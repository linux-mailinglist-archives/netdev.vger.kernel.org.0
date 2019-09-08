Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62777ACB4F
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 09:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfIHHTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 03:19:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36707 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfIHHTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 03:19:08 -0400
Received: by mail-io1-f70.google.com with SMTP id g126so13756453iof.3
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 00:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NHe3HdeOboHxOXm9q/0iOWUOymEceDARktK/4vRh+EQ=;
        b=fsyNMEeYFnoZk7GM8lAtRahQbTVnkzqjKrkBzoMHcgbOch7iodlg/tcpSuWJ2KTpT+
         d3TEfbKY1ByThSpMqDm+XZGLohkcIIgHvZ/FGiKw5q5Ng6xSQc6htA0ApiY3o1vnXOmR
         k1bwtHiYNMZlLTFGW8r+FcljWzLihGkGpeLoDh/qlQJOvxLeqmqMHpj/dhOnfU3vYgA0
         lrKwKMnJx3q948WjKit+lB8iE9SAW0JuaaSUm0t4h8bITqacBxyO527Eg4mw4NlD4d12
         qi41px1hIeYj257aaIhX0GmmYkv1F+cs99N9Jth9rk43lvNh5sBdjKcKjZv08k4dr8Wj
         uLJg==
X-Gm-Message-State: APjAAAUG4iKRLV3OYqAE3ILL7vzG6Wxz82NJbl+E5En4RG0kcMfdtcVy
        DGyOgNF9LxZ3DytxVG4NeWOyRGpTqBNfHTpmlnsbKHOVedur
X-Google-Smtp-Source: APXvYqwhJ+BLrkzL3nxneqIJmbHbd5+7qymv+JpnHISB6Hd0XdsuD569HphfNNAvHdn5sT4G0/i5A7IWP7soh0MbjQoezukD0Q2H
MIME-Version: 1.0
X-Received: by 2002:a5d:8d0b:: with SMTP id p11mr19681465ioj.136.1567927146723;
 Sun, 08 Sep 2019 00:19:06 -0700 (PDT)
Date:   Sun, 08 Sep 2019 00:19:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009d480e0592057c7c@google.com>
Subject: INFO: rcu detected stall in pppoe_sendmsg
From:   syzbot <syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com>
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

HEAD commit:    1e3778cb Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137b2971600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=55be5f513bed37fc4367
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+55be5f513bed37fc4367@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (10501 ticks this GP) idle=06a/1/0x4000000000000002  
softirq=173683/173683 fqs=0
	(t=10502 jiffies g=271749 q=3228)
rcu: rcu_preempt kthread starved for 10503 jiffies! g271749 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29160    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3880
  schedule+0xd9/0x260 kernel/sched/core.c:3947
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1807
  rcu_gp_fqs_loop kernel/rcu/tree.c:1611 [inline]
  rcu_gp_kthread+0x9b2/0x18c0 kernel/rcu/tree.c:1768
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 0
CPU: 0 PID: 4124 Comm: syz-executor.2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:26 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:68 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0xd/0x50 kernel/kcov.c:102
Code: 6d 9f e9 ff 48 c7 05 1e 4d 19 09 00 00 00 00 e9 77 e9 ff ff 90 90 90  
90 90 90 90 90 90 55 48 89 e5 65 48 8b 04 25 40 fe 01 00 <65> 8b 15 04 89  
8f 7e 81 e2 00 01 1f 00 48 8b 75 08 75 2b 8b 90 f0
RSP: 0018:ffff88821b02f098 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: ffff88806c8524c0 RBX: ffff888096f52c38 RCX: ffffc9000bf4d000
RDX: 0000000000000000 RSI: ffffffff85c65fd2 RDI: ffff888096f52cec
RBP: ffff88821b02f098 R08: ffff88806c8524c0 R09: 0000000000000000
R10: fffffbfff134afaf R11: ffff88806c8524c0 R12: dffffc0000000000
R13: ffff888096f52940 R14: 0000000000000000 R15: 0000000000000000
  hhf_dequeue+0x586/0xa20 net/sched/sch_hhf.c:438
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
  br_forward+0x47c/0x500 net/bridge/br_forward.c:158
  br_dev_xmit+0xbf0/0x15a0 net/bridge/br_device.c:102
  __netdev_start_xmit include/linux/netdevice.h:4406 [inline]
  netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  xmit_one net/core/dev.c:3280 [inline]
  dev_hard_start_xmit+0x1a3/0x9c0 net/core/dev.c:3296
  __dev_queue_xmit+0x2b15/0x3650 net/core/dev.c:3869
  dev_queue_xmit+0x18/0x20 net/core/dev.c:3902
  pppoe_sendmsg+0x661/0x7f0 drivers/net/ppp/pppoe.c:899
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg net/socket.c:2439 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20901b4c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00000000004598e9
RDX: 000000000000033b RSI: 000000002000d180 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f20901b56d4
R13: 00000000004c70a7 R14: 00000000004dc768 R15: 00000000ffffffff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
