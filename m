Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30FE671581
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjARHyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjARHx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:53:26 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4FD5AB75
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 23:25:46 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id i7-20020a056e021b0700b003033a763270so24762314ilv.19
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 23:25:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A24+skgjFBNzJpL+YOVG9xLa35b4RiPh5Bv7QLdoXSc=;
        b=5SYP5c4uRt4Y/U1N9Elh4Mk/MpdUUBCaeAWS+PcpCa3WzcjZaaSMxlaCgpzHNbqkHD
         ThZ8ZeishHZQbEknkRzDCvB10na6zL9RaKF03ahPqAK9sgIZZokKZBGDrczNOzhCHZ7r
         1SBOk8WjAqcnefajqtQFyMr9fN/WY8D9ui1RPoRCoPEAZH1mX902ANhAZ1JMfaL4EZsH
         C9Xn/EI0iWRtW0go9RHBaEbPXNGTxPc6DKrgiNUB+UHLGnrml0X7Va+xwU8O2d4kcaKy
         aJHZHuM2RZjQ23YCn1N4e5OLYTeobm77JVp8NFCjN+rbH0AzVZHU7A2UNgNUQu3FIc2z
         81HQ==
X-Gm-Message-State: AFqh2kqw+sfN6vtUNCfbe0ECByM47PEbTrjy0iwVhal8WAr6R9PJo/Gg
        EWXZ3L+gsuzeS01uil3x+Q37cZEOAP1TdJpdyRbVYYvUoxDJ
X-Google-Smtp-Source: AMrXdXvBVu8+t0s+XZx5v6EGL9g07a7WRXyupRhtiGbuviJPKsWFGevgNoqmJKNmjRKNmHt05dpFIqyfuIhYwP06HaV0c3ZZX1Fe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12a1:b0:30e:da52:9a89 with SMTP id
 f1-20020a056e0212a100b0030eda529a89mr495873ilr.109.1674026745426; Tue, 17 Jan
 2023 23:25:45 -0800 (PST)
Date:   Tue, 17 Jan 2023 23:25:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000818d1b05f284b967@google.com>
Subject: [syzbot] KASAN: use-after-free Read in do_accept
From:   syzbot <syzbot+5fafd5cfe1fc91f6b352@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org,
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

HEAD commit:    d9fc1511728c Merge tag 'net-6.2-rc4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1271a6ea480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be6d86665513142a
dashboard link: https://syzkaller.appspot.com/bug?extid=5fafd5cfe1fc91f6b352
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9f5d8282c5e2/disk-d9fc1511.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/605323a11f49/vmlinux-d9fc1511.xz
kernel image: https://storage.googleapis.com/syzbot-assets/22d0ab6d90ac/bzImage-d9fc1511.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fafd5cfe1fc91f6b352@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in do_accept+0x483/0x510 net/socket.c:1848
Read of size 8 at addr ffff88807978d398 by task syz-executor.3/5315

CPU: 0 PID: 5315 Comm: syz-executor.3 Not tainted 6.2.0-rc3-syzkaller-00165-gd9fc1511728c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x461 mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 do_accept+0x483/0x510 net/socket.c:1848
 __sys_accept4_file net/socket.c:1897 [inline]
 __sys_accept4+0x9a/0x120 net/socket.c:1927
 __do_sys_accept net/socket.c:1944 [inline]
 __se_sys_accept net/socket.c:1941 [inline]
 __x64_sys_accept+0x75/0xb0 net/socket.c:1941
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa436a8c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa437784168 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: ffffffffffffffda RBX: 00007fa436bac050 RCX: 00007fa436a8c0c9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007fa436ae7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffebc6700df R14: 00007fa437784300 R15: 0000000000022000
 </TASK>

Allocated by task 5294:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa3/0xb0 mm/kasan/common.c:380
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slab_common.c:968 [inline]
 __kmalloc+0x5a/0xd0 mm/slab_common.c:981
 kmalloc include/linux/slab.h:584 [inline]
 sk_prot_alloc+0x140/0x290 net/core/sock.c:2038
 sk_alloc+0x3a/0x7a0 net/core/sock.c:2091
 nr_create+0xb6/0x5f0 net/netrom/af_netrom.c:433
 __sock_create+0x359/0x790 net/socket.c:1515
 sock_create net/socket.c:1566 [inline]
 __sys_socket_create net/socket.c:1603 [inline]
 __sys_socket_create net/socket.c:1588 [inline]
 __sys_socket+0x133/0x250 net/socket.c:1636
 __do_sys_socket net/socket.c:1649 [inline]
 __se_sys_socket net/socket.c:1647 [inline]
 __x64_sys_socket+0x73/0xb0 net/socket.c:1647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 14:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2b/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x13b/0x1a0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 __cache_free mm/slab.c:3394 [inline]
 __do_kmem_cache_free mm/slab.c:3580 [inline]
 __kmem_cache_free+0xcd/0x3b0 mm/slab.c:3587
 sk_prot_free net/core/sock.c:2074 [inline]
 __sk_destruct+0x5df/0x750 net/core/sock.c:2166
 sk_destruct net/core/sock.c:2181 [inline]
 __sk_free+0x175/0x460 net/core/sock.c:2192
 sk_free+0x7c/0xa0 net/core/sock.c:2203
 sock_put include/net/sock.h:1991 [inline]
 nr_heartbeat_expiry+0x1d7/0x460 net/netrom/nr_timer.c:148
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1700
 expire_timers+0x2c6/0x5c0 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

The buggy address belongs to the object at ffff88807978d000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 920 bytes inside of
 2048-byte region [ffff88807978d000, ffff88807978d800)

The buggy address belongs to the physical page:
page:ffffea0001e5e340 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7978d
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffff888012440800 ffffea0001ee3a90 ffffea0001f6f310
raw: 0000000000000000 ffff88807978d000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2c20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_THISNODE), pid 4383, tgid 4383 (kworker/1:2), ts 156829918867, free_ts 156479265901
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 __alloc_pages_node include/linux/gfp.h:237 [inline]
 kmem_getpages mm/slab.c:1363 [inline]
 cache_grow_begin+0x94/0x390 mm/slab.c:2574
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2947
 ____cache_alloc mm/slab.c:3023 [inline]
 ____cache_alloc mm/slab.c:3006 [inline]
 __do_cache_alloc mm/slab.c:3206 [inline]
 slab_alloc_node mm/slab.c:3254 [inline]
 __kmem_cache_alloc_node+0x44f/0x510 mm/slab.c:3544
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:988
 kmalloc_reserve net/core/skbuff.c:492 [inline]
 __alloc_skb+0xe9/0x310 net/core/skbuff.c:565
 alloc_skb include/linux/skbuff.h:1270 [inline]
 alloc_skb_with_frags+0x97/0x6c0 net/core/skbuff.c:6195
 sock_alloc_send_pskb+0x7a7/0x930 net/core/sock.c:2741
 sock_alloc_send_skb include/net/sock.h:1888 [inline]
 mld_newpack.isra.0+0x1b9/0x770 net/ipv6/mcast.c:1748
 add_grhead+0x295/0x340 net/ipv6/mcast.c:1851
 add_grec+0x1082/0x1560 net/ipv6/mcast.c:1989
 mld_send_cr net/ipv6/mcast.c:2115 [inline]
 mld_ifc_work+0x456/0xdc0 net/ipv6/mcast.c:2653
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
 slab_destroy mm/slab.c:1619 [inline]
 slabs_destroy+0x85/0xc0 mm/slab.c:1639
 cache_flusharray mm/slab.c:3365 [inline]
 ___cache_free+0x2ac/0x3d0 mm/slab.c:3428
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x4f/0x1a0 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slab.c:3261 [inline]
 __kmem_cache_alloc_node+0x26b/0x510 mm/slab.c:3544
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 mca_alloc net/ipv6/mcast.c:880 [inline]
 __ipv6_dev_mc_inc+0x3de/0xec0 net/ipv6/mcast.c:936
 addrconf_join_solict net/ipv6/addrconf.c:2180 [inline]
 addrconf_join_solict net/ipv6/addrconf.c:2172 [inline]
 addrconf_dad_begin net/ipv6/addrconf.c:3991 [inline]
 addrconf_dad_work+0xc5a/0x12d0 net/ipv6/addrconf.c:4116
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Memory state around the buggy address:
 ffff88807978d280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807978d300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807978d380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88807978d400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807978d480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
