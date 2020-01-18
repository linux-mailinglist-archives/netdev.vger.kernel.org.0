Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5DE3141879
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 17:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgARQhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 11:37:11 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:39893 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgARQhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 11:37:11 -0500
Received: by mail-il1-f197.google.com with SMTP id n6so21552328ile.6
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 08:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lNtRQ0jI/igL0n3PZ+IlH/LG/21iszHcJ+hCngwtozk=;
        b=gKmm/6XcqyIu9nG7VCVnKx5u3QAp5GYyIFppeQNAG0UsaUBJ+1DCbbyvtlB6I8pUxO
         h9AyIEFYu1MydE25FH5w2lfHu183JA734B/XQEWjVB6SrkRZFt/RFUVyX18O3rY452sJ
         IELXprjISQ1NFWA8p57yXpmE9Equ67baki+JzFJnwLHCC+7o3v6m4GFUunKngJ0SmjeN
         T8iggCiz1RtbIP0R/O7yV3RIOh1XTl8kt7/fllKXolX7i5hBNiV1YPLQTD3A/GstP0Tf
         lqSwrUXExRjs+DCs5EdakE+Kx5klg/7U+CAXV6US8WWz4q8HbWj069/rwJ7TkvZ4khp9
         obmw==
X-Gm-Message-State: APjAAAUw8wKoA98zF8oqCZ42PjX6y71ai8ifna+bSH7/IH51zSXYNqtM
        9Xawy+jUVYhHoouThFj9yFN9wVud8uEZcHl1pCkheFi6ajtM
X-Google-Smtp-Source: APXvYqxHC5Ty2bRr5vrOtYkG6jSCjY58wk+qjK6uyLjR6pzBS1pq71NgzNYb7xoK9fedeNl3qGM25FeKQ4szp5IE9afjeeDyahc7
MIME-Version: 1.0
X-Received: by 2002:a5d:9697:: with SMTP id m23mr26762520ion.45.1579365430058;
 Sat, 18 Jan 2020 08:37:10 -0800 (PST)
Date:   Sat, 18 Jan 2020 08:37:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006de432059c6cabb1@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_port_gc
From:   syzbot <syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        gregkh@linuxfoundation.org, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    25e73aad Merge tag 'io_uring-5.5-2020-01-16' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1788b166e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=53cdd0ec0bbabd53370a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16da6faee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115e8faee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+53cdd0ec0bbabd53370a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_port_gc_test net/netfilter/ipset/ip_set_bitmap_port.c:67 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_port_gc+0x112/0x4f0 net/netfilter/ipset/ip_set_bitmap_gen.h:277
Read of size 8 at addr ffff8880a3f9abc0 by task syz-executor663/10036

CPU: 0 PID: 10036 Comm: syz-executor663 Not tainted 5.5.0-rc6-syzkaller #0
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
 bitmap_port_gc_test net/netfilter/ipset/ip_set_bitmap_port.c:67 [inline]
 bitmap_port_gc+0x112/0x4f0 net/netfilter/ipset/ip_set_bitmap_gen.h:277
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
RIP: 0010:write_comp_data+0x1e/0x70 kernel/kcov.c:208
Code: 48 89 34 d1 48 89 11 5d c3 0f 1f 00 65 4c 8b 04 25 c0 1e 02 00 65 8b 05 a8 28 8d 7e a9 00 01 1f 00 75 51 41 8b 80 80 13 00 00 <83> f8 03 75 45 49 8b 80 88 13 00 00 45 8b 80 84 13 00 00 4c 8b 08
RSP: 0000:ffffc90003777e00 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff819ffb83
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000005
RBP: ffffc90003777e08 R08: ffff88808f8e6040 R09: fffffbfff165e7ae
R10: ffff88808f8e68d8 R11: ffff88808f8e6040 R12: 0000000000000001
R13: 00000000006cb090 R14: dffffc0000000000 R15: ffff888095bf7000
 vmacache_find+0x243/0x310 mm/vmacache.c:85
 find_vma+0x23/0x170 mm/mmap.c:2223
 do_user_addr_fault arch/x86/mm/fault.c:1402 [inline]
 __do_page_fault+0x37a/0xd80 arch/x86/mm/fault.c:1506
 do_page_fault+0x38/0x590 arch/x86/mm/fault.c:1530
 page_fault+0x39/0x40 arch/x86/entry/entry_64.S:1203
RIP: 0033:0x400702
Code: 01 00 00 00 e8 ef 09 00 00 31 c0 b9 0c 00 00 00 ba 03 00 00 00 be 10 00 00 00 bf 29 00 00 00 e8 84 0c 04 00 48 83 f8 ff 74 07 <48> 89 05 87 a9 2c 00 48 b8 62 69 74 6d 61 70 3a 70 48 c7 04 25 40
RSP: 002b:00007fffcf827620 EFLAGS: 00010213
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000441399
RDX: 000000000000000c RSI: 0000000000000003 RDI: 0000000000000010
RBP: 00000000000185b9 R08: 0000000000000004 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021c0
R13: 0000000000402250 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9665:
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
 init_map_port net/netfilter/ipset/ip_set_bitmap_port.c:234 [inline]
 bitmap_port_create+0x3dc/0x7c0 net/netfilter/ipset/ip_set_bitmap_port.c:276
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9391:
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
 do_last fs/namei.c:3356 [inline]
 path_openat+0x118b/0x3180 fs/namei.c:3473
 do_filp_open+0x1a1/0x280 fs/namei.c:3503
 do_sys_open+0x3fe/0x5d0 fs/open.c:1097
 __do_sys_open fs/open.c:1115 [inline]
 __se_sys_open fs/open.c:1110 [inline]
 __x64_sys_open+0x7e/0xc0 fs/open.c:1110
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a3f9abc0
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a3f9abc0, ffff8880a3f9abe0)
The buggy address belongs to the page:
page:ffffea00028fe680 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff8880a3f9afc1
raw: 00fffe0000000200 ffffea00025ac3c8 ffffea0002a00088 ffff8880aa4001c0
raw: ffff8880a3f9afc1 ffff8880a3f9a000 000000010000002f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a3f9aa80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a3f9ab00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a3f9ab80: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff8880a3f9ac00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a3f9ac80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
