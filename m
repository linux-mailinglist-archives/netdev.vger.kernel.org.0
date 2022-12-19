Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C287D6506DB
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 04:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiLSDkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 22:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiLSDkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 22:40:47 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212F16339
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 19:40:46 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id 7-20020a056e0220c700b0030386f0d0e6so5938685ilq.3
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 19:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TkEZ8M+1HG3nvSZ+Xe6iYgKTar5Wi2cWB6DMhdk6aMU=;
        b=ZHnwkfU2F6w0ysNUe2rsKamW7WXUX4ZyWzr7ikixXaePUGjVDkhlG21uqTTBriHSD8
         5Mc5hXePKl087x1XDVp9AxJPrcsQnvqFwHrYw42f7iTy3/TqSzbU15jDtaasYoErvJuv
         ifWwZA8L72KbMITZltPMB2UK+Yyzad9l9rj7IA52/0dAuVK3jz/T86YUM0vTHn1Iyl/g
         Xgy+qY7MrMWmhQNA+GikwSw2wwE45CwI1qHT9BQj08kQSBpndTQYF9/uziJRTPBUQnsu
         DDwI59k01JlUGLjPD017gm0whAGGCuXqBOd0UFyUaW2Aq4AkdbYewbVhLa3zaloaHXYs
         6CJg==
X-Gm-Message-State: ANoB5pl6Lu/ZdTtKn5/YAXv9VmzfV4DlK+VJRv9QcOYAgjzttBbx4MQ7
        gmvH/PLt5umnnq1OuV0Efi89okbDQ4orSREvubbCUEqZKrb6
X-Google-Smtp-Source: AA0mqf4Aa3Kw+wZKikbr83YdL7LJnPPJDgMoH3cjpM4sPJ0iZIkHjs9zKbORUXHaNOkFdGXiPdUEBsAKFWH72O4gdmVSX35qASHt
MIME-Version: 1.0
X-Received: by 2002:a02:6d1a:0:b0:387:eb89:9528 with SMTP id
 m26-20020a026d1a000000b00387eb899528mr36051793jac.26.1671421245501; Sun, 18
 Dec 2022 19:40:45 -0800 (PST)
Date:   Sun, 18 Dec 2022 19:40:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009bb72705f0261578@google.com>
Subject: [syzbot] memory leak in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com, toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6f1f5caed5bf Merge tag 'for-linus-6.2-ofs1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a5aa57880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aa9d05fc5567240b
dashboard link: https://syzkaller.appspot.com/bug?extid=e9632e3eb038d93d6bc6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1138a5c0480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d07e77880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e0b09490fc5c/disk-6f1f5cae.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2f00e5ef8dce/vmlinux-6f1f5cae.xz
kernel image: https://storage.googleapis.com/syzbot-assets/78f4c439075f/bzImage-6f1f5cae.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888101f97700 (size 240):
  comm "softirq", pid 0, jiffies 4294945988 (age 15.200s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83ac0212>] __alloc_skb+0x202/0x270 net/core/skbuff.c:552
    [<ffffffff83ac396a>] __netdev_alloc_skb+0x6a/0x220 net/core/skbuff.c:630
    [<ffffffff82df70d0>] __dev_alloc_skb include/linux/skbuff.h:3165 [inline]
    [<ffffffff82df70d0>] ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:635 [inline]
    [<ffffffff82df70d0>] ath9k_hif_usb_rx_cb+0x1d0/0x660 drivers/net/wireless/ath/ath9k/hif_usb.c:686
    [<ffffffff82fd9d89>] __usb_hcd_giveback_urb+0xf9/0x230 drivers/usb/core/hcd.c:1671
    [<ffffffff82fda06b>] usb_hcd_giveback_urb+0x1ab/0x1c0 drivers/usb/core/hcd.c:1754
    [<ffffffff8318c0b4>] dummy_timer+0x8e4/0x14c0 drivers/usb/gadget/udc/dummy_hcd.c:1988
    [<ffffffff81328243>] call_timer_fn+0x33/0x1f0 kernel/time/timer.c:1700
    [<ffffffff813284ff>] expire_timers+0xff/0x1d0 kernel/time/timer.c:1751
    [<ffffffff813286f9>] __run_timers kernel/time/timer.c:2022 [inline]
    [<ffffffff813286f9>] __run_timers kernel/time/timer.c:1995 [inline]
    [<ffffffff813286f9>] run_timer_softirq+0x129/0x2f0 kernel/time/timer.c:2035
    [<ffffffff84c000eb>] __do_softirq+0xeb/0x2ef kernel/softirq.c:571
    [<ffffffff8126a086>] invoke_softirq kernel/softirq.c:445 [inline]
    [<ffffffff8126a086>] __irq_exit_rcu+0xc6/0x110 kernel/softirq.c:650
    [<ffffffff848a7742>] sysvec_apic_timer_interrupt+0xa2/0xd0 arch/x86/kernel/apic/apic.c:1107
    [<ffffffff84a00cc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
    [<ffffffff848bd6e9>] native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
    [<ffffffff848bd6e9>] arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
    [<ffffffff848bd6e9>] acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
    [<ffffffff848bd6e9>] acpi_idle_do_entry+0xc9/0xe0 drivers/acpi/processor_idle.c:570
    [<ffffffff848bdc00>] acpi_idle_enter+0x150/0x230 drivers/acpi/processor_idle.c:707
    [<ffffffff83699eb4>] cpuidle_enter_state+0xc4/0x740 drivers/cpuidle/cpuidle.c:239

BUG: memory leak
unreferenced object 0xffff88810c312800 (size 1024):
  comm "softirq", pid 0, jiffies 4294945988 (age 15.200s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814f6467>] __do_kmalloc_node mm/slab_common.c:967 [inline]
    [<ffffffff814f6467>] __kmalloc_node_track_caller+0x47/0x120 mm/slab_common.c:988
    [<ffffffff83ac00f1>] kmalloc_reserve net/core/skbuff.c:492 [inline]
    [<ffffffff83ac00f1>] __alloc_skb+0xe1/0x270 net/core/skbuff.c:565
    [<ffffffff83ac396a>] __netdev_alloc_skb+0x6a/0x220 net/core/skbuff.c:630
    [<ffffffff82df70d0>] __dev_alloc_skb include/linux/skbuff.h:3165 [inline]
    [<ffffffff82df70d0>] ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:635 [inline]
    [<ffffffff82df70d0>] ath9k_hif_usb_rx_cb+0x1d0/0x660 drivers/net/wireless/ath/ath9k/hif_usb.c:686
    [<ffffffff82fd9d89>] __usb_hcd_giveback_urb+0xf9/0x230 drivers/usb/core/hcd.c:1671
    [<ffffffff82fda06b>] usb_hcd_giveback_urb+0x1ab/0x1c0 drivers/usb/core/hcd.c:1754
    [<ffffffff8318c0b4>] dummy_timer+0x8e4/0x14c0 drivers/usb/gadget/udc/dummy_hcd.c:1988
    [<ffffffff81328243>] call_timer_fn+0x33/0x1f0 kernel/time/timer.c:1700
    [<ffffffff813284ff>] expire_timers+0xff/0x1d0 kernel/time/timer.c:1751
    [<ffffffff813286f9>] __run_timers kernel/time/timer.c:2022 [inline]
    [<ffffffff813286f9>] __run_timers kernel/time/timer.c:1995 [inline]
    [<ffffffff813286f9>] run_timer_softirq+0x129/0x2f0 kernel/time/timer.c:2035
    [<ffffffff84c000eb>] __do_softirq+0xeb/0x2ef kernel/softirq.c:571
    [<ffffffff8126a086>] invoke_softirq kernel/softirq.c:445 [inline]
    [<ffffffff8126a086>] __irq_exit_rcu+0xc6/0x110 kernel/softirq.c:650
    [<ffffffff848a7742>] sysvec_apic_timer_interrupt+0xa2/0xd0 arch/x86/kernel/apic/apic.c:1107
    [<ffffffff84a00cc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
    [<ffffffff848bd6e9>] native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
    [<ffffffff848bd6e9>] arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
    [<ffffffff848bd6e9>] acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
    [<ffffffff848bd6e9>] acpi_idle_do_entry+0xc9/0xe0 drivers/acpi/processor_idle.c:570
    [<ffffffff848bdc00>] acpi_idle_enter+0x150/0x230 drivers/acpi/processor_idle.c:707

BUG: memory leak
unreferenced object 0xffff888101f97500 (size 240):
  comm "softirq", pid 0, jiffies 4294945988 (age 15.200s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83ac0212>] __alloc_skb+0x202/0x270 net/core/skbuff.c:552
    [<ffffffff83ac396a>] __netdev_alloc_skb+0x6a/0x220 net/core/skbuff.c:630
    [<ffffffff82df70d0>] __dev_alloc_skb include/linux/skbuff.h:3165 [inline]
    [<ffffffff82df70d0>] ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:635 [inline]
    [<ffffffff82df70d0>] ath9k_hif_usb_rx_cb+0x1d0/0x660 drivers/net/wireless/ath/ath9k/hif_usb.c:686
    [<ffffffff82fd9d89>] __usb_hcd_giveback_urb+0xf9/0x230 drivers/usb/core/hcd.c:1671
    [<ffffffff82fda06b>] usb_hcd_giveback_urb+0x1ab/0x1c0 drivers/usb/core/hcd.c:1754
    [<ffffffff8318c0b4>] dummy_timer+0x8e4/0x14c0 drivers/usb/gadget/udc/dummy_hcd.c:1988
    [<ffffffff81328243>] call_timer_fn+0x33/0x1f0 kernel/time/timer.c:1700
    [<ffffffff813284ff>] expire_timers+0xff/0x1d0 kernel/time/timer.c:1751
    [<ffffffff813286f9>] __run_timers kernel/time/timer.c:2022 [inline]
    [<ffffffff813286f9>] __run_timers kernel/time/timer.c:1995 [inline]
    [<ffffffff813286f9>] run_timer_softirq+0x129/0x2f0 kernel/time/timer.c:2035
    [<ffffffff84c000eb>] __do_softirq+0xeb/0x2ef kernel/softirq.c:571
    [<ffffffff8126a086>] invoke_softirq kernel/softirq.c:445 [inline]
    [<ffffffff8126a086>] __irq_exit_rcu+0xc6/0x110 kernel/softirq.c:650
    [<ffffffff848a7742>] sysvec_apic_timer_interrupt+0xa2/0xd0 arch/x86/kernel/apic/apic.c:1107
    [<ffffffff84a00cc6>] asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
    [<ffffffff848bd6e9>] native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
    [<ffffffff848bd6e9>] arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
    [<ffffffff848bd6e9>] acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
    [<ffffffff848bd6e9>] acpi_idle_do_entry+0xc9/0xe0 drivers/acpi/processor_idle.c:570
    [<ffffffff848bdc00>] acpi_idle_enter+0x150/0x230 drivers/acpi/processor_idle.c:707
    [<ffffffff83699eb4>] cpuidle_enter_state+0xc4/0x740 drivers/cpuidle/cpuidle.c:239



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
