Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320D7222FA6
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgGQAEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:04:55 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:58740
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbgGQAEv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYlq0m3HBDC8QvYRvFz72iyCETP44m7PEYv29DFTRXeIHYOzKwOWTMZixU2NC34tFM45zXFSMWzsjjdC3zFseOHOqHPAdiKjXgOhEE2GYUIjBAVuAlqPirceaH3m89CxUTVlJD6yMXqazbqXoKlzotJ5Bt7cBNtCRZbZ/ZRVW2gnSszxBsFOVBKwoaV8s8GATHmNSaxZzEAuJb5KwQJiQz2ONtX4b6ZUhe+oSDipizs5sCHHY/XaLFpu6zpruHD/3Vj45Y7+8I44sAPuRr+3sMaO1sPRMiOYKewTDq3B0kYmRdTLXaoFI5+eWTxZi1JSiMnloNs/QqeThnTpFESZfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGFxfmXxQYdlSByzJoTKQitny8n1eQS4MB19oJFDY40=;
 b=cho0t0TqH6MmWhp0+PC2weHFDgkl+gm/7vsrwnQ5YGaEDPaAOLaFnkETWlw48hKiGh5QWMEIXInqw+zNAtUJJ9BXXrwp2r1HLWnKtoctkliDlSd0MgrrVxEnQopAtlxnnUN+FtQw+VzzNo5Zq699bdZETA7uLLhHCJGeGIqoaeStXmtOjIN4wW1fiyBv8/fdMCgMN9AH2pK1b1lB/NvM9G1d5UAKXMcqKX6CJUfmLqggl4DCS29WsLk+sJdMUeLKnPa4AM3ruLk6xDqnidZkHtU5JfWqDtUhrHIw6wb5dO/M8rZFbSyH1D4zQnsBQIGxsubPoopPVid2SFy9Ld60Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGFxfmXxQYdlSByzJoTKQitny8n1eQS4MB19oJFDY40=;
 b=kpoxhD0guRoPkBucRUdv8n88ENTy3Gdooe6sNYYLQWR1oUEe9YT3DXf85VLWr1L0kcRumKoM8A4xD/1+1zLm88JksxiJ9AjOaqAua0GHyFfPrAV5YlQ90CSL8HdyWkycl8WWiFgEwNp6QnDD21Y39RCbRKp0/rPHhZ8tByQ0DIA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 03/15] net/mlx5: Make MLX5_EN_TLS non-prompt
Date:   Thu, 16 Jul 2020 17:03:58 -0700
Message-Id: <20200717000410.55600-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:35 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b6b2d86e-bc6c-499b-1d53-08d829e4fec0
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244898CBE64F298B2356595DBE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3adzjfm7n1ny1lSo0JL3davWDshk3PUU9Chybwx5uazcSIm3QoeSVN8N3alBYlAxAjXz1WSslPm1tmM8egpQB0DPgeDR2MZ4yqiMdve5WGVAogOIzUJw3mLKzFD8nVp1TIS2es5/wfL+Bp0rbEHuqkCEJRHE2eH6Zct03EQXNmJqEAz0x6p1rZQxx3BcfzksWbZmnkKaKa44UnrbTcPyLc2nMnDHy4bEnDgwTa17ogLesJipxaUmb1Flq5aOn4DXsZnfAM6hUR38DnUc4MDjRUsfCde6e0uX8nnuqU6m+eI69TTMVk590ml9xM+wUHEvmSxlCXTSlnpdgi3PO+cSk1sgWswXnMBwU579+lBIDn6oPwoz/XbngGrNilYip+Bp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c71J0n8TE9hJ1OpqCFJTYgAhGo7InrL7SGeMKhHJs2lhnUJq8s7JduqeEv8PpMm2C1RxMKXOGaQ462oGWgUwiWPipJR+VsJ8o6ARvfPx5S9c+cC9AaJjgW1XxIotk8SsAeBzrs3ZBWqvEeIXhmXoq0CxpARG99HeO3gjKXiTGoDr2UjiTXa6B623E+P3Rql9V1ZVtVha8Z5iEAYNBEbucCCBGtFIV0TjOgyx+m9dqguieW/+MTADvssKIy/Zl+txy5lNFSFUJkFHDbvG7uEguzqIfDUtY1Z6CdE5oYeMT3fFfmsRB3g9b6JFX6N2CPYdp0I5PeJ0fAETaEiBIDt7zHikP2mLk1K6wTQPZ9/Mps1lPSPzZcOiq3CVc0TZV0blAk0aFmI3sD8fSOhjlIZw8isvhdQQbjF+JRpLYelkNEKNFw4H/WpFY0nDODiiDaNsCDR+m8SKbENgLxQz+lo0BfsapEMRJmlJZKfJMByJ8Gc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b2d86e-bc6c-499b-1d53-08d829e4fec0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:37.8329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FrvuJgMBid5CPRrDu0Yl4cCApKlZo2j5bit/riO3n5nHnqzKR8G1xhj9f7+Mov8EnbsWryvn6V0JjvVT6tV7ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

