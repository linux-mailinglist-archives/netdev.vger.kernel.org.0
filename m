Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FA8414A5D
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhIVNUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:20:12 -0400
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:21856
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229923AbhIVNUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:20:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQs9s1xf2W8PY8ZoNAtM9ChrZUe5thJUkEoFVDVwsQguMe9S/DUm6IY/Y3WBCJV/VXyMNOOgnOZ5GnkgoQYcIQKlynwHh6aqIAlFlaJbbU9Ovgd4SGIgO2JnHPUL1uFtsxtTOZ2tD2rOCLibLKjd+pqJ2BQu1ib/JnpNdio0UX3vdZ9M/JHkc5aidhrOphb973/XiV1mKZoZ1KIiIoqoIjVD2AShztT6+2M2kJSKqwTPhOi1h13/IV+CQkb9TwZC3rL+7vVABVkHHGe4JSUG3Fv8k2Opyjp13m8IICcgHmL8zAnOCDy7ddYh6EfGD7/JU1L0EUfGwtEJRpNjGchKvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=69px1xZBRWD6z5GVqO6YS66sj5vx2K+62+rbLam8Tkw=;
 b=Ra43pm/SG73/+WRjarKm5kAYv8IFoUtUfYgWDSdYYkbqe7djTVytbNlVmLQFz7D48yquSJTlqStIuWGEEla3XTH0xLjz0M5zcRAIjF6LGbu/UH1kgHWmz8Jgg6X8TVTtVO7r/kathvahHjmX7HD63n+Z2bnrunU2xkMEUefagD4KBVVyk2sr+bFkaXV/MIXgCW+snQ7o4vd/Xxk3t5iVPzII189ggxEV/RHF4VXmZ/a/NpMKV21sWXmpjN6F4xmZddI9JKYVsVO26c7lC4Loh/kcr6ho5rLPx29WfoTrj6r3di9DWTLfoWEkvSkRaeXSKsdbvMbvGRzlYhJ2cFPbBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69px1xZBRWD6z5GVqO6YS66sj5vx2K+62+rbLam8Tkw=;
 b=dCpL0q4gZ9+GVnitfliCh8dl2AGgKDVrsNUuHc1nASBESlTuk04su3Y4bTzvLEVYg7tE36VLA3SyxRBbqZS1y6Y4i4DWFgARUJU8h4Ng9aR+mSuheAyjkufxbS5WKbeaX2qgJ+OD55H+sdE+Orr1HMzXiUaam/f04n56ZEp4NnI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Wed, 22 Sep
 2021 13:18:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 13:18:38 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Thread-Topic: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Thread-Index: AQHXr56I1X8k6Vdwpky9OCEV9EsRoauwCXaA
Date:   Wed, 22 Sep 2021 13:18:37 +0000
Message-ID: <20210922131837.ocuk34z3njf5k3yp@skbuf>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-8-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210922105202.12134-8-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e7dccea-3026-49a8-caff-08d97dcb7d2c
x-ms-traffictypediagnostic: VI1PR0402MB3615:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB36156B97BCA42A4510783B6EE0A29@VI1PR0402MB3615.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oKthsG5iExZonASlAHhjAc4zs74ZEgG32FXYFMoiS4nqkWzmj6rMGIyRiA2YVXrmr1OYWaH96VT3bPHp4bY6+9Qc1Xg+InzlplV9oa4EY4SPrvIEFOYmlkSJ9ULHS5tD/98Vgh0uxLZw5By9/Z/xAEnpRFY+zKY9NdZHtFO7lCyhil+nYgkCLM/0JCJoPlizHnztgvBRsLa2DL4nvDSYbJXzSnGUucM0nve0p8cH7agRL0N9EJxV3GnrgPtiE3+fko4LyvyRXsauO817c26DJLNbcS/OZbHxxdea9VKNOrhCH+urTIo/dqTou5zy3/5W5RL+xZjOW3CWn8/oSPM6xSVbUKjrdeVEY8KzLvo7ro8CV/vxprOALRqPvURO72IIgTTjGlEqPub7T6rNJyqPcaEo4IgHnRQim2u7gxzkgVbx28h/wKTuHgfqCcfwGEcl70Z64r1feDIZXlU0h47dChEb7QOqwLZzW2LRxrO4dg6v1GSO9swbnqeAoZcDRwl9LEyqnhKYTSwutTFKemUWlTc5rbiumtyPpiqqPNiDfdYVtn1oIVpuXtN/vk5uolRmFotEqywFlwvCnz7ZmGhOXkov2mcrrwQVI6uKQp2XhFKZr96kET72aGx7ce1QXAuix9oj3y99NxTfc96N+Lqz1t+FaosjjZx9pakEk+UAPgyS1xP+0CO20uDh80cuaz9yQMR9FlRt4j3BoTvj2IxTQlmS/7yjRWTn36BCt4GpPxjD5yM3m9cRlL5lzMQH6k1y+uo39vDHMWsGu/QX26Bc4xZ6/luHxLGqvGkZqU//MnM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6486002)(44832011)(1076003)(66476007)(26005)(6506007)(66446008)(64756008)(4326008)(6636002)(8676002)(66556008)(316002)(86362001)(54906003)(8936002)(38070700005)(38100700002)(122000001)(66946007)(508600001)(71200400001)(186003)(91956017)(9686003)(6512007)(33716001)(7416002)(76116006)(966005)(5660300002)(2906002)(6862004)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UNbGNcKG9ovCnAvR67KsvcBWvmvGrpQroxh8shKf6IXhjgk2SYcz2SjL109l?=
 =?us-ascii?Q?YdiVE92VXiyRu0EoYHOX0cMPm/2GSQnOFmRbQaK60j+MsCZRB9RYKBIkKS2r?=
 =?us-ascii?Q?TDRJfWo6biDjiSfYkC7+uqxz6kWh1SuZGk5SpLxw0MtPWhIPwP+gbiX9Q5vb?=
 =?us-ascii?Q?wN3Ol67ncfFHOpRiYIJ9/pQGrkzmJLJziuPBTmkytQ1jDLs4PBpRmnBxGrko?=
 =?us-ascii?Q?TXlnabPtMF8W+ujMbolMaYP7yfHaqCIEsVC3abdZM4K3zj3dpSULMqdJWFNA?=
 =?us-ascii?Q?mOI4eDh8u3v/KZq7MMTmtbusfWkxgC43DKyBGmYNGmxy7cUfDYe+/ywRLA+Q?=
 =?us-ascii?Q?AQ5dSvzsP1ZVTUqy7lTKpzq34y5PlP6clN55vZLfHZUwGqvxzwfTAwnQSlw/?=
 =?us-ascii?Q?/Hrk72uBUykZtNJgLOjoBsnNxV0xswIrPmT089xLLe7aE/4sLGGGpjdDCHZ5?=
 =?us-ascii?Q?XfJe8lOBvzIIu28XfYcCHcU/4bG70yMI2t6o9mAw+2XkZJiv33JUn8sL/aYp?=
 =?us-ascii?Q?9buQWNrMtpa75PwMbTu8pjEf0Hy7sF7uforCuPsV2IUNEzQIyK4DXwbp9cAg?=
 =?us-ascii?Q?zl7M4ax0Fl29L6JWEwr8w04iFFULziXRJ1lvRCwG+bubJXnaBMnqfjjCWgsw?=
 =?us-ascii?Q?JZv968ZO2gO99HsFOxLnaZUebk7xeTSKeUkjtG6qdU0Hlv+wXm8c1hhs513c?=
 =?us-ascii?Q?6x2X/w6wzyA1MoyaiOqhxEDfUdzex0uZ8BKu7/i24syRWNTTdmP+WlOwCBnx?=
 =?us-ascii?Q?dcl/BFc+scVAPeqKXkobH3mjcU+sTXfrV2lZh+cZL4sqLUGsbbtYCns1snuj?=
 =?us-ascii?Q?q9DM5obpZObShiGvSVbWJeePOlGO7qpLOMG4nRqgCBm+FtfMCCO9QD9JZ0By?=
 =?us-ascii?Q?zUwVKDYUjAJADmwp0035kNHop5FVpjDQHRpIIVAecroYJMTA2o7qkqQicaVs?=
 =?us-ascii?Q?oBu01+yhlQV1d8hH29yTYRm7rw4kS84xUWm6It4KX/us7fSPTjYCZfCdjfcS?=
 =?us-ascii?Q?Ltnm36kX1ZzqTN7nCzqrP+EO10IxbBG9SjXheWMxFAYthlyHTs7nw406CAf1?=
 =?us-ascii?Q?oKZSaKJ1Xih70n/jS7jwLi8+jCf4TSzL2xqLOQCq5XjPH9ZIpI4LgPudzU7M?=
 =?us-ascii?Q?lqCm+se4nRo/fdx38ovTlkS6t+ZOcQIGE+sGtFGBUiT5EkQsOiSRAjWijCve?=
 =?us-ascii?Q?Lb9tkwseaXI4l0EYea6nPYP60tE833WDdE4g1oR6rVscNcSoDO2xKP4wiRCN?=
 =?us-ascii?Q?S5CBjBbIjn/ng/BtBu6ZslaHypBTOGhlr02aBoHx8w1oT5dFZVYEBe7DRtM7?=
 =?us-ascii?Q?a3A+8drCdmsI6/OathcIZhAr?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BE911CA3556C5D4D86F04F7752A7738C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7dccea-3026-49a8-caff-08d97dcb7d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 13:18:37.9767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjjQP7Q0d/tMwzDdkUKbv4kOwwIP6A6eXdjBzyhkkaAPu9rF4MzZlRnG8TSDV4wHUVOju5NzILY2nFPw187Q/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 06:52:01PM +0800, Xiaoliang Yang wrote:
> Policer was previously automatically assigned from the highest index to
> the lowest index from policer pool. But police action of tc flower now
> uses index to set an police entry. This patch uses the police index to
> set vcap policers, so that one policer can be shared by multiple rules.
>=20
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
> +#define VSC9959_VCAP_POLICER_BASE	63
> +#define VSC9959_VCAP_POLICER_MAX	383
> =20

> +#define VSC7514_VCAP_POLICER_BASE			128
> +#define VSC7514_VCAP_POLICER_MAX			191

I think this deserves an explanation.

The VSC7514 driver uses the max number of policers as 383 (0x17f) ever
since commit b596229448dd ("net: mscc: ocelot: Add support for tcam"),
aka the very beginning.

Yet, the documentation at "3.10.1 Policer Allocation"
https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf
says very clearly that there are only 192 policers indeed.

What's going on?

Also, FWIW, Seville has this policer allocation:

      0 ----+----------------------+
            |  Port Policers (11)  |
     11 ----+----------------------+
            |  VCAP Policers (21)  |
     32 ----+----------------------+
            |   QoS Policers (88)  |
    120 ----+----------------------+
            |  VCAP Policers (43)  |
    162 ----+----------------------+=
