Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2E49DD3E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbiA0JDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:41 -0500
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:16065
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238167AbiA0JDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYXj6yuxxJ6SmFYMQp544iiD7vmkQ+JLaHYvsGH/gb26PrJ3r4DZgVwGzki2BSa9sjNSngj58BbuQXg8bLOJOptrgcVGfrjGMYgnHthmiAJALdemEzwXQn+/iZFHV9THemtFtfv6WOuTWhvkM0ziE7xSadD6h5BxbCNWgme0ldrc52ri+OmI5IRdEcoybNtGz8L58E53dNXpViGpiLB34t2Trdy7klrVCn7TEnsgD9UeOPVy10Sz8+Qxe086oVTX2a1zOncocZb8WZQ5EEnZy31Q8d1HKkgmHHn+bMZnfRCu9APQrV1gBdv4zimTiO/JDiLB8+Uhj7wWfqu3FvxOkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJ6/GNy9zHQALWMhpYsvzZTt4fRZHu8jIF2uae6RorM=;
 b=NG+78/D975lrn0E+NnrvDMAvJg1tjaMl+yJQfc9W4vT5MDexqfPCuUnZ8Cy6cWaSdIE7lIuGh9Mqs/uyG2D8Lie/ZKmgH81iqTtdhj9qUMJzDuMSO7DSPfmLwM7YOw7+/nf09tRu64acuyXgX+/VC9KPlW46ZfHTERtsiubnMAOrw+s64nloXwtKF89bRuM5FkWTy3nNKvWTouGOfHpr3AjgDlcY3YM9GRcbqRFzLOSZSQSVDpectDIYuZpz6fsd4DcS/rOISN8beryYIwfggM9//85azg2HADzoTrUhmxh07GV1QfPxcBkUWifoef/tyJpMRdPushVSkQEE2VWNvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJ6/GNy9zHQALWMhpYsvzZTt4fRZHu8jIF2uae6RorM=;
 b=Ighks/456Hxysk7kcFzQ1qd9VJEd9wcOxz8CZ0ef/ami5nHUnbFS1WxeTHaadO0dLDz6vypA2DA5+GXrAg9PdLO3Nq1ERhafmHE49tSDGUeKJIKU9ogymCLg5vY4bzEFavI6/wo3Tv3xcMer6HpFQw0rFFyWf8pdTsFMeNeP53rKgNrlcp8VIT1Qq+Xgv/mseYk79GCnELXE4pn3i9GuRoNpMvDs0EPraqRr6T0n1lTujrpzYAIiP8JYe4ZEH27YLAz8cPcW/9j0v8lMWqTTDUXM3iEZ3E0UOatNMc/1Uc9y8OeagCXYa+LDEwh34jH+Hcu4sTpGmxdIDt//lpXS2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:39 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/7] mlxsw: spectrum: Guard against invalid local ports
Date:   Thu, 27 Jan 2022 11:02:25 +0200
Message-Id: <20220127090226.283442-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
References: <20220127090226.283442-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::33) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef0bdfc1-4441-4e0d-ba96-08d9e173e8e6
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53555D872AE12409EFFB3B76B2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ib+Tj+tzL4JRu8TDVHEhqSbqfypQcg8NqmlJAC/gd0X2g6732Me7+KAxHZhkmePcqmy+J4EFCTaDNbZDqxtsFkhsU6aQxG83L/bjh04aS2quiCEZm581mGIYPuTKHl9xbpkJ6QRH3G0JmBVKm5wSSq3/sl6PQoNP5sRlxsYqO1x1W61L55Qkke9ICmbwAjHkAxnXjS1wCHw1OfyTsJziuH1kBfZUr2+nAe6OHDYzp9/ppsN8732sGv9C72vx0DTnIq67B4JzX58ouO5+Mm7qM7dCbL6LFQt3Qy77+yv3aWKgQhp0GrKuREEwFrv/H+Oii2RtlEOcfOqMCBpLPfupPcJKXQ6dMUlGYVCLmQuwCbkLhQpqYgk6bS0pD3+ynBZaSD0qerLKy2rWOYdIUuEFerBAQN8FcIjMqGOgY/gSSzdf/44IWYEH2tYmetjPQgVuSDKmcYXHvi8PnVUblKel1ig1OOxknXjiWDbg5qGHycnht0HKP/5flDzAJ1H2nSVPXmoftTmlV1mf00dTgqF1UM8LKmheq9aiTftbMLgcE+tF67EBV2DLMUb2c0FPHlw8iZRpwL/xA1xW9sz1JFLXP6keTmlZtr7Iz6fxSSWAae4RvNVI1XVxB4MM4K0l3UYrxIhyb9cys7cmwgVoISsd5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(6666004)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MhVfr9OHnRpHoNx0ExJdPokBtkzffWJOf3bRlWbqnntgaD3oTEMsst661Yqd?=
 =?us-ascii?Q?X/p0uo8YPEPO+xGDLBcYRn5ZTX191rIpNgrnWq3Kx8wcZBYUbQaIIu3bvDQ4?=
 =?us-ascii?Q?+lJNwOCVJQW/aD17G/qLmkRWRnbDoFDUo/YjXP3EnSLdGLAAHLH5TCVMcGxR?=
 =?us-ascii?Q?id3sAA3KMpDNf0dUbQjbjyHBCr9Ln87fEwunWyNqGLA1/j3Gvy73d+lBRFDW?=
 =?us-ascii?Q?imBqjYeI2k5pzccal8O9KysH8jzp+z8UVpbPAqg2rnMBgpYVNE1KvjIj2iA7?=
 =?us-ascii?Q?a8wBqNMuBFv1xDHjPym0LIqDp89jqQRWX2UeezIFfLB00gBG8sRgGup5InNj?=
 =?us-ascii?Q?zF7ffaf5cQAGGVITs+QW6/akCzo8H0cNV5t9yiHkXgUY66BFMiJVXTZIy4WI?=
 =?us-ascii?Q?dYKuYfGUKJv+e1V3pOSVRX1NAUYp6jvBAvKxkqEfUDZio5LEgNJB5zCMbWpR?=
 =?us-ascii?Q?veSKs2ZJ852gRj+U3ZguiwhHWWT1p8YnaQDNdHdvsHFtHC8ZSrsNSM0AM2ay?=
 =?us-ascii?Q?SoEPowutykDQ+QPokXUfWkNBnijkHB9Zf+LnCLVfiXSUMHt0WrNgrpcozeZy?=
 =?us-ascii?Q?M1mfr61rkMgZyjMlqa+XqPElIOaDJ2qy5tTZrtmLi7nd+gnahiHNuHCFU9rA?=
 =?us-ascii?Q?4eO7kRDQSDmijXr15UiB9TdVWEbs2zPhmYHPFwwX+lTOL6iiT2ZTa6sLEYlQ?=
 =?us-ascii?Q?5jZFgZw02wjA2qUWva4ocsznKtygvSA9lg5INGJQUMrxZZ2HOOHg/MMV1203?=
 =?us-ascii?Q?Hsijcdawap824ymFkcMFoCV4kI1Wi1etqK0XI4pBwyPBioa5qDiCdgIzK4jF?=
 =?us-ascii?Q?XWIcl/NthlXAUbg+HZrETvi/Mv0fJt7tiieC8r7ub4fdmyfd/Ijk3B1QWYJR?=
 =?us-ascii?Q?x3RayuUwyE9FzQjz5P0HzJI0IRC1pj9O+EQrfBzx6t292gyJlFB2DjQjAHnL?=
 =?us-ascii?Q?Ax1bky5595n0wrYry5JxBnPk3g8+otEaBEbgA6ye28QJT5vi+NIay1JklJ0w?=
 =?us-ascii?Q?eRbK9LFNNCqiiS9YJe6MTxcdFyRUsZwDl5mg+RlL4Y/a97uWnJwxJzQDCzYQ?=
 =?us-ascii?Q?wKeT6e9vnz+FYPItkrOcWwuOrSjPeWgGDLeeu+HUxnppwR5sDNLHL5P+fDfA?=
 =?us-ascii?Q?i+jJUCW4f4Oc3xsm3oldcuUeSw80HEtID1uZxs7hZ0PVpqPR7T4S+2GRyNqp?=
 =?us-ascii?Q?o90CBo5sWSELExXY9WCCDsvSgezSzG4zMYMmGD2nl0Z66uO1hKeXOLI1a3eG?=
 =?us-ascii?Q?OL9TGxzoFMg/Qhu/WUWHlLukcqSHvmSm1Xxvd8s5FpflgESGvnNR0VjYN6fD?=
 =?us-ascii?Q?RuwOZhzj5yYKATbblj7OSjGFQxX8qMUvqaI8lDC9dysz0oq61Qqrm9KtjMLM?=
 =?us-ascii?Q?cNHHOG5C8AKZ3OhyNYA3YNJKaxxbWQNPHUGpFNPz6DOdINWsZIPwOxafkYpm?=
 =?us-ascii?Q?pbVUCwv0MygWHgJbx8tsk4xdl1AyOCwIxNtDOREjHxUTJvfit7dtOBVqw+84?=
 =?us-ascii?Q?SN3OQ8NE5YJOXNp/GTkb/1AoIE75gV9yaDnGvbffkxd1MPoUJsuvQQVRYQJx?=
 =?us-ascii?Q?96PDnqdx+wdpXU0krrJ3UNqTWP8JptqTiGrx1MjuZCyd6Wa4/4PlWZXLtHWw?=
 =?us-ascii?Q?917BzTVE4WAir/CQQGAQUSQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef0bdfc1-4441-4e0d-ba96-08d9e173e8e6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:39.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oBreIYQ1eP0TubNx1/EHgszq+MY0pt2BqwhKmUdNuSKn93qQFQwozrlLqJGSAA7GLCwgC6vVdkno4WEeQNQHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

When processing events generated by the device's firmware, the driver
protects itself from events reported for non-existent local ports, but
not for the CPU port (local port 0), which exists, but does not have all
the fields as any local port.

This can result in a NULL pointer dereference when trying access
'struct mlxsw_sp_port' fields which are not initialized for CPU port.

Commit 63b08b1f6834 ("mlxsw: spectrum: Protect driver from buggy firmware")
already handled such issue by bailing early when processing a PUDE event
reported for the CPU port.

Generalize the approach by moving the check to a common function and
making use of it in all relevant places.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           | 4 +---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h           | 7 +++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c       | 3 +--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 3 +--
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a3f95744118f..a4b94eecea98 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2148,13 +2148,11 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	struct mlxsw_sp *mlxsw_sp = priv;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	enum mlxsw_reg_pude_oper_status status;
-	unsigned int max_ports;
 	u16 local_port;
 
-	max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	local_port = mlxsw_reg_pude_local_port_get(pude_pl);
 
-	if (WARN_ON_ONCE(!local_port || local_port >= max_ports))
+	if (WARN_ON_ONCE(!mlxsw_sp_local_port_is_valid(mlxsw_sp, local_port)))
 		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index bb2442e1f705..30942b6ffcf9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -481,6 +481,13 @@ int
 mlxsw_sp_port_vlan_classification_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				      bool is_8021ad_tagged,
 				      bool is_8021q_tagged);
+static inline bool
+mlxsw_sp_local_port_is_valid(struct mlxsw_sp *mlxsw_sp, u16 local_port)
+{
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
+
+	return local_port < max_ports && local_port;
+}
 
 /* spectrum_buffers.c */
 struct mlxsw_sp_hdroom_prio {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 0ff163fbc775..35422e64d89f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -568,12 +568,11 @@ void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
 				 u8 domain_number, u16 sequence_id,
 				 u64 timestamp)
 {
-	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp1_ptp_key key;
 	u8 types;
 
-	if (WARN_ON_ONCE(local_port >= max_ports))
+	if (WARN_ON_ONCE(!mlxsw_sp_local_port_is_valid(mlxsw_sp, local_port)))
 		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 65c1724c63b0..bffdb41fc4ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2616,7 +2616,6 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 					    char *sfn_pl, int rec_index,
 					    bool adding)
 {
-	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
@@ -2630,7 +2629,7 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_reg_sfn_mac_unpack(sfn_pl, rec_index, mac, &fid, &local_port);
 
-	if (WARN_ON_ONCE(local_port >= max_ports))
+	if (WARN_ON_ONCE(!mlxsw_sp_local_port_is_valid(mlxsw_sp, local_port)))
 		return;
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port) {
-- 
2.33.1

