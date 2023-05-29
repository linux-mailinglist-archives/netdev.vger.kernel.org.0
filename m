Return-Path: <netdev+bounces-6008-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD509714583
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F7EB1C20985
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250041106;
	Mon, 29 May 2023 07:30:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0771845
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:30:50 +0000 (UTC)
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D91C2;
	Mon, 29 May 2023 00:30:47 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2af7081c9ebso31146331fa.1;
        Mon, 29 May 2023 00:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685345446; x=1687937446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KkQR+d/C0t4pr2zOXjJaFErA6sOw3jBbv3bylMF2rR0=;
        b=KUGYnnqkhgvFGl58FkNAhMlDzkvhonDqsoQhRLI1s8oxEQ67h1hT33TL++G/ZKv3B7
         S22RhBI+D35LeaNUElckO20icpcDV6sm2Fof9t8SQhofVuAKRy+sXPB0oS1iLWGYT4KE
         kn+4TJRAYEoUGt348r9aurInGIvn3Opi4jhW2Qf0cxX6BnRwnLSg3ci8uN4nQZ3kgElG
         RA2cu1y1pg///n5yli3ik5h40JaI0V3wnOafHUWAn9YaTB3nr8oGbgemt6snM22LyolS
         HY5Xq9cD1nrtoEpAy3eFUP8M7eciNY9J6hjwDRZd8BfQBf0Aif1809MKr+xdqsUPexqh
         3RoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685345446; x=1687937446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KkQR+d/C0t4pr2zOXjJaFErA6sOw3jBbv3bylMF2rR0=;
        b=iMPIfz6/8PDfAkzjGtK3v7tBQnRVRIWl75p9zIz0hycEw+fREPn/SxuNrKJ6LeNdD2
         l8bJY6thD0cxHoc68Zr10+cMQnG5mNobtu57V1IBvP7OnmC3SSHTmebb//y+Vz2h89UI
         rmUTSQAm4XJxrvtyTScSNRPbzF2Frvb+Er+unvjEGMKVI1rsO/GAwIJz6dKQpny5KIXG
         +jfqpx+6KKVzd5voI7I6HJpthfZRdhK2Zfqiw5f/6WB0+RNDStYsoOVN1aPqzc/grgq8
         MOur+BlXKOM2yINrFmBnPhYQFNNqMeXhuMJHBajpgrbVOMt/WVh/9bxbL0IaZQYpYvEg
         ejww==
X-Gm-Message-State: AC+VfDy9ZmaSqM6dOH6bZLwV2yRcjTOlYBNn4i/kf5GffRscw6D+/jXJ
	g50ZMKe/+znzsf6O4CWR9+t+6ZaX9SzyrjET+B8=
X-Google-Smtp-Source: ACHHUZ5fyk5q2VGIGCKNtRJ3q3BjJwatfRZbDcOb102v983t1V37Fydyqhu07yyVO78XQYV6dPBic+n6saDa8yt+x2Q=
X-Received: by 2002:a2e:9d96:0:b0:2af:32a7:4eef with SMTP id
 c22-20020a2e9d96000000b002af32a74eefmr3221080ljj.35.1685345445653; Mon, 29
 May 2023 00:30:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-3-liangchen.linux@gmail.com> <992eb402-43f9-0289-f95c-b41cb17f2e59@huawei.com>
In-Reply-To: <992eb402-43f9-0289-f95c-b41cb17f2e59@huawei.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Mon, 29 May 2023 15:30:33 +0800
Message-ID: <CAKhg4tL9PrUebqQHL+s7A6-xqNnju3erNQejMr7UFjwTaOduZw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation support
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: jasowang@redhat.com, mst@redhat.com, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com, kuba@kernel.org, 
	edumazet@google.com, davem@davemloft.net, pabeni@redhat.com, 
	alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 9:33=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> On 2023/5/26 13:46, Liang Chen wrote:
>
> ...
>
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 99c0ca0c1781..ac40b8c66c59 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -32,7 +32,9 @@ module_param(gso, bool, 0444);
> >  module_param(napi_tx, bool, 0644);
> >
> >  static bool page_pool_enabled;
> > +static bool page_pool_frag;
> >  module_param(page_pool_enabled, bool, 0400);
> > +module_param(page_pool_frag, bool, 0400);
>
> The below patchset unifies the frag and non-frag page for
> page_pool_alloc_frag() API, perhaps it would simplify the
> driver's support of page pool.
>
> https://patchwork.kernel.org/project/netdevbpf/cover/20230526092616.40355=
-1-linyunsheng@huawei.com/
>

Thanks for the information and the work to make driver support easy. I
will rebase accordingly after it lands.

> >
>
> ...
>
> > @@ -1769,13 +1788,29 @@ static int add_recvbuf_mergeable(struct virtnet=
_info *vi,
> >        */
> >       len =3D get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
> >       if (rq->page_pool) {
> > -             struct page *page;
> > +             if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG) {
> > +                     if (unlikely(!page_pool_dev_alloc_frag(rq->page_p=
ool,
> > +                                                            &pp_frag_o=
ffset, len + room)))
> > +                             return -ENOMEM;
> > +                     buf =3D (char *)page_address(rq->page_pool->frag_=
page) +
> > +                             pp_frag_offset;
> > +                     buf +=3D headroom; /* advance address leaving hol=
e at front of pkt */
> > +                     hole =3D (PAGE_SIZE << rq->page_pool->p.order)
> > +                             - rq->page_pool->frag_offset;
> > +                     if (hole < len + room) {
> > +                             if (!headroom)
> > +                                     len +=3D hole;
> > +                             rq->page_pool->frag_offset +=3D hole;
>
> Is there any reason why the driver need to be aware of page_pool->frag_of=
fset?
> Isn't the page_pool_dev_alloc_frag() will drain the last page for you whe=
n
> page_pool_dev_alloc_frag() is called with size being 'len + room' later?
> One case I can think of needing this is to have an accurate truesize repo=
rt
> for skb, but I am not sure it matters that much as 'struct page_frag_cach=
e'
> and 'page_frag' implementation both have a similar problem.
>

Yeah, as you pointed out page_pool_dev_alloc_frag will drain the page
itself, so does skb_page_frag_refill. This is trying to keep the logic
consistent with non page pool case where the hole was skipped and
included in buffer len.

> > +                     }
> > +             } else {
> > +                     struct page *page;
> >
> > -             page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > -             if (unlikely(!page))
> > -                     return -ENOMEM;
> > -             buf =3D (char *)page_address(page);
> > -             buf +=3D headroom; /* advance address leaving hole at fro=
nt of pkt */
> > +                     page =3D page_pool_dev_alloc_pages(rq->page_pool)=
;
> > +                     if (unlikely(!page))
> > +                             return -ENOMEM;
> > +                     buf =3D (char *)page_address(page);
> > +                     buf +=3D headroom; /* advance address leaving hol=
e at front of pkt */
> > +             }
> >       } else {
> >               if (unlikely(!skb_page_frag_refill(len + room, alloc_frag=
, gfp)))
> >                       return -ENOMEM;
> > @@ -3800,13 +3835,16 @@ static void virtnet_alloc_page_pool(struct rece=
ive_queue *rq)
> >       struct virtio_device *vdev =3D rq->vq->vdev;
> >
> >       struct page_pool_params pp_params =3D {
> > -             .order =3D 0,
> > +             .order =3D page_pool_frag ? SKB_FRAG_PAGE_ORDER : 0,
> >               .pool_size =3D rq->vq->num_max,
>
> If it using order SKB_FRAG_PAGE_ORDER page, perhaps pool_size does
> not have to be rq->vq->num_max? Even for order 0 page, perhaps the
> pool_size does not need to be as big as rq->vq->num_max?
>

Thanks for pointing this out! pool_size will be lowered to a more
appropriate value on v2.


> >               .nid =3D dev_to_node(vdev->dev.parent),
> >               .dev =3D vdev->dev.parent,
> >               .offset =3D 0,
> >       };
> >
> > +     if (page_pool_frag)
> > +             pp_params.flags |=3D PP_FLAG_PAGE_FRAG;
> > +
> >       rq->page_pool =3D page_pool_create(&pp_params);
> >       if (IS_ERR(rq->page_pool)) {
> >               dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
> >

