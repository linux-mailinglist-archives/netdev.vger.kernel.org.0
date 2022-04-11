Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1BD4FBF8A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347465AbiDKOuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347459AbiDKOtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:49:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99E0220C2
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:47:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nROUfcqMVYoNoNcvwghb/jtj7qlWJD8xzawMfvPzY1v00/PH244WqtFj2G6GNt4DFjkmrjjS4YKazvZRIcnMkYBvFzsBLHDLhK6oQsUyFW/uMGn6byaBsb7KZVd4stT4ZIWso382waJctbPKSCIZUtxbZUGNf71fLBSSkRxmmLfE1pnfNJPw641seaAzGS/PTM97L3plidwJpcNrWYQWcP7QNnL/G/MYPaNFUlPtszNee6qD9fPVXEMfZquZ9v5A+rEmWueyfdjXdst1ud+yokEwlse4EFYfR78h2a//9dp0phap4Oq0onCpOIUVAHlwd2NLJSW/E/rVxjvV7uXUDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sw9FHx3nDRbIR+45XlKgY/OerObrbi+pkq3uQko7JhY=;
 b=YSaxHY58W43e6DRm/rZmGxSuLDjKzQbiX3SBdNHV/mUoTVPpQhkNSQhmFjBCR3KfL+qyj0HBNbFhJkMkO2IZsuRT3VW7GH85bmxEqiZ3WbszghqHuMiicuc9FltcTL5lSyc87D9PfG2Po+5iKo5oDQV36BsnoV+x6qT0+bUibT/QacqWhuaJ5yRh78e/9iKrSWUZMFHPrS79U4WdeABAZ3ogT2IvQZUfevDcXHyaOnjvwmM+8Oxm4ZTV/ahlaqdhTGk20enj38wbGR+CICJwylc9JqhTiAoOpTf77S7z8ustkAkYg5JikieAQbb3TC/2Lnj/qJMMeOuTtY47QIgW4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sw9FHx3nDRbIR+45XlKgY/OerObrbi+pkq3uQko7JhY=;
 b=ebovdUT0ZxkCEAczfcACb6Hl1wbfsR+FYSq+YIW9XixkyGmnPbJKcL8Lo5I8yegodkRgoSJqRq3HW9vzDVORckm9ii1CF7X7Oq0oCjBn9HfSnmnSXzfK95ueOqu+MhATKVTboqrQk3jvvlhJ9bFyedtKIlGcBf3c+Y/hOp0WG63VGazwoxc4gQsk3Aq+Rrvi1BJ/7aOpKhIADBYTINWY0gbICU/aRMBnx17P8rtZpkEJvjK3QWhXOom091M2NbYfB+RIlhZibK1WH07ANPRx9dNEBnxZcZhHnYGevdbS+eISNHDUOLBVqbA1pYyvVUu/6YqA52E5Gujepru+IM/iig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1430.namprd12.prod.outlook.com (2603:10b6:903:3e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:47:36 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:47:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: reg: Extend MTMP register with new slot number field
Date:   Mon, 11 Apr 2022 17:46:50 +0300
Message-Id: <20220411144657.2655752-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0065.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::29) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5490137e-576d-476f-d287-08da1bca3805
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB143000A01B07E306C5D9509EB2EA9@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMXcO8zq7XlGGN4ctddwxEgpC8s5jzwDeZMTfHbDl/INZd9LzHjMQGnynFCIULlVfBuHGESto1pNScrHh+ll7lndjA6q75vTvJl5LZ+E0JjQcrUav1aFJxVSKCUxKUigwJaXD4YS4yntGpizI3T+RWbepKTaehVMIp+kKGxE6eWLQfstaL84/+SGqvrru/7lChlepbHvi3KJmD1XU+6YhkNhjHoloouUWtM7Sy/7937FiUdZW6gl4I2oEI7omsSMbCUtPWepmGqNrwD2lro2EZfrdqkPg/iAybtaQDQvNC5UYeVsM9y41Yure1g0yIXTzBOzKUP2eGuVdAxgvuXK24hR/fjLZ79dfur3fZqp6/gWbYXIEdW2ANzQKnL0hYIiEQ6Wbg79NGcGQRm5tvQO5hBUlZMLIIliTaN3xnkB81Ka2DmgwrAJbnlgc4ps4YNU1c0y9bglFwrN3CEiqUPSUbaxSDCGppfQHTJ1Gh0l/eI6LoinZTs3ZHuepGP8oVps2SW2QYJ12Z7gMrFCHj8IPc0XAd8Cltf2ZvggjiZj+BSS6fObd7KEGn8me2sJzzEM8JFfszl0uV/2DYtzi6BwIe44V9XhO1c1N/penn1dSoaCAR++I8oX8Bn2eC2Iyseuy3lszBklAJpL7gjXc20lVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(66946007)(66556008)(6486002)(66476007)(107886003)(6512007)(2616005)(1076003)(186003)(26005)(6506007)(6666004)(36756003)(38100700002)(2906002)(83380400001)(86362001)(4326008)(8676002)(6916009)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gA7oKrAWC108/bLm17I5y67hnrCHwRHtGpQXJWdHu4MPgmlw/txY5zwaX35e?=
 =?us-ascii?Q?cqLMUEFoMrK0unEE3jksVkM2jVBnRpBROckq7kDKjqxmKoRTP1h6N5xwREs1?=
 =?us-ascii?Q?nYMrJtO1dWgAbh10S1guV6D5GXnYali/0hO8ERDl4+O31dj+0z0lreCn2uJe?=
 =?us-ascii?Q?nOKeprWVglx/+FUBzq8bIDc2XbMK7JhC95JQavweqvayE5MipHR8yS6Kth+U?=
 =?us-ascii?Q?YjiuhNZ2H0DJCNrvCkWs4LZlBJ6ufRL3+zi8evDaw7iEv9oAKV0jjc7YozQF?=
 =?us-ascii?Q?uiaWfHMvE1rltny4Yxt51VmooSovTOFkgclMWl9KnH4ZRLOcNlzgeaFzWT79?=
 =?us-ascii?Q?7uuxK2GCyCBtd5NwlszupT1SN/BllLprM14R1n3ULbgRWkeURb9CvBYUk/13?=
 =?us-ascii?Q?gJA40kwKAmkPr9CW4m+M2L1y/l/DyWPIGKjtsHVi6eJjrrqupoeyyDa6LTUi?=
 =?us-ascii?Q?rPIhOGVB+CnRgNOIwYDMwauQQ0ECyqDUeBEgvotd1IWNGWmS6Vx8zA0tmJiU?=
 =?us-ascii?Q?SyoRXEoiIfrIFh2aE3RD0As3uRe1oZFgjziE30M14mL+FrGH5/FxRP+cXJ8f?=
 =?us-ascii?Q?FeOgoTs8sIOWkeyyyNYv/Gb5o52tzZxA7tFLb7uYxoafQPoV1qhErkxzJajc?=
 =?us-ascii?Q?UEzBvf2h1pXn0E68dWbRarluAL+E93v+h/1RCPMLSk+w1rgBOzs/TiBHyQnp?=
 =?us-ascii?Q?zoSr0wDpcxBKFRWAReuH92o6Vf4J3uNrUpuZvDC9uVs8TxbLs/aOzriM5DF0?=
 =?us-ascii?Q?qmGckWhsK6W4tnPVjDQb8mXJtDtEUjl6FAa+Q/O7ioqJnfAlUgDJ/TO8TS8C?=
 =?us-ascii?Q?M35S0CSB8uBPDneIC5Oodk2Jbzs+CQ3lq1uJX9C/mmD72WCCj6hUomFoH57y?=
 =?us-ascii?Q?16f3YrsxWblDFclilyYICNHF4qpoZkz5t0/L6uDV16YmWQbMmhcoMX+pHk8a?=
 =?us-ascii?Q?FQfa0cbodVRgI1SKzOB4qyImX2Wr/GniaGTbfS9f7uvQPGvg6FD5wdOnFFDc?=
 =?us-ascii?Q?AMd7FJx18j9ex18ghX7eHzF+xD14PkKX4vCIiPMZL3VqkHpqx9CYsvSjD7zl?=
 =?us-ascii?Q?7olINRa/s2Uc5rKQCC+gDV9u9TOujEjM5cZhLYkCSVcwj8oeF/VQvctqR0B4?=
 =?us-ascii?Q?lgWNsw51SQtsul8YLeKRJlo2+DhHr8f+nQNxEdaJrzKyg02fCHHOA5LRJlt2?=
 =?us-ascii?Q?mL7qFh+lqi+UCETgdRisDWLRw5WLaaTQhanHal17Dwm47ZZKRAicIw/NPHuG?=
 =?us-ascii?Q?MbJmajcjGuk156nO769dInNnuHXQqlZk7NsLHA442e73/FEhHO7qR8haspPY?=
 =?us-ascii?Q?mASOij6o280RBAUX4jannkEGCUb92Rn+jgfIZIfWDU4lEHUxBTsfYSvLNgXp?=
 =?us-ascii?Q?ve0VRA+VXLC0EI3BGMKRfkZBiIm+3nS4EsjaZ4KGINKkq/Dz6N41USpkiPDv?=
 =?us-ascii?Q?XrzE0/ZpTEGt4tM94SeIthnzG4RORIbdfoNs7HfnwZmx+6qD9YKqPCd4bbcw?=
 =?us-ascii?Q?TQi+xfZ7vl+qe/JTfrnQw5yvrSQJTLV+07ayOx6KGevi7xpJ9BLIeU7NCogd?=
 =?us-ascii?Q?U7awKBVZAhCM3TKR8xIZxGVVg/Ue0FNNDsJAbFPxGX3rb4d5sdeWv05mekor?=
 =?us-ascii?Q?yeSrdUd0cre97c7NQCBgYsopmCBTZRxYpdz01EPdmQW6jgySnoGgmcIuApkX?=
 =?us-ascii?Q?Zo56dRza8RaptyNuNIHR1tsuJjH2d/ZqGGbJ/MK2tXjE7XlwjMjBT95aghS5?=
 =?us-ascii?Q?uwKjNgOIuw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5490137e-576d-476f-d287-08da1bca3805
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:47:36.5313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orpaLdB7nksDVyzO3DIvfSHnVk9hz/YF/G2b36JtLNJYzJDs85F72gUTExvJwyUsLWUgVdXQwih2hbLUsP37ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
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

Extend MTMP (Management Temperature Register) with new field specifying
the slot index. The purpose of this field is to support access to MTMP
register for reading temperature sensors on modular systems.
For non-modular systems the 'sensor_index' uniquely identifies the cage
sensors, while 'slot_index' is always 0. For modular systems the
sensors are identified by:
- 'slot_index', specifying the slot index, where line card is located;
- 'sensor_index', specifying cage sensor within the line card.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   | 11 ++++++-----
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |  6 +++---
 drivers/net/ethernet/mellanox/mlxsw/reg.h          | 11 +++++++++--
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 29a74b8bd5b5..3103fef43955 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -177,7 +177,7 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	int page;
 	int err;
 
-	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
+	mlxsw_reg_mtmp_pack(mtmp_pl, 0, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
 			    false, false);
 	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 8b170ad92302..71ca3b561e62 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -66,7 +66,7 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon->module_sensor_max);
-	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
@@ -89,7 +89,7 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon->module_sensor_max);
-	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
@@ -232,8 +232,9 @@ static int mlxsw_hwmon_module_temp_get(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
-	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
-			    false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, 0,
+			    MLXSW_REG_MTMP_MODULE_INDEX_MIN + module, false,
+			    false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature\n");
@@ -721,7 +722,7 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	while (index < max_index) {
 		sensor_index = index % mlxsw_hwmon->module_sensor_max +
 			       MLXSW_REG_MTMP_GBOX_INDEX_MIN;
-		mlxsw_reg_mtmp_pack(mtmp_pl, sensor_index, true, true);
+		mlxsw_reg_mtmp_pack(mtmp_pl, 0, sensor_index, true, true);
 		err = mlxsw_reg_write(mlxsw_hwmon->core,
 				      MLXSW_REG(mtmp), mtmp_pl);
 		if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 05f54bd982c0..65ab04e32972 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -271,7 +271,7 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
 	int temp;
 	int err;
 
-	mlxsw_reg_mtmp_pack(mtmp_pl, 0, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, 0, 0, false, false);
 
 	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
@@ -431,7 +431,7 @@ mlxsw_thermal_module_temp_and_thresholds_get(struct mlxsw_core *core,
 	int err;
 
 	/* Read module temperature and thresholds. */
-	mlxsw_reg_mtmp_pack(mtmp_pl, sensor_index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, 0, sensor_index, false, false);
 	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		/* Set temperature and thresholds to zero to avoid passing
@@ -576,7 +576,7 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 	int err;
 
 	index = MLXSW_REG_MTMP_GBOX_INDEX_MIN + tz->module;
-	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
 
 	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 67b1a2f8397f..5de77d6e08ba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9721,6 +9721,12 @@ MLXSW_ITEM32(reg, mtcap, sensor_count, 0x00, 0, 7);
 
 MLXSW_REG_DEFINE(mtmp, MLXSW_REG_MTMP_ID, MLXSW_REG_MTMP_LEN);
 
+/* reg_mtmp_slot_index
+ * Slot index (0: Main board).
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mtmp, slot_index, 0x00, 16, 4);
+
 #define MLXSW_REG_MTMP_MODULE_INDEX_MIN 64
 #define MLXSW_REG_MTMP_GBOX_INDEX_MIN 256
 /* reg_mtmp_sensor_index
@@ -9810,11 +9816,12 @@ MLXSW_ITEM32(reg, mtmp, temperature_threshold_lo, 0x10, 0, 16);
  */
 MLXSW_ITEM_BUF(reg, mtmp, sensor_name, 0x18, MLXSW_REG_MTMP_SENSOR_NAME_SIZE);
 
-static inline void mlxsw_reg_mtmp_pack(char *payload, u16 sensor_index,
-				       bool max_temp_enable,
+static inline void mlxsw_reg_mtmp_pack(char *payload, u8 slot_index,
+				       u16 sensor_index, bool max_temp_enable,
 				       bool max_temp_reset)
 {
 	MLXSW_REG_ZERO(mtmp, payload);
+	mlxsw_reg_mtmp_slot_index_set(payload, slot_index);
 	mlxsw_reg_mtmp_sensor_index_set(payload, sensor_index);
 	mlxsw_reg_mtmp_mte_set(payload, max_temp_enable);
 	mlxsw_reg_mtmp_mtr_set(payload, max_temp_reset);
-- 
2.33.1

