Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164F24B1555
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343497AbiBJSgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:36:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343490AbiBJSgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:36:22 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC03C1C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:36:22 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id k20-20020a5d91d4000000b0061299fad2fdso4624392ior.21
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:36:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GWhBiyTUrLboIIQZYJ28MAaBmH3oYah5X6xla8e9pNo=;
        b=rD5Fs9WVg4FpS/tArCtahGRW2yTbwe3AGklwxApfvFuB67aAcFMFaJu1mCLV8DnSox
         LXC+9hAka21zy27Fpe88Plyx3F7v4h048gjA0wi2FS2kDygeoFpLctV4/CAQ1oZUwK7e
         3B8+tAoobSTfxhU36cja1mZmwuS2s+gS6BytFYr92IbHrixNSb58P56ixORcZzllqBgE
         38bsP0re5AVwVXZVGBQZqTrvyKBXQ9oWQPu9w4E7joN9GDUoomC3kbXpxrTYU4Sq3bsB
         CRnpVTyK1wqdaRrPl5YsIzrl8JmKVVzQEzEC+yplHTKoveOlxRQXuFE0vH/+rqcEk89Z
         v0ug==
X-Gm-Message-State: AOAM5329uW6zZfm+uk7/93n9TOohPbKoQ+zSpv3zO6YGzQEuBO8Dw0gU
        cbpvQ7UMUQeOcZd5IsTb4nNRT3MG6oCELxm/nhOHax4w38cK
X-Google-Smtp-Source: ABdhPJy4o/7RU97CJco6AgWzHNaOPZmbkk64WmHqzza/gzRJeFR64UfzWIq36SbM0qEUHsDWtK/gVqb58u/ERI3JOYCSLQS+1mJV
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c7:: with SMTP id r7mr4767983ill.175.1644518182208;
 Thu, 10 Feb 2022 10:36:22 -0800 (PST)
Date:   Thu, 10 Feb 2022 10:36:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000013ca8105d7ae3ada@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in smc_fback_error_report
From:   syzbot <syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5a8fb33e5305 skmsg: convert struct sk_msg_sg::copy to a bi..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1367e028700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2d6c62e3ddb722a1
dashboard link: https://syzkaller.appspot.com/bug?extid=b425899ed22c6943e00b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in smc_fback_error_report+0x96/0xa0 net/smc/af_smc.c:664
Read of size 8 at addr ffff88801ca31aa8 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-rc2-syzkaller-00650-g5a8fb33e5305 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 smc_fback_error_report+0x96/0xa0 net/smc/af_smc.c:664
 sk_error_report+0x35/0x310 net/core/sock.c:340
 tcp_write_err net/ipv4/tcp_timer.c:71 [inline]
 tcp_write_timeout net/ipv4/tcp_timer.c:276 [inline]
 tcp_retransmit_timer+0x16c5/0x3360 net/ipv4/tcp_timer.c:512
 tcp_write_timer_handler+0x5e6/0xbc0 net/ipv4/tcp_timer.c:622
 tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:551
Code: 89 de e8 fd a0 2a f8 84 db 75 ac e8 14 9d 2a f8 e8 1f e2 30 f8 eb 0c e8 08 9d 2a f8 0f 00 2d 91 ad c3 00 e8 fc 9c 2a f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 77 9f 2a f8 48 85 db
RSP: 0018:ffffffff8b807d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff8b8bc6c0 RSI: ffffffff894ddb94 RDI: 0000000000000000
RBP: ffff88814479c864 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817ebdd8 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88814479c800 R14: ffff88814479c864 R15: ffff8880183ca004
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:687
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3e8/0x590 kernel/sched/idle.c:306
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
 start_kernel+0x47a/0x49b init/main.c:1138
 secondary_startup_64_no_verify+0xc3/0xcb
 </TASK>

Allocated by task 11777:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:586 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 tomoyo_path_symlink+0x94/0xe0 security/tomoyo/tomoyo.c:199
 security_path_symlink+0xdf/0x150 security/security.c:1168
 do_symlinkat+0x106/0x2e0 fs/namei.c:4323
 __do_sys_symlink fs/namei.c:4350 [inline]
 __se_sys_symlink fs/namei.c:4348 [inline]
 __x64_sys_symlink+0x75/0x90 fs/namei.c:4348
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 11777:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x130/0x160 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kfree+0xcb/0x280 mm/slub.c:4562
 tomoyo_realpath_from_path+0x191/0x620 security/tomoyo/realpath.c:291
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 tomoyo_path_symlink+0x94/0xe0 security/tomoyo/tomoyo.c:199
 security_path_symlink+0xdf/0x150 security/security.c:1168
 do_symlinkat+0x106/0x2e0 fs/namei.c:4323
 __do_sys_symlink fs/namei.c:4350 [inline]
 __se_sys_symlink fs/namei.c:4348 [inline]
 __x64_sys_symlink+0x75/0x90 fs/namei.c:4348
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801ca30000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2728 bytes to the right of
 4096-byte region [ffff88801ca30000, ffff88801ca31000)
The buggy address belongs to the page:
page:ffffea0000728c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ca30
head:ffffea0000728c00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea0001370e00 dead000000000002 ffff888010c42140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 10850, ts 291204293565, free_ts 291180249958
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab mm/slub.c:1944 [inline]
 new_slab+0x28a/0x3b0 mm/slub.c:2004
 ___slab_alloc+0x87c/0xe90 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 __kmalloc+0x2fb/0x340 mm/slub.c:4420
 kmalloc include/linux/slab.h:586 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1337
 vfs_getattr fs/stat.c:157 [inline]
 vfs_statx+0x164/0x390 fs/stat.c:225
 vfs_fstatat fs/stat.c:243 [inline]
 __do_sys_newfstatat+0x96/0x120 fs/stat.c:412
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 __unfreeze_partials+0x320/0x340 mm/slub.c:2536
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x6d/0x160 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x202/0x3a0 mm/slub.c:3243
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags include/linux/audit.h:323 [inline]
 getname+0x8e/0xd0 fs/namei.c:217
 do_sys_openat2+0xf5/0x4d0 fs/open.c:1208
 do_sys_open fs/open.c:1230 [inline]
 __do_sys_openat fs/open.c:1246 [inline]
 __se_sys_openat fs/open.c:1241 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1241
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88801ca31980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801ca31a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801ca31a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                  ^
 ffff88801ca31b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801ca31b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
----------------
Code disassembly (best guess):
   0:	89 de                	mov    %ebx,%esi
   2:	e8 fd a0 2a f8       	callq  0xf82aa104
   7:	84 db                	test   %bl,%bl
   9:	75 ac                	jne    0xffffffb7
   b:	e8 14 9d 2a f8       	callq  0xf82a9d24
  10:	e8 1f e2 30 f8       	callq  0xf830e234
  15:	eb 0c                	jmp    0x23
  17:	e8 08 9d 2a f8       	callq  0xf82a9d24
  1c:	0f 00 2d 91 ad c3 00 	verw   0xc3ad91(%rip)        # 0xc3adb4
  23:	e8 fc 9c 2a f8       	callq  0xf82a9d24
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	9c                   	pushfq <-- trapping instruction
  2b:	5b                   	pop    %rbx
  2c:	81 e3 00 02 00 00    	and    $0x200,%ebx
  32:	fa                   	cli
  33:	31 ff                	xor    %edi,%edi
  35:	48 89 de             	mov    %rbx,%rsi
  38:	e8 77 9f 2a f8       	callq  0xf82a9fb4
  3d:	48 85 db             	test   %rbx,%rbx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
