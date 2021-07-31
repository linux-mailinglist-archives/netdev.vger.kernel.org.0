Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D293DC90B
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 02:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhGaXyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 19:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhGaXys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 19:54:48 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266B9C06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 16:54:41 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x7so18597843ljn.10
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 16:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=prestigetransportation-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H7WRtSYTQWi1zORwboUP2iwxIXnZ2B4naYTrarA/HAI=;
        b=A72FjSoBezw6awyXV1Q1LaGz4+ViuLeZr8/rVaXZLfI4cwti3gFMrJ5UbNUs/HWrwY
         9uvRS0zP/Qi+uLeADrpVhovnt2YB02NKTTHsqTA8aAh3ubAWxhElUj45FJI18jfhuY53
         yO+F7O11niqTBXWm0lJYkgvfdgzwCNpxfW8OIVxMKP0bBo1E3zbWtYtf1yarkb7Y20X/
         y4UeI1xzVcF0IF76IHv5OKqNTTi819jCUZ98uG8G60aGRPHTpIg7D8/yn1YTX4h9ceb9
         sCDDCCEX88x2T3KtdeTO5HIoW2PlTl28Go5sejZ4sg9QphUaMbGnFd2MVFkoGfPfrj3S
         HhhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H7WRtSYTQWi1zORwboUP2iwxIXnZ2B4naYTrarA/HAI=;
        b=r6SpgPN1WMYYphXTzwBG0YJjV4u58lnoAaTTGz7LuUVGQatWnfIsO5GIGQmq5RqrR/
         SBynWnzK2wXNMIVKv48SJrDorkETHO1+YZbgciCWt6pttd34WxttG6U2xTV0Kn23KNMA
         fUwxuUblpJ81V9UouncCGU3YsB3PxLHD5BOCqxvoW6+/PuXXpvAOC6jTGUjZ3fl/OjMp
         zAmTKhppr/q9xMdd73WVD0B/kmBY+1zIdwKCBIJUoKvxmOlGS+G6UrGIqHxsQ9d8Eeii
         6Npf1oszIHcIJ48fgL0iJyEFCD1ATEJGZGMqQY0R092y+I8a49ef+eGxess0WYZ2C4YA
         Spyg==
X-Gm-Message-State: AOAM53351WIVRXKDt9vnCIdlQ4HPen/gmzlXA8cA6jIrmMoEMjv7emfz
        OvB+q8qCoTscqMF3uH0his73iXptR4wjAAndT5Lh2A==
X-Google-Smtp-Source: ABdhPJzvWzc5Rv7wn5bYOtX00zOSrR5pi7EbIUR0dhxul+TCGbqnGjN0F2BPZtq+ouB9Gv9bmnhbANkwR6wYuMQV9e0=
X-Received: by 2002:a2e:934f:: with SMTP id m15mr6367894ljh.208.1627775679485;
 Sat, 31 Jul 2021 16:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <CACFia2dwacaVVYD+1uG=CDGaJqdCOSBvZ5FcXp04caecaWAY3w@mail.gmail.com>
 <20210730073029-mutt-send-email-mst@kernel.org> <CACFia2d82tqUrLwpt0fowm3DpD7+HXM9Vcfz56eQ_AkTcWmOEg@mail.gmail.com>
 <20210731165155-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210731165155-mutt-send-email-mst@kernel.org>
From:   Ivan <ivan@prestigetransportation.com>
Date:   Sat, 31 Jul 2021 18:52:22 -0500
Message-ID: <CACFia2f6bMzCkcUWfQu4=R4MNsyUEeG9A2L=5PzieNAhxKwvXg@mail.gmail.com>
Subject: Re: PROBLEM: virtio_net LRO kernel panics
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan <ivan@prestigetransportation.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 3:53 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Jul 30, 2021 at 12:04:18PM -0500, Ivan wrote:
> > On Fri, Jul 30, 2021 at 6:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Thu, Jul 22, 2021 at 06:27:18PM -0500, Ivan wrote:
> > > > Dear Sir,
> > > >
> > > > I've been plagued with kernel panics recently. The problem is easily
> > > > reproducible on any virtual machine that uses the virtio-net driver
> > > > from stock Linux kernel. Simply isuse this command:
> > > >
> > > > echo 1 > /proc/sys/net/ipv4/ip_forward
> > > > ...and the kernel panics.
> > > >
> > > > Is there any way we can possibly fix this?
> > > >
> > > > kernel: ------------[ cut here ]------------
> > > > kernel: netdevice: eth0: failed to disable LRO!
> > > > kernel: WARNING: CPU: 1 PID: 424 at net/core/dev.c:1768
> > > > dev_disable_lro+0x108/0x150
> > > > kernel: Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usbhid
> > > > atkbd libps2 ahci libahci virtio_net ohci_pci net_failover failover
> > > > i8042 serio lpc_ich mfd_core libata ohci_hcd ehci_pci ehci_hcd usbcore
> > > > rng_core i2c_piix4 i2c_core virtio_pci usb_common
> > > > virtio_pci_modern_dev virtio_ring virtio loop unix
> > > > kernel: CPU: 1 PID: 424 Comm: bash Not tainted 5.13.4-gnu.4-NuMini #1
> > > > kernel: Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> > > > VirtualBox 12/01/2006
> > > > kernel: RIP: 0010:dev_disable_lro+0x108/0x150
> > > > kernel: Code: ae 88 74 14 be 25 00 00 00 48 89 df e8 f1 54 ed ff 48 85
> > > > c0 48 0f 44 eb 4c 89 e2 48 89 ee 48 c7 c7 00 c6 ae 88 e8 7a 76 0c 00
> > > > <0f> 0b e9 2d ff ff ff 80 3d e8 70 97 00 00 49 c7 c4 73 bb ae 88 75
> > > > kernel: RSP: 0018:ffffb596c0237d80 EFLAGS: 00010282
> > > > kernel: RAX: 0000000000000000 RBX: ffff9af9c1835000 RCX: ffff9af9fed17538
> > > > kernel: RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9af9fed17530
> > > > kernel: RBP: ffff9af9c1835000 R08: ffffffff88c96ac8 R09: 0000000000004ffb
> > > > kernel: R10: 00000000fffff000 R11: 3fffffffffffffff R12: ffffffff88ac7c3d
> > > > kernel: R13: 0000000000000000 R14: ffffffff88cb2748 R15: ffff9af9c12166c8
> > > > kernel: FS:  00007fd4911b8740(0000) GS:ffff9af9fed00000(0000)
> > > > knlGS:0000000000000000
> > > > kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > kernel: CR2: 0000000000532008 CR3: 000000000115c000 CR4: 00000000000406e0
> > > > kernel: Call Trace:
> > > > kernel:  devinet_sysctl_forward+0x1ac/0x1e0
> > > > kernel:  proc_sys_call_handler+0x127/0x230
> > > > kernel:  new_sync_write+0x114/0x1a0
> > > > kernel:  vfs_write+0x18c/0x220
> > > > kernel:  ksys_write+0x5a/0xd0
> > > > kernel:  do_syscall_64+0x45/0x80
> > > > kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > > kernel: RIP: 0033:0x7fd4912b79b3
> > > > kernel: Code: 8b 15 b9 74 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb
> > > > b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05
> > > > <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
> > > > kernel: RSP: 002b:00007ffe96fdd858 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > > > kernel: RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd4912b79b3
> > > > kernel: RDX: 0000000000000002 RSI: 0000000000536810 RDI: 0000000000000001
> > > > kernel: RBP: 0000000000536810 R08: 000000000000000a R09: 0000000000000000
> > > > kernel: R10: 00007fd49134f040 R11: 0000000000000246 R12: 0000000000000002
> > > > kernel: R13: 00007fd4913906c0 R14: 00007fd49138c520 R15: 00007fd49138b920
> > > > kernel: ---[ end trace ee7985b10570603d ]---
> > > > kernel: ------------[ cut here ]------------
> > >
> > > So the warning is easy to reproduce.
> > > On qemu/kvm just set ctrl_guest_offloads=off for the device.
> >
> > I have no control over the settings of the host.
> > I have full control over the guest.
> >
> > > The panic does not seem to trigger for me and you did not provide
> > > any data about it.  What happens? Does guest just freeze?
> >
> > I'm not sure if I am misusing the word "panic". (Appologies, not a programer)
> > No, the guest does not freeze, just, the moment I issue the command...
> >   echo 1 > /proc/sys/net/ipv4/ip_forward
> > ... and I see the "--[ cut here ]--" message appear in the syslog.
> > Shortly thereafter my ssh session to that host dies.
>
> So the host or to the guest?
Sorry!  The guest. (My bad)  This problem happens in the guest.
My ssh session to that guest dies shortly after I ussue that command.
