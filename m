Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E412E16EDFA
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbgBYS3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:29:15 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:47674 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgBYS3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 13:29:15 -0500
Received: by mail-io1-f72.google.com with SMTP id 13so156063iof.14
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 10:29:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=I6UFJnlb79zEXPRMLPthQdcBm8xLbG9d9X38VNdzh5I=;
        b=TwMOXrarPhXejN6ILfOvJXaHWuNOGgZy/kvdLCl0dq3AW/CUhKwdFI8aULPkSJcZM8
         YNIa407dUuLNwjmZrNAslGQELrLFASo9jdu0+45GEFXKlXIqFWVPyVtuxtqSybzCzCpE
         p5Y6YdOX+cG4AZyKQQyYXaeWD/huCaiUG7WegIX3MMQAXA1ocSp28I/pqoBw4VtBcltA
         m0YOFru58pWwJW8P7/8JsTQvHcEl3ht0emkQGxVFN+f/aLz17oouIpPbTK5yip7PT3FR
         g+aq8gHiU+hikzjhCLrUBVmYrSTHiyd7/i3koD4PbHU3G/z+n2pxN9DD/i6GNhO+Sq8o
         ECSQ==
X-Gm-Message-State: APjAAAWaaMLmmjRZLT6Y8OAoxWZpFDm+/3+xN87a5sqy4suDavbnF+w7
        i9pqeZWnItDVFlB/jtUvDQJ/GSY07y8APQ1JdHqh8Wx1V5fw
X-Google-Smtp-Source: APXvYqy4V13LXEbDGJeEiMLFmiTWFhqlbNUfSf0I1y+me/7hD1uy9H2ngIyOh13oh0LwjM470mxkKEVEdicXMmzjkTAL8qT8R6eQ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:76c:: with SMTP id y12mr53721381jad.95.1582655354188;
 Tue, 25 Feb 2020 10:29:14 -0800 (PST)
Date:   Tue, 25 Feb 2020 10:29:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030395e059f6aaa09@google.com>
Subject: general protection fault in j1939_netdev_start
From:   syzbot <syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6132c1d9 net: core: devlink.c: Hold devlink->lock from the..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10678909e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=f03d384f3455d28833eb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e36909e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100679dde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000c05: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x0000000000006028-0x000000000000602f]
CPU: 1 PID: 10119 Comm: syz-executor671 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:j1939_priv_set net/can/j1939/main.c:145 [inline]
RIP: 0010:j1939_netdev_start+0x361/0x650 net/can/j1939/main.c:280
Code: 03 80 3c 02 00 0f 85 bc 02 00 00 4c 8b ab 90 05 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bd 28 60 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 89 02 00 00 4d 89 a5 28 60 00 00 48 c7 c7 60 89
RSP: 0018:ffffc900070b7d00 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff888094ed4000 RCX: ffffffff8715dd84
RDX: 0000000000000c05 RSI: ffffffff8715ed3c RDI: 0000000000006028
RBP: ffffc900070b7d40 R08: ffff888095b121c0 R09: fffff52000e16f8e
R10: fffff52000e16f8d R11: 0000000000000003 R12: ffff888095538000
R13: 0000000000000000 R14: ffff888095539050 R15: ffff888094ed4558
FS:  00007f9a340ef700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9a340eee78 CR3: 00000000947c2000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 j1939_sk_bind+0x68d/0x980 net/can/j1939/socket.c:469
 __sys_bind+0x239/0x290 net/socket.c:1662
 __do_sys_bind net/socket.c:1673 [inline]
 __se_sys_bind net/socket.c:1671 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1671
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446d39
Code: e8 8c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9a340eed98 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000006dbc78 RCX: 0000000000446d39
RDX: 0000000000000018 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006dbc70 R08: 00007f9a340ef700 R09: 0000000000000000
R10: 00007f9a340ef700 R11: 0000000000000246 R12: 00000000006dbc7c
R13: 000000006f340000 R14: 0000000000000000 R15: 068500100000003c
Modules linked in:
---[ end trace e9a9971e66fb9d42 ]---
RIP: 0010:j1939_priv_set net/can/j1939/main.c:145 [inline]
RIP: 0010:j1939_netdev_start+0x361/0x650 net/can/j1939/main.c:280
Code: 03 80 3c 02 00 0f 85 bc 02 00 00 4c 8b ab 90 05 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bd 28 60 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 89 02 00 00 4d 89 a5 28 60 00 00 48 c7 c7 60 89
RSP: 0018:ffffc900070b7d00 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff888094ed4000 RCX: ffffffff8715dd84
RDX: 0000000000000c05 RSI: ffffffff8715ed3c RDI: 0000000000006028
RBP: ffffc900070b7d40 R08: ffff888095b121c0 R09: fffff52000e16f8e
R10: fffff52000e16f8d R11: 0000000000000003 R12: ffff888095538000
R13: 0000000000000000 R14: ffff888095539050 R15: ffff888094ed4558
FS:  00007f9a340ef700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9a340eee78 CR3: 00000000947c2000 CR4: 00000000001406e0
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
