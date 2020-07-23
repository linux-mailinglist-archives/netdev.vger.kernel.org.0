Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F18422B575
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgGWSMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:12:25 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52846 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgGWSMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:12:24 -0400
Received: by mail-il1-f198.google.com with SMTP id o17so4022226ilt.19
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gzxIG7ZgJvfHDwVFPiFV5LnmLx9pYYgVFI622Payd70=;
        b=jEIrjXP+5Y0Tb8Lqc3u34Mkh051nU4YCLK17bKKfWyrwALtZL/dhgUOPijTtlHY5ei
         5wVdQ4TvQJeaJbupLzOkotZkMCGv/yDlpiMtegJhNSQoee3yCKxQzhPSrAdYXbdyoUha
         5WJXWZknoNJSxZfAgQZKbmkrDRLQ4PoFwUZdKQg+nLkuz5be4dqw8MLAzxUAh/oPFgAC
         8/Ekrx80lP6MtmRbP4n8z6otbS636NmoD0OTnvTWaxu2DVzz1sekYu93SXb7S0WhBO2K
         8Y9t1+9kBIVx2vxHfPxr6lm/hQddj1mFYAWoqtgpWTqo9GNjPe1y7Yc9yVfskjeTLiUA
         kNFw==
X-Gm-Message-State: AOAM531s8G7a5nShdBeOLJJTvrxm9eNb44AvZZYtiCUm9WhWf16mzrxu
        6hIjzWgww+/GEL5wdSQjU+3qqWiRqVt/TFMmmQUhGnWjN/iR
X-Google-Smtp-Source: ABdhPJxcQqKWrZcaqpV5eK9Iw2oJX7eiNt6JQuTAmHMXAo2oYtCW/DAWjuyyjQ3L/HNwm1mhgk4WfMNwrraH1Ys9rjFC5s6NEiPB
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:dc4:: with SMTP id l4mr6425361ilj.134.1595527943146;
 Thu, 23 Jul 2020 11:12:23 -0700 (PDT)
Date:   Thu, 23 Jul 2020 11:12:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000047d80905ab1fccdb@google.com>
Subject: KASAN: use-after-free Read in vlan_dev_get_iflink
From:   syzbot <syzbot+d702fd2351989927037c@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8c26c87b Merge tag 'sound-5.8-rc7' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128af5ef100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=d702fd2351989927037c
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1567cae8900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150631b4900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d702fd2351989927037c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in vlan_dev_get_iflink+0x5f/0x70 net/8021q/vlan_dev.c:767
Read of size 4 at addr ffff888094a76100 by task syz-executor015/9454

CPU: 1 PID: 9454 Comm: syz-executor015 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 vlan_dev_get_iflink+0x5f/0x70 net/8021q/vlan_dev.c:767
 dev_get_iflink+0x73/0xe0 net/core/dev.c:814
 rfc2863_policy+0x243/0x2e0 net/core/link_watch.c:41
 linkwatch_do_dev+0x2a/0x180 net/core/link_watch.c:160
 linkwatch_forget_dev+0x16a/0x200 net/core/link_watch.c:237
 netdev_wait_allrefs net/core/dev.c:9678 [inline]
 netdev_run_todo+0x258/0xac0 net/core/dev.c:9774
 rtnl_unlock net/core/rtnetlink.c:112 [inline]
 rtnetlink_rcv_msg+0x45b/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446cf9
Code: Bad RIP value.
RSP: 002b:00007f4a27e29d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc78 RCX: 0000000000446cf9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 00000000006dbc70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc7c
R13: 0000000040000000 R14: 0000001000000000 R15: 0705001000000048

Allocated by task 9440:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:753 [inline]
 kvzalloc include/linux/mm.h:761 [inline]
 alloc_netdev_mqs+0x97/0xdc0 net/core/dev.c:9938
 rtnl_create_link+0x219/0xad0 net/core/rtnetlink.c:3067
 __rtnl_newlink+0xfa0/0x1730 net/core/rtnetlink.c:3329
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 9461:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 kvfree+0x42/0x50 mm/util.c:603
 device_release+0x71/0x200 drivers/base/core.c:1579
 kobject_cleanup lib/kobject.c:693 [inline]
 kobject_release lib/kobject.c:722 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c0/0x270 lib/kobject.c:739
 netdev_run_todo+0x765/0xac0 net/core/dev.c:9797
 rtnl_unlock net/core/rtnetlink.c:112 [inline]
 rtnetlink_rcv_msg+0x45b/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888094a76000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 256 bytes inside of
 4096-byte region [ffff888094a76000, ffff888094a77000)
The buggy address belongs to the page:
page:ffffea0002529d80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0002529d80 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea000251fe88 ffffea0002375c88 ffff8880aa002000
raw: 0000000000000000 ffff888094a76000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888094a76000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888094a76080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888094a76100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888094a76180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888094a76200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
