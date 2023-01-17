Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF6670E37
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAQXxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjAQXwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:52:03 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C79C3C06;
        Tue, 17 Jan 2023 15:05:18 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-15f64f2791dso3394544fac.7;
        Tue, 17 Jan 2023 15:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=4AE2HZs9Ij2bBJhhAjrwEjzLChQl9bR57MnvWzA7x6U=;
        b=DW8ifSPAga42dfR5FsmeN7ktP7xrF85FXw0C/+Pm5lDatitnt6M1CQj7M2iuNxfpn/
         8Lqyqdz46gcYI65b7HEV2rZB0b9w18a0Vu2j5uxJKOihSIilp5BJI4J3to3fBGZBSOAg
         qKZTbOqyIEM6sy28abPqdGt+yArW2Z23B5BMGrPIlI9/cDODcnnJxtAxcNyDFXPVHMXf
         R48P+80RHdZ3pZH8azCzarSBYjkryNQm8JI66tMAqXqouswoKpLIWF/td2aT/9AEdW3K
         k98TjNYTCV9B45cWKs661R8TJB1gnbsipfyvYuHwtR9zJJna1byThoO89hC/942uN+q5
         JvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AE2HZs9Ij2bBJhhAjrwEjzLChQl9bR57MnvWzA7x6U=;
        b=ogHjxdw00pH0qCHxnMLOIltJ8mCiNnU8fNmWeTnGvigU1FH8jkLdHPZQnaB/Fd4ChI
         SifxelPWB5EeYHTMSukqZ/46ZsxDldDR6R9TllqiZuW5OiQHq5XPdBaDsUnp7vkNUhKL
         yxHRIg/OtjIg6MRi1GUup/h7RZkb+Vzen2aWcKcyj/7tQM/BKayN/hMH7BEbghR9PZCB
         d8YkJll5S70FWYpjo0mXJWRH1HQr9pOvhjIg37ISkbPjxrWL2uSa01ndzD6A1y0HNQak
         VZW2oMKaUD2t6YVj+8osHAFxKetb5Juan78c1SLrCXy5sXZBTjglphOFUT0M7r1warR3
         f21A==
X-Gm-Message-State: AFqh2kqzkwhCoWttu0aDFYnd7dc/dPDMZ9YAT8rw3IVZ4VfBsWXQKT68
        Tf5IPqvpLCIPXhloVistR3jg/3wBgNw=
X-Google-Smtp-Source: AMrXdXtHuS2LexOqaSnPiZkh1ICiW0LO3fAy28p2lWPRYUg8JIB1z86k++pUvGweLF5SJ5SaQKIaNA==
X-Received: by 2002:a05:6870:5386:b0:15f:385c:720c with SMTP id h6-20020a056870538600b0015f385c720cmr3233662oan.30.1673996717252;
        Tue, 17 Jan 2023 15:05:17 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cm18-20020a056870b61200b0012b298699dbsm17151555oab.1.2023.01.17.15.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 15:05:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c9ce648e-e63e-8a47-03c6-7c7e30d8dbc7@roeck-us.net>
Date:   Tue, 17 Jan 2023 15:05:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: remove arch/sh
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Landley <rob@landley.net>
Cc:     Christoph Hellwig <hch@lst.de>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
References: <20230113062339.1909087-1-hch@lst.de>
 <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de>
 <9325a949-8d19-435a-50bd-9ebe0a432012@landley.net>
 <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/23 12:26, Geert Uytterhoeven wrote:
> Hi Rob,
> 
> On Tue, Jan 17, 2023 at 8:01 PM Rob Landley <rob@landley.net> wrote:
>> On 1/16/23 01:13, Christoph Hellwig wrote:
>>> On Fri, Jan 13, 2023 at 09:09:52AM +0100, John Paul Adrian Glaubitz wrote:
>>>> I'm still maintaining and using this port in Debian.
>>>>
>>>> It's a bit disappointing that people keep hammering on it. It works fine for me.
>>>
>>> What platforms do you (or your users) use it on?
>>
>> 3 j-core boards, two sh4 boards (the sh7760 one I patched the kernel of), and an
>> sh4 emulator.
>>
>> I have multiple j-core systems (sh2 compatible with extensions, nommu, 3
>> different kinds of boards running it here). There's an existing mmu version of
>> j-core that's sh3 flavored but they want to redo it so it hasn't been publicly
>> released yet, I have yet to get that to run Linux because the mmu code would
>> need adapting, but the most recent customer projects were on the existing nommu
>> SOC, as was last year's ASIC work via sky130.
> 
> J4 still vaporware?
> 
>> My physical sh4 boards are a Johnson Controls N40 (sh7760 chipset) and the
>> little blue one is... sh4a I think? (It can run the same userspace, I haven't
>> replaced that board's kernel since I got it, I think it's the type Glaubitz is
>> using? It's mostly in case he had an issue I couldn't reproduce on different
>> hardware, or if I spill something on my N40.)
>>
>> I also have a physical sh2 board on the shelf which I haven't touched in years
>> (used to comparison test during j2 development, and then the j2 boards replaced it).
>>
>> I'm lazy and mostly test each new sh4 build under qemu -M r2d because it's
>> really convenient: neither of my physical boards boot from SD card so replacing
>> the kernel requires reflashing soldered in flash. (They'll net mount userspace
>> but I haven't gotten either bootloader to net-boot a kernel.)
> 
> On my landisk (with boots from CompactFLASH), I boot the original 2.6.22
> kernel, and use kexec to boot-test each and every renesas-drivers
> release.  Note that this requires both the original 2.6.22 kernel
> and matching kexec-tools.  Apparently both upstreamed kernel and
> kexec-tools support for SH are different, and incompatible with each
> other, so you cannot kexec from a contemporary kernel.
> I tried working my way up from 2.6.22, but gave up around 2.6.29.
> Probably I should do this with r2d and qemu instead ;-)
> 
> Both r2d and landisk are SH7751.
> 
> Probably SH7722/'23'24 (e.g. Migo-R and Ecovec boards) are also
> worth keeping.  Most on-SoC blocks have drivers with DT support,
> as they are shared with ARM.  So the hardest part is clock and
> interrupt-controller support.
> Unfortunately I no longer have access to the (remote) Migo-R.
> 

Since there are people around with real hardware .... is sh in big endian mode
(sheb) real ? Its qemu support is quite limited; most PCI devices don't work
due to endianness issues. It would be interesting to know if this works better
with real hardware.

Thanks,
Guenter

