Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D1B14165E
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgARHrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:47:16 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:41398 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgARHrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:47:12 -0500
Received: by mail-il1-f199.google.com with SMTP id k9so20506280ili.8
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 23:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zqwk06jmmkjQWt5DEsbbJJA3ytz3sjYDaNJumCa51Oo=;
        b=ZyoF/ViPGS00x8+VbWANRsx/u7XCh5OqPtnBKBZwhJP0ACJVROMSBxLOhl2cuvvx1P
         ToUDyxgSZY+m1waVFI7rIWphj8j5E7npJJwOUG0tHXdc5Nvmt2cUSQCh9819w+WOjUx+
         9eonCQQZGQcjsb/uHVxdbCEwEq9Rv0lYzmHXIo4e20fvA9YSyiSQUs5aDNytsNOR3t1i
         Pe8dwwE8gtzFFrKqwWFnJ8YcDqgBHXCLzYsdt3LBL6NxPEAzgxX7d2L8cjglYn0E3i+W
         1H1YPGmNc6eDbFu4q0a5N6QLDkN+g5vqcbxEbBnAyiRyEyNwJ7UVJ7VWiIQ8hZBDPxuD
         xJRA==
X-Gm-Message-State: APjAAAVD8wyNSjvH2wbaHKe9ax8bcLmsFySszlstTbORaaXJQfiR8s67
        tAmTEJ40G3me8322fW9HLFlKvenvGcriWiirkGvsSTBPB3Sx
X-Google-Smtp-Source: APXvYqyNSOrWc4v0OyJSQYOBZPWXusrpb6MAMi4EFXZwExSZyET8QERcp94aBSwDZG1N0ogaa7TEP70YBNz+lvAYo/OyNKl63RtB
MIME-Version: 1.0
X-Received: by 2002:a6b:915:: with SMTP id t21mr31956177ioi.34.1579333631132;
 Fri, 17 Jan 2020 23:47:11 -0800 (PST)
Date:   Fri, 17 Jan 2020 23:47:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000010cc02059c654440@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_port_list
From:   syzbot <syzbot+fabca5cbf5e54f3fe2de@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ab7541c3 Merge tag 'fuse-fixes-5.5-rc7' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16cf7ed1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=fabca5cbf5e54f3fe2de
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e9b1d1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1140f959e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fabca5cbf5e54f3fe2de@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_port_list+0x386/0xb60 net/netfilter/ipset/ip_set_bitmap_gen.h:222
Read of size 8 at addr ffff8880a757a3c0 by task syz-executor872/8742

CPU: 0 PID: 8742 Comm: syz-executor872 Not tainted 5.5.0-rc6-syzkaller #0
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
 bitmap_port_list+0x386/0xb60 net/netfilter/ipset/ip_set_bitmap_gen.h:222
 ip_set_dump_start+0x10f9/0x1800 net/netfilter/ipset/ip_set_core.c:1632
 netlink_dump+0x4ed/0x1170 net/netlink/af_netlink.c:2244
 __netlink_dump_start+0x5cb/0x7b0 net/netlink/af_netlink.c:2352
 netlink_dump_start include/linux/netlink.h:233 [inline]
 ip_set_dump+0x107/0x160 net/netfilter/ipset/ip_set_core.c:1690
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
RIP: 0033:0x441479
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe8d651888 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441479
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000010bcc R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004022a0
R13: 0000000000402330 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8741:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:513
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x254/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc+0x21/0x40 include/linux/slab.h:670
 ip_set_alloc+0x32/0x60 net/netfilter/ipset/ip_set_core.c:255
 init_map_port net/netfilter/ipset/ip_set_bitmap_port.c:234 [inline]
 bitmap_port_create+0x32c/0x790 net/netfilter/ipset/ip_set_bitmap_port.c:276
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

Freed by task 8472:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10d/0x220 mm/slab.c:3757
 tomoyo_check_open_permission+0x79c/0x9d0 security/tomoyo/file.c:786
 tomoyo_file_open+0x141/0x190 security/tomoyo/tomoyo.c:319
 security_file_open+0x50/0x2e0 security/security.c:1497
 do_dentry_open+0x351/0x10c0 fs/open.c:784
 vfs_open+0x73/0x80 fs/open.c:914
 do_last fs/namei.c:3356 [inline]
 path_openat+0x1367/0x4250 fs/namei.c:3473
 do_filp_open+0x192/0x3d0 fs/namei.c:3503
 do_sys_open+0x29f/0x560 fs/open.c:1097
 __do_sys_open fs/open.c:1115 [inline]
 __se_sys_open fs/open.c:1110 [inline]
 __x64_sys_open+0x87/0x90 fs/open.c:1110
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a757a3c0
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a757a3c0, ffff8880a757a3e0)
The buggy address belongs to the page:
page:ffffea00029d5e80 refcount:1 mapcount:0 mapping:ffff8880aa8001c0 index:0xffff8880a757afc1
raw: 00fffe0000000200 ffffea00029d6148 ffffea0002848148 ffff8880aa8001c0
raw: ffff8880a757afc1 ffff8880a757a000 000000010000003e 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a757a280: fb fb fb fb fc fc fc fc 00 02 fc fc fc fc fc fc
 ffff8880a757a300: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a757a380: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff8880a757a400: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a757a480: fb fb fb fb fc fc fc fc 00 00 01 fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
