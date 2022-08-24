Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BA459FE1B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbiHXPTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235726AbiHXPTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:19:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853C79859E
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:19:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYZIlTte8d/qi+UVWxRggen+4YZRUMh3JLlJad0kLvFhHtdCU+YWlQOSL54GIMHmAhQbS+S8E8JtmMXc9LM75bD0qS46LgEq4Od2I8ArUjcVUpJLpOVgttqDhib1DibyqCfhk1bn2ycftwjDCB2rihrgKRsgxNrKbLWHnoDyBOWmqb2YuoEV7JtG66srn4GhOniLbKUXDD57/px82JV4B93XZ8yuBqGySLrCxVl9qcVA0kAgalWqLR94olQPuAj4WA+NjsYJRqxzmciiiJoiz6LiqFRQ2dCJZeYMtRMBywCAUBooWsHKiXKku96J74izRquaroT27cDB4CzquAiH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQGDy7+G4jQy2t8tS02whoHIwuDbndIRcPQbxueIskM=;
 b=AS0OOXRtxASKpXQunqmDPETXgD27xlIXgY15XfebuhIXNK7AoSV8lYezWur1BzxcbSEZDKy0JzrtYeo2pfeVdStz94l2KpI8BADjY+AO+yBB8D7LH5bObQEaJ/QxyHbfFH5O0XFKxKHHwplEjrghzbA+fptcBdsIPn7yzwd6dSXeVn2rJAI3m8N/EL8b94y0M8GG9RdMV0YQmC3PXzsK+taUvJjz+dvwp2hlU1DOQ2JSJhxw3iJeJwyBvKKQ2rEL3wEiWUH29W+rFfD7o6EwBCLs1HxCF+VJHqeAkmlUfNmzTySvmTCy1SFjJx+F9m65WrhoBKY4/XnVZFMAy3Wxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQGDy7+G4jQy2t8tS02whoHIwuDbndIRcPQbxueIskM=;
 b=EyFRs+sp1uGc0hnfFf62BYHXaGl9PwaHEd3sHcAA2TWsnLP86dM0Xr2BZoTzyK49FqAiQNFQzsH3GQ4ZwJ462+icy5gGBuE3DBEL2cBOZHqpMgAMAeYXZK9GK08fLT+TANKMkS28IhbMK4/yqmK+NoJv+TBuhvW6qpEeuCFSQtDU304b27GQwVhsbd166ANKMMxs7KbHqVu8oWvC6+dqhS2s+f8ZddOd7VIZ1d5wGM+F7YtROxrR2/HQnJPBBH2OBtLyUZyod0ZVFwyuHBhRxW2L5m+z9cqf1cOmux6Dwn5wgCUhwPhzPqyAMBJDO5FhXuXVEhMX6gJ++GTtobIF0g==
Received: from MW2PR16CA0043.namprd16.prod.outlook.com (2603:10b6:907:1::20)
 by SN6PR12MB2702.namprd12.prod.outlook.com (2603:10b6:805:6c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 24 Aug
 2022 15:19:37 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::f4) by MW2PR16CA0043.outlook.office365.com
 (2603:10b6:907:1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 15:19:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 15:19:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 15:19:37 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 08:19:34 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/3] mlxsw: Remove unused IB stuff
Date:   Wed, 24 Aug 2022 17:18:49 +0200
Message-ID: <95acbc998fa46e153e84d7445f9523c31e6727a3.1661350629.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661350629.git.petrm@nvidia.com>
References: <cover.1661350629.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e6d7993-7299-436b-3951-08da85e40ece
X-MS-TrafficTypeDiagnostic: SN6PR12MB2702:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hSnEpundwLZZOU/LNoVBLB1CApHMaRe0jjDuXoR0CPKqhFZJ+JRduIjB7lO6pd3lSMBM8jMLDNtigsZyFmNi5u+v21IkqZhgWtYkV6IXh0JVJsPA51d0wrognYlNgx728a8+p32TLz52gAsbYkN3Q+gapZWVrs/eBLbQHKVaYemmlyu6WBEHl4NhCJz/lTcOCRO469tua89eerGH000SXPlPnltK4URN1yMGD785ythjeZV317NhfIGGjdiFnBki82cKVGg6yq65zNXasv2dTXeIwl8NZlA0KfLxKAEV8rwB49VPBWUt9jZTNtUkYXD161LbwZRvljWQOL9FOYLbU3SdlNmlpTBOl9lF3uyDl4Xa9ftWhbMt10NuKimXZ31Z09p00JwnGEwn1CXQP7UXT+71YbqCh7ulXPAmstj+PS5GPyo+7wqWwZ/tVaJSwcsfSZuttXBrIYTy9cN1rscbdBWWXtS7T5hHqxOePiOT+0lqDmhvV5Bk56mJe9h6820sO+f5UQd7TjK65LKSpTjXMDmJ5RUarjz0jzrZ/yPxzmIRmRGyWO0oRHzpcK3RJp1vNEytJWSxpEL2TcUdoOaqNbGqpCtycK9hcujZxnz47JVjOtN9mWpGIIYjJJiKeKiph+FBlNpto2VPriowkWiuVn/eZPIyzDICyC382JpWvW+BGokFlt7UmXlbWLPCoQsWY5nVVxzgWKYe1UwuRARd8bP1zHWdlGuTtNZgENK1VjecyeSW/ssvWkEjoHpP2Hu66RgE8e+XO7oN/WbdFIigFOt4GF+uf6COtbzTwIvVXs=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(36840700001)(40470700004)(46966006)(26005)(8936002)(316002)(54906003)(478600001)(6666004)(5660300002)(186003)(2906002)(426003)(86362001)(2616005)(336012)(16526019)(107886003)(47076005)(110136005)(41300700001)(40480700001)(81166007)(40460700003)(356005)(83380400001)(82310400005)(70206006)(8676002)(82740400003)(4326008)(36756003)(70586007)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 15:19:37.2686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6d7993-7299-436b-3951-08da85e40ece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2702
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

There are some IB leftovers that are no longer used in the code.
So remove them.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ---
 drivers/net/ethernet/mellanox/mlxsw/core.h |  2 -
 drivers/net/ethernet/mellanox/mlxsw/reg.h  | 92 ----------------------
 3 files changed, 106 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 450dcd9951bb..d28c0f999f76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3183,18 +3183,6 @@ void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
 }
 EXPORT_SYMBOL(mlxsw_core_port_eth_set);
 
-void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u16 local_port,
-			    void *port_driver_priv)
-{
-	struct mlxsw_core_port *mlxsw_core_port =
-					&mlxsw_core->ports[local_port];
-	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
-
-	mlxsw_core_port->port_driver_priv = port_driver_priv;
-	devlink_port_type_ib_set(devlink_port, NULL);
-}
-EXPORT_SYMBOL(mlxsw_core_port_ib_set);
-
 void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
 			   void *port_driver_priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c7c0b3cefd8d..ca42783f143f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -264,8 +264,6 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core);
 void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
 			     void *port_driver_priv, struct net_device *dev);
-void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u16 local_port,
-			    void *port_driver_priv);
 void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
 			   void *port_driver_priv);
 enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f27bdecdf952..d71d7f9a20f1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4729,25 +4729,6 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_cap, 0x08, 0, 32);
  */
 MLXSW_ITEM32(reg, ptys, eth_proto_cap, 0x0C, 0, 32);
 
-/* reg_ptys_ib_link_width_cap
- * IB port supported widths.
- * Access: RO
- */
-MLXSW_ITEM32(reg, ptys, ib_link_width_cap, 0x10, 16, 16);
-
-#define MLXSW_REG_PTYS_IB_SPEED_SDR	BIT(0)
-#define MLXSW_REG_PTYS_IB_SPEED_DDR	BIT(1)
-#define MLXSW_REG_PTYS_IB_SPEED_QDR	BIT(2)
-#define MLXSW_REG_PTYS_IB_SPEED_FDR10	BIT(3)
-#define MLXSW_REG_PTYS_IB_SPEED_FDR	BIT(4)
-#define MLXSW_REG_PTYS_IB_SPEED_EDR	BIT(5)
-
-/* reg_ptys_ib_proto_cap
- * IB port supported speeds and protocols.
- * Access: RO
- */
-MLXSW_ITEM32(reg, ptys, ib_proto_cap, 0x10, 0, 16);
-
 /* reg_ptys_ext_eth_proto_admin
  * Extended speed and protocol to set port to.
  * Access: RW
@@ -4760,18 +4741,6 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_admin, 0x14, 0, 32);
  */
 MLXSW_ITEM32(reg, ptys, eth_proto_admin, 0x18, 0, 32);
 
-/* reg_ptys_ib_link_width_admin
- * IB width to set port to.
- * Access: RW
- */
-MLXSW_ITEM32(reg, ptys, ib_link_width_admin, 0x1C, 16, 16);
-
-/* reg_ptys_ib_proto_admin
- * IB speeds and protocols to set port to.
- * Access: RW
- */
-MLXSW_ITEM32(reg, ptys, ib_proto_admin, 0x1C, 0, 16);
-
 /* reg_ptys_ext_eth_proto_oper
  * The extended current speed and protocol configured for the port.
  * Access: RO
@@ -4784,18 +4753,6 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_oper, 0x20, 0, 32);
  */
 MLXSW_ITEM32(reg, ptys, eth_proto_oper, 0x24, 0, 32);
 
-/* reg_ptys_ib_link_width_oper
- * The current IB width to set port to.
- * Access: RO
- */
-MLXSW_ITEM32(reg, ptys, ib_link_width_oper, 0x28, 16, 16);
-
-/* reg_ptys_ib_proto_oper
- * The current IB speed and protocol.
- * Access: RO
- */
-MLXSW_ITEM32(reg, ptys, ib_proto_oper, 0x28, 0, 16);
-
 enum mlxsw_reg_ptys_connector_type {
 	MLXSW_REG_PTYS_CONNECTOR_TYPE_UNKNOWN_OR_NO_CONNECTOR,
 	MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_NONE,
@@ -4866,33 +4823,6 @@ static inline void mlxsw_reg_ptys_ext_eth_unpack(char *payload,
 			mlxsw_reg_ptys_ext_eth_proto_oper_get(payload);
 }
 
-static inline void mlxsw_reg_ptys_ib_pack(char *payload, u16 local_port,
-					  u16 proto_admin, u16 link_width)
-{
-	MLXSW_REG_ZERO(ptys, payload);
-	mlxsw_reg_ptys_local_port_set(payload, local_port);
-	mlxsw_reg_ptys_proto_mask_set(payload, MLXSW_REG_PTYS_PROTO_MASK_IB);
-	mlxsw_reg_ptys_ib_proto_admin_set(payload, proto_admin);
-	mlxsw_reg_ptys_ib_link_width_admin_set(payload, link_width);
-}
-
-static inline void mlxsw_reg_ptys_ib_unpack(char *payload, u16 *p_ib_proto_cap,
-					    u16 *p_ib_link_width_cap,
-					    u16 *p_ib_proto_oper,
-					    u16 *p_ib_link_width_oper)
-{
-	if (p_ib_proto_cap)
-		*p_ib_proto_cap = mlxsw_reg_ptys_ib_proto_cap_get(payload);
-	if (p_ib_link_width_cap)
-		*p_ib_link_width_cap =
-			mlxsw_reg_ptys_ib_link_width_cap_get(payload);
-	if (p_ib_proto_oper)
-		*p_ib_proto_oper = mlxsw_reg_ptys_ib_proto_oper_get(payload);
-	if (p_ib_link_width_oper)
-		*p_ib_link_width_oper =
-			mlxsw_reg_ptys_ib_link_width_oper_get(payload);
-}
-
 /* PPAD - Port Physical Address Register
  * -------------------------------------
  * The PPAD register configures the per port physical MAC address.
@@ -5666,27 +5596,6 @@ static inline void mlxsw_reg_ppcnt_pack(char *payload, u16 local_port,
 	mlxsw_reg_ppcnt_prio_tc_set(payload, prio_tc);
 }
 
-/* PLIB - Port Local to InfiniBand Port
- * ------------------------------------
- * The PLIB register performs mapping from Local Port into InfiniBand Port.
- */
-#define MLXSW_REG_PLIB_ID 0x500A
-#define MLXSW_REG_PLIB_LEN 0x10
-
-MLXSW_REG_DEFINE(plib, MLXSW_REG_PLIB_ID, MLXSW_REG_PLIB_LEN);
-
-/* reg_plib_local_port
- * Local port number.
- * Access: Index
- */
-MLXSW_ITEM32_LP(reg, plib, 0x00, 16, 0x00, 12);
-
-/* reg_plib_ib_port
- * InfiniBand port remapping for local_port.
- * Access: RW
- */
-MLXSW_ITEM32(reg, plib, ib_port, 0x00, 0, 8);
-
 /* PPTB - Port Prio To Buffer Register
  * -----------------------------------
  * Configures the switch priority to buffer table.
@@ -12962,7 +12871,6 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(paos),
 	MLXSW_REG(pfcc),
 	MLXSW_REG(ppcnt),
-	MLXSW_REG(plib),
 	MLXSW_REG(pptb),
 	MLXSW_REG(pbmc),
 	MLXSW_REG(pspa),
-- 
2.35.3

