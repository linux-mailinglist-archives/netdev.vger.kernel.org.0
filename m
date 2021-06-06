Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDB939D193
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 23:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhFFVSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 17:18:06 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36731 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhFFVSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 17:18:05 -0400
Received: by mail-il1-f197.google.com with SMTP id s5-20020a056e021a05b02901e07d489107so11037173ild.3
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 14:16:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DZ7ysi4BAmWIw1RDkjP8SZ5jsY/CCu87JjCZcaB+ABA=;
        b=XpZeCGzsRi3zErP/GP+FYzNiZO3NQuLp+gZjvltfLXwcL1dvfbhtdutQE6tpx7YpMp
         e7S3yFUkT1/A3xCBf4n1cxk3LI1dA5xWT+NuEWFFX2V1xllRLCXAMebtMM2aRg6zCs93
         pzg41GT2iT21cZQX5iUSsUFtSlaBX2Ol1RENVgXoLP+qqaWGE5I35V/OadBaSb6P8gnC
         wsXPFp1sh9Vg0kT8Q9+jel2TcpfJcYt5mQpTCcDE3EDKx7dyLego2uYYtU24+MMTXEeL
         BMaUktETc02HAh8YetRgep6EmzcWnIp0oxCwVDEONLPo0haO30yvuB4socee8IJRXm89
         TCrA==
X-Gm-Message-State: AOAM5325Rd4/ZdE4KP3ejmfIbUibQea3y2FAERxfAMil2CCL429mzedu
        pkCy26IgZI+vuiFT1rtyj0CwPRyEJoeWa+bkD8QmCTVs0+VX
X-Google-Smtp-Source: ABdhPJzBpeO/0cQT8a86p0CxmfFNeE3LFV6QLkV5o0G9+ZV6sqhux9xWP/y+5aaXzU5oAaVpK04oOVnOqlUSQ6aHa2jF6AMxk9Ry
MIME-Version: 1.0
X-Received: by 2002:a92:cbcc:: with SMTP id s12mr12603988ilq.229.1623014175218;
 Sun, 06 Jun 2021 14:16:15 -0700 (PDT)
Date:   Sun, 06 Jun 2021 14:16:15 -0700
In-Reply-To: <0000000000009e7a1905b8295829@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000061228e05c41f6fd6@google.com>
Subject: Re: [syzbot] KASAN: out-of-bounds Read in ath9k_hif_usb_rx_cb (3)
From:   syzbot <syzbot+3f1ca6a6fec34d601788@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    f5b6eb1e Merge branch 'i2c/for-current' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12fa1797d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a9e9956ca52a5f6
dashboard link: https://syzkaller.appspot.com/bug?extid=3f1ca6a6fec34d601788
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=158914ebd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17720670300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f1ca6a6fec34d601788@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:636 [inline]
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_cb+0xdd8/0x1050 drivers/net/wireless/ath/ath9k/hif_usb.c:680
Read of size 4 at addr ffff888036db4178 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:636 [inline]
 ath9k_hif_usb_rx_cb+0xdd8/0x1050 drivers/net/wireless/ath/ath9k/hif_usb.c:680
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1656
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1726
 dummy_timer+0x11f4/0x32a0 drivers/usb/gadget/udc/dummy_hcd.c:1978
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
 expire_timers kernel/time/timer.c:1476 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
 __run_timers kernel/time/timer.c:1726 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:132 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:513
Code: ed b0 5b f8 84 db 75 ac e8 34 aa 5b f8 e8 ef b9 61 f8 e9 0c 00 00 00 e8 25 aa 5b f8 0f 00 2d 5e 48 b5 00 e8 19 aa 5b f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 24 b2 5b f8 48 85 db
RSP: 0018:ffffc90000d57d18 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880123dd4c0 RSI: ffffffff89193267 RDI: 0000000000000000
RBP: ffff8881427b7864 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817aec78 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8881427b7800 R14: ffff8881427b7864 R15: ffff88801c850804
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:648
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3e8/0x590 kernel/sched/idle.c:306
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
 start_secondary+0x274/0x350 arch/x86/kernel/smpboot.c:272
 secondary_startup_64_no_verify+0xb0/0xbb

Allocated by task 11245:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:516
 kmalloc include/linux/slab.h:561 [inline]
 raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:593 [inline]
 raw_alloc_io_data+0x157/0x1c0 drivers/usb/gadget/legacy/raw_gadget.c:577
 raw_ioctl_ep0_read drivers/usb/gadget/legacy/raw_gadget.c:694 [inline]
 raw_ioctl+0x110b/0x2720 drivers/usb/gadget/legacy/raw_gadget.c:1223
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888036db4000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 376 bytes inside of
 4096-byte region [ffff888036db4000, ffff888036db5000)
The buggy address belongs to the page:
page:ffffea0000db6c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x36db0
head:ffffea0000db6c00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888011042140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4855, ts 492416671090, free_ts 492416389440
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1645 [inline]
 allocate_slab+0x2c5/0x4c0 mm/slub.c:1785
 new_slab mm/slub.c:1848 [inline]
 new_slab_objects mm/slub.c:2594 [inline]
 ___slab_alloc+0x4a1/0x810 mm/slub.c:2757
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2797
 slab_alloc_node mm/slub.c:2879 [inline]
 slab_alloc mm/slub.c:2921 [inline]
 __kmalloc+0x315/0x330 mm/slub.c:4055
 kmalloc include/linux/slab.h:561 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1332
 vfs_getattr fs/stat.c:139 [inline]
 vfs_fstat+0x43/0xb0 fs/stat.c:164
 __do_sys_newfstat+0x81/0x100 fs/stat.c:404
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1298 [inline]
 __free_pages_ok+0x476/0xce0 mm/page_alloc.c:1572
 device_release+0x9f/0x240 drivers/base/core.c:2190
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 put_device+0x1b/0x30 drivers/base/core.c:3432
 ath9k_htc_probe_device+0x1c7/0x1e50 drivers/net/wireless/ath/ath9k/htc_drv_init.c:976
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:503
 ath9k_hif_usb_firmware_cb+0x274/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1239
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1081
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Memory state around the buggy address:
 ffff888036db4000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888036db4080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888036db4100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                                                                ^
 ffff888036db4180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888036db4200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

