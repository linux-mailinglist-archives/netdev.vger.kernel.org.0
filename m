Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB6722209
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 09:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfERH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 03:28:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:38674 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbfERH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 03:28:06 -0400
Received: by mail-io1-f70.google.com with SMTP id b16so7237057iot.5
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 00:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vlBVhwcjWr1stHkXYLRIcPCx5xGI39meNwnHI95eTFU=;
        b=n6iPpGWwPssayr48cn5BpQElei2BA+8DQdznzaYD4mhJw8ts/q3VH5UjlaGK/Lw3RN
         eIs3D8sTK5Z/WeDiBXAD+XAb9F3cVMjjPW75+Hfzi059OCA28ttLzKt3zJ4qWf/IeeeB
         XubsaJDYVAfJGy2dJ3d5dh9oVAF4egKTnZyVYUAJSi56nomd21/3sCACWR9xaw4HWHAx
         VbWGQAx/zRreoaleMT9quSY0486veslrIAqZDjZyi6FKSbQcYfauIWpI1PGBCRJ7D9z5
         02sqhA/MfmXCjtbgsnO53vb8t6kRAFuIGEkkjjSGBFN/p5Ctnpln3K1q3nRRlhSnzfmN
         ZIZQ==
X-Gm-Message-State: APjAAAWAg9l9Kf/P4Kq/zqHXUexBcpFq311HgATVJLNIpCZ/xVjJJkkq
        z3nd3UwnLzn5G1Iicma/gOmSTgaC19f8+NtXlkaxRgqYsrUD
X-Google-Smtp-Source: APXvYqynnfJD9oOmYso4d8nL1nFkMbUo4OiiqhOr+blRXBxywsNy0JEdAMTTWQK4NJ1IyMBzJM3MUwj7dovYAkKM0RXhuCfazC8u
MIME-Version: 1.0
X-Received: by 2002:a24:8245:: with SMTP id t66mr18695527itd.121.1558164485736;
 Sat, 18 May 2019 00:28:05 -0700 (PDT)
Date:   Sat, 18 May 2019 00:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac9447058924709c@google.com>
Subject: WARNING: locking bug in rhashtable_walk_enter
From:   syzbot <syzbot+6440134c13554d3abfb0@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=11079cf8a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=6440134c13554d3abfb0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1055ac6ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d5658ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6440134c13554d3abfb0@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(class_idx > MAX_LOCKDEP_KEYS)
WARNING: CPU: 0 PID: 9008 at kernel/locking/lockdep.c:3764  
__lock_acquire+0x17b5/0x5490 kernel/locking/lockdep.c:3764
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9008 Comm: syz-executor616 Not tainted 5.1.0+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x65c kernel/panic.c:214
  __warn.cold+0x20/0x45 kernel/panic.c:566
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:180 [inline]
  fixup_bug arch/x86/kernel/traps.c:175 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:273
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:292
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:972
RIP: 0010:__lock_acquire+0x17b5/0x5490 kernel/locking/lockdep.c:3764
Code: d2 0f 85 c7 2c 00 00 44 8b 3d 07 46 09 08 45 85 ff 0f 85 57 f3 ff ff  
48 c7 c6 c0 53 6b 87 48 c7 c7 a0 2a 6b 87 e8 f9 f0 eb ff <0f> 0b e9 40 f3  
ff ff 0f 0b e9 83 f1 ff ff 8b 0d e7 52 ee 08 85 c9
RSP: 0018:ffff888085edf3e0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815afbe6 RDI: ffffed1010bdbe6e
RBP: ffff888085edf588 R08: ffff8880a41cc5c0 R09: fffffbfff1133055
R10: fffffbfff1133054 R11: ffffffff889982a3 R12: 00000000a508a4ad
R13: 0000000000000000 R14: 00000000000404ad R15: 0000000000000000
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
RIP: 0033:0x4401f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffce1688958 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
