Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA66690FD
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbjAMIbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjAMIbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:31:02 -0500
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E963475E;
        Fri, 13 Jan 2023 00:31:00 -0800 (PST)
Received: by mail-qv1-f49.google.com with SMTP id m12so12337393qvt.9;
        Fri, 13 Jan 2023 00:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5kunZU7S+tV+EkJ89PAjAGhUsATazsdxcPmCZjz3Piw=;
        b=DKmoTyZpgcisWwY9aULfp9dnQ73JqgJM1GTJtpR0xUMr0hgau91VhcJba7uWR3aclm
         6LhLH7VNMqUGuTRjcc2mSkI030lGGGlpL9iZaRySvlGn6IvnJvZj+zuusGskNyfa8w29
         c9fihAn0Z27EBr57vjD+virkIX48mWoBlLuvHJ0oayO4O7cI4uHtcmWBtFAf4+AtTHZP
         /ZIaG/VgAKHtWLYUlfpckRsnLpkQIMIoDqYu8VstXG4niyRsSuR0eU/KE6Ce97GKy+wD
         FuE02LUTLR1/0ZTm6JsPokjFkjAIbOYiI/lMi2b1ewnqToEm0dDtg4qdl9qHfPViGpYG
         G82A==
X-Gm-Message-State: AFqh2kqysm8UeyxG2wH9Dq7Gwf0HrWrYVEN1+iBViv0XuZ90d9wdYolt
        yrQ2aetkOq33TqgqKnPFPsiCkjpEygH89w==
X-Google-Smtp-Source: AMrXdXvrdlzils4PIV+x9oUEu4NP/tQFHl1qd5GpsMvkkPHzKk9DMmv2m1LNeMOE/7umd4UQEhXSfQ==
X-Received: by 2002:a05:6214:108c:b0:534:723d:fe72 with SMTP id o12-20020a056214108c00b00534723dfe72mr5160861qvr.6.1673598659822;
        Fri, 13 Jan 2023 00:30:59 -0800 (PST)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id y15-20020a05620a0e0f00b006f7ee901674sm12243994qkm.2.2023.01.13.00.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:30:59 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-4d13cb4bbffso154395747b3.3;
        Fri, 13 Jan 2023 00:30:58 -0800 (PST)
X-Received: by 2002:a05:690c:313:b0:37e:6806:a5f9 with SMTP id
 bg19-20020a05690c031300b0037e6806a5f9mr3492728ywb.47.1673598658639; Fri, 13
 Jan 2023 00:30:58 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-12-hch@lst.de>
In-Reply-To: <20230113062339.1909087-12-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 13 Jan 2023 09:30:47 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXYt4dNHUDsTnPa-RP+sdK=35nNa9xQzMChwK54qO44mA@mail.gmail.com>
Message-ID: <CAMuHMdXYt4dNHUDsTnPa-RP+sdK=35nNa9xQzMChwK54qO44mA@mail.gmail.com>
Subject: Re: [PATCH 11/22] mtd/nand: remove sh_flctl
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
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
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
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
>  drivers/mtd/nand/raw/Kconfig    |    8 -
>  drivers/mtd/nand/raw/Makefile   |    1 -
>  drivers/mtd/nand/raw/sh_flctl.c | 1234 -------------------------------
>  include/linux/mtd/sh_flctl.h    |  180 -----
>  4 files changed, 1423 deletions(-)
>  delete mode 100644 drivers/mtd/nand/raw/sh_flctl.c
>  delete mode 100644 include/linux/mtd/sh_flctl.h
>
> diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
> index 98ea1c9e65c8ef..20a4988ea418d5 100644
> --- a/drivers/mtd/nand/raw/Kconfig
> +++ b/drivers/mtd/nand/raw/Kconfig
> @@ -284,14 +284,6 @@ config MTD_NAND_MXC
>           This enables the driver for the NAND flash controller on the
>           MXC processors.
>
> -config MTD_NAND_SH_FLCTL
> -       tristate "Renesas SuperH FLCTL NAND controller"
> -       depends on SUPERH || COMPILE_TEST
> -       depends on HAS_IOMEM
> -       help
> -         Several Renesas SuperH CPU has FLCTL. This option enables support
> -         for NAND Flash using FLCTL.

FTR, this hardware block is also present on the ARM-based
SH-Mobile AG5 and R-Mobile A1 SoCs.
Again, no DT support.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
