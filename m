Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E77DACB23
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 08:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfIHGIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 02:08:22 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:53595 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfIHGIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 02:08:10 -0400
Received: by mail-io1-f72.google.com with SMTP id l21so13578127iob.20
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 23:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dUjDIEQ4V2yempdkzrbUrb4l6z5K0R8nRQCIAMlz4xk=;
        b=NTtB0Yf0puDnOGg895w02K+R/Rk0OP7W36Fk+vNRm3xVBg7KJ1QRZQycQywDkqU1eU
         lvWkWPYIietLomwQlM8ND9CmozKnCAKPHDZl9R59IaePE6tt8z1gRMbb8eLTkKwVo0ug
         M9lMa/lW+EkQ78r6Vl4VsSpCWQ4E7rwRXm6KAmCVdmvrysNYeFXYIdwGUYKk0/EAdSK9
         V97n6U/RRIqdXf8nHqpAg58Ps1KBaylwpqCFpH8YPJH1ABfcp/lojym8ghQVeWYiEsKu
         zUFJq9MU60IHivOf73rBbnIn1HvHTMlVgHkAbZoyPyZXVNapkWB3d84J3ReegzKEwPJk
         M/Eg==
X-Gm-Message-State: APjAAAXQkrhh4vhhTyOPoFAusMeGQxUMZojjYvcKG+wjr2BSibOjYBOd
        ablViISGIWg21lJPBEEpgA+Shxq/Pix1kILDkEkWI5TdwGXq
X-Google-Smtp-Source: APXvYqwvOGiW0P6OfdgUFt+bgQEL0lNelOi9ZHR74YuBq23BQ0qbkFNmrKxnjvU6HXxxdKfO6i6hrfe6SsCuqePzT2enKeQaOr01
MIME-Version: 1.0
X-Received: by 2002:a6b:7e45:: with SMTP id k5mr5633816ioq.178.1567922889395;
 Sat, 07 Sep 2019 23:08:09 -0700 (PDT)
Date:   Sat, 07 Sep 2019 23:08:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db98ee0592047e24@google.com>
Subject: INFO: rcu detected stall in mld_ifc_timer_expire
From:   syzbot <syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15807dc6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
dashboard link: https://syzkaller.appspot.com/bug?extid=bc6297c11f19ee807dc2
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119ee6c1600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c4eb0a600000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b7343e600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17b7343e600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bc6297c11f19ee807dc2@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (10500 ticks this GP) idle=d6e/0/0x3 softirq=9083/9083 fqs=0
	(t=10501 jiffies g=6617 q=143)
rcu: rcu_preempt kthread starved for 10502 jiffies! g6617 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29080    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x877/0xc50 kernel/sched/core.c:3880
  schedule+0x131/0x1e0 kernel/sched/core.c:3947
  schedule_timeout+0x14f/0x240 kernel/time/timer.c:1807
  rcu_gp_fqs_loop kernel/rcu/tree.c:1611 [inline]
  rcu_gp_kthread+0xef8/0x1790 kernel/rcu/tree.c:1768
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  nmi_cpu_backtrace+0xaf/0x1a0 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x174/0x290 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x10/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x15a/0x220 kernel/rcu/tree_stall.h:254
  print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
  rcu_pending kernel/rcu/tree.c:2736 [inline]
  rcu_sched_clock_irq+0xb95/0x16d0 kernel/rcu/tree.c:2183
  update_process_times+0x134/0x190 kernel/time/timer.c:1639
  tick_sched_handle kernel/time/tick-sched.c:167 [inline]
  tick_sched_timer+0x263/0x420 kernel/time/tick-sched.c:1296
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x403/0x850 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x38c/0xda0 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1106 [inline]
  smp_apic_timer_interrupt+0x109/0x280 arch/x86/kernel/apic/apic.c:1131
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
RIP: 0010:__list_add_valid+0xc/0xc0 lib/list_debug.c:22
Code: 89 e5 53 48 89 fb e8 83 d6 1f fe 48 c7 c7 56 5a 45 88 48 89 de e8 44  
fd ff ff 5b 5d c3 90 55 48 89 e5 41 57 41 56 41 55 41 54 <53> 49 89 d6 49  
89 f4 49 89 ff 49 bd 00 00 00 00 00 fc ff df 48 8d
RSP: 0018:ffff8880aea09730 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 1ffff11012f53d0a RBX: 1ffff11012f53d0b RCX: ffffffff88875a00
RDX: ffff888097a9e850 RSI: ffff888097a9e850 RDI: ffff888097a9e7b8
RBP: ffff8880aea09750 R08: ffffffff860c4d6a R09: 0000000000000000
R10: fffffbfff117be8d R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888097a9e4c0 R14: ffff888097a9e850 R15: ffff888097a9e840
  __list_add include/linux/list.h:60 [inline]
  list_add_tail include/linux/list.h:93 [inline]
  list_move_tail include/linux/list.h:214 [inline]
  hhf_dequeue+0x535/0xaa0 net/sched/sch_hhf.c:439
  dequeue_skb net/sched/sch_generic.c:258 [inline]
  qdisc_restart net/sched/sch_generic.c:361 [inline]
  __qdisc_run+0x217/0x1b30 net/sched/sch_generic.c:379
  __dev_xmit_skb net/core/dev.c:3533 [inline]
  __dev_queue_xmit+0x1161/0x3020 net/core/dev.c:3838
  dev_queue_xmit+0x17/0x20 net/core/dev.c:3902
  neigh_hh_output include/net/neighbour.h:500 [inline]
  neigh_output include/net/neighbour.h:509 [inline]
  ip6_finish_output2+0xff2/0x13d0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x693/0x910 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x52/0x1e0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip6_output+0x26f/0x390 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  mld_sendpack+0x770/0xb90 net/ipv6/mcast.c:1682
  mld_send_cr net/ipv6/mcast.c:1978 [inline]
  mld_ifc_timer_expire+0x820/0xb70 net/ipv6/mcast.c:2477
  call_timer_fn+0x95/0x170 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers+0x79e/0x970 kernel/time/timer.c:1685
  run_timer_softirq+0x4a/0x90 kernel/time/timer.c:1698
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x227/0x230 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1133
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 30 fa eb ae 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 f4 b0 30  
fa eb b0 90 90 e9 07 00 00 00 0f 00 2d 96 b0 46 00 fb f4 <c3> 90 e9 07 00  
00 00 0f 00 2d 86 b0 46 00 f4 c3 90 90 55 48 89 e5
RSP: 0018:ffffffff88807dc0 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff11150f3 RBX: ffffffff88875a00 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff812b7a1a RDI: ffffffff877bd46a
RBP: ffffffff88807dc8 R08: ffffffff81790e14 R09: fffffbfff110eb41
R10: fffffbfff110eb41 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffffffff110eb40 R14: dffffc0000000000 R15: 0000000000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
  default_idle_call+0x59/0xa0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x140/0x6d0 kernel/sched/idle.c:263
  cpu_startup_entry+0x25/0x30 kernel/sched/idle.c:354
  rest_init+0x29d/0x2b0 init/main.c:451
  arch_call_rest_init+0xe/0x10
  start_kernel+0x6f5/0x7f6 init/main.c:785
  x86_64_start_reservations+0x18/0x2e arch/x86/kernel/head64.c:472
  x86_64_start_kernel+0x7a/0x7d arch/x86/kernel/head64.c:453
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
