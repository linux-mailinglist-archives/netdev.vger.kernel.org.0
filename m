Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB809400418
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349819AbhICR2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:28:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235713AbhICR2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630690033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vypUNeu4j8vtRPkeg58KYPnt2rPCVH7ThBxevYKDRbg=;
        b=GWiLBFwnxVAq502Un9v4ejxx/iIQZgwA8nRWMkPN95xKcRezoHnmNcZWuvl5VO7/1Aa0iN
        J/J+6OqNNUWpfl5B5j5jyfG0qzL1NqVQ4fnxuvPpBr7zJP2im/ld8rogPSYUDSg1bTWMhK
        sNnOvzPRLqt2NK4kkgXppASWrsUhYIQ=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-m4QOnNvoNC-TzsIfJAUfRg-1; Fri, 03 Sep 2021 13:27:12 -0400
X-MC-Unique: m4QOnNvoNC-TzsIfJAUfRg-1
Received: by mail-yb1-f200.google.com with SMTP id q80-20020a25d953000000b0059a45a5f834so7186077ybg.22
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 10:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vypUNeu4j8vtRPkeg58KYPnt2rPCVH7ThBxevYKDRbg=;
        b=qg8Jowia5RlETN6MaT6ibnOKICsqpkmb6LU7pkC16C3d+DUMusumlNPJkR8fQH9Jmw
         6BAyQeLs9s8YUFvPWS7eV+x9z0wCJBehYIWgA3BN4/mTJhISODp8u/aTgWCD11q7D+4I
         d4rRjnc1jvTH98M2dlLCAz+dPz9flQce5+OhuoygCHQ0W0z24u4ufBrZK9ysqMdJBmUS
         Ea90Dx+I8LkkE3MkjqBcB/C0pV4NRJBHhhuW62Odv6sc5M9GfJ9KE0gvBoc5S9bj+dRQ
         pgqyBdr2G0JKTD47+KZWeZ1eaqKKMePs4xmwUsHYeJNt8rZooGPn/9XAczVs/GcVVxXd
         FTaQ==
X-Gm-Message-State: AOAM531tv80l7VRZf4426MgpoV1AQmbr1bahzbKRjE7zGUkT+VUNshL/
        qI+nfxiHaBdndDC06IkMI+2yPMJUnx5BBOglJk4wPUwLsCjkdmKjW7eZBVW+BEKjOdDwTYnwxV1
        qp5JWgFxz2o/xbsK7xJZLn+0c57kjid1Z
X-Received: by 2002:a25:824e:: with SMTP id d14mr176418ybn.179.1630690031473;
        Fri, 03 Sep 2021 10:27:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2p2cdv8mEYoPe6nCStjJ4fbKvrZKTSaom9r22ZjfiwIrAaPVkgTsG/G/DQhTZ3tQ0LzQswc8mEePYjJx8eiQ=
X-Received: by 2002:a25:824e:: with SMTP id d14mr176392ybn.179.1630690031232;
 Fri, 03 Sep 2021 10:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629473233.git.lorenzo@kernel.org> <4f0438cf2a94e539e56b6a291978e08fd2e9c60b.1629473233.git.lorenzo@kernel.org>
 <612ebe4548da_6b87208fa@john-XPS-13-9370.notmuch>
In-Reply-To: <612ebe4548da_6b87208fa@john-XPS-13-9370.notmuch>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 3 Sep 2021 19:27:00 +0200
Message-ID: <CAJ0CqmX3JtmZk9fKr9tH-SF4=1G8FxuoBLdFQ=3JQ1mOZAuiOg@mail.gmail.com>
Subject: Re: [PATCH v12 bpf-next 06/18] net: marvell: rely on
 xdp_update_skb_shared_info utility routine
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

>
> Lorenzo Bianconi wrote:
> > Rely on xdp_update_skb_shared_info routine in order to avoid
> > resetting frags array in skb_shared_info structure building
> > the skb in mvneta_swbm_build_skb(). Frags array is expected to
> > be initialized by the receiving driver building the xdp_buff
> > and here we just need to update memory metadata.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
> >  drivers/net/ethernet/marvell/mvneta.c | 35 +++++++++++++++------------
> >  1 file changed, 20 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index cbf614d6b993..b996eb49d813 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2304,11 +2304,19 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
> >               skb_frag_size_set(frag, data_len);
> >               __skb_frag_set_page(frag, page);
> >
> > -             if (!xdp_buff_is_mb(xdp))
> > +             if (!xdp_buff_is_mb(xdp)) {
> > +                     sinfo->xdp_frags_size = *size;
> >                       xdp_buff_set_mb(xdp);
> > +             }
> > +             if (page_is_pfmemalloc(page))
> > +                     xdp_buff_set_frag_pfmemalloc(xdp);
> >       } else {
> >               page_pool_put_full_page(rxq->page_pool, page, true);
> >       }
> > +
> > +     /* last fragment */
> > +     if (len == *size)
> > +             sinfo->xdp_frags_tsize = sinfo->nr_frags * PAGE_SIZE;
> >       *size -= len;
> >  }
> >
> > @@ -2316,13 +2324,18 @@ static struct sk_buff *
> >  mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >                     struct xdp_buff *xdp, u32 desc_status)
> >  {
> > -     struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> > +     unsigned int size, truesize;
> >       struct sk_buff *skb;
> >       u8 num_frags;
> > -     int i;
> >
> > -     if (unlikely(xdp_buff_is_mb(xdp)))
> > +     if (unlikely(xdp_buff_is_mb(xdp))) {
>
> Just curious does the mvneta hardware support header split? If we
> get to that point then we can drop the unlikely.

nope, it does not :(

Regards,
Lorenzo

>
> > +             struct skb_shared_info *sinfo;
> > +
> > +             sinfo = xdp_get_shared_info_from_buff(xdp);
> > +             truesize = sinfo->xdp_frags_tsize;
> > +             size = sinfo->xdp_frags_size;
> >               num_frags = sinfo->nr_frags;
> > +     }
> >
> >       skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
> >       if (!skb)
> > @@ -2334,18 +2347,10 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
> >       skb_put(skb, xdp->data_end - xdp->data);
> >       skb->ip_summed = mvneta_rx_csum(pp, desc_status);
> >
> > -     if (likely(!xdp_buff_is_mb(xdp)))
> > -             goto out;
> > -
> > -     for (i = 0; i < num_frags; i++) {
> > -             skb_frag_t *frag = &sinfo->frags[i];
> > -
> > -             skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> > -                             skb_frag_page(frag), skb_frag_off(frag),
> > -                             skb_frag_size(frag), PAGE_SIZE);
> > -     }
> > +     if (unlikely(xdp_buff_is_mb(xdp)))
> > +             xdp_update_skb_shared_info(skb, num_frags, size, truesize,
> > +                                        xdp_buff_is_frag_pfmemalloc(xdp));
> >
> > -out:
> >       return skb;
> >  }
> >
> > --
> > 2.31.1
> >
>
>

