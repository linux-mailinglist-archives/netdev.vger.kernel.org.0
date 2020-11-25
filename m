Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881132C35D0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgKYAzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:55:21 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:38245 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgKYAzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 19:55:20 -0500
Received: by mail-il1-f197.google.com with SMTP id j7so533315ils.5
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 16:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yEpxpviWeJUabatQl1cltLq8Z8zQA4yZKvJug/Nr3PQ=;
        b=Lrs+hWdmM8zp/JeGi2NcVtasWW5dQB0ODMYJu1Zl+8Tk5dC8MexqF3knxStTTPiFjv
         qMAiyd1c+9SasiUfiL3mFn9H35OfMb3CFI4/pLdynFe0BipucDtPW8aCTK1ojrPDA7IX
         /iRLtlejrZ41EeKIFInxXlTtoUflZFdlQxWxQMpT0S8+x+/KmlUI8bGDfkDFG9rkA50y
         yvlIUMpzLz0zf1uGIyqUXUWbXyK+KqN79RrhQcUXK4p0XDS24H6JLnIGxiUT378zgIA5
         gPiT26G69ERFc+GNj8fJgMP/Q5RYbjtC8A3+v8nDmQ+8q+uEZPA5lNb75zD1VYag63yP
         aZzA==
X-Gm-Message-State: AOAM533n35vVo6yCzZikRUZXOs6SnTVMLv0PjC2+k3zk19G77ScijxBv
        +dA1a3hFthFfAgjO9oj3X+r0rMRFT0lT5n+43P20NMc9eoud
X-Google-Smtp-Source: ABdhPJzwHxFB2X3cZziB3Q1yf7/6XuH1EIuGUBo288a1Jap404mDaQMGI0obqcAEXo0PWuNF6ACbAIXzLjK2686AhnJ1t2LkYU8E
MIME-Version: 1.0
X-Received: by 2002:a6b:fd0c:: with SMTP id c12mr780328ioi.107.1606265718300;
 Tue, 24 Nov 2020 16:55:18 -0800 (PST)
Date:   Tue, 24 Nov 2020 16:55:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008de34305b4e3e146@google.com>
Subject: INFO: task hung in addrconf_verify_work (4)
From:   syzbot <syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4d02da97 Merge tag 'net-5.10-rc5' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17253696500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=330f3436df12fd44
dashboard link: https://syzkaller.appspot.com/bug?extid=ba67b12b1ca729912834
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15577dc1500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1138574d500000

The issue was bisected to:

commit 0fedc63fadf0404a729e73a35349481c8009c02f
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed Sep 23 03:56:24 2020 +0000

    net_sched: commit action insertions together

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f3c351500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=100bc351500000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f3c351500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com
Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")

INFO: task kworker/0:1:8444 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:1     state:D stack:29768 pid: 8444 ppid:     2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
 context_switch kernel/sched/core.c:3774 [inline]
 __schedule+0x893/0x2130 kernel/sched/core.c:4523
 schedule+0xcf/0x270 kernel/sched/core.c:4601
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4660
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4568
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
1 lock held by khungtaskd/1655:
 #0: ffffffff8b337820 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6252
1 lock held by in:imklog/8146:
 #0: ffff88801ef9aaf0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932
3 locks held by kworker/0:1/8444:
 #0: ffff888147a41538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888147a41538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888147a41538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888147a41538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888147a41538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888147a41538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90000e9fda8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffffffff8c928588 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4568
2 locks held by syz-executor297/8473:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1655 Comm: khungtaskd Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd43/0xfa0 kernel/hung_task.c:294
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 8473 Comm: syz-executor297 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:lock_is_held_type+0xc2/0x100 kernel/locking/lockdep.c:5479
Code: 03 44 39 f0 41 0f 94 c4 48 c7 c7 c0 5e 4b 89 e8 d4 0b 00 00 b8 ff ff ff ff 65 0f c1 05 57 67 1c 77 83 f8 01 75 23 ff 34 24 9d <48> 83 c4 08 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 45 31 e4 eb
RSP: 0018:ffffc900016beb50 EFLAGS: 00000202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 1ffffffff19d9d4b
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff8b337760 R08: ffffffff87119fb8 R09: ffff888021809207
R10: ffffed1004301240 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801487a350 R14: 00000000ffffffff R15: ffff88801487a350
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0063) knlGS:000000000989d840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00007f691c03f0f8 CR3: 00000000112cc000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_is_held include/linux/lockdep.h:271 [inline]
 ___might_sleep+0x236/0x2b0 kernel/sched/core.c:7264
 __mutex_lock_common kernel/locking/mutex.c:935 [inline]
 __mutex_lock+0xa9/0x10e0 kernel/locking/mutex.c:1103
 tcf_idr_check_alloc+0x78/0x3b0 net/sched/act_api.c:501
 tcf_police_init+0x347/0x13a0 net/sched/act_police.c:81
 tcf_action_init_1+0x1a3/0x990 net/sched/act_api.c:993
 tcf_exts_validate+0x138/0x420 net/sched/cls_api.c:3058
 rsvp_change+0x291/0x27a0 net/sched/cls_rsvp.h:502
 tc_new_tfilter+0x1398/0x2130 net/sched/cls_api.c:2129
 rtnetlink_rcv_msg+0x80e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x292/0x470 net/socket.c:2490
 __compat_sys_sendmmsg net/compat.c:361 [inline]
 __do_compat_sys_sendmmsg net/compat.c:368 [inline]
 __se_compat_sys_sendmmsg net/compat.c:365 [inline]
 __ia32_compat_sys_sendmmsg+0x9b/0x100 net/compat.c:365
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7ff3549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ff8a4b4c EFLAGS: 00000296 ORIG_RAX: 0000000000000159
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000200
RDX: 00000000924926d3 RSI: 0000000000000000 RDI: 0000000000000010
RBP: 0000000000080002 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.398 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
