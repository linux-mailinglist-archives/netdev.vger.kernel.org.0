Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9899125FDEC
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgIGQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:00:11 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:55534 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730194AbgIGP7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:59:23 -0400
Received: by mail-il1-f208.google.com with SMTP id a15so10143562ilb.22
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 08:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2VrxqmmnQf9zxdHfb7HBq36u5NuuQ5dS3oJMKRvP6hE=;
        b=YoVlrYDBbj8GtcHVsZSBsimRm7cBMFfNbPwTYqEs+ZUKFH2DorS4xKyJQrFTmf0m7A
         DSGvog0zn3e44whmGmNp3KvBWEbXaMROyZgMiOQPO749QWy2TFhVWryC11lIqXmJq0K0
         L31Z1HgCndvwe0WENpQXGh6OtrfbFtlQEcrgwnLP9bbuBPUrjlU8vKPXyvmsURV0zoBh
         Lcf73XKTQm7R6gaMYIefGwROMNvoQCrkLRZKL1+hJFcd0RaIWRS0h7WJ6rKCO2ADfNU7
         I5hur7e8LXHSCOueV9QdRb/mwIbcsSbAPTmt/NhI5RsYqiiab9eGpOzRf7arJilOW1dq
         2/zg==
X-Gm-Message-State: AOAM530RjgR/FrLG/Gh1BqiHXD6pss/DHXKosX3CN3MKJRLEgmbL11Yz
        nw4bvLDyqcZpNeX1et27IWAbHNOMW33QLXP2uz5U67MmlSUy
X-Google-Smtp-Source: ABdhPJxLHu7riFo87xWzRKywml5kOyqgHTdHflX6XkBmeOyiVuhKukYjt5B3xT5npf4F/GFrNrmiEkH6GUaaDgDIQo4Vl47wKrP8
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1448:: with SMTP id l8mr20132504jad.83.1599494361859;
 Mon, 07 Sep 2020 08:59:21 -0700 (PDT)
Date:   Mon, 07 Sep 2020 08:59:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000424e3605aebb4d5c@google.com>
Subject: INFO: rcu detected stall in addrconf_dad_work (5)
From:   syzbot <syzbot+251463bfa779ca087ad1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fc3abb53 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ccc8ae900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c5f6ce8d5b68299
dashboard link: https://syzkaller.appspot.com/bug?extid=251463bfa779ca087ad1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107738ae900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1199d0e9900000

The issue was bisected to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=149de095900000
console output: https://syzkaller.appspot.com/x/log.txt?x=129de095900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+251463bfa779ca087ad1@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=786/1/0x4000000000000000 softirq=9770/9781 fqs=1 
	(detected by 0, t=10502 jiffies, g=8481, q=298)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 7070 Comm: kworker/1:3 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
RIP: 0010:__lock_acquire+0xf4f/0x5570 kernel/locking/lockdep.c:4396
Code: ff ff 48 c7 c6 e0 d1 4b 88 48 c7 c7 20 a8 4b 88 e8 18 3d eb ff 0f 0b e9 31 fe ff ff 48 63 5c 24 10 be 08 00 00 00 48 8d 43 3f <48> 85 db 48 0f 49 c3 48 c1 f8 06 48 8d 3c c5 e0 49 5f 8c e8 f9 1d
RSP: 0018:ffffc90000da8b28 EFLAGS: 00000046
RAX: 00000000000006b6 RBX: 0000000000000677 RCX: 0000000000000008
RDX: 0000000000000004 RSI: 0000000000000008 RDI: ffffffff8c63f3d8
RBP: ffff88808dfd4a90 R08: 0000000000000000 R09: ffffffff8c5f4aaf
R10: fffffbfff18be955 R11: 0000000000000001 R12: 0000000000000000
R13: ffff88808dfd4ab2 R14: ffff88808dfd4040 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c9588 CR3: 0000000009a8d000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 lock_acquire+0x1f3/0xae0 kernel/locking/lockdep.c:5006
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 advance_sched+0x4f/0x990 net/sched/sch_taprio.c:699
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x6a9/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1650
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0xb2/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:__call_rcu kernel/rcu/tree.c:2927 [inline]
RIP: 0010:call_rcu+0x3ac/0x7b0 kernel/rcu/tree.c:2968
Code: 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 b9 02 00 00 48 83 3d a8 b0 54 08 00 0f 84 1b 01 00 00 48 8b 3c 24 57 9d <0f> 1f 44 00 00 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 80 3c
RSP: 0018:ffffc900061171c8 EFLAGS: 00000282
RAX: 1ffffffff136c789 RBX: ffff888092757bd8 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000402 RDI: 0000000000000282
RBP: ffff8880ae736ca8 R08: 0000000000000001 R09: ffffffff8c5f4a8f
R10: fffffbfff18be951 R11: 000000000000016e R12: ffff8880ae736c00
R13: ffff8880ae736c98 R14: ffff8880ae736c50 R15: 0000000000000033
 dst_release net/core/dst.c:179 [inline]
 dst_release+0x79/0xe0 net/core/dst.c:169
 refdst_drop include/net/dst.h:258 [inline]
 skb_dst_drop include/net/dst.h:270 [inline]
 skb_release_head_state+0x1f9/0x250 net/core/skbuff.c:648
 skb_release_all net/core/skbuff.c:662 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 kfree_skb.part.0+0x89/0x350 net/core/skbuff.c:696
 kfree_skb+0x7d/0x100 include/linux/refcount.h:270
 ip_tunnel_xmit+0x6ab/0x2ac3 net/ipv4/ip_tunnel.c:826
 erspan_xmit+0x1109/0x2760 net/ipv4/ip_gre.c:704
 __netdev_start_xmit include/linux/netdevice.h:4634 [inline]
 netdev_start_xmit include/linux/netdevice.h:4648 [inline]
 xmit_one net/core/dev.c:3561 [inline]
 dev_hard_start_xmit+0x193/0x950 net/core/dev.c:3577
 sch_direct_xmit+0x2e1/0xbd0 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4b9/0x1620 net/sched/sch_generic.c:384
 qdisc_run include/net/pkt_sched.h:134 [inline]
 qdisc_run include/net/pkt_sched.h:126 [inline]
 __dev_xmit_skb net/core/dev.c:3752 [inline]
 __dev_queue_xmit+0x1456/0x2d60 net/core/dev.c:4105
 neigh_resolve_output net/core/neighbour.c:1489 [inline]
 neigh_resolve_output+0x3fe/0x6a0 net/core/neighbour.c:1469
 neigh_output include/net/neighbour.h:509 [inline]
 ip6_finish_output2+0x8ac/0x1780 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:290 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:443 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ndisc_send_skb+0xa69/0x1720 net/ipv6/ndisc.c:506
 ndisc_send_ns+0x3a9/0x850 net/ipv6/ndisc.c:648
 addrconf_dad_work+0xc1c/0x1280 net/ipv6/addrconf.c:4115
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 0.000 msecs
rcu: rcu_preempt kthread starved for 10500 jiffies! g8481 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:29088 pid:   10 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0xea9/0x2230 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 schedule_timeout+0x148/0x250 kernel/time/timer.c:1879
 rcu_gp_fqs_loop kernel/rcu/tree.c:1888 [inline]
 rcu_gp_kthread+0xae5/0x1b50 kernel/rcu/tree.c:2058
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
