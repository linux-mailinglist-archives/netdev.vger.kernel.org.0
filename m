Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21CE687DB8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjBBMpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjBBMon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:44:43 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AC38E069;
        Thu,  2 Feb 2023 04:44:22 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id dr8so5494476ejc.12;
        Thu, 02 Feb 2023 04:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GcsWV+D7oT0AMtQnPFWdHj/Z02gu0tOXsiEzsrR1/Xk=;
        b=OaatDjKaLfCYJMQTIYnQm/rWl7cfmtVc1CmUSWioXRgZNi+zoG+73gfAM/j12Z11e4
         BAcqDHrPQac6doxVDf4LEaS7UO9giN/Lx56r5u/VTcnxrIoyMRx3Shj/AYDfnh8G6PXb
         50nTk70udsRdSsl7Ioa81s1f6KfJoNLJaTlFWt+AQHy+Ig3qhJ4DHT3ujLbh4FFsDKG2
         UWm5e/22HXbyriq02cQSjsVsbpxSd6Sc8V3Rxn8Q1I6c+gPaVYRA+YNB189wLbgCu3Si
         kKKVeM1v9gw/6NJ2Ap2O+J6iDRQ7Zw5L8BjSdn9qhnysOglStTo9nCT1f/ZDPbfgO05x
         aKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GcsWV+D7oT0AMtQnPFWdHj/Z02gu0tOXsiEzsrR1/Xk=;
        b=iUsCIsvlsnM9RKj5wmIoajaqGGD7ZmftC1Q+vdH/gEpimTbB0xXrx7zBDHMbiKw5ef
         o0sZZdBE7wWwIaxaddfT1EgNg+wIuPR/T+ilf5KF9nPJMwWZxtC9/ns0Pruh7nIo2FUe
         Nc0pK3Iy5krWp3QIQyxUv9BSsHBvh1DH13Y7tYBAy34RngwluaJq7WP8TGC1lk3mSQ/r
         9tQXm7GBL8XXC2XIiITgWempjGRwfaJeEsdmG5SySxGs8Qy/XDLWBFYPLhIYdo2KPnLG
         fSmDFIOgcciHrfgYBrGWWQbx47hOFmKYOotdXSwnuCiohdya4spGrCJL2tNvqQEX6UY9
         cALg==
X-Gm-Message-State: AO0yUKUNoF82bLNQYf6bboUmQhtQaaLhlyEqG4/YnTuwOWqhjynT6rGc
        2l4wkvaSDkwTIx892aGZ4PxPaSJXmnLibXvBzaM=
X-Google-Smtp-Source: AK7set8vdfTzoZ7TEPhE+12kmsoWzPOjzg4xmTZ5+vZZIPLDSHmM5L2bgr+k+z9Cn2M9DPYJYw+XbNEd+pV1p6bkVFQ=
X-Received: by 2002:a17:907:9917:b0:878:5f93:e797 with SMTP id
 ka23-20020a170907991700b008785f93e797mr1503717ejc.4.1675341855527; Thu, 02
 Feb 2023 04:44:15 -0800 (PST)
MIME-Version: 1.0
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com> <20230202110058.130695-9-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230202110058.130695-9-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 2 Feb 2023 13:44:03 +0100
Message-ID: <CAJ8uoz2jHs2zeJ=GcGq4w=atF=HAgtBSJ3avN2FJf9MrP4uikA@mail.gmail.com>
Subject: Re: [PATCH 08/33] virtio_ring: introduce dma sync api for virtio
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 at 12:05, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> In the process of dma sync, we involved whether virtio uses dma api. On
> the other hand, it is also necessary to read vdev->dev.parent. So these
> API has been introduced.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 61 ++++++++++++++++++++++++++++++++++++
>  include/linux/virtio.h       |  8 +++++
>  2 files changed, 69 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 67eda7bc23ea..7b393133fd27 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -3102,4 +3102,65 @@ void virtio_dma_unmap(struct device *dev, dma_addr_t dma, unsigned int length,
>  }
>  EXPORT_SYMBOL_GPL(virtio_dma_unmap);
>
> +/**
> + * virtio_dma_need_sync - check dma address need sync
> + * @dev: virtio device
> + * @addr: DMA address
> + */
> +bool virtio_dma_need_sync(struct device *dev, dma_addr_t addr)
> +{
> +       struct virtio_device *vdev = dev_to_virtio(dev);
> +
> +       if (!vring_use_dma_api(vdev))
> +               return 0;
> +
> +       return dma_need_sync(vdev->dev.parent, addr);
> +}
> +EXPORT_SYMBOL_GPL(virtio_dma_need_sync);
> +
> +/**
> + * virtio_dma_sync_signle_range_for_cpu - dma sync for cpu
> + * @dev: virtio device
> + * @addr: DMA address
> + * @offset: DMA address offset
> + * @size: mem size for sync
> + * @dir: DMA direction
> + *
> + * Before calling this function, use virtio_dma_need_sync() to confirm that the
> + * DMA address really needs to be synchronized
> + */
> +void virtio_dma_sync_signle_range_for_cpu(struct device *dev, dma_addr_t addr,
> +                                         unsigned long offset, size_t size,
> +                                         enum dma_data_direction dir)

First, thank you so much for working on this. It has taken a lot of dedication.

Spelling error in the function name: signle -> single.

> +{
> +       struct virtio_device *vdev = dev_to_virtio(dev);
> +
> +       dma_sync_single_range_for_cpu(vdev->dev.parent, addr, offset,
> +                                     size, DMA_BIDIRECTIONAL);
> +}
> +EXPORT_SYMBOL_GPL(virtio_dma_sync_signle_range_for_cpu);
> +
> +/**
> + * virtio_dma_sync_signle_range_for_device - dma sync for device
> + * @dev: virtio device
> + * @addr: DMA address
> + * @offset: DMA address offset
> + * @size: mem size for sync
> + * @dir: DMA direction
> + *
> + * Before calling this function, use virtio_dma_need_sync() to confirm that the
> + * DMA address really needs to be synchronized
> + */
> +void virtio_dma_sync_signle_range_for_device(struct device *dev,
> +                                            dma_addr_t addr,
> +                                            unsigned long offset, size_t size,
> +                                            enum dma_data_direction dir)

signle -> single here too.

> +{
> +       struct virtio_device *vdev = dev_to_virtio(dev);
> +
> +       dma_sync_single_range_for_device(vdev->dev.parent, addr, offset,
> +                                        size, DMA_BIDIRECTIONAL);
> +}
> +EXPORT_SYMBOL_GPL(virtio_dma_sync_signle_range_for_device);
> +
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index ce89126becc5..8c2fae318b0c 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -227,4 +227,12 @@ dma_addr_t virtio_dma_map(struct device *dev, void *addr, unsigned int length,
>  int virtio_dma_mapping_error(struct device *dev, dma_addr_t addr);
>  void virtio_dma_unmap(struct device *dev, dma_addr_t dma, unsigned int length,
>                       enum dma_data_direction dir);
> +bool virtio_dma_need_sync(struct device *dev, dma_addr_t addr);
> +void virtio_dma_sync_signle_range_for_cpu(struct device *dev, dma_addr_t addr,
> +                                         unsigned long offset, size_t size,
> +                                         enum dma_data_direction dir);
> +void virtio_dma_sync_signle_range_for_device(struct device *dev,
> +                                            dma_addr_t addr,
> +                                            unsigned long offset, size_t size,
> +                                            enum dma_data_direction dir);
>  #endif /* _LINUX_VIRTIO_H */
> --
> 2.32.0.3.g01195cf9f
>
