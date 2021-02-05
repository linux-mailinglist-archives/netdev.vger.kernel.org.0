Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F08311A94
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhBFD7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:59:39 -0500
Received: from mail-qk1-f198.google.com ([209.85.222.198]:49793 "EHLO
        mail-qk1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhBFD5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 22:57:03 -0500
Received: by mail-qk1-f198.google.com with SMTP id a75so7545769qkg.16
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 19:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=k/BHxNQ7qd2sz72tiD4lLbHL6/gf5P11FZOhOOaqDKA=;
        b=YCe18mzt/HMR6qL15U4V8SsGmLPNKHNDz6iO3uOtujHyq/Xz2qdphQMM9K5ojS4n3+
         OODnInHsg5xair4FueUQ84mG8g6kKxbBbudPl16MkBNFmS6UAb04Kbm27Xf7rZGn6NY6
         LrRe3lGbPZWpH7Ihh86kmIezAbsGtkI857GznXAAlw23szM2wKcV/msrPcVWuYa++S3W
         Igp6/K2qI+LDV57lJ/52/k3OoK3cC0XQ5SB+3FGXmuEZedvum6ZG4PiHNWTeKxTBw07L
         6Q805oC4zIBaVy67gjE8RnZL3jHj4VGiIoYjfMgHxmCUudbBZ5/6u00I7Y6Mnxvj5JTI
         EZXw==
X-Gm-Message-State: AOAM530ZQly7Ry6B7WuRduOhUALvrm6LCECu9jmBqy6J3meTFCmlVg+l
        f3zejY0rKF91mZT3t/mu2oDUpgXMFxIRCh+VHFDvIoHq7Q03
X-Google-Smtp-Source: ABdhPJwdOFBnVKo83ZB4DdRWVey1q8/jHZh+2YsaX0RH9Pbo7VV9KaKdLnAguLfe4eReVq4qZQ1yu5RmW6bcEsjv7K2iZ9rsyvRs
MIME-Version: 1.0
X-Received: by 2002:a02:5148:: with SMTP id s69mr7550314jaa.8.1612568424583;
 Fri, 05 Feb 2021 15:40:24 -0800 (PST)
Date:   Fri, 05 Feb 2021 15:40:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f9bb705ba9f5861@google.com>
Subject: general protection fault in ieee80211_assign_vif_chanctx
From:   syzbot <syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3aaf0a27 Merge tag 'clang-format-for-linux-v5.11-rc7' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11dde95f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=266a5362c89c8127
dashboard link: https://syzkaller.appspot.com/bug?extid=bbf402b783eeb6d908db
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fea674d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1054d88cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xfbd59c0000000020: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
CPU: 0 PID: 10022 Comm: syz-executor445 Not tainted 5.11.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_chanctx_num_assigned net/mac80211/chan.c:22 [inline]
RIP: 0010:ieee80211_assign_vif_chanctx+0x6a7/0xa80 net/mac80211/chan.c:746
Code: 08 00 0f 85 96 00 00 00 e9 f7 00 00 00 e8 a1 ce 8a f8 49 83 c6 20 31 db 4c 89 f5 0f 1f 84 00 00 00 00 00 48 89 e8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 ef e8 fa 34 ce f8 48 8b 6d 00 4c 39 f5
RSP: 0018:ffffc90007fef670 EFLAGS: 00010a02
RAX: 1bd5a00000000020 RBX: 0000000000000002 RCX: ffff8880156c1bc0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dead000000000100 R08: ffffffff88ecf9e5 R09: fffffbfff1b672de
R10: fffffbfff1b672de R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888013e2b020 R15: ffff88801bff0bc0
FS:  00007f5557b86700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5557b85288 CR3: 0000000024a0d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __ieee80211_vif_release_channel+0x279/0x540 net/mac80211/chan.c:1619
 ieee80211_vif_release_channel+0x13e/0x1a0 net/mac80211/chan.c:1833
 ieee80211_ibss_disconnect+0x6ea/0x870 net/mac80211/ibss.c:735
 ieee80211_ibss_leave+0x26/0xf0 net/mac80211/ibss.c:1871
 rdev_leave_ibss net/wireless/rdev-ops.h:545 [inline]
 __cfg80211_leave_ibss+0x11c/0x200 net/wireless/ibss.c:212
 cfg80211_leave_ibss+0x5c/0x70 net/wireless/ibss.c:230
 cfg80211_change_iface+0x428/0xaa0 net/wireless/util.c:1047
 nl80211_set_interface+0x497/0x7f0 net/wireless/nl80211.c:3839
 genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x9ae/0xd50 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x2bf/0x370 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446889
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5557b862f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004cb440 RCX: 0000000000446889
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000003
RBP: 00000000004cb44c R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 000000000049b254
R13: 0031313230386c6e R14: 0000000000000000 R15: 00000000004cb448
Modules linked in:
---[ end trace 986da0a98b3932dc ]---
RIP: 0010:ieee80211_chanctx_num_assigned net/mac80211/chan.c:22 [inline]
RIP: 0010:ieee80211_assign_vif_chanctx+0x6a7/0xa80 net/mac80211/chan.c:746
Code: 08 00 0f 85 96 00 00 00 e9 f7 00 00 00 e8 a1 ce 8a f8 49 83 c6 20 31 db 4c 89 f5 0f 1f 84 00 00 00 00 00 48 89 e8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 ef e8 fa 34 ce f8 48 8b 6d 00 4c 39 f5
RSP: 0018:ffffc90007fef670 EFLAGS: 00010a02
RAX: 1bd5a00000000020 RBX: 0000000000000002 RCX: ffff8880156c1bc0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dead000000000100 R08: ffffffff88ecf9e5 R09: fffffbfff1b672de
R10: fffffbfff1b672de R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888013e2b020 R15: ffff88801bff0bc0
FS:  00007f5557b86700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5557b43288 CR3: 0000000024a0d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
