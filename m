Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCA11AE67D
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbgDQUHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:07:32 -0400
Received: from mail-db8eur05on2064.outbound.protection.outlook.com ([40.107.20.64]:22465
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730573AbgDQUHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 16:07:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgEJtOvxnXUWaGknGpIyuK2GttzAIx5SPyelQD49VfKE6LgwUKQF9tM4KqPnFDJuvzR46NtS4119iGNPD/vLjgNLTHAcvtHouUaFE1qnArG9x9+x1xYOBvMyC1MXqEamYHwxuqEpZOoduq+JmCQonVTI7bKg5Dr+0/l1k47whJRi3uaaPrCukdSMK+fp/zRjEkbpiXVgsnHw+Nc8+3TM9vP5PI1dihgLN/v3PaVJA2UTGbhlYY+Jmif/KPMErlRSDmgEHGCEiQ5M/YymIxrAaguhsOq85tAqd/VRV328P2OSv7+s3pkXzsoweY7W8qs7rSNN8TLJMPGkcwEV0eC/Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3908gRRsC5R9RqEQI8MM5RiPxynAWTWtPIBrXz1wJWk=;
 b=Zn+BJ9KQL8SYTWfdYHkrgE12dtYMOxw/zvwAJZpGb7KvT/QQRCJb3IPg11U7dqHc2FpMRZx9hmGibXQs4izWFSC7W9yLQB9OySZlSRfXVo5NzdG+0TyGdmN1tABuAxj5i1xAiSnq3LBizJN4n7cENyUiLM4oMr9pXUUI8iCYa+ZQcncWmChbc5mX6zvDopxEZn6TsnfJmzzViqtQxQYQoGpBNVLfvnPazRNc67erVBHelW5G9cSnBk/ZIUZ/8BgWHJsyP5Y4BjthAmz53V2F9Vn9Pu3kwbYukQH7f2Qp/z8gL2K8vr+s2MPBxHiGXcLh5J7CSvoNrGgo/yVvsTohJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3908gRRsC5R9RqEQI8MM5RiPxynAWTWtPIBrXz1wJWk=;
 b=rdC0hQcgRWw4dz8VhiEPGhtMH+KkHaIfR2Pgxg7cPwjhGDbAqnNLMVt1jqFitrUiFWFhrq0XJdScKTpSx5Z7cwL2vngO+EnK0xEbkW3Gfk3f+2M7QxI7qbKIi3wqMx3FAouijqL6HlblW/JuUVE1ZGUhU640NvX5DMMzvaN1Oko=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5917.eurprd05.prod.outlook.com (2603:10a6:803:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Fri, 17 Apr
 2020 20:07:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 20:07:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, leon@kernel.org,
        kieran.bingham+renesas@ideasonboard.com, jonas@kwiboo.se,
        airlied@linux.ie, jernej.skrabec@siol.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [RFC PATCH v2 2/3] net/mlx5: Kconfig: Use "uses" instead of "imply"
Date:   Fri, 17 Apr 2020 13:06:26 -0700
Message-Id: <20200417200627.129849-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417200627.129849-1-saeedm@mellanox.com>
References: <20200417200627.129849-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0100.namprd05.prod.outlook.com (2603:10b6:a03:e0::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.9 via Frontend Transport; Fri, 17 Apr 2020 20:07:16 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ca60097-47bd-42a9-26f5-08d7e30aef7a
X-MS-TrafficTypeDiagnostic: VI1PR05MB5917:|VI1PR05MB5917:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB59178BB6344455EC2998AFF4BED90@VI1PR05MB5917.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0376ECF4DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(8676002)(7416002)(26005)(6666004)(478600001)(86362001)(2906002)(81156014)(52116002)(4326008)(186003)(16526019)(36756003)(956004)(5660300002)(2616005)(54906003)(1076003)(316002)(66556008)(66946007)(66476007)(6506007)(8936002)(6512007)(6486002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iPrsCS+xugKoS+uaQFiTSqazaSneRuNv6rAFOIObpnw16/D0lsfag5EHIi2Fi4yOrH5+M0uAIo24ieTkbga0KTT7GxzbouREsJHDngXuWqNPe+l31MmSUAiA/0VomLwt8RRFb4Aa7CYzcAIoxnfSvRjp2zSiI91zMXzztAvUCZZ7m/WngGkEg6pVId9sDbn0Dhhw2DVvbsivX0+zr5ivb/fy8PIJASmAdi5HSItQYkufOgoHkqcZKEofd7o2xZSQC7UI0mFpIdAa2DsXKrvS/o1w+72f7/PQFtgIH8+CFKLa0bd2QwV/5+bTamOginSaKTJdBY1eYsUIM3TjACM4OrL4JD+BAu1Uvh8ZHYpdCzWYT9WB7tPRq/GyjmJp+OEjmvXV2dZpES5OeT6hXjbU1CR+ryHYREkZ/qrlpj8QTwxQ2N+HluTzVvBODm2INYluzwLCNwolj3GtDviE2WQSlVW3BafLr7sxa2nowhcdt6bhjhVtv0X/57NiH205GBnX
X-MS-Exchange-AntiSpam-MessageData: IDcgVRMv//CkG54PgH6arEiHj3shCNndeRNwPRC+XCGNP0GQRtNAg2m8lx+aGc5v4Js9vgTh3UBVivavMTR0uHOx6NlgZVkn1nFQzKRX58M7xu1wLbGRoGzaIomFTpEenLBKMhAezm+fqyyaq5DrPg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca60097-47bd-42a9-26f5-08d7e30aef7a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2020 20:07:26.1331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQcRvPXlFaRMnbHCUN537ZvM8GgQgIyTBZwV9bVpNP1fotuMD+9ts1ut2kOp/L8ECR5idYXBfii7ZF/y0Yscgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5917
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5 uses the imply keyword to force weak dependencies on the implied
modules, to make sure they are always reachable by mlx5.

"imply" doesn't work this way any more, and it was wrong to use it in
first place.

The right solution is to use: "depends on symbol || !symbol", which is
exactly what the uses keyword is there for.

Use the new "uses" keyword to replace all mlx5 implied dependencies.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 312e0a1ad43d..4e07179217e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -7,10 +7,10 @@ config MLX5_CORE
 	tristate "Mellanox 5th generation network adapters (ConnectX series) core driver"
 	depends on PCI
 	select NET_DEVLINK
-	imply PTP_1588_CLOCK
-	imply VXLAN
-	imply MLXFW
-	imply PCI_HYPERV_INTERFACE
+	uses PTP_1588_CLOCK
+	uses VXLAN
+	uses MLXFW
+	uses PCI_HYPERV_INTERFACE
 	default n
 	---help---
 	  Core driver for low level functionality of the ConnectX-4 and
-- 
2.25.2

