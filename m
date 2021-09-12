Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2D407E83
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhILQR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILQRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:17:25 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490D1C061574;
        Sun, 12 Sep 2021 09:16:11 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id m11-20020a056820034b00b0028bb60b551fso2528920ooe.5;
        Sun, 12 Sep 2021 09:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=962m9V5kVB1K2ya/iSo41D4jBqvuxZ4BddEpQ3+kojg=;
        b=qM8u+hcIWzR8wMKQYhJCILmC9ZSlNy0NiWb4OY9hgIPBCZHgvM5qkKfgYvGPan/dWy
         i5x/cft2ji93PA3JkhyD3LSkkMTIFc1uT4DGD0JuOsR6E7i+5w/QvbVTzSvWiBYtyvcb
         ZwYQUAi0m60L2obsafgIs5DFtPB2dd11dxVqbdEuSt/wuCLZHR0w3rdAEg1ctjNwuBpV
         FygbmW10nIEchgjXTB7XhMDbK3jxBDIHD8N01nOt0gxXTRXQC0Bkc0ayrYtjpe7vo5Lt
         +tN2mV7Mu8coJuhIwpThaEPRcsMbFlXaxkMDf6YDj+oodAYc/UODDI+YBc3E3yvWM4cI
         srpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=962m9V5kVB1K2ya/iSo41D4jBqvuxZ4BddEpQ3+kojg=;
        b=iCniXSU9P38GdOq+2FxnKjSZuCFrpKRv68Dd/yVOS+t40A21B1IMZGh9QGOMRKapTS
         XOEgPTxLZmLLd4pUAgcXp72Zm+UpVrz6xXgTydWHG7Hf0xmPhaW2piM8IwpwJAKcIxg+
         lm9Y1WG7kWVhtaou0rDkFmnuXcioJeRHofdHRtTaWo6ODBxXFUMDCmPFQIIoiPFrXqvj
         kbbANwgheDDbfPZ2ljH7Ctp0hmW9LYAxiDfd9TCzVjM3qJyqmeKsFUg3rA3ITZ+jXjg1
         HLN23CDb1mET0EeOjFUbkpLNFpb9AxpEclNWLz4bTxol5kaQtilX65m39M0z5CFZoEwR
         SVMA==
X-Gm-Message-State: AOAM5315musOhvwSYrRhjTtx9SB2kJNjoBRMhXrq/0UcyCAeqVX8KmGV
        qeSYoCTu9LLUHKpdSxjz5tJEXzDPEE4=
X-Google-Smtp-Source: ABdhPJzidRP3p6tQgWcre2x9ZhW/ZGNmxMG6SrrOt4xx2vFDvzYw3xFVcpEZpIPpeYjjtBJSrwFLow==
X-Received: by 2002:a4a:98e1:: with SMTP id b30mr6093453ooj.34.1631463370452;
        Sun, 12 Sep 2021 09:16:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8sm1202188otd.76.2021.09.12.09.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 09:16:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 2/4] net: i825xx: Use absolute_pointer for memcpy on fixed
 memory location
To:     Jeroen Roovers <jer@xs4all.nl>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-alpha@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, linux-sparse@vger.kernel.org
References: <20210912160149.2227137-1-linux@roeck-us.net>
 <20210912160149.2227137-3-linux@roeck-us.net>
 <20210912181148.60f147c8@wim.jer>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <0d118e7b-e3cf-67df-00dc-f85b40ada682@roeck-us.net>
Date:   Sun, 12 Sep 2021 09:16:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210912181148.60f147c8@wim.jer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/21 9:11 AM, Jeroen Roovers wrote:
> On Sun, 12 Sep 2021 09:01:47 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
>> gcc 11.x reports the following compiler warning/error.
>>
>> drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
>>      ./arch/m68k/include/asm/string.h:72:25: error:
>>              '__builtin_memcpy' reading 6 bytes from a region of size 0
>>                      [-Werror=stringop-overread]
>>
>> Use absolute_address() to work around the problem.
> 
> => absolute_pointer()
> 

Oopsie. Thanks!

Guenter

>> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/net/ethernet/i825xx/82596.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/i825xx/82596.c
>> b/drivers/net/ethernet/i825xx/82596.c index
>> b8a40146b895..b482f6f633bd 100644 ---
>> a/drivers/net/ethernet/i825xx/82596.c +++
>> b/drivers/net/ethernet/i825xx/82596.c @@ -1144,7 +1144,7 @@ static
>> struct net_device * __init i82596_probe(void) err = -ENODEV;
>>   			goto out;
>>   		}
>> -		memcpy(eth_addr, (void *) 0xfffc1f2c,
>> ETH_ALEN);	/* YUCK! Get addr from NOVRAM */
>> +		memcpy(eth_addr, absolute_pointer(0xfffc1f2c),
>> ETH_ALEN); /* YUCK! Get addr from NOVRAM */ dev->base_addr =
>> MVME_I596_BASE; dev->irq = (unsigned) MVME16x_IRQ_I596;
>>   		goto found;
> 
> 
> Regards,
>        jer
> 

