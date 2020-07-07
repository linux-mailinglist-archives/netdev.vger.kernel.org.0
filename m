Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246B72164CD
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 05:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgGGDns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 23:43:48 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:1472
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728070AbgGGDnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 23:43:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzd+zcub8BujdsTWRy9bs4tKQW2GZ4tsUgUmVSn7bkouvK6UiI/5pjLtAY0eVUhvdAIh3IKR+PoTzRyoT+OFIY4KL9fwozPhw9KuyPTEb8fAcGCLCOAqnWLYpgzGFfcelnitSktbgHrn8XTpU2R7+cNq1TKJY1nHq6LnE0zGHmOTjOaqgiyxDMouLG47QPqNMPSr0Wq0pV5n4khEM7A022PXNUmGuP1iZ4HGbcMrENtpMjuDGwocYWc5ZxVY2J1QZT+y7AhSazK26ZuQtqfxax/j6ZeszcHa2aUgVu9VQIq0lMzF+Bq05QoCjpuqu0VgoKc1a+FgV3p5gg4Jk6rmNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvHzEhgm2TMPscygbiSDCeUaX7Gix7N3InjmUIIG8NM=;
 b=ilc4l0rl7DWQBrWBdcnX6GcwvNjFpufbYPB5VcM5ehA8WAj1rJIk5ItgkIKAOYBUYWR0bUt4Y9UHJ2FTGfdaceYGyHwN+T1RqXxuLl9Y+n2AC7S1FWM64uuOCgA9tiIm5+Jz9LteLQdv+w4QU4cXxdm+VUDfkIIKePm01J1uUQuql3TthX3llgl36xMJOJF7bWCaL+TVExZV+4SCPBi5/e2wH3DHpB6AH9UYIfDSOVuPAhyraK4uzCuoJ/ZnTfbwfggRjvM68L6R2qpFDHjHgAhAACce92qgMTNPzZiZ6vSuNg39VaR0U/V3minoMge/wlDS5FUvxbdsCfKaPeUj2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvHzEhgm2TMPscygbiSDCeUaX7Gix7N3InjmUIIG8NM=;
 b=hn/d+mODcmtdAXdgNA9H00xjfePeN1rjlrnn+eX66BAe2UR6F4aZCyLnN5EKB5Qk6HUeYFR+q8fs1Npl0OVqIuX4idiXYYcuXqLWowky/JhpwVHTJb/7fmi5e5vYq2RIHQwvPLz0JmQ4wHqIEP5yHw8B6YU1fS7b76DirAPVH6U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Tue, 7 Jul
 2020 03:43:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 03:43:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next V2 2/2] net/mlx5: Added support for 100Gbps per lane link modes
Date:   Mon,  6 Jul 2020 20:42:33 -0700
Message-Id: <20200707034233.41122-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707034233.41122-1-saeedm@mellanox.com>
References: <20200707034233.41122-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:40::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0023.namprd04.prod.outlook.com (2603:10b6:a03:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Tue, 7 Jul 2020 03:43:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26378819-148a-4d26-04bc-08d82227de07
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5376E9FBFF78FA12AC688B34BE660@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rucPjeHAgOFcQ2NSbMg2BQdEJ40J+geA8GjlvFhvWqbQbCCA33KbjvmbtjbQ1GGk5EVqz2cJoO5FY8d0uBLHwkzOiSJLRei1HNHTmlB0VgVaPcGoFs72JdyNfTD0eOZVm2uqgkReCrVSJFLBRp2e3Iq8I7t99uYUFLKkRovclOlgSYc4XuxqKgOf9rqyvAND7xqvQir1PNOWCCcS5OeAisr/peDgn6uKzArlm3nN3E5njkSdWq56ZIJ8VRj6NBkdl0jE2bSlSfLtDsVnio0BB5RbCYxbVXQnJofAbGppJzYXs1ewQdphdxHaiI7ET3OfwO8M20Ud3S0UGcOsvQIPGj6SqXAzWi93dymrbCY9oiO49PE3bt0++0hm71lrwgNF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(110136005)(6486002)(54906003)(1076003)(6666004)(36756003)(8676002)(5660300002)(478600001)(8936002)(6506007)(956004)(2616005)(16526019)(83380400001)(52116002)(316002)(186003)(26005)(6512007)(4326008)(107886003)(66556008)(86362001)(66946007)(2906002)(66476007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: g7etfncX3ZweOB5BOG/XIc+onThX6dc7MypE+jSEObR4hgy/k88CyJA1fhvqtJUi/1i4rtq27zEbEDbA/0P/1ZwTL56OGIXYfBAUuh1ssc4dwsGdPTW45CZ+PORy2TvI36azreSSI4TspL942v0QEKuOKL6pj18mk0MOwyNKpjc28J6K2zNboMSnocwPiz3v1wF8Kab6xev9hL0IQu0wQKNvTP1Fe+Bx20CS2LX57fedeps4GtCyT9+BU/+ErmP8W4+tSCbLTgOhWfyBTTMcHdmYBOYVr3j0nOx8Re9PDahF0zMiBeKugiHkNn3GJIzwTrpJoen1FH1aAPKyamd3ulJXNuvKjtPJQ2EmY9NzgZYnKshq38+S8bwMzYDS3pPgRQdggOdMuj+Sqqrv6CN0qtVdrIswa4JbnVd3poJO5MFv2uDb+d0A8Q9eAQbCkT6aQ70ms6vo/DigNbgRqfjQUQwQ07kGxXJ2o4/xcExOHfQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26378819-148a-4d26-04bc-08d82227de07
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 03:43:09.9414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5RTiJrXsCYOBaK+c/4c/G32OW7iSSpKJfEY3xitvRLFKPVApzR0t86kSJYXcgOUlHWGMVYkKxc31e37LJsGYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

This patch exposes new link modes using 100Gbps per lane, including 100G,
200G and 400G modes.

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c |  3 +++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 21 ++++++++++++++++++-
 include/linux/mlx5/port.h                     |  3 +++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 2a8950b3056f..be83db63aca0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -76,6 +76,9 @@ static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODES_NUMBER] = {
 	[MLX5E_100GAUI_2_100GBASE_CR2_KR2]	= 100000,
 	[MLX5E_200GAUI_4_200GBASE_CR4_KR4]	= 200000,
 	[MLX5E_400GAUI_8]			= 400000,
+	[MLX5E_100GAUI_1_100GBASE_CR_KR]	= 100000,
+	[MLX5E_200GAUI_2_200GBASE_CR2_KR2]	= 200000,
+	[MLX5E_400GAUI_4_400GBASE_CR4_KR4]	= 400000,
 };
 
 static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ec5658bbe3c5..6183bee7d21b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -194,6 +194,24 @@ void mlx5e_build_ptys2ethtool_map(void)
 				       ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
 				       ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT,
 				       ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT);
+	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_100GAUI_1_100GBASE_CR_KR, ext,
+				       ETHTOOL_LINK_MODE_100000baseKR_Full_BIT,
+				       ETHTOOL_LINK_MODE_100000baseSR_Full_BIT,
+				       ETHTOOL_LINK_MODE_100000baseLR_ER_FR_Full_BIT,
+				       ETHTOOL_LINK_MODE_100000baseDR_Full_BIT,
+				       ETHTOOL_LINK_MODE_100000baseCR_Full_BIT);
+	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_200GAUI_2_200GBASE_CR2_KR2, ext,
+				       ETHTOOL_LINK_MODE_200000baseKR2_Full_BIT,
+				       ETHTOOL_LINK_MODE_200000baseSR2_Full_BIT,
+				       ETHTOOL_LINK_MODE_200000baseLR2_ER2_FR2_Full_BIT,
+				       ETHTOOL_LINK_MODE_200000baseDR2_Full_BIT,
+				       ETHTOOL_LINK_MODE_200000baseCR2_Full_BIT);
+	MLX5_BUILD_PTYS2ETHTOOL_CONFIG(MLX5E_400GAUI_4_400GBASE_CR4_KR4, ext,
+				       ETHTOOL_LINK_MODE_400000baseKR4_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseSR4_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT,
+				       ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT);
 }
 
 static void mlx5e_ethtool_get_speed_arr(struct mlx5_core_dev *mdev,
@@ -1012,7 +1030,8 @@ static u32 mlx5e_ethtool2ptys_ext_adver_link(const unsigned long *link_modes)
 	unsigned long modes[2];
 
 	for (i = 0; i < MLX5E_EXT_LINK_MODES_NUMBER; ++i) {
-		if (*ptys2ext_ethtool_table[i].advertised == 0)
+		if (ptys2ext_ethtool_table[i].advertised[0] == 0 &&
+		    ptys2ext_ethtool_table[i].advertised[1] == 0)
 			continue;
 		memset(modes, 0, sizeof(modes));
 		bitmap_and(modes, ptys2ext_ethtool_table[i].advertised,
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index de9a272c9f3d..2d45a6af52a4 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -104,8 +104,11 @@ enum mlx5e_ext_link_mode {
 	MLX5E_50GAUI_1_LAUI_1_50GBASE_CR_KR	= 8,
 	MLX5E_CAUI_4_100GBASE_CR4_KR4		= 9,
 	MLX5E_100GAUI_2_100GBASE_CR2_KR2	= 10,
+	MLX5E_100GAUI_1_100GBASE_CR_KR		= 11,
 	MLX5E_200GAUI_4_200GBASE_CR4_KR4	= 12,
+	MLX5E_200GAUI_2_200GBASE_CR2_KR2	= 13,
 	MLX5E_400GAUI_8				= 15,
+	MLX5E_400GAUI_4_400GBASE_CR4_KR4	= 16,
 	MLX5E_EXT_LINK_MODES_NUMBER,
 };
 
-- 
2.26.2

