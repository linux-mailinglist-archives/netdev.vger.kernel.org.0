Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4369EF47B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 05:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfKEEWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 23:22:30 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:48216 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729836AbfKEEWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 23:22:10 -0500
Received: by mail-il1-f198.google.com with SMTP id j68so17562155ili.15
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 20:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HlYiG2GEhhqU8MXaU99Yfr0YCrWSMrWlELcWvWZpYrI=;
        b=Hqo7VDXXABEBoTkV5AAFvhlsER3RCN9Yn2NDZdy9Ttnj1AclrSfmeb+d4REgqTMGBR
         apIkoN/rAherV0JSOTrP7mCnwuw0a1/ENfZWfm+zQkFdzJDqD+H80eZ64WnSE1AOUrnV
         +KeG8+K/KrP5b6n1e9wV3l1GXrIRrw8kxSg35xtL4FEVRWpmDPb3o0eUdBgAj3wbogHj
         6SBNSu2cz+2q1CuhrJlwQqaXGZPWHb6cJPO6F5OeG3xi6wVNcG1LdYv9t+jrYqX+MVN4
         2kMbekSA6iZhBlYJJSLoj3EyjrVDIk1x1SCr3pY01TQSUT5l+O7fxnWZ80PsoyUJkEQJ
         PtWw==
X-Gm-Message-State: APjAAAUhv7oelDsC32EW7I1G54ROlQPSvl915zkWTyYvb2bVZn9KRESX
        M87wr/7fbpMzbOWuRNIpPy3jKIIN1UtEk+VmbqxVSYfjlm0z
X-Google-Smtp-Source: APXvYqxbEzDZpsmT69oyGgygq47bK6KjWTGfROMurVFKCBq+MHaMc5VpLVtnw1OR0R6BoRXpJsxMzrn31/vkDVQzlzuD65RWnlCa
MIME-Version: 1.0
X-Received: by 2002:a02:1948:: with SMTP id b69mr6149366jab.30.1572927729910;
 Mon, 04 Nov 2019 20:22:09 -0800 (PST)
Date:   Mon, 04 Nov 2019 20:22:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000994f3c059691c676@google.com>
Subject: general protection fault in j1939_jsk_del
From:   syzbot <syzbot+6d04f6a1b31a0ae12ca9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a99d8080 Linux 5.4-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1296b4dce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=6d04f6a1b31a0ae12ca9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1450cc58e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6d04f6a1b31a0ae12ca9@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9046 Comm: syz-executor.0 Not tainted 5.4.0-rc6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__lock_acquire+0x1254/0x4a00 kernel/locking/lockdep.c:3828
Code: 00 0f 85 96 24 00 00 48 81 c4 f0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f  
85 0b 28 00 00 49 81 3e e0 85 06 8a 0f 84 5f ee ff
RSP: 0018:ffff8880894c7b48 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000218 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff8880894c7c60 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff138cd40 R11: ffff888091c120c0 R12: 00000000000010c0
R13: 0000000000000000 R14: 00000000000010c0 R15: 0000000000000000
FS:  00007f32e6337700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd8dbf57000 CR3: 00000000a0e72000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  j1939_jsk_del+0x32/0x240 net/can/j1939/socket.c:90
  j1939_sk_bind+0x2e2/0x8e0 net/can/j1939/socket.c:421
  __sys_bind+0x239/0x290 net/socket.c:1647
  __do_sys_bind net/socket.c:1658 [inline]
  __se_sys_bind net/socket.c:1656 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1656
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a219
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f32e6336c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a219
RDX: 0000000000000018 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f32e63376d4
R13: 00000000004c057e R14: 00000000004d2c50 R15: 00000000ffffffff
Modules linked in:
---[ end trace 2db5662cc5070619 ]---
RIP: 0010:__lock_acquire+0x1254/0x4a00 kernel/locking/lockdep.c:3828
Code: 00 0f 85 96 24 00 00 48 81 c4 f0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f  
85 0b 28 00 00 49 81 3e e0 85 06 8a 0f 84 5f ee ff
RSP: 0018:ffff8880894c7b48 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000218 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff8880894c7c60 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff138cd40 R11: ffff888091c120c0 R12: 00000000000010c0
R13: 0000000000000000 R14: 00000000000010c0 R15: 0000000000000000
FS:  00007f32e6337700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd8dbf57000 CR3: 00000000a0e72000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
