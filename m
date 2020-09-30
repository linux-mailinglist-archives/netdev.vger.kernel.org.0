Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA4E27DE58
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 04:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgI3CLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 22:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgI3CLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 22:11:49 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBE7C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 19:11:48 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g4so170015edk.0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 19:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7hZ1tmJDKYbFj1JAR2kOqXmJ14cEBCBL/omVit1tt0s=;
        b=HBThixVJFPy2i/wXeINssCE+v7YQyICrCJcnIXctSDPZcNDXhfa2QpdfTAttjX+6VD
         nPLVueF6rZ6Q8WIhAHIMytXxlKKA0SR914CAFk+JB5Fn4IIY8W9cIWRWPrVKVxygY2Ya
         HIRiVe/DvXPPqLeXo7WKxVJUieoOYGffMxB6zWbm6INFKA9dN09xyAR52VwtQLz31d5a
         Y2hlia8qk63vCgHY7ZgIJ00wPM1y+79DzpPKomCMR7EKU76FwBzZfEew7FU+mL+AskEv
         1tLakI8d9J2ccH3gV5M9t63QMxALY5fzhA4Db99/Qd/dqBbtA2pMJ5dbQrNNrMIf9R+Y
         aCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7hZ1tmJDKYbFj1JAR2kOqXmJ14cEBCBL/omVit1tt0s=;
        b=AXJ1r7brmshYJWnHNXrk0Toz6CCsfAFRN8AL74MBDjhGG+r9/OtyzKJFvB1EACwM/9
         vM7B397hQDYYRdVMHygLcn6YbvtaE7Az+h/x0QnGavkev7tIeR3+hTnnkC0SI+8ug3ja
         zvQRK9phYJPI3kP03IavyAq9WGdXCrYwcBAScvf8EhZNXfQdI9wqGNHCvYPeZk+J2CbO
         +ROEjEbkcz8ySViOwDsQ69A+3/+ofShp6szWcUftXvpoPIIC4lAiBgMBW3DJtuZx3Ycc
         kT7qWh2L28XbsHmaKH3YSHDznhc+LbWp8ZrKORVRLsIBVzp0zmRWtVld975pRDurNQNt
         CWqg==
X-Gm-Message-State: AOAM531sETjbH33XjhP2r2I/kICw78kZUm+AEMMFi0JRgk8AvLSii9uh
        PZ8r0M1n8Mup0nb8NalQ4qlwNw8EhNpIyrrXXLd6uL+hHL8=
X-Google-Smtp-Source: ABdhPJyX+Z741IY7X4VfM2bYUi7FQKJY4JmN9c+eeMmAv0Ix/UWTYfkiM6MPYX8iiH4X3y8ZifbFiJd4No6QJ2CCVTE=
X-Received: by 2002:a50:eb0a:: with SMTP id y10mr387086edp.89.1601431906593;
 Tue, 29 Sep 2020 19:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com> <20200928152142-mutt-send-email-mst@kernel.org>
 <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com>
 <20200929015427-mutt-send-email-mst@kernel.org> <CAMDZJNX94out3B_puYy+zbdotDwU=qZKG2=sMfyoj9o5nnewmA@mail.gmail.com>
 <20200929022138-mutt-send-email-mst@kernel.org> <CAMDZJNVzKc-Wb13Z5ocz_4DHqP_ZMzM1sO1GWmmKhNUKMuP9PQ@mail.gmail.com>
 <20200929032314-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200929032314-mutt-send-email-mst@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 30 Sep 2020 10:09:07 +0800
Message-ID: <CAMDZJNXvWEB5-D0gFVsLfqEHwHTTe0K+4ro3EzyExFmhiFxKUg@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 3:25 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Sep 29, 2020 at 03:17:50PM +0800, Tonghao Zhang wrote:
> > On Tue, Sep 29, 2020 at 2:22 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Sep 29, 2020 at 02:10:56PM +0800, Tonghao Zhang wrote:
> > > > On Tue, Sep 29, 2020 at 1:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Tue, Sep 29, 2020 at 09:45:24AM +0800, Tonghao Zhang wrote:
> > > > > > On Tue, Sep 29, 2020 at 3:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > >
> > > > > > > > Allow user configuring RXCSUM separately with ethtool -K,
> > > > > > > > reusing the existing virtnet_set_guest_offloads helper
> > > > > > > > that configures RXCSUM for XDP. This is conditional on
> > > > > > > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > > > > > >
> > > > > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > > > ---
> > > > > > > >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> > > > > > > >  1 file changed, 28 insertions(+), 12 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > > > index 21b71148c532..2e3af0b2c281 100644
> > > > > > > > --- a/drivers/net/virtio_net.c
> > > > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > > > > > > >                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > > > > >                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > > > > >
> > > > > > > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > > > > > > +
> > > > > > > >  struct virtnet_stat_desc {
> > > > > > > >       char desc[ETH_GSTRING_LEN];
> > > > > > > >       size_t offset;
> > > > > > > > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> > > > > > > >                               netdev_features_t features)
> > > > > > > >  {
> > > > > > > >       struct virtnet_info *vi = netdev_priv(dev);
> > > > > > > > -     u64 offloads;
> > > > > > > > +     u64 offloads = vi->guest_offloads &
> > > > > > > > +                    vi->guest_offloads_capable;
> > > > > > > >       int err;
> > > > > > > >
> > > > > > > > -     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > > > > > -             if (vi->xdp_queue_pairs)
> > > > > > > > -                     return -EBUSY;
> > > > > > > > +     /* Don't allow configuration while XDP is active. */
> > > > > > > > +     if (vi->xdp_queue_pairs)
> > > > > > > > +             return -EBUSY;
> > > > > > > >
> > > > > > > > +     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > > > > >               if (features & NETIF_F_LRO)
> > > > > > > > -                     offloads = vi->guest_offloads_capable;
> > > > > > > > +                     offloads |= GUEST_OFFLOAD_LRO_MASK;
> > > > > > > >               else
> > > > > > > > -                     offloads = vi->guest_offloads_capable &
> > > > > > > > -                                ~GUEST_OFFLOAD_LRO_MASK;
> > > > > > > > +                     offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > > > > > > > +     }
> > > > > > > >
> > > > > > > > -             err = virtnet_set_guest_offloads(vi, offloads);
> > > > > > > > -             if (err)
> > > > > > > > -                     return err;
> > > > > > > > -             vi->guest_offloads = offloads;
> > > > > > > > +     if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > > > > > > > +             if (features & NETIF_F_RXCSUM)
> > > > > > > > +                     offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > > > > > > > +             else
> > > > > > > > +                     offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> > > > > > > >       }
> > > > > > > >
> > > > > > > > +     if (offloads == (vi->guest_offloads &
> > > > > > > > +                      vi->guest_offloads_capable))
> > > > > > > > +             return 0;
> > > > > > >
> > > > > > > Hmm, what exactly does this do?
> > > > > > If the features(lro, rxcsum) we supported, are not changed, it is not
> > > > > > necessary to invoke virtnet_set_guest_offloads.
> > > > >
> > > > > okay, could you describe the cases where this triggers in a bit more
> > > > > detail pls?
> > > > Hi
> > > > As I known,  when we run che commands show as below:
> > > > ethtool -K eth1 sg off
> > > > ethtool -K eth1 tso off
> > > >
> > > > In that case, we will not invoke virtnet_set_guest_offloads.
> > >
> > > How about initialization though? E.g. it looks like guest_offloads
> > > is 0-initialized, won't this skip the first command to disable
> > > offloads?
> > I guest you mean that: if guest_offloads == 0, and run the command
> > "ethtool -K eth1 sg off", that will disable offload ?
> > In that patch
> > u64 offloads = vi->guest_offloads & vi->guest_offloads_capable; // offload = 0
> > .....
> >  if (offloads == (vi->guest_offloads & vi->guest_offloads_capable)) //
> > if offload not changed, offload == 0, and (vi->guest_offloads &
> > vi->guest_offloads_capable) == 0.
> >         return 0;
> >
> > virtnet_set_guest_offloads // that will not be invoked, so will not
> > disable offload
>
>
> Sorry don't understand the question here.
> At device init offloads are enabled, I am asking won't this skip
> disabling them the first time this function is invoked.
> Why are we bothering with this check? Is this called lots of
> times where offloads are unchanged to make skipping the
> command worthwhile?
Hi Michael
I remove the check and when rxcum is disabled, LRO also is disabled
(suggested by Willem de Bruijn)
please review, thanks.

http://patchwork.ozlabs.org/project/netdev/patch/20200930020300.62245-1-xiangxia.m.yue@gmail.com/

> > > > > > > > +
> > > > > > > > +     err = virtnet_set_guest_offloads(vi, offloads);
> > > > > > > > +     if (err)
> > > > > > > > +             return err;
> > > > > > > > +
> > > > > > > > +     vi->guest_offloads = offloads;
> > > > > > > >       return 0;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > > > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > > > > >           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > > > > > >               dev->features |= NETIF_F_LRO;
> > > > > > > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > > > > > > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > > > > > > > +             dev->hw_features |= NETIF_F_RXCSUM;
> > > > > > > >               dev->hw_features |= NETIF_F_LRO;
> > > > > > > > +     }
> > > > > > > >
> > > > > > > >       dev->vlan_features = dev->features;
> > > > > > > >
> > > > > > > > --
> > > > > > > > 2.23.0
> > > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Best regards, Tonghao
> > > > >
> > > >
> > > >
> > > > --
> > > > Best regards, Tonghao
> > >
> >
> >
> > --
> > Best regards, Tonghao
>


-- 
Best regards, Tonghao
