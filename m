Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BD4414393
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhIVIUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhIVIUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:20:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051BEC061574;
        Wed, 22 Sep 2021 01:19:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so3414332pjb.1;
        Wed, 22 Sep 2021 01:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xAwC1Eak7pn1LyQq8FKE4mBzrx5YjXSoqADdyy/8Mmg=;
        b=CsFaiv3sTHoFKIA0SK73zuufW6xkI1kdopHwmJYmV1zMsBU8yD6tEg2iFuPPAwETeG
         qIfJcozVBF8Ec7dVCFV3jIJMUoZJeuToRoDM8rCRpXl5Nl0pj4DSt1S15hy2iSDQ2lUf
         YVF4OlO7WVq3Q/O1jnqN/r/DwZEwdjz60dyvEqEi0XdWzhUbP/P2wasZAhiy8QdpTYj3
         ThUewf+gv6fN1gEJhQ740beapVzvVHPPrqW2KsZt/GbgtPmsHMETXyrByNTbjXC9vJ06
         9+9+k3pCg8W6Hgd/ZkMWWFriiEHp/4CjfYtuNotpJ4vl4BoW0TBYCzYy74PqSxOznMrI
         fLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xAwC1Eak7pn1LyQq8FKE4mBzrx5YjXSoqADdyy/8Mmg=;
        b=pi/zuhux8HVnDq5hSkCYrptCaLj/EmAYsayx9DNt81oOkKOfHgB/oFH/39Hd/uFUol
         i7hzbRGAGAYQe53nkkhFHHDmSmDSntqwgsXHOCb4qndpAQhbgkjaAbiDW4eGOOPfznVx
         ParIwP+b6d5mIn0Nr/XHdCCD5kTluMWNPCeY/VBjACed3AcGNu5woK5o8cbPC7p2qgBr
         GxmxYT7t0HYq9V2fJRf2bv6i1WgFfQV31P6zuAUW4M4TS4OaRJMVLAlvqko1+qb7MG9a
         I+xjLPcIopWc83AoYew1fw91vhPFOvGwlH19rfnEfV+M+Kd8WxfPB9HG/f0JW/uqedHV
         FetQ==
X-Gm-Message-State: AOAM530xphRyAgiPbSQvIpK0ulrMz2mCTXtcFtOlvNKgqqbkYjpLWp7a
        ov8F+WmGq9bBsbzIb5QlkNA=
X-Google-Smtp-Source: ABdhPJwcv8awihDvADpCUhslzTOMMwVSSHWAi9JfX0NjLYWHu3RH6Ls13bobN0ncLqe5fxg+dOYeQA==
X-Received: by 2002:a17:90a:8009:: with SMTP id b9mr9668511pjn.15.1632298751543;
        Wed, 22 Sep 2021 01:19:11 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id s22sm1563555pfe.76.2021.09.22.01.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 01:19:11 -0700 (PDT)
Date:   Wed, 22 Sep 2021 08:19:06 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
Message-ID: <20210922081906.GA78305@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
 <ebea2af2-90d0-248f-8461-80f2e834dfea@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebea2af2-90d0-248f-8461-80f2e834dfea@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 09:37:40AM -0600, Jens Axboe wrote:
> > @@ -424,6 +431,57 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
> >  }
> >  EXPORT_SYMBOL(kmem_cache_create);
> >  
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
> > +	if (cache->size)
> > +		return cache->queue[--cache->size];
> > +	else
> > +		return NULL;
> > +}
> > +EXPORT_SYMBOL(kmem_cache_alloc_cached);

Hello Jens, I'm so happy that you gave comment.

> What I implemented for IOPOLL doesn't need to care about interrupts,
> hence preemption disable is enough. But we do need that, at least.

To be honest, that was my mistake. I was mistakenly using percpu API.
it's a shame :> Thank you for pointing that.

Fixed it in v3 (work in progress now)

> There are basically two types of use cases for this:
> 
> 1) Freeing can happen from interrupts
> 2) Freeing cannot happen from interrupts
>

I considered only case 2) when writing code. Well, To support 1),
I think there are two ways:

 a) internally call kmem_cache_free when in_interrupt() is true
 b) caller must disable interrupt when freeing

I think a) is okay, how do you think?

note that b) can be problematic with kmem_cache_free_bulk
as it says interrupts must be enabled.

> How does this work for preempt? You seem to assume that the function is
> invoked with preempt disabled, but then it could only be used with
> GFP_ATOMIC.

I wrote it just same prototype with kmem_cache_alloc, and the gfpflags
parameter is unnecessary as you said. Okay, let's remove it in v3.

> And if you don't care about users that free from irq/softirq, then that
> should be mentioned. Locking context should be mentioned, too. The above
> may be just fine IFF both alloc and free are protected by a lock higher
> up. If not, both need preemption disabled and GFP_ATOMIC. I'd suggest
> making the get/put cpu part of the API internally.

Actually I didn't put much effort in documentation. (Especially
on what context is expected before calling them)

comments will be updated in v3, with your comment in mind.

> > +/**
> > + * kmem_cache_free_cached - return object to cache
> > + * @s: slab cache
> > + * @p: pointer to free
> > + */
> > +void kmem_cache_free_cached(struct kmem_cache *s, void *p)
> > +{
> > +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> > +
> > +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
> 
> Don't use BUG_ON, just do:
> 
> 	if (WARN_ON_ONCE(!(s->flags & SLAB_LOCKLESS_CACHE))) {
> 		kmem_cache_free(s, p);
> 		return;
> 	}
>

Ok. I agree WARN is better than BUG.

Thanks,
Hyeonggon Yoo

> -- 
> Jens Axboe
> 
