Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6A83259AD
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhBYW3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 17:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhBYW3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 17:29:52 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0773BC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 14:29:12 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id 133so7015478ybd.5
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 14:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rE77ovD1y15fu+UnTvtc1dXQGJFCQ3dq5veEo0ibOgA=;
        b=NsIubZFjudUauWgJ4eyY1sXNfH+HFCqnPi3vqDVV1sJV72WJBxq7M0DrZUBelBROPh
         g3KebdiQeVnarbLQ7BI8Gas4bz4VRwpwu7F/nM1Nm9Ajb0Kx3qESOKPPzy7pqE1cYtcg
         WJsQ+zNjTbvqnSh1TvFGO+UxggrLBZrz1XISDY5xtiTqjfg1T+Z2bhg5DTdWo+2mFYuB
         Uh3oidhlcuTc1GmBEoNX6TXlEL1z9VtPGz0/Kg5lVG80a9xCdYRVvhOllAW4G2QF398a
         Kv1INpBXCuncEdMPrP5hPN3iyDQipbzzOF9qA37o1VffC7emK47dpg4N9QhAt+wcAUhH
         MNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rE77ovD1y15fu+UnTvtc1dXQGJFCQ3dq5veEo0ibOgA=;
        b=fR3XvEzaVGb/wPjlqOx0KVmkBo+/zo/sxX/fh863lp8Nm/GxbPmf6NmXJHjoT9v5Az
         gTS4VecqHmDshb+7+b80PLozdgk6mCOa+zN4uKbAeEY6hHPdpESmJlSqT/aJHrh2WfOw
         40pQKQ3ISJzKnc9+mp5doiwIdCDFIKTULCWip2vWmnRpzRzoiloZxEPYLLeeH2TZV2+J
         QHi2vt6hN6b/Zsm30oQYNGVDw2II8638DN29+Lkr3cOl3UKfL/YZumA8Iqz/+a76hwct
         M40c+ffpMlRW1wVeVwJkYZlvoxN31kw8x0LYeGr9QT/GAFK0T10c6KuaI1HLBHLPKqrg
         iFaw==
X-Gm-Message-State: AOAM533VzQk2CZD3QCdKNObDoGFB0PlNMPNLj1myG+OXx14oiaF4AaNm
        EGqUxxB18gcnfk5dQUgiYgg/XB6aAPOvni/ZKKs=
X-Google-Smtp-Source: ABdhPJxxWoLKI2HLn2wt/Ry9IpxcU9214+Cwqp3iJN3thM4i35T34r0GfPbB5/hM+c6YYZ1evkJ2Jm10qsWrGf3f1Qk=
X-Received: by 2002:a25:cf0f:: with SMTP id f15mr106376ybg.107.1614292151324;
 Thu, 25 Feb 2021 14:29:11 -0800 (PST)
MIME-Version: 1.0
References: <2323124.5UR7tLNZLG@tool> <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
 <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com> <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
 <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com> <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
 <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com>
In-Reply-To: <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Thu, 25 Feb 2021 23:28:59 +0100
Message-ID: <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
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

El jue, 25 feb 2021 a las 21:05, Heiner Kallweit
(<hkallweit1@gmail.com>) escribi=C3=B3:
>
> On 25.02.2021 17:36, Daniel Gonz=C3=A1lez Cabanelas wrote:
> > El jue, 25 feb 2021 a las 8:22, Heiner Kallweit
> > (<hkallweit1@gmail.com>) escribi=C3=B3:
> >>
> >> On 25.02.2021 00:54, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>> El mi=C3=A9, 24 feb 2021 a las 23:01, Florian Fainelli
> >>> (<f.fainelli@gmail.com>) escribi=C3=B3:
> >>>>
> >>>>
> >>>>
> >>>> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
> >>>>> On 24.02.2021 16:44, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>>>> The current bcm63xx_enet driver doesn't asign the internal phy IRQ=
. As a
> >>>>>> result of this it works in polling mode.
> >>>>>>
> >>>>>> Fix it using the phy_device structure to assign the platform IRQ.
> >>>>>>
> >>>>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
> >>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Br=
oadcom
> >>>>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, =
irq=3DPOLL)
> >>>>>>
> >>>>>> After the patch:
> >>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Br=
oadcom
> >>>>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, =
irq=3D17)
> >>>>>>
> >>>>>> Pluging and uplugging the ethernet cable now generates interrupts =
and the
> >>>>>> PHY goes up and down as expected.
> >>>>>>
> >>>>>> Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
> >>>>>> ---
> >>>>>> changes in V2:
> >>>>>>   - snippet moved after the mdiobus registration
> >>>>>>   - added missing brackets
> >>>>>>
> >>>>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
> >>>>>>  1 file changed, 11 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/driver=
s/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>> index fd876721316..dd218722560 100644
> >>>>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_=
device *pdev)
> >>>>>>               * if a slave is not present on hw */
> >>>>>>              bus->phy_mask =3D ~(1 << priv->phy_id);
> >>>>>>
> >>>>>> -            if (priv->has_phy_interrupt)
> >>>>>> +            ret =3D mdiobus_register(bus);
> >>>>>> +
> >>>>>> +            if (priv->has_phy_interrupt) {
> >>>>>> +                    phydev =3D mdiobus_get_phy(bus, priv->phy_id)=
;
> >>>>>> +                    if (!phydev) {
> >>>>>> +                            dev_err(&dev->dev, "no PHY found\n");
> >>>>>> +                            goto out_unregister_mdio;
> >>>>>> +                    }
> >>>>>> +
> >>>>>>                      bus->irq[priv->phy_id] =3D priv->phy_interrup=
t;
> >>>>>> +                    phydev->irq =3D priv->phy_interrupt;
> >>>>>> +            }
> >>>>>>
> >>>>>> -            ret =3D mdiobus_register(bus);
> >>>>>
> >>>>> You shouldn't have to set phydev->irq, this is done by phy_device_c=
reate().
> >>>>> For this to work bus->irq[] needs to be set before calling mdiobus_=
register().
> >>>>
> >>>> Yes good point, and that is what the unchanged code does actually.
> >>>> Daniel, any idea why that is not working?
> >>>
> >>> Hi Florian, I don't know. bus->irq[] has no effect, only assigning th=
e
> >>> IRQ through phydev->irq works.
> >>>
> >>> I can resend the patch  without the bus->irq[] line since it's
> >>> pointless in this scenario.
> >>>
> >>
> >> It's still an ugly workaround and a proper root cause analysis should =
be done
> >> first. I can only imagine that phydev->irq is overwritten in phy_probe=
()
> >> because phy_drv_supports_irq() is false. Can you please check whether
> >> phydev->irq is properly set in phy_device_create(), and if yes, whethe=
r
> >> it's reset to PHY_POLL in phy_probe()?.
> >>
> >
> > Hi Heiner, I added some kernel prints:
> >
> > [    2.712519] libphy: Fixed MDIO Bus: probed
> > [    2.721969] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > [    2.726841] phy_device_create: dev->irq =3D 17
> > [    2.726841]
> > [    2.832620] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > [    2.836846] phy_probe: phydev->irq =3D 17
> > [    2.840950] phy_probe: phy_drv_supports_irq =3D 0, phy_interrupt_is_=
valid =3D 1
> > [    2.848267] phy_probe: phydev->irq =3D -1
> > [    2.848267]
> > [    2.854059] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > [    2.858174] phy_probe: phydev->irq =3D -1
> > [    2.862253] phy_probe: phydev->irq =3D -1
> > [    2.862253]
> > [    2.868121] libphy: bcm63xx_enet MII bus: probed
> > [    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> > driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
> > irq=3DPOLL)
> >
> > Currently using kernel 5.4.99. I still have no idea what's going on.
> >
> Thanks for debugging. This confirms my assumption that the interrupt
> is overwritten in phy_probe(). I'm just scratching my head how
> phy_drv_supports_irq() can return 0. In 5.4.99 it's defined as:
>
> static bool phy_drv_supports_irq(struct phy_driver *phydrv)
> {
>         return phydrv->config_intr && phydrv->ack_interrupt;
> }
>
> And that's the PHY driver:
>
> static struct phy_driver bcm63xx_driver[] =3D {
> {
>         .phy_id         =3D 0x00406000,
>         .phy_id_mask    =3D 0xfffffc00,
>         .name           =3D "Broadcom BCM63XX (1)",
>         /* PHY_BASIC_FEATURES */
>         .flags          =3D PHY_IS_INTERNAL,
>         .config_init    =3D bcm63xx_config_init,
>         .ack_interrupt  =3D bcm_phy_ack_intr,
>         .config_intr    =3D bcm63xx_config_intr,
> }
>
> So both callbacks are set. Can you extend your debugging and check
> in phy_drv_supports_irq() which of the callbacks is missing?
>

Hi, both callbacks are missing on the first check. However on the next
calls they're there.

[    2.263909] libphy: Fixed MDIO Bus: probed
[    2.273026] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    2.277908] phy_device_create: dev->irq =3D 17
[    2.277908]
[    2.373104] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
[    2.377336] phy_probe: phydev->irq =3D 17
[    2.381445] phy_drv_supports_irq: phydrv->config_intr =3D 0,
phydrv->ack_interrupt =3D 0
[    2.389554] phydev->irq =3D PHY_POLL;
[    2.393186] phy_probe: phydev->irq =3D -1
[    2.393186]
[    2.398987] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
[    2.403108] phy_probe: phydev->irq =3D -1
[    2.407195] phy_drv_supports_irq: phydrv->config_intr =3D 1,
phydrv->ack_interrupt =3D 1
[    2.415314] phy_probe: phydev->irq =3D -1
[    2.415314]
[    2.421189] libphy: bcm63xx_enet MII bus: probed
[    2.426129] =3D=3D=3D=3D=3D=3D=3Dphy_connect=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[    2.430410] phy_drv_supports_irq: phydrv->config_intr =3D 1,
phydrv->ack_interrupt =3D 1
[    2.438537] phy_connect: phy_drv_supports_irq =3D 1
[    2.438537]
[    2.445284] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
irq=3DPOLL)

I also added the prints to phy_connect.

> Last but not least: Do you use a mainline kernel, or is it maybe
> a modified downstream kernel? In the latter case, please check
> in your kernel sources whether both callbacks are set.
>

It's a modified kernel, and the the callbacks are set. BTW I also
tested the kernel with no patches concerning to the ethernet driver.

Regards,
Daniel

>
>
> >> On which kernel version do you face this problem?
> >>
> > The kernel version 4.4 works ok. The minimum version where I found the
> > problem were the kernel 4.9.111, now using 5.4. And 5.10 also tested.
> >
> > Regards
> > Daniel
> >
> >>> Regards
> >>>> --
> >>>> Florian
> >>
>
