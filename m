Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D8545023E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhKOKWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:22:19 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:52834 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbhKOKVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 05:21:19 -0500
Received: by mail-io1-f71.google.com with SMTP id k12-20020a0566022a4c00b005ebe737d989so4768768iov.19
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 02:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SM1uJ26vSEDyvDw5WPrfvzbZu3IYg7cQTLTv6OpixUQ=;
        b=x7E3t1JqxDpzjGzFE1fkzHfwewePcQUQK+xSOUypq4LhNcXjTx+MTTe4ZMVTXREauP
         ZM0V108xABuJ0sO2HscJmjwE/vOMUfe5nYpyJFQhOPkpkDcY04mHZk38bPbESY9fbcn7
         ZZMFAkCaIWsfFBoVSuG31XJxJRmC+8vIVu4WJ5GZRXIyQSayuAZUzYxD9+g0JQ59KeRh
         ky2FRiXRa+KbFRKGU/CfRjDXuLN7ZN9zxVZvDap9+cv1WoFkif3dJMiN5pW7gQjl6+J3
         mwXtUssRm+Y2/RjhFEdOlu0f7ir5nwKfSA7uz/eZ4ob8Px4vaztlDw9nwxtgMY7HdtwA
         mPJg==
X-Gm-Message-State: AOAM530M1HIrcpYKxodpzyAcmvnJNRMo9Md94GoBWUGFTerjL4QJShRM
        tZ+BL+fDZ2OIW4wrPy5mAsMWbeD7XpwNo3FYRgHVuiN/wNR3
X-Google-Smtp-Source: ABdhPJyOgNhboAuH/N1MzlWEZ2kVoTnnPAnONUQjKU/OIBhTi91k1dPb+ETM0c7gdjCC/Z/Ut66ZylVLjeRMXuxWqrFWNneWG2B/
MIME-Version: 1.0
X-Received: by 2002:a6b:c403:: with SMTP id y3mr24528106ioa.21.1636971504439;
 Mon, 15 Nov 2021 02:18:24 -0800 (PST)
Date:   Mon, 15 Nov 2021 02:18:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000007948005d0d1214b@google.com>
Subject: [syzbot] INFO: task can't die in __bio_queue_enter
From:   syzbot <syzbot+7ab022485f6761927d68@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ad8be4fa6e81 Add linux-next specific files for 20211111
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17026efab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba9c83199208e103
dashboard link: https://syzkaller.appspot.com/bug?extid=7ab022485f6761927d68
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7ab022485f6761927d68@syzkaller.appspotmail.com

INFO: task syz-executor.2:8342 can't die for more than 143 seconds.
task:syz-executor.2  state:D stack:27152 pid: 8342 ppid:  6533 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 __bio_queue_enter+0x3c5/0x6a0 block/blk-core.c:441
 bio_queue_enter block/blk.h:91 [inline]
 blk_mq_sched_bio_merge+0x1f0/0x870 block/blk-mq-sched.c:373
 blk_attempt_bio_merge block/blk-mq.c:2504 [inline]
 blk_attempt_bio_merge block/blk-mq.c:2498 [inline]
 blk_mq_get_new_requests block/blk-mq.c:2527 [inline]
 blk_mq_get_request block/blk-mq.c:2572 [inline]
 blk_mq_submit_bio+0x1601/0x21b0 block/blk-mq.c:2609
 __submit_bio block/blk-core.c:851 [inline]
 __submit_bio_noacct_mq block/blk-core.c:926 [inline]
 submit_bio_noacct block/blk-core.c:952 [inline]
 submit_bio_noacct+0x82c/0xa20 block/blk-core.c:941
 submit_bio block/blk-core.c:1013 [inline]
 submit_bio+0x1ea/0x430 block/blk-core.c:971
 blk_next_bio block/blk-lib.c:19 [inline]
 __blkdev_issue_zero_pages+0x243/0x4c0 block/blk-lib.c:319
 blkdev_issue_zeroout+0x3d0/0x450 block/blk-lib.c:413
 blkdev_fallocate+0x318/0x420 block/fops.c:635
 vfs_fallocate+0x48d/0xe10 fs/open.c:307
 ksys_fallocate fs/open.c:330 [inline]
 __do_sys_fallocate fs/open.c:338 [inline]
 __se_sys_fallocate fs/open.c:336 [inline]
 __x64_sys_fallocate+0xcf/0x140 fs/open.c:336
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc9f6c6cae9
RSP: 002b:00007fc9f41e2188 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007fc9f6d7ff60 RCX: 00007fc9f6c6cae9
RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000000007
RBP: 00007fc9f6cc6f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000100007e00 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe39e347cf R14: 00007fc9f41e2300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.2:8342 blocked for more than 143 seconds.
      Not tainted 5.15.0-next-20211111-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:27152 pid: 8342 ppid:  6533 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 __bio_queue_enter+0x3c5/0x6a0 block/blk-core.c:441
 bio_queue_enter block/blk.h:91 [inline]
 blk_mq_sched_bio_merge+0x1f0/0x870 block/blk-mq-sched.c:373
 blk_attempt_bio_merge block/blk-mq.c:2504 [inline]
 blk_attempt_bio_merge block/blk-mq.c:2498 [inline]
 blk_mq_get_new_requests block/blk-mq.c:2527 [inline]
 blk_mq_get_request block/blk-mq.c:2572 [inline]
 blk_mq_submit_bio+0x1601/0x21b0 block/blk-mq.c:2609
 __submit_bio block/blk-core.c:851 [inline]
 __submit_bio_noacct_mq block/blk-core.c:926 [inline]
 submit_bio_noacct block/blk-core.c:952 [inline]
 submit_bio_noacct+0x82c/0xa20 block/blk-core.c:941
 submit_bio block/blk-core.c:1013 [inline]
 submit_bio+0x1ea/0x430 block/blk-core.c:971
 blk_next_bio block/blk-lib.c:19 [inline]
 __blkdev_issue_zero_pages+0x243/0x4c0 block/blk-lib.c:319
 blkdev_issue_zeroout+0x3d0/0x450 block/blk-lib.c:413
 blkdev_fallocate+0x318/0x420 block/fops.c:635
 vfs_fallocate+0x48d/0xe10 fs/open.c:307
 ksys_fallocate fs/open.c:330 [inline]
 __do_sys_fallocate fs/open.c:338 [inline]
 __se_sys_fallocate fs/open.c:336 [inline]
 __x64_sys_fallocate+0xcf/0x140 fs/open.c:336
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc9f6c6cae9
RSP: 002b:00007fc9f41e2188 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007fc9f6d7ff60 RCX: 00007fc9f6c6cae9
RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000000007
RBP: 00007fc9f6cc6f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000100007e00 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe39e347cf R14: 00007fc9f41e2300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.0:8372 can't die for more than 143 seconds.
task:syz-executor.0  state:D stack:26728 pid: 8372 ppid: 11411 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 blk_mq_freeze_queue_wait+0x112/0x160 block/blk-mq.c:178
 loop_set_status+0x440/0x930 drivers/block/loop.c:1264
 loop_set_status_old+0x148/0x1b0 drivers/block/loop.c:1396
 lo_ioctl+0x3e9/0x17c0 drivers/block/loop.c:1566
 blkdev_ioctl+0x37a/0x800 block/ioctl.c:597
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4a3e38bae9
RSP: 002b:00007f4a3b901188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4a3e49ef60 RCX: 00007f4a3e38bae9
RDX: 0000000020000000 RSI: 0000000000004c02 RDI: 0000000000000004
RBP: 00007f4a3e3e5f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffe882d0bf R14: 00007f4a3b901300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.0:8372 blocked for more than 144 seconds.
      Not tainted 5.15.0-next-20211111-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:26728 pid: 8372 ppid: 11411 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 blk_mq_freeze_queue_wait+0x112/0x160 block/blk-mq.c:178
 loop_set_status+0x440/0x930 drivers/block/loop.c:1264
 loop_set_status_old+0x148/0x1b0 drivers/block/loop.c:1396
 lo_ioctl+0x3e9/0x17c0 drivers/block/loop.c:1566
 blkdev_ioctl+0x37a/0x800 block/ioctl.c:597
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4a3e38bae9
RSP: 002b:00007f4a3b901188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4a3e49ef60 RCX: 00007f4a3e38bae9
RDX: 0000000020000000 RSI: 0000000000004c02 RDI: 0000000000000004
RBP: 00007f4a3e3e5f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffe882d0bf R14: 00007f4a3b901300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.3:8374 can't die for more than 144 seconds.
task:syz-executor.3  state:D stack:28824 pid: 8374 ppid:  9434 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6397
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 blkdev_put+0x97/0x9e0 block/bdev.c:914
 blkdev_close+0x6a/0x80 block/fops.c:515
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1bef/0x2220 kernel/signal.c:2602
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe0e3187ae9
RSP: 002b:00007fe0e06dc188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: fffffffffffffffc RBX: 00007fe0e329b020 RCX: 00007fe0e3187ae9
RDX: ffffffffffffffff RSI: 0000000000004c07 RDI: 0000000000000003
RBP: 00007fe0e31e1f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc9746e67f R14: 00007fe0e06dc300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.3:8374 blocked for more than 144 seconds.
      Not tainted 5.15.0-next-20211111-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:28824 pid: 8374 ppid:  9434 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6397
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 blkdev_put+0x97/0x9e0 block/bdev.c:914
 blkdev_close+0x6a/0x80 block/fops.c:515
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1bef/0x2220 kernel/signal.c:2602
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe0e3187ae9
RSP: 002b:00007fe0e06dc188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: fffffffffffffffc RBX: 00007fe0e329b020 RCX: 00007fe0e3187ae9
RDX: ffffffffffffffff RSI: 0000000000004c07 RDI: 0000000000000003
RBP: 00007fe0e31e1f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc9746e67f R14: 00007fe0e06dc300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.1:8378 can't die for more than 145 seconds.
task:syz-executor.1  state:D stack:28496 pid: 8378 ppid:  6531 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6397
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 blkdev_get_by_dev.part.0+0x9b/0xb50 block/bdev.c:819
 blkdev_get_by_dev+0x6b/0x80 block/bdev.c:859
 blkdev_open+0x154/0x2e0 block/fops.c:501
 do_dentry_open+0x4c8/0x1250 fs/open.c:822
 do_open fs/namei.c:3426 [inline]
 path_openat+0x1cad/0x2750 fs/namei.c:3559
 do_filp_open+0x1aa/0x400 fs/namei.c:3586
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1212
 do_sys_open fs/open.c:1228 [inline]
 __do_sys_openat fs/open.c:1244 [inline]
 __se_sys_openat fs/open.c:1239 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1239
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8f19777a04
RSP: 002b:00007f8f16d39cc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 6666666666666667 RCX: 00007f8f19777a04
RDX: 0000000000101200 RSI: 00007f8f16d39d60 RDI: 00000000ffffff9c
RBP: 00007f8f16d39d60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000101200
R13: 00007ffc4394f41f R14: 00007f8f16d3a300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.1:8378 blocked for more than 145 seconds.
      Not tainted 5.15.0-next-20211111-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.1  state:D stack:28496 pid: 8378 ppid:  6531 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6397
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 blkdev_get_by_dev.part.0+0x9b/0xb50 block/bdev.c:819
 blkdev_get_by_dev+0x6b/0x80 block/bdev.c:859
 blkdev_open+0x154/0x2e0 block/fops.c:501
 do_dentry_open+0x4c8/0x1250 fs/open.c:822
 do_open fs/namei.c:3426 [inline]
 path_openat+0x1cad/0x2750 fs/namei.c:3559
 do_filp_open+0x1aa/0x400 fs/namei.c:3586
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1212
 do_sys_open fs/open.c:1228 [inline]
 __do_sys_openat fs/open.c:1244 [inline]
 __se_sys_openat fs/open.c:1239 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1239
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8f19777a04
RSP: 002b:00007f8f16d39cc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 6666666666666667 RCX: 00007f8f19777a04
RDX: 0000000000101200 RSI: 00007f8f16d39d60 RDI: 00000000ffffff9c
RBP: 00007f8f16d39d60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000101200
R13: 00007ffc4394f41f R14: 00007f8f16d3a300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.5:8379 can't die for more than 145 seconds.
task:syz-executor.5  state:D stack:28496 pid: 8379 ppid:  7064 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6397
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 blkdev_get_by_dev.part.0+0x9b/0xb50 block/bdev.c:819
 blkdev_get_by_dev+0x6b/0x80 block/bdev.c:859
 blkdev_open+0x154/0x2e0 block/fops.c:501
 do_dentry_open+0x4c8/0x1250 fs/open.c:822
 do_open fs/namei.c:3426 [inline]
 path_openat+0x1cad/0x2750 fs/namei.c:3559
 do_filp_open+0x1aa/0x400 fs/namei.c:3586
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1212
 do_sys_open fs/open.c:1228 [inline]
 __do_sys_openat fs/open.c:1244 [inline]
 __se_sys_openat fs/open.c:1239 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1239
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f64a2f2da04
RSP: 002b:00007f64a04efcc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 6666666666666667 RCX: 00007f64a2f2da04
RDX: 0000000000000000 RSI: 00007f64a04efd60 RDI: 00000000ffffff9c
RBP: 00007f64a04efd60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007ffd7b06952f R14: 00007f64a04f0300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.5:8379 blocked for more than 145 seconds.
      Not tainted 5.15.0-next-20211111-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:28496 pid: 8379 ppid:  7064 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4984 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6265
 schedule+0xd2/0x260 kernel/sched/core.c:6338
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6397
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 blkdev_get_by_dev.part.0+0x9b/0xb50 block/bdev.c:819
 blkdev_get_by_dev+0x6b/0x80 block/bdev.c:859
 blkdev_open+0x154/0x2e0 block/fops.c:501
 do_dentry_open+0x4c8/0x1250 fs/open.c:822
 do_open fs/namei.c:3426 [inline]
 path_openat+0x1cad/0x2750 fs/namei.c:3559
 do_filp_open+0x1aa/0x400 fs/namei.c:3586
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1212
 do_sys_open fs/open.c:1228 [inline]
 __do_sys_openat fs/open.c:1244 [inline]
 __se_sys_openat fs/open.c:1239 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1239
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f64a2f2da04
RSP: 002b:00007f64a04efcc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 6666666666666667 RCX: 00007f64a2f2da04
RDX: 0000000000000000 RSI: 00007f64a04efd60 RDI: 00000000ffffff9c
RBP: 00007f64a04efd60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007ffd7b06952f R14: 00007f64a04f0300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8bb83a60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
2 locks held by systemd-udevd/2977:
 #0: ffff88801aac1918 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev.part.0+0x9b/0xb50 block/bdev.c:819
 #1: ffff88801aa55360 (&lo->lo_mutex){+.+.}-{3:3}, at: lo_open+0x75/0x120 drivers/block/loop.c:1733
1 lock held by in:imklog/6227:
2 locks held by kworker/u4:8/30048:
1 lock held by syz-executor.2/8342:
 #0: ffff88814089d008 (mapping.invalidate_lock#2){++++}-{3:3}, at: filemap_invalidate_lock include/linux/fs.h:828 [inline]
 #0: ffff88814089d008 (mapping.invalidate_lock#2){++++}-{3:3}, at: blkdev_fallocate+0x1e2/0x420 block/fops.c:625
1 lock held by syz-executor.0/8372:
 #0: ffff88801aa55360 (&lo->lo_mutex){+.+.}-{3:3}, at: loop_set_status+0x2a/0x930 drivers/block/loop.c:1248
1 lock held by syz-executor.3/8374:
 #0: ffff88801aac1918 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_put+0x97/0x9e0 block/bdev.c:914
1 lock held by syz-executor.1/8378:
 #0: ffff88801aac1918 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev.part.0+0x9b/0xb50 block/bdev.c:819
1 lock held by syz-executor.5/8379:
 #0: ffff88801aac1918 (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_get_by_dev.part.0+0x9b/0xb50 block/bdev.c:819

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.15.0-next-20211111-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:254 [inline]
 watchdog+0xcb7/0xed0 kernel/hung_task.c:339
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 2967 Comm: systemd-journal Not tainted 5.15.0-next-20211111-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:139 [inline]
RIP: 0010:lock_acquire kernel/locking/lockdep.c:5640 [inline]
RIP: 0010:lock_acquire+0x1dc/0x510 kernel/locking/lockdep.c:5602
Code: 48 83 c4 20 e8 35 07 f3 07 b8 ff ff ff ff 65 0f c1 05 08 96 a5 7e 83 f8 01 0f 85 b4 02 00 00 9c 58 f6 c4 02 0f 85 9f 02 00 00 <48> 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df 48 01 c3
RSP: 0018:ffffc9000287fba0 EFLAGS: 00000046
RAX: 0000000000000046 RBX: 1ffff9200050ff76 RCX: ffffffff815c915f
RDX: 1ffff1100f5584f4 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff8ff74a07
R10: fffffbfff1fee940 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff907046c8 R15: 0000000000000000
FS:  00007f07119c58c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f070f0fb000 CR3: 000000007f1f5000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 debug_object_activate+0x12e/0x3e0 lib/debugobjects.c:661
 debug_object_activate+0x337/0x3e0 lib/debugobjects.c:707
 debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
 __call_rcu kernel/rcu/tree.c:2969 [inline]
 call_rcu+0x2c/0x740 kernel/rcu/tree.c:3065
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f0710f54840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007fffcfc186a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: fffffffffffffffe RBX: 00007fffcfc189b0 RCX: 00007f0710f54840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 00005628e5809fd0
RBP: 000000000000000d R08: 0000000000000000 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00005628e57fd040 R14: 00007fffcfc18970 R15: 00005628e5809df0
 </TASK>
----------------
Code disassembly (best guess):
   0:	48 83 c4 20          	add    $0x20,%rsp
   4:	e8 35 07 f3 07       	callq  0x7f3073e
   9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   e:	65 0f c1 05 08 96 a5 	xadd   %eax,%gs:0x7ea59608(%rip)        # 0x7ea5961e
  15:	7e
  16:	83 f8 01             	cmp    $0x1,%eax
  19:	0f 85 b4 02 00 00    	jne    0x2d3
  1f:	9c                   	pushfq
  20:	58                   	pop    %rax
  21:	f6 c4 02             	test   $0x2,%ah
  24:	0f 85 9f 02 00 00    	jne    0x2c9
* 2a:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp) <-- trapping instruction
  30:	74 01                	je     0x33
  32:	fb                   	sti
  33:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3a:	fc ff df
  3d:	48 01 c3             	add    %rax,%rbx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
