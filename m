Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD9A27A99D
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgI1IfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgI1IfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 04:35:05 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA24C0613CE
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:35:05 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id p24so257937vsf.8
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K0aYGsIeM1DRZtz0d2V1pRZwao+9KEihDTgnA9Qcu1w=;
        b=n1n7gT5E1CqfMJCTWqyJVXIAuoYqjmQo/vij57GCYi7lxCWWEqr437bBhLwOw8GgFT
         xNiPYf4s5BXKbEE6h9w2QVcygi0NRQF5mLxSwfC9zW+vrddS4etk5tCTKU236vKE8ef6
         MPnZ6k2Elxy0Q/B5TzxWOCi7fxOHyH4frFv3AYgSRhwwELhx/D6afd+ENgna+BWkUo+S
         asbxeQLV/LOaHjiEpuQ6j7yw4gU3IXhidF06nolvbCUUTlV7yuLMzZxPcyp1VrtxNuTs
         QLOKOuyFiLmdMbIVWkd4R0XNPD9aWxODih4Q3V/zQfZbzOBKExbfHruFD66Mw3HYFoJ8
         lA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K0aYGsIeM1DRZtz0d2V1pRZwao+9KEihDTgnA9Qcu1w=;
        b=to0DTFZEq23dpwvtgNkaqyfj6gmirXc5iJETijUmmNu7xFN25Wo8MqcqPxgUm9ZeZc
         lzKxwDA5lEfLYeQHiAh31fnQShdlZuXXLlRS5Zo9PDbSfYI6tXqtfmina9t4RZNuFLU0
         QnlN4ba9OAcH4L1M9HtjmKXNA6W6jzDq1r3xL3iogdJAoUVpmyFH8lYBNbGbOy2JRZvr
         +A9pO2VxwGX+mZbHlVn2D2y6O2jJ9aMXZEj24Ext77OqjKfpU6VEfqYaji4HS87If7eS
         +1pDHMuvbViGFetXvLnltUeJLsvuxXbBwjGk+1hTNzCvoIFngwu+PfuwsmexsAW8sYzu
         uxQw==
X-Gm-Message-State: AOAM530PFYU+zVR5f59STfiw+BgYyMp4c0UVD9zqGmeabKkeTe0vWoBd
        bC3W0tLfM2YwMXBTXkS0alqtYIcy53Oqxg==
X-Google-Smtp-Source: ABdhPJydfhZhKU+RiY9+RU5zekHLPGuVuVuyKyo8wwIo9jcfdaufBllqB9J7aoVVfnGV5JIZ33mBvw==
X-Received: by 2002:a67:e248:: with SMTP id w8mr4956402vse.39.1601282103997;
        Mon, 28 Sep 2020 01:35:03 -0700 (PDT)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id s8sm1028023vke.48.2020.09.28.01.35.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 01:35:03 -0700 (PDT)
Received: by mail-vs1-f47.google.com with SMTP id p24so257890vsf.8
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 01:35:02 -0700 (PDT)
X-Received: by 2002:a67:d84:: with SMTP id 126mr223275vsn.51.1601282102334;
 Mon, 28 Sep 2020 01:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Sep 2020 10:34:25 +0200
X-Gmail-Original-Message-ID: <CA+FuTSe08hRwQ_c1Uk7BzHWL1HwTGWQ7kKG1tfBUifOtayVMGw@mail.gmail.com>
Message-ID: <CA+FuTSe08hRwQ_c1Uk7BzHWL1HwTGWQ7kKG1tfBUifOtayVMGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio-net: don't disable guest csum when disable LRO
To:     xiangxia.m.yue@gmail.com
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 5:41 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Open vSwitch and Linux bridge will disable LRO of the interface
> when this interface added to them. Now when disable the LRO, the
> virtio-net csum is disable too. That drops the forwarding performance.
>
> Fixes: e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")

Patch looks fine to me, but wrong commit here?

That commit disables csum on purpose when enabling xdp with ndp_bpf.

This patch refines disabling LRO with ndo_set_features.

The relevant commit is a02e8964eaf9 ("virtio-net: ethtool configurable LRO").

If this is a fix, it should target [PATCH net] separately from the
second patch in the patchset, which is a new feature and targets
[PATCH net-next]. They can arguably target net-next together, but then
it should not have a fixes tag.

> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7145c83c6c8c..21b71148c532 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
>         VIRTIO_NET_F_GUEST_CSUM
>  };
>
> +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> +                               (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> +                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> +                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> +
>  struct virtnet_stat_desc {
>         char desc[ETH_GSTRING_LEN];
>         size_t offset;
> @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
>                 if (features & NETIF_F_LRO)
>                         offloads = vi->guest_offloads_capable;
>                 else
> -                       offloads = 0;
> +                       offloads = vi->guest_offloads_capable &
> +                                  ~GUEST_OFFLOAD_LRO_MASK;
>
>                 err = virtnet_set_guest_offloads(vi, offloads);
>                 if (err)
> --
> 2.23.0
>
