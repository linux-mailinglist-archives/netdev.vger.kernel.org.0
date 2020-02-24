Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2450169FED
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgBXI2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:28:20 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:48521 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbgBXI2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:28:17 -0500
Received: by mail-il1-f198.google.com with SMTP id u14so17063501ilq.15
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:28:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zPnGdhYe6fx/GA1y4l3lAwfwfLNCOo6iSouDNT5vfw0=;
        b=GXBBVgNMIhQgz/1CKnZ/tlKylF0hWSq2Inm8q79a/g70KtUvFDbGmUSfw0heGpwd/P
         0p5zPvgzj+srkW/Zawv0/eoNg6mIHjZ2vvZImTy34FcEQOd9hKFx40LfxETbJOr8NaTs
         4FCwiIezvrGmSxgarkiSxFnW4+PIrlej2uUDZjxoeGFHf6ofo7As3OlXbv7hYb9IKglk
         dPkASzbiJ60lCWX6k1rocK8PcM1FGw6LOi6d8W7QBd4uOpNONYAcZ4NuBw0Z53mtM4Up
         xmwFZBUhcZyb1OvUU5XlgZe7V5J+koYqhmw8LRjgrdd/7db/2lLFWmqNQnMbjB8FNSwT
         QP/g==
X-Gm-Message-State: APjAAAVks9d8B5khbIxN4285+ys5iCiEWfDVtzaR0ee0ijZKYX4KgpQF
        Nw9CCi9KAQJ+TYMHSUGJhuyp95h9EKwBqlRvSCPWyDDSfF5L
X-Google-Smtp-Source: APXvYqwjfTMec2vNK5//uIvwTzm0pcHaYTeC1+EaGLWrGBFccLzIF/ifYG9oXPoiMpuifFdYc7ZA6MDqjneRpTBqEbyKn+cP7pcR
MIME-Version: 1.0
X-Received: by 2002:a92:7301:: with SMTP id o1mr56267048ilc.272.1582532895280;
 Mon, 24 Feb 2020 00:28:15 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:28:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011953b059f4e27f7@google.com>
Subject: KASAN: slab-out-of-bounds Read in ethnl_update_bitset32
From:   syzbot <syzbot+983cb8fb2d17a7af549d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, f.fainelli@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d2eee258 Merge tag 'for-5.6-rc2-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11199109e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=983cb8fb2d17a7af549d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1399a3d9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+983cb8fb2d17a7af549d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in ethnl_bitmap32_not_zero net/ethtool/bitset.c:112 [inline]
BUG: KASAN: slab-out-of-bounds in ethnl_compact_sanity_checks net/ethtool/bitset.c:529 [inline]
BUG: KASAN: slab-out-of-bounds in ethnl_update_bitset32.part.0+0x8db/0x1820 net/ethtool/bitset.c:572
Read of size 4 at addr ffff8880a9750c3c by task syz-executor.0/9818

CPU: 0 PID: 9818 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:134
 ethnl_bitmap32_not_zero net/ethtool/bitset.c:112 [inline]
 ethnl_compact_sanity_checks net/ethtool/bitset.c:529 [inline]
 ethnl_update_bitset32.part.0+0x8db/0x1820 net/ethtool/bitset.c:572
 ethnl_update_bitset32 net/ethtool/bitset.c:562 [inline]
 ethnl_update_bitset+0x4d/0x67 net/ethtool/bitset.c:734
 ethnl_update_linkmodes net/ethtool/linkmodes.c:303 [inline]
 ethnl_set_linkmodes+0x461/0xc30 net/ethtool/linkmodes.c:357
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
 genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
 genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c429
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:0000000000c7fb78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000289b914 RCX: 000000000045c429
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000904 R14: 00000000004d4f90 R15: 000000000076bf2c

Allocated by task 4801:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:523
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x121/0x710 mm/slab.c:3484
 kmem_cache_zalloc include/linux/slab.h:659 [inline]
 copy_signal kernel/fork.c:1558 [inline]
 copy_process+0x2155/0x7290 kernel/fork.c:2078
 _do_fork+0x146/0x1090 kernel/fork.c:2430
 __do_sys_clone kernel/fork.c:2585 [inline]
 __se_sys_clone kernel/fork.c:2566 [inline]
 __x64_sys_clone+0x19a/0x260 kernel/fork.c:2566
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 0:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x86/0x320 mm/slab.c:3694
 free_signal_struct kernel/fork.c:728 [inline]
 put_signal_struct kernel/fork.c:734 [inline]
 __put_task_struct+0x327/0x530 kernel/fork.c:748
 put_task_struct include/linux/sched/task.h:122 [inline]
 delayed_put_task_struct+0x253/0x3c0 kernel/exit.c:182
 rcu_do_batch kernel/rcu/tree.c:2186 [inline]
 rcu_core+0x5e1/0x1390 kernel/rcu/tree.c:2410
 rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2419
 __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff8880a97506c0
 which belongs to the cache signal_cache of size 1328
The buggy address is located 76 bytes to the right of
 1328-byte region [ffff8880a97506c0, ffff8880a9750bf0)
The buggy address belongs to the page:
page:ffffea0002a5d400 refcount:1 mapcount:0 mapping:ffff88821bc468c0 index:0xffff8880a9750100 compound_mapcount: 0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002636888 ffffea00029fa308 ffff88821bc468c0
raw: ffff8880a9750100 ffff8880a9750100 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a9750b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a9750b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>ffff8880a9750c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                        ^
 ffff8880a9750c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a9750d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
