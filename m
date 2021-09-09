Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD5404BD3
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbhIILxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239336AbhIILvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 07:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631188200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RKfLJTAdYC2Y9GCkgvCCUXZUeq0mgeJOjy8yY6oupzQ=;
        b=UW6AKKbbUFLu7KJnjtdZoYnQPfHeJy5+sqEaCNp2H7o78x0cJWRhZBbUYCRtyoEa3U3ZHQ
        RLb1/+VhJYmVgn1kKrUY5ZsJp3zZ6wUo9j5uvFY6jYD1CmACEaes+1KXCFycSI5BBndIHP
        Pst+DKVLDlUcvSqNuN+D0Henh64uPTw=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-_TNTXMe4OeKdCq4915qMWA-1; Thu, 09 Sep 2021 07:49:59 -0400
X-MC-Unique: _TNTXMe4OeKdCq4915qMWA-1
Received: by mail-lj1-f199.google.com with SMTP id a38-20020a05651c212600b001ca48d59b47so622844ljq.22
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 04:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RKfLJTAdYC2Y9GCkgvCCUXZUeq0mgeJOjy8yY6oupzQ=;
        b=T/OfzkI7RDXWvnwt9NaMzp7YS01axG6PHnQtPE4BvJtpOYY26DkryElVGFfDaacr2q
         PBgM/XbADwnhif4W+Ra/Opq70QVdOCvdNnx5Q+VMeJl+M2mzqFEBhvPZhcsCuPt04WB+
         vVFVhWvapo6e5zFpTNK/hPsQmR9ITnY8v+b8TNZrcGD4wMRqCTb5OvsGvyGDQJDoV0C0
         3vJerlXxk7Rp8P0KohP/zvceZ3Ek3NtI8itmDK5AJilPcpjsG6BHmnnczrNGjRuDdRIr
         3Use53HoNOOTqKKM8Ufg6ngD5WIpcMGNb7Xiz0IyBforT5cWTnSK/nAD2hsB0aVVg8DS
         gZkA==
X-Gm-Message-State: AOAM5300/B1eJ/cNF26ssaOja8qcyPGiik7B0Mgy6o8xQq+6dA48Ct9d
        4pp/D5/5vcdAT7Gp4IFDGzvBPobh/qluSwwa/w6CAdzpn2KLx9pev2bh73tFWnS7DEH4t/Tj9Nh
        6L+BhODOyqyMNhj3U
X-Received: by 2002:a2e:22c1:: with SMTP id i184mr1949081lji.89.1631188197672;
        Thu, 09 Sep 2021 04:49:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz34yVkVFly2lKRUz3Skw91yuJ8Zn8SuJWptdAhy+rymLtvnXvn9lAbezazF8CfkxsLTbZMFQ==
X-Received: by 2002:a2e:22c1:: with SMTP id i184mr1949056lji.89.1631188197447;
        Thu, 09 Sep 2021 04:49:57 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id t30sm173712lfg.289.2021.09.09.04.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 04:49:56 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net 0/2] sfc: fallback for lack of xdp tx queues
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ivan Babrou <ivan@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Toke Hoiland Jorgensen <toke@redhat.com>,
        Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>
References: <20210909092846.18217-1-ihuguet@redhat.com>
Message-ID: <d36c51ae-1832-effa-ee5c-fdebdeec5c5c@redhat.com>
Date:   Thu, 9 Sep 2021 13:49:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210909092846.18217-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Great work Huguet, patches LGTM, I would ACK but they have already been 
applied:

Here is the summary with links:
   - [net,1/2] sfc: fallback for lack of xdp tx queues
     https://git.kernel.org/netdev/net/c/415446185b93
   - [net,2/2] sfc: last resort fallback for lack of xdp tx queues
     https://git.kernel.org/netdev/net/c/6215b608a8c4

Cloudflare (cc) heads-up for these improvements.

And heads-up to Toke and Frey on patch 2/2, as it creates push-back via 
TX queue stop/restart logic (see kernel API netif_tx_queue_stopped).
XDP currently doesn't handle this well, but I hope to see XDP queueing 
work from your side to improve the situation ;-)


On 09/09/2021 11.28, Íñigo Huguet wrote:
> If there are not enough hardware resources to allocate one tx queue per
> CPU for XDP, XDP_TX and XDP_REDIRECT actions were unavailable, and using
> them resulted each time with the packet being drop and this message in
> the logs: XDP TX failed (-22)
> 
> These patches implement 2 fallback solutions for 2 different situations
> that might happen:
> 1. There are not enough free resources for all the tx queues, but there
>     are some free resources available
> 2. There are not enough free resources at all for tx queues.
> 
> Both solutions are based in sharing tx queues, using __netif_tx_lock for
> synchronization. In the second case, as there are not XDP TX queues to
> share, network stack queues are used instead, but since we're taking
> __netif_tx_lock, concurrent access to the queues is correctly protected.
> 
> The solution for this second case might affect performance both of XDP
> traffic and normal traffice due to lock contention if both are used
> intensively. That's why I call it a "last resort" fallback: it's not a
> desirable situation, but at least we have XDP TX working.
> 
> Some tests has shown good results and indicate that the non-fallback
> case is not being damaged by this changes. They are also promising for
> the fallback cases. This is the test:
> 1. From another machine, send high amount of packets with pktgen, script
>     samples/pktgen/pktgen_sample04_many_flows.sh
> 2. In the tested machine, run samples/bpf/xdp_rxq_info with arguments
>     "-a XDP_TX --swapmac" and see the results
> 3. In the tested machine, run also pktgen_sample04 to create high TX
>     normal traffic, and see how xdp_rxq_info results vary
> 
> Note that this test doesn't check the worst situations for the fallback
> solutions because XDP_TX will only be executed from the same CPUs that
> are processed by sfc, and not from every CPU in the system, so the
> performance drop due to the highest locking contention doesn't happen.
> I'd like to test that, as well, but I don't have access right now to a
> proper environment.
> 
> Test results:
> 
> Without doing TX:
> Before changes: ~2,900,000 pps
> After changes, 1 queues/core: ~2,900,000 pps
> After changes, 2 queues/core: ~2,900,000 pps
> After changes, 8 queues/core: ~2,900,000 pps
> After changes, borrowing from network stack: ~2,900,000 pps
> 
> With multiflow TX at the same time:
> Before changes: ~1,700,000 - 2,900,000 pps
> After changes, 1 queues/core: ~1,700,000 - 2,900,000 pps
> After changes, 2 queues/core: ~1,700,000 pps
> After changes, 8 queues/core: ~1,700,000 pps
> After changes, borrowing from network stack: 1,150,000 pps
> 
> Sporadic "XDP TX failed (-5)" warnings are shown when running xdp program
> and pktgen simultaneously. This was expected because XDP doesn't have any
> buffering system if the NIC is under very high pressure. Thousands of
> these warnings are shown in the case of borrowing net stack queues. As I
> said before, this was also expected.
> 
> 
> Íñigo Huguet (2):
>    sfc: fallback for lack of xdp tx queues
>    sfc: last resort fallback for lack of xdp tx queues
> 
>   drivers/net/ethernet/sfc/efx_channels.c | 98 ++++++++++++++++++-------
>   drivers/net/ethernet/sfc/net_driver.h   |  8 ++
>   drivers/net/ethernet/sfc/tx.c           | 29 ++++++--
>   3 files changed, 99 insertions(+), 36 deletions(-)
> 

