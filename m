Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5C01BA672
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgD0OcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:32:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39226 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727982AbgD0OcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587997924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cf6Cs2PEOytlk0F2uGTl55ZSvGzk8/G/7WE1a3ciQp0=;
        b=KOJ43tuDVGH9tAoeN0I91LUHVjv2fbNsmnOIXp0wdr/GKNQU6OMhr/d9aTw3WLAhetbCS/
        HO8peWM9EvLRJSwt4zXbCBHDM18cZVFnJ/K70ETv1iHnMFN3chJHKfsRzc7KtqaLqGQqUD
        ciL2kzgHdx+pn2e3fLO79BzRuvAHLe4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-W2rVupTBPi-2a_wZa_moGQ-1; Mon, 27 Apr 2020 10:32:02 -0400
X-MC-Unique: W2rVupTBPi-2a_wZa_moGQ-1
Received: by mail-wm1-f70.google.com with SMTP id w2so5597386wmc.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cf6Cs2PEOytlk0F2uGTl55ZSvGzk8/G/7WE1a3ciQp0=;
        b=VGp5oMO06MN0stOXTDAcd53CdueBp2lG5egWovF5f+wedUaRn24YUAA0aAGA7ZVzOV
         t2qU8C5h6IPisrH0OZu1NchrCf5jEvm6pfwI+dOcfUpu5EqbViWXbRFKfAMOqeaBsiAu
         ToHb9nLHgJWJDfLeQbKP8l/HnCkiBT8LguMv3VIvEfwPlItXmax+K/rngWZ7fLj1C9cT
         4veJxzVJm1d811W4cLj4neJOZGiyWsz0On3plSHv6F4Wn9RolD0ZyxCN52UEwIW6AeyT
         hTVs4HD6reyY6x844L0i4C+X6BXnT/d8hEntsUNI7dkFiEDkUve9vjkgPONAExrnrpWV
         hlmQ==
X-Gm-Message-State: AGi0PubBJ5TAStQHUTDpAbDUFGIuiO6OGVp32Peobsae0C0Yb66txLhY
        fzllKVUmbUkKng/QFd2bK94rzaD0kBEao30asQQXHThdNRMKSWJWEaORbrdYGMX9Dk3cupRPsd4
        Oj8IM1J+PKg+05ZW7
X-Received: by 2002:a1c:4b12:: with SMTP id y18mr27319009wma.149.1587997921468;
        Mon, 27 Apr 2020 07:32:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ3yRKpFpNCFurBKYh3n2YOBs/ZiNJj3mnUr/OngVCgapTti55XiOSO9MN16q48Z0I2RmPu4A==
X-Received: by 2002:a1c:4b12:: with SMTP id y18mr27318989wma.149.1587997921191;
        Mon, 27 Apr 2020 07:32:01 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id r18sm18328241wrj.70.2020.04.27.07.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 07:32:00 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:31:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <20200427102828-mutt-send-email-mst@kernel.org>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427142518.uwssa6dtasrp3bfc@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 04:25:18PM +0200, Stefano Garzarella wrote:
> Hi David, Michael, Stefan,
> I'm restarting to work on this topic since Kata guys are interested to
> have that, especially on the guest side.
> 
> While working on the v2 I had few doubts, and I'd like to have your
> suggestions:
> 
>  1. netns assigned to the device inside the guest
> 
>    Currently I assigned this device to 'init_net'. Maybe it is better
>    if we allow the user to decide which netns assign to the device
>    or to disable this new feature to have the same behavior as before
>    (host reachable from any netns).
>    I think we can handle this in the vsock core and not in the single
>    transports.
> 
>    The simplest way that I found, is to add a new
>    IOCTL_VM_SOCKETS_ASSIGN_G2H_NETNS to /dev/vsock to enable the feature
>    and assign the device to the same netns of the process that do the
>    ioctl(), but I'm not sure it is clean enough.
> 
>    Maybe it is better to add new rtnetlink messages, but I'm not sure if
>    it is feasible since we don't have a netdev device.
> 
>    What do you suggest?

Maybe /dev/vsock-netns here too, like in the host?


> 
>  2. netns assigned in the host
> 
>     As Michael suggested, I added a new /dev/vhost-vsock-netns to allow
>     userspace application to use this new feature, leaving to
>     /dev/vhost-vsock the previous behavior (guest reachable from any
>     netns).
> 
>     I like this approach, but I had these doubts:
> 
>     - I need to allocate a new minor for that device (e.g.
>       VHOST_VSOCK_NETNS_MINOR) or is there an alternative way that I can
>       use?

Not that I see. I agree it's a bit annoying. I'll think about it a bit.

>     - It is vhost-vsock specific, should we provide something handled in
>       the vsock core, maybe centralizing the CID allocation and adding a
>       new IOCTL or rtnetlink message like for the guest side?
>       (maybe it could be a second step, and for now we can continue with
>       the new device)
> 
> 
> Thanks for the help,
> Stefano
> 
> 
> On Thu, Jan 16, 2020 at 06:24:25PM +0100, Stefano Garzarella wrote:
> > RFC -> v1:
> >  * added 'netns' module param to vsock.ko to enable the
> >    network namespace support (disabled by default)
> >  * added 'vsock_net_eq()' to check the "net" assigned to a socket
> >    only when 'netns' support is enabled
> > 
> > RFC: https://patchwork.ozlabs.org/cover/1202235/
> > 
> > Now that we have multi-transport upstream, I started to take a look to
> > support network namespace in vsock.
> > 
> > As we partially discussed in the multi-transport proposal [1], it could
> > be nice to support network namespace in vsock to reach the following
> > goals:
> > - isolate host applications from guest applications using the same ports
> >   with CID_ANY
> > - assign the same CID of VMs running in different network namespaces
> > - partition VMs between VMMs or at finer granularity
> > 
> > This new feature is disabled by default, because it changes vsock's
> > behavior with network namespaces and could break existing applications.
> > It can be enabled with the new 'netns' module parameter of vsock.ko.
> > 
> > This implementation provides the following behavior:
> > - packets received from the host (received by G2H transports) are
> >   assigned to the default netns (init_net)
> > - packets received from the guest (received by H2G - vhost-vsock) are
> >   assigned to the netns of the process that opens /dev/vhost-vsock
> >   (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
> >     - for vmci I need some suggestions, because I don't know how to do
> >       and test the same in the vmci driver, for now vmci uses the
> >       init_net
> > - loopback packets are exchanged only in the same netns
> > 
> > I tested the series in this way:
> > l0_host$ qemu-system-x86_64 -m 4G -M accel=kvm -smp 4 \
> >             -drive file=/tmp/vsockvm0.img,if=virtio --nographic \
> >             -device vhost-vsock-pci,guest-cid=3
> > 
> > l1_vm$ echo 1 > /sys/module/vsock/parameters/netns
> > 
> > l1_vm$ ip netns add ns1
> > l1_vm$ ip netns add ns2
> >  # same CID on different netns
> > l1_vm$ ip netns exec ns1 qemu-system-x86_64 -m 1G -M accel=kvm -smp 2 \
> >             -drive file=/tmp/vsockvm1.img,if=virtio --nographic \
> >             -device vhost-vsock-pci,guest-cid=4
> > l1_vm$ ip netns exec ns2 qemu-system-x86_64 -m 1G -M accel=kvm -smp 2 \
> >             -drive file=/tmp/vsockvm2.img,if=virtio --nographic \
> >             -device vhost-vsock-pci,guest-cid=4
> > 
> >  # all iperf3 listen on CID_ANY and port 5201, but in different netns
> > l1_vm$ ./iperf3 --vsock -s # connection from l0 or guests started
> >                            # on default netns (init_net)
> > l1_vm$ ip netns exec ns1 ./iperf3 --vsock -s
> > l1_vm$ ip netns exec ns1 ./iperf3 --vsock -s
> > 
> > l0_host$ ./iperf3 --vsock -c 3
> > l2_vm1$ ./iperf3 --vsock -c 2
> > l2_vm2$ ./iperf3 --vsock -c 2
> > 
> > [1] https://www.spinics.net/lists/netdev/msg575792.html
> > 
> > Stefano Garzarella (3):
> >   vsock: add network namespace support
> >   vsock/virtio_transport_common: handle netns of received packets
> >   vhost/vsock: use netns of process that opens the vhost-vsock device
> > 
> >  drivers/vhost/vsock.c                   | 29 ++++++++++++-----
> >  include/linux/virtio_vsock.h            |  2 ++
> >  include/net/af_vsock.h                  |  7 +++--
> >  net/vmw_vsock/af_vsock.c                | 41 +++++++++++++++++++------
> >  net/vmw_vsock/hyperv_transport.c        |  5 +--
> >  net/vmw_vsock/virtio_transport.c        |  2 ++
> >  net/vmw_vsock/virtio_transport_common.c | 12 ++++++--
> >  net/vmw_vsock/vmci_transport.c          |  5 +--
> >  8 files changed, 78 insertions(+), 25 deletions(-)
> > 
> > -- 
> > 2.24.1
> > 

