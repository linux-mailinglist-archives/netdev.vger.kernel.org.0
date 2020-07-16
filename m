Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17F8222E09
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGPVdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:33:55 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgGPVdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:33:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0/RaAaO//w+TRZ66KiNVsI6YerVLkIW91qi0Oh6sPXLtap0+aBglJhk0DQRW4Qx+jQYQ6XMV5mwAQHejqgVyeRsoxxho53P1GgwdSYA1I3KJo/CXrrxWjm3/B2fxndtHqRrO6tpM1umnVXRSwP33Hhc1HYzBNuHSGFtM4Qf5EiExmgPtEj79b++fvC5Vuj3KW7pAsx1/3wpjLfu3lJZz4YHb5/ulRgMFoo4MW8Hw8HfNmgAQ3vnqN335tuVWxPYWklWu71RWdQvKscnlDQZJBmKIG5X7bgxUr12ptUSduGObDLVpJlOcANKRKYbMfYk0E8FNxSP+uNVvLMgWRxzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGFxfmXxQYdlSByzJoTKQitny8n1eQS4MB19oJFDY40=;
 b=RrAC9ASnh/jL/MwcYhEvnbBOHrCKpZRXeI8d0WX9ov2xZGLuCWnkxFaHwcdG2jwPp2P3f2/y1hFH9sbOG29vjsQyRxzFHhP/Bqal0DV/Xu3hGVg5+OYk92dtNPp31gFztPuyIuWSjNevG/Sbxj+dNSwHIgmwrA/LrOlGC75GyPSNQNrNAKhDT/XhfBePhiZKxCq4IeBZcMGBJaSCJFKqyHsd+RYugUcuvvHTYYCcPPsNrnR0zV84p8BAMycAWTYYIAYhgbbfVr9E61/B0JL4ackOg5i1kSsx79NIpivt/+7qeNwr51V5ipuP7cRO3N3A/lHecbAfK6JEZekA1G5VSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGFxfmXxQYdlSByzJoTKQitny8n1eQS4MB19oJFDY40=;
 b=I4NhXsjowSW5I60zV9Z0oZlBpQohgkkrmHr4FJoS9j56c7xYeOdaC749zMCuHMr2uKmtdKpre8/7mlyhkoFQw0Jyh44fEtGamcvuVeoCxWx6W3YN/IUvdZLdZZKpSOMlP6ma1yvhh0wKS1pBp2O0dsQUTIISA1sEJTLinEDJ6/4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:33:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:33:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/15] net/mlx5: Make MLX5_EN_TLS non-prompt
Date:   Thu, 16 Jul 2020 14:33:09 -0700
Message-Id: <20200716213321.29468-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:33:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: edcdef60-35e3-48f3-b12b-08d829cfecaf
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2992C5CEBBE65732D9137B82BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zl3VhU/UlBXRUEIJFCtynXDvcqFR5PKbA1GJhFj8/7vAMhqGBwxJJEeJ8oxBvZhFz8jiQLsQ5gHxLe9mlJbLBNVADw1OqESjzcWnmsenAiMFIYBfp44lkrO+iz+Mr9fH60Q8dIhmlefWFpkJpc6XwkI7aAn9BwEfX5LTOQEo5fxX9o3hgJOok00e/4astmoRg4k99U78Iwx7ZxjxJEHTaY1MnvATNGcsmOiLtDXzP9/MrivwwB7FnW9BfM62oXNhzzSSBwGPsiY3KFd2wgNwF0bf4uiNCxi7OHrWeU6rc6ygq1NKTYEbBMVt+II4PLy8vMk1h+0/jNGqfbbBIxUO2N6W8A6arZOJJiFaMj5gEMeY3HqULpqyoXmo+lzkYazI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Xd3GHBwGOhu7++aJc/iTFTW8DeVJzFZCw8cXT1UViShYTkc0Wa/7U2A86+BNLgyR7jTsqbZm08r/rC+6cOFtqDYeDzWpuHdm8mtV5aAi3lxQw5icPWHHrilIgRIsI4ICDgxWbPLJz5ipm/zk08Y7rxe/QG1YFicnBTxh3g4h8yoFcrd/FlEzlk5R/Jw9OHE6VZuKf7GhiqCMGJ4uFHQR9AQXbljeWpA13bPE3xvWNvmbYdzHs+rlwo0ez5JZHe3GT7WIGNOwJS5Ee8rlqrd3zMrxZ7IuJTS8H1shDLaEz3vJfxzDkwQI7NT68MkdwMUo6sp30vXwQFYHL4axCSF/HyhACuFyFfWbHznS4oOlI7gckbRTBEVOpVw8f34jUFU3zXQOGUJf2TKTIjn58SYU0ttcHS/RUd1ZYWiP5GKbB8IuZGxImerfnzBfReB+QFaIJMT33+csXLRfcvzJbZiIqO015yhYt/+u1DGjUGA0eck=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edcdef60-35e3-48f3-b12b-08d829cfecaf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:33:48.0700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBV3CszUdSoPFxo1CkJUGZ1wj/NJIldfcuk/+YBustVBgl91L4l5gbmtTLbmgcZP2iA++oGBIQNgdPHOl42eQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

TLS runs only over Eth, and the Eth driver is the only user of
the core TLS functionality.
There is no meaning of having the core functionality without the usage
in Eth driver.
Hence, let both TLS core implementations depend on MLX5_CORE_EN,
and select MLX5_EN_TLS.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 76b39659c39b2..7d7148c9b7440 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -150,7 +150,10 @@ config MLX5_FPGA_TLS
 	bool "Mellanox Technologies TLS Innova support"
 	depends on TLS_DEVICE
 	depends on TLS=y || MLX5_CORE=m
+	depends on MLX5_CORE_EN
 	depends on MLX5_FPGA
+	depends on XPS
+	select MLX5_EN_TLS
 	default n
 	help
 	Build TLS support for the Innova family of network cards by Mellanox
@@ -161,21 +164,19 @@ config MLX5_FPGA_TLS
 
 config MLX5_TLS
 	bool "Mellanox Technologies TLS Connect-X support"
-	depends on MLX5_CORE_EN
 	depends on TLS_DEVICE
 	depends on TLS=y || MLX5_CORE=m
+	depends on MLX5_CORE_EN
+	depends on XPS
 	select MLX5_ACCEL
+	select MLX5_EN_TLS
 	default n
 	help
 	Build TLS support for the Connect-X family of network cards by Mellanox
 	Technologies.
 
 config MLX5_EN_TLS
-	bool "TLS cryptography-offload accelaration"
-	depends on MLX5_CORE_EN
-	depends on XPS
-	depends on MLX5_FPGA_TLS || MLX5_TLS
-	default y
+	bool
 	help
 	Build support for TLS cryptography-offload accelaration in the NIC.
 	Note: Support for hardware with this capability needs to be selected
-- 
2.26.2

