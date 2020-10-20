Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84CA293EB1
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408104AbgJTO3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:29:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408056AbgJTO3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 10:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603204182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6tHkoMwRyczlYLoN6tbu8ZV93hRsh5e+vVvwIoEmfQ=;
        b=XBwVaOYZhI4omg9Zzx7JpftKoR9yi8WIeq5f6OmgQFOhnolE2i/j5C6yWuOX+085dLKP1W
        DztIE07g1eEPvaJeNoFFemXDg1XTxvbXbC7lciz04g21UaoSWHH1CCORACyIeXHcP8lEqP
        h6ZBMVzxGjEcOI7uCt4Ic6QgGVJmcaI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-XsAfL8auPAGUgR7BMk0X1g-1; Tue, 20 Oct 2020 10:29:41 -0400
X-MC-Unique: XsAfL8auPAGUgR7BMk0X1g-1
Received: by mail-wm1-f71.google.com with SMTP id r7so459430wmr.5
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 07:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=C6tHkoMwRyczlYLoN6tbu8ZV93hRsh5e+vVvwIoEmfQ=;
        b=RC6CID28UmTMVVxHHHOmTmMrxSnv1wSz4FSsEmAPwnzu946+HYsjcDt59KzSDDbF15
         4tc4sXOEwL4+VkfRJdxJvdJLzCUEjpzlX6cFRDtkHfkV5xSpzhpzZ3m9qcoRwqnmEMdD
         jcSOp4S0xQ2qGmcldLwv8eDwx4fydeBEOkl8X641xZhluWyuHqefXfIVDafYVqoWpPYC
         iA67o/NSOtFlH79Rz2onMaTYbUKQ9NuZQOsjkWIJ6955CQNCOM1G/Po2wgrO/YYozVnQ
         7ks6zn5Qa+FXHyhDx6pfwuHH8aFOs1EwhRrUOkMLogvEwtQb69IVAQ4+4eB+lrdGkuJE
         /4ug==
X-Gm-Message-State: AOAM5309nG1dmkfSvwpglT3RKaa/PS80te0ioumzCiYNLHREqEPJWzm4
        08aEfdryQP1Suomb7lYNULE7vWh4WfMD83iK+OQnXZ/08E8utQKaqlXXkxmgoocZ/eV33shf5h1
        V44CM8qz4K0zDFmY0
X-Received: by 2002:a05:600c:210f:: with SMTP id u15mr3381502wml.53.1603204179492;
        Tue, 20 Oct 2020 07:29:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwe+ftxaspmxxnPpzcvDfDhSCdYyXL92Ygf85TD1u3vZHXHOFcofDkD7EwmcXMp+xtWl9ZKCw==
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr2364091wmj.167.1603193788779;
        Tue, 20 Oct 2020 04:36:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-219-234.inter.net.il. [80.230.219.234])
        by smtp.gmail.com with ESMTPSA id t6sm2774785wre.30.2020.10.20.04.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 04:36:27 -0700 (PDT)
Date:   Tue, 20 Oct 2020 07:36:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net v2] Revert "virtio-net: ethtool configurable RXCSUM"
Message-ID: <20201020073540-mutt-send-email-mst@kernel.org>
References: <20201018103122.454967-1-mst@redhat.com>
 <a061697d-844d-bb98-7009-69760fe9918c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a061697d-844d-bb98-7009-69760fe9918c@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 02:13:06PM +0800, Jason Wang wrote:
> 
> On 2020/10/20 上午1:32, Michael S. Tsirkin wrote:
> > This reverts commit 3618ad2a7c0e78e4258386394d5d5f92a3dbccf8.
> > 
> > When the device does not have a control vq (e.g. when using a
> > version of QEMU based on upstream v0.10 or older, or when specifying
> > ctrl_vq=off,ctrl_rx=off,ctrl_vlan=off,ctrl_rx_extra=off,ctrl_mac_addr=off
> > for the device on the QEMU command line), that commit causes a crash:
> > 
> > [   72.229171] kernel BUG at drivers/net/virtio_net.c:1667!
> > [   72.230266] invalid opcode: 0000 [#1] PREEMPT SMP
> > [   72.231172] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc8-02934-g3618ad2a7c0e7 #1
> > [   72.231172] EIP: virtnet_send_command+0x120/0x140
> > [   72.231172] Code: 00 0f 94 c0 8b 7d f0 65 33 3d 14 00 00 00 75 1c 8d 65 f4 5b 5e 5f 5d c3 66 90 be 01 00 00 00 e9 6e ff ff ff 8d b6 00
> > +00 00 00 <0f> 0b e8 d9 bb 82 00 eb 17 8d b4 26 00 00 00 00 8d b4 26 00 00 00
> > [   72.231172] EAX: 0000000d EBX: f72895c0 ECX: 00000017 EDX: 00000011
> > [   72.231172] ESI: f7197800 EDI: ed69bd00 EBP: ed69bcf4 ESP: ed69bc98
> > [   72.231172] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> > [   72.231172] CR0: 80050033 CR2: 00000000 CR3: 02c84000 CR4: 000406f0
> > [   72.231172] Call Trace:
> > [   72.231172]  ? __virt_addr_valid+0x45/0x60
> > [   72.231172]  ? ___cache_free+0x51f/0x760
> > [   72.231172]  ? kobject_uevent_env+0xf4/0x560
> > [   72.231172]  virtnet_set_guest_offloads+0x4d/0x80
> > [   72.231172]  virtnet_set_features+0x85/0x120
> > [   72.231172]  ? virtnet_set_guest_offloads+0x80/0x80
> > [   72.231172]  __netdev_update_features+0x27a/0x8e0
> > [   72.231172]  ? kobject_uevent+0xa/0x20
> > [   72.231172]  ? netdev_register_kobject+0x12c/0x160
> > [   72.231172]  register_netdevice+0x4fe/0x740
> > [   72.231172]  register_netdev+0x1c/0x40
> > [   72.231172]  virtnet_probe+0x728/0xb60
> > [   72.231172]  ? _raw_spin_unlock+0x1d/0x40
> > [   72.231172]  ? virtio_vdpa_get_status+0x1c/0x20
> > [   72.231172]  virtio_dev_probe+0x1c6/0x271
> > [   72.231172]  really_probe+0x195/0x2e0
> > [   72.231172]  driver_probe_device+0x26/0x60
> > [   72.231172]  device_driver_attach+0x49/0x60
> > [   72.231172]  __driver_attach+0x46/0xc0
> > [   72.231172]  ? device_driver_attach+0x60/0x60
> > [   72.231172]  bus_add_driver+0x197/0x1c0
> > [   72.231172]  driver_register+0x66/0xc0
> > [   72.231172]  register_virtio_driver+0x1b/0x40
> > [   72.231172]  virtio_net_driver_init+0x61/0x86
> > [   72.231172]  ? veth_init+0x14/0x14
> > [   72.231172]  do_one_initcall+0x76/0x2e4
> > [   72.231172]  ? rdinit_setup+0x2a/0x2a
> > [   72.231172]  do_initcalls+0xb2/0xd5
> > [   72.231172]  kernel_init_freeable+0x14f/0x179
> > [   72.231172]  ? rest_init+0x100/0x100
> > [   72.231172]  kernel_init+0xd/0xe0
> > [   72.231172]  ret_from_fork+0x1c/0x30
> > [   72.231172] Modules linked in:
> > [   72.269563] ---[ end trace a6ebc4afea0e6cb1 ]---
> > 
> > The reason is that virtnet_set_features now calls virtnet_set_guest_offloads
> > unconditionally, it used to only call it when there is something
> > to configure.
> > 
> > If device does not have a control vq, everything breaks.
> > 
> > Looking at this some more, I noticed that it's not really checking the
> > hardware too much. E.g.
> > 
> >          if ((dev->features ^ features) & NETIF_F_LRO) {
> >                  if (features & NETIF_F_LRO)
> >                          offloads |= GUEST_OFFLOAD_LRO_MASK &
> >                                      vi->guest_offloads_capable;
> >                  else
> >                          offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> >          }
> > 
> > and
> > 
> >                                  (1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
> >                                  (1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> >                                  (1ULL << VIRTIO_NET_F_GUEST_UFO))
> > 
> > But there's no guarantee that e.g. VIRTIO_NET_F_GUEST_TSO6 is set.
> > 
> > If it isn't command should not send it.
> > 
> > Further
> > 
> > static int virtnet_set_features(struct net_device *dev,
> >                                  netdev_features_t features)
> > {
> >          struct virtnet_info *vi = netdev_priv(dev);
> >          u64 offloads = vi->guest_offloads;
> > 
> > seems wrong since guest_offloads is zero initialized,
> 
> 
> I'm not sure I get here.
> 
> Did you mean vi->guest_offloads?
> 
> We initialize it during probe
> 
>     for (i = 0; i < ARRAY_SIZE(guest_offloads); i++)
>         if (virtio_has_feature(vi->vdev, guest_offloads[i]))
>             set_bit(guest_offloads[i], &vi->guest_offloads);
> 

Good point, will drop this part.


> > it does not reflect the state after reset which comes from
> > the features.
> > 
> > Revert the original commit for now.
> > 
> > Cc: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Fixes: 3618ad2a7c0e7 ("virtio-net: ethtool configurable RXCSUM")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > changes from v1:
> > 	- clarify how to reproduce the bug in the log
> > 
> > 
> >   drivers/net/virtio_net.c | 50 +++++++++++-----------------------------
> >   1 file changed, 13 insertions(+), 37 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index d2d2c4a53cf2..21b71148c532 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -68,8 +68,6 @@ static const unsigned long guest_offloads[] = {
> >   				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
> >   				(1ULL << VIRTIO_NET_F_GUEST_UFO))
> > -#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> > -
> >   struct virtnet_stat_desc {
> >   	char desc[ETH_GSTRING_LEN];
> >   	size_t offset;
> > @@ -2524,48 +2522,29 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
> >   	return 0;
> >   }
> > -static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> > -					      netdev_features_t features)
> > -{
> > -	/* If Rx checksum is disabled, LRO should also be disabled. */
> > -	if (!(features & NETIF_F_RXCSUM))
> > -		features &= ~NETIF_F_LRO;
> > -
> > -	return features;
> > -}
> > -
> >   static int virtnet_set_features(struct net_device *dev,
> >   				netdev_features_t features)
> >   {
> >   	struct virtnet_info *vi = netdev_priv(dev);
> > -	u64 offloads = vi->guest_offloads;
> > +	u64 offloads;
> >   	int err;
> > -	/* Don't allow configuration while XDP is active. */
> > -	if (vi->xdp_queue_pairs)
> > -		return -EBUSY;
> > -
> >   	if ((dev->features ^ features) & NETIF_F_LRO) {
> > +		if (vi->xdp_queue_pairs)
> > +			return -EBUSY;
> > +
> >   		if (features & NETIF_F_LRO)
> > -			offloads |= GUEST_OFFLOAD_LRO_MASK &
> > -				    vi->guest_offloads_capable;
> > +			offloads = vi->guest_offloads_capable;
> >   		else
> > -			offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> > +			offloads = vi->guest_offloads_capable &
> > +				   ~GUEST_OFFLOAD_LRO_MASK;
> > +
> > +		err = virtnet_set_guest_offloads(vi, offloads);
> > +		if (err)
> > +			return err;
> > +		vi->guest_offloads = offloads;
> >   	}
> > -	if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> > -		if (features & NETIF_F_RXCSUM)
> > -			offloads |= GUEST_OFFLOAD_CSUM_MASK &
> > -				    vi->guest_offloads_capable;
> > -		else
> > -			offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
> > -	}
> > -
> > -	err = virtnet_set_guest_offloads(vi, offloads);
> > -	if (err)
> > -		return err;
> > -
> > -	vi->guest_offloads = offloads;
> >   	return 0;
> >   }
> > @@ -2584,7 +2563,6 @@ static const struct net_device_ops virtnet_netdev = {
> >   	.ndo_features_check	= passthru_features_check,
> >   	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
> >   	.ndo_set_features	= virtnet_set_features,
> > -	.ndo_fix_features	= virtnet_fix_features,
> >   };
> >   static void virtnet_config_changed_work(struct work_struct *work)
> > @@ -3035,10 +3013,8 @@ static int virtnet_probe(struct virtio_device *vdev)
> >   	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> >   	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> >   		dev->features |= NETIF_F_LRO;
> > -	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> > -		dev->hw_features |= NETIF_F_RXCSUM;
> > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> >   		dev->hw_features |= NETIF_F_LRO;
> > -	}
> >   	dev->vlan_features = dev->features;

