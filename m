Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964C4679B07
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbjAXOEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbjAXODv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:03:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F7E135;
        Tue, 24 Jan 2023 06:03:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSYieJRchEwxqWe1d2Hlhmwx+Di1Pkq05Bm9H6aS1UY9rZ6le+GxHfauQtzUsB1seczfL+gm8CbWz11oQeT7Z0QTu7EThrV+OSO6o/frcIqqC99f3ILeynOcubg3T1Eit3nvaWVOfmsabgioX2xcMzq8gYXZkO3XkIlDOdkT5NmrVG8hwmBU4ricXUCafawBuPy4XJLtEzZ1CeXQXBnyDhb1GMJisVhwz4z08g+llNk6td2TbZRAV3FIkS/sIiUE07TOEXVdGLPJstau/fyOYbThwsq09PNPfD10id4Gh6Lm2BmDHgTIqYpMtqXGEL+XP4M9wUYJslJfvqDFuFH0aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MqW2wuBqP+NUSb1oqVUHY/8syLIRcYnfLrWqhyD3oQ=;
 b=RruCAl0QkWIXrwLWFMg85MHhYdbBLFhzNIkaVJuuD7hLcQU3LTusp9VqCgJwQcCL8CtwS9inWckS0U77CZIKcoqRbQhTq0WyCvHAikuigQNH18S7s+nU02z399HAU9jWJFWSI3JIXfVdO6fqLUTnksd4WRgS+ZyrfVO2j+14RvVXKQaGtxx9F+L/grWQuNdfd4kNLgWP7/8e0KkiwRmsR6ZI7O1B8wRiN9PSSmVWk8d5Nm2cweczuoe5bzh9ea/1OF9anDvNpmNlyWWK1I8dsf61tgUs5F/JwyIbmwLOXMUk0Dsibn1b9HguaTlvDRgwTgC+zuEZAzl9XLdArgEJ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MqW2wuBqP+NUSb1oqVUHY/8syLIRcYnfLrWqhyD3oQ=;
 b=LJL1NiafPFWHhLByV6rNdRqBgdGenn4EsPWXbNE2lMJfH4Uiy6C+VNcDXHTWORlJavna/OdGxpE94tGm3aCvfzDdw+NmF/ScennTYuYztAr2U6CCcUGv3s+7oW3cdFk23cdiYgN08QbWmjMotci0gEF7Upm68GQAtT6WNPOfmECzQkgEtHPWhJ0XtG0b6HJ2SZPWmfYCRY/yc9yEzjqpVBQMR5kV1iCZ4LyW7kLJWv+f4RT0u9YqwwjxGSg/cvdPfBlJ+TMGfNWWQuYt2LkurvGJrdiYocoGihholfGN1/jbgz2RwT9pWPZl2emxC8sWOAgjCDFY2YXDtyR8OfkcRg==
Received: from DM6PR14CA0058.namprd14.prod.outlook.com (2603:10b6:5:18f::35)
 by IA1PR12MB7760.namprd12.prod.outlook.com (2603:10b6:208:422::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:03:21 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::54) by DM6PR14CA0058.outlook.office365.com
 (2603:10b6:5:18f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:03:20 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:04 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:04 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:03:01 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 4/7] netfilter: flowtable: save ctinfo in flow_offload
Date:   Tue, 24 Jan 2023 15:02:04 +0100
Message-ID: <20230124140207.3975283-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230124140207.3975283-1-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|IA1PR12MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: b25a715a-b0b2-419d-9713-08dafe13bfdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Qlfzg5s0TzziKKi/qs2Y1TQk1ao/h6izdAO/iitXq5uBcmexfAaVLmUrjFUXVzWYL1tBLPq0vadgVfSbsc5BtOKYpYxkYqzeZ0gkyxOzFy/jUtRyD7qnvKY1EgeG9miWaeZvBTxlgN4093wcvzrT6IzQy1SxIJ2/vwEYauvc8AXbxX0Ogj5SJUWww2xrRyWVgyCzKX+XEGA1GxXncTA/ZNxTy2DKANBYPPcbjA6I8bWbfYR3oltvRxUpSCLCIs7IFxX0gN2dbxK9/gvn9sNu2j4PCC0JF1JuKFgH9U4Rliaom05JMEwwYXcuOL3scyIwyFeN+SxvFuZV390uLmNUhIjspDj3g+WqI/uQ9tP8ETW8i5J1k55KwGA66hogDfbcLo51Cro/N4AlRMzYF0Ky2QruyWhMpeM05+v7MYuh8YB/VzjyX2hRWK2fIVJeUsy5NQly9U+QB03+vHUwsJmKDEXmkspPl3MgNxCByRN33EmzO6kQBY+iEHZJ1RpQdnBko7N3VK7GPa/CNMgCV44OkCU2ZCNsw4gfCnRHQ05yQ6BPGKMr0Laivt0/EgxA+iaA7cFEeiD/xmLsCVSgUZTnksgyFANwf5IIgPiPf8DcsF/10wsZe/YUAHBDLZYJf+f39NvVeKdCDIcV7hkJOpmjFdbuMExzMPheVwXZyuozKUoBKnKoa9XMMN+pu/zIFYzoeGSsUFA3XrQ2PxtcTbKD1GgDjAcl917ckNlzIdjf3s=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(86362001)(5660300002)(82740400003)(7636003)(356005)(7416002)(82310400005)(8936002)(2906002)(4326008)(41300700001)(83380400001)(36860700001)(7696005)(478600001)(110136005)(186003)(26005)(40480700001)(8676002)(40460700003)(70206006)(316002)(70586007)(54906003)(2616005)(1076003)(47076005)(426003)(107886003)(336012)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:20.1431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b25a715a-b0b2-419d-9713-08dafe13bfdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7760
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend struct flow_offload with generic 'ext_data' field. Use the field in
act_ct to cache the last ctinfo value that was used to update the hardware
offload when generating the actions. This is used to optimize the flow
refresh algorithm in following patches.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V3 -> V4:
    
    - New patch replaces gc async update that is no longer needed after
    refactoring of following act_ct patches.

 include/net/netfilter/nf_flow_table.h |  7 ++++---
 net/netfilter/nf_flow_table_inet.c    |  2 +-
 net/netfilter/nf_flow_table_offload.c |  6 +++---
 net/sched/act_ct.c                    | 12 +++++++-----
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 103798ae10fc..6f3250624d49 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -57,7 +57,7 @@ struct nf_flowtable_type {
 						 struct net_device *dev,
 						 enum flow_block_command cmd);
 	int				(*action)(struct net *net,
-						  const struct flow_offload *flow,
+						  struct flow_offload *flow,
 						  enum flow_offload_tuple_dir dir,
 						  struct nf_flow_rule *flow_rule);
 	void				(*free)(struct nf_flowtable *ft);
@@ -178,6 +178,7 @@ enum flow_offload_type {
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
 	struct nf_conn				*ct;
+	void					*ext_data;
 	unsigned long				flags;
 	u16					type;
 	u32					timeout;
@@ -317,10 +318,10 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
-int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
-int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
 
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 0ccabf3fa6aa..9505f9d188ff 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -39,7 +39,7 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 }
 
 static int nf_flow_rule_route_inet(struct net *net,
-				   const struct flow_offload *flow,
+				   struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
 				   struct nf_flow_rule *flow_rule)
 {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 8b852f10fab4..1c26f03fc661 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,7 +679,7 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
-int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
@@ -704,7 +704,7 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv4);
 
-int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
@@ -735,7 +735,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 {
 	const struct nf_flowtable *flowtable = offload->flowtable;
 	const struct flow_offload_tuple *tuple, *other_tuple;
-	const struct flow_offload *flow = offload->flow;
+	struct flow_offload *flow = offload->flow;
 	struct dst_entry *other_dst = NULL;
 	struct nf_flow_rule *flow_rule;
 	int err = -ENOMEM;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 861305c9c079..48b88c96de86 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -170,11 +170,11 @@ tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
 
 static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 					      enum ip_conntrack_dir dir,
+					      enum ip_conntrack_info ctinfo,
 					      struct flow_action *action)
 {
 	struct nf_conn_labels *ct_labels;
 	struct flow_action_entry *entry;
-	enum ip_conntrack_info ctinfo;
 	u32 *act_ct_labels;
 
 	entry = tcf_ct_flow_table_flow_action_get_next(action);
@@ -182,8 +182,6 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	entry->ct_metadata.mark = READ_ONCE(ct->mark);
 #endif
-	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
-					     IP_CT_ESTABLISHED_REPLY;
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
 	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
@@ -237,22 +235,26 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
 }
 
 static int tcf_ct_flow_table_fill_actions(struct net *net,
-					  const struct flow_offload *flow,
+					  struct flow_offload *flow,
 					  enum flow_offload_tuple_dir tdir,
 					  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action *action = &flow_rule->rule->action;
 	int num_entries = action->num_entries;
 	struct nf_conn *ct = flow->ct;
+	enum ip_conntrack_info ctinfo;
 	enum ip_conntrack_dir dir;
 	int i, err;
 
 	switch (tdir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		dir = IP_CT_DIR_ORIGINAL;
+		ctinfo = IP_CT_ESTABLISHED;
+		WRITE_ONCE(flow->ext_data, (void *)ctinfo);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
 		dir = IP_CT_DIR_REPLY;
+		ctinfo = IP_CT_ESTABLISHED_REPLY;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -262,7 +264,7 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	if (err)
 		goto err_nat;
 
-	tcf_ct_flow_table_add_action_meta(ct, dir, action);
+	tcf_ct_flow_table_add_action_meta(ct, dir, ctinfo, action);
 	return 0;
 
 err_nat:
-- 
2.38.1

