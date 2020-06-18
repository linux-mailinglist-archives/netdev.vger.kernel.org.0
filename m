Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3223E1FFADA
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgFRSNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 14:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgFRSNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 14:13:00 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0824BC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:13:00 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ne5so2879343pjb.5
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gJUG2Pdy/tKJvFcLeHbyJopcRMUXloKwQ9UhgowmyyY=;
        b=NuCe+I447QC60XptrJdB8teGY25EKDvMAhdDYYg1V+VhkXjnsCyx0lefw8Nd4438Y9
         F1BJkTC//W3qZY0uoo1E+JMfgZZbCCLyN5VuaSSp8tFUYA6vc4Of6pq4VXBKpEelypDq
         2MkenK7/MEhLrsUMWXgoKF/Ya36RVQQG25XSCy6bmOzRavI8Qa9/rLrqZ0J6Z9EXwKpm
         A460JcgrbVdHGz5AZRldqfWHW/SBanusKYnDB/cOTrtGdm5Q/NoHnv4d6/Ox120EuQtd
         Khd2nXAbqEEYsCOBgLeLc+P190SSuG8aYyyZs3XXGkPE8Bq7uRVDqnj9u3qsE3rH6Ows
         kURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gJUG2Pdy/tKJvFcLeHbyJopcRMUXloKwQ9UhgowmyyY=;
        b=sXu2o0wgmNMirMw4J4uFmxjifgDB7FH8OolgkWrQopRZMjU/SoIDRb/0tnMuq++H8v
         g0Fa33l9iFqpA85C2lVHF64e8FwsbcmkJpdrOfGiVRUzozuFevHmlgTZ/Ok/5Iz3jwad
         AOm/uOAvIV3u9TTRdetgfQ6x+3qSrSUuJjS47o3OB0ZY1gplkf8YJHLX27oSp5PjGaqF
         2eGDXMfViYY35nWOFgCdBCa8JoewGg9CT8cWIYPqvkcyz8ByD7p7LaH1I/5inRNm/83g
         5ep2ZS4fwTcJps2tR7hRAwIzV9qba5erlkP2vcqoBW2mQIyWiAt+SZnMxidHg0cAfLCv
         F4Hg==
X-Gm-Message-State: AOAM531q75TaIpdg/75GsfKxfTmk8LOrGP9hAO/6Gci7y1A2If54w+kR
        s7oTvavaE+mGlLBnYNj+9oA=
X-Google-Smtp-Source: ABdhPJyl+F/QCvJ9ZjweO4xXDa2/wtRjQnrWWo4vBACwtrQ2XvGT+p83hgt6hil+fu/+8LQ6fBLfDQ==
X-Received: by 2002:a17:902:b496:: with SMTP id y22mr4784593plr.224.1592503979382;
        Thu, 18 Jun 2020 11:12:59 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z144sm3746707pfc.195.2020.06.18.11.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 11:12:58 -0700 (PDT)
Subject: Re: [RFC PATCH 06/21] mlx5: add header_split flag
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     kernel-team@fb.com, axboe@kernel.dk,
        Govindarajulu Varadarajan <gvaradar@cisco.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
 <20200618160941.879717-7-jonathan.lemon@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4b0e0916-2910-373c-82cf-d912a82502a4@gmail.com>
Date:   Thu, 18 Jun 2020 11:12:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200618160941.879717-7-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 9:09 AM, Jonathan Lemon wrote:
> Adds a "rx_hd_split" private flag parameter to ethtool.
> 
> This enables header splitting, and sets up the fragment mappings.
> The feature is currently only enabled for netgpu channels.

We are using a similar idea (pseudo header split) to implement 4096+(headers) MTU at Google,
to enable TCP RX zerocopy on x86.

Patch for mlx4 has not been sent upstream yet.

For mlx4, we are using a single buffer of 128*(number_of_slots_per_RX_RING),
and 86 bytes for the first frag, so that the payload exactly fits a 4096 bytes page.

(In our case, most of our data TCP packets only have 12 bytes of TCP options)


I suggest that instead of a flag, you use a tunable, that can be set by ethtool,
so that the exact number of bytes can be tuned, instead of hard coded in the driver.

(Patch for the counter part of [1] was resent 10 days ago on netdev@ by Govindarajulu Varadarajan)
(Not sure if this has been merged yet)

[1]

commit f0db9b073415848709dd59a6394969882f517da9
Author: Govindarajulu Varadarajan <_govind@gmx.com>
Date:   Wed Sep 3 03:17:20 2014 +0530

    ethtool: Add generic options for tunables
    
    This patch adds new ethtool cmd, ETHTOOL_GTUNABLE & ETHTOOL_STUNABLE for getting
    tunable values from driver.
    
    Add get_tunable and set_tunable to ethtool_ops. Driver implements these
    functions for getting/setting tunable value.
    
    Signed-off-by: Govindarajulu Varadarajan <_govind@gmx.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>




> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 15 +++++++
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 +++++++++++++++----
>  2 files changed, 52 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index ec5658bbe3c5..a1b5d8b33b0b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -1905,6 +1905,20 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
>  	return err;
>  }
>  
> +static int set_pflag_rx_hd_split(struct net_device *netdev, bool enable)
> +{
> +	struct mlx5e_priv *priv = netdev_priv(netdev);
> +	int err;
> +
> +	priv->channels.params.hd_split = enable;
> +	err = mlx5e_safe_reopen_channels(priv);
> +	if (err)
> +		netdev_err(priv->netdev,
> +			   "%s failed to reopen channels, err(%d).\n",
> +				__func__, err);
> +	return err;
> +}
> +
>  static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
>  	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
>  	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
> @@ -1912,6 +1926,7 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
>  	{ "rx_striding_rq",      set_pflag_rx_striding_rq },
>  	{ "rx_no_csum_complete", set_pflag_rx_no_csum_complete },
>  	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
> +	{ "rx_hd_split",	 set_pflag_rx_hd_split },
>  };
>  
>  static int mlx5e_handle_pflag(struct net_device *netdev,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index a836a02a2116..cc8d30aa8a33 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -123,7 +123,8 @@ bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
>  
>  void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
>  {
> -	params->rq_wq_type = mlx5e_striding_rq_possible(mdev, params) &&
> +	params->rq_wq_type = MLX5E_HD_SPLIT(params) ? MLX5_WQ_TYPE_CYCLIC :
> +		mlx5e_striding_rq_possible(mdev, params) &&
>  		MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) ?
>  		MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ :
>  		MLX5_WQ_TYPE_CYCLIC;
> @@ -323,6 +324,8 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
>  				if (prev)
>  					prev->last_in_page = true;
>  			}
> +			next_frag.di->netgpu_source =
> +						!!frag_info[f].frag_source;
>  			*frag = next_frag;
>  
>  			/* prepare next */
> @@ -373,6 +376,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>  	struct mlx5_core_dev *mdev = c->mdev;
>  	void *rqc = rqp->rqc;
>  	void *rqc_wq = MLX5_ADDR_OF(rqc, rqc, wq);
> +	bool hd_split = MLX5E_HD_SPLIT(params) && (umem == (void *)0x1);
> +	u32 num_xsk_frames = 0;
>  	u32 rq_xdp_ix;
>  	u32 pool_size;
>  	int wq_sz;
> @@ -391,9 +396,10 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>  	rq->mdev    = mdev;
>  	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
>  	rq->xdpsq   = &c->rq_xdpsq;
> -	rq->umem    = umem;
> +	if (xsk)
> +		rq->umem    = umem;
>  
> -	if (rq->umem)
> +	if (umem)
>  		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
>  	else
>  		rq->stats = &c->priv->channel_stats[c->ix].rq;
> @@ -404,14 +410,18 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>  	rq->xdp_prog = params->xdp_prog;
>  
>  	rq_xdp_ix = rq->ix;
> -	if (xsk)
> +	if (umem)
>  		rq_xdp_ix += params->num_channels * MLX5E_RQ_GROUP_XSK;
>  	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix);
>  	if (err < 0)
>  		goto err_rq_wq_destroy;
>  
> +	if (umem == (void *)0x1)
> +		rq->buff.headroom = 0;
> +	else
> +		rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
> +
>  	rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> -	rq->buff.headroom = mlx5e_get_rq_headroom(mdev, params, xsk);
>  	pool_size = 1 << params->log_rq_mtu_frames;
>  
>  	switch (rq->wq_type) {
> @@ -509,6 +519,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>  
>  		rq->wqe.skb_from_cqe = xsk ?
>  			mlx5e_xsk_skb_from_cqe_linear :
> +			hd_split ? mlx5e_skb_from_cqe_nonlinear :
>  			mlx5e_rx_is_linear_skb(params, NULL) ?
>  				mlx5e_skb_from_cqe_linear :
>  				mlx5e_skb_from_cqe_nonlinear;
> @@ -2035,13 +2046,19 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
>  	int frag_size_max = DEFAULT_FRAG_SIZE;
>  	u32 buf_size = 0;
>  	int i;
> +	bool hd_split = MLX5E_HD_SPLIT(params) && xsk;
> +
> +	if (hd_split)
> +		frag_size_max = HD_SPLIT_DEFAULT_FRAG_SIZE;
> +	else
> +		frag_size_max = DEFAULT_FRAG_SIZE;
>  
>  #ifdef CONFIG_MLX5_EN_IPSEC
>  	if (MLX5_IPSEC_DEV(mdev))
>  		byte_count += MLX5E_METADATA_ETHER_LEN;
>  #endif
>  
> -	if (mlx5e_rx_is_linear_skb(params, xsk)) {
> +	if (!hd_split && mlx5e_rx_is_linear_skb(params, xsk)) {
>  		int frag_stride;
>  
>  		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
> @@ -2059,6 +2076,16 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
>  		frag_size_max = PAGE_SIZE;
>  
>  	i = 0;
> +
> +	if (hd_split) {
> +		// Start with one fragment for all headers (implementing HDS)
> +		info->arr[0].frag_size = TOTAL_HEADERS;
> +		info->arr[0].frag_stride = roundup_pow_of_two(PAGE_SIZE);
> +		buf_size += TOTAL_HEADERS;
> +		// Now, continue with the payload frags.
> +		i = 1;
> +	}
> +
>  	while (buf_size < byte_count) {
>  		int frag_size = byte_count - buf_size;
>  
> @@ -2066,8 +2093,10 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
>  			frag_size = min(frag_size, frag_size_max);
>  
>  		info->arr[i].frag_size = frag_size;
> -		info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
> -
> +		info->arr[i].frag_stride = roundup_pow_of_two(hd_split ?
> +							      PAGE_SIZE :
> +							      frag_size);
> +		info->arr[i].frag_source = hd_split;
>  		buf_size += frag_size;
>  		i++;
>  	}
> 
