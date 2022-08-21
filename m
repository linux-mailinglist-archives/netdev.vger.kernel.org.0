Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0063959B570
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiHUQUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiHUQUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:20:51 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DCF1A051
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:20:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1v4WPVQJQsYitxS1TfbCJ2na4Uz/BBWNRG0DJuvV0HPrTNpBtMlSjYeEe23vbCjFByW6i1f5er2mqw5lOnqGCOisN7kCq2IBsHsl77zzQF9Kll4JxKNTMSDQNkyNJbqMySQfwNi78I9rDnjttXFzAyig0TbLD/iEIlqlw1gRVSd8SMTt90rGMAwU0mL8UKSjGH8vi25YTf0cbviHwB7FBfu7xYeFsuM72mghxeU1rZUG1YWJJBQ740+6bgZs4Ys4RjmYRRAX+nUqJ+IDC8pBnaEqityamio4k5nJOlpDm2uDyo9sxO56xzBDLgYdwU0OQAAaGustZHbWVamRqL0rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydh0PnyKTwK1SSnoY4kk+WIh0RSMogXP5NYWfMz93Lk=;
 b=fsFEuw+ams9wRIjjRs6QpTvkfhRtV5rlPdk7ew93yOq4xM30wT7N/iqi91B71Mhsi1DvKZz1hdysjkqt+mcz6FisR9GUXbPdc7IKsC3Lp1KnZHaYJ5aaeZnssLGV0RT2jAebB9mqu1BkyhQYFNTAN5Eav1605JGUauoEyouOM23w5CDGfX2FEUB7Dpjuw5wfzL9q3G5MOe1cAcDsDblRO2deml2hAdY8bZq67Jk4W6YkTTavvrwGViMZPSO6U2r+6Jhq2bZFPfSTmeKp7nNh721Okn7I4Uu80ZSxyiOBrsrapY7Vs2BqyvW1RfYl+in242IJYjE4UXhSyauTq0h35A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydh0PnyKTwK1SSnoY4kk+WIh0RSMogXP5NYWfMz93Lk=;
 b=dpzku+5bT+In9GX+h6+Ak5zQ/5d+CYKOZx5KyYwEbtHCv5IeLfmbsLEb7TiCJEqYdVs0ZxVzEgdT8tGRLBi0g3va1AieG78j/c46efBMhkeged0fg1DBwn4y+9WI4Gpnm7K3xEDpBXIVu2wVjSXkagiXnJbSWmeXCQ8fJb1XBbVVEPO+ASnHOMmXSYPNb9x7MfMy0waRSEBc3V8Wiy+7fHkjiZ2g0t+PMUOo0mHDn1Pt2eZGZ7H/Y0IuptVa/TciSJvcwYfNZdB1O98DWwfsD6COSdRFKueVOC3B4wkQBmvw+BPcXTvC02/AbOyBjf1JE1QNNEBQa4tjqwie2c32Vw==
Received: from MW4PR03CA0273.namprd03.prod.outlook.com (2603:10b6:303:b5::8)
 by SN7PR12MB7201.namprd12.prod.outlook.com (2603:10b6:806:2a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Sun, 21 Aug
 2022 16:20:48 +0000
Received: from CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::19) by MW4PR03CA0273.outlook.office365.com
 (2603:10b6:303:b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20 via Frontend
 Transport; Sun, 21 Aug 2022 16:20:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT095.mail.protection.outlook.com (10.13.174.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Sun, 21 Aug 2022 16:20:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:47 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:44 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: minimal: Extend APIs with slot index for modular system support
Date:   Sun, 21 Aug 2022 18:20:15 +0200
Message-ID: <829c4a4e1777a000a50c25b9ef4dcbc8831f8424.1661093502.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661093502.git.petrm@nvidia.com>
References: <cover.1661093502.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5667fc2-c1a4-490f-0afe-08da83911bbd
X-MS-TrafficTypeDiagnostic: SN7PR12MB7201:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWt4QG49ZkuXee/CoZjVJSlO/UZ1cr36OS9tgbdkrCUX6ZBB/BUqUpQoOkEfV/WLN6u3CaUC7Q9BbwZvPJeLGrodn69rqs6JJ4pLMTQhT1HRWl1DxgRXsAvMXPq3ygOE/zHxTWCqSZ4X2iBjYkVVIdKWVBrd7tlUUnDnRwyxkce5kvN0KnUF3JMDomDO8kWeVFerY3fFXr0z4qU9TZMSVMO7Gt1MLuUCssCgvLdynhFsr2Dxp+HqS4mpSppeByMYD+xPML0O8BNimen/VLfGz4e9U1ZMPBhdEYfjEypobSZF0xVLcf/onzJfzIrpS/l4CYCeTeUhg60/+hp2Fo2jyraD62odg7gRvEB8UNw8+BGpNycQ71mcvUZZcegIiQJszBGsp4LNEGn9gLsVNOwRiEvTyYRHUkCCs7n0qPcg8773u6y8nxH2su/Wf6ocy+WO99LXUj2O3LRY0B0lSneNjKZs9MYzqMX9R6BqvuC/VPL8FIF1wAcTaDZ8AMZiONH7Qy3ItwJbyoEnFwgJLl6kea/TB97ahyawWx0jxU9oGp70i+Km4MEWZA0SkZWaH91HSgTZqyTWVYzTAoztNmbxnbc8PT9UHerV/Jg7iau0R9nQhfCNrdoUWaYq1ANgt6avUY5qwMkHrbKhKP0o8mibSX0S2h7Zm/oN/VuJvlWyd3WqcTX5WvMuMAF7nXAiV4qZHM0QsdfAARYBkaOI7MPygSl+GNmIjyd1P8vpNDOxE0XGsL8sQJpl8pqXBm3mWkiZouxD/GYhojPPapAeqwoHwEEknku/fufueZblD9eHnpZ/SV+SS/EasixRgNE0tlzL
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(36840700001)(40470700004)(46966006)(316002)(110136005)(54906003)(107886003)(83380400001)(82310400005)(426003)(86362001)(70586007)(356005)(81166007)(16526019)(186003)(40480700001)(47076005)(336012)(2616005)(70206006)(2906002)(36756003)(478600001)(5660300002)(4326008)(36860700001)(8676002)(8936002)(6666004)(82740400003)(40460700003)(26005)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:20:48.4123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5667fc2-c1a4-490f-0afe-08da83911bbd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7201
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Add 'slot_index' field to port structure.
Replace zero slot_index argument with 'slot_index' in 'ethtool'
related APIs.
Add 'slot_index' argument to port initialization and
de-initialization related APIs.

Motivation is to prepare minimal driver for modular system support.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 38 ++++++++++++-------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index bb1cd4bae82e..ecb9f7b6f564 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -39,6 +39,7 @@ struct mlxsw_m_port {
 	struct net_device *dev;
 	struct mlxsw_m *mlxsw_m;
 	u16 local_port;
+	u8 slot_index;
 	u8 module;
 };
 
@@ -111,8 +112,9 @@ static int mlxsw_m_get_module_info(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_info(netdev, core, 0, mlxsw_m_port->module,
-					 modinfo);
+	return mlxsw_env_get_module_info(netdev, core,
+					 mlxsw_m_port->slot_index,
+					 mlxsw_m_port->module, modinfo);
 }
 
 static int
@@ -122,7 +124,8 @@ mlxsw_m_get_module_eeprom(struct net_device *netdev, struct ethtool_eeprom *ee,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_eeprom(netdev, core, 0,
+	return mlxsw_env_get_module_eeprom(netdev, core,
+					   mlxsw_m_port->slot_index,
 					   mlxsw_m_port->module, ee, data);
 }
 
@@ -134,7 +137,8 @@ mlxsw_m_get_module_eeprom_by_page(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_eeprom_by_page(core, 0,
+	return mlxsw_env_get_module_eeprom_by_page(core,
+						   mlxsw_m_port->slot_index,
 						   mlxsw_m_port->module,
 						   page, extack);
 }
@@ -144,7 +148,8 @@ static int mlxsw_m_reset(struct net_device *netdev, u32 *flags)
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_reset_module(netdev, core, 0, mlxsw_m_port->module,
+	return mlxsw_env_reset_module(netdev, core, mlxsw_m_port->slot_index,
+				      mlxsw_m_port->module,
 				      flags);
 }
 
@@ -156,7 +161,8 @@ mlxsw_m_get_module_power_mode(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_power_mode(core, 0, mlxsw_m_port->module,
+	return mlxsw_env_get_module_power_mode(core, mlxsw_m_port->slot_index,
+					       mlxsw_m_port->module,
 					       params, extack);
 }
 
@@ -168,7 +174,8 @@ mlxsw_m_set_module_power_mode(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_set_module_power_mode(core, 0, mlxsw_m_port->module,
+	return mlxsw_env_set_module_power_mode(core, mlxsw_m_port->slot_index,
+					       mlxsw_m_port->module,
 					       params->policy, extack);
 }
 
@@ -217,13 +224,14 @@ mlxsw_m_port_dev_addr_get(struct mlxsw_m_port *mlxsw_m_port)
 }
 
 static int
-mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 module)
+mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 slot_index,
+		    u8 module)
 {
 	struct mlxsw_m_port *mlxsw_m_port;
 	struct net_device *dev;
 	int err;
 
-	err = mlxsw_core_port_init(mlxsw_m->core, local_port, 0,
+	err = mlxsw_core_port_init(mlxsw_m->core, local_port, slot_index,
 				   module + 1, false, 0, false,
 				   0, mlxsw_m->base_mac,
 				   sizeof(mlxsw_m->base_mac));
@@ -246,6 +254,7 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 module)
 	mlxsw_m_port->mlxsw_m = mlxsw_m;
 	mlxsw_m_port->local_port = local_port;
 	mlxsw_m_port->module = module;
+	mlxsw_m_port->slot_index = slot_index;
 
 	dev->netdev_ops = &mlxsw_m_port_netdev_ops;
 	dev->ethtool_ops = &mlxsw_m_port_ethtool_ops;
@@ -319,10 +328,11 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 	return 0;
 }
 
-static void mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 module)
+static void
+mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 slot_index, u8 module)
 {
 	mlxsw_m->module_to_port[module] = -1;
-	mlxsw_env_module_port_unmap(mlxsw_m->core, 0, module);
+	mlxsw_env_module_port_unmap(mlxsw_m->core, slot_index, module);
 }
 
 static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
@@ -360,7 +370,7 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 		if (mlxsw_m->module_to_port[i] > 0) {
 			err = mlxsw_m_port_create(mlxsw_m,
 						  mlxsw_m->module_to_port[i],
-						  i);
+						  0, i);
 			if (err)
 				goto err_module_to_port_create;
 		}
@@ -377,7 +387,7 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 	i = max_ports;
 err_module_to_port_map:
 	for (i--; i > 0; i--)
-		mlxsw_m_port_module_unmap(mlxsw_m, i);
+		mlxsw_m_port_module_unmap(mlxsw_m, 0, i);
 	kfree(mlxsw_m->module_to_port);
 err_module_to_port_alloc:
 	kfree(mlxsw_m->ports);
@@ -392,7 +402,7 @@ static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 		if (mlxsw_m->module_to_port[i] > 0) {
 			mlxsw_m_port_remove(mlxsw_m,
 					    mlxsw_m->module_to_port[i]);
-			mlxsw_m_port_module_unmap(mlxsw_m, i);
+			mlxsw_m_port_module_unmap(mlxsw_m, 0, i);
 		}
 	}
 
-- 
2.35.3

