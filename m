Return-Path: <netdev+bounces-5670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA34971262F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32C391C21057
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3E1168C8;
	Fri, 26 May 2023 12:04:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FC4156E3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:04:31 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927F510CB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:03:57 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f6ef9a928fso2175215e9.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685102634; x=1687694634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mLfeU1cIQmeaVyRNtph06RZ6KBBxtb+vtfoTJMVHA+I=;
        b=EK5OQPVj8e3zNjKENf4gj9bouD+LdJFHNW2qRgXx9SfCDVpoW01tNj+6tNykaCmobb
         KM93mO9DOTcnWMd6Wb34QIjBwaQdDzHFqrlah9m3Lw5taIKJyF/qFo/AZps/WiMrqQRP
         hU3+5U2xYO4NYYtIkD7a9M1p8LPF/YlBUzuRbx2luLbY1HQxCDSCZddEqEi7VetpyNw7
         465Qmm6n7h1qKJrI2gcTVZNoQbNJzGNc0f3qhIP8q81rL4hroiKBOBg91z0iqlQQ7LmC
         73y/bJxXa7V7/oyqiU6joOgrou5DqxpuluLqEhlb1IUksfJxX5PLz3DqwVnqdVZ36S2/
         bnoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685102634; x=1687694634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLfeU1cIQmeaVyRNtph06RZ6KBBxtb+vtfoTJMVHA+I=;
        b=TRc6V2WKiuEBSrzN2d9PJNUYkfLCoJoL3qntiwkPOqG54PWGEe6olmrL+k99HZgQkd
         yp6uTY2GSF8/5qELEvJBqvPp9hA+jGODTxFFBl9l6mFqn8u17eHjsqIuh4RcZeKdEl8u
         /Uyve6EnZYJ82dvrLlGNsyeY4DrBgU61NUpnUDzl4SrzQ+HRctVxrQJw8+Hg1oHa5T0c
         899oJqGJnHO036/1r65442ziogI2ViMNCP7cDGidgosrt9DjUmdGRZIQzvb2sfbZKEe9
         G2CluZCDRE4748aZq/O9EXrsv5cWV/0/abhjLlixc2a2SI6A6gcFgawCJVADR/XFPBW5
         ZnPA==
X-Gm-Message-State: AC+VfDxKyrg5jqDmzetyv4W5QgzCtcIp36kWBpridC3GPoNdt7cLFbGx
	GqMZn1481hW59DPkIWVD9E04lg==
X-Google-Smtp-Source: ACHHUZ7B6lulluaL0WmnVt8XWs3qPf4jeDtFeCQAMf+7PbzVh9yKDCfg5VeIGknvIgbiSoNxYKD/Yg==
X-Received: by 2002:a7b:c006:0:b0:3f6:683:627e with SMTP id c6-20020a7bc006000000b003f60683627emr1210775wmb.9.1685102634168;
        Fri, 26 May 2023 05:03:54 -0700 (PDT)
Received: from hera (ppp089210114029.access.hol.gr. [89.210.114.29])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600c364600b003f420667807sm8564206wmq.11.2023.05.26.05.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:03:53 -0700 (PDT)
Date: Fri, 26 May 2023 15:03:51 +0300
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] page_pool: unify frag page and non-frag
 page handling
Message-ID: <ZHCgJxTnm37qu3aY@hera>
References: <20230526092616.40355-1-linyunsheng@huawei.com>
 <20230526092616.40355-2-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526092616.40355-2-linyunsheng@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Yunsheng

Apologies for not replying to the RFC,  I was pretty busy with internal
stuff

On Fri, May 26, 2023 at 05:26:14PM +0800, Yunsheng Lin wrote:
> Currently page_pool_dev_alloc_pages() can not be called
> when PP_FLAG_PAGE_FRAG is set, because it does not use
> the frag reference counting.
>
> As we are already doing a optimization by not updating
> page->pp_frag_count in page_pool_defrag_page() for the
> last frag user, and non-frag page only have one user,
> so we utilize that to unify frag page and non-frag page
> handling, so that page_pool_dev_alloc_pages() can also
> be called with PP_FLAG_PAGE_FRAG set.

What happens here is clear.  But why do we need this?  Do you have a
specific use case in mind where a driver will call
page_pool_dev_alloc_pages() and the PP_FLAG_PAGE_FRAG will be set?
If that's the case isn't it a better idea to unify the functions entirely?

Thanks
/Ilias
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> CC: Alexander Duyck <alexander.duyck@gmail.com>
> ---
>  include/net/page_pool.h | 38 +++++++++++++++++++++++++++++++-------
>  net/core/page_pool.c    |  1 +
>  2 files changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index c8ec2f34722b..ea7a0c0592a5 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -50,6 +50,9 @@
>  				 PP_FLAG_DMA_SYNC_DEV |\
>  				 PP_FLAG_PAGE_FRAG)
>
> +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT \
> +		(sizeof(dma_addr_t) > sizeof(unsigned long))
> +
>  /*
>   * Fast allocation side cache array/stack
>   *
> @@ -295,13 +298,20 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>   */
>  static inline void page_pool_fragment_page(struct page *page, long nr)
>  {
> -	atomic_long_set(&page->pp_frag_count, nr);
> +	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +		atomic_long_set(&page->pp_frag_count, nr);
>  }
>
> +/* We need to reset frag_count back to 1 for the last user to allow
> + * only one user in case the page is recycled and allocated as non-frag
> + * page.
> + */
>  static inline long page_pool_defrag_page(struct page *page, long nr)
>  {
>  	long ret;
>
> +	BUILD_BUG_ON(__builtin_constant_p(nr) && nr != 1);
> +
>  	/* If nr == pp_frag_count then we have cleared all remaining
>  	 * references to the page. No need to actually overwrite it, instead
>  	 * we can leave this to be overwritten by the calling function.
> @@ -311,19 +321,36 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
>  	 * especially when dealing with a page that may be partitioned
>  	 * into only 2 or 3 pieces.
>  	 */
> -	if (atomic_long_read(&page->pp_frag_count) == nr)
> +	if (atomic_long_read(&page->pp_frag_count) == nr) {
> +		/* As we have ensured nr is always one for constant case
> +		 * using the BUILD_BUG_ON() as above, only need to handle
> +		 * the non-constant case here for frag count draining.
> +		 */
> +		if (!__builtin_constant_p(nr))
> +			atomic_long_set(&page->pp_frag_count, 1);
> +
>  		return 0;
> +	}
>
>  	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
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
>
>  static inline bool page_pool_is_last_frag(struct page_pool *pool,
>  					  struct page *page)
>  {
> -	/* If fragments aren't enabled or count is 0 we were the last user */
> -	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> +	/* When dma_addr_upper is overlapped with pp_frag_count
> +	 * or we were the last page frag user.
> +	 */
> +	return PAGE_POOL_DMA_USE_PP_FRAG_COUNT ||
>  	       (page_pool_defrag_page(page, 1) == 0);
>  }
>
> @@ -357,9 +384,6 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>  	page_pool_put_full_page(pool, page, true);
>  }
>
> -#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
> -		(sizeof(dma_addr_t) > sizeof(unsigned long))
> -
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
>  	dma_addr_t ret = page->dma_addr;
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e212e9d7edcb..0868aa8f6323 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -334,6 +334,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>  {
>  	page->pp = pool;
>  	page->pp_magic |= PP_SIGNATURE;
> +	page_pool_fragment_page(page, 1);
>  	if (pool->p.init_callback)
>  		pool->p.init_callback(page, pool->p.init_arg);
>  }
> --
> 2.33.0
>

