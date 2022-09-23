Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE25E84DF
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiIWVaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiIWV37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:29:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EF62ED4B
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:29:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMiRZWjluzfd5ls3Mrku8gXd/Hpwp5WLLxevBEQZ0pzNrGUEjJCwjyTdydtKdLmYO3wcxIeW+Ubn01zoRvRIjjRACPShuBrHY7vCGIqj9MIDPy7uCXH8GfuvN3J6VqwiUOOSN5nioiXXqOxNhnl934drQGO1mW8fNi4hGI8EiDWHuBL8A8qR8AGg4J81pwvFSLFqnN+r5ko6mSivx+WoeYWQSr6mWIzq42sZdZss9+tu4DwJiB8R58fP9XomVw5UJK669WUCG+6JhxHLsAyNzTj51qOWJAs98qV2nL8NCFyM7YRf1EhSEz5ADcgi+NG8T7ODcKq5aScA6+RApeT3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuT/B0K9UaTVTbREHZVG5emDk1kIh2KnqRgxj1y0U8U=;
 b=NRqXv0SPZ37PnFu2KnscGy2vr3y80H3T/71XGVg7cvR2GfvS0XTqXZ3GDZutr3e3uVaGYfrLavMNylUC4sVx072LahqpIyOAQDfWlgbWGdUgocihoG484JX4TD2hQFv00CTCjKTyCMJTWeR71s7kgdPdasF5mu/jJtbnHeLIOlVWv0RnV5rfXiMjNz2fj9edmaRgn9cWUBL/23IHwQZndUgD7ROBu/7yuV49Y0ordFc8G5RB3L98Djpxate2Jj2iHV7EDhJZvRSmUrnE+qgEM3SAbThVSMiNxgzk2ZyjtGcGGDNIf6GiBz/hrbZsCfvBMYDWKPWh+WQx90wJAstavQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuT/B0K9UaTVTbREHZVG5emDk1kIh2KnqRgxj1y0U8U=;
 b=gXJm/l6HStnJkGfIlIAuC8GAxkL1f6/sIjh2vrLxvqZePinhIVUwHek5RYWtHBLLEWZVkPbI6suVNN7pDKfhmLkeHRmQqzzFixKL8wimUow5jRKObdFY+eDGn7K82CPKBYz10Na6W2M/zgdc4y1P6cJMnq5DLmlIeHuOx/h/3L9Wu4KWiyn74xP8IxqxQe5r2lUahCEOIXnWTPTqw4r6xC86ESOYeRzxjmaEQdVeRtknD8rpEauocoIeBnhY540V6+a9MeO5EvZeaueCk7h00/FEO2ZRrwVDcmCKbH8z5uE0OOFxC5Y4/OJSJ/BRWG+OJgP29OWN1OPKd7Ii3uBN6A==
Received: from BN9PR03CA0146.namprd03.prod.outlook.com (2603:10b6:408:fe::31)
 by PH7PR12MB6635.namprd12.prod.outlook.com (2603:10b6:510:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 23 Sep
 2022 21:29:54 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::5) by BN9PR03CA0146.outlook.office365.com
 (2603:10b6:408:fe::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 21:29:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 21:29:53 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:52 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 23 Sep 2022 16:29:51 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 2/6] sfc: bind indirect blocks for TC offload on EF100
Date:   Fri, 23 Sep 2022 22:05:34 +0100
Message-ID: <0434e16264797baeaa66061e8078603e0e168187.1663962653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1663962652.git.ecree.xilinx@gmail.com>
References: <cover.1663962652.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT018:EE_|PH7PR12MB6635:EE_
X-MS-Office365-Filtering-Correlation-Id: 5488a946-fdba-4c97-b811-08da9daac111
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3THZtuWk9tFiLGBYjqwwqi+5JEeIyGEB359McqQl42+Ko1J8UUY4KKZF94OGx6RuHP0O0ZSh8fneevbtefqj0j2DsCrSicWEl9U2OSrO8lq6iw4PiUi82oZIuRgRjZOY++od+74dy1HD3eq96LSfyIjPmOE3IOgw4IDC6CmBiyA/maCOFf78r4CrMoEsxaye6koT7MbdksF51s2SyVPcuZgvRxPhXQjv8oacs4/sLW/9xQ40ikOZ6YK21RkUxT049WWKZ9Q3l7xXvUPOIcsq/URPT1SomamOICWWRzoEPi6uJHD70sD7xdLXeVk/V7IASQXrrnA2CT8SdGKu4KC4EwBqwWDqod3gndlt0jO/GRVZjr+exIZPCO+VO4DikCDKJErxd6OY4zePaRJDUuXNVtj/Jp0icqPnOpcgoVF4YfwppTeRPLSMMkVF0u3+6ntLwv1F0MWdK3E6U/VGPKObzR90iIVyawUeoNgP60gefZvwCrJRdhFepr0pf6y637nhVkaHApF3pBQMIBumGcYEdikbHFeTb5VQQcxcqFxQxZDJRdAsc7rXCcSJHYzAdw+bFDaQ5uwy0dFQj+OIGt81nt3thdJQsxqJbIO0T4tV6iOjGdRvzIwbulzBgRccmHBMQMKiCqaRU7Iazsvyj0GMcU8wMc+kOYSthW0vruGgWrRDyImC6OallmrB33z6eKj94TLLFmP7CROaexc+R8O9B29L8XM6pkqDAfTVxyQOaUFwbbmzZU8W/slhtCTrbwdMcaDVRTnBVBGhQn0SJgkL20Ad9pQH/5R1YuQ+WczbJz0XshmNbD8FtiRi05NvR5b
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(81166007)(47076005)(336012)(4326008)(70586007)(54906003)(82310400005)(110136005)(55446002)(83380400001)(26005)(70206006)(478600001)(8676002)(316002)(40460700003)(186003)(42882007)(40480700001)(2906002)(6666004)(41300700001)(83170400001)(8936002)(2876002)(82740400003)(5660300002)(9686003)(356005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:29:53.4730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5488a946-fdba-4c97-b811-08da9daac111
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6635
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

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c          |  6 +++
 drivers/net/ethernet/sfc/tc_bindings.c | 71 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_bindings.h |  6 +++
 3 files changed, 83 insertions(+)

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
index 277ce8558aa0..c18d64519c2d 100644
--- a/drivers/net/ethernet/sfc/tc_bindings.c
+++ b/drivers/net/ethernet/sfc/tc_bindings.c
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
