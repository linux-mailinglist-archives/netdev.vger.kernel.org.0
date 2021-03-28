Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B221B34BE5C
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 20:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhC1StA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 14:49:00 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:41398 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhC1SqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 14:46:17 -0400
Received: by mail-il1-f200.google.com with SMTP id g11so10396618ilc.8
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 11:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pt0NAS2OYaIKRaLA3YT9CDMyqSgP+XpAyCaYfthX11E=;
        b=LkxtCetZUhHIlO201SGI29FIiGouTphQuZUHOY2RCtnLbeN6JcoD1JSzpUQkI4eDS3
         4KshIEg3ZEuG3WhawEAc9wC3VBtGSCSNITdroRVdVcclG042xKdq948lahcO2Z774f0x
         N5puagA4hrHOnOIkaQ8lpAJitU8XD2oCsB6tNxcQEkx07bWgxEvv8wiXQ9xDVNmXeoON
         96jPgLUOuDm8SPGw7VbAIPnPar7mcscMFgj9pFCvnfQoM5B9gCCG1NWPhxG353QyaYDH
         VJqx+Wa7mFM21E+c4tFw2FpsL0CVFTHEwtyzZMHO/UesIwQlGT8iTv3jtWRCLPxiq6jl
         K1wg==
X-Gm-Message-State: AOAM530Y8po/aRQMQ3Vr0aCUFPFXHogFwQOcLvcPJT6emH52zvotn/sb
        +WyAiJwjvbMLTxFXn/N9FJ8wKg69+Tt/8mpCf0URfAYiRMmu
X-Google-Smtp-Source: ABdhPJwjlI1DMEks5zQ+8E8AA+QQbfTDh8qAAXkD9SPeWg/merKgtVEG9bkcm2v8bc3ynoc1VnvI8A2tPKT7aEg5eHpN9NrLBpHS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12a9:: with SMTP id f9mr12789312ilr.12.1616957176566;
 Sun, 28 Mar 2021 11:46:16 -0700 (PDT)
Date:   Sun, 28 Mar 2021 11:46:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000020595705be9d2e49@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in fib6_nh_get_excptn_bucket (3)
From:   syzbot <syzbot+f7687113afaeee05b412@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7acac4b3 Merge tag 'linux-kselftest-kunit-fixes-5.12-rc5.1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102449f6d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5adab0bdee099d7a
dashboard link: https://syzkaller.appspot.com/bug?extid=f7687113afaeee05b412

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f7687113afaeee05b412@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in fib6_nh_get_excptn_bucket+0x18b/0x1a0 net/ipv6/route.c:1622
Read of size 8 at addr ffff88801f5f22f8 by task syz-executor.1/20604

CPU: 0 PID: 20604 Comm: syz-executor.1 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 fib6_nh_get_excptn_bucket+0x18b/0x1a0 net/ipv6/route.c:1622
 fib6_nh_flush_exceptions+0x34/0x2d0 net/ipv6/route.c:1750
 fib6_nh_release+0x81/0x3c0 net/ipv6/route.c:3554
 fib6_info_destroy_rcu+0x187/0x210 net/ipv6/ip6_fib.c:174
 rcu_do_batch kernel/rcu/tree.c:2559 [inline]
 rcu_core+0x74a/0x12f0 kernel/rcu/tree.c:2794
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:197
Code: f0 4d 89 03 e9 f2 fc ff ff b9 ff ff ff ff ba 08 00 00 00 4d 8b 03 48 0f bd ca 49 8b 45 00 48 63 c9 e9 64 ff ff ff 0f 1f 40 00 <65> 8b 05 89 01 8e 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b
RSP: 0018:ffffc90008dc7948 EFLAGS: 00000216
RAX: 000000000000b35d RBX: 0000000000000000 RCX: ffffc9000aea7000
RDX: 0000000000040000 RSI: ffffffff815c086f RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8fab38a7
R10: ffffffff815c0865 R11: 0000000000000000 R12: ffffffff84b26d10
R13: 0000000000000200 R14: dffffc0000000000 R15: ffffc90008dc79a8
 console_unlock+0x805/0xc80 kernel/printk/printk.c:2586
 vprintk_emit+0x1ca/0x560 kernel/printk/printk.c:2098
 vprintk_func+0x8d/0x1e0 kernel/printk/printk_safe.c:401
 printk+0xba/0xed kernel/printk/printk.c:2146
 jfs_mount.cold+0x95/0x136 fs/jfs/jfs_mount.c:217
 jfs_fill_super+0x5bd/0xc80 fs/jfs/super.c:561
 mount_bdev+0x34d/0x410 fs/super.c:1367
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1497
 do_new_mount fs/namespace.c:2903 [inline]
 path_mount+0x132a/0x1f90 fs/namespace.c:3233
 do_mount fs/namespace.c:3246 [inline]
 __do_sys_mount fs/namespace.c:3454 [inline]
 __se_sys_mount fs/namespace.c:3431 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3431
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x46797a
Code: 48 c7 c2 bc ff ff ff f7 d8 64 89 02 b8 ff ff ff ff eb d2 e8 b8 04 00 00 0f 1f 84 00 00 00 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0603554fa8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000020000200 RCX: 000000000046797a
RDX: 0000000020000000 RSI: 0000000020000100 RDI: 00007f0603555000
RBP: 00007f0603555040 R08: 00007f0603555040 R09: 0000000020000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000020000000
R13: 0000000020000100 R14: 00007f0603555000 R15: 0000000020061000

Allocated by task 20613:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 fib6_info_alloc+0xbe/0x1d0 net/ipv6/ip6_fib.c:154
 ip6_route_info_create+0x33e/0x19d0 net/ipv6/route.c:3656
 ip6_route_add+0x24/0x150 net/ipv6/route.c:3746
 inet6_rtm_newroute+0x152/0x160 net/ipv6/route.c:5368
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3039 [inline]
 call_rcu+0xb1/0x740 kernel/rcu/tree.c:3114
 fib6_info_release include/net/ip6_fib.h:337 [inline]
 fib6_info_release include/net/ip6_fib.h:334 [inline]
 ip6_route_info_create+0x125f/0x19d0 net/ipv6/route.c:3736
 ip6_route_add+0x24/0x150 net/ipv6/route.c:3746
 inet6_rtm_newroute+0x152/0x160 net/ipv6/route.c:5368
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 insert_work+0x48/0x370 kernel/workqueue.c:1331
 __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
 queue_work_on+0xee/0x110 kernel/workqueue.c:1524
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:433
 kobject_uevent_env+0xf9f/0x1680 lib/kobject_uevent.c:617
 loop_configure+0x10cb/0x13a0 drivers/block/loop.c:255
 lo_ioctl+0x3f7/0x1620 drivers/block/loop.c:1681
 blkdev_ioctl+0x2a1/0x6d0 block/ioctl.c:583
 block_ioctl+0xf9/0x140 fs/block_dev.c:1667
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801f5f2200
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 56 bytes to the right of
 192-byte region [ffff88801f5f2200, ffff88801f5f22c0)
The buggy address belongs to the page:
page:ffffea00007d7c80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1f5f2
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00004e9980 0000000500000005 ffff888010841a00
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801f5f2180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88801f5f2200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88801f5f2280: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
                                                                ^
 ffff88801f5f2300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801f5f2380: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
