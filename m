Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5334B99D0
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiBQHZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:25:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbiBQHZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:25:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 723B62A0D53
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645082726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sNlRlH2sR1zEEfEZx3VUbIdvRvCNZdqDLBN9MKRUPII=;
        b=XaEap0WseHL/k1FU+1xsW7x8cl07ryMLVOVVmaILeQrJKjvgaLnpyjDE8OckkqtYKDBycX
        wupynFhNK1kUJSW8JIDjIjSBwNc5WGYz2q2wnvlNGSMZqvardPPUGr61PTUQbSF8x3ojPc
        4Q3ltUXq9yiVe7V7dEPVkPuh1khBnaA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-aRgCAJtzNhylJnungcoIbQ-1; Thu, 17 Feb 2022 02:25:25 -0500
X-MC-Unique: aRgCAJtzNhylJnungcoIbQ-1
Received: by mail-lf1-f70.google.com with SMTP id z37-20020a0565120c2500b004433b7d95d3so1525013lfu.4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:25:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sNlRlH2sR1zEEfEZx3VUbIdvRvCNZdqDLBN9MKRUPII=;
        b=V2Y98nDl6Vg3Ce6a2PPX7AKlrH+fjneOKeY5dlQghLRmkwhklGCnlIOtNiG6eejmX1
         kiLNCryMOcsoVX/hMThyDgSVk6+yj24KKUIbx8YsaYhrk+66W6b0ELuWD3D+ec4qJ5GD
         DuyTW9jyNetuITBpj/azO4m3RqmE3QwPXmRYVd9a9EhXl2gzE+sA2vY2HgD3gB+Cn2kf
         SbwAPDqYvfMdDaZOdcO6PUziSfHFS8HFw/cz1BGdteWOvPzq7LFhzMjTX2xITO/f5HK5
         h1/Ez0qLkUC1jmRq+iWkxKJAdR/LKN2hXvnHajgl4u3L6eUrDHZSJgZxU/VVys5bTlQd
         yHtQ==
X-Gm-Message-State: AOAM532spGdPHnCB6JlroAzVKsf5lDQUBb/uXaRwRQhemoDhYxQNsjZN
        w7S/sxzvaAcWKCL26ax+qXkYbjxMbw4Ou45Foe24Lq8J+Gs/LLiHOsVy3xCRX2kvhBS33cXVouk
        AKzRE2kB/65VIWiOXeWMKxdIuur433HaV
X-Received: by 2002:a05:6512:2205:b0:443:7f91:7aaa with SMTP id h5-20020a056512220500b004437f917aaamr1219239lfu.580.1645082723580;
        Wed, 16 Feb 2022 23:25:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwR8xJrhWSFtYs+Sy66tR0N8p/P8you8W1THZDoS8h2O9oP1Ma/wA/ffCoJjTgZG+XZOmctzCbIL/u5foLKP5w=
X-Received: by 2002:a05:6512:2205:b0:443:7f91:7aaa with SMTP id
 h5-20020a056512220500b004437f917aaamr1219224lfu.580.1645082723354; Wed, 16
 Feb 2022 23:25:23 -0800 (PST)
MIME-Version: 1.0
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com>
 <20220214081416.117695-15-xuanzhuo@linux.alibaba.com> <CACGkMEufh3sbGx4wFCkpiXNR0w0WoCC=TNeLHE+QkqrhyXH6Bw@mail.gmail.com>
 <1644998595.3309107-4-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644998595.3309107-4-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Feb 2022 15:25:12 +0800
Message-ID: <CACGkMEtdQXEW9K4j13NMVOxsURCD8bWiBy3u7v5dUu8Ymgx_MA@mail.gmail.com>
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

On Wed, Feb 16, 2022 at 4:08 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Wed, 16 Feb 2022 12:14:25 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > On Mon, Feb 14, 2022 at 4:14 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > This patch implements virtio pci support for QUEUE RESET.
> > >
> > > Performing reset on a queue is divided into these steps:
> > >
> > > 1. reset_vq: reset one vq
> > > 2. recycle the buffer from vq by virtqueue_detach_unused_buf()
> > > 3. release the ring of the vq by vring_release_virtqueue()
> > > 4. enable_reset_vq: re-enable the reset queue
> > >
> > > This patch implements reset_vq, enable_reset_vq in the pci scenario.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/virtio/virtio_pci_common.c |  8 ++--
> > >  drivers/virtio/virtio_pci_modern.c | 60 ++++++++++++++++++++++++++++++
> > >  2 files changed, 65 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> > > index 5a4f750a0b97..9ea319b1d404 100644
> > > --- a/drivers/virtio/virtio_pci_common.c
> > > +++ b/drivers/virtio/virtio_pci_common.c
> > > @@ -255,9 +255,11 @@ static void vp_del_vq(struct virtqueue *vq)
> > >         struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
> > >         unsigned long flags;
> > >
> > > -       spin_lock_irqsave(&vp_dev->lock, flags);
> > > -       list_del(&info->node);
> > > -       spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +       if (!vq->reset) {
> > > +               spin_lock_irqsave(&vp_dev->lock, flags);
> > > +               list_del(&info->node);
> > > +               spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +       }
> > >
> > >         vp_dev->del_vq(info);
> > >         kfree(info);
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> > > index bed3e9b84272..7d28f4c36fc2 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
> > >         if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
> > >                         pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
> > >                 __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
> > > +
> > > +       if (features & BIT_ULL(VIRTIO_F_RING_RESET))
> > > +               __virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> > >  }
> > >
> > >  /* virtio config->finalize_features() implementation */
> > > @@ -176,6 +179,59 @@ static void vp_reset(struct virtio_device *vdev)
> > >         vp_disable_cbs(vdev);
> > >  }
> > >
> > > +static int vp_modern_reset_vq(struct virtqueue *vq)
> > > +{
> > > +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> > > +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> > > +       struct virtio_pci_vq_info *info;
> > > +       unsigned long flags;
> > > +
> > > +       if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> > > +               return -ENOENT;
> > > +
> > > +       vp_modern_set_queue_reset(mdev, vq->index);
> > > +
> > > +       info = vp_dev->vqs[vq->index];
> > > +
> >
> > Any reason that we don't need to disable irq here as the previous versions did?
>
> Based on the spec, for the case of one interrupt per queue, there will be no
> more interrupts after the reset queue operation. Whether the interrupt is turned
> off or not has no effect. I turned off the interrupt before just to be safe.

So:

1) CPU0 -> get an interrupt
2) CPU1 -> vp_modern_reset_vq
2) CPU0 -> do_IRQ()

We still need to synchronize with the irq handler in this case?

Thanks

>
> And for irq sharing scenarios, I don't want to turn off shared interrupts for a
> queue.
>
> And the following list_del has been guaranteed to be safe, so I removed the code
> for closing interrupts in the previous version.
>
> Thanks.
>
> >
> >
> > > +       /* delete vq from irq handler */
> > > +       spin_lock_irqsave(&vp_dev->lock, flags);
> > > +       list_del(&info->node);
> > > +       spin_unlock_irqrestore(&vp_dev->lock, flags);
> > > +
> > > +       INIT_LIST_HEAD(&info->node);
> > > +
> > > +       vq->reset = VIRTQUEUE_RESET_STAGE_DEVICE;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> > > +{
> > > +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> > > +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> > > +       struct virtio_pci_vq_info *info;
> > > +       struct virtqueue *_vq;
> > > +
> > > +       if (vq->reset != VIRTQUEUE_RESET_STAGE_RELEASE)
> > > +               return -EBUSY;
> > > +
> > > +       /* check queue reset status */
> > > +       if (vp_modern_get_queue_reset(mdev, vq->index) != 1)
> > > +               return -EBUSY;
> > > +
> > > +       info = vp_dev->vqs[vq->index];
> > > +       _vq = vp_setup_vq(vq->vdev, vq->index, NULL, NULL, NULL,
> > > +                        info->msix_vector);
> >
> > So we only care about moden devices, this means using vp_setup_vq()
> > with NULL seems tricky.
> >
> > As replied in another thread, I would simply ask the caller to call
> > the vring reallocation helper. See the reply for patch 17.

Right.

Thanks.

> >
> > Thanks
> >
> >
> > > +       if (IS_ERR(_vq)) {
> > > +               vq->reset = VIRTQUEUE_RESET_STAGE_RELEASE;
> > > +               return PTR_ERR(_vq);
> > > +       }
> > > +
> > > +       vp_modern_set_queue_enable(&vp_dev->mdev, vq->index, true);
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
> > >  {
> > >         return vp_modern_config_vector(&vp_dev->mdev, vector);
> > > @@ -397,6 +453,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
> > >         .set_vq_affinity = vp_set_vq_affinity,
> > >         .get_vq_affinity = vp_get_vq_affinity,
> > >         .get_shm_region  = vp_get_shm_region,
> > > +       .reset_vq        = vp_modern_reset_vq,
> > > +       .enable_reset_vq = vp_modern_enable_reset_vq,
> > >  };
> > >
> > >  static const struct virtio_config_ops virtio_pci_config_ops = {
> > > @@ -415,6 +473,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
> > >         .set_vq_affinity = vp_set_vq_affinity,
> > >         .get_vq_affinity = vp_get_vq_affinity,
> > >         .get_shm_region  = vp_get_shm_region,
> > > +       .reset_vq        = vp_modern_reset_vq,
> > > +       .enable_reset_vq = vp_modern_enable_reset_vq,
> > >  };
> > >
> > >  /* the PCI probing function */
> > > --
> > > 2.31.0
> > >
> >
>

