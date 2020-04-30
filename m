Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050821C0B08
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgD3Xlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:41:37 -0400
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:34525
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726384AbgD3Xlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 19:41:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYqIoSLZylin6547Ch034vuLCl2CcdFF943pSm0OTSPzxmefUctsVZ1c3oSw86CaVSo7zv0FlhRxhMfVib8dAlSkgkK9SWV5XU8LFY/ND2cWZ9qa6i0V6NWm6pUwAg+XUDOvlEnscyNWidh2AMwDd2cSjkhm+e+cFgnQc83KQySMafwOvmXqyF/4EOe8MmiaMTxaDe7TukDPtUg+6rM8DJa0i2y83mfigsKe07FHHRBWTPiUfpjNvJ/RrL5kdVGTVh9fbsopAIcsIuxRnTSpbSLQvVxVLwitJMxqKR8GFRdOhldSkOfVI9sxSWYprPDHEhQT0R5swBbllGobgxHd9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7K0u7QbHVHbs6d+NZlab9tcWwraA7zmc5VNZLKzTyE=;
 b=QJ+zc4ewGYC/cUtrdeF17J1f4xehe55TG/kj8R34vW7qhXZDYiAvPJprL3aXwJ/6aTBr+LT5EjxDh8WVXaHvRxLAsnYGrw+jIrLKWgQIdM5D6g5VUlCceu6Li0Zm59QN9VPHvqcRGTyrwG2WnFYQMfCXm9w2YkNNy5nj/c3udFIbd5AkaN7TdmZguKUS4oTCMrZUxdI1nVytgVugnoR7IddfJ88ThQhMgyn9kLjr7QS+sSW2MY53rmlvP/78CUiMwuacD+MYThcyJOjh6322JWEHiSKa2YCMMMo8yQJU2V/XamkP+MlBVULyaf1UNkDddMw1x/Cqubz86RfnkN864g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7K0u7QbHVHbs6d+NZlab9tcWwraA7zmc5VNZLKzTyE=;
 b=HDMTgn3H7v5cZi7/F7UtaOBnBDF3vmy7PyFBKc1InCLnozL+zet7Grnfim9ZmN4L36xeb00csWR0PxqE/Jl4QLnwCf3acRX4mRz82n9iUgfdPMAqMlaBjKiDqW/V2YGoeUriajvw+Aqwvf6Y3A1y08wxV7DI9c0lzCr0MKjg9O8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3230.eurprd05.prod.outlook.com (2603:10a6:802:1b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 23:41:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 23:41:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 2/2] net/mlx5: Added support for 100Gbps per lane link modes
Date:   Thu, 30 Apr 2020 16:41:06 -0700
Message-Id: <20200430234106.52732-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430234106.52732-1-saeedm@mellanox.com>
References: <20200430234106.52732-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0026.namprd17.prod.outlook.com (2603:10b6:a03:1b8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 23:41:27 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e89c8bb1-b81c-444f-e37b-08d7ed600154
X-MS-TrafficTypeDiagnostic: VI1PR05MB3230:|VI1PR05MB3230:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB323079591FD312493D409456BEAA0@VI1PR05MB3230.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(36756003)(186003)(26005)(6506007)(2616005)(956004)(5660300002)(52116002)(316002)(1076003)(478600001)(16526019)(6666004)(6486002)(2906002)(6512007)(86362001)(4326008)(54906003)(8676002)(66946007)(107886003)(66556008)(66476007)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+I9jaWVM9l3Bgx6VVD8jwzLesmFEHbdGrE9jGwIaubf/jN5GKvxBj1ZZmLVtaW+yZ+j5CvoRt84cVwzy7owtH4llurtMYO5DdPvc5+mrIQReawbydi5QHknEPya0FaNKhodPttemR3smQbgXH7zoWR8G0Yf90eIfRu71OAIdsTxAErUPxb+10FZcG5JRJZrSnrHA7xnD6zAqYWIx+9rWGCN9YUezLpQfHlumCen1SO62yjOIOsIYNsqd4b2qmbnh9zDvQ83myQhq6q9AfmtnNTIEuwaWFsmELQY+0ugdwSFvk4y9yDYkFwK1WzUeYFgHj50EH/qwN9U1DWB7k/KcQtkqzfxf9dhs/kHbSeGGT97F8wIqHZbY1niD/KJdivpL46USRjoLh0iRWJE63waQT62/mVThqiT3fTw/jwGGb2aGzpruq/rQ4Zx7l0MO2U49Ng6nEW+6uGK+QUMuYtBpOkx1cYeMiSE3MghasavGst2ta+M9HkV2fe84/hHFSiQ
X-MS-Exchange-AntiSpam-MessageData: 00aTF6nQVq6ftSjbrTtSysew/05QIIgTcMKpeqzaC6Fy/kOfK1D9GN8mIyoYjCdcXdHbuKGbTA5ZJYXF1VKiNTHxLmOejjQzPqe1t43MuaLR2FGi9vk0c/u4WdB9B33MnrsC3PQfo7UcChsGMgMR9gWnXaISp9AWrwYT5LMg4B3CZ6vDC/KLOg5CoHXdv7EWmp2zcgAbfhkk7Lq3WT1hgNh5LqSWMhJPvMWbDkmJQTFJywRu0ssVVUdhJxqjtcvglQ/VyNS4OG+EaBlnG952hq2LzpWB8Z8bIpy0f55WbWFaqUG8hXE4skugZ88nNLO2qGHlztYzfB2VCeYAW9s5xfERIIeu7HYLthdsKgaAEpjx8P9kS9ksLbE+IA5qQrv8ViyywY+3q6PIzIlYmJa0ICJJqcDnDeEEQk1gxWDZ6pir2YGpQg/5Jcqh6Sqk1yGYL0ZCOBgrY4UXkAHV2j0fuN7/CQBAOKnHlZ/2ceedgT2JJpstwB5YfZyJwvOThGeqZwTi8K3RjTs74HHjV+CfWaOtoLNMZ050xt2FbyxMcQW32GstB57m61VWauISc+50H3T1a8aJbum6Jvp6NiDWlzccrnGcsWL8MxevKC07ZOiw5VwZxKbmt0FSD8lU7OpEPStc5cefLnAh1e7Jg/dw4CHvl9RDMKJx22v90ElHyPDkRfHkQTf3Oiv/bGLUTvbgNr7NxcEjBgc7z8GFs4bJXwjLrnpl7bnrzODrrk7aOzdOr1w6ikRWjLLKxTyynMzlVl/zaz8/YGPOP9Y0wMhU+Qgqq6T1VWPv+dkegL7F/0o=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89c8bb1-b81c-444f-e37b-08d7ed600154
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 23:41:29.2827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWYkHHZ+MHdW0ZZQspk/0i6ITqYU5MOi1y2wUTOOAIMLZ+tPO2Bfw2K5kdtSCfpPqJcOVPV4T7U8WIrUjKGPXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3230
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
index 2c4a670c8ffd..7747b32c1565 100644
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
index 0279bb7246e1..a03bb4145ddb 100644
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
@@ -997,7 +1015,8 @@ static u32 mlx5e_ethtool2ptys_ext_adver_link(const unsigned long *link_modes)
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
2.25.4

