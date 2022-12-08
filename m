Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8170264670D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLHChv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLHChj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:37:39 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DABCBF6F
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:37:38 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id r25-20020a6bfc19000000b006e002cb217fso26702ioh.2
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 18:37:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWSFVNpU+4+YJ0sYg3o6Zkh+e8YHn+7iDUXmzZIzbIo=;
        b=067nqLxIbsX8Kr7VWAV3PRvTss24OJ/7WCFYNoOHYWr7/wcvgnX81JIq97IRg1j+aO
         sRNhcKckSMZVwcE4t54N99jeycnU8amXXVxR6sGeYLQ+ApS/dYRO91HU9u9g090YLfsE
         WH1eAMpUOILz9d+WqKD3qUoDYgsHA7n9wyAlTDyffEyrm5Pe/Xh8NxQeRZxCHTU7bFP1
         3A9NojS8w69E7tnVNrZwdbnKOH+5QimiGam8GRDRKR0znZt39lym+nelXn4/L5pYSAzX
         1yRkRvTqHOgItaUYehQpfZdEEr69LuqrHJNwx2MogBDZyQftQ1b5LnKQgz9ZtRHfjIzI
         S40w==
X-Gm-Message-State: ANoB5pktqU8zTPMpAHVqOixJWGyim7zvAETv0v+TxDDlNDXX5jPdpBJc
        GwFbSX9oFThMDOt+kelNYZGKvt7WD3rfQRo5ugWyH1bC+sy2
X-Google-Smtp-Source: AA0mqf6RlVUVZ2Hp1i3on+oLJewUJO8o90QMuusRYVvOcvTca5offrVRD3HQA37l6pbs1IBdMHfHWRERuTIxW+pd9uqXnK9LIUCA
MIME-Version: 1.0
X-Received: by 2002:a92:c98d:0:b0:303:27a5:b9d7 with SMTP id
 y13-20020a92c98d000000b0030327a5b9d7mr17548782iln.12.1670467057728; Wed, 07
 Dec 2022 18:37:37 -0800 (PST)
Date:   Wed, 07 Dec 2022 18:37:37 -0800
In-Reply-To: <00000000000017ace905ef2b739d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000095c32a05ef47eb1f@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_destroy_all_locals
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    591cd61541b9 Add linux-next specific files for 20221207
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=155a05f5880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b2d3e63e054c24f
dashboard link: https://syzkaller.appspot.com/bug?extid=1eb4232fca28c0a6d1c2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16c2defb880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bc862c01ec56/disk-591cd615.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8f9b93f8ed2f/vmlinux-591cd615.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9d5cb636d548/bzImage-591cd615.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1eb4232fca28c0a6d1c2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in rxrpc_destroy_all_locals+0x10a/0x180 net/rxrpc/local_object.c:434
Read of size 4 at addr ffff888026e83014 by task kworker/u4:9/5238

CPU: 0 PID: 5238 Comm: kworker/u4:9 Not tainted 6.1.0-rc8-next-20221207-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
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
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 5495:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 rxrpc_alloc_local net/rxrpc/local_object.c:93 [inline]
 rxrpc_lookup_local+0x4d9/0xfb0 net/rxrpc/local_object.c:249
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 afs_open_socket+0x1b4/0x360 fs/afs/rxrpc.c:64
 afs_net_init+0xa79/0xed0 fs/afs/main.c:126
 ops_init+0xb9/0x680 net/core/net_namespace.c:135
 setup_net+0x793/0xe60 net/core/net_namespace.c:333
 copy_net_ns+0x31b/0x6b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x3b3/0x4a0 kernel/nsproxy.c:179
 copy_process+0x30d3/0x75c0 kernel/fork.c:2269
 kernel_clone+0xeb/0xa40 kernel/fork.c:2681
 __do_sys_clone3+0x1d1/0x370 kernel/fork.c:2980
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 5507:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3800
 rcu_do_batch kernel/rcu/tree.c:2244 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2504
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 __call_rcu_common.constprop.0+0x99/0x820 kernel/rcu/tree.c:2753
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
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff888026e83000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 20 bytes inside of
 1024-byte region [ffff888026e83000, ffff888026e83400)

The buggy address belongs to the physical page:
page:ffffea00009ba000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x26e80
head:ffffea00009ba000 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441dc0 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x152a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_HARDWALL), pid 5118, tgid 5118 (kworker/1:0), ts 447318827019, free_ts 439289003379
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc+0x4a/0xd0 mm/slab_common.c:981
 kmalloc include/linux/slab.h:584 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 neigh_alloc net/core/neighbour.c:476 [inline]
 ___neigh_create+0x1578/0x2a20 net/core/neighbour.c:661
 ip6_finish_output2+0xfc4/0x1530 net/ipv6/ip6_output.c:125
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:444 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ndisc_send_skb+0xa63/0x1740 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x132/0x6f0 net/ipv6/ndisc.c:718
 addrconf_dad_completed+0x37a/0xda0 net/ipv6/addrconf.c:4248
 addrconf_dad_work+0x75d/0x12d0 net/ipv6/addrconf.c:4157
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 kmem_cache_alloc_node+0x1f1/0x460 mm/slub.c:3497
 __alloc_skb+0x216/0x310 net/core/skbuff.c:498
 alloc_skb include/linux/skbuff.h:1269 [inline]
 nlmsg_new include/net/netlink.h:1002 [inline]
 netlink_ack+0x184/0x1370 net/netlink/af_netlink.c:2501
 netlink_rcv_skb+0x34f/0x440 net/netlink/af_netlink.c:2570
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 __sys_sendto+0x23a/0x340 net/socket.c:2117
 __do_sys_sendto net/socket.c:2129 [inline]
 __se_sys_sendto net/socket.c:2125 [inline]
 __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2125
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80

Memory state around the buggy address:
 ffff888026e82f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888026e82f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888026e83000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff888026e83080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888026e83100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

