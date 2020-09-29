Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2927BDF1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgI2HZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726431AbgI2HZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:25:18 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601364315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YZ8E1/B0IgHE6g3riQOXVTHOwxNzr+Lp4c04gi89x5U=;
        b=EMYygneE+S1ypolXl/2IpdbQVJzUC1BXOOlPOmq3syvajoKnHmQZCK7x6cvKLPTfSgFZ18
        0ICzyXxc2pXtC4b4TLDkPPfD/i6PxH+TDvcSUugChYV7ZDF3fkHCL1kuVoURPxCs2lQmfC
        bfGI1bBk/aAvM5NEEoYd+PNmUnDQNEA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-zd3L3cCYOd-rUI8wu0_Rxw-1; Tue, 29 Sep 2020 03:25:13 -0400
X-MC-Unique: zd3L3cCYOd-rUI8wu0_Rxw-1
Received: by mail-wm1-f70.google.com with SMTP id l26so1355353wmg.7
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YZ8E1/B0IgHE6g3riQOXVTHOwxNzr+Lp4c04gi89x5U=;
        b=CTeo9lw8JhXsPcZ68ziuT5/hCn57fBSX7/szeEXmPnLDSYIZG7gdDoUY6vidKMEfqz
         gG9QJ+TpKsMUPwi3TAPjHFXFX2hhI6L7Oh+prjXK2g3Plc08SJD3Cpdjv5v6qCs8Tuj6
         yHnk6elYREP7SA43fEMq31uNPUH7JgyfDCT1/3GEZ+f/UPZxoSVFXNIIsYNbNvDAWrwx
         dY1pplo342yscTi944Ydj+LkD+a19UbOrn1EOnJKDaI504oEk+DIeDYQ7bYgxf4a8hkT
         TA79w3d7KBVWVpOb5zUnRYfw/d2INPkl9E1lmiQ7yHpS7eBqPJSIFrRUmdz1juv0Arh1
         2Nqw==
X-Gm-Message-State: AOAM530R00114S/Y9JTemBDQaOBlMJtYSFp4vjebHPchO5V2E5nSTqU4
        BEGZ058apqfWLFcG6EuGhevUrDv+S4tnl7ZBZzL8G0pVVHG3SOnZ6vFpWUudpLPiIc7VYkx9dRt
        iIdsOHD4jtfDTaP6f
X-Received: by 2002:a5d:4811:: with SMTP id l17mr2644469wrq.252.1601364312098;
        Tue, 29 Sep 2020 00:25:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEpK/MPBU1pyxP4vRA1kwGMHn0cJZ1Ea78w0zQPAat249q7ZwGjLz3eOdqfBs022VCrrzdPg==
X-Received: by 2002:a5d:4811:: with SMTP id l17mr2644445wrq.252.1601364311876;
        Tue, 29 Sep 2020 00:25:11 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id c4sm4652560wme.27.2020.09.29.00.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 00:25:11 -0700 (PDT)
Date:   Tue, 29 Sep 2020 03:25:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
Message-ID: <20200929032314-mutt-send-email-mst@kernel.org>
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
 <20200928152142-mutt-send-email-mst@kernel.org>
 <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com>
 <20200929015427-mutt-send-email-mst@kernel.org>
 <CAMDZJNX94out3B_puYy+zbdotDwU=qZKG2=sMfyoj9o5nnewmA@mail.gmail.com>
 <20200929022138-mutt-send-email-mst@kernel.org>
 <CAMDZJNVzKc-Wb13Z5ocz_4DHqP_ZMzM1sO1GWmmKhNUKMuP9PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNVzKc-Wb13Z5ocz_4DHqP_ZMzM1sO1GWmmKhNUKMuP9PQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:17:50PM +0800, Tonghao Zhang wrote:
> On Tue, Sep 29, 2020 at 2:22 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 02:10:56PM +0800, Tonghao Zhang wrote:
> > > On Tue, Sep 29, 2020 at 1:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Sep 29, 2020 at 09:45:24AM +0800, Tonghao Zhang wrote:
> > > > > On Tue, Sep 29, 2020 at 3:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > >
> > > > > > > Allow user configuring RXCSUM separately with ethtool -K,
> > > > > > > reusing the existing virtnet_set_guest_offloads helper
> > > > > > > that configures RXCSUM for XDP. This is conditional on
> > > > > > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > > > > >
> > > > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > ---
> > > > > > >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> > > > > > >  1 file changed, 28 insertions(+), 12 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > > index 21b71148c532..2e3af0b2c281 100644
> > > > > > > --- a/drivers/net/virtio_net.c
> > > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > > > > > >                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > > > >                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > > > >
> > > > > > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > > > > > +
> > > > > > >  struct virtnet_stat_desc {
> > > > > > >       char desc[ETH_GSTRING_LEN];
> > > > > > >       size_t offset;
> > > > > > > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> > > > > > >                               netdev_features_t features)
> > > > > > >  {
> > > > > > >       struct virtnet_info *vi = netdev_priv(dev);
> > > > > > > -     u64 offloads;
> > > > > > > +     u64 offloads = vi->guest_offloads &
> > > > > > > +                    vi->guest_offloads_capable;
> > > > > > >       int err;
> > > > > > >
> > > > > > > -     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > > > > -             if (vi->xdp_queue_pairs)
> > > > > > > -                     return -EBUSY;
> > > > > > > +     /* Don't allow configuration while XDP is active. */
> > > > > > > +     if (vi->xdp_queue_pairs)
> > > > > > > +             return -EBUSY;
> > > > > > >
> > > > > > > +     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > > > >               if (features & NETIF_F_LRO)
> > > > > > > -                     offloads = vi->guest_offloads_capable;
> > > > > > > +                     offloads |= GUEST_OFFLOAD_LRO_MASK;
> > > > > > >               else
> > > > > > > -                     offloads = vi->guest_offloads_capable &
> > > > > > > -                                ~GUEST_OFFLOAD_LRO_MASK;
> > > > > > > +                     offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > > > > > > +     }
> > > > > > >
> > > > > > > -             err = virtnet_set_guest_offloads(vi, offloads);
> > > > > > > -             if (err)
> > > > > > > -                     return err;
> > > > > > > -             vi->guest_offloads = offloads;
> > > > > > > +     if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > > > > > > +             if (features & NETIF_F_RXCSUM)
> > > > > > > +                     offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > > > > > > +             else
> > > > > > > +                     offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> > > > > > >       }
> > > > > > >
> > > > > > > +     if (offloads == (vi->guest_offloads &
> > > > > > > +                      vi->guest_offloads_capable))
> > > > > > > +             return 0;
> > > > > >
> > > > > > Hmm, what exactly does this do?
> > > > > If the features(lro, rxcsum) we supported, are not changed, it is not
> > > > > necessary to invoke virtnet_set_guest_offloads.
> > > >
> > > > okay, could you describe the cases where this triggers in a bit more
> > > > detail pls?
> > > Hi
> > > As I known,  when we run che commands show as below:
> > > ethtool -K eth1 sg off
> > > ethtool -K eth1 tso off
> > >
> > > In that case, we will not invoke virtnet_set_guest_offloads.
> >
> > How about initialization though? E.g. it looks like guest_offloads
> > is 0-initialized, won't this skip the first command to disable
> > offloads?
> I guest you mean that: if guest_offloads == 0, and run the command
> "ethtool -K eth1 sg off", that will disable offload ?
> In that patch
> u64 offloads = vi->guest_offloads & vi->guest_offloads_capable; // offload = 0
> .....
>  if (offloads == (vi->guest_offloads & vi->guest_offloads_capable)) //
> if offload not changed, offload == 0, and (vi->guest_offloads &
> vi->guest_offloads_capable) == 0.
>         return 0;
> 
> virtnet_set_guest_offloads // that will not be invoked, so will not
> disable offload


Sorry don't understand the question here.
At device init offloads are enabled, I am asking won't this skip
disabling them the first time this function is invoked.
Why are we bothering with this check? Is this called lots of
times where offloads are unchanged to make skipping the
command worthwhile?

> > > > > > > +
> > > > > > > +     err = virtnet_set_guest_offloads(vi, offloads);
> > > > > > > +     if (err)
> > > > > > > +             return err;
> > > > > > > +
> > > > > > > +     vi->guest_offloads = offloads;
> > > > > > >       return 0;
> > > > > > >  }
> > > > > > >
> > > > > > > @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > > > >           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > > > > >               dev->features |= NETIF_F_LRO;
> > > > > > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > > > > > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > > > > > > +             dev->hw_features |= NETIF_F_RXCSUM;
> > > > > > >               dev->hw_features |= NETIF_F_LRO;
> > > > > > > +     }
> > > > > > >
> > > > > > >       dev->vlan_features = dev->features;
> > > > > > >
> > > > > > > --
> > > > > > > 2.23.0
> > > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Best regards, Tonghao
> > > >
> > >
> > >
> > > --
> > > Best regards, Tonghao
> >
> 
> 
> -- 
> Best regards, Tonghao

