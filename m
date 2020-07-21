Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ADE2277AF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 06:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgGUElW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 00:41:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55669 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUElW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 00:41:22 -0400
Received: by mail-il1-f199.google.com with SMTP id b2so12628723ilh.22
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 21:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4NDObDvcYVvUxbnT7etgKM0Hz8xx5bu3Bc10MkSF2tQ=;
        b=BClaZq330xpVd2X6ch6UD5hFXvD4uLKuQAnEUgRw4LOkzdaHIpkupIRDcY8vCqAn/I
         QbHCEb3aR9KwZFnrWQ5lOATdNbAqFlZuq3XwP9PImln01OAtwXiBqwXX03Td/I3rqGpe
         l0KLFYB4UcNcbgkMakwC0SFkf3bfEnmjPvWUUkGbVgWUL1Nu/KNoHanIoKBkD58UHY8p
         zn0CK7prxbov3S3gYgDX/ajhw1ShomwoRrBTrqD3oW6CyoCqA6Wxeg4zRcDLB8kULqrT
         BuWqmsnYp+ZiQ2nl+ajpPzhBoPSlWQ19G6Dc9aEFah2npBEBqgELazm6KB66/OOQoW0w
         cfJQ==
X-Gm-Message-State: AOAM530AUakYNBoNS4aM5ld+CBWkmq1ARUnP3Ze4eYLwsSHFwDdQU9gv
        GBucwMFbzjedhsMe+aNQ2vIxmdBTquXrQZQpGUWkXAFbS8HE
X-Google-Smtp-Source: ABdhPJw0z0wKHOCOUiAiruRk2dSuGAkOO64ky9nsRZ3Iyw9UCkXXhKOyTVABvUAeIzY6Gzi5hsxFiq1/gmahTv9MK0DWN15tVwNJ
MIME-Version: 1.0
X-Received: by 2002:a6b:6d07:: with SMTP id a7mr25915421iod.166.1595306480557;
 Mon, 20 Jul 2020 21:41:20 -0700 (PDT)
Date:   Mon, 20 Jul 2020 21:41:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014e30705aaec3cc5@google.com>
Subject: KASAN: use-after-free Read in sock_def_write_space (2)
From:   syzbot <syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com>
To:     christophe.jaillet@wanadoo.fr, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        navid.emamdoost@gmail.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5714ee50 copy_xstate_to_kernel: Fix typo which caused GDB ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13059e7f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=6720d64f31c081c2f708
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1732cabb100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163ace5f100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: use-after-free in list_empty include/linux/list.h:282 [inline]
BUG: KASAN: use-after-free in waitqueue_active include/linux/wait.h:127 [inline]
BUG: KASAN: use-after-free in wq_has_sleeper include/linux/wait.h:161 [inline]
BUG: KASAN: use-after-free in skwq_has_sleeper include/net/sock.h:2143 [inline]
BUG: KASAN: use-after-free in sock_def_write_space+0x609/0x630 net/core/sock.c:2926
Read of size 8 at addr ffff88808a6d25c0 by task syz-executor863/6817

CPU: 0 PID: 6817 Comm: syz-executor863 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 list_empty include/linux/list.h:282 [inline]
 waitqueue_active include/linux/wait.h:127 [inline]
 wq_has_sleeper include/linux/wait.h:161 [inline]
 skwq_has_sleeper include/net/sock.h:2143 [inline]
 sock_def_write_space+0x609/0x630 net/core/sock.c:2926
 sock_wfree+0x1cc/0x240 net/core/sock.c:2060
 skb_release_head_state+0x9f/0x250 net/core/skbuff.c:651
 skb_release_all net/core/skbuff.c:662 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 kfree_skb.part.0+0x89/0x350 net/core/skbuff.c:696
 kfree_skb+0x7d/0x100 include/linux/refcount.h:270
 skb_queue_purge+0x14/0x30 net/core/skbuff.c:3077
 qrtr_tun_release+0x40/0x60 net/qrtr/tun.c:118
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:239 [inline]
 __prepare_exit_to_usermode+0x1e9/0x1f0 arch/x86/entry/common.c:269
 __do_fast_syscall_32 arch/x86/entry/common.c:475 [inline]
 do_fast_syscall_32+0x7f/0x120 arch/x86/entry/common.c:503
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fc2569
Code: Bad RIP value.
RSP: 002b:00000000ffd1de7c EFLAGS: 00000246 ORIG_RAX: 0000000000000006
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000020000180
RDX: 0000000000000007 RSI: 00000000080bffdb RDI: 000000002000018e
RBP: 00000000ffd1dee8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6817:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x12c/0x3b0 mm/slab.c:3484
 sock_alloc_inode+0x18/0x1c0 net/socket.c:253
 alloc_inode+0x61/0x230 fs/inode.c:232
 new_inode_pseudo+0x14/0xe0 fs/inode.c:928
 sock_alloc+0x3c/0x260 net/socket.c:573
 __sock_create+0xb9/0x740 net/socket.c:1392
 sock_create net/socket.c:1479 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1521
 __do_sys_socket net/socket.c:1530 [inline]
 __se_sys_socket net/socket.c:1528 [inline]
 __ia32_sys_socket+0x6f/0xb0 net/socket.c:1528
 do_syscall_32_irqs_on+0x3f/0x60 arch/x86/entry/common.c:428
 __do_fast_syscall_32 arch/x86/entry/common.c:475 [inline]
 do_fast_syscall_32+0x7f/0x120 arch/x86/entry/common.c:503
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Freed by task 16:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x7f/0x310 mm/slab.c:3694
 i_callback+0x3f/0x70 fs/inode.c:221
 rcu_do_batch kernel/rcu/tree.c:2414 [inline]
 rcu_core+0x5c7/0x1160 kernel/rcu/tree.c:2641
 __do_softirq+0x34c/0xa60 kernel/softirq.c:292

The buggy address belongs to the object at ffff88808a6d2540
 which belongs to the cache sock_inode_cache of size 1216
The buggy address is located 128 bytes inside of
 1216-byte region [ffff88808a6d2540, ffff88808a6d2a00)
The buggy address belongs to the page:
page:ffffea000229b480 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88808a6d2ffd
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002250f88 ffffea000229a608 ffff88821b77f700
raw: ffff88808a6d2ffd ffff88808a6d2000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808a6d2480: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88808a6d2500: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
>ffff88808a6d2580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88808a6d2600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808a6d2680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
