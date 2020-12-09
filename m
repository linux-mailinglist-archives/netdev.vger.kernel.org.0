Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1E22D37E4
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgLIAjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLIAjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:39:37 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC138C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 16:38:56 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id i6so615543otr.2
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 16:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kmk2YI7GQKC1QQuseSoGeIYfygPzB7Y5vXtGgunzq1g=;
        b=WkMlaLkCJH7vyvlOeixVsnfgK0mh6dOe3+HtKwabHPmXvrwgvap7IqTRDTz/gFC4Ij
         NgV4Isn6rhdFVRtyQPq0S9S346lFxBdjw0gVTCIhioYYEKA8UaJDjN9hmJKnB0Vbt0jr
         IVdArmNbvqivMA0Cum8tn+WJcjtPChpo3ij7ncRwJVEfaqWj2k84iREySGWM9ITgb76+
         VttrNXfOZY0lxr2W2QFdCmB3k0jWQ3FUE78upJlSxJUR4I8GOSxOkf/9JxV4mD5ZumiB
         uw6FTeUQEaGCbR+YnP37ynwywXfM3vxHGWXNSI2C98KQHbP+Qs1JlFME6qhrV6J7sKAh
         AhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kmk2YI7GQKC1QQuseSoGeIYfygPzB7Y5vXtGgunzq1g=;
        b=ugm0i+eXnGN3JOeb1glbDUFX6SZQxiGUjr1fACJIfKPGfvo8lim/Vh8Orti8e+Llf6
         ye8tsROW97L62k9SUTldsHQGkroVeDL1wTsW5mpYV7yfz3uc7aXC9vx3NUvnlw8ZLs82
         uf27E/sAH69EKQUnHj5pB5srvHVZWH6QO2W87F5d3UfbPAxnAlqESfhQyDLgezX++QGD
         vld97nOMAhbUmJVjfLC4VFEg9g9e05ylwuEoNoCENt3qtSnxzSDgkBA1eZmSY7vp58s1
         H6EmnhJjOn32096po5nXTlnmvFaB/r1z1fDXebggzxLYqA+2t2lcTcacanBhvc6eOWgA
         Fm3w==
X-Gm-Message-State: AOAM530b/TBE5MPZlgoR31HcfJhpPlkYy9vvqyHv8BgYueGxix2gTKQp
        eYb2gSaQQ7EfZp5hDk1210I=
X-Google-Smtp-Source: ABdhPJwm1JwMtli/qsn+3L8ZydaJFHj/WP3suRCiRxghdzjyRC5HquTekV8QNuIhMfmwHIz1c4dd5Q==
X-Received: by 2002:a9d:6317:: with SMTP id q23mr613356otk.251.1607474336008;
        Tue, 08 Dec 2020 16:38:56 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:64fc:adeb:84f9:fa62])
        by smtp.googlemail.com with ESMTPSA id j62sm17564otc.49.2020.12.08.16.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:38:55 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
 <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
 <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
Date:   Tue, 8 Dec 2020 17:38:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/20 7:36 AM, Boris Pismenny wrote:
> On 08/12/2020 2:42, David Ahern wrote:
>> On 12/7/20 2:06 PM, Boris Pismenny wrote:
>>> This commit introduces direct data placement offload for TCP.
>>> This capability is accompanied by new net_device operations that
>>> configure
>>> hardware contexts. There is a context per socket, and a context per DDP
>>> opreation. Additionally, a resynchronization routine is used to assist
>>> hardware handle TCP OOO, and continue the offload.
>>> Furthermore, we let the offloading driver advertise what is the max hw
>>> sectors/segments.
>>>
>>> Using this interface, the NIC hardware will scatter TCP payload directly
>>> to the BIO pages according to the command_id.
>>> To maintain the correctness of the network stack, the driver is expected
>>> to construct SKBs that point to the BIO pages.
>>>
>>> This, the SKB represents the data on the wire, while it is pointing
>>> to data that is already placed in the destination buffer.
>>> As a result, data from page frags should not be copied out to
>>> the linear part.
>>>
>>> As SKBs that use DDP are already very memory efficient, we modify
>>> skb_condence to avoid copying data from fragments to the linear
>>> part of SKBs that belong to a socket that uses DDP offload.
>>>
>>> A follow-up patch will use this interface for DDP in NVMe-TCP.
>>>
>>
>> You call this Direct Data Placement - which sounds like a marketing name.
>>
> 
> [Re-sending as the previous one didn't hit the mailing list. Sorry for the spam]
> 
> Interesting idea. But, unlike SKBTX_DEV_ZEROCOPY this SKB can be inspected/modified by the stack without the need to copy things out. Additionally, the SKB may contain both data that is already placed in its final destination buffer (PDU data) and data that isn't (PDU header); it doesn't matter. Therefore, labeling the entire SKB as zerocopy doesn't convey the desired information. Moreover, skipping copies in the stack to receive zerocopy SKBs will require more invasive changes.
> 
> Our goal in this approach was to provide the smallest change that enables the desired functionality while preserving the performance of existing flows that do not care for it. An alternative approach, that doesn't affect existing flows at all, which we considered was to make a special version of memcpy_to_page to be used by DDP providers (nvme-tcp). This alternative will require creating corresponding special versions for users of this function such skb_copy_datagram_iter. Thit is more invasive, thus in this patchset we decided to avoid it.
> 
>> Fundamentally, this starts with offloading TCP socket buffers for a
>> specific flow, so generically a TCP Rx zerocopy for kernel stack managed
>> sockets (as opposed to AF_XDP's zerocopy). Why is this not building in
>> that level of infrastructure first and adding ULPs like NVME on top?
>>
> 
> We aren't using AF_XDP or any of the Rx zerocopy infrastructure, because it is unsuitable for data placement for nvme-tcp, which reordes responses relatively to requests for efficiency and requires that data reside in specific destination buffers.
> 
> 

The AF_XDP reference was to differentiate one zerocopy use case (all
packets go to userspace) from another (kernel managed TCP socket with
zerocopy payload). You are focusing on a very narrow use case - kernel
based NVMe over TCP - of a more general problem.

You have a TCP socket and a design that only works for kernel owned
sockets. You have specialized queues in the NIC, a flow rule directing
packets to those queues. Presumably some ULP parser in the NIC
associated with the queues to process NVMe packets. Rather than copying
headers (ethernet/ip/tcp) to one buffer and payload to another (which is
similar to what Jonathan Lemon is working on), this design has a ULP
processor that just splits out the TCP payload even more making it
highly selective about which part of the packet is put into which
buffer. Take out the NVMe part, and it is header split with zerocopy for
the payload - a generic feature that can have a wider impact with NVMe
as a special case.

