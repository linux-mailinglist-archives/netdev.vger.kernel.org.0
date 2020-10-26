Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B9D298F9A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 15:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781800AbgJZOlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 10:41:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41051 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1781795AbgJZOlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 10:41:17 -0400
Received: by mail-io1-f72.google.com with SMTP id j21so6000521iog.8
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 07:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2HM/wCeXg7cLFuWJ8AHGUKtpGpttFNH8NsHAu4nzABU=;
        b=EZxldrL9p4lV/XEr3eBL6aYs7eMWtlBUApVEHdGYXJ33W/6zIeTUu0Omi58H24om+H
         qI0eDwkAGVcppnhpuVltAudWtFBuMa8yssidnlwpOURpMws4VJT5pOYBlWSN8qbmB3Zw
         WAXvSQn9zPFke3r50jPyGzM/YKtmmGX5jGGwsoEewDpEOx4yXg7GFdEEH/arDphqzVJ1
         BGiiI/Wvu6BeHK734J4ZFfeiT0Boai2KPoXYM5EEplFgYJoRsV7bQGQlKKHkC5CyUsUT
         8LD/DnOHYVCRk2RCeP1otXoavt9/RAmN+HMCxKIwPmzZBbWDKtjQYBa1w3xhy/sy1a9P
         JqLw==
X-Gm-Message-State: AOAM5312iQBV/b2RuIkEJcPPtoC5BVSl8GT9IxCDwxueFxyvlROORsQw
        J/v7YCt0ouSMPqoFYpVQBhdFvlnB+680QwCU22Ug58i9p3tV
X-Google-Smtp-Source: ABdhPJwNlQL+qJ6qgdwblfAgQPlcIcbRuu03KJz+bAqJRGV+u2B9AgR1dyf8aIlbX2nDWxC/Jb8+f0zjCMsj1NkcWY4IIq/NuEpa
MIME-Version: 1.0
X-Received: by 2002:a6b:5a17:: with SMTP id o23mr8648240iob.101.1603723276443;
 Mon, 26 Oct 2020 07:41:16 -0700 (PDT)
Date:   Mon, 26 Oct 2020 07:41:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035e65c05b293ec0e@google.com>
Subject: KASAN: use-after-free Read in j1939_xtp_rx_dat_one
From:   syzbot <syzbot+220c1a29987a9a490903@syzkaller.appspotmail.com>
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

HEAD commit:    0adc313c Merge tag 'gfs2-for-5.10' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134ebaef900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df5c8291513455a2
dashboard link: https://syzkaller.appspot.com/bug?extid=220c1a29987a9a490903
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+220c1a29987a9a490903@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_dat_one: 0x000000009262b4a1: Data of RX-looped back packet (00 ff ff ff ff ff ff) doesn't match TX data (00 00 00 00 00 00 00)!
==================================================================
BUG: KASAN: use-after-free in j1939_xtp_rx_dat_one+0x108d/0x1130 net/can/j1939/transport.c:1825
Read of size 1 at addr ffff8880219f308e by task ksoftirqd/0/10

CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.9.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 j1939_xtp_rx_dat_one+0x108d/0x1130 net/can/j1939/transport.c:1825
 j1939_xtp_rx_dat net/can/j1939/transport.c:1875 [inline]
 j1939_tp_recv+0x544/0xb40 net/can/j1939/transport.c:2057
 j1939_can_recv+0x5bc/0x7d0 net/can/j1939/main.c:101
 deliver net/can/af_can.c:571 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:605
 can_receive+0x2e3/0x520 net/can/af_can.c:662
 can_rcv+0x12a/0x1a0 net/can/af_can.c:688
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5311
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5425
 process_backlog+0x232/0x6c0 net/core/dev.c:6315
 napi_poll net/core/dev.c:6759 [inline]
 net_rx_action+0x4dc/0x1100 net/core/dev.c:6829
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 run_ksoftirqd kernel/softirq.c:653 [inline]
 run_ksoftirqd+0x2d/0x50 kernel/softirq.c:645
 smpboot_thread_fn+0x655/0x9e0 kernel/smpboot.c:165
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 15076:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:526 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 kmem_cache_alloc_node+0x132/0x480 mm/slub.c:2927
 __alloc_skb+0x71/0x550 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1094 [inline]
 alloc_skb_with_frags+0x92/0x570 net/core/skbuff.c:5832
 sock_alloc_send_pskb+0x72a/0x880 net/core/sock.c:2329
 j1939_sk_alloc_skb net/can/j1939/socket.c:857 [inline]
 j1939_sk_send_loop net/can/j1939/socket.c:1039 [inline]
 j1939_sk_sendmsg+0x6bb/0x1380 net/can/j1939/socket.c:1174
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 sock_no_sendpage+0xee/0x130 net/core/sock.c:2833
 kernel_sendpage.part.0+0x1ab/0x350 net/socket.c:3646
 kernel_sendpage net/socket.c:3643 [inline]
 sock_sendpage+0xe5/0x140 net/socket.c:944
 pipe_to_sendpage+0x2ad/0x380 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x3dc/0x830 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0xd4/0x140 fs/splice.c:743
 do_splice_from fs/splice.c:764 [inline]
 do_splice+0xbb8/0x1790 fs/splice.c:1061
 __do_sys_splice fs/splice.c:1306 [inline]
 __se_sys_splice fs/splice.c:1288 [inline]
 __ia32_sys_splice+0x195/0x250 fs/splice.c:1288
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Freed by task 22:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:622
 __kfree_skb net/core/skbuff.c:679 [inline]
 kfree_skb net/core/skbuff.c:696 [inline]
 kfree_skb+0x140/0x3f0 net/core/skbuff.c:690
 j1939_session_skb_drop_old net/can/j1939/transport.c:333 [inline]
 j1939_xtp_rx_cts_one net/can/j1939/transport.c:1394 [inline]
 j1939_xtp_rx_cts+0xb59/0xec0 net/can/j1939/transport.c:1433
 j1939_tp_cmd_recv net/can/j1939/transport.c:2001 [inline]
 j1939_tp_recv+0x8be/0xb40 net/can/j1939/transport.c:2067
 j1939_can_recv+0x5bc/0x7d0 net/can/j1939/main.c:101
 deliver net/can/af_can.c:571 [inline]
 can_rcv_filter+0x5d4/0x8d0 net/can/af_can.c:605
 can_receive+0x2e3/0x520 net/can/af_can.c:662
 can_rcv+0x12a/0x1a0 net/can/af_can.c:688
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5311
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5425
 process_backlog+0x232/0x6c0 net/core/dev.c:6315
 napi_poll net/core/dev.c:6759 [inline]
 net_rx_action+0x4dc/0x1100 net/core/dev.c:6829
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298

The buggy address belongs to the object at ffff8880219f3040
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 78 bytes inside of
 224-byte region [ffff8880219f3040, ffff8880219f3120)
The buggy address belongs to the page:
page:000000007e0b9bbc refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x219f2
head:000000007e0b9bbc order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88804030a500
raw: 0000000000000000 0000000000190019 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880219f2f80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880219f3000: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff8880219f3080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff8880219f3100: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880219f3180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
