Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F747199CAD
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgCaRRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:17:06 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55511 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCaRRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:17:05 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jJKVZ-0004gz-3s; Tue, 31 Mar 2020 19:17:01 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jJKVX-0007ei-6x; Tue, 31 Mar 2020 19:16:59 +0200
Date:   Tue, 31 Mar 2020 19:16:59 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Jander <david@protonic.nl>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200331171659.yytmgrtday3243fj@pengutronix.de>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <20200331104459.6857474e@erd988>
 <20200331170300.GQ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w5qomzsamt5uzh2a"
Content-Disposition: inline
In-Reply-To: <20200331170300.GQ25745@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:10:45 up 137 days,  8:29, 156 users,  load average: 0.03, 0.03,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w5qomzsamt5uzh2a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2020 at 06:03:00PM +0100, Russell King - ARM Linux admin wr=
ote:
> On Tue, Mar 31, 2020 at 10:44:59AM +0200, David Jander wrote:
> > I have checked with the datasheet of the AR8035, and AFAICS, what the c=
ode
> > does is this:
> >=20
> >  - Disable the SmartEEE feature of the phy. The comment in the code imp=
lies
> >    that for some reason it doesn't work, but the reason itself is not g=
iven.
> >    Anyway, disabling SmartEEE should IMHO opinion be controlled by a DT
> >    setting. There is no reason to believe this problem is specific to t=
he
> >    i.MX6. Besides, it is a feature of the phy, so it seems logical to e=
xpose
> >    that via the DT. Once that is done, it has no place here.
> >=20
> >  - Set the external clock output to 125MHz. This is needed because the =
i.MX6
> >    needs a 125MHz reference clock input. But it is not a requirement to=
 use
> >    this output. It is perfectly fine and possible to design a board tha=
t uses
> >    an external oscillator for this. It is also possible that an i.MX6 d=
esign
> >    has such a phy connected to a MAC behind a switch or some other inte=
rface.
> >    Independent of i.MX6 this setting can also be necessary for other ha=
rdware
> >    designs, based on different SoC's. In summary, this is a feature of =
the
> >    specific hardware design at hand, and has nothing to do with the i.M=
X6
> >    specifically. This should definitely be exposed through the DT and n=
ot be
> >    here.
> >=20
> >  - Enable TXC delay. To clarify, the RGMII specification version 1 spec=
ified
> >    that the RXC and TXC traces should be routed long enough to introduc=
e a
> >    certain delay to the clock signal, or the delay should be introduced=
 via
> >    other means. In a later version of the spec, a provision was given f=
or MAC
> >    or PHY devices to generate this delay internally. The i.MX6 MAC inte=
rface
> >    is unable to generate the required delay internally, so it has to be=
 taken
> >    care of either by the board layout, or by the PHY device. This is the
> >    crucial point: The amount of delay set by the PHY delay register dep=
ends on
> >    the board layout. It should NEVER be hard-coded in SoC setup code. T=
he
> >    correct way is to specify it in the DT. Needless to say that this to=
o,
> >    isn't i.MX6-specific.
>=20
> Let's say this is simple to do, shall we?
>=20
> So, if I disable the call to ar8031_phy_fixup() from ar8035_phy_fixup(),
> and add the following to the imx6qdl-sr-som.dtsi fragment:
>=20
> &fec {
> ...
>         phy-handle =3D <&phy>;
>=20
>         mdio {
>                 #address-cells =3D <1>;
>                 #size-cells =3D <0>;
>=20
>                 phy: ethernet-phy@0 {
>                         reg =3D <0>;
>                         qca,clk-out-frequency =3D <125000000>;
>                 };
>         };
> };
>=20
> Note that phy-mode is already RGMII-ID.  This should work, right?
>=20
> The link still comes up, which is good, but the PHY registers for
> the clock output are wrong.
>=20
> MMD 3 register 0x8016 contains 0xb282, not 0xb29a which it has
> _with_ the quirk - and thus the above clock frequency stated in
> DT is not being selected.  Forcing this register to the right
> value restores networking.
>=20
> Yes, the PHY driver is being used:
>=20
> Qualcomm Atheros AR8035 2188000.ethernet-1:00: attached PHY driver [Qualc=
omm Atheros AR8035] (mii_bus:phy_addr=3D2188000.ethernet-1:00, irq=3DPOLL)
>=20
> So that's not the problem.
>=20
> Adding some debug shows that the phy_device that is being used is
> the correct one:
>=20
> Qualcomm Atheros AR8035 2188000.ethernet-1:00: node=3D/soc/aips-bus@21000=
00/ethernet@2188000/mdio/ethernet-phy@0
>=20
> and it is correctly parsing the clk-out-frequency property:
>=20
> Qualcomm Atheros AR8035 2188000.ethernet-1:00: cof=3D0 125000000
>=20
> When we get to attaching the PHY however:
>=20
> Qualcomm Atheros AR8035 2188000.ethernet-1:00: clk_25m_mask=3D0004 clk_25=
m_reg=3D0000
>=20
> which is just wrong.  That's because:
>=20
>                 if (at803x_match_phy_id(phydev, ATH8030_PHY_ID) ||
>                     at803x_match_phy_id(phydev, ATH8035_PHY_ID)) {
>                         priv->clk_25m_reg &=3D ~AT8035_CLK_OUT_MASK;
>                         priv->clk_25m_mask &=3D ~AT8035_CLK_OUT_MASK;
>                 }
>=20
> is patently untested - those "~" should not be there.  These masks
> are one-bits-set for the values that comprise the fields, not
> zero-bits-set.
>=20
> So, I see a patch series is going to be necessary to fix the cockup(s)
> in the PHY driver before we can do anything with DT files.

I'm glad you found this issues :D I made a patch to fix it last week.
And it was a reason to send a patch for disabling _all_ fixups :)

Regards,
Oleksij

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--w5qomzsamt5uzh2a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6DewYACgkQ4omh9DUa
UbNshA/+M69u9hhXoysk7kn7c2ywjtPiC1uN0fqc4VgExPuSbszbRa3BKCQayUWL
JIyT9R7ZjrCyRNrGwnO5ow3ecZ5zpgcMx2RYbGLFDsf7Skwe5JMBY0BVSX9PUxlD
GNuMjBe4bDf5q/Ynlj5tSWQnm8/r/86DyAAfIyJFvqlIoJPf/JMtH3OIFSRTLcn+
z9TEy6z0a0jnrAUzmP/qJYQUHyptpN25OTudTvW3K/e0HWQaS47/geFLQ1K+ONy3
ZNic2RVT5uEdR1CloL7uuvO1V89BOgaMJw/rCDK+FX1BXdgW0ib1PIDmGB+FEb3w
KX2WxDLJEGeIgjex/Sf0m6OGnyXpy5lRswHoYdKalHWfHnbSfTuqa0UTjXtXk+r4
B+ZdRSZ1SFW4Bk0pmZKyZLTKOinJV1iK0TV357ZiS+FNwSVXKD3GFFFNQjLxlGbf
yiELU9gRTgN5OLuQqYUynOxqxpvLQqJCHtgzpoClRpSIkjjYL+AAUSYCCDwdoxgS
7DGTVyFAcYHFeJISVnPgCTERLM+z1WgrRgVc0Ikd28nKoEjtCMp79XN4Ku6iv5il
hj1tVXiQYBcv5hpI1zwPRPjHKcnk2DPkB5ZwqhO2ptpI2W53BjvNNWUoBHFjCCy7
4I8Dn+Cw1KiBZqZRT8JgQug0torRM7iN4G/fzRMR+WoqYxGvzHE=
=8dpF
-----END PGP SIGNATURE-----

--w5qomzsamt5uzh2a--
