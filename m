Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9901920387A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgFVNv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:51:59 -0400
Received: from mail-db8eur05on2076.outbound.protection.outlook.com ([40.107.20.76]:6072
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728341AbgFVNv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:51:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePgBe81nNdR0PdTqO48o+5RxtF6kG/3eH+11yFZRe94f2TE5uYubIGL21MkeHWbWE9kLv0Ew5tp8Bk04QxpIp7uvfmB0SFHtT4w/eRPpnkroNAW2bOAnKnz2GZ/1H/1JibhLGV4aomuU4lIqnu68QV/3iQ8QaY53nghQs1mDp0IKIOI8Eupww2xWLZ3mhoPeMtxYxI1+cO9iBlWwxKdQYbQnKNKO2YH0RXpkpQfTjiEE9i/re0Na3FABCCGKNF1VRj5yLulcAw8c4jdfSlyDcvngp1iy8zR2h1JH/aodlL9Xo0Dvm32TkOcgxgsa4wDbmwO2qt/WE+ImLJpgLgMmnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhRIRlN+1xMJsFTzOq2+ZvB5RmuPIxxsphbt7vOlb6I=;
 b=A+xBb+rw3uuXxMCcQkBHYajvyTpuGlM12dc8XlAlLDUdR5Bdmwve7uBhMxmpLpihe1VYsguY5L5yUyTUR9MWAmUcmC4PBQFsvGqgDgDTZ+URp7ig2ZOiamaRylpZsfGaafetcw2aPH3/pg5eJmNBcE+uxPTXwTe2j366z9XYtOLueGTviGqxg0f3jthBa/kck5msUEbEW3FBMB444MheO6A+mMIQFk6wCPk5jzMmKWkEoXf23mpFGUuCJCXTOcBk+OyoY942+sDvGFl3VZvfQg5tvgHatB1I8ao1zrTibP89NolSLQpTBtc6pYYGdCS0NVc2tK7+A9pBUNE0lk3JXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhRIRlN+1xMJsFTzOq2+ZvB5RmuPIxxsphbt7vOlb6I=;
 b=sZFXpu9AakL+zXIIRwIAaf+7IJ4sORqLDVC70f2n88vSgPp1rAuuMTPQe27OyjRkt1DK59cY1iEW6bxmK4J2PjpoMM2/p48FA778dlzVwA2JwtLwKnqTZStdGdOPdFPhuOUY5Mgv4T5gZaKnJaMk9SNcMb0SD1aF1VZZ/akdX0s=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3487.eurprd04.prod.outlook.com
 (2603:10a6:803:11::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Mon, 22 Jun
 2020 13:51:55 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:51:55 +0000
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
Subject: RE: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
Thread-Topic: [PATCH net-next v3 5/9] net: dsa: add support for
 phylink_pcs_ops
Thread-Index: AQHWSB8ioI+cI4qHb0G+pa0hKk9LCqjkbb+AgAANnYCAABI4gIAAAfBQgAAOSACAAAeSkA==
Date:   Mon, 22 Jun 2020 13:51:55 +0000
Message-ID: <VI1PR0402MB3871A4AD4767194D1CCA6AFEE0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-6-ioana.ciornei@nxp.com>
 <20200622102213.GD1551@shell.armlinux.org.uk>
 <20200622111057.GM1605@shell.armlinux.org.uk>
 <20200622121609.GN1605@shell.armlinux.org.uk>
 <VI1PR0402MB3871B441D15250A8970DD5A4E0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200622131412.GF1551@shell.armlinux.org.uk>
In-Reply-To: <20200622131412.GF1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d471c85e-fa10-4207-649f-08d816b36ce6
x-ms-traffictypediagnostic: VI1PR0402MB3487:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34877937B7B1712D440B6967E0970@VI1PR0402MB3487.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Gmjzv7db0y/hLbDAa90FUaJNLQ24OCDJy7qdTMMc0PbvdT15zRS4I9LY75YSTIRtarzkd0BrNXCrtvkQjxZ89NInsmPkl0Mlz1bRcpGgQSL2sJHJyD+GpZfBjbZISl9auFmGWoj8rTKNlOl3CYtuR32vFrEHkUdTA9HdgDcsPoD+qzLa+jyPLDe3MkQidxwpDstCSU38wH3OeDOqt0o2XHawWYEOK0Km2kdybZOE+DczYjph+owSjhCq5TdR9/wRtY3219BvG7PUPqHamUfBV6rPcXQcY65nE1qf3lKFE1WLG8aWrnx3tdBlv4skt/nG3tCX+xyuqTxz2KznJ9JGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(66446008)(64756008)(44832011)(8936002)(54906003)(6916009)(86362001)(8676002)(5660300002)(316002)(66556008)(66476007)(76116006)(2906002)(66946007)(83380400001)(7696005)(71200400001)(33656002)(6506007)(478600001)(4326008)(55016002)(52536014)(26005)(186003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JD+JkIY9T1PPSaKb9r+uq/C8PevuHP+XQswRg270EgFYqotSuABhz416kVX8xyCbgaL0F7+A8LBX6nIi6LcNL3iKdQB0m1+gg9+oDk6AyVUJOpisMHkUt4+TN5mjW2aJLym4cn0kig3Z01MRw6sYZGk67bsktGpuT84XG/89L4JEvKNXgHvnmOLuFdmmNOaZUgFMTlTedVLykZV7VU2dhltLlwSDgqYB9faYXIq3pk/Ix6CN3dUdz0BtL7fAoOyPGDI+slaHKffHrNPv9LQ74I73LFPKrEMcV9aMLNqG9OKPJX57wqgHX6R0Io+XU9iIUOSQwwdGcgasyOLp/wAAd6UlVs30RBYsvn52OIBp/Hx0G6KDyRcBac62fF4BDe240onD5TlQbVivClMf+HXcGSwJTBXtbjGwzGZY3000+j0WsgXgW/SOqNOTTtYSHpIAn9G/Qa1dnWfkI3fd55GBm5ilQl2mtDmOc3S9tbT8snw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d471c85e-fa10-4207-649f-08d816b36ce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 13:51:55.3771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XhJP39PmDTwNyMXgQWlxkWlgirNFYjtJUpLfKcIo0QV3r/64GVI+sIHKHXpqzTWS0pARx0g1wvpdb6TBjv5XeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3487
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pc=
s_ops
>=20
> On Mon, Jun 22, 2020 at 12:35:06PM +0000, Ioana Ciornei wrote:
> >
> > > Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for
> > > phylink_pcs_ops
> > >
> > > On Mon, Jun 22, 2020 at 12:10:57PM +0100, Russell King - ARM Linux
> > > admin
> > > wrote:
> > > > On Mon, Jun 22, 2020 at 11:22:13AM +0100, Russell King - ARM Linux
> > > > admin
> > > wrote:
> > > > > On Mon, Jun 22, 2020 at 01:54:47AM +0300, Ioana Ciornei wrote:
> > > > > > In order to support split PCS using PHYLINK properly, we need
> > > > > > to add a phylink_pcs_ops structure.
> > > > > >
> > > > > > Note that a DSA driver that wants to use these needs to
> > > > > > implement all 4 of them: the DSA core checks the presence of
> > > > > > these 4 function pointers in dsa_switch_ops and only then does
> > > > > > it add a PCS to PHYLINK. This is done in order to preserve
> > > > > > compatibility with drivers that have not yet been converted,
> > > > > > or don't need, a split PCS
> > > setup.
> > > > > >
> > > > > > Also, when pcs_get_state() and pcs_an_restart() are present,
> > > > > > their mac counterparts (mac_pcs_get_state(), mac_an_restart())
> > > > > > will no longer get called, as can be seen in phylink.c.
> > > > >
> > > > > I don't like this at all, it means we've got all this useless
> > > > > layering, and that layering will force similar layering veneers
> > > > > into other parts of the kernel (such as the DPAA2 MAC driver,
> > > > > when we eventually come to re-use pcs-lynx there.)
> > > > >
> >
> > The veneers that you are talking about are one phylink_pcs_ops
> > structure and 4 functions that call lynx_pcs_* subsequently. We have
> > the same thing for the MAC operations.
> >
> > Also, the "veneers" in DSA are just how it works, and I don't want to
> > change its structure without a really good reason and without a green
> > light from DSA maintainers.
>=20
> Right, but we're talking about hardware that is common not only in DSA bu=
t
> elsewhere - and we already deal with that outside of DSA with PHYs.

I said before why the PHY use case is different from a PCS tightly
coupled inside the SoC.

> So, what I'm proposing is really nothing new for DSA.
>=20
> > > > > I don't think we need that - I think we can get to a position
> > > > > where pcs-lynx is called requesting that it bind to phylink as
> > > > > the PCS, and it calls phylink_add_pcs() directly, which means we
> > > > > do not end up with veneers in DSA nor in the DPAA2 MAC driver -
> > > > > they just need to call the pcs-lynx initialisation function with
> > > > > the phylink instance for it to attach to.
> >
> > What I am most concerned about is that by passing the PCS ops directly
> > to the PCS module we would lose any ability to apply SoC specific
> > quirks at runtime such as errata workarounds.
>=20
> Do you know what those errata would be?  I'm only aware of A-011118 in th=
e
> LX2160A which I don't believe will impact this code.  I don't have visibi=
lity of
> Ocelot/Felix.

I was mainly looking at this from a software architecture perspective, not =
having
any explicit erratum in mind.

>=20
> > On the other hand, I am not sure what is the concrete benefit of doing
> > it your way. I understand that for a PHY device the MAC is not
> > involved in the call path but in the case of the PCS the expectation
> > is that it's tightly coupled in the silicon and not plug-and-play.
>=20
> The advantage is less lines of code to maintain, and a more efficient and
> understandable code structure.  I would much rather start off simple and =
then
> augment rather than start off with unnecessary complexity and then get st=
uck
> with it while not really needing it.
>=20

I am not going to argue ad infinitum on this. If you think keeping the
phylink_pcs_ops structure outside is the better approach then let's take th=
at route.=20

I will go through your feedback on the actual Lynx module and respond/make =
the
necessary adjustments.

Beside this, what should be our next move? Will you submit the new method o=
f
working with the phylink_pcs_ops structure?

Ioana
