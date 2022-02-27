Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643E84C59D2
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 07:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiB0GUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 01:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiB0GUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 01:20:45 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2CEB852
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 22:20:08 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id o10-20020a92d4ca000000b002c27571073fso6566089ilm.10
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 22:20:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=tEAUwkc1+1EVNiMgtrncZnB4tXaWfbfFUyH7fcGOHFA=;
        b=va8fSlG+7QR2I4ey/iXXisIsSkm77nTytWpq8MTwV3Z5Y0c+xiKzyspDmp5ui0J0pG
         WeBC5aa9xhNtgeYxQ8jRuhou3i7LP+ea4Yh0KaqqGrWKAGbP57jz2NbqSkctRuR+Tva3
         JWnM2brQhTRXyKR9FK1BqtDHjt72S4MkzzVH1fa6UBSDiMMp1MkLEnjNqpLXLxN6NwO6
         JY7Io6PTLZHYy3YihvrtYAcs3oLtGaY/cAgjJGQHlnuqqdbEfyRUBJ76jcWjDiLmeewm
         bXAuunJwVXMVQdsw4BhUhQy82Y0Frmu3aXO9HAuAatgmo5TbVjTRk+kYt6P/ZOOa8EdE
         hmcA==
X-Gm-Message-State: AOAM532sc2Zs4ydDICNc+OOfy8bV9sdjdSBQz9cX5d6ENswnQ61eK3t8
        AOhKSN7uFQ/Xsa8s4/j9kPPPD/6Gy9wDrJBJbaOup/1H8bvE
X-Google-Smtp-Source: ABdhPJzDaYk8BlOBF5Q5n8hODm4a87NUSx4RsBWq1NnW495kIX37qlAaN7OaoJN0XNiZtTM3Nd8QaqvfKm6zxmHcDn9mWufaYiDr
MIME-Version: 1.0
X-Received: by 2002:a02:5184:0:b0:30f:5c44:fd8a with SMTP id
 s126-20020a025184000000b0030f5c44fd8amr11956758jaa.203.1645942807820; Sat, 26
 Feb 2022 22:20:07 -0800 (PST)
Date:   Sat, 26 Feb 2022 22:20:07 -0800
In-Reply-To: <20220227060827.2844-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000617faa05d8f9ec29@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sco_sock_timeout
From:   syzbot <syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com>
To:     desmondcheongzx@gmail.com, hdanton@sina.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: use-after-free Write in sco_sock_timeout

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:726 [inline]
BUG: KASAN: use-after-free in sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:89
Write of size 4 at addr ffff88801d165080 by task kworker/0:1/8

CPU: 0 PID: 8 Comm: kworker/0:1 Not tainted 5.17.0-rc4-syzkaller-01424-g922ea87ff6f2-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events sco_sock_timeout
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:726 [inline]
 sco_sock_timeout+0x64/0x290 net/bluetooth/sco.c:89
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 4059:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:586 [inline]
 sk_prot_alloc+0x110/0x290 net/core/sock.c:1936
 sk_alloc+0x32/0xa80 net/core/sock.c:1989
 sco_sock_alloc.constprop.0+0x31/0x330 net/bluetooth/sco.c:484
 sco_sock_create+0xd5/0x1b0 net/bluetooth/sco.c:523
 bt_sock_create+0x17c/0x340 net/bluetooth/af_bluetooth.c:130
 __sock_create+0x353/0x790 net/socket.c:1468
 sock_create net/socket.c:1519 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1561
 __do_sys_socket net/socket.c:1570 [inline]
 __se_sys_socket net/socket.c:1568 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 4060:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x126/0x160 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kfree+0xd0/0x390 mm/slub.c:4562
 sk_prot_free net/core/sock.c:1972 [inline]
 __sk_destruct+0x6c0/0x920 net/core/sock.c:2058
 sk_destruct+0x131/0x180 net/core/sock.c:2076
 __sk_free+0xef/0x3d0 net/core/sock.c:2087
 sk_free+0x78/0xa0 net/core/sock.c:2098
 sock_put include/net/sock.h:1926 [inline]
 sco_sock_kill+0x18d/0x1b0 net/bluetooth/sco.c:403
 sco_sock_release+0x162/0x2d0 net/bluetooth/sco.c:1260
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1318
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1de2/0x2490 kernel/signal.c:2631
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3026 [inline]
 call_rcu+0xb1/0x740 kernel/rcu/tree.c:3106
 netlink_release+0xf08/0x1db0 net/netlink/af_netlink.c:813
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1318
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3026 [inline]
 call_rcu+0xb1/0x740 kernel/rcu/tree.c:3106
 netlink_release+0xf08/0x1db0 net/netlink/af_netlink.c:813
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1318
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801d165000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff88801d165000, ffff88801d165800)
The buggy address belongs to the page:
page:ffffea0000745800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1d160
head:ffffea0000745800 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea000070c000 dead000000000002 ffff888010c42000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 54, ts 8464675040, free_ts 0
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x27f/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0xbe1/0x12b0 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 __kmalloc+0x372/0x450 mm/slub.c:4420
 kmalloc include/linux/slab.h:586 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 scsi_alloc_target+0x132/0xc60 drivers/scsi/scsi_scan.c:498
 __scsi_scan_target+0x13a/0xdb0 drivers/scsi/scsi_scan.c:1632
 scsi_scan_channel drivers/scsi/scsi_scan.c:1737 [inline]
 scsi_scan_channel+0x148/0x1e0 drivers/scsi/scsi_scan.c:1713
 scsi_scan_host_selected+0x2df/0x3b0 drivers/scsi/scsi_scan.c:1766
 do_scsi_scan_host+0x1e8/0x260 drivers/scsi/scsi_scan.c:1905
 do_scan_async+0x3e/0x500 drivers/scsi/scsi_scan.c:1915
 async_run_entry_fn+0x9d/0x550 kernel/async.c:127
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801d164f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801d165000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801d165080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801d165100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801d165180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         922ea87f ionic: use vmalloc include
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
console output: https://syzkaller.appspot.com/x/log.txt?x=144f85da700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d63ad23bb09039e8
dashboard link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16e9136c700000

