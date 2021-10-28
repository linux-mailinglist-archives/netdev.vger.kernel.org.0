Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE5543E30F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhJ1OIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:08:42 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:24704
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230240AbhJ1OIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:08:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ku7c8is2DNpKPIXxUy86dsVWPXOME+d9naOakZYlEn3ampMBLLXjADC4trs7ldOkfXtU4ThQh5r8DWLkAbCaPK0/+CHNHt96p54VRMleERFgBT7unucXNb3PbqAGjVUnmavlS1Wx1Wu+eVDRH4eCNSTPDn99d/G5FWcGRbJMme4tq3QbbYDTCpuUnO+TSShV5Lvpy9+cHYaEUXiJ3obmUvrJuggAzr5Ccg6gch5k7h/W0cQxIZ718Q9kphx7UyYGbsG6gLVdGbxY2oq4mpliEJxCqf54KeVB5JxEc5HEUZSFUE450HwQ10Rm77rUVE52/2bkS6Vl9/TE3wrdF8jqVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYrKveBkRuRi1dLQZyCK/IGx6HfmlMT11IdsqEy4T10=;
 b=Es0jDBiCrJ7bSJxr7+IaJ6lPEMcdprF30NvRpBFa051sGfwRcvyVgsPTykrYEn9lUBKhScPXHA2/HV9Tq26O5cu+70Y3bwuYWFZToZ4JuFfN7MjYQqYbcRYQsKD8hgUywAVjJDTWLCsRoTUjQhdXd5X0Ke5MiVjiYDf27hRWb0y89a9Gx0RM6pgqnO26QzGMhmiQL7C8MiK63gTdZaSSBkhSqLxxxpQ28Idiq6qIOdn56Z62tWzj46u+cakA58I8jcEVk+1ni1ZRPaNbUo/ULFzGjz54IAvqc/NEV72sEtHkjLwXDliZnwg8qW34aGtDMOm/sVxVowkTtJU7+TLwTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYrKveBkRuRi1dLQZyCK/IGx6HfmlMT11IdsqEy4T10=;
 b=B02hLE6ANHHbPCpVWK6XBL0cuLWDvydBxkgDiXmcBDfGdzD/OGDxlmh3iLT86GieFlPMLa+a89IMCLc2nLMKMaoVx5P3Q126wn06V/JM61E/+X2xuMMIzhiGOq9W+ASD7UI8tHy4gEJywinxKME1KtebwJ2nZkj7WFKALzCbgA0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 14:06:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 14:06:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Topic: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Index: AQHXzALaBu1tOZHr/E6Z7NAaubhTaKvoceaA
Date:   Thu, 28 Oct 2021 14:06:12 +0000
Message-ID: <20211028140611.m7whuwrzqxp2t53f@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
 <20211028134932.658167-2-clement.leger@bootlin.com>
In-Reply-To: <20211028134932.658167-2-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cff53e08-474f-46c8-00c3-08d99a1c1945
x-ms-traffictypediagnostic: VI1PR0401MB2301:
x-microsoft-antispam-prvs: <VI1PR0401MB2301968B73719EA4B4731817E0869@VI1PR0401MB2301.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YLPAB+NbJIcIpDGwoWkqAQq9R1rl8uf7YsBzquzGC5RUJJayYWGaCVgYHU9dmumKt0cqWv6km+2a0LSizCqlSCwiZuXeedMgq9XFuXa9OVXbN9u9esYQRqkBB3lo9WYlBtEbv/2oL5XUDG4WFXTKVJCACkIbXVTH+p7d73z51LqZSFFfnkhHJcltEfy0ZBBbdbO2BH7b/Lg7h5CBgPqcEDHVU/8s7UOffjETwDCWqZojRWf8sbb7cVGtMaOv8V8MRqYG9HlcJ5N+EUTKsFyKvQzmX+5Ub9oVU5yq8hHXHLHaVcNpVtOKNkiVZ67bq+Ea4zPrNOMKQoJKa1WI9InOfUdccxdWdWERAeIETeZ2maXrQI5PDXehDEwqU6YBMhJNBq592NNPJtPKOzNtJqihZs2BLAL97vkU4VOUmsEKjHi59EK7ETYE7q8SNLsmWuLwQrmI2QW7WZIzsZN3/tTnaprMUZ2GzTzvJwdWIpNdpY5IcLcqo6Lf62wd5zyN73Nyjsnu+I6AocJdIdlMK9vWyaJ3lq0B21OBis+5qRMVG4jCu198CEXsSlX/RJ5EZfZq9lZu8UAkBKsuc0R55iI27KNt+Rj5vQ7UubARI4GFlikcRPuYSPdcYc0GaMnCkCcvNOCE8cC1FvIJrR+7HnDRvlMT4iYMSOSMCn+da35NFHJwZmWV5iTuVNZ159H5zGIRG1rdmHRs5TXl30M5YG9quA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6506007)(6486002)(66946007)(8936002)(66574015)(66446008)(71200400001)(54906003)(7416002)(6916009)(2906002)(26005)(38100700002)(6512007)(186003)(64756008)(83380400001)(44832011)(508600001)(316002)(38070700005)(9686003)(76116006)(8676002)(66476007)(66556008)(1076003)(5660300002)(91956017)(86362001)(122000001)(4326008)(4744005)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rqL3Sjfw/GALzOltiYsQgJvBjZandhtT4b/avvYg3bGKeSjQ2bA5gmeJCS?=
 =?iso-8859-1?Q?UNPp9nL1i/EJGYs3cmYks7ApDUAjfGFYtNADLxCEZcKVmqh8a5+03L33MG?=
 =?iso-8859-1?Q?TvkE9NV5o/0P1rskO1wWhQqdtdAac2DYsmCjGAGnlNRQgUtvfXXK4neWqF?=
 =?iso-8859-1?Q?jgXVWeIo0XF8QSYSduJcFkNdMvJuGzycZecTWIOQ5H+n3fDmNWWRUmSh/c?=
 =?iso-8859-1?Q?g5G0fvXFxBettEEOGEYeEoSZsYNw4E3P8Pp+fZ+fH9HJbmY5BkRHAwcMfd?=
 =?iso-8859-1?Q?vLzTPZgrgNb89JLTbDNVGwU9HdugCerff1qSPW8CazbPlOYjusXdm9Tnwd?=
 =?iso-8859-1?Q?0Jp/8+xYYGHp7HyJML4arVP1iBVwCvDq1WGIJaPP31fm2Yc77Z41/02I5l?=
 =?iso-8859-1?Q?MHrznuHl1nJqpk8I6jGoZXiOCpWDAQWRybzkUF+GD3x9kuRuIPOqpfjprX?=
 =?iso-8859-1?Q?KW3Md6hBTChktC1/X8bTBEoBqS8nSQcCFEAoxxev20b+XPEltB3DIn9V+W?=
 =?iso-8859-1?Q?QM3y2A0i+PK8BkmOjG/cUGTEZl/ecp9X4zKE5yqInwmn7+IpjmhraeVr5+?=
 =?iso-8859-1?Q?nDwQYx0cswThT30gWUDC3g6uUBG12D/DgQgKTPGpVV2/Ku91qvIpBpKxDs?=
 =?iso-8859-1?Q?TOqUwwWEZ0PMnUkkun16n70KnLMZ3TiWz2SlkvH0LebgkhmMyib1p01ccd?=
 =?iso-8859-1?Q?+NVTp72MYjZc8CAlCrI2fXk3S7ZUYx0msS6/9W8uqhkzt2R2QDN/Mwaf6B?=
 =?iso-8859-1?Q?jP0G+S2SsxcFSSB6l3RDp7z0yAuJ1RJZhiugMY3jmhXTkTDNKRDhyLhZWt?=
 =?iso-8859-1?Q?utXq6TUHDW9w/IbwT3Dyc4f3tATcWlC5gETBJv8aOSdUH7jynVesk5SK6P?=
 =?iso-8859-1?Q?RY73hawhkj+cinMXjN2scQEtbSX2aKSr8S3cCJWP0ZJ6g/o0ew0zGf9VCQ?=
 =?iso-8859-1?Q?IupGsZFTsfhlR7OjNcxj5jA2L0dsJ1vTOA+JIAKDIdRi0KxymKFfz4g0lh?=
 =?iso-8859-1?Q?xgfe/A9x9YHo/VA7/b3aL7FJN0w40pcP22QEtmnW7ICfRR4hh0qE1jtKpR?=
 =?iso-8859-1?Q?WQbn7iKkeUhb0PaX3m9MppEHDhsJpkSU1Z9EfFdclJwBaao2CdhbdttN9b?=
 =?iso-8859-1?Q?9X3CuD2Wf5o3XOGZdZ/E3Um5TMo0j1rpvO1uuDE3Rd+ZrM7C5hmDdHdvbG?=
 =?iso-8859-1?Q?/SpvX7WU7kI0+EpxT9DHtk6K3v/Yx+whvDI2MD0uQ6o1nCmrRaO+i05U72?=
 =?iso-8859-1?Q?IsNX10w/hpIdeo9GIz6T4J2e0taXFJuwCcLrq/RL/vAWaphk6KYQvb/NTf?=
 =?iso-8859-1?Q?yBD9sZY3iL5UBgMSN2DZoxE3J8tEHu8ohfliMGU/1De5MvvZlqhcZzMFrF?=
 =?iso-8859-1?Q?KWK+fjd2CVhFmBAjuoWJr6OrmnsfZHHLNAlaBv3iI411fUDP5OOEM/wuk5?=
 =?iso-8859-1?Q?RAhziIviGBMnVsBPPWZ5FbFGuGZiDV4wQo/0mWSR1/0ojXMnaN9ewk6xRC?=
 =?iso-8859-1?Q?3rBncfpnXQ+l1ig9tgo/77LJwXPx5eFUvMuQ/gQx6ZSrh5qtwGRJOM3JrJ?=
 =?iso-8859-1?Q?sXnGLQ6y9tAZbNRmuFuDH+o5wJqRi2nONf8YNFbnFSiKmsJh2EXhWDOgYt?=
 =?iso-8859-1?Q?zpb8LCEGvdeVVmCjDKHMFz/JRI69OC4IYkHzBmIFyZLziIvJ26heVPPmJ6?=
 =?iso-8859-1?Q?QakCR3LZW8fVAgfDaZcnJRRDmNK3ocX2boKj3m3k?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <335D6CED69CD424386C1B2A827223C99@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff53e08-474f-46c8-00c3-08d99a1c1945
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 14:06:12.2040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVLtSm/yGFhqyNDde9RxMGMlDFR1PIXLgna6VW+OWx1iwu3vCwYy8UEtc5aGFw5vWYRss4ppVUWCBCsIReFzDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 03:49:30PM +0200, Cl=E9ment L=E9ger wrote:
> Add support to get mac from device-tree using of_get_mac_address.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/eth=
ernet/mscc/ocelot_vsc7514.c
> index d51f799e4e86..c39118e5b3ee 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -526,7 +526,10 @@ static int ocelot_chip_init(struct ocelot *ocelot, c=
onst struct ocelot_ops *ops)
> =20
>  	ocelot_pll5_init(ocelot);
> =20
> -	eth_random_addr(ocelot->base_mac);
> +	ret =3D of_get_mac_address(ocelot->dev->of_node, ocelot->base_mac);

Why not per port? This is pretty strange, I think.

> +	if (ret)
> +		eth_random_addr(ocelot->base_mac);
> +
>  	ocelot->base_mac[5] &=3D 0xf0;
> =20
>  	return 0;
> --=20
> 2.33.0
>=
