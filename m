Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC6267C496
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 07:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbjAZGxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 01:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjAZGxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 01:53:33 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDB45C0EF
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:53:31 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d14so742795wrr.9
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4zL7cJCFGJffrCj0tH8lwqTkzAmi6Qx3J2tneJ23BXs=;
        b=Wf44+5sjDUoE7slghNiuUFF1lvRaz8T+tmiMoT3GH+SQPGsQKxivtMeZd7vgdchgeQ
         6FpgMBUMUmP2BsRZ2xawFUwHYtyIdCYLH9WY13aZ5KNCf4t9/JGvJlmboJh7wauuSzB6
         RbNfEjnP/i4R1QgCjgvgX9TJ6fpdbnPAPyEEz9wbo3UwrfP5wIZe0pl3iZFjum5HXPW6
         uNpb929z+zLQFpimzpEMUrk9AcFVhfHNUt1VtLYqRWt2h5ha9xE30MbpBz25qtBpvYC2
         Uz27g+Mdktg0J9Udx9zuj2Mie2Gpo5nR7gMKK1a7Le1N8fKYbtaqgh1J0eb5oF8FuQHm
         ++ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4zL7cJCFGJffrCj0tH8lwqTkzAmi6Qx3J2tneJ23BXs=;
        b=UM2fB4DtnfM5Xb8mj0x7Azbxo8z9MAYzmr7B37Kk4/VES7n6lcrmCdyDLNz0BTqUhp
         LKvS1zh1wtCLUdHudFKILLNHK7pXA1nJE2Oz41k6oPRgyU/4/t4zbggzAf/Mr4UU3XMc
         YuqNNCJJ862vEyAl3DrnQiigaXQGV3nkzO3L+0WheJAqc+JGd97mAFp0/SfEBHDWOMbo
         db5w5dxtNFJyjw0euLoJjdnGVPCZMvriyKi4Og8vHY1Ge51miH/a4j7MlGDIFoY3+g4g
         92P1YHywBHFBbabgJifTT+a/V+9FBSgbO8aHn6flFG2JH/gHPWOlEMEC2Qiwfk9bb+Hf
         obBg==
X-Gm-Message-State: AFqh2kr6wdLDqBvXMqDgHXrzRmA46BoTwJ2vs2zOYSZ22lpEVpKTCM47
        guZ4GbDdBQg62kbA1I38FSU=
X-Google-Smtp-Source: AMrXdXsdcG6PIO+uWIk0Jqr72Qb0Eyr3TL70C/FPCZ0sSSEUlrHHkDM7R7anxr4JdYypNq3bBWo5OA==
X-Received: by 2002:adf:8b1c:0:b0:2bf:9478:a91d with SMTP id n28-20020adf8b1c000000b002bf9478a91dmr16635838wra.39.1674716010207;
        Wed, 25 Jan 2023 22:53:30 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id l15-20020a5d6d8f000000b002bfb37497a8sm433431wrs.31.2023.01.25.22.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 22:53:29 -0800 (PST)
Message-ID: <0d722665-140d-8391-2cab-9a3ef0d5d0e7@gmail.com>
Date:   Thu, 26 Jan 2023 08:53:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo
 use-after-free
Content-Language: en-US
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230126010206.13483-1-vfedorenko@novek.ru>
 <20230126010206.13483-3-vfedorenko@novek.ru>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230126010206.13483-3-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/01/2023 3:02, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@meta.com>
> 
> Fifo pointers were not checked during push and pop operations and this
> could potentially lead to use-after-free or skb leak under heavy PTP
> traffic.
> 
> Also there were OOO cqe spotted which lead to drain of the queue and
> use-after-free because of lack of fifo pointers check. Special check
> is added to avoid resync operation if SKB could not exist in the fifo
> because of OOO cqe (skb_id must be between consumer and producer index).
> 

Hi,

Let's hold on with this patch.
I don't think we understand the root cause. I'm also not sure this patch 
doesn't degrade the successful flow. See comment below.

We don't expect an xmit operation coming from the kernel while the TXQ 
is stopped. This might be the reason for the fifo overflow. Does it 
happen? If so, let's understand why and fix.

Your fix to mlx5e_skb_fifo_has_room() should help with preventing the 
fifo overflow. Does the issue still occur even after your patch [1]?

Also, it's not easy to decisively determine that a CQE arrived OOO. I 
doubt this can happen. The SQ is cyclic and works in-order. It's more 
probably a full cycle of lost CQEs.

BTW, what value do you see in your environment for
MLX5_CAP_GEN_2(mdev, ts_cqe_metadata_size2wqe_counter) ?

Thanks,
Tariq

[1] [PATCH net v3 1/2] mlx5: fix skb leak while fifo resync and push

> Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 23 ++++++++++++++-----
>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  7 +++++-
>   2 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> index b72de2b520ec..4ac7483dcbcc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> @@ -86,7 +86,7 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
>   	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
>   }
>   
> -static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
> +static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
>   					     u16 skb_id, int budget)
>   {
>   	struct skb_shared_hwtstamps hwts = {};
> @@ -94,14 +94,23 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
>   
>   	ptpsq->cq_stats->resync_event++;
>   
> -	while (skb_cc != skb_id) {
> -		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)

This can give false positives near the edge of the fifo (wraparound).

> +		pr_err_ratelimited("mlx5e: out-of-order ptp cqe\n");
> +		return false;
> +	}
> +
> +	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
>   		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>   		skb_tstamp_tx(skb, &hwts);
>   		ptpsq->cq_stats->resync_cqe++;
>   		napi_consume_skb(skb, budget);
>   		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>   	}
> +
> +	if (!skb)
> +		return false;
> +
> +	return true;
>   }
>   
>   static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
> @@ -111,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>   	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
>   	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>   	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
> -	struct sk_buff *skb;
> +	struct sk_buff *skb = NULL;
>   	ktime_t hwtstamp;
>   
>   	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
> @@ -120,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>   		goto out;
>   	}
>   
> -	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
> -		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
> +	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
> +	    !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget)) {
> +		goto out;
> +	}
>   
>   	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>   	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> index 15a5a57b47b8..6e559b856afb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -289,14 +289,19 @@ struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_skb_fifo *fifo, u16 i)
>   static inline
>   void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
>   {
> -	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
> +	struct sk_buff **skb_item;
>   
> +	WARN_ONCE(mlx5e_skb_fifo_has_room(fifo), "ptp fifo overflow");
> +	skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>   	*skb_item = skb;
>   }
>   
>   static inline
>   struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
>   {
> +	if (*fifo->pc == *fifo->cc)
> +		return NULL;
> +
>   	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
>   }
>   
