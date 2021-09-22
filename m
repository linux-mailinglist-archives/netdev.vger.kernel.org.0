Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CACF4143D6
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhIVIeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhIVIeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:34:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED785C061574;
        Wed, 22 Sep 2021 01:32:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w11so1234202plz.13;
        Wed, 22 Sep 2021 01:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1vngS2lLFpX3T2rXXyf0bdb29JPkoUdlNBskWHD774k=;
        b=OxLvV2bRCQYkP9+l2Vlws5bL2v+cR5gRM7Z01D+2/5+LnXLYJK6CeI8mhHfLHPeMAS
         UIFpcdXsFiAbqRNtxbxdaW7CE7CbS+cIlyV3YrXIK8QkH7uJtWpLgytBnN5hWYVSl/i3
         TfZj5nRgu/h9EYjEj4WHb9MOYXvpq6lDudCL8FJ6hMmv9cYSX1rlNKyG9HoiWPwJmwPT
         DIevCepsGiwzpJJ4l8cJNWuW5bcfV5P6zvWOZhT/zIjBf47x6PXN0wgJ5dpNM1YhkHo3
         zTsIl6zNC+CMtW0uVrXEba5HGBjYH3zT4QfjrOzLOUig0Llzovl73gfliMeSpTVXPXdp
         RrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1vngS2lLFpX3T2rXXyf0bdb29JPkoUdlNBskWHD774k=;
        b=S4m9o1tK3fW2Za1b6AHKBw4ie+DuJsSW/gk89r240wLn+hD+SMAau0+5cDT716m1os
         PYWHJ6rHkmXXRxjsECg1abn9DnTojwrgk4gAAMm8wukV19EwxsglHJs4r/xVPngkQxTe
         zU6n60hq3Tfqbc+dOA2eb+DkvHqtivOK+FfUVZmw7eX0m9R/lbDzriBc8EtSiKu8AJ57
         XXaqak5A4u3xfi0bjiGMsXar4/xhcey1GgQOJs1XG3H6POMl1G/vB5F9z0nSa+lXmBl5
         nVsHqOIRyxMdG9oq8Pnu5OG/2krBE16SiJpgpt07yyYXFFKOwlAfh1t+hwhqxbYfycyl
         rn6w==
X-Gm-Message-State: AOAM530XsiMuNw7LTcISwzhFugAqOx64x7LP5MS/ZLm/k95gLmXCmBdp
        jzA4JrdMmzfWx/1AyIQtRMc=
X-Google-Smtp-Source: ABdhPJw/BLSytIi3rtAX6V4TCQIMXbjagraOTa5pwNL7yhu5hVmfxY8eLMphBzyOFF80+jG2ykYaRA==
X-Received: by 2002:a17:902:dcd5:b0:13d:97c6:c480 with SMTP id t21-20020a170902dcd500b0013d97c6c480mr21343565pll.70.1632299554488;
        Wed, 22 Sep 2021 01:32:34 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id k14sm1820644pgg.92.2021.09.22.01.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 01:32:34 -0700 (PDT)
Date:   Wed, 22 Sep 2021 08:32:28 +0000
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
Message-ID: <20210922083228.GA79355@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
 <YUkErK1vVZMht4s8@casper.infradead.org>
 <20210921154239.GA5092@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
 <YUoFfrQBmOdPEKpJ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUoFfrQBmOdPEKpJ@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matthew.
There's good news.

in v3 (work in progress now), I fixed some bugs (I hate kernel panics!)
And for test, made NAPI use it. it works pretty well.

On Tue, Sep 21, 2021 at 05:17:02PM +0100, Matthew Wilcox wrote:
> On Tue, Sep 21, 2021 at 03:42:39PM +0000, Hyeonggon Yoo wrote:
> > > > +	/* slowpath */
> > > > +	cache->size = kmem_cache_alloc_bulk(s, gfpflags,
> > > > +			KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);
> > > 
> > > Go back to the Bonwick paper and look at the magazine section again.
> > > You have to allocate _half_ the size of the queue, otherwise you get
> > > into pathological situations where you start to free and allocate
> > > every time.
> > 
> > I want to ask you where idea of allocating 'half' the size of queue came from.
> > the paper you sent does not work with single queue(magazine). Instead,
> > it manages pool of magazines.
> > 
> > And after reading the paper, I see managing pool of magazine (where M is
> > an boot parameter) is valid approach to reduce hitting slowpath.
> 
> Bonwick uses two magazines per cpu; if both are empty, one is replaced
> with a full one.  If both are full, one is replaced with an empty one.
> Our slab implementation doesn't provide magazine allocation, but it does
> provide bulk allocation.
> So translating the Bonwick implementation to
> our implementation, we need to bulk-allocate or bulk-free half of the
> array at any time.

Is there a reason that the number should be 'half'?

what about something like this:

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 884d3311cd8e..f32736302d53 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -455,12 +455,13 @@ void *kmem_cache_alloc_cached(struct kmem_cache *s, gfp_t gfpflags)
        }

        cache = get_cpu_ptr(s->cache);
-       if (cache->size) /* fastpath without lock */
+       if (cache->size) /* fastpath without lock */
                p = cache->queue[--cache->size];
        else {
                /* slowpath */
-               cache->size = kmem_cache_alloc_bulk(s, gfpflags,
-                               KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);
+               cache->size += kmem_cache_alloc_bulk(s, gfpflags,
+                               KMEM_LOCKLESS_CACHE_BATCHCOUNT,
+                               cache->queue);
                if (cache->size)
                        p = cache->queue[--cache->size];
                else
@@ -491,13 +492,13 @@ void kmem_cache_free_cached(struct kmem_cache *s, void *p)
        cache = get_cpu_ptr(s->cache);
        if (cache->size < KMEM_LOCKLESS_CACHE_QUEUE_SIZE) {
                cache->queue[cache->size++] = p;
-               put_cpu_ptr(s->cache);
-               return ;
+       } else {
+               kmem_cache_free_bulk(s,
+                               KMEM_LOCKLESS_CACHE_BATCHCOUNT,
+                               cache->queue - KMEM_LOCKLESS_CACHE_BATCHCOUNT);
+               cache->size -= KMEM_LOCKLESS_CACHE_BATCHCOUNT;
        }
        put_cpu_ptr(s->cache);
-
-       /* Is there better way to do this? */
-       kmem_cache_free(s, p);
 }
 EXPORT_SYMBOL(kmem_cache_free_cached);
