Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BA3643D26
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 07:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiLFGfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 01:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiLFGfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 01:35:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9262B220D9
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 22:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670308446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SVXC2/3NVWe3p2txzbLaPDbYFhPcwOduZ4bfkAoxu2s=;
        b=Voio9MLGlcNheW5nXyrYs+ihwrU6tl6PRXT/b14tJnh1HFvvdTEY5dIl87PEhB4OEGdiQK
        f4cy1JlQI5nWRESGe/2IA2RFCfn+Ed0r5fmfkvBafNKkFrAqT9sseea2/I/h4ZdyhlnM5G
        7EKcnJ8et0gcZ319imI1o7jihQO44pY=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-CSJbqfG9MzG3aZVLDPmt0Q-1; Tue, 06 Dec 2022 01:34:05 -0500
X-MC-Unique: CSJbqfG9MzG3aZVLDPmt0Q-1
Received: by mail-oo1-f72.google.com with SMTP id y19-20020a4a9c13000000b0049dd7ad41c4so5234024ooj.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 22:34:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SVXC2/3NVWe3p2txzbLaPDbYFhPcwOduZ4bfkAoxu2s=;
        b=KznoSka34mbWSsVOSPeTtQkGB8m1nn0+0ipAgcVSikYHzIdOrV1aTT5m1oQOXG1zkO
         bXRmwAfcjwKMGk993TfjOObfMWAfp/RSWclfhYijTKQYN0ea9hmvo3HMuWYdoLQgGlaD
         6EamPTanyNcQlp5n5EyO2rNKOov3wPAcoY2v/gGEvXHKGClSraGTK5NliF/NDSRXmHiI
         stiq9cTASBsZvedj/5eh2DM8YgB+qAlJm+DR8urhMVJstDjN6EHCGaRHNsMe2ELkrTM7
         K+zPc29rLI2jg/pxlBTbLbJd6VtKOc0KPoeelvvVeE9N+N7loB82TyQgusIOMTJXRi3Q
         whKQ==
X-Gm-Message-State: ANoB5plkAn+GtbB4svtGM1KemcSEstTTYlhEzEZK0F+DuOmhlplXpJ54
        15M/5PHUlJaf7nFSrkFNDsz1ti8wnazf9VwNo0kOv2Q0VPDh85HkQMjhyl+lAmt07z//DEDJiVe
        a1JvP/YFnfLG2P4lg0mp31tBbZgfVi44R
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id a18-20020aca1a12000000b0035c303dfe37mr4094546oia.35.1670308444587;
        Mon, 05 Dec 2022 22:34:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf78MRjj4k7smT46pJ2ai7qosDZgSEsi6VkAHGp7m2rbQsPEnwX0x94MzoslMYbbO/4M3e01ktrOHGZxRaJT6vI=
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id
 a18-20020aca1a12000000b0035c303dfe37mr4094536oia.35.1670308444309; Mon, 05
 Dec 2022 22:34:04 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com> <20221122074348.88601-7-hengqi@linux.alibaba.com>
In-Reply-To: <20221122074348.88601-7-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Dec 2022 14:33:53 +0800
Message-ID: <CACGkMEsbX8w1wuU+954zVwNT5JvCHX7a9baKRytVb641UmNsuw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/9] virtio_net: construct multi-buffer xdp in mergeable
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> Build multi-buffer xdp using virtnet_build_xdp_buff() in mergeable.
>
> For the prefilled buffer before xdp is set, vq reset can be
> used to clear it, but most devices do not support it at present.
> In order not to bother users who are using xdp normally, we do
> not use vq reset for the time being.

I guess to tweak the part to say we will probably use vq reset in the future.

> At the same time, virtio
> net currently uses comp pages, and bpf_xdp_frags_increase_tail()
> needs to calculate the tailroom of the last frag, which will
> involve the offset of the corresponding page and cause a negative
> value, so we disable tail increase by not setting xdp_rxq->frag_size.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 67 +++++++++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 20784b1d8236..83e6933ae62b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -994,6 +994,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>                                          unsigned int *xdp_xmit,
>                                          struct virtnet_rq_stats *stats)
>  {
> +       unsigned int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>         struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
>         u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
>         struct page *page = virt_to_head_page(buf);
> @@ -1024,53 +1025,50 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>         rcu_read_lock();
>         xdp_prog = rcu_dereference(rq->xdp_prog);
>         if (xdp_prog) {
> +               unsigned int xdp_frags_truesz = 0;
> +               struct skb_shared_info *shinfo;
>                 struct xdp_frame *xdpf;
>                 struct page *xdp_page;
>                 struct xdp_buff xdp;
>                 void *data;
>                 u32 act;
> +               int i;
>
> -               /* Transient failure which in theory could occur if
> -                * in-flight packets from before XDP was enabled reach
> -                * the receive path after XDP is loaded.
> -                */
> -               if (unlikely(hdr->hdr.gso_type))
> -                       goto err_xdp;

Two questions:

1) should we keep this check for the XDP program that can't deal with XDP frags?
2) how could we guarantee that the vnet header (gso_type/csum_start
etc) is still valid after XDP (where XDP program can choose to
override the header)?

> -
> -               /* Buffers with headroom use PAGE_SIZE as alloc size,
> -                * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> +               /* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> +                * with headroom may add hole in truesize, which
> +                * make their length exceed PAGE_SIZE. So we disabled the
> +                * hole mechanism for xdp. See add_recvbuf_mergeable().
>                  */
>                 frame_sz = headroom ? PAGE_SIZE : truesize;
>
> -               /* This happens when rx buffer size is underestimated
> -                * or headroom is not enough because of the buffer
> -                * was refilled before XDP is set. This should only
> -                * happen for the first several packets, so we don't
> -                * care much about its performance.
> +               /* This happens when headroom is not enough because
> +                * of the buffer was prefilled before XDP is set.
> +                * This should only happen for the first several packets.
> +                * In fact, vq reset can be used here to help us clean up
> +                * the prefilled buffers, but many existing devices do not
> +                * support it, and we don't want to bother users who are
> +                * using xdp normally.
>                  */
> -               if (unlikely(num_buf > 1 ||
> -                            headroom < virtnet_get_headroom(vi))) {
> -                       /* linearize data for XDP */
> -                       xdp_page = xdp_linearize_page(rq, &num_buf,
> -                                                     page, offset,
> -                                                     VIRTIO_XDP_HEADROOM,
> -                                                     &len);
> -                       frame_sz = PAGE_SIZE;
> +               if (unlikely(headroom < virtnet_get_headroom(vi))) {
> +                       if ((VIRTIO_XDP_HEADROOM + len + tailroom) > PAGE_SIZE)
> +                               goto err_xdp;
>
> +                       xdp_page = alloc_page(GFP_ATOMIC);
>                         if (!xdp_page)
>                                 goto err_xdp;
> +
> +                       memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> +                              page_address(page) + offset, len);
> +                       frame_sz = PAGE_SIZE;

How can we know a single page is sufficient here? (before XDP is set,
we reserve neither headroom nor tailroom).

>                         offset = VIRTIO_XDP_HEADROOM;

I think we should still try to do linearization for the XDP program
that doesn't support XDP frags.

Thanks

>                 } else {
>                         xdp_page = page;
>                 }
> -
> -               /* Allow consuming headroom but reserve enough space to push
> -                * the descriptor on if we get an XDP_TX return code.
> -                */
>                 data = page_address(xdp_page) + offset;
> -               xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
> -               xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + vi->hdr_len,
> -                                VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
> +               err = virtnet_build_xdp_buff(dev, vi, rq, &xdp, data, len, frame_sz,
> +                                            &num_buf, &xdp_frags_truesz, stats);
> +               if (unlikely(err))
> +                       goto err_xdp_frags;
>
>                 act = bpf_prog_run_xdp(xdp_prog, &xdp);
>                 stats->xdp_packets++;
> @@ -1164,6 +1162,17 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>                                 __free_pages(xdp_page, 0);
>                         goto err_xdp;
>                 }
> +err_xdp_frags:
> +               shinfo = xdp_get_shared_info_from_buff(&xdp);
> +
> +               if (unlikely(xdp_page != page))
> +                       __free_pages(xdp_page, 0);
> +
> +               for (i = 0; i < shinfo->nr_frags; i++) {
> +                       xdp_page = skb_frag_page(&shinfo->frags[i]);
> +                       put_page(xdp_page);
> +               }
> +               goto err_xdp;
>         }
>         rcu_read_unlock();
>
> --
> 2.19.1.6.gb485710b
>

