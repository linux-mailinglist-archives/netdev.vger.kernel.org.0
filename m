Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB427A8C6
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgI1HhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:37:19 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:55371 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgI1HhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:37:18 -0400
Received: by mail-il1-f208.google.com with SMTP id i12so89630ill.22
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=04SWKSSMPO5wiPUAGW/9pHu3f+KlpomAZBHkybrJOqk=;
        b=ew0UKseZefabn6JKpbtR0UvYHsPqdezS6vdheQUJR3hniXZHIsl0TNt0CU8JMAM3kv
         ZF3SP+gcBZXylNsaJNK8w0vWtGrtjdLkBtY4YqrXjvyJEal9EV4Nk/t/49atzlIOFWgX
         XW3K3+tqkTNw2ksi5Eb6sYo0JCO9mnwOwEL8rbAn7ytEIhXKDoXHZKLgEezQ8APCzHNf
         ZFK7Ya0QnUYeQFOvYydJPe+QMuGSo6YYAfunPG8yYg819i1S/4lutFW5TiykAaxCNdXH
         lXkrzyonPDq4SCQSDe1HxNEpSqQiuAabc02LhtGJ6tpKUoET+yoae0i/mB7aws9tvGf5
         EQgQ==
X-Gm-Message-State: AOAM532ckxSKE+l+V+aCotWUWV4T4jhLicZ4MRiLmYQaBF0vLjoVFqLS
        gR5YZguJ6x3LaDPTnjt7SfL75yySUvCquajSeOVPAFJkwEXm
X-Google-Smtp-Source: ABdhPJzvRHP+j1PB4wus3aYitS2UDMRTL51vrngDEalOsgPFVzQBnvE7WncmG+K1fEi6zIPaamYL1i9N0XBWPtaSysf/4DEALoK8
MIME-Version: 1.0
X-Received: by 2002:a92:4a0c:: with SMTP id m12mr122549ilf.238.1601278636781;
 Mon, 28 Sep 2020 00:37:16 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:37:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054f46105b05abcd5@google.com>
Subject: general protection fault in mac80211_hwsim_tx_frame_no_nl
From:   syzbot <syzbot+84f7d08012d5c1f0f59e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    171d4ff7 Merge tag 'mmc-v5.9-rc4-2' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d1a809900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=240e2ebab67245c7
dashboard link: https://syzkaller.appspot.com/bug?extid=84f7d08012d5c1f0f59e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+84f7d08012d5c1f0f59e@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000338: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x00000000000019c0-0x00000000000019c7]
CPU: 1 PID: 27410 Comm: syz-executor.4 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mac80211_hwsim_tx_frame_no_nl.isra.0+0x728/0x12d0 drivers/net/wireless/mac80211_hwsim.c:1408
Code: 89 b4 24 90 00 00 00 c6 84 24 98 00 00 00 00 74 bb e8 6c 5f 50 fc 48 8d bb c4 19 00 00 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 28 38 d0 7f 08 84 c0 0f 85 39 09 00 00 44 0f b6 bb c4 19
RSP: 0018:ffffc90000da8b68 EFLAGS: 00010202
RAX: 0000000000000338 RBX: 0000000000000000 RCX: ffffffff8525df4e
RDX: 0000000000000004 RSI: ffffffff8525ded4 RDI: 00000000000019c4
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffffffff8d0c0a3f
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888047738500
R13: ffff888051ca3120 R14: ffff888051ca3350 R15: 0000000000000077
FS:  0000000000000000(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055783cad52c8 CR3: 000000005a64a000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 mac80211_hwsim_tx_frame+0x14f/0x1e0 drivers/net/wireless/mac80211_hwsim.c:1654
 mac80211_hwsim_beacon_tx+0x439/0x810 drivers/net/wireless/mac80211_hwsim.c:1694
 __iterate_interfaces+0x124/0x4d0 net/mac80211/util.c:737
 ieee80211_iterate_active_interfaces_atomic+0x8d/0x170 net/mac80211/util.c:773
 mac80211_hwsim_beacon+0xd5/0x1a0 drivers/net/wireless/mac80211_hwsim.c:1717
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
RIP: 0010:__raw_write_unlock_irq include/linux/rwlock_api_smp.h:268 [inline]
RIP: 0010:_raw_write_unlock_irq+0x4b/0x80 kernel/locking/spinlock.c:343
Code: c0 b8 6b fc 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 31 48 83 3d 56 9f d3 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 6b 28 28 f9 65 8b 05 04 32 d9 77 85 c0 74 02 5d
RSP: 0018:ffffc900074a7ae8 EFLAGS: 00000282
RAX: 1ffffffff13f8d77 RBX: ffff888037acc480 RCX: 1ffffffff16b2531
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffffff89e09080 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff888048116340 R14: dffffc0000000000 R15: 00000000ffffffff
 release_task+0xc4e/0x14d0 kernel/exit.c:219
 exit_notify kernel/exit.c:681 [inline]
 do_exit+0x14db/0x29f0 kernel/exit.c:826
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e179
Code: Bad RIP value.
RSP: 002b:00007f248bdfacf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000118cf48 RCX: 000000000045e179
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000118cf48
RBP: 000000000118cf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffec4bea0bf R14: 00007f248bdfb9c0 R15: 000000000118cf4c
Modules linked in:
---[ end trace fba95d8d60d8e645 ]---
RIP: 0010:mac80211_hwsim_tx_frame_no_nl.isra.0+0x728/0x12d0 drivers/net/wireless/mac80211_hwsim.c:1408
Code: 89 b4 24 90 00 00 00 c6 84 24 98 00 00 00 00 74 bb e8 6c 5f 50 fc 48 8d bb c4 19 00 00 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 28 38 d0 7f 08 84 c0 0f 85 39 09 00 00 44 0f b6 bb c4 19
RSP: 0018:ffffc90000da8b68 EFLAGS: 00010202
RAX: 0000000000000338 RBX: 0000000000000000 RCX: ffffffff8525df4e
RDX: 0000000000000004 RSI: ffffffff8525ded4 RDI: 00000000000019c4
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffffffff8d0c0a3f
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888047738500
R13: ffff888051ca3120 R14: ffff888051ca3350 R15: 0000000000000077
FS:  0000000000000000(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055783cad52c8 CR3: 000000005a64a000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
