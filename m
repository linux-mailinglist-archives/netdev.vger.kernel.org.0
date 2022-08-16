Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BB3595768
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiHPKDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiHPKCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:02:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B88426CA
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:23:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elB0dvRqm1ggtowGrN79bRc9+2UArNK+DnzmjoYU6mzdFF3sy2RVn+2JQAhJf56F//4XomCgwte5Loj4VujHc74AkYvMjko3EMNti6UV0bxe0KOJCmaI50J2zt2KtlRNKvMQmrK4De5PZfBuSltrT8lS1oP/HVAsM/BmVd+UmiORmMlDXT0JHPgS2+lWs3tFqDiNqi9gn6dMTY/ytT94+X175IPCXgkirh09NcjwqS7OgQnOeMJzHK7oY6GcGCTeDdnZ/vHrqCjiTTmsh23E/N76JmiBeWm/9kq+1ZOwCjumxZWEQ+tKlKr62eDgS4aSUMmbIDOvMWRUrJNL/iyyIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/HFa6NCIKGXFBczvz7CBa9ojBGUJfxX+qcO62e5xVc=;
 b=e41mfm/4ccl8vlPoiOefAkQusDP3b3cKycQqcO14vCR1AfEHeYJp+S2sr/Ppznv1MTufMPbcoJgzX40tVQMs64gDWblz9YdcT8k14Bw5XxpZAjT0RhQH50r4RnydWepGw/Gedou3NTm/xjiBcUpSOI+3m4XHavBGEnZ6nk6nz9tKFwZRlwhi5WX1gkEkedbVTJagoSrCtJONB6Cx/UZTyYXwS7EK62yszJBV4Div90hn6v1A4S5d4UNpLqq9vCMlRaBDmPKNHREzWEtfKrLMRBNd4Akl3uc7IwiqdpYgAUKzwgSw2aNHY85qg8XT6UYf8asx6wgn+nadVfWiWxUxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/HFa6NCIKGXFBczvz7CBa9ojBGUJfxX+qcO62e5xVc=;
 b=hbSU7/bxqtTMkJVtg0EmlKjNq5FnayxKDUrll17WNHteT8iQWHTY9owKzkSMRBIF7TNAevPzhidtAncgwbsLhzSZ72Rp9doUt/BkEloCWZ4Vs5LsYEKOcbpKrI7eDWCc3uXowOxhqHIePeqTRJa1590/IdvZk4mvlDhlaZccx5rtnVr3c6PrA/VHeuG6RXX9sxrNF+1IPOwKEgB3ptrxITQ8eVB340OmsetpBCahfVFkv/XiJLwpABPTWhR6I+iIkXkMOmuEMGAmXwu6Ej4Cmz2dVpoqpIdXYHJvj7N9fLvXklkPb5RkYeI0P4ybk/XtGRm+woeqwtOFI+8Q/edJiw==
Received: from DS7PR03CA0305.namprd03.prod.outlook.com (2603:10b6:8:2b::25) by
 BL3PR12MB6642.namprd12.prod.outlook.com (2603:10b6:208:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.27; Tue, 16 Aug
 2022 09:23:53 +0000
Received: from DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::bb) by DS7PR03CA0305.outlook.office365.com
 (2603:10b6:8:2b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.16 via Frontend
 Transport; Tue, 16 Aug 2022 09:23:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT084.mail.protection.outlook.com (10.13.172.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Tue, 16 Aug 2022 09:23:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 16 Aug
 2022 09:23:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 02:23:51 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Tue, 16 Aug 2022 02:23:49 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [ RFC  net-next 2/3] net: flow_offload: add action stats api
Date:   Tue, 16 Aug 2022 12:23:37 +0300
Message-ID: <20220816092338.12613-3-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220816092338.12613-1-ozsh@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6e96679-e7a6-4448-3f2a-08da7f69095d
X-MS-TrafficTypeDiagnostic: BL3PR12MB6642:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LTA8FaAOGwy38FrH2bpvYh1TZ5WUJPJppCegG6w22VtF61/VTdvNFUlb0wF8ucVHm0U7PtdkxNi/Ha6ykwkGaZedS/Dq9YObIpcjmewU7oFfiqWfsMyNKxS1pFIH5W6LBcRvxzfTmX58IlxhdIKniu9B69zvwvjnF0KUeubkjBnbXx9WjEqHIZ+nAqBbBVe4rXp0sPEVGGaesSpCfQl+cOGYojcUaJtaHUApr++VxJw1PRX2hlQzBd9epvb24/1ZljFb6tbClsc+7/SHFwA+FbcduzRYkWeFxaILj20LmoTqLMwz8PbdJvB9RTKLbPZUB4v/o0++GjFijx6s/t9qxGxupvXc+57S9ghAHftzahjSIIBosK2KM3vQLb0CZzSWNs4Xsoehnt3w27wD0tr89jljYa5Q0TBf2YArOlV3RueDk6s/1WTnUMTaA4VdJUsKpSbiYHUOHhi2DRIlfRHALNP8TcHIiy6tr5V7JfO5rV29JKTu36+vB79XuJmQZh1S0K5YnW6xP8zoGp7HVnKLU+O4rdt9+AUVogaxaoDXZ1VDMDOi0s/D327rNn4qMCbPxrFSTvbZ/DnsYce7hxua5oSP77tPfZ5qWiYK5apLovkVuKpLzc3ht0c/mYOJFjdrtpJhpRG1NkPQlxcuapvhJA21Jnzc17GFwGu6f2rZlyM/yCr9J33RkSxyyN09zW+5cFhU8JCXltHTfkN4ekZ/PE8a91WPhjwhVZemQ90gxkjfUh0PAJQa3n1DZnMx2T2fkNkwOv8Ewm2QKjayDlZw+nD7L4yN96LFQroa886RLbyrHbgUKet7tnyvjRpl1VeeuAmpMUecSeocV7LHU1x4yQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(40470700004)(46966006)(36840700001)(5660300002)(70206006)(107886003)(40460700003)(82740400003)(8676002)(4326008)(356005)(70586007)(81166007)(336012)(2616005)(1076003)(47076005)(186003)(426003)(478600001)(41300700001)(26005)(6666004)(316002)(83380400001)(86362001)(6916009)(8936002)(82310400005)(36756003)(36860700001)(2906002)(40480700001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 09:23:52.9871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e96679-e7a6-4448-3f2a-08da7f69095d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6642
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current offload api provides visibility to flow hw stats.
This works as long as the flow stats values apply to all the flow's
actions. However, this assumption breaks when an action, such as police,
decides to drop or jump over other actions.

Extend the flow_offload api to return stat record per action instance.
Use the per action stats value, if available, when updating the action
instance counters.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 include/net/flow_offload.h |  6 ++++++
 include/net/pkt_cls.h      | 26 ++++++++++++++++----------
 net/sched/cls_flower.c     |  4 +++-
 net/sched/cls_matchall.c   |  2 +-
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 2a9a9e42e7fd..5e1a34a76772 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -436,6 +436,11 @@ struct flow_stats {
 	bool used_hw_stats_valid;
 };
 
+struct flow_act_stats {
+	unsigned int		num_actions;
+	struct flow_stats	stats[];
+};
+
 static inline void flow_stats_update(struct flow_stats *flow_stats,
 				     u64 bytes, u64 pkts,
 				     u64 drops, u64 lastused,
@@ -583,6 +588,7 @@ struct flow_cls_offload {
 	struct flow_rule *rule;
 	struct flow_stats stats;
 	u32 classid;
+	struct flow_act_stats *act_stats;
 };
 
 enum offload_act_command  {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 27eac9e73c61..f5e5582aef17 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -269,24 +269,30 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_hw_stats_update(const struct tcf_exts *exts,
-			 struct flow_stats *stats)
+			 struct flow_stats *flow_stats,
+			 struct flow_act_stats *act_stats)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
 
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
+		struct flow_stats *stats = flow_stats;
 
 		/* if stats from hw, just skip */
-		if (tcf_action_update_hw_stats(a)) {
-			preempt_disable();
-			tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
-						stats->lastused, true);
-			preempt_enable();
-
-			a->used_hw_stats = stats->used_hw_stats;
-			a->used_hw_stats_valid = stats->used_hw_stats_valid;
-		}
+		if (!tcf_action_update_hw_stats(a))
+			continue;
+
+		if (act_stats)
+			stats = &act_stats->stats[i];
+
+		preempt_disable();
+		tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
+					stats->lastused, true);
+		preempt_enable();
+
+		a->used_hw_stats = stats->used_hw_stats;
+		a->used_hw_stats_valid = stats->used_hw_stats_valid;
 	}
 #endif
 }
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 7da3337c4356..7dc8a62796b5 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -499,7 +499,9 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
 			 rtnl_held);
 
-	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
+	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.act_stats);
+
+	kfree(cls_flower.act_stats);
 }
 
 static void __fl_put(struct cls_fl_filter *f)
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index b5520a9c35e6..0ba4392b93de 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -332,7 +332,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
-	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
+	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats, NULL);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
1.8.3.1

