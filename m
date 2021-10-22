Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6539437CAD
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhJVSnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:43:43 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54956 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhJVSnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 14:43:43 -0400
Received: by mail-io1-f72.google.com with SMTP id ay23-20020a5d9d97000000b005de70aa0cb9so1194423iob.21
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 11:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uzHEu8JcrOhTmWUji7U7XIAkxlSL4g7hVEq0Ja4DQ40=;
        b=ve03iEDOnxAIriIH/0ZFcJkLa1NrgPddHOC2WG5aEcGCD3fMV1JJMh68gjzo0A38gZ
         31xM6YzmvFnOeyk0j2Vf/CyXCOWDRevlaTkgwt0a8oOEB26HkN4C2F+dZcaQVlKUy7QK
         qATN0rZ9KVWtbMSBq/JOC0aytrrfjiXkXQ5G5re2aXV5VKfgLoy6ORnfwzECuzObzNbd
         i4CHX6f615Bc6ENgKaORH/5ntof6GOzutDgvNK9I9Ud3Op6NPHqd7tMaV9l5xjYOJ5BN
         uGvblTu2iNynvdHDTpUPXpMNo3wZFfy1DXCipReESAMO7GnyP+4lGO324nMAIIecyK4O
         lZAg==
X-Gm-Message-State: AOAM530BwOXYkwIz2TemI9+dDjsNK+tqjgZSFihGdedmtS3V0UnAaB88
        VtLDiZxAWj3KebHrEA8ALzZYr1/THMgXZU/EY9Iofn4waTUK
X-Google-Smtp-Source: ABdhPJxRQqZLZSCanV9ISO1MVWEVuagxTVVVIOCj0tH6GVZa8TIqZbGVlUZT+7dHExrn8qUR3kJiXPj3je7oQOLcGm1sK2ZZyGxe
MIME-Version: 1.0
X-Received: by 2002:a6b:cd8c:: with SMTP id d134mr860000iog.191.1634928085221;
 Fri, 22 Oct 2021 11:41:25 -0700 (PDT)
Date:   Fri, 22 Oct 2021 11:41:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0c8d505cef55b23@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in batadv_nc_mesh_free
From:   syzbot <syzbot+1dca817d274a3fb19f2b@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e0bfcf9c77d9 Merge tag 'mlx5-fixes-2021-10-20' of git://gi..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17900a0cb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
dashboard link: https://syzkaller.appspot.com/bug?extid=1dca817d274a3fb19f2b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144d76b4b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14732b80b00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14093652b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16093652b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12093652b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1dca817d274a3fb19f2b@syzkaller.appspotmail.com

R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 6548 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 6548 Comm: syz-executor286 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 80 3e e4 89 4c 89 ee 48 c7 c7 80 32 e4 89 e8 5e 1d 15 05 <0f> 0b 83 05 d5 39 90 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90002d7ecc0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff8880163c8000 RSI: ffffffff815e88a8 RDI: fffff520005afd8a
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815e264e R11: 0000000000000000 R12: ffffffff898de560
R13: ffffffff89e43900 R14: ffffffff81658550 R15: 1ffff920005afda3
FS:  0000555555c03300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef3003e098 CR3: 0000000073ad0000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 debug_object_assert_init lib/debugobjects.c:895 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
 debug_timer_assert_init kernel/time/timer.c:739 [inline]
 debug_assert_init kernel/time/timer.c:784 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1204
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1270
 __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3129
 batadv_nc_mesh_free+0x41/0x120 net/batman-adv/network-coding.c:1869
 batadv_mesh_free+0x7d/0x170 net/batman-adv/main.c:245
 batadv_mesh_init+0x62f/0x710 net/batman-adv/main.c:226
 batadv_softif_init_late+0xad4/0xdd0 net/batman-adv/soft-interface.c:804
 register_netdevice+0x51e/0x1500 net/core/dev.c:10229
 batadv_softif_newlink+0x6e/0x90 net/batman-adv/soft-interface.c:1068
 __rtnl_newlink+0x106d/0x1750 net/core/rtnetlink.c:3458
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f14439a87e9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffda1fa6268 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f14439a87e9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007ffda1fa6270 R08: 0000000000000002 R09: 00007f1443003531
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
