Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D05E8794
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiIXCku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiIXCkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:40:49 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AE1E741D
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 19:40:46 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id m5-20020a056e021c2500b002f65685226eso1490540ilh.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 19:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=onJAqhgCyi2YJW4sYUxj2DDCsFwDiwgCEPMaHbSzii8=;
        b=eYz/KUlZ3PxzqrTu9fAj0Sj/E4XUukdT1ticSu2aIY/wRkBkBjzmN9IUMjyRPHbULa
         AeOW8f+UFfxyMUsnH4cyrW5cEupj7z5Js3y8SI8CsUIGxLoLJCjpajSmb5Dxdwly+kZS
         3MfzMwiBAuYDRORfwpfaoNNY30ushgDyTXJs9MjCp6XOTryx2Tq9rxcp9FFOd1JQLBZA
         i7ux95JV0kGeWT8xohJ+mCUc86ZjPW2Ayof+NZyy5FgIXLN6mQ4R2UyBJGk0DFw8jhfQ
         PTh+6q3ElxkvQ0Jxcw5wvuH9pfXTpoQ0DIJvp64HoS4o9Z7ix1AcMvebCIVzGYbaw2zK
         h+VQ==
X-Gm-Message-State: ACrzQf0xEqjDPhkNITDP29EDLfRJVGeApuyMlCAXQ+A2kqRUoMqFfd2b
        sQR9XW+F6J00AhGWmHOP8gnBrmoN6kzZTFnR6ziNVzVn5dsS
X-Google-Smtp-Source: AMsMyM4SjhsGnfCPrn904C8VG+JdYCNtOhuR5Bf9rtuX/yFlye1DW3iYQpOrw+eC/ZCPeNArNmqDrw+XHos0LZjpd4bFTZj/hFPr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1074:b0:2f6:15d9:4719 with SMTP id
 q20-20020a056e02107400b002f615d94719mr5508688ilj.123.1663987245895; Fri, 23
 Sep 2022 19:40:45 -0700 (PDT)
Date:   Fri, 23 Sep 2022 19:40:45 -0700
In-Reply-To: <000000000000e848fb05e962fb56@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3d6e705e96338b2@google.com>
Subject: Re: [syzbot] WARNING: held lock freed in l2cap_conn_del
From:   syzbot <syzbot+f5f14f5e9e2df9920b98@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    1707c39ae309 Merge tag 'driver-core-6.0-rc7' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=145ed640880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=122d7bd4fc8e0ecb
dashboard link: https://syzkaller.appspot.com/bug?extid=f5f14f5e9e2df9920b98
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bce6e4880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12903cff080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f5f14f5e9e2df9920b98@syzkaller.appspotmail.com

Bluetooth: hci0: hardware error 0x00
=========================
WARNING: held lock freed!
6.0.0-rc6-syzkaller-00281-g1707c39ae309 #0 Not tainted
-------------------------
kworker/u5:2/3610 is freeing memory ffff888021840000-ffff8880218407ff, with a lock still held there!
ffff888021840520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_chan_lock include/net/bluetooth/l2cap.h:855 [inline]
ffff888021840520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_conn_del+0x3b5/0x7b0 net/bluetooth/l2cap_core.c:1920
7 locks held by kworker/u5:2/3610:
 #0: ffff888147a10938 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888147a10938 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888147a10938 ((wq_completion)hci0){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888147a10938 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff888147a10938 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff888147a10938 ((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90003a6fda8 ((work_completion)(&hdev->error_reset)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
 #2: ffff888077b60fd0 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close+0x25/0x70 net/bluetooth/hci_core.c:552
 #3: ffff888077b60078 (&hdev->lock){+.+.}-{3:3}, at: hci_dev_close_sync+0x268/0x1130 net/bluetooth/hci_sync.c:4463
 #4: ffffffff8d9d3e28 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:1776 [inline]
 #4: ffffffff8d9d3e28 (hci_cb_list_lock){+.+.}-{3:3}, at: hci_conn_hash_flush+0xd5/0x260 net/bluetooth/hci_conn.c:2366
 #5: ffff888149a112d8 (&conn->chan_lock){+.+.}-{3:3}, at: l2cap_conn_del+0x2ef/0x7b0 net/bluetooth/l2cap_core.c:1915
 #6: ffff888021840520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_chan_lock include/net/bluetooth/l2cap.h:855 [inline]
 #6: ffff888021840520 (&chan->lock/1){+.+.}-{3:3}, at: l2cap_conn_del+0x3b5/0x7b0 net/bluetooth/l2cap_core.c:1920

stack backtrace:
CPU: 0 PID: 3610 Comm: kworker/u5:2 Not tainted 6.0.0-rc6-syzkaller-00281-g1707c39ae309 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Workqueue: hci0 hci_error_reset
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_freed_lock_bug kernel/locking/lockdep.c:6422 [inline]
 debug_check_no_locks_freed.cold+0x9d/0xa9 kernel/locking/lockdep.c:6455
 slab_free_hook mm/slub.c:1731 [inline]
 slab_free_freelist_hook+0x73/0x1c0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xe2/0x580 mm/slub.c:4567
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:503 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x22a/0x2d0 net/bluetooth/l2cap_core.c:527
 l2cap_conn_del+0x3fc/0x7b0 net/bluetooth/l2cap_core.c:1924
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8212 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8205
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x55d/0x1130 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x96/0x130 net/bluetooth/hci_core.c:1050
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_long_read include/linux/atomic/atomic-instrumented.h:1265 [inline]
BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0xa6/0x5e0 kernel/locking/mutex.c:916
Read of size 8 at addr ffff8880218404b8 by task kworker/u5:2/3610

CPU: 0 PID: 3610 Comm: kworker/u5:2 Not tainted 6.0.0-rc6-syzkaller-00281-g1707c39ae309 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Workqueue: hci0 hci_error_reset
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:1265 [inline]
 __mutex_unlock_slowpath+0xa6/0x5e0 kernel/locking/mutex.c:916
 l2cap_chan_unlock include/net/bluetooth/l2cap.h:860 [inline]
 l2cap_conn_del+0x404/0x7b0 net/bluetooth/l2cap_core.c:1926
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8212 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8205
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x55d/0x1130 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x96/0x130 net/bluetooth/hci_core.c:1050
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 49:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc mm/kasan/common.c:516 [inline]
 ____kasan_kmalloc mm/kasan/common.c:475 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 l2cap_chan_create+0x40/0x570 net/bluetooth/l2cap_core.c:463
 a2mp_chan_open net/bluetooth/a2mp.c:771 [inline]
 amp_mgr_create+0x8f/0x960 net/bluetooth/a2mp.c:862
 a2mp_channel_create+0x7d/0x150 net/bluetooth/a2mp.c:894
 l2cap_data_channel net/bluetooth/l2cap_core.c:7569 [inline]
 l2cap_recv_frame+0x48e3/0x8d90 net/bluetooth/l2cap_core.c:7724
 l2cap_recv_acldata+0xaa6/0xc00 net/bluetooth/l2cap_core.c:8429
 hci_acldata_packet net/bluetooth/hci_core.c:3777 [inline]
 hci_rx_work+0x705/0x1230 net/bluetooth/hci_core.c:4012
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Freed by task 3610:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:367 [inline]
 ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1759 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xe2/0x580 mm/slub.c:4567
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:503 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x22a/0x2d0 net/bluetooth/l2cap_core.c:527
 l2cap_conn_del+0x3fc/0x7b0 net/bluetooth/l2cap_core.c:1924
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8212 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8205
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1779 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2366
 hci_dev_close_sync+0x55d/0x1130 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x96/0x130 net/bluetooth/hci_core.c:1050
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

The buggy address belongs to the object at ffff888021840000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1208 bytes inside of
 2048-byte region [ffff888021840000, ffff888021840800)

The buggy address belongs to the physical page:
page:ffffea0000861000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21840
head:ffffea0000861000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888011842000
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x52a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 49, tgid 49 (kworker/u5:0), ts 46525106359, free_ts 46388169462
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
 alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:1829 [inline]
 allocate_slab+0x27e/0x3d0 mm/slub.c:1974
 new_slab mm/slub.c:2034 [inline]
 ___slab_alloc+0x7f1/0xe10 mm/slub.c:3036
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3123
 slab_alloc_node mm/slub.c:3214 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 kmem_cache_alloc_trace+0x323/0x3e0 mm/slub.c:3287
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 l2cap_chan_create+0x40/0x570 net/bluetooth/l2cap_core.c:463
 a2mp_chan_open net/bluetooth/a2mp.c:771 [inline]
 amp_mgr_create+0x8f/0x960 net/bluetooth/a2mp.c:862
 a2mp_channel_create+0x7d/0x150 net/bluetooth/a2mp.c:894
 l2cap_data_channel net/bluetooth/l2cap_core.c:7569 [inline]
 l2cap_recv_frame+0x48e3/0x8d90 net/bluetooth/l2cap_core.c:7724
 l2cap_recv_acldata+0xaa6/0xc00 net/bluetooth/l2cap_core.c:8429
 hci_acldata_packet net/bluetooth/hci_core.c:3777 [inline]
 hci_rx_work+0x705/0x1230 net/bluetooth/hci_core.c:4012
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2553
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:727 [inline]
 slab_alloc_node mm/slub.c:3248 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3263 [inline]
 kmem_cache_alloc+0x267/0x3b0 mm/slub.c:3273
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:139
 getname_flags+0x9a/0xe0 include/linux/audit.h:320
 vfs_fstatat+0x73/0xb0 fs/stat.c:254
 __do_sys_newfstatat+0x91/0x110 fs/stat.c:425
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff888021840380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888021840400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888021840480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888021840500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888021840580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

