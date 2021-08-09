Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B647F3E48FC
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 17:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhHIPiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 11:38:52 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:51103 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhHIPip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 11:38:45 -0400
Received: by mail-io1-f72.google.com with SMTP id e18-20020a5d92520000b029057d0eab404aso12715556iol.17
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 08:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2AWmyZbYF2miWHRd07OXoGKLLhbkOyy6We+e1i3wDoc=;
        b=HDOHNk1S34OZaIzvH3ywanrRmHuQfmzWN46SxB2lTNzrJGVui+6ImbqTdoO6MeLJ3d
         9yBJNbYgBoJ5m2hgPrNq4oIBFeoRVko0EMXYDBWzcZ6a4AbYyEFjpD5TEFPcb6OzAHs+
         2VAdtWgULAtVMyhBnpYfTw9f7steXl2U3uOQwkFflWCKWZY207wYWrKXdDMY6LAQU4lx
         CNxOzuVaTfFgWrvBTFUie6Yvh4WfWVf7PbCLaOADdco4I4crVf9k94n/NR08e9m2VM78
         zmvdZ6JbMkc5ejuORoAjFvHtG4RW1lcr1ZF98IdumCNxeSze3FhgkelAJIMLNIsBAS6r
         8tLQ==
X-Gm-Message-State: AOAM533RpLakRAl0ymWtGeSa3uO6WQgHLi7aYeAVQvOnFgDRokv+mYC1
        Nc713WoS7ZID+tFDBebhATTcbu38+6km3chQuQUVdzSQsRBQ
X-Google-Smtp-Source: ABdhPJxp86uGTQexH7AMPAi1cbwGD52Vm/Jx4CcXokDitnEb6QNM9zQDTgYdSIQBa/87hoMMq/H3nXlHP6DSMTV+3kN1ptxjSOgW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:106d:: with SMTP id q13mr337344ilj.164.1628523504883;
 Mon, 09 Aug 2021 08:38:24 -0700 (PDT)
Date:   Mon, 09 Aug 2021 08:38:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000004601605c9222d92@google.com>
Subject: [syzbot] WARNING in destroy_conntrack
From:   syzbot <syzbot+a1eb62c681423ee5c0d7@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12755626300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=a1eb62c681423ee5c0d7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1241d9d6300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168e66e9300000

The issue was bisected to:

commit 65038428b2c6c5be79d3f78a6b79c0cdc3a58a41
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue Mar 17 13:13:46 2020 +0000

    netfilter: nf_tables: allow to specify stateful expression in set definition

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1683f1f1300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1583f1f1300000
console output: https://syzkaller.appspot.com/x/log.txt?x=1183f1f1300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a1eb62c681423ee5c0d7@syzkaller.appspotmail.com
Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8989 at net/netfilter/nf_conntrack_core.c:610 destroy_conntrack+0x232/0x2c0 net/netfilter/nf_conntrack_core.c:610
Modules linked in:
CPU: 0 PID: 8989 Comm: syz-executor188 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:destroy_conntrack+0x232/0x2c0 net/netfilter/nf_conntrack_core.c:610
Code: da fc ff eb 90 e8 ae 27 19 fa 48 89 ef e8 c6 53 02 00 48 89 ef e8 ee 1c 5f fa 5b 5d 41 5c 41 5d e9 93 27 19 fa e8 8e 27 19 fa <0f> 0b e9 2f fe ff ff e8 82 27 19 fa 4c 8d a5 e8 00 00 00 48 b8 00
RSP: 0018:ffffc90002d7f080 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000000000000
RDX: ffff88802eeb8000 RSI: ffffffff875c8632 RDI: 0000000000000003
RBP: ffff888147d35400 R08: 0000000000000000 R09: ffff888147d35403
R10: ffffffff875c8460 R11: 0000000000000000 R12: ffff888147d35400
R13: ffffffff8b31b880 R14: 0000000000000000 R15: 0000000000000001
FS:  00007fb18d49a700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f37c403d088 CR3: 00000000182c1000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nf_conntrack_destroy+0xab/0x230 net/netfilter/core.c:677
 nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:34 [inline]
 nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
 nft_ct_tmpl_put_pcpu+0x15e/0x1e0 net/netfilter/nft_ct.c:356
 __nft_ct_set_destroy net/netfilter/nft_ct.c:529 [inline]
 __nft_ct_set_destroy net/netfilter/nft_ct.c:518 [inline]
 nft_ct_set_init+0x41e/0x750 net/netfilter/nft_ct.c:614
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
 nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
 nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
 nf_tables_newset+0x20cb/0x3340 net/netfilter/nf_tables_api.c:4389
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4477b9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 16 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb18d49a318 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004d2298 RCX: 00000000004477b9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000004d2290 R08: 0000000000007463 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004d229c
R13: 00007ffe3c4609ef R14: 00007fb18d49a400 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
