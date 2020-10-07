Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3959285B99
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgJGJJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:09:25 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:42469 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgJGJJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:09:20 -0400
Received: by mail-il1-f205.google.com with SMTP id 18so1049939ilt.9
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 02:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gjt5a7t5G0GfobNHig+44qsKG0BT7BoaxNCvBIm3TkU=;
        b=BvAfQQEs9TsmAWjkZEwS7CezJNQ2ZZhPpBRfdmhrMOAo6O1M6KEhIcO/iw2SRBhHnr
         speFPR04/EZ82tnBb+gi3/B0ICaL57HWPKKmJp0EySsi4QAyljNE4rxKGGaNzL1mY82E
         oRxZzpcL6jA1JBlXC1x5A/bOdLRBzv89qYfR8HYg0I9ly6zir++/ATyVo1Z7ff+lELvw
         yneR/UCk6QtKT4stR+IBSfMIXj87dM6IB7fWQf52kVTKBLQdjbV2VS1u3f2jZbLrRyQN
         cg87fyPkTC/D/VMjoyd38cNvdJ5sDkvv1U96ylw6icgl6f3sC1gEf2cdDfWufV3bCCal
         OhXw==
X-Gm-Message-State: AOAM5316CEeKca9Ez+bIp6Io814sCCZC1tZtWbysIwybHpEvCBPvNTJ9
        xMb++aubI7mySE+9pv97zxfKuGCS0Crd4RXtUmKOoB3rxdWw
X-Google-Smtp-Source: ABdhPJyE065X85vepOdRHdgasS67W6CExJ2Q77ctqNi5BraeqXZMsTCX8ZFps3jg8VFj8XwSpJ3bL5hFqQJcfaa1kAe7Im6rhpph
MIME-Version: 1.0
X-Received: by 2002:a6b:3f88:: with SMTP id m130mr1584454ioa.78.1602061757744;
 Wed, 07 Oct 2020 02:09:17 -0700 (PDT)
Date:   Wed, 07 Oct 2020 02:09:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa89dc05b11111b7@google.com>
Subject: general protection fault in ieee80211_key_free
From:   syzbot <syzbot+847ae671fe8522d3491a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c85fb28b Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e6e93f900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de7f697da23057c7
dashboard link: https://syzkaller.appspot.com/bug?extid=847ae671fe8522d3491a
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102e1cbf900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1671821b900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+847ae671fe8522d3491a@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
general protection fault, probably for non-canonical address 0xdffffe7100000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x0000138800000008-0x000013880000000f]
CPU: 0 PID: 6852 Comm: syz-executor045 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_key_free+0x34/0x320 net/mac80211/key.c:893
Code: 50 89 f3 49 89 fc e8 9b 44 81 f9 4d 85 e4 0f 84 ae 00 00 00 48 bd 00 00 00 00 00 fc ff df 4d 8d 7c 24 08 4d 89 fe 49 c1 ee 03 <41> 80 3c 2e 00 74 08 4c 89 ff e8 1d 2b c1 f9 4d 8b 2f 4d 85 ed 0f
RSP: 0018:ffffc90005377880 EFLAGS: 00010202
RAX: ffffffff87f3b955 RBX: 0000000000000000 RCX: ffff88808f2fa000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000138800000000
RBP: dffffc0000000000 R08: ffffffff87ece20b R09: fffffbfff135f936
R10: fffffbfff135f936 R11: 0000000000000000 R12: 0000138800000000
R13: dffffc0000000000 R14: 0000027100000001 R15: 0000138800000008
FS:  000000000155f940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000040 CR3: 000000009e0b0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee80211_del_key+0x30c/0x360 net/mac80211/cfg.c:531
 rdev_del_key net/wireless/rdev-ops.h:107 [inline]
 nl80211_del_key+0x437/0x6f0 net/wireless/nl80211.c:4201
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0xaf5/0xd70 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44a339
Code: e8 dc 18 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeac18b158 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffeac18b1c0 RCX: 000000000044a339
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000003
RBP: 0000000000000032 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000000000048 R15: 0000000000000004
Modules linked in:
---[ end trace 1b70266a49263a4c ]---
RIP: 0010:ieee80211_key_free+0x34/0x320 net/mac80211/key.c:893
Code: 50 89 f3 49 89 fc e8 9b 44 81 f9 4d 85 e4 0f 84 ae 00 00 00 48 bd 00 00 00 00 00 fc ff df 4d 8d 7c 24 08 4d 89 fe 49 c1 ee 03 <41> 80 3c 2e 00 74 08 4c 89 ff e8 1d 2b c1 f9 4d 8b 2f 4d 85 ed 0f
RSP: 0018:ffffc90005377880 EFLAGS: 00010202
RAX: ffffffff87f3b955 RBX: 0000000000000000 RCX: ffff88808f2fa000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000138800000000
RBP: dffffc0000000000 R08: ffffffff87ece20b R09: fffffbfff135f936
R10: fffffbfff135f936 R11: 0000000000000000 R12: 0000138800000000
R13: dffffc0000000000 R14: 0000027100000001 R15: 0000138800000008
FS:  000000000155f940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2b37de36c0 CR3: 000000009e0b0000 CR4: 00000000001506f0
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
