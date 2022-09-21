Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E9C5D89B6
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiIUSKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiIUSKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:10:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5FC53D39
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663783839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLU56xF3u9q10x5k5ScYLycuHdbGZ3f+n2C69UlIBw4=;
        b=GicKlDS+yOwcq2p9jCjUYfzat8xp3mCvUGXN3WGccMCz4B1UnBc8uXrUw1MCeYWJ2bgz2c
        lcRE/0N8BvVAD5jPas5i+taf36emvfwRCZBuZS+t5oBFFf4kOmi8mFvR82DrfSIlJp4C/R
        ZUAuVE2rCeNalvU9Qz/THrFzuN3Q88k=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-330-6fR_ec-COdipkxdkGiFhPQ-1; Wed, 21 Sep 2022 14:10:36 -0400
X-MC-Unique: 6fR_ec-COdipkxdkGiFhPQ-1
Received: by mail-qv1-f71.google.com with SMTP id mo5-20020a056214330500b004ad711537a6so1787308qvb.10
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=oLU56xF3u9q10x5k5ScYLycuHdbGZ3f+n2C69UlIBw4=;
        b=KrpGNoLCVyANKAZH+vxfKIdbV0gsgyFfrUKI5oJGNT5y3bwAQbMCMqQotmoEltUh0j
         t+uGUPfTvpxK0dQI5M0GRY93YNyqPxm8Xd7+0yk1JbvLked71cynIdVU7dVWesnnhdvO
         GLzmuq6kH/bGKc0KEvFwro03iLIIGLiNCYUy/Nb3/7xcXX4zLlXFmh2zUNddejtRzdpq
         1cEgz4CAaNjbV2MGfkpq7kfrWDaCTagjwiy6QAtrSR0TN6MYzzbm3RgimbTDTLESPJm7
         nNio545VCnG9FCejpH89YOkrruDfls6hwVkAP3VYbEmT5YGc0E2x9NDFxDyHuEPOo4MJ
         5LcQ==
X-Gm-Message-State: ACrzQf2hjf0MS0gmD5mvzTYWueZJ2XfBp2WkBjeSaFg9LIv/zVQx4dWi
        jlQi6jyP+ySu70v265FHFVFySVkYqKXY8MUXC4nvjZKQ3E0wn02ued/vYrMBbzeA6ihZnF7+TWW
        GfPT3R8fU2PIwO7Ip
X-Received: by 2002:ac8:7f46:0:b0:35c:da6b:cfbc with SMTP id g6-20020ac87f46000000b0035cda6bcfbcmr20156571qtk.553.1663783835402;
        Wed, 21 Sep 2022 11:10:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ty7UpKj9xIE6oMA8UZKkHuhO5CZZ5USnoRciAu1qxG73zy+qsm8TwSeq5dMxQDCt8phAc/A==
X-Received: by 2002:ac8:7f46:0:b0:35c:da6b:cfbc with SMTP id g6-20020ac87f46000000b0035cda6bcfbcmr20156539qtk.553.1663783835089;
        Wed, 21 Sep 2022 11:10:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id l27-20020a37f91b000000b006ce580c2663sm2329352qkj.35.2022.09.21.11.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 11:10:34 -0700 (PDT)
Message-ID: <9cd1e24a4fb22136caaeecb2eb81d7652e6dd220.camel@redhat.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag
 cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 21 Sep 2022 20:10:31 +0200
In-Reply-To: <CANn89iK=hdV0Wya8nrdZ=z=yipAxg3OPEOBWT_arzYSuXDENLw@mail.gmail.com>
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
         <CANn89iK=hdV0Wya8nrdZ=z=yipAxg3OPEOBWT_arzYSuXDENLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 10:18 -0700, Eric Dumazet wrote:
> On Wed, Sep 21, 2022 at 9:42 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> > for tiny skbs") we are observing 10-20% regressions in performance
> > tests with small packets. The perf trace points to high pressure on
> > the slab allocator.
> > 
> > This change tries to improve the allocation schema for small packets
> > using an idea originally suggested by Eric: a new per CPU page frag is
> > introduced and used in __napi_alloc_skb to cope with small allocation
> > requests.
> > 
> > To ensure that the above does not lead to excessive truesize
> > underestimation, the frag size for small allocation is inflated to 1K
> > and all the above is restricted to build with 4K page size.
> > 
> > Note that we need to update accordingly the run-time check introduced
> > with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").
> > 
> > Alex suggested a smart page refcount schema to reduce the number
> > of atomic operations and deal properly with pfmemalloc pages.
> > 
> > Under small packet UDP flood, I measure a 15% peak tput increases.
> > 
> > Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Suggested-by: Alexander H Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > @Eric, @Alex please let me know if you are comfortable with the
> > attribution
> > ---
> >  include/linux/netdevice.h |   1 +
> >  net/core/dev.c            |  17 ------
> >  net/core/skbuff.c         | 115 +++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 113 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 9f42fc871c3b..a1938560192a 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3822,6 +3822,7 @@ void netif_receive_skb_list(struct list_head *head);
> >  gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
> >  void napi_gro_flush(struct napi_struct *napi, bool flush_old);
> >  struct sk_buff *napi_get_frags(struct napi_struct *napi);
> > +void napi_get_frags_check(struct napi_struct *napi);
> >  gro_result_t napi_gro_frags(struct napi_struct *napi);
> >  struct packet_offload *gro_find_receive_by_type(__be16 type);
> >  struct packet_offload *gro_find_complete_by_type(__be16 type);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index d66c73c1c734..fa53830d0683 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6358,23 +6358,6 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
> >  }
> >  EXPORT_SYMBOL(dev_set_threaded);
> > 
> > -/* Double check that napi_get_frags() allocates skbs with
> > - * skb->head being backed by slab, not a page fragment.
> > - * This is to make sure bug fixed in 3226b158e67c
> > - * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > - * does not accidentally come back.
> > - */
> > -static void napi_get_frags_check(struct napi_struct *napi)
> > -{
> > -       struct sk_buff *skb;
> > -
> > -       local_bh_disable();
> > -       skb = napi_get_frags(napi);
> > -       WARN_ON_ONCE(skb && skb->head_frag);
> > -       napi_free_frags(napi);
> > -       local_bh_enable();
> > -}
> > -
> >  void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
> >                            int (*poll)(struct napi_struct *, int), int weight)
> >  {
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index f1b8b20fc20b..2be11b487df1 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -134,8 +134,73 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
> >  #define NAPI_SKB_CACHE_BULK    16
> >  #define NAPI_SKB_CACHE_HALF    (NAPI_SKB_CACHE_SIZE / 2)
> > 
> > +/* the compiler doesn't like 'SKB_TRUESIZE(GRO_MAX_HEAD) > 512', but we
> > + * can imply such condition checking the double word and MAX_HEADER size
> > + */
> > +#if PAGE_SIZE == SZ_4K && (defined(CONFIG_64BIT) || MAX_HEADER > 64)
> > +
> > +#define NAPI_HAS_SMALL_PAGE_FRAG 1
> > +
> > +/* specializzed page frag allocator using a single order 0 page
> > + * and slicing it into 1K sized fragment. Constrained to system
> > + * with:
> > + * - a very limited amount of 1K fragments fitting a single
> > + *   page - to avoid excessive truesize underestimation
> > + * - reasonably high truesize value for napi_get_frags()
> > + *   allocation - to avoid memory usage increased compared
> > + *   to kalloc, see __napi_alloc_skb()
> > + *
> > + */
> > +struct page_frag_1k {
> > +       void *va;
> > +       u16 offset;
> > +       bool pfmemalloc;
> > +};
> > +
> > +static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
> > +{
> > +       struct page *page;
> > +       int offset;
> > +
> > +       if (likely(nc->va)) {
> > +               offset = nc->offset - SZ_1K;
> > +               if (likely(offset >= 0))
> > +                       goto out;
> > +
> > +               put_page(virt_to_page(nc->va));
> 
> This probably can be removed, if the page_ref_add() later is adjusted by one ?

I think you are right. It looks like we never touch the page after the
last fragment is used. One less atomic operation :) And one less cold
cacheline accessed.

I read the above as you are somewhat ok with the overall size and
number of conditionals in this change, am I guessing too much?

Thanks!

Paolo 


