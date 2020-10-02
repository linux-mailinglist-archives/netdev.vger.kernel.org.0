Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8D6281713
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgJBPsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:48:25 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:50110 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388108AbgJBPsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:48:23 -0400
Received: by mail-il1-f205.google.com with SMTP id o18so1442414ilm.16
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=AKbewD64TZBiOE+n0ZAkEHGivzT0aH+mQ/YFSsZKEyI=;
        b=G6q9fIWGZYLO2n5+B7nRLvG0+BI6RrOQML5/fVRFJ3/02PHTFtzhczm5LRvauGidwy
         +6Km0O0RLgooyMMlAKGKP96B4SHxRQHP2r4s4avfRz7Hl9/ULCef9yG4AtnQOKe0XbEM
         +WRputAdLIDJxUkRtglfglNgDVzykdxaM+gQpJbWab+E2T2oqouxJk9ORPgsy8IU+znD
         qb3KvlItUhghKdOkvRctC00WJFT0fgGHU8SjtKQQfvk30Z+nCuBhCFlFBy/KFgBMJ2og
         lEacq9sIvdn9OGnUTEYc9hXmLE16vAAI1y/+NFSKPxf24rF4NdM9s4r6MtJ8WfC5w4tO
         uP2g==
X-Gm-Message-State: AOAM532zV7ZumeOfADZvnXQsvHP0h5PbI7dWRllkb5sU9HngD9hYHggY
        0RwV350xQBwtdPieI1hBvWaofev09ihmyGhCBTvtqw5zKSYF
X-Google-Smtp-Source: ABdhPJy31jTXZ1/Ic+TOS2i7NvMAXnfFpz6hr7+R34vLG8RilkYrTNFJLZLlzw+RJcD0hxT3IJ0tI6Gy93F6En//A8FZYuc61q+Z
MIME-Version: 1.0
X-Received: by 2002:a92:3408:: with SMTP id b8mr2337953ila.231.1601653699808;
 Fri, 02 Oct 2020 08:48:19 -0700 (PDT)
Date:   Fri, 02 Oct 2020 08:48:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d494a605b0b20f8c@google.com>
Subject: INFO: task hung in lock_sock_nested (3)
From:   syzbot <syzbot+fcf8ca5817d6e92c6567@syzkaller.appspotmail.com>
To:     amir73il@gmail.com, davem@davemloft.net, jack@suse.cz,
        kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    87d5034d Merge tag 'mlx5-updates-2020-09-30' of git://git...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1377fb37900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7b5cc8ec2218e99d
dashboard link: https://syzkaller.appspot.com/bug?extid=fcf8ca5817d6e92c6567
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14566267900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14458a4d900000

The issue was bisected to:

commit ab174ad8ef76276cadfdae98731d31797d265927
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Mon Sep 14 08:01:12 2020 +0000

    mptcp: move ooo skbs into msk out of order queue.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124d00b3900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=114d00b3900000
console output: https://syzkaller.appspot.com/x/log.txt?x=164d00b3900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fcf8ca5817d6e92c6567@syzkaller.appspotmail.com
Fixes: ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue.")

INFO: task syz-executor924:8165 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor924 state:D stack:28120 pid: 8165 ppid:  6877 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 __lock_sock+0x13d/0x260 net/core/sock.c:2504
 lock_sock_nested+0xf1/0x110 net/core/sock.c:3043
 lock_sock include/net/sock.h:1581 [inline]
 sk_stream_wait_memory+0x775/0xe60 net/core/stream.c:145
 mptcp_sendmsg+0x53b/0x1910 net/mptcp/protocol.c:1196
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:817
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 __sys_sendto+0x21c/0x320 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto net/socket.c:2000 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2000
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44a519
Code: Bad RIP value.
RSP: 002b:00007fbbeac93cd8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000006dfc48 RCX: 000000000044a519
RDX: 00000000ffffffe7 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000006dfc40 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000c000 R11: 0000000000000246 R12: 00000000006dfc4c
R13: 00007ffe07568e9f R14: 00007fbbeac949c0 R15: 0000000000000064
INFO: task syz-executor924:8922 blocked for more than 144 seconds.
      Not tainted 5.9.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor924 state:D stack:28112 pid: 8922 ppid:  6876 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xec9/0x2280 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 __lock_sock+0x13d/0x260 net/core/sock.c:2504
 lock_sock_nested+0xf1/0x110 net/core/sock.c:3043
 lock_sock include/net/sock.h:1581 [inline]
 mptcp_close+0x8d/0xc60 net/mptcp/protocol.c:1914
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x408ec1
Code: Bad RIP value.
RSP: 002b:00007ffe07568f10 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000408ec1
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000007b8fc R08: 00000001bb1414ac R09: 00000001bb1414ac
R10: 00007ffe07568f30 R11: 0000000000000293 R12: 00000000006dfc50
R13: 0000000000000008 R14: 00000000006dfc5c R15: 0000000000000064

Showing all locks held in the system:
3 locks held by kworker/1:0/17:
2 locks held by kworker/u4:4/155:
1 lock held by khungtaskd/1166:
 #0: ffffffff8a068400 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5852
1 lock held by khugepaged/1181:
 #0: ffffffff8a133fc8 (lock#5){+.+.}-{3:3}, at: lru_add_drain_all+0x59/0x6c0 mm/swap.c:780
1 lock held by in:imklog/6560:
 #0: ffff88809d19bbb0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
3 locks held by kworker/0:2/8106:
1 lock held by syz-executor924/8922:
 #0: ffff888085719c90 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:779 [inline]
 #0: ffff888085719c90 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:595
2 locks held by syz-executor924/22396:
5 locks held by syz-executor924/22398:
 #0: ffff8880ae435e58 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1292 [inline]
 #0: ffff8880ae435e58 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x287/0x2280 kernel/sched/core.c:4445
 #1: ffff8880ae420ec8 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x305/0x440 kernel/sched/psi.c:833
 #2: ffff88808b75e6d8 (&(&sig->stats_lock)->lock){....}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #2: ffff88808b75e6d8 (&(&sig->stats_lock)->lock){....}-{2:2}, at: write_seqlock include/linux/seqlock.h:796 [inline]
 #2: ffff88808b75e6d8 (&(&sig->stats_lock)->lock){....}-{2:2}, at: __exit_signal kernel/exit.c:134 [inline]
 #2: ffff88808b75e6d8 (&(&sig->stats_lock)->lock){....}-{2:2}, at: release_task+0x4d9/0x14d0 kernel/exit.c:198
 #3: ffff88808b75e698 (&(&sig->stats_lock)->seqcount){....}-{0:0}, at: exit_notify kernel/exit.c:681 [inline]
 #3: ffff88808b75e698 (&(&sig->stats_lock)->seqcount){....}-{0:0}, at: do_exit+0x14db/0x29f0 kernel/exit.c:826
 #4: ffffffff8a068400 (rcu_read_lock){....}-{1:2}, at: is_bpf_text_address+0x0/0x160 kernel/bpf/core.c:693
2 locks held by syz-executor924/22420:
2 locks held by syz-executor924/22418:
 #0: ffff8880ae535e58 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1292 [inline]
 #0: ffff8880ae535e58 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x287/0x2280 kernel/sched/core.c:4445
 #1: ffff8880ae520ec8 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x305/0x440 kernel/sched/psi.c:833
2 locks held by syz-executor924/22430:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1166 Comm: khungtaskd Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 3905 Comm: systemd-journal Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:write_comp_data+0x78/0x80 kernel/kcov.c:242
Code: 00 00 4e 8d 0c dd 28 00 00 00 4c 39 ce 72 1b 49 83 c0 01 4a 89 7c 08 e0 4e 89 54 08 e8 4a 89 54 08 f0 4a 89 4c d8 20 4c 89 00 <c3> 0f 1f 80 00 00 00 00 48 8b 0c 24 40 0f b6 d6 40 0f b6 f7 31 ff
RSP: 0018:ffffc900054efd88 EFLAGS: 00000293
RAX: 0000000000000000 RBX: ffff888096ca9400 RCX: ffffffff8176fdfd
RDX: 000000007fff0000 RSI: ffff8880939a04c0 RDI: 0000000000000004
RBP: 000000007fff0000 R08: 0000000000000001 R09: 0000000000000001
R10: 000000007fff0000 R11: 0000000000000000 R12: dffffc0000000000
R13: 000000007fff0000 R14: 000000007fff0000 R15: ffffc900054efe38
FS:  00007f869741d8c0(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f86947f5000 CR3: 0000000093d53000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 seccomp_run_filters kernel/seccomp.c:326 [inline]
 __seccomp_filter+0x19d/0x1550 kernel/seccomp.c:937
 __secure_computing+0xfc/0x360 kernel/seccomp.c:1070
 syscall_trace_enter.constprop.0+0x7e/0x250 kernel/entry/common.c:58
 do_syscall_64+0xf/0x70 arch/x86/entry/common.c:41
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f86969ad840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007ffe29dd7568 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007ffe29dd7870 RCX: 00007f86969ad840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 0000556bad994c40
RBP: 000000000000000d R08: 0000000000000000 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000556bad98a040 R14: 00007ffe29dd7830 R15: 0000556bad994ec0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
