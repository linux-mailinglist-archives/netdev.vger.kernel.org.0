Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D0B6862B7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjBAJWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBAJWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:22:24 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2046.outbound.protection.outlook.com [40.92.52.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046BC3B64B;
        Wed,  1 Feb 2023 01:22:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlJlzrQNJJ5iUA7+bY9XHVdr2nhcHYmL8DQLupi/hVesUa7jj94OZzhx5/ekmYRiXA9uou6ih4lkDispe8OOt5yKxU21OGuNCi9uPxmUk79wfntiSv1kBxHeIeSaPzdvZCKTfFt4sdnGnndtvyCKPefOcVCgIkfx8//K9AZA6GaHr49TrMEiEMydOsc2TlY9Y9pKC14vGGknMa67yizJiAOHQpglS17akAzvbuIQqJsuW4AsEYxTQxTPnDjfZUK1l8ir0ocHBlA2mmh7VjMIHsY57w9o7aZwkwQ1KAqMjKriufOHTUse36qwSCYCZGdZAPEUaBj2y/6YgitRXGxA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZ6rQ0LFqCsRAwpjPQN3PskuqAMJihfP438gksUBkpA=;
 b=oYi9vaWN1R0sh5LTc2JbjoBekKKGZCXg5+8t1+6VzkyiGA6ZgK8XZcBJ529GLpKeJIFmxgT8Rroxj0AEYcCOPhXoawMljaB58y9MM5LavMeZdUxtBnKSqyeAhChEs0ggJ+BE4AyfrxL5+V3WkHu9ZF8azj/mM6vauAs29jKlAaoK7KpAiofhmFvRkqLFEHX/WTCKyJUp1k5C3/g1+8frwDZ4bKhvmK5wRzS9WK/jmrBiY5hOAXSkRDo7qJzrTQ68hbQqPgijZG9Mtt6Cn8RrSKoBio9/nRevnDeIWH7Gz6+BEqA5Shk39LdmTfaPER3OJRdDXfN+eBjCnUDIHKL6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZ6rQ0LFqCsRAwpjPQN3PskuqAMJihfP438gksUBkpA=;
 b=MTky5UxClZdOv/rcqVKHUrB3OOoPvJtCerdIYe8sj1R/a5fg2BQlq2lfgeVctuPNsY/3KqJiuyC5wfXgyxrVxdC2bQmxz1wKw3kxqOAu1Lh8B8iCNrDu1AZo9HY7B2P1ttzMHBFcDl91Nus0qpBYOrFxExeZZStg1aUQVe28TxA7ZGeg3f/+8vM462sB8PfxjjFAh9ITEAfdwURBW/1TAhlv0d1wWUckB3/cHG7f8K3okqZlnhVyJgc7ThO/77Y4Q3ZGZtbOPGGrvqsxOZVmAWYIV1IBg8OIoB4sI1sawZbAuYZHeB+y2htubkL0e3MLscZLtVm+P18hVv7D1e5HDg==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYVP286MB3168.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 09:22:19 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Wed, 1 Feb 2023
 09:22:19 +0000
From:   taoyuan_eddy@hotmail.com
To:     linux-kernel@vger.kernel.org
Cc:     eddytaoyuan <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH] net: openvswitch: reduce cpu_used_mask memory consumption
Date:   Wed,  1 Feb 2023 17:21:42 +0800
Message-ID: <OS3P286MB22955390668913062723D49DF5D19@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [R/iPOsx/Qlz3d2tj+2OIEx5sSk81ZjPzzVjqdvHv03RLCxaW8EzqpkKtbxMaBoW3]
X-ClientProxiedBy: PS2PR03CA0009.apcprd03.prod.outlook.com
 (2603:1096:300:5b::21) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230201092143.621334-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYVP286MB3168:EE_
X-MS-Office365-Filtering-Correlation-Id: c3aea883-6109-4f93-6b39-08db0435d160
X-MS-Exchange-SLBlob-MailProps: q3cIJLDN2c+w+CziC9pPzN+leFQPe4aiwxsgVG8JqV+LCOdr9O29Epb4hqw5MDHW6wP1LJvEt44zbmUyBajIbyh93ghNB9YDjjaycsBeGgKRGk07LW5fy/S28roVyQ+YGUhGh03vdcObtDWrlvp8QXj5/nhstIf6gglfmEkBJ7FxDeFIrrkbTNtpWnLPn9zFS0Ss5i/jCJB/g9qzddEh+2C19sf0hLLP2Pwa2uUmNI4YcsxcREOTUIle0FJIHZ3lkPsW7hvs+euZkfviWXuryeoVT268KLPWDqzARGfr/cIcMFF9nkaYJseGuuc+58JUhj56wNTiCzl60oHV/P2ni5Tmh4JmRVKNyxAKwOjBk4jNZJNt4bgyWVvv7GrA/UBMCFPgpG2poCKfsBXQU8Sako7ET3najjoDks57z9lkgeBgj4InCuTgPUpyaUnq0qNoXeZ1WpPyeVFuP14wXODFbZg4ba0JEf41GP7TbkU2Dnvz9TMfl6eDzp0cne7iZzVBnQA6E9s2fKFPJX0ctvDTm3oIqrjGsCUfro8+NTSKjqWFeN7RisRlvp/vVAmtbxj3oq+Nr6PFqnSLWPRsXQESXG4lGfkgoelAk7jyx8YhZF2GxnPh7LNG9MJH8MzlLcQEczWQHZFPs8fz2sLM0UteeTFYAbsbTjlQv55aJE8EuR50Q6fVle0L9CfwmHAbDecb
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMhdGYgIfFUgPMUvwa7yBKZeg0ocz3Lr46uWQWLp7e2X8bnOw9E0m5d3JO6Ze4ZCYkCH+Ml8LLptIGAmmuKSIjQXS6RpcqNGIUOBdsfnycGvrvlBfutV0jufut64aoVWV93MG99uCHW0bw9KVBgZ6GLnEWCndhFCFM87SzdTDucLfhj2Mm8gRbE5t8cq3ouU7qPV8BJbxqn0V4b1vaOuqtp32kryc+xlOiMWoRVTsyT4+iefpyk9ruBkttEKJBy2hTtH70l8e8JKoCaVaZQ5/ikoeAjX6w4IILSarAZ8Z06X0oQ8/NS0aFgMGiPZBABmzpiR1rLngb6btb/lDIvVd/B8VDQlG0/p4fSJCM0VH1Zus84aHGfT1SrvQP1Y942bOQKKKtalsVq+VvruAhM4f+sAjVWVOBiwykwkL6jv8EqOWVJu0FR3sVxLE9LtRlZ/ewVbdZMmh5edneoiG4DvJYUBINFgXVBnH9gBESAhFTtwgpAnDORw9RNHFVOkElhZlGfa6iXC6jDmkH5v9x+pj4VlBCvOkXHgPBb4Cpoa53UV66STHdKPxlXcwPoOjEfq6HXuy40xBr3d+dlQf4i3jGy8Ir/03EYBEbzS9GuFc4d7xatMJn1YG4PFGWckEpMDwEjdiO2iwhqBhGw7OHRtIQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gOZGJIHxOge3MYvrH2Y3pcxKZTnRazK5bpJrDI4gXh9Yacy9YV/HqjQa/aag?=
 =?us-ascii?Q?sgdFoC9+abVJ5ZCkvKWHWSnlnqU4oB3McXqtHcS/razXQAlN1Hz8ieLKXfBK?=
 =?us-ascii?Q?gB0oCR6WLErQZztmUzff555DLLfuhinRWDPId44cyWzW6E8nU8TT3OGDs/NB?=
 =?us-ascii?Q?RoUfdIRpJclxBqcG68KOXg1F90mgxCAHfQ9q926yKVHignYl87TSOXkyNL8P?=
 =?us-ascii?Q?RfPuaWekv5EfFUUrkR/Q/JvJZevVsZiaPYuhRYruefhQKYELqfBkHg2ejgIU?=
 =?us-ascii?Q?oLJRDiIgovfXH+hIWfMK5MOFJ/Hzrn6qgskGCp5P6h9MBpBpiNI48IXeld9W?=
 =?us-ascii?Q?0hL/hyuZdHqj8jH4IoVxJzPtAnxDw1vEi1JFuJ3W1WioFQPWcY6ubqDbANvN?=
 =?us-ascii?Q?rpo8XFFf1jUwKv4YCwx4Auv2khhU+0c3hcwHGWy7ESUUeY0q2cBsnldwZNkC?=
 =?us-ascii?Q?jeYrUlh5yKv0XSWQYc1LDo/hcFeNOcj4wDmf0+aYyKJiGDFgImIo8MOxRdLi?=
 =?us-ascii?Q?O3UBqKY9qO20QMnMVjWmhkxWtOnFNuZgeG9LTy4N/PWvMrj2J+NO10htz1lz?=
 =?us-ascii?Q?SJudGqRH0lFdtp0F9VBzbJUpdogEx1v0UfsakGh7uFBEy2Uv/FbZbYw6WFzn?=
 =?us-ascii?Q?pJZ8CKcuhkGjxLawDYcIrGvsshGs29l39tc0wr0fZFN5UMPT8lQ6kdmUqVjR?=
 =?us-ascii?Q?klOf1YYPLHItzTbSZFnpnbLXtW3EUZh8T/jXoSfUgby+XYZ4hK5vId/uMS/c?=
 =?us-ascii?Q?JnsCZWLQzwx79sOpMG/IescaLwqW++VCUBoVSlJEsY8nfZbHNwhPFQDk8Lpn?=
 =?us-ascii?Q?NGXyAtZL+HjYdBESC9sPoDDKRD6MeZQ8kUFsODD4QGLd9pC04priI2YxV4Zh?=
 =?us-ascii?Q?uctpMzayFljUvvfelwc1Gd0o4yPlPDxoxS9kH55R8+yXnmqtobe6d4m2d0M7?=
 =?us-ascii?Q?wUm08h6yOwRU/FjAR0CNDlDkhXKcoRlBUPHmmwr9kTLbflA5zVr7ocOn7zD8?=
 =?us-ascii?Q?F3J2PA0LjddlxTbx16qUFmkJD1JfSFGLDSmb0HwulE0fymORlyMwB+OBroKM?=
 =?us-ascii?Q?n8BY8qrW1zl3YDWyTCiH+1J+tASmxY7Q1B2PdvsJoz/9jSuKp9DW6NvfJTHp?=
 =?us-ascii?Q?y61DPoWTUwbFIyhFHktQv11PlSaWgMqF3vNgCj830zc6BS8J03C5k/dT8L2r?=
 =?us-ascii?Q?iwsRefufXVnenAcDHZL1OF+RmAMul8R6oK35oWYydVQ1tQWOyKGRM40b/+6O?=
 =?us-ascii?Q?Lp7JypxV+3e2m7bJJQMSlC8l/hgCMtJNQmjrzIDidlj1ydFh8AXA/OerfJUu?=
 =?us-ascii?Q?OBz2UlOPMJ4Oujb+JgKvWKHf31jIG+Dl0SX+YNzI0y7KKQ=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: c3aea883-6109-4f93-6b39-08db0435d160
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 09:22:19.8872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVP286MB3168
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: eddytaoyuan <taoyuan_eddy@hotmail.com>

struct cpumask cpu_used_mask is directly embedded in struct sw_flow
however, its size is hardcoded to CONFIG_NR_CPUS bits, which
can be as large as 8192 by default, it cost memory and slows down
ovs_flow_alloc, this fix used actual CPU number instead

Signed-off-by: eddytaoyuan <taoyuan_eddy@hotmail.com>
---
 net/openvswitch/flow.c       |  6 +++---
 net/openvswitch/flow.h       |  2 +-
 net/openvswitch/flow_table.c | 25 ++++++++++++++++++++++---
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index e20d1a973417..06345cd8c777 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -107,7 +107,7 @@ void ovs_flow_stats_update(struct sw_flow *flow, __be16 tcp_flags,
 
 					rcu_assign_pointer(flow->stats[cpu],
 							   new_stats);
-					cpumask_set_cpu(cpu, &flow->cpu_used_mask);
+					cpumask_set_cpu(cpu, flow->cpu_used_mask);
 					goto unlock;
 				}
 			}
@@ -135,7 +135,7 @@ void ovs_flow_stats_get(const struct sw_flow *flow,
 	memset(ovs_stats, 0, sizeof(*ovs_stats));
 
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		struct sw_flow_stats *stats = rcu_dereference_ovsl(flow->stats[cpu]);
 
 		if (stats) {
@@ -159,7 +159,7 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
 	int cpu;
 
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		struct sw_flow_stats *stats = ovsl_dereference(flow->stats[cpu]);
 
 		if (stats) {
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index 073ab73ffeaa..b5711aff6e76 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -229,7 +229,7 @@ struct sw_flow {
 					 */
 	struct sw_flow_key key;
 	struct sw_flow_id id;
-	struct cpumask cpu_used_mask;
+	struct cpumask *cpu_used_mask;
 	struct sw_flow_mask *mask;
 	struct sw_flow_actions __rcu *sf_acts;
 	struct sw_flow_stats __rcu *stats[]; /* One for each CPU.  First one
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 0a0e4c283f02..c0fdff73272f 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -87,11 +87,12 @@ struct sw_flow *ovs_flow_alloc(void)
 	if (!stats)
 		goto err;
 
+	flow->cpu_used_mask = (struct cpumask *)&(flow->stats[nr_cpu_ids]);
 	spin_lock_init(&stats->lock);
 
 	RCU_INIT_POINTER(flow->stats[0], stats);
 
-	cpumask_set_cpu(0, &flow->cpu_used_mask);
+	cpumask_set_cpu(0, flow->cpu_used_mask);
 
 	return flow;
 err:
@@ -115,7 +116,7 @@ static void flow_free(struct sw_flow *flow)
 					  flow->sf_acts);
 	/* We open code this to make sure cpu 0 is always considered */
 	for (cpu = 0; cpu < nr_cpu_ids;
-	     cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		if (flow->stats[cpu])
 			kmem_cache_free(flow_stats_cache,
 					(struct sw_flow_stats __force *)flow->stats[cpu]);
@@ -1194,9 +1195,27 @@ int ovs_flow_init(void)
 	BUILD_BUG_ON(__alignof__(struct sw_flow_key) % __alignof__(long));
 	BUILD_BUG_ON(sizeof(struct sw_flow_key) % sizeof(long));
 
+        /*
+         * Simply including 'struct cpumask' in 'struct sw_flow'
+         * consumes memory unnecessarily large.
+         * The reason is that compilation option CONFIG_NR_CPUS(default 8192)
+         * decides the value of NR_CPUS, which in turn decides size of
+         * 'struct cpumask', which means 1024 bytes are needed for the cpumask
+         * It affects ovs_flow_alloc performance as well as memory footprint.
+         * We should use actual CPU count instead of hardcoded value.
+         *
+         * To address this, 'cpu_used_mask' is redefined to pointer
+         * and append a cpumask_size() after 'stat' to hold the actual memory
+         * of struct cpumask
+         *
+         * cpumask APIs like cpumask_next and cpumask_set_cpu have been defined
+         * to never access bits beyond cpu count by design, thus above change is
+         * safe even though the actual memory provided is smaller than
+         * sizeof(struct cpumask)
+         */
 	flow_cache = kmem_cache_create("sw_flow", sizeof(struct sw_flow)
 				       + (nr_cpu_ids
-					  * sizeof(struct sw_flow_stats *)),
+					  * sizeof(struct sw_flow_stats *)) + cpumask_size(),
 				       0, 0, NULL);
 	if (flow_cache == NULL)
 		return -ENOMEM;
-- 
2.27.0

