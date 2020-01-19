Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72D81420C7
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgASXRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:17:12 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45901 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgASXRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:17:10 -0500
Received: by mail-il1-f199.google.com with SMTP id w6so23674388ill.12
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 15:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=87EX4fKbV2RL3Wu240JMjatiUZWsVWorr0W/RwRVjFI=;
        b=GrFo0VQmuVy/zGEulIqZw5BlA88uJevOhYKZvjJ66FaGCTGIeHT8Tg8MPBryCPHO+m
         VqiRRC2zo7OW1XD7bc82loKjEjHlt1Qa2/B0MkPU3YHZ04P9Be/tNqhqD+6IJaMTwkHA
         BSdVpXnxJBqq5WXNe+3KohYtTHGY5a1OBc+6VkmCUQ1/g8YjpIp9Qk1nLDCAC+r4KKE7
         FKKa7+Uj3ZfSiMHT+kgB64i9A0hXeT3viY9Sgf+boGk8UGo7kYmNWdfuHgYgho6eI0g1
         cAV/IiUUEYep+uNqXZ0jTMXd9b8yoBKhlEfo7fVduWs0XqpfmxAdlFwQC2q0YVIz+kfi
         djmA==
X-Gm-Message-State: APjAAAUks2kNISIdwv8luNUc4RcS68yldA2CpB5Xikf5wl6ZQL6TrnI/
        TRJlC9nnl5ZdurshcusTqt+cz7U/hWv0AKTR3bKwnwwSoF56
X-Google-Smtp-Source: APXvYqzFaa2z8sgM2AczxtIIHpQTQfY+jMStP/W0i4QmGLa/IpyVovSDFuM03mTEk59XGum++v6zizpuEk5ki7OYHVM/aHokBEN+
MIME-Version: 1.0
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr7513296ilq.37.1579475829370;
 Sun, 19 Jan 2020 15:17:09 -0800 (PST)
Date:   Sun, 19 Jan 2020 15:17:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bdb5b2059c865f5c@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ip_ext_cleanup
From:   syzbot <syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=15fec135e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=6491ea8f6dddbf04930e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141af959e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1067fa85e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
Read of size 8 at addr ffff8880a7d15c80 by task syz-executor874/9996

CPU: 1 PID: 9996 Comm: syz-executor874 Not tainted 5.5.0-rc5-syzkaller #0
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
 bitmap_ip_ext_cleanup+0xd8/0x290 net/netfilter/ipset/ip_set_bitmap_gen.h:51
 bitmap_ip_destroy+0x180/0x1d0 net/netfilter/ipset/ip_set_bitmap_gen.h:64
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
RIP: 0033:0x441459
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffee4e5cf88 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441459
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 000000000001ac44 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402280
R13: 0000000000402310 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9996:
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

Freed by task 9722:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 single_release+0x95/0xc0 fs/seq_file.c:609
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
 prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
 do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a7d15c80
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a7d15c80, ffff8880a7d15ca0)
The buggy address belongs to the page:
page:ffffea00029f4540 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff8880a7d15fc1
raw: 00fffe0000000200 ffffea00027c0bc8 ffffea00029aa6c8 ffff8880aa4001c0
raw: ffff8880a7d15fc1 ffff8880a7d15000 0000000100000034 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a7d15b80: 00 05 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a7d15c00: 00 00 00 fc fc fc fc fc 00 fc fc fc fc fc fc fc
>ffff8880a7d15c80: 04 fc fc fc fc fc fc fc 00 00 00 fc fc fc fc fc
                   ^
 ffff8880a7d15d00: 04 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a7d15d80: 05 fc fc fc fc fc fc fc 00 00 fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
