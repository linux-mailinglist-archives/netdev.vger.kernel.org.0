Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F4F674324
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjASTwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjASTwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:52:01 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70159DC91;
        Thu, 19 Jan 2023 11:51:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAilxmzDREoSAAiRsxf51dfROn8XDq1srPN9Z1OCEvOJYIPNiZVHqFng8mEobftODqbp0yC/eunE9+IScROp547F4u83utniZ4TiHxrlhhmG0fAmndZwP1ar3SrkSfH6+faX7hcm5aLGiSlotLA4oMyX2IOHEg5EUidhe94STVYXeycMPDXW9loG0FIYRXK0SMocpWu2foYObhgkOfB9eKK9j4j1LaslJpeJY0j7umHOotL7doRC9roGZBmK1GrEDjuPl6wDTloM04ckAikayQVPdlC4kORvqdDJvV/uB4668+w/w2mQHwlVkkXn5LmELw+kvKV8jdo2vYQQbvXXiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eVt+c+15jGRhcTXeDwGGa8OjjrApn0DRx+nf2W7K2E=;
 b=jHh93vcsGDQ9rLSC1vvLGwEwAFDGLOllJ+7pR3Ec+1uX/q1NydsRpnqtz9Q6vjV+f1ANILhGIVqISiOJy23px3BzBa27Lt0sJOBlXum64rBcwlY/2fZV9w18ikX8S1uTnEZ11pWb4epvHOZZYXG3wQfensn/ndWIUbPCY2jQcTbITrTtiEhAUVPnG019usTux8DXnQAMIoawe+vTRGOeYKniLJwZCz5cgE5qnd0wUv0nSoHvbw3obYYOThrdQ/PojkQRCM989VSCMJw56vX4pIzxoj/Z+BAtlnTcRzO2PdAgDJznBHJypL9siYBQHxo1ui1XHnHXrHzZJiv1+J3xcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eVt+c+15jGRhcTXeDwGGa8OjjrApn0DRx+nf2W7K2E=;
 b=oz9V9jKxruLb+4BNxg0cpcacKNVv1jv0Yl5zth1fLHiW329CHlaQEFOQ8WMDY1ptRP7gOIMH49CprBXr+rXIw1rrLwfvlyz0nWtZ1oLXpsb5d9erGPcPKVs1aSvXPUUkM+cVSOWQlFUF7jvJIFbF9zbpoeVR+q6rfr34qN8IXVjx15Jf+a647J9DtZSjttfFSHKWcnCXPqohxrIvvUYfzng1YcXRyXaOH20x6GX1oYMglpdpvamWHKpAbBiaCfTgfMeIGIegl3yTHo5trNSXhASCbkHEfRAp4PwSClxa1X/o4WjhrfDi8GRw7odfJ2dtbzhXnvHQGBAElAkrpueYOA==
Received: from MW4PR04CA0235.namprd04.prod.outlook.com (2603:10b6:303:87::30)
 by MW5PR12MB5681.namprd12.prod.outlook.com (2603:10b6:303:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 19:51:54 +0000
Received: from CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::d) by MW4PR04CA0235.outlook.office365.com
 (2603:10b6:303:87::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 19:51:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT111.mail.protection.outlook.com (10.13.174.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 19:51:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:37 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:34 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 4/7] netfilter: flowtable: allow updating offloaded rules asynchronously
Date:   Thu, 19 Jan 2023 20:51:01 +0100
Message-ID: <20230119195104.3371966-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT111:EE_|MW5PR12MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: 6155e195-aab3-4308-0e46-08dafa569d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6NYk2aJC5SM28IRmq7cdL1Z7nmAfeHg1Uh4MxAfymugsi/zxtexP1pbc0g5A3Px6lfb/OnGmv53rd9xTdbb653ouwSuzbGE+xFSC/V+B1NO8FEwm2jdDnRkA+SrQwndYo6z9Ls+g368DH9huzNBm+/zzrusGO7YpNrLnz/I54dPWgCZCICdDUS4If/tBGnucSJjfIEN4xsAZzmdSM9D58ktgNrfQkaolM8HXziyeLHoKGLkY8Qo+oxAsG+yxZ+2LyiIbHPU7+c9kLscXtCy66PHaRBlIo+PFz5gwIRGiO6mYM9HRGmkKAQSq2zQKpzUFbiKI4oX90qXNpoUmof2ZQoQdVcfpBp5c7E+E+Q7Ry0MoTUhOd9gR8Bn/wZS8SBEiSV+veudI5vvhPIgyo1dWHXieTGMU9EgoDf4fpeS6mLS7YZU8/DjaFybgWnM2nUCLFDDn+CVxzUgo8yIP1NEettLBfaeE7lTD5Ukqk/umDaZKEDaznIONDwFkRwJckM7gDgXIZqOs+ekUQPZy1tmBM7bGPNOIYGDV+ma89qmeZse/Zh7tZkrcc2qDrqHiAcpdIFiPOra8aG+oNTMK6GlG/d9KObLreXAieT9FSqaNpURJfeICK03rJR8Qlj5PShfVi/Xk6Iu5eTUiexbHo1w9xxh32EuQV7Y/5nfR9MAedBxpHuNTvtOUOGuBY9xKwQMnUCbaaU83+J/B/poG5Y8tbCnPatXRFCfKEzPGSA6NmZ8=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(36756003)(356005)(86362001)(82740400003)(2906002)(70206006)(7416002)(8936002)(5660300002)(70586007)(36860700001)(7636003)(478600001)(316002)(6666004)(110136005)(426003)(54906003)(107886003)(7696005)(47076005)(40480700001)(8676002)(4326008)(82310400005)(41300700001)(186003)(1076003)(83380400001)(26005)(336012)(40460700003)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:51:53.6571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6155e195-aab3-4308-0e46-08dafa569d35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5681
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following patches in series need to update flowtable rule several times
during its lifetime in order to synchronize hardware offload with actual ct
status. However, reusing existing 'refresh' logic in act_ct would cause
data path to potentially schedule significant amount of spurious tasks in
'add' workqueue since it is executed per-packet. Instead, introduce a new
flow 'update' flag and use it to schedule async flow refresh in flowtable
gc which will only be executed once per gc iteration.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h |  3 ++-
 net/netfilter/nf_flow_table_core.c    | 20 +++++++++++++++-----
 net/netfilter/nf_flow_table_offload.c |  5 +++--
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 88ab98ab41d9..e396424e2e68 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -165,6 +165,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
+	NF_FLOW_HW_UPDATE,
 };
 
 enum flow_offload_type {
@@ -300,7 +301,7 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
+bool nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 04bd0ed4d2ae..5b495e768655 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -316,21 +316,28 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+static bool __flow_offload_refresh(struct nf_flowtable *flow_table,
+				   struct flow_offload *flow)
+{
+	if (likely(!nf_flowtable_hw_offload(flow_table)))
+		return true;
+
+	return nf_flow_offload_add(flow_table, flow);
+}
+
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
-	if (timeout - READ_ONCE(flow->timeout) > HZ)
+	if (timeout - READ_ONCE(flow->timeout) > HZ &&
+	    !test_bit(NF_FLOW_HW_UPDATE, &flow->flags))
 		WRITE_ONCE(flow->timeout, timeout);
 	else
 		return;
 
-	if (likely(!nf_flowtable_hw_offload(flow_table)))
-		return;
-
-	nf_flow_offload_add(flow_table, flow);
+	__flow_offload_refresh(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_refresh);
 
@@ -435,6 +442,9 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 		} else {
 			flow_offload_del(flow_table, flow);
 		}
+	} else if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags)) {
+		if (!__flow_offload_refresh(flow_table, flow))
+			set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
 		nf_flow_offload_stats(flow_table, flow);
 	}
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 8b852f10fab4..103b2ca8d123 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1036,16 +1036,17 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 }
 
 
-void nf_flow_offload_add(struct nf_flowtable *flowtable,
+bool nf_flow_offload_add(struct nf_flowtable *flowtable,
 			 struct flow_offload *flow)
 {
 	struct flow_offload_work *offload;
 
 	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
 	if (!offload)
-		return;
+		return false;
 
 	flow_offload_queue_work(offload);
+	return true;
 }
 
 void nf_flow_offload_del(struct nf_flowtable *flowtable,
-- 
2.38.1

