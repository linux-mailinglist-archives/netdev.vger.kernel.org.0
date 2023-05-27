Return-Path: <netdev+bounces-5896-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D387134C0
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 497A1281797
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D7CF9E2;
	Sat, 27 May 2023 12:36:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366F417FD
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:36:02 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B28C1B0;
	Sat, 27 May 2023 05:35:45 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2af2db78b38so17593061fa.3;
        Sat, 27 May 2023 05:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685190943; x=1687782943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HH3JkcQQauNz7KukXOkzdyynRXiXt1x0ijLtD/xpm7g=;
        b=AwfeJbB2HWHfDHXNcXulaiLzYHu7UJRrIwYZijFp2G1ylfWY2sRDhIuRb82qL0gz36
         68VC5a9Gk1TR+ZYjXTpmxtGp5O/ju1+Ow/dnfNuUhFLaziJdFWh1wAmJFLSnJQwBNSG1
         HXFuLueAzw/XfpqFdyYvemC8N/GXxsYNIfACkGMWaC663d/nt3WUCxYgXbXrrBWhAf2n
         By9Mzjs76c6Y83B9MfvVz9WM6DhKXZPLCklPOmmI1eLZl4TTJRIXmYzWqBl/2TyY/rsf
         5po8fCjE1IsfBBt0hszNBB8cBKpGqnrRU3Cu3z9++soViPHcYl9UgMJW8GY16fNROsGA
         xoPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685190943; x=1687782943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HH3JkcQQauNz7KukXOkzdyynRXiXt1x0ijLtD/xpm7g=;
        b=X9d62R1VxbHex7cWlDXYC1aM+g+xKVZxKGKctDVCYDiXNZ+4h+DxO1csYFxGGeWNBg
         SzBBxsetAhx333rDADbWTocGjiyk21p5SI0F0kXgxONomQ21jeipc75SnI2WVJy8sGzW
         YpUTw9UP660yclHliIJC6dz2UsJWUOikh7S8WktEbHBIPjO2PHW4fWy7x6nhOPOU1dVQ
         GEZzoMCqP2Yt+FEaOmTigCLCKUa39WwljAqHf7huG7il8TSsa+ornWDY6war31h2KX0U
         6yOEB2DIkuods/NrhzPqa6oEfXRUw7TFFXhrU1VpraxAtrZ8qYYo/TUV3ae6Ov9PBpEe
         Y/fQ==
X-Gm-Message-State: AC+VfDynUWkSv7/PL+WWfQmmQrZwPirGX1k+2TMBB4E7WzJ0JGSmJGeH
	UDpH7t8WX5Bs6C9Q4t6fIEG+vtC71S2Gfk2exGY=
X-Google-Smtp-Source: ACHHUZ62U5Z4wegM5QNY5hw2yPYFqLkSgQphhkY7qkpXtZ2hTwyQ4Wi9GL8lhA/YXAiUWEIXR2XSQnu2Qj6Xb1A2kfU=
X-Received: by 2002:a2e:88d7:0:b0:2ae:e214:482f with SMTP id
 a23-20020a2e88d7000000b002aee214482fmr1602576ljk.52.1685190943003; Sat, 27
 May 2023 05:35:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-5-liangchen.linux@gmail.com> <CACGkMEsrr-3ArBgCksq=c60+5fZ-Xc-i653ix_vdr2f7c7wYfg@mail.gmail.com>
In-Reply-To: <CACGkMEsrr-3ArBgCksq=c60+5fZ-Xc-i653ix_vdr2f7c7wYfg@mail.gmail.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Sat, 27 May 2023 20:35:31 +0800
Message-ID: <CAKhg4tKcQi4-G8oGWtzTBZztvNKzLP7Q=GGHS=ccH-DgKDCJig@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] virtio_net: Implement DMA pre-handler
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
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

On Fri, May 26, 2023 at 3:06=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Fri, May 26, 2023 at 1:47=E2=80=AFPM Liang Chen <liangchen.linux@gmail=
.com> wrote:
> >
> > Adding a DMA pre-handler that utilizes page pool for managing DMA mappi=
ngs.
> > When IOMMU is enabled, turning on the page_pool_dma_map module paramete=
r to
> > select page pool for DMA mapping management gives a significant reducti=
on
> > in the overhead caused by DMA mappings.
> >
> > In testing environments with a single core vm and qemu emulated IOMMU,
> > significant performance improvements can be observed:
> >   Upstream codebase: 1.76 Gbits/sec
> >   Upstream codebase with page pool fragmentation support: 1.81 Gbits/se=
c
> >   Upstream codebase with page pool fragmentation and DMA support: 19.3
> >   Gbits/sec
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > ---
> >  drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 55 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index ac40b8c66c59..73cc4f9fe4fa 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -22,6 +22,7 @@
> >  #include <net/route.h>
> >  #include <net/xdp.h>
> >  #include <net/net_failover.h>
> > +#include <linux/iommu.h>
> >
> >  static int napi_weight =3D NAPI_POLL_WEIGHT;
> >  module_param(napi_weight, int, 0444);
> > @@ -33,8 +34,10 @@ module_param(napi_tx, bool, 0644);
> >
> >  static bool page_pool_enabled;
> >  static bool page_pool_frag;
> > +static bool page_pool_dma_map;
> >  module_param(page_pool_enabled, bool, 0400);
> >  module_param(page_pool_frag, bool, 0400);
> > +module_param(page_pool_dma_map, bool, 0400);
> >
> >  /* FIXME: MTU in config. */
> >  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> > @@ -3830,6 +3833,49 @@ static void virtnet_del_vqs(struct virtnet_info =
*vi)
> >         virtnet_free_queues(vi);
> >  }
> >
> > +static dma_addr_t virtnet_pp_dma_map_page(struct device *dev, struct p=
age *page,
> > +                                         unsigned long offset, size_t =
size,
> > +                                         enum dma_data_direction dir, =
unsigned long attrs)
> > +{
> > +       struct page *head_page;
> > +
> > +       if (dir !=3D DMA_FROM_DEVICE)
> > +               return 0;
> > +
> > +       head_page =3D compound_head(page);
> > +       return page_pool_get_dma_addr(head_page)
> > +               + (page - head_page) * PAGE_SIZE
> > +               + offset;
>
> So it's not a map, it is just a query from the dma address from the pool.
>
> > +}
> > +
> > +static bool virtnet_pp_dma_unmap_page(struct device *dev, dma_addr_t d=
ma_handle,
> > +                                     size_t size, enum dma_data_direct=
ion dir,
> > +                                     unsigned long attrs)
> > +{
> > +       phys_addr_t phys;
> > +
> > +       /* Handle only the RX direction, and sync the DMA memory only i=
f it's not
> > +        * a DMA coherent architecture.
> > +        */
> > +       if (dir !=3D DMA_FROM_DEVICE)
> > +               return false;
> > +
> > +       if (dev_is_dma_coherent(dev))
> > +               return true;
> > +
> > +       phys =3D iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_hand=
le);
>
> This would be somehow slow. If we track the mapping by driver, it
> would be much faster.
>
> More could be seen here:
>
> https://lists.linuxfoundation.org/pipermail/virtualization/2023-May/06677=
8.html
>
> Thanks
>

Thanks for the information. I agree with your suggestion, and I will
drop the last two patches on v2 and wait for Xuan's patch to land for
dma mapping management.




> > +       if (WARN_ON(!phys))
> > +               return false;
> > +
> > +       arch_sync_dma_for_cpu(phys, size, dir);
> > +       return true;
> > +}
> > +
> > +static struct virtqueue_pre_dma_ops virtnet_pp_pre_dma_ops =3D {
> > +       .map_page =3D virtnet_pp_dma_map_page,
> > +       .unmap_page =3D virtnet_pp_dma_unmap_page,
> > +};
> > +
> >  static void virtnet_alloc_page_pool(struct receive_queue *rq)
> >  {
> >         struct virtio_device *vdev =3D rq->vq->vdev;
> > @@ -3845,6 +3891,15 @@ static void virtnet_alloc_page_pool(struct recei=
ve_queue *rq)
> >         if (page_pool_frag)
> >                 pp_params.flags |=3D PP_FLAG_PAGE_FRAG;
> >
> > +       /* Consider using page pool DMA support only when DMA API is us=
ed. */
> > +       if (virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM) &&
> > +           page_pool_dma_map) {
> > +               pp_params.flags |=3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC=
_DEV;
> > +               pp_params.dma_dir =3D DMA_FROM_DEVICE;
> > +               pp_params.max_len =3D PAGE_SIZE << pp_params.order;
> > +               virtqueue_register_pre_dma_ops(rq->vq, &virtnet_pp_pre_=
dma_ops);
> > +       }
> > +
> >         rq->page_pool =3D page_pool_create(&pp_params);
> >         if (IS_ERR(rq->page_pool)) {
> >                 dev_warn(&vdev->dev, "page pool creation failed: %ld\n"=
,
> > --
> > 2.31.1
> >
>

