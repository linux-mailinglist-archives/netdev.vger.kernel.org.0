Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E3F2152A1
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgGFGV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:21:26 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41126 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728084AbgGFGVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:21:25 -0400
Received: by mail-io1-f71.google.com with SMTP id n3so22877305iob.8
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 23:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EQkDFTHTTjXsPGhKEU+KB0rjXngc4+gf8gFnOkxzCAQ=;
        b=Lh/0KzFoojgDz4gDX7zXEjTeoMn3BhScVWBrucNVNQQgUE01eX9wG5J01n8IfsBLEf
         P/kgBXiTWwnkjrXAXuaKbjTTtnVOfeOEDA+96ousuTPWcDByv2oMJgPgX4QjQHnRoZ0K
         VhYTtSvyI5BUyedj+a8k2urLwWEzIkWfW+wT/wxWVW7tqNhDcS8a0hzZXe5vjCi2Hxop
         JmTX5Bn7kBN8JnymegNG12dJp+49iHWDJnm8vgoQg9iybmnKmbITpQxfXZ4nUFiIF0dK
         i8lrjNZw0ME7rEVwlDg/6ZGpEdzqP4S9j+f02UOFYNikrEwsfXMMberLk+6log6RsoW5
         Jy7g==
X-Gm-Message-State: AOAM531zb8P/FcKlzTWTa0pItOKzYXclRR+nfmsPQboknFopdfZbOC+e
        bG86RSL0qGh+Xtqi1s9yEQGI4/EdCeNRuxvUz88AaU2RE0Js
X-Google-Smtp-Source: ABdhPJxFtheZLVpNrUwMILiDRSDL/9w9UfnCD9soBJtvkKivnZRcfd1/tiOj5UnV+AtyaiAmrlqB9vdhymQB3OFznvmzquMv/Ysy
MIME-Version: 1.0
X-Received: by 2002:a02:b714:: with SMTP id g20mr43988173jam.117.1594016484552;
 Sun, 05 Jul 2020 23:21:24 -0700 (PDT)
Date:   Sun, 05 Jul 2020 23:21:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053f40205a9bfe2d7@google.com>
Subject: INFO: task hung in gate_exit_net
From:   syzbot <syzbot+9353377c27f046c26c0c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2b04a661 Merge branch 'cxgb4-add-mirror-action-support-for..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12d9b86b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2172f4d0dbc37e27
dashboard link: https://syzkaller.appspot.com/bug?extid=9353377c27f046c26c0c
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9353377c27f046c26c0c@syzkaller.appspotmail.com

INFO: task syz-executor.4:11446 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D27472 11446   9626 0x00004006
Call Trace:
 context_switch kernel/sched/core.c:3430 [inline]
 __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4155
 schedule+0xd0/0x2a0 kernel/sched/core.c:4230
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4289
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 tc_action_net_exit include/net/act_api.h:147 [inline]
 gate_exit_net+0x22/0x360 net/sched/act_gate.c:627
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 setup_net+0x502/0x850 net/core/net_namespace.c:364
 copy_net_ns+0x2cf/0x5e0 net/core/net_namespace.c:482
 create_new_namespaces+0x3f6/0xb10 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:231
 ksys_unshare+0x36c/0x9a0 kernel/fork.c:2983
 __do_sys_unshare kernel/fork.c:3051 [inline]
 __se_sys_unshare kernel/fork.c:3049 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3049
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007f52fca15c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000000050ba20 RCX: 000000000045cb29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000c8f R14: 00000000004ceebe R15: 00007f52fca166d4
INFO: task syz-executor.4:11449 blocked for more than 143 seconds.
      Not tainted 5.8.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D27472 11449   9626 0x00004006
Call Trace:
 context_switch kernel/sched/core.c:3430 [inline]
 __schedule+0x8e1/0x1eb0 kernel/sched/core.c:4155
 schedule+0xd0/0x2a0 kernel/sched/core.c:4230
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4289
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10d0 kernel/locking/mutex.c:1103
 tc_action_net_exit include/net/act_api.h:147 [inline]
 gate_exit_net+0x22/0x360 net/sched/act_gate.c:627
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 setup_net+0x502/0x850 net/core/net_namespace.c:364
 copy_net_ns+0x2cf/0x5e0 net/core/net_namespace.c:482
 create_new_namespaces+0x3f6/0xb10 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:231
 ksys_unshare+0x36c/0x9a0 kernel/fork.c:2983
 __do_sys_unshare kernel/fork.c:3051 [inline]
 __se_sys_unshare kernel/fork.c:3049 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3049
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007f52fc9f4c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000000050ba20 RCX: 000000000045cb29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000c8f R14: 00000000004ceebe R15: 00007f52fc9f56d4

Showing all locks held in the system:
1 lock held by khungtaskd/1143:
 #0: ffffffff89bbe640 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5779
1 lock held by in:imklog/6631:
 #0: ffff88809b9fbdb0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
4 locks held by kworker/u4:7/9446:
3 locks held by kworker/u4:4/10084:
3 locks held by kworker/0:3/9429:
 #0: ffff888099b43938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888099b43938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888099b43938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888099b43938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888099b43938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888099b43938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc9001b987da8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244
 #2: ffffffff8a7b0168 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4543
2 locks held by syz-executor.4/11446:
 #0: ffffffff8a7a32f0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2ac/0x5e0 net/core/net_namespace.c:478
 #1: ffffffff8a7b0168 (rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit include/net/act_api.h:147 [inline]
 #1: ffffffff8a7b0168 (rtnl_mutex){+.+.}-{3:3}, at: gate_exit_net+0x22/0x360 net/sched/act_gate.c:627
2 locks held by syz-executor.4/11449:
 #0: ffffffff8a7a32f0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2ac/0x5e0 net/core/net_namespace.c:478
 #1: ffffffff8a7b0168 (rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit include/net/act_api.h:147 [inline]
 #1: ffffffff8a7b0168 (rtnl_mutex){+.+.}-{3:3}, at: gate_exit_net+0x22/0x360 net/sched/act_gate.c:627

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1143 Comm: khungtaskd Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 10084 Comm: kworker/u4:4 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_purge_orig
RIP: 0010:hlock_class kernel/locking/lockdep.c:179 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4055 [inline]
RIP: 0010:__lock_acquire+0x4a7/0x56e0 kernel/locking/lockdep.c:4330
Code: 41 81 e7 ff 1f 45 0f b7 ff be 08 00 00 00 4c 89 f8 48 c1 f8 06 48 8d 3c c5 20 ca 58 8c e8 81 38 59 00 4c 0f a3 3d b9 8b ff 0a <0f> 83 3d 0c 00 00 4d 69 ff b8 00 00 00 49 81 c7 40 ce 58 8c 48 b8
RSP: 0018:ffffc9001b497990 EFLAGS: 00000047
RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffffffff81593e5f
RDX: fffffbfff18b195d RSI: 0000000000000008 RDI: ffffffff8c58cae0
RBP: ffff88804ff6cee0 R08: 0000000000000000 R09: ffffffff8c58cae7
R10: fffffbfff18b195c R11: 0000000000000001 R12: ffff88804ff6c5c0
R13: 0000000000000002 R14: ffff88806074a858 R15: 000000000000063b
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff9a5f4f000 CR3: 00000000a6be4000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:358 [inline]
 batadv_purge_orig_ref+0x176/0x1540 net/batman-adv/originator.c:1350
 batadv_purge_orig+0x17/0x60 net/batman-adv/originator.c:1379
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
