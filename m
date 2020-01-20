Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795DF1423C7
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 07:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgATGrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 01:47:09 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:54502 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgATGrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 01:47:08 -0500
Received: by mail-io1-f70.google.com with SMTP id u6so19308654iog.21
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 22:47:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cIdmPd9T49k4wiqUYsL6iwyA5/K/5mAfkMfBSkCrK8o=;
        b=TthQv4HVC8Elq950TjQ/6wV/5jrLIii1Vd3D1tM6MzfuflQykU4fTtZBkq3j6zb3wi
         icbvVTnijCK0YDRnTP+t71xZcDXP8zNQ5/By2xoxjdL48usginwloWzeayDi5b+hvwMs
         1GyuHTK4fOfOcgwR9Mk7kgHb6SCxHVMApXCat6PS4KUjaBftnedAJWieqfLD8JG8BcMU
         T6bw1RuoZrCygHD/LK1LcOtMhHf0HnWowWmi6+hTKMQj7Z91ORMNDYI/kRa26NzyF/yI
         N82GbD4lKAxcW7Mm0WiB9M77YqFcS92QQwR05y6uhixgPGq9albBTvWu1gna1D88t7Mt
         ma+g==
X-Gm-Message-State: APjAAAW8a+/zyphWMJDCPWgiuaTKdUVsGeKZ07I42mnA2One3/54XIBx
        MBtArChDWWcynGK9Xv8pIATr4FmOyjUdYdpGV2oGiv2uoz+Z
X-Google-Smtp-Source: APXvYqz69J753AHOIMOPF0z/tt4wAGEiwX/3+cyakeFsgp9vWRB7zm8SZOQa5IW9/m5ftPwGK4yW4BbqtzLVNxwb2ALkYecxvXqx
MIME-Version: 1.0
X-Received: by 2002:a6b:915:: with SMTP id t21mr37643107ioi.34.1579502827619;
 Sun, 19 Jan 2020 22:47:07 -0800 (PST)
Date:   Sun, 19 Jan 2020 22:47:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f649ad059c8ca893@google.com>
Subject: KASAN: slab-out-of-bounds Write in bitmap_ip_del
From:   syzbot <syzbot+24d0577de55b8b8f6975@syzkaller.appspotmail.com>
To:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, gregkh@linuxfoundation.org, jeremy@azazel.net,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
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

HEAD commit:    09d4f10a net: sched: act_ctinfo: fix memory leak
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=168f73b9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=24d0577de55b8b8f6975
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1799c135e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176b8faee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+24d0577de55b8b8f6975@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_and_clear_bit include/asm-generic/bitops/instrumented-atomic.h:83 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_do_del net/netfilter/ipset/ip_set_bitmap_ip.c:89 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_del+0xdb/0x380 net/netfilter/ipset/ip_set_bitmap_gen.h:182
Write of size 8 at addr ffff888094779ec0 by task syz-executor498/9869

CPU: 0 PID: 9869 Comm: syz-executor498 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 __kasan_check_write+0x14/0x20 mm/kasan/common.c:101
 test_and_clear_bit include/asm-generic/bitops/instrumented-atomic.h:83 [inline]
 bitmap_ip_do_del net/netfilter/ipset/ip_set_bitmap_ip.c:89 [inline]
 bitmap_ip_del+0xdb/0x380 net/netfilter/ipset/ip_set_bitmap_gen.h:182
 bitmap_ip_uadt+0x73e/0xa10 net/netfilter/ipset/ip_set_bitmap_ip.c:186
 call_ad+0x1a0/0x5a0 net/netfilter/ipset/ip_set_core.c:1716
 ip_set_ad.isra.0+0x572/0xb20 net/netfilter/ipset/ip_set_core.c:1804
 ip_set_udel+0x3a/0x50 net/netfilter/ipset/ip_set_core.c:1838
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
RIP: 0033:0x440689
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc9c51e348 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440689
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 000000000000001c R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401f10
R13: 0000000000401fa0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9869:
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
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x6ec/0xc20 net/netfilter/ipset/ip_set_bitmap_ip.c:327
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

Freed by task 9598:
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

The buggy address belongs to the object at ffff888094779ec0
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff888094779ec0, ffff888094779ee0)
The buggy address belongs to the page:
page:ffffea000251de40 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff888094779fc1
raw: 00fffe0000000200 ffffea00027fee88 ffffea0002a42888 ffff8880aa4001c0
raw: ffff888094779fc1 ffff888094779000 000000010000002f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888094779d80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff888094779e00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff888094779e80: 00 00 05 fc fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff888094779f00: 00 fc fc fc fc fc fc fc 00 00 03 fc fc fc fc fc
 ffff888094779f80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
