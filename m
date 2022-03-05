Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5374CE427
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 11:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiCEKWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 05:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiCEKWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 05:22:22 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18407DF49C
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 02:21:33 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id k10-20020a5d91ca000000b006414a00b160so7078626ior.18
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 02:21:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=laeKQbwz18o46JsX34j9AJLRVYZviS81haUzKvgxr1M=;
        b=7EvXyiTqZJTvdLESwi/a249Cad4FAU4jGqENYDqQ8XzCEE9gKgYi6le+mbACYV6QOI
         swQxUi624SwsL35/W7MkwNVRiV8EK4GPMF1JZ3e/KJPDiFpBG5RJi6rqkk/af06X3icH
         3eA06uCGgTve83dOpHSIehY/Ei2M0vnDlPUtJOwqxrBDAl1JlEAbzKx1XY44ON4pYOU/
         N8Le2MW+AbuCtUdErXfA+iKMNSHVqN13ronBm9q7fvsGWP2z7Mf1fLGTokhI2vNOReMt
         jqh4bt0usane5AfszVDBqiy42pwyX7AsjLbCoaYr12+PPjqXxSHknvID7gptMnuN7URf
         B/lA==
X-Gm-Message-State: AOAM530ufOkdmNOEKenXSjo0XS1x1D09sH9LJ04CCXwt+FVXRW4lV2aB
        MJ9cWNBSuDTWjWbGcKcBl/ax17bhRoat/MVOvN/XZYfyV5zC
X-Google-Smtp-Source: ABdhPJxEQYJ0dXKyi+MDAVrc+kCtSvcbz7hRszVne3I6ZVQ8Ni68aA9CA2V2VbhMPyUOlOrlHKhRvpgthQYNOaj1mr8i4FIwg5nh
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a88:b0:2be:a472:90d9 with SMTP id
 k8-20020a056e021a8800b002bea47290d9mr2878255ilv.239.1646475692477; Sat, 05
 Mar 2022 02:21:32 -0800 (PST)
Date:   Sat, 05 Mar 2022 02:21:32 -0800
In-Reply-To: <00000000000013ca8105d7ae3ada@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c813bd05d975feed@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in smc_fback_error_report
From:   syzbot <syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, guwen@linux.alibaba.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    07ebd38a0da2 Merge tag 'riscv-for-linus-5.17-rc7' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=111f4842700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=542b2708133cc492
dashboard link: https://syzkaller.appspot.com/bug?extid=b425899ed22c6943e00b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172150ee700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1447485e700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in smc_fback_error_report+0x96/0xa0 net/smc/af_smc.c:670
Read of size 8 at addr ffff888078172628 by task syz-executor750/23402

CPU: 0 PID: 23402 Comm: syz-executor750 Not tainted 5.17.0-rc6-syzkaller-00226-g07ebd38a0da2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 smc_fback_error_report+0x96/0xa0 net/smc/af_smc.c:670
 sk_error_report+0x35/0x310 net/core/sock.c:340
 tcp_write_err net/ipv4/tcp_timer.c:71 [inline]
 tcp_write_timeout net/ipv4/tcp_timer.c:276 [inline]
 tcp_retransmit_timer+0x20c2/0x3320 net/ipv4/tcp_timer.c:512
 tcp_write_timer_handler+0x5e6/0xbc0 net/ipv4/tcp_timer.c:622
 tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 do_softirq.part.0+0xde/0x130 kernel/softirq.c:459
 </IRQ>
 <TASK>
 do_softirq kernel/softirq.c:451 [inline]
 __local_bh_enable_ip+0x102/0x120 kernel/softirq.c:383
 spin_unlock_bh include/linux/spinlock.h:394 [inline]
 __inet_hash_connect+0x85e/0x1190 net/ipv4/inet_hashtables.c:812
 tcp_v4_connect+0xe33/0x1c80 net/ipv4/tcp_ipv4.c:275
 __inet_stream_connect+0x8cf/0xed0 net/ipv4/af_inet.c:660
 inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:724
 smc_connect+0x22f/0x440 net/smc/af_smc.c:1414
 __sys_connect_file+0x155/0x1a0 net/socket.c:1900
 __sys_connect+0x161/0x190 net/socket.c:1917
 __do_sys_connect net/socket.c:1927 [inline]
 __se_sys_connect net/socket.c:1924 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd9e12ade49
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe002431b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00000000000e359a RCX: 00007fd9e12ade49
RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 0000000000000000 R08: 00007ffe00243358 R09: 00007ffe00243358
R10: 0000000000000004 R11: 0000000000000246 R12: 00007ffe002431cc
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Allocated by task 22537:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 kasan_kmalloc include/linux/kasan.h:270 [inline]
 __do_kmalloc mm/slab.c:3694 [inline]
 __kmalloc+0x209/0x4d0 mm/slab.c:3703
 kmalloc include/linux/slab.h:586 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:311 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:306
 security_file_open+0x45/0xb0 security/security.c:1638
 do_dentry_open+0x358/0x1250 fs/open.c:811
 do_open fs/namei.c:3476 [inline]
 path_openat+0x1c9e/0x2940 fs/namei.c:3609
 do_filp_open+0x1aa/0x400 fs/namei.c:3636
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1214
 do_sys_open fs/open.c:1230 [inline]
 __do_sys_openat fs/open.c:1246 [inline]
 __se_sys_openat fs/open.c:1241 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1241
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 22537:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 __cache_free mm/slab.c:3437 [inline]
 kfree+0xf8/0x2b0 mm/slab.c:3794
 tomoyo_realpath_from_path+0x191/0x620 security/tomoyo/realpath.c:291
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:311 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:306
 security_file_open+0x45/0xb0 security/security.c:1638
 do_dentry_open+0x358/0x1250 fs/open.c:811
 do_open fs/namei.c:3476 [inline]
 path_openat+0x1c9e/0x2940 fs/namei.c:3609
 do_filp_open+0x1aa/0x400 fs/namei.c:3636
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1214
 do_sys_open fs/open.c:1230 [inline]
 __do_sys_openat fs/open.c:1246 [inline]
 __se_sys_openat fs/open.c:1241 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1241
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888078172000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1576 bytes inside of
 4096-byte region [ffff888078172000, ffff888078173000)
The buggy address belongs to the page:
page:ffffea0001e05c80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x78172
head:ffffea0001e05c80 order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001d3ef08 ffffea000073db88 ffff888010c40900
raw: 0000000000000000 ffff888078172000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0x242040(__GFP_IO|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 22537, ts 926394890024, free_ts 926289131271
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 __alloc_pages_node include/linux/gfp.h:572 [inline]
 kmem_getpages mm/slab.c:1378 [inline]
 cache_grow_begin+0x75/0x390 mm/slab.c:2584
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2957
 ____cache_alloc mm/slab.c:3040 [inline]
 ____cache_alloc mm/slab.c:3023 [inline]
 __do_cache_alloc mm/slab.c:3267 [inline]
 slab_alloc mm/slab.c:3308 [inline]
 __do_kmalloc mm/slab.c:3692 [inline]
 __kmalloc+0x3b3/0x4d0 mm/slab.c:3703
 kmalloc include/linux/slab.h:586 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:311 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:306
 security_file_open+0x45/0xb0 security/security.c:1638
 do_dentry_open+0x358/0x1250 fs/open.c:811
 do_open fs/namei.c:3476 [inline]
 path_openat+0x1c9e/0x2940 fs/namei.c:3609
 do_filp_open+0x1aa/0x400 fs/namei.c:3636
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1214
 do_sys_open fs/open.c:1230 [inline]
 __do_sys_openat fs/open.c:1246 [inline]
 __se_sys_openat fs/open.c:1241 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1241
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 slab_destroy mm/slab.c:1630 [inline]
 slabs_destroy+0x89/0xc0 mm/slab.c:1650
 cache_flusharray mm/slab.c:3410 [inline]
 ___cache_free+0x303/0x600 mm/slab.c:3472
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x50/0x1a0 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0x97/0xb0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc mm/slab.c:3315 [inline]
 kmem_cache_alloc+0x265/0x560 mm/slab.c:3499
 ptlock_alloc+0x1d/0x70 mm/memory.c:5467
 ptlock_init include/linux/mm.h:2300 [inline]
 pgtable_pte_page_ctor include/linux/mm.h:2327 [inline]
 __pte_alloc_one include/asm-generic/pgalloc.h:66 [inline]
 pte_alloc_one+0x68/0x230 arch/x86/mm/pgtable.c:33
 __pte_alloc+0x69/0x250 mm/memory.c:465
 do_anonymous_page mm/memory.c:3747 [inline]
 handle_pte_fault mm/memory.c:4568 [inline]
 __handle_mm_fault+0x5006/0x5110 mm/memory.c:4705
 handle_mm_fault+0x1c8/0x790 mm/memory.c:4803
 do_user_addr_fault+0x489/0x11c0 arch/x86/mm/fault.c:1397
 handle_page_fault arch/x86/mm/fault.c:1484 [inline]
 exc_page_fault+0x9e/0x180 arch/x86/mm/fault.c:1540
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:568

Memory state around the buggy address:
 ffff888078172500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888078172580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888078172600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff888078172680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888078172700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

