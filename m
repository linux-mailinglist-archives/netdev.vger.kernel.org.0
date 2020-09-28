Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B9927A9B9
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgI1Ijb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgI1Ija (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 04:39:30 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA486C0613CE
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:39:30 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id q124so1363916vkb.8
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2hn9r7bUHQ5/qOvCxhqCGVg5WiOwDkVWGWEKMyNnY0=;
        b=m8E9zVAi8kq5j5HCZRX3DgXynR+9bcKt9YaJm1xEdTNq2Y1p8cEq3kBZmwZCdZM2At
         jONoxjHFaitcyiSmwSd4SSKleFlrg8NL9yt2hY5YqAWqaV6HKWSXcjb2xwowSiI3sWZ1
         A/fRc1AD6HS3VZRr7caYl6BVV4868ggTY7aC01veJb8EYlhxFEuvaEWHGCxrI1918xDq
         np6D2i0VrSdKmki5ewAoMrpU3+a7XzItHHMMTfEf0q+tjpRxuV+x2voY+lHwuS81xZW3
         59+CU6U5v3PWVkX6tpXOOhB/tLqLlaLFXyWrwmM2RV1o96qZFks+vBKxYExTLUi3Mcfe
         fFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2hn9r7bUHQ5/qOvCxhqCGVg5WiOwDkVWGWEKMyNnY0=;
        b=IzhfkGDbfnY5ror8YAPJiUXDTTN5NUYpKErYEGIBKjr6e7AInN7ngXIfX/GHhUH9/J
         Tiy/VJY2X6N8nmgsiPOUxJ2Be3Dputb3COTgsAI1SV0QU8dUDgXHZlu3WSh19TWsW7go
         TCvZqK53yQiLjnrw7ldkDNQUq4qk6K+j5PEgtZ4ARz81RppILCwxx77oLd3v5MteVzG4
         ftTA4o7SyWeuWp0caAzu5SKWTzP5vfG4y/OshTP7jQO+mhZ/o6WP0fqDragcmvXYsqkj
         mRRtyfaPH/aafcwTzGLSx8N6vcIQ1hH1ymVaKJZNc95BLmIi87XWVpKCets9cpVxdMHh
         6MLg==
X-Gm-Message-State: AOAM532144GT0WXIz5zlFDTXQ6TIaKgTROZ7ZjxEu7r6SWV8AwtUKvHJ
        6VptVhfWJMRld9a41T9VGtFqvzFJwY0yuA==
X-Google-Smtp-Source: ABdhPJzs93xgKwq1fx8WVLJft4Of8S2aA0kDDttt0FV8nz4DvX5YBSPr6u1um5x9YHmBRW3+L63v0Q==
X-Received: by 2002:a1f:ac0e:: with SMTP id v14mr4405295vke.21.1601282369243;
        Mon, 28 Sep 2020 01:39:29 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id 67sm1021707vks.44.2020.09.28.01.39.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 01:39:28 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id x203so258278vsc.11
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:39:28 -0700 (PDT)
X-Received: by 2002:a67:e83:: with SMTP id 125mr4637210vso.22.1601282367887;
 Mon, 28 Sep 2020 01:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com> <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Sep 2020 10:38:51 +0200
X-Gmail-Original-Message-ID: <CA+FuTSeOzCAVShBa1VTXtkqzc9YFdng_Dk1wVbjVeniTRREM=A@mail.gmail.com>
Message-ID: <CA+FuTSeOzCAVShBa1VTXtkqzc9YFdng_Dk1wVbjVeniTRREM=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
To:     xiangxia.m.yue@gmail.com
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 5:42 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Allow user configuring RXCSUM separately with ethtool -K,
> reusing the existing virtnet_set_guest_offloads helper
> that configures RXCSUM for XDP. This is conditional on
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21b71148c532..2e3af0b2c281 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
>                                 (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
>                                 (1ULL << VIRTIO_NET_F_GUEST_UFO))
>
> +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> +
>  struct virtnet_stat_desc {
>         char desc[ETH_GSTRING_LEN];
>         size_t offset;
> @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
>                                 netdev_features_t features)
>  {
>         struct virtnet_info *vi = netdev_priv(dev);
> -       u64 offloads;
> +       u64 offloads = vi->guest_offloads &
> +                      vi->guest_offloads_capable;
>         int err;
>
> -       if ((dev->features ^ features) & NETIF_F_LRO) {
> -               if (vi->xdp_queue_pairs)
> -                       return -EBUSY;
> +       /* Don't allow configuration while XDP is active. */
> +       if (vi->xdp_queue_pairs)
> +               return -EBUSY;
>
> +       if ((dev->features ^ features) & NETIF_F_LRO) {
>                 if (features & NETIF_F_LRO)
> -                       offloads = vi->guest_offloads_capable;
> +                       offloads |= GUEST_OFFLOAD_LRO_MASK;
>                 else
> -                       offloads = vi->guest_offloads_capable &
> -                                  ~GUEST_OFFLOAD_LRO_MASK;
> +                       offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> +       }
>
> -               err = virtnet_set_guest_offloads(vi, offloads);
> -               if (err)
> -                       return err;
> -               vi->guest_offloads = offloads;
> +       if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> +               if (features & NETIF_F_RXCSUM)
> +                       offloads |= GUEST_OFFLOAD_CSUM_MASK;
> +               else
> +                       offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
>         }

LRO requires receive checksum offload: packets must have their
checksum verified prior to coalescing.

The two features can thus not be configured fully independently.
