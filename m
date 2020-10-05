Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8128D283276
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgJEIse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:48:34 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:46881 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:48:27 -0400
Received: by mail-io1-f78.google.com with SMTP id a2so4321364iod.13
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 01:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OUJvcrRoLVHuAD2WVAsPEEDuXrOPyxsu9xuXhFtzrtQ=;
        b=IcAXTCnhFpDwcObyNFARtt1WtEPAB6WwtOgbdRvuH5KVVS0x86PoMbx+cFFhOUDpJ0
         H33BPJc9ApmvT3ReIwn5Syg813dDuYc/ZlBdsdsdP1usmQr/0ap8ISvnuAzifvXlJgBQ
         XHRGs1OnMqtmWnYX6GcLRgMPNnZc7HnfF0fL1+gjU1y9Y7WDIVLlG+2iCnz9pLnoQFu4
         u1HOYRbcyZqJpwIomyuBZYE6gaHAN17YNnak/Lw0bEwgOQoRWGt3991e7Kb98lwGyKcJ
         iBgvHwbAQQyO4kJBYLfPziU/tmGRPt1CA8snrriEGlB9DQUtYEzLSfqh07/rU+KdOG+S
         ybog==
X-Gm-Message-State: AOAM530tbmhUFlzem10tnbOQ5jsgd6qnKgtT26Jjbha0FPR4Dd/PskV2
        k3txiEEwQsGGtGpLNhjGEc5Mns8t/aQSRWy45ypF9sjPf4Xj
X-Google-Smtp-Source: ABdhPJwZd2mpAWZuXJjasd1cOfQ0ayivPA9DiOAIbMZYwlPgSNKW+yV5Lu6m8NU0qZi8aLUTdXmYGMsgw7tRHj5EwDB3I1yRHgrI
MIME-Version: 1.0
X-Received: by 2002:a5d:9e47:: with SMTP id i7mr10302204ioi.52.1601887704990;
 Mon, 05 Oct 2020 01:48:24 -0700 (PDT)
Date:   Mon, 05 Oct 2020 01:48:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a04cf205b0e88bb3@google.com>
Subject: WARNING in ieee80211_s1g_channel_width
From:   syzbot <syzbot+92715a0eccd6c881bc32@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        thomas@adapt-ip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    678cdd49 Merge branch 'genetlink-support-per-command-polic..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=158bb760500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1e6c5266df853ae
dashboard link: https://syzkaller.appspot.com/bug?extid=92715a0eccd6c881bc32
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ac92af900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15bcb733900000

The issue was bisected to:

commit 11b34737b18a70c74d5cf13ee58d36e95879013c
Author: Thomas Pedersen <thomas@adapt-ip.com>
Date:   Tue Sep 8 19:03:06 2020 +0000

    nl80211: support setting S1G channels

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=128cbf7b900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=118cbf7b900000
console output: https://syzkaller.appspot.com/x/log.txt?x=168cbf7b900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92715a0eccd6c881bc32@syzkaller.appspotmail.com
Fixes: 11b34737b18a ("nl80211: support setting S1G channels")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6864 at net/wireless/util.c:117 ieee80211_s1g_channel_width+0x51/0x180 net/wireless/util.c:117
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6864 Comm: syz-executor803 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:ieee80211_s1g_channel_width+0x51/0x180 net/wireless/util.c:117
Code: ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 34 01 00 00 8b 2b bf 04 00 00 00 89 ee e8 59 13 c1 f9 83 fd 04 74 19 e8 ef 16 c1 f9 <0f> 0b 45 31 e4 e8 e5 16 c1 f9 44 89 e0 5b 5d 41 5c 41 5d c3 e8 d6
RSP: 0018:ffffc900044172d0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8882179037d0 RCX: ffffffff87b570b7
RDX: ffff88808dc361c0 RSI: ffffffff87b570c1 RDI: 0000000000000005
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffc900044173f8
R10: 0000000000000004 R11: 1ffffffff19a4e5d R12: 0000000000000000
R13: 000000000000148c R14: 0000000000000000 R15: ffffc90004417404
 cfg80211_chandef_valid+0x222/0xc30 net/wireless/chan.c:227
 nl80211_parse_chandef+0x5ed/0xdf0 net/wireless/nl80211.c:2979
 __nl80211_set_channel+0x2e3/0x860 net/wireless/nl80211.c:3016
 nl80211_set_wiphy+0xa6c/0x2d40 net/wireless/nl80211.c:3189
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x518/0x940 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440979
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 11 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc9e2880d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440979
RDX: 0000000000000000 RSI: 0000000020001f40 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000008 R09: 00000000004002c8
R10: 0000000000000026 R11: 0000000000000246 R12: 0000000000401f60
R13: 0000000000401ff0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
