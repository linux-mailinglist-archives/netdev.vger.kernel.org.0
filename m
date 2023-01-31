Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C13682E8A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjAaOAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjAaOAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:00:00 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2091.outbound.protection.outlook.com [40.92.107.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777775FE7;
        Tue, 31 Jan 2023 05:59:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoFdaADBYH9y4upGBGbV7YbMRyZ4he6KgmZoj1IFvfwa/mLMktmueBAisJmSh4BagGV5WE2SCcRE5X9445DAU7NtN15rI/4mf5FYCvo/34ptofGPlqROkPDkQQHZXHmvU5oUN7YT21miAXibYPnagBmtGKBOmx3ngxsW7ZKAhPNuEPce8QVFAiQgRV6acn8SerW21Kfjh1Ai2LP7gVrlprqqAkpRcPvaVtt1kFOnUJLXS/e3PMf7dQlT/vkQEkFZqEqoEA89UbjxxNANCWKjE04NSn4qV2rGfLlC4bRQRwT/v/kLzNcK04mik9AjSoUgINiEbTqySoHyPOTRG2SyJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZ6rQ0LFqCsRAwpjPQN3PskuqAMJihfP438gksUBkpA=;
 b=YRvTYdGOu4rrHw/XGtVX+Bwyuk5X0denBxMRwvY9FuIAU9bkEEW+jHwHQju/Nn0kftJSec+PNsVaWcW4J/JFan/Z73LFXc0g5uiH9LVh3blsoGz4XQhdlq7DkzgqxiDucB6wdsz52DB1aGZp5rlTqdMwbV0zHbvJ2MTzsXPECK7Yq46kWDAgZr7dJrMgDZvmk4YslPYbeMWzj/TBJOPdQ+mm5dREoAhbrfj9HKDtStj/YjUwjPsW3x3io1Nd8ZZyXiOBDuOpCyX++Yyf4QTNIAw7csj1hvLu2z5smggjoCAaJ8ja8+AavgX9eFiWq/zs/b+B7e1eexnCTKO1kY93/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZ6rQ0LFqCsRAwpjPQN3PskuqAMJihfP438gksUBkpA=;
 b=mECtNeqqHrjlH115Iz1aVKahZ2kwWXFPs5NBVsRdpafAMnS6TOeYch7YBN8+jxuFjKAO/m4udHBmJMGBPX09rk6Ec2FYsKTdebJ9sWSwdO26hSGaPhnfd6y57AjgiC/E0t3hsrpzPSZl1jbEzNh3quO84vSj6h9atsQGR67XzXNI/WiPmNqkEwqa2g5b3bYDSvnuhLSXIzwoYBuuaQrs+5XsNimoQ6Twy0hqh3F5c/qvJ5u1dvm/UJggWMB0uY0j/jcPvxSbVRly/Kr4eZJgOWbqEBW4LBXJ5CEONfJT4yyw+iQpRuYMUHF8xV2b6hQ8Bm9wUBPyriyKw/6sBRFL/Q==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OSZP286MB2269.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:18a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 13:59:56 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Tue, 31 Jan 2023
 13:59:56 +0000
From:   taoyuan_eddy@hotmail.com
To:     dev@openvswitch.org
Cc:     eddytaoyuan <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: openvswitch: reduce cpu_used_mask memory consumption
Date:   Tue, 31 Jan 2023 21:58:22 +0800
Message-ID: <OS3P286MB2295C30BCD41592C25805136F5D09@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [K6qdMsHffJ9eaoHYt73mUuTZb1s8awWLBRRiDU8qkbleIigINddMNE3QQ6M7Z0Ku]
X-ClientProxiedBy: SI2P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::14) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230131135823.390249-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OSZP286MB2269:EE_
X-MS-Office365-Filtering-Correlation-Id: a7bb523c-e1ec-4443-cb0d-08db03936f26
X-MS-Exchange-SLBlob-MailProps: q6Zzr5Fg03Ht49wMEz40i2N/NnYAXb+epVakThJqCTMDF64i4WfcTmd9HHRWqC/slNGnnvaNizRJACkftMMrp/grLV8aoDCi2y2bp1qqZwF1ebOHtdg6TzPwE//WIEI/2IDWSQTmQ0E8HjqMwy1bXz6JMCn91y3s06Lx5uL64XYWvBUar5SCHJnnFkANhqW0azcpdj6+Qz6+uCkCqSArw9Maf4EWmMMNmHJ7IqmRCmhM8rawTZMnBCu8brJiPuWfwHMvKvtsO/yMpNEZhSE5Ftd58XUpnse2lvDPhb2P161ihmCV+noDhtSSEq6cvG0AMTTZ98pZdQUr6FZLe10c+LydumhjEYatgoWMSzYZ03xEWEsLr89Ua50IiSUyTegSUVs261XjRR7+rPziYTsyWcGC4nM9rdGqyrJm9++qfi7uQ4u6ILxwaGHiavXKjKs9yP0fXVAVIINCAK6zwn8nZAhzuJ5NMEt4DMuKrBGb1KRvxxp95d5//4hv/b180qQUeIltdtna4XrHyMb5JC1KflRAZ1z9XKlYKo93hNCO8L4yYggb8TBX6xGKAY1bFCWx/7IPHQ4CXbVFs+OIt6g0cRCe+ldK2xdyfC19jC3Jt+1/DjVWccFBdkf5wtX4Osw8tExoqqjnvg/osSI4mJ5aP7W1EHcLrEeOolBvLadp5yGBCS8+isk7AXyiT1YHoeMk
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9CqEkbW0bVRpN074RUxjSla0QsKJpJ++Uo2na1hNTzzyhDfPV/VgmURlEE2th8iIJyPOnYLvSC2OF0uhD5s2FBVe+AdqNJw2L063XBns9FQ3T6w7+zC44wZkhObB4+7CpyPHTP6oKQY5WWLUurMm7W22SToZ6x0sgvmP8r5+HyNpTXLkjGLt3DfA8J7knhev07YPxmiYtgEkC0IB9LVg6lpliHZFgtjKjjwR9W6g1BfcRIbm4MMiursKQ27Se6I7a6C1koeBKxQ88Zb/j/dny/7Hmcjq+zc+urjuHD++ewqJkZ6wLZvQrq7GDCAGvzaUnAmVAxDa2aY9iUTtviaS5Zbs0/KdN7EqKv9m6f8SPWEdCg8nO2L96gYsyFtFt29Pb+OMdZNxcyUNjjCTof8afHzHDZ/HHUKdFFF/k8RLgb6HQtSqkNKI+AOOffeSGVJ8ujvjfAtYXNw4MgPyWM0BEhlscYHZH5teLpb1BUroL+tIAqfG1lf9M4tiGLJUTjiaRfkk5xntVAXnV+qw3mafAVZyjCcF0uE0KzOZzhwVq1RjNhd78/B+3BPcX2hQCYZodNBwVqUnU32gTTMtQg58XToM7qSUoI1dG/WfcunKcDZA99Zfa/5BY/Oplr6YQWhyrQGkT4F18QwFEdkaRC4+A==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A6Mn51Mj6SzskmLwtml/jkOfxx1QzgjfztXoe/EnviyieTWF9Oh282r270FV?=
 =?us-ascii?Q?HHlE8VleVGtRId6d/d4MILOezqbDN99kcojKuZX65PjKy3a5gkWyku7Jv6bX?=
 =?us-ascii?Q?YlISGeTAEgNtoVDDM/aP2ikCv93ttp68SVc2JOiUZbR3AVNFUroInenY6xWd?=
 =?us-ascii?Q?BYpUNf6e36RXNr93jsG3AbbIEULrEsZl2FY8SS2vQcF8uyV48giTXGk7BYTJ?=
 =?us-ascii?Q?ZONu1xwTnw+8nhf9JyEAkVF//7a9iAUARWgSukJ/ZB8HB2WTdWtevXnDA2Qr?=
 =?us-ascii?Q?SIx9kUo8xg0/WR8ioSP+/Uy+U0zYGYTHLlff+BmLsBBO8/isHfhj4poYmJtc?=
 =?us-ascii?Q?tyUWITED0jOV/l7dmmoVOK9Lf9Cke1vHf5qfT2YwHOV2JgT4N3gj3gB0AQV0?=
 =?us-ascii?Q?ICmxakqi4mVV1gDU4PjtBLpheSJVk0lTsh4qyNaBCGtnR40cZGGxp87LmzVd?=
 =?us-ascii?Q?7H+EoYjOYc/HZPFRX6O4QrRUSfifzSeMmy7Qx5TgDmxfU01sNMauD6Ql5XX9?=
 =?us-ascii?Q?PP6XLRY9J/tkjUFTiPPsBKxX+FhSgdrS4MZ99GzOSAgs9cdYbofLIuw+cyNE?=
 =?us-ascii?Q?xnnX3z5X6AaKuf6qBkBNMNBrqEhYldK9ENFZjJQDQuaWq7YF+hPXKMjiN0dt?=
 =?us-ascii?Q?3TL7iKnJK/2psw1t3L494nbG2uMMNPT5AUfFwBurnLG2Vwf5035vUDeUqCdS?=
 =?us-ascii?Q?MUNbITDyGw7J1piMjd/h7Feh67vECl1obxR1itRxpCdyvDRA0lwCDtKz30g0?=
 =?us-ascii?Q?nT0ahhUM9grFgr+0iC0+nJBuLFdweSP3TaF8upRwPxS5LKZXwdrVoSr9u7xB?=
 =?us-ascii?Q?ARmhD7rdxY+ofzh9N3Cw+dVZjqUNtu4r8k2m4oj5U75L9LZTyPZ+p9sGW5sk?=
 =?us-ascii?Q?/2wNWDjAL5qudB6wJ6VzQDbLFqmfWFeJ/zt8nufHoPli+Um3t3wY56YwX0qo?=
 =?us-ascii?Q?Qm27EQBOgslqn6m7Cgpdoka4GMCmReUCWZgADHcHPqmbroQMeAFd+chzbE0K?=
 =?us-ascii?Q?aVQORtySun6+a2aqKgimDZJtoeb5wughL79jQJ8yzNDlDYmfFLoz9YK3eTKj?=
 =?us-ascii?Q?OWb3sFDU+qNcIewRcVS8dCluIvtb13COKuG5mhZjfHY7zxZC3XdOAlAbQ7vS?=
 =?us-ascii?Q?EiMm2hKq+1m693ZViLCkCrrkVjhp24CCCeSm3FZk/977NxlhkdbeiuAEgFzG?=
 =?us-ascii?Q?MDAyUtcVyZxbhcJ4Oosv6eIwYGS+N0UXrvF6MsF1ZJRvXnr/SdHkmuw+43FG?=
 =?us-ascii?Q?BYBU+/yS+3io7OqNClipfXC3h+W9BixNJcdSdGxOPP54gIqTl2tnI7b92P9o?=
 =?us-ascii?Q?fdt4XIE+xo7k4iXZiUHbClEBYmJyPYHfnBNmMi06kXxYqw=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a7bb523c-e1ec-4443-cb0d-08db03936f26
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 13:59:56.6695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZP286MB2269
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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

