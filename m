Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC488141B1C
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 03:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgASCHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 21:07:10 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56385 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgASCHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 21:07:10 -0500
Received: by mail-io1-f69.google.com with SMTP id d13so17602654ioo.23
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 18:07:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=idsr0Fm5f2RMNf3/YGiIsq96TQVNJAV84Aq5F0xBCjA=;
        b=NhWgRKggqdzQXdcC0FrAuxu6ZlJUpOKu0YJKMHymQVttgycNsMg7G7PMdZmF1jdyrn
         0hV0PivZO2NSZCv81jQBe/eFXmx1ok4ZUGhMhPmx8WlyQOt9AyF0w3EuyoFaCkf2irED
         ADPm6hB4l0ryFj4aJ8l9cUw46L0Z4tGG6a8//G1TaxEtRairROOkKdEQsFEiy5vfMUsd
         81zosaOrz3i/8YUvLhyqgY9TGhBbBZz1OI1QQw+0DOemXxMfUvUOjGjaKcroLLadEYgw
         MXV2klO+ztUv7Guo0u9k3vxvH93vf9ADc1w8CevYiRakSO2nUmSQ5X/nObXEgaHLsaGT
         yJ4w==
X-Gm-Message-State: APjAAAVmB0pB+HrjE8bnah5v+nWqLWf5/9jP0UoHdIulXDUiOo+OwiVs
        o0m9X5dMCE/2iLBLvv6i5aERryqu+GGt/Y+wsBADIOKidQMy
X-Google-Smtp-Source: APXvYqwzRWFEe+gCQEo31KXgnazGw4tk4pVAQXLm6cuznlf6z5VFTkb/DpHNBAqtM5vbIWwtYg/X+IRfqyAE0SO/m6qrrC1bkZBQ
MIME-Version: 1.0
X-Received: by 2002:a92:5cda:: with SMTP id d87mr5409106ilg.100.1579399629333;
 Sat, 18 Jan 2020 18:07:09 -0800 (PST)
Date:   Sat, 18 Jan 2020 18:07:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd68d0059c74a1db@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ip_add
From:   syzbot <syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com>
To:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    244dc268 Merge tag 'drm-fixes-2020-01-19' of git://anongit..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10edfa85e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e96783d74ee8ea9aa3
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159e60f1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f3e96783d74ee8ea9aa3@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_do_add net/netfilter/ipset/ip_set_bitmap_ip.c:83 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_add+0xdf/0x870 net/netfilter/ipset/ip_set_bitmap_gen.h:136
Read of size 8 at addr ffff888094088c80 by task syz-executor.4/9490

CPU: 1 PID: 9490 Comm: syz-executor.4 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x149/0x1c0 mm/kasan/report.c:506
 kasan_report+0x26/0x50 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:182 [inline]
 check_memory_region+0x2b6/0x2f0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_ip_do_add net/netfilter/ipset/ip_set_bitmap_ip.c:83 [inline]
 bitmap_ip_add+0xdf/0x870 net/netfilter/ipset/ip_set_bitmap_gen.h:136
 bitmap_ip_uadt+0x6bf/0xa60 net/netfilter/ipset/ip_set_bitmap_ip.c:186
 call_ad+0x10a/0x5b0 net/netfilter/ipset/ip_set_core.c:1716
 ip_set_ad+0x6a9/0x860 net/netfilter/ipset/ip_set_core.c:1804
 ip_set_uadd+0x37/0x50 net/netfilter/ipset/ip_set_core.c:1829
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b159
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fddd7876c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fddd78776d4 RCX: 000000000045b159
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000008dc R14: 00000000004ca08f R15: 000000000075bf2c

Allocated by task 8928:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:513
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x254/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc+0x21/0x40 include/linux/slab.h:670
 ip_set_alloc+0x32/0x60 net/netfilter/ipset/ip_set_core.c:255
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x48b/0xac0 net/netfilter/ipset/ip_set_bitmap_ip.c:327
 ip_set_create+0x421/0xfd0 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0x9ae/0xcd0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1e0/0x1e50 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x767/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2c/0xd50 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg net/socket.c:659 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2330
 ___sys_sendmsg net/socket.c:2384 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2424
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8538:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10d/0x220 mm/slab.c:3757
 tomoyo_path_perm+0x6ae/0x850 security/tomoyo/file.c:842
 tomoyo_inode_getattr+0x1c/0x20 security/tomoyo/tomoyo.c:129
 security_inode_getattr+0xc0/0x140 security/security.c:1222
 vfs_getattr+0x2a/0x6d0 fs/stat.c:115
 vfs_statx fs/stat.c:191 [inline]
 vfs_stat include/linux/fs.h:3249 [inline]
 __do_sys_newstat fs/stat.c:341 [inline]
 __se_sys_newstat+0x95/0x150 fs/stat.c:337
 __x64_sys_newstat+0x5b/0x70 fs/stat.c:337
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888094088c80
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff888094088c80, ffff888094088ca0)
The buggy address belongs to the page:
page:ffffea0002502200 refcount:1 mapcount:0 mapping:ffff8880aa8001c0 index:0xffff888094088fc1
raw: 00fffe0000000200 ffffea00028f8048 ffffea00029d9b88 ffff8880aa8001c0
raw: ffff888094088fc1 ffff888094088000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888094088b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff888094088c00: 00 05 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>ffff888094088c80: 04 fc fc fc fc fc fc fc 00 00 01 fc fc fc fc fc
                   ^
 ffff888094088d00: 00 00 03 fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff888094088d80: fb fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
