Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F9440C6F2
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 16:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237602AbhIOOEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 10:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbhIOOEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 10:04:50 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F9EC061574;
        Wed, 15 Sep 2021 07:03:31 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id q26-20020a4adc5a000000b002918a69c8eeso904251oov.13;
        Wed, 15 Sep 2021 07:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dXV0TdJQZj6j+f/Hi7EIzy0MEGNbxXGsvCh8JJLlODg=;
        b=WPi3IOT8Z+un52mSPLE4sfqcvjdnW6YB61L3883DmVLJCseKT0/X5+UxUhOCmGoe6Z
         HIGh4/nwJMlyK+3dCdARsx7O83eqW0mxZ8VZ0aedkBHAaEN7l82Gy6kEnotJu0yF+MU+
         5a+7S37ulW2eIr6nSMyrGUZyXeMv3h4t8ZlzhCuIPCpxyX7J/TepZavW275hbZyhW2Gk
         YOa17FQn9TO4Gk7XgljwpYzkzDT+C2SZhOQvgqFsx4nDUuzNklzbH8Hgi4XLuqrfB5c3
         eMXBKePg1BOAfA5WW84beOgutATln1NmsNbVFEakI6+C4NMzrKEuxWlWU4otT5aApJjU
         fABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dXV0TdJQZj6j+f/Hi7EIzy0MEGNbxXGsvCh8JJLlODg=;
        b=lf/lxhHvy3JK2aJPkgydBUsoemjtuR+KI0105Nupx/NpGuVu7JvyzM8/6S6qSTxVBm
         +IiG59FHPSbr5em/T4oTXqk6LBm04h14aYmPlOEHC0QCXiARbVnBi54Ah9N7C5XwwhEd
         CPibysbq7N3TpOWbnKoHZBKlEL0/G7F9VNYeOhJXuub9kImyENfMwi5g1XRdUOomDNsH
         d2E0N4ZizxQ+mCZBzsmskqsIaFaPkbTB02/c1kPr//p3EOz9cWQxbQs7iB+UEIBzvnKj
         k+DvayEBKGAlHWj5N5whcl1QED2WexNkOcANgzEWnwgJ8qZ8vIreD+ltgXUi6kkTOJBo
         5S7g==
X-Gm-Message-State: AOAM531e8Bm3hWyaq8pqa1iIqIRKjkdExRXGL08OFZjzUTRAiM9P5rO/
        uWN1KPgVr65ZW0dDMfcLbTaQwFxSQ0s=
X-Google-Smtp-Source: ABdhPJxZWw0J/8Mllmga07N63Y8sT9KQNPV3ZJtz3dgQOrFH3hdHQmv0ainu2VlCw9qtyk8srn1muQ==
X-Received: by 2002:a05:6820:555:: with SMTP id n21mr18699324ooj.56.1631714609412;
        Wed, 15 Sep 2021 07:03:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v16sm11201oou.45.2021.09.15.07.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 07:03:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v2 1/4] compiler.h: Introduce absolute_pointer macro
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-sparse@vger.kernel.org
References: <20210915035227.630204-1-linux@roeck-us.net>
 <20210915035227.630204-2-linux@roeck-us.net>
 <CAMuHMdXZcrjGAE5OOipKsYpEgk9AZ_hrWKh+v81FMBtQTBv2LA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ab67dccf-cf29-523d-3cf7-7554c493dcd1@roeck-us.net>
Date:   Wed, 15 Sep 2021 07:03:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXZcrjGAE5OOipKsYpEgk9AZ_hrWKh+v81FMBtQTBv2LA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/21 12:13 AM, Geert Uytterhoeven wrote:
> Hi Günter,
> 
> On Wed, Sep 15, 2021 at 5:52 AM Guenter Roeck <linux@roeck-us.net> wrote:
>> absolute_pointer() disassociates a pointer from its originating symbol
>> type and context. Use it to prevent compiler warnings/errors such as
>>
>> drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
>> ./arch/m68k/include/asm/string.h:72:25: error:
>>          '__builtin_memcpy' reading 6 bytes from a region of size 0
>>                  [-Werror=stringop-overread]
>>
>> Such warnings may be reported by gcc 11.x for string and memory operations
>> on fixed addresses.
>>
>> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v2: No change
>>
>>   include/linux/compiler.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
>> index b67261a1e3e9..3d5af56337bd 100644
>> --- a/include/linux/compiler.h
>> +++ b/include/linux/compiler.h
>> @@ -188,6 +188,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>>       (typeof(ptr)) (__ptr + (off)); })
>>   #endif
>>
>> +#define absolute_pointer(val)  RELOC_HIDE((void *)(val), 0)
> 
> I guess we're not worried about "val" being evaluated multiple
> times inside RELOC_HIDE(), as this is mainly intended for constants?
> 

No, we are not. It is quite similar to RELOC_HIDE() in that regard.

Guenter
