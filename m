Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDFD5F1118
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiI3Rpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiI3Rpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:45:40 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44C812F3C6
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 10:45:39 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 126so6108777ybw.3
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=nyBAE1EdX2jul50McZRlmHtsFbPSR3r+In4JaOoFqWc=;
        b=ofUxDbt70vhz2iu4prBJUzj7lnclZAY6qL9Fn4vvD9rPWX3NKStZIY8UwwxZXfvk7N
         Ij/JDBD94yTCTDiWMYnAgjaZs05x3WWRiv1ghRVmmyJ+wMHyWJq+hk88jFAH9E3fKMGR
         N7TEH3ECVeQX+7khgE+DbGPU/livwQhH+0jQY01KDqrgXFYOdYtr9QBtxFuX7THg8+fE
         72GkP9mmuuB1nRUGwz2G4DLdItrG41jYAUD6OUvYXq4wNOD27j0VNLUgYzBNaar9TDrh
         QVU4j9hz/zT+bl3Gng6sf16hc4YnmcYMCZmVvUAd3grfWltbqaNK4QEx++wgU3ti84Qt
         b6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=nyBAE1EdX2jul50McZRlmHtsFbPSR3r+In4JaOoFqWc=;
        b=cM+ilryjE4HHxesO3NOUYKDPWtb7pijH3kgHfKD+epUHGvGO2xpQXAuOiZDKfscDAy
         RS5w+MvZ0HVtXelXb8F6mDJEwpVs5GeTBsDCSTrdr+Wwazlxh+/5yIQRwjQOpmuwoI1h
         izkhQMpPziJRDhgIibBBEBczrX+qAYbFTF0g2t/f9vu2v9SC2Ndc9Q+9hzPr07sR9Ijk
         rHtw7M8Sv+1jFPkYtTgD+zsA7AJtz0BHTM/H5fVif/W4ZHR1tP8v/2gY1tvCItYGEvpS
         D8xTy1jf3zXtdpXCJRkc5b6vtl3ShU9DCAM5HU+VpXAIhj5z3+f0rAVSXNUQ2R+6Symy
         /cHw==
X-Gm-Message-State: ACrzQf3DflBv4J7G1J+zvKVLuu5NpWA4PP0lBvOSOhgzwBeVvbvKK4hN
        iggjfgkoYY7YPMSnqOCPQOrvoUHJ6egbLfFHP52aCCneB4Y=
X-Google-Smtp-Source: AMsMyM5h3JTknTuleUCOKsAFKlpXS/d53UKssCUQdyRH66dZf3cQLi+DLHr0X7hqbypkHMDfrnQ5jdHRAzMPuygNX4I=
X-Received: by 2002:a25:d103:0:b0:6bc:eae5:9b6d with SMTP id
 i3-20020a25d103000000b006bceae59b6dmr4082052ybg.407.1664559938718; Fri, 30
 Sep 2022 10:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
 <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
 <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com> <cdbfe4615ffec2bcfde94268dbc77dfa98143f39.camel@redhat.com>
In-Reply-To: <cdbfe4615ffec2bcfde94268dbc77dfa98143f39.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Sep 2022 10:45:27 -0700
Message-ID: <CANn89i+SjRtpG9e3gJjh7sNELUYETSkOi86Qk_eC2sQOV39UGg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 10:30 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Fri, 2022-09-30 at 09:43 -0700, Eric Dumazet wrote:
> > On Thu, Sep 29, 2022 at 7:21 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > >
> > > Hello:
> > >
> > > This patch was applied to netdev/net-next.git (master)
> > > by Jakub Kicinski <kuba@kernel.org>:
> > >
> > > On Wed, 28 Sep 2022 10:43:09 +0200 you wrote:
> > > > After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> > > > for tiny skbs") we are observing 10-20% regressions in performance
> > > > tests with small packets. The perf trace points to high pressure on
> > > > the slab allocator.
> > > >
> > > > This change tries to improve the allocation schema for small packets
> > > > using an idea originally suggested by Eric: a new per CPU page frag is
> > > > introduced and used in __napi_alloc_skb to cope with small allocation
> > > > requests.
> > > >
> > > > [...]
> > >
> > > Here is the summary with links:
> > >   - [net-next,v4] net: skb: introduce and use a single page frag cache
> > >     https://git.kernel.org/netdev/net-next/c/dbae2b062824
> > >
> >
> > Paolo, this patch adds a regression for TCP RPC workloads (aka TCP_RR)
> >
> > Before the patch, cpus servicing NIC interrupts were allocating
> > SLAB/SLUB objects for incoming packets,
> > but they were also freeing skbs from TCP rtx queues when ACK packets
> > were processed. SLAB/SLUB caches
> > were efficient (hit ratio close to 100%)
>
> Thank you for the report. Is that reproducible with netperf TCP_RR and
> CONFIG_DEBUG_SLAB, I guess? Do I need specific request/response sizes?

No CONFIG_DEBUG_SLAB, simply standard SLAB, and tcp_rr tests on an AMD
host with 256 cpus...


>
> Do you think a revert will be needed for 6.1?

No need for a revert, I am sure we can add a followup.

>
> > After the patch, these CPU only free skbs from TCP rtx queues and
> > constantly have to drain their alien caches,
> > thus competing with the mm spinlocks. RX skbs allocations being done
> > by page frag allocation only left kfree(~1KB) calls.
> >
> > One way to avoid the asymmetric behavior would be to switch TCP to
> > also use page frags for TX skbs,
> > allocated from tcp_stream_alloc_skb()
>
> I guess we should have:
>

Note that typical skb allocated from tcp sendmsg() have size==0 (all
payload is put in skb frag, not in skb->head)

>         if (<alloc size is small and NAPI_HAS_SMALL_PAGE>)
>                 <use small page frag>
>         else
>                 <use current allocator>
>
> right in tcp_stream_alloc_skb()? or all the way down to __alloc_skb()?

We could first try in tcp_stream_alloc_skb()

>
> Thanks!
>
> Paolo
>
>
>
> >
>
