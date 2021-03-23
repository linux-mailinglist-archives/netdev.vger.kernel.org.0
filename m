Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0483467EB
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhCWSmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhCWSmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:42:17 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C19C061764
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 11:42:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so12593880pjh.1
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 11:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mD61Ls6vzVvQMSeaaF56QK5c7Jjn0dunNUYdNfL29o0=;
        b=Yxm1As2H3pEmc1Sg12rZKhMnJyeu07K+JLnvdk3QBaxxYlJEzDmemZrDF0Ip283m2n
         KvVcd/fnExUfAMVMlmsFS66ObnPWv6O00ZWkyipAsvnTig4pl3MO9WFA5Ors5hmGE2+E
         ITg2Vq10vzklKs4BrsWhXCdPmS6fEjxhlMCCo2GQantmnqtu+FevhJFfJG9IGcDfEmIc
         eBa34K/i+gPMCtu40dgX+BI7B/YgufwBp+AZzEepmWuDvlPwyqr8MMtabVl1weobp4T4
         1QkNtv0dJIA+oSu1BPQcgGO/WR+0tCg22lXERtZFxhTmTZH92pb3+dpaCtHTRebJ6M1z
         2dPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mD61Ls6vzVvQMSeaaF56QK5c7Jjn0dunNUYdNfL29o0=;
        b=a/t9N3/6H3BjwCaFxxjtqgFpyDTiLAFJuKEYAmT5sbJgsnVfKSg+E1TvhILZznk1H+
         oLN8dyLOOWaNyY5Jp+UJTy1OXKIUhBNjVOpCRmA1SNO2QfqH0AHj6btOH9YiONyCE4Ds
         +VDBRJASrE2EQzPvn8c6rwWXkq08FOBK7uRz441eX5JBktlZhxsukZF7mlK2ITQ/fY9t
         I+omGrrpqGVzKjtZLvt8tF9wbcs9uN3wZf9o/gkmEU+QZPooF0UjqrtImYOqozeIVJPq
         0Y/L482DSBoTje8PFbh82JOI3/Xf4DmBMUDk7CPz+KkgUB6G7/ryiV6CCmw1H6Nz9x+T
         2+qQ==
X-Gm-Message-State: AOAM531h301vUWjtyuWCcK1hN+MZM7RkXFPa+eh3nTFTpae4ehWAUJm4
        4RRHWzhYXkTkJRsq7fzCfZuHfeEiQLzOmwlPBbFpTA==
X-Google-Smtp-Source: ABdhPJygvpHW1+nS6pqN04XtniIKRXltnxLG60Gv6sngXjpNYOucsvIhxX3LDXIdlIDxgmV7t00gIDNVyweZG0ihoMQ=
X-Received: by 2002:a17:90a:ce0d:: with SMTP id f13mr5731015pju.85.1616524936259;
 Tue, 23 Mar 2021 11:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org> <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org> <CAOFY-A17g-Aq_TsSX8=mD7ZaSAqx3gzUuCJT8K0xwrSuYdP4Kw@mail.gmail.com>
 <YFoe8BO0JsbXTHHF@cmpxchg.org>
In-Reply-To: <YFoe8BO0JsbXTHHF@cmpxchg.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 23 Mar 2021 11:42:05 -0700
Message-ID: <CAOFY-A2dfWS91b10R9Pu-5T-uT2qF9h9Lm8GaJfV9shfjP4Wbg@mail.gmail.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 10:01 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Mar 22, 2021 at 02:35:11PM -0700, Arjun Roy wrote:
> > To make sure we're on the same page, then, here's a tentative
> > mechanism - I'd rather get buy in before spending too much time on
> > something that wouldn't pass muster afterwards.
> >
> > A) An opt-in mechanism, that a driver needs to explicitly support, in
> > order to get properly accounted receive zerocopy.
>
> Yep, opt-in makes sense. That allows piece-by-piece conversion and
> avoids us having to have a flag day.
>
> > B) Failure to opt-in (e.g. unchanged old driver) can either lead to
> > unaccounted zerocopy (ie. existing behaviour) or, optionally,
> > effectively disabled zerocopy (ie. any call to zerocopy will return
> > something like EINVAL) (perhaps controlled via some sysctl, which
> > either lets zerocopy through or not with/without accounting).
>
> I'd suggest letting it fail gracefully (i.e. no -EINVAL) to not
> disturb existing/working setups during the transition period. But the
> exact policy is easy to change later on if we change our minds on it.
>
> > The proposed mechanism would involve:
> > 1) Some way of marking a page as being allocated by a driver that has
> > decided to opt into this mechanism. Say, a page flag, or a memcg flag.
>
> Right. I would stress it should not be a memcg flag or any direct
> channel from the network to memcg, as this would limit its usefulness
> while having the same maintenance overhead.
>
> It should make the network page a first class MM citizen - like an LRU
> page or a slab page - which can be accounted and introspected as such,
> including from the memcg side.
>
> So definitely a page flag.

Works for me.

>
> > 2) A callback provided by the driver, that takes a struct page*, and
> > returns a boolean. The value of the boolean being true indicates that
> > any and all refs on the page are held by the driver. False means there
> > exists at least one reference that is not held by the driver.
>
> I was thinking the PageNetwork flag would cover this, but maybe I'm
> missing something?
>

The main reason for a driver callback is to handle whatever
driver-specific behaviour needs to be handled (ie. while a driver may
use code from net/core/page_pool.c, it also may roll its own arbitrary
behaviour and data structures). And because it's not necessarily the
case that a driver would take exactly 1 ref of its own on the page.


> > 3) A branch in put_page() that, for pages marked thus, will consult
> > the driver callback and if it returns true, will uncharge the memcg
> > for the page.
>
> The way I picture it, put_page() (and release_pages) should do this:
>
> void __put_page(struct page *page)
> {
>         if (is_zone_device_page(page)) {
>                 put_dev_pagemap(page->pgmap);
>
>                 /*
>                  * The page belongs to the device that created pgmap. Do
>                  * not return it to page allocator.
>                  */
>                 return;
>         }
> +
> +       if (PageNetwork(page)) {
> +               put_page_network(page);
> +               /* Page belongs to the network stack, not the page allocator */
> +               return;
> +       }
>
>         if (unlikely(PageCompound(page)))
>                 __put_compound_page(page);
>         else
>                 __put_single_page(page);
> }
>
> where put_page_network() is the network-side callback that uncharges
> the page.
>
> (..and later can be extended to do all kinds of things when informed
> that the page has been freed: update statistics (mod_page_state), put
> it on a private network freelist, or ClearPageNetwork() and give it
> back to the page allocator etc.
>

Yes, this is more or less what I had in mind, though
put_page_network() would also need to avail itself of the callback
mentioned previously.


> But for starters it can set_page_count(page, 1) after the uncharge to
> retain the current silent recycling behavior.)
>

This would be one example of where the driver could conceivably have
>1 ref for whatever reason
(https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mellanox/mlx4/en_rx.c#L495)
where it looks like it could take 2 refs on a page, perhaps storing 2
x 1500B packets on a single 4KB page.




> > The anonymous struct you defined above is part of a union that I think
> > normally is one qword in length (well, could be more depending on the
> > typedefs I saw there) and I think that can be co-opted to provide the
> > driver callback - though, it might require growing the struct by one
> > more qword since there may be drivers like mlx5 that are already using
> > the field already in there  for dma_addr.
>
> The page cache / anonymous struct it's shared with is 5 words (double
> linked list pointers, mapping, index, private), and the network struct
> is currently one word, so you can add 4 words to a PageNetwork() page
> without increasing the size of struct page. That should be plenty of
> space to store auxiliary data for drivers, right?
>

Ah, I think I was looking more narrowly at an older version of the
struct. The new one is much easier to parse. :)

4 words should be plenty, I think.

> > Anyways, the callback could then be used by the driver to handle the
> > other accounting quirks you mentioned, without needing to scan the
> > full pool.
>
> Right.
>
> > Of course there are corner cases and such to properly account for, but
> > I just wanted to provide a really rough sketch to see if this
> > (assuming it were properly implemented) was what you had in mind. If
> > so I can put together a v3 patch.
>
> Yeah, makes perfect sense. We can keep iterating like this any time
> you feel you accumulate too many open questions. Not just for MM but
> also for the networking folks - although I suspect that the first step
> would be mostly about the MM infrastructure, and I'm not sure how much
> they care about the internals there ;)
>
> > Per my response to Andrew earlier, this would make it even more
> > confusing whether this is to be applied against net-next or mm trees.
> > But that's a bridge to cross when we get to it.
>
> The mm tree includes -next, so it should be a safe development target
> for the time being.
>
> I would then decide it based on how many changes your patch interacts
> with on either side. Changes to struct page and the put path are not
> very frequent, so I suspect it'll be easy to rebase to net-next and
> route everything through there. And if there are heavy changes on both
> sides, the -mm tree is the better route anyway.
>
> Does that sound reasonable?

This sounds good to me.

To summarize then, it seems to me that we're on the same page now.
I'll put together a tentative v3 such that:
1. It uses pre-charging, as previously discussed.
2. It uses a page flag to delineate pages of a certain networking sort
(ie. this mechanism).
3. It avails itself of up to 4 words of data inside struct page,
inside the networking specific struct.
4. And it sets up this opt-in lifecycle notification for drivers that
choose to use it, falling back to existing behaviour without.

Thanks,
-Arjun
