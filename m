Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0846CAF1C6
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfIJTSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:18:11 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53295 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfIJTSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:18:10 -0400
Received: by mail-io1-f70.google.com with SMTP id l21so24394305iob.20
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 12:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KICzFkLeQqtEwysB2QmS9o7mzKO9jXpOrCeO4D7f/cI=;
        b=WoesZfQajsMLJZur5GyKwwcnRPgrRWdweQFT5yLmdB0Hv4e1p95/Ls0N9CbGIko1DU
         wetV0mySFh5NuycY3o5KJHn/d8GnIJXZBSiE7+zrJ5YLGNgxDUa9NaBwGyENZkAEJQfa
         eTBXWN3OznuMtoBZgSOz8dYn7pT+WtLBsghj0mBdF7GCS97em0ebhHPYaUCb/wTQjsH7
         7Y2y8eX8PvD4zTkRm1S8tsSi31U+AfOluMqtYBw5anqGTwrO7R4/m3KExnDQ3pLvj1W5
         VwDAgbNteI34oF9Vabom8rqm6GgazYkpzaZTR2rwMEEEVTJY5r7WWQ09osHvfurrmuWl
         GXJg==
X-Gm-Message-State: APjAAAUQ6cRywzjByrupUwIIoeXi/xMqTTELJx0nIVaAL+wJS4tpZwvr
        YPklswj5lYIHmxaOBq0dq/uOU2U7yg6tRVQpp5VE64TNH1/g
X-Google-Smtp-Source: APXvYqxPzKg6GbeoH6yRm1PjX2izZMuz0ieNKYMovQHrdeRH4rFXfA13QHVvWiKOqCtfYE2/LBdKRcjOVwklvTsHVCfIvW8qlWT4
MIME-Version: 1.0
X-Received: by 2002:a5d:888b:: with SMTP id d11mr26874923ioo.236.1568143088331;
 Tue, 10 Sep 2019 12:18:08 -0700 (PDT)
Date:   Tue, 10 Sep 2019 12:18:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bcb83d059237c30a@google.com>
Subject: INFO: rcu detected stall in br_handle_frame
From:   syzbot <syzbot+2addc1f058bd021b0a40@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=12983001600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=2addc1f058bd021b0a40
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d8afae600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1253d1fa600000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=109dcfc6600000
console output: https://syzkaller.appspot.com/x/log.txt?x=149dcfc6600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2addc1f058bd021b0a40@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (10500 ticks this GP) idle=c4e/1/0x4000000000000002  
softirq=10445/10445 fqs=0
	(t=10500 jiffies g=10669 q=248)
rcu: rcu_preempt kthread starved for 10500 jiffies! g10669 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29392    10      2 0x80004000
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
CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.3.0-rc7+ #0
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
RIP: 0010:write_comp_data+0x68/0x70 kernel/kcov.c:147
Code: 00 00 4e 8d 14 dd 28 00 00 00 4d 39 d0 72 1b 49 83 c1 01 4a 89 7c 10  
e0 4a 89 74 10 e8 4a 89 54 10 f0 4a 89 4c d8 20 4c 89 08 <c3> 0f 1f 80 00  
00 00 00 55 40 0f b6 d6 40 0f b6 f7 31 ff 48 89 e5
RSP: 0018:ffff8880a98be990 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000301 RBX: ffff88808c6eb0b8 RCX: ffffffff85c64b39
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: ffff8880a98be998 R08: ffff8880a98b2240 R09: 0000000000000000
R10: fffffbfff134af8f R11: ffff8880a98b2240 R12: dffffc0000000000
R13: ffff88808c6eadc0 R14: ffff88808c6eb150 R15: 0000000000000000
  hhf_dequeue+0xb9/0xa20 net/sched/sch_hhf.c:434
  dequeue_skb net/sched/sch_generic.c:258 [inline]
  qdisc_restart net/sched/sch_generic.c:361 [inline]
  __qdisc_run+0x1e7/0x19d0 net/sched/sch_generic.c:379
  __dev_xmit_skb net/core/dev.c:3533 [inline]
  __dev_queue_xmit+0x16f1/0x3650 net/core/dev.c:3838
  dev_queue_xmit+0x18/0x20 net/core/dev.c:3902
  br_dev_queue_push_xmit+0x3f3/0x5c0 net/bridge/br_forward.c:52
  br_nf_dev_queue_xmit+0x34e/0x1470 net/bridge/br_netfilter_hooks.c:796
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  br_nf_post_routing+0x1502/0x1d30 net/bridge/br_netfilter_hooks.c:844
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:260 [inline]
  NF_HOOK include/linux/netfilter.h:303 [inline]
  br_forward_finish+0x215/0x400 net/bridge/br_forward.c:65
  br_nf_hook_thresh+0x2e9/0x370 net/bridge/br_netfilter_hooks.c:1015
  br_nf_forward_finish+0x66c/0xa90 net/bridge/br_netfilter_hooks.c:560
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  br_nf_forward_ip net/bridge/br_netfilter_hooks.c:630 [inline]
  br_nf_forward_ip+0xc74/0x21e0 net/bridge/br_netfilter_hooks.c:571
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:260 [inline]
  NF_HOOK include/linux/netfilter.h:303 [inline]
  __br_forward+0x393/0xb00 net/bridge/br_forward.c:109
  deliver_clone+0x61/0xc0 net/bridge/br_forward.c:125
  br_flood+0x325/0x3d0 net/bridge/br_forward.c:232
  br_handle_frame_finish+0xb46/0x1670 net/bridge/br_input.c:162
  br_nf_hook_thresh+0x2e9/0x370 net/bridge/br_netfilter_hooks.c:1015
  br_nf_pre_routing_finish_ipv6+0x6fb/0xd80  
net/bridge/br_netfilter_ipv6.c:206
  NF_HOOK include/linux/netfilter.h:305 [inline]
  br_nf_pre_routing_ipv6+0x456/0x832 net/bridge/br_netfilter_ipv6.c:236
  br_nf_pre_routing+0x1743/0x2355 net/bridge/br_netfilter_hooks.c:501
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_bridge_pre net/bridge/br_input.c:223 [inline]
  br_handle_frame+0x806/0x133e net/bridge/br_input.c:348
  __netif_receive_skb_core+0xfc1/0x3060 net/core/dev.c:4905
  __netif_receive_skb_one_core+0xa8/0x1a0 net/core/dev.c:5002
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5118
  process_backlog+0x206/0x750 net/core/dev.c:5929
  napi_poll net/core/dev.c:6352 [inline]
  net_rx_action+0x4d6/0x1030 net/core/dev.c:6418
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
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
