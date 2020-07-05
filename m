Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED8214C39
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 13:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgGELwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 07:52:16 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:43097 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgGELwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 07:52:15 -0400
Received: by mail-il1-f200.google.com with SMTP id y13so25656646ila.10
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 04:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kI2hWc85ElXBDp49zGFIxRME9u7T+l5L6TLjyZSAFs4=;
        b=ITK/Cmqa3eL2JgKIDa34ASGs2JjGph+7a0lK6Qiv/lj/w8cuNbH1QWRgYJSh+Q/Ecu
         btstR6OyjRS8n8uLZhljNXolCDIAf3K7nf9wLrVh+VERESG4P07EFIX5TUcUbbD0JyXN
         6G6H+iK9/JQUzPZ+UYI1dQ6PnLYykPsbW9nxksF4GxGum9ABAROCWpmSb21w1nUqg0po
         E9QxQU/mSgphDZDyb+Us6hrHHWa9cu4G7b0aSCp+whPHV8SwACyR4sHzt4XmH7qz4Sa6
         BaCPoTqB3NyTe7Bwd+S1gjdMw9DN5ALnOYobnIyFDFReuBa1u4Fa809dH0QefdzZKRzh
         IP+Q==
X-Gm-Message-State: AOAM530I+AdhSnuEOJbLkAPsWrP96ya2T3yOIr7yuM4CCAd0/NqVsA8+
        DbBsnPfPhZH3ZI58mnkgxXPs0OXp51tKL7/8Fphgmt8R0AHs
X-Google-Smtp-Source: ABdhPJxz8iv8sDWWqygYoSnTBw3J+tox/oNRyTbYWIxOWQMDjG45/plb5Tn0mBUyg2KErJbpgxb5fYDplDXZAmY2OGSN1H2iKGB8
MIME-Version: 1.0
X-Received: by 2002:a02:c50d:: with SMTP id s13mr41360163jam.109.1593949934233;
 Sun, 05 Jul 2020 04:52:14 -0700 (PDT)
Date:   Sun, 05 Jul 2020 04:52:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009eaa8605a9b0632e@google.com>
Subject: INFO: trying to register non-static key in red_destroy
From:   syzbot <syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2b04a661 Merge branch 'cxgb4-add-mirror-action-support-for..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=161887bb100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2172f4d0dbc37e27
dashboard link: https://syzkaller.appspot.com/bug?extid=6e95a4fabf88dc217145
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13809e6d100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1527be6d100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com

batman_adv: batadv0: Interface activated: batadv_slave_1
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 6788 Comm: syz-executor510 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:894 [inline]
 register_lock_class+0x157d/0x1630 kernel/locking/lockdep.c:1206
 __lock_acquire+0xfa/0x56e0 kernel/locking/lockdep.c:4259
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 del_timer_sync+0xab/0x270 kernel/time/timer.c:1354
 red_destroy+0x33/0x70 net/sched/sch_red.c:219
 qdisc_create+0xcd9/0x12e0 net/sched/sch_api.c:1294
 tc_modify_qdisc+0x4c8/0x1990 net/sched/sch_api.c:1661
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x331/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4434e9
Code: Bad RIP value.
RSP: 002b:00007ffc7993dc38 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004434e9
RDX: 0492492492492642 RSI: 0000000020000180 RDI: 0000000000000004
RBP: 00007ffc7993dc40 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc7993dc50
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
