Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1392F23FF3E
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 18:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgHIQ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 12:27:49 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:57339 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgHIQ1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 12:27:20 -0400
Received: by mail-io1-f71.google.com with SMTP id q20so5330614iod.23
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 09:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wSbi7FUa9Dr7lcrAw4zA/tNHG3Ok4PeAmcUOho11adg=;
        b=ROGLoNqlrp2LJ5W6o8pmcjmFmSDJszLq2LDxjZ9EkHVhbEwAkEaw3UpUjl46BDvuj6
         T1RRnrLr+bvSMuPCCozwpizGXu5lPPLgyxm6X+obCFyObMp6kM1P/NHnV9ZTUxyoMx4C
         v3Qt5P4KSGX0dMv6PF3mwmeasrmKFN1zcJl5YSeAq8ca9NDzY1AsHfjHVQ8FIYImBu8W
         WXErpdR2vzAoxI8kGgvQIZtyKtE+GdlAowSts6hlG+hzvjitArPIcDOaiVFBZQNOc0Tg
         d/qKlCDit+5M0xift2jO9CUAoilz+LT0UrikpSOWkGBNkgo770fBu2uNTuVrHEXobaIA
         ezww==
X-Gm-Message-State: AOAM531adCb5lBMmpknHNuvcna40WZKcH0QY1Aa7QT0jk2ax+WR+TOhX
        sNdSTZ1J+blJhSI3dZkD2h4A8/UYLCLUMRzWaZfeq0IUVY0z
X-Google-Smtp-Source: ABdhPJwDn4ma8NI6U/Q4f8GO0LDATgah2hLhKcC8bmZOmIIEEr07l+xKwI06c5Y0ZJReoNCmBuXCqenS1vTnD6CqlZ9cmDMyZqN5
MIME-Version: 1.0
X-Received: by 2002:a5e:9507:: with SMTP id r7mr14025341ioj.151.1596990438343;
 Sun, 09 Aug 2020 09:27:18 -0700 (PDT)
Date:   Sun, 09 Aug 2020 09:27:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c98a7f05ac744f53@google.com>
Subject: KMSAN: uninit-value in ath9k_htc_rx_msg
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

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=130c562c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=2ca247c2d60c7023de7f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ath9k_htc_rx_msg+0x28f/0x1f50 drivers/net/wireless/ath/ath9k/htc_hst.c:410
CPU: 0 PID: 4867 Comm: systemd-udevd Not tainted 5.8.0-rc5-syzkaller #0
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
RIP: 0010:tomoyo_path_matches_pattern+0xba/0x4d0 security/tomoyo/util.c:920
Code: 48 89 45 a0 8b 02 89 45 d0 4d 85 f6 4c 8b ad 70 ff ff ff 0f 85 c6 01 00 00 4c 89 7d b8 41 0f b7 44 24 0c 48 89 45 80 48 89 df <e8> 71 fd ea fc 49 8d 5c 24 0f 0f b7 00 48 89 45 88 8b 02 89 45 a8
RSP: 0018:ffff888111c0f858 EFLAGS: 00000246
RAX: 0000000000000015 RBX: ffff888111d41fe4 RCX: 0000000111941fd8
RDX: ffff888111941fd8 RSI: 0000000000000440 RDI: ffff888111d41fe4
RBP: ffff888111c0f8e8 R08: ffffea000000000f R09: ffff88812fffa000
R10: 0000000000000003 R11: ffff88811a320000 R12: ffff888111d41fd8
R13: ffff88811a3209d8 R14: 0000000000000000 R15: ffff888111c0fab0
 tomoyo_compare_name_union security/tomoyo/file.c:87 [inline]
 tomoyo_check_path_acl+0x272/0x360 security/tomoyo/file.c:260
 tomoyo_check_acl+0x239/0x5a0 security/tomoyo/domain.c:175
 tomoyo_path_permission security/tomoyo/file.c:586 [inline]
 tomoyo_path_perm+0x83f/0xc60 security/tomoyo/file.c:838
 tomoyo_inode_getattr+0x54/0x60 security/tomoyo/tomoyo.c:123
 security_inode_getattr+0x144/0x280 security/security.c:1278
 vfs_getattr fs/stat.c:121 [inline]
 vfs_statx+0x34c/0x940 fs/stat.c:206
 vfs_lstat include/linux/fs.h:3302 [inline]
 __do_sys_newlstat fs/stat.c:374 [inline]
 __se_sys_newlstat+0xce/0x920 fs/stat.c:368
 __x64_sys_newlstat+0x3e/0x60 fs/stat.c:368
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f72dd774335
Code: Bad RIP value.
RSP: 002b:00007ffeb28263b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
RAX: ffffffffffffffda RBX: 000055a2c06613f0 RCX: 00007f72dd774335
RDX: 00007ffeb28263f0 RSI: 00007ffeb28263f0 RDI: 000055a2c06603f0
RBP: 00007ffeb28264b0 R08: 00007f72dda33178 R09: 0000000000001010
R10: 0000000000000020 R11: 0000000000000246 R12: 000055a2c06603f0
R13: 000055a2c0660410 R14: 000055a2c064ce5b R15: 000055a2c064ce60

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


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
