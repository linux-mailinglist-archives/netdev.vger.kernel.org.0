Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A8359B56B
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiHUQVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiHUQVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:21:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8861A380
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUg2rwCPy9B/bNN+iCU0v2L0LvGNO/H7hUjRnTKlLydGaJDxfj9w6ILWUrZZ903oDkE5eyjiCas1QCULXckVKne7n5pxQ4IuX8QO80wG7pVJWmYa2JJ29BzsPN7QfjqB3fP/oO6tb56h3TNWAU7UbO7yuXCrqx7BaneA/CsNZMq+K1szOA0j0O+aG/jtVhkzLYnHjhutI+06FYjN3B8GSLcg35ek0srgrn3vxA4b+KtiOlbE2VV6OdFhytpk8fyMXikWNh+AQHQa0lYKezK0MaUSeGQtNVfHVj/iwmGTBuBHBwN2LkCq9Z80iHh10whvy9sXwme3R+z7m2d4pLROrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZhM2B50773qZQhi4W24MjRgqphJvHKA99KSqgmOYSQ=;
 b=TLeGtphnWydc/hHv7funwyGq723WFPkjQqznfnpyxD/1WxTJLFoQMe9kMDogkF8Qy1sLr/wlsdRdylKSlxAx8i2Dy/q6i6y815O290/87WAy9rxEjfbgEYokdf97pXOIx7QuyZxfwzcyL/vsdygT1LezQbo5ZqR+LKQZG90BaXn5guvEuvco7UPY8WDElQOTteKSdZqkEB0P4VWUqJuBC/Y0sG1qLOIBh0O3B599bwxWBgdKUhNTBGp1WwWeHt5afXHegRPv3igQbXXcIE60KfCLjIqA4RF3luAwibB1dfXD3RrU9zdrwXRhmeVNB7nYBlHY656wgXnSlm98XgEapA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZhM2B50773qZQhi4W24MjRgqphJvHKA99KSqgmOYSQ=;
 b=ikYbKlMWnLA0q5Cp/tErigteCLY7d59M+K9xAiuSlGLP40gUYq0cZE4BWJYWNkKr1nc68p/PmPN4l/qvnZe6ARrZk13GaWBagswYBV/1mzwbZK1jImM6Fxp5YPPkqZcmJLAqAZHnJY9mvFop7yjxKC9S0vkzzy73XnJgwF4NhZPs3ogpr/qRaIzclQM2vjAaF4KTR0w8qMy5K5cnjFNxyDGWZ8PRPAwIMNuOJTJMQ1yxiishZQtpJDhp2bp0pLy+Skfbg4VJdeyTxdqYIfPtVs8fwqC9oNOIVwxoDhNPZPln9pKIJ5St0lnnVkifDVOtAnV+OBxFCrEdsBE/afWgUg==
Received: from MW4P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::23)
 by BN8PR12MB3425.namprd12.prod.outlook.com (2603:10b6:408:61::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Sun, 21 Aug
 2022 16:20:56 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::f4) by MW4P220CA0018.outlook.office365.com
 (2603:10b6:303:115::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Sun, 21 Aug 2022 16:20:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Sun, 21 Aug 2022 16:20:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:55 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:52 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: minimal: Extend to support line card dynamic operations
Date:   Sun, 21 Aug 2022 18:20:18 +0200
Message-ID: <878e23de61e11655995a9e837f735fc0b67e0533.1661093502.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: eaefa876-9e5d-495e-b3c8-08da83912063
X-MS-TrafficTypeDiagnostic: BN8PR12MB3425:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lt6MvCbBLhFnyDBWcdROi9UXoZvLyIt4HQK6WMZ+RHzWV6TRO0PzcBjnS06bkwa2H18QOdvEfJSj/sgNWVQGrWdKWLcf7lqfa+MECYCiGpKr/LzzByktZgt9uTMh1Gc55JxXkxquwlrpW42dNen57MteFLs8QRRt5+S7OjPlS8C9z3lB1gHBKWZZN6uNNZAxIQP//tEJ/yfpnJ3WvLDVyfcymR5HzNsHZTIxOIhHBR7nUv88pqcTElMBsTTsJWD2jeU2uPATeuq9y2S+p/Nbs8U7TTmM57Uc9f+huT5XUj1f5KeDAQRg+l2hocHx0FtehzkE/w0rtR+v2qf5xJxBS7vQxWG70JgTOp7BWIOvPnAVtfsIpl+mVOD4ufM2UBBYspeoCuS88JoV2fy7oBkb+FnTCCuLqzfVKRPMCjS8ahzWUiDXQMtR5f/WvNfEKDd9tHDLB3k210QDbF8Ek4jFtM+dIwmHSf0t0csftJtIYhIuXaV5EKnrO8gs0hvQl9TrJvRbIYyFW0iwlLRuYAR5n0DbHx0/4r1PU4fjVzpt+nhO8qhPJgDjXE3OjGNlF4z1C5yB4HLgzJC3VMs1o5nKB2H5NHLSy7XIgZ0R1HKEvBuT7cTCmaZVwiR5PZVPDC6q3PqmrXUqrNAm5tLTomCetX38NvOZJp/Ka0Mz+xFoiuz1LfC/+pJkPoP2l9TRWUP9R2+HMFNRul2DF2vqaAoIOkrbY6WFgjtRyk+/EYtS69Bb6aOHvD9Bt1zXnvG4Tn5AITkbAKK9gOQVnqYVBZn8ZSNZEuH/PFRSOIC2Z1V6Vak=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(40470700004)(36840700001)(46966006)(83380400001)(426003)(2616005)(16526019)(336012)(81166007)(186003)(40460700003)(356005)(36860700001)(86362001)(47076005)(82740400003)(316002)(70206006)(8676002)(4326008)(82310400005)(110136005)(2906002)(36756003)(40480700001)(54906003)(8936002)(5660300002)(478600001)(107886003)(26005)(41300700001)(70586007)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:20:56.1998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eaefa876-9e5d-495e-b3c8-08da83912063
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3425
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

Implement line card operation callbacks got_active() / got_inactive().
The purpose of these callback to create / remove line card ports after
line card is getting active / inactive.

Implement line ports_remove_selected() callback to support line card
un-provisioning flow through 'devlink'.

Add line card operation registration and de-registration APIs.

Add module offset for line card. Offset for main board iz zero.
For line card in slot #n offset is calculated as (#n - 1) multiplied by
maximum modules number.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 100 +++++++++++++++++-
 1 file changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 7fc5ebb8e0ba..7d3fa2883e8b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -48,6 +48,7 @@ struct mlxsw_m_port {
 	u16 local_port;
 	u8 slot_index;
 	u8 module;
+	u8 module_offset;
 };
 
 static int mlxsw_m_base_mac_get(struct mlxsw_m *mlxsw_m)
@@ -227,7 +228,8 @@ mlxsw_m_port_dev_addr_get(struct mlxsw_m_port *mlxsw_m_port)
 	if (err)
 		return err;
 	mlxsw_reg_ppad_mac_memcpy_from(ppad_pl, addr);
-	eth_hw_addr_gen(mlxsw_m_port->dev, addr, mlxsw_m_port->module + 1);
+	eth_hw_addr_gen(mlxsw_m_port->dev, addr, mlxsw_m_port->module + 1 +
+			mlxsw_m_port->module_offset);
 	return 0;
 }
 
@@ -268,6 +270,14 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 slot_index,
 	mlxsw_m_port->local_port = local_port;
 	mlxsw_m_port->module = module;
 	mlxsw_m_port->slot_index = slot_index;
+	/* Add module offset for line card. Offset for main board iz zero.
+	 * For line card in slot #n offset is calculated as (#n - 1)
+	 * multiplied by maximum modules number, which could be found on a line
+	 * card.
+	 */
+	mlxsw_m_port->module_offset = mlxsw_m_port->slot_index ?
+				      (mlxsw_m_port->slot_index - 1) *
+				      mlxsw_m->max_modules_per_slot : 0;
 
 	dev->netdev_ops = &mlxsw_m_port_netdev_ops;
 	dev->ethtool_ops = &mlxsw_m_port_ethtool_ops;
@@ -333,6 +343,9 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 	if (err)
 		return err;
 
+	/* Skip if line card has been already configured */
+	if (mlxsw_m->line_cards[slot_index]->active)
+		return 0;
 	if (!width)
 		return 0;
 	/* Skip, if port belongs to the cluster */
@@ -536,6 +549,24 @@ static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 	mlxsw_m_linecard_ports_remove(mlxsw_m, 0);
 }
 
+static void
+mlxsw_m_ports_remove_selected(struct mlxsw_core *mlxsw_core,
+			      bool (*selector)(void *priv, u16 local_port),
+			      void *priv)
+{
+	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
+	struct mlxsw_linecard *linecard_priv = priv;
+	struct mlxsw_m_line_card *linecard;
+
+	linecard = mlxsw_m->line_cards[linecard_priv->slot_index];
+
+	if (WARN_ON(!linecard->active))
+		return;
+
+	mlxsw_m_linecard_ports_remove(mlxsw_m, linecard_priv->slot_index);
+	linecard->active = false;
+}
+
 static int mlxsw_m_fw_rev_validate(struct mlxsw_m *mlxsw_m)
 {
 	const struct mlxsw_fw_rev *rev = &mlxsw_m->bus_info->fw_rev;
@@ -554,6 +585,60 @@ static int mlxsw_m_fw_rev_validate(struct mlxsw_m *mlxsw_m)
 	return -EINVAL;
 }
 
+static void
+mlxsw_m_got_active(struct mlxsw_core *mlxsw_core, u8 slot_index, void *priv)
+{
+	struct mlxsw_m_line_card *linecard;
+	struct mlxsw_m *mlxsw_m = priv;
+	int err;
+
+	linecard = mlxsw_m->line_cards[slot_index];
+	/* Skip if line card has been already configured during init */
+	if (linecard->active)
+		return;
+
+	/* Fill out module to local port mapping array */
+	err = mlxsw_m_ports_module_map(mlxsw_m);
+	if (err)
+		goto err_ports_module_map;
+
+	/* Create port objects for each valid entry */
+	err = mlxsw_m_linecard_ports_create(mlxsw_m, slot_index);
+	if (err) {
+		dev_err(mlxsw_m->bus_info->dev, "Failed to create port for line card at slot %d\n",
+			slot_index);
+		goto err_linecard_ports_create;
+	}
+
+	linecard->active = true;
+
+	return;
+
+err_linecard_ports_create:
+err_ports_module_map:
+	mlxsw_m_linecard_port_module_unmap(mlxsw_m, slot_index);
+}
+
+static void
+mlxsw_m_got_inactive(struct mlxsw_core *mlxsw_core, u8 slot_index, void *priv)
+{
+	struct mlxsw_m_line_card *linecard;
+	struct mlxsw_m *mlxsw_m = priv;
+
+	linecard = mlxsw_m->line_cards[slot_index];
+
+	if (WARN_ON(!linecard->active))
+		return;
+
+	mlxsw_m_linecard_ports_remove(mlxsw_m, slot_index);
+	linecard->active = false;
+}
+
+static struct mlxsw_linecards_event_ops mlxsw_m_event_ops = {
+	.got_active = mlxsw_m_got_active,
+	.got_inactive = mlxsw_m_got_inactive,
+};
+
 static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 			const struct mlxsw_bus_info *mlxsw_bus_info,
 			struct netlink_ext_ack *extack)
@@ -580,6 +665,13 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 		return err;
 	}
 
+	err = mlxsw_linecards_event_ops_register(mlxsw_core,
+						 &mlxsw_m_event_ops, mlxsw_m);
+	if (err) {
+		dev_err(mlxsw_m->bus_info->dev, "Failed to register line cards operations\n");
+		goto linecards_event_ops_register;
+	}
+
 	err = mlxsw_m_ports_create(mlxsw_m);
 	if (err) {
 		dev_err(mlxsw_m->bus_info->dev, "Failed to create ports\n");
@@ -589,6 +681,9 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 	return 0;
 
 err_ports_create:
+	mlxsw_linecards_event_ops_unregister(mlxsw_core,
+					     &mlxsw_m_event_ops, mlxsw_m);
+linecards_event_ops_register:
 	mlxsw_m_linecards_fini(mlxsw_m);
 	return err;
 }
@@ -598,6 +693,8 @@ static void mlxsw_m_fini(struct mlxsw_core *mlxsw_core)
 	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
 
 	mlxsw_m_ports_remove(mlxsw_m);
+	mlxsw_linecards_event_ops_unregister(mlxsw_core,
+					     &mlxsw_m_event_ops, mlxsw_m);
 	mlxsw_m_linecards_fini(mlxsw_m);
 }
 
@@ -608,6 +705,7 @@ static struct mlxsw_driver mlxsw_m_driver = {
 	.priv_size		= sizeof(struct mlxsw_m),
 	.init			= mlxsw_m_init,
 	.fini			= mlxsw_m_fini,
+	.ports_remove_selected	= mlxsw_m_ports_remove_selected,
 	.profile		= &mlxsw_m_config_profile,
 };
 
-- 
2.35.3

