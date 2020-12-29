Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E482E7320
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 20:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgL2S65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 13:58:57 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:49483 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgL2S65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 13:58:57 -0500
Received: by mail-io1-f69.google.com with SMTP id m19so6122212iow.16
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 10:58:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+TBsWIfvGU4VhD7Hd6BwPAnBfpcnr8dDlMOLqb/jGdg=;
        b=k2pewZAqeROFj762gYeooY0rXyNS2DkT8wayMLAZmUAo/Af6aMtDPlk6MJg5c78xDj
         /cYvwnEo+Kh6lZYX15LSnYJncC8U7vvZEwlxajO96bNqyL28cR3hOKVqAKyEXZiFmYdD
         OaUP2NsQEUdxcWaVH5No/KELyob9I4SiPVUL6LP4Lv3cNm4bELaRosehMfCDcSvaX9Fu
         g+entc+3aCyngyBX552UrPV3JhbJKvdpw6/wRsHk8aNUvyIXMJMUG6dQCkKTH4e1uwxN
         Rwepq2DKS2+yTtOMxgPOvB7gAKSwQyzULx3/VMmGN7CoRYeC2y2/NMIGW8JXeI4h1OoP
         MIKQ==
X-Gm-Message-State: AOAM533flQiAcy65uDjJTrTilcrbkOrApWqo5I4fTioOwXelfL5t30q6
        r1dDBWf4AWgU3Ccx1Cqq1sUtCvChFu5hKJmtqEJbgtK3Mr+s
X-Google-Smtp-Source: ABdhPJxen17g8uLsEGBTknQu7HdfqvdN+/NqwsWzSwD2/BFCe4x0NLdNg22WkK4cejrtf7o4wbRuIrIcLWjQAbh5AtxdAyK5PK75
MIME-Version: 1.0
X-Received: by 2002:a02:b02:: with SMTP id 2mr43666362jad.15.1609268296590;
 Tue, 29 Dec 2020 10:58:16 -0800 (PST)
Date:   Tue, 29 Dec 2020 10:58:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002aa9f905b79ef9c3@google.com>
Subject: UBSAN: shift-out-of-bounds in choke_change
From:   syzbot <syzbot+4eda8c01ca2315d1722e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    71c5f031 Merge tag 'docs-5.11-2' of git://git.lwn.net/linux
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15103693500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e7e34a83d606100
dashboard link: https://syzkaller.appspot.com/bug?extid=4eda8c01ca2315d1722e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143d33ff500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13725277500000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137f60db500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10ff60db500000
console output: https://syzkaller.appspot.com/x/log.txt?x=177f60db500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4eda8c01ca2315d1722e@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
================================================================================
UBSAN: shift-out-of-bounds in ./include/net/red.h:252:22
shift exponent 96 is too large for 32-bit type 'int'
CPU: 0 PID: 8513 Comm: syz-executor800 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 red_set_parms include/net/red.h:252 [inline]
 choke_change.cold+0xce/0x115 net/sched/sch_choke.c:413
 qdisc_create+0x4ba/0x13a0 net/sched/sch_api.c:1246
 tc_modify_qdisc+0x4c8/0x1a30 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0x498/0xb80 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4437b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 0d fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff205ca1d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004437b9
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 00007fff205ca1e0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007fff205ca1f0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
