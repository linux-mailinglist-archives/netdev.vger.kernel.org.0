Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770ED2277A1
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 06:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgGUEaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 00:30:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:49123 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGUEaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 00:30:20 -0400
Received: by mail-il1-f199.google.com with SMTP id q9so12628337ilt.15
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 21:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5giXxd1+Vx4lWw5hSAxfF96Mtyl+E+/XgMt+XwF3FYQ=;
        b=Aac8KGuqk3kOL7ZQYiMtMgQIXF/un25GydEfciJs4atXDFbKAI2E1Fk10eMPSozkpb
         ePIu4MQCidAIFK8wPnavWPqRs+AzegCpPGHxWjBkqc9TPJZrmOsStNUBS0sBCBTBrAmS
         Ys5XCNDkVwF+9YQ852Pgtn/K4eIQq7HhXkHGkHlX36uJ3jC1IVPlugNNbCgc4SMijxPs
         KcR1zcELZepEebWzrbCigZxV8HTlPalICRS6aswt5HtHipeqkD80fC+V3l6VIfUbuo2A
         jz9Ey8yftoGUv+NEHdfpdu52zrg5ziH5IlZsvQTj0S65NXvb29KzbgIP4LAd1NN5BHbj
         0wIQ==
X-Gm-Message-State: AOAM530c3EAGq0LmHMdKoTyTSfNyYh9pxPPdKenLQbfczA0vxoQ6iJaH
        o9qn7kz0G+82JVEmHlEhNp0wp1HcC5DDW5/nDSV6BMBPceEl
X-Google-Smtp-Source: ABdhPJxm2lb1fAKc2+P/N/sT6k/Hc9qOK0GkQLm0OfeWqzV8EvH/uGzFX1whN11GDz391QOGS7tZ4F+cs+NcYtk+YsgexgV+OIgr
MIME-Version: 1.0
X-Received: by 2002:a02:7419:: with SMTP id o25mr29600295jac.4.1595305819799;
 Mon, 20 Jul 2020 21:30:19 -0700 (PDT)
Date:   Mon, 20 Jul 2020 21:30:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2848005aaec14c4@google.com>
Subject: general protection fault in __xfrm6_tunnel_spi_check
From:   syzbot <syzbot+cbb5af985601225ceb76@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4c43049f Add linux-next specific files for 20200716
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16f786d7100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c76d72659687242
dashboard link: https://syzkaller.appspot.com/bug?extid=cbb5af985601225ceb76
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cbb5af985601225ceb76@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xe01ffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0x0100000000000020-0x0100000000000027]
CPU: 0 PID: 11470 Comm: syz-executor.3 Not tainted 5.8.0-rc5-next-20200716-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__xfrm6_tunnel_spi_check+0x1e5/0x330 net/ipv6/xfrm6_tunnel.c:111
Code: 0f 85 3c 01 00 00 48 8b 5b 10 48 85 db 74 44 e8 31 41 7b fa 48 83 eb 10 74 39 e8 26 41 7b fa 48 8d 7b 30 48 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 74 08 3c 03 0f 8e fd 00 00 00 8b 6b 30 44 89
RSP: 0018:ffffc900175df3d0 EFLAGS: 00010202
RAX: 0020000000000004 RBX: 00fffffffffffff0 RCX: ffffc9000f672000
RDX: 0000000000040000 RSI: ffffffff86f8eeba RDI: 0100000000000020
RBP: ffff88805bdfc800 R08: 0000000000000001 R09: ffff888089c1cc10
R10: fffffbfff1571bb9 R11: 0000000000000000 R12: 0000000098f1a001
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000098f19fff
FS:  00007f1165c1d700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001600 CR3: 0000000092d1e000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_tunnel.c:131 [inline]
 xfrm6_tunnel_alloc_spi+0x296/0x8a0 net/ipv6/xfrm6_tunnel.c:174
 ipcomp6_tunnel_create net/ipv6/ipcomp6.c:84 [inline]
 ipcomp6_tunnel_attach net/ipv6/ipcomp6.c:124 [inline]
 ipcomp6_init_state net/ipv6/ipcomp6.c:159 [inline]
 ipcomp6_init_state+0x2af/0x700 net/ipv6/ipcomp6.c:139
 __xfrm_init_state+0x9a6/0x14b0 net/xfrm/xfrm_state.c:2498
 xfrm_state_construct net/xfrm/xfrm_user.c:627 [inline]
 xfrm_add_sa+0x1db9/0x34f0 net/xfrm/xfrm_user.c:684
 xfrm_user_rcv_msg+0x414/0x700 net/xfrm/xfrm_user.c:2684
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2692
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1d9
Code: Bad RIP value.
RSP: 002b:00007f1165c1cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002a500 RCX: 000000000045c1d9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffc3130211f R14: 00007f1165c1d9c0 R15: 000000000078bf0c
Modules linked in:
---[ end trace 21b48c86a3c64819 ]---
RIP: 0010:__xfrm6_tunnel_spi_check+0x1e5/0x330 net/ipv6/xfrm6_tunnel.c:111
Code: 0f 85 3c 01 00 00 48 8b 5b 10 48 85 db 74 44 e8 31 41 7b fa 48 83 eb 10 74 39 e8 26 41 7b fa 48 8d 7b 30 48 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 74 08 3c 03 0f 8e fd 00 00 00 8b 6b 30 44 89
RSP: 0018:ffffc900175df3d0 EFLAGS: 00010202
RAX: 0020000000000004 RBX: 00fffffffffffff0 RCX: ffffc9000f672000
RDX: 0000000000040000 RSI: ffffffff86f8eeba RDI: 0100000000000020
RBP: ffff88805bdfc800 R08: 0000000000000001 R09: ffff888089c1cc10
R10: fffffbfff1571bb9 R11: 0000000000000000 R12: 0000000098f1a001
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000098f19fff
FS:  00007f1165c1d700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001600 CR3: 0000000092d1e000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
