Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292B22FAF67
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbhASEUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbhASET2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 23:19:28 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C39C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 20:18:47 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id b24so18602290otj.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 20:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PGQWnRykzJUb1S9lKNedKSEMsPVcpfZ4OcuUTj/9aeM=;
        b=jP8BzF3xDMu98sFpJMShdpW0yMy492LbJFp9GgFB4p6qmu05mg6wXNTqe0as8tKID3
         3UCIfRJDpxP16GSu2ZbGgFb8cuR384r8AtUvpUEtgrw7CfRPg40P1xPFudQ1MzNcQ89j
         kKlXJ4aq+6rCXtKqG13+9+j1tn/Y+zZb68EHOJaVVUPRr5sk2UrU+aJmKVWMIE/0Vmxh
         de6R6nIrGMmm39nu+xLtYPPpz7Axydq9DuadhgwbHckUKMjfZy72vAts6vDAv+llpAx2
         kCtHbpy5Sj/nIf1Py2JH+WsazdaztC0eQTInDpfyL3COgusRoYfnGkIjhoQS3RwkYpHm
         1Y8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PGQWnRykzJUb1S9lKNedKSEMsPVcpfZ4OcuUTj/9aeM=;
        b=dlsnYomxdDcsYBcMTpaft/O6nq0wN7c4gK8/dua9UdLsAJ1IrK6vTW565lF9vaoguV
         oOFULnXu5wywepDXGsja7TsEqv49OYuXVZAT3LYsnbFe5cmHaKdRbP5453RSMflqlj8/
         ZvyED682tC2og0tbE7b1KC+12JxzUsygNUBGY27H1MKGZiXYqNcihu/AyFGoKz5ZlA1v
         EzVPryKE0x0rRZH71+GfU6eQ4mYEl2W9JJZVB496bTwT1ctheiVshLMJ3FwmWVMYGFkH
         hTdlFJDcn3bKotEcPBunkQZCB7GN+mzrQ98GezD3wH7Yyvebd9hszFvTSpXGa9e/x8GR
         D2DA==
X-Gm-Message-State: AOAM530DVy9hjRkk/9yMw4SlCURrbeIWAHQEjYEQ6eEdw2g7X7Fb+2rC
        fm65jeQ7y92N4Fo/oKGqJUQ=
X-Google-Smtp-Source: ABdhPJxdWVSAgii/2MkPvERcKolGR6i+7ta0jZQ7GpHk/SqwbsPfyB7CKBksX1tJHuK0ErHfmPxpNA==
X-Received: by 2002:a9d:4e87:: with SMTP id v7mr2070437otk.302.1611029926930;
        Mon, 18 Jan 2021 20:18:46 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.196])
        by smtp.googlemail.com with ESMTPSA id y84sm3786465oig.36.2021.01.18.20.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 20:18:46 -0800 (PST)
Subject: Re: [PATCH v2 net-next 07/21] nvme-tcp: Add DDP data-path
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
 <20210114151033.13020-8-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <84cc2af1-22e8-abf5-07da-bc7b4a2b6b12@gmail.com>
Date:   Mon, 18 Jan 2021 21:18:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210114151033.13020-8-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/21 8:10 AM, Boris Pismenny wrote:
> @@ -664,8 +753,15 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
>  		return -EINVAL;
>  	}
>  
> -	if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
> -		nvme_complete_rq(rq);
> +	req = blk_mq_rq_to_pdu(rq);
> +	if (req->offloaded) {
> +		req->status = cqe->status;
> +		req->result = cqe->result;
> +		nvme_tcp_teardown_ddp(queue, cqe->command_id, rq);
> +	} else {
> +		if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
> +			nvme_complete_rq(rq);
> +	}
>  	queue->nr_cqe++;
>  
>  	return 0;
> @@ -859,9 +955,18 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>  static inline void nvme_tcp_end_request(struct request *rq, u16 status)
>  {
>  	union nvme_result res = {};
> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
> +	struct nvme_tcp_queue *queue = req->queue;
> +	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
>  
> -	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> -		nvme_complete_rq(rq);
> +	if (req->offloaded) {
> +		req->status = cpu_to_le16(status << 1);
> +		req->result = res;
> +		nvme_tcp_teardown_ddp(queue, pdu->command_id, rq);
> +	} else {
> +		if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
> +			nvme_complete_rq(rq);
> +	}
>  }
>  
>  static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,


The req->offload checks assume the offload is to the expected
offload_netdev, but you do not verify the data arrived as expected. You
might get lucky if both netdev's belong to the same PCI device (assuming
the h/w handles it a certain way), but it will not if the netdev's
belong to different devices.

Consider a system with 2 network cards -- even if it is 2 mlx5 based
devices. One setup can have the system using a bond with 1 port from
each PCI device. The tx path picks a leg based on the hash of the ntuple
and that (with Tariq's bond patches) becomes the expected offload
device. A similar example holds for a pure routing setup with ECMP. For
both there is full redundancy in the network - separate NIC cards
connected to separate TORs to have independent network paths.

A packet arrives on the *other* netdevice - you have *no* control over
the Rx path. Your current checks will think the packet arrived with DDP
but it did not.
