Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5875D41A
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGBQRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:17:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34426 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfGBQRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:17:06 -0400
Received: by mail-io1-f71.google.com with SMTP id m1so19433664iop.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Qmk524b00MU6ToPqGyWqdEyJ+Ug/dqtjf66MdS9xRbE=;
        b=NM6qMK1+pR8LGrTkCj4eetkBx/Z3xuUkM+zexB7J2GqekRCrC3ii/6mZ2Vom7yIKix
         Y+bhWbrQdjbcoBEo+ZintN0ZLZxUEGBHOgkZgg+zuFtUGAmvveI4kTK4oj4Axu3h3Yuo
         I/a/0vY3Bh50T4617WJVWfXDL3WfP6y28WAFUXsZqmpQ0lGa3dqmS79qg82zmF5jBeiy
         0I+nK9YqmrqIXyL2jxVxbI+puZrf9HhkcGGRfUXlgOgxseqi17vdc5llKdLZ8haiBi4c
         j4d1X1jEu2YH5wDkZCosfhAgRu6+Ri2nq/391eUvi4RAnoWrSVAaUENLfBrmi4oC3Fpg
         2lAw==
X-Gm-Message-State: APjAAAUZTtiUIqSKqYxs0WqtyasU4NPQYDqMuSKWwxq0ClZ7IUJ8AvRr
        nN1JyIUY58QfSMlStGAJizhMa4xKe3j9wj9BF6q4fti3S3p0
X-Google-Smtp-Source: APXvYqxm+NCBJzRexTyr89ra9l5S7Wa2AwoWb0Qqilvic84NY/mtTpUU6u1F/U3jFonumZb4Q8LmvfFzsrlUYTdROFO8//4Br0FB
MIME-Version: 1.0
X-Received: by 2002:a02:ccdc:: with SMTP id k28mr34239336jaq.41.1562084225610;
 Tue, 02 Jul 2019 09:17:05 -0700 (PDT)
Date:   Tue, 02 Jul 2019 09:17:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000607bf4058cb5135c@google.com>
Subject: WARNING: locking bug in do_ipv6_getsockopt
From:   syzbot <syzbot+babfdd7368c72aac3875@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6fbc7275 Linux 5.2-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13fb8fe5a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6451f0da3d42d53
dashboard link: https://syzkaller.appspot.com/bug?extid=babfdd7368c72aac3875
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1460390ba00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+babfdd7368c72aac3875@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 18374 at kernel/locking/lockdep.c:735  
arch_local_save_flags arch/x86/include/asm/paravirt.h:762 [inline]
WARNING: CPU: 1 PID: 18374 at kernel/locking/lockdep.c:735  
arch_local_save_flags arch/x86/include/asm/paravirt.h:760 [inline]
WARNING: CPU: 1 PID: 18374 at kernel/locking/lockdep.c:735  
look_up_lock_class kernel/locking/lockdep.c:726 [inline]
WARNING: CPU: 1 PID: 18374 at kernel/locking/lockdep.c:735  
register_lock_class+0xe10/0x1860 kernel/locking/lockdep.c:1079
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 18374 Comm: syz-executor.0 Not tainted 5.2.0-rc7 #65
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x744 kernel/panic.c:219
  __warn.cold+0x20/0x4d kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
RIP: 0010:look_up_lock_class kernel/locking/lockdep.c:735 [inline]
RIP: 0010:register_lock_class+0xe10/0x1860 kernel/locking/lockdep.c:1079
Code: 00 48 89 da 4d 8b 76 c0 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80  
3c 02 00 0f 85 23 07 00 00 4c 89 33 e9 e3 f4 ff ff 0f 0b <0f> 0b e9 ea f3  
ff ff 44 89 e0 4c 8b 95 50 ff ff ff 83 c0 01 4c 8b
RSP: 0018:ffff88809ea3f678 EFLAGS: 00010087
RAX: dffffc0000000000 RBX: ffff888090b948e0 RCX: 0000000000000000
RDX: 1ffff1101217291f RSI: 0000000000000000 RDI: ffff888090b948f8
RBP: ffff88809ea3f740 R08: 1ffff11013d47ed7 R09: ffffffff8a65ad40
R10: ffffffff8a2e9180 R11: 0000000000000000 R12: ffffffff8a3243a0
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff88023e60
  __lock_acquire+0x116/0x5490 kernel/locking/lockdep.c:3674
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4303
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  lock_sock_nested+0x41/0x120 net/core/sock.c:2913
  lock_sock include/net/sock.h:1522 [inline]
  do_ipv6_getsockopt.isra.0+0x289/0x2590 net/ipv6/ipv6_sockglue.c:1167
  ipv6_getsockopt+0x186/0x280 net/ipv6/ipv6_sockglue.c:1391
  udpv6_getsockopt+0x68/0xa0 net/ipv6/udp.c:1590
  sock_common_getsockopt+0x94/0xd0 net/core/sock.c:3085
  __sys_getsockopt+0x15f/0x240 net/socket.c:2109
  __do_sys_getsockopt net/socket.c:2120 [inline]
  __se_sys_getsockopt net/socket.c:2117 [inline]
  __x64_sys_getsockopt+0xbe/0x150 net/socket.c:2117
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4597c9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb5fd78ac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00000000004597c9
RDX: 0000000000000036 RSI: 0000000000000029 RDI: 0000000000000004
RBP: 000000000075bfc8 R08: 0000000020000080 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb5fd78b6d4
R13: 00000000004c0803 R14: 00000000004d2b88 R15: 00000000ffffffff
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
