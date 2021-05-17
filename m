Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33F2383046
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 16:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbhEQOZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 10:25:31 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:35635 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbhEQOXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 10:23:41 -0400
Received: by mail-io1-f71.google.com with SMTP id l2-20020a5e82020000b02903c2fa852f92so3503748iom.2
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 07:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HADA3QRIyWimZD5D287UyZ4QkppjKTCyVZ55wvUkTms=;
        b=Esp+qu6i2wk0n+T1oWRfiwAa0geFiChFaQi8PGwNAUWwID58/LHD5FYYkkdl147aID
         aUBDGoPoxnxl0Voa5JyONknRYNRVfTe7Qqh7G7zBASc6qhqt6p12WVwmKfUy3TjiXMYl
         AiD0nDtRpZXJ2mJppdO+84R/c3w2otBGH/2nuIgmzZRn9WEuYypi+VulZatzmLmESgpD
         YFx3ELE2IAEeBKxXJrOU89Z2piQpa30ps3Ga/Bx/lSyvjx0wAqphcNl0HKJrsS2GbGql
         fSZbSh18I9SOJmt1auiOicH6f7vg2gSy3ABCwXHRMFG557LKMp1g0xfwwMmvGAqKSGyN
         EvIQ==
X-Gm-Message-State: AOAM533IZ6gAiniQzGzYXyoVwGV0qf9EMeThx5fvbzTp6timYUi1PT42
        qn0IQRdsLPij0Wpx3zwHwi77XyfCZEQ53SFvOSjreHhjZ9bj
X-Google-Smtp-Source: ABdhPJzdyhghjlXDEbrWu/7dNHsFc8WtTqkDDT6tqrY1hIS9JxSlw2vZMuvf9Ktkz+f1nu35W/e162wAnjMYOlItjJHlkEkO9PGd
MIME-Version: 1.0
X-Received: by 2002:a92:b746:: with SMTP id c6mr20980008ilm.240.1621261343300;
 Mon, 17 May 2021 07:22:23 -0700 (PDT)
Date:   Mon, 17 May 2021 07:22:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074a0a305c28752b1@google.com>
Subject: [syzbot] KASAN: use-after-free Read in j1939_xtp_rx_dat_one (2)
From:   syzbot <syzbot+45199c1b73b4013525cf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c06a2ba6 Merge tag 'docs-5.13-3' of git://git.lwn.net/linux
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a19709d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e950b1ffed48778
dashboard link: https://syzkaller.appspot.com/bug?extid=45199c1b73b4013525cf
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+45199c1b73b4013525cf@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_dat_one: 0xffff8880739af000: Data of RX-looped back packet (00 ff ff ff ff ff ff) doesn't match TX data (00 00 00 00 00 00 00)!
==================================================================
BUG: KASAN: use-after-free in j1939_xtp_rx_dat_one+0x108d/0x1130 net/can/j1939/transport.c:1825
Read of size 1 at addr ffff888069049a8e by task ksoftirqd/2/25

CPU: 2 PID: 25 Comm: ksoftirqd/2 Not tainted 5.13.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 j1939_xtp_rx_dat_one+0x108d/0x1130 net/can/j1939/transport.c:1825
 j1939_xtp_rx_dat net/can/j1939/transport.c:1875 [inline]
 j1939_tp_recv+0x544/0xb40 net/can/j1939/transport.c:2057
 j1939_can_recv+0x6d7/0x930 net/can/j1939/main.c:101
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
 can_receive+0x336/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5440
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5554
 process_backlog+0x232/0x6c0 net/core/dev.c:6418
 __napi_poll+0xaf/0x440 net/core/dev.c:6966
 napi_poll net/core/dev.c:7033 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7120
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x655/0x9e0 kernel/smpboot.c:165
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 20961:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:461
 kasan_slab_alloc include/linux/kasan.h:236 [inline]
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:2912 [inline]
 kmem_cache_alloc_node+0x269/0x3e0 mm/slub.c:2948
 __alloc_skb+0x20b/0x340 net/core/skbuff.c:413
 alloc_skb include/linux/skbuff.h:1107 [inline]
 alloc_skb_with_frags+0x93/0x5d0 net/core/skbuff.c:5990
 sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2356
 j1939_sk_alloc_skb net/can/j1939/socket.c:858 [inline]
 j1939_sk_send_loop net/can/j1939/socket.c:1040 [inline]
 j1939_sk_sendmsg+0x6bb/0x1380 net/can/j1939/socket.c:1175
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 sock_no_sendpage+0xf3/0x130 net/core/sock.c:2854
 kernel_sendpage.part.0+0x1ab/0x350 net/socket.c:3631
 kernel_sendpage net/socket.c:3628 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:947
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x43e/0x8a0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1b3/0x280 fs/splice.c:979
 do_sendfile+0x9f0/0x1110 fs/read_write.c:1260
 __do_compat_sys_sendfile fs/read_write.c:1346 [inline]
 __se_compat_sys_sendfile fs/read_write.c:1329 [inline]
 __ia32_compat_sys_sendfile+0x1dd/0x220 fs/read_write.c:1329
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x67/0xe0 arch/x86/entry/common.c:143
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:168
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Freed by task 20:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1581 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1606
 slab_free mm/slub.c:3166 [inline]
 kmem_cache_free+0x8a/0x740 mm/slub.c:3182
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:684
 __kfree_skb net/core/skbuff.c:741 [inline]
 kfree_skb net/core/skbuff.c:758 [inline]
 kfree_skb+0x140/0x3f0 net/core/skbuff.c:752
 j1939_session_skb_drop_old net/can/j1939/transport.c:333 [inline]
 j1939_xtp_rx_cts_one net/can/j1939/transport.c:1394 [inline]
 j1939_xtp_rx_cts+0xb59/0xec0 net/can/j1939/transport.c:1433
 j1939_tp_cmd_recv net/can/j1939/transport.c:2001 [inline]
 j1939_tp_recv+0x8be/0xb40 net/can/j1939/transport.c:2067
 j1939_can_recv+0x6d7/0x930 net/can/j1939/main.c:101
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:608
 can_receive+0x336/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5440
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5554
 process_backlog+0x232/0x6c0 net/core/dev.c:6418
 __napi_poll+0xaf/0x440 net/core/dev.c:6966
 napi_poll net/core/dev.c:7033 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7120
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559

The buggy address belongs to the object at ffff888069049a40
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 78 bytes inside of
 232-byte region [ffff888069049a40, ffff888069049b28)
The buggy address belongs to the page:
page:ffffea0001a41200 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888069048c80 pfn:0x69048
head:ffffea0001a41200 order:1 compound_mapcount:0
flags: 0x4fff00000010200(slab|head|node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000010200 ffffea0001ad8c08 ffffea0001b09508 ffff8880127cc500
raw: ffff888069048c80 0000000000190015 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0x52a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 8624, ts 272925890505, free_ts 272857357828
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1644 [inline]
 allocate_slab+0x2c5/0x4c0 mm/slub.c:1784
 new_slab mm/slub.c:1847 [inline]
 new_slab_objects mm/slub.c:2593 [inline]
 ___slab_alloc+0x44c/0x7a0 mm/slub.c:2756
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2796
 slab_alloc_node mm/slub.c:2878 [inline]
 slab_alloc mm/slub.c:2920 [inline]
 kmem_cache_alloc+0x34b/0x3a0 mm/slub.c:2925
 skb_clone+0x170/0x3c0 net/core/skbuff.c:1497
 dev_queue_xmit_nit+0x3a5/0xa90 net/core/dev.c:2413
 xmit_one net/core/dev.c:3649 [inline]
 dev_hard_start_xmit+0xad/0x920 net/core/dev.c:3670
 sch_direct_xmit+0x2e1/0xbd0 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4ba/0x15f0 net/sched/sch_generic.c:384
 qdisc_run include/net/pkt_sched.h:136 [inline]
 qdisc_run include/net/pkt_sched.h:128 [inline]
 __dev_xmit_skb net/core/dev.c:3856 [inline]
 __dev_queue_xmit+0x142e/0x2e30 net/core/dev.c:4213
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip_finish_output2+0xeec/0x21f0 net/ipv4/ip_output.c:230
 __ip_finish_output net/ipv4/ip_output.c:308 [inline]
 __ip_finish_output+0x396/0x640 net/ipv4/ip_output.c:290
 ip_finish_output+0x35/0x200 net/ipv4/ip_output.c:318
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1298 [inline]
 __free_pages_ok+0x476/0xce0 mm/page_alloc.c:1572
 unfreeze_partials+0x16c/0x1b0 mm/slub.c:2374
 put_cpu_partial+0x13d/0x230 mm/slub.c:2410
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:438
 kasan_slab_alloc include/linux/kasan.h:236 [inline]
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:2912 [inline]
 slab_alloc mm/slub.c:2920 [inline]
 __kmalloc+0x1f7/0x330 mm/slub.c:4063
 kmalloc include/linux/slab.h:561 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:313 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:308
 security_file_open+0x52/0x4f0 security/security.c:1633
 do_dentry_open+0x358/0x11b0 fs/open.c:813
 do_open fs/namei.c:3361 [inline]
 path_openat+0x1c0e/0x27e0 fs/namei.c:3494
 do_filp_open+0x190/0x3d0 fs/namei.c:3521
 do_sys_openat2+0x16d/0x420 fs/open.c:1187
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open fs/open.c:1207 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1207

Memory state around the buggy address:
 ffff888069049980: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
 ffff888069049a00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff888069049a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888069049b00: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
 ffff888069049b80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
