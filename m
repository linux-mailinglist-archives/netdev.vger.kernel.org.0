Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9A526F99
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiENHfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 03:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiENHfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 03:35:23 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CA023E
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 00:35:20 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso6275612ioo.13
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 00:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZxEs3HMnmKvqIZL34xAsWfWg2TolICgmPzbL68K0Ecc=;
        b=Sll5i0h1xxOiZkn3XVcOzZfS6dkop94L/LyDIz9gbCZJWSaJKA+lIFyfImTflIl9nH
         9XekxmoGx5qT3rZ+XdL6WRHhp+iEO9odjkSrAr3TDyBDwfwUDot+BW/d+V2woEkqXckZ
         WCYSk4GKLmKgY3JAb/qqNbhIR6MEPUdJjNZCFvQNVNyZDor2eWVm7GsCsOlXRIvIr86f
         dwSGqAf9Jzhrd094EvGauByUHBFVa/C5DyRlP26ID4YfIgpHC/03pvQtt/MATdTVYIdY
         oDg4Fs/dSKbQl3z+kAmYqlCcH28vVWKFil4ccyTnsacYK9prsW9bDUEkIQ6ZzNP64H2Q
         Qm8A==
X-Gm-Message-State: AOAM531T1sqmDjvKALx7GjPz7G7C9/6qazOMqNAaixbroaILRjDD8Waa
        7kK/EWW2s5JAlA6UIcYpJ6KrWSH7yrJcFJh7Bym1lvBz8ZDL
X-Google-Smtp-Source: ABdhPJyMppWPzAMw129yotfB2Q/JGzMJAuBzqSqtAR5JELwzFrB5+YrUivU/mJSUPy4WQFW3TBiYIII4K+ka/8/K8aArCWmjwEhM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c87:b0:2cf:2d3d:dd89 with SMTP id
 w7-20020a056e021c8700b002cf2d3ddd89mr4609906ill.36.1652513720034; Sat, 14 May
 2022 00:35:20 -0700 (PDT)
Date:   Sat, 14 May 2022 00:35:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044eb3305def3d567@google.com>
Subject: [syzbot] KASAN: use-after-free Read in slip_open (2)
From:   syzbot <syzbot+9d130534f0d300732a3a@syzkaller.appspotmail.com>
To:     arnd@arndb.de, davem@davemloft.net, dmitry.torokhov@gmail.com,
        edumazet@google.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    9be9ed2612b5 Merge tag 'platform-drivers-x86-v5.18-4' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=122c18c6f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79caa0035f59d385
dashboard link: https://syzkaller.appspot.com/bug?extid=9d130534f0d300732a3a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d130534f0d300732a3a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in sl_sync drivers/net/slip/slip.c:730 [inline]
BUG: KASAN: use-after-free in slip_open+0xec3/0x11b0 drivers/net/slip/slip.c:806
Read of size 1 at addr ffff888056ca8df1 by task syz-executor.1/3054

CPU: 1 PID: 3054 Comm: syz-executor.1 Not tainted 5.18.0-rc6-syzkaller-00007-g9be9ed2612b5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 sl_sync drivers/net/slip/slip.c:730 [inline]
 slip_open+0xec3/0x11b0 drivers/net/slip/slip.c:806
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:433
 tty_set_ldisc+0x2f1/0x680 drivers/tty/tty_ldisc.c:558
 tiocsetd drivers/tty/tty_io.c:2433 [inline]
 tty_ioctl+0xae0/0x15e0 drivers/tty/tty_io.c:2714
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f45150890e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f451621a168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f451519bf60 RCX: 00007f45150890e9
RDX: 0000000020000040 RSI: 0000000000005423 RDI: 0000000000000003
RBP: 00007f45150e308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe5344efcf R14: 00007f451621a300 R15: 0000000000022000
 </TASK>

Allocated by task 3043:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc_node include/linux/slab.h:604 [inline]
 kvmalloc_node+0x3e/0x190 mm/util.c:580
 kvmalloc include/linux/slab.h:731 [inline]
 kvzalloc include/linux/slab.h:739 [inline]
 alloc_netdev_mqs+0x98/0x1100 net/core/dev.c:10491
 sl_alloc drivers/net/slip/slip.c:756 [inline]
 slip_open+0x36d/0x11b0 drivers/net/slip/slip.c:817
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:433
 tty_set_ldisc+0x2f1/0x680 drivers/tty/tty_ldisc.c:558
 tiocsetd drivers/tty/tty_io.c:2433 [inline]
 tty_ioctl+0xae0/0x15e0 drivers/tty/tty_io.c:2714
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3034:
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
 kvfree+0x42/0x50 mm/util.c:622
 device_release+0x9f/0x240 drivers/base/core.c:2229
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 netdev_run_todo+0x72e/0x10b0 net/core/dev.c:10274
 slip_close+0x161/0x1c0 drivers/net/slip/slip.c:906
 tty_ldisc_close+0x110/0x190 drivers/tty/tty_ldisc.c:456
 tty_ldisc_kill+0x94/0x150 drivers/tty/tty_ldisc.c:608
 tty_ldisc_release+0xe1/0x2a0 drivers/tty/tty_ldisc.c:776
 tty_release_struct+0x20/0xe0 drivers/tty/tty_io.c:1694
 tty_release+0xc70/0x1200 drivers/tty/tty_io.c:1865
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888056ca8000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 3569 bytes inside of
 4096-byte region [ffff888056ca8000, ffff888056ca9000)

The buggy address belongs to the physical page:
page:ffffea00015b2a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x56ca8
head:ffffea00015b2a00 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff88801f47db01
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888010c4c280
raw: 0000000000000000 0000000000040004 00000001ffffffff ffff88801f47db01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 3884, tgid 3884 (udevd), ts 529533667679, free_ts 529460891996
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 __kmalloc_node+0x2cb/0x390 mm/slub.c:4458
 kmalloc_node include/linux/slab.h:604 [inline]
 kvmalloc_node+0x3e/0x190 mm/util.c:580
 kvmalloc include/linux/slab.h:731 [inline]
 seq_buf_alloc fs/seq_file.c:38 [inline]
 seq_read_iter+0x7f7/0x1280 fs/seq_file.c:210
 proc_reg_read_iter+0x1fb/0x2d0 fs/proc/inode.c:300
 call_read_iter include/linux/fs.h:2044 [inline]
 new_sync_read+0x384/0x5f0 fs/read_write.c:401
 vfs_read+0x492/0x5d0 fs/read_write.c:482
 ksys_read+0x127/0x250 fs/read_write.c:620
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2523
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:749 [inline]
 slab_alloc_node mm/slub.c:3217 [inline]
 slab_alloc mm/slub.c:3225 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3232 [inline]
 kmem_cache_alloc_lru+0x255/0x720 mm/slub.c:3249
 alloc_inode_sb include/linux/fs.h:2966 [inline]
 shmem_alloc_inode+0x23/0x50 mm/shmem.c:3722
 alloc_inode+0x61/0x230 fs/inode.c:260
 new_inode_pseudo fs/inode.c:1018 [inline]
 new_inode+0x27/0x2f0 fs/inode.c:1047
 shmem_get_inode+0x195/0xcd0 mm/shmem.c:2261
 shmem_mknod+0x5a/0x1f0 mm/shmem.c:2823
 lookup_open.isra.0+0x10cc/0x1690 fs/namei.c:3330
 open_last_lookups fs/namei.c:3400 [inline]
 path_openat+0x9a2/0x2910 fs/namei.c:3606
 do_filp_open+0x1aa/0x400 fs/namei.c:3636
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1213

Memory state around the buggy address:
 ffff888056ca8c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888056ca8d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888056ca8d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff888056ca8e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888056ca8e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
