Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A213DB7F6
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhG3LnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:43:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238617AbhG3Lm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 07:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627645373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aCLtm9dFHn+w/SB2693+ZgZ2eFgaS9vHe74MS+otrP0=;
        b=TOA5NiZF3D1UmEAsOyg5oIXOkAuzlViAgZXwMpOBDlXUNjSYfKF+oIl0XgLn2EEsl7kbfe
        hA9SGwOWEcL7YC962QpiEi8XRucsoL4EInv9HU07GPG3+cWvcZ9oSbxo1Kbskgb2ubrLYZ
        glEC8yIzyJXkxrAOcUQMtLjdKPqYGLo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-Ll2DH18YOnykIesRK0PgSA-1; Fri, 30 Jul 2021 07:42:52 -0400
X-MC-Unique: Ll2DH18YOnykIesRK0PgSA-1
Received: by mail-ed1-f69.google.com with SMTP id h16-20020aa7de100000b02903a6620f87feso4498849edv.18
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 04:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aCLtm9dFHn+w/SB2693+ZgZ2eFgaS9vHe74MS+otrP0=;
        b=XQF5crf4WLQVvjnYa9UGng9+XrCWoXzrT+ohwu6KFScvsms3uoH/w2QTNoTb/Fck3J
         HcWvDyiFZy0kkVRj45PdJcpA8ITd38YX6bDSsxisrIXN1V5/mypKARbwU2c45Hs1Ae8q
         zugN1Y5tF6R1cLO7kPAZH/VlZFVmKPzCFqpPQm8xHZp3poC6fVL4svDdAGqIb660VK/v
         ScBGBGoWcbb/i9MIVuWLvDTgzKhfxLtBMwylubMJTmX7LYTY5s+TVRPm4SqwbP0PBs27
         twS3qT5WytYbQT1xTBmwVdyempmu1rCFEFzhnwSZviZOgMeEw6Qq98KwaXp6/rE8JGwG
         ewJg==
X-Gm-Message-State: AOAM531rj1MtrMfC4+M5WFoGZiWFM4rCJ8StNB7BTQo+pwT7XbfthYm3
        Xg5XEHr9DdKnuP3ugX6l4Qtayr7AH0/kiMuV60icfxK8wMMG1IecX/ucYb0cf/0MXxEH7pKrRuq
        SpdFZ3mflU00wMBJJ
X-Received: by 2002:a17:906:170e:: with SMTP id c14mr2099523eje.40.1627645370366;
        Fri, 30 Jul 2021 04:42:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLMex01yosXP2wcgUw3UaUEOh1RjmU459A47bxcVoWsy5QaUxlIHWfCdcjeeCPj1w80hxeYA==
X-Received: by 2002:a17:906:170e:: with SMTP id c14mr2099508eje.40.1627645370200;
        Fri, 30 Jul 2021 04:42:50 -0700 (PDT)
Received: from redhat.com ([2.55.154.10])
        by smtp.gmail.com with ESMTPSA id r15sm574960edw.46.2021.07.30.04.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 04:42:48 -0700 (PDT)
Date:   Fri, 30 Jul 2021 07:42:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Ivan <ivan@prestigetransportation.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: PROBLEM: virtio_net LRO kernel panics
Message-ID: <20210730073029-mutt-send-email-mst@kernel.org>
References: <CACFia2dwacaVVYD+1uG=CDGaJqdCOSBvZ5FcXp04caecaWAY3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACFia2dwacaVVYD+1uG=CDGaJqdCOSBvZ5FcXp04caecaWAY3w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 06:27:18PM -0500, Ivan wrote:
> Dear Sir,
> 
> I've been plagued with kernel panics recently. The problem is easily
> reproducible on any virtual machine that uses the virtio-net driver
> from stock Linux kernel. Simply isuse this command:
> 
> echo 1 > /proc/sys/net/ipv4/ip_forward
> ...and the kernel panics.
> 
> Is there any way we can possibly fix this?
> 
> kernel: ------------[ cut here ]------------
> kernel: netdevice: eth0: failed to disable LRO!
> kernel: WARNING: CPU: 1 PID: 424 at net/core/dev.c:1768
> dev_disable_lro+0x108/0x150
> kernel: Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usbhid
> atkbd libps2 ahci libahci virtio_net ohci_pci net_failover failover
> i8042 serio lpc_ich mfd_core libata ohci_hcd ehci_pci ehci_hcd usbcore
> rng_core i2c_piix4 i2c_core virtio_pci usb_common
> virtio_pci_modern_dev virtio_ring virtio loop unix
> kernel: CPU: 1 PID: 424 Comm: bash Not tainted 5.13.4-gnu.4-NuMini #1
> kernel: Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> VirtualBox 12/01/2006
> kernel: RIP: 0010:dev_disable_lro+0x108/0x150
> kernel: Code: ae 88 74 14 be 25 00 00 00 48 89 df e8 f1 54 ed ff 48 85
> c0 48 0f 44 eb 4c 89 e2 48 89 ee 48 c7 c7 00 c6 ae 88 e8 7a 76 0c 00
> <0f> 0b e9 2d ff ff ff 80 3d e8 70 97 00 00 49 c7 c4 73 bb ae 88 75
> kernel: RSP: 0018:ffffb596c0237d80 EFLAGS: 00010282
> kernel: RAX: 0000000000000000 RBX: ffff9af9c1835000 RCX: ffff9af9fed17538
> kernel: RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9af9fed17530
> kernel: RBP: ffff9af9c1835000 R08: ffffffff88c96ac8 R09: 0000000000004ffb
> kernel: R10: 00000000fffff000 R11: 3fffffffffffffff R12: ffffffff88ac7c3d
> kernel: R13: 0000000000000000 R14: ffffffff88cb2748 R15: ffff9af9c12166c8
> kernel: FS:  00007fd4911b8740(0000) GS:ffff9af9fed00000(0000)
> knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 0000000000532008 CR3: 000000000115c000 CR4: 00000000000406e0
> kernel: Call Trace:
> kernel:  devinet_sysctl_forward+0x1ac/0x1e0
> kernel:  proc_sys_call_handler+0x127/0x230
> kernel:  new_sync_write+0x114/0x1a0
> kernel:  vfs_write+0x18c/0x220
> kernel:  ksys_write+0x5a/0xd0
> kernel:  do_syscall_64+0x45/0x80
> kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> kernel: RIP: 0033:0x7fd4912b79b3
> kernel: Code: 8b 15 b9 74 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb
> b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05
> <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
> kernel: RSP: 002b:00007ffe96fdd858 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> kernel: RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd4912b79b3
> kernel: RDX: 0000000000000002 RSI: 0000000000536810 RDI: 0000000000000001
> kernel: RBP: 0000000000536810 R08: 000000000000000a R09: 0000000000000000
> kernel: R10: 00007fd49134f040 R11: 0000000000000246 R12: 0000000000000002
> kernel: R13: 00007fd4913906c0 R14: 00007fd49138c520 R15: 00007fd49138b920
> kernel: ---[ end trace ee7985b10570603d ]---
> kernel: ------------[ cut here ]------------

So the warning is easy to reproduce.
On qemu/kvm just set ctrl_guest_offloads=off for the device.

The panic does not seem to trigger for me and you did not provide
any data about it.  What happens? Does guest just freeze?

I am guessing the issue is that dev_disable_lro does not report the
return status and inet_forward_change assumes it's successful.  We then
end up with LRO packets in unexpected places.

Cc netdev and a bunch of people who might have a better idea.

-- 
MST

