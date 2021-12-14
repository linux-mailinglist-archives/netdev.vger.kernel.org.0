Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE6473C22
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 05:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhLNEmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 23:42:25 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55942 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLNEmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 23:42:24 -0500
Received: by mail-io1-f72.google.com with SMTP id y74-20020a6bc84d000000b005e700290338so16651113iof.22
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=G3iIm7WWyPtP3wJ5l8bK4zKKO3ZBgLh/J1tuLp7eujw=;
        b=W6TAqqDe5vcQHTO2if7jHUKxtjyqG+N1gsFdZm8/x84pkwfadUWMgrP0E7SUqQK/wA
         h+Azen5Aq7tysL13qq5sl9Kp3ItT31XxwxTPzBTQIYkM98xc0co2KRdnJu331TF1KeKo
         A0WMy9ziXVfZlaSoxOfipuU2MTQZ6YoroeWzksHJeaCQctV3HR/SuTOrQXOOa+OChpZc
         EzHFW2gt3RLe/MyOUohik/59kkvsw9GCFHyLxfL1LzKuDZH2zbCwEm5Eu4NSmdlbbyBh
         WrhDnWBa32NUsQf/AYq1LqEV/EbPTGJ5e7PB+maMU/uMDDxOAuRN62KVjDDzH3tnXAGJ
         BYMw==
X-Gm-Message-State: AOAM5314H+fLrl2lBefB7HyAMYNQwcWtz5oPHTQy0VhKf3GV9qc+l4XG
        ZcSsAQzfVBWx4bnDGkebjy1urXB4Cu7eQXAKHewjkzTmxZAG
X-Google-Smtp-Source: ABdhPJy2mrysm79kzkL9DG8A2CJxm8i+gCRmlY1Z31V+4yaYk+9Pmep6D0t/w+s0aTVWbs1MX0c50XcvIGRi3T0L7s6D3dEWxGxk
MIME-Version: 1.0
X-Received: by 2002:a5e:c10d:: with SMTP id v13mr2041657iol.115.1639456944012;
 Mon, 13 Dec 2021 20:42:24 -0800 (PST)
Date:   Mon, 13 Dec 2021 20:42:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c5c09805d313d03e@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in tipc_crypto_start
From:   syzbot <syzbot+73a4f2b28371d5526901@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fw@strlen.de, jmaloy@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tadeusz.struk@linaro.org,
        tipc-discussion@lists.sourceforge.net, yajun.deng@linux.dev,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ea922272cbe5 Add linux-next specific files for 20211210
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1641d8d5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c1359a19d2230002
dashboard link: https://syzkaller.appspot.com/bug?extid=73a4f2b28371d5526901
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11de63ceb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f27879b00000

The issue was bisected to:

commit 86c3a3e964d910a62eeb277d60b2a60ebefa9feb
Author: Tadeusz Struk <tadeusz.struk@linaro.org>
Date:   Thu Nov 11 20:59:16 2021 +0000

    tipc: use consistent GFP flags

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1008a69db00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1208a69db00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1408a69db00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+73a4f2b28371d5526901@syzkaller.appspotmail.com
Fixes: 86c3a3e964d9 ("tipc: use consistent GFP flags")

tipc: Started in network mode
tipc: Node identity 00000000000000000000000000000001, cluster identity 4711
tipc: New replicast peer: 0000:0000:0000:0000:0000:0000:0000:0000
tipc: Enabled bearer <udp:syz0>, priority 10
BUG: sleeping function called from invalid context at include/linux/sched/mm.h:256
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3597, name: syz-executor310
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
4 locks held by syz-executor310/3597:
 #0: ffffffff8d3af590 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:802
 #1: ffffffff8d3af648 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8d3af648 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3e0/0x580 net/netlink/genetlink.c:790
 #2: ffffffff8d31c9a8 (rtnl_mutex){+.+.}-{3:3}, at: tipc_nl_node_set_key+0x7b/0xf70 net/tipc/node.c:3032
 #3: ffff888023514068 (&tn->node_list_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #3: ffff888023514068 (&tn->node_list_lock){+...}-{2:2}, at: tipc_node_create+0x179/0x1f60 net/tipc/node.c:480
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 PID: 3597 Comm: syz-executor310 Not tainted 5.16.0-rc4-next-20211210-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9583
 might_alloc include/linux/sched/mm.h:256 [inline]
 slab_pre_alloc_hook mm/slab.h:739 [inline]
 slab_alloc_node mm/slub.c:3145 [inline]
 slab_alloc mm/slub.c:3239 [inline]
 kmem_cache_alloc_trace+0x25d/0x2c0 mm/slub.c:3256
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 tipc_crypto_start+0xc7/0xbe0 net/tipc/crypto.c:1466
 tipc_node_create+0xb42/0x1f60 net/tipc/node.c:536
 __tipc_nl_node_set_key net/tipc/node.c:2998 [inline]
 tipc_nl_node_set_key+0xd6d/0xf70 net/tipc/node.c:3033
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2492
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1341
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f086ad0dd99
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff8e4aaed8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f086ad0dd99
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00007f086acd1800 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: 00007f086acd1890
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

=============================
[ BUG: Invalid wait context ]
5.16.0-rc4-next-20211210-syzkaller #0 Tainted: G        W        
-----------------------------
syz-executor310/3597 is trying to lock:
ffffffff8bc8a028 (pcpu_alloc_mutex){+.+.}-{3:3}, at: pcpu_alloc+0xb25/0x1360 mm/percpu.c:1774
other info that might help us debug this:
context-{4:4}
4 locks held by syz-executor310/3597:
 #0: ffffffff8d3af590 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:802
 #1: ffffffff8d3af648 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8d3af648 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3e0/0x580 net/netlink/genetlink.c:790
 #2: ffffffff8d31c9a8 (rtnl_mutex){+.+.}-{3:3}, at: tipc_nl_node_set_key+0x7b/0xf70 net/tipc/node.c:3032
 #3: ffff888023514068 (&tn->node_list_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #3: ffff888023514068 (&tn->node_list_lock){+...}-{2:2}, at: tipc_node_create+0x179/0x1f60 net/tipc/node.c:480
stack backtrace:
CPU: 0 PID: 3597 Comm: syz-executor310 Tainted: G        W         5.16.0-rc4-next-20211210-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4678 [inline]
 check_wait_context kernel/locking/lockdep.c:4739 [inline]
 __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4977
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __mutex_lock_common kernel/locking/mutex.c:600 [inline]
 __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:733
 pcpu_alloc+0xb25/0x1360 mm/percpu.c:1774
 tipc_crypto_start+0xf5/0xbe0 net/tipc/crypto.c:1480
 tipc_node_create+0xb42/0x1f60 net/tipc/node.c:536
 __tipc_nl_node_set_key net/tipc/node.c:2998 [inline]
 tipc_nl_node_set_key+0xd6d/0xf70 net/tipc/node.c:3033
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2492
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1315 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1341
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f086ad0dd99
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff8e4aaed8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f086ad0dd99
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00007f086acd1800 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: 00007f086acd1890
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
