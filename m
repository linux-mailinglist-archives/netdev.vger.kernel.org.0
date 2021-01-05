Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2692EAB06
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbhAEMm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:42:58 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:38593 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbhAEMm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:42:57 -0500
Received: by mail-il1-f200.google.com with SMTP id e10so30434809ils.5
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:42:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Yov8pThlurzn2qeJcnPoJ2+Ts+csVG2AvqOiqp8QBNg=;
        b=D7AKsPJYCzsX4aSRmrPg/PoxPuUkCG/d/pXsvS/axhf6+Ds6yOQP8OP+D3ZRPOT0ld
         yzi+QWHi/L7wCmt9ZWsVzBDaLzEPMkclj/vRZkX3cHi2Ee3my4u1PoNkoPNlr3/ZBEuu
         ujQt+SAwQazWAxGZrE0+9akNtHHxgpthI1nm8xNhlzoCiuNJT1xq3KRax9nHVFhUw83c
         vI6hEi+59CUFvhbfEockFG3YH8L9Qr8xqroyU3ulHmfW/GxRW6ln4MuE+E+E1FkhbYky
         mm+WHqD8srNUaeNnD/yeQvvhE3ANDHyi5KnT+HBtUk3lN8I3mhLjwH11bRxIZCiwzLS6
         L1uQ==
X-Gm-Message-State: AOAM531otBTEZE3sgNQPDjqsnM58IBnOsTPvsfmbfnn6yfRvADH1eGQ2
        YQk9hnD5laHHNETDa+z5yOGlk26+v1hVHx48o0g8vBenfGzv
X-Google-Smtp-Source: ABdhPJwDhBrOazpl3SHjmwso5bDY/HH/88oLwRL5LHxMn0Cy+/1BwHnOsMbTIySyMfuhlW+nCV9IOQYDEYXCSxlrPntCD3JiSKzN
MIME-Version: 1.0
X-Received: by 2002:a02:6cd4:: with SMTP id w203mr38289416jab.89.1609850535983;
 Tue, 05 Jan 2021 04:42:15 -0800 (PST)
Date:   Tue, 05 Jan 2021 04:42:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056c3e005b82689d1@google.com>
Subject: general protection fault in xfrm_user_rcv_msg_compat
From:   syzbot <syzbot+5078fc2d7cf37d71de1c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    36bbbd0e Merge branch 'rcu/urgent' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136ca057500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=104b0cac547b2149
dashboard link: https://syzkaller.appspot.com/bug?extid=5078fc2d7cf37d71de1c
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5078fc2d7cf37d71de1c@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xe7c939d8b8314120: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0x3e49eec5c18a0900-0x3e49eec5c18a0907]
CPU: 0 PID: 9749 Comm: syz-executor.0 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:404 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:526 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1040 net/xfrm/xfrm_compat.c:571
Code: 3c 38 00 0f 85 14 08 00 00 48 8b 04 24 4c 8b 20 4d 85 e4 0f 84 0b 02 00 00 e8 27 6d d3 f9 49 8d 7c 24 02 48 89 f8 48 c1 e8 03 <42> 0f b6 14 38 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffffc90021f273d8 EFLAGS: 00010202
RAX: 07c93dd8b8314120 RBX: 0000000000000005 RCX: ffffc900018b9000
RDX: 0000000000040000 RSI: ffffffff879f0879 RDI: 3e49eec5c18a0902
RBP: ffff88801dd6c450 R08: 000000000000001b R09: ffff88801dd6c453
R10: ffffffff879f0ab9 R11: 0000000000000024 R12: 3e49eec5c18a0900
R13: 0000000000000006 R14: ffff88801dd6c440 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88802ca00000(0063) knlGS:00000000f5591b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000540 CR3: 00000000758b3000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 xfrm_user_rcv_msg+0x55b/0x8b0 net/xfrm/xfrm_user.c:2774
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f97549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f55910bc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000540
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace cd107aff38e126f7 ]---
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:404 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:526 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1040 net/xfrm/xfrm_compat.c:571
Code: 3c 38 00 0f 85 14 08 00 00 48 8b 04 24 4c 8b 20 4d 85 e4 0f 84 0b 02 00 00 e8 27 6d d3 f9 49 8d 7c 24 02 48 89 f8 48 c1 e8 03 <42> 0f b6 14 38 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffffc90021f273d8 EFLAGS: 00010202
RAX: 07c93dd8b8314120 RBX: 0000000000000005 RCX: ffffc900018b9000
RDX: 0000000000040000 RSI: ffffffff879f0879 RDI: 3e49eec5c18a0902
RBP: ffff88801dd6c450 R08: 000000000000001b R09: ffff88801dd6c453
R10: ffffffff879f0ab9 R11: 0000000000000024 R12: 3e49eec5c18a0900
R13: 0000000000000006 R14: ffff88801dd6c440 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88802cb00000(0063) knlGS:00000000f5591b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000008161934 CR3: 00000000758b3000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
