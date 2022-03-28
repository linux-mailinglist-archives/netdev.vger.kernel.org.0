Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5B4E9EF0
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245204AbiC1S1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbiC1S1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:27:10 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF304ECF1
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:25:26 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id k20-20020a5e9314000000b00649d55ffa67so10891476iom.20
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RBDHVALQi6in3MzmSvksdqiyNF+gV4JupE/OPsrZyog=;
        b=454z7vWbJ+V4PlK+fhJV+0MXuvBFo5BTKQPq+t7kZvFQYmi3CZawCVamn6Tf8sE/p1
         cXGUAqYODtraxWjiR+MPBKCWlY0F/PRP+b/zZ2CrGk2pM4XKfLKGXWVgIW6UYmFnwDGQ
         hb4GyMy0gSuDvQ4NDV3I32oRThCYRftrca8ENbhaSh4TvyNXLzXfrm7t+OsFSOeW7u00
         7MgKozvm5BD5c07w4//aIP5C6vomXXu8KQEAownMfnVPdORR767pKdiqeOHf8sPBufdo
         7J5HRIpMRkdYpHrILBFm1Xwki7QizM/e0FcT5t+3NLyEnMoTbozElMV5c1uUQ20tWOqR
         V3GQ==
X-Gm-Message-State: AOAM532a3fpZ6816qQABU3ON02ErkV1RX/8w/Bak9qNZqJQv7GBK060f
        xdHTNHXixNUiCjIAo6eLmm2nXDjIx7si1NgUbtjSvsoUk+ok
X-Google-Smtp-Source: ABdhPJzab1QKPQlFRWArIzNIbpMntnS0NX/WKJ497m2G15az2oVdICT7J0yPXysaW+n9iW88CC3NNPoZl6AWsrT/5eol+ZNCU12C
MIME-Version: 1.0
X-Received: by 2002:a5e:dc05:0:b0:645:d2cc:3e92 with SMTP id
 b5-20020a5edc05000000b00645d2cc3e92mr7186171iok.72.1648491926259; Mon, 28 Mar
 2022 11:25:26 -0700 (PDT)
Date:   Mon, 28 Mar 2022 11:25:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae0adf05db4b6f66@google.com>
Subject: [syzbot] KASAN: use-after-free Read in j1939_xtp_rx_dat_one (3)
From:   syzbot <syzbot+a9dce1ff45c3bbeceb3a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        pabeni@redhat.com, robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ae085d7f9365 mm: kfence: fix missing objcg housekeeping fo..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17656105700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bae4cd50262530e
dashboard link: https://syzkaller.appspot.com/bug?extid=a9dce1ff45c3bbeceb3a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12529653700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b64ea5700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a9dce1ff45c3bbeceb3a@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_dat_one: 0xffff88801fe31400: last 00
vcan0: j1939_xtp_rx_dat_one: 0xffff88801fe31800: last 00
vcan0: j1939_xtp_rx_dat_one: 0xffff88801fe31800: Data of RX-looped back packet (00 ff ff ff ff ff ff) doesn't match TX data (00 00 00 00 00 00 00)!
==================================================================
BUG: KASAN: use-after-free in j1939_xtp_rx_dat_one+0xe15/0xee0 net/can/j1939/transport.c:1877
Read of size 1 at addr ffff88802304ab8e by task ksoftirqd/1/21

CPU: 1 PID: 21 Comm: ksoftirqd/1 Tainted: G        W         5.17.0-syzkaller-11407-gae085d7f9365 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 j1939_xtp_rx_dat_one+0xe15/0xee0 net/can/j1939/transport.c:1877
 j1939_xtp_rx_dat net/can/j1939/transport.c:1929 [inline]
 j1939_tp_recv+0x6de/0xcb0 net/can/j1939/transport.c:2123
 j1939_can_recv+0x6ff/0x9a0 net/can/j1939/main.c:108
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
 can_receive+0x31d/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5405
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5519
 process_backlog+0x3a0/0x7c0 net/core/dev.c:5847
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6413
 napi_poll net/core/dev.c:6480 [inline]
 net_rx_action+0x8ec/0xc60 net/core/dev.c:6567
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Allocated by task 3606:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:749 [inline]
 slab_alloc_node mm/slub.c:3217 [inline]
 kmem_cache_alloc_node+0x255/0x3f0 mm/slub.c:3267
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1300 [inline]
 alloc_skb_with_frags+0x93/0x730 net/core/skbuff.c:5988
 sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2600
 j1939_sk_alloc_skb net/can/j1939/socket.c:861 [inline]
 j1939_sk_send_loop net/can/j1939/socket.c:1118 [inline]
 j1939_sk_sendmsg+0x6eb/0x13f0 net/can/j1939/socket.c:1253
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 sock_no_sendpage+0xf6/0x140 net/core/sock.c:3106
 kernel_sendpage.part.0+0x1ff/0x7b0 net/socket.c:3492
 kernel_sendpage net/socket.c:3489 [inline]
 sock_sendpage+0xdf/0x140 net/socket.c:1007
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1a7/0x270 fs/splice.c:979
 do_sendfile+0xae0/0x1240 fs/read_write.c:1246
 __do_sys_sendfile64 fs/read_write.c:1311 [inline]
 __se_sys_sendfile64 fs/read_write.c:1297 [inline]
 __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1297
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 15:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3510 [inline]
 kmem_cache_free+0xdd/0x5a0 mm/slub.c:3527
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:700
 kfree_skb_reason+0x85/0x110 include/linux/refcount.h:279
 kfree_skb include/linux/skbuff.h:1250 [inline]
 j1939_session_skb_drop_old net/can/j1939/transport.c:340 [inline]
 j1939_xtp_rx_cts_one net/can/j1939/transport.c:1434 [inline]
 j1939_xtp_rx_cts+0xbdb/0x1170 net/can/j1939/transport.c:1473
 j1939_tp_cmd_recv net/can/j1939/transport.c:2061 [inline]
 j1939_tp_recv+0x83c/0xcb0 net/can/j1939/transport.c:2133
 j1939_can_recv+0x6ff/0x9a0 net/can/j1939/main.c:108
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
 can_receive+0x31d/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5405
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5519
 process_backlog+0x3a0/0x7c0 net/core/dev.c:5847
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6413
 napi_poll net/core/dev.c:6480 [inline]
 net_rx_action+0x8ec/0xc60 net/core/dev.c:6567
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

The buggy address belongs to the object at ffff88802304ab40
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 78 bytes inside of
 232-byte region [ffff88802304ab40, ffff88802304ac28)

The buggy address belongs to the physical page:
page:ffffea00008c1280 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2304a
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 0000000000000000 dead000000000122 ffff888140b8d500
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY), pid 3590, tgid 3590 (kworker/1:3), ts 33637485571, free_ts 33296379898
 prep_new_page mm/page_alloc.c:2438 [inline]
 get_page_from_freelist+0xba2/0x3df0 mm/page_alloc.c:4179
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5405
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2262
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 kmem_cache_alloc_node+0x122/0x3f0 mm/slub.c:3267
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1300 [inline]
 ndisc_alloc_skb+0x134/0x320 net/ipv6/ndisc.c:420
 ndisc_send_rs+0x37f/0x6f0 net/ipv6/ndisc.c:701
 addrconf_dad_completed+0x37a/0xd30 net/ipv6/addrconf.c:4231
 addrconf_dad_work+0x79f/0x1340 net/ipv6/addrconf.c:4141
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1353 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1403
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3420
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:749 [inline]
 slab_alloc_node mm/slub.c:3217 [inline]
 kmem_cache_alloc_node+0x255/0x3f0 mm/slub.c:3267
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1300 [inline]
 alloc_skb_with_frags+0x93/0x730 net/core/skbuff.c:5988
 sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2600
 mld_newpack.isra.0+0x1be/0x750 net/ipv6/mcast.c:1746
 add_grhead+0x283/0x360 net/ipv6/mcast.c:1849
 add_grec+0x106a/0x1530 net/ipv6/mcast.c:1987
 mld_send_initial_cr.part.0+0xf6/0x230 net/ipv6/mcast.c:2234
 mld_send_initial_cr net/ipv6/mcast.c:1232 [inline]
 ipv6_mc_dad_complete+0x1d0/0x690 net/ipv6/mcast.c:2245
 addrconf_dad_completed+0x9e8/0xd30 net/ipv6/addrconf.c:4211
 addrconf_dad_work+0x79f/0x1340 net/ipv6/addrconf.c:4141

Memory state around the buggy address:
 ffff88802304aa80: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
 ffff88802304ab00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff88802304ab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88802304ac00: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
 ffff88802304ac80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
