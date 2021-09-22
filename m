Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95064144D1
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhIVJN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbhIVJN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:13:28 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EEFC061574;
        Wed, 22 Sep 2021 02:11:58 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y8so2173948pfa.7;
        Wed, 22 Sep 2021 02:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/H8JM7coTsTy8XjFA3lC9gYA0UOGgAXPd+2isahauao=;
        b=HLfzScsMUNlMK27qLlQSMLyfFJnzi9FRK1BoI4XnD5EpQ+Emg5A4BoboFCRpkw9Wu6
         GFb3+8rXr2IGnlWuakYdqs9ifweiLD482y5Wh/4vszZ6EN6rVvdHADhIS0epD+NYEwE5
         VB3SD6O3yCZSWZdAQCSzUgeh9GEYZHrRP38yqiZ/LsmaVLYrV1ZitsdcCx3+crTPbW9/
         9mXffiGZFQNCc55bpPPcSbV2jXSe4V84W3wfzbuiENLTLgOwILeOqvzupRWDDtAqWlqQ
         in3ruqZ1NB/EXth8tYXBxPyqcm5ojD+7vypxzfXWxb2UNl54PRTzzCGscW5qzbRsDJ3Z
         eHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/H8JM7coTsTy8XjFA3lC9gYA0UOGgAXPd+2isahauao=;
        b=ysHT+h8YcOganZvY7oupZk0G4qES1kZzq3lSahUTuK0aPrS9fkG4NRfJaIIcilT/wG
         Whft4LxiOKlSKPmjT2w2q8ShZGBV8BAdBK0Uazgn9yrskUKnbWi8DuU3E47BPImC5zXK
         RDdyDRDdMw9XLkyg54GHuwnEduv2YxmlSEIMUim/8vsdeHrJhDbc/fpXCBGcP1QDfc1D
         5sFXHFRvfbtO424r7loxI2H8gpotj3VwihD8rwvy82a0UZQI3jEPKtklmwxgsZt++LDf
         0jm0J9dibCkTYZh6mcIBmAqZflLn6YzJA9QR4zEmrkVgIIt+LcPFxeslBBAHsygzzid+
         2GEQ==
X-Gm-Message-State: AOAM532emL9gO+Cku1nZ15WfGHRoYD56JwtoEM65KehuMOKbDZrGZY3H
        Lz8CKpHQqGZqjRmgflYgPc4=
X-Google-Smtp-Source: ABdhPJyJbGKl9PSSC+E0xge37GY2XBRLrgMN4EpM3vgbuVyw3BCwFcQ0wzvDDavBtUv/zMLPJv3aow==
X-Received: by 2002:a65:6554:: with SMTP id a20mr32010143pgw.107.1632301918483;
        Wed, 22 Sep 2021 02:11:58 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id h15sm1755742pfo.54.2021.09.22.02.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 02:11:58 -0700 (PDT)
Date:   Wed, 22 Sep 2021 09:11:53 +0000
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
Message-ID: <20210922091153.GA80396@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
 <YUkErK1vVZMht4s8@casper.infradead.org>
 <20210921154239.GA5092@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
 <YUoFfrQBmOdPEKpJ@casper.infradead.org>
 <20210922083228.GA79355@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922083228.GA79355@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -491,13 +492,13 @@ void kmem_cache_free_cached(struct kmem_cache *s, void *p)
>         cache = get_cpu_ptr(s->cache);
>         if (cache->size < KMEM_LOCKLESS_CACHE_QUEUE_SIZE) {
>                 cache->queue[cache->size++] = p;
> -               put_cpu_ptr(s->cache);
> -               return ;
> +       } else {
> +               kmem_cache_free_bulk(s,
> +                               KMEM_LOCKLESS_CACHE_BATCHCOUNT,
> +                               cache->queue - KMEM_LOCKLESS_CACHE_BATCHCOUNT);
> +               cache->size -= KMEM_LOCKLESS_CACHE_BATCHCOUNT;
>         }
>         put_cpu_ptr(s->cache);
> -
> -       /* Is there better way to do this? */
> -       kmem_cache_free(s, p);
>  }
>  EXPORT_SYMBOL(kmem_cache_free_cached);

Sent you a wrong code.

Above was buggy code from some hours ago 
because of cache->queue - KMEM_LOCKLESS_CACHE_BATCHCOUNT.

So that is now:

	cache = get_cpu_ptr(s->cache);
	if (cache->size < KMEM_LOCKLESS_CACHE_QUEUE_SIZE) {
		cache->queue[cache->size++] = p;
	} else {
		kmem_cache_free_bulk(s,
				KMEM_LOCKLESS_CACHE_BATCHCOUNT,
				cache->queue + KMEM_LOCKLESS_CACHE_QUEUE_SIZE
				- KMEM_LOCKLESS_CACHE_BATCHCOUNT);
		cache->size -= KMEM_LOCKLESS_CACHE_BATCHCOUNT;
	}
	put_cpu_ptr(s->cache);
