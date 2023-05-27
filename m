Return-Path: <netdev+bounces-5897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B96EF7134CA
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 630F31C208BA
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5873FF9E2;
	Sat, 27 May 2023 12:36:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612C11C95
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:36:41 +0000 (UTC)
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FF5E41;
	Sat, 27 May 2023 05:36:25 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2afb2874e83so17592071fa.0;
        Sat, 27 May 2023 05:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685190983; x=1687782983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxM+okH8Wp1cmzKMTX/bhdgz/6xLhieWnxN6AooLVdk=;
        b=SOFBINV4tAoZFH6dmb0gL0gHL6TEKuKbaNktI/ukzf/sMwhe8aA4bfB6zJVgqVjjzF
         uc3hBuxEGEM2RxkCKKCHdSkuttRdiKyeKTxYst2WGnZUAcoC0ok0yf1KXs1i5AC1Y6/6
         tNIpCVyED4VIWZMa4rlDIvuNKAc/TgpoUTg9xvhGwUcJ41rF94EAUWRqLkqW/Uc5wFZW
         Vpfj3X50b+KfGIdmPf60q6fzXUlJA9b1WWCZEe51a4mCOdhvxl05G1wDHxhahvMkO5ix
         bZ67QEmRUdlG8mFo27YGdOOXB/1tJ1e9hAXiTQQ6KGiN2EaxDgvzco7k0bA2YIfYQufc
         q/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685190983; x=1687782983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FxM+okH8Wp1cmzKMTX/bhdgz/6xLhieWnxN6AooLVdk=;
        b=EGGLt0ShYWdJ7SvWYPgltE3igNESEAQ/Snatjf/tUf0e1L7gpTxWOa9RBDEVsGF3eY
         l1wscO1R7r+bgfd2/IFN2/fgZlXMfVTHgUScYVK6siVCnemgzp/iPgVI5rYft97co52Y
         py/Sc9V/LWI+Z/2gJbZ0mWwspK9Oqlj93Slcy9KbHvlVS907u0U3DN4qmFnUtVEIAxE/
         XTxDn+upPPXo7Ft9BKr4UgXywg7oQIjRxgRzekTgCW6MardVYY5H27uwx9NHnnfS883s
         hwj4FCoEDpoDWQySSExBsZ5xkYn8o/TiVkURXYzFG+kjspihsDgv8g/Evp93m3lVo6f5
         kfMA==
X-Gm-Message-State: AC+VfDwrJLKjy7mksSmEbEsopxEuixrugzf2yKAhhnYNhgf2zQsx56Li
	CII96t03Ukoaqi2giXHV4b1VdLnHIa1rNRG2wbE=
X-Google-Smtp-Source: ACHHUZ7OuABIcwSNWgUsK3FDFoEdmht2OkP913Caao+3TZAI2PrzU3gPTUOIj0vFn/3mpU/mLY/Fey5TLkdwRLm7dBs=
X-Received: by 2002:a2e:968c:0:b0:2ab:16a6:b330 with SMTP id
 q12-20020a2e968c000000b002ab16a6b330mr1750644lji.51.1685190983476; Sat, 27
 May 2023 05:36:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-3-liangchen.linux@gmail.com> <20230526082914.owofnszwdjgcjwhi@soft-dev3-1>
In-Reply-To: <20230526082914.owofnszwdjgcjwhi@soft-dev3-1>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Sat, 27 May 2023 20:36:09 +0800
Message-ID: <CAKhg4tJ-m52NVE6C+4H85krK5m84pERNDssq2hqXx9kUdEr08g@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation support
To: Horatiu Vultur <horatiu.vultur@microchip.com>
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

On Fri, May 26, 2023 at 4:29=E2=80=AFPM Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 05/26/2023 13:46, Liang Chen wrote:
>
> Hi Liang,
>
> >
> > To further enhance performance, implement page pool fragmentation
> > support and introduce a module parameter to enable or disable it.
> >
> > In single-core vm testing environments, there is an additional performa=
nce
> > gain observed in the normal path compared to the one packet per page
> > approach.
> >   Upstream codebase: 47.5 Gbits/sec
> >   Upstream codebase with page pool: 50.2 Gbits/sec
> >   Upstream codebase with page pool fragmentation support: 52.3 Gbits/se=
c
> >
> > There is also some performance gain for XDP cpumap.
> >   Upstream codebase: 1.38 Gbits/sec
> >   Upstream codebase with page pool: 9.74 Gbits/sec
> >   Upstream codebase with page pool fragmentation: 10.3 Gbits/sec
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > ---
> >  drivers/net/virtio_net.c | 72 ++++++++++++++++++++++++++++++----------
> >  1 file changed, 55 insertions(+), 17 deletions(-)
> >
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
> >
> >  /* FIXME: MTU in config. */
> >  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> > @@ -909,23 +911,32 @@ static struct page *xdp_linearize_page(struct rec=
eive_queue *rq,
> >                                        struct page *p,
> >                                        int offset,
> >                                        int page_off,
> > -                                      unsigned int *len)
> > +                                      unsigned int *len,
> > +                                          unsigned int *pp_frag_offset=
)
>
> The 'unsigned int *pp_frag_offset' seems to be unaligned.
>

Sure, Thanks!
> >  {
> >         int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info))=
;
> >         struct page *page;
> > +       unsigned int pp_frag_offset_val;
>
> Please use reverse christmas tree notation here. The pp_frag_offset_val
> needs to be declared before page;
>

Sure. Will do on v2.
> >
> >         if (page_off + *len + tailroom > PAGE_SIZE)
> >                 return NULL;
> >
> >         if (rq->page_pool)
> > -               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > +               if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
> > +                       page =3D page_pool_dev_alloc_frag(rq->page_pool=
, pp_frag_offset,
> > +                                                       PAGE_SIZE);
>
> Don't you need to check if pp_frag_offset is null? As you call once with
> NULL.
>

At the moment, page_pool is enabled only for mergeable mode, and the
path leading to a call with NULL pp_frag_offset is from small mode.
But I will evaluate again whether it is beneficial to support
page_pool for small mode on v2. Thanks.
> > +               else
> > +                       page =3D page_pool_dev_alloc_pages(rq->page_poo=
l);
> >         else
> >                 page =3D alloc_page(GFP_ATOMIC);
> >
> >         if (!page)
> >                 return NULL;
> >
> > -       memcpy(page_address(page) + page_off, page_address(p) + offset,=
 *len);
> > +       pp_frag_offset_val =3D pp_frag_offset ? *pp_frag_offset : 0;
> > +
> > +       memcpy(page_address(page) + page_off + pp_frag_offset_val,
> > +              page_address(p) + offset, *len);
> >         page_off +=3D *len;
> >
> >         while (--*num_buf) {
> > @@ -948,7 +959,7 @@ static struct page *xdp_linearize_page(struct recei=
ve_queue *rq,
> >                         goto err_buf;
> >                 }
> >
> > -               memcpy(page_address(page) + page_off,
> > +               memcpy(page_address(page) + page_off + pp_frag_offset_v=
al,
> >                        page_address(p) + off, buflen);
> >                 page_off +=3D buflen;
> >                 virtnet_put_page(rq, p);
> > @@ -1029,7 +1040,7 @@ static struct sk_buff *receive_small_xdp(struct n=
et_device *dev,
> >                         SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> >                 xdp_page =3D xdp_linearize_page(rq, &num_buf, page,
> >                                               offset, header_offset,
> > -                                             &tlen);
> > +                                             &tlen, NULL);
> >                 if (!xdp_page)
> >                         goto err_xdp;
> >
> > @@ -1323,6 +1334,7 @@ static void *mergeable_xdp_get_buf(struct virtnet=
_info *vi,
> >         unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
> >         struct page *xdp_page;
> >         unsigned int xdp_room;
> > +       unsigned int page_frag_offset =3D 0;
>
> Please use reverse x-mas tree notation.
>

Sure. Will do on v2.
> >
> >         /* Transient failure which in theory could occur if
> >          * in-flight packets from before XDP was enabled reach
> > @@ -1356,7 +1368,8 @@ static void *mergeable_xdp_get_buf(struct virtnet=
_info *vi,
> >                 xdp_page =3D xdp_linearize_page(rq, num_buf,
> >                                               *page, offset,
> >                                               VIRTIO_XDP_HEADROOM,
> > -                                             len);
> > +                                             len,
> > +                                                 &page_frag_offset);
>
> You have also here some misalignment with regards to page_frag_offset.
>

Sure, Thanks!
> >                 if (!xdp_page)
> >                         return NULL;
> >         } else {
> > @@ -1366,14 +1379,19 @@ static void *mergeable_xdp_get_buf(struct virtn=
et_info *vi,
> >                         return NULL;
> >
> >                 if (rq->page_pool)
> > -                       xdp_page =3D page_pool_dev_alloc_pages(rq->page=
_pool);
> > +                       if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
> > +                               xdp_page =3D page_pool_dev_alloc_frag(r=
q->page_pool,
> > +                                                                   &pa=
ge_frag_offset, PAGE_SIZE);
> > +                       else
> > +                               xdp_page =3D page_pool_dev_alloc_pages(=
rq->page_pool);
> >                 else
> >                         xdp_page =3D alloc_page(GFP_ATOMIC);
> > +
> >                 if (!xdp_page)
> >                         return NULL;
> >
> > -               memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> > -                      page_address(*page) + offset, *len);
> > +               memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM +
> > +                               page_frag_offset, page_address(*page) +=
 offset, *len);
> >         }
> >
> >         *frame_sz =3D PAGE_SIZE;
> > @@ -1382,7 +1400,7 @@ static void *mergeable_xdp_get_buf(struct virtnet=
_info *vi,
> >
> >         *page =3D xdp_page;
> >
> > -       return page_address(*page) + VIRTIO_XDP_HEADROOM;
> > +       return page_address(*page) + VIRTIO_XDP_HEADROOM + page_frag_of=
fset;
> >  }
> >
> >  static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
> > @@ -1762,6 +1780,7 @@ static int add_recvbuf_mergeable(struct virtnet_i=
nfo *vi,
> >         void *ctx;
> >         int err;
> >         unsigned int len, hole;
> > +       unsigned int pp_frag_offset;
>
> There same here.
>

Sure, Thanks!

> >
> >         /* Extra tailroom is needed to satisfy XDP's assumption. This
> >          * means rx frags coalescing won't work, but consider we've
> > @@ -1769,13 +1788,29 @@ static int add_recvbuf_mergeable(struct virtnet=
_info *vi,
> >          */
> >         len =3D get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
> >         if (rq->page_pool) {
> > -               struct page *page;
> > +               if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG) {
> > +                       if (unlikely(!page_pool_dev_alloc_frag(rq->page=
_pool,
> > +                                                              &pp_frag=
_offset, len + room)))
> > +                               return -ENOMEM;
> > +                       buf =3D (char *)page_address(rq->page_pool->fra=
g_page) +
> > +                               pp_frag_offset;
> > +                       buf +=3D headroom; /* advance address leaving h=
ole at front of pkt */
> > +                       hole =3D (PAGE_SIZE << rq->page_pool->p.order)
> > +                               - rq->page_pool->frag_offset;
> > +                       if (hole < len + room) {
> > +                               if (!headroom)
> > +                                       len +=3D hole;
> > +                               rq->page_pool->frag_offset +=3D hole;
> > +                       }
> > +               } else {
> > +                       struct page *page;
> >
> > -               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > -               if (unlikely(!page))
> > -                       return -ENOMEM;
> > -               buf =3D (char *)page_address(page);
> > -               buf +=3D headroom; /* advance address leaving hole at f=
ront of pkt */
> > +                       page =3D page_pool_dev_alloc_pages(rq->page_poo=
l);
> > +                       if (unlikely(!page))
> > +                               return -ENOMEM;
> > +                       buf =3D (char *)page_address(page);
> > +                       buf +=3D headroom; /* advance address leaving h=
ole at front of pkt */
> > +               }
> >         } else {
> >                 if (unlikely(!skb_page_frag_refill(len + room, alloc_fr=
ag, gfp)))
> >                         return -ENOMEM;
> > @@ -3800,13 +3835,16 @@ static void virtnet_alloc_page_pool(struct rece=
ive_queue *rq)
> >         struct virtio_device *vdev =3D rq->vq->vdev;
> >
> >         struct page_pool_params pp_params =3D {
> > -               .order =3D 0,
> > +               .order =3D page_pool_frag ? SKB_FRAG_PAGE_ORDER : 0,
> >                 .pool_size =3D rq->vq->num_max,
> >                 .nid =3D dev_to_node(vdev->dev.parent),
> >                 .dev =3D vdev->dev.parent,
> >                 .offset =3D 0,
> >         };
> >
> > +       if (page_pool_frag)
> > +               pp_params.flags |=3D PP_FLAG_PAGE_FRAG;
> > +
> >         rq->page_pool =3D page_pool_create(&pp_params);
> >         if (IS_ERR(rq->page_pool)) {
> >                 dev_warn(&vdev->dev, "page pool creation failed: %ld\n"=
,
> > --
> > 2.31.1
> >
> >
>
> --
> /Horatiu

