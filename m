Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647B21AF580
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgDRWj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:39:25 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA5DC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:39:25 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i19so6602911ioh.12
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9LLH2vCLYMStAoz6kNMO5LYGbaz5lq66DXoBCLx3QtE=;
        b=fOR6/j70zLbkkIWuHDtq/IsJWKt+mr7kMYidWwxgY3vefD6vWlpSJtWeU+J4E+B4sE
         uRzQggXLwO4+KpnEk/SQPQycVHdxljCUbQ+XfO9zVwKVpMq7X+hIwFn3kjgJy09mP+rz
         r2yU3Hb3azw27qu9RPvVD0nlZ/Aq1Z4m71liTTmih6oes+w6o3pwgXDmppAu8biOAX2N
         4PbsgpCbmOLCzNaomWnhxujIUU6C/0mKT2eKYy9+RuKZgp4sxRvyk9cJNlJbBOBsExxY
         NIE9r3wCrB8ChWLynztbohneKldu5qKIJOAXC/1YseEk9zQjxSbGnL2Jd0QhYV7FLqSv
         gFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9LLH2vCLYMStAoz6kNMO5LYGbaz5lq66DXoBCLx3QtE=;
        b=W9A7q6CftKknQFKseVXPyK7MYWDuCs7h3vEsXztra0zqSqjXot3MvDWXSYiIZKvt2x
         N69VqF9LL0CNVLYtWKmnsCn8OyMa7SOPsSSELzg//CVWmOToQAOdCb1rZDWvfAIOPMdy
         mwpqMHo6oQT0N6WkXrIwUTgjYVMXFKYa65TGWPptE1so4ovkw6iFjFY/GTH62gAWsLwN
         TslJ+7Cx0LxW0uPs9GcPJb8TF3tN4UTvBRQ052fnvr++U7HEkBTAdiwHIi4qruwnJQmv
         STp1UGKCix/WEerPZ2K2dzSn4puv2cFtUEFyaEWrOZ25S1oi5f4eX1M/RabLY9CsqEgR
         Hm+w==
X-Gm-Message-State: AGi0PuY2vKCB9oITCn1scOcZE33gqJzzCFAsRY7Btw2xc43Q4nTdkuTu
        r4MrWvQ35Pn7zRMstm8IBf79C6e1GyqImJ/2B4TElC2t
X-Google-Smtp-Source: APiQypIK0wTMMycpxIGtKV4yaVIOo/TgY0SlRRDIyD6e/UzShTFer5akAzcZzXDmvF/K0avPC2zx+w+5S9aLSnlifbk=
X-Received: by 2002:a5d:9c88:: with SMTP id p8mr2578357iop.200.1587249564323;
 Sat, 18 Apr 2020 15:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200418000355.804617-1-andrew@lunn.ch> <20200418000355.804617-2-andrew@lunn.ch>
 <HE1PR0402MB27450B207DFFB1B86DCF287DFFD60@HE1PR0402MB2745.eurprd04.prod.outlook.com>
In-Reply-To: <HE1PR0402MB27450B207DFFB1B86DCF287DFFD60@HE1PR0402MB2745.eurprd04.prod.outlook.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sat, 18 Apr 2020 15:39:17 -0700
Message-ID: <CAFXsbZpVSiMYpUaOR=+UEGBgx5kSTzGcftbPe=PPkj_xWhy=bA@mail.gmail.com>
Subject: Re: [EXT] [PATCH net-next v2 1/3] net: ethernet: fec: Replace
 interrupt driven MDIO with polled IO
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I did some profiling using an oscilloscope with my NXP Vybrid based
platform to see what different "sleep_us" values resulted in for start
of MDIO to start of MDIO transaction times.  Here's what I found:

0  - ~38us to ~40us
1  - ~48us to ~64us
2  - ~48us to ~64us
3  - ~48us to ~64us
4  - ~48us to ~64us
4  - ~48us to ~64us
5  - ~48us to ~64us
6  - ~48us to ~64us
7  - ~48us to ~64us
8  - ~48us to ~64us
9  - ~56us to ~88us
10 - ~56us to ~112us

Basically, with the "sleep_us" value set to 0, I would get the
shortest inter transaction times with a very low variance.  Once I
went to a non-zero value, the inter transaction time went up, as well
as the variance, which I suppose makes sense....


On Sat, Apr 18, 2020 at 6:55 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Andrew Lunn <andrew@lunn.ch> Sent: Saturday, April 18, 2020 8:04 AM
> > Measurements of the MDIO bus have shown that driving the MDIO bus using
> > interrupts is slow. Back to back MDIO transactions take about 90uS, with
> > 25uS spent performing the transaction, and the remainder of the time the bus
> > is idle.
> >
> > Replacing the completion interrupt with polled IO results in back to back
> > transactions of 40uS. The polling loop waiting for the hardware to complete
> > the transaction takes around 27uS. Which suggests interrupt handling has an
> > overhead of 50uS, and polled IO nearly halves this overhead, and doubles the
> > MDIO performance.
> >
> > Suggested-by: Chris Heally <cphealy@gmail.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/ethernet/freescale/fec.h      |  4 +-
> >  drivers/net/ethernet/freescale/fec_main.c | 67 ++++++++++++-----------
> >  2 files changed, 35 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec.h
> > b/drivers/net/ethernet/freescale/fec.h
> > index e74dd1f86bba..a6cdd5b61921 100644
> > --- a/drivers/net/ethernet/freescale/fec.h
> > +++ b/drivers/net/ethernet/freescale/fec.h
> > @@ -376,8 +376,7 @@ struct bufdesc_ex {
> >  #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
> >  #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
> >
> > -#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF |
> > FEC_ENET_MII) -#define FEC_NAPI_IMASK FEC_ENET_MII
> > +#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
> >  #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK &
> > (~FEC_ENET_RXF))
> >
> >  /* ENET interrupt coalescing macro define */ @@ -543,7 +542,6 @@ struct
> > fec_enet_private {
> >         int     link;
> >         int     full_duplex;
> >         int     speed;
> > -       struct  completion mdio_done;
> >         int     irq[FEC_IRQ_NUM];
> >         bool    bufdesc_ex;
> >         int     pause_flag;
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index dc6f8763a5d4..6530829632b1 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -976,8 +976,8 @@ fec_restart(struct net_device *ndev)
> >         writel((__force u32)cpu_to_be32(temp_mac[1]),
> >                fep->hwp + FEC_ADDR_HIGH);
> >
> > -       /* Clear any outstanding interrupt. */
> > -       writel(0xffffffff, fep->hwp + FEC_IEVENT);
> > +       /* Clear any outstanding interrupt, except MDIO. */
> > +       writel((0xffffffff & ~FEC_ENET_MII), fep->hwp + FEC_IEVENT);
> >
> >         fec_enet_bd_init(ndev);
> >
> > @@ -1123,7 +1123,7 @@ fec_restart(struct net_device *ndev)
> >         if (fep->link)
> >                 writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
> >         else
> > -               writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
> > +               writel(0, fep->hwp + FEC_IMASK);
> >
> >         /* Init the interrupt coalescing */
> >         fec_enet_itr_coal_init(ndev);
> > @@ -1652,6 +1652,10 @@ fec_enet_interrupt(int irq, void *dev_id)
> >         irqreturn_t ret = IRQ_NONE;
> >
> >         int_events = readl(fep->hwp + FEC_IEVENT);
> > +
> > +       /* Don't clear MDIO events, we poll for those */
> > +       int_events &= ~FEC_ENET_MII;
> > +
> >         writel(int_events, fep->hwp + FEC_IEVENT);
> >         fec_enet_collect_events(fep, int_events);
> >
> > @@ -1659,16 +1663,12 @@ fec_enet_interrupt(int irq, void *dev_id)
> >                 ret = IRQ_HANDLED;
> >
> >                 if (napi_schedule_prep(&fep->napi)) {
> > -                       /* Disable the NAPI interrupts */
> > -                       writel(FEC_NAPI_IMASK, fep->hwp +
> > FEC_IMASK);
> > +                       /* Disable interrupts */
> > +                       writel(0, fep->hwp + FEC_IMASK);
> >                         __napi_schedule(&fep->napi);
> >                 }
> >         }
> >
> > -       if (int_events & FEC_ENET_MII) {
> > -               ret = IRQ_HANDLED;
> > -               complete(&fep->mdio_done);
> > -       }
> >         return ret;
> >  }
> >
> > @@ -1818,11 +1818,24 @@ static void fec_enet_adjust_link(struct
> > net_device *ndev)
> >                 phy_print_status(phy_dev);  }
> >
> > +static int fec_enet_mdio_wait(struct fec_enet_private *fep) {
> > +       uint ievent;
> > +       int ret;
> > +
> > +       ret = readl_poll_timeout(fep->hwp + FEC_IEVENT, ievent,
> > +                                ievent & FEC_ENET_MII, 0, 30000);
>
> sleep X us between reads ?
>
> > +
> > +       if (!ret)
> > +               writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> > +
> > +       return ret;
> > +}
> > +
> >  static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)  {
> >         struct fec_enet_private *fep = bus->priv;
> >         struct device *dev = &fep->pdev->dev;
> > -       unsigned long time_left;
> >         int ret = 0, frame_start, frame_addr, frame_op;
> >         bool is_c45 = !!(regnum & MII_ADDR_C45);
> >
> > @@ -1830,8 +1843,6 @@ static int fec_enet_mdio_read(struct mii_bus *bus,
> > int mii_id, int regnum)
> >         if (ret < 0)
> >                 return ret;
> >
> > -       reinit_completion(&fep->mdio_done);
> > -
> >         if (is_c45) {
> >                 frame_start = FEC_MMFR_ST_C45;
> >
> > @@ -1843,11 +1854,9 @@ static int fec_enet_mdio_read(struct mii_bus
> > *bus, int mii_id, int regnum)
> >                        fep->hwp + FEC_MII_DATA);
> >
> >                 /* wait for end of transfer */
> > -               time_left =
> > wait_for_completion_timeout(&fep->mdio_done,
> > -                               usecs_to_jiffies(FEC_MII_TIMEOUT));
> > -               if (time_left == 0) {
> > +               ret = fec_enet_mdio_wait(fep);
> > +               if (ret) {
> >                         netdev_err(fep->netdev, "MDIO address write
> > timeout\n");
> > -                       ret = -ETIMEDOUT;
> >                         goto out;
> >                 }
> >
> > @@ -1866,11 +1875,9 @@ static int fec_enet_mdio_read(struct mii_bus
> > *bus, int mii_id, int regnum)
> >                 FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
> >
> >         /* wait for end of transfer */
> > -       time_left = wait_for_completion_timeout(&fep->mdio_done,
> > -                       usecs_to_jiffies(FEC_MII_TIMEOUT));
> > -       if (time_left == 0) {
> > +       ret = fec_enet_mdio_wait(fep);
> > +       if (ret) {
> >                 netdev_err(fep->netdev, "MDIO read timeout\n");
> > -               ret = -ETIMEDOUT;
> >                 goto out;
> >         }
> >
> > @@ -1888,7 +1895,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> > int mii_id, int regnum,  {
> >         struct fec_enet_private *fep = bus->priv;
> >         struct device *dev = &fep->pdev->dev;
> > -       unsigned long time_left;
> >         int ret, frame_start, frame_addr;
> >         bool is_c45 = !!(regnum & MII_ADDR_C45);
> >
> > @@ -1898,8 +1904,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus,
> > int mii_id, int regnum,
> >         else
> >                 ret = 0;
> >
> > -       reinit_completion(&fep->mdio_done);
> > -
> >         if (is_c45) {
> >                 frame_start = FEC_MMFR_ST_C45;
> >
> > @@ -1911,11 +1915,9 @@ static int fec_enet_mdio_write(struct mii_bus
> > *bus, int mii_id, int regnum,
> >                        fep->hwp + FEC_MII_DATA);
> >
> >                 /* wait for end of transfer */
> > -               time_left =
> > wait_for_completion_timeout(&fep->mdio_done,
> > -                       usecs_to_jiffies(FEC_MII_TIMEOUT));
> > -               if (time_left == 0) {
> > +               ret = fec_enet_mdio_wait(fep);
> > +               if (ret) {
> >                         netdev_err(fep->netdev, "MDIO address write
> > timeout\n");
> > -                       ret = -ETIMEDOUT;
> >                         goto out;
> >                 }
> >         } else {
> > @@ -1931,12 +1933,9 @@ static int fec_enet_mdio_write(struct mii_bus
> > *bus, int mii_id, int regnum,
> >                 fep->hwp + FEC_MII_DATA);
> >
> >         /* wait for end of transfer */
> > -       time_left = wait_for_completion_timeout(&fep->mdio_done,
> > -                       usecs_to_jiffies(FEC_MII_TIMEOUT));
> > -       if (time_left == 0) {
> > +       ret = fec_enet_mdio_wait(fep);
> > +       if (ret)
> >                 netdev_err(fep->netdev, "MDIO write timeout\n");
> > -               ret  = -ETIMEDOUT;
> > -       }
> >
> >  out:
> >         pm_runtime_mark_last_busy(dev);
> > @@ -2132,6 +2131,9 @@ static int fec_enet_mii_init(struct platform_device
> > *pdev)
> >
> >         writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
> >
> > +       /* Clear any pending transaction complete indication */
> > +       writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> > +
> >         fep->mii_bus = mdiobus_alloc();
> >         if (fep->mii_bus == NULL) {
> >                 err = -ENOMEM;
> > @@ -3674,7 +3676,6 @@ fec_probe(struct platform_device *pdev)
> >                 fep->irq[i] = irq;
> >         }
> >
> > -       init_completion(&fep->mdio_done);
> >         ret = fec_enet_mii_init(pdev);
> >         if (ret)
> >                 goto failed_mii_init;
> > --
> > 2.26.1
>
