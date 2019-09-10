Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4036BAF1C4
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfIJTSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:18:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:35502 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfIJTSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:18:09 -0400
Received: by mail-io1-f69.google.com with SMTP id 18so24488505iof.2
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 12:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qJrPEyyq2wIkvZMXDLhRyvs6qoso+R0H+MG2NHGwSu4=;
        b=gmlgyHS3Y19gDPaXgvTABzOT7Qfn0H7NbDPluLOxwH4zCDZkXclfvk538ziBjZbwgl
         +3PTuSK8Y/NYplXCFD9e+Ds1oIaaUl+OvH+fPT4yx2AHnLMukJJISxCMIcskuRhMZevY
         6+jNtSuLvDOClP2mHj5ZDiIGpIFOM/OKqxaDxDJujIjRkAqYlsViLAMHT1Ir7CmdWBQk
         d7U80y1W29o6umaBaXs5ESeUg2B0p/RorxXsFRVK+ksintT+KE2X5v9E+IHaQrxB4K3p
         i4Kvio3Zo61hhUaWwOl/kw/TxTPlKbxpX4GqGNGW87q7fhNgrNC0RqRAqKzCVdr1Lb11
         IkGQ==
X-Gm-Message-State: APjAAAX70wNImt+lFW8wNNLitiZoRjicAYH3B8iyp7hjM8Rt1Is/FoWi
        UVW3/UrhTTbhyP2Da7b8aITyrt7pAB3xVmhnzdDIWo7U9BwZ
X-Google-Smtp-Source: APXvYqwLp6TUDoXjKFeiVSnFe2tcLGdqsf8aJ3drx9I589lEwG+oRCppTSFpEhF9UmKXSYXlIfIgfWkn3OCz1rX4NX6lvbb6MkDc
MIME-Version: 1.0
X-Received: by 2002:a02:948c:: with SMTP id x12mr32825055jah.96.1568143088627;
 Tue, 10 Sep 2019 12:18:08 -0700 (PDT)
Date:   Tue, 10 Sep 2019 12:18:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1391b059237c3a6@google.com>
Subject: INFO: rcu detected stall in addrconf_dad_work
From:   syzbot <syzbot+0055e43d6f67fb9b8ba1@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=126c0f51600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=0055e43d6f67fb9b8ba1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1500264e600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d7a46e600000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160261e1600000
console output: https://syzkaller.appspot.com/x/log.txt?x=110261e1600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0055e43d6f67fb9b8ba1@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (10499 ticks this GP) idle=e02/1/0x4000000000000002  
softirq=9705/9705 fqs=4
	(t=10500 jiffies g=9309 q=84)
rcu: rcu_preempt kthread starved for 10492 jiffies! g9309 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29112    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3880
  schedule+0xd9/0x260 kernel/sched/core.c:3947
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1807
  rcu_gp_fqs_loop kernel/rcu/tree.c:1611 [inline]
  rcu_gp_kthread+0x9b2/0x18c0 kernel/rcu/tree.c:1768
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 1
CPU: 1 PID: 3027 Comm: kworker/1:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
  print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
  rcu_pending kernel/rcu/tree.c:2736 [inline]
  rcu_sched_clock_irq.cold+0x4dd/0xc13 kernel/rcu/tree.c:2183
  update_process_times+0x32/0x80 kernel/time/timer.c:1639
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1296
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1106 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1131
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:__list_del_entry_valid+0x4b/0xf5 lib/list_debug.c:45
Code: 54 80 3c 02 00 0f 85 a1 00 00 00 4c 89 f2 4d 8b 66 08 48 b8 00 00 00  
00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 9d 00 00 00 <48> b8 00 01 00  
00 00 00 ad de 4d 8b 2e 49 39 c5 0f 84 e1 00 00 00
RSP: 0018:ffff88809ff26d30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: dffffc0000000000 RBX: ffff88808c560778 RCX: ffffffff85c64b39
RDX: 1ffff110118ac0ef RSI: ffffffff85c65006 RDI: ffff88808c560780
RBP: ffff88809ff26d48 R08: ffff88809ff08300 R09: 0000000000000000
R10: fffffbfff134af8f R11: ffff88809ff08300 R12: ffff88808c560810
R13: ffff88808c560480 R14: ffff88808c560778 R15: 0000000000000000
  __list_del_entry include/linux/list.h:131 [inline]
  list_move_tail include/linux/list.h:213 [inline]
  hhf_dequeue+0x5c5/0xa20 net/sched/sch_hhf.c:439
  dequeue_skb net/sched/sch_generic.c:258 [inline]
  qdisc_restart net/sched/sch_generic.c:361 [inline]
  __qdisc_run+0x1e7/0x19d0 net/sched/sch_generic.c:379
  __dev_xmit_skb net/core/dev.c:3533 [inline]
  __dev_queue_xmit+0x16f1/0x3650 net/core/dev.c:3838
  dev_queue_xmit+0x18/0x20 net/core/dev.c:3902
  br_dev_queue_push_xmit+0x3f3/0x5c0 net/bridge/br_forward.c:52
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  br_forward_finish+0xfa/0x400 net/bridge/br_forward.c:65
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  __br_forward+0x641/0xb00 net/bridge/br_forward.c:109
  deliver_clone+0x61/0xc0 net/bridge/br_forward.c:125
  maybe_deliver+0x2c7/0x390 net/bridge/br_forward.c:181
  br_flood+0x13a/0x3d0 net/bridge/br_forward.c:223
  br_dev_xmit+0x98c/0x15a0 net/bridge/br_device.c:100
  __netdev_start_xmit include/linux/netdevice.h:4406 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3280 [inline]
  dev_hard_start_xmit+0x1a3/0x9c0 net/core/dev.c:3296
  __dev_queue_xmit+0x2b15/0x3650 net/core/dev.c:3869
  dev_queue_xmit+0x18/0x20 net/core/dev.c:3902
  neigh_resolve_output net/core/neighbour.c:1490 [inline]
  neigh_resolve_output+0x5a5/0x970 net/core/neighbour.c:1470
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x1034/0x2520 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xa50 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip6_output+0x235/0x7c0 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  ndisc_send_skb+0xf29/0x1450 net/ipv6/ndisc.c:504
  ndisc_send_ns+0x3a9/0x850 net/ipv6/ndisc.c:646
  addrconf_dad_work+0xb88/0x1150 net/ipv6/addrconf.c:4120
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
