Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7436C27BCDE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgI2GNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgI2GNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:13:22 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3EBC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:13:22 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dd13so565858ejb.5
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZQeJtUz9oxtcF3AII4Hqcc/QpKUTP2g6qGeW5Urmq0I=;
        b=nBZQYxXCJ5aazG+q/85PjLWtHRPzEk7XO1uDWS68z5y9f48xkhHnG9VEKt6Yg5IvXy
         e7Go8s82VzvoZt4zuowmTfu8o47yIMkT1i9Ph7sSadp1jDqlf/lj0+3H0yOTzDeqytBE
         YNkTL8Uy82uHIYH3qEmXCAWGe/rVtlc5e3yhMo8lr66QQg11mU2qRqVbY9D5lijIWT4f
         n8y2fv5TZsZviAowujqa/rNvTlAHPKDfAdoaHnscjZM/nbEKWlH6DeTGG8+0pM7ODCYm
         9BK7ShD2EBU4qFYfmMcnBh2ESKtmi1SiYdsCCPQomF7smkA/8l5nv0/pbHXxGQc0DlGW
         /+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZQeJtUz9oxtcF3AII4Hqcc/QpKUTP2g6qGeW5Urmq0I=;
        b=KFTenDy8JeAaKrdKNFAeqi9B5WWJaNsJH2IFMldnOrWm5E+ohYXrqGHe2d55NJ2vQA
         xqEmrE1PdCkheyD0oyFvh2AUCycOiQ3vUIoeE5QaoEj10in0nnqcESiqMsLPaUh4dxfh
         FqNr6q3uHcNMeOZIxde0QIJzhw36DA7x24N66mFIxtmg+BgfKz7weFxwMY/ZHnRV+w5V
         8C5Vfxuz+ryt9UXqiZXqLDOVSHZtJsrLJNu4TT+T0BAcRs9FW/XZjKaZ32uCJ8qezDSm
         VDSx2DcmsQc1z7IzK/62/Knz9N9ppvcG2jefUBAfHgBceJQhwX4Xdhb2+W7Rw+0+1NXM
         JRRg==
X-Gm-Message-State: AOAM532cIiG+Jvdwd3+/vyGbzV/QuK5O8brW4vhz4wIMki0BsEUKyEEP
        +hlIBJraXf+4YUBUctr1YPGfRebTIzqbT76AaQw=
X-Google-Smtp-Source: ABdhPJyPjo91Rzi99gEGORlWXAADe8p7c7AQJz08VR9iIZZXHtPM3T/PvOEnyBaR0PzodljuIbaBoPlzEj67XoTNthA=
X-Received: by 2002:a17:906:1690:: with SMTP id s16mr2271575ejd.122.1601360000885;
 Mon, 28 Sep 2020 23:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com> <20200928152142-mutt-send-email-mst@kernel.org>
 <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com> <20200929015427-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200929015427-mutt-send-email-mst@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 14:10:56 +0800
Message-ID: <CAMDZJNX94out3B_puYy+zbdotDwU=qZKG2=sMfyoj9o5nnewmA@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 1:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Sep 29, 2020 at 09:45:24AM +0800, Tonghao Zhang wrote:
> > On Tue, Sep 29, 2020 at 3:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > Allow user configuring RXCSUM separately with ethtool -K,
> > > > reusing the existing virtnet_set_guest_offloads helper
> > > > that configures RXCSUM for XDP. This is conditional on
> > > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > >
> > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> > > >  1 file changed, 28 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 21b71148c532..2e3af0b2c281 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > > >                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > >                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > >
> > > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > > +
> > > >  struct virtnet_stat_desc {
> > > >       char desc[ETH_GSTRING_LEN];
> > > >       size_t offset;
> > > > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> > > >                               netdev_features_t features)
> > > >  {
> > > >       struct virtnet_info *vi = netdev_priv(dev);
> > > > -     u64 offloads;
> > > > +     u64 offloads = vi->guest_offloads &
> > > > +                    vi->guest_offloads_capable;
> > > >       int err;
> > > >
> > > > -     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > -             if (vi->xdp_queue_pairs)
> > > > -                     return -EBUSY;
> > > > +     /* Don't allow configuration while XDP is active. */
> > > > +     if (vi->xdp_queue_pairs)
> > > > +             return -EBUSY;
> > > >
> > > > +     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > >               if (features & NETIF_F_LRO)
> > > > -                     offloads = vi->guest_offloads_capable;
> > > > +                     offloads |= GUEST_OFFLOAD_LRO_MASK;
> > > >               else
> > > > -                     offloads = vi->guest_offloads_capable &
> > > > -                                ~GUEST_OFFLOAD_LRO_MASK;
> > > > +                     offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > > > +     }
> > > >
> > > > -             err = virtnet_set_guest_offloads(vi, offloads);
> > > > -             if (err)
> > > > -                     return err;
> > > > -             vi->guest_offloads = offloads;
> > > > +     if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > > > +             if (features & NETIF_F_RXCSUM)
> > > > +                     offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > > > +             else
> > > > +                     offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> > > >       }
> > > >
> > > > +     if (offloads == (vi->guest_offloads &
> > > > +                      vi->guest_offloads_capable))
> > > > +             return 0;
> > >
> > > Hmm, what exactly does this do?
> > If the features(lro, rxcsum) we supported, are not changed, it is not
> > necessary to invoke virtnet_set_guest_offloads.
>
> okay, could you describe the cases where this triggers in a bit more
> detail pls?
Hi
As I known,  when we run che commands show as below:
ethtool -K eth1 sg off
ethtool -K eth1 tso off

In that case, we will not invoke virtnet_set_guest_offloads.

> > > > +
> > > > +     err = virtnet_set_guest_offloads(vi, offloads);
> > > > +     if (err)
> > > > +             return err;
> > > > +
> > > > +     vi->guest_offloads = offloads;
> > > >       return 0;
> > > >  }
> > > >
> > > > @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > >           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > >               dev->features |= NETIF_F_LRO;
> > > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > > > +             dev->hw_features |= NETIF_F_RXCSUM;
> > > >               dev->hw_features |= NETIF_F_LRO;
> > > > +     }
> > > >
> > > >       dev->vlan_features = dev->features;
> > > >
> > > > --
> > > > 2.23.0
> > >
> >
> >
> > --
> > Best regards, Tonghao
>


-- 
Best regards, Tonghao
