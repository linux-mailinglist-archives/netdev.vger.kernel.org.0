Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0343E9E51
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 08:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhHLGNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 02:13:47 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55002 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhHLGNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 02:13:46 -0400
Received: by mail-io1-f72.google.com with SMTP id 81-20020a6b02540000b02905824a68848bso2848492ioc.21
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 23:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DYL1J+oy4oDNfBwuAE6KH58xhAFOH+PfBaJADfwuBSo=;
        b=P/J0G5f1Gmwg0HaAif2+1/crdPExqoLw11ug8RzU9QAd+aINjvJr+sPUf2YdCmbxrV
         ptPnuVdBPT5rc7jbsCoDWP7cX1RSoWKvjjEbKej75sAaRVIfEWgeCF8J7WunPM0Vzc29
         ojxw1Y2fHmtXlnobcxlwWPEpCyxaZhZVAo6pyESsEVhQWz3efLH1sLNjjEYii0X6UOcU
         BFQLu0li0BvE7qX4ja0kUdTQbOtZA0VU7leCDKpz4GKmdF/g/75WXWK5UxQYLh5j5Up6
         jV0OD50cs3s/4GfY9H4D2qbh/nvbfMP4x7uRIymF+LKNKOs5Ro5eIKkqTIJzMBZ2USv6
         UI4g==
X-Gm-Message-State: AOAM5310Rjw+xquyAycoC1SxxMlaU58zf5PuAMByB7FlG0VCF6pGajnB
        fPwlz6M0awAJ27vgOmJnaeymXmzCgrqKDpdSZwZGZeSNAN3R
X-Google-Smtp-Source: ABdhPJx29JmgnSj90+sgKDtBiuaIDX86xQPzbZV35OvVkv5qo14IzLyzCUCWmDrDPgPPfalGc0k4BcPMwjxlJEG29GePaKjMgL/g
MIME-Version: 1.0
X-Received: by 2002:a5d:9c58:: with SMTP id 24mr1800988iof.120.1628748801983;
 Wed, 11 Aug 2021 23:13:21 -0700 (PDT)
Date:   Wed, 11 Aug 2021 23:13:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c5482805c956a118@google.com>
Subject: [syzbot] INFO: task hung in hci_req_sync
From:   syzbot <syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c9194f32bfd9 Merge tag 'ext4_for_linus_stable' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1488f59e300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=be2baed593ea56c6a84c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b5afc6300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fcd192300000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17dce4fa300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=143ce4fa300000
console output: https://syzkaller.appspot.com/x/log.txt?x=103ce4fa300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com

INFO: task syz-executor446:8489 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor446 state:D stack:28712 pid: 8489 ppid:  8452 flags:0x00000000
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
 hci_inquiry+0x6f4/0x9e0 net/bluetooth/hci_core.c:1357
 hci_sock_ioctl+0x1a7/0x910 net/bluetooth/hci_sock.c:1060
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
 sock_ioctl+0x477/0x6a0 net/socket.c:1221
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x446449
RSP: 002b:00007f36ab8342e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004cb400 RCX: 0000000000446449
RDX: 00000000200000c0 RSI: 00000000800448f0 RDI: 0000000000000004
RBP: 00000000004cb40c R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000004 R14: 00007f36ab8346b8 R15: 00000000004cb408
INFO: task syz-executor446:8491 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor446 state:D stack:28176 pid: 8491 ppid:  8452 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
 hci_inquiry+0x6f4/0x9e0 net/bluetooth/hci_core.c:1357
 hci_sock_ioctl+0x1a7/0x910 net/bluetooth/hci_sock.c:1060
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1094
 sock_ioctl+0x477/0x6a0 net/socket.c:1221
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x446449
RSP: 002b:00007f36ab8342e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004cb400 RCX: 0000000000446449
RDX: 00000000200000c0 RSI: 00000000800448f0 RDI: 0000000000000004
RBP: 00000000004cb40c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000004 R14: 00007f36ab8346b8 R15: 00000000004cb408

Showing all locks held in the system:
6 locks held by kworker/u4:0/8:
1 lock held by khungtaskd/1635:
 #0: ffffffff8b97c180 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by in:imklog/8352:
 #0: ffff888033e1d4f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
1 lock held by syz-executor446/8486:
 #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
1 lock held by syz-executor446/8489:
 #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276
1 lock held by syz-executor446/8491:
 #0: ffff8880349c4ff0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_req_sync+0x33/0xd0 net/bluetooth/hci_request.c:276

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1635 Comm: khungtaskd Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xd0a/0xfc0 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8 Comm: kworker/u4:0 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:csd_lock_wait kernel/smp.c:440 [inline]
RIP: 0010:smp_call_function_many_cond+0x452/0xc20 kernel/smp.c:967
Code: 0b 00 85 ed 74 4d 48 b8 00 00 00 00 00 fc ff df 4d 89 f4 4c 89 f5 49 c1 ec 03 83 e5 07 49 01 c4 83 c5 03 e8 d0 47 0b 00 f3 90 <41> 0f b6 04 24 40 38 c5 7c 08 84 c0 0f 85 33 06 00 00 8b 43 08 31
RSP: 0018:ffffc90000cd7a00 EFLAGS: 00000293
RAX: 0000000000000000 RBX: ffff8880b9d570c0 RCX: 0000000000000000
RDX: ffff88813fe6d4c0 RSI: ffffffff816a6400 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff816a6426 R11: 0000000000000000 R12: ffffed10173aae19
R13: 0000000000000001 R14: ffff8880b9d570c8 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f56e8f43000 CR3: 000000000b68e000 CR4: 0000000000350ef0
Call Trace:
 on_each_cpu_cond_mask+0x56/0xa0 kernel/smp.c:1133
 on_each_cpu include/linux/smp.h:71 [inline]
 text_poke_sync arch/x86/kernel/alternative.c:929 [inline]
 text_poke_bp_batch+0x47d/0x560 arch/x86/kernel/alternative.c:1183
 text_poke_flush arch/x86/kernel/alternative.c:1268 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1265 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1275
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:146
 jump_label_update+0x1d5/0x430 kernel/jump_label.c:830
 static_key_enable_cpuslocked+0x1b1/0x260 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate mm/kfence/core.c:623 [inline]
 toggle_allocation_gate+0x100/0x390 mm/kfence/core.c:615
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
