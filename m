Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F88C5354D5
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 22:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349115AbiEZUos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 16:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349119AbiEZUok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 16:44:40 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AC3E7306
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 13:44:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id t1-20020a056602140100b0065393cc1dc3so1662493iov.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 13:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YLpfqytwZpazcMvsxOmLyJTXwY63w1jw+WEd0Y5fcQU=;
        b=KBfPdlPR2HSirhy9YWh/9xPxFXnVbb5v1P56PkL5zUOh1s15TWKleHOYBUDLkIcXH9
         O1OuKByHWPUy13U9uYNJl22z0IP4x4a5yEmufrUxgj82nQQWqBmcgrzS7sZPaA2P9Wq2
         8Wwiyr+MtMD4zyhEQRuYAX3UCYiBsJMgzM5q5LqIzXAO4ZX5NJ3cppOguAXuAr1E08YU
         CJxhyzN6e84eqRsrxvBjY/+rwQgfRm+XIspkkNpOGlIo0uyQdUJAOvsrAISGRqX3ySiH
         SwUUlgjvCRb8d+35Ju8e8gbn0WeII0CQWDm3CLiN6INZ4peC33T/gg3pSCnrg/1Gu4Pv
         Vukw==
X-Gm-Message-State: AOAM533nEVG07v/Qu61XAC4Cz7UMgpV2vOmBZW+8djHEChLr5EVboHiA
        dhbWpESqRRlvwsy07YOSWZ4UCSZgwk1U4kcLIyzBj1epykw9
X-Google-Smtp-Source: ABdhPJye1DkXT8FOzDD3SU2FqtfgKeugTAvQ24ijnDcQg0doWCxx+7P0koKkCQdnjEvE5jDNj/01L2W/+nOf10CRx6UHiGi2l9+K
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170b:b0:2cf:970f:6050 with SMTP id
 u11-20020a056e02170b00b002cf970f6050mr20806107ill.5.1653597861100; Thu, 26
 May 2022 13:44:21 -0700 (PDT)
Date:   Thu, 26 May 2022 13:44:21 -0700
In-Reply-To: <000000000000212fec05de1a16ec@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001cc34505dff04143@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in blk_mq_sched_free_rqs
From:   syzbot <syzbot+3e3f419f4a7816471838@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    6c465408a770 dt-bindings: net: adin: Fix adi,phy-output-cl..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=147357d5f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2c9c27babb4d679
dashboard link: https://syzkaller.appspot.com/bug?extid=3e3f419f4a7816471838
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1658daf3f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a6a8eef00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e3f419f4a7816471838@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in blk_mq_sched_free_rqs+0x211/0x250 block/blk-mq-sched.c:631
Read of size 4 at addr ffff888076e82858 by task udevd/3675

CPU: 1 PID: 3675 Comm: udevd Not tainted 5.18.0-syzkaller-04953-g6c465408a770 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 blk_mq_sched_free_rqs+0x211/0x250 block/blk-mq-sched.c:631
 elevator_exit+0x3b/0x70 block/elevator.c:196
 disk_release_mq block/genhd.c:1139 [inline]
 disk_release+0x17c/0x420 block/genhd.c:1168
 device_release+0x9f/0x240 drivers/base/core.c:2229
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 put_device+0x1b/0x30 drivers/base/core.c:3512
 blkdev_close+0x64/0x80 block/fops.c:495
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f6713525fc3
Code: 48 ff ff ff b8 ff ff ff ff e9 3e ff ff ff 66 0f 1f 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
RSP: 002b:00007ffe588d18a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 00007f671390c6a8 RCX: 00007f6713525fc3
RDX: 0000000003938700 RSI: 000000000aba9500 RDI: 0000000000000008
RBP: 00005558b8e42300 R08: 0000000000000001 R09: 00005558b8e41190
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000002
R13: 00005558b8e1bef0 R14: 0000000000000008 R15: 00005558b8e1b910
 </TASK>

Allocated by task 21741:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:588 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 nbd_dev_add+0x4d/0xc90 drivers/block/nbd.c:1729
 nbd_genl_connect+0x11f3/0x1930 drivers/block/nbd.c:1946
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 3751:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1727 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1753
 slab_free mm/slub.c:3507 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4555
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 insert_work+0x48/0x350 kernel/workqueue.c:1358
 __queue_work+0x62e/0x1140 kernel/workqueue.c:1517
 queue_work_on+0xee/0x110 kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:502 [inline]
 nbd_put drivers/block/nbd.c:279 [inline]
 nbd_put+0xd7/0x120 drivers/block/nbd.c:272
 blkdev_put_whole+0xbb/0xf0 block/bdev.c:696
 blkdev_put+0x226/0x770 block/bdev.c:954
 blkdev_close+0x64/0x80 block/fops.c:495
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff888076e82800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 88 bytes inside of
 1024-byte region [ffff888076e82800, ffff888076e82c00)

The buggy address belongs to the physical page:
page:ffffea0001dba000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x76e80
head:ffffea0001dba000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888010c41dc0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 19417, tgid 19413 (syz-executor130), ts 1575509356197, free_ts 1575489414721
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 __alloc_pages_node include/linux/gfp.h:587 [inline]
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x80/0x3c0 mm/slub.c:1942
 new_slab mm/slub.c:2002 [inline]
 ___slab_alloc+0x985/0xd90 mm/slub.c:3002
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3089
 slab_alloc_node mm/slub.c:3180 [inline]
 kmem_cache_alloc_node_trace+0x185/0x420 mm/slub.c:3278
 kmalloc_node include/linux/slab.h:606 [inline]
 kzalloc_node include/linux/slab.h:732 [inline]
 sbitmap_queue_init_node+0x1d8/0x460 lib/sbitmap.c:438
 bt_alloc block/blk-mq-tag.c:543 [inline]
 blk_mq_init_bitmaps+0x57/0x180 block/blk-mq-tag.c:555
 blk_mq_init_tags+0x10b/0x170 block/blk-mq-tag.c:586
 blk_mq_alloc_rq_map+0x1ba/0x3b0 block/blk-mq.c:3179
 blk_mq_alloc_map_and_rqs+0x4b/0x180 block/blk-mq.c:3630
 blk_mq_sched_alloc_map_and_rqs block/blk-mq-sched.c:507 [inline]
 blk_mq_init_sched+0x2af/0x6d0 block/blk-mq-sched.c:587
 elevator_init_mq+0x2b5/0x4e0 block/elevator.c:709
 device_add_disk+0x102/0xe20 block/genhd.c:425
 add_disk include/linux/blkdev.h:761 [inline]
 nbd_dev_add+0x89f/0xc90 drivers/block/nbd.c:1816
 nbd_genl_connect+0x11f3/0x1930 drivers/block/nbd.c:1946
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2521
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:750 [inline]
 slab_alloc_node mm/slub.c:3214 [inline]
 slab_alloc mm/slub.c:3222 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3229 [inline]
 kmem_cache_alloc+0x204/0x3b0 mm/slub.c:3239
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:139
 getname_flags+0x9a/0xe0 include/linux/audit.h:323
 vfs_fstatat+0x73/0xb0 fs/stat.c:254
 vfs_lstat include/linux/fs.h:3136 [inline]
 __do_sys_newlstat+0x8b/0x110 fs/stat.c:411
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Memory state around the buggy address:
 ffff888076e82700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888076e82780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888076e82800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888076e82880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888076e82900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

