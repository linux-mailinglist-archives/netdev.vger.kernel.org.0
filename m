Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1871CD9
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388167AbfGWQYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 12:24:32 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35031 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfGWQYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 12:24:31 -0400
Received: by mail-io1-f68.google.com with SMTP id m24so83158911ioo.2
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 09:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s0W10oDCE4rcVok9tHehlx4XJnvSqNTVmIbMO9jj6GE=;
        b=VpWCqJEEFjtLMPvWFBpdp5vhxzroARnZnruzHc1cRAbxTGZRFWswp79H/Wookc2lhS
         wKEv+m/AG8Y49TmkwJEjYLJ/TdJ/rgH94It0nDnNKzbTne6cnCnC5vbO0CWlxD04l9wP
         G9b3Keawx2ftkWkwPZTnkaABM5Zno35vLgs+RcQYN4CfbLjbVlJ1JCq/rNWnylqW0uhZ
         oJnIn3BjKgr0UHQiwM7yq7y/GFXmRUUGLyRdYszdbm+SW37KnyMhLUeqzzcmBMBQ0hlA
         XeQowhxwiSEyoIcfgqZsZ+qm/CmemIVpte1aWi0Oonwt/RFafKyWJspYQCL6hObsiMwd
         Hg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s0W10oDCE4rcVok9tHehlx4XJnvSqNTVmIbMO9jj6GE=;
        b=XVPhuKQGCSH1YqNqZw4tBoG/PJlHW1cwb+LdTrNGhvXvlHKXI1jxx8BA0W2QCKTIMp
         zFstQ9vAdFt0uniNejKi16rLuz3UxNfQneGYMlDs6c2PCuprUIOLFtxAzZt4dzE9Tctt
         0Ao37zpCTNKakVIJInAMmPeI4gfy+s9Fg1sAz0lFRHpRE8sodLvCSKYeUMOH9kxoxQAx
         6EwK0SrLPKPhVhAIYLsYXaxEWEjbio5Dwcwh2M0QE/+1+7Sft+FGpWpzo2BLGb7qBpcM
         ARea7JRa0WFpP0xuIvhLxtk1rHkoNgqW2UcvOaAiuJmwMlBgZqTsUp4HzAFOSJ8dhA/E
         STXQ==
X-Gm-Message-State: APjAAAU3LhjMWKCnoR3n2Kp+u883RRXjgh3sjVm+zTwWG/2DoY/S5qjf
        St0CUvtznC3Xoj1uvwfRwfRQkb5nEemXOII4m2b7lA==
X-Google-Smtp-Source: APXvYqxLIq5vy7pJGGQAYsQcJmxc7Pa45WbKCLL1dLe5ymputmucw/RaYJPhlGyHG6a0LYh4ExbaVJWRK4v5WZDmEEg=
X-Received: by 2002:a6b:b556:: with SMTP id e83mr69678605iof.94.1563899070081;
 Tue, 23 Jul 2019 09:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006241fe058e5b9490@google.com>
In-Reply-To: <0000000000006241fe058e5b9490@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 23 Jul 2019 18:24:18 +0200
Message-ID: <CACT4Y+ZrO3Zss=S64TubS-vUHjcwopn2X2CFsckzu51Pm4WOWw@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in nr_insert_socket
To:     syzbot <syzbot+5e54e8e637bc970bbd2b@syzkaller.appspotmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Miller <davem@davemloft.net>,
        linux-hams <linux-hams@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 6:21 PM syzbot
<syzbot+5e54e8e637bc970bbd2b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=178a5c10600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3c8985c08e1f9727
> dashboard link: https://syzkaller.appspot.com/bug?extid=5e54e8e637bc970bbd2b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+5e54e8e637bc970bbd2b@syzkaller.appspotmail.com

+net/netrom/af_netrom.c maintainers

> ==================================================================
> BUG: KASAN: use-after-free in atomic_try_cmpxchg
> /./include/asm-generic/atomic-instrumented.h:693 [inline]
> BUG: KASAN: use-after-free in refcount_inc_not_zero_checked+0xef/0x200
> /lib/refcount.c:134
> Write of size 4 at addr ffff88805b0a2d00 by task syz-executor.1/29302
>
> CPU: 1 PID: 29302 Comm: syz-executor.1 Not tainted 5.2.0+ #64
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   <IRQ>
>   __dump_stack /lib/dump_stack.c:77 [inline]
>   dump_stack+0x16f/0x1f0 /lib/dump_stack.c:113
>   print_address_description.cold+0xd4/0x306 /mm/kasan/report.c:351
>   __kasan_report.cold+0x1b/0x36 /mm/kasan/report.c:482
>   kasan_report+0x12/0x17 /mm/kasan/common.c:612
>   check_memory_region_inline /mm/kasan/generic.c:185 [inline]
>   check_memory_region+0x134/0x1a0 /mm/kasan/generic.c:192
>   __kasan_check_write+0x14/0x20 /mm/kasan/common.c:98
>   atomic_try_cmpxchg /./include/asm-generic/atomic-instrumented.h:693
> [inline]
>   refcount_inc_not_zero_checked+0xef/0x200 /lib/refcount.c:134
>   refcount_inc_checked+0x17/0x70 /lib/refcount.c:156
>   sock_hold /./include/net/sock.h:649 [inline]
>   sk_add_node /./include/net/sock.h:701 [inline]
>   nr_insert_socket+0x2d/0xe0 /net/netrom/af_netrom.c:137
>   nr_rx_frame+0x1605/0x1e73 /net/netrom/af_netrom.c:1023
>   nr_loopback_timer+0x7b/0x170 /net/netrom/nr_loopback.c:59
>   call_timer_fn+0x1ac/0x700 /kernel/time/timer.c:1322
>   expire_timers /kernel/time/timer.c:1366 [inline]
>   __run_timers /kernel/time/timer.c:1685 [inline]
>   __run_timers /kernel/time/timer.c:1653 [inline]
>   run_timer_softirq+0x66c/0x16a0 /kernel/time/timer.c:1698
>   __do_softirq+0x30d/0x970 /kernel/softirq.c:292
>   invoke_softirq /kernel/softirq.c:373 [inline]
>   irq_exit+0x1d0/0x200 /kernel/softirq.c:413
>   exiting_irq /./arch/x86/include/asm/apic.h:537 [inline]
>   smp_apic_timer_interrupt+0x14e/0x550 /arch/x86/kernel/apic/apic.c:1095
>   apic_timer_interrupt+0xf/0x20 /arch/x86/entry/entry_64.S:828
>   </IRQ>
> RIP: 0010:__preempt_count_sub /./arch/x86/include/asm/preempt.h:84 [inline]
> RIP: 0010:__raw_spin_unlock_irq /./include/linux/spinlock_api_smp.h:169
> [inline]
> RIP: 0010:_raw_spin_unlock_irq+0x54/0x70 /kernel/locking/spinlock.c:199
> Code: c0 a0 e3 d2 88 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00
> 75 1e 48 83 3d d5 65 a0 01 00 74 12 fb 66 0f 1f 44 00 00 <65> ff 0d ad 7f
> cf 78 41 5c 5d c3 0f 0b 48 c7 c7 a0 e3 d2 88 e8 d3
> RSP: 0018:ffff88808fc87370 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff11a5c74 RBX: ffff888092ace300 RCX: 0000000000000006
> RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff888092aceb4c
> RBP: ffff88808fc87378 R08: 1ffffffff14a6d50 R09: fffffbfff14a6d51
> R10: fffffbfff14a6d50 R11: ffffffff8a536a87 R12: ffff8880ae935380
> R13: ffff888053dde280 R14: 0000000000000000 R15: 0000000000000001
>   finish_lock_switch /kernel/sched/core.c:3004 [inline]
>   finish_task_switch+0x11d/0x690 /kernel/sched/core.c:3104
>   context_switch /kernel/sched/core.c:3257 [inline]
>   __schedule+0x77a/0x1530 /kernel/sched/core.c:3880
>   preempt_schedule_common+0x35/0x70 /kernel/sched/core.c:4025
>   _cond_resched+0x1d/0x30 /kernel/sched/core.c:5423
>   generic_perform_write+0x332/0x540 /mm/filemap.c:3344
>   __generic_file_write_iter+0x25e/0x630 /mm/filemap.c:3456
>   ext4_file_write_iter+0x373/0x1430 /fs/ext4/file.c:270
>   call_write_iter /./include/linux/fs.h:1870 [inline]
>   do_iter_readv_writev+0x5f8/0x8f0 /fs/read_write.c:693
>   do_iter_write /fs/read_write.c:970 [inline]
>   do_iter_write+0x184/0x610 /fs/read_write.c:951
>   vfs_iter_write+0x77/0xb0 /fs/read_write.c:983
>   iter_file_splice_write+0x66d/0xbe0 /fs/splice.c:746
>   do_splice_from /fs/splice.c:848 [inline]
>   direct_splice_actor+0x123/0x190 /fs/splice.c:1020
>   splice_direct_to_actor+0x366/0x970 /fs/splice.c:975
>   do_splice_direct+0x1da/0x2a0 /fs/splice.c:1063
>   do_sendfile+0x597/0xd00 /fs/read_write.c:1464
>   __do_sys_sendfile64 /fs/read_write.c:1519 [inline]
>   __se_sys_sendfile64 /fs/read_write.c:1511 [inline]
>   __x64_sys_sendfile64+0x15a/0x220 /fs/read_write.c:1511
>   do_syscall_64+0xfd/0x6a0 /arch/x86/entry/common.c:296
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x459829
> Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fe4c4360c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000459829
> RDX: 0000000020000080 RSI: 0000000000000003 RDI: 0000000000000003
> RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000a198 R11: 0000000000000246 R12: 00007fe4c43616d4
> R13: 00000000004c6e87 R14: 00000000004dc238 R15: 00000000ffffffff
>
> Allocated by task 29302:
>   save_stack+0x23/0x90 /mm/kasan/common.c:69
>   set_track /mm/kasan/common.c:77 [inline]
>   __kasan_kmalloc /mm/kasan/common.c:487 [inline]
>   __kasan_kmalloc.constprop.0+0xcf/0xe0 /mm/kasan/common.c:460
>   kasan_kmalloc+0x9/0x10 /mm/kasan/common.c:501
>   __do_kmalloc /mm/slab.c:3655 [inline]
>   __kmalloc+0x163/0x760 /mm/slab.c:3664
>   kmalloc /./include/linux/slab.h:557 [inline]
>   sk_prot_alloc+0x23a/0x310 /net/core/sock.c:1603
>   sk_alloc+0x39/0xf60 /net/core/sock.c:1657
>   nr_make_new /net/netrom/af_netrom.c:476 [inline]
>   nr_rx_frame+0x733/0x1e73 /net/netrom/af_netrom.c:959
>   nr_loopback_timer+0x7b/0x170 /net/netrom/nr_loopback.c:59
>   call_timer_fn+0x1ac/0x700 /kernel/time/timer.c:1322
>   expire_timers /kernel/time/timer.c:1366 [inline]
>   __run_timers /kernel/time/timer.c:1685 [inline]
>   __run_timers /kernel/time/timer.c:1653 [inline]
>   run_timer_softirq+0x66c/0x16a0 /kernel/time/timer.c:1698
>   __do_softirq+0x30d/0x970 /kernel/softirq.c:292
>
> Freed by task 29300:
>   save_stack+0x23/0x90 /mm/kasan/common.c:69
>   set_track /mm/kasan/common.c:77 [inline]
>   __kasan_slab_free+0x102/0x150 /mm/kasan/common.c:449
>   kasan_slab_free+0xe/0x10 /mm/kasan/common.c:457
>   __cache_free /mm/slab.c:3425 [inline]
>   kfree+0x10a/0x2a0 /mm/slab.c:3756
>   sk_prot_free /net/core/sock.c:1640 [inline]
>   __sk_destruct+0x4f7/0x6e0 /net/core/sock.c:1726
>   sk_destruct+0x86/0xa0 /net/core/sock.c:1734
>   __sk_free+0xfb/0x360 /net/core/sock.c:1745
>   sk_free+0x42/0x50 /net/core/sock.c:1756
>   sock_put /./include/net/sock.h:1725 [inline]
>   sock_efree+0x61/0x80 /net/core/sock.c:2042
>   skb_release_head_state+0xeb/0x250 /net/core/skbuff.c:652
>   skb_release_all+0x16/0x60 /net/core/skbuff.c:663
>   __kfree_skb /net/core/skbuff.c:679 [inline]
>   kfree_skb /net/core/skbuff.c:697 [inline]
>   kfree_skb+0x101/0x380 /net/core/skbuff.c:691
>   nr_accept+0x56e/0x700 /net/netrom/af_netrom.c:819
>   __sys_accept4+0x34e/0x6a0 /net/socket.c:1754
>   __do_sys_accept4 /net/socket.c:1789 [inline]
>   __se_sys_accept4 /net/socket.c:1786 [inline]
>   __x64_sys_accept4+0x97/0xf0 /net/socket.c:1786
>   do_syscall_64+0xfd/0x6a0 /arch/x86/entry/common.c:296
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff88805b0a2c80
>   which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 128 bytes inside of
>   2048-byte region [ffff88805b0a2c80, ffff88805b0a3480)
> The buggy address belongs to the page:
> page:ffffea00016c2880 refcount:1 mapcount:0 mapping:ffff8880aa400e00
> index:0x0 compound_mapcount: 0
> flags: 0x1fffc0000010200(slab|head)
> raw: 01fffc0000010200 ffffea000180bc08 ffffea00025aef08 ffff8880aa400e00
> raw: 0000000000000000 ffff88805b0a2400 0000000100000003 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff88805b0a2c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff88805b0a2c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff88805b0a2d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff88805b0a2d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88805b0a2e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> ------------[ cut here ]------------
> ODEBUG: activate not available (active state 0) object type: timer_list
> hint: nr_heartbeat_expiry+0x0/0x410 /net/netrom/nr_timer.c:52
> WARNING: CPU: 1 PID: 29302 at lib/debugobjects.c:481
> debug_print_object+0x168/0x250 /lib/debugobjects.c:481
> Modules linked in:
> CPU: 1 PID: 29302 Comm: syz-executor.1 Tainted: G    B             5.2.0+
> #64
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:debug_print_object+0x168/0x250 /lib/debugobjects.c:481
> Code: dd 80 02 c6 87 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48
> 8b 14 dd 80 02 c6 87 48 c7 c7 80 f7 c5 87 e8 60 0d 09 fe <0f> 0b 83 05 e3
> 68 6a 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
> RSP: 0018:ffff8880ae9099d0 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> RDX: 0000000000000100 RSI: ffffffff815b9de2 RDI: ffffed1015d2132c
> RBP: ffff8880ae909a10 R08: ffff888092ace300 R09: fffffbfff13494e8
> R10: fffffbfff13494e7 R11: ffffffff89a4a73f R12: 0000000000000001
> R13: ffffffff88db3f40 R14: ffffffff8160d430 R15: 1ffff11015d21348
> FS:  00007fe4c4361700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2e620000 CR3: 000000007bf8a000 CR4: 00000000001406e0
> Call Trace:
>   <IRQ>
>   debug_object_activate+0x2e5/0x470 /lib/debugobjects.c:680
>   debug_timer_activate /kernel/time/timer.c:710 [inline]
>   __mod_timer /kernel/time/timer.c:1035 [inline]
>   mod_timer+0x415/0xb90 /kernel/time/timer.c:1096
>   sk_reset_timer+0x24/0x60 /net/core/sock.c:2821
>   nr_start_heartbeat+0x47/0x60 /net/netrom/nr_timer.c:79
>   nr_rx_frame+0x160d/0x1e73 /net/netrom/af_netrom.c:1025
>   nr_loopback_timer+0x7b/0x170 /net/netrom/nr_loopback.c:59
>   call_timer_fn+0x1ac/0x700 /kernel/time/timer.c:1322
>   expire_timers /kernel/time/timer.c:1366 [inline]
>   __run_timers /kernel/time/timer.c:1685 [inline]
>   __run_timers /kernel/time/timer.c:1653 [inline]
>   run_timer_softirq+0x66c/0x16a0 /kernel/time/timer.c:1698
>   __do_softirq+0x30d/0x970 /kernel/softirq.c:292
>   invoke_softirq /kernel/softirq.c:373 [inline]
>   irq_exit+0x1d0/0x200 /kernel/softirq.c:413
>   exiting_irq /./arch/x86/include/asm/apic.h:537 [inline]
>   smp_apic_timer_interrupt+0x14e/0x550 /arch/x86/kernel/apic/apic.c:1095
>   apic_timer_interrupt+0xf/0x20 /arch/x86/entry/entry_64.S:828
>   </IRQ>
> RIP: 0010:__preempt_count_sub /./arch/x86/include/asm/preempt.h:84 [inline]
> RIP: 0010:__raw_spin_unlock_irq /./include/linux/spinlock_api_smp.h:169
> [inline]
> RIP: 0010:_raw_spin_unlock_irq+0x54/0x70 /kernel/locking/spinlock.c:199
> Code: c0 a0 e3 d2 88 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00
> 75 1e 48 83 3d d5 65 a0 01 00 74 12 fb 66 0f 1f 44 00 00 <65> ff 0d ad 7f
> cf 78 41 5c 5d c3 0f 0b 48 c7 c7 a0 e3 d2 88 e8 d3
> RSP: 0018:ffff88808fc87370 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff11a5c74 RBX: ffff888092ace300 RCX: 0000000000000006
> RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff888092aceb4c
> RBP: ffff88808fc87378 R08: 1ffffffff14a6d50 R09: fffffbfff14a6d51
> R10: fffffbfff14a6d50 R11: ffffffff8a536a87 R12: ffff8880ae935380
> R13: ffff888053dde280 R14: 0000000000000000 R15: 0000000000000001
>   finish_lock_switch /kernel/sched/core.c:3004 [inline]
>   finish_task_switch+0x11d/0x690 /kernel/sched/core.c:3104
>   context_switch /kernel/sched/core.c:3257 [inline]
>   __schedule+0x77a/0x1530 /kernel/sched/core.c:3880
>   preempt_schedule_common+0x35/0x70 /kernel/sched/core.c:4025
>   _cond_resched+0x1d/0x30 /kernel/sched/core.c:5423
>   generic_perform_write+0x332/0x540 /mm/filemap.c:3344
>   __generic_file_write_iter+0x25e/0x630 /mm/filemap.c:3456
>   ext4_file_write_iter+0x373/0x1430 /fs/ext4/file.c:270
>   call_write_iter /./include/linux/fs.h:1870 [inline]
>   do_iter_readv_writev+0x5f8/0x8f0 /fs/read_write.c:693
>   do_iter_write /fs/read_write.c:970 [inline]
>   do_iter_write+0x184/0x610 /fs/read_write.c:951
>   vfs_iter_write+0x77/0xb0 /fs/read_write.c:983
>   iter_file_splice_write+0x66d/0xbe0 /fs/splice.c:746
>   do_splice_from /fs/splice.c:848 [inline]
>   direct_splice_actor+0x123/0x190 /fs/splice.c:1020
>   splice_direct_to_actor+0x366/0x970 /fs/splice.c:975
>   do_splice_direct+0x1da/0x2a0 /fs/splice.c:1063
>   do_sendfile+0x597/0xd00 /fs/read_write.c:1464
>   __do_sys_sendfile64 /fs/read_write.c:1519 [inline]
>   __se_sys_sendfile64 /fs/read_write.c:1511 [inline]
>   __x64_sys_sendfile64+0x15a/0x220 /fs/read_write.c:1511
>   do_syscall_64+0xfd/0x6a0 /arch/x86/entry/common.c:296
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x459829
> Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fe4c4360c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000459829
> RDX: 0000000020000080 RSI: 0000000000000003 RDI: 0000000000000003
> RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000a198 R11: 0000000000000246 R12: 00007fe4c43616d4
> R13: 00000000004c6e87 R14: 00000000004dc238 R15: 00000000ffffffff
> irq event stamp: 9211
> hardirqs last  enabled at (9210): [<ffffffff8100651a>]
> trace_hardirqs_on_thunk+0x1a/0x20 /arch/x86/entry/thunk_64.S:41
> hardirqs last disabled at (9211): [<ffffffff8732831f>]
> __raw_spin_lock_irqsave /./include/linux/spinlock_api_smp.h:108 [inline]
> hardirqs last disabled at (9211): [<ffffffff8732831f>]
> _raw_spin_lock_irqsave+0x6f/0xd0 /kernel/locking/spinlock.c:159
> softirqs last  enabled at (8598): [<ffffffff8760069a>]
> __do_softirq+0x69a/0x970 /kernel/softirq.c:319
> softirqs last disabled at (8879): [<ffffffff814526b0>] invoke_softirq
> /kernel/softirq.c:373 [inline]
> softirqs last disabled at (8879): [<ffffffff814526b0>] irq_exit+0x1d0/0x200
> /kernel/softirq.c:413
> ---[ end trace 1f19b790eed0288b ]---
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000006241fe058e5b9490%40google.com.
