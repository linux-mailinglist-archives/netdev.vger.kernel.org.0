Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134C649DD3B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbiA0JDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:25 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:31201
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234583AbiA0JDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MR19RscsQX1uD+zktQzP1G17q24IGkDwkS6KYhTMLHc2qzUqtrtAy1j2DnRG2zd8uq64um4u7ARdSG6svKyw+4es45Z7D7PNC1e08fHhI1OVEXpYgfqkiAXd3yDgT/MUHkC/6l3rMOpvmxPPGPq/sUpkEjpx/G2vdowBvbOt2SxrmkqBBRNhSCZ+HgsdV+Znnz2a1bhpq4V+cXhlrX3VFCB2TV0fXFlugRdMQY7MUWU969EJ6JpxjjL7j+YETTROwWGAF3LTSrRgXEAVa+ZqJKfprTuxnrT9p1Ps7ucrL82oGgLz3uSgIFIMhZSQkV5GmzCoTPSHxa6Mk2T9lO96/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oaz6YiHBDK/S8qYg7YimCt1ZGu8MoiWmIGb4flpr08Y=;
 b=AfhI92BZNC9c7BBYQhCW27bDN6CYIkxtbiVLT5eUm01A6MCg1vLeYMnJvG8mLARm9qag9EogIbeZL6bs6ZZTdgNpMXvGU6i6LLReDgqdaqSnj9aCeE1baedggHT9Kga6dQrU01HfDQPkiOXnkmzzgRDvYebDoYup9xQIYqXDJ5hG0IqtbbgmbazbeSGuoWozgeoET5QGXE9iWU9jLetZKxcRxm3zQVpsO3IgQECATnMGlezJfa6RyztIyaZAC0+kBsZ9HrVNSUBLhrtp6ZMPkPa1oC6mWhQhy/kWyJVnz1+NVYThv4FVimQxGN4hSEsInRr9NrodC+KzQWIvrTyW7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaz6YiHBDK/S8qYg7YimCt1ZGu8MoiWmIGb4flpr08Y=;
 b=HRCpnUyxMIzy2sTCmtJIuGnTOqA4Pdb1XjO10Gb2ZsjjG4CcQ9JuZH8DcMUnf8HgRGXWQ0tOmF8LbnmO+7cnLZdYBt5HEiNlUHYZMAoPsldyefJQYTTt13bWXneprqPhmZ8Iim+BzRqhg+1h/3oBcICuthFNLlKiSvLZvSPpBWL00tN5gLlQhMPlmOEJg7z7K6+n/VKsjpMldNyab28Hee/rTQLOoEvIEf59hgmQ9lvE2Z9GEtJUnTCXP6rogSrucE3A2ZXm67OhbaIUS3sLhmiw+OhZ37+psQzufERuewEzPTfbQfRJy64DHowupawA6lfSAcG1QcFJrqVc5aTPQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:17 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/7] mlxsw: core: Move basic trap group initialization from spectrum.c
Date:   Thu, 27 Jan 2022 11:02:22 +0200
Message-Id: <20220127090226.283442-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
References: <20220127090226.283442-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0102.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::28) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 050b5b12-55dd-43b7-e2c0-08d9e173dbe1
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53552AE232641607B273A5E6B2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ar/XbjbVCKTty30+lOYqDAIutXWhxygsSFzic4UImd0eT6us8UEPhXeSJNInm3VMWgBRo/xI9/d0+PurqCfbJjuQ1GWgrh+6/5x8JxnsSYKWi0Dkjix9XKOcdqERVEDG6fwSCqBPXov8BIO1WGCB8ke7BF7ijvR1NYg/HZysRsEViySoJdVNxByhBOVg0/Zo8Ky0OaXk5QD0lb4nkGkXsysuJykIBvSfsRFikVD25slb4RUiIxLWYEbowcRz+Ryt3sh5/g6oUHPlQMY+nmdcFnQa3CwXyeMJmgSCgxlFGCgzMWVh3jMWOSMugXiA/yr+R9vGbg6tHVy2qIjQGAuqYJkUEGJVfGYbzwUEw0cmlNoV3tEaRXaNeVY3H/MlVYvhLPTVrUzNGyjHJJJBuAmWePOmIzYpbVhrt5QrO2SgPySksJFi7+hVm7EQikVa5HZKEJhQXvWYOh6FGBUYxsEu6JBeCpjHs9qA/pS0TDpa68//rVWw3A3RdPZ3+6x3oK41y8QzfUTVum2nEb5dANX36+jKHpGQH9NNky0a1OOkO9zPvVclKc6ypd+ziQvOwSWnlIDoZ0FjjGNnkHRiM2IofcANKErwl+gSmHeMCY9UVQrFpQXxecvVGn+nbcgWTz/3VpBaDZ4dvisC9X60/+QyWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(6666004)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S7ueKOM6hDJJ33Ls1DFOSD+SsVe2l06Zwi9GuYEjUV+dNrcyQyrOFYGbIj1e?=
 =?us-ascii?Q?F+UJHAEp/Drp0PCGmrVVwFgoQHDm32g55lltRDME7H5jCZjZWSuHqN2HAjIk?=
 =?us-ascii?Q?s5fj5YkoPXVOMu0fRfcGvoA65KOMbI7B4JjFoKsV4gM2BNWAYGpfj8hmgHNN?=
 =?us-ascii?Q?ix/wJZMinVgJOM5pH8ZiZL2tDHPQeRBvSjoU0+tJnxSwokwN8JDSXP5GVChg?=
 =?us-ascii?Q?K4jp5epvX1hd26y4SwpVp0Ogr4XcKE30+4uDTi8p82lVpVAEiOJGfoBegp/T?=
 =?us-ascii?Q?e2yO6FzflOE1m6fzy6EWBohF4upd8t2fokxwW6YDzHjr0HRajeiwNfMFtgRF?=
 =?us-ascii?Q?FJo9cfws7A0AADo8aip74qNaK+mnmatE1aS10IuNs5mGJ25InlcN51QsIPGM?=
 =?us-ascii?Q?QeVHlS9RyPV+hqLmgMi4RkkjTkJINKMdjcFZYFyxCrydle13jQq0bjg4V1mO?=
 =?us-ascii?Q?OBCgMprxEbcwh/IH8H9sJkNMlCl+i7qlYTPNH8N2O3uDnhKUvD0E9/wFA34/?=
 =?us-ascii?Q?ZdJaPW9CEQfPxQhF0ok+imjptucXDhxHYyBr9OqRY0/Sf9McTfgmAP2P5uvc?=
 =?us-ascii?Q?+l5mPyCMONmCTDplVyb2ns+PY7UqZ/u0LFT6w4kKNas0whMbqNv4KijQICC4?=
 =?us-ascii?Q?6f2BpTnqDl1Gf6LSGaO/HsT60+P0GUaAHCWgFZlGbrzwNCZTrNvc9lZ1cyDi?=
 =?us-ascii?Q?rPlZZ4iEVi2sXpWGC7zHR68A1Sw/FBdjSNfXfF4570T4SlLqYvn7bjL/iEIs?=
 =?us-ascii?Q?A8P3rcBIqAg0AuumYfJBLHESFQIjaRLxBQu6Gu4EQyJE2VUq5HKKzCZnb1v3?=
 =?us-ascii?Q?vSis1jJ3jaxEO1cKTw9eCMNySGzt/KsHN/dI/3zFI5M0sk2BHN8bwmCBFWLr?=
 =?us-ascii?Q?Q8/cBiBLqwkMnS7qOYsOFOMTjNmlgl3jOfls1YwcGh21S3Gh9h5jdzpB6ET1?=
 =?us-ascii?Q?CH6ZWL7qJMCZlYQG0D0nmHKePczreHMQ+H+CsrjQdh+NlATdJKKcSQwe5Aff?=
 =?us-ascii?Q?jzQ4Y5RUD5K67Ff2n87fZx6QQH5WpVHump7qDtlMhVhRg9kiflAW4GhJdRI1?=
 =?us-ascii?Q?5NkIPXm3MkfHJcXfIy6LlxGMjCt9vPJInszeNGJnavesS95q2MgvxEMZ2GqB?=
 =?us-ascii?Q?Xq9t8lQEC41la5+k29Q/m8BRNmXpxZEs/ha8n2lYpmReglRF5eztOl1p4WsD?=
 =?us-ascii?Q?0jT8pd0gvmnPOn0oe9wF+3KvcnPlyG4wyawIl6HJwzQ7ulmmXIrpueBPUmAg?=
 =?us-ascii?Q?UhP5vz2xcMQLXD/ahqiw4tftkIolXF2TF4Oa15FWDSMY9G3pKH8g2XPH/tAG?=
 =?us-ascii?Q?I0eHiyJoKe79/IFrIUaFKuQ49dplYX7b5ZH1lrUmrwZJnJAiWufvFvZigLMq?=
 =?us-ascii?Q?nf9TKi6RTr2hXDWpJbZ5m/hUqkSzyXOW5hz+k1eAh3yISMwEZx+59rGeByO3?=
 =?us-ascii?Q?c1AAF+SMpcZb46mWPcJTHkydcqd8AUAzveKKyZgH2KzN6A6a3Nc1QpfmMU0l?=
 =?us-ascii?Q?rEQoyNDWF+vEs6JtAhGgLhUDPLNJ/rBY2ZjZKBm0jYXJ2rjxBbj/O/iSJNCc?=
 =?us-ascii?Q?lV7ubksJXDUcisR+9pbfNlgNrhOy+hovpQiISGd8YZZsh2ocahGbY+ch7BaL?=
 =?us-ascii?Q?zdXyVqxAW0fjTWOAqzEL1u0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 050b5b12-55dd-43b7-e2c0-08d9e173dbe1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:17.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OdxDGIGhs0N3IbMTJDgVxpRi/UlVSmfl7t/V5ex5QuWIMi/V0Hyh4fG0aPtQJSA9OQH1FPTLp29DAkE5BZS/Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of initializing the trap groups used by core in spectrum.c
over op, do it directly in core.c

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 22 +++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  1 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 29 -------------------
 3 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index c9fb7425866c..20133daa54f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -212,9 +212,29 @@ struct mlxsw_event_listener_item {
 	void *priv;
 };
 
+static const u8 mlxsw_core_trap_groups[] = {
+	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
+	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
+	MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
+	MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
+};
+
 static int mlxsw_core_trap_groups_set(struct mlxsw_core *mlxsw_core)
 {
-	return mlxsw_core->driver->basic_trap_groups_set(mlxsw_core);
+	char htgt_pl[MLXSW_REG_HTGT_LEN];
+	int err;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mlxsw_core_trap_groups); i++) {
+		mlxsw_reg_htgt_pack(htgt_pl, mlxsw_core_trap_groups[i],
+				    MLXSW_REG_HTGT_INVALID_POLICER,
+				    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
+				    MLXSW_REG_HTGT_DEFAULT_TC);
+		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
+		if (err)
+			return err;
+	}
+	return 0;
 }
 
 /******************
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index f30bb8614e69..42e8d669be0a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -315,7 +315,6 @@ struct mlxsw_driver {
 		    const struct mlxsw_bus_info *mlxsw_bus_info,
 		    struct netlink_ext_ack *extack);
 	void (*fini)(struct mlxsw_core *mlxsw_core);
-	int (*basic_trap_groups_set)(struct mlxsw_core *mlxsw_core);
 	int (*port_type_set)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			     enum devlink_port_type new_type);
 	int (*port_split)(struct mlxsw_core *mlxsw_core, u16 local_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4c6497753912..0dc32c23394e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2528,31 +2528,6 @@ static void mlxsw_sp_lag_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp->lags);
 }
 
-static const u8 mlxsw_sp_basic_trap_groups[] = {
-	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
-	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
-	MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
-	MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
-};
-
-static int mlxsw_sp_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
-{
-	char htgt_pl[MLXSW_REG_HTGT_LEN];
-	int err;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_basic_trap_groups); i++) {
-		mlxsw_reg_htgt_pack(htgt_pl, mlxsw_sp_basic_trap_groups[i],
-				    MLXSW_REG_HTGT_INVALID_POLICER,
-				    MLXSW_REG_HTGT_DEFAULT_PRIORITY,
-				    MLXSW_REG_HTGT_DEFAULT_TC);
-		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
-		if (err)
-			return err;
-	}
-	return 0;
-}
-
 static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.clock_init	= mlxsw_sp1_ptp_clock_init,
 	.clock_fini	= mlxsw_sp1_ptp_clock_fini,
@@ -3666,7 +3641,6 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.fw_filename			= MLXSW_SP1_FW_FILENAME,
 	.init				= mlxsw_sp1_init,
 	.fini				= mlxsw_sp_fini,
-	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
@@ -3706,7 +3680,6 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.fw_filename			= MLXSW_SP2_FW_FILENAME,
 	.init				= mlxsw_sp2_init,
 	.fini				= mlxsw_sp_fini,
-	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
@@ -3747,7 +3720,6 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.fw_filename			= MLXSW_SP3_FW_FILENAME,
 	.init				= mlxsw_sp3_init,
 	.fini				= mlxsw_sp_fini,
-	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
@@ -3786,7 +3758,6 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.priv_size			= sizeof(struct mlxsw_sp),
 	.init				= mlxsw_sp4_init,
 	.fini				= mlxsw_sp_fini,
-	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
-- 
2.33.1

