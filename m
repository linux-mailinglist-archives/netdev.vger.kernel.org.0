Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289DE2F017B
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 17:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAIQ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 11:28:05 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:36811 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbhAIQ2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 11:28:04 -0500
Received: by mail-il1-f197.google.com with SMTP id z15so13251778ilb.3
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 08:27:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UfTIgRRR5zQYdkC5mEzTjzS+qdheTB/GHC44FlPG0ew=;
        b=GI64opz90vGSklcAROjL0c2Z5YPiG5R19Mam4PVImLSc6c5610/EohRfV7GTprYAxr
         pCyEZwDuRnTiv4ejAxAgBIZKpVgW+KMBBL6Pc9wvvH3Fndcw1ehEJWdIh6SVChiW7tHs
         gjEYmeK4wiAXleotH73jexFEbnx2CAyX+0bLYh6rLvlEwhcLoY+SsLvZ1BmyfmWckS04
         n2+NayZMIkImoW/WcvRAV/Mimip7XWJcUaYSNxdPlDD9JiO1HyAA50J8FR9arXzFs7XB
         7Z2c6g9erdeKsKGWTKpU1HtH8qDqDijRjg8zEx4FbUjT1xGocYpkohOYYaBiLJayzR1p
         52lQ==
X-Gm-Message-State: AOAM531CZhFJVWJSGkExHo5f0+y/pcSCjDBb08O1JY41PgdaUvJ+4M7G
        ixIYzgfU1pFjZ1ZSuufpxb0N2ZGi4PbQxq1veDDeEMZjFKXn
X-Google-Smtp-Source: ABdhPJxYEjCpuXzVfcPSHlt+fWSPBk6hy8bTEZd3BsuWyoGbbZoqLiycmiApJ5uMta4OSIIgIao7ES83euKlBOw+DPAHAEAJmT74
MIME-Version: 1.0
X-Received: by 2002:a92:4019:: with SMTP id n25mr9049876ila.25.1610209643255;
 Sat, 09 Jan 2021 08:27:23 -0800 (PST)
Date:   Sat, 09 Jan 2021 08:27:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cce36805b87a25e4@google.com>
Subject: WARNING in tcindex_alloc_perfect_hash
From:   syzbot <syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f6e7a024 Merge tag 'arc-5.11-rc3' of git://git.kernel.org/..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11a9a760d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
dashboard link: https://syzkaller.appspot.com/bug?extid=1071ad60cd7df39fdadb
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11adb9c0d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164e8998d00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=111bc72f500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=131bc72f500000
console output: https://syzkaller.appspot.com/x/log.txt?x=151bc72f500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1071ad60cd7df39fdadb@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
------------[ cut here ]------------
WARNING: CPU: 1 PID: 8487 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
Modules linked in:
CPU: 1 PID: 8487 Comm: syz-executor509 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
RSP: 0018:ffffc9000c676e58 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff920018cedcf RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000040dc0
RBP: 0000000000040dc0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 000000000000001b
R13: 000000000000001b R14: 0000000000000000 R15: ffff8880265e8000
FS:  0000000002160880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 0000000017965000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
 kmalloc_array include/linux/slab.h:592 [inline]
 kcalloc include/linux/slab.h:621 [inline]
 tcindex_alloc_perfect_hash+0x57/0x440 net/sched/cls_tcindex.c:306
 tcindex_set_parms+0x1a87/0x20d0 net/sched/cls_tcindex.c:433
 tcindex_change+0x212/0x320 net/sched/cls_tcindex.c:546
 tc_new_tfilter+0x1394/0x2120 net/sched/cls_api.c:2127
 rtnetlink_rcv_msg+0x80e/0xad0 net/core/rtnetlink.c:5555
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x331/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmmsg+0x195/0x470 net/socket.c:2489
 __do_sys_sendmmsg net/socket.c:2518 [inline]
 __se_sys_sendmmsg net/socket.c:2515 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2515
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440ce9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdef9e98b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004a24d0 RCX: 0000000000440ce9
RDX: 04924924924926d3 RSI: 0000000020000200 RDI: 0000000000000004
RBP: 00007ffdef9e98c0 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004a24d0
R13: 0000000000402210 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
