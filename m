Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4AD59B56C
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiHUQVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiHUQVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:21:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA4D20F61
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nalGFRdPbs90Cw2eCJ/aUJmyiZMD2Aaer9QdiH31s/IcN9l3CSqCD/M8qSQ4J9asrcNpIozsNOGPUCGFredPKI/dpLEUgzdmMaW4NxjPzGrevkzgNlwyqescPq8gq5O+V3omQ4J49nolibxjItS4Ju2RHLM6V89UuURrGo/y6NhaDUiCXRG9G7rbmjMcsUfimjvlsITzfinyy37Ha2VmBWeU1C7YeIrihviPfrugXaM52vS/NtNTBp9DeEJVMDzAP8z4QCt7+g5Fj8KREcChrKqBXhh4uMlT5Z3ld2IpJTXwEgxX3ibUuSpWzK1BKS6PXfducn4XUnv76Mn01vJU0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXZIy3ZKIufr4FieBojjexmt1Vx5hGgwHKtKE07jJho=;
 b=BaImT4djLsPwXzeWNYs59fWM4QyYV5tpT8Cn+EYAcPzJJ700X+esoQMJ/8LXr38RsDVMmngaMkZwoqlSXyth35v3rHVihBy1yKANHjuDxPwuu1OI/BLKsufd+9p++2m/YnoyiejzqQErQGdvSlbYEywcpkfJodgQgVWx6d+6K2OfD5K78Cz5HeUcUuvEYpl2WEy2JvPW/eK6f/iaI9mJ9EF8v8sSu2FUNu+acYqI+GqQ48RDbVbbUZf8mh3KynXqkzxbFwV7stOeVafEwGJfE8ZIYGwnivqx1AZf8Cn+ez0i/9dkHKRTgG8G1FxfJBiBsMtVJzxKRrUWfY0cPfbDtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXZIy3ZKIufr4FieBojjexmt1Vx5hGgwHKtKE07jJho=;
 b=PSYagmVrQMQ4nfAw3znUse9AimCU6v6VUGTyfXb/nyt+iKjH1AYA/HPj0+69FsAHwKowf1hcOjMQCy8gTLsVrp7qcMf433zctfijOHrX43tHQK8AH0EQ0SVj6be8+8SzMHxYtgKXiJQs4t7gFPyn7PlaEFLNgDY4kG3L+cbcKram/B1DhbjhmELHJMTzBz4kbGy776VReMB9ZRESaY8ZlK4pHLOsS4JsmIwjYtIGf9prXtHOyJ4G8cYXGKXyjT9+RDwEkXzecJMRk99yiBS4Uuc8gmOkIEFSeXPAnupVTXQbVCD9sH37RomDqhEBlLMe0GLDQirPCtc2n7aPXl8iiQ==
Received: from DM5PR07CA0114.namprd07.prod.outlook.com (2603:10b6:4:ae::43) by
 BY5PR12MB3683.namprd12.prod.outlook.com (2603:10b6:a03:1a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Sun, 21 Aug
 2022 16:21:10 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::f0) by DM5PR07CA0114.outlook.office365.com
 (2603:10b6:4:ae::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Sun, 21 Aug 2022 16:21:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Sun, 21 Aug 2022 16:21:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:53 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:50 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: minimal: Extend module to port mapping with slot index
Date:   Sun, 21 Aug 2022 18:20:17 +0200
Message-ID: <e63a0b049a497db04004d50632096932e5f4600a.1661093502.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: cd1d5b40-5cc7-4003-76be-08da839128d2
X-MS-TrafficTypeDiagnostic: BY5PR12MB3683:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6w72yM2+kN4BNhb8HZ4Sg54jy7QX8qTsOyBuYLjoFWSEsF0kTsrrnTXmxMUkcJokYDetuzppzPflyotop/KPz6O5le3u3LJFvrhQ7M+Mu8v+2vrwipJgSlnSb+F9206zM5QlXNHI6RbOa32+rkWLy442UXdp8XcT0quiCdnLK/TYz8oef/gFQnjNqJtdmRdAPv6V3BlT+c0rEr0CARuztc7W5GgGZwQZVs9tUwwuXgb93UB3yxnXqwfNFMoK2lMvvsfVUw/4IG7N+30dGdq5CTubPnC/UcUfvMm0IjXouhrWGplHymxejqofh3Npk4iZWBYcnq2ZD92HrJfkO4MFv6iPeAQ58ORrzVjEm6aS8YzGIylUkJsB8DP4WW4nSzlO+RAMTwXGnMqXErztfej783wHnJeiGt6CUIFYPhyFfs7Wz3oVqvNUi6b09OGBdfotctl9TIj7+BYww4IHnOQpsGE/Tncc91ZXiwwOYtSJnafce0vpef5I6KssNs1S8epEcXhGEtnmp7oifXgxObx9pY5ibNj8Kd6hpV49JztHpDeYDYCWWpnCcEXh+nEGw9/SeG2yWUfxxmQ/A+3ccAh+Ae1UsqtGNPewV4ajT9deMVPPCWAx0z1YAd2R4D8R/qDoSB3rn2BolV4dVbb6n3bSZKK83oyPo1EqyBv77BXi2vqNNFbxG9vZkij1LLQ1Vdeh4HTEc9Wr2QvUWjn9m7dzBch13jxcf1cnlGWGETG6WXhWJ2qBjxg+LrdTzUxH4YXrqRXg50TRgzh7IeDs1R7WzJ/JrjWt2Ah/XgnutjZOU3WLCECwzrKprm7/jLHkdnXNNAP0B8D+MUdnzc4NrtpXHkiFJRKzNcvoXnaQeRjtfs=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(36840700001)(40470700004)(40480700001)(2616005)(83380400001)(82740400003)(81166007)(36756003)(110136005)(70586007)(54906003)(8676002)(4326008)(316002)(70206006)(40460700003)(26005)(2906002)(82310400005)(86362001)(107886003)(36860700001)(6666004)(186003)(336012)(16526019)(426003)(47076005)(41300700001)(478600001)(356005)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:21:10.3474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1d5b40-5cc7-4003-76be-08da839128d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3683
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

The interfaces for ports found on line card are created and removed
dynamically after line card is getting active or inactive.

Introduce per line card array with module to port mapping.
For each port get 'slot_index' through PMLP register and set port
mapping for the relevant [slot_index][module] entry.

Split module and port allocation into separate routines.

Split per line card port creation and removing into separate routines.
Motivation to re-use these routines for line card operations.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 221 +++++++++++++-----
 1 file changed, 166 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index f8dee111d25b..7fc5ebb8e0ba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -26,13 +26,20 @@ static const struct mlxsw_fw_rev mlxsw_m_fw_rev = {
 
 struct mlxsw_m_port;
 
+struct mlxsw_m_line_card {
+	bool active;
+	int module_to_port[];
+};
+
 struct mlxsw_m {
 	struct mlxsw_m_port **ports;
-	int *module_to_port;
 	struct mlxsw_core *core;
 	const struct mlxsw_bus_info *bus_info;
 	u8 base_mac[ETH_ALEN];
 	u8 max_ports;
+	u8 max_modules_per_slot; /* Maximum number of modules per-slot. */
+	u8 num_of_slots; /* Including the main board. */
+	struct mlxsw_m_line_card **line_cards;
 };
 
 struct mlxsw_m_port {
@@ -191,7 +198,7 @@ static const struct ethtool_ops mlxsw_m_port_ethtool_ops = {
 
 static int
 mlxsw_m_port_module_info_get(struct mlxsw_m *mlxsw_m, u16 local_port,
-			     u8 *p_module, u8 *p_width)
+			     u8 *p_module, u8 *p_width, u8 *p_slot_index)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	int err;
@@ -202,6 +209,7 @@ mlxsw_m_port_module_info_get(struct mlxsw_m *mlxsw_m, u16 local_port,
 		return err;
 	*p_module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
 	*p_width = mlxsw_reg_pmlp_width_get(pmlp_pl);
+	*p_slot_index = mlxsw_reg_pmlp_slot_index_get(pmlp_pl, 0);
 
 	return 0;
 }
@@ -223,6 +231,11 @@ mlxsw_m_port_dev_addr_get(struct mlxsw_m_port *mlxsw_m_port)
 	return 0;
 }
 
+static bool mlxsw_m_port_created(struct mlxsw_m *mlxsw_m, u16 local_port)
+{
+	return mlxsw_m->ports[local_port];
+}
+
 static int
 mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 slot_index,
 		    u8 module)
@@ -300,16 +313,23 @@ static void mlxsw_m_port_remove(struct mlxsw_m *mlxsw_m, u16 local_port)
 	mlxsw_core_port_fini(mlxsw_m->core, local_port);
 }
 
+static int*
+mlxsw_m_port_mapping_get(struct mlxsw_m *mlxsw_m, u8 slot_index, u8 module)
+{
+	return &mlxsw_m->line_cards[slot_index]->module_to_port[module];
+}
+
 static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 				   u8 *last_module)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
-	u8 module, width;
+	u8 module, width, slot_index;
+	int *module_to_port;
 	int err;
 
 	/* Fill out to local port mapping array */
 	err = mlxsw_m_port_module_info_get(mlxsw_m, local_port, &module,
-					   &width);
+					   &width, &slot_index);
 	if (err)
 		return err;
 
@@ -322,8 +342,9 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 
 	if (WARN_ON_ONCE(module >= max_ports))
 		return -EINVAL;
-	mlxsw_env_module_port_map(mlxsw_m->core, 0, module);
-	mlxsw_m->module_to_port[module] = ++mlxsw_m->max_ports;
+	mlxsw_env_module_port_map(mlxsw_m->core, slot_index, module);
+	module_to_port = mlxsw_m_port_mapping_get(mlxsw_m, slot_index, module);
+	*module_to_port = local_port;
 
 	return 0;
 }
@@ -331,98 +352,188 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 static void
 mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 slot_index, u8 module)
 {
-	mlxsw_m->module_to_port[module] = -1;
+	int *module_to_port = mlxsw_m_port_mapping_get(mlxsw_m, slot_index,
+						       module);
+	*module_to_port = -1;
 	mlxsw_env_module_port_unmap(mlxsw_m->core, slot_index, module);
 }
 
 static int mlxsw_m_linecards_init(struct mlxsw_m *mlxsw_m)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
-	int i, err;
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	u8 num_of_modules;
+	int i, j, err;
+
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	err = mlxsw_reg_query(mlxsw_m->core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, &num_of_modules,
+			       &mlxsw_m->num_of_slots);
+	/* If the system is modular, get the maximum number of modules per-slot.
+	 * Otherwise, get the maximum number of modules on the main board.
+	 */
+	if (mlxsw_m->num_of_slots)
+		mlxsw_m->max_modules_per_slot =
+			mlxsw_reg_mgpir_max_modules_per_slot_get(mgpir_pl);
+	else
+		mlxsw_m->max_modules_per_slot = num_of_modules;
+	/* Add slot for main board. */
+	mlxsw_m->num_of_slots += 1;
 
 	mlxsw_m->ports = kcalloc(max_ports, sizeof(*mlxsw_m->ports),
 				 GFP_KERNEL);
 	if (!mlxsw_m->ports)
 		return -ENOMEM;
 
-	mlxsw_m->module_to_port = kmalloc_array(max_ports, sizeof(int),
-						GFP_KERNEL);
-	if (!mlxsw_m->module_to_port) {
-		err = -ENOMEM;
-		goto err_module_to_port_alloc;
+	mlxsw_m->line_cards = kcalloc(mlxsw_m->num_of_slots,
+				      sizeof(*mlxsw_m->line_cards),
+				      GFP_KERNEL);
+	if (!mlxsw_m->line_cards)
+		goto err_kcalloc;
+
+	for (i = 0; i < mlxsw_m->num_of_slots; i++) {
+		mlxsw_m->line_cards[i] =
+			kzalloc(struct_size(mlxsw_m->line_cards[i],
+					    module_to_port,
+					    mlxsw_m->max_modules_per_slot),
+				GFP_KERNEL);
+		if (!mlxsw_m->line_cards[i])
+			goto err_kmalloc_array;
+
+		/* Invalidate the entries of module to local port mapping array. */
+		for (j = 0; j < mlxsw_m->max_modules_per_slot; j++)
+			mlxsw_m->line_cards[i]->module_to_port[j] = -1;
 	}
 
-	/* Invalidate the entries of module to local port mapping array */
-	for (i = 0; i < max_ports; i++)
-		mlxsw_m->module_to_port[i] = -1;
-
 	return 0;
 
-err_module_to_port_alloc:
+err_kmalloc_array:
+	for (i--; i >= 0; i--)
+		kfree(mlxsw_m->line_cards[i]);
+err_kcalloc:
 	kfree(mlxsw_m->ports);
 	return err;
 }
 
 static void mlxsw_m_linecards_fini(struct mlxsw_m *mlxsw_m)
 {
-	kfree(mlxsw_m->module_to_port);
+	int i = mlxsw_m->num_of_slots;
+
+	for (i--; i >= 0; i--)
+		kfree(mlxsw_m->line_cards[i]);
+	kfree(mlxsw_m->line_cards);
 	kfree(mlxsw_m->ports);
 }
 
-static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
+static void
+mlxsw_m_linecard_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 slot_index)
+{
+	int i;
+
+	for (i = mlxsw_m->max_modules_per_slot - 1; i >= 0; i--) {
+		int *module_to_port;
+
+		module_to_port = mlxsw_m_port_mapping_get(mlxsw_m, slot_index, i);
+		if (*module_to_port > 0)
+			mlxsw_m_port_module_unmap(mlxsw_m, slot_index, i);
+	}
+}
+
+static int
+mlxsw_m_linecard_ports_create(struct mlxsw_m *mlxsw_m, u8 slot_index)
+{
+	int *module_to_port;
+	int i, err;
+
+	for (i = 0; i < mlxsw_m->max_modules_per_slot; i++) {
+		module_to_port = mlxsw_m_port_mapping_get(mlxsw_m, slot_index, i);
+		if (*module_to_port > 0) {
+			err = mlxsw_m_port_create(mlxsw_m, *module_to_port,
+						  slot_index, i);
+			if (err)
+				goto err_port_create;
+			/* Mark slot as active */
+			if (!mlxsw_m->line_cards[slot_index]->active)
+				mlxsw_m->line_cards[slot_index]->active = true;
+		}
+	}
+	return 0;
+
+err_port_create:
+	for (i--; i >= 0; i--) {
+		module_to_port = mlxsw_m_port_mapping_get(mlxsw_m, slot_index, i);
+		if (*module_to_port > 0 &&
+		    mlxsw_m_port_created(mlxsw_m, *module_to_port)) {
+			mlxsw_m_port_remove(mlxsw_m, *module_to_port);
+			/* Mark slot as inactive */
+			if (mlxsw_m->line_cards[slot_index]->active)
+				mlxsw_m->line_cards[slot_index]->active = false;
+		}
+	}
+	return err;
+}
+
+static void
+mlxsw_m_linecard_ports_remove(struct mlxsw_m *mlxsw_m, u8 slot_index)
+{
+	int i;
+
+	for (i = 0; i < mlxsw_m->max_modules_per_slot; i++) {
+		int *module_to_port = mlxsw_m_port_mapping_get(mlxsw_m,
+							       slot_index, i);
+
+		if (*module_to_port > 0 &&
+		    mlxsw_m_port_created(mlxsw_m, *module_to_port)) {
+			mlxsw_m_port_remove(mlxsw_m, *module_to_port);
+			mlxsw_m_port_module_unmap(mlxsw_m, slot_index, i);
+		}
+	}
+}
+
+static int mlxsw_m_ports_module_map(struct mlxsw_m *mlxsw_m)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
 	u8 last_module = max_ports;
-	int i;
-	int err;
+	int i, err;
 
-	/* Fill out module to local port mapping array */
 	for (i = 1; i < max_ports; i++) {
 		err = mlxsw_m_port_module_map(mlxsw_m, i, &last_module);
 		if (err)
-			goto err_module_to_port_map;
+			return err;
 	}
 
+	return 0;
+}
+
+static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
+{
+	int err;
+
+	/* Fill out module to local port mapping array */
+	err = mlxsw_m_ports_module_map(mlxsw_m);
+	if (err)
+		goto err_ports_module_map;
+
 	/* Create port objects for each valid entry */
-	for (i = 0; i < mlxsw_m->max_ports; i++) {
-		if (mlxsw_m->module_to_port[i] > 0) {
-			err = mlxsw_m_port_create(mlxsw_m,
-						  mlxsw_m->module_to_port[i],
-						  0, i);
-			if (err)
-				goto err_module_to_port_create;
-		}
-	}
+	err = mlxsw_m_linecard_ports_create(mlxsw_m, 0);
+	if (err)
+		goto err_linecard_ports_create;
 
 	return 0;
 
-err_module_to_port_create:
-	for (i--; i >= 0; i--) {
-		if (mlxsw_m->module_to_port[i] > 0)
-			mlxsw_m_port_remove(mlxsw_m,
-					    mlxsw_m->module_to_port[i]);
-	}
-	i = max_ports;
-err_module_to_port_map:
-	for (i--; i > 0; i--)
-		mlxsw_m_port_module_unmap(mlxsw_m, 0, i);
+err_linecard_ports_create:
+err_ports_module_map:
+	mlxsw_m_linecard_port_module_unmap(mlxsw_m, 0);
+
 	return err;
 }
 
 static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 {
-	int i;
-
-	for (i = 0; i < mlxsw_m->max_ports; i++) {
-		if (mlxsw_m->module_to_port[i] > 0) {
-			mlxsw_m_port_remove(mlxsw_m,
-					    mlxsw_m->module_to_port[i]);
-			mlxsw_m_port_module_unmap(mlxsw_m, 0, i);
-		}
-	}
-
-	kfree(mlxsw_m->module_to_port);
-	kfree(mlxsw_m->ports);
+	mlxsw_m_linecard_ports_remove(mlxsw_m, 0);
 }
 
 static int mlxsw_m_fw_rev_validate(struct mlxsw_m *mlxsw_m)
-- 
2.35.3

