Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235E14FF9DE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiDMPVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbiDMPVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:21:17 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2077.outbound.protection.outlook.com [40.107.96.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA8A2E6A2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcM4ygpRyxGUdLe7KUk6MNGI2hbnhLKxpSgIp1BHj7aq8+PlFmrNF5P8VVK9kJbboPlaAHMdaEzhWO624FQwl5oYiazl59kWofd4opPusL27VKc9hxpykmmkPj09NeompacBnhojO/liSfM35dcOG39jtqtsZYLiWEObHoQcQEn8wd7mb+YMD3tZoYs/LLBJFQ2AaEDojzRa8I+1n1rvHk7CzUD7NvsSLxwt0qsjZMOtxgT31FBUP+vqDCzfLhCFjcF7DMCL9LMjKSiH+dwYkOHfSYMUIwJeuMyd3SO7KHGpZR2OtiHSAPZh6kIX5cok4/Wy3xPz3h/l/U5RrWFinA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUFQwuJeqdh7HGNSMtFUU5npvvrMekhfV2jbn2ZtVo4=;
 b=j8uvsHWKOK/fl7F56M3Mj6TkjYd9oa2zTV1FCD66uDDMPlEgGZmHMwQMymDNOLwzD0xZG03lZ3Iee/cgXAr3NOjo2QOcl3ujNSGJFzKnuVI6wmwZxVXo9RLUDZou0LfY2QMHlGFNms2Lvyu1tgVHFLOWDBzp9lG21EUs9Y8jN6fHVsbuSlo/q83sSq52F9dFCnuGO4kVJ4tLZH4TDQK20pB/5x8AVS8yRvn1H6F+1v7FuOzv0aWPbVWDOU3h5txIvdrLBUVgkbkj7hsZhUH9eocQiCGZkJlHXrH/RLG72ge0pnygZ2A04Zhbh9NySfeWg/OYjOh5Zo1KCvdS1Ckfbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUFQwuJeqdh7HGNSMtFUU5npvvrMekhfV2jbn2ZtVo4=;
 b=AUkcRxSDLoYmyruU+tSc5vNTw3in6wg9lv2Gj/3heaqjoBmVsubRa8R4aVUTLsUalVgzZjl4WDgaC0AyTE6LG62iad4d9Pcai0VvCEUkGoqjwV6NhwjA4zo00Ol8STrmaRqcuEWMdIHqtLEJ0lB3acda18E/VVK0Ax5n2VEwk3DoNrmC8Zk3gXLglFMYxGBKiJPa9CzGDlnkgg/6ypR2nVa7yOAClIFUCHroTsaGri+42brrdZHnpAv0m6mxB6icvq1DbXGP/734cLJ/2T9U2PBbmoG3FB4/DprP+ZjobrlxSM5MrgO+CwpPLnF2Dlax+WYleN1wpFXe9bBRhgSYiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN6PR1201MB2530.namprd12.prod.outlook.com (2603:10b6:404:b0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Wed, 13 Apr
 2022 15:18:49 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/9] mlxsw: core_thermal: Extend internal structures to support multi thermal areas
Date:   Wed, 13 Apr 2022 18:17:30 +0300
Message-Id: <20220413151733.2738867-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0005.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::17) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8038d879-e5a6-479c-a072-08da1d60e8ef
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2530:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2530D0DCD8180B6989B3BF2CB2EC9@BN6PR1201MB2530.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +rHHbarayl0vjqnw+HrMB9XpBE/+V8hpPCtvKymxT1ljR6bLabJAN6C8V1BKkzgIZrjhYPS6Wo/gf17sMkceD7sQ/hiVwCBvBxTCLOMDg2mS1dJcBXJc/Q28uh2O3/g2JA4SwTGFQRgJSx6AB3k9cd3CefiG4icPfs67cWCIadAzrwX1ziy3vF2nmnVIBR9xmMm9mV3YfdXLENz5uP3NJsaneulUYoRrMN5It+IK2/rbfSWEtSaWMhsM/WTpSD3VlMzL07au9EhDQ/6ZNDuuUoql1Wle8IY3gjGxgASLB8rXPiMXVCegX2UIeLa1kFZI70DjRW6jPZg043HtQcBA2uk0DfUKBWS7ZffWA9zk1Br4YHVVoyvdSBJAuQH4DE4Pun2wsXfuMy36hgKM2YbDFFpd+HqbZ7osUahfWxWlnChlFLLHVqjn2yWSoXvGl0+Ve+/ckld7mUHM67EwQg5Z5XdijUBSEJYBpGCApCuG7q2ZF9j4C0F3eHSBzNc6DLQ6sqb/gquTjI/fe6TjiwpcTgZl+m6/K2ALu9sWP5F0JS+00Op89sHJ1RUNLAVPOcfmJ9PX4ee1cvymIV9M1wnJ5EvG9ILMULWrqPto2XsQGXxCUi2lnJ05BfOpW+Ux4rLo1Y/6hJ6yW34GiOv1tTLHlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(316002)(6666004)(36756003)(2616005)(6916009)(1076003)(6506007)(86362001)(2906002)(186003)(66556008)(6486002)(6512007)(508600001)(4326008)(38100700002)(66476007)(26005)(83380400001)(66946007)(30864003)(8936002)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nj6tpwMx9I8WXCn5VEnVrmnDWVyvXOxEkJEALHOdtztpTTuN9OzGoOY4qoR3?=
 =?us-ascii?Q?NXxWtJMgKCfVBz+tWg/UqDB9+fp6M1n5S+D5eAikqf0WM/u9XCDtNtOnXvVz?=
 =?us-ascii?Q?gwpYwlZaia5Cfn4W771UMUjwoRSxeuxpaAPolErPd9K6fPqXhD+bhdPqV550?=
 =?us-ascii?Q?5LYlq3cHCT81wzV8LpfLwbcycLTVY4wp6f8quWAnTa4ik9G68UtVoDxwipYK?=
 =?us-ascii?Q?ZK17wVcYY48gLop4qPwXPGt2dnUdRIYFNEjXdGw4pW71uQzRGJb/vlFodKeG?=
 =?us-ascii?Q?d1yHqA08emjjR3dJBhTY+bxhjavtg7WWVhPHoU2GG6ajPXuUkAnbEtfd/cQN?=
 =?us-ascii?Q?rX0KGG6OBQaQIJUezo22T1qLoCiwkSQQguAbuLjm4hk2/FWTLLUCLDsATxNm?=
 =?us-ascii?Q?uA0/DkB6QrfYW3bePMJWsHR+bBxLT2Cjgxt/2RcO2r7WVgWGYoX/z6PjkrWG?=
 =?us-ascii?Q?nqqO4jVOCy+mP2BPt8s7EAe3szaUuFmQ3nBJsjkV52i3xz2S04fBrK/Pl+G4?=
 =?us-ascii?Q?1u3GoGrUcy/hruuIRCbjiZQ/EwyPZE/4scj31JSiOks7NWp6vUrGcuzfWqZI?=
 =?us-ascii?Q?quFvmjkTmwS4z22F5853pYXIZfhI4q/g3LDr35R68Uc/NC/kcvLnNTMAvxeH?=
 =?us-ascii?Q?wHiwEzf9mLuqJFR+8OQ5LNNG7G7KmyjdO0lmwA1ysWXd9RTCPJjCt+hEkpPf?=
 =?us-ascii?Q?yScT1otwN5ZJo2/pp6fug48zex5ijJT43tBKHMb1Sh1xQeDvBGhNR1sHicAA?=
 =?us-ascii?Q?QlKWD2qckbkMcCf65eGJFhNCV2zJBxGnvm3ipIV8MjvkQuMtoFGVLxrS4DL+?=
 =?us-ascii?Q?B+o076K/vWugx0MV/0OYOLP6b4laRgvlRZLkxNetmCWmOwdf+A9NBelYGz9/?=
 =?us-ascii?Q?QcNzF8z5+eXtcjDOKl4nBVAI+h6aMdZw8ylmM4RDx4fdiKPwBveH1cvrgTw1?=
 =?us-ascii?Q?rfFrUsbniCqbL5M43qAC6V7a1RC5W6ltPTXG9fdUEytHX4gAgZ4gegt0fAhv?=
 =?us-ascii?Q?zvw2aO1tydwG33aalcnraC1FTd1eMptLpKn0wv/PrKTgOtBD7OaBM0074G4f?=
 =?us-ascii?Q?kNyuz8b9paVX6uhNw9cINFWH6rCuzHnBG10/bboYgkyoAcSyXqEhtN9s3Uga?=
 =?us-ascii?Q?HiV5NohwtXqy0hk0r6I0Vwk138rjTMRJHonFdeKdtZ1L68q33jZjm6T4byYc?=
 =?us-ascii?Q?wsPTEt2lTvzJZ5xBLM4XoCuS1/WCuVJFsg5zT9K/jYD8krbx1nymc42e43Md?=
 =?us-ascii?Q?SrnpBcGA7yf3XqJHAOxJWLigSvL/mArDtPtMWqiHzlPDiyLDzWJS/oCDcesN?=
 =?us-ascii?Q?1HoARCgq/4tUNlYwgNfTMO0bLxPNkmceA4qfCb8K0flwOANNiDjvZlvNY8Ew?=
 =?us-ascii?Q?4kKEY/JeQyIrBWretmyXenVP022QOe+imrOPWRY+K+a38VUQXfAKO30Bwoxm?=
 =?us-ascii?Q?WiQ875NoKkp8ugphIrFhbJnGbHCCdSXSxoULEWDmDrG+WOh61siFKvHUdKWd?=
 =?us-ascii?Q?FGAlfbmx8Ue1WZEOW31BjROvLp5F7Ob8WmvWbFC/YMGEfizAHzJzLLChj0DB?=
 =?us-ascii?Q?TaTYaGt9jaA6Xywfm/p3ybQ9b81Iu4DM0dC3Ms7XRXCF1IyIOrMSDW7iWUTR?=
 =?us-ascii?Q?FHexTkgq169sPlmGdc+xkfaZEeDXHtS/ASdKqX0OqGqgjge99sRoM6tYl3aJ?=
 =?us-ascii?Q?uY5kBYT8fnadcCI5gzRYFCSvYSTCMHLB73JWK7wHAc9s4fVKOP2P4vGUknQ8?=
 =?us-ascii?Q?wmvOHY/IJg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8038d879-e5a6-479c-a072-08da1d60e8ef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:48.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKDRgFIxT9GpYGSvsFN8smx9EG/i9PNOKF3zV77a14XXobrrwExGa4oi03NkQelCFhQy5YZUVZjuRaFwNcyVrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2530
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

Introduce intermediate level for thermal zones areas.
Currently all thermal zones are associated with thermal objects located
within the main board. Such objects are created during driver
initialization and removed during driver de-initialization.

For line cards in modular system the thermal zones are to be associated
with the specific line card. They should be created whenever new line
card is available (inserted, validated, powered and enabled) and
removed, when line card is getting unavailable.
The thermal objects found on the line card #n are accessed by setting
slot index to #n, while for access to objects found on the main board
slot index should be set to default value zero.

Each thermal area contains the set of thermal zones associated with
particular slot index.
Thus introduction of thermal zone areas allows to use the same APIs for
the main board and line cards, by adding slot index argument.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 148 +++++++++++-------
 1 file changed, 91 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index d64af27e5bac..6d186cc74df3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -82,6 +82,15 @@ struct mlxsw_thermal_module {
 	struct thermal_zone_device *tzdev;
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
 	int module; /* Module or gearbox number */
+	u8 slot_index;
+};
+
+struct mlxsw_thermal_area {
+	struct mlxsw_thermal_module *tz_module_arr;
+	u8 tz_module_num;
+	struct mlxsw_thermal_module *tz_gearbox_arr;
+	u8 tz_gearbox_num;
+	u8 slot_index;
 };
 
 struct mlxsw_thermal {
@@ -92,12 +101,9 @@ struct mlxsw_thermal {
 	struct thermal_cooling_device *cdevs[MLXSW_MFCR_PWMS_MAX];
 	u8 cooling_levels[MLXSW_THERMAL_MAX_STATE + 1];
 	struct mlxsw_thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
-	struct mlxsw_thermal_module *tz_module_arr;
-	u8 tz_module_num;
-	struct mlxsw_thermal_module *tz_gearbox_arr;
-	u8 tz_gearbox_num;
 	unsigned int tz_highest_score;
 	struct thermal_zone_device *tz_highest_dev;
+	struct mlxsw_thermal_area line_cards[];
 };
 
 static inline u8 mlxsw_state_to_duty(int state)
@@ -150,13 +156,15 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	 * EEPROM if we got valid thresholds from MTMP.
 	 */
 	if (!emerg_temp || !crit_temp) {
-		err = mlxsw_env_module_temp_thresholds_get(core, 0, tz->module,
+		err = mlxsw_env_module_temp_thresholds_get(core, tz->slot_index,
+							   tz->module,
 							   SFP_TEMP_HIGH_WARN,
 							   &crit_temp);
 		if (err)
 			return err;
 
-		err = mlxsw_env_module_temp_thresholds_get(core, 0, tz->module,
+		err = mlxsw_env_module_temp_thresholds_get(core, tz->slot_index,
+							   tz->module,
 							   SFP_TEMP_HIGH_ALARM,
 							   &emerg_temp);
 		if (err)
@@ -423,15 +431,16 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
 
 static void
 mlxsw_thermal_module_temp_and_thresholds_get(struct mlxsw_core *core,
-					     u16 sensor_index, int *p_temp,
-					     int *p_crit_temp,
+					     u8 slot_index, u16 sensor_index,
+					     int *p_temp, int *p_crit_temp,
 					     int *p_emerg_temp)
 {
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int err;
 
 	/* Read module temperature and thresholds. */
-	mlxsw_reg_mtmp_pack(mtmp_pl, 0, sensor_index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, slot_index, sensor_index,
+			    false, false);
 	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		/* Set temperature and thresholds to zero to avoid passing
@@ -462,6 +471,7 @@ static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 
 	/* Read module temperature and thresholds. */
 	mlxsw_thermal_module_temp_and_thresholds_get(thermal->core,
+						     tz->slot_index,
 						     sensor_index, &temp,
 						     &crit_temp, &emerg_temp);
 	*p_temp = temp;
@@ -576,7 +586,7 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
 	int err;
 
 	index = MLXSW_REG_MTMP_GBOX_INDEX_MIN + tz->module;
-	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, tz->slot_index, index, false, false);
 
 	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
@@ -704,25 +714,28 @@ static void mlxsw_thermal_module_tz_fini(struct thermal_zone_device *tzdev)
 
 static int
 mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
-			  struct mlxsw_thermal *thermal, u8 module)
+			  struct mlxsw_thermal *thermal,
+			  struct mlxsw_thermal_area *area, u8 module)
 {
 	struct mlxsw_thermal_module *module_tz;
 	int dummy_temp, crit_temp, emerg_temp;
 	u16 sensor_index;
 
 	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + module;
-	module_tz = &thermal->tz_module_arr[module];
+	module_tz = &area->tz_module_arr[module];
 	/* Skip if parent is already set (case of port split). */
 	if (module_tz->parent)
 		return 0;
 	module_tz->module = module;
+	module_tz->slot_index = area->slot_index;
 	module_tz->parent = thermal;
 	memcpy(module_tz->trips, default_thermal_trips,
 	       sizeof(thermal->trips));
 	/* Initialize all trip point. */
 	mlxsw_thermal_module_trips_reset(module_tz);
 	/* Read module temperature and thresholds. */
-	mlxsw_thermal_module_temp_and_thresholds_get(core, sensor_index, &dummy_temp,
+	mlxsw_thermal_module_temp_and_thresholds_get(core, area->slot_index,
+						     sensor_index, &dummy_temp,
 						     &crit_temp, &emerg_temp);
 	/* Update trip point according to the module data. */
 	return mlxsw_thermal_module_trips_update(dev, core, module_tz,
@@ -740,34 +753,39 @@ static void mlxsw_thermal_module_fini(struct mlxsw_thermal_module *module_tz)
 
 static int
 mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
-			   struct mlxsw_thermal *thermal)
+			   struct mlxsw_thermal *thermal,
+			   struct mlxsw_thermal_area *area)
 {
 	struct mlxsw_thermal_module *module_tz;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	int i, err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	mlxsw_reg_mgpir_pack(mgpir_pl, area->slot_index);
 	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
 
 	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL,
-			       &thermal->tz_module_num, NULL);
+			       &area->tz_module_num, NULL);
 
-	thermal->tz_module_arr = kcalloc(thermal->tz_module_num,
-					 sizeof(*thermal->tz_module_arr),
-					 GFP_KERNEL);
-	if (!thermal->tz_module_arr)
+	/* For modular system module counter could be zero. */
+	if (!area->tz_module_num)
+		return 0;
+
+	area->tz_module_arr = kcalloc(area->tz_module_num,
+				      sizeof(*area->tz_module_arr),
+				      GFP_KERNEL);
+	if (!area->tz_module_arr)
 		return -ENOMEM;
 
-	for (i = 0; i < thermal->tz_module_num; i++) {
-		err = mlxsw_thermal_module_init(dev, core, thermal, i);
+	for (i = 0; i < area->tz_module_num; i++) {
+		err = mlxsw_thermal_module_init(dev, core, thermal, area, i);
 		if (err)
 			goto err_thermal_module_init;
 	}
 
-	for (i = 0; i < thermal->tz_module_num; i++) {
-		module_tz = &thermal->tz_module_arr[i];
+	for (i = 0; i < area->tz_module_num; i++) {
+		module_tz = &area->tz_module_arr[i];
 		if (!module_tz->parent)
 			continue;
 		err = mlxsw_thermal_module_tz_init(module_tz);
@@ -779,20 +797,21 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 
 err_thermal_module_tz_init:
 err_thermal_module_init:
-	for (i = thermal->tz_module_num - 1; i >= 0; i--)
-		mlxsw_thermal_module_fini(&thermal->tz_module_arr[i]);
-	kfree(thermal->tz_module_arr);
+	for (i = area->tz_module_num - 1; i >= 0; i--)
+		mlxsw_thermal_module_fini(&area->tz_module_arr[i]);
+	kfree(area->tz_module_arr);
 	return err;
 }
 
 static void
-mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal)
+mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal,
+			   struct mlxsw_thermal_area *area)
 {
 	int i;
 
-	for (i = thermal->tz_module_num - 1; i >= 0; i--)
-		mlxsw_thermal_module_fini(&thermal->tz_module_arr[i]);
-	kfree(thermal->tz_module_arr);
+	for (i = area->tz_module_num - 1; i >= 0; i--)
+		mlxsw_thermal_module_fini(&area->tz_module_arr[i]);
+	kfree(area->tz_module_arr);
 }
 
 static int
@@ -828,7 +847,8 @@ mlxsw_thermal_gearbox_tz_fini(struct mlxsw_thermal_module *gearbox_tz)
 
 static int
 mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
-			     struct mlxsw_thermal *thermal)
+			     struct mlxsw_thermal *thermal,
+			     struct mlxsw_thermal_area *area)
 {
 	enum mlxsw_reg_mgpir_device_type device_type;
 	struct mlxsw_thermal_module *gearbox_tz;
@@ -837,7 +857,7 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 	int i;
 	int err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	mlxsw_reg_mgpir_pack(mgpir_pl, area->slot_index);
 	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
@@ -848,19 +868,20 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 	    !gbox_num)
 		return 0;
 
-	thermal->tz_gearbox_num = gbox_num;
-	thermal->tz_gearbox_arr = kcalloc(thermal->tz_gearbox_num,
-					  sizeof(*thermal->tz_gearbox_arr),
-					  GFP_KERNEL);
-	if (!thermal->tz_gearbox_arr)
+	area->tz_gearbox_num = gbox_num;
+	area->tz_gearbox_arr = kcalloc(area->tz_gearbox_num,
+				       sizeof(*area->tz_gearbox_arr),
+				       GFP_KERNEL);
+	if (!area->tz_gearbox_arr)
 		return -ENOMEM;
 
-	for (i = 0; i < thermal->tz_gearbox_num; i++) {
-		gearbox_tz = &thermal->tz_gearbox_arr[i];
+	for (i = 0; i < area->tz_gearbox_num; i++) {
+		gearbox_tz = &area->tz_gearbox_arr[i];
 		memcpy(gearbox_tz->trips, default_thermal_trips,
 		       sizeof(thermal->trips));
 		gearbox_tz->module = i;
 		gearbox_tz->parent = thermal;
+		gearbox_tz->slot_index = area->slot_index;
 		err = mlxsw_thermal_gearbox_tz_init(gearbox_tz);
 		if (err)
 			goto err_thermal_gearbox_tz_init;
@@ -870,19 +891,20 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 
 err_thermal_gearbox_tz_init:
 	for (i--; i >= 0; i--)
-		mlxsw_thermal_gearbox_tz_fini(&thermal->tz_gearbox_arr[i]);
-	kfree(thermal->tz_gearbox_arr);
+		mlxsw_thermal_gearbox_tz_fini(&area->tz_gearbox_arr[i]);
+	kfree(area->tz_gearbox_arr);
 	return err;
 }
 
 static void
-mlxsw_thermal_gearboxes_fini(struct mlxsw_thermal *thermal)
+mlxsw_thermal_gearboxes_fini(struct mlxsw_thermal *thermal,
+			     struct mlxsw_thermal_area *area)
 {
 	int i;
 
-	for (i = thermal->tz_gearbox_num - 1; i >= 0; i--)
-		mlxsw_thermal_gearbox_tz_fini(&thermal->tz_gearbox_arr[i]);
-	kfree(thermal->tz_gearbox_arr);
+	for (i = area->tz_gearbox_num - 1; i >= 0; i--)
+		mlxsw_thermal_gearbox_tz_fini(&area->tz_gearbox_arr[i]);
+	kfree(area->tz_gearbox_arr);
 }
 
 int mlxsw_thermal_init(struct mlxsw_core *core,
@@ -892,19 +914,29 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	char mfcr_pl[MLXSW_REG_MFCR_LEN] = { 0 };
 	enum mlxsw_reg_mfcr_pwm_frequency freq;
 	struct device *dev = bus_info->dev;
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	struct mlxsw_thermal *thermal;
+	u8 pwm_active, num_of_slots;
 	u16 tacho_active;
-	u8 pwm_active;
 	int err, i;
 
-	thermal = devm_kzalloc(dev, sizeof(*thermal),
-			       GFP_KERNEL);
+	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, NULL,
+			       &num_of_slots);
+
+	thermal = kzalloc(struct_size(thermal, line_cards, num_of_slots + 1),
+			  GFP_KERNEL);
 	if (!thermal)
 		return -ENOMEM;
 
 	thermal->core = core;
 	thermal->bus_info = bus_info;
 	memcpy(thermal->trips, default_thermal_trips, sizeof(thermal->trips));
+	thermal->line_cards[0].slot_index = 0;
 
 	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mfcr), mfcr_pl);
 	if (err) {
@@ -970,11 +1002,13 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 		goto err_thermal_zone_device_register;
 	}
 
-	err = mlxsw_thermal_modules_init(dev, core, thermal);
+	err = mlxsw_thermal_modules_init(dev, core, thermal,
+					 &thermal->line_cards[0]);
 	if (err)
 		goto err_thermal_modules_init;
 
-	err = mlxsw_thermal_gearboxes_init(dev, core, thermal);
+	err = mlxsw_thermal_gearboxes_init(dev, core, thermal,
+					   &thermal->line_cards[0]);
 	if (err)
 		goto err_thermal_gearboxes_init;
 
@@ -986,9 +1020,9 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	return 0;
 
 err_thermal_zone_device_enable:
-	mlxsw_thermal_gearboxes_fini(thermal);
+	mlxsw_thermal_gearboxes_fini(thermal, &thermal->line_cards[0]);
 err_thermal_gearboxes_init:
-	mlxsw_thermal_modules_fini(thermal);
+	mlxsw_thermal_modules_fini(thermal, &thermal->line_cards[0]);
 err_thermal_modules_init:
 	if (thermal->tzdev) {
 		thermal_zone_device_unregister(thermal->tzdev);
@@ -1001,7 +1035,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 			thermal_cooling_device_unregister(thermal->cdevs[i]);
 err_reg_write:
 err_reg_query:
-	devm_kfree(dev, thermal);
+	kfree(thermal);
 	return err;
 }
 
@@ -1009,8 +1043,8 @@ void mlxsw_thermal_fini(struct mlxsw_thermal *thermal)
 {
 	int i;
 
-	mlxsw_thermal_gearboxes_fini(thermal);
-	mlxsw_thermal_modules_fini(thermal);
+	mlxsw_thermal_gearboxes_fini(thermal, &thermal->line_cards[0]);
+	mlxsw_thermal_modules_fini(thermal, &thermal->line_cards[0]);
 	if (thermal->tzdev) {
 		thermal_zone_device_unregister(thermal->tzdev);
 		thermal->tzdev = NULL;
@@ -1023,5 +1057,5 @@ void mlxsw_thermal_fini(struct mlxsw_thermal *thermal)
 		}
 	}
 
-	devm_kfree(thermal->bus_info->dev, thermal);
+	kfree(thermal);
 }
-- 
2.33.1

