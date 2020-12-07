Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D305D2D110D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgLGMwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:52:51 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:44761 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgLGMwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:52:51 -0500
Received: by mail-il1-f197.google.com with SMTP id c76so2660475ilf.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 04:52:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=E1loxOO0ot1jw4modLmt1T/jHFaPvObmHgTybF9H1O8=;
        b=kLLeC7cnjLnCHwkbOUKu03CzHwXjUisPyu6Gd6jwjwAGnYjglO926EOI9nUx9cDg+u
         uTtUYil/1WQnVNEcelmmSjl8DXUm0vKd5EAdhbFbgscryt0kShZOTG+XxnKWXX/ghJTF
         kL8Kdd+3E+J9iNOhnofxQ0IgYTt/YSWJxORou13ZFR9fkTSj6UG7vyvgh4D3Wq67qlFW
         J7nsywYQiGk9dLFuFGUEcpdA8w9I9r+/vyZ6PN+CDZNCagC7cWT+IgsnFRQEXT0jIhsl
         8KysmokBIAhM6Lcf5oqtSDmKooz0HfO1tZelgukevUVIj8NylVcSsPRZeqc2luNboF+V
         ruMg==
X-Gm-Message-State: AOAM533Gt00fxYQi9KcdTrAQYY1U8t3OQtW2xSHSFJfBF5N5fLUsnH92
        un/hV4ChCFGcKxWlvzIDplsPe3wDEnPfIk3AV4gm+yFFs2xU
X-Google-Smtp-Source: ABdhPJzgbjrYsA9M28vInM9sZmJICKCpgg+U3eqlZK16cZLAzTsEpgfDKkEikcz7Baou5i5y6TlrlNMWM18fz5TNFwW2mpQ/N/KJ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:100c:: with SMTP id n12mr12955778ilj.4.1607345530518;
 Mon, 07 Dec 2020 04:52:10 -0800 (PST)
Date:   Mon, 07 Dec 2020 04:52:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000060c28405b5df4b1b@google.com>
Subject: WARNING: ODEBUG bug in slave_kobj_release
From:   syzbot <syzbot+7bce4c2f7e1768ec3fe0@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    34816d20 Merge tag 'gfs2-v5.10-rc5-fixes' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153f779d500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e49433cfed49b7d9
dashboard link: https://syzkaller.appspot.com/bug?extid=7bce4c2f7e1768ec3fe0
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7bce4c2f7e1768ec3fe0@syzkaller.appspotmail.com

kobject_add_internal failed for bonding_slave (error: -12 parent: veth213)
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 1 PID: 22707 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 22707 Comm: syz-executor.4 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 20 a2 9d 89 4c 89 ee 48 c7 c7 20 96 9d 89 e8 1e 0e f2 04 <0f> 0b 83 05 a5 87 32 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000e37e9a0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8158c855 RDI: fffff52001c6fd26
RBP: 0000000000000001 R08: 0000000000000001 R09: ffff8880b9f2011b
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff894d3be0
R13: ffffffff899d9ca0 R14: ffffffff815f15f0 R15: 1ffff92001c6fd3f
FS:  00007fc5d258d700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000749138 CR3: 0000000052e81000 CR4: 0000000000350ee0
Call Trace:
 debug_object_assert_init lib/debugobjects.c:890 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:861
 debug_timer_assert_init kernel/time/timer.c:737 [inline]
 debug_assert_init kernel/time/timer.c:782 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1202
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1252
 __cancel_work_timer+0xa6/0x520 kernel/workqueue.c:3095
 slave_kobj_release+0x48/0xe0 drivers/net/bonding/bond_main.c:1468
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 bond_kobj_init drivers/net/bonding/bond_main.c:1489 [inline]
 bond_alloc_slave drivers/net/bonding/bond_main.c:1506 [inline]
 bond_enslave+0x2488/0x4bf0 drivers/net/bonding/bond_main.c:1708
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2517
 do_setlink+0x911/0x3a70 net/core/rtnetlink.c:2713
 __rtnl_newlink+0xc1c/0x1740 net/core/rtnetlink.c:3374
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
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
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc5d258cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002e740 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 00007fc5d258cca0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000009
R13: 00007ffdcf6b003f R14: 00007fc5d258d9c0 R15: 000000000119bf2c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
