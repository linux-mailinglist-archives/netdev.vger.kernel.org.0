Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868663F8BA8
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243061AbhHZQTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhHZQTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 12:19:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C08C061757;
        Thu, 26 Aug 2021 09:18:22 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 7so3172299pfl.10;
        Thu, 26 Aug 2021 09:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dOyIpQNn1Wv/pADBDK73i6xsgkcQlLak+x+jp44hVCc=;
        b=bE2i9Y6FpKsaXS3UjsA1KPXFLrFcJMKSvIU8iMbzjz1VFSN5OvDPKLvYbkTeysQFqb
         bqRy8g4xO3osIKTfzDkrb3IWqq9dzZpua8YlIle/aFPPuD5E8zCPXo5BYzgu6XIuJ98a
         2Ss1w8Yg8VvCFyQR3B8t0ja9DInfgSx/mUF208h0bWvaXLG466vd36Vnol54HuZOB10I
         BBKTtz+CAkjvCt1nmy6EhnHpMZIQQ25hA2mSquuBRyHfTA1ZSgY7mWSQLzJR2p//qiFr
         0kJA4VqFibMNUcCQlGBQE9KhG1yv04o2CyFa1AUQS4P52F0GJnm5Jadvby9rLqYinldT
         4fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dOyIpQNn1Wv/pADBDK73i6xsgkcQlLak+x+jp44hVCc=;
        b=KMwL9E5kMoT/ivqCgOKsGAtLSCrUMEwreeZuFANfn3m/VzWCU5AKFM6hI5V70B83JT
         8PPnbeYuMsa3rFLVtSrL2SWgZrhQWbxW6NpPl8IZ2ypwYO/4oKZlTbIZf2583Vb53i86
         T6xzfnzTvczmA1UL3ijdLU31KuNYXULyhOq0rLn1jGWya1a7mC2wH5s56ar+aPSWTyBn
         9kQszpmoPbxq/qy1D/YbF1jtoZIgulNyy4lcVXFW5OX5nC7+VXOAA3qrLkf7302UMfqM
         jpZU3vqi6g+EoV8pUoIBI7m94gjimV5/dCcdqXJRrosOOWtFn7r+pT9tH9oMnPJgEgkN
         uf/Q==
X-Gm-Message-State: AOAM531//VmagdZgiIWR63hwcpITYGcpBwVY3dJ4BcuVDDkKbPA+AUri
        Vqh/DAev4jVS5i7ETGWDrLssD1p2otg=
X-Google-Smtp-Source: ABdhPJwcKlndbk9gwN6SyO3+bdthDmcnVOq1T77Rx4GVlTCUYigx9bEWdomUjGHW032/Qu8CChs9QA==
X-Received: by 2002:a63:cf44:: with SMTP id b4mr3892793pgj.215.1629994702325;
        Thu, 26 Aug 2021 09:18:22 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b7sm1525236pgs.64.2021.08.26.09.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 09:18:21 -0700 (PDT)
Subject: Re: [PATCH v4] ixgbe: let the xdpdrv work with more than 64 cpus
To:     kerneljasonxing@gmail.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
References: <20210826141623.8151-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <00890ff4-3264-337a-19cc-521a6434d1d0@gmail.com>
Date:   Thu, 26 Aug 2021 09:18:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210826141623.8151-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/21 7:16 AM, kerneljasonxing@gmail.com wrote:
> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> server is equipped with more than 64 cpus online. So it turns out that
> the loading of xdpdrv causes the "NOMEM" failure.
> 
> Actually, we can adjust the algorithm and then make it work through
> mapping the current cpu to some xdp ring with the protect of @tx_lock.
> 
> v4:
> - Update the wrong commit messages. (Jason)
> 
> v3:
> - Change nr_cpu_ids to num_online_cpus() (Maciej)

I suspect this is wrong.

> - Rename MAX_XDP_QUEUES to IXGBE_MAX_XDP_QS (Maciej)
> - Rename ixgbe_determine_xdp_cpu() to ixgbe_determine_xdp_q_idx() (Maciej)
> - Wrap ixgbe_xdp_ring_update_tail() with lock into one function (Maciej)
> 
> v2:
> - Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
> - Add a fallback path. (Maciej)
> - Adjust other parts related to xdp ring.
> 
> Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h           | 15 ++++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  9 ++-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 64 ++++++++++++++++------
>  .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |  1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  9 +--
>  5 files changed, 73 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index a604552..5f7f181 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> @@ -82,6 +82,8 @@
>  #define IXGBE_2K_TOO_SMALL_WITH_PADDING \
>  ((NET_SKB_PAD + IXGBE_RXBUFFER_1536) > SKB_WITH_OVERHEAD(IXGBE_RXBUFFER_2K))
>  
> +DECLARE_STATIC_KEY_FALSE(ixgbe_xdp_locking_key);
> +
>  static inline int ixgbe_compute_pad(int rx_buf_len)
>  {
>  	int page_size, pad_size;
> @@ -351,6 +353,7 @@ struct ixgbe_ring {
>  	};
>  	u16 rx_offset;
>  	struct xdp_rxq_info xdp_rxq;
> +	spinlock_t tx_lock;	/* used in XDP mode */
>  	struct xsk_buff_pool *xsk_pool;
>  	u16 ring_idx;		/* {rx,tx,xdp}_ring back reference idx */
>  	u16 rx_buf_len;
> @@ -375,7 +378,7 @@ enum ixgbe_ring_f_enum {
>  #define IXGBE_MAX_FCOE_INDICES		8
>  #define MAX_RX_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
>  #define MAX_TX_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
> -#define MAX_XDP_QUEUES			(IXGBE_MAX_FDIR_INDICES + 1)
> +#define IXGBE_MAX_XDP_QS		(IXGBE_MAX_FDIR_INDICES + 1)
>  #define IXGBE_MAX_L2A_QUEUES		4
>  #define IXGBE_BAD_L2A_QUEUE		3
>  #define IXGBE_MAX_MACVLANS		63
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

Even if num_online_cpus() is 8, the returned cpu here could be

0, 32, 64, 96, 128, 161, 197, 224

Are we sure this will still be ok ?

> +}
> +
>  static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
>  {
>  	switch (adapter->hw.mac.type) {
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> index 0218f6c..884bf99 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> @@ -299,7 +299,10 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
>  
>  static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
>  {
> -	return adapter->xdp_prog ? nr_cpu_ids : 0;
> +	int queues;
> +
> +	queues = min_t(int, IXGBE_MAX_XDP_QS, num_online_cpus());

num_online_cpus() might change later...




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
>


