Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389892E7C29
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgL3Tg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:36:58 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55186 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgL3Tg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:36:57 -0500
Received: by mail-io1-f72.google.com with SMTP id w26so7469831iox.21
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 11:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=koCWLqpSv5tpkG4NqSlK2H7TVsLFWhhWXiU9co6/ENc=;
        b=KnEJ6NXEcHKbQDI7MpZqEpERvmkL5X8Vp73zXjGKHEmBRDPuziqO4EnlaQYHcUU2Hi
         mjQEy5dLAre6ebR86lf9e90h3onEriLYzJHEOM9uOaStYtwuOqoNeJgEBUjHypsxAB+t
         pdw9s93nMt1qLCv+oBF6efvGC6uUuEQ5ASQZMPRGd8qejp/GslrN1WC2091uuk/ArFSC
         QNmVVc4IZoxGDr2+3EKOa6Ve5k7T8TXazb5MHgzpyS6WP7rPPwZj2lvwcoaSLG0IRLKi
         1CLowUUaJAM7BBJk8jRce1WntUl6fqX3/uk8Sw20IwlDvZvhAndQV+zNJreJTsXxJZ/I
         DcMA==
X-Gm-Message-State: AOAM531xJpijnha8JvS7RI9JL3Busj6XBUcf3KSUxR+LaZhNxLlSivaM
        0F+c6QF/HWWASHwzNCwHFbEK3/rfbzsIwVaFzuFvc2eta675
X-Google-Smtp-Source: ABdhPJyp41O3FIQy0uhXGqY834VIosA+CogvkXhL+6VKOIQkryyF0ShbAn7n2L1FDHocp5953RUCrBGdCmd8s+Nz+1Nu9yMIBU1C
MIME-Version: 1.0
X-Received: by 2002:a92:ce47:: with SMTP id a7mr54297656ilr.261.1609356975852;
 Wed, 30 Dec 2020 11:36:15 -0800 (PST)
Date:   Wed, 30 Dec 2020 11:36:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dcd05705b7b39eb6@google.com>
Subject: KASAN: use-after-free Read in vlan_dev_real_dev
From:   syzbot <syzbot+944af49d74bdd9175f4b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jwi@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1f45dc22 ibmvnic: continue fatal error reset after passive..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10dbe3ff500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c6feb14e07e1220
dashboard link: https://syzkaller.appspot.com/bug?extid=944af49d74bdd9175f4b
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+944af49d74bdd9175f4b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in is_vlan_dev include/linux/if_vlan.h:74 [inline]
BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120 net/8021q/vlan_core.c:105
Read of size 4 at addr ffff8880263c222c by task kworker/u4:0/8

CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: gid-cache-wq netdevice_event_work_handler
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 is_vlan_dev include/linux/if_vlan.h:74 [inline]
 vlan_dev_real_dev+0xf9/0x120 net/8021q/vlan_core.c:105
 rdma_vlan_dev_real_dev include/rdma/ib_addr.h:267 [inline]
 is_eth_port_of_netdev_filter.part.0+0xe7/0x300 drivers/infiniband/core/roce_gid_mgmt.c:157
 is_eth_port_of_netdev_filter+0x28/0x40 drivers/infiniband/core/roce_gid_mgmt.c:153
 ib_enum_roce_netdev+0x18f/0x2b0 drivers/infiniband/core/device.c:2287
 ib_enum_all_roce_netdevs+0xbd/0x130 drivers/infiniband/core/device.c:2316
 netdevice_event_work_handler+0x9c/0x1b0 drivers/infiniband/core/roce_gid_mgmt.c:626
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 19697:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc_node include/linux/slab.h:575 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:575
 kvmalloc include/linux/mm.h:773 [inline]
 kvzalloc include/linux/mm.h:781 [inline]
 alloc_netdev_mqs+0x97/0xea0 net/core/dev.c:10540
 rtnl_create_link+0x219/0xad0 net/core/rtnetlink.c:3171
 __rtnl_newlink+0xf9b/0x1750 net/core/rtnetlink.c:3433
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3502
 rtnetlink_rcv_msg+0x498/0xb80 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 19689:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:352
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3140 [inline]
 kfree+0xdb/0x3c0 mm/slub.c:4122
 kvfree+0x42/0x50 mm/util.c:604
 device_release+0x9f/0x240 drivers/base/core.c:1962
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 put_device+0x1b/0x30 drivers/base/core.c:3190
 free_netdev+0x3d7/0x500 net/core/dev.c:10660
 ppp_destroy_interface+0x2ab/0x340 drivers/net/ppp/ppp_generic.c:3358
 ppp_release+0x1bf/0x240 drivers/net/ppp/ppp_generic.c:410
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x1f0/0x200 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880263c2000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 556 bytes inside of
 4096-byte region [ffff8880263c2000, ffff8880263c3000)
The buggy address belongs to the page:
page:0000000052fa6739 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x263c0
head:0000000052fa6739 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010842140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880263c2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880263c2180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880263c2200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff8880263c2280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880263c2300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
