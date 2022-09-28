Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971EC5ED621
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiI1Hbh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 03:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiI1Hbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:31:34 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45883EFA5B;
        Wed, 28 Sep 2022 00:31:13 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id a20so7436705qtw.10;
        Wed, 28 Sep 2022 00:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qLaRR+atoHoSJaoPeYCH+z3TJyk6r6Xbl1EdBW345pA=;
        b=6NnEPABEVDJzwh6yCurfx1Cif5DMapO+bg1iMikzghyO38AmfDSR94isRYQCdZjRIk
         pyZZpIknvj8ECkP8iVx5yjZC10ic9v7bNmeVzwZ9pum0Y0TRGa9SgYNq13DLkvBkN2z5
         8CMqpnp/IyQTSxyGZ9Dv2SUWJ4CzzvvRYl3cSmk5/LKtSSbMkhtBxVtgnnUhC4nTRXq1
         GPvaysL3BVE8WVVXEBvhEgzS1ghJ6swCy7oiCxSVlIwgztHn8DndlXSHRwcOiqPxauth
         IXo8pdKoZz69P+7kWBAuGiDAvhvxvmrs70k/ThsZJZBsd96TGkHpEmrikmijgqml2D3u
         U3rw==
X-Gm-Message-State: ACrzQf3xXpKbb7hm4jsTAbm5KlnbQW8kiPjsABe0wd8k2h4dOmzHAlmy
        6OkP9PbmtEEraX6MRFqBxqNQDtejTlb2Fw==
X-Google-Smtp-Source: AMsMyM4+PNFxoIXXZBmtdzqe4MriABDPe51IFn1BULr+he2jCjsTHGWgMj7oO+fZnDBoWSErj88otg==
X-Received: by 2002:ac8:5ccd:0:b0:35c:e18b:2be3 with SMTP id s13-20020ac85ccd000000b0035ce18b2be3mr25152912qta.502.1664349989011;
        Wed, 28 Sep 2022 00:26:29 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id n8-20020a05620a294800b006cfc1d827cbsm1140417qkp.9.2022.09.28.00.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 00:26:28 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-35393e71e1eso4939837b3.9;
        Wed, 28 Sep 2022 00:26:27 -0700 (PDT)
X-Received: by 2002:a81:758a:0:b0:345:450b:6668 with SMTP id
 q132-20020a81758a000000b00345450b6668mr28433710ywc.316.1664349987412; Wed, 28
 Sep 2022 00:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220923202822.2667581-1-keescook@chromium.org> <20220923202822.2667581-2-keescook@chromium.org>
In-Reply-To: <20220923202822.2667581-2-keescook@chromium.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 28 Sep 2022 09:26:15 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
Message-ID: <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
Subject: Re: [PATCH v2 01/16] slab: Remove __malloc attribute from realloc functions
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
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
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

On Fri, Sep 23, 2022 at 10:35 PM Kees Cook <keescook@chromium.org> wrote:
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

Thanks for your patch, which is now commit 63caa04ec60583b1 ("slab:
Remove __malloc attribute from realloc functions") in next-20220927.

Noreply@ellerman.id.au reported all gcc8-based builds to fail
(e.g. [1], more at [2]):

    In file included from <command-line>:
    ./include/linux/percpu.h: In function ‘__alloc_reserved_percpu’:
    ././include/linux/compiler_types.h:279:30: error: expected
declaration specifiers before ‘__alloc_size__’
     #define __alloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__) __malloc
                                  ^~~~~~~~~~~~~~
    ./include/linux/percpu.h:120:74: note: in expansion of macro ‘__alloc_size’
    [...]

It's building fine with e.g. gcc-9 (which is my usual m68k cross-compiler).
Reverting this commit on next-20220927 fixes the issue.

[1] http://kisskb.ellerman.id.au/kisskb/buildresult/14803908/
[2] http://kisskb.ellerman.id.au/kisskb/head/1bd8b75fe6adeaa89d02968bdd811ffe708cf839/



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
> -# define __alloc_size(x, ...)  __alloc_size__(x, ## __VA_ARGS__) __malloc
> -#else
> -# define __alloc_size(x, ...)  __malloc
> -#endif
> +#define __alloc_size(x, ...)   __alloc_size__(x, ## __VA_ARGS__) __malloc
> +#define __realloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__)
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
> -                                                                   size_t new_n,
> -                                                                   size_t new_size,
> -                                                                   gfp_t flags)
> +static inline __realloc_size(2, 3) void * __must_check krealloc_array(void *p,
> +                                                                     size_t new_n,
> +                                                                     size_t new_size,
> +                                                                     gfp_t flags)
>  {
>         size_t bytes;
>
> @@ -774,7 +774,7 @@ static inline __alloc_size(1, 2) void *kvcalloc(size_t n, size_t size, gfp_t fla
>  }
>
>  extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
> -                     __alloc_size(3);
> +                     __realloc_size(3);
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
> -                                          gfp_t flags)
> +static __always_inline __realloc_size(2) void *
> +__do_krealloc(const void *p, size_t new_size, gfp_t flags)
>  {
>         void *ret;
>         size_t ks;
> --
> 2.34.1
>


--
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
