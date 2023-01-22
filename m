Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE721676DD6
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjAVOzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjAVOzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:55:52 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F311CAEA
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:55:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i58bheCP9Ex+SYLgv86TpF2lMvLxy85iVy4k+f4mxs+AVa+VQs9IqolS4qerxdmSrZZIw7x2womy+eTxJ2SXBI1jrsHxY6ZtiTbGnspXrV24KKHAi+BQWUB2qsqrpVt2bZgDVUGWZA8Q+5U0TXr5q0awSmFz3FYo+/mPvAMWLAuMdkAl0pTR3QsIrJO8wI/iOlR5AEtQ9as+phZyN46FewgZbgfY5sGKdEv+8kNi5d2NOfPS+Voc+DzZItFNkvk3VigFQX0cTu9Lpe0mUVRm5PjBJew73fhIxzkeCEQh40eK1HE5GjUZ5D53Wy5U8DSJqTH/UQ/9DkzBbdgki/diDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRzKsWMb9uk4nDl9wb9RQO6B3+vZHTczy3RwfOsgqp8=;
 b=hoqSCNEXwpVUjCk5H1DG/7FdFpdFVea6MlDT7TCtc4nfbiu3H1pQVnSccX3f0c60dEMtfWgMihdXz7WXLXIX6DGbIeLjDvxBLJbh9ngAyUQTD507tKIMtZrgmfuQU/sx98gcY4QGWzhdTpYYM+iWXWbwZG732DCul9crH3QS44eX2qNH0+zNkPyUoX8ZWWp79XCm5XU0uUPOYExU2Keh4VKm8XOzThGfExVfMkH0SlXB0SP6rHt25vE55PMiWokRmnLBezEKzTi3/gVjLlLyh/xQl0LTxUnQ2RiVyZc0DbMQyO1PjsyQVSf3hp+W99VA/IPH6ZH4+7QPudrv/L4E8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRzKsWMb9uk4nDl9wb9RQO6B3+vZHTczy3RwfOsgqp8=;
 b=eGhAbZfhpvXcVGz8ox8g/n90ZI+hvle/IE+WN5lX7Nt2iilbM8PXRQGoGhwqjJGUX2qwaVyCFxx81xLJoS3EP/0QX15n4shghvFFa8BVLfo+zreIKSIgWq0kK+ZI4xPZ/OUE0skT5e285AOamtv05nlrl93l2xUih9F76z6HmIBkJEdDe8BHwbF3lXx68QYwXaLPxPtpl2qssQRimNk8YZ+Ka/Nu8gFMSNWIpGLzbw2juE4H2tQqvmJSKU7fMXryzK7TlayteeiiiEd9gvGpwTn/TqXImcaJ1Ws1BJo4jGujPMIdKnz7AeK3kSnzBnVD1h9Bbpq5ExQf2PYMm35HsA==
Received: from MW4PR03CA0163.namprd03.prod.outlook.com (2603:10b6:303:8d::18)
 by BL1PR12MB5922.namprd12.prod.outlook.com (2603:10b6:208:399::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sun, 22 Jan
 2023 14:55:46 +0000
Received: from CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::99) by MW4PR03CA0163.outlook.office365.com
 (2603:10b6:303:8d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.31 via Frontend
 Transport; Sun, 22 Jan 2023 14:55:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT108.mail.protection.outlook.com (10.13.175.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sun, 22 Jan 2023 14:55:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 06:55:40 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 22 Jan 2023 06:55:40 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 22 Jan 2023 06:55:37 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 4/6] net/mlx5: Refactor tc miss handling to a single function
Date:   Sun, 22 Jan 2023 16:55:10 +0200
Message-ID: <20230122145512.8920-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230122145512.8920-1-paulb@nvidia.com>
References: <20230122145512.8920-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT108:EE_|BL1PR12MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f33606c-e540-4974-228a-08dafc88bde4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9YAcPGvC0AHXSOJWMxFERF/EWWVNURKXd6Ri2avFdPO/p7oAy97HmBciYhuyl/xF5trYeYlgDgFZ/LjHwlTKIKobgUEozcw4QZzlC0vKVptkJzy70GB5c/bEJgVRY3/iSn2yqsO2aQXTgGPEM5XZRroc8SsOumL4TvMuO6pfr3bK+rVsey0YIO0WmRDrq6t+h8DSrOzc6O68yIT8IBcwgugwz+4Ioo8+qCabumQpt/rIKNYn5P4l1w8rz0nMC3bLOjbkeW1PDa0C8iJw/E7jX+NeeKcrK813wgCvE0ICMkBDa4KUX+2GGpvvg2AdVLciRdAWZ7E3fCBAqmOITeR5Vj1ILlhQDD+6cre0HdPr5eQnibzMloB5HMujCzc/PbR4/y9yWTv1njsMDrJq8xE9dRiBHsXF+HzkHqNBodXVYek7/hyY39z98wwEmJTfWv/hSqjJ+nOjVWAOr6+E8pIk8kXtq3B0S+VBvxrCIG0sFxMrVOnp539WkyIz+Okt6xWpQkEFeTie+92BFQyl10B8eH8lsdrzQ30ClKnb31hhCIhAk0OGgaV/73jjtlZH0WCV1SgPsdxQlSkhPkyT8u4qGwNFv51P9Qrctu2kYeMaON2IGkfrxE+kfHbjIufwaelpMpcmgzfI2CbQ/rro6HOXsurdU+gRQnxPolR9zvKxlkHyeoIhlQacXNV/fXYDv7t5GsXJptvC+KfzB6aVidQjBA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(46966006)(40470700004)(36840700001)(316002)(36756003)(110136005)(107886003)(54906003)(6666004)(426003)(356005)(7636003)(2616005)(82740400003)(41300700001)(1076003)(83380400001)(36860700001)(47076005)(336012)(2906002)(186003)(26005)(40480700001)(70586007)(8936002)(70206006)(8676002)(86362001)(30864003)(40460700003)(4326008)(5660300002)(82310400005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 14:55:45.7005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f33606c-e540-4974-228a-08dafc88bde4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5922
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tc miss handling code to en_tc.c, and remove
duplicate code.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++----------------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 221 +++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  11 +-
 4 files changed, 232 insertions(+), 229 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b08339d986d5f..69ff212eaad86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020 Mellanox Technologies. */
 
-#include <net/dst_metadata.h>
 #include <linux/netdevice.h>
 #include <linux/if_macvlan.h>
 #include <linux/list.h>
@@ -665,235 +664,57 @@ void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
 				 mlx5e_rep_indr_block_unbind);
 }
 
-static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
-				 struct mlx5e_tc_update_priv *tc_priv,
-				 u32 tunnel_id)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct tunnel_match_enc_opts enc_opts = {};
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
-	struct metadata_dst *tun_dst;
-	struct tunnel_match_key key;
-	u32 tun_id, enc_opts_id;
-	struct net_device *dev;
-	int err;
-
-	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
-	tun_id = tunnel_id >> ENC_OPTS_BITS;
-
-	if (!tun_id)
-		return true;
-
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
-	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
-	if (err) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
-			   tun_id, err);
-		return false;
-	}
-
-	if (enc_opts_id) {
-		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
-				   enc_opts_id, &enc_opts);
-		if (err) {
-			netdev_dbg(priv->netdev,
-				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
-				   enc_opts_id, err);
-			return false;
-		}
-	}
-
-	if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
-					   key.enc_ip.tos, key.enc_ip.ttl,
-					   key.enc_tp.dst, TUNNEL_KEY,
-					   key32_to_tunnel_id(key.enc_key_id.keyid),
-					   enc_opts.key.len);
-	} else if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
-					     key.enc_ip.tos, key.enc_ip.ttl,
-					     key.enc_tp.dst, 0, TUNNEL_KEY,
-					     key32_to_tunnel_id(key.enc_key_id.keyid),
-					     enc_opts.key.len);
-	} else {
-		netdev_dbg(priv->netdev,
-			   "Couldn't restore tunnel, unsupported addr_type: %d\n",
-			   key.enc_control.addr_type);
-		return false;
-	}
-
-	if (!tun_dst) {
-		netdev_dbg(priv->netdev, "Couldn't restore tunnel, no tun_dst\n");
-		return false;
-	}
-
-	tun_dst->u.tun_info.key.tp_src = key.enc_tp.src;
-
-	if (enc_opts.key.len)
-		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
-					enc_opts.key.data,
-					enc_opts.key.len,
-					enc_opts.key.dst_opt_type);
-
-	skb_dst_set(skb, (struct dst_entry *)tun_dst);
-	dev = dev_get_by_index(&init_net, key.filter_ifindex);
-	if (!dev) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find tunnel device with ifindex: %d\n",
-			   key.filter_ifindex);
-		return false;
-	}
-
-	/* Set fwd_dev so we do dev_put() after datapath */
-	tc_priv->fwd_dev = dev;
-
-	skb->dev = dev;
-
-	return true;
-}
-
-static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
-				    struct mlx5e_tc_update_priv *tc_priv)
-{
-	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
-
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	if (chain) {
-		struct mlx5_rep_uplink_priv *uplink_priv;
-		struct mlx5e_rep_priv *uplink_rpriv;
-		struct tc_skb_ext *tc_skb_ext;
-		struct mlx5_eswitch *esw;
-		u32 zone_restore_id;
-
-		tc_skb_ext = tc_skb_ext_alloc(skb);
-		if (!tc_skb_ext) {
-			WARN_ON(1);
-			return false;
-		}
-		tc_skb_ext->chain = chain;
-		zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
-		esw = priv->mdev->priv.eswitch;
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		uplink_priv = &uplink_rpriv->uplink_priv;
-		if (!mlx5e_tc_ct_restore_flow(uplink_priv->ct_priv, skb,
-					      zone_restore_id))
-			return false;
-	}
-#endif /* CONFIG_NET_TC_SKB_EXT */
-
-	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
-}
-
-static void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
-{
-	if (tc_priv->fwd_dev)
-		dev_put(tc_priv->fwd_dev);
-}
-
-static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *skb,
-				     struct mlx5_mapped_obj *mapped_obj,
-				     struct mlx5e_tc_update_priv *tc_priv)
-{
-	if (!mlx5e_restore_tunnel(priv, skb, tc_priv, mapped_obj->sample.tunnel_id)) {
-		netdev_dbg(priv->netdev,
-			   "Failed to restore tunnel info for sampled packet\n");
-		return;
-	}
-	mlx5e_tc_sample_skb(skb, mapped_obj);
-	mlx5_rep_tc_post_napi_receive(tc_priv);
-}
-
-static bool mlx5e_restore_skb_int_port(struct mlx5e_priv *priv, struct sk_buff *skb,
-				       struct mlx5_mapped_obj *mapped_obj,
-				       struct mlx5e_tc_update_priv *tc_priv,
-				       bool *forward_tx,
-				       u32 reg_c1)
-{
-	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
-
-	/* Tunnel restore takes precedence over int port restore */
-	if (tunnel_id)
-		return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
-
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
-	if (mlx5e_tc_int_port_dev_fwd(uplink_priv->int_port_priv, skb,
-				      mapped_obj->int_port_metadata, forward_tx)) {
-		/* Set fwd_dev for future dev_put */
-		tc_priv->fwd_dev = skb->dev;
-
-		return true;
-	}
-
-	return false;
-}
-
 void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
 			  struct sk_buff *skb)
 {
-	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata);
+	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata), reg_c0, zone_restore_id, tunnel_id;
 	struct mlx5e_tc_update_priv tc_priv = {};
-	struct mlx5_mapped_obj mapped_obj;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5_tc_ct_priv *ct_priv;
+	struct mapping_ctx *mapping_ctx;
 	struct mlx5_eswitch *esw;
-	bool forward_tx = false;
 	struct mlx5e_priv *priv;
-	u32 reg_c0;
-	int err;
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
 	if (!reg_c0 || reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
 		goto forward;
 
-	/* If reg_c0 is not equal to the default flow tag then skb->mark
+	/* If mapped_obj_id is not equal to the default flow tag then skb->mark
 	 * is not supported and must be reset back to 0.
 	 */
 	skb->mark = 0;
 
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
-	err = mapping_find(esw->offloads.reg_c0_obj_pool, reg_c0, &mapped_obj);
-	if (err) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find mapped object for reg_c0: %d, err: %d\n",
-			   reg_c0, err);
-		goto free_skb;
-	}
+	mapping_ctx = esw->offloads.reg_c0_obj_pool;
+	zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
+	tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
 
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
-		if (!mlx5e_restore_skb_chain(skb, mapped_obj.chain, reg_c1, &tc_priv) &&
-		    !mlx5_ipsec_is_rx_flow(cqe))
-			goto free_skb;
-	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
-		mlx5e_restore_skb_sample(priv, skb, &mapped_obj, &tc_priv);
-		goto free_skb;
-	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_INT_PORT_METADATA) {
-		if (!mlx5e_restore_skb_int_port(priv, skb, &mapped_obj, &tc_priv,
-						&forward_tx, reg_c1))
-			goto free_skb;
-	} else {
-		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+	ct_priv = uplink_priv->ct_priv;
+
+	if (!mlx5_ipsec_is_rx_flow(cqe) &&
+	    !mlx5e_tc_update_skb(cqe, skb, mapping_ctx, reg_c0, ct_priv, zone_restore_id, tunnel_id,
+				 &tc_priv))
 		goto free_skb;
-	}
 
 forward:
-	if (forward_tx)
+	if (tc_priv.skb_done)
+		goto free_skb;
+
+	if (tc_priv.forward_tx)
 		dev_queue_xmit(skb);
 	else
 		napi_gro_receive(rq->cq.napi, skb);
 
-	mlx5_rep_tc_post_napi_receive(&tc_priv);
+	if (tc_priv.fwd_dev)
+		dev_put(tc_priv.fwd_dev);
 
 	return;
 
 free_skb:
+	WARN_ON(tc_priv.fwd_dev);
 	dev_kfree_skb_any(skb);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3df455f6b1685..e5faebb4c084e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1792,7 +1792,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb)) {
+		if (!mlx5e_tc_update_skb_nic(cqe, skb)) {
 			dev_kfree_skb_any(skb);
 			goto free_wqe;
 		}
@@ -2256,7 +2256,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb)) {
+		if (!mlx5e_tc_update_skb_nic(cqe, skb)) {
 			dev_kfree_skb_any(skb);
 			goto mpwrq_cqe_out;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4e6f5caf8ab66..6275c451e32a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -43,6 +43,7 @@
 #include <net/ipv6_stubs.h>
 #include <net/bareudp.h>
 #include <net/bonding.h>
+#include <net/dst_metadata.h>
 #include "en.h"
 #include "en/tc/post_act.h"
 #include "en_rep.h"
@@ -5562,47 +5563,221 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
-			 struct sk_buff *skb)
+static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
+				    struct mlx5e_tc_update_priv *tc_priv,
+				    u32 tunnel_id)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
-	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	struct mlx5_mapped_obj mapped_obj;
-	struct tc_skb_ext *tc_skb_ext;
-	struct mlx5e_tc_table *tc;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct tunnel_match_enc_opts enc_opts = {};
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct metadata_dst *tun_dst;
+	struct tunnel_match_key key;
+	u32 tun_id, enc_opts_id;
+	struct net_device *dev;
 	int err;
 
-	reg_b = be32_to_cpu(cqe->ft_metadata);
-	tc = mlx5e_fs_get_tc(priv->fs);
-	chain_tag = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
+	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
+	tun_id = tunnel_id >> ENC_OPTS_BITS;
 
-	err = mapping_find(tc->mapping, chain_tag, &mapped_obj);
+	if (!tun_id)
+		return true;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
 	if (err) {
 		netdev_dbg(priv->netdev,
-			   "Couldn't find chain for chain tag: %d, err: %d\n",
-			   chain_tag, err);
+			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
+			   tun_id, err);
+		return false;
+	}
+
+	if (enc_opts_id) {
+		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
+				   enc_opts_id, &enc_opts);
+		if (err) {
+			netdev_dbg(priv->netdev,
+				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
+				   enc_opts_id, err);
+			return false;
+		}
+	}
+
+	if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
+					   key.enc_ip.tos, key.enc_ip.ttl,
+					   key.enc_tp.dst, TUNNEL_KEY,
+					   key32_to_tunnel_id(key.enc_key_id.keyid),
+					   enc_opts.key.len);
+	} else if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
+					     key.enc_ip.tos, key.enc_ip.ttl,
+					     key.enc_tp.dst, 0, TUNNEL_KEY,
+					     key32_to_tunnel_id(key.enc_key_id.keyid),
+					     enc_opts.key.len);
+	} else {
+		netdev_dbg(priv->netdev,
+			   "Couldn't restore tunnel, unsupported addr_type: %d\n",
+			   key.enc_control.addr_type);
 		return false;
 	}
 
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
-		chain = mapped_obj.chain;
+	if (!tun_dst) {
+		netdev_dbg(priv->netdev, "Couldn't restore tunnel, no tun_dst\n");
+		return false;
+	}
+
+	tun_dst->u.tun_info.key.tp_src = key.enc_tp.src;
+
+	if (enc_opts.key.len)
+		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
+					enc_opts.key.data,
+					enc_opts.key.len,
+					enc_opts.key.dst_opt_type);
+
+	skb_dst_set(skb, (struct dst_entry *)tun_dst);
+	dev = dev_get_by_index(&init_net, key.filter_ifindex);
+	if (!dev) {
+		netdev_dbg(priv->netdev,
+			   "Couldn't find tunnel device with ifindex: %d\n",
+			   key.filter_ifindex);
+		return false;
+	}
+
+	/* Set fwd_dev so we do dev_put() after datapath */
+	tc_priv->fwd_dev = dev;
+
+	skb->dev = dev;
+
+	return true;
+}
+
+static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
+				       u32 chain, u32 zone_restore_id,
+				       u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
+{
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	struct tc_skb_ext *tc_skb_ext;
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	if (chain) {
+		if (!mlx5e_tc_ct_restore_flow(ct_priv, skb, zone_restore_id))
+			return false;
+
 		tc_skb_ext = tc_skb_ext_alloc(skb);
-		if (WARN_ON(!tc_skb_ext))
+		if (!tc_skb_ext) {
+			WARN_ON(1);
 			return false;
+		}
 
 		tc_skb_ext->chain = chain;
+	}
+#endif /* CONFIG_NET_TC_SKB_EXT */
 
-		zone_restore_id = (reg_b >> MLX5_REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
-			ESW_ZONE_ID_MASK;
+	if (tc_priv)
+		return mlx5e_tc_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 
-		if (!mlx5e_tc_ct_restore_flow(tc->ct, skb,
-					      zone_restore_id))
-			return false;
-	} else {
+	return true;
+}
+
+static void mlx5e_tc_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *skb,
+					struct mlx5_mapped_obj *mapped_obj,
+					struct mlx5e_tc_update_priv *tc_priv)
+{
+	if (!mlx5e_tc_restore_tunnel(priv, skb, tc_priv, mapped_obj->sample.tunnel_id)) {
+		netdev_dbg(priv->netdev,
+			   "Failed to restore tunnel info for sampled packet\n");
+		return;
+	}
+	mlx5e_tc_sample_skb(skb, mapped_obj);
+}
+
+static bool mlx5e_tc_restore_skb_int_port(struct mlx5e_priv *priv, struct sk_buff *skb,
+					  struct mlx5_mapped_obj *mapped_obj,
+					  struct mlx5e_tc_update_priv *tc_priv,
+					  u32 tunnel_id)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	bool forward_tx = false;
+
+	/* Tunnel restore takes precedence over int port restore */
+	if (tunnel_id)
+		return mlx5e_tc_restore_tunnel(priv, skb, tc_priv, tunnel_id);
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	if (mlx5e_tc_int_port_dev_fwd(uplink_priv->int_port_priv, skb,
+				      mapped_obj->int_port_metadata, &forward_tx)) {
+		/* Set fwd_dev for future dev_put */
+		tc_priv->fwd_dev = skb->dev;
+		tc_priv->forward_tx = forward_tx;
+
+		return true;
+	}
+
+	return false;
+}
+
+bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
+			 struct mapping_ctx *mapping_ctx, u32 mapped_obj_id,
+			 struct mlx5_tc_ct_priv *ct_priv,
+			 u32 zone_restore_id, u32 tunnel_id,
+			 struct mlx5e_tc_update_priv *tc_priv)
+{
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	struct mlx5_mapped_obj mapped_obj;
+	int err;
+
+	err = mapping_find(mapping_ctx, mapped_obj_id, &mapped_obj);
+	if (err) {
+		netdev_dbg(skb->dev,
+			   "Couldn't find mapped object for mapped_obj_id: %d, err: %d\n",
+			   mapped_obj_id, err);
+		return false;
+	}
+
+	switch (mapped_obj.type) {
+	case MLX5_MAPPED_OBJ_CHAIN:
+		return mlx5e_tc_restore_skb_chain(skb, ct_priv, mapped_obj.chain, zone_restore_id,
+						  tunnel_id, tc_priv);
+	case MLX5_MAPPED_OBJ_SAMPLE:
+		mlx5e_tc_restore_skb_sample(priv, skb, &mapped_obj, tc_priv);
+		tc_priv->skb_done = true;
+		return true;
+	case MLX5_MAPPED_OBJ_INT_PORT_METADATA:
+		return mlx5e_tc_restore_skb_int_port(priv, skb, &mapped_obj, tc_priv, tunnel_id);
+	default:
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
+
+	return false;
+}
+
+bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	u32 mapped_obj_id, reg_b, zone_restore_id;
+	struct mlx5_tc_ct_priv *ct_priv;
+	struct mapping_ctx *mapping_ctx;
+	struct mlx5e_tc_table *tc;
+
+	reg_b = be32_to_cpu(cqe->ft_metadata);
+	tc = mlx5e_fs_get_tc(priv->fs);
+	mapped_obj_id = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
+	zone_restore_id = (reg_b >> MLX5_REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
+			  ESW_ZONE_ID_MASK;
+	ct_priv = tc->ct;
+	mapping_ctx = tc->mapping;
+
+	return mlx5e_tc_update_skb(cqe, skb, mapping_ctx, mapped_obj_id, ct_priv, zone_restore_id,
+				   0, NULL);
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ce516dc7f3fde..4fa5d4e024cd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -59,6 +59,8 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
 struct mlx5e_tc_update_priv {
 	struct net_device *fwd_dev;
+	bool skb_done;
+	bool forward_tx;
 };
 
 struct mlx5_nic_flow_attr {
@@ -386,14 +388,19 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 	return false;
 }
 
-bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
+bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
+bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
+			 struct mapping_ctx *mapping_ctx, u32 mapped_obj_id,
+			 struct mlx5_tc_ct_priv *ct_priv,
+			 u32 zone_restore_id, u32 tunnel_id,
+			 struct mlx5e_tc_update_priv *tc_priv);
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline struct mlx5e_tc_table *mlx5e_tc_table_alloc(void) { return NULL; }
 static inline void mlx5e_tc_table_free(struct mlx5e_tc_table *tc) {}
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 { return false; }
 static inline bool
-mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
+mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
 { return true; }
 #endif
 
-- 
2.30.1

