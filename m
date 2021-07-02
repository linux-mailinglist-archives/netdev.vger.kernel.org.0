Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDB93B9B87
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 06:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhGBEf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 00:35:59 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:38508 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhGBEf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 00:35:56 -0400
Received: by mail-io1-f72.google.com with SMTP id r137-20020a6b2b8f0000b02904fb34cb474cso5959645ior.5
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 21:33:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5qjOvcNCSksgilft5PRKSJyisBJ/jwvlFMGeUTPsxgU=;
        b=D+jt1U6dJwXiB863QHIYsjK6l5PSBGjJG+fMMflDscARxMrOi1euHwGFOapTRB+Z39
         6MDfD22OcZJk9f6rEYOgTJviAPQczepzpbA3KiEkEybMwFn814SdChe5gGNicZM+dYB5
         ku7VDvLHntNOJyuMPcIHOeC9NZLFIVgN6xSfoVUo4aKGOqS5QsQc8EFbaTeFE8qtHK79
         Xq/IKHt1gFrf60Y7Q2a/f0Y0LK5F0C6MWCjiPueLWFVDfMp/29UDiIUcfmLQiGd2EOMu
         vzQNzFhptZ0WBag8py9l+xVsIwdJgIjhNUFqp1ow+o24BxKWwhX0BskzqMac2hJ+WL6R
         J+TQ==
X-Gm-Message-State: AOAM531BYYZg1ejoHUDv3Hb2nsXws+Ck/SAk++ua/R5ppL9HhR263fad
        q5iKSl0NMCjMO1veCr1W1kdA2057qT0iCVxALN+YuCM+dac3
X-Google-Smtp-Source: ABdhPJynnj/2T2nX7HfMtkRmsgnhaHLy9fkrzgR4ntczme5R752COZeTjFt30GlfWfAE1Y8zShF2Uy1ecMXVgerHfFS9qRr9OQNe
MIME-Version: 1.0
X-Received: by 2002:a92:710a:: with SMTP id m10mr257346ilc.254.1625200404274;
 Thu, 01 Jul 2021 21:33:24 -0700 (PDT)
Date:   Thu, 01 Jul 2021 21:33:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9257305c61c742c@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in
 crypto_drop_spawn (2)
From:   syzbot <syzbot+610ec0671f51e838436e@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d6765985 Revert "be2net: disable bh with spin_lock in be_p..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1555a0d8300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
dashboard link: https://syzkaller.appspot.com/bug?extid=610ec0671f51e838436e

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+610ec0671f51e838436e@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1405
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1180, name: kworker/u4:6
4 locks held by kworker/u4:6/1180:
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
 #1: ffffc90004ecfda8 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
 #2: ffffffff8bf79620 (rcu_read_lock){....}-{1:2}, at: batadv_nc_process_nc_paths.part.0+0xb1/0x3b0 net/batman-adv/network-coding.c:680
 #3: ffffffff8bf79500 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2547 [inline]
 #3: ffffffff8bf79500 (rcu_callback){....}-{0:0}, at: rcu_core+0x737/0x13b0 kernel/rcu/tree.c:2793
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 1180 Comm: kworker/u4:6 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:8337
 down_write+0x6e/0x150 kernel/locking/rwsem.c:1405
 crypto_drop_spawn crypto/algapi.c:709 [inline]
 crypto_drop_spawn+0x4b/0x2b0 crypto/algapi.c:704
 crypto_drop_aead include/crypto/internal/aead.h:90 [inline]
 pcrypt_free+0x15/0x80 crypto/pcrypt.c:206
 crypto_free_instance crypto/algapi.c:68 [inline]
 crypto_destroy_instance+0x7a/0xc0 crypto/algapi.c:76
 crypto_alg_put crypto/internal.h:108 [inline]
 crypto_alg_put crypto/internal.h:105 [inline]
 crypto_mod_put+0xd3/0x100 crypto/api.c:45
 crypto_destroy_tfm crypto/api.c:573 [inline]
 crypto_destroy_tfm+0xdb/0x240 crypto/api.c:561
 crypto_free_aead include/crypto/aead.h:193 [inline]
 tipc_aead_free+0x398/0x660 net/tipc/crypto.c:422
 rcu_do_batch kernel/rcu/tree.c:2558 [inline]
 rcu_core+0x7ab/0x13b0 kernel/rcu/tree.c:2793
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:check_preemption_disabled+0x2a/0x150 lib/smp_processor_id.c:16
Code: 41 56 41 55 49 89 f5 41 54 55 48 89 fd 53 0f 1f 44 00 00 65 44 8b 25 1d 7a ea 76 65 8b 1d 6e d4 ea 76 81 e3 ff ff ff 7f 31 ff <89> de 0f 1f 44 00 00 85 db 74 11 0f 1f 44 00 00 44 89 e0 5b 5d 41
RSP: 0018:ffffc90004ecfbd8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888017ed3880 RSI: ffffffff89c2e880 RDI: 0000000000000000
RBP: ffffffff89c2e8c0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff88b6951d R11: 0000000000000000 R12: 0000000000000001
R13: ffffffff89c2e880 R14: ffff88803029cc00 R15: 000000000000001f
 rcu_dynticks_curr_cpu_in_eqs kernel/rcu/tree.c:325 [inline]
 rcu_is_watching+0xe/0xc0 kernel/rcu/tree.c:1168
 rcu_read_unlock include/linux/rcupdate.h:707 [inline]
 batadv_nc_process_nc_paths.part.0+0x304/0x3b0 net/batman-adv/network-coding.c:695
 batadv_nc_process_nc_paths net/batman-adv/network-coding.c:675 [inline]
 batadv_nc_worker+0xb90/0xe50 net/batman-adv/network-coding.c:731
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

=============================
[ BUG: Invalid wait context ]
5.13.0-rc6-syzkaller #0 Tainted: G        W        
-----------------------------
kworker/u4:6/1180 is trying to lock:
ffffffff8c74bef0 (crypto_alg_sem){++++}-{3:3}, at: crypto_drop_spawn crypto/algapi.c:709 [inline]
ffffffff8c74bef0 (crypto_alg_sem){++++}-{3:3}, at: crypto_drop_spawn+0x4b/0x2b0 crypto/algapi.c:704
other info that might help us debug this:
context-{2:2}
4 locks held by kworker/u4:6/1180:
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff88802897e138 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2247
 #1: ffffc90004ecfda8 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2251
 #2: ffffffff8bf79620 (rcu_read_lock){....}-{1:2}, at: batadv_nc_process_nc_paths.part.0+0xb1/0x3b0 net/batman-adv/network-coding.c:680
 #3: ffffffff8bf79500 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2547 [inline]
 #3: ffffffff8bf79500 (rcu_callback){....}-{0:0}, at: rcu_core+0x737/0x13b0 kernel/rcu/tree.c:2793
stack backtrace:
CPU: 1 PID: 1180 Comm: kworker/u4:6 Tainted: G        W         5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4553 [inline]
 check_wait_context kernel/locking/lockdep.c:4614 [inline]
 __lock_acquire.cold+0xc8/0x3b4 kernel/locking/lockdep.c:4852
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
 down_write+0x92/0x150 kernel/locking/rwsem.c:1406
 crypto_drop_spawn crypto/algapi.c:709 [inline]
 crypto_drop_spawn+0x4b/0x2b0 crypto/algapi.c:704
 crypto_drop_aead include/crypto/internal/aead.h:90 [inline]
 pcrypt_free+0x15/0x80 crypto/pcrypt.c:206
 crypto_free_instance crypto/algapi.c:68 [inline]
 crypto_destroy_instance+0x7a/0xc0 crypto/algapi.c:76
 crypto_alg_put crypto/internal.h:108 [inline]
 crypto_alg_put crypto/internal.h:105 [inline]
 crypto_mod_put+0xd3/0x100 crypto/api.c:45
 crypto_destroy_tfm crypto/api.c:573 [inline]
 crypto_destroy_tfm+0xdb/0x240 crypto/api.c:561
 crypto_free_aead include/crypto/aead.h:193 [inline]
 tipc_aead_free+0x398/0x660 net/tipc/crypto.c:422
 rcu_do_batch kernel/rcu/tree.c:2558 [inline]
 rcu_core+0x7ab/0x13b0 kernel/rcu/tree.c:2793
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:check_preemption_disabled+0x2a/0x150 lib/smp_processor_id.c:16
Code: 41 56 41 55 49 89 f5 41 54 55 48 89 fd 53 0f 1f 44 00 00 65 44 8b 25 1d 7a ea 76 65 8b 1d 6e d4 ea 76 81 e3 ff ff ff 7f 31 ff <89> de 0f 1f 44 00 00 85 db 74 11 0f 1f 44 00 00 44 89 e0 5b 5d 41
RSP: 0018:ffffc90004ecfbd8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888017ed3880 RSI: ffffffff89c2e880 RDI: 0000000000000000
RBP: ffffffff89c2e8c0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff88b6951d R11: 0000000000000000 R12: 0000000000000001
R13: ffffffff89c2e880 R14: ffff88803029cc00 R15: 000000000000001f
 rcu_dynticks_curr_cpu_in_eqs kernel/rcu/tree.c:325 [inline]
 rcu_is_watching+0xe/0xc0 kernel/rcu/tree.c:1168
 rcu_read_unlock include/linux/rcupdate.h:707 [inline]
 batadv_nc_process_nc_paths.part.0+0x304/0x3b0 net/batman-adv/network-coding.c:695
 batadv_nc_process_nc_paths net/batman-adv/network-coding.c:675 [inline]
 batadv_nc_worker+0xb90/0xe50 net/batman-adv/network-coding.c:731
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
