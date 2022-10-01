Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD915F1D95
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 18:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJAQ2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 12:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJAQ2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 12:28:43 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02873F330;
        Sat,  1 Oct 2022 09:28:42 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x29so1375556pfp.7;
        Sat, 01 Oct 2022 09:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=R2aHD+6cNWC3HBn0zEy8lfhSMETzy6xsa81iQFM1gFI=;
        b=CnfTxBe3WqNAdyY553znsd4WFFospJ6nV0IeY7yOw8ZjreQMj2OLZItT3LNcrhOnkf
         aTThdwcf5BzNMP0qDDY/4EyAErr2QFgwqecT3rScHeE4Dl680Tfv2aL3bzk/kErOtmDq
         grZRxtc1sYP1QttyJJx/QFXNIFEo3QXiuFowAUw9css/YVFum1/u/RnTMULPxJbt9+VK
         lSYflZML/wX23jxWTMvD7+5lIskYWo/IrjY1Q4VK/fvR33rrFJwRLISddVM2AmOEuNqB
         palf3qfWNF/+0DGlnyERowoZTmQklznRMX0Q+E6r9DyAzcYUAphN52Qgls8SK33d36+V
         80iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=R2aHD+6cNWC3HBn0zEy8lfhSMETzy6xsa81iQFM1gFI=;
        b=FCkXiSincs/HLG2IGsjzDDdd8J/vUmTS8vm1X1nw9SCn8Wu70L+CiXxDD7itqqzt3C
         3/kYTPM6az7LX8WlUTrAQ+j40djulKvQHvwtE6iF3fLsY4Nk/i3VxEDpWyyTdjxCXc2C
         HhkEzfq1UDSFbUqbdcxTXJ3oBR4PKSAYW+qI8iyDcQJcar5UNPhSSL+O5Epbeasauej3
         zLWR4Dr9zKUr327vWgrLNuINfP6jv7Pu+LJgO0Xt8R0Ryk0cknyFdSKskMOXAfzJx512
         /6YCbGcvWVJmpQT9AI0JRyr9OLgfR4zWY2GtdrXdesww1IH9oSnMDFavrM/0ZP3TslsX
         +Smg==
X-Gm-Message-State: ACrzQf2REX3h6GABGoag5uNW8R5qA54J2DEhV7/9EZDBSkTMDOyBxn6v
        6PBbmJJxAw7i2+g6b/IvqTs=
X-Google-Smtp-Source: AMsMyM48mu3JqsMIftzSaQxBhnp0gnxIuN2YeQjS74Ood1zBecUmQ9aA0E1zLhZxhlZVNlJyuKM6YA==
X-Received: by 2002:a63:8a43:0:b0:44b:5c1b:6213 with SMTP id y64-20020a638a43000000b0044b5c1b6213mr1050682pgd.532.1664641722092;
        Sat, 01 Oct 2022 09:28:42 -0700 (PDT)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id cp24-20020a17090afb9800b00205f4f7a3b3sm3554434pjb.21.2022.10.01.09.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 09:28:41 -0700 (PDT)
Date:   Sun, 2 Oct 2022 01:28:30 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
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
Message-ID: <Yzhqrmpmo8/sGI3g@hyeyoo>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923202822.2667581-3-keescook@chromium.org>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 01:28:08PM -0700, Kees Cook wrote:
> In the effort to help the compiler reason about buffer sizes, the
> __alloc_size attribute was added to allocators. This improves the scope
> of the compiler's ability to apply CONFIG_UBSAN_BOUNDS and (in the near
> future) CONFIG_FORTIFY_SOURCE. For most allocations, this works well,
> as the vast majority of callers are not expecting to use more memory
> than what they asked for.
> 
> There is, however, one common exception to this: anticipatory resizing
> of kmalloc allocations. These cases all use ksize() to determine the
> actual bucket size of a given allocation (e.g. 128 when 126 was asked
> for). This comes in two styles in the kernel:
> 
> 1) An allocation has been determined to be too small, and needs to be
>    resized. Instead of the caller choosing its own next best size, it
>    wants to minimize the number of calls to krealloc(), so it just uses
>    ksize() plus some additional bytes, forcing the realloc into the next
>    bucket size, from which it can learn how large it is now. For example:
> 
> 	data = krealloc(data, ksize(data) + 1, gfp);
> 	data_len = ksize(data);
> 
> 2) The minimum size of an allocation is calculated, but since it may
>    grow in the future, just use all the space available in the chosen
>    bucket immediately, to avoid needing to reallocate later. A good
>    example of this is skbuff's allocators:
> 
> 	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> 	...
> 	/* kmalloc(size) might give us more room than requested.
> 	 * Put skb_shared_info exactly at the end of allocated zone,
> 	 * to allow max possible filling before reallocation.
> 	 */
> 	osize = ksize(data);
>         size = SKB_WITH_OVERHEAD(osize);
> 
> In both cases, the "how much was actually allocated?" question is answered
> _after_ the allocation, where the compiler hinting is not in an easy place
> to make the association any more. This mismatch between the compiler's
> view of the buffer length and the code's intention about how much it is
> going to actually use has already caused problems[1]. It is possible to
> fix this by reordering the use of the "actual size" information.
> 
> We can serve the needs of users of ksize() and still have accurate buffer
> length hinting for the compiler by doing the bucket size calculation
> _before_ the allocation. Code can instead ask "how large an allocation
> would I get for a given size?".
> 
> Introduce kmalloc_size_roundup(), to serve this function so we can start
> replacing the "anticipatory resizing" uses of ksize().
> 
> [1] https://github.com/ClangBuiltLinux/linux/issues/1599
>     https://github.com/KSPP/linux/issues/183
> 
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/slab.h | 31 +++++++++++++++++++++++++++++++
>  mm/slab.c            |  9 ++++++---
>  mm/slab_common.c     | 20 ++++++++++++++++++++
>  3 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 41bd036e7551..727640173568 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -188,7 +188,21 @@ void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __r
>  void kfree(const void *objp);
>  void kfree_sensitive(const void *objp);
>  size_t __ksize(const void *objp);
> +
> +/**
> + * ksize - Report actual allocation size of associated object
> + *
> + * @objp: Pointer returned from a prior kmalloc()-family allocation.
> + *
> + * This should not be used for writing beyond the originally requested
> + * allocation size. Either use krealloc() or round up the allocation size
> + * with kmalloc_size_roundup() prior to allocation. If this is used to
> + * access beyond the originally requested allocation size, UBSAN_BOUNDS
> + * and/or FORTIFY_SOURCE may trip, since they only know about the
> + * originally allocated size via the __alloc_size attribute.
> + */
>  size_t ksize(const void *objp);
> +

With this now we have two conflicting kernel-doc comments
about ksize in mm/slab_common.c and include/linux/slab.h.

>  #ifdef CONFIG_PRINTK
>  bool kmem_valid_obj(void *object);
>  void kmem_dump_obj(void *object);
> @@ -779,6 +793,23 @@ extern void kvfree(const void *addr);
>  extern void kvfree_sensitive(const void *addr, size_t len);
>  
>  unsigned int kmem_cache_size(struct kmem_cache *s);
> +
> +/**
> + * kmalloc_size_roundup - Report allocation bucket size for the given size
> + *
> + * @size: Number of bytes to round up from.
> + *
> + * This returns the number of bytes that would be available in a kmalloc()
> + * allocation of @size bytes. For example, a 126 byte request would be
> + * rounded up to the next sized kmalloc bucket, 128 bytes. (This is strictly
> + * for the general-purpose kmalloc()-based allocations, and is not for the
> + * pre-sized kmem_cache_alloc()-based allocations.)
> + *
> + * Use this to kmalloc() the full bucket size ahead of time instead of using
> + * ksize() to query the size after an allocation.
> + */
> +size_t kmalloc_size_roundup(size_t size);
> +
>  void __init kmem_cache_init_late(void);
>  
>  #if defined(CONFIG_SMP) && defined(CONFIG_SLAB)
> diff --git a/mm/slab.c b/mm/slab.c
> index 10e96137b44f..2da862bf6226 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4192,11 +4192,14 @@ void __check_heap_object(const void *ptr, unsigned long n,
>  #endif /* CONFIG_HARDENED_USERCOPY */
>  
>  /**
> - * __ksize -- Uninstrumented ksize.
> + * __ksize -- Report full size of underlying allocation
>   * @objp: pointer to the object
>   *
> - * Unlike ksize(), __ksize() is uninstrumented, and does not provide the same
> - * safety checks as ksize() with KASAN instrumentation enabled.
> + * This should only be used internally to query the true size of allocations.
> + * It is not meant to be a way to discover the usable size of an allocation
> + * after the fact. Instead, use kmalloc_size_roundup(). Using memory beyond
> + * the originally requested allocation size may trigger KASAN, UBSAN_BOUNDS,
> + * and/or FORTIFY_SOURCE.
>   *
>   * Return: size of the actual memory used by @objp in bytes
>   */
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 457671ace7eb..d7420cf649f8 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -721,6 +721,26 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
>  	return kmalloc_caches[kmalloc_type(flags)][index];
>  }
>  
> +size_t kmalloc_size_roundup(size_t size)
> +{
> +	struct kmem_cache *c;
> +
> +	/* Short-circuit the 0 size case. */
> +	if (unlikely(size == 0))
> +		return 0;
> +	/* Short-circuit saturated "too-large" case. */
> +	if (unlikely(size == SIZE_MAX))
> +		return SIZE_MAX;
> +	/* Above the smaller buckets, size is a multiple of page size. */
> +	if (size > KMALLOC_MAX_CACHE_SIZE)
> +		return PAGE_SIZE << get_order(size);
> +
> +	/* The flags don't matter since size_index is common to all. */
> +	c = kmalloc_slab(size, GFP_KERNEL);
> +	return c ? c->object_size : 0;
> +}
> +EXPORT_SYMBOL(kmalloc_size_roundup);
> +
>  #ifdef CONFIG_ZONE_DMA
>  #define KMALLOC_DMA_NAME(sz)	.name[KMALLOC_DMA] = "dma-kmalloc-" #sz,
>  #else
> -- 
> 2.34.1

Otherwise looks good!

-- 
Thanks,
Hyeonggon
