Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D113D3E8F53
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbhHKLQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 07:16:50 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:37801 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237224AbhHKLQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 07:16:49 -0400
Received: by mail-il1-f198.google.com with SMTP id a2-20020a9266020000b0290222005f354cso1118140ilc.4
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 04:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HmEDS0FYLEJ/zcVv7Q2EVhnsR4cbjcf4BbnPzxZ83Rw=;
        b=jxIhQkZK3xjp2Si1A6h5QS6x2hfE6s0BBsKbSujq/74zeB5IiW0iGjJ2CoF+hekuJ5
         Yvojx3nY6pl1lJqX/a67tbMC7sdVLb1YApiNnvzTg5waErHUEtZ5ywrrjV11TluPpjgl
         b9GraT3ChSOfKTxOeBtTnVo3/oUzWAmX+yn9i2NdKPO7eA4JH6M/PE8vs6Lsp8dHDPx9
         vo+TTdbVvLg0CQ5i3L0xnxNNgO/fRZizBP1T5gSaj5mVwZR2zCwXv/B++kT+kbMUd4OH
         KmOy2Q17m3qV3d9Fx5K672aNIy5dxcZQK2W5FUOWlWt1i4UwxvBUWY9KEDybN5g6DzL+
         BLFQ==
X-Gm-Message-State: AOAM530+ySnFsV6vG9IvGr1dqdj0M27gCgKU95fyD1fIEquTSpeTNhIn
        x5uPEI+WdRS8VitwoozCY60SlvnlKS0GsfwW+mzhw8zEyVnE
X-Google-Smtp-Source: ABdhPJz5bRKBsEFIZ00tSCnIQTrzNeX1W6f8tFhgOJV9+8/AqH7aqa5YMrxC5cDMEiInVELG6+nj2+mr8D8kLtAdmvidcUOALt+D
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c2a:: with SMTP id m10mr188481ilh.114.1628680585872;
 Wed, 11 Aug 2021 04:16:25 -0700 (PDT)
Date:   Wed, 11 Aug 2021 04:16:25 -0700
In-Reply-To: <00000000000000410c05c8e29289@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c60fd605c946bfe2@google.com>
Subject: Re: [syzbot] KASAN: invalid-free in bdev_free_inode (2)
From:   syzbot <syzbot+5fa698422954b6b9307b@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d3432bf10f17 net: Support filtering interfaces on no master
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14fd894e300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=5fa698422954b6b9307b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174ebaf6300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fa698422954b6b9307b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3210 [inline]
BUG: KASAN: double-free or invalid-free in kfree+0xe4/0x530 mm/slub.c:4264

CPU: 1 PID: 11043 Comm: syz-executor.1 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:358
 ____kasan_slab_free mm/kasan/common.c:346 [inline]
 __kasan_slab_free+0x120/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1625 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
 slab_free mm/slub.c:3210 [inline]
 kfree+0xe4/0x530 mm/slub.c:4264
 bdev_free_inode+0xe0/0x110 fs/block_dev.c:816
 i_callback+0x3f/0x70 fs/inode.c:222
 rcu_do_batch kernel/rcu/tree.c:2550 [inline]
 rcu_core+0x7ab/0x1380 kernel/rcu/tree.c:2785
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:197
Code: 01 f0 4d 89 03 e9 63 fd ff ff b9 ff ff ff ff ba 08 00 00 00 4d 8b 03 48 0f bd ca 49 8b 45 00 48 63 c9 e9 64 ff ff ff 0f 1f 00 <65> 8b 05 f9 41 8c 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b
RSP: 0018:ffffc9000dccf1d8 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801c27d4c0 RSI: ffffffff815d5923 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8fceb8a7
R10: ffffffff815d5919 R11: 0000000000000000 R12: ffffffff84c5a900
R13: 0000000000000200 R14: dffffc0000000000 R15: ffffc9000dccf238
 console_unlock+0x7c9/0xc40 kernel/printk/printk.c:2653
 vprintk_emit+0x1ca/0x560 kernel/printk/printk.c:2174
 vprintk+0x8d/0x260 kernel/printk/printk_safe.c:392
 printk+0xba/0xed kernel/printk/printk.c:2216
 nbd_genl_connect.cold+0x157/0x16f drivers/block/nbd.c:1852
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f69709a7188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 0000000020000540 RDI: 0000000000000006
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffca6ecd5bf R14: 00007f69709a7300 R15: 0000000000022000

Allocated by task 11042:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 kmalloc_node include/linux/slab.h:609 [inline]
 kzalloc_node include/linux/slab.h:732 [inline]
 __alloc_disk_node+0x4e/0x380 block/genhd.c:1246
 __blk_mq_alloc_disk+0xec/0x190 block/blk-mq.c:3145
 nbd_dev_add+0x2a9/0x940 drivers/block/nbd.c:1703
 nbd_genl_connect+0x551/0x1820 drivers/block/nbd.c:1842
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 11042:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1625 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
 slab_free mm/slub.c:3210 [inline]
 kfree+0xe4/0x530 mm/slub.c:4264
 __alloc_disk_node+0x2e8/0x380 block/genhd.c:1271
 __blk_mq_alloc_disk+0xec/0x190 block/blk-mq.c:3145
 nbd_dev_add+0x2a9/0x940 drivers/block/nbd.c:1703
 nbd_genl_connect+0x551/0x1820 drivers/block/nbd.c:1842
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888016977000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 512-byte region [ffff888016977000, ffff888016977200)
The buggy address belongs to the page:
page:ffffea00005a5d00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16974
head:ffffea00005a5d00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001164f00 0000000500000005 ffff888010841c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 824, ts 2603409140, free_ts 0
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1688 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1828
 new_slab mm/slub.c:1891 [inline]
 new_slab_objects mm/slub.c:2637 [inline]
 ___slab_alloc+0x473/0x7b0 mm/slub.c:2800
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2840
 slab_alloc_node mm/slub.c:2922 [inline]
 slab_alloc mm/slub.c:2964 [inline]
 kmem_cache_alloc_trace+0x30f/0x3c0 mm/slub.c:2981
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 alloc_bprm+0x51/0x8f0 fs/exec.c:1501
 kernel_execve+0x55/0x460 fs/exec.c:1941
 call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:112
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888016976f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888016976f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888016977000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888016977080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888016977100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

