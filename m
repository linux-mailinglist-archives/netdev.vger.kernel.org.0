Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D920419CE8C
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 04:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390315AbgDCCRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 22:17:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:40861 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389857AbgDCCRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 22:17:05 -0400
Received: by mail-io1-f70.google.com with SMTP id z207so4745404iof.7
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 19:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=y+8HK+h85w4Q9jlbcyJ5+b0iPhOLO2IN6ZUPUefI0x8=;
        b=I00awNACplvhyH5UJFEqEqCDuIoXJtkEnCXzi9jJiSyoX8Ng+SWsDTdoDrzMpTxU0K
         K6MuHgDMnh5YVRVIt3cO1yDKnd7wLrTPVIprFNDSKktz6uwZfI5lHnCTDRPGBMWWA0V3
         oqSRNtOspeKrs+PIGVhO0gmdt2t7M81FsjAC+JtkO6mmEearTyPt+azSiqONtxgUHBGq
         tj9aeAvQpnQWm0bSOluBk942NQLHssfAuquLYiOwF4PmO4O1ggWgCnhvVIb91tBncGdV
         W4GJ5CdF4UXJVvPAnbk/mGMTaKptSWW5hzPG8A2CQgx7CSRVsSqcWri3bunSmEhYJN6F
         a22w==
X-Gm-Message-State: AGi0PuZnEUgZLaK9G8os0flyBbzVkQ+mn+KdTv+lEXO5kxe6/UrI334o
        eWWnXivZpVGEEfPIy4GENfMFaFnyLXQAam1wyMdb5wNTxkGg
X-Google-Smtp-Source: APiQypICbk+thBcyxa06sEd+THmINScx39a45aYWn7GD2GqkDVfkCY8JGsq/tOFvDQ3vkhxb4NJGXFvJFgbX7u6j/nFXWIE+2keJ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:c50:: with SMTP id g16mr6006572jal.99.1585880224186;
 Thu, 02 Apr 2020 19:17:04 -0700 (PDT)
Date:   Thu, 02 Apr 2020 19:17:04 -0700
In-Reply-To: <CADG63jCRT=gcRK4RzQ8Gv4uyMkQ4LVGfczC587GLyfkb8F7-aw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006b48ec05a259830b@google.com>
Subject: Re: KASAN: use-after-free Read in ath9k_wmi_ctrl_rx
From:   syzbot <syzbot+5d338854440137ea0fef@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, anenbupt@gmail.com,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered crash:
KASAN: use-after-free Read in ath9k_wmi_ctrl_rx

==================================================================
BUG: KASAN: use-after-free in ath9k_wmi_ctrl_rx+0x416/0x500 drivers/net/wireless/ath/ath9k/wmi.c:229
Read of size 1 at addr ffff8881d335b17c by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 ath9k_wmi_ctrl_rx+0x416/0x500 drivers/net/wireless/ath/ath9k/wmi.c:229
 ath9k_htc_rx_msg+0x2d9/0xac0 drivers/net/wireless/ath/ath9k/htc_hst.c:460
 ath9k_hif_usb_reg_in_cb+0x1ba/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:718
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
 dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x950 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:default_idle+0x28/0x300 arch/x86/kernel/process.c:696
Code: cc cc 41 56 41 55 65 44 8b 2d 04 3b 72 7a 41 54 55 53 0f 1f 44 00 00 e8 b6 27 b5 fb e9 07 00 00 00 0f 00 2d aa d0 52 00 fb f4 <65> 44 8b 2d e0 3a 72 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffffff87007d80 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffffffff8702cc40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffffff8702d48c
RBP: fffffbfff0e05988 R08: ffffffff8702cc40 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff87e612c0 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_kernel+0xe16/0xe5a init/main.c:998
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

Allocated by task 169:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 ath9k_init_wmi+0x40/0x310 drivers/net/wireless/ath/ath9k/wmi.c:95
 ath9k_htc_probe_device+0x21c/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:953
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:502
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 169:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
 slab_free_hook mm/slub.c:1444 [inline]
 slab_free_freelist_hook mm/slub.c:1477 [inline]
 slab_free mm/slub.c:3034 [inline]
 kfree+0xd5/0x300 mm/slub.c:3995
 ath9k_htc_probe_device+0x278/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:970
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:502
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881d335b000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 380 bytes inside of
 2048-byte region [ffff8881d335b000, ffff8881d335b800)
The buggy address belongs to the page:
page:ffffea00074cd600 refcount:1 mapcount:0 mapping:ffff8881da00c000 index:0x0 compound_mapcount: 0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da00c000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881d335b000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881d335b080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881d335b100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff8881d335b180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881d335b200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=1666f28fe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a782c087b1f425c6
dashboard link: https://syzkaller.appspot.com/bug?extid=5d338854440137ea0fef
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=145bf733e00000

