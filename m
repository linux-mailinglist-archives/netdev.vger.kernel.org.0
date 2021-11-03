Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7CB443FF3
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhKCK3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:29:05 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:18930
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231623AbhKCK3E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 06:29:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNJyyVd1ikrJc65n/piE/J6my0lA7gzDbYpSxbJGfbbFy2xngPDraQmqF7dosdaBE2IfON5WRrAZUthE8WSHY0bpVkmHb1AjH9rslcLl1jeM52tEmgjjcUQLL7BDKfgkwfX8Tpnb2pnvQ4XUPfHazelU7CVp7HbK5b9Qvb7kpYJ8XDEyeXj2Xcejtf/J1GzuvGoVhQ9lKsp/HZSLM4K69xLNaq+NApLkVFYeivDSwG47xnRfclXzs9AFZEmFOQR8oVFaL1Ri4CSa9nCQAhzZ7cHt2pYW95FLd0EDsq9/BRs6g7z+b+zaBIWB93LGdPyIHP5ps/LGu5lqLcjEnyXZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nCUIyDaA5J0R5McDqyPRsJVsSMvGY10LjGoGJOFsVc=;
 b=Lp2A4iuafBCkHsrVtHSj5Oj2ZDQ2wocpY3KAM7SGnnebIIJZTSKofiQXLevnN8a09lM2E+jltEb7ILapS6aG0zEXirM3aqv+fCAWireg62E0a1B0BTJeTwD4QJxlstlAb4CXQ/2Ye6CslzMwW1lV8Z+UD4SKGTSBG0NpeFraNWW0Pqhgm7+3yW4K77Nmy1sZZDiejIG3XE5jheZHa0Y5kBS7H5p/8y6/tjmUGQIJ2OLbastcVKmFisvbS/Cb4Jbd1WbFIsEevhKy1ab+JyIPjSW1OnEqXlyPkk4U9P6jesmX/2bxrNzj0cgIXiqjOuJefKR26BvUpzXu61qIT1kC0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nCUIyDaA5J0R5McDqyPRsJVsSMvGY10LjGoGJOFsVc=;
 b=cVTsYVVn7nK/DbJN+2aPO781zjaBhZJWGL9FHs4mvTJ+ZkPaSoUdqGwcVfKQKc7ANIRA8OQtg/ySOq1KEPLn3KSyAginvyfX0LfFuIEYCbFWyx364Itaq5g41rUAsrszzuq1fVjJDF8033q7UPatal8bAmfF30miQUIOLvlYdY0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4432.eurprd04.prod.outlook.com (2603:10a6:803:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Wed, 3 Nov
 2021 10:26:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 10:26:25 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 1/6] net: ocelot: add support to get port mac from
 device-tree
Thread-Topic: [PATCH v2 1/6] net: ocelot: add support to get port mac from
 device-tree
Thread-Index: AQHX0JQL0SfN3NCuTUafOx0abL6ZS6vxmVgA
Date:   Wed, 3 Nov 2021 10:26:25 +0000
Message-ID: <20211103102624.uujlwyhzq2t572o3@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-2-clement.leger@bootlin.com>
In-Reply-To: <20211103091943.3878621-2-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5676875b-2e98-4b82-f2b7-08d99eb463f8
x-ms-traffictypediagnostic: VI1PR04MB4432:
x-microsoft-antispam-prvs: <VI1PR04MB4432F3DE67E794EB20EF775FE08C9@VI1PR04MB4432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:343;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GDkLG/ZGCg3QlrpuNS61fsXC6ERnNoByrtfSfaD9sjB7hQGk4S131sIGH/PKCwvmxqWnvBoj9iKp1iU5oYkiL7YgUr7pnYd5zqRUG6qyP8eL19ePdNw79p58wChJQt2s0NxVlixvRBwaBWYJ418hT4whTDla6kf3b3rYfErah0n9FE9wxvFU/8odPy8v3Qw08PM8cMKlx/w4YXJz9IYSji/LnPUxBwwgFdvErlIjMf2TeIfpigJaf0697lmHJSKbx5oRrxSLgkv0t6rzSSc2hJ/GHEqzy6jpF8Z2RGYPcHy4vKmzGw+s6dBj/khRE4veXw1CiCrx3uArXikx8fjHd03PPNBSR9bTj9IGjJkSa1eMByHMdwZoZ/6ATJNoeIhdnos36cHrHwwG7kg3ms+X3DnWDmQd4uhrEB7mqPEdrbXGKt7Ys9CRJH7o+fcV/TKDMTJgzf67amBHvUT39DrVxpo91Qq/iCufjy5XUFSK0X8D7qxv6PaSZGgJkq8tQzJGiAkUNVcIdiR75U1ZLdaWvC7e2GmqVOOnIDW695FLeDgF2MrIN/i87soth8kvjgVQu102Lq8mwZhlyJr+4LN+F9O3BeOBpMJp8kovtaIkMsiVUP4Ak93c3JAg+Ow5p8wjOkFNRvhxDHu3H4EXDQ5dGAJR06F7OR7BnsbUJ+BFZT3RJzOMYQf1cdOKkcdhvdWFLQMBf5JaTCuX0nthA0i76Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(4326008)(66574015)(5660300002)(2906002)(508600001)(54906003)(186003)(38070700005)(86362001)(6506007)(9686003)(6486002)(8936002)(1076003)(26005)(6512007)(8676002)(33716001)(7416002)(44832011)(66476007)(91956017)(66556008)(66446008)(6916009)(71200400001)(66946007)(64756008)(76116006)(38100700002)(83380400001)(316002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?wmTKMTsgbEiyDgrqt/Yh3oLIkWBf6RS7K5GGShE/fYqDQtPOsgk0spXwcw?=
 =?iso-8859-1?Q?1YA6tonlzLIvIYDcl0NKg4ZINUWMN93w93a03yfAbb2oJjtTRLB3xujaMK?=
 =?iso-8859-1?Q?mxCi4MdhME2W5BqUDpgeoxeA/DDqlBFKYY+ou7akIySm7/0qsRg8/8f54V?=
 =?iso-8859-1?Q?0nxptz05MZrt5Y75TPUTlAjd/lVNDFMeC+kMcjE4P6LD3FeETEYrLL3UO5?=
 =?iso-8859-1?Q?a41ClBRpEm1N1QjmAymxsZho0QTD0n26lQLgUwwzE4o0VS4usOW1i+cBs4?=
 =?iso-8859-1?Q?isdi9CclpXkoQ0MO2GqKU4ktN+wLylOosNj6vTjE64+KVZ1kYY6P4+TCy1?=
 =?iso-8859-1?Q?vtCOW9s4WAPYaZRKYP2EV2TFml6J+icbSgxfyUWyn/RmeFNZmCdU8MShSQ?=
 =?iso-8859-1?Q?tiSeviGC3YoZ9/QSAJC9G47yRkvngA9ytioOEZq1yB4WIfEdTBUPWzjmrA?=
 =?iso-8859-1?Q?w/YveDQcIBxgGAIhK7L60JnensvapHvn5yJR+SFcBEJsby015tIyQeUTd/?=
 =?iso-8859-1?Q?ik0G/+oeObXVC60BmLAjbR+xCzSJSPU0h2um2AU7yaEbj2J7kESCcbmzUa?=
 =?iso-8859-1?Q?kpbo7XwvopQwaNCQyF8rIOCOXKTsUdKfNt/W5ECYBs3F9oigCRXAHoNAkf?=
 =?iso-8859-1?Q?O0Nw5erIgO5QecQYqIZP51+SJLHBUUf61GC6rARTWklxpBg/ar8oHmV7Qn?=
 =?iso-8859-1?Q?8OGgDzWSOF8S6NouICl73Loax+vEkrIbEctjfaPUt+F18A4owg5HOD3cXQ?=
 =?iso-8859-1?Q?6znc281tFRLxn0Otj0v/XqmKNvjDe+kX2GB7yL1kPTrCKFNkGJv88/iMYp?=
 =?iso-8859-1?Q?terl8edv2QDCq8SfVaoAH+mhZT5cZtTCmS4h7rTrOtx7OaFmwZ8XK4aPif?=
 =?iso-8859-1?Q?qUxUbzLKrrZaBiBOElLJIZMuWRzdtpZbDjYplg9Y78cOAQKP/pBspr2ktk?=
 =?iso-8859-1?Q?/Yor2HMUxLLlfHiEd8zuNFT8LIW1W/gqNahXtsQ0qoSiiG04LYUOfePsNf?=
 =?iso-8859-1?Q?+Ue3Jlg3rGtKl/2xLaACbXmF6cB1CSNKMm6ZOR0lUA5masohwIQB7UeZGQ?=
 =?iso-8859-1?Q?pwHPXLIqquzMZymjGQ63uEGGu+p0t+hY5qgvBYUWvQ9PJyn7Hj0Jzbob4a?=
 =?iso-8859-1?Q?PWrJ+GyL/j23PT6DH9wJAM0iizDd1m+zSPikmclDL4ZzrnF6w4cDIdXXH+?=
 =?iso-8859-1?Q?Z0uOL4Z1/a86ux26jU4U1Nukha0WZSd0ObRfO4fAXaapnnVI2XA+UHj3iT?=
 =?iso-8859-1?Q?b6VW0Zl9HO0W5ZhhgAJPeol+S6q7S7LrOrBucmeH4OMfKOZ9Wq3kw9VXoi?=
 =?iso-8859-1?Q?6niRr/cdyJKTnkfKS2kseHx1MhQfpBLzqSdB453L9GOtBISKAGUuv5pY/w?=
 =?iso-8859-1?Q?1QA9U49r1mtzW63I/LgazkwVutedcIzyfuMJKNHic/58CFtRPCTWtNKlNv?=
 =?iso-8859-1?Q?1UnLMl1C9uIQz7mWVZbUCcEzWsKS6pmHjkRrAaAzIaUtxePYqYbwpjPeOr?=
 =?iso-8859-1?Q?dQYUiclVunJpNoAbG3oo+6DAQ0b9pMMzYVLsbYSX2LDtgZLSJvnO96F3qu?=
 =?iso-8859-1?Q?gGp3+SzzoGlD6W9nzbVm3vMu2j/f8+/cMDnRwKLNMmccL28FmkgFfhDQRa?=
 =?iso-8859-1?Q?SPugE7AJYgiJ/SBWHIQ2YSlTJjJgab7+5ACoYENjGqMCleM+guTjR552VA?=
 =?iso-8859-1?Q?hNyyv4mVmF3jMu9yqKg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <518BF9C9D917C147B10223BD2B86F6C1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5676875b-2e98-4b82-f2b7-08d99eb463f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 10:26:25.6558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8unISCMJojtCDG7tzoCWvtzdACpPz9v3hU3WQPqqMaalwtxJ8vxXmZx4MrWLkvaFXWtjCwqG5R2im+fHo4mtjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 10:19:38AM +0100, Cl=E9ment L=E9ger wrote:
> Add support to get mac from device-tree using of_get_mac_address.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/ethernet/mscc/ocelot_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/etherne=
t/mscc/ocelot_net.c
> index eaeba60b1bba..d76def435b23 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1704,7 +1704,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int p=
ort, struct regmap *target,
>  		NETIF_F_HW_TC;
>  	dev->features |=3D NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
> =20
> -	eth_hw_addr_gen(dev, ocelot->base_mac, port);
> +	err =3D of_get_mac_address(portnp, dev->dev_addr);
> +	if (err)
> +		eth_hw_addr_gen(dev, ocelot->base_mac, port);
> +
>  	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
>  			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
> =20
> --=20
> 2.33.0
>=
