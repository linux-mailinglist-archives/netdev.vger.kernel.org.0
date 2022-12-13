Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63C264B19E
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbiLMI4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiLMI4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:56:50 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1DE103;
        Tue, 13 Dec 2022 00:56:49 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s5so16707227edc.12;
        Tue, 13 Dec 2022 00:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vD7l0fUYqcJCtpTMlWZg37cbVxsGWj34X8MRkehm6mE=;
        b=SHBmyU+b2lRK80rBZEfIcDaHopEHdBDTjcH5vIcM/zOmnRcsy3669BEm6EiCEJQ+J5
         n7BKvUJJsmQrdje6HL5S3EN9LOhY3FEmflH+T5cc8dFGBFFAX2vfp91vV9gACoH5mdej
         Zz0Ccvy2JYz0rlgADxXP/UtuH9ozHFfsdqwnQL+MP9pMXHFmVnJBsg27RSizYW7e6G0U
         V+jxdpWzb5mm7rATT/+qBnLeNYcrSfL7JJ2nSqvQbO1nR7WIo4CkejoGSk1Vh7KKH+B+
         oAGRtPXUm+0VToZEOiADceMC6j+cPejGQO2/bMS/nK5hc02sItbA1/HTDDn26bBoug3p
         IfSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vD7l0fUYqcJCtpTMlWZg37cbVxsGWj34X8MRkehm6mE=;
        b=uX7DKPOxdiSWlrnxMn1qxOfSBvjdG1nZ+vpDgyKGAhR8DRWHM/9T7dzZg7DqDZnoZP
         PX7eW91v2Kfa86Ls9v2NdNQWlgc3HOCCufZFasJSmG1Alr6h3kH650SwLyDOunDUQIgw
         KOZL7Jr+f1JhcRhZpF6jLJ8XRYNYEyzZtsW3pDLBAx8FM5B4C8/w7TpnV29ZJm0A7lVQ
         1v4rAMa7wvkTiHnlD3ksfCazkunWB2A/PJUm/T5A+zBK8gVHJr7i58icpAqCrb9w0bxW
         xnTak4xgj8+z/Stb/8DkaTpp+jUGAZwu8TJa+uc8nvYj1j8d/58uD6hVBUyYjiBIAYzq
         7Y6w==
X-Gm-Message-State: ANoB5pnM4Iv4XpurFkP3yLosgfPFg3IdgbrzFjLyQT+h6c5LMPZLBRaX
        57ZN3XOarc/DrVbWNsy4++o=
X-Google-Smtp-Source: AA0mqf5sTX3/VfOMIcXu2bJVQJEQJ0z10LnHjIfefARxqoACw3p2aVbTEcawRtMF2xH3N/bdUlEyJA==
X-Received: by 2002:a05:6402:5486:b0:461:aeeb:9ce1 with SMTP id fg6-20020a056402548600b00461aeeb9ce1mr16590533edb.32.1670921807545;
        Tue, 13 Dec 2022 00:56:47 -0800 (PST)
Received: from [192.168.1.115] ([77.124.106.18])
        by smtp.gmail.com with ESMTPSA id j5-20020aa7ca45000000b0046bf7ebbbadsm4672327edt.42.2022.12.13.00.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 00:56:46 -0800 (PST)
Message-ID: <a45cc7b7-8691-ff39-ddf8-df8fc7e6ab7c@gmail.com>
Date:   Tue, 13 Dec 2022 10:56:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH bpf-next v4 11/15] net/mlx4_en: Support RX XDP metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-12-sdf@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221213023605.737383-12-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/2022 4:36 AM, Stanislav Fomichev wrote:
> RX timestamp and hash for now. Tested using the prog from the next
> patch.
> 
> Also enabling xdp metadata support; don't see why it's disabled,
> there is enough headroom..
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_clock.c | 13 +++++---
>   .../net/ethernet/mellanox/mlx4/en_netdev.c    |  6 ++++
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 33 ++++++++++++++++++-
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  5 +++
>   4 files changed, 52 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> index 98b5ffb4d729..9e3b76182088 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
> @@ -58,9 +58,7 @@ u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
>   	return hi | lo;
>   }
>   
> -void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> -			    struct skb_shared_hwtstamps *hwts,
> -			    u64 timestamp)
> +u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp)
>   {
>   	unsigned int seq;
>   	u64 nsec;
> @@ -70,8 +68,15 @@ void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>   		nsec = timecounter_cyc2time(&mdev->clock, timestamp);
>   	} while (read_seqretry(&mdev->clock_lock, seq));
>   
> +	return ns_to_ktime(nsec);
> +}
> +
> +void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> +			    struct skb_shared_hwtstamps *hwts,
> +			    u64 timestamp)
> +{
>   	memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
> -	hwts->hwtstamp = ns_to_ktime(nsec);
> +	hwts->hwtstamp = mlx4_en_get_hwtstamp(mdev, timestamp);
>   }
>   
>   /**
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> index 8800d3f1f55c..af4c4858f397 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> @@ -2889,6 +2889,11 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
>   	.ndo_bpf		= mlx4_xdp,
>   };
>   
> +static const struct xdp_metadata_ops mlx4_xdp_metadata_ops = {
> +	.xmo_rx_timestamp		= mlx4_en_xdp_rx_timestamp,
> +	.xmo_rx_hash			= mlx4_en_xdp_rx_hash,
> +};
> +
>   struct mlx4_en_bond {
>   	struct work_struct work;
>   	struct mlx4_en_priv *priv;
> @@ -3310,6 +3315,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
>   		dev->netdev_ops = &mlx4_netdev_ops_master;
>   	else
>   		dev->netdev_ops = &mlx4_netdev_ops;
> +	dev->xdp_metadata_ops = &mlx4_xdp_metadata_ops;
>   	dev->watchdog_timeo = MLX4_EN_WATCHDOG_TIMEOUT;
>   	netif_set_real_num_tx_queues(dev, priv->tx_ring_num[TX]);
>   	netif_set_real_num_rx_queues(dev, priv->rx_ring_num);
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 014a80af2813..0869d4fff17b 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -663,8 +663,35 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
>   
>   struct mlx4_en_xdp_buff {
>   	struct xdp_buff xdp;
> +	struct mlx4_cqe *cqe;
> +	struct mlx4_en_dev *mdev;
> +	struct mlx4_en_rx_ring *ring;
> +	struct net_device *dev;
>   };
>   
> +int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
> +{
> +	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
> +
> +	if (unlikely(_ctx->ring->hwtstamp_rx_filter != HWTSTAMP_FILTER_ALL))
> +		return -EOPNOTSUPP;
> +
> +	*timestamp = mlx4_en_get_hwtstamp(_ctx->mdev,
> +					  mlx4_en_get_cqe_ts(_ctx->cqe));
> +	return 0;
> +}
> +
> +int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
> +{
> +	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
> +
> +	if (unlikely(!(_ctx->dev->features & NETIF_F_RXHASH)))
> +		return -EOPNOTSUPP;
> +
> +	*hash = be32_to_cpu(_ctx->cqe->immed_rss_invalid);
> +	return 0;
> +}
> +
>   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
>   {
>   	struct mlx4_en_priv *priv = netdev_priv(dev);
> @@ -781,8 +808,12 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   						DMA_FROM_DEVICE);
>   
>   			xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
> -					 frags[0].page_offset, length, false);
> +					 frags[0].page_offset, length, true);
>   			orig_data = mxbuf.xdp.data;
> +			mxbuf.cqe = cqe;
> +			mxbuf.mdev = priv->mdev;
> +			mxbuf.ring = ring;
> +			mxbuf.dev = dev;
>   
>   			act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> index e132ff4c82f2..2f8ef0b30083 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -788,10 +788,15 @@ void mlx4_en_update_pfc_stats_bitmap(struct mlx4_dev *dev,
>   int mlx4_en_netdev_event(struct notifier_block *this,
>   			 unsigned long event, void *ptr);
>   
> +struct xdp_md;
> +int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp);
> +int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash);
> +
>   /*
>    * Functions for time stamping
>    */
>   u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe);
> +u64 mlx4_en_get_hwtstamp(struct mlx4_en_dev *mdev, u64 timestamp);
>   void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
>   			    struct skb_shared_hwtstamps *hwts,
>   			    u64 timestamp);


Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
