Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEF625C6BE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgICQ1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:27:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44373 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgICQ1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:27:17 -0400
Received: by mail-io1-f71.google.com with SMTP id l8so2415739ioa.11
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 09:27:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7+kZkaNHmWvCmuuZ3NabuSFbF1u08SxnzXIlIZXCGUw=;
        b=AU6vEEoDwpvYZQjwOVOGbOu7kpxgN2axLhR1BGpYlggWlPKiUYTRcG9UdTVKolg+t8
         VkWVEX2H8xQKCSRw86HOdOg3lNazwvU3dug5dbz+OxKy4st4VatAGQpelsMx85vRcG3v
         IoLLNoy/wBse7Z1qPqeioqUWovnzPQM1OVbUQoFlHwjZ3iXnkDJ/wKVQUgvsxNj5ccX0
         9/s0WTpEQS4kEz5y8Okl5F/kgL03NMqnayHmnKQMnDceCZRrtOXlQ2B9+LV7D+b1MTkz
         660/JR8GeTqw4HX6zhDfHMEBjPFrj48Tvq7YCib3e48t2QC6V9/WMw3xoJpZIgywCzpD
         J+Rg==
X-Gm-Message-State: AOAM5302ZZr/SLVI418b1PaRjfwQ3F+tXfh2LGsIZS8gC/BT1+vsHa38
        B8K1sPWOxZGzwgoOxm6SeEIKQN1qAWOeRiJx1hg4XIApDpSC
X-Google-Smtp-Source: ABdhPJyCDltrgs7lTIDoiu2z6Xe0VOtJ+jsd5vjPyFxbqnpBUMREZ1K16SBziBVxBX8OgIQG4oo+WCArcaXfiR+vo8b4y8+ZjCZ1
MIME-Version: 1.0
X-Received: by 2002:a92:b106:: with SMTP id t6mr3631537ilh.122.1599150435980;
 Thu, 03 Sep 2020 09:27:15 -0700 (PDT)
Date:   Thu, 03 Sep 2020 09:27:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000addbdd05ae6b39e8@google.com>
Subject: INFO: rcu detected stall in ip_list_rcv
From:   syzbot <syzbot+14189f93c40e0e6b19cd@syzkaller.appspotmail.com>
To:     fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1eb832ac tools/bpf: build: Make sure resolve_btfids cleans..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=15affa1e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=14189f93c40e0e6b19cd
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171580cd900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1148b225900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+14189f93c40e0e6b19cd@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (10499 ticks this GP) idle=1c2/1/0x4000000000000000 softirq=7897/7897 fqs=327 
	(t=10500 jiffies g=9165 q=13067)
NMI backtrace for cpu 0
CPU: 0 PID: 12920 Comm: syz-executor411 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x194/0x1cf kernel/rcu/tree_stall.h:318
 print_cpu_stall kernel/rcu/tree_stall.h:551 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:625 [inline]
 rcu_pending kernel/rcu/tree.c:3637 [inline]
 rcu_sched_clock_irq.cold+0x5b3/0xccd kernel/rcu/tree.c:2519
 update_process_times+0x25/0xa0 kernel/time/timer.c:1710
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x1d1/0x2a0 kernel/time/tick-sched.c:1328
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1650
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 sysvec_apic_timer_interrupt+0x4c/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:should_resched arch/x86/include/asm/preempt.h:102 [inline]
RIP: 0010:__local_bh_enable_ip+0x101/0x190 kernel/softirq.c:202
Code: 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 8b 00 00 00 48 83 3d b0 5c 6f 08 00 74 2f fb 66 0f 1f 44 00 00 <65> 8b 05 48 1f bb 7e 85 c0 74 46 5b 5d c3 0f 0b e9 4a ff ff ff 48
RSP: 0018:ffffc900000072e0 EFLAGS: 00000286
RAX: 1ffffffff136c77b RBX: 0000000000000200 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffffffff8146df01
RBP: ffffffff86d54a56 R08: 0000000000000001 R09: ffffffff8c5f3a9f
R10: fffffbfff18be753 R11: 0000000000000001 R12: ffff88809a20e150
R13: ffff88809a20e0d8 R14: ffff88809a20e148 R15: dffffc0000000000
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 ipt_do_table+0xcfb/0x1870 net/ipv4/netfilter/ip_tables.c:358
 iptable_mangle_hook+0xad/0x520 net/ipv4/netfilter/iptable_mangle.c:82
 nf_hook_entry_hookfn include/linux/netfilter.h:136 [inline]
 nf_hook_slow+0xc5/0x1e0 net/netfilter/core.c:512
 nf_hook.constprop.0+0x35b/0x5d0 include/linux/netfilter.h:256
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x17b/0x200 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:449 [inline]
 ip_sublist_rcv_finish+0x9a/0x2c0 net/ipv4/ip_input.c:550
 ip_list_rcv_finish.constprop.0+0x514/0x6e0 net/ipv4/ip_input.c:600
 ip_sublist_rcv net/ipv4/ip_input.c:608 [inline]
 ip_list_rcv+0x34e/0x488 net/ipv4/ip_input.c:643
 __netif_receive_skb_list_ptype net/core/dev.c:5329 [inline]
 __netif_receive_skb_list_core+0x549/0x8e0 net/core/dev.c:5377
 __netif_receive_skb_list net/core/dev.c:5429 [inline]
 netif_receive_skb_list_internal+0x777/0xd70 net/core/dev.c:5534
 gro_normal_list net/core/dev.c:5645 [inline]
 gro_normal_list net/core/dev.c:5641 [inline]
 gro_normal_one+0x16f/0x260 net/core/dev.c:5657
 napi_skb_finish net/core/dev.c:5985 [inline]
 napi_gro_receive+0x5ca/0x750 net/core/dev.c:6017
 receive_buf+0x1006/0x5980 drivers/net/virtio_net.c:1082
 virtnet_receive drivers/net/virtio_net.c:1346 [inline]
 virtnet_poll+0x568/0xd76 drivers/net/virtio_net.c:1451
 napi_poll net/core/dev.c:6688 [inline]
 net_rx_action+0x4a1/0xe80 net/core/dev.c:6758
 __do_softirq+0x2de/0xa24 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x1f3/0x230 kernel/softirq.c:435
 common_interrupt+0xa3/0x1f0 arch/x86/kernel/irq.c:239
 asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:572
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x4b/0x80 kernel/locking/spinlock.c:199
Code: c0 d8 3b b6 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 31 48 83 3d 46 f6 bf 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 db 6d 59 f9 65 8b 05 d4 b8 0b 78 85 c0 74 02 5d
RSP: 0018:ffffc90007e27978 EFLAGS: 00000286
RAX: 1ffffffff136c77b RBX: ffff8880a7a42280 RCX: 0000000000000006
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffffffff87f6456f
RBP: ffff8880ae635e00 R08: 0000000000000001 R09: ffffffff8c5f3a9f
R10: fffffbfff18be753 R11: 0000000000000001 R12: ffff8880ae635e00
R13: ffff8880a9630240 R14: ffff8880a8ead6c0 R15: 0000000000000001
 finish_lock_switch kernel/sched/core.c:3517 [inline]
 finish_task_switch+0x147/0x750 kernel/sched/core.c:3617
 context_switch kernel/sched/core.c:3781 [inline]
 __schedule+0x8ed/0x21e0 kernel/sched/core.c:4527
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:4683
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:40
 smp_call_function_single+0x467/0x4f0 kernel/smp.c:384
 task_function_call+0xd7/0x160 kernel/events/core.c:116
 perf_install_in_context+0x2cb/0x550 kernel/events/core.c:2895
 __do_sys_perf_event_open+0x1c31/0x2cb0 kernel/events/core.c:11992
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4431b9
Code: e8 7c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe02567f68 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 00000000000bfdd6 RCX: 00000000004431b9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000100
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000403e10
R10: 00000000ffffffff R11: 0000000000000246 R12: 000000000000047e
R13: 0000000000403e10 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
