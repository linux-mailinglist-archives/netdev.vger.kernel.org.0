Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E3266140C
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 08:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjAHHid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 02:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjAHHib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 02:38:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001B5BE13;
        Sat,  7 Jan 2023 23:38:28 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qk9so12851428ejc.3;
        Sat, 07 Jan 2023 23:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kv54G9yei7cxwSz6jWUhSY6/zSNgzi3WeKu2VeIGgnw=;
        b=WIHR5dMR5uJ6lAtOaIUlhigYzvPE+VyhvxWr905s+CS37HLLWbRTS8bPl0/Dk9rugd
         C7lH3C63uqCtIh4EdLEFrguxaej6LzYBwPqeMMhGHZizb+7oIaoFic7qUUlT7tTV22Kg
         YimtD702dSZdmNeW9jl9+95Ka2bMy0E61xB7kG9uPBCdkU46x04da3xzFKMNwDCBPxp9
         U/t2cdb+nIiyhx09btDSv4i/WNXesdFSHsD0+Rcnkz3mQQcs8n37L5Gx6EicwtCA4sNZ
         L4Gwof8BspNkfqDG9kHsQ6Fm55HNK1pgvMA2/qNSiJTLYs00McufLYSlcISkDDXDmBXs
         ZgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kv54G9yei7cxwSz6jWUhSY6/zSNgzi3WeKu2VeIGgnw=;
        b=0L9O/U7ldqqtTrRAJxiW8YG76mSIk8PHl6S+P5Rnf02IDzaVoylTPLRr8RLRW3zDzV
         axiHsbLYby9eXTHklJie24pOUeInppprHWoarsa+G/TBgt50RvH4dBAqbv8OPCsSDAUy
         bHYfKrw/9fLJYMWJ4LUDfCIOnFjq6i5JKM/2iGm0Ql7lpAIbVbKSRkkp1/wnjAB3Ztuh
         1TLC4vPKx1a0n1mpEkWk2gdVh7BJKp8mw2TkI1Xqm7chdeCGNoHIJ/J0B7xzrDN6oC4K
         vUW8/W9mJDMJlG06IzlnYnRyK9IrFmEsZ2JL+eJdW/PJUberLeO1fm664W7oTXFX/ZwD
         nU2Q==
X-Gm-Message-State: AFqh2kohe+6Fch8fU5HZmWip1SNGAnpb5CzU031+kWaBuOQaRBc5RYQb
        dHcCe5RHt7v9UStWSNnl0JA=
X-Google-Smtp-Source: AMrXdXuypfJnm2L29PLGQxv6ffEPNHSKevc1Da6TQzdBbpNlIAqMiQa9KCkM8AB+v47xxFwmXtmn3w==
X-Received: by 2002:a17:907:c388:b0:849:e96f:51f4 with SMTP id tm8-20020a170907c38800b00849e96f51f4mr44341378ejc.23.1673163507446;
        Sat, 07 Jan 2023 23:38:27 -0800 (PST)
Received: from [192.168.0.105] ([77.126.9.245])
        by smtp.gmail.com with ESMTPSA id b6-20020a17090630c600b007c0d0dad9c6sm2237487ejb.108.2023.01.07.23.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jan 2023 23:38:26 -0800 (PST)
Message-ID: <9ea66b5b-f2e7-f2cb-ef1c-a01274f111b0@gmail.com>
Date:   Sun, 8 Jan 2023 09:38:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v6 16/17] net/mlx5e: Support RX XDP metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20230104215949.529093-1-sdf@google.com>
 <20230104215949.529093-17-sdf@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230104215949.529093-17-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/01/2023 23:59, Stanislav Fomichev wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
> pointer to the mlx5e_skb_from* functions so it can be retrieved from the
> XDP ctx to do this.
> 
> Cc: Saeed Mahameed <saeedm@nvidia.com>
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
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Thanks for your patch!
It looks good in general. A few minor comments below.

>   drivers/net/ethernet/mellanox/mlx5/core/en.h  | 10 +++-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 23 +++++++++
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  5 ++
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 10 ++++
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  2 +
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +++
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 51 ++++++++++---------
>   7 files changed, 81 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index af663978d1b4..af0be59b956e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -627,10 +627,11 @@ struct mlx5e_rq;
>   typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64*);
>   typedef struct sk_buff *
>   (*mlx5e_fp_skb_from_cqe_mpwrq)(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
> -			       u16 cqe_bcnt, u32 head_offset, u32 page_idx);
> +			       struct mlx5_cqe64 *cqe, u16 cqe_bcnt,
> +			       u32 head_offset, u32 page_idx);
>   typedef struct sk_buff *
>   (*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
> -			 u32 cqe_bcnt);
> +			 struct mlx5_cqe64 *cqe, u32 cqe_bcnt);
>   typedef bool (*mlx5e_fp_post_rx_wqes)(struct mlx5e_rq *rq);
>   typedef void (*mlx5e_fp_dealloc_wqe)(struct mlx5e_rq*, u16);
>   typedef void (*mlx5e_fp_shampo_dealloc_hd)(struct mlx5e_rq*, u16, u16, bool);
> @@ -1036,6 +1037,11 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __always_unused __be16 proto,
>   			   u16 vid);
>   void mlx5e_timestamp_init(struct mlx5e_priv *priv);
>   
> +static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
> +{
> +	return config->rx_filter == HWTSTAMP_FILTER_ALL;
> +}
> +

Fits better here
drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h

>   struct mlx5e_xsk_param;
>   
>   struct mlx5e_rq_param;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index 31bb6806bf5d..d10d31e12ba2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -156,6 +156,29 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
>   	return true;
>   }
>   
> +int mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
> +{
> +	const struct mlx5e_xdp_buff *_ctx = (void *)ctx;
> +
> +	if (unlikely(!mlx5e_rx_hw_stamp(_ctx->rq->tstamp)))
> +		return -EOPNOTSUPP;
> +
> +	*timestamp =  mlx5e_cqe_ts_to_ns(_ctx->rq->ptp_cyc2time,
> +					 _ctx->rq->clock, get_cqe_ts(_ctx->cqe));
> +	return 0;
> +}

There's room for code reuse, with similar use case in mlx5e_build_rx_skb.

> +
> +int mlx5e_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
> +{
> +	const struct mlx5e_xdp_buff *_ctx = (void *)ctx;
> +
> +	if (unlikely(!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH)))
> +		return -EOPNOTSUPP;
> +
> +	*hash = be32_to_cpu(_ctx->cqe->rss_hash_result);
> +	return 0;
> +}
> +
>   /* returns true if packet was consumed by xdp */
>   bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
>   		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mxbuf)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> index 389818bf6833..cb568c62aba0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -46,6 +46,8 @@
>   
>   struct mlx5e_xdp_buff {
>   	struct xdp_buff xdp;
> +	struct mlx5_cqe64 *cqe;
> +	struct mlx5e_rq *rq;
>   };
>   
>   struct mlx5e_xsk_param;
> @@ -60,6 +62,9 @@ void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq);
>   int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
>   		   u32 flags);
>   
> +int mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp);
> +int mlx5e_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash);
> +
>   INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
>   							  struct mlx5e_xmit_data *xdptxd,
>   							  struct skb_shared_info *sinfo,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index 9cff82d764e3..8bf3029abd3c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -49,6 +49,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
>   				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
>   			};
> +			wi->alloc_units[i].mxbuf->rq = rq;
>   		}
>   	} else if (unlikely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_UNALIGNED)) {
>   		for (i = 0; i < batch; i++) {
> @@ -58,6 +59,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   				.key = rq->mkey_be,
>   				.va = cpu_to_be64(addr),
>   			};
> +			wi->alloc_units[i].mxbuf->rq = rq;
>   		}
>   	} else if (likely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE)) {
>   		u32 mapping_size = 1 << (rq->mpwqe.page_shift - 2);
> @@ -81,6 +83,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   				.key = rq->mkey_be,
>   				.va = cpu_to_be64(rq->wqe_overflow.addr),
>   			};
> +			wi->alloc_units[i].mxbuf->rq = rq;
>   		}
>   	} else {
>   		__be32 pad_size = cpu_to_be32((1 << rq->mpwqe.page_shift) -
> @@ -100,6 +103,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   				.va = cpu_to_be64(rq->wqe_overflow.addr),
>   				.bcount = pad_size,
>   			};
> +			wi->alloc_units[i].mxbuf->rq = rq;
>   		}
>   	}
>   
> @@ -230,6 +234,7 @@ static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, struct xdp_b
>   
>   struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   						    struct mlx5e_mpw_info *wi,
> +						    struct mlx5_cqe64 *cqe,
>   						    u16 cqe_bcnt,
>   						    u32 head_offset,
>   						    u32 page_idx)
> @@ -250,6 +255,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   	 */
>   	WARN_ON_ONCE(head_offset);
>   
> +	/* mxbuf->rq is set on allocation, but cqe is per-packet so set it here */
> +	mxbuf->cqe = cqe;
>   	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
>   	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
>   	net_prefetch(mxbuf->xdp.data);
> @@ -284,6 +291,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   
>   struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
>   					      struct mlx5e_wqe_frag_info *wi,
> +					      struct mlx5_cqe64 *cqe,
>   					      u32 cqe_bcnt)
>   {
>   	struct mlx5e_xdp_buff *mxbuf = wi->au->mxbuf;
> @@ -296,6 +304,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
>   	 */
>   	WARN_ON_ONCE(wi->offset);
>   
> +	/* mxbuf->rq is set on allocation, but cqe is per-packet so set it here */
> +	mxbuf->cqe = cqe;
>   	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
>   	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
>   	net_prefetch(mxbuf->xdp.data);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> index 087c943bd8e9..cefc0ef6105d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> @@ -13,11 +13,13 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
>   int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
>   struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   						    struct mlx5e_mpw_info *wi,
> +						    struct mlx5_cqe64 *cqe,
>   						    u16 cqe_bcnt,
>   						    u32 head_offset,
>   						    u32 page_idx);
>   struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
>   					      struct mlx5e_wqe_frag_info *wi,
> +					      struct mlx5_cqe64 *cqe,
>   					      u32 cqe_bcnt);
>   
>   #endif /* __MLX5_EN_XSK_RX_H__ */
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 8d36e2de53a9..2dddb05d2e60 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4913,6 +4913,11 @@ const struct net_device_ops mlx5e_netdev_ops = {
>   #endif
>   };
>   
> +static const struct xdp_metadata_ops mlx5_xdp_metadata_ops = {
> +	.xmo_rx_timestamp		= mlx5e_xdp_rx_timestamp,
> +	.xmo_rx_hash			= mlx5e_xdp_rx_hash,
> +};
> +
>   static u32 mlx5e_choose_lro_timeout(struct mlx5_core_dev *mdev, u32 wanted_timeout)
>   {
>   	int i;
> @@ -5053,6 +5058,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>   	SET_NETDEV_DEV(netdev, mdev->device);
>   
>   	netdev->netdev_ops = &mlx5e_netdev_ops;
> +	netdev->xdp_metadata_ops = &mlx5_xdp_metadata_ops;
>   
>   	mlx5e_dcbnl_build_netdev(netdev);
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index c8a2b26de36e..10d45064e613 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -62,10 +62,12 @@
>   
>   static struct sk_buff *
>   mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
> -				u16 cqe_bcnt, u32 head_offset, u32 page_idx);
> +				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
> +				u32 page_idx);
>   static struct sk_buff *
>   mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
> -				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
> +				   struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
> +				   u32 page_idx);
>   static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
>   static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
>   static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
> @@ -76,11 +78,6 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic = {
>   	.handle_rx_cqe_mpwqe_shampo = mlx5e_handle_rx_cqe_mpwrq_shampo,
>   };
>   
> -static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
> -{
> -	return config->rx_filter == HWTSTAMP_FILTER_ALL;
> -}
> -
>   static inline void mlx5e_read_cqe_slot(struct mlx5_cqwq *wq,
>   				       u32 cqcc, void *data)
>   {
> @@ -1575,16 +1572,19 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
>   	return skb;
>   }
>   
> -static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
> -				u32 len, struct mlx5e_xdp_buff *mxbuf)
> +static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
> +				void *va, u16 headroom, u32 len,
> +				struct mlx5e_xdp_buff *mxbuf)
>   {
>   	xdp_init_buff(&mxbuf->xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
>   	xdp_prepare_buff(&mxbuf->xdp, va, headroom, len, true);
> +	mxbuf->cqe = cqe;
> +	mxbuf->rq = rq;
>   }
>   
>   static struct sk_buff *
>   mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
> -			  u32 cqe_bcnt)
> +			  struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
>   {
>   	union mlx5e_alloc_unit *au = wi->au;
>   	u16 rx_headroom = rq->buff.headroom;
> @@ -1609,7 +1609,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
>   		struct mlx5e_xdp_buff mxbuf;
>   
>   		net_prefetchw(va); /* xdp_frame data area */
> -		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
> +		mlx5e_fill_xdp_buff(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
>   		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
>   			return NULL; /* page/packet was consumed by XDP */
>   
> @@ -1630,7 +1630,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
>   
>   static struct sk_buff *
>   mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
> -			     u32 cqe_bcnt)
> +			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
>   {
>   	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
>   	struct mlx5e_wqe_frag_info *head_wi = wi;
> @@ -1654,7 +1654,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>   	net_prefetchw(va); /* xdp_frame data area */
>   	net_prefetch(va + rx_headroom);
>   
> -	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &mxbuf);
> +	mlx5e_fill_xdp_buff(rq, cqe, va, rx_headroom, frag_consumed_bytes, &mxbuf);
>   	sinfo = xdp_get_shared_info_from_buff(&mxbuf.xdp);
>   	truesize = 0;
>   
> @@ -1777,7 +1777,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
>   			      mlx5e_skb_from_cqe_linear,
>   			      mlx5e_skb_from_cqe_nonlinear,
>   			      mlx5e_xsk_skb_from_cqe_linear,
> -			      rq, wi, cqe_bcnt);
> +			      rq, wi, cqe, cqe_bcnt);
>   	if (!skb) {
>   		/* probably for XDP */
>   		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
> @@ -1830,7 +1830,7 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
>   	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
>   			      mlx5e_skb_from_cqe_linear,
>   			      mlx5e_skb_from_cqe_nonlinear,
> -			      rq, wi, cqe_bcnt);
> +			      rq, wi, cqe, cqe_bcnt);
>   	if (!skb) {
>   		/* probably for XDP */
>   		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
> @@ -1889,7 +1889,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
>   	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
>   			      mlx5e_skb_from_cqe_mpwrq_linear,
>   			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
> -			      rq, wi, cqe_bcnt, head_offset, page_idx);
> +			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
>   	if (!skb)
>   		goto mpwrq_cqe_out;
>   
> @@ -1940,7 +1940,8 @@ mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq,
>   
>   static struct sk_buff *
>   mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
> -				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
> +				   struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
> +				   u32 page_idx)
>   {
>   	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
>   	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
> @@ -1979,7 +1980,8 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
>   
>   static struct sk_buff *
>   mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
> -				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
> +				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
> +				u32 page_idx)
>   {
>   	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
>   	u16 rx_headroom = rq->buff.headroom;
> @@ -2010,7 +2012,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
>   		struct mlx5e_xdp_buff mxbuf;
>   
>   		net_prefetchw(va); /* xdp_frame data area */
> -		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
> +		mlx5e_fill_xdp_buff(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
>   		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
>   			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
>   				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
> @@ -2174,8 +2176,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
>   		if (likely(head_size))
>   			*skb = mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
>   		else
> -			*skb = mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe_bcnt, data_offset,
> -								  page_idx);
> +			*skb = mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe, cqe_bcnt,
> +								  data_offset, page_idx);
>   		if (unlikely(!*skb))
>   			goto free_hd_entry;
>   
> @@ -2249,7 +2251,8 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
>   			      mlx5e_skb_from_cqe_mpwrq_linear,
>   			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
>   			      mlx5e_xsk_skb_from_cqe_mpwrq_linear,
> -			      rq, wi, cqe_bcnt, head_offset, page_idx);
> +			      rq, wi, cqe, cqe_bcnt, head_offset,
> +			      page_idx);
>   	if (!skb)
>   		goto mpwrq_cqe_out;
>   
> @@ -2494,7 +2497,7 @@ static void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
>   	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
>   			      mlx5e_skb_from_cqe_linear,
>   			      mlx5e_skb_from_cqe_nonlinear,
> -			      rq, wi, cqe_bcnt);
> +			      rq, wi, cqe, cqe_bcnt);
>   	if (!skb)
>   		goto wq_free_wqe;
>   
> @@ -2586,7 +2589,7 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
>   		goto free_wqe;
>   	}
>   
> -	skb = mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe_bcnt);
> +	skb = mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe, cqe_bcnt);
>   	if (!skb)
>   		goto free_wqe;
>   
