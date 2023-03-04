Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753416AA851
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 07:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjCDG0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 01:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDG0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 01:26:53 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4151B25B93
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 22:26:51 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id b4-20020a92c844000000b00317983ace21so2533811ilq.6
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 22:26:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8b1/t8Nqjt+49ocjKAgJWd+UAu49XM23tOZbPtJ+WS4=;
        b=IhsgkmAs6/XWJDiaEX661Dkuc5KoEmaL192jyP+GPHl/G5UPgKpIDs1shMb0g4Zp4P
         q9Je/D70oJhJUubKdjnCs8SWxZsbS311R2wkVyWr3F10f258EQi49QrBGcYTQgGWZEBZ
         qOcvOf8jli6rEh5CuAXcCMZdG17gyqv/1RqoVrRChGIQew2v+yUfLJ3XF00wlS6Y8nJq
         Y3RKP5DlvG3Ki5tJO93l6JJz8H+03e56i7JK4KBxr7xJ7CdviFPTJJhHFL6eBaZYrSWE
         U4jjEOniSa25MVWersD25Zo2qIkcavvct7TbaClsk6G+snlukF44RCvcQhEfPwt+do5p
         tJzw==
X-Gm-Message-State: AO0yUKU/WjKOMYkL7uBVu1l/NSJj0QICaob4X1D0EzGeDuvgVYMfiEpQ
        8FJE0YAPBVCDOMOSVsuqqYYGtbhl6nutJvkLMr+kq7ThxgC2
X-Google-Smtp-Source: AK7set9CQ8z4oNv4G2Y3ici09DGsJT+UCgWrGetPv+TmPhKS/WqfKnJqBzmuJaUF3KlckmLLFPxuiGgUbbtIpDiu8yOqvqOxKxae
MIME-Version: 1.0
X-Received: by 2002:a05:6638:36ea:b0:3ec:46d4:e15 with SMTP id
 t42-20020a05663836ea00b003ec46d40e15mr3356235jau.3.1677911210494; Fri, 03 Mar
 2023 22:26:50 -0800 (PST)
Date:   Fri, 03 Mar 2023 22:26:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa920505f60d25ad@google.com>
Subject: [syzbot] [bluetooth?] KASAN: slab-use-after-free Read in hci_conn_hash_flush
From:   syzbot <syzbot+8bb72f86fc823817bc5d@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following issue on:

HEAD commit:    1acf39ef8f14 Add linux-next specific files for 20230303
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=115b8e38c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e4da7f0aef5d2eb8
dashboard link: https://syzkaller.appspot.com/bug?extid=8bb72f86fc823817bc5d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/721c5c42a073/disk-1acf39ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5ca5353e61a/vmlinux-1acf39ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/29f477775fe9/bzImage-1acf39ef.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bb72f86fc823817bc5d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in hci_conn_hash_flush+0x23c/0x260 net/bluetooth/hci_conn.c:2437
Read of size 8 at addr ffff88808d354000 by task syz-executor.1/6401

CPU: 1 PID: 6401 Comm: syz-executor.1 Not tainted 6.2.0-next-20230303-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
 print_report mm/kasan/report.c:430 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:536
 hci_conn_hash_flush+0x23c/0x260 net/bluetooth/hci_conn.c:2437
 hci_dev_close_sync+0x5fb/0x1200 net/bluetooth/hci_sync.c:4889
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x1ce/0x580 net/bluetooth/hci_core.c:2702
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb42/0x2b60 kernel/exit.c:869
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
 __do_sys_exit_group kernel/exit.c:1030 [inline]
 __se_sys_exit_group kernel/exit.c:1028 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1028
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fea0308c0f9
Code: Unable to access opcode bytes at 0x7fea0308c0cf.
RSP: 002b:00007fff14dbd268 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fff14dbd410 RCX: 00007fea0308c0f9
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000043
RBP: 0000000000000000 R08: 0000000000000025 R09: 00007fff14dbd410
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fea030e7aba
R13: 000000000000001c R14: 000000000000000f R15: 00007fff14dbd450
 </TASK>

Allocated by task 6988:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 hci_conn_add+0xb8/0x15c0 net/bluetooth/hci_conn.c:962
 hci_connect_sco+0x42c/0xac0 net/bluetooth/hci_conn.c:1607
 sco_connect net/bluetooth/sco.c:255 [inline]
 sco_sock_connect+0x350/0xa60 net/bluetooth/sco.c:598
 __sys_connect_file+0x153/0x1a0 net/socket.c:2004
 __sys_connect+0x165/0x1a0 net/socket.c:2021
 __do_sys_connect net/socket.c:2031 [inline]
 __se_sys_connect net/socket.c:2028 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2028
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 6401:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3800
 device_release+0xa3/0x240 drivers/base/core.c:2436
 kobject_cleanup lib/kobject.c:681 [inline]
 kobject_release lib/kobject.c:712 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c2/0x4d0 lib/kobject.c:729
 put_device+0x1f/0x30 drivers/base/core.c:3697
 hci_conn_del+0x212/0xa70 net/bluetooth/hci_conn.c:1112
 hci_conn_del+0x7df/0xa70 net/bluetooth/hci_conn.c:1071
 hci_conn_hash_flush+0x19b/0x260 net/bluetooth/hci_conn.c:2441
 hci_dev_close_sync+0x5fb/0x1200 net/bluetooth/hci_sync.c:4889
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x1ce/0x580 net/bluetooth/hci_core.c:2702
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb42/0x2b60 kernel/exit.c:869
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1019
 __do_sys_exit_group kernel/exit.c:1030 [inline]
 __se_sys_exit_group kernel/exit.c:1028 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1028
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 insert_work+0x48/0x350 kernel/workqueue.c:1361
 __queue_work+0x5fd/0x1170 kernel/workqueue.c:1524
 __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1672
 queue_delayed_work_on+0x109/0x120 kernel/workqueue.c:1708
 queue_delayed_work include/linux/workqueue.h:519 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1417 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1387 [inline]
 sco_chan_del+0x1f8/0x4f0 net/bluetooth/sco.c:169
 __sco_sock_close+0x178/0x740 net/bluetooth/sco.c:431
 sco_sock_close net/bluetooth/sco.c:446 [inline]
 sco_sock_release+0x81/0x360 net/bluetooth/sco.c:1254
 __sock_release+0xcd/0x290 net/socket.c:651
 sock_close+0x1c/0x20 net/socket.c:1393
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 get_signal+0x1c7/0x25b0 kernel/signal.c:2635
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88808d354000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes inside of
 freed 4096-byte region [ffff88808d354000, ffff88808d355000)

The buggy address belongs to the physical page:
page:ffffea000234d400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8d350
head:ffffea000234d400 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 5125, tgid 5125 (syz-executor.2), ts 331563645285, free_ts 0
 prep_new_page mm/page_alloc.c:2492 [inline]
 get_page_from_freelist+0xf75/0x2ad0 mm/page_alloc.c:4256
 __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5522
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2283
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x28e/0x380 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc+0x4a/0xd0 mm/slab_common.c:980
 kmalloc include/linux/slab.h:584 [inline]
 tomoyo_realpath_from_path+0xc3/0x600 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x22d/0x430 security/tomoyo/file.c:822
 security_inode_getattr+0xd3/0x140 security/security.c:1375
 vfs_getattr fs/stat.c:167 [inline]
 vfs_fstat+0x47/0xb0 fs/stat.c:192
 __do_sys_newfstat+0x7a/0xf0 fs/stat.c:456
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88808d353f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88808d353f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88808d354000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88808d354080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808d354100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
