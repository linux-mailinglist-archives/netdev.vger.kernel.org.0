Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A54438512
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhJWT4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 15:56:45 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:49912 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhJWT4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 15:56:45 -0400
Received: by mail-il1-f199.google.com with SMTP id e10-20020a92194a000000b00258acd999afso4401471ilm.16
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 12:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oBqxmkYJ35ODYS3LLZ0zgLwniNIka8k3CCqPQnjb8kE=;
        b=W86vQnJiDBSQl96Hp6hkg9xwZVTdxpf+Pax/77nvci3aKRKdYuMoO8sCNNqeT4eiPV
         n2s+tEqmLoLEnMx215I7YuMZb/zWSnj3BK4CJyy+UOKqe70/4TQgXBXnCxlD/obOl0r4
         Wrw1i0lJnggVVgQTVurRu46qpowG3bpemKtTguCaalO/YNw+Q1xYmPOdTuaSbCO+0Q1/
         qJPpuwZqx3O5YGrXMsyunmI6RFQ/3O3Qvv6Y34Wzzl7Fd37S9V28JhJJuIhFZN0XB58L
         ARt5llomi381gB9QZWS9/DiNY4GqwoXTc2fXICfvHxiDOZKw4DZdBA2iTdldGQZlcCok
         GtHg==
X-Gm-Message-State: AOAM533CYp5+GnMwrfUmu6IRde2ALTdq3ig1ow1Mudt7hAWym2MVgBAf
        lq3c2zs4nwtN6X6mYaPrBTLIPT7c4mAvhxzxJOtficIbs23n
X-Google-Smtp-Source: ABdhPJw5NKItnuVtd5v5imvzltcc2aHR7mroG8ep8h/SdztrsJRfgKlmgCLpIemNDb4l/ytyku4NrimT3m0kAu0mmhpgNbKCA5gE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c6:: with SMTP id 6mr4588666ilx.220.1635018865582;
 Sat, 23 Oct 2021 12:54:25 -0700 (PDT)
Date:   Sat, 23 Oct 2021 12:54:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af277405cf0a7ef0@google.com>
Subject: [syzbot] WARNING in nsim_dev_reload_destroy
From:   syzbot <syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@nvidia.com, kuba@kernel.org,
        leonro@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0998aee279c3 Merge branch 'delete-impossible-devlink-notif..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=115dd272b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d36d2402e8523638
dashboard link: https://syzkaller.appspot.com/bug?extid=93d5accfaefceedf43c1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156b91acb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=153aefb4b00000

The issue was bisected to:

commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
Author: Leon Romanovsky <leonro@nvidia.com>
Date:   Thu Oct 21 14:16:14 2021 +0000

    devlink: Remove not-executed trap policer notifications

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12450a72b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11450a72b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16450a72b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")

netdevsim netdevsim0 netdevsim2 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim1 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim0 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6553 at net/core/devlink.c:11162 devlink_trap_groups_unregister+0xe8/0x110 net/core/devlink.c:11162
Modules linked in:
CPU: 0 PID: 6553 Comm: syz-executor166 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:devlink_trap_groups_unregister+0xe8/0x110 net/core/devlink.c:11162
Code: ff ff 31 ff 89 de e8 97 e3 41 fa 83 fb ff 75 cc e8 4d dc 41 fa 4c 89 f7 5b 5d 41 5c 41 5d 41 5e e9 6d 79 05 02 e8 38 dc 41 fa <0f> 0b e9 71 ff ff ff 4c 89 ef e8 19 4f 89 fa e9 3b ff ff ff 48 89
RSP: 0018:ffffc90002d8f3b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000000000
RDX: ffff888024a00000 RSI: ffffffff87350e68 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff87350dd7 R11: 0000000000000000 R12: ffffffff8a263c20
R13: ffff888077d36000 R14: dffffc0000000000 R15: ffff888077d36388
FS:  000055555711e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200004c0 CR3: 0000000070465000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nsim_dev_traps_exit+0x67/0x170 drivers/net/netdevsim/dev.c:849
 nsim_dev_reload_destroy+0x20c/0x2f0 drivers/net/netdevsim/dev.c:1559
 nsim_dev_reload_down+0xdf/0x180 drivers/net/netdevsim/dev.c:883
 devlink_reload+0x53b/0x6b0 net/core/devlink.c:4040
 devlink_nl_cmd_reload+0x6ed/0x11d0 net/core/devlink.c:4161
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
RIP: 0033:0x7f02abf45409
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeed83e458 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffeed83e468 RCX: 00007f02abf45409
RDX: 0000000000000000 RSI: 0000000020000600 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffeed83e470
R13: 00007ffeed83e490 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
