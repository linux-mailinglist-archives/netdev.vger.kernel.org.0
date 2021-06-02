Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41D8399019
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFBQjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:39:12 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:42921 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhFBQjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:39:10 -0400
Received: by mail-il1-f198.google.com with SMTP id d17-20020a9236110000b02901cf25fcfdcdso2012321ila.9
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ScaWggXPBbQZ+j9iOKCUD+/Tr2hnGHxfC2G9+IXCng0=;
        b=ZHvC5alTJbD7lnq8T5PWXtGgVnkZ2hKQwJojx5/zTKTm+iFDkq7CjOLF4TpXiPN6V9
         gGGezovK+UtOA2KnnEJZullar6fXMk1K2JvHxaJ1dy1a/aEMWHhygipj9I8OaFwGQXCB
         id2za90+fYNj92EGeRBZe8JP0q/7pz9frbyaNuG+AoNYmqxYN6k+HlLAyRd67WnYRipP
         hUTQl50eh7zvv057vaMoFIbZnuz0vFHDzBm3EktFPE7TQ8qtSbgj6ispx8fDLoo51DJg
         xuGf0HmThe08ouskr4kET8a1FyUFPk//hudgP44eVoHIWf6HXhdcJqDrabre7J+hG16J
         MzSA==
X-Gm-Message-State: AOAM5314v7TqEEeiIu/maYZHn/Ru4r5siMfHUJ5ycouh5MJR/Tx6QIo+
        kQHfkNk8TWpJGHAwH8+xg0lz9HrlqLsntT9KuekIrk97BgUP
X-Google-Smtp-Source: ABdhPJxAcIXnKkgcCVqanUnxxQ2yn32HsIrHELvpKVrza6Kh4f2/2nScpSkceUrWkb84Ss25ZJWsV7gLElsuqNVqA+pUtfe2fXVh
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b83:: with SMTP id h3mr24952646ili.199.1622651846984;
 Wed, 02 Jun 2021 09:37:26 -0700 (PDT)
Date:   Wed, 02 Jun 2021 09:37:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef07b205c3cb1234@google.com>
Subject: [syzbot] general protection fault in nft_set_elem_expr_alloc
From:   syzbot <syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com>
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

HEAD commit:    6850ec97 Merge branch 'mptcp-fixes-for-5-13'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1355504dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
dashboard link: https://syzkaller.appspot.com/bug?extid=ce96ca2b1d0b37c6422d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1502d517d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bbbe13d00000

The issue was bisected to:

commit 05abe4456fa376040f6cc3cc6830d2e328723478
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Wed May 20 13:44:37 2020 +0000

    netfilter: nf_tables: allow to register flowtable with no devices

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fa1387d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fa1387d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14fa1387d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com
Fixes: 05abe4456fa3 ("netfilter: nf_tables: allow to register flowtable with no devices")

general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 1 PID: 8438 Comm: syz-executor343 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nft_set_elem_expr_alloc+0x17e/0x280 net/netfilter/nf_tables_api.c:5321
Code: 48 c1 ea 03 80 3c 02 00 0f 85 09 01 00 00 49 8b 9d c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d9 00 00 00 48 8b 5b 70 48 85 db 74 21 e8 9a bd
RSP: 0018:ffffc90000fff338 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000000e RSI: ffffffff875b1e90 RDI: 0000000000000070
RBP: ffffc90000fff4a0 R08: fffffffffffff000 R09: 0000000000000000
R10: ffffffff875b1e86 R11: 0000000000000000 R12: ffff88802819f200
R13: ffff888028e11000 R14: ffffffff8dca5260 R15: ffffffff8a714120
FS:  0000000002387300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000190 CR3: 0000000019973000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nf_tables_newset+0x1b78/0x32a0 net/netfilter/nf_tables_api.c:4370
 nfnetlink_rcv_batch+0x1788/0x25c0 net/netfilter/nfnetlink.c:510
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:631 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:649
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f389
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd09f0258 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f389
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 0000000000403370 R08: 0000000000000014 R09: 0000000000400488
R10: 0000000000000074 R11: 0000000000000246 R12: 0000000000403400
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
Modules linked in:
---[ end trace dd21b65109300c05 ]---
RIP: 0010:nft_set_elem_expr_alloc+0x17e/0x280 net/netfilter/nf_tables_api.c:5321
Code: 48 c1 ea 03 80 3c 02 00 0f 85 09 01 00 00 49 8b 9d c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d9 00 00 00 48 8b 5b 70 48 85 db 74 21 e8 9a bd
RSP: 0018:ffffc90000fff338 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000000e RSI: ffffffff875b1e90 RDI: 0000000000000070
RBP: ffffc90000fff4a0 R08: fffffffffffff000 R09: 0000000000000000
R10: ffffffff875b1e86 R11: 0000000000000000 R12: ffff88802819f200
R13: ffff888028e11000 R14: ffffffff8dca5260 R15: ffffffff8a714120
FS:  0000000002387300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa0ba0326c0 CR3: 0000000019973000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
