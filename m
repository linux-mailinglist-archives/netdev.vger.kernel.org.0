Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BCF686302
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjBAJmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjBAJmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:42:09 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2071.outbound.protection.outlook.com [40.92.52.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4705DC37;
        Wed,  1 Feb 2023 01:42:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In5Fba4ozuyDRO7TPjcz4aVy+zC3Wkw+Ni//iLISzpeKUiGf3eN9Oq48eV0GTrFcNc325VohflIBtYNnh2uL/3b9JHHPC8X+cYZ21NI/nziT7Sl0vD0rGv7MO9QG2xo4hDrVn3+RMuncQXR8YmqfR4gXliL3lxpYrnEVs1DzXHYVutXmzXXci+Q/jrd2ip4RsgGO6ffCTkAFqd2brXtr2P6zsdTeUysFnTAV/a/Mrw8/GkYrf15+9f2ckZSUhixFBsvRxmBjefMUpjc7h+A1w4mXe0HnjMPB8A2Ct8G/xtMIGVi/RCPdEAtSvXaKJCLye7n4OjT6m6UlgsqmREsp0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEXJ8OVSfk32wlUZdtRWQ8gxx4gFaum8tFKI68iFQ4g=;
 b=CBGcdy4zkD04N94uv7W5DTodjjRwSg8EUKVKec6Soqn/xlRNGBJPSihg/2avW18QPf28rRMXy9g3z0f5fA3z4vqCWpgkG/CtT03QXpWugu3wj335OhZPthYomMe5xSU7t4Ha2EB4m4HVJ3PqlOqe80X31s5f18iAx2laDgPqx3HSWnsj5mziP3eb4ER6gaJmic0yhzGFlsZG9OH/+LH5p7VCwss3+M3rsd5RksPIQH7Sw+G9nlOSG2OhXEngaNX+NGL2TvH0TNOu0XbFXWO4HQuVULFKGvtV/tzHs4HUv6ykzPgJVLypHzcGoru9CUYR988zwNSwYO4HPeM46dyiZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEXJ8OVSfk32wlUZdtRWQ8gxx4gFaum8tFKI68iFQ4g=;
 b=urzkJjvPsw9P+FyiuAaqY21jtxfuBrbuTTw4jGomDU7cPBK+PDRcjBF2ZQfRVj+nIqePHkCM8TMQNJlpySUUzETkoYU5vehH/ke8683wms/IImVLsKv3jgeS5RQQhhWem3XDJ1u0ZB7X1nJpiPdKqkhVZMCJfvrkO4Jd1bNHvaZwZp2s/t7FUg94mus3FI/WX5rEH7afNZsTYPsqcu6ETK6YHbTDES8qp3h7Mzba537/Gg7rVVb7QPKTtRKGwTFL/9LDmng9Oc8MU4pt9t2HbNLD3nJo0o15p3H4vmE53P25JvjfiURaSx9DomzVrSccaOen+yL+kgtjH9E3kzvNeg==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TY3P286MB3763.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:40d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 09:42:04 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Wed, 1 Feb 2023
 09:42:04 +0000
From:   taoyuan_eddy@hotmail.com
To:     linux-kernel@vger.kernel.org
Cc:     eddytaoyuan <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: [PATCH v1 1/1] net: openvswitch: reduce cpu_used_mask memory
Date:   Wed,  1 Feb 2023 17:41:48 +0800
Message-ID: <OS3P286MB229510E55946D9D1E3EFBD5EF5D19@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [eGoWsEIeh0qt9pLGUGvkhmOfSePbQb2pKwzIs11oQ2veRV/9AVrL9kb+eWogRSfr]
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230201094148.628185-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TY3P286MB3763:EE_
X-MS-Office365-Filtering-Correlation-Id: c5fa78f5-dd67-4afe-c9d5-08db0438932c
X-MS-Exchange-SLBlob-MailProps: q3cIJLDN2c+w+CziC9pPzN+leFQPe4aiMG0x7m1hxZoUwrdy4tPAvEJugo0nog56utL3BXvXoo4qxJXfZwQW23CMdC1ZuK4A0LtMjcPXJHgmuOGbUHLfYP+ZSwg4C8aY/+nj8Vgb7bJhMhGyU4uqDpUizYMrxtD5FIJJyX4Ck5WvOAQrbN96QgcBKQ49bmN5JmuQJOxxmldgreIIBSAJ7ZqHmbIr4VEanwHdawURWMLHQPnYMZjkM4s21Z4Ax3wzNK9f37zvWwqJV0Qs3Nqh9IHS9b0iWBw21d72L7AJoGryMfilp+aGAZwe8QF2KWU26l1xnE8W/ZCZzB6iLZUqwhWn1Jp7lhiINvx7+vjcCWYi+/lcGIHKkY+OGlbwFQR/79C1mtwiwW08tR7ZYxnm4FovHGuq3J2yXOtfkB7t0/3ufLDg/NWmtXtesxptdq5rNkt1Pt5DmCmbNRwRb0Fi1Jx5//L9raZ4asly0+yVNW3EJvv+ZHuEbndrfk4gqzXsYn5CmEeXlqQMWvPMOTVq5tezV5++C+AiZHRWarvicTjmSZewDcqC8l4F9O+lhKTgOU6t8OL6ZwQgm6Z9ps9bITL3APaGkza4YZ/NeN4MERyFUfU9vX10u8d2Md6hUjpljiPf27UuSmCl6+dCTXgizBjTA2dS7kiEh1yGqaMbzGhbt7QWlXuztcpqTXdyVBjY
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdxe8Kd0VVA8XSkF1HJLntuHCSbdjmi5Z1Ay82+dyuA0Z8iQ7DHSTPBSKN3zhTNwUhk1Ho+CZzs6MGNIQbN0QiJnnds+e9YtTr7BlSP9rjVNHbCMmzdp+9POsmxMdY9iOffUike6A9SUEYoXuKQbpGJ87xE8iAz32sV3yr1wmRjcC2wxoX3EkVSlCrzspYZxZh9UbHjMyn94yb0esGL6p/bsYsMm94oqS1OPq/bEykuhV8bC2gbCBXIY21iPhOBiIZvJ4+k2d2Lso0VMYsHOt8CIG3ia2EX5XVcXQ4yWJeWUXLtceeYmNmaWF0huit8Hs+7T0Jnodm16pc5MonrkXBR2Q2uuJwbpBSoAuS/ZOQnVV3iXSV98oEl/6QcCGRsvgJXMgYSiaM6CHgi5jmtQ47+UxtKV/9K2gp9A0oOukvdJfTdTgRTINEcz+yBB1TuOPjOnghxzWMPGr61+dOY/D9xdhYFRznkih1DwEglwdEU1xGpW5aPlDfk96jz7O/SjZH9obc+CDXID2nEJctCiZaRbJQmUpj54JjBwGTnxFV4mdwevuYpE/+o166HHgbjh0Jpb60yyeKW6VIZga7JMXicuTi/EIoSI3MaMDAzM2hETvqGSQAP4+mj+MoPCcUYoMEKIon5iRrHjYqWIaQ8tjQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YyKLnyToVhSK1/SfftfFHbRIdCJar+T2NsWez92qfbm+pvUtZxlJ1n7P9+we?=
 =?us-ascii?Q?o3rg09Rf2zeMR3Cn/Q+v3XqWA5+BnqdMr21k27MmfqT0rH8t486e4H47hoGD?=
 =?us-ascii?Q?mv+Cm7S2muTeZhvVi5KNbGUnIA85ljLNjK5gl613ZldNJ4hYH76/xewIm9rC?=
 =?us-ascii?Q?gv6Mx1uB8ppwI+j/B89rXyW2cSUY4XsrJv5cqA1b1P/TmZ9oQb6iNw+bWliB?=
 =?us-ascii?Q?2A0/qKdd8cdKMXGFLJa9cX1qM4GfaZU6Xnp0y+LRvSHgPRtehsvfJUZ4z6S6?=
 =?us-ascii?Q?qTANhf7kyYnIwOKzCz2saK4L4kN+6VODHJWoNtAca11FPETbDmzEsJivf2Pa?=
 =?us-ascii?Q?hUJbD5HMe5SGXfY2zLAKvy1R6OxW9E89HwOHj3bUj8QUmetskhllRkChhQYZ?=
 =?us-ascii?Q?azxeAWOcHyu/awkEOiPAKL/jZB2hjV8hZuRn2y8pdV+L9RzhEHrQldQy438p?=
 =?us-ascii?Q?tJOBqYCsj6kqlMtD7GklyIgm8zlhMDivMeDeB+dvZSbFXv+n/YcOhtMn1TWA?=
 =?us-ascii?Q?ArWleEEbPs+eWEE6u4qVGQPc6Sus+q6oDqoUoMQRJeGgdglosrq3E0ogj8sK?=
 =?us-ascii?Q?3X7CLFkmBqIOyTADpone6ehKhaDTl3BvnddQM9MKZdU86WBJPeWjuiDS/Crl?=
 =?us-ascii?Q?el4mvpYNawXlEGftphScc5iEj9GGrcI0zJDo/dOsGQV95IdjDjE2XpdmxFTJ?=
 =?us-ascii?Q?nl4CHQS/66VMxLO9jAPrAeTTrRQU8KItYdMmQ2D6oLbZRycdmYMcPMw5UcNy?=
 =?us-ascii?Q?VC2ouENZaJlPNeOCg1Yuo60EYnvI+Eqea4dTKKEsLIiidZMLZp2K1qQ0zM50?=
 =?us-ascii?Q?oMTl2PfgUOqGx5sLzdrjRXkd1x0FzK07ZsWoGgmmvGpeHA9xABdGPfvdzAtn?=
 =?us-ascii?Q?BcYBWHAu86jPtdAaot/AYeyaSMCodrwSPEIHsqlS1yKfxJwjs7NLxFfyVm5q?=
 =?us-ascii?Q?GG4DPV9C+WOSNmPWJMiTTkKqtltZWNFQUgbLEY9SREgHc666FxPGGM3V0Zp6?=
 =?us-ascii?Q?sIYL3xPH8ArjsAWscs1tZk7qNjvVzoGu3XSdrY8fyZ0HbZLqV7o1bAi0fIhn?=
 =?us-ascii?Q?enqduLjnXMxOw41fb5E7SPIp1jgmQsxY3UM6UMmHBzvA2Tyd8sBrnuPhGYk7?=
 =?us-ascii?Q?nTPlsrduDjjPhE+wlIV1Jx9Nq3ha0V3tfowt9ah/a7cJzQfXlmG7yr3NmX6y?=
 =?us-ascii?Q?5QncWNSaiJtcII+nS3QEn0S/5uTDAPVJiNMx/Iwm/QITW5TtvgU4JM+u/Nuw?=
 =?us-ascii?Q?biBQUlksZcH/La9PXXUDtdve7tYU0XVhtYYyYkWgdpr2WZbZkTuPRDzIXRq4?=
 =?us-ascii?Q?jZ+1JjetTUva0QVhPMPizrJ2/DicClum6xxHRhxB1bJuVA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: c5fa78f5-dd67-4afe-c9d5-08db0438932c
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 09:42:03.9734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3P286MB3763
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

'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
However, its size is hardcoded to CONFIG_NR_CPUS bits, which can be
8192 by default, it costs memory and slows down ovs_flow_alloc.
This fix uses actual CPU number instead

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

