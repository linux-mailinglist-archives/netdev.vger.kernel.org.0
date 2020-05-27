Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B801E4E39
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgE0TeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:34:21 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43872 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgE0TeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:34:18 -0400
Received: by mail-io1-f70.google.com with SMTP id 184so17771673iow.10
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W56eeROf/6B9r0VDmmlfml93PYb/srpgJXNe3sUJhfA=;
        b=KExVqg24KXImBZyyqjATsJAfKoey0SCDTcn6EJrBXAor6ejJkto+iFaZKyoJXvkjrT
         DGIIosqYWW6LES+N1nfYCJOILslgYJp+N+6CPfG66AWmqUkHppO4afmo0TUTMbY0i30O
         L+GXu69aHLPBkGwyfIryw9ROoCPeSofXGZL3CHaYlX+5aQbGD521TE8+dXVaTQP0ocLG
         AS1pmqHOjptrsqlKzMQ8/RJrEna0DO46sFAb0RbUSs6OIxVCYVZwLZkgmcelYMegywlH
         ax4Q5CCE7wI6V1O+ULhJMpeC2elu1m3b6D37RKo5P7LA6J21ADd15o9Z4Btu4KiGs8xU
         Noog==
X-Gm-Message-State: AOAM530eHCcH1E8fd0zG67P22XPK2FuY1HyNvdP2KseqRq8T72k16Y6u
        z3/xlt+5g4zG4t+Qt4bSBYHCP7PTf3cASLJ0zg1U4WVL7RYg
X-Google-Smtp-Source: ABdhPJwUS6XHZxoufD0yHNyC0/Cvb3zkIpNDyUoYuNmWrKQMfwLf7Oa3fAJmDgN5goFXbKIJxCUUxX7yZLXE9dsLd9OdgA0p3H2J
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2431:: with SMTP id g17mr3540300iob.3.1590608056779;
 Wed, 27 May 2020 12:34:16 -0700 (PDT)
Date:   Wed, 27 May 2020 12:34:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033888405a6a64c2f@google.com>
Subject: general protection fault in __tipc_sendstream
From:   syzbot <syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, tuong.t.lien@dektech.com.au,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fb8ddaa9 Merge tag 'batadv-next-for-davem-20200526' of git..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=161c99e2100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e1bc97341edbea6
dashboard link: https://syzkaller.appspot.com/bug?extid=8eac6d030e7807c21d32
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125ef99a100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14741416100000

The bug was bisected to:

commit 0a3e060f340dbe232ffa290c40f879b7f7db595b
Author: Tuong Lien <tuong.t.lien@dektech.com.au>
Date:   Tue May 26 09:38:38 2020 +0000

    tipc: add test for Nagle algorithm effectiveness

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=173f1cd2100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14bf1cd2100000
console output: https://syzkaller.appspot.com/x/log.txt?x=10bf1cd2100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com
Fixes: 0a3e060f340d ("tipc: add test for Nagle algorithm effectiveness")

general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
CPU: 1 PID: 7060 Comm: syz-executor394 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__tipc_sendstream+0xbde/0x11f0 net/tipc/socket.c:1591
Code: 00 00 00 00 48 39 5c 24 28 48 0f 44 d8 e8 fa 3e db f9 48 b8 00 00 00 00 00 fc ff df 48 8d bb c8 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e2 04 00 00 48 8b 9b c8 00 00 00 48 b8 00 00 00
RSP: 0018:ffffc90003ef7818 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8797fd9d
RDX: 0000000000000019 RSI: ffffffff8797fde6 RDI: 00000000000000c8
RBP: ffff888099848040 R08: ffff88809a5f6440 R09: fffffbfff1860b4c
R10: ffffffff8c305a5f R11: fffffbfff1860b4b R12: ffff88809984857e
R13: 0000000000000000 R14: ffff888086aa4000 R15: 0000000000000000
FS:  00000000009b4880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 00000000a7fdf000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tipc_sendstream+0x4c/0x70 net/tipc/socket.c:1533
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x32f/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440199
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe74856df8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440199
RDX: 0492492492492619 RSI: 0000000020003240 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a20
R13: 0000000000401ab0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 0d2e71066c248d44 ]---
RIP: 0010:__tipc_sendstream+0xbde/0x11f0 net/tipc/socket.c:1591
Code: 00 00 00 00 48 39 5c 24 28 48 0f 44 d8 e8 fa 3e db f9 48 b8 00 00 00 00 00 fc ff df 48 8d bb c8 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e2 04 00 00 48 8b 9b c8 00 00 00 48 b8 00 00 00
RSP: 0018:ffffc90003ef7818 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8797fd9d
RDX: 0000000000000019 RSI: ffffffff8797fde6 RDI: 00000000000000c8
RBP: ffff888099848040 R08: ffff88809a5f6440 R09: fffffbfff1860b4c
R10: ffffffff8c305a5f R11: fffffbfff1860b4b R12: ffff88809984857e
R13: 0000000000000000 R14: ffff888086aa4000 R15: 0000000000000000
FS:  00000000009b4880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 00000000a7fdf000 CR4: 00000000001406e0
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
