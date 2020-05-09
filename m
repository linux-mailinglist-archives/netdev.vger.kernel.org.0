Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF721CBF01
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgEII3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:31 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:60182
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727785AbgEII3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDlgCFjQSbq6UplyZV8NrwtI4naTbqE2mlEjK9vyDSYZ1ZgFKsI74eSugtwbLRW2T50rCcx4RAaH2U8T5kuScmwqxd8XsJ/rscFKMiuHGI42HSIpEwihpZZ/STwRVZHnUTjavQRz+MeeyPN0ubCuIwH65NK6YgzhyY+nMAKgnQddMltqZ4/djUF6NAdm/oI8jRPjvDtGOq6rAiIb8WMWljLZdWJzrRspunjrOzQRXKnhAddb0KhXzn1Y7J24VAtLpfyMa8seuBJNYV2f4hAAQ/s9EfB3Vgbgxt9I+DzmB1XKZxt7L877VNGjpYODqGSAWAf0vi0KOaSKAT27DXtmPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzRiGnMKhQCR2irlgHLRtpek1wIzg0cpMDOfVZ2KeeM=;
 b=RuxYRBfeCA9bppeMxZ3xSSzl+5p5a+RtldldNMr+BLldxq3qB4bbVJLx0AeNX8H+ds7Wl1nB17P1+rWjkDYD3pQ42JfGxr+yu0QTRMRRHKITMggDMSy3Osv551Q768YaOti8ukLWr24FF1fRreMXoOvKU+eBqkKt/VvzZgIONlZmS6fxw1HWcJT9mINvRcApd3SPceiJaFmFjO3oISWAXOh0WtCVPO5HiILr1LFnoDFf9ubiRoWSOIeem0UduuKyowUncItSUY2/Dj7IH3vTpxi47Lr4+4F/M3t7jN0IT0wYLUiYvgbnrLUla4Os1V0KsapjC/bZ5qVXZMTk4MBG0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzRiGnMKhQCR2irlgHLRtpek1wIzg0cpMDOfVZ2KeeM=;
 b=CIb2pC9Lq/XrwGiNW5O1l1Sybr72P0yc5uzZXyE1XR2/M7Y7jdl1Hb64FrEP4OzgfR/Lmu8iTaujSvyJZl3Zoi4x2E01u+w8fG+vrSbhWIPXfqcmybyCj5qzlX1lQCIZ1moX6hi6Q5UtmlYGtVISc7N+1pHRO6QVTIVAnUp0488=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/13] net/mlx5e: Return void from mlx5e_sq_xmit and mlx5i_sq_xmit
Date:   Sat,  9 May 2020 01:28:46 -0700
Message-Id: <20200509082856.97337-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:19 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47ab2841-0794-4146-2f3a-08d7f3f312b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB481388EDF93796F91E4DB34DBEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5q2AhjHTJ1gDMRNohWmoHotZeK0rF8PW0BeQreH0apzS2gqnegZ3m1QhmVTuXDK74eHFHV1CqvfXiuqVG9o9wx8n5zuFYyg5bjVp7QwylmZ4ErgZSySVu3eaTylwy6+km6vOR38PPzaWZ+2PI409jBkzepA6lHbYU0A4RvK9j8b+S1p+VVLJ4VxXV4DXvAspPdy+CNsb5xopha1NkpXPrJHYR44x7Aq4c4BkdAFBl68Meu/YBbAFfGWLoDYaKbvm7mYCIU3fnPxTV1doCk/mAaMzHpzea1gS1Wyd2sI15E4ofRIJkh84FKpvLb167pFGa50pytyTAXPdoRq7KSKsX9QzWUt0Ol9H7PNqPd82yQgN5EIFcUVlZrjXI//2HFwPy6mxXbp/9URjOax5Tryk6c/uGr0z5YOgalQ5xoNB8RiAn+nxUcAP4tPFS0Cre9oC9csCsIEo7EcjPTLS/nVyyusNgw3CmNvXEX59ICDE+r3Gldq/nI0m22S1JqNg7wSbQ82LRuEKsmo3G932NarkBSOblpb7JnCDUli7qdfeGxIC8pgQ7n06RBHhebq4AFRD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(33430700001)(26005)(6506007)(2616005)(6666004)(4326008)(6512007)(1076003)(6486002)(36756003)(8936002)(33440700001)(66556008)(66476007)(5660300002)(54906003)(956004)(8676002)(316002)(107886003)(66946007)(2906002)(16526019)(52116002)(86362001)(186003)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZYVMF047P+It9Wuq0otE9oKt9YdM3YlJu2iB0A6RwX6FZhTEiNM/jXm2pQTxE9iffsHsrX8ihVtbP9+OLzbPHxEzmxC4C+xM0+GjfvROt3qCGEuePRbapNToTMpQsB3/ZlDcARhSZzdttLfTQyIeAQxgmqTmn4/a1u62Mp6VRpp7fItR+HCOWIkwgdoFj7dXFjNmw/WJsDZtrHTuo3jR69uI9k6yeY0TOT0h5QPv0JBElpuGNw0GDI1yvXKj00mn6ZRy37+BooPvQfeuVguneAemCYtl84Mq9uuSAGp2llgELzAhrLpN4LTnvV2TJe4DCnBar9isrDcBTnG0V4YnL1uk5+bRDqsNqLVgBrr1go8n/RD6RVVTGnNMjxe8UyN7h3FXb3FAtM8JgczexQPFLklvwvYMkJzlOL79BV0vup9wfmm46Z2D8rCj/s9PJMOn+yN/h4Ei1mHVxBJjHueoKmlPF2aXOiFuSnDt+0bEJgM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ab2841-0794-4146-2f3a-08d7f3f312b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:21.4350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irTp/Qb9/yIijV90gC/1h6ivZ5ZFjDb5G00eSkim0RXIGrLdzZPR1VUPkf3vOKzel8Astt082UJew5DQJ44dFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_sq_xmit and mlx5i_sq_xmit always return NETDEV_TX_OK. Drop the
return value to simplify the code.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 24 +++++++++----------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  4 +++-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.h |  5 ++--
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0864b76ca2c0..da7fe6aafeed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -919,8 +919,8 @@ void mlx5e_build_ptys2ethtool_map(void);
 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
-netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-			  struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more);
+void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more);
 
 void mlx5e_trigger_irq(struct mlx5e_icosq *sq);
 void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 7a6ed72ae00a..bb6d3774eafb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -265,8 +265,8 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
 }
 
-netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-			  struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more)
+void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more)
 {
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5_wqe_ctrl_seg *cseg;
@@ -373,13 +373,11 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	mlx5e_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
 			     num_dma, wi, cseg, xmit_more);
 
-	return NETDEV_TX_OK;
+	return;
 
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
-
-	return NETDEV_TX_OK;
 }
 
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -395,9 +393,12 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* might send skbs and update wqe and pi */
 	if (unlikely(!mlx5e_accel_handle_tx(skb, sq, dev, &wqe, &pi)))
-		return NETDEV_TX_OK;
+		goto out;
+
+	mlx5e_sq_xmit(sq, skb, wqe, pi, netdev_xmit_more());
 
-	return mlx5e_sq_xmit(sq, skb, wqe, pi, netdev_xmit_more());
+out:
+	return NETDEV_TX_OK;
 }
 
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
@@ -567,9 +568,8 @@ mlx5i_txwqe_build_datagram(struct mlx5_av *av, u32 dqpn, u32 dqkey,
 	dseg->av.key.qkey.qkey = cpu_to_be32(dqkey);
 }
 
-netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-			  struct mlx5_av *av, u32 dqpn, u32 dqkey,
-			  bool xmit_more)
+void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more)
 {
 	struct mlx5i_tx_wqe *wqe;
 
@@ -647,12 +647,10 @@ netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	mlx5e_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
 			     num_dma, wi, cseg, xmit_more);
 
-	return NETDEV_TX_OK;
+	return;
 
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
-
-	return NETDEV_TX_OK;
 }
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 068578be00f1..035bd21e5d4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -663,7 +663,9 @@ static int mlx5i_xmit(struct net_device *dev, struct sk_buff *skb,
 	struct mlx5_ib_ah *mah   = to_mah(address);
 	struct mlx5i_priv *ipriv = epriv->ppriv;
 
-	return mlx5i_sq_xmit(sq, skb, &mah->av, dqpn, ipriv->qkey, netdev_xmit_more());
+	mlx5i_sq_xmit(sq, skb, &mah->av, dqpn, ipriv->qkey, netdev_xmit_more());
+
+	return NETDEV_TX_OK;
 }
 
 static void mlx5i_set_pkey_index(struct net_device *netdev, int id)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index 7844ab5d0ce7..c4aa47018c0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -113,9 +113,8 @@ struct mlx5i_tx_wqe {
 #define MLX5I_SQ_FETCH_WQE(sq, pi) \
 	((struct mlx5i_tx_wqe *)mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5i_tx_wqe)))
 
-netdev_tx_t mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-			  struct mlx5_av *av, u32 dqpn, u32 dqkey,
-			  bool xmit_more);
+void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more);
 void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 
-- 
2.25.4

