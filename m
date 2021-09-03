Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DDB3FFCAC
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 11:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348708AbhICJEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 05:04:30 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:53163 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348775AbhICJEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 05:04:25 -0400
Received: by mail-il1-f200.google.com with SMTP id b13-20020a92dccd0000b0290223ea53d878so3073698ilr.19
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 02:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QHVY6xOBToV6KTQ90M6W/NwK/HndcSjGc3VqFMVnYBA=;
        b=hxdNk+DW4p1JnW9dfk0jSP8NIZRHCrVlcj4ATGDjw6F75Z8SDlGD2wGL1ww2O3eYT/
         iKbKIFNxQWWJDJGsOKthveA4tS9M02+ouzEpjrprjZgaajdDSQHNh7ZJbVAWqSXVqPF2
         0slzaNjfrALIYjUIcXz6XAc+2jQslZFBMlj7TpWvi+48/Leagvdyzm5k5D2VXggjUwA7
         n4ikBITrHAIrifqfhwxoLq2S37cOLuwSjsIDiFQ1GnYT9Z1Xu4+kHaqSzpcDd11GJ0TK
         7JbHyeGdKy7XF5/5VBtoMCHk1s5+oC23Kl3S3IBu/oRHqcA4wMvdReMjvUXzgmzJ55S3
         CfqQ==
X-Gm-Message-State: AOAM5310yURxZm7xMgk+l+zh/hHe9eI769/jBmYBroh+WCXPpK7lnpEE
        pkawsz+zqAT7PK8HqoK1IeawfBATyZmBLcGkV4uVox0JWrlP
X-Google-Smtp-Source: ABdhPJwCPUKeC0b3Zi5R/2Ipftqa8tEKDT2fo+GQWuezDbX3u2LF1VQEoMtX8ZM0wkYQlZq0SO8W1MTC3R/PnUS5pSLj5b443xIj
MIME-Version: 1.0
X-Received: by 2002:a92:7a11:: with SMTP id v17mr1824521ilc.217.1630659806037;
 Fri, 03 Sep 2021 02:03:26 -0700 (PDT)
Date:   Fri, 03 Sep 2021 02:03:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007d0d1a05cb13924c@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in add_del_if
From:   syzbot <syzbot+24b98616278c31afc800@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nikolay@nvidia.com, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3bdc70669eb2 Merge branch 'devlink-register'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=147a8072300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=914a8107c0ffdc14
dashboard link: https://syzkaller.appspot.com/bug?extid=24b98616278c31afc800
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f4ccc9d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b054f4300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+24b98616278c31afc800@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in add_del_if+0x13a/0x140 net/bridge/br_ioctl.c:85
Read of size 8 at addr ffff888019118c88 by task syz-executor790/8443

CPU: 0 PID: 8443 Comm: syz-executor790 Not tainted 5.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 add_del_if+0x13a/0x140 net/bridge/br_ioctl.c:85
 br_ioctl_stub+0x1c6/0x7f0 net/bridge/br_ioctl.c:397
 br_ioctl_call+0x5e/0xa0 net/socket.c:1091
 dev_ifsioc+0xc1f/0xf60 net/core/dev_ioctl.c:382
 dev_ioctl+0x1b9/0xee0 net/core/dev_ioctl.c:580
 sock_do_ioctl+0x18b/0x210 net/socket.c:1128
 sock_ioctl+0x2f1/0x640 net/socket.c:1231
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ee49
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc164ff518 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee49
RDX: 0000000020000180 RSI: 00000000000089a3 RDI: 0000000000000003
RBP: 0000000000402e30 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ec0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 kmalloc_node include/linux/slab.h:614 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:587
 kvmalloc include/linux/mm.h:806 [inline]
 kvzalloc include/linux/mm.h:814 [inline]
 alloc_netdev_mqs+0x98/0xe80 net/core/dev.c:10847
 loopback_net_init+0x31/0x160 drivers/net/loopback.c:211
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 __register_pernet_operations net/core/net_namespace.c:1137 [inline]
 register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1214
 register_pernet_device+0x26/0x70 net/core/net_namespace.c:1301
 net_dev_init+0x566/0x612 net/core/dev.c:11705
 do_one_initcall+0x103/0x650 init/main.c:1282
 do_initcall_level init/main.c:1355 [inline]
 do_initcalls init/main.c:1371 [inline]
 do_basic_setup init/main.c:1391 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1593
 kernel_init+0x1a/0x1d0 init/main.c:1485
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff888019118000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 3208 bytes inside of
 4096-byte region [ffff888019118000, ffff888019119000)
The buggy address belongs to the page:
page:ffffea0000644600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x19118
head:ffffea0000644600 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff88801084c280
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd60c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, ts 3473484541, free_ts 0
 prep_new_page mm/page_alloc.c:2433 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4166
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5388
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2119
 alloc_pages+0x238/0x2a0 mm/mempolicy.c:2242
 alloc_slab_page mm/slub.c:1688 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1828
 new_slab mm/slub.c:1891 [inline]
 new_slab_objects mm/slub.c:2637 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2800
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2840
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node+0x2df/0x380 mm/slub.c:4148
 kmalloc_node include/linux/slab.h:614 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:587
 kvmalloc include/linux/mm.h:806 [inline]
 kvzalloc include/linux/mm.h:814 [inline]
 alloc_netdev_mqs+0x98/0xe80 net/core/dev.c:10847
 loopback_net_init+0x31/0x160 drivers/net/loopback.c:211
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 __register_pernet_operations net/core/net_namespace.c:1137 [inline]
 register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1214
 register_pernet_device+0x26/0x70 net/core/net_namespace.c:1301
 net_dev_init+0x566/0x612 net/core/dev.c:11705
 do_one_initcall+0x103/0x650 init/main.c:1282
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888019118b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888019118c00: 00 00 00 07 fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888019118c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                      ^
 ffff888019118d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888019118d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
