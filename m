Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F743413667
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhIUPoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhIUPoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 11:44:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DCAC061574;
        Tue, 21 Sep 2021 08:42:45 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t4so13691310plo.0;
        Tue, 21 Sep 2021 08:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RD5aX+bq0mWaigsgwff4LifiFIskfGBYOuz23IRmF4A=;
        b=gQysE9fy9UdDCPFaMP9zJNGweHy7ylFyDDUJqj0hCp6Syl8h4CQSjjBIJ5X2PhUdnL
         bOJLbvXVF1dZZScDOJKeXVDV4okYScgUR4FjIDhVbjMqZ+O5RG2MyTEjwHjpkNfLLHfM
         aJAIWyWct1v/cLXuCv0Qzbzy0jZzPO6SVWANWrDXS29VPpKgm+M5ueXm/OaKypKWo5nC
         FgLjm2nHB7V9voFQuIyN/A0/6wfxrnlgDRESguvuXgG0bOfgXnEAotuz3ma+9fBgm5z0
         shrcwHRe3VeWIRCYwhXKi+vJlgD4HxrXdAoNQNznain0ZjBHHU0p1J6EUyETbz4oZozs
         KOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RD5aX+bq0mWaigsgwff4LifiFIskfGBYOuz23IRmF4A=;
        b=h9DPQ6DfcOimwCsZM2xr6/tbUGn5zQacqekHvv4H0vhkz+HnF6LGO5XnpNzXthc89e
         E28k7n7XgqnUuVxEkiEcEcC5H09l9dTfENWzrprhATDq1L49TqwIg1eVdHTne4oQqIgB
         Qn0vA6fUcNJL7aNPB2BJK5fLj9nwoZDtotZvwGMLi4mEIA5DVvCIu765MP8pScFn5z+0
         Z33hOP+1pIv63SPm4HbCKYa7O2PqF/0mEVC9keKRiMlJucafe0a/XxvZa1I0NbhkZ4t5
         2qG3tG0eHmVKidp9pq5Sc35Ehtfq6VvbYANcB7NxJXCG28dSfKtnaqjlJZLM+1XwGXcr
         ZVsQ==
X-Gm-Message-State: AOAM5321WyZJCXWVT19RQQ8BpY8zJ0JOkn2zo2hgVqzxuv0d85EqhI6u
        7uDVxFgddi9nD4nwaDYMZ+g=
X-Google-Smtp-Source: ABdhPJx/Zmb6zD2WZ4KC4j4SUn/d8h/e2zioznqSPJAtibgwO8DI4PddxHOSmQdfF8LHqBQbnbl9MQ==
X-Received: by 2002:a17:903:102:b0:13a:66a8:f28 with SMTP id y2-20020a170903010200b0013a66a80f28mr28067530plc.62.1632238964906;
        Tue, 21 Sep 2021 08:42:44 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id y6sm17819188pfb.64.2021.09.21.08.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 08:42:44 -0700 (PDT)
Date:   Tue, 21 Sep 2021 15:42:39 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
Message-ID: <20210921154239.GA5092@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
 <YUkErK1vVZMht4s8@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUkErK1vVZMht4s8@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:01:16PM +0100, Matthew Wilcox wrote:
> On Mon, Sep 20, 2021 at 03:48:16PM +0000, Hyeonggon Yoo wrote:
> > +#define KMEM_LOCKLESS_CACHE_QUEUE_SIZE 64
> 
> I would suggest that, to be nice to the percpu allocator, this be
> one less than 2^n.

I think first we need to discuss if KMEM_LOCKLESS_CACHE_QUEUE_SIZE will be
okay with constant, or per kmem_cache size, or global boot parameter.

But even before that, we need to discuss how to manage magazine.
because that affect on what KMEM_LOCKLESS_CACHE_QUEUE_SIZE will be.

> > +struct kmem_lockless_cache {
> > +	void *queue[KMEM_LOCKLESS_CACHE_QUEUE_SIZE];
> > +	unsigned int size;
> > +};
> 
> I would also suggest that 'size' be first as it is going to be accessed
> every time, and then there's a reasonable chance that queue[size - 1] will
> be in the same cacheline.  CPUs will tend to handle that better.

That looks good to me, as you said there's chance that 'size' and some of
queue's elements (hopefully queue[size - 1]) are in same cacheline.

Plus, in v2 I didn't consider cache line when determining position of
kmem_lockless_cache in kmem_cache, I think we need to reconsider this
too.

> > +/**
> > + * kmem_cache_alloc_cached - try to allocate from cache without lock
> > + * @s: slab cache
> > + * @flags: SLAB flags
> > + *
> > + * Try to allocate from cache without lock. If fails, fill the lockless cache
> > + * using bulk alloc API
> > + *
> > + * Be sure that there's no race condition.
> > + * Must create slab cache with SLAB_LOCKLESS_CACHE flag to use this function.
> > + *
> > + * Return: a pointer to free object on allocation success, NULL on failure.
> > + */
> > +void *kmem_cache_alloc_cached(struct kmem_cache *s, gfp_t gfpflags)
> > +{
> > +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> > +
> > +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
> > +
> > +	if (cache->size) /* fastpath without lock */
> > +		return cache->queue[--cache->size];
> > +
> > +	/* slowpath */
> > +	cache->size = kmem_cache_alloc_bulk(s, gfpflags,
> > +			KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);
> 
> Go back to the Bonwick paper and look at the magazine section again.
> You have to allocate _half_ the size of the queue, otherwise you get
> into pathological situations where you start to free and allocate
> every time.

I want to ask you where idea of allocating 'half' the size of queue came from.
the paper you sent does not work with single queue(magazine). Instead,
it manages pool of magazines.

And after reading the paper, I see managing pool of magazine (where M is
an boot parameter) is valid approach to reduce hitting slowpath.

Thanks,
Hyeonggon Yoo

> > +void kmem_cache_free_cached(struct kmem_cache *s, void *p)
> > +{
> > +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> > +
> > +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
> > +
> > +	/* Is there better way to do this? */
> > +	if (cache->size == KMEM_LOCKLESS_CACHE_QUEUE_SIZE)
> > +		kmem_cache_free(s, cache->queue[--cache->size]);
> 
> Yes.
> 
> 	if (cache->size == KMEM_LOCKLESS_CACHE_QUEUE_SIZE) {
> 		kmem_cache_free_bulk(s, KMEM_LOCKLESS_CACHE_QUEUE_SIZE / 2,
> 			&cache->queue[KMEM_LOCKLESS_CACHE_QUEUE_SIZE / 2));
> 		cache->size = KMEM_LOCKLESS_CACHE_QUEUE_SIZE / 2;
> 
> (check the maths on that; it might have some off-by-one)
 
