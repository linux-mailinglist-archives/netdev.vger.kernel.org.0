Return-Path: <netdev+bounces-6261-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBAD7156C1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC058280F8B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2019B111BE;
	Tue, 30 May 2023 07:30:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B75E11189
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:30:12 +0000 (UTC)
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A436E72
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:30:06 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-76c6c1b16d2so614575039f.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685431805; x=1688023805;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i7CtQzI0l5t/OOEyepWkdX8Kt74wz/sHmbzRJBgYb20=;
        b=YdI5Blw8ZWUqyGzagUrsPGGZXYtJNBBEhzQiYwfcmTcrJw29mbNWzmbi84AMmPxGFl
         F4qqCMjqkR9Cl/bfepsHSedibaRBgSKTcWvIMwD2NUYiRhCV8cqCA/GIohbhQtA+RFh5
         H86EyZ8WqRBrxlxxU6dbSUZBvLPMgxt7tGQXlXeacyNf6AGjBgdbeDIPMzQRCyqLgsbn
         KKpFmpyfoZNC0LKxU+eDvo7EdKlYIlw1KA22+h7LhIniNio3iqkXHUl0lnuUV5su3XT9
         l9EwCZoCl8KdH46Bk3Dz1Y3L93zVFwKeXoX/KeM1A/RCqtsQBTl3r62h6Uj6e++gPVlL
         08NA==
X-Gm-Message-State: AC+VfDxRpQFUg57KrXR+3AWxBxJ4EUVNU63A7hRi3hfkwSV+b9NqMjUA
	xS4NhU0wrpCCwZSfHP9yYYWAO0QdME9p6UMwEfH7wwhWbEWk
X-Google-Smtp-Source: ACHHUZ4mCwrPxMk9inZVApufbGOcXZZ2CO9smFEWxdu7I/4/bLxtsQW4DyK5AbVSMhrnSrwW+5AALU03bJxTE+vnERrnT3sJSCTP
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:62ce:0:b0:41a:902f:70d0 with SMTP id
 d197-20020a0262ce000000b0041a902f70d0mr681957jac.6.1685431805805; Tue, 30 May
 2023 00:30:05 -0700 (PDT)
Date: Tue, 30 May 2023 00:30:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000140b1405fce42c66@google.com>
Subject: [syzbot] [bluetooth?] KASAN: slab-use-after-free Write in sco_conn_del
From: syzbot <syzbot+6b9277cad941daf126a2@syzkaller.appspotmail.com>
To: johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luiz.dentz@gmail.com, marcel@holtmann.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    878ecb0897f4 ipv6: Fix out-of-bounds access in ipv6_find_t..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17fc501e280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9afc9b1b9107cdcd
dashboard link: https://syzkaller.appspot.com/bug?extid=6b9277cad941daf126a2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4f18f9fc3e6b/disk-878ecb08.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe938cc7c36c/vmlinux-878ecb08.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2ae8899a247a/bzImage-878ecb08.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6b9277cad941daf126a2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
BUG: KASAN: slab-use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
BUG: KASAN: slab-use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: slab-use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: slab-use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: slab-use-after-free in sock_hold include/net/sock.h:775 [inline]
BUG: KASAN: slab-use-after-free in sco_conn_del+0xb9/0x2b0 net/bluetooth/sco.c:193
Write of size 4 at addr ffff88807c764080 by task syz-executor.0/21878

CPU: 1 PID: 21878 Comm: syz-executor.0 Not tainted 6.4.0-rc2-syzkaller-00209-g878ecb0897f4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/16/2023
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
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:775 [inline]
 sco_conn_del+0xb9/0x2b0 net/bluetooth/sco.c:193
 sco_disconn_cfm+0x75/0xb0 net/bluetooth/sco.c:1392
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1834 [inline]
 hci_conn_hash_flush+0x114/0x230 net/bluetooth/hci_conn.c:2484
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
RIP: 0033:0x7fa76928c169
Code: Unable to access opcode bytes at 0x7fa76928c13f.
RSP: 002b:00007ffc9f4c2fb8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000029 RCX: 00007fa76928c169
RDX: 00007fa76928d7ba RSI: 0000000000000000 RDI: 0000000000000007
RBP: 0000000000000007 R08: ff78736871746264 R09: 0000000000000029
R10: 00000000000003b8 R11: 0000000000000246 R12: 00007ffc9f4c3630
R13: 0000000000000003 R14: 00007ffc9f4c35cc R15: 00007fa769386660
 </TASK>

Allocated by task 1079:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kasan_kmalloc include/linux/kasan.h:196 [inline]
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc_node_track_caller+0x5f/0x1a0 mm/slab_common.c:986
 kmalloc_reserve+0xf0/0x270 net/core/skbuff.c:585
 pskb_expand_head+0x237/0x1170 net/core/skbuff.c:2054
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1321
 netlink_broadcast+0x63/0xd90 net/netlink/af_netlink.c:1517
 nlmsg_multicast include/net/netlink.h:1083 [inline]
 nlmsg_notify+0x93/0x280 net/netlink/af_netlink.c:2589
 rtnl_notify net/core/rtnetlink.c:771 [inline]
 rtmsg_ifinfo_send net/core/rtnetlink.c:4016 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:4032 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:4019 [inline]
 rtmsg_ifinfo+0x16e/0x1a0 net/core/rtnetlink.c:4038
 __dev_notify_flags+0x240/0x2d0 net/core/dev.c:8601
 rtnl_configure_link+0x181/0x260 net/core/rtnetlink.c:3273
 veth_newlink+0x446/0x9d0 drivers/net/veth.c:1909
 rtnl_newlink_create net/core/rtnetlink.c:3443 [inline]
 __rtnl_newlink+0x10c2/0x1840 net/core/rtnetlink.c:3660
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3673
 rtnetlink_rcv_msg+0x43d/0xd50 net/core/rtnetlink.c:6395
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2546
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 __sys_sendto+0x23a/0x340 net/socket.c:2144
 __do_sys_sendto net/socket.c:2156 [inline]
 __se_sys_sendto net/socket.c:2152 [inline]
 __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2152
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 __call_rcu_common.constprop.0+0x99/0x7e0 kernel/rcu/tree.c:2627
 netlink_release+0xcde/0x1e40 net/netlink/af_netlink.c:828
 __sock_release+0xcd/0x290 net/socket.c:653
 sock_close+0x1c/0x20 net/socket.c:1397
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad3/0x2960 kernel/exit.c:871
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1021
 get_signal+0x2315/0x25b0 kernel/signal.c:2874
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 __call_rcu_common.constprop.0+0x99/0x7e0 kernel/rcu/tree.c:2627
 netlink_release+0xcde/0x1e40 net/netlink/af_netlink.c:828
 __sock_release+0xcd/0x290 net/socket.c:653
 sock_close+0x1c/0x20 net/socket.c:1397
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807c764000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 freed 2048-byte region [ffff88807c764000, ffff88807c764800)

The buggy address belongs to the physical page:
page:ffffea0001f1d800 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88807c767000 pfn:0x7c760
head:ffffea0001f1d800 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442000 ffffea00012ef410 ffffea0000ab4010
raw: ffff88807c767000 0000000000080001 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5035, tgid 5035 (syz-executor.4), ts 168058722686, free_ts 163150710676
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
 __do_kmalloc_node mm/slab_common.c:965 [inline]
 __kmalloc_node_track_caller+0x4f/0x1a0 mm/slab_common.c:986
 kmalloc_reserve+0xf0/0x270 net/core/skbuff.c:585
 pskb_expand_head+0x237/0x1170 net/core/skbuff.c:2054
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1321
 netlink_broadcast+0x63/0xd90 net/netlink/af_netlink.c:1517
 nlmsg_multicast include/net/netlink.h:1083 [inline]
 nlmsg_notify+0x93/0x280 net/netlink/af_netlink.c:2589
 rtnl_notify net/core/rtnetlink.c:771 [inline]
 rtmsg_ifinfo_send net/core/rtnetlink.c:4016 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:4032 [inline]
 rtmsg_ifinfo_event net/core/rtnetlink.c:4019 [inline]
 rtmsg_ifinfo+0x16e/0x1a0 net/core/rtnetlink.c:4038
 __dev_notify_flags+0x240/0x2d0 net/core/dev.c:8601
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
 kmem_cache_alloc_node+0x185/0x3e0 mm/slub.c:3496
 __alloc_skb+0x288/0x330 net/core/skbuff.c:644
 alloc_skb_fclone include/linux/skbuff.h:1338 [inline]
 tcp_stream_alloc_skb+0x3c/0x580 net/ipv4/tcp.c:866
 tcp_sendmsg_locked+0xc47/0x2960 net/ipv4/tcp.c:1329
 tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1487
 inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:825
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 sock_write_iter+0x295/0x3d0 net/socket.c:1140
 call_write_iter include/linux/fs.h:1868 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x945/0xd50 fs/read_write.c:584
 ksys_write+0x1ec/0x250 fs/read_write.c:637

Memory state around the buggy address:
 ffff88807c763f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807c764000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807c764080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88807c764100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807c764180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

