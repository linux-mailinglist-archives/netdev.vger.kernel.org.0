Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894FE2E1114
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 02:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgLWBQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 20:16:03 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:36682 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgLWBQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 20:16:02 -0500
Received: by mail-il1-f198.google.com with SMTP id z15so13142142ilb.3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 17:15:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qqkeSoCm1Vpmyy4eSZobyfGFupqnSFHUvlxIBcfud7U=;
        b=Yi87KE6qBUKTtpt5jYr17kfCJeVbuH0uVkl+864RrXz3Xj7qJD7HRihlqpfa+5lT9T
         ksrwOuRoT7+nH2ll+B/3vYXsl17dygfp3qOf+mfOwWFgs1/+yCIV1fdqwWzr8mP4e7iH
         ccx7syNK7gpbERXDPyc30+lQILBjtq4wtSQk8qSDZlZC3Yahf2+eDqFUAIjnm3A4Iht6
         pyCV1yYLQP6CoiRhUP1VaetH71waI1rkl6z5e6VsjaaudCfy2U2r4I39FzoqYVyyw2U5
         DExtHY25IXNQc+4Z0eEwvAfzuZlaHlqhlpqOEZxwzSwc/02UE0fIKKFKg06sn0atHy5E
         cRFQ==
X-Gm-Message-State: AOAM533IPN3fu6O21HuGSeT3Dw/EuSsowyoqDWgfpxJBs09/X/SAPokV
        XOh6uioLEXj9742xqw1dlRxO8NmR0DwKRLOOu6jxNYt9haiL
X-Google-Smtp-Source: ABdhPJySr8OIgv3X1rOc7nug6+rxsOMQLNYBj5rqV5LsnaYUu+bS5j8Ep54xe4R2dg9JCqH/RvRc739Rmb5YFyonKIo67Zaud7d7
MIME-Version: 1.0
X-Received: by 2002:a02:834b:: with SMTP id w11mr21524195jag.5.1608686121215;
 Tue, 22 Dec 2020 17:15:21 -0800 (PST)
Date:   Tue, 22 Dec 2020 17:15:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf6d3705b7176c3d@google.com>
Subject: UBSAN: shift-out-of-bounds in sfq_init
From:   syzbot <syzbot+97c5bd9cc81eca63d36e@syzkaller.appspotmail.com>
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

HEAD commit:    a409ed15 Merge tag 'gpio-v5.11-1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=164f5123500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f7c39e7211134bc0
dashboard link: https://syzkaller.appspot.com/bug?extid=97c5bd9cc81eca63d36e
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1136680f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14383487500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97c5bd9cc81eca63d36e@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in ./include/net/red.h:252:22
shift exponent 72 is too large for 32-bit type 'int'
CPU: 1 PID: 8479 Comm: syz-executor063 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 red_set_parms include/net/red.h:252 [inline]
 sfq_change net/sched/sch_sfq.c:674 [inline]
 sfq_init.cold+0x4f/0xd5 net/sched/sch_sfq.c:762
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
RIP: 0033:0x4404f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffef145e18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004404f9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 00000000ffffffff R09: 00000000004002c8
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401d00
R13: 0000000000401d90 R14: 0000000000000000 R15: 0000000000000000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
