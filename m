Return-Path: <netdev+bounces-6468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 231E871663B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:09:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBDBD2810E1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EA4271FB;
	Tue, 30 May 2023 15:08:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A331117AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:08:20 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E0311B;
	Tue, 30 May 2023 08:07:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d247a023aso3314908b3a.2;
        Tue, 30 May 2023 08:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685459250; x=1688051250;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=90qsX+BXhNStrskWzkrpuNl5PQEloie9F+kBEZPHuCs=;
        b=j4GfH0/PuF5dQJVh6Ihur7bB6XH/WiiSoIaUXiM4/gBzCMxoPeQh/eeOjnFY+fufRP
         ljK6fFM9FFNmoSbj6Bl/wDg7eE/mqVTxmms9OQR/7Zv+E6Lxm7m3fFvQZJiJ/0XoN3FR
         PCM6LYn47vNASMnR0GYElqmeN1BuYde+9H8H0waUqWN6PrkEbYfRir4IhTNKjdotksQn
         rw0LA0i4I0A7xKRJKLG/l2fh+gcReCBCXu0Efx2tXYMdNYt0/de2fXOHdS/nhHDTHXMu
         Qiw0OAFelu7c1Kn9UoEAYbSOqPrm4YRKREgvWZloiw+fZnlsuIKmoAyv0xPP4OCxsF06
         ACpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685459250; x=1688051250;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=90qsX+BXhNStrskWzkrpuNl5PQEloie9F+kBEZPHuCs=;
        b=UszlJ6DgblPFFw47WH8Mfe/3dz7Zl4qfB8rfhuLj54TS65V4LRqxoPnFTL56HBo/YH
         9hSzRkAh5D6kGkTSNxFxVK9R1+abBrZJPLcfaxechj7qgbtyPzSaf7rp2B3+MuYKz/fL
         IJJxgErden6QQA35mgmqDQ96n6iJeDkic28AvLMLfRS7PPOcINLmdquAvtnEzX02fbS4
         MelDoow7iutqNrkZm0lGMoJUyqtpurDVjfTz/AyE1bgnv6bEkogl9/Ly4Mx5RjscwpFV
         3NFIXfV3lT57vS9azK3/AoCA/UtaIUkVAWJN9HwRy7VLLnXfB6ow+8Chn98OCA1aKjqT
         YIjw==
X-Gm-Message-State: AC+VfDwhJGnJ8Ep5TOZgfEfBGeyukZ+fLvOZ69bB3TZMjRjHwvyuCurw
	tL5MQVO+tzTjAb8blP29nYE=
X-Google-Smtp-Source: ACHHUZ7hoTMjXkxSfzArgiEDlv0vTd070PUvxyvePERtHaXAgLushJfaxAEyPByxNT5mpqlfITBp7Q==
X-Received: by 2002:a05:6a00:1491:b0:62a:4503:53ba with SMTP id v17-20020a056a00149100b0062a450353bamr3187328pfu.26.1685459249701;
        Tue, 30 May 2023 08:07:29 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id y14-20020aa7804e000000b0064dbf805ff7sm1757691pfm.72.2023.05.30.08.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 08:07:29 -0700 (PDT)
Message-ID: <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
Subject: Re: [PATCH net-next v2 2/3] page_pool: support non-frag page for
 page_pool_alloc_frag()
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org,  pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Lorenzo Bianconi
 <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 08:07:28 -0700
In-Reply-To: <20230529092840.40413-3-linyunsheng@huawei.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
	 <20230529092840.40413-3-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-29 at 17:28 +0800, Yunsheng Lin wrote:
> There is performance penalty with using page frag support when
> user requests a larger frag size and a page only supports one
> frag user, see [1].
>=20
> It seems like user may request different frag size depending
> on the mtu and packet size, provide an option to allocate
> non-frag page when a whole page is not able to hold two frags,
> so that user has a unified interface for the memory allocation
> with least memory utilization and performance penalty.
>=20
> 1. https://lore.kernel.org/netdev/ZEU+vospFdm08IeE@localhost.localdomain/
>=20
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> ---
>  net/core/page_pool.c | 47 +++++++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 18 deletions(-)
>=20
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 0868aa8f6323..e84ec6eabefd 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -699,14 +699,27 @@ struct page *page_pool_alloc_frag(struct page_pool =
*pool,
>  	unsigned int max_size =3D PAGE_SIZE << pool->p.order;
>  	struct page *page =3D pool->frag_page;
> =20
> -	if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> -		    size > max_size))
> +	if (unlikely(size > max_size))
>  		return NULL;
> =20
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> +		*offset =3D 0;
> +		return page_pool_alloc_pages(pool, gfp);
> +	}
> +

This is a recipe for pain. Rather than doing this I would say we should
stick with our existing behavior and not allow page pool fragments to
be used when the DMA address is consuming the region. Otherwise we are
going to make things very confusing.

If we have to have both version I would much rather just have some
inline calls in the header wrapped in one #ifdef for
PAGE_POOL_DMA_USE_PP_FRAG_COUNT that basically are a wrapper for
page_pool pages treated as pp_frag.

>  	size =3D ALIGN(size, dma_get_cache_alignment());
> -	*offset =3D pool->frag_offset;
> =20

If we are going to be allocating mono-frag pages they should be
allocated here based on the size check. That way we aren't discrupting
the performance for the smaller fragments and the code below could
function undisturbed.

> -	if (page && *offset + size > max_size) {
> +	if (page) {
> +		*offset =3D pool->frag_offset;
> +
> +		if (*offset + size <=3D max_size) {
> +			pool->frag_users++;
> +			pool->frag_offset =3D *offset + size;
> +			alloc_stat_inc(pool, fast);
> +			return page;
> +		}
> +
> +		pool->frag_page =3D NULL;
>  		page =3D page_pool_drain_frag(pool, page);
>  		if (page) {
>  			alloc_stat_inc(pool, fast);
> @@ -714,26 +727,24 @@ struct page *page_pool_alloc_frag(struct page_pool =
*pool,
>  		}
>  	}
> =20
> -	if (!page) {
> -		page =3D page_pool_alloc_pages(pool, gfp);
> -		if (unlikely(!page)) {
> -			pool->frag_page =3D NULL;
> -			return NULL;
> -		}
> -
> -		pool->frag_page =3D page;
> +	page =3D page_pool_alloc_pages(pool, gfp);
> +	if (unlikely(!page))
> +		return NULL;
> =20
>  frag_reset:
> -		pool->frag_users =3D 1;
> +	/* return page as non-frag page if a page is not able to
> +	 * hold two frags for the current requested size.
> +	 */

This statement ins't exactly true since you make all page pool pages
into fragmented pages.


> +	if (unlikely(size << 1 > max_size)) {

This should happen much sooner so you aren't mixing these allocations
with the smaller ones and forcing the fragmented page to be evicted.

>  		*offset =3D 0;
> -		pool->frag_offset =3D size;
> -		page_pool_fragment_page(page, BIAS_MAX);
>  		return page;
>  	}
> =20


> -	pool->frag_users++;
> -	pool->frag_offset =3D *offset + size;
> -	alloc_stat_inc(pool, fast);
> +	pool->frag_page =3D page;
> +	pool->frag_users =3D 1;
> +	*offset =3D 0;
> +	pool->frag_offset =3D size;
> +	page_pool_fragment_page(page, BIAS_MAX);
>  	return page;
>  }
>  EXPORT_SYMBOL(page_pool_alloc_frag);


