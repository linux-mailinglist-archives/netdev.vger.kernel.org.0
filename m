Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA924B7F39
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343572AbiBPEPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:15:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237223AbiBPEPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:15:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1322FCB7A
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644984893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M8MTfL3kzhS2e/wtfvfkaRaYdGxaNdzWBHJ20dictyk=;
        b=Z4sBmeh7VPNXdbHyaUh5Tuta/AKvrSIksloiEfS1uhFA5iBYM55HpwwEmSrnjqsgs6bFeO
        8ZqHLko+E9S9sPoGHF/JhJwH17A9KEIRNVHE/48TmVhhc22UyGM3UcOBVc6ToILjGeKBDi
        aZhTnJgkHDcN1gErHUslnzapDpCtgfQ=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-Lky3dN-zP6yS_fGxjnIawQ-1; Tue, 15 Feb 2022 23:14:51 -0500
X-MC-Unique: Lky3dN-zP6yS_fGxjnIawQ-1
Received: by mail-lj1-f200.google.com with SMTP id m7-20020a2ea587000000b00244e2faf769so464198ljp.6
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:14:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M8MTfL3kzhS2e/wtfvfkaRaYdGxaNdzWBHJ20dictyk=;
        b=F2O1kbGJHDXq6AMpHM/paB3BZkh6E82nQowTCkkICsg/jhWoYlUx5T8UfY4FWxiuo+
         LFdlISztpFM6208jNYrkTZ9FYUnM39xDb2w/0pQit2iqW79ydGoemPMGFWFGqK6w8dJV
         UDa1lr1/ZrOJyzr+5irGRIarYm4wTzFnvtce9Hs8wVTj/LWeNEoR9pj5xQ9TiWTejsim
         QBoRPL33am45bH1MZWaRWlJ/yewtyL7AntwKBsRJPn7MZwgKUl4zBizVRK5dk15SMctI
         z/tkb2JuGFc/klp/dEw/gYle0cimHoMS2dkzJMX1apfVTrZfq1nogVmE5qtcj+cfSuxQ
         U9HA==
X-Gm-Message-State: AOAM533DTxgFB42iav7OrKGH1Gawo8fuWzeIHEmDScrzl/jSV/TupX75
        T6Mvb1vfxM79CUNooqihSjGf/HC/s0EkF/z8gB4rgYxDnmIjM6ETNW/sSrNesmMYjIqW9Vbpiax
        y0Qp9LXMNwVv4L2OBD1fK41pHRKf0iLt/
X-Received: by 2002:a2e:bd03:0:b0:244:d446:27dc with SMTP id n3-20020a2ebd03000000b00244d44627dcmr653234ljq.307.1644984890107;
        Tue, 15 Feb 2022 20:14:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIwQDLTLmesj7I7mqh58WPdKsiWqCpL4QKOR+Hkpz63Lh50HmsX1HyFv+emKZYY3EDS4Va/5Qfoi2ktDcaOC4=
X-Received: by 2002:a2e:bd03:0:b0:244:d446:27dc with SMTP id
 n3-20020a2ebd03000000b00244d44627dcmr653217ljq.307.1644984889914; Tue, 15 Feb
 2022 20:14:49 -0800 (PST)
MIME-Version: 1.0
References: <20220214081416.117695-1-xuanzhuo@linux.alibaba.com> <20220214081416.117695-23-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20220214081416.117695-23-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 16 Feb 2022 12:14:39 +0800
Message-ID: <CACGkMEsQB0XCZb39QVsv9VM0qJpc__jucgUCGV9LU5kPTze6Hg@mail.gmail.com>
Subject: Re: [PATCH v5 22/22] virtio_net: support set_ringparam
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

On Mon, Feb 14, 2022 at 4:15 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> Support set_ringparam based on virtio queue reset.
>
> The rx,tx_pending required to be passed must be power of 2.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 50 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f9bb760c6dbd..bf460ea87354 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2308,6 +2308,55 @@ static void virtnet_get_ringparam(struct net_device *dev,
>         ring->tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
>  }
>
> +static int virtnet_set_ringparam(struct net_device *dev,
> +                                struct ethtool_ringparam *ring,
> +                                struct kernel_ethtool_ringparam *kernel_ring,
> +                                struct netlink_ext_ack *extack)
> +{
> +       struct virtnet_info *vi = netdev_priv(dev);
> +       u32 rx_pending, tx_pending;
> +       int i, err;
> +
> +       if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> +               return -EINVAL;
> +
> +       rx_pending = virtqueue_get_vring_size(vi->rq[0].vq);
> +       tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
> +
> +       if (ring->rx_pending == rx_pending &&
> +           ring->tx_pending == tx_pending)
> +               return 0;
> +
> +       if (ring->rx_pending > virtqueue_get_vring_max_size(vi->rq[0].vq))
> +               return -EINVAL;
> +
> +       if (ring->tx_pending > virtqueue_get_vring_max_size(vi->sq[0].vq))
> +               return -EINVAL;
> +
> +       if (!is_power_of_2(ring->rx_pending))
> +               return -EINVAL;
> +
> +       if (!is_power_of_2(ring->tx_pending))
> +               return -EINVAL;

We'd better leave those checks to the virtio core where it knows
packed virtqueue doesn't have this limitation.

> +
> +       for (i = 0; i < vi->max_queue_pairs; i++) {
> +               if (ring->tx_pending != tx_pending) {
> +                       virtio_set_max_ring_num(vi->vdev, ring->tx_pending);

The name is kind of confusing, I guess it should not be the maximum
ring. And this needs to be done after the reset, and it would be even
better to disallow such change when virtqueue is not resetted.

> +                       err = virtnet_tx_vq_reset(vi, i);
> +                       if (err)
> +                               return err;
> +               }
> +
> +               if (ring->rx_pending != rx_pending) {
> +                       virtio_set_max_ring_num(vi->vdev, ring->rx_pending);
> +                       err = virtnet_rx_vq_reset(vi, i);
> +                       if (err)
> +                               return err;
> +               }
> +       }
> +
> +       return 0;
> +}
>
>  static void virtnet_get_drvinfo(struct net_device *dev,
>                                 struct ethtool_drvinfo *info)
> @@ -2541,6 +2590,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>         .get_drvinfo = virtnet_get_drvinfo,
>         .get_link = ethtool_op_get_link,
>         .get_ringparam = virtnet_get_ringparam,
> +       .set_ringparam = virtnet_set_ringparam,
>         .get_strings = virtnet_get_strings,
>         .get_sset_count = virtnet_get_sset_count,
>         .get_ethtool_stats = virtnet_get_ethtool_stats,
> --
> 2.31.0
>

