Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE90444023
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhKCKuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:50:21 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:11233
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbhKCKuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 06:50:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0VDxvNMF0D8eZ+uvLmuISAaqPQwO7fLlkF/cjtHxPEvH3Xrg7n5bdQ2K2jUxAvlCLsx23aaFDevHPHX5/PhV+QfTvQgihdtnIEEh4YbWzlxGSzyaIQCoT64boFVz9buTjw6BEjaohQS8skKHQAWnHPc2CYy4xReqz9gm7hlhmXeezw4Q4wzExQBzi+N8LbxAB7S8oZHRrwajV5f9dr1+K5k3eZxWuw/L42AavBXuEYZ6rBSFxF/4KMex1r7RRrf4OuPI7f63F+NDdo/v6oc6tvpNEmofujh6mKzdid5U5xDas0KmjhPKKhRM9VyfUqANZp2ZWpIpTnIWZXNwwGqLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnsTxZM1LzT9IVVXSwhklgIoetQSi/L/5hx0hpoCXic=;
 b=PM0ghMcsY87R1yoiocnCjxO/LT+wriSTawGi6R74L2e8am8GUMY4fH9Idx8yRBNoHR4SWYPhp1w70KdSNHFu0yN52q9tP8tU+6UMeuCH0RtSJP50XIwRQMum9x/LD1UvQFySJN/dMpBk4CJm8fHv46j+g8WxMFCj2HJBC0dCrnCqCGKvoIGdVQVtBUNYtmFt/gAEZO0oLuR1PYWwhAW2kMsqo7QIVUpfesYwMCm3LcZXc+AbprBrRhlCNbBXt/NddkvitkUHDc49G7GPsDhAs/VhU+qMQQtH6XFGLH4ZdlKy9SaI+vstl2Ks+h9hF1yGb2MF+mKNSoDUY2LjL0Dx2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnsTxZM1LzT9IVVXSwhklgIoetQSi/L/5hx0hpoCXic=;
 b=q927r2dQeOaAthSeJeGJhJ4NOZXCFZCxX5Na0iUyyv2NcVbIPg0FNPZ3CRWFGLZXiKrs7M+TEskDJfadPrOVVc7b+OQIrmVNqS5YmeMTKY1PD+5r7NrRIwSpCe+UbS+tFMmoI5pOWBc94gF+8OdpQRo2Z4MvLYLRfYtGCw2KOvc=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SN6PR02MB5503.namprd02.prod.outlook.com (2603:10b6:805:e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Wed, 3 Nov
 2021 10:47:42 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::4513:36a7:3adf:3b0f]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::4513:36a7:3adf:3b0f%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 10:47:42 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Simek <michals@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: mdio: separate gpio-reset property per child phy usecase
Thread-Topic: mdio: separate gpio-reset property per child phy usecase
Thread-Index: AdfLMkaiDAtsCpNITLKzSmdhMK2gugAJEiEAAU2SxjAAASkJAAADizvQ
Date:   Wed, 3 Nov 2021 10:47:41 +0000
Message-ID: <SA1PR02MB8560023309823770DDAC0E06C78C9@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <SA1PR02MB85605C26380A9D8F4D1FB2AAC7859@SA1PR02MB8560.namprd02.prod.outlook.com>
 <64248ee1-55dd-b1bd-6c4e-0a272d230e8e@gmail.com>
 <SA1PR02MB8560936DB193279B2F2C5721C78C9@SA1PR02MB8560.namprd02.prod.outlook.com>
 <YYJQFt0mDpcOcxGd@shell.armlinux.org.uk>
In-Reply-To: <YYJQFt0mDpcOcxGd@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6edd97c8-2352-44b5-d88a-08d99eb75cb3
x-ms-traffictypediagnostic: SN6PR02MB5503:
x-microsoft-antispam-prvs: <SN6PR02MB5503EA185CA1F47297D16B50C78C9@SN6PR02MB5503.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2jWrIFs9Mgz2VFu97Fnzyn+cMHRI+5lMBWr9I/qW59cViHEQqV2hrhTrEoPkB5g3R2XyMef/agrbNasyZo79Dt3ZpjqWXSCYiNX7Yn9GjrfKFSXvh+yQwfLjOL2SfXLiU9abUxt+no/a0E714PQsysE/DdtlFI9pZqZIR26Ml3eG/RW1cr0R0ZY1FOJgNXKL3zHtNJuNqVijxHqYZL/azyCE6AToj6OC5YovnJALHDbAILC9F5t9ZpYu1NcZTNr8BuRECb7dkeeqFumz/B+jYvz9QIRfbf6v/hpln8pPnLe/s1m3KpdZL1HO24AtXdTxwoYSfMtRv8i/3M0DcsU9U/cADwLSjVPTrqlAgiEMMdJg8/zWSzJmqiqBJ7VotbmtptJbKOe4UYKhkvx9A2BHaECwqPMlgkvkXd7FGNBwiIWo9XRwIKGLObbwtI8h0cJDbl2vZo2pS3GKG2bQN5llPCqAc6pz1uIsIkj7EhiYBTaKkXnPCuPePWSE+8/qOpD1dLHH3vBnKid/lBhaTKuCZrX9drQEI5uNukv2N2M8zJ53U7oouZUPN3RcDq16M88SK8eGw23tjWCrh/Rq+ppJTAglZSQ0+/D7MvoFjpE7SZ+xtt4e2f4EdgmB6I+SWER/OfpjzddFSAFbnShsV2rRwRfC5fjSYot/oiZSpFhw8Z3DdFURh47c24OHhZSzQKGHB3EUUGEsoklhe75PrhNjIMw8J/6pDMaKbE2nQDVXZRgeQut73MaQNUCR3OK9xeJiLZfL4o07lHY1FUWAS7E/xgE1K8DcET0Qp3SOdGTCOjo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(38070700005)(508600001)(6916009)(26005)(71200400001)(76116006)(5660300002)(316002)(107886003)(66946007)(8936002)(186003)(66476007)(66556008)(66446008)(33656002)(83380400001)(4326008)(64756008)(38100700002)(122000001)(9686003)(966005)(52536014)(8676002)(54906003)(53546011)(55016002)(7696005)(2906002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GqvoJfNQEa1x2sdQfy7iW+7sNag0EqMGl8zkMCYiSezzP4SK1vqvE2j+ZN7R?=
 =?us-ascii?Q?zP+sO+Ry0kRkLKd/uk2Kg51+9Xp+QGxhrDLeiuRR7770zeekxNI4CCgwhey2?=
 =?us-ascii?Q?PnxVggm5qAeu+TOh6r1NHlNFVwMQGqugjouXjLa3aNM9Sa6aftB2+EhKCMPx?=
 =?us-ascii?Q?2/8apLUroAnftgCTf75cObncv5CgD5An/atRUhc29LT3J+xU2WgVzbvnULUX?=
 =?us-ascii?Q?zGQF+Xo0ncgWVHGPfYL+tJ9zl5vNMKYSMQZk8caVxpBPVcphPwftzbuBuxUN?=
 =?us-ascii?Q?cu7nSWCVMRmXWHa+zGBr0UBv9Ps9ICO8zZ0s51rIX5MYJmj5pVcMjCkKTjFw?=
 =?us-ascii?Q?nS55XRI36rJMi9YIX/n0KsEurOIgkJiQodDLpv5RRuNPWZFWYRt3h8WO8ZAY?=
 =?us-ascii?Q?3nwLVj7qEwoxMwPh3o9Gguumu+WON8izrriojnXsswvN8YqG/CQuWxGfd+/L?=
 =?us-ascii?Q?xCtc6xS6lcsi5EKwio3e7mSalFcS7fhfCQrIClkQFKZ3G9yxPg16xJH2ilZn?=
 =?us-ascii?Q?QdwGN+ZUt/2npykqB5r1E8IcQN3Bzxz/u7S9IKAdROm+o+H0NHy5MPujYNDh?=
 =?us-ascii?Q?iRdUKLIsR8hp7gzncNJ2wR8VSQHmlxSd1ePAD6y7SBdmnsOYqeml0n8lfs6I?=
 =?us-ascii?Q?5hjA8ohcywjHn5baZNIuI9A50m8ZuQG4LLmzO3njvD1FQCYZI8+cnvdk7tfn?=
 =?us-ascii?Q?fHLHWRC9VqA4NppkYXzsHB4FakvwrUuoRp3aljYmE+xi09vWkub7FD6UtBuO?=
 =?us-ascii?Q?zuPyos7Dg0+m58Bsb8/ime+GaINHROUD1f3m7r+dCotfdS3mucc67CdQxFsx?=
 =?us-ascii?Q?2byO2/xDj+n0TCeU6D3WzGzNI+GTDD/+wXIfLrqoJJjwM+0FBZNnXCO5ixbn?=
 =?us-ascii?Q?OJyrKd8BYMaX9fTA2biKVkCAUtjxEtukFBJ35QewVdyeNsNh3YqboTxUS54d?=
 =?us-ascii?Q?MEpNtleYRxO9UZDxDYu0iSqjTf8STWrlsmv7+JI84OxyPsbfT26rYjh+t01L?=
 =?us-ascii?Q?G8WGMEFKfPx0rxtjCarqFCHonN7jx07BspGEvkyBJWs6J2QxglUGM+NFdsG7?=
 =?us-ascii?Q?gSZ6HdKurqWNlfPIDxYHzxqP4GIgaF+ZWxPekARBh9zjKIDdI4OCt6U5wJRh?=
 =?us-ascii?Q?B54cEMuNdkiPLbXzfJKfkuQaCP9LLLW98O1LKil5bj8cgO4hNpgW4XKi7ERD?=
 =?us-ascii?Q?6NF27EiXvMVJAYWUJRhhK2OluRJ7MGeABYQQrvIElZAPqiLBWKjXdfAYDYHP?=
 =?us-ascii?Q?l+pk1gUKFRayB4sDXq3xqGsxdvDe6nNIN/beiVKO21nbQlkIQEoOqbuvUBih?=
 =?us-ascii?Q?L8hwojc3h9Wd9QHBOAqKFQax5HLaXzbm4A7GaLYhFk63Ciwmpu+yBew5Y1MG?=
 =?us-ascii?Q?v6Quq960zt1/S8jMprEh3edvSU10BLBj+hrmD1CNRuWpf/iCRzL/kPAr20yh?=
 =?us-ascii?Q?EUCjL5mMr809XVjGsN9dA/HiD+0Ewem0qN01aemG8TgOsiwHASEvQ0cn7xd8?=
 =?us-ascii?Q?8MeYPcBoktFcg+q2f4VWWZy3KNRY4RDKR3JGK6H3GOkX9KjpWDSjOjlCONG/?=
 =?us-ascii?Q?XlrQotiNohyLMK7EiHNgqH41MOh2anqbk7tH2/zpc79Yz1S25494oU9YkhJK?=
 =?us-ascii?Q?38TVn9D/DOI+v3fyvi/XtjY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edd97c8-2352-44b5-d88a-08d99eb75cb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 10:47:41.9268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3rUyma8Wn+HsbuhptqejhesZA3mKAAUg+Qo+YuKpyTxfzo/10qbOXy8mmPdXUyhzamxx9LJvwerCoW6idynRIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Wednesday, November 3, 2021 2:32 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>; netdev@vger.kernel.org; Andr=
ew
> Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>; Michal
> Simek <michals@xilinx.com>; Harini Katakam <harinik@xilinx.com>
> Subject: Re: mdio: separate gpio-reset property per child phy usecase
>=20
> On Wed, Nov 03, 2021 at 08:50:30AM +0000, Radhey Shyam Pandey wrote:
> > > -----Original Message-----
> > > From: Florian Fainelli <f.fainelli@gmail.com>
> > > Sent: Wednesday, October 27, 2021 10:48 PM
> > > To: Radhey Shyam Pandey <radheys@xilinx.com>; netdev@vger.kernel.org;
> > > Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>;
> > > Russell King <linux@armlinux.org.uk>
> > > Cc: Michal Simek <michals@xilinx.com>; Harini Katakam
> <harinik@xilinx.com>
> > > Subject: Re: mdio: separate gpio-reset property per child phy usecase
> > >
> > > +PHY library maintainers,
> > >
> > > On 10/27/21 5:58 AM, Radhey Shyam Pandey wrote:
> > > > Hi all,
> > > >
> > > > In a xilinx internal board we have shared GEM MDIO configuration wi=
th
> > > > TI DP83867 phy and for proper phy detection both PHYs need prior
> > > > separate GPIO-reset.
> > > >
> > > > Description:
> > > > There are two GEM ethernet IPs instances GEM0 and GEM1. GEM0 and
> GEM1
> > > > used shared MDIO driven by GEM1.
> > > >
> > > > TI PHYs need prior reset (RESET_B) for PHY detection at defined add=
ress.
> > > > However with current framework limitation " one reset line per PHY
> > > > present on the MDIO bus" the other PHY get detected at incorrect
> > > > address and later having child PHY node reset property will also no=
t help.
> > > >
> > > > In order to fix this one possible solution is to allow reset-gpios
> > > > property to have PHY reset GPIO tuple for each phy. If this approac=
h
> > > > looks fine we can make changes and send out a RFC.
> > >
> > > I don't think your proposed solution would work because there is no w=
ay
> to
> > > disambiguate which 'reset-gpios' property applies to which PHY, unles=
s you
> use
> > > a 'reset-gpio-names' property which encodes the phy address in there.=
 But
> > > even doing so, if the 'reset-gpios' property is placed within the MDI=
O
> controller
> > > node then it applies within its scope which is the MDIO controller. T=
he
> other
> > > reason why it is wrong is because the MDIO bus itself may need multip=
le
> resets
> > > to be toggled to be put in a functional state. This is probably uncom=
mon for
> > > MDIO, but it is not for other types of peripherals with complex
> asynchronous
> > > reset circuits (the things you love to hate).
> > >
> > > The MDIO bus layer supports something like this which is much more
> accurate
> > > in describing the reset GPIOs pertaining to each PHY device:
> > >
> > > 	mdio {
> > > 		..
> > > 		phy0: ethernet-phy@0 {
> > > 			reg =3D <0>;
> > > 			reset-gpios =3D <&slg7xl45106 5 GPIO_ACTIVE_HIGH>;
> > > 		};
> > > 		phy1: ethernet-phy@8 {
> > > 			reg =3D <8>;
> > > 			reset-gpios =3D <&slg7xl45106 6 GPIO_ACTIVE_HIGH>;
> > > 		};
> > > 	};
> > >
> > > The code that will parse that property is in drivers/net/phy/mdio_bus=
.c
> under
> > > mdiobus_register_gpiod()/mdiobus_register_reset() and then
> > > mdio_device_reset() called by phy_device_reset() will pulse the per-P=
HY
> device
> > > reset line/GPIO.
> > >
> > > Are you saying that you tried that and this did not work somehow? Can=
 you
> > > describe in more details how the timing of the reset pulsing affects =
the way
> > > each TI PHY is going to gets its MDIO address assigned?
> >
> > Yes, having reset-gpios in PHY node is not working.  Just to highlight =
- We are
> > using external strap configuration for PHY Address configuration. The s=
trap
> > pin configuration is set by sw stack at a later stage. PHY address on
> > power on is configured based on sampled values at strap pins which is n=
ot
> > PHY address mentioned in DT. (It could be any PHY Address depending on
> > strap pins default input). For PHY detect to happen at proper PHY Addre=
ss
> > we have call PHY reset (RESET_B) after strap pins are configured otherw=
ise
> > probe (of_mdiobus_phy_device_register) fails and we see below error:
> >
> > mdio_bus ff0c0000.ethernet-ffffffff: MDIO device at address 8 is missin=
g.
>=20
> This is a well-known problem with placing resets in the PHY node. In
> this case, you must add a compatible property as well that matches
> "ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}" so that phylib knows the
> contents of the ID registers.

Thanks! Using ethernet-phy-id compatible property seems to work.
I think we are good for now, will get back if there is any followup
discussion required.
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
