Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0635D346811
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhCWSsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhCWSsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:48:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07B1C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 11:48:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so1469754pjb.0
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 11:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W0hZGL9ovQy+jWSfLjuO4yiUfJKwclwtM7TKVF346ck=;
        b=ZV0TRepGN/bTRrghylVvoSE2ass/5JiPwc7sWV/wAQVPb1uoehbKFxYd4S32T2g/0y
         bi8QRSGC4kiddQG52GuTZgZjLEO4L9GEbm0s0/mkY8Zy6+prXQuZMGBVscsMwTRldNqu
         lyWIYuzOG0oWrteGqrjaL6MJtGAJiNp/0XVN+6Of7kEDrx+5blNdgrFJEx40IIDQ0W+z
         cmAArxmrCm2xFu8htn/jaTt9xHXJKScLEwYLKM9GS7/7wd/U7vR/RgVPpaGOSmapqvr1
         +6LH315iekrNT5vGiRN5yU6KXXK5v2ezMT+076k3qWVhPbW0Geaur0UYFWCw4Pb+1DX3
         6Vtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W0hZGL9ovQy+jWSfLjuO4yiUfJKwclwtM7TKVF346ck=;
        b=bn9Wk4H169coE/qqmXJEA+/6fWWLAHmtkmgQ9NSzUqOXG5fRa8ibmqSKDPblqDOYoR
         XAYOf0Oc+R4FDZFCCGBrO80AH6rKhblTwgI2YmXxZvyODpuo2Ir07tDo/JgbmUzGro/i
         Joed61QgPxfPxFpPLYc346fl5IruiC16GLqMBNqek2Rl0LjXrrEIlbDN4qGsPwWBRiIn
         JXqK6rDeKS56tSN/dsDu1ljVJjiHHFnNzH2/cD+aW2hZCqbefHi1eVNPLVr0R6qRYGn0
         CsG0SYCoouAtbWfieeK/BiMFbZMWcgi09ucp79QHwjDxKCeZCHiELruDcX/sbOtjkKUD
         pkMQ==
X-Gm-Message-State: AOAM533Xe6gTjWNES7+/A537rmhX/cFMju/y6Ql5a5eL0mBLh59bPsZm
        A0ltv/ifx62NcgWne654b6oRRihKk2Aa1FHwu2/Jnw==
X-Google-Smtp-Source: ABdhPJy58JffI7SATii7n67BekyxmpIkXD68FhgTDdhjmi8lNU5f3dTxTfW+xxhQJKHw4a/ukBsfSA8VFunC//JWCLg=
X-Received: by 2002:a17:90b:947:: with SMTP id dw7mr5892929pjb.178.1616525286054;
 Tue, 23 Mar 2021 11:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org> <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org> <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
In-Reply-To: <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 23 Mar 2021 11:47:54 -0700
Message-ID: <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
To:     Michal Hocko <mhocko@suse.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> [...]
> > Here is an idea of how it could work:
> >
> > struct page already has
> >
> >                 struct {        /* page_pool used by netstack */
> >                         /**
> >                          * @dma_addr: might require a 64-bit value even on
> >                          * 32-bit architectures.
> >                          */
> >                         dma_addr_t dma_addr;
> >                 };
> >
> > and as you can see from its union neighbors, there is quite a bit more
> > room to store private data necessary for the page pool.
> >
> > When a page's refcount hits zero and it's a networking page, we can
> > feed it back to the page pool instead of the page allocator.
> >
> > From a first look, we should be able to use the PG_owner_priv_1 page
> > flag for network pages (see how this flag is overloaded, we can add a
> > PG_network alias). With this, we can identify the page in __put_page()
> > and __release_page(). These functions are already aware of different
> > types of pages and do their respective cleanup handling. We can
> > similarly make network a first-class citizen and hand pages back to
> > the network allocator from in there.
>
> For compound pages we have a concept of destructors. Maybe we can extend
> that for order-0 pages as well. The struct page is heavily packed and
> compound_dtor shares the storage without other metadata
>                                         int    pages;    /*    16     4 */
>                         unsigned char compound_dtor;     /*    16     1 */
>                         atomic_t   hpage_pinned_refcount; /*    16     4 */
>                         pgtable_t  pmd_huge_pte;         /*    16     8 */
>                         void *     zone_device_data;     /*    16     8 */
>
> But none of those should really require to be valid when a page is freed
> unless I am missing something. It would really require to check their
> users whether they can leave the state behind. But if we can establish a
> contract that compound_dtor can be always valid when a page is freed
> this would be really a nice and useful abstraction because you wouldn't
> have to care about the specific type of page.
>
> But maybe I am just overlooking the real complexity there.
> --

For now probably the easiest way is to have network pages be first
class with a specific flag as previously discussed and have concrete
handling for it, rather than trying to establish the contract across
page types.

Thanks,
-Arjun

> Michal Hocko
> SUSE Labs
