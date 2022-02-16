Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F5F4B7F27
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245707AbiBPEOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:14:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245697AbiBPEOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:14:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 505B575E64
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644984865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hkH+Fw1g25wmzz0motWkGyLx4yyB/LCgVvvS7rJG570=;
        b=A/N9hrY97BYkdFzmOIem7M0N8t/DWte4repdWcIlDQlSrmkggEqvAYYUMEXQTRg92cO2kO
        RPnA+2K4oRtf3tkoCt0d/Rr2zvexcy0RPFt5t6X2PY2J7YCkwqkSEXsJYcRbyCwHov9N1r
        Lz/z4xPxOPWqDYMCac5BNuk/wq5oswc=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-K-_V4znCNiyMvX47kUDanA-1; Tue, 15 Feb 2022 23:14:24 -0500
X-MC-Unique: K-_V4znCNiyMvX47kUDanA-1
Received: by mail-lj1-f199.google.com with SMTP id i10-20020a05651c120a00b00244c2eb1539so440740lja.21
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hkH+Fw1g25wmzz0motWkGyLx4yyB/LCgVvvS7rJG570=;
        b=LjPnHrz5zBQo4Q6YF/YF+Oo4ddJcjBXHM+wLnN/uHC5e2bBOxYMGeuNOBONDs0i9U6
         WDZcg5c69DemSzzpF+iaZepsdVHbmuizdH7XJ+KlX9o1Uz6gyvhep2ZfrLuYZ/lvL7LE
         Y74jsMhjUOxwNvt8Wx5qfjwQA5TI2U40OQ+UTJOMb7ViLDtgBY18G63R9TvX3x+XvnnL
         YvTPz+yhXBnl2okKDri0JNOf2Q3ftPfNUCOyvkz34j9vs41LvT24FALjcDrhgB801baH
         fjfUoZ3Dqxk3JE0Iz2jwZ9z28vJVC5xlg+/XD8jZIOTp6dK8PdKxK6TawTub99CJaBsb
         1Mfw==
X-Gm-Message-State: AOAM5338lZSJuUCW4UDENhzf5mAWWQeFRAlzs53aQPD3cpBSvLtR+qnB
        TgVGJxRWG57dNGqSmGNT+RUVe159IU/xricrDbHnQyS9GSy+wtCeoFMg9KxCt8+9wkt5EgD/SFI
        D6ic4H0DD9EHux+5qBMIZweMfxaAwrM6X
X-Received: by 2002:a05:6512:3a81:b0:443:3ae7:33af with SMTP id q1-20020a0565123a8100b004433ae733afmr668251lfu.481.1644984862654;
        Tue, 15 Feb 2022 20:14:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRVo50AruHxXqmY/yLBFDcf8ggmkJHeya3tApjNJhB/lsnGsPXpb51U/jfAQJfPXdJI1xKxTM3cZK1zkLozI0=
X-Received: by 2002:a05:6512:3a81:b0:443:3ae7:33af with SMTP id
 q1-20020a0565123a8100b004433ae733afmr668246lfu.481.1644984862461; Tue, 15 Feb
 2022 20:14:22 -0800 (PST)
MIME-Version: 1.0
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com> <20220214081416.117695-18-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220214081416.117695-18-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 16 Feb 2022 12:14:11 +0800
Message-ID: <CACGkMEszV_sUt+7gpLJ=6S1Spa0RmY=Ck0_duEkGf6xKOPG+oQ@mail.gmail.com>
Subject: Re: [PATCH v5 17/22] virtio_net: support rx/tx queue reset
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
> This patch implements the reset function of the rx, tx queues.
>
> Based on this function, it is possible to modify the ring num of the
> queue. And quickly recycle the buffer in the queue.
>
> In the process of the queue disable, in theory, as long as virtio
> supports queue reset, there will be no exceptions.
>
> However, in the process of the queue enable, there may be exceptions due to
> memory allocation.  In this case, vq is not available, but we still have
> to execute napi_enable(). Because napi_disable is similar to a lock,
> napi_enable must be called after calling napi_disable.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 123 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 123 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9a1445236e23..a4ffd7cdf623 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -251,6 +251,11 @@ struct padded_vnet_hdr {
>         char padding[4];
>  };
>
> +static void virtnet_sq_free_unused_bufs(struct virtnet_info *vi,
> +                                       struct send_queue *sq);
> +static void virtnet_rq_free_unused_bufs(struct virtnet_info *vi,
> +                                       struct receive_queue *rq);
> +
>  static bool is_xdp_frame(void *ptr)
>  {
>         return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> @@ -1369,6 +1374,9 @@ static void virtnet_napi_enable(struct virtqueue *vq, struct napi_struct *napi)
>  {
>         napi_enable(napi);
>
> +       if (vq->reset)
> +               return;
> +
>         /* If all buffers were filled by other side before we napi_enabled, we
>          * won't get another interrupt, so process any outstanding packets now.
>          * Call local_bh_enable after to trigger softIRQ processing.
> @@ -1413,6 +1421,10 @@ static void refill_work(struct work_struct *work)
>                 struct receive_queue *rq = &vi->rq[i];
>
>                 napi_disable(&rq->napi);
> +               if (rq->vq->reset) {
> +                       virtnet_napi_enable(rq->vq, &rq->napi);
> +                       continue;
> +               }
>                 still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
>                 virtnet_napi_enable(rq->vq, &rq->napi);
>
> @@ -1523,6 +1535,9 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>         if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
>                 return;
>
> +       if (sq->vq->reset)
> +               return;
> +
>         if (__netif_tx_trylock(txq)) {
>                 do {
>                         virtqueue_disable_cb(sq->vq);
> @@ -1769,6 +1784,114 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>         return NETDEV_TX_OK;
>  }
>
> +static int virtnet_rx_vq_disable(struct virtnet_info *vi,
> +                                struct receive_queue *rq)
> +{
> +       int err;
> +
> +       napi_disable(&rq->napi);
> +
> +       err = virtio_reset_vq(rq->vq);
> +       if (err)
> +               goto err;
> +
> +       virtnet_rq_free_unused_bufs(vi, rq);
> +
> +       vring_release_virtqueue(rq->vq);
> +
> +       return 0;
> +
> +err:
> +       virtnet_napi_enable(rq->vq, &rq->napi);
> +       return err;
> +}
> +
> +static int virtnet_tx_vq_disable(struct virtnet_info *vi,
> +                                struct send_queue *sq)
> +{
> +       struct netdev_queue *txq;
> +       int err, qindex;
> +
> +       qindex = sq - vi->sq;
> +
> +       txq = netdev_get_tx_queue(vi->dev, qindex);
> +       __netif_tx_lock_bh(txq);
> +
> +       netif_stop_subqueue(vi->dev, qindex);
> +       virtnet_napi_tx_disable(&sq->napi);
> +
> +       err = virtio_reset_vq(sq->vq);
> +       if (err) {
> +               virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> +               netif_start_subqueue(vi->dev, qindex);
> +
> +               __netif_tx_unlock_bh(txq);
> +               return err;
> +       }
> +       __netif_tx_unlock_bh(txq);
> +
> +       virtnet_sq_free_unused_bufs(vi, sq);
> +
> +       vring_release_virtqueue(sq->vq);
> +
> +       return 0;
> +}
> +
> +static int virtnet_tx_vq_enable(struct virtnet_info *vi, struct send_queue *sq)
> +{
> +       int err;
> +
> +       err = virtio_enable_resetq(sq->vq);
> +       if (!err)
> +               netif_start_subqueue(vi->dev, sq - vi->sq);
> +
> +       virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> +
> +       return err;
> +}
> +
> +static int virtnet_rx_vq_enable(struct virtnet_info *vi,
> +                               struct receive_queue *rq)
> +{
> +       int err;

So the API should be design in a consistent way.

In rx_vq_disable() we do:

reset()
detach_unused_bufs()
vring_release_virtqueue()

here it's better to exactly the reverse

vring_attach_virtqueue() // this is the helper I guess in patch 5,
reverse of the vring_release_virtqueue()
try_refill_recv() // reverse of the detach_unused_bufs()
enable_reset() // reverse of the reset

So did for the tx (no need for refill in that case).

> +
> +       err = virtio_enable_resetq(rq->vq);
> +
> +       virtnet_napi_enable(rq->vq, &rq->napi);
> +
> +       return err;
> +}
> +
> +static int virtnet_rx_vq_reset(struct virtnet_info *vi, int i)
> +{
> +       int err;
> +
> +       err = virtnet_rx_vq_disable(vi, vi->rq + i);
> +       if (err)
> +               return err;
> +
> +       err = virtnet_rx_vq_enable(vi, vi->rq + i);
> +       if (err)
> +               netdev_err(vi->dev,
> +                          "enable rx reset vq fail: rx queue index: %d err: %d\n", i, err);
> +       return err;
> +}
> +
> +static int virtnet_tx_vq_reset(struct virtnet_info *vi, int i)
> +{
> +       int err;
> +
> +       err = virtnet_tx_vq_disable(vi, vi->sq + i);
> +       if (err)
> +               return err;
> +
> +       err = virtnet_tx_vq_enable(vi, vi->sq + i);
> +       if (err)
> +               netdev_err(vi->dev,
> +                          "enable tx reset vq fail: tx queue index: %d err: %d\n", i, err);
> +       return err;
> +}
> +
>  /*
>   * Send command via the control virtqueue and check status.  Commands
>   * supported by the hypervisor, as indicated by feature bits, should
> --
> 2.31.0
>

