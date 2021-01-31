Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3588309B2B
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 09:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhAaIpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 03:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhAaIpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 03:45:00 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D95AC061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 00:44:17 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a9so1041364ejr.2
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 00:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eaHIpYN9GWFnXbaCKJBt41SCDrRaQhQO2OFHIC9TfAM=;
        b=owu4XVs7ehxw5ghy+hoTFu4XjsXYxhRKVWs+x7oM4wzlD+QmH+ee5pVu5JGVXapQqK
         pitL3o92oQyaHrAYzgTkTdPiB43wFvtW1fjde9YS2QjjM6tnDKEFvDzoUw019RwlJylC
         1EriYGHHyBEoJDOpubRX4YBQ3thGiLFyQCUmt+9ZinirdsulwJ1Dfz1mc+oFdjDzrBPI
         dy5ZXM9TVizYnu4vs25aAbp46fjYmRJdjPeYI73d+yhLpHfvsLsLAnEsnhCkTgjbHK8N
         rn/m9LZtO9Njk9WwqwdyL2n1ZkM0mWCMONfJyZUIcXlUXLDGmtycZqcsfh4/jlGLohRg
         /rCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eaHIpYN9GWFnXbaCKJBt41SCDrRaQhQO2OFHIC9TfAM=;
        b=IoCaWKGZ9kjxMAZzwMvx0G+Qw01AtpzTRF9l9F2D81TMdMtXQR6+czEQASkyUTqtox
         6CGYbTUtLtE+pVhuCTrGywUC4F6sH9ZRI4Qdgj+ARLrUGAHu4WhORPjAEx5OfLiQcDP3
         Rwm6z/mPJtEN3+x7xsc3/P0vhP+CDFKzVppaASMbYdhe8qYnJc/4DgJy8mjh7+7tiTWo
         EkpcJFkZn8Evcj4VW2u6ShwQbJv11kJeTO1wrqm8nFgKPc+dH3cl9FNpKjZDYxPLbhUA
         kt2U3mpwzBUeWd77Y4u7oXvoXYg0qs14yw4qda+axofIIrYx5kWscqqmoWLUaG0/PGbH
         5LoA==
X-Gm-Message-State: AOAM532ZUFNKFvg5xgXwtlCun5zvzAVfqvRlfVUVQxQgH4+bHxFaBk7Y
        csYbG+OE5lcmBekWwgYN7EqLy/N8Pxh4ayoG
X-Google-Smtp-Source: ABdhPJxnyORbxckz4zNdup1CruQd7Nwbm4xWOVc9FEXYZwn6GCAB185O3OiO/DjCaZZVyy/xPJDntg==
X-Received: by 2002:a17:906:b51:: with SMTP id v17mr12465673ejg.8.1612082655988;
        Sun, 31 Jan 2021 00:44:15 -0800 (PST)
Received: from [132.68.43.126] ([132.68.43.126])
        by smtp.gmail.com with ESMTPSA id i4sm6153469eje.90.2021.01.31.00.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 00:44:15 -0800 (PST)
Subject: Re: [PATCH v2 net-next 07/21] nvme-tcp: Add DDP data-path
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
 <20210114151033.13020-8-borisp@mellanox.com>
 <84cc2af1-22e8-abf5-07da-bc7b4a2b6b12@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <419231da-615c-10c5-7c98-7e049ac54ee7@gmail.com>
Date:   Sun, 31 Jan 2021 10:44:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <84cc2af1-22e8-abf5-07da-bc7b4a2b6b12@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/01/2021 6:18, David Ahern wrote:
> On 1/14/21 8:10 AM, Boris Pismenny wrote:
>> @@ -664,8 +753,15 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
>>  		return -EINVAL;
>>  	}
>>  
>> -	if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
>> -		nvme_complete_rq(rq);
>> +	req = blk_mq_rq_to_pdu(rq);
>> +	if (req->offloaded) {
>> +		req->status = cqe->status;
>> +		req->result = cqe->result;
>> +		nvme_tcp_teardown_ddp(queue, cqe->command_id, rq);
>> +	} else {
>> +		if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
>> +			nvme_complete_rq(rq);
>> +	}
>>  	queue->nr_cqe++;
>>  
>>  	return 0;
>> @@ -859,9 +955,18 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
>>  static inline void nvme_tcp_end_request(struct request *rq, u16 status)
>>  {
>>  	union nvme_result res = {};
>> +	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
>> +	struct nvme_tcp_queue *queue = req->queue;
>> +	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
>>  
>> -	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
>> -		nvme_complete_rq(rq);
>> +	if (req->offloaded) {
>> +		req->status = cpu_to_le16(status << 1);
>> +		req->result = res;
>> +		nvme_tcp_teardown_ddp(queue, pdu->command_id, rq);
>> +	} else {
>> +		if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
>> +			nvme_complete_rq(rq);
>> +	}
>>  }
>>  
>>  static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
> 
> 
> The req->offload checks assume the offload is to the expected
> offload_netdev, but you do not verify the data arrived as expected. You
> might get lucky if both netdev's belong to the same PCI device (assuming
> the h/w handles it a certain way), but it will not if the netdev's
> belong to different devices.
> 
> Consider a system with 2 network cards -- even if it is 2 mlx5 based
> devices. One setup can have the system using a bond with 1 port from
> each PCI device. The tx path picks a leg based on the hash of the ntuple
> and that (with Tariq's bond patches) becomes the expected offload
> device. A similar example holds for a pure routing setup with ECMP. For
> both there is full redundancy in the network - separate NIC cards
> connected to separate TORs to have independent network paths.
> 
> A packet arrives on the *other* netdevice - you have *no* control over
> the Rx path. Your current checks will think the packet arrived with DDP
> but it did not.
> 

There's no problem if another (non-offload) netdevice receives traffic
that arrives here. Because that other device will never set the SKB
frag pages to point to the final destination buffers, and so copy
offload will not take place.

The req->offload indication is mainly for matching ddp_setup with
ddp_teardown calls, it does not control copy/crc offload as these are
controlled per-skb using frags for copy and skb bits for crc.

