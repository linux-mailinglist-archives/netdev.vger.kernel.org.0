Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9C744C19E
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhKJM4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhKJM4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:56:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636548831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sn1WXrnXTZ1dYyFwngm5xjUkxmZOxlAGXW9Egen7F3c=;
        b=LqCxMd6dm9vZTeVbijK8uDnGvJmHYir637A59Rkn8B8xplY911Ttr3wJAJD6VzA9Hp2lOq
        ks1tV99wr4PbtAJGsHaYYpD+xVaQoAFjibmuaQnaXnpQTR2dwBBIhKTWpM5dOTXvIanE57
        ez3B11FUw7nxiWLvvS4BocAvLSzM6wk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-QhN3Fc4lNwOGfso602KIag-1; Wed, 10 Nov 2021 07:53:50 -0500
X-MC-Unique: QhN3Fc4lNwOGfso602KIag-1
Received: by mail-ed1-f72.google.com with SMTP id h13-20020a05640250cd00b003e35ea5357fso2257661edb.2
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 04:53:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sn1WXrnXTZ1dYyFwngm5xjUkxmZOxlAGXW9Egen7F3c=;
        b=heS4yGs0izeAvMJlU3/6WlfZlCSP3CxaWXV7jn2JcDevb0/49PNp+zcn8QeNfTyDEY
         o6if4JXjUcPLyWNaxAC8dH3mPKTNVpDOq05ziK8UCSHghqjBLPg+4d9VyqnEeiKIXFjO
         dA1xKTjBs/UY/CrNOAdtFxdcyi5PW+xp0f58piSVbw68UV4zMiyR/HwtHyBrYd+jmZ/0
         6EKGuIgp4SkSOBZNAZ0kden88LikppXd9T+cEC610DToUOr/0xPAy9uqoAfEEg+bNXXB
         8ax0IYDqmu3oTACRzrkNfYAKPTKVcjywZYkTSMMHiIyQpHK4ScKvEs1YJ0K0PhZFrlKC
         iQ/g==
X-Gm-Message-State: AOAM530RNR1ULNyhmFdWuriZUjpj8dFq5GYsgT2l7Eywbx/b5ahkOJ5v
        w1y4jEbOuVBDwIWJGvJHxd8c0ftrLj3t3pUAWXTprTYZt0EJA9VfcCQcFVNFxYRNDF8M2Yd9OCW
        a1dnR63ZVm4wvi++Y
X-Received: by 2002:a17:907:1b25:: with SMTP id mp37mr20401382ejc.140.1636548829189;
        Wed, 10 Nov 2021 04:53:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzn5NPOygFjffm/bfuj3ZHK0KZf4lB7kWR2MkWgkMO02HRnjld94PSJZzwVE7i8KU7r+5B7IA==
X-Received: by 2002:a17:907:1b25:: with SMTP id mp37mr20401345ejc.140.1636548828941;
        Wed, 10 Nov 2021 04:53:48 -0800 (PST)
Received: from redhat.com ([2.55.133.41])
        by smtp.gmail.com with ESMTPSA id ar2sm2125481ejc.20.2021.11.10.04.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 04:53:47 -0800 (PST)
Date:   Wed, 10 Nov 2021 07:53:44 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 0/3] virtio support cache indirect desc
Message-ID: <20211110074326-mutt-send-email-mst@kernel.org>
References: <20211108084732-mutt-send-email-mst@kernel.org>
 <1636382860.765897-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636382860.765897-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 10:47:40PM +0800, Xuan Zhuo wrote:
> On Mon, 8 Nov 2021 08:49:27 -0500, Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > Hmm a bunch of comments got ignored. See e.g.
> > https://lore.kernel.org/r/20211027043851-mutt-send-email-mst%40kernel.org
> > if they aren't relevant add code comments or commit log text explaining the
> > design choice please.
> 
> I should have responded to related questions, I am guessing whether some emails
> have been lost.
> 
> I have sorted out the following 6 questions, if there are any missing questions,
> please let me know.
> 
> 1. use list_head
>   In the earliest version, I used pointers directly. You suggest that I use
>   llist_head, but considering that llist_head has atomic operations. There is no
>   competition problem here, so I used list_head.
> 
>   In fact, I did not increase the allocated space for list_head.
> 
>   use as desc array: | vring_desc | vring_desc | vring_desc | vring_desc |
>   use as queue item: | list_head ........................................|

the concern is that you touch many cache lines when removing an entry.

I suggest something like:

llist: add a non-atomic list_del_first

One has to know what one's doing, but if one has locked the list
preventing all accesses, then it's ok to just pop off an entry without
atomics.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 24f207b0190b..13a47dddb12b 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -247,6 +247,17 @@ static inline struct llist_node *__llist_del_all(struct llist_head *head)
 
 extern struct llist_node *llist_del_first(struct llist_head *head);
 
+static inline struct llist_node *__llist_del_first(struct llist_head *head)
+{
+	struct llist_node *first = head->first;
+
+	if (!first)
+		return NULL;
+
+	head->first = first->next;
+	return first;
+}
+
 struct llist_node *llist_reverse_order(struct llist_node *head);
 
 #endif /* LLIST_H */


-----


> 2.
> > > +	if (vq->use_desc_cache && total_sg <= VIRT_QUEUE_CACHE_DESC_NUM) {
> > > +		if (vq->desc_cache_chain) {
> > > +			desc = vq->desc_cache_chain;
> > > +			vq->desc_cache_chain = (void *)desc->addr;
> > > +			goto got;
> > > +		}
> > > +		n = VIRT_QUEUE_CACHE_DESC_NUM;
> >
> > Hmm. This will allocate more entries than actually used. Why do it?
> 
> 
> This is because the size of each cache item is fixed, and the logic has been
> modified in the latest code. I think this problem no longer exists.
> 
> 
> 3.
> > What bothers me here is what happens if cache gets
> > filled on one numa node, then used on another?
> 
> I'm thinking about another question, how did the cross-numa appear here, and
> virtio desc queue also has the problem of cross-numa. So is it necessary for us
> to deal with the cross-numa scene?

It's true that desc queue might be cross numa, and people are looking
for ways to improve that. Not a reason to make things worse ...


> Indirect desc is used as virtio desc, so as long as it is in the same numa as
> virito desc. So we can allocate indirect desc cache at the same time when
> allocating virtio desc queue.

Using it from current node like we do now seems better.

> 4.
> > So e.g. for rx, we are wasting memory since indirect isn't used.
> 
> In the current version, desc cache is set up based on pre-queue.
> 
> So if the desc cache is not used, we don't need to set the desc cache.
> 
> For example, virtio-net, as long as the tx queue and the rx queue in big packet
> mode enable desc cache.


I liked how in older versions adding indrect enabled it implicitly
though without need to hack drivers.

> 5.
> > Would a better API be a cache size in bytes? This controls how much
> > memory is spent after all.
> 
> My design is to set a threshold. When total_sg is greater than this threshold,
> it will fall back to kmalloc/kfree. When total_sg is less than or equal to
> this threshold, use the allocated cache.
> 

I know. My question is this, do devices know what a good threshold is?
If yes how do they know?

> 6. kmem_cache_*
> 
> I have tested these, the performance is not as good as the method used in this
> patch.

Do you mean kmem_cache_alloc_bulk/kmem_cache_free_bulk?
You mentioned just kmem_cache_alloc previously.

> 
> Thanks.

