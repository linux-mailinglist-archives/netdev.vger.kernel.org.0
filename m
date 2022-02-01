Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EED4A56FE
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiBAFiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:38:21 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:51884 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiBAFiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:38:20 -0500
Received: by mail-il1-f199.google.com with SMTP id z11-20020a056e0217cb00b002bab54d8254so10996298ilu.18
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 21:38:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=anJUKQ2whukBlfrjgT5cEyfetmkKWRrMvSyM2oDT9dE=;
        b=S+gLYVn5wfurzdRHlhvJxZthNYZa8NrNtM0gKOi5AbR4jdIBWJlPTqsepSyyukTmO+
         6421IQHDelkKDgI7HzSBoaElgmuMwex0whPqim8rMkHfFr3zipkn/e9UyeDmsrdJFaj+
         o+PpVmDqjP9pGT4vYkz1QTUTRH4KxT3WzVv0tIAeixSIjkS8S5W0RZpWfOCdXWJi6cK5
         GmztCH4A0whWORa/LaMEKVe5MiqRIaTe/kDLd5g7WhAMporyywsWoFtDlYlogn8y1UQt
         gnk6NMRbbwv2YWvVL56g9YD91WSz0YR09RTdOoMb/ZVdIpA/wnpUbNKi9+sj2P9Kk+HC
         qvww==
X-Gm-Message-State: AOAM5300O+vZxMReh4eS00T8tmn9T/VCwzBx4MYoBNeSbNAhhXpTt3TS
        BtxR6dbxVrC1/+pQVVsFbrtBINFUT1dUZtaL/+VmpeNwoPbz
X-Google-Smtp-Source: ABdhPJyuWZidjUECtTaMLkYN802AUurGmR1Q/gUNMLrDzbrBOuaZa3WKCXqfocyT+JqkwHuk/2N2JcvPYudcAykjlVEdrCh4TQpE
MIME-Version: 1.0
X-Received: by 2002:a92:ca45:: with SMTP id q5mr13982285ilo.55.1643693899952;
 Mon, 31 Jan 2022 21:38:19 -0800 (PST)
Date:   Mon, 31 Jan 2022 21:38:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006b92e05d6ee4fce@google.com>
Subject: [syzbot] KASAN: use-after-free Read in ath9k_hif_usb_reg_in_cb (3)
From:   syzbot <syzbot+b05dabaed0b1f0b0a5e4@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    993a44fa85c1 usb: gadget: f_uac2: allow changing interface..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=149215e4700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d7c811a1a4d0135
dashboard link: https://syzkaller.appspot.com/bug?extid=b05dabaed0b1f0b0a5e4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b05dabaed0b1f0b0a5e4@syzkaller.appspotmail.com

usb 1-1: ath: unknown panic pattern!
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1098 [inline]
BUG: KASAN: use-after-free in kfree_skb_reason+0x33/0x400 net/core/skbuff.c:772
Read of size 4 at addr ffff88810feac35c by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-rc1-syzkaller-00028-g993a44fa85c1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 skb_unref include/linux/skbuff.h:1098 [inline]
 kfree_skb_reason+0x33/0x400 net/core/skbuff.c:772
 kfree_skb include/linux/skbuff.h:1114 [inline]
 ath9k_hif_usb_reg_in_cb+0x4c2/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:771
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1663
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1733
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x288/0x9a5 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x113/0x170 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:130 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:551
Code: 89 de e8 6d 8c 6e fb 84 db 75 ac e8 84 88 6e fb e8 af c3 74 fb eb 0c e8 78 88 6e fb 0f 00 2d 91 1f 75 00 e8 6c 88 6e fb fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 e7 8a 6e fb 48 85 db
RSP: 0018:ffffffff87607d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff87652680 RSI: ffffffff85d51c94 RDI: 0000000000000000
RBP: ffff888100378864 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8149e068 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888100378800 R14: ffff888100378864 R15: ffff88810a1b3004
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

Allocated by task 11515:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 kmem_cache_alloc_node+0x25e/0x4b0 mm/slub.c:3266
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1158 [inline]
 ath9k_hif_usb_alloc_reg_in_urbs drivers/net/wireless/ath/ath9k/hif_usb.c:964 [inline]
 ath9k_hif_usb_alloc_urbs+0x91d/0x1040 drivers/net/wireless/ath/ath9k/hif_usb.c:1023
 ath9k_hif_usb_dev_init drivers/net/wireless/ath/ath9k/hif_usb.c:1109 [inline]
 ath9k_hif_usb_firmware_cb+0x148/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1242
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1022
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2ef/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Freed by task 0:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfa/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook mm/slub.c:1754 [inline]
 slab_free mm/slub.c:3509 [inline]
 kmem_cache_free+0xd7/0x3c0 mm/slub.c:3526
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:700
 __kfree_skb net/core/skbuff.c:757 [inline]
 kfree_skb_reason net/core/skbuff.c:776 [inline]
 kfree_skb_reason+0x145/0x400 net/core/skbuff.c:770
 kfree_skb include/linux/skbuff.h:1114 [inline]
 ath9k_htc_rx_msg+0x1ed/0xb70 drivers/net/wireless/ath/ath9k/htc_hst.c:451
 ath9k_hif_usb_reg_in_cb+0x1ac/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:740
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1663
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1733
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x288/0x9a5 kernel/softirq.c:558

The buggy address belongs to the object at ffff88810feac280
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 220 bytes inside of
 232-byte region [ffff88810feac280, ffff88810feac368)
The buggy address belongs to the page:
page:ffffea00043fab00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10feac
flags: 0x200000000000200(slab|node=0|zone=2)
raw: 0200000000000200 ffffea00044de700 dead000000000003 ffff8881003d3640
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_HARDWALL), pid 1269, ts 548051559679, free_ts 548051333117
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0x122d/0x2940 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab mm/slub.c:1944 [inline]
 new_slab+0x28a/0x3b0 mm/slub.c:2004
 ___slab_alloc+0x81a/0xe60 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x3bb/0x480 mm/slub.c:3243
 skb_clone+0x170/0x3c0 net/core/skbuff.c:1519
 dev_queue_xmit_nit+0x38c/0xa90 net/core/dev.c:2211
 xmit_one net/core/dev.c:3468 [inline]
 dev_hard_start_xmit+0xad/0x920 net/core/dev.c:3489
 sch_direct_xmit+0x25b/0x7a0 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3700 [inline]
 __dev_queue_xmit+0x11b0/0x3200 net/core/dev.c:4081
 neigh_hh_output include/net/neighbour.h:525 [inline]
 neigh_output include/net/neighbour.h:539 [inline]
 ip_finish_output2+0x143f/0x20c0 net/ipv4/ip_output.c:221
 __ip_finish_output.part.0+0x1b7/0x350 net/ipv4/ip_output.c:299
 __ip_finish_output net/ipv4/ip_output.c:287 [inline]
 ip_finish_output net/ipv4/ip_output.c:309 [inline]
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x2ed/0x5f0 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:451 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 __ip_queue_xmit+0x984/0x1b80 net/ipv4/ip_output.c:525
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x361/0x760 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x580 mm/page_alloc.c:3404
 __put_single_page mm/swap.c:99 [inline]
 __put_page+0x103/0x140 mm/swap.c:130
 folio_put include/linux/mm.h:1199 [inline]
 put_page include/linux/mm.h:1237 [inline]
 anon_pipe_buf_release+0x1d9/0x280 fs/pipe.c:138
 pipe_buf_release include/linux/pipe_fs_i.h:203 [inline]
 pipe_read+0x6e4/0x11b0 fs/pipe.c:323
 call_read_iter include/linux/fs.h:2068 [inline]
 new_sync_read+0x5c2/0x6e0 fs/read_write.c:400
 vfs_read+0x35c/0x600 fs/read_write.c:481
 ksys_read+0x1ee/0x250 fs/read_write.c:619
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88810feac200: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
 ffff88810feac280: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88810feac300: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
                                                    ^
 ffff88810feac380: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
 ffff88810feac400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	89 de                	mov    %ebx,%esi
   2:	e8 6d 8c 6e fb       	callq  0xfb6e8c74
   7:	84 db                	test   %bl,%bl
   9:	75 ac                	jne    0xffffffb7
   b:	e8 84 88 6e fb       	callq  0xfb6e8894
  10:	e8 af c3 74 fb       	callq  0xfb74c3c4
  15:	eb 0c                	jmp    0x23
  17:	e8 78 88 6e fb       	callq  0xfb6e8894
  1c:	0f 00 2d 91 1f 75 00 	verw   0x751f91(%rip)        # 0x751fb4
  23:	e8 6c 88 6e fb       	callq  0xfb6e8894
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	9c                   	pushfq <-- trapping instruction
  2b:	5b                   	pop    %rbx
  2c:	81 e3 00 02 00 00    	and    $0x200,%ebx
  32:	fa                   	cli
  33:	31 ff                	xor    %edi,%edi
  35:	48 89 de             	mov    %rbx,%rsi
  38:	e8 e7 8a 6e fb       	callq  0xfb6e8b24
  3d:	48 85 db             	test   %rbx,%rbx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
