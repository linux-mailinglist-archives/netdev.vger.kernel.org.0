Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B817433E20
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 06:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFDE7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 00:59:06 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:54560 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfFDE7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 00:59:06 -0400
Received: by mail-it1-f197.google.com with SMTP id k8so16999767itd.4
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 21:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TTDReImnbsPUfsbHC9WPWZEbpuEYQR4VhJJHGQELGSY=;
        b=lpTFAbaUTgQ4CM6M5FAGkC233g0ewPx/rJbXUKA3YAwLu9jPGMLUqIkD/+NBFUAcNO
         YuCrgOsIaCnQGq/RnmOFjatdrAM4DpL197lweHo4vYUtZGqKgCqxL5WoF/Aot7Zm7wvp
         MBpMFvsNu0sDZ4pHObW4f2CtmRj4Amy/NkUdAI+EOJL5yQqWKskhUh8t/NqVS5BLPJvI
         3bmgxhhfYsbD25Rq9ZzrNVpsXUZwQ8Isz5Lfo/sdXiNnTd7skL7Nh9g5Q4l5UZo30ZNM
         fwdmd53rPUum0841dfB62v7qbMyRIYQExO3+Rs1v2wjqybpmkRofSWrK1wgAFh5CEFtr
         V+3Q==
X-Gm-Message-State: APjAAAWYpYQaaCeAM/wBJiBY0g8svwl2sISpXJn8whyNIQqY8536Mi/u
        8yyD5Re2BBglq1bFG+TpVyMQsAxsfACxJzo/S2euuFQwntjD
X-Google-Smtp-Source: APXvYqxhOTHCxmPPGUlRYIewZVdGpcmTCrQduA2Xdse33/kHj/bIPyHrvD0dun9841nI60bFqTIyH3BCmNbfMgaNz9JLeN4NfBWQ
MIME-Version: 1.0
X-Received: by 2002:a02:c492:: with SMTP id t18mr14002910jam.67.1559624345428;
 Mon, 03 Jun 2019 21:59:05 -0700 (PDT)
Date:   Mon, 03 Jun 2019 21:59:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017b026058a785790@google.com>
Subject: INFO: rcu detected stall in rose_connect
From:   syzbot <syzbot+af81c7a21a31b18bec0e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0462eaac Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12fda636a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7b54c66298f8420
dashboard link: https://syzkaller.appspot.com/bug?extid=af81c7a21a31b18bec0e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+af81c7a21a31b18bec0e@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (10499 ticks this GP) idle=5fa/1/0x4000000000000002  
softirq=44473/44473 fqs=15
	(t=10501 jiffies g=63393 q=282)
rcu: rcu_preempt kthread starved for 10470 jiffies! g63393 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29056    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:2818 [inline]
  __schedule+0x7cb/0x1560 kernel/sched/core.c:3445
  schedule+0xa8/0x260 kernel/sched/core.c:3509
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1807
  rcu_gp_fqs_loop kernel/rcu/tree.c:1589 [inline]
  rcu_gp_kthread+0x9b2/0x18b0 kernel/rcu/tree.c:1746
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 0
CPU: 0 PID: 25729 Comm: syz-executor.0 Not tainted 5.2.0-rc2+ #9
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x63/0xa4 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1be/0x236 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
  print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
  rcu_pending kernel/rcu/tree.c:2625 [inline]
  rcu_sched_clock_irq.cold+0x4d1/0xbfd kernel/rcu/tree.c:2161
  update_process_times+0x32/0x80 kernel/time/timer.c:1639
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x47/0x130 kernel/time/tick-sched.c:1298
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x33b/0xdd0 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
  smp_apic_timer_interrupt+0x111/0x550 arch/x86/kernel/apic/apic.c:1066
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
  </IRQ>
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:26 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:68 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x11/0x50 kernel/kcov.c:102
Code: 48 c7 05 8e 89 f5 08 00 00 00 00 e9 a4 e9 ff ff 90 90 90 90 90 90 90  
90 90 55 48 89 e5 48 8b 75 08 65 48 8b 04 25 c0 fd 01 00 <65> 8b 15 b0 57  
91 7e 81 e2 00 01 1f 00 75 2b 8b 90 e0 12 00 00 83
RSP: 0018:ffff888062d17c00 EFLAGS: 00000297 ORIG_RAX: ffffffffffffff13
RAX: ffff8880875ce680 RBX: dffffc0000000000 RCX: ffffffff864bdd76
RDX: 0000000000000001 RSI: ffffffff864bdd14 RDI: 0000000000000004
RBP: ffff888062d17c00 R08: ffff8880875ce680 R09: ffffed100c5a2f70
R10: ffffed100c5a2f6f R11: 0000000000000003 R12: ffff88808ce48600
R13: 0000000000000001 R14: ffff888216685300 R15: 0000000000000000
  rose_find_socket+0x54/0x120 net/rose/af_rose.c:281
  rose_new_lci net/rose/af_rose.c:302 [inline]
  rose_new_lci+0xca/0x140 net/rose/af_rose.c:296
  rose_connect+0x3b8/0x1510 net/rose/af_rose.c:776
  __sys_connect+0x264/0x330 net/socket.c:1840
  __do_sys_connect net/socket.c:1851 [inline]
  __se_sys_connect net/socket.c:1848 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:1848
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007eff2ff64c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
RDX: 0000000000000040 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007eff2ff656d4
R13: 00000000004bf7f6 R14: 00000000004d0d38 R15: 00000000ffffffff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
