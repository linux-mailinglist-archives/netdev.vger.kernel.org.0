Return-Path: <netdev+bounces-11567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAD4733A31
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108CF281810
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CA61ED33;
	Fri, 16 Jun 2023 19:51:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0811B914;
	Fri, 16 Jun 2023 19:51:10 +0000 (UTC)
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CAF10D8;
	Fri, 16 Jun 2023 12:51:09 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6b2a875b1bfso1034950a34.0;
        Fri, 16 Jun 2023 12:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686945069; x=1689537069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9zzEEj6Ru4Fm1HSJuqWBF8VhshQnF/wyKEfY2wv1tA=;
        b=r0dNBcpyOeBi6Vgfwh2pYFHlJkK6/Xse+jrzq6beCOE8c9nYYWr2p63qij04h4YVPk
         nasSLtzUYuWyYk8nto8eciiy+YjsIaq7kn7hAv8R81E44xQEC9uvkF82g967fy0y9zSu
         l7gckS1bEuo6QLrEvsQnR06PI3h+3kbPVncleHXUio80Xgx9T0HFSuWzukyOFCcjwKDR
         RKjQ2fVX4UXTfTJ4TjLZnBK2lb7685CJPgOxqtwnYEPkqBlmgFI9r+N+1RuebOJzgIJu
         QnLacoGk5x6NfLt+ZctTB4VIYYrfTGK5ldkOYD91dYTaqPbdrqfXZktwrHNiW9gs6JUG
         xbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686945069; x=1689537069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9zzEEj6Ru4Fm1HSJuqWBF8VhshQnF/wyKEfY2wv1tA=;
        b=KuYGbE7i/d+ekofu3jvTNi9g4cDndbM22+wrd4qHxfY2EYHBKK4UO5D9twZrLMm5RT
         Z24NPnnHSkpnPYAlDhz1D4xf0UGi5aQ6/O7m1yXRNXI5C3jOnPDIH7pPkeesgdaG8z7w
         xfLKBNJizfMOMnO9VD5zCIlits6GpfzmRMOT+WTQl8U5mod4jZpZHq9sycwL5tl3MM6G
         vhOqBxUzYxc4Hgum5IEUL8R8DNcLwAoAGWsO5lxkE9yG+BV1iiiggU3oenSTYRJ4DYAb
         y+oALl7z09tUKahlIuUiCIjpGMlU+yvCBffujL6QkvrSNTLm3WaokP5p27Wfk0Fjm0K0
         tGqg==
X-Gm-Message-State: AC+VfDzoDRNn5TvDfIfkCtFlCP83QeOaN/FmN1mMoj2XCljMRXPnMb2u
	dV+fqCxKbgJY1vQRmQhLYVLHRkvS9BBxL+ZP6bh+RVR5
X-Google-Smtp-Source: ACHHUZ7w0/SOCzXdPf9VVP222BYR2I0YN9fpAsy5jkzxhe41T0H3TvOG4/6NLyM8r87M9NGi0iQK2HxcUjUkrB/IAls=
X-Received: by 2002:a05:6830:60c:b0:6b4:4b80:bb89 with SMTP id
 w12-20020a056830060c00b006b44b80bb89mr271855oti.15.1686945068679; Fri, 16 Jun
 2023 12:51:08 -0700 (PDT)
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
 <f8ce176f-f975-af11-641c-b56c53a8066a@redhat.com> <CAKgT0UfzP30OiBQu+YKefLD+=32t+oA6KGzkvsW6k7CMTXU8KA@mail.gmail.com>
 <699563f5-c4fa-0246-5e79-61a29e1a8db3@redhat.com>
In-Reply-To: <699563f5-c4fa-0246-5e79-61a29e1a8db3@redhat.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 16 Jun 2023 12:50:31 -0700
Message-ID: <CAKgT0UcNOYwxRP_zkaBaZh-VBL-CriL8dFG-VY7-FUyzxfHDWw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc() API
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: brouer@redhat.com, Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, 
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

On Fri, Jun 16, 2023 at 11:41=E2=80=AFAM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 16/06/2023 19.34, Alexander Duyck wrote:
> > On Fri, Jun 16, 2023 at 9:31=E2=80=AFAM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >>
> >>
> >> On 16/06/2023 13.57, Yunsheng Lin wrote:
> >>> On 2023/6/16 0:19, Jesper Dangaard Brouer wrote:

[...]

>
>
> >>>                   if (!nskb) {
> >>>                           page_pool_put_full_page(rq->page_pool, page=
, true);
> >>>                           goto drop;
> >>> @@ -767,7 +770,6 @@ static int veth_convert_skb_to_xdp_buff(struct ve=
th_rq *rq,
> >>>                   skb_copy_header(nskb, skb);
> >>>                   skb_mark_for_recycle(nskb);
> >>>
> >>> -               size =3D min_t(u32, skb->len, max_head_size);
> >>>                   if (skb_copy_bits(skb, 0, nskb->data, size)) {
> >>>                           consume_skb(nskb);
> >>>                           goto drop;
> >>> @@ -782,14 +784,17 @@ static int veth_convert_skb_to_xdp_buff(struct =
veth_rq *rq,
> >>>                   len =3D skb->len - off;
> >>>
> >>>                   for (i =3D 0; i < MAX_SKB_FRAGS && off < skb->len; =
i++) {
> >>> -                       page =3D page_pool_dev_alloc_pages(rq->page_p=
ool);
> >>> +                       size =3D min_t(u32, len, PAGE_SIZE);
> >>> +                       truesize =3D size;
> >>> +
> >>> +                       page =3D page_pool_dev_alloc(rq->page_pool, &=
page_offset,
> >>> +                                                  &truesize);
> >>>                           if (!page) {
> >>>                                   consume_skb(nskb);
> >>>                                   goto drop;
> >>>                           }
> >>>
> >>> -                       size =3D min_t(u32, len, PAGE_SIZE);
> >>> -                       skb_add_rx_frag(nskb, i, page, 0, size, PAGE_=
SIZE);
> >>> +                       skb_add_rx_frag(nskb, i, page, page_offset, s=
ize, truesize);
> >>
> >> Guess, this shows the opposite; that the "page" _is_ used by the
> >> existing API.
> >
> > This is a sort-of. One thing that has come up as of late is that all
> > this stuff is being moved over to folios anyway and getting away from
> > pages. In addition I am not sure how often we are having to take this
> > path as I am not sure how many non-Tx frames end up having to have
> > fragments added to them. For something like veth it might be more
> > common though since Tx becomes Rx in this case.
>
> I'm thinking, that is it very unlikely that XDP have modified the
> fragments.  So, why are we allocating and copying the fragments?
> Wouldn't it be possible for this veth code to bump the refcnt on these
> fragments? (maybe I missed some detail).

From what I can tell this is an exception case with multiple caveats
for shared, locked, or nonlinear frames.

As such I suspect there may be some deprecated cases in there too
since XDP multi-buf support has been around for a while so the code
shouldn't need to reallocate to linearize a nonlinear frame.

> >
> > One other question I have now that I look at this code as well. Why is
> > it using page_pool and not just a frag cache allocator, or pages
> > themselves? It doesn't seem like it has a DMA mapping to deal with
> > since this is essentially copy-break code. Seems problematic that
> > there is no DMA involved here at all. This could be more easily
> > handled with just a single page_frag_cache style allocator.
> >
>
> Yes, precisely.
> I distinctly remember what I tried to poke you and Eric on this approach
> earlier, but I cannot find a link to that email.
>
> I would really appreciate, if you Alex, could give the approach in
> veth_convert_skb_to_xdp_buff() some review, as I believe that is a huge
> potential for improvements that will lead to large performance
> improvements. (I'm sure Maryam will be eager to help re-test performance
> for her use-cases).

Well just looking at it the quick and dirty answer would be to look at
making use of something like page_frag_cache. I won't go into details
since it isn't too different from the frag allocator, but it is much
simpler since it is just doing reference count hacks instead of having
to do the extra overhead to keep the DMA mapping in place. The veth
would then just be sitting on at most an order 3 page while it is
waiting to fully consume it rather than waiting on a full pool of
pages.

Alternatively it could do something similar to page_frag_alloc_align
itself and just bypass doing a custom allocator. If it went that route
it could do something almost like a ring buffer and greatly improve
the throughput since it would be able to allocate a higher order page
and just copy the entire skb in so the entire thing would be linear
rather than having to allocate a bunch of single pages.

