Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598945E7E44
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiIWPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiIWPXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:23:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F83F148A2C
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:22:58 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id f23so473469plr.6
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dt2S/GvG0+ik7cReE6XNKY8qJKXq2AZToaT9MrYplrA=;
        b=Fznt0rhoF0TkEASjZ5J9vyjMgIBA9xLGmu2zHUkEm4f5522oGE5DvDYeUwBVZkPyEm
         ZyJP9ws95+rcxfLfgFV006IeoOjOCr4v6qVH/5InrGyEpT7zWWU4hdz8k26EtP2CBdXQ
         HuEt0A6ArpqTIdVeppQ9U2JPjg6UbSmi/wcywes8hROln861F9mpYocl7SOi9NsyCtIl
         XpAimyLMw/Z1ZaKFqu4BLY2OT0FJcvRnHeFQTho6umcBvtgsRRNYXbCi3XvDe7fTnjed
         v8jN0AUKyxekHYlL93V/zofh6J58eWZ0Y3o4r7m5h/XcqPZSZJQm6Pe43/HL+4PHs5DK
         jp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dt2S/GvG0+ik7cReE6XNKY8qJKXq2AZToaT9MrYplrA=;
        b=rhpgoRlyyfaXEGDeOYVE4oKYay/iCpTme6qi3CFLxlPMX5qzhgow9tFTi58r8IgdpU
         8kMO1J8beno2dAG9N8BfquaY7VfZgpDml6/Gws5Eq997/By4hF3svYKVZPUU7ZIX/TtJ
         7Qiho6Cpu7XrzO3GDDSIUwuqPg+2NMIUsSPhME9AfQRhgqFKECLnYHmC/+VhRmZPce8n
         G/GqI/9tkv2oA7XbrRgbfaHhiGqLcT1DE6+maikf95Tr1ja1R75M3yMeK/4cdbuL3KG4
         flz+0PKWerr0X8adSI/D/mk3mKuZMY9AF2ZBdIdVTOKwnfKZUKym0tChDULyX5gzvreZ
         +bUQ==
X-Gm-Message-State: ACrzQf2UP6mxPUCMJ9L9Btyhmd0vWfiQ8m/cXV5EUo8f09RCDaXADfAN
        0dMkhUZHrkfq5ph7wytzcw/RvHeHVig9oUmn6oMlzcb04y4=
X-Google-Smtp-Source: AMsMyM60qI9gu8RmaNst5h6i1aNZiCvs5QQ01SvW0s/OAKkf6PgRyYiN/tTREijsqB225St4D8syelgxGH+yZAFvdv8=
X-Received: by 2002:a17:90b:1b0e:b0:202:c913:221f with SMTP id
 nu14-20020a17090b1b0e00b00202c913221fmr21943676pjb.211.1663946575688; Fri, 23
 Sep 2022 08:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <162fe40c387cd395d633729fa4f2b5245531514a.1663879752.git.pabeni@redhat.com>
 <CAKgT0Uc2qmKTeZMCTR3ZkibioxEwKHjKqLrnz-=cfSt+5TAv=g@mail.gmail.com> <efa64c44b1e53510f972954e4670b2d8ecde97eb.camel@redhat.com>
In-Reply-To: <efa64c44b1e53510f972954e4670b2d8ecde97eb.camel@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 23 Sep 2022 08:22:43 -0700
Message-ID: <CAKgT0Ud+U4NO+adYeUdegVbbS2EMaqTg2B-a0Z8Q2n9H7MaePg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: introduce and use a single page
 frag cache
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 12:41 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Thu, 2022-09-22 at 14:17 -0700, Alexander Duyck wrote:
> [...]
> > My suggestion earlier was to just make the 1k cache a page_frag_cache.
> > It will allow you to reuse the same structure members and a single
> > pointer to track them. Waste would be minimal since the only real
> > difference between the structures is about 8B for the structure, and
> > odds are the napi_alloc_cache allocation is being rounded up anyway.
> >
> > >         unsigned int skb_count;
> > >         void *skb_cache[NAPI_SKB_CACHE_SIZE];
> > >  };
> > > @@ -143,6 +202,23 @@ struct napi_alloc_cache {
> > >  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
> > >  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
> > >
> > > +/* Double check that napi_get_frags() allocates skbs with
> > > + * skb->head being backed by slab, not a page fragment.
> > > + * This is to make sure bug fixed in 3226b158e67c
> > > + * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > > + * does not accidentally come back.
> > > + */
> > > +void napi_get_frags_check(struct napi_struct *napi)
> > > +{
> > > +       struct sk_buff *skb;
> > > +
> > > +       local_bh_disable();
> > > +       skb = napi_get_frags(napi);
> > > +       WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
> > > +       napi_free_frags(napi);
> > > +       local_bh_enable();
> > > +}
> > > +
> > >  void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
> > >  {
> > >         struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> > > @@ -561,6 +637,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > >  {
> > >         struct napi_alloc_cache *nc;
> > >         struct sk_buff *skb;
> > > +       bool pfmemalloc;
> >
> > Rather than adding this I think you would be better off adding a
> > struct page_frag_cache pointer. I will reference it here as "pfc".
> >
> > >         void *data;
> > >
> > >         DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> > > @@ -568,8 +645,10 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > >
> > >         /* If requested length is either too small or too big,
> > >          * we use kmalloc() for skb->head allocation.
> > > +        * When the small frag allocator is available, prefer it over kmalloc
> > > +        * for small fragments
> > >          */
> > > -       if (len <= SKB_WITH_OVERHEAD(1024) ||
> > > +       if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
> > >             len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> > >             (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > >                 skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
> > > @@ -580,13 +659,30 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > >         }
> > >
> > >         nc = this_cpu_ptr(&napi_alloc_cache);
> > > -       len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > -       len = SKB_DATA_ALIGN(len);
> > >
> > >         if (sk_memalloc_socks())
> > >                 gfp_mask |= __GFP_MEMALLOC;
> > >
> > > -       data = page_frag_alloc(&nc->page, len, gfp_mask);
> > > +       if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
> >
> > Then here you would add a line that would be:
> > pfc = &nc->page_small;
> >
> > > +               /* we are artificially inflating the allocation size, but
> > > +                * that is not as bad as it may look like, as:
> > > +                * - 'len' less then GRO_MAX_HEAD makes little sense
> > > +                * - larger 'len' values lead to fragment size above 512 bytes
> > > +                *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
> > > +                * - kmalloc would use the kmalloc-1k slab for such values
> > > +                */
> > > +               len = SZ_1K;
> > > +
> > > +               data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
> > > +               pfmemalloc = nc->page_small.pfmemalloc;
> >
> > Instead of setting pfmemalloc you could just update the line below. In
> > addition you would just be passing pfc as the parameter.
> >
> > > +       } else {
> >
> > Likewise here you would have the line:
> > pfc = &nc->page;
>
> Probaly I was not clear in my previois email, sorry: before posting
> this version I tried locally exactly all the above, and the generated
> code with gcc 11.3.1 is a little bigger (a couple of instructions) than
> what this version produces (with gcc 11.3.1-2). It has the same number
> of conditionals and a slightly larger napi_alloc_cache.
>
> Additionally the suggested alternative needs more pre-processor
> conditionals to handle the !NAPI_HAS_SMALL_PAGE_FRAG case - avoiding
> adding a 2nd, unused in that case, page_frag_cache.
>
> [...]

Why would that be? You should still be using the pointer to the
page_frag_cache in the standard case. Like I was saying what you are
doing is essentially replacing the use of napi_alloc_cache with the
page_frag_cache, so for example with the existing setup all references
to "nc->page" would become "pfc->" so there shouldn't be any extra
unused variables in such a case since it would be used for both the
frag allocation and the pfmemalloc check.

One alternate way that occured to me to handle this would be to look
at possibly having napi_alloc_cache contain an array of
page_frag_cache structures. With that approach you could just size the
array and have it stick with a size of 1 in the case that small
doesn't exist, and support a size of 2 if it does. You could define
them via an enum so that the max would vary depending on if you add a
small frag cache or not. With that you could just bump the pointer
with a ++ so it goes from large to small and you wouldn't have any
warnings about items not existing in your structures, and the code
with the ++ could be kept from being called in the
!NAPI_HAS_SMALL_PAGE_FRAG case.

> >
> > > @@ -596,7 +692,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > >                 return NULL;
> > >         }
> > >
> > > -       if (nc->page.pfmemalloc)
> > > +       if (pfmemalloc)
> >
> > Instead of passing pfmemalloc you could just check pfc->pfmemalloc.
> > Alternatively I wonder if it wouldn't be faster to just set the value
> > directly based on frag_cache->pfmemalloc and avoid the conditional
> > heck entirely.
>
> Note that:
>
>         skb->pfmemalloc = pfmemalloc;
>
> avoids a branch but requires more instructions than the current code
> (verified with gcc). The gain looks doubtful?!? Additionally we have
> statement alike:
>
>         if (<pfmemalloc>)
>                 skb->pfmemalloc = 1;
>
> in other functions in skbuff.c - still fast-path - and would be better
> updating all the places together for consistency - if that is really
> considered an improvement. IMHO it should at least land in a different
> patch.

We cannot really use "skb->pfmemalloc = pfmemalloc" because one is a
bitfield and the other is a boolean value. I suspect the complexity
would be greatly reduced if we converted the pfmemalloc to a bitfield
similar to skb->pfmemalloc. It isn't important though. I was mostly
just speculating on possible future optimizations.

> I'll post a v3 with your updated email address, but I think the current
> code is the better option.

That's fine. Like I mentioned I am mostly just trying to think things
out and identify any possible gaps we may have missed. I will keep an
eye out for the next version.
