Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAB247E423
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 14:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348392AbhLWNf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 08:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243817AbhLWNfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 08:35:25 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26488C061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 05:35:25 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id a26-20020a9d6e9a000000b0058f37eeb861so4423312otr.9
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 05:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8DV8E/x5JbZmc6FHvGl5nX9a0jB68Jb6uzvbCd1TAMs=;
        b=nZH3FRtAaVA72y5weUGNJtN5nlrXrPj945PqCgDk9GuyJ/wE/Yr66aaDuVrVeaSrrM
         MNouTv+j4jzOL0C7WxI6zFQ38cHuwRezL5G/iHsZ1/m+/5G0el6JJUeOMEbpc4kHjUVj
         /ukcRDYdgabEwVu1H2/D/YvNKZllBg5L7LYKID3+msHBuqXoQMejReoSb8wdDsljpI7a
         eY/n4KfZ3KAP5PvgqTbbW79SH+rxW8/eOohN3hNFjCar6+Qr1yBEZqtl1/joSGGp2oKO
         FJ0Osf23xULQNvS9ZRKYFZgQne+Iw23oZKJTnhBBl20HGwirJnUidj3KsLGkqR5QLFzC
         BsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8DV8E/x5JbZmc6FHvGl5nX9a0jB68Jb6uzvbCd1TAMs=;
        b=MZwx5D9zq5GTNGBvGCW6cnd8k+1XKZNCRykL8geZc8QEE9Rh05A4ZKptR0EhK/VI61
         v+tIiKCFC41hznW4MpKWrAFAt9DVQxUCBHKbIE0yivp0C5BBy/uQKvzVb2fYDQL5iBzc
         Ylc+lpTru8HW5FtvIb+keY3Qf5E40xR2vbtrW9Rn/3YsW0LRE8Vwj0eU7EqeYWVdjvMA
         MDtnZrt4CL5SCt73dCmRaacpw5gZdVC4LFXJYhxmpz5TGxbnI657gm67QBkQ03iVO0kx
         o99eb8ScsIWNo8bJrbv72k2ACoJPUgdvcl2SZwORa3tMRA4eYVbxnr88+GgNmoSwPacU
         U14w==
X-Gm-Message-State: AOAM531825as1WGJWDGVQtL49p7ijnl8Ue1pljv9CAmCYX/xpTT89E6t
        Evwk+6heCHVRMzbLHDVc2dVtm/CabYLQSv50EodBkUlP/RA=
X-Google-Smtp-Source: ABdhPJyFtD96Q7S515WyfG2h90OLYaMaUMkD5KzAva8znKbiuxNtv3UNks8x29slg/CA7yZVYzVM+1kRXaOHZYEHg9w=
X-Received: by 2002:a05:6830:1e8f:: with SMTP id n15mr1398100otr.259.1640266523578;
 Thu, 23 Dec 2021 05:35:23 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbj93LvTu9RjVXD+NcT0JYoA42BC7pSHumtNJfniSobAqA@mail.gmail.com>
 <DB8PR04MB679571AF60C377BB1242D26BE67D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <CAMeyCbiYwB=SK3vvqdTEWhbnHwee8U6rfxzNs9B8-hyr45GhOw@mail.gmail.com> <DB8PR04MB6795B2D48F4B5FDC8BA4EBC0E67E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795B2D48F4B5FDC8BA4EBC0E67E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Thu, 23 Dec 2021 14:35:12 +0100
Message-ID: <CAMeyCbhTRuic6U8xnOg+oWJ_cSXduYZaV14vu8+ZWd_4XaXNaA@mail.gmail.com>
Subject: Re: net: fec: memory corruption caused by err_enet_mii_probe error path
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the hint to use of_mdiobus_register instead of the old way
with fec { phy-reset-gpios =3D ....}

This change could solve another issue with the smsc phys.
I think phy_reset_after_clk_enable does only something if the phy was
specified in the DT with reset-gpio =3D <
Coming from an older kernel I was using the fecs phy-reset-gpios and
mdio auto probing and therefore phy_reset_after_clk_enable did
nothing.
And my smsc phys need this reset after enet_out enable (PHY_RST_AFTER_CLK_E=
N).

int phy_reset_after_clk_enable(struct phy_device *phydev)
{
if (!phydev || !phydev->drv)
return -ENODEV;

if (phydev->drv->flags & PHY_RST_AFTER_CLK_EN) {
phy_device_reset(phydev, 1);
phy_device_reset(phydev, 0);
return 1;
}
return 0;
}

So I adapted the DT to specify the reset gpios.
BUT this solved not my issue with the not detected phy.
So i changed the generic
compatible =3D "ethernet-phy-ieee802.3-c22";
to the exact phy id
compatible =3D "ethernet-phy-id0007.c0f0";

=3D> Now the phy is detected on every boot

if (!is_c45 && !of_get_phy_id(child, &phy_id))
phy =3D phy_device_create(mdio, addr, phy_id, 0, NULL);
else
phy =3D get_phy_device(mdio, addr, is_c45);
if (IS_ERR(phy)) {
if (mii_ts)
unregister_mii_timestamper(mii_ts);
return PTR_ERR(phy);
}
rc =3D of_mdiobus_phy_device_register(mdio, phy, child, addr);

With a given phy id mdio probe will issue phy_device_create; otherwise
get_phy_device to read the id via mdio.

ethernet-phy@0 { reset-gpio =3D ....} gpio does not get
asserted/deasserted before the get_phy_device call.
Only the global mdio { reset-gpio =3D .... } gpio is asserted/deasserted
before the get_phy_device call.
So the phy does not get its reset after enet_out clock enable =3D> phy
is in bad state =3D> get_phy_device does not find the phy =3D> no
of_mdiobus_phy_device_register =3D> missing phy

I would need something like this in addition to ethernet-phy@0 {
reset-gpio =3D ....}
mdio { reset-gpio =3D <&gpio4 13 GPIO_ACTIVE_LOW &gpio2 7 GPIO_ACTIVE_LOW}
But mdio { reset-gpio } does only support a single gpio.

For now I am ok with the fixed phy ids.


&mac0 {
phy-mode =3D "rmii";
phy-handle =3D <&mac0_phy>;
phy-supply =3D <&reg_etn_3v3>;
pinctrl-names =3D "default";
pinctrl-0 =3D <&mac0_pins_a>, <&mac0_phy_reset_pin>, <&mac1_phy_reset_pin>;
status =3D "okay";


mdio {
#address-cells =3D <1>;
#size-cells =3D <0>;

mac0_phy: ethernet-phy@0 {
reg =3D <0>;
compatible =3D "ethernet-phy-id0007.c0f0";
reset-gpios =3D <&gpio4 13 GPIO_ACTIVE_LOW>;
reset-assert-us =3D <10000>;
reset-deassert-us =3D <30000>;
smsc,disable-energy-detect;
};

mac1_phy: ethernet-phy@1 {
reg =3D <1>;
compatible =3D "ethernet-phy-id0007.c0f0";
reset-gpios =3D <&gpio2 7 GPIO_ACTIVE_LOW>;
reset-assert-us =3D <10000>;
reset-deassert-us =3D <30000>;
smsc,disable-energy-detect;
};
};
};

On Thu, Dec 23, 2021 at 2:53 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrot=
e:
>
>
> Hi Kegl,
>
> > -----Original Message-----
> > From: Kegl Rohit <keglrohit@gmail.com>
> > Sent: 2021=E5=B9=B412=E6=9C=8822=E6=97=A5 19:06
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: netdev <netdev@vger.kernel.org>; Andrew Lunn <andrew@lunn.ch>
> > Subject: Re: net: fec: memory corruption caused by err_enet_mii_probe
> > error path
> >
> > On Wed, Dec 22, 2021 at 9:01 AM Joakim Zhang <qiangqing.zhang@nxp.com>
> > wrote:
> >
> > > > This error path frees the DMA buffers, BUT as far I could see it
> > > > does not stop the DMA engines.
> > > > =3D> open() fails =3D> frees buffers =3D> DMA still active =3D> MAC=
 receives
> > > > network packet =3D> DMA starts =3D> random memory corruption (use a=
fter
> > > > free) =3D> random kernel panics
> > >
> > > A question here, why receive path still active? MAC has not connected=
 to
> > PHY when this failure happened, should not see network activities.
> >
> > It is a imx.28 platform using the fec for dual ethernet eth0 & eth1.
> >
> > One of our devices (out of 10) eth1 did not detect a phy for eth1 on if=
up
> > ( fec_open() ) =3D> mdio error path =3D> random system crashes But the =
phy is
> > there and the link is good, only MDIO access failed.
> > phys have autoneg activated after reset. So the RX path is active, even=
 if the
> > fec driver says that there is no phy.
> >
> > Without attached ethernet cable the phy was also not detected, BUT the
> > system did not crash. =3D> Because no packets will arrive without attac=
hed
> > cable.
> >
> > So the main issue on our side is the not detected phy. And the other is=
sue is
> > the use after free in the error path.
>
> Thanks for you detailed explanation :)
>
> > I think the main issue has something to do with phy reset handling.
> > On a cold boot the eth1 phy is detected successfully. A warm restart ( =
reboot
> > -f ) will always lead to a not detected eth1 phy. The eth0 phy is alway=
s
> > detected.
> > From past experience the dual ethernet implementation in the driver was
> > not the most stable one. Maybe because of a smaller user base.
> > In our setup both phy reset lines are connected to gpios with the corre=
ct
> > entry in the mac0 & mac1 DT entry.
> > Revert of
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
hu
> > b.com%2Ftorvalds%2Flinux%2Fcommit%2F7705b5ed8adccd921423019e870df
> > 672fa423279%23diff-655f306656e7bccbec8fe6ebff2adf466bb8133f5bcb55111
> > 2d3fe37e50b1a15&amp;data=3D04%7C01%7Cqiangqing.zhang%40nxp.com%7C
> > 2f10c3ff43de4ccccc8708d9c53b037e%7C686ea1d3bc2b4c6fa92cd99c5c301635
> > %7C0%7C1%7C637757679518224181%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> > oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1
> > 000&amp;sdata=3DyIQBX3v6PRvPerVBhdDcRJpjt1aIiq%2BtL8RXfNmKs%2FA%3
> > D&amp;reserved=3D0
> > seems to get the phys in a correct state before the fec driver is probe=
d and
> > both phys are detected.
>
> You mean it always can detect both eth0 and eth1 PHY on a code boot, but =
eth1 PHY failed when do
> warm reset, it may deserve a further analyze the different for these two =
scenarios.
>
> I am not sure when you will hardware reset PHY on you platforms. For FEC =
driver, it seems only hardware
> reset PHY when probe MAC (please note PHY reset has moved to phylib, not =
recommend to do it in MAC driver),
> fec_probe->of_mdiobus_register->of_mdiobus_register_phy->of_mdiobus_phy_d=
evice_register->phy_device_register
>
> Generally, a hardware reset will trigger an auto-nego together, so I thin=
k PHY should in a correct state when you ifup the device,
> although, it will also trigger auto-nego when connected PHY. What I want =
to say is that you may need to check if the hardware reset
> at you side is suitable? Not sure you use single GPIO to control two PHYs=
 reset?
>
> Just some analysis, hope this can give you some hints.
>
> > > > So maybe fec_stop() as counterpart to fec_restart() is missing
> > > > before freeing the buffers?
> > > > err_enet_mii_probe:
> > > > fec_stop(ndev);
> > > > fec_enet_free_buffers(ndev);
> > > >
> > > > Issue happend with 5.10.83 and should also also happen with current
> > master.
> > >
> > > It's fine for me, please see if anyone else has some comments. If not=
,
> > please cook a formal patch, thanks.
> > So fec_stop is the right guess to stop the rx/tx dma rings.
> >
> > Other paths use netif_tx_lock_bh before calling fec_stop().
> > I don't think this is necessary because netif_tx_start_all_queues() was=
 not
> > called before in this error path case?
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
hu
> > b.com%2Ftorvalds%2Flinux%2Fblob%2Fmaster%2Fdrivers%2Fnet%2Fethern
> > et%2Ffreescale%2Ffec_main.c%23L3207&amp;data=3D04%7C01%7Cqiangqing.z
> > hang%40nxp.com%7C2f10c3ff43de4ccccc8708d9c53b037e%7C686ea1d3bc2b4
> > c6fa92cd99c5c301635%7C0%7C1%7C637757679518224181%7CUnknown%7CT
> > WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLC
> > JXVCI6Mn0%3D%7C1000&amp;sdata=3DKfDdWkJ76Tvsd7nmXpNhdrY%2Fz9x24
> > UYJl6fxjwvqtYA%3D&amp;reserved=3D0
>
> ACK, please submit a patch if you test there is no regressions.
>
> Best Regards,
> Joakim Zhang
> > index 1b1f7f2a6..8f208b4a9 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3211,8 +3211,9 @@ fec_enet_open(struct net_device *ndev)
> >
> >         return 0;
> >
> >  err_enet_mii_probe:
> > +       fec_stop(ndev);
> >         fec_enet_free_buffers(ndev);
> >  err_enet_alloc:
> >         fec_enet_clk_enable(ndev, false);
> >  clk_enable:

On Thu, Dec 23, 2021 at 2:53 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrot=
e:
>
>
> Hi Kegl,
>
> > -----Original Message-----
> > From: Kegl Rohit <keglrohit@gmail.com>
> > Sent: 2021=E5=B9=B412=E6=9C=8822=E6=97=A5 19:06
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: netdev <netdev@vger.kernel.org>; Andrew Lunn <andrew@lunn.ch>
> > Subject: Re: net: fec: memory corruption caused by err_enet_mii_probe
> > error path
> >
> > On Wed, Dec 22, 2021 at 9:01 AM Joakim Zhang <qiangqing.zhang@nxp.com>
> > wrote:
> >
> > > > This error path frees the DMA buffers, BUT as far I could see it
> > > > does not stop the DMA engines.
> > > > =3D> open() fails =3D> frees buffers =3D> DMA still active =3D> MAC=
 receives
> > > > network packet =3D> DMA starts =3D> random memory corruption (use a=
fter
> > > > free) =3D> random kernel panics
> > >
> > > A question here, why receive path still active? MAC has not connected=
 to
> > PHY when this failure happened, should not see network activities.
> >
> > It is a imx.28 platform using the fec for dual ethernet eth0 & eth1.
> >
> > One of our devices (out of 10) eth1 did not detect a phy for eth1 on if=
up
> > ( fec_open() ) =3D> mdio error path =3D> random system crashes But the =
phy is
> > there and the link is good, only MDIO access failed.
> > phys have autoneg activated after reset. So the RX path is active, even=
 if the
> > fec driver says that there is no phy.
> >
> > Without attached ethernet cable the phy was also not detected, BUT the
> > system did not crash. =3D> Because no packets will arrive without attac=
hed
> > cable.
> >
> > So the main issue on our side is the not detected phy. And the other is=
sue is
> > the use after free in the error path.
>
> Thanks for you detailed explanation :)
>
> > I think the main issue has something to do with phy reset handling.
> > On a cold boot the eth1 phy is detected successfully. A warm restart ( =
reboot
> > -f ) will always lead to a not detected eth1 phy. The eth0 phy is alway=
s
> > detected.
> > From past experience the dual ethernet implementation in the driver was
> > not the most stable one. Maybe because of a smaller user base.
> > In our setup both phy reset lines are connected to gpios with the corre=
ct
> > entry in the mac0 & mac1 DT entry.
> > Revert of
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
hu
> > b.com%2Ftorvalds%2Flinux%2Fcommit%2F7705b5ed8adccd921423019e870df
> > 672fa423279%23diff-655f306656e7bccbec8fe6ebff2adf466bb8133f5bcb55111
> > 2d3fe37e50b1a15&amp;data=3D04%7C01%7Cqiangqing.zhang%40nxp.com%7C
> > 2f10c3ff43de4ccccc8708d9c53b037e%7C686ea1d3bc2b4c6fa92cd99c5c301635
> > %7C0%7C1%7C637757679518224181%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> > oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1
> > 000&amp;sdata=3DyIQBX3v6PRvPerVBhdDcRJpjt1aIiq%2BtL8RXfNmKs%2FA%3
> > D&amp;reserved=3D0
> > seems to get the phys in a correct state before the fec driver is probe=
d and
> > both phys are detected.
>
> You mean it always can detect both eth0 and eth1 PHY on a code boot, but =
eth1 PHY failed when do
> warm reset, it may deserve a further analyze the different for these two =
scenarios.
>
> I am not sure when you will hardware reset PHY on you platforms. For FEC =
driver, it seems only hardware
> reset PHY when probe MAC (please note PHY reset has moved to phylib, not =
recommend to do it in MAC driver),
> fec_probe->of_mdiobus_register->of_mdiobus_register_phy->of_mdiobus_phy_d=
evice_register->phy_device_register
>
> Generally, a hardware reset will trigger an auto-nego together, so I thin=
k PHY should in a correct state when you ifup the device,
> although, it will also trigger auto-nego when connected PHY. What I want =
to say is that you may need to check if the hardware reset
> at you side is suitable? Not sure you use single GPIO to control two PHYs=
 reset?
>
> Just some analysis, hope this can give you some hints.
>
> > > > So maybe fec_stop() as counterpart to fec_restart() is missing
> > > > before freeing the buffers?
> > > > err_enet_mii_probe:
> > > > fec_stop(ndev);
> > > > fec_enet_free_buffers(ndev);
> > > >
> > > > Issue happend with 5.10.83 and should also also happen with current
> > master.
> > >
> > > It's fine for me, please see if anyone else has some comments. If not=
,
> > please cook a formal patch, thanks.
> > So fec_stop is the right guess to stop the rx/tx dma rings.
> >
> > Other paths use netif_tx_lock_bh before calling fec_stop().
> > I don't think this is necessary because netif_tx_start_all_queues() was=
 not
> > called before in this error path case?
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
hu
> > b.com%2Ftorvalds%2Flinux%2Fblob%2Fmaster%2Fdrivers%2Fnet%2Fethern
> > et%2Ffreescale%2Ffec_main.c%23L3207&amp;data=3D04%7C01%7Cqiangqing.z
> > hang%40nxp.com%7C2f10c3ff43de4ccccc8708d9c53b037e%7C686ea1d3bc2b4
> > c6fa92cd99c5c301635%7C0%7C1%7C637757679518224181%7CUnknown%7CT
> > WFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLC
> > JXVCI6Mn0%3D%7C1000&amp;sdata=3DKfDdWkJ76Tvsd7nmXpNhdrY%2Fz9x24
> > UYJl6fxjwvqtYA%3D&amp;reserved=3D0
>
> ACK, please submit a patch if you test there is no regressions.
>
> Best Regards,
> Joakim Zhang
> > index 1b1f7f2a6..8f208b4a9 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3211,8 +3211,9 @@ fec_enet_open(struct net_device *ndev)
> >
> >         return 0;
> >
> >  err_enet_mii_probe:
> > +       fec_stop(ndev);
> >         fec_enet_free_buffers(ndev);
> >  err_enet_alloc:
> >         fec_enet_clk_enable(ndev, false);
> >  clk_enable:
