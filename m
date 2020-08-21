Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAB724C8FB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 02:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgHUAIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 20:08:24 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43624 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgHUAIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 20:08:22 -0400
Received: by mail-il1-f197.google.com with SMTP id 2so235283ill.10
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 17:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DKSOpbAg+aP97PkPPdrI+eKL1Fd7x+cP1WN09z9kHHQ=;
        b=fgV/Wg0jAQ3iyTfK87d7PidijHFboF5Uig3fCUy7D5ZeEHOvHuO298MwCqSHVJplyF
         IaZbEiqrBnTC2Wzzk2TVjsscM6ijtnpecsIIJ0AKe1PjWteb1oSDNg6Y32VX18w71+7A
         IOrrUSS09ejnUo6vNPtLFlq2Uf5e8EOHEfSoUrzFgIOLEMNnWKm1Ht+6cBGEec4kXOBA
         76RmtI6mf/fi2Nk7j2sAPpN925EYlARic98G2h+0e6PYV+uIblTCzIW9S19FYdwa9fHL
         lLFCICVybTBL9o3FNrROkiZ5Q1NbJyMWD7LGbzLySyVhDp7FyWyxBs8zx0EfMjwsYSgn
         c2vQ==
X-Gm-Message-State: AOAM530tosp8my/LFgL8ZcfeRiQlp32FI+DuSv93YUqcxvDm8gmTKt+Y
        3ixw0owQXK5wEGhw8ytcgKU7bI0NO32iNlJJJGmYps7JM0Zz
X-Google-Smtp-Source: ABdhPJz9JqOei9Yz3vbqJm1VZu7mSikC+3kDAWHXmpazimDOpd5HyIYkMTom5l5J7IvYguV+3c4iC9aro6u2etbbyqk9Bdf3CDL7
MIME-Version: 1.0
X-Received: by 2002:a05:6638:594:: with SMTP id a20mr230916jar.127.1597968500980;
 Thu, 20 Aug 2020 17:08:20 -0700 (PDT)
Date:   Thu, 20 Aug 2020 17:08:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd00d705ad5808a3@google.com>
Subject: INFO: task hung in process_one_work (4)
From:   syzbot <syzbot+1edb0b6642837b20addf@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9123e3a7 Linux 5.9-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=144c0c89900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
dashboard link: https://syzkaller.appspot.com/bug?extid=1edb0b6642837b20addf
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123eb289900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1edb0b6642837b20addf@syzkaller.appspotmail.com

INFO: task kworker/0:5:8255 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:5     state:D stack:28744 pid: 8255 ppid:     2 flags:0x00004000
Workqueue: events nsim_dev_trap_report_work
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4661
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 nsim_dev_trap_report_work+0x5d/0xbe0 drivers/net/netdevsim/dev.c:594
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
7 locks held by kworker/u4:2/29:
 #0: ffff8880a97b5138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a97b5138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a97b5138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a97b5138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a97b5138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a97b5138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000e57da8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7d8bf0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xa00 net/core/net_namespace.c:565
 #3: ffffffff8a809688 (devlink_mutex){+.+.}-{3:3}, at: devlink_pernet_pre_exit+0x1c/0x190 net/core/devlink.c:9613
 #4: ffff888093479370 (&nsim_dev->port_list_lock){+.+.}-{3:3}, at: nsim_dev_port_del_all drivers/net/netdevsim/dev.c:956 [inline]
 #4: ffff888093479370 (&nsim_dev->port_list_lock){+.+.}-{3:3}, at: nsim_dev_reload_destroy+0x9e/0x1e0 drivers/net/netdevsim/dev.c:1135
 #5: ffffffff8a7e5c48 (rtnl_mutex){+.+.}-{3:3}, at: nsim_destroy+0x2b/0x70 drivers/net/netdevsim/netdev.c:338
 #6: ffffffff89b91010 (cpu_hotplug_lock){++++}-{0:0}, at: get_online_cpus include/linux/cpu.h:144 [inline]
 #6: ffffffff89b91010 (cpu_hotplug_lock){++++}-{0:0}, at: flush_all_backlogs net/core/dev.c:5628 [inline]
 #6: ffffffff89b91010 (cpu_hotplug_lock){++++}-{0:0}, at: rollback_registered_many+0x45b/0x1210 net/core/dev.c:9266
1 lock held by khungtaskd/1168:
 #0: ffffffff89bd6340 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5825
6 locks held by kworker/0:1H/3871:
1 lock held by in:imklog/6531:
 #0: ffff888093b0fe30 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
3 locks held by kworker/0:5/8255:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc9000a727da8 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffff888093479370 (&nsim_dev->port_list_lock){+.+.}-{3:3}, at: nsim_dev_trap_report_work+0x5d/0xbe0 drivers/net/netdevsim/dev.c:594
2 locks held by syz-executor.2/8302:
 #0: ffffffff8a7d8bf0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2ac/0x5e0 net/core/net_namespace.c:478
 #1: ffffffff8a7e5c48 (rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x31c/0x980 net/ipv4/ip_tunnel.c:1071
2 locks held by syz-executor.5/8306:
 #0: ffffffff8a7d8bf0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2ac/0x5e0 net/core/net_namespace.c:478
 #1: ffffffff8a809688 (devlink_mutex){+.+.}-{3:3}, at: devlink_pernet_pre_exit+0x1c/0x190 net/core/devlink.c:9613

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1168 Comm: khungtaskd Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3871 Comm: kworker/0:1H Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_highpri snd_vmidi_output_work
RIP: 0010:check_memory_region+0x17/0x180 mm/kasan/generic.c:191
Code: 0f 1f 00 48 89 f2 be f8 00 00 00 e9 b3 2f 02 02 0f 1f 00 48 85 f6 0f 84 70 01 00 00 49 89 f9 41 54 44 0f b6 c2 49 01 f1 55 53 <0f> 82 18 01 00 00 48 b8 ff ff ff ff ff 7f ff ff 48 39 c7 0f 86 05
RSP: 0018:ffffc90007557840 EFLAGS: 00000096
RAX: 000000000000001b RBX: 0000000000000004 RCX: ffffffff815a0536
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8c5f0ab8
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8c5f0ac0
R10: fffffbfff18be157 R11: 0000000000000001 R12: 00000000000006e3
R13: dffffc0000000000 R14: ffff888098b5c200 R15: ffff888098b5cae8
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005611713ce160 CR3: 00000000a2f29000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 instrument_atomic_read include/linux/instrumented.h:56 [inline]
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 hlock_class kernel/locking/lockdep.c:179 [inline]
 check_wait_context kernel/locking/lockdep.c:4125 [inline]
 __lock_acquire+0x706/0x5640 kernel/locking/lockdep.c:4376
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:5005
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xc0 kernel/locking/spinlock.c:159
 snd_seq_timer_get_cur_tick+0x1f/0x70 sound/core/seq/seq_timer.c:459
 update_timestamp_of_queue.isra.0+0xcf/0x210 sound/core/seq/seq_clientmgr.c:586
 deliver_to_subscribers sound/core/seq/seq_clientmgr.c:691 [inline]
 snd_seq_deliver_event+0x4ca/0x850 sound/core/seq/seq_clientmgr.c:828
 snd_seq_kernel_client_dispatch+0x145/0x180 sound/core/seq/seq_clientmgr.c:2323
 snd_vmidi_output_work+0x1c8/0x380 sound/core/seq/seq_virmidi.c:150
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
