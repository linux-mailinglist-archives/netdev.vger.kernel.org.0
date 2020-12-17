Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337A22DCDF8
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgLQI64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:58:56 -0500
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:50264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727304AbgLQI64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:58:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHiRF19AgTdFEZpTPOLYVKeKWL9VAo5Beih7//w0BrN7qZTaCMZzIwaePe+QvMIiO2Xl8M4lOkdzGOEVqcNJxdMAgAeePEp82oXpKn6MtydYSe948d2gGy0PvkMc1sjiRBxPMeuct1GrX47WwVtnrSRXbcNIWzbDDzRZe/nb8a+n3Y9a3BnXGj2PKLWrDd72aZF7cuiqr7LQr/lnnTvpDlUmCQ6UpVDKfr8YRkhwJ+InThdvBlQj1sB0rFrzNfVRN38IRKyCUWsfPLxxdFadOxaMtjdaSBqU4g3Pt0BECb7XNpdpA9G/s+Cwylbe/GyHyXvbERjWi3H7WvvCODpW4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7A8m25TdcNQabDGe6DusymhCIc7ZHOJLrf3nn56WWSE=;
 b=aM0cx00v71GPvuo8YhN4EiyRkw5eO1IqJu1EHkF4AYHoGtpxOrDz8ajHLWljGQ5puVU3yd+bXR6KsF2215h7b0XMWNiMMrpm7Dc4D3UVAadyZqpXX8OvWYqGbJ3lLtLwQQYH2SGV5SFWoNE4+1ztcpNNtb50USg9Xabta/LeITawrek6eLloUHbvEJc9JfNzjitfYCUDu7cc2b0kymfY8OpqIDeb6JeheIz8fM/p+emUzJD41gYxHmIvkE6FqtTjYM0OuWuqq3V9F3cgu7UCM368dsB37+UX/PDFEfUFmGwRVr5aRRCcmRA7Yew1UnE0W9V27qnBcDQqEAHpDpL6og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7A8m25TdcNQabDGe6DusymhCIc7ZHOJLrf3nn56WWSE=;
 b=GDQHt+0zowgCFRelyXMWdYn3Mkau0VK6KWth9rkxmep0AVAa0CVj/uWw5grKiQBkcUGHqCh3vi8UVRUO2snNxi0z3LM9s6Oq9xonWz9cg6xhvpJJPg4N54sL3IiEpL3jcvwhiTHHohZXMwI7rqsKQs9dN9Hy/WIVNGl7miWWhmM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:36 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:36 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 4/7] mlxsw: ethtool: Remove max lanes filtering
Date:   Thu, 17 Dec 2020 10:57:14 +0200
Message-Id: <20201217085717.4081793-5-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 867b1e36-c6c3-4a58-4a31-08d8a269cc91
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6674B72CD5B45F7FA4789E3FD5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CrEzkMCo21EEPhbkrmJe+v4nHNrDRLXOT6znSyZ8VUvW9ect/LkZwZek5PCTXLYKC2f1C96YJmgc6ZkTnn/41n0dKccAlTUfZZKJy8UraYJfdUMUY6PNDk00rxRJWIaGYZNaerafDIIT9jsFS4rNK5Q8OTava+tIN9eD0f6vGBKY12qTTVEo1l9blR3/QHkFXhlbVj6W7ldhZhGPtIs0/FL4TrTi34O55YXA8rgay+1P2qLX0KKWkpJrYg6tIiEZVv3WL+XSxwfy7YxwVctGfdhWzs+WDx0HofqGnvBk5qQV3Rj04Go/5xy6b+rkpquY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xBcmRAX6Tm4Qr/+1U9XWEPKjTobGUKhUXkSDR0Gug3GEvKSeN7wyX6zTSmmO?=
 =?us-ascii?Q?vWo88s3Tfxhae3iaBZ/XzLrYUQK2ho60eVfuOEahAtgPuLUHXHGfWiBUQRd0?=
 =?us-ascii?Q?7nvtiAdZaexdaSd8ZE+hnDjpUAThfl88WSbre+WUJFlW7t8p2KpgtOnzNTEB?=
 =?us-ascii?Q?MpxTSB/ZnHIWXwap7Sx2lwwlpghQk74F5Trfcf29hm0MUB2v5hIAIV1nPMV/?=
 =?us-ascii?Q?M6O/1Q8VhIDF0b1PNKQl83oxGvstfNlxVxVz0bHozkjN5jbeCVViuwfjS9aE?=
 =?us-ascii?Q?nC2yJiKXz7tfsojxwWo2YYMOMbgQRG3M+YOO2dWFioaE4rlH1aUxEVNce9Bx?=
 =?us-ascii?Q?RQZUjfk5xWXP/dFFgFfGHLRGbCO8bdwzg656WoIRvVszyIyWJsNLXTmBuwMA?=
 =?us-ascii?Q?3w4Rnh3GphOsn7ck2qKJ3ljpsDiLhwFE8nqc15D0DruBvA9OpS4q8UjFNX9B?=
 =?us-ascii?Q?wo4AiEK45SW/dCBcAb6+W1OJSPOIuOR/8Ovz5n0Z3gsiP8rQ4l58ZkzGPfQC?=
 =?us-ascii?Q?H0fRHksNsJsJWj4GdhvpmdHPy54NszO5pciBY4cZsMXTwnQ1MN+APoOPgFu9?=
 =?us-ascii?Q?G6+LJ2QclsZJE/AtkQ/ohQMLE0VuCrM+cWForTjIpFHKgx4Gs/jtcScPkNxw?=
 =?us-ascii?Q?EqSi9daEnlsshoPg8ZjQzLk9x1vRckz/F+YpZHm6auFt2i4GGU6dE1OxF3jF?=
 =?us-ascii?Q?shE4G2L14Qv7aVrcN7AeP3Aq1uC+K0oYnMVqiqGgEFbhFs27ARkOia3UjH7N?=
 =?us-ascii?Q?EoIeTIrmNq8FEo8p1IrcpIH3EAiJcquDlHcv9NB0ldeCkOP2thGt0hr5cW/e?=
 =?us-ascii?Q?o+2yhhfBXF99eBj0PGaGrDB4x58MISd1A5gd6plS6amkOMTkQ6HillvC+zo/?=
 =?us-ascii?Q?ptQHLxPzpYdMQsrYNvMiV11RUJ2DUU2Q/61AUAdH7Vw6q7tDrEfd6C+QYghk?=
 =?us-ascii?Q?d7pTm8djf78VqcQk30Pe2HgF+Ndwnp0qog3FEVmdbWeVlEnc6bex1D0HlFCe?=
 =?us-ascii?Q?XsZb?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:35.9015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 867b1e36-c6c3-4a58-4a31-08d8a269cc91
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hjPhPniJ7hiWBt4X9QDI98vdzjtk41lBSW1VjCRbRDrZnPrygLQ2YX+kcaPKoaOfFCYcgz0k/CZ6r/V06/i7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
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

