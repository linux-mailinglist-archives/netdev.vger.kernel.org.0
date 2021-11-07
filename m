Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2AE447238
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 09:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhKGIyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 03:54:02 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:56291 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhKGIyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 03:54:02 -0500
Received: by mail-io1-f71.google.com with SMTP id s21-20020a056602169500b005e184f81e0fso9190388iow.22
        for <netdev@vger.kernel.org>; Sun, 07 Nov 2021 01:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0snVIq2Bui/dySdfpi4a1QVUvDVLh4nBMkVbNdPRPao=;
        b=w7qRwpn1PUJn8j4mROtP4rf0HL29ab5nlk8EN8gbGyBNPChRFkT0Td4aY+TOx6bJHN
         KIPRXOZqrIQtwIuWjBYW4nZGkI89G1KoTguo+abGHHa24jrrnpLgIgoCwrSJRMjdnCZJ
         090tCZG1rkIbAxz/Q/bPVeMtVR3zh1/m24paNFKCVW91N8aLa0JOgWEv/l+3EN7TZUHV
         L55ZykXs3xbuBucBWlbMJ9V6ZqDpAFYnX6+m0KL0SS8NocHGeKJMdCdowFcHUBJ2G20k
         dZAW9Io8QoHlCWc+ROqBie6LZdAKz++A1wVquzMxKhXZXlkd4vXq8jMBplWdks4EKDLE
         wohA==
X-Gm-Message-State: AOAM531lbRfOXABLSz5d1wU55oQl0kznaBud4Nwcc0v4FoV1coCrlMjM
        ZKf9mrbPfrfvqhpkbgcRsgGyCQMpnuTfJmDjgWFLS8xvIA10
X-Google-Smtp-Source: ABdhPJz82QBJIuHxfhU93K92SbySnNOqP/KWwQPZlEV33Vtpa3NIsbfwANaRVhpNxBwmLHW7Ej1jkpW9ZUjKewWowfTKTdVAcLzo
MIME-Version: 1.0
X-Received: by 2002:a6b:6812:: with SMTP id d18mr1508988ioc.47.1636275079645;
 Sun, 07 Nov 2021 01:51:19 -0700 (PDT)
Date:   Sun, 07 Nov 2021 01:51:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e08e4a05d02efa66@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in ieee80211_set_tx_power
From:   syzbot <syzbot+79fbc232a705a30d93cd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cc0356d6a02e Merge tag 'x86_core_for_v5.16_rc1' of git://g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1414732eb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5d447cdc3ae81d9
dashboard link: https://syzkaller.appspot.com/bug?extid=79fbc232a705a30d93cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+79fbc232a705a30d93cd@syzkaller.appspotmail.com

netlink: 4 bytes leftover after parsing attributes in process `syz-executor.0'.
=============================
WARNING: suspicious RCU usage
5.15.0-syzkaller #0 Not tainted
-----------------------------
net/mac80211/cfg.c:2710 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/25174:
 #0: ffffffff8d183890 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:802
 #1: ffff88802ab60628 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5377 [inline]
 #1: ffff88802ab60628 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_set_wiphy+0x1c6/0x2c20 net/wireless/nl80211.c:3287

stack backtrace:
CPU: 0 PID: 25174 Comm: syz-executor.0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ieee80211_set_tx_power+0x74c/0x860 net/mac80211/cfg.c:2710
 rdev_set_tx_power net/wireless/rdev-ops.h:580 [inline]
 nl80211_set_wiphy+0xd5b/0x2c20 net/wireless/nl80211.c:3384
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbfe1b55ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbfdf0cb188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbfe1c68f60 RCX: 00007fbfe1b55ae9
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007fbfe1baff25 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff39e7553f R14: 00007fbfdf0cb300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
