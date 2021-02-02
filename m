Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7B830BD45
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 12:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhBBLhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 06:37:12 -0500
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:37792
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231273AbhBBLhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 06:37:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZChoQF6FeRPSytuGPWEjp58O2L2csjVUh02vQS9DHbeHC0KGWGE2E91TAkN/23jjPTCwIzezLzFU2tjf4HXMvUSPCI+Ka7hEHMFQRF4JMLGFQXbLg3viDacnueuQpLEMromm69rsDojSxXKI7D/WrOAMqzJdBbOM7eItASlVbEd9qz7ngFgu2rLt6H46eSwO7QT3VmYyRROBrsqdv7XvOEF2suf4n38lRIdfB+Ojp5E9SVycPghbm7wvRHnelBsp1FP+Ul84YRN2KES6ou80vX0STc201XAo0yBDekTfUNtStQg+3HwMVNBalfyesTEMScM4PMxSiOplcNx2JO5vdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etySm5dYg/JWgIdpzEaB6YKP6NxSBVmJ557kYnlZ7nM=;
 b=RVCvdD4UfAmHOFzFSKTvzpNYFvrwm3XQ4ZhBx1VYUwpKOMw9Z9qKjZ4T/wdelgfBZ39P1ujIX8SPdUMuEoWdR7iQn5P6fM8AoFchjDcimxh3pg2BINKUSqH0/GiZAqs5xpzj7oI9J8GERRmg3O+h/C5LR01ZZpP3mbg7T2sjzhVC96sUm8G2IV0yyZup63hlY/79v8xUCRrX2KaV/LN+RSLJ2THqSk0xL7lyWlwA3DLPInF3LhuchKJDS3bhCIL6ElzCEeUdqo2iFY8tI0+zPwlHT305wUomA4MtWCQfll8vb1lFk2AY85ANXB4upNmdo1/B2tQB2yJ2ZK+IoTHHoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etySm5dYg/JWgIdpzEaB6YKP6NxSBVmJ557kYnlZ7nM=;
 b=n10EwePldBGcyH+yWRnHlTwiDLw4/4NUJbeV+Q6vWWwMjk8bJReag7jlZPHd/6fsDoSG0Vs3gRpsA6dbmM0DW2+gMTETgcCD50vXfpt1v6Mf+5YPM3dp2HQbmO5xorQVPa+Padv9yGH9j5MNFo6X/NHSIR8p5TRKvOqubHp4Co4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2944.eurprd04.prod.outlook.com
 (2603:10a6:800:ad::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 11:36:19 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 11:36:19 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Kevin Hao <haokexin@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v2 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
Thread-Topic: [PATCH net-next v2 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
Thread-Index: AQHW96aigj98D9qGVUCzC1fhplt6KapEv/AA
Date:   Tue, 2 Feb 2021 11:36:18 +0000
Message-ID: <20210202113618.s4tz2q7ysbnecgsl@skbuf>
References: <20210131074426.44154-1-haokexin@gmail.com>
 <20210131074426.44154-2-haokexin@gmail.com>
In-Reply-To: <20210131074426.44154-2-haokexin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cba04e5a-4d0a-4b38-a7cc-08d8c76ec27b
x-ms-traffictypediagnostic: VI1PR0402MB2944:
x-microsoft-antispam-prvs: <VI1PR0402MB29442B5C13EEC339136295F5E0B59@VI1PR0402MB2944.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mS0OQLafqIfoypF5Ec2obwliAQKdwDDrJ9k25mFZuO6Vp83Hbi7vHwLO3pbcmcvJdvKLtExtQk06KCaJig2YuX1I1ZmzfojAt+s2jl3H8P4zE8TYUIPaJMZDcjMN4mRVmhO+S/cCUXA1X0CeLemdNIyFk40Re3JX09LTCH4PvTFl6AKRNcnYq17DwDgj4NF7tIkOsvE4nkBOnQLxwWvUfoEPMQ9/VMqCny8pHbHnvpol17d7UN/OqRUdWkg+CrjQ6qYD8XF1PYCbXT0sZ1b8/wjd0lCuEbUPnAUgQv52dHNMIeM6WRodPj5OlrVOqfIXbvrloAL/pVVOp6wutV9FVPLWkIzd+MlUBFuGDj8fXsst1/pK3MA0FP3FrnSkccLXU6lu1sTZBv+xDn4cKHQxoFgNnHpw4kfWQA0DGbBy0pUUvGqXjV0Tyo9liLfNFxc8Avva2yjN0OhWUsE1p5nxAonaHwywGERdyHXbKLFtFglif0ShpfPsvp9ie1pUWfMaJ0rgL7ZYcnzp0hy6jTO/4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(6916009)(2906002)(86362001)(5660300002)(1076003)(76116006)(186003)(478600001)(6506007)(26005)(66556008)(4326008)(8676002)(66946007)(66446008)(44832011)(91956017)(66476007)(64756008)(33716001)(9686003)(316002)(71200400001)(8936002)(54906003)(83380400001)(6512007)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?osOty6UVrtWnzyskXujIp5zbwLdfHMAJ30M/95acOLPKCcBvl33m3u82w5G1?=
 =?us-ascii?Q?dKPNZ0P5iJfPwpDsZe0Kx0h0OoVKoZ7paHbLBcBEnS7MzIlk/2APJRnIjK+J?=
 =?us-ascii?Q?LvueQ6gZPHv4iG90gFRXmzq4ROzBtAyNvvrqmsQuebSwvUXT9e04On4q5IUW?=
 =?us-ascii?Q?YZNSl0WwZPVRfU9W0zLmmOaZ48KMTDN06BdTywmV+eaAq85Tq21hVaKpRt1U?=
 =?us-ascii?Q?eImRbOLrYZqpbsZhbFpKwKywHQMKrkLHZEIlaQJTha3nqcXbl3rBNSlsAVI0?=
 =?us-ascii?Q?JSVdJbHtdgTps0OTV7gyo/ZXhmOiIssB9JErU/h/5XACyAED2fXO2rRY/TRq?=
 =?us-ascii?Q?4e4Vg/jruYxVarsiTRm5zlvzpN3V2KgPnOOEydn1Kl0zJM7fWpuW/6z3KRDm?=
 =?us-ascii?Q?E5zT0LD41o6hDjux12W8hLkD4WucK4mFlp/enqhv1O+1qEnFhp3N9ktxozwv?=
 =?us-ascii?Q?IOMqL6v8dr9SoN7norWAiENHJ/JVwcLi5+8TQ5pnzpk0COwoDGh77bNLj56F?=
 =?us-ascii?Q?x8y3wXCYBP6bWM5iYfXemN+t4zQCjcVL9ptk1ljEgGt7w1HJF/WINNBkWCJv?=
 =?us-ascii?Q?wWWq79jFWkiuyCXMHocuRJWnJJtS4dNzlWXjpV4ccUDoyTZ9lIMnmcrwtLUt?=
 =?us-ascii?Q?3eWFNqF/oagWgi2ohMbw1Nmc/Xy0zie7QaA1z1hCyszlr6pLDAyX0RjvgfYA?=
 =?us-ascii?Q?9HXCr0ZbcHCN3Ri7ubQbxYuM94g7Ms8AVLhpnqBc+XpuBShG7NcBQl2q3YqL?=
 =?us-ascii?Q?WbBzxw4C7nNsurGytUv8DEXf23tbZ/zI38isnCHkvE1Jk+9KsDl+5CtRgG3y?=
 =?us-ascii?Q?zCXSuK2MYHF+CIKiEU9gqtlSaHI44cIsuJYXMiLmkY15BPE1RNkHeQp4C2kr?=
 =?us-ascii?Q?KdT1/GPmMUdpaSfWnorVN6B2A9aY3i+m32rlNyy5rb3RwfsP640qrao1+B5p?=
 =?us-ascii?Q?t7UO9ixEu/e/RK6gmI0xrjrjjclSQgDqZVxVA73kt5pwoSynyW9r3inzIooh?=
 =?us-ascii?Q?IYns4MWfWno5WeGluDxDLQwQhpCWoZgsZvfbyprWg5JdbGUXZjy1q38kamJ0?=
 =?us-ascii?Q?37FRF9N/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C52BDF13477C8B449E8FA94B922989C7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba04e5a-4d0a-4b38-a7cc-08d8c76ec27b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 11:36:19.4789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVLQnDUOIr2xe0Orq/fiwdCul0OdL62sDLkT92d+G9itwMVAh25AP7tCfSf5r0WNXDIzXnyp41k7G4hsIPNVKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 03:44:23PM +0800, Kevin Hao wrote:
> In the current implementation of page_frag_alloc(), it doesn't have
> any align guarantee for the returned buffer address. But for some
> hardwares they do require the DMA buffer to be aligned correctly,
> so we would have to use some workarounds like below if the buffers
> allocated by the page_frag_alloc() are used by these hardwares for
> DMA.
>     buf =3D page_frag_alloc(really_needed_size + align);
>     buf =3D PTR_ALIGN(buf, align);
>=20
> These codes seems ugly and would waste a lot of memories if the buffers
> are used in a network driver for the TX/RX.

Isn't the memory wasted even with this change?

I am not familiar with the frag allocator so I might be missing
something, but from what I understood each page_frag_cache keeps only
the offset inside the current page being allocated, offset which you
ALIGN_DOWN() to match the alignment requirement. I don't see how that
memory between the non-aligned and aligned offset is going to be used
again before the entire page is freed.

> So introduce
> page_frag_alloc_align() to make sure that an aligned buffer address is
> returned.
>=20
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> v2:=20
>   - Inline page_frag_alloc()
>   - Adopt Vlastimil's suggestion and add his Acked-by
> =20
>  include/linux/gfp.h | 12 ++++++++++--
>  mm/page_alloc.c     |  8 +++++---
>  2 files changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 6e479e9c48ce..39f4b3070d09 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -583,8 +583,16 @@ extern void free_pages(unsigned long addr, unsigned =
int order);
> =20
>  struct page_frag_cache;
>  extern void __page_frag_cache_drain(struct page *page, unsigned int coun=
t);
> -extern void *page_frag_alloc(struct page_frag_cache *nc,
> -			     unsigned int fragsz, gfp_t gfp_mask);
> +extern void *page_frag_alloc_align(struct page_frag_cache *nc,
> +				   unsigned int fragsz, gfp_t gfp_mask,
> +				   int align);
> +
> +static inline void *page_frag_alloc(struct page_frag_cache *nc,
> +			     unsigned int fragsz, gfp_t gfp_mask)
> +{
> +	return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
> +}
> +
>  extern void page_frag_free(void *addr);
> =20
>  #define __free_page(page) __free_pages((page), 0)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 519a60d5b6f7..4667e7b6993b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5137,8 +5137,8 @@ void __page_frag_cache_drain(struct page *page, uns=
igned int count)
>  }
>  EXPORT_SYMBOL(__page_frag_cache_drain);
> =20
> -void *page_frag_alloc(struct page_frag_cache *nc,
> -		      unsigned int fragsz, gfp_t gfp_mask)
> +void *page_frag_alloc_align(struct page_frag_cache *nc,
> +		      unsigned int fragsz, gfp_t gfp_mask, int align)
>  {
>  	unsigned int size =3D PAGE_SIZE;
>  	struct page *page;
> @@ -5190,11 +5190,13 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>  	}
> =20
>  	nc->pagecnt_bias--;
> +	if (align)
> +		offset =3D ALIGN_DOWN(offset, align);
>  	nc->offset =3D offset;
> =20
>  	return nc->va + offset;
>  }
> -EXPORT_SYMBOL(page_frag_alloc);
> +EXPORT_SYMBOL(page_frag_alloc_align);
> =20
>  /*
>   * Frees a page fragment allocated out of either a compound or order 0 p=
age.
> --=20
> 2.29.2
> =
