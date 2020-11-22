Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4022BC5E8
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgKVN4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 08:56:18 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:34484 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbgKVN4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 08:56:16 -0500
Received: by mail-io1-f72.google.com with SMTP id q6so4963349iog.1
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 05:56:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=tqgn9H/Q+B+44wovmA82s5k8ZV8xFvENoyPiymoIjZA=;
        b=mJbWfIXpgGQUuAgNxRySVm5ckSc4u66bF/qkfABIKdPgPSjDiYYTW0Oqns/VLXs8Oi
         JzVVe8cNp/OrQZtS7j2lWK5GnGOl8cVOWQO+XbX24uThJr92tncQDxb18QSOWuownbBA
         25GfPBF+ioABEAnXmDAeWMk9fMAvy4nNyLW6+XhiySb2Fy3pAt3o1ccVRQLV+sE+Hsek
         n2F4LEWzvBMwaJev/1UHcUl4oaA7ZgITiyTahJZm64zqVBVkZa39dRk6/utE1brqI+3U
         HOJdnud8T4qCs931V5bSUSn/r9VmyuJKNDVPuW+tqTQ5xmdCv7UBcIUWl17aq2G58Llb
         JgAA==
X-Gm-Message-State: AOAM5337s7AGX0z4S9CQ6qT+8ZhM703XHINFPjbVwHqFd/FG3XN6Mjlj
        H5c6IkUcNpQG3XhOBTLMIgcX039k7TelZOHDAYGKecl8+osr
X-Google-Smtp-Source: ABdhPJzF+SimZnu+MsknGU5cgEPUP9ISd+glkW7gXVcXDGsN0zXacfH8aaScC9rXO0QgvXUu8qkPY6VdFQbhubi3UweI8yA+No7D
MIME-Version: 1.0
X-Received: by 2002:a6b:b24b:: with SMTP id b72mr31049559iof.32.1606053375256;
 Sun, 22 Nov 2020 05:56:15 -0800 (PST)
Date:   Sun, 22 Nov 2020 05:56:15 -0800
In-Reply-To: <00000000000086205205b0fff8b2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ec2eb005b4b2704e@google.com>
Subject: Re: general protection fault in ieee80211_chanctx_num_assigned
From:   syzbot <syzbot+00ce7332120071df39b1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a349e4c6 Merge tag 'xfs-5.10-fixes-7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=144e1e99500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=330f3436df12fd44
dashboard link: https://syzkaller.appspot.com/bug?extid=00ce7332120071df39b1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153140a5500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=179bf835500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00ce7332120071df39b1@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xfbd59c0000000020: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
CPU: 1 PID: 8531 Comm: syz-executor169 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_chanctx_num_assigned+0xb1/0x140 net/mac80211/chan.c:21
Code: a8 f6 ff ff 48 39 c5 74 3b 49 bd 00 00 00 00 00 fc ff df e8 c1 91 1b f9 48 8d bb 58 09 00 00 41 83 c4 01 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 75 68 48 8b 83 58 09 00 00 48 8d 98 a8 f6 ff ff 48
RSP: 0018:ffffc9000169f330 EFLAGS: 00010a02
RAX: 1bd5a00000000020 RBX: deacfffffffff7a8 RCX: ffffffff88549e6b
RDX: ffff888011c8b480 RSI: ffffffff88549e0f RDI: dead000000000100
RBP: ffff8880130ca720 R08: 0000000000000000 R09: ffffffff8cecb9cf
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: dffffc0000000000 R14: ffff8880130ca700 R15: 0000000000000000
FS:  000000000087d940(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006d3090 CR3: 000000001c20a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee80211_assign_vif_chanctx+0x7b8/0x1230 net/mac80211/chan.c:690
 __ieee80211_vif_release_channel+0x236/0x430 net/mac80211/chan.c:1557
 ieee80211_vif_release_channel+0x117/0x220 net/mac80211/chan.c:1771
 ieee80211_ibss_disconnect+0x44e/0x7b0 net/mac80211/ibss.c:735
 ieee80211_ibss_leave+0x12/0xe0 net/mac80211/ibss.c:1871
 rdev_leave_ibss net/wireless/rdev-ops.h:545 [inline]
 __cfg80211_leave_ibss+0x19a/0x4c0 net/wireless/ibss.c:212
 cfg80211_leave_ibss+0x57/0x80 net/wireless/ibss.c:230
 cfg80211_change_iface+0x855/0xef0 net/wireless/util.c:1012
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3789
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
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
RIP: 0033:0x4429b9
Code: e8 bc fd 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd820d0a58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004429b9
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000004
RBP: 000000000000fbef R08: 00000000004035b0 R09: 00000000004035b0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403520
R13: 00000000004035b0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 4cedfcb59a8efe47 ]---
RIP: 0010:ieee80211_chanctx_num_assigned+0xb1/0x140 net/mac80211/chan.c:21
Code: a8 f6 ff ff 48 39 c5 74 3b 49 bd 00 00 00 00 00 fc ff df e8 c1 91 1b f9 48 8d bb 58 09 00 00 41 83 c4 01 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 75 68 48 8b 83 58 09 00 00 48 8d 98 a8 f6 ff ff 48
RSP: 0018:ffffc9000169f330 EFLAGS: 00010a02
RAX: 1bd5a00000000020 RBX: deacfffffffff7a8 RCX: ffffffff88549e6b
RDX: ffff888011c8b480 RSI: ffffffff88549e0f RDI: dead000000000100
RBP: ffff8880130ca720 R08: 0000000000000000 R09: ffffffff8cecb9cf
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: dffffc0000000000 R14: ffff8880130ca700 R15: 0000000000000000
FS:  000000000087d940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efedefa7000 CR3: 000000001c20a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

