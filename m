Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393D230A43A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhBAJSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:18:38 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:36323 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbhBAJQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:16:55 -0500
Received: by mail-io1-f72.google.com with SMTP id f7so11332339ioz.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 01:16:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=J7T7XJfE9UhBh5HjcgKJFv0+xMfDR6bs3Go2l1l2OgQ=;
        b=SEWweGGX+UxJEMR+d/zNO4EpxQ7ENGahqxo41eRjnOl4MTpD6z4MsR/TG6IbwhNh2c
         9fol4ssvNffedbV+GpWtGrjzpQbbUPKmkD+AYBPEb06XXOi/qHWsa1SIcxdK5uiFOr6H
         NQWVWWEgvGf6ER9xHgxmBtWKY9SBxnidd3YqTF53AjxK2+9eZ8Szwc7lmInGadcYQows
         OpkgIvuY2KsymlvD51VQpkNHbGo+IQ33iEOWRKB2ARVJ6CDJAyNWDYVvSdojabj+JS+1
         Qly85KSC0mZSdof2GCXpdKSy16aet71bCi10Dtdt55sbdRWo2fW2aQTojR0C3qcdW+bF
         i8Nw==
X-Gm-Message-State: AOAM532UQFSncril/J4WED3n64LJGwrhYlc87x7K0Q0r6XW2QXXvLGl+
        zs8BOs8w1bKvP1PBl9IFeCXs2iHO3wAulK2I09KFbo3WQ8Wa
X-Google-Smtp-Source: ABdhPJwOtYqkHVZOuKX4W39+s199i7sNBidMCy8p8WqfNYPw8rSn9n/6wgiClhy40G7Fw0T9Py3xf9YtDJJJmnAg9seyhgNBaDRr
MIME-Version: 1.0
X-Received: by 2002:a6b:f107:: with SMTP id e7mr11870848iog.191.1612170972094;
 Mon, 01 Feb 2021 01:16:12 -0800 (PST)
Date:   Mon, 01 Feb 2021 01:16:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001be3ac05ba42cef9@google.com>
Subject: INFO: task hung in rsvp_delete_filter_work
From:   syzbot <syzbot+a2ec7a7fb2331091aecf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    14e8e0f6 tcp: shrink inet_connection_sock icsk_mtup enable..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=114362c4d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ac6e76902c1abb76
dashboard link: https://syzkaller.appspot.com/bug?extid=a2ec7a7fb2331091aecf
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114d33d8d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12610ac4d00000

The issue was bisected to:

commit 0fedc63fadf0404a729e73a35349481c8009c02f
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed Sep 23 03:56:24 2020 +0000

    net_sched: commit action insertions together

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1065c1d8d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1265c1d8d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1465c1d8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a2ec7a7fb2331091aecf@syzkaller.appspotmail.com
Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")

INFO: task kworker/u4:0:8 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:0    state:D stack:23440 pid:    8 ppid:     2 flags:0x00004000
Workqueue: tc_filter_workqueue rsvp_delete_filter_work
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5216
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 rsvp_delete_filter_work+0xe/0x20 net/sched/cls_rsvp.h:293
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
INFO: task kworker/0:3:3217 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:3     state:D stack:26720 pid: 3217 ppid:     2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5216
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4572
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
3 locks held by kworker/u4:0/8:
 #0: ffff88814156a938 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88814156a938 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88814156a938 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88814156a938 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88814156a938 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88814156a938 ((wq_completion)tc_filter_workqueue){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc90000cd7da8 ((work_completion)(&(rwork)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffffffff8ca5a488 (rtnl_mutex){+.+.}-{3:3}, at: rsvp_delete_filter_work+0xe/0x20 net/sched/cls_rsvp.h:293
1 lock held by khungtaskd/1659:
 #0: ffffffff8b373d20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6259
3 locks held by kworker/0:3/3217:
 #0: ffff8881472c5138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881472c5138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881472c5138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881472c5138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881472c5138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881472c5138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc90001e1fda8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffffffff8ca5a488 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4572
1 lock held by in:imklog/8196:
 #0: ffff888012330370 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:947
1 lock held by syz-executor200/8491:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1659 Comm: khungtaskd Not tainted 5.11.0-rc5-syzkaller #0
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8491 Comm: syz-executor200 Not tainted 5.11.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:match_held_lock+0x0/0x150 kernel/locking/lockdep.c:4891
Code: cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 48 8b 34 24 48 c7 c7 c0 25 4a 89 e8 b8 2a bf ff cc cc cc cc cc cc cc cc cc cc cc <48> 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48 83 ec 08
RSP: 0018:ffffc9000197ecd8 EFLAGS: 00000002
RAX: 0000000000000005 RBX: 0000000000000002 RCX: ffffc9000197ed68
RDX: 0000000000000002 RSI: ffff8880212a6c68 RDI: ffff888022122570
RBP: 1ffff9200032fda5 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888022122570
R13: ffff8880212a6c68 R14: ffffc9000197ed68 R15: 0000000000000001
FS:  0000000001643880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 0000000020ad5000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 find_held_lock+0x2d/0x110 kernel/locking/lockdep.c:4935
 __lock_release kernel/locking/lockdep.c:5119 [inline]
 lock_release+0x1f2/0x710 kernel/locking/lockdep.c:5462
 __mutex_unlock_slowpath+0x81/0x610 kernel/locking/mutex.c:1228
 tcf_idr_check_alloc+0x29e/0x3b0 net/sched/act_api.c:556
 tcf_police_init+0x34f/0x1460 net/sched/act_police.c:81
 tcf_action_init_1+0x103/0x640 net/sched/act_api.c:1026
 tcf_exts_validate+0x1d7/0x540 net/sched/cls_api.c:3051
 rsvp_change+0x291/0x2990 net/sched/cls_rsvp.h:502
 tc_new_tfilter+0x1394/0x2120 net/sched/cls_api.c:2127
 rtnetlink_rcv_msg+0x80e/0xad0 net/core/rtnetlink.c:5544
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4417b9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd5ed328c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004417b9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000006
RBP: 0000000000076ec0 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000402560
R13: 00000000004025f0 R14: 0000000000000000 R15: 0000000000000000
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.607 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
