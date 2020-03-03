Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E835176933
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgCCAPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:15:55 -0500
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:56068
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726971AbgCCAPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 19:15:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwSRYmaL2bqT54nMjqXigLN2UJtzkhzL9c+aW++Sk+Aty7ASAFB3il5TtYuEXuFs+yhO2TWcJDnW/Zdizn5TaWgZQfFIjW7T5+h0n5lbT2gqihGp573SvWMEMkUe5+8HlIjC9CXr3zicM67zw8HtMRil8CdGwZjmU7jwekAXhz/0IZgxkZS+sL+x4aOH9pF2P1CSjtHx1Yl7e7cuDX5y5QuMp886WFTNx8IE3Y9g2gfR6zy2kMnoCC35/GcXwLMyZLBTJ4+lJdfann+5AzpnmtCCrdibnNy82fUDGsoZP3zyfpjdh0KaG3pKPJ9spO1ISyP6MTGV+ngdHUUb0fMrrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7I9FQ/54c160T03edEtnjXWns2RYtPr+IhComoYAPiU=;
 b=JV/8GE18e8JZsxUYLLWO3OPv3HpPy1RIZHRzS8AhXgiNGmvxyLysPyOauI7lJHDtXE6MStvMdWZ8mhnsZtQHF5Hr74vDUjwaAVxfMJtM+6ZPeH/+Z/hrQ07ijM+IZHYhgGlCmbURSa8iYC3LKjXcUv79LruEjLZi5eN4E41u/c6amW9QGV0a1BfPVf8+jHuUoQyGAN+0eYBFSx7dAlMAYEVxlUVP8e5EMClmoDugDyzB6uP7uEb0QgoOzqfhbFVtvf9YsLaYVcTp6l1f3o0hrkQ2MQclhmj5OfBlGxi3pXU0wdni42U482A89dwSR5JJEuZf1q3wM+kafOcCM1M/mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7I9FQ/54c160T03edEtnjXWns2RYtPr+IhComoYAPiU=;
 b=C1tJV/qKMYjeGsSUdTdVhCzFlrv7McOYUeVAUIQ7kKAIi2K0clug9CJcF3zPS0LEegnYIQ7auY8gvWe9y7jE8bHGcXJg0Xva5pGLwNisc0XHnpOir9TfRh4Ssvt/jxFV+uWtqL5YOdioqaieE6ZWTR5C43v0y+SXzgYHyHFjGoI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3166.eurprd05.prod.outlook.com (10.170.237.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 00:15:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 00:15:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 3/4] net/mlx5: Expose link speed directly
Date:   Mon,  2 Mar 2020 16:15:21 -0800
Message-Id: <20200303001522.54067-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303001522.54067-1-saeedm@mellanox.com>
References: <20200303001522.54067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0018.namprd08.prod.outlook.com (2603:10b6:a03:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Tue, 3 Mar 2020 00:15:46 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb94919d-525a-46de-16fa-08d7bf0805ba
X-MS-TrafficTypeDiagnostic: VI1PR05MB3166:|VI1PR05MB3166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3166041713E8063518220DF8BEE40@VI1PR05MB3166.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(110136005)(316002)(52116002)(6512007)(6506007)(8936002)(6666004)(6486002)(36756003)(86362001)(81156014)(81166006)(8676002)(1076003)(2616005)(16526019)(4326008)(450100002)(5660300002)(4744005)(107886003)(2906002)(186003)(956004)(478600001)(26005)(66476007)(66946007)(66556008)(7049001)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3166;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qff3kvPIBQgM0+K65xRfcTG1TD4h1CyBp4gGel/U4iroIf2Pe364Zygrgyab602C8JsL6k0NWg572jS6DGnftfPh5X2UUGYuX4EJIJfODH9uJzom6G1BL+7h6d5lv5hXdECEwv8RUdhY1QLgWU6KUH5eUKWUIBMHf8OuRmxlXV1l1o8+s+XgNpH32Bfr4ND84EOLKHIeT167oKAlTCB1RIwt/ew71dzKtulVl+Vw3VhzQ1PtiGbh68xbyQ1M21D4+o2JkDsKJ9z5OjR8Teqi+tPq+ynmdkPL7OVWlABxW/Mpb6pQhozslxQkho8AN/69GCX2J6NLF5f3CIzc1+TF4WTIJ2JGJixrGaqHovKiiNO2Qe9EFVtiseUWfIpZzqk8cKTbd0tktWCOrl0C8CJD8pDL4odYZtVpNGkZ1LEpMsoKD1EgI4SmRuwXtPv1p7rQ5Rh0avpwz5yDlYVpsXaVNdzvFnpTtAre9aN0sDQFT+trKTn0jA2dxmhOnKx0WDTAdZGIMkht2b4Q+F+XgBLfP8EeS7CskGv1hLFwMX8u0ug=
X-MS-Exchange-AntiSpam-MessageData: pKVxAgfcCi2EMA7bH71Kw4Zk8Aa508Vg+7cBeKBSSTJ5nfjDxyKSGP2Ow/zw4Ckuj85FpGV/BkKT/RRlMyjWfaQbLc09QqeS2MhOKjks9l8mtokjByDjCU6NITZUYxEMv/zJfTWo5JKL5JfyTXeVdg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb94919d-525a-46de-16fa-08d7bf0805ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 00:15:48.1484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPCvlp6gENzzzHiX/O9vtSDP9R/rzHNf8DwVyKUtkLwk/PIDGDA+dAFXV6rBQo0aHdvp5SetH1CHNBDdxMoTtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Expose port rate as part of the port speed register fields.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 471e26c1e8d9..c764a65e5754 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8417,7 +8417,8 @@ struct mlx5_ifc_ptys_reg_bits {
 	u8         proto_mask[0x3];
 
 	u8         an_status[0x4];
-	u8         reserved_at_24[0x1c];
+	u8         reserved_at_24[0xc];
+	u8         data_rate_oper[0x10];
 
 	u8         ext_eth_proto_capability[0x20];
 
-- 
2.24.1

