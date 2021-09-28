Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04ECD41AEC7
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbhI1MVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:16 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49949 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240657AbhI1MVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 08:21:08 -0400
Received: by mail-io1-f71.google.com with SMTP id l17-20020a05660227d100b005d6609eb90eso21624141ios.16
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 05:19:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Y6eAfVq4QB1GjvBpf0CYIiLEndzX7aWsLmuLqn9rBWI=;
        b=OpD+BrrAfr7B63VTHf+3cdCDMOkYtV131aPf3XLgMzbBHpXN6tHrBJtXS398WBATm7
         xyslG/qkRWgOGaPkMwIKt4awNNdk7pNzLrhdzjC6R8BtePzKwWZWp3ZQaLo6C6+7bVQu
         djqi1qMKxLf01fyuOmScN9RXoCG1+o7oVLbSf9kUz1IIMuA4IBBc3Acp6PImfXzFJlIy
         4WgItoaiyHU+MJLsHwYLXuJQqxl6gkaaIZqW0zaDlUdG+sDDU4EJvpTMLsdmT217/6Kn
         TLItmuQ1n452pBnMhmPpLR2fnQn39xVNgcHEbi70RefneKeiw+bM0N4Ryja0eQoP9S9Z
         IIRA==
X-Gm-Message-State: AOAM533HpgVmXe4g3zKGqACHwyBfNX159Qkac/ANeKxjjDoFthSsAziB
        47X4NoTlYUqodslx+rErI0/Jo8xrhr6nHk5mLKHlrPF3wt6Y
X-Google-Smtp-Source: ABdhPJwjk+ufmfYJ8G67DTTehKzMeo/aNb7/s8YcN4+KNGG2ruY8RwnAzJ69+ADC7fo0wMB/R9mjGngPzk6WJgHFuAFMYnaWV1RA
MIME-Version: 1.0
X-Received: by 2002:a5d:9c56:: with SMTP id 22mr3787440iof.10.1632831568852;
 Tue, 28 Sep 2021 05:19:28 -0700 (PDT)
Date:   Tue, 28 Sep 2021 05:19:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3bb7b05cd0d3919@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nf_tables_fill_table_info
From:   syzbot <syzbot+46f298a3b7ae01600a54@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2fcd14d0f780 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16350cbb300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
dashboard link: https://syzkaller.appspot.com/bug?extid=46f298a3b7ae01600a54
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+46f298a3b7ae01600a54@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nf_tables_fill_table_info+0x94f/0xa10 net/netfilter/nf_tables_api.c:743
Read of size 8 at addr ffff88807ee4b9d0 by task syz-executor.4/14371

CPU: 1 PID: 14371 Comm: syz-executor.4 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 nf_tables_fill_table_info+0x94f/0xa10 net/netfilter/nf_tables_api.c:743
 nf_tables_dump_tables+0x542/0xa50 net/netfilter/nf_tables_api.c:832
 netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2278
 __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2383
 netlink_dump_start include/linux/netlink.h:258 [inline]
 nft_netlink_dump_start_rcu+0x83/0x1c0 net/netfilter/nf_tables_api.c:859
 nf_tables_gettable+0x47d/0x570 net/netfilter/nf_tables_api.c:884
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff0295fa709
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff026b71188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff0296fef60 RCX: 00007ff0295fa709
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000004
RBP: 00007ff029654cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc9ef8191f R14: 00007ff026b71300 R15: 0000000000022000

Allocated by task 14371:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 nf_tables_newtable+0xe3e/0x1b40 net/netfilter/nf_tables_api.c:1112
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 14368:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x81/0x190 mm/slub.c:1725
 slab_free mm/slub.c:3483 [inline]
 kfree+0xe4/0x530 mm/slub.c:4543
 nf_tables_table_destroy+0x13f/0x1b0 net/netfilter/nf_tables_api.c:1315
 __nft_release_table+0xabc/0xe30 net/netfilter/nf_tables_api.c:9603
 nft_rcv_nl_event+0x4af/0x590 net/netfilter/nf_tables_api.c:9645
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 blocking_notifier_call_chain kernel/notifier.c:318 [inline]
 blocking_notifier_call_chain+0x67/0x90 kernel/notifier.c:306
 netlink_release+0xcb8/0x1dd0 net/netlink/af_netlink.c:785
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88807ee4b800
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 464 bytes inside of
 512-byte region [ffff88807ee4b800, ffff88807ee4ba00)
The buggy address belongs to the page:
page:ffffea0001fb9200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7ee48
head:ffffea0001fb9200 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001f97d00 0000000700000007 ffff888010c41c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 13, ts 93630512771, free_ts 91502385180
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4153
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5375
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2197
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab mm/slub.c:1900 [inline]
 new_slab+0x319/0x490 mm/slub.c:1963
 ___slab_alloc+0x921/0xfe0 mm/slub.c:2994
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3081
 slab_alloc_node mm/slub.c:3172 [inline]
 __kmalloc_node_track_caller+0x2d2/0x340 mm/slub.c:4936
 kmalloc_reserve net/core/skbuff.c:352 [inline]
 __alloc_skb+0xda/0x360 net/core/skbuff.c:424
 __napi_alloc_skb+0x70/0x310 net/core/skbuff.c:566
 napi_alloc_skb include/linux/skbuff.h:2934 [inline]
 page_to_skb+0x18c/0xd80 drivers/net/virtio_net.c:436
 receive_mergeable drivers/net/virtio_net.c:1027 [inline]
 receive_buf+0x3238/0x65c0 drivers/net/virtio_net.c:1137
 virtnet_receive drivers/net/virtio_net.c:1429 [inline]
 virtnet_poll+0x5bf/0x1190 drivers/net/virtio_net.c:1538
 __napi_poll+0xaf/0x440 net/core/dev.c:6988
 napi_poll net/core/dev.c:7055 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7142
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3394
 __put_page+0x105/0x400 mm/swap.c:127
 put_page include/linux/mm.h:1247 [inline]
 __skb_frag_unref include/linux/skbuff.h:3107 [inline]
 skb_release_data+0x49d/0x790 net/core/skbuff.c:670
 skb_release_all net/core/skbuff.c:740 [inline]
 __kfree_skb+0x46/0x60 net/core/skbuff.c:754
 sk_eat_skb include/net/sock.h:2578 [inline]
 tcp_recvmsg_locked+0x12e8/0x20d0 net/ipv4/tcp.c:2489
 tcp_recvmsg+0x134/0x550 net/ipv4/tcp.c:2535
 inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:848
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_recvmsg net/socket.c:958 [inline]
 sock_read_iter+0x33c/0x470 net/socket.c:1035
 call_read_iter include/linux/fs.h:2157 [inline]
 new_sync_read+0x5ba/0x6e0 fs/read_write.c:404
 vfs_read+0x35c/0x600 fs/read_write.c:485
 ksys_read+0x1ee/0x250 fs/read_write.c:623
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88807ee4b880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807ee4b900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807ee4b980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff88807ee4ba00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807ee4ba80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
