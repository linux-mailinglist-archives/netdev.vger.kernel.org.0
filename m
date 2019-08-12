Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C76489E6C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHLMcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:32:13 -0400
Received: from mail-ot1-f69.google.com ([209.85.210.69]:50833 "EHLO
        mail-ot1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfHLMcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:32:07 -0400
Received: by mail-ot1-f69.google.com with SMTP id a21so84076666otk.17
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 05:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=F+Oypquq9n9HNtY0Jqz/I2k0r7GDi/1v7gcMDKXbWlE=;
        b=PvjysTWTPUvbROsvpEko2/dZ6hVMWhUTuPrMGUVQbjuIpdCeZ2jP8XXFXoWESuztez
         RFT+8gB+0TNWkrSiscKzTr9apB+YXrGT9OGxZJAE9GjUWZbwSONqQxMgwq2PkL8Lt8Sg
         0fCJbzFz6FUhxAO/ECTXwocvbwmk71GWz8pgZ5b5vjF2a9Aqeh3NUr6DNcuSRtXETM+V
         eHVc5d+IK6RLwkPvpKVnds+s97hRfqKAtACsGFnZUilVxyFUQnDq4l3vSma45+Rxm4BQ
         aHE8IE66tSC783cdcqb4p+PU9E9H0Gq1NZErHV1+aKihRQK4PpJNmylYpen8A22sWIJA
         PmqA==
X-Gm-Message-State: APjAAAWyVY29kr1k7HX+qj3kCMWfZaeCx2z8KozYi3MfHV+poaetKwqy
        bJVFiKiNYVxgJNm3WGTlmqQMlHp1AM2LijThKqctZRfcSKHp
X-Google-Smtp-Source: APXvYqzrtWFHnbEloBir+fmz7uABlgzef1lpytcLzrTXzSQggrWpwANNp8vqBFsRyv7qmkIOACELyvadSNojmI3SAmgM013Ybtdm
MIME-Version: 1.0
X-Received: by 2002:a02:5246:: with SMTP id d67mr30490319jab.58.1565613126300;
 Mon, 12 Aug 2019 05:32:06 -0700 (PDT)
Date:   Mon, 12 Aug 2019 05:32:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fbaef058feab6e5@google.com>
Subject: INFO: rcu detected stall in inet6_sendmsg
From:   syzbot <syzbot+2461d4a2bb70325dcdab@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        soheil@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b1645c0c Add linux-next specific files for 20190805
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=116e598a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b837e78be990c60a
dashboard link: https://syzkaller.appspot.com/bug?extid=2461d4a2bb70325dcdab
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2461d4a2bb70325dcdab@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 0, t=10502 jiffies, g=33389, q=24)
rcu: All QSes seen, last rcu_preempt kthread activity 10503  
(4294976899-4294966396), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor.0  R  running task    25096 17466  10161 0x0000400e
Call Trace:
  <IRQ>
  sched_show_task kernel/sched/core.c:5814 [inline]
  sched_show_task.cold+0x2ed/0x34e kernel/sched/core.c:5789
  print_other_cpu_stall kernel/rcu/tree_stall.h:410 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:536 [inline]
  rcu_pending kernel/rcu/tree.c:2736 [inline]
  rcu_sched_clock_irq.cold+0xac8/0xc13 kernel/rcu/tree.c:2183
  update_process_times+0x32/0x80 kernel/time/timer.c:1724
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1299
  __run_hrtimer kernel/time/hrtimer.c:1493 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1555
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1617
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1068 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1093
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:check_memory_region+0x1f/0x1a0 mm/kasan/generic.c:191
Code: 00 66 2e 0f 1f 84 00 00 00 00 00 48 85 f6 0f 84 34 01 00 00 48 b8 ff  
ff ff ff ff 7f ff ff 55 0f b6 d2 48 39 c7 48 89 e5 41 55 <41> 54 53 0f 86  
07 01 00 00 4c 8d 5c 37 ff 49 89 f8 48 b8 00 00 00
RSP: 0018:ffff88805be977b8 EFLAGS: 00000216 ORIG_RAX: ffffffffffffff13
RAX: ffff7fffffffffff RBX: ffff8880625080c8 RCX: ffffffff8158f457
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8880625080c8
RBP: ffff88805be977c0 R08: 1ffff1100c4a1019 R09: ffffed100c4a101a
R10: ffffed100c4a1019 R11: ffff8880625080cb R12: 0000000000000001
R13: 0000000000000003 R14: ffffed100c4a1019 R15: 0000000000000001
  __kasan_check_read+0x11/0x20 mm/kasan/common.c:92
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  virt_spin_lock arch/x86/include/asm/qspinlock.h:83 [inline]
  native_queued_spin_lock_slowpath+0xb7/0x9f0 kernel/locking/qspinlock.c:325
  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:642 [inline]
  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
  do_raw_spin_lock+0x20e/0x2e0 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  lock_sock_nested+0x41/0x120 net/core/sock.c:2917
  lock_sock include/net/sock.h:1522 [inline]
  sk_stream_wait_memory+0x83f/0xfc0 net/core/stream.c:149
  tls_sw_sendmsg+0x673/0x17b0 net/tls/tls_sw.c:1054
  inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1c16940c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1c169416d4
R13: 00000000004c77d9 R14: 00000000004dcf90 R15: 00000000ffffffff
rcu: rcu_preempt kthread starved for 10547 jiffies! g33389 f0x2  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29688    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x15b0 kernel/sched/core.c:3921
  schedule+0xa8/0x270 kernel/sched/core.c:3985
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1893
  rcu_gp_fqs_loop kernel/rcu/tree.c:1611 [inline]
  rcu_gp_kthread+0x9b2/0x18c0 kernel/rcu/tree.c:1768
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
