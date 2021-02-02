Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA49F30C59A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhBBQ1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236315AbhBBQXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:23:24 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32BFC061788
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 08:20:05 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id h11so21867576ioh.11
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 08:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Da19mOLKmJyRjSXgpGZWU4OOIXigtDd8FLvo0i6X24=;
        b=jb5DKhEAl6leh7r1gGeddbngBnqJXZL/aura7fPimgD6Cflo8LfGJr9lpaeOLWHsxQ
         fzD4QQBV6EFMGycTlkuCNCl0GutMzSxFx1hHRfIkJip8fyzuAVFLutLZTyvS7TG0Frbh
         fj4+5lOngmC6lIDh9eG5+FqQfwI8cc1hOsTzEbjJTSvzXFV4G45yQkFy10ekSaaNBk8r
         4Ixk/AQQP8Vw+oGCJS/VLqBoks7Q341EYD3GS9CnpZiy60gXTv6vx7ZWuEzVon43ilur
         C3FVbNcKsKelYg+iIMTtcmC1PIcyv2YxgdlHdgCsdYFtzy9PrbmAvgUCJxR9ohoVWcDw
         Mitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Da19mOLKmJyRjSXgpGZWU4OOIXigtDd8FLvo0i6X24=;
        b=DYrl11ADgcMGrp7Sqm5TkTEL4wNu3Qu6PA58YhvkBync/PExQ/DCn1yhqDbLJddGvs
         s/CpI5V7R94w0f16XleOXt/sO7PYIQm7c7nR/hGCfY3VcJGIszzSzZv+CYN/6gc7keGj
         zc20eqU0AIpDcqi6lm/ILPi7gMIGiqlBwzOO6HGs/GFGt7uL1po6mwMaSKrvn9RNWofK
         fqaiczhmUBlRAwV3yi1QxJ34yl+TKdg2wAuzRfJzy2znkbrLHvGBXsOZBKbsNUmFInIe
         s9n5BONZ9KJHg+6uH8BSDsgIYaBwj2R/wH2H5qPgTbJBmd1zUbe+Cg0m6LvUdBXnb3wr
         3KRQ==
X-Gm-Message-State: AOAM531CDr5EHDKySpmbY61w0rd2wMTvPzetaiop2++HJBUYMAl14mCk
        YvNUNNiPdJe9DTtabmufoGBTTomkEpcUHNg8nTM=
X-Google-Smtp-Source: ABdhPJzgiYkMbxueZ9+tOHERxUDsWzJJifUYbboj6iiuldrT0aG9w/GhlMkFeGk2p5lawoQCBWKauMBgiIxRdcJ3ufk=
X-Received: by 2002:a6b:f904:: with SMTP id j4mr7922451iog.138.1612282804958;
 Tue, 02 Feb 2021 08:20:04 -0800 (PST)
MIME-Version: 1.0
References: <20210131074426.44154-1-haokexin@gmail.com> <20210131074426.44154-2-haokexin@gmail.com>
In-Reply-To: <20210131074426.44154-2-haokexin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 2 Feb 2021 08:19:54 -0800
Message-ID: <CAKgT0Uf2BJ-EHF+Cp+Jp4121xH3ei_L9ZCE1TFVPJVp4Ru9O0w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/4] mm: page_frag: Introduce page_frag_alloc_align()
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 11:54 PM Kevin Hao <haokexin@gmail.com> wrote:
>
> In the current implementation of page_frag_alloc(), it doesn't have
> any align guarantee for the returned buffer address. But for some
> hardwares they do require the DMA buffer to be aligned correctly,
> so we would have to use some workarounds like below if the buffers
> allocated by the page_frag_alloc() are used by these hardwares for
> DMA.
>     buf = page_frag_alloc(really_needed_size + align);
>     buf = PTR_ALIGN(buf, align);
>
> These codes seems ugly and would waste a lot of memories if the buffers
> are used in a network driver for the TX/RX. So introduce
> page_frag_alloc_align() to make sure that an aligned buffer address is
> returned.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> v2:
>   - Inline page_frag_alloc()
>   - Adopt Vlastimil's suggestion and add his Acked-by
>
>  include/linux/gfp.h | 12 ++++++++++--
>  mm/page_alloc.c     |  8 +++++---
>  2 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 6e479e9c48ce..39f4b3070d09 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -583,8 +583,16 @@ extern void free_pages(unsigned long addr, unsigned int order);
>
>  struct page_frag_cache;
>  extern void __page_frag_cache_drain(struct page *page, unsigned int count);
> -extern void *page_frag_alloc(struct page_frag_cache *nc,
> -                            unsigned int fragsz, gfp_t gfp_mask);
> +extern void *page_frag_alloc_align(struct page_frag_cache *nc,
> +                                  unsigned int fragsz, gfp_t gfp_mask,
> +                                  int align);
> +
> +static inline void *page_frag_alloc(struct page_frag_cache *nc,
> +                            unsigned int fragsz, gfp_t gfp_mask)
> +{
> +       return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
> +}
> +
>  extern void page_frag_free(void *addr);
>
>  #define __free_page(page) __free_pages((page), 0)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 519a60d5b6f7..4667e7b6993b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5137,8 +5137,8 @@ void __page_frag_cache_drain(struct page *page, unsigned int count)
>  }
>  EXPORT_SYMBOL(__page_frag_cache_drain);
>
> -void *page_frag_alloc(struct page_frag_cache *nc,
> -                     unsigned int fragsz, gfp_t gfp_mask)
> +void *page_frag_alloc_align(struct page_frag_cache *nc,
> +                     unsigned int fragsz, gfp_t gfp_mask, int align)

I would make "align" unsigned since really we are using it as a mask.
Actually passing it as a mask might be even better. More on that
below.

>  {
>         unsigned int size = PAGE_SIZE;
>         struct page *page;
> @@ -5190,11 +5190,13 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>         }
>
>         nc->pagecnt_bias--;
> +       if (align)
> +               offset = ALIGN_DOWN(offset, align);
>         nc->offset = offset;
>
>         return nc->va + offset;
>  }
> -EXPORT_SYMBOL(page_frag_alloc);
> +EXPORT_SYMBOL(page_frag_alloc_align);
>
>  /*
>   * Frees a page fragment allocated out of either a compound or order 0 page.

Rather than using the conditional branch it might be better to just do
"offset &= align_mask". Then you would be adding at most 1 instruction
which can likely occur in parallel with the other work that is going
on versus the conditional branch which requires a test, jump, and then
the 3 alignment instructions to do the subtraction, inversion, and
AND.

However it would ripple through the other patches as you would also
need to update you other patches to assume ~0 in the unaligned case,
however with your masked cases you could just use the negative
alignment value to generate your mask which would likely be taken care
of by the compiler.
