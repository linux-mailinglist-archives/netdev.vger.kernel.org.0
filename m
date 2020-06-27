Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4A220BDC8
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 04:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgF0CzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 22:55:15 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:45625 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgF0CzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 22:55:15 -0400
Received: by mail-il1-f197.google.com with SMTP id c1so7689946ilk.12
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 19:55:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rQlIfEWzOqXAPiQvq9J83xQmyCx1O/uoaraUr4XXD/k=;
        b=Gw1vOFjOcBwdIChxIaVG6NS7MPBZ+f/tcAatRrpSzpMb9l7mymVSN1XOIkfc1ZL0ie
         ejJA1tvAC9W5LbMGD6A1aqJ0ETspJ10CgcnGtJuLjAp3TyVROfOiMyrcqZi91cjPB9zv
         mYparDa7xreD4oFAGC0ghB7X+uPibDr9UXhnTH8JE5FmJqqHZK3VswjB6oGdEy5pvMRM
         ieXkfOQWvQRbZ3/CvxGj5KwvYg6rnwssbk9wWNWOO+Afjqe5cc1ETLK4QDLpFXTvxD9b
         38yQNTRQMPX1zv8cegzM2c50gFeYfHtf33r+zBhIBvIhQmJ+XUfMNvS5/2XSeRxgeWZh
         6UHQ==
X-Gm-Message-State: AOAM533Q+47HM/NRwATDq2sUmNm3GfgUNDlbt63YeWQetA1BASJ3BLji
        /w+8M/gKFcViPqWWCBp9/m8NtawqAfZv/D0Qt1bAEAZ2lwRy
X-Google-Smtp-Source: ABdhPJwJ8ewJazwy5qseAEfqZYpdG2OW1bXNNdqa3tJM9z6tI05tkIGZuPTgBfPsBEklPeRjh7ty4pX/lyKRID/80G79kIoBi3mn
MIME-Version: 1.0
X-Received: by 2002:a02:69d3:: with SMTP id e202mr6405093jac.15.1593226513990;
 Fri, 26 Jun 2020 19:55:13 -0700 (PDT)
Date:   Fri, 26 Jun 2020 19:55:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000069c84c05a907f415@google.com>
Subject: KASAN: use-after-free Read in tipc_nl_node_dump_monitor_peer (2)
From:   syzbot <syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1364f2e5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c907630cbdbe5
dashboard link: https://syzkaller.appspot.com/bug?extid=c96e4dfb32f8987fdeed
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16802239100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1410b223100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nla_len include/net/netlink.h:1135 [inline]
BUG: KASAN: use-after-free in nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
BUG: KASAN: use-after-free in tipc_nl_node_dump_monitor_peer+0x566/0x590 net/tipc/node.c:2788
Read of size 2 at addr ffff8880a4b0a814 by task syz-executor823/6893

CPU: 0 PID: 6893 Comm: syz-executor823 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 nla_len include/net/netlink.h:1135 [inline]
 nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
 tipc_nl_node_dump_monitor_peer+0x566/0x590 net/tipc/node.c:2788
 genl_lock_dumpit+0x86/0xa0 net/netlink/genetlink.c:575
 netlink_dump+0x4be/0x10d0 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x538/0x700 net/netlink/af_netlink.c:2353
 genl_family_rcv_msg_dumpit net/netlink/genetlink.c:638 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0xb03/0xe00 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4452a9
Code: Bad RIP value.
RSP: 002b:00007fff822c3fa8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004452a9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000000134d3 R08: 00000000004002e0 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402440
R13: 00000000004024d0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6892:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xde/0x4f0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x7b2/0xd70 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6892:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 skb_release_all net/core/skbuff.c:664 [inline]
 __kfree_skb+0x56/0x1c0 net/core/skbuff.c:678
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x78e/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a4b0a800
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 20 bytes inside of
 512-byte region [ffff8880a4b0a800, ffff8880a4b0aa00)
The buggy address belongs to the page:
page:ffffea000292c280 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027f8d08 ffffea00029ebe88 ffff8880aa400a80
raw: 0000000000000000 ffff8880a4b0a000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a4b0a700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a4b0a780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a4b0a800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880a4b0a880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a4b0a900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
