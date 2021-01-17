Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50582F9176
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbhAQIvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbhAQInG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:43:06 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8863C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 00:42:25 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id rv9so601802ejb.13
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 00:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XjUAlJ/fJQG6dKpcOw5EDZkb1CDW+DPSbLZeYFETED8=;
        b=SWT+2x1wAPNzxu6/HmHh+1wEc0erFBU5/pEdBapNgrv/X3jWFSsmticRMUN6k0rJoY
         VBMkctq3P0HlfYHAhH9qQzxBQ2nKgsaviKEckan4L9TBYVhBbNK1dCgfas9vJSP72e8g
         3Ob3U3urhFW4Stj8Yr+RR5gsR8rsQPvvhCAhFRIy2DlEhd5fHhdUfWO7IGscTb1dgZeY
         qfV1i11nX8cJ/mWUbTl8L+viwpZDiun5wHixHInZxioQXX5JNwubdwSDsan66ZduIrMT
         eiKPysyRufJoUxSvHTHrfkX4hak2Yp1D2CIjLiCyWiPJURZ292HIZSRo1FcKTxvrb51W
         imMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XjUAlJ/fJQG6dKpcOw5EDZkb1CDW+DPSbLZeYFETED8=;
        b=bV/CWvj87ePjgBZdKSDYutketALXjucxHK1Vnbbdp1XCvyZy9m7LSNJccnzQS9jRXf
         Xkpo8pNcQ5J666pMwJKxPJsSXfgYZCMvldWzHAQVSgDQNt9+Czma78+k2Bd+sXQdmmTy
         EWXunYC5uTIeImtrYaK4fp7EtPFHnawH/0VkUIShVi5XQvq3wHG9cd8XKOOmJ5DqkhT/
         btUlxzUo29uVV63gvTUO37/tPO8iYdFT7VvQe4hSqik9t+ivyIm/BgMEY5WzPXAKNlAR
         FF+Lcd6LqP5izFPTGOQLfmTvEFIzY3DmdaqPeydGcvD4Uvvnu/6lV/C9O5biHexsIdKJ
         N1Qg==
X-Gm-Message-State: AOAM533N/ByLNqnAyX5piT6oor7loSP5sDc4u3OCPauQDD8z81Ld2+zP
        G0gyC+do9tEfxIcxGtuDBvg=
X-Google-Smtp-Source: ABdhPJyaztUGq1LZIB3TzyvSnpqxX5ikvtigb3hlB5COiClbf3uJ7ZP5Nq91cXPuRBwvGH2CgIPtHg==
X-Received: by 2002:a17:906:2785:: with SMTP id j5mr9759209ejc.527.1610872944321;
        Sun, 17 Jan 2021 00:42:24 -0800 (PST)
Received: from [132.68.43.120] ([132.68.43.120])
        by smtp.gmail.com with ESMTPSA id bq20sm7886630ejb.64.2021.01.17.00.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 00:42:23 -0800 (PST)
Subject: Re: [PATCH v2 net-next 19/21] net/mlx5e: NVMEoTCP, data-path for DDP
 offload
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
 <20210114151033.13020-20-borisp@mellanox.com>
 <10c28b01-49e5-c512-8670-bf8332b24b1b@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <15248743-82bf-4283-d8c6-99f2210e42ae@gmail.com>
Date:   Sun, 17 Jan 2021 10:42:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <10c28b01-49e5-c512-8670-bf8332b24b1b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2021 6:57, David Ahern wrote:
> I have not had time to review this version of the patches, but this
> patch seems very similar to 13 of 15 from v1 and you did not respond to
> my question on it ...
> 
> On 1/14/21 8:10 AM, Boris Pismenny wrote:
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
>> new file mode 100644
>> index 000000000000..f446b5d56d64
>> --- /dev/null
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
>> @@ -0,0 +1,243 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> +/* Copyright (c) 2021 Mellanox Technologies. */
>> +
>> +#include "en_accel/nvmeotcp_rxtx.h"
>> +#include "en_accel/nvmeotcp.h"
>> +#include <linux/mlx5/mlx5_ifc.h>
>> +
>> +#define	MLX5E_TC_FLOW_ID_MASK  0x00ffffff
>> +static void nvmeotcp_update_resync(struct mlx5e_nvmeotcp_queue *queue,
>> +				   struct mlx5e_cqe128 *cqe128)
>> +{
>> +	const struct tcp_ddp_ulp_ops *ulp_ops;
>> +	u32 seq;
>> +
>> +	seq = be32_to_cpu(cqe128->resync_tcp_sn);
>> +	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
>> +	if (ulp_ops && ulp_ops->resync_request)
>> +		ulp_ops->resync_request(queue->sk, seq, TCP_DDP_RESYNC_REQ);
>> +}
>> +
>> +static void mlx5e_nvmeotcp_advance_sgl_iter(struct mlx5e_nvmeotcp_queue *queue)
>> +{
>> +	struct nvmeotcp_queue_entry *nqe = &queue->ccid_table[queue->ccid];
>> +
>> +	queue->ccoff += nqe->sgl[queue->ccsglidx].length;
>> +	queue->ccoff_inner = 0;
>> +	queue->ccsglidx++;
>> +}
>> +
>> +static inline void
>> +mlx5e_nvmeotcp_add_skb_frag(struct net_device *netdev, struct sk_buff *skb,
>> +			    struct mlx5e_nvmeotcp_queue *queue,
>> +			    struct nvmeotcp_queue_entry *nqe, u32 fragsz)
>> +{
>> +	dma_sync_single_for_cpu(&netdev->dev,
>> +				nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
>> +				fragsz, DMA_FROM_DEVICE);
>> +	page_ref_inc(compound_head(sg_page(&nqe->sgl[queue->ccsglidx])));
>> +	// XXX: consider reducing the truesize, as no new memory is consumed
>> +	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>> +			sg_page(&nqe->sgl[queue->ccsglidx]),
>> +			nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
>> +			fragsz,
>> +			fragsz);
>> +}
>> +
>> +static struct sk_buff*
>> +mlx5_nvmeotcp_add_tail_nonlinear(struct mlx5e_nvmeotcp_queue *queue,
>> +				 struct sk_buff *skb, skb_frag_t *org_frags,
>> +				 int org_nr_frags, int frag_index)
>> +{
>> +	struct mlx5e_priv *priv = queue->priv;
>> +
>> +	while (org_nr_frags != frag_index) {
>> +		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
>> +			dev_kfree_skb_any(skb);
>> +			return NULL;
>> +		}
>> +		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>> +				skb_frag_page(&org_frags[frag_index]),
>> +				skb_frag_off(&org_frags[frag_index]),
>> +				skb_frag_size(&org_frags[frag_index]),
>> +				skb_frag_size(&org_frags[frag_index]));
>> +		page_ref_inc(skb_frag_page(&org_frags[frag_index]));
>> +		frag_index++;
>> +	}
>> +	return skb;
>> +}
>> +
>> +static struct sk_buff*
>> +mlx5_nvmeotcp_add_tail(struct mlx5e_nvmeotcp_queue *queue, struct sk_buff *skb,
>> +		       int offset, int len)
>> +{
>> +	struct mlx5e_priv *priv = queue->priv;
>> +
>> +	if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
>> +		dev_kfree_skb_any(skb);
>> +		return NULL;
>> +	}
>> +	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>> +			virt_to_page(skb->data),
>> +			offset,
>> +			len,
>> +			len);
>> +	page_ref_inc(virt_to_page(skb->data));
>> +	return skb;
>> +}
>> +
>> +static void mlx5_nvmeotcp_trim_nonlinear(struct sk_buff *skb,
>> +					 skb_frag_t *org_frags,
>> +					 int *frag_index,
>> +					 int remaining)
>> +{
>> +	unsigned int frag_size;
>> +	int nr_frags;
>> +
>> +	/* skip @remaining bytes in frags */
>> +	*frag_index = 0;
>> +	while (remaining) {
>> +		frag_size = skb_frag_size(&skb_shinfo(skb)->frags[*frag_index]);
>> +		if (frag_size > remaining) {
>> +			skb_frag_off_add(&skb_shinfo(skb)->frags[*frag_index],
>> +					 remaining);
>> +			skb_frag_size_sub(&skb_shinfo(skb)->frags[*frag_index],
>> +					  remaining);
>> +			remaining = 0;
>> +		} else {
>> +			remaining -= frag_size;
>> +			skb_frag_unref(skb, *frag_index);
>> +			*frag_index += 1;
>> +		}
>> +	}
>> +
>> +	/* save original frags for the tail and unref */
>> +	nr_frags = skb_shinfo(skb)->nr_frags;
>> +	memcpy(&org_frags[*frag_index], &skb_shinfo(skb)->frags[*frag_index],
>> +	       (nr_frags - *frag_index) * sizeof(skb_frag_t));
>> +	while (--nr_frags >= *frag_index)
>> +		skb_frag_unref(skb, nr_frags);
>> +
>> +	/* remove frags from skb */
>> +	skb_shinfo(skb)->nr_frags = 0;
>> +	skb->len -= skb->data_len;
>> +	skb->truesize -= skb->data_len;
>> +	skb->data_len = 0;
>> +}
>> +
>> +struct sk_buff*
>> +mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
>> +			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt,
>> +			     bool linear)
>> +{
>> +	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
>> +	struct mlx5e_priv *priv = netdev_priv(netdev);
>> +	skb_frag_t org_frags[MAX_SKB_FRAGS];
>> +	struct mlx5e_nvmeotcp_queue *queue;
>> +	struct nvmeotcp_queue_entry *nqe;
>> +	int org_nr_frags, frag_index;
>> +	struct mlx5e_cqe128 *cqe128;
>> +	u32 queue_id;
>> +
>> +	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
>> +	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
>> +	if (unlikely(!queue)) {
>> +		dev_kfree_skb_any(skb);
>> +		return NULL;
>> +	}
>> +
>> +	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
>> +	if (cqe_is_nvmeotcp_resync(cqe)) {
>> +		nvmeotcp_update_resync(queue, cqe128);
>> +		mlx5e_nvmeotcp_put_queue(queue);
>> +		return skb;
>> +	}
>> +
>> +#ifdef CONFIG_TCP_DDP_CRC
>> +	/* If a resync occurred in the previous cqe,
>> +	 * the current cqe.crcvalid bit may not be valid,
>> +	 * so we will treat it as 0
>> +	 */
>> +	skb->ddp_crc = queue->after_resync_cqe ? 0 :
>> +		cqe_is_nvmeotcp_crcvalid(cqe);
>> +	queue->after_resync_cqe = 0;
>> +#endif
>> +	if (!cqe_is_nvmeotcp_zc(cqe)) {
>> +		mlx5e_nvmeotcp_put_queue(queue);
>> +		return skb;
>> +	}
>> +
>> +	/* cc ddp from cqe */
>> +	ccid = be16_to_cpu(cqe128->ccid);
>> +	ccoff = be32_to_cpu(cqe128->ccoff);
>> +	cclen = be16_to_cpu(cqe128->cclen);
>> +	hlen  = be16_to_cpu(cqe128->hlen);
>> +
>> +	/* carve a hole in the skb for DDP data */
>> +	if (linear) {
>> +		skb_trim(skb, hlen);
>> +	} else {
>> +		org_nr_frags = skb_shinfo(skb)->nr_frags;
>> +		mlx5_nvmeotcp_trim_nonlinear(skb, org_frags, &frag_index,
>> +					     cclen);
>> +	}
>> +
>> +	nqe = &queue->ccid_table[ccid];
>> +
>> +	/* packet starts new ccid? */
>> +	if (queue->ccid != ccid || queue->ccid_gen != nqe->ccid_gen) {
>> +		queue->ccid = ccid;
>> +		queue->ccoff = 0;
>> +		queue->ccoff_inner = 0;
>> +		queue->ccsglidx = 0;
>> +		queue->ccid_gen = nqe->ccid_gen;
>> +	}
>> +
>> +	/* skip inside cc until the ccoff in the cqe */
>> +	while (queue->ccoff + queue->ccoff_inner < ccoff) {
>> +		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
>> +		fragsz = min_t(off_t, remaining,
>> +			       ccoff - (queue->ccoff + queue->ccoff_inner));
>> +
>> +		if (fragsz == remaining)
>> +			mlx5e_nvmeotcp_advance_sgl_iter(queue);
>> +		else
>> +			queue->ccoff_inner += fragsz;
>> +	}
>> +
>> +	/* adjust the skb according to the cqe cc */
>> +	while (to_copy < cclen) {
>> +		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
>> +			dev_kfree_skb_any(skb);
>> +			mlx5e_nvmeotcp_put_queue(queue);
>> +			return NULL;
>> +		}
>> +
>> +		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
>> +		fragsz = min_t(int, remaining, cclen - to_copy);
>> +
>> +		mlx5e_nvmeotcp_add_skb_frag(netdev, skb, queue, nqe, fragsz);
>> +		to_copy += fragsz;
>> +		if (fragsz == remaining)
>> +			mlx5e_nvmeotcp_advance_sgl_iter(queue);
>> +		else
>> +			queue->ccoff_inner += fragsz;
>> +	}
>> +
>> +	if (cqe_bcnt > hlen + cclen) {
>> +		remaining = cqe_bcnt - hlen - cclen;
>> +		if (linear)
>> +			skb = mlx5_nvmeotcp_add_tail(queue, skb,
>> +						     offset_in_page(skb->data) +
>> +								hlen + cclen,
>> +						     remaining);
>> +		else
>> +			skb = mlx5_nvmeotcp_add_tail_nonlinear(queue, skb,
>> +							       org_frags,
>> +							       org_nr_frags,
>> +							       frag_index);
>> +	}
>> +
>> +	mlx5e_nvmeotcp_put_queue(queue);
>> +	return skb;
>> +}
> 
> 
> 
> ... I'll copy and paste my question here:
> 
> "mlx5e_skb_from_cqe_mpwrq_linear and mlx5e_skb_from_cqe_mpwrq_nolinear
> create an skb and then this function comes behind it, strips any frags
> originally added to the skb, adds the frags for the sgls, and then
> re-adds the original frags.
> 
> Why is this needed? Why can't the skb be created with all of the frags
> in proper order?
> 
> It seems like this dance is not needed if you had generic header/payload
> splits with the payload written to less retrictive SGLs."
> 
> This patch seems to be something very similar, and it is really
> complicated way to create each skb for DDP. The patch description does
> little to explain why it is needed.
> 

This is the same patch as before.

I'll start by explaining why this is needed. Then, clarify why generic
header-data split is not enough.

This is needed for a few reasons that are explained in detail
in the tcp-ddp offload documentation. See patch 21 overview
and rx-data-path sections. Our reasons are as follows:
1) Each SKB may contain multiple PDUs. DDP offload doesn't operate on
PDU headers, so these are written in the receive ring. Therefore, we
need to rebuild the SKB to account for it. Additionally, due to HW
limitations, we will only offload the first PDU in the SKB.
2) The newly constructed SKB represents the original data as it is on
the wire, such that the network stack is oblivious to the offload.
3) We decided not to modify all of the mlx5e_skb_from_cqe* functions
because it would make the offload harder to distinguish, and it would
add overhead to the existing data-path fucntions. Therefore, we opted
for this modular approach.

If we only had generic header-data split, then we just couldn't
provide this offload. It is not enough to place payload into some
buffer without TCP headers because RPC protocols and advanced storage
protocols, such as nvme-tcp, reorder their responses and require data
to be placed into application/pagecache buffers, which are anything
but anonymous. In other words, header-data split alone writes data
to the wrong buffers (reordering), or to anonymous buffers that
can't be page-flipped to replace application/pagecache buffers.

