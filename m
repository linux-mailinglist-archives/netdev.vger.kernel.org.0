Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8717B1ED36C
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 17:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgFCPcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 11:32:17 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:43508 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgFCPcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 11:32:15 -0400
Received: by mail-il1-f198.google.com with SMTP id e5so1498476ill.10
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 08:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Gl8DCI8PdMFP57T9AipLOavLrIwW1cuatNeoRe4hWbg=;
        b=csrWnBcIqoqHbdxlEkt4KTgJm5Bbqw3XEycmtT0nsIHNosilqaYH7JaMQKciBGBJiE
         erVGqWwMG+rl7+T6V1JF21q7PA77+IvS4e2mrPUpg2JN6PX+PPtqYik5dCBctxyyVUfs
         1J1Cq2JvBhZNP4yS9SoxGL38tSk7jkKgPyQVF9z+Hll9oBEHzMbgfqOMBM4AkoS3rNsa
         0b9SARVKthk+emW//cXyv3vb+H6SL+97OS2ft/IkUjZ7x1rVh7/oHIXW2dzGOZu+MdVB
         +4Idw2i0KIFRIW9q8Of6LhjuPhqqDlcFgpofK2faszjdwhfVHwt2SEijTikYfGsymK/E
         hcKw==
X-Gm-Message-State: AOAM531Jx2jDAinVWQKyUKjlZGyaL39dWnFigvMBH8UCcRciSVyosy1A
        E7C76hmFxML6KAnUVZt211FPg9fnwLsCzIEyVEDk/dC1r6YN
X-Google-Smtp-Source: ABdhPJy5Ka0KHHhvWlr51OHU3WnJemWLkBsFR4ZWyPRPCO6VwyWIBTXiNMdirWDuNq1OUicZ8NEv0kerl7DZV6+xqhHPTg15ivM5
MIME-Version: 1.0
X-Received: by 2002:a92:9c52:: with SMTP id h79mr100851ili.252.1591198334773;
 Wed, 03 Jun 2020 08:32:14 -0700 (PDT)
Date:   Wed, 03 Jun 2020 08:32:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000082f13605a72fbbcb@google.com>
Subject: KASAN: out-of-bounds Read in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+d7289ef49bcdfd654265@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    2089c6ed usb: core: kcov: collect coverage from usb comple..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=17cf6bd6100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7479d3935864b1b
dashboard link: https://syzkaller.appspot.com/bug?extid=d7289ef49bcdfd654265
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d7289ef49bcdfd654265@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:622 [inline]
BUG: KASAN: out-of-bounds in ath9k_hif_usb_rx_cb+0xe64/0xf90 drivers/net/wireless/ath/ath9k/hif_usb.c:666
Read of size 4 at addr ffff8881acb6c0d0 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x415 mm/kasan/report.c:382
 __kasan_report.cold+0x37/0x7d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:622 [inline]
 ath9k_hif_usb_rx_cb+0xe64/0xf90 drivers/net/wireless/ath/ath9k/hif_usb.c:666
 __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
 dummy_timer+0x125e/0x32b4 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x700 kernel/time/timer.c:1405
 expire_timers kernel/time/timer.c:1450 [inline]
 __run_timers kernel/time/timer.c:1774 [inline]
 __run_timers kernel/time/timer.c:1741 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1787
 __do_softirq+0x21e/0x9aa kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1140
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:default_idle+0x28/0x300 arch/x86/kernel/process.c:698
Code: cc cc 41 56 41 55 65 44 8b 2d 94 3f 6b 7a 41 54 55 53 0f 1f 44 00 00 e8 16 28 af fb e9 07 00 00 00 0f 00 2d 7a e1 4b 00 fb f4 <65> 44 8b 2d 70 3f 6b 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffff8881da227da8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffff8881da20b180 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8881da20b9fc
RBP: ffffed103b441630 R08: ffff8881da20b180 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: ffffffff87e88c40 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_secondary+0x2ae/0x390 arch/x86/kernel/smpboot.c:268
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

The buggy address belongs to the page:
page:ffffea0006b2db00 refcount:0 mapcount:0 mapping:0000000080660f93 index:0x0
flags: 0x200000000000000()
raw: 0200000000000000 0000000000000000 ffffea0006b2db08 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881acb6bf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881acb6c000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8881acb6c080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                 ^
 ffff8881acb6c100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881acb6c180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
