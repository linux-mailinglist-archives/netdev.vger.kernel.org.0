Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB84A132
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfFRMyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:54:39 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41457 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRMyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 08:54:39 -0400
Received: by mail-lf1-f67.google.com with SMTP id 136so9176842lfa.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 05:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=rt5N3dxT6EL52OPf/1KKXYt0EJkS/0wv3B/X7MbDn5s=;
        b=f/nm9wMIuFJwkPoGljdMS7rzRRYj+FvznuIBay2wBs7BxEbQ88bN2z11uYecjoB/Mz
         fmMJkgM92UR3Zs8JNQwzrBM1xJEZ8L/tlPjNfmWC6osBvGHDi9mxnSEZCmPdEv+44PRP
         AtpN0IcYQlAZeKkRMqWiW7BbajN1/zmCr5J2eNL9FvIVNpHZlJq7Z0cxxFVtwpRhgNax
         MCL9D/V9tVmS+9Ktf+AabRFQP3UNm4HDJjNATwDZ0oqAO6QOhQYTnBF50lng6DwUot+O
         Gkofm4HF8RfkUuz+CRmbNoLZkSCrpmGjjQvTAhjtzD2OKcIsqZltUFoKJ7b1+ANlVBIK
         pv7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=rt5N3dxT6EL52OPf/1KKXYt0EJkS/0wv3B/X7MbDn5s=;
        b=C/+/bk7LUXV6oA0hW8DP92ezKCmSW0TCHQY1HsNdUuTosJdHXpEQQK/J0dVHjdY0Q9
         RcMsDbp2dsXeZNKUARtstGaqzlseADhEY/LUfLhDEGyhsohdsDIfK3TjDuMqBDUgEHDK
         KwZHcMytYtDzFY6Rx7dsIoLzkBO1t+RBAilUrO7M76sOQHEu/O0aI8jyYujc3myewwuf
         YRmgWRyijCl+QamA3jEuDOQvoNbylNpTz+OCd4vBJa6KclD1xmyQKjaR8sF0KQNsgiFh
         07ARzdq+O47Dg7BYrKo8Cf4VdXAxUM7YOs80Lm2Foxl/jZZBOOeXPFNWJPnEqYmWsp2A
         jVpQ==
X-Gm-Message-State: APjAAAW2dl+NAcUv8Dgkg87zHHRNsJD2ecmhLMy0f9AI5lGO9WCTStM7
        kOfHbBFxQFqukMiDOvEJKBzmXw==
X-Google-Smtp-Source: APXvYqw0r1yWpNBvVGt4QaAfC4TNrWKmhX6mLooI80jzrctAhy4zyo4t6G/7jeNnpYOFA6BEkaeMsQ==
X-Received: by 2002:a19:e05c:: with SMTP id g28mr44759177lfj.167.1560862476238;
        Tue, 18 Jun 2019 05:54:36 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id b6sm2443959lfa.54.2019.06.18.05.54.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Jun 2019 05:54:35 -0700 (PDT)
Date:   Tue, 18 Jun 2019 15:54:33 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "mcroce@redhat.com" <mcroce@redhat.com>
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190618125431.GA5307@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
 <20190615093339.GB3771@khorivan>
 <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 16, 2019 at 10:56:25AM +0000, Tariq Toukan wrote:

Hi Tariq

>
>
>On 6/15/2019 12:33 PM, Ivan Khoronzhuk wrote:
>> On Thu, Jun 13, 2019 at 08:28:42PM +0200, Jesper Dangaard Brouer wrote:
>> Hi, Jesper
>>
>>> This patch is needed before we can allow drivers to use page_pool for
>>> DMA-mappings. Today with page_pool and XDP return API, it is possible to
>>> remove the page_pool object (from rhashtable), while there are still
>>> in-flight packet-pages. This is safely handled via RCU and failed
>>> lookups in
>>> __xdp_return() fallback to call put_page(), when page_pool object is
>>> gone.
>>> In-case page is still DMA mapped, this will result in page note getting
>>> correctly DMA unmapped.
>>>
>>> To solve this, the page_pool is extended with tracking in-flight
>>> pages. And
>>> XDP disconnect system queries page_pool and waits, via workqueue, for all
>>> in-flight pages to be returned.
>>>
>>> To avoid killing performance when tracking in-flight pages, the implement
>>> use two (unsigned) counters, that in placed on different cache-lines, and
>>> can be used to deduct in-flight packets. This is done by mapping the
>>> unsigned "sequence" counters onto signed Two's complement arithmetic
>>> operations. This is e.g. used by kernel's time_after macros, described in
>>> kernel commit 1ba3aab3033b and 5a581b367b5, and also explained in
>>> RFC1982.
>>>
>>> The trick is these two incrementing counters only need to be read and
>>> compared, when checking if it's safe to free the page_pool structure.
>>> Which
>>> will only happen when driver have disconnected RX/alloc side. Thus, on a
>>> non-fast-path.
>>>
>>> It is chosen that page_pool tracking is also enabled for the non-DMA
>>> use-case, as this can be used for statistics later.
>>>
>>> After this patch, using page_pool requires more strict resource
>>> "release",
>>> e.g. via page_pool_release_page() that was introduced in this
>>> patchset, and
>>> previous patches implement/fix this more strict requirement.
>>>
>>> Drivers no-longer call page_pool_destroy(). Drivers already call
>>> xdp_rxq_info_unreg() which call xdp_rxq_info_unreg_mem_model(), which
>>> will
>>> attempt to disconnect the mem id, and if attempt fails schedule the
>>> disconnect for later via delayed workqueue.
>>>
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>> ---
>>> drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    3 -
>>> include/net/page_pool.h                           |   41 ++++++++++---
>>> net/core/page_pool.c                              |   62
>>> +++++++++++++++-----
>>> net/core/xdp.c                                    |   65
>>> +++++++++++++++++++--
>>> 4 files changed, 136 insertions(+), 35 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> index 2f647be292b6..6c9d4d7defbc 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>
>> [...]
>>
>>> --- a/net/core/xdp.c
>>> +++ b/net/core/xdp.c
>>> @@ -38,6 +38,7 @@ struct xdp_mem_allocator {
>>>     };
>>>     struct rhash_head node;
>>>     struct rcu_head rcu;
>>> +    struct delayed_work defer_wq;
>>> };
>>>
>>> static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
>>> @@ -79,13 +80,13 @@ static void __xdp_mem_allocator_rcu_free(struct
>>> rcu_head *rcu)
>>>
>>>     xa = container_of(rcu, struct xdp_mem_allocator, rcu);
>>>
>>> +    /* Allocator have indicated safe to remove before this is called */
>>> +    if (xa->mem.type == MEM_TYPE_PAGE_POOL)
>>> +        page_pool_free(xa->page_pool);
>>> +
>>
>> What would you recommend to do for the following situation:
>>
>> Same receive queue is shared between 2 network devices. The receive ring is
>> filled by pages from page_pool, but you don't know the actual port (ndev)
>> filling this ring, because a device is recognized only after packet is
>> received.
>>
>> The API is so that xdp rxq is bind to network device, each frame has
>> reference
>> on it, so rxq ndev must be static. That means each netdev has it's own rxq
>> instance even no need in it. Thus, after your changes, page must be
>> returned to
>> the pool it was taken from, or released from old pool and recycled in
>> new one
>> somehow.
>>
>> And that is inconvenience at least. It's hard to move pages between
>> pools w/o
>> performance penalty. No way to use common pool either, as unreg_rxq now
>> drops
>> the pool and 2 rxqa can't reference same pool.
>>
>
>Within the single netdev, separate page_pool instances are anyway
>created for different RX rings, working under different NAPI's.

The circumstances are so that same RX ring is shared between 2
netdevs... and netdev can be known only after descriptor/packet is
received. Thus, while filling RX ring, there is no actual device,
but when packet is received it has to be recycled to appropriate
net device pool. Before this change there were no difference from
which pool the page was allocated to fill RX ring, as there were no
owner. After this change there is owner - netdev page pool.

For cpsw the dma unmap is common for both netdevs and no difference
who is freeing the page, but there is difference which pool it's
freed to.

So that, while filling RX ring the page is taken from page pool of
ndev1, but packet is received for ndev2, it has to be later
returned/recycled to page pool of ndev1, but when xdp buffer is
handed over to xdp prog the xdp_rxq_info has reference on ndev2 ...

And no way to predict the final ndev before packet is received, so no
way to choose appropriate page pool as now it becomes page owner.

So, while RX ring filling, the page/dma recycling is needed but should
be some way to identify page owner only after receiving packet.

Roughly speaking, something like:

pool->pages_state_hold_cnt++;

outside of page allocation API, after packet is received.
and free of the counter while allocation (w/o owing the page).

-- 
Regards,
Ivan Khoronzhuk
