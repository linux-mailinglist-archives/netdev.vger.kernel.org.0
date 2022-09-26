Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AF05EAF29
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiIZSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiIZSGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:06:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23798284F
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:50:39 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso7681026pjd.1
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 10:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=TNDUsCjQ4zB2/5GZ7X+uS9zeoK4Uz9rg4Dmc7gG+Kts=;
        b=diPFMelUGqg5Olz6I8z2UqQgP/qT0p6U2CTPr1IKXAPPQDlXjIbGiW+Mq8ZW/AJerP
         YVtmTqGjAus4WfzbTh4Tizc48Roo/vvFh6ncx714UJ4hLWN/DikhBXoZzoyhCy7LE6Y/
         3OYOMIYymLSLRxuRHD8IaRlLtQ4iFKBE+1Png=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TNDUsCjQ4zB2/5GZ7X+uS9zeoK4Uz9rg4Dmc7gG+Kts=;
        b=mYEsPABud6aSQKq4c5g5NaBoTWVKgNjxp1WG2EJ2tYP1UyzMk16dSdXe00huPOWrRq
         PG799Jp47dvQIzCJ/wSrTrWCH15sK3WTT18kp8/K1QByfTl4XYUnM46bNNPLjbfz/rM2
         xz6wTvgXFlsyWFDFiVlIaYhf3Hvx++pOXnUA2eNSdDkuqNEgK6NHSheDJGlTwcUfIt9N
         mO4//VLPVXv/09QZ6QT3n79YQb2tgRd5LGJvyKSDkRnliFVkU3Vgk3UfBeAY+BkKkg6j
         sxPA5T2FiDmDPcRvDhqCWyoS1xAwuITM7WjxGTKRAw/DIDfMuD5s4/PQ4kvQKsBi2DyU
         aW0g==
X-Gm-Message-State: ACrzQf1WVQGK3tlJOLgFpuTAddG5WYHLubJ3L8wdbSV71Oa1Vc4CJqSB
        YG2nTdhWlfX2OFmkIxMYua3vrg==
X-Google-Smtp-Source: AMsMyM53HUNBt6kGZBRWVtwFK3cgJAVMJrfeOBQoCVB2uG4qpYwM3FiGKu6g/YmgMRQUrRqqychKmQ==
X-Received: by 2002:a17:90a:a09:b0:202:ab93:2afb with SMTP id o9-20020a17090a0a0900b00202ab932afbmr37124281pjo.60.1664214639071;
        Mon, 26 Sep 2022 10:50:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g13-20020aa79f0d000000b00536097dd45bsm12539497pfr.134.2022.09.26.10.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 10:50:37 -0700 (PDT)
Date:   Mon, 26 Sep 2022 10:50:36 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 02/16] slab: Introduce kmalloc_size_roundup()
Message-ID: <202209261050.560459B@keescook>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-3-keescook@chromium.org>
 <e0326835-9b0d-af1b-bd22-2aadb178bd25@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0326835-9b0d-af1b-bd22-2aadb178bd25@suse.cz>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:15:22PM +0200, Vlastimil Babka wrote:
> On 9/23/22 22:28, Kees Cook wrote:
> > In the effort to help the compiler reason about buffer sizes, the
> > __alloc_size attribute was added to allocators. This improves the scope
> > of the compiler's ability to apply CONFIG_UBSAN_BOUNDS and (in the near
> > future) CONFIG_FORTIFY_SOURCE. For most allocations, this works well,
> > as the vast majority of callers are not expecting to use more memory
> > than what they asked for.
> > 
> > There is, however, one common exception to this: anticipatory resizing
> > of kmalloc allocations. These cases all use ksize() to determine the
> > actual bucket size of a given allocation (e.g. 128 when 126 was asked
> > for). This comes in two styles in the kernel:
> > 
> > 1) An allocation has been determined to be too small, and needs to be
> >     resized. Instead of the caller choosing its own next best size, it
> >     wants to minimize the number of calls to krealloc(), so it just uses
> >     ksize() plus some additional bytes, forcing the realloc into the next
> >     bucket size, from which it can learn how large it is now. For example:
> > 
> > 	data = krealloc(data, ksize(data) + 1, gfp);
> > 	data_len = ksize(data);
> > 
> > 2) The minimum size of an allocation is calculated, but since it may
> >     grow in the future, just use all the space available in the chosen
> >     bucket immediately, to avoid needing to reallocate later. A good
> >     example of this is skbuff's allocators:
> > 
> > 	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> > 	...
> > 	/* kmalloc(size) might give us more room than requested.
> > 	 * Put skb_shared_info exactly at the end of allocated zone,
> > 	 * to allow max possible filling before reallocation.
> > 	 */
> > 	osize = ksize(data);
> >          size = SKB_WITH_OVERHEAD(osize);
> > 
> > In both cases, the "how much was actually allocated?" question is answered
> > _after_ the allocation, where the compiler hinting is not in an easy place
> > to make the association any more. This mismatch between the compiler's
> > view of the buffer length and the code's intention about how much it is
> > going to actually use has already caused problems[1]. It is possible to
> > fix this by reordering the use of the "actual size" information.
> > 
> > We can serve the needs of users of ksize() and still have accurate buffer
> > length hinting for the compiler by doing the bucket size calculation
> > _before_ the allocation. Code can instead ask "how large an allocation
> > would I get for a given size?".
> > 
> > Introduce kmalloc_size_roundup(), to serve this function so we can start
> > replacing the "anticipatory resizing" uses of ksize().
> > 
> > [1] https://github.com/ClangBuiltLinux/linux/issues/1599
> >      https://github.com/KSPP/linux/issues/183
> > 
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> OK, added patch 1+2 to slab.git for-next branch.
> Had to adjust this one a bit, see below.
> 
> > ---
> >   include/linux/slab.h | 31 +++++++++++++++++++++++++++++++
> >   mm/slab.c            |  9 ++++++---
> >   mm/slab_common.c     | 20 ++++++++++++++++++++
> >   3 files changed, 57 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/slab.h b/include/linux/slab.h
> > index 41bd036e7551..727640173568 100644
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -188,7 +188,21 @@ void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __r
> >   void kfree(const void *objp);
> >   void kfree_sensitive(const void *objp);
> >   size_t __ksize(const void *objp);
> > +
> > +/**
> > + * ksize - Report actual allocation size of associated object
> > + *
> > + * @objp: Pointer returned from a prior kmalloc()-family allocation.
> > + *
> > + * This should not be used for writing beyond the originally requested
> > + * allocation size. Either use krealloc() or round up the allocation size
> > + * with kmalloc_size_roundup() prior to allocation. If this is used to
> > + * access beyond the originally requested allocation size, UBSAN_BOUNDS
> > + * and/or FORTIFY_SOURCE may trip, since they only know about the
> > + * originally allocated size via the __alloc_size attribute.
> > + */
> >   size_t ksize(const void *objp);
> > +
> >   #ifdef CONFIG_PRINTK
> >   bool kmem_valid_obj(void *object);
> >   void kmem_dump_obj(void *object);
> > @@ -779,6 +793,23 @@ extern void kvfree(const void *addr);
> >   extern void kvfree_sensitive(const void *addr, size_t len);
> >   unsigned int kmem_cache_size(struct kmem_cache *s);
> > +
> > +/**
> > + * kmalloc_size_roundup - Report allocation bucket size for the given size
> > + *
> > + * @size: Number of bytes to round up from.
> > + *
> > + * This returns the number of bytes that would be available in a kmalloc()
> > + * allocation of @size bytes. For example, a 126 byte request would be
> > + * rounded up to the next sized kmalloc bucket, 128 bytes. (This is strictly
> > + * for the general-purpose kmalloc()-based allocations, and is not for the
> > + * pre-sized kmem_cache_alloc()-based allocations.)
> > + *
> > + * Use this to kmalloc() the full bucket size ahead of time instead of using
> > + * ksize() to query the size after an allocation.
> > + */
> > +size_t kmalloc_size_roundup(size_t size);
> > +
> >   void __init kmem_cache_init_late(void);
> >   #if defined(CONFIG_SMP) && defined(CONFIG_SLAB)
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 10e96137b44f..2da862bf6226 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -4192,11 +4192,14 @@ void __check_heap_object(const void *ptr, unsigned long n,
> >   #endif /* CONFIG_HARDENED_USERCOPY */
> >   /**
> > - * __ksize -- Uninstrumented ksize.
> > + * __ksize -- Report full size of underlying allocation
> >    * @objp: pointer to the object
> >    *
> > - * Unlike ksize(), __ksize() is uninstrumented, and does not provide the same
> > - * safety checks as ksize() with KASAN instrumentation enabled.
> > + * This should only be used internally to query the true size of allocations.
> > + * It is not meant to be a way to discover the usable size of an allocation
> > + * after the fact. Instead, use kmalloc_size_roundup(). Using memory beyond
> > + * the originally requested allocation size may trigger KASAN, UBSAN_BOUNDS,
> > + * and/or FORTIFY_SOURCE.
> >    *
> >    * Return: size of the actual memory used by @objp in bytes
> >    */
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 457671ace7eb..d7420cf649f8 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -721,6 +721,26 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
> >   	return kmalloc_caches[kmalloc_type(flags)][index];
> >   }
> > +size_t kmalloc_size_roundup(size_t size)
> > +{
> > +	struct kmem_cache *c;
> > +
> > +	/* Short-circuit the 0 size case. */
> > +	if (unlikely(size == 0))
> > +		return 0;
> > +	/* Short-circuit saturated "too-large" case. */
> > +	if (unlikely(size == SIZE_MAX))
> > +		return SIZE_MAX;
> > +	/* Above the smaller buckets, size is a multiple of page size. */
> > +	if (size > KMALLOC_MAX_CACHE_SIZE)
> > +		return PAGE_SIZE << get_order(size);
> > +
> > +	/* The flags don't matter since size_index is common to all. */
> > +	c = kmalloc_slab(size, GFP_KERNEL);
> > +	return c ? c->object_size : 0;
> > +}
> > +EXPORT_SYMBOL(kmalloc_size_roundup);
> 
> We need a SLOB version too as it's not yet removed... I added this:
> 
> diff --git a/mm/slob.c b/mm/slob.c
> index 2bd4f476c340..5dbdf6ad8bcc 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -574,6 +574,20 @@ void kfree(const void *block)
>  }
>  EXPORT_SYMBOL(kfree);
> +size_t kmalloc_size_roundup(size_t size)
> +{
> +       /* Short-circuit the 0 size case. */
> +       if (unlikely(size == 0))
> +               return 0;
> +       /* Short-circuit saturated "too-large" case. */
> +       if (unlikely(size == SIZE_MAX))
> +               return SIZE_MAX;
> +
> +       return ALIGN(size, ARCH_KMALLOC_MINALIGN);
> +}
> +
> +EXPORT_SYMBOL(kmalloc_size_roundup);

Ah, perfect! Thanks for catching that. :)

FWIW:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
