Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AB329AC25
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899969AbgJ0MdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:33:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:57274 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899860AbgJ0MdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:33:18 -0400
Received: by mail-io1-f71.google.com with SMTP id x19so679914iow.23
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FofA/azUC/4jOvukNRdRU5+c9AoRXjk/SRFBK/2eTD0=;
        b=t7mwZu1FghCvnlho5C2I50p4UgpnaxLp9S+reZMtt4oq6CqIFyAwFnRCPV5eO2wODl
         DUpFwmbpdkNRlrgjliXld+23DWB82Bt5udvzJipdAT3bRUwV06Mtx6JP+sNQnRLbPKZ6
         c7/BLZT/kIrtOPToX4hkdwgZfKB5YbSWwIFJ3a3gPMGL6DbUPNFRvbmUtAqRkTdNJzYz
         lYhs112vU5ehGyho35dGBgxIZg1QyuiA8jNWXA44OgOFmg7YFRzJ2qQBIVgCteJZEQGA
         NsECKZwVStYNXUSVXet2tgWqY9nzLKWyI1PA2SiYq9JGqLlHIJP4KWrJrwZ0eiGHajGX
         uelA==
X-Gm-Message-State: AOAM531pefD/Qj+TnfSGwXv8KgmLjSsei0p7kIMdqmm4SQ/6M6bvfLrM
        Fctcg+2TEHTcNknWVAYO1eWU8z9vPQpN8WtL6tz4QIxnySQA
X-Google-Smtp-Source: ABdhPJwSuAcDLBIvSKckcwgm4tsrpSETPpi96K9Rf1JDfHhZ+g87MLAR9Pg4qeWFxwyjgNkKNBjgqPqLoIy4WXDVwqENAIagb47d
MIME-Version: 1.0
X-Received: by 2002:a5e:d515:: with SMTP id e21mr1862616iom.9.1603801996145;
 Tue, 27 Oct 2020 05:33:16 -0700 (PDT)
Date:   Tue, 27 Oct 2020 05:33:16 -0700
In-Reply-To: <000000000000143a4305aba36803@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045390f05b2a640c4@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in ath9k_hif_usb_rx_cb (2)
From:   syzbot <syzbot+6ecc26112e7241c454ef@syzkaller.appspotmail.com>
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

HEAD commit:    3650b228 Linux 5.10-rc1
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=14485e50500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1c5bd23a80035ea
dashboard link: https://syzkaller.appspot.com/bug?extid=6ecc26112e7241c454ef
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d8eff7900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15130390500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6ecc26112e7241c454ef@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:399 [inline]
BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:562 [inline]
BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_cb+0x3ab/0x1020 drivers/net/wireless/ath/ath9k/hif_usb.c:680
Read of size 41740 at addr ffff88810bf10000 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 memcpy+0x20/0x60 mm/kasan/common.c:105
 memcpy include/linux/string.h:399 [inline]
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:562 [inline]
 ath9k_hif_usb_rx_cb+0x3ab/0x1020 drivers/net/wireless/ath/ath9k/hif_usb.c:680
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f4/0x3280 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1a5/0x630 kernel/time/timer.c:1415
 expire_timers kernel/time/timer.c:1460 [inline]
 __run_timers.part.0+0x67c/0xa10 kernel/time/timer.c:1752
 __run_timers kernel/time/timer.c:1733 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1765
 __do_softirq+0x1b2/0x945 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x80/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x110/0x1a0 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x43/0xa0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:79 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:169 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:517
Code: bd 13 a1 fb 84 db 75 ac e8 64 1b a1 fb e8 8f c1 a6 fb e9 0c 00 00 00 e8 55 1b a1 fb 0f 00 2d 1e be 69 00 e8 49 1b a1 fb fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 e4 13 a1 fb 48 85 db
RSP: 0018:ffffffff87007d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffffffff1079e01
RDX: ffffffff87031000 RSI: ffffffff859daf27 RDI: ffffffff859daf11
RBP: ffff888103980864 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffff888103980800 R14: ffff888103980864 R15: ffff88810545e804
 acpi_idle_enter+0x355/0x4f0 drivers/acpi/processor_idle.c:648
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:132 [inline]
 cpuidle_idle_call kernel/sched/idle.c:213 [inline]
 do_idle+0x3d5/0x580 kernel/sched/idle.c:273
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:369
 start_kernel+0x472/0x493 init/main.c:1051
 secondary_startup_64_no_verify+0xa6/0xab

The buggy address belongs to the page:
page:00000000dfda5045 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10bf10
head:00000000dfda5045 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x200000000010000(head)
raw: 0200000000010000 dead000000000100 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88810bf18380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88810bf18400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88810bf18480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
                                                                ^
 ffff88810bf18500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc 00
 ffff88810bf18580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

