Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4965BA89D
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiIPIuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIPIua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:50:30 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88DEA0627;
        Fri, 16 Sep 2022 01:50:26 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTSMb42f0zMn05;
        Fri, 16 Sep 2022 16:45:47 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 16:50:24 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [RFC PATCH net-next 2/2] net: sched: use module_net_tcf_action macro when module and net init/exit in action
Date:   Fri, 16 Sep 2022 16:51:55 +0800
Message-ID: <20220916085155.33750-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916085155.33750-1-shaozhengchao@huawei.com>
References: <20220916085155.33750-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use module_net_tcf_action macro when module and net init/exit in action.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/act_bpf.c        | 32 +-------------------------------
 net/sched/act_connmark.c   | 31 +------------------------------
 net/sched/act_csum.c       | 32 +-------------------------------
 net/sched/act_ctinfo.c     | 31 +------------------------------
 net/sched/act_gate.c       | 31 +------------------------------
 net/sched/act_ife.c        | 32 +-------------------------------
 net/sched/act_mpls.c       | 32 +-------------------------------
 net/sched/act_nat.c        | 32 +-------------------------------
 net/sched/act_pedit.c      | 32 +-------------------------------
 net/sched/act_police.c     | 32 +-------------------------------
 net/sched/act_sample.c     | 32 +-------------------------------
 net/sched/act_skbedit.c    | 32 +-------------------------------
 net/sched/act_skbmod.c     | 32 +-------------------------------
 net/sched/act_tunnel_key.c | 32 +-------------------------------
 net/sched/act_vlan.c       | 32 +-------------------------------
 15 files changed, 15 insertions(+), 462 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index c5dbb68e6b78..ad1b0dbfd47d 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -400,37 +400,7 @@ static struct tc_action_ops act_bpf_ops __read_mostly = {
 	.size		=	sizeof(struct tcf_bpf),
 };
 
-static __net_init int bpf_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_bpf_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_bpf_ops);
-}
-
-static void __net_exit bpf_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_bpf_ops.net_id);
-}
-
-static struct pernet_operations bpf_net_ops = {
-	.init = bpf_init_net,
-	.exit_batch = bpf_exit_net,
-	.id   = &act_bpf_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init bpf_init_module(void)
-{
-	return tcf_register_action(&act_bpf_ops, &bpf_net_ops);
-}
-
-static void __exit bpf_cleanup_module(void)
-{
-	tcf_unregister_action(&act_bpf_ops, &bpf_net_ops);
-}
-
-module_init(bpf_init_module);
-module_exit(bpf_cleanup_module);
+module_net_tcf_action(bpf, act_bpf_ops);
 
 MODULE_AUTHOR("Jiri Pirko <jiri@resnulli.us>");
 MODULE_DESCRIPTION("TC BPF based action");
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 66b143bb04ac..58161da6e856 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -209,37 +209,8 @@ static struct tc_action_ops act_connmark_ops = {
 	.size		=	sizeof(struct tcf_connmark_info),
 };
 
-static __net_init int connmark_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_connmark_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_connmark_ops);
-}
-
-static void __net_exit connmark_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_connmark_ops.net_id);
-}
-
-static struct pernet_operations connmark_net_ops = {
-	.init = connmark_init_net,
-	.exit_batch = connmark_exit_net,
-	.id   = &act_connmark_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init connmark_init_module(void)
-{
-	return tcf_register_action(&act_connmark_ops, &connmark_net_ops);
-}
-
-static void __exit connmark_cleanup_module(void)
-{
-	tcf_unregister_action(&act_connmark_ops, &connmark_net_ops);
-}
+module_net_tcf_action(connmark, act_connmark_ops);
 
-module_init(connmark_init_module);
-module_exit(connmark_cleanup_module);
 MODULE_AUTHOR("Felix Fietkau <nbd@openwrt.org>");
 MODULE_DESCRIPTION("Connection tracking mark restoring");
 MODULE_LICENSE("GPL");
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 1366adf9b909..4d8edc93a33f 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -709,37 +709,7 @@ static struct tc_action_ops act_csum_ops = {
 	.size		= sizeof(struct tcf_csum),
 };
 
-static __net_init int csum_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_csum_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_csum_ops);
-}
-
-static void __net_exit csum_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_csum_ops.net_id);
-}
-
-static struct pernet_operations csum_net_ops = {
-	.init = csum_init_net,
-	.exit_batch = csum_exit_net,
-	.id   = &act_csum_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
+module_net_tcf_action(csum, act_csum_ops);
 
 MODULE_DESCRIPTION("Checksum updating actions");
 MODULE_LICENSE("GPL");
-
-static int __init csum_init_module(void)
-{
-	return tcf_register_action(&act_csum_ops, &csum_net_ops);
-}
-
-static void __exit csum_cleanup_module(void)
-{
-	tcf_unregister_action(&act_csum_ops, &csum_net_ops);
-}
-
-module_init(csum_init_module);
-module_exit(csum_cleanup_module);
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index d4102f0a9abd..21d1cd20c8d3 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -362,37 +362,8 @@ static struct tc_action_ops act_ctinfo_ops = {
 	.size	= sizeof(struct tcf_ctinfo),
 };
 
-static __net_init int ctinfo_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_ctinfo_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_ctinfo_ops);
-}
-
-static void __net_exit ctinfo_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_ctinfo_ops.net_id);
-}
-
-static struct pernet_operations ctinfo_net_ops = {
-	.init		= ctinfo_init_net,
-	.exit_batch	= ctinfo_exit_net,
-	.id		= &act_ctinfo_ops.net_id,
-	.size		= sizeof(struct tc_action_net),
-};
-
-static int __init ctinfo_init_module(void)
-{
-	return tcf_register_action(&act_ctinfo_ops, &ctinfo_net_ops);
-}
-
-static void __exit ctinfo_cleanup_module(void)
-{
-	tcf_unregister_action(&act_ctinfo_ops, &ctinfo_net_ops);
-}
+module_net_tcf_action(ctinfo, act_ctinfo_ops);
 
-module_init(ctinfo_init_module);
-module_exit(ctinfo_cleanup_module);
 MODULE_AUTHOR("Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>");
 MODULE_DESCRIPTION("Connection tracking mark actions");
 MODULE_LICENSE("GPL");
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 3049878e7315..59a4dbb144e7 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -642,35 +642,6 @@ static struct tc_action_ops act_gate_ops = {
 	.size		=	sizeof(struct tcf_gate),
 };
 
-static __net_init int gate_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_gate_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_gate_ops);
-}
-
-static void __net_exit gate_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_gate_ops.net_id);
-}
-
-static struct pernet_operations gate_net_ops = {
-	.init = gate_init_net,
-	.exit_batch = gate_exit_net,
-	.id   = &act_gate_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init gate_init_module(void)
-{
-	return tcf_register_action(&act_gate_ops, &gate_net_ops);
-}
-
-static void __exit gate_cleanup_module(void)
-{
-	tcf_unregister_action(&act_gate_ops, &gate_net_ops);
-}
+module_net_tcf_action(gate, act_gate_ops);
 
-module_init(gate_init_module);
-module_exit(gate_cleanup_module);
 MODULE_LICENSE("GPL v2");
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 41d63b33461d..efbdddcacdea 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -888,37 +888,7 @@ static struct tc_action_ops act_ife_ops = {
 	.size =	sizeof(struct tcf_ife_info),
 };
 
-static __net_init int ife_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_ife_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_ife_ops);
-}
-
-static void __net_exit ife_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_ife_ops.net_id);
-}
-
-static struct pernet_operations ife_net_ops = {
-	.init = ife_init_net,
-	.exit_batch = ife_exit_net,
-	.id   = &act_ife_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init ife_init_module(void)
-{
-	return tcf_register_action(&act_ife_ops, &ife_net_ops);
-}
-
-static void __exit ife_cleanup_module(void)
-{
-	tcf_unregister_action(&act_ife_ops, &ife_net_ops);
-}
-
-module_init(ife_init_module);
-module_exit(ife_cleanup_module);
+module_net_tcf_action(ife, act_ife_ops);
 
 MODULE_AUTHOR("Jamal Hadi Salim(2015)");
 MODULE_DESCRIPTION("Inter-FE LFB action");
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8ad25cc8ccd5..aa9a354ef308 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -437,37 +437,7 @@ static struct tc_action_ops act_mpls_ops = {
 	.size		=	sizeof(struct tcf_mpls),
 };
 
-static __net_init int mpls_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_mpls_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_mpls_ops);
-}
-
-static void __net_exit mpls_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_mpls_ops.net_id);
-}
-
-static struct pernet_operations mpls_net_ops = {
-	.init = mpls_init_net,
-	.exit_batch = mpls_exit_net,
-	.id   = &act_mpls_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init mpls_init_module(void)
-{
-	return tcf_register_action(&act_mpls_ops, &mpls_net_ops);
-}
-
-static void __exit mpls_cleanup_module(void)
-{
-	tcf_unregister_action(&act_mpls_ops, &mpls_net_ops);
-}
-
-module_init(mpls_init_module);
-module_exit(mpls_cleanup_module);
+module_net_tcf_action(mpls, act_mpls_ops);
 
 MODULE_SOFTDEP("post: mpls_gso");
 MODULE_AUTHOR("Netronome Systems <oss-drivers@netronome.com>");
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 9265145f1040..e14e8d2819bc 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -298,37 +298,7 @@ static struct tc_action_ops act_nat_ops = {
 	.size		=	sizeof(struct tcf_nat),
 };
 
-static __net_init int nat_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_nat_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_nat_ops);
-}
-
-static void __net_exit nat_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_nat_ops.net_id);
-}
-
-static struct pernet_operations nat_net_ops = {
-	.init = nat_init_net,
-	.exit_batch = nat_exit_net,
-	.id   = &act_nat_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
+module_net_tcf_action(nat, act_nat_ops);
 
 MODULE_DESCRIPTION("Stateless NAT actions");
 MODULE_LICENSE("GPL");
-
-static int __init nat_init_module(void)
-{
-	return tcf_register_action(&act_nat_ops, &nat_net_ops);
-}
-
-static void __exit nat_cleanup_module(void)
-{
-	tcf_unregister_action(&act_nat_ops, &nat_net_ops);
-}
-
-module_init(nat_init_module);
-module_exit(nat_cleanup_module);
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 94ed5857ce67..713432ac4fa7 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -539,38 +539,8 @@ static struct tc_action_ops act_pedit_ops = {
 	.size		=	sizeof(struct tcf_pedit),
 };
 
-static __net_init int pedit_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_pedit_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_pedit_ops);
-}
-
-static void __net_exit pedit_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_pedit_ops.net_id);
-}
-
-static struct pernet_operations pedit_net_ops = {
-	.init = pedit_init_net,
-	.exit_batch = pedit_exit_net,
-	.id   = &act_pedit_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
+module_net_tcf_action(pedit, act_pedit_ops);
 
 MODULE_AUTHOR("Jamal Hadi Salim(2002-4)");
 MODULE_DESCRIPTION("Generic Packet Editor actions");
 MODULE_LICENSE("GPL");
-
-static int __init pedit_init_module(void)
-{
-	return tcf_register_action(&act_pedit_ops, &pedit_net_ops);
-}
-
-static void __exit pedit_cleanup_module(void)
-{
-	tcf_unregister_action(&act_pedit_ops, &pedit_net_ops);
-}
-
-module_init(pedit_init_module);
-module_exit(pedit_cleanup_module);
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0adb26e366a7..9e26b14ca86a 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -500,34 +500,4 @@ static struct tc_action_ops act_police_ops = {
 	.size		=	sizeof(struct tcf_police),
 };
 
-static __net_init int police_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_police_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_police_ops);
-}
-
-static void __net_exit police_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_police_ops.net_id);
-}
-
-static struct pernet_operations police_net_ops = {
-	.init = police_init_net,
-	.exit_batch = police_exit_net,
-	.id   = &act_police_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init police_init_module(void)
-{
-	return tcf_register_action(&act_police_ops, &police_net_ops);
-}
-
-static void __exit police_cleanup_module(void)
-{
-	tcf_unregister_action(&act_police_ops, &police_net_ops);
-}
-
-module_init(police_init_module);
-module_exit(police_cleanup_module);
+module_net_tcf_action(police, act_police_ops);
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 5ba36f70e3a1..bb9afb154698 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -308,37 +308,7 @@ static struct tc_action_ops act_sample_ops = {
 	.size	  = sizeof(struct tcf_sample),
 };
 
-static __net_init int sample_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_sample_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_sample_ops);
-}
-
-static void __net_exit sample_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_sample_ops.net_id);
-}
-
-static struct pernet_operations sample_net_ops = {
-	.init = sample_init_net,
-	.exit_batch = sample_exit_net,
-	.id   = &act_sample_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init sample_init_module(void)
-{
-	return tcf_register_action(&act_sample_ops, &sample_net_ops);
-}
-
-static void __exit sample_cleanup_module(void)
-{
-	tcf_unregister_action(&act_sample_ops, &sample_net_ops);
-}
-
-module_init(sample_init_module);
-module_exit(sample_cleanup_module);
+module_net_tcf_action(sample, act_sample_ops);
 
 MODULE_AUTHOR("Yotam Gigi <yotam.gi@gmail.com>");
 MODULE_DESCRIPTION("Packet sampling action");
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 7f598784fd30..d054b0b6b4ce 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -415,38 +415,8 @@ static struct tc_action_ops act_skbedit_ops = {
 	.size		=	sizeof(struct tcf_skbedit),
 };
 
-static __net_init int skbedit_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_skbedit_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_skbedit_ops);
-}
-
-static void __net_exit skbedit_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_skbedit_ops.net_id);
-}
-
-static struct pernet_operations skbedit_net_ops = {
-	.init = skbedit_init_net,
-	.exit_batch = skbedit_exit_net,
-	.id   = &act_skbedit_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
+module_net_tcf_action(skbedit, act_skbedit_ops);
 
 MODULE_AUTHOR("Alexander Duyck, <alexander.h.duyck@intel.com>");
 MODULE_DESCRIPTION("SKB Editing");
 MODULE_LICENSE("GPL");
-
-static int __init skbedit_init_module(void)
-{
-	return tcf_register_action(&act_skbedit_ops, &skbedit_net_ops);
-}
-
-static void __exit skbedit_cleanup_module(void)
-{
-	tcf_unregister_action(&act_skbedit_ops, &skbedit_net_ops);
-}
-
-module_init(skbedit_init_module);
-module_exit(skbedit_cleanup_module);
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index d98758a63934..b3f712b2a453 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -286,38 +286,8 @@ static struct tc_action_ops act_skbmod_ops = {
 	.size		=	sizeof(struct tcf_skbmod),
 };
 
-static __net_init int skbmod_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_skbmod_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_skbmod_ops);
-}
-
-static void __net_exit skbmod_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_skbmod_ops.net_id);
-}
-
-static struct pernet_operations skbmod_net_ops = {
-	.init = skbmod_init_net,
-	.exit_batch = skbmod_exit_net,
-	.id   = &act_skbmod_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
+module_net_tcf_action(skbmod, act_skbmod_ops);
 
 MODULE_AUTHOR("Jamal Hadi Salim, <jhs@mojatatu.com>");
 MODULE_DESCRIPTION("SKB data mod-ing");
 MODULE_LICENSE("GPL");
-
-static int __init skbmod_init_module(void)
-{
-	return tcf_register_action(&act_skbmod_ops, &skbmod_net_ops);
-}
-
-static void __exit skbmod_cleanup_module(void)
-{
-	tcf_unregister_action(&act_skbmod_ops, &skbmod_net_ops);
-}
-
-module_init(skbmod_init_module);
-module_exit(skbmod_cleanup_module);
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2691a3d8e451..f4fea32c9e10 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -836,37 +836,7 @@ static struct tc_action_ops act_tunnel_key_ops = {
 	.size		=	sizeof(struct tcf_tunnel_key),
 };
 
-static __net_init int tunnel_key_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_tunnel_key_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_tunnel_key_ops);
-}
-
-static void __net_exit tunnel_key_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_tunnel_key_ops.net_id);
-}
-
-static struct pernet_operations tunnel_key_net_ops = {
-	.init = tunnel_key_init_net,
-	.exit_batch = tunnel_key_exit_net,
-	.id   = &act_tunnel_key_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init tunnel_key_init_module(void)
-{
-	return tcf_register_action(&act_tunnel_key_ops, &tunnel_key_net_ops);
-}
-
-static void __exit tunnel_key_cleanup_module(void)
-{
-	tcf_unregister_action(&act_tunnel_key_ops, &tunnel_key_net_ops);
-}
-
-module_init(tunnel_key_init_module);
-module_exit(tunnel_key_cleanup_module);
+module_net_tcf_action(tunnel_key, act_tunnel_key_ops);
 
 MODULE_AUTHOR("Amir Vadai <amir@vadai.me>");
 MODULE_DESCRIPTION("ip tunnel manipulation actions");
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 7b24e898a3e6..6490a5a0f737 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -426,37 +426,7 @@ static struct tc_action_ops act_vlan_ops = {
 	.size		=	sizeof(struct tcf_vlan),
 };
 
-static __net_init int vlan_init_net(struct net *net)
-{
-	struct tc_action_net *tn = net_generic(net, act_vlan_ops.net_id);
-
-	return tc_action_net_init(net, tn, &act_vlan_ops);
-}
-
-static void __net_exit vlan_exit_net(struct list_head *net_list)
-{
-	tc_action_net_exit(net_list, act_vlan_ops.net_id);
-}
-
-static struct pernet_operations vlan_net_ops = {
-	.init = vlan_init_net,
-	.exit_batch = vlan_exit_net,
-	.id   = &act_vlan_ops.net_id,
-	.size = sizeof(struct tc_action_net),
-};
-
-static int __init vlan_init_module(void)
-{
-	return tcf_register_action(&act_vlan_ops, &vlan_net_ops);
-}
-
-static void __exit vlan_cleanup_module(void)
-{
-	tcf_unregister_action(&act_vlan_ops, &vlan_net_ops);
-}
-
-module_init(vlan_init_module);
-module_exit(vlan_cleanup_module);
+module_net_tcf_action(vlan, act_vlan_ops);
 
 MODULE_AUTHOR("Jiri Pirko <jiri@resnulli.us>");
 MODULE_DESCRIPTION("vlan manipulation actions");
-- 
2.17.1

