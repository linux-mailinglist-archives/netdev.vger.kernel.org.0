Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21062E9D4A
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 19:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbhADSoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 13:44:32 -0500
Received: from mail-vi1eur05on2081.outbound.protection.outlook.com ([40.107.21.81]:51554
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbhADSob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 13:44:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTMbX6TpIFULnzv/CEaEsk+q+E7l7f26T3I8oqDmUjlGMV1N88DXjFTLLvz6IWUDFJDmn029FNSmn5R+Vvc13d7Mh4GqUGbMzjLAAZE8R4ZAvi2TGmHu97TwtgLR4D1HcqZzWq/JgbIrBdLq/qAkL5kRLkw+O8xtkRJb/U0vjjD2SukSKKF655CVoECwioBAnuRYmtWHIJWjL7DfDUqZR56bezK7hPtzmem+Cu6FSkUlrpzsJ0xRXaUCwkZ6yN7e/7xm4/12LFtJ1RQxBC8K5sp3QsoOQg7A+w5RTF0cc2hTAUwwThEWXSzfNtwdIuZQ+uWgkrWxVaJ9/OEjbblKeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPfPGelOzeJZ1ikfXRGszzi9HrAfG3xWHT2CB0ROoyA=;
 b=YWE3CEO/uaGycSSH75Y9HZExg173g220VBTQ6u7I5XfDzTyPfjiA6GDzizMvlZMiD8c9IhPLYNChGKHt9oUX6pyVSF0ga2OjV9oMmyssYo472aC/TSxxM3BupEWTDK2xVlP+pBDAcM5hbYSBSkMN6bQTAG4COBayfjf/wzcKbFs9SifT4sHa2DyWVxq6qmJgv7gyHyq6cUVfeVXrLIFBw3105S7GgYJIvjV2QMgiay+e5Rxcg2Iqu8m448/tiLoDHkwWegKGpZ8U/ENM/g/bCzAs82Z0Dj4Ae9tUPDXYg9Ld5DE4Yl9enmaI5o27BEKs/bDXU+YfVQ9uewWoxujW5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPfPGelOzeJZ1ikfXRGszzi9HrAfG3xWHT2CB0ROoyA=;
 b=LzwyifsQemZq70Hfpih5GVn5Mr0Jyato275TLJT/J89+QOi5+Qiehrkih0JCOKFtIFjueb5Xs99+hNInaldtJ2A5XOITdI23QvrvZ1uHwXtD3W6BxiDeT44RGqe1rrc9WfXI1gQayJrUDQJoFTL71YO0e9Z3rH6OUcQrsImig6w=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3469.eurprd04.prod.outlook.com
 (2603:10a6:803:d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Mon, 4 Jan
 2021 18:43:43 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f%6]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 18:43:43 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not
 set
Thread-Topic: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not
 set
Thread-Index: AQHW4pSHwxyh2hM/e0O6/3UMlPC3maoXjZOAgAAE5QCAAB7HAIAABB2AgAAEPYCAABRIgA==
Date:   Mon, 4 Jan 2021 18:43:42 +0000
Message-ID: <20210104184341.szvnl24wnfnxg4k7@skbuf>
References: <20210104122415.1263541-1-geert+renesas@glider.be>
 <20210104145331.tlwjwbzey5i4vgvp@skbuf>
 <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
 <20210104170112.hn6t3kojhifyuaf6@skbuf> <X/NNS3FUeSNxbqwo@lunn.ch>
 <X/NQ2fYdBygm3CYc@lunn.ch>
In-Reply-To: <X/NQ2fYdBygm3CYc@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb924217-bc28-4f29-4830-08d8b0e0a92f
x-ms-traffictypediagnostic: VI1PR0402MB3469:
x-microsoft-antispam-prvs: <VI1PR0402MB346921D4B4FA95D7AC89162CE0D20@VI1PR0402MB3469.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0GYfRb4/s+XHIUuq4aJ82np3KZmmcn73XFy1N/jeL6NYhDhSM1YtXWlCh+I562SRqxh+xe6fd0Txfa/9qk7exmoAMYEb3IZzUklz95G1bOVp71bb8jNvtMKE9Oh3dh+VLNmDue3Wi7ER4qtdEtkxWp7y8OC7p+Fd1DbXpVNTh4wNb1igOdHUUUkPfuwlOI292A2atqCagxkcMzfT8WcHycCoPj6rQn2dOQH+pgCAPT2MEHHRA3AHasdqip87+daUprOYmvMwPFXAJ7WGIr5bRy0JXiInS4HLG1YgbIHRwY2ABtZEG7iZru/H7LU4AIEeXypHMX17sxXp8GKXJ5+32j0USsSImAdNnYE78G8PvpWEm4dKVeUMOn/5XbVAew9r8AHgXy7P3jGDZPrNV7RqfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(186003)(33716001)(1076003)(5660300002)(478600001)(83380400001)(8676002)(66476007)(66446008)(66946007)(64756008)(8936002)(76116006)(54906003)(316002)(86362001)(6512007)(6916009)(6506007)(9686003)(91956017)(2906002)(44832011)(71200400001)(4326008)(26005)(7416002)(66556008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bvF2CkVEw99DeqFeAeFzsFDUc+W6QdjfGrWRlR1unPttXg02NrecKGH4vXw3?=
 =?us-ascii?Q?6AiPfP/rxWT0JZnIEnVS2YLAdovfcAAG/klPK6mGCbbquUZxQknxbOGTwt0C?=
 =?us-ascii?Q?ZQzLJxi83ysRZSb/CaMgQW1fMrS/XF6QygATYSP+Q38w7/Azx8B7u0DYOXQn?=
 =?us-ascii?Q?7/7fM1h2U1MdCNav5q4esVcMflhyrBb+gnkTzCZaaVI81QSdbCjL4P+V7v42?=
 =?us-ascii?Q?XcgXGSkx49AcAufWqd6N2hj2XvDn0LFExhQwnjqzXco/bGxMHfdCaSUbftWI?=
 =?us-ascii?Q?jjHhzJuY5bSDqnOtYk4suJwo01uGrvKZwMDjQ4oLTE12b9+TYkkSL5YkBya+?=
 =?us-ascii?Q?DoeeQqXgJAXmDixTTI509SkdjXETlu0gdZv5oj5UII6PdEOysH7bdYZtwiZ9?=
 =?us-ascii?Q?M+QBW5wK6rJm9MfU3FICFRNxE6espqcYe1sDakXT4P1qhIWAQcUru2AQmB6I?=
 =?us-ascii?Q?zro5kOM9Nqaq7LZSSMmCWwFZ73a9MxI/lsbFQPy8sWoVXOW23IhTEDaUgqEH?=
 =?us-ascii?Q?1yjF5AkmyYziU9zc4Hb64dxf+YJz+yYX9TmnpCW6Ujnxg5y9N+VZHGmvpujM?=
 =?us-ascii?Q?UjUurXbCMjQeAfICDPenEyWuuWiN0rE/mLWFoKueD8HvrmuXpe6EG5XYD2Ke?=
 =?us-ascii?Q?kii4Y82vp1UO8d+TOeFFkR0Gn4yTBvw2q6WIvQyM1N8qZnnvtlc+6vjO12Bz?=
 =?us-ascii?Q?ZcYTaIjwgz/s8faXsk6TAZsjGz77tbK02DvJRQZ0BVl9HFzDd87YWYYCgQJB?=
 =?us-ascii?Q?EfMgU4e0PTYFiZwHpG6hBvBkUWC0M5xCtPBtAcW6437frh1niAoztQQOaysM?=
 =?us-ascii?Q?8GCUFBDk5V8XPpilJyDJFqtYRd3I0qPBDYVYNHVmlaKPF0kTMCcXRQ9Fa5iv?=
 =?us-ascii?Q?FMyay7KMZu4GzxRBxisr7A183cA4Y8LXBipwcDRK8aIpaFsE5GpBHmT5Dlhv?=
 =?us-ascii?Q?Jzz6T6iHcIhNM+ZBtcvdqVEt81AM0VrX3OxJG1sTPD1HYll1hbdWt+HGOcp7?=
 =?us-ascii?Q?bhfi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35D2D4A914A4AF4BAE9FA5DA1262AB1C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb924217-bc28-4f29-4830-08d8b0e0a92f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 18:43:42.9436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 66BSPE4PdIMSUZSuYJ7uH+mdZ3crZd1gxIojkWVfiRwd6mAG/OTmYLHYqBVS7mWX2Ej+Ac1ne/M0dNXIjdyB4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3469
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 06:31:05PM +0100, Andrew Lunn wrote:
> > The basic rules here should be, if the MDIO bus is registered, it is
> > usable. There are things like PHY statistics, HWMON temperature
> > sensors, etc, DSA switches, all which have a life cycle separate to
> > the interface being up.
>=20
> [Goes and looks at the code]
>=20
> Yes, this is runtime PM which is broken.
>=20
> sh_mdio_init() needs to wrap the mdp->mii_bus->read and
> mdp->mii_bus->write calls with calls to
>=20
> pm_runtime_get_sync(&mdp->pdev->dev);
>=20
> and
>=20
> pm_runtime_put_sync(&mdp->pdev->dev);
>=20

Agree. Thanks for actually looking into it.. I'm not really well versed
in runtime PM.

> The KSZ8041RNLI supports statistics, which ethtool --phy-stats can
> read, and these will also going to cause problems.
>=20

Not really, this driver connects to the PHY on .ndo_open(), thus any
try to actually dump the PHY statistics before an ifconfig up would get
an -EOPNOTSUPP since the dev->phydev is not yet populated.

This is exactly why I do not understand why some drivers insist on
calling of_phy_connect() and its variants on .ndo_open() and not while
probing the device - you can access the debug stats only if the
interface was started.=
