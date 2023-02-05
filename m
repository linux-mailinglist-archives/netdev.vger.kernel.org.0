Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D7568ADF4
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 02:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBEBgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 20:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBEBgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 20:36:01 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2031.outbound.protection.outlook.com [40.92.107.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801DD25BAC;
        Sat,  4 Feb 2023 17:35:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4+SeaRbhyoWLC/ig0pAdLRQwlhqFKAKRJSc0PXPQsKC8Wg7kxeBQNfOvJ6A5fSEkUzdN9RJAg3JiAxZ3bAl8fZiXw7hs71Lh+Vg9lQCtX5eRT7XPmUE3eyWyvvDpVTU2MT4Ghltvoozj1PaT8G5DMrWIbBcJxY4v42Dbc2Vf6oKDDGYzbw3F8TzGO6EHHwNFTm7aUL9Tu8CotFuWfbR+JyQHIBx8jqTFYnb+ciuLo+1M9cECEGZ1LjtZgL/sWxcljvJQn3EgoExK2F5VkrTtqIKn49tEwvZM7TGTccbQZjEWUoy1+roPZkPAdLvZMkkHFwFJbRDAQkb2uWRBCyBfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKZLFc/t2D9XrbfXhQ28wRl4ClZtT93oskhVozUe+50=;
 b=OHfYTh8ZsVL4WF2jrjhudlT2/Us00x5SaNNkqETwlpoG+8qAqyvFyasJQ9BPhfMjbtrNGy3+IJ1L+lU2IEyxIlfVPTO/jU0uwNRXI7iQFGHPSD906IqUiOqPkHCEM15DnIGFvIWaIKR7NE3dYOFEoxYS1MFPRJEW3lrsMOuBLGth0v8vcbHVi7dS57hpagpCCsUgrfxNwiVSz8QMkaV97uiU6rKAydoy0/BTwpFsTdDm6gqi3E/ktIanTVXq+WPTRITgSlD6KzW52/x6l7ohE9hHIzNHJobx6qNfywlDo1ujmmoWZJWROB/t0ni1YIYahK0u4NolPQODYlYFKOoZ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKZLFc/t2D9XrbfXhQ28wRl4ClZtT93oskhVozUe+50=;
 b=cm6jWj9Bk8t+wZ+4o5w3e8rlyvz6nVMfKzn7y73oAwJr27+r85U0P5Br6jueHav5fium/8IPdReqDP7UeyCxowalNxU6rWnPr+zCsXLCu81BRLoiBk8dqp/m9za2uE0dxRFr5DN2cTE2VyevauHsdCj5eCvDEbvCx3VZNSvh7g1ETsu68doKfdWEU0CoNlv21Uio0uRGsVVAnQ/IEFGxjUX0WVDute9CyA9rd3mm8ZAAXqF36oB8tfNtAdXU/ofzQdHOCujwgzqRSbfqv6ctsA3zuw6IQqh4QQYSt8fmi8NeDrdBVizh6f7I+FHb2I9savOLzrk37nTqTcv3e1iicQ==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB2264.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 01:35:55 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6064.032; Sun, 5 Feb 2023
 01:35:55 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v8 1/1] net: openvswitch: reduce cpu_used_mask memory
Date:   Sun,  5 Feb 2023 09:35:37 +0800
Message-ID: <OS3P286MB229570CCED618B20355D227AF5D59@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [KHhGriF0l1AvV8iwT+yKmM6A24N0SrQn]
X-ClientProxiedBy: SGAP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::18)
 To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230205013537.339783-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB2264:EE_
X-MS-Office365-Filtering-Correlation-Id: a2062e4c-4024-4fa6-4fe4-08db07195341
X-MS-Exchange-SLBlob-MailProps: WE1/0xzO5cJqTbEO6Uk/eGk0YxoojCZlkozuGjstigyJMNcp6eooU08U1kjdHKL416S/9p7MEEt2juxb8AeMTrMSWC1pRP4MgZg62gzo7rtp5CMMu2LLVAC+REsixmA6XtDcIGK47SzASq+LrVkGZaDOdB7r47cv7ZXUkBCjkH41vPEkTHvjm2QE/G+OLo5uLLGMPQdl6MVHf0xVm0nQLB8kJc3+kTW4zxz+imZfs4i8fIq7MjBhlo/gEy7UMPc/uV4otDw97LQIhBwvRtFEOnB9ELoHfI7foj7rUe+yH6csvvKbBilpor/lAldcGNhSqhc8+0D5hJjkv1kSTsxc8C0nD7fD5IBrgAWKW/oJUuhlMG3cir7lhnVJaUZ6nYR0RN48CZnD0WbJK5c1flOPsvJY49Kqwd2o55Qzi0I2mQPdVQNI/T8cZKcxuDoJ7QY3lt3mb5S+AYbnE1Iz+7HypvOyy8uRZKmJ6aDFSClVP2EVRz+8a7UgIxIZ2VV4vs22Yrcc+FXPwUUqcw6X/5LQlprhOgqW/SezrZKgkvO/KOBj5qZvswZNQT9bO63SKcCmUpc6n+OGoz8wVyoHp+kz+kykt1+XSyvt82s33TvXDx9dspH9znRI57DB37tTp6j1+4iZr/VSJIqSvqKKJJ/D8C+2qCXH9VVZWP+vsDp9Oo4f6cE9tP87vjq25hgnVEQLeA+zgGdf515IEuKBaZRfkIbOa+6S7VY0+3VhUi/y50SwbHQfK7x13Q==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kf3A/bgwgs/kAug+nJ4BQuYfRuO6S6KffssepeCThzO6BYwtyQ819DN9TAD0m0uy4J/MCL3O1hRTt5J4vxCvYbN2oFeudHg75DZAfbS7GQROx0JFkBgU4MOeaXGKNn30lLMWkXTbXk+JmOAdsPhwotwddyk3XP1t0AZMTK8HnKeSqZhO5f3/rX+RIiS4+l2PUUvnZoomK+uKtbDR5Qz/2hCWtJ53AaWhqaXPYT6i9bwrBEw9BUyVRRVGeChI7L7U/J87zv3uD+25ySvbj3QKlxiLO9oAXeRwAw3zbcW28BDv91/Gx+lwcchi7rF812Wq5x5hfFiOC5ngbudyML7qvenh2spOike6MQ5DVZHVCSGGmjLlJkJPlltXOv4OxKoJlAxHz14kRMo9m/8NTGsy1lm+kHtOJu0K1YUOt8kvhEDiWKJV2YTNPonVOIMSrlCLdvR8iSEAqfmxzkcDl0E9xbvEc6HF86kjkUT6ECOLFtnhN7yp+nAgnoBbeK8VXrRBEIquYmN0LnwXWQVRPl5WBJmL1l3MGaOVmSvCS6RiIqdOZ+N9mp2sFEAx0O94zdFBguCqXQlSUTvZKZ975tlU2AdvaXETBQwi7sg9USyF1Ts6sBkN9/Phr/GHSnFjbDRPLA86HjCPf5bH3aKkKFi8cw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lszJUn4LKUS3O3E3Xaj0VIxuQyQnL+gb87SvHl5PRV49zVMvThxchgscXKoU?=
 =?us-ascii?Q?uN1kZ7Kr6Rc8wLJW7fj+sbaXSFnslTxTUXESZNddGMOJ52IVnMYQCuWWXm2s?=
 =?us-ascii?Q?HTVt0HtzKdp/0GyIjYOzdSytdXIvjR7yHQKymvZLOIwAG4ipfx0AeniaQH6m?=
 =?us-ascii?Q?8x2xPrL8xn8ewRGnynKmWzPPu9Z0PI0IGmqNJ80xmm1aq0CJoZT5F6HBJFia?=
 =?us-ascii?Q?z6hN2FXuqCWbK1f7f9wgmFSPMbSLBRc0wl7CxBqijXA2JZQgdl1LUKYwHtcA?=
 =?us-ascii?Q?uDSPaVk4Acsi/kdfGAC5UOQUMjWkGKzc+NpOfRpNrxtHTLzJ4AQMdqpByZAK?=
 =?us-ascii?Q?oQkOEqpdJKGt6BFjKp7CxukAtnK5QPCGAsKSj0ndWWagntUp8PP1X/0Je9QA?=
 =?us-ascii?Q?bxOjPhEr3aSfwIref2IowNVqQva+4+6NfMfXNyjibtZ6TEweKxpJL8Ayy2SL?=
 =?us-ascii?Q?6hk6zT5gLikUSpJ1gPNPzKCHfLlJiLO2AefNKatFx5MjEC1GIt9UZIddKURU?=
 =?us-ascii?Q?Hb+kFj9smYQv3z1A23lywRIWqpHVKNALYI3wHX1ABg+3CDmX2ER0M9fOFRuT?=
 =?us-ascii?Q?gT2iobhrfB61Dqk8Im93UfK25+ABcsATU1hFaxAB/bsJFiBZv2hOj3WhveT6?=
 =?us-ascii?Q?hUC4nFkaowsAcBnDrDX87P1tAE7Y4wJBWfwo4A9SIlF1kTM/PGyexMzCcTS6?=
 =?us-ascii?Q?WoVd47nCnStuGwk/i32LMsNrGhU+9nZxuETSwOkwmA/3PcrsaXPQkNoB4ims?=
 =?us-ascii?Q?bJe3QRxh8T7p7oG4YM9QNbsuqytj4Oyg1p4Na2dwuMLf6s6bzcnDkBbTzk5D?=
 =?us-ascii?Q?3MgaoomuEIkhNIZTzOpzNn+uzoOsW6XJTN60NOGyItTFkuEkFi/rvs2JKu0x?=
 =?us-ascii?Q?zcc1MQwe04C7E2GgtsVfcdWcU9R5YoK3ofM1Z5Cq+LR6OWRTCxSfW1HZPdoz?=
 =?us-ascii?Q?ezq950bsddqBjzpd0WGFiz/7OO142Eo05KLquyHDYhTJq0IeRXhWMrWGCmtC?=
 =?us-ascii?Q?MDGwUbF9dQlgEGuf8Oxk3vnXHdrjm6cJDGkPTee7AgtH+P2UEz0jfnzB2Gdj?=
 =?us-ascii?Q?t6mWn/WFvWjgGunX553U/Vpu865Ujq82yf+wGrXG4twkOKBe5+4o1lPX8CAj?=
 =?us-ascii?Q?RztbBYHFs9IvasFg0TK4y5MsuvSHzg7F8LMwkODv2JUy4LilsFaW5xdQ9s6X?=
 =?us-ascii?Q?rsXmUl2X4fekOZYoJX8pw/aSIUmo7FeVJwdhSQC5j7C2Tz+R+6athbiWSXOJ?=
 =?us-ascii?Q?6le0R++S/SgQKAFp8nisjRVGRzSQWurUa+SYyq09QA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a2062e4c-4024-4fa6-4fe4-08db07195341
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 01:35:55.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2264
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
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
8192 by default, it costs memory and slows down ovs_flow_alloc.

To address this:
 Redefine cpu_used_mask to pointer.
 Append cpumask_size() bytes after 'stat' to hold cpumask.
 Initialization cpu_used_mask right after stats_last_writer.

APIs like cpumask_next and cpumask_set_cpu never access bits
beyond cpu count, cpumask_size() bytes of memory is enough.

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 V7 -> V8: add blanc space after colon in subject line
 V6 -> V7: initialize cpu_used_mask after stats_last_writer
 V5 -> V6: add tab to align the wrapped cpumask_set_cpu call
 V4 -> V5: fix max-line-length warning
 V3 -> V4: no change, sorry, my bad
 V2 -> V3: add 'net-next' in prefix
           fix max-line-length warning
           remove the comment
 V1 -> V2: make comment imperitive
           remove unnecessary parentheses

 net/openvswitch/flow.c       | 9 ++++++---
 net/openvswitch/flow.h       | 2 +-
 net/openvswitch/flow_table.c | 8 +++++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index e20d1a973417..416976f70322 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -107,7 +107,8 @@ void ovs_flow_stats_update(struct sw_flow *flow, __be16 tcp_flags,
 
 					rcu_assign_pointer(flow->stats[cpu],
 							   new_stats);
-					cpumask_set_cpu(cpu, &flow->cpu_used_mask);
+					cpumask_set_cpu(cpu,
+							flow->cpu_used_mask);
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
index 0a0e4c283f02..791504b7f42b 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -79,6 +79,7 @@ struct sw_flow *ovs_flow_alloc(void)
 		return ERR_PTR(-ENOMEM);
 
 	flow->stats_last_writer = -1;
+	flow->cpu_used_mask = (struct cpumask *)&flow->stats[nr_cpu_ids];
 
 	/* Initialize the default stat node. */
 	stats = kmem_cache_alloc_node(flow_stats_cache,
@@ -91,7 +92,7 @@ struct sw_flow *ovs_flow_alloc(void)
 
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

