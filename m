Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6908D26796
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 17:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfEVP6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 11:58:22 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51191 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729486AbfEVP6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 11:58:07 -0400
Received: by mail-io1-f71.google.com with SMTP id t7so2073577iod.17
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 08:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7lSDApAtOCxz4TP7s5daJu57d1+C70zxwd4mjmot7GQ=;
        b=N19iwzXVw4qFgcyELehIwtz2Z4xe5ytZmqRDq42yivBXFqoXHI8nFyZQMBT3tL15bi
         50fRQOhihcxY48Q56aV0bRMuP2zPiDq+Qh7cIf23uhIT4Bd23SPmK6iJHEUmVuyHfWid
         6ToHdk18LV4QI8iyFA4Z/mtEobjsEJt1skj/6CIZB21gmB0Q6wjbAugwny6hEezEp14l
         Jc/DZwf0pXyLB4mz5AHzj58kazJ8n73//9RTAqnhNdfBe+bP9cGDzZZvX+2071QfqST3
         2lC/H3ehjkQeWL8yHpIYIK5zwKhHfoAvs5OQn+VzDQBr7DdT+lUyTGy0sMKF1Vfy7svN
         +t0g==
X-Gm-Message-State: APjAAAV+rMOpSS2RGEZISiucLcoWUQ72uIOupFW/Ry+ex7WJ9mCH4LZM
        tpOoeClqwJuL+Vr/0Ztd6QW+W6n4NY7J0se/ysmSn3iKhOJ2
X-Google-Smtp-Source: APXvYqzNvzXZrMP4syP6fd9m0N/jp3GGMI28VLySGSdCni7VNl/d49fhxFg6P44NkLggIJwm82b0DQU/LrzAlDuhZyWuR17Kzq/b
MIME-Version: 1.0
X-Received: by 2002:a05:660c:492:: with SMTP id a18mr8854066itk.48.1558540686157;
 Wed, 22 May 2019 08:58:06 -0700 (PDT)
Date:   Wed, 22 May 2019 08:58:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f7707805897c071f@google.com>
Subject: WARNING: locking bug in do_ipv6_setsockopt
From:   syzbot <syzbot+f28170ca1ee366e97283@syzkaller.appspotmail.com>
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

HEAD commit:    5bdd9ad8 Merge tag 'kbuild-fixes-v5.2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13e8856ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
dashboard link: https://syzkaller.appspot.com/bug?extid=f28170ca1ee366e97283
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a61080a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f28170ca1ee366e97283@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 19781 at kernel/locking/lockdep.c:734  
arch_local_save_flags arch/x86/include/asm/paravirt.h:762 [inline]
WARNING: CPU: 1 PID: 19781 at kernel/locking/lockdep.c:734  
arch_local_save_flags arch/x86/include/asm/paravirt.h:760 [inline]
WARNING: CPU: 1 PID: 19781 at kernel/locking/lockdep.c:734  
look_up_lock_class kernel/locking/lockdep.c:725 [inline]
WARNING: CPU: 1 PID: 19781 at kernel/locking/lockdep.c:734  
register_lock_class+0xe10/0x1860 kernel/locking/lockdep.c:1078
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 19781 Comm: syz-executor.2 Not tainted 5.2.0-rc1+ #2
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x744 kernel/panic.c:218
  __warn.cold+0x20/0x4d kernel/panic.c:575
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
RIP: 0010:look_up_lock_class kernel/locking/lockdep.c:734 [inline]
RIP: 0010:register_lock_class+0xe10/0x1860 kernel/locking/lockdep.c:1078
Code: 00 48 89 da 4d 8b 76 c0 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80  
3c 02 00 0f 85 23 07 00 00 4c 89 33 e9 e3 f4 ff ff 0f 0b <0f> 0b e9 ea f3  
ff ff 44 89 e0 4c 8b 95 50 ff ff ff 83 c0 01 4c 8b
RSP: 0018:ffff88807e527568 EFLAGS: 00010083
RAX: dffffc0000000000 RBX: ffff888087f720e0 RCX: 0000000000000000
RDX: 1ffff11010fee41f RSI: 0000000000000000 RDI: ffff888087f720f8
RBP: ffff88807e527630 R08: 1ffff1100fca4eb5 R09: ffffffff8a659d40
R10: ffffffff8a2e8440 R11: 0000000000000000 R12: ffffffff8a3249a0
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff88022ba0
  __lock_acquire+0x116/0x5490 kernel/locking/lockdep.c:3673
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4302
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  lock_sock_nested+0x41/0x120 net/core/sock.c:2917
  lock_sock include/net/sock.h:1525 [inline]
  do_ipv6_setsockopt.isra.0+0x27a/0x4100 net/ipv6/ipv6_sockglue.c:167
  ipv6_setsockopt+0xf6/0x170 net/ipv6/ipv6_sockglue.c:946
  udpv6_setsockopt+0x68/0xb0 net/ipv6/udp.c:1571
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3130
  __sys_setsockopt+0x17a/0x280 net/socket.c:2078
  __do_sys_setsockopt net/socket.c:2089 [inline]
  __se_sys_setsockopt net/socket.c:2086 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2086
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007efc76669c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000459279
RDX: 0000000000000023 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 000000000075c060 R08: 00000000000000e8 R09: 0000000000000000
R10: 00000000200002c0 R11: 0000000000000246 R12: 00007efc7666a6d4
R13: 00000000004ce020 R14: 00000000004dc648 R15: 00000000ffffffff
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
