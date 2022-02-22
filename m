Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294904BFFF7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiBVRSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiBVRSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDB6122206
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:17:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bx5lGDgPzS0Dz5UXyJji3IG9wh5KEGgqknRm9dzkmbDDCb4Y6yZYUndWyst7MdAp+eLg9VfRu8x8+iEP61iyTS7hMU1oXxfyXaF2c/kNPXOoDDq/cKt1QfXYQPFe0KKNdp/0g1Lq19Hc/nh85RME1R8Y8Cu7YyROnFj7vEEJTjsZcbzUUQxs6JOaDjeyk3WzQElv76/G4dFfqfDFdNgHBiJxmrRjIoaYpSddq5Cxygd+du99sx8hjHteR7F2/nf9mAfM/9u+zdHdQhd2+8hYrewISt464XvrueaVqldPdSgXd2BYusFIYN3XJ10ihQO6bxsYQr4ui/GoRrnV65Cjxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iymUOxILIICnRA8qJFVdNAIkLS+PM+w5LkUVPHXS7TU=;
 b=hwPijVd0tvLp+JIsVehjNt1rFr+8ivtOeg3TQToeGX4Yx+qBI/doJlTk9EzvCErWgNS924XZ/v4bZsTDcPsJac/dku6SLEnSNlaWpSmlcxnkRXq6h+7clZonSi15tj8P2+uVBqAjiP89i/2tNUVnzf+a8gwDYoa95rXXfOYZGdpaWGiwvkI072k7s8BvWgByJ/ToD5NtBT04iprfz2Pzzlfr1LCI42Z+JRwiV/8Bmhp16DP1NR6YlofQn2gn1OgrPR3eW4obtsoc9p2shxA2UnFb5KaF95YPlyPd0i55QD//xmXQQalHoRcTsewi0hW0YSLaCcbg5pMtBINHTlANnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iymUOxILIICnRA8qJFVdNAIkLS+PM+w5LkUVPHXS7TU=;
 b=QRmOFAIvhD65i8egs5U/Hsc+/wD80SROuatDJDifVmASf6BEgjVa2u7t6IahXCHRX7imEx0ZwGYJPEG/4uwNVbvUmJvb/zRKikRKISrKCSarAGVKdQDcewSiGDIW+9oaoVTAoQZv0sPvZeiohqZB5SlQ7+1gW8opyXVlqSJpZj6qtLbJhbfS/6x6n/j36Ls6Cdpn6bou9eMjAhXU+JXvLpV5k0z/ruu9XhpUAK9sHU/BszMOqusE6YZc5Z/LEYdasOFifdRxOW41xlB7d8Ux8CWER1zDdQJWtc1OKPGUA7owpi+Gp2ektDIFtKIbw5RtRTenDlcvrqeUh94Bj7H78A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 17:17:50 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:17:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/12] mlxsw: core_thermal: Avoid creation of virtual hwmon objects by thermal module
Date:   Tue, 22 Feb 2022 19:16:54 +0200
Message-Id: <20220222171703.499645-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0177.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::25) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b3eaaa4-27d5-431e-3a56-08d9f62740f0
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52145293F1018D494C043887B23B9@DM4PR12MB5214.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DcdiduHmEVjqySjAnkHNevZglipEyOhGqQO3f0XbXTn/xoaRZixWpiCj7HIuePnc9VgTDTPZTUvHTl+V7841pRgJRR4L48V9yt/t2a08xDJDbHbRuRgWJoIvRh1xgSVllX5pnef48G5Djqsg01+uaeuGpf8ZTm0WJ3KhHRSsSHvZRCcYyPKXujRqCPEnCbQE/v8PGxfuIPvllQQuuILNBBhot3Fljea2e5fCvd8DI+a8k2tnTv/cP4Lz6eb76p5hhqUWqWYaeKKzLdUDTHFlk58zjM3WKJ277MpAa4BQXfO349CMU+OGNHsoW4OBCYqRAh3kf8Vzae4HFEK1A//qpOV8luf1L1Q13GuGr318A07jNfsohBp7Kg1F3hJ8tCFlpdTGD2UNcEolLnNTU5EWaO2RIoVT0Cpq5kSHNkRfEre6zduRc9RMuQkZFC1DCAzWacU8OYbIXNeTQuDcZKL4IOF6y2vlyE3AtRfF7IoAkJdeMwm1QF7CqF+kcarJbN3lacie2HFBxoegzQOQlN7gQzCDhfNVB63LSCzuWLYtSp3KeYF6pAB6z5z5N/2m7lcFS2Z/6qVoNCFgs6yvKjvAeKBIFZmCHes7xWuX4rHsAmBnELop4M2wG0aiV/h58BQFNsT8t/FwGZiSD5XSg6wKdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6916009)(316002)(66556008)(107886003)(2906002)(2616005)(5660300002)(1076003)(8676002)(66476007)(6506007)(36756003)(6512007)(6486002)(508600001)(38100700002)(8936002)(66946007)(86362001)(26005)(4326008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3eVz6I2s3V0jST/3kswDotWigky726MyxmGHAyqIPqxmfxFC/rXIeVC5KPmp?=
 =?us-ascii?Q?i9us9B2dPJ6H0Rw4/BvAeJPIop6CTfTo7+wb3DN041xfpLpaOq6PTjdgyQRD?=
 =?us-ascii?Q?SmJ1FBpDtk/j+UeACXHbUtSmFnF669+5akU7pKSxiAqvX5tQGPnzrp/XeWIJ?=
 =?us-ascii?Q?NahxWJdAllBH/xOTNU0iz8uDdC1CiZ96ms3VsWnTKEQVaiIq5jK4QcUG4YrA?=
 =?us-ascii?Q?DoWm+PH/rqT+6ltxvmAF5A+jMCMDMw1OGs6YjeI8ZDTKNTJwfh9EKuUiBiFd?=
 =?us-ascii?Q?cVkLRrPpQZ1e0zdinDyoOWpwLx0RUK1keCWCPNwXO5HkxQOHx9vMxdjC06Sr?=
 =?us-ascii?Q?7MXcehlqRoWDQaoMRMlBFIvuwAj3vAjZ0z2nf6zm8/MVwHN6/3Q/yqsGhyff?=
 =?us-ascii?Q?j5HfirtsMupCxuJ6sVkGbpLMK8aPmEextWJJK7UzfybATGuQmx22wZUMDbvX?=
 =?us-ascii?Q?m05LGaBWE2F2XVIrTlci2QfY2yJzMIeAfHeMKPYGq+7lh2J7/IZ/Mz2rdJU1?=
 =?us-ascii?Q?PXdbt8AAhK3F8ZafMf7jh5zQJuB5NQq0xGfOMztcKBuVIFIsEeg6h+8Kzvmg?=
 =?us-ascii?Q?/VO45PUSDCDFSWoUNQqNjNKUef3QFLf2dLdPa3qDJ681S302GgWPQUh3YJvJ?=
 =?us-ascii?Q?kRPwPinIPH/z5wuRnhVa82P8y4fuPokXbaSTdhvLWoO+1gzuAPMG8RFYXW4Q?=
 =?us-ascii?Q?MI/HkRn0jcGn9nGhKWCBehs8D7GwB+sjrk8jMeWohaW74nIERiXZy0eAwU5A?=
 =?us-ascii?Q?m81TfuAHKhftCuV0RSQ+lDgwAzTl08sljKWVVqL3cCqM89LU13O4jfEAoJZ1?=
 =?us-ascii?Q?ydKLLfDMJYxAcrjcIQJWsp2Cifi12IyknYblofqCpSealBgSNd5N5gGCEzP3?=
 =?us-ascii?Q?C9ZVPHU/4+58H9ZaqwyTIHhTVgxTFRttrNPkG6zWBGBr2D/0hY8WT2Mb5/qu?=
 =?us-ascii?Q?Vhzzsxuy5f45pZ2zrdzl57NjurdJlvICT4CFlcVdKsVO0gFK+/1paQK8nxS+?=
 =?us-ascii?Q?3z+p+0fvbtgRvOBHLxKh9t+/FiFbH9uqt7yj35LKPqE38VJ+tyJ1vfCTD+3+?=
 =?us-ascii?Q?3vE5dHRam4wwsaart3Cwh68SICDhGoLDwp2Td2w8R7c/vMuv6BjUx1zNf9kY?=
 =?us-ascii?Q?Dsq+xzRKuw4IbditVuhTLijMVGF6XGxymm43ltmxRZy6EL7TNIYvivifgUx2?=
 =?us-ascii?Q?/tbCZJhl9GBjSE/SNozfneozk1VCiAWGeYHDGGGWnRnKzlg5mQkj4noqpJ6o?=
 =?us-ascii?Q?vrnwlgqjE9TN49Aly8FD3+7rGgBwEgTW0AvLiD/mJb9hsefHXNXg8h81pz5R?=
 =?us-ascii?Q?IV2yPW9vhUgjZsvrcEmVGKB3eV3UNVj3Ie9bZDue+laD+zEkYe2BA3fAd4l3?=
 =?us-ascii?Q?lf0VQeJQ0F3pCt++CJhl2wHmknvF3Aa21S1wpu5WSs6ByXcU2yqE2sJpNoHU?=
 =?us-ascii?Q?nvoUHVIXDiLFRmsbaiGd30dH2Sw8hWvkSXHkLTlbsa8wKWSDg4oUcH6eoPPA?=
 =?us-ascii?Q?oM33M7uFKLdJqWSEyalN4D2xyDPpU9kCX7JUU6SbP7Fiz4TJOASLvPyafnKG?=
 =?us-ascii?Q?2aGRsCercMO8BbhmS1tHwu/XMF9heSYPNIEaig8G8FQ4W665ohYfYd4pg0f2?=
 =?us-ascii?Q?+AIycWL+Zh9/DXIuu07sE+0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3eaaa4-27d5-431e-3a56-08d9f62740f0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:17:50.5778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Jrq3GXbyvYmZHmtXeHghUrqwXvjQAyRQ1kv9lV7P7Z39aUhWdh1sllIEL7tp3IodWB+h8TICoPRl+SR0T/qtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
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

The driver registers with both the hwmon and thermal subsystems.
Therefore, there is no need for the thermal subsystem to automatically
create hwmon entries upon registration of a thermal zone, as this
results in duplicate information.

Avoid creation of virtual hwmon objects by thermal subsystem by
registering a thermal zone with 'no_hwmon' set to 'true'.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index b29824448aa8..e20ac2bf3985 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -357,6 +357,10 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
 	return 0;
 }
 
+static struct thermal_zone_params mlxsw_thermal_params = {
+	.no_hwmon = true,
+};
+
 static struct thermal_zone_device_ops mlxsw_thermal_ops = {
 	.bind = mlxsw_thermal_bind,
 	.unbind = mlxsw_thermal_unbind,
@@ -678,7 +682,8 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
 							&mlxsw_thermal_module_ops,
-							NULL, 0,
+							&mlxsw_thermal_params,
+							0,
 							module_tz->parent->polling_delay);
 	if (IS_ERR(module_tz->tzdev)) {
 		err = PTR_ERR(module_tz->tzdev);
@@ -808,7 +813,7 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 						MLXSW_THERMAL_TRIP_MASK,
 						gearbox_tz,
 						&mlxsw_thermal_gearbox_ops,
-						NULL, 0,
+						&mlxsw_thermal_params, 0,
 						gearbox_tz->parent->polling_delay);
 	if (IS_ERR(gearbox_tz->tzdev))
 		return PTR_ERR(gearbox_tz->tzdev);
@@ -968,7 +973,7 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 						      MLXSW_THERMAL_TRIP_MASK,
 						      thermal,
 						      &mlxsw_thermal_ops,
-						      NULL, 0,
+						      &mlxsw_thermal_params, 0,
 						      thermal->polling_delay);
 	if (IS_ERR(thermal->tzdev)) {
 		err = PTR_ERR(thermal->tzdev);
-- 
2.33.1

