Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0728A2C9EDE
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 11:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgLAKL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 05:11:59 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:40156 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbgLAKL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 05:11:57 -0500
Received: by mail-il1-f198.google.com with SMTP id b18so1024301ilr.7
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 02:11:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=b5RBHpGK4xi7X1hJC/J/ggmt8EqQrMn2ZjENCO935H0=;
        b=U0M+/zFt8pP7DqgpAzQ4pk260Ba56c063+YSGer/Vh2oOV2r+ADwEwy1hmtkkwMYxD
         HCnwmtew/YbJkSgCAqZl5d1xzvw4NY5xT8bV5d3JHTAm9N7sLJE/wapYFcIF8twKu/He
         UuvEf+m5WLyDy+I99Q0lyktErwiII3eOBn7kWYpyjKkYjONrc8XQRKiy5wx+pNImlciy
         a5luYCnMMGPSXZgy2s1PCMaCM+VhlgfsDsTck0tr4VGT1VJ06hFftw8O3O4q7iIstu/a
         xPxzjTNT9IjMlczKyR3F0cG8hfnP5Yd4CSetvcyn2q6vzr9XnhWIa/eei4NmnfomjO6x
         Pd0g==
X-Gm-Message-State: AOAM5329RYjFYvKwyGJo37RZs0k1udMWxRyfT/guilgJ3HGz3ofhkmfd
        hlMpR0POUFTpW0Ki4hagLAZBQQqDHC/v/iZlyCOYzxxuuM4F
X-Google-Smtp-Source: ABdhPJxTKjeNQsc//e0VotITvjrvUrdvbCowU5vsO/BCSEADM0pr+5+xJMWC4GYkAuJ/Q7QhzbLVqAYeK9xP3txR3EcF8l4E+QNy
MIME-Version: 1.0
X-Received: by 2002:a92:c50d:: with SMTP id r13mr1842593ilg.160.1606817477099;
 Tue, 01 Dec 2020 02:11:17 -0800 (PST)
Date:   Tue, 01 Dec 2020 02:11:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f107e305b564586f@google.com>
Subject: WARNING: locking bug in ip6_datagram_connect
From:   syzbot <syzbot+d3af95d2506e1511dcc1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d5beb314 Merge tag 'hyperv-fixes-signed' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15808bed500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a31e7421a3bb7a0f
dashboard link: https://syzkaller.appspot.com/bug?extid=d3af95d2506e1511dcc1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b5bfb9500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d3af95d2506e1511dcc1@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 10853 at kernel/locking/lockdep.c:894 look_up_lock_class kernel/locking/lockdep.c:894 [inline]
WARNING: CPU: 1 PID: 10853 at kernel/locking/lockdep.c:894 register_lock_class+0x1fb/0x1100 kernel/locking/lockdep.c:1242
Modules linked in:
CPU: 1 PID: 10853 Comm: syz-executor.0 Not tainted 5.10.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:look_up_lock_class kernel/locking/lockdep.c:894 [inline]
RIP: 0010:register_lock_class+0x1fb/0x1100 kernel/locking/lockdep.c:1242
Code: 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 21 0d 00 00 4d 3b 67 18 74 0b 49 81 3f 80 51 4a 8e 74 02 <0f> 0b 85 ed 0f 84 20 01 00 00 f6 44 24 04 01 0f 85 15 01 00 00 83
RSP: 0018:ffffc90002377a58 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 1ffff9200046ef52 RCX: ffffffff8ef48920
RDX: 1ffff110032d9217 RSI: 0000000000000000 RDI: ffff8880196c90b8
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8a42ad20
R13: ffffffff8fa9f980 R14: ffffffff8ec04d40 R15: ffff8880196c90a0
FS:  00007f3808a81700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004e0b50 CR3: 000000001cacf000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __lock_acquire+0xff/0x5500 kernel/locking/lockdep.c:4711
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 release_sock+0x1b/0x1b0 net/core/sock.c:3051
 ip6_datagram_connect+0x36/0x40 net/ipv6/datagram.c:273
 inet_dgram_connect+0x14a/0x2d0 net/ipv4/af_inet.c:577
 __sys_connect_file+0x155/0x1a0 net/socket.c:1852
 __sys_connect+0x161/0x190 net/socket.c:1869
 __do_sys_connect net/socket.c:1879 [inline]
 __se_sys_connect net/socket.c:1876 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1876
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3808a80c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000002400 RCX: 000000000045deb9
RDX: 000000000000001c RSI: 0000000020000080 RDI: 0000000000000005
RBP: 000000000118c008 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bfd4
R13: 00007fff08fcd91f R14: 00007f3808a819c0 R15: 000000000118bfd4


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
