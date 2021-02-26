Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DE8326129
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 11:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBZKUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 05:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhBZKUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 05:20:48 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D5FC061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:20:08 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id p193so8429146yba.4
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dM7FSNeScjlEKiIIAKGoIXs5ZiEHsnH0yvyueRzsQ9k=;
        b=IV72IlbyiObZcEOM/iI8PrSeQGmMakPfroCNASCPT5zxGz8yDhHtzKrCgYQFbmK6Ev
         R0jgGrgFQ1rGF227hrdImxmWdW4TrRAbW4Z7jZAO0SA03en7IkhaTb4MwA8fSod1U+bp
         Pttxbk8/nGwg/EirfXcBVS4n+dd/TfQpBDRUB2jE4YvRKh8XHqaK1bk3Ke+rsZ4uI4Kn
         LQ4RrxAPY3zrZIwGm6agaTzHmda550qtqEgKWN3bNYVdOe2RmYL6ymr78m4mPO6cEEdn
         pfKOBwuJIbcHZEbpWejP9x3Ob5ow59zZK1RuTNfSVWjm4hSGH/uT6/a9zs9rN+Ll4GFE
         acYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dM7FSNeScjlEKiIIAKGoIXs5ZiEHsnH0yvyueRzsQ9k=;
        b=mFCMTu8Kj/otWf7oI8OE23r2rYjLxfkHZ/6Ao0ar3sqRaFWXkNKIZuEWCHKMSQRFGB
         YsC5+5S81QEuyg0gm3HLpdsuMm+/5oW676yrkulRnlPYWPfQztLkXF1ySOF1UMaTvgA4
         CNq+xqK9HYVgEK/6iWlNQu+7ZFopYXenlB4LUTiYZFusQl1wD5Uxo6gYxpZsaAwum3YE
         GZsQFeaEFs/W9U0pcdHbfbcXft+t9PGHl6NpLBSQ2BYL63/ksH4Ae+tpkbjPwctIRU0V
         zKCu1mNokI3J0uTm+EdIVuFghPCohtnVvTYzkfd4zNX5Y0XYXdSonzJH8rlfhPCxUj88
         mW5w==
X-Gm-Message-State: AOAM532WgVy2oCpNzmwsZRpXkbG+mrSJldkBnwLMnal5DAg5ziWJoxtv
        EoUXKVwXP2fd9aoitXZ/OvMDBOVUUnZV/AWBBo4=
X-Google-Smtp-Source: ABdhPJytDoa92QAXMOoWfIN/eHh2L1XMHeZjteBfokaxPYNi/t7f8r9AIaHRtvQ6a1qdYzhrZa4VZQjoO7qCt1gj5hk=
X-Received: by 2002:a25:2b08:: with SMTP id r8mr3664880ybr.194.1614334807824;
 Fri, 26 Feb 2021 02:20:07 -0800 (PST)
MIME-Version: 1.0
References: <2323124.5UR7tLNZLG@tool> <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
 <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com> <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
 <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com> <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
 <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com> <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
 <b35ae75c-d0ce-2d29-b31a-72dc999a9bcc@gmail.com> <CABwr4_u5azaW8vRix-OtTUyUMRKZ3ncHwsou5MLC9w4F0WUsvg@mail.gmail.com>
 <c9e72b62-3b4e-6214-f807-b24ec506cb56@gmail.com> <CABwr4_vpmgxyGAGYjM_C5TvdROT+pV738YBv=KnSKEO-ibUMxQ@mail.gmail.com>
 <286fb043-b812-a5ba-c66e-eef63fe5cc98@gmail.com>
In-Reply-To: <286fb043-b812-a5ba-c66e-eef63fe5cc98@gmail.com>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Fri, 26 Feb 2021 11:19:56 +0100
Message-ID: <CABwr4_tJqFiS-XtFitXGn=bjYzdv=YwqSSUaAvh1U-iHsbTZXQ@mail.gmail.com>
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El vie, 26 feb 2021 a las 11:08, Heiner Kallweit
(<hkallweit1@gmail.com>) escribi=C3=B3:
>
> On 26.02.2021 10:49, Daniel Gonz=C3=A1lez Cabanelas wrote:
> > El vie, 26 feb 2021 a las 10:32, Heiner Kallweit
> > (<hkallweit1@gmail.com>) escribi=C3=B3:
> >>
> >> On 26.02.2021 10:10, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>> El vie, 26 feb 2021 a las 8:13, Heiner Kallweit
> >>> (<hkallweit1@gmail.com>) escribi=C3=B3:
> >>>>
> >>>> On 25.02.2021 23:28, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>>> El jue, 25 feb 2021 a las 21:05, Heiner Kallweit
> >>>>> (<hkallweit1@gmail.com>) escribi=C3=B3:
> >>>>>>
> >>>>>> On 25.02.2021 17:36, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>>>>> El jue, 25 feb 2021 a las 8:22, Heiner Kallweit
> >>>>>>> (<hkallweit1@gmail.com>) escribi=C3=B3:
> >>>>>>>>
> >>>>>>>> On 25.02.2021 00:54, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>>>>>>> El mi=C3=A9, 24 feb 2021 a las 23:01, Florian Fainelli
> >>>>>>>>> (<f.fainelli@gmail.com>) escribi=C3=B3:
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
> >>>>>>>>>>> On 24.02.2021 16:44, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>>>>>>>>>> The current bcm63xx_enet driver doesn't asign the internal p=
hy IRQ. As a
> >>>>>>>>>>>> result of this it works in polling mode.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Fix it using the phy_device structure to assign the platform=
 IRQ.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
> >>>>>>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driv=
er [Broadcom
> >>>>>>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-=
0:01, irq=3DPOLL)
> >>>>>>>>>>>>
> >>>>>>>>>>>> After the patch:
> >>>>>>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driv=
er [Broadcom
> >>>>>>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-=
0:01, irq=3D17)
> >>>>>>>>>>>>
> >>>>>>>>>>>> Pluging and uplugging the ethernet cable now generates inter=
rupts and the
> >>>>>>>>>>>> PHY goes up and down as expected.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail=
.com>
> >>>>>>>>>>>> ---
> >>>>>>>>>>>> changes in V2:
> >>>>>>>>>>>>   - snippet moved after the mdiobus registration
> >>>>>>>>>>>>   - added missing brackets
> >>>>>>>>>>>>
> >>>>>>>>>>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++=
++--
> >>>>>>>>>>>>  1 file changed, 11 insertions(+), 2 deletions(-)
> >>>>>>>>>>>>
> >>>>>>>>>>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/=
drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>>>>>>>> index fd876721316..dd218722560 100644
> >>>>>>>>>>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>>>>>>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>>>>>>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct pla=
tform_device *pdev)
> >>>>>>>>>>>>               * if a slave is not present on hw */
> >>>>>>>>>>>>              bus->phy_mask =3D ~(1 << priv->phy_id);
> >>>>>>>>>>>>
> >>>>>>>>>>>> -            if (priv->has_phy_interrupt)
> >>>>>>>>>>>> +            ret =3D mdiobus_register(bus);
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +            if (priv->has_phy_interrupt) {
> >>>>>>>>>>>> +                    phydev =3D mdiobus_get_phy(bus, priv->p=
hy_id);
> >>>>>>>>>>>> +                    if (!phydev) {
> >>>>>>>>>>>> +                            dev_err(&dev->dev, "no PHY foun=
d\n");
> >>>>>>>>>>>> +                            goto out_unregister_mdio;
> >>>>>>>>>>>> +                    }
> >>>>>>>>>>>> +
> >>>>>>>>>>>>                      bus->irq[priv->phy_id] =3D priv->phy_in=
terrupt;
> >>>>>>>>>>>> +                    phydev->irq =3D priv->phy_interrupt;
> >>>>>>>>>>>> +            }
> >>>>>>>>>>>>
> >>>>>>>>>>>> -            ret =3D mdiobus_register(bus);
> >>>>>>>>>>>
> >>>>>>>>>>> You shouldn't have to set phydev->irq, this is done by phy_de=
vice_create().
> >>>>>>>>>>> For this to work bus->irq[] needs to be set before calling md=
iobus_register().
> >>>>>>>>>>
> >>>>>>>>>> Yes good point, and that is what the unchanged code does actua=
lly.
> >>>>>>>>>> Daniel, any idea why that is not working?
> >>>>>>>>>
> >>>>>>>>> Hi Florian, I don't know. bus->irq[] has no effect, only assign=
ing the
> >>>>>>>>> IRQ through phydev->irq works.
> >>>>>>>>>
> >>>>>>>>> I can resend the patch  without the bus->irq[] line since it's
> >>>>>>>>> pointless in this scenario.
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> It's still an ugly workaround and a proper root cause analysis s=
hould be done
> >>>>>>>> first. I can only imagine that phydev->irq is overwritten in phy=
_probe()
> >>>>>>>> because phy_drv_supports_irq() is false. Can you please check wh=
ether
> >>>>>>>> phydev->irq is properly set in phy_device_create(), and if yes, =
whether
> >>>>>>>> it's reset to PHY_POLL in phy_probe()?.
> >>>>>>>>
> >>>>>>>
> >>>>>>> Hi Heiner, I added some kernel prints:
> >>>>>>>
> >>>>>>> [    2.712519] libphy: Fixed MDIO Bus: probed
> >>>>>>> [    2.721969] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >>>>>>> [    2.726841] phy_device_create: dev->irq =3D 17
> >>>>>>> [    2.726841]
> >>>>>>> [    2.832620] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >>>>>>> [    2.836846] phy_probe: phydev->irq =3D 17
> >>>>>>> [    2.840950] phy_probe: phy_drv_supports_irq =3D 0, phy_interru=
pt_is_valid =3D 1
> >>>>>>> [    2.848267] phy_probe: phydev->irq =3D -1
> >>>>>>> [    2.848267]
> >>>>>>> [    2.854059] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >>>>>>> [    2.858174] phy_probe: phydev->irq =3D -1
> >>>>>>> [    2.862253] phy_probe: phydev->irq =3D -1
> >>>>>>> [    2.862253]
> >>>>>>> [    2.868121] libphy: bcm63xx_enet MII bus: probed
> >>>>>>> [    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached P=
HY
> >>>>>>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:=
01,
> >>>>>>> irq=3DPOLL)
> >>>>>>>
> >>>>>>> Currently using kernel 5.4.99. I still have no idea what's going =
on.
> >>>>>>>
> >>>>>> Thanks for debugging. This confirms my assumption that the interru=
pt
> >>>>>> is overwritten in phy_probe(). I'm just scratching my head how
> >>>>>> phy_drv_supports_irq() can return 0. In 5.4.99 it's defined as:
> >>>>>>
> >>>>>> static bool phy_drv_supports_irq(struct phy_driver *phydrv)
> >>>>>> {
> >>>>>>         return phydrv->config_intr && phydrv->ack_interrupt;
> >>>>>> }
> >>>>>>
> >>>>>> And that's the PHY driver:
> >>>>>>
> >>>>>> static struct phy_driver bcm63xx_driver[] =3D {
> >>>>>> {
> >>>>>>         .phy_id         =3D 0x00406000,
> >>>>>>         .phy_id_mask    =3D 0xfffffc00,
> >>>>>>         .name           =3D "Broadcom BCM63XX (1)",
> >>>>>>         /* PHY_BASIC_FEATURES */
> >>>>>>         .flags          =3D PHY_IS_INTERNAL,
> >>>>>>         .config_init    =3D bcm63xx_config_init,
> >>>>>>         .ack_interrupt  =3D bcm_phy_ack_intr,
> >>>>>>         .config_intr    =3D bcm63xx_config_intr,
> >>>>>> }
> >>>>>>
> >>>>>> So both callbacks are set. Can you extend your debugging and check
> >>>>>> in phy_drv_supports_irq() which of the callbacks is missing?
> >>>>>>
> >>>>>
> >>>>> Hi, both callbacks are missing on the first check. However on the n=
ext
> >>>>> calls they're there.
> >>>>>
> >>>>> [    2.263909] libphy: Fixed MDIO Bus: probed
> >>>>> [    2.273026] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >>>>> [    2.277908] phy_device_create: dev->irq =3D 17
> >>>>> [    2.277908]
> >>>>> [    2.373104] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >>>>> [    2.377336] phy_probe: phydev->irq =3D 17
> >>>>> [    2.381445] phy_drv_supports_irq: phydrv->config_intr =3D 0,
> >>>>> phydrv->ack_interrupt =3D 0
> >>>>> [    2.389554] phydev->irq =3D PHY_POLL;
> >>>>> [    2.393186] phy_probe: phydev->irq =3D -1
> >>>>> [    2.393186]
> >>>>> [    2.398987] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >>>>> [    2.403108] phy_probe: phydev->irq =3D -1
> >>>>> [    2.407195] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> >>>>> phydrv->ack_interrupt =3D 1
> >>>>> [    2.415314] phy_probe: phydev->irq =3D -1
> >>>>> [    2.415314]
> >>>>> [    2.421189] libphy: bcm63xx_enet MII bus: probed
> >>>>> [    2.426129] =3D=3D=3D=3D=3D=3D=3Dphy_connect=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >>>>> [    2.430410] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> >>>>> phydrv->ack_interrupt =3D 1
> >>>>> [    2.438537] phy_connect: phy_drv_supports_irq =3D 1
> >>>>> [    2.438537]
> >>>>> [    2.445284] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> >>>>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01=
,
> >>>>> irq=3DPOLL)
> >>>>>
> >>>>
> >>>> I'd like to understand why the phy_device is probed twice,
> >>>> with which drivers it's probed.
> >>>> Could you please add printing phydrv->name to phy_probe() ?
> >>>>
> >>>
> >>> Hi Heiner, indeed there are two different probed devices. The B53
> >>> switch driver is causing this issue.
> >>>
> >>> [    2.269595] libphy: Fixed MDIO Bus: probed
> >>> [    2.278706] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >>> [    2.283594] phy_device_create: dev->irq =3D 17
> >>> [    2.283594]
> >>> [    2.379554] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >>> [    2.383780] phy_probe: phydrv->name =3D Broadcom B53 (3)
> >>
> >> Is this an out-of-tree driver? I can't find this string in any
> >> DSA or PHY driver.
> >>
> >
> > Yes it is.
> > https://github.com/openwrt/openwrt/blob/master/target/linux/generic/fil=
es/drivers/net/phy/b53/b53_mdio.c#L421
> >
>
> OK, I see. Then there's no reason to complain upstream.
> Either use the mainline B53 DSA driver of fix interrupt mode
> downstream.

I agree.

This b53 driver has one PHY with the same BCM63XX phy_id, causing a
double probe. I'll send the original patch to the OpenWrt project.

Thank you very much.
Daniel
>
> >>
> >>> [    2.389235] phy_probe: phydev->irq =3D 17
> >>> [    2.393332] phy_drv_supports_irq: phydrv->config_intr =3D 0,
> >>> phydrv->ack_interrupt =3D 0
> >>> [    2.401445] phydev->irq =3D PHY_POLL
> >>> [    2.405080] phy_probe: phydev->irq =3D -1
> >>> [    2.405080]
> >>> [    2.410878] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >>> [    2.414996] phy_probe: phydrv->name =3D Broadcom BCM63XX (1)
> >>> [    2.420791] phy_probe: phydev->irq =3D -1
> >>> [    2.424876] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> >>> phydrv->ack_interrupt =3D 1
> >>> [    2.432994] phy_probe: phydev->irq =3D -1
> >>> [    2.432994]
> >>> [    2.438862] libphy: bcm63xx_enet MII bus: probed
> >>> [    2.443809] =3D=3D=3D=3D=3D=3D=3Dphy_connect=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >>> [    2.448092] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> >>> phydrv->ack_interrupt =3D 1
> >>> [    2.456215] phy_connect: phy_drv_supports_irq =3D 1
> >>> [    2.456215]
> >>> [    2.462961] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> >>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
> >>> irq=3DPOLL)
> >>>
> >>> The board has no switch, it's a driver for other boards in OpenWrt. I
> >>> forgot it wasn't upstreamed:
> >>> https://github.com/openwrt/openwrt/tree/master/target/linux/generic/f=
iles/drivers/net/phy/b53
> >>>
> >>> I tested a kernel compiled without this driver, now the IRQ is
> >>> detected as it should be:
> >>>
> >>> [    2.270707] libphy: Fixed MDIO Bus: probed
> >>> [    2.279715] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >>> [    2.284600] phy_device_create: dev->irq =3D 17
> >>> [    2.284600]
> >>> [    2.373763] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >>> [    2.377989] phy_probe: phydrv->name =3D Broadcom BCM63XX (1)
> >>> [    2.383803] phy_probe: phydev->irq =3D 17
> >>> [    2.387888] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> >>> phydrv->ack_interrupt =3D 1
> >>> [    2.396007] phy_probe: phydev->irq =3D 17
> >>> [    2.396007]
> >>> [    2.401877] libphy: bcm63xx_enet MII bus: probed
> >>> [    2.406820] =3D=3D=3D=3D=3D=3D=3Dphy_connect=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >>> [    2.411099] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> >>> phydrv->ack_interrupt =3D 1
> >>> [    2.419226] phy_connect: phy_drv_supports_irq =3D 1
> >>> [    2.419226]
> >>> [    2.429857] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> >>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
> >>> irq=3D17)
> >>>
> >>> Then, maybe this is an OpenWrt bug itself?
> >>>
> >>> Regards
> >>> Daniel
> >>>
> >>>>
> >>>>> I also added the prints to phy_connect.
> >>>>>
> >>>>>> Last but not least: Do you use a mainline kernel, or is it maybe
> >>>>>> a modified downstream kernel? In the latter case, please check
> >>>>>> in your kernel sources whether both callbacks are set.
> >>>>>>
> >>>>>
> >>>>> It's a modified kernel, and the the callbacks are set. BTW I also
> >>>>> tested the kernel with no patches concerning to the ethernet driver=
.
> >>>>>
> >>>>> Regards,
> >>>>> Daniel
> >>>>>
> >>>>>>
> >>>>>>
> >>>>>>>> On which kernel version do you face this problem?
> >>>>>>>>
> >>>>>>> The kernel version 4.4 works ok. The minimum version where I foun=
d the
> >>>>>>> problem were the kernel 4.9.111, now using 5.4. And 5.10 also tes=
ted.
> >>>>>>>
> >>>>>>> Regards
> >>>>>>> Daniel
> >>>>>>>
> >>>>>>>>> Regards
> >>>>>>>>>> --
> >>>>>>>>>> Florian
> >>>>>>>>
> >>>>>>
> >>>>
> >>
>
