Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476B853D6B4
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 14:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiFDMOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 08:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiFDMOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 08:14:24 -0400
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73BC1C923;
        Sat,  4 Jun 2022 05:14:22 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id e184so18033002ybf.8;
        Sat, 04 Jun 2022 05:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boxdhvDiMWyFpyyHCYcMSN/PMwteqk8YIeu/9YG1GME=;
        b=dYylsk2XH+ELQeCei/qciNsqfuRBDsrrTkwZo9MzP7mBWceUemia22JnILaojxV6uo
         ifPjnEhe+tDU+ZGlCZV69iunfb5hmBRt49ZOIfO35TQXszAiASK1Sn61ufPvb7fTj8u/
         9Z0/AEx7MqlL7jvc6m5JvIiA1M47rbo81D9NU4qDOF2ILkLmWHA+AG+hczQmyCr3jMm9
         EppNAAacOroqZIDrA73hNihTI9MBdOvQnWgiiGmhUothLmdjaFBtQQdmeBX/qWCqBzEj
         tN6wUhRXvcUUnTZ/g7KxMbVthD7Ne4WPn1CUyAucugWuBj/qXYGgo7ZkHoDinibZXpED
         vcuw==
X-Gm-Message-State: AOAM531PzveUiDNMTuizBJxIupnxoCIJE0j5BY1/dXB7eQwf21euvmhx
        Dkatu+OVtzpNJ13oLa56+suv4JJmuGDU9VRjP8I=
X-Google-Smtp-Source: ABdhPJzUJ1prs/N8KlS25MFDQbdL1UU5LSRr8qXyz8KbVjhYq0zp1d0vPqelAsC74XdtWkDYX2ql+G2oa1Ahw3V/roY=
X-Received: by 2002:a25:b846:0:b0:65d:1cb0:e444 with SMTP id
 b6-20020a25b846000000b0065d1cb0e444mr14985060ybm.20.1654344862032; Sat, 04
 Jun 2022 05:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220603102848.17907-5-mailhol.vincent@wanadoo.fr>
 <20220604112227.nlyxulkxelgofruz@pengutronix.de>
In-Reply-To: <20220604112227.nlyxulkxelgofruz@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 4 Jun 2022 21:14:10 +0900
Message-ID: <CAMZ6RqLRb_n+o2eFLEzn8Er7CyaZd8Q7B3=5e4Z5d0PJHKywAg@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 4 June 2022 at 20:22, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 03.06.2022 19:28:45, Vincent Mailhol wrote:
> > Only a few drivers rely on the CAN rx offload framework (as of the
> > writing of this patch, only three: flexcan, ti_hecc and
> > mcp251xfd). Give the option to the user to deselect this features
> > during compilation.
> >
> > The drivers relying on CAN rx offload are in different sub
> > folders. All of these drivers get tagged with "select CAN_RX_OFFLOAD"
> > so that the option is automatically enabled whenever one of those
> > driver is chosen.
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >  drivers/net/can/Kconfig               | 16 ++++++++++++++++
> >  drivers/net/can/dev/Makefile          |  2 ++
> >  drivers/net/can/spi/mcp251xfd/Kconfig |  1 +
> >  3 files changed, 19 insertions(+)
> >
> > diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> > index 8f3b97aea638..1f1d81da1c8c 100644
> > --- a/drivers/net/can/Kconfig
> > +++ b/drivers/net/can/Kconfig
> > @@ -102,6 +102,20 @@ config CAN_CALC_BITTIMING
> >
> >         If unsure, say Y.
> >
> > +config CAN_RX_OFFLOAD
> > +     bool "CAN RX offload"
> > +     default y
> > +     help
> > +       Framework to offload the controller's RX FIFO during one
> > +       interrupt. The CAN frames of the FIFO are read and put into a skb
> > +       queue during that interrupt and transmitted afterwards in a NAPI
> > +       context.
> > +
> > +       The additional features selected by this option will be added to the
> > +       can-dev module.
> > +
> > +       If unsure, say Y.
> > +
> >  config CAN_AT91
> >       tristate "Atmel AT91 onchip CAN controller"
> >       depends on (ARCH_AT91 || COMPILE_TEST) && HAS_IOMEM
> > @@ -113,6 +127,7 @@ config CAN_FLEXCAN
> >       tristate "Support for Freescale FLEXCAN based chips"
> >       depends on OF || COLDFIRE || COMPILE_TEST
> >       depends on HAS_IOMEM
> > +     select CAN_RX_OFFLOAD
> >       help
> >         Say Y here if you want to support for Freescale FlexCAN.
> >
> > @@ -162,6 +177,7 @@ config CAN_SUN4I
> >  config CAN_TI_HECC
> >       depends on ARM
> >       tristate "TI High End CAN Controller"
> > +     select CAN_RX_OFFLOAD
> >       help
> >         Driver for TI HECC (High End CAN Controller) module found on many
> >         TI devices. The device specifications are available from www.ti.com
> > diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
> > index b8a55b1d90cd..5081d8a3be57 100644
> > --- a/drivers/net/can/dev/Makefile
> > +++ b/drivers/net/can/dev/Makefile
> > @@ -11,3 +11,5 @@ can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
> >  can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Do you want to remove this?

Absolutely. As you probably guessed, this is just a leftover.

> >
> >  can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
> > +
> > +can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
> > diff --git a/drivers/net/can/spi/mcp251xfd/Kconfig b/drivers/net/can/spi/mcp251xfd/Kconfig
> > index dd0fc0a54be1..877e4356010d 100644
> > --- a/drivers/net/can/spi/mcp251xfd/Kconfig
> > +++ b/drivers/net/can/spi/mcp251xfd/Kconfig
> > @@ -2,6 +2,7 @@
> >
> >  config CAN_MCP251XFD
> >       tristate "Microchip MCP251xFD SPI CAN controllers"
> > +     select CAN_RX_OFFLOAD
> >       select REGMAP
> >       select WANT_DEV_COREDUMP
> >       help
>
> I remember I've given you a list of drivers needing RX offload, I
> probably missed the m_can driver. Feel free to squash this patch:

Added it to v5.

This went through the cracks when testing. Thanks for catching this!

> --- a/drivers/net/can/dev/Makefile
> +++ b/drivers/net/can/dev/Makefile
> @@ -8,7 +8,6 @@ can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
>  can-dev-$(CONFIG_CAN_NETLINK) += dev.o
>  can-dev-$(CONFIG_CAN_NETLINK) += length.o
>  can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
> -can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
>
>  can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
>
> diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
> index 45ad1b3f0cd0..fc2afab36279 100644
> --- a/drivers/net/can/m_can/Kconfig
> +++ b/drivers/net/can/m_can/Kconfig
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  menuconfig CAN_M_CAN
>         tristate "Bosch M_CAN support"
> +       select CAN_RX_OFFLOAD
>         help
>           Say Y here if you want support for Bosch M_CAN controller framework.
>           This is common support for devices that embed the Bosch M_CAN IP.
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
