Return-Path: <netdev+bounces-11527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5656B733780
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54F871C20C81
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552DC1C774;
	Fri, 16 Jun 2023 17:34:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4418319E69;
	Fri, 16 Jun 2023 17:34:41 +0000 (UTC)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573021FF7;
	Fri, 16 Jun 2023 10:34:39 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-25e8545ea28so781704a91.0;
        Fri, 16 Jun 2023 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686936879; x=1689528879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kxA+ZqGfFPqYw3C9ialTd5Ien3AooaP5NvhhVbxD7jk=;
        b=k8VOj7blc5+BW5q9oY08+FkzwflcaI8z9k70mTiZPwgDMJTWtpx7vpERhzdxujkp8L
         cD+FDXJQ3YEyHPmOyjqniCM1J+IqUasyEg+LnEkO0EbMP8t7S3DA57ote9QG5tiCIDHz
         6rlxEHySklqJ7cQO+hQYRJeYDLFmI43j89MzNUyuNC5vtDKJ4FbfAiOQWe/w+u5ENQo/
         4Od1SMFoJThcEuVwnAg1tzivco1RtwV9W7smQ+PtGidtHxgQyQlvMII5tBi7mHL5JX4K
         SsetE+7HjeIASKbBid0IFGAZPc0tEuLPIyOKrQA3hRWnn3Yt13QVlH2WsgOrzjkNrK3U
         TBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686936879; x=1689528879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kxA+ZqGfFPqYw3C9ialTd5Ien3AooaP5NvhhVbxD7jk=;
        b=WJwAQh+l71QXdzate4tu0eW54ul6BfKp/Dd3ykl5HG9BenMmNzCWiT4gTyiw+fc63l
         AGQng4TIVoVD+NwUFnKIy0QowP/x8MkWGiHOx0JtBDFvaRU+YJyT/SrDDmUiiieoopHV
         +myg2dySCVVNcMrusEyEEJ7fXhdLWKCIL9CXfU9bt3Bbh8mtM7C7oTyFpX6Qaf6/LsmQ
         VAkQ37AowbhsZL8kZ4ZXguE33pHl9KMXZldEYwGE/W3ZqxP9+QJUlIFQBPssg05/Jxvs
         t6Ql9vmJT/k6zzEZcSpniDsPuDDtXOd9Y9MkYP2anMEuYqdQjjMKCuCJDfPMbnpdVWt5
         c0cQ==
X-Gm-Message-State: AC+VfDzVvPdJ6iMwNs/m94VKwP+XaN9iFwcVF+XIXL4xLmfyzYn4n9ll
	iJix4yMPaHgKMIDg32opkQqaOvSF0jv8msByUY8=
X-Google-Smtp-Source: ACHHUZ5OH1Hyzn3IS5GqShw67bYvUR2eMaDWOMyDgnmPwmGsdeM1ZOBJQoLVpc0HRTkmFjd0Yzqp5bz/x6Ms5M1pITg=
X-Received: by 2002:a17:90b:a4b:b0:255:9038:fe0d with SMTP id
 gw11-20020a17090b0a4b00b002559038fe0dmr2347329pjb.38.1686936878634; Fri, 16
 Jun 2023 10:34:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609131740.7496-1-linyunsheng@huawei.com> <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com> <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com> <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
 <0ba1bf9c-2e45-cd44-60d3-66feeb3268f3@redhat.com> <dcc9db4c-207b-e118-3d84-641677cd3d80@huawei.com>
 <f8ce176f-f975-af11-641c-b56c53a8066a@redhat.com>
In-Reply-To: <f8ce176f-f975-af11-641c-b56c53a8066a@redhat.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 16 Jun 2023 10:34:02 -0700
Message-ID: <CAKgT0UfzP30OiBQu+YKefLD+=32t+oA6KGzkvsW6k7CMTXU8KA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc() API
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, brouer@redhat.com, davem@davemloft.net, 
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Maryam Tahhan <mtahhan@redhat.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 9:31=E2=80=AFAM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 16/06/2023 13.57, Yunsheng Lin wrote:
> > On 2023/6/16 0:19, Jesper Dangaard Brouer wrote:
> >
> > ...
> >
> >> You have mentioned veth as the use-case. I know I acked adding page_po=
ol
> >> use-case to veth, for when we need to convert an SKB into an
> >> xdp_buff/xdp-frame, but maybe it was the wrong hammer(?).
> >> In this case in veth, the size is known at the page allocation time.
> >> Thus, using the page_pool API is wasting memory.  We did this for
> >> performance reasons, but we are not using PP for what is was intended
> >> for.  We mostly use page_pool, because it an existing recycle return
> >> path, and we were too lazy to add another alloc-type (see enum
> >> xdp_mem_type).
> >>
> >> Maybe you/we can extend veth to use this dynamic size API, to show us
> >> that this is API is a better approach.  I will signup for benchmarking
> >> this (and coordinating with CC Maryam as she came with use-case we
> >> improved on).
> >
> > Thanks, let's find out if page pool is the right hammer for the
> > veth XDP case.
> >
> > Below is the change for veth using the new api in this patch.
> > Only compile test as I am not familiar enough with veth XDP and
> > testing environment for it.
> > Please try it if it is helpful.
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index 614f3e3efab0..8850394f1d29 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -736,7 +736,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth=
_rq *rq,
> >          if (skb_shared(skb) || skb_head_is_locked(skb) ||
> >              skb_shinfo(skb)->nr_frags ||
> >              skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> > -               u32 size, len, max_head_size, off;
> > +               u32 size, len, max_head_size, off, truesize, page_offse=
t;
> >                  struct sk_buff *nskb;
> >                  struct page *page;
> >                  int i, head_off;
> > @@ -752,12 +752,15 @@ static int veth_convert_skb_to_xdp_buff(struct ve=
th_rq *rq,
> >                  if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_si=
ze)
> >                          goto drop;
> >
> > +               size =3D min_t(u32, skb->len, max_head_size);
> > +               truesize =3D size;
> > +
> >                  /* Allocate skb head */
> > -               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > +               page =3D page_pool_dev_alloc(rq->page_pool, &page_offse=
t, &truesize);
>
> Maybe rename API to:
>
>   addr =3D netmem_alloc(rq->page_pool, &truesize);
>
> >                  if (!page)
> >                          goto drop;
> >
> > -               nskb =3D napi_build_skb(page_address(page), PAGE_SIZE);
> > +               nskb =3D napi_build_skb(page_address(page) + page_offse=
t, truesize);
>
> IMHO this illustrates that API is strange/funky.
> (I think this is what Alex Duyck is also pointing out).
>
> This is the memory (virtual) address "pointer":
>   addr =3D page_address(page) + page_offset
>
> This is what napi_build_skb() takes as input. (I looked at other users
> of napi_build_skb() whom all give a mem ptr "va" as arg.)
> So, why does your new API provide the "page" and not just the address?
>
> As proposed above:
>    addr =3D netmem_alloc(rq->page_pool, &truesize);
>
> Maybe the API should be renamed, to indicate this isn't returning a "page=
"?
> We have talked about the name "netmem" before.

Yeah, this is more-or-less what I was getting at. Keep in mind this is
likely the most common case since most frames passed and forth aren't
ever usually much larger than 1500B.

> >                  if (!nskb) {
> >                          page_pool_put_full_page(rq->page_pool, page, t=
rue);
> >                          goto drop;
> > @@ -767,7 +770,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth=
_rq *rq,
> >                  skb_copy_header(nskb, skb);
> >                  skb_mark_for_recycle(nskb);
> >
> > -               size =3D min_t(u32, skb->len, max_head_size);
> >                  if (skb_copy_bits(skb, 0, nskb->data, size)) {
> >                          consume_skb(nskb);
> >                          goto drop;
> > @@ -782,14 +784,17 @@ static int veth_convert_skb_to_xdp_buff(struct ve=
th_rq *rq,
> >                  len =3D skb->len - off;
> >
> >                  for (i =3D 0; i < MAX_SKB_FRAGS && off < skb->len; i++=
) {
> > -                       page =3D page_pool_dev_alloc_pages(rq->page_poo=
l);
> > +                       size =3D min_t(u32, len, PAGE_SIZE);
> > +                       truesize =3D size;
> > +
> > +                       page =3D page_pool_dev_alloc(rq->page_pool, &pa=
ge_offset,
> > +                                                  &truesize);
> >                          if (!page) {
> >                                  consume_skb(nskb);
> >                                  goto drop;
> >                          }
> >
> > -                       size =3D min_t(u32, len, PAGE_SIZE);
> > -                       skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SI=
ZE);
> > +                       skb_add_rx_frag(nskb, i, page, page_offset, siz=
e, truesize);
>
> Guess, this shows the opposite; that the "page" _is_ used by the
> existing API.

This is a sort-of. One thing that has come up as of late is that all
this stuff is being moved over to folios anyway and getting away from
pages. In addition I am not sure how often we are having to take this
path as I am not sure how many non-Tx frames end up having to have
fragments added to them. For something like veth it might be more
common though since Tx becomes Rx in this case.

One thought I had on this is that we could look at adding a new
function that abstracts this away and makes use of netmem instead.
Then the whole page/folio thing would be that much further removed.

One other question I have now that I look at this code as well. Why is
it using page_pool and not just a frag cache allocator, or pages
themselves? It doesn't seem like it has a DMA mapping to deal with
since this is essentially copy-break code. Seems problematic that
there is no DMA involved here at all. This could be more easily
handled with just a single page_frag_cache style allocator.

