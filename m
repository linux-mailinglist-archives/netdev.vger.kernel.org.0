Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908AA8675E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390269AbfHHQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:45:07 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:55591 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHHQpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 12:45:06 -0400
Received: by mail-ot1-f72.google.com with SMTP id p7so62887447otk.22
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 09:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pCP8x+c3NdmQMNT+LHA6K3XzXnAObCZ6ntIBW771GIM=;
        b=mL1HvMT00Isru5ETgBbv49IofCzooBZZGurHlHuiSxGZZHyZnt7cRpCF2G6X0uDXvx
         w2glw+DdMY7POr6/FDGQxLM1g/P3BnS6Re4VeY0fBxlRkx2U/3zjzX1e5pF6Iihgo+qO
         AilKMr9/HGtgxP28UdYilwNdRc9L4sxy6aZdoZZg6Uu5Y725pZVkmLKdxb9MExc92APx
         fkOQM0uu/h58w1bqBqNvl51EvFIQ3APDBUTewDa4vd7o8s147vuXXhcVgstWGgtYe0re
         ka1j1/DuB6B8Ntw31MdOZeYS3wQFA0Sqgx4SN38Q+YUVMeu8+KoUAqoz0APSMCleBIYz
         bv8Q==
X-Gm-Message-State: APjAAAXiyVvH1yFb/vVfOlbrNuOtNdZ6+hPCUtdG+QhtGSWtdbfzitse
        kcthXjLa+6y30usWw95jFeiXUGFS/OO47B2c1bJCAExK5pxL
X-Google-Smtp-Source: APXvYqyKZOG/tnmvcHVs/lnVgia1SmEKFAl2TJJr91WPNOtvwVYVhOvsr5tAKftpEUX5MjcOQuAl2XktGfyghSfgZBa3BS6XROE2
MIME-Version: 1.0
X-Received: by 2002:a5d:9613:: with SMTP id w19mr109048iol.140.1565282705187;
 Thu, 08 Aug 2019 09:45:05 -0700 (PDT)
Date:   Thu, 08 Aug 2019 09:45:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009dac7f058f9dc763@google.com>
Subject: INFO: rcu detected stall in tcp_write_timer
From:   syzbot <syzbot+1f80b70f1e8f1df46319@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, kafai@fb.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ce96e791 Add linux-next specific files for 20190731
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12b2efd0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fca5b9d53db6585c
dashboard link: https://syzkaller.appspot.com/bug?extid=1f80b70f1e8f1df46319
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1f80b70f1e8f1df46319@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 1, t=10502 jiffies, g=28777, q=38)
rcu: All QSes seen, last rcu_preempt kthread activity 10503  
(4294973637-4294963134), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor.5  R  running task    27376 17588  10322 0x00004008
Call Trace:
  <IRQ>
  sched_show_task kernel/sched/core.c:5814 [inline]
  sched_show_task.cold+0x2ed/0x34e kernel/sched/core.c:5789
  print_other_cpu_stall kernel/rcu/tree_stall.h:410 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:536 [inline]
  rcu_pending kernel/rcu/tree.c:2736 [inline]
  rcu_sched_clock_irq.cold+0xac8/0xc13 kernel/rcu/tree.c:2183
  update_process_times+0x32/0x80 kernel/time/timer.c:1639
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1296
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1068 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1093
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
RIP: 0010:__kasan_check_read+0x0/0x20 mm/kasan/common.c:91
Code: e8 e9 c0 ae ff 0f 0b 4c 8b 4d d0 e9 27 ee ff ff 48 8b 73 58 89 c2 48  
c7 c7 e0 c2 89 88 f7 da e8 ca c0 ae ff e9 da ee ff ff 90 <55> 89 f6 31 d2  
48 89 e5 48 8b 4d 08 e8 cf 26 00 00 5d c3 0f 1f 00
RSP: 0018:ffff8880ae909b40 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff8880601cce08 RCX: ffffffff8158f467
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8880601cce08
RBP: ffff8880ae909c08 R08: 1ffff1100c0399c1 R09: ffffed100c0399c2
R10: ffffed100c0399c1 R11: ffff8880601cce0b R12: 0000000000000001
R13: 0000000000000003 R14: ffffed100c0399c1 R15: 0000000000000001
  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:642 [inline]
  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
  do_raw_spin_lock+0x20e/0x2e0 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
  _raw_spin_lock+0x37/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  tcp_write_timer+0x2b/0x1e0 net/ipv4/tcp_timer.c:610
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1095
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:828
  </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:756  
[inline]
RIP: 0010:slab_alloc mm/slab.c:3312 [inline]
RIP: 0010:__do_kmalloc mm/slab.c:3653 [inline]
RIP: 0010:__kmalloc+0x2b8/0x770 mm/slab.c:3664
Code: 7e 0f 85 d6 fe ff ff e8 26 c5 53 ff e9 cc fe ff ff e8 1c ff ca ff 48  
83 3d e4 52 26 07 00 0f 84 4f 03 00 00 48 8b 7d c0 57 9d <0f> 1f 44 00 00  
e9 5e fe ff ff 31 d2 be 35 02 00 00 48 c7 c7 ce c0
RSP: 0018:ffff888069e978c0 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: 0000000000000dc0 RCX: 1ffffffff134c016
RDX: 0000000000000000 RSI: ffffffff8177a12e RDI: 0000000000000286
RBP: ffff888069e97938 R08: ffff888064bee240 R09: ffffed10154802c1
R10: ffffed10154802c0 R11: ffff8880aa401603 R12: 0000000000000100
R13: 0000000000000dc0 R14: ffff8880aa4008c0 R15: ffff88805f8e7dc0
  kmalloc_array include/linux/slab.h:614 [inline]
  kcalloc include/linux/slab.h:625 [inline]
  iter_file_splice_write+0x16e/0xbe0 fs/splice.c:690
  do_splice_from fs/splice.c:848 [inline]
  direct_splice_actor+0x123/0x190 fs/splice.c:1020
  splice_direct_to_actor+0x366/0x970 fs/splice.c:975
  do_splice_direct+0x1da/0x2a0 fs/splice.c:1063
  do_sendfile+0x597/0xd00 fs/read_write.c:1464
  __do_sys_sendfile64 fs/read_write.c:1519 [inline]
  __se_sys_sendfile64 fs/read_write.c:1511 [inline]
  __x64_sys_sendfile64+0x15a/0x220 fs/read_write.c:1511
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9691478c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000459829
RDX: 0000000020001000 RSI: 0000000000000003 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000ffff R11: 0000000000000246 R12: 00007f96914796d4
R13: 00000000004c6ff7 R14: 00000000004dc558 R15: 00000000ffffffff
rcu: rcu_preempt kthread starved for 10569 jiffies! g28777 f0x2  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29688    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x15b0 kernel/sched/core.c:3921
  schedule+0xa8/0x270 kernel/sched/core.c:3985
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1807
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
