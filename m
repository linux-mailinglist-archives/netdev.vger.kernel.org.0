Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989BFDD08E
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfJRUpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:45:50 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33796 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfJRUpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:45:50 -0400
Received: by mail-pl1-f196.google.com with SMTP id k7so3416811pll.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 13:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=zZ2dDJWIIFdHI9YDN9u+z+l6xakT916SFWuzXDTCEtw=;
        b=kIDRupRX37oR+HeyxC3tNhuO5XQHnXlifP1cXb4CXcISDD0AQiozhkbhEAxCUGXVFS
         vUX9fHmEbgcd7BNhJ4AwpvkWN/crVsLZYtUQ60vcOWPg26IhewXwJKnQfN/x2rlN1Me6
         V5VMm8EFT1YXMCnBZ5+xfY5L0vTQFoc7PBYgNruEdIJQJaGNu+KVlOBrRaF5nMW547cj
         0Qd0Yx+0XUGsEtQRhRjmbaOt49R9roz3ZHuvMoxrljJeuVnMmNAwDvPnx9n/e2jYDa4d
         yKAYif+YPKqTXms3ouYd+8nA54KdO9SrjRCgFbQwie7WoPMdyRJhwCWUhp27wWdMD+Sw
         TSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=zZ2dDJWIIFdHI9YDN9u+z+l6xakT916SFWuzXDTCEtw=;
        b=bVjX3GkLYC66PckfYtxWcQtRujeY8wzCknxBb3nQ6fRCQ1v2Lj1YJnVXd1wkcv2Lmy
         DVjC/Zo63RO49D5+DJfzwrU79y5Ijp6zD51xGzruL3mHpcdoW35Y+GIVGAEszNAv4X7o
         2aN7XGDlZDpQBy4Gw7HKb01rp0B4HgY2zpQJaTL18UsLtFrb+j0TemM7s7tfjzvJGYn8
         bOXB4iJUa1HsYQj867l5YkJAKHySowU6RVzPYSqE+368ltMGdbx3GMQ0MwCtkT29CKkg
         0T0IQK1UDB7ukCXdAGthJfAwgU2rGaEyQ6jlFFoQOAC+/dJQVaCp2lRFFntNg/aHAylB
         zMNg==
X-Gm-Message-State: APjAAAXddA8TzszI5uGSg2TZP6V1gprq2JfkY0prLBA3cukp279/tnLj
        Pldox8o2YFY7snYWpnCQ7o41Im9c
X-Google-Smtp-Source: APXvYqxUOn3gcwtrvggy6j6Z18/YtChGOvx43FxBcfw8FpDUcihY7BqLR1uye6K9PGk//aEx4D32hg==
X-Received: by 2002:a17:902:6b02:: with SMTP id o2mr11747573plk.302.1571431549574;
        Fri, 18 Oct 2019 13:45:49 -0700 (PDT)
Received: from [172.20.162.151] ([2620:10d:c090:180::d0dd])
        by smtp.gmail.com with ESMTPSA id d76sm7558805pfd.185.2019.10.18.13.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 13:45:48 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     ilias.apalodimas@linaro.org, saeedm@mellanox.com,
        tariqt@mellanox.com, netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 09/10 net-next] net/mlx5: Add page_pool stats to the
 Mellanox driver
Date:   Fri, 18 Oct 2019 13:45:47 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <361B12F0-625B-4148-91EC-A2217679C723@gmail.com>
In-Reply-To: <20191017130935.01a7a99b@carbon>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-10-jonathan.lemon@gmail.com>
 <20191017130935.01a7a99b@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 Oct 2019, at 4:09, Jesper Dangaard Brouer wrote:

> On Wed, 16 Oct 2019 15:50:27 -0700
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>> Replace the now deprecated inernal cache stats with the page pool 
>> stats.
>
> I can see that the stats you introduced are useful, but they have to 
> be
> implemented in way that does not hurt performance.

They're not noticeable, but even if they were, they are needed
for production, otherwise there's no way to identify problems.

I can separate the ring consume/produce counters so they
are always separated by a cache line distance.



>> # ethtool -S eth0 | grep rx_pool
>>      rx_pool_cache_hit: 1646798
>>      rx_pool_cache_full: 0
>>      rx_pool_cache_empty: 15723566
>>      rx_pool_ring_produce: 474958
>>      rx_pool_ring_consume: 0
>>      rx_pool_ring_return: 474958
>>      rx_pool_flush: 144
>>      rx_pool_node_change: 0
>>
>> Showing about a 10% hit rate for the page pool.
>
> What is the workload from above stats?

Network traffic from a proxygen load balancer.  From
this, we see the ptr_ring is completely unused except
for flushing operations.
-- 
Jonathan

>
>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
>>  .../ethernet/mellanox/mlx5/core/en_stats.c    | 39 
>> ++++++++++++-------
>>  .../ethernet/mellanox/mlx5/core/en_stats.h    | 19 +++++----
>>  4 files changed, 35 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> index 2e281c755b65..b34519061d12 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> @@ -50,6 +50,7 @@
>>  #include <net/xdp.h>
>>  #include <linux/dim.h>
>>  #include <linux/bits.h>
>> +#include <net/page_pool.h>
>>  #include "wq.h"
>>  #include "mlx5_core.h"
>>  #include "en_stats.h"
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index 2b828de1adf0..f10b5838fb17 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -551,6 +551,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel 
>> *c,
>>  		pp_params.nid       = cpu_to_node(c->cpu);
>>  		pp_params.dev       = c->pdev;
>>  		pp_params.dma_dir   = rq->buff.map_dir;
>> +		pp_params.stats     = &rq->stats->pool;
>>
>>  		/* page_pool can be used even when there is no rq->xdp_prog,
>>  		 * given page_pool does not handle DMA mapping there is no
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>> index ac6fdcda7019..ad42d965d786 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
>> @@ -102,11 +102,14 @@ static const struct counter_desc 
>> sw_stats_desc[] = {
>>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_buff_alloc_err) },
>>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cqe_compress_blks) 
>> },
>>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cqe_compress_pkts) 
>> },
>> -	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_reuse) },
>> -	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_full) },
>> -	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_empty) },
>> -	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_busy) },
>> -	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_waive) },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_cache_hit) },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_cache_full) },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_cache_empty) },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_ring_produce) 
>> },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_ring_consume) 
>> },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_ring_return) },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_flush) },
>> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pool_node_change) },
>>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
>>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
>>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
>> @@ -214,11 +217,14 @@ static void mlx5e_grp_sw_update_stats(struct 
>> mlx5e_priv *priv)
>>  		s->rx_buff_alloc_err += rq_stats->buff_alloc_err;
>>  		s->rx_cqe_compress_blks += rq_stats->cqe_compress_blks;
>>  		s->rx_cqe_compress_pkts += rq_stats->cqe_compress_pkts;
>> -		s->rx_cache_reuse += rq_stats->cache_reuse;
>> -		s->rx_cache_full  += rq_stats->cache_full;
>> -		s->rx_cache_empty += rq_stats->cache_empty;
>> -		s->rx_cache_busy  += rq_stats->cache_busy;
>> -		s->rx_cache_waive += rq_stats->cache_waive;
>> +		s->rx_pool_cache_hit += rq_stats->pool.cache_hit;
>> +		s->rx_pool_cache_full += rq_stats->pool.cache_full;
>> +		s->rx_pool_cache_empty += rq_stats->pool.cache_empty;
>> +		s->rx_pool_ring_produce += rq_stats->pool.ring_produce;
>> +		s->rx_pool_ring_consume += rq_stats->pool.ring_consume;
>> +		s->rx_pool_ring_return += rq_stats->pool.ring_return;
>> +		s->rx_pool_flush += rq_stats->pool.flush;
>> +		s->rx_pool_node_change += rq_stats->pool.node_change;
>>  		s->rx_congst_umr  += rq_stats->congst_umr;
>>  		s->rx_arfs_err    += rq_stats->arfs_err;
>>  		s->rx_recover     += rq_stats->recover;
>> @@ -1446,11 +1452,14 @@ static const struct counter_desc 
>> rq_stats_desc[] = {
>>  	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, buff_alloc_err) },
>>  	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cqe_compress_blks) 
>> },
>>  	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cqe_compress_pkts) 
>> },
>> -	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_reuse) },
>> -	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_full) },
>> -	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_empty) },
>> -	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_busy) },
>> -	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_waive) },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.cache_hit) },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.cache_full) },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.cache_empty) },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.ring_produce) 
>> },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.ring_consume) 
>> },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.ring_return) },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.flush) },
>> +	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pool.node_change) },
>>  	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
>>  	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
>>  	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
>> index 79f261bf86ac..7d6001969400 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
>> @@ -109,11 +109,14 @@ struct mlx5e_sw_stats {
>>  	u64 rx_buff_alloc_err;
>>  	u64 rx_cqe_compress_blks;
>>  	u64 rx_cqe_compress_pkts;
>> -	u64 rx_cache_reuse;
>> -	u64 rx_cache_full;
>> -	u64 rx_cache_empty;
>> -	u64 rx_cache_busy;
>> -	u64 rx_cache_waive;
>> +	u64 rx_pool_cache_hit;
>> +	u64 rx_pool_cache_full;
>> +	u64 rx_pool_cache_empty;
>> +	u64 rx_pool_ring_produce;
>> +	u64 rx_pool_ring_consume;
>> +	u64 rx_pool_ring_return;
>> +	u64 rx_pool_flush;
>> +	u64 rx_pool_node_change;
>>  	u64 rx_congst_umr;
>>  	u64 rx_arfs_err;
>>  	u64 rx_recover;
>> @@ -245,14 +248,10 @@ struct mlx5e_rq_stats {
>>  	u64 buff_alloc_err;
>>  	u64 cqe_compress_blks;
>>  	u64 cqe_compress_pkts;
>> -	u64 cache_reuse;
>> -	u64 cache_full;
>> -	u64 cache_empty;
>> -	u64 cache_busy;
>> -	u64 cache_waive;
>>  	u64 congst_umr;
>>  	u64 arfs_err;
>>  	u64 recover;
>> +	struct page_pool_stats pool;
>>  };
>>
>>  struct mlx5e_sq_stats {
>
>
>
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
