Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1284B7B6D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 00:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244674AbiBOXxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 18:53:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240712AbiBOXxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 18:53:21 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A61BCB93D
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:53:10 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so4886403pjl.2
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qizWz62DgwXn3ec7hnYiSQtwd9Pj/pqGX49uX5J6L7Q=;
        b=NYMw4+Epk8wHmBOs+Mwk+Ol8qdiIHt2an7mn75M5w+qz9cNYZHJjbwIVpDVtlVtfqb
         z1wME6Ww5Dd/4iTSqHPRVvvwLjN6lxdgdJggGNfdDGPQAGMERz/CMo60IMCQSq2E/iRj
         Mn4PwkozmwaAEsOOqaDS8y5OX6jAEnXJS9sPlXRSwmL3pyohpO32CppDJz2gUxDOZSe4
         1QyUBSl9mvElh1qrtrBkK0iYywY6IWJrCQcY1UONoFBV3FNkpDn29NjzEluuU3Z9tgkR
         M7WBc4SsdfBYMT7YfboN78PePLcL/8eTHjOGZ6aiHOuAMOtDzsNe0SGM2HurVRJHGW4S
         qPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qizWz62DgwXn3ec7hnYiSQtwd9Pj/pqGX49uX5J6L7Q=;
        b=PJQ6UFi/votG2TxXCfSCbyXn390xdHvfXePMqMB6s8FmSdbU4myzjLY+lcewXUjB38
         eOZtcJSh/S/+yeDDnVr99H4Tna6o3myWMOVMABIHnl8LcSg1ew6O01JRzTW4HA4Lk8/0
         fOQjE0FlnBXFdhVVnQOfg7L2U5vug8sBJQi8Jg6ljD/9FIHM36uWFVvXw7p2ek1CEZ10
         LIjK5+jHxqLoYLqEMDEEL2bFZ2bhhmuinuLpEMQBlEf6kXXXdgGNWq9+uwhR8/G+3EkR
         DxaWXIkrwBQ9C7vDZeEi+cSUKdpD5GUnuOzlG467A4tDA/xS269qPeJf55qnnzx1oxR2
         ZbZQ==
X-Gm-Message-State: AOAM530CZk8kEQOWlu1AZu6NYw0NdBLtUVzzHwZZleJAuU/mdSuEm7In
        kD7Wde9dWqnZ342Q8ld8UaU=
X-Google-Smtp-Source: ABdhPJzOONoYDJaZZIqHC+hhw/eKtF2aOcebfQV62tzxS83yxYP5z5nGxaXjV+X0gZNzrU2OhzLLuw==
X-Received: by 2002:a17:902:d50b:b0:14d:ca2b:1b59 with SMTP id b11-20020a170902d50b00b0014dca2b1b59mr315998plg.22.1644969189462;
        Tue, 15 Feb 2022 15:53:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b2d6:3f21:5f47:8e5a])
        by smtp.gmail.com with ESMTPSA id nv11sm1190935pjb.49.2022.02.15.15.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 15:53:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH v2 net] net: sched: limit TC_ACT_REPEAT loops
Date:   Tue, 15 Feb 2022 15:53:05 -0800
Message-Id: <20220215235305.3272331-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We have been living dangerously, at the mercy of malicious users,
abusing TC_ACT_REPEAT, as shown by this syzpot report [1].

Add an arbitrary limit (32) to the number of times an action can
return TC_ACT_REPEAT.

v2: switch the limit to 32 instead of 10.
    Use net_warn_ratelimited() instead of pr_err_once().

[1] (C repro available on demand)

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu:    1-...!: (10500 ticks this GP) idle=021/1/0x4000000000000000 softirq=5592/5592 fqs=0
        (t=10502 jiffies g=5305 q=190)
rcu: rcu_preempt kthread timer wakeup didn't happen for 10502 jiffies! g5305 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
rcu:    Possible timer handling issue on cpu=0 timer-softirq=3527
rcu: rcu_preempt kthread starved for 10505 jiffies! g5305 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:29344 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4986 [inline]
 __schedule+0xab2/0x4db0 kernel/sched/core.c:6295
 schedule+0xd2/0x260 kernel/sched/core.c:6368
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1881
 rcu_gp_fqs_loop+0x186/0x810 kernel/rcu/tree.c:1963
 rcu_gp_kthread+0x1de/0x320 kernel/rcu/tree.c:2136
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3646 Comm: syz-executor358 Not tainted 5.17.0-rc3-syzkaller-00149-gbf8e59fd315f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rep_nop arch/x86/include/asm/vdso/processor.h:13 [inline]
RIP: 0010:cpu_relax arch/x86/include/asm/vdso/processor.h:18 [inline]
RIP: 0010:pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:437 [inline]
RIP: 0010:__pv_queued_spin_lock_slowpath+0x3b8/0xb40 kernel/locking/qspinlock.c:508
Code: 48 89 eb c6 45 01 01 41 bc 00 80 00 00 48 c1 e9 03 83 e3 07 41 be 01 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8d 2c 01 eb 0c <f3> 90 41 83 ec 01 0f 84 72 04 00 00 41 0f b6 45 00 38 d8 7f 08 84
RSP: 0018:ffffc9000283f1b0 EFLAGS: 00000206
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 1ffff1100fc0071e
RDX: 0000000000000001 RSI: 0000000000000201 RDI: 0000000000000000
RBP: ffff88807e0038f0 R08: 0000000000000001 R09: ffffffff8ffbf9ff
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000004c1e
R13: ffffed100fc0071e R14: 0000000000000001 R15: ffff8880b9c3aa80
FS:  00005555562bf300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdbfef12b8 CR3: 00000000723c2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:591 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:115
 spin_lock_bh include/linux/spinlock.h:354 [inline]
 sch_tree_lock include/net/sch_generic.h:610 [inline]
 sch_tree_lock include/net/sch_generic.h:605 [inline]
 prio_tune+0x3b9/0xb50 net/sched/sch_prio.c:211
 prio_init+0x5c/0x80 net/sched/sch_prio.c:244
 qdisc_create.constprop.0+0x44a/0x10f0 net/sched/sch_api.c:1253
 tc_modify_qdisc+0x4c5/0x1980 net/sched/sch_api.c:1660
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5594
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7ee98aae99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdbfef12d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffdbfef1300 RCX: 00007f7ee98aae99
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 000000000000000d R11: 0000000000000246 R12: 00007ffdbfef12f0
R13: 00000000000f4240 R14: 000000000004ca47 R15: 00007ffdbfef12e4
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 2.293 msecs
NMI backtrace for cpu 1
CPU: 1 PID: 3260 Comm: kworker/1:3 Not tainted 5.17.0-rc3-syzkaller-00149-gbf8e59fd315f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:604 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:688 [inline]
 rcu_pending kernel/rcu/tree.c:3919 [inline]
 rcu_sched_clock_irq.cold+0x5c/0x759 kernel/rcu/tree.c:2617
 update_process_times+0x16d/0x200 kernel/time/timer.c:1785
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1428
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1c0/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0xc/0x70 kernel/kcov.c:286
Code: 00 00 00 48 89 7c 30 e8 48 89 4c 30 f0 4c 89 54 d8 20 48 89 10 5b c3 0f 1f 80 00 00 00 00 41 89 f8 bf 03 00 00 00 4c 8b 14 24 <89> f1 65 48 8b 34 25 00 70 02 00 e8 14 f9 ff ff 84 c0 74 4b 48 8b
RSP: 0018:ffffc90002c5eea8 EFLAGS: 00000246
RAX: 0000000000000007 RBX: ffff88801c625800 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff8880137d3100 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff874fcd88 R11: 0000000000000000 R12: ffff88801d692dc0
R13: ffff8880137d3104 R14: 0000000000000000 R15: ffff88801d692de8
 tcf_police_act+0x358/0x11d0 net/sched/act_police.c:256
 tcf_action_exec net/sched/act_api.c:1049 [inline]
 tcf_action_exec+0x1a6/0x530 net/sched/act_api.c:1026
 tcf_exts_exec include/net/pkt_cls.h:326 [inline]
 route4_classify+0xef0/0x1400 net/sched/cls_route.c:179
 __tcf_classify net/sched/cls_api.c:1549 [inline]
 tcf_classify+0x3e8/0x9d0 net/sched/cls_api.c:1615
 prio_classify net/sched/sch_prio.c:42 [inline]
 prio_enqueue+0x3a7/0x790 net/sched/sch_prio.c:75
 dev_qdisc_enqueue+0x40/0x300 net/core/dev.c:3668
 __dev_xmit_skb net/core/dev.c:3756 [inline]
 __dev_queue_xmit+0x1f61/0x3660 net/core/dev.c:4081
 neigh_hh_output include/net/neighbour.h:533 [inline]
 neigh_output include/net/neighbour.h:547 [inline]
 ip_finish_output2+0x14dc/0x2170 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:306 [inline]
 __ip_finish_output+0x396/0x650 net/ipv4/ip_output.c:288
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x196/0x310 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x628/0xa50 net/ipv4/ip_tunnel_core.c:82
 geneve_xmit_skb drivers/net/geneve.c:966 [inline]
 geneve_xmit+0x10c8/0x3530 drivers/net/geneve.c:1077
 __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
 netdev_start_xmit include/linux/netdevice.h:4697 [inline]
 xmit_one net/core/dev.c:3473 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3489
 __dev_queue_xmit+0x2985/0x3660 net/core/dev.c:4116
 neigh_hh_output include/net/neighbour.h:533 [inline]
 neigh_output include/net/neighbour.h:547 [inline]
 ip6_finish_output2+0xf7a/0x14f0 net/ipv6/ip6_output.c:126
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 __ip6_finish_output+0x61e/0xe90 net/ipv6/ip6_output.c:170
 ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:451 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 mld_sendpack+0x9a3/0xe40 net/ipv6/mcast.c:1826
 mld_send_cr net/ipv6/mcast.c:2127 [inline]
 mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2659
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess):
   0:   48 89 eb                mov    %rbp,%rbx
   3:   c6 45 01 01             movb   $0x1,0x1(%rbp)
   7:   41 bc 00 80 00 00       mov    $0x8000,%r12d
   d:   48 c1 e9 03             shr    $0x3,%rcx
  11:   83 e3 07                and    $0x7,%ebx
  14:   41 be 01 00 00 00       mov    $0x1,%r14d
  1a:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
  21:   fc ff df
  24:   4c 8d 2c 01             lea    (%rcx,%rax,1),%r13
  28:   eb 0c                   jmp    0x36
* 2a:   f3 90                   pause <-- trapping instruction
  2c:   41 83 ec 01             sub    $0x1,%r12d
  30:   0f 84 72 04 00 00       je     0x4a8
  36:   41 0f b6 45 00          movzbl 0x0(%r13),%eax
  3b:   38 d8                   cmp    %bl,%al
  3d:   7f 08                   jg     0x47
  3f:   84                      .byte 0x84

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/act_api.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 32563cef85bfa29679f3790599b9d34ebd504b5c..2811348f3acc0b853f54f001b6e80ce3adbe6ad4 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1037,6 +1037,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 restart_act_graph:
 	for (i = 0; i < nr_actions; i++) {
 		const struct tc_action *a = actions[i];
+		int repeat_ttl;
 
 		if (jmp_prgcnt > 0) {
 			jmp_prgcnt -= 1;
@@ -1045,11 +1046,17 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 
 		if (tc_act_skip_sw(a->tcfa_flags))
 			continue;
+
+		repeat_ttl = 32;
 repeat:
 		ret = a->ops->act(skb, a, res);
-		if (ret == TC_ACT_REPEAT)
-			goto repeat;	/* we need a ttl - JHS */
-
+		if (unlikely(ret == TC_ACT_REPEAT)) {
+			if (--repeat_ttl != 0)
+				goto repeat;
+			/* suspicious opcode, stop pipeline */
+			net_warn_ratelimited("TC_ACT_REPEAT abuse ?\n");
+			return TC_ACT_OK;
+		}
 		if (TC_ACT_EXT_CMP(ret, TC_ACT_JUMP)) {
 			jmp_prgcnt = ret & TCA_ACT_MAX_PRIO_MASK;
 			if (!jmp_prgcnt || (jmp_prgcnt > nr_actions)) {
-- 
2.35.1.265.g69c8d7142f-goog

