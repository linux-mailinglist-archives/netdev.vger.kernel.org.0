Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D51768C508
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjBFRow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjBFRos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:44:48 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E7D2B2A8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:44:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrmhqPD/gJ4PV9xGvhFdyWTPNy+jlePD/Jeyileu18qIBRtRLq6+fXa/UMqO433iNXpS3awCjmlNRf4WE1nQJ0Hg0F+799ZHJLjGr7BmW/1pjClkp2VwKLlE5POJRA8TwwBk+U9FbStGWCqbpBA7tXtH+ijXoLsJsNjpLrHAbePLJTOwdmXmLwFerVt6t2MMvgIdtAUKWQvlJb7qjghuH26EvJAKbxPeyJKkX5CiqghVjOozH1jl74o8OwXL1WnRuwI1ljMYpSJzj5LhbadozzEBfeKaT3vI1m27vs4JKXqDCtUleTs7Yq3c2yL0ntdcZrmb7TVhMm4ObT7zD415AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8d+c4VeSCRXpMVkCN5MHYS0imdcXmyvzKG6MHIThRWI=;
 b=UG0dfmrxUywBTYLzTdk8+71F66hmi7Wrh4PboL+LtKGe8LsW6bi/hgD1giTyLoA1tHpYlGDpdqQwBOzB1rsS/WjwveuIxqwm2QBxLPpGfA7QvUh4bJlcEVGU6qOJy4UhcTghg/or2qnGbtmCGQj5BdHRf1xjucUrwqOg56QxzI2/PzpT2jgSYKc8mDaF3YEP9Tgk6rX6zKDVl8KTn5Z905wIGeGza00bG9yHGnhCRFxt9/Nmvwg319k3hLR8ut3jku7F7khkJgOFvV0OKvZ5/sZXs9w5914s1vp5EL0GY4Xvn7Q4ZzT3Vh7HAxFV91e2YhAyKr8HtPY+3Olvp11vEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8d+c4VeSCRXpMVkCN5MHYS0imdcXmyvzKG6MHIThRWI=;
 b=DwmVC/bMf9+17N8vtQ0isJFSPVUrUSkGfPQhx3s3OzQhberDYeX+84G2RT+PhXpAfl3AdHxoFXiZ1Y+8RoH9/MrBXI8ZnvmDyIb0tH7GOUokpbmkIQeugtO/85kaCgTmvtRgphlj0YIIMSqmVkFLczsr6qxtzcWjCU05DIwGUhvUHfUaQ/omvPqcZEwk4XTdVfBNYCigZ2/ct5Y1J2bpfsZkA5MW7DKBBKei/0qIcgUMNcsXiogMLYbImIFI1Fy8p2HA6zxR3pEE149kTpH4PXdkDrUYmiAdtV07JMJR+gGN6rOeuFJzKNcDpKTdHyniyf7shRWsKN4VBBLK9hN1fw==
Received: from DM5PR07CA0073.namprd07.prod.outlook.com (2603:10b6:4:ad::38) by
 BY5PR12MB4869.namprd12.prod.outlook.com (2603:10b6:a03:1d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:44:35 +0000
Received: from DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::b6) by DM5PR07CA0073.outlook.office365.com
 (2603:10b6:4:ad::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 17:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT091.mail.protection.outlook.com (10.13.173.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 17:44:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:44:27 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 09:44:27 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 09:44:23 -0800
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
Subject: [PATCH net-next v9 5/7] net/mlx5: Refactor tc miss handling to a single function
Date:   Mon, 6 Feb 2023 19:44:01 +0200
Message-ID: <20230206174403.32733-6-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206174403.32733-1-paulb@nvidia.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT091:EE_|BY5PR12MB4869:EE_
X-MS-Office365-Filtering-Correlation-Id: dda69025-62a3-4537-4482-08db0869cff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tVuL6cKBm4A9vmMAFX5Hn/XhRIqHtpTvi4LfzsuM5ROu0+WOtlCBIlBwmFXEeEGP0xrQl18YTxyay1qDlnQ0pomwgqNdqvmLskejfSM4jxyAKZ589TrpkwGV37IOvnrHBdHZac3+qCj/vY1bgQx7ONF4qPs4b5lfnwVY7UXdP6eGUIXeUwMDJ4HNm3Pdd1tjSCktbra6jPWyVJ5jzeTTYebZdSZLEFP/VuDvKrlFhOjUgYlpZVzpCi2kFmMoRnPa7js5bOHk/NpIN9/2OUJ5DzYOh+/RAWExBiITcyK9Aqeujo7CYWyLLt52C1oyyUZnVzQAqQK8IiSFNHGFFeqHRFJWemUYzjgMUhkppZLqagunLjIaSw48ENCQv7EFV52Cil9qz2EfaqoT/VxwdCzEVb3B84OBzZHVtI4yOS4B7csWw806BTa2sql+dkrFwt2rqHnsmVfvi5fIc7cVlCc0pQRTDDqbuXqpzPXiPfo9LvnbDb8nSfE9Qb+11qp4nGmcK/DZ72qrjdJ/MNp5pQ+UJ+FulBjwEX/48oawftEcOWKHTTWmHNjTvmx0qbT4MnsEVvVZt6LGl1SH5jS10HrMn0EhrpwCfeLkq+d+KOp+haldh+IDYMOP1NXQO5Qc83DoOdag4SeGRRsA+0BPB7T/bqbCexK+tfWgtel8mCGx+m4=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(46966006)(36840700001)(478600001)(110136005)(316002)(54906003)(30864003)(1076003)(107886003)(186003)(2616005)(26005)(82310400005)(36756003)(5660300002)(6666004)(86362001)(82740400003)(426003)(40480700001)(7636003)(83380400001)(47076005)(336012)(70206006)(2906002)(4326008)(8676002)(70586007)(356005)(8936002)(36860700001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:44:35.4062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dda69025-62a3-4537-4482-08db0869cff2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4869
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 223 ++----------------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 220 +++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  11 +-
 4 files changed, 231 insertions(+), 227 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index fcb4cf526727..0b84665989fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020 Mellanox Technologies. */
 
-#include <net/dst_metadata.h>
 #include <linux/netdevice.h>
 #include <linux/if_macvlan.h>
 #include <linux/list.h>
@@ -665,230 +664,54 @@ void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
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
+	u32 reg_c0, reg_c1, zone_restore_id, tunnel_id;
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
+	reg_c1 = be32_to_cpu(cqe->ft_metadata);
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
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a9473a51edc1..fea0c2aa95e2 100644
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
@@ -2259,7 +2259,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb)) {
+		if (!mlx5e_tc_update_skb_nic(cqe, skb)) {
 			dev_kfree_skb_any(skb);
 			goto mpwrq_cqe_out;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b173c7e9e553..a6399dc870c2 100644
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
@@ -5562,46 +5563,219 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
-			 struct sk_buff *skb)
+static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
+				    struct mlx5e_tc_update_priv *tc_priv,
+				    u32 tunnel_id)
 {
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
+
+	if (!tun_id)
+		return true;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
 
-	err = mapping_find(tc->mapping, chain_tag, &mapped_obj);
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
+	switch (key.enc_control.addr_type) {
+	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
+		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
+					   key.enc_ip.tos, key.enc_ip.ttl,
+					   key.enc_tp.dst, TUNNEL_KEY,
+					   key32_to_tunnel_id(key.enc_key_id.keyid),
+					   enc_opts.key.len);
+		break;
+	case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
+		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
+					     key.enc_ip.tos, key.enc_ip.ttl,
+					     key.enc_tp.dst, 0, TUNNEL_KEY,
+					     key32_to_tunnel_id(key.enc_key_id.keyid),
+					     enc_opts.key.len);
+		break;
+	default:
+		netdev_dbg(priv->netdev,
+			   "Couldn't restore tunnel, unsupported addr_type: %d\n",
+			   key.enc_control.addr_type);
+		return false;
+	}
+
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
 		return false;
 	}
 
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
-		chain = mapped_obj.chain;
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
 
-	return true;
+	return false;
+}
+
+bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
+{
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
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ee9c8f31491e..1c52c8915c3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -59,6 +59,8 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
 struct mlx5e_tc_update_priv {
 	struct net_device *fwd_dev;
+	bool skb_done;
+	bool forward_tx;
 };
 
 struct mlx5_nic_flow_attr {
@@ -384,14 +386,19 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
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

