Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE3D325FBA
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhBZJMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhBZJLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:11:24 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2159FC06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:10:44 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 133so8251822ybd.5
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zkLE7vjp9hy+9xMe1t/VAY3SE1pRUw3nH2EdxUU2TTs=;
        b=QyRhmpk0sK8rN8K98HC9Gfk1b2UtntUXaAxaKgu8DABD/chU+b6IYvhivUrm9PHkQd
         wr3FaovOvu0AaFvJmbV0SaeqShvecDf2Jhmp8DlemdT2+YGIEvy8wifK1X1SMwORPant
         6rMuJQnU2rwOPw/4rzrrshn3UyWqeQxDQeJr0W12K7qykQdvMD6b9yLMq2bC4GTZJ4Xh
         CFXoybc2ay0maysleEUyr0JdlbcDxiz23RnalvI2lBhwOM76gOCifxatjMjLHjY+iLFt
         B5F5rnfgg/UFYXHUjmmdi7QFy49U2NsFNn9w01u/EEOsm8Xb8LRuNFlf5nOY7iv5cMi9
         LmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zkLE7vjp9hy+9xMe1t/VAY3SE1pRUw3nH2EdxUU2TTs=;
        b=VP78490q2RWzo/Hxa+JLpT4u34p5GSE08mre/migjrkiS9eTKUY80JB9C3VxISwwmp
         Cu+KZgRHsrajfWHbCYrR5/ajE/v0vRJywFpVZoKnavD6MwLuAJx2RzB0n0uJVjg9zoug
         9B99/AzWq3yb1uesbeIA9WVfOW2D6j/1IIvkccgKuqUa8uj9EpLVKBftCNptFR5Dgxo8
         0EX6/DB39dq2G7xq4qPYJYabhSP47YHKZMP5VZIi4fEvFWnUN1GPkwsuEnrMwnOcKci7
         NNI1WHxD8jUZEEt98eNmLH1GY4CWiRpz+XCqKyxCEQUR/NvHvgm5w1U/U5AGrUffZfql
         VAlA==
X-Gm-Message-State: AOAM532SNwLmfwB5z5rBL6lWuL9Uq3ezZ+NGoHYUnvBjl75sS2QBwug5
        5NSo75aMOuZIWmj53s1thCDq9ChnXSLG/QBiEfE=
X-Google-Smtp-Source: ABdhPJyzK4pTSb6CRblaB5W0LtNK2FuVcIwwfuHWs8A6edSc9SKd9X0DO+opqX3nH7JcnJ6ObAelxAOXEItC8tw7AZg=
X-Received: by 2002:a25:4054:: with SMTP id n81mr2989202yba.39.1614330643200;
 Fri, 26 Feb 2021 01:10:43 -0800 (PST)
MIME-Version: 1.0
References: <2323124.5UR7tLNZLG@tool> <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
 <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com> <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
 <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com> <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
 <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com> <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
 <b35ae75c-d0ce-2d29-b31a-72dc999a9bcc@gmail.com>
In-Reply-To: <b35ae75c-d0ce-2d29-b31a-72dc999a9bcc@gmail.com>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Fri, 26 Feb 2021 10:10:31 +0100
Message-ID: <CABwr4_u5azaW8vRix-OtTUyUMRKZ3ncHwsou5MLC9w4F0WUsvg@mail.gmail.com>
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

El vie, 26 feb 2021 a las 8:13, Heiner Kallweit
(<hkallweit1@gmail.com>) escribi=C3=B3:
>
> On 25.02.2021 23:28, Daniel Gonz=C3=A1lez Cabanelas wrote:
> > El jue, 25 feb 2021 a las 21:05, Heiner Kallweit
> > (<hkallweit1@gmail.com>) escribi=C3=B3:
> >>
> >> On 25.02.2021 17:36, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>> El jue, 25 feb 2021 a las 8:22, Heiner Kallweit
> >>> (<hkallweit1@gmail.com>) escribi=C3=B3:
> >>>>
> >>>> On 25.02.2021 00:54, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>>> El mi=C3=A9, 24 feb 2021 a las 23:01, Florian Fainelli
> >>>>> (<f.fainelli@gmail.com>) escribi=C3=B3:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
> >>>>>>> On 24.02.2021 16:44, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>>>>>> The current bcm63xx_enet driver doesn't asign the internal phy I=
RQ. As a
> >>>>>>>> result of this it works in polling mode.
> >>>>>>>>
> >>>>>>>> Fix it using the phy_device structure to assign the platform IRQ=
.
> >>>>>>>>
> >>>>>>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
> >>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [=
Broadcom
> >>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01=
, irq=3DPOLL)
> >>>>>>>>
> >>>>>>>> After the patch:
> >>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [=
Broadcom
> >>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01=
, irq=3D17)
> >>>>>>>>
> >>>>>>>> Pluging and uplugging the ethernet cable now generates interrupt=
s and the
> >>>>>>>> PHY goes up and down as expected.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com=
>
> >>>>>>>> ---
> >>>>>>>> changes in V2:
> >>>>>>>>   - snippet moved after the mdiobus registration
> >>>>>>>>   - added missing brackets
> >>>>>>>>
> >>>>>>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
> >>>>>>>>  1 file changed, 11 insertions(+), 2 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/driv=
ers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>>>> index fd876721316..dd218722560 100644
> >>>>>>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platfor=
m_device *pdev)
> >>>>>>>>               * if a slave is not present on hw */
> >>>>>>>>              bus->phy_mask =3D ~(1 << priv->phy_id);
> >>>>>>>>
> >>>>>>>> -            if (priv->has_phy_interrupt)
> >>>>>>>> +            ret =3D mdiobus_register(bus);
> >>>>>>>> +
> >>>>>>>> +            if (priv->has_phy_interrupt) {
> >>>>>>>> +                    phydev =3D mdiobus_get_phy(bus, priv->phy_i=
d);
> >>>>>>>> +                    if (!phydev) {
> >>>>>>>> +                            dev_err(&dev->dev, "no PHY found\n"=
);
> >>>>>>>> +                            goto out_unregister_mdio;
> >>>>>>>> +                    }
> >>>>>>>> +
> >>>>>>>>                      bus->irq[priv->phy_id] =3D priv->phy_interr=
upt;
> >>>>>>>> +                    phydev->irq =3D priv->phy_interrupt;
> >>>>>>>> +            }
> >>>>>>>>
> >>>>>>>> -            ret =3D mdiobus_register(bus);
> >>>>>>>
> >>>>>>> You shouldn't have to set phydev->irq, this is done by phy_device=
_create().
> >>>>>>> For this to work bus->irq[] needs to be set before calling mdiobu=
s_register().
> >>>>>>
> >>>>>> Yes good point, and that is what the unchanged code does actually.
> >>>>>> Daniel, any idea why that is not working?
> >>>>>
> >>>>> Hi Florian, I don't know. bus->irq[] has no effect, only assigning =
the
> >>>>> IRQ through phydev->irq works.
> >>>>>
> >>>>> I can resend the patch  without the bus->irq[] line since it's
> >>>>> pointless in this scenario.
> >>>>>
> >>>>
> >>>> It's still an ugly workaround and a proper root cause analysis shoul=
d be done
> >>>> first. I can only imagine that phydev->irq is overwritten in phy_pro=
be()
> >>>> because phy_drv_supports_irq() is false. Can you please check whethe=
r
> >>>> phydev->irq is properly set in phy_device_create(), and if yes, whet=
her
> >>>> it's reset to PHY_POLL in phy_probe()?.
> >>>>
> >>>
> >>> Hi Heiner, I added some kernel prints:
> >>>
> >>> [    2.712519] libphy: Fixed MDIO Bus: probed
> >>> [    2.721969] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >>> [    2.726841] phy_device_create: dev->irq =3D 17
> >>> [    2.726841]
> >>> [    2.832620] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >>> [    2.836846] phy_probe: phydev->irq =3D 17
> >>> [    2.840950] phy_probe: phy_drv_supports_irq =3D 0, phy_interrupt_i=
s_valid =3D 1
> >>> [    2.848267] phy_probe: phydev->irq =3D -1
> >>> [    2.848267]
> >>> [    2.854059] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >>> [    2.858174] phy_probe: phydev->irq =3D -1
> >>> [    2.862253] phy_probe: phydev->irq =3D -1
> >>> [    2.862253]
> >>> [    2.868121] libphy: bcm63xx_enet MII bus: probed
> >>> [    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> >>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
> >>> irq=3DPOLL)
> >>>
> >>> Currently using kernel 5.4.99. I still have no idea what's going on.
> >>>
> >> Thanks for debugging. This confirms my assumption that the interrupt
> >> is overwritten in phy_probe(). I'm just scratching my head how
> >> phy_drv_supports_irq() can return 0. In 5.4.99 it's defined as:
> >>
> >> static bool phy_drv_supports_irq(struct phy_driver *phydrv)
> >> {
> >>         return phydrv->config_intr && phydrv->ack_interrupt;
> >> }
> >>
> >> And that's the PHY driver:
> >>
> >> static struct phy_driver bcm63xx_driver[] =3D {
> >> {
> >>         .phy_id         =3D 0x00406000,
> >>         .phy_id_mask    =3D 0xfffffc00,
> >>         .name           =3D "Broadcom BCM63XX (1)",
> >>         /* PHY_BASIC_FEATURES */
> >>         .flags          =3D PHY_IS_INTERNAL,
> >>         .config_init    =3D bcm63xx_config_init,
> >>         .ack_interrupt  =3D bcm_phy_ack_intr,
> >>         .config_intr    =3D bcm63xx_config_intr,
> >> }
> >>
> >> So both callbacks are set. Can you extend your debugging and check
> >> in phy_drv_supports_irq() which of the callbacks is missing?
> >>
> >
> > Hi, both callbacks are missing on the first check. However on the next
> > calls they're there.
> >
> > [    2.263909] libphy: Fixed MDIO Bus: probed
> > [    2.273026] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > [    2.277908] phy_device_create: dev->irq =3D 17
> > [    2.277908]
> > [    2.373104] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > [    2.377336] phy_probe: phydev->irq =3D 17
> > [    2.381445] phy_drv_supports_irq: phydrv->config_intr =3D 0,
> > phydrv->ack_interrupt =3D 0
> > [    2.389554] phydev->irq =3D PHY_POLL;
> > [    2.393186] phy_probe: phydev->irq =3D -1
> > [    2.393186]
> > [    2.398987] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > [    2.403108] phy_probe: phydev->irq =3D -1
> > [    2.407195] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> > phydrv->ack_interrupt =3D 1
> > [    2.415314] phy_probe: phydev->irq =3D -1
> > [    2.415314]
> > [    2.421189] libphy: bcm63xx_enet MII bus: probed
> > [    2.426129] =3D=3D=3D=3D=3D=3D=3Dphy_connect=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > [    2.430410] phy_drv_supports_irq: phydrv->config_intr =3D 1,
> > phydrv->ack_interrupt =3D 1
> > [    2.438537] phy_connect: phy_drv_supports_irq =3D 1
> > [    2.438537]
> > [    2.445284] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> > driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
> > irq=3DPOLL)
> >
>
> I'd like to understand why the phy_device is probed twice,
> with which drivers it's probed.
> Could you please add printing phydrv->name to phy_probe() ?
>

Hi Heiner, indeed there are two different probed devices. The B53
switch driver is causing this issue.

[    2.269595] libphy: Fixed MDIO Bus: probed
[    2.278706] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    2.283594] phy_device_create: dev->irq =3D 17
[    2.283594]
[    2.379554] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
[    2.383780] phy_probe: phydrv->name =3D Broadcom B53 (3)
[    2.389235] phy_probe: phydev->irq =3D 17
[    2.393332] phy_drv_supports_irq: phydrv->config_intr =3D 0,
phydrv->ack_interrupt =3D 0
[    2.401445] phydev->irq =3D PHY_POLL
[    2.405080] phy_probe: phydev->irq =3D -1
[    2.405080]
[    2.410878] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
[    2.414996] phy_probe: phydrv->name =3D Broadcom BCM63XX (1)
[    2.420791] phy_probe: phydev->irq =3D -1
[    2.424876] phy_drv_supports_irq: phydrv->config_intr =3D 1,
phydrv->ack_interrupt =3D 1
[    2.432994] phy_probe: phydev->irq =3D -1
[    2.432994]
[    2.438862] libphy: bcm63xx_enet MII bus: probed
[    2.443809] =3D=3D=3D=3D=3D=3D=3Dphy_connect=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[    2.448092] phy_drv_supports_irq: phydrv->config_intr =3D 1,
phydrv->ack_interrupt =3D 1
[    2.456215] phy_connect: phy_drv_supports_irq =3D 1
[    2.456215]
[    2.462961] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
irq=3DPOLL)

The board has no switch, it's a driver for other boards in OpenWrt. I
forgot it wasn't upstreamed:
https://github.com/openwrt/openwrt/tree/master/target/linux/generic/files/d=
rivers/net/phy/b53

I tested a kernel compiled without this driver, now the IRQ is
detected as it should be:

[    2.270707] libphy: Fixed MDIO Bus: probed
[    2.279715] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    2.284600] phy_device_create: dev->irq =3D 17
[    2.284600]
[    2.373763] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
[    2.377989] phy_probe: phydrv->name =3D Broadcom BCM63XX (1)
[    2.383803] phy_probe: phydev->irq =3D 17
[    2.387888] phy_drv_supports_irq: phydrv->config_intr =3D 1,
phydrv->ack_interrupt =3D 1
[    2.396007] phy_probe: phydev->irq =3D 17
[    2.396007]
[    2.401877] libphy: bcm63xx_enet MII bus: probed
[    2.406820] =3D=3D=3D=3D=3D=3D=3Dphy_connect=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[    2.411099] phy_drv_supports_irq: phydrv->config_intr =3D 1,
phydrv->ack_interrupt =3D 1
[    2.419226] phy_connect: phy_drv_supports_irq =3D 1
[    2.419226]
[    2.429857] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
irq=3D17)

Then, maybe this is an OpenWrt bug itself?

Regards
Daniel

>
> > I also added the prints to phy_connect.
> >
> >> Last but not least: Do you use a mainline kernel, or is it maybe
> >> a modified downstream kernel? In the latter case, please check
> >> in your kernel sources whether both callbacks are set.
> >>
> >
> > It's a modified kernel, and the the callbacks are set. BTW I also
> > tested the kernel with no patches concerning to the ethernet driver.
> >
> > Regards,
> > Daniel
> >
> >>
> >>
> >>>> On which kernel version do you face this problem?
> >>>>
> >>> The kernel version 4.4 works ok. The minimum version where I found th=
e
> >>> problem were the kernel 4.9.111, now using 5.4. And 5.10 also tested.
> >>>
> >>> Regards
> >>> Daniel
> >>>
> >>>>> Regards
> >>>>>> --
> >>>>>> Florian
> >>>>
> >>
>
