Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD9940088F
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhIDACe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:02:34 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:49978 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbhIDAC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 20:02:29 -0400
Received: by mail-il1-f197.google.com with SMTP id a15-20020a92444f000000b0022473393120so504064ilm.16
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 17:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=o2vA0ZMsHC+UCty2riMB626DqMslXAg4nASWM6ywTYc=;
        b=aXndgcoZXY6l1ihy3vY00GXfJdNsZnBmh4UHeDagYAIPernmE+YDbZlpa8evagAC+c
         ffN+3IWJcX0NlDOcWwGwa0++DcCv0RztCNgsuWsVtdcyamiZU/Pazm7+6VWlVs9+BmHv
         W9RWbe3MbC+xJ8qgHvEli+tDhi1BLfZAb8kn4xQIazGKdI1wXaLufCxHrq/ewRXDOi3w
         JfQZBThxiudJtRdVt8x0bDvOcONpSye5G3ZtBgf8Gvk+O71wbhpkaB3/85GozsdB8uGT
         gzzFLrgtvTazAIx7mR8zF99RH/yv6tb9beS6jBwIOsC7H+u5KlLC98hKGboQy/7cvV7F
         ahEw==
X-Gm-Message-State: AOAM533zIUumCxQyYqrVHsX6YgyomUQX57K8pZtYCTjPRS7jp/nBJLin
        20ZPPybg0k/nKxqvcxVo1AsWlu+R9rOHXTRQczu/HAKBgZSW
X-Google-Smtp-Source: ABdhPJxIdlIBm02ols5xi8SPH92oZj8Wbianv1naNKaFkt5GyeNnRXlss6+tsLwNaRjOASyR/NVRDDP1Z3aKwmiTczueBWhk2i7f
MIME-Version: 1.0
X-Received: by 2002:a92:6904:: with SMTP id e4mr1030741ilc.311.1630713688974;
 Fri, 03 Sep 2021 17:01:28 -0700 (PDT)
Date:   Fri, 03 Sep 2021 17:01:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029697605cb201ed2@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_ipmark_create
From:   syzbot <syzbot+5a5a70ab7329b98649e7@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16490fb1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ac29107aeb2a552
dashboard link: https://syzkaller.appspot.com/bug?extid=5a5a70ab7329b98649e7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=115e5ccd300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178b4cb9300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5a5a70ab7329b98649e7@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8416 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8416 Comm: syz-executor566 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 ed 11 0d 00 49 89 c5 e9 69 ff ff ff e8 90 55 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 7f 55 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 66
RSP: 0018:ffffc90001cb7280 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90001cb73a0 RCX: 0000000000000000
RDX: ffff8880292f8100 RSI: ffffffff81a3f651 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001e
R10: ffffffff81a3f60e R11: 000000000000001f R12: 0000000200000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888015dc1800
FS:  00000000016c3300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000146 CR3: 00000000168e4000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_ipmark_create+0x4bd/0x1370 net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
 nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f039
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdcfb9e628 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 0000000000403020 R08: 0000000000000005 R09: 0000000000400488
R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004030b0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
