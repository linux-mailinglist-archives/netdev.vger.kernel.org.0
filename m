Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D2722213
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 09:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfERHeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 03:34:06 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:55242 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfERHeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 03:34:06 -0400
Received: by mail-it1-f199.google.com with SMTP id k8so8704140itd.4
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 00:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6cOhUqDBTNuDCsm6/KkPyzSPG5CwBmbnSt8sCm1qFcs=;
        b=E8xx4d2/2ey+g5baBuoCCjhHoEHZlBznmqOlbj4ecrVQnc8IYt/zwsAh3KzBuHdx82
         359kfF9PR+FfOoGj166h6tG+B3uqX6tA/j9AUe4uM8MVmhahWQVs5W0a22ZCuuoyQ6k/
         ooHvRwnv0oyzwIFTzetpsszA7YwuOis4q/znPL3K7cQWDPlL8YtEJnIvDEB+nYPdq9Py
         JqsJiG3nVffI9w9RzLiI9WPjy8vGUi3U96bYMFZYCdla6J1JDRPm489I9ui3GNloHlqy
         NctbwYXGvAuydbQqn9b+fS+TCsX0Y7h7M8IY4gtibAN0zSCqq8K0q7Dt4zWverJoocfh
         rRoQ==
X-Gm-Message-State: APjAAAUprndjArkYk3ZDVgJba/19rGYeVgzXTIJJdheUAG8iSZRXK5O2
        Ofh+QzYM5CM3dy6QQAKc4b6AnzWqT6zeMss2PhDvJHBofdtT
X-Google-Smtp-Source: APXvYqyexnNpF8ZFJY2kef94sLG3owM8ucOKbX0IFpkLEOs1tYXHPRYTWgN3VfdHzwyqKqsZ2Q5E3MITzUvGRt1a6jmPa2YHQnmJ
MIME-Version: 1.0
X-Received: by 2002:a5d:9b90:: with SMTP id r16mr1739027iom.62.1558164844895;
 Sat, 18 May 2019 00:34:04 -0700 (PDT)
Date:   Sat, 18 May 2019 00:34:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014e65905892486ab@google.com>
Subject: INFO: trying to register non-static key in rhashtable_walk_enter
From:   syzbot <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    510e2ced ipv6: fix src addr routing with the exception table
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15b7e608a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=1e8114b61079bfe9cbc5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 27370 Comm: syz-executor.2 Not tainted 5.1.0+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  assign_lock_key kernel/locking/lockdep.c:774 [inline]
  register_lock_class+0x167e/0x1860 kernel/locking/lockdep.c:1083
  __lock_acquire+0x116/0x5490 kernel/locking/lockdep.c:3673
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4302
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  rhashtable_walk_enter+0xf9/0x390 lib/rhashtable.c:669
  __tipc_dump_start+0x1fa/0x3c0 net/tipc/socket.c:3414
  tipc_dump_start+0x70/0x90 net/tipc/socket.c:3396
  __netlink_dump_start+0x4fb/0x7e0 net/netlink/af_netlink.c:2351
  netlink_dump_start include/linux/netlink.h:226 [inline]
  tipc_sock_diag_handler_dump+0x1d9/0x270 net/tipc/diag.c:91
  __sock_diag_cmd net/core/sock_diag.c:232 [inline]
  sock_diag_rcv_msg+0x322/0x410 net/core/sock_diag.c:263
  netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2486
  sock_diag_rcv+0x2b/0x40 net/core/sock_diag.c:274
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:660 [inline]
  sock_sendmsg+0x12e/0x170 net/socket.c:671
  ___sys_sendmsg+0x81d/0x960 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0x103/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fea7516cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fea7516d6d4
R13: 00000000004c6790 R14: 00000000004db3e8 R15: 00000000ffffffff
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 27370 Comm: syz-executor.2 Not tainted 5.1.0+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_add_valid+0x27/0xa0 lib/list_debug.c:23
Code: 90 90 90 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 55 49 89 fd 48  
8d 7a 08 41 54 49 89 d4 48 89 fa 48 83 ec 08 48 c1 ea 03 <80> 3c 02 00 75  
52 49 8b 54 24 08 48 39 f2 0f 85 5a 01 00 00 48 b8
RSP: 0018:ffff888086ee7608 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffff88808d9e2a80 RCX: ffff88808d9e2a98
RDX: 007d58291f51291c RSI: ffffffff85f1d1ae RDI: 03eac148fa8948e7
RBP: ffff888086ee7620 R08: ffff8880a65d8280 R09: ffffed1010ddceb4
R10: ffffed1010ddceb3 R11: 0000000000000003 R12: 03eac148fa8948df
R13: ffff88808d9e2a98 R14: ffffffff85f1d19e R15: ffffffff85f1d1ae
FS:  00007fea7516d700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000015b77d0 CR3: 0000000076601000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_add include/linux/list.h:60 [inline]
  list_add include/linux/list.h:79 [inline]
  rhashtable_walk_enter+0x1b0/0x390 lib/rhashtable.c:672
  __tipc_dump_start+0x1fa/0x3c0 net/tipc/socket.c:3414
  tipc_dump_start+0x70/0x90 net/tipc/socket.c:3396
  __netlink_dump_start+0x4fb/0x7e0 net/netlink/af_netlink.c:2351
  netlink_dump_start include/linux/netlink.h:226 [inline]
  tipc_sock_diag_handler_dump+0x1d9/0x270 net/tipc/diag.c:91
  __sock_diag_cmd net/core/sock_diag.c:232 [inline]
  sock_diag_rcv_msg+0x322/0x410 net/core/sock_diag.c:263
  netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2486
  sock_diag_rcv+0x2b/0x40 net/core/sock_diag.c:274
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:660 [inline]
  sock_sendmsg+0x12e/0x170 net/socket.c:671
  ___sys_sendmsg+0x81d/0x960 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0x103/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fea7516cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fea7516d6d4
R13: 00000000004c6790 R14: 00000000004db3e8 R15: 00000000ffffffff
Modules linked in:
---[ end trace dc952ec41476acbb ]---
RIP: 0010:__list_add_valid+0x27/0xa0 lib/list_debug.c:23
Code: 90 90 90 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 55 49 89 fd 48  
8d 7a 08 41 54 49 89 d4 48 89 fa 48 83 ec 08 48 c1 ea 03 <80> 3c 02 00 75  
52 49 8b 54 24 08 48 39 f2 0f 85 5a 01 00 00 48 b8
RSP: 0018:ffff888086ee7608 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffff88808d9e2a80 RCX: ffff88808d9e2a98
RDX: 007d58291f51291c RSI: ffffffff85f1d1ae RDI: 03eac148fa8948e7
RBP: ffff888086ee7620 R08: ffff8880a65d8280 R09: ffffed1010ddceb4
R10: ffffed1010ddceb3 R11: 0000000000000003 R12: 03eac148fa8948df
R13: ffff88808d9e2a98 R14: ffffffff85f1d19e R15: ffffffff85f1d1ae
FS:  00007fea7516d700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000015b77d0 CR3: 0000000076601000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
