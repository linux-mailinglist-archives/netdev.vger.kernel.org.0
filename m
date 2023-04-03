Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A546D3FFC
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjDCJQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjDCJQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:16:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9FA10419
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 02:16:09 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so114422288edb.13
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 02:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680513366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6C6hynrcWv5X6FVoRcBHyHdDzOPwIH+nu4mWNHIuzRU=;
        b=PtI7rWmYVO07eoYjubHIVR8Ly7S9bDh3NoRsLTbh/xig8AYq87eQqAdVBkIx8FFHXJ
         MDvmgX25lTXuc3rWb+28P8zz4/lPx3K/2pr7sYP9kA2W0qXwfjr+mZxgzdH/bTI8BCed
         azqIkJAoFFgcft+ynjMNSfzsGWlvUbQL6nw+6yEgoKmDSxhCVPmBo+miUFaY88oShLJ6
         JGzh/DfpF9PrLCbWJUfoeeKDxMPCZIuBL2YcVQRpQuXN5a75CG13OMmPim0YZjpl/DSq
         OEssRCfftpO3rIcBk1QC65JAyeXYTqphBZCW0cemSDUCgvMKk8XjMdG1/SRIiuRt8oKw
         i+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680513366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6C6hynrcWv5X6FVoRcBHyHdDzOPwIH+nu4mWNHIuzRU=;
        b=BQZXYaizNqchKLXE9geLZcFDFojMGA0jrmFtffW/hWeAqyyivvJxeldkGlS9UnYKcu
         MFz9J4Wt/4WfB7EDL37bQTBY2Utvrcydv36axpm17SkVR004ufn6FtxvI78BJkTah+IL
         OJUhayZod4z+JdeQMVxgEkLaFgNScdNyogxgdEIbaaONKKyhla8d4632vVL/zfrzKc47
         UtvtlN5c+Xy52gcuEWV+MNGdiOmpr4SphQJ2xqOSNT2QC4a0Y0G7C3qQWUV9lLL7uxWf
         LwtEIWTBNl6pTc62BvjBtL9ewHN4imgnugyEsZoZaz+hQq2fs/KIqiW2PEJH+cue167h
         NMoQ==
X-Gm-Message-State: AAQBX9fFSEcYfzPOL1rscz2XY5KacvnW5hCUaHixPlyJcQFz7taIx8Jy
        0ArurZxbd2bKKhn5o6sGHnuThreYZT7bsfNoMfI=
X-Google-Smtp-Source: AKy350brdyxuRZjjDAqrJlngx88QvNNlh8GjOZfeLcUHm6G4990vBn0UXwMVT/IYMsyDyzt2NcD2kg==
X-Received: by 2002:aa7:d885:0:b0:4fd:2155:74ef with SMTP id u5-20020aa7d885000000b004fd215574efmr34985348edq.19.1680513366583;
        Mon, 03 Apr 2023 02:16:06 -0700 (PDT)
Received: from hera (ppp176092130041.access.hol.gr. [176.92.130.41])
        by smtp.gmail.com with ESMTPSA id h5-20020a50c385000000b004ad601533a3sm4340095edf.55.2023.04.03.02.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 02:16:06 -0700 (PDT)
Date:   Mon, 3 Apr 2023 12:16:04 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Message-ID: <ZCqZVNvhjLqBh2cv@hera>
References: <20230331043906.3015706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331043906.3015706-1-kuba@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub

On Thu, Mar 30, 2023 at 09:39:05PM -0700, Jakub Kicinski wrote:
> Recent patches to mlx5 mentioned a regression when moving from
> driver local page pool to only using the generic page pool code.
> Page pool has two recycling paths (1) direct one, which runs in
> safe NAPI context (basically consumer context, so producing
> can be lockless); and (2) via a ptr_ring, which takes a spin
> lock because the freeing can happen from any CPU; producer
> and consumer may run concurrently.
>
> Since the page pool code was added, Eric introduced a revised version
> of deferred skb freeing. TCP skbs are now usually returned to the CPU
> which allocated them, and freed in softirq context. This places the
> freeing (producing of pages back to the pool) enticingly close to
> the allocation (consumer).
>
> If we can prove that we're freeing in the same softirq context in which
> the consumer NAPI will run - lockless use of the cache is perfectly fine,
> no need for the lock.
>
> Let drivers link the page pool to a NAPI instance. If the NAPI instance
> is scheduled on the same CPU on which we're freeing - place the pages
> in the direct cache.
>
> With that and patched bnxt (XDP enabled to engage the page pool, sigh,
> bnxt really needs page pool work :() I see a 2.6% perf boost with
> a TCP stream test (app on a different physical core than softirq).
>
> The CPU use of relevant functions decreases as expected:
>
>   page_pool_refill_alloc_cache   1.17% -> 0%
>   _raw_spin_lock                 2.41% -> 0.98%
>
> Only consider lockless path to be safe when NAPI is scheduled
> - in practice this should cover majority if not all of steady state
> workloads. It's usually the NAPI kicking in that causes the skb flush.
>
> The main case we'll miss out on is when application runs on the same
> CPU as NAPI. In that case we don't use the deferred skb free path.
> We could disable softirq one that path, too... maybe?

This whole thing makes a lot of sense to me.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: hawk@kernel.org
> CC: ilias.apalodimas@linaro.org

[...]

>  	return true;
>  }
>
> +/* If caller didn't allow direct recycling check if we have other reasons
> + * to believe that the producer and consumer can't race.
> + *
> + * Result is only meaningful in softirq context.
> + */
> +static bool page_pool_safe_producer(struct page_pool *pool)
> +{
> +	struct napi_struct *napi = pool->p.napi;
> +
> +	return napi && READ_ONCE(napi->list_owner) == smp_processor_id();
> +}
> +
>  /* If the page refcnt == 1, this will try to recycle the page.
>   * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
>   * the configured size min(dma_sync_size, pool->max_len).
> @@ -570,6 +583,9 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>  			page_pool_dma_sync_for_device(pool, page,
>  						      dma_sync_size);
>
> +		if (!allow_direct)
> +			allow_direct = page_pool_safe_producer(pool);
> +

Do we want to hide the decision in __page_pool_put_page().  IOW wouldn't it
be better for this function to honor whatever allow_direct dictates and
have the allow_direct = page_pool_safe_producer(pool); in callers?

Thanks
/Ilias
>  		if (allow_direct && in_softirq() &&
>  		    page_pool_recycle_in_cache(page, pool))
>  			return NULL;
> --
> 2.39.2
>
