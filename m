Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E3E687A4B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjBBKdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBBKd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:33:27 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2046.outbound.protection.outlook.com [40.92.53.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4384F84E;
        Thu,  2 Feb 2023 02:33:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfhKi5UXaO4tLJvqXXfQtyZcfuMwKTq69Wk8kNURbJJRaFrp6SRWbq9YIYvBcg88Rqtg6sIJx0r/+C5EkfUPGwn7e9v2Ksz/9WFaW49Mekos98PzRWnx7T1xppV57iFW575PYl+4tR+lAVQF3aWnT0wYn98nRUgW4pLVe5DCDMhMae4SfCqTFa4+O1sbPFChJImpPPrmzkjfPQO++FMzoq6SJamU0WMy+Z5x9jNURztXrLMgj2oNcOb6M4960TgbORqlq+OUW811HaT5cOiTVoX/tz3ce9wtgtX/UVa80TRBS1O+dsm/fstIjSsQQIQ0A6mb8ii5fPihBh/HdEPVHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lUtfb8l4DA2bdPdxSEGObdqBhScMP3nZP7imP1EgnWc=;
 b=lEd4BzFuXYK1UHvxznYK8iGo10AFs4jvIVULTaLdL11QFuOTP3s1Gqm0AvLPOYJbQorJ5sUNjf4JxT0O2uNCc5TUgavzLQVe74as/0D2KC+yHS41DgzdpkWFZ1gxjhMoxeRSJHo6lEq3y3IcTDezwxrEgmOiDm3uf+AhXKTkd6U6tzlkWeL2a0rvB3TWhvvR25gztmHXG45QF3iRSiQeONPvKQDEB6zRJx2ASE1umAn6oi6aMA8P4g8fOKWpCBOrGf7w2pGhpfvJNiOECsVxDIFS4g/qysrsCgnEnaZkcacK/tqwjpwLp83nlIV2vqvM0pOcrL7Jm3lEv9Cr2sBn8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lUtfb8l4DA2bdPdxSEGObdqBhScMP3nZP7imP1EgnWc=;
 b=oEAiNqCLJ0qhiNqiTaiQWge7jqNj3TI4PuofNitKD4WDjJGliJCK9SVE8zNzmV0F1cJLM3AAjLWF8mxPxYI8DsRzh+5bZaf5n6fxvTrYPB2F6CndfJlUlLGo+0riTl4XeQ4tDK+Nh/6lBQWamFguIXnJ1d8SbUyOF30y7pZowTgKPmizI8iAj2jlSUpf3oQ+cRN1wid7/nbu6P5YIRuvVpeM+ljrb/1x0Ga+8VBFYsKpR2qsj9uy7ArSKbINB0JPZr1lSW9BxWv9brORapJpFwZhqT2p6qs9kCLJj528iY27M713HMuGVaaH7nhwYG0Lir2HAe8VNuccIC1h1jkRHw==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYCP286MB2273.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:154::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 10:33:01 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Thu, 2 Feb 2023
 10:33:01 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/1] net:openvswitch:reduce cpu_used_mask memory
Date:   Thu,  2 Feb 2023 18:32:11 +0800
Message-ID: <OS3P286MB2295FA2701BCE468E367607AF5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [34m2UwOG/3cvdL4ztxYYRu40P5p8yctE]
X-ClientProxiedBy: SG2PR04CA0209.apcprd04.prod.outlook.com
 (2603:1096:4:187::12) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230202103211.203848-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYCP286MB2273:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b7d6943-0213-4412-d786-08db0508dc2f
X-MS-Exchange-SLBlob-MailProps: Op6Ru+d2ciHX8qj6X9BlhnfrJwNxzEqdlpYhl8Vkhf3LE2F2icoBMFP7UIQ+V8ZEX6Q6+FkQCZ2U2OiosRtezV4+NEAcZWDbmNnJJYM90+OHRW1XP4Ho24aKgiTK88d8XAuXqFKy2jzTPZ9hjOOVArft5SO5+G359aKUY9/IHycqKn+xonszS1QRkNUZ6sDB8MvlcA9hAf62GD4TyyoxQRGoUmHOJl3nnle/UImgW4qtVz4DjbTeKfoikProB4hK6+vow7+ornq8LiRZ3qPUHS9iVkP1shzF9CqOaQjkSnFULBeKUfyPhae2cQrENIhL4WHwQ+g4xt42Be5SCwec7yqjml2d8jCkFGL/b78yIrUPmNWh5UF+EEh/JrVEm3/G887PFPlekj2YC3vpcRRRiTHtHN9/Lg7NN7BDvNe+1SXZku+X7AG6LhwYaJBvSGBqMklDVsmQgVk3XhAtgJnuB0ZxBwVt6FDgNYeVbCoLzgZXJ5Qworf2tbKL9OTeaTuaVGCVhHrt6I0710svECj0VVsWTlQQW6LgZPlSFdnpcTDV5PzM4FXF/L9EhSX+8+OZoclqOACr/pbqGNdZ3QLtkcubvlK9ZtEHMOXc4WkN3X1JKr74/tk1k1k4E51l1dLczx1IzlIx3iQYxH6tneymyrNbMwMfFFwjSdib4gt8OM82y27YzQjW7HWfBTKl5FrEyaEv1bwcv8H7pJwrdfwP862zy8Tnx5HQ
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/dmWmzpanNcAuVUbEtvylJ3NJGk8ssDcgm3ej5nR1pzMsDc3LtcnS75udLCQtSpO3yePoXlvVux+os3PGDSfEwVSuIFwF2OwGAtQr0s391ahsfNxaVmLeNPAxIcPQ3wQH0rVkII1ourJ8/1zimPeFFGm3rzwlLTaFYeTfrnCmdoqt04nLaqmPv4g33wRdXDQiiaNnlGSuUXcO1jvdDwvFvggIy/lULDiDL/Ya+0dVMJo74d5L0IeFdUuUvND9omcpUZiLJNzzJrtaJ6vd9gDnn0/nOF/yl+ie04YoOaQ5bFrIU7qlvT1S4WZI5dkbMjQDuC8Xhu/qModog78DCceusu36nh89M3foAf4LFcgvDAEt7IXTqEKet+hPzzFrKl5VVz5tyIxJObyHqpmUoFkZARKQBeyJFxdGPpPSeE7FKBgdSOP0K64LJSY1A4opjVGnVo9I6Ra/I7KW9IPvqrPfk48vJBjKa3gwuWl8wb6k68CU/yKTZP7qwNtDqFrK6NfCAZ7cJyoy+HznFGm6hlYKhDlA5jyI4z5Qw1IWAET8iEOE04wXOg4c4b8ciaJ9YJpwxv28EbIXCy5BO1tefN3Np+TtBWehSevmRx0WJYyNhl+8e6mBfUl4mqI9AztIWCtYIQ+jeDoHAoRDQGm1wKbQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dq+4EFYxr8w8JYKkZD/6K1R8uDtmxxy+XMTcoIlke0ZY1vT7/NrYENn4GnP9?=
 =?us-ascii?Q?DIXWXEqo8eT4l41zzXb8gBzW0k7ufJKdun63aChCIuaMDSVaMEWMqyBiXK/N?=
 =?us-ascii?Q?u0KklclkG4+YfvsKPx/skm5KFJsQHU8S7ctqLOzmrmyWvxvUcgQDRv2OQYf4?=
 =?us-ascii?Q?So9u0Gr4tl/BgzvQf0fUMOcdNbaMkr/ABcG3HFZ+5JodFAUf+ADWShTsvyA8?=
 =?us-ascii?Q?WFVrO1sXbFGOOgMOLWeoVw0PrYYzToOSrPvZS/WK9ieu6Is7MMHxecZc1HV0?=
 =?us-ascii?Q?HXsJapn8rIE+xU/ZcVhuA1QvEFcRvdmW7ZaMEKo04PP/Em2AGOeypsfHQD9w?=
 =?us-ascii?Q?nV8Ttdd3o/KoQ9xqQbPwq/cfs9i+Ciy2BNn/ewH9efHAKaY3+jiLr9RJNwVu?=
 =?us-ascii?Q?iXUIW2KUxuMM/ogD6z43njHnOL0Gtae10zAZy6etD7QIDkREn/B5T3yofFal?=
 =?us-ascii?Q?GVOT/xBPgxRR/LIbxDq0+hSSUjd5eGipJ8gnDpmBaG5/AHDi+0NsXWEroI/I?=
 =?us-ascii?Q?ZQMbFHygTuYerh2+xCs3G8yYfmpOfAAiapwJ1Vz2J4nry6Yn8py4xGNheuPH?=
 =?us-ascii?Q?BXwVzdji1DE1APtnkO/zx76m4f/WYv8hrCAnNOqWQtt9VX38SJfqKRXtAgBO?=
 =?us-ascii?Q?1WmXIRryJBjfQedbPYILjv5j/LixH1ldQUCsCgjPlQHbujScprlI9ZpOd980?=
 =?us-ascii?Q?xaVZoZHmgogSXtpw9rHyJLZkqSCWXyH+o5Y881fvYLuifTGN55pw+WuZgPuw?=
 =?us-ascii?Q?Fii1qJp5zTIL3QMIFG9WOmlgX6LrEzlV5MorYznelgaO+5XguJ2yKsHu6xBy?=
 =?us-ascii?Q?lGBJ9TBSECR9fhciXB6x8osxTUv5Bz9j0HAFdo5uGETRVhUPpAyYl7ySMlQ/?=
 =?us-ascii?Q?hJaAjZM06X8hdMFLshSZyiEjm/jJy+iu9/6dx8iB51waRGObSCwkMw1AyR6u?=
 =?us-ascii?Q?BHV3DHkUWXJmkwTrsJW3nOLpxYHTsixkM4KHhsGBsH4OeSPD/WAAIOv+uR5I?=
 =?us-ascii?Q?0Shc/5RhwdZyMHJ1Z0eAo/GKETTqLC92A7u1RBeaUPJkNDajEO79YW7oxogH?=
 =?us-ascii?Q?DYDf28hhCBRn2FRbdIFjvOe5slByzQL5cnlWSbOaWDyzgtUFjeb4swGVfujE?=
 =?us-ascii?Q?HpySId6Uzad55dRbDQChm6bY6MABGGABRsgRBmuOBpAPDRZd/kLzF5PHvMhm?=
 =?us-ascii?Q?SVvk6gwC1galGWX9cb6yWdOTyjI+x1ryy4tCl7aKT50lpIMiHH6nuEn7nyz3?=
 =?us-ascii?Q?egpqNgyCxulHXKY/aOZAJ3ryQ8lEvrANLPn6tYx5uQ=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7d6943-0213-4412-d786-08db0508dc2f
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 10:33:01.8181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB2273
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
as well as the iteration of bits in cpu_used_mask when handling
netlink message from ofproto

To address this, redefine cpu_used_mask to pointer
append cpumask_size() bytes after 'stat' to hold cpumask

cpumask APIs like cpumask_next and cpumask_set_cpu never access
bits beyond cpu count, cpumask_size() bytes of memory is enough

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
 net/openvswitch/flow.c       | 8 +++++---
 net/openvswitch/flow.h       | 2 +-
 net/openvswitch/flow_table.c | 8 +++++---
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index e20d1a973417..0109a5f86f6a 100644
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
@@ -135,7 +135,8 @@ void ovs_flow_stats_get(const struct sw_flow *flow,
 	memset(ovs_stats, 0, sizeof(*ovs_stats));
 
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
+	for (cpu = 0; cpu < nr_cpu_ids;
+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
 		struct sw_flow_stats *stats = rcu_dereference_ovsl(flow->stats[cpu]);
 
 		if (stats) {
@@ -159,7 +160,8 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
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

