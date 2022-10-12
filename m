Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768C95FC595
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJLMqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJLMqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:46:51 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDFFB601B
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 05:46:49 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id f25-20020a5d8799000000b006a44e33ddb6so11169809ion.1
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 05:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WtbicVhKrfraQtYDLCGtzSoEs+9T+vRt8gDn+itRy+U=;
        b=yVIeUa54wdK6HMkmmRKRf6ab8XOm9RLEe7zFr494lifBfJ8B5p9oN4rQhVyh9IlGsv
         kOK4YuUAoXAwH4Rs4KPSCMT/vRIzY5718pjp4UDUyPRRvXSb89MHCCMD3nH/zvUnw9Cg
         ERkEZc1b0yjOvwACPYiDA2I7X+/lXGxp6qWCt+cE/sOijJkGH7Ao1sLXu9H8jRuEyi7E
         v7oVP27BhDw89nK0kX0TbkqJsw8K+fRk0g731Lx3Gd55apNgafu4TTghwme0TZdl7AH4
         ByDCSKdhXEGpLiAfJZPDlPcqqalACxazsvKXLZIMVZ2g8/33St7jTFAlWhIz522eaNhY
         FXJA==
X-Gm-Message-State: ACrzQf1afE5iDFHlWeczZZxTy6eYvwKNPawWr3ikaxd5+uYaWto5/h6m
        t/SHQJgxFW1LZDDLp+cZb/F6stojj4LEpVOabAJS3flSlqmx
X-Google-Smtp-Source: AMsMyM4RNi7oNTOjNF5beRuTdCcsQ5zF7juQG94xBXB6bZxYnYcCc/P1RB/6tx7H7R7MIy6Ug+d1q14S0JroSt6+CiIC/3djgwaW
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:bef:b0:2f9:889b:6db6 with SMTP id
 d15-20020a056e020bef00b002f9889b6db6mr14888198ilu.281.1665578809313; Wed, 12
 Oct 2022 05:46:49 -0700 (PDT)
Date:   Wed, 12 Oct 2022 05:46:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004655fa05ead5c9f6@google.com>
Subject: [syzbot] KASAN: use-after-free Read in register_shrinker
From:   syzbot <syzbot+12320e263831dd4ddb91@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2e30960097f6 bpf, x64: Remove unnecessary check on existen..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15934fbc880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=796b7c2847a6866a
dashboard link: https://syzkaller.appspot.com/bug?extid=12320e263831dd4ddb91
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1055b15c880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1018112a880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f0f073bdb6eb/disk-2e309600.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6062312f63fe/vmlinux-2e309600.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12320e263831dd4ddb91@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_add_valid+0xa5/0xb0 lib/list_debug.c:30
Read of size 8 at addr ffff8880775905c8 by task syz-executor328/3786

CPU: 1 PID: 3786 Comm: syz-executor328 Not tainted 6.0.0-syzkaller-02744-g2e30960097f6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 __list_add_valid+0xa5/0xb0 lib/list_debug.c:30
 __list_add include/linux/list.h:69 [inline]
 list_add_tail include/linux/list.h:102 [inline]
 register_shrinker_prepared mm/vmscan.c:684 [inline]
 __register_shrinker mm/vmscan.c:696 [inline]
 register_shrinker+0x6f/0x160 mm/vmscan.c:722
 nfsd4_init_leases_net+0x390/0x490 fs/nfsd/nfs4state.c:4393
 nfsd_init_net+0x1b5/0x430 fs/nfsd/nfsctl.c:1456
 ops_init+0xaf/0x470 net/core/net_namespace.c:134
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x304d/0x7090 kernel/fork.c:2257
 kernel_clone+0xe7/0xab0 kernel/fork.c:2671
 __do_sys_clone+0xba/0x100 kernel/fork.c:2805
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7faea2762b79
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faea1f041c8 EFLAGS: 00000202 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007faea27eb248 RCX: 00007faea2762b79
RDX: 0000000020000040 RSI: 0000000000000000 RDI: 0000000074809480
RBP: 00007faea27eb240 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007faea27eb24c
R13: 00007ffe0759dc8f R14: 00007faea1f04300 R15: 0000000000022000
 </TASK>

Allocated by task 3783:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc mm/kasan/common.c:516 [inline]
 ____kasan_kmalloc mm/kasan/common.c:475 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 ops_init+0xfb/0x470 net/core/net_namespace.c:124
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x304d/0x7090 kernel/fork.c:2257
 kernel_clone+0xe7/0xab0 kernel/fork.c:2671
 __do_sys_clone+0xba/0x100 kernel/fork.c:2805
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 3783:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:367 [inline]
 ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1759 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0xe2/0x580 mm/slub.c:4567
 ops_init+0xcd/0x470 net/core/net_namespace.c:139
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x304d/0x7090 kernel/fork.c:2257
 kernel_clone+0xe7/0xab0 kernel/fork.c:2671
 __do_sys_clone+0xba/0x100 kernel/fork.c:2805
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888077590000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1480 bytes inside of
 2048-byte region [ffff888077590000, ffff888077590800)

The buggy address belongs to the physical page:
page:ffffea0001dd6400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x77590
head:ffffea0001dd6400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888011842000
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3783, tgid 3782 (syz-executor328), ts 382436699386, free_ts 382355211521
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5549
 alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:1829 [inline]
 allocate_slab+0x27e/0x3d0 mm/slub.c:1974
 new_slab mm/slub.c:2034 [inline]
 ___slab_alloc+0x84f/0xe80 mm/slub.c:3036
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3123
 slab_alloc_node mm/slub.c:3214 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 __kmalloc+0x32b/0x340 mm/slub.c:4425
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 ops_init+0xfb/0x470 net/core/net_namespace.c:124
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x304d/0x7090 kernel/fork.c:2257
 kernel_clone+0xe7/0xab0 kernel/fork.c:2671
 __do_sys_clone+0xba/0x100 kernel/fork.c:2805
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2553
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:727 [inline]
 slab_alloc_node mm/slub.c:3248 [inline]
 slab_alloc mm/slub.c:3256 [inline]
 __kmalloc+0x28a/0x340 mm/slub.c:4425
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 __register_sysctl_table+0x112/0x10a0 fs/proc/proc_sysctl.c:1344
 __devinet_sysctl_register+0x156/0x280 net/ipv4/devinet.c:2586
 devinet_init_net+0x17b/0x640 net/ipv4/devinet.c:2709
 ops_init+0xaf/0x470 net/core/net_namespace.c:134
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x304d/0x7090 kernel/fork.c:2257

Memory state around the buggy address:
 ffff888077590480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888077590500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888077590580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff888077590600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888077590680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
