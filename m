Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA7F309B02
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhAaHwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhAaHwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:52:05 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D418C061573
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:51:17 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y8so174486ede.6
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CZnj9PSGYJvwkHgTiq/VDDFdSzGMKGh7K/RwheJSvf4=;
        b=P9rduIvYflhy/mdiWPslz323bV4GVbUTfNDWGzBu2IAuTQ3wffgW49ATNBY6eEzWnX
         s5Hibxdqa+2+ReBoDUZuV3T5ZJrVXR6oml/KPWYlTeOSMRT3cA0adK6oI18uSVTcgG3L
         HL3mWrdaUk589S95T+b9ar2eypyJmvrWm9Xlqih98NcUsqsfux+3MegNQQJur3CU+S2I
         wPq6nPS14a86FGOk9e8vd9CkLUvS55ffIakDp1bGmmatCOmN20PjTyjG/UkA5qdF/oa5
         ZsWw0jf58sBkeGVb/uLlV88HnwJO+zwUWzOqECYmVVQI53TOswrZXLUPMaY1R1k+P8uj
         3WrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZnj9PSGYJvwkHgTiq/VDDFdSzGMKGh7K/RwheJSvf4=;
        b=RH8qW6hI8hudYTnk+Ap8GlxrA5huEzt9YefzZdFGVrWljuonOqgLGbqjv26Qe7emk+
         805bnNJoNQqdFAu2+zkxEF0UhsMVJlOr85CM1z+Vo+6bUg1jeg24WclLJ+6JoVqdsEBk
         vlMZLU4CF8q/C2ramew+QEHj0agYtrgNnBrYmg3m/kVLiSFYq/kONgLIxvCEcjedQBab
         d5fOpMBMrq6s35jONT8ber3PHZXb3xk3TzpyugeYLQl8vsMdy7rVjEgI5cbkp4+oKqO2
         XNp1pamEsLFAHaYik7d9MLJl8rU/8xmzpsHd9BvuQ8YrZ9Sa6N6guLSqrxgkdJlDqh7k
         W2BA==
X-Gm-Message-State: AOAM5333FnaKBhkwksfJFGc+SHtKezPFmQmm86TLDUXlj9fJz76ReSzZ
        trRRLpalScMRU0be+gn6gtY=
X-Google-Smtp-Source: ABdhPJwXU/dOisJZQ0h2CNK1vEUzVmcvk7WcfPsziaMP9Q2aTVWagnsQw+D+RLq1fKGuazndWuZVfg==
X-Received: by 2002:aa7:db49:: with SMTP id n9mr13450979edt.73.1612079475659;
        Sat, 30 Jan 2021 23:51:15 -0800 (PST)
Received: from [132.68.43.126] ([132.68.43.126])
        by smtp.gmail.com with ESMTPSA id a11sm6080181ejc.64.2021.01.30.23.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jan 2021 23:51:14 -0800 (PST)
Subject: Re: [PATCH v2 net-next 06/21] nvme-tcp: Add DDP offload control path
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
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
 <37861060-9651-49c8-e583-2b070914361c@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <c9d06a90-4e7d-b5aa-eabb-63b557b8b5d0@gmail.com>
Date:   Sun, 31 Jan 2021 09:51:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <37861060-9651-49c8-e583-2b070914361c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2021 5:47, David Ahern wrote:
> On 1/14/21 8:10 AM, Boris Pismenny wrote:
>> +static
>> +int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>> +{
>> +	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
>> +	struct nvme_tcp_ddp_config config = {};
>> +	int ret;
>> +
>> +	if (!netdev) {
>> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (!(netdev->features & NETIF_F_HW_TCP_DDP)) {
>> +		dev_put(netdev);
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	config.cfg.type		= TCP_DDP_NVME;
>> +	config.pfv		= NVME_TCP_PFV_1_0;
>> +	config.cpda		= 0;
>> +	config.dgst		= queue->hdr_digest ?
>> +		NVME_TCP_HDR_DIGEST_ENABLE : 0;
>> +	config.dgst		|= queue->data_digest ?
>> +		NVME_TCP_DATA_DIGEST_ENABLE : 0;
>> +	config.queue_size	= queue->queue_size;
>> +	config.queue_id		= nvme_tcp_queue_id(queue);
>> +	config.io_cpu		= queue->io_cpu;
>> +
>> +	ret = netdev->tcp_ddp_ops->tcp_ddp_sk_add(netdev,
>> +						  queue->sock->sk,
>> +						  (struct tcp_ddp_config *)&config);
> 
> typecast is not needed; tcp_ddp_config is an element of nvme_tcp_ddp_config
> 

True, will fix, thanks!

>> +	if (ret) {
>> +		dev_put(netdev);
>> +		return ret;
>> +	}
>> +
>> +	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
>> +	if (netdev->features & NETIF_F_HW_TCP_DDP)
>> +		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
>> +
>> +	return ret;
>> +}
>> +
>> +static
>> +void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
>> +{
>> +	struct net_device *netdev = queue->ctrl->offloading_netdev;
>> +
>> +	if (!netdev) {
>> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>> +		return;
>> +	}
>> +
>> +	netdev->tcp_ddp_ops->tcp_ddp_sk_del(netdev, queue->sock->sk);
>> +
>> +	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
>> +	dev_put(netdev); /* put the queue_init get_netdev_for_sock() */
> 
> have you validated the netdev reference counts? You have a put here, and ...
> 

Yes, it does work for the cases we've tested: up/down,
connect/disconnect, and up/down during traffic. It is
unfortunate that it is not trivial to follow.
We'll add some comment to make it more clear. Also see
below.

>> +}
>> +
>> +static
>> +int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue)
>> +{
>> +	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
> 
> ... a get here ....
> 
>> +	struct tcp_ddp_limits limits;
>> +	int ret = 0;
>> +
>> +	if (!netdev) {
>> +		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (netdev->features & NETIF_F_HW_TCP_DDP &&
>> +	    netdev->tcp_ddp_ops &&
>> +	    netdev->tcp_ddp_ops->tcp_ddp_limits)
>> +		ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, &limits);
>> +	else
>> +		ret = -EOPNOTSUPP;
>> +
>> +	if (!ret) {
>> +		queue->ctrl->offloading_netdev = netdev;
> 
> 
> ... you have the device here, but then ...
> 
>> +		dev_dbg_ratelimited(queue->ctrl->ctrl.device,
>> +				    "netdev %s offload limits: max_ddp_sgl_len %d\n",
>> +				    netdev->name, limits.max_ddp_sgl_len);
>> +		queue->ctrl->ctrl.max_segments = limits.max_ddp_sgl_len;
>> +		queue->ctrl->ctrl.max_hw_sectors =
>> +			limits.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
>> +	} else {
>> +		queue->ctrl->offloading_netdev = NULL;
>> +	}
>> +
>> +	dev_put(netdev);
> 
> ... put here. And this is the limit checking function which seems like
> an odd place to set offloading_netdev vs nvme_tcp_offload_socket which
> sets no queue variable but yet hangs on to a netdev reference count.
> 
> netdev reference count leaks are an absolute PITA to find. Code that
> takes and puts the counts should be clear and obvious as to when and
> why. The symmetry of offload and unoffload are clear when the offload
> saves the address in offloading_netdev. What you have now is dubious.
> 

The idea here is to rely on offload and unoffload to hold the netdev
during offload. Get limits is not offloading anything; it only queries
device limits that are then applied to the queue by the caller.
We hold the device here for only to ensure that the function is still
there when it is called, and we release it once we are done with it,
as no context is established on the NIC, and no offload takes place.
