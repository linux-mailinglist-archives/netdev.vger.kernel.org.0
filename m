Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8174925A3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbiARMXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:23:25 -0500
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:4512
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234413AbiARMXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 07:23:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Num/xt88onrYzk5/DsoYk+ub1bgmZey33rNv5ZIIdkPOEJqL67ku47KgR38JiAl1vtUPbaBQNfum1uYU4x7n9pLvtk78BryPE9n5HNje8DC5Q97rIUzzKVTl0FMYmV+NvkRNGPBnvV43ZRYboHuBHoeGxpxcnts7LQRXS2TmbZrDT5ytpHW7lVFKtj1OER4MixTUbLdjzZknp+CFTGV4XSkW7aH9pBs8KGcUCLVehFPgwB5Ed4aHZnmm6jYoPQUvCEJuZX9LabBcV10bBzH9poL2no0LHoHk1D2fXY2CbqsiRHRahlaNRx8IpdOM+gHDOFtjoVaZefZ1Lr1NpancxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQHzva3dDpcxFl70kIaY3H2OtluRHA66LLXxe3kXGLA=;
 b=Df28668OYihYdr3nfBb6KgjBXoNcs0nIaTNe1VCDVkqCbQBGh1YOonoqeJsQ1Xn7jdPrS6BZqa8ydMJZv3q3IAyrJfeX1LVSfKLr9YKHpS/3uzz11kVBm6s/vUQW13L7+NXJx1Ui4ahc8GfZU2J0CILYhTarpbY4Q1s188ls9isLuNL/Xdpb8TqG3tPBZjVR5tmBBLZGgq6LwT5A+/SLjmrdHsa7UvBqu+/Oqg8ZEr4pgHy7nSoE3VfUBLSFP+Yhh+ZmjNts/2vW0VT98mX9zq4Kyz624bwXVm0xNgSlTogcFq7AscqLzZbvGc97vS/zPoVYFJFeUZN4vIzURKsOtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQHzva3dDpcxFl70kIaY3H2OtluRHA66LLXxe3kXGLA=;
 b=dnNEbX17JME0b/FPnNtAlT/L+JVlLZD4aZsBd93EnKBhrtqE+EEBYCVwMtyo6DylAHK8Q2NYAxGMhysy8RH1OgGKRoBqBPPTiAYqieIdWMd9qazSCCiG85MFz0vKGC9Nh6LlUYPwZOtY4D2bgX6gUaRXBvphZ8JiliWVWjsVHLE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB5836.eurprd04.prod.outlook.com (2603:10a6:10:a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 12:23:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 12:23:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.16 108/217] net: dsa: ocelot: felix: Remove
 requirement for PCS in felix devices
Thread-Topic: [PATCH AUTOSEL 5.16 108/217] net: dsa: ocelot: felix: Remove
 requirement for PCS in felix devices
Thread-Index: AQHYDBKgJJQHtgdBEEWeoJNKtqf88KxotDEA
Date:   Tue, 18 Jan 2022 12:23:17 +0000
Message-ID: <20220118122316.yas6mmyzog6said3@skbuf>
References: <20220118021940.1942199-1-sashal@kernel.org>
 <20220118021940.1942199-108-sashal@kernel.org>
In-Reply-To: <20220118021940.1942199-108-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d4b53e7-2fd3-48db-6890-08d9da7d4e9d
x-ms-traffictypediagnostic: DB8PR04MB5836:EE_
x-microsoft-antispam-prvs: <DB8PR04MB58366C0618736F366F7D0E5AE0589@DB8PR04MB5836.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oApbONiMduiI/uWSiteZgrGE705sBTDozXgN1jJ+yQCTlyZ8liKz7GsxWGgu7xVzT8D7ZiL+sJD9g/U0+epDuC3FIZrjpYzPgK58L9HzmZj5I40E7nRfY41cDclM8aCa/XEnvOXzL+6G1hVyxoswBSRr7bMiq2988Hjw5UDUp+iPq4wVCaA/w17YWVi5ynkVM34MsrfoX7p0pFZc4w7HCrUAiFdHlnOZ766mlSc+ThM5EvFx6TcHpTXC7UPGygCjUyKkGVZHkuCQh4fDjy0lbTNpHG15kXeo2qK7WxR8oV5vtfYAx2+bRSVWrdfo9UcfNJsd9qBQiz0GrLtytK4Mc4aSfM06cIv9gRbmpcpHIni4DwONruplXWr8cRmz5aQLaxi6JeyfU+cVpjhLnXrTvIeOQYg9Y3klLZTHjFTV3SAyo9Zt69gJ+BxDW0R00XDeJrdyRx0fuedysPsnPWVqUNudv+2YWAKjU5dGaGBzkHx28yxyZC97lJrqwkkgnfmeKJIIbRKPknI1FmtfludpC5WU9szizKlxtAYEbvhpZ6yjga0tAFU5zY0vJR/q7uuWviqdhkKzFo/iurtQ7DN5+YRbYnwAK9krvHsIgP3DjBb6BklyGcxeTh6g2LEMMR+eZwdCNRWqJbquKxPgYR/CBNxh6gzdzO5FZn5OvkylqNFeVwXNbcMaYCdmrHIRSWqD3oLqxl8YOBKL1e/90waFjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(76116006)(6486002)(508600001)(8676002)(44832011)(66476007)(66946007)(64756008)(1076003)(66556008)(91956017)(8936002)(66446008)(86362001)(7416002)(83380400001)(2906002)(9686003)(33716001)(6512007)(6916009)(26005)(71200400001)(4326008)(38100700002)(38070700005)(6506007)(122000001)(186003)(54906003)(5660300002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UwQkosIe7DvsauQ9Af8cpnGAUSksBb7uOBcGDYdC3AzN88CK4zncvJijSGNv?=
 =?us-ascii?Q?zjptWPafvEfx42NZO/g4rpz8ZaRPn4VOgHur16A9O83znVNRhE4zmX0JBhja?=
 =?us-ascii?Q?ART6vCXhS/iEZ3+nkXFWD17Ao88ZYX/lsqWnsgumZFkJxfKZqgDYumYYkOlI?=
 =?us-ascii?Q?f9npRa4fSqssUlH/2JYE17Ellq7hgG/FhW3Qdig3RDApmQc8a6/Q40IK/1IO?=
 =?us-ascii?Q?sN1a2Z5Dec9yQcy68okQkkCnWANkVnXLMlG+Peu1Mul36ahWmE4LVonLV7EV?=
 =?us-ascii?Q?udNyup8xJdCO8IKAEQuVg0u90a3XV5hdDSN5WdwysH/Vs4qkDdHqa7FGaKeY?=
 =?us-ascii?Q?OCS3sinObe50JsIB4/OTx4s2v/QrMvUQFWjXx/8A8SdMX57R+uRazoTjXMD7?=
 =?us-ascii?Q?2ecjwRgK6t4HVy+jQjX3wi72NurHFJZb7uQA/be/+dey5SAc4BuoG2ZGYCCe?=
 =?us-ascii?Q?BWo5FVPlIC6YaKJvhyWMPxc3WRT1FIWWnTBVIL6l1CLMfiAo+iUPtNLEnS2m?=
 =?us-ascii?Q?J5yOzcTHEmwo92Do515kt5cHeZzqq7DDe+Wqwn2BkL2MVlGMUK6UbkvJhPnG?=
 =?us-ascii?Q?F5/otYCQJX8yXiH2McgxmPHHNUJvR2qtmyFb0nkFYFheck1KhGIfPzmrl2DS?=
 =?us-ascii?Q?fsPzKSQKAG6w21fjN3QYMCD8BdGPK2E8OKH1zxyRgO8k4T5Lzu3DTs5FK9TP?=
 =?us-ascii?Q?JLzJup7UvgZoWSinGdor86oNSvSHrf2x7FLUfsLPtSkTqELed0CCCtb2LD50?=
 =?us-ascii?Q?DsZ2wnq/474lvTgtU62zOwaMWpXzc82yWfm78Zpy0U7ikdGs+iisHnkcY6FA?=
 =?us-ascii?Q?h3b03Fgw02eQ9SQNr35p6syZYZT43hC1+fL+rFWZAutriQNwnNq9MuCVQV05?=
 =?us-ascii?Q?Po+odSSdNrcJ0XCEvE4exFnUI7rUtAK9BZIlfCkLqJNVEBGd6A8Uw9J4b3xe?=
 =?us-ascii?Q?IE/YN7LLEY3hWjitaSOUz8H0JGjDhxKV2yAMd73nBoydWrbxIERGYvuoS2Ly?=
 =?us-ascii?Q?ekPIjymzp55hhbCjb1HHrVK15dKIYkSLbKzg6+YHbI3YDpUALA8seN0d4iS7?=
 =?us-ascii?Q?zgsgNT02BkGzwtHCbRdKckNDytKHmUy0uKIuWCRcodM92XZdRp9LOJGq6G/9?=
 =?us-ascii?Q?GJoBPl7XBQB1y+e3U30BUzQtLBYqfKy4PurI+93B4qzSj/iTkr0FV5rAvKOk?=
 =?us-ascii?Q?82rMRZhCnVLIuUQgo5hpOu86KVyMprIX1omANjKuE80KcazGUowQcA5sisIB?=
 =?us-ascii?Q?5RyKoXv9hj9pCFDC6qqwwPa12IxhYeOptSA7AawKh77c2xrPHrUi9RlmFTI9?=
 =?us-ascii?Q?v+urSrgOmJsbvwn1OS5M0xle5XHNutjgOSEAkgTrifGAh+nVJSfc5ojMDKtW?=
 =?us-ascii?Q?vWLu55/8WNJlArcX4VOYWT3zu5R89bmDEY22vwabelWCUJTtA+mrjIGhAgtm?=
 =?us-ascii?Q?I7Ry9eerWMXtfU12gBALWjOdmsWAb0GkwoASo9ly9Xu4k4X9K3ESU/Po3O78?=
 =?us-ascii?Q?iALqp+xfxxmmD+BQojBMf8f44tMj+EDIeFNIzuAwl2K+nCH4LLkl1HKis8vv?=
 =?us-ascii?Q?6dlo6YQFafHxIle6jmulayVmrUKvAtbjb7QCSM8CqHZ5qylIe2C0Bw+3LQel?=
 =?us-ascii?Q?x/VAz5mqAA5KFm9AMBlExjk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3202A6493A3FBC4C979515BD9F983492@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4b53e7-2fd3-48db-6890-08d9da7d4e9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 12:23:17.3560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 36NQzC3cSAaw6fTCGq601RQ7H7vbObKovDKr7/yUkqm1kQYATKsnJ0lacIAAVrd8BQ4ZZK0sqW9jFlE/1AY7MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sasha,

On Mon, Jan 17, 2022 at 09:17:51PM -0500, Sasha Levin wrote:
> From: Colin Foster <colin.foster@in-advantage.com>
>=20
> [ Upstream commit 49af6a7620c53b779572abfbfd7778e113154330 ]
>=20
> Existing felix devices all have an initialized pcs array. Future devices
> might not, so running a NULL check on the array before dereferencing it
> will allow those future drivers to not crash at this point
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/dsa/ocelot/felix.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index f1a05e7dc8181..221440a61e17e 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -823,7 +823,7 @@ static void felix_phylink_mac_config(struct dsa_switc=
h *ds, int port,
>  	struct felix *felix =3D ocelot_to_felix(ocelot);
>  	struct dsa_port *dp =3D dsa_to_port(ds, port);
> =20
> -	if (felix->pcs[port])
> +	if (felix->pcs && felix->pcs[port])
>  		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
>  }
> =20
> --=20
> 2.34.1
>

Please drop this patch from all stable branches (5.16, 5.15, 5.10).=
