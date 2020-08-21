Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C8F24D883
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgHUP1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:27:36 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:38453 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgHUP1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:27:18 -0400
Received: by mail-il1-f197.google.com with SMTP id t79so1670388ild.5
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oRlhEl9y3UG47TJfhMloMYOjluaCt1sb2BEiuCSJ7NI=;
        b=eYgGEIcZyuSEerQhN3s2U4MBiHONYmFbHyn7j4XDcSAQyhGnTAOBEJ1jdu/+e3Hvz3
         Y1TvmpWZD3VkvNAiK3r+gxIi2TfQBatHW4qKeeNdJZgCRsUw+CTCPai6R+9WpTHMokdl
         6rUwagP2obdXuKnDDX22l1pXxZR4t75zbeP2GaifVbdSNbBF2xbQbRnycWAFhQzeD0tF
         rFhKIPd53xjCFrSOgBUMtk8KPr6fg7mQXQRF8bcNBx0+dWF0Q3cjjYyQXJQLr2ItXJkm
         3RaH3zM/sATc4ipZxkHhOW23xKzVGDu6n1CwlaVm7lhx9RFgjKVfH7ppEwbb17AfRFtu
         jbsQ==
X-Gm-Message-State: AOAM530K+FheWRHqnGM2xEyyaswLDbHfA9fZPS1YwEL+NGdJmEiM2wFI
        E+jOMdTKy9h50232Cg62rSAZpi4/iBumuGvPro8KvQrS0U52
X-Google-Smtp-Source: ABdhPJz/7pnITgCgm8CtpXFil5SbjNTzEkS1E7GV2CPChtipYAvzWzyO9rn84WSXLWWTkyV5zrjF1034OfDD4Cg4WMmCOrnMw1i/
MIME-Version: 1.0
X-Received: by 2002:a02:95ab:: with SMTP id b40mr3017406jai.14.1598023636980;
 Fri, 21 Aug 2020 08:27:16 -0700 (PDT)
Date:   Fri, 21 Aug 2020 08:27:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039b10005ad64df20@google.com>
Subject: general protection fault in fib_dump_info (2)
From:   syzbot <syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@gmail.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    da2968ff Merge tag 'pci-v5.9-fixes-1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137316ca900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=a61aa19b0c14c8770bd9
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12707051900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1150a046900000

The issue was bisected to:

commit 0b5e2e39739e861fa5fc84ab27a35dbe62a15330
Author: David Ahern <dsahern@gmail.com>
Date:   Tue May 26 18:56:16 2020 +0000

    nexthop: Expand nexthop_is_multipath in a few places

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=139cec66900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=105cec66900000
console output: https://syzkaller.appspot.com/x/log.txt?x=179cec66900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
Fixes: 0b5e2e39739e ("nexthop: Expand nexthop_is_multipath in a few places")

general protection fault, probably for non-canonical address 0xdffffc0000000010: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
CPU: 0 PID: 6830 Comm: syz-executor644 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nexthop_is_blackhole include/net/nexthop.h:240 [inline]
RIP: 0010:fib_dump_info+0x893/0x1f00 net/ipv4/fib_semantics.c:1781
Code: 3c 02 00 0f 85 83 15 00 00 4d 8b 6d 10 e8 85 f1 ab fa 49 8d bd 80 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 62 15 00 00 4d 8b ad 80 00 00 00 e8 37 e2 2a 01
RSP: 0018:ffffc90001d37248 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888093b02000 RCX: ffffffff86c84d53
RDX: 0000000000000010 RSI: ffffffff86c84d8b RDI: 0000000000000080
RBP: ffff88809f95a017 R08: 0000000000000001 R09: ffff88809f95a02b
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88809f95a000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880a7164a40
FS:  0000000000000000(0000) GS:ffff8880ae600000(0063) knlGS:0000000009af2840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000300 CR3: 0000000099698000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rtmsg_fib+0x318/0xdf0 net/ipv4/fib_semantics.c:524
 fib_table_insert+0x1383/0x1af0 net/ipv4/fib_trie.c:1284
 inet_rtm_newroute+0x109/0x1e0 net/ipv4/fib_frontend.c:883
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x57/0x80 arch/x86/entry/common.c:126
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f66549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffba6bdc EFLAGS: 00000282 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000580
RDX: 0000000000000000 RSI: 00000000080ea00c RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace ca6d5d9f281019b7 ]---
RIP: 0010:nexthop_is_blackhole include/net/nexthop.h:240 [inline]
RIP: 0010:fib_dump_info+0x893/0x1f00 net/ipv4/fib_semantics.c:1781
Code: 3c 02 00 0f 85 83 15 00 00 4d 8b 6d 10 e8 85 f1 ab fa 49 8d bd 80 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 62 15 00 00 4d 8b ad 80 00 00 00 e8 37 e2 2a 01
RSP: 0018:ffffc90001d37248 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888093b02000 RCX: ffffffff86c84d53
RDX: 0000000000000010 RSI: ffffffff86c84d8b RDI: 0000000000000080
RBP: ffff88809f95a017 R08: 0000000000000001 R09: ffff88809f95a02b
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88809f95a000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880a7164a40
FS:  0000000000000000(0000) GS:ffff8880ae600000(0063) knlGS:0000000009af2840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00007f3f0e891000 CR3: 0000000099698000 CR4: 00000000001506f0
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
