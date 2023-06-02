Return-Path: <netdev+bounces-7416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E72720236
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26B841C20FC1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DCB171B4;
	Fri,  2 Jun 2023 12:37:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EBA8476
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:37:57 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766641AE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:37:55 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5693861875fso21793307b3.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 05:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685709474; x=1688301474;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4cWZzLOjP1Dx9q6HXLXSmu9V2yCzu5d56fE4N1+kjK0=;
        b=SfLkdMuiP3dkZA1YUzgoRLaNAX4R4BK8IzsRpq+4ysXqnrCe1o434D0GTOc/a2nDaR
         UU2n0r0GvZKbscmS35eZcRt3/zdRFporhyP9EF3eMfevhqeAKeJ5Cf+Re0RhuRNerQqx
         P/tUwTNV6tqZ04vpItjQJgbzSCC3RqQYQEZBv7c4vshifJ5ZqahdZtSoSRNLXLH1Xt/c
         whKeqqxux3ipiulKFOwxAafTP5pm503Nz9zzCBkU7DOwZ36jQ2QDJTqiVwUiYvDf5OjO
         4irYTHAbP9X9dEzKobbd8Sh4UDHubLhLodMXPfDfyvQOJsnX7F1bxzYQ3c2hT/HmWqQa
         j2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685709474; x=1688301474;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4cWZzLOjP1Dx9q6HXLXSmu9V2yCzu5d56fE4N1+kjK0=;
        b=PC7q4oru0PkZHYGcQ5DzK7S7hK+98yDG+huuJaVPxEvNzI1ezzkMzT+xIRTnjHsP6u
         bt36EwUPg+Qziz1Tc6eQr/INvcLe97e1iQubSJDjnvYHDzFtRIY68SRuXdjtDobAILMG
         x7IrqAwHlmN6Vjt8QWJnYvEiq/qqTPFdAoDpcFjqQ0ITLebMVVvXn5T1c4i/gvxQyHdB
         Al0XzAILYl+jCHnCW8DyVQ1mEDf3QSWd2FfsmpAbLkzciNRhlMey6kuKVaFYpg4UAI7y
         gRVQ638gMRtIhJ/4Bu1uxzi5VKSGliKir636pk10mr4KzjzckJsSpmeNFZ05kWCqRGca
         GsCg==
X-Gm-Message-State: AC+VfDzrO5dGC6oDQDyqo6iwqtON2LRCv7tKcK7J9N/YZu8ToUbgucVj
	6u4TsTdRfYsh7hQYsgGzypIv98GOIFPYTQ==
X-Google-Smtp-Source: ACHHUZ6Qo9Y+Xr5ggmMMBc8VrS1W+WeIzC0xfaUWTQyEKZjys4gaBRePYIGkORKIWfOt54wYetGyLf3q5k442A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:26c9:0:b0:ba8:3e78:206e with SMTP id
 m192-20020a2526c9000000b00ba83e78206emr1804567ybm.9.1685709474453; Fri, 02
 Jun 2023 05:37:54 -0700 (PDT)
Date: Fri,  2 Jun 2023 12:37:47 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602123747.2056178-1-edumazet@google.com>
Subject: [PATCH net] net/sched: fq_pie: ensure reasonable TCA_FQ_PIE_QUANTUM values
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We got multiple syzbot reports, all duplicates of the following [1]

syzbot managed to install fq_pie with a zero TCA_FQ_PIE_QUANTUM,
thus triggering infinite loops.

Use limits similar to sch_fq, with commits
3725a269815b ("pkt_sched: fq: avoid hang when quantum 0") and
d9e15a273306 ("pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM")

[1]
watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [swapper/0:0]
Modules linked in:
irq event stamp: 172817
hardirqs last enabled at (172816): [<ffff80001242fde4>] __el1_irq arch/arm64/kernel/entry-common.c:476 [inline]
hardirqs last enabled at (172816): [<ffff80001242fde4>] el1_interrupt+0x58/0x68 arch/arm64/kernel/entry-common.c:486
hardirqs last disabled at (172817): [<ffff80001242fdb0>] __el1_irq arch/arm64/kernel/entry-common.c:468 [inline]
hardirqs last disabled at (172817): [<ffff80001242fdb0>] el1_interrupt+0x24/0x68 arch/arm64/kernel/entry-common.c:486
softirqs last enabled at (167634): [<ffff800008020c1c>] softirq_handle_end kernel/softirq.c:414 [inline]
softirqs last enabled at (167634): [<ffff800008020c1c>] __do_softirq+0xac0/0xd54 kernel/softirq.c:600
softirqs last disabled at (167701): [<ffff80000802a660>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.4.0-rc3-syzkaller-geb0f1697d729 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : fq_pie_qdisc_dequeue+0x10c/0x8ac net/sched/sch_fq_pie.c:246
lr : fq_pie_qdisc_dequeue+0xe4/0x8ac net/sched/sch_fq_pie.c:240
sp : ffff800008007210
x29: ffff800008007280 x28: ffff0000c86f7890 x27: ffff0000cb20c2e8
x26: ffff0000cb20c2f0 x25: dfff800000000000 x24: ffff0000cb20c2e0
x23: ffff0000c86f7880 x22: 0000000000000040 x21: 1fffe000190def10
x20: ffff0000cb20c2e0 x19: ffff0000cb20c2e0 x18: ffff800008006e60
x17: 0000000000000000 x16: ffff80000850af6c x15: 0000000000000302
x14: 0000000000000100 x13: 0000000000000000 x12: 0000000000000001
x11: 0000000000000302 x10: 0000000000000100 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff80000841c468 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000cb20c2e0 x1 : ffff0000cb20c2e0 x0 : 0000000000000001
Call trace:
fq_pie_qdisc_dequeue+0x10c/0x8ac net/sched/sch_fq_pie.c:246
dequeue_skb net/sched/sch_generic.c:292 [inline]
qdisc_restart net/sched/sch_generic.c:397 [inline]
__qdisc_run+0x1fc/0x231c net/sched/sch_generic.c:415
__dev_xmit_skb net/core/dev.c:3868 [inline]
__dev_queue_xmit+0xc80/0x3318 net/core/dev.c:4210
dev_queue_xmit include/linux/netdevice.h:3085 [inline]
neigh_connected_output+0x2f8/0x38c net/core/neighbour.c:1581
neigh_output include/net/neighbour.h:544 [inline]
ip6_finish_output2+0xd60/0x1a1c net/ipv6/ip6_output.c:134
__ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
ip6_finish_output+0x538/0x8c8 net/ipv6/ip6_output.c:206
NF_HOOK_COND include/linux/netfilter.h:292 [inline]
ip6_output+0x270/0x594 net/ipv6/ip6_output.c:227
dst_output include/net/dst.h:458 [inline]
NF_HOOK include/linux/netfilter.h:303 [inline]
ndisc_send_skb+0xc30/0x1790 net/ipv6/ndisc.c:508
ndisc_send_rs+0x47c/0x5d4 net/ipv6/ndisc.c:718
addrconf_rs_timer+0x300/0x58c net/ipv6/addrconf.c:3936
call_timer_fn+0x19c/0x8cc kernel/time/timer.c:1700
expire_timers kernel/time/timer.c:1751 [inline]
__run_timers+0x55c/0x734 kernel/time/timer.c:2022
run_timer_softirq+0x7c/0x114 kernel/time/timer.c:2035
__do_softirq+0x2d0/0xd54 kernel/softirq.c:571
____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
call_on_irq_stack+0x24/0x4c arch/arm64/kernel/entry.S:882
do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:85
invoke_softirq kernel/softirq.c:452 [inline]
__irq_exit_rcu+0x28c/0x534 kernel/softirq.c:650
irq_exit_rcu+0x14/0x84 kernel/softirq.c:662
__el1_irq arch/arm64/kernel/entry-common.c:472 [inline]
el1_interrupt+0x38/0x68 arch/arm64/kernel/entry-common.c:486
el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:491
el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:587
__daif_local_irq_enable arch/arm64/include/asm/irqflags.h:33 [inline]
arch_local_irq_enable+0x8/0xc arch/arm64/include/asm/irqflags.h:55
cpuidle_idle_call kernel/sched/idle.c:170 [inline]
do_idle+0x1f0/0x4e8 kernel/sched/idle.c:282
cpu_startup_entry+0x24/0x28 kernel/sched/idle.c:379
rest_init+0x2dc/0x2f4 init/main.c:735
start_kernel+0x0/0x55c init/main.c:834
start_kernel+0x3f0/0x55c init/main.c:1088
__primary_switched+0xb8/0xc0 arch/arm64/kernel/head.S:523

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq_pie.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 6980796d435d9d496bbf6db773dc6d8b5857c50c..c699e5095607dedbc921802f31e8f4c78c35985f 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -201,6 +201,11 @@ static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_CN;
 }
 
+static struct netlink_range_validation fq_pie_q_range = {
+	.min = 1,
+	.max = 1 << 20,
+};
+
 static const struct nla_policy fq_pie_policy[TCA_FQ_PIE_MAX + 1] = {
 	[TCA_FQ_PIE_LIMIT]		= {.type = NLA_U32},
 	[TCA_FQ_PIE_FLOWS]		= {.type = NLA_U32},
@@ -208,7 +213,8 @@ static const struct nla_policy fq_pie_policy[TCA_FQ_PIE_MAX + 1] = {
 	[TCA_FQ_PIE_TUPDATE]		= {.type = NLA_U32},
 	[TCA_FQ_PIE_ALPHA]		= {.type = NLA_U32},
 	[TCA_FQ_PIE_BETA]		= {.type = NLA_U32},
-	[TCA_FQ_PIE_QUANTUM]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_QUANTUM]		=
+			NLA_POLICY_FULL_RANGE(NLA_U32, &fq_pie_q_range),
 	[TCA_FQ_PIE_MEMORY_LIMIT]	= {.type = NLA_U32},
 	[TCA_FQ_PIE_ECN_PROB]		= {.type = NLA_U32},
 	[TCA_FQ_PIE_ECN]		= {.type = NLA_U32},
-- 
2.41.0.rc0.172.g3f132b7071-goog


