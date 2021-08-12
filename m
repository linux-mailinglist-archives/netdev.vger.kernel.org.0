Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9E3E9DB9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 07:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhHLFAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 01:00:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234126AbhHLFAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 01:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628744409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DQUQgpLOH7EvoFZyVb3gOKPst+Hz5mvO2rmYb4CAJ/s=;
        b=Tfb1IVeB6PybPqW9KCdZjAmOG5ynwEd6k9sUxlJJqENwZb9sEYXMKhfgdCnOI4eWrsRFk8
        SDOHMhpkSd+Jz2G4ndD8cB8xM1ac8h+VZLtU6ALISyouJODsWb3MX75zTAP0Zgqa+ErrLq
        1t1BqFHcf3PuqWPIgHcAhpGhuBwBDvE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-y4CWZNIhNJGqXA0ujjjG0g-1; Thu, 12 Aug 2021 01:00:06 -0400
X-MC-Unique: y4CWZNIhNJGqXA0ujjjG0g-1
Received: by mail-ed1-f69.google.com with SMTP id e18-20020a0564020892b02903be9702d63eso1209641edy.17
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 22:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DQUQgpLOH7EvoFZyVb3gOKPst+Hz5mvO2rmYb4CAJ/s=;
        b=pFz+6U5BEkFFhD+m4QOjHxTFOqCyXjG3V6D3jTD0FZITHb3j7kAEE/OYGC7e5WhgSK
         b2XQvcmaKfuMhHWsEjzxYZOW5IpEPi9lOlSodm3sltz3JMmkhKiSNBZqLqw6RXTnt1S4
         OJII994vZV8LY7mjbTLbF+zdsE0rDnmMx5w4/linVhBJNf9jUBIxwB8b9CMZU3DAim80
         crQZHXWfq4SrHtcgoaisTz7fb1rGuX0P1jnKFtNJAypVkRg8tHyy+qtdhEQcsxLMoAbZ
         /Ng3SbktB5xeKqsm9nnTWMUzXV9X9nYxG8qQ/KmcR7rkyAmLJaQlqvDxeU5USVPxlU9U
         0qFA==
X-Gm-Message-State: AOAM533eAiXe0jHMOyrGWKtlul1NvKa1H5uHNoK2VKGWTCS3fHkzG+pa
        03JSaGkXSGlUgQztg7CS/+Prrn1zBbACUPvH9BP6MLReURHrn8mwN4HjvFg7sF9IUZQeZlThdX8
        AIO9wblXRHWwhLO0k
X-Received: by 2002:a17:906:580c:: with SMTP id m12mr1960731ejq.32.1628744404132;
        Wed, 11 Aug 2021 22:00:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKLVMf+qTdMY912mSDNmu9+IlM2KUZDsBbWXlCpC6KUa/Fgm9wWtlkt1XeENnU8hLWpfURvQ==
X-Received: by 2002:a17:906:580c:: with SMTP id m12mr1960711ejq.32.1628744403856;
        Wed, 11 Aug 2021 22:00:03 -0700 (PDT)
Received: from redhat.com ([2.55.129.96])
        by smtp.gmail.com with ESMTPSA id ck17sm90912edb.88.2021.08.11.22.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 22:00:03 -0700 (PDT)
Date:   Thu, 12 Aug 2021 00:59:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     ivan <ivan@prestigetransportation.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC PATCH] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
Message-ID: <20210812005246-mutt-send-email-mst@kernel.org>
References: <20210811081623.9832-1-jasowang@redhat.com>
 <CACFia2dOarWzZ-FfOgA-n3Puxhw4zacdEPtabzbbveyeuV3YBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACFia2dOarWzZ-FfOgA-n3Puxhw4zacdEPtabzbbveyeuV3YBA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 08:20:03PM -0500, ivan wrote:
> On Wed, Aug 11, 2021 at 3:16 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > Commit a02e8964eaf92 ("virtio-net: ethtool configurable LRO") tries to
> > advertise LRO on behalf of the guest offloading features and allow the
> > administrator to enable and disable those features via ethtool.
> >
> > This may lead several issues:
> >
> > - For the device that doesn't support control guest offloads, the
> >   "LRO" can't be disabled so we will get a warn in the
> >   dev_disable_lro()
> > - For the device that have the control guest offloads, the guest
> >   offloads were disabled in the case of bridge etc which may slow down
> >   the traffic.
> >
> > Try to fix this by using NETIF_F_GRO_HW instead so we're not
> > guaranteed to be re-segmented as original. Or we may want a new netdev
> > feature like RX_GSO since the guest offloads for virtio-net is
> > actually to receive GSO packet.
> >
> > Or we can try not advertise LRO is control guest offloads is not
> > enabled. This solves the warning but will still slow down the traffic.
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 0416a7e00914..10c382b08bce 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -63,7 +63,7 @@ static const unsigned long guest_offloads[] = {
> >         VIRTIO_NET_F_GUEST_CSUM
> >  };
> >
> > -#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> > +#define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> >                                 (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> >                                 (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> >                                 (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > @@ -2481,7 +2481,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> >                 virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> >                 virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
> >                 virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
> > -               NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
> > +               NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
> >                 return -EOPNOTSUPP;
> >         }
> >
> > @@ -2612,15 +2612,15 @@ static int virtnet_set_features(struct net_device *dev,
> >         u64 offloads;
> >         int err;
> >
> > -       if ((dev->features ^ features) & NETIF_F_LRO) {
> > +       if ((dev->features ^ features) & NETIF_F_GRO_HW) {
> >                 if (vi->xdp_enabled)
> >                         return -EBUSY;
> >
> > -               if (features & NETIF_F_LRO)
> > +               if (features & NETIF_F_GRO_HW)
> >                         offloads = vi->guest_offloads_capable;
> >                 else
> >                         offloads = vi->guest_offloads_capable &
> > -                                  ~GUEST_OFFLOAD_LRO_MASK;
> > +                                  ~GUEST_OFFLOAD_GRO_HW_MASK;
> >
> >                 err = virtnet_set_guest_offloads(vi, offloads);
> >                 if (err)
> > @@ -3100,9 +3100,9 @@ static int virtnet_probe(struct virtio_device *vdev)
> >                 dev->features |= NETIF_F_RXCSUM;
> >         if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> >             virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > -               dev->features |= NETIF_F_LRO;
> > +               dev->features |= NETIF_F_GRO_HW;
> >         if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > -               dev->hw_features |= NETIF_F_LRO;
> > +               dev->hw_features |= NETIF_F_GRO_HW;
> >
> >         dev->vlan_features = dev->features;
> >
> > --
> 
> I applied this patch, recompiled the kernel, and tested it.
> The warning messages are gone. Network speed is normal.
> I can now enable forwarding, and nothing bad happens.
> So far, so good.
> 
> Thank you.

OK so that's

Tested-by: ivan <ivan@prestigetransportation.com>

It is still weird that without the patch networking dies.

What happens if you apply the patch then try to disable GRO
using ethtool?

-- 
MST

