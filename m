Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A961B27EEE7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbgI3QUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:23 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:43504 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731113AbgI3QUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:18 -0400
Received: by mail-io1-f80.google.com with SMTP id x13so1505042iom.10
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jr01O5i4+4Id9gfjg+AO8oY8jm46IXh7ujYh+69aY30=;
        b=VQE+XquvLEWGrvAfLjjj0GpuZ22s3LF8CJ4Y2chOuze0OarK09R9ZWwwC8a+8jTdTc
         M0ncNjkb+npJwaJN47ZxJM9nro22AljQrY5tjuNS2hI3hFX0gUs/cwbRaSZLPtyTYEst
         AeJL26eJR7Nm93Y2DZXDfN+g1/Wxuqy9bl6Xh0V+ZtsLPiVzw+R80K6RBki9ZrNw6+PW
         ja2W5GoWxuNwGxOEQTV4DQVd5HesKhodOwp07m0bj6EYBwk/y4Sn6emUMjn0NjW5CeWg
         jGGM8X5nliEJdmANhoBjtaY2qQhY5xwVcxFQFVkWFIlq8mauFTG2T/JfBhB0zhG1LQHz
         2UhQ==
X-Gm-Message-State: AOAM530qAQpxjk17IJGQ1D6QN4maVYJKAPvzjdqi+N1kkvqgajIQjaWO
        wiVQOr9DMe6G8yt+XFLSBBfi5QvKjMGVOrdPA+VVhnTISQ/0
X-Google-Smtp-Source: ABdhPJwrVmrMIvJV9ik1fS3aGveNLuVCAYd4LpZgO3G5paPtGsRWqpZl9DJhcet4K2GwvMFhuji0paVM0bJvSlwWs5K07L91/eOS
MIME-Version: 1.0
X-Received: by 2002:a92:c301:: with SMTP id n1mr2508592ilg.247.1601482815580;
 Wed, 30 Sep 2020 09:20:15 -0700 (PDT)
Date:   Wed, 30 Sep 2020 09:20:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056307e05b08a4693@google.com>
Subject: BUG: soft lockup in mac80211_hwsim_beacon
From:   syzbot <syzbot+d6219cf21f26bdfcc22e@syzkaller.appspotmail.com>
To:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    00e8c44a bpf, selftests: Fix cast to smaller integer type ..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17b48a87900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d44e1360b76d34dc
dashboard link: https://syzkaller.appspot.com/bug?extid=d6219cf21f26bdfcc22e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6219cf21f26bdfcc22e@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 123s! [syz-executor.5:32715]
Modules linked in:
irq event stamp: 10093197
hardirqs last  enabled at (10093196): [<ffffffff88400c42>] asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
hardirqs last disabled at (10093197): [<ffffffff883509fd>] irqentry_enter+0x1d/0x50 kernel/entry/common.c:344
softirqs last  enabled at (9864878): [<ffffffff88400f2f>] asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
softirqs last disabled at (9864881): [<ffffffff88400f2f>] asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
CPU: 0 PID: 32715 Comm: syz-executor.5 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:434 [inline]
RIP: 0010:__pv_queued_spin_lock_slowpath+0x3ba/0xb40 kernel/locking/qspinlock.c:508
Code: eb c6 45 01 01 41 bc 00 80 00 00 48 c1 e9 03 83 e3 07 41 be 01 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8d 2c 01 eb 0c f3 90 <41> 83 ec 01 0f 84 72 04 00 00 41 0f b6 45 00 38 d8 7f 08 84 c0 0f
RSP: 0018:ffffc900000079f8 EFLAGS: 00000202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff1bfa6d0
RDX: 0000000000000001 RSI: dffffc0000000000 RDI: ffffffff8dfd3682
RBP: ffffffff8dfd3680 R08: 0000000000000001 R09: ffffffff8dfd3683
R10: fffffbfff1bfa6d0 R11: 0000000000000000 R12: 0000000000006777
R13: fffffbfff1bfa6d0 R14: 0000000000000001 R15: ffff8880ae436bc0
FS:  00007f0b289a7700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557277813520 CR3: 000000020ea48000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 <IRQ>
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:656 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 mac80211_hwsim_tx_frame_no_nl.isra.0+0x640/0x12d0 drivers/net/wireless/mac80211_hwsim.c:1397
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
RIP: 0010:preempt_count_sub+0x0/0x150 kernel/sched/core.c:4211
Code: 45 d0 e8 c3 80 86 02 48 8b 55 c0 4c 8b 45 c8 48 8b 45 d0 e9 9a fb ff ff 89 4d d0 e8 4a 28 67 00 8b 4d d0 e9 2a fe ff ff 66 90 <48> c7 c0 60 71 48 8d 53 89 fb 48 ba 00 00 00 00 00 fc ff df 48 89
RSP: 0018:ffffc9001724ef70 EFLAGS: 00000282
RAX: 1ffffffff13f8d7f RBX: ffff88820abea180 RCX: ffffffff815b9de2
RDX: dffffc0000000000 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff8880ae435e40 R08: 0000000000000001 R09: ffffffff8d1099ff
R10: fffffbfff1a2133f R11: 0000000000000000 R12: ffff8880ae435e40
R13: ffff88803330c340 R14: 0000000000000000 R15: 0000000000000001
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
 _raw_spin_unlock_irq+0x55/0x80 kernel/locking/spinlock.c:199
 finish_lock_switch kernel/sched/core.c:3517 [inline]
 finish_task_switch+0x150/0x790 kernel/sched/core.c:3617
 context_switch kernel/sched/core.c:3781 [inline]
 __schedule+0xed1/0x2280 kernel/sched/core.c:4527
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:4683
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:40
 __raw_spin_unlock include/linux/spinlock_api_smp.h:152 [inline]
 _raw_spin_unlock+0x36/0x40 kernel/locking/spinlock.c:183
 spin_unlock include/linux/spinlock.h:394 [inline]
 follow_page_pte+0xda5/0x1430 mm/gup.c:534
 follow_pmd_mask mm/gup.c:650 [inline]
 follow_pud_mask mm/gup.c:695 [inline]
 follow_p4d_mask mm/gup.c:721 [inline]
 follow_page_mask+0xdd3/0x1df0 mm/gup.c:780
 __get_user_pages+0x5aa/0x1510 mm/gup.c:1088
 __get_user_pages_locked mm/gup.c:1273 [inline]
 get_user_pages_unlocked+0x17e/0x630 mm/gup.c:1993
 __gup_longterm_unlocked mm/gup.c:2643 [inline]
 internal_get_user_pages_fast+0x1ad4/0x2990 mm/gup.c:2701
 get_user_pages_fast+0x49/0x70 mm/gup.c:2797
 iov_iter_get_pages+0x2a2/0xf50 lib/iov_iter.c:1324
 __bio_iov_iter_get_pages block/bio.c:1014 [inline]
 bio_iov_iter_get_pages+0x213/0x10a0 block/bio.c:1119
 iomap_dio_bio_actor+0x782/0xf00 fs/iomap/direct-io.c:281
 iomap_dio_actor+0x95/0x530 fs/iomap/direct-io.c:388
 iomap_apply+0x2b6/0xcc0 fs/iomap/apply.c:84
 iomap_dio_rw+0x6c7/0x1230 fs/iomap/direct-io.c:506
 ext4_dio_write_iter fs/ext4/file.c:548 [inline]
 ext4_file_write_iter+0xe28/0x13f0 fs/ext4/file.c:658
 call_write_iter include/linux/fs.h:1882 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:503
 vfs_write+0x5ad/0x730 fs/read_write.c:578
 ksys_write+0x12d/0x250 fs/read_write.c:631
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45dd99
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0b289a6c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000039840 RCX: 000000000045dd99
RDX: 0000000000806000 RSI: 0000000020000200 RDI: 0000000000000006
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff31fb2a3f R14: 00007f0b289a79c0 R15: 000000000118bf2c
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 32717 Comm: syz-executor.4 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:lock_release+0x48a/0x8f0 kernel/locking/lockdep.c:5052
Code: 24 04 09 00 00 0f 85 db 01 00 00 48 c7 c0 e8 6b fc 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 b0 03 00 00 <48> 83 3d a6 48 a0 08 00 0f 84 ac 01 00 00 48 8b 3c 24 57 9d 0f 1f
RSP: 0018:ffffc90000da7ef8 EFLAGS: 00000046
RAX: 1ffffffff13f8d7d RBX: 0000000000000008 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: ffffffff8a068440 RDI: ffff88801be2cc44
RBP: 1ffff920001b4fe1 R08: 0000000000000001 R09: ffff88801be2cc40
R10: fffffbfff16b8fd1 R11: 0000000000000000 R12: ffff88801be2c340
R13: 0000000000000007 R14: ffffffff8195c2a7 R15: ffff88801be2c340
FS:  00007f448e967700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005572778ff277 CR3: 000000020e2cc000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 rcu_lock_release include/linux/rcupdate.h:246 [inline]
 rcu_read_unlock include/linux/rcupdate.h:688 [inline]
 __perf_output_begin kernel/events/ring_buffer.c:260 [inline]
 perf_output_begin_forward+0x7f9/0xba0 kernel/events/ring_buffer.c:268
 __perf_event_output kernel/events/core.c:7172 [inline]
 perf_event_output_forward+0x108/0x270 kernel/events/core.c:7190
 __perf_event_overflow+0x13c/0x370 kernel/events/core.c:8845
 perf_swevent_hrtimer+0x37c/0x3f0 kernel/events/core.c:10247
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1650
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x147/0x5f0 arch/x86/kernel/apic/apic.c:1097
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 sysvec_apic_timer_interrupt+0x4c/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:pv_wait_node kernel/locking/qspinlock_paravirt.h:301 [inline]
RIP: 0010:__pv_queued_spin_lock_slowpath+0x5c4/0xb40 kernel/locking/qspinlock.c:473
Code: 32 84 c0 75 23 41 0f b6 14 24 4c 89 e9 83 e1 07 38 ca 7f 08 84 d2 0f 85 ed 03 00 00 0f b6 53 14 84 d2 0f 85 9e 00 00 00 f3 90 <83> e8 01 0f 84 93 00 00 00 0f b6 16 84 d2 74 09 80 fa 03 0f 8e 96
RSP: 0018:ffffc90000da89f8 EFLAGS: 00000286
RAX: 0000000000004dcf RBX: ffff8880ae436bc0 RCX: 0000000000000004
RDX: 0000000000000000 RSI: ffffed1015ca6d79 RDI: ffff8880ae536bd4
RBP: ffff8880ae536bd4 R08: 0000000000000001 R09: ffff8880ae536bd4
R10: ffffed1015ca6d7a R11: 0000000000000000 R12: ffffed1015c86d7a
R13: ffff8880ae436bd4 R14: dffffc0000000000 R15: ffff8880ae536bc0
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:656 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 mac80211_hwsim_tx_frame_no_nl.isra.0+0x640/0x12d0 drivers/net/wireless/mac80211_hwsim.c:1397
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
RIP: 0010:scsi_queue_rq+0x4/0x3410 drivers/scsi/scsi_lib.c:1620
Code: 7c 24 08 e8 fe 63 07 fd e9 9a fe ff ff 4c 89 ff e8 11 64 07 fd e9 55 fe ff ff 66 90 66 2e 0f 1f 84 00 00 00 00 00 41 57 41 56 <41> 55 41 54 55 53 48 89 f3 48 83 ec 60 48 89 74 24 08 e8 35 ae c5
RSP: 0018:ffffc900171fee70 EFLAGS: 00000246
RAX: 1ffffffff11fb31c RBX: ffff88809e188050 RCX: ffffc900111a5000
RDX: 0000000000040000 RSI: ffffc900171fef68 RDI: ffff8880a006a800
RBP: ffff88809e188048 R08: 0000000000000001 R09: ffff8880a00b0247
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffc900171ff040 R14: 0000000000000000 R15: ffffffff88fd98e0
 blk_mq_dispatch_rq_list+0x3a5/0x1cb0 block/blk-mq.c:1387
 __blk_mq_do_dispatch_sched+0x3bc/0x890 block/blk-mq-sched.c:201
 blk_mq_do_dispatch_sched block/blk-mq-sched.c:214 [inline]
 __blk_mq_sched_dispatch_requests+0x361/0x490 block/blk-mq-sched.c:330
 blk_mq_sched_dispatch_requests+0xfb/0x180 block/blk-mq-sched.c:356
 __blk_mq_run_hw_queue+0x13a/0x2d0 block/blk-mq.c:1534
 __blk_mq_delay_run_hw_queue+0x522/0x5f0 block/blk-mq.c:1611
 blk_mq_run_hw_queue+0x16c/0x2f0 block/blk-mq.c:1664
 blk_mq_sched_insert_requests+0x286/0x620 block/blk-mq-sched.c:610
 blk_mq_flush_plug_list+0x3d8/0x560 block/blk-mq.c:1934
 blk_flush_plug_list+0x4d/0x5f block/blk-core.c:1868
 blk_mq_submit_bio+0xae0/0x1760 block/blk-mq.c:2219
 __submit_bio_noacct_mq block/blk-core.c:1180 [inline]
 submit_bio_noacct+0xc78/0x12b0 block/blk-core.c:1213
 submit_bio+0x263/0x5b0 block/blk-core.c:1283
 iomap_dio_submit_bio+0x293/0x360 fs/iomap/direct-io.c:76
 iomap_dio_bio_actor+0x4b3/0xf00 fs/iomap/direct-io.c:311
 iomap_dio_actor+0x95/0x530 fs/iomap/direct-io.c:388
 iomap_apply+0x2b6/0xcc0 fs/iomap/apply.c:84
 iomap_dio_rw+0x6c7/0x1230 fs/iomap/direct-io.c:506
 ext4_dio_write_iter fs/ext4/file.c:548 [inline]
 ext4_file_write_iter+0xe28/0x13f0 fs/ext4/file.c:658
 call_write_iter include/linux/fs.h:1882 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:503
 vfs_write+0x5ad/0x730 fs/read_write.c:578
 ksys_write+0x12d/0x250 fs/read_write.c:631
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45dd99
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f448e966c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000039840 RCX: 000000000045dd99
RDX: 0000000000806000 RSI: 0000000020000200 RDI: 0000000000000006
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffde9e83f3f R14: 00007f448e9679c0 R15: 000000000118bf2c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
