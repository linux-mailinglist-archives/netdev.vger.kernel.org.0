Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7221AD3FE
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 03:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgDQBNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 21:13:00 -0400
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:6126
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725858AbgDQBM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 21:12:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJbsQ0l3p051Ye9x4t1UjKMjAc5d3+A1NfMpmw8DN83RCNTYaaEtmIsewY4G9LHm9TDAjb3kGYReDZ5y/WedvH5yvoZmfhrc5Wglkvy9zP7Ym0RaIU8peVSzD4IEMFEAxWtFFVpk5Xq8INFN0sQy1vSbsO4Pj+BY7fiEwvzfupuPoZP2Re6lFWDWdq8YoWA9J0wqhRgbUq7oN8XDxhrwZS3QXFz4eZFnN4lHu/0VUGqHv0TWqRdsSXQ0i+n8WuwLCTcQSuUDmR1aGt5A2Bo6I/F0K43H6vP5oWr2GVBLdHHfUaYvzHMoJeg9WD8zTseKcWMZ2rIcnqBu6+uvmw9G7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3908gRRsC5R9RqEQI8MM5RiPxynAWTWtPIBrXz1wJWk=;
 b=YQckjWxHge8oBoaAYfn0vBvpivCTy6sc/XahlXBhbUCDnZIWWQef0I6X+ybyiWhOOrheM5RVTgFXO1H1/y2qEGS9NWObib5tK8C0zNZaFpb6FJFwNZ7KK8iBJe7hvTlUGq1qBEuQ+Sm0hebPv7y0JAB1n1UM2UVyszg4+t++JWVuU4V9ne055T0LQwOAisaxST+1kHoM7r5zsaQNeTo+5HY8FZrz3xcnMrdSa/IGMzIS/7xJvbEI7/P/KWrITxtfgvKHsTcboHdqyZIWznoB1WpcLW/fzzIuZYsW12QwEHEYFbaoTeuho0rIE6r0N2KTnVJBomYiafsvDcl4dEfBEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3908gRRsC5R9RqEQI8MM5RiPxynAWTWtPIBrXz1wJWk=;
 b=dB3/qAoNjnX8YlylwgpIfNLVDbGcBo2hV3aTTiUBjkwkCpIfVN7e12zsPrGabL9A6yzVvsYIrlhyMnkc0+/b7SDdqvvPHVvvNYXi3p8sszPV25cSy/+cd6RzijXfn710rDgt0xNVyZ6paR5MP8UjQp2jVMmBcm8dCfH5D4Cz43g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6237.eurprd05.prod.outlook.com (2603:10a6:803:d8::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Fri, 17 Apr
 2020 01:12:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 01:12:25 +0000
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
Subject: [RFC PATCH 2/2] net/mlx5: Kconfig: Use "uses" instead of "imply"
Date:   Thu, 16 Apr 2020 18:11:46 -0700
Message-Id: <20200417011146.83973-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417011146.83973-1-saeedm@mellanox.com>
References: <20200417011146.83973-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0041.namprd08.prod.outlook.com
 (2603:10b6:a03:117::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0041.namprd08.prod.outlook.com (2603:10b6:a03:117::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Fri, 17 Apr 2020 01:12:20 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4ee7aa6-cbbe-49a3-a6c2-08d7e26c6323
X-MS-TrafficTypeDiagnostic: VI1PR05MB6237:|VI1PR05MB6237:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB62372DB416DADE4CDA71F651BED90@VI1PR05MB6237.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0376ECF4DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(4326008)(6512007)(316002)(66556008)(6666004)(86362001)(54906003)(26005)(66476007)(7416002)(6486002)(478600001)(36756003)(186003)(1076003)(2906002)(5660300002)(52116002)(16526019)(66946007)(8676002)(956004)(81156014)(6506007)(8936002)(2616005)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ZZi2itoorU+FjfkQ51ifIfclORohYCnaL+KT9PoN3gS3Sn6cpXdVkN0iFT/z0xMQesLRAezWRWQ28twNcN2UUczOsHvxVejwn0VS74RSbYeTBd20arGIelCKObllbrwkIDXGORGJRLaEmRDhjxFSjO1cigAl3TyQqIY0rN4tb3QdGxsTadgGxfYslpphB4CDX4kLZbsMFwh75H8gu/KxNysJkxX9EvHQQcTIfdutTXJm/Revxgy4qzuKj+gSMr4PVM4tADlEPVyY9izsrh0jK14y+YKEXIv39zyXnUCZot67vn2CMvblKWYhCpCV/VL66ceb4dnAnjcNIz1QtE7a1etQUCpVc4LYWaZLs1mMru28vnM/JbTmPimYgrdRhVdU3x311ZMQEg2UHdbcF8JxH0V0QmvyqZANPbO+RFFrYHsfOhZ0vsR7BuZyb/ZIm/CfEUazjPtFuTwMcjvkn/EkRIfdfer9Mto/j7k1OTQMhnY0NF59DNAzZwSEWm0P65i
X-MS-Exchange-AntiSpam-MessageData: 83eFyu1R4fO+7UjyGhuYTL+4SAOzkjBJ3W0fnpk2q0AS8znOOBsVyYWLdWCwJMpv4VbOhaRcTMkrGBSNztqLT98hqNrvw9VMgkERQNqAHj4k6CU/x9ebZcpjdeg5G9y+FhSakdYLhdOtMCFz4feDBw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ee7aa6-cbbe-49a3-a6c2-08d7e26c6323
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2020 01:12:24.9257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQNpT4GCQKc9lSZiHR0L9f1wD1MN/nCT25Px1aPKByhl6epZ/uFZBI+jWK3X48wm9SkjeTEWCY7hZiQAvQXN9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6237
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

