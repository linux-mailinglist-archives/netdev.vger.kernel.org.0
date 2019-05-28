Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 526192BC8B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 02:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfE1AsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 20:48:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:50116 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbfE1AsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 20:48:08 -0400
Received: by mail-io1-f69.google.com with SMTP id l9so4454589iok.16
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 17:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yPmxIq3NyzTYtlCb8AuqxWY4zBaFAfoMF8379hewuKk=;
        b=k90dL1hIhLMfExRvskbDl5OCvvmc/dmR/kRyZFWcpUJLi/NEDYly3zv5zlnWKvcswf
         AI8FrqUX2PvNp/ArmNNXixeShVXCz6XsIiF23XgNEsDTx5bcs+/gYMpflYMoWSqz2UL6
         Ed5wS2J7ETixPEx91Es/b5mdmQszL6ncoZpDcC8811hBDstWkXpHffB158UuawlAu9cw
         pmHq02H6a5higtsC4PsPhGBZ1DnNr5VjoaNutTamVyjZ4wYbPWwddjtOrrDF6b11NhkT
         EAQ1HZDX1argBY3nAuw5Ch65SK95zZgpeu18otkOJLfIY46b/vXWuuQ8Im9tEIbOWUW4
         x+Cg==
X-Gm-Message-State: APjAAAX6sSEZ5pk/2WOD+Rwr7MCTzqgQlX8ApGFeyB9FXRKpbBNz26OK
        a/dcvR4KldU+T39dHOJ6lEuCrCDZY4SmPLQdlVQxdyxierFJ
X-Google-Smtp-Source: APXvYqxvjz8gk18lqzFJxbaQjfxYJcBxGk6qVxoNsHAgXRVYn6r51H/AEhFN1CyN9OsE2C40hfqqKew6IjNPTmOoeancEkoUS0Hl
MIME-Version: 1.0
X-Received: by 2002:a24:f68b:: with SMTP id u133mr1294819ith.139.1559004485778;
 Mon, 27 May 2019 17:48:05 -0700 (PDT)
Date:   Mon, 27 May 2019 17:48:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009412c60589e804d8@google.com>
Subject: memory leak in nr_create
From:   syzbot <syzbot+10f1194569953b72f1ae@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    54dee406 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1456f282a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=10f1194569953b72f1ae
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b0aae4a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16537ae4a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+10f1194569953b72f1ae@syzkaller.appspotmail.com

ady
BUG: memory leak
unreferenced object 0xffff88810b5f0800 (size 2048):
   comm "syz-executor801", pid 7213, jiffies 4294942993 (age 23.690s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<00000000bb1743b5>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000bb1743b5>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000bb1743b5>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000bb1743b5>] __do_kmalloc mm/slab.c:3658 [inline]
     [<00000000bb1743b5>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
     [<00000000f4997f7c>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000f4997f7c>] sk_prot_alloc+0xd6/0x170 net/core/sock.c:1608
     [<0000000061de5feb>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
     [<000000006f76d0bc>] nr_create+0x6e/0x1b0 net/netrom/af_netrom.c:436
     [<00000000a16d61dc>] __sock_create+0x164/0x250 net/socket.c:1430
     [<000000004c041309>] sock_create net/socket.c:1481 [inline]
     [<000000004c041309>] __sys_socket+0x69/0x110 net/socket.c:1523
     [<0000000048a2d41e>] __do_sys_socket net/socket.c:1532 [inline]
     [<0000000048a2d41e>] __se_sys_socket net/socket.c:1530 [inline]
     [<0000000048a2d41e>] __x64_sys_socket+0x1e/0x30 net/socket.c:1530
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888109139be0 (size 32):
   comm "syz-executor801", pid 7213, jiffies 4294942993 (age 23.690s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     e0 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000095f877e7>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000095f877e7>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000095f877e7>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5059
     [<0000000021ca56d4>] security_sk_alloc+0x49/0x70  
security/security.c:2030
     [<00000000f5063317>] sk_prot_alloc+0xf1/0x170 net/core/sock.c:1611
     [<0000000061de5feb>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
     [<000000006f76d0bc>] nr_create+0x6e/0x1b0 net/netrom/af_netrom.c:436
     [<00000000a16d61dc>] __sock_create+0x164/0x250 net/socket.c:1430
     [<000000004c041309>] sock_create net/socket.c:1481 [inline]
     [<000000004c041309>] __sys_socket+0x69/0x110 net/socket.c:1523
     [<0000000048a2d41e>] __do_sys_socket net/socket.c:1532 [inline]
     [<0000000048a2d41e>] __se_sys_socket net/socket.c:1530 [inline]
     [<0000000048a2d41e>] __x64_sys_socket+0x1e/0x30 net/socket.c:1530
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888120fce800 (size 2048):
   comm "softirq", pid 0, jiffies 4294943004 (age 23.580s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     06 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<00000000bb1743b5>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000bb1743b5>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000bb1743b5>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000bb1743b5>] __do_kmalloc mm/slab.c:3658 [inline]
     [<00000000bb1743b5>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
     [<00000000f4997f7c>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000f4997f7c>] sk_prot_alloc+0xd6/0x170 net/core/sock.c:1608
     [<0000000061de5feb>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
     [<00000000f2582c54>] nr_make_new net/netrom/af_netrom.c:479 [inline]
     [<00000000f2582c54>] nr_rx_frame+0x3ba/0x8a0 net/netrom/af_netrom.c:962
     [<0000000079aca691>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:62
     [<000000009da630cc>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<00000000dee8d9cf>] expire_timers kernel/time/timer.c:1366 [inline]
     [<00000000dee8d9cf>] __run_timers kernel/time/timer.c:1685 [inline]
     [<00000000dee8d9cf>] __run_timers kernel/time/timer.c:1653 [inline]
     [<00000000dee8d9cf>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<0000000089273632>] __do_softirq+0x115/0x35e kernel/softirq.c:293
     [<00000000b3927148>] invoke_softirq kernel/softirq.c:374 [inline]
     [<00000000b3927148>] irq_exit+0xbb/0xe0 kernel/softirq.c:414
     [<000000008e5c55b6>] exiting_irq arch/x86/include/asm/apic.h:536  
[inline]
     [<000000008e5c55b6>] smp_apic_timer_interrupt+0x7b/0x170  
arch/x86/kernel/apic/apic.c:1068
     [<00000000b4fec25d>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:806
     [<00000000bd475427>] __write_once_size include/linux/compiler.h:221  
[inline]
     [<00000000bd475427>] __sanitizer_cov_trace_pc+0x4b/0x50  
kernel/kcov.c:110
     [<0000000003cb308e>] string_nocheck+0x44/0xb0 lib/vsprintf.c:608
     [<0000000037c7e052>] string+0x6a/0x70 lib/vsprintf.c:668
     [<000000009a6fc640>] vsnprintf+0x385/0x6f0 lib/vsprintf.c:2503
     [<000000007bdc78c5>] tomoyo_supervisor+0xad/0x7f0  
security/tomoyo/common.c:2067

BUG: memory leak
unreferenced object 0xffff88811e9a73c0 (size 32):
   comm "softirq", pid 0, jiffies 4294943004 (age 23.580s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     03 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000095f877e7>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000095f877e7>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000095f877e7>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5059
     [<0000000021ca56d4>] security_sk_alloc+0x49/0x70  
security/security.c:2030
     [<00000000f5063317>] sk_prot_alloc+0xf1/0x170 net/core/sock.c:1611
     [<0000000061de5feb>] sk_alloc+0x35/0x2f0 net/core/sock.c:1662
     [<00000000f2582c54>] nr_make_new net/netrom/af_netrom.c:479 [inline]
     [<00000000f2582c54>] nr_rx_frame+0x3ba/0x8a0 net/netrom/af_netrom.c:962
     [<0000000079aca691>] nr_loopback_timer+0x4e/0xd0  
net/netrom/nr_loopback.c:62
     [<000000009da630cc>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<00000000dee8d9cf>] expire_timers kernel/time/timer.c:1366 [inline]
     [<00000000dee8d9cf>] __run_timers kernel/time/timer.c:1685 [inline]
     [<00000000dee8d9cf>] __run_timers kernel/time/timer.c:1653 [inline]
     [<00000000dee8d9cf>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<0000000089273632>] __do_softirq+0x115/0x35e kernel/softirq.c:293
     [<00000000b3927148>] invoke_softirq kernel/softirq.c:374 [inline]
     [<00000000b3927148>] irq_exit+0xbb/0xe0 kernel/softirq.c:414
     [<000000008e5c55b6>] exiting_irq arch/x86/include/asm/apic.h:536  
[inline]
     [<000000008e5c55b6>] smp_apic_timer_interrupt+0x7b/0x170  
arch/x86/kernel/apic/apic.c:1068
     [<00000000b4fec25d>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:806
     [<00000000bd475427>] __write_once_size include/linux/compiler.h:221  
[inline]
     [<00000000bd475427>] __sanitizer_cov_trace_pc+0x4b/0x50  
kernel/kcov.c:110
     [<0000000003cb308e>] string_nocheck+0x44/0xb0 lib/vsprintf.c:608
     [<0000000037c7e052>] string+0x6a/0x70 lib/vsprintf.c:668

BUG: memory leak
unreferenced object 0xffff88810ae65780 (size 64):
   comm "softirq", pid 0, jiffies 4294942649 (age 35.950s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 8c e0 0c 81 88 ff ff  ................
     00 00 00 00 00 00 00 00 80 81 15 83 ff ff ff ff  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003790970e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003790970e>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003790970e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<000000008f0a408e>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000001fe399b1>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001a2f6b25>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000000f8bd2dc>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<000000003b5b299c>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff88810a1db400 (size 128):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 34.950s)
   hex dump (first 32 bytes):
     f0 98 34 0a 81 88 ff ff f0 98 34 0a 81 88 ff ff  ..4.......4.....
     ee 9b 0a 4e bd 89 1e 3c 3d c8 d1 d3 ff ff ff ff  ...N...<=.......
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000e0f31747>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000e0f31747>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000070aeb3a4>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888108803fc0 (size 64):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 34.950s)
   hex dump (first 32 bytes):
     80 d2 e9 0a 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 90 34 0a 81 88 ff ff c0 98 34 0a 81 88 ff ff  ..4.......4.....
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000096290fbb>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000096290fbb>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000096290fbb>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000fca6bf57>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ae65780 (size 64):
   comm "softirq", pid 0, jiffies 4294942649 (age 36.020s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 8c e0 0c 81 88 ff ff  ................
     00 00 00 00 00 00 00 00 80 81 15 83 ff ff ff ff  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003790970e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003790970e>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003790970e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<000000008f0a408e>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000001fe399b1>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001a2f6b25>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000000f8bd2dc>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<000000003b5b299c>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff88810a1db400 (size 128):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.010s)
   hex dump (first 32 bytes):
     f0 98 34 0a 81 88 ff ff f0 98 34 0a 81 88 ff ff  ..4.......4.....
     ee 9b 0a 4e bd 89 1e 3c 3d c8 d1 d3 ff ff ff ff  ...N...<=.......
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000e0f31747>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000e0f31747>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000070aeb3a4>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888108803fc0 (size 64):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.010s)
   hex dump (first 32 bytes):
     80 d2 e9 0a 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 90 34 0a 81 88 ff ff c0 98 34 0a 81 88 ff ff  ..4.......4.....
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000096290fbb>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000096290fbb>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000096290fbb>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000fca6bf57>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ae65780 (size 64):
   comm "softirq", pid 0, jiffies 4294942649 (age 36.080s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 8c e0 0c 81 88 ff ff  ................
     00 00 00 00 00 00 00 00 80 81 15 83 ff ff ff ff  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003790970e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003790970e>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003790970e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<000000008f0a408e>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000001fe399b1>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001a2f6b25>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000000f8bd2dc>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<000000003b5b299c>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff88810a1db400 (size 128):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.070s)
   hex dump (first 32 bytes):
     f0 98 34 0a 81 88 ff ff f0 98 34 0a 81 88 ff ff  ..4.......4.....
     ee 9b 0a 4e bd 89 1e 3c 3d c8 d1 d3 ff ff ff ff  ...N...<=.......
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000e0f31747>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000e0f31747>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000070aeb3a4>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888108803fc0 (size 64):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.070s)
   hex dump (first 32 bytes):
     80 d2 e9 0a 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 90 34 0a 81 88 ff ff c0 98 34 0a 81 88 ff ff  ..4.......4.....
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000096290fbb>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000096290fbb>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000096290fbb>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000fca6bf57>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ae65780 (size 64):
   comm "softirq", pid 0, jiffies 4294942649 (age 36.140s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 8c e0 0c 81 88 ff ff  ................
     00 00 00 00 00 00 00 00 80 81 15 83 ff ff ff ff  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003790970e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003790970e>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003790970e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<000000008f0a408e>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000001fe399b1>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001a2f6b25>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000000f8bd2dc>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<000000003b5b299c>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff88810a1db400 (size 128):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.130s)
   hex dump (first 32 bytes):
     f0 98 34 0a 81 88 ff ff f0 98 34 0a 81 88 ff ff  ..4.......4.....
     ee 9b 0a 4e bd 89 1e 3c 3d c8 d1 d3 ff ff ff ff  ...N...<=.......
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000e0f31747>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000e0f31747>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000070aeb3a4>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888108803fc0 (size 64):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.130s)
   hex dump (first 32 bytes):
     80 d2 e9 0a 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 90 34 0a 81 88 ff ff c0 98 34 0a 81 88 ff ff  ..4.......4.....
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000096290fbb>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000096290fbb>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000096290fbb>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000fca6bf57>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ae65780 (size 64):
   comm "softirq", pid 0, jiffies 4294942649 (age 36.200s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 8c e0 0c 81 88 ff ff  ................
     00 00 00 00 00 00 00 00 80 81 15 83 ff ff ff ff  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003790970e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003790970e>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003790970e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<000000008f0a408e>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000001fe399b1>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001a2f6b25>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000000f8bd2dc>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<000000003b5b299c>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff88810a1db400 (size 128):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.190s)
   hex dump (first 32 bytes):
     f0 98 34 0a 81 88 ff ff f0 98 34 0a 81 88 ff ff  ..4.......4.....
     ee 9b 0a 4e bd 89 1e 3c 3d c8 d1 d3 ff ff ff ff  ...N...<=.......
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000e0f31747>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000e0f31747>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000070aeb3a4>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888108803fc0 (size 64):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.190s)
   hex dump (first 32 bytes):
     80 d2 e9 0a 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 90 34 0a 81 88 ff ff c0 98 34 0a 81 88 ff ff  ..4.......4.....
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000096290fbb>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000096290fbb>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000096290fbb>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000fca6bf57>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ae65780 (size 64):
   comm "softirq", pid 0, jiffies 4294942649 (age 36.260s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 8c e0 0c 81 88 ff ff  ................
     00 00 00 00 00 00 00 00 80 81 15 83 ff ff ff ff  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003790970e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003790970e>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003790970e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<000000008f0a408e>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000001fe399b1>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001a2f6b25>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000000f8bd2dc>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<000000003b5b299c>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff88810a1db400 (size 128):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.250s)
   hex dump (first 32 bytes):
     f0 98 34 0a 81 88 ff ff f0 98 34 0a 81 88 ff ff  ..4.......4.....
     ee 9b 0a 4e bd 89 1e 3c 3d c8 d1 d3 ff ff ff ff  ...N...<=.......
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000e0f31747>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000e0f31747>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000070aeb3a4>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888108803fc0 (size 64):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.250s)
   hex dump (first 32 bytes):
     80 d2 e9 0a 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 90 34 0a 81 88 ff ff c0 98 34 0a 81 88 ff ff  ..4.......4.....
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000096290fbb>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000096290fbb>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000096290fbb>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000fca6bf57>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ae65780 (size 64):
   comm "softirq", pid 0, jiffies 4294942649 (age 36.320s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 8c e0 0c 81 88 ff ff  ................
     00 00 00 00 00 00 00 00 80 81 15 83 ff ff ff ff  ................
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000003790970e>] kmalloc include/linux/slab.h:547 [inline]
     [<000000003790970e>] kzalloc include/linux/slab.h:742 [inline]
     [<000000003790970e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<000000008f0a408e>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000001fe399b1>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001a2f6b25>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000000f8bd2dc>] register_netdevice+0xbf/0x600 net/core/dev.c:8673
     [<000000003b5b299c>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3203
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972

BUG: memory leak
unreferenced object 0xffff88810a1db400 (size 128):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.310s)
   hex dump (first 32 bytes):
     f0 98 34 0a 81 88 ff ff f0 98 34 0a 81 88 ff ff  ..4.......4.....
     ee 9b 0a 4e bd 89 1e 3c 3d c8 d1 d3 ff ff ff ff  ...N...<=.......
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000e0f31747>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000e0f31747>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<0000000070aeb3a4>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888108803fc0 (size 64):
   comm "syz-executor801", pid 7176, jiffies 4294942750 (age 35.310s)
   hex dump (first 32 bytes):
     80 d2 e9 0a 81 88 ff ff 00 02 00 00 00 00 ad de  ................
     00 90 34 0a 81 88 ff ff c0 98 34 0a 81 88 ff ff  ..4.......4.....
   backtrace:
     [<000000000ab627d1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000000ab627d1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000ab627d1>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000ab627d1>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000096290fbb>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000096290fbb>] kzalloc include/linux/slab.h:742 [inline]
     [<0000000096290fbb>] hsr_add_port+0xe7/0x220 net/hsr/hsr_slave.c:142
     [<00000000fca6bf57>] hsr_dev_finalize+0x14f/0x233  
net/hsr/hsr_device.c:472
     [<0000000082f8e7a6>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000e7d4dcbc>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3191
     [<000000009cf2817a>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3249
     [<00000000833c3914>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5218
     [<00000000896b4782>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2486
     [<0000000005a62f49>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
     [<00000000cac98b75>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1311 [inline]
     [<00000000cac98b75>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1337
     [<000000009a2fddd5>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1926
     [<00000000deea8a81>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000deea8a81>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<00000000b1c7fdc9>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<00000000e21f16b4>] __do_sys_sendto net/socket.c:1976 [inline]
     [<00000000e21f16b4>] __se_sys_sendto net/socket.c:1972 [inline]
     [<00000000e21f16b4>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<00000000c9627c63>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007715eec0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
