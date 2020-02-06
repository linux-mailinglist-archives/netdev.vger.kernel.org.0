Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580BA154D9F
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgBFU5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:57:52 -0500
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:22890
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727711AbgBFU5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 15:57:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/Gh1ZVFYlTU6dpFVxXDErTs5sdLjZPrN9c4bbt9dIpv9dwRjTqkoBq8a98MmrhX60qDc4hocNaFNWcPw+TQR8SPkfla5D02Dwe1hPuxPj2W/JRKkoOFLYuNKurfLHOzHS79JBpXqtHhRyddcgBX3VBCu2uUHNqJhBtUmRe8dtum3YLbqt69BqM/4rafoULEHHH9zQ4N4Z9pldyYTRJn3CZ6KJk6y7TyJVKoBZEHjuisGuHLHgq8QsVbFhDMTdRXfFAaz4VTQfE3B1IANPk7TZOoT9ljFgK+Fame84oKhOqlpsivMiABQw6R+ezuioE+M8hEvpcObv3V9aZMWMSHew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWvvrkTLNg5PgAolT5Hcex4B0hvlj96es8D3ekXWQc4=;
 b=G6wGuaesuCtEJezWGEwbto6tp6IX5SnNv0Rliz7NDbmniUDNrwJ1sEkrxFtXHJev032x7ufAeS2U0S1DgYDtQVBr3ERHMQxArGpOlISIXXnfgHNa8Q7lCmVyy9nJMfkXXJhAWxvGD9zL1jZByHW/pbjkItoVHDk41Fz2oOQ5tq5rwBXer1ISXn/G1QJ6g+NSZDfws6EXyT/f5L3J+f5lbcvmRjThbhnGwDQZvgjzV2OgKOjUDNQnDZCpmQf4grdbkeT0R+Jg6orTYJTa1x/eQzaPwKiQrWDqD9t4EPN3IeDhekpcbD+gsO1A0sKjNa5byJUdsrPhJS8EASeFT0AS4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWvvrkTLNg5PgAolT5Hcex4B0hvlj96es8D3ekXWQc4=;
 b=ITsgPuf2B8ddobZI/iDKVVUn5FdRAVNdRmmHQHoY29RtPeOl23YAOWcXdFmTwLp9ZyOdqw1rZzRMKvuXTAGQS217xDIJgnk41HaFXE9wfnLL1tBMv69PrafToK9yDAgcmIsQo/saokW5/7NK4t4WFxW1VFalB0zABoOKbLBohHA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3280.eurprd05.prod.outlook.com (10.175.243.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 20:57:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.024; Thu, 6 Feb 2020
 20:57:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/5] net/mlx5: Deprecate usage of generic TLS HW capability bit
Date:   Thu,  6 Feb 2020 12:57:10 -0800
Message-Id: <20200206205710.26861-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206205710.26861-1-saeedm@mellanox.com>
References: <20200206205710.26861-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BY5PR20CA0005.namprd20.prod.outlook.com (2603:10b6:a03:1f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 20:57:45 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 644f07f0-a6c3-4c99-30bd-08d7ab4737ca
X-MS-TrafficTypeDiagnostic: VI1PR05MB3280:|VI1PR05MB3280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3280A3885B31095BA4538523BE1D0@VI1PR05MB3280.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:95;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(86362001)(4326008)(6512007)(107886003)(26005)(5660300002)(16526019)(186003)(6506007)(8676002)(81156014)(6916009)(81166006)(8936002)(2906002)(478600001)(36756003)(52116002)(6486002)(316002)(54906003)(1076003)(6666004)(956004)(66476007)(2616005)(66556008)(66946007)(41533002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3280;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFUkZoMRMvCUZ4qmT/zxb6YVuFgVT/ulzryS8fpLOQlXTRmt4+41REfpuTrHiI3EymWYMat6h2vucFRxD2go8em/tLaulTxd/TWNYqH62bhyKV5szG5ZbZx1vOf05kLdZN3sb7fMdjKiw12R4N68IOqID9K50Vo4mpkuSfsdEktthrpcRDNPfVaDCd1zIMmSyzaQeEbNOsaZq0kbc9dnz1jK0PWWd7hqOORk5Hi5iUbLCw0vkdEt8+uyqUmPcQPlSLBGZx0yxk8YHvvn+hexmBD5TnHJcVEKDWzDHB9U/+pIWR3PrAszAm4M5WkuDZoBJk+ePNxKVnRsPqC0sErr26K9T2pD1IgHAjI4BEJtTWYEidiwHw88SUgew58xXH38VLPg69YVXF66sqvvjK15rj9DeTUN2XfAZibbRVB4k8Pdh7xDabKxrpk5r1Hsg5GImJzLI8EepAi3brUY67CwE/HIDP6VECGoO4DFnMUSKZSRtJM6SXRMrTmyLjVRNEakgLg3PjvppjxX7Z3YSQv2XNHqlk3FHBh6kOoeRd4LSYs2H4XA14SV6aETzgIygQvv
X-MS-Exchange-AntiSpam-MessageData: Vy3Y5KL7Nxp1sCDtkP1vvNTRL73QF5Bi5dVwy5oZU8ZX5zcQJCiI+mInyfD/O3+dwVZuZLLudlK7kXzF4rQlHNY3FBeo1zKZSiQJyCbiMMgUEJngx8XOg0Ct+wFznn9P4HP+Z3ziIGMlOOeZtxQ1DA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 644f07f0-a6c3-4c99-30bd-08d7ab4737ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 20:57:46.6537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PtovepPEv6/sbxtmz9MT3TUoerRu6WvQe19iXz2ms0K0GJqtt8VFW2o8EbAiy+fzARxv1cg2KMUpREyUxTHIkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Deprecate the generic TLS cap bit, use the new TX-specific
TLS cap bit instead.

Fixes: a12ff35e0fb7 ("net/mlx5: Introduce TLS TX offload hardware bits and structures")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h        | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c               | 2 +-
 include/linux/mlx5/mlx5_ifc.h                              | 7 ++++---
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
index d787bc0a4155..e09bc3858d57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -45,7 +45,7 @@ void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
 
 static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
 {
-	if (!MLX5_CAP_GEN(mdev, tls))
+	if (!MLX5_CAP_GEN(mdev, tls_tx))
 		return false;
 
 	if (!MLX5_CAP_GEN(mdev, log_max_dek))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 71384ad1a443..ef1ed15a53b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -269,7 +269,7 @@ struct sk_buff *mlx5e_tls_handle_tx_skb(struct net_device *netdev,
 	int datalen;
 	u32 skb_seq;
 
-	if (MLX5_CAP_GEN(sq->channel->mdev, tls)) {
+	if (MLX5_CAP_GEN(sq->channel->mdev, tls_tx)) {
 		skb = mlx5e_ktls_handle_tx_skb(netdev, sq, skb, wqe, pi);
 		goto out;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index d89ff1d09119..909a7f284614 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -242,7 +242,7 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
-	if (MLX5_CAP_GEN(dev, tls)) {
+	if (MLX5_CAP_GEN(dev, tls_tx)) {
 		err = mlx5_core_get_caps(dev, MLX5_CAP_TLS);
 		if (err)
 			return err;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 032cd6630720..ff8c9d527bb4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1448,14 +1448,15 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_440[0x20];
 
-	u8         tls[0x1];
-	u8         reserved_at_461[0x2];
+	u8         reserved_at_460[0x3];
 	u8         log_max_uctx[0x5];
 	u8         reserved_at_468[0x3];
 	u8         log_max_umem[0x5];
 	u8         max_num_eqs[0x10];
 
-	u8         reserved_at_480[0x3];
+	u8         reserved_at_480[0x1];
+	u8         tls_tx[0x1];
+	u8         reserved_at_482[0x1];
 	u8         log_max_l2_table[0x5];
 	u8         reserved_at_488[0x8];
 	u8         log_uar_page_sz[0x10];
-- 
2.24.1

