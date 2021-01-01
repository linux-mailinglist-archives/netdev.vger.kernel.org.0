Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026A32E8522
	for <lists+netdev@lfdr.de>; Fri,  1 Jan 2021 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbhAARIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 12:08:09 -0500
Received: from mail-eopbgr1320129.outbound.protection.outlook.com ([40.107.132.129]:1165
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbhAARII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Jan 2021 12:08:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ndx+cLfqbbaZHJ1Q/YsUDeXAHkVgpl4DxINd6ij2UJ4jEoGROmGgM2KtW5TvJm18yQbnuUT+cViInXpLGVkgWFOqiLEr5dRzctywle4VObejXm30SG1h8vzk1RRaCxgIpuVu84d3EK5yjbDtB3AgZQCMQRjzISDK/xRPDS9kSi17dDtVUwBUa1ap+SFyPylEFXwwlRkPVgGlytAtv2U7aTrAmvHcPhiYS3vtnTjpv0JSDmyK71IaKpODNl0vYD56Oy8mePWHMwig0UoXW3VGQX8l7Lc+GhXzR5VSFPBGYxwAftXC+PNH6/29khtNRQVHsSonPe47doU7CdDrqycvHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESfxjYpbH2c7T6lifwuv4kKyKlbJoJW0sa+Il9m6qdk=;
 b=Yqzumrrw1iqkKXstNsjQVPDeamXXeb8cPlkAwWFALLDhL4HmuJsRIXVEUWMNe72GFHC9KrmMfEmSBTaRqUuOMvy6XNa5OvtFzgJTW5HNXgn1QRh4w57LR5CGGBPAZ4hLmgeX7iyomERU10tL7l+4x5zPsroqs4W8V3kB15m9mvfMZvvzJ/fu2WM3SGNV03IKw9nw0vKwjuDrR1wKikiS10WfRFj2jRG+ugOezHWGepCAJK1glVrHwBzWCgVyTi9HNbx7wPUbJX8EZ4F16fUHNNPKyomVQoo02S7AOvUvHUJm4RqaFyhp/MdgBKFsJzdhbKxLuIBVmoO1UMUgjA9LPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESfxjYpbH2c7T6lifwuv4kKyKlbJoJW0sa+Il9m6qdk=;
 b=XQjrk/hH8Nlj/a7BudauFn7J75Jg9qmuLtrR5ReZiEcom0tpDoa5VzvHE5N2bZgPFR1aEQ73mFVqOcMx3DqD9RTDQKW+yX2n+MJv2STItgzB7LtrB5jr3bk6MhIupXz53JV6TgGIusmwTZZbBU5G8CveXF6FDOq5VSACorgXmCw=
Received: from TYBPR01MB5309.jpnprd01.prod.outlook.com
 (2603:1096:404:8025::15) by TY2PR01MB2811.jpnprd01.prod.outlook.com
 (2603:1096:404:6f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Fri, 1 Jan
 2021 17:06:31 +0000
Received: from TYBPR01MB5309.jpnprd01.prod.outlook.com
 ([fe80::5d23:de2f:4a70:97db]) by TYBPR01MB5309.jpnprd01.prod.outlook.com
 ([fe80::5d23:de2f:4a70:97db%3]) with mapi id 15.20.3700.032; Fri, 1 Jan 2021
 17:06:31 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH] can: rcar: Update help description for CAN_RCAR config
Thread-Topic: [PATCH] can: rcar: Update help description for CAN_RCAR config
Thread-Index: AQHW345uMo6jwbPTE021zsa0BOwzqKoTATIw
Date:   Fri, 1 Jan 2021 17:06:30 +0000
Message-ID: <TYBPR01MB530929B7507AFED04F4BADAF86D50@TYBPR01MB5309.jpnprd01.prod.outlook.com>
References: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201231155957.31165-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20201231155957.31165-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-originating-ip: [81.135.30.249]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8038862d-87e1-4027-b833-08d8ae7795ef
x-ms-traffictypediagnostic: TY2PR01MB2811:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY2PR01MB28113E408A99B3A47AA52DA886D50@TY2PR01MB2811.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Miv+pZqBPQrXehip23588+GB6sSrNik9WfIZb7r0NQmPztEIbzKq3NxXHCSyd6hyobRcfmc+ehz/VnY4sYZLe0KlazARKVtTygQXNQjFyeYShQYHcoR+gvj5LI9/+FuwusBU1vbf8o7M2/YECiZ1R+xa39sEvgf2orHTs8d6t+J+4IymfrujQxuknbotUO3IYyQGkIgu2rIkjtr4HwB0uyu2B7rjBiWueWoXu4aFNbzTtrkDkqJaVCHo9AOkH3MYQF0Q9ZXAIoSsmsZ2m7uTFPDFS9Qj0bXfaroTQj2Hj7vIc4HDwZViSIGwnpkf/A+WiT8oDE2AqcHV+ZK2bYZ4BL5uXqsAUBuj+MngNCuX6ZDOo1r6fdcMPN7KfvhSowT0Pefk35KY6Lh44DOkIK7Pzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5309.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(66446008)(66946007)(107886003)(76116006)(66476007)(55016002)(4326008)(52536014)(478600001)(5660300002)(9686003)(66556008)(83380400001)(64756008)(54906003)(26005)(186003)(7696005)(7416002)(316002)(33656002)(53546011)(86362001)(110136005)(6506007)(8936002)(2906002)(71200400001)(8676002)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yZiF4dDVHtbST0snQUWWR69S6/ec02qfhMryAeW7Pvqd1AV9o3uafp2TT5D3?=
 =?us-ascii?Q?Oi5ltOHjHbK4okWTzOZa96SZQcNqzkAW24iB0XS1tJ3ikdRhYwvdp3hRg+E+?=
 =?us-ascii?Q?yNIcAzYccanFemiWKCSNvarhNtGQJbfWP9KkeEoI20tJBN9jyWBESOpxSsJ3?=
 =?us-ascii?Q?u5Y0ZFalmYOyFhZDprwtctYlvaeBAjDvmA4aNARbCYsmfXv7KAp2scBcy2UI?=
 =?us-ascii?Q?ZHchvwH8WpVNO/o/nI5vy87FAIdhSMBfBxf/6vAmRUrbOdrxUU6aofv+u1NJ?=
 =?us-ascii?Q?VciawiouRGsm6WiXYExu5ijTcL2SKJy7AX0Pgv0NH35iNfmlXzeZjEglrlZ5?=
 =?us-ascii?Q?S+l+GG0wYRxAQWcU2YDnsOsfZqnFsfCjuT1hXaiVrwqS9WFPiNQ0yWrSnI+8?=
 =?us-ascii?Q?Gbp+eiYC2ciCv3JSREQxPuLgsSijtnLF8NqlqZv6MhAhXfX0q8HfaLIspCGh?=
 =?us-ascii?Q?ju+oOV4tyehCznyBtz9UV1kARx3Dm1pq47OH2SJxzyrhM5lmgZHeOrnyYVIA?=
 =?us-ascii?Q?15CZd2pWDGhWa+rU5fnqgDdG7GNOGOAG7OksOne2uG/CctG/urPjJGtcEn+L?=
 =?us-ascii?Q?zcP9+dHHjh0AQxR/HpDZxwlvdRey5NeRZLNkmwSeMs0gprGAou194/Szr098?=
 =?us-ascii?Q?TqhiPAw5kIVmcYAYKL0rSFP/jFawAxq28cxpa0AZUOoGUyHEbz+EISemRyvA?=
 =?us-ascii?Q?8N9Rr7zhWLH6+7A9TlTOuEy6yqn8LzUoH3m9UPvVPiXdJsNP68cCY0qlQV34?=
 =?us-ascii?Q?w6tM7CtDWwl9blOf/N6BUs8mIutaKG5FMSdEkx15IIIVGbkmyqqyJSeMmBDf?=
 =?us-ascii?Q?ePmj8vVJ43dSdXoeOHX36Q/OneqQT1lDdSgvwNxM6NImkVgD+HU2LUqKlK0U?=
 =?us-ascii?Q?NVN8uz82gBcAUUwDrrnm2deGQYazr3Rny9b7yv/0TtoLqd1EO2EY3qc2fi/v?=
 =?us-ascii?Q?Z32hvvxMoB/hRfvVWtuN4wr64H4RdtsxN/Ql7yXCAjk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5309.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8038862d-87e1-4027-b833-08d8ae7795ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jan 2021 17:06:31.1397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P52WWsjztdBg/trwyZUJs0M06HnqRJpXIJLUawhQirJc2+KsLgbovjOpqo3XQOo5wRLl7dFDlDPILDgBQlkDST1b0yVXBrDNfPIpNCqGzbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2811
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

Thanks for the patch.

> -----Original Message-----
> From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Sent: 31 December 2020 16:00
> To: Geert Uytterhoeven <geert+renesas@glider.be>; Wolfgang Grandegger
> <wg@grandegger.com>; Marc Kleine-Budde <mkl@pengutronix.de>; David S.
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Masahiro
> Yamada <masahiroy@kernel.org>
> Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-renesas-soc@vger.kernel.org; Prabhakar
> <prabhakar.csengg@gmail.com>; Prabhakar Mahadev Lad <prabhakar.mahadev-
> lad.rj@bp.renesas.com>
> Subject: [PATCH] can: rcar: Update help description for CAN_RCAR config
>=20
> The rcar_can driver supports R-Car Gen{1,2,3} and RZ/G{1,2} SoC's, update
> the description to reflect this.

Not sure we need to make it generic like dropping {1,2,3}/{1,2} and  instea=
d use R-Car and RZ/G SoC's??

Cheers,
Biju


>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/can/rcar/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/can/rcar/Kconfig b/drivers/net/can/rcar/Kconfig
> index 8d36101b78e3..6bb0e7c052ad 100644
> --- a/drivers/net/can/rcar/Kconfig
> +++ b/drivers/net/can/rcar/Kconfig
> @@ -1,10 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0
>  config CAN_RCAR
> -	tristate "Renesas R-Car CAN controller"
> +	tristate "Renesas R-Car Gen{1,2,3} and RZ/G{1,2} CAN controller"
>  	depends on ARCH_RENESAS || ARM
>  	help
>  	  Say Y here if you want to use CAN controller found on Renesas R-
> Car
> -	  SoCs.
> +	  Gen{1,2,3} and RZ/G{1,2} SoCs.
>=20
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called rcar_can.
> --
> 2.17.1

