Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952D9689E7D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbjBCPnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBCPnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:43:33 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2082d.outbound.protection.outlook.com [IPv6:2a01:111:f400:feab::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49EA30E98;
        Fri,  3 Feb 2023 07:43:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5dNT4BuVq8oPVUj4uQX3CIdK5Xiz8JLSE9B/Vqgf139IsklITTuBKNt9rSe2mi53r2JSuKIrBIbjZawNbNYyk4WldxEiOGtpPLzjPODLrqsvDVQbfZx5uZrNVdBRhWhU/ZZr8ne6cALJ4eOHNNGJVofu741AjypqlFM62NF+juJSKKeL2kfeqMM0js30yfWDg1xyQ9avoD06EBRnkfndlfp6b4g8jlM/bdfQQJ/Gl+qDRDKqyAhATcSt927JgjZ0IrTcWqOLFymVa8SwsOZFu9sTd7jErX3HpPkWt+m4GfoW5QRnXxRJlE3U3CYmTLTJc74Y9+fx98Q/vh20s4iwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3M3zM+xU49A7itxr2RV8wODjxZvFkRfdQI7kC1ZTmKY=;
 b=fnUlMYpeudxnzMV759mMxQVfuE1ud/Ah8nqUyQVquLn0HsLie72RH7FMOlK5nOFyg05VYBYLZwFczpaYEFd+rVXgG7HXFiBcsmouerrWkWvmEh4vnmQ5w9y5w3nCC7B9yE4nwJsZ/CIr+1e6vNKkLg+y9v5IbBuawNlkrRgHW7kRWTdzogN7j0KWGnGoNCSaHIB1xIOkDnfqsFzfar3rUkRid4pDqb1pg2dFxgLTrIEA/1wW7nS4ohuLDMYkoCr8bP4W/Ylr2BzdWr4vz206ImsrqNanpbjiXOdGsGJffYyy3CkWKISlvLVUje+DF1S+RBOUZGuZ8llOLRGBdNb0hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3M3zM+xU49A7itxr2RV8wODjxZvFkRfdQI7kC1ZTmKY=;
 b=meRFmKiUSUbKMzEsWnSh8/XketQ2r7AIz2ofduhXJIU3i4GAQnB6iLvicErsaYw0xcXgpiMDD9YcY0tgvPviLSdcFZo0d/wfCbAzJwTzvH5V9lbtnfdPE7/2wL8QyQMocaVYl4Dwh+W+nVaSXyVKNipy9ghDRAo70IuDJnKiXVUYmPEF0589gyrQBpfbbcDkH9JFMZ61PjzE2t1LD+O6hcSWCks+BlqqiNCcGJVXQ0lnuAFuPpYnKRhcimlW6y93qiFktrpS4wWjbv1fSgOcgWTa1kZK0z0cAezlhg668Gl1Piiyn83gLnikMA15NZKvlA0YvcIAQlzUj4H1KxCycg==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYWP286MB2038.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:161::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 15:43:23 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 15:43:23 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v7 1/1] net:openvswitch:reduce cpu_used_mask memory
Date:   Fri,  3 Feb 2023 23:42:45 +0800
Message-ID: <OS3P286MB22957550350801F37FB56DFFF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [+A+SXmacr6ZKBPY9HtgA3dbBP5EMT9XbXivLU4WbgOCl/mXkw8I9NwW03FDheCN3]
X-ClientProxiedBy: SG3P274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::14)
 To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230203154245.2315-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYWP286MB2038:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aef04fb-7a0b-40e8-b55b-08db05fd61d3
X-MS-Exchange-SLBlob-MailProps: Vt1MYR2q4OlA88tKnJumUmj37q6PE6QaZ9J+M5kSycBE8DmlPRtcIsC6P7ugrAWdZujdBNNenG9gnZNUyDEGAsiEzjc+360i/ov1IHlGZuppMnDhbr09VKVSoofNBW0mSp+874XMfM47g/mvyvjqtdyvyTVjAgOXI5U4NFRJWm4wJ8PNDyyEqPe6RLZjn9L5fIqkDIlSFYJgnTg63VLhQluRiaDJuNmuEPOtQO3CEmBRaFnyC3zUMGTMYOqSiJzvn0agUB03MxaBZf1Gjx+ai7Vmnqec2sZeSKRPvPFxBrTKdL9IjVeNUGroQgKLYPy3qGV9OcsPYwoSXj44k+hvmTM1UvBanWTb2n/JkEvwwBTb91AnixmWbPpDmJ3RFpSFdU09/R2u7VKwKZmLWNFHPBEm/OW0cZcD3ZTIpU8iWmZPnTb/gVvCGRAyv1QnCl6Ar12rIg28LIcsv8p2zv7ZcYln/oCbXY2HjuDGEgefbp+Y26RwgFOVQqQgQbePkfiTgR+nx7mK+R5iHGhu2xItj3eTFpmNMr4v3z/xPrnLagKCzeCxVQOf8qUfRrRiBXeADFIt1fNzJJ9hjjrcssFipFmVxZvUuQkNg6EEB4TEpZ7qnWNury+p6DOhhCOUy3mzqRir9jJvmxglvC+6wkYXyCgapacYN8EzgZVP/ve9jPEKvmo7V3bVThIyFp985+DfcB0cVrvh4+8xeXsVZmM6XDOzLuCGoL2l
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4DnvPpbun6LHuMO85VZ194eO3VseYmstVlnOGEL1W5fG+DVKs+LPs+yNv6BnCad9CkgpKU+9aFTppPFEP+sDJy2wfMmkx7XIStuHCKk2EMkr8RW2EC85/HyXQGVOUFj6ouna9qTweZ6Y8p3WpVWT5Kuqd3iVQUXwq+KiQif+39DqYAlRLIe8p8hig3+sy/6LVg6/fuoEaOIxWvVEs71H2oWdG5Pxm1k+c1X02NA/rW2w2i2kfjHPkcjjT3M0WD4XzpA2HawTD38XeZeu7T9mEOKP0+XIJ1rthPSIB+PLYEnEkDly1GZQFlyw7mwJ9T9qe4TtwcTxefH3ga27htOxWKTR/tdbHfQqibFBy1YBQ90n9o7e6vet0AOJYURzT+fWoXojvJOT/XwZLa/CnLQzorJ6vaqX0tDyHXP5nsd93HBpxPjfMcIC9oZtZzA2fLuzfsbQftAaTLCiTO6xz8negTZ/2VnuSiZhW93Eo3oZgUpNXzVDaa5G215WB35TeVvQVF5nCaCh5QUNHbxj3lmP6gAmghQERN9YbH94AWz78ithtO25rZN+KnQv/VezUeFtYLnSLW17mUn2fjunP5igFcFENxFB7VA5QVmHQgKZBLQWLlA68TVQEtc/q83Wf+o5aKCb0NpoFkJONtT6FbQTLw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pAet0TFcey2NCOfTbK8H7jrX4qg3V1qF64fO+q5DEjK/LBqDgv964rUehKXv?=
 =?us-ascii?Q?oTkLYOzkz8CcxAKWtzxdIyCC3gFzHFEiuoi/jI2zQ1ECO4ernjSp9aoAVF2u?=
 =?us-ascii?Q?MzKK8c8m0c0mgXZwLWrBxMFZEDJ7fk3DNBocq8Miyk55q71GWcl8mmjgkMdB?=
 =?us-ascii?Q?Vb2Fang0hoIG8iW+E0H1Q2dmXI6j8QZMNTLTU/dXjc/bKGWJ35+5WhYDaumT?=
 =?us-ascii?Q?GOWF9FeP6UB2wtqxRwLRL+SQAMnhYvPJQs3vIElXvQopfmJi8cmaT38pjHQ5?=
 =?us-ascii?Q?LC1qlBBG0/aRE3brG1iWD3lTMUL5nIHwPn8wC3SPEDnT115F71jYNk53230T?=
 =?us-ascii?Q?cD3oPTCgRfhLzStAR0AOG3128mBs0DdkpiIlkImrEE0z5dYIQ0DBca/uwqJJ?=
 =?us-ascii?Q?4dn0WhXqHdjRgw5yhaQVnfhXycPHvRi7IcI4KXiomv9T2Uk1/fJS7aPSAh3e?=
 =?us-ascii?Q?ULgv3eWSEzFodC0vJjzJXwLUYNOYb4yAcrVb4H3y6vgEkCoaXHeBrbObjnZC?=
 =?us-ascii?Q?e2Ay4itNjhLhyUkhqbtFvGwa49Pufa2hxFKqIGO147HVnMNvrzpjvFUAztSR?=
 =?us-ascii?Q?79qhEevxhdsgXZUsuX/p0aiNMN0j82JDyup2OkH337qlCi0OPHGMm/rUgIqR?=
 =?us-ascii?Q?ThbHgihL/O1Bz/5g2u66E+pGZEp1ssJ0+xNtBzvfJn6Vx9vOYZR+tpPg+Hx0?=
 =?us-ascii?Q?u8myVDH5uN/eUgwTLz+w8zM6kanZfr2ZVyXkVnsGKs+1i0fjVc3LqssCAHJh?=
 =?us-ascii?Q?2cB2nK9+S+AS/3grPJMNF8p4Y7tz5t07VmvSS9Zuas8oA9lpVNTo9QbsFOgT?=
 =?us-ascii?Q?E2+opHW/hP+D4jxsWr1sbKeGeNLJWvXhR+7gQajL49niKsOjbweZ0gd28ns8?=
 =?us-ascii?Q?L5SY3Ewz7ACv+CjLyiaSCE7T3N23t1MCe8pgkNJop25znFmKP+3kvztwbBcU?=
 =?us-ascii?Q?6X0qUKRlp+/vTHjcMLunZ+8271cGRmoZijAR0dxUp+/Q0a4p6e94wqtkIVaE?=
 =?us-ascii?Q?c8u9WonqKXHtjwEZILSwODerCO6hjbWca401N8o7TH2nzQ99hyAB0tcJsCol?=
 =?us-ascii?Q?cm1ChbWTY9FpeoVSQT0SjjVdQapR0hweYGjhfkzSb+gdMftlyBeqDErnUsE1?=
 =?us-ascii?Q?eOGW0/hSPApGljXM4/5UPwTbVdOwF3QUXFwGCA9FrHIK3vvSpGPM36NzgVIl?=
 =?us-ascii?Q?uGbYEVdwA2ay8Ed+WRECxdSQ8kHRIa0G5riFJX0ewz5wFtV0RxhQ4G1UZRF8?=
 =?us-ascii?Q?P6F6GpcuaRR4fUrFwGscGirdI8AUmeb31mK2/V1Ghx5f1/8N1Cl2WWO4Cn+N?=
 =?us-ascii?Q?7ORPePaTTktCdhPkssvqPDeRqy3Oe8jsfN8Bn7dtpOiv5g=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aef04fb-7a0b-40e8-b55b-08db05fd61d3
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 15:43:23.1685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB2038
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
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

To address this:
 Redefine cpu_used_mask to pointer.
 Append cpumask_size() bytes after 'stat' to hold cpumask.
 Initialization cpu_used_mask right after stats_last_writer.

APIs like cpumask_next and cpumask_set_cpu never access bits
beyond cpu count, cpumask_size() bytes of memory is enough

Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
---
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

