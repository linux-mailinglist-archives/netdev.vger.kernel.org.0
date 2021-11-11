Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB34E44D8D0
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhKKPE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:04:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhKKPE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:04:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636642928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P8p6CBi9GhyAybomTT9aK06QsN9Co1Vcux5yo3BY17U=;
        b=Vd4D7ixV4VnQp0mfMs42IP2u4fRBILUvFJAThN09VqH7ne5Rh+u4vQXXG3v2ZmfC+EE4k0
        tYcBgECeK6ooo5/SBp+EYhyZYwASTA0/Tv0LS0iU9P/3hJrSiGiCfrrwXbKPTpPYru53XU
        4DkHJPOilxmWxVp5PGciknNrdKzEwcI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-gaieqDz-OgW6yAFgniXeSw-1; Thu, 11 Nov 2021 10:02:06 -0500
X-MC-Unique: gaieqDz-OgW6yAFgniXeSw-1
Received: by mail-wm1-f71.google.com with SMTP id g81-20020a1c9d54000000b003330e488323so1782919wme.0
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 07:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P8p6CBi9GhyAybomTT9aK06QsN9Co1Vcux5yo3BY17U=;
        b=BEuTwCJoM6OJ3W7ycsJ2EV8raP4qXKucbWiHvpB5qJS8j8hifoRdqzyu8Y8rR2PWij
         rxQbbF473xMGI0NDo45B0xfDYAZhxjUQqq9Dz3J9CcjCpYZsHxF51anCR1d0YT46rwPw
         lg3dtNsuY87gmOHn/rXXI0gc5GPHuIqUhRGvPqrfm/TtEe8zvRe/ch0e3iIzcl/Tka0r
         o7Ngy6lsQN+XMnAN0I13bO1+Mt81EqAMQfN2zJcn9ymjccc10ufwIUziDdPe6IHYRaDV
         siJkk0bNOmWr+IOvXeezJ6NqlEIoco8QY/ti9sZ6e/PVFBwGvKPwzqwgaAetKNYzeKIh
         fBMw==
X-Gm-Message-State: AOAM531KMb6K+vfjGUgsUrlWfjvDstT38h4sCbAkm33/Z2RAGv58BM5s
        HxtStkV5dG2DFkbLkSBVAZTLYKLEvT8BU2TDHd14FNC/Ff7YGFFR7Wd67IaONyi5sNdBkjPl1ew
        h2lcAG4VC/X0GxdTF
X-Received: by 2002:a05:600c:1d28:: with SMTP id l40mr9002724wms.192.1636642925475;
        Thu, 11 Nov 2021 07:02:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkrb/NNFzG3uc3s+Qn7RLDKcEGHeP1u7uOqyhEqqTl55Guko20m8LN6N3y0i9Lb0+EXDrBAA==
X-Received: by 2002:a05:600c:1d28:: with SMTP id l40mr9002687wms.192.1636642925242;
        Thu, 11 Nov 2021 07:02:05 -0800 (PST)
Received: from redhat.com ([2.55.135.246])
        by smtp.gmail.com with ESMTPSA id h1sm3116622wmb.7.2021.11.11.07.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:02:04 -0800 (PST)
Date:   Thu, 11 Nov 2021 10:02:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 0/3] virtio support cache indirect desc
Message-ID: <20211111100044-mutt-send-email-mst@kernel.org>
References: <20211110074326-mutt-send-email-mst@kernel.org>
 <1636613527.8447719-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636613527.8447719-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 02:52:07PM +0800, Xuan Zhuo wrote:
> On Wed, 10 Nov 2021 07:53:44 -0500, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Nov 08, 2021 at 10:47:40PM +0800, Xuan Zhuo wrote:
> > > On Mon, 8 Nov 2021 08:49:27 -0500, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > Hmm a bunch of comments got ignored. See e.g.
> > > > https://lore.kernel.org/r/20211027043851-mutt-send-email-mst%40kernel.org
> > > > if they aren't relevant add code comments or commit log text explaining the
> > > > design choice please.
> > >
> > > I should have responded to related questions, I am guessing whether some emails
> > > have been lost.
> > >
> > > I have sorted out the following 6 questions, if there are any missing questions,
> > > please let me know.
> > >
> > > 1. use list_head
> > >   In the earliest version, I used pointers directly. You suggest that I use
> > >   llist_head, but considering that llist_head has atomic operations. There is no
> > >   competition problem here, so I used list_head.
> > >
> > >   In fact, I did not increase the allocated space for list_head.
> > >
> > >   use as desc array: | vring_desc | vring_desc | vring_desc | vring_desc |
> > >   use as queue item: | list_head ........................................|
> >
> > the concern is that you touch many cache lines when removing an entry.
> >
> > I suggest something like:
> >
> > llist: add a non-atomic list_del_first
> >
> > One has to know what one's doing, but if one has locked the list
> > preventing all accesses, then it's ok to just pop off an entry without
> > atomics.
> >
> 
> Oh, great, but my way of solving the problem is too conservative.
> 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > ---
> >
> > diff --git a/include/linux/llist.h b/include/linux/llist.h
> > index 24f207b0190b..13a47dddb12b 100644
> > --- a/include/linux/llist.h
> > +++ b/include/linux/llist.h
> > @@ -247,6 +247,17 @@ static inline struct llist_node *__llist_del_all(struct llist_head *head)
> >
> >  extern struct llist_node *llist_del_first(struct llist_head *head);
> >
> > +static inline struct llist_node *__llist_del_first(struct llist_head *head)
> > +{
> > +	struct llist_node *first = head->first;
> > +
> > +	if (!first)
> > +		return NULL;
> > +
> > +	head->first = first->next;
> > +	return first;
> > +}
> > +
> >  struct llist_node *llist_reverse_order(struct llist_node *head);
> >
> >  #endif /* LLIST_H */
> >
> >
> > -----
> >
> >
> > > 2.
> > > > > +	if (vq->use_desc_cache && total_sg <= VIRT_QUEUE_CACHE_DESC_NUM) {
> > > > > +		if (vq->desc_cache_chain) {
> > > > > +			desc = vq->desc_cache_chain;
> > > > > +			vq->desc_cache_chain = (void *)desc->addr;
> > > > > +			goto got;
> > > > > +		}
> > > > > +		n = VIRT_QUEUE_CACHE_DESC_NUM;
> > > >
> > > > Hmm. This will allocate more entries than actually used. Why do it?
> > >
> > >
> > > This is because the size of each cache item is fixed, and the logic has been
> > > modified in the latest code. I think this problem no longer exists.
> > >
> > >
> > > 3.
> > > > What bothers me here is what happens if cache gets
> > > > filled on one numa node, then used on another?
> > >
> > > I'm thinking about another question, how did the cross-numa appear here, and
> > > virtio desc queue also has the problem of cross-numa. So is it necessary for us
> > > to deal with the cross-numa scene?
> >
> > It's true that desc queue might be cross numa, and people are looking
> > for ways to improve that. Not a reason to make things worse ...
> >
> 
> I will test for it.
> 
> >
> > > Indirect desc is used as virtio desc, so as long as it is in the same numa as
> > > virito desc. So we can allocate indirect desc cache at the same time when
> > > allocating virtio desc queue.
> >
> > Using it from current node like we do now seems better.
> >
> > > 4.
> > > > So e.g. for rx, we are wasting memory since indirect isn't used.
> > >
> > > In the current version, desc cache is set up based on pre-queue.
> > >
> > > So if the desc cache is not used, we don't need to set the desc cache.
> > >
> > > For example, virtio-net, as long as the tx queue and the rx queue in big packet
> > > mode enable desc cache.
> >
> >
> > I liked how in older versions adding indrect enabled it implicitly
> > though without need to hack drivers.
> 
> I see.
> 
> >
> > > 5.
> > > > Would a better API be a cache size in bytes? This controls how much
> > > > memory is spent after all.
> > >
> > > My design is to set a threshold. When total_sg is greater than this threshold,
> > > it will fall back to kmalloc/kfree. When total_sg is less than or equal to
> > > this threshold, use the allocated cache.
> > >
> >
> > I know. My question is this, do devices know what a good threshold is?
> > If yes how do they know?
> 
> I think the driver knows the threshold, for example, MAX_SKB_FRAG + 2 is a
> suitable threshold for virtio-net.
> 

I guess... in that case I assume it's a good idea to have
virtio core round the size up to whole cache lines, right?

> >
> > > 6. kmem_cache_*
> > >
> > > I have tested these, the performance is not as good as the method used in this
> > > patch.
> >
> > Do you mean kmem_cache_alloc_bulk/kmem_cache_free_bulk?
> > You mentioned just kmem_cache_alloc previously.
> 
> 
> I will test for kmem_cache_alloc_bulk.
> 
> Thanks.
> 
> >
> > >
> > > Thanks.
> >

