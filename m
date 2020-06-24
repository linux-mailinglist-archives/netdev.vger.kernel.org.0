Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B70206A16
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388049AbgFXCWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:22:23 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387719AbgFXCWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:22:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0x4XyHUg5h6ftKIBj0pwuWAAV/gd2Uzj8/j01fT18bfK2jf0ACfSr7/ILSsbWYXfH1iM83F4i/eXaHqyfMLH9I2zYVzlJCycABV4KIvgW9nSt9z6XrmgPVH+N+6yXKQwpLsz6/z8aXsTJSxO5ESJ2TwePXoi+7+Ks5guEBgGa2h3mtq6Nj15LVxVufP1ayrIqA8GVbojPGcql+8xO27g0U/680IVW1XqDVcUhqZb4rhqCmun4RUvBHw2pnnncFUsNoDrw0guhnPHM9dOI6ZK9mPjINfrxYdyWMDHXGtNvnaWclE7M9NsTsdQIONFy2jq1PHyg83wSj+/9TNKkwWbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70MFU2jHnj2EGvb3VVagI1Kl1aBeu4qYIsy261BtYYo=;
 b=KJaoKdqhhwLT3WoVf6x0C8Yan4mZCyQBpQjJg6i8bxsnNCNrhZhJ3t11YzE7ndFaoG8GzTCYvcRQ5QaJWIvnSp0ao3p4OfEyCIMBBQJekmmjmsogkE75XpPZEEKC4+xoF4Il4X0AsNooqOaqW3/tnzTPZLit8ellM+Kt2ZohB7nCL6Sk2AL2aBjRM36fOUl6jkwRFf5fwufB9o/lfaW3XBCTOcJ0DJd5RmuKPNkr1T1EjRzFXxDEUcELMyVME0OehQhiqOAl24LBoZUkUpbNu1mcbuUa9MqRXs2sHCHBrOtS6UUcH5nI+5XOmOqIJmj0kpm973mhXPwNVgeqjq45SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70MFU2jHnj2EGvb3VVagI1Kl1aBeu4qYIsy261BtYYo=;
 b=BLh6FW4jugGbzP7Ar+7tVAdEtsE4NCzlHqPZyf4HI3QGGYpBS2DbMbHnPRGWxMJ1797PdXKqMBFQGAuYz/hVV3Oxi4by+howDlWVI+cefFStTLyt3pwjkZfb0l0oMxP4UGs42utUGbB75HNvMC+B42dcqCvEToOHftsShZ0rGCE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 10/10] net/mlx5e: Add support for PCI relaxed ordering
Date:   Tue, 23 Jun 2020 19:18:25 -0700
Message-Id: <20200624021825.53707-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:25 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7960545d-b346-435b-af3c-08d817e54c57
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7022689CB7AFFA0C2A80A245BE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xMc30C2yXB6jeA22r57zvUmP6GN7zOXztjKT6k1OhGAsFiNIY0f+epzjIGwRwIr5flJKY15tj3T9khu1I4XoReu72eEk1ilUSmMbQENydFao8R619AYg9Fvefs46E00z1sANdzb4piE4EUZcn1YuC92vMTZ57ro8aU6l7egNa53Nyxuy2Q2vU7pU4V1JT3nIooz36hDB0uTjahkCvqmEWpjIaXm5/x78tslCCeaJoKhMIgWnzmAb8aHC72PGv5+BLdiA94DKYPJzUFAjd1a93cAJ48WOV30QJzCpLUOy8utejTGIEiZGESgprx0zI5FJWVoDcgGyh/p9r3Ln4Eypq7h5cnvq49LpWuKnUig4vABhI8Nlk923mHLyuWXMyClD8Apf/ELgu3XFokm8k4d4Dmp/CQi5r4NKof9QI+vRHyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(30864003)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xdZFSEw25wL0t6V9ooRGmaBalcJZipxM4MxLUYsBF8wCy9FSSB77GoRXnGZeeg6zYqx9zTtHGPVNJ1YbwCGpiamqck8M0v6gfJzzaEYkBAl3JIFMmHeL3XyivbekETNQpxHCOSJhyh4rG7jqZs4Pqtm3W4pvQHusHmhAQGrucm7qPiNovg5tqsJsXtci6oGmDtboJUVFj/jcfNB7kD/HJCCyl9xR/NSB5S9B/A5VwUa8cGmYKwbeE/iZwHK7H66QX6U4NJw31o+16uGWLWeZCiCJk+M3bdcz1756rY9vyNQjhWZB8geX8hEgKlen0HrwtoCgqG3HghApXYN1ajmwQ2S+HKt/IfGO7IA3lxe50zO6PjmJCCSVfHbyX1wqQ0QP8IesvXsEqFpzSIOCiedT4CqQaPrijAScZAYO9gaMscLH8ad8V5MCTgFRyIaKyAfPrTWeAKu9Fmu1bQTwLjgFq6novvb19WRgQ14ubTRgf7c=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7960545d-b346-435b-af3c-08d817e54c57
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:27.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swHlkWYn9i/xkGwtH8pmrL8c6Yp5uwsw1eklvcDLJcsDQofOVLYttT6duhcO3UWWsmnHpy4SpF5DtehezR5BgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
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

With relaxed ordering set, traffic on the remote-numa is at the same
level as when on the local numa. Running TCP single stream over
ConnectX-4 LX, ARM CPU on remote-numa has 300% improvement in the
bandwidth.
With relaxed ordering turned off: BW:10 [GB/s]
With relaxed ordering turned on:  BW:40 [GB/s]

The driver turns relaxed ordering off by default. It exposes 2 boolean
private-flags in ethtool: pci_ro_read and pci_ro_write for user control.

$ ethtool --show-priv-flags eth2
Private flags for eth2:
...
pci_ro_read        : off
pci_ro_write       : off

$ ethtool --set-priv-flags eth2 pci_ro_write on
$ ethtool --set-priv-flags eth2 pci_ro_read on

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +
 .../ethernet/mellanox/mlx5/core/en_common.c   | 67 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 46 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 29 ++++++--
 include/linux/mlx5/driver.h                   | 10 ++-
 5 files changed, 143 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 842db20493df6..32b1d41d36347 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -228,6 +228,8 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_RX_STRIDING_RQ,
 	MLX5E_PFLAG_RX_NO_CSUM_COMPLETE,
 	MLX5E_PFLAG_XDP_TX_MPWQE,
+	MLX5E_PFLAG_PCI_RO_READ,
+	MLX5E_PFLAG_PCI_RO_WRITE,
 	MLX5E_NUM_PFLAGS, /* Keep last */
 };
 
@@ -1033,6 +1035,7 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev);
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev);
 int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
 		       bool enable_mc_lb);
+__be32 mlx5e_mkey_ro_get(struct mlx5e_resources *res, u8 mkey_idx);
 
 /* common netdev helpers */
 void mlx5e_create_q_counters(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 1e42c7ae621b9..a3a6a16c774d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -61,9 +61,10 @@ void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
 }
 
 static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-			     struct mlx5_core_mkey *mkey)
+			     struct mlx5_core_mkey *mkey, u8 ro_state)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	static const u8 mkey_variant = 0x5e;
 	void *mkc;
 	u32 *in;
 	int err;
@@ -76,10 +77,13 @@ static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
-
+	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_state & MLX5E_MKEY_RO_READ);
+	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_state & MLX5E_MKEY_RO_WRITE);
 	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET(mkc, mkc, length64, 1);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, mkey_7_0, mkey_variant);
+	mkey->key = mkey_variant;
 
 	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
 
@@ -87,6 +91,57 @@ static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	return err;
 }
 
+static bool mlx5e_rx_mkey_supported(struct mlx5_core_dev *mdev, u8 mkey_idx)
+{
+	if ((mkey_idx & MLX5E_MKEY_RO_READ) &&
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_read))
+		return false;
+	if ((mkey_idx & MLX5E_MKEY_RO_WRITE) &&
+	    !MLX5_CAP_GEN(mdev, relaxed_ordering_write))
+		return false;
+	return true;
+}
+
+static int mlx5e_create_mkeys(struct mlx5_core_dev *mdev, u32 pdn,
+			      struct mlx5_core_mkey mkey_arr[])
+{
+	int i, err;
+
+	for (i = 0; i < MLX5E_MKEY_RO_NUM; i++) {
+		if (!mlx5e_rx_mkey_supported(mdev, i))
+			continue;
+		err = mlx5e_create_mkey(mdev, pdn, &mkey_arr[i], i);
+		if (err)
+			goto destroy;
+	}
+	return err;
+
+destroy:
+	while (--i >= 0) {
+		if (!mkey_arr[i].key)
+			continue;
+		mlx5_core_destroy_mkey(mdev, &mkey_arr[i]);
+	}
+	return err;
+}
+
+static void mlx5e_destroy_mkeys(struct mlx5_core_dev *mdev,
+				struct mlx5_core_mkey mkey_arr[])
+{
+	int i;
+
+	for (i = 0; i < MLX5E_MKEY_RO_NUM; i++) {
+		if (!mkey_arr[i].key)
+			continue;
+		mlx5_core_destroy_mkey(mdev, &mkey_arr[i]);
+	}
+}
+
+__be32 mlx5e_mkey_ro_get(struct mlx5e_resources *res, u8 mkey_idx)
+{
+	return cpu_to_be32(res->mkey_ro[mkey_idx].key);
+}
+
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 {
 	struct mlx5e_resources *res = &mdev->mlx5e_res;
@@ -104,9 +159,9 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 		goto err_dealloc_pd;
 	}
 
-	err = mlx5e_create_mkey(mdev, res->pdn, &res->mkey);
+	err = mlx5e_create_mkeys(mdev, res->pdn, res->mkey_ro);
 	if (err) {
-		mlx5_core_err(mdev, "create mkey failed, %d\n", err);
+		mlx5_core_err(mdev, "create mkeys failed, %d\n", err);
 		goto err_dealloc_transport_domain;
 	}
 
@@ -122,7 +177,7 @@ int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev)
 	return 0;
 
 err_destroy_mkey:
-	mlx5_core_destroy_mkey(mdev, &res->mkey);
+	mlx5e_destroy_mkeys(mdev, res->mkey_ro);
 err_dealloc_transport_domain:
 	mlx5_core_dealloc_transport_domain(mdev, res->td.tdn);
 err_dealloc_pd:
@@ -135,7 +190,7 @@ void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev)
 	struct mlx5e_resources *res = &mdev->mlx5e_res;
 
 	mlx5_free_bfreg(mdev, &res->bfreg);
-	mlx5_core_destroy_mkey(mdev, &res->mkey);
+	mlx5e_destroy_mkeys(mdev, res->mkey_ro);
 	mlx5_core_dealloc_transport_domain(mdev, res->td.tdn);
 	mlx5_core_dealloc_pd(mdev, res->pdn);
 	memset(res, 0, sizeof(*res));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ec5658bbe3c57..4e61f7f87118f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1905,6 +1905,50 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
 	return err;
 }
 
+static int set_pflag_pci_ro_read(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_channels new_channels = {};
+	struct mlx5e_resources *res;
+
+	res = &priv->mdev->mlx5e_res;
+	if (enable && !mlx5e_mkey_ro_get(res, MLX5E_MKEY_RO_READ))
+		return -EOPNOTSUPP;
+
+	new_channels.params = priv->channels.params;
+
+	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_PCI_RO_READ, enable);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		priv->channels.params = new_channels.params;
+		return 0;
+	}
+
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+}
+
+static int set_pflag_pci_ro_write(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_channels new_channels = {};
+	struct mlx5e_resources *res;
+
+	res = &priv->mdev->mlx5e_res;
+	if (enable && !mlx5e_mkey_ro_get(res, MLX5E_MKEY_RO_WRITE))
+		return -EOPNOTSUPP;
+
+	new_channels.params = priv->channels.params;
+
+	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_PCI_RO_WRITE, enable);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		priv->channels.params = new_channels.params;
+		return 0;
+	}
+
+	return mlx5e_safe_switch_channels(priv, &new_channels, NULL, NULL);
+}
+
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
 	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
@@ -1912,6 +1956,8 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_striding_rq",      set_pflag_rx_striding_rq },
 	{ "rx_no_csum_complete", set_pflag_rx_no_csum_complete },
 	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
+	{ "pci_ro_read",         set_pflag_pci_ro_read },
+	{ "pci_ro_write",        set_pflag_pci_ro_write },
 };
 
 static int mlx5e_handle_pflag(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a836a02a21166..80d1d940a78a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -258,8 +258,11 @@ static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq,
 
 static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 				 u64 npages, u8 page_shift,
+				 struct mlx5e_params *params,
 				 struct mlx5_core_mkey *umr_mkey)
 {
+	bool ro_write = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_PCI_RO_WRITE);
+	bool ro_read = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_PCI_RO_READ);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	void *mkc;
 	u32 *in;
@@ -276,7 +279,8 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-
+	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_write);
+	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_read);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
@@ -290,11 +294,12 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	return err;
 }
 
-static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq *rq)
+static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq *rq,
+				    struct mlx5e_params *params)
 {
 	u64 num_mtts = MLX5E_REQUIRED_MTTS(mlx5_wq_ll_get_size(&rq->mpwqe.wq));
 
-	return mlx5e_create_umr_mkey(mdev, num_mtts, PAGE_SHIFT, &rq->umr_mkey);
+	return mlx5e_create_umr_mkey(mdev, num_mtts, PAGE_SHIFT, params, &rq->umr_mkey);
 }
 
 static inline u64 mlx5e_get_mpwqe_offset(struct mlx5e_rq *rq, u16 wqe_ix)
@@ -457,7 +462,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 
 		rq->buff.frame0_sz = (1 << rq->mpwqe.log_stride_sz);
 
-		err = mlx5e_create_rq_umr_mkey(mdev, rq);
+		err = mlx5e_create_rq_umr_mkey(mdev, rq, params);
 		if (err)
 			goto err_rq_wq_destroy;
 		rq->mkey_be = cpu_to_be32(rq->umr_mkey.key);
@@ -1924,6 +1929,18 @@ static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
 	return (ix + port_aff_bias) % mlx5e_get_num_lag_ports(mdev);
 }
 
+static __be32 mlx5e_choose_ro_mkey(struct mlx5e_resources *res, struct mlx5e_params *params)
+{
+	u8 mkey_idx = 0;
+
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_PCI_RO_READ))
+		mkey_idx |= MLX5E_MKEY_RO_READ;
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_PCI_RO_WRITE))
+		mkey_idx |= MLX5E_MKEY_RO_WRITE;
+
+	return mlx5e_mkey_ro_get(res, mkey_idx);
+}
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -1953,12 +1970,14 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->cpu      = cpu;
 	c->pdev     = priv->mdev->device;
 	c->netdev   = priv->netdev;
-	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
 	c->num_tc   = params->num_tc;
 	c->xdp      = !!params->xdp_prog;
 	c->stats    = &priv->channel_stats[ix].ch;
 	c->irq_desc = irq_to_desc(irq);
 	c->lag_port = mlx5e_enumerate_lag_port(priv->mdev, ix);
+	c->mkey_be  = mlx5e_choose_ro_mkey(&priv->mdev->mlx5e_res, params);
+	if (WARN_ON_ONCE(!c->mkey_be))
+		return -EINVAL;
 
 	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 13c0e4556eda9..f3e97c3606705 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -613,10 +613,18 @@ struct mlx5_td {
 	u32              tdn;
 };
 
+enum mlx5e_mkey_ro {
+	MLX5E_MKEY_RO_NONE = 0,
+	MLX5E_MKEY_RO_READ = 1,
+	MLX5E_MKEY_RO_WRITE = 2,
+	MLX5E_MKEY_RO_RW = 3,
+	MLX5E_MKEY_RO_NUM
+};
+
 struct mlx5e_resources {
 	u32                        pdn;
 	struct mlx5_td             td;
-	struct mlx5_core_mkey      mkey;
+	struct mlx5_core_mkey      mkey_ro[MLX5E_MKEY_RO_NUM];
 	struct mlx5_sq_bfreg       bfreg;
 };
 
-- 
2.26.2

