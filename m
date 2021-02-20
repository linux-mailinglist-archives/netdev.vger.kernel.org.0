Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3A43204E0
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 11:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhBTKA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 05:00:59 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:34038 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhBTKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 05:00:58 -0500
Received: by mail-io1-f72.google.com with SMTP id c3so5704801ioa.1
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 02:00:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=p9Q0YoBfajD0DYzOKJpfW+uHINHmUgk6SoT1ooBtkI0=;
        b=TWr7EmJH6DX1kuIZ1cY1qiiQFX9gCgdoULfkobYrQZdymuIT7Dgn5f4Uqszn4G0tZr
         sQkqBCb9EIAFuXNoM3ppUoUbiWvJsIpLObPb5D5IhSs5exfCD3CrVGAOmxXOKWBcaY/i
         2rRMhkqF+jrH/wVOhe4Dme/WMdPHbb98UOdVCSYnqLO/4632tLhpcea8sKdT4Qtsjnw5
         gYTOM0uV+fF4z0sUupR3tBbGQmXz+76A5L79c8uwK3vLh5bIg5+j2Tb8s61jlzATud13
         LYewhMg6YZdyZ8RPffQubRaF9sbht6MiW28JQCjlzUxU8j+ivL70dfrM6rzquqxphx0y
         2Ikw==
X-Gm-Message-State: AOAM532P+QrSeIjFQeXybrTlTVHAavuvA0YB5nFoHNm/886GdFAk5ySx
        t3Thmo8X//aDWOsTlAgaLEx32nnr4ge4uAjyuVHnwFBAHxp+
X-Google-Smtp-Source: ABdhPJyyeOIYNzNwGKsKkTnMNxaQvZM/60S+efwdFjo898ZdK8UNKRhx6MxuOREjXS4kRTOj8RIZ22o9oMSLKiwun+LSHWmTrr4f
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:483:: with SMTP id b3mr7514450ils.152.1613815217160;
 Sat, 20 Feb 2021 02:00:17 -0800 (PST)
Date:   Sat, 20 Feb 2021 02:00:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c086a505bbc1a238@google.com>
Subject: KASAN: use-after-free Write in j1939_can_recv
From:   syzbot <syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f40ddce8 Linux 5.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17073738d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e53d04227c52a0df
dashboard link: https://syzkaller.appspot.com/bug?extid=bdf710cfc41c186fdff3
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_dat: no tx connection found
vcan0: j1939_xtp_rx_dat: no rx connection found
vcan0: j1939_xtp_rx_dat: no tx connection found
vcan0: j1939_xtp_rx_dat: no rx connection found
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in kref_get include/linux/kref.h:45 [inline]
BUG: KASAN: use-after-free in j1939_priv_get net/can/j1939/main.c:170 [inline]
BUG: KASAN: use-after-free in j1939_can_recv+0x51/0x7d0 net/can/j1939/main.c:54
Write of size 4 at addr ffff888057f81058 by task syz-executor.5/17699

CPU: 0 PID: 17699 Comm: syz-executor.5 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 kref_get include/linux/kref.h:45 [inline]
 j1939_priv_get net/can/j1939/main.c:170 [inline]
 j1939_can_recv+0x51/0x7d0 net/can/j1939/main.c:54
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
 can_receive+0x2e3/0x520 net/can/af_can.c:665
 can_rcv+0x129/0x1d0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5323
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5437
 process_backlog+0x232/0x6c0 net/core/dev.c:6328
 napi_poll net/core/dev.c:6806 [inline]
 net_rx_action+0x461/0xe10 net/core/dev.c:6889
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu kernel/softirq.c:420 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
Code: 0f 1f 44 00 00 55 48 8b 74 24 08 48 89 fd 48 83 c7 18 e8 de d6 5b f8 48 89 ef e8 86 8b 5c f8 e8 91 b1 7b f8 fb bf 01 00 00 00 <e8> c6 92 50 f8 65 8b 05 bf f8 04 77 85 c0 74 02 5d c3 e8 4b 4e 03
RSP: 0018:ffffc9000b50f880 EFLAGS: 00000202
RAX: 0000000000001967 RBX: 0000000000000001 RCX: 1ffffffff1b46a19
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff8880b9c34c40 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8178a8b8 R11: 0000000000000000 R12: ffff8880b9c34c40
R13: ffff8880119b1bc0 R14: ffff888028b51500 R15: ffff88806451d340
 finish_lock_switch kernel/sched/core.c:4079 [inline]
 finish_task_switch.isra.0+0x158/0x7e0 kernel/sched/core.c:4196
 context_switch kernel/sched/core.c:4330 [inline]
 __schedule+0x914/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 freezable_schedule include/linux/freezer.h:172 [inline]
 futex_wait_queue_me+0x2a7/0x570 kernel/futex.c:2606
 futex_wait+0x1db/0x580 kernel/futex.c:2708
 do_futex+0x15d/0x1700 kernel/futex.c:3736
 __do_sys_futex_time32 kernel/futex.c:3989 [inline]
 __se_sys_futex_time32 kernel/futex.c:3961 [inline]
 __ia32_sys_futex_time32+0x321/0x530 kernel/futex.c:3961
 do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:139
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f15549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f550f67c EFLAGS: 00000296 ORIG_RAX: 00000000000000f0
RAX: ffffffffffffffda RBX: 000000000818afc8 RCX: 0000000000000080
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000818afcc
RBP: 0000000000000081 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 17710:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kmalloc include/linux/slab.h:552 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 j1939_priv_create net/can/j1939/main.c:124 [inline]
 j1939_netdev_start+0xfc/0x730 net/can/j1939/main.c:260
 j1939_sk_bind+0x9c0/0xec0 net/can/j1939/socket.c:484
 __sys_bind+0x1e9/0x250 net/socket.c:1635
 __do_sys_bind net/socket.c:1646 [inline]
 __se_sys_bind net/socket.c:1644 [inline]
 __ia32_sys_bind+0x6e/0xb0 net/socket.c:1644
 do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:139
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Freed by task 17704:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:192 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3143 [inline]
 kfree+0xdb/0x3b0 mm/slub.c:4139
 kref_put include/linux/kref.h:65 [inline]
 j1939_priv_put+0x78/0xa0 net/can/j1939/main.c:165
 j1939_sk_sock_destruct+0x44/0x90 net/can/j1939/socket.c:370
 __sk_destruct+0x4b/0x900 net/core/sock.c:1778
 sk_destruct+0xbd/0xe0 net/core/sock.c:1822
 __sk_free+0xef/0x3d0 net/core/sock.c:1833
 sk_free+0x78/0xa0 net/core/sock.c:1844
 sock_put include/net/sock.h:1797 [inline]
 j1939_sk_release+0x519/0x790 net/can/j1939/socket.c:645
 __sock_release+0xcd/0x280 net/socket.c:597
 sock_close+0x18/0x20 net/socket.c:1256
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 __do_fast_syscall_32+0x62/0x80 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

The buggy address belongs to the object at ffff888057f80000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4184 bytes inside of
 8192-byte region [ffff888057f80000, ffff888057f82000)
The buggy address belongs to the page:
page:0000000047611f6c refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x57f80
head:0000000047611f6c order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 0000000000000000 0000000100000001 ffff888010c42280
raw: 0000000000000000 0000000000020002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888057f80f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888057f80f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888057f81000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888057f81080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888057f81100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
