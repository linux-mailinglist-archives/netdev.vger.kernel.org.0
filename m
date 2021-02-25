Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070D13253A8
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhBYQiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhBYQh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:37:29 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727FEC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 08:36:49 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id x19so6028452ybe.0
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 08:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R0j+y0InnDVxpqdZ4QQKZJfvIS1oDwBnK/nAzy0xUXc=;
        b=tiPetMhw46l8lfKjRNQa7dP60FxShVewRpo8nQNjS9NbV8QEGdHeC72MxlY6pYAiOx
         7M+E8orfS0/qp2lvx/KuJD016xYg4bKM8BtWiKefollVsm41W7yCh3CjIS3JhhOuw7jR
         R2wnUVAUkcFCRmkxzKfU5hK1jMsDCZ34b/PZvEBeQBRLOaZwGDcTHbD0sljR4MB80RS3
         BtFh7MURl5A7ia1ilyXHS/UQTIJMYxTLRr83zAGvlCE+4L6dm1z8WchRJXkpP8osP+9w
         ZfXzOeHp4N3Ql1WrorX/UfZHbomZVhs0DjGhJgKmXEFEFk4UJyOjQEKXu5+QZ+GaqK01
         2q+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R0j+y0InnDVxpqdZ4QQKZJfvIS1oDwBnK/nAzy0xUXc=;
        b=tTQo+PWstozXJA3YyQUzRcvQWRiq8Y34q0tq8qf/0+YH7jqftAtpCF1CTc5hoo5VEv
         3WkXf8I1y+Q/AktGjVl1TQWdPg53Q29QfjXJa9o9DdFIVcEpPubxPUaKCiOismnfXeWz
         0OHvlXvsefyIveX3ORg7Vd2SNe4wWGtHNXWkzl0mbQBwShRl7z5+ZLMq+FlPwgNNofXW
         u6mPZfIeQDx8hLfhISHLfE0yRQYl81ZKhCmSc8uXP1M8BZZ8gerx+7GHSe22ebFRQpSX
         wrSOyEnevtB5253dMW0JP59YZz1udiJKJp0BH2Ms9KxqofTHaRX4HwtJWBKwBZOMJVEg
         1thw==
X-Gm-Message-State: AOAM533n5WVCfodldinI+I8vCfL1XTcCw9LuXPzVLtrXoEGLdEWm+rBw
        NKsBi3KnMtc4bibTNMevcpJrGMWHCd32lRqqTZM=
X-Google-Smtp-Source: ABdhPJyswl3qsVJBPQv1GRUBY0eGrI6aR0tvox6hX3EkFw9ulMh4Gpnr5hio4vmM1zlINz3XnPW3uG9bkyp8ppjNyyw=
X-Received: by 2002:a25:4054:: with SMTP id n81mr4937802yba.39.1614271008613;
 Thu, 25 Feb 2021 08:36:48 -0800 (PST)
MIME-Version: 1.0
References: <2323124.5UR7tLNZLG@tool> <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
 <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com> <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
 <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com>
In-Reply-To: <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Thu, 25 Feb 2021 17:36:37 +0100
Message-ID: <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El jue, 25 feb 2021 a las 8:22, Heiner Kallweit
(<hkallweit1@gmail.com>) escribi=C3=B3:
>
> On 25.02.2021 00:54, Daniel Gonz=C3=A1lez Cabanelas wrote:
> > El mi=C3=A9, 24 feb 2021 a las 23:01, Florian Fainelli
> > (<f.fainelli@gmail.com>) escribi=C3=B3:
> >>
> >>
> >>
> >> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
> >>> On 24.02.2021 16:44, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >>>> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. =
As a
> >>>> result of this it works in polling mode.
> >>>>
> >>>> Fix it using the phy_device structure to assign the platform IRQ.
> >>>>
> >>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
> >>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broa=
dcom
> >>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, ir=
q=3DPOLL)
> >>>>
> >>>> After the patch:
> >>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broa=
dcom
> >>>>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, ir=
q=3D17)
> >>>>
> >>>> Pluging and uplugging the ethernet cable now generates interrupts an=
d the
> >>>> PHY goes up and down as expected.
> >>>>
> >>>> Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
> >>>> ---
> >>>> changes in V2:
> >>>>   - snippet moved after the mdiobus registration
> >>>>   - added missing brackets
> >>>>
> >>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
> >>>>  1 file changed, 11 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/=
net/ethernet/broadcom/bcm63xx_enet.c
> >>>> index fd876721316..dd218722560 100644
> >>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_de=
vice *pdev)
> >>>>               * if a slave is not present on hw */
> >>>>              bus->phy_mask =3D ~(1 << priv->phy_id);
> >>>>
> >>>> -            if (priv->has_phy_interrupt)
> >>>> +            ret =3D mdiobus_register(bus);
> >>>> +
> >>>> +            if (priv->has_phy_interrupt) {
> >>>> +                    phydev =3D mdiobus_get_phy(bus, priv->phy_id);
> >>>> +                    if (!phydev) {
> >>>> +                            dev_err(&dev->dev, "no PHY found\n");
> >>>> +                            goto out_unregister_mdio;
> >>>> +                    }
> >>>> +
> >>>>                      bus->irq[priv->phy_id] =3D priv->phy_interrupt;
> >>>> +                    phydev->irq =3D priv->phy_interrupt;
> >>>> +            }
> >>>>
> >>>> -            ret =3D mdiobus_register(bus);
> >>>
> >>> You shouldn't have to set phydev->irq, this is done by phy_device_cre=
ate().
> >>> For this to work bus->irq[] needs to be set before calling mdiobus_re=
gister().
> >>
> >> Yes good point, and that is what the unchanged code does actually.
> >> Daniel, any idea why that is not working?
> >
> > Hi Florian, I don't know. bus->irq[] has no effect, only assigning the
> > IRQ through phydev->irq works.
> >
> > I can resend the patch  without the bus->irq[] line since it's
> > pointless in this scenario.
> >
>
> It's still an ugly workaround and a proper root cause analysis should be =
done
> first. I can only imagine that phydev->irq is overwritten in phy_probe()
> because phy_drv_supports_irq() is false. Can you please check whether
> phydev->irq is properly set in phy_device_create(), and if yes, whether
> it's reset to PHY_POLL in phy_probe()?.
>

Hi Heiner, I added some kernel prints:

[    2.712519] libphy: Fixed MDIO Bus: probed
[    2.721969] =3D=3D=3D=3D=3D=3D=3Dphy_device_create=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[    2.726841] phy_device_create: dev->irq =3D 17
[    2.726841]
[    2.832620] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
[    2.836846] phy_probe: phydev->irq =3D 17
[    2.840950] phy_probe: phy_drv_supports_irq =3D 0, phy_interrupt_is_vali=
d =3D 1
[    2.848267] phy_probe: phydev->irq =3D -1
[    2.848267]
[    2.854059] =3D=3D=3D=3D=3D=3D=3Dphy_probe=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
[    2.858174] phy_probe: phydev->irq =3D -1
[    2.862253] phy_probe: phydev->irq =3D -1
[    2.862253]
[    2.868121] libphy: bcm63xx_enet MII bus: probed
[    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01,
irq=3DPOLL)

Currently using kernel 5.4.99. I still have no idea what's going on.

> On which kernel version do you face this problem?
>
The kernel version 4.4 works ok. The minimum version where I found the
problem were the kernel 4.9.111, now using 5.4. And 5.10 also tested.

Regards
Daniel

> > Regards
> >> --
> >> Florian
>
