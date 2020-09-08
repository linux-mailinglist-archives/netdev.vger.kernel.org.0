Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3CD2612F9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIHOvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 10:51:20 -0400
Received: from mail-pf1-f205.google.com ([209.85.210.205]:50066 "EHLO
        mail-pf1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729822AbgIHO0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 10:26:07 -0400
Received: by mail-pf1-f205.google.com with SMTP id q5so6114952pfl.16
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dpvampSRKqk3hzME8jOMKeKyXBOan8WOEO3RmX+EpEQ=;
        b=RKEMFILH4MhmrK69P5ddNn5538o1OccNXJ0blyZ6cVHe5KtMrfMgnG8CkZ3Ke+lrh9
         obz4LMZaSzUYwHo97hNGp4ZMCwGvcJI5OiKgR3scMykvjH+SfM6mrx7puMWVtngl8a+6
         sBPZXSSOkpBwd3cH/4gMKX5lzbsbWBWL3dFPIoWCh2Xt/PAyBOLYhHtuSSCZC3qKQ95e
         6uKBIDWsnR+kbG+sXe4zDoMwOgxL1OAOKG0ewFai+mGVkGkK5rKxrn1k6/2pXgLX5pwe
         M23Jl2z9gdo9DUIIQfuvcf60pKi/LI3QHC9cemDWfevyaQxqNFGzxjwAVtI1isrInTzK
         NgAQ==
X-Gm-Message-State: AOAM532AmcHDkAGKodVVl9Pq0zprWjv/3XI8rdY8O1gpVKU405YN1+du
        6XtGWKb2kCGAKyYOdRoIaTQvQnRnBfXWPBMiL7lPt7J0wvqV
X-Google-Smtp-Source: ABdhPJzSeK7K4ZGg1Vx9wgZ8X7yGBL1crrrDuoMF53SkFzGfiL1P9GtdMKI47aeeSCZ4n42sNkGGFKFmpYxTQIlpFIxu0Sa3xW+o
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d4e:: with SMTP id d14mr21327976iow.127.1599572961722;
 Tue, 08 Sep 2020 06:49:21 -0700 (PDT)
Date:   Tue, 08 Sep 2020 06:49:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d04cc05aecd9a28@google.com>
Subject: INFO: rcu detected stall in security_file_free (2)
From:   syzbot <syzbot+f590c1bada839a48b7b1@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, mbenes@suse.cz, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        shile.zhang@linux.alibaba.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e6135df4 Merge branch 'hashmap_iter_bucket_lock_fix'
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=10e3dbf5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=f590c1bada839a48b7b1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174fea59900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12153819900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f590c1bada839a48b7b1@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (3 ticks this GP) idle=382/1/0x4000000000000002 softirq=9307/9307 fqs=0 
	(detected by 1, t=10502 jiffies, g=11173, q=564)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8139 Comm: syz-executor202 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unwind_next_frame+0x7d/0x1f90 arch/x86/kernel/unwind_orc.c:426
Code: 48 89 fa 65 48 8b 34 25 28 00 00 00 48 89 b4 24 98 00 00 00 31 f6 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 54 0b 00 00 <41> 8b 2f 31 c0 85 ed 75 3b 48 ba 00 00 00 00 00 fc ff df 48 c7 04
RSP: 0018:ffffc90000007048 EFLAGS: 00000046
RAX: 0000000000000000 RBX: 1ffff92000000e11 RCX: 1ffff11011ba10a0
RDX: 1ffff92000000e30 RSI: 0000000000000000 RDI: ffffc90000007180
RBP: ffffc90000007248 R08: ffffffff8b9bff4c R09: ffffffff8b9bff50
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff81b40fac
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90000007180
FS:  000000000227e880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000a468a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 perf_callchain_kernel+0x444/0x6a0 arch/x86/events/core.c:2449
 get_perf_callchain+0x16e/0x620 kernel/events/callchain.c:200
 perf_callchain+0x165/0x1c0 kernel/events/core.c:6985
 perf_prepare_sample+0x8fd/0x1d40 kernel/events/core.c:7012
 __perf_event_output kernel/events/core.c:7170 [inline]
 perf_event_output_forward+0xf3/0x270 kernel/events/core.c:7190
 __perf_event_overflow+0x13c/0x370 kernel/events/core.c:8845
 perf_swevent_overflow kernel/events/core.c:8921 [inline]
 perf_swevent_event+0x347/0x550 kernel/events/core.c:8949
 perf_tp_event+0x2e4/0xb50 kernel/events/core.c:9377
 perf_trace_run_bpf_submit+0x11c/0x200 kernel/events/core.c:9351
 perf_trace_preemptirq_template+0x289/0x440 include/trace/events/preemptirq.h:14
 trace_irq_enable_rcuidle include/trace/events/preemptirq.h:40 [inline]
 trace_irq_enable_rcuidle include/trace/events/preemptirq.h:40 [inline]
 trace_hardirqs_on+0x18a/0x220 kernel/trace/trace_preemptirq.c:44
 asm_sysvec_irq_work+0x12/0x20 arch/x86/include/asm/idtentry.h:611
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:rcu_read_unlock_special kernel/rcu/tree_plugin.h:630 [inline]
RIP: 0010:__rcu_read_unlock+0x488/0x560 kernel/rcu/tree_plugin.h:395
Code: 48 c7 c0 c8 3b b6 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 53 48 83 3d 47 75 54 08 00 74 13 4c 89 e7 57 9d <0f> 1f 44 00 00 e9 ed fb ff ff 0f 0b 0f 0b 0f 0b 0f 0b 4c 89 ef e8
RSP: 0018:ffffc90000007b40 EFLAGS: 00000286
RAX: 1ffffffff136c779 RBX: ffffffff89bd9901 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000286
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffffff8c5f3a97
R10: fffffbfff18be752 R11: 0000000000000001 R12: 0000000000000286
R13: 0000000000000200 R14: ffff8880ae636c00 R15: 0000000000000000
 rcu_read_unlock include/linux/rcupdate.h:687 [inline]
 mld_sendpack+0x742/0xdb0 net/ipv6/mcast.c:1690
 mld_send_initial_cr.part.0+0x106/0x150 net/ipv6/mcast.c:2096
 mld_send_initial_cr net/ipv6/mcast.c:1191 [inline]
 mld_dad_timer_expire+0x1c7/0x6a0 net/ipv6/mcast.c:2115
 call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
 expire_timers kernel/time/timer.c:1458 [inline]
 __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
 __run_timers kernel/time/timer.c:1736 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
 __do_softirq+0x2de/0xa24 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x1f3/0x230 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x4b/0x80 kernel/locking/spinlock.c:199
Code: c0 d8 3b b6 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 31 48 83 3d 46 f6 bf 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 db 6d 59 f9 65 8b 05 d4 b8 0b 78 85 c0 74 02 5d
RSP: 0018:ffffc90009cf7c00 EFLAGS: 00000286
RAX: 1ffffffff136c77b RBX: ffff8880a95ea1c0 RCX: 1ffffffff1563fd1
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffffffff87f6456f
RBP: ffff8880ae635e00 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8880ae635e00
R13: ffff88808850a440 R14: 0000000000000000 R15: 0000000000000001
 finish_lock_switch kernel/sched/core.c:3517 [inline]
 finish_task_switch+0x147/0x750 kernel/sched/core.c:3617
 context_switch kernel/sched/core.c:3781 [inline]
 __schedule+0x8ed/0x21e0 kernel/sched/core.c:4527
 preempt_schedule_irq+0xb0/0x150 kernel/sched/core.c:4785
 irqentry_exit_cond_resched kernel/entry/common.c:333 [inline]
 irqentry_exit_cond_resched kernel/entry/common.c:325 [inline]
 irqentry_exit+0x65/0x90 kernel/entry/common.c:363
 asm_sysvec_reschedule_ipi+0x12/0x20 arch/x86/include/asm/idtentry.h:586
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:kmem_cache_free.part.0+0x8c/0x1f0 mm/slab.c:3694
Code: e8 89 25 00 00 84 c0 74 76 41 f7 c4 00 02 00 00 74 4e e8 a7 f6 c5 ff 48 83 3d 27 2c 02 08 00 0f 84 2f 01 00 00 4c 89 e7 57 9d <0f> 1f 44 00 00 4c 8b 64 24 20 0f 1f 44 00 00 65 8b 05 9e 83 4d 7e
RSP: 0018:ffffc90009cf7e20 EFLAGS: 00000286
RAX: 000000000000168d RBX: ffff88809f747380 RCX: 1ffffffff1563fd1
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000286
RBP: ffff8880aa241e00 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000286
R13: ffffffff8358c3f4 R14: ffff88808828d600 R15: ffff8880896a26a0
 security_file_free+0xa4/0xd0 security/security.c:1474
 file_free fs/file_table.c:55 [inline]
 __fput+0x3d7/0x920 fs/file_table.c:299
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:167
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:242
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x403fc0
Code: 01 f0 ff ff 0f 83 40 0d 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d cd 9f 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 14 0d 00 00 c3 48 83 ec 08 e8 7a 02 00 00
RSP: 002b:00007ffe459c68a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000403fc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000400326777
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000004
R13: 00000000004051f0 R14: 0000000000000000 R15: 0000000000000000
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 0.000 msecs
rcu: rcu_preempt kthread starved for 10502 jiffies! g11173 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:29664 pid:   10 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_timeout+0x148/0x250 kernel/time/timer.c:1879
 rcu_gp_fqs_loop kernel/rcu/tree.c:1888 [inline]
 rcu_gp_kthread+0xae5/0x1b50 kernel/rcu/tree.c:2058
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
