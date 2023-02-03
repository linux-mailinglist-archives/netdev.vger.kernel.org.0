Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520196892D0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjBCIxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjBCIx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:53:29 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2025.outbound.protection.outlook.com [40.92.107.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E018A2C66A;
        Fri,  3 Feb 2023 00:53:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOmdN+r+SWk9lAjJ98rk7s4W1zntm89V4RbiiB+GT0HeV5E0+Q1B0F/YawApurc6a1N91UEsw2FW2ceuY45w3pigR2Y3Rv7LinXnjltUD4LfA/lygqmWOpdyTMG+69iYoHPK8uPKC1UfrQ2oQB26lr9cbuLC2mY3XnEUGnrzd3be/p4CdtjPuViKjokbRm9hhDQg7gfuRTZwszozTA5aXeU93Hqwu69+YfdIPAdDPdDwdpS25D/txllYqzenOhAemZGs5+1w5c7jFExe2a7CpfcyAb9cODK4t2zjuQBYvDrsJHWFaimEcEQdxxjJUgYc28bhxLce8ScBcOtX8dH8Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtqbQdLv493zXb9EZS6kdPrDzcdP21q6asQPwvUEUOo=;
 b=DqxGROjDttct7MCrb65BSFUHJ4t7eJ5BvbUYQ0iwbq0e1cycGqRdqTUJdEd8CK2pR6WEb0GIXA+jsxUxKrMWeCkOwMnFmzw2B66OCvDzNWAdJmrGVAGBUc25Cca8mFwt0WZ2sUEULG/q/yOWqYm5swklFeUuabZy6LCVMm61r05BmQdoLdx5eMQS2e4epJpguD+l5AJaOlo9vA24xIyPsZ119LJI03SIEm1XzKAjV/XUG/yb74bowgI2qwB/wogrRhBPBQV91d8ReEnNK2J5wujkSN7UBEFUMMRqBaLaN3Gh96ORbi4ESzF4FWdmz/adxe2XoRHyDn7TpmcWWOPZuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtqbQdLv493zXb9EZS6kdPrDzcdP21q6asQPwvUEUOo=;
 b=UsdR7HwpPE7Nk4zXmaRfvCm3mXxa0HCyeGMd5+foPLIp4AQwrr6bM6XRSVjGQajz8t7IOIyQONkXOZQjDhpVQvWVdLLjvfweSgfUihndmoI0PJ6TF3Rl/L9I0i9E5JjTeHqz+K3OqsaXITrusfGZhVlTFohC03VR7CLBpG2UXH97Isqbw41ZAnjoAIt8vBgreyMvY0DlyMANLIWp31sWavTaUUCHTJLcN/u+ItGmnlNYOEOD+/5VQqihzbC7qroEExzsqORL1TpPX5iOUQKZb9h1nUNIkdi7ROOhbzjgUR/ygFoudvPWggHxojB9ifZVwT2livWl918SFoeH1Ubl3g==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB1919.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:171::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Fri, 3 Feb
 2023 08:53:24 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Fri, 3 Feb 2023
 08:53:23 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 1/1] net:openvswitch:reduce cpu_used_mask memory
Date:   Fri,  3 Feb 2023 16:52:56 +0800
Message-ID: <OS3P286MB22955AB6FF67B67778343FEDF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [hg8SPq3bRRjXY7Nnh6hE4zaGMS1yovz/]
X-ClientProxiedBy: SG2P153CA0002.APCP153.PROD.OUTLOOK.COM (2603:1096::12) To
 OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230203085257.254240-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB1919:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fb3c58e-bd35-4fae-4b23-08db05c41b82
X-MS-Exchange-SLBlob-MailProps: Op6Ru+d2ciGZxW9SRnKHFeRtQv7uON2YAiNRMPEO9TWlGk+3SWraKATLMuVVUBM54pIykylzJYogXOPdlQ6xlrVI4+cPzxvjZ68UFmuU30tJexYliVvP1hjAj6nd+H9e1BaXjPB5KWHwQklzL2SeiAiajrmm8NF9a5QoQvmBM6urfGx2Hkc1zcRA9TZRJTThEoE5XrO7iyOoXuTlW7huFt5cQe1P4towky0Ah19Cy0x4F1UOk8W31+XW/ew7rEQGIVeyaqZivWG+Vf+9PrJuiQJyZ6sZvnyIlUIQXDgc2wnnlFde7sARoYBKK3XoPPXBdSgrOlaN6vk4PKa9bmfwlzNxbJoUjOSgif4jG6cUe0lWNKg04PIE61H5wzKcCcnZEAg8xVmxEJhRqxpTkbivqT88/G+xnOgeoAqo5geGfBiSFjpLkAvDPrUiaXoUsLtj60RJt6favtalHGEoWL+6i1oOytcBlkllw881B+IteHBKgxxiTLjqs8HwwjNL7dZytQQB/On/j3WQxpSZYppyKs8r3t/ag4Up1XlH0oDoST4rt+KN1JIYyY07q/ZrHjwQ4jAOXG2b4A6CQjIaCiWuTfpSwKL0J6XGVpRICzg8SehoUnieXPgJ1RmFiHenJKEcOAAo9UB6C7ogtI5LhmMF43aoVhEriPUWDL24WoGm1BtFaEPaeNK9MTIWTbr63kkIyD6ODgzGQ5tai94k0+vlxVfkKrOuK73t
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AWK6oc5071L1s9i1Smv78gEhTOSD2pT50fQ4XeTWRxyN5rl0wpN6dizRF1vCZL1YT9E6dN28dSphKgSTr24yAG9yFrBvHSuLxaGMZyYcToe9RKruaJTR62Qq1DHil7cL/fd4HuGlctY9D22jZuErXWLo4n3SYyK9A69vkU/9JAMPFfZDWLxEkvAR6rxmj/whhYhiO+XCYPSPNgFtEFj5q6Nuzd7vADYqdsMf9atBSY8fA2MPocLh2QYFdDpZXdDKl7QibBJenUWy9htB8uTuE9GgY0B311NUUHp6wtllW8c4eCbBdkPVMJJ+i98xnEhjUcXR+V9Wh4Drh1Zy+AMoeW/fD/Vsepgij5xxuuDrFnS5aqNlwweptXGKfXjBGuTyfLrlx6xukZ1eqXd7fW7D+OzZwtKetAj3wF2zxsB0z0JNswJpZt4i58Uh8LouLLJt0cD+0mdVNLI2dJiFx45FszvWVL2U0TZCpDNAYoVHfwZ/Ry0lPEMvR3aYrW1oZg2Iam/YljD6AnNbEvpwYp3t36iO0RlK2ZfCrdZh1UsHRywdR5fkUHHh4Iy48NN+N8jy0b0DuqD4LbLoflxPQfp6E30KPjPqjLPB/Ix4zOnR5KWnE1uPDE7vaz6DFCJMpZnTo0X9XOtu+7FZUm4lAsI8Zw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6xYZk0Zv8kFfamK9w3Whbsqs1fFYbd2uoshwi/TjpZ8dqU0q1pZymW8tLOXJ?=
 =?us-ascii?Q?hFEvWILKoy0n3bLhvZcjy8FEl2TcrKp7nkogMN5HYVnN2FAsD213B14C5lUA?=
 =?us-ascii?Q?BTdkJ+2uI7Ox7ed+P25avWn+Yh30zu9DcY0cWmD1OuBq6Sf1GYDVl+AIOD3h?=
 =?us-ascii?Q?fISRcXOL4YuOzadzrLNam50nuR9YZQw/dVKbACWMbK7a+ElS5sMUlBrQfHZv?=
 =?us-ascii?Q?7TjY9ZvUjZR+g+F/w5Wsy89+c0fHTcKopKb9AsOquQ957wiVb8NNX6McfazF?=
 =?us-ascii?Q?wWvflVNcg0QZ2KKqDe6to68xqY2evmd2NMbcIbVaM1DL4N5z9frYjnIOchMs?=
 =?us-ascii?Q?hKVaTejgnItnXR5B4GMNe+6e3H/CzIUSSCRi90enEDmIgShNqG24erj0Q6NQ?=
 =?us-ascii?Q?GC7Ue92/8QXypAeGV9HbvyLKa+WaSUuoURFqOlf5c+6BrmM1IZbj4ys9q+n1?=
 =?us-ascii?Q?iYPCFkr7/jiIfgipMnz4ZWLh8DnPnqFDsosU5k7qWy2uINvX5JlhP2r3x+Kf?=
 =?us-ascii?Q?msYRxgBPCCNiih7tGpFWqMbn07e2BSmoS3tGVRsYf4KBSQiEFNAO8ko8Ok10?=
 =?us-ascii?Q?qWrrREQc7TRnpbMc9YVuGV2r+OoYr5e0afnZ0ipYldCEfjor3vpBhmDbbIBd?=
 =?us-ascii?Q?QmHXG6efbfNU9E6PVEEVEQJRSs6BORVfeWJB5DCdV5TIQwlPbawN8bEphOwi?=
 =?us-ascii?Q?xqHHoWfqNbKovpdSHTMMNfKQqIg0U1Y9SHml9k7HRqnICmFzKiBO1fAMecRI?=
 =?us-ascii?Q?7sKgcDiLO1f8FWxlrc+dsMJZ/OTO5c3ANQvM+BV1Bizukz5eQ6nBfRtHPMob?=
 =?us-ascii?Q?keYUk5jlgEpAwe1moThTTBZrl7kS50n5sdJ08WUyK36NuG6ykTJaggqDUyuE?=
 =?us-ascii?Q?EAln0xHReQSLBF5g/pbnhSkz9LyaF67IJG83fLq6aOwMALAiflT2QrZ/cz85?=
 =?us-ascii?Q?5AwMJ7GR6JAZZtmsOcwoXLHhAAha2QhSzdmjLfs59i02tECIbaWWsu9TRAw+?=
 =?us-ascii?Q?uVTXqo3D359mXtodjaaRJFWcKeqRnnP8lHOniF5KhIuNuX4hpLQcfNWWQZCr?=
 =?us-ascii?Q?S3QA01mGYqeesfemo9Pe1mg6s4UnRG+XjPHeecsI5E3UPxOYUISr778Mp/0/?=
 =?us-ascii?Q?BqNmFt8stbzAGJgP6HFByb0N/eCnTsQlrSV39RROA1GfCRB0BcuQ9pDCBrbh?=
 =?us-ascii?Q?n6/kLaI9pNf4WElcAy5mPsq8aivM08oz8Au2DhgoPgsAFBE0H57a9XrEa9ay?=
 =?us-ascii?Q?QBd1gEhKBqLd0H63F8JyTENKIwR1wR5lI+MRtYgkF2qFQAG3ie0lhGJJuVlt?=
 =?us-ascii?Q?stI=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb3c58e-bd35-4fae-4b23-08db05c41b82
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:53:23.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB1919
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use actual CPU number instead of hardcoded value to decide the size
of 'cpu_used_mask' in 'struct sw_flow'. Below is the reason.

'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
Its size is hardcoded to CONFIG_NR_CPUS bits, which can be
8192 by default, it costs memory and slows down ovs_flow_alloc

To address this, redefine cpu_used_mask to pointer
append cpumask_size() bytes after 'stat' to hold cpumask

cpumask APIs like cpumask_next and cpumask_set_cpu never access
bits beyond cpu count, cpumask_size() bytes of memory is enough

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 net/openvswitch/flow.c       | 9 ++++++---
 net/openvswitch/flow.h       | 2 +-
 net/openvswitch/flow_table.c | 8 +++++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index e20d1a973417..a56483eda015 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -107,7 +107,8 @@ void ovs_flow_stats_update(struct sw_flow *flow, __be16 tcp_flags,
 
 					rcu_assign_pointer(flow->stats[cpu],
 							   new_stats);
-					cpumask_set_cpu(cpu, &flow->cpu_used_mask);
+					cpumask_set_cpu(cpu,
+						flow->cpu_used_mask);
 					goto unlock;
 				}
 			}
@@ -135,7 +136,8 @@ void ovs_flow_stats_get(const struct sw_flow *flow,
 	memset(ovs_stats, 0, sizeof(*ovs_stats));
 
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	for (cpu = 0; cpu < nr_cpu_ids;
+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		struct sw_flow_stats *stats = rcu_dereference_ovsl(flow->stats[cpu]);
 
 		if (stats) {
@@ -159,7 +161,8 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
 	int cpu;
 
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	for (cpu = 0; cpu < nr_cpu_ids;
+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
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
index 0a0e4c283f02..dc6a174c3194 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -87,11 +87,12 @@ struct sw_flow *ovs_flow_alloc(void)
 	if (!stats)
 		goto err;
 
+	flow->cpu_used_mask = (struct cpumask *)&flow->stats[nr_cpu_ids];
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
@@ -1196,7 +1197,8 @@ int ovs_flow_init(void)
 
 	flow_cache = kmem_cache_create("sw_flow", sizeof(struct sw_flow)
 				       + (nr_cpu_ids
-					  * sizeof(struct sw_flow_stats *)),
+					  * sizeof(struct sw_flow_stats *))
+				       + cpumask_size(),
 				       0, 0, NULL);
 	if (flow_cache == NULL)
 		return -ENOMEM;
-- 
2.27.0

