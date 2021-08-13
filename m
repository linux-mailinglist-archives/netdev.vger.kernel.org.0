Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F1B3EBE48
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhHMW3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhHMW3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:29:35 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E628C061756;
        Fri, 13 Aug 2021 15:29:08 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id n17so22546104lft.13;
        Fri, 13 Aug 2021 15:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nGHiRfHmrc53lFGsCeLT5fWZ/gcwuMxbfBrAvdKDdeY=;
        b=f6QNQ0tJrL66+L1wjEClV78xcB8ZV9OU30WcUP6/AQkN7LO4qROBuD0Uvdr08vIIVI
         8eJZVpz5OaZ/8YPsBQ1z1jqCrcL/Tx+bawRMJUX6iwy7vANncATBT5ArzJ6YiSaZ/Z/9
         tfUyaG30o6rQHEPVPti0hZC4lcKOcr3grSe5YeCfOaAMJoGqR8woJ/+s3R6DHWHRmiJN
         wrrLkcRErhgiuA6RMUNlNyV3mri1B/uvXXw2R988UfEiI4nmnD+Vq59FGntihda1zq8W
         WjsswcySEVaI3p6VfGciy9UXLj6UgJGisxsLmVVeSrc+oX/+yLKl6/CnWVM24gXK6kSa
         0ldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nGHiRfHmrc53lFGsCeLT5fWZ/gcwuMxbfBrAvdKDdeY=;
        b=jcQe49ptRD5PgeUGvrFG9P4t/fNj9dRKNhY/itLwfenPzk9LLQ/fooNy5aBl9dynVt
         QdPS8LfwQFowa6UTPT/SrEGD76exco43IO3vwBBr7lr/VqsKBtVnwoMJwuiVh9305TPc
         frYewoHlMIHOD9hjBX4oSW5MERdAfPinJdFJW8REcyiKW/QhmGLLOo2TRsNEa8lu+wi7
         guUZ8TR4ur18ZsPnPDxn+pDQVsB8ix65ffJIcsaLr1gfnJNIy6SYZDzKCsk7P15D3NGR
         nd6vcAWvamKPgR0MVe7llLRtcwIDCzYzyejP2i7LseSN4NwxqPYTn8Xf3uL8WUgbSAS5
         0Kcg==
X-Gm-Message-State: AOAM530TKhZr1V27OQYYOUFoDNmomlwgfQsWHH4hFIMjBSMcMa/CDYBo
        J928z+YGZc4zaeZSnnSO8hM=
X-Google-Smtp-Source: ABdhPJzSWZE378GEaISoBHQh853nqaSCbQK2KADWy/YYqDwPj2t1b5cuGf7voa/JfbDRjH+ZlPGqtA==
X-Received: by 2002:a05:6512:1597:: with SMTP id bp23mr3068182lfb.189.1628893746456;
        Fri, 13 Aug 2021 15:29:06 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.59])
        by smtp.gmail.com with ESMTPSA id p10sm311179ljc.135.2021.08.13.15.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 15:29:06 -0700 (PDT)
Subject: Re: [PATCH] net: asix: fix uninit value in asix_mdio_read
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        himadrispandya@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
References: <20210813160108.17534-1-paskripkin@gmail.com>
 <YRbw1psAc8jQu4ob@lunn.ch>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <22130c0e-5966-f76d-5ce1-f92ec4750155@gmail.com>
Date:   Sat, 14 Aug 2021 01:29:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRbw1psAc8jQu4ob@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/21 1:23 AM, Andrew Lunn wrote:
> On Fri, Aug 13, 2021 at 07:01:08PM +0300, Pavel Skripkin wrote:
>> Syzbot reported uninit-value in asix_mdio_read(). The problem was in
>> missing error handling. asix_read_cmd() should initialize passed stack
>> variable smsr, but it can fail in some cases. Then while condidition
>> checks possibly uninit smsr variable.
>> 
>> Since smsr is uninitialized stack variable, driver can misbehave,
>> because smsr will be random in case of asix_read_cmd() failure.
>> Fix it by adding error cheking and just continue the loop instead of
>> checking uninit value.
>> 
>> Fixes: 8a46f665833a ("net: asix: Avoid looping when the device is disconnected")
>> Reported-and-tested-by: syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>>  drivers/net/usb/asix_common.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
>> index ac92bc52a85e..572ca3077f8f 100644
>> --- a/drivers/net/usb/asix_common.c
>> +++ b/drivers/net/usb/asix_common.c
>> @@ -479,7 +479,13 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
>>  		usleep_range(1000, 1100);
>>  		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
>>  				    0, 0, 1, &smsr, 0);
>> -	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
>> +		if (ret == -ENODEV) {
>> +			break;
>> +		} else if (ret < 0) {
>> +			++i;
>> +			continue;
>> +		}
>> +	} while (!(smsr & AX_HOST_EN) && (i++ < 30));
> 
> No ret < 0, don't you end up with a double increment of i? So it will
> only retry 15 times, not 30?
> 
> Humm.
> 
> If ret < 0 is true, smsr is uninitialized? The continue statement
> causes a jump into the condition expression, where we evaluate smsr &
> AX_HOST_EN. Isn't this just as broken as the original version?
> 
>        Andrew
> 

Yes, you are right, I missed that, sorry. I will rewrote this loop into 
for loop in v2.

Im wondering why this wrong patch passed KMSAN testing...



With regards,
Pavel Skripkin
