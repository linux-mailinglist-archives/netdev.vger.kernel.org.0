Return-Path: <netdev+bounces-6004-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A3C714570
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EA91280DD6
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE8EECB;
	Mon, 29 May 2023 07:28:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CCD809
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:28:14 +0000 (UTC)
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16693A6;
	Mon, 29 May 2023 00:28:11 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2af2f4e719eso31656591fa.2;
        Mon, 29 May 2023 00:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685345289; x=1687937289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDIUn7szt3oUTg98VtlKJJ/lmLURgK8HSXpwwAsfwfA=;
        b=ZsQGiE+/1L86OHLaExPLPJbNfQ2WkWZlqM0vcDzojVn2YZdFmcjUupDL3cag7u2kl2
         tw55/4qR0/FU4IIZKeTAYOTp9/79A8Pu6y9O2f307RhvILsNDpx+6jfVR29LfvTb11L0
         5CAaqvM/0lC9zd++rTsWmAiFUpI+oS1mfetSyoBKYZsvoOtJijfa6zYR9WQiCf2t40IE
         yZn9UuJVJr2uVFdWpcrE+LyPy4CbPg3pjeNwTn/DAPQ3BVn6lfkaquSZa3DH/Tb5Vbc7
         bcmalu6EhoCgN05Kjw8q/PDb6DLYhU6fYDtNz5IzfPeRRxQ9MUVNgQxAbHCLoicytyEm
         OG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685345289; x=1687937289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDIUn7szt3oUTg98VtlKJJ/lmLURgK8HSXpwwAsfwfA=;
        b=UBezDOEK1GotiOWpOGp4j2FHXeyfqPmONFvaCB4VSIbRYVHt7jjcAq1Ofwl1KxAnub
         rmgf4K+1NKBXUQJk3h6QB/51YUHQTOAZGHqefFRbYPPrUf5uqTh3cLcBFboX2EQVIlf5
         t0UabbJgyH9iGsylKEXEDtOPsD4zegulsNLo9TBjM9Nxxe/E+RdXxP9oPRiSTNIQManX
         lOICOqOA9RuQi8aMSyRFyWIjInwQovxGIYLaaZyRBcsUO86jVVA9TuRNNAWipx53VpB3
         Fin/nX8dqJXrUuQTbfYYS02O3ugLSSo/vHL3IMIKvBUB5hMh5cTXbK5NW7+hOadeUukh
         vtOA==
X-Gm-Message-State: AC+VfDy16L150H5N4m1LJMx1EV8UdqwK6dioKP8bdt4BAbPsF2tLWpHP
	viwbpAyc06N1IDQs97oYDDp2rq7jsFcvbHHQI1UvnrLft4Q=
X-Google-Smtp-Source: ACHHUZ5eHnGX4jlJbVYocQ1wcF0Q0p/x6g/4e92h9IQ7LtTCzJSK06938TVpX9CvbDsb0SMhRlTwffEW04YjaPb80gY=
X-Received: by 2002:a2e:7a03:0:b0:2af:164c:fe2 with SMTP id
 v3-20020a2e7a03000000b002af164c0fe2mr3695743ljc.5.1685345289069; Mon, 29 May
 2023 00:28:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-2-liangchen.linux@gmail.com> <20230528021708-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230528021708-mutt-send-email-mst@kernel.org>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Mon, 29 May 2023 15:27:56 +0800
Message-ID: <CAKhg4tKzW6akbKLvg1UFpey+Lkiic3hBWh87jyg-a8ASchPvMA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
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

On Sun, May 28, 2023 at 2:20=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, May 26, 2023 at 01:46:18PM +0800, Liang Chen wrote:
> > The implementation at the moment uses one page per packet in both the
> > normal and XDP path. In addition, introducing a module parameter to ena=
ble
> > or disable the usage of page pool (disabled by default).
> >
> > In single-core vm testing environments, it gives a modest performance g=
ain
> > in the normal path.
> >   Upstream codebase: 47.5 Gbits/sec
> >   Upstream codebase + page_pool support: 50.2 Gbits/sec
> >
> > In multi-core vm testing environments, The most significant performance
> > gain is observed in XDP cpumap:
> >   Upstream codebase: 1.38 Gbits/sec
> >   Upstream codebase + page_pool support: 9.74 Gbits/sec
> >
> > With this foundation, we can further integrate page pool fragmentation =
and
> > DMA map/unmap support.
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>
> Why off by default?
> I am guessing it sometimes has performance costs too?
>
>
> What happens if we use page pool for big mode too?
> The less modes we have the better...
>
>

Sure, now I believe it makes sense to enable it by default. When the
packet size is very small, it reduces the likelihood of skb
coalescing. But such cases are rare.
The usage of page pool for big mode is being evaluated now. Thanks!

> > ---
> >  drivers/net/virtio_net.c | 188 ++++++++++++++++++++++++++++++---------
> >  1 file changed, 146 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index c5dca0d92e64..99c0ca0c1781 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -31,6 +31,9 @@ module_param(csum, bool, 0444);
> >  module_param(gso, bool, 0444);
> >  module_param(napi_tx, bool, 0644);
> >
> > +static bool page_pool_enabled;
> > +module_param(page_pool_enabled, bool, 0400);
> > +
> >  /* FIXME: MTU in config. */
> >  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> >  #define GOOD_COPY_LEN        128
> > @@ -159,6 +162,9 @@ struct receive_queue {
> >       /* Chain pages by the private ptr. */
> >       struct page *pages;
> >
> > +     /* Page pool */
> > +     struct page_pool *page_pool;
> > +
> >       /* Average packet length for mergeable receive buffers. */
> >       struct ewma_pkt_len mrg_avg_pkt_len;
> >
> > @@ -459,6 +465,14 @@ static struct sk_buff *virtnet_build_skb(void *buf=
, unsigned int buflen,
> >       return skb;
> >  }
> >
> > +static void virtnet_put_page(struct receive_queue *rq, struct page *pa=
ge)
> > +{
> > +     if (rq->page_pool)
> > +             page_pool_put_full_page(rq->page_pool, page, true);
> > +     else
> > +             put_page(page);
> > +}
> > +
> >  /* Called from bottom half context */
> >  static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >                                  struct receive_queue *rq,
> > @@ -555,7 +569,7 @@ static struct sk_buff *page_to_skb(struct virtnet_i=
nfo *vi,
> >       hdr =3D skb_vnet_hdr(skb);
> >       memcpy(hdr, hdr_p, hdr_len);
> >       if (page_to_free)
> > -             put_page(page_to_free);
> > +             virtnet_put_page(rq, page_to_free);
> >
> >       return skb;
> >  }
> > @@ -802,7 +816,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
> >       return ret;
> >  }
> >
> > -static void put_xdp_frags(struct xdp_buff *xdp)
> > +static void put_xdp_frags(struct xdp_buff *xdp, struct receive_queue *=
rq)
> >  {
> >       struct skb_shared_info *shinfo;
> >       struct page *xdp_page;
> > @@ -812,7 +826,7 @@ static void put_xdp_frags(struct xdp_buff *xdp)
> >               shinfo =3D xdp_get_shared_info_from_buff(xdp);
> >               for (i =3D 0; i < shinfo->nr_frags; i++) {
> >                       xdp_page =3D skb_frag_page(&shinfo->frags[i]);
> > -                     put_page(xdp_page);
> > +                     virtnet_put_page(rq, xdp_page);
> >               }
> >       }
> >  }
> > @@ -903,7 +917,11 @@ static struct page *xdp_linearize_page(struct rece=
ive_queue *rq,
> >       if (page_off + *len + tailroom > PAGE_SIZE)
> >               return NULL;
> >
> > -     page =3D alloc_page(GFP_ATOMIC);
> > +     if (rq->page_pool)
> > +             page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > +     else
> > +             page =3D alloc_page(GFP_ATOMIC);
> > +
> >       if (!page)
> >               return NULL;
> >
> > @@ -926,21 +944,24 @@ static struct page *xdp_linearize_page(struct rec=
eive_queue *rq,
> >                * is sending packet larger than the MTU.
> >                */
> >               if ((page_off + buflen + tailroom) > PAGE_SIZE) {
> > -                     put_page(p);
> > +                     virtnet_put_page(rq, p);
> >                       goto err_buf;
> >               }
> >
> >               memcpy(page_address(page) + page_off,
> >                      page_address(p) + off, buflen);
> >               page_off +=3D buflen;
> > -             put_page(p);
> > +             virtnet_put_page(rq, p);
> >       }
> >
> >       /* Headroom does not contribute to packet length */
> >       *len =3D page_off - VIRTIO_XDP_HEADROOM;
> >       return page;
> >  err_buf:
> > -     __free_pages(page, 0);
> > +     if (rq->page_pool)
> > +             page_pool_put_full_page(rq->page_pool, page, true);
> > +     else
> > +             __free_pages(page, 0);
> >       return NULL;
> >  }
> >
> > @@ -1144,7 +1165,7 @@ static void mergeable_buf_free(struct receive_que=
ue *rq, int num_buf,
> >               }
> >               stats->bytes +=3D len;
> >               page =3D virt_to_head_page(buf);
> > -             put_page(page);
> > +             virtnet_put_page(rq, page);
> >       }
> >  }
> >
> > @@ -1264,7 +1285,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
device *dev,
> >               cur_frag_size =3D truesize;
> >               xdp_frags_truesz +=3D cur_frag_size;
> >               if (unlikely(len > truesize - room || cur_frag_size > PAG=
E_SIZE)) {
> > -                     put_page(page);
> > +                     virtnet_put_page(rq, page);
> >                       pr_debug("%s: rx error: len %u exceeds truesize %=
lu\n",
> >                                dev->name, len, (unsigned long)(truesize=
 - room));
> >                       dev->stats.rx_length_errors++;
> > @@ -1283,7 +1304,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_=
device *dev,
> >       return 0;
> >
> >  err:
> > -     put_xdp_frags(xdp);
> > +     put_xdp_frags(xdp, rq);
> >       return -EINVAL;
> >  }
> >
> > @@ -1344,7 +1365,10 @@ static void *mergeable_xdp_get_buf(struct virtne=
t_info *vi,
> >               if (*len + xdp_room > PAGE_SIZE)
> >                       return NULL;
> >
> > -             xdp_page =3D alloc_page(GFP_ATOMIC);
> > +             if (rq->page_pool)
> > +                     xdp_page =3D page_pool_dev_alloc_pages(rq->page_p=
ool);
> > +             else
> > +                     xdp_page =3D alloc_page(GFP_ATOMIC);
> >               if (!xdp_page)
> >                       return NULL;
> >
> > @@ -1354,7 +1378,7 @@ static void *mergeable_xdp_get_buf(struct virtnet=
_info *vi,
> >
> >       *frame_sz =3D PAGE_SIZE;
> >
> > -     put_page(*page);
> > +     virtnet_put_page(rq, *page);
> >
> >       *page =3D xdp_page;
> >
> > @@ -1400,6 +1424,8 @@ static struct sk_buff *receive_mergeable_xdp(stru=
ct net_device *dev,
> >               head_skb =3D build_skb_from_xdp_buff(dev, vi, &xdp, xdp_f=
rags_truesz);
> >               if (unlikely(!head_skb))
> >                       break;
> > +             if (rq->page_pool)
> > +                     skb_mark_for_recycle(head_skb);
> >               return head_skb;
> >
> >       case XDP_TX:
> > @@ -1410,10 +1436,10 @@ static struct sk_buff *receive_mergeable_xdp(st=
ruct net_device *dev,
> >               break;
> >       }
> >
> > -     put_xdp_frags(&xdp);
> > +     put_xdp_frags(&xdp, rq);
> >
> >  err_xdp:
> > -     put_page(page);
> > +     virtnet_put_page(rq, page);
> >       mergeable_buf_free(rq, num_buf, dev, stats);
> >
> >       stats->xdp_drops++;
> > @@ -1467,6 +1493,9 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >       head_skb =3D page_to_skb(vi, rq, page, offset, len, truesize, hea=
droom);
> >       curr_skb =3D head_skb;
> >
> > +     if (rq->page_pool)
> > +             skb_mark_for_recycle(curr_skb);
> > +
> >       if (unlikely(!curr_skb))
> >               goto err_skb;
> >       while (--num_buf) {
> > @@ -1509,6 +1538,8 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                       curr_skb =3D nskb;
> >                       head_skb->truesize +=3D nskb->truesize;
> >                       num_skb_frags =3D 0;
> > +                     if (rq->page_pool)
> > +                             skb_mark_for_recycle(curr_skb);
> >               }
> >               if (curr_skb !=3D head_skb) {
> >                       head_skb->data_len +=3D len;
> > @@ -1517,7 +1548,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >               }
> >               offset =3D buf - page_address(page);
> >               if (skb_can_coalesce(curr_skb, num_skb_frags, page, offse=
t)) {
> > -                     put_page(page);
> > +                     virtnet_put_page(rq, page);
> >                       skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
> >                                            len, truesize);
> >               } else {
> > @@ -1530,7 +1561,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >       return head_skb;
> >
> >  err_skb:
> > -     put_page(page);
> > +     virtnet_put_page(rq, page);
> >       mergeable_buf_free(rq, num_buf, dev, stats);
> >
> >  err_buf:
> > @@ -1737,31 +1768,40 @@ static int add_recvbuf_mergeable(struct virtnet=
_info *vi,
> >        * disabled GSO for XDP, it won't be a big issue.
> >        */
> >       len =3D get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
> > -     if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
> > -             return -ENOMEM;
> > +     if (rq->page_pool) {
> > +             struct page *page;
> >
> > -     buf =3D (char *)page_address(alloc_frag->page) + alloc_frag->offs=
et;
> > -     buf +=3D headroom; /* advance address leaving hole at front of pk=
t */
> > -     get_page(alloc_frag->page);
> > -     alloc_frag->offset +=3D len + room;
> > -     hole =3D alloc_frag->size - alloc_frag->offset;
> > -     if (hole < len + room) {
> > -             /* To avoid internal fragmentation, if there is very like=
ly not
> > -              * enough space for another buffer, add the remaining spa=
ce to
> > -              * the current buffer.
> > -              * XDP core assumes that frame_size of xdp_buff and the l=
ength
> > -              * of the frag are PAGE_SIZE, so we disable the hole mech=
anism.
> > -              */
> > -             if (!headroom)
> > -                     len +=3D hole;
> > -             alloc_frag->offset +=3D hole;
> > -     }
> > +             page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > +             if (unlikely(!page))
> > +                     return -ENOMEM;
> > +             buf =3D (char *)page_address(page);
> > +             buf +=3D headroom; /* advance address leaving hole at fro=
nt of pkt */
> > +     } else {
> > +             if (unlikely(!skb_page_frag_refill(len + room, alloc_frag=
, gfp)))
> > +                     return -ENOMEM;
> >
> > +             buf =3D (char *)page_address(alloc_frag->page) + alloc_fr=
ag->offset;
> > +             buf +=3D headroom; /* advance address leaving hole at fro=
nt of pkt */
> > +             get_page(alloc_frag->page);
> > +             alloc_frag->offset +=3D len + room;
> > +             hole =3D alloc_frag->size - alloc_frag->offset;
> > +             if (hole < len + room) {
> > +                     /* To avoid internal fragmentation, if there is v=
ery likely not
> > +                      * enough space for another buffer, add the remai=
ning space to
> > +                      * the current buffer.
> > +                      * XDP core assumes that frame_size of xdp_buff a=
nd the length
> > +                      * of the frag are PAGE_SIZE, so we disable the h=
ole mechanism.
> > +                      */
> > +                     if (!headroom)
> > +                             len +=3D hole;
> > +                     alloc_frag->offset +=3D hole;
> > +             }
> > +     }
> >       sg_init_one(rq->sg, buf, len);
> >       ctx =3D mergeable_len_to_ctx(len + room, headroom);
> >       err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp)=
;
> >       if (err < 0)
> > -             put_page(virt_to_head_page(buf));
> > +             virtnet_put_page(rq, virt_to_head_page(buf));
> >
> >       return err;
> >  }
> > @@ -1994,8 +2034,15 @@ static int virtnet_enable_queue_pair(struct virt=
net_info *vi, int qp_index)
> >       if (err < 0)
> >               return err;
> >
> > -     err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
> > -                                      MEM_TYPE_PAGE_SHARED, NULL);
> > +     if (vi->rq[qp_index].page_pool)
> > +             err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_=
rxq,
> > +                                              MEM_TYPE_PAGE_POOL,
> > +                                              vi->rq[qp_index].page_po=
ol);
> > +     else
> > +             err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_=
rxq,
> > +                                              MEM_TYPE_PAGE_SHARED,
> > +                                              NULL);
> > +
> >       if (err < 0)
> >               goto err_xdp_reg_mem_model;
> >
> > @@ -2951,6 +2998,7 @@ static void virtnet_get_strings(struct net_device=
 *dev, u32 stringset, u8 *data)
> >                               ethtool_sprintf(&p, "tx_queue_%u_%s", i,
> >                                               virtnet_sq_stats_desc[j].=
desc);
> >               }
> > +             page_pool_ethtool_stats_get_strings(p);
> >               break;
> >       }
> >  }
> > @@ -2962,12 +3010,30 @@ static int virtnet_get_sset_count(struct net_de=
vice *dev, int sset)
> >       switch (sset) {
> >       case ETH_SS_STATS:
> >               return vi->curr_queue_pairs * (VIRTNET_RQ_STATS_LEN +
> > -                                            VIRTNET_SQ_STATS_LEN);
> > +                                            VIRTNET_SQ_STATS_LEN +
> > +                                             (page_pool_enabled && vi-=
>mergeable_rx_bufs ?
> > +                                              page_pool_ethtool_stats_=
get_count() : 0));
> >       default:
> >               return -EOPNOTSUPP;
> >       }
> >  }
> >
> > +static void virtnet_get_page_pool_stats(struct net_device *dev, u64 *d=
ata)
> > +{
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     struct page_pool_stats pp_stats =3D {};
> > +     int i;
> > +
> > +     for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> > +             if (!vi->rq[i].page_pool)
> > +                     continue;
> > +             page_pool_get_stats(vi->rq[i].page_pool, &pp_stats);
> > +     }
> > +     page_pool_ethtool_stats_get(data, &pp_stats);
> > +#endif /* CONFIG_PAGE_POOL_STATS */
> > +}
> > +
> >  static void virtnet_get_ethtool_stats(struct net_device *dev,
> >                                     struct ethtool_stats *stats, u64 *d=
ata)
> >  {
> > @@ -3003,6 +3069,8 @@ static void virtnet_get_ethtool_stats(struct net_=
device *dev,
> >               } while (u64_stats_fetch_retry(&sq->stats.syncp, start));
> >               idx +=3D VIRTNET_SQ_STATS_LEN;
> >       }
> > +
> > +     virtnet_get_page_pool_stats(dev, &data[idx]);
> >  }
> >
> >  static void virtnet_get_channels(struct net_device *dev,
> > @@ -3623,6 +3691,8 @@ static void virtnet_free_queues(struct virtnet_in=
fo *vi)
> >       for (i =3D 0; i < vi->max_queue_pairs; i++) {
> >               __netif_napi_del(&vi->rq[i].napi);
> >               __netif_napi_del(&vi->sq[i].napi);
> > +             if (vi->rq[i].page_pool)
> > +                     page_pool_destroy(vi->rq[i].page_pool);
> >       }
> >
> >       /* We called __netif_napi_del(),
> > @@ -3679,12 +3749,19 @@ static void virtnet_rq_free_unused_buf(struct v=
irtqueue *vq, void *buf)
> >       struct virtnet_info *vi =3D vq->vdev->priv;
> >       int i =3D vq2rxq(vq);
> >
> > -     if (vi->mergeable_rx_bufs)
> > -             put_page(virt_to_head_page(buf));
> > -     else if (vi->big_packets)
> > +     if (vi->mergeable_rx_bufs) {
> > +             if (vi->rq[i].page_pool) {
> > +                     page_pool_put_full_page(vi->rq[i].page_pool,
> > +                                             virt_to_head_page(buf),
> > +                                             true);
> > +             } else {
> > +                     put_page(virt_to_head_page(buf));
> > +             }
> > +     } else if (vi->big_packets) {
> >               give_pages(&vi->rq[i], buf);
> > -     else
> > +     } else {
> >               put_page(virt_to_head_page(buf));
> > +     }
> >  }
> >
> >  static void free_unused_bufs(struct virtnet_info *vi)
> > @@ -3718,6 +3795,26 @@ static void virtnet_del_vqs(struct virtnet_info =
*vi)
> >       virtnet_free_queues(vi);
> >  }
> >
> > +static void virtnet_alloc_page_pool(struct receive_queue *rq)
> > +{
> > +     struct virtio_device *vdev =3D rq->vq->vdev;
> > +
> > +     struct page_pool_params pp_params =3D {
> > +             .order =3D 0,
> > +             .pool_size =3D rq->vq->num_max,
> > +             .nid =3D dev_to_node(vdev->dev.parent),
> > +             .dev =3D vdev->dev.parent,
> > +             .offset =3D 0,
> > +     };
> > +
> > +     rq->page_pool =3D page_pool_create(&pp_params);
> > +     if (IS_ERR(rq->page_pool)) {
> > +             dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
> > +                      PTR_ERR(rq->page_pool));
> > +             rq->page_pool =3D NULL;
> > +     }
> > +}
> > +
> >  /* How large should a single buffer be so a queue full of these can fi=
t at
> >   * least one full packet?
> >   * Logic below assumes the mergeable buffer header is used.
> > @@ -3801,6 +3898,13 @@ static int virtnet_find_vqs(struct virtnet_info =
*vi)
> >               vi->rq[i].vq =3D vqs[rxq2vq(i)];
> >               vi->rq[i].min_buf_len =3D mergeable_min_buf_len(vi, vi->r=
q[i].vq);
> >               vi->sq[i].vq =3D vqs[txq2vq(i)];
> > +
> > +             if (page_pool_enabled && vi->mergeable_rx_bufs)
> > +                     virtnet_alloc_page_pool(&vi->rq[i]);
> > +             else
> > +                     dev_warn(&vi->vdev->dev,
> > +                              "page pool only support mergeable mode\n=
");
> > +
> >       }
> >
> >       /* run here: ret =3D=3D 0. */
> > --
> > 2.31.1
>

