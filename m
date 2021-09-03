Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB285400411
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350156AbhICRYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:24:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349819AbhICRYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630689794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W+TaHnw1m4QF3+gFNvlmfVjI3Eug4gclNUnkDmbww1M=;
        b=c2EmbHV/kBLZSzBlpZ0bq36BQl5Ih1ZYzUtJ+Vtxwd8vxcas++g/zBJf3HURY4JncCzpCm
        sNaIny4Wrenw1Vtai2sKAjxL3VjXaF0h0K4SdIvSQ/iUmKG3Kd5i0oLjUy8/7k/LPM1DLK
        2TVh/3V9silIVSnKC6IldjLA/8lCu+I=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-vep_D2SaN1WQTwqnfUqGNA-1; Fri, 03 Sep 2021 13:23:13 -0400
X-MC-Unique: vep_D2SaN1WQTwqnfUqGNA-1
Received: by mail-yb1-f199.google.com with SMTP id 63-20020a250d42000000b0059dc43162c9so7133071ybn.23
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 10:23:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W+TaHnw1m4QF3+gFNvlmfVjI3Eug4gclNUnkDmbww1M=;
        b=E2891o2KOi6VKH5pgkbJOQqom5kHeO2dUKV/6tYk1sNN0tNh/SoheUGlukrJHXPDbg
         7uKjBq+FCgXPqDixlcAgkx9bsgM2V39cpwRH9nkWM49I0ftt9tK/5wRo/kVMOKQTIGzW
         eZz9gsHSBoBl2GFhL1y1ZVJBL5oMhSQ0sf6mO46iTk5RIF9l3fzKRw0PlaRrJYHztNCq
         cRiP2fQg/pweDKZefpHDvqAtBBz9lUnS8qpxTFSoE5uOQr603tYCB1UYATjYf7F2p4g8
         Vp3DK+ObBYQtBiucR8ZrpIKAHEaXfBoWffTpeEhiUKnvEa+1/oKbuRvlzSAuS+xlNopC
         Ejbw==
X-Gm-Message-State: AOAM530VCry3uwM2PGq0n7mrckrHClgQBptCjkzc1u1JtbC8X0+4YK6I
        D+xUvGnG7AtZg9mh3TX25r0nNvHwtc1vWGnO2u1GAGcjLh1WXDZ00EdyTBeKw9L3UC3+Es1USop
        z4RRyjdIooKuboWY8HG03QCOnZl8aysmT
X-Received: by 2002:a25:27c1:: with SMTP id n184mr179850ybn.496.1630689792899;
        Fri, 03 Sep 2021 10:23:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznjCtfZQz2JDWJu9YExK6+0HVbzx0EdaRPmcnXCz9PzzDz4Yb+Lh5OYwO+8PDvyyVgD4ABTsgvFHw+Orr9g9g=
X-Received: by 2002:a25:27c1:: with SMTP id n184mr179819ybn.496.1630689792637;
 Fri, 03 Sep 2021 10:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629473233.git.lorenzo@kernel.org> <b1f0cbc19e00e4a4dbb7dd5d82e0c8bad300cffc.1629473233.git.lorenzo@kernel.org>
 <612eba0cd2678_6b872081d@john-XPS-13-9370.notmuch>
In-Reply-To: <612eba0cd2678_6b872081d@john-XPS-13-9370.notmuch>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 3 Sep 2021 19:23:01 +0200
Message-ID: <CAJ0CqmU6cFP3WrvqVqbVKt8R-yrKTKp2ZHm65O-w5fjEJVvemA@mail.gmail.com>
Subject: Re: [PATCH v12 bpf-next 03/18] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        Toke Hoiland Jorgensen <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 1:24 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Lorenzo Bianconi wrote:
> > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> > XDP remote drivers if this is a "non-linear" XDP buffer. Access
> > skb_shared_info only if xdp_buff mb is set in order to avoid possible
> > cache-misses.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 23 ++++++++++++++++++-----
> >  1 file changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 5d1007e1b5c9..9f4858e35566 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2037,9 +2037,14 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
> >  {
> >       int i;
> >
> > +     if (likely(!xdp_buff_is_mb(xdp)))
> > +             goto out;
> > +
>
> Wouldn't nr_frags = 0 in the !xdp_buff_is_mb case? Is the
> xdp_buff_is_mb check with goto really required?

if xdp_buff_is_mb is false, nr_frags will not be initialized otherwise
we will trigger a cache-miss for the single-buffer use case (where
initializing skb_shared_info is not required).

>
> >       for (i = 0; i < sinfo->nr_frags; i++)
> >               page_pool_put_full_page(rxq->page_pool,
> >                                       skb_frag_page(&sinfo->frags[i]), true);
> > +
> > +out:
> >       page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
> >                          sync_len, true);
> >  }
> > @@ -2241,7 +2246,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >       int data_len = -MVNETA_MH_SIZE, len;
> >       struct net_device *dev = pp->dev;
> >       enum dma_data_direction dma_dir;
> > -     struct skb_shared_info *sinfo;
> >
> >       if (*size > MVNETA_MAX_RX_BUF_SIZE) {
> >               len = MVNETA_MAX_RX_BUF_SIZE;
> > @@ -2261,11 +2265,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
> >
> >       /* Prefetch header */
> >       prefetch(data);
> > +     xdp_buff_clear_mb(xdp);
> >       xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
> >                        data_len, false);
> > -
> > -     sinfo = xdp_get_shared_info_from_buff(xdp);
> > -     sinfo->nr_frags = 0;
> >  }
> >
> >  static void
> > @@ -2299,6 +2301,9 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
> >               skb_frag_off_set(frag, pp->rx_offset_correction);
> >               skb_frag_size_set(frag, data_len);
> >               __skb_frag_set_page(frag, page);
> > +
> > +             if (!xdp_buff_is_mb(xdp))
> > +                     xdp_buff_set_mb(xdp);
> >       } else {
> >               page_pool_put_full_page(rxq->page_pool, page, true);
> >       }
> > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >                     struct xdp_buff *xdp, u32 desc_status)
> >  {
> >       struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> > -     int i, num_frags = sinfo->nr_frags;
> >       struct sk_buff *skb;
> > +     u8 num_frags;
> > +     int i;
> > +
> > +     if (unlikely(xdp_buff_is_mb(xdp)))
> > +             num_frags = sinfo->nr_frags;
> >
> >       skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
> >       if (!skb)
> > @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >       skb_put(skb, xdp->data_end - xdp->data);
> >       skb->ip_summed = mvneta_rx_csum(pp, desc_status);
> >
> > +     if (likely(!xdp_buff_is_mb(xdp)))
> > +             goto out;
> > +
>
> Not that I care much, but couldn't you just init num_frags = 0 and
> avoid the goto?

same here.

Regards,
Lorenzo

>
> Anyways its not my driver so no need to change it if you like it better
> the way it is. Mostly just checking my understanding.
>
> >       for (i = 0; i < num_frags; i++) {
> >               skb_frag_t *frag = &sinfo->frags[i];
> >
> > @@ -2341,6 +2353,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >                               skb_frag_size(frag), PAGE_SIZE);
> >       }
> >
> > +out:
> >       return skb;
> >  }
> >
> > --
> > 2.31.1
> >
>
>

