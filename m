Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961D44C2972
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiBXKaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiBXKaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:30:07 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2086.outbound.protection.outlook.com [40.107.96.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC51A1F7677;
        Thu, 24 Feb 2022 02:29:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkvElXNxF/jCoif0pj50fu+5NQ6Zys3W0kVQdWE0eKEqzt9JAgbNuXOfMPlyBc9Vr3DTp9zYyh0ltpcw6AX1ave1nZPG4s4fYIZO2UCNm4pAQ+vPHXo7k2TFA0lmlQfv9VKRYzqTzKO95v7bxnIlQe1Rr+4Mczqh4n2g52qpRaYpeauPO25o3QRRqN7FTIngPLF+xKzL4dvD6wdEXvsR2Nc+YolOFwDYzK+SVu7uNvY/lsvMTp3y2cMQ16BNgiDW4pnrJgupHUu/bG++95GyxnAhzziPOB6Kn32frtP6OWcM1ah1SApZzDDRk3DQq/2UxAd0otGI0BiLPg4ul2Zkzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UYPsdyjqULzgWzqG/b68gTHjkreYemgeuy1deHa+7ww=;
 b=AI9862E5IEIUvV12kwoyPX6rE9jeKbx1xqKTOpbkZEwBZQw+vEvGczmX0YDNYqzC231BdlxTv0Efq+UmTIuRA3mMbp1QC1tcnNKz4qZrssPoFprv/l8Rio/UJ/fVz3d0I35BntjqwFtMpZISORkcYUnu8S9Ri3jviFiQRP7cGddQ1QWL+DP58tdqOHa2QlAxcrJ+PCZjwzdw8w1VFM30qbPDBaeKgr/d3CHrekZcw6w3Kkpn2Z9YFPIyEsRStCEmshzDsIbgsA1sY7aVXVin1TALQSXGR6SLckGMZG3ydnmn00eNgjzY9SynWIAs9juLHQtkrkx/kiSMk0AbpMJvZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYPsdyjqULzgWzqG/b68gTHjkreYemgeuy1deHa+7ww=;
 b=X4vBM53eySzEw9aRoO/+GVK6bNr0YGSoy6An54BqvgtewWgNz6VW9JhD34o2rM4gxL/tPqcpfhu1tJlUV3ORHn6sc6+62BdnZ/BI5dnU8xm5sgtz/yiLATpMeJr6VyK8br5DVZusg9tmwt4VXp4+N4EJyNR+XpAnt796Tmj3Tah4NrQnxRj2CKc0Xm8ZCXBmizyNU5VG3d8NaVLXw0b+1e9QK5iSX4yJeupH8L3AHISf2hAnkphS95HLc5HL22e0XLEkG0qZeQ6ddANxoYk1mLqNEJ+9FtulruEh6Cj0WfMe2L0SF1C/H5stQfjy8Gphq9dhOtMCb19tWBcMnnrPrQ==
Received: from DS7PR07CA0017.namprd07.prod.outlook.com (2603:10b6:5:3af::14)
 by DM6PR12MB3787.namprd12.prod.outlook.com (2603:10b6:5:1c1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 10:29:32 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::2f) by DS7PR07CA0017.outlook.office365.com
 (2603:10b6:5:3af::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 10:29:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 10:29:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 10:29:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 02:29:25 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 02:29:19 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rajur@chelsio.com>, <claudiu.manoil@nxp.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <idosch@nvidia.com>, <petrm@nvidia.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <simon.horman@corigine.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <baowen.zheng@corigine.com>, <louis.peens@netronome.com>,
        <peng.zhang@corigine.com>, <oss-drivers@corigine.com>,
        <roid@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next v3 1/2] net: flow_offload: add tc police action parameters
Date:   Thu, 24 Feb 2022 10:29:07 +0000
Message-ID: <20220224102908.5255-2-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220224102908.5255-1-jianbol@nvidia.com>
References: <20220224102908.5255-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a051f8c-6024-4abe-afd8-08d9f7808be6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3787:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3787751BC5D948EECE073BA6C53D9@DM6PR12MB3787.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYH5Pq3fud71qVu/yZsPQSygbN9yiSxbFOAukJB0h+ckLlVi8GkdTrIhbcgcnXl5Z1+jpCXIBE83wc+2W9tW6vZrOW4TDyPPLWasXdrV9B6WgT5yO+DSvGzKLad0KFM07u9doG3axDVCp5yRqjFYfPi8wuptbHB7r1LurxzPJM+8kzwT28y9VYu4k1Llfotg7lmnHHUx5JCwAO/vnei/AHdxXqZOjN1d2iHO4P7UoGKPWYRRkA5jck0DE7mBw+x5wsq/RmcTm6bz6qB+kdaMMf2kfacqg8hQLmzURRzMskCmlhAEsV7chd96KTWoLDw7UAy6a+C7q2+IdGKc8pxOi6Pb8c8Ltp+taahnDH8MuVONL6pjprZzTTwAVY/ZAFpDXHBCyLIPJZrLypX8KFB5SrJqM/4G+CTHdvz6AxLCJPeaveTBYvtDOv7gj9e1KoNfmyrmNuu/WHa/bfca0omYsBsYRpdHZPlI6fKzRPbeo4F4C/tbYHjshYBg5BcTICInO7logwchz1wjEiAsHEcp/TKgG0TphJHonyW175AUAkQ4FdurwJ31wpWrE2cuh6TQpfrM0xMeQ7E8m68fXQpV3CUNQLbZxeLhIn2ORZCmMnkK+xp6/30p0wO4wTlVA/S54brLOAfktS3fEpQgN2JjujAa3N7ZNUnrYr4Z3cBRjIMXXmSaAgFqtKZSu03+352wE8vViS3+3E0m6OALRKCVVg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7416002)(36860700001)(83380400001)(82310400004)(7696005)(8936002)(5660300002)(47076005)(508600001)(110136005)(6666004)(4326008)(8676002)(107886003)(1076003)(336012)(26005)(2616005)(54906003)(186003)(70586007)(36756003)(40460700003)(2906002)(86362001)(356005)(316002)(426003)(70206006)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 10:29:32.3255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a051f8c-6024-4abe-afd8-08d9f7808be6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3787
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 include/net/flow_offload.h     |  9 +++++++
 include/net/tc_act/tc_police.h | 30 ++++++++++++++++++++++
 net/sched/act_police.c         | 46 ++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 5b8c54eb7a6b..74f44d44abe3 100644
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
 
@@ -235,9 +237,16 @@ struct flow_action_entry {
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
+				enum flow_action_id	act_id;
+				u32			extval;
+			} exceed, notexceed;
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
index 0923aa2b8f8a..a2275eef6877 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -405,20 +405,66 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
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
+		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
+	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
+		act_id = FLOW_ACTION_JUMP;
+		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
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
+						    &entry->police.exceed.extval);
+		if (act_id < 0)
+			return act_id;
+
+		entry->police.exceed.act_id = act_id;
+
+		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
+						    &entry->police.notexceed.extval);
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

