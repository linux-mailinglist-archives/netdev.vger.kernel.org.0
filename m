Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD812D85A9
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438578AbgLLKFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407214AbgLLJyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:54:16 -0500
Received: from mail-il1-x145.google.com (mail-il1-x145.google.com [IPv6:2607:f8b0:4864:20::145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D094C061285
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:03:13 -0800 (PST)
Received: by mail-il1-x145.google.com with SMTP id r3so9142923ila.3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6Q8P6lZWJk9YvI1o3Ir5QP4xCY7zQR/frUrxy75o8kk=;
        b=UxbU5RUTWvfo3jfrthSut/rg0A/ajE6b4d8AHa8D5qlaaFnq6i1W2cJSOD4lvutumS
         jsvn9qDirkFNcbL1FJy1GQP+y9vgXwnSem4rFsv5W+K3uumzVnMDU5SnH3A+bGTmZU/y
         /8dqDxlQ8zRzIBmgSWU4YyZey43LDXMtJJ1pmEmmylk72sczI5+oDLMj6OCrnrDiOEQZ
         Bd3eWt4mpqoObc7Fu2wW1KV3+cnieKKcw+7syJS99Ss1xAqW5p0X8fqiJ5pJejqwk/7w
         A2vQccDY4eBQHs3Ta+7T4Lxq9AClJAtkpInaBigNKEMN/ZghygRsEJfKpJTcmFOlj6FV
         w0Rw==
X-Gm-Message-State: AOAM533p0vvR3rXsj+Z/IILBS4OVO8n7imUDDlgHkGYqU7N3VGtBLG3W
        0KdxiJSSxhw/W7LzpCQlWVf1wHfuK6RlcDb1WBIDKHTpjGKC
X-Google-Smtp-Source: ABdhPJyd3AKxjCLuOnS6FKa03FzV1nTM3nzrhwE8pcGZkkkvqlmJfF5eV5rBaWyiFCTrb4rIWZhbkOtCOUv9GcJfAQbTxcXAvo3L
MIME-Version: 1.0
X-Received: by 2002:a02:91c2:: with SMTP id s2mr21400206jag.48.1607763790376;
 Sat, 12 Dec 2020 01:03:10 -0800 (PST)
Date:   Sat, 12 Dec 2020 01:03:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009bb75905b640ad12@google.com>
Subject: INFO: task can't die in connmark_exit_net
From:   syzbot <syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    15ac8fdb Add linux-next specific files for 20201207
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15fbf86b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3696b8138207d24d
dashboard link: https://syzkaller.appspot.com/bug?extid=b3b63b6bff456bd95294
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13121287500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com

INFO: task syz-executor.4:13889 can't die for more than 143 seconds.
task:syz-executor.4  state:D stack:26200 pid:13889 ppid: 12369 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8eb/0x21b0 kernel/sched/core.c:5076
 schedule+0xcf/0x270 kernel/sched/core.c:5155
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5214
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 tc_action_net_exit include/net/act_api.h:147 [inline]
 connmark_exit_net+0x20/0x130 net/sched/act_connmark.c:241
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 setup_net+0x508/0x850 net/core/net_namespace.c:365
 copy_net_ns+0x376/0x7b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x3e5/0x4d0 kernel/nsproxy.c:179
 copy_process+0x2aa7/0x6fe0 kernel/fork.c:2103
 kernel_clone+0xe7/0xad0 kernel/fork.c:2465
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2582
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e0f9
RSP: 002b:00007fd04901bc68 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045e0f9
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 00000000e900e57c
RBP: 000000000119c078 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c034
R13: 00007fff629a5d7f R14: 00007fd04901c9c0 R15: 000000000119c034
INFO: task syz-executor.1:13932 can't die for more than 143 seconds.
task:syz-executor.1  state:D stack:26320 pid:13932 ppid: 12371 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8eb/0x21b0 kernel/sched/core.c:5076
 schedule+0xcf/0x270 kernel/sched/core.c:5155
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:5214
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x81a/0x1110 kernel/locking/mutex.c:1103
 tc_action_net_exit include/net/act_api.h:147 [inline]
 gate_exit_net+0x20/0x130 net/sched/act_gate.c:624
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 setup_net+0x508/0x850 net/core/net_namespace.c:365
 copy_net_ns+0x376/0x7b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x3e5/0x4d0 kernel/nsproxy.c:179
 copy_process+0x2aa7/0x6fe0 kernel/fork.c:2103
 kernel_clone+0xe7/0xad0 kernel/fork.c:2465
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2582
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e0f9
RSP: 002b:00007fd373ed4c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045e0f9
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 00000000e900e57c
RBP: 000000000119c120 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c0dc
R13: 00007ffc4464352f R14: 00007fd373ed59c0 R15: 000000000119c0dc

Showing all locks held in the system:
3 locks held by kworker/0:2/8:
3 locks held by kworker/1:1/35:
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2246
 #1: ffffc90000e6fda8 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2250
 #2: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x1280 net/ipv6/addrconf.c:4028
1 lock held by khungtaskd/1655:
 #0: ffffffff8b78db60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x28c kernel/locking/lockdep.c:6254
1 lock held by in:imklog/8192:
 #0: ffff888012b58370 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:923
4 locks held by kworker/u4:1/8580:
3 locks held by kworker/u4:2/8830:
3 locks held by kworker/0:4/9816:
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2246
 #1: ffffc90001dd7da8 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2250
 #2: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
3 locks held by kworker/0:6/10010:
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881473fb538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2246
 #1: ffffc9000af5fda8 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2250
 #2: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x1280 net/ipv6/addrconf.c:4028
3 locks held by kworker/0:27/12319:
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010862d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2246
 #1: ffffc90002e67da8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2250
 #2: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
2 locks held by syz-executor.4/13889:
 #0: ffffffff8d0bc590 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x352/0x7b0 net/core/net_namespace.c:479
 #1: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit include/net/act_api.h:147 [inline]
 #1: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: connmark_exit_net+0x20/0x130 net/sched/act_connmark.c:241
2 locks held by syz-executor.1/13932:
 #0: ffffffff8d0bc590 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x352/0x7b0 net/core/net_namespace.c:479
 #1: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit include/net/act_api.h:147 [inline]
 #1: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: gate_exit_net+0x20/0x130 net/sched/act_gate.c:624
2 locks held by syz-executor.3/14181:
 #0: ffffffff8d0bc590 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x352/0x7b0 net/core/net_namespace.c:479
 #1: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit include/net/act_api.h:147 [inline]
 #1: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: gate_exit_net+0x20/0x130 net/sched/act_gate.c:624
2 locks held by syz-executor.5/14278:
1 lock held by syz-executor.0/14352:
 #0: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0d70c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x443/0xb80 net/core/rtnetlink.c:5559

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
