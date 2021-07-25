Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBDA3D4ECE
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGYQIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 12:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGYQIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 12:08:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E348C061757;
        Sun, 25 Jul 2021 09:49:20 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id he41so12502657ejc.6;
        Sun, 25 Jul 2021 09:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hvEIHu9m+4gLaoFby3qd9OS7/wPiO71TcYfZFfPn4mQ=;
        b=fhuyGmWrmb3ZSDZs//q9/Z7yIRtUlxhkS26soEPbAG7Ao1UsaS3mm+ObByBN+CuD3d
         xO+hATjkl+ChFoZ6ywSg/t71mnFI+8RlxIX2EspHHrD6wOi4OcB4i2X/9bFAI9E7X4vX
         U7hlhPJ6HVYjtXHG3GgpEYt20GHMxlD1p+WSwhoqsi8zRxcE3uu0YIYVWva7oVwSPb9S
         5ur4aiC2py0eRl2R6A+iGUcIx2KiWyJ+aXUkE1MYi5MFHuh1NGgy6mq076bU1cctPFKq
         r3ZvuCJ0i/Zj0LpU1ej0vXgyxMFUF0633IIsvBwv24IzbIYjXinySYFOZORlWnESWYUa
         /HhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hvEIHu9m+4gLaoFby3qd9OS7/wPiO71TcYfZFfPn4mQ=;
        b=j52vWaDCil+j8YiWoVKcQumRsHzDKmR9naXTb596z576tvoWK7AjM1ep3rXC5I9/51
         IoWuzEAPhwTvmGOKe8JwUkhgTkVx1rOn6vR9JKiK13lan/eDJn5GpDhTkaH7kN9+TFeK
         h0tEsfICJwzwQDzmF7V0NDSRzl6A7GK9Us2YfrLDqNbPNUocCbR3/1Z2sonr0gElT9xc
         2aDcY/x/ID36GtcmIF2ERR0S/WROAxSvNLAYfcxvQRwyCfqq1glZ4pISToYoIAbgdb2v
         mGj7XLPEWEan4or+CD5fjBbdZJWROpMtEINTYIVG88gGdri9S8ycb0Q871xmzTfKt1kg
         h5pQ==
X-Gm-Message-State: AOAM530u2G0pI68ijy5kTfQp+/aySdd3q9ToKxza4OFMaTtsR7Inq7iW
        smGL5B6oq8Y6SE0twGSQ25K7KqbVxVAG+Fhp0XU=
X-Google-Smtp-Source: ABdhPJwG/6qaZBOHkS7VH2KywX0OvjVflrwBj6QUjp2jB4HcCrljIi2GRQo8ZSYXxzTEvUkh1nGk1Cink/RiXbbZiQk=
X-Received: by 2002:a17:907:e9e:: with SMTP id ho30mr13917105ejc.114.1627231758859;
 Sun, 25 Jul 2021 09:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <1626752145-27266-1-git-send-email-linyunsheng@huawei.com>
 <1626752145-27266-3-git-send-email-linyunsheng@huawei.com>
 <CAKgT0Uf=WbpngDPQ1V0X+XSJbZ91=cuaz8r_J96=BrXg01PJFA@mail.gmail.com>
 <92e68f4e-49a4-568c-a281-2865b54a146e@huawei.com> <CAKgT0UfwiBowGN+ctqoFZ6qaQAUp-0uGJeukk4OHOEOOfbrEWw@mail.gmail.com>
 <fffae41f-b0a3-3c43-491f-096d31ba94ca@huawei.com> <CAKgT0UcBgo0Ex=x514qGeLvppJr-0vqx9ZngAFDTwugjtKUrOA@mail.gmail.com>
 <41283c5f-2f58-7fa7-e8fe-a91207a57353@huawei.com> <CAKgT0Ud+PRzz7mgX1dru1=i3TDiaGOoyhg7vp6cz+3NzVFZf+A@mail.gmail.com>
 <20210724130709.GA1461@ip-172-31-30-86.us-east-2.compute.internal>
In-Reply-To: <20210724130709.GA1461@ip-172-31-30-86.us-east-2.compute.internal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 25 Jul 2021 09:49:07 -0700
Message-ID: <CAKgT0UckhFhvmsjNhBM6tX_EUn12NCn--puJkwVUGitk9yZedw@mail.gmail.com>
Subject: Re: [PATCH rfc v6 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Yunsheng Lin <yunshenglin0825@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
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

On Sat, Jul 24, 2021 at 6:07 AM Yunsheng Lin <yunshenglin0825@gmail.com> wr=
ote:
>
> On Fri, Jul 23, 2021 at 09:08:00AM -0700, Alexander Duyck wrote:
> > On Fri, Jul 23, 2021 at 4:12 AM Yunsheng Lin <linyunsheng@huawei.com> w=
rote:
> > >
> > > On 2021/7/22 23:18, Alexander Duyck wrote:
> > > >>>
> > > >>>> You are right that that may cover up the reference count errors.=
 How about
> > > >>>> something like below:
> > > >>>>
> > > >>>> static inline long page_pool_atomic_sub_frag_count_return(struct=
 page *page,
> > > >>>>                                                           long n=
r)
> > > >>>> {
> > > >>>> #ifdef CONFIG_DEBUG_PAGE_REF
> > > >>>>         long ret =3D atomic_long_sub_return(nr, &page->pp_frag_c=
ount);
> > > >>>>
> > > >>>>         WARN_ON(ret < 0);
> > > >>>>
> > > >>>>         return ret;
> > > >>>> #else
> > > >>>>         if (atomic_long_read(&page->pp_frag_count) =3D=3D nr)
> > > >>>>                 return 0;
> > > >>>>
> > > >>>>         return atomic_long_sub_return(nr, &page->pp_frag_count);
> > > >>>> #end
> > > >>>> }
> > > >>>>
> > > >>>> Or any better suggestion?
> > > >>>
> > > >>> So the one thing I might change would be to make it so that you o=
nly
> > > >>> do the atomic_long_read if nr is a constant via __builtin_constan=
t_p.
> > > >>> That way you would be performing the comparison in
> > > >>> __page_pool_put_page and in the cases of freeing or draining the
> > > >>> page_frags you would be using the atomic_long_sub_return which sh=
ould
> > > >>> be paths where you would not expect it to match or that are slowp=
ath
> > > >>> anyway.
> > > >>>
> > > >>> Also I would keep the WARN_ON in both paths just to be on the saf=
e side.
> > > >>
> > > >> If I understand it correctly, we should change it as below, right?
> > > >>
> > > >> static inline long page_pool_atomic_sub_frag_count_return(struct p=
age *page,
> > > >>                                                           long nr)
> > > >> {
> > > >>         long ret;
> > > >>
> > > >>         /* As suggested by Alexander, atomic_long_read() may cover=
 up the
> > > >>          * reference count errors, so avoid calling atomic_long_re=
ad() in
> > > >>          * the cases of freeing or draining the page_frags, where =
we would
> > > >>          * not expect it to match or that are slowpath anyway.
> > > >>          */
> > > >>         if (__builtin_constant_p(nr) &&
> > > >>             atomic_long_read(&page->pp_frag_count) =3D=3D nr)
> > > >>                 return 0;
> > > >>
> > > >>         ret =3D atomic_long_sub_return(nr, &page->pp_frag_count);
> > > >>         WARN_ON(ret < 0);
> > > >>         return ret;
> > > >> }
> > > >
> > > > Yes, that is what I had in mind.
> > > >
> > > > One thought I had for a future optimization is that we could look a=
t
> > > > reducing the count by 1 so that we could essentially combine the
> > > > non-frag and frag cases.Then instead of testing for 1 we would test
> > > > for 0 at thee start of the function and test for < 0 to decide if w=
e
> > > > want to free it or not instead of testing for 0. With that we can
> > > > essentially reduce the calls to the WARN_ON since we should only ha=
ve
> > > > one case where we actually return a value < 0, and we can then chec=
k
> > > > to see if we overshot -1 which would be the WARN_ON case.
> > > >
> > > > With that a value of 0 instead of 1 would indicate page frag is not=
 in
> > > > use for the page *AND/OR* that the page has reached the state where
> > > > there are no other frags present so the page can be recycled. In
> > > > effect it would allow us to mix page frags and no frags within the
> > > > same pool. The added bonus would be we could get rid of the check f=
or
> > > > PP_FLAG_PAGE_FRAG flag check in the __page_pool_put_page function a=
nd
> > > > replace it with a check for PAGE_POOL_DMA_USE_PP_FRAG_COUNT since w=
e
> > > > cannot read frag_count in that case.
> > >
> > > Let's leave it for a future optimization.
> > > I am not sure if there is use case to support both frag page and non-=
frag
> > > page for the same page pool. If there is, maybe we can use "page->pp_=
frag_count
> > > > 0" to indicate that the page is frag page, and "page->pp_frag_count=
 =3D=3D 0"
> > > to indicate that the page is non-frag page, so that we can support fr=
ag page and
> > > non-frag page for the same page pool instead of disabling non-frag pa=
ge support
> > > when PP_FLAG_PAGE_FRAG flag is set, which might be conflit with the a=
bove
> > > optimization?
> >
> > As far as use case I can see a number of potential uses. For example
> > in the case of drivers that do something like a header/data split I
> > could see potentially having the header pages be frags while the data
> > pages being 4K blocks. Basically the big optimization of the count =3D=
=3D
> > 1/0/nr case is that you aren't increasing/decreasing the count and it
> > is immediately being recycled/reused. So in such a case being able to
> > add frag count some pages, and not to others would likely be quite
> > useful.
>
> I am not sure how the header/data split is implemented in hw, but it
> seems the driver is not able to tell which desc will be filled with
> header or data in advance, so it might need to allocate 4K block for
> all desc?

It all depends on the hardware config. In theory you could have
anything from a single use for a page to multiple uses for a page in
the case of headers and/or packets being small. The overhead for
adding/removing the frag count could end up being more than what is
needed if the page is only used once. That is why I was thinking it
might make sense to allow both to coexist in the same pool.

> >
> > Basically by shifting the pool values by 1 you can have both in the
> > same pool with little issue. However the big change is that instead of
> > testing for count =3D nr it would end up being pp_frag_count =3D nr - 1=
.
> > So in the case of the standard page pool pages being freed or the last
> > frag you would be looking at pp_frag_count =3D 0. In addition we can
> > mask the WARN_ON overhead as you would be using -1 as the point to
> > free so you would only have to perform the WARN_ON check for the last
> > frag instead of every frag.
>
> Yes, it seems doable.
>
> >
> > > Also, I am prototyping the tx recycling based on page pool in order t=
o see
> > > if there is any value supporting the tx recycling.
> >
> > Just to clarify here when you say Tx recycling you are talking about
> > socket to netdev correct? Just want to be certain since the netdev to
> > netdev case should already have recycling for page pool pages as long
> > as it follows a 1<->1 path.
>
> Yes, the above Tx recycling meant socket to netdev.
> Also, the above "netdev to netdev" only meant XDP now, but not the IP
> forwarding path in the network stack, right?
>
> >
> > > As the busypoll has enable the one-to-one relation between NAPI and s=
ock,
> > > and there is one-to-one relation between NAPI and page pool, perhaps =
it make
> > > senses that we use page pool to recycle the tx page too?
> > >
> > > There are possibly below problems when doing that as I am aware of no=
w:
> > > 1. busypoll is for rx, and tx may not be using the same queue as rx e=
ven if
> > >    there are *technically* the same flow=EF=BC=8C so I am not sure it=
 is ok to use
> > >    busypoll infrastructure to get the page pool ptr for a specific so=
ck.
> > >
> > > 2. There may be multi socks using the same page pool ptr to allocate =
page for
> > >    multi flow, so we can not assume the same NAPI polling protection =
as rx,
> > >    which might mean we can only use the recyclable page from pool->ri=
ng under the
> > >    r->consumer_lock protection.
> > >
> > > 3. Right now tcp_sendmsg_locked() use sk_page_frag_refill() to refill=
 the page
> > >    frag for tcp xmit, when implementing a similar sk_page_pool_frag_r=
efill()
> > >    based on page pool, I found that tcp coalesce in tcp_mtu_probe() a=
nd
> > >    tcp fragment in tso_fragment() might mess with the page_ref_count =
directly.
> > >
> > > As the above the problem I am aware of(I believe there are other prob=
lems I am not
> > > aware of yet), I am not sure if the tcp tx page recycling based on pa=
ge pool is
> > > doable or not, I would like to hear about your opinion about tcp tx r=
ecycling support
> > > based on page pool first, in case it is a dead end to support that.
> >
> > I'm honestly not sure there is much there to gain. Last I knew TCP was
> > using order 3 pages for transmitting and as a result the overhead for
> > the pages should already be greatly reduced. In addition one of the
> > main reasons for page_pool  is the fact that the device has to DMA map
> > the page and that can have very high overhead on systems with an
> > IOMMU.
>
> Yes, avoiding the IOMMU overhead is the main gain. and "order 3 pages"
> seems to be disabled on defaut?
>
> >
> > Rather than trying to reuse the devices page pool it might make more
> > sense to see if you couldn't have TCP just use some sort of circular
> > buffer of memory that is directly mapped for the device that it is
> > going to be transmitting to. Essentially what you would be doing is
> > creating a pre-mapped page and would need to communicate that the
> > memory is already mapped for the device you want to send it to so that
> > it could skip that step.
>
> IIUC sk_page_frag_refill() is already doing a similar reusing as the
> rx reusing implemented in most driver except for the not pre-mapping
> part.
>
> And it seems that even if we pre-map the page and communicate that the
> memory is already mapped to the driver, it is likely that we will not
> be able to reuse the page when the circular buffer is not big enough
> or tx completion/tcp ack is not happening quickly enough, which might
> means unmapping/deallocating old circular buffer and allocating/mapping
> new circular buffer.
>
> Using page pool we might be able to alleviate the above problem as it
> does for rx?

I would say that instead of looking at going straight for the page
pool it might make more sense to look at seeing if we can coalesce the
DMA mapping of the pages first at the socket layer rather than trying
to introduce the overhead for the page pool. In the case of sockets we
already have the destructors that are called when the memory is freed,
so instead of making sockets use page pool it might make more sense to
extend the socket buffer allocation/freeing to incorporate bulk
mapping and unmapping of pages to optimize the socket Tx path in the
32K page case.
