Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572A01956D8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 13:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgC0MMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 08:12:42 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:6074
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbgC0MMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 08:12:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwuMeHsHWMPNMzKX5r1ic4wzRyPUIeZwXAIQpOQx9xzzF+1P9oJTvlRwqp5hOnZ7icbZI1FgL82IVWB5T4QAJKohTWj+SWZVvWy8pp0XibqTVjbgjB41gJl4vCjrnaQrOJRbapq83bSd0ygGIY7L8AAoD0z1LBt4n9L7sib76jdMT378RGYIDBdB3vEnsTEFQcsnumW71P931hNEmqIOt8uS0dfLHzX+WAi2iRtZZ9I8OzH3NYw4DLj/Bd7dYrDOORneYypVjGPyR6HHyizs4t0gdMh6/Gm4MVa++zRsS63X4OSkMZlo+PsJa0zu6qsroqMaORyPvYygmEcY3V3c8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGKyss1meh4EoUgif9r/co9f1viaU635ESy0/FRWhGs=;
 b=Fb6ryORvM2R+BnTiu9vYvdXf5irbC3I90+lCe++MwWEyazcQ0p2n9+xrMplFHswk7ODMKZhmHo07/VXELdbTuB4YtTS8mUj2fvz0ZcVH86+fqKFGSIYL23tyRGpc+0k+U2JnC3aEjhm+tyx+s+OaxDxi7RigBJYz6ONljRGjzM/693umpNLTq/k0Ze84niFxkEhelBlM2AwbwkTMZ4ktHVM0xEhmUQ6yxPZMMaJ6Z8XCP/cP2z27/ilFUo+cPX0MmNgVVRmmsqudMn5u2FM+D5+C9CT99yy+9D2F8tDrfWI+Md73ZUxEa2Sg2AYAiJ7hSbnTFnNEqjMKCgO8EKgu9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGKyss1meh4EoUgif9r/co9f1viaU635ESy0/FRWhGs=;
 b=kM6NNPAFUrBmuJOAPjoespHvKuej+LR0MFLLo3PHMrJfO/Z0pFgheTUVRIxCwE+MNJ2mGedDGvwIDWVAIdoReGhIPxw5JZtWtluSJQWfEu6VI1GhCwwCQ8KsTz6+pyV5QVzM24ThR+XtSeoeT3Knbrc60CJ/L5hMtqNNKqd79GU=
Received: from AM0PR04MB6980.eurprd04.prod.outlook.com (52.132.212.87) by
 AM0PR04MB4657.eurprd04.prod.outlook.com (52.135.150.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Fri, 27 Mar 2020 12:12:37 +0000
Received: from AM0PR04MB6980.eurprd04.prod.outlook.com
 ([fe80::182f:6b6f:c5de:a768]) by AM0PR04MB6980.eurprd04.prod.outlook.com
 ([fe80::182f:6b6f:c5de:a768%7]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 12:12:37 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 3/9] net: phy: add kr phy connection type
Thread-Topic: [PATCH net-next 3/9] net: phy: add kr phy connection type
Thread-Index: AQHWA3W51L++Smjeo02LmodTCzr/lahbkqiAgADFbQCAAADmcA==
Date:   Fri, 27 Mar 2020 12:12:37 +0000
Message-ID: <AM0PR04MB6980E904C03F164E6A1D2267ECCC0@AM0PR04MB6980.eurprd04.prod.outlook.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-4-git-send-email-florinel.iordache@nxp.com>
 <20200327001515.GL3819@lunn.ch>
 <20200327120151.GG25745@shell.armlinux.org.uk>
In-Reply-To: <20200327120151.GG25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [79.115.171.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7f064b7f-5a57-4e01-b915-08d7d248239b
x-ms-traffictypediagnostic: AM0PR04MB4657:|AM0PR04MB4657:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB4657E63259D7C6568D6608CCADCC0@AM0PR04MB4657.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6980.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(26005)(5660300002)(33656002)(110136005)(55016002)(54906003)(7416002)(966005)(71200400001)(2906002)(53546011)(9686003)(6506007)(86362001)(81166006)(76116006)(66476007)(81156014)(52536014)(66446008)(66946007)(316002)(8676002)(4326008)(64756008)(478600001)(186003)(66556008)(8936002)(7696005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E1luKoY/1Nwh6P7eSqLU4YOWAS+IIRl71UXjCuNjhzeuEuat/wYEaP94b4y7XbyVsvG50oMNnCRMna3BnusFhGiCWJm01sFaSv6hksbTFK+mJsbdqu+Gd/1UD0GLgtopiOlDg5IdKX2HrnkUVY7G2Z9me+YXcv/ZIE8lz/V4D/H0+soGus6Fh/mOrV6GffnbJdUUB0F7mOHGKmJslpLq6vmAAop5e0ftFFEzN7cy14cap65xLQ1NVnmm6Oye+gGk6VkZU32E6z3SOi2vzA0Cx3YFgEh4ygzbrgzAGUFO5XwErfbZ0BBZ6mrTJ91BM0wumqHd7y42YRSI3dVDz/VBokEpuCpFLjpvr00j+YGCqUO15b7XqURdyOthLGBmYUDEeqOxhMvrRuTAucX+D+071r9yzIc4Y/KKhJD+xw4wrIUIy/oZ9aR/AJ5wBbjd24wH1WP6hNvv+uoYXC0MXk9dObdiHnDHzSDisehZZIkKBeMvJ3NooVxbEmJttg4Y5F1pb0QA6ouw45H7eiCe7filQg==
x-ms-exchange-antispam-messagedata: 3UllHR64IJnHBojrzY/uAFcf/DDGDNdUBCPPD3x5RfR8CPQZ6NEjuubbyWAoR7X/C/Y+VKlXczyeihYDswLv0/Kzc3eA4Pn8nZba9rAqBw+zwftyS6N8MtDAFyGGmXuRmjwbUHKAZcJIqer9fKYRWQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f064b7f-5a57-4e01-b915-08d7d248239b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 12:12:37.1746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fyvm8HHfrJDg5R16FSvWQiZRRMBJyWnTgEN0a/VnLGv0C7Pa5PR9nlDDXo/FeJd6Pti+R3tLt6AUBbcIN+P81w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4657
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Russell King - ARM Linux admin
> Sent: Friday, March 27, 2020 2:02 PM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Florinel Iordache <florinel.iordache@nxp.com>; davem@davemloft.net;
> netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> devicetree@vger.kernel.org; linux-doc@vger.kernel.org; robh+dt@kernel.org=
;
> mark.rutland@arm.com; kuba@kernel.org; corbet@lwn.net;
> shawnguo@kernel.org; Leo Li <leoyang.li@nxp.com>; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; linux=
-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 3/9] net: phy: add kr phy connection type
>=20
> On Fri, Mar 27, 2020 at 01:15:15AM +0100, Andrew Lunn wrote:
> > On Thu, Mar 26, 2020 at 03:51:16PM +0200, Florinel Iordache wrote:
> > > Add support for backplane kr phy connection types currently available
> > > (10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
> > > the cases for KR modes which are clause 45 compatible to correctly
> assign
> > > phy_interface and phylink#supported)
> > >
> > > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > > ---
> > >  drivers/net/phy/phylink.c | 15 ++++++++++++---
> > >  include/linux/phy.h       |  6 +++++-
> > >  2 files changed, 17 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > index fed0c59..db1bb87 100644
> > > --- a/drivers/net/phy/phylink.c
> > > +++ b/drivers/net/phy/phylink.c
> > > @@ -4,6 +4,7 @@
> > >   * technologies such as SFP cages where the PHY is hot-pluggable.
> > >   *
> > >   * Copyright (C) 2015 Russell King
> > > + * Copyright 2020 NXP
> > >   */
> > >  #include <linux/ethtool.h>
> > >  #include <linux/export.h>
> > > @@ -303,7 +304,6 @@ static int phylink_parse_mode(struct phylink *pl,
> struct fwnode_handle *fwnode)
> > >  			break;
> > >
> > >  		case PHY_INTERFACE_MODE_USXGMII:
> > > -		case PHY_INTERFACE_MODE_10GKR:
> >
> > We might have a backwards compatibility issue here. If i remember
> > correctly, there are some boards out in the wild using
> > PHY_INTERFACE_MODE_10GKR not PHY_INTERFACE_MODE_10GBASER.
> >
> > See e0f909bc3a242296da9ccff78277f26d4883a79d
> >
> > Russell, what do you say about this?
>=20
> Yes, and that's a point that I made when I introduced 10GBASER to
> correct that mistake.  It is way too soon to change this; it will
> definitely cause regressions:
>=20
> $ grep 10gbase-kr arch/*/boot/dts -r
> arch/arm64/boot/dts/marvell/cn9131-db.dts:      phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode =3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode =3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-7040-db.dts:    phy-mode =3D "10gbase-
> kr";
> arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
=3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
=3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts:     phy-mode =
=3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/cn9132-db.dts:      phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/cn9130-db.dts:      phy-mode =3D "10gbase-kr"=
;
>=20
> So any change to the existing PHY_INTERFACE_MODE_10GKR will likely
> break all these platforms.
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbp=
s
> up

Hi Russell,

I hoped a fix for those would be in by now, it's not useful to leave them l=
ike
that. We have a similar situation, where all boards using XFI interfaces co=
ntain
phy-connection-type=3D"xgmii" for a long time now but that did not stop any=
one from
adding a warning in the Aquantia driver:

+       WARN(phydev->interface =3D=3D PHY_INTERFACE_MODE_XGMII,
+            "Your devicetree is out of date, please update it. The AQR107 =
family doesn't support XGMII, maybe you mean USXGMII.\n");
+

Maybe we need a warning added here too, until the proper phy-mode is used f=
or
these boards, to allow for a transition period.

Madalin
