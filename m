Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9E6169F6A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgBXHkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:40:16 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:43008 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBXHkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:40:15 -0500
Received: by mail-io1-f72.google.com with SMTP id v15so14039811iol.10
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:40:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=787IVEtTAp4pm7jHKW0atIbdisWqmLyVEo9pOI1dOQI=;
        b=ikfVg7vcGIxzTAfMaMsU3jxNBDaCHdSL6zXLYt4Q+aB0ZA5kYoyeu/DLe9n0JxmAq+
         3sF5LQ67kRfj6vK6+IB6/ncsyrvRW0ZQoEWs4ScAQZCOqlfQ9yExDfsKTTTcHOZQeQIp
         kxuoH923Xo1SDPAko9jObmd39afP38D9l3w6WdWaRWZgGlxCOQnELU+P0Re9QhgXGire
         xNMTRa6Lxp9TifFR8VCov3MxQHtcWN3CrUN91q+RZLv0C2rIDEcAMvZXhUwQg9/UZ2Ib
         GfYx8ukcRZxo93jcDPxIKbbRCxVFuTnmf4IZGQdtlpfl98zCFvobUddY59L+CoLIxp98
         Ya1Q==
X-Gm-Message-State: APjAAAXH6jCTA8nhDikWwKu1+taggMd5ZHYI4L8VpNpEBEPui0kDk8kG
        NVU6mjAmAFbXdusz2N8f0bv2xcov+BuOZuh2exmPjRNK8Sv3
X-Google-Smtp-Source: APXvYqzJh3mHUMyngPpafir7PkO10lHNmm+YWTAev44v4xWmcR/3wA+00HcZ0KZGFfSTw+SOGPDCV0sVulyssalTAFNQp3RgJDEj
MIME-Version: 1.0
X-Received: by 2002:a02:a415:: with SMTP id c21mr48112323jal.45.1582530013025;
 Sun, 23 Feb 2020 23:40:13 -0800 (PST)
Date:   Sun, 23 Feb 2020 23:40:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045dc96059f4d7b02@google.com>
Subject: KASAN: use-after-free Read in tcp_retransmit_timer (5)
From:   syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        kafai@fb.com, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    41f57cfd Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1460da7ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=768cc3d3e277cc16
dashboard link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+694120e1002c117747ed@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in tcp_retransmit_timer+0x2c51/0x30e0 net/ipv4/tcp_timer.c:500
Read of size 8 at addr ffff888062cc0338 by task syz-executor.0/18199

CPU: 0 PID: 18199 Comm: syz-executor.0 Not tainted 5.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 tcp_retransmit_timer+0x2c51/0x30e0 net/ipv4/tcp_timer.c:500
 tcp_write_timer_handler+0x6be/0x8d0 net/ipv4/tcp_timer.c:611
 tcp_write_timer+0xac/0x2e0 net/ipv4/tcp_timer.c:631
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:slab_alloc mm/slab.c:3313 [inline]
RIP: 0010:__do_kmalloc mm/slab.c:3654 [inline]
RIP: 0010:__kmalloc+0x2b8/0x770 mm/slab.c:3665
Code: 7e 0f 85 d6 fe ff ff e8 a7 af 4c ff e9 cc fe ff ff e8 4c 6d c7 ff 48 83 3d dc f5 ff 07 00 0f 84 4f 03 00 00 48 8b 7d c0 57 9d <0f> 1f 44 00 00 e9 5e fe ff ff 31 d2 be 35 02 00 00 48 c7 c7 de dd
RSP: 0018:ffffc900019675a8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: 0000000000000c40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8880569e29d8 RDI: 0000000000000282
RBP: ffffc90001967620 R08: ffff8880569e2140 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000001000
R13: 0000000000000c40 R14: ffff8880aa402000 R15: ffff8880962fa000
 kmalloc include/linux/slab.h:560 [inline]
 tomoyo_realpath_from_path+0xc5/0x660 security/tomoyo/realpath.c:252
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x2a3/0x3e0 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
 tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
 security_file_open+0x71/0x300 security/security.c:1529
 do_dentry_open+0x37a/0x1380 fs/open.c:784
 vfs_open+0xa0/0xd0 fs/open.c:914
 do_last fs/namei.c:3490 [inline]
 path_openat+0x12ee/0x3490 fs/namei.c:3607
 do_filp_open+0x192/0x260 fs/namei.c:3637
 do_sys_openat2+0x5eb/0x7e0 fs/open.c:1149
 do_sys_open+0xf2/0x180 fs/open.c:1165
 ksys_open include/linux/syscalls.h:1386 [inline]
 __do_sys_open fs/open.c:1171 [inline]
 __se_sys_open fs/open.c:1169 [inline]
 __x64_sys_open+0x7e/0xc0 fs/open.c:1169
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4161c0
Code: 05 48 3d 01 f0 ff ff 0f 83 2d 19 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 83 3d ad 22 87 00 00 75 14 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 04 19 00 00 c3 48 83 ec 08 e8 0a fa ff ff
RSP: 002b:00007ffd846aa178 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007ffd846aa1a4 RCX: 00000000004161c0
RDX: 00007ffd846aa1aa RSI: 0000000000080001 RDI: 00000000004c1fef
RBP: 00007ffd846aa1a0 R08: 0000000000008040 R09: 0000000000000004
R10: 0000000000000075 R11: 0000000000000246 R12: 00000000004c1fef
R13: 00007ffd846aa6c0 R14: 0000000000000000 R15: 00007ffd846aa6d0

Allocated by task 2861:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
 __do_kmalloc_node mm/slab.c:3616 [inline]
 __kmalloc_node_track_caller+0x4e/0x70 mm/slab.c:3630
 __kmalloc_reserve.isra.0+0x40/0xf0 net/core/skbuff.c:142
 __alloc_skb+0x10b/0x5e0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1081 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:324 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:376 [inline]
 nsim_dev_trap_report_work+0x25c/0xaf0 drivers/net/netdevsim/dev.c:415
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 2861:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 skb_free_head+0x93/0xb0 net/core/skbuff.c:590
 skb_release_data+0x43c/0x8b0 net/core/skbuff.c:610
 skb_release_all+0x4d/0x60 net/core/skbuff.c:664
 __kfree_skb net/core/skbuff.c:678 [inline]
 consume_skb net/core/skbuff.c:837 [inline]
 consume_skb+0xfb/0x410 net/core/skbuff.c:831
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:390 [inline]
 nsim_dev_trap_report_work+0x7cb/0xaf0 drivers/net/netdevsim/dev.c:415
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888062cc0000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 824 bytes inside of
 4096-byte region [ffff888062cc0000, ffff888062cc1000)
The buggy address belongs to the page:
page:ffffea00018b3000 refcount:1 mapcount:0 mapping:ffff8880aa402000 index:0x0 compound_mapcount: 0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00024ce208 ffffea00029a7b08 ffff8880aa402000
raw: 0000000000000000 ffff888062cc0000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888062cc0200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888062cc0280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888062cc0300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888062cc0380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888062cc0400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
