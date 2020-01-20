Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898EB1423C4
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 07:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgATGrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 01:47:09 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:50334 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgATGrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 01:47:08 -0500
Received: by mail-io1-f70.google.com with SMTP id e13so19195342iob.17
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 22:47:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MuAwe6mdiCtWoj0bCmHk0ViJmRHm0jBAoLaW34a3xHw=;
        b=PA5PgZqtdS0jKtF3zZYRwcs3dGVo5KrKpvhygApnKBQ5F++lg7yZb/BS9T4ZxJkdIV
         18qTZBEJV3XmcFfE4YjDt6aGC4gORuXx3ZzU6T5TtK0fYm6h1zt8lkzwysIQaDMc5eNe
         CiwH82dPxcbvJim/OkE83tla64u1fZoDvUYSsvBE8K2isPdXjRxMQRcqO3XLH1LUIC/J
         fMg/DGAnPg8TEhD7Fcfk5QPW996FvvLpLcPGij3v0bF17DeYgwZcW/u/sSQ4lwOa4Fjn
         aLI2txc38wDmp2pzjObFuuuljC+385PU3xmBno+N6stRL0efxGHZ0/vk9bOszJqzASV+
         eX8g==
X-Gm-Message-State: APjAAAV2s1UNfLuEU7osVBPsn9cYQbZRhn5NxIDXcpK/xiwuxC3Q32KX
        dycUopWdNKewF81dFhcTS8SZI4boirdU+QJTgAXzBs8uln0n
X-Google-Smtp-Source: APXvYqx/N3926g6aQZLHQYvWAg5Z+toNaZNNH8dSy1S60HiNcDABnqHWvzr5exIMUOM3b5/Bf3ppWtN1CH7Khvcl6EL+jkLVcYEA
MIME-Version: 1.0
X-Received: by 2002:a5d:9514:: with SMTP id d20mr35139554iom.198.1579502827821;
 Sun, 19 Jan 2020 22:47:07 -0800 (PST)
Date:   Sun, 19 Jan 2020 22:47:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f96400059c8ca8cd@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ipmac_ext_cleanup
From:   syzbot <syzbot+c400f7b04cadb5df6ea7@syzkaller.appspotmail.com>
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

HEAD commit:    09d4f10a net: sched: act_ctinfo: fix memory leak
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13bc21d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=c400f7b04cadb5df6ea7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170871d1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16b02cc9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c400f7b04cadb5df6ea7@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ipmac_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
Read of size 8 at addr ffff88809e126b40 by task syz-executor256/9597

CPU: 0 PID: 9597 Comm: syz-executor256 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_ipmac_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
 bitmap_ipmac_destroy+0x180/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:64
 ip_set_create+0xe47/0x1500 net/netfilter/ipset/ip_set_core.c:1165
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4413f9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeb99f7fc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004413f9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000182b5 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402220
R13: 00000000004022b0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9597:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x163/0x770 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:670 [inline]
 ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
 init_map_ipmac net/netfilter/ipset/ip_set_bitmap_ipmac.c:302 [inline]
 bitmap_ipmac_create+0x4e8/0xa00 net/netfilter/ipset/ip_set_bitmap_ipmac.c:365
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9327:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 tomoyo_check_open_permission+0x19e/0x3e0 security/tomoyo/file.c:786
 tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
 tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
 security_file_open+0x71/0x300 security/security.c:1497
 do_dentry_open+0x37a/0x1380 fs/open.c:784
 vfs_open+0xa0/0xd0 fs/open.c:914
 do_last fs/namei.c:3420 [inline]
 path_openat+0x10df/0x4500 fs/namei.c:3537
 do_filp_open+0x1a1/0x280 fs/namei.c:3567
 do_sys_open+0x3fe/0x5d0 fs/open.c:1097
 __do_sys_open fs/open.c:1115 [inline]
 __se_sys_open fs/open.c:1110 [inline]
 __x64_sys_open+0x7e/0xc0 fs/open.c:1110
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809e126b40
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff88809e126b40, ffff88809e126b60)
The buggy address belongs to the page:
page:ffffea0002784980 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff88809e126fc1
raw: 00fffe0000000200 ffffea00028bebc8 ffffea00027ca4c8 ffff8880aa4001c0
raw: ffff88809e126fc1 ffff88809e126000 000000010000002b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809e126a00: fb fb fb fb fc fc fc fc 00 01 fc fc fc fc fc fc
 ffff88809e126a80: 00 01 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>ffff88809e126b00: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff88809e126b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809e126c00: fb fb fb fb fc fc fc fc 00 01 fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
