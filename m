Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2541E53B2FE
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 07:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiFBF2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 01:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiFBF2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 01:28:25 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70352A3B9F
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 22:28:20 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id c1-20020a928e01000000b002d1b20aa761so2671269ild.6
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 22:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oBwwLmIWelfGfUj4Er9QHKF4pnoyhNYH+2/2k171TC4=;
        b=ZLX+ci86+YmfgpJTowACaIE+Rd5LTPtFFqetVzLxmgxiv4s69fW3GYTyBH/ow9R/v2
         3iC3e9B5OR2jAVxztHgWZwblVah7roLQ16eXLHACql0za7SnJk9GiQ76ft6i2a4gUmyq
         hqEeOdKFW5l/g9hf1Ys9So7pxBY+LGT//dl6aF461UgEGnnYiIDGJkK5aGnljCLNvb4E
         +zGUDMWedlgMO10qZWJMQfY9LfvL+vWddHnm/ByCajUY2nPtq3X/yso0isMMPAWbnUpH
         Qo2GYO3+SlG93yZF0LYohbs0LzrPfMiiaOAeNRZplWAEcruSYl4P1fLhGrf1x8PlWP4W
         QYow==
X-Gm-Message-State: AOAM533w/kMJjqLbohIBtEsf0h85d912Twdf8Gdz2hzQ4641f+xMCGFu
        ofwR2T2XzUfTMN/aymMEPSAlVx5M9+Ah/lK3bK5gwW/lQvj2
X-Google-Smtp-Source: ABdhPJwbRf67+UyF9LzJGuP7RSzqkxCIsEFEV0tgbx5hKvN5+0eue/juVqy3l6Nnvgt+TVX16Pu/XRekpndUbnFGmOtTkyX0/9jN
MIME-Version: 1.0
X-Received: by 2002:a92:de4b:0:b0:2d2:18f1:be45 with SMTP id
 e11-20020a92de4b000000b002d218f1be45mr2166512ilr.308.1654147700044; Wed, 01
 Jun 2022 22:28:20 -0700 (PDT)
Date:   Wed, 01 Jun 2022 22:28:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000113adf05e0704621@google.com>
Subject: [syzbot] INFO: task hung in hci_power_on
From:   syzbot <syzbot+8d7b9ced2a99394b0a50@syzkaller.appspotmail.com>
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

HEAD commit:    9d004b2f4fea Merge tag 'cxl-for-5.19' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1644de7bf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c367f7c347f1679
dashboard link: https://syzkaller.appspot.com/bug?extid=8d7b9ced2a99394b0a50
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103f3755f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f4cf3df00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d7b9ced2a99394b0a50@syzkaller.appspotmail.com

INFO: task kworker/u5:0:47 blocked for more than 143 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:0    state:D stack:26752 pid:   47 ppid:     2 flags:0x00004000
Workqueue: hci2 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0x957/0xec0 kernel/sched/core.c:6431
 schedule+0xeb/0x1b0 kernel/sched/core.c:6503
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6562
 __mutex_lock_common+0xecf/0x26c0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 hci_dev_do_open net/bluetooth/hci_core.c:480 [inline]
 hci_power_on+0x178/0x650 net/bluetooth/hci_core.c:963
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
INFO: task kworker/u5:8:3667 blocked for more than 143 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:8    state:D stack:26752 pid: 3667 ppid:     2 flags:0x00004000
Workqueue: hci3 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0x957/0xec0 kernel/sched/core.c:6431
 schedule+0xeb/0x1b0 kernel/sched/core.c:6503
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6562
 __mutex_lock_common+0xecf/0x26c0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 hci_dev_do_open net/bluetooth/hci_core.c:480 [inline]
 hci_power_on+0x178/0x650 net/bluetooth/hci_core.c:963
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
INFO: task syz-executor174:3932 blocked for more than 143 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor174 state:D stack:26584 pid: 3932 ppid:  3611 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0x957/0xec0 kernel/sched/core.c:6431
 schedule+0xeb/0x1b0 kernel/sched/core.c:6503
 schedule_timeout+0xac/0x300 kernel/time/timer.c:1911
 do_wait_for_common+0x3ea/0x560 kernel/sched/completion.c:85
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x46/0x60 kernel/sched/completion.c:138
 __flush_work kernel/workqueue.c:3075 [inline]
 __cancel_work_timer+0x585/0x740 kernel/workqueue.c:3162
 hci_dev_close_sync+0x31/0xcc0 net/bluetooth/hci_sync.c:4091
 hci_dev_do_close net/bluetooth/hci_core.c:553 [inline]
 hci_unregister_dev+0x1b1/0x460 net/bluetooth/hci_core.c:2685
 hci_uart_tty_close+0x1a7/0x280 drivers/bluetooth/hci_ldisc.c:548
 tty_ldisc_kill drivers/tty/tty_ldisc.c:608 [inline]
 tty_ldisc_release+0x23c/0x510 drivers/tty/tty_ldisc.c:776
 tty_release_struct+0x27/0xd0 drivers/tty/tty_io.c:1694
 tty_release+0xc06/0xe60 drivers/tty/tty_io.c:1865
 __fput+0x3b9/0x820 fs/file_table.c:317
 task_work_run+0x146/0x1c0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x547/0x1ed0 kernel/exit.c:795
 do_group_exit+0x23b/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f934cf16ab9
RSP: 002b:00007fff38b78f88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f934cf8a330 RCX: 00007f934cf16ab9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 00007f934cf8a330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>
INFO: task syz-executor174:4073 blocked for more than 144 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor174 state:D stack:26584 pid: 4073 ppid:  3615 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0x957/0xec0 kernel/sched/core.c:6431
 schedule+0xeb/0x1b0 kernel/sched/core.c:6503
 schedule_timeout+0xac/0x300 kernel/time/timer.c:1911
 do_wait_for_common+0x3ea/0x560 kernel/sched/completion.c:85
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x46/0x60 kernel/sched/completion.c:138
 __flush_work kernel/workqueue.c:3075 [inline]
 __cancel_work_timer+0x585/0x740 kernel/workqueue.c:3162
 hci_dev_close_sync+0x31/0xcc0 net/bluetooth/hci_sync.c:4091
 hci_dev_do_close net/bluetooth/hci_core.c:553 [inline]
 hci_unregister_dev+0x1b1/0x460 net/bluetooth/hci_core.c:2685
 hci_uart_tty_close+0x1a7/0x280 drivers/bluetooth/hci_ldisc.c:548
 tty_ldisc_kill drivers/tty/tty_ldisc.c:608 [inline]
 tty_ldisc_release+0x23c/0x510 drivers/tty/tty_ldisc.c:776
 tty_release_struct+0x27/0xd0 drivers/tty/tty_io.c:1694
 tty_release+0xc06/0xe60 drivers/tty/tty_io.c:1865
 __fput+0x3b9/0x820 fs/file_table.c:317
 task_work_run+0x146/0x1c0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x547/0x1ed0 kernel/exit.c:795
 do_group_exit+0x23b/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f934cf16ab9
RSP: 002b:00007fff38b78f88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f934cf8a330 RCX: 00007f934cf16ab9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 00007f934cf8a330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/29:
 #0: ffffffff8cb1ebe0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
3 locks held by kworker/u5:0/47:
 #0: ffff88801fdcd938 ((wq_completion)hci2){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc90000b87d00 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffff88801d935048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_open net/bluetooth/hci_core.c:480 [inline]
 #2: ffff88801d935048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_power_on+0x178/0x650 net/bluetooth/hci_core.c:963
2 locks held by getty/3280:
 #0: ffff888025914098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:244
 #1: ffffc90002cd62e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6ad/0x1c90 drivers/tty/n_tty.c:2075
3 locks held by kworker/u5:5/3630:
 #0: ffff88801a8ed938 ((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc9000315fd00 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffff88801a7d1048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_open net/bluetooth/hci_core.c:480 [inline]
 #2: ffff88801a7d1048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_power_on+0x178/0x650 net/bluetooth/hci_core.c:963
3 locks held by kworker/u5:6/3631:
 #0: ffff8880772d6138 ((wq_completion)hci4){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc9000316fd00 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffff8880778cd048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_open net/bluetooth/hci_core.c:480 [inline]
 #2: ffff8880778cd048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_power_on+0x178/0x650 net/bluetooth/hci_core.c:963
2 locks held by kworker/0:4/3634:
 #0: ffff888011466538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc900031afd00 ((work_completion)(&rew->rew_work)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
3 locks held by kworker/u5:7/3652:
 #0: ffff88801b1bd938 ((wq_completion)hci5){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc900031efd00 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffff888075651048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_open net/bluetooth/hci_core.c:480 [inline]
 #2: ffff888075651048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_power_on+0x178/0x650 net/bluetooth/hci_core.c:963
3 locks held by kworker/u5:8/3667:
 #0: ffff88807b17b138 ((wq_completion)hci3){+.+.}-{0:0}, at: process_one_work+0x796/0xd10 kernel/workqueue.c:2262
 #1: ffffc9000309fd00 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x7d0/0xd10 kernel/workqueue.c:2264
 #2: ffff88807ae29048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_open net/bluetooth/hci_core.c:480 [inline]
 #2: ffff88807ae29048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_power_on+0x178/0x650 net/bluetooth/hci_core.c:963
3 locks held by syz-executor174/3932:
 #0: ffff88801ec0d098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff88801ec0d098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:336 [inline]
 #0: ffff88801ec0d098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff88801ec0d098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0x5b/0x510 drivers/tty/tty_ldisc.c:775
 #1: ffff88801ec0e098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff88801ec0e098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:338 [inline]
 #1: ffff88801ec0e098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff88801ec0e098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0x7f/0x510 drivers/tty/tty_ldisc.c:775
 #2: ffff88801d935048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close net/bluetooth/hci_core.c:551 [inline]
 #2: ffff88801d935048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_unregister_dev+0x1a9/0x460 net/bluetooth/hci_core.c:2685
3 locks held by syz-executor174/4073:
 #0: ffff888073846098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff888073846098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:346 [inline]
 #0: ffff888073846098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff888073846098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0xb3/0x510 drivers/tty/tty_ldisc.c:775
 #1: ffff88807d590098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff88807d590098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:348 [inline]
 #1: ffff88807d590098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff88807d590098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0xd7/0x510 drivers/tty/tty_ldisc.c:775
 #2: ffff88807ae29048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close net/bluetooth/hci_core.c:551 [inline]
 #2: ffff88807ae29048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_unregister_dev+0x1a9/0x460 net/bluetooth/hci_core.c:2685
3 locks held by syz-executor174/4621:
 #0: ffff888074f58098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff888074f58098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:336 [inline]
 #0: ffff888074f58098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff888074f58098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0x5b/0x510 drivers/tty/tty_ldisc.c:775
 #1: ffff888074f5a098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff888074f5a098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:338 [inline]
 #1: ffff888074f5a098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff888074f5a098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0x7f/0x510 drivers/tty/tty_ldisc.c:775
 #2: ffff888075651048
 (&hdev->req_lock){+.+.}-{3:3}, at: __debug_check_no_obj_freed lib/debugobjects.c:977 [inline]
 (&hdev->req_lock){+.+.}-{3:3}, at: debug_check_no_obj_freed+0xc5/0x650 lib/debugobjects.c:1020
3 locks held by syz-executor174/4623:
 #0: ffff888021031098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff888021031098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:346 [inline]
 #0: ffff888021031098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff888021031098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0xb3/0x510 drivers/tty/tty_ldisc.c:775
 #1: ffff888021034098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff888021034098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:348 [inline]
 #1: ffff888021034098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff888021034098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0xd7/0x510 drivers/tty/tty_ldisc.c:775
 #2: ffff88801a7d1048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close net/bluetooth/hci_core.c:551 [inline]
 #2: ffff88801a7d1048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_unregister_dev+0x1a9/0x460 net/bluetooth/hci_core.c:2685
3 locks held by syz-executor174/4624:
 #0: ffff888074f59098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff888074f59098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:346 [inline]
 #0: ffff888074f59098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff888074f59098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0xb3/0x510 drivers/tty/tty_ldisc.c:775
 #1: ffff888074f5b098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff888074f5b098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:348 [inline]
 #1: ffff888074f5b098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff888074f5b098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0xd7/0x510 drivers/tty/tty_ldisc.c:775
 #2: ffff8880778cd048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close net/bluetooth/hci_core.c:551 [inline]
 #2: ffff8880778cd048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_unregister_dev+0x1a9/0x460 net/bluetooth/hci_core.c:2685
4 locks held by syz-executor174/4625:
 #0: ffff8880166dc098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff8880166dc098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:346 [inline]
 #0: ffff8880166dc098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff8880166dc098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0xb3/0x510 drivers/tty/tty_ldisc.c:775
 #1: ffff88801cfda098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff88801cfda098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:348 [inline]
 #1: ffff88801cfda098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff88801cfda098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0xd7/0x510 drivers/tty/tty_ldisc.c:775
 #2: ffff888023a8f990 (&hu->proto_lock){++++}-{0:0}, at: hci_uart_tty_close+0x123/0x280 drivers/bluetooth/hci_ldisc.c:539
 #3: ffffffff8cb23ce0 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #3: ffffffff8cb23ce0 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x266/0x720 kernel/rcu/tree_exp.h:927
3 locks held by syz-executor174/4626:
 #0: ffff888074220098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:290 [inline]
 #0: ffff888074220098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:346 [inline]
 #0: ffff888074220098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #0: ffff888074220098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_release+0xb3/0x510 drivers/tty/tty_ldisc.c:775
 #1: ffff888074224098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: __tty_ldisc_lock_nested drivers/tty/tty_ldisc.c:296 [inline]
 #1: ffff888074224098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair_timeout drivers/tty/tty_ldisc.c:348 [inline]
 #1: ffff888074224098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_lock_pair drivers/tty/tty_ldisc.c:367 [inline]
 #1: ffff888074224098 (&tty->ldisc_sem/1){+.+.}-{0:0}, at: tty_ldisc_release+0xd7/0x510 drivers/tty/tty_ldisc.c:775
 #2: ffff88801f204d90 (&hu->proto_lock){++++}-{0:0}, at: hci_uart_tty_close+0x123/0x280 drivers/bluetooth/hci_ldisc.c:539

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 29 Comm: khungtaskd Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 nmi_cpu_backtrace+0x473/0x4a0 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x168/0x280 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
 watchdog+0xd18/0xd60 kernel/hung_task.c:378
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 48 Comm: kworker/u4:2 Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x4/0x60 kernel/kcov.c:199
Code: 00 00 00 00 66 90 53 48 89 fb e8 17 00 00 00 48 8b 3d 18 f1 7b 0c 48 89 de 5b e9 47 ee 51 00 cc cc cc cc cc cc cc 48 8b 04 24 <65> 48 8b 0c 25 00 6f 02 00 65 8b 15 a4 fc 7a 7e f7 c2 00 01 ff 00
RSP: 0018:ffffc90000b97658 EFLAGS: 00000093
RAX: ffffffff813cd4d4 RBX: ffff8881c00fb000 RCX: 0000000000000000
RDX: ffff8880171ad880 RSI: 000000000000002e RDI: 0000000000000040
RBP: ffffc90000b97790 R08: ffffffff813cd4c5 R09: ffffed1027fc5085
R10: ffffed1027fc5085 R11: 1ffff11027fc5084 R12: 0000000000000000
R13: dffffc0000000000 R14: 00000001400fb000 R15: 000000000000002e
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f934cf8b1d0 CR3: 000000000c88e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 phys_addr_valid arch/x86/mm/physaddr.h:7 [inline]
 __phys_addr+0x94/0x160 arch/x86/mm/physaddr.c:28
 build_cr3 arch/x86/mm/tlb.c:163 [inline]
 load_new_mm_cr3 arch/x86/mm/tlb.c:283 [inline]
 switch_mm_irqs_off+0x8f5/0x910 arch/x86/mm/tlb.c:628
 use_temporary_mm arch/x86/kernel/alternative.c:962 [inline]
 __text_poke+0x5c2/0x9d0 arch/x86/kernel/alternative.c:1073
 text_poke arch/x86/kernel/alternative.c:1137 [inline]
 text_poke_bp_batch+0x6bc/0x970 arch/x86/kernel/alternative.c:1483
 text_poke_flush arch/x86/kernel/alternative.c:1589 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1596
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:146
 static_key_enable_cpuslocked+0x129/0x250 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate+0xbf/0x470 mm/kfence/core.c:808
 process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	66 90                	xchg   %ax,%ax
   6:	53                   	push   %rbx
   7:	48 89 fb             	mov    %rdi,%rbx
   a:	e8 17 00 00 00       	callq  0x26
   f:	48 8b 3d 18 f1 7b 0c 	mov    0xc7bf118(%rip),%rdi        # 0xc7bf12e
  16:	48 89 de             	mov    %rbx,%rsi
  19:	5b                   	pop    %rbx
  1a:	e9 47 ee 51 00       	jmpq   0x51ee66
  1f:	cc                   	int3
  20:	cc                   	int3
  21:	cc                   	int3
  22:	cc                   	int3
  23:	cc                   	int3
  24:	cc                   	int3
  25:	cc                   	int3
  26:	48 8b 04 24          	mov    (%rsp),%rax
* 2a:	65 48 8b 0c 25 00 6f 	mov    %gs:0x26f00,%rcx <-- trapping instruction
  31:	02 00
  33:	65 8b 15 a4 fc 7a 7e 	mov    %gs:0x7e7afca4(%rip),%edx        # 0x7e7afcde
  3a:	f7 c2 00 01 ff 00    	test   $0xff0100,%edx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
