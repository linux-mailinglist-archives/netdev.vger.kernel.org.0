Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97F144C22
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 07:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAVG5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 01:57:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:56408 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgAVG5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 01:57:09 -0500
Received: by mail-il1-f198.google.com with SMTP id i68so4066769ill.23
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 22:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/rQBg5JrtiVpeVsizLp7+VFqN7X2U+I1/SyZDrm+44g=;
        b=ZRcDn0qNSsdBSWgV+GYYs/GUNyRdJhizAbr08nFXmaY+RXjjXf7mv54iv1vio8NpKR
         e16MzsnZGmnbREKhA9Z6xSyre0BRl7eVUsHxPxb96hpJlqixl7NFQYSdHspn1F+EeIVl
         dxHeWgEOJAGEI1ggcMTiX5TqDsbpBpjP/TA8yuFyVFalE5Xj4iBOE3F0dAVeon1ktu55
         EbehRP9VbE8Ngg+ZsEqjU4xyF8XpSn22dpqcnQgKH7tYdDWpgjkpIa8ElWM//z73RvH9
         ACQGCfrf9BgUKJRrDqwNOAtKTpWrIoMGJHjDFozSTa8c06NuhUujHvUZiaVgxUx8DCIx
         72tw==
X-Gm-Message-State: APjAAAVF/YiinQFuFw1S/Tu+sKaoBnVuDh0Wc7DjV9fUeToSu6Zbqi1E
        hHz7TC/J0iA99SWYmCEBfbPFuuvWTw9O8JKhQcMDr9xIK8Ln
X-Google-Smtp-Source: APXvYqzFNnJRCWdK1dGmZN0wL484rJ2pLx5LJkhGaDWOxP2VeY51KW1awSV/FhqndxD3NYVgKksYxViDpZ6FrnC64AXqRF09qlTD
MIME-Version: 1.0
X-Received: by 2002:a92:5cda:: with SMTP id d87mr7193909ilg.100.1579676228655;
 Tue, 21 Jan 2020 22:57:08 -0800 (PST)
Date:   Tue, 21 Jan 2020 22:57:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000078224f059cb50887@google.com>
Subject: KASAN: slab-out-of-bounds Read in nla_put_nohdr
From:   syzbot <syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com>
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

HEAD commit:    d96d875e Merge tag 'fixes_for_v5.5-rc8' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d13879e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83c00afca9cf5153
dashboard link: https://syzkaller.appspot.com/bug?extid=2f07903a5b05e7f36410
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17736bd1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b67369e00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138c726ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=104c726ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=178c726ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: slab-out-of-bounds in __nla_put_nohdr lib/nlattr.c:815 [inline]
BUG: KASAN: slab-out-of-bounds in nla_put_nohdr+0x100/0x180 lib/nlattr.c:881
Read of size 12 at addr ffff888095542c40 by task syz-executor859/9230

CPU: 0 PID: 9230 Comm: syz-executor859 Not tainted 5.5.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x149/0x1c0 mm/kasan/report.c:506
 kasan_report+0x26/0x50 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:182 [inline]
 check_memory_region+0x2b6/0x2f0 mm/kasan/generic.c:192
 memcpy+0x28/0x60 mm/kasan/common.c:125
 __nla_put_nohdr lib/nlattr.c:815 [inline]
 nla_put_nohdr+0x100/0x180 lib/nlattr.c:881
 tcf_em_tree_dump+0x4c6/0x940 net/sched/ematch.c:471
 basic_dump+0x44e/0x690 net/sched/cls_basic.c:308
 tcf_fill_node+0x4f5/0x8a0 net/sched/cls_api.c:1814
 tfilter_notify net/sched/cls_api.c:1840 [inline]
 tc_new_tfilter+0x1b73/0x2f70 net/sched/cls_api.c:2108
 rtnetlink_rcv_msg+0x8fb/0xd40 net/core/rtnetlink.c:5415
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5442
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
RIP: 0033:0x440dd9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff09724008 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004a25b0 RCX: 0000000000440dd9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000120080522 R11: 0000000000000246 R12: 00000000004022e0
R13: 0000000000402370 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9230:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:513
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc_track_caller+0x253/0x340 mm/slab.c:3671
 kmemdup+0x24/0x50 mm/util.c:127
 em_nbyte_change+0xb7/0x120 net/sched/em_nbyte.c:32
 tcf_em_validate net/sched/ematch.c:241 [inline]
 tcf_em_tree_validate+0x6b2/0x1020 net/sched/ematch.c:359
 basic_set_parms net/sched/cls_basic.c:157 [inline]
 basic_change+0x5c8/0x1280 net/sched/cls_basic.c:219
 tc_new_tfilter+0x1490/0x2f70 net/sched/cls_api.c:2104
 rtnetlink_rcv_msg+0x8fb/0xd40 net/core/rtnetlink.c:5415
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5442
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

Freed by task 8926:
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

The buggy address belongs to the object at ffff888095542c40
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff888095542c40, ffff888095542c60)
The buggy address belongs to the page:
page:ffffea0002555080 refcount:1 mapcount:0 mapping:ffff8880aa8001c0 index:0xffff888095542fc1
raw: 00fffe0000000200 ffffea00029f8708 ffffea00029c1a48 ffff8880aa8001c0
raw: ffff888095542fc1 ffff888095542000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888095542b00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff888095542b80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff888095542c00: 00 00 01 fc fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff888095542c80: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
 ffff888095542d00: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
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
