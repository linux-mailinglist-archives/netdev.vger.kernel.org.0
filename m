Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37CF818C80E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 08:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCTHOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 03:14:15 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:56494 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgCTHOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 03:14:14 -0400
Received: by mail-il1-f200.google.com with SMTP id 191so4180940ilb.23
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 00:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=y/7OFkTqlcH2sU9QydtVhaMn6LXHA7sVeaTw6bwwdfs=;
        b=aShrWVeeoH/CiByRsoj6YY+z/iM//4hV9IhK142bpieQxgtt7OVR1zAjWVNWOMXP+v
         kxwpg4LHII/K46OejRA0lhlxFPxAlj/BLJ489yhq5/jFRJ7AoigaNcJqEg6OzL129J14
         QsUbf9qvO3BR6iVoy4u3DoRtsvrk2+qnwp3yx5Tf5qN6v10llkOVHxXebQnMPoGgpSFF
         1QfthamkxM8mSHIWlubT1qvJZljVZRxX09QLMWRdhJAgBj8L3yZB9mLKkoJFAkiuXNgS
         gVQ72+fZVjV2mN5XTp/gqLQ8N35z61aWCqDNS0AnaxneuuiKZPXZg8u7VMucB3W5tOC7
         uynA==
X-Gm-Message-State: ANhLgQ3K023jE62pVvGrTcIl7c+Mk8oXpnVUASNj7LUIsIGZiR7oswWx
        N7cTqnubkcPG0qkzDtrsq3MZhrzXdGoLPqqXxqFLFEF55S6W
X-Google-Smtp-Source: ADFU+vuj9UsKauUlK7sqRqFQFc1lqdDk8OCKvMoEPI9rtvxl4pB2NVA6QZWhiLuAT8qUKHyhtXMiv18N46NLA16e2KZefJ/YJTar
MIME-Version: 1.0
X-Received: by 2002:a92:5fc5:: with SMTP id i66mr6755410ill.303.1584688453786;
 Fri, 20 Mar 2020 00:14:13 -0700 (PDT)
Date:   Fri, 20 Mar 2020 00:14:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e238a05a14408e4@google.com>
Subject: general protection fault in hsr_addr_is_self (2)
From:   syzbot <syzbot+fcf5dd39282ceb27108d@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd607737 Merge tag '5.6-rc6-smb3-fixes' of git://git.samba..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f4561de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=fcf5dd39282ceb27108d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fcf5dd39282ceb27108d@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 PID: 9421 Comm: udevd Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:hsr_addr_is_self+0x70/0x2e0 net/hsr/hsr_framereg.c:44
Code: 34 c7 00 f1 f1 f1 f1 c7 40 04 00 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 44 24 58 31 c0 e8 f7 23 c2 f9 4c 89 e8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 3e 02 00 00 48 8b 43 30 49 39 c5 48 89 44 24
RSP: 0018:ffffc90000da8a90 EFLAGS: 00010206
RAX: 0000000000000006 RBX: 0000000000000000 RCX: ffffffff87b0901a
RDX: 0000000000000100 RSI: ffffffff87b00129 RDI: 0000000000000000
RBP: ffff8880a40d7448 R08: ffff8880917d4580 R09: ffffed1015ce7074
R10: ffffed1015ce7073 R11: ffff8880ae73839b R12: 1ffff920001b5152
R13: 0000000000000030 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007f387c3777a0(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f387c37e000 CR3: 0000000095237000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 hsr_handle_frame+0x2d1/0x650 net/hsr/hsr_slave.c:33
 __netif_receive_skb_core+0xfbc/0x30b0 net/core/dev.c:5088
 __netif_receive_skb_one_core+0x99/0x160 net/core/dev.c:5185
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5301
 process_backlog+0x21e/0x7a0 net/core/dev.c:6133
 napi_poll net/core/dev.c:6571 [inline]
 net_rx_action+0x4c2/0x1070 net/core/dev.c:6639
 __do_softirq+0x26c/0x99d kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x192/0x1d0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
RIP: 0010:lock_acquire+0x209/0x420 kernel/locking/lockdep.c:4487
Code: 94 08 00 00 00 00 00 00 48 c1 e8 03 80 3c 10 00 0f 85 de 01 00 00 48 83 3d a3 0f 1b 08 00 0f 84 5a 01 00 00 48 8b 3c 24 57 9d <0f> 1f 44 00 00 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 65 8b
RSP: 0018:ffffc900020d7800 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff12e7698 RBX: ffff8880917d4580 RCX: 0000000000004cd1
RDX: dffffc0000000000 RSI: 1ffff9200041aee9 RDI: 0000000000000286
RBP: ffff8880a8369070 R08: ffffffff8c04d188 R09: fffffbfff180e577
R10: fffffbfff180e576 R11: ffffffff8c072bb7 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 copy_pte_range mm/memory.c:816 [inline]
 copy_pmd_range mm/memory.c:892 [inline]
 copy_pud_range mm/memory.c:926 [inline]
 copy_p4d_range mm/memory.c:948 [inline]
 copy_page_range+0xa6a/0x1f30 mm/memory.c:1010
 dup_mmap kernel/fork.c:604 [inline]
 dup_mm+0x9cf/0x1340 kernel/fork.c:1360
 copy_mm kernel/fork.c:1416 [inline]
 copy_process+0x2987/0x7290 kernel/fork.c:2081
 _do_fork+0x12d/0x1010 kernel/fork.c:2430
 __do_sys_clone kernel/fork.c:2585 [inline]
 __se_sys_clone kernel/fork.c:2566 [inline]
 __x64_sys_clone+0x182/0x210 kernel/fork.c:2566
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f387ba5af46
Code: f7 d8 64 89 04 25 d4 02 00 00 64 4c 8b 14 25 10 00 00 00 31 d2 49 81 c2 d0 02 00 00 31 f6 bf 11 00 20 01 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 31 01 00 00 85 c0 41 89 c4 0f 85 3b 01 00
RSP: 002b:00007ffff9bfad00 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007ffff9bfad00 RCX: 00007f387ba5af46
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 00007ffff9bfad60 R08: 00000000000024cd R09: 00000000000024cd
R10: 00007f387c377a70 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffff9bfad20 R14: 0000000000000005 R15: 0000000000000005
Modules linked in:
---[ end trace 3228e95e3491c130 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:hsr_addr_is_self+0x70/0x2e0 net/hsr/hsr_framereg.c:44
Code: 34 c7 00 f1 f1 f1 f1 c7 40 04 00 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 44 24 58 31 c0 e8 f7 23 c2 f9 4c 89 e8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 3e 02 00 00 48 8b 43 30 49 39 c5 48 89 44 24
RSP: 0018:ffffc90000da8a90 EFLAGS: 00010206
RAX: 0000000000000006 RBX: 0000000000000000 RCX: ffffffff87b0901a
RDX: 0000000000000100 RSI: ffffffff87b00129 RDI: 0000000000000000
RBP: ffff8880a40d7448 R08: ffff8880917d4580 R09: ffffed1015ce7074
R10: ffffed1015ce7073 R11: ffff8880ae73839b R12: 1ffff920001b5152
R13: 0000000000000030 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007f387c3777a0(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f387c37e000 CR3: 0000000095237000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
