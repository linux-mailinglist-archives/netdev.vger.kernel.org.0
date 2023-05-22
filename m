Return-Path: <netdev+bounces-4141-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14B3870B4B1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D9BC280E58
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 05:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B66440C;
	Mon, 22 May 2023 05:51:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A741FBF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:51:06 +0000 (UTC)
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A389DC
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 22:51:03 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-76c3e89c73aso208675439f.1
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 22:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684734662; x=1687326662;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sJ3ECm/S1WpNy1KYNnmDuPolLtz5d+MdB+RcH96oAqU=;
        b=eLrOzV3WMD6lEGJqG+Xzcf/r2Cv19iIX9GiNxmIP4Sm0BKUU3j7efNaOAnBznqM4ty
         aI3LJYetYFVhMOYr+te6HEIMmoLpHn99dNbDbRoLKLzXRSl8zpfpfVlcIcmOSJK/H1Ky
         7wb2vmAiyD12doJNJmGQf2H0Y/Kgu3akSIGFPtwhTRO0Kc3oZYIU1YYCo3HV0etH5X6k
         QlrsJwFfEI1CIjhsDfmRQ2bPnEL58PlOvirE+spmUpgDqikM2Ku/UpN6ynj7d+ZxqBEj
         LJJCySeQ4frcDiiEDFLd68vE0SjXJ8ZC5l+WmReMlIvCbtAqMogH2gGeWBdijfK1STiZ
         6wwQ==
X-Gm-Message-State: AC+VfDxojc4fa8RrQnVTpk3v0as9t3LTsKKtluhT7QnYgPwz37XnMoY/
	FnOOLWw+3daOdUZqrxX+shkCYDPh2QTAxPRcfLhNa2eJbFeP
X-Google-Smtp-Source: ACHHUZ5XGgt+7ySAB+FUoutFLfdWg3yxw/lAJDrDet94dqoqRFVdkZyMPDAc5M/7hlrlF+6P3BNj5nQBgDyQd8+LEcNzsVUOyHnN
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:23ca:0:b0:40f:d6c5:2059 with SMTP id
 u193-20020a0223ca000000b0040fd6c52059mr4940956jau.6.1684734662651; Sun, 21
 May 2023 22:51:02 -0700 (PDT)
Date: Sun, 21 May 2023 22:51:02 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001bb75a05fc41db40@google.com>
Subject: [syzbot] [bluetooth?] KASAN: slab-use-after-free Write in hci_conn_drop
From: syzbot <syzbot+21835970af93643f25a2@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com, 
	kuba@kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luiz.dentz@gmail.com, marcel@holtmann.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    1b66c114d161 Merge tag 'nfsd-6.4-1' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=157d87ce280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94af80bb8ddd23c4
dashboard link: https://syzkaller.appspot.com/bug?extid=21835970af93643f25a2
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f5d99e318272/disk-1b66c114.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2cdf457bc2a6/vmlinux-1b66c114.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a5d135c04826/bzImage-1b66c114.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+21835970af93643f25a2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
BUG: KASAN: slab-use-after-free in atomic_dec_and_test include/linux/atomic/atomic-instrumented.h:575 [inline]
BUG: KASAN: slab-use-after-free in hci_conn_drop+0x34/0x2c0 include/net/bluetooth/hci_core.h:1418
Write of size 4 at addr ffff8880406a6010 by task syz-executor.1/7637

CPU: 0 PID: 7637 Comm: syz-executor.1 Not tainted 6.4.0-rc2-syzkaller-00015-g1b66c114d161 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:351 [inline]
 print_report+0x163/0x540 mm/kasan/report.c:462
 kasan_report+0x176/0x1b0 mm/kasan/report.c:572
 kasan_check_range+0x283/0x290 mm/kasan/generic.c:187
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_dec_and_test include/linux/atomic/atomic-instrumented.h:575 [inline]
 hci_conn_drop+0x34/0x2c0 include/net/bluetooth/hci_core.h:1418
 sco_chan_del+0xeb/0x1d0 net/bluetooth/sco.c:169
 sco_sock_close net/bluetooth/sco.c:469 [inline]
 sco_sock_release+0xb3/0x320 net/bluetooth/sco.c:1267
 __sock_release net/socket.c:653 [inline]
 sock_close+0xd1/0x230 net/socket.c:1397
 __fput+0x3b7/0x890 fs/file_table.c:321
 task_work_run+0x24a/0x300 kernel/task_work.c:179
 get_signal+0x1606/0x17e0 kernel/signal.c:2650
 arch_do_signal_or_restart+0x91/0x670 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop+0x6a/0x100 kernel/entry/common.c:168
 exit_to_user_mode_prepare+0xb1/0x140 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x64/0x280 kernel/entry/common.c:297
 do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f632188c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f63225fc168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 00007f63219abf80 RCX: 00007f632188c169
RDX: 0000000000000008 RSI: 0000000020000100 RDI: 0000000000000004
RBP: 00007f63218e7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff7261be3f R14: 00007f63225fc300 R15: 0000000000022000
 </TASK>

Allocated by task 7519:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4f/0x70 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 hci_conn_add+0xc3/0x13a0 net/bluetooth/hci_conn.c:986
 hci_connect_sco+0x8e/0x2b0 net/bluetooth/hci_conn.c:1663
 sco_connect net/bluetooth/sco.c:264 [inline]
 sco_sock_connect+0x2b9/0x990 net/bluetooth/sco.c:610
 __sys_connect_file net/socket.c:2003 [inline]
 __sys_connect+0x2cd/0x300 net/socket.c:2020
 __do_sys_connect net/socket.c:2030 [inline]
 __se_sys_connect net/socket.c:2027 [inline]
 __x64_sys_connect+0x7a/0x90 net/socket.c:2027
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 7110:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4f/0x70 mm/kasan/common.c:52
 kasan_save_free_info+0x2b/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free+0xd6/0x120 mm/kasan/common.c:236
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook mm/slub.c:1807 [inline]
 slab_free mm/slub.c:3786 [inline]
 __kmem_cache_free+0x264/0x3c0 mm/slub.c:3799
 device_release+0x95/0x1c0
 kobject_cleanup lib/kobject.c:683 [inline]
 kobject_release lib/kobject.c:714 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x228/0x470 lib/kobject.c:731
 hci_conn_del+0x321/0x5a0 net/bluetooth/hci_conn.c:1162
 hci_conn_unlink+0x1e1/0x320 net/bluetooth/hci_conn.c:1087
 hci_conn_hash_flush+0x198/0x220 net/bluetooth/hci_conn.c:2479
 hci_dev_close_sync+0xa35/0x1020 net/bluetooth/hci_sync.c:4941
 hci_dev_do_close net/bluetooth/hci_core.c:554 [inline]
 hci_unregister_dev+0x1ca/0x480 net/bluetooth/hci_core.c:2703
 vhci_release+0x83/0xd0 drivers/bluetooth/hci_vhci.c:669
 __fput+0x3b7/0x890 fs/file_table.c:321
 task_work_run+0x24a/0x300 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x68f/0x2290 kernel/exit.c:871
 do_group_exit+0x206/0x2c0 kernel/exit.c:1021
 get_signal+0x1701/0x17e0 kernel/signal.c:2874
 arch_do_signal_or_restart+0x91/0x670 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop+0x6a/0x100 kernel/entry/common.c:168
 exit_to_user_mode_prepare+0xb1/0x140 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x64/0x280 kernel/entry/common.c:297
 do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xb0/0xc0 mm/kasan/generic.c:491
 insert_work+0x54/0x3d0 kernel/workqueue.c:1365
 __queue_work+0xb37/0xf10 kernel/workqueue.c:1526
 queue_delayed_work_on+0x15a/0x260 kernel/workqueue.c:1710
 sco_chan_del+0xeb/0x1d0 net/bluetooth/sco.c:169
 sco_sock_close net/bluetooth/sco.c:469 [inline]
 sco_sock_release+0xb3/0x320 net/bluetooth/sco.c:1267
 __sock_release net/socket.c:653 [inline]
 sock_close+0xd1/0x230 net/socket.c:1397
 __fput+0x3b7/0x890 fs/file_table.c:321
 task_work_run+0x24a/0x300 kernel/task_work.c:179
 get_signal+0x1606/0x17e0 kernel/signal.c:2650
 arch_do_signal_or_restart+0x91/0x670 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop+0x6a/0x100 kernel/entry/common.c:168
 exit_to_user_mode_prepare+0xb1/0x140 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x64/0x280 kernel/entry/common.c:297
 do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff8880406a6000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 16 bytes inside of
 freed 4096-byte region [ffff8880406a6000, ffff8880406a7000)

The buggy address belongs to the physical page:
page:ffffea000101a800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x406a0
head:ffffea000101a800 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 ffffea0000a14a00 dead000000000002
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 6060, tgid 6060 (udevadm), ts 248100761058, free_ts 248068222302
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x1e6/0x210 mm/page_alloc.c:1731
 prep_new_page mm/page_alloc.c:1738 [inline]
 get_page_from_freelist+0x321c/0x33a0 mm/page_alloc.c:3502
 __alloc_pages+0x255/0x670 mm/page_alloc.c:4768
 alloc_slab_page+0x6a/0x160 mm/slub.c:1851
 allocate_slab mm/slub.c:1998 [inline]
 new_slab+0x84/0x2f0 mm/slub.c:2051
 ___slab_alloc+0xa85/0x10a0 mm/slub.c:3192
 __slab_alloc mm/slub.c:3291 [inline]
 __slab_alloc_node mm/slub.c:3344 [inline]
 slab_alloc_node mm/slub.c:3441 [inline]
 __kmem_cache_alloc_node+0x1b8/0x290 mm/slub.c:3490
 __do_kmalloc_node mm/slab_common.c:965 [inline]
 __kmalloc+0xa8/0x230 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 tomoyo_realpath_from_path+0xcf/0x5e0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x254/0x4e0 security/tomoyo/file.c:771
 security_file_open+0x63/0xa0 security/security.c:2797
 do_dentry_open+0x308/0x10f0 fs/open.c:907
 do_open fs/namei.c:3636 [inline]
 path_openat+0x27b3/0x3170 fs/namei.c:3791
 do_filp_open+0x234/0x490 fs/namei.c:3818
 do_sys_openat2+0x13f/0x500 fs/open.c:1356
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x247/0x290 fs/open.c:1383
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x903/0xa30 mm/page_alloc.c:2564
 free_unref_page+0x37/0x3f0 mm/page_alloc.c:2659
 discard_slab mm/slub.c:2097 [inline]
 __unfreeze_partials+0x1b1/0x1f0 mm/slub.c:2636
 put_cpu_partial+0x116/0x180 mm/slub.c:2712
 qlist_free_all+0x22/0x60 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x14b/0x160 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x23/0x70 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook+0x68/0x3a0 mm/slab.h:711
 slab_alloc_node mm/slub.c:3451 [inline]
 __kmem_cache_alloc_node+0x14c/0x290 mm/slub.c:3490
 kmalloc_trace+0x2a/0xe0 mm/slab_common.c:1057
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 kernfs_iop_get_link+0x67/0x5a0 fs/kernfs/symlink.c:135
 vfs_readlink+0x16e/0x400 fs/namei.c:5098
 do_readlinkat+0x283/0x3b0 fs/stat.c:489
 __do_sys_readlink fs/stat.c:510 [inline]
 __se_sys_readlink fs/stat.c:507 [inline]
 __x64_sys_readlink+0x7f/0x90 fs/stat.c:507
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff8880406a5f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880406a5f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880406a6000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880406a6080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880406a6100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

