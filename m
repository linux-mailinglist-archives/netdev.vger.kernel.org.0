Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2827E630
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgI3KFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3KFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:05:52 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA3CC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:05:52 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id q26so325120uaa.12
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sw8MWy65K0URDWaVY+ZCIih81TlOoNQvNGMszTNW1YA=;
        b=IqLZYi0/AWq+R/9zodfquqj+KRUjW5h5YHkOyw8Vbwg0hNPltUrL8Gb/TdSIKNmbdu
         FfpRSdyjbcQSzmq2tEyhoZBkgXqy95s5avi9YHdbx2a8E/pjOwzefzCqWFM/JK9wcZ9Z
         U9S+AKxVfXPUYaPkBV3AtI9Yg3e40Bw8Y2khnVsqy/VBZK4bcX6FdfHUi36lmvojPKUI
         dvbvNz4aycRHCSSpDitxfEMN0VsTeD7XUylkYhPhdGP6cOL9SIayl3Zn4TU9FnuflWl/
         yFyfhef9JGUsGhLfnO8ssWMxT0wrk03foCNN7TSDn77daKMVXLXPWOENHEbVwTvjZsAN
         uBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sw8MWy65K0URDWaVY+ZCIih81TlOoNQvNGMszTNW1YA=;
        b=tDHJ8D6o2KFTFcKwCPGXlgxZiSJsoTkmW1AGNHsoq05Iy/I3eX+IgpmpjPrTNq3gGJ
         83lcxoXW6W2YDjpN/vs6IkG3wW7UDhPKJC36yx+rPs+ZKtCX3uqaWjGx6PoMQr4yMme6
         1GNhfb5UWjo4gc0k8+MZQpsA701ZcJWAfXIjuZIQJYI1d83/zjRpC9wtZpmEzwY6bKLq
         tW0CNFDypvpnS41wWI6aiQN39zrDUhNb99b6y85M7343nSl4HonyUqGf2CiTrlU/ZWDt
         0vRUDNgER+beLZKGtbmrDO5CcBCc344W2ne3t19qqYMjjH6naFqINvgPlrby2PbeQSfA
         tTGw==
X-Gm-Message-State: AOAM532d86ippWOmVRT1y2UcHdbFnrUyjVxqRBJq/NaNWQUzVuJzUjSc
        Z0K4P6vB3hh/F57H9FAdfuMfH5QP0LpMMw==
X-Google-Smtp-Source: ABdhPJxwYUq1Amj9v8LVqKAQLOObAxBg3AjvEJVSZSo99PC8dMMoeynyjnFQmn1ih/4rk2QNefyqGw==
X-Received: by 2002:ab0:b18:: with SMTP id b24mr872142uak.75.1601460350711;
        Wed, 30 Sep 2020 03:05:50 -0700 (PDT)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com. [209.85.221.178])
        by smtp.gmail.com with ESMTPSA id j21sm145304vkn.26.2020.09.30.03.05.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 03:05:49 -0700 (PDT)
Received: by mail-vk1-f178.google.com with SMTP id d2so276826vkd.13
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 03:05:49 -0700 (PDT)
X-Received: by 2002:a1f:1f15:: with SMTP id f21mr751691vkf.12.1601460348742;
 Wed, 30 Sep 2020 03:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 30 Sep 2020 12:05:12 +0200
X-Gmail-Original-Message-ID: <CA+FuTSed1GsGp8a=GnHqV-HUcsOSZ0tb0NCe8360S8Md3MbS3g@mail.gmail.com>
Message-ID: <CA+FuTSed1GsGp8a=GnHqV-HUcsOSZ0tb0NCe8360S8Md3MbS3g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] virtio-net: ethtool configurable RXCSUM
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 4:05 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Allow user configuring RXCSUM separately with ethtool -K,
> reusing the existing virtnet_set_guest_offloads helper
> that configures RXCSUM for XDP. This is conditional on
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>
> If Rx checksum is disabled, LRO should also be disabled.
>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The first patch was merged into net.

Please wait until that is merged into net-next, as this depends on the
other patch.

> ---
> v2:
> * LRO depends the rx csum
> * remove the unnecessary check
> ---
>  drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21b71148c532..5407a0106771 100644
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
> @@ -2522,29 +2524,49 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
>         return 0;
>  }
>
> +static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> +                                             netdev_features_t features)
> +{
> +       /* If Rx checksum is disabled, LRO should also be disabled.
> +        * That is life. :)

Please remove this second line.

> +        */
> +       if (!(features & NETIF_F_RXCSUM))
> +               features &= ~NETIF_F_LRO;
> +
> +       return features;
> +}
> +
>  static int virtnet_set_features(struct net_device *dev,
>                                 netdev_features_t features)
>  {
>         struct virtnet_info *vi = netdev_priv(dev);
> -       u64 offloads;
> +       u64 offloads = vi->guest_offloads &
> +                      vi->guest_offloads_capable;

When can vi->guest_offloads have bits set outside the mask of
vi->guest_offloads_capable?
