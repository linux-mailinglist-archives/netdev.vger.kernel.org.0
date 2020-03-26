Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62C193DF4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgCZLeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:34:18 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33789 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgCZLeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:34:17 -0400
Received: by mail-io1-f70.google.com with SMTP id w25so4941364iom.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 04:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OeinQFi7x4TlScyCTQhRHYs3o4+FpLXfl1bcf2XkeHU=;
        b=Q58YZrJtANsjBc0S2Prq2WcdmYaaszptd3abgCdOxv2COTafFYynaqNFa+on93UVVT
         iXRNY26TVy9hd0set4Zdr121Ro4GHxMrHTA2sT8KhQQXSjP4LK3olxhvE+Rlr3yMFL4l
         TwdBsbd4cAyjc+SA84AgZjs6pcURmbQKSzQ/+iHThTpd2qbcxXUEXkgvV1v+s8pWhc3N
         QHgdVggjqg4965KBD9X/iuvWBli3bDLz6EUuhd/BUmE+VnlhM64t/Sv1negcx56Nl/ZD
         2cP+CQnADIZZ4paWhpRKW1bwh7Ls7tSRMYby4Gis9fZ8ccSIA2LFYATXz9DTLA1aze/7
         3Idg==
X-Gm-Message-State: ANhLgQ1rIpv+slrgvm0ONcOlBxrfB2DUpNANw452w0lMqfGrqM72tvjE
        NG9KgmqMKS3utQ+XxbbsK5gzWjDWr7AmXuUQcaNIwFCByrbN
X-Google-Smtp-Source: ADFU+vsqgiA/JP2Ls4ZR6uB3AkBQAQ0h+SfYGkztbIwJbRaJ5pX2Azq8wXCu2UNxpKEfK5jx9TCwcV+WALKhxu17MTcaoyFWAx51
MIME-Version: 1.0
X-Received: by 2002:a92:9edc:: with SMTP id s89mr8441522ilk.229.1585222456337;
 Thu, 26 Mar 2020 04:34:16 -0700 (PDT)
Date:   Thu, 26 Mar 2020 04:34:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000666c9c05a1c05d12@google.com>
Subject: general protection fault in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=112072ade00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
dashboard link: https://syzkaller.appspot.com/bug?extid=40d5d2e8a4680952f042
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143981d3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152072ade00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000015: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:usb_get_intfdata include/linux/usb.h:265 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0x103/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:643
Code: 83 3c 24 00 48 89 c3 0f 84 19 04 00 00 e8 95 d5 6e fe 48 8d bb a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 27 0c 00 00 4c 8b a3 a8 00 00 00 4d 85 e4 0f 84
RSP: 0018:ffff8881db209928 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff835ed4bc
RDX: 0000000000000015 RSI: ffffffff82d0804b RDI: 00000000000000a8
RBP: ffff8881d3c03b00 R08: ffffffff8702cc40 R09: fffffbfff0e28205
R10: fffffbfff0e28204 R11: ffffffff87141023 R12: 0100000000000001
R13: ffff8881ceef31c8 R14: ffff8881d3c03b00 R15: ffff8881d3c03b40
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056168f698a48 CR3: 00000001d050a000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
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
RSP: 0018:ffffffff87007d80 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffffffff8702cc40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffffff8702d48c
RBP: fffffbfff0e05988 R08: ffffffff8702cc40 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff87e607c0 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_kernel+0xe16/0xe5a init/main.c:998
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242
Modules linked in:
---[ end trace eca37a89cc7a3629 ]---
RIP: 0010:usb_get_intfdata include/linux/usb.h:265 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0x103/0xf70 drivers/net/wireless/ath/ath9k/hif_usb.c:643
Code: 83 3c 24 00 48 89 c3 0f 84 19 04 00 00 e8 95 d5 6e fe 48 8d bb a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 27 0c 00 00 4c 8b a3 a8 00 00 00 4d 85 e4 0f 84
RSP: 0018:ffff8881db209928 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff835ed4bc
RDX: 0000000000000015 RSI: ffffffff82d0804b RDI: 00000000000000a8
RBP: ffff8881d3c03b00 R08: ffffffff8702cc40 R09: fffffbfff0e28205
R10: fffffbfff0e28204 R11: ffffffff87141023 R12: 0100000000000001
R13: ffff8881ceef31c8 R14: ffff8881d3c03b00 R15: ffff8881d3c03b40
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056168f698a48 CR3: 00000001d050a000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
