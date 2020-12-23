Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D2A2E1AF5
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 11:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgLWKZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 05:25:03 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:45352 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgLWKZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 05:25:01 -0500
Received: by mail-io1-f72.google.com with SMTP id x7so9192092ion.12
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 02:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QQuYF4pQJOcWayt5K3dL/v3AiRGyB7xbhwRNrH6/2r4=;
        b=FF6wJODRsqInnwQmDVIT2GAwIN+pcVsDtiU9qp8PYIzTlqgW7taNw0mqXOW4liG0fP
         gcSBbsN/IfIeD6IfoxFstEJJ6RjZDQ+W9qf0+2v9EF/TTrxJGrF2iZ+8sBGZ+TcekZKl
         z7+OlMKwk7WLWDKFhWRBO2ipi6wNkmYZhKskKhzhfhs3vMX1hRQkH4TKvtlmJ2tuOnIh
         xkGwOQftPfoF+bOzUej8jst2k0MjAqTKVVioEButXuHsiHp/uPktw8XL2POSit9dpQBQ
         h9Hu7zmjZfJ+nC0VZZfE7ZYR2DBv9TKF6lK1hbOt0OhKj1NIxUTZXriWib2EsjTkSvTE
         1v2A==
X-Gm-Message-State: AOAM531uTxBamAdj0uFDOdjZiYzQJIXYc2GBI4V+szpM2CotfZZaDlA+
        /bitWyADrHunndpwb+cJOOEpG4hZuylZA7tW+6ySOVWmjVZe
X-Google-Smtp-Source: ABdhPJxKk9sLiqNaDSr6Rda5ORnrcqLaAg7IgNKfpP4eYf7As0Nq4QGsumWMTBk8en+7cJdDq/v/8lltDXjm537peNKhJ61jdzOf
MIME-Version: 1.0
X-Received: by 2002:a6b:b2c3:: with SMTP id b186mr20870103iof.126.1608719060607;
 Wed, 23 Dec 2020 02:24:20 -0800 (PST)
Date:   Wed, 23 Dec 2020 02:24:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026aa7905b71f183a@google.com>
Subject: UBSAN: object-size-mismatch in tipc_sk_filter_rcv
From:   syzbot <syzbot+bc0b77f2a9209716067f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5e60366d Merge tag 'fallthrough-fixes-clang-5.11-rc1' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11913e0f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=267a60b188ded8ed
dashboard link: https://syzkaller.appspot.com/bug?extid=bc0b77f2a9209716067f
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bc0b77f2a9209716067f@syzkaller.appspotmail.com

================================================================================
UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2021:28
member access within address 000000002c1825a5 with insufficient space
for an object of type 'struct sk_buff'
CPU: 1 PID: 9846 Comm: syz-executor.1 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 handle_object_size_mismatch lib/ubsan.c:297 [inline]
 ubsan_type_mismatch_common+0x1e2/0x390 lib/ubsan.c:310
 __ubsan_handle_type_mismatch_v1+0x41/0x50 lib/ubsan.c:339
 __skb_queue_before include/linux/skbuff.h:2021 [inline]
 __skb_queue_tail include/linux/skbuff.h:2054 [inline]
 tipc_sk_filter_rcv+0x2bf/0x2330 net/tipc/socket.c:2342
 tipc_sk_enqueue net/tipc/socket.c:2438 [inline]
 tipc_sk_rcv+0x3d9/0xf80 net/tipc/socket.c:2490
 tipc_node_xmit+0x285/0xb10 net/tipc/node.c:1689
 __tipc_sendmsg+0x1cbe/0x2f90 net/tipc/socket.c:1524
 tipc_sendmsg+0x51/0x70 net/tipc/socket.c:1409
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xc1/0xf0 net/socket.c:672
 ____sys_sendmsg+0x4b3/0x840 net/socket.c:2336
 ___sys_sendmsg net/socket.c:2390 [inline]
 __sys_sendmmsg+0x3de/0x860 net/socket.c:2480
 __do_sys_sendmmsg net/socket.c:2509 [inline]
 __se_sys_sendmmsg net/socket.c:2506 [inline]
 __x64_sys_sendmmsg+0x9c/0xb0 net/socket.c:2506
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e149
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20231a6c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000045e149
RDX: 0000000000000002 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000119bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffd81950ccf R14: 00007f20231a79c0 R15: 000000000119bf8c
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
