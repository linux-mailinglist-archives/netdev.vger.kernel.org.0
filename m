Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730992FAF37
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 04:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbhASDsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 22:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbhASDry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 22:47:54 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC871C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 19:47:11 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id i30so5589102ota.6
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 19:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LEBogkZ4IQHYkFDaqnlPZw8aJhD0X+Er1BtoG8LWR7o=;
        b=qvLA3LvTgXP7DgsVwyVP5kRc9Ias6NBJtlQVAy4CcSsJWClVFh30Xfn3JIBOrrUAzf
         L1TStHr6oyVSXIYg/EC3a5h7+dZU5drk7yawYs6bbIaeEH8tdlgdi+BJDaYS8VP77204
         X5xaABMF9RyN/S4zKmMC78vcVFFYvbA+8tekxfwJC1dCtNT2trMyaj8I4rtQZXpDi11g
         SahJhXmcuUlWUqszcPi50Ap1DsT3YI+1J2NyQ0diT/S14yWCy8Wdx2f1RRlnwPegDOIA
         QqFULfN7mjBKneEDxOpdPLNZSB00BhR46xvcJU8ueRT/Ob1kUU9tl6ZPnehqJGs02mfR
         o/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LEBogkZ4IQHYkFDaqnlPZw8aJhD0X+Er1BtoG8LWR7o=;
        b=gZzH6q++c+qfUdGL1VDJh1g9EM0T6nEVR6QqthrLL10u2Pl1zh50vZ4qJ/hbB4WKGD
         qWvAvJ2+66M4vFU1zvx/ko0ewzEB/h4ep+eERhQdkyXS7V21BqEucwNuNesoogLvNHj0
         HZI5lFa4NLfCKYx+hhOp6vOBeNmQQ3lcxlD6M/Re0Pq/RaKZW6T6hj3et8lwEkxYL7x8
         220XZpLg7/akfgfGBR6pCsL3fqOdSg9RFfRvbevA0HTmyxjAofR9FCl46jYa6zL4qSTK
         PBR/QzvYepI1LMSNBxl3e2kzVZSYfmc9m/aymBuMmPruNH+xfZ1GlFla5Y6YUEWOjL1y
         NX+g==
X-Gm-Message-State: AOAM533ebs5aQsxLCS3+87V8Mxa89Bb+4/EqivAVurcEqRQw0uyjqKGQ
        fBpamQAEwCPUlYbR7QlpWek=
X-Google-Smtp-Source: ABdhPJyjOHYOkMe+KTHzBd+kmzzYF6C/9dZKi7sFMS5JhOO50R20PtuG16/OG7KfcTEhekCRAImIug==
X-Received: by 2002:a9d:8f6:: with SMTP id 109mr2116503otf.199.1611028031149;
        Mon, 18 Jan 2021 19:47:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.193])
        by smtp.googlemail.com with ESMTPSA id v67sm2185482otb.43.2021.01.18.19.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 19:47:10 -0800 (PST)
Subject: Re: [PATCH v2 net-next 06/21] nvme-tcp: Add DDP offload control path
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
 <20210114151033.13020-7-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <37861060-9651-49c8-e583-2b070914361c@gmail.com>
Date:   Mon, 18 Jan 2021 20:47:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210114151033.13020-7-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/21 8:10 AM, Boris Pismenny wrote:
> +static
> +int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
> +{
> +	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
> +	struct nvme_tcp_ddp_config config = {};
> +	int ret;
> +
> +	if (!netdev) {
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!(netdev->features & NETIF_F_HW_TCP_DDP)) {
> +		dev_put(netdev);
> +		return -EOPNOTSUPP;
> +	}
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
> +	ret = netdev->tcp_ddp_ops->tcp_ddp_sk_add(netdev,
> +						  queue->sock->sk,
> +						  (struct tcp_ddp_config *)&config);

typecast is not needed; tcp_ddp_config is an element of nvme_tcp_ddp_config

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
> +static
> +void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
> +{
> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
> +
> +	if (!netdev) {
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
> +		return;
> +	}
> +
> +	netdev->tcp_ddp_ops->tcp_ddp_sk_del(netdev, queue->sock->sk);
> +
> +	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
> +	dev_put(netdev); /* put the queue_init get_netdev_for_sock() */

have you validated the netdev reference counts? You have a put here, and ...

> +}
> +
> +static
> +int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue)
> +{
> +	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);

... a get here ....

> +	struct tcp_ddp_limits limits;
> +	int ret = 0;
> +
> +	if (!netdev) {
> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
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


... you have the device here, but then ...

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
> +	dev_put(netdev);

... put here. And this is the limit checking function which seems like
an odd place to set offloading_netdev vs nvme_tcp_offload_socket which
sets no queue variable but yet hangs on to a netdev reference count.

netdev reference count leaks are an absolute PITA to find. Code that
takes and puts the counts should be clear and obvious as to when and
why. The symmetry of offload and unoffload are clear when the offload
saves the address in offloading_netdev. What you have now is dubious.

