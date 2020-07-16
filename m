Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F46222E0F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgGPVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:20 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:49391
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727825AbgGPVeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kf5kDIJi++uXtK9bQUiFyDfd7Ir71zvjoJTjpEyYsZwCXCINGpvFChUtjKTcN2FeFCo2lPktpJjrNjjd8IFD8bjvT5Ke1hShcgoT7rSkX1Z1UG1gOt3uGBhfYZErdM+F6SwG0mMxU8M3cahOdb3XFmxJFqh+Mf3Aia9nIjG/4MpnYN9n4jv9zoLZQsi24Ee5EWf3uL3gpPw/nrbFyPSsLNg1nX2mu5RSqxUZMcx8V1q0ObO1Br0Nz8epCIpaRwnhl4ShKUS9Z5Ar0HyI0lzYDEiYCDQkGzBoWvYU9P/RRCUmbscQRIjCgsef4oBHEKbPeHKxtpd2aOcS8haaeQkf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEnplcrX6lx9vgRdLRs1MWeqDSoOn6KwsfPDviYXWb8=;
 b=d8fjPs3N8IJXwPjDlr0r8TIVWSU59llizR/7aiRaYkh5NpVlARAcoLEsCOAMWkBlYJgA8jx+t3OgMBxXSMSCzu1TT/1qlbkR1iR4U5vkzBO4mAwIYyY+9OA6jD5p3sDTDqGNOky/jOS6RCuEbRaB0qLMNwFPK36teCq0a1y75BHXC5CYtKw45/Tz0XIBtSB0VymWiBN1CZMXV4k4W+wwNr0ZGNXnm443+YVUKQISrSMvabx07Vio24CGsN7PRUk8m6A8CNruoLyqUxBe1gXyEh6R5ORQjKqkcVSbdkKkuJGyXuwi2ud+AGhzAIgwwmh+Hi6Q8LXnZuwPqRSNMVHpBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEnplcrX6lx9vgRdLRs1MWeqDSoOn6KwsfPDviYXWb8=;
 b=QcdsN1VTIuzN2ar83yjaO3yalEjRSy8IAdgkzA3sLj3X8O/BhlRl9v+K088PKbKgfdavZRzGlLNIpg7He9o8u3tmgz7JvSCAieAFKMekfb20Sd0znS/JuNSQBmd6YIRZZ2tIytUK9DeZPXvine6KWJo+byjRGrQpGWM9Dv9P9C8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:34:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:34:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/mlx5e: IPsec: Add Connect-X IPsec Rx data path offload
Date:   Thu, 16 Jul 2020 14:33:16 -0700
Message-Id: <20200716213321.29468-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:34:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2d84dc2-61db-4741-389f-08d829cff676
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB299272B6A55BCA9ED4FEA2B3BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nrxysbeCF6jZgZlxvV4AwLJEI4k9Yxn8lQ5SXyrhh/rLLurRmqWakmn7aYXRE56qAUEUWzXwmNt/xmfBoTvoN391C7fYn/e+Xus7gc6WhfhStfzPbL3FBGae0DD2umE8sTSR92EVcBm81fCHPi2NFcy0/gauhmd9+i2tbxzGHwog0GndyOTJVAfaiIoNzZy6RYLFpMNmcP2BEiz3+2xSAK88ymaafs6UU6FuCGm7msvfSS3aLx7jG5mWLs0ZUvdQP6KyCnhTSNRxQnUYW/8rCzqxbioOTfoyxnt45eVuzFVxfZJ6FYlq2f2KKssHXbdZ6rHHWamPtYxlOVWdgeohxdxqfev61LdbGEBtpw3M3gABeEGZKwH2HqIKLLkfyO2C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Cq5bXFFlHxAiyNSPoZ4y6RiGCXBf3w/yiKxWsygdFJPDEj8jpsFtJbCUlKypxxaBHtwLDJqKbyzs5mPL/yJohPn1mu/8mRH4Z4JV63Dm5tW/8b9WCvtgyoUFlTgGPJaQjTDXYwUMitUl8QB8FkW+QZy9iwHv6aQu7erkL7L06webvoBCcLJAeE38XilRvVvyMbOc4U8Uc4hxDNexUCA2/Fa2MUCas8OgaLbBrEWaNLgRJxfNw8jI28+0hvr0ZNRpYdcBOHgiZOMFt0qcPtJZFeYupWHCexDoeuNv88Yu+vF5I+NjmfXE7c1rfhA+s4TmvpwPONpbpu1zOcm6tHEJuMtEIAossjzISIySdNXMYJ5+BWgxc/5jadOWvqWlq9XBKKFnJ4frgFzqiaP7KGI2p5po8m/RuZZr1mTR6pXSm7dndDlGBKKsDPf7YCuU6X7qz3vVpUOetuGpXjVz2yULIzRmLzut1gA8Tba3Zrtf+Lw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d84dc2-61db-4741-389f-08d829cff676
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:34:04.4945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ipX7X7JuepH269mbMXLm0ZJupsi6butgHbn5K+UMFQWLrqqmqAEqFuTgrQLLMF/qTV63LJw+EUgZ2l+CGB3EAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

On receive flow inspect received packets for IPsec offload indication
using the cqe, for IPsec offloaded packets propagate offload status
and stack handle to stack for further processing.

Supported statuses:
- Offload ok.
- Authentication failure.
- Bad trailer indication.

Connect-X IPsec does not use mlx5e_ipsec_handle_rx_cqe.

For RX only offload, we see the BW gain. Below is the iperf3
performance report on two server of 24 cores Intel(R) Xeon(R)
CPU E5-2620 v3 @ 2.40GHz with ConnectX6-DX.
We use one thread per IPsec tunnel.

---------------------------------------------------------------------
Mode          |  Num tunnel | BW     | Send CPU util | Recv CPU util
              |             | (Gbps) | (Average %)   | (Average %)
---------------------------------------------------------------------
Cryto offload | 1           | 4.6    | 4.2           | 14.5
---------------------------------------------------------------------
Cryto offload | 24          | 38     | 73            | 63
---------------------------------------------------------------------
Non-offload   | 1           | 4      | 4             | 13
---------------------------------------------------------------------
Non-offload   | 24          | 23     | 52            | 67

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 56 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 22 +++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 10 +++-
 4 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 824b87ac8f9ee..93a8d68815ade 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -360,6 +360,62 @@ struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
 	return skb;
 }
 
+enum {
+	MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_DECRYPTED,
+	MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_AUTH_FAILED,
+	MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_BAD_TRAILER,
+};
+
+void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
+				       struct sk_buff *skb,
+				       struct mlx5_cqe64 *cqe)
+{
+	u32 ipsec_meta_data = be32_to_cpu(cqe->ft_metadata);
+	u8 ipsec_syndrome = ipsec_meta_data & 0xFF;
+	struct mlx5e_priv *priv;
+	struct xfrm_offload *xo;
+	struct xfrm_state *xs;
+	struct sec_path *sp;
+	u32  sa_handle;
+
+	sa_handle = MLX5_IPSEC_METADATA_HANDLE(ipsec_meta_data);
+	priv = netdev_priv(netdev);
+	sp = secpath_set(skb);
+	if (unlikely(!sp)) {
+		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sp_alloc);
+		return;
+	}
+
+	xs = mlx5e_ipsec_sadb_rx_lookup(priv->ipsec, sa_handle);
+	if (unlikely(!xs)) {
+		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_sadb_miss);
+		return;
+	}
+
+	sp = skb_sec_path(skb);
+	sp->xvec[sp->len++] = xs;
+	sp->olen++;
+
+	xo = xfrm_offload(skb);
+	xo->flags = CRYPTO_DONE;
+
+	switch (ipsec_syndrome & MLX5_IPSEC_METADATA_SYNDROM_MASK) {
+	case MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_DECRYPTED:
+		xo->status = CRYPTO_SUCCESS;
+		if (WARN_ON_ONCE(priv->ipsec->no_trailer))
+			xo->flags |= XFRM_ESP_NO_TRAILER;
+		break;
+	case MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_AUTH_FAILED:
+		xo->status = CRYPTO_TUNNEL_ESP_AUTH_FAILED;
+		break;
+	case MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_BAD_TRAILER:
+		xo->status = CRYPTO_INVALID_PACKET_SYNTAX;
+		break;
+	default:
+		atomic64_inc(&priv->ipsec->sw_stats.ipsec_rx_drop_syndrome);
+	}
+}
+
 bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
 			       netdev_features_t features)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index ba02643586a54..2a47673da5a4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -34,13 +34,17 @@
 #ifndef __MLX5E_IPSEC_RXTX_H__
 #define __MLX5E_IPSEC_RXTX_H__
 
-#ifdef CONFIG_MLX5_EN_IPSEC
-
 #include <linux/skbuff.h>
 #include <net/xfrm.h>
 #include "en.h"
 #include "en/txrx.h"
 
+#define MLX5_IPSEC_METADATA_MARKER_MASK      (0x80)
+#define MLX5_IPSEC_METADATA_SYNDROM_MASK     (0x7F)
+#define MLX5_IPSEC_METADATA_HANDLE(metadata) (((metadata) >> 8) & 0xFF)
+
+#ifdef CONFIG_MLX5_EN_IPSEC
+
 struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
 					  struct sk_buff *skb, u32 *cqe_bcnt);
 void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
@@ -55,7 +59,21 @@ void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
 bool mlx5e_ipsec_handle_tx_skb(struct mlx5e_priv *priv,
 			       struct mlx5_wqe_eth_seg *eseg,
 			       struct sk_buff *skb);
+void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
+				       struct sk_buff *skb,
+				       struct mlx5_cqe64 *cqe);
+static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe)
+{
+	return !!(MLX5_IPSEC_METADATA_MARKER_MASK & be32_to_cpu(cqe->ft_metadata));
+}
+#else
+static inline
+void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
+				       struct sk_buff *skb,
+				       struct mlx5_cqe64 *cqe)
+{}
 
+static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4e5d83f6334a4..88ea1908cb14a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -65,6 +65,7 @@
 #include "en/hv_vhca_stats.h"
 #include "en/devlink.h"
 #include "lib/mlx5.h"
+#include "fpga/ipsec.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -496,7 +497,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->dealloc_wqe = mlx5e_dealloc_rx_wqe;
 
 #ifdef CONFIG_MLX5_EN_IPSEC
-		if (c->priv->ipsec)
+		if ((mlx5_fpga_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_DEVICE) &&
+		    c->priv->ipsec)
 			rq->handle_rx_cqe = mlx5e_ipsec_handle_rx_cqe;
 		else
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 350f9c54e508f..8b24e44f860a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -973,9 +973,14 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 		goto csum_unnecessary;
 
 	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
-		if (unlikely(get_ip_proto(skb, network_depth, proto) == IPPROTO_SCTP))
+		u8 ipproto = get_ip_proto(skb, network_depth, proto);
+
+		if (unlikely(ipproto == IPPROTO_SCTP))
 			goto csum_unnecessary;
 
+		if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
+			goto csum_none;
+
 		stats->csum_complete++;
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
@@ -1021,6 +1026,9 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 
 	mlx5e_tls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
 
+	if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
+		mlx5e_ipsec_offload_handle_rx_skb(netdev, skb, cqe);
+
 	if (lro_num_seg > 1) {
 		mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
 		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt, lro_num_seg);
-- 
2.26.2

