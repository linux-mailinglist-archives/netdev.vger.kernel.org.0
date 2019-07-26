Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AFC7629C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfGZJiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:38:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48787 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfGZJiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:38:07 -0400
Received: by mail-io1-f71.google.com with SMTP id z19so58166973ioi.15
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 02:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=j2PpSjwLnO2eIe3uBjpnMCjddJMfh5EpcYJWBvbsYKo=;
        b=RrwBdQyUSBXqed6KiUOTHrB+fZDVztlykbCO/qf0nPk6u0CWJvLZdDq3hxUQxXIuT7
         pYVATs+fZyCh5HRD7FXjnjQSulY2tSTU9zmJ2kLf+urLdXT1L/HPs88Da2UfAMuYz4us
         wIP1HaF7mqGko70xx43oW0plXhFPEmNdmPm3gQoCW3hqLIyn2dtEj5MXP9pVBcOuLpd+
         H+9swqRUZKr5nJB8lC1Y+Yn/y5oQ1X5fkGjRRBFJDw3UugPyOjk0v6BRxDReCx5rRL51
         qPwL5X8HTdiZfa3jjXOC3Py83ZyCrp8U7Ypf8UN49V63YL/CaNe26KhZyu40ZsM1/9Le
         mWkg==
X-Gm-Message-State: APjAAAWW+/zj+pCsBF8x+KYf79+SvcNGCxa+s/B2D4Ix+9xkrjUEU46D
        oVQLBc4OxZYNLcVxxPdzR+6SAVcr5ArxBgFHTaxmawMcULy6
X-Google-Smtp-Source: APXvYqx/f2gWDhwCONRj6jdiiIlMyabLv+3dxZoCyfbLX3KK64QU0+v3iKTWk3YEBBBdvasEay5lAUn8HZobIxyfkuXBjHnS0hI4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:281:: with SMTP id c1mr94958147jaq.43.1564133886487;
 Fri, 26 Jul 2019 02:38:06 -0700 (PDT)
Date:   Fri, 26 Jul 2019 02:38:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af7322058e924cde@google.com>
Subject: INFO: rcu detected stall in ipv6_rcv (2)
From:   syzbot <syzbot+34f3e3f781b524b5127a@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, arvid.brodin@alten.se, aviadye@mellanox.com,
        borisp@mellanox.com, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        huangfq.daxian@gmail.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    13bf6d6a Add linux-next specific files for 20190725
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16c5cd94600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ae987d803395886
dashboard link: https://syzkaller.appspot.com/bug?extid=34f3e3f781b524b5127a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e55df4600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142f7768600000

The bug was bisected to:

commit ccf355e52a3265624b7acadd693c849d599e9b9f
Author: Fuqian Huang <huangfq.daxian@gmail.com>
Date:   Mon Jul 8 12:34:17 2019 +0000

     net: phy: Make use of linkmode_mod_bit helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12285f58600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11285f58600000
console output: https://syzkaller.appspot.com/x/log.txt?x=16285f58600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+34f3e3f781b524b5127a@syzkaller.appspotmail.com
Fixes: ccf355e52a32 ("net: phy: Make use of linkmode_mod_bit helper")

TCP: request_sock_TCPv6: Possible SYN flooding on port 20002. Sending  
cookies.  Check SNMP counters.
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (1 GPs behind) idle=c0a/1/0x4000000000000002  
softirq=11627/11628 fqs=5250
	(t=10500 jiffies g=10477 q=33)
NMI backtrace for cpu 1
CPU: 1 PID: 10160 Comm: syz-executor291 Not tainted 5.3.0-rc1-next-20190725  
#52
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
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1068 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1093
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
RIP: 0010:cpu_relax arch/x86/include/asm/processor.h:656 [inline]
RIP: 0010:virt_spin_lock arch/x86/include/asm/qspinlock.h:84 [inline]
RIP: 0010:native_queued_spin_lock_slowpath+0x132/0x9f0  
kernel/locking/qspinlock.c:325
Code: 00 00 00 48 8b 45 d0 65 48 33 04 25 28 00 00 00 0f 85 37 07 00 00 48  
81 c4 98 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 f3 90 <e9> 73 ff ff ff  
8b 45 98 4c 8d 65 d8 3d 00 01 00 00 0f 84 e5 00 00
RSP: 0018:ffff8880ae909210 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff88809338ad08 RCX: ffffffff81599777
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88809338ad08
RBP: ffff8880ae9092d0 R08: 1ffff110126715a1 R09: ffffed10126715a2
R10: ffffed10126715a1 R11: ffff88809338ad0b R12: 0000000000000001
R13: 0000000000000003 R14: ffffed10126715a1 R15: 0000000000000001
  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:642 [inline]
  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
  do_raw_spin_lock+0x20e/0x2e0 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  release_sock+0x20/0x1c0 net/core/sock.c:2932
  wait_on_pending_writer+0x20f/0x420 net/tls/tls_main.c:91
  tls_sk_proto_cleanup+0x2c5/0x3e0 net/tls/tls_main.c:295
  tls_sk_proto_unhash+0x90/0x3f0 net/tls/tls_main.c:330
  tcp_set_state+0x5b9/0x7d0 net/ipv4/tcp.c:2235
  tcp_done+0xe2/0x320 net/ipv4/tcp.c:3824
  tcp_reset+0x132/0x500 net/ipv4/tcp_input.c:4080
  tcp_validate_incoming+0xa2d/0x1660 net/ipv4/tcp_input.c:5440
  tcp_rcv_established+0x6b5/0x1e70 net/ipv4/tcp_input.c:5648
  tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
  tcp_v6_rcv+0x31f1/0x3500 net/ipv6/tcp_ipv6.c:1588
  ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
  dst_input include/net/dst.h:442 [inline]
  ip6_rcv_finish+0x1de/0x2f0 net/ipv6/ip6_input.c:76
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:272
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:4999
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5113
  process_backlog+0x206/0x750 net/core/dev.c:5924
  napi_poll net/core/dev.c:6347 [inline]
  net_rx_action+0x508/0x10c0 net/core/dev.c:6413
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1080
  </IRQ>
  do_softirq.part.0+0x11a/0x170 kernel/softirq.c:337
  do_softirq kernel/softirq.c:329 [inline]
  __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:189
  local_bh_enable include/linux/bottom_half.h:32 [inline]
  inet_csk_listen_stop+0x1e0/0x850 net/ipv4/inet_connection_sock.c:993
  tcp_close+0xd5b/0x10e0 net/ipv4/tcp.c:2338
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x406571
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 24 1a 00 00 c3 48  
83 ec 08 e8 6a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 b3 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffc1a1a5e00 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000406571
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00000000006dcc20 R08: 0000000000000140 R09: 0000000000000140
R10: 00007ffc1a1a5e30 R11: 0000000000000293 R12: 00007ffc1a1a5e60
R13: 00000000006dcc2c R14: 000000000000002d R15: 0000000000000007


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
