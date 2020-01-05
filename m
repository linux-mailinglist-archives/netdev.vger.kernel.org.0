Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A878130830
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 14:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAENOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 08:14:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47216 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726029AbgAENOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 08:14:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578230040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fk09R+kHO6037bNMYCslAmNwggGNiJ8jA8PAG3EtmFs=;
        b=R7wNr+I724MMHWTzLsyA98YshUdJMxO4fTkYS3bFYpbl8rw2ePChvbqfBIlfgn3lEdq4nf
        9FP0dQMNB34muCwunWw627XdthjYBHrqh3PFqO3RnHZ67xHnXOELngtCGc8fOuX2yk6Ghb
        702XNZfX6EDfAmFgn1pItco7qdqefjQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-UKJ4iEbgP5y-paPCd06Kzw-1; Sun, 05 Jan 2020 08:13:58 -0500
X-MC-Unique: UKJ4iEbgP5y-paPCd06Kzw-1
Received: by mail-qt1-f200.google.com with SMTP id r9so8068951qtc.4
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 05:13:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fk09R+kHO6037bNMYCslAmNwggGNiJ8jA8PAG3EtmFs=;
        b=C1K2IAhmqAA7oR+BYQgBU5v8G5mg7S3VGAtZZLWYaRRPC2d7j1LwN0s4Skm1QmuhM2
         zgGmNgzYbZ0RMsr3HprcZ6dhq/1+O5+4zdj0sh7URvsKLsXkYDIkc3E6LJogmffoge3l
         szuw/lPrtJyOt1RRD4kJ0iLWNUCkp6zDIKR/UNZLkvS13oGCb2DqQsiALP7fVpX8Hl+n
         Xf0mU276X/JQvQ8szjRcFVk+X9lISJSZVzP/erTTHkO75AIGRXILSjaaqm82coOrAreB
         pqVDD/DWG3uBjLfiUD2wk2+Lw76o2FHld4/6rdvPSzYVOt/1XZv90qly7sIjk/47s71Z
         c03Q==
X-Gm-Message-State: APjAAAUpl2qA8yUP+QmFO2EEKF93wALxuRw+MVj3up7NV+V5cNRZiipw
        PShTfaawZReZEXzQLbFdYyyES7a7n6ir7O/z0W35vbTKWhrCfJdFvwJK1XUPI8nSr0X+P0p+d+Z
        yB5siMHWwe+h7Ckjf
X-Received: by 2002:ae9:f506:: with SMTP id o6mr78042889qkg.41.1578230038399;
        Sun, 05 Jan 2020 05:13:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoXz/f/iqq3z8FG3FiucFEok/9LI9Kxgvo8Jiz3Je6GuMniFX8+AsyEWxkXA1oSkfBFTLFwA==
X-Received: by 2002:ae9:f506:: with SMTP id o6mr78042873qkg.41.1578230038128;
        Sun, 05 Jan 2020 05:13:58 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id g21sm19193743qkl.116.2020.01.05.05.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 05:13:57 -0800 (PST)
Date:   Sun, 5 Jan 2020 08:13:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alistair Delva <adelva@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
Message-ID: <20200105081312-mutt-send-email-mst@kernel.org>
References: <20191223140322.20013-1-mst@redhat.com>
 <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
 <CA+FuTSfq5v3-0VYmTG7YFFUqT8uG53eXXhqc8WvVvMbp3s0nvA@mail.gmail.com>
 <CA+FuTScwwajN2ny2w8EBkBQd191Eb1ZsrRhbh3=5eQervArnEA@mail.gmail.com>
 <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 12:21:56PM -0800, Alistair Delva wrote:
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

Should this return error here?

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

This is just my

    virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ

right?

