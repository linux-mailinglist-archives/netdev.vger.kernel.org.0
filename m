Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BF0205136
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 13:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbgFWLtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 07:49:36 -0400
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:21252
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732464AbgFWLtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 07:49:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mY3OaUtNG42nAak1LoCXIWiwF372kfqfg0umLyTiqx98f9EzLAFqEiwaRXBby08DO1EDbH3m9zzzQF7GqYh4xUSprwASNuxZoaK5Y10xmM5RNn6vw2GpUuqRHjxY8M5RUVY9piZK5tUmkhHN7NNXL/F9bj0PFORc5csEujxxVdzCtyvWCYViYEHfqCIOxSO3Ic2dKQv8bg3Acih4oVDUYBXtwHDfvpZray04MOOToxGr2xM3CRFCQmrVXFakGyONcDrTtV4pKpxxUaD9PNHQ2C3SEMdjcmJpTWWva4rL84jCoKpeKyZGSynU1bkzl1pBIz28nehvSIqGPsrsoe/JWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAEwwy2Nh8k0m0W7u+nqOW9IDlKXxzEeZRT5AQeYkfQ=;
 b=B9/tIltq1kiwFoPjnxzyegDnAIBDetMWCyGHB4SnrNC/1OuwKcTc2WxP5tYWDSSUciZOW8qNOkJ9/h1YkPJApCC5ilbKW2eRTtRypE/2l5oC6RbCFDhzCtnz3jBhswxY/1Fm2IzAGOO9SlgDw7aqUUv0SWmloHw4jU+w4YV6NeQmCpGzkG0641N6oCaOUrv780lrVwdmTsKAkKPcDFD6oVCKbjdHIVSkfH4d2yEdZy88fC0mU8EH+VE/uIuqrnLxwsqY04WyhreRyOIKAoRQzRxhWkrrw4+LVayMCE+XNFhFJaKs5d3CfhjCXAQkUym9HTE457uiv2/J9plULF963g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAEwwy2Nh8k0m0W7u+nqOW9IDlKXxzEeZRT5AQeYkfQ=;
 b=JHPPNazucEp3o5B7+fY0O8zpqTmti5Udx513EmQ6YvwY1wL7lEDRTlge+Pdw9HYlEn412fj/xPme5grWGoQYBRCTzc3W5VhK2j2f7RhiimgTymASyjVtYQSFDg7Veo+Ga5mfAnT5fJai5a6ybVvi02uiJe5F0/knyPOuEKuemYc=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 11:49:28 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 11:49:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: RE: [PATCH net-next v3 4/9] net: phy: add Lynx PCS module
Thread-Topic: [PATCH net-next v3 4/9] net: phy: add Lynx PCS module
Thread-Index: AQHWSB8i6O1VV8JY/EKrA1u100I5/KjkauQAgAGhaOA=
Date:   Tue, 23 Jun 2020 11:49:28 +0000
Message-ID: <VI1PR0402MB387117BC6F2B53E521F6D7EBE0940@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-5-ioana.ciornei@nxp.com>
 <20200622101200.GC1551@shell.armlinux.org.uk>
In-Reply-To: <20200622101200.GC1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3c5b0690-6b71-45ec-1a8f-08d8176b7c18
x-ms-traffictypediagnostic: VI1PR0402MB2815:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2815C51E6C223F75ACAECF1EE0940@VI1PR0402MB2815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g7oyO5Deos2UtFIbh1lEI9OjrKlI6bt0TyaNhsXyEIeV9MVSUp8+yKUR5+TtDM3vzLtR42un6LLiPFUfmx3xsIrrIbGZK8oMhuzXFsotsIceN57smMadTFRuueGwQJxM4Wz7QFldiTeZtoe/jid+t/v2ON90CaArwwak7vuhU25d3j2FCyyVhcHzhOuf95Ju6ykc4A+9XgPKLP4GZKDMhs2B5NIoUeL+bb5ToVIhObZy1gPSkc/pTb1KxDPQFdgZ3+SVJIUhXuRPXw+qgWvbFQ5YVcVnIOd+7kpx8ho6V5Ml2W4/bnoKXYrKZnqGMQNO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(5660300002)(8936002)(54906003)(2906002)(64756008)(66476007)(66946007)(30864003)(4326008)(83380400001)(66556008)(55016002)(9686003)(8676002)(186003)(33656002)(498600001)(86362001)(44832011)(76116006)(7696005)(52536014)(6916009)(6506007)(71200400001)(26005)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dH6pPRGfBR4VJGJguH1TbLzRrJCY7wsX1ZfuhFm0E2xGJUEANrLe5ADgmCiP0f245UmzKHIpSnEcrrcjNwt21A7tXw5aG/zGayhNnlafLUX9YjalzC/fmR9B3SMEtB2WIQMei9+TQhcP7bNB83AsBmDLJWMmHs9l/L7BdSvLchzWckT2VC9EXqjwmvMIx7lGFR1BajLjDH0iCNEMK+rqKeYszUOvSYoEeQJYxUSy9Eqz66XIXGMjIskrNigF8+nxy+lr+6fv3wW5UBaQ5x6FOXfaMC73syGN7bKnkzgrIrbKEAzG8bOEOoQsQVW+D0fYpsISB0v95pOYty3SAv3Aw3vXw6x4FC0A44mN8MHAdDlh3D5zpu+z5ySa4fB5tupybSUzSCjOil1kBkNJ72+/nmWsa3/BUx9BlrWkY78+7deQCdJfaoGjrTLeW67LNkyCrJFFQ/YB9Kvl+9Newbq/+92MYzca7xbT3VUjO1krmMc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5b0690-6b71-45ec-1a8f-08d8176b7c18
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 11:49:28.2499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 22BH6z4EzGmGy7Ba5oce9J1gTFmsqDt7fSugTGgefDj1UOUAtszB+HAhER1/dDWX12dHmOfQfxZXq2+BOftzgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next v3 4/9] net: phy: add Lynx PCS module
>=20
> On Mon, Jun 22, 2020 at 01:54:46AM +0300, Ioana Ciornei wrote:
> > Add a Lynx PCS module which exposes the necessary operations to drive
> > the PCS using PHYLINK.
> >
> > The majority of the code is extracted from the Felix DSA driver, which
> > will be also modified in a later patch, and exposed as a separate
> > module for code reusability purposes.
> >
> > At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> > SGMII, QSGMII and 2500Base-X (only w/o in-band AN) are supported by
> > the Lynx PCS module since these were also supported by Felix.
> >
> > The module can only be enabled by the drivers in need and not user
> > selectable.
> >
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > Changes in v2:
> >  * got rid of the mdio_lynx_pcs structure and directly exported the
> > functions without the need of an indirection
> >  * solved the broken allmodconfig build test by making the module
> > tristate instead of bool
> >
> > Changes in v3:
> >  * renamed the file to pcs-lynx.c
> >
> >
> >  MAINTAINERS                |   7 +
> >  drivers/net/phy/Kconfig    |   6 +
> >  drivers/net/phy/Makefile   |   1 +
> >  drivers/net/phy/pcs-lynx.c | 337
> +++++++++++++++++++++++++++++++++++++
> >  include/linux/pcs-lynx.h   |  25 +++
> >  5 files changed, 376 insertions(+)
> >  create mode 100644 drivers/net/phy/pcs-lynx.c  create mode 100644
> > include/linux/pcs-lynx.h
> >

(...)

> > diff --git a/drivers/net/phy/pcs-lynx.c b/drivers/net/phy/pcs-lynx.c
> > new file mode 100644 index 000000000000..23bdd9db4340
> > --- /dev/null
> > +++ b/drivers/net/phy/pcs-lynx.c
> > @@ -0,0 +1,337 @@
> > +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> > +/* Copyright 2020 NXP
> > + * Lynx PCS MDIO helpers
> > + */
> > +
> > +#include <linux/mdio.h>
> > +#include <linux/phylink.h>
> > +#include <linux/pcs-lynx.h>
> > +
> > +#define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz
> */
> > +#define SGMII_LINK_TIMER_VAL(ns)	((u32)((ns) /
> SGMII_CLOCK_PERIOD_NS))
> > +
> > +#define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII
> spec */
> > +
> > +#define SGMII_LINK_TIMER_LO		0x12
> > +#define SGMII_LINK_TIMER_HI		0x13
> > +#define SGMII_IF_MODE			0x14
> > +#define SGMII_IF_MODE_SGMII_EN		BIT(0)
> > +#define SGMII_IF_MODE_USE_SGMII_AN	BIT(1)
> > +#define SGMII_IF_MODE_SPEED(x)		(((x) << 2) & GENMASK(3, 2))
> > +#define SGMII_IF_MODE_SPEED_MSK		GENMASK(3, 2)
> > +#define SGMII_IF_MODE_DUPLEX		BIT(4)
>=20
> Given that this is in the .c file, and this code will be re-used in other=
 places where
> there is support for more than Cisco SGMII, can we lose the SGMII_ prefix
> please?  Maybe use names such as those I have in "dpaa2-mac: add 1000BASE=
-
> X/SGMII PCS support" ?

Yep, I can do that.=20

>=20
> (I hate the way a single lane gigabit serdes link that supports 1000base-=
x gets
> incorrectly called "SGMII".)
>=20
> > +
> > +#define USXGMII_ADVERTISE_LSTATUS(x)	(((x) << 15) & BIT(15))
> > +#define USXGMII_ADVERTISE_FDX		BIT(12)
> > +#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
> > +
> > +#define USXGMII_LPA_LSTATUS(lpa)	((lpa) >> 15)
> > +#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >>
> 12)
> > +#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
> > +
> > +enum usxgmii_speed {
> > +	USXGMII_SPEED_10	=3D 0,
> > +	USXGMII_SPEED_100	=3D 1,
> > +	USXGMII_SPEED_1000	=3D 2,
> > +	USXGMII_SPEED_2500	=3D 4,
> > +};
>=20
> These are not specific to the Lynx PCS, but are the standard layout of th=
e
> USXGMII word.  These ought to be in a header file similar to what we do w=
ith
> the SGMII definitions in include/uapi/linux/mii.h.
> I think as these are Clause 45, they possibly belong in include/uapi/linu=
x/mdio.h
> ?  In any case, one of my comments below suggests that some of the uses o=
f
> these definitions should be moved into phylink's helpers.
>

Ok, since these are described in the USXGMII standard I can move them to th=
e generic header (mdio.h).
I will comment below about their usage in phylink's helpers.
=20
> > +
> > +enum sgmii_speed {
> > +	SGMII_SPEED_10		=3D 0,
> > +	SGMII_SPEED_100		=3D 1,
> > +	SGMII_SPEED_1000	=3D 2,
> > +	SGMII_SPEED_2500	=3D 2,
> > +};
> > +
> > +static void lynx_pcs_an_restart_usxgmii(struct mdio_device *pcs) {
> > +	mdiobus_c45_write(pcs->bus, pcs->addr,
> > +			  MDIO_MMD_VEND2, MII_BMCR,
> > +			  BMCR_RESET | BMCR_ANENABLE |
> BMCR_ANRESTART); }
>=20
> Phylink will not call *_an_restart() for USXGMII, so this code is unreach=
able.
>=20
> > +
> > +void lynx_pcs_an_restart(struct mdio_device *pcs, phy_interface_t
> > +ifmode) {
> > +	switch (ifmode) {
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +		phylink_mii_c22_pcs_an_restart(pcs);
>=20
> Phylink will not call *_an_restart() for SGMII, so this code is unreachab=
le.
>=20

Good point. I'll remove this and the above one.
> > +		break;
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +		lynx_pcs_an_restart_usxgmii(pcs);
> > +		break;
> > +	case PHY_INTERFACE_MODE_2500BASEX:
> > +		break;
> > +	default:
> > +		dev_err(&pcs->dev, "Invalid PCS interface type %s\n",
> > +			phy_modes(ifmode));
> > +		break;
> > +	}
> > +}
> > +EXPORT_SYMBOL(lynx_pcs_an_restart);
> > +
> > +static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
> > +				       struct phylink_link_state *state) {
> > +	struct mii_bus *bus =3D pcs->bus;
> > +	int addr =3D pcs->addr;
> > +	int status, lpa;
> > +
> > +	status =3D mdiobus_c45_read(bus, addr, MDIO_MMD_VEND2,
> MII_BMSR);
> > +	if (status < 0)
> > +		return;
> > +
> > +	state->link =3D !!(status & MDIO_STAT1_LSTATUS);
> > +	state->an_complete =3D !!(status & MDIO_AN_STAT1_COMPLETE);
> > +	if (!state->link || !state->an_complete)
> > +		return;
> > +
> > +	lpa =3D mdiobus_c45_read(bus, addr, MDIO_MMD_VEND2, MII_LPA);
> > +	if (lpa < 0)
> > +		return;
> > +
> > +	switch (USXGMII_LPA_SPEED(lpa)) {
> > +	case USXGMII_SPEED_10:
> > +		state->speed =3D SPEED_10;
> > +		break;
> > +	case USXGMII_SPEED_100:
> > +		state->speed =3D SPEED_100;
> > +		break;
> > +	case USXGMII_SPEED_1000:
> > +		state->speed =3D SPEED_1000;
> > +		break;
> > +	case USXGMII_SPEED_2500:
> > +		state->speed =3D SPEED_2500;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	if (USXGMII_LPA_DUPLEX(lpa))
> > +		state->duplex =3D DUPLEX_FULL;
> > +	else
> > +		state->duplex =3D DUPLEX_HALF;
>=20
> This should be added to phylink_mii_c45_pcs_get_state().  There is nothin=
g that
> is Lynx PCS specific here.

The USXGMII standard only describes the auto-negotiation word, not the MMD
where this can be found (MMD_VEND2 in this case).
I would not add a generic phylink herper that reads the MMD and also decode=
s it.
Maybe a helper that just decodes the USXGMII word read from the
Lynx module - phylink_decode_usxgmii_word(state, lpa) ?

>=20
> > +}
> > +
> > +static void lynx_pcs_get_state_2500basex(struct mdio_device *pcs,
> > +					 struct phylink_link_state *state) {
> > +	struct mii_bus *bus =3D pcs->bus;
> > +	int addr =3D pcs->addr;
> > +	int bmsr, lpa;
> > +
> > +	bmsr =3D mdiobus_read(bus, addr, MII_BMSR);
> > +	lpa =3D mdiobus_read(bus, addr, MII_LPA);
> > +	if (bmsr < 0 || lpa < 0) {
> > +		state->link =3D false;
> > +		return;
> > +	}
> > +
> > +	state->link =3D !!(bmsr & BMSR_LSTATUS);
> > +	state->an_complete =3D !!(bmsr & BMSR_ANEGCOMPLETE);
> > +	if (!state->link)
> > +		return;
> > +
> > +	state->speed =3D SPEED_2500;
> > +	state->pause |=3D MLO_PAUSE_TX | MLO_PAUSE_RX;
>=20
> How do you know the other side is using pause frames, or is capable of de=
aling
> with them?

Isn't this done by also looking into the PHY's pause frame bits and enablin=
g pause
frames in the MAC only when both the PCS and the PHY have flow enabled?

>=20
> In any case, phylink_mii_c22_pcs_get_state() should be expanded to deal w=
ith
> the non-inband cases, where we are only interested in the link state.  It=
 isn't
> passed the link AN mode, which may be an issue that needs resolving in so=
me
> way.
>

Agreed, but I wouldn't just add all of this into this patch set.. it alread=
y is getting out of hand.

=20
> > +}
> > +
> > +void lynx_pcs_get_state(struct mdio_device *pcs, phy_interface_t ifmod=
e,
> > +			struct phylink_link_state *state)
> > +{
> > +	switch (ifmode) {
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +		phylink_mii_c22_pcs_get_state(pcs, state);
> > +		break;
> > +	case PHY_INTERFACE_MODE_2500BASEX:
> > +		lynx_pcs_get_state_2500basex(pcs, state);
> > +		break;
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +		lynx_pcs_get_state_usxgmii(pcs, state);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +
> > +	dev_dbg(&pcs->dev,
> > +		"mode=3D%s/%s/%s link=3D%u an_enabled=3D%u
> an_complete=3D%u\n",
> > +		phy_modes(ifmode),
> > +		phy_speed_to_str(state->speed),
> > +		phy_duplex_to_str(state->duplex),
> > +		state->link, state->an_enabled, state->an_complete); }
> > +EXPORT_SYMBOL(lynx_pcs_get_state);
> > +
> > +static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int=
 mode,
> > +				 const unsigned long *advertising) {
> > +	struct mii_bus *bus =3D pcs->bus;
> > +	int addr =3D pcs->addr;
> > +	u16 if_mode;
> > +	int err;
> > +
> > +	/* SGMII spec requires tx_config_Reg[15:0] to be exactly 0x4001
> > +	 * for the MAC PCS in order to acknowledge the AN.
> > +	 */
> > +	mdiobus_write(bus, addr, MII_ADVERTISE,
> > +		      ADVERTISE_SGMII | ADVERTISE_LPACK);
>=20
> This will be overwritten by phylink_mii_c22_pcs_config() below.
>=20

Yep, will remove. I've gone through the documentation and the register
should be initialized to 0x0001 when in SGMII mode
(as done by phylink_mii_c22_pcs_config()).

> > +
> > +	if_mode =3D SGMII_IF_MODE_SGMII_EN;
> > +	if (mode =3D=3D MLO_AN_INBAND) {
> > +		u32 link_timer;
> > +
> > +		if_mode |=3D SGMII_IF_MODE_USE_SGMII_AN;
> > +
> > +		/* Adjust link timer for SGMII */
> > +		link_timer =3D
> SGMII_LINK_TIMER_VAL(SGMII_AN_LINK_TIMER_NS);
> > +		mdiobus_write(bus, addr, SGMII_LINK_TIMER_LO, link_timer &
> 0xffff);
> > +		mdiobus_write(bus, addr, SGMII_LINK_TIMER_HI, link_timer >>
> 16);
> > +	}
> > +	mdiobus_modify(bus, addr, SGMII_IF_MODE,
> > +		       SGMII_IF_MODE_SGMII_EN |
> SGMII_IF_MODE_USE_SGMII_AN,
> > +		       if_mode);
> > +
> > +	err =3D phylink_mii_c22_pcs_config(pcs, mode,
> PHY_INTERFACE_MODE_SGMII,
> > +					 advertising);
> > +	return err;
> > +}
> > +
> > +static int lynx_pcs_config_usxgmii(struct mdio_device *pcs, unsigned i=
nt
> mode,
> > +				   const unsigned long *advertising) {
> > +	struct mii_bus *bus =3D pcs->bus;
> > +	int addr =3D pcs->addr;
> > +
> > +	/* Configure device ability for the USXGMII Replicator */
> > +	mdiobus_c45_write(bus, addr, MDIO_MMD_VEND2, MII_ADVERTISE,
> > +			  USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
> > +			  USXGMII_ADVERTISE_LSTATUS(1) |
> > +			  ADVERTISE_SGMII |
> > +			  ADVERTISE_LPACK |
> > +			  USXGMII_ADVERTISE_FDX);
> > +	return 0;
> > +}
> > +
> > +int lynx_pcs_config(struct mdio_device *pcs, unsigned int mode,
> > +		    phy_interface_t ifmode,
> > +		    const unsigned long *advertising) {
> > +	switch (ifmode) {
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +		lynx_pcs_config_sgmii(pcs, mode, advertising);
> > +		break;
> > +	case PHY_INTERFACE_MODE_2500BASEX:
> > +		/* 2500Base-X only works without in-band AN,
> > +		 * thus nothing to do here
> > +		 */
> > +		break;
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +		lynx_pcs_config_usxgmii(pcs, mode, advertising);
> > +		break;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(lynx_pcs_config);
> > +
> > +static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned i=
nt
> mode,
> > +				   int speed, int duplex)
> > +{
> > +	struct mii_bus *bus =3D pcs->bus;
> > +	u16 if_mode =3D 0, sgmii_speed;
> > +	int addr =3D pcs->addr;
> > +
> > +	/* The PCS needs to be configured manually only
> > +	 * when not operating on in-band mode
> > +	 */
> > +	if (mode =3D=3D MLO_AN_INBAND)
> > +		return;
> > +
> > +	if (duplex =3D=3D DUPLEX_HALF)
> > +		if_mode |=3D SGMII_IF_MODE_DUPLEX;
> > +
> > +	switch (speed) {
> > +	case SPEED_1000:
> > +		sgmii_speed =3D SGMII_SPEED_1000;
> > +		break;
> > +	case SPEED_100:
> > +		sgmii_speed =3D SGMII_SPEED_100;
> > +		break;
> > +	case SPEED_10:
> > +		sgmii_speed =3D SGMII_SPEED_10;
> > +		break;
> > +	case SPEED_UNKNOWN:
> > +		/* Silently don't do anything */
> > +		return;
> > +	default:
> > +		dev_err(&pcs->dev, "Invalid PCS speed %d\n", speed);
> > +		return;
> > +	}
> > +	if_mode |=3D SGMII_IF_MODE_SPEED(sgmii_speed);
> > +
> > +	mdiobus_modify(bus, addr, SGMII_IF_MODE,
> > +		       SGMII_IF_MODE_DUPLEX | SGMII_IF_MODE_SPEED_MSK,
> > +		       if_mode);
> > +}
> > +
> > +/* 2500Base-X is SerDes protocol 7 on Felix and 6 on ENETC. It is a
> > +SerDes lane
> > + * clocked at 3.125 GHz which encodes symbols with 8b/10b and does
> > +not have
> > + * auto-negotiation of any link parameters. Electrically it is
> > +compatible with
> > + * a single lane of XAUI.
> > + * The hardware reference manual wants to call this mode SGMII, but
> > +it isn't
> > + * really, since the fundamental features of SGMII:
> > + * - Downgrading the link speed by duplicating symbols
> > + * - Auto-negotiation
> > + * are not there.
> > + * The speed is configured at 1000 in the IF_MODE because the clock
> > +frequency
> > + * is actually given by a PLL configured in the Reset Configuration Wo=
rd
> (RCW).
> > + * Since there is no difference between fixed speed SGMII w/o AN and
> > +802.3z w/o
> > + * AN, we call this PHY interface type 2500Base-X. In case a PHY
> > +negotiates a
> > + * lower link speed on line side, the system-side interface remains
> > +fixed at
> > + * 2500 Mbps and we do rate adaptation through pause frames.
> > + */
> > +static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
> > +				       unsigned int mode,
> > +				       int speed, int duplex)
> > +{
> > +	struct mii_bus *bus =3D pcs->bus;
> > +	int addr =3D pcs->addr;
> > +
> > +	if (mode =3D=3D MLO_AN_INBAND) {
> > +		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
> > +		return;
> > +	}
> > +
> > +	mdiobus_write(bus, addr, SGMII_IF_MODE,
> > +		      SGMII_IF_MODE_SGMII_EN |
> > +		      SGMII_IF_MODE_SPEED(SGMII_SPEED_2500));
> > +}
> > +
> > +void lynx_pcs_link_up(struct mdio_device *pcs, unsigned int mode,
> > +		      phy_interface_t interface,
> > +		      int speed, int duplex)
> > +{
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +		lynx_pcs_link_up_sgmii(pcs, mode, speed, duplex);
> > +		break;
> > +	case PHY_INTERFACE_MODE_2500BASEX:
> > +		lynx_pcs_link_up_2500basex(pcs, mode, speed, duplex);
> > +		break;
> > +	case PHY_INTERFACE_MODE_USXGMII:
> > +		/* At the moment, only in-band AN is supported for USXGMII
> > +		 * so nothing to do in link_up
> > +		 */
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +}
> > +EXPORT_SYMBOL(lynx_pcs_link_up);
> > +
> > +MODULE_LICENSE("Dual BSD/GPL");
> > diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h new
> > file mode 100644 index 000000000000..336fccb8c55f
> > --- /dev/null
> > +++ b/include/linux/pcs-lynx.h
> > @@ -0,0 +1,25 @@
> > +/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
> > +/* Copyright 2020 NXP
> > + * Lynx PCS helpers
> > + */
> > +
> > +#ifndef __LINUX_PCS_LYNX_H
> > +#define __LINUX_PCS_LYNX_H
> > +
> > +#include <linux/phy.h>
> > +#include <linux/mdio.h>
> > +
> > +void lynx_pcs_an_restart(struct mdio_device *pcs, phy_interface_t
> > +ifmode);
> > +
> > +void lynx_pcs_get_state(struct mdio_device *pcs, phy_interface_t ifmod=
e,
> > +			struct phylink_link_state *state);
> > +
> > +int lynx_pcs_config(struct mdio_device *pcs, unsigned int mode,
> > +		    phy_interface_t ifmode,
> > +		    const unsigned long *advertising);
> > +
> > +void lynx_pcs_link_up(struct mdio_device *pcs, unsigned int mode,
> > +		      phy_interface_t interface,
> > +		      int speed, int duplex);
> > +
> > +#endif /* __LINUX_PCS_LYNX_H */
> > --
> > 2.25.1
> >
> >
>=20

