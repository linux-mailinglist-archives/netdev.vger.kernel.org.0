Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE0F2057F9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbgFWQ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:56:21 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52261 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbgFWQ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:56:19 -0400
Received: by mail-io1-f71.google.com with SMTP id p8so15511272ios.19
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:56:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JshClNTAlS3z2QGUcLPz9c4kM4qXO8CMuBvsuSHGHcM=;
        b=IsHHdsYuhLxM8JOnqwEQEc+HTqGG8cBQtWZHWRnUYaUVmM26+xRUBslGkTUBxS2YIh
         gWC/hZeZe3RgqJuyZhz7lF11JSz/BdIg9jPmEe72TnpqPQJ8xxkfKQ9ogazFnTUjBqmd
         sguNS7TKoGTe5uKql5RK0T/7x5I8fW7q7U6VQhRGZghQlKX/JzAQE4+emiN0OjtrhYIi
         6lZKIg71epzL+dqDWfIz9P7K+Yqs9ITSWJw+blzQSqJNsKo1GqDxQtGQUnZYPzwLX7Xc
         pEsoYJIMjSkYnecSDbbCj3Hsa7LWoLAeBp3msrsQyGmNqsShgzsxXJMmLeul7Qr2Z2WG
         8wVg==
X-Gm-Message-State: AOAM53229cjzReNjRZjVdBKom9esFHldoXTiGYKG5nxAVu72JczoqncN
        BxiapP0U66ekr+BpF3pG2I0oumV9PKvetrTSr7RGp+atR/eg
X-Google-Smtp-Source: ABdhPJzr23dc+NwpOLI07qgaM1Kky9DbwM87Tvp7h3jgisjlayHd4sQ5bE0KEGmtw1rDUaTS5g8r8gKb9YGLCb6Hets7766dYliI
MIME-Version: 1.0
X-Received: by 2002:a92:aa92:: with SMTP id p18mr5067484ill.199.1592931379091;
 Tue, 23 Jun 2020 09:56:19 -0700 (PDT)
Date:   Tue, 23 Jun 2020 09:56:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000009e7b05a8c33d11@google.com>
Subject: KASAN: vmalloc-out-of-bounds Read in tipc_nl_node_dump_monitor_peer
From:   syzbot <syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com>
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

HEAD commit:    4e15507f libbpf: Forward-declare bpf_stats_type for system..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1227a0ad100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
dashboard link: https://syzkaller.appspot.com/bug?extid=80cad1e3cb4c41cde6ff
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155fef15100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127acae9100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in nla_len include/net/netlink.h:1135 [inline]
BUG: KASAN: vmalloc-out-of-bounds in nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
BUG: KASAN: vmalloc-out-of-bounds in tipc_nl_node_dump_monitor_peer+0x4da/0x590 net/tipc/node.c:2788
Read of size 2 at addr ffffc90004959024 by task syz-executor857/7189

CPU: 1 PID: 7189 Comm: syz-executor857 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 nla_len include/net/netlink.h:1135 [inline]
 nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
 tipc_nl_node_dump_monitor_peer+0x4da/0x590 net/tipc/node.c:2788
 genl_lock_dumpit+0x7f/0xb0 net/netlink/genetlink.c:575
 netlink_dump+0x4cd/0xf60 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2353
 genl_family_rcv_msg_dumpit+0x2ac/0x310 net/netlink/genetlink.c:638
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0x797/0x9e0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446859
Code: Bad RIP value.
RSP: 002b:00007f102ce25d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446859
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 4002001060fc2413 R14: 0d94638c64805ad2 R15: 0f05002d0000022e


Memory state around the buggy address:
 ffffc90004958f00: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
 ffffc90004958f80: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
>ffffc90004959000: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
                               ^
 ffffc90004959080: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
 ffffc90004959100: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
