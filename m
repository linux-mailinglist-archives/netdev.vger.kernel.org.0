Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8CF3FFBCE
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348282AbhICIVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:21:37 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:57190 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348231AbhICIV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 04:21:26 -0400
Received: by mail-il1-f199.google.com with SMTP id v9-20020a92c6c9000000b00226d10082a6so3012051ilm.23
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 01:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0y1zQv+iil0clIoIPqXnW+gwh7pavjlHU6bypZMcgKc=;
        b=AZLdQ1xnnJr24lK9sXQe2/g34uj5kSSH0PYBhAyutuLNOCD9kgBzumHyZr8LhL+JFF
         Vr1eADDDlmyYKuipO0xb4qsu2AslCP56ERCvujlkUkqAE1WgFsPaWtwQgktZDVHPEHJ3
         JrMdzGiHqmm8vO0c6Ky7iSQ815lkXx1VlIvPpxn2vMzW8UYV+iAubnJnFXn583uxtHO9
         fgkxG/eYugHjIXmuSgrG7xoXqDnqSkLAnBeevDoLHcBbLkFgxlhFr+c8dD0PIpGsp/Y5
         pM7rDVuIXL/HZ1CC/aV1dKVAKQ/N4r8vX3UtVnHNmJdjHgxI2PloVFFd5gw4maQufyuq
         0VlQ==
X-Gm-Message-State: AOAM533SVe9EzCMTJJV/HMZUGLQ5bY0dErQnoU8FGTJcD/3S5vVKu4pT
        arzvIbVe9YxrbhUMHNjAb9bKqx5KnCp71DUZ3X1wsaA/z7nE
X-Google-Smtp-Source: ABdhPJzH+erI+qRsXrwZtYUnmqhl2/NZ15wa42d9qHfaHBZAcZca0hMrAm1MNot1NoGo0F6KDmkIJ0vrMWpwZzrket286TtZmr8q
MIME-Version: 1.0
X-Received: by 2002:a5d:9681:: with SMTP id m1mr2106435ion.113.1630657227166;
 Fri, 03 Sep 2021 01:20:27 -0700 (PDT)
Date:   Fri, 03 Sep 2021 01:20:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c69b0f05cb12f8bc@google.com>
Subject: [syzbot] KASAN: use-after-free Read in ovs_ct_exit (2)
From:   syzbot <syzbot+5287ee27c6da3ab2d054@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0d55649d2ad7 net: phy: marvell10g: fix broken PHY interrup..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1780d7ad300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=765eea9a273a8879
dashboard link: https://syzkaller.appspot.com/bug?extid=5287ee27c6da3ab2d054
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5287ee27c6da3ab2d054@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim0 (unregistering): unset [0, 0] type 1 family 0 port 8472 - 0
netdevsim netdevsim0 netdevsim0 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
==================================================================
BUG: KASAN: use-after-free in ovs_ct_limit_exit net/openvswitch/conntrack.c:1909 [inline]
BUG: KASAN: use-after-free in ovs_ct_exit+0x2df/0x4a0 net/openvswitch/conntrack.c:2303
Read of size 8 at addr ffff888060b8aa00 by task kworker/u4:5/17848

CPU: 0 PID: 17848 Comm: kworker/u4:5 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 ovs_ct_limit_exit net/openvswitch/conntrack.c:1909 [inline]
 ovs_ct_exit+0x2df/0x4a0 net/openvswitch/conntrack.c:2303
 ovs_exit_net+0x19c/0xbc0 net/openvswitch/datapath.c:2536
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:175
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 30495:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:591 [inline]
 ovs_ct_limit_set_zone_limit net/openvswitch/conntrack.c:1972 [inline]
 ovs_ct_limit_cmd_set+0x3dd/0xc70 net/openvswitch/conntrack.c:2148
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2959
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3677
 kernel_sendpage net/socket.c:3674 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1002
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1b3/0x280 fs/splice.c:979
 do_sendfile+0x9f0/0x1120 fs/read_write.c:1260
 __do_sys_sendfile64 fs/read_write.c:1325 [inline]
 __se_sys_sendfile64 fs/read_write.c:1311 [inline]
 __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1311
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 28572:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1628 [inline]
 slab_free_freelist_hook+0xe3/0x250 mm/slub.c:1653
 slab_free mm/slub.c:3213 [inline]
 kmem_cache_free_bulk mm/slub.c:3354 [inline]
 kmem_cache_free_bulk+0x3fa/0xa90 mm/slub.c:3341
 kfree_bulk include/linux/slab.h:448 [inline]
 kfree_rcu_work+0x4db/0x870 kernel/rcu/tree.c:3317
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3594
 ovs_ct_limit_exit net/openvswitch/conntrack.c:1911 [inline]
 ovs_ct_exit+0x21e/0x4a0 net/openvswitch/conntrack.c:2303
 ovs_exit_net+0x19c/0xbc0 net/openvswitch/datapath.c:2536
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:175
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff888060b8aa00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 64-byte region [ffff888060b8aa00, ffff888060b8aa40)
The buggy address belongs to the page:
page:ffffea000182e280 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888060b8a200 pfn:0x60b8a
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000059b548 ffffea00018ff7c8 ffff888010841640
raw: ffff888060b8a200 000000000020001e 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 28607, ts 1329213251572, free_ts 1329213232305
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4168
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5390
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1691 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1831
 new_slab mm/slub.c:1894 [inline]
 new_slab_objects mm/slub.c:2640 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2803
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2843
 slab_alloc_node mm/slub.c:2925 [inline]
 kmem_cache_alloc_node_trace+0x18f/0x410 mm/slub.c:3009
 kmalloc_node include/linux/slab.h:609 [inline]
 kzalloc_node include/linux/slab.h:732 [inline]
 __get_vm_area_node.constprop.0+0xd3/0x380 mm/vmalloc.c:2382
 __vmalloc_node_range+0x12e/0x960 mm/vmalloc.c:2956
 __vmalloc_node mm/vmalloc.c:3015 [inline]
 vmalloc+0x67/0x80 mm/vmalloc.c:3048
 netlink_alloc_large_skb net/netlink/af_netlink.c:1191 [inline]
 netlink_sendmsg+0x5f0/0xdb0 net/netlink/af_netlink.c:1904
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2959
 kernel_sendpage.part.0+0x1a0/0x340 net/socket.c:3677
 kernel_sendpage net/socket.c:3674 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:1002
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3411
 __put_single_page mm/swap.c:98 [inline]
 __put_page+0xe3/0x3f0 mm/swap.c:129
 put_page include/linux/mm.h:1246 [inline]
 generic_pipe_buf_release+0x1d5/0x240 fs/pipe.c:209
 pipe_buf_release include/linux/pipe_fs_i.h:203 [inline]
 splice_from_pipe_feed fs/splice.c:431 [inline]
 __splice_from_pipe+0x56d/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1b3/0x280 fs/splice.c:979
 do_sendfile+0x9f0/0x1120 fs/read_write.c:1260
 __do_sys_sendfile64 fs/read_write.c:1325 [inline]
 __se_sys_sendfile64 fs/read_write.c:1311 [inline]
 __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1311
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888060b8a900: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff888060b8a980: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888060b8aa00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff888060b8aa80: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
 ffff888060b8ab00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
