Return-Path: <netdev+bounces-5539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B72FD7120A4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F2A91C20EED
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B925687;
	Fri, 26 May 2023 07:06:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C051567C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:06:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C45114
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685084805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBejMg+s8pn89tl0WoGSR+vknKwo5Dacmjq+sP5U8E0=;
	b=YvE3Du6BSq4tsu7IKCr4OJIJOT1xt2Bwg8rYb/3Qd7vvTxipIJvA3Cv0slKp8eX4UVi5PZ
	0yayOCdnEMihEGI5Y6PyUvZcVdQPajnDvwLZI+lEkuZhsOsaKTSNPWiLuTrI5n3h16COeq
	Bd3K+KZ2KXeFV4yCt5utXCnSzprcs8c=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-ES0rM3V7P_yaIju3uwlZgg-1; Fri, 26 May 2023 03:06:43 -0400
X-MC-Unique: ES0rM3V7P_yaIju3uwlZgg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2af2059164fso1670481fa.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 00:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685084801; x=1687676801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wBejMg+s8pn89tl0WoGSR+vknKwo5Dacmjq+sP5U8E0=;
        b=HoZxszN/pjtnfOUCoPrxdYUM4x9TW1ltAVzYV0R9yr9wkEEH5UOqpMIF2CMazkAEHR
         Vx5apiZq+WjlmcrFKRBB8TF9tQj54V8ag9cSY4puDDaSnrOdcqgiOFEdkJDCVtNfsgJ7
         YYyxXG/NCs8AooMkIkJVA5p7X4NDcTSBZhXn3eefnOsic4e2/swx82RMzizcpbwBsdak
         RQyOu8pMDs62ksvFq8fLWIYCgTMtOnXDLjSJ4zyqSKm47463QHonYwbj9FKZnitsycLV
         7GsM/wUeBk6W+QfTkk16y/FVFDpFi8sot8WGNwBT4StX6z46BJ0Ipl9kYgvoTLGT9hjs
         Auxg==
X-Gm-Message-State: AC+VfDwQeV51skdB+SlDwjiHaOrKuuf7U2C6tU9DKc+Gg/MK2tP1h7Vv
	F5OYU1yyqvVmads0p1JDAj8heUUytjHyFlC2PpV4Q1G4WpZeMew7e2bzhfzelAd6EU+UKPcux+P
	+cAtFK1D/0zjtGLXjf5H8B0khJ8LpKb6W50SUlrotgCr4UQ==
X-Received: by 2002:a2e:7817:0:b0:2ac:8c5e:e151 with SMTP id t23-20020a2e7817000000b002ac8c5ee151mr451662ljc.31.1685084801106;
        Fri, 26 May 2023 00:06:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6sHDrHvdUXjE/f4RLyIFJiZ9+BIhhYVMPihHPnwvEGGl1gTbFH1d/Kkjl1jRuizOa84yxiFWZP2XxBPAfuKMg=
X-Received: by 2002:a2e:7817:0:b0:2ac:8c5e:e151 with SMTP id
 t23-20020a2e7817000000b002ac8c5ee151mr451649ljc.31.1685084800799; Fri, 26 May
 2023 00:06:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com> <20230526054621.18371-5-liangchen.linux@gmail.com>
In-Reply-To: <20230526054621.18371-5-liangchen.linux@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 26 May 2023 15:06:29 +0800
Message-ID: <CACGkMEsrr-3ArBgCksq=c60+5fZ-Xc-i653ix_vdr2f7c7wYfg@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] virtio_net: Implement DMA pre-handler
To: Liang Chen <liangchen.linux@gmail.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 1:47=E2=80=AFPM Liang Chen <liangchen.linux@gmail.c=
om> wrote:
>
> Adding a DMA pre-handler that utilizes page pool for managing DMA mapping=
s.
> When IOMMU is enabled, turning on the page_pool_dma_map module parameter =
to
> select page pool for DMA mapping management gives a significant reduction
> in the overhead caused by DMA mappings.
>
> In testing environments with a single core vm and qemu emulated IOMMU,
> significant performance improvements can be observed:
>   Upstream codebase: 1.76 Gbits/sec
>   Upstream codebase with page pool fragmentation support: 1.81 Gbits/sec
>   Upstream codebase with page pool fragmentation and DMA support: 19.3
>   Gbits/sec
>
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  drivers/net/virtio_net.c | 55 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ac40b8c66c59..73cc4f9fe4fa 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -22,6 +22,7 @@
>  #include <net/route.h>
>  #include <net/xdp.h>
>  #include <net/net_failover.h>
> +#include <linux/iommu.h>
>
>  static int napi_weight =3D NAPI_POLL_WEIGHT;
>  module_param(napi_weight, int, 0444);
> @@ -33,8 +34,10 @@ module_param(napi_tx, bool, 0644);
>
>  static bool page_pool_enabled;
>  static bool page_pool_frag;
> +static bool page_pool_dma_map;
>  module_param(page_pool_enabled, bool, 0400);
>  module_param(page_pool_frag, bool, 0400);
> +module_param(page_pool_dma_map, bool, 0400);
>
>  /* FIXME: MTU in config. */
>  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> @@ -3830,6 +3833,49 @@ static void virtnet_del_vqs(struct virtnet_info *v=
i)
>         virtnet_free_queues(vi);
>  }
>
> +static dma_addr_t virtnet_pp_dma_map_page(struct device *dev, struct pag=
e *page,
> +                                         unsigned long offset, size_t si=
ze,
> +                                         enum dma_data_direction dir, un=
signed long attrs)
> +{
> +       struct page *head_page;
> +
> +       if (dir !=3D DMA_FROM_DEVICE)
> +               return 0;
> +
> +       head_page =3D compound_head(page);
> +       return page_pool_get_dma_addr(head_page)
> +               + (page - head_page) * PAGE_SIZE
> +               + offset;

So it's not a map, it is just a query from the dma address from the pool.

> +}
> +
> +static bool virtnet_pp_dma_unmap_page(struct device *dev, dma_addr_t dma=
_handle,
> +                                     size_t size, enum dma_data_directio=
n dir,
> +                                     unsigned long attrs)
> +{
> +       phys_addr_t phys;
> +
> +       /* Handle only the RX direction, and sync the DMA memory only if =
it's not
> +        * a DMA coherent architecture.
> +        */
> +       if (dir !=3D DMA_FROM_DEVICE)
> +               return false;
> +
> +       if (dev_is_dma_coherent(dev))
> +               return true;
> +
> +       phys =3D iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle=
);

This would be somehow slow. If we track the mapping by driver, it
would be much faster.

More could be seen here:

https://lists.linuxfoundation.org/pipermail/virtualization/2023-May/066778.=
html

Thanks

> +       if (WARN_ON(!phys))
> +               return false;
> +
> +       arch_sync_dma_for_cpu(phys, size, dir);
> +       return true;
> +}
> +
> +static struct virtqueue_pre_dma_ops virtnet_pp_pre_dma_ops =3D {
> +       .map_page =3D virtnet_pp_dma_map_page,
> +       .unmap_page =3D virtnet_pp_dma_unmap_page,
> +};
> +
>  static void virtnet_alloc_page_pool(struct receive_queue *rq)
>  {
>         struct virtio_device *vdev =3D rq->vq->vdev;
> @@ -3845,6 +3891,15 @@ static void virtnet_alloc_page_pool(struct receive=
_queue *rq)
>         if (page_pool_frag)
>                 pp_params.flags |=3D PP_FLAG_PAGE_FRAG;
>
> +       /* Consider using page pool DMA support only when DMA API is used=
. */
> +       if (virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM) &&
> +           page_pool_dma_map) {
> +               pp_params.flags |=3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_D=
EV;
> +               pp_params.dma_dir =3D DMA_FROM_DEVICE;
> +               pp_params.max_len =3D PAGE_SIZE << pp_params.order;
> +               virtqueue_register_pre_dma_ops(rq->vq, &virtnet_pp_pre_dm=
a_ops);
> +       }
> +
>         rq->page_pool =3D page_pool_create(&pp_params);
>         if (IS_ERR(rq->page_pool)) {
>                 dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
> --
> 2.31.1
>


