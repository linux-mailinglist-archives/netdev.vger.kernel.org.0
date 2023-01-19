Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E296E67339E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 09:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjASIZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 03:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjASIYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 03:24:47 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E032366F99
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 00:24:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiJg8SmBoeeeyFe2e8pJNWVpkRNbgIwWTDByVkTmPgxeuma2QSTlMVRaI4Iu7eA4B7SmpKAlAt1rSK4ut7H+mpyyX8dEXXAQ86RfV4kKHl6PmBAUPdyrsoc2U4iBv/DV2zkRYGt/ZBXwgYUnWoKUVxiBv2TOsZdneCZs4+qrxgrobo7eIf2jVKAyCQIjhgaRSo4/2IoPEIjVB4jmDwLnPl0QwRQM3vwG2ozkpjiIMNhh6Y/i4JBLtlPp1jJ0DsbJ8W9YuveqnPHG+1SNnrRea0WPgiVlVwWZR6A6K8yjxvfQbGiKsYpne0Ww6WatUDCW88HddEzeBiJL8toeqTRZcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jDIK8lgneNZYa9mcPMcfu65APOpyiqbh07CvDYC8w8=;
 b=bbhzIYyau3gcPjs6YUeEfS+kuGKri96dnqOb/CJBMjLMrydWEYLSqIic+bzKt/1jBX3rK0blWT96sV0ijN29swKzE4xjboIKXxOVCfnE1ltQWGoW5rrdJbFwIsFuXf1VYxyBZTtmfJViaB2L5OQxN8SzuHgIA+FZWG99CK3KHjORx3cZsYrJyU1OkT554h6leucfU3hQpFjwDrpbiXUp6Gf5xdPkwVm963aUr9OBr4yp9tTzrKJwwGc32MuuG0lA/YOKrw0SZ2Re/Q6eVThHCmQpjvOUNCEQGqn6OLiU86noVUPMFyO9Ydg2jvTbgGJ1IJS6HqWYrBQni5vXGaihsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jDIK8lgneNZYa9mcPMcfu65APOpyiqbh07CvDYC8w8=;
 b=HBRTqUQt3SukaKhnfRY0ni6/lGlrBsAuvvbxqi22fImRMZHDHPUD+xvYwZhay47Ri5C6ffeJQsYaND9GwZNF9qqkyShtwfED8Uwadbo1/vqUaIYY4wzGTGgO7h8lnmyqf6UnYL1RWFHDcBa74oGDEa7E3UK7CCVNJ4wdjIaMX1Yx8F8b9kqyIXJeQZXIOK71zcrQHJHzlLuRGiJ9WKZO6RKjp3QTwoFdr4KZKnwFS9UfwRgEdCNKvJ9SiztM6aymK4xQBmNiWkZaeYuPg3Ph/bDsVFylgOOvb0O3GKJAOsY63DnaAKiVPpUqF9qapZRjswFrY6AUoSz9uIUvpJqQQA==
Received: from MW4P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::34)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 08:24:27 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::d5) by MW4P222CA0029.outlook.office365.com
 (2603:10b6:303:114::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Thu, 19 Jan 2023 08:24:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 08:24:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 00:24:22 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 00:24:21 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Thu, 19 Jan 2023 00:24:18 -0800
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
Subject: [PATCH net-next v3 4/6] net/mlx5: Refactor tc miss handling to a single function
Date:   Thu, 19 Jan 2023 10:23:55 +0200
Message-ID: <20230119082357.21744-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230119082357.21744-1-paulb@nvidia.com>
References: <20230119082357.21744-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT020:EE_|BL1PR12MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db4c20b-1313-47bf-c166-08daf9f6944e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CO/075TE8a5lQO+vJO2QlHEvOoRrj2OAOcHlj2QSRNX5Z/+pskrYLtVx55u4/K1JNW7ufL3zTCZMEdcpAZVhH4GNlP6344QduuuRq51RFAsJt998YpfnOwJHE57X4emShIs6JnnN2myJmG77sDMYI0keYRz6CAk7gnY4k3t7Q3ReW92ytSyp2i2jCZyH4iuPkZCPgVG5Iv30BOGncBdNxYWmr07fIoRW6W8Xq9RT8CcM7m90o/3a7bddaZMRwJ7r8kV+9Yjb/GiVdMwYA7d/uuZCSHZdBOoDZ8IcWh+Z9pl+N8ENk8AWFtY5RVz4YrW9Kl1827oakAfHk6DAIsg+/vD+qZRW9lu4d3rQWWDhh+tD2R+PQHbY4JLeve12bHRCIeB307bPrBg0BwnK69k/2JJYGTDpnlImIGHT9GuQurtWcXip+aJWq91J5Qg0JX80v73OMK16UOt+nZB6/S+SbKx8k+VFW/clzyZb1sNYE8RikkdcpHpHa+Z2Yz6tV4PTaNGrITP+CMxAFEGUavNYTT/LoeoEv5LOs05s0Y6PSbx4n4cn7777nZ5wc1yOvffqkiSgz/oFrK4HCpdq9yFq5sPDhMmRzvLAk9EHih3wLe2372PIM9ixcKtHI9JDHnT+ewer5+QaS+5ZdbSvn7x/QJZMJhJnmyHuHd+cGQewAUcWeaVUiYib3PiK+A9dJlFHSkDmUINe7oG8njKSFaoTgg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(40460700003)(86362001)(107886003)(6666004)(478600001)(36756003)(8936002)(5660300002)(316002)(40480700001)(82740400003)(30864003)(70206006)(70586007)(4326008)(8676002)(41300700001)(36860700001)(356005)(186003)(26005)(2616005)(82310400005)(2906002)(7636003)(83380400001)(1076003)(110136005)(54906003)(47076005)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 08:24:27.0713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db4c20b-1313-47bf-c166-08daf9f6944e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
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
index 0c04a5e7c2746..0cd788c6e76a5 100644
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
@@ -5592,47 +5593,221 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
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
index 50af70ef22f3c..e574efff85eb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -59,6 +59,8 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
 struct mlx5e_tc_update_priv {
 	struct net_device *fwd_dev;
+	bool skb_done;
+	bool forward_tx;
 };
 
 struct mlx5_nic_flow_attr {
@@ -382,14 +384,19 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
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

