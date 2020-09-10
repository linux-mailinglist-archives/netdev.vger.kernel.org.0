Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E276265150
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgIJUvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:51:24 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:35107 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730770AbgIJO6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:58:23 -0400
Received: by mail-io1-f78.google.com with SMTP id e83so4529929ioa.2
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/RudVQuIhnh/vW9VJ8SuHXcf7LCswYZ0o+NVwdKAA7U=;
        b=TrZk9O55+GlLcDkqOCiIikjXG1F+Cnir96tBzSjYmK++umCo1k/AQCkrvo6kiliBlC
         Uv8UBIzTy/dys2TgM/RTizwYYSWsq2aBw0s/Bk3TUYsBc5psEAiw0hWGG+eYqss6eHi2
         IUzmJD2bTclWSVuf4NIbtpod4F37r2Zm416Ek9R4z8DB6j9FvVWqt3fbrt4as2shf3S1
         opqHdaZGAhQBvWuQRryw0T2+ynF5N70VTiTtcumJnHQZ9pVYJMTh6SEp69jZepvtbDwj
         DStEBDt3LOI0PunVsmDbPkBGAniRANV8YfvqCo8kp0rJYdHD8FjOjCsJIOF2LaIF5/T/
         jiEw==
X-Gm-Message-State: AOAM530vam/xe+UZrU0bqz+uNCy0O2sY6B4gKqU6i6wdqJvtFndLG3SA
        MbWD9fMzExO8k27G58BjGntpjq6a76ZVdjo4x3Xcvpy97n3g
X-Google-Smtp-Source: ABdhPJy+7SKxDrG1GxLaC8fFKY07/UAOL7fWWKDTFyB/pGcMgNd3YaKAHBPaPaJMk8d8OTfAaOpCWVrE7vagN8DmDXplO50/ijFZ
MIME-Version: 1.0
X-Received: by 2002:a5d:8352:: with SMTP id q18mr8025549ior.31.1599749902075;
 Thu, 10 Sep 2020 07:58:22 -0700 (PDT)
Date:   Thu, 10 Sep 2020 07:58:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a48f9e05aef6cce1@google.com>
Subject: INFO: rcu detected stall in exit_group
From:   syzbot <syzbot+1a14a0f8ce1a06d4415f@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, dhowells@redhat.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mareklindner@neomailbox.ch, mike.kravetz@oracle.com,
        mingo@kernel.org, netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    34d4ddd3 Merge tag 'linux-kselftest-5.9-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134173a5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
dashboard link: https://syzkaller.appspot.com/bug?extid=1a14a0f8ce1a06d4415f
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c6642d900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132d00fd900000

The issue was bisected to:

commit 32021982a324dce93b4ae00c06213bf45fb319c8
Author: David Howells <dhowells@redhat.com>
Date:   Thu Nov 1 23:07:26 2018 +0000

    hugetlbfs: Convert to fs_context

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16cc40be900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15cc40be900000
console output: https://syzkaller.appspot.com/x/log.txt?x=11cc40be900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a14a0f8ce1a06d4415f@syzkaller.appspotmail.com
Fixes: 32021982a324 ("hugetlbfs: Convert to fs_context")

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1):
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3551 at kernel/sched/core.c:3013 rq_unlock kernel/sched/sched.h:1326 [inline]
WARNING: CPU: 0 PID: 3551 at kernel/sched/core.c:3013 try_invoke_on_locked_down_task+0x214/0x2c0 kernel/sched/core.c:3019
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 3551 Comm: syz-executor649 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x347/0x7c0 kernel/panic.c:231
 __warn.cold+0x20/0x46 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:try_invoke_on_locked_down_task+0x214/0x2c0 kernel/sched/core.c:3013
Code: 45 31 f6 49 39 c0 74 3a 8b 74 24 38 49 8d 78 18 4c 89 04 24 e8 ad 9a 08 00 4c 8b 04 24 4c 89 c7 e8 01 40 a6 06 e9 29 ff ff ff <0f> 0b e9 86 fe ff ff 4c 89 ee 48 89 ef 41 ff d4 41 89 c6 e9 11 ff
RSP: 0018:ffffc90000007bd8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 1ffff92000000f7d RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff81612ed0 RDI: ffff888099502240
RBP: ffff888099502240 R08: 0000000000000033 R09: ffffffff89bcb4a3
R10: 00000000000005a2 R11: 0000000000000001 R12: ffffffff81612ed0
R13: ffffc90000007d00 R14: ffff8880995025c0 R15: ffff8880ae636c00
 rcu_print_task_stall kernel/rcu/tree_stall.h:267 [inline]
 print_other_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:634 [inline]
 rcu_pending kernel/rcu/tree.c:3637 [inline]
 rcu_sched_clock_irq.cold+0x92e/0xccd kernel/rcu/tree.c:2519
 update_process_times+0x25/0xa0 kernel/time/timer.c:1710
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x1d1/0x2a0 kernel/time/tick-sched.c:1328
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1650
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0xb2/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x4d/0x90 kernel/locking/spinlock.c:191
Code: 48 c7 c0 48 3c b6 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 3c 48 83 3d 62 07 bf 01 00 74 29 48 89 df 57 9d <0f> 1f 44 00 00 bf 01 00 00 00 e8 44 80 58 f9 65 8b 05 7d c9 0a 78
RSP: 0018:ffffc9000c997a20 EFLAGS: 00000282
RAX: 1ffffffff136c789 RBX: 0000000000000282 RCX: 1ffffffff15645e9
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: 0000000000000282
RBP: ffffffff8cb5e0e0 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000017
R13: 0000000000000017 R14: dead000000000100 R15: dffffc0000000000
 __debug_check_no_obj_freed lib/debugobjects.c:977 [inline]
 debug_check_no_obj_freed+0x20c/0x41c lib/debugobjects.c:998
 free_pages_prepare mm/page_alloc.c:1214 [inline]
 __free_pages_ok+0x240/0xcd0 mm/page_alloc.c:1471
 release_pages+0x5ec/0x17a0 mm/swap.c:881
 tlb_batch_pages_flush mm/mmu_gather.c:49 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:242 [inline]
 tlb_flush_mmu mm/mmu_gather.c:249 [inline]
 tlb_finish_mmu+0x165/0x8c0 mm/mmu_gather.c:328
 exit_mmap+0x2d1/0x530 mm/mmap.c:3185
 __mmput+0x122/0x470 kernel/fork.c:1076
 mmput+0x53/0x60 kernel/fork.c:1097
 exit_mm kernel/exit.c:483 [inline]
 do_exit+0xa8b/0x29f0 kernel/exit.c:793
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __ia32_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x60/0x90 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f84549
Code: Bad RIP value.
RSP: 002b:00000000ffd39f7c EFLAGS: 00000292 ORIG_RAX: 00000000000000fc
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000080ed2b8
RDX: 0000000000000000 RSI: 00000000080d6f3c RDI: 00000000080ed2c0
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
