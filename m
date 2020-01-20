Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A626142A5D
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgATMRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:17:11 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:56086 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgATMRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 07:17:10 -0500
Received: by mail-io1-f71.google.com with SMTP id z21so19586004iob.22
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 04:17:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Vkx1X/uhypGcfwV4uVIachDeWGXHsTal5Hm4vIDjIpQ=;
        b=MOJGH274q+cxKdvu5MptKO1um0uZp4q9t3JR2ACS4o5/dteULPhvc8EnaA4fhrTMN6
         I8yAcNhmk3tSkogUwi8XtvG3cs4n/8abBPG4TWAZ5z7WaUm+dGY3hCcVXyU51HPBo8Zu
         qooZEiAw7Z/kEPStNqlLbOrbfu0oC6wVY25d+BB+SfCjoNoJn0y4O9UizyM+zRarolyG
         MbLr7VJ9G+2LuvI1DtBX6crnjT9J+ZAzFy/PSQ+ySznIJSK+ea/yVg28kuhMVr2Y7A21
         S1oNdGgYaKbNRkr/bBE5/fo6c//X5NzuiISLewc3bTJlPesU+ltmLKIfu/JIWY+bEmNg
         ONvQ==
X-Gm-Message-State: APjAAAU4BZ4WR7B9relDPVBFaBFt1cB/pos8Mt885tqlNb3mul/XSywO
        CZqVC9G9LOqo+0dMT0QL1m3B//DENaya2H1vUOcjxUPpQXs6
X-Google-Smtp-Source: APXvYqwilhB1JHiupE5U//dbWs3ax4JsiMGoYOFU/8NJJzes44K+HaTtsYE4mfxkS6OLb++qrdSNj7JpkZCnI5doRmqJZzeiMc0L
MIME-Version: 1.0
X-Received: by 2002:a02:a60e:: with SMTP id c14mr44602708jam.80.1579522629805;
 Mon, 20 Jan 2020 04:17:09 -0800 (PST)
Date:   Mon, 20 Jan 2020 04:17:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000043aa29059c91459e@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ipmac_gc
From:   syzbot <syzbot+c1a1fb435465986efe35@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        info@metux.net, jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sbrivio@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b3f7e3f2 Merge ra.kernel.org:/pub/scm/linux/kernel/git/net..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17b4e966e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=25af05ec22c1bcef
dashboard link: https://syzkaller.appspot.com/bug?extid=c1a1fb435465986efe35
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d00685e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d471d1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c1a1fb435465986efe35@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ipmac_gc_test net/netfilter/ipset/ip_set_bitmap_ipmac.c:102 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ipmac_gc+0x119/0x590 net/netfilter/ipset/ip_set_bitmap_gen.h:277
Read of size 8 at addr ffff8880a97e9cc0 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.5.0-rc6-syzkaller #0
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
 bitmap_ipmac_gc_test net/netfilter/ipset/ip_set_bitmap_ipmac.c:102 [inline]
 bitmap_ipmac_gc+0x119/0x590 net/netfilter/ipset/ip_set_bitmap_gen.h:277
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
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x4f/0x80 kernel/locking/spinlock.c:199
Code: c0 a8 33 93 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 33 48 83 3d b2 9f b9 01 00 74 20 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 37 01 77 f9 65 8b 05 78 8a 28 78 85 c0 74 06 41
RSP: 0018:ffffc90000d3fc68 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1326675 RBX: ffff8880a99fc340 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffff8880a99fcbd4
RBP: ffffc90000d3fc70 R08: ffff8880a99fc340 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880ae937340
R13: ffff8880a64a05c0 R14: 0000000000000000 R15: 0000000000000001
 finish_lock_switch kernel/sched/core.c:3124 [inline]
 finish_task_switch+0x147/0x750 kernel/sched/core.c:3224
 context_switch kernel/sched/core.c:3388 [inline]
 __schedule+0x93c/0x1f90 kernel/sched/core.c:4081
 schedule_idle+0x58/0x90 kernel/sched/core.c:4183
 do_idle+0x35e/0x6e0 kernel/sched/idle.c:293
 cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
 start_secondary+0x2f4/0x410 arch/x86/kernel/smpboot.c:264
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242

Allocated by task 9651:
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
 init_map_ipmac net/netfilter/ipset/ip_set_bitmap_ipmac.c:302 [inline]
 bitmap_ipmac_create+0x4e8/0xa00 net/netfilter/ipset/ip_set_bitmap_ipmac.c:365
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

Freed by task 9407:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 load_elf_binary+0x61c/0x5310 fs/binfmt_elf.c:760
 search_binary_handler fs/exec.c:1658 [inline]
 search_binary_handler+0x16d/0x570 fs/exec.c:1635
 exec_binprm fs/exec.c:1701 [inline]
 __do_execve_file.isra.0+0x1329/0x22b0 fs/exec.c:1821
 do_execveat_common fs/exec.c:1867 [inline]
 do_execve fs/exec.c:1884 [inline]
 __do_sys_execve fs/exec.c:1960 [inline]
 __se_sys_execve fs/exec.c:1955 [inline]
 __x64_sys_execve+0x8f/0xc0 fs/exec.c:1955
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a97e9cc0
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a97e9cc0, ffff8880a97e9ce0)
The buggy address belongs to the page:
page:ffffea0002a5fa40 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff8880a97e9fc1
raw: 00fffe0000000200 ffffea0002a4cac8 ffffea000291ca88 ffff8880aa4001c0
raw: ffff8880a97e9fc1 ffff8880a97e9000 000000010000002f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a97e9b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a97e9c00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a97e9c80: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff8880a97e9d00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a97e9d80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
