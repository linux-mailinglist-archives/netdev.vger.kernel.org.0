Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F48E31CE89
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBPQ6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 11:58:10 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:41026 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhBPQ6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 11:58:05 -0500
Received: by mail-il1-f197.google.com with SMTP id d11so8297466ilu.8
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 08:57:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lgTVbAHqWVNEB/dshAUiMoUnmbR5GQ/5LSK0lrISuIM=;
        b=VtArfs2ljqIoNLd6dL7OYOEFA5QeIFcSegWPzMkepA2uhCD7uIbP3sGnBKXff6w29v
         4c22ukhyZzhk8uh3hixmxsTf6D7bJq/KEf93GyOjT5ALk0/qe1yqrMByl7rprfTOe4nQ
         GCufShLqtbz0D8s1vj3NH6pOH6Kgv0W72P9bOmUS+esKYAifzZPtSv+a/BTQkD98QqVT
         CnkajdNY7XrxWrO0lcGHqys4QrvdaT8FR6Diq+E1UMgCrwdm5WvQsIVO/X+YBc8jln29
         5bwFxe3Ql3UQ335j+dgraOJgyhE6PrPUcRJtY/b8DjjDjkwvDkRN8uoEyGyBSOeGOc00
         ypGQ==
X-Gm-Message-State: AOAM5328iTkJzumZUKAyiiahVY4V0CA268b5plf9f7/2SbfMzvegtbcE
        XmtuSi5Rduu+sBm3ug7yGDDWghhva74HhC3hCC6SdXhkhSrV
X-Google-Smtp-Source: ABdhPJwo/7qGQ7C1owxurAC5XBtTKsCLArLJ1ypFWQwx6rdUiPG3vkJYTvqDu31ul6s1qwiYVyEOHhAU+ASwa6HDnoOfAtT7JR8o
MIME-Version: 1.0
X-Received: by 2002:a02:1ac5:: with SMTP id 188mr11444013jai.71.1613494642945;
 Tue, 16 Feb 2021 08:57:22 -0800 (PST)
Date:   Tue, 16 Feb 2021 08:57:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a337b05bb76ff8b@google.com>
Subject: INFO: task hung in disconnect_work
From:   syzbot <syzbot+060f9ce2b428f88a288f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f40ddce8 Linux 5.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1644919cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51ab7ccaffffc30c
dashboard link: https://syzkaller.appspot.com/bug?extid=060f9ce2b428f88a288f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1217953cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13baa822d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+060f9ce2b428f88a288f@syzkaller.appspotmail.com

INFO: task kworker/1:0:19 blocked for more than 143 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0     state:D stack:26712 pid:   19 ppid:     2 flags:0x00004000
Workqueue: events disconnect_work
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5216
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 disconnect_work+0x18/0x200 net/wireless/sme.c:664
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
INFO: task kworker/0:2:2992 blocked for more than 143 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:2     state:D stack:26200 pid: 2992 ppid:     2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5216
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 addrconf_dad_work+0xa3/0x1280 net/ipv6/addrconf.c:4029
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
INFO: task kworker/0:3:3896 blocked for more than 143 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:3     state:D stack:27192 pid: 3896 ppid:     2 flags:0x00004000
Workqueue: events linkwatch_event
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5216
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 linkwatch_event+0xb/0x60 net/core/link_watch.c:250
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
INFO: task kworker/1:1:8463 blocked for more than 143 seconds.
      Not tainted 5.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1     state:D stack:28672 pid: 8463 ppid:     2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5216
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 addrconf_dad_work+0xa3/0x1280 net/ipv6/addrconf.c:4029
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
3 locks held by kworker/1:0/19:
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc90000dafda8 (cfg80211_disconnect_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffffffff8d45bce8 (rtnl_mutex){+.+.}-{3:3}, at: disconnect_work+0x18/0x200 net/wireless/sme.c:664
1 lock held by khungtaskd/1649:
 #0: ffffffff8bd73da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6259
3 locks held by kworker/0:2/2992:
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc90001887da8 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffffffff8d45bce8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x1280 net/ipv6/addrconf.c:4029
3 locks held by kworker/0:3/3896:
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010c63d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc90002dffda8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffffffff8d45bce8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
1 lock held by in:imklog/8133:
 #0: ffff88802319a8b0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:947
3 locks held by kworker/1:1/8463:
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888147ba1938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc9000170fda8 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffffffff8d45bce8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x1280 net/ipv6/addrconf.c:4029
3 locks held by syz-executor177/8483:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1649 Comm: khungtaskd Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd43/0xfa0 kernel/hung_task.c:294
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 4863 Comm: systemd-journal Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_lockdep_rcu_enabled+0x23/0x30 kernel/rcu/update.c:278
Code: cc cc cc cc cc cc cc 8b 05 de 1e a8 04 85 c0 74 21 8b 05 ac 4f a8 04 85 c0 74 17 65 48 8b 04 25 00 f0 01 00 8b 80 84 09 00 00 <85> c0 0f 94 c0 0f b6 c0 c3 cc cc cc cc 55 53 48 c7 c3 40 5b 03 00
RSP: 0018:ffffc900013a7940 EFLAGS: 00000202
RAX: 0000000000000000 RBX: 1ffff92000274f2b RCX: ffffffff8158d5c8
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff8da3b448
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8da3b44f
R10: fffffbfff1b47689 R11: 0000000000000001 R12: 0000000000000002
R13: ffffffff8bd73da0 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fd32adca8c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3281b7000 CR3: 0000000014e8a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 trace_lock_acquire include/trace/events/lock.h:13 [inline]
 lock_acquire+0x57d/0x720 kernel/locking/lockdep.c:5413
 rcu_lock_acquire include/linux/rcupdate.h:259 [inline]
 rcu_read_lock include/linux/rcupdate.h:648 [inline]
 is_bpf_text_address+0x36/0x160 kernel/bpf/core.c:700
 kernel_text_address kernel/extable.c:151 [inline]
 kernel_text_address+0xbd/0xf0 kernel/extable.c:120
 __kernel_text_address+0x9/0x30 kernel/extable.c:105
 unwind_get_return_address arch/x86/kernel/unwind_orc.c:318 [inline]
 unwind_get_return_address+0x51/0x90 arch/x86/kernel/unwind_orc.c:313
 arch_stack_walk+0x93/0xe0 arch/x86/kernel/stacktrace.c:26
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x7f/0xa0 mm/kasan/common.c:429
 kasan_slab_alloc include/linux/kasan.h:209 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc mm/slab.c:3315 [inline]
 kmem_cache_alloc+0x1ab/0x4c0 mm/slab.c:3486
 prepare_creds+0x3b/0x730 kernel/cred.c:258
 access_override_creds fs/open.c:353 [inline]
 do_faccessat+0x3d7/0x820 fs/open.c:417
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fd32a0859c7
Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffdcc94f6e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007ffdcc952600 RCX: 00007fd32a0859c7
RDX: 00007fd32aaf6a00 RSI: 0000000000000000 RDI: 000055b9fd33e9a3
RBP: 00007ffdcc94f720 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ffdcc952600 R15: 00007ffdcc94fc10


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
