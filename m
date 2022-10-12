Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020CE5FC6F0
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJLODo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJLODm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:03:42 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D414C7072
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:03:40 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id n6-20020a056e021ba600b002fc99858e34so3063489ili.14
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n0UBNFYp+vCcYR8ZR0zNcVKROtglGCtdOoaLUjeXgg4=;
        b=rC4F7QZEdoGvCaEJ9pv12RIfJuEqNlLlM05ZAbHr75IgEp6sbXPQ/XTDoeG4qwewV7
         wRBQ4VPv7asQF9VwRyj9z7a6VCieMa+BIO5XTbQm2nqiLdCtwP9uulUYKlPi5o7JH+uW
         x9S0XcFsZ7pmB3UftvzLVoMcY0fjjAEgwcTJA/HJaHsGVej+fjQwjF3TXh33LVvAlnzw
         mu0k2rpD1IKtVtKZUOqUyPJHYXx5C/htI6c8bGA/PicJeWqK0l+wF9qFj4rOuhnJtNZb
         Azv+6PnwZMZghvKSFgqiPgsnJWoN+gHh+24jJOb27I4HsBRS6NfSjFmnAZ+FZZnK5tc1
         zOuA==
X-Gm-Message-State: ACrzQf1dwoDA3STfuLx7td2VE0AgwUw8ptVZl0g3zHBzLWczFu4usyKD
        Nbm+BM7zws8lXQfKJHBFNmryGpt9W32Ylsl8SkZAl41R9uCd
X-Google-Smtp-Source: AMsMyM4UlkI+7pX3jD5RdNYVHE8pjZo8aZaJ5yo3+4kquz2tNK3M6pNctuakarJ7htgkAX9eh6vchvwjuSKKTeJTe7m4F6ZktQMv
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1919:b0:363:b88d:e02b with SMTP id
 p25-20020a056638191900b00363b88de02bmr8700074jal.154.1665583419621; Wed, 12
 Oct 2022 07:03:39 -0700 (PDT)
Date:   Wed, 12 Oct 2022 07:03:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001207f205ead6dc09@google.com>
Subject: [syzbot] usb-testing boot error: WARNING in cpumask_next_wrap
From:   syzbot <syzbot+28ec239d5c21a2d91f3d@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    49da07006239 Merge tag 'memblock-v6.1-rc1' of git://git.ke..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1361eb1a880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8be1ac10ff2d4692
dashboard link: https://syzkaller.appspot.com/bug?extid=28ec239d5c21a2d91f3d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d41d7d5418ab/disk-49da0700.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9ffb9548d913/vmlinux-49da0700.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+28ec239d5c21a2d91f3d@syzkaller.appspotmail.com

software IO TLB: mapped [mem 0x00000000bbffd000-0x00000000bfffd000] (64MB)
RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl timer
clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb6feccdd0, max_idle_ns: 440795259471 ns
clocksource: Switched to clocksource tsc
Initialise system trusted keyrings
workingset: timestamp_bits=40 max_order=21 bucket_order=0
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
9p: Installing v9fs 9p2000 file system support
Key type asymmetric registered
Asymmetric key parser 'x509' registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
io scheduler mq-deadline registered
io scheduler kyber registered
usbcore: registered new interface driver udlfb
usbcore: registered new interface driver smscufx
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: button: Power Button [PWRF]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
ACPI: button: Sleep Button [SLPF]
ACPI: \_SB_.LNKC: Enabled at IRQ 11
virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKD: Enabled at IRQ 10
virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKB: Enabled at IRQ 10
virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ACPI: bus type drm_connector registered
usbcore: registered new interface driver udl
loop: module loaded
usbcore: registered new interface driver rtsx_usb
usbcore: registered new interface driver viperboard
usbcore: registered new interface driver dln2
usbcore: registered new interface driver pn533_usb
usbcore: registered new interface driver port100
usbcore: registered new interface driver nfcmrvl
scsi host0: Virtio SCSI HBA
scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
sd 0:0:1:0: Attached scsi generic sg0 type 0
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
------------[ cut here ]------------
WARNING: CPU: 1 PID: 1 at include/linux/cpumask.h:110 cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
WARNING: CPU: 1 PID: 1 at include/linux/cpumask.h:110 cpumask_check include/linux/cpumask.h:117 [inline]
WARNING: CPU: 1 PID: 1 at include/linux/cpumask.h:110 cpumask_next include/linux/cpumask.h:178 [inline]
WARNING: CPU: 1 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x139/0x1d0 lib/cpumask.c:27
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-11414-g49da07006239 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
RIP: 0010:cpumask_check include/linux/cpumask.h:117 [inline]
RIP: 0010:cpumask_next include/linux/cpumask.h:178 [inline]
RIP: 0010:cpumask_next_wrap+0x139/0x1d0 lib/cpumask.c:27
Code: df e8 6b 9e 80 fb 39 eb 77 64 e8 12 a2 80 fb 41 8d 6c 24 01 89 de 89 ef e8 54 9e 80 fb 39 dd 0f 82 54 ff ff ff e8 f7 a1 80 fb <0f> 0b e9 48 ff ff ff e8 eb a1 80 fb 48 c7 c2 80 dc e3 88 48 b8 00
RSP: 0000:ffffc9000001f920 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff8881002b0000 RSI: ffffffff85c61b89 RDI: 0000000000000004
RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff88e3da90
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000007825000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virtnet_set_affinity+0x35a/0x750 drivers/net/virtio_net.c:2303
 init_vqs drivers/net/virtio_net.c:3581 [inline]
 init_vqs drivers/net/virtio_net.c:3567 [inline]
 virtnet_probe+0x12ae/0x33a0 drivers/net/virtio_net.c:3884
 virtio_dev_probe+0x577/0x870 drivers/virtio/virtio.c:305
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xb90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __driver_attach+0x1d0/0x550 drivers/base/dd.c:1190
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
 bus_add_driver+0x4c9/0x640 drivers/base/bus.c:618
 driver_register+0x220/0x3a0 drivers/base/driver.c:246
 virtio_net_driver_init+0x93/0xd2 drivers/net/virtio_net.c:4090
 do_one_initcall+0x13d/0x780 init/main.c:1303
 do_initcall_level init/main.c:1376 [inline]
 do_initcalls init/main.c:1392 [inline]
 do_basic_setup init/main.c:1411 [inline]
 kernel_init_freeable+0x6fa/0x783 init/main.c:1631
 kernel_init+0x1a/0x1d0 init/main.c:1519
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
