Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380C26EE826
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 21:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbjDYTYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 15:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbjDYTXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 15:23:55 -0400
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1AA18B90
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 12:23:52 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7639ebbef32so706794339f.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 12:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682450631; x=1685042631;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7wp9/5MJgDYCIUfKNZXJR2m1Kl0JfYcxjRayQuhYEtM=;
        b=ke4Hx/N3KAFHvxekYB3Vg5tUdCCvG6SclgWgSc8UMtyzc9C15YPw5wv7IhH0xr43Q6
         8hpBKPpBMvFMh+YKORYxKwljpM3vkEC6lEo9m9ke88X0nEH67sFRptB8v0qmB2JZUYHE
         mt+zySu1LiqDz35DfaA5Jj2xVwQ+iQscNhD49Q5DBmclMlez7pxizbyYFYwKlZkE+lH3
         w08q+lt9ppCeeoKmwBHr9TAcwjDRxWwgbqLnYkIMO3uj8yLkTFQxXKoZD9ETU8XoEQtM
         tvCO+lRNm2V6Ff8jYb2RvIO5lOGeOKcY/VYBw6smLRSzCQ5ifV/YOkcbf7OCzsb0leD/
         4Isw==
X-Gm-Message-State: AAQBX9elarGMUuGZrmLVEcirLirrm61cr9D6XVzdqegjm0OiVWklB0hP
        zt8AcuxHWYWhfW4TB9Pq0ovvjlaSmBiVt3pBgCEJ+tXlMg0i
X-Google-Smtp-Source: AKy350ZQKXuzUAurJ6lf35jiy82lk7RV10MpNHhQ60zclN1QTHlzonRs9Pcctvxdt7LMdl3iGiZWzsKMWGDTDgko/Wt/MDWTt2ZO
MIME-Version: 1.0
X-Received: by 2002:a02:b109:0:b0:40f:cf8d:86e6 with SMTP id
 r9-20020a02b109000000b0040fcf8d86e6mr7525030jah.4.1682450631423; Tue, 25 Apr
 2023 12:23:51 -0700 (PDT)
Date:   Tue, 25 Apr 2023 12:23:51 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003cfeb205fa2e10e0@google.com>
Subject: [syzbot] [wireless?] INFO: task hung in ath9k_hif_usb_firmware_cb (2)
From:   syzbot <syzbot+d5635158fb0281b27bff@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8f40fc080813 usb: dwc3: gadget: Refactor EP0 forced stall/..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=14a6e320280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51fcd1c8b17faf3c
dashboard link: https://syzkaller.appspot.com/bug?extid=d5635158fb0281b27bff
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/25d265ba0e56/disk-8f40fc08.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/117b3f370e35/vmlinux-8f40fc08.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7046fc173e38/bzImage-8f40fc08.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d5635158fb0281b27bff@syzkaller.appspotmail.com

INFO: task kworker/1:0:21 blocked for more than 143 seconds.
      Not tainted 6.3.0-rc6-syzkaller-g8f40fc080813 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0     state:D stack:21984 pid:21    ppid:2      flags:0x00004000
Workqueue: events request_firmware_work_func
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5307 [inline]
 __schedule+0xa90/0x2da0 kernel/sched/core.c:6625
 schedule+0xde/0x1a0 kernel/sched/core.c:6701
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6760
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 device_lock include/linux/device.h:832 [inline]
 ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1146 [inline]
 ath9k_hif_usb_firmware_cb+0x3a9/0x620 drivers/net/wireless/ath/ath9k/hif_usb.c:1279
 request_firmware_work_func+0x130/0x240 drivers/base/firmware_loader/main.c:1107
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2ee/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Showing all locks held in the system:
5 locks held by kworker/0:0/7:
1 lock held by rcu_tasks_kthre/11:
 #0: ffffffff87c9bb70 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
1 lock held by rcu_tasks_trace/12:
 #0: ffffffff87c9b870 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
3 locks held by kworker/1:0/21:
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x87a/0x15c0 kernel/workqueue.c:2361
 #1: ffffc9000016fda8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x15c0 kernel/workqueue.c:2365
 #2: ffff88810e9d5190 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:832 [inline]
 #2: ffff88810e9d5190 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_fail drivers/net/wireless/ath/ath9k/hif_usb.c:1146 [inline]
 #2: ffff88810e9d5190 (&dev->mutex){....}-{3:3}, at: ath9k_hif_usb_firmware_cb+0x3a9/0x620 drivers/net/wireless/ath/ath9k/hif_usb.c:1279
1 lock held by khungtaskd/27:
 #0: ffffffff87c9c6c0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x340 kernel/locking/lockdep.c:6495
2 locks held by getty/2413:
 #0: ffff8881101e3098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x26/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc900000452f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xef4/0x13e0 drivers/tty/n_tty.c:2177
2 locks held by kworker/1:4/5200:
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x87a/0x15c0 kernel/workqueue.c:2361
 #1: ffffc90001977da8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x15c0 kernel/workqueue.c:2365
4 locks held by udevd/7445:
 #0: ffff8881156c62f0 (&p->lock){+.+.}-{3:3}, at: seq_read_iter+0xe3/0x12d0 fs/seq_file.c:182
 #1: ffff8881256c3888 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x4b/0x450 fs/kernfs/file.c:154
 #2: ffff88811dae3da0 (kn->active#28){++++}-{0:0}, at: kernfs_seq_start+0x75/0x450 fs/kernfs/file.c:155
 #3: ffff88810d5cd190 (&dev->mutex){....}-{3:3}, at: device_lock_interruptible include/linux/device.h:837 [inline]
 #3: ffff88810d5cd190 (&dev->mutex){....}-{3:3}, at: manufacturer_show+0x26/0xa0 drivers/usb/core/sysfs.c:142
4 locks held by udevd/7446:
 #0: ffff888110bb19e0 (&p->lock){+.+.}-{3:3}, at: seq_read_iter+0xe3/0x12d0 fs/seq_file.c:182
 #1: ffff88811a753488 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x4b/0x450 fs/kernfs/file.c:154
 #2: ffff88810d9c1a00 (kn->active#28){++++}-{0:0}, at: kernfs_seq_start+0x75/0x450 fs/kernfs/file.c:155
 #3: ffff8881161f3190 (&dev->mutex){....}-{3:3}, at: device_lock_interruptible include/linux/device.h:837 [inline]
 #3: ffff8881161f3190 (&dev->mutex){....}-{3:3}, at: manufacturer_show+0x26/0xa0 drivers/usb/core/sysfs.c:142
6 locks held by kworker/1:6/7527:
 #0: ffff888109030938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888109030938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888109030938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888109030938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888109030938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888109030938 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x87a/0x15c0 kernel/workqueue.c:2361
 #1: ffffc900027afda8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x15c0 kernel/workqueue.c:2365
 #2: ffff88810ea91190 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:832 [inline]
 #2: ffff88810ea91190 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c0/0x4ed0 drivers/usb/core/hub.c:5739
 #3: ffff88810d5cd190 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:832 [inline]
 #3: ffff88810d5cd190 (&dev->mutex){....}-{3:3}, at: __device_attach+0x76/0x4b0 drivers/base/dd.c:973
 #4: ffff8881256db118 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:832 [inline]
 #4: ffff8881256db118 (&dev->mutex){....}-{3:3}, at: __device_attach+0x76/0x4b0 drivers/base/dd.c:973
 #5: ffff8881f673b0d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:539 [inline]
 #5: ffff8881f673b0d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock kernel/sched/sched.h:1366 [inline]
 #5: ffff8881f673b0d8 (&rq->__lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1653 [inline]
 #5: ffff8881f673b0d8 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x263/0x2da0 kernel/sched/core.c:6542
2 locks held by kworker/0:6/7578:
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888100070d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x87a/0x15c0 kernel/workqueue.c:2361
 #1: ffffc90005c0fda8 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x15c0 kernel/workqueue.c:2365

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 27 Comm: khungtaskd Not tainted 6.3.0-rc6-syzkaller-g8f40fc080813 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x29c/0x350 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x273/0x2d0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:222 [inline]
 watchdog+0xe16/0x1090 kernel/hung_task.c:379
 kthread+0x2ee/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 5211 Comm: syz-executor.5 Not tainted 6.3.0-rc6-syzkaller-g8f40fc080813 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
RIP: 0010:wait_consider_task+0xa9/0x3ce0 kernel/exit.c:1389
Code: 55 33 00 49 8d 87 f0 04 00 00 48 89 44 24 10 48 c1 e8 03 0f b6 04 28 84 c0 74 08 3c 03 0f 8e 6c 1a 00 00 45 8b a7 f0 04 00 00 <bf> 10 00 00 00 44 89 e6 e8 ba 51 33 00 41 83 fc 10 0f 84 f3 00 00
RSP: 0018:ffffc900019d7b60 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88810b338000 RSI: ffffffff811734c2 RDI: ffffc900019d7d18
RBP: dffffc0000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88810b338000 R14: 0000000000000004 R15: ffff888118bb3900
FS:  0000555556c19400(0000) GS:ffff8881f6700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3100143918 CR3: 000000012a818000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_wait_thread kernel/exit.c:1495 [inline]
 do_wait+0x799/0xc30 kernel/exit.c:1612
 kernel_wait4+0x150/0x260 kernel/exit.c:1775
 __do_sys_wait4+0x13f/0x150 kernel/exit.c:1803
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2239d01d06
Code: 1f 44 00 00 31 c9 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 14 48 89 74 24
RSP: 002b:00007ffc75448bd8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 000000000000010c RCX: 00007f2239d01d06
RDX: 0000000040000001 RSI: 00007ffc75448c3c RDI: 00000000ffffffff
RBP: 00007ffc75448c3c R08: 0000000000000150 R09: 00007ffc755ab080
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000032
R13: 00000000000521a2 R14: 0000000000000000 R15: 00007ffc75448ca0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
