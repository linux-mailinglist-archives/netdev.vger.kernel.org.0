Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA548415CEC
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbhIWLjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:39:43 -0400
Received: from mail-eopbgr1410102.outbound.protection.outlook.com ([40.107.141.102]:30800
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238930AbhIWLji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5f6Hj//tjSbSCYMZeyYOsw4iO/vu3Kqy8Jgk0jc5ghLBjSOiu5dSJjm6KXM+/lQpXrWpAhzFhoivS+F45WAPDQKWFtK04jcYgCiOaJ0cl0YK5nkMALcBh7iqqVnWxvNOfHJeSRgezuD+J4G4b8Rl5ju7j/vQaYpR5KFjtjohrjushDbJKAqQX3m0WHj0QesvRoCx6RGjMGgcA4BYPgURbhqBVad2SB+6xzyU4OLcE2Eai0Tccx5aGKfA9sYTMrb/whu580xhKVGE+1oL72r4oRqNRyohIUhs+ft+3p3+60pKqWuGx4xOfpBY2PoUhiehapGVSOnfT883FXJe6u9+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BpsENi+PJuHdXt1R74rt9LB0wBIi/CqT1Bu6skVXG/s=;
 b=h9VT7P4U0MKlAOOhPitiTuMTyOJRG2+uBHLPgBvBeADOwAcfidCnS1tkV2NM9t4NA++2X3k0plw4WWpXL70J/QhIWBOD3rV7Hq6LuptTKmMzXGrxA8kQkVydHsEi7L3uMkoUJ56Y9u/U3BKx4eR3qt7VzibM3yyaoxgQwdbzTehFimx7cbcoB8GHeWaxGfPQ9LnfFj2LUURjDg4iKXbvTytjgfW3zt8TSmtCaFRfmM0gU2CcWUxTMd5FBCZUbvrPt1oLdL36zUyEKGg+jDZ7roCEaRQ0p15p2xYoZnVPOPotgd4yUPCp5AGd5++Yz/tnjQ5GP61W1k732JpAZRJ19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpsENi+PJuHdXt1R74rt9LB0wBIi/CqT1Bu6skVXG/s=;
 b=XRCsqXYZ/rDXiodidx47cjn21Y6cXUMk8w3BztKQJnbeByiHKIZuycikEiQaRd6fdkIieZTgT4RDhVFyhh6C6AeYFR1KDvPSV3In+o5e+nVhXD7tSFK95KbGFZYOx4/bJuGhFiGVbhUkLPxHjp1j5nMPMfEzWzMPe0lxWJ7AlKo=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB3477.jpnprd01.prod.outlook.com (2603:1096:604:44::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 11:38:04 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 11:38:03 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>
CC:     Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 9/9] arm64: dts: renesas: Add compatible properties to
 RTL8211E Ethernet PHYs
Thread-Topic: [PATCH 9/9] arm64: dts: renesas: Add compatible properties to
 RTL8211E Ethernet PHYs
Thread-Index: AQHXpVeszL3M4cEXQkaXukPQlEhceauxk9Cw
Date:   Thu, 23 Sep 2021 11:38:03 +0000
Message-ID: <OS0PR01MB5922B6BA78CA34AB60543A4E86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <cover.1631174218.git.geert+renesas@glider.be>
 <3b366e3dddd4d3cd7e89b92d3a8f78f6dc18e244.1631174218.git.geert+renesas@glider.be>
In-Reply-To: <3b366e3dddd4d3cd7e89b92d3a8f78f6dc18e244.1631174218.git.geert+renesas@glider.be>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: glider.be; dkim=none (message not signed)
 header.d=none;glider.be; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 195e0b0a-0122-40d3-1d15-08d97e869af1
x-ms-traffictypediagnostic: OSBPR01MB3477:
x-microsoft-antispam-prvs: <OSBPR01MB34770F1CE286C78E9C7C0F1586A39@OSBPR01MB3477.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gCXt/Qq6N1VIv0jPCOQuVBMDIAwL3s6WojEGQkqX0X6Qg9Qap0w6dkqG2OJkgu3kxasWP5KQfUnF7mmCuRcr9JjA7cwwpov0pR5XRuKMHydoWKy65Bx4LnSHXAYgv2QG9TTXFdsveJanrDWOzA4x4oi9ov56i6zHVtgdd664NERBlrHAjSKuHsJJfwN0TIw4rLddx4hV8QZZzRBO0IJ2nZigqbbd1mCi8ExlIPTwaMCU9tISPjYrLE7IoJTzhRYKJYgNUmEXLZT3k3jiH1kFFg0+Xy7LQE8rUQtUKmnUIdYvhJ0Fa4bcdclt2MywZttpP3/wGXVFX55jxC/qvTps2jsG6NVdWYPRqyJXfzeg0ru/qC1ZjFK2znOerOqPEcR3ALozuGVC0rWDWBCMycwbkvi1RB7HQ8KbtXBBjbZ+z4wT2sYs//sfmRSAtxRb54jD6MHuZOD7vgm+chFpYNrCqpZMwh5phygiCGUNaYuElkvoNuwrhxbAfTxRaLJ19DsDzAYTZYlIFTet7ZWAVJlUxgm6bwjziyncRqPuSnBi52wGI7Tup2cPk4krflBel3KQoSZ/4eynyEHf6Ltk53oFdHeLFOHPTgT4YaCIHT5kWq+RKyJ53rdfGbgt+dQd+8XIKv8RN6Tg/mUM7V/WlVAoO895FRkFKxgBR2fhCAwbnAUpckSKCdOj8pKS5OU88q4aAgDsk6kuHYczH0MkLorfLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(55016002)(316002)(38070700005)(33656002)(66446008)(64756008)(66556008)(5660300002)(54906003)(186003)(7416002)(52536014)(122000001)(110136005)(38100700002)(4326008)(8936002)(9686003)(83380400001)(2906002)(508600001)(8676002)(71200400001)(7696005)(86362001)(66476007)(66946007)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y3JmxtsF6nKwL/+uKj3IacMICAqjmKx+cI5qPOXyRJa1tdxVnI6lHjGqEy4Q?=
 =?us-ascii?Q?cxSEi644Bjs1fRH6ZAO/BK7w6AfjmtBM0x4dWMhfYCQy7zqiDOOrFmXMWUvV?=
 =?us-ascii?Q?au0ROvbMI3vy2gG7WD6r+ZtE8u6Zy+Vi4rVCB54eNJ1UMEPjw97y8k+56Is6?=
 =?us-ascii?Q?Y5qOPW67i1H6/MpDcDh9HAKhXyERHCtxjuatFiXuzI+k7mZxNIvzvpcXq+ZH?=
 =?us-ascii?Q?n8z5jp2KoE5fufn+g2r2lNWsPnGFy+VSsAT40Kme+KmiO5wVgOcDslYsIYfQ?=
 =?us-ascii?Q?tkW9IpEMJx415akadVZxYVi1VcInsnQI8UJD7EadZVatfgCq21bu4T23KPkS?=
 =?us-ascii?Q?jSlArAQW8Zsx4UxMI22RWCvoqCUB72wPdQqJ25XNpM4fW1h4JQf1oJsXcbuT?=
 =?us-ascii?Q?D3xDBqJzSsmI+GBuRmBI+2NAXZFhl20UXsNNuOxWe1VThNgr0PB0dqFyn1y7?=
 =?us-ascii?Q?KvqL5pR3T2Boz8Ee8Ub40sHU5DuLUomfNnJFACytK7+dEVXSfHdE7tQs+kDN?=
 =?us-ascii?Q?wHFVRSMov0x9zBW5Cq5b2MbjdQl6JQuMjADqLmG2JTB44QqaBi7P+WB9n86J?=
 =?us-ascii?Q?9uOkj1WEOeJDi8I+QbNxt809QwilMUmPhqN1UmEVgJlGgi+wBlxpk8uApApK?=
 =?us-ascii?Q?sGbL9axiHkSxfrUH6ZEXtUeLUmTgJsb1+qOCYnAEJhHSHUUuLHDjt85E7pNA?=
 =?us-ascii?Q?J0m6qD/IPJ5/sQRcBje81tw8+xlTnRqZz1LQv4Sv+LM7riHlbMOSfOITwiOh?=
 =?us-ascii?Q?Db7HFNlTR4x8C94ux2yfiC5WAMM/11Hi+ZSlpd5bFLTt7s5CUxmp+siX2fO1?=
 =?us-ascii?Q?5V7a29a7tR8axNliMwupMgdUYlMbQl/YGivPtpTy+DHYENDpRjhLQPZX09Fj?=
 =?us-ascii?Q?UTJczOgEayR08sx6gJ0GiCDHWoZrGni1N9LP9KrkP0BHSDNjXs94jCJDZFfm?=
 =?us-ascii?Q?dFEJr9N8juz6NqhKogVBbg8bkI+g53gnCefXcoADmDDHPa/IyPAmzcY5kNdf?=
 =?us-ascii?Q?KTNKFYeUDcFo2h7akW/HjUHKzdDXpQMPnb47tg0UE5BJDMXyBbwORrfIAEcv?=
 =?us-ascii?Q?J4n+zGczDgTiKCnpvhGg/K+JkVQ0hx2fIWvNp2ux7wddMaq6vac188Wcd2JB?=
 =?us-ascii?Q?zqrRdFtuj2rOxPsFYvWZ8+Apj8faZUnwfZQ7L5rs736XxEDIYgFaOzkJipyh?=
 =?us-ascii?Q?nc90BJK2InIy6Ap1NAam3x8pkgJi92a+ifvbQucxaTzGZLwV494BeucVV1A0?=
 =?us-ascii?Q?4nI3afIZMeTDGDu2AwNqdAos+E/P5IhNpGb62lxHoqPZk1SsVJcC9t2eJ2Xs?=
 =?us-ascii?Q?txEvbTzSAslh56QAmp02T5KB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195e0b0a-0122-40d3-1d15-08d97e869af1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 11:38:03.6749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jaJhybUg+vY8OYC0Iidt1CwqWzLe+6s1V5QZvUmjxoSx7D2gwl6L1zrHuczgdPL7jYi1HQLnzZTY9BIXkLL7mYoNtaykzjnX51RXXD9c12E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for the patch. Tested the patch on Hihope RZ/G2M board.

Tested-by: Biju Das <biju.das.jz@bp.renesas.com>

Regards,
Biju

> -----Original Message-----
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Sent: 09 September 2021 09:50
> To: Magnus Damm <magnus.damm@gmail.com>
> Cc: Biju Das <biju.das.jz@bp.renesas.com>; Adam Ford <aford173@gmail.com>=
;
> Florian Fainelli <f.fainelli@gmail.com>; Andrew Lunn <andrew@lunn.ch>;
> Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; Grygorii Strashko <grygorii.strashko@ti.com>;
> linux-renesas-soc@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> netdev@vger.kernel.org; devicetree@vger.kernel.org; Geert Uytterhoeven
> <geert+renesas@glider.be>
> Subject: [PATCH 9/9] arm64: dts: renesas: Add compatible properties to
> RTL8211E Ethernet PHYs
>=20
> Add compatible values to Ethernet PHY subnodes representing Realtek
> RTL8211E PHYs on RZ/G2 boards.  This allows software to identify the PHY
> model at any time, regardless of the state of the PHY reset line.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  arch/arm64/boot/dts/renesas/cat875.dtsi         | 2 ++
>  arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi | 2 ++
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/renesas/cat875.dtsi
> b/arch/arm64/boot/dts/renesas/cat875.dtsi
> index 801ea54b027c43d9..a69d24e9c61db052 100644
> --- a/arch/arm64/boot/dts/renesas/cat875.dtsi
> +++ b/arch/arm64/boot/dts/renesas/cat875.dtsi
> @@ -21,6 +21,8 @@ &avb {
>  	status =3D "okay";
>=20
>  	phy0: ethernet-phy@0 {
> +		compatible =3D "ethernet-phy-id001c.c915",
> +			     "ethernet-phy-ieee802.3-c22";
>  		reg =3D <0>;
>  		interrupt-parent =3D <&gpio2>;
>  		interrupts =3D <21 IRQ_TYPE_LEVEL_LOW>; diff --git
> a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
> b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
> index dde3a07bc417c690..ad898c6db4e62df6 100644
> --- a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
> +++ b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
> @@ -24,6 +24,8 @@ &avb {
>  	status =3D "okay";
>=20
>  	phy0: ethernet-phy@0 {
> +		compatible =3D "ethernet-phy-id001c.c915",
> +			     "ethernet-phy-ieee802.3-c22";
>  		reg =3D <0>;
>  		interrupt-parent =3D <&gpio2>;
>  		interrupts =3D <11 IRQ_TYPE_LEVEL_LOW>;
> --
> 2.25.1

