Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E86A68BF25
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjBFOB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjBFOA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:00:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D26B27986
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuqyXHiO73fYHYL2dQfZz3if6o2jbO6zN3o1LMFwRkvzz4K4FJTZGvCJnYZw/H5dLfyF8NmdtJm83h+gTlYZN5y9RQTdzg/czBUQRS3OMZ4E5afwKxRz2JUUXqDsgpGGquei8IGuRcoAJyhlSei7qA1+kw/Xp+iwTY/ckUHpSG4DSgTtf7WQFk17YeivJC41jtt902p3U/zCNXWJm9cfjxre2X6QODZp8oMbiBmppFdmnrparDxcDaXOQ4kodOpY719dBQ/gE8bEXj0PjCBFIAIslW44EZP47XfKJNdbT7K5J6Ui5ftGJiBe5sAhrDvp28o5pFwWxNAYI3t2HeRUhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+7YDjkoSoU+0wJnvoF8VMfGYxl7O4Sl4bRE4vm0nK8=;
 b=neKAVNN4iJuj/+4/stdpE7ztph5qGuUSSmOTcalKnPCIZCy7vBMXF8TPU83Gmx64pyOEnewGn8MUd/JamU0Z/0a9aW43s7SHxK9Nc3pbjDzV13iGgKutHhGZR2ARVsnfMfakQ3Cu/4G79vU+Y/PodeXmU4mxWRaBGzTB+Z+4jJbyX9cgIAMACTjGmneHmAUj0T/cEzDQW3GXTHFmEcwxZ5vP8XSekUDm9AYqsVANXQ3miQp1o9pj8f8itJ63U45Ale+vQcRgyhAFS6Q+WPKE35BzKMslCu3T43bCDs1/kPqvWCXfS+tmAB/k6svYoBr1T7x+uR8VvnahKtPfdRwlwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+7YDjkoSoU+0wJnvoF8VMfGYxl7O4Sl4bRE4vm0nK8=;
 b=P5sxwPgVqrfKdlb70FLYcMJP0lzvDdBdIcGMHVj56dJZNCTLAmPyFZbmJMmZMOjzgXY8jYe0WpKt2wJq3J1w7eLiL4QgMC14Z6/KydWnqvubGWrd7n2OvmTx44+cSBBUaQsokY1JZ0Nb/pkk5Eo4NIeBeTKXAi+UDLlyn/7rX2j85Wmuq4jWwLCemCGXiw/ZgfRRO/j00oGcYfjDTQudwiZpUOdDqz7z69mxHn7tO4L4ohYOeHB3FH+dDNkwQB3DLnW0n8IbZMXb4qth9E7CkfKHrZaZS77SdlZ7I3ZcV658nnf5cv0H84t3kebaZY5ydqytSnrxIJY6tDwW1gAZtg==
Received: from BN9P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::30)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 14:00:32 +0000
Received: from BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::2c) by BN9P220CA0025.outlook.office365.com
 (2603:10b6:408:13e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT094.mail.protection.outlook.com (10.13.176.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Mon, 6 Feb 2023 14:00:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:16 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:14 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v3 4/9] net/sched: introduce flow_offload action cookie
Date:   Mon, 6 Feb 2023 15:54:37 +0200
Message-ID: <20230206135442.15671-5-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT094:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: a86a9688-3b49-4a64-5d13-08db084a8300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nB97b3Zg8zOlkg4k8z4Rcr13hTMywDbd0dasKHjiwJp2FGvQOVgH4SliNfs4Wtm65FFRYQyHjf/kGGFcRTIsTGvb67HY6z/RSILWe+reW3ZL55gzYy1jBfQE8OOuXAegy/uWpu05scq9jhJ5iIMZlW+W8DFbBp2yD3L/tE5H3lB+MBi3R3h66XN4wKZ9+lkXkg9H0H3H6EXV4NYk+t4kjCKS6XWBrDplfKCRZ9uwj4aGnTNRQFuTw4wKMxqdViHmBPMwOSAm+MkjW0BcH3T3vP/YvadytkW7HuftgdlkjgDUAoA2PEnXxUcXsyQDGH6brYthc6RG2U0PY6Cs2tzQxFr0PtmZwnVHBpTFiPfV3oNKWQJYM6igsF3iyWZxnDnMPHlIAWmoHjWSq9YG5gHe+ucMTNqBAWZoTtvKUHdPE9QHprqoOyHFQDbmExi209aIc3PxNhk2qhF4vw18h0Qs/wqW8z/DRQed1rGFXUvvueDxoAeDiwx59lGqmNWKVpEi3bRWyhw1GFE1WNWdasR09K+ud2KhGTPqizDwQ9Til4LQNLvsBVyzywNSX+QR6DyU3UnvAHOTZMkQ8CT3CxuGKAUkqJZl7xDbq5XHZrS4+6uMpeVOGW9NDZL94eDaf3EeafJiCDdDN4BW+0858hrFq13ZR3mHMLk7hYDst5VvPGK+TqUFCh8wNSTvhyZYD2nqb7MGuheVZc7/cLwlJU2+oA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(107886003)(316002)(6666004)(54906003)(478600001)(8936002)(4326008)(6916009)(41300700001)(70206006)(70586007)(8676002)(2906002)(5660300002)(40460700003)(82310400005)(426003)(40480700001)(26005)(82740400003)(36860700001)(7636003)(83380400001)(2616005)(336012)(186003)(47076005)(356005)(1076003)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:31.9467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a86a9688-3b49-4a64-5d13-08db084a8300
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a hardware action is uniquely identified by the <id, hw_index>
tuple. However, the id is set by the flow_act_setup callback and tc core
cannot enforce this, and it is possible that a future change could break
this. In addition, <id, hw_index> are not unique across network namespaces.

Uniquely identify the action by setting an action cookie by the tc core.
Use the unique action cookie to query the action's hardware stats.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/flow_offload.h | 2 ++
 net/sched/act_api.c        | 1 +
 net/sched/cls_api.c        | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 0400a0ac8a29..d177bf5f0e1a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
 struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
+	unsigned long			act_cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -610,6 +611,7 @@ struct flow_offload_action {
 	enum offload_act_command  command;
 	enum flow_action_id id;
 	u32 index;
+	unsigned long cookie;
 	struct flow_stats stats;
 	struct flow_action action;
 };
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f4fa6d7340f8..917827199102 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -192,6 +192,7 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 	fl_action->extack = extack;
 	fl_action->command = cmd;
 	fl_action->index = act->tcfa_index;
+	fl_action->cookie = (unsigned long)act;
 
 	if (act->ops->offload_act_setup) {
 		spin_lock_bh(&act->tcfa_lock);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5b4a95e8a1ee..bfabc9c95fa9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3577,6 +3577,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
+			entry[k].act_cookie = (unsigned long)act;
 		}
 
 		j += index;
-- 
1.8.3.1

