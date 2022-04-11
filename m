Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EBE4FBF83
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347469AbiDKOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347466AbiDKOuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:50:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FEE220DA
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:48:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJ71MYc5scRIW/ZqBKswCKCGCLp15FOJgx9QUtZ5DWZqXZsIYQ50uZ87535BpdM0bHt3FY2375Grvpz2arcYGX0fQuA6x7YUbli5jFms5Yz4ZOosU1fVqO+Pxws4+Z4k6XhkBUTVXZ59xYq/242vZnpuewkEra0rNANqdzLJ06ZJyPMsgwB7SR8BB2gQTRn+uYIpCjgrV1vQEMKldyB2y5qlPHrhilLcD/chpxBbPHl2DPLuilkH9AGm+ujjUC1AfyYfkJ4rm6sCLCC7/yrGjb6T3ux9hik7b2GUfjZ9Rw4V4rh19H107+dYUzbdMNY4yGRyff6BLQ4wjK9ySh5iDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXdsmu1oOy1DpV1VTV8SIMOms9BOMp53azlnkaTPY3A=;
 b=aQoUE8gFQRgD0+6X7GUXZOdWA/YroAhBGsosJ6pmeNnBlUjM/y46MHYmhpPPlpV+gANrQeAobNq0B41YQtU2yTuyia+hPGlHr6C+AMNvROek/ZBELL3OI54CZm5eFDPJDj+XaGcTzSEsF3wyxsnqjoFShWFzmBti1u+rNLxRy185sZJh8jPImdBbcNAFOCXe3ZPDSuafdEnXnTroN69p4F/vgU1LrhKgvXmhIXnQvcYle9uGxmIwaUBqxLtLMIFnfclm6jS3n+50c3FnKaasfBgzHSSBW6/PtwbxfPWFRViAyOuJV3RBb2/k4KIVezOKC0mIGt2pcgTON2we+MQ9vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXdsmu1oOy1DpV1VTV8SIMOms9BOMp53azlnkaTPY3A=;
 b=cV70aoiaXrxmtgWGRnDPXcIsd/x/9W8RpBFftvYRuD0HoTkSjXLHsedRXzjuqAD/90WKKDa7pjDjmti2uc73FL2XEilCagI969EXKv3Whb3ooKYpRoSKRMCd89F3qHHkdR8V98wILgVRuqjHI1tE7aQJMlfKaddgDQiwMI216v3IhwjMpuLB3HM3UiFhJlsJBADtKhDCTZT8AJDqPE9iZgqb8GUg+K/9oKJP6/xoU0pWfItJC9a0tqmVoBFcYBmcdqC47/y5qIe4HR4SnUAG6Tege6iVk3Arvr0Khlw007ismQe4GJKbQbepSC53d3ZDuEjRBAw8tniO1Q56xzIz+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5067.namprd12.prod.outlook.com (2603:10b6:408:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:48:01 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:48:01 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: reg: Extend MGPIR register with new slot fields
Date:   Mon, 11 Apr 2022 17:46:55 +0300
Message-Id: <20220411144657.2655752-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0117.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 481cf512-9fb7-4021-105e-08da1bca46de
X-MS-TrafficTypeDiagnostic: BN9PR12MB5067:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5067E0BF939706007ED6A310B2EA9@BN9PR12MB5067.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iurBUqHLJGgv3K9cKG+80gQTr0nQfh4sshVLf7BP4V2w/JV8sSE7hUXdHogYUKGK7lpPbpFIJ/o0Wmc/s6f66KJGXxtPXPVKFO6y4tVwCH0hFIjt0qcppwy+x5B4W+Ehqq9opHoRwaigNTHiYa0XC450xEtq5tMskycSufKELh3GolbFfkgYvdk+CL5RPD+/5sL3vn9qh2lpaK+/Sfw9WVN4ygh9iw8dU/Ofx4RCuYP8kAZRiEh3wa7YQnpChu8Pg6Rfd1f6X8A1pYQnNbLSCtZvj0/4HQajZS8AUeQyU4gqi2pq2HPUOlEKO5mJHhUW5OpDI5pxpl5Rf0l6bP73ymokcCjFWM3y+B3dkH8W8/PA8czIWD1MSIGUoryXHQfLJr4yucT3QMz8E2TBq3FT4sqsUFI+gCW/oaSyfisWQpmKXWbhX9MvgMaV0E/LW7l7pWPpgDADhUm9ekxW+MdZ71TYhs+1XKFxC5H1seTtFATYjoXfgc5R8cxNpbwA/4U79DTRkSwzy06j7xTSa9VNnjSr5+ilFVvorbZPZXdUvnW8sO9vtRTv21mIG6d4ssOWpZq+md+qb82C2TB9M16x0lTyqdIO5DBeRWxiGrtZJrI9ufHymdTg9cZ26W1sCpv3XqipQJk/jEiMBKbhLxgC5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(316002)(6512007)(6666004)(6506007)(186003)(26005)(1076003)(6916009)(6486002)(508600001)(5660300002)(2616005)(8936002)(2906002)(36756003)(4326008)(86362001)(8676002)(66946007)(66476007)(107886003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6QFMwy5o6yYHNk+7XPbh6x6Hw2fHBkloNjMIJ7Qm0WL9aUKuqyMNN13slxpN?=
 =?us-ascii?Q?KxNbLcJZxFv+XfyMJe//hIL4C+TuFKx+1jWENTXlXFYYJx4hVFjmGP9gKjqx?=
 =?us-ascii?Q?Nxv4QDGvB/mb9PA+guPPsQ2emTSe3hktQY2/iZVmkiFbzb0ThjOsf5WqN7Sa?=
 =?us-ascii?Q?InNClBeJxSSdGe5iW3H+drewqgK4d/dgvMrUe8dh8y0Hca+IQGSrLOfv8DZk?=
 =?us-ascii?Q?jwvPcu1oX0N4n7KhjdZXnaf/dt45p+WxJE1aCthnnsvNq4OCjKvTy6bGh7ln?=
 =?us-ascii?Q?Y4TQ7v+y2cl/ExMuuLPeB+houKQx7LqY8nbUAPR1M2AFUYr43alDPzH1ddiD?=
 =?us-ascii?Q?MPvPIB7DtXTcc4wPoJ/BUjpAvYxNvFrk3qSgrSPPxI90GHJIHzJu611elbhn?=
 =?us-ascii?Q?oizZQXN7S/+zD9qvCK/xDCGRA+qNoVNYDjkm7FYP2O+nlrg4K7r1vI6OpWis?=
 =?us-ascii?Q?8bg2jTdwwDwJCKQU+AtU66ke+8su7DaRj/eC47Mu1w93swLKWtvKMeqQiJcZ?=
 =?us-ascii?Q?AP1iqVdJISTmSBiloteycHYJ1Qph/jAqdV+OooOz/PcQE8+TlsHA44c7IpQa?=
 =?us-ascii?Q?e5PP0Rm9pMNn0CuG0/HA+okZiLWIFTjI5dtqxT1B0DXVFuvLIbyw0OWQfeEw?=
 =?us-ascii?Q?nPNA/fbP7K7MNb0xy/B0K3x/evacZgjBovKLmYLv9QX+7g4Pj3d+T4ib218b?=
 =?us-ascii?Q?VfmpoZtZXCv6xJPlkgsScb8S7K2BgU1BzfJAE2iOUl4Y0WTWDnq8kI/hpRD1?=
 =?us-ascii?Q?+LvC5od9uJlvRSar+s5VaWxRd3ebIiOg7KRyPog5Dai3lOreEAJDv8N2+ESY?=
 =?us-ascii?Q?tYf214j24D7eOpVa4GpQ9zb67mrRP0jzSEBzDq5jaYjNhwcUtyIsuQHkozsA?=
 =?us-ascii?Q?ymB7TC49hn+qpzbafOMHJAK9yeDX8R4fL0KAMNYSXed2I8VsPcecmUEI313R?=
 =?us-ascii?Q?ujVGk0CBTzOCvIMIofVP7maunscBZcLXHePNGgyC1FpJF5OQoe4nJHqYHHlY?=
 =?us-ascii?Q?YiAMxs6suUiV0DrMrbDGW24CG+zMQfsyZQbT6rCylx0DsaVPVSWIZqU0BLCd?=
 =?us-ascii?Q?hL59QU8Sh8G3hkqrmEx0lUcGOEbJY2KMGUJGwCF2OK9xIbVpNpUWpW2fzc8a?=
 =?us-ascii?Q?foi3NlwVmd2K/rGfTSxO9WGvkwDNpZNX9bZNVIW27OA+Tvsd2aQN4qXORsmU?=
 =?us-ascii?Q?qAtosoBIOla7LlNtrAW/nL9zyTa9rvJ1AXDdDwjT7TQPYwtam6wxZw7wR+ww?=
 =?us-ascii?Q?qrrswk/7Lv17WQA0s6R19Q2c1Y6kL5GYvpSnDc2xsBtcOjIu0HgbTOBvUXjw?=
 =?us-ascii?Q?vUbJnoLHjeG9PYIhnfUPBVPRzA+1dseUCzzEK1i95IikKA18dtqgPgD9f4dD?=
 =?us-ascii?Q?t/hBZSlhraRjUOh6ArzS98Knz6QT+ws0p+TfZV/dEOQoiqgWk86g9GEXJdYS?=
 =?us-ascii?Q?2Xq8gvoa3J7xYebzPJS1WSOcot8i7rHte+iJ7jums+EVb3t9HQ+gVVALmoWC?=
 =?us-ascii?Q?L9z1Zy9jt0mKNBY6/B/aMtChfnRS9r3RdzEG5AdfutoWzbF9y8kSxY0eqJDY?=
 =?us-ascii?Q?v2rOlpz46Q6N9ILHmRn7Y2YKrPpKq9pxRjYqd53f+AHjxuIWl02yOwQNVCad?=
 =?us-ascii?Q?raruHb5RBfhlbj4s1F2j09N6Zlh06YX/IQvADkv3vsTPZ0IwzAlLCpc+obCm?=
 =?us-ascii?Q?Y6yvKy1w4Tv9SZz35VO4vsvcXRLMw5qXkeGi57QTYBR+PAZuEayoluevKC1t?=
 =?us-ascii?Q?I1KcE6hWKw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481cf512-9fb7-4021-105e-08da1bca46de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:48:01.5317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwQZ8yS81if/wsLyNOS5AygSLTkZv9CDLAXBDM+cA2C9U1wMbR0J31G2V717UfeJ5H+/t29un7CFM5g+9mMVPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5067
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Extend MGPIR (Management General Peripheral Information Register) with
new fields specifying the slot number and number of the slots available
on system. The purpose of these fields is:
- to support access to MPGIR register on modular system for getting the
  number of cages, equipped on the line card, inserted at specified
  slot. In case slot number is set zero, MGPIR will provide the
  information for the main board. For Top of the Rack (non-modular)
  system it will provide the same as before.
- to provide the number of slots supported by system. This data is
  relevant only in case slot number is set zero.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    |  4 ++--
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  9 +++++----
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  8 ++++----
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 20 +++++++++++++++++--
 4 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 8cee3e317a5b..8b4205c098d2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -1060,12 +1060,12 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	u8 module_count;
 	int i, err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl);
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, &module_count);
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, &module_count, NULL);
 
 	env = kzalloc(struct_size(env, module_info, module_count), GFP_KERNEL);
 	if (!env)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index f4bc711a16cf..2bc4c4556895 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -656,13 +656,13 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	u8 module_sensor_max;
 	int i, err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl);
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
 
 	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL,
-			       &module_sensor_max);
+			       &module_sensor_max, NULL);
 
 	/* Add extra attributes for module temperature. Sensor index is
 	 * assigned to sensor_count value, while all indexed before
@@ -707,12 +707,13 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	u8 gbox_num;
 	int err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl);
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, &device_type, NULL, NULL);
+	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, &device_type, NULL, NULL,
+			       NULL);
 	if (device_type != MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE ||
 	    !gbox_num)
 		return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 65ab04e32972..adb2820430b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -746,13 +746,13 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	int i, err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl);
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
 	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
 
 	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL,
-			       &thermal->tz_module_num);
+			       &thermal->tz_module_num, NULL);
 
 	thermal->tz_module_arr = kcalloc(thermal->tz_module_num,
 					 sizeof(*thermal->tz_module_arr),
@@ -837,13 +837,13 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 	int i;
 	int err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl);
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
 	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
 
 	mlxsw_reg_mgpir_unpack(mgpir_pl, &gbox_num, &device_type, NULL,
-			       NULL);
+			       NULL, NULL);
 	if (device_type != MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE ||
 	    !gbox_num)
 		return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5bf8ad32cb8e..f0c90e66aa32 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11362,6 +11362,12 @@ enum mlxsw_reg_mgpir_device_type {
 	MLXSW_REG_MGPIR_DEVICE_TYPE_GEARBOX_DIE,
 };
 
+/* mgpir_slot_index
+ * Slot index (0: Main board).
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mgpir, slot_index, 0x00, 28, 4);
+
 /* mgpir_device_type
  * Access: RO
  */
@@ -11379,21 +11385,29 @@ MLXSW_ITEM32(reg, mgpir, devices_per_flash, 0x00, 16, 8);
  */
 MLXSW_ITEM32(reg, mgpir, num_of_devices, 0x00, 0, 8);
 
+/* mgpir_num_of_slots
+ * Number of slots in the system.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgpir, num_of_slots, 0x04, 8, 8);
+
 /* mgpir_num_of_modules
  * Number of modules.
  * Access: RO
  */
 MLXSW_ITEM32(reg, mgpir, num_of_modules, 0x04, 0, 8);
 
-static inline void mlxsw_reg_mgpir_pack(char *payload)
+static inline void mlxsw_reg_mgpir_pack(char *payload, u8 slot_index)
 {
 	MLXSW_REG_ZERO(mgpir, payload);
+	mlxsw_reg_mgpir_slot_index_set(payload, slot_index);
 }
 
 static inline void
 mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
 		       enum mlxsw_reg_mgpir_device_type *device_type,
-		       u8 *devices_per_flash, u8 *num_of_modules)
+		       u8 *devices_per_flash, u8 *num_of_modules,
+		       u8 *num_of_slots)
 {
 	if (num_of_devices)
 		*num_of_devices = mlxsw_reg_mgpir_num_of_devices_get(payload);
@@ -11404,6 +11418,8 @@ mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
 				mlxsw_reg_mgpir_devices_per_flash_get(payload);
 	if (num_of_modules)
 		*num_of_modules = mlxsw_reg_mgpir_num_of_modules_get(payload);
+	if (num_of_slots)
+		*num_of_slots = mlxsw_reg_mgpir_num_of_slots_get(payload);
 }
 
 /* MFDE - Monitoring FW Debug Register
-- 
2.33.1

