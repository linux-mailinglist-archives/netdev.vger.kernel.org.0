Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84261670A90
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 23:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjAQWBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 17:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjAQV7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:59:42 -0500
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2343C2A3;
        Tue, 17 Jan 2023 12:26:42 -0800 (PST)
Received: by mail-vs1-f49.google.com with SMTP id v127so29141213vsb.12;
        Tue, 17 Jan 2023 12:26:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7rC0mNjXax5vqLz2OAo+EH0y+cJfjyIAm7sm9u5PvgQ=;
        b=Yr9F31/7vLwBOZRKZ1DOhx7lv+07U9yCPU3kfK3htjNZou2RGjuLkdqwCn8yKk9eF3
         GnyyMHiW3JgbPuw6+FCnbxXOm2pXbKR74ChWnRn/hHl+9by/VHS5XtgOFtV5OVc06ddw
         LnzBWPfOsBT9fqwpqly0JUq8dnwIcMSuesyYy1KvIo27t7NfN87fYlhZwyNhgxs4TcFk
         9BF4fB6bXw5YhS8+79SPrAO36Q1UAWE6lQ/eDxVYm9AGrYBuapnXFFs/g4Y/d3/65nEM
         cNY+emfDCxLCn/w9cVLEEICPn6d8+Q4pdwHu1n/gCrT2Kr8MUafwGrFjLQWyaGQ2cHdv
         bY8g==
X-Gm-Message-State: AFqh2kqzy6dBVKRzPngOGJhrF0YAVXXu3mDkVZ//3HfOKs6E0G/PoFSo
        ZhqezYlyMbvP27SJixa4hW2wxfnjUsABHg==
X-Google-Smtp-Source: AMrXdXv8xG+OngFJXkL1EyBOzdj+k3Oc3D+zm5NnPdBiJa4B+CPjVzuCM17G+lAG+3CcyHApPWniCQ==
X-Received: by 2002:a67:c116:0:b0:3b1:23bb:3087 with SMTP id d22-20020a67c116000000b003b123bb3087mr2147820vsj.26.1673987201149;
        Tue, 17 Jan 2023 12:26:41 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id q22-20020a05620a2a5600b0070638ad5986sm7355016qkp.85.2023.01.17.12.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 12:26:40 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id o75so35606650yba.2;
        Tue, 17 Jan 2023 12:26:39 -0800 (PST)
X-Received: by 2002:a25:9012:0:b0:7b8:a0b8:f7ec with SMTP id
 s18-20020a259012000000b007b8a0b8f7ecmr707665ybl.36.1673987199250; Tue, 17 Jan
 2023 12:26:39 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de> <9325a949-8d19-435a-50bd-9ebe0a432012@landley.net>
In-Reply-To: <9325a949-8d19-435a-50bd-9ebe0a432012@landley.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 17 Jan 2023 21:26:27 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com>
Message-ID: <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com>
Subject: Re: remove arch/sh
To:     Rob Landley <rob@landley.net>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, Jan 17, 2023 at 8:01 PM Rob Landley <rob@landley.net> wrote:
> On 1/16/23 01:13, Christoph Hellwig wrote:
> > On Fri, Jan 13, 2023 at 09:09:52AM +0100, John Paul Adrian Glaubitz wrote:
> >> I'm still maintaining and using this port in Debian.
> >>
> >> It's a bit disappointing that people keep hammering on it. It works fine for me.
> >
> > What platforms do you (or your users) use it on?
>
> 3 j-core boards, two sh4 boards (the sh7760 one I patched the kernel of), and an
> sh4 emulator.
>
> I have multiple j-core systems (sh2 compatible with extensions, nommu, 3
> different kinds of boards running it here). There's an existing mmu version of
> j-core that's sh3 flavored but they want to redo it so it hasn't been publicly
> released yet, I have yet to get that to run Linux because the mmu code would
> need adapting, but the most recent customer projects were on the existing nommu
> SOC, as was last year's ASIC work via sky130.

J4 still vaporware?

> My physical sh4 boards are a Johnson Controls N40 (sh7760 chipset) and the
> little blue one is... sh4a I think? (It can run the same userspace, I haven't
> replaced that board's kernel since I got it, I think it's the type Glaubitz is
> using? It's mostly in case he had an issue I couldn't reproduce on different
> hardware, or if I spill something on my N40.)
>
> I also have a physical sh2 board on the shelf which I haven't touched in years
> (used to comparison test during j2 development, and then the j2 boards replaced it).
>
> I'm lazy and mostly test each new sh4 build under qemu -M r2d because it's
> really convenient: neither of my physical boards boot from SD card so replacing
> the kernel requires reflashing soldered in flash. (They'll net mount userspace
> but I haven't gotten either bootloader to net-boot a kernel.)

On my landisk (with boots from CompactFLASH), I boot the original 2.6.22
kernel, and use kexec to boot-test each and every renesas-drivers
release.  Note that this requires both the original 2.6.22 kernel
and matching kexec-tools.  Apparently both upstreamed kernel and
kexec-tools support for SH are different, and incompatible with each
other, so you cannot kexec from a contemporary kernel.
I tried working my way up from 2.6.22, but gave up around 2.6.29.
Probably I should do this with r2d and qemu instead ;-)

Both r2d and landisk are SH7751.

Probably SH7722/'23'24 (e.g. Migo-R and Ecovec boards) are also
worth keeping.  Most on-SoC blocks have drivers with DT support,
as they are shared with ARM.  So the hardest part is clock and
interrupt-controller support.
Unfortunately I no longer have access to the (remote) Migo-R.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
