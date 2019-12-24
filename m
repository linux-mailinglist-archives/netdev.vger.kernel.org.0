Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0212A1DE
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 14:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfLXNzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 08:55:10 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45091 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfLXNzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 08:55:09 -0500
Received: by mail-il1-f199.google.com with SMTP id w6so16526359ill.12
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 05:55:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HTS91YZtQ+nhf8htPCL+NrUOqd0ulo/vpjIraIDE+gY=;
        b=fyVrK0sa7vny7YLbbJcvoFhM0NtLcebFaXd/kT/rzQ/2T7ZfP+aT1sW05kbWyi/qaL
         9dYjxrWOkUtBwVbfgmU3eIGM0tIdb77Rzml/2ghmroaJNk6GRFBb6ZOtErr3SZVbox3i
         Rr0o61rR3W6rgsQoHcdy+UYFm4VaP0aOojcKevH+JZldpkoXrdGIBuF+MYRSlqgu5x0X
         8ICtKDo9blkBvMWW7en9s0C9QkzbbXy/kRwMVBPCrIQO1rqoGroxLF72QehNF2YjHQoS
         Ob41m5LzjtObFUE05PDGiSvbBeu5e12yThyB9eSVwOs1LZihfokyKddqjWs3ZckEfxT3
         qo1w==
X-Gm-Message-State: APjAAAXm812PYNxLF17UKtTYK59NxNVPBvUSOErGpO05JPdSacrzLltW
        lq/q0gaPyvP4TJiAhBO6YimG3sWiRUAw+pe8juP0qNKxE9Bg
X-Google-Smtp-Source: APXvYqwNrHgr8EEnnliv852BZWW5QbQkT3xAgCyKBrk3d6pXf1TI4Kuyq/ScmTXrW+EiCidBrrH+Cf61d1RcqMo0ARY/iLPLhoFf
MIME-Version: 1.0
X-Received: by 2002:a92:1f16:: with SMTP id i22mr31046660ile.206.1577195709000;
 Tue, 24 Dec 2019 05:55:09 -0800 (PST)
Date:   Tue, 24 Dec 2019 05:55:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9f9a8059a737d7e@google.com>
Subject: INFO: rcu detected stall in br_handle_frame (2)
From:   syzbot <syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com>
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

HEAD commit:    7e0165b2 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=116ec09ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1b59a3066828ac4c
dashboard link: https://syzkaller.appspot.com/bug?extid=dc9071cc5a85950bdfce
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159182c1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1221218ee00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158224c1e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=178224c1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=138224c1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 0, t=10502 jiffies, g=10149, q=201)
rcu: All QSes seen, last rcu_preempt kthread activity 10502  
(4294978441-4294967939), jiffies_till_next_fqs=1, root ->qsmask 0x0
sshd            R  running task    26584 10034   9965 0x00000008
Call Trace:
  <IRQ>
  sched_show_task kernel/sched/core.c:5954 [inline]
  sched_show_task.cold+0x2ee/0x35d kernel/sched/core.c:5929
  print_other_cpu_stall kernel/rcu/tree_stall.h:410 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:538 [inline]
  rcu_pending kernel/rcu/tree.c:2827 [inline]
  rcu_sched_clock_irq.cold+0xaf4/0xc02 kernel/rcu/tree.c:2271
  update_process_times+0x2d/0x70 kernel/time/timer.c:1726
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1310
  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
RIP: 0010:fq_dequeue+0x7b3/0x16a0 net/sched/sch_fq.c:506
Code: 4d 89 af d8 02 00 00 49 c7 45 48 00 00 00 00 e9 01 fd ff ff e8 7e 56  
30 fb 48 8b 45 90 48 89 45 d0 48 8b 45 a0 42 80 3c 30 00 <0f> 85 4f 0c 00  
00 4d 8b af d0 02 00 00 4d 85 ed 0f 85 ff fc ff ff
RSP: 0018:ffffc90000006ab8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 1ffff1101246725a RBX: 0000000000000000 RCX: ffffffff8644d3d3
RDX: 0000000000000100 RSI: ffffffff8644d672 RDI: ffff88809708c728
RBP: ffffc90000006b40 R08: ffff88809cba2300 R09: fffffbfff16599c5
R10: fffffbfff16599c4 R11: ffffffff8b2cce27 R12: ffff8880923392d8
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888092339000
  dequeue_skb net/sched/sch_generic.c:263 [inline]
  qdisc_restart net/sched/sch_generic.c:366 [inline]
  __qdisc_run+0x1a5/0x1770 net/sched/sch_generic.c:384
  __dev_xmit_skb net/core/dev.c:3677 [inline]
  __dev_queue_xmit+0x163f/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  br_dev_queue_push_xmit+0x3f3/0x5e0 net/bridge/br_forward.c:52
  br_nf_dev_queue_xmit+0x34e/0x14b0 net/bridge/br_netfilter_hooks.c:800
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  br_nf_post_routing+0x14e9/0x1d10 net/bridge/br_netfilter_hooks.c:848
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:262 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  br_forward_finish+0x215/0x3f0 net/bridge/br_forward.c:65
  br_nf_hook_thresh+0x2e9/0x370 net/bridge/br_netfilter_hooks.c:1019
  br_nf_forward_finish+0x667/0xa80 net/bridge/br_netfilter_hooks.c:564
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  br_nf_forward_ip net/bridge/br_netfilter_hooks.c:634 [inline]
  br_nf_forward_ip+0xc65/0x21d0 net/bridge/br_netfilter_hooks.c:575
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:262 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  __br_forward+0x393/0xaf0 net/bridge/br_forward.c:109
  deliver_clone+0x61/0xc0 net/bridge/br_forward.c:125
  br_flood+0x325/0x3d0 net/bridge/br_forward.c:232
  br_handle_frame_finish+0xb46/0x1670 net/bridge/br_input.c:162
  br_nf_hook_thresh+0x2e9/0x370 net/bridge/br_netfilter_hooks.c:1019
  br_nf_pre_routing_finish_ipv6+0x6fa/0xdb0  
net/bridge/br_netfilter_ipv6.c:206
  NF_HOOK include/linux/netfilter.h:307 [inline]
  br_nf_pre_routing_ipv6+0x456/0x830 net/bridge/br_netfilter_ipv6.c:236
  br_nf_pre_routing+0x1896/0x22b3 net/bridge/br_netfilter_hooks.c:505
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_bridge_pre net/bridge/br_input.c:224 [inline]
  br_handle_frame+0x806/0x1340 net/bridge/br_input.c:349
  __netif_receive_skb_core+0xfbc/0x30b0 net/core/dev.c:5051
  __netif_receive_skb_one_core+0xa8/0x1a0 net/core/dev.c:5148
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5264
  process_backlog+0x206/0x750 net/core/dev.c:6095
  napi_poll net/core/dev.c:6532 [inline]
  net_rx_action+0x508/0x1120 net/core/dev.c:6600
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:sk_page_frag include/net/sock.h:2255 [inline]
RIP: 0010:tcp_sendmsg_locked+0x1a1d/0x33a0 net/ipv4/tcp.c:1318
Code: f0 fe ff ff 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 00 17 00  
00 41 89 9e b8 00 00 00 41 bf f2 ff ff ff e9 7f 03 00 00 <e8> 9e 93 eb fa  
48 8b 85 90 fe ff ff 48 89 85 10 ff ff ff e9 a8 f5
RSP: 0018:ffffc90001df7920 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff888093571afc RCX: ffffffff86898ee8
RDX: 0000000000000400 RSI: 0000000000000400 RDI: 0000000000000005
RBP: ffffc90001df7ab0 R08: ffff88809cba2300 R09: ffffed1013bf3d5d
R10: ffffed1013bf3d5c R11: ffff88809df9eae3 R12: 0000000000000038
R13: ffff888093571a40 R14: ffff888085e92040 R15: dffffc0000000000
  tcp_sendmsg+0x30/0x50 net/ipv4/tcp.c:1436
  inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  sock_write_iter+0x2cb/0x400 net/socket.c:991
  call_write_iter include/linux/fs.h:1902 [inline]
  new_sync_write+0x4d3/0x770 fs/read_write.c:483
  __vfs_write+0xe1/0x110 fs/read_write.c:496
  vfs_write+0x268/0x5d0 fs/read_write.c:558
  ksys_write+0x220/0x290 fs/read_write.c:611
  __do_sys_write fs/read_write.c:623 [inline]
  __se_sys_write fs/read_write.c:620 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:620
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f5c7193a370
Code: 73 01 c3 48 8b 0d c8 4a 2b 00 31 d2 48 29 c2 64 89 11 48 83 c8 ff eb  
ea 90 90 83 3d 85 a2 2b 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 73 31 c3 48 83 ec 08 e8 0e 8a 01 00 48 89 04 24
RSP: 002b:00007ffdcd194578 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000038 RCX: 00007f5c7193a370
RDX: 0000000000000038 RSI: 000055bba62514a0 RDI: 0000000000000003
RBP: 000055bba62514a0 R08: 0000000000000001 R09: 0101010101010101
R10: 0000000000000008 R11: 0000000000000246 R12: 00007ffdcd1945dc
R13: 000055bba61fcfb4 R14: 0000000000000028 R15: 000055bba61feca0
rcu: rcu_preempt kthread starved for 10502 jiffies! g10149 f0x2  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29272    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
  rcu_gp_fqs_loop kernel/rcu/tree.c:1661 [inline]
  rcu_gp_kthread+0x9b2/0x18d0 kernel/rcu/tree.c:1821
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
