Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3040816F
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhILU3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbhILU3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 16:29:50 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CA4C061574;
        Sun, 12 Sep 2021 13:28:36 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id q11-20020a9d4b0b000000b0051acbdb2869so10509886otf.2;
        Sun, 12 Sep 2021 13:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AXSxIvFJqTwiufjYo/D6s+CkMzPMpGZ/GlVxsFHvRNA=;
        b=Q2WdxlOeY/qzPh2YwGGttsdCkzkxMQWwy7h0b8hpSJHAHJdc7mJzXYZEknKviVTv2A
         D3co9DESFaNB1suY1HUJ8JIZUWr2nYh2P6sRRjejKeWqLuoC5qsKANE1i8LsJIZDJcmq
         HvMtSDNIfEr64W0EWW3H4yxq4VzP7eh2JT4tV+akN5Jaxcmb+tVq+6X92PJCM8c6G8vi
         XMv7rKFO8DcfArnvi3JOSOjA+CBiS0ChiXvX6NN9hp9TmsA/CLWfsIuC0LFuKKN/DXII
         lT5pJ/otTNTX6SZhY3rkfw7LOwyu/BijLRvQ+PTsLxTFG5KtazRVUQMtrNcSo5zVauMT
         rzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AXSxIvFJqTwiufjYo/D6s+CkMzPMpGZ/GlVxsFHvRNA=;
        b=J4RBwJQ+iLqJtpkZVuQowB7Ep93lLLW7R2xYZmIbJh5Lauxmt+l6XBzzlwDMv7ZQyy
         JMW9Mrlf0MIFBqYCxin5cKIdF4Kqj1voK+0r4UlUAXGQ1+zIU5Xi4HTESEE1GEHdmslb
         Ie2JgVSstUZUo+JYl7eJT9VohqQeEI8OE828R0KpYjeJk0aUwPuy3vxsNnC8khyhlxWr
         z19g01HQkFlJICD5LC9QQuQgWV8lJRlibzd92g976ljqVdPgmX9B2pBYqTsAtfMEIZzk
         vaJkKaZwRgB+K+h0jEVBSV+mIWTtbGLhMtFwMXjHubW4rIMs3qN+4+fB6nkqRewPfw+c
         8OvA==
X-Gm-Message-State: AOAM530602+2mMuU1WajW9a5sUbF7qSMPIexD/GEWldaATsg3C4jrBSw
        mTQR91NtdIR+G5gItM8ljHmv8owPOHc=
X-Google-Smtp-Source: ABdhPJxuFvecmPM2TZMockYIjqnp4xZdl21Ekd9EkR06uk2o6zhz+UuSEZrSpVHXNCjbELp04zmBiA==
X-Received: by 2002:a9d:4b84:: with SMTP id k4mr6669955otf.98.1631478515438;
        Sun, 12 Sep 2021 13:28:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r20sm1338260oot.16.2021.09.12.13.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 13:28:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Helge Deller <deller@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
References: <20210912160149.2227137-1-linux@roeck-us.net>
 <20210912160149.2227137-4-linux@roeck-us.net>
 <CAHk-=wi1TBvyk7SWX+5LLYN8ZnTJMut1keQbOrKCG=nb08hdiQ@mail.gmail.com>
 <YT5b2HgrvL12Nrhx@ls3530>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 3/4] parisc: Use absolute_pointer for memcmp on fixed
 memory location
Message-ID: <2702f518-da2f-5bca-11d3-35f5cd4316e6@roeck-us.net>
Date:   Sun, 12 Sep 2021 13:28:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YT5b2HgrvL12Nrhx@ls3530>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/21 12:58 PM, Helge Deller wrote:
> * Linus Torvalds <torvalds@linux-foundation.org>:
>> On Sun, Sep 12, 2021 at 9:02 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> -       running_on_qemu = (memcmp(&PAGE0->pad0, "SeaBIOS", 8) == 0);
>>> +       running_on_qemu = (memcmp(absolute_pointer(&PAGE0->pad0), "SeaBIOS", 8) == 0);
>>
>> This seems entirely the wrong thing to do, and makes no sense. That
>> "&PAGE0->pad0" is a perfectly valid pointer, and that's not where the
>> problem is.
>>
>> The problem is "PAGE0" itself:
>>
>>      #define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
>>
>> which takes that absolute offset and creates a pointer out of it.
>>
>> IOW, _that_ is what should have the "absolute_pointer()" thing, and in
>> that context the name of that macro and its use actually makes sense.
>>
>> No?
>>
>> An alternative - and possibly cleaner - approach that doesn't need
>> absolute_pointer() at all might be to just do
>>
>>          extern struct zeropage PAGE0;
>>
>> and then make that PAGE0 be defined to __PAGE_OFFSET in the parisc
>> vmlinux.lds.S file.
>>
>> Then doing things like
>>
>>          running_on_qemu = !memcmp(&PAGE0.pad0, "SeaBIOS", 8);
>>
>> would JustWork(tm).
> 
> Yes, this second approach seems to work nicely, although the patch
> then gets slightly bigger.
> Below is a tested patch.
> I'll check it some further and apply it to the parisc tree then.
> 

There are several PAGE0-> references left in the code after applying your patch.

$ git grep "PAGE0->"
arch/parisc/kernel/firmware.c:  if (!PAGE0->mem_kbd.iodc_io)
arch/parisc/kernel/firmware.c:  real32_call(PAGE0->mem_kbd.iodc_io,
arch/parisc/kernel/firmware.c:              (unsigned long)PAGE0->mem_kbd.hpa, ENTRY_IO_CIN,
arch/parisc/kernel/firmware.c:              PAGE0->mem_kbd.spa, __pa(PAGE0->mem_kbd.dp.layers),
arch/parisc/kernel/smp.c:       WARN_ON(((unsigned long)(PAGE0->mem_pdc_hi) << 32
arch/parisc/kernel/smp.c:                       | PAGE0->mem_pdc) != pdce_proc);

After fixing those, I can build a parisc image and boot it in qemu (32 bit).

Guenter
