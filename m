Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619876691AC
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbjAMIup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbjAMIuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:50:40 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A71BE15;
        Fri, 13 Jan 2023 00:50:38 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id x7so8478998qtv.13;
        Fri, 13 Jan 2023 00:50:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=awQakUOIwVvp4xWgkhRGNM/c58rzqkM16qYt20+qNyU=;
        b=LdBKwIE65Xc5+S3l/5mDqKHA2P8SUEqQIOnsbYpMywwqnDqFY0lkFDJkXX/cIXQjZR
         pvFlIninVlhM68lOF+WnZQIGH+bCZ3mUJacSgywdXw82ZmdLukkgl5BI4Fhs0C3RdMTa
         DFnoQD6q9omk00w9Q9OQPVHU8EWSf5ynnoTYKHp+7j7KBCoiP6+dUa3bWLxXM03cYuoh
         pOli7zKMeq8zShzR6KcgnAhLCRCCSgcWSwlUdHCs3q7t5aB6qGTizXPm/Qf0Kx/BYSds
         iRPnm3T0O7KdYIe2lmY0EpK9rnJ5DArgkQXuRvw7rMWAIKo/u+yVPb0LcmI3OvgKmRmA
         C+gw==
X-Gm-Message-State: AFqh2koZzvGMnxRroWNbNaBMk3h56j+PEyPDZzq9M4j9KgNI08MKGz9i
        C9WqMazmZRz2/IXbzmIitfSjVipTzoU3oQ==
X-Google-Smtp-Source: AMrXdXsh82ByrARJ6E7dHhXPkYGb7WEUe3JCC1zvVotjwXOax+oMJT4z83kkR8VKQEa1B+tMBTaYlw==
X-Received: by 2002:a05:622a:1927:b0:3a7:ec54:cfa2 with SMTP id w39-20020a05622a192700b003a7ec54cfa2mr107329191qtc.56.1673599837567;
        Fri, 13 Jan 2023 00:50:37 -0800 (PST)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id he34-20020a05622a602200b00399fe4aac3esm5656349qtb.50.2023.01.13.00.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:50:36 -0800 (PST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-4b6255ce5baso274713027b3.11;
        Fri, 13 Jan 2023 00:50:36 -0800 (PST)
X-Received: by 2002:a81:578e:0:b0:4d9:3858:392 with SMTP id
 l136-20020a81578e000000b004d938580392mr551266ywb.502.1673599835999; Fri, 13
 Jan 2023 00:50:35 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-17-hch@lst.de>
In-Reply-To: <20230113062339.1909087-17-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 13 Jan 2023 09:50:24 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU2vaVaCrcKom5YQYD9GLoeerX8HAQav36uFGUksOFc9w@mail.gmail.com>
Message-ID: <CAMuHMdU2vaVaCrcKom5YQYD9GLoeerX8HAQav36uFGUksOFc9w@mail.gmail.com>
Subject: Re: [PATCH 16/22] spi: remove spi-sh-sci
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
>  drivers/spi/Kconfig      |   7 --
>  drivers/spi/Makefile     |   1 -
>  drivers/spi/spi-sh-sci.c | 197 ---------------------------------------
>  3 files changed, 205 deletions(-)
>  delete mode 100644 drivers/spi/spi-sh-sci.c
>
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 7508dcef909c78..76f3bc6f8c81fc 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -882,13 +882,6 @@ config SPI_SH_MSIOF
>         help
>           SPI driver for SuperH and SH Mobile MSIOF blocks.
>
> -config SPI_SH_SCI
> -       tristate "SuperH SCI SPI controller"
> -       depends on SUPERH
> -       select SPI_BITBANG
> -       help
> -         SPI driver for SuperH SCI blocks.

This driver uses the Serial Communications Interface (SCI, cfr.
drivers/tty/serial/sh-sci.c) in SPI mode. Hence in theory it could be
used on a variety of Renesas ARM SoCs, and even on RZ/Five.
Again, no DT support.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
