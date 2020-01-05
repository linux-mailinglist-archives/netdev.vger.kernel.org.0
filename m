Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2CF1307A4
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 12:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgAELQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 06:16:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56481 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725897AbgAELQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 06:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578222999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GGlSSbeC4Kbhr61r3dRU9qa1eVoeraY/lQ162mo0Jg=;
        b=WtHbvrcnb7uj/nbsnYYHVHjmVdQ9yrNOKlV0Kq+ZP3LErUs8VCq1UHFdIiQetc5KKxHxgi
        jWDusYJ0aPYIxL8tsbZnmOwbi2QcMcQLy+6OeVfLRd8x8FLY3FPbxeD8m5DGjL0qghYxKa
        UUwyRYgGOifxfwJPRoJoeUAUBS0Ry80=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-GqMQVPdVM_OGZW18jZ7XHQ-1; Sun, 05 Jan 2020 06:16:37 -0500
X-MC-Unique: GqMQVPdVM_OGZW18jZ7XHQ-1
Received: by mail-qk1-f199.google.com with SMTP id s9so14659682qkg.21
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 03:16:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+GGlSSbeC4Kbhr61r3dRU9qa1eVoeraY/lQ162mo0Jg=;
        b=X2NCGtolgTUY/VmdvKakntD76kA2M5lXSNhJLONvWeVU87auqaYuYsZcYeKvMu8MyR
         BcCNwTGs4El1Au8Ngyc6dxnnvAJnl6UPSF4Pq9G/jTxoyP7HXzkTy5wlyvl2f8Jc8pKl
         IwdbEhRbyE8FozdEoTonJSeI8UBj6wlhWyAxr6jZ1uJh4GT9NUlt70p6scqGsWgY+aAL
         dQ0ZNqfGcIFeG0qmNNwcNMZKVGaOamUOP0P3voWq+xAfh3CPlHZrHUkCeaoFUMBNt6qa
         5VZTCLAH8Gz5XqbevB4Ks3hd/4jESlo95+3ZsclIQf7wDWlPXq8gxU7SewqYea9lxB+H
         ZwLA==
X-Gm-Message-State: APjAAAWR+N1cJthUuqbrw/8lGBY2J6r1VPJIicLVb/cORUUt+oEhrws/
        TrN1DdPSiEGjpWu7bBUyFs9eNuxmsOxpWzaA4n6wwXkcxsj2oE8sfMIkwSbMoVQlPfcTxpes0Lh
        ITBYe0ylBLkIs+gXu
X-Received: by 2002:a37:68d5:: with SMTP id d204mr78760686qkc.171.1578222997286;
        Sun, 05 Jan 2020 03:16:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPMMvBqmBN4Gem7zky32ejHiDxpzbcW8rhw1eSZVpEgSTWT6x4f+E8PIcPfp2MrIjZ3t+TIA==
X-Received: by 2002:a37:68d5:: with SMTP id d204mr78760671qkc.171.1578222996963;
        Sun, 05 Jan 2020 03:16:36 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id t7sm19125131qkm.136.2020.01.05.03.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 03:16:36 -0800 (PST)
Date:   Sun, 5 Jan 2020 06:16:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alistair Delva <adelva@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
Message-ID: <20200105061532-mutt-send-email-mst@kernel.org>
References: <20191223140322.20013-1-mst@redhat.com>
 <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
 <CA+FuTSfq5v3-0VYmTG7YFFUqT8uG53eXXhqc8WvVvMbp3s0nvA@mail.gmail.com>
 <CA+FuTScwwajN2ny2w8EBkBQd191Eb1ZsrRhbh3=5eQervArnEA@mail.gmail.com>
 <CANDihLFv+DJYOD1m_Z3CKuxoXG-z4zPy_Tc2eoggq1KRo+GeWw@mail.gmail.com>
 <ea5131fc-cda6-c773-73fc-c862be6ecb7b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea5131fc-cda6-c773-73fc-c862be6ecb7b@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 10:49:13AM +0800, Jason Wang wrote:
> 
> On 2019/12/24 上午4:21, Alistair Delva wrote:
> > On Mon, Dec 23, 2019 at 12:12 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > > On Mon, Dec 23, 2019 at 2:56 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > 00fffe0ff0 DR7: 0000000000000400
> > > > > > Call Trace:
> > > > > >   ? preempt_count_add+0x58/0xb0
> > > > > >   ? _raw_spin_lock_irqsave+0x36/0x70
> > > > > >   ? _raw_spin_unlock_irqrestore+0x1a/0x40
> > > > > >   ? __wake_up+0x70/0x190
> > > > > >   virtnet_set_features+0x90/0xf0 [virtio_net]
> > > > > >   __netdev_update_features+0x271/0x980
> > > > > >   ? nlmsg_notify+0x5b/0xa0
> > > > > >   dev_disable_lro+0x2b/0x190
> > > > > >   ? inet_netconf_notify_devconf+0xe2/0x120
> > > > > >   devinet_sysctl_forward+0x176/0x1e0
> > > > > >   proc_sys_call_handler+0x1f0/0x250
> > > > > >   proc_sys_write+0xf/0x20
> > > > > >   __vfs_write+0x3e/0x190
> > > > > >   ? __sb_start_write+0x6d/0xd0
> > > > > >   vfs_write+0xd3/0x190
> > > > > >   ksys_write+0x68/0xd0
> > > > > >   __ia32_sys_write+0x14/0x20
> > > > > >   do_fast_syscall_32+0x86/0xe0
> > > > > >   entry_SYSENTER_compat+0x7c/0x8e
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
> > > > > This patch doesn't work. The reason is that NETIF_F_LRO is also turned
> > > > > on by TSO4/TSO6, which your patch didn't check for. So it ends up
> > > > > going through the same path and crashing in the same way.
> > > > > 
> > > > >          if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > > >              virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> > > > >                  dev->features |= NETIF_F_LRO;
> > > > > 
> > > > > It sounds like this patch is fixing something slightly differently to
> > > > > my patch fixed. virtnet_set_features() doesn't care about
> > > > > GUEST_OFFLOADS, it only tests against NETIF_F_LRO. Even if "offloads"
> > > > > is zero, it will call virtnet_set_guest_offloads(), which triggers the
> > > > > crash.
> > > > 
> > > > Interesting. It's surprising that it is trying to configure a flag
> > > > that is not configurable, i.e., absent from dev->hw_features
> > > > after Michael's change.
> > > > 
> > > > > So either we need to ensure NETIF_F_LRO is never set, or
> > > > LRO might be available, just not configurable. Indeed this was what I
> > > > observed in the past.
> > > dev_disable_lro expects that NETIF_F_LRO is always configurable. Which
> > > I guess is a reasonable assumption, just not necessarily the case in
> > > virtio_net.
> > > 
> > > So I think we need both patches. Correctly mark the feature as fixed
> > > by removing from dev->hw_features and also ignore the request from
> > > dev_disable_lro, which does not check for this.
> > Something like this maybe:
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4d7d5434cc5d..0556f42b0fb5 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device *dev,
> >          u64 offloads;
> >          int err;
> > 
> > +       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> > +               return 0;
> > +
> >          if ((dev->features ^ features) & NETIF_F_LRO) {
> >                  if (vi->xdp_queue_pairs)
> >                          return -EBUSY;
> > @@ -2971,6 +2974,15 @@ static int virtnet_validate(struct virtio_device *vdev)
> >          if (!virtnet_validate_features(vdev))
> >                  return -EINVAL;
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
> >          if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
> >                  int mtu = virtio_cread16(vdev,
> >                                           offsetof(struct virtio_net_config,
> > 
> 
> We check feature dependency and fail the probe in
> virtnet_validate_features().
> 
> Is it more straightforward to fail the probe there when CTRL_GUEST_OFFLOADS
> was set but CTRL_VQ wasn't?
> 
> Thanks

Expanding on what the comment above says, we can't fail probe
in this configuration without breaking the driver for
spec compliant devices.

-- 
MST

