Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02C927AAA2
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgI1JXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgI1JXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:23:32 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0FEC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:23:31 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id j2so501964eds.9
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=49UgUsuSZpbxMCQ1i25UEUHUhYi5jAwhqJAxsLMJJbA=;
        b=JE0/6giF4HuaBufvw1jiR/Z4QVqaUyASMznriiZ4ifjR9k4FiKXxGOW8ql3eVeumaE
         NcEJV866hSqG5MwWxiYng0XMqXN8vPt44auPNIJ6m5fipoh8bsAXNwOoSOoH1YR6gIqz
         CRHtByztVrfPIy5QygCOFLFZdIW3sttFKeuNyAWxAM+ZMCEuF28Z6HlqwfDb8HklLj+K
         t5zMvq+rBd6QD58bqv4l/CH1tFf6xvxuO3mlYvhfdjHBEWX/JGbcTapp3bAYLE6TKBAA
         bx1iw60ffR19Fg7kRfxNU1izEP018UGdKDWxTRuIu0vhNitR09CRS1+7HTC1k/6jGrl4
         SUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49UgUsuSZpbxMCQ1i25UEUHUhYi5jAwhqJAxsLMJJbA=;
        b=MDCXn0Ftix3BgQNPeK5duto6zpjBQff1BgmcF9/EHW9k+jVegY7AQHzKk9jm1i7xVe
         sD4J4++6VN6gIW3Wv8hWfRl2VJWN2cooENW3cnkkosG2+/KZiT16WntL/ysO3xA1Ohy7
         BxmtWBz/IeXscyAck9ThS+31MajFnsYdaSlxBEs2KGNVh6eOksVqPG+CskdSv7BVcT31
         T91YUUgG+VKBh+HhSFRrdoN3Iyt/UoWr64IwXOTjKIIY9QQ5MEXmrmHyvayEq+cHTixb
         cW1akBtobifMnAaow2m1tgvO9lY6R7tzHP8BaVbAsaMiT4LQqoeVNShX6PNX4yr1XaOR
         sLqg==
X-Gm-Message-State: AOAM533nGzO/prTZC3gCZWxcTSlUXhUeZsiGIDJjQuGcgQ+88xBw/mxN
        JLh17Zx3z2dLm25qbkyQAaf5W/XoFpwThD9+K9w=
X-Google-Smtp-Source: ABdhPJz+24UgqtQiE8ggUQSe1O6SQ1aOICXYByjZaTiGIUF4g0xhjoIeDoIOqrSJY6Ir1FZm9dcTspBNQgJUARtI9g8=
X-Received: by 2002:aa7:de82:: with SMTP id j2mr691360edv.3.1601285010642;
 Mon, 28 Sep 2020 02:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com> <CA+FuTSe08hRwQ_c1Uk7BzHWL1HwTGWQ7kKG1tfBUifOtayVMGw@mail.gmail.com>
In-Reply-To: <CA+FuTSe08hRwQ_c1Uk7BzHWL1HwTGWQ7kKG1tfBUifOtayVMGw@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 28 Sep 2020 17:21:18 +0800
Message-ID: <CAMDZJNX2yUv9rL4v++SnL34bcKRiX2zJ2Qnjni4U_SDtjeOLWQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio-net: don't disable guest csum when disable LRO
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 4:35 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Sep 28, 2020 at 5:41 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Open vSwitch and Linux bridge will disable LRO of the interface
> > when this interface added to them. Now when disable the LRO, the
> > virtio-net csum is disable too. That drops the forwarding performance.
> >
> > Fixes: e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")
>
> Patch looks fine to me, but wrong commit here?
Yes, I will change the tag.
> That commit disables csum on purpose when enabling xdp with ndp_bpf.
>
> This patch refines disabling LRO with ndo_set_features.
>
> The relevant commit is a02e8964eaf9 ("virtio-net: ethtool configurable LRO").
>
> If this is a fix, it should target [PATCH net] separately from the
> second patch in the patchset, which is a new feature and targets
> [PATCH net-next]. They can arguably target net-next together, but then
> it should not have a fixes tag.
Thanks, I will send first patch for net, and next one to net-next.
>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  drivers/net/virtio_net.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7145c83c6c8c..21b71148c532 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
> >         VIRTIO_NET_F_GUEST_CSUM
> >  };
> >
> > +#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > +                               (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> > +                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > +                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > +
> >  struct virtnet_stat_desc {
> >         char desc[ETH_GSTRING_LEN];
> >         size_t offset;
> > @@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
> >                 if (features & NETIF_F_LRO)
> >                         offloads = vi->guest_offloads_capable;
> >                 else
> > -                       offloads = 0;
> > +                       offloads = vi->guest_offloads_capable &
> > +                                  ~GUEST_OFFLOAD_LRO_MASK;
> >
> >                 err = virtnet_set_guest_offloads(vi, offloads);
> >                 if (err)
> > --
> > 2.23.0
> >



-- 
Best regards, Tonghao
