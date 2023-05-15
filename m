Return-Path: <netdev+bounces-2647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF74702D06
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BC8E281323
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179B0C2D9;
	Mon, 15 May 2023 12:47:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE2379D4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:47:40 +0000 (UTC)
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0170E12A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:47:38 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-33539445684so303791235ab.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:47:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684154858; x=1686746858;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UzjPHYy1YH2B69CAuHHkDfM5nL26LpeVqCg+aXZtonM=;
        b=SA8Kt/KMwC7d5+raV0f2wGa26v2fvsS4EdKjMAv8Dd6cy+aTclY9DE5jogPF6/l1Xk
         xL+VkPFA4pinD0Snyf57XgLbHUCJoC0UwmtbrfaOMsrToZoEirKe13BUb0/oEwmDYB7f
         2xFU+Jc60ls20+HFJYp6dC4L9D2wc6gB+FE2Eosa6SYQDPaUmiiRfjz336p9mfMEQj9i
         Qkqzc3HrjSRbaQ/6bYhzmUmxFbuwsZS8E7PY6E0sXMb6XPXYkJvYhsBiq+05pDAnBKyf
         uRBfWWO4+9B/y/2xwtqKUd5RwSU/7tolIQXsabonlndaAPFyzg808o4ukfm908d33K+m
         hSXg==
X-Gm-Message-State: AC+VfDwklbJRsIsKsgKVoA09sK5o5RVSJeGDGFnQMbHszdr1J9CkloRP
	6vQwWeq9vY2JQG5w67kvVMrr//HBzNG+73rlFb+rPQyS8SkF
X-Google-Smtp-Source: ACHHUZ53ACMJVZgITuxniMs9kAf3gvISCmaij0AkKz+OjWJvx5RBdhNq0Zwf0PXGEjdsbbcY0IXaKlJasMtUg3XKX6DfqCIcSeLF
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d16:b0:763:b184:fe92 with SMTP id
 c22-20020a0566022d1600b00763b184fe92mr20328026iow.0.1684154858319; Mon, 15
 May 2023 05:47:38 -0700 (PDT)
Date: Mon, 15 May 2023 05:47:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000013b93805fbbadc50@google.com>
Subject: [syzbot] [bluetooth?] KASAN: slab-use-after-free Write in sco_chan_del
From: syzbot <syzbot+cf54c1da6574b6c1b049@syzkaller.appspotmail.com>
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

HEAD commit:    ed23734c23d2 Merge tag 'net-6.4-rc1' of git://git.kernel.o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16b2a3f4280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87f9126139666d37
dashboard link: https://syzkaller.appspot.com/bug?extid=cf54c1da6574b6c1b049
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c43e1732e675/disk-ed23734c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8f4e7bce7a91/vmlinux-ed23734c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9fe83b099e40/bzImage-ed23734c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf54c1da6574b6c1b049@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
BUG: KASAN: slab-use-after-free in atomic_dec_and_test include/linux/atomic/atomic-instrumented.h:575 [inline]
BUG: KASAN: slab-use-after-free in hci_conn_drop include/net/bluetooth/hci_core.h:1418 [inline]
BUG: KASAN: slab-use-after-free in sco_chan_del+0x102/0x4f0 net/bluetooth/sco.c:169
Write of size 4 at addr ffff88804dbea010 by task syz-executor.0/7018

CPU: 0 PID: 7018 Comm: syz-executor.0 Not tainted 6.3.0-syzkaller-13379-ged23734c23d2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 check_region_inline mm/kasan/generic.c:181 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:187
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_dec_and_test include/linux/atomic/atomic-instrumented.h:575 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1418 [inline]
 sco_chan_del+0x102/0x4f0 net/bluetooth/sco.c:169
 __sco_sock_close+0x178/0x740 net/bluetooth/sco.c:454
 sco_sock_close net/bluetooth/sco.c:469 [inline]
 sco_sock_release+0x81/0x360 net/bluetooth/sco.c:1267
 __sock_release+0xcd/0x290 net/socket.c:653
 sock_close+0x1c/0x20 net/socket.c:1397
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 get_signal+0x1c7/0x25b0 kernel/signal.c:2650
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7a97a8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7a965fe168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 00007f7a97babf80 RCX: 00007f7a97a8c169
RDX: 0000000000000008 RSI: 0000000020002ec0 RDI: 0000000000000004
RBP: 00007f7a97ae7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffca219560f R14: 00007f7a965fe300 R15: 0000000000022000
 </TASK>

Allocated by task 7018:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 hci_conn_add+0xb8/0x16b0 net/bluetooth/hci_conn.c:986
 hci_connect_sco+0x3c7/0x1050 net/bluetooth/hci_conn.c:1663
 sco_connect net/bluetooth/sco.c:264 [inline]
 sco_sock_connect+0x2d7/0xae0 net/bluetooth/sco.c:610
 __sys_connect_file+0x153/0x1a0 net/socket.c:2003
 __sys_connect+0x165/0x1a0 net/socket.c:2020
 __do_sys_connect net/socket.c:2030 [inline]
 __se_sys_connect net/socket.c:2027 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2027
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 5708:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3786 [inline]
 __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3799
 device_release+0xa3/0x240 drivers/base/core.c:2484
 kobject_cleanup lib/kobject.c:683 [inline]
 kobject_release lib/kobject.c:714 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c2/0x4d0 lib/kobject.c:731
 put_device+0x1f/0x30 drivers/base/core.c:3733
 hci_conn_del+0x1e5/0x950 net/bluetooth/hci_conn.c:1162
 hci_conn_unlink+0x2ce/0x460 net/bluetooth/hci_conn.c:1109
 hci_conn_unlink+0x362/0x460 net/bluetooth/hci_conn.c:1087
 hci_conn_hash_flush+0x19b/0x270 net/bluetooth/hci_conn.c:2479
 hci_dev_close_sync+0x5fb/0x1200 net/bluetooth/hci_sync.c:4941
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x1ce/0x580 net/bluetooth/hci_core.c:2703
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:669
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad3/0x2960 kernel/exit.c:871
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1021
 __do_sys_exit_group kernel/exit.c:1032 [inline]
 __se_sys_exit_group kernel/exit.c:1030 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1030
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88804dbea000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 16 bytes inside of
 freed 4096-byte region [ffff88804dbea000, ffff88804dbeb000)

The buggy address belongs to the physical page:
page:ffffea000136fa00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4dbe8
head:ffffea000136fa00 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 4456, tgid 4456 (udevd), ts 192360753903, free_ts 185030986834
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1731
 prep_new_page mm/page_alloc.c:1738 [inline]
 get_page_from_freelist+0xf41/0x2c00 mm/page_alloc.c:3502
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4768
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2279
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x390 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3192
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3291
 __slab_alloc_node mm/slub.c:3344 [inline]
 slab_alloc_node mm/slub.c:3441 [inline]
 __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3490
 kmalloc_trace+0x26/0xe0 mm/slab_common.c:1057
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 uevent_show+0x15d/0x380 drivers/base/core.c:2641
 dev_attr_show+0x4f/0xd0 drivers/base/core.c:2349
 sysfs_kf_seq_show+0x21d/0x430 fs/sysfs/file.c:59
 seq_read_iter+0x4f9/0x12d0 fs/seq_file.c:230
 kernfs_fop_read_iter+0x4ce/0x690 fs/kernfs/file.c:279
 call_read_iter include/linux/fs.h:1862 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x4b1/0x8a0 fs/read_write.c:470
 ksys_read+0x12b/0x250 fs/read_write.c:613
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2564
 free_unref_page+0x33/0x370 mm/page_alloc.c:2659
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2636
 qlink_free mm/kasan/quarantine.c:166 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slub.c:3451 [inline]
 __kmem_cache_alloc_node+0x17c/0x320 mm/slub.c:3490
 kmalloc_trace+0x26/0xe0 mm/slab_common.c:1057
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 is_state_visited kernel/bpf/verifier.c:15459 [inline]
 do_check kernel/bpf/verifier.c:15629 [inline]
 do_check_common+0x2845/0xc620 kernel/bpf/verifier.c:18215
 do_check_main kernel/bpf/verifier.c:18278 [inline]
 bpf_check+0x74aa/0xb010 kernel/bpf/verifier.c:18899
 bpf_prog_load+0x16d3/0x21f0 kernel/bpf/syscall.c:2648
 __sys_bpf+0x149f/0x5420 kernel/bpf/syscall.c:5058
 __do_sys_bpf kernel/bpf/syscall.c:5162 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5160 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5160
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88804dbe9f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88804dbe9f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88804dbea000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff88804dbea080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804dbea100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

