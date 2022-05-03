Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557AE518379
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbiECLwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 07:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiECLv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:51:58 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657F135859
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:48:26 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id n15-20020a056602340f00b0065a54d17512so4421729ioz.23
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 04:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jfg33bwwnWloyf0ql/T0M8gQrJH26kBsHt+yDGopNsk=;
        b=CufCiBdxRtF+MOYbohy/KPkgt1siZT3M9ETF4RVT7PjTrJti9jryAsCPx3eGwlWTg4
         NPhUqJDKZBG92et4r/xIz9qVgRIaIlvc9oZwK6/idE3DI4Wj7PSg2R3yUK/S9UahQXG8
         7P87kWabLwffpb2wdErqJyC/kX5CuCsJ6BA8rVRkv3dcS/YPij6zbf1rOx9j9SxSzJyU
         DUxly6uQkigZfxotRbYTRelPczWt82UL4yLaPfUXfhlVvRsgoXDmAHvt7gOvFLzC04ng
         NrNLqwf/AaED8NOmdeHzgSbMjF0yPkKVZbdwcV5piVmieFkdpqXGCVuuVj50sa4nSSwv
         c+qA==
X-Gm-Message-State: AOAM530GzDMNlU6GRIO3fHzAQ+aZRpU4pkHgYb/7YZs0GP9OsPsXtGSP
        hGPaQgddkPRkBNheFj/Tsf7grB10YxY/J/zmAVUKRkt9Hq1J
X-Google-Smtp-Source: ABdhPJy0fwgrEg2Ut7yLPy9j2IYl+/CjlS3vKZiHQezhF1oeI3U9MuzGCdS2BU23TFjILi9+9eGNcE9iS1yfg49R/ugVkoI1Yh+B
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1542:b0:2cf:47c:7c35 with SMTP id
 j2-20020a056e02154200b002cf047c7c35mr4491731ilu.147.1651578505340; Tue, 03
 May 2022 04:48:25 -0700 (PDT)
Date:   Tue, 03 May 2022 04:48:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000212fec05de1a16ec@google.com>
Subject: [syzbot] KASAN: use-after-free Read in blk_mq_sched_free_rqs
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

Hello,

syzbot found the following issue on:

HEAD commit:    febb2d2fa561 Merge tag 'for-net-2022-04-27' of git://git.k..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11aaf7f0f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88991a1d8c403a9e
dashboard link: https://syzkaller.appspot.com/bug?extid=3e3f419f4a7816471838
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e3f419f4a7816471838@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in blk_mq_sched_free_rqs+0x211/0x250 block/blk-mq-sched.c:631
Read of size 4 at addr ffff88801b996058 by task udevd/21250

CPU: 1 PID: 21250 Comm: udevd Not tainted 5.18.0-rc3-syzkaller-00277-gfebb2d2fa561 #0
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
 blkdev_close+0x64/0x80 block/fops.c:512
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f764d925fc3
Code: 48 ff ff ff b8 ff ff ff ff e9 3e ff ff ff 66 0f 1f 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
RSP: 002b:00007fff1c213418 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 00007f764dcee6a8 RCX: 00007f764d925fc3
RDX: 0000000003938700 RSI: 000000000aba9500 RDI: 0000000000000008
RBP: 000055ec72d9d8f0 R08: 0000000000000001 R09: 000055ec72dbc190
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000002
R13: 000055ec72d9fb70 R14: 0000000000000008 R15: 000055ec72d96910
 </TASK>

Allocated by task 1:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 nbd_dev_add+0x4d/0xcd0 drivers/block/nbd.c:1730
 nbd_init+0x297/0x2a7 drivers/block/nbd.c:2511
 do_one_initcall+0x103/0x650 init/main.c:1298
 do_initcall_level init/main.c:1371 [inline]
 do_initcalls init/main.c:1387 [inline]
 do_basic_setup init/main.c:1406 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1613
 kernel_init+0x1a/0x1d0 init/main.c:1502
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Freed by task 8:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3510 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4552
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
 insert_work+0x48/0x350 kernel/workqueue.c:1358
 __queue_work+0x62e/0x1140 kernel/workqueue.c:1517
 queue_work_on+0xee/0x110 kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:502 [inline]
 nbd_put drivers/block/nbd.c:279 [inline]
 nbd_put+0xd7/0x120 drivers/block/nbd.c:272
 blkdev_put_whole block/bdev.c:689 [inline]
 blkdev_put+0x2e4/0x950 block/bdev.c:947
 blkdev_close+0x64/0x80 block/fops.c:512
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801b996000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 88 bytes inside of
 1024-byte region [ffff88801b996000, ffff88801b996400)

The buggy address belongs to the physical page:
page:ffffea00006e6400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1b990
head:ffffea00006e6400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c41dc0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 7498210050, free_ts 0
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 __alloc_pages_node include/linux/gfp.h:587 [inline]
 alloc_slab_page mm/slub.c:1801 [inline]
 allocate_slab+0x80/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 kmem_cache_alloc_node_trace+0x116/0x310 mm/slub.c:3281
 kmalloc_node include/linux/slab.h:599 [inline]
 kzalloc_node include/linux/slab.h:725 [inline]
 sbitmap_queue_init_node+0x1d8/0x460 lib/sbitmap.c:438
 bt_alloc block/blk-mq-tag.c:543 [inline]
 blk_mq_init_bitmaps+0x57/0x180 block/blk-mq-tag.c:555
 blk_mq_init_tags+0x10b/0x170 block/blk-mq-tag.c:586
 blk_mq_alloc_rq_map+0x1ba/0x3b0 block/blk-mq.c:3169
 blk_mq_alloc_map_and_rqs block/blk-mq.c:3620 [inline]
 __blk_mq_alloc_map_and_rqs block/blk-mq.c:3642 [inline]
 __blk_mq_alloc_map_and_rqs block/blk-mq.c:3633 [inline]
 __blk_mq_alloc_rq_maps block/blk-mq.c:4119 [inline]
 blk_mq_alloc_set_map_and_rqs block/blk-mq.c:4150 [inline]
 blk_mq_alloc_tag_set+0x8cc/0x12b0 block/blk-mq.c:4309
 nbd_dev_add+0x2b1/0xcd0 drivers/block/nbd.c:1745
 nbd_init+0x297/0x2a7 drivers/block/nbd.c:2511
 do_one_initcall+0x103/0x650 init/main.c:1298
 do_initcall_level init/main.c:1371 [inline]
 do_initcalls init/main.c:1387 [inline]
 do_basic_setup init/main.c:1406 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1613
 kernel_init+0x1a/0x1d0 init/main.c:1502
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801b995f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801b995f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801b996000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff88801b996080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801b996100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
