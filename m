Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77498B9EDA
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 18:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407722AbfIUQTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 12:19:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54960 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407653AbfIUQTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 12:19:08 -0400
Received: by mail-io1-f72.google.com with SMTP id w8so15871208iod.21
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 09:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=qtqv80KNXvHS2YSXIlXC/jI9QvFdNus+iDGH+Cwnqnc=;
        b=j/ePVUXPUF5JMb3xXQJaJGtm1mSHcChzq5S9PgHcx5cbOoJ0VZHoY/ayLxgfma9/xk
         H2ALTvy4qe+I+p34nvqI50HJAuMix3hjFLTjqv3epBSCYGF5jrn4ZTuoQdDu05cTiMbg
         JyAyw6xwPHuF/JCPebGM0R7ywO9NQzmSgKDZZifXFsq/J5y7vuQx6YNnULv9H/CZ301a
         EnnY6fTt4i9+DHKpka5mDgfmLGShjE6L++nebERHysuTbP+QX9xogT800oZzPTWiJt0r
         nm+LnDxwmH5CZoXjCBpUTD/lDUIjWbX8nCrFD7+jIEAzs7Dfeg5SI/BF9wKlsGYo4pXn
         OB4Q==
X-Gm-Message-State: APjAAAWhQsLYqnJL6Nh5HdKKCUyp+KiIYwiiJ/jw/+jJ9ZFnBX0aW7R8
        yrTULExLqss46XMXVcoSetV+38+eVN7EDRLgy9ebyk9MqnEh
X-Google-Smtp-Source: APXvYqy4x1CTaUiyxPxpo6DHv0wyz1k0Mh7JH6ciUb9MYf0uQ9UZd28KyWKxJIR9LFOD3WVfa5iLGl2XyCOSSn5hHg4OSDBYethi
MIME-Version: 1.0
X-Received: by 2002:a6b:7b01:: with SMTP id l1mr5052870iop.292.1569082746980;
 Sat, 21 Sep 2019 09:19:06 -0700 (PDT)
Date:   Sat, 21 Sep 2019 09:19:06 -0700
In-Reply-To: <00000000000039af4d05915a9f56@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1d3ca0593128b24@google.com>
Subject: Re: INFO: task hung in p9_fd_close
From:   syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    f97c81dc Merge tag 'armsoc-late' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171a1555600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61f948934213449f
dashboard link: https://syzkaller.appspot.com/bug?extid=8b41a1365f1106fd0f33
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1641d429600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11eff9ad600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com

INFO: task syz-executor635:8085 blocked for more than 143 seconds.
       Not tainted 5.3.0+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor635 D27848  8085   8070 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3384 [inline]
  __schedule+0x82e/0xc50 kernel/sched/core.c:4056
  schedule+0x131/0x1e0 kernel/sched/core.c:4123
  schedule_timeout+0x46/0x240 kernel/time/timer.c:1869
  do_wait_for_common+0x2e7/0x4d0 kernel/sched/completion.c:83
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x47/0x60 kernel/sched/completion.c:136
  __flush_work+0xd4/0x150 kernel/workqueue.c:3040
  __cancel_work_timer+0x420/0x570 kernel/workqueue.c:3127
  cancel_work_sync+0x17/0x20 kernel/workqueue.c:3163
  p9_conn_destroy net/9p/trans_fd.c:868 [inline]
  p9_fd_close+0x297/0x3c0 net/9p/trans_fd.c:898
  p9_client_create+0x974/0xee0 net/9p/client.c:1068
  v9fs_session_init+0x192/0x18e0 fs/9p/v9fs.c:406
  v9fs_mount+0x82/0x860 fs/9p/vfs_super.c:124
  legacy_get_tree+0xf9/0x1a0 fs/fs_context.c:659
  vfs_get_tree+0x8f/0x380 fs/super.c:1542
  do_new_mount fs/namespace.c:2825 [inline]
  do_mount+0x16c7/0x2510 fs/namespace.c:3145
  ksys_mount+0xcc/0x100 fs/namespace.c:3354
  __do_sys_mount fs/namespace.c:3368 [inline]
  __se_sys_mount fs/namespace.c:3365 [inline]
  __x64_sys_mount+0xbf/0xd0 fs/namespace.c:3365
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447909
Code: e8 5c 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 9b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007eff1aea0db8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00000000006ddc78 RCX: 0000000000447909
RDX: 00000000200005c0 RSI: 0000000020000540 RDI: 0000000000000000
RBP: 00000000006ddc70 R08: 0000000020000680 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006ddc7c
R13: 00007ffc4e6377ef R14: 00007eff1aea19c0 R15: 000000000000002d

Showing all locks held in the system:
2 locks held by kworker/1:1/22:
  #0: ffff8880aa4278e8 ((wq_completion)events){+.+.}, at: spin_unlock_irq  
include/linux/spinlock.h:388 [inline]
  #0: ffff8880aa4278e8 ((wq_completion)events){+.+.}, at:  
process_one_work+0x75d/0x10e0 kernel/workqueue.c:2242
  #1: ffff8880a9a3fd78 ((work_completion)(&m->wq)){+.+.}, at:  
process_one_work+0x79f/0x10e0 kernel/workqueue.c:2244
1 lock held by khungtaskd/1053:
  #0: ffffffff888d3900 (rcu_read_lock){....}, at: rcu_lock_acquire+0x4/0x30  
include/linux/rcupdate.h:207
1 lock held by rsyslogd/7959:
  #0: ffff8880a99f1e20 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0x243/0x2e0  
fs/file.c:801
2 locks held by getty/8049:
  #0: ffff8880a602d450 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: ffffc90005f212e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x221/0x1b00 drivers/tty/n_tty.c:2156
2 locks held by getty/8050:
  #0: ffff8880a902ac50 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: ffffc90005f092e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x221/0x1b00 drivers/tty/n_tty.c:2156
2 locks held by getty/8051:
  #0: ffff88809c0f1750 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: ffffc90005f312e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x221/0x1b00 drivers/tty/n_tty.c:2156
2 locks held by getty/8052:
  #0: ffff88809e344b90 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: ffffc90005f152e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x221/0x1b00 drivers/tty/n_tty.c:2156
2 locks held by getty/8053:
  #0: ffff88809e344310 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: ffffc90005f1d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x221/0x1b00 drivers/tty/n_tty.c:2156
2 locks held by getty/8054:
  #0: ffff88809c8aa410 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: ffffc90005f2d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x221/0x1b00 drivers/tty/n_tty.c:2156
2 locks held by getty/8055:
  #0: ffff8880a0267310 (&tty->ldisc_sem){++++}, at:  
tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:272
  #1: ffffc90005f012e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x221/0x1b00 drivers/tty/n_tty.c:2156

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1053 Comm: khungtaskd Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  nmi_cpu_backtrace+0xaf/0x1a0 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x174/0x290 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x10/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace+0x17/0x20 include/linux/nmi.h:146
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0xbb9/0xbd0 kernel/hung_task.c:289
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:check_preemption_disabled+0x6/0x2a0 lib/smp_processor_id.c:13
Code: 90 90 90 90 55 48 89 e5 e8 a7 b2 2e fe 48 c7 c7 79 91 38 88 48 c7 c6  
10 72 4e 88 e8 04 00 00 00 5d c3 66 90 55 48 89 e5 41 57 <41> 56 41 55 41  
54 53 48 83 ec 10 49 89 f6 49 89 ff e8 74 b2 2e fe
RSP: 0018:ffff8880aeb09ee0 EFLAGS: 00000093
RAX: ffffffff83448fc9 RBX: 0000000000000004 RCX: ffff8880a98c2340
RDX: 0000000000000000 RSI: ffffffff884e7210 RDI: ffffffff88389179
RBP: ffff8880aeb09ee8 R08: ffffffff816701e0 R09: fffffbfff117c3cd
R10: fffffbfff117c3cd R11: 0000000000000000 R12: 1ffff11015d64eaf
R13: ffff8880aeb00000 R14: dffffc0000000000 R15: ffff8880aeb2757c
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000000a3d38000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  debug_smp_processor_id+0x1c/0x20 lib/smp_processor_id.c:57
  tick_nohz_stop_idle kernel/time/tick-sched.c:535 [inline]
  tick_nohz_irq_enter kernel/time/tick-sched.c:1255 [inline]
  tick_irq_enter+0xbd/0x3e0 kernel/time/tick-sched.c:1274
  irq_enter+0x52/0xc0 kernel/softirq.c:354
  scheduler_ipi+0xb3/0x4a0 kernel/sched/core.c:2337
  smp_reschedule_interrupt+0x7a/0xa0 arch/x86/kernel/smp.c:244
  reschedule_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:854
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 3c fa eb ae 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 94 ab 3c  
fa eb b0 90 90 e9 07 00 00 00 0f 00 2d b6 99 52 00 fb f4 <c3> 90 e9 07 00  
00 00 0f 00 2d a6 99 52 00 f4 c3 90 90 55 48 89 e5
RSP: 0018:ffff8880a98cfe10 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff02
RAX: 1ffffffff1115179 RBX: ffff8880a98c2340 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffffffff812ba81a RDI: ffff8880a98c2b80
RBP: ffff8880a98cfe18 R08: ffff8880a98c2b98 R09: ffffed1015318469
R10: ffffed1015318469 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff11015318468 R14: dffffc0000000000 R15: 1ffffffff1115177
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:571
  default_idle_call+0x59/0xa0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x140/0x670 kernel/sched/idle.c:264
  cpu_startup_entry+0x25/0x30 kernel/sched/idle.c:356
  start_secondary+0x384/0x410 arch/x86/kernel/smpboot.c:264
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

