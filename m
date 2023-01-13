Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBA06690E1
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbjAMI3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241020AbjAMI2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:28:33 -0500
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B976ECAC;
        Fri, 13 Jan 2023 00:28:21 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id a25so11389750qto.10;
        Fri, 13 Jan 2023 00:28:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LXxq4tFDMaQ+gaSI4+XgAKyMbRpnWTuq4SxaohX01OI=;
        b=Zk8m3aeddIzAMK2UNfhmhm0/Wm8OIIhZYBwQaPtu0S+IKbi1Rrc8Cpmex3mBojmRLu
         obsujJGGqkamu0SQKP2/zFvixUGcW2xBhKEfxZuVpRoI3UKyzEKkpH45W/8P066uVTk1
         wp5YLPmDUNxPdRNzPPiSWPVKJEkNcb5T5CDLqutgrORyIxGt4ay9I+wq9engghHValdR
         X3bXMn09deVnyzq4vZtXFT50qJpEq+jbdXM2DVd1JKwFOiLVG1DBi0R4emtK3HM4373n
         EcgXUWCtKReuNNOOCGKsHoO+vMhZWH6bmId/Jd9BSgvk4eAS4eiR+3w4eOiMtvydRy4q
         u6rw==
X-Gm-Message-State: AFqh2krlYrmTbhSSKl0+2OCtmmSjkMbpB/BmzuA0WQ8Eo8i1C8It6h9B
        6ueJ3B8mXtItgkAkw8L68blo5Je8FouG5g==
X-Google-Smtp-Source: AMrXdXtlbL5v2Ep7FxIvbuIP58vhDouwZKGNsuXxlv0wG/mVjf69s0dBcBE79U09q1L7/p1RVTi7sg==
X-Received: by 2002:a05:622a:4c08:b0:3a7:f599:9c6c with SMTP id ey8-20020a05622a4c0800b003a7f5999c6cmr114240498qtb.26.1673598500878;
        Fri, 13 Jan 2023 00:28:20 -0800 (PST)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id bq11-20020a05620a468b00b0070209239b87sm12226602qkb.41.2023.01.13.00.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:28:19 -0800 (PST)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-4d59d518505so105680107b3.1;
        Fri, 13 Jan 2023 00:28:19 -0800 (PST)
X-Received: by 2002:a0d:fb81:0:b0:480:fa10:459e with SMTP id
 l123-20020a0dfb81000000b00480fa10459emr889474ywf.283.1673598499239; Fri, 13
 Jan 2023 00:28:19 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-11-hch@lst.de>
In-Reply-To: <20230113062339.1909087-11-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 13 Jan 2023 09:28:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVLT5G7spdbkB=sx6ZZraXzNFgENxLwg1PMrFnVERn_Tw@mail.gmail.com>
Message-ID: <CAMuHMdVLT5G7spdbkB=sx6ZZraXzNFgENxLwg1PMrFnVERn_Tw@mail.gmail.com>
Subject: Re: [PATCH 10/22] input: remove sh_keysc
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
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
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 7:24 AM Christoph Hellwig <hch@lst.de> wrote:
> Now that arch/sh is removed this driver is dead code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/input/keyboard/Kconfig    |  10 -
>  drivers/input/keyboard/Makefile   |   1 -
>  drivers/input/keyboard/sh_keysc.c | 334 ------------------------------
>  3 files changed, 345 deletions(-)
>  delete mode 100644 drivers/input/keyboard/sh_keysc.c
>
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 84490915ae4d5a..882ec5fef214ac 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -625,16 +625,6 @@ config KEYBOARD_SUNKBD
>           To compile this driver as a module, choose M here: the
>           module will be called sunkbd.
>
> -config KEYBOARD_SH_KEYSC
> -       tristate "SuperH KEYSC keypad support"
> -       depends on ARCH_SHMOBILE || COMPILE_TEST
> -       help
> -         Say Y here if you want to use a keypad attached to the KEYSC block
> -         on SuperH processors such as sh7722 and sh7343.

FTR, this hardware block is also present on the ARM-based
SH-Mobile AG5, and R-Mobile A1 and APE6 SoCs.
Again, no DT support.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
