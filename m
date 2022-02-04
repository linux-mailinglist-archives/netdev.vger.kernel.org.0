Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FDA4A94B8
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 08:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiBDHqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 02:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiBDHqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 02:46:20 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6D1C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 23:46:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w25so11391326edt.7
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 23:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ok/LsuI1SXBOTNlhIjizpNgUSDLNtkAK6KvQJ96GDS8=;
        b=DGNMBObMMsTwCVUgBVMk3iNCYh1P4K/nbS4vWGh/5LHAJ8xL1DruqGlfNOJ8aFiAJg
         ke7fw/yB8kCKPQNVG5KrHAphS++rHoclEqCBJXXh30kRppqTD1+xok076x/ms4hG3//m
         8Pg/MxlYApc17VE6WdhGqT38CSq/BjQ6f089qxAZ3kH7H6ZyVUhQXVemqVc2P0dK4PxX
         esctt030a52SKE0iTMN6BB96cnnFXJSztpuOhlhOxMvf9lkvqWFOvH7hLpvPCugQLS6e
         /Ua/ZFm7NpLzNmkOkbRilAtUSUvKoYEcDGupw//kLFwodtO+qi/t0ztXYw1AZ3190q9X
         6erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ok/LsuI1SXBOTNlhIjizpNgUSDLNtkAK6KvQJ96GDS8=;
        b=PwNECtq/IVUvndwdN64+JFr4yU93dleXGoNmWRuKhniKQTa/Cnq/+WlfK4qPK73o5G
         iYp7PEMxXzfOFcaTGQ+bIFKZ1y7OxryE+5+XPFZaU2VLHrEDL9QC2r8jaf96E7fbQIGc
         ibOiiyko4Y60YNdifbm3MnDvQIpc5sUr9b9cqY49+i3misZfU+9+vqgY3MT2xTTTHh8c
         VaWDMwjRZsI5T824IV81L7kSWlC6k4t1DFjgkoBEBxbKNXlQtrZ0UqSlEc4DLOkPe4IP
         sXRVOl5q+rw8t+xb+Xom1fpQhGZrLEHiHOvFQ7FlKckmXxrXOIBCUYmfn2X3CDMhLrWW
         lJ6Q==
X-Gm-Message-State: AOAM530PU3g6Z9ybmm631S3Iz4DSBpGGKILWQNSCIKSVvs6Ijem703Qr
        bgCRQQmCSh0fkuK2iwzCdk8HDLRn13JLR95J
X-Google-Smtp-Source: ABdhPJwDi6X/dvZKJIpLYJlz0oYwyuYFePo7O42tlGMR2AP7WoJlYDjullp7rNBcFSzV74b80Od0NA==
X-Received: by 2002:a05:6402:1508:: with SMTP id f8mr1755050edw.438.1643960778887;
        Thu, 03 Feb 2022 23:46:18 -0800 (PST)
Received: from hades (athedsl-4461669.home.otenet.gr. [94.71.4.85])
        by smtp.gmail.com with ESMTPSA id z2sm374607ejn.117.2022.02.03.23.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 23:46:18 -0800 (PST)
Date:   Fri, 4 Feb 2022 09:46:16 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com,
        brouer@redhat.com
Subject: Re: [net-next v4 11/11] page_pool: Add function to batch and return
 stats
Message-ID: <YfzZyL+mnvcFdzYs@hades>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
 <1643933373-6590-12-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643933373-6590-12-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 04:09:33PM -0800, Joe Damato wrote:
> Adds a function page_pool_get_stats which can be used by drivers to obtain
> the batched stats for a specified page pool.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>  include/net/page_pool.h |  9 +++++++++
>  net/core/page_pool.c    | 25 +++++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index bb87706..5257e46 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -153,6 +153,15 @@ struct page_pool_stats {
>  		u64 waive;  /* failed refills due to numa zone mismatch */
>  	} alloc;
>  };
> +
> +/*
> + * Drivers that wish to harvest page pool stats and report them to users
> + * (perhaps via ethtool, debugfs, or another mechanism) can allocate a
> + * struct page_pool_stats and call page_pool_get_stats to get the batched pcpu
> + * stats.
> + */
> +struct page_pool_stats *page_pool_get_stats(struct page_pool *pool,
> +					    struct page_pool_stats *stats);
>  #endif
>  
>  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 0bd084c..076593bb 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -35,6 +35,31 @@
>  		struct page_pool_stats __percpu *s = pool->stats;	\
>  		__this_cpu_inc(s->alloc.__stat);			\
>  	} while (0)
> +
> +struct page_pool_stats *page_pool_get_stats(struct page_pool *pool,
> +					    struct page_pool_stats *stats)
> +{
> +	int cpu = 0;
> +
> +	if (!stats)
> +		return NULL;
> +
> +	for_each_possible_cpu(cpu) {
> +		const struct page_pool_stats *pcpu =
> +			per_cpu_ptr(pool->stats, cpu);
> +
> +		stats->alloc.fast += pcpu->alloc.fast;
> +		stats->alloc.slow += pcpu->alloc.slow;
> +		stats->alloc.slow_high_order +=
> +			pcpu->alloc.slow_high_order;
> +		stats->alloc.empty += pcpu->alloc.empty;
> +		stats->alloc.refill += pcpu->alloc.refill;
> +		stats->alloc.waive += pcpu->alloc.waive;
> +	}
> +
> +	return stats;
> +}
> +EXPORT_SYMBOL(page_pool_get_stats);

You don't really need to return a pointer here. Just make the return code a
bool 

Regards
/Ilias
>  #else
>  #define this_cpu_inc_alloc_stat(pool, __stat)
>  #endif
> -- 
> 2.7.4
> 
