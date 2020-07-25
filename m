Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278F122D92A
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 20:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgGYSNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 14:13:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:50887 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgGYSNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 14:13:21 -0400
Received: by mail-il1-f199.google.com with SMTP id l17so8125434ilj.17
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 11:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=k4uGA3t3jAuxCZnMZ0DJL7nSqCS04UUnj/rEYSLsADI=;
        b=OdPtezkL2id11ZVm4xfiz/5pjW+WQCNeAe3CDav29acKgjBkE9cRiAMYNprZ/caQse
         PLUnCGXnHKYqL18D2F2fX9A5MoKH8VCpYODQznL4muyxgBCB28VgpC1m7wwato/xhvXf
         k+Kz3h5V9q8JL439TD1TZGMkJ60b3vH9xAgf7ZYKnCQyJzzvWBjRPpUYx/iLnOiibUzK
         jVvbpZ/YKO77ctOBnwQTv4FTZkT6usCItiBwwJ8Bc59g8D5CP3uq9TCIN/BlPkEPaP4W
         xoKuckEgSU2HlQrjTBaRGBk9g5FkviWdUdxG9ZTxPjVD30pw9NwLgQVjnA/QgMw39kbD
         q5qQ==
X-Gm-Message-State: AOAM530DzXg0g5IZ+MnM+8IiZ6NgnR/X0NSem+tdhG5caRsZQ5ti2/e7
        JisN4BF4LlOVhTIgo2GaAbORSH0cBGIDoeJW/xPlbG8U6F76
X-Google-Smtp-Source: ABdhPJwFq3zb1nVCNBsL5B/4Tzo2Lq1Drlc2AqfSvQa3wAbu5xxbonENma0WEs6CVwZOEQXHVCs/uPAVE5Iv/G/mdZKUuNSUH9Gt
MIME-Version: 1.0
X-Received: by 2002:a5d:9d58:: with SMTP id k24mr9469028iok.107.1595700800775;
 Sat, 25 Jul 2020 11:13:20 -0700 (PDT)
Date:   Sat, 25 Jul 2020 11:13:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065efbf05ab480bff@google.com>
Subject: KMSAN: uninit-value in strstr
From:   syzbot <syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jmaloy@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    93f54a72 instrumented.h: fix KMSAN support
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=118c3454900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c534a9fad6323722
dashboard link: https://syzkaller.appspot.com/bug?extid=a73d24a22eeeebe5f244
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in strlen lib/string.c:552 [inline]
BUG: KMSAN: uninit-value in strstr+0xfe/0x2e0 lib/string.c:991
CPU: 0 PID: 11587 Comm: syz-executor.0 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1df/0x240 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 strlen lib/string.c:552 [inline]
 strstr+0xfe/0x2e0 lib/string.c:991
 tipc_nl_node_reset_link_stats+0x434/0xa90 net/tipc/node.c:2504
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x1592/0x1740 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x1370/0x1400 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007fb2b7c2ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002ad40 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000003
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 0000000000c9fb6f R14: 00007fb2b7c2f9c0 R15: 000000000078bf0c

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x1370/0x1400 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
