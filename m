Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4337956457E
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiGCHCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiGCHCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:02:23 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF865AF
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 00:02:21 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id n4-20020a5d8244000000b0067566682c09so4018427ioo.13
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 00:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YCaEkM3HdICacjQiuv8ERZIO67c8Cq3dSbpHJKI1BmA=;
        b=aozR88/vc2YYSbAc+qcJlUMt7yXtAsh0VQ0c6mC5sllvDf8he5/tZYMH0Yxf7ObXFS
         QXMu7/bklVjrwC6/uearM42Z+dQhRjnvPz3i2UZGSBRNH/bJg8HaraTYz1QBMlwBt/9K
         0K2duTAqOLOBrlm8q6GaCPLqehG61VlfAr8RPqA85/7+ekxrkwxkk0+/XHAVHlRie8Eq
         +IJY/zCDAYHfNG4lsqbmLA2HEa4nTLAQpqkNnJb7OrX6BBY6eWBRLIr9tk+grXFX8HK8
         VQBRYFi+KUUbvdNGUZgJfN7r1GFmNPz+WdPsYLkim/S0C17lKU8pbXNmvihCAOALJrGF
         oONA==
X-Gm-Message-State: AJIora8iruIsvtnuP1MSERP+hwrq1pppk24HKkwikAgH5ktu55mHom7F
        TxjvheV84I1C+37O8BO0k9tGMmsU9UCYkSwfs3W6sjkiFACv
X-Google-Smtp-Source: AGRyM1sW0Goh1i0p3k/+IR2Zdw8Uis3hkU96QVdx8vWIav3seczT10dGPRNunFYJZdQG5MCUART34VI2WuSgZ09+xvijOGKNPFDv
MIME-Version: 1.0
X-Received: by 2002:a02:a78c:0:b0:339:ed30:1a3e with SMTP id
 e12-20020a02a78c000000b00339ed301a3emr13854952jaj.0.1656831740859; Sun, 03
 Jul 2022 00:02:20 -0700 (PDT)
Date:   Sun, 03 Jul 2022 00:02:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ddbc405e2e133e7@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Write in ip6_mc_hdr
From:   syzbot <syzbot+a7f5cbe0f4682a059a8e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
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

HEAD commit:    d521bc0a0f7c Merge branch 'mlxsw-unified-bridge-conversion..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=119c8ae0080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3822ec9aaf800dfb
dashboard link: https://syzkaller.appspot.com/bug?extid=a7f5cbe0f4682a059a8e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c34c18080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fac6c0080000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11e69790080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13e69790080000
console output: https://syzkaller.appspot.com/x/log.txt?x=15e69790080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7f5cbe0f4682a059a8e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in ip6_flow_hdr include/net/ipv6.h:1007 [inline]
BUG: KASAN: slab-out-of-bounds in ip6_mc_hdr.constprop.0+0x4ec/0x5c0 net/ipv6/mcast.c:1715
Write of size 4 at addr ffff888023d32fe0 by task kworker/1:3/2939

CPU: 1 PID: 2939 Comm: kworker/1:3 Not tainted 5.19.0-rc3-syzkaller-00644-gd521bc0a0f7c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 ip6_flow_hdr include/net/ipv6.h:1007 [inline]
 ip6_mc_hdr.constprop.0+0x4ec/0x5c0 net/ipv6/mcast.c:1715
 mld_newpack.isra.0+0x3c0/0x770 net/ipv6/mcast.c:1763
 add_grhead+0x295/0x340 net/ipv6/mcast.c:1849
 add_grec+0x1082/0x1560 net/ipv6/mcast.c:1987
 mld_send_cr net/ipv6/mcast.c:2113 [inline]
 mld_ifc_work+0x452/0xdc0 net/ipv6/mcast.c:2651
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>

Allocated by task 2991:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 tomoyo_encode2.part.0+0xe9/0x3a0 security/tomoyo/realpath.c:45
 tomoyo_encode2 security/tomoyo/realpath.c:31 [inline]
 tomoyo_encode+0x28/0x50 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x186/0x620 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1344
 vfs_getattr fs/stat.c:157 [inline]
 vfs_statx+0x16a/0x390 fs/stat.c:232
 vfs_fstatat+0x8c/0xb0 fs/stat.c:255
 __do_sys_newfstatat+0x91/0x110 fs/stat.c:425
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff888023d32f80
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 32 bytes to the right of
 64-byte region [ffff888023d32f80, ffff888023d32fc0)

The buggy address belongs to the physical page:
page:ffffea00008f4c80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x23d32
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000097dec0 dead000000000003 ffff888011841640
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 47, tgid 47 (kworker/u4:3), ts 9452910565, free_ts 9450274699
 prep_new_page mm/page_alloc.c:2456 [inline]
 get_page_from_freelist+0x1290/0x3b70 mm/page_alloc.c:4198
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1824 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1969
 new_slab mm/slub.c:2029 [inline]
 ___slab_alloc+0x9c4/0xe20 mm/slub.c:3031
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
 slab_alloc_node mm/slub.c:3209 [inline]
 __kmalloc_node+0x2cb/0x390 mm/slub.c:4490
 kmalloc_node include/linux/slab.h:623 [inline]
 __vmalloc_area_node mm/vmalloc.c:2981 [inline]
 __vmalloc_node_range+0xa40/0x13e0 mm/vmalloc.c:3165
 alloc_thread_stack_node kernel/fork.c:312 [inline]
 dup_task_struct kernel/fork.c:977 [inline]
 copy_process+0x156e/0x7020 kernel/fork.c:2071
 kernel_clone+0xe7/0xab0 kernel/fork.c:2655
 user_mode_thread+0xad/0xe0 kernel/fork.c:2724
 call_usermodehelper_exec_work kernel/umh.c:174 [inline]
 call_usermodehelper_exec_work+0xcc/0x180 kernel/umh.c:160
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1371 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1421
 free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3438
 __vunmap+0x85d/0xd30 mm/vmalloc.c:2665
 free_work+0x58/0x70 mm/vmalloc.c:97
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302

Memory state around the buggy address:
 ffff888023d32e80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff888023d32f00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff888023d32f80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
                                                       ^
 ffff888023d33000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888023d33080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
