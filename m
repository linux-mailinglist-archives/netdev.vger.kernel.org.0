Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A98353D6E2
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 14:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbiFDM4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 08:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbiFDM4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 08:56:36 -0400
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F497644;
        Sat,  4 Jun 2022 05:56:35 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-30ec2aa3b6cso105555517b3.11;
        Sat, 04 Jun 2022 05:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6wL6JUMToXUplBBVMpZMqbwmGUUZrNQVr95rlA3s2zM=;
        b=CJ4ZvuGCYdrhnrf3+LNim/h8nBNlWzDBb3DyIS8lg3JU8uPgeraC9P1D7nRhSx/Xpb
         VA/MF759HcCuv2E1Sm5yAXozgVgzBzh/PASvY+dAuiEM/cCP9v91VuKB1N5W+vN8UvhM
         eYLSMkBUG+cZTuoX+bvCFZgvUU07TUmxJBavyGlLkkmJG1fxQDRJ/armTUlY1R/DGRkb
         P6P5n750clwPksnRNUqeBhZ5tRr7m0P182aPu8A8Ha9jbEcHlQ/INjh+aQzEhoWIcgFb
         AZc9FPG2fSSbGbFn4QFORL7kmatUJbwlaqmIAh5G9UEfamWnEFLaYS/f+tIpOibiRzYR
         GWUw==
X-Gm-Message-State: AOAM531GtxNum6m7v9ARCguxMLTlYS84I28We+PxHP5BfgImnGOB/Pyg
        0dhv9dmZQhq2ECwCWbVNRh5aZ8aXCnkGiEHa9CY=
X-Google-Smtp-Source: ABdhPJx+XtX/Mp15f2+lzGaE0H3JTGJ4vzaKH5o9GqOLQlJHeZBH8uQeNUcZGr7Yzsr3kCys9tPc7TSxvsRxrC0by6Y=
X-Received: by 2002:a0d:ee47:0:b0:2ff:85e6:9e03 with SMTP id
 x68-20020a0dee47000000b002ff85e69e03mr16362910ywe.172.1654347394342; Sat, 04
 Jun 2022 05:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr> <20220603102848.17907-4-mailhol.vincent@wanadoo.fr>
 <20220604112538.p4hlzgqnodyvftsj@pengutronix.de> <CAMZ6RqLg_Enyn1h+sn=o8rc8kkR6r=YaygLy40G9D4=Ug_KxOg@mail.gmail.com>
 <20220604124139.pg2h33zanyqs54q5@pengutronix.de>
In-Reply-To: <20220604124139.pg2h33zanyqs54q5@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 4 Jun 2022 21:56:23 +0900
Message-ID: <CAMZ6RqJqSG16fdRE5_uiOmqsDboBgQCanvVNGaG5ZUDwpVoYvA@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] can: bittiming: move bittiming calculation
 functions to calc_bittiming.c
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

On Sat. 4 June 2022 at 21:41, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 04.06.2022 21:21:01, Vincent MAILHOL wrote:
> > On Sat. 4 June 2022 at 20:25, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > > On 03.06.2022 19:28:44, Vincent Mailhol wrote:
> > > > The canonical way to select or deselect an object during compilation
> > > > is to use this pattern in the relevant Makefile:
> > > >
> > > > bar-$(CONFIG_FOO) := foo.o
> > > >
> > > > bittiming.c instead uses some #ifdef CONFIG_CAN_CALC_BITTIMG.
> > > >
> > > > Create a new file named calc_bittiming.c with all the functions which
> > > > are conditionally compiled with CONFIG_CAN_CALC_BITTIMG and modify the
> > > > Makefile according to above pattern.
> > > >
> > > > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > > > ---
> > > >  drivers/net/can/Kconfig              |   4 +
> > > >  drivers/net/can/dev/Makefile         |   2 +
> > > >  drivers/net/can/dev/bittiming.c      | 197 --------------------------
> > > >  drivers/net/can/dev/calc_bittiming.c | 202 +++++++++++++++++++++++++++
> > > >  4 files changed, 208 insertions(+), 197 deletions(-)
> > > >  create mode 100644 drivers/net/can/dev/calc_bittiming.c
> > > >
> > > > diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> > > > index b1e47f6c5586..8f3b97aea638 100644
> > > > --- a/drivers/net/can/Kconfig
> > > > +++ b/drivers/net/can/Kconfig
> > > > @@ -96,6 +96,10 @@ config CAN_CALC_BITTIMING
> > > >         source clock frequencies. Disabling saves some space, but then the
> > > >         bit-timing parameters must be specified directly using the Netlink
> > > >         arguments "tq", "prop_seg", "phase_seg1", "phase_seg2" and "sjw".
> > > > +
> > > > +       The additional features selected by this option will be added to the
> > > > +       can-dev module.
> > > > +
> > > >         If unsure, say Y.
> > > >
> > > >  config CAN_AT91
> > > > diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
> > > > index 919f87e36eed..b8a55b1d90cd 100644
> > > > --- a/drivers/net/can/dev/Makefile
> > > > +++ b/drivers/net/can/dev/Makefile
> > > > @@ -9,3 +9,5 @@ can-dev-$(CONFIG_CAN_NETLINK) += dev.o
> > > >  can-dev-$(CONFIG_CAN_NETLINK) += length.o
> > > >  can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
> > > >  can-dev-$(CONFIG_CAN_NETLINK) += rx-offload.o
> > > > +
> > > > +can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
> > >
> > > Nitpick:
> > > Can we keep this list sorted?
> >
> > My idea was first to group per CONFIG symbol according to the
> > different levels: CAN_DEV first, then CAN_NETLINK and finally
> > CAN_CALC_BITTIMING and CAN_RX_OFFLOAD. And then only sort by
> > alphabetical order within each group.
>
> I was thinking to order by CONFIG symbol and put the objects without an
> additional symbol first
>
> > By sorting the list, do literally mean to sort each line like this:
> >
> > obj-$(CONFIG_CAN_DEV) += can-dev.o
> > can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
> > can-dev-$(CONFIG_CAN_DEV) += skb.o
> > can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
> > can-dev-$(CONFIG_CAN_NETLINK) += dev.o
> > can-dev-$(CONFIG_CAN_NETLINK) += length.o
> > can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
> > can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
>
> ...which results in:
>
> obj-$(CONFIG_CAN_DEV) += can-dev.o
>
> can-dev-y += skb.o

I see. But this contradicts the idea to do
| obj-y += can-dev
as suggested in:
https://lore.kernel.org/linux-can/20220604112707.z4zjdjydqy5rkyfe@pengutronix.de/

So, we have to choose between:
| obj-$(CONFIG_CAN_DEV) += can-dev.o
|
| can-dev-y += skb.o
|
| can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
| (...)

or:

| obj-y += can-dev.o
|
| can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
| can-dev-$(CONFIG_CAN_DEV) += skb.o
| (...)

I have a slight preference for the second, but again, wouldn't mind to
select the first one.

> can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
> can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
> can-dev-$(CONFIG_CAN_NETLINK) += dev.o
> can-dev-$(CONFIG_CAN_NETLINK) += length.o
> can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
> can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
>
> > or do you mean to sort by object name (ignoring the config symbol) like that:
> >
> > obj-$(CONFIG_CAN_DEV) += can-dev.o
> > can-dev-$(CONFIG_CAN_NETLINK) += bittiming.o
> > can-dev-$(CONFIG_CAN_CALC_BITTIMING) += calc_bittiming.o
> > can-dev-$(CONFIG_CAN_NETLINK) += dev.o
> > can-dev-$(CONFIG_CAN_NETLINK) += length.o
> > can-dev-$(CONFIG_CAN_NETLINK) += netlink.o
> > can-dev-$(CONFIG_CAN_RX_OFFLOAD) += rx-offload.o
> > can-dev-$(CONFIG_CAN_DEV) += skb.o
> >
> > ?
> >
> > (I honestly do not care so much how we sort the lines. My logic of
> > grouping first by CONFIG symbols seems more natural, but I am fine to
> > go with any other suggestion).
>
> I think this makes it clear where new files should be added.
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
