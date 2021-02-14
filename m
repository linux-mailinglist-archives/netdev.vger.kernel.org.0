Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7228931B1FD
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 19:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBNS2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 13:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhBNS17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 13:27:59 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5015DC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 10:27:19 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id l19so5606161oih.6
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 10:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gyAEP57mzF2m5+A3pWOKhRp71TfOmK81NA6IB/liTnw=;
        b=BrPG4yoOVHbHMJc/QMpZknFh0q3k2v6usHR5HR8PzVE3VPNmY16i9lT3Ur0KV/P+7f
         1eqC9Pbki5O6eO9cdBy+rFKfctf7Mq+iQSQOakX2Ool2DyfGErLb6yKkPwcwC2ZKPJMx
         bLiq4XdDyf/We5WqNr3SVfneJhtyIMiDouq6yNid7cVzAm5rWK9DQwu6ZfIBjhFhDtKI
         zerS0En3YFShIUwkHBH6WK2L9ROXBxOmvhEp6DFlQZ8EoBw5l/WerRedUINzpf/jxqzy
         J5F+WqqtW5Ie1JX5U5a+fp+fpSQHdpzTEyQfliH0IJ9UX7bbCHIXeoa130B/gBjyMJwf
         vc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gyAEP57mzF2m5+A3pWOKhRp71TfOmK81NA6IB/liTnw=;
        b=PXwSz4mDuYqG9AQukj80VHsjZNh6jE+lmfMqxjSIyRI7sRPYgMwaZNqaX0bB/sTrWJ
         euUMMEKkOindPl9stqxFprxh8o3J3oW5JxISbICBrFLehBwuFhVfIMaTsalRzvB+UEzc
         7R2yO3awlPR9jqAZeBhx+PcViKO0MngfQlpLaT9EpQwbPX61+RqJEsFJBl+YLJxdLoa7
         IaCu0jDI2WExuOe1u8+K3SxZhoSA32ZmLklRkde8f7NXcpTXpitZIXcqtGoZLd3onwpE
         UbtA8mkuPwYFXxMaJrq9kdlBxiZk+ckaeK6A1+GY5BkaJu7zuSui6ZRlAjKLyeUD85Mj
         aVIw==
X-Gm-Message-State: AOAM533LOWjGh4qNQ3Von3DhzcGBWcRDbOneWoZNRO8Lh1KBz3SIvQec
        nE8FFklIVi1AfRfsOOswgzM=
X-Google-Smtp-Source: ABdhPJzq2KGbgVEMIR3ygGvmdhduOk9OfvWmPuRS7zo+Q+llSXzs+e6V5A3ifhGjpOPIw95HtOhXOw==
X-Received: by 2002:aca:3742:: with SMTP id e63mr6277228oia.158.1613327238813;
        Sun, 14 Feb 2021 10:27:18 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id j25sm2772470otn.55.2021.02.14.10.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 10:27:18 -0800 (PST)
Subject: Re: [PATCH v4 net-next 07/21] nvme-tcp: Add DDP data-path
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
 <20210211211044.32701-8-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cfd61c5a-c5fd-e0d9-fb60-be93f1c98735@gmail.com>
Date:   Sun, 14 Feb 2021 11:27:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211211044.32701-8-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 2:10 PM, Boris Pismenny wrote:
>  
> +static int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
> +				 u16 command_id,
> +				 struct request *rq)
> +{
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +	int ret;
> +
> +	if (unlikely(!netdev)) {
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");

again, unnecessary. you only get here because the rquest is marked
offloaded and that only happens if the netdev exists and supports DDP.

> +		return -EINVAL;
> +	}
> +
> +	ret = netdev->tcp_ddp_ops->tcp_ddp_teardown(netdev, queue->sock->sk,
> +						    &req->ddp, rq);
> +	sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
> +	return ret;
> +}
> +
> +static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
> +{
> +	struct request *rq = ddp_ctx;
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +
> +	if (!nvme_try_complete_req(rq, req->status, req->result))
> +		nvme_complete_rq(rq);
> +}
> +
> +static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
> +			      u16 command_id,
> +			      struct request *rq)
> +{
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +	int ret;
> +
> +	if (unlikely(!netdev)) {
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");

similarly here. you can't get here if netdev is null.

> +		return -EINVAL;
> +	}
> +
> +	req->ddp.command_id = command_id;
> +	ret = nvme_tcp_req_map_sg(req, rq);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
> +						 queue->sock->sk,
> +						 &req->ddp);
> +	if (!ret)
> +		req->offloaded = true;
> +	return ret;
> +}
> +
>  static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>  {
>  	struct net_device *netdev = queue->ctrl->offloading_netdev;
> @@ -343,7 +417,7 @@ static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
>  		return;
>  
>  	if (unlikely(!netdev)) {
> -		pr_info_ratelimited("%s: netdev not found\n", __func__);
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");

and per comment on the last patch, this is not needed.

> @@ -849,10 +953,39 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>  
>  static inline void nvme_tcp_end_request(struct request *rq, u16 status)
>  {
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_tcp_queue *queue = req->queue;
> +	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
>  	union nvme_result res = {};
>  
> -	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> -		nvme_complete_rq(rq);
> +	nvme_tcp_complete_request(rq, cpu_to_le16(status << 1), res, pdu->command_id);
> +}
> +
> +
> +static int nvme_tcp_consume_skb(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> +				unsigned int *offset, struct iov_iter *iter, int recv_len)
> +{
> +	int ret;
> +
> +#ifdef CONFIG_TCP_DDP
> +	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
> +		if (queue->data_digest)
> +			ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
> +					queue->rcv_hash);
> +		else
> +			ret = skb_ddp_copy_datagram_iter(skb, *offset, iter, recv_len);
> +	} else {
> +#endif

why not make that a helper defined in the CONFIG_TCP_DDP section with an
inline for the unset case. Keeps this code from being polluted with the
ifdef checks.

> +		if (queue->data_digest)
> +			ret = skb_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
> +					queue->rcv_hash);
> +		else
> +			ret = skb_copy_datagram_iter(skb, *offset, iter, recv_len);
> +#ifdef CONFIG_TCP_DDP
> +	}
> +#endif
> +
> +	return ret;
>  }
>  
>  static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> @@ -899,12 +1032,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>  		recv_len = min_t(size_t, recv_len,
>  				iov_iter_count(&req->iter));
>  
> -		if (queue->data_digest)
> -			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
> -				&req->iter, recv_len, queue->rcv_hash);
> -		else
> -			ret = skb_copy_datagram_iter(skb, *offset,
> -					&req->iter, recv_len);
> +		ret = nvme_tcp_consume_skb(queue, skb, offset, &req->iter, recv_len);
>  		if (ret) {
>  			dev_err(queue->ctrl->ctrl.device,
>  				"queue %d failed to copy request %#x data",
> @@ -1128,6 +1256,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>  	bool inline_data = nvme_tcp_has_inline_data(req);
>  	u8 hdgst = nvme_tcp_hdgst_len(queue);
>  	int len = sizeof(*pdu) + hdgst - req->offset;
> +	struct request *rq = blk_mq_rq_from_pdu(req);
>  	int flags = MSG_DONTWAIT;
>  	int ret;
>  
> @@ -1136,6 +1265,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
>  	else
>  		flags |= MSG_EOR;
>  
> +	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) &&
> +	    blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
> +		nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
> +

For consistency, shouldn't this be wrapped in the CONFIG_TCP_DDP check too?

>  	if (queue->hdr_digest && !req->offset)
>  		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
>  
