Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41ED4144556
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAUTrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:47:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:56527 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgAUTrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:47:10 -0500
Received: by mail-io1-f72.google.com with SMTP id d13so2404973ioo.23
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:47:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4Qooo+yLtW0hSQ6uqVOv6DJWezkkHSW9eCGuSjzIwDc=;
        b=tnYWmcLq/sxf7oaW0d8HzZtzcxpRMsyrqzgdg5HsLES9p7eZ/SL8pCO+q8Zep0/LMM
         F99mtOilAiJ8kyDyx3VEOFgN0a0RVSJz3kPI8qPMKjMEv2mR74y/X9B4CVKBuCdsujoD
         lHLErcDbbPxCuBZeTZVyCvjH53eVV4f4wEMaPPMiGyVy2DKGhpSulMQaJOKcQFhnTWrO
         RMxnEx7MKxQSKHHYZc3MT58kUWW45aW8ecUa75CAJF9at0qw3S3J2xk5JzofTlh4Q3ta
         w7Mj/7KRZuEcM5VjcPypbEzvjX+eJzTx+hbUXnTdAyPUuBUe69xcWhq1tf1nqdpCLcMr
         wc9w==
X-Gm-Message-State: APjAAAWk2sFJAKdFY9LfNQRjBkLcQUnK9yAV840Js6WR1bjrkGx1nWlT
        xMdfPiPZvrwDMqktx4X/yl9piyDlIJ8tFQRNLPePLNmawWtI
X-Google-Smtp-Source: APXvYqxjBUYzytiRZkLP4ZQ7IzU6IAWTLSThIj2ySVZIM9q+LA+jnsD+iegJuM/XMYH0/b01krW1mR687e/R6G8jwAzSVVUkjhpu
MIME-Version: 1.0
X-Received: by 2002:a92:d608:: with SMTP id w8mr4810833ilm.95.1579636029090;
 Tue, 21 Jan 2020 11:47:09 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:47:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006370ef059cabac14@google.com>
Subject: KASAN: slab-out-of-bounds Read in __nla_put_nohdr
From:   syzbot <syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    80892772 hsr: Fix a compilation error
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1718e46ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=5af9a90dad568aa9f611
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1043f521e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fb5521e00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1084280de00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1284280de00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1484280de00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:380 [inline]
BUG: KASAN: slab-out-of-bounds in __nla_put_nohdr+0x46/0x50 lib/nlattr.c:815
Read of size 12 at addr ffff888096ff0780 by task syz-executor696/9507

CPU: 0 PID: 9507 Comm: syz-executor696 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 memcpy+0x24/0x50 mm/kasan/common.c:125
 memcpy include/linux/string.h:380 [inline]
 __nla_put_nohdr+0x46/0x50 lib/nlattr.c:815
 nla_put_nohdr+0xf9/0x140 lib/nlattr.c:881
 tcf_em_tree_dump+0x67e/0x960 net/sched/ematch.c:471
 basic_dump+0x379/0x690 net/sched/cls_basic.c:308
 tcf_fill_node+0x58b/0x970 net/sched/cls_api.c:1814
 tfilter_notify+0x134/0x290 net/sched/cls_api.c:1840
 tc_new_tfilter+0xc18/0x2590 net/sched/cls_api.c:2108
 rtnetlink_rcv_msg+0x824/0xaf0 net/core/rtnetlink.c:5415
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
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
RIP: 0033:0x440dd9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd12f770f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004a25b0 RCX: 0000000000440dd9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000120080522 R11: 0000000000000246 R12: 00000000004022e0
R13: 0000000000402370 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9507:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc_track_caller+0x15f/0x760 mm/slab.c:3671
 kmemdup+0x27/0x60 mm/util.c:127
 kmemdup include/linux/string.h:453 [inline]
 em_nbyte_change+0xd6/0x150 net/sched/em_nbyte.c:32
 tcf_em_validate net/sched/ematch.c:241 [inline]
 tcf_em_tree_validate net/sched/ematch.c:359 [inline]
 tcf_em_tree_validate+0x9b5/0xf3c net/sched/ematch.c:300
 basic_set_parms net/sched/cls_basic.c:157 [inline]
 basic_change+0x513/0x14a0 net/sched/cls_basic.c:219
 tc_new_tfilter+0xbbd/0x2590 net/sched/cls_api.c:2104
 rtnetlink_rcv_msg+0x824/0xaf0 net/core/rtnetlink.c:5415
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
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

Freed by task 4365:
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
 do_last fs/namei.c:3356 [inline]
 path_openat+0x118b/0x3180 fs/namei.c:3473
 do_filp_open+0x1a1/0x280 fs/namei.c:3503
 do_sys_open+0x3fe/0x5d0 fs/open.c:1097
 __do_sys_open fs/open.c:1115 [inline]
 __se_sys_open fs/open.c:1110 [inline]
 __x64_sys_open+0x7e/0xc0 fs/open.c:1110
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888096ff0780
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff888096ff0780, ffff888096ff07a0)
The buggy address belongs to the page:
page:ffffea00025bfc00 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff888096ff0fc1
raw: 00fffe0000000200 ffffea000253ec08 ffff8880aa401238 ffff8880aa4001c0
raw: ffff888096ff0fc1 ffff888096ff0000 0000000100000030 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888096ff0680: 00 00 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff888096ff0700: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff888096ff0780: 04 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
                   ^
 ffff888096ff0800: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
 ffff888096ff0880: 00 00 00 00 fc fc fc fc 00 00 fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
