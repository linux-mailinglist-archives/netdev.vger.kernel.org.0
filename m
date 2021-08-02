Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B743DDF00
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 20:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhHBSSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 14:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 14:18:41 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B71C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 11:18:30 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y34so35325728lfa.8
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 11:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=prestigetransportation-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LecZeQHk5rIxlWs32qPomGzDTLcfzCHgtM2q4bUry9g=;
        b=lC1IITj075bvtY8DMP2Yuklx8sqMf7An3xdVHv7nmHRaZmnc6sSBb5LBn334Oie4p5
         QHRgwANlEzI/YOLpVtAQr+QauMhoGZNaAROFnVvDXzaMiCwe3WvmvoRCkgzHOK7Otd5y
         xRMiFCsePt+9BAE6mtvdzW/lKdCb/rIUV9MXC55oxmzbxQyP/OE2YpgdJbxwwK1vY6ku
         kj/YzT/bWnZQlxP2tNnHS3p/CI8hqT0QHRBANIz7BHn7UPj80cuuJq6+eeF6C5xyp0px
         MGuGCmrVB1AuZtjYYuRP5AJ40C/fzGRemocNY6SXzU+OVFzpiL1K6QVWQEDxkrhQeWha
         gTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LecZeQHk5rIxlWs32qPomGzDTLcfzCHgtM2q4bUry9g=;
        b=b2XYt1L8fhwnjrvFPVlpcWTxqTDdq/f/rCrJ2PWuFtLidcufVAmC8fc31S34EA/QlG
         L234/5OatFwsdqVXywtBA2BBq9BakwVIY3qjVC8y2lJn5uPPhf946mkEhEXMjssVXdlo
         a3tY8/WqM2qtDuQvF7KYMsYXcVM8So5n6gs0CbhlRtMFOQcY2f78/33yQHI8RrzemMw/
         VnXU++Jv2NtuYO5AU6xrWxbEiV2rEF9r7mbxPJcW+xstEUTW4Y9oKa3WQJHC7mwu+vOc
         Od+ABnj9PhR7EDfUqop9u+2mWSvRvRYWM0DcIbKBQUMvfkCSBy61wkdbsLkq9XvKxGlD
         Kpnw==
X-Gm-Message-State: AOAM530KwPiH5Ork+qQVGTc7zvEiWO8lLCoV3tB1cEvASOvUwPpSmsk5
        MQ+m2VYPACRSaLKfR5ndwND6P1aQhTScLjWcivycig==
X-Google-Smtp-Source: ABdhPJyb5YHji/ye305nos1HYKwv3dUznjVP1uPPA6tGX6zFVeI6WVHarT/M7LpuiDE3Q7DbUvh85VQkplDXIzdJy0U=
X-Received: by 2002:a19:c390:: with SMTP id t138mr13684850lff.554.1627928308673;
 Mon, 02 Aug 2021 11:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <CACFia2dwacaVVYD+1uG=CDGaJqdCOSBvZ5FcXp04caecaWAY3w@mail.gmail.com>
 <20210730073029-mutt-send-email-mst@kernel.org> <CACFia2d82tqUrLwpt0fowm3DpD7+HXM9Vcfz56eQ_AkTcWmOEg@mail.gmail.com>
 <edf33712-c036-b9d0-7f41-904d5862156f@redhat.com>
In-Reply-To: <edf33712-c036-b9d0-7f41-904d5862156f@redhat.com>
From:   Ivan <ivan@prestigetransportation.com>
Date:   Mon, 2 Aug 2021 13:16:10 -0500
Message-ID: <CACFia2fAZistK9MZxugAcpos546U0W32w0z+vEmS4pK_9bxn5w@mail.gmail.com>
Subject: Re: PROBLEM: virtio_net LRO kernel panics
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan <ivan@prestigetransportation.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 1, 2021 at 11:35 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/31 =E4=B8=8A=E5=8D=881:04, Ivan =E5=86=99=E9=81=93:
> > On Fri, Jul 30, 2021 at 6:42 AM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> >> On Thu, Jul 22, 2021 at 06:27:18PM -0500, Ivan wrote:
> >>> Dear Sir,
> >>>
> >>> I've been plagued with kernel panics recently. The problem is easily
> >>> reproducible on any virtual machine that uses the virtio-net driver
> >>> from stock Linux kernel. Simply isuse this command:
> >>>
> >>> echo 1 > /proc/sys/net/ipv4/ip_forward
> >>> ...and the kernel panics.
> >>>
> >>> Is there any way we can possibly fix this?
> >>>
> >>> kernel: ------------[ cut here ]------------
> >>> kernel: netdevice: eth0: failed to disable LRO!
> >>> kernel: WARNING: CPU: 1 PID: 424 at net/core/dev.c:1768
> >>> dev_disable_lro+0x108/0x150
> >>> kernel: Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usbhid
> >>> atkbd libps2 ahci libahci virtio_net ohci_pci net_failover failover
> >>> i8042 serio lpc_ich mfd_core libata ohci_hcd ehci_pci ehci_hcd usbcor=
e
> >>> rng_core i2c_piix4 i2c_core virtio_pci usb_common
> >>> virtio_pci_modern_dev virtio_ring virtio loop unix
> >>> kernel: CPU: 1 PID: 424 Comm: bash Not tainted 5.13.4-gnu.4-NuMini #1
> >>> kernel: Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> >>> VirtualBox 12/01/2006
> >>> kernel: RIP: 0010:dev_disable_lro+0x108/0x150
> >>> kernel: Code: ae 88 74 14 be 25 00 00 00 48 89 df e8 f1 54 ed ff 48 8=
5
> >>> c0 48 0f 44 eb 4c 89 e2 48 89 ee 48 c7 c7 00 c6 ae 88 e8 7a 76 0c 00
> >>> <0f> 0b e9 2d ff ff ff 80 3d e8 70 97 00 00 49 c7 c4 73 bb ae 88 75
> >>> kernel: RSP: 0018:ffffb596c0237d80 EFLAGS: 00010282
> >>> kernel: RAX: 0000000000000000 RBX: ffff9af9c1835000 RCX: ffff9af9fed1=
7538
> >>> kernel: RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9af9fed1=
7530
> >>> kernel: RBP: ffff9af9c1835000 R08: ffffffff88c96ac8 R09: 000000000000=
4ffb
> >>> kernel: R10: 00000000fffff000 R11: 3fffffffffffffff R12: ffffffff88ac=
7c3d
> >>> kernel: R13: 0000000000000000 R14: ffffffff88cb2748 R15: ffff9af9c121=
66c8
> >>> kernel: FS:  00007fd4911b8740(0000) GS:ffff9af9fed00000(0000)
> >>> knlGS:0000000000000000
> >>> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> kernel: CR2: 0000000000532008 CR3: 000000000115c000 CR4: 000000000004=
06e0
> >>> kernel: Call Trace:
> >>> kernel:  devinet_sysctl_forward+0x1ac/0x1e0
> >>> kernel:  proc_sys_call_handler+0x127/0x230
> >>> kernel:  new_sync_write+0x114/0x1a0
> >>> kernel:  vfs_write+0x18c/0x220
> >>> kernel:  ksys_write+0x5a/0xd0
> >>> kernel:  do_syscall_64+0x45/0x80
> >>> kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>> kernel: RIP: 0033:0x7fd4912b79b3
> >>> kernel: Code: 8b 15 b9 74 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff e=
b
> >>> b7 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05
> >>> <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
> >>> kernel: RSP: 002b:00007ffe96fdd858 EFLAGS: 00000246 ORIG_RAX: 0000000=
000000001
> >>> kernel: RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd4912b=
79b3
> >>> kernel: RDX: 0000000000000002 RSI: 0000000000536810 RDI: 000000000000=
0001
> >>> kernel: RBP: 0000000000536810 R08: 000000000000000a R09: 000000000000=
0000
> >>> kernel: R10: 00007fd49134f040 R11: 0000000000000246 R12: 000000000000=
0002
> >>> kernel: R13: 00007fd4913906c0 R14: 00007fd49138c520 R15: 00007fd49138=
b920
> >>> kernel: ---[ end trace ee7985b10570603d ]---
> >>> kernel: ------------[ cut here ]------------
> >> So the warning is easy to reproduce.
> >> On qemu/kvm just set ctrl_guest_offloads=3Doff for the device.
> > I have no control over the settings of the host.
> > I have full control over the guest.
> >
> >> The panic does not seem to trigger for me and you did not provide
> >> any data about it.  What happens? Does guest just freeze?
> > I'm not sure if I am misusing the word "panic". (Appologies, not a prog=
ramer)
> > No, the guest does not freeze, just, the moment I issue the command...
> >    echo 1 > /proc/sys/net/ipv4/ip_forward
> > ... and I see the "--[ cut here ]--" message appear in the syslog.
> > Shortly thereafter my ssh session to that host dies.
>
>
> Does it work before this commit?
>
> commit a02e8964eaf9271a8a5fcc0c55bd13f933bafc56
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Thu Dec 20 17:14:54 2018 -0500
>
>      virtio-net: ethtool configurable LRO

Yes.
