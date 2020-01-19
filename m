Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3CD141CFB
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 09:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgASI1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 03:27:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:36999 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgASI1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 03:27:10 -0500
Received: by mail-il1-f200.google.com with SMTP id l13so22842183ilj.4
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 00:27:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XKy1TYTcaFoKWzXikfNy8Zh/NpwKbKhptMMi53xSYvo=;
        b=HEsVcJ269fz7TJTJ4RG8TN4M9UvlvY1QPifgZARJnj8VkDhRri9+HdJoqbP/yZapPf
         IU/KOMLTpOWZe17eNF37vyuYGOfloynGFYKzuyO/H/uLAt8gzPfAfdrc4PpnCaVgj0gq
         nFTM65WQ/WrpdqTzNKQSgJEoIcfEUSHXmU3szKsKpZVfbJoSpZjrjfFd+8b9UUlrSgzS
         plyNXhKqFNOmqHxxPBkyBEon8iBpIZtwue57JmaQsUktvYs5N7m1105P+YpGoEs/j9a6
         67OXyXNtRneNhSMS28N9IHh114VemYv8Dd6XzjjB/8mABkkBL/BwybPYbAeBVMI7pCfv
         INpA==
X-Gm-Message-State: APjAAAW5zc8tdHerbdovgxEkNu+0+MnhjuT78FVr7pIbw3UhXfGG6Zkn
        MF61Dipc1vFInyhAcvyrSKRl7hL9/J/ay6dry//bo+sA3Pjc
X-Google-Smtp-Source: APXvYqzcuxX+ScbgQBwuWlpX8l+2EFZgEiV7BEUQWi7fLcIhpIsDdlPlgR50TXXaqpe1p1m5XPkzKwgRu7ELFkWy8PtzPmc0XjZp
MIME-Version: 1.0
X-Received: by 2002:a92:c686:: with SMTP id o6mr5861523ilg.212.1579422429783;
 Sun, 19 Jan 2020 00:27:09 -0800 (PST)
Date:   Sun, 19 Jan 2020 00:27:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e0ab4c059c79f014@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_port_ext_cleanup
From:   syzbot <syzbot+7b6206fb525c1f5ec3f8@syzkaller.appspotmail.com>
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

HEAD commit:    e02d9c4c Merge branch 'bnxt_en-fixes'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=142f11d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=7b6206fb525c1f5ec3f8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16551cc9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a04966e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7b6206fb525c1f5ec3f8@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_port_ext_cleanup+0xe6/0x2a0 net/netfilter/ipset/ip_set_bitmap_gen.h:51
Read of size 8 at addr ffff88809f6c0d00 by task syz-executor172/8965

CPU: 1 PID: 8965 Comm: syz-executor172 Not tainted 5.5.0-rc5-syzkaller #0
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
 bitmap_port_ext_cleanup+0xe6/0x2a0 net/netfilter/ipset/ip_set_bitmap_gen.h:51
 bitmap_port_destroy+0x180/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:64
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
RIP: 0033:0x441399
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd3c76f208 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441399
RDX: 0000000000000000 RSI: 0000000020001080 RDI: 0000000000000003
RBP: 0000000000015169 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004021c0
R13: 0000000000402250 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8965:
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
 init_map_port net/netfilter/ipset/ip_set_bitmap_port.c:234 [inline]
 bitmap_port_create+0x3dc/0x7c0 net/netfilter/ipset/ip_set_bitmap_port.c:276
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

Freed by task 8710:
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

The buggy address belongs to the object at ffff88809f6c0d00
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff88809f6c0d00, ffff88809f6c0d20)
The buggy address belongs to the page:
page:ffffea00027db000 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff88809f6c0fc1
raw: 00fffe0000000200 ffffea00027cca88 ffffea0002a27908 ffff8880aa4001c0
raw: ffff88809f6c0fc1 ffff88809f6c0000 000000010000003c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809f6c0c00: 00 00 00 fc fc fc fc fc 00 fc fc fc fc fc fc fc
 ffff88809f6c0c80: 00 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>ffff88809f6c0d00: 04 fc fc fc fc fc fc fc 00 fc fc fc fc fc fc fc
                   ^
 ffff88809f6c0d80: 00 fc fc fc fc fc fc fc 00 04 fc fc fc fc fc fc
 ffff88809f6c0e00: 00 04 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
