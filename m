Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D2E30BE41
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhBBMdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:33:35 -0500
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:7341
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229590AbhBBMda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 07:33:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiRnTiZvAE8ju2VBZKZV+0vtVweQ5i2oI4zQ3itmAqEFHnGOD/GNrs/XXd/hXkjNPPCjQJfTsL6HK6tfDVnYU4SMzz/zuzIkEATRH0ka7fWGhFuA6pe+HTO0vMkJdxvKEKhelC7pweVWf4M6ekt48eA3piU3pAfsblS7FNpMV5HPPqX/P8olC5gMW29qPI5DY4gVgzo3bvwmiU55WdBEitPuJRI2UNDdltYpkgZaFLt9TXK15nkSUm+/+FXnJBAASJl01mP2+F2T09bvksNvlu1fF101SPcZOVibzlq0VV9d0H/y4BGMHjnJoSGjMSZmNpBHVH+OWXfJ++aRIGSbBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JiWQ++WYG8p7zn2MRjt2jOhBDkUWwoyerKSZhfqnTI=;
 b=HaZ5xGCj27gcF1GSstRLTwwX6+7TbnxIo+7jyyp02Jc2Zlo3e8wTuRCx8SWdkat5Yq9SbZy6MwYpIcUyMtJVt0dyH4TrDA/i43yS4z4qE/cmPnm1M4auk2J6j6zs+XwqAIHQf115bdk4KdgF78/BwHBToC1Sn4Z5o/LYHiHlGk0PuK0ApnB4fox2EgMQ/3cpCDR49aF7TlWnT8lAPL+nxPyZwNQH2rvjyQr4a6culhEJLEXBHladOoiNEf8ac4FELKfktFH/e39Mk4x7dp+tIlXIm4XPDLZmMjOc44UXvnc5k/wfuh+aZGpE2MfoDoTu4hxyNZYGeGt6qV0r19PVCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JiWQ++WYG8p7zn2MRjt2jOhBDkUWwoyerKSZhfqnTI=;
 b=QndMugf1WemSEgu2mqDvFI5il7h97F2h/zvaTWYwj5x8PO6Hpw5wEbXI4sOhEpOpWsx4P0XufDAsdbwQ43dsrT8U9QmSYs5LOl50LORpbItwW29MgCJK2Ivhjgw9bSV579N/x1IA4maxjyfis4XZNAECfGZYJEgQyeHOnUFtb4Y=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB6445.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 2 Feb
 2021 12:32:41 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 12:32:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Kevin Hao <haokexin@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH net-next v2 4/4] net: dpaa2: Use napi_alloc_frag_align()
 to avoid the memory waste
Thread-Topic: [PATCH net-next v2 4/4] net: dpaa2: Use napi_alloc_frag_align()
 to avoid the memory waste
Thread-Index: AQHW96ZuDf172hJVTUufbJCeWoSfn6pEz7AA
Date:   Tue, 2 Feb 2021 12:32:41 +0000
Message-ID: <20210202123240.rfgbky3mzhefbamz@skbuf>
References: <20210131074426.44154-1-haokexin@gmail.com>
 <20210131074426.44154-5-haokexin@gmail.com>
In-Reply-To: <20210131074426.44154-5-haokexin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29807636-2db2-4bda-9163-08d8c776a233
x-ms-traffictypediagnostic: VE1PR04MB6445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB64459DA92A6E580DECD73305E0B59@VE1PR04MB6445.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z5qNhUfMnMAyaYldREaeWJbYCOyPT3Po5ul2YNKQSDwSSu4YpjXLSf7x4bbhM33NAPf5tMi0tNYPQlKhzlizv6iIr0qsIjtzW3jSfsv+O7ChvtQTWk0KSdE1N5dQTUCypQjItNqBFJrzxYo/TIqRdvf/IqxW7mP3ujSmBexF3wBWjJrKtHgCPUyw1Qzti41lsD/koUw4ebMQhtDM7xFBsccOmZedYTejhRJEGhMgpQVVh6Fok9PM3eUum/HVBaayKLzgQSGVZZJavUTVRDRIgx3zUsvgCHoAep0fif7++z0fM61D1btteXrwfZ9RgE8D1ZX+5AGxH6GjVzbWldIi0SGV2jZR50SF3NEU4ccBV2HJHM0/m2R7rt4rLSBFkqpDBmyQLdG5IUURcgotWHtkKs9y6X5HZ0OGFeCqlsPfns0UFLYip75oeHNqNdJvUKeSbF2a70GhBnSglLj4d4fSRh4oLzwQrUVJamCb34HEHPb8uGrgGHEnEWytm5hes/7sFS7D/6JMoFozfuAlhdNNrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(6506007)(8936002)(6512007)(9686003)(2906002)(1076003)(91956017)(316002)(6486002)(76116006)(26005)(8676002)(54906003)(44832011)(86362001)(478600001)(186003)(33716001)(6916009)(66556008)(66476007)(66446008)(64756008)(83380400001)(5660300002)(66946007)(71200400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?C6TLFPttAD8C6UXcoydpBqcatSsF+JvchzuGWXLDGEMEiha6WjVtL0QyFPiB?=
 =?us-ascii?Q?HX2zxcze9r2G2OPm6Y3L23AvzKTKhzgNKCjXEN2siRvw9sHec0HBEc+1pW5W?=
 =?us-ascii?Q?w30riwHxwCOQBa4Cdqhf03dQPZcBZsZ5aukdmd3w3ZL3phpYoZaIU0K9HH5Q?=
 =?us-ascii?Q?NkZ6CAcV7KuEFitajjv5pN9Xie/2iMTVsdXRj2ggrd/6UqT2FNNCBirCZkfZ?=
 =?us-ascii?Q?mV78IGpxMWxLFq1dgLt4lcEgnGkEB5E3wIgktDCEiaSjRx7zMorlsDC15umI?=
 =?us-ascii?Q?DP1mibq05/n+PsdacnTCeEV62ogxyKh/HZT0FjB/wkp7PUKCwKciicAbaA+y?=
 =?us-ascii?Q?si5mr2KznaM4X1+aoJHBeMyw3xb3O8OYBNOhkIZjJW/YcNbcOsWfJo2Vg3he?=
 =?us-ascii?Q?3KZvP2nt25ApdhppPzgfuzsyEl/wica4vPDXjWo1uGi8EJ55rAes+48v8HH6?=
 =?us-ascii?Q?Xk61+4yv+e1n9R/7jb1gkvSAL6JQ+5mErxFvyArSyDK/pkG0Q7Vlf4NmliwX?=
 =?us-ascii?Q?CbrAY14IHrG/tCD1yW/Nq7eRDQ+j/I4wPv4UMGOaT7xV0GFkwIdNYGFGhC/A?=
 =?us-ascii?Q?MOcJZIT9/vogxzlhDjxWDJVSSBkb63GwKZgr4uJRiugmMHHJUM78BD6IVGOB?=
 =?us-ascii?Q?iqBXwXg0Yb74WdoIPYdJrDqPuW592sfHOXFDkS+wi+CnvLGZ1rG6IubO5/hf?=
 =?us-ascii?Q?B4FJdNu6SOA1Am1K/R6GfTk8xbtmTIdriYYaaVxcPBGG4BYUt7+sMN/B8mvz?=
 =?us-ascii?Q?EqvlbxMohXwS/Jm+svhk0oj1jM/yI+CgSOgtlq/k6FYMcnVpD8uXe7QUcMKC?=
 =?us-ascii?Q?pTjidukzpQh6WnhMDQOl74hzaKkkFVNypWcjzPlQe5dB2uy6c6Y/i9R14rLV?=
 =?us-ascii?Q?H6UcbkA1LCTpqdx5u5DkYnpMhe0jD2ry+e+gMLJQ7vjAo3Gw72GuNgZkPgIf?=
 =?us-ascii?Q?YvbdOIcesIW1hnSCt2EEVG7VVWyXtYSq9tSBns1RxuTPyw1gNIfKnpTR/yD/?=
 =?us-ascii?Q?IlL0YGqM8WvyMWaq2M13mFBKNqeekvAC14p52jVv2JIZRRPm17wrUTOt2ayQ?=
 =?us-ascii?Q?9Il4JAVH?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C13E44D1BCEDF4EBE2738E026414E89@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29807636-2db2-4bda-9163-08d8c776a233
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 12:32:41.2802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByftM4ni0siKIDiOuaJFrfOn57/apTiU+fTODoXtbC18fxex7E5+p0Fsax+I4cwQnTK+McjOptZFUQW0MAF22w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 03:44:26PM +0800, Kevin Hao wrote:
> The napi_alloc_frag_align() will guarantee that a correctly align
> buffer address is returned. So use this function to simplify the buffer
> alloc and avoid the unnecessary memory waste.
>=20
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

> ---
> v2: No change.
>=20
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 41e225baf571..882b32a04f5e 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -764,12 +764,11 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_p=
riv *priv,
>  	/* Prepare the HW SGT structure */
>  	sgt_buf_size =3D priv->tx_data_offset +
>  		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
> -	sgt_buf =3D napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
> +	sgt_buf =3D napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN)=
;
>  	if (unlikely(!sgt_buf)) {
>  		err =3D -ENOMEM;
>  		goto sgt_buf_alloc_failed;
>  	}
> -	sgt_buf =3D PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
>  	memset(sgt_buf, 0, sgt_buf_size);
> =20
>  	sgt =3D (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
> --=20
> 2.29.2
> =
