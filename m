Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B88E5A2BFE
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbiHZQHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiHZQHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:07:35 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E5FD5723
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gg3VPn+tOiOTGA7kQupSIz9fTloPHNG3qYtzt8Vu1xEDecsNdrS2aIJlIJWoWOEBiDDglMpN3qsAxCWdO2G1o6STAeelnIyzejmhOqXD4AdvWYPBc+gUvhEjpZmdBs5mCHUZ1LU7i+h+yHUEhgwX0CfAulAa/1OApuBG+3YgRedAcy9V6vKIWYTkdUM9nAdLQnrTI6fly0B97x84PDX1GMdgbNr4PZ6bgZBniyY+9+MbdTLc2coYf2bLiNWAzqsqqVww8JNLhiRuF6y5YG8/aDkyRwWoN9w9/ZIGuTjTUzAwpQBrRl88WC2xJqmoNlvWm6IFebhJhUQZnSU52bSjaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOnhlVRb5UnPrUcITMKemw7A3hbP72Kna7fjnN4XWdY=;
 b=LBVYEIn1r6r7SVE09NbT0otY9TUM7eM+NxMnSS139PLiHCyH6Uutxo1toSB5jucw1GpDiJLNCNY76ZI/3wuCGeT4ajPdX3pox+PPi0cL64C0JyrRQkl03A22Riw6uKwIAoIELidrG0NCXb4c54kEh45hWDXgqrw/ka3FtP6TjqnGqnCS6brzJVYSxDtn8cwmpMhSCF3DCAi9s/PMjrTDlHn2G89GNqRwlFvgHPwww6nco/iBO3csM/379LhKAGbbMuMON4SsD8y7voHklZW/Xm94hWIJihP85ekDeBTU8RBIKYJ1ZRBGe2XG9z81p137DDTMrpZFIhQntA9Z1RgHOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOnhlVRb5UnPrUcITMKemw7A3hbP72Kna7fjnN4XWdY=;
 b=mA7C1qsx7RsrnayMr9eXPpHFVK1PB2CNbOuRCPXbkQ2SZxUAsw8nNuKo6Jar7H3il5Rpqaq1CyfWymvMtl5iC/+ggaw0XPAuqlKcxqb7QwzaszGHWVIVfwG2S15B4cy4gZYApRZC5230LZ1jMjQ+DmTQvveaNe5TwTUnx5JKfwzvmYxbE2IQ1SEz3/Gp6vkgtZvp3OMzQxOHwioclFe8gD8iRd6aLVhZt//9zm1i/RiKUEEJ55Fj+j55AGEis9s+tpSthMR0SasbNkIj5r1D+XALizN+Czpmj3wwRrUftJ5bRukn8KHTATDkEtI0DpDgKtNT3+0ec044JH/VzB7Dvg==
Received: from BN9PR03CA0455.namprd03.prod.outlook.com (2603:10b6:408:139::10)
 by MWHPR12MB1887.namprd12.prod.outlook.com (2603:10b6:300:111::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Fri, 26 Aug
 2022 16:07:31 +0000
Received: from BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::86) by BN9PR03CA0455.outlook.office365.com
 (2603:10b6:408:139::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Fri, 26 Aug 2022 16:07:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT088.mail.protection.outlook.com (10.13.177.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Fri, 26 Aug 2022 16:07:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 26 Aug
 2022 16:07:26 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 26 Aug
 2022 09:07:23 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/4] mlxsw: Add a helper function for getting maximum LAG ID
Date:   Fri, 26 Aug 2022 18:06:51 +0200
Message-ID: <8cb43cb5a2d278f2d1be75a36a95da6e926974c6.1661527928.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661527928.git.petrm@nvidia.com>
References: <cover.1661527928.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bd473d5-f980-43a1-fc3d-08da877d1456
X-MS-TrafficTypeDiagnostic: MWHPR12MB1887:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6W8U5xIDo2aS8E9TEGXda1gdwJdNayVDymNsSNjBcRCNrRWVpodRri0ftp9G5BWBUApFt86BKtK8EAJO5bCRzXE97dqcEuQegaCguf71nGitO0kkeFaKHCsRWTjoFy3OqsWE3K+jWokT6agRITpVgMj8dN1MyYDTZi7MmasFendUNVJcqQe2YAFBkGDBhPlXcjBb74u+ccmU14WvXf+hXcauPZMv3REypUUk6bUNQ0W6iuDIlPVmeO/bVIWDTGGEOOQ2SMJUX2ULmnDwsmlHxZRtEIRyJXx1RzzF44rrNEKLVJMoA+Dyd4ekO8P2xY1U9NDXYWYdJ5pP6Zj1hbTBHo13BcHszY/NrL6rDI/qJdJHhuZ1Q5rd3VAat6mTyQAvHpw3yBm6T7r3nNGgDgvKNUdD0NGRxxmM7IDFuJTsk0sdA+N0fOPjJnCdn9yIJOzqwy8B5cDWq+pleWP7HyD9hMnEkd/IJBVRB6AcEOsRd6ukXUSIsAJek/oB2eJgrb6jXafvLc7oTk6muGEgUm7BttFDLcdwSAzJ+E6CzzV9G+hFCx14Vz1XCs31lV1fxISfvIye7kQysLzUUAmLtIjW0A21rg/Tb9gL7X9oX/xKzUj2FYyosxs4dZSlrQsETUShIcEsI2Ri0EIXjgxPyGoWupEY3h3uc2iHKUrh+MWoiKhz7NcqxLw/ki/G0Z+MR7IRHcI9zxBKkOHP8JOzRFtupuCDEIaynBfQdwAoXhFhfZkg1obYNJcNPcg0bD9h9c6CdcHjj4y0NwxapB5mH/CRMqNQSz+Y4m6yq2nlIPaFFX1y0SxansvPWMn5tNxw6yC
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(136003)(40470700004)(36840700001)(46966006)(110136005)(336012)(26005)(41300700001)(6666004)(107886003)(82740400003)(82310400005)(478600001)(40480700001)(86362001)(16526019)(81166007)(40460700003)(2616005)(426003)(186003)(47076005)(356005)(2906002)(36756003)(8936002)(70586007)(5660300002)(70206006)(8676002)(4326008)(36860700001)(316002)(83380400001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 16:07:30.6378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd473d5-f980-43a1-fc3d-08da877d1456
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1887
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently the driver queries the maximum supported LAG ID from firmware.
This will not be accurate anymore once the driver will configure 'max_lag'
via CONFIG_PROFILE command.

For resource query, firmware returns the maximum LAG ID which is supported
by hardware. Software can configure firmware to do not allocate entries for
all the supported LAGs, and to limit LAG IDs. In this case, the resource
query will not return the actual maximum LAG ID.

Add a helper function for getting this value. In case that 'max_lag' field
was set during initialization, return the value which was used, otherwise,
query firmware for the maximum supported ID.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 25 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 20 +++++++++------
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index afbe046b35a0..1d14b1d8c500 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -186,6 +186,23 @@ unsigned int mlxsw_core_max_ports(const struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_max_ports);
 
+int mlxsw_core_max_lag(struct mlxsw_core *mlxsw_core, u16 *p_max_lag)
+{
+	struct mlxsw_driver *driver = mlxsw_core->driver;
+
+	if (driver->profile->used_max_lag) {
+		*p_max_lag = driver->profile->max_lag;
+		return 0;
+	}
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, MAX_LAG))
+		return -EIO;
+
+	*p_max_lag = MLXSW_CORE_RES_GET(mlxsw_core, MAX_LAG);
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_core_max_lag);
+
 void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core)
 {
 	return mlxsw_core->driver_priv;
@@ -2099,6 +2116,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	struct mlxsw_core *mlxsw_core;
 	struct mlxsw_driver *mlxsw_driver;
 	size_t alloc_size;
+	u16 max_lag;
 	int err;
 
 	mlxsw_driver = mlxsw_core_driver_get(device_kind);
@@ -2140,10 +2158,9 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_ports_init;
 
-	if (MLXSW_CORE_RES_VALID(mlxsw_core, MAX_LAG) &&
-	    MLXSW_CORE_RES_VALID(mlxsw_core, MAX_LAG_MEMBERS)) {
-		alloc_size = sizeof(*mlxsw_core->lag.mapping) *
-			MLXSW_CORE_RES_GET(mlxsw_core, MAX_LAG) *
+	err = mlxsw_core_max_lag(mlxsw_core, &max_lag);
+	if (!err && MLXSW_CORE_RES_VALID(mlxsw_core, MAX_LAG_MEMBERS)) {
+		alloc_size = sizeof(*mlxsw_core->lag.mapping) * max_lag *
 			MLXSW_CORE_RES_GET(mlxsw_core, MAX_LAG_MEMBERS);
 		mlxsw_core->lag.mapping = kzalloc(alloc_size, GFP_KERNEL);
 		if (!mlxsw_core->lag.mapping) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 383c423c3ef8..ca0c3d2bee6b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -35,6 +35,8 @@ struct mlxsw_fw_rev;
 
 unsigned int mlxsw_core_max_ports(const struct mlxsw_core *mlxsw_core);
 
+int mlxsw_core_max_lag(struct mlxsw_core *mlxsw_core, u16 *p_max_lag);
+
 void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core);
 
 struct mlxsw_linecards *mlxsw_core_linecards(struct mlxsw_core *mlxsw_core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 30c7b0e15721..c71a04050279 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2691,6 +2691,7 @@ static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
 static int mlxsw_sp_lag_init(struct mlxsw_sp *mlxsw_sp)
 {
 	char slcr_pl[MLXSW_REG_SLCR_LEN];
+	u16 max_lag;
 	u32 seed;
 	int err;
 
@@ -2709,12 +2710,14 @@ static int mlxsw_sp_lag_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		return err;
 
-	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_LAG) ||
-	    !MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_LAG_MEMBERS))
+	err = mlxsw_core_max_lag(mlxsw_sp->core, &max_lag);
+	if (err)
+		return err;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_LAG_MEMBERS))
 		return -EIO;
 
-	mlxsw_sp->lags = kcalloc(MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_LAG),
-				 sizeof(struct mlxsw_sp_upper),
+	mlxsw_sp->lags = kcalloc(max_lag, sizeof(struct mlxsw_sp_upper),
 				 GFP_KERNEL);
 	if (!mlxsw_sp->lags)
 		return -ENOMEM;
@@ -4263,10 +4266,13 @@ static int mlxsw_sp_lag_index_get(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_upper *lag;
 	int free_lag_id = -1;
-	u64 max_lag;
-	int i;
+	u16 max_lag;
+	int err, i;
+
+	err = mlxsw_core_max_lag(mlxsw_sp->core, &max_lag);
+	if (err)
+		return err;
 
-	max_lag = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_LAG);
 	for (i = 0; i < max_lag; i++) {
 		lag = mlxsw_sp_lag_get(mlxsw_sp, i);
 		if (lag->ref_count) {
-- 
2.35.3

