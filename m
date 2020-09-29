Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FDD27BE09
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgI2HcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgI2HcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:32:02 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31BBC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:32:01 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id g16so3110235uan.5
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqGHxvLut0c3Qv4bId0WIqz7ueuiNhUcIgNgX6FtrLc=;
        b=Rx5Q8lrOPfcBq82BZDnLwdmzhc8lnrn8nvRZEQzUGR2Efsjtjfxh8S8+Bve6xwf5dn
         d6qnVhYnQKRGOOehc03UMQ/Kno1uB0WQ+FjHOR/+ja+MpWz2dFnHT8Vf50GRtIcKHoPU
         gq5mZdn5apqOP77gj5Y9kk8qsp865sENGF/qarlR3E6gnMZeOb0H2h5+KNd4g51zb436
         EHfENUJJKrdSacii4Dd2mFTQhvJkSAoxmY0QdUdEvp+3fxUlX1WZ5J9qI5GO8Vb/XZSv
         cma8TDlxwm8JUzpv5JvJ5WiD7ng3pxyf2BaL4vWWdA91RLDL8CZ17/7tPofgK7DpxgHr
         r3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqGHxvLut0c3Qv4bId0WIqz7ueuiNhUcIgNgX6FtrLc=;
        b=rkaG7p/iHnnrokDPJZLwX+PX8OqE3mnzMO6kPAcwxJ5okXg3sTsUp3ufpB+9tW1dW6
         uIuAQgL+4AvfU2dtZDPSnmyk5GGHaSIQtXbVPm4KH1iWcG97RKVXy3EM8cXkWz25Qj6/
         QGTfvUy7iPTwt+Vdw8gA1oZyeubdiW9KCrG8I/eI8iAM3RYRLbhhieYhCsU2KnFGE4Cd
         6V8tTrw1MtHDKTD92R9O/TSS5XKCFyER20EtZWjhzLPaJg4DuAr4GEE1STjcujcdaLb4
         eQIPcG+anvB/e0mpXwsS/TqmyZley5laeXBXulHos4FKQzJCeb4QAbSdsrUsoy6/Fmle
         aPsQ==
X-Gm-Message-State: AOAM532m8c1zYFhe626U5nfDw74r11+lP1RB+Tj2tAS6+OkqclYLf392
        mkO1xD0QBRXJ9OMbqVx478aLjuEReuQUQQ==
X-Google-Smtp-Source: ABdhPJz+fgFhbfouYJ2t4oYdpH2XdqvqLyJWKnjBYuHgUfIcTRTOsJcYGanpfTERj4rwYGjmfHlj4g==
X-Received: by 2002:ab0:658c:: with SMTP id v12mr3049467uam.39.1601364720620;
        Tue, 29 Sep 2020 00:32:00 -0700 (PDT)
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com. [209.85.221.171])
        by smtp.gmail.com with ESMTPSA id q23sm1426947vkq.18.2020.09.29.00.31.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 00:31:59 -0700 (PDT)
Received: by mail-vk1-f171.google.com with SMTP id n7so2188565vkq.5
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:31:59 -0700 (PDT)
X-Received: by 2002:a1f:1f0d:: with SMTP id f13mr1757897vkf.1.1601364719268;
 Tue, 29 Sep 2020 00:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 29 Sep 2020 09:31:23 +0200
X-Gmail-Original-Message-ID: <CA+FuTSebRQ=2VfT0KnM6ChjMg0j3NWJDPwn9S=aQk8tbNrUt6w@mail.gmail.com>
Message-ID: <CA+FuTSebRQ=2VfT0KnM6ChjMg0j3NWJDPwn9S=aQk8tbNrUt6w@mail.gmail.com>
Subject: Re: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 4:00 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Open vSwitch and Linux bridge will disable LRO of the interface
> when this interface added to them. Now when disable the LRO, the
> virtio-net csum is disable too. That drops the forwarding performance.

I had focused on the code previously.

The s/w checksum verification cost is significant in a VM with traffic
to local destinations. A bridge does not verify transport layer
checksums OTOH?

> Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v2:
> * change the fix-tag
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
