Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F1947C7E5
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhLUUAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLUUAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 15:00:24 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6CBC061574;
        Tue, 21 Dec 2021 12:00:23 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id u13so206537lff.12;
        Tue, 21 Dec 2021 12:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=43/2Mezhuf3WWJTy/6w8lAncDvzXAj2g4OEisA/QoPc=;
        b=e/7PubARU7NoVPBABUvhADa8uENBdfgxs0KNkTxtBzHkr1YeMWO7EUGNuF4s259YmN
         MdkRmTIpeXu88h2ODoTcQO1MZWSc4wbNu/A9qZi7zx/nXY/7KOxNx0S4FRnjnNmnUmgT
         JoMtNgW4NWCl/8v1vAcldb1U9hSbPzFWsLbYZJdCy+zoYfmqVFDHvPyi0Kp/0TVraMzE
         tyuqQSHYpXkW9eVxEIlbRl+njcvFAaMXhTAUf86qHaM+JoqWdh+DgisjpDNWlgaK7vpd
         +mZvfOoYq5qIw/FMrPltdDEyxIsOVYLYeQKIKQTja/IA0R39CdEPn6kkYde3A5DMbHS7
         ZV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=43/2Mezhuf3WWJTy/6w8lAncDvzXAj2g4OEisA/QoPc=;
        b=zO9aXlt90MyX++L+Hn3y5mwwc8GVmG6Y+nD0boCu6sxWTbSu28VMYLP8ZI+osVg8Z9
         uBWMeXgPFmoQeoYBWZIm/VLqGtaI4Gt2NBFbALWwtDXp9L3LkKCOXK7JUlPxp0RCVWdN
         FJ2f4uqzEkggGr/lafdBUFclQeRtLwFAmq2B2uk8pLx7Tl+kcmRS9EcaYUOPI5eDA8bM
         N+iOd/VdxaWS92/v9AUwSopJIM3HMLxghgmrHPzYM+Oc5SFqcFRZgdRSBGY83RNvQ3mD
         1r9dRk6CVpWAHcbyoyrC0iMfQy62lxpxrpzLc0y2Z6ajI20tja3cvTmfNkdLPpvdEbmF
         JMZQ==
X-Gm-Message-State: AOAM531AuHtyUsm2VHQJUnRcDKZNFqJkvahzxSjuNgyiuPeJlI/qVwSH
        clfkGByarQrRGgTog2vXTkU=
X-Google-Smtp-Source: ABdhPJwU/zRSU/yagVXc2QJ/i0oPGRhcT51zXVjPnhW5k1d5fA28rs9Yv5Z+akpOtx/5ySQjSoUz0A==
X-Received: by 2002:ac2:5a45:: with SMTP id r5mr4324253lfn.547.1640116822111;
        Tue, 21 Dec 2021 12:00:22 -0800 (PST)
Received: from [192.168.1.11] ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id bd28sm2822051ljb.134.2021.12.21.12.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 12:00:21 -0800 (PST)
Message-ID: <65ff1752-f60e-a3b3-2a5f-a7f0b9c97f36@gmail.com>
Date:   Tue, 21 Dec 2021 23:00:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] asix: fix wrong return value in
 asix_check_host_enable()
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        robert.foss@collabora.com, freddy@asix.com.tw,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <bd6a7e1779ba97a300650e8e23b69ecffb3b4236.1640115493.git.paskripkin@gmail.com>
 <989915c5f8887e4a0281ed87325277aa8c997291.1640115493.git.paskripkin@gmail.com>
 <YcIulPIwii+7OOzT@lunn.ch>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <YcIulPIwii+7OOzT@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/21 22:44, Andrew Lunn wrote:
> On Tue, Dec 21, 2021 at 10:40:05PM +0300, Pavel Skripkin wrote:
>> If asix_read_cmd() returns 0 on 30th interation, 0 will be returned from
>> asix_check_host_enable(), which is logically wrong. Fix it by returning
>> -ETIMEDOUT explicitly if we have exceeded 30 iterations
>> 
>> Fixes: a786e3195d6a ("net: asix: fix uninit value bugs")
>> Reported-by: Andrew Lunn <andrew@lunn.ch>
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>>  drivers/net/usb/asix_common.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
>> index 06823d7141b6..8c61d410a123 100644
>> --- a/drivers/net/usb/asix_common.c
>> +++ b/drivers/net/usb/asix_common.c
>> @@ -83,7 +83,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
>>  			break;
>>  	}
>>  
>> -	return ret;
>> +	return i >= 30? -ETIMEDOUT: ret;
> 
> I think the coding style guidelines would recommend a space before the ?
> 

Ah, yes, I forgot to run chechpatch on 2nd one, sorry. Will fix in v2

> I would also replace the 30 with a #define, both here and in the for
> loop.

Will fix in v2 as well. Thanks for review!



With regards,
Pavel Skripkin
