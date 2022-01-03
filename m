Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2DD4830B2
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbiACLpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:45:19 -0500
Received: from mail-bn7nam10on2040.outbound.protection.outlook.com ([40.107.92.40]:33120
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231809AbiACLpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 06:45:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7tWVof+P1X8NiQEPFK4QJXIC9APm31P8fPL3ul90UZcYPerSgo6aQSaR/1s5oJbvIT05dFiCVuGwUxPX4jQkx3aSgPeI8W0CjlMX+wpg3C83hDahEcZyFE+7NJLmXhzn5jWpc7TPJ2bhzzGvn9krCQon1baA2r+Buxt8R0EZw2vp67Qr8GTg6dAsdzDmstSrBjoV3EaktMesnDmypgYTM5MXNWMsRp7DMlCB22v470xlSk/Uy+dEjCMccWRSB/Y2NEQJq7yRnKs+ztOOf3GGmfiwQdxIK1Wi/SiloKVoiBsB47EnWaju2bMIbLl8vBm6/oAZGj0GoQqzcFzceVpQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uz/tKL2L80XwjWxRKoTmS22LDEh498cAXW6862kQbjc=;
 b=JHW1S7Ry9CYShsNFd4ChDCTqCAByjBF55VYfmHbDE8KF8knpC9/xhRNGj0yvLdwVgI/gZY4GMG6e2VWPE7l7AGJM6EbBToWA5z9chiI0J87rtcPGO08XSyeuZWxluCLp8sqXR6ctrG6yBxemLJ2SYz710DByO2XaqnuOgf+eVASEODY2y2Lh6n5AYSmxnjSB3X63LAPzGJGHd9hyWNMBWLSua6eHIJPDwyFfk2Z73bay2DwDZyXMaAYZIiPxsXS1CP3YjVndPLOurfkcD5cuAoYkrLhVfHSJeKKmqp/7MXYPB9OwgmrlLZic946/CzhBlJQJsKmlaNnR91g7fu1fsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uz/tKL2L80XwjWxRKoTmS22LDEh498cAXW6862kQbjc=;
 b=jA/m0dtS+t6cLNfmzK4xVadvAmCwZy3Hf9iB0J/tMvcSHZ4yFgc9Nrhq7jiUtAMK6VnSIDdQtE76/u35VRFGxkoN9zsVP98Hjgego9E/tFQAaBCxDjZ1IcQLBShJedbs6RBl3Yi2UdugucZct4uj0EafrS6ccKy9VAje3AXsDFtdIla/qy1NUjIJjzWufQ2+QQ4gOSRwE0ywhCgtempZcejGGJosdmrcJssBw12kdyU8l2Ei7XcJeMmeBTafvECMJ8PMhR/P80Y9fJ5LH9vhfiaYqO6GbhzefhxzQ9VInh6Uv3lB5m5kmqbQO7izQxopaU0c6SDrtodG2+4BZew3/A==
Received: from DM5PR17CA0050.namprd17.prod.outlook.com (2603:10b6:3:13f::12)
 by DM6PR12MB3628.namprd12.prod.outlook.com (2603:10b6:5:3d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 11:45:13 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::f) by DM5PR17CA0050.outlook.office365.com
 (2603:10b6:3:13f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Mon, 3 Jan 2022 11:45:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Mon, 3 Jan 2022 11:45:11 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:45:09 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 3 Jan
 2022 11:45:09 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Mon, 3 Jan 2022 11:45:06 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 3/3] net/mlx5: CT: Set flow source hint from provided tuple device
Date:   Mon, 3 Jan 2022 13:44:52 +0200
Message-ID: <20220103114452.406-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220103114452.406-1-paulb@nvidia.com>
References: <20220103114452.406-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11b86af0-3f6c-475e-7321-08d9ceae803a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3628:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3628EA9184FAB7948745AB88C2499@DM6PR12MB3628.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u4naH+cwjb4sKzqVzR16d0TfKFbgX1Ag0TYnYtN37vjVqoZxuHcuNKBYzCkUrkluf+3uQZUQhSi5jIHxbyunDHstQhqJoxB4FLJXl1DVOajtNNynPsKwRHfmyM6TMyMz5lW43m5R8RQNd7SAw2xj7ukG2wcfha/yBX5os/A9Ar/lLliE3B6yYLgB7nuaRTOFkmtgkfeJ2R9RNWpfwaNFNl0nvSgfC5xgDQi3lClhAMTJQJU1EJvR6qSe7iMIXDsUgAHcVsrYN5d3S0n7QX7NIk5YT1CRaMOA4yQxndBL+8LiaYcQX6pEHEYs3zNfy/Ds6RwY1bPsEY14SPLBdSNRdhA3DiA/0t4ebmGxJyMoL7A8+J11CatUncTldtmhGnWI3GHeSXww3cy8dWazcETw9HakCOT6IhhokXRd9B/cKpigWMcDydQVIo2O8Czury+HGvCXs5C3/bwQExbQcN8R2wKxhUs2HLhvGKow1kr4QkmN6M6ww6+0kGKy3suIHbk3DIpCAquRxBqkT3o2ooQotEOXjidx8yHkCx63xclm/od4iFOYNmBAYuWyQVcVpm5Ara5lldi4tn/mKCcrt29oEadPuNgVVz7bXCA9RQHvSKa1pKZ3f3UFh7BSA0lEbWaMuGgDwELz7UYoTLPMZmgS8HY0IB0Rloy0e4HwnbS1eyyr+emHHfYn8garAbTwEA5SyHudY/Ur6381JOqVjw3qPrA5Qs6cSdY9AFY7EbHp3CzHd7UzVBjwhG+cRNkbISvCWM0dwCYszE/7F8CpLwL8g6HvwX9G/l3XQVYQxTkmNVPxT5ma00U2Cw9tyOUYg3Js
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(40460700001)(36860700001)(356005)(1076003)(36756003)(81166007)(110136005)(47076005)(83380400001)(82310400004)(8936002)(8676002)(186003)(508600001)(4326008)(54906003)(107886003)(921005)(70206006)(6666004)(26005)(70586007)(86362001)(2906002)(426003)(336012)(2616005)(5660300002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 11:45:11.9019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b86af0-3f6c-475e-7321-08d9ceae803a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3628
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get originating device from tuple offload metadata match ingress_ifindex,
and set flow_source hint to either LOCAL for vf/sf reps, UPLINK for
uplink/wire/tunnel devices/bond, or ANY (as before this patch)
for all others.

This allows lower layer (software steering or firmware) to insert the tuple
rule only in one table (either rx or tx) instead of two (rx and tx).

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 51 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 3 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index a8b84d53dfb0..ba6dad97e308 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -538,7 +538,7 @@ int mlx5_rescan_drivers_locked(struct mlx5_core_dev *dev)
 	return add_drivers(dev);
 }
 
-static bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev)
+bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev)
 {
 	u64 fsystem_guid, psystem_guid;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 9f33729e7fc4..4a0d38d219ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -14,6 +14,7 @@
 #include <linux/workqueue.h>
 #include <linux/refcount.h>
 #include <linux/xarray.h>
+#include <linux/if_macvlan.h>
 
 #include "lib/fs_chains.h"
 #include "en/tc_ct.h"
@@ -326,7 +327,33 @@ mlx5_tc_ct_rule_to_tuple_nat(struct mlx5_ct_tuple *tuple,
 }
 
 static int
-mlx5_tc_ct_set_tuple_match(struct mlx5e_priv *priv, struct mlx5_flow_spec *spec,
+mlx5_tc_ct_get_flow_source_match(struct mlx5_tc_ct_priv *ct_priv,
+				 struct net_device *ndev)
+{
+	struct mlx5e_priv *other_priv = netdev_priv(ndev);
+	struct mlx5_core_dev *mdev = ct_priv->dev;
+	bool vf_rep, uplink_rep;
+
+	vf_rep = mlx5e_eswitch_vf_rep(ndev) && mlx5_same_hw_devs(mdev, other_priv->mdev);
+	uplink_rep = mlx5e_eswitch_uplink_rep(ndev) && mlx5_same_hw_devs(mdev, other_priv->mdev);
+
+	if (vf_rep)
+		return MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
+	if (uplink_rep)
+		return MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
+	if (is_vlan_dev(ndev))
+		return mlx5_tc_ct_get_flow_source_match(ct_priv, vlan_dev_real_dev(ndev));
+	if (netif_is_macvlan(ndev))
+		return mlx5_tc_ct_get_flow_source_match(ct_priv, macvlan_dev_real_dev(ndev));
+	if (mlx5e_get_tc_tun(ndev) || netif_is_lag_master(ndev))
+		return MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
+
+	return MLX5_FLOW_CONTEXT_FLOW_SOURCE_ANY_VPORT;
+}
+
+static int
+mlx5_tc_ct_set_tuple_match(struct mlx5_tc_ct_priv *ct_priv,
+			   struct mlx5_flow_spec *spec,
 			   struct flow_rule *rule)
 {
 	void *headers_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
@@ -341,8 +368,7 @@ mlx5_tc_ct_set_tuple_match(struct mlx5e_priv *priv, struct mlx5_flow_spec *spec,
 
 		flow_rule_match_basic(rule, &match);
 
-		mlx5e_tc_set_ethertype(priv->mdev, &match, true, headers_c,
-				       headers_v);
+		mlx5e_tc_set_ethertype(ct_priv->dev, &match, true, headers_c, headers_v);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 match.mask->ip_proto);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
@@ -438,6 +464,23 @@ mlx5_tc_ct_set_tuple_match(struct mlx5e_priv *priv, struct mlx5_flow_spec *spec,
 			 ntohs(match.key->flags));
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
+		struct flow_match_meta match;
+
+		flow_rule_match_meta(rule, &match);
+
+		if (match.key->ingress_ifindex & match.mask->ingress_ifindex) {
+			struct net_device *dev;
+
+			dev = dev_get_by_index(&init_net, match.key->ingress_ifindex);
+			if (dev && MLX5_CAP_ESW_FLOWTABLE(ct_priv->dev, flow_source))
+				spec->flow_context.flow_source =
+					mlx5_tc_ct_get_flow_source_match(ct_priv, dev);
+
+			dev_put(dev);
+		}
+	}
+
 	return 0;
 }
 
@@ -770,7 +813,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
 		attr->esw_attr->in_mdev = priv->mdev;
 
-	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
+	mlx5_tc_ct_set_tuple_match(ct_priv, spec, flow_rule);
 	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
 
 	zone_rule->rule = mlx5_tc_rule_insert(priv, spec, attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index bb677329ea08..6f8baa0f2a73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -305,5 +305,6 @@ static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
 bool mlx5_eth_supported(struct mlx5_core_dev *dev);
 bool mlx5_rdma_supported(struct mlx5_core_dev *dev);
 bool mlx5_vnet_supported(struct mlx5_core_dev *dev);
+bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev);
 
 #endif /* __MLX5_CORE_H__ */
-- 
2.30.1

