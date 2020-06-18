Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BBA1FFA5D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbgFRRe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:34:57 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:24886
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728384AbgFRRez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 13:34:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIEGHAFZU/ldIs36y99F7KtIx3kV94KkLZ7YShunAaA6jOUTtqDKP8JvItExGeBLVBsAQUsVqpgcN6YU5r/Qrr9I5174xlbXjotp0eXHAdnkYOEaGKKGErNjTW9MDIC4IcmE9l3iXJjHeOvpEhu3YdL5in92Kf4t5eWl8hPg79XdFW0qc+/O/HUPztOUR6864Bqxd3f67R69DD9o9rUDbMyTbqoOcfNS0NMFu6L3nJHCSs5/YpjloybVf5TDO1fk58l+wxpacuegAjvtuaY+olKxkHQ4SpNJTpcWSZ6qDbTgSdWnsRfyJJ78TTAuSC6sLBItB/eMDKrNL34M0Xkzcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5ZvO5YPqTnKNAc844tYSO4yXR25TvhE1wHmAYfBAik=;
 b=S7y3nGLd4ppLkz3UqHwkipvFCwA1vReEffMHAm5arEv7UJRMb/xRcAO4o1x+SsL2JxHZLOlWyoazaR69xbzT1bCSJVVGbuDtp3Qxc+mfUJ/xD1SJUitcQXY+gWvq0yxamBwt5X1WRVeI4yLeGpNAH7ONWVb8CytDrfJxjR+p/bgvABLVvogR+8ieWp+rnkcXvAoSjIppmpd1Yc3yUgtMq8VPwq+uyk2E9rnCkFhhTov4Bnpnsj0Rxn8SdKXNjjbBlFIg0iZtcA0+dZWm+pYuzWI7z8CNO4h/RgJKwIPeBDpLO70pWoyxoZ/O+Q7pSdeYBXjQ9UDRacQq9QrKudVFcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5ZvO5YPqTnKNAc844tYSO4yXR25TvhE1wHmAYfBAik=;
 b=UA/7ShymClE/wqxQOi2Z4lqJUbfggHODDnQpemKM6gxQBHj+Igw51TNeA2FARII4RX8+ggqJIXerHo/GQ1WMJmInpZ/DrbiLmwvPDRhSR0sIRnS93bz+wUaDrF/xh+0FVsxCBWdctHZQWeWzth+nmPprrs+drPnc5dYEAj45z4I=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2846.eurprd04.prod.outlook.com
 (2603:10a6:800:ba::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 17:34:50 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 17:34:50 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Topic: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Index: AQHWRWlFJODo1hCReU2dgxtV9gIXrKjeaHmAgAAGAiCAACkmAIAAAPiQ
Date:   Thu, 18 Jun 2020 17:34:49 +0000
Message-ID: <VI1PR0402MB38712F94BAAC32DB1C8AB7F8E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618140623.GC1551@shell.armlinux.org.uk>
 <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200618165510.GG1551@shell.armlinux.org.uk>
In-Reply-To: <20200618165510.GG1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6f4f38e1-6e11-44e6-bb93-08d813ade71a
x-ms-traffictypediagnostic: VI1PR0402MB2846:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2846CCD72E7D6248811BA0A4E09B0@VI1PR0402MB2846.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yMEIKSmXaqQfA+tLTKIsZubTrBVpoiLv9YGJiwO1HRfV1j3DlhUPMBRLl8LjF2id1bkGeLifZbT3JbG6pWqt2iev29BEibN0rA+uyb8SOqnlPnnWzmu2WyHl1ZItZN1lvC8YNr01u5nxwOyfeQ/zn+3bK43XsxCKmNdk1viYJ7xcI4J2OoaD1u4tEsSD7xzU4LrPuomXO2ap5I1O2n4kjzXiXF3emhMv9XG4OPEThtgy3LNogAetzOA5iVUKTdDlESJ7C8pOpTDlr4b8EDCc5LRWDj3bLwqgIugMS9ftyPPmIqDpSvWb9SPSHK4I1Ne8GnEpNrz7hGEOiMdyVR85fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(26005)(6506007)(52536014)(6916009)(66446008)(83380400001)(64756008)(66476007)(2906002)(66556008)(4326008)(316002)(86362001)(7696005)(55016002)(9686003)(44832011)(8936002)(33656002)(71200400001)(8676002)(186003)(76116006)(54906003)(66946007)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Q89F/oss308D16WUzr5sKJHo3uKS1Ua1M00Ht9F7KlDcm1hjBPkV7S2b6ZhdWE9PCu+xlZd/lvoruuqwLYn9pXPHT0EXY6DxFh+N2//elPDkYF9nJ75bXRsT+YOYv9s6DgHCMYVyBPGfTLq7G4vsGWo3Vu0j635PFzE17usi/yTKSGRz6yaDP/jNdXpyf0vPi/ClYeTK7Nz/6OHHdC7sFTY3yJeq18TmYle+1g5s5gZhanNhQLPDhu/GkNP+W0axiDVlysZ1/5fLRcI7hH4vcxhnJeSLb6mR3AmyqDvyN5hvFsmQFyubzj2Q8bZNp2lFoAz8yTYMIbK2D9I9tWpxH94s5ytVtH+jBW4slf7/i1mwVGBnaHrdGcMNCO0zFPLalZ0l0xOXq1eI6ta3ZhrUJZnD8kLnDn+Tr0fhLyM5Lusj8tyigt/FmnWqqNR5J11LklWq/FlJ/+MEndDKlaoeZVBgl4Cx/AGAOg16BizNlh4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4f38e1-6e11-44e6-bb93-08d813ade71a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 17:34:49.8625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDX+M4cjbUY2kJbbUekqGFiTgBAIsibuVQXrfZ3t+xgpAxWHAockGeXkj7hAb43fZ/sE/SGbiYxy79xvj3HMtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
>=20
> On Thu, Jun 18, 2020 at 04:17:56PM +0000, Ioana Ciornei wrote:
> > > > +struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device
> > > > +*mdio_dev) {
> > > > +	struct mdio_lynx_pcs *pcs;
> > > > +
> > > > +	if (WARN_ON(!mdio_dev))
> > > > +		return NULL;
> > > > +
> > > > +	pcs =3D kzalloc(sizeof(*pcs), GFP_KERNEL);
> > > > +	if (!pcs)
> > > > +		return NULL;
> > > > +
> > > > +	pcs->dev =3D mdio_dev;
> > > > +	pcs->an_restart =3D lynx_pcs_an_restart;
> > > > +	pcs->get_state =3D lynx_pcs_get_state;
> > > > +	pcs->link_up =3D lynx_pcs_link_up;
> > > > +	pcs->config =3D lynx_pcs_config;
> > >
> > > We really should not have these private structure interfaces.
> > > Private structure- based driver specific interfaces really don't
> > > constitute a sane approach to interface design.
> > >
> > > Would it work if there was a "struct mdio_device" add to the
> > > phylink_config structure, and then you could have the
> > > phylink_pcs_ops embedded into this driver?
> >
> > I think that would restrict too much the usage.
> > I am afraid there will be instances where the PCS is not recognizable
> > by PHY_ID, thus no way of knowing which driver to probe which mdio_devi=
ce.
> > Also, I would leave to the driver the choice of using (or not) the
> > functions exported by Lynx.
>=20
> I think you've taken my point way too far.  What I'm complaining about is=
 the
> indirection of lynx_pcs_an_restart() et.al. through a driver- private str=
ucture.
>=20
> In order to access lynx_pcs_an_restart(), we need to dereference struct
> mdio_lynx_pcs, which is a structure specific to this lynx PCS driver.  Wh=
at this
> leads to is users doing this:
>=20
> 	if (pcs_is_lynx) {
> 		struct mdio_lynx_pcs *pcs =3D foo->bar;
>=20
> 		pcs->an_restart(...);
> 	} else if (pcs_is_something_else) {
> 		struct mdio_somethingelse_pcs *pcs =3D foo->bar;
>=20
> 		pcs->an_restart(...);
> 	}
>=20
> which really does not scale.  A step forward would be:
>=20
> 	if (pcs_is_lynx) {
> 		lynx_pcs_an_restart(...);
> 	} else if (pcs_is_something_else) {
> 		something_else_pcs_an_restart(...);
> 	}
>=20
> but that also scales horribly.

This is what I was proposing. I can of course take the indirection away
and just export the functions.

Are there really instances where the ethernet driver has to manage multiple
different types of PCSs? I am not sure this type of snippet of code is real=
ly
going to occur.

>=20
> Even better would be to have a generic set of operations for PCS devices =
that
> can be declared in the lynx PCS driver and used externally... like, maybe=
 struct
> phylink_pcs_ops, which is made globally visible for MAC drivers to use wi=
th
> phylink_add_pcs().
>=20
> Or maybe a function in this lynx PCS driver that calls phylink_add_pcs() =
itself with
> its own PCS operations, and maybe also sets a field in struct phylink_con=
fig for
> the PCS mdio device?
>

I am not sure how this would work with Felix and DSA drivers in general sin=
ce the
DSA core is hiding the phylink_pcs_ops from the actual switch driver.

> Or something like that - just some a way that doesn't force us down a pat=
h that
> we end up forcing people into code that has to decide what sort of PCS we=
 have
> at runtime in all these method paths.

I get what you are saying but I do not know of any drivers that actually ne=
ed this
distinction at runtime.

Ioana

>=20
> > What if we directly export the helper functions directly as symbols
> > which can be used by the driver without any mdio_lynx_pcs in the
> > middle (just the mdio_device passed to the function).
> > This would be exactly as phylink_mii_c22_pcs_[an_restart/config] are
> > currently used.
>=20
> The difference is that phylink_mii_c22_pcs_* are designed as library func=
tions -
> functions that are very likely to be re-used for multiple different PCS (=
because
> the format, location, and access method of these registers is defined by =
IEEE
> 802.3).  It's a bit like phylib's configuration of autoneg - we don't hav=
e all the
> individual drivers doing that, we have core code that does that for us in=
 the form
> of helpers.
>=20

