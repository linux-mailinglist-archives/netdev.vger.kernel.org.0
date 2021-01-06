Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D802EBE43
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAFNIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:08:42 -0500
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:24773
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbhAFNIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:08:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpeBG53h3nRqZ9X/J01PxeedBkiKq7N6e4zrx7znC09jKdoh/cYmPG4bWZk7vXubXPgeJ0LMNVIf7zTvB5M5T5rjP6rE5K+3tOLH5OflLxzUGqhvse6kc5XbrX9LgCH0JGVe97S4RTbyuDwWNUPYe0zQxW1LH7IMOm3p74VvrGRN90meKwwjURmEaCGcPlVqoopAqjV6N+x3k1TPYt45ESTaesBn4CaJkU9uzt6J5Uvx5FbEn72OLTY0DGndLNN4sOs2mu1+AGI+/RNo0avonjxvKoDcQKo1Rk/WlKQeJLKz9v5rWfyIE3GgQsRu2eI+SLjkV06ElmNAjK/PIoFApg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7A8m25TdcNQabDGe6DusymhCIc7ZHOJLrf3nn56WWSE=;
 b=YtppY7yeCtrnDFAj+TbhAMAxNQrsarr/XU0Uro7QWhiBX+4U0N1L+R4d4mWjjEm0LLkTPo3uv2UeGMR4VPMKUFJd9EC+tuhO9Jag0MM2SKA/pL2Me2UVnd0tkSpWDxSTE9T8krnJccXOeJN1BtmslaZLFsYgrKTYae07Y84WLa90eAWFE+kC+PX+r6YthtZkVrOMsH9zldbVqyUsZQL0/q+bR4N+bY9NRgNawimNCxvPnBtDMjKvTDrtNQFAkgCCkcCx/Up0Sxny+gGcYTNjqn337v+iFszZR3c7X/kpLHcKaiLwd/cQqTaB67AoAX2/32p6wmKuIQbOU0VvODFYlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7A8m25TdcNQabDGe6DusymhCIc7ZHOJLrf3nn56WWSE=;
 b=LY5FaP7G/1JZxh21z9/PGCsaJZSmg7Kw6mNVg17KC1yRsm0Oy/IWOvf+mpj0XjezQCMNsZ7dR/QusUlXCi9R7K0rES3XWN7XXtLyACefdOGyYL0E9loOfbcYb+t7Zaax2iksZDrzzlcxZm2mrNU67kID4iPk/O5XGF3B0CV2IXQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4308.eurprd05.prod.outlook.com (2603:10a6:208:62::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 13:06:46 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:06:46 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next repost v2 4/7] mlxsw: ethtool: Remove max lanes filtering
Date:   Wed,  6 Jan 2021 15:06:19 +0200
Message-Id: <20210106130622.2110387-5-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106130622.2110387-1-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0102CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::41) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR0102CA0100.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:06:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2a59478c-2f5d-4802-ad1c-08d8b243ec0d
X-MS-TrafficTypeDiagnostic: AM0PR05MB4308:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB4308534F92A6394B53130934D5D00@AM0PR05MB4308.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NqJ0ZafMCZp+WaO18DvM0fJAmDdL0DyIX0+zlVvW1SC3KwZnnSuL1EV+iL1wGqvNtWPdW4/VsVa5iZ/5gwewokYRSe4xPdOoSq0Vmla2ZzNYLoEewuMcXca0ArdfV2gItZwprWJqRD8QDHSLZOihChjWWR+Dv7c3HQsjAy3RtkHUx6P+IaiKNTppu8jsZpaD/5FVy7YA2auQT1oFWH5CZHXQdX8ffk8g5mvVdhOyq7wMNcgcbbrjl8HlKyKRy2NECNJqVTyHj2d3BgFnqBbaPTHIpvTk145JXLOYUQ8NQy46RWcJjw16mwWEX6hvV3Izm/UbvI3zGs/zibU+Sg8K1FRI3BoeZwa+S81vquIT/lDZLIsf5uRk+eq3u1UgtJmq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(1076003)(186003)(478600001)(7416002)(26005)(6506007)(16526019)(83380400001)(6486002)(4326008)(52116002)(6512007)(2616005)(2906002)(316002)(6666004)(8676002)(8936002)(956004)(66476007)(66556008)(36756003)(86362001)(5660300002)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?u8FaHtrhai9mVbuuD3NFOQuvzldZTki9SsU96BXppYPReSiP33qMrLIA3MQu?=
 =?us-ascii?Q?x5vO6yKY2aoW2LT8QFOlyhcmeIA6uhNnNPX9p0N+4DUKNx6tfAd+00VTSXRw?=
 =?us-ascii?Q?9D7G3GYr39eO+QqQnoP6lrsXzN/LrgFYpEUDN1aSX9aTbj5Y0CTTACE8TYOk?=
 =?us-ascii?Q?zEd2VTpZQYZxqijIkwNFt82RrKnpIby8/OyU+9HalSjABzTE0z+idVNMNWmD?=
 =?us-ascii?Q?p8Ri/FbQKEU712ZDLTaEqF+yWNgiC57oFKM82F/Qgrmsf1Qj3JIODEswC+4E?=
 =?us-ascii?Q?ZySIh4Fv1sMOLzX2olEe/xuJaT3yGGUkxuVjvTOdwRBz4suvXMnkjk6Wnc9S?=
 =?us-ascii?Q?k/c/guHXxbTZpCsYcwfC6uGw192eFGuaj39Am9K4NUOVdNIY/bdS8KyaZccr?=
 =?us-ascii?Q?tVcXBqM3/Ac5a5rztK8TlFFPjFj24lF9Ch9wax+0T0s+zPmrDrRfZduXtx4q?=
 =?us-ascii?Q?RC16ofPbjPK80zaF4PKK9Pph5nS3EJC7TUq1ms/gcdJmD0S2vRBxF79x99Fo?=
 =?us-ascii?Q?PCZFKcuYVhNPg/FO0gV5jtUSJ4yZz3pILaVpwItfoYvgXK1m5AO9F6KZtW+l?=
 =?us-ascii?Q?4QHPtgj34PLka0VTPayRUanWXY0BlrAWDZku4UG/Tqljw6R31hLs96y2gf4c?=
 =?us-ascii?Q?WbWmfi9HzJvwIJbXbjawl3PC5/Z2LW+gEKw3nvrsv79VHR+uU0fc3Il95MVV?=
 =?us-ascii?Q?Ro6N8z0F7oGtFjZdhdrch6qu5olRRyIKYHGdW+LQ+LT4qPGFpoRkguzjx7vc?=
 =?us-ascii?Q?JfdjwDV3Vt03NeCnqZCLUMApfIDGid56Ee4XSZ81Uirsx5GZ8vgozoZ6TnX/?=
 =?us-ascii?Q?Tlw2sSZrgHG1h1EBSwa7nOby6bitR0xfZs8zrk5dPW3N0i5vS84w55zlu0BK?=
 =?us-ascii?Q?E99hkN15dvjJwQSXMf4hUQ5wF2nnXD/CY9oM3loIZ8+N1De1rtNAf+qJhX2E?=
 =?us-ascii?Q?9FRFOQTVVpVzEmzacjrts3Fk6tFnQyoKrBZRUUnzfaKl9DjLDat9xyOpew9z?=
 =?us-ascii?Q?GhB8?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:06:46.4608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a59478c-2f5d-4802-ad1c-08d8b243ec0d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /0spHQkLkPUNCXdkIsVcIHg7UcaTCOzxV4duP91Tsy+I7Il/Dv93/+COqxTle3vn/I5lmcK2hbAXw6OWizmecw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when a speed can be supported by different number of lanes,
the supported link modes bitmask contains only link modes with a single
number of lanes.

This was done in order to prevent auto negotiation on number of
lanes after 50G-1-lane and 100G-2-lanes link modes were introduced.

For example, if a port's max width is 4, only link modes with 4 lanes
will be presented as supported by that port, so 100G is always achieved by
4 lanes of 25G.

After the previous patches that allow selection of the number of lanes,
auto negotiation on number of lanes becomes practical.

Remove that filtering of the maximum number of lanes supported link modes,
so indeed all the supported and advertised link modes will be shown.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +--
 .../mellanox/mlxsw/spectrum_ethtool.c         | 33 ++++++++-----------
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b1b593076a76..cc4aeb3cdd10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -329,13 +329,13 @@ struct mlxsw_sp_port_type_speed_ops {
 					 u32 ptys_eth_proto,
 					 struct ethtool_link_ksettings *cmd);
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			       u8 width, unsigned long *mode);
+			       unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
 	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
 				       bool carrier_ok, u32 ptys_eth_proto,
 				       struct ethtool_link_ksettings *cmd);
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
-	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp, u8 width,
+	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
 	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 41288144852d..aa13af0f33f0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -858,7 +858,7 @@ static int mlxsw_sp_port_get_sset_count(struct net_device *dev, int sset)
 
 static void
 mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
-				 u8 width, struct ethtool_link_ksettings *cmd)
+				 struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
 
@@ -869,13 +869,13 @@ mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
 	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 
 	ops->from_ptys_supported_port(mlxsw_sp, eth_proto_cap, cmd);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_cap, width,
+	ops->from_ptys_link(mlxsw_sp, eth_proto_cap,
 			    cmd->link_modes.supported);
 }
 
 static void
 mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
-				 u32 eth_proto_admin, bool autoneg, u8 width,
+				 u32 eth_proto_admin, bool autoneg,
 				 struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
@@ -886,7 +886,7 @@ mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
 		return;
 
 	ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_admin, width,
+	ops->from_ptys_link(mlxsw_sp, eth_proto_admin,
 			    cmd->link_modes.advertising);
 }
 
@@ -960,11 +960,9 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 	ops = mlxsw_sp->port_type_speed_ops;
 	autoneg = mlxsw_sp_port->link.autoneg;
 
-	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap,
-					 mlxsw_sp_port->mapping.width, cmd);
+	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap, cmd);
 
-	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg,
-					 mlxsw_sp_port->mapping.width, cmd);
+	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg, cmd);
 
 	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
@@ -997,8 +995,7 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
 	eth_proto_new = autoneg ?
-		ops->to_ptys_advert_link(mlxsw_sp, mlxsw_sp_port->mapping.width,
-					 cmd) :
+		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
 		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
 				   cmd->base.speed);
 
@@ -1200,7 +1197,7 @@ mlxsw_sp1_from_ptys_supported_port(struct mlxsw_sp *mlxsw_sp,
 
 static void
 mlxsw_sp1_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
+			 unsigned long *mode)
 {
 	int i;
 
@@ -1262,7 +1259,7 @@ static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_
 }
 
 static u32
-mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 			      const struct ethtool_link_ksettings *cmd)
 {
 	u32 ptys_proto = 0;
@@ -1621,14 +1618,12 @@ mlxsw_sp2_set_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
 
 static void
 mlxsw_sp2_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
+			 unsigned long *mode)
 {
-	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	int i;
 
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask)
 			mlxsw_sp2_set_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 						  mode);
 	}
@@ -1700,16 +1695,14 @@ mlxsw_sp2_test_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
 }
 
 static u32
-mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 			      const struct ethtool_link_ksettings *cmd)
 {
-	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	u32 ptys_proto = 0;
 	int i;
 
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((mask_width & mlxsw_sp2_port_link_mode[i].mask_width) &&
-		    mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
+		if (mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 					       cmd->link_modes.advertising))
 			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
 	}
-- 
2.26.2

