Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D8E196BE2
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 10:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgC2IWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 04:22:15 -0400
Received: from mail-eopbgr30071.outbound.protection.outlook.com ([40.107.3.71]:30806
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbgC2IWP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 04:22:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nek/XSj8PQ5TZjlELL0veSQDp4DZRzJ+89zVK31cZcpRzLhKTUbTJyZBfDNxKtiegLYTWVbjsTQ+9V7AJLPFtoqODU9j7VWikdTlRyCwDLL5Vrcm8LHsiKenBB3m3f4CGQ8dWb7rkoa4F0dtX5ZjAQhfcmViKnmemN6FMaE1g1aLl82WK+n84CHySVicyP3raxyy3XaJgRod8FK/BsogGdEJCCcaM3nOKEne7c69uXU33rHru29F2jj/9bZEcrNlHy57EHmQ7PvulyOXOrN14O2NiSjo/izRFb+FIgi/PjuTnetydn0TXeY6/4C9lYLQNGl6ecB0kdejCg3DCBA8Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPhiiF3PKA4GruwIu3IDcoVKU2zL3OpehCcaxODQl94=;
 b=UjVCqc7LCdolyHiDwcFBtBvemHpYJQhJNC2X05LybKoRwsXXwhuTcHxfFf+d10oNlHUOKetsXJKDR0xNVBrR+ZWe4ZrIfOWOTOtGPtjVoOB/eT5UXSpLjc2O1iTck+CJ7Yi3XjSK+l8NyBUofJy8A41ArW06agsosbwwaAheERZ7ej7NQCaHVZMa/aEYvW2nneWpos7+CP+sImd1nE4g1HBPWy+OOYqksKJv0juzRqNY2axF6dn7orHZy2y3yU4BNHFBV+zeUFbPYFb2UMMZcEGnrrgRMVLZbacneE22UGhjBntSD3WffcsTNmg4cyiRWLPWaAKeA1v022nqDsQDHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPhiiF3PKA4GruwIu3IDcoVKU2zL3OpehCcaxODQl94=;
 b=j8YspKOOFXDdgIEA5SPP8sBvl+I5wK50YDy8NFzR0jLV2Q2EH7y0R4waYoIdVfknXcm1wS+RqVyrJ6r9dChZuJ4bmDZ2+lU6Uo7uWtnLXCEDWqWO5GM1JKlq6O36zoa58ERh7O8SPmJ9WWJqvAB3YRQeGmS2mTRzQRVpGL4BI4c=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (20.178.114.161) by
 AM0PR04MB4690.eurprd04.prod.outlook.com (20.177.40.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Sun, 29 Mar 2020 08:22:10 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::ccc:be36:aaf0:709a%7]) with mapi id 15.20.2856.019; Sun, 29 Mar 2020
 08:22:10 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 3/9] net: phy: add kr phy connection
 type
Thread-Topic: [EXT] Re: [PATCH net-next 3/9] net: phy: add kr phy connection
 type
Thread-Index: AQHWA3W5Efen8PD/TUubWXt5OukOuqhbkqiAgAOsR/A=
Date:   Sun, 29 Mar 2020 08:22:10 +0000
Message-ID: <AM0PR04MB54435F251B435789A435A0BBFBCA0@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-4-git-send-email-florinel.iordache@nxp.com>
 <20200327001515.GL3819@lunn.ch>
In-Reply-To: <20200327001515.GL3819@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [78.96.99.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c43ef43a-9b45-4533-5363-08d7d3ba4743
x-ms-traffictypediagnostic: AM0PR04MB4690:|AM0PR04MB4690:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB4690F8B7A708D70BE9AFE8D2FBCA0@AM0PR04MB4690.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 035748864E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(39850400004)(396003)(346002)(376002)(6506007)(7696005)(71200400001)(5660300002)(54906003)(33656002)(478600001)(186003)(55016002)(9686003)(4326008)(26005)(64756008)(66946007)(52536014)(6916009)(66446008)(76116006)(66476007)(8676002)(316002)(66556008)(86362001)(81156014)(44832011)(2906002)(81166006)(7416002)(8936002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9N0pPFpAvkMn5ofnDHVswvu1mV1sF9gGcKuNSY6UA8Gu9YCnIaZfOD8KUZAl6SpSD/eAmtp0kmeOSezcV/ykL19Igg/PzEydsRr+dkp+MZRQQ5CCler/qiD6Lzj0HszAA54CcQ1XFsbhA+b8z5glQ2av8FkxNGxui2w0lTkQ7bskc4fY0yrjabyKHN3kcQZw3FScy0R0NEYw1M1FzT5IRbd/MkJJZZT0LyMoKk3GN9pkn7AawzU5Lhr9v2VQ291l3qG8pnKjFe5Bge1J4Muee66GIUBb9ZB9eEBXcSg96ZbHatOnuldQfu/LlyZKTOQPmI9YG/T8Z5CX8ZQBZ3LejuLI8HwdfHeSIFp9xqes48Ehrmru/S5gal9fgBnReqRoU2NDIpIpbOQLaHW4Bvw9nKepJxndWKS7bGxMc4TFNT2kn/xrKVIEnd+ignBcq75R
x-ms-exchange-antispam-messagedata: 51dmKYQHwuNTiTCS6AoPWaeYU0q5MkBRBHDdE9DejtbDCIePbkPzFYJox/T0kaZImsjgS54uqSa+jPYUePzOzG6cEyOMqei2ekXHDbCiZZtrzU1aQS0TgZGwshQi99RB3sBd+ymx3Eb2bsp+RF8O6A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c43ef43a-9b45-4533-5363-08d7d3ba4743
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2020 08:22:10.7777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vCmbOsmcR7TzxwzJkpA0f8bGk9GwSiz2IK32GNgD0TlX76VVSPZsOdC/KrsYlvr1O4SVKs9ze/X5FCqUCuvt5yEU8c3sUrqLZvsv2eXVVrs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4690
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Mar 26, 2020 at 03:51:16PM +0200, Florinel Iordache wrote:
> > Add support for backplane kr phy connection types currently available
> > (10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
> > the cases for KR modes which are clause 45 compatible to correctly
> > assign phy_interface and phylink#supported)
> >
> > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > ---
> >  drivers/net/phy/phylink.c | 15 ++++++++++++---
> >  include/linux/phy.h       |  6 +++++-
> >  2 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index fed0c59..db1bb87 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -4,6 +4,7 @@
> >   * technologies such as SFP cages where the PHY is hot-pluggable.
> >   *
> >   * Copyright (C) 2015 Russell King
> > + * Copyright 2020 NXP
> >   */
> >  #include <linux/ethtool.h>
> >  #include <linux/export.h>
> > @@ -303,7 +304,6 @@ static int phylink_parse_mode(struct phylink *pl, s=
truct
> fwnode_handle *fwnode)
> >                       break;
> >
> >               case PHY_INTERFACE_MODE_USXGMII:
> > -             case PHY_INTERFACE_MODE_10GKR:
>=20
> We might have a backwards compatibility issue here. If i remember correct=
ly,
> there are some boards out in the wild using PHY_INTERFACE_MODE_10GKR not
> PHY_INTERFACE_MODE_10GBASER.
>=20
> See e0f909bc3a242296da9ccff78277f26d4883a79d
>=20
> Russell, what do you say about this?
>=20
>          Andrew

Ethernet interface nomenclature is using the following terminology:
e.g. 10GBase-KR: data rate (10G),  modulation type (Base =3D Baseband),
medium type (K =3D BacKplane), physical layer encoding scheme
(R =3D scRambling/descRambling using 64b/66b encoding that allows for
Ethernet framing at a rate of 10.3125 Gbit/s)
So 10GBase-R name provide information only about the data rate and
the encoding scheme without specifying the interface medium.
10GBase-R is a family of many different standards specified for
several different physical medium for copper and optical fiber like
for example:
	10GBase-SR: Short range (over fiber)
	10GBase-LR: Long reach (over fiber)
	10GBase-LRM: Long reach multi-mode (over fiber)
	10GBase-ER: Extended reach (over fiber)
	10GBase-CR: 10G over copper
	10GBase-KR: Backplane

10GBase-KR represents Ethernet operation over electrical backplanes on
single lane and uses the same physical layer encoding as 10GBase-LR/ER/SR
defined in IEEE802.3 Clause 49.=20
So prior to my change, phy_interface_t provided both enumerators which is c=
orrect:
	PHY_INTERFACE_MODE_10GBASER
	PHY_INTERFACE_MODE_10GKR
Perhaps PHY_INTERFACE_MODE_10GKR was not used before because Backplane
support was not available and all 10GBase-R family of interfaces should
be using PHY_INTERFACE_MODE_10GBASER.
In case PHY_INTERFACE_MODE_10GKR was used before, this is probably
incorrect and should be changed for those boards to use the correct phy
connection type: PHY_INTERFACE_MODE_10GBASER.
Moreover now I also introduced a new phy connection type to cover also:
40GBase-KR4 which is 40G Backplane over 4-lanes:
	PHY_INTERFACE_MODE_40GKR4

Prior to adding backplane support, 10GKR case was handled the same as
10GBASER in phylink_parse_mode.=20
But now because we are adding support for backplane modes, all backplane
phy connection types (like: 10GKR, 40GKR4) must be treated separately to
correctly setup the supported phylink.

Florin.
