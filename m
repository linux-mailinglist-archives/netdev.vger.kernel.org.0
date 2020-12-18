Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF782DDC7D
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 01:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbgLRA6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 19:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgLRA6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 19:58:31 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEE4C0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 16:57:51 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id j20so463460otq.5
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 16:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M/GXJE0BsmK5P/8UPt6aSQZYOVcEb0nfKYYp7qoljXc=;
        b=Xl8sYIhX3iYj7zcnCfaXh8N1QC7FwqLNy9XJAH903Xl1dsF+bBqVjiT7raNV3fgpoz
         JfpqWU+5zPjKhAfYL1ssQ60gNl//2FnrSZLnUuhhFtBSq5CBU9j3xvGq8O26N50chfjG
         3brT31YBMHkK+fOnBrJuUVW2TGGzv6xJcnV50TPaj4PxZokClhC53WdBOhactyZjnFrl
         M7LIkbqNZmqA8ACNB38zi4cHkN1EM70iAJV5e8eqboXQsr21v80S2Wd0qlDCmZVCDqmW
         d/YWV6bZ3q1B64+yMbw77vBIhWfFNLm94qIqZ7llgZEJoFWTGWcdTuD2OAN7uAi8wwKj
         fRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M/GXJE0BsmK5P/8UPt6aSQZYOVcEb0nfKYYp7qoljXc=;
        b=Mbu5cZkXt7ErbvfpiouNTVMhQD33oNkf7Bk0A66H4TXCDc5Ff6AYbk7DSplGkEopcM
         ttLGyNQRba2FCt1o4CEi2+oO/4r9Js1cmo/SLjd1ktK9+dRN03ycR8sk+HnCiVt1TYRG
         A2Al6N7t1t+gCWKR/mKTC8Z3gzyh+zEoxSg0obWAGGBZCXwYoRp32nO8u+fXSkBmunLm
         tui+2XpebqQkqPSVEUPsRs/jTERvyqGoekz57HbZPXrqAeQ0k3/U16St0+dNdxA8yTxd
         rx70nU0cAp3xP7poQLDTUUSwSAiLOncanJ1pf2HyqXDFQHc8kknh3F698m6g4SPrVMiu
         mFmA==
X-Gm-Message-State: AOAM533FguIfmhHBjs6gKZCicjrZAeAuwJ2zwKYT+QyEKbGxT+St8Aso
        Ng9aFDnCVc9fXhHHC4qY6NQ=
X-Google-Smtp-Source: ABdhPJz2bsikSsneQ1POTq/19Qi8HFEGhTTeKwyL6sW1XsGY0FGWILQ9EuNYCfOYoxO9A4vfGLWdKA==
X-Received: by 2002:a9d:4707:: with SMTP id a7mr1186925otf.133.1608253070902;
        Thu, 17 Dec 2020 16:57:50 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id m18sm1616741ooa.24.2020.12.17.16.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 16:57:50 -0800 (PST)
Subject: Re: [PATCH v1 net-next 13/15] net/mlx5e: NVMEoTCP, data-path for DDP
 offload
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-14-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9cc1e367-bf5a-929b-2abe-e368d2109291@gmail.com>
Date:   Thu, 17 Dec 2020 17:57:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207210649.19194-14-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 2:06 PM, Boris Pismenny wrote:
> +struct sk_buff*
> +mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
> +			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt,
> +			     bool linear)
> +{
> +	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
> +	struct mlx5e_priv *priv = netdev_priv(netdev);
> +	skb_frag_t org_frags[MAX_SKB_FRAGS];
> +	struct mlx5e_nvmeotcp_queue *queue;
> +	struct nvmeotcp_queue_entry *nqe;
> +	int org_nr_frags, frag_index;
> +	struct mlx5e_cqe128 *cqe128;
> +	u32 queue_id;
> +
> +	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
> +	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
> +	if (unlikely(!queue)) {
> +		dev_kfree_skb_any(skb);
> +		return NULL;
> +	}
> +
> +	cqe128 = (struct mlx5e_cqe128 *)((char *)cqe - 64);
> +	if (cqe_is_nvmeotcp_resync(cqe)) {
> +		nvmeotcp_update_resync(queue, cqe128);
> +		mlx5e_nvmeotcp_put_queue(queue);
> +		return skb;
> +	}
> +
> +	/* cc ddp from cqe */
> +	ccid = be16_to_cpu(cqe128->ccid);
> +	ccoff = be32_to_cpu(cqe128->ccoff);
> +	cclen = be16_to_cpu(cqe128->cclen);
> +	hlen  = be16_to_cpu(cqe128->hlen);
> +
> +	/* carve a hole in the skb for DDP data */
> +	if (linear) {
> +		skb_trim(skb, hlen);
> +	} else {
> +		org_nr_frags = skb_shinfo(skb)->nr_frags;
> +		mlx5_nvmeotcp_trim_nonlinear(skb, org_frags, &frag_index,
> +					     cclen);
> +	}

mlx5e_skb_from_cqe_mpwrq_linear and mlx5e_skb_from_cqe_mpwrq_nolinear
create an skb and then this function comes behind it, strips any frags
originally added to the skb, ...


> +
> +	nqe = &queue->ccid_table[ccid];
> +
> +	/* packet starts new ccid? */
> +	if (queue->ccid != ccid || queue->ccid_gen != nqe->ccid_gen) {
> +		queue->ccid = ccid;
> +		queue->ccoff = 0;
> +		queue->ccoff_inner = 0;
> +		queue->ccsglidx = 0;
> +		queue->ccid_gen = nqe->ccid_gen;
> +	}
> +
> +	/* skip inside cc until the ccoff in the cqe */
> +	while (queue->ccoff + queue->ccoff_inner < ccoff) {
> +		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
> +		fragsz = min_t(off_t, remaining,
> +			       ccoff - (queue->ccoff + queue->ccoff_inner));
> +
> +		if (fragsz == remaining)
> +			mlx5e_nvmeotcp_advance_sgl_iter(queue);
> +		else
> +			queue->ccoff_inner += fragsz;
> +	}
> +
> +	/* adjust the skb according to the cqe cc */
> +	while (to_copy < cclen) {
> +		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
> +			dev_kfree_skb_any(skb);
> +			mlx5e_nvmeotcp_put_queue(queue);
> +			return NULL;
> +		}
> +
> +		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
> +		fragsz = min_t(int, remaining, cclen - to_copy);
> +
> +		mlx5e_nvmeotcp_add_skb_frag(netdev, skb, queue, nqe, fragsz);
> +		to_copy += fragsz;
> +		if (fragsz == remaining)
> +			mlx5e_nvmeotcp_advance_sgl_iter(queue);
> +		else
> +			queue->ccoff_inner += fragsz;
> +	}

... adds the frags for the sgls, ...

> +
> +	if (cqe_bcnt > hlen + cclen) {
> +		remaining = cqe_bcnt - hlen - cclen;
> +		if (linear)
> +			skb = mlx5_nvmeotcp_add_tail(queue, skb,
> +						     offset_in_page(skb->data) +
> +								hlen + cclen,
> +						     remaining);
> +		else
> +			skb = mlx5_nvmeotcp_add_tail_nonlinear(queue, skb,
> +							       org_frags,
> +							       org_nr_frags,
> +							       frag_index);

... and then re-adds the original frags.

Why is this needed? Why can't the skb be created with all of the frags
in proper order?

It seems like this dance is not needed if you had generic header/payload
splits with the payload written to less retrictive SGLs.
