Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81C1283239
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJEIid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:38:33 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:34069 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgJEIiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:38:25 -0400
Received: by mail-il1-f205.google.com with SMTP id f89so3811910ill.1
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 01:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fnx1lacPr4RD2lq8lO1WM//67u3yl76a9A5fDLAfxDU=;
        b=bV5Segda1pCA5rwTfRRXRBU7oAoN7YA9POwi9VH05tLCrF69mDd7/H5tsyeEvYkmab
         AMjXlr1w9vVjPv9/r+7txd30lxC1OcRPG4+sXSKFwTgSnnGBhs7UOOBWypVfrp0AWDu9
         Ppj/iAvZNi2D/kcdWk/suK8Rmmg4tMoiaDuI9Qj8EoOS3O9++lhI7vbplFA9lfXi2G5n
         kryDa6d9ApY9NcP2ggTwviYSgKqSSDeATE33CD/DHgfGsJsP1qIBzexO3QmmMHsyd3/Z
         3KOuhdouDGJQSX5VefXUvnrLzEjfL/r68OpvCPYuRNcOEigzkuQ5UrcCsemzCxn+wfcu
         92nQ==
X-Gm-Message-State: AOAM531Ei+Eeot79hPSasJ9xkhWveYb76y7bw0vE6XyJPolnvS0QaeO0
        SOFa95xLHvxgIFuL/P54JpM3afWlPlPU5QpVCubIAGcKaw23
X-Google-Smtp-Source: ABdhPJwKtlc5jFzYGJ999aLM/DCVdDqPAtjjrIZox5y6DsCL1kX5LRtjjyTVED5nf5waWgQaCuV5CcwzmXPEnMCnGGrlEWOWghLM
MIME-Version: 1.0
X-Received: by 2002:a92:d986:: with SMTP id r6mr10957051iln.302.1601887103032;
 Mon, 05 Oct 2020 01:38:23 -0700 (PDT)
Date:   Mon, 05 Oct 2020 01:38:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf21d705b0e8674c@google.com>
Subject: WARNING in __ieee80211_beacon_get
From:   syzbot <syzbot+18c783c5cf6a781e3e2c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ramonreisfontes@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    456afe01 mptcp: ADD_ADDRs with echo bit are smaller
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16047c57900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1e6c5266df853ae
dashboard link: https://syzkaller.appspot.com/bug?extid=18c783c5cf6a781e3e2c
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a68fdf900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ef31eb900000

The issue was bisected to:

commit 7dfd8ac327301f302b03072066c66eb32578e940
Author: Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Thu Oct 10 18:13:07 2019 +0000

    mac80211_hwsim: add support for OCB

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c463a3900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=102463a3900000
console output: https://syzkaller.appspot.com/x/log.txt?x=17c463a3900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+18c783c5cf6a781e3e2c@syzkaller.appspotmail.com
Fixes: 7dfd8ac32730 ("mac80211_hwsim: add support for OCB")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6900 at net/mac80211/tx.c:4875 __ieee80211_beacon_get+0xb59/0x1aa0 net/mac80211/tx.c:4875
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6900 Comm: syz-executor345 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:__ieee80211_beacon_get+0xb59/0x1aa0 net/mac80211/tx.c:4875
Code: b8 00 00 00 00 00 fc ff df 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e fe 0c 00 00 41 83 4c 24 28 1a eb 0a e8 a7 15 9b f9 <0f> 0b 45 31 e4 e8 9d 15 9b f9 e8 e8 3e 5b 00 31 ff 89 c3 89 c6 e8
RSP: 0018:ffffc90000da8b40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880a96b5e18 RCX: ffffffff87db68e5
RDX: ffff888091824540 RSI: ffffffff87db7209 RDI: 0000000000000005
RBP: 000000000000000b R08: 0000000000000001 R09: ffffc90000da8c88
R10: 0000000000000007 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880872c0c80 R14: 0000000000000000 R15: ffffc90000da8c88
 ieee80211_beacon_get_tim+0x88/0x910 net/mac80211/tx.c:4939
 ieee80211_beacon_get include/net/mac80211.h:4909 [inline]
 mac80211_hwsim_beacon_tx+0x111/0x910 drivers/net/wireless/mac80211_hwsim.c:1729
 __iterate_interfaces+0x1e5/0x520 net/mac80211/util.c:792
 ieee80211_iterate_active_interfaces_atomic+0x8d/0x170 net/mac80211/util.c:828
 mac80211_hwsim_beacon+0xd5/0x1a0 drivers/net/wireless/mac80211_hwsim.c:1782
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x6a9/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1605
 __do_softirq+0x1f8/0xb23 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__sanitizer_cov_trace_pc+0x30/0x60 kernel/kcov.c:197
Code: fe 01 00 65 8b 05 c0 76 8b 7e a9 00 01 ff 00 48 8b 34 24 74 0f f6 c4 01 74 35 8b 82 4c 14 00 00 85 c0 74 2b 8b 82 28 14 00 00 <83> f8 02 75 20 48 8b 8a 30 14 00 00 8b 92 2c 14 00 00 48 8b 01 48
RSP: 0018:ffffc900048072d8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff8880a96b4c00 RCX: ffffffff87dd0f8e
RDX: ffff888091824540 RSI: ffffffff87dd0f61 RDI: ffff8880a96b5558
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8880872c296f
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880a7bbaa20 R14: dffffc0000000000 R15: 0000000000000000
 ieee80211_chanctx_radar_detect+0x1f1/0x3a0 net/mac80211/util.c:4266
 ieee80211_check_combinations+0x3b9/0x880 net/mac80211/util.c:4325
 ieee80211_check_concurrent_iface+0x45b/0x670 net/mac80211/iface.c:309
 ieee80211_runtime_change_iftype net/mac80211/iface.c:1672 [inline]
 ieee80211_if_change_type+0x288/0x620 net/mac80211/iface.c:1712
 ieee80211_change_iface+0x26/0x210 net/mac80211/cfg.c:157
 rdev_change_virtual_intf net/wireless/rdev-ops.h:69 [inline]
 cfg80211_change_iface+0x2ec/0xfe0 net/wireless/util.c:1032
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3789
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4423d9
Code: e8 ac 00 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcf9989098 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004423d9
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000003
RBP: 000000306e616c77 R08: 0000002000000000 R09: 0000002000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000080bde
R13: 0000000000000000 R14: 000000000000000c R15: 0000000000000004
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
