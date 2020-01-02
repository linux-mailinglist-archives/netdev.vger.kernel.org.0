Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C0912E47B
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 10:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgABJfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 04:35:11 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:46483 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727931AbgABJfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 04:35:10 -0500
Received: by mail-io1-f69.google.com with SMTP id p206so25264491iod.13
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 01:35:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vccpKWCKoUf8l6AatqgQWk56oswB+uFCmRgqQNd92sk=;
        b=YrJ53C9J5O4VdnOTnhdlg0P6rnC0bX20ek2SnKYieI8pnqbFzRsvKIoxDkExSGgUXB
         e9jNsUREdogQp1jmBLhUYc+VrVhTSSug6YEEkSi1IzevEGC+fkuhyaTZdE8xeZVHpmxd
         SpJ9fAWwxGhO4CXEP/ptLHKV0ZzcPYXqTnXiLpFe235uAxUmIMXZXf6Zm0mjXPBkuXH5
         6jlBck8XJQPI1Vs+3eo53f4Tr6mhfc9udN1t/Ti56lMnCjIDmSCWiL2CsUc2elK1TtMP
         2KQEl8jBsehO5wSmnuwqLrU9vGHZs8YB0JOiy0a0RW/xluThRmPWP2pXyJyK23rd5h4M
         vweA==
X-Gm-Message-State: APjAAAVtdQs/JSFNAp1OJAG98gxKn4EqOK1Ewf+cR0fihp+CSKIHN3cJ
        4PnwDylpnVFQFbeOOc3yg9f3PRJ5rJNgWVBCP3WcCPOu8o34
X-Google-Smtp-Source: APXvYqwgXiuGJScM9HTvKT1JKowivfEyDa3R3JABkpcQ+SmXuDFJz37fAWalmuc38j0znHS1uZnnEWq11pqt6O3wAlk/6oj1hXLh
MIME-Version: 1.0
X-Received: by 2002:a6b:fc0c:: with SMTP id r12mr51294497ioh.189.1577957709959;
 Thu, 02 Jan 2020 01:35:09 -0800 (PST)
Date:   Thu, 02 Jan 2020 01:35:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c5d741059b24e89d@google.com>
Subject: WARNING: locking bug in __inet6_bind
From:   syzbot <syzbot+414dcdfe035bbcf35fc5@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kafai@fb.com,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    bf8d1cd4 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=155ac9fee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=414dcdfe035bbcf35fc5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1245bac6e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+414dcdfe035bbcf35fc5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 32733 at kernel/locking/lockdep.c:840  
look_up_lock_class kernel/locking/lockdep.c:840 [inline]
WARNING: CPU: 0 PID: 32733 at kernel/locking/lockdep.c:840  
register_lock_class+0x206/0x1850 kernel/locking/lockdep.c:1185
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 32733 Comm: syz-executor.0 Not tainted 5.5.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:look_up_lock_class kernel/locking/lockdep.c:840 [inline]
RIP: 0010:register_lock_class+0x206/0x1850 kernel/locking/lockdep.c:1185
Code: fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 aa 10 00 00 4c 3b 7b  
18 44 8b 35 85 9e 08 0a 74 0b 48 81 3b a0 79 bb 8a 74 02 <0f> 0b 45 85 ed  
0f 84 71 03 00 00 f6 85 70 ff ff ff 01 0f 85 64 03
RSP: 0018:ffffc90003d17a28 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: ffff88809a06d120 RCX: 0000000000000000
RDX: 1ffff1101340da27 RSI: 0000000000000000 RDI: ffff88809a06d138
RBP: ffffc90003d17af0 R08: 1ffff920007a2f4d R09: ffffffff8b63b560
R10: ffffffff8b2c5ce8 R11: 0000000000000000 R12: ffffffff8b3089e0
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff88d4e000
  __lock_acquire+0xf4/0x4a00 kernel/locking/lockdep.c:3837
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  lock_sock_nested+0x41/0x120 net/core/sock.c:2936
  lock_sock include/net/sock.h:1531 [inline]
  __inet6_bind+0x788/0x19b0 net/ipv6/af_inet6.c:300
  inet6_bind+0xfa/0x155 net/ipv6/af_inet6.c:453
  __sys_bind+0x239/0x290 net/socket.c:1649
  __do_sys_bind net/socket.c:1660 [inline]
  __se_sys_bind net/socket.c:1658 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1658
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a919
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f66ae74ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a919
RDX: 000000000000001c RSI: 0000000020000000 RDI: 0000000000000004
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f66ae74f6d4
R13: 00000000004c0ca5 R14: 00000000004d47d8 R15: 00000000ffffffff
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
