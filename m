Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473912432CA
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 05:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHMDcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 23:32:19 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:46744 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHMDcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 23:32:18 -0400
Received: by mail-il1-f200.google.com with SMTP id q19so3388537ilt.13
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 20:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=P9pLEB9Ie9BNOlGpHvN5myjm3ue4cem8ycZ60nuClrc=;
        b=MjV/h1v57b8YPuImbOT1epj5Lkhpx7OJnkvKSxShuu8vDc9UsBUJaePxsPO1NKazPs
         9KtcviFEBqsD+5n9E/pHpecsvMqSEOWOEJNIzhXm0VpH4phye15voKi2yN1TTutuU8Bz
         UPGgB5dSJQxVzkOolEhiTDBBr/DVxL1brwvGWVHL/jC5I1/MHZofSckkWIf0aXapCJvX
         e39vKNHPXhaxgfKrE7mc1f9P7Cr9Ct6dDvBzQdEGUaQQLs737Wm9/f2Nyw5sjkal0LlC
         3X6VXJlxjQuER0UICnWREQrXo6Qpij8MNPdX1IwhlSXjcTJdnnZCurvxkLRgOvOKNmDk
         F5EQ==
X-Gm-Message-State: AOAM533wIcAYDoJMCMoQR2cuY/45zfiIUKA6+ZyNvlgVatMhnQxpa5mG
        e15JYNUISwepz2wYLTrG+Ydx0YgLL1o7R+XmNzCadyAwP623
X-Google-Smtp-Source: ABdhPJzWa8bZiMsbcj+1jm07c0oi4qAkSaZR3vRyrO7J61eijlNFH5EPnLXipTjPW8ZzzueQu8rtkTdj5NobvZbFN9m0fZ+F1bdR
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1125:: with SMTP id f5mr2803096jar.51.1597289536899;
 Wed, 12 Aug 2020 20:32:16 -0700 (PDT)
Date:   Wed, 12 Aug 2020 20:32:16 -0700
In-Reply-To: <000000000000c98a7f05ac744f53@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000734fe705acb9f3a2@google.com>
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
From:   syzbot <syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        glider@google.com, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12985a16900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=2ca247c2d60c7023de7f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1468efe2900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10bb9fba900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ath9k_htc_rx_msg+0x28f/0x1f50 drivers/net/wireless/ath/ath9k/htc_hst.c:410
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 ath9k_htc_rx_msg+0x28f/0x1f50 drivers/net/wireless/ath/ath9k/htc_hst.c:410
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:638 [inline]
 ath9k_hif_usb_rx_cb+0x1841/0x1d10 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x687/0x870 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1716
 dummy_timer+0xd98/0x71c0 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
 expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
 __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:23 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 do_softirq_own_stack+0x7c/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:390 [inline]
 __irq_exit_rcu+0x226/0x270 kernel/softirq.c:420
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x107/0x130 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:593
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
RIP: 0010:acpi_idle_do_entry drivers/acpi/processor_idle.c:525 [inline]
RIP: 0010:acpi_idle_enter+0x817/0xeb0 drivers/acpi/processor_idle.c:651
Code: 85 db 74 0a f7 d3 44 21 fb 48 85 db 74 32 4d 85 ff 75 3a 48 8b 5d a0 e9 0c 00 00 00 e8 12 b2 78 fb 0f 00 2d 25 15 1c 0b fb f4 <fa> eb 5a 84 c0 8b 7d 90 0f 45 7d 94 e8 d8 9a f4 fb e9 74 fc ff ff
RSP: 0018:ffff88812df93bc8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff8881dfefce70 RCX: 000000012db88000
RDX: ffff88812df88000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88812df93ca0 R08: ffffffff86420acc R09: ffff88812fffa000
R10: 0000000000000002 R11: ffff88812df88000 R12: ffff88812df889d8
R13: ffff8881dfefcc64 R14: 0000000000000000 R15: 0000000000000000
 cpuidle_enter_state+0x860/0x12b0 drivers/cpuidle/cpuidle.c:235
 cpuidle_enter+0xe3/0x170 drivers/cpuidle/cpuidle.c:346
 call_cpuidle kernel/sched/idle.c:126 [inline]
 cpuidle_idle_call kernel/sched/idle.c:214 [inline]
 do_idle+0x668/0x810 kernel/sched/idle.c:276
 cpu_startup_entry+0x45/0x50 kernel/sched/idle.c:372
 start_secondary+0x1bf/0x240 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xc5/0x1a0 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0xdf0/0x1030 mm/page_alloc.c:4889
 __alloc_pages include/linux/gfp.h:509 [inline]
 __alloc_pages_node include/linux/gfp.h:522 [inline]
 alloc_pages_node include/linux/gfp.h:536 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4964 [inline]
 page_frag_alloc+0x35b/0x880 mm/page_alloc.c:4994
 __netdev_alloc_skb+0x2a8/0xc90 net/core/skbuff.c:451
 __dev_alloc_skb include/linux/skbuff.h:2813 [inline]
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:620 [inline]
 ath9k_hif_usb_rx_cb+0xe5a/0x1d10 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x687/0x870 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1716
 dummy_timer+0xd98/0x71c0 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
 expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
 __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
=====================================================

