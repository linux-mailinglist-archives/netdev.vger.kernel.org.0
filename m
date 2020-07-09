Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7105621A6B1
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgGISNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:13:19 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:54671 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgGISNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:13:18 -0400
Received: by mail-il1-f199.google.com with SMTP id d18so1812170ill.21
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pyvbd/KK7BQZTS7Firg+VEI35PLOt7eMHrA0xCYf7nM=;
        b=a2Uo75cDrkqpfO8J3N0TkzoEGg86yUfB0qZv19Vnf2uH/DLFywY/lfr6LaTEnnekzV
         z4U8ZqtnCiuF9xHHoUphAymoUt6rGTfByLzM6JxAoAH+mE6nlP+yublJO89btUcEYka0
         O7YiijIlDZWdv7g0vx8FVaGJTvxugwuaICnRUr671OS9Zgv60HlN/QYOpD+heRyh12oD
         z+s7ESNgmb69end7gx1o7brQzV1ZJDBti3jy2VMTPS98uPTdKz10G1YFz2ZczSsgwKf1
         sbsvVwe2No+ifK1vEXTqMNRDBHQVpBgJRptn5ZqW8hxW6+PbdOAUvl/5k2F4oJfS8S6n
         DGZA==
X-Gm-Message-State: AOAM530S96HJDyG70Em2jg48GXLf1+eqVpE73O6JR4vSxE4MSDVDkunw
        DgEwIJxLNZ/sc/yX8URHDO31UGvz1csQQ+1eyuibHlDqtfLp
X-Google-Smtp-Source: ABdhPJxlADnBCMJxDUDbylz2yOLR24h+r0EQYuzAZ5xAHR/FSLWnp7G8piW+JMlyPVjIsWauQOuTn6JbuUjMfqhd/wK+ARobH6cp
MIME-Version: 1.0
X-Received: by 2002:a5e:c801:: with SMTP id y1mr43684957iol.127.1594318397362;
 Thu, 09 Jul 2020 11:13:17 -0700 (PDT)
Date:   Thu, 09 Jul 2020 11:13:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bbd94205aa062df5@google.com>
Subject: KASAN: invalid-free in hsr_forward_skb
From:   syzbot <syzbot+9570a11cde8a3ab63444@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0bddd227 Documentation: update for gcc 4.9 requirement
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12ac618f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=9570a11cde8a3ab63444
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9570a11cde8a3ab63444@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: double-free or invalid-free in kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:622

CPU: 0 PID: 3924 Comm: systemd-udevd Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:477
 __kasan_slab_free+0x127/0x140 mm/kasan/common.c:434
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x7f/0x310 mm/slab.c:3694
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:622
 kfree_skb+0x7d/0x100 include/linux/refcount.h:270
 hsr_forward_skb+0xfcc/0x1cdd net/hsr/hsr_forward.c:371
 send_hsr_supervision_frame+0x90e/0xf40 net/hsr/hsr_device.c:302
 hsr_announce+0x125/0x390 net/hsr/hsr_device.c:330
 call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers.part.0+0x54c/0xa20 kernel/time/timer.c:1773
 __run_timers kernel/time/timer.c:1745 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1786
 __do_softirq+0x34c/0xa60 kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x111/0x170 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x229/0x270 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x54/0x120 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:587
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:765 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x8c/0xe0 kernel/locking/spinlock.c:191
Code: 48 c7 c0 80 e0 b4 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 37 48 83 3d 3b a6 cd 01 00 74 22 48 89 df 57 9d <0f> 1f 44 00 00 bf 01 00 00 00 e8 35 38 68 f9 65 8b 05 5e c4 1a 78
RSP: 0018:ffffc90001577d80 EFLAGS: 00000286
RAX: 1ffffffff1369c10 RBX: 0000000000000286 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000286
RBP: ffffffff8caee680 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8880a2123580
R13: dffffc0000000000 R14: 1ffff920002aefb5 R15: ffffffff89bc1040
 debug_object_activate+0x1b3/0x3e0 lib/debugobjects.c:670
 debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
 __call_rcu kernel/rcu/tree.c:2865 [inline]
 call_rcu+0x2c/0x7e0 kernel/rcu/tree.c:2952
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:239 [inline]
 __prepare_exit_to_usermode+0x1e9/0x1f0 arch/x86/entry/common.c:269
 do_syscall_64+0x6c/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f16d1582a07
Code: Bad RIP value.
RSP: 002b:00007fffa781f270 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000011 RCX: 00007f16d1582a07
RDX: 00007f16d1869380 RSI: 00007f16d1868b58 RDI: 0000000000000011
RBP: 00007f16d2737710 R08: 00005594e96817f0 R09: 0000000000008040
R10: 00007f16d1868b58 R11: 0000000000000202 R12: 0000000000000000
R13: 00005594e963d1f0 R14: 00000000000000fd R15: 00005594e963d1f0

Allocated by task 2574:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc_node mm/slab.c:3263 [inline]
 kmem_cache_alloc_node+0x130/0x3c0 mm/slab.c:3575
 __alloc_skb+0x71/0x550 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1083 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:500 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:557 [inline]
 nsim_dev_trap_report_work+0x2b2/0xbe0 drivers/net/netdevsim/dev.c:598
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Freed by task 2574:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x7f/0x310 mm/slab.c:3694
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:622
 __kfree_skb net/core/skbuff.c:679 [inline]
 consume_skb net/core/skbuff.c:837 [inline]
 consume_skb+0xcf/0x160 net/core/skbuff.c:831
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:573 [inline]
 nsim_dev_trap_report_work+0x889/0xbe0 drivers/net/netdevsim/dev.c:598
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff888094a80800
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 32 bytes to the right of
 224-byte region [ffff888094a80800, ffff888094a808e0)
The buggy address belongs to the page:
page:ffffea000252a000 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888094a806c0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00014327c8 ffffea00029bfc08 ffff88821b77ea80
raw: ffff888094a806c0 ffff888094a80080 000000010000000b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888094a80800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888094a80880: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff888094a80900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                   ^
 ffff888094a80980: 00 00 00 00 00 00 00 00 00 00 00 00 fb fb fb fb
 ffff888094a80a00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
