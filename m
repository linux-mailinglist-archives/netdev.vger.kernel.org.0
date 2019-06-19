Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A314BD35
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 17:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbfFSPrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 11:47:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:36472 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFSPrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 11:47:08 -0400
Received: by mail-io1-f71.google.com with SMTP id k21so21776550ioj.3
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 08:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HcDITllUPfSPDG1JQqG6leFos4NEv4NFO7VcX2wuMAM=;
        b=Z+LSb/76XXkCuQJWBtBtihRQhvsxZnSJC0v4a0cBi5GrphXjUtIJ+LCugvEfRcwdgU
         /cmo2/sC34Pce2n47ZAiLbyrmRSmRMsaRaxoFKjmkZQG/MDyOTP3qytRIkZxrf2UpEWb
         Xu1XJlmRjUDqTWGwpFvU7+J/P6y84LOMtFxfTxN9qnU2SGatkkOIKCGLSivmtvp8TnIR
         yZAJQoFGMztefTM/ocnuF+bpcze8PMPKNwfMZTpnPIei/Ep+8UhcsjbdTyvfa9X3/kZl
         Z7xbAaYzqRJkCMztlygavU7n7SCpCQVivazBn9ASlO4Lp43aZRLkAUOyHCCgkZP2c2zW
         AUow==
X-Gm-Message-State: APjAAAUbIzfwuGWPIqz2hzwjsSy0WEgburrb2AcrJwTY1uzE8ePXlQan
        ssYXBnRBfn9dHmukUpv8t5WquPXIx1rPcouyRHiTjfpinceo
X-Google-Smtp-Source: APXvYqzHT+/h5fzHBH9/4STY90y7enbUfAXXMhdUUAhSQrtLQji30V+Q0KFaTyRBM1d+dDCB1/lW2XSmUUkJECIoXf6PsZcY5dQy
MIME-Version: 1.0
X-Received: by 2002:a6b:b843:: with SMTP id i64mr3626822iof.81.1560959227406;
 Wed, 19 Jun 2019 08:47:07 -0700 (PDT)
Date:   Wed, 19 Jun 2019 08:47:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004237d7058baf24e3@google.com>
Subject: general protection fault in call_fib6_multipath_entry_notifiers
From:   syzbot <syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@gmail.com, idosch@mellanox.com,
        jiri@mellanox.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    39f58860 net/mlx5: add missing void argument to function m..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=115eb99ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4937094fc643655f
dashboard link: https://syzkaller.appspot.com/bug?extid=382566d339d52cd1a204
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120c9e11a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120c3d21a00000

The bug was bisected to:

commit ebee3cad835f7fe7250213225cf6d62c7cf3b2ca
Author: Ido Schimmel <idosch@mellanox.com>
Date:   Tue Jun 18 15:12:48 2019 +0000

     ipv6: Add IPv6 multipath notifications for add / replace

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1529970aa00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1729970aa00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1329970aa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com
Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add /  
replace")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9190 Comm: syz-executor149 Not tainted 5.2.0-rc5+ #38
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:call_fib6_multipath_entry_notifiers+0xd1/0x1a0  
net/ipv6/ip6_fib.c:396
Code: 8b b5 30 ff ff ff 48 c7 85 68 ff ff ff 00 00 00 00 48 c7 85 70 ff ff  
ff 00 00 00 00 89 45 88 4c 89 e0 48 c1 e8 03 4c 89 65 80 <42> 80 3c 28 00  
0f 85 9a 00 00 00 48 b8 00 00 00 00 00 fc ff df 4d
RSP: 0018:ffff88809788f2c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff11012f11e59 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88809788f390 R08: ffff88809788f8c0 R09: 000000000000000c
R10: ffff88809788f5d8 R11: ffff88809788f527 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff88809788f8c0 R15: ffffffff89541d80
FS:  000055555632c880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000009ba7c000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip6_route_multipath_add+0xc55/0x1490 net/ipv6/route.c:5094
  inet6_rtm_newroute+0xed/0x180 net/ipv6/route.c:5208
  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5219
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5237
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:665
  ___sys_sendmsg+0x803/0x920 net/socket.c:2286
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2324
  __do_sys_sendmsg net/socket.c:2333 [inline]
  __se_sys_sendmsg net/socket.c:2331 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2331
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc09fd0028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 77949df4cfac115c ]---
RIP: 0010:call_fib6_multipath_entry_notifiers+0xd1/0x1a0  
net/ipv6/ip6_fib.c:396
Code: 8b b5 30 ff ff ff 48 c7 85 68 ff ff ff 00 00 00 00 48 c7 85 70 ff ff  
ff 00 00 00 00 89 45 88 4c 89 e0 48 c1 e8 03 4c 89 65 80 <42> 80 3c 28 00  
0f 85 9a 00 00 00 48 b8 00 00 00 00 00 fc ff df 4d
RSP: 0018:ffff88809788f2c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff11012f11e59 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88809788f390 R08: ffff88809788f8c0 R09: 000000000000000c
R10: ffff88809788f5d8 R11: ffff88809788f527 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff88809788f8c0 R15: ffffffff89541d80
FS:  000055555632c880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000009ba7c000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
