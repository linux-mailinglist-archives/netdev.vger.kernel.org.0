Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D03371E28
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 19:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhECRNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 13:13:10 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51854 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbhECRLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 13:11:16 -0400
Received: by mail-io1-f71.google.com with SMTP id h7-20020a5d9e070000b029041a1f6bccc8so3759562ioh.18
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 10:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bbtdet35GJncXf6HuQljM3K3BSHxsXNzF8nGYSgpYPc=;
        b=NLC1jvLYb2PnNodyybfkPuDmA1DPiEolLPYyWnjFr2hqKnenTbsuuA90QV8PgrM7l4
         J4E9uPprer4FZeHBm9tyeunSbLGXhRHvCOxvtOP79MMB6Qx6OI6skqDNqJ9CZUb2X+q0
         mdygbVfzQxAtHpa11SP1bPyXflUxdTZjlt9821VlA5AmvsGX1XwTsqcpiMZ+P4hIzZ9l
         kZtNiQGqBAC2vlcvqoGgUP4EQfP2gsyTuY9rUCl5moOmdILrDTmM3sH5Ieita1AA6TQA
         ClUtahYOiYHFFciQJ/i66WZRpfeht+sjwi+E64Gz7ss1VfbKnFxaK+ShKb9xqTrGwX48
         41OA==
X-Gm-Message-State: AOAM5305iY1QdBr4jhKr8qfvzi7LuRdNHrPfvCgQgnFLrY09ipbuei4W
        FnsuO/o4uckH/x++flaUPTFNef9lmXs8OvjEz95jPkf11JsU
X-Google-Smtp-Source: ABdhPJyPfDmZUGFCsSTAecryuEH4YJJUgG94HgLuqCezcYoWziffSuQTjjtc/dEiMvxbd4f4decMO38w/PIZOfvv9y53NwqLJmLK
MIME-Version: 1.0
X-Received: by 2002:a6b:ed11:: with SMTP id n17mr7080502iog.171.1620061822198;
 Mon, 03 May 2021 10:10:22 -0700 (PDT)
Date:   Mon, 03 May 2021 10:10:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d297505c1700970@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in __ipv6_dev_mc_dec
From:   syzbot <syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ap420073@gmail.com, ast@kernel.org,
        avagin@gmail.com, bpf@vger.kernel.org, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    95aafe91 net: ethernet: ixp4xx: Support device tree probing
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14fad3e1d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7668018815a66138
dashboard link: https://syzkaller.appspot.com/bug?extid=7d941e89dd48bcf42573
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103edf15d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1592b9d5d00000

The issue was bisected to:

commit f185de28d9ae6c978135993769352e523ee8df06
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Thu Mar 25 16:16:56 2021 +0000

    mld: add new workqueues for process mld events

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=145ba3f5d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=165ba3f5d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=125ba3f5d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:928
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 9825, name: syz-executor943
2 locks held by syz-executor943/9825:
 #0: ffffffff8d6730a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d6730a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5559
 #1: ffffffff8bf74520 (rcu_read_lock){....}-{1:2}, at: nla_ok include/net/netlink.h:1159 [inline]
 #1: ffffffff8bf74520 (rcu_read_lock){....}-{1:2}, at: do_setlink+0x27d0/0x3af0 net/core/rtnetlink.c:2868
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 PID: 9825 Comm: syz-executor943 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:8328
 __mutex_lock_common kernel/locking/mutex.c:928 [inline]
 __mutex_lock+0xa9/0x1120 kernel/locking/mutex.c:1096
 __ipv6_dev_mc_dec+0x5f/0x340 net/ipv6/mcast.c:965
 addrconf_leave_solict net/ipv6/addrconf.c:2182 [inline]
 addrconf_leave_solict net/ipv6/addrconf.c:2174 [inline]
 __ipv6_ifa_notify+0x5b6/0xa90 net/ipv6/addrconf.c:6099
 ipv6_ifa_notify net/ipv6/addrconf.c:6122 [inline]
 ipv6_del_addr+0x463/0xae0 net/ipv6/addrconf.c:1294
 addrconf_verify_rtnl+0xdbc/0x1220 net/ipv6/addrconf.c:4489
 inet6_set_iftoken net/ipv6/addrconf.c:5757 [inline]
 inet6_set_link_af+0x53c/0xc40 net/ipv6/addrconf.c:5833
 do_setlink+0x290d/0x3af0 net/core/rtnetlink.c:2875
 __rtnl_newlink+0xdcf/0x1710 net/core/rtnetlink.c:3385
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x443869
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc4ce9e848 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffc4ce9e870 RCX: 0000000000443869
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 000000000000000d R11: 0000000000000246 R12: 00007ffc4ce9e860
R13: 00000000000f4240 R14: 0000000000014fb2 R15: 00007ffc4ce9e854

=============================
[ BUG: Invalid wait context ]
5.12.0-rc7-syzkaller #0 Tainted: G        W        
-----------------------------
syz-executor943/9825 is trying to lock:
ffff8880188a3530 (&idev->mc_lock){+.+.}-{3:3}, at: __ipv6_dev_mc_dec+0x5f/0x340 net/ipv6/mcast.c:965
other info that might help us debug this:
context-{4:4}
2 locks held by syz-executor943/9825:
 #0: ffffffff8d6730a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d6730a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5559
 #1: ffffffff8bf74520 (rcu_read_lock){....}-{1:2}, at: nla_ok include/net/netlink.h:1159 [inline]
 #1: ffffffff8bf74520 (rcu_read_lock){....}-{1:2}, at: do_setlink+0x27d0/0x3af0 net/core/rtnetlink.c:2868
stack backtrace:
CPU: 0 PID: 9825 Comm: syz-executor943 Tainted: G        W         5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4552 [inline]
 check_wait_context kernel/locking/lockdep.c:4613 [inline]
 __lock_acquire.cold+0x219/0x3b4 kernel/locking/lockdep.c:4851
 lock_acquire kernel/locking/lockdep.c:5511 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5476
 __mutex_lock_common kernel/locking/mutex.c:949 [inline]
 __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
 __ipv6_dev_mc_dec+0x5f/0x340 net/ipv6/mcast.c:965
 addrconf_leave_solict net/ipv6/addrconf.c:2182 [inline]
 addrconf_leave_solict net/ipv6/addrconf.c:2174 [inline]
 __ipv6_ifa_notify+0x5b6/0xa90 net/ipv6/addrconf.c:6099
 ipv6_ifa_notify net/ipv6/addrconf.c:6122 [inline]
 ipv6_del_addr+0x463/0xae0 net/ipv6/addrconf.c:1294
 addrconf_verify_rtnl+0xdbc/0x1220 net/ipv6/addrconf.c:4489
 inet6_set_iftoken net/ipv6/addrconf.c:5757 [inline]
 inet6_set_link_af+0x53c/0xc40 net/ipv6/addrconf.c:5833
 do_setlink+0x290d/0x3af0 net/core/rtnetlink.c:2875
 __rtnl_newlink+0xdcf/0x1710 net/core/rtnetlink.c:3385
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x443869
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc4ce9e848 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffc4ce9e870 RCX: 0000000000443869
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 000000000000000d R11: 0000000000000246 R12: 00007ffc4ce9e860
R13: 00000000000f4240 R14: 0000000000014fb2 R15: 00007ffc4ce9e854
BUG: sleeping function called from invalid context at include/linux/sched/mm.h:197
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 9825, name: syz-executor943
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffffff87026ff3>] local_bh_disable include/linux/bottom_half.h:19 [inline]
[<ffffffff87026ff3>] netif_addr_lock_bh include/linux/netdevice.h:4549 [inline]
[<ffffffff87026ff3>] __dev_mc_del net/core/dev_addr_lists.c:814 [inline]
[<ffffffff87026ff3>] dev_mc_del+0x63/0x110 net/core/dev_addr_lists.c:833
CPU: 0 PID: 9825 Comm: syz-executor943 Tainted: G        W         5.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:8328
 might_alloc include/linux/sched/mm.h:197 [inline]
 slab_pre_alloc_hook mm/slab.h:497 [inline]
 slab_alloc_node mm/slub.c:2826 [inline]
 slab_alloc mm/slub.c:2915 [inline]
 kmem_cache_alloc_trace+0x263/0x2a0 mm/slub.c:2932
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 mld_add_delrec net/ipv6/mcast.c:737 [inline]
 igmp6_leave_group net/ipv6/mcast.c:2629 [inline]
 igmp6_group_dropped+0x4f7/0xe90 net/ipv6/mcast.c:717
 __ipv6_dev_mc_dec+0x25d/0x340 net/ipv6/mcast.c:973
 addrconf_leave_solict net/ipv6/addrconf.c:2182 [inline]
 addrconf_leave_solict net/ipv6/addrconf.c:2174 [inline]
 __ipv6_ifa_notify+0x5b6/0xa90 net/ipv6/addrconf.c:6099
 ipv6_ifa_notify net/ipv6/addrconf.c:6122 [inline]
 ipv6_del_addr+0x463/0xae0 net/ipv6/addrconf.c:1294
 addrconf_verify_rtnl+0xdbc/0x1220 net/ipv6/addrconf.c:4489
 inet6_set_iftoken net/ipv6/addrconf.c:5757 [inline]
 inet6_set_link_af+0x53c/0xc40 net/ipv6/addrconf.c:5833
 do_setlink+0x290d/0x3af0 net/core/rtnetlink.c:2875
 __rtnl_newlink+0xdcf/0x1710 net/core/rtnetlink.c:3385
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x443869
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc4ce9e848 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffc4ce9e870 RCX: 0000000000443869
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 000000000000000d R11: 0000000000000246 R12: 00007ffc4ce9e860
R13: 00000000000f4240 R14: 0000000000014fb2 R15: 00007ffc4ce9e854
__nla_validate_parse: 52 callbacks suppressed
netlink: 4 bytes leftover after parsing attributes in process `syz-executor943'.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
