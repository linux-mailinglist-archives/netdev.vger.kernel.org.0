Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFC53FD2BF
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 07:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbhIAFN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 01:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhIAFN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 01:13:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8245C061575;
        Tue, 31 Aug 2021 22:13:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x4so1605581pgh.1;
        Tue, 31 Aug 2021 22:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1te2TiJLyTiKKKO3+VCdFNHOw4n57n/rfL3rTuqofow=;
        b=AAhZi11tJEFIYwAH4Q0BDvdJ45zBoS1Jf9Dr1YG/TRvJB2DerLO7WAVYWVmuuFgx3R
         vEJBzhyA3NWbsaehA2px5aKlQ1HMldQmYkbJRj/47yiTBiSp6z+uddX6Fg3q1+nT6uGN
         zZUUrsW9jc5CvILENEQrG4uEtQjL3u09HtSVCR6lGco69aKF992I1BMUJA1wP8jd5lDK
         tPD83lGglNHhD1SKSdHZycLKIkCo1PL+Qy/cO5MwEp4JbnWWXP1SB3MbzZ8huTo9unyY
         uQqhfIW3iQX3Rogq9LTvaXXXmn9CksywUFlsXKS73OubijxRcv+XWibCq8vmqdhmRR88
         6a9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1te2TiJLyTiKKKO3+VCdFNHOw4n57n/rfL3rTuqofow=;
        b=V+4qGFPs93eami3aVcASHrghKFQhv+OsAwyAz7TaGcV086sdxz8L4/li2VHt7NJMik
         +6xiWFxCOresnUI5d+D5gStHJy3kQ6mKQLQ02t4lacXQQaZR/MSS1ZybpTfrj/mCG9r+
         gJuyChcMknL6c+hsKIKQuo1NxiZL3B4KtbmL0YN5a2sjEEOB5o+p7Hlq9x83tiDmx5hN
         mqq67EZ6Q7NJUuPels+FeE2lpEI9ekOdG7JW0hCNCv9xRxKOuwgZiujZBZl0eolG55Wh
         lGW6eQLg0ua9dihGqCFdRwaSI9ZXTekvyp6U3kr44+969enepUUX4EDlZ0pNV7WEdhrw
         B8Fw==
X-Gm-Message-State: AOAM533hgHRDxiDHCbRP2w/GcHJWNl8uZwX8UWDtcU9iOEgQbDdPiIOH
        T6zOUfy/4nTU1fN04IJo+J4=
X-Google-Smtp-Source: ABdhPJwM8k6bqJPUGrnb9gKpKRftGiZC3CPJGKvvNH1wJfE1/RLnxc9PqJJC4HXnH5Guy9e3TGfCzw==
X-Received: by 2002:a05:6a00:2d4:b0:409:6830:f66d with SMTP id b20-20020a056a0002d400b004096830f66dmr877256pft.54.1630473181413;
        Tue, 31 Aug 2021 22:13:01 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 130sm9181819pfy.175.2021.08.31.22.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 22:13:01 -0700 (PDT)
Subject: Re: [PATCH v6] ixgbe: let the xdpdrv work with more than 64 cpus
To:     kerneljasonxing@gmail.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        kernel test robot <lkp@intel.com>,
        Shujin Li <lishujin@kuaishou.com>
References: <20210901044933.47230-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7ca5bca6-16eb-4102-0b29-504edb80a21b@gmail.com>
Date:   Tue, 31 Aug 2021 22:12:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210901044933.47230-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/21 9:49 PM, kerneljasonxing@gmail.com wrote:
> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> server is equipped with more than 64 cpus online. So it turns out that
> the loading of xdpdrv causes the "NOMEM" failure.
> 
> Actually, we can adjust the algorithm and then make it work through
> mapping the current cpu to some xdp ring with the protect of @tx_lock.
> 
> Here're some numbers before/after applying this patch with xdp-example
> loaded on the eth0X:
> 
> As client (tx path):
>                      Before    After
> TCP_STREAM send-64   734.14    714.20
> TCP_STREAM send-128  1401.91   1395.05
> TCP_STREAM send-512  5311.67   5292.84
> TCP_STREAM send-1k   9277.40   9356.22 (not stable)
> TCP_RR     send-1    22559.75  21844.22
> TCP_RR     send-128  23169.54  22725.13
> TCP_RR     send-512  21670.91  21412.56
> 
> As server (rx path):
>                      Before    After
> TCP_STREAM send-64   1416.49   1383.12
> TCP_STREAM send-128  3141.49   3055.50
> TCP_STREAM send-512  9488.73   9487.44
> TCP_STREAM send-1k   9491.17   9356.22 (not stable)
> TCP_RR     send-1    23617.74  23601.60
> ...
> 
> Notice: the TCP_RR mode is unstable as the official document explaines.
> 
> I tested many times with different parameters combined through netperf.
> Though the result is not that accurate, I cannot see much influence on
> this patch. The static key is places on the hot path, but it actually
> shouldn't cause a huge regression theoretically.
> 
> Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> Reported-by: kernel test robot <lkp@intel.com>
> Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
> v6:
> - Move the declaration of static-key to the proper position (Test Robot)
> - Add reported-by tag (Jason)
> - Add more detailed performance test results (Jason)
> 
> v5:
> - Change back to nr_cpu_ids (Eric)
> 
> v4:
> - Update the wrong commit messages. (Jason)
> 
> v3:
> - Change nr_cpu_ids to num_online_cpus() (Maciej)
> - Rename MAX_XDP_QUEUES to IXGBE_MAX_XDP_QS (Maciej)
> - Rename ixgbe_determine_xdp_cpu() to ixgbe_determine_xdp_q_idx() (Maciej)
> - Wrap ixgbe_xdp_ring_update_tail() with lock into one function (Maciej)
> 
> v2:
> - Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
> - Add a fallback path. (Maciej)
> - Adjust other parts related to xdp ring.
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h           | 15 ++++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  9 ++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 64 ++++++++++++++++------
>  .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |  1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  9 +--
>  5 files changed, 73 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index a604552..1dcddea 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> @@ -351,6 +351,7 @@ struct ixgbe_ring {
>  	};
>  	u16 rx_offset;
>  	struct xdp_rxq_info xdp_rxq;
> +	spinlock_t tx_lock;	/* used in XDP mode */
>  	struct xsk_buff_pool *xsk_pool;
>  	u16 ring_idx;		/* {rx,tx,xdp}_ring back reference idx */
>  	u16 rx_buf_len;
> @@ -375,11 +376,13 @@ enum ixgbe_ring_f_enum {
>  #define IXGBE_MAX_FCOE_INDICES		8
>  #define MAX_RX_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
>  #define MAX_TX_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
> -#define MAX_XDP_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
> +#define IXGBE_MAX_XDP_QS		(IXGBE_MAX_FDIR_INDICES + 1)
>  #define IXGBE_MAX_L2A_QUEUES		4
>  #define IXGBE_BAD_L2A_QUEUE		3
>  #define IXGBE_MAX_MACVLANS		63
>  
> +DECLARE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
> +
>  struct ixgbe_ring_feature {
>  	u16 limit;	/* upper limit on feature indices */
>  	u16 indices;	/* current value of indices */
> @@ -629,7 +632,7 @@ struct ixgbe_adapter {
>  
>  	/* XDP */
>  	int num_xdp_queues;
> -	struct ixgbe_ring *xdp_ring[MAX_XDP_QUEUES];
> +	struct ixgbe_ring *xdp_ring[IXGBE_MAX_XDP_QS];
>  	unsigned long *af_xdp_zc_qps; /* tracks AF_XDP ZC enabled rings */
>  
>  	/* TX */
> @@ -772,6 +775,14 @@ struct ixgbe_adapter {
>  #endif /* CONFIG_IXGBE_IPSEC */
>  };
>  
> +static inline int ixgbe_determine_xdp_q_idx(int cpu)
> +{
> +	if (static_key_enabled(&ixgbe_xdp_locking_key))
> +		return cpu % IXGBE_MAX_XDP_QS;
> +	else
> +		return cpu;
> +}
> +
>  static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
>  {
>  	switch (adapter->hw.mac.type) {
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> index 0218f6c..86b1116 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> @@ -299,7 +299,10 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
>  
>  static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
>  {
> -	return adapter->xdp_prog ? nr_cpu_ids : 0;
> +	int queues;
> +
> +	queues = min_t(int, IXGBE_MAX_XDP_QS, nr_cpu_ids);
> +	return adapter->xdp_prog ? queues : 0;
>  }
>  
>  #define IXGBE_RSS_64Q_MASK	0x3F
> @@ -947,6 +950,7 @@ static int ixgbe_alloc_q_vector(struct ixgbe_adapter *adapter,
>  		ring->count = adapter->tx_ring_count;
>  		ring->queue_index = xdp_idx;
>  		set_ring_xdp(ring);
> +		spin_lock_init(&ring->tx_lock);
>  
>  		/* assign ring to adapter */
>  		WRITE_ONCE(adapter->xdp_ring[xdp_idx], ring);
> @@ -1032,6 +1036,9 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
>  	adapter->q_vector[v_idx] = NULL;
>  	__netif_napi_del(&q_vector->napi);
>  
> +	if (static_key_enabled(&ixgbe_xdp_locking_key))
> +		static_branch_dec(&ixgbe_xdp_locking_key);
> +
>  	/*
>  	 * after a call to __netif_napi_del() napi may still be used and
>  	 * ixgbe_get_stats64() might access the rings on this vector,
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 14aea40..bec29f5 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -165,6 +165,9 @@ static int ixgbe_notify_dca(struct notifier_block *, unsigned long event,
>  MODULE_DESCRIPTION("Intel(R) 10 Gigabit PCI Express Network Driver");
>  MODULE_LICENSE("GPL v2");
>  
> +DEFINE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
> +EXPORT_SYMBOL(ixgbe_xdp_locking_key);
> +
>  static struct workqueue_struct *ixgbe_wq;
>  
>  static bool ixgbe_check_cfg_remove(struct ixgbe_hw *hw, struct pci_dev *pdev);
> @@ -2422,13 +2425,10 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>  		xdp_do_flush_map();
>  
>  	if (xdp_xmit & IXGBE_XDP_TX) {
> -		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> +		int index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> +		struct ixgbe_ring *ring = adapter->xdp_ring[index];
>  
> -		/* Force memory writes to complete before letting h/w
> -		 * know there are new descriptors to fetch.
> -		 */
> -		wmb();
> -		writel(ring->next_to_use, ring->tail);
> +		ixgbe_xdp_ring_update_tail_locked(ring);
>  	}
>  
>  	u64_stats_update_begin(&rx_ring->syncp);
> @@ -6320,7 +6320,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
>  	if (ixgbe_init_rss_key(adapter))
>  		return -ENOMEM;
>  
> -	adapter->af_xdp_zc_qps = bitmap_zalloc(MAX_XDP_QUEUES, GFP_KERNEL);
> +	adapter->af_xdp_zc_qps = bitmap_zalloc(IXGBE_MAX_XDP_QS, GFP_KERNEL);
>  	if (!adapter->af_xdp_zc_qps)
>  		return -ENOMEM;
>  
> @@ -8539,21 +8539,32 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
>  int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
>  			struct xdp_frame *xdpf)
>  {
> -	struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
>  	struct ixgbe_tx_buffer *tx_buffer;
>  	union ixgbe_adv_tx_desc *tx_desc;
> +	struct ixgbe_ring *ring;
>  	u32 len, cmd_type;
>  	dma_addr_t dma;
> +	int index, ret;
>  	u16 i;
>  
>  	len = xdpf->len;
>  
> -	if (unlikely(!ixgbe_desc_unused(ring)))
> -		return IXGBE_XDP_CONSUMED;
> +	index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> +	ring = adapter->xdp_ring[index];
> +
> +	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +		spin_lock(&ring->tx_lock);
> +
> +	if (unlikely(!ixgbe_desc_unused(ring))) {
> +		ret = IXGBE_XDP_CONSUMED;
> +		goto out;
> +	}
>  
>  	dma = dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
> -	if (dma_mapping_error(ring->dev, dma))
> -		return IXGBE_XDP_CONSUMED;
> +	if (dma_mapping_error(ring->dev, dma)) {
> +		ret = IXGBE_XDP_CONSUMED;
> +		goto out;
> +	}
>  
>  	/* record the location of the first descriptor for this packet */
>  	tx_buffer = &ring->tx_buffer_info[ring->next_to_use];
> @@ -8590,7 +8601,11 @@ int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
>  	tx_buffer->next_to_watch = tx_desc;
>  	ring->next_to_use = i;
>  
> -	return IXGBE_XDP_TX;
> +	ret = IXGBE_XDP_TX;
> +out:
> +	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +		spin_unlock(&ring->tx_lock);
> +	return ret;
>  }
>  
>  netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
> @@ -10130,8 +10145,13 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  			return -EINVAL;
>  	}
>  
> -	if (nr_cpu_ids > MAX_XDP_QUEUES)
> +	/* if the number of cpus is much larger than the maximum of queues,
> +	 * we should stop it and then return with NOMEM like before.
> +	 */
> +	if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
>  		return -ENOMEM;
> +	else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
> +		static_branch_inc(&ixgbe_xdp_locking_key);
>  
>  	old_prog = xchg(&adapter->xdp_prog, prog);
>  	need_reset = (!!prog != !!old_prog);
> @@ -10195,12 +10215,22 @@ void ixgbe_xdp_ring_update_tail(struct ixgbe_ring *ring)
>  	writel(ring->next_to_use, ring->tail);
>  }
>  
> +void ixgbe_xdp_ring_update_tail_locked(struct ixgbe_ring *ring)
> +{
> +	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +		spin_lock(&ring->tx_lock);
> +	ixgbe_xdp_ring_update_tail(ring);
> +	if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> +		spin_unlock(&ring->tx_lock);
> +}

It is not clear why you use a pair of spin_lock()/unlock for each ixgbe_xmit_xdp_ring()
call, plus one other for ixgbe_xdp_ring_update_tail()

I guess this could be factorized to a single spin lock/unlock in ixgbe_xdp_xmit(),
and thus not have this ixgbe_xdp_ring_update_tail_locked() helper ?

> +
>  static int ixgbe_xdp_xmit(struct net_device *dev, int n,
>  			  struct xdp_frame **frames, u32 flags)
>  {
>  	struct ixgbe_adapter *adapter = netdev_priv(dev);
>  	struct ixgbe_ring *ring;
>  	int nxmit = 0;
> +	int index;
>  	int i;
>  
>  	if (unlikely(test_bit(__IXGBE_DOWN, &adapter->state)))
> @@ -10209,10 +10239,12 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>  		return -EINVAL;
>  
> +	index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> +
>  	/* During program transitions its possible adapter->xdp_prog is assigned
>  	 * but ring has not been configured yet. In this case simply abort xmit.
>  	 */
> -	ring = adapter->xdp_prog ? adapter->xdp_ring[smp_processor_id()] : NULL;
> +	ring = adapter->xdp_prog ? adapter->xdp_ring[index] : NULL;
>  	if (unlikely(!ring))
>  		return -ENXIO;
>  
> @@ -10230,7 +10262,7 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
>  	}
>  
>  	if (unlikely(flags & XDP_XMIT_FLUSH))
> -		ixgbe_xdp_ring_update_tail(ring);
> +		ixgbe_xdp_ring_update_tail_locked(ring);
>  
>  	return nxmit;
>  }
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> index 2aeec78..f6426d9 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> @@ -23,6 +23,7 @@ void ixgbe_process_skb_fields(struct ixgbe_ring *rx_ring,
>  void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
>  		  struct sk_buff *skb);
>  void ixgbe_xdp_ring_update_tail(struct ixgbe_ring *ring);
> +void ixgbe_xdp_ring_update_tail_locked(struct ixgbe_ring *ring);
>  void ixgbe_irq_rearm_queues(struct ixgbe_adapter *adapter, u64 qmask);
>  
>  void ixgbe_txrx_ring_disable(struct ixgbe_adapter *adapter, int ring);
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index b1d22e4..82d00e4 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -334,13 +334,10 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>  		xdp_do_flush_map();
>  
>  	if (xdp_xmit & IXGBE_XDP_TX) {
> -		struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> +		int index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> +		struct ixgbe_ring *ring = adapter->xdp_ring[index];
>  
> -		/* Force memory writes to complete before letting h/w
> -		 * know there are new descriptors to fetch.
> -		 */
> -		wmb();
> -		writel(ring->next_to_use, ring->tail);
> +		ixgbe_xdp_ring_update_tail_locked(ring);
>  	}
>  
>  	u64_stats_update_begin(&rx_ring->syncp);
> 
