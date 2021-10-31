Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B121440FCC
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 18:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhJaRnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 13:43:03 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33338 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhJaRnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 13:43:00 -0400
Received: by mail-io1-f70.google.com with SMTP id f19-20020a6b6213000000b005ddc4ce4deeso11128254iog.0
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 10:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7M1VeV5Puogy1Aa38S5xLZtrD8M6xbycaErzb+ZqLJk=;
        b=HmCDTPdXnKO+dae62b55oCc4y50014rFhe1SeP2NNcZdNGfZ9bmReoCQ255qTL0i83
         XTNeRUBRsKLL4kPywUxTkSnfq4lDnru6HZ1EKX6S3fnYwIr1Js6XtJNUeY0iOb20ICLx
         WukldlvQ3MwdR/YP/NzuakDbKSLemrFHjNSyamYKw1oF1+cJrEbFcyU2wNzM+AE1gmmD
         BfosqOaeekcDnMKpLSb775Oql+PyssQF4u9Hs+sT27OFwvRYCHGpY7bsNChgw8w131NH
         Coqx48nqsBAO8QsCHZNhWmWsH5nbNMUAp1Kh0OXcZzoC4qAcwzkDOD6Ntght8GKnpNpN
         b1oA==
X-Gm-Message-State: AOAM530vnHZftbKiuqHaPYeSk4k+enLBtSmNNhZsgwSdN6vBD4RGhTZ1
        N+XRZMXi057uW7uAJHZXCCimQmQiu5gartQ2OOLyjBG/UuhN
X-Google-Smtp-Source: ABdhPJxl9h4UvTixmRZjoZ4XRQXq8YzoiNVLBOoyjHr4IJkAOBDsUCqLLrO70nd8cxZTyidaqz7J8lqO/6HYRQB6zWVb6MrwRB+c
MIME-Version: 1.0
X-Received: by 2002:a92:cb4e:: with SMTP id f14mr15507720ilq.109.1635702025869;
 Sun, 31 Oct 2021 10:40:25 -0700 (PDT)
Date:   Sun, 31 Oct 2021 10:40:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035de5905cfa98e03@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in hci_le_meta_evt (2)
From:   syzbot <syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    119c85055d86 Merge tag 'powerpc-5.15-6' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1453e1f4b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6362530af157355b
dashboard link: https://syzkaller.appspot.com/bug?extid=e3fcb9c4f3c2a931dc40
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1128465cb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1431dfe2b00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f27096b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12f27096b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14f27096b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e3fcb9c4f3c2a931dc40@syzkaller.appspotmail.com

Bluetooth: hci0: unknown advertising packet type: 0x90
Bluetooth: hci0: Dropping invalid advertising data
==================================================================
BUG: KASAN: slab-out-of-bounds in hci_le_adv_report_evt net/bluetooth/hci_event.c:5783 [inline]
BUG: KASAN: slab-out-of-bounds in hci_le_meta_evt+0x3e27/0x46d0 net/bluetooth/hci_event.c:6104
Read of size 1 at addr ffff888079314e03 by task kworker/u5:2/6459

CPU: 1 PID: 6459 Comm: kworker/u5:2 Not tainted 5.15.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x2d6 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 hci_le_adv_report_evt net/bluetooth/hci_event.c:5783 [inline]
 hci_le_meta_evt+0x3e27/0x46d0 net/bluetooth/hci_event.c:6104
 hci_event_packet+0x5d9/0x7cf0 net/bluetooth/hci_event.c:6445
 hci_rx_work+0x4fa/0xd30 net/bluetooth/hci_core.c:5136
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 6453:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa1/0xd0 mm/kasan/common.c:522
 kmalloc_reserve net/core/skbuff.c:356 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:427
 alloc_skb include/linux/skbuff.h:1116 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0xbd/0x450 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:507
 vfs_write+0x7cf/0xae0 fs/read_write.c:594
 ksys_write+0x12d/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888079314c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 3 bytes to the right of
 512-byte region [ffff888079314c00, ffff888079314e00)
The buggy address belongs to the page:
page:ffffea0001e4c500 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x79314
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00005ef948 ffffea0000768f08 ffff888010c40600
raw: 0000000000000000 ffff888079314000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 1, ts 20947704734, free_ts 20947079890
 prep_new_page mm/page_alloc.c:2426 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4155
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5381
 __alloc_pages_node include/linux/gfp.h:570 [inline]
 kmem_getpages mm/slab.c:1377 [inline]
 cache_grow_begin+0x75/0x460 mm/slab.c:2593
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2965
 ____cache_alloc mm/slab.c:3048 [inline]
 ____cache_alloc mm/slab.c:3031 [inline]
 __do_cache_alloc mm/slab.c:3275 [inline]
 slab_alloc mm/slab.c:3316 [inline]
 kmem_cache_alloc_trace+0x38c/0x480 mm/slab.c:3573
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 kernfs_fop_open+0x2c5/0xd40 fs/kernfs/file.c:628
 do_dentry_open+0x4c8/0x11d0 fs/open.c:822
 do_open fs/namei.c:3428 [inline]
 path_openat+0x1c9a/0x2740 fs/namei.c:3561
 do_filp_open+0x1aa/0x400 fs/namei.c:3588
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1200
 do_sys_open fs/open.c:1216 [inline]
 __do_sys_open fs/open.c:1224 [inline]
 __se_sys_open fs/open.c:1220 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1220
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1340 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1391
 free_unref_page_prepare mm/page_alloc.c:3317 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3396
 selinux_genfs_get_sid security/selinux/hooks.c:1378 [inline]
 inode_doinit_with_dentry+0x868/0x12e0 security/selinux/hooks.c:1573
 selinux_d_instantiate+0x23/0x30 security/selinux/hooks.c:6448
 security_d_instantiate+0x50/0xe0 security/security.c:2039
 d_splice_alias+0x8c/0xc60 fs/dcache.c:3064
 kernfs_iop_lookup+0x22d/0x2c0 fs/kernfs/dir.c:1137
 lookup_open.isra.0+0x69f/0x13d0 fs/namei.c:3260
 open_last_lookups fs/namei.c:3352 [inline]
 path_openat+0x9a5/0x2740 fs/namei.c:3558
 do_filp_open+0x1aa/0x400 fs/namei.c:3588
 do_sys_openat2+0x16d/0x4d0 fs/open.c:1200
 do_sys_open fs/open.c:1216 [inline]
 __do_sys_open fs/open.c:1224 [inline]
 __se_sys_open fs/open.c:1220 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1220
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888079314d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888079314d80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888079314e00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff888079314e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888079314f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
