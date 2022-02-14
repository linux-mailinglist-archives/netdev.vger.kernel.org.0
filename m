Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA34B4CFA
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349201AbiBNKsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 05:48:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348869AbiBNKru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 05:47:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90DEBA772
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:10:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPU5G9GxqxbUXOzlsTl1FEVI5xQZtpZz4+J0AvxA3nZ5tDNRbA7mhWxD2s89oPBiP/QnYd5ne3B8V00f2DufJaihDADgstrtk7sno8OAUrDDlffLFpsFZwHLfpNhMGl5Wl+CdPcrK7uiKGe7fXQNWqfMLWlvIWf/5OhVlTHN/RjOyvBkiHqXxY8sJropZyf8tyS1SUIaA1XpB28lgx3C6QI/PvWwNjWTf3n4mY4pvxti9dZe3ijKuj27isAY9IKriN6uVyXfqWlcsCA+Y5m++xlb44VOU0lwKTe1ltVxtn5oRM1w7yhN80twRcT6ZvzZIqamvCEbM9YkGQHCNFcoRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTv8hblTDu/R/HbOVSeJiBn1U3cUBTr+K2k793jyw7c=;
 b=TEJIo+S3lqh60JiJSz+h8k3WmuL3NVC6L7o9uoH45Imh0ZtFK0i1Z6hI2+HvvVcLWsUgWr7e7AZAjSQQx0jfku4AkfS1ueRAmFlOuhrodVCWjYCg0PgU64oICwrZNkUvIyiAUjqohBgPAWXv3mKyV1A8DseUdhbIst2qdK2hhDY2vcMjEvp0WMl5E0LahlA/LrEdTJkpn0lD8WU94FkcoNaSAm+qDNSmTz93ao9Mi2sbImUQIWhXAMKa2aml2wexaGj9SCebjiq5zM+0CpQ7XgE6CGJotG79ngk8iJGL/cD2/K9IbouVIdUoOH9sf+4JjGBpNlK1Ts6f/ApvEKnhxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTv8hblTDu/R/HbOVSeJiBn1U3cUBTr+K2k793jyw7c=;
 b=G0mFs+V5RVDQMyVgwejhjPhVFCbKZSz1J3dmEZ+l6h88IaoUG64cmGbyVbRTeQbaXzZxG/+8/EJCYlnhvQVbE/3/MkRTrFM2zL6pFlM8MZcJ8z6mHGi42lAFJA/aQUdWbxUBlohmw+l2ZVK3ln6+kVy9VXrEreKBbnMu2IbwSxj33pnzySlFzsKVN//S01xce4J/j4FhCqmVZuONFIeAnkITLHkFVQzlB5lR3r5H/e3z8E37lJHWJZzX37sMBQSUlL8DVX2BmuZPpKVqhprEYM2ykJiXgVj+3A8TZX4wMtaRuS6G1qBZ47v4ok2UqH8W2HSIpJi8VD0tkOmsi5KhhQ==
Received: from CO2PR04CA0186.namprd04.prod.outlook.com (2603:10b6:104:5::16)
 by CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 10:10:14 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::68) by CO2PR04CA0186.outlook.office365.com
 (2603:10b6:104:5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13 via Frontend
 Transport; Mon, 14 Feb 2022 10:10:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 10:10:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 10:09:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 02:09:35 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 14 Feb
 2022 02:09:33 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jiri@nvidia.com>, <idosch@nvidia.com>,
        <ozsh@nvidia.com>, <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next 1/2] net: flow_offload: add tc police action parameters
Date:   Mon, 14 Feb 2022 10:09:21 +0000
Message-ID: <20220214100922.13004-2-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220214100922.13004-1-jianbol@nvidia.com>
References: <20220214100922.13004-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eb19fde-e5da-43ca-dd58-08d9efa2318c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1352:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1352F7FA69676CC0BA38A3BBC5339@CY4PR12MB1352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StrYb0673iMhY1WeeClHUeM2lWk/Pc1kDZ7VXGQaRt+NKWSGT78YMeJqc9HWEHvBOEAFwq2A0J2qdHYxW5SqgqFto7uuJaXeq+MLHSnub27A+JmcRN/39no2JeMmvg+Xg6sw7uBQ2jTugaS6M3uifdQIFzPxBELthLQAUuvwGUGI8OXKfW2awBT9t+y04i9k/FjozMMHKZkRvtiiqFs6qdSxO4WNNZ99HPLG+1wcR2bt7sffF4DnObtqtuZPSTV071Yri6n0oj/DvQ9MbxHXSM+PHbgjWqzzNErx58i1ev3hINVqS0iXY7lCA78Gy+qA+0LFTBD9Zn5DWeRPZNTR2pr0KequWFPvLG239ZY5Y36dpd5XS7ziON59R9l/99kTe8QB9faZ4R1m638SwYNzk/TAoVGbdYwmrPWn9w7+920BBsg+iwtdLBOuTaGldsxEOEYzUq3GuxtN1pIilqBfQIpNCzFbT2HTlb/papR+UkhTfoHfJgWo+StDXf/RNWvL1feQKP2H9VJfnO/60P8cfbfvdcKjMHnXrmTJobDKXSlHM6C6HXSj3nI5UBym9tiTxGgUKQrIXS96KM52vorExYhthPpZKqaa8ioGHK4uhWUzoAvYgcptC0FJ5xg8+GPEhnsHrhN5RRphSNj66tRpnOYGuWtlVrOuBtLwjSh2XaCdTrMoFIGJ64upu2mpFnm6V+04nr4+8t8QlTzPQJSu9Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(6916009)(107886003)(54906003)(186003)(7696005)(316002)(26005)(5660300002)(47076005)(2616005)(1076003)(336012)(81166007)(82310400004)(70206006)(2906002)(8936002)(8676002)(86362001)(36860700001)(36756003)(6666004)(70586007)(4326008)(356005)(83380400001)(508600001)(40460700003)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 10:10:14.3441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb19fde-e5da-43ca-dd58-08d9efa2318c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1352
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current police offload action entry is missing exceed/notexceed
actions and parameters that can be configured by tc police action.
Add the missing parameters as a pre-step for offloading police actions
to hardware.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/flow_offload.h     | 13 ++++++++++
 include/net/tc_act/tc_police.h | 30 ++++++++++++++++++++++
 net/sched/act_police.c         | 46 ++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 5b8c54eb7a6b..94cde6bbc8a5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -148,6 +148,8 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_MANGLE,
 	FLOW_ACTION_GATE,
 	FLOW_ACTION_PPPOE_PUSH,
+	FLOW_ACTION_JUMP,
+	FLOW_ACTION_PIPE,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -235,9 +237,20 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_POLICE */
 			u32			burst;
 			u64			rate_bytes_ps;
+			u64			peakrate_bytes_ps;
+			u32			avrate;
+			u16			overhead;
 			u64			burst_pkt;
 			u64			rate_pkt_ps;
 			u32			mtu;
+			struct {
+				enum flow_action_id     act_id;
+				u32                     index;
+			} exceed;
+			struct {
+				enum flow_action_id     act_id;
+				u32                     index;
+			} notexceed;
 		} police;
 		struct {				/* FLOW_ACTION_CT */
 			int action;
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index 72649512dcdd..283bde711a42 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -159,4 +159,34 @@ static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
 	return params->tcfp_mtu;
 }
 
+static inline u64 tcf_police_peakrate_bytes_ps(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->peak.rate_bytes_ps;
+}
+
+static inline u32 tcf_police_tcfp_ewma_rate(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->tcfp_ewma_rate;
+}
+
+static inline u16 tcf_police_rate_overhead(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->rate.overhead;
+}
+
 #endif /* __NET_TC_POLICE_H */
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0923aa2b8f8a..0457b6c9c4e7 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -405,20 +405,66 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_police_act_to_flow_act(int tc_act, int *index)
+{
+	int act_id = -EOPNOTSUPP;
+
+	if (!TC_ACT_EXT_OPCODE(tc_act)) {
+		if (tc_act == TC_ACT_OK)
+			act_id = FLOW_ACTION_ACCEPT;
+		else if (tc_act ==  TC_ACT_SHOT)
+			act_id = FLOW_ACTION_DROP;
+		else if (tc_act == TC_ACT_PIPE)
+			act_id = FLOW_ACTION_PIPE;
+	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_GOTO_CHAIN)) {
+		act_id = FLOW_ACTION_GOTO;
+		*index = tc_act & TC_ACT_EXT_VAL_MASK;
+	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
+		act_id = FLOW_ACTION_JUMP;
+		*index = tc_act & TC_ACT_EXT_VAL_MASK;
+	}
+
+	return act_id;
+}
+
 static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
 					u32 *index_inc, bool bind)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
+		struct tcf_police *police = to_police(act);
+		struct tcf_police_params *p;
+		int act_id;
+
+		p = rcu_dereference_protected(police->params,
+					      lockdep_is_held(&police->tcf_lock));
 
 		entry->id = FLOW_ACTION_POLICE;
 		entry->police.burst = tcf_police_burst(act);
 		entry->police.rate_bytes_ps =
 			tcf_police_rate_bytes_ps(act);
+		entry->police.peakrate_bytes_ps = tcf_police_peakrate_bytes_ps(act);
+		entry->police.avrate = tcf_police_tcfp_ewma_rate(act);
+		entry->police.overhead = tcf_police_rate_overhead(act);
 		entry->police.burst_pkt = tcf_police_burst_pkt(act);
 		entry->police.rate_pkt_ps =
 			tcf_police_rate_pkt_ps(act);
 		entry->police.mtu = tcf_police_tcfp_mtu(act);
+
+		act_id = tcf_police_act_to_flow_act(police->tcf_action,
+						    &entry->police.exceed.index);
+		if (act_id < 0)
+			return act_id;
+
+		entry->police.exceed.act_id = act_id;
+
+		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
+						    &entry->police.notexceed.index);
+		if (act_id < 0)
+			return act_id;
+
+		entry->police.notexceed.act_id = act_id;
+
 		*index_inc = 1;
 	} else {
 		struct flow_offload_action *fl_action = entry_data;
-- 
2.26.2

