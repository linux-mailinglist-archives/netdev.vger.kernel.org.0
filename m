Return-Path: <netdev+bounces-6007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0F671457F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B032B280E08
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8721106;
	Mon, 29 May 2023 07:29:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB8AA5C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:29:45 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F446B2;
	Mon, 29 May 2023 00:29:41 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2af20198f20so30311431fa.0;
        Mon, 29 May 2023 00:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685345379; x=1687937379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TuyYcu8t+w4tBaiuC6qtUy6PrdNxgiYYt2fH8+OWVDY=;
        b=QyZQ45wMo1H/zbmv5hl67s6/CQ/iTljYSFFQrpTwhPoSKo3Y8hcx0rtgxQr81Jdzwh
         XENE8WRNIT/SfwkQb/k7hwarAmqWGmTMniberK9F5KXA8oxRAqqY52+zIrNAUJHEU2rk
         5Z2UP1FSVWZM5ra4pGDgXOcEy941BjAASlxf71N2LdhyyrYZt5dos6SRHCvONPUivPuo
         mdY/0+6M4ukzeuf7AAZ0Mi1SOqy/bym8ZkWPENgI0yjNtNa6eloLhaC1JgyrljkexlvH
         1x4XE33mrfpX2BjGwqEG8S4kiEE2J+Su2S3BAA0fcZqbuBLVPJxD+QntLFy26wexSwBr
         vJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685345379; x=1687937379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TuyYcu8t+w4tBaiuC6qtUy6PrdNxgiYYt2fH8+OWVDY=;
        b=ZyLSuzOLbJmzKY4Wu17MZZcYM5hS7Y39GrNdXfJ5jB4ax5KkIgPJzoilbBxKDvMbUc
         5YbHGmh3pGtb2z0yqVAI1nzbri3W0TkegHW0A5dw3Mgt69j2T8C/OlnXe4waaB+OGF1N
         fBjraW9oWsEmLU/FobTGeDx2C1H0n5bFgFxGP/jRc0qSzACniNsqXRZPB+znOJI4Cac+
         2IlaTOX5onhfOVliV0eOuIaAHhAqxvMEmITfztg4EyzHaRej411vyCBpD2MxIqAKOq2i
         2vk5YpEBjB210hJNWvTVpaRkHgcwFyiKaEvkoEJ6JxCDpvPfoUzzoT1LWK/61uCP3lE2
         uu9g==
X-Gm-Message-State: AC+VfDyU4+bF86yvvaT20PSc3/SbSBFI/SMenLv4yYLoFsphEE35bE/A
	DiMgHD5BCsS4cWiKgWiI0BsCrhy4+tpexWfZ6qk=
X-Google-Smtp-Source: ACHHUZ5vNyF4W+5bG5UxT0wd2OAbCfY+GFjfWFElVoSmaPe5/FUy0nqfBFTkIsivhWe5c+qh/DptkgT6RTS5OOYlWCY=
X-Received: by 2002:a2e:94c3:0:b0:2ad:9a11:b131 with SMTP id
 r3-20020a2e94c3000000b002ad9a11b131mr3432418ljh.32.1685345379171; Mon, 29 May
 2023 00:29:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-3-liangchen.linux@gmail.com> <20230528022057-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230528022057-mutt-send-email-mst@kernel.org>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Mon, 29 May 2023 15:29:26 +0800
Message-ID: <CAKhg4tKrG=G6VGUsBK-ykypioWiEydR8z_w_xJiKdPrnKA9xjA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation support
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 2:25=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, May 26, 2023 at 01:46:19PM +0800, Liang Chen wrote:
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
>
> I think it's called fragmenting not fragmentation.
>
>

Sure, thanks!

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
>
> So here again same questions.
>
> -when is this a net perf gain when does it have no effect?
> -can be on by default
> - can we get rid of the extra modes?
>
>

Yeah, now I believe it makes sense to enable it by default to avoid
the extra modes. Thanks.


> > @@ -909,23 +911,32 @@ static struct page *xdp_linearize_page(struct rec=
eive_queue *rq,
> >                                      struct page *p,
> >                                      int offset,
> >                                      int page_off,
> > -                                    unsigned int *len)
> > +                                    unsigned int *len,
> > +                                        unsigned int *pp_frag_offset)
> >  {
> >       int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> >       struct page *page;
> > +     unsigned int pp_frag_offset_val;
> >
> >       if (page_off + *len + tailroom > PAGE_SIZE)
> >               return NULL;
> >
> >       if (rq->page_pool)
> > -             page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > +             if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
> > +                     page =3D page_pool_dev_alloc_frag(rq->page_pool, =
pp_frag_offset,
> > +                                                     PAGE_SIZE);
> > +             else
> > +                     page =3D page_pool_dev_alloc_pages(rq->page_pool)=
;
> >       else
> >               page =3D alloc_page(GFP_ATOMIC);
> >
> >       if (!page)
> >               return NULL;
> >
> > -     memcpy(page_address(page) + page_off, page_address(p) + offset, *=
len);
> > +     pp_frag_offset_val =3D pp_frag_offset ? *pp_frag_offset : 0;
> > +
> > +     memcpy(page_address(page) + page_off + pp_frag_offset_val,
> > +            page_address(p) + offset, *len);
> >       page_off +=3D *len;
> >
> >       while (--*num_buf) {
> > @@ -948,7 +959,7 @@ static struct page *xdp_linearize_page(struct recei=
ve_queue *rq,
> >                       goto err_buf;
> >               }
> >
> > -             memcpy(page_address(page) + page_off,
> > +             memcpy(page_address(page) + page_off + pp_frag_offset_val=
,
> >                      page_address(p) + off, buflen);
> >               page_off +=3D buflen;
> >               virtnet_put_page(rq, p);
> > @@ -1029,7 +1040,7 @@ static struct sk_buff *receive_small_xdp(struct n=
et_device *dev,
> >                       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> >               xdp_page =3D xdp_linearize_page(rq, &num_buf, page,
> >                                             offset, header_offset,
> > -                                           &tlen);
> > +                                           &tlen, NULL);
> >               if (!xdp_page)
> >                       goto err_xdp;
> >
> > @@ -1323,6 +1334,7 @@ static void *mergeable_xdp_get_buf(struct virtnet=
_info *vi,
> >       unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
> >       struct page *xdp_page;
> >       unsigned int xdp_room;
> > +     unsigned int page_frag_offset =3D 0;
> >
> >       /* Transient failure which in theory could occur if
> >        * in-flight packets from before XDP was enabled reach
> > @@ -1356,7 +1368,8 @@ static void *mergeable_xdp_get_buf(struct virtnet=
_info *vi,
> >               xdp_page =3D xdp_linearize_page(rq, num_buf,
> >                                             *page, offset,
> >                                             VIRTIO_XDP_HEADROOM,
> > -                                           len);
> > +                                           len,
> > +                                               &page_frag_offset);
> >               if (!xdp_page)
> >                       return NULL;
> >       } else {
> > @@ -1366,14 +1379,19 @@ static void *mergeable_xdp_get_buf(struct virtn=
et_info *vi,
> >                       return NULL;
> >
> >               if (rq->page_pool)
> > -                     xdp_page =3D page_pool_dev_alloc_pages(rq->page_p=
ool);
> > +                     if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
> > +                             xdp_page =3D page_pool_dev_alloc_frag(rq-=
>page_pool,
> > +                                                                 &page=
_frag_offset, PAGE_SIZE);
> > +                     else
> > +                             xdp_page =3D page_pool_dev_alloc_pages(rq=
->page_pool);
> >               else
> >                       xdp_page =3D alloc_page(GFP_ATOMIC);
> > +
> >               if (!xdp_page)
> >                       return NULL;
> >
> > -             memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> > -                    page_address(*page) + offset, *len);
> > +             memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM +
> > +                             page_frag_offset, page_address(*page) + o=
ffset, *len);
> >       }
> >
> >       *frame_sz =3D PAGE_SIZE;
> > @@ -1382,7 +1400,7 @@ static void *mergeable_xdp_get_buf(struct virtnet=
_info *vi,
> >
> >       *page =3D xdp_page;
> >
> > -     return page_address(*page) + VIRTIO_XDP_HEADROOM;
> > +     return page_address(*page) + VIRTIO_XDP_HEADROOM + page_frag_offs=
et;
> >  }
> >
> >  static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
> > @@ -1762,6 +1780,7 @@ static int add_recvbuf_mergeable(struct virtnet_i=
nfo *vi,
> >       void *ctx;
> >       int err;
> >       unsigned int len, hole;
> > +     unsigned int pp_frag_offset;
> >
> >       /* Extra tailroom is needed to satisfy XDP's assumption. This
> >        * means rx frags coalescing won't work, but consider we've
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
> > --
> > 2.31.1
>

