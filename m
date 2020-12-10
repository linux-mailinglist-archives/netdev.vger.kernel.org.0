Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDAA2D4F46
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgLJASn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgLJASm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:18:42 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F93DC0613CF;
        Wed,  9 Dec 2020 16:18:02 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id l9so3624091wrt.13;
        Wed, 09 Dec 2020 16:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LH2TbIk8yvopRAYMudOtsFMQfdRdmyO24GGKQu9JPKg=;
        b=gsj/sutM/le/AryQTjx9TM8vHS/LRSgpyAA6nR7A7DNkXPvE7xjlul3phUDx8yY4VU
         WHOV41kkgOtcfpss2+oWwGUF7TyylDbQ6W4j3eDPB556aWqyAWx98ADxQIxjAIYwTSt1
         yp7pRuzcPgAzBcUHi1dO/LDVk3MAsp3B8X6bRNFj0g2XEnCb+PsuSSWC/ChEB3tJclWD
         9xpWWOIVlrsySaisqTBF2DbosdqBF4ni0yPI7rNlNm0wnoTNjdd3T1piKRiLQ2pV+CVz
         GSUdPsL8p45befmBomOwzJT7cvYKaueQkgF+IM5KvHuQXS6K2L7ohdbWYwtA5xhO4ZyM
         UasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LH2TbIk8yvopRAYMudOtsFMQfdRdmyO24GGKQu9JPKg=;
        b=f0tWBCQ4hVgh5IC9/dYxSAoLZb9tXzNW8P+h75Nk8OnjVYiXgpMgKqQYJ+CWRZVNg6
         fmsP//h4gItI4LDXnrTT6H9m3+8WBwEJjEMO4sZyTTUU/PUyhNWtSedA0Z9nmMR8MyKy
         ESRxz9KLIDvKy6xlvtBGaCuUmTDbsBLMOZDa0eiirXqVprHrM2sn0B4zi0mzZgfzO1T6
         RVeo0Cn9+7A89Llc1xV//cKRi8DJoKXA+nYRgSAEVvSqemeWWw11OfWAPcnB+1Pjgifx
         0G9ygxpsvnfb+d58XCcUihJb8+/4A/J24TLVBxYwMjxNtcP8k7mDgELS0hCqVN1y69ml
         DJCA==
X-Gm-Message-State: AOAM530nIFP6iwwcd3Ert6Q78ChTqVCgXfPkcRksX5jDyx517l5s7jIm
        w6MVsBSW9SHyw6d66EqLexy7Ei2ZHXI=
X-Google-Smtp-Source: ABdhPJzN/WDYcI9WwtMT7zuYOAEv4nDPAB36alABaodV9YKoZlwJJL7DFQV5UijD3I+QhPQyAAuD5w==
X-Received: by 2002:adf:e802:: with SMTP id o2mr5389699wrm.251.1607559480686;
        Wed, 09 Dec 2020 16:18:00 -0800 (PST)
Received: from [192.168.8.116] ([37.171.242.50])
        by smtp.gmail.com with ESMTPSA id g78sm6540587wme.33.2020.12.09.16.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 16:17:59 -0800 (PST)
Subject: Re: [PATCH 1/1] net/ipv4/inet_fragment: Batch fqdir destroy works
To:     SeongJae Park <sjpark@amazon.com>, davem@davemloft.net
Cc:     SeongJae Park <sjpark@amazon.de>, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, paulmck@kernel.org, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201208094529.23266-1-sjpark@amazon.com>
 <20201208094529.23266-2-sjpark@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6d3e32f6-c2df-a1a6-3568-b7387cd0c933@gmail.com>
Date:   Thu, 10 Dec 2020 01:17:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201208094529.23266-2-sjpark@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/20 10:45 AM, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> In 'fqdir_exit()', a work for destruction of the 'fqdir' is enqueued.
> The work function, 'fqdir_work_fn()', calls 'rcu_barrier()'.  In case of
> intensive 'fqdir_exit()' (e.g., frequent 'unshare(CLONE_NEWNET)'
> systemcalls), this increased contention could result in unacceptably
> high latency of 'rcu_barrier()'.  This commit avoids such contention by
> doing the destruction in batched manner, as similar to that of
> 'cleanup_net()'.

Any numbers to share ? I have never seen an issue.

> 
> Signed-off-by: SeongJae Park <sjpark@amazon.de>
> ---
>  include/net/inet_frag.h  |  2 +-
>  net/ipv4/inet_fragment.c | 28 ++++++++++++++++++++--------
>  2 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> index bac79e817776..558893d8810c 100644
> --- a/include/net/inet_frag.h
> +++ b/include/net/inet_frag.h
> @@ -20,7 +20,7 @@ struct fqdir {
>  
>  	/* Keep atomic mem on separate cachelines in structs that include it */
>  	atomic_long_t		mem ____cacheline_aligned_in_smp;
> -	struct work_struct	destroy_work;
> +	struct llist_node	destroy_list;
>  };
>  
>  /**
> diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> index 10d31733297d..796b559137c5 100644
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -145,12 +145,19 @@ static void inet_frags_free_cb(void *ptr, void *arg)
>  		inet_frag_destroy(fq);
>  }
>  
> +static LLIST_HEAD(destroy_list);
> +
>  static void fqdir_work_fn(struct work_struct *work)
>  {
> -	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
> -	struct inet_frags *f = fqdir->f;
> +	struct llist_node *kill_list;
> +	struct fqdir *fqdir;
> +	struct inet_frags *f;
> +
> +	/* Atomically snapshot the list of fqdirs to destroy */
> +	kill_list = llist_del_all(&destroy_list);
>  
> -	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> +	llist_for_each_entry(fqdir, kill_list, destroy_list)
> +		rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
> 


OK, it seems rhashtable_free_and_destroy() has cond_resched() so we are not going
to hold this cpu for long periods.
 
>  	/* We need to make sure all ongoing call_rcu(..., inet_frag_destroy_rcu)
>  	 * have completed, since they need to dereference fqdir.
> @@ -158,10 +165,13 @@ static void fqdir_work_fn(struct work_struct *work)
>  	 */
>  	rcu_barrier();
>  
> -	if (refcount_dec_and_test(&f->refcnt))
> -		complete(&f->completion);
> +	llist_for_each_entry(fqdir, kill_list, destroy_list) {

Don't we need the llist_for_each_entry_safe() variant here ???

> +		f = fqdir->f;
> +		if (refcount_dec_and_test(&f->refcnt))
> +			complete(&f->completion);
>  
> -	kfree(fqdir);
> +		kfree(fqdir);
> +	}
>  }
>  
>  int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
> @@ -184,10 +194,12 @@ int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net)
>  }
>  EXPORT_SYMBOL(fqdir_init);
>  
> +static DECLARE_WORK(fqdir_destroy_work, fqdir_work_fn);
> +
>  void fqdir_exit(struct fqdir *fqdir)
>  {
> -	INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
> -	queue_work(system_wq, &fqdir->destroy_work);
> +	if (llist_add(&fqdir->destroy_list, &destroy_list))
> +		queue_work(system_wq, &fqdir_destroy_work);
>  }
>  EXPORT_SYMBOL(fqdir_exit);
>  
> 
