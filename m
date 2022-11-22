Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FEB633E1D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiKVNud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiKVNu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:50:28 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E89765851;
        Tue, 22 Nov 2022 05:50:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d1so12687565wrs.12;
        Tue, 22 Nov 2022 05:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+2RxZVjn+Kqn8Jxp3X+XGyQFgx1akp5xCh6njJ2sPFk=;
        b=JjjD1XkKFdASsNPZSHEuPZjhLhpXaQ+Nw9q5Njff/LbrpCjHPH8v20iPG1T3N6Q1dx
         +k6YSb7eUpEWJ646ZodbQD+6fkbkx206H/71hCcnmDS9Lr+5grRE6SRsTAN3qOmeP8tG
         gIajY4glhBROAg7arJm56De/7hd5p4GFOWYu8as4RiUYAU01CmcIvNFUWjuO/pe7TZ0+
         MO7dxFaDp70kzXYsBI3dvpRhRL3Z/iz3zVLfXqe1FuNwXW4qyNwc7xKtBguUJa36Krto
         IGPcQHMqhBrrXRLYm7tsh+UxO762W4wjSL26DrfaMebqSGYlTo7w5D4WCI8I5/N4w/Tl
         zcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2RxZVjn+Kqn8Jxp3X+XGyQFgx1akp5xCh6njJ2sPFk=;
        b=X8mJzW4ELt7vvJltXI8+jMoMvIltcvGpJflZaNNqXKjqbl7YBaYEGxlj12Q5Mg5097
         1G8KcfMtx4Hqng1OuD/TNQqOmqk68a0DU0nhvWc1lfoc3biIzJy/vGmM+xGFkMh87Ae1
         p6WQL/PcioGqtX2bKySp5BCNR+hEcRTW22a15ndBLzXk3Ayx91z26fA6vXrKOxNJ2oV1
         +AdO6jZ3UwW1F9Eie41YBFJjH0vmYHi7GBFTjB15HvwTNZ9D/0ovFaWguj/cNBePbYs+
         igjWiZ7PL1Y0uVF6l5OTvRCAA6qVnqHoF7g6/ycEz3TZxVctje/p15r/ohkVgBwIxClO
         1aTQ==
X-Gm-Message-State: ANoB5plZFxXksoyD745lFtfq1yx+wqlhEETi461bmHYpBElRdaAt7i6x
        9Uws/WpHbNTrb0DNWOZ7Yn0=
X-Google-Smtp-Source: AA0mqf5QGdezDzE8VAq+/Ak+BD21TrsJzoC7qm0FCPTlB828kaLZsY4B2TshJSJQ7qaXtmmx5ywuWw==
X-Received: by 2002:a5d:5e87:0:b0:241:e7a6:db08 with SMTP id ck7-20020a5d5e87000000b00241e7a6db08mr665522wrb.349.1669125026995;
        Tue, 22 Nov 2022 05:50:26 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id w19-20020adfbad3000000b00241c6729c2bsm11012241wrg.26.2022.11.22.05.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 05:50:26 -0800 (PST)
Message-ID: <a692f096-bf81-7974-fa66-afbe3d48fb6e@gmail.com>
Date:   Tue, 22 Nov 2022 15:50:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH bpf-next v2 7/8] mxl4: Support RX XDP metadata
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
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-8-sdf@google.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221121182552.2152891-8-sdf@google.com>
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



On 11/21/2022 8:25 PM, Stanislav Fomichev wrote:
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
>   .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 ++++
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 48 ++++++++++++++++++-
>   include/linux/mlx4/device.h                   |  7 +++
>   3 files changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> index 8800d3f1f55c..1cb63746a851 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> @@ -2855,6 +2855,11 @@ static const struct net_device_ops mlx4_netdev_ops = {
>   	.ndo_features_check	= mlx4_en_features_check,
>   	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
>   	.ndo_bpf		= mlx4_xdp,
> +
> +	.ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
> +	.ndo_xdp_rx_timestamp	= mlx4_xdp_rx_timestamp,
> +	.ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
> +	.ndo_xdp_rx_hash	= mlx4_xdp_rx_hash,
>   };
>   
>   static const struct net_device_ops mlx4_netdev_ops_master = {
> @@ -2887,6 +2892,11 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
>   	.ndo_features_check	= mlx4_en_features_check,
>   	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
>   	.ndo_bpf		= mlx4_xdp,
> +
> +	.ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
> +	.ndo_xdp_rx_timestamp	= mlx4_xdp_rx_timestamp,
> +	.ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
> +	.ndo_xdp_rx_hash	= mlx4_xdp_rx_hash,
>   };
>   
>   struct mlx4_en_bond {
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 467356633172..fd14d59f6cbf 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -663,8 +663,50 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
>   
>   struct mlx4_xdp_buff {
>   	struct xdp_buff xdp;
> +	struct mlx4_cqe *cqe;
> +	struct mlx4_en_dev *mdev;
> +	struct mlx4_en_rx_ring *ring;
> +	struct net_device *dev;
>   };
>   
> +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
> +{
> +	struct mlx4_xdp_buff *_ctx = (void *)ctx;
> +
> +	return _ctx->ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL;
> +}
> +
> +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx)
> +{
> +	struct mlx4_xdp_buff *_ctx = (void *)ctx;
> +	unsigned int seq;
> +	u64 timestamp;
> +	u64 nsec;
> +
> +	timestamp = mlx4_en_get_cqe_ts(_ctx->cqe);
> +
> +	do {
> +		seq = read_seqbegin(&_ctx->mdev->clock_lock);
> +		nsec = timecounter_cyc2time(&_ctx->mdev->clock, timestamp);
> +	} while (read_seqretry(&_ctx->mdev->clock_lock, seq));
> +

This is open-code version of mlx4_en_fill_hwtstamps.
Better use the existing function.

> +	return ns_to_ktime(nsec);
> +}
> +
> +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx)
> +{
> +	struct mlx4_xdp_buff *_ctx = (void *)ctx;
> +
> +	return _ctx->dev->features & NETIF_F_RXHASH;
> +}
> +
> +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx)
> +{
> +	struct mlx4_xdp_buff *_ctx = (void *)ctx;
> +
> +	return be32_to_cpu(_ctx->cqe->immed_rss_invalid);
> +}
> +
>   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
>   {
>   	struct mlx4_en_priv *priv = netdev_priv(dev);
> @@ -781,8 +823,12 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
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
> diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> index 6646634a0b9d..d5904da1d490 100644
> --- a/include/linux/mlx4/device.h
> +++ b/include/linux/mlx4/device.h
> @@ -1585,4 +1585,11 @@ static inline int mlx4_get_num_reserved_uar(struct mlx4_dev *dev)
>   	/* The first 128 UARs are used for EQ doorbells */
>   	return (128 >> (PAGE_SHIFT - dev->uar_page_shift));
>   }
> +
> +struct xdp_md;
> +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx);
> +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx);
> +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx);
> +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx);
> +
>   #endif /* MLX4_DEVICE_H */
