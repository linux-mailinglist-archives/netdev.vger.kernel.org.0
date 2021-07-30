Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6B3DBD74
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhG3RGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhG3RGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 13:06:42 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B610FC06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 10:06:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z2so19253039lft.1
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 10:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=prestigetransportation-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qA8IBjKKOxL5thImiztH8aad4MUlTqNiWxqcHtHaRCs=;
        b=aQ/ev/haqZhL4YYJtfnaJYLoNwVmBzu9vKZg7l/hXaFKLo25QVfibZHi0xDvxzF2Uu
         lYbTUBFp8oCxDkZY7Em/+yTdRAfk5UMZT2gNtcd7Jme+Muw6RPhV4b18Ej2t2eZdRtP3
         Tyu8YKzwgfSPS5o14zNma+KF134QH8Oy1AWLth0T7Kb9o53ZE/D0RwRZF/h40UCSk71n
         iz3nh4Cmjd/dSgO8scbupY/8wBVCLzi7wbMybdE128Fc0E4Vt7duYnrLq68mkhOwtX8O
         eznajn8Qo3c20HaQK4cR0ogrXDRwQaJKiE9DV1vYRUL4yxTiEcBjQtAxiYT0Xc5iiWFI
         +wMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qA8IBjKKOxL5thImiztH8aad4MUlTqNiWxqcHtHaRCs=;
        b=F+B9hPBOQTGr9jZV3cxnV3/gm0Z0G0jw0+SdkVB+MnxAwyWjKYR8UGXeYS/HvKiUJk
         IfjZm5R19tSrE5zqvHv1WxtlHSJ0UNhaqAX7+flbFPcwWwzy5Xcrzi9Nb4sj2sALIPBb
         Fs1xcQvpuxsM7GGTd5pPkBwHevy7khrzmEBE/w4eMPTxncHjzZe6kgaFipy61djYWSTb
         6ZJaMlwepL36mbcjcjp/F2nKJ1cjU00tm6aOLDG2K5QtdjnuE5yEyHbbtvyhf8nEzQgO
         Q8EsSlYrv88gtxL8D1pGbqHBEYQIJfR+gkuEUXBdzrAQmgDhZRu3M55rRnX/fdaFD7TG
         oDxA==
X-Gm-Message-State: AOAM532TX2vbo5X8TjR2eX8txXK3KKNd3r7XuAQ9nc/Gw5I8i9woarFt
        6fMWI2iWs316JvrPJgbIQMtFtApai9fk9RWOdvNSqQ==
X-Google-Smtp-Source: ABdhPJxM9fXkDRpH6oAp14G0YSq9MJ8U1Ngh2op7mkL4YMoz5BpP8BLMH8q+lgNsjVPWFJt6yn27zIlyXVyw+RyY9Tk=
X-Received: by 2002:a05:6512:3ba7:: with SMTP id g39mr2729321lfv.494.1627664795716;
 Fri, 30 Jul 2021 10:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <CACFia2dwacaVVYD+1uG=CDGaJqdCOSBvZ5FcXp04caecaWAY3w@mail.gmail.com>
 <20210730073029-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210730073029-mutt-send-email-mst@kernel.org>
From:   Ivan <ivan@prestigetransportation.com>
Date:   Fri, 30 Jul 2021 12:04:18 -0500
Message-ID: <CACFia2d82tqUrLwpt0fowm3DpD7+HXM9Vcfz56eQ_AkTcWmOEg@mail.gmail.com>
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

On Fri, Jul 30, 2021 at 6:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Jul 22, 2021 at 06:27:18PM -0500, Ivan wrote:
> > Dear Sir,
> >
> > I've been plagued with kernel panics recently. The problem is easily
> > reproducible on any virtual machine that uses the virtio-net driver
> > from stock Linux kernel. Simply isuse this command:
> >
> > echo 1 > /proc/sys/net/ipv4/ip_forward
> > ...and the kernel panics.
> >
> > Is there any way we can possibly fix this?
> >
> > kernel: ------------[ cut here ]------------
> > kernel: netdevice: eth0: failed to disable LRO!
> > kernel: WARNING: CPU: 1 PID: 424 at net/core/dev.c:1768
> > dev_disable_lro+0x108/0x150
> > kernel: Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usbhid
> > atkbd libps2 ahci libahci virtio_net ohci_pci net_failover failover
> > i8042 serio lpc_ich mfd_core libata ohci_hcd ehci_pci ehci_hcd usbcore
> > rng_core i2c_piix4 i2c_core virtio_pci usb_common
> > virtio_pci_modern_dev virtio_ring virtio loop unix
> > kernel: CPU: 1 PID: 424 Comm: bash Not tainted 5.13.4-gnu.4-NuMini #1
> > kernel: Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> > VirtualBox 12/01/2006
> > kernel: RIP: 0010:dev_disable_lro+0x108/0x150
> > kernel: Code: ae 88 74 14 be 25 00 00 00 48 89 df e8 f1 54 ed ff 48 85
> > c0 48 0f 44 eb 4c 89 e2 48 89 ee 48 c7 c7 00 c6 ae 88 e8 7a 76 0c 00
> > <0f> 0b e9 2d ff ff ff 80 3d e8 70 97 00 00 49 c7 c4 73 bb ae 88 75
> > kernel: RSP: 0018:ffffb596c0237d80 EFLAGS: 00010282
> > kernel: RAX: 0000000000000000 RBX: ffff9af9c1835000 RCX: ffff9af9fed17538
> > kernel: RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9af9fed17530
> > kernel: RBP: ffff9af9c1835000 R08: ffffffff88c96ac8 R09: 0000000000004ffb
> > kernel: R10: 00000000fffff000 R11: 3fffffffffffffff R12: ffffffff88ac7c3d
> > kernel: R13: 0000000000000000 R14: ffffffff88cb2748 R15: ffff9af9c12166c8
> > kernel: FS:  00007fd4911b8740(0000) GS:ffff9af9fed00000(0000)
> > knlGS:0000000000000000
> > kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > kernel: CR2: 0000000000532008 CR3: 000000000115c000 CR4: 00000000000406e0
> > kernel: Call Trace:
> > kernel:  devinet_sysctl_forward+0x1ac/0x1e0
> > kernel:  proc_sys_call_handler+0x127/0x230
> > kernel:  new_sync_write+0x114/0x1a0
> > kernel:  vfs_write+0x18c/0x220
> > kernel:  ksys_write+0x5a/0xd0
> > kernel:  do_syscall_64+0x45/0x80
> > kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > kernel: RIP: 0033:0x7fd4912b79b3
> > kernel: Code: 8b 15 b9 74 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb
> > b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05
> > <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
> > kernel: RSP: 002b:00007ffe96fdd858 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > kernel: RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd4912b79b3
> > kernel: RDX: 0000000000000002 RSI: 0000000000536810 RDI: 0000000000000001
> > kernel: RBP: 0000000000536810 R08: 000000000000000a R09: 0000000000000000
> > kernel: R10: 00007fd49134f040 R11: 0000000000000246 R12: 0000000000000002
> > kernel: R13: 00007fd4913906c0 R14: 00007fd49138c520 R15: 00007fd49138b920
> > kernel: ---[ end trace ee7985b10570603d ]---
> > kernel: ------------[ cut here ]------------
>
> So the warning is easy to reproduce.
> On qemu/kvm just set ctrl_guest_offloads=off for the device.

I have no control over the settings of the host.
I have full control over the guest.

> The panic does not seem to trigger for me and you did not provide
> any data about it.  What happens? Does guest just freeze?

I'm not sure if I am misusing the word "panic". (Appologies, not a programer)
No, the guest does not freeze, just, the moment I issue the command...
  echo 1 > /proc/sys/net/ipv4/ip_forward
... and I see the "--[ cut here ]--" message appear in the syslog.
Shortly thereafter my ssh session to that host dies.
