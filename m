Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE8F46B467
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhLGHu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:50:57 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:52932 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhLGHuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:50:54 -0500
Received: by mail-il1-f199.google.com with SMTP id y3-20020a056e021be300b0029f6c440695so10828156ilv.19
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 23:47:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2LcVz25G+/kPckEY89PUSGoHGspF8DTIpTWd/cw2TgI=;
        b=HLEAwj/sPL9ZJ006Wz4C3wyuCCKQiNQz86L2G/K2Oqln+X2aNvuRpfYw3n3i2qGf78
         eKuwaZemOwSGavLdmmqpLuXbXEmIDSyBLPsoQ/u8zRUcxonVilIe6x8tlqvgcf8iJtck
         TBbRQhyeYHdsZPH82v2wzOyY3SDdEoovasHL8NWwoZHZXbzxLuGlGGjKXc1NI7tLR+ic
         yLEX/sNmmRLsBmFqYPg1YRejwfXtoF4adG6MoHrwT3THTbXgcUHMjZuW/IgigIWI3a6l
         pJpzk0N6ZgVU/Yrt79tS6uUyswTC5rNrR6FaOSDy0akFYSqhOLFNB0QxrY4cK3J5NE7o
         Yj8A==
X-Gm-Message-State: AOAM53060YyglkFGTe6zMXqgftbTWWvc/pUOu5j+PgoIBlSRwj4CyeyM
        J64yRhy/Q9zDCsf13kvc3z8tviG04fsI1qa5hekzFpfyAOMA
X-Google-Smtp-Source: ABdhPJzXnBeGlNC3osWLxkcRZiljS6ULu8SKLdGYJhe/RhYzHmWBiAQyFsMvuUU1o4ao9k4J3dHaMaCpbVghhF8/6xS9GDi+DGlq
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1550:: with SMTP id h16mr38864611iow.125.1638863243970;
 Mon, 06 Dec 2021 23:47:23 -0800 (PST)
Date:   Mon, 06 Dec 2021 23:47:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e105105d28995eb@google.com>
Subject: [syzbot] KASAN: use-after-free Write in l2tp_tunnel_del_work
From:   syzbot <syzbot+3614588f9652203dccaa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mschiffer@universe-factory.net, netdev@vger.kernel.org,
        rdunlap@infradead.org, sishuai@purdue.edu,
        syzkaller-bugs@googlegroups.com, tanxin.ctf@gmail.com,
        unixbhaskar@gmail.com, xiongx18@fudan.edu.cn,
        xiyuyang19@fudan.edu.cn
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    58e1100fdc59 MAINTAINERS: co-maintain random.c
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=155b1475b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b0eee8ab3ea1839
dashboard link: https://syzkaller.appspot.com/bug?extid=3614588f9652203dccaa
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3614588f9652203dccaa@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:70 [inline]
BUG: KASAN: use-after-free in l2tp_session_delete net/l2tp/l2tp_core.c:1549 [inline]
BUG: KASAN: use-after-free in l2tp_tunnel_closeall net/l2tp/l2tp_core.c:1207 [inline]
BUG: KASAN: use-after-free in l2tp_tunnel_del_work+0x25c/0x9c0 net/l2tp/l2tp_core.c:1239
Write of size 8 at addr ffff88807e603808 by task kworker/u4:3/54

CPU: 0 PID: 54 Comm: kworker/u4:3 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: l2tp l2tp_tunnel_del_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:70 [inline]
 l2tp_session_delete net/l2tp/l2tp_core.c:1549 [inline]
 l2tp_tunnel_closeall net/l2tp/l2tp_core.c:1207 [inline]
 l2tp_tunnel_del_work+0x25c/0x9c0 net/l2tp/l2tp_core.c:1239
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 14071:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:595 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 l2tp_session_create+0x36/0xa90 net/l2tp/l2tp_core.c:1585
 pppol2tp_connect+0xffb/0x1a00 net/l2tp/l2tp_ppp.c:772
 __sys_connect_file+0x155/0x1a0 net/socket.c:1896
 __sys_connect+0x161/0x190 net/socket.c:1913
 __do_sys_connect net/socket.c:1923 [inline]
 __se_sys_connect net/socket.c:1920 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1920
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 2973:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kfree+0xf6/0x560 mm/slub.c:4561
 l2tp_session_free net/l2tp/l2tp_core.c:163 [inline]
 l2tp_session_dec_refcount+0x126/0x300 net/l2tp/l2tp_core.c:200
 pppol2tp_session_destruct+0xba/0xf0 net/l2tp/l2tp_ppp.c:419
 __sk_destruct+0x4b/0x900 net/core/sock.c:2012
 sk_destruct+0xbd/0xe0 net/core/sock.c:2057
 __sk_free+0xef/0x3d0 net/core/sock.c:2068
 sk_free+0x78/0xa0 net/core/sock.c:2079
 sock_put include/net/sock.h:1878 [inline]
 pppol2tp_put_sk+0x9b/0xd0 net/l2tp/l2tp_ppp.c:402
 rcu_do_batch kernel/rcu/tree.c:2506 [inline]
 rcu_core+0x7ab/0x1470 kernel/rcu/tree.c:2741
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Last potentially related work creation:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xf5/0x120 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:2985 [inline]
 call_rcu+0xb1/0x740 kernel/rcu/tree.c:3065
 pppol2tp_release+0x311/0x560 net/l2tp/l2tp_ppp.c:458
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xf5/0x120 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3550
 neigh_destroy+0x419/0x620 net/core/neighbour.c:889
 neigh_release include/net/neighbour.h:437 [inline]
 neigh_cleanup_and_release+0x1fd/0x340 net/core/neighbour.c:103
 neigh_del net/core/neighbour.c:225 [inline]
 neigh_remove_one+0x37d/0x460 net/core/neighbour.c:246
 neigh_forced_gc net/core/neighbour.c:276 [inline]
 neigh_alloc net/core/neighbour.c:423 [inline]
 ___neigh_create+0x189b/0x2970 net/core/neighbour.c:618
 ip6_finish_output2+0xf84/0x14e0 net/ipv6/ip6_output.c:123
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 __ip6_finish_output+0x4c1/0x1050 net/ipv6/ip6_output.c:170
 ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0xa99/0x17f0 net/ipv6/ndisc.c:508
 ndisc_send_rs+0x12e/0x6f0 net/ipv6/ndisc.c:702
 addrconf_dad_completed+0x397/0xd60 net/ipv6/addrconf.c:4216
 addrconf_dad_work+0x79f/0x1340 net/ipv6/addrconf.c:4126
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff88807e603800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 8 bytes inside of
 1024-byte region [ffff88807e603800, ffff88807e603c00)
The buggy address belongs to the page:
page:ffffea0001f98000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7e600
head:ffffea0001f98000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001e78e00 dead000000000002 ffff888010c41dc0
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6514, ts 155766229424, free_ts 155712464037
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 __kmalloc_node_track_caller+0x2cb/0x360 mm/slub.c:4956
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 __tcp_send_ack.part.0+0x67/0x760 net/ipv4/tcp_output.c:3930
 __tcp_send_ack net/ipv4/tcp_output.c:3962 [inline]
 tcp_send_ack+0x7d/0xa0 net/ipv4/tcp_output.c:3962
 tcp_cleanup_rbuf+0x464/0x5a0 net/ipv4/tcp.c:1580
 tcp_recvmsg_locked+0x7a2/0x20d0 net/ipv4/tcp.c:2504
 tcp_recvmsg+0x12b/0x550 net/ipv4/tcp.c:2534
 inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:850
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_recvmsg net/socket.c:958 [inline]
 sock_read_iter+0x33c/0x470 net/socket.c:1035
 call_read_iter include/linux/fs.h:2156 [inline]
 new_sync_read+0x5ba/0x6e0 fs/read_write.c:400
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3388
 __put_page+0x27a/0x470 mm/swap.c:128
 folio_put include/linux/mm.h:1237 [inline]
 put_page include/linux/mm.h:1255 [inline]
 __skb_frag_unref include/linux/skbuff.h:3144 [inline]
 skb_release_data+0x49d/0x790 net/core/skbuff.c:672
 skb_release_all net/core/skbuff.c:742 [inline]
 __kfree_skb+0x46/0x60 net/core/skbuff.c:756
 sk_eat_skb include/net/sock.h:2652 [inline]
 tcp_recvmsg_locked+0x12e8/0x20d0 net/ipv4/tcp.c:2488
 tcp_recvmsg+0x12b/0x550 net/ipv4/tcp.c:2534
 inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:850
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_recvmsg net/socket.c:958 [inline]
 sock_read_iter+0x33c/0x470 net/socket.c:1035
 call_read_iter include/linux/fs.h:2156 [inline]
 new_sync_read+0x5ba/0x6e0 fs/read_write.c:400
 vfs_read+0x35c/0x600 fs/read_write.c:481
 ksys_read+0x1ee/0x250 fs/read_write.c:619
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88807e603700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807e603780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807e603800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88807e603880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e603900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
