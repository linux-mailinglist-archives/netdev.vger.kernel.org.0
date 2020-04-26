Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4179D1B9221
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 19:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDZRiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 13:38:15 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:51912 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgDZRiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 13:38:14 -0400
Received: by mail-io1-f69.google.com with SMTP id k1so17850758iov.18
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 10:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QtmphXsQ75V4Zs6d7ZRFjvUkwgefM7NFs4j9HWfvrPo=;
        b=YwHKuk6smE+WrVgCNXUH8nPxa5MQq7vsFCk7J2HQ9PJWHmKlU2n4BRfH5XeT8D+tO6
         AiuAFd/BD+SHYNcWcbz/scgd3Sw+yt7mtiyvsN6bLFFheKakFl2SJucbadSOrNrt7edL
         Sc/kBvtp/PkaIHpfwOwyPVClh3+wVJ6a2gjyF7/vT9kP2QL4eRq1376p4RiVX+iUtYIT
         ZB2UkUz/A3w2BTIHlBPyFpJ7jQ1g5MOd/rwREwb+h3nEOjiTgMxS3YMiz0pVn2pR6Rc8
         6E1hI5R1Kc4WXDJoihOv+0OeOZbSx0rpUWs05koMs++aBfP6VzuZh/UANS5DJ6nVy4nM
         CZRA==
X-Gm-Message-State: AGi0PuaBwBkrmEYZuxhwEooZeRcToTaNEkIkIyLBgQB/vqEnRoazK0A6
        /sVsq7/qGQ1p+W5lltA/s6vIk2M0DYg4uPtRcOxU21fZPTgP
X-Google-Smtp-Source: APiQypLOMVfyo5tNzBqvwG2ylPG3JRgLXp2DLVl3dA6/XKzJjUFZIIlq/YpqzR7Vyvmc6d4iCCfsCL2PibwC2hRnaTPfhkqb8Zez
MIME-Version: 1.0
X-Received: by 2002:a92:d18f:: with SMTP id z15mr18636909ilz.226.1587922692576;
 Sun, 26 Apr 2020 10:38:12 -0700 (PDT)
Date:   Sun, 26 Apr 2020 10:38:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000005d1ab05a4351006@google.com>
Subject: INFO: rcu detected stall in wg_packet_tx_worker
From:   syzbot <syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b2768df2 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16141e64100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
dashboard link: https://syzkaller.appspot.com/bug?extid=0251e883fe39e7a0cb0a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5f47fe00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e8efb4100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (10499 ticks this GP) idle=272/1/0x4000000000000002 softirq=53996/53996 fqs=254 
	(t=10500 jiffies g=80873 q=139)
rcu: rcu_preempt kthread starved for 9955 jiffies! g80873 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I28848    10      2 0x80004000
Call Trace:
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 schedule_timeout+0x35c/0x850 kernel/time/timer.c:1898
 rcu_gp_fqs_loop kernel/rcu/tree.c:1674 [inline]
 rcu_gp_kthread+0x9bf/0x1960 kernel/rcu/tree.c:1836
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 1
CPU: 1 PID: 3483 Comm: kworker/1:8 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg0 wg_packet_tx_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x19b/0x1e5 kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
 rcu_pending kernel/rcu/tree.c:3225 [inline]
 rcu_sched_clock_irq.cold+0x55d/0xcfa kernel/rcu/tree.c:2296
 update_process_times+0x25/0x60 kernel/time/timer.c:1727
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x4e/0x140 kernel/time/tick-sched.c:1320
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x5ca/0xed0 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x312/0x770 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1113 [inline]
 smp_apic_timer_interrupt+0x15b/0x600 arch/x86/kernel/apic/apic.c:1138
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:sfq_dequeue+0x19f/0xcc0 net/sched/sch_sfq.c:492
Code: 66 44 03 a5 e2 02 00 00 66 44 89 63 1a 48 8b 9d 28 03 00 00 48 8d 7b 12 48 89 f8 48 c1 e8 03 42 0f b6 14 30 48 89 f8 83 e0 07 <83> c0 01 38 d0 7c 08 84 d2 0f 85 2b 0a 00 00 44 0f b7 63 12 48 8b
RSP: 0018:ffffc9000b69f4e0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000002 RBX: ffff8880986c2370 RCX: ffffffff86466097
RDX: 0000000000000000 RSI: ffffffff86465fd2 RDI: ffff8880986c2382
RBP: ffff888097c2d000 R08: ffff88809b468240 R09: fffff520016d3e7a
R10: 0000000000000003 R11: fffff520016d3e79 R12: 0000000000000000
R13: ffff8880986c238a R14: dffffc0000000000 R15: 0000000000000002
 dequeue_skb net/sched/sch_generic.c:263 [inline]
 qdisc_restart net/sched/sch_generic.c:366 [inline]
 __qdisc_run+0x1ac/0x17b0 net/sched/sch_generic.c:384
 __dev_xmit_skb net/core/dev.c:3704 [inline]
 __dev_queue_xmit+0x1d07/0x30a0 net/core/dev.c:4021
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip6_finish_output2+0xfb5/0x25b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:435 [inline]
 ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:179
 ip6tunnel_xmit include/net/ip6_tunnel.h:160 [inline]
 udp_tunnel6_xmit_skb+0x6f4/0xcd0 net/ipv6/ip6_udp_tunnel.c:114
 send6+0x4e3/0xb20 drivers/net/wireguard/socket.c:164
 wg_socket_send_skb_to_peer+0xf5/0x220 drivers/net/wireguard/socket.c:189
 wg_packet_create_data_done drivers/net/wireguard/send.c:250 [inline]
 wg_packet_tx_worker+0x30c/0xc30 drivers/net/wireguard/send.c:278
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
