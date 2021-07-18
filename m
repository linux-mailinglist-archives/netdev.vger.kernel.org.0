Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04F43CC962
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 15:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhGRNxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 09:53:19 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:50816 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbhGRNxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 09:53:18 -0400
Received: by mail-il1-f200.google.com with SMTP id w8-20020a056e021c88b02902095727d18dso8753357ill.17
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 06:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=OXoW0tdh3u7kirLpVINFuQ3xib/WnFYX8gUfwjUENjk=;
        b=pJEgXtw7+els7KlA/hO7x6U13W8984lkgsflFrnzJFiQwYm3YqULK5PFdeuXNK6YrN
         RhZZ+IZb6z7d1/q93A1+ICnHCDDT+gJQP79I2fclNTLzIbl1MU1smVkHVXhGdMJxxrwM
         06IilGEZ2O9nu3T/Ybu2TJylCbwbspNubHqmzna8vUDH40VXIaIvIQQ2SBwx1S/cd6gc
         WS7DykitoxgvUHCzzdd2GNlUCt/CfqVQYzPoTNBcvdzXQXJy+c6lvezPGJUtOAZ5UX6t
         /MW6cPljWPklJk8mOqjx4tBW7Lj6Z/YMZcZXHFJ3PFIXORFud94Zn9oM0Hd2UfkLggGP
         bmbQ==
X-Gm-Message-State: AOAM530iZSDjlfmU02ka2swCu0upSd17q63mwcI1brbBEI0U0KqV8S19
        uGpbPTligTZ4kPfAxhvXweKO8YU2047uqzVZcJQi/jrf+cX+
X-Google-Smtp-Source: ABdhPJyFGBpgqB+KxTMFlxIFRrUzHrB23N5+7Q8y4qgeiIzmmR5jT7VlVjTFWPQysotCZaG+Zalw0PAJkLjKEJRzUYR31zdxvWi1
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:550:: with SMTP id i16mr13219001ils.207.1626616220337;
 Sun, 18 Jul 2021 06:50:20 -0700 (PDT)
Date:   Sun, 18 Jul 2021 06:50:20 -0700
In-Reply-To: <0000000000005866b005c7394288@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ffcb8205c7661908@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in ath9k_htc_rxep
From:   syzbot <syzbot+dc6c749aec286992cea2@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    97db1b081e12 dt-bindings: usb: dwc3: Update dwc3 TX fifo p..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=13b7fd02300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db8b503c237253ee
dashboard link: https://syzkaller.appspot.com/bug?extid=dc6c749aec286992cea2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10431e54300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d2dc32300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dc6c749aec286992cea2@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffffffffffffc8
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 7426067 P4D 7426067 PUD 7428067 PMD 0 
Oops: 0000 [#1] SMP KASAN
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ath9k_htc_rxep+0xb5/0x210 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1135
Code: 8b 43 38 48 8d 58 c8 49 39 c4 0f 84 ee 00 00 00 e8 f0 64 37 fe 48 89 d8 48 c1 e8 03 0f b6 04 28 84 c0 74 06 0f 8e 0a 01 00 00 <44> 0f b6 3b 31 ff 44 89 fe e8 fd 6b 37 fe 45 84 ff 75 a8 e8 c3 64
RSP: 0018:ffffc900001489b8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffc8 RCX: 0000000000000100
RDX: ffff8881002c0000 RSI: ffffffff830a0050 RDI: ffffc90000148928
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000029125 R11: 0000000000000000 R12: ffff888119a9b678
R13: ffff888119a9b240 R14: ffff888119a9b688 R15: ffff8881088974a8
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffc8 CR3: 000000010719b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ath9k_htc_rx_msg+0x2e4/0xb70 drivers/net/wireless/ath/ath9k/htc_hst.c:461
 ath9k_hif_usb_reg_in_cb+0x1ac/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:733
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1656
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1726
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 call_timer_fn+0x1a5/0x630 kernel/time/timer.c:1417
 expire_timers kernel/time/timer.c:1462 [inline]
 __run_timers.part.0+0x675/0xa10 kernel/time/timer.c:1731
 __run_timers kernel/time/timer.c:1712 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1744
 __do_softirq+0x1b0/0x910 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x117/0x160 kernel/softirq.c:636
 irq_exit_rcu+0x5/0x10 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x6a/0x90 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:132 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:110 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:553
Code: 89 de e8 cd ed 80 fb 84 db 75 ac e8 94 e6 80 fb e8 5f f2 86 fb eb 0c e8 88 e6 80 fb 0f 00 2d 81 b0 88 00 e8 7c e6 80 fb fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 07 ef 80 fb 48 85 db
RSP: 0018:ffffc900000dfd18 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8881002c0000 RSI: ffffffff85c07ec4 RDI: ffffffff85c07eb1
RBP: ffff888109b93064 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81477148 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888109b93000 R14: ffff888109b93064 R15: ffff88810cf00004
 acpi_idle_enter+0x355/0x4f0 drivers/acpi/processor_idle.c:688
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3dd/0x580 kernel/sched/idle.c:306
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:403
 start_secondary+0x267/0x340 arch/x86/kernel/smpboot.c:270
 secondary_startup_64_no_verify+0xb0/0xbb
Modules linked in:
CR2: ffffffffffffffc8
---[ end trace c812365639e6eb14 ]---
RIP: 0010:ath9k_htc_rxep+0xb5/0x210 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1135
Code: 8b 43 38 48 8d 58 c8 49 39 c4 0f 84 ee 00 00 00 e8 f0 64 37 fe 48 89 d8 48 c1 e8 03 0f b6 04 28 84 c0 74 06 0f 8e 0a 01 00 00 <44> 0f b6 3b 31 ff 44 89 fe e8 fd 6b 37 fe 45 84 ff 75 a8 e8 c3 64
RSP: 0018:ffffc900001489b8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffffffffffc8 RCX: 0000000000000100
RDX: ffff8881002c0000 RSI: ffffffff830a0050 RDI: ffffc90000148928
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000029125 R11: 0000000000000000 R12: ffff888119a9b678
R13: ffff888119a9b240 R14: ffff888119a9b688 R15: ffff8881088974a8
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffc8 CR3: 000000010719b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

