Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3572A348395
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbhCXVY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbhCXVYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:24:12 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD15C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:24:12 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id y5so18079710qkl.9
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CUd0B1oE8UgjwZS/vVWXtycCqy3Z4dx7RtFiDbPwnxk=;
        b=dbdTgeyCSqFo3yOGJ76gxQ1MbGnyiOl1auHv4991smV1UjVeNvf/EWpQZAUT06hMbh
         fviRi4ubTSutg+fJ8qUIb7nt1Ooxdtd4d4OiOoAmWjbOFUxf9ZcoS6cEgRcdhetuzqy4
         P3D8NeWOFUTQq5gw+DUGkMO0L6jrrd8pi+WLcFpqlvmYjrgk1mf/xDqUxiNn+mTr1T53
         WZ/8QdvoCMP57HFJpuY5In0IPlzv9E5V29+zA+257wug93KmU5ag+lxVHNVOtIIaFZbH
         iHOslI2xYTIazSjwTxlSPPIN+6fba2t7iBA90mUKLyANKtzbvNniP+4RorV3bHA3qkdA
         qvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CUd0B1oE8UgjwZS/vVWXtycCqy3Z4dx7RtFiDbPwnxk=;
        b=Qm8GA0gu0a8SWQ6fsXquW5YgMKZiRKffF0xJBSJYX9/S+qoLfQKeeJO5tgT3ovv2xr
         zmdgF5ZpqO1GC7KG5kblsmXZatUyEOI2Qcbngw8A9woC7DRPYp3zvSe+pbJgd73eN2f2
         8/FULFX8RhjeblcuMQDv+wEuZSaKUXGbhYHs/dFcp/RhkdZV9w/6i1JsJTTcPbxsqjlP
         RH/f/vUT4EB3lrhMqS7ARnJC+aJmMRIV9WVWEFdfILfqzxq6cyBflmS7yEmbeGjwr9gI
         n0eDiBMhm7mhJbM/dKkbjLQuBFPLurCD+FBvF3AZS8xwu6oa/7FV9iTES+bT51FFvqTU
         YbiQ==
X-Gm-Message-State: AOAM530mCq211zezCiqKNf2amPISbiZsXp4pwZIhVCmSdstSB9abs2L1
        0RLQI33yVpR5sD7Wu3TDKGJPdA==
X-Google-Smtp-Source: ABdhPJyuVXA96uvFC0rylaph6WLUCLkqLG17wsg0lww8sgrQ3PZVuyBqDhrrYqkr0wTzgjnd+W8q9g==
X-Received: by 2002:a05:620a:5b3:: with SMTP id q19mr5317185qkq.98.1616621051819;
        Wed, 24 Mar 2021 14:24:11 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:f4a2])
        by smtp.gmail.com with ESMTPSA id d14sm2313793qtr.55.2021.03.24.14.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:24:11 -0700 (PDT)
Date:   Wed, 24 Mar 2021 17:24:09 -0400
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
Message-ID: <YFut+cZhsJec7Pud@cmpxchg.org>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
 <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
 <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
 <YFsA78FfzICrnFf7@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFsA78FfzICrnFf7@dhcp22.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 10:12:46AM +0100, Michal Hocko wrote:
> On Tue 23-03-21 11:47:54, Arjun Roy wrote:
> > On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> > > [...]
> > > > Here is an idea of how it could work:
> > > >
> > > > struct page already has
> > > >
> > > >                 struct {        /* page_pool used by netstack */
> > > >                         /**
> > > >                          * @dma_addr: might require a 64-bit value even on
> > > >                          * 32-bit architectures.
> > > >                          */
> > > >                         dma_addr_t dma_addr;
> > > >                 };
> > > >
> > > > and as you can see from its union neighbors, there is quite a bit more
> > > > room to store private data necessary for the page pool.
> > > >
> > > > When a page's refcount hits zero and it's a networking page, we can
> > > > feed it back to the page pool instead of the page allocator.
> > > >
> > > > From a first look, we should be able to use the PG_owner_priv_1 page
> > > > flag for network pages (see how this flag is overloaded, we can add a
> > > > PG_network alias). With this, we can identify the page in __put_page()
> > > > and __release_page(). These functions are already aware of different
> > > > types of pages and do their respective cleanup handling. We can
> > > > similarly make network a first-class citizen and hand pages back to
> > > > the network allocator from in there.
> > >
> > > For compound pages we have a concept of destructors. Maybe we can extend
> > > that for order-0 pages as well. The struct page is heavily packed and
> > > compound_dtor shares the storage without other metadata
> > >                                         int    pages;    /*    16     4 */
> > >                         unsigned char compound_dtor;     /*    16     1 */
> > >                         atomic_t   hpage_pinned_refcount; /*    16     4 */
> > >                         pgtable_t  pmd_huge_pte;         /*    16     8 */
> > >                         void *     zone_device_data;     /*    16     8 */
> > >
> > > But none of those should really require to be valid when a page is freed
> > > unless I am missing something. It would really require to check their
> > > users whether they can leave the state behind. But if we can establish a
> > > contract that compound_dtor can be always valid when a page is freed
> > > this would be really a nice and useful abstraction because you wouldn't
> > > have to care about the specific type of page.

Yeah technically nobody should leave these fields behind, but it
sounds pretty awkward to manage an overloaded destructor with a
refcounted object:

Either every put would have to check ref==1 before to see if it will
be the one to free the page, and then set up the destructor before
putting the final ref. But that means we can't support lockless
tryget() schemes like we have in the page cache with a destructor.

Or you'd have to set up the destructor every time an overloaded field
reverts to its null state, e.g. hpage_pinned_refcount goes back to 0.

Neither of those sound practical to me.

> > > But maybe I am just overlooking the real complexity there.
> > > --
> > 
> > For now probably the easiest way is to have network pages be first
> > class with a specific flag as previously discussed and have concrete
> > handling for it, rather than trying to establish the contract across
> > page types.
> 
> If you are going to claim a page flag then it would be much better to
> have it more generic. Flags are really scarce and if all you care about
> is PageHasDestructor() and provide one via page->dtor then the similar
> mechanism can be reused by somebody else. Or does anything prevent that?

I was suggesting to alias PG_owner_priv_1, which currently isn't used
on network pages. We don't need to allocate a brandnew page flag.

I agree that a generic destructor for order-0 pages would be nice, but
due to the decentralized nature of refcounting the only way I think it
would work in practice is by adding a new field to struct page that is
not in conflict with any existing ones.

Comparably, creating a network type page consumes no additional space.
