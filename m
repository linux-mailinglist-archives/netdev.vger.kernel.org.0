Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7E1276A0
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfLTHiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:38:52 -0500
Received: from mail-eopbgr00055.outbound.protection.outlook.com ([40.107.0.55]:29188
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbfLTHiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 02:38:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGGiVuqTS9H1b5xm/lrWVCclNUaW2Vmah8tXrCuYzWfV+7WWjSrotA+5raNz2z/7YGHyHWdp1ZM5U0zlmTe2N1h+oBGK2FoW0yxvokhd51/QUa8y3JtSreHRFBq2CqXpGZ4vllW4NOjUiySPI4JKtvdPpvGTqstYV8dHtYGeTPxMFxBSuvw4k0PO4Fp0RComV43jjF0uzVi6EvxL28NbKzHpQUxTVhN+IbJQPrTHyXir+UcDwq50TLY5FC1zTxYU/3MKABy+7hcua5jrkyqPCRM+74qSHH8xVcLDwWIBAd159LCdIfWXeMM6Cluc0KyPdwysH2NHK36MEr68/ytqkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIAkZUtMuWVqmAijM2+Qw0lR7L0Nx8eKSa935UpUKkA=;
 b=A3HM/+oHwB0SsODhewS7mjw5wx/Hiayz1NpNe9fAHNdsT3uGz0I1aSz8mW+ldRG5S0cku4tRYRDEZcti+1qF+lF99gCAg6H4o3ZIAGuKjMi6HFnfHWiA5q3eE4cRNHQ5PIcaUGO4sTlyZtu5FAa+PFkDU2OHrERsL8kYyjEjsiM0GP0bfzjuw9FoPhJSOoqQO0BPdqyoDCz5v29TvdwNuStYhkyN8AWADnO//fABJPUtkutpWEE6lwjc7t5BaHqyobYgXN8VsjCVY5mo6W6Y56IDeF1eCpSGlNTC2KxIwAvddFTA4JV+4ejBsSRMtA3Oi61eD4kflRiCoWSjzrSScQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIAkZUtMuWVqmAijM2+Qw0lR7L0Nx8eKSa935UpUKkA=;
 b=Namo/UWpzD+Xg6WFWqvnPSmvQjvrhADPsyeS8GhJ045rIWYnzVW2EIL8izY+ZJF4CjvoypVRd04p8f3YMum3rRRvPIXVBu6bCTzdQdNLzHZxEd8INbKukYQRzGEGe7pswIAQJ56t7ImyI6vyRYqHHxk/rUJ4J8bFdmpKR4duExc=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5248.eurprd04.prod.outlook.com (20.177.52.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Fri, 20 Dec 2019 07:38:46 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.016; Fri, 20 Dec 2019
 07:38:46 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "antoine.tenart@free-electrons.com" 
        <antoine.tenart@free-electrons.com>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtn//emqdPRPEmEKC7Ncoej9h46fBtnoAgAAR9oCAAAh2AIAAKmuAgAAEEQCAAKEqIA==
Date:   Fri, 20 Dec 2019 07:38:45 +0000
Message-ID: <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
In-Reply-To: <20191219214930.GG25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 93dffde8-c633-4ac4-9d26-08d7851fa563
x-ms-traffictypediagnostic: VI1PR04MB5248:|VI1PR04MB5248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB52481451C62653234A257A76AD2D0@VI1PR04MB5248.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(13464003)(199004)(189003)(55016002)(9686003)(478600001)(26005)(186003)(4326008)(64756008)(66946007)(86362001)(66476007)(66446008)(66556008)(7416002)(5660300002)(2906002)(7696005)(81166006)(81156014)(8936002)(76116006)(33656002)(6506007)(71200400001)(110136005)(54906003)(316002)(52536014)(8676002)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5248;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o7kjiIwvS6VBWgRH+ENKOZkXMk/KcfffGjODRpojsv+cjelxEJdXYEMymtP/hTvF+m+0hOvjaazfeu62wESp4+P3/bPOUyb0NVOSttD10a99SCpT+lo1ZC05ma9MNRShVJy+IzuufRqYvvqq/fENWM+4ppE19LjastSwZ6M+0ZypHiALcdNvd4NZxhGnuDlXfh0R3q0aLah3eBGJutDWNygj/mCtiaqpM7cZlMGTwFR4qJSVXv6cU9WW96tf6Bhpo0g9hDrm5bQn56wN/ceR0PrVOblDXwNVGU6EAC1yzraLqy6fKKorp/wKtCDPPHMd7FZA/duam9uv15eJGkwYzzvwsE3EUyzsnOdWr3304e4fKXnya/5RPwGH0A4yZA5IvWhcVkMKCNn7CAnx4rJY0ZyuKBE7bVCxvp4Ej3S93kP1Zk43/p4TSwEWhaE7IPlD+mP3Ggt00fZpZAyBEQb9FJ0Do1dK7UnHePGC92ZHSJdi3HIOVqM8Zj8ZIkB2G3OIkX3qaO1oRtv1ren7a/sd8ahtSVnrlqoIAGoa/JKNI44=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93dffde8-c633-4ac4-9d26-08d7851fa563
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 07:38:46.0394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w47uo4bjNgCvgQRc4BYPnlJC7RQ6cjk/uBzpyTYUEd5eb/Z9eb2QNbj9S1MM90wDXk765FuLwJ0vrm9yUUzjeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5248
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> On Thu, Dec 19, 2019 at 09:34:57PM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > On Thu, Dec 19, 2019 at 06:32:51PM +0000, Madalin Bucur wrote:
> > > > > -----Original Message-----
> > > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > >
> > > > > On Thu, Dec 19, 2019 at 05:21:16PM +0200, Madalin Bucur wrote:
> > > > > > From: Madalin Bucur <madalin.bucur@nxp.com>
> > > > > >
> > > > > > Add explicit entries for XFI, SFI to make sure the device
> > > > > > tree entries for phy-connection-type "xfi" or "sfi" are
> > > > > > properly parsed and differentiated against the existing
> > > > > > backplane 10GBASE-KR mode.
> > > > >
> > > > > 10GBASE-KR is actually used for XFI and SFI (due to a slight
> > > > > mistake on my part, it should've been just 10GBASE-R).
> > > > >
> > > > > Please explain exactly what the difference is between XFI, SFI
> > > > > and 10GBASE-R. I have not been able to find definitive definition=
s
> > > > > for XFI and SFI anywhere, and they appear to be precisely identic=
al
> > > > > to 10GBASE-R. It seems that it's just a terminology thing, with
> > > > > different groups wanting to "own" what is essentially exactly the
> > > > > same interface type.
> > > >
> > > > Hi Russell,
> > > >
> > > > 10GBase-R could be used as a common nominator but just as well 10G
> > > > and remove the rest while we're at it. There are/may be differences=
 in
> > > > features, differences in the way the HW is configured (the most
> > > > important aspect) and one should be able to determine what interfac=
e
> > > > type is in use to properly configure the HW. SFI does not have the
> > > > CDR function in the PMD, relying on the PMA signal conditioning vs =
the
> > > > XFI that requires this in the PMD. We kept the xgmii compatible for=
 so
> > > > long without much issues until someone started cleaning up the PHY
> > > > supported modes. Since we're doing that, let's be rigorous. The 10G=
Base-KR
> > > > is important too, we have some backplane code in preparation and
> > > > having it there could pave the way for a simpler integration.
> > >
> > > The problem we currently have is:
> > >
> > > $ grep '10gbase-kr' arch/*/boot/dts -r
> > >
> > > virtually none of those are actually backplane. For the mcbin
> > > matches, these are either to a 88x3310 PHY for the doubleshot, which
> > > dynamically operates between XFI, 5GBASE-R, 2500BASE-X, or SGMII acco=
rding
> > > to the datasheet.
> >
> > Yes, I've seen it's used already in several places:
> >
> > $ grep PHY_INTERFACE_MODE_10GKR drivers/net -nr
> > drivers/net/phy/marvell10g.c:219:       if (iface !=3D
> PHY_INTERFACE_MODE_10GKR) {
> > drivers/net/phy/marvell10g.c:307:           phydev->interface !=3D
> PHY_INTERFACE_MODE_10GKR)
> > drivers/net/phy/marvell10g.c:389:            phydev->interface =3D=3D
> PHY_INTERFACE_MODE_10GKR) && phydev->link) {
> > drivers/net/phy/marvell10g.c:398:                       phydev-
> >interface =3D PHY_INTERFACE_MODE_10GKR;
> > drivers/net/phy/phylink.c:296:          case PHY_INTERFACE_MODE_10GKR:
> > drivers/net/phy/aquantia_main.c:361:            phydev->interface =3D
> PHY_INTERFACE_MODE_10GKR;
> > drivers/net/phy/aquantia_main.c:499:        phydev->interface !=3D
> PHY_INTERFACE_MODE_10GKR)
> > drivers/net/phy/sfp-bus.c:340:          return
> PHY_INTERFACE_MODE_10GKR;
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1117:   return
> interface =3D=3D PHY_INTERFACE_MODE_10GKR ||
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1203:   case
> PHY_INTERFACE_MODE_10GKR:
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1652:   case
> PHY_INTERFACE_MODE_10GKR:
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4761:   case
> PHY_INTERFACE_MODE_10GKR:
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4783:   case
> PHY_INTERFACE_MODE_10GKR:
> >
> > We should fix this, if it's incorrect.
> >
> > > If we add something else, then the problem becomes what to do about
> > > that lot - one of the problems is, it seems we're going to be
> > > breaking DT compatibility by redefining 10gbase-kr to be correct.
> >
> > We need the committer/maintainer to update that to a correct value.
>=20
> The general principle is, we don't break existing DT - in that, we
> expect DT files from current kernels to work with future kernels. So,
> we're kind of stuck with "10gbase-kr" being used for this at least in
> the medium term.
>=20
> By all means introduce "xfi" and "sfi" if you think that there is a
> need to discriminate between the two, but I've seen no hardware which
> that treats them any differently from 10gbase-r.
>=20
> If we want to support real 10gbase-kr, then I think we need to consider
> how to do that without affecting compatibility with what we already
> have.
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down
> 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

I've looked at the device tree entries using 10GBase-KR:

all these are disabled:

// disabled, commit mentions interface is SFI, jaz@semihalf.com
arch/arm64/boot/dts/marvell/cn9132-db.dts:107:  phy-mode =3D "10gbase-kr";

// disabled, SFI with SFP cage, jaz@semihalf.com
arch/arm64/boot/dts/marvell/cn9130-db.dts:131:  phy-mode =3D "10gbase-kr";
arch/arm64/boot/dts/marvell/cn9131-db.dts:89:   phy-mode =3D "10gbase-kr";

these are used:

// SFP ports, antoine.tenart@free-electrons.com
arch/arm64/boot/dts/marvell/armada-7040-db.dts:279:     phy-mode =3D "10gba=
se-kr";=20
arch/arm64/boot/dts/marvell/armada-8040-db.dts:190:     phy-mode =3D "10gba=
se-kr";
arch/arm64/boot/dts/marvell/armada-8040-db.dts:334:     phy-mode =3D "10gba=
se-kr";

// SFP, 10GKR, antoine.tenart@free-electrons.com
arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:37:   phy-mode =3D "10gba=
se-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:44:   phy-mode =3D "10gba=
se-kr";

// SFP, baruch@tkos.co.il
arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts:279: phy-mode =
=3D "10gbase-kr";

// SFP+, rmk+kernel@armlinux.org.uk
arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:19:        phy=
-mode =3D "10gbase-kr";=20
arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:26:        phy=
-mode =3D "10gbase-kr";=20

I've added the information I could derive from the commit message.
Maybe the original authors of the commits can help us with more
information on the actual HW capabilities/operation mode.

Regards,
Madalin
