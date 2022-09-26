Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8232C5EB0A2
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiIZS7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiIZS7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:59:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536479378C
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:59:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RidktdW3U7HiLPtHx4xiHysgVUq2tNfalvnpWcL95gM2bnjRFUVNpVM6eNUeFjNxaFX6RcvfblIp+eEvWx7PBdmpvHT2OLi/4h050Mxu0SvfHwDQWGFmTt3f3Ml9lQGda2tR+zjwH8whHKs/rqGYQiSKZYTLrtMRW0begH2THzD1dmF5tnoTeXl73wbNZe4XbrMoz61iUiux/mKnjYHyTHjyXR2wn3gTk1nYoYOLzhIf55yWcRMnXL0fV317RGokAE0fwNlUk0g3KBb1EmT2mKVKkXu5t+AWAJAMMJpWWVTRQGVz3bOEpGpgsVALkPS2BhSh/iRZRIQSkFNMYANE7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dqe/TV/c3QXfA2LynJz5mnrDA5JkxuQjTacFnKhFc70=;
 b=JbGYfANadZJkL9zgQ3anaT3syrItrZKvFrSHaW5n1YtaiSUHjgT46Y6oNzvJs/0FEjVbF72xCuJnmZcMDSUHzjwkrX1F1xURbtuFYeRxqbD0/4tiNpTrCTTJEEH8H5qKubie2oqcrZ3nD8Kfy9ZHbpNn6ztW18AusCdekREzRv48F3lYWhGU927+ypgFSD9qXM63HJVzpDv0Y/wgfqeBtsfSw9x3cc5hFm5fHPk6zgTU8D1nF511XxL/0n1matgbGs/PbnBrKymWvLD4l25q+v9y0U1kTKNSnBuIxnQG0nkl+vO6vhNxv/Tj1MW5UvazThjn9aFc/WT5ayKPBrNVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dqe/TV/c3QXfA2LynJz5mnrDA5JkxuQjTacFnKhFc70=;
 b=rnisTM9Yxqv709qE5W80dTFePt0W9Mk7JmCUV44NK+xb/43KOuzn3sS8CU7v31N0IR5G4zqiueCQJhqKkMmeaDhqP7+aggiPvjS6WmJK6XaM++Ur9buCRweyZ1ObsGq3q5u8p1s/jvfdbosizzUL1TzQ7MWX5GPO5+XnQIiBqlsTFEtzZMbgkRFJ0sFKQFTo6tsL8ZlO1pZUSt5DnssJar7r0FgpUBd0Ih7cIsiwFiiQqGAjJ2mAvYyOmGEIh4Q0x0RqWnV5auFqPTrEYrP0B2w6UBUqke2SQ4ma2wVQ3zndS+w77dwNYI2/DO3f0upEIZHgsDkz3tDxzpKkgjWyPw==
Received: from MW4PR03CA0010.namprd03.prod.outlook.com (2603:10b6:303:8f::15)
 by PH7PR12MB6489.namprd12.prod.outlook.com (2603:10b6:510:1f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Mon, 26 Sep
 2022 18:59:05 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::8c) by MW4PR03CA0010.outlook.office365.com
 (2603:10b6:303:8f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Mon, 26 Sep 2022 18:59:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 18:59:04 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 13:59:02 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 26 Sep 2022 13:59:01 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 2/6] sfc: bind indirect blocks for TC offload on EF100
Date:   Mon, 26 Sep 2022 19:57:32 +0100
Message-ID: <ab4982b63f36f8b0522f412cc349025f1231517c.1664218348.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1664218348.git.ecree.xilinx@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|PH7PR12MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 729e9627-adc5-4d19-2431-08da9ff12ede
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXWaK1Wy9r7moevxMKOvtBCyfR18LHeNIxeOnP0UuRTajjwX0v9tk5RUuqp44s8CsHarI9TzKnJxbhYg2J4Gy18AJobaBsviuoErIAv8iIOcncrRbSOOJD+P0/he5/ovSw5tjCrTQjFFPTaNj0W9g6qTZO80zT2Us+jyT9y6MiVJVYi6PRpjE7ytmfa/UaxNKgyuRNPiSlwXUGhPpabK/ilsuabu9E5kg/cMvlIg7+EskBhCl0ItWC2p1qDZp3e3qm5jgAbppDl9gfamas6BRCpdEzYbakwLcypGwZ0EnXH6luSbrQW4kjIgSTavYQ2IkXAMVvJgKFh3TEEs5J5WgaRqve+79Uugx+PjY1WBhIxcWtERizS8rKiH4DWffK26Q5JpQNYRRGEsLqxY4UWhMd/gk9wZEdVlP6zYFBEN76NmLEgG0qvwgHWIGwmSFH3lrJlhQ0v8BwC/YXnJKT7727/yceRp7qOyV0DlsnolScQ5Lt0og/c96ypO8g3VWQ617UZBQM6uLi82KUbWZxjj44lXEeQ0HQIzmm2sCkkcH0nmTISNDXav3UVHHM26p+J/i3yd3xu6hTa6ESqoIrp6TMeo648DCJKn6f8pW8/aCbyRtI5tlvO7xZf75wZLuIxx8Sk8zaypmsbZumykAuXPI6vpHi+3LXRhdnrzBR07YYCPzasrmukfKzJLbRpNV9n7kb9Hx0dFQwsjUYXKUnT2CU+Z+R3juKBIsrX1BtKe4aW2tY1+PBg3RMxb0xSYwkxzy2QweURo1jXXlxwpVA2IwYyRsLRhUTrHycDXyPswrHT/RfINFeo8sDXtoBoJO9/w
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(41300700001)(4326008)(6666004)(70206006)(356005)(8936002)(70586007)(82310400005)(36860700001)(5660300002)(40480700001)(478600001)(55446002)(110136005)(316002)(81166007)(54906003)(26005)(40460700003)(186003)(336012)(83170400001)(42882007)(9686003)(47076005)(2906002)(2876002)(82740400003)(8676002)(83380400001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 18:59:04.6872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 729e9627-adc5-4d19-2431-08da9ff12ede
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6489
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Bind indirect blocks for recognised tunnel netdevices.
Currently these connect to a stub efx_tc_flower() that only returns
 -EOPNOTSUPP; subsequent patches will implement flower offloads to the
 Match-Action Engine.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c          |  6 +++
 drivers/net/ethernet/sfc/tc_bindings.c | 73 +++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc_bindings.h |  6 +++
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 23c4325e739a..cb7f76c74e66 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -10,6 +10,7 @@
  */
 
 #include "tc.h"
+#include "tc_bindings.h"
 #include "mae.h"
 #include "ef100_rep.h"
 #include "efx.h"
@@ -217,6 +218,9 @@ int efx_init_tc(struct efx_nic *efx)
 	if (rc)
 		return rc;
 	efx->tc->up = true;
+	rc = flow_indr_dev_register(efx_tc_indr_setup_cb, efx);
+	if (rc)
+		return rc;
 	return 0;
 }
 
@@ -225,6 +229,8 @@ void efx_fini_tc(struct efx_nic *efx)
 	/* We can get called even if efx_init_struct_tc() failed */
 	if (!efx->tc)
 		return;
+	if (efx->tc->up)
+		flow_indr_dev_unregister(efx_tc_indr_setup_cb, efx, efx_tc_block_unbind);
 	efx_tc_deconfigure_rep_mport(efx);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.pf);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.wire);
diff --git a/drivers/net/ethernet/sfc/tc_bindings.c b/drivers/net/ethernet/sfc/tc_bindings.c
index d9401ee7b8e1..c18d64519c2d 100644
--- a/drivers/net/ethernet/sfc/tc_bindings.c
+++ b/drivers/net/ethernet/sfc/tc_bindings.c
@@ -46,7 +46,7 @@ static int efx_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static void efx_tc_block_unbind(void *cb_priv)
+void efx_tc_block_unbind(void *cb_priv)
 {
 	struct efx_tc_block_binding *binding = cb_priv;
 
@@ -135,6 +135,77 @@ int efx_tc_setup_block(struct net_device *net_dev, struct efx_nic *efx,
 	}
 }
 
+int efx_tc_indr_setup_cb(struct net_device *net_dev, struct Qdisc *sch,
+			 void *cb_priv, enum tc_setup_type type,
+			 void *type_data, void *data,
+			 void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	struct flow_block_offload *tcb = type_data;
+	struct efx_tc_block_binding *binding;
+	struct flow_block_cb *block_cb;
+	struct efx_nic *efx = cb_priv;
+	bool is_ovs_int_port;
+	int rc;
+
+	if (!net_dev)
+		return -EOPNOTSUPP;
+
+	if (tcb->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	    tcb->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+		return -EOPNOTSUPP;
+
+	is_ovs_int_port = netif_is_ovs_master(net_dev);
+	if (tcb->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
+	    !is_ovs_int_port)
+		return -EOPNOTSUPP;
+
+	if (is_ovs_int_port)
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		switch (tcb->command) {
+		case FLOW_BLOCK_BIND:
+			binding = efx_tc_create_binding(efx, NULL, net_dev, tcb->block);
+			if (IS_ERR(binding))
+				return PTR_ERR(binding);
+			block_cb = flow_indr_block_cb_alloc(efx_tc_block_cb, binding,
+							    binding, efx_tc_block_unbind,
+							    tcb, net_dev, sch, data, binding,
+							    cleanup);
+			rc = PTR_ERR_OR_ZERO(block_cb);
+			netif_dbg(efx, drv, efx->net_dev,
+				  "bind indr block for device %s, rc %d\n",
+				  net_dev ? net_dev->name : NULL, rc);
+			if (rc) {
+				list_del(&binding->list);
+				kfree(binding);
+			} else {
+				flow_block_cb_add(block_cb, tcb);
+			}
+			return rc;
+		case FLOW_BLOCK_UNBIND:
+			binding = efx_tc_find_binding(efx, net_dev);
+			if (!binding)
+				return -ENOENT;
+			block_cb = flow_block_cb_lookup(tcb->block,
+							efx_tc_block_cb,
+							binding);
+			if (!block_cb)
+				return -ENOENT;
+			flow_indr_block_cb_remove(block_cb, tcb);
+			netif_dbg(efx, drv, efx->net_dev,
+				  "unbind indr block for device %s\n",
+				  net_dev ? net_dev->name : NULL);
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /* .ndo_setup_tc implementation
  * Entry point for flower block and filter management.
  */
diff --git a/drivers/net/ethernet/sfc/tc_bindings.h b/drivers/net/ethernet/sfc/tc_bindings.h
index bcd63c270585..c210bb09150e 100644
--- a/drivers/net/ethernet/sfc/tc_bindings.h
+++ b/drivers/net/ethernet/sfc/tc_bindings.h
@@ -16,8 +16,14 @@
 
 struct efx_rep;
 
+void efx_tc_block_unbind(void *cb_priv);
 int efx_tc_setup_block(struct net_device *net_dev, struct efx_nic *efx,
 		       struct flow_block_offload *tcb, struct efx_rep *efv);
 int efx_tc_setup(struct net_device *net_dev, enum tc_setup_type type,
 		 void *type_data);
+
+int efx_tc_indr_setup_cb(struct net_device *net_dev, struct Qdisc *sch,
+			 void *cb_priv, enum tc_setup_type type,
+			 void *type_data, void *data,
+			 void (*cleanup)(struct flow_block_cb *block_cb));
 #endif /* EFX_TC_BINDINGS_H */
