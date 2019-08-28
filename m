Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFBBA061A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfH1PUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 11:20:14 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35204 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfH1PUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 11:20:13 -0400
Received: by mail-ed1-f68.google.com with SMTP id t50so486524edd.2
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q3io65Y+qLgm1KJIAbQXP6p5qBI8TQYetIODTngUSYc=;
        b=hJ+I73asNqjQtxvh9mFLhNLE7CE0mEH4iDiIHcnTaeKGp+w/dffBeG7yxUQtEHUheA
         zd1fVFT2EeQXEjzvaMxCsVjqyCbxqIhRdIw6wRcY5eTqN7O8VLRkVQpsZG7EYBBCJjFd
         bnRiWODYlw/QvBNamIpinW5R+I9NVjGs/IMELLMBU2Svw/D2O+lkWFvIbYisRPfI3gxD
         qihRE94/k4WzZMowVY+1FAi7pzkUSAREfYAQHGI8pHk5Oo2C71p+88dUiOF9lUSvA700
         nWeb8CoZnrLoPRyGKHZVx8f8isUT6/PhpsTShVTEEPIpjdeEVwqiYbjzzHa7RRrq7DQd
         b2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q3io65Y+qLgm1KJIAbQXP6p5qBI8TQYetIODTngUSYc=;
        b=oiH6dLxnMgXpOrjkAZiZW5bFbU7+O7r7rcx1m+ApmsprIx2mg4BXVH2EWNwP8zCP92
         X58twNHr6+jxlLvlgzblYWW1NR7RkXOhTzNZfshLit93MPrmJh5Oi2A7Vo4MIvR+ixih
         XRnCTuGf0Q6cQy74QPAYqQbNw9SG8Hay+vcYQIGICPoVeybFo5fyiwALZdiXHuSgUHa7
         rDL6XMbzY60hvPBTSJ8z/8tVItsMrD9XCZ+m5Jj+tsMREtjPKxLfzldKNmXdfKpT7ZN0
         EpWr/F/+1lAQctyip0bcSlMGt6ekWVq7iL/FG5YQNIL2Ls53I4ZafDIlvsyEq8IszyMb
         FIUw==
X-Gm-Message-State: APjAAAVT6XSlR18pc55Lmm+I6yqyok/M4/NHEZ5OMyH86QvNyHS7XGem
        q1s9WFPhMhKkRSobGdPG4cqLh9OSSmqV/OHS71EUA8fs1C0=
X-Google-Smtp-Source: APXvYqxIwSEJh8eQMRKaKMhfvYLfXhhkgVIl9M8GpvrgN92ew/DV671FErH0nVvk8Tob6uwfnyf7CE9bl1teFi6sUQg=
X-Received: by 2002:a05:6402:124f:: with SMTP id l15mr4582005edw.140.1567005611217;
 Wed, 28 Aug 2019 08:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190723151702.14430-1-asolokha@kb.kras.ru> <20190723151702.14430-2-asolokha@kb.kras.ru>
 <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com>
 <87lfwfio13.fsf@eldim> <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
In-Reply-To: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 28 Aug 2019 18:20:00 +0300
Message-ID: <CA+h21hp6oXx3FtH3=K8Kb3_osdYiDp1SySziTM+yJRH-1nW5eA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
To:     Arseny Solokha <asolokha@kb.kras.ru>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Sat, 24 Aug 2019 at 18:21, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Arseny.
>
> On Tue, 30 Jul 2019 at 17:40, Arseny Solokha <asolokha@kb.kras.ru> wrote:
> >
> > > Hi Arseny,
> > >
> > > Nice project!
> >
> > Vladimir, Russell, thanks for your review. I'm on vacation now, so won'=
t fully
> > address your comments in a few weeks: while I can build the code, I won=
't have
> > access to hardware to test.
> >
> > So it seems this patch will turn into a series where we'll have some cl=
eanup
> > patches preceding the actual conversion (and the latter will also conta=
in a
> > documentation change in Documentation/devicetree/bindings/net/fsl-tsec-=
phy.txt
> > which I've overlooked in the first submission). I'll try to post trivia=
l
> > cleanups independently while still on vacation.
> >
>
> Yes, ideally the cleanup would be separate from the conversion.
>
> >
> > >> @@ -891,11 +912,21 @@ static int gfar_of_init(struct platform_device=
 *ofdev, struct net_device **pdev)
> > >>
> > >>         err =3D of_property_read_string(np, "phy-connection-type", &=
ctype);
> > >>
> > >> -       /* We only care about rgmii-id.  The rest are autodetected *=
/
> > >> -       if (err =3D=3D 0 && !strcmp(ctype, "rgmii-id"))
> > >> -               priv->interface =3D PHY_INTERFACE_MODE_RGMII_ID;
> > >> -       else
> > >> +       /* We only care about rgmii-id and sgmii - the former
> > >> +        * is indistinguishable from rgmii in hardware, and phylink =
needs
> > >> +        * the latter to be set appropriately for correct phy config=
uration.
> > >> +        * The rest are autodetected
> > >> +        */
> > >> +       if (err =3D=3D 0) {
> > >> +               if (!strcmp(ctype, "rgmii-id"))
> > >> +                       priv->interface =3D PHY_INTERFACE_MODE_RGMII=
_ID;
> > >> +               else if (!strcmp(ctype, "sgmii"))
> > >> +                       priv->interface =3D PHY_INTERFACE_MODE_SGMII=
;
> > >> +               else
> > >> +                       priv->interface =3D PHY_INTERFACE_MODE_MII;
> > >> +       } else {
> > >>                 priv->interface =3D PHY_INTERFACE_MODE_MII;
> > >> +       }
> > >>
> > >
> > > No. Don't do this. Just do:
> > >
> > >     err =3D of_get_phy_mode(np);
> > >     if (err < 0)
> > >         goto err_grp_init;
> > >
> > >     priv->interface =3D err;
> > >
> > >>         if (of_find_property(np, "fsl,magic-packet", NULL))
> > >>                 priv->device_flags |=3D FSL_GIANFAR_DEV_HAS_MAGIC_PA=
CKET;
> > >> @@ -903,19 +934,21 @@ static int gfar_of_init(struct platform_device=
 *ofdev, struct net_device **pdev)
> > >>         if (of_get_property(np, "fsl,wake-on-filer", NULL))
> > >>                 priv->device_flags |=3D FSL_GIANFAR_DEV_HAS_WAKE_ON_=
FILER;
> > >>
> > >> -       priv->phy_node =3D of_parse_phandle(np, "phy-handle", 0);
> > >> +       priv->device_node =3D np;
> > >> +       priv->speed =3D SPEED_UNKNOWN;
> > >>
> > >> -       /* In the case of a fixed PHY, the DT node associated
> > >> -        * to the PHY is the Ethernet MAC DT node.
> > >> -        */
> > >> -       if (!priv->phy_node && of_phy_is_fixed_link(np)) {
> > >> -               err =3D of_phy_register_fixed_link(np);
> > >> -               if (err)
> > >> -                       goto err_grp_init;
> > >> +       priv->phylink_config.dev =3D &priv->ndev->dev;
> > >> +       priv->phylink_config.type =3D PHYLINK_NETDEV;
> > >>
> > >> -               priv->phy_node =3D of_node_get(np);
> > >> +       phylink =3D phylink_create(&priv->phylink_config, of_fwnode_=
handle(np),
> > >> +                                priv->interface, &gfar_phylink_ops)=
;
> > >
> > > You introduced a bug here.
> > > of_phy_connect used to take the PHY interface type (for good or bad)
> > > from gfar_get_interface() (which is reconstructing it from the MAC
> > > registers).
> > > You are now passing the PHY interface type to phylink_create from the
> > > "phy-connection-type" DT property.
> > > At the very least, you are breaking LS1021A which uses phy-mode
> > > instead of phy-connection-type (hence my comment above to use the
> > > generic OF helper).
> > > Actually I think you just uncovered a latent bug, in that the DT
> > > bindings for phy-mode didn't mean much at all to the driver - it woul=
d
> > > rely on what the bootloader had set up.
> > > Actually DT bindings for phy-connection-type were most likely simply
> > > bolt on on top of gianfar when they figured they couldn't just
> > > auto-detect the various species of required RGMII delays.
> > > But gfar_get_interface is a piece of history that was introduced in
> > > the same commit as the enum phy_interface_t itself: e8a2b6a42073
> > > ("[PATCH] PHY: Add support for configuring the PHY connection
> > > interface"). Its time has come.
> >
> > <=E2=80=A6>
> >
> > >>         }
> > >>
> > >> +       priv->tbi_phy =3D NULL;
> > >> +       interface =3D gfar_get_interface(dev);
> > >
> > > Be consistent and just go for priv->interface. Nobody's changing it a=
nyway.
> >
> > So if I get you right, I'm supposed to drop gfar_get_interface() and re=
ly on DT
> > bindings entirely?
> >
>
> Oof, I checked arch/powerpc/boot/dts/fsl and the following boards
> using the gianfar driver are guilty of populating phy-handle but not
> phy-connection-type:
> mpc8540ads
> mpc8541cds
> mpc8548cds_32b
> mpc8548cds_36b
> mpc8555cds
> mpc8560ads
> mpc8568mds
> ppa8548
>
> I think a sane logic for populating priv->interface would be:
> - Attempt of_get_phy_mode
> - If phy-mode or phy-connection-type properties are not found, revert
> to gfar_get_interface for the legacy blobs above.
>
> >
> > >> @@ -3387,23 +3384,6 @@ static irqreturn_t gfar_interrupt(int irq, vo=
id *grp_id)
> > >>         return IRQ_HANDLED;
> > >>  }
> > >>
> > >> -/* Called every time the controller might need to be made
> > >> - * aware of new link state.  The PHY code conveys this
> > >> - * information through variables in the phydev structure, and this
> > >> - * function converts those variables into the appropriate
> > >> - * register values, and can bring down the device if needed.
> > >> - */
> > >> -static void adjust_link(struct net_device *dev)
> > >> -{
> > >> -       struct gfar_private *priv =3D netdev_priv(dev);
> > >> -       struct phy_device *phydev =3D dev->phydev;
> > >> -
> > >> -       if (unlikely(phydev->link !=3D priv->oldlink ||
> > >> -                    (phydev->link && (phydev->duplex !=3D priv->old=
duplex ||
> > >> -                                      phydev->speed !=3D priv->olds=
peed))))
> > >> -               gfar_update_link_state(priv);
> > >> -}
> > >
> > > Getting rid of the cruft from this function deserves its own patch.
> >
> > How am I supposed to remove it without breaking the PHYLIB-based driver=
? Or do
> > you mean making it call gfar_update_link_state() just before the conver=
sion
> > which will then remove adjust_link() altogether?
> >
>
> I don't know, if you can't refactor without breaking anything then ok.
>
> >
> > >>
> > >>         if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
> > >>                 return;
> > >>
> > >> -       if (phydev->link) {
> > >> -               u32 tempval1 =3D gfar_read(&regs->maccfg1);
> > >> -               u32 tempval =3D gfar_read(&regs->maccfg2);
> > >> -               u32 ecntrl =3D gfar_read(&regs->ecntrl);
> > >> -               u32 tx_flow_oldval =3D (tempval1 & MACCFG1_TX_FLOW);
> > >> +       if (unlikely(phylink_autoneg_inband(mode)))
> > >> +               return;
> > >>
> > >> -               if (phydev->duplex !=3D priv->oldduplex) {
> > >> -                       if (!(phydev->duplex))
> > >> -                               tempval &=3D ~(MACCFG2_FULL_DUPLEX);
> > >> -                       else
> > >> -                               tempval |=3D MACCFG2_FULL_DUPLEX;
> > >> +       maccfg1 =3D gfar_read(&regs->maccfg1);
> > >> +       maccfg2 =3D gfar_read(&regs->maccfg2);
> > >> +       ecntrl =3D gfar_read(&regs->ecntrl);
> > >>
> > >> -                       priv->oldduplex =3D phydev->duplex;
> > >> -               }
> > >> +       new_maccfg2 =3D maccfg2 & ~(MACCFG2_FULL_DUPLEX | MACCFG2_IF=
);
> > >> +       new_ecntrl =3D ecntrl & ~ECNTRL_R100;
> > >>
> > >> -               if (phydev->speed !=3D priv->oldspeed) {
> > >> -                       switch (phydev->speed) {
> > >> -                       case 1000:
> > >> -                               tempval =3D
> > >> -                                   ((tempval & ~(MACCFG2_IF)) | MAC=
CFG2_GMII);
> > >> +       if (state->duplex)
> > >> +               new_maccfg2 |=3D MACCFG2_FULL_DUPLEX;
> > >>
> > >> -                               ecntrl &=3D ~(ECNTRL_R100);
> > >> -                               break;
> > >> -                       case 100:
> > >> -                       case 10:
> > >> -                               tempval =3D
> > >> -                                   ((tempval & ~(MACCFG2_IF)) | MAC=
CFG2_MII);
> > >> -
> > >> -                               /* Reduced mode distinguishes
> > >> -                                * between 10 and 100
> > >> -                                */
> > >> -                               if (phydev->speed =3D=3D SPEED_100)
> > >> -                                       ecntrl |=3D ECNTRL_R100;
> > >> -                               else
> > >> -                                       ecntrl &=3D ~(ECNTRL_R100);
> > >> -                               break;
> > >> -                       default:
> > >> -                               netif_warn(priv, link, priv->ndev,
> > >> -                                          "Ack!  Speed (%d) is not =
10/100/1000!\n",
> > >> -                                          phydev->speed);
> > >
> > > Please 1. remove "Ack!" 2. treat SPEED_UNKNOWN here by setting the MA=
C
> > > into a low-power state (e.g. 10 Mbps - the power savings are real).
> > > Don't print that Speed -1 is not 10/100/1000, we know that.
> >
> > In my first conversion attempt I see "Ack!" when changing link speed on=
 when
> > shutting it down, so switching to 10 Mbps doesn't seem right for me=E2=
=80=94hence early
> > return in this case. Maybe I'm doing something wrong here.
> >
>
> When mac_config calls with SPEED_UNKNOWN, the link is down, and you
> can put the MAC in the lowest energy state it can go to (10 Mbps, in
> this case). Or so I've been told. Maybe Russell can chime in. Anyway,
> you don't need to print anything, there's lots of prints from PHYLINK
> already.
>
> >
> > >> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/driv=
ers/net/ethernet/freescale/gianfar_ethtool.c
> > >> index 3433b46b90c1..146b30d07789 100644
> > >> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> > >> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> > >> @@ -35,7 +35,7 @@
> > >>  #include <asm/types.h>
> > >>  #include <linux/ethtool.h>
> > >>  #include <linux/mii.h>
> > >> -#include <linux/phy.h>
> > >> +#include <linux/phylink.h>
> > >>  #include <linux/sort.h>
> > >>  #include <linux/if_vlan.h>
> > >>  #include <linux/of_platform.h>
> > >> @@ -207,12 +207,10 @@ static void gfar_get_regs(struct net_device *d=
ev, struct ethtool_regs *regs,
> > >>  static unsigned int gfar_usecs2ticks(struct gfar_private *priv,
> > >>                                      unsigned int usecs)
> > >>  {
> > >> -       struct net_device *ndev =3D priv->ndev;
> > >> -       struct phy_device *phydev =3D ndev->phydev;
> > >
> > > Are you sure this still works? You missed a ndev->phydev check from
> > > gfar_gcoalesce, where this is called from. Technically you can still
> > > check ndev->phydev, it's just that PHYLINK doesn't guarantee you'll
> > > have one (e.g. fixed-link interfaces).
> >
> > It still works for RGMII PHYs, SGMII and 1000Base-X in my testing. I di=
dn't
> > check it with fixed-link, though.
> >
> >
> > >> @@ -1519,6 +1472,24 @@ static int gfar_get_ts_info(struct net_device=
 *dev,
> > >>         return 0;
> > >>  }
> > >>
> > >> +/* Set link ksettings (phy address, speed) for ethtools */
> > >
> > > ethtool, not ethtools. Also, I'm not quite sure what you mean by
> > > setting the "phy address" with ethtool.
> >
> > Well, I know where I've copied it from=E2=80=A6 Thanks for pointing it =
out.
>
> Regards,
> -Vladimir

Coming back to your patch.
Here is a gfar_reset_task gone horribly wrong, due to it not holding
rtnl_lock while calling phylink_stop:

[ 4115.081902] ------------[ cut here ]------------
[ 4115.086544] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:443
dev_watchdog+0x2ec/0x2f0
[ 4115.094802] NETDEV WATCHDOG: eth2 (fsl-gianfar): transmit queue 0 timed =
out
[ 4115.101727] Modules linked in:
[ 4115.104794] CPU: 1 PID: 0 Comm: swapper/1 Not tainted
5.3.0-rc6-01275-g246284a4920a-dirty #251
[ 4115.113360] Hardware name: Freescale LS1021A
[ 4115.117635] [<c03132e0>] (unwind_backtrace) from [<c030d8b8>]
(show_stack+0x10/0x14)
[ 4115.125351] [<c030d8b8>] (show_stack) from [<c10b41f0>]
(dump_stack+0xb0/0xc4)
[ 4115.132550] [<c10b41f0>] (dump_stack) from [<c0349dc8>] (__warn+0xf8/0x1=
10)
[ 4115.139488] [<c0349dc8>] (__warn) from [<c0349e24>]
(warn_slowpath_fmt+0x44/0x68)
[ 4115.146942] [<c0349e24>] (warn_slowpath_fmt) from [<c0f28a4c>]
(dev_watchdog+0x2ec/0x2f0)
[ 4115.155089] [<c0f28a4c>] (dev_watchdog) from [<c03c2800>]
(call_timer_fn+0x3c/0x18c)
[ 4115.162806] [<c03c2800>] (call_timer_fn) from [<c03c2a2c>]
(expire_timers+0xdc/0x144)
[ 4115.170608] [<c03c2a2c>] (expire_timers) from [<c03c2d38>]
(run_timer_softirq+0xac/0x1d4)
[ 4115.178754] [<c03c2d38>] (run_timer_softirq) from [<c030221c>]
(__do_softirq+0xb4/0x364)
[ 4115.186815] [<c030221c>] (__do_softirq) from [<c03502c0>]
(irq_exit+0xbc/0xd8)
[ 4115.194012] [<c03502c0>] (irq_exit) from [<c03a426c>]
(__handle_domain_irq+0x60/0xb4)
[ 4115.201818] [<c03a426c>] (__handle_domain_irq) from [<c0754260>]
(gic_handle_irq+0x58/0x9c)
[ 4115.210139] [<c0754260>] (gic_handle_irq) from [<c0301a8c>]
(__irq_svc+0x6c/0x90)
[ 4115.217586] Exception stack(0xea8cff58 to 0xea8cffa0)
[ 4115.222613] ff40:
    00000000 0010afbc
[ 4115.230756] ff60: eb6c1330 c031ecc0 ea8ce000 c1d064ac c1d064f0
00000002 00000000 00000000
[ 4115.238900] ff80: c1c80ba8 ea8cffb0 00000000 ea8cffa8 c0309db4
c0309db8 600f0013 ffffffff
[ 4115.247049] [<c0301a8c>] (__irq_svc) from [<c0309db8>]
(arch_cpu_idle+0x38/0x3c)
[ 4115.254420] [<c0309db8>] (arch_cpu_idle) from [<c037aa04>]
(do_idle+0x1c8/0x2a4)
[ 4115.261789] [<c037aa04>] (do_idle) from [<c037ad7c>]
(cpu_startup_entry+0x18/0x1c)
[ 4115.269328] [<c037ad7c>] (cpu_startup_entry) from [<8030256c>] (0x803025=
6c)
[ 4115.276288] ---[ end trace c31a413a826ed6df ]---
[ 4115.291055] ------------[ cut here ]------------
[ 4115.295671] WARNING: CPU: 1 PID: 260 at
drivers/net/phy/phylink.c:1013 phylink_stop+0xd4/0xd8
[ 4115.304165] RTNL: assertion failed at drivers/net/phy/phylink.c (1013)
[ 4115.310651] Modules linked in:
[ 4115.313707] CPU: 1 PID: 260 Comm: kworker/1:4 Tainted: G        W
      5.3.0-rc6-01275-g246284a4920a-dirty #251
[ 4115.323996] Hardware name: Freescale LS1021A
[ 4115.328245] Workqueue: events gfar_reset_task
[ 4115.332589] [<c03132e0>] (unwind_backtrace) from [<c030d8b8>]
(show_stack+0x10/0x14)
[ 4115.340293] [<c030d8b8>] (show_stack) from [<c10b41f0>]
(dump_stack+0xb0/0xc4)
[ 4115.347480] [<c10b41f0>] (dump_stack) from [<c0349dc8>] (__warn+0xf8/0x1=
10)
[ 4115.354406] [<c0349dc8>] (__warn) from [<c0349e24>]
(warn_slowpath_fmt+0x44/0x68)
[ 4115.361850] [<c0349e24>] (warn_slowpath_fmt) from [<c0b62918>]
(phylink_stop+0xd4/0xd8)
[ 4115.369813] [<c0b62918>] (phylink_stop) from [<c0bcc3c0>]
(stop_gfar+0x3c/0x48)
[ 4115.377085] [<c0bcc3c0>] (stop_gfar) from [<c0bccf68>] (reset_gfar+0x88/=
0xc8)
[ 4115.384185] [<c0bccf68>] (reset_gfar) from [<c03650d4>]
(process_one_work+0x218/0x510)
[ 4115.392062] [<c03650d4>] (process_one_work) from [<c0366544>]
(worker_thread+0x30/0x5a0)
[ 4115.400112] [<c0366544>] (worker_thread) from [<c036b33c>]
(kthread+0x120/0x150)
[ 4115.407469] [<c036b33c>] (kthread) from [<c03010e8>]
(ret_from_fork+0x14/0x2c)
[ 4115.414648] Exception stack(0xeaf8bfb0 to 0xeaf8bff8)
[ 4115.419668] bfa0:                                     00000000
00000000 00000000 00000000
[ 4115.427800] bfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[ 4115.435932] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[ 4115.442529] ---[ end trace c31a413a826ed6e0 ]---
[ 4115.447454] fsl-gianfar soc:ethernet@2d90000 eth2: Link is Down
[ 4115.457917] ------------[ cut here ]------------
[ 4115.462605] WARNING: CPU: 1 PID: 260 at
drivers/net/phy/phylink.c:952 phylink_start+0x1b4/0x270
[ 4115.471257] RTNL: assertion failed at drivers/net/phy/phylink.c (952)
[ 4115.477682] Modules linked in:
[ 4115.480725] CPU: 1 PID: 260 Comm: kworker/1:4 Tainted: G        W
      5.3.0-rc6-01275-g246284a4920a-dirty #251
[ 4115.491014] Hardware name: Freescale LS1021A
[ 4115.495263] Workqueue: events gfar_reset_task
[ 4115.499609] [<c03132e0>] (unwind_backtrace) from [<c030d8b8>]
(show_stack+0x10/0x14)
[ 4115.507315] [<c030d8b8>] (show_stack) from [<c10b41f0>]
(dump_stack+0xb0/0xc4)
[ 4115.514502] [<c10b41f0>] (dump_stack) from [<c0349dc8>] (__warn+0xf8/0x1=
10)
[ 4115.521428] [<c0349dc8>] (__warn) from [<c0349e24>]
(warn_slowpath_fmt+0x44/0x68)
[ 4115.528872] [<c0349e24>] (warn_slowpath_fmt) from [<c0b61c9c>]
(phylink_start+0x1b4/0x270)
[ 4115.537094] [<c0b61c9c>] (phylink_start) from [<c0bcc994>]
(startup_gfar+0x248/0x2fc)
[ 4115.544885] [<c0bcc994>] (startup_gfar) from [<c0bccf70>]
(reset_gfar+0x90/0xc8)
[ 4115.552244] [<c0bccf70>] (reset_gfar) from [<c03650d4>]
(process_one_work+0x218/0x510)
[ 4115.560121] [<c03650d4>] (process_one_work) from [<c0366544>]
(worker_thread+0x30/0x5a0)
[ 4115.568171] [<c0366544>] (worker_thread) from [<c036b33c>]
(kthread+0x120/0x150)
[ 4115.575528] [<c036b33c>] (kthread) from [<c03010e8>]
(ret_from_fork+0x14/0x2c)
[ 4115.582708] Exception stack(0xeaf8bfb0 to 0xeaf8bff8)
[ 4115.587730] bfa0:                                     00000000
00000000 00000000 00000000
[ 4115.595862] bfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[ 4115.603993] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[ 4115.610607] ---[ end trace c31a413a826ed6e1 ]---

Hope this helps,
-Vladimir
