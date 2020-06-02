Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877B51EBA71
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgFBLcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:32:14 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:6161
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726935AbgFBLcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 07:32:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqCEQ+QscslEDN58hA7Bz73zP7/0SNTC3tHeIyezrQZptRSYykhg2UkWQqHstRkjDjXGljKNq5wU6L6UJPpeYNgR7qgw+bHLLOKVjYwC6HriAMrJxNlalwT5bDDm6ma77f9sQyrvCu/WeQx0QSMeFNT9REjwFyiqmf/AHOb4i7hQq3TTnNiN/gimGvhFwfsUe5y15jdlO9SwhefvEw3OnTEBHvDa2hTPThMISsvKFAFx9QfnND+T+WPNvIGz1XCCWGXOA/Y1Hc0YhltgMd5Uz/HjFosbey7qqikRnykYGj6aj8XBF4bjUGZne0HTTWxC7VSrq1eMBwi/DaWAfjaNEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcbuDQM2FcFBs4tTi4OHJy2YWx/U806AJW1ehypeJcg=;
 b=LEwrO4SEGe036tvWTHLjoJuGObiH3VFGfrQPmpRBrVapHkK5Ul4tkGVL5RvNBQZX6NyI0Mfy5MtDBNz7LxCPWNIWyoieqYEcNPZfeM/R+G0RLAWKDQZZXY4Cp/D4zvN50eWUqghj6kyIZfA8vc3BKjgI+VBIkrUBXQJ98XLVMImiPxQeJcNziF016Hlw/pBF9eeRVbpyDsrUUzFlG5AJVAT2Ct4swv1OX62R+wfkEAIaWN6k50LXeRuyKQsIXMYpkNOqeywFhWgt/uhY8XqRTNPF5GYN/QVBCJ4QvLUwYKhWEzS7NWArpbaRYUTMZcLiTXtuqnHs2juSgWqCFQK3BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcbuDQM2FcFBs4tTi4OHJy2YWx/U806AJW1ehypeJcg=;
 b=c/OUuxsjRTynyV2SLM8GdJq3DOBU7Q7kO4SnCHZBAX2cE5ZHxqA5YZiHNByO3zNNwwDWDB72GXQQ+nDixKoXuNxpjMzvbghzzFAtUv9Erk9mS2szHuUEPPjcxGfd2OcknwFQ5VsHH7ccR82rEQnQYp04AY+2uV9hVDldwCmQOcA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6628.eurprd05.prod.outlook.com (2603:10a6:20b:15b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 11:32:02 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 11:32:02 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, michael.chan@broadcom.com, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [RFC PATCH net-next 6/8] mlxsw: Set port split ability attribute in driver
Date:   Tue,  2 Jun 2020 14:31:17 +0300
Message-Id: <20200602113119.36665-7-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200602113119.36665-1-danieller@mellanox.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21 via Frontend Transport; Tue, 2 Jun 2020 11:32:00 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e58a551-6b54-40ac-cf6f-08d806e891b5
X-MS-TrafficTypeDiagnostic: AM0PR05MB6628:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6628243662DBB677CB12AE3FD58B0@AM0PR05MB6628.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5Dn8iBvDZz5gzkyd2uQQcLfJOm4YEo1USzYVCN1Y+wJq3M9ym29ke0r08hNSepGZFyVPPg7iGqzfeMH/fxYtYeWJmFCr8130UWwBZm4jMXmNYCWEn6NYvj9B0msvaRIbOB7GR8BKweb55+naNXH+Vfbzt36VkbHwa5ubJNvcXN+MJw9OXSTc8znHxWmymwGtRZmax6GBr+4PgD1hRsXxSxp/jDG+HFln6Sr5q3JR4tdlZ67Egq+LQn9sGpaantY9ppNOSfLpMemnSoOt5zfhOPMc06Z3VATQdTDFTOZEZIdWhZf7YL5/AMmzvOgCbP+m0806v4VLqM4+tk76nupBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(186003)(16526019)(26005)(83380400001)(6506007)(86362001)(36756003)(2616005)(2906002)(52116002)(107886003)(6916009)(956004)(6486002)(8676002)(7416002)(66556008)(478600001)(6666004)(6512007)(66476007)(66946007)(5660300002)(316002)(4326008)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2pEu7ciepJczlmBKLctZQVSRdLdDZdf+neiGs/QYLAbPyqvjNzEcHc4hqRoJG2wj7x/TFLmoTy0dQfsfvG1XSsRfgoYsEzfiyhabWrr063vRlaSaNAbswXqQRhjey+NLYymzbJMBMEAtw4hVfFpt/QCPlQ36mecLHaEOaxZ8P9H2BkWsn3v9Wq/RP/vtOp1vPJo2Ysd1sS91qGyBHWoUY34WJT4cHvShr6uy11xPpewTYdIozTa6OfvzZo/u5Rvo16PrD4tbUWlszMG5pyNuOYW1tpmCvMGS6aJNNTrkoe0PXvCc43hbPSNvcR9A4iJI5/ygmYNZUselckRfGAD/x7c74A6eQ54bu09wMxl5EyDucUXxZ/HR51azCEWJHJt/LmXWlQiIBsTLuhNdhKvadFwwqXBn+ZdgpXE1gJZiCD6s/uSdmeL4o5fXp4Qx71hyTD/T/jk6+GGldFB7hv7sz37QNsiJkSHpOErc+yAUdwU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e58a551-6b54-40ac-cf6f-08d806e891b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 11:32:02.1674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8QDzxiwCnEehpfW69p+Eg5JeJL1iAUnVDaIwV8QufsuVriDnvB69yC4NdbTNbzJ70614b/iItqTparquC7C9gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, port attributes like flavour, port number and whether the port
was split are set when initializing a port.

Set the split ability of the port as well, based on port_mapping->width
field and split attribute of devlink port in spectrum, so that it could be
easily passed to devlink in the next patch.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 9 +++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 5 ++---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 drivers/net/ethernet/mellanox/mlxsw/switchib.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 2 +-
 6 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 6cde196f6b70..f85f5d88d331 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2122,7 +2122,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 				  enum devlink_port_flavour flavour,
 				  u32 port_number, bool split,
 				  u32 split_port_subnumber,
-				  u32 lanes,
+				  bool splittable, u32 lanes,
 				  const unsigned char *switch_id,
 				  unsigned char switch_id_len)
 {
@@ -2161,14 +2161,15 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
-			 u32 lanes,
+			 bool splittable, u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len)
 {
 	return __mlxsw_core_port_init(mlxsw_core, local_port,
 				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				      port_number, split, split_port_subnumber,
-				      lanes, switch_id, switch_id_len);
+				      splittable, lanes,
+				      switch_id, switch_id_len);
 }
 EXPORT_SYMBOL(mlxsw_core_port_init);
 
@@ -2189,7 +2190,7 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 
 	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
 				     DEVLINK_PORT_FLAVOUR_CPU,
-				     0, false, 0, 0,
+				     0, false, 0, false, 0,
 				     switch_id, switch_id_len);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b5c02e6e6865..7d6b0a232789 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -191,9 +191,8 @@ void mlxsw_core_lag_mapping_clear(struct mlxsw_core *mlxsw_core,
 
 void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port);
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
-			 u32 port_number, bool split,
-			 u32 split_port_subnumber,
-			 u32 lanes,
+			 u32 port_number, bool split, u32 split_port_subnumber,
+			 bool splittable, u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
 void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index f9c9d7baf3be..c010db2c9dba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -164,8 +164,8 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_m->core, local_port,
-				   module + 1, false, 0, 0,
-				   mlxsw_m->base_mac,
+				   module + 1, false, 0, false,
+				   0, mlxsw_m->base_mac,
 				   sizeof(mlxsw_m->base_mac));
 	if (err) {
 		dev_err(mlxsw_m->bus_info->dev, "Port %d: Failed to init core port\n",
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4b4d639d9ba6..f40a499b7e76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3246,12 +3246,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	u32 lanes = port_mapping->width;
 	struct net_device *dev;
+	bool splittable;
 	int err;
 
+	splittable = lanes > 1 && !split;
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
 				   port_mapping->module + 1, split,
 				   port_mapping->lane / lanes,
-				   lanes,
+				   splittable, lanes,
 				   mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchib.c b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
index 1b446e6071b2..1e561132eb1e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchib.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
@@ -281,7 +281,7 @@ static int mlxsw_sib_port_create(struct mlxsw_sib *mlxsw_sib, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sib->core, local_port,
-				   module + 1, false, 0, 0,
+				   module + 1, false, 0, false, 0,
 				   mlxsw_sib->hw_id, sizeof(mlxsw_sib->hw_id));
 	if (err) {
 		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to init core port\n",
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index ac4cd7c23439..6f9a725662fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1107,7 +1107,7 @@ static int mlxsw_sx_port_eth_create(struct mlxsw_sx *mlxsw_sx, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sx->core, local_port,
-				   module + 1, false, 0, 0,
+				   module + 1, false, 0, false, 0,
 				   mlxsw_sx->hw_id, sizeof(mlxsw_sx->hw_id));
 	if (err) {
 		dev_err(mlxsw_sx->bus_info->dev, "Port %d: Failed to init core port\n",
-- 
2.20.1

