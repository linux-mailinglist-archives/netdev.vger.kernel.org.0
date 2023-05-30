Return-Path: <netdev+bounces-6467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FAF71663A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93CE2281211
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE3A24E88;
	Tue, 30 May 2023 15:08:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA46C17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:08:19 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F0FA7;
	Tue, 30 May 2023 08:07:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d2c865e4eso3440400b3a.0;
        Tue, 30 May 2023 08:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685459244; x=1688051244;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0RkgySFR8dYSzEG9Be3aAi+lKVQBHUqVUG/Ar8NiTao=;
        b=EtXbmuvZbrpekKKqZqTCHYqQHmipf7ORW5LgkE9y54IMwDaATBBVPpECxsldIR/uqi
         cF2B8d/jW5iwd2LI12ecTDYYCZLsitlMI3l9RXBGFsPiKeA2VjuG2FsVLjxVRDoPyQKp
         gM2rWKYOvwcE1shFRN6DJk7l4qANL34+2hp1HsLFvpJ5xxykqNZTc65mAS1aypuwRPc8
         jP2h2M2pSwZp3rkiILXwzqWbc3dqiiaNgrkzQozVP/O9kMwWHoxB3Z42JBuvr++qhU6X
         Gsj2+wTJjfLBenblDW2pzceMo8Z1dmQdB3e3BivA3NhnwsJSh/P2GFL9JbKmlMf2AEEG
         sqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685459244; x=1688051244;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0RkgySFR8dYSzEG9Be3aAi+lKVQBHUqVUG/Ar8NiTao=;
        b=HJcWLax0xbbey/dNKCt56mmRlxViq3jxfRAX2K5O3896pmUK1ahOvvxRVPRzalKnua
         x4BnbUHCPK7HX0qhZyRhab3Pkd0Czleti/TB8GtTr2cznbrYP6fTuAG6EPhNjYWElD4m
         g2KwWKX5DBrAjT1bPme4kZJ2n8HrHRqt7I0Uw7yRD37ABkl7R6LVFP/CuVxqg7trp0wh
         F4VqZhakrio0t7wL1zNXQ88JpaVNT0KXZf/i0cj9+UkfCExvv4n3P+StGEh6KbTi2GUg
         fVgvIDHPcBNiKqxfN8EPItjcum6JNYC1hF4VsfgQZg7ASe9bossOAhOHBgUPRbpCqsBh
         rGPA==
X-Gm-Message-State: AC+VfDxQJudYEiCYdFujn24neorSbiD1NPH9kIr1BkyzqQxFHTGOuX4x
	5dC+zdJuJ05mWKvH/OhLYTg=
X-Google-Smtp-Source: ACHHUZ6Pc8N6d/ig8Uq/F87koYDGrFliyNjegwghUvloxGX4grD4GP+sFVIys/SOEfnB5cMN6IKEwQ==
X-Received: by 2002:a17:902:e74c:b0:1ab:267e:2f2d with SMTP id p12-20020a170902e74c00b001ab267e2f2dmr3141807plf.48.1685459243913;
        Tue, 30 May 2023 08:07:23 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id i12-20020a170902eb4c00b0019a773419a6sm5334955pli.170.2023.05.30.08.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 08:07:23 -0700 (PDT)
Message-ID: <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org,  pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Lorenzo Bianconi
 <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 08:07:21 -0700
In-Reply-To: <20230529092840.40413-2-linyunsheng@huawei.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
	 <20230529092840.40413-2-linyunsheng@huawei.com>
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
> Currently page_pool_dev_alloc_pages() can not be called
> when PP_FLAG_PAGE_FRAG is set, because it does not use
> the frag reference counting.
>=20
> As we are already doing a optimization by not updating
> page->pp_frag_count in page_pool_defrag_page() for the
> last frag user, and non-frag page only have one user,
> so we utilize that to unify frag page and non-frag page
> handling, so that page_pool_dev_alloc_pages() can also
> be called with PP_FLAG_PAGE_FRAG set.
>=20
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> CC: Alexander Duyck <alexander.duyck@gmail.com>

I"m not really a huge fan of the approach. Basically it looks like you
are trying to turn every page pool page into a fragmented page. Why not
just stick to keeping the fragemented pages and have a special case
that just generates a mono-frag page for your allocator instead.

The problem is there are some architectures where we just cannot
support having pp_frag_count due to the DMA size. So it makes sense to
leave those with just basic page pool instead of trying to fake that it
is a fragmented page.

> ---
>  include/net/page_pool.h | 38 +++++++++++++++++++++++++++++++-------
>  net/core/page_pool.c    |  1 +
>  2 files changed, 32 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index c8ec2f34722b..ea7a0c0592a5 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -50,6 +50,9 @@
>  				 PP_FLAG_DMA_SYNC_DEV |\
>  				 PP_FLAG_PAGE_FRAG)
> =20
> +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT \
> +		(sizeof(dma_addr_t) > sizeof(unsigned long))
> +
>  /*
>   * Fast allocation side cache array/stack
>   *
> @@ -295,13 +298,20 @@ void page_pool_put_defragged_page(struct page_pool =
*pool, struct page *page,
>   */
>  static inline void page_pool_fragment_page(struct page *page, long nr)
>  {
> -	atomic_long_set(&page->pp_frag_count, nr);
> +	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +		atomic_long_set(&page->pp_frag_count, nr);
>  }
> =20
> +/* We need to reset frag_count back to 1 for the last user to allow
> + * only one user in case the page is recycled and allocated as non-frag
> + * page.
> + */
>  static inline long page_pool_defrag_page(struct page *page, long nr)
>  {
>  	long ret;
> =20
> +	BUILD_BUG_ON(__builtin_constant_p(nr) && nr !=3D 1);
> +

What is the point of this line? It doesn't make much sense to me. Are
you just trying to force an optiimization? You would be better off just
taking the BUILD_BUG_ON contents and feeding them into an if statement
below since the statement will compile out anyway.

It seems like what you would want here is:
	BUG_ON(!PAGE_POOL_DMA_USE_PP_FRAG_COUNT);

Otherwise you are potentially writing to a variable that shouldn't
exist.

>  	/* If nr =3D=3D pp_frag_count then we have cleared all remaining
>  	 * references to the page. No need to actually overwrite it, instead
>  	 * we can leave this to be overwritten by the calling function.
> @@ -311,19 +321,36 @@ static inline long page_pool_defrag_page(struct pag=
e *page, long nr)
>  	 * especially when dealing with a page that may be partitioned
>  	 * into only 2 or 3 pieces.
>  	 */
> -	if (atomic_long_read(&page->pp_frag_count) =3D=3D nr)
> +	if (atomic_long_read(&page->pp_frag_count) =3D=3D nr) {
> +		/* As we have ensured nr is always one for constant case
> +		 * using the BUILD_BUG_ON() as above, only need to handle
> +		 * the non-constant case here for frag count draining.
> +		 */
> +		if (!__builtin_constant_p(nr))
> +			atomic_long_set(&page->pp_frag_count, 1);
> +
>  		return 0;
> +	}
> =20
>  	ret =3D atomic_long_sub_return(nr, &page->pp_frag_count);
>  	WARN_ON(ret < 0);
> +
> +	/* Reset frag count back to 1, this should be the rare case when
> +	 * two users call page_pool_defrag_page() currently.
> +	 */
> +	if (!ret)
> +		atomic_long_set(&page->pp_frag_count, 1);
> +
>  	return ret;
>  }
> =20
>  static inline bool page_pool_is_last_frag(struct page_pool *pool,
>  					  struct page *page)
>  {
> -	/* If fragments aren't enabled or count is 0 we were the last user */
> -	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> +	/* When dma_addr_upper is overlapped with pp_frag_count
> +	 * or we were the last page frag user.
> +	 */
> +	return PAGE_POOL_DMA_USE_PP_FRAG_COUNT ||
>  	       (page_pool_defrag_page(page, 1) =3D=3D 0);
>  }
> =20
> @@ -357,9 +384,6 @@ static inline void page_pool_recycle_direct(struct pa=
ge_pool *pool,
>  	page_pool_put_full_page(pool, page, true);
>  }
> =20
> -#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
> -		(sizeof(dma_addr_t) > sizeof(unsigned long))
> -
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
>  	dma_addr_t ret =3D page->dma_addr;
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e212e9d7edcb..0868aa8f6323 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -334,6 +334,7 @@ static void page_pool_set_pp_info(struct page_pool *p=
ool,
>  {
>  	page->pp =3D pool;
>  	page->pp_magic |=3D PP_SIGNATURE;
> +	page_pool_fragment_page(page, 1);
>  	if (pool->p.init_callback)
>  		pool->p.init_callback(page, pool->p.init_arg);
>  }

Again, you are adding statements here that now have to be stripped out
under specific circumstances. In my opinion it would be better to not
modify base page pool pages and instead just have your allocator
provide a 1 frag page pool page via a special case allocator rather
then messing with all the other drivers.

