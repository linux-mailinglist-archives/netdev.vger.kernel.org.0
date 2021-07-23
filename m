Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C93D3D2D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhGWP1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhGWP1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:27:42 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A59C061575;
        Fri, 23 Jul 2021 09:08:14 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h10so2371995edv.8;
        Fri, 23 Jul 2021 09:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KQvEte8gv6LCleVWT8quDLkmhHOJ0Qgryb7ud4ir0cY=;
        b=lOX4cQxy8AwZlErxzvlPPBxOdm5976BEEbsvblBhP95rDLK2ILXLWqmWYDVf1kb43C
         gz2B5GUxW1mpKWvHR5Ahe7f2jp94l3Bql+26+/5vce5hkEwH+rE/0QhMJ/tHvedbpmtg
         WnNM7BHIvh2ZzGNZ/5/re51AQxz+zNetSNTRJc2wlcUS+bVLWkRqE1CFdFbP64NvqQyH
         pY8J4vM4sfkIG1pvGGqH9uzdKq+V/nTzLnx2vfOtepllhHt90keqyNPUaayuGKhKf2+S
         Oce9jxgyQO4TSK4US9dX69t1ZS6KDw1r9R8M+/8ZjMs64VDjYlbi/z/DRT4zYHb0hbee
         jLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KQvEte8gv6LCleVWT8quDLkmhHOJ0Qgryb7ud4ir0cY=;
        b=B4+kLM5aHKY3GqkuDtJkJqZa3F+lQDmlms2xopFhC7bQyteTs0+tWwnXqcbEjMQwGU
         uPO/j8WiQcDGqrDU6C42btQuoyioG4A/yuWKYIaiGc9WHixn8KFlh9qWyjrSzGmjbudA
         tkmHSVmdcRqojzaJ/4AvwePNJiLSPK3QEy6vbSMtKlwC3i7V9lU/yLcnKiaagfVtmtc9
         WX8v7YKk+usnS13MJjlhiU8gwMoPb2HLlX6r6PjuvTdkU3V8YVuCnGIVo0ONp/BklZYS
         k1111d0K8bGAYbCa92LvZQszwq+AD6BXb/lMFUnpWTm+tuoACzEKNkHzsERhNFUGE18Y
         A8AA==
X-Gm-Message-State: AOAM533sg/NONMAVSlqYwgipmWWFedj1qXrw86ySDPBaIEiVfVDpdPWC
        UJXK1ZnMl9myfgi/RI+r/8PIdJr8lrCYY+qGL7g=
X-Google-Smtp-Source: ABdhPJyRq4ir6W+M+5SxtEzpj0idJh5FGX3l2tN5O62X5VYq3u2LYxPl4w06VaGvr2Uy0x0CpFvIfsDNJzWDRuKHIVY=
X-Received: by 2002:aa7:c1cc:: with SMTP id d12mr6520874edp.282.1627056492282;
 Fri, 23 Jul 2021 09:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
 <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com> <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
 <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com> <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
 <41283c5f-2f58-7fa7-e8fe-a91207a57353@huawei.com>
In-Reply-To: <41283c5f-2f58-7fa7-e8fe-a91207a57353@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 23 Jul 2021 09:08:00 -0700
Message-ID: <CAKgT0Ud+PRzz7mgX1dru1=i3TDiaGOoyhg7vp6cz+3NzVFZf+A@mail.gmail.com>
Subject: Re: [PATCH rfc v6 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 4:12 AM Yunsheng Lin <linyunsheng@huawei.com> wrote=
:
>
> On 2021/7/22 23:18, Alexander Duyck wrote:
> >>>
> >>>> You are right that that may cover up the reference count errors. How=
 about
> >>>> something like below:
> >>>>
> >>>> static inline long page_pool_atomic_sub_frag_count_return(struct pag=
e *page,
> >>>>                                                           long nr)
> >>>> {
> >>>> #ifdef CONFIG_DEBUG_PAGE_REF
> >>>>         long ret =3D atomic_long_sub_return(nr, &page->pp_frag_count=
);
> >>>>
> >>>>         WARN_ON(ret < 0);
> >>>>
> >>>>         return ret;
> >>>> #else
> >>>>         if (atomic_long_read(&page->pp_frag_count) =3D=3D nr)
> >>>>                 return 0;
> >>>>
> >>>>         return atomic_long_sub_return(nr, &page->pp_frag_count);
> >>>> #end
> >>>> }
> >>>>
> >>>> Or any better suggestion?
> >>>
> >>> So the one thing I might change would be to make it so that you only
> >>> do the atomic_long_read if nr is a constant via __builtin_constant_p.
> >>> That way you would be performing the comparison in
> >>> __page_pool_put_page and in the cases of freeing or draining the
> >>> page_frags you would be using the atomic_long_sub_return which should
> >>> be paths where you would not expect it to match or that are slowpath
> >>> anyway.
> >>>
> >>> Also I would keep the WARN_ON in both paths just to be on the safe si=
de.
> >>
> >> If I understand it correctly, we should change it as below, right?
> >>
> >> static inline long page_pool_atomic_sub_frag_count_return(struct page =
*page,
> >>                                                           long nr)
> >> {
> >>         long ret;
> >>
> >>         /* As suggested by Alexander, atomic_long_read() may cover up =
the
> >>          * reference count errors, so avoid calling atomic_long_read()=
 in
> >>          * the cases of freeing or draining the page_frags, where we w=
ould
> >>          * not expect it to match or that are slowpath anyway.
> >>          */
> >>         if (__builtin_constant_p(nr) &&
> >>             atomic_long_read(&page->pp_frag_count) =3D=3D nr)
> >>                 return 0;
> >>
> >>         ret =3D atomic_long_sub_return(nr, &page->pp_frag_count);
> >>         WARN_ON(ret < 0);
> >>         return ret;
> >> }
> >
> > Yes, that is what I had in mind.
> >
> > One thought I had for a future optimization is that we could look at
> > reducing the count by 1 so that we could essentially combine the
> > non-frag and frag cases.Then instead of testing for 1 we would test
> > for 0 at thee start of the function and test for < 0 to decide if we
> > want to free it or not instead of testing for 0. With that we can
> > essentially reduce the calls to the WARN_ON since we should only have
> > one case where we actually return a value < 0, and we can then check
> > to see if we overshot -1 which would be the WARN_ON case.
> >
> > With that a value of 0 instead of 1 would indicate page frag is not in
> > use for the page *AND/OR* that the page has reached the state where
> > there are no other frags present so the page can be recycled. In
> > effect it would allow us to mix page frags and no frags within the
> > same pool. The added bonus would be we could get rid of the check for
> > PP_FLAG_PAGE_FRAG flag check in the __page_pool_put_page function and
> > replace it with a check for PAGE_POOL_DMA_USE_PP_FRAG_COUNT since we
> > cannot read frag_count in that case.
>
> Let's leave it for a future optimization.
> I am not sure if there is use case to support both frag page and non-frag
> page for the same page pool. If there is, maybe we can use "page->pp_frag=
_count
> > 0" to indicate that the page is frag page, and "page->pp_frag_count =3D=
=3D 0"
> to indicate that the page is non-frag page, so that we can support frag p=
age and
> non-frag page for the same page pool instead of disabling non-frag page s=
upport
> when PP_FLAG_PAGE_FRAG flag is set, which might be conflit with the above
> optimization?

As far as use case I can see a number of potential uses. For example
in the case of drivers that do something like a header/data split I
could see potentially having the header pages be frags while the data
pages being 4K blocks. Basically the big optimization of the count =3D=3D
1/0/nr case is that you aren't increasing/decreasing the count and it
is immediately being recycled/reused. So in such a case being able to
add frag count some pages, and not to others would likely be quite
useful.

Basically by shifting the pool values by 1 you can have both in the
same pool with little issue. However the big change is that instead of
testing for count =3D nr it would end up being pp_frag_count =3D nr - 1.
So in the case of the standard page pool pages being freed or the last
frag you would be looking at pp_frag_count =3D 0. In addition we can
mask the WARN_ON overhead as you would be using -1 as the point to
free so you would only have to perform the WARN_ON check for the last
frag instead of every frag.

> Also, I am prototyping the tx recycling based on page pool in order to se=
e
> if there is any value supporting the tx recycling.

Just to clarify here when you say Tx recycling you are talking about
socket to netdev correct? Just want to be certain since the netdev to
netdev case should already have recycling for page pool pages as long
as it follows a 1<->1 path.

> As the busypoll has enable the one-to-one relation between NAPI and sock,
> and there is one-to-one relation between NAPI and page pool, perhaps it m=
ake
> senses that we use page pool to recycle the tx page too?
>
> There are possibly below problems when doing that as I am aware of now:
> 1. busypoll is for rx, and tx may not be using the same queue as rx even =
if
>    there are *technically* the same flow=EF=BC=8C so I am not sure it is =
ok to use
>    busypoll infrastructure to get the page pool ptr for a specific sock.
>
> 2. There may be multi socks using the same page pool ptr to allocate page=
 for
>    multi flow, so we can not assume the same NAPI polling protection as r=
x,
>    which might mean we can only use the recyclable page from pool->ring u=
nder the
>    r->consumer_lock protection.
>
> 3. Right now tcp_sendmsg_locked() use sk_page_frag_refill() to refill the=
 page
>    frag for tcp xmit, when implementing a similar sk_page_pool_frag_refil=
l()
>    based on page pool, I found that tcp coalesce in tcp_mtu_probe() and
>    tcp fragment in tso_fragment() might mess with the page_ref_count dire=
ctly.
>
> As the above the problem I am aware of(I believe there are other problems=
 I am not
> aware of yet), I am not sure if the tcp tx page recycling based on page p=
ool is
> doable or not, I would like to hear about your opinion about tcp tx recyc=
ling support
> based on page pool first, in case it is a dead end to support that.

I'm honestly not sure there is much there to gain. Last I knew TCP was
using order 3 pages for transmitting and as a result the overhead for
the pages should already be greatly reduced. In addition one of the
main reasons for page_pool  is the fact that the device has to DMA map
the page and that can have very high overhead on systems with an
IOMMU.

Rather than trying to reuse the devices page pool it might make more
sense to see if you couldn't have TCP just use some sort of circular
buffer of memory that is directly mapped for the device that it is
going to be transmitting to. Essentially what you would be doing is
creating a pre-mapped page and would need to communicate that the
memory is already mapped for the device you want to send it to so that
it could skip that step.
