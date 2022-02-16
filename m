Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AAE4B7F38
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343546AbiBPEPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:15:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245724AbiBPEPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:15:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C757C75E64
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644984889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DC/9cJ1rnmLdF2qNbTho1YXwyhPBz3aGkzgrZwTS3o8=;
        b=LtT+3sDk4/Oj+gzceW/n74VtyYRCdI4G35xjbbbou7W8C2gKa6lJ34gsft3nH32nauIQOX
        V9sfpHWqF9y3w39annhV0R+7lAn5tFwCcSlVrgr6FWvvJGQ+xA+Ox9WSmskzm5Q+YSdLAo
        FBhuTruNEkC+uXv59m24HCXgVc0JwzU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-4avb9S-QN8mFTqcmIZtJpA-1; Tue, 15 Feb 2022 23:14:48 -0500
X-MC-Unique: 4avb9S-QN8mFTqcmIZtJpA-1
Received: by mail-lj1-f198.google.com with SMTP id n9-20020a2e82c9000000b002435af2e8b9so438838ljh.20
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DC/9cJ1rnmLdF2qNbTho1YXwyhPBz3aGkzgrZwTS3o8=;
        b=ml3II+oM/QFp9PhHkVX3gRONOu1MOkjDtsZraFgmj4GBbvvMofGwphoxDKYk11tMXu
         PBUulA30ETYSJIzZ+/G78+Z2Atfoq92DWc4jFfgufEmBgD4N0sm39Z99RrPFbPL6RoIY
         xvvzKnKWBpoEe4kQ15e3k0gQQ8SgZvd0RNgHm6TliEEeC9YmPgHxgCPhH0xfRIjPgunJ
         d2qJ+P0qepaIbEl5cif/UbTFfT4W/LbLzc5+QQ5VP+6XMVHSmef7+106C39DsDN7/7gq
         kzHGpnO4eQPDKUWZWsZ7OR5kDwNKK2XnvBglOCQXlxOBAqhAW/Mx43bAKoYLX+Cf5r8X
         1jUg==
X-Gm-Message-State: AOAM533LCMp9otKpACUQJqrgFWrcquXH7wGh0ZloMohenL+NXFXa4VNb
        4lEPBblgD19qrV7syu0imNfCA5HbBvInXldCyOPm5bzWx/Os26h5nUfUgh2rzVqk+qIS/zYjcSa
        z5KImf5oojLGcykVSf5TITrqWWTYqhmfI
X-Received: by 2002:a2e:b748:0:b0:245:fcd6:c4a3 with SMTP id k8-20020a2eb748000000b00245fcd6c4a3mr697743ljo.362.1644984887133;
        Tue, 15 Feb 2022 20:14:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgeUs3QA39CjiR99ZEeCfiGPEBhNSb5QEYePt31lVdV4ggOPIjPfM5qmPh3/hI8KyMESfuk+OJIcQQZtdXga4=
X-Received: by 2002:a2e:b748:0:b0:245:fcd6:c4a3 with SMTP id
 k8-20020a2eb748000000b00245fcd6c4a3mr697738ljo.362.1644984886923; Tue, 15 Feb
 2022 20:14:46 -0800 (PST)
MIME-Version: 1.0
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com> <20220214081416.117695-9-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220214081416.117695-9-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 16 Feb 2022 12:14:36 +0800
Message-ID: <CACGkMEttDpjYZcsT7Eh0Nm50R27nTBOLDFwBaSKsJ+OL1x26vg@mail.gmail.com>
Subject: Re: [PATCH v5 08/22] virtio_ring: queue_reset: add vring_release_virtqueue()
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 4:14 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> Added vring_release_virtqueue() to release the ring of the vq.
>
> In this process, vq is removed from the vdev->vqs queue. And the memory
> of the ring is released
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 18 +++++++++++++++++-
>  include/linux/virtio.h       | 12 ++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index c5dd17c7dd4a..b37753bdbbc4 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1730,6 +1730,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>         vq->vq.vdev = vdev;
>         vq->vq.num_free = num;
>         vq->vq.index = index;
> +       vq->vq.reset = VIRTQUEUE_RESET_STAGE_NONE;

So we don't have a similar check for detach_unused_buf(), I guess it
should be sufficient to document the API requirement. Otherwise we
probably need some barriers/ordering which are not worthwhile just for
figuring out bad API usage.

>         vq->we_own_ring = true;
>         vq->notify = notify;
>         vq->weak_barriers = weak_barriers;
> @@ -2218,6 +2219,7 @@ static int __vring_init_virtqueue(struct virtqueue *_vq,
>         vq->vq.vdev = vdev;
>         vq->vq.num_free = vring.num;
>         vq->vq.index = index;
> +       vq->vq.reset = VIRTQUEUE_RESET_STAGE_NONE;
>         vq->we_own_ring = false;
>         vq->notify = notify;
>         vq->weak_barriers = weak_barriers;
> @@ -2397,11 +2399,25 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  {
>         struct vring_virtqueue *vq = to_vvq(_vq);
>
> -       __vring_del_virtqueue(vq);
> +       if (_vq->reset != VIRTQUEUE_RESET_STAGE_RELEASE)
> +               __vring_del_virtqueue(vq);
>         kfree(vq);
>  }
>  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
>
> +void vring_release_virtqueue(struct virtqueue *_vq)
> +{

If we agree on that we need a allocation routine, we probably need to
rename this as vring_free_virtqueue()

Thanks

> +       struct vring_virtqueue *vq = to_vvq(_vq);
> +
> +       if (_vq->reset != VIRTQUEUE_RESET_STAGE_DEVICE)
> +               return;
> +
> +       __vring_del_virtqueue(vq);
> +
> +       _vq->reset = VIRTQUEUE_RESET_STAGE_RELEASE;
> +}
> +EXPORT_SYMBOL_GPL(vring_release_virtqueue);
> +
>  /* Manipulates transport-specific feature bits. */
>  void vring_transport_features(struct virtio_device *vdev)
>  {
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 72292a62cd90..cdb2a551257c 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -10,6 +10,12 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/gfp.h>
>
> +enum virtqueue_reset_stage {
> +       VIRTQUEUE_RESET_STAGE_NONE,
> +       VIRTQUEUE_RESET_STAGE_DEVICE,
> +       VIRTQUEUE_RESET_STAGE_RELEASE,
> +};
> +
>  /**
>   * virtqueue - a queue to register buffers for sending or receiving.
>   * @list: the chain of virtqueues for this device
> @@ -32,6 +38,7 @@ struct virtqueue {
>         unsigned int index;
>         unsigned int num_free;
>         void *priv;
> +       enum virtqueue_reset_stage reset;
>  };
>
>  int virtqueue_add_outbuf(struct virtqueue *vq,
> @@ -196,4 +203,9 @@ void unregister_virtio_driver(struct virtio_driver *drv);
>  #define module_virtio_driver(__virtio_driver) \
>         module_driver(__virtio_driver, register_virtio_driver, \
>                         unregister_virtio_driver)
> +/*
> + * Resets a virtqueue. Just frees the ring, not free vq.
> + * This function must be called after reset_vq().
> + */
> +void vring_release_virtqueue(struct virtqueue *vq);
>  #endif /* _LINUX_VIRTIO_H */
> --
> 2.31.0
>

