Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713D622BB1D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgGXArS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:47:18 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:55676 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgGXArQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 20:47:16 -0400
Received: by mail-il1-f200.google.com with SMTP id b2so4688069ilh.22
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 17:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BNZWFIG+mhHqzyvESfY+ZRyDftcwSaoYvJcMAf54kFo=;
        b=t1acrpAfJnDPS+8RZK9lkiaNw3uC0X2wDM5rLnGa0ZYdlZPgtvTKvbJswR9MlxNM/C
         p3RvlH+JdhUuerQqKx3t+9T4MUdTuBil9PslIPcF2O2MCPKri+nE4YDI/mhNpcE9j60e
         L/P1qtRa2UrzWtm1r6HZ6RS8o8CxAteflpXJ5ATREpnnz5NO2pYyfml0EU31qkA7qUt/
         GZZs2l+fPilguoyJn6lghgXMEfZMFhSgcPosqw1a92BHJr/kvdhyNkvLj33GtPqNdsa7
         Onn/EsLvk0MZVDsFQYGPnvTP7VOu8MOVx+G5MXuA7Q6Bhan5pUYtoRcJtj9zabBlSLfe
         RZpQ==
X-Gm-Message-State: AOAM530aNfZqhtcw208TCy/+l4+o4OZBc7J6D9ZY9VvRZ3mCq2EpLkHH
        Uh0r/irrIrvoAc0stSiVTrglrPU9Lfn0UGbSfZ6Ija5o7CAB
X-Google-Smtp-Source: ABdhPJzWyLJSNW/Mt0wdgB2csu8hpv3eWZ6rnnpIntP4GG4OBM/43v4fRJm25pHgfTasHfNEJp+KC9KJCMRdCbRiuhSfGj18e4nR
MIME-Version: 1.0
X-Received: by 2002:a5e:8d15:: with SMTP id m21mr7894473ioj.60.1595551634488;
 Thu, 23 Jul 2020 17:47:14 -0700 (PDT)
Date:   Thu, 23 Jul 2020 17:47:14 -0700
In-Reply-To: <0000000000003df98d05ab06aac6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065017c05ab255072@google.com>
Subject: Re: KASAN: use-after-free Read in linkwatch_fire_event
From:   syzbot <syzbot+987da0fff3a594532ce1@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    4f5baedd Add linux-next specific files for 20200723
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12e497b4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=785eb1cc9c75f625
dashboard link: https://syzkaller.appspot.com/bug?extid=987da0fff3a594532ce1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11043454900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16579f78900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+987da0fff3a594532ce1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_add_valid+0x93/0xa0 lib/list_debug.c:26
Read of size 8 at addr ffff888065294570 by task syz-executor076/31793
CPU: 1 PID: 31793 Comm: syz-executor076 Not tainted 5.8.0-rc6-next-20200723-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __list_add_valid+0x93/0xa0 lib/list_debug.c:26
 __list_add include/linux/list.h:67 [inline]
 list_add_tail include/linux/list.h:100 [inline]
 linkwatch_add_event net/core/link_watch.c:111 [inline]
 linkwatch_fire_event+0xea/0x1d0 net/core/link_watch.c:261
 netif_carrier_off net/sched/sch_generic.c:513 [inline]
 netif_carrier_off+0x96/0xb0 net/sched/sch_generic.c:507
 bond_newlink drivers/net/bonding/bond_netlink.c:460 [inline]
 bond_newlink+0x52/0xa0 drivers/net/bonding/bond_netlink.c:448
 __rtnl_newlink+0x1090/0x1750 net/core/rtnetlink.c:3339
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44a979
Code: Bad RIP value.
RSP: 002b:00007f1740ffbd98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006e69e8 RCX: 000000000044a979
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00000000006e69e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e69ec
R13: 0000000000000000 R14: 0000000000000000 R15: 068500100000003c
Allocated by task 31587:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmalloc_node include/linux/slab.h:577 [inline]
 kvmalloc_node+0xb4/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:760 [inline]
 kvzalloc include/linux/mm.h:768 [inline]
 alloc_netdev_mqs+0x97/0xdc0 net/core/dev.c:9961
 rtnl_create_link+0x219/0xad0 net/core/rtnetlink.c:3067
 __rtnl_newlink+0xfa0/0x1750 net/core/rtnetlink.c:3329
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
Freed by task 31587:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3756
 kvfree+0x42/0x50 mm/util.c:603
 device_release+0x71/0x200 drivers/base/core.c:1791
 kobject_cleanup lib/kobject.c:704 [inline]
 kobject_release lib/kobject.c:735 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x171/0x270 lib/kobject.c:752
 put_device+0x1b/0x30 drivers/base/core.c:3020
 free_netdev+0x35d/0x480 net/core/dev.c:10077
 __rtnl_newlink+0x14d8/0x1750 net/core/rtnetlink.c:3354
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2450
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
The buggy address belongs to the object at ffff888065294000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 1392 bytes inside of
 8192-byte region [ffff888065294000, ffff888065296000)
The buggy address belongs to the page:
page:00000000d305b100 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x65294
head:00000000d305b100 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea000194b708 ffffea00019eb908 ffff8880aa000a00
raw: 0000000000000000 ffff888065294000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff888065294400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888065294480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888065294500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff888065294580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888065294600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

