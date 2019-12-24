Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07F6129CCC
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 03:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfLXCfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 21:35:12 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:38896 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLXCfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 21:35:12 -0500
Received: by mail-il1-f199.google.com with SMTP id i67so15683632ilf.5
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 18:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1+dWtw3vwfVmnluOmXunk0ENxZRgQ9jBR6EyVQsVhqw=;
        b=PALUMx/yZz4iW3B8HdSsXy0nziBEvzYIvTARX19AR7DTIwbpnTjzCMBJrxB8sbrrxT
         LAGvIqdUCOFlcAtSIhUS0847+tA8xsRqjNFk7/jUZuv43ucv+PGXOXJPhjBI2SzrIBg6
         +wPDBlsU7rLFyE4ubuWi9oKxpIetmGu8k82586WUSJ4VIznxryIJzTnCsBS6nO+RruTC
         jaMYMQPkiz+6dAMwG+dpwLNB/+0XNy22EGkEqaBkaOzgPe+gpUE0jRPICKxk/YXpkl64
         hc8O64AI5YwlagAARCj86TQnwNE5b73r3rcQVt8oIYabNsgZAgOmaqbDuNEmFtIHhV05
         gXIQ==
X-Gm-Message-State: APjAAAWDuvVXcSZAErv6Mt52XBMx+WCD9sDi/J5iwkNGy5mwMh8deT98
        fIIBoPyWetNte7sifXn0gfwx2LiuneewzMia8YN4MlCCr6dr
X-Google-Smtp-Source: APXvYqxQP72EB7ftQ9orqAiT6R/+nV5fZ9PsAiixitW06Fj260Kkr+zN3NBcsS8FSrA5CVqjFWaKo/1EN4brQVwnruHDve4B/Qmo
MIME-Version: 1.0
X-Received: by 2002:a92:5a16:: with SMTP id o22mr28335461ilb.229.1577154911202;
 Mon, 23 Dec 2019 18:35:11 -0800 (PST)
Date:   Mon, 23 Dec 2019 18:35:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003cf909059a69fe9a@google.com>
Subject: INFO: rcu detected stall in addrconf_rs_timer (3)
From:   syzbot <syzbot+c22c6b9dce8e773ddcb6@syzkaller.appspotmail.com>
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

HEAD commit:    a1ec57c0 net: stmmac: tc: Fix TAPRIO division operation
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=126058b9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7159d94cd4de714e
dashboard link: https://syzkaller.appspot.com/bug?extid=c22c6b9dce8e773ddcb6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168e33b6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178c160ae00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16dcb09ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15dcb09ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11dcb09ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c22c6b9dce8e773ddcb6@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (10500 ticks this GP) idle=38a/1/0x4000000000000004  
softirq=14860/14860 fqs=0
	(t=10500 jiffies g=10057 q=278)
rcu: rcu_preempt kthread starved for 10500 jiffies! g10057 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29272    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
  rcu_gp_fqs_loop kernel/rcu/tree.c:1661 [inline]
  rcu_gp_kthread+0x9b2/0x18d0 kernel/rcu/tree.c:1821
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 1
CPU: 1 PID: 10981 Comm: syz-executor209 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
  print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
  rcu_pending kernel/rcu/tree.c:2827 [inline]
  rcu_sched_clock_irq.cold+0x509/0xc02 kernel/rcu/tree.c:2271
  update_process_times+0x2d/0x70 kernel/time/timer.c:1726
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1310
  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
RIP: 0010:fq_flow_add_tail net/sched/sch_fq.c:148 [inline]
RIP: 0010:fq_dequeue+0x716/0x16a0 net/sched/sch_fq.c:518
Code: 3c 42 80 3c 30 00 0f 85 94 0c 00 00 48 8b 45 d0 49 8b 5d 48 48 c1 e8  
03 42 80 3c 30 00 0f 85 00 0c 00 00 48 8b 45 d0 48 89 18 <48> 8b 45 a0 42  
80 3c 30 00 0f 85 4c 0c 00 00 49 83 bf d0 02 00 00
RSP: 0018:ffffc90000da84b8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: ffff88809d78c2d0 RBX: 0000000000000000 RCX: ffffffff864629c3
RDX: 0000000000000100 RSI: ffffffff86462b78 RDI: ffff8880a8b25d58
RBP: ffffc90000da8540 R08: ffff888098622140 R09: fffffbfff165a3c4
R10: fffffbfff165a3c3 R11: ffffffff8b2d1e1f R12: ffff88809d78c2d8
R13: ffff8880a8b25d10 R14: dffffc0000000000 R15: ffff88809d78c000
  dequeue_skb net/sched/sch_generic.c:263 [inline]
  qdisc_restart net/sched/sch_generic.c:366 [inline]
  __qdisc_run+0x1a5/0x1770 net/sched/sch_generic.c:384
  __dev_xmit_skb net/core/dev.c:3677 [inline]
  __dev_queue_xmit+0x163f/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_hh_output include/net/neighbour.h:500 [inline]
  neigh_output include/net/neighbour.h:509 [inline]
  ip6_finish_output2+0xfbe/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  ndisc_send_skb+0xf1f/0x1490 net/ipv6/ndisc.c:505
  ndisc_send_rs+0x134/0x720 net/ipv6/ndisc.c:699
  addrconf_rs_timer+0x30f/0x6e0 net/ipv6/addrconf.c:3879
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
RIP: 0010:__raw_write_unlock_irq include/linux/rwlock_api_smp.h:268 [inline]
RIP: 0010:_raw_write_unlock_irq+0x4f/0x80 kernel/locking/spinlock.c:343
Code: c0 68 35 93 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00  
75 33 48 83 3d 22 93 c8 01 00 74 20 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00  
e8 37 19 86 f9 65 8b 05 28 7c 37 78 85 c0 74 06 41
RSP: 0018:ffffc9000cbc7c88 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff13266ad RBX: 0000000000000000 RCX: 0000000000000006
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff8880986229d4
RBP: ffffc9000cbc7c90 R08: 1ffffffff165a3bd R09: fffffbfff165a3be
R10: fffffbfff165a3bd R11: ffffffff8b2d1def R12: ffffffff8a50d700
R13: 0000000000000002 R14: 0000000000000000 R15: ffff88808d159000
  netlink_table_ungrab+0x15/0x30 net/netlink/af_netlink.c:448
  netlink_remove net/netlink/af_netlink.c:611 [inline]
  netlink_release+0x814/0x1c60 net/netlink/af_netlink.c:740
  __sock_release+0xce/0x280 net/socket.c:596
  sock_close+0x1e/0x30 net/socket.c:1282
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4025c0
Code: 01 f0 ff ff 0f 83 40 0d 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d cd 99 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 14 0d 00 00 c3 48 83 ec 08 e8 7a 02 00 00
RSP: 002b:00007ffe7a88c768 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000004025c0
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 000000000004b20d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004037f0 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
