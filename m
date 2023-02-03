Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AFB689467
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjBCJvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjBCJvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:51:40 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2064.outbound.protection.outlook.com [40.92.52.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA5C7D2B6;
        Fri,  3 Feb 2023 01:51:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2teTEHR2UYh89XOb1khZ25ROL2Xvo9o5RhuLMeyoakuiwwT4c39W7yqoxxQiM8C/xP9ST6bbA2Mugv97WHI+vmhB4yNwEg6vU7BWSMOeUKvxfZDU1VtzAZ8k5SIdxrxTrTnmysZ7jV4X6qXvwSIUrlPxRPR/QlWboBIZWUaQfgplvLbK+R3jioh061HdmPnz4bQI1eZhlyxyL5wv2XchraFMyRzXGDIsMCWTgRWnAr8MYwESZJujn0HRdgIGnlbQM4hSdP+4TR7BdH7DEH4NLBclB7FSit/6pPwOlUZgE7XEwGG1ORXOJEM1bgx3LW6bQUfh/cxeR8TS9020NTFew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XssPDUUQpRBct646VkuclYOnyUPeRTF2+D3UsGRE2g=;
 b=IqBV+xz9s/TtcxrqHKkt50mLMHkHYnr4/thnvUXrIQtmQy/fRVZSAsqqtJ/3FQzJTHcBbINgbPkD0u5xq/nKpH67mKWyIOhCjgc+9bHJpJ5sSmi+RRu1FXqVy1NrqPwDvQ4S0sWlSTAExCGoGKNoEV+3M680uvxk+jGng/3nmKZYjzjxOPTjfcjvcLrKxFPw30mG+MHcFapdnad24paQfWr6A0WC1PRIY/i+vpyAohgQm9E4zm5Ch4YjTaHkFq7sNy5/peOXCoSKuyNyy2OCyRIXibH0V2jq4tiWcsRQZfDNGdquCldDEr7+pjkM5DCDo7PK+ts5KS3bigFQMBY5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XssPDUUQpRBct646VkuclYOnyUPeRTF2+D3UsGRE2g=;
 b=QE7jul/JrVH8kLkBpY8qJGJxpOPzrJ5gQHgtHnqm3Yla5JFAtdBYyVpDPk0oTWhnkHKwcmNz6UtB+UQPqVv10gDJ89KYW04npNQcBOb7MjRV6uF7OmoBijut3XLT/x/R+gOO/5P0UmXRw0BjHAnMTpmmaWzmH6oSRzL+vHlC4yHJa6JKCIQHnSdE/VrtCXlt9kc+Dft4yCDHDkDogv+FQcz7UVFv15NcQCLn9lv8U1RMGJlj0ew/OnoDjmGrBLPhAxfQN3ANC/DPLDQtHdbkY6EilNXC8Uietrnwugvirp1jhiAYVq2QF6/uH0jA0iET5F3HV3RkpXjmxEd14BZbMg==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYWP286MB3431.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 09:51:36 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Fri, 3 Feb 2023
 09:51:36 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 1/1] net:openvswitch:reduce cpu_used_mask memory
Date:   Fri,  3 Feb 2023 17:51:18 +0800
Message-ID: <OS3P286MB2295DC976A51C0087F6FE16BF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230203095118.276261-1-taoyuan_eddy@hotmail.com>
References: <20230203095118.276261-1-taoyuan_eddy@hotmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [F4AyPzuBm59sBLhXxb3dC1xwdk6tDf9i]
X-ClientProxiedBy: SG2PR01CA0184.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::9) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230203095118.276261-2-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYWP286MB3431:EE_
X-MS-Office365-Filtering-Correlation-Id: b5056fa2-ed0b-495c-255e-08db05cc3d37
X-MS-Exchange-SLBlob-MailProps: Op6Ru+d2ciGZxW9SRnKHFeRtQv7uON2YAiNRMPEO9TWlGk+3SWraKATLMuVVUBM54pIykylzJYogXOPdlQ6xlrVI4+cPzxvjsKPnZ5pbLl/DJ6VfjxlO4hgec/9S4cpWO8OiDQyiLaFrqtF8leV7asRQUBYHQoN32Fi5NWUUCdZIu3lMWhrdrG8ORN674rDAIQ0rYWsRfoMe/C7FOuuhGtAWrzWgVMGa0NxbOWKqJq5Jb+CqcyMYK6+dU+aHQBMh7e52kKXN7PNmgO0fakK6QBSLrLJtFBNZ6WPMy+g43Is2kgtaXzRvRDrY8ZRReZdGVcx1XnbKk3KTlGY/RBo1vmycqOSWFj+nqxJvN4FVEtXZbzOx12lu7LF+MyCNytyN59h2/2FyNHl0zva6hbiQrtsKh44vaf9Lbo562ErSNlDMvAkAjtJegf42VyzHA1yhLmKWJVSRHwQueIyZd7KqLIhFyr2WTNkg1K8bQa/7eDBqeV4BAggQSaZeXp0PZzgMewc8Ph8IQS7cLv4PlD34M5ouJDuS5I4knfxXMOEfoXsW+M8SFPjO5WtibCLcllXOBfLjDFSvrsjNVANGP6mvD3lq71+l3OPPd/IfLLDpsaDVcG+Mw18SzNM7QiYxGvFN+Wsw1IRZ70HK21knyrjio1l30n+F/LHIpsxJeBcdj5l9jwxP6aZDXhk4nDtXN8fzjp015OCZoazIoRUC8JhR9rtbtfV65RQe
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNy/eG5G5kKmGz/NAb7/+BHiP4YyXg3i2eNxIVtjKY2Qbo10whqFde9mxXEhW+u2CFsTGptM6UNHtM77SfIFHm0CDfeAnwQQtow5oBBz+Li8aMz6Xt12W/ZK2Jf4IvUwmiRdmmhmdYqdzHtsaCfu9CTxw8DXIOQnNAna2O/oy2MxpPKDHlLG9qa9we6YNROD10oDsl5qvK9dwL1FN195sIeJxA7g3JTyDAA5bJUb6fsufGSHcbJQmc914lXbmmijPw443FxadG50IXztO7RWhxKKaVR67H8Rgb4NVrLVFiPZ6AVBYbunl1pAqM+PwDw58jLEh5xIzGWgLOXNit/41M1AN3Ri0fHYs95LLOAFCvke/KIjmgPCduSfnS0UZWfrz8j2ITnzKcI+hbVtj1tEYVzTZb46ItPVWJleNyHiGpMM3N2/upmqDUJorB6JcDLdc2u1HBZ69FpeGL3wGUww37ldF6Yc7Z1KqiMUaQDHQbBYVaJ57F6kw3XviO1FlCzaHr75MEadBu7QakemdnkCym17O43Yg4IQNETC2YjWKjuxHZbsa604ZaHbMJqiewYR1U6Z7x3LlolRTRO3QHlBKvQZZ+huoXjZiCYLc50wGiSzPGEI+ywm1HSV4Viax3w+0UBh3On89YjEgytPwMuUGQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o8do+RTTJByrPJyqmGvM5Q1YpBXRPyNGTsv3WG8tzKvw6nAIrvXNIVeXmjgg?=
 =?us-ascii?Q?8VJxB5ZY4/rlqFkj4/CHCGi7LXr3wVsrD1hDxbC8lAqLw+Hk3A84YxFHtUTG?=
 =?us-ascii?Q?S+Gz3rPkeKiUs7NKjpkZLuY95vbC3eZySgX2jMLXMtqTaXNtcEP4Gip27HGB?=
 =?us-ascii?Q?TjWloOHRIlWukDx+waF4kVSbFWnfc/3es94/xKYmG5am2q0NS4LR2L6QLN60?=
 =?us-ascii?Q?OmAe0HpQMTnhPe8c8VHJQif0PQhaKmhvH5pYV/MvDEuVRYONcjdM/zesMLcn?=
 =?us-ascii?Q?r+rH2bcoQIqmURdkL1WNOTCB49i1pntzuwdzQrDA4rNIc2TP7/zUkdi9358z?=
 =?us-ascii?Q?pgp2bDkuv6JYmFlHucVA6dB9WryKnHS1DApYcZlRGsS1uJRKuNknU5cGkn7G?=
 =?us-ascii?Q?ED0moPN/ouz31cTjnQkx66XO7eRMVodOP50taFr+kYRfyzvPRxc4VOGxAvUT?=
 =?us-ascii?Q?X6i8gn5STuFI4Nx+hZL7n0F1Vui5c6PQD/8QGENWRitK/DHCAs4u2OnHbx3g?=
 =?us-ascii?Q?3puYZmSreV3CJh5EpJPA4rLuE/d/lGYN6qO/CNPnZknBOH/djSIj64NomrWS?=
 =?us-ascii?Q?Rb0LPV1fBjjjRYDlnONhgsZFe+2Yncnq9fE3Y7abLsLp9qejXBpP6Q4CcoyR?=
 =?us-ascii?Q?uBO94FzP6LNzkiHmqwBw5M51fOrHyeGwrNv2nrVgNygGj+fjzEZWvQkFkEwF?=
 =?us-ascii?Q?TCyVLXPuNqj0F3+bZUlzjCUssMLoipy3gyOkIq8Av+7wHhVY48fdHOmFFMHS?=
 =?us-ascii?Q?MCOyyCqiA/0lBYTKTuIU3hlhaPdvTjySAkr5S1hEQq9W/paUYOyIei7WxZ3T?=
 =?us-ascii?Q?hs2E3JiCBhIDJs59/fdly5aSzuKyx+WXEP/uA9KBkuR08M7N7ZFOYc7RSpL/?=
 =?us-ascii?Q?6Uswp5nLm9jGFxSDKX25yf2To5AAsbSpwN+ah96ri7H62eNEIDX/1+E3B9F0?=
 =?us-ascii?Q?xqnBKDshf1d96uLN3Kczf4k1eRH0ke2l2FgGiCYF6z2Vn+lNLm01cGoQhhX2?=
 =?us-ascii?Q?Ut53OqN6IIJnuGT+NGvfzfH8znJLWhUrze/mBeV7w2BRrK4AZspVgDQDQapS?=
 =?us-ascii?Q?BWmRPTku94U4Oq83Nr3aagW8zzr1dq4RVNjrNs9FnDiKK9VFqwN78lbBv6X+?=
 =?us-ascii?Q?aX/w9KGupWIw0kUXegtsVdhOON+oVnAj3hC/6zUCPBg+6h9SGgYKKbjNL4N1?=
 =?us-ascii?Q?7OYVCCPpo9L3Pzxf6HajWhFD1AM9qwkj5xdanIIioDoPtfcrnIznCn0QSIhA?=
 =?us-ascii?Q?xaA7nIGhn/FdxF3bgc6V+S/ju03VjL6PpwQQLky2tTvKo0WVBKeAo4fQkg3c?=
 =?us-ascii?Q?Cyk=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: b5056fa2-ed0b-495c-255e-08db05cc3d37
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 09:51:36.4497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB3431
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

