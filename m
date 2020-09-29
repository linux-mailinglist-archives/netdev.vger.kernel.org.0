Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A00927BD0F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgI2GWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgI2GWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:22:47 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601360565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OZL2UTL2NRgnTLjhHE1qMWT9IHTxaDPA0n06CGHk4AQ=;
        b=bKHSR8N84hmxi6Gr1c6gt4kfBWxRmXfKre+CT2LQVzt0wGggsQ83CyQsQ6pudkJmp9H034
        D+fAqfk2qCF1MAlC3KAEqSLd4otCww9OvriLdc+M75LqlmofmNYSwkk8wrOlBDPHJgO2G+
        9fOXz3+yviGdJcA2jsyAqe3J9GFAP/A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-AbcW0XiCMCmgA0VGLBBuMA-1; Tue, 29 Sep 2020 02:22:40 -0400
X-MC-Unique: AbcW0XiCMCmgA0VGLBBuMA-1
Received: by mail-wr1-f69.google.com with SMTP id i10so1300703wrq.5
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 23:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OZL2UTL2NRgnTLjhHE1qMWT9IHTxaDPA0n06CGHk4AQ=;
        b=A/ygReujyiuXNsnEXGx6NzDdkqrjzan8fVedCAIV8kKaCwJT9aHqtwrdOtusGa0EHr
         yuqYbicJr/KRkwIwelE26xSWQCRlOAGh92+rCrz9+eb247OII6RwQZ0gcwJ830GFSm3X
         iNvVa2EgUtcYjiY4pV2ITr5KSMilxwyIvpBxr5E2IEYGQYWY3OarCYgWHKUZFmzDd4M7
         XkHArHmvaOgV3ObMxzOV+ObhVLp1pi8OOk36Z/pN3UtS/UtZfiLFa5Y4jenBgJva6uSY
         cCornAoWESVCsmCncjorVn6j/6wl47zALIf/tfEwZByA8qq7HsJ2CTd2Gsqp4dBanbbp
         Xhcg==
X-Gm-Message-State: AOAM532bXlcgo/e4mD+Q0FjloFM3za+paQuHI8gIl+Q+ZmlEqa2G/Gx9
        HTQPzFxFJeeiIu6w/uPe9JMU+QEwOYyxX7XoDCun2mSLRUzRx+yFrxOjmB57WZERt85vFYVpOeL
        Br8pevZFb5p1pc1Fb
X-Received: by 2002:a1c:9894:: with SMTP id a142mr2543029wme.167.1601360558609;
        Mon, 28 Sep 2020 23:22:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIS5SNKKKtZ5VRm/6T5hn5KAH0Cg7LbJVKGKre8/WZIcIt53l2bXqInmMfqBG/CD7ilCzX1g==
X-Received: by 2002:a1c:9894:: with SMTP id a142mr2543006wme.167.1601360558415;
        Mon, 28 Sep 2020 23:22:38 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id k8sm4517984wrl.42.2020.09.28.23.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 23:22:37 -0700 (PDT)
Date:   Tue, 29 Sep 2020 02:22:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
Message-ID: <20200929022138-mutt-send-email-mst@kernel.org>
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
 <20200928152142-mutt-send-email-mst@kernel.org>
 <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com>
 <20200929015427-mutt-send-email-mst@kernel.org>
 <CAMDZJNX94out3B_puYy+zbdotDwU=qZKG2=sMfyoj9o5nnewmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMDZJNX94out3B_puYy+zbdotDwU=qZKG2=sMfyoj9o5nnewmA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 02:10:56PM +0800, Tonghao Zhang wrote:
> On Tue, Sep 29, 2020 at 1:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 09:45:24AM +0800, Tonghao Zhang wrote:
> > > On Tue, Sep 29, 2020 at 3:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > >
> > > > > Allow user configuring RXCSUM separately with ethtool -K,
> > > > > reusing the existing virtnet_set_guest_offloads helper
> > > > > that configures RXCSUM for XDP. This is conditional on
> > > > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > > >
> > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> > > > >  1 file changed, 28 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 21b71148c532..2e3af0b2c281 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > > > >                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > >                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > >
> > > > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > > > +
> > > > >  struct virtnet_stat_desc {
> > > > >       char desc[ETH_GSTRING_LEN];
> > > > >       size_t offset;
> > > > > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> > > > >                               netdev_features_t features)
> > > > >  {
> > > > >       struct virtnet_info *vi = netdev_priv(dev);
> > > > > -     u64 offloads;
> > > > > +     u64 offloads = vi->guest_offloads &
> > > > > +                    vi->guest_offloads_capable;
> > > > >       int err;
> > > > >
> > > > > -     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > > -             if (vi->xdp_queue_pairs)
> > > > > -                     return -EBUSY;
> > > > > +     /* Don't allow configuration while XDP is active. */
> > > > > +     if (vi->xdp_queue_pairs)
> > > > > +             return -EBUSY;
> > > > >
> > > > > +     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > >               if (features & NETIF_F_LRO)
> > > > > -                     offloads = vi->guest_offloads_capable;
> > > > > +                     offloads |= GUEST_OFFLOAD_LRO_MASK;
> > > > >               else
> > > > > -                     offloads = vi->guest_offloads_capable &
> > > > > -                                ~GUEST_OFFLOAD_LRO_MASK;
> > > > > +                     offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > > > > +     }
> > > > >
> > > > > -             err = virtnet_set_guest_offloads(vi, offloads);
> > > > > -             if (err)
> > > > > -                     return err;
> > > > > -             vi->guest_offloads = offloads;
> > > > > +     if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > > > > +             if (features & NETIF_F_RXCSUM)
> > > > > +                     offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > > > > +             else
> > > > > +                     offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> > > > >       }
> > > > >
> > > > > +     if (offloads == (vi->guest_offloads &
> > > > > +                      vi->guest_offloads_capable))
> > > > > +             return 0;
> > > >
> > > > Hmm, what exactly does this do?
> > > If the features(lro, rxcsum) we supported, are not changed, it is not
> > > necessary to invoke virtnet_set_guest_offloads.
> >
> > okay, could you describe the cases where this triggers in a bit more
> > detail pls?
> Hi
> As I known,  when we run che commands show as below:
> ethtool -K eth1 sg off
> ethtool -K eth1 tso off
> 
> In that case, we will not invoke virtnet_set_guest_offloads.

How about initialization though? E.g. it looks like guest_offloads
is 0-initialized, won't this skip the first command to disable
offloads?

> > > > > +
> > > > > +     err = virtnet_set_guest_offloads(vi, offloads);
> > > > > +     if (err)
> > > > > +             return err;
> > > > > +
> > > > > +     vi->guest_offloads = offloads;
> > > > >       return 0;
> > > > >  }
> > > > >
> > > > > @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > >           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > > >               dev->features |= NETIF_F_LRO;
> > > > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > > > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > > > > +             dev->hw_features |= NETIF_F_RXCSUM;
> > > > >               dev->hw_features |= NETIF_F_LRO;
> > > > > +     }
> > > > >
> > > > >       dev->vlan_features = dev->features;
> > > > >
> > > > > --
> > > > > 2.23.0
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

