Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B1C526F93
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiENHRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 03:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiENHRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 03:17:21 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB54B09
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 00:17:19 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id 204-20020a6b01d5000000b00657bb7a0f33so6262876iob.4
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 00:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XjhKrXFJz6SbbnV2UysgtjDPOtBkUM97A6o+xLew1cE=;
        b=aOBglyjFMmcWXi32c3OoAS1BF0pGo78/aOVUHk1D2kRjaWsoUFKVQ9L//zZna4GPID
         V7hOCIADsZk15+RYwK7JFXNT5FfUU2oQBq1I7b8mx1wy22vIjJzLZqgtoqdr3vizsICC
         emvB9yLIh8r60Y7XGpZ6aQEhfUlME0Ktu69dH9iICyjWyDxZZu0ZsKnHmZkeGbC+L0fb
         z7BLDNe9I+RKhMLwIMp6ZwLWjun/smQikVOKvz/fUdriwtMOYgPDCLxff98Fce3OGC8n
         IpFYdUxc0b4omydp1PG+apljUa5rx8DYCQz4QlMi+QbNfJTIChLm9e2VHn1xDL4A47aM
         +1tg==
X-Gm-Message-State: AOAM532lDQK/deY9k7kSp9NE77MYY7PdkoP5MwCQvfq7473F/Zhmaprx
        +use4uJLkR9Y7mToNjUIE+1JZZv5ypYn0WWgDo42TggLg8l+
X-Google-Smtp-Source: ABdhPJxBLignDtCM2ipXAHk2R8dhNVqmmIh+SmOsZ4b5kyI03x/5+Av073GuOvXT9fspJoCxCl4asFtg4FGGdZpZbxljaSSw8RJz
MIME-Version: 1.0
X-Received: by 2002:a92:ca48:0:b0:2d0:fb23:6c26 with SMTP id
 q8-20020a92ca48000000b002d0fb236c26mr3219490ilo.175.1652512638576; Sat, 14
 May 2022 00:17:18 -0700 (PDT)
Date:   Sat, 14 May 2022 00:17:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf2ece05def394c8@google.com>
Subject: [syzbot] INFO: task hung in hci_dev_do_open (2)
From:   syzbot <syzbot+e68a3899a8927b14f863@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    38a288f5941e Add linux-next specific files for 20220506
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10e9fd3ef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f4fbf50aa82985b
dashboard link: https://syzkaller.appspot.com/bug?extid=e68a3899a8927b14f863
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111555fef00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1629b3eaf00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e68a3899a8927b14f863@syzkaller.appspotmail.com

INFO: task kworker/u5:1:3738 blocked for more than 143 seconds.
      Not tainted 5.18.0-rc5-next-20220506-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:1    state:D stack:27952 pid: 3738 ppid:     2 flags:0x00004000
Workqueue: hci0 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5109 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6424
 schedule+0xd2/0x1f0 kernel/sched/core.c:6496
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6555
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa70/0x1350 kernel/locking/mutex.c:747
 hci_dev_do_open+0x2a/0x70 net/bluetooth/hci_core.c:480
 hci_power_on+0x133/0x630 net/bluetooth/hci_core.c:963
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
INFO: task syz-executor271:4065 blocked for more than 143 seconds.
      Not tainted 5.18.0-rc5-next-20220506-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor271 state:D stack:27952 pid: 4065 ppid:  3735 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5109 [inline]
 __schedule+0xa9a/0x4cc0 kernel/sched/core.c:6424
 schedule+0xd2/0x1f0 kernel/sched/core.c:6496
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1883
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3098
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3185
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4092
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_unregister_dev+0x1c4/0x550 net/bluetooth/hci_core.c:2685
 hci_uart_tty_close+0x241/0x2a0 drivers/bluetooth/hci_ldisc.c:548
 tty_ldisc_close+0x110/0x190 drivers/tty/tty_ldisc.c:456
 tty_ldisc_kill+0x94/0x150 drivers/tty/tty_ldisc.c:608
 tty_ldisc_release+0xe1/0x2a0 drivers/tty/tty_ldisc.c:776
 tty_release_struct+0x20/0xe0 drivers/tty/tty_io.c:1694
 tty_release+0xc70/0x1200 drivers/tty/tty_io.c:1865
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xaff/0x2a00 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd7dadc9c69
RSP: 002b:00007ffe0ae022a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fd7dae363d0 RCX: 00007fd7dadc9c69
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00007ffe0ae02320
R10: 00007ffe0ae02320 R11: 0000000000000246 R12: 00007fd7dae363d0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8bd84f50 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:502
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8bd84bd0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0xc70 kernel/rcu/tasks.h:502
1 lock held by khungtaskd/29:
 #0: ffffffff8bd85aa0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6491
2 locks held by getty/3366:
 #0: ffff888024cd1098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc90002ce62e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xe50/0x13c0 drivers/tty/n_tty.c:2118
3 locks held by kworker/u5:1/3738:
 #0: ffff888019af7138 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888019af7138 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888019af7138 ((wq_completion)hci0){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888019af7138 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888019af7138 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888019af7138 ((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc9000323fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff88807ec49048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_open+0x2a/0x70 net/bluetooth/hci_core.c:480
3 locks held by syz-executor271/4065:
 #0: ffff88801d49b098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff88801d49b098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:336 [inline]
 #0: ffff88801d49b098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff88801d49b098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0x15c/0x2a0 drivers/tty/tty_ldisc.c:775
 #1: ffff88801d49c098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff88801d49c098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:338 [inline]
 #1: ffff88801d49c098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff88801d49c098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0x20f/0x2a0 drivers/tty/tty_ldisc.c:775
 #2: ffff88807ec49048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 29 Comm: khungtaskd Not tainted 5.18.0-rc5-next-20220506-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
 watchdog+0xc22/0xf90 kernel/hung_task.c:378
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 1 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 1 skipped: idling at acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
NMI backtrace for cpu 1 skipped: idling at acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:554


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
