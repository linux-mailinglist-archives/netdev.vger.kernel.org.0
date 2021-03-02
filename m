Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C192832B37D
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352659AbhCCEAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:07 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:34410 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349657AbhCBLBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:01:41 -0500
Received: by mail-il1-f198.google.com with SMTP id c16so14264814ile.1
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 03:00:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PV6+byP9zYXt5yV0DfIxComUkQdZHlJ/9e4G1hGksP0=;
        b=cMrNbrRPLIvk7Yb4mbMCd6K+T5FHyBRZTAvawxGCqy/Xl2Km22fo9wfbQ+BW18w6IW
         dVroVFAwKUvWQLYi3WQ7X5HJRg41jjllpNc5NaxgoB5/E6uU0GTdReDpmEE1d3aQhI0v
         XpZNKqLzogTb3r6d+YcVEQnosKgDRsqEdubetD0XiWqfC5rHrmTevCW0cEn3JbocVh8P
         eXxsS4W1pBoPYhLBRxFXjlVINcij+s9m2N6LMM3ZPUm7XoPluKXcS7tQ/tRnJm6bFthz
         X8NW2F4krWc+pNuA/zY/7ywMyxM8A7581TlNuZBya1GPYjcfoM1kTUvZtyCE/r+EukhU
         jTCA==
X-Gm-Message-State: AOAM532PB+tac+29R4Ki9nHSNo/JNTk+haFQ6nlu6vpvx0A73YSNzxbA
        MQwgdilshGorETbqDl5zjtgyxBRgtUbKlh66yWVzHQt3Ifyw
X-Google-Smtp-Source: ABdhPJwNP5cCrM4/Vv/m1YSWf7ImxOMj87RE/r6t3/BlCMFR5ZyR7+5WPvU4rk5132HHQfn9XeZc0cfPb3atw2VU/9aNOZvaFMwo
MIME-Version: 1.0
X-Received: by 2002:a92:4a0e:: with SMTP id m14mr11000770ilf.117.1614682813341;
 Tue, 02 Mar 2021 03:00:13 -0800 (PST)
Date:   Tue, 02 Mar 2021 03:00:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000083a5d205bc8ba364@google.com>
Subject: WARNING: refcount bug in sctp_transport_put (3)
From:   syzbot <syzbot+9cf577014b7a043dbb0d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2c87f7a3 Merge tag 'pwm/for-5.12-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=155a6632d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb762f1df8da5074
dashboard link: https://syzkaller.appspot.com/bug?extid=9cf577014b7a043dbb0d
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9cf577014b7a043dbb0d@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 10072 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Modules linked in:
CPU: 1 PID: 10072 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 dc 17 f5 fd e9 8a fe ff ff e8 22 3a b1 fd 48 c7 c7 a0 d8 be 89 c6 05 60 9d ef 09 01 e8 a0 f1 fe 04 <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc900004e8d08 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880137ad340 RSI: ffffffff815bd0e5 RDI: fffff5200009d193
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815b61be R11: 0000000000000000 R12: ffff88805f193020
R13: 1ffff9200009d1a9 R14: ffffffff882930c0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000008169834 CR3: 000000000bc8e000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 sctp_transport_put+0x138/0x180 net/sctp/transport.c:325
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
 expire_timers kernel/time/timer.c:1476 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
 __run_timers kernel/time/timer.c:1726 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:90 [inline]
RIP: 0010:lock_is_held_type+0x31/0x130 kernel/locking/lockdep.c:5542
Code: bd 01 00 00 00 41 54 55 53 48 83 ec 08 8b 0d 32 af c3 04 85 c9 0f 84 d0 00 00 00 65 8b 05 d7 8f ff 76 85 c0 0f 85 c1 00 00 00 <65> 4c 8b 24 25 00 f0 01 00 41 8b 94 24 84 09 00 00 85 d2 0f 85 a8
RSP: 0018:ffffc90023f5f568 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 1ffff920047ebeb9 RCX: 0000000000000001
RDX: 1ffffffff17ef936 RSI: 00000000ffffffff RDI: ffffffff8bf742e0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8dc5e84f
R10: fffffbfff1b8bd09 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
 lock_is_held include/linux/lockdep.h:278 [inline]
 rcu_read_lock_sched_held+0x3a/0x70 kernel/rcu/update.c:125
 trace_lock_acquire include/trace/events/lock.h:13 [inline]
 lock_acquire+0x5d4/0x730 kernel/locking/lockdep.c:5481
 rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
 rcu_read_lock include/linux/rcupdate.h:656 [inline]
 lock_page_memcg+0x69/0x4f0 mm/memcontrol.c:2142
 page_remove_rmap+0x25/0x1430 mm/rmap.c:1349
 zap_pte_range mm/memory.c:1276 [inline]
 zap_pmd_range mm/memory.c:1380 [inline]
 zap_pud_range mm/memory.c:1409 [inline]
 zap_p4d_range mm/memory.c:1430 [inline]
 unmap_page_range+0xe30/0x2650 mm/memory.c:1451
 unmap_single_vma+0x198/0x300 mm/memory.c:1496
 unmap_vmas+0x16d/0x2f0 mm/memory.c:1528
 exit_mmap+0x2a8/0x590 mm/mmap.c:3218
 __mmput+0x122/0x470 kernel/fork.c:1082
 mmput+0x58/0x60 kernel/fork.c:1103
 exit_mm kernel/exit.c:501 [inline]
 do_exit+0xb6f/0x2ae0 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x42c/0x2100 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
 __do_fast_syscall_32+0x62/0x80 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fd8549
Code: Unable to access opcode bytes at RIP 0xf7fd851f.
RSP: 002b:00000000f55d25fc EFLAGS: 00000296 ORIG_RAX: 0000000000000150
RAX: 0000000000000003 RBX: 000000002001d000 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: 00000000ffffffff RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
