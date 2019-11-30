Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47B210DD23
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 09:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfK3IqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 03:46:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:46499 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfK3IqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 03:46:10 -0500
Received: by mail-io1-f70.google.com with SMTP id b186so9324402iof.13
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 00:46:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=755V43H68p2tB3xp7z2VrFVq47sZugs1GcV9p/fBxfQ=;
        b=N/ZO5sTbjWtsl7A4NRwY25FCydSfdqSZpvaNw9XPxrl2bNu6o9/gR9iC3tnGLfhnQ1
         ejZp2FOLD/ZnD0uNUbeV4WBFgECaw+REoSIBDF2dCEF21JxR6LK8ABFYFjW80ir3g7cr
         yUIBv79Fi3kHT6djpvkwxTcw0dWkGJHwqPVc0UE2CLEYplxA+AaUG/EaIRJ67HoF3wji
         smS2YyF1KDKhxoDjhMSyegweiDTwoahuNJjT/tzhyCEti+YRkDpl9nZ6plfpo6dWVygN
         QsQqR0DAiP5+FkGZKYeIo2bhCynbQoMSYuorQ0gSIulAf307FDSnbZj3607ZegVKER95
         jDQA==
X-Gm-Message-State: APjAAAUB9deci7emLPvU1nL1PUVPGyvKhGZxBaETuSMy5Vgrbr3JW1NA
        C/gmAHcfKYxlWT7D4Az8QQEbiJbT6CVWiffLF2/ZBkGEdR0M
X-Google-Smtp-Source: APXvYqyjqt3aSbwdxMnttBcZrjWgclXwi32UoowlUZT0C8OBaP9a5TW7YFBcaq37TSB19/+USUg/7p122pZsv4arndgt52/T6xTI
MIME-Version: 1.0
X-Received: by 2002:a92:7981:: with SMTP id u123mr22876500ilc.138.1575103568232;
 Sat, 30 Nov 2019 00:46:08 -0800 (PST)
Date:   Sat, 30 Nov 2019 00:46:08 -0800
In-Reply-To: <0000000000008c5bfa05988b29dd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab4c4b05988c6085@google.com>
Subject: Re: general protection fault in j1939_jsk_del (2)
From:   syzbot <syzbot+99e9e1b200a1e363237d@syzkaller.appspotmail.com>
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

syzbot has found a reproducer for the following crash on:

HEAD commit:    81b6b964 Merge branch 'master' of git://git.kernel.org/pub..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14d2aabce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=333b76551307b2a0
dashboard link: https://syzkaller.appspot.com/bug?extid=99e9e1b200a1e363237d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1671bcdae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+99e9e1b200a1e363237d@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9409 Comm: syz-executor.0 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__lock_acquire+0x1254/0x4a00 kernel/locking/lockdep.c:3828
Code: 00 0f 85 96 24 00 00 48 81 c4 f0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f  
85 0b 28 00 00 49 81 3e 20 e9 77 8a 0f 84 5f ee ff
RSP: 0018:ffff8880a393fb48 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000218 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff8880a393fc60 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff146dba0 R11: ffff8880a084e300 R12: 00000000000010c0
R13: 0000000000000000 R14: 00000000000010c0 R15: 0000000000000000
FS:  00007f996d50d700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000075c000 CR3: 000000008f718000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  j1939_jsk_del+0x32/0x210 net/can/j1939/socket.c:89
  j1939_sk_bind+0x2ea/0x8f0 net/can/j1939/socket.c:448
  __sys_bind+0x239/0x290 net/socket.c:1648
  __do_sys_bind net/socket.c:1659 [inline]
  __se_sys_bind net/socket.c:1657 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1657
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f996d50cc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a679
RDX: 0000000000000018 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f996d50d6d4
R13: 00000000004c09e9 R14: 00000000004d37d0 R15: 00000000ffffffff
Modules linked in:
------------[ cut here ]------------
WARNING: CPU: 0 PID: 9409 at kernel/locking/mutex.c:1419  
mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427

