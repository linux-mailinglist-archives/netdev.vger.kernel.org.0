Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF7D46E499
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhLIIxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhLIIxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:53:14 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2235C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 00:49:41 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g16so4516477pgi.1
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 00:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81xUi5/l7TAI7hGfJghIoytFkdu2lwMidZietds6zaw=;
        b=ckY2/Xe6/vrXPSluCLcg1gh6UYOUhUpKtowYQ57QStQCAAaYTAsnc6zjzjwxkWUzKZ
         TEmvTXtfIMkEF5n8kNDbJ6eMDVcr4Co4ZzwqOwDkv/k9PvvFQfkJ5R3QFyQ1jqW5aJrv
         WnUxNrge+aSUQzkRDKhWKZmuCHKg5WwtYU8JiB+5ISGjc0f7hNzg5bKm46RYzIF7Fjq7
         XdwMlTipFmxTGOSLU2oBkuXBXwOidp/vW0jtS8SmK4ceG0dQPCMZQoPJ75rNW4PvSX2Y
         ClPNWPME4QuwNRW5iNUk/9yrzmgdFDe3anRVyhFv+izQ9Z0LEiXbPHYNfrqeXmegc5P5
         qMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81xUi5/l7TAI7hGfJghIoytFkdu2lwMidZietds6zaw=;
        b=Q0AUxesx02gSxfzOPlUf4wn3T41mr8JJTwQMkK1ftxA8TeP+Sbc9rsOUUDPiTCbv/C
         WZymUmz80U9MTcSGe0VzKdf0QwnG75peaohYN4OJDEV9Ye2NwmBLeZC99kbAEyaL530t
         dzazIKolzy9LVdPWbvPbhS8BbmKLT/ZDJyD2AKuRCZbjaM1CjaYMrp1KTHaTXLWg0c57
         qa282Y6liCWy19E9NzVJq40iqCQ05PA5D4q+l0JBXM+UxlkGKUkJU+KI1w26HHt8NQaO
         GjAkZ3H98Kj8zHbTfGHRTY+XZ9NlEssoGLBmHJT2AcQOBapAblEuCH/i9lS/KQt3husb
         MNtg==
X-Gm-Message-State: AOAM533hG+lPat36M3VOBqf5f+/MhmGU+a6GpW+KTIcO+svRpfIyfqdp
        a4y117kohcBwJdbPWljvTmg=
X-Google-Smtp-Source: ABdhPJwmMKcvcBnXQ4jIqCVtjmtCfF5BKM3lybQ9ii8u80NXS8LTYD7MS2pdtBWnAVKWY7IKXW49oQ==
X-Received: by 2002:a63:130c:: with SMTP id i12mr33677681pgl.297.1639039781130;
        Thu, 09 Dec 2021 00:49:41 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:903c:510c:9a29:125b])
        by smtp.gmail.com with ESMTPSA id l9sm6646680pfu.55.2021.12.09.00.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 00:49:40 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net] net/sched: fq_pie: prevent dismantle issue
Date:   Thu,  9 Dec 2021 00:49:37 -0800
Message-Id: <20211209084937.3500020-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For some reason, fq_pie_destroy() did not copy
working code from pie_destroy() and other qdiscs,
thus causing elusive bug.

Before calling del_timer_sync(&q->adapt_timer),
we need to ensure timer will not rearm itself.

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu:    0-....: (4416 ticks this GP) idle=60d/1/0x4000000000000000 softirq=10433/10434 fqs=2579
        (t=10501 jiffies g=13085 q=3989)
NMI backtrace for cpu 0
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:711 [inline]
 rcu_pending kernel/rcu/tree.c:3878 [inline]
 rcu_sched_clock_irq.cold+0x9d/0x746 kernel/rcu/tree.c:2597
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
RIP: 0010:write_comp_data kernel/kcov.c:221 [inline]
RIP: 0010:__sanitizer_cov_trace_const_cmp1+0x1d/0x80 kernel/kcov.c:273
Code: 54 c8 20 48 89 10 c3 66 0f 1f 44 00 00 53 41 89 fb 41 89 f1 bf 03 00 00 00 65 48 8b 0c 25 40 70 02 00 48 89 ce 4c 8b 54 24 08 <e8> 4e f7 ff ff 84 c0 74 51 48 8b 81 88 15 00 00 44 8b 81 84 15 00
RSP: 0018:ffffc90000d27b28 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff888064bf1bf0 RCX: ffff888011928000
RDX: ffff888011928000 RSI: ffff888011928000 RDI: 0000000000000003
RBP: ffff888064bf1c28 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff875d8295 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880783dd300 R14: 0000000000000000 R15: 0000000000000000
 pie_calculate_probability+0x405/0x7c0 net/sched/sch_pie.c:418
 fq_pie_timer+0x170/0x2a0 net/sched/sch_fq_pie.c:383
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Cc: Sachin D. Patil <sdp.sachin@gmail.com>
Cc: V. Saicharan <vsaicharan1998@gmail.com>
Cc: Mohit Bhasi <mohitbhasi1998@gmail.com>
Cc: Leslie Monis <lesliemonis@gmail.com>
Cc: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 net/sched/sch_fq_pie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 830f3559f727ad471b595b2f5b04788827da89b0..d6aba6edd16e5eab120a57c316fcb06a5d5f3442 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -531,6 +531,7 @@ static void fq_pie_destroy(struct Qdisc *sch)
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
 
 	tcf_block_put(q->block);
+	q->p_params.tupdate = 0;
 	del_timer_sync(&q->adapt_timer);
 	kvfree(q->flows);
 }
-- 
2.34.1.400.ga245620fadb-goog

