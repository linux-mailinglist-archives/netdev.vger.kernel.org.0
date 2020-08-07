Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94C223E7F8
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 09:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgHGHaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 03:30:18 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43936 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHGHaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 03:30:17 -0400
Received: by mail-io1-f71.google.com with SMTP id f19so1007684iol.10
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 00:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JOb+Ait29c8UaKGoRPSevgV4SXs3lLIQQpLOa7Dp1qU=;
        b=rxuhlNmI0cflleliqMMj4KUImc9dmHiVPYsPrPol0OHSbQISOd70quysVNAocGhCu9
         xKdZ/dmaSvFuB4qweJsFD8ui9cH0JEWTGCq5iHfQ8u4VhHS6AQtQDalqnaaXEatG69cl
         001UCaMYYJ0k4vfasCuYeN5+WpVSH583U5CUr2Q2TqI/D4OUP0l5Sc/WGdVJ60uvfpEp
         zoQdoFwIeBznR9SaP8gGj1qquSNI4Na26gNshiIhhDc+48vS0lMuiwSWrYfxpNOdWkzB
         yVVJKYtl9KG8sy8qwlr1ZH11YzundddsDR7vIJIAQFZDI/4IYKTpP0+4WhTnd9LfHjMc
         uRHw==
X-Gm-Message-State: AOAM532jjFXcbCGpOT5pHUPqEgRRKhzjyOD42BoLcBd4RuJ2nuyCSFdd
        svhTHs0I5v/8wAp50ctuoDNC78WQhu6GNb5JlqTh4O94/qTi
X-Google-Smtp-Source: ABdhPJzPpPvtcSJHqTUBAqF/YbXRQ/z7Jc4/l/rPj4QW3esD3oT9PRdTX/LX7R2aNd0MRgmH2DbtXTYFS5wPb9fcwOoILYqjJ4RZ
MIME-Version: 1.0
X-Received: by 2002:a92:ba57:: with SMTP id o84mr2898216ili.215.1596785416214;
 Fri, 07 Aug 2020 00:30:16 -0700 (PDT)
Date:   Fri, 07 Aug 2020 00:30:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000841f8305ac4493b2@google.com>
Subject: WARNING: refcount bug in l2tp_session_free
From:   syzbot <syzbot+f20ee2ee6060c79efb65@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        jchapman@katalix.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, pablo@netfilter.org,
        ridge.kennedy@alliedtelesis.co.nz, syzkaller-bugs@googlegroups.com,
        vulab@iscas.ac.cn
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    04300d66 Merge tag 'riscv-for-linus-5.8-rc7' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17beee28900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f3bc31881f1ae8a7
dashboard link: https://syzkaller.appspot.com/bug?extid=f20ee2ee6060c79efb65
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f20ee2ee6060c79efb65@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 6980 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6980 Comm: syz-executor.1 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:540
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Code: c7 2a 86 14 89 31 c0 e8 d3 f2 a8 fd 0f 0b eb 85 e8 2a 32 d7 fd c6 05 43 cc eb 05 01 48 c7 c7 56 86 14 89 31 c0 e8 b5 f2 a8 fd <0f> 0b e9 64 ff ff ff e8 09 32 d7 fd c6 05 23 cc eb 05 01 48 c7 c7
RSP: 0018:ffffc90000da8de8 EFLAGS: 00010246
RAX: d0e66feebea22600 RBX: 0000000000000003 RCX: ffff888086b3c200
RDX: 0000000080000102 RSI: 0000000080000102 RDI: 0000000000000000
RBP: 0000000000000003 R08: ffffffff815dd389 R09: ffffed1015d241c3
R10: ffffed1015d241c3 R11: 0000000000000000 R12: ffff888000f3f040
R13: dffffc0000000000 R14: ffff8880a9256800 R15: ffff888000f3f0c0
 l2tp_tunnel_dec_refcount include/linux/refcount.h:274 [inline]
 l2tp_session_free+0x1a5/0x1f0 net/l2tp/l2tp_core.c:1570
 __sk_destruct+0x50/0x770 net/core/sock.c:1786
 rcu_do_batch kernel/rcu/tree.c:2414 [inline]
 rcu_core+0x816/0x1120 kernel/rcu/tree.c:2641
 __do_softirq+0x268/0x80c kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0xe0/0x1a0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu+0x1e1/0x1f0 kernel/softirq.c:417
 irq_exit_rcu+0x6/0x50 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x117/0x130 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:585
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x57/0x80 kernel/locking/spinlock.c:199
Code: 00 00 00 00 fc ff df 80 3c 08 00 74 0c 48 c7 c7 08 c8 4b 89 e8 da 40 93 f9 48 83 3d aa 67 2b 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 af 38 30 f9 65 8b 05 94 9d e1 77 85 c0 74 02 5b
RSP: 0018:ffffc90004957cb8 EFLAGS: 00000282
RAX: 1ffffffff1297901 RBX: ffff8880ae9358c0 RCX: dffffc0000000000
RDX: 0000000040000000 RSI: 0000000000000000 RDI: ffffffff8820602f
RBP: ffffc90004957d18 R08: ffffffff817a3350 R09: ffffed1015d26b19
R10: ffffed1015d26b19 R11: 0000000000000000 R12: ffff8880ae9358c0
R13: ffff888086b3c200 R14: ffff8880ae936308 R15: dffffc0000000000
 finish_task_switch+0x24f/0x550 kernel/sched/core.c:3297
 context_switch kernel/sched/core.c:3461 [inline]
 __schedule+0x859/0xcf0 kernel/sched/core.c:4219
 schedule+0x188/0x220 kernel/sched/core.c:4294
 freezable_schedule include/linux/freezer.h:172 [inline]
 do_nanosleep+0x1ae/0x680 kernel/time/hrtimer.c:1879
 hrtimer_nanosleep kernel/time/hrtimer.c:1932 [inline]
 __do_sys_nanosleep kernel/time/hrtimer.c:1966 [inline]
 __se_sys_nanosleep+0x3d5/0x5c0 kernel/time/hrtimer.c:1953
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45a870
Code: c0 5b 5d c3 66 0f 1f 44 00 00 8b 04 24 48 83 c4 18 5b 5d c3 66 0f 1f 44 00 00 83 3d e1 f5 84 00 00 75 14 b8 23 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 54 d1 fb ff c3 48 83 ec 08 e8 8a 46 00 00
RSP: 002b:00007ffd534d3838 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
RAX: ffffffffffffffda RBX: 0000000000145c62 RCX: 000000000045a870
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffd534d3840
RBP: 0000000000001962 R08: 0000000000000001 R09: 0000000001ead940
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000008
R13: 00007ffd534d3890 R14: 0000000000145c30 R15: 00007ffd534d38a0
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
