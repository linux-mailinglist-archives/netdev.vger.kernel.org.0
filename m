Return-Path: <netdev+bounces-5537-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26419712077
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8C1B1C20E6A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCF953A0;
	Fri, 26 May 2023 06:51:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAC95669
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:51:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD63013A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 23:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685083865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xhx2rCHqgkzIwSk2Mgkh1NsxfWoR2K+4YkNE5CAJg7Q=;
	b=AbDJvWB+AJDW/+pICCIDtN920FtZqIzJQkdOXcVYYpTI73W4OZVXj2CmVqZvWWepYUkWOO
	VZhRxg8XPmx5fpUdg+NQDCghMgAhIUWJnoMhxzgzyO+0fM30KA9+cyI/9cJDq/OQpOjDq7
	hKtnzph6QmW8wFoHdmPSJSfdFRUp36A=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-87Nk-U6uNHyYLDBG3frkeA-1; Fri, 26 May 2023 02:51:03 -0400
X-MC-Unique: 87Nk-U6uNHyYLDBG3frkeA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f4b7b4e7c5so188400e87.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 23:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685083861; x=1687675861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xhx2rCHqgkzIwSk2Mgkh1NsxfWoR2K+4YkNE5CAJg7Q=;
        b=NVoh8JwQdeH/uuqKn2SIax/+2Yd1suea2+9bUEdGXxHvwAddmpA+lmeULHs+piXUui
         xHMcblyY2qOqXb+7V0CE0kZmaNhA8aflwdbIQH0M37usLTAbxIhlwRGEwtfERBCFelMR
         oWa0dnGymK8A1QzZl0CiXDICb/hkJQBDPiH10DzA4nDE9zFeTJw4wL/dY49lXZmsEIDT
         SENMYLnz2jh2ce5y05ZdwkrvxueQof+7AOwUZ2E925UzjceC+A88CKE/ArQCcYv2mFoh
         nF3H/bhKo0F7TsB/niRR1YL1wPJu8LXhRvtTb7IQzdmJnHHhHTjByztv6VzfjAvNLnOt
         GCWA==
X-Gm-Message-State: AC+VfDweTdvdJVWxynkDrbIsW23Wd4gJhyQJ2vgwm8/thzLlmwC70HJp
	nMaPaACUBkoctrpoeoRyD4S5rPJbrdWdCPaY1SxU10SmBCfVwFCZABIKE9GGRDWovwVYpYSGR4B
	8+hIOIW5gyxTuVdQp9HKbfE52zHrQSCH4/F4BMwfecUY=
X-Received: by 2002:a2e:9ed9:0:b0:2ad:d949:dd39 with SMTP id h25-20020a2e9ed9000000b002add949dd39mr531737ljk.29.1685083861081;
        Thu, 25 May 2023 23:51:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5TXz+ssrtDQcKywyFsZ9BVvx5MTuTUI3B+rZ2zU5vBT89yhV/tYOSJIUrGRNttF1bt7MfAoLf0tu8TrV0NZNI=
X-Received: by 2002:a2e:9ed9:0:b0:2ad:d949:dd39 with SMTP id
 h25-20020a2e9ed9000000b002add949dd39mr531724ljk.29.1685083860646; Thu, 25 May
 2023 23:51:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com> <20230526054621.18371-2-liangchen.linux@gmail.com>
In-Reply-To: <20230526054621.18371-2-liangchen.linux@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 26 May 2023 14:50:49 +0800
Message-ID: <CACGkMEv+5150S4ooWFMnUs-GpwRYgRMTku0ZgkFpH5iFR1qQsw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
To: Liang Chen <liangchen.linux@gmail.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 1:46=E2=80=AFPM Liang Chen <liangchen.linux@gmail.c=
om> wrote:
>
> The implementation at the moment uses one page per packet in both the
> normal and XDP path.

It's better to explain why we need a page pool and how it can help the
performance.

> In addition, introducing a module parameter to enable
> or disable the usage of page pool (disabled by default).

If page pool wins for most of the cases, any reason to disable it by defaul=
t?

>
> In single-core vm testing environments, it gives a modest performance gai=
n
> in the normal path.
>   Upstream codebase: 47.5 Gbits/sec
>   Upstream codebase + page_pool support: 50.2 Gbits/sec
>
> In multi-core vm testing environments, The most significant performance
> gain is observed in XDP cpumap:
>   Upstream codebase: 1.38 Gbits/sec
>   Upstream codebase + page_pool support: 9.74 Gbits/sec

Please show more details on the test. E.g which kinds of tests have
you measured?

Btw, it would be better to measure PPS as well.

>
> With this foundation, we can further integrate page pool fragmentation an=
d
> DMA map/unmap support.
>
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  drivers/net/virtio_net.c | 188 ++++++++++++++++++++++++++++++---------

I believe we should make virtio-net to select CONFIG_PAGE_POOL or do
the ifdef tricks at least.

>  1 file changed, 146 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c5dca0d92e64..99c0ca0c1781 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -31,6 +31,9 @@ module_param(csum, bool, 0444);
>  module_param(gso, bool, 0444);
>  module_param(napi_tx, bool, 0644);
>
> +static bool page_pool_enabled;
> +module_param(page_pool_enabled, bool, 0400);
> +
>  /* FIXME: MTU in config. */
>  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
>  #define GOOD_COPY_LEN  128
> @@ -159,6 +162,9 @@ struct receive_queue {
>         /* Chain pages by the private ptr. */
>         struct page *pages;
>
> +       /* Page pool */
> +       struct page_pool *page_pool;
> +
>         /* Average packet length for mergeable receive buffers. */
>         struct ewma_pkt_len mrg_avg_pkt_len;
>
> @@ -459,6 +465,14 @@ static struct sk_buff *virtnet_build_skb(void *buf, =
unsigned int buflen,
>         return skb;
>  }
>
> +static void virtnet_put_page(struct receive_queue *rq, struct page *page=
)
> +{
> +       if (rq->page_pool)
> +               page_pool_put_full_page(rq->page_pool, page, true);
> +       else
> +               put_page(page);
> +}
> +
>  /* Called from bottom half context */
>  static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>                                    struct receive_queue *rq,
> @@ -555,7 +569,7 @@ static struct sk_buff *page_to_skb(struct virtnet_inf=
o *vi,
>         hdr =3D skb_vnet_hdr(skb);
>         memcpy(hdr, hdr_p, hdr_len);
>         if (page_to_free)
> -               put_page(page_to_free);
> +               virtnet_put_page(rq, page_to_free);
>
>         return skb;
>  }
> @@ -802,7 +816,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>         return ret;
>  }
>
> -static void put_xdp_frags(struct xdp_buff *xdp)
> +static void put_xdp_frags(struct xdp_buff *xdp, struct receive_queue *rq=
)
>  {

rq could be fetched from xdp_rxq_info?

>         struct skb_shared_info *shinfo;
>         struct page *xdp_page;
> @@ -812,7 +826,7 @@ static void put_xdp_frags(struct xdp_buff *xdp)
>                 shinfo =3D xdp_get_shared_info_from_buff(xdp);
>                 for (i =3D 0; i < shinfo->nr_frags; i++) {
>                         xdp_page =3D skb_frag_page(&shinfo->frags[i]);
> -                       put_page(xdp_page);
> +                       virtnet_put_page(rq, xdp_page);
>                 }
>         }
>  }
> @@ -903,7 +917,11 @@ static struct page *xdp_linearize_page(struct receiv=
e_queue *rq,
>         if (page_off + *len + tailroom > PAGE_SIZE)
>                 return NULL;
>
> -       page =3D alloc_page(GFP_ATOMIC);
> +       if (rq->page_pool)
> +               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> +       else
> +               page =3D alloc_page(GFP_ATOMIC);
> +
>         if (!page)
>                 return NULL;
>
> @@ -926,21 +944,24 @@ static struct page *xdp_linearize_page(struct recei=
ve_queue *rq,
>                  * is sending packet larger than the MTU.
>                  */
>                 if ((page_off + buflen + tailroom) > PAGE_SIZE) {
> -                       put_page(p);
> +                       virtnet_put_page(rq, p);
>                         goto err_buf;
>                 }
>
>                 memcpy(page_address(page) + page_off,
>                        page_address(p) + off, buflen);
>                 page_off +=3D buflen;
> -               put_page(p);
> +               virtnet_put_page(rq, p);
>         }
>
>         /* Headroom does not contribute to packet length */
>         *len =3D page_off - VIRTIO_XDP_HEADROOM;
>         return page;
>  err_buf:
> -       __free_pages(page, 0);
> +       if (rq->page_pool)
> +               page_pool_put_full_page(rq->page_pool, page, true);
> +       else
> +               __free_pages(page, 0);
>         return NULL;
>  }
>
> @@ -1144,7 +1165,7 @@ static void mergeable_buf_free(struct receive_queue=
 *rq, int num_buf,
>                 }
>                 stats->bytes +=3D len;
>                 page =3D virt_to_head_page(buf);
> -               put_page(page);
> +               virtnet_put_page(rq, page);
>         }
>  }
>
> @@ -1264,7 +1285,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_de=
vice *dev,
>                 cur_frag_size =3D truesize;
>                 xdp_frags_truesz +=3D cur_frag_size;
>                 if (unlikely(len > truesize - room || cur_frag_size > PAG=
E_SIZE)) {
> -                       put_page(page);
> +                       virtnet_put_page(rq, page);
>                         pr_debug("%s: rx error: len %u exceeds truesize %=
lu\n",
>                                  dev->name, len, (unsigned long)(truesize=
 - room));
>                         dev->stats.rx_length_errors++;
> @@ -1283,7 +1304,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_de=
vice *dev,
>         return 0;
>
>  err:
> -       put_xdp_frags(xdp);
> +       put_xdp_frags(xdp, rq);
>         return -EINVAL;
>  }
>
> @@ -1344,7 +1365,10 @@ static void *mergeable_xdp_get_buf(struct virtnet_=
info *vi,
>                 if (*len + xdp_room > PAGE_SIZE)
>                         return NULL;
>
> -               xdp_page =3D alloc_page(GFP_ATOMIC);
> +               if (rq->page_pool)
> +                       xdp_page =3D page_pool_dev_alloc_pages(rq->page_p=
ool);
> +               else
> +                       xdp_page =3D alloc_page(GFP_ATOMIC);
>                 if (!xdp_page)
>                         return NULL;
>
> @@ -1354,7 +1378,7 @@ static void *mergeable_xdp_get_buf(struct virtnet_i=
nfo *vi,
>
>         *frame_sz =3D PAGE_SIZE;
>
> -       put_page(*page);
> +       virtnet_put_page(rq, *page);
>
>         *page =3D xdp_page;
>
> @@ -1400,6 +1424,8 @@ static struct sk_buff *receive_mergeable_xdp(struct=
 net_device *dev,
>                 head_skb =3D build_skb_from_xdp_buff(dev, vi, &xdp, xdp_f=
rags_truesz);
>                 if (unlikely(!head_skb))
>                         break;
> +               if (rq->page_pool)
> +                       skb_mark_for_recycle(head_skb);
>                 return head_skb;
>
>         case XDP_TX:
> @@ -1410,10 +1436,10 @@ static struct sk_buff *receive_mergeable_xdp(stru=
ct net_device *dev,
>                 break;
>         }
>
> -       put_xdp_frags(&xdp);
> +       put_xdp_frags(&xdp, rq);
>
>  err_xdp:
> -       put_page(page);
> +       virtnet_put_page(rq, page);
>         mergeable_buf_free(rq, num_buf, dev, stats);
>
>         stats->xdp_drops++;
> @@ -1467,6 +1493,9 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>         head_skb =3D page_to_skb(vi, rq, page, offset, len, truesize, hea=
droom);
>         curr_skb =3D head_skb;
>
> +       if (rq->page_pool)
> +               skb_mark_for_recycle(curr_skb);
> +
>         if (unlikely(!curr_skb))
>                 goto err_skb;
>         while (--num_buf) {
> @@ -1509,6 +1538,8 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                         curr_skb =3D nskb;
>                         head_skb->truesize +=3D nskb->truesize;
>                         num_skb_frags =3D 0;
> +                       if (rq->page_pool)
> +                               skb_mark_for_recycle(curr_skb);
>                 }
>                 if (curr_skb !=3D head_skb) {
>                         head_skb->data_len +=3D len;
> @@ -1517,7 +1548,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                 }
>                 offset =3D buf - page_address(page);
>                 if (skb_can_coalesce(curr_skb, num_skb_frags, page, offse=
t)) {
> -                       put_page(page);
> +                       virtnet_put_page(rq, page);

I wonder why not we can't do this during buffer allocation like other drive=
rs?

>                         skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
>                                              len, truesize);
>                 } else {
> @@ -1530,7 +1561,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>         return head_skb;
>
>  err_skb:
> -       put_page(page);
> +       virtnet_put_page(rq, page);
>         mergeable_buf_free(rq, num_buf, dev, stats);
>
>  err_buf:
> @@ -1737,31 +1768,40 @@ static int add_recvbuf_mergeable(struct virtnet_i=
nfo *vi,
>          * disabled GSO for XDP, it won't be a big issue.
>          */
>         len =3D get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
> -       if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
> -               return -ENOMEM;
> +       if (rq->page_pool) {
> +               struct page *page;
>
> -       buf =3D (char *)page_address(alloc_frag->page) + alloc_frag->offs=
et;
> -       buf +=3D headroom; /* advance address leaving hole at front of pk=
t */
> -       get_page(alloc_frag->page);
> -       alloc_frag->offset +=3D len + room;
> -       hole =3D alloc_frag->size - alloc_frag->offset;
> -       if (hole < len + room) {
> -               /* To avoid internal fragmentation, if there is very like=
ly not
> -                * enough space for another buffer, add the remaining spa=
ce to
> -                * the current buffer.
> -                * XDP core assumes that frame_size of xdp_buff and the l=
ength
> -                * of the frag are PAGE_SIZE, so we disable the hole mech=
anism.
> -                */
> -               if (!headroom)
> -                       len +=3D hole;
> -               alloc_frag->offset +=3D hole;
> -       }
> +               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> +               if (unlikely(!page))
> +                       return -ENOMEM;
> +               buf =3D (char *)page_address(page);
> +               buf +=3D headroom; /* advance address leaving hole at fro=
nt of pkt */
> +       } else {
> +               if (unlikely(!skb_page_frag_refill(len + room, alloc_frag=
, gfp)))

Why not simply use a helper like virtnet_page_frag_refill() and add
the page_pool allocation logic there? It helps to reduce the
changeset.

> +                       return -ENOMEM;
>
> +               buf =3D (char *)page_address(alloc_frag->page) + alloc_fr=
ag->offset;
> +               buf +=3D headroom; /* advance address leaving hole at fro=
nt of pkt */
> +               get_page(alloc_frag->page);
> +               alloc_frag->offset +=3D len + room;
> +               hole =3D alloc_frag->size - alloc_frag->offset;
> +               if (hole < len + room) {
> +                       /* To avoid internal fragmentation, if there is v=
ery likely not
> +                        * enough space for another buffer, add the remai=
ning space to
> +                        * the current buffer.
> +                        * XDP core assumes that frame_size of xdp_buff a=
nd the length
> +                        * of the frag are PAGE_SIZE, so we disable the h=
ole mechanism.
> +                        */
> +                       if (!headroom)
> +                               len +=3D hole;
> +                       alloc_frag->offset +=3D hole;
> +               }
> +       }
>         sg_init_one(rq->sg, buf, len);
>         ctx =3D mergeable_len_to_ctx(len + room, headroom);
>         err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp)=
;
>         if (err < 0)
> -               put_page(virt_to_head_page(buf));
> +               virtnet_put_page(rq, virt_to_head_page(buf));
>
>         return err;
>  }
> @@ -1994,8 +2034,15 @@ static int virtnet_enable_queue_pair(struct virtne=
t_info *vi, int qp_index)
>         if (err < 0)
>                 return err;
>
> -       err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
> -                                        MEM_TYPE_PAGE_SHARED, NULL);
> +       if (vi->rq[qp_index].page_pool)
> +               err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_=
rxq,
> +                                                MEM_TYPE_PAGE_POOL,
> +                                                vi->rq[qp_index].page_po=
ol);
> +       else
> +               err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_=
rxq,
> +                                                MEM_TYPE_PAGE_SHARED,
> +                                                NULL);
> +
>         if (err < 0)
>                 goto err_xdp_reg_mem_model;
>
> @@ -2951,6 +2998,7 @@ static void virtnet_get_strings(struct net_device *=
dev, u32 stringset, u8 *data)
>                                 ethtool_sprintf(&p, "tx_queue_%u_%s", i,
>                                                 virtnet_sq_stats_desc[j].=
desc);
>                 }
> +               page_pool_ethtool_stats_get_strings(p);
>                 break;
>         }
>  }
> @@ -2962,12 +3010,30 @@ static int virtnet_get_sset_count(struct net_devi=
ce *dev, int sset)
>         switch (sset) {
>         case ETH_SS_STATS:
>                 return vi->curr_queue_pairs * (VIRTNET_RQ_STATS_LEN +
> -                                              VIRTNET_SQ_STATS_LEN);
> +                                              VIRTNET_SQ_STATS_LEN +
> +                                               (page_pool_enabled && vi-=
>mergeable_rx_bufs ?
> +                                                page_pool_ethtool_stats_=
get_count() : 0));
>         default:
>                 return -EOPNOTSUPP;
>         }
>  }
>
> +static void virtnet_get_page_pool_stats(struct net_device *dev, u64 *dat=
a)
> +{
> +#ifdef CONFIG_PAGE_POOL_STATS
> +       struct virtnet_info *vi =3D netdev_priv(dev);
> +       struct page_pool_stats pp_stats =3D {};
> +       int i;
> +
> +       for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> +               if (!vi->rq[i].page_pool)
> +                       continue;
> +               page_pool_get_stats(vi->rq[i].page_pool, &pp_stats);
> +       }
> +       page_pool_ethtool_stats_get(data, &pp_stats);
> +#endif /* CONFIG_PAGE_POOL_STATS */
> +}
> +
>  static void virtnet_get_ethtool_stats(struct net_device *dev,
>                                       struct ethtool_stats *stats, u64 *d=
ata)
>  {
> @@ -3003,6 +3069,8 @@ static void virtnet_get_ethtool_stats(struct net_de=
vice *dev,
>                 } while (u64_stats_fetch_retry(&sq->stats.syncp, start));
>                 idx +=3D VIRTNET_SQ_STATS_LEN;
>         }
> +
> +       virtnet_get_page_pool_stats(dev, &data[idx]);
>  }
>
>  static void virtnet_get_channels(struct net_device *dev,
> @@ -3623,6 +3691,8 @@ static void virtnet_free_queues(struct virtnet_info=
 *vi)
>         for (i =3D 0; i < vi->max_queue_pairs; i++) {
>                 __netif_napi_del(&vi->rq[i].napi);
>                 __netif_napi_del(&vi->sq[i].napi);
> +               if (vi->rq[i].page_pool)
> +                       page_pool_destroy(vi->rq[i].page_pool);
>         }
>
>         /* We called __netif_napi_del(),
> @@ -3679,12 +3749,19 @@ static void virtnet_rq_free_unused_buf(struct vir=
tqueue *vq, void *buf)
>         struct virtnet_info *vi =3D vq->vdev->priv;
>         int i =3D vq2rxq(vq);
>
> -       if (vi->mergeable_rx_bufs)
> -               put_page(virt_to_head_page(buf));
> -       else if (vi->big_packets)
> +       if (vi->mergeable_rx_bufs) {
> +               if (vi->rq[i].page_pool) {
> +                       page_pool_put_full_page(vi->rq[i].page_pool,
> +                                               virt_to_head_page(buf),
> +                                               true);
> +               } else {
> +                       put_page(virt_to_head_page(buf));
> +               }
> +       } else if (vi->big_packets) {
>                 give_pages(&vi->rq[i], buf);

Any reason only mergeable were modified but not for small and big?

Thanks

> -       else
> +       } else {
>                 put_page(virt_to_head_page(buf));
> +       }
>  }
>
>  static void free_unused_bufs(struct virtnet_info *vi)
> @@ -3718,6 +3795,26 @@ static void virtnet_del_vqs(struct virtnet_info *v=
i)
>         virtnet_free_queues(vi);
>  }
>
> +static void virtnet_alloc_page_pool(struct receive_queue *rq)
> +{
> +       struct virtio_device *vdev =3D rq->vq->vdev;
> +
> +       struct page_pool_params pp_params =3D {
> +               .order =3D 0,
> +               .pool_size =3D rq->vq->num_max,
> +               .nid =3D dev_to_node(vdev->dev.parent),
> +               .dev =3D vdev->dev.parent,
> +               .offset =3D 0,
> +       };
> +
> +       rq->page_pool =3D page_pool_create(&pp_params);
> +       if (IS_ERR(rq->page_pool)) {
> +               dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
> +                        PTR_ERR(rq->page_pool));
> +               rq->page_pool =3D NULL;
> +       }
> +}
> +
>  /* How large should a single buffer be so a queue full of these can fit =
at
>   * least one full packet?
>   * Logic below assumes the mergeable buffer header is used.
> @@ -3801,6 +3898,13 @@ static int virtnet_find_vqs(struct virtnet_info *v=
i)
>                 vi->rq[i].vq =3D vqs[rxq2vq(i)];
>                 vi->rq[i].min_buf_len =3D mergeable_min_buf_len(vi, vi->r=
q[i].vq);
>                 vi->sq[i].vq =3D vqs[txq2vq(i)];
> +
> +               if (page_pool_enabled && vi->mergeable_rx_bufs)
> +                       virtnet_alloc_page_pool(&vi->rq[i]);
> +               else
> +                       dev_warn(&vi->vdev->dev,
> +                                "page pool only support mergeable mode\n=
");
> +
>         }
>
>         /* run here: ret =3D=3D 0. */
> --
> 2.31.1
>


