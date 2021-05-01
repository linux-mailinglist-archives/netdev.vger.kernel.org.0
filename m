Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620F43705D6
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 08:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhEAGJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 02:09:08 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52138 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhEAGJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 02:09:06 -0400
Received: by mail-il1-f198.google.com with SMTP id i2-20020a056e021b02b029018159d70cffso397469ilv.18
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 23:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QYNQL12w8nlDdWsl7a7uYJK/eVQrZRWtohuLnhPUUFw=;
        b=gwcbjUVSwKuVc25tX9RpLqo/0RPKU+kQ3/6bb5bhGA5gQYA74LckZ85AhHDiOyn/sn
         Fruqjz2/cxeOlcuWzx9TMFimY5o+UfVHRBh307XJcADv52bRnybbFd3BC5vroIOyoLT/
         nys2CnV10iE4puR+w2EQljsjQaslAHrTo66sACpwqFjgPQZsFXpCogmzhzqlWFETK9WI
         KY4RiTgdvkIajFB7WFw/WclxZJ3mFXadLWNQO1OHLdo5Egkb6VbfxmCqmVjSkZXd+2ze
         SEevyXSnsydIHHhMF5jVQ4twaMyw0BMKIeYDOkBKaPQPSOWy7JL32TdEoHCkuFdeDVvY
         o3Zw==
X-Gm-Message-State: AOAM5317psfl5YL9l4j2n0ap2rRh+/r9S9Fm+vc6Z2vTqRObEdYd8aob
        CObX+t1A3TPBe7PYrfdvJLA/KEqIbjYqEmtjSvijiiwHeaIK
X-Google-Smtp-Source: ABdhPJxzxMnZ8YaHhfGdbW5xZYhFnD3D+VIHsNU9rtc7/uHMDUr00xzQauP/+7p/BdgNR4hALKcysSeH36eW/9YbljdIXVpSWTrO
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13d0:: with SMTP id v16mr7251690ilj.8.1619849296404;
 Fri, 30 Apr 2021 23:08:16 -0700 (PDT)
Date:   Fri, 30 Apr 2021 23:08:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6e54c05c13e8d84@google.com>
Subject: [syzbot] KMSAN: uninit-value in ax25cmp
From:   syzbot <syzbot+a6a652af5d212bb29329@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4ebaab5f kmsan: drop unneeded references to kmsan_context_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17e99e05d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=647ca0f5bbe7703a
dashboard link: https://syzkaller.appspot.com/bug?extid=a6a652af5d212bb29329
compiler:       Debian clang version 11.0.1-2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6a652af5d212bb29329@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
CPU: 0 PID: 26805 Comm: syz-executor.5 Not tainted 5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
 nr_dev_get net/netrom/nr_route.c:598 [inline]
 nr_route_frame+0x477/0x1ff0 net/netrom/nr_route.c:771
 nr_xmit+0x9c/0x270 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3605
 dev_hard_start_xmit net/core/dev.c:3621 [inline]
 __dev_queue_xmit+0x3432/0x4600 net/core/dev.c:4194
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 raw_sendmsg+0x7ce/0xcc0 net/ieee802154/socket.c:295
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55175fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020009c40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5948
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2362
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2379
 raw_sendmsg+0x459/0xcc0 net/ieee802154/socket.c:278
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================
=====================================================
BUG: KMSAN: uninit-value in ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
CPU: 0 PID: 26805 Comm: syz-executor.5 Tainted: G    B             5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
 nr_dev_get net/netrom/nr_route.c:598 [inline]
 nr_route_frame+0x477/0x1ff0 net/netrom/nr_route.c:771
 nr_xmit+0x9c/0x270 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3605
 dev_hard_start_xmit net/core/dev.c:3621 [inline]
 __dev_queue_xmit+0x3432/0x4600 net/core/dev.c:4194
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 raw_sendmsg+0x7ce/0xcc0 net/ieee802154/socket.c:295
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55175fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020009c40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5948
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2362
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2379
 raw_sendmsg+0x459/0xcc0 net/ieee802154/socket.c:278
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================
=====================================================
BUG: KMSAN: uninit-value in ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
CPU: 0 PID: 26805 Comm: syz-executor.5 Tainted: G    B             5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
 nr_dev_get net/netrom/nr_route.c:598 [inline]
 nr_route_frame+0x477/0x1ff0 net/netrom/nr_route.c:771
 nr_xmit+0x9c/0x270 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3605
 dev_hard_start_xmit net/core/dev.c:3621 [inline]
 __dev_queue_xmit+0x3432/0x4600 net/core/dev.c:4194
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 raw_sendmsg+0x7ce/0xcc0 net/ieee802154/socket.c:295
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55175fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020009c40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5948
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2362
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2379
 raw_sendmsg+0x459/0xcc0 net/ieee802154/socket.c:278
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================
=====================================================
BUG: KMSAN: uninit-value in ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
CPU: 0 PID: 26805 Comm: syz-executor.5 Tainted: G    B             5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
 nr_dev_get net/netrom/nr_route.c:598 [inline]
 nr_route_frame+0x477/0x1ff0 net/netrom/nr_route.c:771
 nr_xmit+0x9c/0x270 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3605
 dev_hard_start_xmit net/core/dev.c:3621 [inline]
 __dev_queue_xmit+0x3432/0x4600 net/core/dev.c:4194
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 raw_sendmsg+0x7ce/0xcc0 net/ieee802154/socket.c:295
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55175fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020009c40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5948
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2362
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2379
 raw_sendmsg+0x459/0xcc0 net/ieee802154/socket.c:278
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================
=====================================================
BUG: KMSAN: uninit-value in ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
CPU: 0 PID: 26805 Comm: syz-executor.5 Tainted: G    B             5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
 nr_dev_get net/netrom/nr_route.c:598 [inline]
 nr_route_frame+0x477/0x1ff0 net/netrom/nr_route.c:771
 nr_xmit+0x9c/0x270 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3605
 dev_hard_start_xmit net/core/dev.c:3621 [inline]
 __dev_queue_xmit+0x3432/0x4600 net/core/dev.c:4194
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 raw_sendmsg+0x7ce/0xcc0 net/ieee802154/socket.c:295
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55175fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020009c40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5948
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2362
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2379
 raw_sendmsg+0x459/0xcc0 net/ieee802154/socket.c:278
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================
=====================================================
BUG: KMSAN: uninit-value in ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
CPU: 0 PID: 26805 Comm: syz-executor.5 Tainted: G    B             5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ax25cmp+0x49c/0x5f0 net/ax25/ax25_addr.c:119
 nr_dev_get net/netrom/nr_route.c:598 [inline]
 nr_route_frame+0x477/0x1ff0 net/netrom/nr_route.c:771
 nr_xmit+0x9c/0x270 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3605
 dev_hard_start_xmit net/core/dev.c:3621 [inline]
 __dev_queue_xmit+0x3432/0x4600 net/core/dev.c:4194
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 raw_sendmsg+0x7ce/0xcc0 net/ieee802154/socket.c:295
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55175fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020009c40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5948
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2362
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2379
 raw_sendmsg+0x459/0xcc0 net/ieee802154/socket.c:278
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================
=====================================================
BUG: KMSAN: uninit-value in nr_route_frame+0x7c8/0x1ff0 net/netrom/nr_route.c:784
CPU: 0 PID: 26805 Comm: syz-executor.5 Tainted: G    B             5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 nr_route_frame+0x7c8/0x1ff0 net/netrom/nr_route.c:784
 nr_xmit+0x9c/0x270 net/netrom/nr_dev.c:144
 __netdev_start_xmit include/linux/netdevice.h:4825 [inline]
 netdev_start_xmit include/linux/netdevice.h:4839 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3605
 dev_hard_start_xmit net/core/dev.c:3621 [inline]
 __dev_queue_xmit+0x3432/0x4600 net/core/dev.c:4194
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 raw_sendmsg+0x7ce/0xcc0 net/ieee802154/socket.c:295
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55175fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020009c40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8e/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0xa4f/0x1470 mm/slub.c:4609
 kmalloc_reserve net/core/skbuff.c:353 [inline]
 __alloc_skb+0x4dd/0xe90 net/core/skbuff.c:424
 alloc_skb include/linux/skbuff.h:1103 [inline]
 alloc_skb_with_frags+0x1f3/0xc10 net/core/skbuff.c:5948
 sock_alloc_send_pskb+0xdc1/0xf90 net/core/sock.c:2362
 sock_alloc_send_skb+0xca/0xe0 net/core/sock.c:2379
 raw_sendmsg+0x459/0xcc0 net/ieee802154/socket.c:278
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
