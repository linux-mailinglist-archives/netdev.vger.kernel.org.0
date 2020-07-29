Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EA723193C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 07:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgG2FxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 01:53:24 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:50036 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgG2FxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 01:53:24 -0400
Received: by mail-il1-f199.google.com with SMTP id v12so5632692iln.16
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 22:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kaDnaA3BITfKcY/8Vxb4jbHOSthJC8NmXl9wxLc5BTc=;
        b=t+N4TQFEk6KZC65OeCekr7c1FCER9jTW+eaObLhyqXRUFLWqHJwzEN5ROp5P60MTaV
         hy9lY/yV81vsuxJY4vBBT8wvvTB2VmadpTs/fvZ4h2VP/DlLvYLg3sKSJhYzvulmwKjd
         gf+2rSyUG9iw9QYNye8HBjxuUwOG01eyONIgSErvta+AmYhM/SpZYbnTzsVGb5647TRl
         Qu0tdp7vby93wT2C8hYWXBJN8MTOBiX60hQ5NKEa9+2NlDelSofkKx8beSeX2yz6Jyi0
         eatiar3I8di9PN7RQ3LPzvrUxCMrtmXFQO/Ldlq6Xty3m3hjibNxwgwipE81AmQdZR5A
         3FZg==
X-Gm-Message-State: AOAM530SwzJcAOOnhUSdMmym4uvnl0fwmY38rHNo3xKCByxvbI0/JUGa
        mz8mgu4GqUpaJPlzN4qye5Wvzt56i8eSJ8lVRWb97oQXYn6Q
X-Google-Smtp-Source: ABdhPJwNwVdtlfg3NDT3vUlgH6s93GAnPUjSanO/gQbfS+gJhGDwAUTPLkzsNImJXDp5L1PYfz2b/N4r+ug5VbrlDsDCmS5vCpld
MIME-Version: 1.0
X-Received: by 2002:a5d:8d04:: with SMTP id p4mr32507772ioj.187.1596002002735;
 Tue, 28 Jul 2020 22:53:22 -0700 (PDT)
Date:   Tue, 28 Jul 2020 22:53:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006f179d05ab8e2cf2@google.com>
Subject: INFO: rcu detected stall in tc_modify_qdisc
From:   syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fweisbec@gmail.com, jhs@mojatatu.com,
        jiri@resnulli.us, linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vinicius.gomes@intel.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    181964e6 fix a braino in cmsghdr_from_user_compat_to_kern()
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12925e38900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=9f78d5c664a8c33f4cce
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16587f8c900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b2d790900000

The issue was bisected to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160e1bac900000
console output: https://syzkaller.appspot.com/x/log.txt?x=110e1bac900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (1 GPs behind) idle=6f6/1/0x4000000000000000 softirq=10195/10196 fqs=1 
	(t=27930 jiffies g=9233 q=413)
rcu: rcu_preempt kthread starved for 27901 jiffies! g9233 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29112    10      2 0x00004000
Call Trace:
 context_switch kernel/sched/core.c:3458 [inline]
 __schedule+0x8ea/0x2210 kernel/sched/core.c:4219
 schedule+0xd0/0x2a0 kernel/sched/core.c:4294
 schedule_timeout+0x148/0x250 kernel/time/timer.c:1908
 rcu_gp_fqs_loop kernel/rcu/tree.c:1874 [inline]
 rcu_gp_kthread+0xae5/0x1b50 kernel/rcu/tree.c:2044
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
NMI backtrace for cpu 1
CPU: 1 PID: 6799 Comm: syz-executor494 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x194/0x1cf kernel/rcu/tree_stall.h:320
 print_cpu_stall kernel/rcu/tree_stall.h:553 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 rcu_pending kernel/rcu/tree.c:3489 [inline]
 rcu_sched_clock_irq.cold+0x5b3/0xccc kernel/rcu/tree.c:2504
 update_process_times+0x25/0x60 kernel/time/timer.c:1737
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x108/0x290 kernel/time/tick-sched.c:1320
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0xe0/0x120 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:585
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x8c/0xe0 kernel/locking/spinlock.c:191
Code: 48 c7 c0 88 e0 b4 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 37 48 83 3d e3 52 cc 01 00 74 22 48 89 df 57 9d <0f> 1f 44 00 00 bf 01 00 00 00 e8 35 e5 66 f9 65 8b 05 fe 70 19 78
RSP: 0018:ffffc900016672c0 EFLAGS: 00000282
RAX: 1ffffffff1369c11 RBX: 0000000000000282 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000282
RBP: ffff888093a052e8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000282
R13: 00000078100c35c3 R14: ffff888093a05000 R15: 0000000000000000
 spin_unlock_irqrestore include/linux/spinlock.h:408 [inline]
 taprio_change+0x1fdc/0x2960 net/sched/sch_taprio.c:1557
 taprio_init+0x52e/0x670 net/sched/sch_taprio.c:1670
 qdisc_create+0x4b6/0x12e0 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x4c8/0x1990 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443819
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 0f fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff687c83d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443819
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 00007fff687c83e0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007fff687c83f0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
