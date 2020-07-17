Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588912245F8
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGQVuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:50:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56277 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgGQVuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:50:16 -0400
Received: by mail-io1-f72.google.com with SMTP id k10so7366769ioh.22
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 14:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=85jeZRkVVZR0QWjQqq1R38JosKuOusEK/U+W/rCZr34=;
        b=ZZTbLBSlBqb0EXrayrDF8VSXbZ6PQU0662cVK9EuqfOa3KUJCWQ1d23HmeY77rXTPf
         iJFQKFRH1x9Y1EBNchOLpQniDl60UdOVz7N64b/83fvxjUNc8nXZjuJVmxI3ICKooQ7E
         MFN4xnFfYDtw9VUHdlb+E0LXIbJ7ihiVaVmzRskGxukO/xZFzyx+Y72j9bIlFTi+QVNr
         TQRxd7YNBOTPlsGkNS2CJXBjTGgbvzsVAvKeeZ0vyjczJgJ/OIqNgALSTRC223ZhcuVh
         xSQqoP5Fred8r3aqya45+LrpV8aDYlkczOB6jDof+8vkH++gLH9wHYQREFIKR70IZwmR
         X3EA==
X-Gm-Message-State: AOAM531dW1agMTOZhVj0wIymZD36uLadaSnR3638B7zV8P/ggXqQTHU/
        UwiXdjHBCfuwjj38eMfgpGhDqLOOOZPhf0e9Y2W++i0B6ZZC
X-Google-Smtp-Source: ABdhPJy+3h5BOXNPx6JRlmD4LA6y78fC/ycxGDJuw6H+My87ZlKnfolBKrDEEJ4A7990zPNUFVjLiOF+QBWo5iz8NEOLW1sQjMcE
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2423:: with SMTP id g3mr11356421iob.183.1595022614768;
 Fri, 17 Jul 2020 14:50:14 -0700 (PDT)
Date:   Fri, 17 Jul 2020 14:50:14 -0700
In-Reply-To: <00000000000030271005aaa7b603@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005cb69605aaaa2411@google.com>
Subject: Re: general protection fault in ath9k_hif_usb_rx_cb (2)
From:   syzbot <syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com>
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    313da01a usb: misc: sisusbvga: Move static const tables ou..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=15d1cde7100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=999be4eb2478ffa5
dashboard link: https://syzkaller.appspot.com/bug?extid=c6dde1f690b60e0b9fbe
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11edde20900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178d2680900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc00000001f3: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000f98-0x0000000000000f9f]
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:580 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0xc4d/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
Code: 48 c1 ea 03 80 3c 02 00 0f 85 0e 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 08 48 8d bb 9c 0f 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8
RSP: 0018:ffff8881db309920 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff82e1fa3e
RDX: 00000000000001f3 RSI: ffffffff82e1fcb9 RDI: 0000000000000f9c
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff8881d8fc442b
R10: 0000000000004e00 R11: 1ffffffff123bba9 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8881d8fc4000 R15: ffff8881c8b5cf40
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556e7bf7d8d8 CR3: 00000001c3194000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f2/0x3240 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x6e0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers.part.0+0x54c/0x9e0 kernel/time/timer.c:1773
 __run_timers kernel/time/timer.c:1745 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1786
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
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:596
RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:acpi_safe_halt+0x72/0x90 drivers/acpi/processor_idle.c:112
Code: 74 06 5b e9 60 c8 8f fb e8 5b c8 8f fb e8 a6 53 95 fb e9 0c 00 00 00 e8 4c c8 8f fb 0f 00 2d c5 e5 74 00 e8 40 c8 8f fb fb f4 <fa> e8 98 4d 95 fb 5b e9 32 c8 8f fb 48 89 df e8 fa 72 b9 fb eb ab
RSP: 0018:ffff8881da22fc80 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8881da213200 RSI: ffffffff85afd9a0 RDI: ffffffff85afd98a
RBP: ffff8881d8cca864 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8881d8cca864
R13: 1ffff1103b445f99 R14: ffff8881d8cca865 R15: 0000000000000001
 acpi_idle_do_entry+0x15c/0x1b0 drivers/acpi/processor_idle.c:525
 acpi_idle_enter+0x3f0/0xa50 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0xff/0x870 drivers/cpuidle/cpuidle.c:235
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:346
 call_cpuidle kernel/sched/idle.c:126 [inline]
 cpuidle_idle_call kernel/sched/idle.c:214 [inline]
 do_idle+0x3d6/0x5a0 kernel/sched/idle.c:276
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:372
 start_secondary+0x2d2/0x3c0 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:243
Modules linked in:
---[ end trace e2f028e5d5706562 ]---
RIP: 0010:ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:580 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0xc4d/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
Code: 48 c1 ea 03 80 3c 02 00 0f 85 0e 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 08 48 8d bb 9c 0f 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8
RSP: 0018:ffff8881db309920 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff82e1fa3e
RDX: 00000000000001f3 RSI: ffffffff82e1fcb9 RDI: 0000000000000f9c
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff8881d8fc442b
R10: 0000000000004e00 R11: 1ffffffff123bba9 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8881d8fc4000 R15: ffff8881c8b5cf40
FS:  0000000000000000(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556e7bf7d8d8 CR3: 00000001c3194000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

