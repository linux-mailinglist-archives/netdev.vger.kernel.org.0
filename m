Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E3B629FB3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbiKOQ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiKOQ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:56:45 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9256B13FAB
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:56:43 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id a14-20020a921a0e000000b003016bfa7e50so11502290ila.16
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:56:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oqXlldeI6HzdmlJnUaj2xoDKV/PnBucoP3pJnDmXiXE=;
        b=CRMR2wkd1TljrsP4GKJeRsuTrBy8/1ugx5Ijpl1e/+6Dhxd1NSu5LgO6m6uSDOkFYE
         SNGYx6Ual9/4W9p7+6DGVPbE2jH4968PPcH59khDWPKXPAqcrpRO/N0j/+Q73xXRDAKL
         1+pgeDKR/wjF0ZVra4x8P/x++V1/PfsXXCW+/6+QDsxATGqwOnL192cHLrIgkwTq5T8v
         AjqWvBppzob+t4vqu5sKpPUjPtGX0umeHEJd5oD4nGjfrLENeQwf/wYP4z0FjtXNyiwt
         wAa/XtqDLN52w8//W2AYUDaDf6Edc51vYoEeb4WHYM04m9dFRAIg/AgZFCntTN1fA1wD
         rtOw==
X-Gm-Message-State: ANoB5pkaVOj4YFLio1J4O7+B+BJ/YazVRujgq6Sh0SuRbb5s4AYEWsdm
        fMLRUcV1Z3zMEiaqkjGMY19IWL6Icq1fD6HJgMVR0u9A7Sv5
X-Google-Smtp-Source: AA0mqf4NNNks/yqOYLhgz3pn9z6ClbXOdz29q52HRnnJtcHd0rf8x4Nt6unUcbTh22BAJFdB6Wllp/4swyPoODYrH/iPEXjrCYab
MIME-Version: 1.0
X-Received: by 2002:a02:734a:0:b0:375:7ab5:7158 with SMTP id
 a10-20020a02734a000000b003757ab57158mr8345756jae.160.1668531402941; Tue, 15
 Nov 2022 08:56:42 -0800 (PST)
Date:   Tue, 15 Nov 2022 08:56:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000091ae7105ed853d35@google.com>
Subject: [syzbot] INFO: task hung in rfkill_global_led_trigger_worker (2)
From:   syzbot <syzbot+2e39bc6569d281acbcfb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e01d50cbd6ee Merge tag 'vfio-v6.1-rc6' of https://github.c..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=136f6401880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=47b0b2ecc119b39f
dashboard link: https://syzkaller.appspot.com/bug?extid=2e39bc6569d281acbcfb
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e85d35880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1579ac01880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b48e4d485e7e/disk-e01d50cb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dc9ba558e055/vmlinux-e01d50cb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b766d9815123/bzImage-e01d50cb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e39bc6569d281acbcfb@syzkaller.appspotmail.com

INFO: task kworker/0:6:4120 blocked for more than 143 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:6     state:D stack:24024 pid:4120  ppid:2      flags:0x00004000
Workqueue: events rfkill_global_led_trigger_worker
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8c9/0xd70 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6638
 __mutex_lock_common+0xe4f/0x26e0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 rfkill_global_led_trigger_worker+0x1b/0xf0 net/rfkill/core.c:181
 process_one_work+0x877/0xdb0 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
INFO: task syz-executor145:4505 blocked for more than 143 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor145 state:D stack:21896 pid:4505  ppid:3645   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8c9/0xd70 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6638
 __mutex_lock_common+0xe4f/0x26e0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 rfkill_unregister+0xcb/0x220 net/rfkill/core.c:1130
 nfc_unregister_device+0xba/0x290 net/nfc/core.c:1167
 virtual_ncidev_close+0x55/0x90 drivers/nfc/virtual_ncidev.c:166
 __fput+0x3ba/0x880 fs/file_table.c:320
 task_work_run+0x243/0x300 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x664/0x2070 kernel/exit.c:820
 do_group_exit+0x1fd/0x2b0 kernel/exit.c:950
 __do_sys_exit_group kernel/exit.c:961 [inline]
 __se_sys_exit_group kernel/exit.c:959 [inline]
 __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:959
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc8e3d92af9
RSP: 002b:00007fff2cfab0b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fc8e3e06330 RCX: 00007fc8e3d92af9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 00007fc8e3e06330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>
INFO: task syz-executor145:4514 blocked for more than 143 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor145 state:D stack:23816 pid:4514  ppid:3640   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8c9/0xd70 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6638
 __mutex_lock_common+0xe4f/0x26e0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 rfkill_fop_release+0x49/0x230 net/rfkill/core.c:1312
 __fput+0x3ba/0x880 fs/file_table.c:320
 task_work_run+0x243/0x300 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x664/0x2070 kernel/exit.c:820
 do_group_exit+0x1fd/0x2b0 kernel/exit.c:950
 __do_sys_exit_group kernel/exit.c:961 [inline]
 __se_sys_exit_group kernel/exit.c:959 [inline]
 __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:959
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc8e3d92af9
RSP: 002b:00007fff2cfab0b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fc8e3e06330 RCX: 00007fc8e3d92af9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 00007fc8e3e06330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>
INFO: task syz-executor145:4516 blocked for more than 144 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor145 state:D stack:23096 pid:4516  ppid:3647   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8c9/0xd70 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6638
 __mutex_lock_common+0xe4f/0x26e0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 device_lock include/linux/device.h:835 [inline]
 nfc_dev_down+0x33/0x260 net/nfc/core.c:143
 nfc_rfkill_set_block+0x28/0xc0 net/nfc/core.c:179
 rfkill_set_block+0x1e7/0x430 net/rfkill/core.c:345
 rfkill_fop_write+0x5db/0x790 net/rfkill/core.c:1286
 vfs_write+0x303/0xc50 fs/read_write.c:582
 ksys_write+0x177/0x2a0 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc8e3d93e69
RSP: 002b:00007fff2cfab108 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007fc8e3d93e69
RDX: 0000000000000008 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 000000000000d60b
R13: 00007fff2cfab11c R14: 00007fff2cfab130 R15: 00007fff2cfab120
 </TASK>
INFO: task syz-executor145:4517 blocked for more than 144 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor145 state:D stack:23816 pid:4517  ppid:3643   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8c9/0xd70 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6638
 __mutex_lock_common+0xe4f/0x26e0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 misc_open+0x57/0x3c0 drivers/char/misc.c:107
 chrdev_open+0x53b/0x5f0 fs/char_dev.c:414
 do_dentry_open+0x85f/0x11b0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x25fc/0x2df0 fs/namei.c:3713
 do_filp_open+0x264/0x4f0 fs/namei.c:3740
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc8e3d93e69
RSP: 002b:00007fff2cfab108 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007fc8e3d93e69
RDX: 0000000000000002 RSI: 0000000020002100 RDI: ffffffffffffff9c
RBP: 0000000000000000 R08: 00007fff2cfaab80 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000d60c
R13: 00007fff2cfab11c R14: 00007fff2cfab130 R15: 00007fff2cfab120
 </TASK>
INFO: task syz-executor145:4518 blocked for more than 144 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor145 state:D stack:23816 pid:4518  ppid:3639   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8c9/0xd70 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6638
 __mutex_lock_common+0xe4f/0x26e0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 misc_open+0x57/0x3c0 drivers/char/misc.c:107
 chrdev_open+0x53b/0x5f0 fs/char_dev.c:414
 do_dentry_open+0x85f/0x11b0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x25fc/0x2df0 fs/namei.c:3713
 do_filp_open+0x264/0x4f0 fs/namei.c:3740
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc8e3d93e69
RSP: 002b:00007fff2cfab108 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007fc8e3d93e69
RDX: 0000000000000002 RSI: 0000000020002100 RDI: ffffffffffffff9c
RBP: 0000000000000000 R08: 00007fff2cfaab80 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000d60c
R13: 00007fff2cfab11c R14: 00007fff2cfab130 R15: 00007fff2cfab120
 </TASK>
INFO: task syz-executor145:4519 blocked for more than 144 seconds.
      Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor145 state:D stack:23816 pid:4519  ppid:3642   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5191 [inline]
 __schedule+0x8c9/0xd70 kernel/sched/core.c:6503
 schedule+0xcb/0x190 kernel/sched/core.c:6579
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6638
 __mutex_lock_common+0xe4f/0x26e0 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x17/0x20 kernel/locking/mutex.c:799
 rfkill_fop_open+0x12f/0x690 net/rfkill/core.c:1163
 misc_open+0x346/0x3c0 drivers/char/misc.c:143
 chrdev_open+0x53b/0x5f0 fs/char_dev.c:414
 do_dentry_open+0x85f/0x11b0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x25fc/0x2df0 fs/namei.c:3713
 do_filp_open+0x264/0x4f0 fs/namei.c:3740
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc8e3d93e69
RSP: 002b:00007fff2cfab108 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007fc8e3d93e69
RDX: 0000000000022002 RSI: 0000000020000080 RDI: ffffffffffffff9c
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000d64b
R13: 00007fff2cfab11c R14: 00007fff2cfab130 R15: 00007fff2cfab120
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8d327330 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x30/0xd00 kernel/rcu/tasks.h:507
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8d327b30 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x30/0xd00 kernel/rcu/tasks.h:507
1 lock held by khungtaskd/28:
 #0: ffffffff8d327160 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
2 locks held by getty/3308:
 #0: ffff888145009098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:244
 #1: ffffc900031262f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x53b/0x1650 drivers/tty/n_tty.c:2177
3 locks held by kworker/0:6/4120:
 #0: ffff888012864d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x7f2/0xdb0
 #1: ffffc90004d0fd00 ((work_completion)(&rfkill_global_led_trigger_work)){+.+.}-{0:0}, at: process_one_work+0x831/0xdb0 kernel/workqueue.c:2264
 #2: ffffffff8e787b08 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_global_led_trigger_worker+0x1b/0xf0 net/rfkill/core.c:181
2 locks held by syz-executor145/4505:
 #0: ffff88807268e100 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #0: ffff88807268e100 (&dev->mutex){....}-{3:3}, at: nfc_unregister_device+0x87/0x290 net/nfc/core.c:1165
 #1: ffffffff8e787b08 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_unregister+0xcb/0x220 net/rfkill/core.c:1130
1 lock held by syz-executor145/4514:
 #0: ffffffff8e787b08 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_release+0x49/0x230 net/rfkill/core.c:1312
2 locks held by syz-executor145/4516:
 #0: ffffffff8e787b08 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_write+0x1b3/0x790 net/rfkill/core.c:1278
 #1: ffff88807268e100 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:835 [inline]
 #1: ffff88807268e100 (&dev->mutex){....}-{3:3}, at: nfc_dev_down+0x33/0x260 net/nfc/core.c:143
1 lock held by syz-executor145/4517:
 #0: ffffffff8da8f368 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x57/0x3c0 drivers/char/misc.c:107
1 lock held by syz-executor145/4518:
 #0: ffffffff8da8f368 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x57/0x3c0 drivers/char/misc.c:107
2 locks held by syz-executor145/4519:
 #0: ffffffff8da8f368 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x57/0x3c0 drivers/char/misc.c:107
 #1: ffffffff8e787b08 (rfkill_global_mutex){+.+.}-{3:3}, at: rfkill_fop_open+0x12f/0x690 net/rfkill/core.c:1163

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 28 Comm: khungtaskd Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 nmi_cpu_backtrace+0x46f/0x4f0 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1ba/0x420 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
 watchdog+0xcf5/0xd40 kernel/hung_task.c:377
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 9 Comm: kworker/u4:0 Not tainted 6.1.0-rc5-syzkaller-00008-ge01d50cbd6ee #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:write_comp_data kernel/kcov.c:235 [inline]
RIP: 0010:__sanitizer_cov_trace_const_cmp8+0x4/0xa0 kernel/kcov.c:311
Code: f0 48 83 c8 08 48 c7 04 01 05 00 00 00 48 89 f0 48 83 c8 10 48 89 14 01 48 83 ce 18 4c 89 0c 31 4c 89 44 f9 20 c3 4c 8b 04 24 <65> 48 8b 14 25 40 6f 02 00 65 8b 0d 24 d2 77 7e f7 c1 00 01 ff 00
RSP: 0018:ffffc900000e7a78 EFLAGS: 00000246
RAX: ffffffff920114a0 RBX: 0000000000000000 RCX: ffffffff8cd12a50
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff81b5a436 R09: fffff5200001cf3d
R10: fffff5200001cf3d R11: 1ffff9200001cf3c R12: 0000000000000020
R13: ffffffff8cd12a30 R14: dffffc0000000000 R15: 1ffffffff19a254b
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f4c9bd9990 CR3: 000000000d08e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __jump_label_update+0xa6/0x3b0
 static_key_disable_cpuslocked+0xc8/0x1b0 kernel/jump_label.c:207
 static_key_disable+0x16/0x20 kernel/jump_label.c:215
 toggle_allocation_gate+0x3b8/0x450 mm/kfence/core.c:814
 process_one_work+0x877/0xdb0 kernel/workqueue.c:2289
 worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
