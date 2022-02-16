Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89074B7F2A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbiBPEOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:14:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245738AbiBPEOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:14:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D423FCB7A
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644984879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G5w2uW0K8wt8YIL54HfUFFaak3oCnnb6qVxJPmyS2e8=;
        b=QegbwtrgrUikPHQIXFWqUNDdn9ULGx5wC6UAq/ohlzeKEXiMdl8vHjuchgrOuFjW9yX3B0
        7EnFIGzhXhCqfcD3NooQkH0IcYSHMphQ/dlf04g/V1jv4kKtYx5fOjBJcZ+/ptK/sQbMRd
        VQK0gnXNcUTJ8rhqiW9tNQ9EZnYFXLQ=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-nMKYEaoaPqOFReHcchh3sg-1; Tue, 15 Feb 2022 23:14:38 -0500
X-MC-Unique: nMKYEaoaPqOFReHcchh3sg-1
Received: by mail-lj1-f200.google.com with SMTP id s20-20020a2eb8d4000000b00244c0c07f5aso462507ljp.7
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G5w2uW0K8wt8YIL54HfUFFaak3oCnnb6qVxJPmyS2e8=;
        b=XmEV5j86MJCuFqty+GENEMeDqL7yemL9IrAWWwdNB+I3jUrkywwz+5F+h2VhR8AXJu
         RMaQdvyWmgnCtrYidw4kbOywAIvP0qdjlz8ATtuQ7mOSL1+p0HuhKqsaheTBxbKg6q05
         e2hELEct3uWBG38IHNk3uhO4brDDQAqdTPbM5WrFnyg8nZJToiApKwzSRxV5IalW1lRG
         tnhJ/Kw7BQL/d7k11l7RCozV4xJQjgaR5iX+xI//bH23WpgG4INvebe8RFGAmT2x0//t
         axUGIn5p6ZzLmMgsOUVo0aeB5fdgbZV65DKDcDBNehl3CdeIvCPznantxqb7rhj3Sbul
         kQaw==
X-Gm-Message-State: AOAM532g6oteeVrTK9O7hseKgClA1t9QsGca1pSTXXZZ0YtkS6iwVxxz
        DxRPui8MtCpHxXYK4jkMEmTHIPjKIMu9gCQI84Ng4XIMXZBLHAOr0P/Gj9LCGI+WcQVv0FK4k4P
        8kk0xT7Brl+ZVT3xNuddjAHMU42FRBDyX
X-Received: by 2002:a05:6512:6c4:b0:437:9409:984c with SMTP id u4-20020a05651206c400b004379409984cmr643925lff.199.1644984876336;
        Tue, 15 Feb 2022 20:14:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/SqMXMDdMcIvR51eq7JJhxSJJb6Pttay4oaaNdt54PJd6gjA9wLfdB4T2eVF9iBibNdyuf8KnPMvEU6ZpUOE=
X-Received: by 2002:a05:6512:6c4:b0:437:9409:984c with SMTP id
 u4-20020a05651206c400b004379409984cmr643915lff.199.1644984876132; Tue, 15 Feb
 2022 20:14:36 -0800 (PST)
MIME-Version: 1.0
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com> <20220214081416.117695-15-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220214081416.117695-15-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 16 Feb 2022 12:14:25 +0800
Message-ID: <CACGkMEufh3sbGx4wFCkpiXNR0w0WoCC=TNeLHE+QkqrhyXH6Bw@mail.gmail.com>
Subject: Re: [PATCH v5 14/22] virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 4:14 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> This patch implements virtio pci support for QUEUE RESET.
>
> Performing reset on a queue is divided into these steps:
>
> 1. reset_vq: reset one vq
> 2. recycle the buffer from vq by virtqueue_detach_unused_buf()
> 3. release the ring of the vq by vring_release_virtqueue()
> 4. enable_reset_vq: re-enable the reset queue
>
> This patch implements reset_vq, enable_reset_vq in the pci scenario.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_pci_common.c |  8 ++--
>  drivers/virtio/virtio_pci_modern.c | 60 ++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 5a4f750a0b97..9ea319b1d404 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -255,9 +255,11 @@ static void vp_del_vq(struct virtqueue *vq)
>         struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
>         unsigned long flags;
>
> -       spin_lock_irqsave(&vp_dev->lock, flags);
> -       list_del(&info->node);
> -       spin_unlock_irqrestore(&vp_dev->lock, flags);
> +       if (!vq->reset) {
> +               spin_lock_irqsave(&vp_dev->lock, flags);
> +               list_del(&info->node);
> +               spin_unlock_irqrestore(&vp_dev->lock, flags);
> +       }
>
>         vp_dev->del_vq(info);
>         kfree(info);
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index bed3e9b84272..7d28f4c36fc2 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>         if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>                         pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
>                 __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> +
> +       if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> +               __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
>  }
>
>  /* virtio config->finalize_features() implementation */
> @@ -176,6 +179,59 @@ static void vp_reset(struct virtio_device *vdev)
>         vp_disable_cbs(vdev);
>  }
>
> +static int vp_modern_reset_vq(struct virtqueue *vq)
> +{
> +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +       struct virtio_pci_vq_info *info;
> +       unsigned long flags;
> +
> +       if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> +               return -ENOENT;
> +
> +       vp_modern_set_queue_reset(mdev, vq->index);
> +
> +       info = vp_dev->vqs[vq->index];
> +

Any reason that we don't need to disable irq here as the previous versions did?


> +       /* delete vq from irq handler */
> +       spin_lock_irqsave(&vp_dev->lock, flags);
> +       list_del(&info->node);
> +       spin_unlock_irqrestore(&vp_dev->lock, flags);
> +
> +       INIT_LIST_HEAD(&info->node);
> +
> +       vq->reset = VIRTQUEUE_RESET_STAGE_DEVICE;
> +
> +       return 0;
> +}
> +
> +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> +{
> +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +       struct virtio_pci_vq_info *info;
> +       struct virtqueue *_vq;
> +
> +       if (vq->reset != VIRTQUEUE_RESET_STAGE_RELEASE)
> +               return -EBUSY;
> +
> +       /* check queue reset status */
> +       if (vp_modern_get_queue_reset(mdev, vq->index) != 1)
> +               return -EBUSY;
> +
> +       info = vp_dev->vqs[vq->index];
> +       _vq = vp_setup_vq(vq->vdev, vq->index, NULL, NULL, NULL,
> +                        info->msix_vector);

So we only care about moden devices, this means using vp_setup_vq()
with NULL seems tricky.

As replied in another thread, I would simply ask the caller to call
the vring reallocation helper. See the reply for patch 17.

Thanks


> +       if (IS_ERR(_vq)) {
> +               vq->reset = VIRTQUEUE_RESET_STAGE_RELEASE;
> +               return PTR_ERR(_vq);
> +       }
> +
> +       vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
> +
> +       return 0;
> +}
> +
>  static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
>  {
>         return vp_modern_config_vector(&vp_dev->mdev, vector);
> @@ -397,6 +453,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>         .set_vq_affinity = vp_set_vq_affinity,
>         .get_vq_affinity = vp_get_vq_affinity,
>         .get_shm_region  = vp_get_shm_region,
> +       .reset_vq        = vp_modern_reset_vq,
> +       .enable_reset_vq = vp_modern_enable_reset_vq,
>  };
>
>  static const struct virtio_config_ops virtio_pci_config_ops = {
> @@ -415,6 +473,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
>         .set_vq_affinity = vp_set_vq_affinity,
>         .get_vq_affinity = vp_get_vq_affinity,
>         .get_shm_region  = vp_get_shm_region,
> +       .reset_vq        = vp_modern_reset_vq,
> +       .enable_reset_vq = vp_modern_enable_reset_vq,
>  };
>
>  /* the PCI probing function */
> --
> 2.31.0
>

