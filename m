Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B114BFFF8
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiBVRSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiBVRSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:33 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B51165C2B
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOhaGAjGEb5gRnI2tKB5BQkYolBweqchZq6t34g0yLGvm0+1jbdoUcN6qMcfvbhf0lRS78HOK33kTkaP5XG7IaqtDUW4WuKNp7kzpOotFWlJ4Uq9V03nDVjS8N9PLteRzqbnb311pv46PAWupaxFk+qO+K3orpWQoIsJdrqr4wUZ2QCDEXj4wpsfZvTisTEqsKcQuJRXdr++cOlziEVazIuTu6VO0443/hPjWn8Z+nTinTut7NMuslJDapVR+2Mn5e/6OY0+HlSfKwt7v4/YAOyPGhWVB/WZQ0n4btWIz2km1K44f0v8bwsq6rHuY9qXen8Vas8c9c6YugC9R5RkKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuYSQaalNEb9S6dHVnTculp/Dn2udpHe5pgy+EWv5ag=;
 b=UhcCUJjmwSbrZOxR8us92QMGQNfNRcY2tAeKRtFXZ4FprRUuyB8kSlLv7otQgNl2IRtFoKYfnxgs280IYgWJsnA+HyUgkBpHUNBYp1/EIEta6G56HxvIx/q7tjnnPyShS9GZGTiKHNa4OyH++Ea0l9Y2mDDI1Vzsk0jqxG4KdjFDHki37bSQ4LinbncmHC0paYGnD7pMnk1qIXla+tAzuPCt1voDMgaTHlUw1dUIO2iteiQTLBkGRSfUUydPdR7Hxpv276214SrPKpeTdKctrnZ3h+Q+TdwYpgsnFIRP1liXUJYCPhfzrpV5c33uUMlUV45yMvuU4drwaLxEuOAqRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VuYSQaalNEb9S6dHVnTculp/Dn2udpHe5pgy+EWv5ag=;
 b=HdE3gz5p4OrYpExmmTPMsW1rOqzC0x5uw9bdJKMJIrlYfzahLVpK6Ajdpt112EdCWnG25HsAEvkOfDTru0tg1mbH/cc1w6WkSK3DGR4Wu581zhaY77OvVtDoyeTd6OF+q2ZPCWzLFpRhCCZMm6GA7psqoYzaDI4JOt2poS4HEmNazcE4rQ2erEoejckb9lhOKtZTrxx3b4GkokQFtoCtQvck+giMLZeZ3MrfpGQkgDtf8jjRRuN1JgZH3G+wxnKGKNIKrXubgf8+3ijYQvJyUIrv/j7iPfgBs7rQzoorW6Qsak9X6VgH1EzFYerG8qdg2Ku9yQAKo5V6UOAx3rpy2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:05 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/12] mlxsw: core_thermal: Rename labels according to naming convention
Date:   Tue, 22 Feb 2022 19:16:56 +0200
Message-Id: <20220222171703.499645-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0085.eurprd04.prod.outlook.com
 (2603:10a6:803:64::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 002a59ee-c44f-4c36-0d6c-08d9f62749ee
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB42621E201B87CAF46E6E9F83B23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fkt0o6Q/sDvJ9U+QkJrZkuYGFEE30IwTJyYPp4ij9/W6Vj0biUrKudyKcMdp1eXN28u9unvywtTJHKPl94eEfkE8JfLiegt/c1Aj72qZQe/+FEeuHd6StlRwnSd6S03OiB7SmKbHGGXmzsw9Qzt6XC9eRZDNjMKkhwVt+TvDJ7Flls65Rmn+cG81AHACvFwjOMsYonBeZ9biWUf/I56AFI2vZe0ufJlUctNoVOrUeZnfU0Hygr3fA5Bw0xsTGJa6ESxiW/sXeS0pzTGLKl7Biszy4tj1kdhvQfhjepMw8RpMkyDs4voVnLf6ooO+fWs5wMQnJJbtiJHrvyk0sra905iYa4qZUB4m00e/+Gr8vYGyGnX7BguK5TGlswt/kCANXyoIsUWOJVEKvYo14HSqcZ0sNVgSJ1qVokESIaZiYyvnh4PjXACnLBXaAKNB9XQVyRTnMQ3hgHpjxtNaQExlkqU9UBKw9JGIXbFosMPYxMmDxa9UEUDqO7lOwQcnDnFe/QI5Jf7W9dbMYYrcryu+ydTuxKhi/YX5LYBKj302Z/rkkSgOH4WEumOc086Hyn5APe1N88xmjEPFXiw4mH/uTtHDKGLXwnARgbZ0O6rpaTZXhq0s+Dr9JQs5UWS4zh71h/BrEnhn05I6+qrCfpHjsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5LEYPabCsG0hTr98RVaAojpytlm4i6QTNAMRubiASUT+kba8FWRKpGOCIRl?=
 =?us-ascii?Q?xgyKMMqY1efpdymGuj5q9TpR3A+MPmq+sTbZ5i1wrSNcmfRQvAGMfRwRRkh9?=
 =?us-ascii?Q?ngiVzE5BKNhXa0b14JQvJc4UIFuM4O601B1Ehj9vblHcYR6lbl7D6kItsJUF?=
 =?us-ascii?Q?G0wq34a9qDjgm1Udcbg46UGx/Cgt2p3x9kzqkmCKhnPheKe8cMPvtLihHXAt?=
 =?us-ascii?Q?Mild2dXwRR8QIS38MJK40qqcHV0kHl4jCqDZR8bG9wYPQWkl+SR0KQeB3zhs?=
 =?us-ascii?Q?EtBZnfFAuqEinU515aH1B/Z7bWZ0y1u39LDVVsNLeTFP4GUmFooLkhDWxjPV?=
 =?us-ascii?Q?xuJtor3zZlLfDlW4Tk5DfssE/Y0FepFeaYn5fX7TDAtUMhDXAXFKAmyc8fg6?=
 =?us-ascii?Q?UnLIQxdPoUFS8rTd3L3W6Ny9sYVaElEA/mQsJDSHTDxWb719ha6VvqnCzbog?=
 =?us-ascii?Q?rkzIjRu3YymszbUEgI4a0pdsUgQxkxLvJZjH1MkGYz7rHVhM7+VshRNMTf5v?=
 =?us-ascii?Q?f4JST7SWTyRw34U7+JU1a5wx1/Y4+a5lchjGgRQGM6s0t5Ud8+o3HGtLCppk?=
 =?us-ascii?Q?4sRuBK7CXF/c2++pWbt1rcf+294tRRecsrHfoBKBNyPLA5AvmaTT8vYRrkOz?=
 =?us-ascii?Q?BkUGI4r5qkq/mFRgg6PozSP9m7YeQG0zIKKZXmQ+DB0YygLRdgfV75bwROlo?=
 =?us-ascii?Q?fdDo52ld+RND8wTxVEDFKpLsEeexJsmW36zJnBwcC9dfWMeIheYSuwfnqch6?=
 =?us-ascii?Q?blJY5tvMGhkF2NljJqkc4eNsi4OuukM27RXZlvnzM0rV18yt7LP9xwTvpv76?=
 =?us-ascii?Q?Hi2MDbfeZSrHSISJS6YN1MTObPEfzksWyORAOBr8mcTbXywMsMgOQ7HZ+KiL?=
 =?us-ascii?Q?jaO9owfAEuULlH8bP36mv56Xi6YSRJpqSqPrzAZ0a2ajZpACDE+n2q0dq0K/?=
 =?us-ascii?Q?Ag0bOX//vT2eEBdE/2HOtbalGqhCamX/esO2vcaiv4A0SBt9SOK+Bk7+z5Ks?=
 =?us-ascii?Q?xrSNxgITJ+tNir5NGOgeeJREVVY58sMsAQQapBGPjH+XdlGiMaUz8P11NSIX?=
 =?us-ascii?Q?cbREcBcPmapb5QulATWo8HFr3shS8WSnD+TrQfbubSw96I0WkuVYGW4hyYbm?=
 =?us-ascii?Q?s6cx+2Lv0DYLZJTv+W4QZ4eGA6FpVirXFsXxZXeBTybQYv/9lLpJ1OI7zs8M?=
 =?us-ascii?Q?SSdkNCOJkXoY6sT9d3TBbU83A2A2r3J2f8m5ywytM8cytSzYfjaRxir2N2Fq?=
 =?us-ascii?Q?/ztULKPb7EqkdeUdf2i/6uxaBAgrlg3pn8Mri8YYLxd4Eu2m76r9ZdPd2KJg?=
 =?us-ascii?Q?OdlrVwMHzSPxwIT1PwqU9vV6B9VIl7VDeKs6kVhEKzFkYzo1+T+ZGeyxF/9D?=
 =?us-ascii?Q?AkGQuIUB1hWlpmgMdKGDdf0xn3M+s4qKQzlWLaZOeUHHbpTvmg8X4ofwzELe?=
 =?us-ascii?Q?5DgtgdegKXqu48vlCEJsY2IrZhmO5IuWfVX7d7zXnrKBBeQIXVzN1EPMsahU?=
 =?us-ascii?Q?xMwZF8Je9kcMVzIgnAcphtEOzwUcQOsNZw/NThPbTzVyL8wiaIlEGryY60z0?=
 =?us-ascii?Q?qEHG6pDNJJ5MHUYXdwOV3MKLYkE8Ulh16Bg31ZmA76i+rivQdnS35Q/YdcvF?=
 =?us-ascii?Q?FFRteRAZC55yGOEqFTd476M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002a59ee-c44f-4c36-0d6c-08d9f62749ee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:05.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qTkfqoV4xXa3yiuSVwfpEgiGfPj55RSHwnrEcptflj07JU9Gvc6SbQYCFOwHApmswnkU8pwd4KjO/PbOSVx8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
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

Rename labels for error flow handling in order to align with naming
convention used in rest of 'mlxsw' code.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 43 ++++++++++---------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index e20ac2bf3985..784f9c7650d1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -392,11 +392,11 @@ static int mlxsw_thermal_module_bind(struct thermal_zone_device *tzdev,
 						       trip->min_state,
 						       THERMAL_WEIGHT_DEFAULT);
 		if (err < 0)
-			goto err_bind_cooling_device;
+			goto err_thermal_zone_bind_cooling_device;
 	}
 	return 0;
 
-err_bind_cooling_device:
+err_thermal_zone_bind_cooling_device:
 	for (j = i - 1; j >= 0; j--)
 		thermal_zone_unbind_cooling_device(tzdev, j, cdev);
 	return err;
@@ -766,7 +766,7 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 	for (i = 0; i < thermal->tz_module_num; i++) {
 		err = mlxsw_thermal_module_init(dev, core, thermal, i);
 		if (err)
-			goto err_unreg_tz_module_arr;
+			goto err_thermal_module_init;
 	}
 
 	for (i = 0; i < thermal->tz_module_num; i++) {
@@ -775,12 +775,13 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 			continue;
 		err = mlxsw_thermal_module_tz_init(module_tz);
 		if (err)
-			goto err_unreg_tz_module_arr;
+			goto err_thermal_module_tz_init;
 	}
 
 	return 0;
 
-err_unreg_tz_module_arr:
+err_thermal_module_tz_init:
+err_thermal_module_init:
 	for (i = thermal->tz_module_num - 1; i >= 0; i--)
 		mlxsw_thermal_module_fini(&thermal->tz_module_arr[i]);
 	kfree(thermal->tz_module_arr);
@@ -871,12 +872,12 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 		gearbox_tz->parent = thermal;
 		err = mlxsw_thermal_gearbox_tz_init(gearbox_tz);
 		if (err)
-			goto err_unreg_tz_gearbox;
+			goto err_thermal_gearbox_tz_init;
 	}
 
 	return 0;
 
-err_unreg_tz_gearbox:
+err_thermal_gearbox_tz_init:
 	for (i--; i >= 0; i--)
 		mlxsw_thermal_gearbox_tz_fini(&thermal->tz_gearbox_arr[i]);
 	kfree(thermal->tz_gearbox_arr);
@@ -920,7 +921,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mfcr), mfcr_pl);
 	if (err) {
 		dev_err(dev, "Failed to probe PWMs\n");
-		goto err_free_thermal;
+		goto err_reg_query;
 	}
 	mlxsw_reg_mfcr_unpack(mfcr_pl, &freq, &tacho_active, &pwm_active);
 
@@ -934,14 +935,14 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 			err = mlxsw_reg_query(thermal->core, MLXSW_REG(mfsl),
 					      mfsl_pl);
 			if (err)
-				goto err_free_thermal;
+				goto err_reg_query;
 
 			/* set the minimal RPMs to 0 */
 			mlxsw_reg_mfsl_tach_min_set(mfsl_pl, 0);
 			err = mlxsw_reg_write(thermal->core, MLXSW_REG(mfsl),
 					      mfsl_pl);
 			if (err)
-				goto err_free_thermal;
+				goto err_reg_write;
 		}
 	}
 	for (i = 0; i < MLXSW_MFCR_PWMS_MAX; i++) {
@@ -954,7 +955,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 			if (IS_ERR(cdev)) {
 				err = PTR_ERR(cdev);
 				dev_err(dev, "Failed to register cooling device\n");
-				goto err_unreg_cdevs;
+				goto err_thermal_cooling_device_register;
 			}
 			thermal->cdevs[i] = cdev;
 		}
@@ -978,38 +979,40 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	if (IS_ERR(thermal->tzdev)) {
 		err = PTR_ERR(thermal->tzdev);
 		dev_err(dev, "Failed to register thermal zone\n");
-		goto err_unreg_cdevs;
+		goto err_thermal_zone_device_register;
 	}
 
 	err = mlxsw_thermal_modules_init(dev, core, thermal);
 	if (err)
-		goto err_unreg_tzdev;
+		goto err_thermal_modules_init;
 
 	err = mlxsw_thermal_gearboxes_init(dev, core, thermal);
 	if (err)
-		goto err_unreg_modules_tzdev;
+		goto err_thermal_gearboxes_init;
 
 	err = thermal_zone_device_enable(thermal->tzdev);
 	if (err)
-		goto err_unreg_gearboxes;
+		goto err_thermal_zone_device_enable;
 
 	*p_thermal = thermal;
 	return 0;
 
-err_unreg_gearboxes:
+err_thermal_zone_device_enable:
 	mlxsw_thermal_gearboxes_fini(thermal);
-err_unreg_modules_tzdev:
+err_thermal_gearboxes_init:
 	mlxsw_thermal_modules_fini(thermal);
-err_unreg_tzdev:
+err_thermal_modules_init:
 	if (thermal->tzdev) {
 		thermal_zone_device_unregister(thermal->tzdev);
 		thermal->tzdev = NULL;
 	}
-err_unreg_cdevs:
+err_thermal_zone_device_register:
+err_thermal_cooling_device_register:
 	for (i = 0; i < MLXSW_MFCR_PWMS_MAX; i++)
 		if (thermal->cdevs[i])
 			thermal_cooling_device_unregister(thermal->cdevs[i]);
-err_free_thermal:
+err_reg_write:
+err_reg_query:
 	devm_kfree(dev, thermal);
 	return err;
 }
-- 
2.33.1

