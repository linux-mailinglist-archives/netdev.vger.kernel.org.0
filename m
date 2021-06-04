Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186A239C2DB
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhFDVtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:49:17 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:45242
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229668AbhFDVtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:49:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=een3iXTjKoWonTcvPiL105SgtstxiGV6QUKw52mPajSLtmXUErLlCbXas3GswQCij4W2HFZ+q/8ZSbFd4wrKh/1qTqzG4y+Axo81XuY6guVeXGDwI/GJITLZ6yvfvp13kom5veHP8wT4XBLy4vDKpYceBrpxqJcKtu9ByEPhi3tH3mFM65/4H3epZoLGegtE30rs5wg4lrsUgGqINYT22vRaZ7+q66X+pxpJPE7bTDGkllrihEROA1PlQPVInHpIhM+99mdvtAtJaD+1dU0HGOHCkgqg0uJKoJCMf5s4RXooCLjsomY2LyE/W9eOgRPssmVx6kevTJJU+enZ+G1oJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZWfJ/elDueb7a5fE/9lf+4FweHdBV253R214+uSS64=;
 b=iQBuKty0u9oqI255yhY3Ik7Qw8pvHplW6rlvSrIFWJnOq2fwc2L4zAOjZXkOxR5TDEFvGexfyrauGwmWiYDYvYxtk73nQ2Fe31yrHHbk6wXcl90sModTT8Ab2eybm7dR2KGmdhj/XW6UPzenZgY81aG7e+wJpbJTyZz+ilO43W7EUrjqL4Us0Zo/8P5vTf+MHKZgZkwtIx0PgSHVJdUyQ5sXZpEfcvYv8FXhcmf4P0aPFrdzrYpD21HJ8ehSMMcD3810R9HZY5n/c+uIA8Os2TW/9G7rXVxmzCMBSFLNvlK8VZFlrXaQPoQ7757byLP9WXwNyqxqKdWWpqw17fmaHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZWfJ/elDueb7a5fE/9lf+4FweHdBV253R214+uSS64=;
 b=Mn+51QyvPoBInCr/TDOzW2N2xQOtkjB80m9XiftodYWZCRy2MSihcxoWomBAilXfiC2qOPZCQrljRZGa/mJ6qEn1XbawNeiJgekBnko+Y3VrtXpx67n+QKKRf+SjS84fpmA9OSpW4/125QwDiu1mjpmBniKWaPyzvmIcT5q//PE=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM5PR0402MB2900.eurprd04.prod.outlook.com (2603:10a6:203:97::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 4 Jun
 2021 21:47:27 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a%4]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 21:47:27 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King <linux@armlinux.org.uk>,
        =?iso-8859-1?Q?Pali_Roh=E1r?= <pali@kernel.org>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: RE: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Thread-Topic: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Thread-Index: AQHXWIWiLLzXceBiLkWovt9CFi28O6sCZLOAgABNOICAAL4lwIAAzjqAgAABF4CAAA6WAIAAFLWQ
Date:   Fri, 4 Jun 2021 21:47:26 +0000
Message-ID: <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20210603143453.if7hgifupx5k433b@pali> <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
In-Reply-To: <YLqLzOltcb6jan+B@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [81.196.28.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3b58305-498c-40df-b7a8-08d927a25869
x-ms-traffictypediagnostic: AM5PR0402MB2900:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR0402MB2900D1538A83CD1F7594B3D9EC3B9@AM5PR0402MB2900.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2V3w5tVt8Yc2W2IG/C2cVnSIZrbFKOcf79Ksau3Wz+w42Ah0KTBw8/FWPKIpKgEXVBFwdm999w9P1exKHMqwsHFYNbHfF5efNTytQglXm5hi231QW6g0QTDN5IR7Qs2B/OktXZtnxHro5W96fn7IJdUdyfP6eoGW4jAXCajkNVGKW0LIen6qjIKRqJocXxgMsb2MBdb0D2cDc/RInPdpz6B3yY9wZN9PQGCidHkc8e9Um4IqEHOtn3NE6WLAWso6rpbetSY1Az2DpQh91M7KTNucqycrnfTtXkHK8DdYqp73zycVW5lJUgghDAGgxl99r1n4I63G2PUTCJYgRVyRRC4cB97PBCezYbTkTVtu1syC9qyTx8Pl41Uawc5jVY9LGr2iquVJ+2+6Tsf4GHnxKjR2ktiyWSXBkm+fb/UkxxSz/5RFJ7l1HhXR3HUNX2+sAGCiNpSbqZeEA6sLs+Ugd6GdDFF/1KflWNPGOtC+3PM/7cjx/BgV696Tx0Oty7UsXsoQZs2d2zxUUW2KdZ3EQA8zAIozcjDu2fWMTKTsEuy4fSlZ0BVhX4yr2UKf7pO1XF2wMMBbGEm1ANyAunARjg2B+I1U5aW5bMuM1OcEJbA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39850400004)(136003)(376002)(366004)(316002)(54906003)(44832011)(55016002)(76116006)(2906002)(71200400001)(7416002)(8936002)(9686003)(33656002)(186003)(6916009)(86362001)(4326008)(38100700002)(8676002)(66556008)(5660300002)(26005)(53546011)(6506007)(64756008)(66476007)(478600001)(66446008)(66574015)(122000001)(52536014)(7696005)(83380400001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?SY7SfqVQe5AxmGp1wOsfNLzo+T86X8tGd4aLNJAdQ9l2MMWgMw7C6vUczq?=
 =?iso-8859-1?Q?1otmclIK/Gz9BAZSw4ddHVVJSZns8EwmNW+wjbluv4WuvhfreD1x5+y7q7?=
 =?iso-8859-1?Q?OCB+grIfrTHJoYSh6w9H9I3RdkHNVM8yQbRTMmPvH4L4hgeuPsUpIbKaUf?=
 =?iso-8859-1?Q?qFJJK30ZA5AZHpREDdRUgRVVz0y+CffSJh+n72aag8Uo9qwY+YcH5SXSI0?=
 =?iso-8859-1?Q?k1xV8MPy3eZb0hIdBeOzBGCQ07EDssTGVrkWZaNe2a6HOMi/2GA7SSqYSv?=
 =?iso-8859-1?Q?QWIQCPDHB3qLp3xQ4sKssu9IYn0xRSb7JczlGJiszArb1RoIGRvbZEyi4a?=
 =?iso-8859-1?Q?wYJV1MnG/xPPduCjGLyFuXshTWbk+CvVd8811Qo6/nZGx1j2F1LDD4Fziw?=
 =?iso-8859-1?Q?NLtQz636EjP3rUCbgqKtXsc7aFb+udOBhl/lNLXJIH3DqTPFKjjMShpRWe?=
 =?iso-8859-1?Q?gUvEsqQWgz/NxV/yrGe2kPNlIyjIvKA4RlvDyZb0ArS+i7NOy7MBSMWx9j?=
 =?iso-8859-1?Q?SADLPmfKGABU/avAGvuAG6eb5OELWd2xqVT+9WO39yx5PCID8ij218Srl1?=
 =?iso-8859-1?Q?c74v32PIqbqgMKCh6cnNNCDmknBSViRpP/51TTEBoMzM/LnGQGUrvC0oBt?=
 =?iso-8859-1?Q?6nSzFqtMuwc+JsmMk/A2P/ZCUC59OKR/0AJEGvL2HNi5Ag7pcor1MPV+eC?=
 =?iso-8859-1?Q?EoNMP6qvGMBlQtw1B6kNRVrN8XY3FKhK0wuwc/0jgQ8rtVB8/HMjo3VRj1?=
 =?iso-8859-1?Q?V4jyQUUqj3O6/xcxzClerowzTM3Viyw9ybLhM8RJLm3zf/nwgLaB7wBW/f?=
 =?iso-8859-1?Q?36krnuwjPKROEqz+QJw1lLhjFcqCX4yVmOKvYTO9AwHhAA7s1yV59MlUR1?=
 =?iso-8859-1?Q?3C5vjrgrGuS6O5qwS6LlBYZ5d/HCLxZKtsSj9yAy+LHQ+UfKg2zobHAGj8?=
 =?iso-8859-1?Q?wMMlrFX5eAvi4xqWV62mw+5KhL06y+aZLkYgNDiQB8WufORMNYVNtL/mrA?=
 =?iso-8859-1?Q?1JpYrlmkWfSfBhoOq6t5Mw+kjL7oQcow53+MzLagPTCQvYiaDSJqZJYiVO?=
 =?iso-8859-1?Q?RCuFp8FMPdVgsPaipzzIKJN6iChD16x8ilT2HNoAEEx5aIbq8dl2BS2wNo?=
 =?iso-8859-1?Q?VFHP8XygtE+SrLzuCt+TW9gvOVJ+8CBl2a6YR8qwzajvQMwRTToKfwv6bn?=
 =?iso-8859-1?Q?aQxnDv3/6qU0W8Q3XnsedR26sEEtuq1Oe+E/NIzx1S4o8OhHtM0I9655Ja?=
 =?iso-8859-1?Q?GpqpXt2xwtlsqJCguIxPlMQ8oyLz7rsOgY60vytuKPLgXK7vqbk9pShgE+?=
 =?iso-8859-1?Q?pMazjHhpa0wbFJKovEQGIA8zmkmo2s/h66tatSUPzbDfCuf8vXY00/tzb0?=
 =?iso-8859-1?Q?tETsgD5zun?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b58305-498c-40df-b7a8-08d927a25869
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 21:47:27.0144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: osZRT1/SpJX1OZqJdsPR4aqKO0t5Xq2HBlsPglwTD2jn6VJ7UHQcskxWTTMbighCstdN0eWjJqrGoxTYAs5iMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2900
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: 04 June 2021 23:24
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: Russell King <linux@armlinux.org.uk>; Pali Roh=E1r <pali@kernel.org>;
> Igal Liberman <Igal.Liberman@freescale.com>; Shruti Kanetkar
> <Shruti@freescale.com>; Emil Medve <Emilian.Medve@freescale.com>; Scott
> Wood <oss@buserror.net>; Rob Herring <robh+dt@kernel.org>; Michael
> Ellerman <mpe@ellerman.id.au>; Benjamin Herrenschmidt
> <benh@kernel.crashing.org>; netdev@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; Camelia
> Alexandra Groza (OSS) <camelia.groza@oss.nxp.com>
> Subject: Re: Unsupported phy-connection-type sgmii-2500 in
> arch/powerpc/boot/dts/fsl/t1023rdb.dts
>=20
> > The "sgmii-2500" compatible in that device tree describes an SGMII HW
> > block, overclocked at 2.5G. Without that overclocking, it's a plain
> > Cisco (like) SGMII HW block. That's the reason you need to disable it's
> > AN setting when overclocked. With the proper Reset Configuration Word,
> > you could remove the overclocking and transform that into a plain
> "sgmii".
> > Thus, the dts compatible describes the HW, as it is.
>=20
> It sounds like the hardware is capable of swapping between SGMII and
> 2500BaseX.
>=20
> What we have in DT in this case is not describing the hardware, but
> how we configure the hardware. It is one of the few places we abuse DT
> for configuration.
>=20
>     Andrew

The actual selection of this mode of operation is performed by the so calle=
d
Reset Configuration Word from the boot media, that aligned with the HW and
board design. The need to name it something other than plain "sgmii" comes
from the HW special need for AN to be disabled to operate.

Actually, the weird/non-standard hardware is described by the device tree
with a value that puts it in a class of its own. Instead of the overclocked
SGMII denomination "sgmii-2500" it could have been named just as well
"overclocked-nonstandard-2.5G-ethernet-no-autoneg-SGMII-hw-ip".

One could try to change device trees to slip configuration details, but the
backwards compatibility aspect renders this futile. Is there any option to
say "sgmii" then "autoneg disabled"?

Madalin
