Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC26F426223
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 03:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhJHBsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 21:48:15 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:49879 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbhJHBsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 21:48:14 -0400
Received: by mail-il1-f199.google.com with SMTP id e10-20020a92194a000000b00258acd999afso5064832ilm.16
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 18:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3V0gMQArySAZVecQuHcle8YsXw0+et6jEaMN+U7Pngk=;
        b=Zi2tparq0o0vOsKwLN1O4iE387unXokd9hkCfC0Y1I87NxZnzA393I1krRTYcCBVeX
         9Gkctnz8FBM9XOM33DUqjwOg0evMhKUOnTjZoX+K9eJQVhDsli7kPlFLPAcHIpH85t1D
         YgosE98ajPUrzmnK/8fX0Jx5p2lAobYfoYoIaA/Pi3JSXnSOfTsgUGSO2cNm6YEWiFrH
         CE32pzcdUv5QmbPtqZGkKobRe3lPipCa9p7mjJgCi2qpoiuOU74AcCVL0U5PsqeOIunf
         xYIjvXqa5the7o9c6SUcJKAhAg+iC3Zk84HrB5hM3sFyHQSZnRBr2zgWHRL23kjvAnOm
         YSOg==
X-Gm-Message-State: AOAM531xrhgG0qeSitGczUawSOm9MANNwjxZ7qw9B2YBanA7hmTYszHp
        yHQFlgXKAP7knIAiryjER32qVx6pe+sr3Jdr7eTnP7tZ14VM
X-Google-Smtp-Source: ABdhPJzExBXOVo0euzkjGnBooFDPofT/nUJi+B2M6P3x4ZtZn8xYiJgGPzOYdaQ6dNPjY3xa8gU+n1OBIpmmt5nGc89O8i+Sm+sw
MIME-Version: 1.0
X-Received: by 2002:a5d:944b:: with SMTP id x11mr5580437ior.110.1633657579796;
 Thu, 07 Oct 2021 18:46:19 -0700 (PDT)
Date:   Thu, 07 Oct 2021 18:46:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba80b905cdcd8b19@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in batadv_v_ogm_free
From:   syzbot <syzbot+0ef06384b5f39a16ebb9@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, a@unstable.cc, amcohen@nvidia.com,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, fw@strlen.de,
        idosch@OSS.NVIDIA.COM, justin.iurman@uliege.be, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, praveen5582@gmail.com, sven@narfation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com,
        willemb@google.com, yoshfuji@linux-ipv6.org, zxu@linkedin.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    44cc24b04bed Merge tag 'wireless-drivers-next-2021-10-07' ..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=130661b8b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=97f67871098c6901
dashboard link: https://syzkaller.appspot.com/bug?extid=0ef06384b5f39a16ebb9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1361e884b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1472de98b00000

The issue was bisected to:

commit 9ee11f0fff205b4b3df9750bff5e94f97c71b6a0
Author: Justin Iurman <justin.iurman@uliege.be>
Date:   Tue Jul 20 19:42:57 2021 +0000

    ipv6: ioam: Data plane support for Pre-allocated Trace

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c661b8b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c661b8b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c661b8b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0ef06384b5f39a16ebb9@syzkaller.appspotmail.com
Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")

R13: 00007ffc310f3710 R14: 00007ffc310f3760 R15: 0000000000000001
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 1 PID: 6548 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 6548 Comm: syz-executor580 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd c0 3e e4 89 4c 89 ee 48 c7 c7 c0 32 e4 89 e8 29 8d 16 05 <0f> 0b 83 05 55 18 91 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90002bdee90 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff88801c395580 RSI: ffffffff815dbbc8 RDI: fffff5200057bdc4
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d596e R11: 0000000000000000 R12: ffffffff898de200
R13: ffffffff89e43940 R14: ffffffff8164b870 R15: 1ffff9200057bddd
FS:  000055555617e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f868a8856c0 CR3: 0000000024660000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 debug_object_assert_init lib/debugobjects.c:895 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
 debug_timer_assert_init kernel/time/timer.c:739 [inline]
 debug_assert_init kernel/time/timer.c:784 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1204
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1270
 __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3129
 batadv_v_ogm_free+0x1f/0xd0 net/batman-adv/bat_v_ogm.c:1076
 batadv_mesh_free+0x75/0x170 net/batman-adv/main.c:244
 batadv_mesh_init+0x62f/0x710 net/batman-adv/main.c:226
 batadv_softif_init_late+0xad4/0xdd0 net/batman-adv/soft-interface.c:804
 register_netdevice+0x51e/0x1500 net/core/dev.c:10236
 batadv_softif_newlink+0x6e/0x90 net/batman-adv/soft-interface.c:1068
 __rtnl_newlink+0x106d/0x1750 net/core/rtnetlink.c:3458
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2485
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1910
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 __sys_sendto+0x21c/0x320 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4cb72c2829
Code: b2 01 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc310f36a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f4cb72c2829
RDX: 000000000000ad2a RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00007ffc310f3710 R08: 0000000000000000 R09: 4b6ae4f95a5de394
R10: 0000000000007812 R11: 0000000000000246 R12: 0000000000000005
R13: 00007ffc310f3710 R14: 00007ffc310f3760 R15: 0000000000000001


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
