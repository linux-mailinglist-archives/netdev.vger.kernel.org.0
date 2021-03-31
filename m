Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF5D34FB47
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhCaILh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234303AbhCaILV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617178280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0J4qcn0paWrAVMQjtUrK8BLoP3CjRvLK/IEjwal2LdA=;
        b=CfYueKfENq1kGqUqmK2C7dukezG9rLklxy1WBubkWhXOleNBXjDy9MjW3sczLHdohXo7tF
        9Xblyzo0137SpkF+l2fD45tNOZPPdI0B0y6jKzizsatL6ZI9rzmhvwhHkOBbVJGbpAH/uu
        /LTuEQ7ZPNJlclDGHOmZwI5AumscOl0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-uV35DSd1OHmCe83zrqN5lQ-1; Wed, 31 Mar 2021 04:11:18 -0400
X-MC-Unique: uV35DSd1OHmCe83zrqN5lQ-1
Received: by mail-wr1-f69.google.com with SMTP id e10so579719wru.13
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0J4qcn0paWrAVMQjtUrK8BLoP3CjRvLK/IEjwal2LdA=;
        b=fQSgWQuJs4hye3okcBNvcpfL9NN4LdPaR4XQ+rkzfNyPIjjKeepFmPrw5MctK6THmv
         w4ppO6MRXF1iSVD4s+XYceTT1eeJeFsdkQJdxMK6h1YtzCQ290d08lZiEqIYDMfWmARk
         B6g+EYBWGmWIhcxBNlpFBJl6VtdjvgREJSocAzopcgwXYDvq5WEn0D3sxuhTNZP001WW
         kxd9iagBrz1yHPM78ZpNbCN0AfoXpPmI4ljARhdcE9lNnHnptXtlU830y2GrO5+CJyep
         PQj/8IZ+lvrgzSJKfVj3F2r/crKeUWqaX8GdJH/J0VzpAtW0o9Jt18XcsPwHY2nDmU/H
         cghQ==
X-Gm-Message-State: AOAM532j7fmPyHBYIpB3fNuSHAhomoN+Wqgx8BWDvE1MNJYrbrA/rizd
        c5f8JOfOCleuD9p9I1nEt3u6AstitYQDiwOKr6FHgppnEXL+OIiZYyx3LinX88jHzpI4yt3245Z
        BbJpQd/4ChnXYkXEd
X-Received: by 2002:adf:fb91:: with SMTP id a17mr2261130wrr.118.1617178277424;
        Wed, 31 Mar 2021 01:11:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRcpszLoma+OZHdF5ED9mJERo8ZT7f8GRBtmXA07p+tNrAGHPJgHYggMFqYGzKS77NaHc5yA==
X-Received: by 2002:adf:fb91:: with SMTP id a17mr2261111wrr.118.1617178277249;
        Wed, 31 Mar 2021 01:11:17 -0700 (PDT)
Received: from redhat.com ([2a10:800e:f0d3:0:b69b:9fb8:3947:5636])
        by smtp.gmail.com with ESMTPSA id c11sm2996352wrm.67.2021.03.31.01.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:11:15 -0700 (PDT)
Date:   Wed, 31 Mar 2021 04:11:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
Message-ID: <20210331040405-mutt-send-email-mst@kernel.org>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <1617007696.5731978-1-xuanzhuo@linux.alibaba.com>
 <CANn89iLXfu7mdk+cxqVYxtJhfBQtpho6i2kyOEUbEGPXBQj+jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLXfu7mdk+cxqVYxtJhfBQtpho6i2kyOEUbEGPXBQj+jg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 11:06:09AM +0200, Eric Dumazet wrote:
> On Mon, Mar 29, 2021 at 10:52 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > On Wed, 13 Jan 2021 08:18:19 -0800, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Both virtio net and napi_get_frags() allocate skbs
> > > with a very small skb->head
> > >
> > > While using page fragments instead of a kmalloc backed skb->head might give
> > > a small performance improvement in some cases, there is a huge risk of
> > > under estimating memory usage.
> > >
> > > For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 allocations
> > > per page (order-3 page in x86), or even 64 on PowerPC
> > >
> > > We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> > > but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
> > >
> > > Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> > > would still be there on arches with PAGE_SIZE >= 32768
> > >
> > > This patch makes sure that small skb head are kmalloc backed, so that
> > > other objects in the slab page can be reused instead of being held as long
> > > as skbs are sitting in socket queues.
> > >
> > > Note that we might in the future use the sk_buff napi cache,
> > > instead of going through a more expensive __alloc_skb()
> > >
> > > Another idea would be to use separate page sizes depending
> > > on the allocated length (to never have more than 4 frags per page)
> > >
> > > I would like to thank Greg Thelen for his precious help on this matter,
> > > analysing crash dumps is always a time consuming task.
> >
> >
> > This patch causes a performance degradation of about 10% in the scenario of
> > virtio-net + GRO.
> >
> > For GRO, there is no way to merge skbs based on frags with this patch, only
> > frag_list can be used to link skbs. The problem that this cause are that compared
> > to the GRO package merged into the frags way, the current skb needs to call
> > kfree_skb_list to release each skb, resulting in performance degradation.
> >
> > virtio-net will store some data onto the linear space after receiving it. In
> > addition to the header, there are also some payloads, so "headlen <= offset"
> > fails. And skb->head_frag is failing when use kmalloc() for skb->head allocation.
> >
> 
> Thanks for the report.
> 
> There is no way we can make things both fast for existing strategies
> used by _insert_your_driver
> and malicious usages of data that can sit for seconds/minutes in socket queues.
> 
> I think that if you want to gain this 10% back, you have to change
> virtio_net to meet optimal behavior.
> 
> Normal drivers make sure to not pull payload in skb->head, only headers.

Hmm we do have hdr_len field, but seem to ignore it on RX.
Jason do you see any issues with using it for the head len?


> Optimal GRO packets are when payload is in page fragments.
> 
> (I am speaking not only for raw performance, but ability for systems
> to cope with network outages and sudden increase of memory usage in
> out of order queues)
> 
> This has been quite clearly stated in my changelog.
> 
> Thanks.
> 
> 
> > int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > {
> >         struct skb_shared_info *pinfo, *skbinfo = skb_shinfo(skb);
> >         unsigned int offset = skb_gro_offset(skb);
> >         unsigned int headlen = skb_headlen(skb);
> >
> >     .......
> >
> >         if (headlen <= offset) {         // virtio-net will fail
> >         ........ // merge by frags
> >                 goto done;
> >         } else if (skb->head_frag) {     // skb->head_frag is fail when use kmalloc() for skb->head allocation
> >         ........ // merge by frags
> >                 goto done;
> >         }
> >
> > merge:
> >     ......
> >
> >         if (NAPI_GRO_CB(p)->last == p)
> >                 skb_shinfo(p)->frag_list = skb;
> >         else
> >                 NAPI_GRO_CB(p)->last->next = skb;
> >
> >     ......
> >         return 0;
> > }
> >
> >
> > test cmd:
> >  for i in $(seq 1 4)
> >  do
> >     redis-benchmark -r 10000000 -n 10000000 -t set -d 1024 -c 8 -P 32 -h  <ip> -p 6379 2>&1 | grep 'per second'  &
> >  done
> >
> > Reported-by: su-lifan@linux.alibaba.com
> >
> > >
> > > Fixes: fd11a83dd363 ("net: Pull out core bits of __netdev_alloc_skb and add __napi_alloc_skb")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Greg Thelen <gthelen@google.com>
> > > ---
> > >  net/core/skbuff.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 7626a33cce590e530f36167bd096026916131897..3a8f55a43e6964344df464a27b9b1faa0eb804f3 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -501,13 +501,17 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
> > >  struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > >                                gfp_t gfp_mask)
> > >  {
> > > -     struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> > > +     struct napi_alloc_cache *nc;
> > >       struct sk_buff *skb;
> > >       void *data;
> > >
> > >       len += NET_SKB_PAD + NET_IP_ALIGN;
> > >
> > > -     if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
> > > +     /* If requested length is either too small or too big,
> > > +      * we use kmalloc() for skb->head allocation.
> > > +      */
> > > +     if (len <= SKB_WITH_OVERHEAD(1024) ||
> > > +         len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> > >           (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > >               skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
> > >               if (!skb)
> > > @@ -515,6 +519,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > >               goto skb_success;
> > >       }
> > >
> > > +     nc = this_cpu_ptr(&napi_alloc_cache);
> > >       len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > >       len = SKB_DATA_ALIGN(len);
> > >
> > > --
> > > 2.30.0.284.gd98b1dd5eaa7-goog
> > >

