Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C95E6866C5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjBANZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjBANZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:25:09 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2075.outbound.protection.outlook.com [40.92.53.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DC835A3;
        Wed,  1 Feb 2023 05:25:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+ihNt6InrXocKZz+7iLUPhxqH++1QmN4up6PxlSuyYpmEvkf3XQwZB4LDxNicvMWpcaagWG+rDXu7W9aYyVhlbL+xBoLsJ3CDmvomvZ8YTAVFrtTol5/Vh4BRagxbiwNZm+jm9RDfzT8L2LQtkYGIwe9uhxhW9r2ffv3+Az8r5GzYBfTO3Avei8Z+UznuzRL8K3S7Gi2SNeeWkHsnSWIERyJSjlifSdsYsdV1UcKy12WIuDIN+WpjZH508XHJpFmppyZZGPCKfS8tB4RqbyaFjswnYbByfh8W1gyb1vEFrxeUtLqCv4Wp36N/n7OMUTLLrSrcCmAfJcE83kPp0t1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dqeX7eeMtwcIhbTKCp+MHOTinnUmHuAu7G2bJktK7s=;
 b=W57K21kwbS7MTKF9JlQUi/RlwUYsFt3/JE0Ai+rhE+T1KP264cOKtYxY6CtrpT8dx3FfqXDpUBZ+VR7G7tS4+M+Md7ApHqntvoSc+VPPxMn7F0ld4o2Dq/tFpM8kAwdV0oOtHRC5j4acLSKe3S4ec1L33r6kpcfFCyE18/3CT8rUkBsfuVEn/CV3AGZg/L4CvNkUE/+1XxuJfFQWNqAZOLIbRhnaAmhpFlM68EOsqKAW0gy4BgOhbTZui+sQV4XlfTMif0GIcH1d0jKQeT477K0jSvp5zB/5INA5K1lA0yDaxnE/ttazhMPVmDzBBepEoYYbAhoPKe8+wUJFcaBo0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dqeX7eeMtwcIhbTKCp+MHOTinnUmHuAu7G2bJktK7s=;
 b=bUWqrHfcqX81EiKuJ79zxtH/TRcrJem6CBDwUnViVionDzjgJeHxlTco4IK/+REN+hu2HYgQBcwWUILyoQutdikjQFydBRYPJwJ7uZmYsgfHEqUDEyB3Mkp1mhJDwEOy/aNEzp65Q8aquJmzsIkuO4+a9GlThkugL7UeFMIFcSFUi9qTC8+YGV/Hblnx17Li9Wvr0NLV8yiyRjHw0novt1fX0DC8SbHHNt9Lng3EXFTG5ZYzrE5amO+kmIwZ87xU4K7XSSxYCeZKKZpGPsPIaqodlKLDr5WwWJsZ1vg7mUO9MRJZr3/Use6AP4lOoXcspW0DFH5hMBscfuuSpljJmA==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OSZP286MB2240.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:18d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 1 Feb
 2023 13:25:04 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Wed, 1 Feb 2023
 13:25:04 +0000
From:   taoyuan_eddy@hotmail.com
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] net: openvswitch: reduce cpu_used_mask memory
Date:   Wed,  1 Feb 2023 21:24:39 +0800
Message-ID: <OS3P286MB22954422E3DD09FF5FD6B091F5D19@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [sUPTXEReOI2Zv76tiMz6U9PNd/i0p1P0vOthcSmdaXGQgc/ubcmrAvaCcH7uEjn5]
X-ClientProxiedBy: SI2PR01CA0052.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::11) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230201132439.709236-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OSZP286MB2240:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d607598-99fc-4a9f-fa7e-08db0457ba8e
X-MS-Exchange-SLBlob-MailProps: q3cIJLDN2c+w+CziC9pPzGUhn8kCPPeB/KSK5v8pj7EaaxuGM6Oo1nIOTV8oCtvE9xWchWOaTlVgiKKM3+OqkESLe7iHZxOyBTZrNkm0XkDj7dmp/0i2WfYPFEzoQSJnjOmdX/ftxNLc1lCJ2qn2Kn4goHv7IvNTcaqJIsBZOoiNyM4wbmLx+Qm3dDxqpz/4BHhXq7S6Qjql9NnLPR4z63mjmRCOCD2IdXJX3C+VL5JkcqNZbfkM0gy2j/trp1s2I1IHfVLyFhGthP1QyU3YC79gVt4MbY6BATKxx4pXJ8nBzOZHBQO7pusbJyD7ARY1yxXrMTdzdHQ40J5CvBaHiKVBcYWlgRrRafz0w6LW36wubxYgDfA6czNL1OxlY+J/d4sfzTl9gepRvmIGsGtlfCidE1k7Xfo1pjgFdUT2IdvdTh8zRdEzx5oDV8Xgh8ZgShvONy1nAEwBY51fN2/3Gus3MWJ5XBepRpKy7Fkzz8GahMn6pUu8uvg0QtAjRWR9vvqjM21MmcGLoTWYv7M6IWrnmOe11gcdORZ5KtuQeA4YplkwpEsvK2xrtkLEny1pRLEgxuQQbJKXbJazZ0uI6N0jW4/CG0bIuWbi7JRq9tbidT61yIL/waH5CCt59F4GErSsTugy951GAW9rqFAyTIfyQpXSlwfT04HvK1SBOtpHqju+/NkEgm14VU7i+5k2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/zTEz8X29u83q8N/dHl1CJMuny9If4um13e+0xmq/8jPJT0e4m4wGYQMFjYyxW3pXUI1GTpZxE1LuB1uHYWorqsK+O4qinoHWoZ1x9b3eTHMLI/4JnsK8lRb6Zrj4oa/E1sU/0aAo1K0/z+sUXs7O9PrHh2IsT/zL/F9htkU/8sm6bon3+z5V1EC5k29/oEM+YGRDiXAz/ldqdorZW4+R7AOT6CqUGqLstA1NF1UBgu7xZe1FZj1Cn26CeDKMdZdbQ0FrUWC6bydo7548Xr6rVRXo1iD5DFPOZqY4wAJ6KrUpzBOx31UaiHNwt6q3zVzq03xlADgnwIhg8xismg56oa23XFu4SByAcRD10wKkMuVznKVoiA2o5yAPCQtIBPncEF2gH/jSYHKOhj7WcSE0+akhWFOVEG/9jRBOeMtL3CBP9wRlmF2gFjl6up3BQqzj5ZgQvUsln5JbfZ5wiyCqUC5mtQzUAzcb7i4SD00pELVPSg4/+cGsyM9GLvIE0z8DJwJTmquEC9zG03wcmr7+OEB/08YbVgb9/MQ3AJtuow6KO3SanfQq5Lbw6QB27slZEwDDMSGdxg63tck7GU3OVm8EnEja2AffM0bd2vlP9jAK+RNInjSBu+FB+lE7B7me+9/7jx8MweOYUkmaP/oQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q5yzcilvru4Atwlg0z05XA5Uk+pNZIzbJPEEZ3ZyJHvdjDJ2uTAPWyrf8NOq?=
 =?us-ascii?Q?+5l8DuoIgl8IUM3MBf6f+YmUwEgLExqIcqonQ9esABx8YzMfd3NnqKw8ulPZ?=
 =?us-ascii?Q?BJTy/+qINDoAsQBHP4nsJsT/C0qVjK6loTgl+9cPA16XVvet249VX6HbSJT7?=
 =?us-ascii?Q?xTDmmoWia6SPi8GN1RB36kqAN6w0mDwY0kOR5brPQgejlLgU5Jyh8671kjVo?=
 =?us-ascii?Q?Bl0/DrSTDzFZKtE4VxAlEhtgfrWlpaxPyCTdK2hvSap9vo3nvDouGHU0g4QD?=
 =?us-ascii?Q?SUxn8IsPYmLLTrk7Rd03BwAQ+8oE5R3ksEPEj7k3gSUpVMqMhJlav61+v1OB?=
 =?us-ascii?Q?7wpqb5wqsLc6fnYmPDpUcuUcbZFV8osCYxHVLrqTne/PrG16H1ucI4E7fFdY?=
 =?us-ascii?Q?RndpM8tKH83gRN4Mqf/lDzzU/st9mCaUCxA0Mb5miHympPTJRbHrpe6/sNqD?=
 =?us-ascii?Q?1B6RC6YaeIw67xqF6/FTAGGyAR5VMKkZKkqEcGLIv/OLF5EdbSnoyJ9jRfqr?=
 =?us-ascii?Q?P0pT8jX5aPBYZUSUSSDNEBzZOjiv31SbLTufMd1DTFeF1XLaW5xCwQWDXrlP?=
 =?us-ascii?Q?wNgbWaBmFJq2wPqsiRoGESbRSzZelrYpcKKS2IOB6CT/X47OauXp/zxZEYNA?=
 =?us-ascii?Q?BVNfFVjyytFr6e9KFIqSVhiBahPtE5AWXbo1fcQ+FHUlvGk9bwgyx3xib12x?=
 =?us-ascii?Q?hfkDyBomMebgWxlBGCoynm0OGp1qYQRYitFTcgFoBshtd/FqPDQHPMqE+Ou8?=
 =?us-ascii?Q?fv1mYmF5lxAGMpHqIs7NgHrW8Rai3rvJM2pvtwrbwGR5gklPiQq8kTRwIMce?=
 =?us-ascii?Q?t5+x4gn+bDBvV62bVoY/vx5gUYwe1+UacX2ymFs9SdvzU7BdXcAvvPTb8pjr?=
 =?us-ascii?Q?q7VvRit81jONE6wQueRRfPytpgJ8sdd6DWJo+GmQi4rTicGwQLh++W/Asu7c?=
 =?us-ascii?Q?hMn5jmGNR8HXzQZCUbKsRgqij93CJxucFHB/jjcQOPw59rSLMyhU9s5EKgqU?=
 =?us-ascii?Q?hQlGFDPSFb5OOVruIMwJiOkr++G2pTR2UVu9AS3Sqw+zcMA6G+8pFAM6o5YP?=
 =?us-ascii?Q?pBVMTvepH1+39yiqDlnR5r9YDMjuHwioMoYvkxPUXbOCCs46hcG8NiPa7in4?=
 =?us-ascii?Q?Oo0IiRuhhpnWK/ZGrUmtoMc4nTDywf51BHwyQ4TAzGJfcRhMNQVrmcIruWkP?=
 =?us-ascii?Q?zsKqIuPHntubIe+EelsGEFAn0NC2qu5ZGDN9GxHvgEt1bFiuOglOs9KD7h7z?=
 =?us-ascii?Q?zKzFbw7Eb6LZrJfrQkkDrErSOqpf3G4Xj0XFVpZ1jSfYpq7b80fwucJzHqZb?=
 =?us-ascii?Q?uB/tBPjFsAEuuRSx5lnbMNe4VAGFzM8svkZWWruxYAwsNA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d607598-99fc-4a9f-fa7e-08db0457ba8e
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 13:25:04.4780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZP286MB2240
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eddy Tao <taoyuan_eddy@hotmail.com>

'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
However, its size is hardcoded to CONFIG_NR_CPUS bits, which can be
8192 by default, it costs memory and slows down ovs_flow_alloc.
This fix uses actual CPU number instead

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 net/openvswitch/flow.c       |  6 +++---
 net/openvswitch/flow.h       |  2 +-
 net/openvswitch/flow_table.c | 24 +++++++++++++++++++++---
 3 files changed, 25 insertions(+), 7 deletions(-)

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
index 0a0e4c283f02..63c95c9a814d 100644
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
@@ -1194,9 +1195,26 @@ int ovs_flow_init(void)
 	BUILD_BUG_ON(__alignof__(struct sw_flow_key) % __alignof__(long));
 	BUILD_BUG_ON(sizeof(struct sw_flow_key) % sizeof(long));
 
+	/* Simply embedding 'struct cpumask' in 'struct sw_flow'
+	 * consumes memory unnecessarily large. Cpumask is an bitmap
+	 * of CONFIG_NR_CPUS bits, which is hardcoded in .config
+	 * and default value can be 8192, in this case is 1024 bytes.
+	 * It drops ovs_flow_alloc performance and cost memory.
+	 * We should use actual CPU count instead of hardcoded value.
+	 *
+	 * To address this, 'cpu_used_mask' is redefined to pointer
+	 * and append a cpumask_size() after 'stat' to hold the memory
+	 * for struct cpumask.
+	 *
+	 * cpumask APIs like cpumask_next and cpumask_set_cpu are defined
+	 * to never access bits beyond cpu count, as such above change is
+	 * safe even though the actual memory provided is smaller than
+	 * sizeof(struct cpumask)
+	 */
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

