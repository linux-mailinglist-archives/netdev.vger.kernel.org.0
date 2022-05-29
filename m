Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1566536FD9
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 08:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiE2Fz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 01:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiE2FzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 01:55:25 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5193462139
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 22:55:23 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id j5-20020a922005000000b002d1c2659644so5920320ile.8
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 22:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2THofbMjmyuoo5sodONiinlu0c+1Y5g183/8XLnwBQ8=;
        b=CnqCtLVQObAIImRaHcnKmhkqiVEK9GO5et1Ss/Jr+ezKUDBf4sKpSLtlHItO4iGPY6
         Xkhf6KiZr5ZUEljecjAZWzEtncW9qIQhW/DBpENszYCEb/WWIW31is3i9BAgRbOxUAVg
         krZJ6UDqaGsnsda32UbBFHTxLWX4C2VrhaQcJMgSLS35qGPcao9lxIqYGa0BGyy0G++m
         vH/qEE+I6rji8Hk8H91LUlGnZhcEueyQRjTzdtHzyPUqexfqJsrbfw6vpR67fXvnU9ru
         dCR3Bttvb49EwwtJOvNrlwV1x+xBH8vyPgbIVOaQfM7b1/i2ltyogmIVQNxhU/L3qRE1
         KBDg==
X-Gm-Message-State: AOAM531RqviciizKzq2argOeJSYm2mgXmzj7yOasPrNZe7IU73kiGgnI
        PK1isqgPsxytsmqnPvZSK2PlbTUn13NA4CvItuzAC4kTw/Ks
X-Google-Smtp-Source: ABdhPJwAWrCSzU/aY+Y7DewhaEWv0bRRSBRPR1q/ztMhd4lTUW/KOAfksNq1fE9VLkWbfYIarsF632wGile3bjI3LrtJmyV/HO6W
MIME-Version: 1.0
X-Received: by 2002:a05:6602:80a:b0:665:7139:4c4b with SMTP id
 z10-20020a056602080a00b0066571394c4bmr12468885iow.134.1653803722262; Sat, 28
 May 2022 22:55:22 -0700 (PDT)
Date:   Sat, 28 May 2022 22:55:22 -0700
In-Reply-To: <000000000000d59b7105de1e6d3a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064cf4505e0202fe7@google.com>
Subject: Re: [syzbot] INFO: task hung in hci_dev_close_sync
From:   syzbot <syzbot+c56f6371c48cad0420f9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        hdanton@sina.com, johan.hedberg@gmail.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, luiz.dentz@gmail.com, marcel@holtmann.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        penguin-kernel@I-love.SAKURA.ne.jp,
        syzkaller-bugs@googlegroups.com, tj@kernel.org
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    9d004b2f4fea Merge tag 'cxl-for-5.19' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12fe6d23f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d5ef46f0e355ceff
dashboard link: https://syzkaller.appspot.com/bug?extid=c56f6371c48cad0420f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c258f5f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144f1233f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c56f6371c48cad0420f9@syzkaller.appspotmail.com

INFO: task kworker/u5:1:3610 blocked for more than 143 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:1    state:D stack:27304 pid: 3610 ppid:     2 flags:0x00004000
Workqueue: hci9 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0xa00/0x4b30 kernel/sched/core.c:6431
 schedule+0xd2/0x1f0 kernel/sched/core.c:6503
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1911
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3075
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4091
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_power_on+0x1c0/0x630 net/bluetooth/hci_core.c:981
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>
INFO: task kworker/u5:3:3617 blocked for more than 144 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:3    state:D stack:27568 pid: 3617 ppid:     2 flags:0x00004000
Workqueue: hci8 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0xa00/0x4b30 kernel/sched/core.c:6431
 schedule+0xd2/0x1f0 kernel/sched/core.c:6503
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1911
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3075
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4091
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_power_on+0x1c0/0x630 net/bluetooth/hci_core.c:981
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>
INFO: task kworker/u5:4:3619 blocked for more than 144 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u5:4    state:D stack:27192 pid: 3619 ppid:     2 flags:0x00004000
Workqueue: hci7 hci_power_on
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0xa00/0x4b30 kernel/sched/core.c:6431
 schedule+0xd2/0x1f0 kernel/sched/core.c:6503
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1911
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 __flush_work+0x56c/0xb10 kernel/workqueue.c:3075
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
 hci_dev_close_sync+0x8d/0x1150 net/bluetooth/hci_sync.c:4091
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_power_on+0x1c0/0x630 net/bluetooth/hci_core.c:981
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>
INFO: task syz-executor921:3700 blocked for more than 145 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor921 state:D stack:27944 pid: 3700 ppid:  3603 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0xa00/0x4b30 kernel/sched/core.c:6431
 schedule+0xd2/0x1f0 kernel/sched/core.c:6503
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1911
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 flush_workqueue+0x3ed/0x13a0 kernel/workqueue.c:2861
 hci_dev_open+0xdb/0x300 net/bluetooth/hci_core.c:526
 hci_sock_ioctl+0x62c/0x910 net/bluetooth/hci_sock.c:1027
 sock_do_ioctl+0xcc/0x230 net/socket.c:1169
 sock_ioctl+0x2f1/0x640 net/socket.c:1286
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f595e7f37e7
RSP: 002b:00007ffc76721138 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f595e7f37e7
RDX: 0000000000000009 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 0000000000000004 R08: 00007f595e7a0700 R09: 00007f595e7a0700
R10: 00007f595e7a09d0 R11: 0000000000000246 R12: 6c616b7a79732f2e
R13: 585858582e72656c R14: 00007ffc76721164 R15: 00007ffc767211a0
 </TASK>
INFO: task syz-executor921:3701 blocked for more than 145 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor921 state:D stack:27944 pid: 3701 ppid:  3603 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0xa00/0x4b30 kernel/sched/core.c:6431
 schedule+0xd2/0x1f0 kernel/sched/core.c:6503
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1911
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 flush_workqueue+0x3ed/0x13a0 kernel/workqueue.c:2861
 hci_dev_open+0xdb/0x300 net/bluetooth/hci_core.c:526
 hci_sock_ioctl+0x62c/0x910 net/bluetooth/hci_sock.c:1027
 sock_do_ioctl+0xcc/0x230 net/socket.c:1169
 sock_ioctl+0x2f1/0x640 net/socket.c:1286
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f595e7f37e7
RSP: 002b:00007ffc76721138 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f595e7f37e7
RDX: 0000000000000007 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 0000000000000004 R08: 00007f595e7a0700 R09: 00007f595e7a0700
R10: 00007f595e7a09d0 R11: 0000000000000246 R12: 6c616b7a79732f2e
R13: 585858582e72656c R14: 00007ffc76721164 R15: 00007ffc767211a0
 </TASK>
INFO: task syz-executor921:3702 blocked for more than 145 seconds.
      Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor921 state:D stack:26648 pid: 3702 ppid:  3603 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5116 [inline]
 __schedule+0xa00/0x4b30 kernel/sched/core.c:6431
 schedule+0xd2/0x1f0 kernel/sched/core.c:6503
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1911
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common+0x378/0x530 kernel/sched/completion.c:106
 flush_workqueue+0x3ed/0x13a0 kernel/workqueue.c:2861
 hci_dev_open+0xdb/0x300 net/bluetooth/hci_core.c:526
 hci_sock_ioctl+0x62c/0x910 net/bluetooth/hci_sock.c:1027
 sock_do_ioctl+0xcc/0x230 net/socket.c:1169
 sock_ioctl+0x2f1/0x640 net/socket.c:1286
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f595e7f37e7
RSP: 002b:00007ffc76721138 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f595e7f37e7
RDX: 0000000000000008 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 0000000000000004 R08: 00007f595e7a0700 R09: 00007f595e7a0700
R10: 00007f595e7a09d0 R11: 0000000000000246 R12: 6c616b7a79732f2e
R13: 585858582e72656c R14: 00007ffc76721164 R15: 00007ffc767211a0
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/29:
 #0: ffffffff8bd86860 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6491
2 locks held by getty/3285:
 #0: ffff88814c09b098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc90002cd62e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcea/0x1230 drivers/tty/n_tty.c:2075
2 locks held by sshd/3597:
3 locks held by kworker/u5:1/3610:
 #0: ffff88807898c138 ((wq_completion)hci9){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88807898c138 ((wq_completion)hci9){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88807898c138 ((wq_completion)hci9){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff88807898c138 ((wq_completion)hci9){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff88807898c138 ((wq_completion)hci9){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff88807898c138 ((wq_completion)hci9){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc9000302fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff88801a3f9048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551
3 locks held by kworker/u5:3/3617:
 #0: ffff888076411138 ((wq_completion)hci8){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888076411138 ((wq_completion)hci8){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888076411138 ((wq_completion)hci8){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888076411138 ((wq_completion)hci8){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888076411138 ((wq_completion)hci8){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888076411138 ((wq_completion)hci8){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc9000312fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff88807421d048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551
3 locks held by kworker/u5:4/3619:
 #0: ffff888076414138 ((wq_completion)hci7){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888076414138 ((wq_completion)hci7){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888076414138 ((wq_completion)hci7){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888076414138 ((wq_completion)hci7){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888076414138 ((wq_completion)hci7){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888076414138 ((wq_completion)hci7){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc9000315fda8 ((work_completion)(&hdev->power_on)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff888074219048 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x2a/0x70 net/bluetooth/hci_core.c:551

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 29 Comm: khungtaskd Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
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
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3599 Comm: strace-static-x Not tainted 5.18.0-syzkaller-10643-g9d004b2f4fea #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:129 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:159 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0x55/0x180 mm/kasan/generic.c:189
Code: 86 05 01 00 00 49 83 e9 01 48 89 fd 48 b8 00 00 00 00 00 fc ff df 4d 89 ca 48 c1 ed 03 49 c1 ea 03 48 01 c5 49 01 c2 48 89 e8 <49> 8d 5a 01 48 89 da 48 29 ea 48 83 fa 10 7e 63 41 89 eb 41 83 e3
RSP: 0018:ffffc90002eff9c8 EFLAGS: 00000082
RAX: fffffbfff1b77492 RBX: 0000000000000000 RCX: ffffffff815e5141
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8dbba490
RBP: fffffbfff1b77492 R08: 0000000000000000 R09: ffffffff8dbba497
R10: fffffbfff1b77492 R11: 0000000000000000 R12: ffff8880b9c39ed8
R13: ffff8880b9c39ec0 R14: ffff88802525a298 R15: ffff888025259d80
FS:  0000000000757340(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555566c1608 CR3: 0000000073fd2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
 cpumask_test_cpu include/linux/cpumask.h:379 [inline]
 cpu_online include/linux/cpumask.h:921 [inline]
 trace_lock_release include/trace/events/lock.h:69 [inline]
 lock_release+0xa1/0x780 kernel/locking/lockdep.c:5676
 prepare_lock_switch kernel/sched/core.c:4860 [inline]
 context_switch kernel/sched/core.c:5113 [inline]
 __schedule+0x9cd/0x4b30 kernel/sched/core.c:6431
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6596
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 try_to_wake_up+0xa04/0x1800 kernel/sched/core.c:4201
 ptrace_resume+0x27d/0x2d0 kernel/ptrace.c:895
 ptrace_request+0x180/0xef0 kernel/ptrace.c:1230
 arch_ptrace+0x36/0x510 arch/x86/kernel/ptrace.c:828
 __do_sys_ptrace kernel/ptrace.c:1321 [inline]
 __se_sys_ptrace kernel/ptrace.c:1286 [inline]
 __x64_sys_ptrace+0x178/0x310 kernel/ptrace.c:1286
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x4e6c1a
Code: Unable to access opcode bytes at RIP 0x4e6bf0.
RSP: 002b:00007ffdb7543730 EFLAGS: 00000206 ORIG_RAX: 0000000000000065
RAX: ffffffffffffffda RBX: 00000000007572f8 RCX: 00000000004e6c1a
RDX: 0000000000000000 RSI: 0000000000000e2e RDI: 0000000000000018
RBP: 0000000000000018 R08: 0000000000000017 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000759380
R13: 0000000000000000 R14: 000000000000857f R15: 0000000000617180
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.132 msecs
----------------
Code disassembly (best guess):
   0:	86 05 01 00 00 49    	xchg   %al,0x49000001(%rip)        # 0x49000007
   6:	83 e9 01             	sub    $0x1,%ecx
   9:	48 89 fd             	mov    %rdi,%rbp
   c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  13:	fc ff df
  16:	4d 89 ca             	mov    %r9,%r10
  19:	48 c1 ed 03          	shr    $0x3,%rbp
  1d:	49 c1 ea 03          	shr    $0x3,%r10
  21:	48 01 c5             	add    %rax,%rbp
  24:	49 01 c2             	add    %rax,%r10
  27:	48 89 e8             	mov    %rbp,%rax
* 2a:	49 8d 5a 01          	lea    0x1(%r10),%rbx <-- trapping instruction
  2e:	48 89 da             	mov    %rbx,%rdx
  31:	48 29 ea             	sub    %rbp,%rdx
  34:	48 83 fa 10          	cmp    $0x10,%rdx
  38:	7e 63                	jle    0x9d
  3a:	41 89 eb             	mov    %ebp,%r11d
  3d:	41                   	rex.B
  3e:	83                   	.byte 0x83
  3f:	e3                   	.byte 0xe3

