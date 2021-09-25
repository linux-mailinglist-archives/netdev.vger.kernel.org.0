Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA39C418418
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 21:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhIYTOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 15:14:50 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:20785
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229711AbhIYTOq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 15:14:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXgXyRoPJRtgMxsETXWBpau3KyFhvCQYdC5x4DhxihV2OvYiYU6fmLVomKp4WevH+yGDgDjVrlfgHZkdGcNFeaKMW94cHUjXE9K+Z+LK8QRHUlMEtA990CipEEWOdSOIPZglKRGN6kGTOfQkUoIGihsZnoFemcL8J643WV1A0J6CMEdbLTslJpu63OsH2UjaupvfD75ALWV0C1GqkMF0L9H1F3RmKQtxjEshf5rz33Efeit5NaJaYN70FsuBc5XTs4LrQBYGRW/1BKNKzOT9NRPQICErYoiLUDNgAGB0GkrtQWYyxD5+wIcRoMmJphMojoFw/pVsgqq2s6epdMUDyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QQ15CQp7Wq48KxjnGRP/qJKXSl0/TCjjEhUTVl4o3W0=;
 b=ffIgF9YcvhRZh0irycn76VoT6Rxyc7CMTLTJxM3IMT5OGQoYCZHWwc5RoaIhVMpb11OU31IY4o85oO/GN+h2P2IcIDDxWLIi+nyy4HXKs+Ry+nxKuFiRC9ZiQ6rmc813P0rR/tyr1dfJEDY/BLMW0Ut8pXrfwCuez3D91Y+L+vsHfQkCEwoLMDp3DdiHRRZQQSXyXn99zSeRmJwai/Z4aqeInxsyt24w4WivYv4wvYvSQJP9y7/q+f+5DFcCHWmm7vtdG/C8AGykNOwvFnOVu1/PXp0arGDt4nBMw+l1kZtg1qo1+yhPWX6l5QRh38/09xn4EwP14xiZivDJohIP+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQ15CQp7Wq48KxjnGRP/qJKXSl0/TCjjEhUTVl4o3W0=;
 b=UCmxgsnfCi2hbfrRNlXzuST3KHNbgVNow9hqdgdd6WWmS83HxzMvHkC68J9g2fnwnfgAB6wS8u7LPe0Jd3zw8q7l38gBrVHih2z8XL6eEOibF3vSkmRckW/7WiK4NhR0im1PuxR1AitK3EREeOYFUfP/eudjfAvSlvjE/iCjUWs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sat, 25 Sep
 2021 19:13:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.020; Sat, 25 Sep 2021
 19:13:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v5 net-next 1/9] net: mscc: ocelot: serialize access to
 the MAC table
Thread-Topic: [PATCH v5 net-next 1/9] net: mscc: ocelot: serialize access to
 the MAC table
Thread-Index: AQHXsSiNdI/FyYdkjEKxnocevBuSrqu1IG2A
Date:   Sat, 25 Sep 2021 19:13:08 +0000
Message-ID: <20210925191307.qoon6iz32gep6st7@skbuf>
References: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
 <20210924095226.38079-2-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210924095226.38079-2-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bb89d0a-ce2b-41e1-e5f0-08d980588283
x-ms-traffictypediagnostic: VI1PR04MB4685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB468552DEF48FFC9D046D5241E0A59@VI1PR04MB4685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xOMiDJeRGbM/xuWEmBwAGGYzZDrq8yHhgG/Lfs9xXYWLJ4F4IoANUSoBsAMVv6N2YCBzvMmr0Ref/uFO6HVCOpoHRdnyjJvbpse3udcnExGh6K05Q+1jUSxdFcTnYoLk3YV6B8emAaReBfbqNlkQJa3NSs6OG9lT2IVgxhMDpI0ZMxFw8aEYAMu2Mv4XIsL1LA1bYCmSt//OYaXcuUiNJ+XAn+nmHQHoW9o3lCpkKSGQwYcuMrxjIpHzQFRMyRl1fa7GhyrSsPMq4kyZeKG5hh1oljEhHJhh/BRFYeqQceLq6miVUrYtZMxZH3pcaXXtPd7JqAxnW75ws1br4sG8vtaRo5mKh1RSLtRe8QrO9Ko8eeZbPoQSbXVySFEUo0zD9Kv5ErW4Af4WEoTP/Eqm4GvxivBUe8bJFhndJ0lUS6aFgI8hVWMbFNXWm8rn/E4KWenyrrBBcYvERrC8Y1vABJnWlKxsGhJjYSTIhJIThnYQMO4hTfFwXDbALdRFhC11fUSgVioYOnDQmn05X9z6NPQRHkJlRp1+i/csrRR8TvswqyxHfzWByJ2C9ZKvmVPQ9cHwo0hyvVEcbLC70g/JDv4Bp3j6vCD7q+1O6ctNb2EbsSbCyUYQnRIXNHa17jApQDX9gcVL7n/s+/+QH5f0fltwi1uNOoCTQlEZC1nWTvHUCz2eepsmSyN7l/FpZCPihhoYGe6gdrRz1XVjTfaMIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(8936002)(33716001)(1076003)(8676002)(66446008)(64756008)(66556008)(66476007)(44832011)(66946007)(76116006)(91956017)(508600001)(71200400001)(2906002)(38100700002)(54906003)(6506007)(83380400001)(316002)(6512007)(9686003)(122000001)(4744005)(38070700005)(5660300002)(6636002)(6862004)(186003)(4326008)(7416002)(26005)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qy32qJoBRS8Kzo5kQ0BMQiyS1v7eRZnMSZINEV3Ru+l+JEJG4rxysz4hLm/F?=
 =?us-ascii?Q?odNpmEyfP0SezrIDhLQQ05P7MHpWCnb+N7U5lb0jKCnLgxUEg16mWGVeEup5?=
 =?us-ascii?Q?HpgEPHpqYAPZo1F5JX/GVDZmtzfqw1NtmuksJl+9qCV2GkyCj5Jr+kCsFNXS?=
 =?us-ascii?Q?Q1IAFjl3oH/2PK962hEAYOaPPWAc0NE39nF153oLb1KGW3tUkgKV7Y3OVAVu?=
 =?us-ascii?Q?NlUX+2jdtVp+Mg+T/JuWsJ33fzbqfBdSQwX1wej2v254TYoP0F8uFykJ3Vd5?=
 =?us-ascii?Q?JG6A91yYVxr67kvhY29Op5i/rMAxe4PO6NwjL3jgPnVL2fQOxjIfXHgJ+HGn?=
 =?us-ascii?Q?eClKDRQxY6fUlCdCZZjEZ511eoxtVJeybaayU/EOow1jpKYj4Y+liH3JLEeU?=
 =?us-ascii?Q?AgS6/BlQgQSgRTB8NuFkoDoA1TdBHXQVsBmiUbgxszAO9FxlTQ3htDTrVlTS?=
 =?us-ascii?Q?3NAzaGWgbUJC5r33dVIMiEQR4iRqvK8m+i+/VBlnWXXFVyzDDoJ3OnOvRFyO?=
 =?us-ascii?Q?nFg1FSzZtcAypuwVrfpYVOgIM7cr+VdOrRSCKq6uDp4l56uGJ6gDc3z/5MYM?=
 =?us-ascii?Q?4tawzArTA713d90TsHShgyyk6bCWMVr1hfJ8DJpILXTBXuyp+kMOBaQXjEzN?=
 =?us-ascii?Q?/6Q2LrPnYuSkdgb1jUKdQrC7lT3KfVprhbnbAl/qwtqqbzSri5HVcSeRUlui?=
 =?us-ascii?Q?dWZAO5I7l93E75D/PRNtDHfGN9V7ALeev44OmkfO0RcLz3ojxH5mz6VyLWEu?=
 =?us-ascii?Q?fYGrmbzhLDd69rTrwAyVJTtTpC/hQSMAtntK6hyenit3xrAxi0wOIga7bnEM?=
 =?us-ascii?Q?U4PkkBupcrn+kXzwQQeo/U5yTUXJwBpHn3W5qxF88pA9+f46At4It5tsKM6b?=
 =?us-ascii?Q?9UeN4ONrPbPeTWnh1kKoYf6WBa1b3qXEUsOokRk7b0gYdUgZ1MBPgZR7bFnx?=
 =?us-ascii?Q?J+ptYiFkASpxYa9RulqIr+FIJoo9lHheTfap9+ucMjv2cGDasXXsAekbMNSe?=
 =?us-ascii?Q?9dqJBp2O/iYOk8X8p1Jd7zrTCEYwsrCs588WUnne0GA7z4WhRkic7amatxL8?=
 =?us-ascii?Q?leE7t3y2yAROcZPPOgme3/DQGabfH8BoQ/KnytAbgX2qNTfbWj16Q9fXlBvP?=
 =?us-ascii?Q?HWm35ip/7VTjbPnpZStIX6phnhV/hjOXji5JLtcX+Ct03JR3+zbKkvWh+viY?=
 =?us-ascii?Q?Q1167CSpkl+RjvzNK8fTTDy9NtUmF6xNznl2oj1PcY24TekRu+G5Ph7JWhIi?=
 =?us-ascii?Q?fX78KK3gw96DjfpZef80mmm2WrSzSxu5+Ymt6JuQKa37lOjzMd6iKPW/t2yh?=
 =?us-ascii?Q?2084kTkSr81Yl57tgMNCXkBd?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B54424CEF3F0841984A1D574DF49BCE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb89d0a-ce2b-41e1-e5f0-08d980588283
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 19:13:08.4095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zITmhjs5LpmfbPtM2tXatZzec1EsEZWwe8Yzga6auCc/zKdNi25HV1FUk+wC0dg3IhEbOrUAK20Bm7ib5mw9+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 05:52:18PM +0800, Xiaoliang Yang wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> DSA would like to remove the rtnl_lock from its
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers, and the felix driver uses
> the same MAC table functions as ocelot.
>=20
> This means that the MAC table functions will no longer be implicitly
> serialized with respect to each other by the rtnl_mutex, we need to add
> a dedicated lock in ocelot for the non-atomic operations of selecting a
> MAC table row, reading/writing what we want and polling for completion.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

This patch needs your sign-off too.=
