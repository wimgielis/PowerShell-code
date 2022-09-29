$FileExtensions = Read-Host "Enter the desired file extensions, comma-separated (pro,rux,dim,cub or leave empty)"
$TM1Folder = 'D:\test'
$ZipFoldername = ''

# $FileExtension = 'rux'
# $ZipFilename = 'All rules'

    TRY {
		$today = Get-Date -Format "yyyy-MM-dd"

        if ( -not (Test-Path $TM1Folder -PathType Container) ) { Exit }

        # Test if ZipFoldername is empty, then use the same folder as TM1Folder
        if (-Not ($ZipFoldername)) {
            $ZipFoldername = $TM1Folder
        }

		$ArrFileExtensions = $FileExtensions.Split(",")
		foreach ($FileExtension in $ArrFileExtensions) {

			# Get the files collection
			if ($FileExtensions) {
			$TM1SourceFiles = get-childitem -Path $TM1Folder -Recurse -File | Where-Object {$_.fullName -Match $FileExtension + '$'} }
			else {
			$TM1SourceFiles = get-childitem -Path $TM1Folder -Recurse -File }

			# Get the zip filename
			Switch ($FileExtension) {
				'pro' {$ZipFilename = 'All processes'}
				'rux' {$ZipFilename = 'All rules'}
				Default {$ZipFilename = $FileExtension + ' files'}
			}
			$ZipFullFilename = $ZipFoldername + '\' + $ZipFilename + ' (' + $today + ')' + '.zip'
			if (Test-Path $ZipFullFilename) { Remove-Item $ZipFullFilename }

			# Compress the file contents
			$TM1SourceFiles | Compress-Archive -DestinationPath $ZipFullFilename -CompressionLevel NoCompression -Force
		}
    }

    CATCH {
        Write-Error "$($_.Exception.Message)"
        Break
    }

    FINALLY {
    }