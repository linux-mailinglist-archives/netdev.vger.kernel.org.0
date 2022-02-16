Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6C14B7F26
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245722AbiBPEOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:14:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245697AbiBPEOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:14:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 755FD6D84E
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644984873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E3b3uR5MMPzm1En/lQgKQ0CsRJyNewt+DAjMnvVIPGk=;
        b=JVu4MjmofYxcmO7//XTnAbPV0QeSHEj1Xb2A11wUnrbU6gXP3IKQhB7DFU//wbmy2U/9YV
        eZ6t1EvtR6A0BiU1iR0cIGXcgmCjj9pZpYAiaBGVDK7n+zUCN2BkM0fOYn+GYKsL2WvY6o
        2tuTGJflpwUApqA7d/ybUgXuvCzEga8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-kHk73fxyOjyroGj-jpMj_A-1; Tue, 15 Feb 2022 23:14:32 -0500
X-MC-Unique: kHk73fxyOjyroGj-jpMj_A-1
Received: by mail-lf1-f71.google.com with SMTP id v13-20020ac2592d000000b004435f5315dbso266887lfi.21
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3b3uR5MMPzm1En/lQgKQ0CsRJyNewt+DAjMnvVIPGk=;
        b=v2cXtsgPRG+8k7HjFxNR9dVTgrdBLw2kCmhNuARfU4swMlyFUwfQLHfB50cma2gwJh
         5/xHF7tXEWd++UFFXF5JBNYg+3tAMVmW6yjs08lCnh7O+2aZx39P5OoBx2tNooxt741e
         cCUiO5U7IFo7p6vPNbAdTLVCt+/tXtWfrTEwBnDkyVivdINS5iRQUYHWtwsNii9XxoxI
         QXFfNtBntTw2Th1BrvtJV61JWsD6ApmiEKbNYgHEWCKiJu2p8Uy2SeCsGhi9G0fYcBKF
         3RhUaid/yb03ATuoxWWyvBP2oZoyIUGSbe/1kxsl9cY1shhxok/1hslNkHfi8zaBcpV/
         36Hw==
X-Gm-Message-State: AOAM533NQc4Bdm8waU/0D1xYvc6sC4q30W8uRRwe+OymTmtoOPllzzHZ
        yf+oI/T4IHHwiUNwOlo19lnqnIe5Yp8AWUwfg2P4AYBOmJm+g/8Q6xU8JFqYc96gUwfYmVPsszi
        eclvfPwTLBGk4oOjk3e7fNa3onRf0k266
X-Received: by 2002:a05:6512:2808:b0:43f:4baa:7e5f with SMTP id cf8-20020a056512280800b0043f4baa7e5fmr679416lfb.498.1644984870826;
        Tue, 15 Feb 2022 20:14:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvGQ/nnJgLPQUQhwuqE8vh7JijE6JMtt5Dan0917QmW8EwCohodifZ+blu+a5ngcwNhPqmxW/s7gwTwysBlsY=
X-Received: by 2002:a05:6512:2808:b0:43f:4baa:7e5f with SMTP id
 cf8-20020a056512280800b0043f4baa7e5fmr679397lfb.498.1644984870621; Tue, 15
 Feb 2022 20:14:30 -0800 (PST)
MIME-Version: 1.0
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com> <20220214081416.117695-7-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220214081416.117695-7-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 16 Feb 2022 12:14:19 +0800
Message-ID: <CACGkMEt_WcAzcxYGyEvX8zATrbzxmMZzCJYhW_gsML0Ge5xvEA@mail.gmail.com>
Subject: Re: [PATCH v5 06/22] virtio_ring: queue_reset: packed: support enable
 reset queue
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
> The purpose of this patch is to make vring packed support re-enable reset
> vq.
>
> Based on whether the incoming vq passed by vring_setup_virtqueue() is
> NULL or not, distinguish whether it is a normal create virtqueue or
> re-enable a reset queue.
>
> When re-enable a reset queue, reuse the original callback, name, indirect.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_ring.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 4639e1643c78..20659f7ca582 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1683,7 +1683,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
>         bool context,
>         bool (*notify)(struct virtqueue *),
>         void (*callback)(struct virtqueue *),
> -       const char *name)
> +       const char *name,
> +       struct virtqueue *_vq)
>  {
>         struct vring_virtqueue *vq;
>         struct vring_packed_desc *ring;
> @@ -1713,13 +1714,20 @@ static struct virtqueue *vring_create_virtqueue_packed(
>         if (!device)
>                 goto err_device;
>
> -       vq = kmalloc(sizeof(*vq), GFP_KERNEL);
> -       if (!vq)
> -               goto err_vq;
> +       if (_vq) {
> +               vq = to_vvq(_vq);
> +       } else {
> +               vq = kmalloc(sizeof(*vq), GFP_KERNEL);
> +               if (!vq)
> +                       goto err_vq;
> +
> +               vq->vq.callback = callback;
> +               vq->vq.name = name;
> +               vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
> +                       !context;
> +       }

The code looks tricky. Except for the memory we don't even need to
touch any of the other attributes.

I'd suggest splitting out the vring allocation into a dedicated helper
that could be called by both vring_create_queue_XXX and the enable()
logic (and in the enable logic we don't even need to relocate if size
is not changed).

Thanks

>
> -       vq->vq.callback = callback;
>         vq->vq.vdev = vdev;
> -       vq->vq.name = name;
>         vq->vq.num_free = num;
>         vq->vq.index = index;
>         vq->we_own_ring = true;
> @@ -1736,8 +1744,6 @@ static struct virtqueue *vring_create_virtqueue_packed(
>         vq->last_add_time_valid = false;
>  #endif
>
> -       vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
> -               !context;
>         vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
>
>         if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> @@ -1778,7 +1784,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>                 goto err_desc_extra;
>
>         /* No callback?  Tell other side not to bother us. */
> -       if (!callback) {
> +       if (!vq->vq.callback) {
>                 vq->packed.event_flags_shadow = VRING_PACKED_EVENT_FLAG_DISABLE;
>                 vq->packed.vring.driver->flags =
>                         cpu_to_le16(vq->packed.event_flags_shadow);
> @@ -1792,7 +1798,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
>  err_desc_extra:
>         kfree(vq->packed.desc_state);
>  err_desc_state:
> -       kfree(vq);
> +       if (!_vq)
> +               kfree(vq);
>  err_vq:
>         vring_free_queue(vdev, event_size_in_bytes, device, device_event_dma_addr);
>  err_device:
> @@ -2317,7 +2324,7 @@ struct virtqueue *vring_setup_virtqueue(
>         if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
>                 return vring_create_virtqueue_packed(index, num, vring_align,
>                                 vdev, weak_barriers, may_reduce_num,
> -                               context, notify, callback, name);
> +                               context, notify, callback, name, vq);
>
>         return vring_create_virtqueue_split(index, num, vring_align,
>                         vdev, weak_barriers, may_reduce_num,
> --
> 2.31.0
>

