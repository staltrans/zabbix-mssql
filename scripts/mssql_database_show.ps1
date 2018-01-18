# Задаем переменные для подключение к MSSQL. $uid и $pwd нужны для проверки подлинности windows / We define the variables for connecting to MS SQL. $uid и $pwd need to authenticate windows
$SQLServer = 127.0.0.1
#$uid = "" 
#$pwd = ""

# Создаем подключение к MSSQL / Create a connection to MSSQL

# Если проверка подлинности windows / If windows authentication
#$connectionString = "Server = $SQLServer; User ID = $uid; Password = $pwd;"

# Если Интегрированная проверка подлинности / If integrated authentication
$connectionString = "Server = $SQLServer; Integrated Security = True;"

$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# Создаем запрос непосредственно к MSSQL / Create a request directly to MSSQL
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand  
$SqlCmd.CommandText = "SELECT * FROM sysdatabases"
$SqlCmd.Connection = $Connection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) > $null
$Connection.Close()

# Получили список баз. Записываем в переменную. / We get a list of databases. Write to the variable.
$baselist = $DataSet.Tables[0]

$data = @()

foreach ($item in $baselist) {
    $data += @{
       "{#MSSQL_DATABASE_NAME}" = $item.name;
       "{#MSSQL_DATABASE_ID}" = $item.dbid;
       "{#MSSQL_DATABASE_MODE}" = $item.mode;
       "{#MSSQL_DATABASE_STAUTS}" = $item.status;
       "{#MSSQL_DATABASE_STAUTS2}" = $item.status2;
       "{#MSSQL_DATABASE_CRDATE}" = $item.crdate.ToString("s");
       "{#MSSQL_DATABASE_RESERVED}" = $item.reserved.ToString("s");
       "{#MSSQL_DATABASE_CATEGOTY}" = $item.category;
       "{#MSSQL_DATABASE_CMPTLEVEL}" = $item.cmptlevel;
       "{#MSSQL_DATABASE_FILENAME}" = $item.filename;
       "{#MSSQL_DATABASE_VERSION}" = $item.version;
    }
}

@{data = $data} | ConvertTo-Json -Compress