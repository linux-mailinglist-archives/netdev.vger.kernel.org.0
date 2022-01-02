Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CB5482CA8
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 21:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiABUMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 15:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiABUMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 15:12:45 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1B5C061761;
        Sun,  2 Jan 2022 12:12:44 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id j11so69405832lfg.3;
        Sun, 02 Jan 2022 12:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J6ekuq2pMzK/C+td0TqNztQHRujSMVkioAz6VuQ9qnw=;
        b=kOQSp+WEAevZWUcVz/soT0LPYNjTDJoFfCp5Q3t6ngGUlYcIiOGiuoNjS48u0JwQ90
         hnOBSqpl1JhAbF6Cf5tJLw1CzCd/ZBKQlmV4xAWcQ43XQvFTQuOqLt5jsMerN9AtK5YQ
         mkTzPTU/3ZIXdmIFhel12GY0YqTO+aZ54ZPozrq4Lq3NKh3nujZ03Qqb0VduxTKd4Inc
         obpOaHIHyuP7sOYVxjd0f2g+sCvgaTvykdfNeDKR7sWY20H5IMkHH667QeqoVj93MuJ8
         HczhwX8HSGVpf3rtsKBtwC5kp6Eop3h3cI7MWad031NlUSM3qtSpGGwQcVm0chOFzHWi
         QPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J6ekuq2pMzK/C+td0TqNztQHRujSMVkioAz6VuQ9qnw=;
        b=QQ1oWHY/1stp6pCPZWv498/kncsATlW/8nhnF7vrGvhPFKYeArJhIzM5oMLq53yR/2
         Cfe8NxwTeMGUZwcIxlMyplYsj6MNNL68unYZncKxknQWF8DYzp/rnrKBZQA2KNaUT8fi
         e0X3elvmYreW5shrPrhesoMzwUL5E9q9fHCYUu46SJW/rtVGwVpGRRr2QDMcp8uU8Q/h
         CYc1txpqVl7huLWQMtdU20uyG8ruZkVh2lfuui8OcO0hNMugm3MD6ibbJ/uJMK+ywPcM
         dEhc2yOdkvPNJ1Z5ClUJAdkpPdcfC3rrVdIAoqAiII63TLbUSBX16Dssd6SizWXx/L+s
         SLPA==
X-Gm-Message-State: AOAM533+d8VXzrorn8LQtaQzxqZz7NsF/CFiUbn/u8hgjmnigOvNtOGv
        SE7I410FZmMeQPTlE152GZI=
X-Google-Smtp-Source: ABdhPJwUHRr1tfjmtZh2XM+y62JHtGcWJvwkZ/OHZPSK0pSyvkv40wKp3K/LZUx9rAfCRbf7sj19mA==
X-Received: by 2002:a05:6512:1149:: with SMTP id m9mr38205299lfg.679.1641154363265;
        Sun, 02 Jan 2022 12:12:43 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id bi1sm3192665lfb.248.2022.01.02.12.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 12:12:42 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
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
        Wright Feng <wright.feng@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <c79d67af-2d4c-2c9d-bb7d-630faf9de175@gmail.com>
 <f35bed9b-aefd-cdf1-500f-194d5699cffd@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <cc3d020f-8f5c-7e6d-d6fc-27d133c87609@gmail.com>
Date:   Sun, 2 Jan 2022 23:12:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f35bed9b-aefd-cdf1-500f-194d5699cffd@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

02.01.2022 17:25, Hector Martin пишет:
> On 2022/01/02 16:08, Dmitry Osipenko wrote:
>> 26.12.2021 18:35, Hector Martin пишет:
>>> +static void brcm_free_alt_fw_paths(const char **alt_paths)
>>> +{
>>> +	int i;
>>> +
>>> +	if (!alt_paths)
>>> +		return;
>>> +
>>> +	for (i = 0; alt_paths[i]; i++)
>>> +		kfree(alt_paths[i]);
>>> +
>>> +	kfree(alt_paths);
>>>  }
>>>  
>>>  static int brcmf_fw_request_firmware(const struct firmware **fw,
>>>  				     struct brcmf_fw *fwctx)
>>>  {
>>>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>>> -	int ret;
>>> +	int ret, i;
>>>  
>>>  	/* Files can be board-specific, first try a board-specific path */
>>>  	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
>>> -		char *alt_path;
>>> +		const char **alt_paths = brcm_alt_fw_paths(cur->path, fwctx);
>>>  
>>> -		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
>>> -		if (!alt_path)
>>> +		if (!alt_paths)
>>>  			goto fallback;
>>>  
>>> -		ret = request_firmware(fw, alt_path, fwctx->dev);
>>> -		kfree(alt_path);
>>> -		if (ret == 0)
>>> -			return ret;
>>> +		for (i = 0; alt_paths[i]; i++) {
>>> +			ret = firmware_request_nowarn(fw, alt_paths[i], fwctx->dev);
>>> +			if (ret == 0) {
>>> +				brcm_free_alt_fw_paths(alt_paths);
>>> +				return ret;
>>> +			}
>>> +		}
>>> +		brcm_free_alt_fw_paths(alt_paths);
>>>  	}
>>>  
>>>  fallback:
>>> @@ -641,6 +663,9 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>>>  	struct brcmf_fw *fwctx = ctx;
>>>  	int ret;
>>>  
>>> +	brcm_free_alt_fw_paths(fwctx->alt_paths);
>>> +	fwctx->alt_paths = NULL;
>>
>> It looks suspicious that fwctx->alt_paths isn't zero'ed by other code
>> paths. The brcm_free_alt_fw_paths() should take fwctx for the argument
>> and fwctx->alt_paths should be set to NULL there.
> 
> There are multiple code paths for alt_paths; the initial firmware lookup
> uses fwctx->alt_paths, and once we know the firmware load succeeded we
> use blocking firmware requests for NVRAM/CLM/etc and those do not use
> the fwctx member, but rather just keep alt_paths in function scope
> (brcmf_fw_request_firmware). You're right that there was a rebase SNAFU
> there though, I'll compile test each patch before sending v2. Sorry
> about that. In this series the code should build again by patch #6.
> 
> Are you thinking of any particular code paths? As far as I saw when
> writing this, brcmf_fw_request_done() should always get called whether
> things succeed or fail. There are no other code paths that free
> fwctx->alt_paths.

It should be okay in the particular case then. But this is not obvious
without taking a closer look at the code, which is a sign that there is
some room for improvement.

>> On the other hand, I'd change the **alt_paths to a fixed-size array.
>> This should simplify the code, making it easier to follow and maintain.
>>
>> -	const char **alt_paths;
>> +	char *alt_paths[BRCM_MAX_ALT_FW_PATHS];
>>
>> Then you also won't need to NULL-terminate the array, which is a common
>> source of bugs in kernel.
> 
> That sounds reasonable, it'll certainly make the code simpler. I'll do
> that for v2.

Feel free to CC me on v2. I'll take a closer look and give a test to the
patches on older hardware, checking for regressions.

