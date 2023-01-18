Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40C8671642
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjARI1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjARI0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:26:04 -0500
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990695B44F;
        Tue, 17 Jan 2023 23:53:12 -0800 (PST)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-15085b8a2f7so34666426fac.2;
        Tue, 17 Jan 2023 23:53:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ckf5E8d0Cnw+micSJ5vxd9QO1KFnhxODfDAqVKF2Q0k=;
        b=61XkuxeqbcHeN75KAIqN0uUIqXmdph5hqhUkIGSxuNJx5qSVY7Qe7agxlT1qiDrlxw
         3kFFuSGU7Ttng175jPprkNzEj8Q31rAb/iKxlhsOuJm2rU94rdTGk7G9QabfsXqG/OmN
         vdv/BnPWlZFAFFvbbuAcTnw3q6uwVKBQMkA8/tIS6GTpMvJ6Zui8/BjnIgOlOD1eAIUf
         AnKxZF6pWIGReX8L5rf8vNToN1w0VnYFfBM8Ly+7EjvN3VgOJ6SzYiHtM3GhnsOu/4bA
         1PB/3YuJ7+xQjZF5hpdLVaFg3aDYh1mVnzwq0DU4HqO02Xxb/ZIxlDIwGySTi7Sk8xnI
         G+BQ==
X-Gm-Message-State: AFqh2kpHI3jkAmTMFlBlHF71M7xU47YrSDzBu0sdApxrIOTb9DZDWDPb
        vpcHzqLiV9kOxxWmg4iwt5u6+O+qXdkoYg==
X-Google-Smtp-Source: AMrXdXv3HFvK0+bsQSmlhDxPYltMz33ZUPx1/VWAZsq50xvNYmaqoTLM2jLuhz36OLbrGzbjDA2hIQ==
X-Received: by 2002:a05:6870:b4a5:b0:158:910:8956 with SMTP id y37-20020a056870b4a500b0015809108956mr3548325oap.54.1674028391734;
        Tue, 17 Jan 2023 23:53:11 -0800 (PST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id v12-20020a056870b50c00b0014fc049fc0asm18147690oap.57.2023.01.17.23.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 23:53:11 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id k44-20020a9d19af000000b00683e176ab01so19217997otk.13;
        Tue, 17 Jan 2023 23:53:11 -0800 (PST)
X-Received: by 2002:a81:bd6:0:b0:48d:1334:6e38 with SMTP id
 205-20020a810bd6000000b0048d13346e38mr726842ywl.316.1674028030903; Tue, 17
 Jan 2023 23:47:10 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de> <9325a949-8d19-435a-50bd-9ebe0a432012@landley.net>
 <CAMuHMdUJm5QvzH8hvqwvn9O6qSbzNOapabjw5nh9DJd0F55Zdg@mail.gmail.com> <7329212f-b1a0-41eb-99b3-a56eb1d23138@landley.net>
In-Reply-To: <7329212f-b1a0-41eb-99b3-a56eb1d23138@landley.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 Jan 2023 08:46:58 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXo3iR2C=CAaXO5tBRCncnQAAMR6BMPLOm_nBpFAeVhrA@mail.gmail.com>
Message-ID: <CAMuHMdXo3iR2C=CAaXO5tBRCncnQAAMR6BMPLOm_nBpFAeVhrA@mail.gmail.com>
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

On Wed, Jan 18, 2023 at 5:50 AM Rob Landley <rob@landley.net> wrote:
> On 1/17/23 14:26, Geert Uytterhoeven wrote:
> > On Tue, Jan 17, 2023 at 8:01 PM Rob Landley <rob@landley.net> wrote:
> >> I'm lazy and mostly test each new sh4 build under qemu -M r2d because it's
> >> really convenient: neither of my physical boards boot from SD card so replacing
> >> the kernel requires reflashing soldered in flash. (They'll net mount userspace
> >> but I haven't gotten either bootloader to net-boot a kernel.)
> >
> > On my landisk (with boots from CompactFLASH), I boot the original 2.6.22
> > kernel, and use kexec to boot-test each and every renesas-drivers
> > release.  Note that this requires both the original 2.6.22 kernel
> > and matching kexec-tools.
>
> I make it a point to run _current_ kernels in all my mkroot systems, including
> sh4. What I shipped was 6.1 is:
>
> # cat /proc/version
> Linux version 6.1.0 (landley@driftwood) (sh4-linux-musl-cc (GCC) 9.4.0, GNU ld
> (GNU Binutils) 2.33.1) #1 Tue Jan 10 16:32:07 CST 2023

I think you misunderstood: renesas-drivers releases[1] are current
kernels.

   Linux version 6.2.0-rc3-landisk-01864-g0c6453b3e5f6 (geert@rox)
(sh4-linux-gnu-gcc (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0, GNU ld (GNU
Binutils for Ubuntu) 2.38) #125 Tue Jan 10 14:29:01 CET 2023

I use 2.6.22 and kexec as a boot loader for newer kernels, to avoid
juggling CF cards.  I cannot install a newer base kernel on the CF,
as kexec is broken upstream.

> > Apparently both upstreamed kernel and
> > kexec-tools support for SH are different, and incompatible with each
> > other, so you cannot kexec from a contemporary kernel.
>
> Sure you can. Using toybox's insmod and modprobe, anyway. (That's the target I
> tested those on... :)
>
> Haven't messed with signing or compression or anything yet, my insmod is just
> doing syscall(SYS_finit_module) and then falling back to SYS_init_module if that
> fails and either fd was 0 or errno was ENOSYS. (Don't ask me why
> SYS_finit_module doesn't work on stdin...)
>
> https://github.com/landley/toybox/blob/master/toys/other/insmod.c#L31
>
> https://landley.net/toybox/downloads/binaries/0.8.9/toybox-sh4

Again, I think you're talking about something different.
Does kexec work for you?

> > I tried working my way up from 2.6.22, but gave up around 2.6.29.
> > Probably I should do this with r2d and qemu instead ;-)
>
> I have current running there. I've had current running there for years. Config
> attached...
>
> > Both r2d and landisk are SH7751.
>
> Cool. Shouldn't be hard to get landisk running current then.

Current kernels work fine on landisk with an old Debian userspace
on CF.  The 8139cp driver is a bit flaky: last time I tried nfsroot,
that didn't work well.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
