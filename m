Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E1944C1A1
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhKJM5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:57:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231162AbhKJM5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636548893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z4n9H695I56p3uFL/xN9H+OG/zilvbb6UbzgWj/opIc=;
        b=QH4jiq2SrVUlG8S4LwZ9y6IjFFzS7m9RproP5uavjpRqOy6AORCCD71A+ZPkFsLUicS9wd
        E/5/24iJHk5uPnCrEmlvtf6I+wKiUB+9FeXHDT3ngS82TR+N9ZCyD8h/3kjJCi9NtfpfhF
        6RT8KCirO9j6y7R/E0GCZRfQbACn1m0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-ymMU1VNPMb-oG2OESB-qWg-1; Wed, 10 Nov 2021 07:54:52 -0500
X-MC-Unique: ymMU1VNPMb-oG2OESB-qWg-1
Received: by mail-ed1-f70.google.com with SMTP id y12-20020a056402270c00b003e28de6e995so2226807edd.11
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 04:54:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z4n9H695I56p3uFL/xN9H+OG/zilvbb6UbzgWj/opIc=;
        b=hxTE6wpwWb3Vkamr5opTkLXvz774Yd0ws57uabKcFOsm3CulmvzVxiAVoenxkqNYsu
         GTarpEtiKsFX3MXYXv2lPMjbpZKxygeRqj9L1NeGY8Jjblv4tcJRELV7LwpUGTE/gsAA
         sz6+tt5pjk66O3VdoXEBpvImyg9WrJB6jcLOLQut6cZ9ZP/EVJOg4WEEMNE7Nc99HHFu
         I8Ve3MtsyKSMolx3r9CVR4bSqVMRO92wLRzN6p/+j8VNoBsbujKikYXYKuHUn/cZkag6
         l/GApKmqioy4/8dOU3bzOJoK944IXNkpSfww9s8K0OZ0q9QU4tAyoJzAi53LDlThEcNI
         D9aA==
X-Gm-Message-State: AOAM530y1zoPa/nal488X4xIgW/OdnvSCqFJlSf7NFS/caCShgtJ0yBT
        +2XV6GK6FyThvXppmPv6F80MlNh05fMt73WRR6yH1sFNoIo12V/41LH7yJni2mf/ZEnFofv8HG4
        1Dv9ey3OGl7LEKxLT
X-Received: by 2002:aa7:cd99:: with SMTP id x25mr21043883edv.249.1636548891080;
        Wed, 10 Nov 2021 04:54:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw50M4PLj6z/Dq+XVHSq0+qJ6iYuzTlHJFOEl/jotgYfNBocUvMNCYW+Use7QYwyxpd7H5SiQ==
X-Received: by 2002:aa7:cd99:: with SMTP id x25mr21043861edv.249.1636548890882;
        Wed, 10 Nov 2021 04:54:50 -0800 (PST)
Received: from redhat.com ([2.55.133.41])
        by smtp.gmail.com with ESMTPSA id r19sm12535963edt.54.2021.11.10.04.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 04:54:50 -0800 (PST)
Date:   Wed, 10 Nov 2021 07:54:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 0/3] virtio support cache indirect desc
Message-ID: <20211110075412-mutt-send-email-mst@kernel.org>
References: <20211108084732-mutt-send-email-mst@kernel.org>
 <1636382860.765897-1-xuanzhuo@linux.alibaba.com>
 <20211110074326-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110074326-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 07:53:49AM -0500, Michael S. Tsirkin wrote:
> On Mon, Nov 08, 2021 at 10:47:40PM +0800, Xuan Zhuo wrote:
> > On Mon, 8 Nov 2021 08:49:27 -0500, Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > Hmm a bunch of comments got ignored. See e.g.
> > > https://lore.kernel.org/r/20211027043851-mutt-send-email-mst%40kernel.org
> > > if they aren't relevant add code comments or commit log text explaining the
> > > design choice please.
> > 
> > I should have responded to related questions, I am guessing whether some emails
> > have been lost.
> > 
> > I have sorted out the following 6 questions, if there are any missing questions,
> > please let me know.
> > 
> > 1. use list_head
> >   In the earliest version, I used pointers directly. You suggest that I use
> >   llist_head, but considering that llist_head has atomic operations. There is no
> >   competition problem here, so I used list_head.
> > 
> >   In fact, I did not increase the allocated space for list_head.
> > 
> >   use as desc array: | vring_desc | vring_desc | vring_desc | vring_desc |
> >   use as queue item: | list_head ........................................|
> 
> the concern is that you touch many cache lines when removing an entry.
> 
> I suggest something like:
> 
> llist: add a non-atomic list_del_first
> 
> One has to know what one's doing, but if one has locked the list
> preventing all accesses, then it's ok to just pop off an entry without
> atomics.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ---
> 
> diff --git a/include/linux/llist.h b/include/linux/llist.h
> index 24f207b0190b..13a47dddb12b 100644
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -247,6 +247,17 @@ static inline struct llist_node *__llist_del_all(struct llist_head *head)
>  
>  extern struct llist_node *llist_del_first(struct llist_head *head);
>  
> +static inline struct llist_node *__llist_del_first(struct llist_head *head)
> +{
> +	struct llist_node *first = head->first;
> +
> +	if (!first)
> +		return NULL;
> +
> +	head->first = first->next;
> +	return first;
> +}
> +
>  struct llist_node *llist_reverse_order(struct llist_node *head);
>  
>  #endif /* LLIST_H */
> 
> 
> -----
> 
> 
> > 2.
> > > > +	if (vq->use_desc_cache && total_sg <= VIRT_QUEUE_CACHE_DESC_NUM) {
> > > > +		if (vq->desc_cache_chain) {
> > > > +			desc = vq->desc_cache_chain;
> > > > +			vq->desc_cache_chain = (void *)desc->addr;
> > > > +			goto got;
> > > > +		}
> > > > +		n = VIRT_QUEUE_CACHE_DESC_NUM;
> > >
> > > Hmm. This will allocate more entries than actually used. Why do it?
> > 
> > 
> > This is because the size of each cache item is fixed, and the logic has been
> > modified in the latest code. I think this problem no longer exists.
> > 
> > 
> > 3.
> > > What bothers me here is what happens if cache gets
> > > filled on one numa node, then used on another?
> > 
> > I'm thinking about another question, how did the cross-numa appear here, and
> > virtio desc queue also has the problem of cross-numa. So is it necessary for us
> > to deal with the cross-numa scene?
> 
> It's true that desc queue might be cross numa, and people are looking
> for ways to improve that. Not a reason to make things worse ...
> 

To add to that, given it's a concern, how about actually
testing performance for this config?

> > Indirect desc is used as virtio desc, so as long as it is in the same numa as
> > virito desc. So we can allocate indirect desc cache at the same time when
> > allocating virtio desc queue.
> 
> Using it from current node like we do now seems better.
> 
> > 4.
> > > So e.g. for rx, we are wasting memory since indirect isn't used.
> > 
> > In the current version, desc cache is set up based on pre-queue.
> > 
> > So if the desc cache is not used, we don't need to set the desc cache.
> > 
> > For example, virtio-net, as long as the tx queue and the rx queue in big packet
> > mode enable desc cache.
> 
> 
> I liked how in older versions adding indrect enabled it implicitly
> though without need to hack drivers.
> 
> > 5.
> > > Would a better API be a cache size in bytes? This controls how much
> > > memory is spent after all.
> > 
> > My design is to set a threshold. When total_sg is greater than this threshold,
> > it will fall back to kmalloc/kfree. When total_sg is less than or equal to
> > this threshold, use the allocated cache.
> > 
> 
> I know. My question is this, do devices know what a good threshold is?
> If yes how do they know?
> 
> > 6. kmem_cache_*
> > 
> > I have tested these, the performance is not as good as the method used in this
> > patch.
> 
> Do you mean kmem_cache_alloc_bulk/kmem_cache_free_bulk?
> You mentioned just kmem_cache_alloc previously.
> 
> > 
> > Thanks.

