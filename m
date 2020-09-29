Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07127BA74
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgI2Br6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2Br6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:47:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDC3C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:47:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i26so12551288ejb.12
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 18:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MkBPqBhHfLDw/+PRNqDaEfF8oeqozUeo1kOlUOG88QU=;
        b=PSDamLIB9h0D9VqOfh0Em81onTFLfaclu1WQ9M+xWbr2+B4Y6fp7tFSyR1cqfaMthp
         ID2KARr9QaufbqRqcjSP4CWunJNb2hpnyS81ugqOu+qhG3c/m4JVjvA7uwiiNWlXOosR
         CQEgqY1nzWU1IuSiHN4XBf2pZFxUczj6upyR/JQI/5LTB8+yFaeUdGeeth6fSCK6SYBs
         2kOVpRobMBYeGbO3jiHzjd4pcSgpbv13CG+QzsFTbvpkyFtt7PCGFGyMqcwb0F58+cco
         3r4YrmKOyGDS0PLqslvwbRVnhI/cME9ZWxrzDaZhvcIC010R4s1YCUZowQbnpFdH+571
         NMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MkBPqBhHfLDw/+PRNqDaEfF8oeqozUeo1kOlUOG88QU=;
        b=YYuZDHdZd32RIqA3nZxkCHnKq5/3nhF9P6f7FefSv4PfIWNdjtGxghfAPAQMtnTmEP
         df130Iso0a3cXeYVFCH36K5MSkCoadvtE9ugMFV2kHpigxrrOL6DCFldwQU6lgPCx8zF
         NFhimL8fbeGzSgWwhlBky2c6CxCuHAtJsLBuKfcd6q6o+s8R2yJC7HY39ujo0nxCA2XW
         bra34U8rbr99XPnwVjttN9XxNf5wpZcA0vEPo3+nZubQx+zX4bC7fp+GRUXcLqQWWJeY
         bzjUHx+omxlNwKMi0W+oGlLOrLyLn7hlbl5bULWzL9E+aiBlvMXCgQB0gaWOidNILZKN
         efxg==
X-Gm-Message-State: AOAM533cIhaml7pKnSa27HIiMpuHQ4kTjBYuqGQis8LGJ+3t2TAMzVOL
        kOsEwMv9BMaReLTK4bVoZJARtFHF+/Mp3G4gDjs=
X-Google-Smtp-Source: ABdhPJwLhDDOLskOrdw3djY+kSSWJ0zk8ymGNb5sA+GernTPHpXjdOQ3WxytSLv0e44NxQdtmdv857KoIaazyTe5EDE=
X-Received: by 2002:a17:907:374:: with SMTP id rs20mr1580498ejb.135.1601344068474;
 Mon, 28 Sep 2020 18:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com> <20200928152142-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200928152142-mutt-send-email-mst@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 09:45:24 +0800
Message-ID: <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 3:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Allow user configuring RXCSUM separately with ethtool -K,
> > reusing the existing virtnet_set_guest_offloads helper
> > that configures RXCSUM for XDP. This is conditional on
> > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> >
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> >  1 file changed, 28 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 21b71148c532..2e3af0b2c281 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> >                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> >                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> >
> > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > +
> >  struct virtnet_stat_desc {
> >       char desc[ETH_GSTRING_LEN];
> >       size_t offset;
> > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> >                               netdev_features_t features)
> >  {
> >       struct virtnet_info *vi = netdev_priv(dev);
> > -     u64 offloads;
> > +     u64 offloads = vi->guest_offloads &
> > +                    vi->guest_offloads_capable;
> >       int err;
> >
> > -     if ((dev->features ^ features) & NETIF_F_LRO) {
> > -             if (vi->xdp_queue_pairs)
> > -                     return -EBUSY;
> > +     /* Don't allow configuration while XDP is active. */
> > +     if (vi->xdp_queue_pairs)
> > +             return -EBUSY;
> >
> > +     if ((dev->features ^ features) & NETIF_F_LRO) {
> >               if (features & NETIF_F_LRO)
> > -                     offloads = vi->guest_offloads_capable;
> > +                     offloads |= GUEST_OFFLOAD_LRO_MASK;
> >               else
> > -                     offloads = vi->guest_offloads_capable &
> > -                                ~GUEST_OFFLOAD_LRO_MASK;
> > +                     offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > +     }
> >
> > -             err = virtnet_set_guest_offloads(vi, offloads);
> > -             if (err)
> > -                     return err;
> > -             vi->guest_offloads = offloads;
> > +     if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > +             if (features & NETIF_F_RXCSUM)
> > +                     offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > +             else
> > +                     offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> >       }
> >
> > +     if (offloads == (vi->guest_offloads &
> > +                      vi->guest_offloads_capable))
> > +             return 0;
>
> Hmm, what exactly does this do?
If the features(lro, rxcsum) we supported, are not changed, it is not
necessary to invoke virtnet_set_guest_offloads.
> > +
> > +     err = virtnet_set_guest_offloads(vi, offloads);
> > +     if (err)
> > +             return err;
> > +
> > +     vi->guest_offloads = offloads;
> >       return 0;
> >  }
> >
> > @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> >           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> >               dev->features |= NETIF_F_LRO;
> > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > +             dev->hw_features |= NETIF_F_RXCSUM;
> >               dev->hw_features |= NETIF_F_LRO;
> > +     }
> >
> >       dev->vlan_features = dev->features;
> >
> > --
> > 2.23.0
>


-- 
Best regards, Tonghao
