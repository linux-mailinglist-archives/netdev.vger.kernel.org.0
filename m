Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AD13CFDB9
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbhGTO6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:58:35 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:9654
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241896AbhGTO47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:56:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKimzjSuLEgQg4gyQfptGuMHUl4Y5HmBu5QLtNB/LtZaEPstk36MDrHEPPju8Z19gZw5ROQ+0bCtRHmCzFGhcd568XpRUHlWYNkWhIEy9WZ2aRO8NDECW8urBUoY0jXfJwoCcqLDi19musQZ/MhmPzLo7pOf2dy6O8sEmi0nsA4TAVSlHVJvzIKtQs862oTy7hlothHGMp2EA+M7JWzzdDsZhJgXf0gBNVhGUk5Ecb6hjf9lrNJBhgnVL+NIbns3ztmY8rA9GZPViSqTricsZW4N0+0zspW/o2CLoF9HptTs5vWa3wXLEa2Hq+tmRW1MQwA0SnD5i6kUfxrGTPYRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amM3FE/4ZsPyf1At5EyS/WADEq3F0q294fG/XxbsPgc=;
 b=fEsPN7Y5pOatfXhcMBoT21Nj1AjwKpnkeCWbaBnWWLSS7jytBOyCXjdqmrjdYc9eWZmyP1Jv59DR90hbrDhQ9V3krWAQEh2PNZIODekC+9e59YVh2TamyAPunetLrh3y0PPbT9VE9tGjGgfs7YQbffEm/ktxsD7KPRS/ES/pGTcDd7rudqC2sK50CeNQVAvbNpvRnopAxjcngT98x//Ud/nKcBy9bLjP6b+g9Ey/8D+f9HfDCjvR9pBlHttp5oi3DZ7PgmkvnnObPHAF4CL0oxA91rsIFVVvUMIhvgKyorTKOXQonFP5zKPLxzy1SgCCQRVcX5vD2T3wZfRQAd7kRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amM3FE/4ZsPyf1At5EyS/WADEq3F0q294fG/XxbsPgc=;
 b=kmkEGD7JDqjSRpOarCHkrb8LIW2KH8zvBxN7caexAqVlGSdOenv60MRSZDW8Zk9bmbUA6/66VmX3buJuFyZ5oZTRfEfUs0UrMqid8O2C4+GA4/t7a3zS5db3+oV9pj6lDuWZ1uP7XIlr7sbc1kqxA7S8bL4sN6SK5D3nsg3SkrY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4429.eurprd04.prod.outlook.com (2603:10a6:803:6e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 15:36:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 15:36:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Topic: [PATCH v5 net-next 00/10] Let switchdev drivers offload and
 unoffload bridge ports at their own convenience
Thread-Index: AQHXfW29xPYONAiJQkyZbYsuqj9IL6tL5LQAgAAC2QCAAAOsAIAABemAgAABbgCAAAyhAA==
Date:   Tue, 20 Jul 2021 15:36:37 +0000
Message-ID: <20210720153636.pabfdzznzfuiinfs@skbuf>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
 <YPbXTKj4teQZ1QRi@shredder> <20210720141200.xgk3mlipp2mzerjl@skbuf>
 <YPbcxPKjbDxChnlK@shredder> <20210720144617.ptqt5mqlw5stidep@skbuf>
 <YPbi7NSsdDEdvmcA@shredder>
In-Reply-To: <YPbi7NSsdDEdvmcA@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af9f5631-8570-4d88-4207-08d94b9429ac
x-ms-traffictypediagnostic: VI1PR04MB4429:
x-microsoft-antispam-prvs: <VI1PR04MB44296DDFC17D3E28D337B6A5E0E29@VI1PR04MB4429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1M/TH6nnT0ioHlodVEIL6zOJL3H5PWvbD/tuw+5+qE+l0gHVLzwYyvG9Hsb47NyecP5+lT1mPE7I7rrm6awT2CpJgoeuHfrAKBUYKzUSjlas4xD2AlI8aBg0bfgWuPnw/v2QmFASFd1fya+YXL4UDBvlDGHVpQOE0S4LHkWOC6FotFkofz3FzigJN3TcBp0I/KIwYqcABoWHpfqC6vlN3l7fH/hmBDNyjGRKl2hBjVBrfltvU3K+b10yRVP1VhEgTs7CI1G8W3C6sOOL+bUgW7YNUc9cXP2fZDDv2Qxjkh3KOP7+sPbx6OtNp+xN5C7Qw0sDRYWn7yb5yAKK/SqkWTQRn0rYzLA4rGmWT2+FCoBxromqTFXxQ92kh9fwejRyLp3UTNddkDOE+MEsGPV+2zg/dtscjyZTsxK+WhKqmJFEapqFywLFzPjBv3+1VSKYyHujzqX4tMG9OzV+tzpA9Ow/Em/7PYZ9my2zwT2FpmcX5qwiO3K4/R3m59W37o5LR9SN2aHoK+JlQmk6N+kmv+eaL5zouuh1WPE7XRh8z5/st0ji/+ios/KbQltrDbsBUN5tvPIRFYtPXTa8h5Oj9MwfQgD5LPQ8yAXsu6Z1T6P3QAhlErtsF2dViS1GEsTUVVdGXa2oDXLpqitAk5OZobc/iwnviIob4b9cZy0XyfUwnaCfoaaCKBRS0e7QhiR17yIEeL1N13Dg3KCi80pXBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(136003)(376002)(39860400002)(366004)(71200400001)(2906002)(38100700002)(1076003)(44832011)(5660300002)(66476007)(26005)(83380400001)(316002)(9686003)(6486002)(6916009)(6512007)(186003)(478600001)(54906003)(33716001)(4326008)(6506007)(7416002)(66946007)(86362001)(64756008)(66556008)(91956017)(3716004)(8676002)(66446008)(76116006)(8936002)(122000001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z/IbGmmdNmvHAuV3VbPFya2CyjfQHJsVSyAnAEi21wqgxEhJT1mAAHU+cwUS?=
 =?us-ascii?Q?DPvT2EnOqhQmqTiVn1qdWVBaO8Dbw71Zi5jLwedGfJdUGTfZqKxX9NTkTQVZ?=
 =?us-ascii?Q?hB3DeDFEJ4C1se/OdwLAh2lRAt/ec+EGw1Nyfb8aIj1DMLIw4ONYUbBUB4u7?=
 =?us-ascii?Q?Abotu6wq5uoCGwCxF+BA9VKsqlcZebTq8l7HR/O1YJ/jXk78akqkT/lLwZeF?=
 =?us-ascii?Q?QvVmleIYA0KzVFCjfDk/uB4eovu6T1cBWDZ48dukoExW88ugoth/bhkwpaXv?=
 =?us-ascii?Q?yU7368rvDfN+/yyYs0wcWxQORnM5aGiwZhgUnhZ//d1cLMzsI+cqxtfDkgSz?=
 =?us-ascii?Q?olYvrpSaQm7NIHEOF5w2nKgJJBHRTDAuz0/O0+RSS9jtwmY+T5rbnmvNg9Rf?=
 =?us-ascii?Q?J/omO9WVQrt389m9nlscXLE63noJvZnPF487koMhZKCUc4MHFLVVsG3Y7q8m?=
 =?us-ascii?Q?dPOVLQytOqwfAPgXWj36vD3l0K3Uc8oSYeucEYjNg3lCLxULZfupu/SmM1Pj?=
 =?us-ascii?Q?pOgon7gQFo2oy2RwWcv8R9Zt3Rg9pX/I1z/KtBXdDLNKiVOcVoJRpXePlrrV?=
 =?us-ascii?Q?UAS3S6l0QtSy2HHplsLT5acT64suMHoVUS2mYz2ltMhf5vZIbS6/uf0KxZfV?=
 =?us-ascii?Q?QYPByvibdpS2ZIuHU5N3DEdQycUODix6kGKaUjayV6iFlVrQKpYU/oIenzWw?=
 =?us-ascii?Q?piFu9kviWaxTckfrxa4M27GqYpomccdWUPuvPRVh1Sp0g7LGHX79McfOnGdj?=
 =?us-ascii?Q?VCWQfGz3y15q6+bFUZAzPSzsSm+YetqEMPYnzmtYdyyI39LWOHVh+HpFxfjP?=
 =?us-ascii?Q?gdo53JcMrmRYOP+n/Gnn1FXjkGWxQvqhGQHmoL6vD3bTeO495T6Mr1DnSCOy?=
 =?us-ascii?Q?HM//0J5qr/G1WshgJLEeMxx1wpMtyFSTsRJpJBD6Qgs0KKwinC61rbtgdxTI?=
 =?us-ascii?Q?+Kj2wYwtW9Eqb1E0/Ekl1bbo4S9g2+HSPIRS7Dtb3unSfumHtgEowXapNbkc?=
 =?us-ascii?Q?e3ty1syAXi4ivuCLT8qirx0fAOGi218p4O+XZaIn1uF14jGbTfoKyXG0UrCr?=
 =?us-ascii?Q?hswOwTyEirJNB1OiMKpbbbzZ7Ix+bTizjSd7WNfjdamq7jANX6O1D14nb+y0?=
 =?us-ascii?Q?J3XU2DPFz0JmCKfgV0krTEe+dXxd9LeEgquwRrZlejfhqjbTOCci98MnFbqk?=
 =?us-ascii?Q?qUpfPzS3uM/FfQOtJhldxXElWwZ0OUBMTOhWyCLpFgw0YSJtBAXvkuwQUnOW?=
 =?us-ascii?Q?+fnQuUSxOOJ0ys2wB2UxVxsYQygD/cUBJoBodja7dRomWvtazlpMe34rfb2a?=
 =?us-ascii?Q?EHMyC8rEl0G8DbKxHyXIiwie?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17DEA3A2C6DEE74BB8461C5E632D3F6D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9f5631-8570-4d88-4207-08d94b9429ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 15:36:37.5683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pUnaDOrK1Qyqt2w02DmTGjFnb0Kk7IRiFB1ttwa9s4QRIwyNpP9queYVjUc8yJdK5VlrBkcks4jwpS6h4/2gBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 05:51:24PM +0300, Ido Schimmel wrote:
> On Tue, Jul 20, 2021 at 02:46:18PM +0000, Vladimir Oltean wrote:
> > On Tue, Jul 20, 2021 at 05:25:08PM +0300, Ido Schimmel wrote:
> > > If you don't want to change the order, then at least make the
> > > replay/cleanup optional and set it to 'false' for mlxsw. This should
> > > mean that the only change in mlxsw should be adding calls to
> > > switchdev_bridge_port_offload() / switchdev_bridge_port_unoffload() i=
n
> > > mlxsw_sp_bridge_port_create() / mlxsw_sp_bridge_port_destroy(),
> > > respectively.
> >=20
> > I mean, I could guard br_{vlan,mdb,fdb}_replay() against NULL notifier
> > block pointers, and then make mlxsw pass NULL for both the atomic_nb an=
d
> > blocking_nb.
> >=20
> > But why? How do you deal with a host-joined mdb that was auto-installed
> > while there was no port under the bridge?
>=20
> mlxsw does not currently support such entries. It's on my TODO list.
> When we add support for that, we will also take care of the replay.

Okay, that I can do. I had the impression that mlxsw does - I knew for
certain that DSA isn't the only driver offloading SWITCHDEV_OBJ_ID_HOST_MDB
so I looked it up right now, and I remembered. cpsw was the other driver,
and it does a pretty funny thing: the same thing as for
SWITCHDEV_OBJ_ID_PORT_MDB.

I guess I'll just provide NULL pointers for every driver except those I
already received acks for (dpaa2-switch, ocelot) and DSA. Then driver
maintainers can take it from there as they wish. Hopefully this should
also make the patches slide in easier.=
