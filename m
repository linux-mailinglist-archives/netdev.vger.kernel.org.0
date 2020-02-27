Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4978A1718DB
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 14:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgB0NhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 08:37:15 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:50437 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgB0NhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 08:37:14 -0500
Received: by mail-io1-f72.google.com with SMTP id e13so3521812iob.17
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 05:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=91gKwAo30RdFaoLYbTACNeuWe8Uq9JMFGOgZLkn6DM0=;
        b=CGVEt6NIpyanzSVK8ZPn352VUSFZpXUGkcHQEvGKUUF9/0XdZ1/Irpn0ufi0GDrN8+
         amauIez97+W9vJFxelf7fcPPJmxrZHd8YGTWm99vfdR7feqy2qZGIEEwmYfb1imqnPbB
         rLYM5Yt+bWNoHXwuwjrQapiu2P3locAye0o0gk7Q6Kw4MGD5VF8vCr/ZYscTAjNllNEo
         EnlC4hfc6nGSnZdDTCkhtKq3DHdJG5BD9inQvavrQ4WA2X/AJHOyKv6m/La/pE8miQnC
         Z8bsLv7e8Xr55grJPYM6nYXHGm7ft49ECF7iJ3A9Wm3Zw99wG2THw/PKyvJiayzo4PIM
         OLog==
X-Gm-Message-State: APjAAAWv34adOg8NfDXVtcLDnUGV5CuRvWObObfZnRZbSC9JkDFrpZWm
        cw5pFdFYFEQv6p+gf2d9KtcdF9T5B7vesRYoA4ED1DWGYTtN
X-Google-Smtp-Source: APXvYqywGKnMFJjs3rWZe5+hj65axWzzB3kF4VtBPQi5BXaiJgAILiOuOj0JukUfrY/DGKVti4s28K4XgJrVV2ZrQrQZRCY6QLH9
MIME-Version: 1.0
X-Received: by 2002:a5e:8c0d:: with SMTP id n13mr4788017ioj.138.1582810634019;
 Thu, 27 Feb 2020 05:37:14 -0800 (PST)
Date:   Thu, 27 Feb 2020 05:37:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000966862059f8ed1c8@google.com>
Subject: general protection fault in alb_fasten_mac_swap
From:   syzbot <syzbot+d54e40cf758e447e088e@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    54dedb5b Merge tag 'for-linus-5.6-rc3-tag' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d7da7ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e57a6b450fb9883
dashboard link: https://syzkaller.appspot.com/bug?extid=d54e40cf758e447e088e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d54e40cf758e447e088e@syzkaller.appspotmail.com

bond189: (slave bridge130): making interface the new active one
device bridge130 entered promiscuous mode
general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 0 PID: 2313 Comm: syz-executor.3 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rlb_req_update_slave_clients drivers/net/bonding/bond_alb.c:505 [inline]
RIP: 0010:alb_fasten_mac_swap+0x67c/0xda0 drivers/net/bonding/bond_alb.c:1063
Code: f7 48 8b 45 98 42 80 3c 30 00 74 08 48 89 df e8 6a bd e4 fc 4c 8b 33 45 89 e4 49 c1 e4 06 4b 8d 5c 26 30 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 45 bd e4 fc 48 8b 45 90 48 39 03
RSP: 0018:ffffc90004edee40 EFLAGS: 00010206
RAX: 0000000000000006 RBX: 0000000000000030 RCX: 0000000000000002
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000ffffffff
RBP: ffffc90004edeeb0 R08: ffffffff84cf74ca R09: fffff520009dbdbc
R10: fffff520009dbdbc R11: 0000000000000000 R12: 0000000000000000
R13: ffff888044db0b80 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fcb902f3700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000071a158 CR3: 00000000a816b000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bond_alb_handle_active_change+0x147f/0x1ba0 drivers/net/bonding/bond_alb.c:1750
 bond_change_active_slave+0x8c0/0x2b20 drivers/net/bonding/bond_main.c:910
 bond_select_active_slave+0x584/0xa80 drivers/net/bonding/bond_main.c:986
 bond_enslave+0x42af/0x59c0 drivers/net/bonding/bond_main.c:1823
 do_set_master net/core/rtnetlink.c:2468 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3346 [inline]
 rtnl_newlink+0x182f/0x1c00 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5436
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2478
 rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5454
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c429
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fcb902f2c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fcb902f36d4 RCX: 000000000045c429
RDX: 0000000006000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 000000000076bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f9 R14: 00000000004cc6da R15: 000000000076bfcc
Modules linked in:
---[ end trace 360aa5d46d32c48b ]---
RIP: 0010:rlb_req_update_slave_clients drivers/net/bonding/bond_alb.c:505 [inline]
RIP: 0010:alb_fasten_mac_swap+0x67c/0xda0 drivers/net/bonding/bond_alb.c:1063
Code: f7 48 8b 45 98 42 80 3c 30 00 74 08 48 89 df e8 6a bd e4 fc 4c 8b 33 45 89 e4 49 c1 e4 06 4b 8d 5c 26 30 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 45 bd e4 fc 48 8b 45 90 48 39 03
RSP: 0018:ffffc90004edee40 EFLAGS: 00010206
RAX: 0000000000000006 RBX: 0000000000000030 RCX: 0000000000000002
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00000000ffffffff
RBP: ffffc90004edeeb0 R08: ffffffff84cf74ca R09: fffff520009dbdbc
R10: fffff520009dbdbc R11: 0000000000000000 R12: 0000000000000000
R13: ffff888044db0b80 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fcb902f3700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000071a158 CR3: 00000000a816b000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
