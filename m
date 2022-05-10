Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F4520D6A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiEJGCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiEJGCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AD22764EB
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKmZJtM6iWVAh03aEJ5AiBbRpo0eMcCNWgHhtaVw4u0iJBwjIBRS+VTeMiwGN0A3zQ1VZjbBuktxEf/7BcWwomwETaX3iJ0quyD7k/sW/S2Li9uiKz4hyjuUzikFKDZmpzkE/eJpTFsm/lYM3WtECGldoH4WV8O2imOu1i+uz9vhJOfMShQ2szzxHp5aHCHrZcMMVaxQVb0ieXINzsqGA+94GxNeXvzL8WHGQqimValj0TDs1FdwrPcOl8YY9UNAD6cr03VpzrBNu5Ku/X5ic/hazrg0eWX1jQfJAhYhG3DG17cts4RLzkqU+eCgMfIlLG2tEmmDRSiOEtM+kKkwkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACObdb178CSBlNpesNroGPFPy5Kq36mtFRI2Z308tQM=;
 b=DiErXINyyOKvGEI59TcVuGeK1Lria5kQW3qYGGNzzeLGPMZZEMMzOM3Gy1bmEGA685aZk96gz5x5SGwb6k3U3uRhGuKKA2DXrZS68c0u1e55QnU7Y6kI9qPOUiOTClJ1vq2mpmOJmEwWyEs9GOs2hEkt3S5D2BAyV/C6OJi94Kyllr94B1giNIGj8+lmWfZCNNv2sajWprV2mGh541ejC3UPPb+pMwNSOLNWiXsDeW/1Ll2LMhgdSH5fyXUNtqXBOnu22EznibJZ+vTYJDLRxJMEiujk7lyXMjnTCClJ8tIiYRUbX6xndYEuyeGjtYBsvfi6xIIngM7L34eSjoqd4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACObdb178CSBlNpesNroGPFPy5Kq36mtFRI2Z308tQM=;
 b=NgS/whYsa28p8S9fc7y1wxzm2WcuonV/dhX2J5PG128zVHZClJ2Im3nO39+k4423knfm2L82xp6K1CKLWUycwFMJ3e345xUNPSPlFL/dyxoVrIMALUihwFaKCA8rbKDwczuApY/fQZSXmC5JL1rvClXIicZIIGzhkHPOKMbifWd2Nspb7hU4jseBOlE3DP3mKZbhAwVlwoWOm+E3eZkOC5iAGyqkQgXOldtoRJLmQc14fCb2MMQNzwNfRA6ogfC6dNW5n4+dIVc9Xr5jbvm6Jamnq6nQDbGMwINwvRQu6Qr/jS5Rp5no+3cfG+RNKcW+z78bZImh0ON7Ar5evyXyDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:04 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: devcom only supports 2 ports
Date:   Mon,  9 May 2022 22:57:32 -0700
Message-Id: <20220510055743.118828-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0006.prod.exchangelabs.com (2603:10b6:a02:80::19)
 To BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 028dc94e-6222-440d-8740-08da324a0c04
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB63834B74AA7CD9A61335647DB3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDsANtH/KtHpD+gB9IHwKyO+oycsI+aHm+b/y2wa0ef/U8N9Y5IJUnVszh3NCQLnJJ9RrZ+r10Qj5r/VxQanTVBmFoUfFIoZM0yPP3EN4omX0Paa/eE5QD6WnFNgdvLEXxxDwBgxfg10T+AuF2GFO1XMkk+H7QRjMwunls3gq1Sg7JiCj0eULanAlV+PJuxYnjhY50fCmqN4xtb+YZJxGoFKkfoPbhZV1JLlVQhlSWT2roOvUKaO68BPP5g8VpgC4bRIL3Q6CMqyS9K0avn+88QgHMnlTMa0FzUet9Gi6LECqCBWERx8VEMmVCRBAHLoj1lUNaMisKcMw25UyoywVamMeauG8GRyj/HZnip0Il+upbm97KX3pwxyN/pn4McjI7lKzSGQCDViUToIWIGkE3hl54ejX3SiNVStOeZoGjnZvO0lGny16OnTDWV0S9TnPag+oSF06oq3mqqd9sCaCZOW/R0QREepLnVitrRHVL3WpjwfeqXvlCbD2hstQbS2m8PeFd2nzdo0KPv/WGLm7dX5r+rlHaLP4eh71pG9i8Zd3jy9SSCO+YTmH+HBLK736dQmP0C0NEtrPbFw5fhK0BBZKJTEwJDW1HJckteofxuzUJDIhEcx5dXzprDptQARUHp9TV11XVk4h0wHvssf5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dKpMgY1jx6EOH43KVSFgEDP1qHnQTGQgkrsMVWa3/UXcYf4SgmeEp+EYt+DP?=
 =?us-ascii?Q?8LIO0j2zPcBU22vxgOpQK3Qk4ONfx71lPiejK6NYtzmQ/zLDYA7xWSCtBe61?=
 =?us-ascii?Q?xu0bxVTst61OMwdCBxUvXTDXGCd5Y5dWBYg+3OJYP2cqdlXWBRhbqFyE9Bmt?=
 =?us-ascii?Q?pcMCAR6mxrazEOnN6ZuuNwySbixvwQlCqA5JIn53gi3g6euz/ybmSFewknzc?=
 =?us-ascii?Q?qvyc7rHRBN6IRoPxiOw2XcEz9FHar9d9lPcgSWvVHL5jpTa+FKz6V8Y8v7Jk?=
 =?us-ascii?Q?6krsUSl3LvIcCiJVXBWoImaoqBKOoT3gc4oFuY8vb2ZyJepGjJF+PTiRced0?=
 =?us-ascii?Q?v7ee5KAN6EdA47qIJTGDiXB0ciPbv44ggZE+TDcfnZbSReWbs/uOZiZfhUtw?=
 =?us-ascii?Q?SQduGtja6bGyn82CA4dpWFK70jdGU/dn+B9p97Dsxynzs5P2szeM1IrVDVZ1?=
 =?us-ascii?Q?Bmti5KOCawjJbm8ti1hNyBTV+H/yF3dY0akOBJUKpSpaIiDEglcBZGUxzijw?=
 =?us-ascii?Q?oJYgqEgFhP4ypW+/oPjCe+jMXGYlQ8CtJnx0yoPv+vVE6susNiKwTLhSm77u?=
 =?us-ascii?Q?eI4/6BeJp5J0y7gAD7Yf/iJUVk85AWI5/qqBm3M98+ozZ0wBylyXaelQ5bTg?=
 =?us-ascii?Q?IjGuqQ6Ov7+Qm+3lk/EsX5xPZToQ+nIWq6Pl0r64/Yenqkmp7dMH0kCRuvCG?=
 =?us-ascii?Q?kUw0wZ87ZooM7Jd196nT5lba/iew30KDpVtZTIGYlUpNOB2lZNfa5OAB6QqK?=
 =?us-ascii?Q?uh+Ci8vLso/0pE4pnZzObPD4E2wR+R3L92QHa7kka+FFVa1KXV9pPKDRE1U/?=
 =?us-ascii?Q?JaTrDPrTzhD+52ih3XyIBPcaRgsXkuf/Td+jdMCBavv0dZR/TosJMSpSHMZc?=
 =?us-ascii?Q?YODwL6c85vuc4bzFeD9ulW4LVjsa9v4JV9MUX4Sgy7cdheRZaVIUjCNDfHGq?=
 =?us-ascii?Q?TAnHFRBep3jdiDj+Fo/HI2hBT0caDilqD78lWl36qth5wQF5OQgtMItx7Eew?=
 =?us-ascii?Q?Sw6dEzGHuqqNEOOwdu7XCNb1fPblHDPHxlD+mfzSWR8Bre6Y+jbQsO1evJHc?=
 =?us-ascii?Q?/P5D6kmitq8tHVT96TklfvF+7abGpf89g/npqmpZoShp4SujqfBrD8oRCyIW?=
 =?us-ascii?Q?dl9S0Y/gAKNU0OS7VPOsN0ZO2+ONPlp/opmLUbI38ctsIvcfji/fAJh0E9+U?=
 =?us-ascii?Q?y5biRu/cxBXsDcJQ3vQ9I3orh8yAAXl7SK53kXxEQzf3uiCO3DRtQCVIeU61?=
 =?us-ascii?Q?W2KxtMcPKGFwawE7we3zYEEAzZ6BNDEynyHFIe0TQbFWblaHS6lEjuEdZIJH?=
 =?us-ascii?Q?eUrjeN1G3n0tvjZzNt6HClT8NzCCNaNfgMVp7rmxOIoo9lTTqBeF+hWwIHQ/?=
 =?us-ascii?Q?MQXek19YMCmDcb8o0cUeWrj54Zu8V28svNvo37/+oY9NKmEFsMk3S2PuYL5U?=
 =?us-ascii?Q?QWT3eKgzPWxvtMem+Tu1lpIW/Wu7ryoQ9vLGIDS04bSzihUt8/mevIdDR661?=
 =?us-ascii?Q?O9elnBOGh6sI91tmH3uSAyLz+8+EBdZWeS/s25iF4oxaQ4KoSKCsk5DBhIZi?=
 =?us-ascii?Q?1xAld62w5hjA+Svg8rcbY9to0ZXWwlBCJOq+0O6qN9p1ZoIRI01QhAgZjBZY?=
 =?us-ascii?Q?B/ASHUqgCDmmgHR0CJ3Ld/MMy8YdvHCuTU4zdrC/IXiA9ycUraJ4xZvkSzxK?=
 =?us-ascii?Q?JwfDUMo5uwpR601zINUrUrv3SRQhYlLJTqQIZbiUMTsa3xkX/On4lNA2DuLW?=
 =?us-ascii?Q?JbIYd6D4UCy7Qv8ZXLCQFAWY9FxIQWhEBbPE9EfUK3FLOS/XP5sM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028dc94e-6222-440d-8740-08da324a0c04
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:03.8515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+lFwAJt3fcmu2fCLHT2LUevwaNUlUbMbgvW6F1jGv2PMDMst3Xd1GrJMBHNalUS9gOZvJki/g8/9/dHwfyfzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Devcom API is intended to be used between 2 devices only add this
implied assumption into the code and check when it's no true.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c | 16 +++++++++-------
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h |  2 ++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index bced2efe9bef..adefde3ea941 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -14,7 +14,7 @@ static LIST_HEAD(devcom_list);
 struct mlx5_devcom_component {
 	struct {
 		void *data;
-	} device[MLX5_MAX_PORTS];
+	} device[MLX5_DEVCOM_PORTS_SUPPORTED];
 
 	mlx5_devcom_event_handler_t handler;
 	struct rw_semaphore sem;
@@ -25,7 +25,7 @@ struct mlx5_devcom_list {
 	struct list_head list;
 
 	struct mlx5_devcom_component components[MLX5_DEVCOM_NUM_COMPONENTS];
-	struct mlx5_core_dev *devs[MLX5_MAX_PORTS];
+	struct mlx5_core_dev *devs[MLX5_DEVCOM_PORTS_SUPPORTED];
 };
 
 struct mlx5_devcom {
@@ -74,13 +74,15 @@ struct mlx5_devcom *mlx5_devcom_register_device(struct mlx5_core_dev *dev)
 
 	if (!mlx5_core_is_pf(dev))
 		return NULL;
+	if (MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_DEVCOM_PORTS_SUPPORTED)
+		return NULL;
 
 	sguid0 = mlx5_query_nic_system_image_guid(dev);
 	list_for_each_entry(iter, &devcom_list, list) {
 		struct mlx5_core_dev *tmp_dev = NULL;
 
 		idx = -1;
-		for (i = 0; i < MLX5_MAX_PORTS; i++) {
+		for (i = 0; i < MLX5_DEVCOM_PORTS_SUPPORTED; i++) {
 			if (iter->devs[i])
 				tmp_dev = iter->devs[i];
 			else
@@ -134,11 +136,11 @@ void mlx5_devcom_unregister_device(struct mlx5_devcom *devcom)
 
 	kfree(devcom);
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
+	for (i = 0; i < MLX5_DEVCOM_PORTS_SUPPORTED; i++)
 		if (priv->devs[i])
 			break;
 
-	if (i != MLX5_MAX_PORTS)
+	if (i != MLX5_DEVCOM_PORTS_SUPPORTED)
 		return;
 
 	list_del(&priv->list);
@@ -191,7 +193,7 @@ int mlx5_devcom_send_event(struct mlx5_devcom *devcom,
 
 	comp = &devcom->priv->components[id];
 	down_write(&comp->sem);
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
+	for (i = 0; i < MLX5_DEVCOM_PORTS_SUPPORTED; i++)
 		if (i != devcom->idx && comp->device[i].data) {
 			err = comp->handler(event, comp->device[i].data,
 					    event_data);
@@ -239,7 +241,7 @@ void *mlx5_devcom_get_peer_data(struct mlx5_devcom *devcom,
 		return NULL;
 	}
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
+	for (i = 0; i < MLX5_DEVCOM_PORTS_SUPPORTED; i++)
 		if (i != devcom->idx)
 			break;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
index 939d5bf1581b..94313c18bb64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.h
@@ -6,6 +6,8 @@
 
 #include <linux/mlx5/driver.h>
 
+#define MLX5_DEVCOM_PORTS_SUPPORTED 2
+
 enum mlx5_devcom_components {
 	MLX5_DEVCOM_ESW_OFFLOADS,
 
-- 
2.35.1

