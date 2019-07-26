Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C306D7629E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGZJiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:38:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34124 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfGZJiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:38:07 -0400
Received: by mail-io1-f71.google.com with SMTP id u84so58222994iod.1
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 02:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QDNthF8eUHdqYI8kSSEW4zJ8AlkW+NY0ccSrbtgPmUo=;
        b=GfFM6CMKcSceo4igsbWlEdBoRFkgh0/2zkSZLWUCyowANuGF+6t+nsLXoRBulTkfUv
         FTUGbTfcSZz3yNYpnSH/WzohzaQw/FTp+sqRB2hiqIdj7Qum77/WbiN28sTgkyDWIWQH
         PvkJ8GojbaIvpJEDvMGvayUhcNDzdq79nYqB00k+j567g0vtIpHTr2URntaJ+1k5QmoU
         /O63nayHSHbJcnFdJmgwgej1iruQUsu67R94k/ZPCk2JytHtsJ1fesu6zUlEkBC/ribx
         h1gdRT4x1BypXWKHjr0ke0W498QHvbcqr4D0oGmvW/k+QEgMH/nZ4Vwtruu9+rCF8/V8
         zf3g==
X-Gm-Message-State: APjAAAVQ36+3w42WmBpZ8US7jfAl9WN0XvHodA2cZBA1UcDHnSV/z8+r
        xBWrzx6iQwur5PY8RDWuO9CceqjaLbsjt+b4O3QwBEPbvBke
X-Google-Smtp-Source: APXvYqxZyRhoRRM4yZ/SXtXxqgJFOOdNBkxlozj1hSnyOWnQiwPMwSyUjqxsEA+FwP5IKOIsmu9huWtjTJ7T27mCGuM0yNwEzorL
MIME-Version: 1.0
X-Received: by 2002:a02:8816:: with SMTP id r22mr22730032jai.60.1564133886797;
 Fri, 26 Jul 2019 02:38:06 -0700 (PDT)
Date:   Fri, 26 Jul 2019 02:38:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4358f058e924c6d@google.com>
Subject: INFO: rcu detected stall in vhost_worker
From:   syzbot <syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    13bf6d6a Add linux-next specific files for 20190725
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=141449f0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ae987d803395886
dashboard link: https://syzkaller.appspot.com/bug?extid=36e93b425cd6eb54fcc1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15112f3fa00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131ab578600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+36e93b425cd6eb54fcc1@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (10500 ticks this GP) idle=a56/1/0x4000000000000002  
softirq=12266/12266 fqs=5250
	(t=10502 jiffies g=14905 q=12)
NMI backtrace for cpu 0
CPU: 0 PID: 10848 Comm: vhost-10847 Not tainted 5.3.0-rc1-next-20190725 #52
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
  </IRQ>
RIP: 0010:check_memory_region_inline mm/kasan/generic.c:173 [inline]
RIP: 0010:check_memory_region+0x0/0x1a0 mm/kasan/generic.c:192
Code: 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 f2 be f8 00 00 00 48 89 e5 e8  
df 60 90 05 5d c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 <48> 85 f6 0f 84  
34 01 00 00 48 b8 ff ff ff ff ff 7f ff ff 55 0f b6
RSP: 0018:ffff8880a40bf950 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff8880836a8220 RCX: ffffffff81599777
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8880836a8220
RBP: ffff8880a40bf958 R08: 1ffff110106d5044 R09: ffffed10106d5045
R10: ffffed10106d5044 R11: ffff8880836a8223 R12: 0000000000000001
R13: 0000000000000003 R14: ffffed10106d5044 R15: 0000000000000001
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  virt_spin_lock arch/x86/include/asm/qspinlock.h:83 [inline]
  native_queued_spin_lock_slowpath+0xb7/0x9f0 kernel/locking/qspinlock.c:325
  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:642 [inline]
  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:81 [inline]
  do_raw_spin_lock+0x20e/0x2e0 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
  _raw_spin_lock+0x37/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  vhost_setup_uaddr drivers/vhost/vhost.c:790 [inline]
  vhost_setup_vq_uaddr drivers/vhost/vhost.c:801 [inline]
  vhost_vq_map_prefetch drivers/vhost/vhost.c:1783 [inline]
  vq_meta_prefetch+0x2a0/0xcb0 drivers/vhost/vhost.c:1804
  handle_rx+0x145/0x1890 drivers/vhost/net.c:1128
  handle_rx_net+0x19/0x20 drivers/vhost/net.c:1270
  vhost_worker+0x2af/0x4d0 drivers/vhost/vhost.c:473
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
