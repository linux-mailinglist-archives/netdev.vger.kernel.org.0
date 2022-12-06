Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7762D644986
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbiLFQlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiLFQke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:40:34 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0F89599
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:39:37 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id a14-20020a921a0e000000b00302a8ffa8e5so14583343ila.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:39:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GXQcBynn93trl+j7QgKD23tXZzujpObBAvqEWSX6yug=;
        b=1ShF0cuXJNpWxAHbbTNafYygrJliXeRtMZLrt+0We9pST6vfCLPccciVkRAG4v4pP0
         sSuUFpQ7kxoFMf7TKO4Bz7bdtlFfsRqDElXGeHauEk3HoLWlB8iTyNEpzyPZbDaGVYqT
         axsAUyTIUTYN4gQ/n03mZDXY/JgCGkpC1vPVh9CW188GmjwwRL78wI4Q4ERolSbIfHD4
         8eHLOHMf1DOdFJLCBVIQDfhWNaemWGOpLGaSdkop38sGzJFroPr8fJzfAusLMRPjY0Hb
         1C19Ax8ovl7LRqy6lxnTFutvBM0+Ksx6F26k+bgjeYtcBwamxAPPuyBMwQB1yQjgtrhV
         KunA==
X-Gm-Message-State: ANoB5plPDRTyhVFTMRV/8X3VXcj2p3HiP7KnjTQOWPrx4ZLt0RAXeCEw
        80siV1EPYJulRAuTFSRUEScvT6Rejz4LiRXn0I71FxJxNKWC
X-Google-Smtp-Source: AA0mqf6/7BCRLHTzOIqBAJNu4ITIhXSWToBiErEhmSFuB3www6peWOkb+6K/FtB8RwzerLovnXc7ehddOxc1FX4byxECffaz0Lmg
MIME-Version: 1.0
X-Received: by 2002:a92:9411:0:b0:302:56e8:e5ab with SMTP id
 c17-20020a929411000000b0030256e8e5abmr40106742ili.40.1670344777114; Tue, 06
 Dec 2022 08:39:37 -0800 (PST)
Date:   Tue, 06 Dec 2022 08:39:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017ace905ef2b739d@google.com>
Subject: [syzbot] KASAN: use-after-free Read in rxrpc_destroy_all_locals
From:   syzbot <syzbot+1eb4232fca28c0a6d1c2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    01d0e110f236 Merge branch 'net-lan966x-enable-ptp-on-bridg..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16af79d5880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c608c21151db14f2
dashboard link: https://syzkaller.appspot.com/bug?extid=1eb4232fca28c0a6d1c2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/45e7d33efabe/disk-01d0e110.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bb13aac486ae/vmlinux-01d0e110.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3fb366429f3d/bzImage-01d0e110.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1eb4232fca28c0a6d1c2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in rxrpc_destroy_all_locals+0x10a/0x180 net/rxrpc/local_object.c:434
Read of size 4 at addr ffff88807bd82814 by task kworker/u4:3/46

CPU: 0 PID: 46 Comm: kworker/u4:3 Not tainted 6.1.0-rc7-syzkaller-01815-g01d0e110f236 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 rxrpc_destroy_all_locals+0x10a/0x180 net/rxrpc/local_object.c:434
 rxrpc_exit_net+0x174/0x300 net/rxrpc/net_ns.c:128
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:606
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 13847:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:553 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 rxrpc_alloc_local net/rxrpc/local_object.c:93 [inline]
 rxrpc_lookup_local+0x4d9/0xfb0 net/rxrpc/local_object.c:249
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 afs_open_socket+0x1b4/0x360 fs/afs/rxrpc.c:64
 afs_net_init+0xa79/0xed0 fs/afs/main.c:126
 ops_init+0xb9/0x680 net/core/net_namespace.c:135
 setup_net+0x793/0xe60 net/core/net_namespace.c:333
 copy_net_ns+0x31b/0x6b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc5/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x449/0x920 kernel/fork.c:3188
 __do_sys_unshare kernel/fork.c:3259 [inline]
 __se_sys_unshare kernel/fork.c:3257 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:3257
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 15:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1724 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1750
 slab_free mm/slub.c:3661 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3674
 rcu_do_batch kernel/rcu/tree.c:2250 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2510
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 call_rcu+0x9d/0x820 kernel/rcu/tree.c:2798
 rxrpc_put_local.part.0+0x128/0x170 net/rxrpc/local_object.c:332
 rxrpc_put_local+0x25/0x30 net/rxrpc/local_object.c:324
 rxrpc_release_sock net/rxrpc/af_rxrpc.c:888 [inline]
 rxrpc_release+0x237/0x550 net/rxrpc/af_rxrpc.c:914
 __sock_release net/socket.c:650 [inline]
 sock_release+0x8b/0x1b0 net/socket.c:678
 afs_close_socket+0x1ce/0x330 fs/afs/rxrpc.c:125
 afs_net_exit+0x179/0x320 fs/afs/main.c:158
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:606
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 kvfree_call_rcu+0x78/0x8f0 kernel/rcu/tree.c:3343
 neigh_destroy+0x435/0x640 net/core/neighbour.c:931
 neigh_release include/net/neighbour.h:449 [inline]
 neigh_cleanup_and_release+0x271/0x3d0 net/core/neighbour.c:103
 neigh_periodic_work+0x616/0x9f0 net/core/neighbour.c:1013
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

The buggy address belongs to the object at ffff88807bd82800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 20 bytes inside of
 1024-byte region [ffff88807bd82800, ffff88807bd82c00)

The buggy address belongs to the physical page:
page:ffffea0001ef6000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7bd80
head:ffffea0001ef6000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888012041dc0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3623, tgid 3623 (syz-fuzzer), ts 86395494821, free_ts 86393423061
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4291
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5558
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1794 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1939
 new_slab mm/slub.c:1992 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3180
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
 slab_alloc_node mm/slub.c:3364 [inline]
 __kmem_cache_alloc_node+0x199/0x3e0 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:975
 kmalloc_reserve net/core/skbuff.c:438 [inline]
 __alloc_skb+0xe9/0x310 net/core/skbuff.c:511
 alloc_skb include/linux/skbuff.h:1269 [inline]
 __tcp_send_ack.part.0+0x67/0x760 net/ipv4/tcp_output.c:3957
 __tcp_send_ack net/ipv4/tcp_output.c:3989 [inline]
 tcp_send_ack+0x81/0xa0 net/ipv4/tcp_output.c:3989
 __tcp_cleanup_rbuf+0x356/0x470 net/ipv4/tcp.c:1617
 tcp_recvmsg_locked+0x72c/0x22b0 net/ipv4/tcp.c:2649
 tcp_recvmsg+0x117/0x620 net/ipv4/tcp.c:2679
 inet_recvmsg+0x114/0x5e0 net/ipv4/af_inet.c:861
 sock_recvmsg_nosec net/socket.c:995 [inline]
 sock_recvmsg net/socket.c:1013 [inline]
 sock_recvmsg net/socket.c:1009 [inline]
 sock_read_iter+0x348/0x480 net/socket.c:1086
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1459 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1509
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x4d0 mm/page_alloc.c:3483
 skb_free_frag include/linux/skbuff.h:3192 [inline]
 skb_free_head+0x96/0x110 net/core/skbuff.c:766
 skb_release_data+0x5f4/0x870 net/core/skbuff.c:797
 skb_release_all net/core/skbuff.c:862 [inline]
 __kfree_skb net/core/skbuff.c:876 [inline]
 skb_attempt_defer_free+0x309/0x3e0 net/core/skbuff.c:6651
 tcp_eat_recv_skb net/ipv4/tcp.c:1638 [inline]
 tcp_recvmsg_locked+0x124e/0x22b0 net/ipv4/tcp.c:2633
 tcp_recvmsg+0x117/0x620 net/ipv4/tcp.c:2679
 inet_recvmsg+0x114/0x5e0 net/ipv4/af_inet.c:861
 sock_recvmsg_nosec net/socket.c:995 [inline]
 sock_recvmsg net/socket.c:1013 [inline]
 sock_recvmsg net/socket.c:1009 [inline]
 sock_read_iter+0x348/0x480 net/socket.c:1086
 call_read_iter include/linux/fs.h:2193 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x7fa/0x930 fs/read_write.c:470
 ksys_read+0x1ec/0x250 fs/read_write.c:613
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88807bd82700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807bd82780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807bd82800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff88807bd82880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807bd82900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
