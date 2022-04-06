Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D624F6E6E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 01:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiDFXRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 19:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiDFXRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 19:17:15 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3881CC427
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 16:15:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 32so1331475pgl.4
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 16:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n3a7RBDoMv4pRNBnRLcq9TBMr5diRy/k9LuAIKEZpaQ=;
        b=h0jfbh2bSTDxv9GIfo6WTW1QvgUmp9N2zwcEzpZXAoCt03DNTeb6ckZtGHvtCx4Iv2
         uVENJ6OfryGnqzahOMJ3+ULx4P7ywOLm6PEWaj+1agefK0u7/V47hgh2EOE/tq1zep+/
         RIstcVeETlp5zNcdVCt0EM0BW9Eqz8xkA/SXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n3a7RBDoMv4pRNBnRLcq9TBMr5diRy/k9LuAIKEZpaQ=;
        b=XIPQQyuD9m5WJmXTfhYBoHbQZCP6LAL6javy/+8ebOHFdpjFjv6M8fmz8nAd4zZTZZ
         BfdYlp2yA5RAKhDfgEbA+e2wrus65Hfb9Fq2Nh9wgBMlEPMCGykWzkDONsXGYQF4YzSh
         EGGdDaGBYoGUNVIniWdNQTdm+gNzlE1pwgVhZrqXYgnXcr+/UE8sUUnzjy3XJt8KyhWg
         JBWfwAbXJrrcf+tzYB9n+2c7nZ5FSq3fpTomlaPkMhbSFMYk+NpesDIdV188qnu+xzdf
         Gk7ESOquKSHhBNcaNCoML7AmrBc1hoQRI09L25c3QbT2JR6O8M4ulzJk6MzqTXjesOFY
         J2sw==
X-Gm-Message-State: AOAM532XaAuKVeljFfNJ9da6tCl9C6vicKPJKbMATENrCb+gJvmnAqz9
        vdSHYm42tddYFMm9SpLnHOmQ4w==
X-Google-Smtp-Source: ABdhPJzkpdgd3d4ZrU5ceCR1LFMuAn2nVWvK5qUnLbKfe/djGR5MCcI0UOSmc7i16oT/QoS8mxi/Qg==
X-Received: by 2002:a63:1744:0:b0:39c:c4d9:fd39 with SMTP id 4-20020a631744000000b0039cc4d9fd39mr890822pgx.130.1649286917603;
        Wed, 06 Apr 2022 16:15:17 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a9-20020a056a000c8900b004fb37ecc6bbsm21043661pfv.65.2022.04.06.16.15.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:15:16 -0700 (PDT)
Date:   Wed, 6 Apr 2022 16:15:13 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] page_pool: Add recycle stats to
 page_pool_put_page_bulk
Message-ID: <20220406231512.GB96269@fastly.com>
References: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 10:52:55PM +0200, Lorenzo Bianconi wrote:
> Add missing recycle stats to page_pool_put_page_bulk routine.

Thanks for proposing this change. I did miss this path when adding
stats.

I'm sort of torn on this. It almost seems that we might want to track
bulking events separately as their own stat.

Maybe Ilias has an opinion on this; I did implement the stats, but I'm not
a maintainer of the page_pool so I'm not sure what I think matters all
that much ;) 

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/core/page_pool.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1943c0f0307d..4af55d28ffa3 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -36,6 +36,12 @@
>  		this_cpu_inc(s->__stat);						\
>  	} while (0)
>  
> +#define recycle_stat_add(pool, __stat, val)						\
> +	do {										\
> +		struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;	\
> +		this_cpu_add(s->__stat, val);						\
> +	} while (0)
> +
>  bool page_pool_get_stats(struct page_pool *pool,
>  			 struct page_pool_stats *stats)
>  {
> @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
>  #else
>  #define alloc_stat_inc(pool, __stat)
>  #define recycle_stat_inc(pool, __stat)
> +#define recycle_stat_add(pool, __stat, val)
>  #endif
>  
>  static int page_pool_init(struct page_pool *pool,
> @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  	/* Bulk producer into ptr_ring page_pool cache */
>  	page_pool_ring_lock(pool);
>  	for (i = 0; i < bulk_len; i++) {
> -		if (__ptr_ring_produce(&pool->ring, data[i]))
> -			break; /* ring full */
> +		if (__ptr_ring_produce(&pool->ring, data[i])) {
> +			/* ring full */
> +			recycle_stat_inc(pool, ring_full);
> +			break;
> +		}
>  	}
> +	recycle_stat_add(pool, ring, i);

If we do go with this approach (instead of adding bulking-specific stats),
we might want to replicate this change in __page_pool_alloc_pages_slow; we
currently only count the single allocation returned by the slow path, but
the rest of the pages which refilled the cache are not counted.

>  	page_pool_ring_unlock(pool);
>  
>  	/* Hopefully all pages was return into ptr_ring */
> -- 
> 2.35.1
> 
