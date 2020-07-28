Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80082306D2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgG1Jpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:45:36 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:23103
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728542AbgG1JpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wag6fVQA4qvej4E8A9SunFIunT1FHz7U5vjJRSPbB4eSEOPtvTGD5YkQMCmfB0rf0b9k++mPgDen1GiqUqAHX7qJYk1Qqxtdf/ClJQYNycvd7lamOhoh0BWw6y1gknXn7aleycNHb8ogtuehK17TRHCOcCHBY/YK954I5e4eF0TM0SXURR7oV1Fm/jeecmYq8+h3ZVotNyWm8yyxIuZ3bsUvUYI80qpKwwB4jRPyPzUVtX4fvr6bD+cWlSpUqeC5gKwut/Y1exXjfvzfNqd7Na0EGFFIyRErlangLgAPNAXQAyiMREwz/Uq2z23RikWM9ZVjvT1fBm356GFRn5YtEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wNOCgWlKVgiJTHUd4iZD3DpOkFL0w2wrOKg/Y7qaus=;
 b=PJblhcrZey/k9B9umqQkr500zgNwpccLi2PPe9i7RtC6/QrnotqdRyhA1lw1J49FaUy131i9YxrcjBrgaisi6xL26Nth+/VH6ode02loTblveZD4w0VGfFMnEtXm5+d+kAO68ngvTVO/eIBS0Bh2TFIW6QH9hiAAgIWjNdZdFsLVjt/ZZd+BJX4YHye3eGEhTZit8/09I4NQETf/XLTIKrDTEhT6V6SM4C6C0dJl6qluXqQgDTmBIaX8g8Iju1vBaW9J87J4QHcUopqLfokxDg1jsjhNFfBGxJbSXZySLJf3zKTeLCCaRNtqpvD17dF1nk3dsAv8fEEnmZ9xFBu5pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wNOCgWlKVgiJTHUd4iZD3DpOkFL0w2wrOKg/Y7qaus=;
 b=TVTSER48nRQiYzSwPywU4154Pfob4WecxOclv6ckEqmxs4dJtlHb1az1rQRuAOLv0U/zpj5TdCJ+7MmH1hz7avGcuzhzjI/kRZ3MtYH3GSQTsq1AFGzaZFUmEDwLQ5tUEUiCW33+tCrvpTKxYBik7z5Xf99y4vxWpcuKCFpuz90=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:45:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:45:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/13] net/mlx5: Use fallthrough pseudo-keyword
Date:   Tue, 28 Jul 2020 02:44:10 -0700
Message-Id: <20200728094411.116386-13-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:45:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0956bff9-a38e-43e6-393b-08d832dae5e7
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117B021FB5D947A6EAD3827BE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qe27wvYyDMR80bvJnoPAbnzlfEwPAWbSXwnK1wAjpJdM0Kv9ztDCVrt6D0E3BbCPkPSaj0PwTZRYqNorUUNc7gbbSmNZqm8bF8QCPSKsliTpFV1pmOoMMuXR2lHKv53DmnXF2yPMqeynuONIAUzAAcKTTSO0IZub/J6WCdWHn2Au9KzZM23cXd5qlSGTH64py/fRSqhDd5wS/Se5svnO55rUVL4vEdusC0bbStobl/NSGWvfNjTB0J49ZuP/aTPsOdhVQMAkLj2D3G+p2tz6R/GUEv5LDW5T+8pO0piMyg3FzpbeFDT//VcZbqkz3OlbGKsHTXiZb1XMq7S2EOljKxPcFymXeYBaaDrazVI+hdJeSyTMNWdk6vYzJ9BiqccEVHPYQhw7QLwPPIujdi+yC/WTwBbNTzsL46IYTG7jFQ4zSuDEjdQ4UDqvVFC0TCJGDQEfMMgcIF+r/+qg03PdRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(966005)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 655xTsTsRV63ZG7PkxArFxrOrJvm4D6WIZhiSYWKePNrzhktPNuwGXU9XNjOa21DmfczxS66Zfruu15NWOyP3tsA3xU2YAjdV+SZ63tUw3MdBMKb+vvUI0kIMFjpsafDIXAlSO178cjBniYamIqhMwYN4tpp0zgKVSRtEwa6+6yjf8kCK8t57Of0XkWaDCHTJyFJK0vu7W6rBRX7W/msK98uU0HsDKjQ/Lr9jTYw98aZjbrMCqekMb/mb9ihRT1wjP/7MVgc6yPyFq3LXe29MauDAmqKuzgXDd+315N2JD7wfBrNN3sx4dP/ZseWqMYB6N6FX9NfrBz+NhLCidHCMndehxIOGCTVqUzcBzTEDq8knCOnv2sdgfWhChstes+2SGx27sYyT2unBqw2QmcgUV+lSWRNA+vrkLocD3mBzqEza77vlHrS4xBQy2pfRlkVyZk3kBXZXdNVxawtGXVzgnFNYtJDzo2BYR6nBBJi+NQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0956bff9-a38e-43e6-393b-08d832dae5e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:45:02.1347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrJE3uOrLyK9Isqtrfur3yL/LcjjkV76iZVgXgUmrAhn5jq62/cyZut556cJAavsao7Hu8dCFC0XqsR4PxdZcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h         | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c          | 4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      | 2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c       | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c          | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/vport.c           | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index f7fd2ed322792..9334c9c3e208b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -388,7 +388,7 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 	switch (swp_spec->tun_l4_proto) {
 	case IPPROTO_UDP:
 		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
-		/* fall through */
+		fallthrough;
 	case IPPROTO_TCP:
 		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 90db221e31df3..0e6946fc121f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -152,11 +152,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		return true;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fall through */
+		fallthrough;
 	case XDP_ABORTED:
 xdp_abort:
 		trace_xdp_exception(rq->netdev, prog, act);
-		/* fall through */
+		fallthrough;
 	case XDP_DROP:
 		rq->stats->xdp_drop++;
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 0e6698d1b4ca9..f4861545b236b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -470,7 +470,7 @@ bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *s
 			if (likely(!skb->decrypted))
 				goto out;
 			WARN_ON_ONCE(1);
-			/* fall-through */
+			fallthrough;
 		case MLX5E_KTLS_SYNC_FAIL:
 			goto err_out;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index af849bc83c306..08270987c5066 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -243,7 +243,7 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
 		return mlx5e_self_test_num(priv);
-	/* fallthrough */
+		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 54de53daf1c02..be610d40749a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2346,7 +2346,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
 		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
 			goto out;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
 		err = -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 182d3ac3e73f2..831d2c39e1534 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -339,14 +339,14 @@ static void mlx5_fpga_conn_handle_cqe(struct mlx5_fpga_conn *conn,
 	switch (opcode) {
 	case MLX5_CQE_REQ_ERR:
 		status = ((struct mlx5_err_cqe *)cqe)->syndrome;
-		/* Fall through */
+		fallthrough;
 	case MLX5_CQE_REQ:
 		mlx5_fpga_conn_sq_cqe(conn, cqe, status);
 		break;
 
 	case MLX5_CQE_RESP_ERR:
 		status = ((struct mlx5_err_cqe *)cqe)->syndrome;
-		/* Fall through */
+		fallthrough;
 	case MLX5_CQE_RESP_SEND:
 		mlx5_fpga_conn_rq_cqe(conn, cqe, status);
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index e9089a793632b..9e68f5926ab6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -198,13 +198,13 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	/* Protect internal structures from changes */
 	rtnl_lock();
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
 					 fib_work->fen_info.fi);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fib_nh = fib_work->fnh_info.fib_nh;
 		mlx5_lag_fib_nexthop_event(ldev,
@@ -255,7 +255,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	switch (event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
@@ -278,7 +278,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		 */
 		fib_info_hold(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fnh_info = container_of(info, struct fib_nh_notifier_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 88cdb9bb4c4a4..bdafc85fd874d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -110,7 +110,7 @@ void mlx5_query_min_inline(struct mlx5_core_dev *mdev,
 	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
 		if (!mlx5_query_nic_vport_min_inline(mdev, 0, min_inline_mode))
 			break;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		*min_inline_mode = MLX5_INLINE_MODE_L2;
 		break;
-- 
2.26.2

