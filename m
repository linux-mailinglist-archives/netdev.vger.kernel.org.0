Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1E8252B7E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 12:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgHZKid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 06:38:33 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:39065 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgHZKiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 06:38:17 -0400
Received: by mail-il1-f200.google.com with SMTP id o1so1212045ilk.6
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 03:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zygVL94X6Q9/gOxylja2ASyPRPX3GqyZ0wHqqF523eI=;
        b=eNH4JHnsu/nqgtqviT5mPkoaX7VwJsM6N6yQfRoEEwe218w2NjGSJ532nqik8ZUaX6
         sT38SfE8wpjusWN7Qa+6uKao1hA9hsiZsMXQQFa4Q4v+oMKOKq6wtAcAFSnSI6Zt9O1f
         6mSEna70rDbN+jJF2h4rBiEVlwzoV/gmjrALZIgw3QhIXAnGPEoraK11lXg2dGqpHmnG
         xTlnWVl++OWoSwX9QQ2DDsvNTgpHLqP3BYmDeZJdhcFzHHkMU2G95hnx36gRKJe8/h8I
         J2B3Ke8p/gyQfaMkEwRe4DeB+2gWVSBGnve4oRtYW50KTpPFwiB+KRYAVQjGLJjSd92x
         vHrA==
X-Gm-Message-State: AOAM533mE44MABwFuVOQSFLTnUiP2esDK2+Q2N4crAdPMv9LjAYL/o0p
        causYXUhHaLrWkmwLroAlNdSFc8fGZopoEDKKPblQwb0Qzfe
X-Google-Smtp-Source: ABdhPJw08lyBJzdODV2Nkxfhuk4RHh+Cw2MEsa6J9AamNBzV1YHNImbwq9QQ84qsc0HcufY/KZOLJ+Gx1fTymR3g1Kve5aQLypQ6
MIME-Version: 1.0
X-Received: by 2002:a02:6d0e:: with SMTP id m14mr14520416jac.23.1598438295340;
 Wed, 26 Aug 2020 03:38:15 -0700 (PDT)
Date:   Wed, 26 Aug 2020 03:38:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca0c6805adc56a38@google.com>
Subject: INFO: task can't die in p9_fd_close
From:   syzbot <syzbot+fbe34b643e462f65e542@syzkaller.appspotmail.com>
To:     alsa-devel@alsa-project.org, asmadeus@codewreck.org,
        broonie@kernel.org, daniel.baluta@nxp.com, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, perex@perex.cz, rminnich@sandia.gov,
        syzkaller-bugs@googlegroups.com, tiwai@suse.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    494d311a Add linux-next specific files for 20200821
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10615b36900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a61d44f28687f508
dashboard link: https://syzkaller.appspot.com/bug?extid=fbe34b643e462f65e542
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15920a05900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a78539900000

The issue was bisected to:

commit af3acca3e35c01920fe476f730dca7345d0a48df
Author: Daniel Baluta <daniel.baluta@nxp.com>
Date:   Tue Feb 20 12:53:10 2018 +0000

    ASoC: ak5558: Fix style for SPDX identifier

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ea5d39900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11ea5d39900000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ea5d39900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fbe34b643e462f65e542@syzkaller.appspotmail.com
Fixes: af3acca3e35c ("ASoC: ak5558: Fix style for SPDX identifier")

INFO: task syz-executor475:7005 can't die for more than 143 seconds.
task:syz-executor475 state:D stack:27208 pid: 7005 ppid:  6875 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 __flush_work+0x51f/0xab0 kernel/workqueue.c:3046
 __cancel_work_timer+0x5de/0x700 kernel/workqueue.c:3133
 p9_conn_destroy net/9p/trans_fd.c:889 [inline]
 p9_fd_close+0x305/0x520 net/9p/trans_fd.c:919
 p9_client_destroy+0xbe/0x360 net/9p/client.c:1086
 v9fs_session_close+0x45/0x2c0 fs/9p/v9fs.c:498
 v9fs_kill_super+0x49/0x90 fs/9p/vfs_super.c:222
 deactivate_locked_super+0x94/0x160 fs/super.c:335
 v9fs_mount+0x77c/0x970 fs/9p/vfs_super.c:203
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x1287/0x1e20 fs/namespace.c:3214
 do_mount fs/namespace.c:3227 [inline]
 __do_sys_mount fs/namespace.c:3435 [inline]
 __se_sys_mount fs/namespace.c:3412 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3412
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446eb9
Code: Bad RIP value.
RSP: 002b:00007f6a133add98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00000000006dcc48 RCX: 0000000000446eb9
RDX: 0000000020000200 RSI: 0000000020000000 RDI: 0000000000000000
RBP: 00000000006dcc40 R08: 00000000200028c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc4c
R13: 00000000200003c0 R14: 00000000004af538 R15: 0000000000000000
INFO: task syz-executor475:7005 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc1-next-20200821-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor475 state:D stack:27208 pid: 7005 ppid:  6875 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 __flush_work+0x51f/0xab0 kernel/workqueue.c:3046
 __cancel_work_timer+0x5de/0x700 kernel/workqueue.c:3133
 p9_conn_destroy net/9p/trans_fd.c:889 [inline]
 p9_fd_close+0x305/0x520 net/9p/trans_fd.c:919
 p9_client_destroy+0xbe/0x360 net/9p/client.c:1086
 v9fs_session_close+0x45/0x2c0 fs/9p/v9fs.c:498
 v9fs_kill_super+0x49/0x90 fs/9p/vfs_super.c:222
 deactivate_locked_super+0x94/0x160 fs/super.c:335
 v9fs_mount+0x77c/0x970 fs/9p/vfs_super.c:203
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x1287/0x1e20 fs/namespace.c:3214
 do_mount fs/namespace.c:3227 [inline]
 __do_sys_mount fs/namespace.c:3435 [inline]
 __se_sys_mount fs/namespace.c:3412 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3412
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446eb9
Code: Bad RIP value.
RSP: 002b:00007f6a133add98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00000000006dcc48 RCX: 0000000000446eb9
RDX: 0000000020000200 RSI: 0000000020000000 RDI: 0000000000000000
RBP: 00000000006dcc40 R08: 00000000200028c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc4c
R13: 00000000200003c0 R14: 00000000004af538 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1173:
 #0: ffffffff89c675c0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5825
1 lock held by in:imklog/6540:
2 locks held by kworker/0:1/6858:
 #0: ffff8880ae635dd8 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1292 [inline]
 #0: ffff8880ae635dd8 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x232/0x21e0 kernel/sched/core.c:4445
 #1: ffff8880ae620ec8 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x2fb/0x400 kernel/sched/psi.c:833
2 locks held by kworker/0:2/6898:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90005577da8 ((work_completion)(&m->wq)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
1 lock held by syz-executor475/6960:
 #0: ffff8880a7c7a0e0 (&type->s_umount_key#45/1){+.+.}-{3:3}, at: alloc_super+0x201/0xa90 fs/super.c:229
1 lock held by syz-executor475/7064:
 #0: ffff8880a6c9c0e0 (&type->s_umount_key#45/1){+.+.}-{3:3}, at: alloc_super+0x201/0xa90 fs/super.c:229
2 locks held by kworker/0:3/7070:
 #0: ffff8880aa073538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa073538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa073538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa073538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa073538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa073538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90006157da8 ((work_completion)(&rew.rew_work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
1 lock held by syz-executor475/7279:
 #0: ffff88809476e0e0 (&type->s_umount_key#45/1){+.+.}-{3:3}, at: alloc_super+0x201/0xa90 fs/super.c:229
1 lock held by syz-executor475/32328:
 #0: ffffffff89c6bc28 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:322 [inline]
 #0: ffffffff89c6bc28 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x274/0x5f0 kernel/rcu/tree_exp.h:836
1 lock held by syz-executor475/32335:
 #0: ffffffff89c6bc28 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:322 [inline]
 #0: ffffffff89c6bc28 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x274/0x5f0 kernel/rcu/tree_exp.h:836

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1173 Comm: khungtaskd Not tainted 5.9.0-rc1-next-20200821-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:339
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 32335 Comm: syz-executor475 Not tainted 5.9.0-rc1-next-20200821-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:write_comp_data+0x0/0x80 kernel/kcov.c:212
Code: e8 ff ff cc cc cc cc cc cc cc 65 48 8b 04 25 c0 fe 01 00 48 8b 80 20 14 00 00 c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <49> 89 f2 65 8b 05 76 90 8d 7e 65 48 8b 34 25 c0 fe 01 00 a9 00 01
RSP: 0018:ffffc90009c47ab8 EFLAGS: 00000086
RAX: 0000000000000000 RBX: ffff888096e0e000 RCX: ffffffff8134b5d6
RDX: ffff888116e0e000 RSI: ffff888096e0e000 RDI: 0000000000000006
RBP: ffff888116e0e000 R08: 0000000000000001 R09: ffff8880ae736dc7
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff888096e0e000 R14: ffff8880ae632c80 R15: ffff8880a43f9f00
FS:  00007f6a133ae700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f19a2450710 CR3: 0000000097214000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __phys_addr+0x26/0x110 arch/x86/mm/physaddr.c:20
 virt_to_head_page include/linux/mm.h:846 [inline]
 qlink_to_cache mm/kasan/quarantine.c:128 [inline]
 qlist_move_cache+0x72/0xd0 mm/kasan/quarantine.c:278
 per_cpu_remove_cache+0x47/0x60 mm/kasan/quarantine.c:296
 on_each_cpu+0xf0/0x240 kernel/smp.c:834
 quarantine_remove_cache+0x40/0xd0 mm/kasan/quarantine.c:313
 shutdown_cache mm/slab_common.c:449 [inline]
 kmem_cache_destroy+0x50/0x120 mm/slab_common.c:497
 p9_client_destroy+0x24b/0x360 net/9p/client.c:1097
 v9fs_session_close+0x45/0x2c0 fs/9p/v9fs.c:498
 v9fs_kill_super+0x49/0x90 fs/9p/vfs_super.c:222
 deactivate_locked_super+0x94/0x160 fs/super.c:335
 v9fs_mount+0x77c/0x970 fs/9p/vfs_super.c:203
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1547
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x1287/0x1e20 fs/namespace.c:3214
 do_mount fs/namespace.c:3227 [inline]
 __do_sys_mount fs/namespace.c:3435 [inline]
 __se_sys_mount fs/namespace.c:3412 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3412
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446eb9
Code: e8 dc e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6a133add98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00000000006dcc48 RCX: 0000000000446eb9
RDX: 0000000020000200 RSI: 0000000020000000 RDI: 0000000000000000
RBP: 00000000006dcc40 R08: 00000000200028c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc4c
R13: 00000000200003c0 R14: 00000000004af538 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
