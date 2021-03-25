Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368EC34972A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCYQrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCYQrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:47:07 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BBBC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:47:07 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id x16so1507261qvk.3
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 09:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lykmu0sL2IE2rv4jZbeLXyhZ1F1JsRlETU5Bs7nyK5o=;
        b=BsGz30j1VHloTirswPHx0/iqWV8KvfY8K9xwN5SEBh7r+qhcAWYtuvNgZYS8YyEqS5
         s6y1ObPeB/JOuOFnrDGHRXxqWEmGXuyCgr7LogV1bbn0cEgIyg8PfbqhP0etBxq7i1Zs
         8afKnfczHEr0lWie+hiH0DY6aVfET4wuVv2BwYDIWAvmIT17MjXOlETzpPnEpIsWyJ79
         2FfTTyn+SmKh7rrP+PzeHEznSBiJhgsJJTgGZUyG2Nu02bVh+/hhK3TjinA0GIgwrH+W
         PJvtASb7gudzWE/WIIYUkE0vF66e5IMP/T6u0N2pnZGxaar0I8Iq5FWvw6V6aGgPyaKL
         qulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lykmu0sL2IE2rv4jZbeLXyhZ1F1JsRlETU5Bs7nyK5o=;
        b=XYqQ9q6wpv+n+4djMiq5hjemGJuWrEN36Orm+7auBThiLnCeoS/r7uSmQA+JxvMSTP
         AS3t9g8ks4zBN1kB/zEqAZ1sFIgUM/AXEFXuzs2Ck7D2KuJJeXxZ5VpyIYRjeQlphRnO
         3cNqZY2hTYXnMuWN8Rn6ibC6mSBCTeokEegrXn9e2FsM2NAE8GPV5WhFy/ARWgBKyuII
         pUHdsfIkK6cRnWENYhl+hjRglsxPuxwk8bCaJGtmYlVEYb6muUJUa6TfEc87UcBn0cib
         cEekJeWvUrNt/GyLjIgvF3lSTSoYCVJCTtSSErQxO9iJdFSAxWj8GxeKQDjDXFo9wkUX
         MZiA==
X-Gm-Message-State: AOAM533dOvru+V0N977BKmVyiFJ4tBq3aoDDbqq4VsHNoFI6nErao8MF
        U8RniDlhXD/HwbnmelayU6FQNQ==
X-Google-Smtp-Source: ABdhPJzqzs3cwWxaMZFEfvUPymuHcq983ghv8dspfemmYC9nSd0j6GAkwdSbZRJH23jjSbL8OVDE5w==
X-Received: by 2002:ad4:5887:: with SMTP id dz7mr9515403qvb.12.1616690826723;
        Thu, 25 Mar 2021 09:47:06 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:9738])
        by smtp.gmail.com with ESMTPSA id 8sm4382779qkc.32.2021.03.25.09.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:47:05 -0700 (PDT)
Date:   Thu, 25 Mar 2021 12:47:04 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Arjun Roy <arjunroy@google.com>,
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
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <YFy+iPiL1YbjjapV@cmpxchg.org>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
 <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
 <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
 <YFsA78FfzICrnFf7@dhcp22.suse.cz>
 <YFut+cZhsJec7Pud@cmpxchg.org>
 <CAOFY-A0Y0ye74bnpcWsKOPZMJSrFW8mJxVJrpwiy2dcGgUJ5Tw@mail.gmail.com>
 <YFxRpKfwQwobt7IK@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFxRpKfwQwobt7IK@dhcp22.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 10:02:28AM +0100, Michal Hocko wrote:
> On Wed 24-03-21 15:49:15, Arjun Roy wrote:
> > On Wed, Mar 24, 2021 at 2:24 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > >
> > > On Wed, Mar 24, 2021 at 10:12:46AM +0100, Michal Hocko wrote:
> > > > On Tue 23-03-21 11:47:54, Arjun Roy wrote:
> > > > > On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko@suse.com> wrote:
> > > > > >
> > > > > > On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> > > > > > [...]
> > > > > > > Here is an idea of how it could work:
> > > > > > >
> > > > > > > struct page already has
> > > > > > >
> > > > > > >                 struct {        /* page_pool used by netstack */
> > > > > > >                         /**
> > > > > > >                          * @dma_addr: might require a 64-bit value even on
> > > > > > >                          * 32-bit architectures.
> > > > > > >                          */
> > > > > > >                         dma_addr_t dma_addr;
> > > > > > >                 };
> > > > > > >
> > > > > > > and as you can see from its union neighbors, there is quite a bit more
> > > > > > > room to store private data necessary for the page pool.
> > > > > > >
> > > > > > > When a page's refcount hits zero and it's a networking page, we can
> > > > > > > feed it back to the page pool instead of the page allocator.
> > > > > > >
> > > > > > > From a first look, we should be able to use the PG_owner_priv_1 page
> > > > > > > flag for network pages (see how this flag is overloaded, we can add a
> > > > > > > PG_network alias). With this, we can identify the page in __put_page()
> > > > > > > and __release_page(). These functions are already aware of different
> > > > > > > types of pages and do their respective cleanup handling. We can
> > > > > > > similarly make network a first-class citizen and hand pages back to
> > > > > > > the network allocator from in there.
> > > > > >
> > > > > > For compound pages we have a concept of destructors. Maybe we can extend
> > > > > > that for order-0 pages as well. The struct page is heavily packed and
> > > > > > compound_dtor shares the storage without other metadata
> > > > > >                                         int    pages;    /*    16     4 */
> > > > > >                         unsigned char compound_dtor;     /*    16     1 */
> > > > > >                         atomic_t   hpage_pinned_refcount; /*    16     4 */
> > > > > >                         pgtable_t  pmd_huge_pte;         /*    16     8 */
> > > > > >                         void *     zone_device_data;     /*    16     8 */
> > > > > >
> > > > > > But none of those should really require to be valid when a page is freed
> > > > > > unless I am missing something. It would really require to check their
> > > > > > users whether they can leave the state behind. But if we can establish a
> > > > > > contract that compound_dtor can be always valid when a page is freed
> > > > > > this would be really a nice and useful abstraction because you wouldn't
> > > > > > have to care about the specific type of page.
> > >
> > > Yeah technically nobody should leave these fields behind, but it
> > > sounds pretty awkward to manage an overloaded destructor with a
> > > refcounted object:
> > >
> > > Either every put would have to check ref==1 before to see if it will
> > > be the one to free the page, and then set up the destructor before
> > > putting the final ref. But that means we can't support lockless
> > > tryget() schemes like we have in the page cache with a destructor.
> 
> I do not follow the ref==1 part. I mean to use the hugetlb model where
> the destructore is configured for the whole lifetime until the page is
> freed back to the allocator (see below).

That only works if the destructor field doesn't overlap with a member
the page type itself doesn't want to use. Page types that do want to
use it would need to keep that field exclusive.

We couldn't use it for LRU pages e.g. because it overlaps with the
lru.next pointer. But if we bother with a 'generic' destructor for
order-0 pages the LRU pages would actually be a prime candidate for a
destructor: lru removal, memcg uncharging, page waiter cleanup...

The field is also kind of wasteful. There are only a few different
dtors but it occupies an entire byte. Page types don't necessarily
have other bytes they could pair it with, so it might often take up a
whole word. This is all fine with compound pages because we have all
this space in the tail pages. It's not good in order-0 pages.

So again, yes it would be nice to have generic destructors, but I just
don't see how it's practical.

Making network pages first-class objects instead makes a lot more
sense to me for the time being. It's not like it's some small random
driver usecase - it's the network stack!

> > Ah, I think I see what you were getting at with your prior email - at
> > first I thought your suggestion was that, since the driver may have
> > its own refcount, every put would need to check ref == 1 and call into
> > the driver if need be.
> > 
> > Instead, and correct me if I'm wrong, it seems like what you're advocating is:
> > 1) The (opted in) driver no longer hangs onto the ref,
> > 2) Now refcount can go all the way to 0,
> > 3) And when it does, due to the special destructor this page has, it
> > goes back to the driver, rather than the system?

Yes, correct.

> > > > If you are going to claim a page flag then it would be much better to
> > > > have it more generic. Flags are really scarce and if all you care about
> > > > is PageHasDestructor() and provide one via page->dtor then the similar
> > > > mechanism can be reused by somebody else. Or does anything prevent that?
> > >
> > > I was suggesting to alias PG_owner_priv_1, which currently isn't used
> > > on network pages. We don't need to allocate a brandnew page flag.
> > >
> > 
> > Just to be certain, is there any danger of having a page, that would
> > not be a network driver page originally, being inside __put_page(),
> > such that PG_owner_priv_1 is set (but with one of its other overloaded
> > meanings)?
> 
> Yeah this is a real question. And from what Johannes is saying this
> might pose some problem for this specific flags. I still need to check
> all the users to be certain. One thing is clear though.  PG_owner_priv_1
> is not a part of PAGE_FLAGS_CHECK_AT_FREE so it is not checked when a
> page is freed so it is possible that the flag is left behind when
> somebody does final put_page which makes things harder.

The swapcache holds a reference, so PG_swapcache is never set on the
final put.

PG_checked refers to the data stored in file pages. It's possible not
all filesystems clear it properly on truncate right now, but they
don't need it once the data itself has become invalid. I double
checked with Chris Mason.

PG_pinned pages are Xen pagetables, they aren't actually
refcounted. PG_xen_remapped pages are dma-remaps and aren't refcounted
either. PG_foreign pages appear refcounted, but AFAICS the foreign map
state is against a table that holds refs, so can't be set on put.

I'll audit the PageChecked sites more closely and send a patch to
tighten it up and add PG_owner_priv_1 to PAGE_FLAGS_CHECK_AT_FREE.
That would be better anyway.

> But that would be the case even when the flag is used for network
> specific handling because you cannot tell it from other potential users
> who are outside of networking...

For non-refcounted pages, we'll catch it in the page allocator.

For refcounted pages a bug is a bit trickier, but I don't think worse
than the baseline risk of aliased page flags in the first place, and
likely the network destructor would crash on a non-network page
(assuming there is a driver-specific callback/ops struct in there).
