Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3280C232C47
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 09:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgG3HNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 03:13:19 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53145 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3HNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 03:13:18 -0400
Received: by mail-io1-f69.google.com with SMTP id k12so17912325iom.19
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 00:13:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OsygJws73+ifoiCOA9gS6rVGsiYjzXdLwPjRcW5XWEM=;
        b=cczWDu1M6zfi5To8Smi/N2DgVpV7ASq1WdWrhnlMDnG50ODb+5BmiQLuIypzJFVr18
         VDC0E/cnmvwVjai9qNcyDeSmEJsinTuyYWk0HkC2KDmeSn+JnA9cCyhAP/fZNMB93S3l
         RNznZ8VljYwGCoiEJWeeE4I6V3go973RMLMDuDfmZ5LxJ1Avbq/MpZq82AC1nQvUgSHZ
         NwfwqCiREbdZjAR2LLb2HaMrTn60r0d52S9soTdTtXK8FnFiR2OgocUCMorCKsZ76S8u
         obZQHpBfKGC74qtsl577HYsJi7Gq6Wu3l8GqLa2NuHIA7M9TTwUDggDRjG05h/jp5Yp6
         uEFg==
X-Gm-Message-State: AOAM531T8PWpmJWRH/mR8X4Y8HizlPjFmGrxgJ80nwjTB5fiSgIruRx2
        5OOPXh7B9mf8GwDW6TQHTpPiwmkchWW/39ryw7l6WwcSE5bj
X-Google-Smtp-Source: ABdhPJzG0Ln5tCHYPVorVTvgyzhdlhg1XE6AmkVOAxgZ09CzFspZl+p8H2VYeTiZQOuVFvfsoXfbREYaCPPunfNTp+dOZEehEwUl
MIME-Version: 1.0
X-Received: by 2002:a02:9109:: with SMTP id a9mr2063499jag.130.1596093197725;
 Thu, 30 Jul 2020 00:13:17 -0700 (PDT)
Date:   Thu, 30 Jul 2020 00:13:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000143a4305aba36803@google.com>
Subject: KASAN: slab-out-of-bounds Read in ath9k_hif_usb_rx_cb (2)
From:   syzbot <syzbot+6ecc26112e7241c454ef@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ab4dc051 usb: mtu3: simplify mtu3_req_complete()
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=11c0666c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb6677a3d4f11788
dashboard link: https://syzkaller.appspot.com/bug?extid=6ecc26112e7241c454ef
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171e6004900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6ecc26112e7241c454ef@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:627 [inline]
BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_cb+0xd7d/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
Read of size 4 at addr ffff8881cbf6c090 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1a/0x210 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x37/0x7c mm/kasan/report.c:530
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:627 [inline]
 ath9k_hif_usb_rx_cb+0xd7d/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f2/0x3240 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x6e0 kernel/time/timer.c:1415
 expire_timers kernel/time/timer.c:1460 [inline]
 __run_timers.part.0+0x54c/0x9e0 kernel/time/timer.c:1784
 __run_timers kernel/time/timer.c:1756 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1797
 __do_softirq+0x222/0x95b kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0xed/0x140 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x150/0x1f0 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x49/0xc0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:585
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:acpi_safe_halt+0x72/0x90 drivers/acpi/processor_idle.c:112
Code: 74 06 5b e9 e0 4c 8f fb e8 db 4c 8f fb e8 26 d8 94 fb e9 0c 00 00 00 e8 cc 4c 8f fb 0f 00 2d 05 63 74 00 e8 c0 4c 8f fb fb f4 <fa> e8 18 d2 94 fb 5b e9 b2 4c 8f fb 48 89 df e8 fa fb b8 fb eb ab
RSP: 0018:ffffffff87207c80 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff8722f840 RSI: ffffffff85b05d40 RDI: ffffffff85b05d2a
RBP: ffff8881d8cca864 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8881d8cca864
R13: 1ffffffff0e40f99 R14: ffff8881d8cca865 R15: 0000000000000001
 acpi_idle_do_entry+0x15c/0x1b0 drivers/acpi/processor_idle.c:525
 acpi_idle_enter+0x3f0/0xa50 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0xff/0x870 drivers/cpuidle/cpuidle.c:235
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:346
 call_cpuidle kernel/sched/idle.c:126 [inline]
 cpuidle_idle_call kernel/sched/idle.c:214 [inline]
 do_idle+0x3d6/0x5a0 kernel/sched/idle.c:276
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:372
 start_kernel+0xa1b/0xa56 init/main.c:1043
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:243

Allocated by task 0:
(stack is not available)

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff8881cbf6c000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 144 bytes inside of
 1024-byte region [ffff8881cbf6c000, ffff8881cbf6c400)
The buggy address belongs to the page:
page:ffffea00072fda00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea00072fda00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da002280
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881cbf6bf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881cbf6c000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881cbf6c080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff8881cbf6c100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881cbf6c180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
