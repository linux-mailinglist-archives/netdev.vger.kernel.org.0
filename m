Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8389E2306C8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgG1JpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:45:15 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:23103
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728197AbgG1JpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CI9qgbw+g8X/NqRA6LpJ93feTX7+lXng6jpFO01Vrbtr9MaXFmM7XooDAlPP2NkX4yA/HPGHQETj7TJHo+SXf2Z586TZ6nF7Gk+U9fuFbc0mNt7AT/hJCqEabz4Jmr/aACaepES00aYqXHKi9RhYjgMmWkTN1LL91QvcF3neP1Zs4jF9nMVUwZICc3RHWdOs2PyQERXL/JqW7Lnur94ckuudQERIH9YtHN2Jy02w5Wayi3oe/5/8FI7IFffzN1bLe8FZOOu4Q9Bk5mJN4ebKQ4Kgza4mfdFuDlPtE8IghZE0p01T3dXn+E3XwGMttOgcBu0L6zPJktaBOmJAwjnGFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR3yJ2ihNmtLARkfR/dl6nzp4wUydEw3A8wRMFJ3Srg=;
 b=BRybSfy2+/UdX6y6wUh7OqTb5//li+pSfGA9/mWulGr0JZzkSq+477Glcua1OjKmf0nSgH667EV9xNVN5vMBi+LPjGYKh8rpKy9ecyquzLh2J35hhi6ClHXe+tLiOWQkO/qCJbYhH6Vz5VTScZ15YZZDRuzDSHTt88OTTDrhLP/HYsrtP4PUDOeicklCHMr3QPpunLfRYq1qhRsW+/CC8k1Urhxe+YxXWAgQN+i9RIvtyWpzfTR+UWhDHQR2RNVZa9TyCjOCa7VMpVnnrKkFGQm36ROvW0IDl1tAMKpKLZ2rXO+lMdrfM2p6GISTpb/IZEo2/H5TBl2FEpBrwWC0ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR3yJ2ihNmtLARkfR/dl6nzp4wUydEw3A8wRMFJ3Srg=;
 b=p1ATSi4yIDLGhLL02zplPS451LtEXyO3SSnt+itXODE28LYdgY3McRKQ+M3o5r7ViOjL0eXRxgfRf6SWb8BuA07VzdP3eVBvFqWEsh2PVRslusZjRJx3hM6AuOjwCNpfqQytan+mqI59Z+Z4k1TN1onf/GMTIKv86o9j4W3utpQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/13] net/mlx5e: Add support for PCI relaxed ordering
Date:   Tue, 28 Jul 2020 02:44:08 -0700
Message-Id: <20200728094411.116386-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3844ff88-240c-42b0-cb82-08d832dae338
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117CC4048778491DDBE4CABBE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zgJfNlbR0seCO+D7fCjd++bN0q38ixC9gT7avIbw7zQGZAPRHtbwxmefQ8jfThiqdi8tABrCWDj9yYDnBGefaXmXDaKh1wQCGiMJx9HTYXtHkV5+/DEt8KFaYJ6AUZHoJmQLyCoWDKtZg5qcmhBwzKc6thZP9xM61ZVMKaswiNA+vP2pvPZbuaj7m8uhfteLVhQgNRGhOMPHLcan8wyTGs2OtW/LQbtEgZWCFrOLa3XIRbyuzcJGMPcCp0E9GPBF8kJi/LGqGLSPWRVz3xjFMDgg3YjM1gM2O6L0sw5td2zMrJour+Tkf1ba5FpbQTsw/1rhxCy1czFc4ZD2trsb8yqIRlw1jgnVj4OO8FgK3Ao7cZyo3iL25Oxybqdmii7l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BsQsnwnH0/7Eq13OZWpp/puHibSbeVxCjZsicvVb6ZDSELnrEM25StT3mbMMaBMH7+xIyNL7m4BtMvXzYwHLO3F4+cXa+Do4ToWkI8HGRzqSbNqpFgDQHMx/n+BOfKhFd2Ve1ThlNgz20vqKkKV6TmJVdshLz9t8jaeADh4yQlX04lR7Qjlqo1sbmTwCIDp3bcjccBpZQCtC6EAnYeqoTiWKfbAs8GzqYAttoZgxbUV21+6rjF19fYEzkK8TXuKNSw+YiqoVKa2MBpWXPfOerS+6Byojc8p9xt9i5yiqg1xb4yDvNIIyLNEuvud0lumz502VCalsbWSb28J4tbYe2wJSk/I/tOz1SavWPz39shvAS+OugdbU9CtfYzpVHvXdtXFliCZGA4NU5z5mfUJJGyVUitUrnWBwSfu05yrAw9N0cdGZ0ZFuDeFwbX6QllFF6wcnb+1K+ffqXZh0CiHQvDEizq6Vewgl8Cr1MGNAj1k=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3844ff88-240c-42b0-cb82-08d832dae338
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:57.4499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9utfNelDQ6ZclKCFpLmfJ3BPQrzLxdxTOlknBtljhoDdGt40vL4TMDnzczPXdfMjoW4XPZ1YsbMPRuowUpjtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

The concept of Relaxed Ordering in the PCI Express environment allows
switches in the path between the Requester and Completer to reorder some
transactions just received before others that were previously enqueued.

In ETH driver, there is no question of write integrity since each memory
segment is written only once per cycle. In addition, the driver doesn't
access the memory shared with the hardware until the corresponding CQE
arrives indicating all PCI transactions are done.

Running TCP single stream over ConnectX-4 LX, ARM CPU on remote-numa has
300% improvement in the bandwidth.

With relaxed ordering turned off: BW:10 [GB/s]
With relaxed ordering turned on: BW:40 [GB/s]

The driver turns relaxed ordering with respect to the firmware
capabilities and the return value from pcie_relaxed_ordering_enabled().

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 12 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0fb30fe93207b..f2fa1307e90cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -974,6 +974,7 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev);
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev);
 int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 		       bool enable_mc_lb);
+void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc);
 
 /* common netdev helpers */
 void mlx5e_create_q_counters(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 1e42c7ae621b9..a6cf008057b5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -60,6 +60,16 @@ void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
 	mutex_unlock(&mdev->mlx5e_res.td.list_lock);
 }
 
+void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
+{
+	bool ro_pci_enable = pcie_relaxed_ordering_enabled(mdev->pdev);
+	bool ro_write = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
+	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read);
+
+	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_pci_enable && ro_read);
+	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_pci_enable && ro_write);
+}
+
 static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 			     struct mlx5_core_mkey *mkey)
 {
@@ -76,7 +86,7 @@ static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
-
+	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET(mkc, mkc, length64, 1);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ac91504be8e8b..f374348fa8100 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -274,7 +274,7 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-
+	mlx5e_mkey_set_relaxed_ordering(mdev, mkc);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
-- 
2.26.2

