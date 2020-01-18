Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3ABE141877
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 17:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgARQhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 11:37:11 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:48541 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgARQhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 11:37:11 -0500
Received: by mail-il1-f198.google.com with SMTP id u14so21432609ilq.15
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 08:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mRI7zVK1vmfqHTyGy66NRP+806bcNFmvUGPkslAvTcw=;
        b=Xj4jFBwykPh4LV/KqDivSbvuRoICHSRh3YXtWN9ByYQbzXiUDWMVAVhail+JWcyM7L
         coQT8W5O/rpbD6DhvUrZnxhMfDEboS7sCYQ48z3wMNK4yCUybDlPfc51vZwt4gPAhkHr
         qX4pNkHx9GJWYe4kro4zxrozHIRaobAj7LiATZeNxXAxHzW58CFBumlyzllunVdovLyM
         2bPgOOy5doLZLYcUk2rugZa1cTxwkdcS6pNBsVlBjXuSliSQkQPjwkuJuT/+jChheJwS
         81xH/oRtWVFhZPwENLlzHRf87892icHVZSBJQId165kXX5t2eR2V3xMqCOcr7jPqJAsJ
         t/2A==
X-Gm-Message-State: APjAAAWmsPvsUbYSCplKw0caw5nGHjUDEb54kz28D2QJx9DdjD+1WDlH
        B0KV7B1bMR9V6mwCZ0v/A1ct+DRQDtYRT0DPVPQmzE+HWk7c
X-Google-Smtp-Source: APXvYqxrg1ZfnvKENQ/CVF8gSsJr59ZHo5oF/k5bmdRpEt8E+ufHK1673YpEEEdzd9YjdJWRVAapIu5+BhneDFqCcSmYiirLoSVH
MIME-Version: 1.0
X-Received: by 2002:a6b:6118:: with SMTP id v24mr36068556iob.73.1579365430292;
 Sat, 18 Jan 2020 08:37:10 -0800 (PST)
Date:   Sat, 18 Jan 2020 08:37:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000717523059c6cabc9@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ip_gc
From:   syzbot <syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        info@metux.net, jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    56f200c7 netns: Constify exported functions
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=178b74c9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=df0d0f5895ef1f41a65b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d78966e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1375b1d1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+df0d0f5895ef1f41a65b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_gc_test net/netfilter/ipset/ip_set_bitmap_ip.c:76 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_gc+0x100/0x4f0 net/netfilter/ipset/ip_set_bitmap_gen.h:277
Read of size 8 at addr ffff8880987e3280 by task syz-executor158/9973

CPU: 1 PID: 9973 Comm: syz-executor158 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_ip_gc_test net/netfilter/ipset/ip_set_bitmap_ip.c:76 [inline]
 bitmap_ip_gc+0x100/0x4f0 net/netfilter/ipset/ip_set_bitmap_gen.h:277
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:get_lock_parent_ip include/linux/ftrace.h:796 [inline]
RIP: 0010:preempt_latency_start kernel/sched/core.c:3765 [inline]
RIP: 0010:preempt_latency_start kernel/sched/core.c:3762 [inline]
RIP: 0010:preempt_count_add+0x7a/0x160 kernel/sched/core.c:3790
Code: b6 c0 3d f4 00 00 00 7f 7f 65 8b 05 a8 73 b1 7e 25 ff ff ff 7f 39 c3 74 05 5b 41 5c 5d c3 48 8b 5d 08 48 89 df e8 36 ba 0a 00 <85> c0 75 39 65 4c 8b 24 25 c0 1e 02 00 49 8d bc 24 58 12 00 00 48
RSP: 0000:ffffc900036b7b50 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffffffff81a1bea3 RCX: 1ffffffff16cec9c
RDX: 0000000000000000 RSI: ffffffff81a1be96 RDI: ffffffff81a1bea3
RBP: ffffc900036b7b60 R08: ffff888093e3c440 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 0000000000004d00
R13: 0000000000000134 R14: 0000000000000000 R15: 0000000000000000
 kmap_atomic include/linux/highmem.h:93 [inline]
 clear_user_highpage include/linux/highmem.h:160 [inline]
 clear_subpage+0x23/0x110 mm/memory.c:4673
 process_huge_page mm/memory.c:4627 [inline]
 clear_huge_page+0xb5/0x3e0 mm/memory.c:4687
 __do_huge_pmd_anonymous_page mm/huge_memory.c:596 [inline]
 do_huge_pmd_anonymous_page+0x6a6/0x1a50 mm/huge_memory.c:764
 create_huge_pmd mm/memory.c:3888 [inline]
 __handle_mm_fault+0x3145/0x3cc0 mm/memory.c:4098
 handle_mm_fault+0x3b2/0xa50 mm/memory.c:4164
 do_user_addr_fault arch/x86/mm/fault.c:1441 [inline]
 __do_page_fault+0x536/0xd80 arch/x86/mm/fault.c:1506
 do_page_fault+0x38/0x590 arch/x86/mm/fault.c:1530
 page_fault+0x39/0x40 arch/x86/entry/entry_64.S:1203
RIP: 0033:0x400713
Code: 03 00 00 00 be 10 00 00 00 bf 29 00 00 00 e8 24 0d 04 00 48 83 f8 ff 74 07 48 89 05 87 a9 2c 00 48 b8 62 69 74 6d 61 70 3a 69 <48> c7 04 25 00 03 00 20 00 00 00 00 c7 04 25 08 03 00 20 00 00 00
RSP: 002b:00007ffee78cceb0 EFLAGS: 00010213
RAX: 693a70616d746962 RBX: 0000000000000000 RCX: 0000000000441439
RDX: 000000000000000c RSI: 0000000000000003 RDI: 0000000000000010
RBP: 000000000001ba88 R08: 0000000000000004 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402260
R13: 00000000004022f0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9616:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x163/0x770 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:670 [inline]
 ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x6ec/0xc20 net/netfilter/ipset/ip_set_bitmap_ip.c:327
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9337:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 tomoyo_check_open_permission+0x19e/0x3e0 security/tomoyo/file.c:786
 tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
 tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
 security_file_open+0x71/0x300 security/security.c:1497
 do_dentry_open+0x37a/0x1380 fs/open.c:784
 vfs_open+0xa0/0xd0 fs/open.c:914
 do_last fs/namei.c:3420 [inline]
 path_openat+0x10df/0x4500 fs/namei.c:3537
 do_filp_open+0x1a1/0x280 fs/namei.c:3567
 do_sys_open+0x3fe/0x5d0 fs/open.c:1097
 __do_sys_open fs/open.c:1115 [inline]
 __se_sys_open fs/open.c:1110 [inline]
 __x64_sys_open+0x7e/0xc0 fs/open.c:1110
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880987e3280
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880987e3280, ffff8880987e32a0)
The buggy address belongs to the page:
page:ffffea000261f8c0 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff8880987e3fc1
raw: 00fffe0000000200 ffffea000287c788 ffffea00029a0648 ffff8880aa4001c0
raw: ffff8880987e3fc1 ffff8880987e3000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880987e3180: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
 ffff8880987e3200: 00 03 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880987e3280: 04 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
                   ^
 ffff8880987e3300: 00 03 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880987e3380: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
