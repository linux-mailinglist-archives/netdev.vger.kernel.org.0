Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46754323009
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 18:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhBWR4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 12:56:11 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:46243 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhBWR4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 12:56:02 -0500
Received: by mail-io1-f69.google.com with SMTP id s26so11819783ioe.13
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 09:55:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fT48g9h0S+gy4Ojz4VVsb9c+BWOlqpsqL3o3V6eM2GU=;
        b=fi8rVym430PdnY5Yfi5GWhsI5y6V4qToHingWyK0fI1R3RvTGCsSM+iZ2dHBcQFtG4
         b4r+rCs4TVmV22/SC6crrw+C1vtilJFy4egAXWwDYo943RtyJdOamH4cGlIyH1C5wa3k
         Hi9WRWUt6snFu4cePX8YFVeW8T3IaAwp8kxuzprZr/fy+vXPV8gmvE2FxtxE1i6kGFLY
         /TFWOmCpsncsR8HRFfHWO5o17ciiD5KjMprUsnLoGtUPBQbdpJm/KJ2derCnJ8rR17+M
         tBq8P02IHjtcuizyazRefsnAa99tR3hvTxggx1/qSAZrBniMEqFE/iXzMgkHUkT55OTp
         aCWA==
X-Gm-Message-State: AOAM5338MnMpkjMF7uSh44doxFuosJuwZhR6ZGfT6biqdcVrez3fKLIk
        PU6IIJF44jBRr/YfPmuHPGLdFWZLOTMl6ywd7gLCq5sWMSlX
X-Google-Smtp-Source: ABdhPJw2W3VZbbJexgoqTtgrw7cdX8+Jzj7hZd5pniQHz03ul5QJh8nZXrsVEJ5zJgdb6zV0HreygduyCPqpjfA9umDeGKznEc0C
MIME-Version: 1.0
X-Received: by 2002:a5e:890a:: with SMTP id k10mr21184821ioj.63.1614102920771;
 Tue, 23 Feb 2021 09:55:20 -0800 (PST)
Date:   Tue, 23 Feb 2021 09:55:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039404305bc049fa5@google.com>
Subject: BUG: soft lockup in ieee80211_tasklet_handler
From:   syzbot <syzbot+27df43cf7ae73de7d8ee@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3b9cdafb Merge tag 'pinctrl-v5.12-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153024bcd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=22008533485b2c35
dashboard link: https://syzkaller.appspot.com/bug?extid=27df43cf7ae73de7d8ee

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+27df43cf7ae73de7d8ee@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 122s! [syz-executor.4:18357]
Modules linked in:
irq event stamp: 20542405
hardirqs last  enabled at (20542404): [<ffffffff89200d42>] asm_sysvec_irq_work+0x12/0x20 arch/x86/include/asm/idtentry.h:661
hardirqs last disabled at (20542405): [<ffffffff8901540c>] sysvec_apic_timer_interrupt+0xc/0x100 arch/x86/kernel/apic/apic.c:1100
softirqs last  enabled at (18968488): [<ffffffff89200eaf>] asm_call_irq_on_stack+0xf/0x20
softirqs last disabled at (18968491): [<ffffffff89200eaf>] asm_call_irq_on_stack+0xf/0x20
CPU: 0 PID: 18357 Comm: syz-executor.4 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:jhash+0x339/0x5d0 include/linux/jhash.h:95
Code: fc ff df 48 89 fa 48 c1 ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 8a 02 00 00 0f b6 43 06 c1 e0 10 41 01 c7 <e8> 92 7f b2 fd 48 8d 7b 05 48 b8 00 00 00 00 00 fc ff df 48 89 fa
RSP: 0018:ffffc90000007a08 EFLAGS: 00000297
RAX: 0000000000000000 RBX: ffff88801419dc5a RCX: 000000000000000c
RDX: 0000000000000000 RSI: ffff88806da10000 RDI: 0000000000000003
RBP: 0000000000000006 R08: ffffffff89bed200 R09: ffffffff83c0d347
R10: 000000000000000c R11: 0000000000000006 R12: 0000000000000006
R13: 00000000b59356c8 R14: 00000000b59356c8 R15: 00000000b59356c8
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557aa2d18ea8 CR3: 000000001466b000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 rht_key_hashfn include/linux/rhashtable.h:159 [inline]
 __rhashtable_lookup+0x22b/0x780 include/linux/rhashtable.h:596
 rhltable_lookup include/linux/rhashtable.h:688 [inline]
 sta_info_hash_lookup net/mac80211/sta_info.c:162 [inline]
 sta_info_get_bss+0x144/0x3f0 net/mac80211/sta_info.c:199
 __ieee80211_rx_handle_packet net/mac80211/rx.c:4694 [inline]
 ieee80211_rx_list+0x910/0x2680 net/mac80211/rx.c:4819
 ieee80211_rx_napi+0xf7/0x3d0 net/mac80211/rx.c:4842
 ieee80211_rx include/net/mac80211.h:4524 [inline]
 ieee80211_tasklet_handler+0xd4/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x1d7/0x2d0 kernel/softirq.c:555
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu kernel/softirq.c:420 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:635
RIP: 0010:mm_update_next_owner+0x50f/0x7a0 kernel/exit.c:391
Code: 06 00 00 48 8d a8 f0 f9 ff ff 49 39 c7 0f 84 eb fe ff ff e8 43 e3 2e 00 48 8d 85 a0 04 00 00 48 89 c2 48 c1 ea 03 80 3c 1a 00 <0f> 85 96 01 00 00 4c 8b b5 a0 04 00 00 4d 39 e6 75 95 49 89 c5 e9
RSP: 0018:ffffc90002067b18 EFLAGS: 00000246
RAX: ffff888012bcbc20 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 1ffff11002579784 RSI: ffffffff814470fd RDI: ffff888012bcbf38
RBP: ffff888012bcb780 R08: 0000000000000000 R09: ffffffff8bc0a083
R10: ffffffff8144705f R11: 0000000000000001 R12: ffff888073213f00
R13: ffff888012bcb780 R14: 0000000000000000 R15: ffff88802655c110
 exit_mm kernel/exit.c:500 [inline]
 do_exit+0xb67/0x2ae0 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x42c/0x2100 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: Unable to access opcode bytes at RIP 0x465ecf.
RSP: 002b:00007f599085f218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000056bf68 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf68
RBP: 000000000056bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf6c
R13: 00007ffd3669b9ff R14: 00007f599085f300 R15: 0000000000022000
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 18367 Comm: syz-executor.5 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:queued_write_lock_slowpath+0x131/0x270 kernel/locking/qrwlock.c:76
Code: 00 00 00 00 fc ff df 49 01 c7 41 83 c6 03 41 0f b6 07 41 38 c6 7c 08 84 c0 0f 85 fe 00 00 00 8b 03 3d 00 01 00 00 74 19 f3 90 <41> 0f b6 07 41 38 c6 7c ec 84 c0 74 e8 48 89 df e8 ea c7 5c 00 eb
RSP: 0018:ffffc90001ee7ca0 EFLAGS: 00000006
RAX: 0000000000000300 RBX: ffffffff8bc0a080 RCX: ffffffff8159eafa
RDX: fffffbfff1781411 RSI: 0000000000000004 RDI: ffffffff8bc0a080
RBP: 00000000000000ff R08: 0000000000000001 R09: ffffffff8bc0a083
R10: fffffbfff1781410 R11: 0000000000000000 R12: 1ffff920003dcf95
R13: ffffffff8bc0a084 R14: 0000000000000003 R15: fffffbfff1781410
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000004 CR3: 0000000026091000 CR4: 0000000000350ee0
Call Trace:
 queued_write_lock include/asm-generic/qrwlock.h:97 [inline]
 do_raw_write_lock+0x1ce/0x280 kernel/locking/spinlock_debug.c:207
 exit_notify kernel/exit.c:667 [inline]
 do_exit+0xcaf/0x2ae0 kernel/exit.c:845
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: Unable to access opcode bytes at RIP 0x465ecf.
RSP: 002b:00007ffd63249718 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 000000000000001e RCX: 0000000000465ef9
RDX: 000000000041920b RSI: ffffffffffffffbc RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000001 R15: 00007ffd63249810


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
