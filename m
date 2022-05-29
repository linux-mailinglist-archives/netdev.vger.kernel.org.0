Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C28A537156
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 16:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiE2OZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 10:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiE2OZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 10:25:33 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7955E151;
        Sun, 29 May 2022 07:25:31 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id p13so3738942ybm.1;
        Sun, 29 May 2022 07:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+0zPRYJnufvVPkTixT+aSSdJu8NMBjIecozVwXO0Nko=;
        b=LqdjDaXotHC/DSVIXU8KG9WyTe3pAhOq0KOMWQ1stlTUK2qbRsT6lbKLNKLFgksH5T
         sfmSavGPerQYxhzJETb/O9SerasmLDNr5OekWLv3iHR9ZAJDdIcjSy22+5gawPV4dolD
         kxFBR/8dJ87BkHPcsGkDvQCHy3qeon2Az640yUvS5oj081UliQpd+vDBYvp8Q7l6diDH
         0zdl/J+PfNeHc1zuu1bA9gyAGWu0lNllRowBWzK9ys9w4vyhaWHiYkkbPAn7+nPvBSZP
         irOZBTYIX1jaktNgcNuoAGdZAFziRSIg0fvE1E9ZQ43ylFKicLpwys8+PzRVFLNXcbRV
         w/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+0zPRYJnufvVPkTixT+aSSdJu8NMBjIecozVwXO0Nko=;
        b=DWl1toFPNAmiTM+2frl+/rGe19J02J34WuBRUPcmpatlwxuSZMIjJPpI+nxApQPfJS
         3cqw/aaXk8jrGGFDc4T0FemQ6Xm8keL0lBSI85sKxy91FTu/yiUIbzjdFIDv6xtmtl9q
         il+pZ6QICOHAaHvac5bFlizRJgpgHfjL6Obo1HVLuKocAwHhFLB1lOVgeIP0xEBdDvWq
         fnLt1yLAJBbN2dAXll3t0KvPZV6snOpQHA3qndcil+k9zMep6+DiVC2ZRbWXfBVvzSi8
         OuhzdiBxxlfixA1kh30ubYXIBHEKiRANPpZVKn1YFEnWbsN2RCgaHyefH7C3spnJyg7E
         +fSQ==
X-Gm-Message-State: AOAM5339WkMRGgY5Le14mdYHp2mUIVQXinpc7qkiK9ienWviY0rT0Rkp
        y2jzIxaE+12GPDDYa/pgHBSE5Wbv6vWiSHimXWcakDoacZd0Pg==
X-Google-Smtp-Source: ABdhPJwtNSjqYTLL1SW8UvN5n72R4plMC2o/nSbnPtkZ2xGV4T5mxk3wZ9RBBltR4yaQKbgIyL2o7sqHgaBLCOh9XbM=
X-Received: by 2002:a5b:1d0:0:b0:65c:ce2b:594f with SMTP id
 f16-20020a5b01d0000000b0065cce2b594fmr1574128ybp.500.1653834331020; Sun, 29
 May 2022 07:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220512135901.1377087-1-srinivas.neeli@xilinx.com>
 <CAMZ6Rq+z69CTY6Ec0n9d0-ri6pcyHtKH917M1eTD6hgkmyvGDQ@mail.gmail.com>
 <DM6PR02MB53868E201FAB1F01D01AAB25AFD99@DM6PR02MB5386.namprd02.prod.outlook.com>
 <CAMZ6RqLKQ-jmQfF7yq5dObpbzky6FcjEFw9acHmfLLhp2v4eXg@mail.gmail.com> <DM6PR02MB5386DCD8D96FEC639D967A42AFDB9@DM6PR02MB5386.namprd02.prod.outlook.com>
In-Reply-To: <DM6PR02MB5386DCD8D96FEC639D967A42AFDB9@DM6PR02MB5386.namprd02.prod.outlook.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Sun, 29 May 2022 23:25:19 +0900
Message-ID: <CAMZ6RqJ2JHJYRu-pSpbpV6SOBqs5w7RNt5R3xeuRyD++NiNWPw@mail.gmail.com>
Subject: Re: [PATCH] can: xilinx_can: Add Transmitter delay compensation (TDC)
 feature support
To:     Srinivas Neeli <sneeli@xilinx.com>
Cc:     "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>,
        Srinivas Goud <sgoud@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat. 28 May 2022 at 09:46, Srinivas Neeli <sneeli@xilinx.com> wrote:
> Hi Vincent,
>
> > -----Original Message-----
> > From: Vincent Mailhol <vincent.mailhol@gmail.com>
> > Sent: Friday, May 27, 2022 6:01 AM
> > To: Srinivas Neeli <sneeli@xilinx.com>
> > Cc: wg@grandegger.com; mkl@pengutronix.de; davem@davemloft.net;
> > edumazet@google.com; Appana Durga Kedareswara Rao
> > <appanad@xilinx.com>; Srinivas Goud <sgoud@xilinx.com>; Michal Simek
> > <michals@xilinx.com>; kuba@kernel.org; pabeni@redhat.com; linux-
> > can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org; git
> > <git@xilinx.com>
> > Subject: Re: [PATCH] can: xilinx_can: Add Transmitter delay compensation
> > (TDC) feature support
> >
> > On Fri. 27 May 2022 at 00:51, Srinivas Neeli <sneeli@xilinx.com> wrote:
> > > Hi Vincent,
> > >
> > > > -----Original Message-----
> > > > From: Vincent Mailhol <vincent.mailhol@gmail.com>
> > > > Sent: Friday, May 13, 2022 6:54 AM
> > > > To: Srinivas Neeli <sneeli@xilinx.com>
> > > > Cc: wg@grandegger.com; mkl@pengutronix.de; davem@davemloft.net;
> > > > edumazet@google.com; Appana Durga Kedareswara Rao
> > > > <appanad@xilinx.com>; Srinivas Goud <sgoud@xilinx.com>; Michal
> > Simek
> > > > <michals@xilinx.com>; kuba@kernel.org; pabeni@redhat.com; linux-
> > > > can@vger.kernel.org; netdev@vger.kernel.org; linux-arm-
> > > > kernel@lists.infradead.org; linux-kernel@vger.kernel.org; git
> > > > <git@xilinx.com>
> > > > Subject: Re: [PATCH] can: xilinx_can: Add Transmitter delay
> > > > compensation
> > > > (TDC) feature support
> > > >
> > > > On Fri. 13 May 2022 at 07:30, Srinivas Neeli
> > > > <srinivas.neeli@xilinx.com>
> > > > wrote:
> > > > > Added Transmitter delay compensation (TDC) feature support.
> > > > > In the case of higher measured loop delay with higher baud rates,
> > > > > observed bit stuff errors.
> > > > > By enabling the TDC feature in a controller, will compensate for
> > > > > the measure loop delay in the receive path.
> > > > > TDC feature requires BRP values can be 1 or 2.
> > > > > The current CAN framework does not limit the brp so while using
> > > > > TDC, have to restrict BRP values.
> > > > > Ex:
> > > > > ip link set can0 type can tq 12 prop-seg 39 phase-seg1 20
> > > > > phase-seg2
> > > > > 20 sjw 20 dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4 fd
> > > > > on loopback on tdco 12 tdc-mode auto
> > > >
> > > > Did you experience some cases in which you had BRP > 2 and saw
> > > > transmission errors due to the absence of delay compensation? Could
> > > > you show the calculated values?
> > > > Usually, you start to observe but stuff error at high bitrates (e.g.
> > > > ~5MBPS), and for such bitrates, time quanta has to be small which
> > > > then results in a small BRP.
> > >
> > > yes, we observed errors with higher baud rates(4 and 5 MBPS).
> > > Observation:
> > > BRPA 1Mbps Sampling 75%
> > > BRPD 5MBPS Sampling 75%
> > > On NXP PHY observed a delay of 160 ns. so observing the failure.
> > > After enabling the TDC feature to work fine.
> >
> > Can you also share the results of:
> >
> > | ip --details link show can0
> >
> > for both the automatic calculation by the CAN framework and for your hand
> > calculated values?
>
> ip --details link show can6
> root@xilinx-vck190-2021_1:~# ip --details link show can6
> 9: can6: <NOARP,UP,LOWER_UP,ECHO> mtu 72 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
>     link/can  promiscuity 0 minmtu 0 maxmtu 0
>     can <FD> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
>           bitrate 999999 sample-point 0.750
>           tq 250 prop-seg 1 phase-seg1 1 phase-seg2 1 sjw 1
>           xilinx_can: tseg1 1..256 tseg2 1..128 sjw 1..128 brp 2..256 brp-inc 1
>           dbitrate 4999999 dsample-point 0.750
>           dtq 50 dprop-seg 1 dphase-seg1 1 dphase-seg2 1 dsjw 1
>           xilinx_can: dtseg1 1..32 dtseg2 1..16 dsjw 1..16 dbrp 2..256 dbrp-inc 1
>           clock 79999999 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> root@xilinx-vck190-2021_1:~#

So the CAN framework calculated a DBRP of 4.

Did you apply this patch from Marc?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=85d4eb2a3dfe939dda5304d61e406cb8e0852d60

It is supposed to solve those "too high BRP" issues.

> Hand calculated values:
> ip link set can0 type can tq 12 prop-seg 39 phase-seg1 20 phase-seg2 20 sjw 20 dtq 12 dprop-seg 5 dphase-seg1 6 dphase-seg2 4 dsjw 4 fd on

With tq = 12 you are off by 4%, right?
I get:

dbrp = dtq * clock / 1000000000
     = 12 * 80000000 / 1000000000
     = 0.96

instead of brp = 1.

Wouldn't dtq = 25 and dbrp = 2 be the best here?

> Observations:
> ---------------
> Board VCK190 +NXP phy.
> Observed TDCV value generated by IP is 9clock cycles(112ns)[Choosing Falling edge of bit].
> But Bit starts on rx line after 160 ns observed with scope.
>
> Exp1:
> BRPA 1Mbps Sampling 75%
> BRPD 5MBPS Sampling 75%
>
> Without TDC feature:
> Bit length 200ns, Sampling point 75% means 150ns.
> IP tries to sample at 150ns , but Bit starting at 160ns,so observed failure.
>
> With TDC feature:
> Bit length 200ns, Sampling point 75%, TDCO =12clock cycles(150ns).
> Ip tries after 112+150 = 262ns,able to sample the bit.

That seems correct.
My worries is why the framework calculates a DBRP of 4. Please check
that Mark's patch was correctly applied. If not, try it and,
hopefully, this will fix your issue and you will not have to enter
manually calculated parameters again.

> Thank you!
> >
> >
> > Thank you!
> >
> > > > > Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> > > > > ---
> > > > >  drivers/net/can/xilinx_can.c | 30 +++++++++++++++++++++++++-----
> > > > >  1 file changed, 25 insertions(+), 5 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/can/xilinx_can.c
> > > > > b/drivers/net/can/xilinx_can.c index e2b15d29d15e..7af518fbed02
> > > > > 100644
> > > > > --- a/drivers/net/can/xilinx_can.c
> > > > > +++ b/drivers/net/can/xilinx_can.c
> > > > > @@ -1,7 +1,7 @@
> > > > >  // SPDX-License-Identifier: GPL-2.0-or-later
> > > > >  /* Xilinx CAN device driver
> > > > >   *
> > > > > - * Copyright (C) 2012 - 2014 Xilinx, Inc.
> > > > > + * Copyright (C) 2012 - 2022 Xilinx, Inc.
> > > > >   * Copyright (C) 2009 PetaLogix. All rights reserved.
> > > > >   * Copyright (C) 2017 - 2018 Sandvik Mining and Construction Oy
> > > > >   *
> > > > > @@ -133,6 +133,8 @@ enum xcan_reg {
> > > > >  #define XCAN_DLCR_BRS_MASK             0x04000000 /* BRS Mask in DLC
> > */
> > > > >
> > > > >  /* CAN register bit shift - XCAN_<REG>_<BIT>_SHIFT */
> > > > > +#define XCAN_BRPR_TDCO_SHIFT_CANFD     8  /* Transmitter Delay
> > > > Compensation Offset */
> > > >
> > > > Having CANFD in the name is redundant (TDC implies CANFD).
> > > > #define XCAN_BRPR_TDCO_SHIFT 8
> > > update in V2.
> > >
> > > >
> > > > > +#define XCAN_BRPR_TDCE_SHIFT_CANFD     16 /* Transmitter Delay
> > > > Compensation (TDC) Enable */
> > > >
> > > > Why not:
> > > > #define XCAN_BRPR_TDC_ENABLE BIT(16)
> > > update in V2.
> > >
> > > >
> > > > >  #define XCAN_BTR_SJW_SHIFT             7  /* Synchronous jump width */
> > > > >  #define XCAN_BTR_TS2_SHIFT             4  /* Time segment 2 */
> > > > >  #define XCAN_BTR_SJW_SHIFT_CANFD       16 /* Synchronous jump
> > width
> > > > */
> > > > > @@ -259,7 +261,7 @@ static const struct can_bittiming_const
> > > > xcan_bittiming_const_canfd2 = {
> > > > >         .tseg2_min = 1,
> > > > >         .tseg2_max = 128,
> > > > >         .sjw_max = 128,
> > > > > -       .brp_min = 2,
> > > > > +       .brp_min = 1,
> > > >
> > > > Was there any reason to have brp_min = 2 in the first place?
> > > > I think this change  should be a different patch. If the brp_min = 2
> > > > is just a typo, you might also want to backport it to stable branches.
> > >
> > > On early silicon engineering samples we observed bit shrinking issue when
> > we use brp =1 , hence we updated brp_min =2.
> > > As in production silicon this issue is fixed we are planning to revert the
> > patch.
> >
> > Great!
> >
> > > > >         .brp_max = 256,
> > > > >         .brp_inc = 1,
> > > > >  };
> > > > > @@ -272,11 +274,21 @@ static struct can_bittiming_const
> > > > xcan_data_bittiming_const_canfd2 = {
> > > > >         .tseg2_min = 1,
> > > > >         .tseg2_max = 16,
> > > > >         .sjw_max = 16,
> > > > > -       .brp_min = 2,
> > > > > +       .brp_min = 1,
> > > > >         .brp_max = 256,
> > > > >         .brp_inc = 1,
> > > > >  };
> > > > >
> > > > > +/* Transmission Delay Compensation constants for CANFD2.0 and
> > > > > +Versal */ static const struct can_tdc_const xcan_tdc_const = {
> > > > > +       .tdcv_min = 0,
> > > > > +       .tdcv_max = 0, /* Manual mode not supported. */
> > > >
> > > > Right, had a look at the datasheet and xilinx indeed does not
> > > > support setting TDCV.
> > > > However, xilinx still has a TDCV register to report the measured
> > > > transmission delay.
> > > >
> > > > Socket CAN's TDC framework provides can_priv::do_get_auto_tdcv() to
> > > > report the measured value through the netlink interface:
> > > > https://elixir.bootlin.com/linux/v5.17/source/include/linux/can/dev.
> > > > h#L87
> > > >
> > > > Can you implement this call back function?
> > > Will implement in V2.
> > >
> > > >
> > > > > +       .tdco_min = 0,
> > > > > +       .tdco_max = 64,
> > > > > +       .tdcf_min = 0, /* Filter window not supported */
> > > > > +       .tdcf_max = 0,
> > > > > +};
> > > > > +
> > > > >  /**
> > > > >   * xcan_write_reg_le - Write a value to the device register little endian
> > > > >   * @priv:      Driver private data structure
> > > > > @@ -425,6 +437,11 @@ static int xcan_set_bittiming(struct
> > > > > net_device
> > > > *ndev)
> > > > >             priv->devtype.cantype == XAXI_CANFD_2_0) {
> > > > >                 /* Setting Baud Rate prescalar value in F_BRPR Register */
> > > > >                 btr0 = dbt->brp - 1;
> > > > > +               if (can_tdc_is_enabled(&priv->can)) {
> > > > > +                       btr0 = btr0 |
> > > > > +                       (priv->can.tdc.tdco) << XCAN_BRPR_TDCO_SHIFT_CANFD
> > |
> > > > > +                       1 << XCAN_BRPR_TDCE_SHIFT_CANFD;
> > > >
> > > > I don't think the parenthesis around (priv->can.tdc.tdco) are needed.
> > > Yes, will update.
> > > >
> > > >                        btr0 = btr0 |
> > > >                        priv->can.tdc.tdco << XCAN_BRPR_TDCO_SHIFT |
> > > >                       XCAN_BRPR_TDC_ENABLE
> > > >
> > > > (c.f. above for macro names)
> > > >
> > > > > +               }
> > > > >
> > > > >                 /* Setting Time Segment 1 in BTR Register */
> > > > >                 btr1 = dbt->prop_seg + dbt->phase_seg1 - 1; @@
> > > > > -1747,13 +1764,16 @@ static int xcan_probe(struct platform_device
> > *pdev)
> > > > >                 priv->can.data_bittiming_const =
> > > > >                         &xcan_data_bittiming_const_canfd;
> > > > >
> > > > > -       if (devtype->cantype == XAXI_CANFD_2_0)
> > > > > +       if (devtype->cantype == XAXI_CANFD_2_0) {
> > > > >                 priv->can.data_bittiming_const =
> > > > >                         &xcan_data_bittiming_const_canfd2;
> > > > > +               priv->can.tdc_const = &xcan_tdc_const;
> > > > > +       }
> > > > >
> > > > >         if (devtype->cantype == XAXI_CANFD ||
> > > > >             devtype->cantype == XAXI_CANFD_2_0)
> > > > > -               priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
> > > > > +               priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
> > > > > +
> > > > > + CAN_CTRLMODE_TDC_AUTO;
> > > > >
> > > > >         priv->reg_base = addr;
> > > > >         priv->tx_max = tx_max;
