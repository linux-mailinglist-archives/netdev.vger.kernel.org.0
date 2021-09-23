Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00723415622
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbhIWDgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhIWDgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 23:36:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89B7C061574;
        Wed, 22 Sep 2021 20:35:00 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 81so1408379pgb.0;
        Wed, 22 Sep 2021 20:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6wtxktN7r3qAuP3tkW7gYR/0jxmE+kG3y02qg3DUj3o=;
        b=GDg2liZ+x3QXQwKe1n+6qfegRPtL672Cw4qCp/lEEFcDwyFeVs6PIOAbdVXoajgCv7
         9jEsh89LCQcBqEeEWAjraS6DOHFVOq80yCe3i7duJOer7QBROfTkB9ugR2cLcOlWk72s
         kuglnmRID2sFxtOWrAUfeeHoymH2xzo6A5rXM7gCjxtgUKekmik4Sfx0aidLl/YS/FE3
         opdB8evHBLOLvVtDw4BfAMB0Zxba8DEl3XoiFGkdD/1v6CBsX3EwS85yrDFcVbDtr/SC
         1egxEU/c475ZoSiWeUrGrko7593ixXQhu38iTbQQMj/laCWx5J31xXtlG9HuhhzjvgW8
         tPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6wtxktN7r3qAuP3tkW7gYR/0jxmE+kG3y02qg3DUj3o=;
        b=7Qr12XfkGgnZKxa7aQIu+hcS/HgTHl6uPaiIU5QwZgwm/bZ9cT+dyMDLVwaA+ajpkg
         G/6Ayi4jCv/ucgDF5kk4qTNVqp99Ae7Mwkg8tbJ0Ud7dg8YiORCK6Ll8KB2ImGkTK446
         x0cZH3w2lzAm7QAgFzztNZU7PLMfUW05NM1+OS7sGZ1BpgxQtV8fbYs+Ulx3z3pftILH
         CgttJrFeQRm1P1f0VA9n0PZriKm8uDFcEjFIuwJoSdPz2uiufrAztF845C4KaopCfx8X
         5S/E/q6F76r4A3HYVqj5PdjQglpfb3Pa7+uQk8EmB/aDS9NskqixHwwy9pXnO7mgmzl3
         TCSg==
X-Gm-Message-State: AOAM530Ltgd2ZZtU57rtcozxV9I5MH+ludeDtLfYUQJflh2gwePKn4RH
        quFZrD1981a3JkQ0lXCSrLM=
X-Google-Smtp-Source: ABdhPJwhwpWmtfW0kFrjMmxVNOe5WUC/aA4ifx5mX/4aqbRqjHUCPq6NOE1BuU+VaFXpRiNDdmrcng==
X-Received: by 2002:a63:79c7:: with SMTP id u190mr2213717pgc.378.1632368100268;
        Wed, 22 Sep 2021 20:35:00 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id q1sm3591221pfu.4.2021.09.22.20.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 20:34:59 -0700 (PDT)
Date:   Thu, 23 Sep 2021 03:34:54 +0000
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
Message-ID: <20210923033454.GA3145@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
 <ebea2af2-90d0-248f-8461-80f2e834dfea@kernel.dk>
 <20210922081906.GA78305@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
 <688e6750-87e9-fb44-ce40-943bad072e48@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688e6750-87e9-fb44-ce40-943bad072e48@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 06:58:00AM -0600, Jens Axboe wrote:
> On 9/22/21 2:19 AM, Hyeonggon Yoo wrote:
> > On Tue, Sep 21, 2021 at 09:37:40AM -0600, Jens Axboe wrote:
> >>> @@ -424,6 +431,57 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
> >>>  }
> >>>  EXPORT_SYMBOL(kmem_cache_create);
> >>>  
> >>> +/**
> >>> + * kmem_cache_alloc_cached - try to allocate from cache without lock
> >>> + * @s: slab cache
> >>> + * @flags: SLAB flags
> >>> + *
> >>> + * Try to allocate from cache without lock. If fails, fill the lockless cache
> >>> + * using bulk alloc API
> >>> + *
> >>> + * Be sure that there's no race condition.
> >>> + * Must create slab cache with SLAB_LOCKLESS_CACHE flag to use this function.
> >>> + *
> >>> + * Return: a pointer to free object on allocation success, NULL on failure.
> >>> + */
> >>> +void *kmem_cache_alloc_cached(struct kmem_cache *s, gfp_t gfpflags)
> >>> +{
> >>> +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> >>> +
> >>> +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
> >>> +
> >>> +	if (cache->size) /* fastpath without lock */
> >>> +		return cache->queue[--cache->size];
> >>> +
> >>> +	/* slowpath */
> >>> +	cache->size = kmem_cache_alloc_bulk(s, gfpflags,
> >>> +			KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);
> >>> +	if (cache->size)
> >>> +		return cache->queue[--cache->size];
> >>> +	else
> >>> +		return NULL;
> >>> +}
> >>> +EXPORT_SYMBOL(kmem_cache_alloc_cached);
> > 
> > Hello Jens, I'm so happy that you gave comment.
> > 
> >> What I implemented for IOPOLL doesn't need to care about interrupts,
> >> hence preemption disable is enough. But we do need that, at least.
> > 
> > To be honest, that was my mistake. I was mistakenly using percpu API.
> > it's a shame :> Thank you for pointing that.
> > 
> > Fixed it in v3 (work in progress now)

Hello Jens, thank you so much for reviewing this. Your thoughtful review helps
a lot And I feel we're going into right direction.

Anyway, let's start discussion again.

> 
> Another thing to fix from there, just make it:
> 
> if (cache->size)
> 	return cached item
> return NULL;
> 
> No need for an if/else with the return.

That looks better. I'll consider that in next version.

> >> How does this work for preempt? You seem to assume that the function is
> >> invoked with preempt disabled, but then it could only be used with
> >> GFP_ATOMIC.
> > 
> > I wrote it just same prototype with kmem_cache_alloc, and the gfpflags
> > parameter is unnecessary as you said. Okay, let's remove it in v3.
> 
> Please also run some actual comparitative benchmarks on this, with a
> real workload. You also need an internal user of this, a stand-alone
> feature isn't really useful. It needs someone using it, and the
> benchmarks would be based on that (or those) use cases.
>

Yeah, That's important point too. as my project affects performance,
I should measure the impact. And as you said, to measure impact, I should
find use cases. For test, I made NAPI (network layer IO Polling) to use
this. it may help measuring.

So, Okay. I'll show its impact on performance, as work progresses.

> Another consideration - is it going to be OK to ignore slab pruning for
> this? Probably. But it needs to be thought about.
>

I think I should consider slab pruning too. That's one of benefits of
using slab allocator. I'll add this in TODOs.

> In terms of API, not sure why these are separate functions. Creating the
> cache with SLAB_FOO should be enough, and then kmem_cache_alloc() tries
> the cache first. If nothing there, fallback to the regular path.
> Something like this would only be used for cases that have a high
> alloc+free rate, would seem like a shame to need two function calls for
> the case where you just want a piece of memory and the cache is empty.
> 

It would be wonderful if we can do that. And I'm working on this.
I'm testing this in my private repository and looking at what happens.
it seems there's some issues to solve.

> >> There are basically two types of use cases for this:
> >>
> >> 1) Freeing can happen from interrupts
> >> 2) Freeing cannot happen from interrupts
> >>
> > 
> > I considered only case 2) when writing code. Well, To support 1),
> > I think there are two ways:
> > 
> >  a) internally call kmem_cache_free when in_interrupt() is true
> >  b) caller must disable interrupt when freeing
> > 
> > I think a) is okay, how do you think?
> 
> If the API doesn't support freeing from interrupts, then I'd make that
> the rule. Caller should know better if that can happen, and then just
> use kmem_cache_free() if in a problematic context. That avoids polluting
> the fast path with that check. I'd still make it a WARN_ON_ONCE() as
> described and it can get removed later, hopefully.

Hmm.. As you mentioned above, to provide unified API, we should check
its context in kmem_cache_alloc anyway. But yes, it is better not to allow
calling from interrupt kmem_cache_{alloc,free}_cached.

> But note it's not just the freeing side that would be problematic. If
> you do support from-irq freeing, then the alloc side would need
> local_irq_save/restore() instead of just basic preempt protection. That
> would make it more expensive all around

I think so too. One reason of this work is to reduce cost of disabling
interrupts. That's costly.

> > note that b) can be problematic with kmem_cache_free_bulk
> > as it says interrupts must be enabled.
> 
> Not sure that's actually true, apart from being bitrot.

I don't get what you mean.
Can you tell me in detail?

(Yeah, maybe I'm misunderstanding kmem_cache_{alloc,free}_bulk.)

Thanks,
Hyeonggon Yoo

> -- 
> Jens Axboe
> 
