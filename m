Return-Path: <netdev+bounces-7505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A2B7207BB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAD111C210C5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508EC332EA;
	Fri,  2 Jun 2023 16:38:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F457332E1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:38:02 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939D7194;
	Fri,  2 Jun 2023 09:37:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-65299178ac5so1466466b3a.1;
        Fri, 02 Jun 2023 09:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685723878; x=1688315878;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=auuHOLzIu4SE2BmZ2RncfOS0U9tBZL7UmFowSh6FuVk=;
        b=jA+zNuVjvv6GjhMvRQGGM9Yd07oqquAtgpr5LJMAFBkxEc/0FgrnddDtJMRvGoLFWj
         QSH3n/7zTujolICFpZ983EfgJmA7QKdjWqQy7JNaR9Ssr7mNNqX8C7saPz9c7/FVJCKG
         vNeTw7ydqONIWYz6OaQ0JQCv+Lm9e4Ghg7+YVhYOx65O08tkCxhcRYGzonjrHo1eVCYr
         9FQvQi+upc2k6cEgSNExMfr76XLB1AMdzbwu+e/MCT7NaZGx2hZ194IcvI+OvB7PeAu1
         0erk+Dwu3k21YqpZJO3bY2RmTxa2GJ5LM3oJLdOwje0IHmkj2GlF3vNcd92UfCUPbiB+
         sd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685723878; x=1688315878;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=auuHOLzIu4SE2BmZ2RncfOS0U9tBZL7UmFowSh6FuVk=;
        b=CWbSVcU45gMoa19ejst6iIh6EFeOTuffM7vWzDpaTheYRtt3Q36lMw3UPqxUZyjAsR
         SaqBDzo56KgPZWnWFL5N3TzCFmkH60+07ph6X1Nza+m/eygqbI2K9priuPPIwhq0uKAt
         OrPMy2BVcZVPuOoBKFPZXcpeZD0KBDc+HLQ4DnkIqMi+5hrhyw1kl+CXsWmOAZauHotD
         7oV31xAAv+ptNZUx2l5y5XOcoOalNOtA66xbuc87jM28o1t5k+LEvOUE5wtNpwLL20W+
         jai0LBggafbcVrlE9+OvOTZheabDFnEVaSVuSSW49gnPSds4To4ICTCKiSOWJSxJryE2
         kkOA==
X-Gm-Message-State: AC+VfDyjsHZPzSYoBaHTZk/REcYPExqTOaVlrgbtCx2zE0QutVdxmdWk
	bI7M/ah6hEA9BWZdMpPmj0M=
X-Google-Smtp-Source: ACHHUZ4ZwT8o1uJ9g4X5UF6uitRDVGH99eaT+FRHNh06JvqzgJXgVRAB7PXJ4pYJBoz6bgQeo66hfg==
X-Received: by 2002:a05:6a20:958a:b0:105:6d0e:c046 with SMTP id iu10-20020a056a20958a00b001056d0ec046mr12701069pzb.26.1685723877724;
        Fri, 02 Jun 2023 09:37:57 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id p10-20020aa7860a000000b006528d9080f6sm1233369pfn.9.2023.06.02.09.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 09:37:57 -0700 (PDT)
Message-ID: <160fea176559526b38a4080cc0f52666634a7a4f.camel@gmail.com>
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org,  pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Lorenzo Bianconi
 <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Date: Fri, 02 Jun 2023 09:37:55 -0700
In-Reply-To: <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
	 <20230529092840.40413-2-linyunsheng@huawei.com>
	 <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
	 <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-31 at 19:55 +0800, Yunsheng Lin wrote:
> On 2023/5/30 23:07, Alexander H Duyck wrote:
> > On Mon, 2023-05-29 at 17:28 +0800, Yunsheng Lin wrote:
> > > Currently page_pool_dev_alloc_pages() can not be called
> > > when PP_FLAG_PAGE_FRAG is set, because it does not use
> > > the frag reference counting.
> > >=20
> > > As we are already doing a optimization by not updating
> > > page->pp_frag_count in page_pool_defrag_page() for the
> > > last frag user, and non-frag page only have one user,
> > > so we utilize that to unify frag page and non-frag page
> > > handling, so that page_pool_dev_alloc_pages() can also
> > > be called with PP_FLAG_PAGE_FRAG set.
> > >=20
> > > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > > CC: Lorenzo Bianconi <lorenzo@kernel.org>
> > > CC: Alexander Duyck <alexander.duyck@gmail.com>
> >=20
> > I"m not really a huge fan of the approach. Basically it looks like you
> > are trying to turn every page pool page into a fragmented page. Why not
> > just stick to keeping the fragemented pages and have a special case
> > that just generates a mono-frag page for your allocator instead.
>=20
> Let me try to describe what does this patch try to do and how it
> do that in more detailed in order to have more common understanding.
>=20
> Before this patch:
>=20
> As we use PP_FLAG_PAGE_FRAG to decide whether to check the frag count
> in page_pool_is_last_frag() when page is returned back to page pool,
> so:
>=20
> 1. PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true case: page_pool_create()
>    fails when it is called with PP_FLAG_PAGE_FRAG set, if user calls
>    page_pool_alloc_frag(), then we warn about it and return NULL.
>=20
> 2. PAGE_POOL_DMA_USE_PP_FRAG_COUNT being false case:
>    (1). page_pool_create() is called with PP_FLAG_PAGE_FRAG set:
>         page_pool_alloc_pages() is not allowed to be called as the
>         page->pp_frag_count is not setup correctly for the case.
>    (2). page_pool_create() is called without PP_FLAG_PAGE_FRAG set:
>         page_pool_alloc_frag() is not allowed to be called as the
>         page->pp_frag_count is not checked in page_pool_is_last_frag().
>=20
> and mlx5 using a mix of the about:
> page_pool_create() is called with with PP_FLAG_PAGE_FRAG,
> page_pool_dev_alloc_pages() is called to allocate a page and
> page_pool_fragment_page() is called to setup the page->pp_frag_count
> correctly so the page_pool_is_last_frag() can see the correct
> page->pp_frag_count, mlx5 driver handling the frag count is in the
> below, it is complicated and I am not sure if there are any added
> benefit that can justify the complication yet:
> https://www.spinics.net/lists/netdev/msg892893.html
>=20
> There are usecases for veth and virtio_net to use frag support
> in page pool to reduce memory usage, and it may request different
> frag size depending on the head/tail room space for xdp_frame/shinfo
> and mtu/packet size. When the requested frag size is large enough
> that a single page can not be split into more than one frag, using
> frag support only have performance penalty because of the extra frag
> count handling for frag support.
> So to avoid driver handling the page->pp_frag_count directly and driver
> calling different page pool API according to memory size, we need to
> way to unify the page_pool_is_last_frag() for frag and non-frag page.
>=20
> 1. https://patchwork.kernel.org/project/netdevbpf/patch/d3ae6bd3537fbce37=
9382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org/
> 2. https://patchwork.kernel.org/project/netdevbpf/patch/20230526054621.18=
371-3-liangchen.linux@gmail.com/
>=20
> After this patch:
> This patch ensure pp_frag_count of page from pool->alloc/pool->ring or
> newly allocated from page allocator is one, which means we assume that
> all pages have one frag user initially so that we can have a unified
> handling for frag and non-frag page in page_pool_is_last_frag().
>=20
> So the key point in this patch is about unified handling in
> page_pool_is_last_frag(), which is the free/put side of page pool,
> not the alloc/generate side.
>=20
> Utilizing the page->pp_frag_count being one initially for every page
> is the least costly way to do that as best as I can think of.
> As it only add the cost of page_pool_fragment_page() for non-frag page
> case as you have mentioned below, which I think it is negligible as we
> are already dirtying the same cache line in page_pool_set_pp_info().
> And for frag page, we avoid the reseting page->pp_frag_count to one by
> utilizing the optimization of not updating page->pp_frag_count in
> page_pool_defrag_page() for the last frag user.
>=20
> Please let me know if the above makes sense, or if misunderstood your
> concern here.

So my main concern is that what this is doing is masking things so that
the veth and virtio_net drivers can essentially lie about the truesize
of the memory they are using in order to improve their performance by
misleading the socket layer about how much memory it is actually
holding onto.

We have historically had an issue with reporting the truesize of
fragments, but generally the underestimation was kept to something less
than 100% because pages were generally split by at least half. Where it
would get messy is if a misbehaviing socket held onto packets for an
exceedingly long time.

What this patch set is doing is enabling explicit lying about the
truesize, and it compounds that by allowing for mixing small
allocations w/ large ones.

> >=20
> > The problem is there are some architectures where we just cannot
> > support having pp_frag_count due to the DMA size. So it makes sense to
> > leave those with just basic page pool instead of trying to fake that it
> > is a fragmented page.
>=20
> It kind of depend on how you veiw it, this patch view it as only supporti=
ng
> one frag when we can't support having pp_frag_count, so I would not call =
it
> faking.

So the big thing that make it "faking" is the truesize underestimation
that will occur with these frames.

>=20
> >=20
> > > ---
> > >  include/net/page_pool.h | 38 +++++++++++++++++++++++++++++++-------
> > >  net/core/page_pool.c    |  1 +
> > >  2 files changed, 32 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > > index c8ec2f34722b..ea7a0c0592a5 100644
> > > --- a/include/net/page_pool.h
> > > +++ b/include/net/page_pool.h
> > > @@ -50,6 +50,9 @@
> > >  				 PP_FLAG_DMA_SYNC_DEV |\
> > >  				 PP_FLAG_PAGE_FRAG)
> > > =20
> > > +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT \
> > > +		(sizeof(dma_addr_t) > sizeof(unsigned long))
> > > +
> > >  /*
> > >   * Fast allocation side cache array/stack
> > >   *
> > > @@ -295,13 +298,20 @@ void page_pool_put_defragged_page(struct page_p=
ool *pool, struct page *page,
> > >   */
> > >  static inline void page_pool_fragment_page(struct page *page, long n=
r)
> > >  {
> > > -	atomic_long_set(&page->pp_frag_count, nr);
> > > +	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> > > +		atomic_long_set(&page->pp_frag_count, nr);
> > >  }
> > > =20
> > > +/* We need to reset frag_count back to 1 for the last user to allow
> > > + * only one user in case the page is recycled and allocated as non-f=
rag
> > > + * page.
> > > + */
> > >  static inline long page_pool_defrag_page(struct page *page, long nr)
> > >  {
> > >  	long ret;
> > > =20
> > > +	BUILD_BUG_ON(__builtin_constant_p(nr) && nr !=3D 1);
> > > +
> >=20
> > What is the point of this line? It doesn't make much sense to me. Are
> > you just trying to force an optiimization? You would be better off just
> > taking the BUILD_BUG_ON contents and feeding them into an if statement
> > below since the statement will compile out anyway.
>=20
> if the "if statement" you said refers to the below, then yes.
>=20
> > > +		if (!__builtin_constant_p(nr))
> > > +			atomic_long_set(&page->pp_frag_count, 1);
>=20
> But it is a *BUILD*_BUG_ON(), isn't it compiled out anywhere we put it?
>=20
> Will move it down anyway to avoid confusion.

Actually now that I look at this more it is even more confusing. The
whole point of this function was that we were supposed to be getting
pp_frag_count to 0. However you are setting it to 1.

This is seriously flawed. If we are going to treat non-fragmented pages
as mono-frags then that is what we should do. We should be pulling this
acounting into all of the page pool freeing paths, not trying to force
the value up to 1 for the non-fragmented case.

> >=20
> > It seems like what you would want here is:
> > 	BUG_ON(!PAGE_POOL_DMA_USE_PP_FRAG_COUNT);
> >=20
> > Otherwise you are potentially writing to a variable that shouldn't
> > exist.
>=20
> Not if the driver use the page_pool_alloc_frag() API instead of manipulat=
ing
> the page->pp_frag_count directly using the page_pool_defrag_page() like m=
lx5.
> The mlx5 call the page_pool_create() with with PP_FLAG_PAGE_FRAG set, and
> it does not seems to have a failback for PAGE_POOL_DMA_USE_PP_FRAG_COUNT
> case, and we may need to keep PP_FLAG_PAGE_FRAG for it. That's why we nee=
d
> to keep the driver from implementation detail(pp_frag_count handling spec=
ifically)
> of the frag support unless we have a very good reason.
>=20

Getting the truesize is that "very good reason". The fact is the
drivers were doing this long before page pool came around. Trying to
pull that away from them is the wrong way to go in my opinion.

> > >  	/* If nr =3D=3D pp_frag_count then we have cleared all remaining
> > >  	 * references to the page. No need to actually overwrite it, instea=
d
> > >  	 * we can leave this to be overwritten by the calling function.
> > > @@ -311,19 +321,36 @@ static inline long page_pool_defrag_page(struct=
 page *page, long nr)
> > >  	 * especially when dealing with a page that may be partitioned
> > >  	 * into only 2 or 3 pieces.
> > >  	 */
> > > -	if (atomic_long_read(&page->pp_frag_count) =3D=3D nr)
> > > +	if (atomic_long_read(&page->pp_frag_count) =3D=3D nr) {
> > > +		/* As we have ensured nr is always one for constant case
> > > +		 * using the BUILD_BUG_ON() as above, only need to handle
> > > +		 * the non-constant case here for frag count draining.
> > > +		 */
> > > +		if (!__builtin_constant_p(nr))
> > > +			atomic_long_set(&page->pp_frag_count, 1);
> > > +
> > >  		return 0;
> > > +	}
> > > =20

The optimization here was already the comparison since we didn't have
to do anything if pp_frag_count =3D=3D nr. The whole point of pp_frag_count
going to 0 is that is considered non-fragmented in that case and ready
to be freed. By resetting it to 1 you are implying that there is still
one *other* user that is holding a fragment so the page cannot be
freed.

We weren't bothering with writing the value since the page is in the
free path and this value is going to be unused until the page is
reallocated anyway.

> > >  	ret =3D atomic_long_sub_return(nr, &page->pp_frag_count);
> > >  	WARN_ON(ret < 0);
> > > +
> > > +	/* Reset frag count back to 1, this should be the rare case when
> > > +	 * two users call page_pool_defrag_page() currently.
> > > +	 */
> > > +	if (!ret)
> > > +		atomic_long_set(&page->pp_frag_count, 1);
> > > +
> > >  	return ret;
> > >  }
> > > =20
> > >  static inline bool page_pool_is_last_frag(struct page_pool *pool,
> > >  					  struct page *page)
> > >  {
> > > -	/* If fragments aren't enabled or count is 0 we were the last user =
*/
> > > -	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
> > > +	/* When dma_addr_upper is overlapped with pp_frag_count
> > > +	 * or we were the last page frag user.
> > > +	 */
> > > +	return PAGE_POOL_DMA_USE_PP_FRAG_COUNT ||
> > >  	       (page_pool_defrag_page(page, 1) =3D=3D 0);
> > >  }
> > > =20
> > > @@ -357,9 +384,6 @@ static inline void page_pool_recycle_direct(struc=
t page_pool *pool,
> > >  	page_pool_put_full_page(pool, page, true);
> > >  }
> > > =20
> > > -#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
> > > -		(sizeof(dma_addr_t) > sizeof(unsigned long))
> > > -
> > >  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> > >  {
> > >  	dma_addr_t ret =3D page->dma_addr;
> > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > index e212e9d7edcb..0868aa8f6323 100644
> > > --- a/net/core/page_pool.c
> > > +++ b/net/core/page_pool.c
> > > @@ -334,6 +334,7 @@ static void page_pool_set_pp_info(struct page_poo=
l *pool,
> > >  {
> > >  	page->pp =3D pool;
> > >  	page->pp_magic |=3D PP_SIGNATURE;
> > > +	page_pool_fragment_page(page, 1);
> > >  	if (pool->p.init_callback)
> > >  		pool->p.init_callback(page, pool->p.init_arg);
> > >  }
> >=20
> > Again, you are adding statements here that now have to be stripped out
> > under specific circumstances. In my opinion it would be better to not
> > modify base page pool pages and instead just have your allocator
> > provide a 1 frag page pool page via a special case allocator rather
> > then messing with all the other drivers.
>=20
> As above, it is about unifying handling for frag and non-frag page in
> page_pool_is_last_frag(). please let me know if there is any better way
> to do it without adding statements here.

I get what you are trying to get at but I feel like the implementation
is going to cause more problems than it helps. The problem is it is
going to hurt base page pool performance and it just makes the
fragmented pages that much more confusing to deal with.

My advice as a first step would be to look at first solving how to
enable the PP_FLAG_PAGE_FRAG mode when you have
PAGE_POOL_DMA_USE_PP_FRAG_COUNT as true. That should be creating mono-
frags as we are calling them, and we should have a way to get the
truesize for those so we know when we are consuming significant amount
of memory.

Once that is solved then we can look at what it would take to apply
mono-frags to the standard page pool case. Ideally we would need to
find a way to do it with minimal overhead.


