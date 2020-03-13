Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7FF184179
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 08:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgCMHYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 03:24:11 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:34024 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgCMHYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 03:24:10 -0400
Received: by mail-il1-f197.google.com with SMTP id x2so3274632ilg.1
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 00:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3fnqtx3Np3RmuYdkSlEXsgvvP9L18wQfb4Gxspps7uM=;
        b=kuo/Z4pL72IYghJ6N46gK9WhXcwGpCAiPxQHS2EDFtH4hZLsqJfL+WYJiv6wGvQQPp
         rU1eX/svbQTU1KYSZ7t4Sf9H0o0o5KJ8PKT6w1HANRBkCbCRIrfNEKt0Yy8QlBRL2d0U
         m/uv2WMtQE+dd92j0vr4QV+q1pX2xHgZN71oMwQ1CfEU17C5Gm/lwMjTyV8PuXzYL7Yj
         BG7PiAdmoVt2P7/U77kB1x+WsZnd+urjItfhZiiEh3tcZGC1E1IGvttNBO5uhCwxhjMC
         BkwOD3dqPeNojjNz40uYaGvSHwQwBwwN0FfXDo0uojTL5AonPN7u2hX4LbdkWrAQXBZe
         pPpQ==
X-Gm-Message-State: ANhLgQ388wEsB42RP8WrxxBj9ITwCGPEckKMrleeAa1B/wkAKp6EdVdc
        RrD6KCtK2lgfJvebo1Ood5NFGaynq1KZNiAFCSLxw+A+Rk/n
X-Google-Smtp-Source: ADFU+vuVVo3qE4eAjTyKAogl7wzyNipsP9DNE++u7KnKnQjxhrUHqf2bi76wvPXzy4OAL7Uh+a0O2DgnVEHapTWUbecNyLlTPO1f
MIME-Version: 1.0
X-Received: by 2002:a02:8645:: with SMTP id e63mr9268338jai.14.1584084249541;
 Fri, 13 Mar 2020 00:24:09 -0700 (PDT)
Date:   Fri, 13 Mar 2020 00:24:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd030905a0b75ac8@google.com>
Subject: KASAN: use-after-free Read in route4_get
From:   syzbot <syzbot+1cba26af4a37d30e8040@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e6e6ec48 Merge tag 'fscrypt-for-linus' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14982f53e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
dashboard link: https://syzkaller.appspot.com/bug?extid=1cba26af4a37d30e8040
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1cba26af4a37d30e8040@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in route4_get+0x351/0x380 net/sched/cls_route.c:235
Read of size 4 at addr ffff8880a0d70040 by task syz-executor.0/9234

CPU: 0 PID: 9234 Comm: syz-executor.0 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 print_address_description+0x74/0x5c0 mm/kasan/report.c:374
 __kasan_report+0x14b/0x1c0 mm/kasan/report.c:506
 kasan_report+0x25/0x50 mm/kasan/common.c:641
 route4_get+0x351/0x380 net/sched/cls_route.c:235
 tc_new_tfilter+0x111c/0x2f50 net/sched/cls_api.c:2082
 rtnetlink_rcv_msg+0x8fb/0xd40 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f9/0x7c0 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7755ac4c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7755ac56d4 RCX: 000000000045c679
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000007
RBP: 000000000076bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009fa R14: 00000000004cc948 R15: 000000000076bfac

Allocated by task 9226:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:515
 kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 route4_change+0x224/0x1d90 net/sched/cls_route.c:493
 tc_new_tfilter+0x1490/0x2f50 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x8fb/0xd40 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f9/0x7c0 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 144:
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 __route4_delete_filter net/sched/cls_route.c:257 [inline]
 route4_delete_filter_work+0xb1/0xe0 net/sched/cls_route.c:266
 process_one_work+0x76e/0xfd0 kernel/workqueue.c:2266
 worker_thread+0xa7f/0x1450 kernel/workqueue.c:2412
 kthread+0x317/0x340 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a0d70000
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 64 bytes inside of
 192-byte region [ffff8880a0d70000, ffff8880a0d700c0)
The buggy address belongs to the page:
page:ffffea0002835c00 refcount:1 mapcount:0 mapping:ffff8880aa400000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002830e08 ffffea000263c548 ffff8880aa400000
raw: 0000000000000000 ffff8880a0d70000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a0d6ff00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a0d6ff80: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
>ffff8880a0d70000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff8880a0d70080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880a0d70100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
