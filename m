Return-Path: <netdev+bounces-7478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7039D7206B1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0D201C21094
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786AD1C749;
	Fri,  2 Jun 2023 15:58:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D091B909
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:58:27 +0000 (UTC)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509A4132;
	Fri,  2 Jun 2023 08:58:25 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-25692ff86cdso1734203a91.2;
        Fri, 02 Jun 2023 08:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685721505; x=1688313505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5P+EE/TOVxYknycB94mEuJJRRu3tivhsMfEz3EGIVs=;
        b=ld6YO38kiks9nCOaM+ElI+1GYpFqdKV9otWAchj8SduUs0nu/CUrBDjXt6Xta/CcgG
         aX8OAenev8mrUeTTB/Uny0SrSsMa/g7w+uzeZL3XvOAigJ/RjCAW7HUYuEZAK2UAs/gJ
         unEK/wOK+HhGxHC5FuGnlnLuDTokeVeSeqQK//paJe64Dd8PAGHcmJBFS5iURuUDGwR7
         PIwLBySX5TYharcdktg3I+FJ4uewaGkmb7uM+bStAODckeECaohEbOhsGTDufKRHXUGN
         MZFYaxpkxEXkEweKelqq/eLO6Eq2M0REfMz2kKSXmlHf9wRPwJHRggXdJtlBQLiBppve
         o+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685721505; x=1688313505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r5P+EE/TOVxYknycB94mEuJJRRu3tivhsMfEz3EGIVs=;
        b=OxMtnu7N8WdqetS5xvOia/96b3hwvjRlM38OP/WV1I1K/zOKHF0fzYOlyEXbq0cNmM
         ibUFCPEMHIYnkFq9bj+78fGQ2PqOnKeD0srYV4kedmfoa7OMZUgVnk9Dtcc09zPjKac6
         Q8XB4A6InUtdFZcUvDTWTJXmWW7Pc23oOfrxABgfErSf+upNWbZPJHmc3AEN4cKKSHrW
         NB+TPH6axlNpElczhwFc7Wh9UlgpKs5hd9KCi2Rh1IAOSzGmYPuwBridBvp/FlyoNO3s
         t3W9vz+0XJAEPK2K8elg2m7OML1WpzVDuZynxDXdj3y8zpP+kVsmY9NIZrDlglYaPMX2
         2R0Q==
X-Gm-Message-State: AC+VfDw77iDOACZFaapVA9SylyYXXvegcFw4lHCwr1Pyoj/YAHcWiDB/
	QhQKJpqlfACv1dC3LHcSfLj3A1+qG7PE42xKPWI=
X-Google-Smtp-Source: ACHHUZ5DIQksDkMh3cbfc61K6OgkJV1fHQJmld2ZMdAu9hoVBdPWuu7rlybQeWN3cZdZ3nFJGxYwsIY4sVA8BxAqHfo=
X-Received: by 2002:a17:90a:728d:b0:255:58c4:fbae with SMTP id
 e13-20020a17090a728d00b0025558c4fbaemr367316pjg.10.1685721504583; Fri, 02 Jun
 2023 08:58:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-3-linyunsheng@huawei.com> <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
 <2e4f0359-151a-5cff-6d31-0ea0f014ef9a@huawei.com> <CAKgT0UcGYXstFP_H8VQtUooYEaYgDpG_crkodYOEyX4q0D58LQ@mail.gmail.com>
 <8c9d5dd8-b654-2d50-039d-9b7732e7746f@huawei.com>
In-Reply-To: <8c9d5dd8-b654-2d50-039d-9b7732e7746f@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 08:57:47 -0700
Message-ID: <CAKgT0UchHBO+kyPZMYJR7JHfqYsk+qSeuvXzA-H9w3VH-9Tfrg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] page_pool: support non-frag page for page_pool_alloc_frag()
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 5:23=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:
>
> On 2023/6/2 2:14, Alexander Duyck wrote:
> > On Wed, May 31, 2023 at 5:19=E2=80=AFAM Yunsheng Lin <linyunsheng@huawe=
i.com> wrote:
>
> ...
>
> >>
> >>>
> >>> If we have to have both version I would much rather just have some
> >>> inline calls in the header wrapped in one #ifdef for
> >>> PAGE_POOL_DMA_USE_PP_FRAG_COUNT that basically are a wrapper for
> >>> page_pool pages treated as pp_frag.
> >>
> >> Do you have a good name in mind for that wrapper.
> >> In addition to the naming, which API should I use when I am a driver
> >> author wanting to add page pool support?
> >
> > When I usually have to deal with these sort of things I just rename
> > the original with a leading underscore or two and then just name the
> > inline the same as the original function.
>
> Ok, will follow the pattern if it is really necessary.
>
> >
> >>>
> >>>>      size =3D ALIGN(size, dma_get_cache_alignment());
> >>>> -    *offset =3D pool->frag_offset;
> >>>>
> >>>
> >>> If we are going to be allocating mono-frag pages they should be
> >>> allocated here based on the size check. That way we aren't discruptin=
g
> >>> the performance for the smaller fragments and the code below could
> >>> function undisturbed.
> >>
> >> It is to allow possible optimization as below.
> >
> > What optimization? From what I can tell you are taking extra steps for
> > non-page pool pages.
>
> I will talk about the optimization later.
>
> According to my defination in this patchset:
> frag page: page alloced from page_pool_alloc_frag() with page->pp_frag_co=
unt
>            being greater than one.
> non-frag page:page alloced return from both page_pool_alloc_frag() and
>               page_pool_alloc_pages() with page->pp_frag_count being one.
>
> I assume the above 'non-page pool pages' refer to what I call as 'non-fra=
g
> page' alloced return from both page_pool_alloc_frag(), right? And it is
> still about doing the (size << 1 > max_size)' checking at the begin inste=
ad
> of at the middle right now to avoid extra steps for 'non-frag page' case?

Yeah, the non-page I was referring to were you mono-frag pages.

> >
> >>>
> >>>> -    if (page && *offset + size > max_size) {
> >>>> +    if (page) {
> >>>> +            *offset =3D pool->frag_offset;
> >>>> +
> >>>> +            if (*offset + size <=3D max_size) {
> >>>> +                    pool->frag_users++;
> >>>> +                    pool->frag_offset =3D *offset + size;
> >>>> +                    alloc_stat_inc(pool, fast);
> >>>> +                    return page;
> >>
> >> Note that we still allow frag page here when '(size << 1 > max_size)'.
>
> This is the optimization I was taking about: suppose we start
> from a clean state with 64K page size, if page_pool_alloc_frag()
> is called with size being 2K and then 34K, we only need one page
> to satisfy caller's need as we do the '*offset + size > max_size'
> checking before the '(size << 1 > max_size)' checking.

The issue is the unaccounted for waste. We are supposed to know the
general size of the frags being used so we can compute truesize. If
for example you are using an order 3 page and you are splitting it
between a 2K and a 17K fragment the 2K fragments will have a massive
truesize underestimate that can lead to memory issues if those smaller
fragments end up holding onto the pages.

As such we should try to keep the small fragments away from anything
larger than half of the page.

> As you mentioned below, it is at the cost of evicting the previously
> fragmented page, I thought about keeping it when implementing, but I
> am not sure evicting it is really matter if the previously fragmented
> page does not pass the testing by '*offset + size > max_size'?
>
> Or maybe we should adjust the code a litte bit as below to allow the
> optimization I mentioned without the cost of evicting the previously
> fragmented page?

Really we should just not be mixing smaller fragments w/ larger ones
for the above truesize reasons.

> struct page *page_pool_alloc_frag(struct page_pool *pool,
>                                   unsigned int *offset,
>                                   unsigned int size, gfp_t gfp)
> {
>         unsigned int max_size =3D PAGE_SIZE << pool->p.order;
>         struct page *page =3D pool->frag_page;
>
>         if (unlikely(size > max_size))
>                 return NULL;
>
>         if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>                 goto alloc_non_frag;
>
>         size =3D ALIGN(size, dma_get_cache_alignment());
>
>         if (page && pool->frag_offset <=3D max_size) {
>                 *offset =3D pool->frag_offset;
>                 pool->frag_users++;
>                 pool->frag_offset +=3D size;
>                 alloc_stat_inc(pool, fast);
>                 return page;
>         }
>
>         if (unlikely((size << 1) > max_size))
>                 goto alloc_non_frag;
>
>         if (page) {
>                 page =3D page_pool_drain_frag(pool, page);
>                 if (page) {
>                         alloc_stat_inc(pool, fast);
>                         goto frag_reset;
>                 }
>         }
>
>         page =3D page_pool_alloc_pages(pool, gfp);
>         if (unlikely(!page))
>                 return NULL;
>
>         pool->frag_page =3D page;
> frag_reset:
>         pool->frag_users =3D 1;
>         *offset =3D 0;
>         pool->frag_offset =3D size;
>         page_pool_fragment_page(page, BIAS_MAX);
>         return page;
>
> alloc_non_frag:
>         *offset =3D 0;
>         return page_pool_alloc_pages(pool, gfp);
> }
>
> >
> > You are creating what I call a mono-frag. I am not a huge fan.
>
> Do you mean 'mono-frag' as the unifying of frag and non-frag
> page handling by assuming all pages in page pool having one
> frag user initially in patch 1?
> If yes, please let's continue the discussion in pacth 1 so that
> we don't have to restart the discussion again.
>
> Or is there some other obvious concern about 'mono-frag' I missed?

The main concern I have is having mono-frags and truly fragmented
pages mixing too much which is making a bit of a mess of things.

If we are going to use these fragments we really need to be able to
tell the truesize of these mono-frag pages. What I want to avoid is
seeing drivers abuse this to allocate huge swaths of memory but not
accounting for it in the skb_truesize.

