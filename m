Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A64F304B31
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbhAZEtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:49:33 -0500
Received: from mail-pl1-f200.google.com ([209.85.214.200]:48059 "EHLO
        mail-pl1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbhAYJVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:21:34 -0500
Received: by mail-pl1-f200.google.com with SMTP id i2so7187597plt.14
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 01:20:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pNSUKd7vykHQaWeEVJavyvqT9xP++GKxREp91ttTN7A=;
        b=LEImwSfbdTOVLHUUQpMa4FutS3pDnrRfahbhBqz639paVucN1oRTIhXnOzp3aq86lw
         f43kKQ3gtfSYYLsy3BVnTyDYNzbpxZNr/UByHhEC9FedbsJg3E9QyAt7irza5wKtJjsz
         H22zfemrDMGJzF8rdVlBMsEcBGBNQyWLe9TIOiBJB89vlARv1LXTTevCL2UQ+LUvJc3G
         OvXki3miygwXLbM9M7bKjqcAX7BTqRwNNtUopcoXKGdbpGPdfiu04udDzQye/e//jc3D
         j6mmOQchit+OZ4qbCf8YnVPsrO7pITLE4EanCEvy7ezUOv99LdZb8/dyybWNXgXlRDjW
         Du4w==
X-Gm-Message-State: AOAM531GnRDWc6RddLrQdPkkU+orTkL7Zwt4tie1Ppvx2VBWUN0IlCl4
        r2Ft5g8xSz6mCHKOxkc77qLz7tdK47QXSwqyg2rdKcJHwU4i
X-Google-Smtp-Source: ABdhPJzshc/dS5LGbcsTJhcYEQ+6nMIofXD1Pr3Eto8ywELID1GLt0lTKOFTFlMUKrPdjyM/WoSLmhsRWO6u+k1VtWbhNmxk3NaT
MIME-Version: 1.0
X-Received: by 2002:a92:79c7:: with SMTP id u190mr9482ilc.140.1611564739238;
 Mon, 25 Jan 2021 00:52:19 -0800 (PST)
Date:   Mon, 25 Jan 2021 00:52:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d0a0ae05b9b5a7de@google.com>
Subject: KASAN: use-after-free Read in rxrpc_get_skb
From:   syzbot <syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7d68e382 bpf: Permit size-0 datasec
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17e024c8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c7843b8af99dff
dashboard link: https://syzkaller.appspot.com/bug?extid=3d1c772efafd3c38d007
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rxrpc_get_skb+0x1ce/0x1e0 net/rxrpc/skbuff.c:50
Read of size 1 at addr ffff8880117ae8ed by task kworker/1:4/9736

CPU: 1 PID: 9736 Comm: kworker/1:4 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: krxrpcd rxrpc_process_call
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 rxrpc_get_skb+0x1ce/0x1e0 net/rxrpc/skbuff.c:50
 rxrpc_resend net/rxrpc/call_event.c:263 [inline]
 rxrpc_process_call+0x1619/0x1f60 net/rxrpc/call_event.c:412
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 20353:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kasan_slab_alloc include/linux/kasan.h:205 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 kmem_cache_alloc_node+0x1e0/0x470 mm/slub.c:2927
 __alloc_skb+0x71/0x5a0 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1100 [inline]
 alloc_skb_with_frags+0x93/0x5d0 net/core/skbuff.c:5887
 sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2348
 rxrpc_send_data+0xb51/0x2bf0 net/rxrpc/sendmsg.c:358
 rxrpc_do_sendmsg+0xc03/0x1350 net/rxrpc/sendmsg.c:744
 rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:560
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 20353:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:188 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:633
 __kfree_skb net/core/skbuff.c:690 [inline]
 kfree_skb net/core/skbuff.c:707 [inline]
 kfree_skb+0x140/0x3f0 net/core/skbuff.c:701
 rxrpc_free_skb+0x11d/0x150 net/rxrpc/skbuff.c:78
 rxrpc_cleanup_ring net/rxrpc/call_object.c:485 [inline]
 rxrpc_release_call+0x5dd/0x860 net/rxrpc/call_object.c:552
 rxrpc_release_calls_on_socket+0x21c/0x300 net/rxrpc/call_object.c:579
 rxrpc_release_sock net/rxrpc/af_rxrpc.c:885 [inline]
 rxrpc_release+0x263/0x5a0 net/rxrpc/af_rxrpc.c:916
 __sock_release+0xcd/0x280 net/socket.c:597
 sock_close+0x18/0x20 net/socket.c:1256
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xc5c/0x2ae0 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x3e9/0x20a0 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880117ae8c0
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 45 bytes inside of
 232-byte region [ffff8880117ae8c0, ffff8880117ae9a8)
The buggy address belongs to the page:
page:000000006d18c7f7 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x117ae
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff8881406f7c80
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880117ae780: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880117ae800: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
>ffff8880117ae880: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                          ^
 ffff8880117ae900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880117ae980: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
