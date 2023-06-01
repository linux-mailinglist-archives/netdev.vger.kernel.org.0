Return-Path: <netdev+bounces-7220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1E671F17E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 146E92818E1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97794824D;
	Thu,  1 Jun 2023 18:15:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC74701B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:15:25 +0000 (UTC)
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD471BD;
	Thu,  1 Jun 2023 11:15:22 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-53f70f7c2d2so701026a12.3;
        Thu, 01 Jun 2023 11:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685643322; x=1688235322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQCPwD5J0179L3azCbCgJadBQYf/05DC0Z7XW3a4CvQ=;
        b=Ggt+Ahg9cbNTz1Aeu/Mjk3Z32z6i7Fm9EOwL9DA3Kkr2BgFtZyWUDvqdvpz5pL4CeT
         XkdkDYsCaoZ1+f19VJZmPOYfvGAsUDZnIup//0YU4+4NI97IYNwc7ktoltKUgUHhxN2r
         OJ7BShbhNU2BmzQ1EvZoz8wUenUgdp57/GuyJnw4rA80HVwEK1t5o2HIclefcWlAltdc
         JD709W94JCdMYzPRbpnasWEXvu2pb6GWcc1RzZ/TLIh0dcDvY/eMUwOEwMTz7eZobUW5
         BSy/01dB/4Zyb5N0WCL/OiEuSzmEeVDTZjhhMwj2CtQXhL4Fsu4j/lVYpKb/jbmMMSS8
         uu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685643322; x=1688235322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WQCPwD5J0179L3azCbCgJadBQYf/05DC0Z7XW3a4CvQ=;
        b=Ret7PcWTol+S2FajXHgXw7KnRUoCpgACdh++Fn1d34tfn2UiBRGnVyWME0eNeWykto
         vh7BrSass/l0UEWfbUgm2QGh76fT0QBZo+/lVfs9BAaSsQP0HfYsVJPUTOEVcze5SaY/
         GDrAzBloBpdcEkpVw7YrQQrF9AQnH9k+P3tIJETSRVWNLHl/X128rvyPf+s5vME1+RIe
         k3C+RCRGAdL6dqLTm4bc8237AcWF5G3ofbAUdjbWGmwZ16BDYZw93vGKGVBtzyeNH//8
         RDtKIfwHxi3ZB7AxDkzV4nem53BN9Y8UiHw3qAXFVf0+rjwAcRsMQ587tdtrLK2BY+c1
         gjJA==
X-Gm-Message-State: AC+VfDywl2XjRgDlgi2U68AZqTvHFBasdVQ7Zx5o2Q2U1b3pKr49J11R
	kTzqldKL1Fye+PyqRjS9vWOmBscS/GOVjO9Ekb5elH1u
X-Google-Smtp-Source: ACHHUZ5yV5+ShvEDeJZONwjasIYpQ6vpmHmCjUwd0W25wjNLa3sXbN/P+bDlLuBFvqGU65IZij3p1WY07tc3y+/twB0=
X-Received: by 2002:a17:90a:57:b0:256:728b:9672 with SMTP id
 23-20020a17090a005700b00256728b9672mr131378pjb.22.1685643321642; Thu, 01 Jun
 2023 11:15:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-3-linyunsheng@huawei.com> <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
 <2e4f0359-151a-5cff-6d31-0ea0f014ef9a@huawei.com>
In-Reply-To: <2e4f0359-151a-5cff-6d31-0ea0f014ef9a@huawei.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Thu, 1 Jun 2023 11:14:45 -0700
Message-ID: <CAKgT0UcGYXstFP_H8VQtUooYEaYgDpG_crkodYOEyX4q0D58LQ@mail.gmail.com>
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

On Wed, May 31, 2023 at 5:19=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/5/30 23:07, Alexander H Duyck wrote:
> ...
>
> >> +    if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> >> +            *offset =3D 0;
> >> +            return page_pool_alloc_pages(pool, gfp);
> >> +    }
> >> +
> >
> > This is a recipe for pain. Rather than doing this I would say we should
> > stick with our existing behavior and not allow page pool fragments to
> > be used when the DMA address is consuming the region. Otherwise we are
> > going to make things very confusing.
>
> Are there any other concern other than confusing? we could add a
> big comment to make it clear.
>
> The point of adding that is to avoid the driver handling the
> PAGE_POOL_DMA_USE_PP_FRAG_COUNT when using page_pool_alloc_frag()
> like something like below:
>
> if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
>         page =3D page_pool_alloc_frag()
> else
>         page =3D XXXXX;
>
> Or do you perfer the driver handling it? why?
>
> >
> > If we have to have both version I would much rather just have some
> > inline calls in the header wrapped in one #ifdef for
> > PAGE_POOL_DMA_USE_PP_FRAG_COUNT that basically are a wrapper for
> > page_pool pages treated as pp_frag.
>
> Do you have a good name in mind for that wrapper.
> In addition to the naming, which API should I use when I am a driver
> author wanting to add page pool support?

When I usually have to deal with these sort of things I just rename
the original with a leading underscore or two and then just name the
inline the same as the original function.

> >
> >>      size =3D ALIGN(size, dma_get_cache_alignment());
> >> -    *offset =3D pool->frag_offset;
> >>
> >
> > If we are going to be allocating mono-frag pages they should be
> > allocated here based on the size check. That way we aren't discrupting
> > the performance for the smaller fragments and the code below could
> > function undisturbed.
>
> It is to allow possible optimization as below.

What optimization? From what I can tell you are taking extra steps for
non-page pool pages.

> >
> >> -    if (page && *offset + size > max_size) {
> >> +    if (page) {
> >> +            *offset =3D pool->frag_offset;
> >> +
> >> +            if (*offset + size <=3D max_size) {
> >> +                    pool->frag_users++;
> >> +                    pool->frag_offset =3D *offset + size;
> >> +                    alloc_stat_inc(pool, fast);
> >> +                    return page;
>
> Note that we still allow frag page here when '(size << 1 > max_size)'.

You are creating what I call a mono-frag. I am not a huge fan.

> >> +            }
> >> +
> >> +            pool->frag_page =3D NULL;
> >>              page =3D page_pool_drain_frag(pool, page);
> >>              if (page) {
> >>                      alloc_stat_inc(pool, fast);
> >> @@ -714,26 +727,24 @@ struct page *page_pool_alloc_frag(struct page_po=
ol *pool,
> >>              }
> >>      }
> >>
> >> -    if (!page) {
> >> -            page =3D page_pool_alloc_pages(pool, gfp);
> >> -            if (unlikely(!page)) {
> >> -                    pool->frag_page =3D NULL;
> >> -                    return NULL;
> >> -            }
> >> -
> >> -            pool->frag_page =3D page;
> >> +    page =3D page_pool_alloc_pages(pool, gfp);
> >> +    if (unlikely(!page))
> >> +            return NULL;
> >>
> >>  frag_reset:
> >> -            pool->frag_users =3D 1;
> >> +    /* return page as non-frag page if a page is not able to
> >> +     * hold two frags for the current requested size.
> >> +     */
> >
> > This statement ins't exactly true since you make all page pool pages
> > into fragmented pages.
>
> Any suggestion to describe it more accurately?
> I wrote that thinking frag_count being one as non-frag page.

I wouldn't consider that to be the case. The problem is if frag count
=3D=3D 1 then you have a fragmented page. It is no different from a page
where you had either freed earlier instances.

> >
> >
> >> +    if (unlikely(size << 1 > max_size)) {
> >
> > This should happen much sooner so you aren't mixing these allocations
> > with the smaller ones and forcing the fragmented page to be evicted.
>
> As mentioned above, it is to allow a possible optimization

Maybe you should point out exactly what you think the optimization is.
I don't see it as such. If you are going to evict anything that has a
size that is over half your max_size then you might as well just skip
using this entirely and just output a non-fragmented/mono frag page
rather than evicting the previously fragmented page.

