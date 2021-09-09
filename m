Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E10D405B23
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 18:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhIIQpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 12:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbhIIQpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 12:45:16 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D905C061767;
        Thu,  9 Sep 2021 09:44:07 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso3290075otp.1;
        Thu, 09 Sep 2021 09:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N33tNDE983KFwzlOPCn9woI2Z+VdOff5TDBckNp3U9Q=;
        b=iP+z647fLsud8UrzxAwWm4ioiHRr0rdv+dTMbUjK9HT/xKLLGLSWTP5lqyOfSr0Qdi
         GrH+UZie0L6S+P6HSuR3bEXjM3/bea48sXaOa0kLd300aOEqJd045QHT33dpn/rI/rJj
         xteptZW14fUEj8OLM6ejvijvgZFTCM4XJW0qljtvcpfzMY4ptR9jxW1trJna+Jsr7SM9
         oWqemVqmZORbYYkKXa177dkxR13LsADm6DmKRoXtFI7PxyZN8LP+5WbWkGIH8lNgNASJ
         jQeiwmOQoj6HHODJB/wd7yqGRDsdJUGDiIOqMi+LJyKFuOJXGi39YmdZHODWsXLgZvXr
         QoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N33tNDE983KFwzlOPCn9woI2Z+VdOff5TDBckNp3U9Q=;
        b=iZfvPpo0Uj9L9y1j2bC1KzOCAjlhi2gf6TNQQ8mglqrnBAi6NmDEoSwDBaiRdSW9aA
         1pwg2CUEyKzUzomaHBGvJ1+3/w/e0yBOERhMCZLmSFdE1QfWYTr5ogH/6bFkoMdJXjl3
         Nl97JeeqJMXc7bmkXEwXJL8er+p+4Zj2TcZNSx5xTleLVxgFXvZ8E2bEb6R+nCh5abpH
         nVNNz5PAC+r0slhs9xrQj0Nv9e9tc5+Sn3L3rmjPrptVvqYGBRKtjTyteI7VLh9cjcg+
         7JmhK5IJzlgR20/aGw/+/jEmzQwwo1fVg2rxvNJ4I0qD8pxEG6OMcJJwMQOL8nCWHCLM
         aBmQ==
X-Gm-Message-State: AOAM53220pkMhuIjRv6cqMpUjuJZKyIAfNn5ykaPzPfjUgDIn+D8NkUQ
        NPItOChlj2gf1VVi0xcQPVLF5Pq6V30=
X-Google-Smtp-Source: ABdhPJywGYdmWMj6VK/Nd5t9DDrFvruXPcLntzXEkaYiBjGzvGPEzi/yNEYqOQBVQB4zsKneYA4Bsw==
X-Received: by 2002:a9d:7ccc:: with SMTP id r12mr688426otn.350.1631205846387;
        Thu, 09 Sep 2021 09:44:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c3sm525651oiy.30.2021.09.09.09.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 09:44:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     ajk@comnets.uni-bremen.de, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210909035743.1247042-1-linux@roeck-us.net>
 <20210909.123442.1648633411296774237.davem@davemloft.net>
 <751f5079-2da1-187e-573c-d7d2d6743bbf@roeck-us.net>
 <20210909.162721.1267526781289116670.davem@davemloft.net>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] net: 6pack: Fix tx timeout and slot time
Message-ID: <aaa2d05e-cdbd-f80c-d85f-1ee92e7a7946@roeck-us.net>
Date:   Thu, 9 Sep 2021 09:44:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210909.162721.1267526781289116670.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/21 8:27 AM, David Miller wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Thu, 9 Sep 2021 07:53:29 -0700
> 
>> On 9/9/21 4:34 AM, David Miller wrote:
>>> From: Guenter Roeck <linux@roeck-us.net>
>>> Date: Wed,  8 Sep 2021 20:57:43 -0700
>>>
>>>> tx timeout and slot time are currently specified in units of HZ.
>>>> On Alpha, HZ is defined as 1024. When building alpha:allmodconfig,
>>>> this results in the following error message.
>>>>
>>>> drivers/net/hamradio/6pack.c: In function 'sixpack_open':
>>>> drivers/net/hamradio/6pack.c:71:41: error:
>>>> 	unsigned conversion from 'int' to 'unsigned char'
>>>> 	changes value from '256' to '0'
>>>>
>>>> In the 6PACK protocol, tx timeout is specified in units of 10 ms
>>>> and transmitted over the wire. Defining a value dependent on HZ
>>>> doesn't really make sense. Assume that the intent was to set tx
>>>> timeout and slot time based on a HZ value of 100 and use constants
>>>> instead of values depending on HZ for SIXP_TXDELAY and SIXP_SLOTTIME.
>>>>
>>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>>> ---
>>>> No idea if this is correct or even makes sense. Compile tested only.
>>> These are timer offsets so they have to me HZ based.  Better to make
>>> the
>>> structure members unsigned long, I think.
>>>
>>
>> Hmm, ok. Both tx_delay and slottime are updated in sp_encaps(),
>> though,
>> from data in the transmit buffer. The KISS protocol description states
>> that the values are in units of 10ms; that is where my assumption
>> came from.
> 
> They are ms and must be converted using to HZ in order to use the values as timer offsets.
> 
> The values are perfectly fine, the types used to store them need to be fixed.
> 
>> Anyway, I am inclined to just mark the protocol as dependent on
>> !ALPHA. Would you accept that ?
> 
> No, fix this properly.  Make the unsigfned char members be unsigned long.
> 
> Why do you not want to fix it this way?
> 

All I want is to get alpha:allmodconfig to compile, nothing else,
but at the same time I don't want to introduce new bugs.

If I make tx_delay unsigned long, it is still passed to encode_sixpack()
as parameter, and that parameter is declared unsigned char and put into
a byte sized buffer. If the value is 0x100, it will then be truncated to
0x0, only that is then done silently without generating a compile error.
Sure, that fixes the compile error, but not the underlying issue. Maybe
that truncation is perfectly fine, but I don't understand the code well
enough to make that call.

Never mind, I'll let someone else who has a better understanding of the code
deal with this.

Guenter
