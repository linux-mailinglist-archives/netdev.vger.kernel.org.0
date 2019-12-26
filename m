Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14ED12AE2D
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 20:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfLZTMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 14:12:23 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:35763 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfLZTMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 14:12:23 -0500
Received: by mail-vk1-f196.google.com with SMTP id o187so6329730vka.2
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 11:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r8KpMgsYL2ZCy9eGVPdtnJ4T4Q2FxqQwB9hJfGokaLs=;
        b=b1Bea9QqFDzeF9WPB0W5ucaCk4UmLbyLzI58h7lEJOhZk39mF9M9biGSVuCZ4X3tbW
         JFuIFnUCXw8ixNcsTDJKGKvoG6g/R3HcNNZLXRbmyn71/cBPL7G5KO6RTRqjdB8SjpLd
         2hW3ccGuDSz2WNYtxyjIMQfkq8PD8hX6GxO4TBfe3WGEd5d1fML3yt6bfHazSEj9FhrS
         D72tB5v6lPkD32ey6Gw1MWRlAwPDuf3Vh23Iq2u2Ixwx8iFi2em/zQ/U7xOnvKDZ5kfI
         iU+B6eBazSGV4hwoNxAj02v2c53fp0KSOUduOSzuGGU0BjYMe9UwdG/d0MuR7jKaEfcG
         Caag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r8KpMgsYL2ZCy9eGVPdtnJ4T4Q2FxqQwB9hJfGokaLs=;
        b=qAAynzzAJ1hIW4wpP1ED0TfgOeUmxoaEdBV8MyuYvZcYYJjvGrG2A68FjLY5jp5dpg
         UV/ohasr4UYuvRT2yw2av+U+KVwN/TClrLQpDrblPtos51m2POpyXDnechnmMHH4Wp3K
         7GiVt40xh/urx8aBoHwqFDS45Y+RT9xoETvN9f988Y7vtCwYYyQKjjaFr/msY9CjHHKx
         yGoSKDtwv5zpywjKpVqDs/jCBAuSBC6o5ejqJ5jEICvrnKYlrzuzzBRQxNYx3HnqUOwg
         Quthu73OBnXoEH4MEj4CF+2kGFaSk90D+Y/eRk5+ZukdETjpPVOyy7/67b+aBYJyXbrP
         z2cg==
X-Gm-Message-State: APjAAAUTcK93rjtOmftFoZDXEglxJmiXbNTkg29aZ/BmQEDv8fzcWOmq
        A12ZC0Tg06DQiLetQBV74qMHNBeCidKKlFsz1DQgZg==
X-Google-Smtp-Source: APXvYqyh6h0Cf/gdN5ieAF3s4fnxHFvyfa9/Cw2SM+DE8ZiVc4eKnVueqChIfPYbNB4aPgx7HuTWkd/j1u+pgZJE9ow=
X-Received: by 2002:ac5:cde3:: with SMTP id v3mr28383914vkn.43.1577387541747;
 Thu, 26 Dec 2019 11:12:21 -0800 (PST)
MIME-Version: 1.0
References: <20191223140322.20013-1-mst@redhat.com> <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
 <CA+FuTSfq5v3-0VYmTG7YFFUqT8uG53eXXhqc8WvVvMbp3s0nvA@mail.gmail.com>
 <CA+FuTScwwajN2ny2w8EBkBQd191Eb1ZsrRhbh3=5eQervArnEA@mail.gmail.com>
 <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com> <CA+FuTSfrg9eOee6sxR-oSb4sfK2-FbQh7A0y3YJOjf+pTmSjxA@mail.gmail.com>
In-Reply-To: <CA+FuTSfrg9eOee6sxR-oSb4sfK2-FbQh7A0y3YJOjf+pTmSjxA@mail.gmail.com>
From:   Alistair Delva <adelva@google.com>
Date:   Thu, 26 Dec 2019 11:12:10 -0800
Message-ID: <CANDihLHxtZ+3vo4Eva=P7LN9y04wrKq3VKRUj0yo6tDvaM+CbQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 8:02 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Dec 23, 2019 at 3:22 PM Alistair Delva <adelva@google.com> wrote:
> >
> > On Mon, Dec 23, 2019 at 12:12 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Mon, Dec 23, 2019 at 2:56 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > 00fffe0ff0 DR7: 0000000000000400
> > > > > > Call Trace:
> > > > > >  ? preempt_count_add+0x58/0xb0
> > > > > >  ? _raw_spin_lock_irqsave+0x36/0x70
> > > > > >  ? _raw_spin_unlock_irqrestore+0x1a/0x40
> > > > > >  ? __wake_up+0x70/0x190
> > > > > >  virtnet_set_features+0x90/0xf0 [virtio_net]
> > > > > >  __netdev_update_features+0x271/0x980
> > > > > >  ? nlmsg_notify+0x5b/0xa0
> > > > > >  dev_disable_lro+0x2b/0x190
> > > > > >  ? inet_netconf_notify_devconf+0xe2/0x120
> > > > > >  devinet_sysctl_forward+0x176/0x1e0
> > > > > >  proc_sys_call_handler+0x1f0/0x250
> > > > > >  proc_sys_write+0xf/0x20
> > > > > >  __vfs_write+0x3e/0x190
> > > > > >  ? __sb_start_write+0x6d/0xd0
> > > > > >  vfs_write+0xd3/0x190
> > > > > >  ksys_write+0x68/0xd0
> > > > > >  __ia32_sys_write+0x14/0x20
> > > > > >  do_fast_syscall_32+0x86/0xe0
> > > > > >  entry_SYSENTER_compat+0x7c/0x8e
> > > > > >
> > > > > > A similar crash will likely trigger when enabling XDP.
> > > > > >
> > > > > > Reported-by: Alistair Delva <adelva@google.com>
> > > > > > Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > > > > Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
> > > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > > ---
> > > > > >
> > > > > > Lightly tested.
> > > > > >
> > > > > > Alistair, could you please test and confirm that this resolves the
> > > > > > crash for you?
> > > > >
> > > > > This patch doesn't work. The reason is that NETIF_F_LRO is also turned
> > > > > on by TSO4/TSO6, which your patch didn't check for. So it ends up
> > > > > going through the same path and crashing in the same way.
> > > > >
> > > > >         if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > >             virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > > >                 dev->features |= NETIF_F_LRO;
> > > > >
> > > > > It sounds like this patch is fixing something slightly differently to
> > > > > my patch fixed. virtnet_set_features() doesn't care about
> > > > > GUEST_OFFLOADS, it only tests against NETIF_F_LRO. Even if "offloads"
> > > > > is zero, it will call virtnet_set_guest_offloads(), which triggers the
> > > > > crash.
> > > >
> > > >
> > > > Interesting. It's surprising that it is trying to configure a flag
> > > > that is not configurable, i.e., absent from dev->hw_features
> > > > after Michael's change.
> > > >
> > > > > So either we need to ensure NETIF_F_LRO is never set, or
> > > >
> > > > LRO might be available, just not configurable. Indeed this was what I
> > > > observed in the past.
> > >
> > > dev_disable_lro expects that NETIF_F_LRO is always configurable. Which
> > > I guess is a reasonable assumption, just not necessarily the case in
> > > virtio_net.
> > >
> > > So I think we need both patches. Correctly mark the feature as fixed
> > > by removing from dev->hw_features and also ignore the request from
> > > dev_disable_lro, which does not check for this.
> >
> > Something like this maybe:
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4d7d5434cc5d..0556f42b0fb5 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device *dev,
> >         u64 offloads;
> >         int err;
> >
> > +       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > +               return 0;
> > +
> >         if ((dev->features ^ features) & NETIF_F_LRO) {
> >                 if (vi->xdp_queue_pairs)
> >                         return -EBUSY;
> > @@ -2971,6 +2974,15 @@ static int virtnet_validate(struct virtio_device *vdev)
> >         if (!virtnet_validate_features(vdev))
> >                 return -EINVAL;
> >
> > +       /* VIRTIO_NET_F_CTRL_GUEST_OFFLOADS does not work without
> > +        * VIRTIO_NET_F_CTRL_VQ. However the virtio spec does not
> > +        * specify that VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends
> > +        * on VIRTIO_NET_F_CTRL_VQ so devices can set the later but
> > +        * not the former.
> > +        */
> > +       if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> > +               __virtio_clear_bit(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
> > +
> >         if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
> >                 int mtu = virtio_cread16(vdev,
> >                                          offsetof(struct virtio_net_config,
>
> I think we need three separate patches.
>
> - disable guest offloads if VQ is absent
> - remove LRO from hw_features if guest offloads are absent
>
> This should fix the ethtool path.  But there is a separate path to
> disable LRO through dev_disable_lro (from bond enslave, xdp install,
> sysctl -n net.ipv.ip_forward=1, ..) that assumes LRO is always
> configurable. So we cannot work around needing a patch to
> virtset_set_features.
>
> After a long detour, I think your original submission is fine for
> that.

Alright. Knowing all the use cases now, and if nobody beats me to it,
I'll resubmit this as a series which fixes the three paths.

> Perhaps with a comment in the commit that it is needed even
> if the feature is absent from hw_features for dev_disable_lro.

Ack.
