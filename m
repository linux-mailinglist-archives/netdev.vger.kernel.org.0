Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25411C6207
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgEEU2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:28:25 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:6068
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728853AbgEEU2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 16:28:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCix+JVW6qspYcjpcJI8TeaRkTe5DGge1ho4KfBWSHQTZaiOi8e2kxVdbazlP5zuJ2ODGzqd8xIehZg3qOWKw92WqEUkVyKMDPs6R6obO59liNB5uDwghEqG+I103WW/6yzKt3VHu8s3b0s0vb5i+Eij/7GA8/tzTudjd7LtVXFG/OMYGNlGEh7eIJQJZ27qdkJoy1SZY4Cr7xlb7U940T788EDJPuw3Cb/OtiKZ0oLp426TU7/SiNmW0Q6rw/Jky39EqgNSIED8YWhkQFMNueBoK02tebwl3OSLmZrCaIAKh/h1sLRYhumDgnqTwVJ8RkrZfyBW149wenYXhFl5xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0udm7ytap8x+f7c0c7GLyR6RckHwKdp+5Cg2jXzTLk=;
 b=dL7oxMcwwP+c0FrAWZc5fC7VUd4yUnq+VhCR2qo1AaUs5Ui2XjRPWErIUPveGQv37l/h8ohSlhP0JhX4QT2qlA1Ifx9bzCTdunb16kK9i75vnwYRijGM8NgQEMYJQs1o34mh3sFuB7+FmpJx4i6yIrJ2atBPztx7QphxlVK4oz+SYD644PK0j5Sak/tO8fgiYYFxAjsB167LQ9TLzJ1uD8LkO1syuNgucTv9L6YGB+O0pEk0wCNzq6l1+n2jQKWd8c/BlAxynpd8VerIocjvBO/Lw2R6HJjVB0m5M8LVbD60sMv03owAXp+Hq62Alt8oZ7AhKjIUcq7GhD9y0vFuww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0udm7ytap8x+f7c0c7GLyR6RckHwKdp+5Cg2jXzTLk=;
 b=ChcPFnMlV7bArtOw0Ynr6HpA7XTG8eMTLGLLc6213OjKyJ+bza0S4vN+n43tdmZ2oXCgoYkgI8+J+TYuhl9W6cGrhNWy7DC+hJWFZ+7Je9OQ5GknS325w8lRpCinunmIxQgQtig3zM44Xl3RjrgdFMjevylPBnz2fW6C7dPW9RA=
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com (2603:10a6:803:121::30)
 by VE1PR04MB6349.eurprd04.prod.outlook.com (2603:10a6:803:126::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Tue, 5 May
 2020 20:28:20 +0000
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::48b1:c82c:905:da9f]) by VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::48b1:c82c:905:da9f%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 20:28:20 +0000
From:   Leo Li <leoyang.li@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Youri Querry <youri.querry_1@nxp.com>
Subject: RE: [PATCH net] soc: fsl: dpio: properly compute the consumer index
Thread-Topic: [PATCH net] soc: fsl: dpio: properly compute the consumer index
Thread-Index: AQHWIxnvaBco/TscSUWgh5JBknwmZ6iZ71hA
Date:   Tue, 5 May 2020 20:28:19 +0000
Message-ID: <VE1PR04MB668714A83CC2EB638BC273208FA70@VE1PR04MB6687.eurprd04.prod.outlook.com>
References: <20200505201429.24360-1-ioana.ciornei@nxp.com>
In-Reply-To: <20200505201429.24360-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [136.49.234.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fffcbc3d-d6b5-4c81-90c3-08d7f132d9dc
x-ms-traffictypediagnostic: VE1PR04MB6349:|VE1PR04MB6349:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6349CF2C64A6C6860AFC214C8FA70@VE1PR04MB6349.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EDUeU5RwkX3kskTHgnVK0rFzS1eawKFKGw5gublMhY3E/RBCNnBHDW3N1qI/8pOQbBdJNTaW85/Nkk6zp7jDLtUaorrEKUDAjeBDkjedthQU3v1Xb0vxkttF0fnUcs1ztmafiUxQJPrlD7z0gETvIq60tK/jh23d3bJsQKFtuX2yYKMpO87z1eDeiKkDMqyNNad2jE3ll/hjsX739XKsUmGEdE0123AukSBrYWmNbweiXXZjNeiXIrR/fsdsKefKUT/agBQQ/BUgkJBEuNbin5DUNdl2yu7Io7GPz2OZY8adkft27Pt3jmtlehtvD+kieFIcnUFcfsB8D7b2JfoC5Zbv7xeICGwclPAkBdrZNsTyMPooPZmxWiaJDpPd0mkkswA0Veo/TQeonTFkPSZc4OdxuVlgoN0NFFj8xmR3wuB5E5Qxj3TGjFq5UD8ebChIipSWmyfIiXODL6sktmR5JwNG6ON2CJpJG1bX3txuliSzZTZY3/bCXXPYu6Jdsmn+E6ty7FiFgpMEh0Y10mQC+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6687.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39840400004)(33430700001)(478600001)(33440700001)(2906002)(33656002)(110136005)(316002)(66946007)(76116006)(6506007)(7696005)(66556008)(64756008)(186003)(4326008)(66476007)(26005)(9686003)(66446008)(52536014)(53546011)(8676002)(55016002)(8936002)(5660300002)(86362001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ld8X//3AQWoeER8b8MoAfnhNPYB/5CtzfhneWJ+IxVccCt5tCU2JQvG0zAJEp9bibPVeWpBqcaV6Q0R2UNL01An1UXTjcUXbbqQKq/MH8TobWoeZMPj3h2FyXjbh+T0XksbJEUKEvm/ZhPJ7i3D/cInfF1bpGy0bbjVQuQJnJJuFI2jKK7AC1Mr14vZTE92IMBm95Cn/F+mqEflNKAOLow8BjFsJLKXY8psusYhn5+Re0HtuOOtFcKOI2vwEs/dF6AAiZt5Jv5QUUbOcPCEDGdhWMTdymrlHJY51S8FUwNN7vWZFJp5Z96hzqB454q+dOmWW6WgrTZnpu/poNleHFgHD6dXy4pXDLsh3+IDG/9ZyeeiVrBhHp9dzrj9ujfcidH1NRY2X+bvcuamkJ76ZvQEu6gl6vZSwaEAbO9MUgvLn0RdJTs4ACGrGjV3njGW2kVkPPb/GsEYjcHThKpUOOPU+pA7hGWY9SwgyEjfQLP+7freUxfuIzEQprCMhgwR/F4DaJgzF/qE4GlVhcGODmiJDBbm6qwYXXBvaKyh+QKDVW7YjZLzJDASU0yn5Q2abqKtTY1zGXYLR7/WmDih7Rvjtcz2GdIO2myH4CIYxv+50dxWbvzcUTXFSp/5shaIkzIfoA9tJWKlHuWxwH93fSdPU2Ir47ctjS7IlWcaR71UuWehQhkbiZ/qPdXu63ncYGL/snoDse2LwcdS1jZatzysM5WBb70hU1watS1WHRKJLMFb6AMkMDVDMfJdogfVcCJDD6HBFQv9qXrpaZN6ukziJmHP4k2mu6qO3KaW9uII=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fffcbc3d-d6b5-4c81-90c3-08d7f132d9dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 20:28:20.1004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L+ejT2aROeyRCw92keY5pu16gZO7MA5i4KMp6LooVeFX37Ip8BHzISC4CI6B23eEy6uJck0bKMALOHHJpXY6Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6349
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Sent: Tuesday, May 5, 2020 3:14 PM
> To: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Youri Querry <youri.querry_1@nxp.com>; Leo Li <leoyang.li@nxp.com>;
> Ioana Ciornei <ioana.ciornei@nxp.com>
> Subject: [PATCH net] soc: fsl: dpio: properly compute the consumer index
>=20
> Mask the consumer index before using it. Without this, we would be writin=
g
> frame descriptors beyond the ring size supported by the QBMAN block.
>=20
> Fixes: 3b2abda7d28c ("soc: fsl: dpio: Replace QMAN array mode with ring
> mode enqueue")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

If you would like it go through net tree.

Acked-by: Li Yang <leoyang.li@nxp.com>

> ---
>=20
> I am sending this fix through the net tree since the bug manifests itself=
 only
> on net-next and not the soc trees. This way it would be easier to integra=
te
> this sooner rather than later.

Since the description of the patch says it fixes a patch included from soc =
tree, it is not very clear why this problem only exists on net-next.

>=20
>  drivers/soc/fsl/dpio/qbman-portal.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/soc/fsl/dpio/qbman-portal.c
> b/drivers/soc/fsl/dpio/qbman-portal.c
> index 804b8ba9bf5c..23a1377971f4 100644
> --- a/drivers/soc/fsl/dpio/qbman-portal.c
> +++ b/drivers/soc/fsl/dpio/qbman-portal.c
> @@ -669,6 +669,7 @@ int qbman_swp_enqueue_multiple_direct(struct
> qbman_swp *s,
>  		eqcr_ci =3D s->eqcr.ci;
>  		p =3D s->addr_cena + QBMAN_CENA_SWP_EQCR_CI;
>  		s->eqcr.ci =3D qbman_read_register(s,
> QBMAN_CINH_SWP_EQCR_CI);
> +		s->eqcr.ci &=3D full_mask;
>=20
>  		s->eqcr.available =3D qm_cyc_diff(s->eqcr.pi_ring_size,
>  					eqcr_ci, s->eqcr.ci);
> --
> 2.17.1

