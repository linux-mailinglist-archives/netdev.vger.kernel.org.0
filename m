Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5A4AC5F6
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfIGJ4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 05:56:08 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:46675 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfIGJ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 05:56:07 -0400
Received: by mail-io1-f69.google.com with SMTP id o3so10977282iom.13
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 02:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WO555lkaxvVn5IWJ49GqqEscmE5LpyLr2xvoh4L9LSI=;
        b=hlO40fri7M6SUcHmcsEjUxeVkuN5P4PRqf37yJzWUPb1/bkjemxjGs5g1x/FkyM2X2
         ts3P8XqpuUdDhAsZwuy6M9Sbp6Iik/lcgkadfDIY5ua+g5qdu3HHQEhM9gKhQvk7UGu5
         8XYnhgu9ScttKopEM8k/YFwF7IPMqjBNMaUfOWBgFMt5JUi+xDIXisEh9SrDr18Z6e8T
         9BlX1RQLFkyyS+I9cXayhkJ6mpgpt1pELba2yNjs6+rpIiG7EC2rdtxD+nojFC4CI2ea
         h8Q7sG0SG+RZYY0GHhhnl5paBm3j2ZycrqIQTYj8828lH8OgB/OBQsW8/qwqqyqckq6B
         htsQ==
X-Gm-Message-State: APjAAAU5dzK/VuxCrqeS+kBfzVGHjxyTBFExhgXrhqA4/9rF9iWdPqAp
        fjIZOwhuxByk5k6GWRxpEm/HVNYIqREWXXlS/OgURrRpjap2
X-Google-Smtp-Source: APXvYqy4MVY5KW7kK4pg8kLzexOHFvtn3VQRTYhL8wLXxtoQmIKW/IM08ajWX5hDnCNRm51ux3VqzaZeyaq+NJAR1soMRBrreGg6
MIME-Version: 1.0
X-Received: by 2002:a5d:9c0b:: with SMTP id 11mr10843494ioe.192.1567850166289;
 Sat, 07 Sep 2019 02:56:06 -0700 (PDT)
Date:   Sat, 07 Sep 2019 02:56:06 -0700
In-Reply-To: <000000000000a26437057e4915ff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000390e940591f390a6@google.com>
Subject: Re: INFO: rcu detected stall in igmp_ifc_timer_expire
From:   syzbot <syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, jhs@mojatatu.com,
        jiri@resnulli.us, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    1e3778cb Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12df164e600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=041483004a7f45f1f20a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148c3001600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13b12cd1600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+041483004a7f45f1f20a@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (1 GPs behind) idle=b8e/0/0x3 softirq=12119/12122 fqs=6
	(t=10500 jiffies g=10289 q=55)
rcu: rcu_preempt kthread starved for 10480 jiffies! g10289 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29520    10      2 0x80004000
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
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.3.0-rc7+ #0
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
RIP: 0010:__list_del_entry_valid+0xb3/0xf5 lib/list_debug.c:54
Code: 75 53 49 8b 14 24 4c 39 f2 0f 85 99 00 00 00 49 8d 7d 08 48 b8 00 00  
00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 24 <49> 8b 55 08 4c  
39 f2 0f 85 aa 00 00 00 41 5c b8 01 00 00 00 41 5d
RSP: 0018:ffff8880ae909010 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: dffffc0000000000 RBX: ffff88808c064338 RCX: ffffffff85c65b39
RDX: 1ffff1101180c87b RSI: ffffffff85c66006 RDI: ffff88808c0643d8
RBP: ffff8880ae909028 R08: ffff8880a98d6340 R09: 0000000000000000
R10: fffffbfff134afaf R11: ffff8880a98d6340 R12: ffff88808c0643d0
R13: ffff88808c0643d0 R14: ffff88808c064338 R15: 0000000000000000
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
  neigh_hh_output include/net/neighbour.h:500 [inline]
  neigh_output include/net/neighbour.h:509 [inline]
  ip_finish_output2+0x1726/0x2570 net/ipv4/ip_output.c:228
  __ip_finish_output net/ipv4/ip_output.c:308 [inline]
  __ip_finish_output+0x5fc/0xb90 net/ipv4/ip_output.c:290
  ip_finish_output+0x38/0x1f0 net/ipv4/ip_output.c:318
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip_output+0x21f/0x640 net/ipv4/ip_output.c:432
  dst_output include/net/dst.h:436 [inline]
  ip_local_out+0xbb/0x190 net/ipv4/ip_output.c:125
  igmpv3_sendpack+0x1b5/0x2c0 net/ipv4/igmp.c:426
  igmpv3_send_cr net/ipv4/igmp.c:721 [inline]
  igmp_ifc_timer_expire+0x687/0xa00 net/ipv4/igmp.c:809
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1133
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 38 73 6e fa eb 8a 90 90 90 90 90 90 e9 07 00 00 00 0f 00 2d 24 1b 4a  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 14 1b 4a 00 fb f4 <c3> 90 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 ee 32 22 fa e8 39
RSP: 0018:ffff8880a98e7d68 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff11a5e8d RBX: ffff8880a98d6340 RCX: 1ffffffff134b5ee
RDX: dffffc0000000000 RSI: ffffffff8177f14e RDI: ffffffff873e050c
RBP: ffff8880a98e7d98 R08: ffff8880a98d6340 R09: ffffed101531ac69
R10: ffffed101531ac68 R11: ffff8880a98d6347 R12: dffffc0000000000
R13: ffffffff89a57d78 R14: 0000000000000000 R15: 0000000000000001
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
  default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x413/0x760 kernel/sched/idle.c:263
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:354
  start_secondary+0x315/0x430 arch/x86/kernel/smpboot.c:264
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

