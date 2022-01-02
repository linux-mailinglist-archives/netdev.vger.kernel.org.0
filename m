Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D02482A7A
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 08:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiABHUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 02:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiABHUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 02:20:43 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86287C061574;
        Sat,  1 Jan 2022 23:20:42 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id h15so37796434ljh.12;
        Sat, 01 Jan 2022 23:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wygtrmPrIcz8i0paHqUL5GkSGBjvsBiEY6wm7+ulaec=;
        b=HbPf8FzVFP44Fcl9nKWjpfS9tTcuwGy2aSkdZ2TiRVQU+f6s+aYHFybZlkKjEXzwBT
         6UWne5eyeDZrsrwz6S2K3cmM368+cDT/1/eAztL4C463bNu+4x+ywyfhyAocYBAaI7+0
         C9s3xsR/XpWj2oSXz2cQwQSKnrKKXpS9hZFarJmr21R23wKLDSdZqhF//iQW3adkdRlF
         JqX78E4DSTR8YDupc2D+x5O2dYMIalNby0ND3+KOo2WEsYxqSchoA/StNBXvAoE0s9Lt
         Wp0t2KGFBb9JRTAHXl7hQZf7kE8ETpCu2FyROUngGFBw+fDqMIJLHAvjr+xNE10Guao6
         hdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wygtrmPrIcz8i0paHqUL5GkSGBjvsBiEY6wm7+ulaec=;
        b=Luer4A5gF/A1dxKYC0JNi64n5R8/8545vnvHYpLZ9+DotVX7o8i9FQhq8AtJiVU6da
         iFWlChQZi/Td+r/zq382P189otlH+XtUZp92FjeL0zTjN0aitPkT8si28QHrX/+1VbHV
         Jh29FY6ZilgGo4B4rdxneHT8lNdEBf9uvbygA3ZLk1Qk0cbgt3TMEco4ud4TzrxOKKsJ
         Y/Jb54moJuPDbu0bFVoUDYhWmEd5yQ94yTVtbBTY0qETkIj+rGMugp8y+GJH1PrmchKG
         5wx9MPlLO03LluvcmhDHOTo+OYCEz5vPfT4//pudzIFVl6pNCgpbbFlZQp9UPaMGimXo
         EgzA==
X-Gm-Message-State: AOAM530507UChFlfbfqjYutUTPfbsw6QZ9RduY5ZLMs0CbfED7wyKZN2
        1ttN61/QPyHr9UPvgmRxrSs=
X-Google-Smtp-Source: ABdhPJybPZO6/p7tlkGMKGTRgin9OYNaVRwxSnNMCUQ+c1aTAZotEsgHfD+DdLK59Q1WLTpQ++zUrQ==
X-Received: by 2002:a2e:b818:: with SMTP id u24mr26727559ljo.426.1641108040757;
        Sat, 01 Jan 2022 23:20:40 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id p29sm3265772lfa.27.2022.01.01.23.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 23:20:40 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <c79d67af-2d4c-2c9d-bb7d-630faf9de175@gmail.com>
Message-ID: <32eacaf1-77e7-3299-0d62-0248334ccfa2@gmail.com>
Date:   Sun, 2 Jan 2022 10:20:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c79d67af-2d4c-2c9d-bb7d-630faf9de175@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

02.01.2022 10:08, Dmitry Osipenko пишет:
> 26.12.2021 18:35, Hector Martin пишет:
>> +static void brcm_free_alt_fw_paths(const char **alt_paths)
>> +{
>> +	int i;
>> +
>> +	if (!alt_paths)
>> +		return;
>> +
>> +	for (i = 0; alt_paths[i]; i++)
>> +		kfree(alt_paths[i]);
>> +
>> +	kfree(alt_paths);
>>  }
>>  
>>  static int brcmf_fw_request_firmware(const struct firmware **fw,
>>  				     struct brcmf_fw *fwctx)
>>  {
>>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>> -	int ret;
>> +	int ret, i;
>>  
>>  	/* Files can be board-specific, first try a board-specific path */
>>  	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
>> -		char *alt_path;
>> +		const char **alt_paths = brcm_alt_fw_paths(cur->path, fwctx);
>>  
>> -		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
>> -		if (!alt_path)
>> +		if (!alt_paths)
>>  			goto fallback;
>>  
>> -		ret = request_firmware(fw, alt_path, fwctx->dev);
>> -		kfree(alt_path);
>> -		if (ret == 0)
>> -			return ret;
>> +		for (i = 0; alt_paths[i]; i++) {
>> +			ret = firmware_request_nowarn(fw, alt_paths[i], fwctx->dev);
>> +			if (ret == 0) {
>> +				brcm_free_alt_fw_paths(alt_paths);
>> +				return ret;
>> +			}
>> +		}
>> +		brcm_free_alt_fw_paths(alt_paths);
>>  	}
>>  
>>  fallback:
>> @@ -641,6 +663,9 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>>  	struct brcmf_fw *fwctx = ctx;
>>  	int ret;
>>  
>> +	brcm_free_alt_fw_paths(fwctx->alt_paths);
>> +	fwctx->alt_paths = NULL;
> 
> It looks suspicious that fwctx->alt_paths isn't zero'ed by other code
> paths. The brcm_free_alt_fw_paths() should take fwctx for the argument
> and fwctx->alt_paths should be set to NULL there.
> 
> On the other hand, I'd change the **alt_paths to a fixed-size array.
> This should simplify the code, making it easier to follow and maintain.
> 
> -	const char **alt_paths;
> +	char *alt_paths[BRCM_MAX_ALT_FW_PATHS];

Although, the const should be kept.

const char *alt_paths[BRCM_MAX_ALT_FW_PATHS];

> 
> Then you also won't need to NULL-terminate the array, which is a common
> source of bugs in kernel.
> 

