Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA4419E02F
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 23:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgDCVNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 17:13:05 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:36180 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgDCVNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 17:13:05 -0400
Received: by mail-il1-f198.google.com with SMTP id e5so8326435ilg.3
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 14:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wy3lpNU7WmEaGyZrYQCN+Owhy5EFfLkQGobsgJD88SY=;
        b=aHBWoBSPBXej8t41ereoihiVjR/VQi4zhWaJEiC2UDm/VP2VvGa0fSXh4bQ8ou5fVA
         RiHHIHxBgMdLhCWIiE/Bjr/INr3rqRoMqtZavVoJhlkMjYe/7cBQsTM05OcbVMy99l+v
         h4caxm/Z+Ev7CNGvO8tpOL/8+HFzpA1By/Obw4l3FsWZhvu46o4sOYvRdnPxDq78YuAg
         ionFjaKQC1NqHggbtZrsAlny7GL+/fQfb6qVeSyYpEyOyvmDKVSghCYj410wtww/3G2Q
         etSVj4Dr6MO8B7yxnqa/k2IN3O3CXwr3/xbmVSbe491B7/Ki3LR+Et4CjHDmR+BA3IkK
         DvBA==
X-Gm-Message-State: AGi0PuaBOPmw63iMlzCQz7xBtXgT+zKgztipNj1FD5WvMDON6fxyL5+3
        iw9HPTBHxbizSO2a5Ut/+WKcq1k4AbX9MJqazdTWLwszEdwD
X-Google-Smtp-Source: APiQypL9Uo/ySR/OKjVx4URg+WZ+Fz/1Nz3g/6cIlDMVLpWlUll+9D4EJyEIauZtqJcCSr2Dx0Irl6P0C+9DX3zmTXi2WgHEBPJv
MIME-Version: 1.0
X-Received: by 2002:a5d:9648:: with SMTP id d8mr9516183ios.115.1585948384628;
 Fri, 03 Apr 2020 14:13:04 -0700 (PDT)
Date:   Fri, 03 Apr 2020 14:13:04 -0700
In-Reply-To: <CADG63jD4BzGVHdAZifTT==qm3n9tj16JVGxfR2nFLM6D4_S3aQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001913a505a269626e@google.com>
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
Read of size 1 at addr ffff8881cf89f17c by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 ath9k_wmi_ctrl_rx+0x416/0x500 drivers/net/wireless/ath/ath9k/wmi.c:229
 ath9k_htc_rx_msg+0x2d9/0xb00 drivers/net/wireless/ath/ath9k/htc_hst.c:459
 ath9k_hif_usb_reg_in_cb+0x1a6/0x620 drivers/net/wireless/ath/ath9k/hif_usb.c:724
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
RSP: 0018:ffff8881da22fda8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffff8881da213100 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8881da21394c
RBP: ffffed103b442620 R08: ffff8881da213100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: ffffffff87e61300 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_secondary+0x2a4/0x390 arch/x86/kernel/smpboot.c:264
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

Allocated by task 157:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 ath9k_init_wmi+0x40/0x310 drivers/net/wireless/ath/ath9k/wmi.c:95
 ath9k_htc_probe_device+0x21c/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:953
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1218
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 157:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
 slab_free_hook mm/slub.c:1444 [inline]
 slab_free_freelist_hook mm/slub.c:1477 [inline]
 slab_free mm/slub.c:3034 [inline]
 kfree+0xd5/0x300 mm/slub.c:3995
 ath9k_htc_probe_device+0x278/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:970
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1218
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881cf89f000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 380 bytes inside of
 2048-byte region [ffff8881cf89f000, ffff8881cf89f800)
The buggy address belongs to the page:
page:ffffea00073e2600 refcount:1 mapcount:0 mapping:ffff8881da00c000 index:0x0 compound_mapcount: 0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da00c000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881cf89f000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881cf89f080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881cf89f100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff8881cf89f180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881cf89f200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=139f3b1fe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a782c087b1f425c6
dashboard link: https://syzkaller.appspot.com/bug?extid=5d338854440137ea0fef
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17e22ac7e00000

