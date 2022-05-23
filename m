Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17DC531444
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiEWPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 11:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237622AbiEWPMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 11:12:24 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ACA532CE
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 08:12:21 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id a3-20020a924443000000b002d1bc79da14so494212ilm.15
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 08:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ssTC97tVmCx0McXfxm8DIw1sGQpAzQtXezYdGClsZzw=;
        b=b9vDtBVVofjmq8Q/1G/FI6/bYX+MOZHvdsmsgBkbqkIUe5EnaGylUG44I/HJylocdY
         exEqvyNl3gs9BFIpjuiBLmqgX+Dz2rNXJnrrWyFQiOJSQEpkE3f7xUY4E07pLp+KHV5P
         N7Ol1OY8WyxyjDG6Zuak8qqlaI7dc1auf2+35ibRlh0Kt8PhvAMofLTVKzUTfCgSAPCU
         DThrib4miFC/s+UO2yi6ZiYOF2wPQulmfJixUoJzB40J7tE/Bn/EaIHJp3JHgQINLb/f
         n0/qZly10pUN9UbSzPs+6ZRwaWO4PYuddwXt2vKjCgtRiO2WJK/ynvR3cIiwjPV1SZpB
         pVtw==
X-Gm-Message-State: AOAM532kt3P2KmgGPPSh9XTFk42DQJq2yr2yrH/wXQxzdrbjrDpNQLif
        eYwDf0x3U5uhUKKBZ7S1DFZWvyu+qOBI1u21XbW6gwVLwHLL
X-Google-Smtp-Source: ABdhPJzCQUxi07tf/64UklqNftuGBpCacuEfYhUrPQzaeB7hQ7uxFvPB9RPBLZjCetWxT+2gnlVSDvNB+sGP1K7e3tCwXNkKupxS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1352:b0:2d1:6424:60b8 with SMTP id
 k18-20020a056e02135200b002d1642460b8mr10989334ilr.305.1653318740815; Mon, 23
 May 2022 08:12:20 -0700 (PDT)
Date:   Mon, 23 May 2022 08:12:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f33bc05dfaf44fe@google.com>
Subject: [syzbot] WARNING in inet_csk_get_port
From:   syzbot <syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        joannelkoong@gmail.com, kuba@kernel.org, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    aa5334b1f968 Merge branch 'add-a-bhash2-table-hashed-by-po..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=151fe7fdf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=468b6c3a1b5b53f0
dashboard link: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1336e875f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1673a38df00000

The issue was bisected to:

commit d5a42de8bdbe25081f07b801d8b35f4d75a791f4
Author: Joanne Koong <joannelkoong@gmail.com>
Date:   Fri May 20 00:18:33 2022 +0000

    net: Add a second bind table hashed by port and address

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14193ea9f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16193ea9f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12193ea9f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")

nf_conntrack: default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found. Use the iptables CT target to attach helpers instead.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 3598 at net/ipv4/inet_connection_sock.c:525 inet_csk_get_port+0x1148/0x1ad0 net/ipv4/inet_connection_sock.c:525
Modules linked in:
CPU: 1 PID: 3598 Comm: syz-executor285 Not tainted 5.18.0-rc7-syzkaller-01833-gaa5334b1f968 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:inet_csk_get_port+0x1148/0x1ad0 net/ipv4/inet_connection_sock.c:525
Code: 07 00 00 48 8b 44 24 28 4c 89 ee 48 8b 78 18 e8 2e d1 fe ff e9 0f ff ff ff e8 f4 59 a6 f9 0f 0b e9 ae fa ff ff e8 e8 59 a6 f9 <0f> 0b e9 de fa ff ff e8 dc 59 a6 f9 e8 a7 ed 9d 01 31 ff 89 c3 89
RSP: 0018:ffffc90002f4fbf8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888022f6a100 RCX: 0000000000000000
RDX: ffff88801e6fbb00 RSI: ffffffff87d2dff8 RDI: ffff88801e2e06a8
RBP: ffff88801e2e06a0 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff87d2c485 R11: 0000000000000000 R12: 0000000000000000
R13: ffff888022f6a100 R14: 0000000000000000 R15: ffff88801e2e0000
FS:  000055555578e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000005defd8 CR3: 000000001ce0b000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 inet_csk_listen_start+0x13e/0x3c0 net/ipv4/inet_connection_sock.c:1178
 inet_listen+0x231/0x640 net/ipv4/af_inet.c:228
 __sys_listen+0x17d/0x250 net/socket.c:1778
 __do_sys_listen net/socket.c:1787 [inline]
 __se_sys_listen net/socket.c:1785 [inline]
 __x64_sys_listen+0x50/0x70 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9112cccd09
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffca7006048 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9112cccd09
RDX: ffffffffffffffc0 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f9112c90eb0 R08: 000000000000001c R09: 000000000000001c
R10: 0000000020001540 R11: 0000000000000246 R12: 00007f9112c90f40
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
