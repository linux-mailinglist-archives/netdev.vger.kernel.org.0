Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7EC3FDF42
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245064AbhIAQCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:02:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233049AbhIAQCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630512068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ELi0qf4aK3uP7dRRYETNlOTJbJ5D1N+KxdPfGPTw4A=;
        b=QN2EM4A9Utddz7HFg43nbDoZF5TSox405roo6YHqBXmB1nY3lVlPUBcZ7p67BPlEtWTJYb
        SECFIPFEFHdNfsgWuKzRG2/oxEQ0agL+YrBa9Lnf6bvhppr0qxPnfnkl/+O/SXc/0Z2/LC
        lO/Qh+xgwi1kUTRBMnP+4oD8r0eVpUI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-iYbBF9J4ObWrZu5tlmx-MA-1; Wed, 01 Sep 2021 12:01:07 -0400
X-MC-Unique: iYbBF9J4ObWrZu5tlmx-MA-1
Received: by mail-wm1-f71.google.com with SMTP id u1-20020a05600c210100b002e74fc5af71so74205wml.1
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 09:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0ELi0qf4aK3uP7dRRYETNlOTJbJ5D1N+KxdPfGPTw4A=;
        b=cCGeFfRRBgVaiXhIdI1pqpx7OibOpibzFh6QaeKT1dv2OVHTOtS3YdCqiN3qbGJuAu
         f2hYQqLRnYdII64vw1wYiqFe2Sw/Lk/lULXCyB37qpv0+4POUvsUI4OBVy/bDhIUyflH
         sjAJDdICaLdteH8Bnip3Cai4MQWfh0F68F3XqllrM24KYq7tf82xcPNlH4OzYotjEGEp
         prRYDFLnh0DWI2px7L+vCo9Zt+TjL9kUBUV7rZDH0IlpqF2MTMl2LRsHSebZq9PnZuE8
         taJv+hUtbLWpJrzcjPLtNg9sWDUdS6SNIBVEsGn7zTJTaoTeH8LSK/6elpagLNQQb8R2
         4ESA==
X-Gm-Message-State: AOAM533xFCP60tuw3H4VcDeP7cuKPaINU13N/Bq70tCNtKiE1bSaSTtH
        oFt5wwUhPAcMLZP/QHSnM8kJZ75s+t5au99xDW2dn1wG3ZcUPzpXeL7B8NzU3YXSxVjf3tkk+Lx
        hHSnhTtYJsoCtNqk+
X-Received: by 2002:a1c:3542:: with SMTP id c63mr148693wma.68.1630512065180;
        Wed, 01 Sep 2021 09:01:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwz//bcO1LgzAECo7e8PoJZgBJq8fM+kTkmrO6ASs7HDmNmYuidKFDlOTnbPgfVTlShl2wHLA==
X-Received: by 2002:a1c:3542:: with SMTP id c63mr148631wma.68.1630512064673;
        Wed, 01 Sep 2021 09:01:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-233-185.dyn.eolo.it. [146.241.233.185])
        by smtp.gmail.com with ESMTPSA id d124sm847wmd.2.2021.09.01.09.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 09:01:04 -0700 (PDT)
Message-ID: <59ad13bb312805bb1d183c5817d5f7b6fd6a90dd.camel@redhat.com>
Subject: Re: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in
 sk_stream_alloc_skb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Date:   Wed, 01 Sep 2021 18:01:03 +0200
In-Reply-To: <c40a178110ee705b2be32272b9b3e512a40a4cae.camel@redhat.com>
References: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
         <9c9ef2228dfcb950b5c75382bd421c6169e547a0.camel@redhat.com>
         <CANn89iJFeM=DgcQpDbaE38uhxTEL6REMWPnVFt7Am7Nuf4wpMw@mail.gmail.com>
         <CANn89iKbgtb84Lb4UOxUCb_WGrfB6ZoD=bVH2O06-Mm6FBmwpg@mail.gmail.com>
         <c40a178110ee705b2be32272b9b3e512a40a4cae.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-01 at 17:25 +0200, Paolo Abeni wrote:
> On Wed, 2021-09-01 at 08:16 -0700, Eric Dumazet wrote:
> > On Wed, Sep 1, 2021 at 8:06 AM Eric Dumazet <edumazet@google.com> wrote:
> > > On Wed, Sep 1, 2021 at 3:52 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > On Wed, 2021-09-01 at 18:39 +0800, Yunsheng Lin wrote:
> > > > > Since tcp_tx_skb_cache is disabled by default in:
> > > > > commit 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")
> > > > > 
> > > > > Add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb() to
> > > > > avoid possible branch-misses.
> > > > > 
> > > > > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > > > 
> > > > Note that MPTCP is currently exploiting sk->sk_tx_skb_cache. If we get
> > > > this patch goes in as-is, it will break mptcp.
> > > > 
> > > > One possible solution would be to let mptcp usage enable sk-
> > > > > sk_tx_skb_cache, but that has relevant side effects on plain TCP.
> > > > 
> > > > Another options would be re-work once again the mptcp xmit path to
> > > > avoid using sk->sk_tx_skb_cache.
> > > > 
> > > 
> > > Hmmm, I actually wrote a revert of this feature but forgot to submit
> > > it last year.
> > > 
> > > commit c36cfbd791f62c0f7c6b32132af59dfdbe6be21b (HEAD -> listener_scale4)
> > > Author: Eric Dumazet <edumazet@google.com>
> > > Date:   Wed May 20 06:38:38 2020 -0700
> > > 
> > >     tcp: remove sk_{tr}x_skb_cache
> > > 
> > >     This reverts the following patches :
> > > 
> > >     2e05fcae83c41eb2df10558338dc600dc783af47 ("tcp: fix compile error
> > > if !CONFIG_SYSCTL")
> > >     4f661542a40217713f2cee0bb6678fbb30d9d367 ("tcp: fix zerocopy and
> > > notsent_lowat issues")
> > >     472c2e07eef045145bc1493cc94a01c87140780a ("tcp: add one skb cache for tx")
> > >     8b27dae5a2e89a61c46c6dbc76c040c0e6d0ed4c ("tcp: add one skb cache for rx")
> > > 
> > >     Having a cache of one skb (in each direction) per TCP socket is fragile,
> > >     since it can cause a significant increase of memory needs,
> > >     and not good enough for high speed flows anyway where more than one skb
> > >     is needed.
> > > 
> > >     We want instead to add a generic infrastructure, with more flexible per-cpu
> > >     caches, for alien NUMA nodes.
> > > 
> > >     Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > 
> > > I will update this commit to also remove the part in MPTCP.
> > > 
> > > Let's remove this feature and replace it with something less costly.
> > 
> > Paolo, can you work on MPTP side, so that my revert can be then applied ?
> 
> You are way too fast, I was still replying to your previous email,
> asking if I could help :)
> 
> I'll a look ASAP. Please, allow for some latency: I'm way slower!

I think the easiest way and the one with less code duplication will
require accessing the tcp_mark_push() and skb_entail() helpers from the
MPTCP code, making them not static and exposing them e.g. in net/tcp.h.
Would that be acceptable or should I look for other options?

Thanks!

Paolo

