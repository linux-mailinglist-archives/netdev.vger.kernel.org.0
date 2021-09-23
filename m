Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853CC415545
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 03:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbhIWByN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 21:54:13 -0400
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:41566
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238177AbhIWByM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 21:54:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCRf6sHBel79GHWVxdAsM+SWJOUfUogANqQLCXxkAo7TPwyeaOVB/Do3WwFadC5w6rxxlSjpbTSkbFgtvFolJ8UdLnU2pmiDqKaVbtFci40ZOdja6MHmgn/b9Su1DqdR3egUod4+xTM0VYWYPZu7Xa+Ft09DgRXR0KSDf/7KVha5cpN3oRR3d9tnzIN3Nihs/TFWVve8MQ7j2+3J89D5IVkRe89xQ+2F2NDxS3ivNZRwgWVaEosUzZysYCammZBZS/sH86oDaLFtzw8+wb3E8S6mbgMFtSO2LQ/M8YjRQrJLVH9OzBm6TMGIxN848XDp7yTWQeD8JST6XxDGSqWDag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UB+IkQdMGLbsJ4u1sFiH18lPK0i4EnBZzVtGRKUg6qE=;
 b=Z6sU1wWZTyarRXS8vzVOsHToo4L9OaxJQjHiJBnoXtkplHgyeb7qNzCjxvWvaNY7XmscByuFFYVnlOAtW8vAR4HaJzA6PccEdD30bRbW+7W2Ysoeqe+e4y1WH7KBwb9u00jirZ8NGB3TRmRyLf4fymRwUlhdtvN+p9LFK/5NqIVVRM8cSRjjkvhFTkyxrPJZ0YFM7oXjrggKBtUHUbyoPcnsjQWkpERE6nxFBkTLkqi8OEFpGl/qTuau93ZyyetdaAvYsGp86DsJWyoB7di27PEh9JBE6miGdu+XyRvva29bwTmd+8dBi9YmiHvsF0ZutVEKg6nBB6tP6PMb17WsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UB+IkQdMGLbsJ4u1sFiH18lPK0i4EnBZzVtGRKUg6qE=;
 b=j59Oh3DnC1skbAtAq5G5AUmgyX6ykQl6C1VUeaDfWE/o77/Jj6H1YYjbuiHok8MZEJUjxGrydz+stdx+tE9PFOPeSncY0wi2PTOaZOgJ8bqasvdBlkwufmKTEyvkSj8IR2ejN2iorbUM2TudO+E0wFcCT/BIZN09TIT/YO6aVsM=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB4954.eurprd04.prod.outlook.com (2603:10a6:10:1e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 23 Sep
 2021 01:52:39 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4544.014; Thu, 23 Sep 2021
 01:52:39 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
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
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: RE: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Thread-Topic: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Thread-Index: AQHXr56IVK6JKlDdYkKzYzpAt9AcBauwCXaAgADDz0A=
Date:   Thu, 23 Sep 2021 01:52:38 +0000
Message-ID: <DB8PR04MB578599F04A8764034485CE89F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-8-xiaoliang.yang_1@nxp.com>
 <20210922131837.ocuk34z3njf5k3yp@skbuf>
In-Reply-To: <20210922131837.ocuk34z3njf5k3yp@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f16d1d9b-6de2-467c-6772-08d97e34d2dd
x-ms-traffictypediagnostic: DB7PR04MB4954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB495445CBB1BDC584C103DB15F0A39@DB7PR04MB4954.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1lZfxHlFkoidsY3nL9Jr402fWCkojvniB9fle2BIKuz8pDZ0FczcqswOS9N2n9BftIxQb2z+89+LUr0Q9hLrqc+gxLj5ZBnNnI/GQ2/WAmLjRUpXL1GD3/HAPiqPsGOLA7+OwYPWF+vw5pFYmJvc+AAz9E/0mdXhS8Z9g7tg2rZv1WfAs1dqxdxNkR2u8aOC5AtuN6lkYoXQrauqdWBVlJ/IQGuhmUAVNkODk4e2HXxio09Sp1O2y5/7nassvQ9W+p5YvLXfCxZF+IGrebtP5QnhazJdyYRwzM9my+0d47se4kI6aiNxM3cGtA9Oj7mQuO79VrmHASMqcLvzHSyz0u//xXe9X4dLog1+3DR9g5P2J1OKucnJoX55EHVy5KbD1bsdqjvP8mcodwr04WBm7nJ3gp049BZ39zcoO+V07jttHmdk9tw36Dq0rdBfcx3qLH8E4AWwpqBUCV30/uPuY567N1Ll4YXreb4+peIVEasQu5ZkKE4W9n77AtZlZEuWRgMUh9f/H6ypIeSXbAoFGG6LAJ3PPA7QRdrtqXFt/KfvQJjsyw//BBSZriq1/VkE4c0LGUcndRDgof2YlKAU6KWm+km2kfo7rvmU17hMyVHXmcgFSpzWalb0CC/WP0heEk20E8rCvFsz9Z3gj0KasPe3zMGaUlrNWvoUVbUzn+FVR4+2HisVK3rh7xqiaVaFKM0jcjkvelJmgr7B8FQO3y9AVRuKRxc7ud7InRXSI3RRRSIGhjmT43+/5ZEwaizomapZCskzSfpLhlrWTo2BrTcfVUuomoVl5QZUpoOVj/w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(66476007)(66946007)(66556008)(71200400001)(5660300002)(6862004)(6636002)(64756008)(508600001)(6506007)(76116006)(52536014)(33656002)(38100700002)(8676002)(7696005)(53546011)(8936002)(38070700005)(966005)(66446008)(2906002)(122000001)(55016002)(86362001)(4326008)(26005)(316002)(9686003)(54906003)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TD4w9mW2wHqIREgrfpXxDufmr+aES2U69YOLU23mInDMWkBCUg170AQli/8U?=
 =?us-ascii?Q?HRoV5rNKV1rjYRnYoW9bWPp7J9V3PUt9bc+BkggR+FLjb+ShYAXhbEV9Fd9O?=
 =?us-ascii?Q?DkNiTsm8H2BzowzQTXfQqFIlGksl3avdSFOkW2wFbcU4eIW1nPZKJUzoUi8F?=
 =?us-ascii?Q?Go4+R9KFeLFzWqOqb3GSsQhL036Lg4aF8WL1Co0ccNhwjryV+GB3EMpL8okT?=
 =?us-ascii?Q?8+D1xWDb9w0AKwL2WFeYt2RQR3H3v5+UeNYnsQtIiLOK33e7UrhePXHQV+l/?=
 =?us-ascii?Q?esjTySZa9xxis6xBc6gwFQrk7H/7QwuPapf/c9CObf7rwbEhCwiskc//GIbH?=
 =?us-ascii?Q?HSwjqnmeJclsDAaCGbjvIVUyGe1Te0MGSertfihLY3f1Xa5/J0behSd2tfYi?=
 =?us-ascii?Q?PdAUA/YQBYeDGNQlp88dN2yaImVCKtU3fuGX/tfwQ6cB+EPvB9aU/COeC2mq?=
 =?us-ascii?Q?KA1a1NLBP0Lf517BIyXSnWhyAooQiGivpNXLeSA/EwQIWfYxho1ty5wcy/vR?=
 =?us-ascii?Q?gLM6c6jcrZ/cCIy8TXsmVl+4h+1w8IcIa05kywBiZHPkiXHPljcjI4ZjHDhc?=
 =?us-ascii?Q?DDtPijvj7wH7lQdz07HW66Fiy5imuXCMCcljbmI7ry7y1vZiX3yylOR8FYJP?=
 =?us-ascii?Q?vbkXJp+UYBFH+xB5eemiBuEaDgk5sRL8M5Fym9rwjGPTtxWnHfXrVTxODVGY?=
 =?us-ascii?Q?tUWKiQgFWGXb+KD+srFcqzkv2+7uXHutEX3tA+LEYDxx/GKCFnDs7UYhD8Jz?=
 =?us-ascii?Q?HsthZAaqmYOJgwJlz6R38JowfkNJUZYBblRXEDv64Lfh0YjrzokrGFq4iYRx?=
 =?us-ascii?Q?z+LuNNrpv7S7b7J354eh41f7AtCdlLDrgmcP4UrWg9WM7C9YijH/tlXfD/Ah?=
 =?us-ascii?Q?N0pM85BDERpBESFwC7V3rJF6bFR0PsWxxUvJb5kPO7qWlhW0rsBrMkIW53C2?=
 =?us-ascii?Q?GCzpRiBkWrp0mh5dVehqaDxrQ2q/SyLPlzxl2bwmkr6ptmreXX0tn27WRZoK?=
 =?us-ascii?Q?mWordM5XgXEIJOuQZD25Sv0DMnyVdNYgN0JanWAgvpnuwRz3weVhqMitc7jM?=
 =?us-ascii?Q?BT0PZWMM39ZOTLr0QAR3/P5UMy674gHV+PD7ze9JnZi7a+9GYuTdV/FdufWm?=
 =?us-ascii?Q?lnQBc3MJVojoMkK/75NBg9bvTAHapZczui65frWyJZDPoDUeLoXgKMUHrJKW?=
 =?us-ascii?Q?PcMHDreZFf6NhtyH0/8sFzok6p5vvn3OjN//2jia/RfAjYlaN0R+xXU1Lzur?=
 =?us-ascii?Q?mSOUpPr4XuvO1KdqrUIQBjC/XxXs75CHvRjXcL8SKDXSo/Ctt/LX68SkOuBr?=
 =?us-ascii?Q?WyQsJq5q5U0H4lxdL/wd1q15?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f16d1d9b-6de2-467c-6772-08d97e34d2dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 01:52:38.9920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tXOSua45trbmOZ6kiIx1J4W1R7Ecq+cSad2gN/pkdu/DB3lKPkIZBGM0lLwbwTNK6MzS5BJHI2bxIXYIytE60cSwyrRxtnXhGWp66PrID/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4954
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, Sep 22, 2021 at 13:18:37 +0000, Vladimir Oltean wrote:
> > Policer was previously automatically assigned from the highest index
> > to the lowest index from policer pool. But police action of tc flower
> > now uses index to set an police entry. This patch uses the police
> > index to set vcap policers, so that one policer can be shared by multip=
le
> rules.
> >
> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > ---
> > +#define VSC9959_VCAP_POLICER_BASE	63
> > +#define VSC9959_VCAP_POLICER_MAX	383
> >
>=20
> > +#define VSC7514_VCAP_POLICER_BASE			128
> > +#define VSC7514_VCAP_POLICER_MAX			191
>=20
> I think this deserves an explanation.
>=20
> The VSC7514 driver uses the max number of policers as 383 (0x17f) ever si=
nce
> commit b596229448dd ("net: mscc: ocelot: Add support for tcam"), aka the
> very beginning.
>=20
> Yet, the documentation at "3.10.1 Policer Allocation"
> https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf
> says very clearly that there are only 192 policers indeed.
>=20
> What's going on?

In commit commit b596229448dd ("net: mscc: ocelot: Add support for tcam"), =
Horatiu Vultur define the max number of policers as 383:
+#define OCELOT_POLICER_DISCARD 0x17f
VCAP IS2 use this policer to set drop action. I did not change this and set=
 the VCAP policers with 128-191 according to the VSC7514 document.

I don't know why 383 was used as the maximum value of policer in the origin=
al code. Can Microchip people check the code or the documentation for error=
s?

>=20
> Also, FWIW, Seville has this policer allocation:
>=20
>       0 ----+----------------------+
>             |  Port Policers (11)  |
>      11 ----+----------------------+
>             |  VCAP Policers (21)  |
>      32 ----+----------------------+
>             |   QoS Policers (88)  |
>     120 ----+----------------------+
>             |  VCAP Policers (43)  |
>     162 ----+----------------------+

I didn't find Seville's document, if this allocation is right, I will add i=
t in Seville driver.

Thanks,
Xiaoliang
