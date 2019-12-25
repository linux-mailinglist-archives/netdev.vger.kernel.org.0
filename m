Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB6F12A876
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLYQCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 11:02:46 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38671 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfLYQCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 11:02:45 -0500
Received: by mail-yw1-f66.google.com with SMTP id 10so9422219ywv.5
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 08:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xbjdKFYnRPE22MuPGqmxVrHVoC1Lr//HPWCd1VnKDIc=;
        b=TIBIumMRVZUUukwX9fjUvDYs638HJM1vhjJBtoz3hhtjI9JpCxNz9wiphndtw0uO9J
         A5mZg/srdnxEKPDQtVZjLAC1WuG315ExhtWfz3lacmEuv6N+NKBEgrVbcanGjXcVhQFF
         a+pqL3jAW8c9HhS5xojaTTX45jQe6zd0khDbcvsJ2dGIGyARRWuD6WgMh1qeFDkVEz/T
         7E6+MB9mYtokUybi1I+c6VtfU9QTf4wYJkl0g1zcOwyq92bsiAnm81apo/9BpEQ1je4y
         xhWqJ16mVdBAnK4nt4JjDM7WY5XlOMfLygIYUzoHm7Q9e5R8wp2BtSdTbp5w5nl41/kP
         7iYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xbjdKFYnRPE22MuPGqmxVrHVoC1Lr//HPWCd1VnKDIc=;
        b=YhYqSXEXgMWX4XScuIvvgZS2igdJTbicS2jNE+sQNh78EJ4ubRtHHtm57eerWnbICM
         50WZTx4F8lxupmtoXWq+Mh/7EyXehkmWgi93D2hQ3ihHAvU8RpuLFnffkeVMA/zC3DJV
         KkjCvoQpvCoGkVTWTX9keFzcL367m344OBdj0FtLQEsgaBI6yueb6HZjhUsUBlOCIWW3
         S+JhIUMToogcv4pFrWK6fWX/4JgO4ENbSdSEb8z4PiFjbs32KXTRS/ZoATQ64uFoFW0n
         NFvbVZgZg6qDG9kiZorFv7jB5uwP0SkL0Bw69iyOsmmZ5UC8LIVhHecbg5qArOP45UDX
         mw1g==
X-Gm-Message-State: APjAAAWc904vBuMUlhoeYmAOyAf5HbhC4DilBiK1nnfHtUzfxu+LZiTj
        FnbHJPztO1zPAGZLsKVeeWoNXwae
X-Google-Smtp-Source: APXvYqzE9njWyLV7S6y6tyJmAdy0ZxCtMRuqKQmviAExm13yHwOoSG+Y9zww+aZTAATPzMPx5kDsiQ==
X-Received: by 2002:a0d:c981:: with SMTP id l123mr27220420ywd.284.1577289763242;
        Wed, 25 Dec 2019 08:02:43 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id d207sm10991578ywa.62.2019.12.25.08.02.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Dec 2019 08:02:41 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id a124so9394080ybg.2
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 08:02:41 -0800 (PST)
X-Received: by 2002:a5b:c43:: with SMTP id d3mr30180493ybr.203.1577289760699;
 Wed, 25 Dec 2019 08:02:40 -0800 (PST)
MIME-Version: 1.0
References: <20191223140322.20013-1-mst@redhat.com> <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
 <CA+FuTSfq5v3-0VYmTG7YFFUqT8uG53eXXhqc8WvVvMbp3s0nvA@mail.gmail.com>
 <CA+FuTScwwajN2ny2w8EBkBQd191Eb1ZsrRhbh3=5eQervArnEA@mail.gmail.com> <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com>
In-Reply-To: <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 Dec 2019 11:02:03 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfrg9eOee6sxR-oSb4sfK2-FbQh7A0y3YJOjf+pTmSjxA@mail.gmail.com>
Message-ID: <CA+FuTSfrg9eOee6sxR-oSb4sfK2-FbQh7A0y3YJOjf+pTmSjxA@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
To:     Alistair Delva <adelva@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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

On Mon, Dec 23, 2019 at 3:22 PM Alistair Delva <adelva@google.com> wrote:
>
> On Mon, Dec 23, 2019 at 12:12 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Mon, Dec 23, 2019 at 2:56 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > 00fffe0ff0 DR7: 0000000000000400
> > > > > Call Trace:
> > > > >  ? preempt_count_add+0x58/0xb0
> > > > >  ? _raw_spin_lock_irqsave+0x36/0x70
> > > > >  ? _raw_spin_unlock_irqrestore+0x1a/0x40
> > > > >  ? __wake_up+0x70/0x190
> > > > >  virtnet_set_features+0x90/0xf0 [virtio_net]
> > > > >  __netdev_update_features+0x271/0x980
> > > > >  ? nlmsg_notify+0x5b/0xa0
> > > > >  dev_disable_lro+0x2b/0x190
> > > > >  ? inet_netconf_notify_devconf+0xe2/0x120
> > > > >  devinet_sysctl_forward+0x176/0x1e0
> > > > >  proc_sys_call_handler+0x1f0/0x250
> > > > >  proc_sys_write+0xf/0x20
> > > > >  __vfs_write+0x3e/0x190
> > > > >  ? __sb_start_write+0x6d/0xd0
> > > > >  vfs_write+0xd3/0x190
> > > > >  ksys_write+0x68/0xd0
> > > > >  __ia32_sys_write+0x14/0x20
> > > > >  do_fast_syscall_32+0x86/0xe0
> > > > >  entry_SYSENTER_compat+0x7c/0x8e
> > > > >
> > > > > A similar crash will likely trigger when enabling XDP.
> > > > >
> > > > > Reported-by: Alistair Delva <adelva@google.com>
> > > > > Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > > > Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
> > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > ---
> > > > >
> > > > > Lightly tested.
> > > > >
> > > > > Alistair, could you please test and confirm that this resolves the
> > > > > crash for you?
> > > >
> > > > This patch doesn't work. The reason is that NETIF_F_LRO is also turned
> > > > on by TSO4/TSO6, which your patch didn't check for. So it ends up
> > > > going through the same path and crashing in the same way.
> > > >
> > > >         if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > >             virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > >                 dev->features |= NETIF_F_LRO;
> > > >
> > > > It sounds like this patch is fixing something slightly differently to
> > > > my patch fixed. virtnet_set_features() doesn't care about
> > > > GUEST_OFFLOADS, it only tests against NETIF_F_LRO. Even if "offloads"
> > > > is zero, it will call virtnet_set_guest_offloads(), which triggers the
> > > > crash.
> > >
> > >
> > > Interesting. It's surprising that it is trying to configure a flag
> > > that is not configurable, i.e., absent from dev->hw_features
> > > after Michael's change.
> > >
> > > > So either we need to ensure NETIF_F_LRO is never set, or
> > >
> > > LRO might be available, just not configurable. Indeed this was what I
> > > observed in the past.
> >
> > dev_disable_lro expects that NETIF_F_LRO is always configurable. Which
> > I guess is a reasonable assumption, just not necessarily the case in
> > virtio_net.
> >
> > So I think we need both patches. Correctly mark the feature as fixed
> > by removing from dev->hw_features and also ignore the request from
> > dev_disable_lro, which does not check for this.
>
> Something like this maybe:
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..0556f42b0fb5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device *dev,
>         u64 offloads;
>         int err;
>
> +       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> +               return 0;
> +
>         if ((dev->features ^ features) & NETIF_F_LRO) {
>                 if (vi->xdp_queue_pairs)
>                         return -EBUSY;
> @@ -2971,6 +2974,15 @@ static int virtnet_validate(struct virtio_device *vdev)
>         if (!virtnet_validate_features(vdev))
>                 return -EINVAL;
>
> +       /* VIRTIO_NET_F_CTRL_GUEST_OFFLOADS does not work without
> +        * VIRTIO_NET_F_CTRL_VQ. However the virtio spec does not
> +        * specify that VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends
> +        * on VIRTIO_NET_F_CTRL_VQ so devices can set the later but
> +        * not the former.
> +        */
> +       if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> +               __virtio_clear_bit(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
> +
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
>                 int mtu = virtio_cread16(vdev,
>                                          offsetof(struct virtio_net_config,

I think we need three separate patches.

- disable guest offloads if VQ is absent
- remove LRO from hw_features if guest offloads are absent

This should fix the ethtool path.  But there is a separate path to
disable LRO through dev_disable_lro (from bond enslave, xdp install,
sysctl -n net.ipv.ip_forward=1, ..) that assumes LRO is always
configurable. So we cannot work around needing a patch to
virtset_set_features.

After a long detour, I think your original submission is fine for
that.

Perhaps with a comment in the commit that it is needed even
if the feature is absent from hw_features for dev_disable_lro.
