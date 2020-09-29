Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1730127BDE0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgI2HUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbgI2HUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:20:16 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB53C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:20:16 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n22so5212932edt.4
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/8AfVIM7nj1s2C0M9w5fBluTPef3EMqzRWiiH1JKPFg=;
        b=UAS8pwDuEKmzmaCwLryEJ41G/kriWG32BblW26Q+0RCqfG5JKnJBzel3h+K6MjxzQ2
         OVLs9/yDWFMXp7x15xx1WgGcYKBuCPpYZYaRGXzypavfSywtu5z3YRio01+Dm/OEvT4w
         dQDJdg1rGWgM+fKO9WLIXsbkR8ZTLoOGRj9R/xz7pNlHb+7bA62GUemhW2xfhiY3VX6/
         y28Rmr+WK96t142eBHVrxaMQ5Y3gy3lKrWpN2XfTOn71kQ3PXQH+gSiVXmovZyRFhVaH
         JcJX0i75v/xoF5FRfw5+uMdsVVl7fpVTq03efJo0rjlOTuCWSt7kIk3eKzk4fwtmJibW
         f1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/8AfVIM7nj1s2C0M9w5fBluTPef3EMqzRWiiH1JKPFg=;
        b=SUwe1yDAazQu6qIC0QbgN4qBjf0ND+iL6FaDT8OxtqbqQbD7cmFg7gPZYmRjCz2mYW
         GC61Cbx7PkNL7yc0zddyabE+qKofp/ZbrNsnJ64ZEb6vQKAojlUBFs65L59DcdK3f8bg
         WLNvNCl7Krj3Yt1g0i7abWv5+maDeOAJ5ASrTxtu35hMzDq1rIbciwy5m3k1BSqlivyN
         nSK4W5U4oLNaPYO4KDqQmNOMbbS6zfKB9Hq2nPhltjusAPcHIZLU4+uirkN8S1gQJlwo
         SHadobvY7UvNcOi+6LavwcJofPEueXLHhdU/XYxdHM766LscCb/ZsoE5jh/b9Ra6UEO5
         VR7w==
X-Gm-Message-State: AOAM530SR8KUQjUjrI/XI4HQK5OOFm+2BbRDw4ZjGyxAzUMdNOQy4jtK
        lDtf0tedLPTArVnAZ1Fx9uRJSHk/M1zQySFRidYhiDZMnR4=
X-Google-Smtp-Source: ABdhPJx6wh40oMhel4yV9yYghsAjTEx9I/nGf0Jd2jWwUt6dweX3wyJfEFhxf/CLbS5o3vN62ZeBgbX3kKEYBowi8Mw=
X-Received: by 2002:a05:6402:1353:: with SMTP id y19mr1778136edw.71.1601364014949;
 Tue, 29 Sep 2020 00:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
 <20200928033915.82810-2-xiangxia.m.yue@gmail.com> <20200928152142-mutt-send-email-mst@kernel.org>
 <CAMDZJNVUVm9y2NV5ZGHzrPoEaDF4PZEGWVFEx9g6sF3U-1Rm0Q@mail.gmail.com>
 <20200929015427-mutt-send-email-mst@kernel.org> <CAMDZJNX94out3B_puYy+zbdotDwU=qZKG2=sMfyoj9o5nnewmA@mail.gmail.com>
 <20200929022138-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200929022138-mutt-send-email-mst@kernel.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 29 Sep 2020 15:17:50 +0800
Message-ID: <CAMDZJNVzKc-Wb13Z5ocz_4DHqP_ZMzM1sO1GWmmKhNUKMuP9PQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 2:22 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Sep 29, 2020 at 02:10:56PM +0800, Tonghao Zhang wrote:
> > On Tue, Sep 29, 2020 at 1:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Sep 29, 2020 at 09:45:24AM +0800, Tonghao Zhang wrote:
> > > > On Tue, Sep 29, 2020 at 3:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Sep 28, 2020 at 11:39:15AM +0800, xiangxia.m.yue@gmail.com wrote:
> > > > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > >
> > > > > > Allow user configuring RXCSUM separately with ethtool -K,
> > > > > > reusing the existing virtnet_set_guest_offloads helper
> > > > > > that configures RXCSUM for XDP. This is conditional on
> > > > > > VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> > > > > >
> > > > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > > > ---
> > > > > >  drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
> > > > > >  1 file changed, 28 insertions(+), 12 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > index 21b71148c532..2e3af0b2c281 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
> > > > > >                               (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> > > > > >                               (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > > > > >
> > > > > > +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > > > > > +
> > > > > >  struct virtnet_stat_desc {
> > > > > >       char desc[ETH_GSTRING_LEN];
> > > > > >       size_t offset;
> > > > > > @@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
> > > > > >                               netdev_features_t features)
> > > > > >  {
> > > > > >       struct virtnet_info *vi = netdev_priv(dev);
> > > > > > -     u64 offloads;
> > > > > > +     u64 offloads = vi->guest_offloads &
> > > > > > +                    vi->guest_offloads_capable;
> > > > > >       int err;
> > > > > >
> > > > > > -     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > > > -             if (vi->xdp_queue_pairs)
> > > > > > -                     return -EBUSY;
> > > > > > +     /* Don't allow configuration while XDP is active. */
> > > > > > +     if (vi->xdp_queue_pairs)
> > > > > > +             return -EBUSY;
> > > > > >
> > > > > > +     if ((dev->features ^ features) & NETIF_F_LRO) {
> > > > > >               if (features & NETIF_F_LRO)
> > > > > > -                     offloads = vi->guest_offloads_capable;
> > > > > > +                     offloads |= GUEST_OFFLOAD_LRO_MASK;
> > > > > >               else
> > > > > > -                     offloads = vi->guest_offloads_capable &
> > > > > > -                                ~GUEST_OFFLOAD_LRO_MASK;
> > > > > > +                     offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > > > > > +     }
> > > > > >
> > > > > > -             err = virtnet_set_guest_offloads(vi, offloads);
> > > > > > -             if (err)
> > > > > > -                     return err;
> > > > > > -             vi->guest_offloads = offloads;
> > > > > > +     if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > > > > > +             if (features & NETIF_F_RXCSUM)
> > > > > > +                     offloads |= GUEST_OFFLOAD_CSUM_MASK;
> > > > > > +             else
> > > > > > +                     offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> > > > > >       }
> > > > > >
> > > > > > +     if (offloads == (vi->guest_offloads &
> > > > > > +                      vi->guest_offloads_capable))
> > > > > > +             return 0;
> > > > >
> > > > > Hmm, what exactly does this do?
> > > > If the features(lro, rxcsum) we supported, are not changed, it is not
> > > > necessary to invoke virtnet_set_guest_offloads.
> > >
> > > okay, could you describe the cases where this triggers in a bit more
> > > detail pls?
> > Hi
> > As I known,  when we run che commands show as below:
> > ethtool -K eth1 sg off
> > ethtool -K eth1 tso off
> >
> > In that case, we will not invoke virtnet_set_guest_offloads.
>
> How about initialization though? E.g. it looks like guest_offloads
> is 0-initialized, won't this skip the first command to disable
> offloads?
I guest you mean that: if guest_offloads == 0, and run the command
"ethtool -K eth1 sg off", that will disable offload ?
In that patch
u64 offloads = vi->guest_offloads & vi->guest_offloads_capable; // offload = 0
.....
 if (offloads == (vi->guest_offloads & vi->guest_offloads_capable)) //
if offload not changed, offload == 0, and (vi->guest_offloads &
vi->guest_offloads_capable) == 0.
        return 0;

virtnet_set_guest_offloads // that will not be invoked, so will not
disable offload

> > > > > > +
> > > > > > +     err = virtnet_set_guest_offloads(vi, offloads);
> > > > > > +     if (err)
> > > > > > +             return err;
> > > > > > +
> > > > > > +     vi->guest_offloads = offloads;
> > > > > >       return 0;
> > > > > >  }
> > > > > >
> > > > > > @@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > > >           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > > > >               dev->features |= NETIF_F_LRO;
> > > > > > -     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > > > > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > > > > > +             dev->hw_features |= NETIF_F_RXCSUM;
> > > > > >               dev->hw_features |= NETIF_F_LRO;
> > > > > > +     }
> > > > > >
> > > > > >       dev->vlan_features = dev->features;
> > > > > >
> > > > > > --
> > > > > > 2.23.0
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
