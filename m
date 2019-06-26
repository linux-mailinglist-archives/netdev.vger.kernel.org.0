Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31D256729
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfFZKtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:49:55 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35082 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfFZKtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:49:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id x25so1705406ljh.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 03:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DbYsEvBW6F8N7wNO234XyQBFfHMkwstcMZVR/YcSDHw=;
        b=VsEWkm0MKum6Fuf4raOeZFMKLL6F5QD+CIAWzqOlcXyDeZgZSuaqNcUonl4RMBv/7x
         /kgGbT97ZXeUXhT9BlRiesPZFqWrXiIGDMgjN7IYOxJUaTkfGOQp3nXTaFE+clonoHv+
         +3owRGkMDcfqI4MgdCMZQYf/kHYq4VTMfbnGMUsFacARq8FhUoalSx7j1BRJQnhnpObx
         68Dx3ihI0FP/0BGbVxW0dfJHr601fLSKJvdBIh4T9k8Aj+hIgpcT7eGrG13u0MoqL2ed
         sQBIHOjxrfgpo/BzJeMXHXJNHK5D2F7iKgDj9AOoDvEjbwSwMfEXwJD0h/vjqyZNefnu
         HYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=DbYsEvBW6F8N7wNO234XyQBFfHMkwstcMZVR/YcSDHw=;
        b=i26OaYbRVy72x4AWsaTacrQaknDQ4zH8tqIhmtCBPWYDE5OKEaTH3Dld/BjI9j/Vq5
         hvZOxY14WDMuSgDTkbgIItzs3aXmisk4Jysu8hrYUxcNMtti1MwVm3DRRCNzZQeqVaAA
         jUP3sSC3jBwnweUaucvAdvT8iYuu6cRVHlXmdS/f/3dtithPqFXw6ydv1rovSPyyXfcR
         O83Jsdma1EOCYzpPZeyG06X0Znk4S6q7seUy5TmpI28vnIoBytZhjcavwItZpoJFC6sb
         lfjTJfGVQX7Qk62Pk95bReskdSPQIwr568tYmiQpyVeutessrpC1gy8ROBSQghmktr7X
         IFKw==
X-Gm-Message-State: APjAAAVPSeg/3jsgBji9mJwJzyCBilgLsxf4XMPUpIJnOMaamnHOQJej
        7cPuQqKPfrdnDLn7rTvOAke32A==
X-Google-Smtp-Source: APXvYqyf4W3q5MehDftLZSo/IFhASVjHPRiT4GnnAHEmxeIYcMFSDZsrmhFSjrMVhLaA2kVqaSHKYw==
X-Received: by 2002:a2e:8ed2:: with SMTP id e18mr2469846ljl.235.1561546192452;
        Wed, 26 Jun 2019 03:49:52 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id q2sm2341611lfj.25.2019.06.26.03.49.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Jun 2019 03:49:51 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:49:49 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     davem@davemloft.net, grygorii.strashko@ti.com, hawk@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH v4 net-next 1/4] net: core: page_pool: add user cnt
 preventing pool deletion
Message-ID: <20190626104948.GF6485@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        davem@davemloft.net, grygorii.strashko@ti.com, hawk@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
 <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
 <20190626124216.494eee86@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190626124216.494eee86@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 12:42:16PM +0200, Jesper Dangaard Brouer wrote:
>On Tue, 25 Jun 2019 20:59:45 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> Add user counter allowing to delete pool only when no users.
>> It doesn't prevent pool from flush, only prevents freeing the
>> pool instance. Helps when no need to delete the pool and now
>> it's user responsibility to free it by calling page_pool_free()
>> while destroying procedure. It also makes to use page_pool_free()
>> explicitly, not fully hidden in xdp unreg, which looks more
>> correct after page pool "create" routine.
>
>No, this is wrong.
below.

>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 +++++---
>>  include/net/page_pool.h                           | 7 +++++++
>>  net/core/page_pool.c                              | 7 +++++++
>>  net/core/xdp.c                                    | 3 +++
>>  4 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index 5e40db8f92e6..cb028de64a1d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -545,10 +545,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>>  	}
>>  	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
>>  					 MEM_TYPE_PAGE_POOL, rq->page_pool);
>> -	if (err) {
>> -		page_pool_free(rq->page_pool);
>> +	if (err)
>>  		goto err_free;
>> -	}
>>
>>  	for (i = 0; i < wq_sz; i++) {
>>  		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
>> @@ -613,6 +611,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>>  	if (rq->xdp_prog)
>>  		bpf_prog_put(rq->xdp_prog);
>>  	xdp_rxq_info_unreg(&rq->xdp_rxq);
>> +	if (rq->page_pool)
>> +		page_pool_free(rq->page_pool);
>>  	mlx5_wq_destroy(&rq->wq_ctrl);
>>
>>  	return err;
>> @@ -643,6 +643,8 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
>>  	}
>>
>>  	xdp_rxq_info_unreg(&rq->xdp_rxq);
>> +	if (rq->page_pool)
>> +		page_pool_free(rq->page_pool);
>
>No, this is wrong.  The hole point with the merged page_pool fixes
>patchset was that page_pool_free() needs to be delayed until no-more
>in-flight packets exist.

Probably it's not so obvious, but it's still delayed and deleted only
after no-more in-flight packets exist. Here question is only who is able
to do this first based on refcnt.

>
>
>>  	mlx5_wq_destroy(&rq->wq_ctrl);
>>  }
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index f07c518ef8a5..1ec838e9927e 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -101,6 +101,7 @@ struct page_pool {
>>  	struct ptr_ring ring;
>>
>>  	atomic_t pages_state_release_cnt;
>> +	atomic_t user_cnt;
>>  };
>>
>>  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
>> @@ -183,6 +184,12 @@ static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>>  	return page->dma_addr;
>>  }
>>
>> +/* used to prevent pool from deallocation */
>> +static inline void page_pool_get(struct page_pool *pool)
>> +{
>> +	atomic_inc(&pool->user_cnt);
>> +}
>> +
>>  static inline bool is_page_pool_compiled_in(void)
>>  {
>>  #ifdef CONFIG_PAGE_POOL
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index b366f59885c1..169b0e3c870e 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -48,6 +48,7 @@ static int page_pool_init(struct page_pool *pool,
>>  		return -ENOMEM;
>>
>>  	atomic_set(&pool->pages_state_release_cnt, 0);
>> +	atomic_set(&pool->user_cnt, 0);
>>
>>  	if (pool->p.flags & PP_FLAG_DMA_MAP)
>>  		get_device(pool->p.dev);
>> @@ -70,6 +71,8 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
>>  		kfree(pool);
>>  		return ERR_PTR(err);
>>  	}
>> +
>> +	page_pool_get(pool);
>>  	return pool;
>>  }
>>  EXPORT_SYMBOL(page_pool_create);
>> @@ -356,6 +359,10 @@ static void __warn_in_flight(struct page_pool *pool)
>>
>>  void __page_pool_free(struct page_pool *pool)
>>  {
>> +	/* free only if no users */
>> +	if (!atomic_dec_and_test(&pool->user_cnt))
>> +		return;
>> +
>>  	WARN(pool->alloc.count, "API usage violation");
>>  	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>>
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 829377cc83db..04bdcd784d2e 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -372,6 +372,9 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>>
>>  	mutex_unlock(&mem_id_lock);
>>
>> +	if (type == MEM_TYPE_PAGE_POOL)
>> +		page_pool_get(xdp_alloc->page_pool);
>> +
>>  	trace_mem_connect(xdp_alloc, xdp_rxq);
>>  	return 0;
>>  err:
>
>
>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
