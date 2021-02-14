Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F131B1DE
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 19:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBNSRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 13:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhBNSRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 13:17:14 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB89C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 10:16:34 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id y199so5603025oia.4
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 10:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kq7FDDv4Bg29GbbprI0wEcAVH1cweqTzNJcKru2Q2eQ=;
        b=dZ7ANatAQ7vjVErpc5Sgc7vp50Uw7U9oAwKn4VLzXuxLzgI38ESqkpLux1Qyz3G7Vn
         UtpykyDY/TwDrbZoEz45/rI+SGoPGd86a/iQL+Sn87gTagMZ8UNK7lSQw5/xHY1GhbFG
         eEAcdpqGMWkhR6B2TvlbnFBoQMmtkJxamQxLs6zkwB7zetXK7Et/eJf54L2bWrXN9gvZ
         9lmkebbW6JjOjK+4ap2h1iRG+ztGvKlOgdT+Z0XQwEqc5xQ/psGTYVh+eZnyqlQ9L/tl
         OhGmWxY2vpiHHjYRIra/Vmp2peGBZR5XOJoM02LZWx6VOvZK7l2JkbpH2qPaHQQxjyAB
         b4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kq7FDDv4Bg29GbbprI0wEcAVH1cweqTzNJcKru2Q2eQ=;
        b=t6ft7e/VFKbJC9pv4kmXxx7XLZal0RTP/im+YjcBpJbUQ1ixCbAiSA7eT4h7lWF7Xx
         aGD0ELmsxjtk44So1KoATjo1QfNiviR5SAkVAwcmHjNjguHnkJgtvQhGN4BI4p3jSFt5
         KRwFeEBknRrByQI2/3xq1V/4DujKcNvflcpNbKUGqR6IFiLTLAHmXQYicVS5v1X2UQdQ
         087ZeXYYCNeBlD/3i/j1b7ZkKAhFmqTBL8/gdZX9tTrxEHaNXo8ernL2/NY2yDCR8CNC
         V8ELCS7HYfIL5tR9RAjEk3gpwoQJG97I5HI1szY7opWU5xXy5Fkg+Wc5TbdAZa96smbF
         NFOA==
X-Gm-Message-State: AOAM530R0TUymvuO8xTzz5sqYeS0uhGU/fwwxvGMpRU4TiNjEckGtUWv
        KX3973UqIIeJA7TYzHM579s=
X-Google-Smtp-Source: ABdhPJye/5uDMbc8XAtx7oIbNvjI+FraHm+LJBN6eiFUQ5sOhd7scgPLM5AgjANlPU1qblUZvai9vw==
X-Received: by 2002:aca:724e:: with SMTP id p75mr6604037oic.109.1613326593954;
        Sun, 14 Feb 2021 10:16:33 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id p67sm3336764oih.21.2021.02.14.10.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 10:16:33 -0800 (PST)
Subject: Re: [PATCH v4 net-next 06/21] nvme-tcp: Add DDP offload control path
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
 <20210211211044.32701-7-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2dd10b2f-df00-e21c-7886-93f41a987040@gmail.com>
Date:   Sun, 14 Feb 2021 11:16:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211211044.32701-7-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 2:10 PM, Boris Pismenny wrote:
> @@ -223,6 +229,164 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
>  	return nvme_tcp_pdu_data_left(req) <= len;
>  }
>  
> +#ifdef CONFIG_TCP_DDP
> +
> +static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
> +static const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
> +	.resync_request		= nvme_tcp_resync_request,
> +};
> +
> +static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
> +{
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +	struct nvme_tcp_ddp_config config = {};
> +	int ret;
> +
> +	if (!(netdev->features & NETIF_F_HW_TCP_DDP))

If nvme_tcp_offload_limits does not find a dst_entry on the socket then
offloading_netdev may not NULL at this point.

> +		return -EOPNOTSUPP;
> +
> +	config.cfg.type		= TCP_DDP_NVME;
> +	config.pfv		= NVME_TCP_PFV_1_0;
> +	config.cpda		= 0;
> +	config.dgst		= queue->hdr_digest ?
> +		NVME_TCP_HDR_DIGEST_ENABLE : 0;
> +	config.dgst		|= queue->data_digest ?
> +		NVME_TCP_DATA_DIGEST_ENABLE : 0;
> +	config.queue_size	= queue->queue_size;
> +	config.queue_id		= nvme_tcp_queue_id(queue);
> +	config.io_cpu		= queue->io_cpu;
> +
> +	dev_hold(netdev); /* put by unoffload_socket */
> +	ret = netdev->tcp_ddp_ops->tcp_ddp_sk_add(netdev,
> +						  queue->sock->sk,
> +						  &config.cfg);
> +	if (ret) {
> +		dev_put(netdev);
> +		return ret;
> +	}
> +
> +	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
> +	if (netdev->features & NETIF_F_HW_TCP_DDP)
> +		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
> +
> +	return ret;
> +}
> +
> +static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
> +{
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +
> +	if (!netdev) {
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");

you are already logged in nvme_tcp_offload_limits that
get_netdev_for_sock returned NULL; no need to do it again.

> +		return;
> +	}
> +
> +	netdev->tcp_ddp_ops->tcp_ddp_sk_del(netdev, queue->sock->sk);
> +
> +	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
> +	dev_put(netdev); /* held by offload_socket */
> +}
> +
> +static int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue)
> +{
> +	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
> +	struct tcp_ddp_limits limits;
> +	int ret = 0;
> +
> +	if (!netdev) {
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");

This should be more informative.

> +		queue->ctrl->offloading_netdev = NULL;
> +		return -ENODEV;
> +	}
> +
> +	if (netdev->features & NETIF_F_HW_TCP_DDP &&
> +	    netdev->tcp_ddp_ops &&
> +	    netdev->tcp_ddp_ops->tcp_ddp_limits)
> +		ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, &limits);
> +	else
> +		ret = -EOPNOTSUPP;
> +
> +	if (!ret) {
> +		queue->ctrl->offloading_netdev = netdev;

you save a reference to the netdev here, but then release the refcnt
below. That device could be deleted between this point in time and the
initialization of all queues.


> +		dev_dbg_ratelimited(queue->ctrl->ctrl.device,
> +				    "netdev %s offload limits: max_ddp_sgl_len %d\n",
> +				    netdev->name, limits.max_ddp_sgl_len);
> +		queue->ctrl->ctrl.max_segments = limits.max_ddp_sgl_len;
> +		queue->ctrl->ctrl.max_hw_sectors =
> +			limits.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
> +	} else {
> +		queue->ctrl->offloading_netdev = NULL;
> +	}
> +
> +	/* release the device as no offload context is established yet. */
> +	dev_put(netdev);
> +
> +	return ret;
> +}
> +
> +static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
> +				     struct sk_buff *skb, unsigned int offset)
> +{
> +	u64 pdu_seq = TCP_SKB_CB(skb)->seq + offset - queue->pdu_offset;
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +	u64 resync_val;
> +	u32 resync_seq;
> +
> +	resync_val = atomic64_read(&queue->resync_req);
> +	/* Lower 32 bit flags. Check validity of the request */
> +	if ((resync_val & TCP_DDP_RESYNC_REQ) == 0)
> +		return;
> +
> +	/* Obtain and check requested sequence number: is this PDU header before the request? */
> +	resync_seq = resync_val >> 32;
> +	if (before(pdu_seq, resync_seq))
> +		return;
> +
> +	if (unlikely(!netdev)) {
> +		pr_info_ratelimited("%s: netdev not found\n", __func__);

can't happen right? you get here because NVME_TCP_Q_OFF_DDP is set and
it is only set if offloading_netdev is set and the device supports offload.

> +		return;
> +	}
> +
> +	/**
> +	 * The atomic operation gurarantees that we don't miss any NIC driver
> +	 * resync requests submitted after the above checks.
> +	 */
> +	if (atomic64_cmpxchg(&queue->resync_req, resync_val,
> +			     resync_val & ~TCP_DDP_RESYNC_REQ))
> +		netdev->tcp_ddp_ops->tcp_ddp_resync(netdev, queue->sock->sk, pdu_seq);
> +}
> +

