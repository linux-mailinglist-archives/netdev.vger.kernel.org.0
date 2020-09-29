Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5B127BC9A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgI2FzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI2FzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 01:55:24 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601358922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CU6DE2cx0I1FLYs8fHE6zj6vjwpo9LDCmZqFve4flUg=;
        b=EoKpJqC0nzClsUNxNS9oqV4foiJbYij+YK60wRR+YLTFvakKv/OzJ9aI9b6Yx5tivN0S39
        rl3uLCoUvHgk3P1SDvxlf11zF2cNEA6xXMcZbwYEiSdhzrLfs5hVk1ZhUg76hy/REIzNtY
        t7km5YjyydssV9Z2oc6ACcwwYzK0K7o=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-gDzWEegQPeSIjrPcb5tPrw-1; Tue, 29 Sep 2020 01:55:20 -0400
X-MC-Unique: gDzWEegQPeSIjrPcb5tPrw-1
Received: by mail-wr1-f71.google.com with SMTP id l9so1257977wrq.20
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 22:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CU6DE2cx0I1FLYs8fHE6zj6vjwpo9LDCmZqFve4flUg=;
        b=R13V+cwHWprfNog8sReNmMYy37O4SELcFlwfLxgrbVDcXoaKqRebADGYqc5/XXAiHj
         NVkcpOdEIRkdztz0ISWZJe/MQobXaqw0AW7mbBw8aqUAa4AD5RjZXm3uHafQQfboI+Oe
         1rudzhHIM0MXsGTDmgMvd4Ms+Fr3ruPpZg/BEMgV0kxzoL2mD0bm09U98LVbbGc5huTL
         CrWR7Ved+3i6YbKg8T3hWZFpg1ciE1tsKCjG7TJ7Q0xmFQOdmcVXDjVHKwhj6rF3aSuG
         iVUhE+gy1/VglCIc0IjQD8QHyIeFsvBtMVMoUf0FUd6p3YUJxfso5FvsM7w6jjfOBTO+
         k8Tg==
X-Gm-Message-State: AOAM530CutDKQbZuVZiox3d36AzFQf1f4GAS37kmCTKa2byX6z+gubOD
        6BFZsNNpMdKdEwwXopzhgVjoDeMcBjdXHB45YiXbuSp095ArS7l0GWDGsZAPjUK1uUPK81DZ/HA
        sp0f/7U8uo4/zDssA
X-Received: by 2002:a1c:b103:: with SMTP id a3mr2656568wmf.68.1601358918056;
        Mon, 28 Sep 2020 22:55:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxsOwwngwmhGeReV8HiZ7hkWkrIf0RVPILaTaEu1hmMo4H1fr7U3ZGwgZqxZtONPMxJ+qfaw==
X-Received: by 2002:a1c:b103:: with SMTP id a3mr2656544wmf.68.1601358917787;
        Mon, 28 Sep 2020 22:55:17 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id w14sm4153307wrk.95.2020.09.28.22.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 22:55:16 -0700 (PDT)
Date:   Tue, 29 Sep 2020 01:55:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
Message-ID: <20200929015427-mutt-send-email-mst@kernel.org>
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
 <20200928152142-mutt-send-email-mst@kernel.org>
 <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:45:24AM +0800, Tonghao Zhang wrote:
> On Tue, Sep 29, 2020 at 3:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Allow user configuring RXCSUM separately with ethtool -K,
> > > reusing the existing virtnet_set_guest_offloads helper
> > > that configures RXCSUM for XDP. This is conditional on
> > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > >
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> > >  1 file changed, 28 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 21b71148c532..2e3af0b2c281 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > >                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > >                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > >
> > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > +
> > >  struct virtnet_stat_desc {
> > >       char desc[ETH_GSTRING_LEN];
> > >       size_t offset;
> > > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> > >                               netdev_features_t features)
> > >  {
> > >       struct virtnet_info *vi = netdev_priv(dev);
> > > -     u64 offloads;
> > > +     u64 offloads = vi->guest_offloads &
> > > +                    vi->guest_offloads_capable;
> > >       int err;
> > >
> > > -     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > -             if (vi->xdp_queue_pairs)
> > > -                     return -EBUSY;
> > > +     /* Don't allow configuration while XDP is active. */
> > > +     if (vi->xdp_queue_pairs)
> > > +             return -EBUSY;
> > >
> > > +     if ((dev->features ^ features) & NETIF_F_LRO) {
> > >               if (features & NETIF_F_LRO)
> > > -                     offloads = vi->guest_offloads_capable;
> > > +                     offloads |= GUEST_OFFLOAD_LRO_MASK;
> > >               else
> > > -                     offloads = vi->guest_offloads_capable &
> > > -                                ~GUEST_OFFLOAD_LRO_MASK;
> > > +                     offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > > +     }
> > >
> > > -             err = virtnet_set_guest_offloads(vi, offloads);
> > > -             if (err)
> > > -                     return err;
> > > -             vi->guest_offloads = offloads;
> > > +     if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > > +             if (features & NETIF_F_RXCSUM)
> > > +                     offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > > +             else
> > > +                     offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> > >       }
> > >
> > > +     if (offloads == (vi->guest_offloads &
> > > +                      vi->guest_offloads_capable))
> > > +             return 0;
> >
> > Hmm, what exactly does this do?
> If the features(lro, rxcsum) we supported, are not changed, it is not
> necessary to invoke virtnet_set_guest_offloads.

okay, could you describe the cases where this triggers in a bit more
detail pls?

> > > +
> > > +     err = virtnet_set_guest_offloads(vi, offloads);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     vi->guest_offloads = offloads;
> > >       return 0;
> > >  }
> > >
> > > @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > >           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > >               dev->features |= NETIF_F_LRO;
> > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > > +             dev->hw_features |= NETIF_F_RXCSUM;
> > >               dev->hw_features |= NETIF_F_LRO;
> > > +     }
> > >
> > >       dev->vlan_features = dev->features;
> > >
> > > --
> > > 2.23.0
> >
> 
> 
> -- 
> Best regards, Tonghao

