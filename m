Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D239C193DFE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgCZLes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:34:48 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49533 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbgCZLeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:34:17 -0400
Received: by mail-io1-f70.google.com with SMTP id p14so4883524ios.16
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 04:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tUu5ipLqX0h3zkfeKvn8ONybl6tcgocGmca6tPedBZ0=;
        b=Z9elwbeI2COoGzqdziKUrqXXu/8wPW732DnUA7BkrYwsS4dwgC5h8kzb5ABtMl4IQB
         oT+lAhe9SJfRsZLL2yYBpaU+oXVTXZdS4022H4pJZ9bnOJOAhPGFFSJZEMEDq8/klHAf
         XHvMSjbA2Wp7K1i3JthhUg8zdeU1PYDzUQW3aUyd341Q/YmEJ66+XGE+OVHTGezCSjvl
         zSXXKUHc/cyqjd9cu5Ze5PA4fPoLOI8oA+nUrsFBagKH3sXwlGUiDNSwAXpRQWf/QY4V
         PeewWjMNJCwjL7mEBswTpl1FFc4TgsiL/iP+Y0IHVysDqq62dngvqDfRqNROVA0xSJgP
         N8dA==
X-Gm-Message-State: ANhLgQ19wOcvH5mT4C91Owkl+YbZArxnyvxJFE3O7HtMen/80EQT+MTn
        RRH7aYsH2RDyBExXlSQgg97LXhyPU+1CI4pLkZJyuVUqqUq+
X-Google-Smtp-Source: ADFU+vufjsMSX1K3oF5eN1nnvBpx+Ckwu2UMj8UTss4Wk2k2mnY6WJIimTmipZxTr2BHd+iCykHeg/7tCTky5POrj5DZ9bt6L/UQ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1248:: with SMTP id o8mr6892714jas.143.1585222456046;
 Thu, 26 Mar 2020 04:34:16 -0700 (PDT)
Date:   Thu, 26 Mar 2020 04:34:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000061f8bb05a1c05def@google.com>
Subject: KASAN: use-after-free Read in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+89bd486af9427a9fc605@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e17994d1 usb: core: kcov: collect coverage from usb comple..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=12533987e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
dashboard link: https://syzkaller.appspot.com/bug?extid=89bd486af9427a9fc605
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161978d5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1509b523e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+89bd486af9427a9fc605@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/string.h:381 [inline]
BUG: KASAN: use-after-free in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:553 [inline]
BUG: KASAN: use-after-free in ath9k_hif_usb_rx_cb+0x3be/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:666
Read of size 49151 at addr ffff8881ceee0000 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x152/0x1c0 mm/kasan/generic.c:192
 memcpy+0x20/0x50 mm/kasan/common.c:127
 memcpy include/linux/string.h:381 [inline]
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:553 [inline]
 ath9k_hif_usb_rx_cb+0x3be/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:666
 __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
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
Code: cc cc 41 56 41 55 65 44 8b 2d 44 77 72 7a 41 54 55 53 0f 1f 44 00 00 e8 b6 62 b5 fb e9 07 00 00 00 0f 00 2d ea 0c 53 00 fb f4 <65> 44 8b 2d 20 77 72 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffff8881da22fda8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffff8881da213100 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8881da21394c
RBP: ffffed103b442620 R08: ffff8881da213100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: ffffffff87e607c0 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_secondary+0x2a4/0x390 arch/x86/kernel/smpboot.c:264
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

The buggy address belongs to the page:
page:ffffea00073bb800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 compound_mapcount: 0
flags: 0x200000000010000(head)
raw: 0200000000010000 dead000000000100 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881ceee7f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8881ceee7f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8881ceee8000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8881ceee8080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881ceee8100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
