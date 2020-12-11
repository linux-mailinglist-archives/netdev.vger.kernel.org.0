Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7632D6E1D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391165AbgLKC0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 21:26:10 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56059 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390294AbgLKCZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 21:25:53 -0500
Received: by mail-io1-f69.google.com with SMTP id j25so5446165iog.22
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 18:25:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ss5rnVicPosSBdYzSy+UMj22SrH9QgFUN/iCK5u2C0s=;
        b=XEgavJgbpFgp7utaHPWh7ci1YDRpmqmj874jVyaRhwEhtXUgk+b8FoaTsj5TMZuH12
         2ZBb7twxiu0ls1DP69n/XsTbWJkWYqEp3Y292pTa8iT9P7OQ6f2tRPAJ1d9ULXZkf4CS
         Bq19VfCrtLAhhT/LqUWLuaJNxgcKu7zxyR/Ep52P0gzBrezSf2HI96I30iHRcaJMmbji
         /b1GNKHLYb1YV/w88q68NuaFj7c8ppDgw9P67eQIap1dwfdOnDlYd4Ge6uvzEt7tKGPy
         VlPNXmRfGi+vfN7dFPUxAv2sgQpvo+fTzRLJfGCn2+xjY2GYAfX7iQd2Me5rlxsdf3l9
         kFgQ==
X-Gm-Message-State: AOAM532lPF0C8sHLJ9kgr8Vio43widAVHqh692B4eS+/EcBdyicXmF+/
        +MyfWIQIehNxdBFELVqu4ouyYlRejUkzDABdgWgAkWh+y1yx
X-Google-Smtp-Source: ABdhPJyoM4NXcBUADfRqaRwmtaqAdriQJrYdwsszXSuOCYC9wjE/Wv3OGgRMh23YriJgyw59FTOf7iTj/vDAJj/WjcChZPwxsW2D
MIME-Version: 1.0
X-Received: by 2002:a5e:9612:: with SMTP id a18mr12033491ioq.13.1607653511707;
 Thu, 10 Dec 2020 18:25:11 -0800 (PST)
Date:   Thu, 10 Dec 2020 18:25:11 -0800
In-Reply-To: <0000000000001779fd05a46b001f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007cc08305b62700a3@google.com>
Subject: Re: INFO: task hung in linkwatch_event (2)
From:   syzbot <syzbot+96ff6cfc4551fcc29342@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andrew@lunn.ch, aviad.krawczyk@huawei.com,
        axboe@kernel.dk, davem@davemloft.net, gregkh@linuxfoundation.org,
        hdanton@sina.com, io-uring@vger.kernel.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linyunsheng@huawei.com, luobin9@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a7105e34 Merge branch 'hns3-next'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=155af80f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ac2dabe250b3a58
dashboard link: https://syzkaller.appspot.com/bug?extid=96ff6cfc4551fcc29342
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bc7b13500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1674046b500000

The issue was bisected to:

commit 386d4716fd91869e07c731657f2cde5a33086516
Author: Luo bin <luobin9@huawei.com>
Date:   Thu Feb 27 06:34:44 2020 +0000

    hinic: fix a bug of rss configuration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16626fcfe00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15626fcfe00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11626fcfe00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+96ff6cfc4551fcc29342@syzkaller.appspotmail.com
Fixes: 386d4716fd91 ("hinic: fix a bug of rss configuration")

INFO: task kworker/0:2:3004 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:2     state:D stack:28448 pid: 3004 ppid:     2 flags:0x00004000
Workqueue: events linkwatch_event
Call Trace:
 context_switch kernel/sched/core.c:3779 [inline]
 __schedule+0x893/0x2130 kernel/sched/core.c:4528
 schedule+0xcf/0x270 kernel/sched/core.c:4606
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4665
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 linkwatch_event+0xb/0x60 net/core/link_watch.c:250
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
INFO: task kworker/0:0:8837 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:0     state:D stack:29768 pid: 8837 ppid:     2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
 context_switch kernel/sched/core.c:3779 [inline]
 __schedule+0x893/0x2130 kernel/sched/core.c:4528
 schedule+0xcf/0x270 kernel/sched/core.c:4606
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4665
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4569
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
1 lock held by khungtaskd/1655:
 #0: ffffffff8b337a20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6254
3 locks held by kworker/0:2/3004:
 #0: ffff888010064d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010064d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010064d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010064d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90001dafda8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffffffff8c92d448 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
1 lock held by in:imklog/8186:
 #0: ffff888017c900f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932
2 locks held by syz-executor047/8830:
3 locks held by kworker/0:0/8837:
 #0: ffff888147499138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888147499138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888147499138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888147499138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888147499138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888147499138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90001aefda8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffffffff8c92d448 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4569

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1655 Comm: khungtaskd Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd43/0xfa0 kernel/hung_task.c:294
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8830 Comm: syz-executor047 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__this_cpu_preempt_check+0x0/0x20 lib/smp_processor_id.c:64
Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 c7 c6 00 ae 9d 89 48 c7 c7 40 ae 9d 89 e9 b8 fe ff ff 0f 1f 84 00 00 00 00 00 <55> 48 89 fd 0f 1f 44 00 00 48 89 ee 5d 48 c7 c7 80 ae 9d 89 e9 97
RSP: 0018:ffffc90001a2eb50 EFLAGS: 00000082
RAX: 0000000000000001 RBX: 1ffff92000345d6d RCX: 0000000000000001
RDX: 1ffff11002f507b2 RSI: 0000000000000008 RDI: ffffffff894b60c0
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff8ebb6727
R10: fffffbfff1d76ce4 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801433fa68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fc7c7ab9700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc7c7a97e78 CR3: 000000001292b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lockdep_recursion_finish kernel/locking/lockdep.c:437 [inline]
 lock_acquire kernel/locking/lockdep.c:5439 [inline]
 lock_acquire+0x2ad/0x740 kernel/locking/lockdep.c:5402
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x134/0x10e0 kernel/locking/mutex.c:1103
 tcf_idr_check_alloc+0x78/0x3b0 net/sched/act_api.c:549
 tcf_police_init+0x347/0x13a0 net/sched/act_police.c:81
 tcf_action_init_1+0x1a3/0x990 net/sched/act_api.c:1013
 tcf_exts_validate+0x138/0x420 net/sched/cls_api.c:3046
 cls_bpf_set_parms net/sched/cls_bpf.c:422 [inline]
 cls_bpf_change+0x60b/0x1b80 net/sched/cls_bpf.c:506
 tc_new_tfilter+0x1394/0x2120 net/sched/cls_api.c:2127
 rtnetlink_rcv_msg+0x80e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2331
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2385
 __sys_sendmmsg+0x195/0x470 net/socket.c:2475
 __do_sys_sendmmsg net/socket.c:2504 [inline]
 __se_sys_sendmmsg net/socket.c:2501 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2501
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447219
Code: e8 bc b4 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc7c7ab8d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000006dcc88 RCX: 0000000000447219
RDX: 010efe10675dec16 RSI: 0000000020000200 RDI: 0000000000000004
RBP: 00000000006dcc80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc8c
R13: 0000000000000000 R14: 0000000000000000 R15: 0507002400000074

