Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB945FFBC1
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 21:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJOTWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 15:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJOTWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 15:22:43 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C30D41D0C
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 12:22:42 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id g13-20020a056e021e0d00b002fc57cd18e3so6250334ila.11
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 12:22:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mh43AJ1PRUmqIgIT5dSQbwpbOw/GWUpk4HC12QCTsrI=;
        b=GXuqZmrHXzk+Knw2BZTvXJpvfCqgNf+PWXvo1yWvZ6jxdCG9jF0rWv1JUH+xcu5INY
         sdtWY/bckHxS+o5UXwm5I3G3VWC/awFSsVY67Gjlnv/p/3S37qe7K3xwoUc7M9LB3xTQ
         G8ZaC128jcBQwtI8ohKAZi5n3rtRKA84IXbfi8cBXlaHc+d4t6eb1g9RmXwutsRizjl8
         i+vbeKou2Q8aNYKJaZwXp76RLqYi3MOL7bT1tb/54C1FIjr2jmoyR7dKPM+O7RzEUxuG
         pB9xf1VGPTK87dKnvkGGDqCHQrzZJz+Gb85nbb4IogW13ckjLKbeIf4Z/lFct731tTRq
         K20Q==
X-Gm-Message-State: ACrzQf3O1fXZQ7p8G4A9vZJ4kAz3Qxh6jfr8CwzuFoOXoNL0jjk93yai
        3pWLiZTotiVf3MX2xINiqWowsTkVRzP+mXiVJI9UUduaDP7p
X-Google-Smtp-Source: AMsMyM673Oxtb4tTp0tit7Auny7JsQYxqIjDLZ86mDPUbfOLzeIIX8eG+gRK5a8gza+Ty9Zv06vBSaZU1oWwZ6hDRxUYFA3YW6Sy
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1be7:b0:2f9:b795:e298 with SMTP id
 y7-20020a056e021be700b002f9b795e298mr1813458ilv.117.1665861761824; Sat, 15
 Oct 2022 12:22:41 -0700 (PDT)
Date:   Sat, 15 Oct 2022 12:22:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f02b105eb17aafd@google.com>
Subject: [syzbot] net-next boot error: WARNING in cpumask_next_wrap
From:   syzbot <syzbot+d2ee3b0bdd0a95ffef1e@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    66ae04368efb Merge tag 'net-6.1-rc1' of git://git.kernel.o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12821b94880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85495c44a2c25446
dashboard link: https://syzkaller.appspot.com/bug?extid=d2ee3b0bdd0a95ffef1e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1ae7b7730cc6/disk-66ae0436.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/675ac7249856/vmlinux-66ae0436.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2ee3b0bdd0a95ffef1e@syzkaller.appspotmail.com

ACPI: button: Sleep Button [SLPF]
ACPI: \_SB_.LNKC: Enabled at IRQ 11
virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKD: Enabled at IRQ 10
virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKB: Enabled at IRQ 10
virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
N_HDLC line discipline registered with maxframe=4096
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ACPI: bus type drm_connector registered
[drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
[drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
Console: switching to colour frame buffer device 128x48
platform vkms: [drm] fb0: vkmsdrmfb frame buffer device
usbcore: registered new interface driver udl
brd: module loaded
loop: module loaded
zram: Added device: zram0
null_blk: disk nullb0 created
null_blk: module loaded
Guest personality initialized and is inactive
VMCI host device registered (name=vmci, major=10, minor=119)
Initialized host personality
usbcore: registered new interface driver rtsx_usb
usbcore: registered new interface driver viperboard
usbcore: registered new interface driver dln2
usbcore: registered new interface driver pn533_usb
nfcsim 0.2 initialized
usbcore: registered new interface driver port100
usbcore: registered new interface driver nfcmrvl
Loading iSCSI transport class v2.0-870.
scsi host0: Virtio SCSI HBA
st: Version 20160209, fixed bufsize 32768, s/g segs 256
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
MACsec IEEE 802.1AE
tun: Universal TUN/TAP device driver, 1.6
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_check include/linux/cpumask.h:117 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next include/linux/cpumask.h:178 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x139/0x1d0 lib/cpumask.c:27
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-11827-g66ae04368efb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
RIP: 0010:cpumask_check include/linux/cpumask.h:117 [inline]
RIP: 0010:cpumask_next include/linux/cpumask.h:178 [inline]
RIP: 0010:cpumask_next_wrap+0x139/0x1d0 lib/cpumask.c:27
Code: df e8 8b 5a 3d f8 39 eb 77 64 e8 32 5e 3d f8 41 8d 6c 24 01 89 de 89 ef e8 74 5a 3d f8 39 dd 0f 82 54 ff ff ff e8 17 5e 3d f8 <0f> 0b e9 48 ff ff ff e8 0b 5e 3d f8 48 c7 c2 00 02 e2 8d 48 b8 00
RSP: 0000:ffffc90000067920 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff88813fe38000 RSI: ffffffff893f0c59 RDI: 0000000000000004
RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff8de20010
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000bc8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virtnet_set_affinity+0x35a/0x750 drivers/net/virtio_net.c:2303
 init_vqs drivers/net/virtio_net.c:3581 [inline]
 init_vqs drivers/net/virtio_net.c:3567 [inline]
 virtnet_probe+0x12ae/0x31e0 drivers/net/virtio_net.c:3884
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
 kernel_init_freeable+0x6ff/0x788 init/main.c:1631
 kernel_init+0x1a/0x1d0 init/main.c:1519
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
