Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9867410EEE4
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbfLBSFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:05:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:33158 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfLBSFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:05:10 -0500
Received: by mail-io1-f71.google.com with SMTP id i8so210509ioi.0
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 10:05:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PbGUQ8nTe/vUiu6cf4kGFhkkHjOEBDRPBI2nuhiSG6g=;
        b=IRqwmvoqs4Xfr5KK0XEJr/LnHhiePvg0nRUGG4JkqxPu+91NcVA0usldA8wrMM47aK
         vB4wv4dMDdcksVNWoMRD+jcTtE6fVMlhvqITE6863L4RNLlfHICNbSISJyvAEcP1Fqly
         +IsCUQLX6Rtdm5seK9vCiSu/AIZFTyXGMgFTzMBvAdvgq4WbOujjMaIEbO+M02JUj7iv
         pVrghiJO0yYiqquAvpSXbvAhhBYnIu4DGiZbyieoANxfTHlMshNeYwT1CBBOzyq4/JAn
         V1RkRDTaJ8G9KtNbwT5Zw0MuHQeTwM1cXgVsx1b3jISMXLStZcdLCiX5mG5xvqETafMk
         E4Ew==
X-Gm-Message-State: APjAAAWYOttn3n1hsXtPKdnyDUDjxISwnHXqzwwDCzx/wdzPaTQOwNmW
        a/dy7CIejWmP5K7NVorLzDi9AXpm0vCCX5oGbLSvx1Jb9E0/
X-Google-Smtp-Source: APXvYqzWbnTVUclsK+5rDXU2Uwf7FL7lWcyHuAB9sr0PH7sON/HCgTlf75KUIfdweOPjpTDH2V1+In9/YhmT1GcrOcCq/gYiFNqg
MIME-Version: 1.0
X-Received: by 2002:a05:6602:156:: with SMTP id v22mr23075389iot.180.1575309908812;
 Mon, 02 Dec 2019 10:05:08 -0800 (PST)
Date:   Mon, 02 Dec 2019 10:05:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000086c2bf0598bc6bc0@google.com>
Subject: memory leak in register_netdevice
From:   syzbot <syzbot+6e13e65ffbaa33757bcb@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a6ed68d6 Merge tag 'drm-next-2019-11-27' of git://anongit...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1469ab12e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d47416a80b409a86
dashboard link: https://syzkaller.appspot.com/bug?extid=6e13e65ffbaa33757bcb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cd0b12e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e1e536e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6e13e65ffbaa33757bcb@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811736a900 (size 64):
   comm "syz-executor255", pid 6961, jiffies 4294941312 (age 18.230s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     10 a9 36 17 81 88 ff ff 10 a9 36 17 81 88 ff ff  ..6.......6.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888115549040 (size 64):
   comm "syz-executor255", pid 6968, jiffies 4294941312 (age 18.230s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     50 90 54 15 81 88 ff ff 50 90 54 15 81 88 ff ff  P.T.....P.T.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff88811736a900 (size 64):
   comm "syz-executor255", pid 6961, jiffies 4294941312 (age 19.240s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     10 a9 36 17 81 88 ff ff 10 a9 36 17 81 88 ff ff  ..6.......6.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888115549040 (size 64):
   comm "syz-executor255", pid 6968, jiffies 4294941312 (age 19.240s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     50 90 54 15 81 88 ff ff 50 90 54 15 81 88 ff ff  P.T.....P.T.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff88811736a900 (size 64):
   comm "syz-executor255", pid 6961, jiffies 4294941312 (age 21.120s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     10 a9 36 17 81 88 ff ff 10 a9 36 17 81 88 ff ff  ..6.......6.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888115549040 (size 64):
   comm "syz-executor255", pid 6968, jiffies 4294941312 (age 21.120s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     50 90 54 15 81 88 ff ff 50 90 54 15 81 88 ff ff  P.T.....P.T.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff88811736a900 (size 64):
   comm "syz-executor255", pid 6961, jiffies 4294941312 (age 22.100s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     10 a9 36 17 81 88 ff ff 10 a9 36 17 81 88 ff ff  ..6.......6.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888115549040 (size 64):
   comm "syz-executor255", pid 6968, jiffies 4294941312 (age 22.100s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     50 90 54 15 81 88 ff ff 50 90 54 15 81 88 ff ff  P.T.....P.T.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff88811736a900 (size 64):
   comm "syz-executor255", pid 6961, jiffies 4294941312 (age 23.060s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     10 a9 36 17 81 88 ff ff 10 a9 36 17 81 88 ff ff  ..6.......6.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

BUG: memory leak
unreferenced object 0xffff888115549040 (size 64):
   comm "syz-executor255", pid 6968, jiffies 4294941312 (age 23.060s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     50 90 54 15 81 88 ff ff 50 90 54 15 81 88 ff ff  P.T.....P.T.....
   backtrace:
     [<000000000bce4d97>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000bce4d97>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<000000000bce4d97>] slab_alloc mm/slab.c:3319 [inline]
     [<000000000bce4d97>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<000000005351be03>] kmalloc include/linux/slab.h:556 [inline]
     [<000000005351be03>] netdev_name_node_alloc+0x2a/0x70 net/core/dev.c:237
     [<00000000e51ce12a>] netdev_name_node_head_alloc net/core/dev.c:251  
[inline]
     [<00000000e51ce12a>] register_netdevice+0xaf/0x650 net/core/dev.c:9239
     [<000000001e7bad43>] bond_newlink  
drivers/net/bonding/bond_netlink.c:458 [inline]
     [<000000001e7bad43>] bond_newlink+0x41/0x80  
drivers/net/bonding/bond_netlink.c:448
     [<00000000651af2f0>] __rtnl_newlink+0x89a/0xb80  
net/core/rtnetlink.c:3303
     [<00000000360e9df5>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3361
     [<00000000e011064d>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5422
     [<000000007efb805f>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2477
     [<00000000bbcbc561>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5440
     [<00000000cf032e1c>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000cf032e1c>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<000000008792feaf>] netlink_sendmsg+0x29f/0x550  
net/netlink/af_netlink.c:1917
     [<00000000a2c65b59>] sock_sendmsg_nosec net/socket.c:638 [inline]
     [<00000000a2c65b59>] sock_sendmsg+0x54/0x70 net/socket.c:658
     [<000000005b5b243c>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2329
     [<000000000b7158e8>] __sys_sendmsg+0x80/0xf0 net/socket.c:2374
     [<00000000e52f982c>] __do_sys_sendmsg net/socket.c:2383 [inline]
     [<00000000e52f982c>] __se_sys_sendmsg net/socket.c:2381 [inline]
     [<00000000e52f982c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2381
     [<00000000a4e97677>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294

executing program
executing program
executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
