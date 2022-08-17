Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E8E5968AD
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbiHQFgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiHQFga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:36:30 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E03B61D6D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 22:36:28 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id z9-20020a056e02088900b002e35dba878cso8464758ils.10
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 22:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=AQiV7l2fMg2LPAi+6vJ1uxufyFpYypLNRSEB17s09p0=;
        b=xX/a2BUQm+w9RPES/VHPpSABlyFR/gwa6p3ZPqC5YQC/2mIjjE7F804mmn3jiUThSz
         cZ+BzkwL+hzP7DQgu9U6fj9D2N2D6JRKBBKpqu4FoSaoFukMAEVHWwr5bepzc/mtXskT
         kpVXyqFqi1RXGXhiEsTTluwjSq4UXJj0W9sN4R98D95ZN8lar/UfS5X5nsojX52XMozj
         lSpQobVMTNmoC2Xowxb9qp+PHdOPkhUgi/CVCqUNuNS0s1PpGA9tXA2tjzIanJze04KY
         EvQa+sl045Zrh8d+PaeYOir3iZWsKcMhPSzxy98m/uAye/F9e5FaT9PlGjqK4oraYZKU
         Pemg==
X-Gm-Message-State: ACgBeo1yzAf8k+lsl1kYO1Zr8NiVKaF/v0JdA9w7HCoZKtPjF76DNOP8
        IRMekR0bqpex32BR94sWLxkYyZU0yvwT6H46hiYnxXBoL8QI
X-Google-Smtp-Source: AA6agR6p+RRhuiteKXAo3yV9OmDelO5OECbCZrUPC44q/+qS58sS++Pj7IZLMLebx7aM7CELpyZQpVgndUzOla9v/NcD1mQTvGNS
MIME-Version: 1.0
X-Received: by 2002:a05:6602:180c:b0:67c:296:2561 with SMTP id
 t12-20020a056602180c00b0067c02962561mr10227890ioh.173.1660714588322; Tue, 16
 Aug 2022 22:36:28 -0700 (PDT)
Date:   Tue, 16 Aug 2022 22:36:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c3efc05e6693f06@google.com>
Subject: [syzbot] KASAN: use-after-free Read in p9_req_put
From:   syzbot <syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c3adefb5baf3 Merge tag 'for-6.0/dm-fixes' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17552e35080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c15de4ee7650fb42
dashboard link: https://syzkaller.appspot.com/bug?extid=de52531662ebb8823b26
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4923
Read of size 8 at addr ffff888022724c18 by task kworker/u16:6/9419

CPU: 0 PID: 9419 Comm: kworker/u16:6 Not tainted 5.19.0-syzkaller-13940-gc3adefb5baf3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: netns cleanup_net
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x6e9 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4923
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 p9_tag_remove net/9p/client.c:367 [inline]
 p9_req_put net/9p/client.c:375 [inline]
 p9_req_put+0xc6/0x250 net/9p/client.c:372
 req_done+0x1de/0x2e0 net/9p/trans_virtio.c:148
 vring_interrupt drivers/virtio/virtio_ring.c:2176 [inline]
 vring_interrupt+0x29d/0x3d0 drivers/virtio/virtio_ring.c:2151
 __handle_irq_event_percpu+0x227/0x870 kernel/irq/handle.c:158
 handle_irq_event_percpu kernel/irq/handle.c:193 [inline]
 handle_irq_event+0xa7/0x1e0 kernel/irq/handle.c:210
 handle_edge_irq+0x25f/0xd00 kernel/irq/chip.c:819
 generic_handle_irq_desc include/linux/irqdesc.h:158 [inline]
 handle_irq arch/x86/kernel/irq.c:231 [inline]
 __common_interrupt+0x9d/0x210 arch/x86/kernel/irq.c:250
 common_interrupt+0xa4/0xc0 arch/x86/kernel/irq.c:240
 </IRQ>
 <TASK>
 asm_common_interrupt+0x22/0x40 arch/x86/include/asm/idtentry.h:640
RIP: 0010:lock_acquire+0x1ef/0x570 kernel/locking/lockdep.c:5634
Code: d2 a3 7e 83 f8 01 0f 85 e8 02 00 00 9c 58 f6 c4 02 0f 85 fb 02 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
RSP: 0018:ffffc9000373fa50 EFLAGS: 00000206
RAX: dffffc0000000000 RBX: 1ffff920006e7f4c RCX: c54d55f18b925c0c
RDX: 1ffff1100466a15e RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff908d8947
R10: fffffbfff211b128 R11: 1ffffffff17f21a9 R12: 0000000000000002
R13: 0000000000000000 R14: ffffffff8bf86740 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:280 [inline]
 rcu_read_lock include/linux/rcupdate.h:706 [inline]
 inet_twsk_purge+0x117/0x850 net/ipv4/inet_timewait_sock.c:270
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:595
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 18072:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc mm/kasan/common.c:516 [inline]
 ____kasan_kmalloc mm/kasan/common.c:475 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:525
 kasan_kmalloc include/linux/kasan.h:234 [inline]
 kmem_cache_alloc_trace+0x25a/0x460 mm/slab.c:3559
 kmalloc include/linux/slab.h:600 [inline]
 p9_client_create+0xaf/0x1070 net/9p/client.c:934
 v9fs_session_init+0x1e2/0x1810 fs/9p/v9fs.c:408
 v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1530
 do_new_mount fs/namespace.c:3040 [inline]
 path_mount+0x1326/0x1e20 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 18072:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:367 [inline]
 ____kasan_slab_free+0x13d/0x1a0 mm/kasan/common.c:329
 kasan_slab_free include/linux/kasan.h:200 [inline]
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x173/0x390 mm/slab.c:3786
 p9_client_create+0x7a6/0x1070 net/9p/client.c:1005
 v9fs_session_init+0x1e2/0x1810 fs/9p/v9fs.c:408
 v9fs_mount+0xba/0xc90 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1530
 do_new_mount fs/namespace.c:3040 [inline]
 path_mount+0x1326/0x1e20 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 insert_work+0x48/0x350 kernel/workqueue.c:1358
 __queue_work+0x625/0x1210 kernel/workqueue.c:1517
 call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1514 [inline]
 __run_timers.part.0+0x4a3/0xa80 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 call_rcu+0x99/0x790 kernel/rcu/tree.c:2793
 inetdev_destroy net/ipv4/devinet.c:331 [inline]
 inetdev_event+0xd4a/0x1610 net/ipv4/devinet.c:1602
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 unregister_netdevice_many+0xa62/0x1980 net/core/dev.c:10862
 ip_tunnel_delete_nets+0x39f/0x5b0 net/ipv4/ip_tunnel.c:1125
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:595
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

The buggy address belongs to the object at ffff888022724c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 24 bytes inside of
 512-byte region [ffff888022724c00, ffff888022724e00)

The buggy address belongs to the physical page:
page:ffffea000089c900 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888022724000 pfn:0x22724
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000794788 ffffea0000763948 ffff888011840600
raw: ffff888022724000 ffff888022724000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2c2220(__GFP_HIGH|__GFP_ATOMIC|__GFP_NOWARN|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_THISNODE), pid 3769, tgid 3769 (syz-executor.0), ts 230243023347, free_ts 223689823370
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages_slowpath.constprop.0+0x2d7/0x2240 mm/page_alloc.c:5058
 __alloc_pages+0x43d/0x510 mm/page_alloc.c:5528
 __alloc_pages_node include/linux/gfp.h:243 [inline]
 kmem_getpages mm/slab.c:1363 [inline]
 cache_grow_begin+0x75/0x360 mm/slab.c:2569
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2942
 ____cache_alloc mm/slab.c:3018 [inline]
 ____cache_alloc mm/slab.c:3001 [inline]
 slab_alloc_node mm/slab.c:3220 [inline]
 kmem_cache_alloc_node_trace+0x50a/0x570 mm/slab.c:3601
 __do_kmalloc_node mm/slab.c:3623 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3638
 kmalloc_reserve net/core/skbuff.c:358 [inline]
 __alloc_skb+0xd9/0x2f0 net/core/skbuff.c:430
 alloc_skb include/linux/skbuff.h:1257 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 inet6_ifa_notify+0x118/0x230 net/ipv6/addrconf.c:5492
 __ipv6_ifa_notify net/ipv6/addrconf.c:6140 [inline]
 ipv6_ifa_notify net/ipv6/addrconf.c:6192 [inline]
 inet6_addr_add+0x687/0xae0 net/ipv6/addrconf.c:2981
 inet6_rtm_newaddr+0xfa4/0x1a60 net/ipv6/addrconf.c:4923
 rtnetlink_rcv_msg+0x43a/0xc90 net/core/rtnetlink.c:6089
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
 slab_destroy mm/slab.c:1615 [inline]
 slabs_destroy+0x89/0xc0 mm/slab.c:1635
 cache_flusharray mm/slab.c:3389 [inline]
 ___cache_free+0x2a8/0x3d0 mm/slab.c:3452
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x4f/0x1b0 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x97/0xb0 mm/kasan/common.c:447
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:727 [inline]
 slab_alloc_node mm/slab.c:3232 [inline]
 kmem_cache_alloc_node+0x2f1/0x560 mm/slab.c:3583
 __alloc_skb+0x210/0x2f0 net/core/skbuff.c:418
 alloc_skb include/linux/skbuff.h:1257 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 netlink_ack+0x1f0/0xa80 net/netlink/af_netlink.c:2436
 netlink_rcv_skb+0x33d/0x420 net/netlink/af_netlink.c:2507
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 __sys_sendto+0x236/0x340 net/socket.c:2117
 __do_sys_sendto net/socket.c:2129 [inline]
 __se_sys_sendto net/socket.c:2125 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2125

Memory state around the buggy address:
 ffff888022724b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888022724b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888022724c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff888022724c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888022724d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	d2 a3 7e 83 f8 01    	shlb   %cl,0x1f8837e(%rbx)
   6:	0f 85 e8 02 00 00    	jne    0x2f4
   c:	9c                   	pushfq
   d:	58                   	pop    %rax
   e:	f6 c4 02             	test   $0x2,%ah
  11:	0f 85 fb 02 00 00    	jne    0x312
  17:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  1d:	74 01                	je     0x20
  1f:	fb                   	sti
  20:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  27:	fc ff df
* 2a:	48 01 c3             	add    %rax,%rbx <-- trapping instruction
  2d:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  34:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  3b:	00
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	84                   	.byte 0x84
  3f:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
