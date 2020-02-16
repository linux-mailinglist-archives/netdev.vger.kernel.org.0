Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28A01603BB
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgBPKuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:50:12 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:35987 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbgBPKuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:50:11 -0500
Received: by mail-io1-f70.google.com with SMTP id d13so9926096ioc.3
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 02:50:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tmyUD4dE5EdukAHh4Dp5vAx2GiOLlf70TtCKs5OH5Sw=;
        b=rGZxbRqleeXcxj2NqKnP3GEUluxI0cEoi4LqrotLNzKsouH3qGrl4lRe+PSaodUxwv
         0pqGX81Wj1+UBWkp+pP8A+JOxOcKih56LlKRA7WkbEeoTzDspfYhZF/lKP7Ju4qdIYET
         7uFJkP8d/CkrPr5YVtRctGFTPs8LrzKhfUWASWWX2JG/69oA0LlolPaB/iUZD9y/LF5V
         AXYBe2yyyMMJ6Xon4MWYpq6kjt9CY2/Ybayt9YoPhEwPWF0Fybur8rH0a8I8MuTz2krC
         8r0thtyXP/dVsu6uFqgsZ1fg3ibIzzaffBiHbAz7QwKoolZks4jMqbMdHvDfQSfK9PoL
         BQgw==
X-Gm-Message-State: APjAAAW4gAdNAhUB15DGImfOnuDYsDX11/a8B9UJBkkvhHmLPeRlu2fQ
        Nn7Z/5jlp6wgVOwI94PUnneUeSVdbFTrcNScQAAoSp4/Q0rq
X-Google-Smtp-Source: APXvYqxIC/+1N1mZT1SbpNXMoImwWhUXugZZjqlCAokizCAIQqbRMMr2RoiQjoquxaV6WUNVCSmGtChycZ680M6dzO9BeSbkKePm
MIME-Version: 1.0
X-Received: by 2002:a02:a48e:: with SMTP id d14mr8619049jam.30.1581850210881;
 Sun, 16 Feb 2020 02:50:10 -0800 (PST)
Date:   Sun, 16 Feb 2020 02:50:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8590b059eaf33d3@google.com>
Subject: INFO: rcu detected stall in garp_join_timer (2)
From:   syzbot <syzbot+3fb2b230a1134a93a964@syzkaller.appspotmail.com>
To:     allison@lohutok.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, info@metux.net,
        kstewart@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    322bf2d3 Merge branch 'for-5.6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e11ad9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3373595e41752b95
dashboard link: https://syzkaller.appspot.com/bug?extid=3fb2b230a1134a93a964
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3fb2b230a1134a93a964@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 0, t=10502 jiffies, g=103677, q=319)
rcu: All QSes seen, last rcu_preempt kthread activity 10503 (4295009044-4294998541), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor.0  R  running task    27960  4245   8776 0x00004008
Call Trace:
 <IRQ>
 sched_show_task+0x411/0x560 kernel/sched/core.c:5954
 print_other_cpu_stall kernel/rcu/tree_stall.h:430 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:558 [inline]
 rcu_pending kernel/rcu/tree.c:3030 [inline]
 rcu_sched_clock_irq+0x188c/0x1aa0 kernel/rcu/tree.c:2276
 update_process_times+0x12d/0x180 kernel/time/timer.c:1726
 tick_sched_handle kernel/time/tick-sched.c:171 [inline]
 tick_sched_timer+0x263/0x420 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x3f3/0x840 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x37c/0xda0 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
 smp_apic_timer_interrupt+0x109/0x280 arch/x86/kernel/apic/apic.c:1135
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xa8/0xe0 kernel/locking/spinlock.c:191
Code: b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 0c 48 c7 c7 10 d1 2a 89 e8 87 b3 9d f9 48 83 3d ff ba 14 01 00 74 2d 4c 89 f7 57 9d <0f> 1f 44 00 00 bf 01 00 00 00 e8 29 d6 3c f9 65 8b 05 9e 07 ec 77
RSP: 0000:ffffc90000007cb8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1255a22 RBX: ffff88809ca8d2a8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000286
RBP: ffffc90000007cc8 R08: ffff88805127ed58 R09: fffffbfff1405526
R10: fffffbfff1405526 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000286 R15: ffff88809ca8d2a8
 spin_unlock_irqrestore include/linux/spinlock.h:393 [inline]
 skb_dequeue+0x122/0x160 net/core/skbuff.c:3042
 garp_queue_xmit net/802/garp.c:258 [inline]
 garp_join_timer+0x95/0x130 net/802/garp.c:410
 call_timer_fn+0x95/0x170 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers+0x776/0x970 kernel/time/timer.c:1773
 run_timer_softirq+0x4a/0x90 kernel/time/timer.c:1786
 __do_softirq+0x283/0x7bd kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x227/0x230 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:preempt_schedule_irq+0xc0/0x150 kernel/sched/core.c:4339
Code: 67 f9 43 80 3c 37 00 74 0c 48 c7 c7 20 d1 2a 89 e8 95 72 9e f9 48 83 3d 1d 7a 15 01 00 0f 84 82 00 00 00 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 66 ed ff ff 43 80 3c 34 00 74 0c 48 c7 c7 18 d1
RSP: 0000:ffffc900056c7d98 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: ffff88805127ed94 RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc90002309000 RSI: 000000000000ad7f RDI: ffff88805127ed44
RBP: ffffc900056c7db8 R08: ffff88805127ed58 R09: ffffed1015d47004
R10: ffffed1015d47004 R11: 0000000000000000 R12: 1ffffffff1255a23
R13: 0000000000000000 R14: dffffc0000000000 R15: 1ffffffff1255a24
 retint_kernel+0x1b/0x2b
RIP: 0010:check_memory_region+0x224/0x2f0 mm/kasan/generic.c:192
Code: 89 cf 49 8d 5e 07 4d 85 f6 49 0f 49 de 48 83 e3 f8 49 29 de 74 11 45 0f b6 1f 45 84 db 75 65 49 ff c7 49 ff ce 75 ef 5b 41 5c <41> 5d 41 5e 41 5f 5d c3 45 84 db 75 50 45 8a 59 01 45 84 db 0f 85
RSP: 0000:ffffc900056c7e78 EFLAGS: 00000256 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000001 RBX: 1ffff1100a24fca0 RCX: ffffffff881552ef
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88805127e500
RBP: ffffc900056c7e90 R08: dffffc0000000000 R09: ffffed100a24fca1
R10: ffffed100a24fca1 R11: 0000000000000000 R12: dffffc0000000000
R13: dffffc0000000001 R14: 0000000000000001 R15: ffff88805127e500
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 test_ti_thread_flag include/linux/thread_info.h:84 [inline]
 need_resched include/linux/sched.h:1820 [inline]
 schedule+0x19f/0x210 kernel/sched/core.c:4158
 exit_to_usermode_loop arch/x86/entry/common.c:150 [inline]
 prepare_exit_to_usermode+0x2cd/0x5b0 arch/x86/entry/common.c:195
 ret_from_intr+0x26/0x36
RIP: 0033:0x45b399
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8115626c78 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 00007f81156276d4 RCX: 000000000045b399
RDX: 0000000000042000 RSI: 0000000000000004 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000000c1 R14: 00000000004c2040 R15: 000000000075bf2c
rcu: rcu_preempt kthread starved for 10552 jiffies! g103677 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    28792    10      2 0x80004000
Call Trace:
 context_switch kernel/sched/core.c:3386 [inline]
 __schedule+0x87f/0xcd0 kernel/sched/core.c:4082
 schedule+0x188/0x210 kernel/sched/core.c:4156
 schedule_timeout+0x14f/0x240 kernel/time/timer.c:1895
 rcu_gp_fqs_loop kernel/rcu/tree.c:1658 [inline]
 rcu_gp_kthread+0xe8d/0x17e0 kernel/rcu/tree.c:1818
 kthread+0x332/0x350 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
