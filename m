Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A784840B4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiADLVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:21:25 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:8193
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231127AbiADLVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 06:21:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGrYZiteYYpKwkteVmRqDvIA2soCAUVA0lFOWzjJVUoVa8yWVyO6HkDMB1/UMinZT5z9hp/n65s1sKNZOpvtRJFhyXhmqiA2emdSRahrSYlKq103N9AxGyUi0zaj29d+FHX3ri/8Cb+JR6TkUAWbXz1YD7o/jfPjiobNxBESaIk9dH3h0ZnJf6lbQkS58AYrhMm1YjoTQgxFmaalx30NHsXBiNS6uoNQLkUXb1f6KTF6LFfHp7zmxsZZtoukFV5uWUF+/NnEvlJRhSbFQAovV174pGN2oVCM/+sxU0QZW0ccHnm3b00Iiz/GJe6VvuIxj0/wc61I2dSv/efAPDiPrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mm6mzyhLg9RWS+37h+ryhXna/h0/zTmBCEwmb+9qP0U=;
 b=jTZX23Q/tucsnttzdXYGchvjjox+HeSmd+R4zGPorInJREZ4ZTBLmZE3gZiBdHX9UBRkF2CasipX+EiDOsZscFeqPqvDHYTQdNxV2NrrzLFDOp7fFpRe6N0SeS7l4azM0CM5J/O2m12OoyVYdWjyUvRYpd+TFFHFkN9ispdJg1pk87IPPWiwbwhqku4CktZJCQNdU9YtufJZz2vrizSGlNn3W0Z0tyIBkwqHZ1I412sfo90hJwP+kFla2hpWoUGJBSzwedldwrlsZaocdVAINK1jdAJyf0B1Zcc0v61dPz6SyKCISzqOVhIOOD6xTK3rXwApb4I6vkAQIfm2uIZOUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mm6mzyhLg9RWS+37h+ryhXna/h0/zTmBCEwmb+9qP0U=;
 b=M/ZVb/T7RP3fptw/nkQKfihjbdQF5VVkbEYnEaVY0+RyRzK2srgFvysG7MXEXe32KejtuIRVvSWXRXWeDC6/Tb1PgyeRruWUxXuwVuVbPaq0EpDfJ8wjv4KyWxovkF2p3eGimO7kqMEPoKDLsZTXhmR3WtdvSV5W+ceAPZHkcG4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 11:21:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 11:21:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 2/3] net: lan966x: Add PGID_FIRST and
 PGID_LAST
Thread-Topic: [PATCH net-next v2 2/3] net: lan966x: Add PGID_FIRST and
 PGID_LAST
Thread-Index: AQHYAVQxwkmkDz+4V02XsrSPi2qWZaxSt7wA
Date:   Tue, 4 Jan 2022 11:21:20 +0000
Message-ID: <20220104112120.6tfdrzikkn6nbhkn@skbuf>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
 <20220104101849.229195-3-horatiu.vultur@microchip.com>
In-Reply-To: <20220104101849.229195-3-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cde6a0d-f430-4d83-d428-08d9cf7455b5
x-ms-traffictypediagnostic: VI1PR0402MB2862:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB2862FC0F52D02840AF1CEF0CE04A9@VI1PR0402MB2862.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dCxH4JjUb8tWQZokYM2S0O8VxYGLmJ5faoq7L1uAdRXqNDdDH6aroXajapa5/CuQ2xuO53xyRtQDRfrM7B8Y1f06BfWZt8OzYnW37zkhiN8xqhmmS9jIvNM+R6Go6VG8VqZRhgKaoBP9iUE6/BHwPAYkePYRbFHwYtRb+OjbdpJszJggtk2YnhEHKHmPR9Upq8ogsWprMck0ccoQFPq2OLGOSAZGman0i0MBgij818KHdYWLfBJK7EcU1sOmJnhXy5s4yQdVxuIfeI2vMuFXa6C7sIWCal7yWvopPRpU4Ai/TJ4EResOho+wOffGixtJjCJiok94z1HS/qLPedDlXZVaiCWEeu9HMXYjqqrJ48HSLIBSN3O909IdE3X+k7Ruf2IU14PWR9gMQm2pcb2JcmgP9ko7Rj8JrngnzP960RyyuU7R+O8NOzwHa8ZDYxHUbVxDsnTaNrZgQZACpzGcAMAaoTUm+REo8/M3q+WWrYsCuIL8zVBXVQ/dQQkkYRXEjnp/3UQopeMvK1mc6Eqq1ZNkJEju0i/BKd3ZtdRb+EgF3NW0W5bax9IPJhmQgCyo/4mexM6zTztaC6mTjsYMhF20++UB8iRM8ZJr3tpQcHBj79hOFYfVY2aVRxju90AcsOTwibIDg7Nv5GU0gCaajdR5dPpTbBh4feni7TWMZD48XKsh3jZY3b7jGNSDYcfqVlsDnv1rHmVJiuzMSCYFUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(122000001)(38100700002)(71200400001)(8936002)(6916009)(5660300002)(66446008)(186003)(1076003)(83380400001)(508600001)(8676002)(6506007)(54906003)(66946007)(86362001)(6486002)(6512007)(2906002)(9686003)(316002)(44832011)(38070700005)(4326008)(76116006)(33716001)(26005)(64756008)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JrLVHGFZfVIEwswl5P1KH14V+ObmWfLFRmbCEbvNQCRvuoIUVzt03B/BfS1i?=
 =?us-ascii?Q?lrACu5bed/7K3NTFLZyB6Br2twX8Cl7DjuXWRRY9zjs8pDwMfJYwm645z4vO?=
 =?us-ascii?Q?998YVQtAy+Ov+8L0xC6wg/m2YuKUO6VxhRTZnm6UQ/avzKTTUSHa0/h55TuM?=
 =?us-ascii?Q?NnbW6lYXhzXzhBsT5/eCthJcu2yrEx3HqiOmy8C4XnU3ew7bwTXLDhyK4jYC?=
 =?us-ascii?Q?90+IdhN7i3J227S6dC66955So0bHCSnE9fYjkJDF4FNUjv4CjKpryzKsgz94?=
 =?us-ascii?Q?mHoCo61njRs7URJ3Ilnelo7LOcspdPNeZTy8Mw0eYFgN9HvbwIlfE/hTw7KP?=
 =?us-ascii?Q?TR55iW2oCGvi/YUB8h1z51FagRc2tpxD3QnoBVY/es89jfhW2PIbcmFDHuMW?=
 =?us-ascii?Q?B7p6rcIx14fLR5qCPd+WKiX6CyKcrfBJGhAeJFzv8S9wBchOxcgjGX+e6BHo?=
 =?us-ascii?Q?VqC4MECsTuBrxuszu01pgAHe7MKq01WHPtVgKjJ5UzZIvIot7H/BT4unTXXj?=
 =?us-ascii?Q?pmpla4qYZfn55jMCwzKMejLJYvu9RRMM5ARv2I6JTNm7qZHDMK0FklmUzol8?=
 =?us-ascii?Q?yRpKb6Zc1smK8tFgfydLR61g9AjIE6N55hdmINdXCQq92vn49YpJ3l/GCXb1?=
 =?us-ascii?Q?ZqEf2BpXN1tuiImpqZ+7gzgulhRP0SD4Z05ouxFpja+LFzlZVJeeaURIaIBA?=
 =?us-ascii?Q?Kkt64JH2jpoJI55796q4A5iqLSmB4dOiW5N/hXKoxYeuH/tphOZgaaCcLXJW?=
 =?us-ascii?Q?tArHfCCSTIC+cTmwSv7wixfQXHsNTEhXLzeU+CbVqreAGWx2ir2V588QriuC?=
 =?us-ascii?Q?bqhZzz6O3OeA6Cxo7PVTQ8NjBSuV0QV/7u2cX8zoodP+MjkfhR6z5ir1bMRo?=
 =?us-ascii?Q?63a2T69uywOQ+Uks6zsgrutb10cqhMqrN0RUnAN76NaBd7lpa5PPoUX2dZEa?=
 =?us-ascii?Q?0JT+5mvxeH2wmWtcF7aU/D7x0krGG9rLlh5zPoPtE0MlFKroegrZtS/D/5wD?=
 =?us-ascii?Q?uYwFjo5U5XAIsuRAmWW1xRvj7tvUxmus5rdA2kvaBiNQxfyNIvEMoajXYoKl?=
 =?us-ascii?Q?AvDU9JDfQexLksXabXX1e1eFP+PGu3NlBhTH4nAet2oTKlIKiUos6yH283Is?=
 =?us-ascii?Q?gOVgA7qA1u8zdn0nwnrwUt9q1zgz/iRaqRVIRf5Q3m9HXo29D0GRSohxVOmt?=
 =?us-ascii?Q?5e42gOEpZ4GISm4+KIgNrRh/+6K2N+w2lfb/X88LrCnPAgYg8uYJDZi+A+lS?=
 =?us-ascii?Q?iL+1byxhJlDqo+CnIJfFhVjjMBRAd3+K1qnIGvYsRsXc2pPwt/6dvAj0QOpc?=
 =?us-ascii?Q?JJQR8XaurgBMHRMxr6iHPRFOLjmFvb1+T1dFRSjsbC0Kb6hw3pHTogVC8ZY1?=
 =?us-ascii?Q?tEOsqsltf2x36cnutHejRPY2rE1iYkXCl625OcRMoGynLlEfLzwwVEvFWkUb?=
 =?us-ascii?Q?5hmj3SCRv8UwyhbhvC66zOfs3m97wu4l0Kgv51Z1O4DqzTyqEx8bg9F4sW1Z?=
 =?us-ascii?Q?KdDXsIwsAl/EJOcqmzgDwZWm1DDrdVI24DM55L5pbvFvc7sGicnmqabnURgJ?=
 =?us-ascii?Q?029ziHltR0QZGmhIo5RU74DPTWQbs8M0NSrTBO2M98Gy0QiKJzgB6vFFvHf9?=
 =?us-ascii?Q?JSyrUQRhjCzhCkBciN4X4MY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <715FF32D9E9BFC438051845451519B8A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cde6a0d-f430-4d83-d428-08d9cf7455b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 11:21:20.9677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +tGfhEuFBYiCnFg9HkfCIiqvOKC09pgQHHihrzpKpvJ9JNONwJTBvhiYWJDSlirc1SYju3ugiTQTe8Jx95AOKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 11:18:48AM +0100, Horatiu Vultur wrote:
> The first entries in the PGID table are used by the front ports while
> the last entries are used for different purposes like flooding mask,
> copy to CPU, etc. So add these macros to define which entries can be
> used for general purpose.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Not too thrilled by the "first" and "last" names, since there are PGIDs
before the "first" PGID, and after the "last" PGID, too. I can see how
others may get confused about this. In the ocelot driver they are called
"nonreserved" PGIDs. It also doesn't help that PGID_FIRST and PGID_LAST
are defined under the "Reserved PGIDs" comment, because they aren't reserve=
d.

>  drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index f70e54526f53..190d62ced3fd 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -30,7 +30,11 @@
>  /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
>  #define QSYS_Q_RSRV			95
> =20
> +#define CPU_PORT			8
> +
>  /* Reserved PGIDs */
> +#define PGID_FIRST			(CPU_PORT + 1)
> +#define PGID_LAST			PGID_CPU

Since PGID_LAST is defined in terms of PGID_CPU, I would put it _below_
PGID_CPU.

>  #define PGID_CPU			(PGID_AGGR - 6)
>  #define PGID_UC				(PGID_AGGR - 5)
>  #define PGID_BC				(PGID_AGGR - 4)
> @@ -44,8 +48,6 @@
>  #define LAN966X_SPEED_100		2
>  #define LAN966X_SPEED_10		3
> =20
> -#define CPU_PORT			8
> -
>  /* MAC table entry types.
>   * ENTRYTYPE_NORMAL is subject to aging.
>   * ENTRYTYPE_LOCKED is not subject to aging.
> --=20
> 2.33.0
>=
