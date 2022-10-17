Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118A9600522
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 04:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJQCQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 22:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJQCPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 22:15:42 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16040192BB
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 19:15:41 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id i21-20020a056e021d1500b002f9e4f8eab7so7960530ila.7
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 19:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DGa85eDs4HDf0btlqFpHUgSWnf8N3groGUn+7nSJ2UY=;
        b=Rt2UfnJUXjg6PyMta79y2j23Y9RDbi19XoilwcN6x4k96uJSh4Pv0qr4yFXm25cz4R
         wgSXlK+gPgfoQTod6QYTCm8m2LBkHVBBnsrnXnx2lQWvLJwHYDtII//X/FV+MLbXrOJg
         paPhQS0eFUvwaTLQvisdf1K57ofY9/xMUqKf9w7/6/3gjBJJXjIV16h6ExY87Qcseki6
         HKk6lgpilz1DMBcFthJb4BN2FY7E3To5PHl4yvqxHD/Ti/FK+VInulIw1i2o37QJd7vF
         mN+hl0ATBHgJ6TJfAdaifX6H4eopCql6SoPIFPPsJH0iIs6hUWny8oeB8dm9ejQAJ3cY
         NBBg==
X-Gm-Message-State: ACrzQf0SaLFUL1/vF8qKx/6iip8yqiYjI2xSypSgtpSLP5a7TUPao3gE
        MGSQQ+/77u8dSc9lm59BAUqQ0IEXT0CMQE8oC0IjVXikt7zW
X-Google-Smtp-Source: AMsMyM7TF7QkPiCerp1TQlI7M7+sQnISW1eS7yUz86L4kMv9kLD4axumPp3b21eNue1WQLDTw1mZnfxzJlIez3kIDOo1AUSzaVvG
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12b1:b0:2fc:cc40:6c2 with SMTP id
 f17-20020a056e0212b100b002fccc4006c2mr3921051ilr.187.1665972940289; Sun, 16
 Oct 2022 19:15:40 -0700 (PDT)
Date:   Sun, 16 Oct 2022 19:15:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004fc10b05eb318d60@google.com>
Subject: [syzbot] upstream boot error: WARNING in __netif_set_xps_queue
From:   syzbot <syzbot+9abe5ecc348676215427@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9abf2313adc1 Linux 6.1-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e70244880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4789759e8a6d5f57
dashboard link: https://syzkaller.appspot.com/bug?extid=9abe5ecc348676215427
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1f92e2492e87/disk-9abf2313.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e1f5038aaa4b/vmlinux-9abf2313.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9abe5ecc348676215427@syzkaller.appspotmail.com

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
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 netif_attrmask_next_and include/linux/netdevice.h:3689 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0xc00/0x2120 net/core/dev.c:2592
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
RIP: 0010:netif_attrmask_next_and include/linux/netdevice.h:3689 [inline]
RIP: 0010:__netif_set_xps_queue+0xc00/0x2120 net/core/dev.c:2592
Code: f9 c6 05 f3 cb d9 05 01 48 c7 c7 30 fe b8 8b be 2e 0a 00 00 48 c7 c2 20 a6 b8 8b e8 0a 1e 30 f9 e9 a2 f9 ff ff e8 30 69 50 f9 <0f> 0b e9 1c f8 ff ff 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c d3 fe ff
RSP: 0000:ffffc90000067490 EFLAGS: 00010293
RAX: ffffffff88393690 RBX: 0000000000000000 RCX: ffff888140158000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
RBP: ffff888020fd4b00 R08: ffffffff88392ea5 R09: 0000000000000000
R10: fffff5200000ce18 R11: 1ffff9200000ce16 R12: ffff888020fd4b80
R13: ffff888020fd4a00 R14: 0000000000000002 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000ca8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virtnet_set_affinity+0x56e/0x730 drivers/net/virtio_net.c:2308
 init_vqs+0x107c/0x11d0 drivers/net/virtio_net.c:3581
 virtnet_probe+0x19db/0x32a0 drivers/net/virtio_net.c:3884
 virtio_dev_probe+0x8ca/0xb60 drivers/virtio/virtio.c:305
 call_driver_probe+0x96/0x250
 really_probe+0x24c/0x9f0 drivers/base/dd.c:639
 __driver_probe_device+0x1f4/0x3f0 drivers/base/dd.c:778
 driver_probe_device+0x50/0x240 drivers/base/dd.c:808
 __driver_attach+0x364/0x5b0 drivers/base/dd.c:1190
 bus_for_each_dev+0x188/0x1f0 drivers/base/bus.c:301
 bus_add_driver+0x32f/0x600 drivers/base/bus.c:618
 driver_register+0x2e9/0x3e0 drivers/base/driver.c:246
 virtio_net_driver_init+0x8e/0xcb drivers/net/virtio_net.c:4090
 do_one_initcall+0xbd/0x2b0 init/main.c:1303
 do_initcall_level+0x168/0x218 init/main.c:1376
 do_initcalls+0x4b/0x8c init/main.c:1392
 kernel_init_freeable+0x471/0x61d init/main.c:1631
 kernel_init+0x19/0x2b0 init/main.c:1519
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
