Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0574E20C575
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 04:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgF1CrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 22:47:16 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:33753 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgF1CrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 22:47:16 -0400
Received: by mail-il1-f199.google.com with SMTP id c11so9602183ilq.0
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 19:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=c1GKZ6J1NGU57Y1YR1YuMj5khvHg20R1XXcT4R4FFeI=;
        b=ox0IkaiAXMMvS98RpLKxSmux9/PMT0djiIsWZSBi98TkgqkiEXt8fRrXw/LNoeXkHb
         mYdX6EnxiaX4S4Z3l2TCFSbJvB9Q7QS3r/avllxLQXMNGBd07L13+LCpHpPJIxQIkmZj
         JNaDKTrZX5FhpI0KPuep/DWlTDJhU23wTAzN1BSZT2dzz61ilzB/oQHN390qZYfIewbX
         tnRwfArDmY8+4fHFQB99fejQPRMwIldJVY3ySphkriGv6eCWRJ9gsPiVdpCf2MurCrJN
         JNSe4pbUNN8hChXBpJRR5E5gTXRrIrYYaDROex+K5BW6n6+SDpQuMTlzQJ2lVyb1UoO5
         xE5Q==
X-Gm-Message-State: AOAM533CrvooQcjXEoiLuv5CGgewJQpcxWtxh2DATbmRzYWk5xvPcq4G
        USel+CzuP8XWoltis5/jU9y4hKfeTMHy+EIYlm72k7fNrLzt
X-Google-Smtp-Source: ABdhPJyS9KZ9H5jXc55MM7nSDRyoQ39AMmRehTQnBu4C5jfXq5WQkBSF79QO9nqilAdOoQjC2A4JxkkgsL0hAe75D61wEIM/QIZj
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d2:: with SMTP id r18mr10557876ilq.263.1593312434826;
 Sat, 27 Jun 2020 19:47:14 -0700 (PDT)
Date:   Sat, 27 Jun 2020 19:47:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b1b74105a91bf53d@google.com>
Subject: KASAN: use-after-free Read in macvlan_dev_get_iflink
From:   syzbot <syzbot+95eec132c4bd9b1d8430@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1070059b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20c907630cbdbe5
dashboard link: https://syzkaller.appspot.com/bug?extid=95eec132c4bd9b1d8430
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1559e6e5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16aadd29100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+95eec132c4bd9b1d8430@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in macvlan_dev_get_iflink+0x6a/0x70 drivers/net/macvlan.c:1137
Read of size 4 at addr ffff88808b62a100 by task syz-executor984/7033

CPU: 0 PID: 7033 Comm: syz-executor984 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 macvlan_dev_get_iflink+0x6a/0x70 drivers/net/macvlan.c:1137
 default_operstate net/core/link_watch.c:41 [inline]
 rfc2863_policy+0x11f/0x2a0 net/core/link_watch.c:53
 linkwatch_do_dev+0x3a/0x160 net/core/link_watch.c:160
 netdev_wait_allrefs net/core/dev.c:9678 [inline]
 netdev_run_todo+0x2c8/0xc90 net/core/dev.c:9774
 rtnl_unlock net/core/rtnetlink.c:112 [inline]
 rtnetlink_rcv_msg+0x890/0xd40 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446e69
Code: Bad RIP value.
RSP: 002b:00007f7fa3a46d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc98 RCX: 0000000000446e69
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 00000000006dbc90 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: 0000000000000246 R12: 00000000006dbc9c
R13: 0000000000000000 R14: 0000000000000000 R15: 0705001000000048

Allocated by task 7001:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x81/0x110 mm/util.c:574
 kvmalloc include/linux/mm.h:753 [inline]
 kvzalloc include/linux/mm.h:761 [inline]
 alloc_netdev_mqs+0x86/0xf90 net/core/dev.c:9938
 rtnl_create_link+0x242/0x9c0 net/core/rtnetlink.c:3067
 __rtnl_newlink net/core/rtnetlink.c:3329 [inline]
 rtnl_newlink+0x12a2/0x1bf0 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 7001:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 device_release+0x70/0x1a0 drivers/base/core.c:1555
 kobject_cleanup lib/kobject.c:693 [inline]
 kobject_release lib/kobject.c:722 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x15b/0x220 lib/kobject.c:739
 netdev_run_todo+0xb17/0xc90 net/core/dev.c:9797
 rtnl_unlock net/core/rtnetlink.c:112 [inline]
 rtnetlink_rcv_msg+0x890/0xd40 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88808b62a000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 256 bytes inside of
 4096-byte region [ffff88808b62a000, ffff88808b62b000)
The buggy address belongs to the page:
page:ffffea00022d8a80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea00022d8a80 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002a12288 ffffea0002462c08 ffff8880aa402000
raw: 0000000000000000 ffff88808b62a000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808b62a000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808b62a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88808b62a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88808b62a180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808b62a200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
