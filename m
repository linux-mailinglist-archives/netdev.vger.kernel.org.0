Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F5848D735
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiAMMJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:09:45 -0500
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:33761
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230310AbiAMMJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 07:09:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POfScaA5NQrWKCHFENOuDwYNNFQXoJGzGQ7HUnNExw7Rf7u/W/3uLQyXme0iIg3OkCWaN1hMtoVzMJu3i/4PROxWIf637Nt/+EEM2SjOsaje9YBQDYqSTdbkm8aZDMT9o+xfSx/3N4YWHkhPvuDGw16t6b1nQq1apMf1IEPDACZZJ33G5XmExruxlQ6Fq3lu+7rXic+gyHRBSK8TTcp5p8UbN/Wp5rTtPlbxfiijTX9Rtkok/iuA/wEIbHUQbAD5IVoXlqrIZjozlyqMha4OtkXwW8uhPqYY0+fDkwXzXzco/I78s64yFstA0BFFdfQoZV0RwLygnXSPIRiiEGVxFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTIpCoD8uFYyRAf0jA1+Or5KhV8vIzbII5hwppPARm0=;
 b=kHKjUFq8V+6fmZ8HYVAChGoUridnsF0tRMpWLsidkrCs37q6TufaGFcaomYdt2A7eJmJ55xFTo+uZKwCfQbLPHQCAIaNSUZt5CmLhlb3eg9hvren+0kuuYh8QSxA5N1q2xjFFcsm/ysSkz2DkyIRirpOS8kTabgOACA7At2bV60sPa2S6MH0dZh/N56UH4Ew8xllyK2SPYhXJjw4SpnpOjG51vXAzqLFzLFuEFzdC5M/QMqbHQEZ+t15RRPYU7h5yu3f3U6LL1beE4h0IxMwNhfrDPx2RAj2nyUgMWAI76RbGFMWRTFXevzWaYUNE8VFHt/CsH4xUQHFKu1lY052Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTIpCoD8uFYyRAf0jA1+Or5KhV8vIzbII5hwppPARm0=;
 b=d3FHN8O3Rv6hS2TCVz1Bs4x2lpLlE/LELlKzUAYQIcsSWC/Aq1znkOhCEIEd3AdMPia7qiLkFiG34ONeg0F2Nx642cjjtQNtPE1qSHjYexIMAeks2ZY8Xo+8OuDWY3aB+ouE8spepFUrXbXeqZAdp+B0VMMOsG6cXaB7samLif4=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 12:09:41 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::7cc2:82b0:9409:7b05]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::7cc2:82b0:9409:7b05%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 12:09:41 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michals@xilinx.com>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: RE: [PATCH net v2 4/9] net: axienet: add missing memory barriers
Thread-Topic: [PATCH net v2 4/9] net: axienet: add missing memory barriers
Thread-Index: AQHYB9s1HGFEGbndkE6qA46b1PiAL6xg22yw
Date:   Thu, 13 Jan 2022 12:09:41 +0000
Message-ID: <SA1PR02MB85604DE700BA8511C604B632C7539@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
 <20220112173700.873002-5-robert.hancock@calian.com>
In-Reply-To: <20220112173700.873002-5-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13b5a34b-f85e-49c7-05ef-08d9d68d9437
x-ms-traffictypediagnostic: SA1PR02MB8560:EE_
x-microsoft-antispam-prvs: <SA1PR02MB8560A6E014D907109B7A4F56C7539@SA1PR02MB8560.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WUGgHOBU5hLR7j8W4s87bEvR/MDPubx48GlQ64AryBflGf2RlUz/+aKx+820m4xcJFW8RDeAKek0EG3ENqQ3enOPbHvJXCdpGdDek4fPDQzDb5xq6fAhehceH7MObn/bW1QIBKqNJjwKofGh8AlEHieDo6QBZYiipKC7GEmaITr0XhAznjMRI3hoyexumy666o7UcBLyWQyPamPV8h1V0p15vDqPCk8cb41NiP0RY+Gkhya0UjJS8qEdRdcOxPpWnyA57Ty3i3O+NZDTfTR8f6CWHBQj7Ijx0/CfBe6TU1ZnKcFsXgS3qv1r0SjcIVGhO5ZJcpQq8Oe9rtzK9SFWZfS99vq3Gs3kWGx61bpO+aKSrK4J46pq4iGqM72zKYotJyuEfcoM6jQiAsdKjBzhTeM1H2ztKKgH5UsNNiROnQNIyS04zWHq/chV6t2jzD/6b1p2Iozju8kVW6ekhS4rB6eTFC/xTm6XrD+rgawsCpPx2yUI9CJbLTT4TnqSPLm+tVFRJ+snLkWJE9dM1JQradPqsapVYvuqaKjk6odxBLR52DGGrVlszL4bJ+BmPqKNaT5aDY9NHMpH3ntYUPmkAYQd1FF4ksF6ngd3trkYOM3ohyPBSXa/nLg48jN91gnj02Y+3yVVUOkH4XbbLXkxW74MOIDXiwKQ/95zqtX11tEZRetUfVu2iTOsh98tGgM5bMZri5auYwcQt6gK9fYDLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(71200400001)(4326008)(55016003)(8936002)(7696005)(38070700005)(122000001)(38100700002)(508600001)(5660300002)(8676002)(83380400001)(66556008)(66946007)(66476007)(6506007)(53546011)(186003)(26005)(33656002)(110136005)(54906003)(64756008)(66446008)(52536014)(316002)(76116006)(2906002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WaTOeRemygWVPHEofxdZ5NwDYe613vdIqSeep5JB23Wr9D3ucOFxAzdVXC9v?=
 =?us-ascii?Q?oq1KDpyyEyoNK5aU//Splerxyh1ab0ypZrFbG05LI3bh3GC6a1uB2OoNySPQ?=
 =?us-ascii?Q?RSCIf3uRSZjzJlG28QyWKuYAgtZCq4upPPA4qx3OGV2K5PcTnN/yBHYux8wo?=
 =?us-ascii?Q?C30gdpMgzVEpq89lfZNu03QTXo7Bla+Nj2m7Q3DhvxRFpTBfskvX+Q1vtVJb?=
 =?us-ascii?Q?5V2yA9UvAzmPInm3IOlaDMIByaoScOC7nKFLgOV3tf1JAl2SMNCdRWnz3Ves?=
 =?us-ascii?Q?F1aospnc3Z7rPLVcikoy+KqBoZBTLElHZAQp66CGpT1c7/gI1ZMsmDDKQEBD?=
 =?us-ascii?Q?J0sU7fzl9o/umSdTWX+VJerDklucBYUXsf3K2BqiTYgDtEzQkQcSll50eeE1?=
 =?us-ascii?Q?AbbfV907/g+mtIsh5zcyFYJsd2LXir68EhOQDgMrO+eXjvu/4l0Abv7M4sn6?=
 =?us-ascii?Q?6Qzk6rocLRmL87YmnOzg+tkjr36zlJ/8GDFfxRh2w1ntKI334dRqfYklfHVG?=
 =?us-ascii?Q?h+jQ6nte/kyiuJ4I+PuZutKBSDxlQpXRXUeMMvgedqlSAhGE/sqwGlklt0ss?=
 =?us-ascii?Q?3gd3BTO/zbu/sDJILSZCu6jbLw2/u+eW/TlrSUsOXWjcy5oZiqDjMqHuFe27?=
 =?us-ascii?Q?iCTI6vtcdLIuVGHhjeP7svT14mSPx8LJR99VLI6dKyt52vuMp9xaK2BLSOPA?=
 =?us-ascii?Q?es0ut7NerAV/NXg2/6qWy3VFnIGVGFXluWzqagyez6YK8zfwPBeiAdUXTYKy?=
 =?us-ascii?Q?NnSgp4BDph1a9TqNSiNsYuJnuYKEqEdXdnZJ2tBxxhaYS0eL/AGctKjgjHIN?=
 =?us-ascii?Q?OnmZekmgF0C5QW58K96kCIRUQl3AGHS2tDjyNtKmZ9ocRrpyfjWjXZm2cgby?=
 =?us-ascii?Q?HLMQ9pnSpHFJuMG/EeIhgLkg25+4IFw+xR2/bjoOtZ3CnXbywIw6vfQItHQQ?=
 =?us-ascii?Q?rHOdzopq8JagOhgdQSIzujBnUk0JE7zxlb8Dsy/+iK7bpi16FhK+PlNEGeX0?=
 =?us-ascii?Q?/Fa/Snu/S3mNvDRW+sVo57pyJ0alGS0xv57O29otqLs9stKSHl5HUqXZD6et?=
 =?us-ascii?Q?Cos/V3SRBen8voRinohgYrmNpT/oJ1xCdsKmLLmqCc/mM9ywuRzWsBZQBs4k?=
 =?us-ascii?Q?PONzg3USIRohh2bpxLTlfGW+QSaPSmpfU1UAN0yLaB/kaoxHVOP7Oh21Di6/?=
 =?us-ascii?Q?CukQcQpOthmSDEh7Yyy7+Z92fGpgLSD3+KNChuqTe3hDtQNkLessZfxwKuLb?=
 =?us-ascii?Q?coUrLrANWTgUR2XVSDpxmf0ehU2+nyiUhj/2O7t0i3qUloHvIkzG9gVTAt9p?=
 =?us-ascii?Q?Plr3a8mnpi2UfAHSgrhw+b1g3YtEIGNhQqrvOq94V9D4m4xJ/4hW1SWQKYFM?=
 =?us-ascii?Q?TsrG2EOGHaccDarWT5b/K+P/em49CIhmsoey915r7623QyqimwFuAphzxaDU?=
 =?us-ascii?Q?vmMgzCyzO2WYCBOnzl7f59QZTQpZTRa/Sd0grcgHa2OxL0pKYASaksL0hBUq?=
 =?us-ascii?Q?Lq2KKuXRzmnNnmD9lnBXroOgx4Nv/cZl0Qla3Elv4kBlQCP73LR8YfFGUrAq?=
 =?us-ascii?Q?6SEdzoJ42ER0oqKDQ1RrbzQT2R0kyrtjVtuzUfaR6Os/vWQdYHoPDrqgcsk8?=
 =?us-ascii?Q?u8GJ9lxhE6EMH5xsZkSimD0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b5a34b-f85e-49c7-05ef-08d9d68d9437
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 12:09:41.3908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t7sH2V3K6m8s8IMy6ZNl2wYknk3PSLdMl0pjl1uLnL7UWCnj1jV6577/z5EiwW8dyhAPmdPfehJsdAXmwrM/fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Wednesday, January 12, 2022 11:07 PM
> To: netdev@vger.kernel.org
> Cc: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org; linux-arm-kernel@lists.infradead.org; Michal Simek
> <michals@xilinx.com>; ariane.keller@tik.ee.ethz.ch; daniel@iogearbox.net;
> Robert Hancock <robert.hancock@calian.com>
> Subject: [PATCH net v2 4/9] net: axienet: add missing memory barriers
>=20
> This driver was missing some required memory barriers:
>=20
> Use dma_rmb to ensure we see all updates to the descriptor after we see t=
hat
> an entry has been completed.
>=20
> Use wmb and rmb to avoid stale descriptor status between the TX path and =
TX
> complete IRQ path.
>=20
> Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethe=
rnet
> driver")
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index f4ae035bed35..de8f85175a6c 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -632,6 +632,8 @@ static int axienet_free_tx_chain(struct net_device
> *ndev, u32 first_bd,
>  		if (nr_bds =3D=3D -1 && !(status &
> XAXIDMA_BD_STS_COMPLETE_MASK))
>  			break;
>=20
> +		/* Ensure we see complete descriptor update */
> +		dma_rmb();
>  		phys =3D desc_get_phys_addr(lp, cur_p);
>  		dma_unmap_single(ndev->dev.parent, phys,
>  				 (cur_p->cntrl &
> XAXIDMA_BD_CTRL_LENGTH_MASK), @@ -645,8 +647,10 @@ static int
> axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
>  		cur_p->app1 =3D 0;
>  		cur_p->app2 =3D 0;
>  		cur_p->app4 =3D 0;
> -		cur_p->status =3D 0;
>  		cur_p->skb =3D NULL;
> +		/* ensure our transmit path and device don't prematurely see
> status cleared */
> +		wmb();
> +		cur_p->status =3D 0;

Any reason for moving status initialization down?

>=20
>  		if (sizep)
>  			*sizep +=3D status &
> XAXIDMA_BD_STS_ACTUAL_LEN_MASK; @@ -704,6 +708,9 @@ static inline
> int axienet_check_tx_bd_space(struct axienet_local *lp,
>  					    int num_frag)
>  {
>  	struct axidma_bd *cur_p;
> +
> +	/* Ensure we see all descriptor updates from device or TX IRQ path */
> +	rmb();
>  	cur_p =3D &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
>  	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
>  		return NETDEV_TX_BUSY;
> @@ -843,6 +850,8 @@ static void axienet_recv(struct net_device *ndev)
>=20
>  		tail_p =3D lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
>=20
> +		/* Ensure we see complete descriptor update */
> +		dma_rmb();
>  		phys =3D desc_get_phys_addr(lp, cur_p);
>  		dma_unmap_single(ndev->dev.parent, phys, lp-
> >max_frm_size,
>  				 DMA_FROM_DEVICE);

Ideally we would also need a write barrier in xmit function just before=20
updating tail descriptor.

> --
> 2.31.1

