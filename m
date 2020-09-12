Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDED267716
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 03:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgILBfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 21:35:42 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45051 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgILBfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 21:35:18 -0400
Received: by mail-il1-f199.google.com with SMTP id j11so8441377ilr.11
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 18:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1Au+jF0U9NdQpjmGSupuqP1uY7GjUPeo4ovRK8rNqtg=;
        b=gzquLDwku6rTun0aZPr8wnqkKa0MxEzU9+LWFBavO9QXjIxpCRezmf9SF7/eXG+Xpf
         rzbcaPvWm3F4d6nyTxC7VPjA36X0D32N0m8y2Qp5plvYVx7En6oF9yqco5GcJl/uY0Av
         1X0NbsA6ROd7l3L3XeAJIqcPb7rXtG8T3Un98/N2WGub9fPg6r26RGipq1afEdME0WmD
         jWshS8F3kvLjIJTBwKwyE+cfjcMYpNu0mcHQrjBAGBJqzzqGFh1mwXI7tqlSQXzRHKQ2
         YgeQyS67Qpr26fnf+ne1iDw80p7gQjUsM+cyiok2NF2T+tlPF8ARCqCfDyAeJZ+e8VvI
         A/hQ==
X-Gm-Message-State: AOAM53146QIcOHWrNJUbbT9G1cp8WlpU4qzKzMMNrMDxHcTnTcYJ8WGt
        m//tsuA8llmOOXEfdn891VOIuCAmVXiA0o08/3wQLFu9cf1A
X-Google-Smtp-Source: ABdhPJykGvkkfF0TalkCAFdl6JKCUiPAmVhfOt5G9R1UhpC7B/l/0I/FrHN9AfoIj2ouf2dGbvl10ZQCmRDRvIvA/3F/8kp7mqZ8
MIME-Version: 1.0
X-Received: by 2002:a6b:fb0c:: with SMTP id h12mr3621463iog.98.1599874514946;
 Fri, 11 Sep 2020 18:35:14 -0700 (PDT)
Date:   Fri, 11 Sep 2020 18:35:14 -0700
In-Reply-To: <0000000000004991e705ac9d1a83@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026136505af13d0ab@google.com>
Subject: Re: inconsistent lock state in sco_conn_del
From:   syzbot <syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e8878ab8 Merge tag 'spi-fix-v5.9-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12130759900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
dashboard link: https://syzkaller.appspot.com/bug?extid=65684128cd7c35bc66a1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121ef0fd900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c3a853900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+65684128cd7c35bc66a1@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.9.0-rc4-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz-executor675/31233 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880a75c50a0 (slock-AF_BLUETOOTH-BTPROTO_SCO){+.?.}-{2:2}, at: sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  sco_sock_timeout+0x24/0x140 net/bluetooth/sco.c:83
  call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
  expire_timers kernel/time/timer.c:1458 [inline]
  __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
  __run_timers kernel/time/timer.c:1736 [inline]
  run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
  __do_softirq+0x1f7/0xa91 kernel/softirq.c:298
  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
  do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
  invoke_softirq kernel/softirq.c:393 [inline]
  __irq_exit_rcu kernel/softirq.c:423 [inline]
  irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
  sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
  unwind_next_frame+0x139a/0x1f90 arch/x86/kernel/unwind_orc.c:607
  arch_stack_walk+0x81/0xf0 arch/x86/kernel/stacktrace.c:25
  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_set_track mm/kasan/common.c:56 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
  slab_post_alloc_hook mm/slab.h:518 [inline]
  slab_alloc mm/slab.c:3312 [inline]
  kmem_cache_alloc+0x13a/0x3a0 mm/slab.c:3482
  __d_alloc+0x2a/0x950 fs/dcache.c:1709
  d_alloc+0x4a/0x230 fs/dcache.c:1788
  d_alloc_parallel+0xe9/0x18e0 fs/dcache.c:2540
  lookup_open.isra.0+0x9ac/0x1350 fs/namei.c:3030
  open_last_lookups fs/namei.c:3177 [inline]
  path_openat+0x96d/0x2730 fs/namei.c:3365
  do_filp_open+0x17e/0x3c0 fs/namei.c:3395
  do_sys_openat2+0x16d/0x420 fs/open.c:1168
  do_sys_open fs/open.c:1184 [inline]
  __do_sys_open fs/open.c:1192 [inline]
  __se_sys_open fs/open.c:1188 [inline]
  __x64_sys_open+0x119/0x1c0 fs/open.c:1188
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
irq event stamp: 853
hardirqs last  enabled at (853): [<ffffffff87f733af>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
hardirqs last  enabled at (853): [<ffffffff87f733af>] _raw_spin_unlock_irq+0x1f/0x80 kernel/locking/spinlock.c:199
hardirqs last disabled at (852): [<ffffffff87f73764>] __raw_spin_lock_irq include/linux/spinlock_api_smp.h:126 [inline]
hardirqs last disabled at (852): [<ffffffff87f73764>] _raw_spin_lock_irq+0xa4/0xd0 kernel/locking/spinlock.c:167
softirqs last  enabled at (0): [<ffffffff8144c929>] copy_process+0x1a99/0x6920 kernel/fork.c:2018
softirqs last disabled at (0): [<0000000000000000>] 0x0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

3 locks held by syz-executor675/31233:
 #0: ffff88809f104f40 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0xf5/0x1080 net/bluetooth/hci_core.c:1720
 #1: ffff88809f104078 (&hdev->lock){+.+.}-{3:3}, at: hci_dev_do_close+0x253/0x1080 net/bluetooth/hci_core.c:1757
 #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1435 [inline]
 #2: ffffffff8a9188c8 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0xc7/0x220 net/bluetooth/hci_conn.c:1557

stack backtrace:
CPU: 1 PID: 31233 Comm: syz-executor675 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:4020 [inline]
 valid_state kernel/locking/lockdep.c:3361 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3560 [inline]
 mark_lock.cold+0x7a/0x7f kernel/locking/lockdep.c:4006
 mark_usage kernel/locking/lockdep.c:3923 [inline]
 __lock_acquire+0x876/0x5570 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 sco_conn_del+0x128/0x270 net/bluetooth/sco.c:176
 sco_disconn_cfm net/bluetooth/sco.c:1178 [inline]
 sco_disconn_cfm+0x62/0x80 net/bluetooth/sco.c:1171
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1438 [inline]
 hci_conn_hash_flush+0x114/0x220 net/bluetooth/hci_conn.c:1557
 hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1770
 hci_unregister_dev+0x1bd/0xe30 net/bluetooth/hci_core.c:3790
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:159 [inline]
 exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:190
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:265
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447279
Code: Bad RIP value.
RSP: 002b:00007fd19f624d88 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006dcc28 RCX: 0000000000447279
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dcc28
RBP: 00000000006dcc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc2c
R13: 0000000000000004 R14: 0000000000000003 R15: 00007fd19f6256d0

