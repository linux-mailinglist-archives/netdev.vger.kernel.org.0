Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C416F3247AD
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhBXXzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhBXXzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 18:55:49 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480B2C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 15:55:08 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id p193so3653204yba.4
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 15:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bbx6OrhQ3PRUKTC4XuQyzrzUOzAwTjsnhh7ILY62Dio=;
        b=OF66Kxo3jKts9hXT0z+TaKABNLYcvTb087k38OEdw6SqdELuukfOOdxc6D5vFi4psq
         z0PrZ8HEf2CAVsqFB9tRDdiTg4Fc+bYeqc8v8e7S9HdVrQlqLxbScfcbZ6bHvS0Syy/U
         IxjpCZelXqTfg9ypTGx0taDERnxNFIdDJH/gffvso0M0W+Tdvt7uPZsBmT4UuxLieMVQ
         QuKQhUvBTXmCamvHD+MIVl9CECYe45CmZxu7BBAvouFT0niPiiR+g4ETIvlZNEy7ZckO
         i2nrNWFJ2gpDxHyyUJBQfWYyXLE0BAD9V3ufPUB4GJYsAsYTNQ9dWfadXaRgNBeyk8gO
         xUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bbx6OrhQ3PRUKTC4XuQyzrzUOzAwTjsnhh7ILY62Dio=;
        b=r4kK0b2xcj0UjNZPQygARcjQESP088jLGg5fhRv63F4NoUcdaVXpoWxhMz8NQ4PKh9
         /aD5cJmSw5fkgnsw8EWwW6si08iy6P/L0Gd5lOL02CwDXdFIyo2WREcmVsqWkryieeYA
         iVkpY2m1zlfmvq9yCX75kVGdS72Z2E68jf8hBpdx87h4i3ESIdzVuQZ1FA3406sZrITT
         789HmwBLV/j5kr47wkwYYIqP0uC8C3ALygWuqWis/aEZIefnU3A7SYJS+yHwKtUKgaNK
         NZ2ncvCMdRRUn2albRsst6DapzEyDUjQSI+bAkkIL3c5C2hsrHMUUzaomB9ZMgJ1Npcv
         L8FQ==
X-Gm-Message-State: AOAM533nLBpLlxpxFricFPmvNEfNI6KCJSEyTPmtykzobs4qWBrjX532
        DOQba9xFr6huCmfZGfI3CEN3DRJc1N+sMmGJnCg=
X-Google-Smtp-Source: ABdhPJynu+CoqSKnS+EoG1jodFkv9U/4a0Jcl6blWRGNJv6vXYJa2SMPCKJbsBob4Zgro6fJLIS32/s/JiLdAjYppb8=
X-Received: by 2002:a25:4054:: with SMTP id n81mr190933yba.39.1614210907534;
 Wed, 24 Feb 2021 15:55:07 -0800 (PST)
MIME-Version: 1.0
References: <2323124.5UR7tLNZLG@tool> <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
 <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com>
In-Reply-To: <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com>
From:   =?UTF-8?Q?Daniel_Gonz=C3=A1lez_Cabanelas?= <dgcbueu@gmail.com>
Date:   Thu, 25 Feb 2021 00:54:56 +0100
Message-ID: <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El mi=C3=A9, 24 feb 2021 a las 23:01, Florian Fainelli
(<f.fainelli@gmail.com>) escribi=C3=B3:
>
>
>
> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
> > On 24.02.2021 16:44, Daniel Gonz=C3=A1lez Cabanelas wrote:
> >> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As=
 a
> >> result of this it works in polling mode.
> >>
> >> Fix it using the phy_device structure to assign the platform IRQ.
> >>
> >> Tested under a BCM6348 board. Kernel dmesg before the patch:
> >>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadc=
om
> >>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, irq=
=3DPOLL)
> >>
> >> After the patch:
> >>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadc=
om
> >>               BCM63XX (1)] (mii_bus:phy_addr=3Dbcm63xx_enet-0:01, irq=
=3D17)
> >>
> >> Pluging and uplugging the ethernet cable now generates interrupts and =
the
> >> PHY goes up and down as expected.
> >>
> >> Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
> >> ---
> >> changes in V2:
> >>   - snippet moved after the mdiobus registration
> >>   - added missing brackets
> >>
> >>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
> >>  1 file changed, 11 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/ne=
t/ethernet/broadcom/bcm63xx_enet.c
> >> index fd876721316..dd218722560 100644
> >> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> >> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_devi=
ce *pdev)
> >>               * if a slave is not present on hw */
> >>              bus->phy_mask =3D ~(1 << priv->phy_id);
> >>
> >> -            if (priv->has_phy_interrupt)
> >> +            ret =3D mdiobus_register(bus);
> >> +
> >> +            if (priv->has_phy_interrupt) {
> >> +                    phydev =3D mdiobus_get_phy(bus, priv->phy_id);
> >> +                    if (!phydev) {
> >> +                            dev_err(&dev->dev, "no PHY found\n");
> >> +                            goto out_unregister_mdio;
> >> +                    }
> >> +
> >>                      bus->irq[priv->phy_id] =3D priv->phy_interrupt;
> >> +                    phydev->irq =3D priv->phy_interrupt;
> >> +            }
> >>
> >> -            ret =3D mdiobus_register(bus);
> >
> > You shouldn't have to set phydev->irq, this is done by phy_device_creat=
e().
> > For this to work bus->irq[] needs to be set before calling mdiobus_regi=
ster().
>
> Yes good point, and that is what the unchanged code does actually.
> Daniel, any idea why that is not working?

Hi Florian, I don't know. bus->irq[] has no effect, only assigning the
IRQ through phydev->irq works.

I can resend the patch  without the bus->irq[] line since it's
pointless in this scenario.

Regards
> --
> Florian
