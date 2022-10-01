Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7045F1D7C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJAQKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 12:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJAQKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 12:10:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CF227DD3;
        Sat,  1 Oct 2022 09:10:00 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d24so6382647pls.4;
        Sat, 01 Oct 2022 09:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ZFt50GDqlKIYM4l8mECHUWC3f4w34q3ItwBbk2NFmik=;
        b=K3if3PVJ5bvcTJ9M0NPajRsS9R22PhUV8mt1DF9aSjhi92xxGX68nw1fQOdsnfeW88
         RYDbvN3GquD6aYJG58Lch5x17v+7Fbew3pLZMAkWt1+ooRJfi37RQADA2PXlVWpJ0CkC
         Tph9mkBw10QRI/4GlEXa2GIU/ewaCJw+Q5bhNbWEldyfKXsiimIOVSMffXQx+3tGU4Mj
         dJvzomia0B+Wj46FPagEpyfhrlYIDzrrtNbXqmnTPZIsHCWjn0Q7IxiKUPw+lNuqO8YW
         mhgisps0Go9/DKTKISmZAxZzmxBVutsjUNJDrnOyzW3IiQoFEADN8PzV+SFx5mJvo2bv
         Sq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZFt50GDqlKIYM4l8mECHUWC3f4w34q3ItwBbk2NFmik=;
        b=c5jAmLeP6Y8YFdsIgQMbsieNEPdAxKsNFmnv/Fsq/rNo0p5J33j8pmrShGaes5/iuz
         CL0SR7uONTP0nfyaAb5cCLwqrL+kCjd6HPBoKxHTLkI7mqqZ56nxzf8inda3ISoF7Rft
         fDILH7h8ctoST2en0t8SMOynG1wN/KPzBy8LXYmtS0TyIwl+Eg3wKJPxCFBOnDWoULh0
         SO9nAukb5PIU4zIcmEwIZg+NcPSBH240bARWs+m8WDCSFnQDZFLWKL8CrEVdmQOmR1zw
         0L3rIB5PJUPmzTN/qJ4t5bzOSFDtf/FwrVtA666ojgi9z0tBKYjJPCQMetv6N2qMd0DJ
         7dFQ==
X-Gm-Message-State: ACrzQf08TtNsiSdzKQnRBbwrKZ98QmhF/PEtnp/JzTgTEbgvJh3L6EGW
        H6rbPkglhh/G6kezKQvwzTo=
X-Google-Smtp-Source: AMsMyM4LFEW8r3bJhaCxZm3hZ+BJ6mFgt6vMylhuSPGZuSYFmA+LZrM5m1U3puB9ewICj0JZLSgwTQ==
X-Received: by 2002:a17:903:246:b0:179:96b5:1ad2 with SMTP id j6-20020a170903024600b0017996b51ad2mr14161925plh.37.1664640600299;
        Sat, 01 Oct 2022 09:10:00 -0700 (PDT)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090a474900b0020a28156e11sm3000108pjg.26.2022.10.01.09.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 09:09:59 -0700 (PDT)
Date:   Sun, 2 Oct 2022 01:09:47 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Marco Elver <elver@google.com>, linux-mm@kvack.org,
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
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 01/16] slab: Remove __malloc attribute from realloc
 functions
Message-ID: <YzhmSxKFzOXhUZ2Z@hyeyoo>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923202822.2667581-2-keescook@chromium.org>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 01:28:07PM -0700, Kees Cook wrote:
> The __malloc attribute should not be applied to "realloc" functions, as
> the returned pointer may alias the storage of the prior pointer. Instead
> of splitting __malloc from __alloc_size, which would be a huge amount of
> churn, just create __realloc_size for the few cases where it is needed.
> 
> Additionally removes the conditional test for __alloc_size__, which is
> always defined now.
> 
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Cc: Marco Elver <elver@google.com>
> Cc: linux-mm@kvack.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/compiler_types.h | 13 +++++--------
>  include/linux/slab.h           | 12 ++++++------
>  mm/slab_common.c               |  4 ++--
>  3 files changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index 4f2a819fd60a..f141a6f6b9f6 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -271,15 +271,12 @@ struct ftrace_likely_data {
>  
>  /*
>   * Any place that could be marked with the "alloc_size" attribute is also
> - * a place to be marked with the "malloc" attribute. Do this as part of the
> - * __alloc_size macro to avoid redundant attributes and to avoid missing a
> - * __malloc marking.
> + * a place to be marked with the "malloc" attribute, except those that may
> + * be performing a _reallocation_, as that may alias the existing pointer.
> + * For these, use __realloc_size().
>   */
> -#ifdef __alloc_size__
> -# define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
> -#else
> -# define __alloc_size(x, ...)	__malloc
> -#endif
> +#define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
> +#define __realloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__)
>  
>  #ifndef asm_volatile_goto
>  #define asm_volatile_goto(x...) asm goto(x)
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 0fefdf528e0d..41bd036e7551 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -184,7 +184,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
>  /*
>   * Common kmalloc functions provided by all allocators
>   */
> -void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
> +void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __realloc_size(2);
>  void kfree(const void *objp);
>  void kfree_sensitive(const void *objp);
>  size_t __ksize(const void *objp);
> @@ -647,10 +647,10 @@ static inline __alloc_size(1, 2) void *kmalloc_array(size_t n, size_t size, gfp_
>   * @new_size: new size of a single member of the array
>   * @flags: the type of memory to allocate (see kmalloc)
>   */
> -static inline __alloc_size(2, 3) void * __must_check krealloc_array(void *p,
> -								    size_t new_n,
> -								    size_t new_size,
> -								    gfp_t flags)
> +static inline __realloc_size(2, 3) void * __must_check krealloc_array(void *p,
> +								      size_t new_n,
> +								      size_t new_size,
> +								      gfp_t flags)
>  {
>  	size_t bytes;
>  
> @@ -774,7 +774,7 @@ static inline __alloc_size(1, 2) void *kvcalloc(size_t n, size_t size, gfp_t fla
>  }
>  
>  extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
> -		      __alloc_size(3);
> +		      __realloc_size(3);
>  extern void kvfree(const void *addr);
>  extern void kvfree_sensitive(const void *addr, size_t len);
>  
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 17996649cfe3..457671ace7eb 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1134,8 +1134,8 @@ module_init(slab_proc_init);
>  
>  #endif /* CONFIG_SLAB || CONFIG_SLUB_DEBUG */
>  
> -static __always_inline void *__do_krealloc(const void *p, size_t new_size,
> -					   gfp_t flags)
> +static __always_inline __realloc_size(2) void *
> +__do_krealloc(const void *p, size_t new_size, gfp_t flags)
>  {
>  	void *ret;
>  	size_t ks;
> -- 
> 2.34.1
> 

This is now squashed with later one. (so undefined __alloc_size__ issues are fixed)
for the latest version of this patch:

Looks good to me,
Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

-- 
Thanks,
Hyeonggon
