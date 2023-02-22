Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6AA69ED27
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjBVC6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjBVC55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:57:57 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02hn2211.outbound.protection.outlook.com [52.100.160.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC72A76AD;
        Tue, 21 Feb 2023 18:57:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkuA0bFW7+tVeZEl81+kzmIr/gASXdkuJq75G3ISyzgJ4IaMcwIpb1RGRrWkY2r5p8PUf9obscmc+tBDzB7V+OevJXz9Kw63eGA654O4W0jCgIwmnMDaC+ZoXdpRndbG6Fs0DRO71xKdjixOWxhVIrOvn8YDH8g2FxdhnAh8LWz5vK85E0kr4irWr/OKz7PZ13EWta8cn4gBwpMlN2MLeiliGqtMZkLHhnY1nFi2on7axjaG4hH+B/C30YwmszhrLARddoGTUUvZOF1rpuukTF96zECK7rsh8TAxRBc0sLrpGUAcAtL1iVMhcZtjwRcVinqX2WMPh5cOGoBXuvmonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxNvmuJUNDx5oktodj60XeuXvFgWkxaDwRqPCIDRZnY=;
 b=mbDVUNJL2YK3G1/LxmsNYpAbHVKbdFM+MEG/4Vdn9mML6jYApgjynyugJZsPX9c/u01FVpbIiC+UnytVFvodwPkV/lZt2qgeuzgS7Q38/oORmQ3+LWknAvcejo4nCBZN/JtoUi2pyrXVW2/9h4s/YUKW2kEoQaJuDsBoQQxzUbK0ivMELf3DaVZacA2Bthq1PJy/7Hb2m042C9ZWsvPVv6tW/Djt2iBE4O/zONgUMUYuZ6wk/4LZIwFF7rTtNVi5sWwTfvBwS2E1sEjrbwJ5sJs0sOIHO0CyPamwRDar9x3LMFF09dBMr4SBKBogFVJ9JnrV/MciBYHVIIHU02I+WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxNvmuJUNDx5oktodj60XeuXvFgWkxaDwRqPCIDRZnY=;
 b=EAVNYp1FxQN7gnyTGnh/a/9KFZnqwIdmnqzKVboag4CcDN2+SMocGBrodN2GFUiJ6kXIWI+RLqZqDak5xJUM/jaArifDa0nVvlIkaVWmTrj1KRUYePMzI9jBTZMw1WApdyyLGjjOdEYtL7oBK+U0p31ffs3Oz2K5IQCMvz4UEa6WRgWlXlbCeg04yvoIcg5K9oqBaKAHRdcAzsnU4b+7FXP0q1S0fhY8yKKPcbDuGuIeS1g5JlhItzCo6uXKpXGi1h/rFrQ8qUZOYcub890Xye4c59/5weMyo3n1JUj4S9NQRPUtkXTk05VGx/IeoE5nInHaeMvQs8N3SIfoqy+CNQ==
Received: from DS7PR03CA0108.namprd03.prod.outlook.com (2603:10b6:5:3b7::23)
 by IA1PR12MB6042.namprd12.prod.outlook.com (2603:10b6:208:3d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Wed, 22 Feb
 2023 02:57:53 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::4c) by DS7PR03CA0108.outlook.office365.com
 (2603:10b6:5:3b7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21 via Frontend
 Transport; Wed, 22 Feb 2023 02:57:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.17 via Frontend Transport; Wed, 22 Feb 2023 02:57:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:38 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 21 Feb
 2023 18:57:34 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v4 4/4] net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
Date:   Wed, 22 Feb 2023 04:56:53 +0200
Message-ID: <20230222025653.20425-5-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230222025653.20425-1-gavinl@nvidia.com>
References: <20230222025653.20425-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT061:EE_|IA1PR12MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: d7525812-7837-45dd-03b4-08db148097a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FYGbFdqZ+RgtSunNTkva//8MBWqqY2tqy+j2FC3oMN2WWv3rc2LqUKuuO6KGjlx8oc9p49rvVR5jRrvHBTSdS1SsrcjseisjfZtAUgIdN+xpm2Sxq/nSZAhXMo+YrriQ5aZLAFIoQQ74lrRTVrf7JecvYNW9/JprPSO4+ET3gn93QEqqbzUvCBEwnVGFWdPjMfVQmvUtlAHVscmsLprNUo1BaT7cc16qvZngSImasOipghAh9H+wU61WNwWAPYFMRVXZ+ZSbjuILr7X3ck7qcbkRKqKaVyVSFKbFHaI/MNR4gTKJthU9XfAeaaPeahGcg2YMD/iUKBkdk0wOIVNy0wbJDcoYE1WSXb1Cde8GMVsQplwOg7Kb53vnUXXcILdVZIT5p0UE4A275aBfy9ZByowDi0dZg59tHpsDPDfg+r6PDM4+D4gVHOf+FLdE3xfDagcuueOFcekq7hV0MWkCwYUKa2BoSMwo0gZ9y3v1pGCsxBNimeHONKLPWWSETibw6n/ba5BqXjDsDjo9fsMhiL8p6dAQ9TvJxGOI5eZ4zfeiQ1hjicm+OT9W/JvQsZQRDw38akBespkw0WQeM5Ah4alCbkSwpNT5gnmkbuE0f0X65e3vMyRezCaSHfGJndESgKAfWauyc4mL0eTfEbltbeDW4XJ7wQrQ6xbdwEP0qWhBTGoBNU8hnBO1MlOhNMHBRNKcDIt0ESVRfwm/OQsUIvakZAMeX+fTDYMn/hsjvQlpAmdePo4yxKXjvls5hPDPS8mWNk3xapYOU0fPG/oxw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199018)(5400799012)(46966006)(36840700001)(40470700004)(41300700001)(186003)(54906003)(316002)(47076005)(110136005)(36860700001)(7636003)(336012)(2616005)(426003)(83380400001)(1076003)(2906002)(34070700002)(16526019)(40460700003)(478600001)(4326008)(8676002)(70206006)(26005)(70586007)(6666004)(6286002)(8936002)(7696005)(36756003)(356005)(40480700001)(82310400005)(82740400003)(86362001)(55016003)(5660300002)(12100799015);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 02:57:53.3932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7525812-7837-45dd-03b4-08db148097a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6042
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add HW offloading support for TC flows with VxLAN GBP encap/decap.

Example of encap rule:
tc filter add dev eth0 protocol ip ingress flower \
    action tunnel_key set id 42 vxlan_opts 512 \
    action mirred egress redirect dev vxlan1

Example of decap rule:
tc filter add dev vxlan1 protocol ip ingress flower \
    enc_key_id 42 enc_dst_port 4789 vxlan_opts 1024 \
    action tunnel_key unset action mirred egress redirect dev eth0

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 3 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 1f62c702b625..8ee5d9e67e0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2018 Mellanox Technologies. */
 
+#include <net/ip_tunnels.h>
 #include <net/vxlan.h>
 #include "lib/vxlan.h"
 #include "en/tc_tun.h"
@@ -86,9 +87,11 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
 	__be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
 	struct udphdr *udp = (struct udphdr *)(buf);
+	struct vxlan_metadata *md;
 	struct vxlanhdr *vxh;
 
-	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+	if ((tun_key->tun_flags & TUNNEL_VXLAN_OPT) &&
+	    e->tun_info->options_len != sizeof(*md))
 		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
@@ -96,6 +99,61 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	udp->dest = tun_key->tp_dst;
 	vxh->vx_flags = VXLAN_HF_VNI;
 	vxh->vx_vni = vxlan_vni_field(tun_id);
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
+		md = ip_tunnel_info_opts((struct ip_tunnel_info *)e->tun_info);
+		vxlan_build_gbp_hdr(vxh, md);
+	}
+
+	return 0;
+}
+
+static int mlx5e_tc_tun_parse_vxlan_gbp_option(struct mlx5e_priv *priv,
+					       struct mlx5_flow_spec *spec,
+					       struct flow_cls_offload *f)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct flow_match_enc_opts enc_opts;
+	void *misc5_c, *misc5_v;
+	u32 *gbp, *gbp_mask;
+
+	flow_rule_match_enc_opts(rule, &enc_opts);
+
+	if (memchr_inv(&enc_opts.mask->data, 0, sizeof(enc_opts.mask->data)) &&
+	    !MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(priv->mdev, tunnel_header_0_1)) {
+		NL_SET_ERR_MSG_MOD(extack, "Matching on VxLAN GBP is not supported");
+		netdev_warn(priv->netdev, "Matching on VxLAN GBP is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
+		NL_SET_ERR_MSG_MOD(extack, "Wrong VxLAN option type: not GBP");
+		netdev_warn(priv->netdev, "Wrong VxLAN option type: not GBP\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->len != sizeof(*gbp) ||
+	    enc_opts.mask->len != sizeof(*gbp_mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN GBP option/mask len is not 32 bits");
+		netdev_warn(priv->netdev, "VxLAN GBP option/mask len is not 32 bits\n");
+		return -EINVAL;
+	}
+
+	gbp = (u32 *)&enc_opts.key->data[0];
+	gbp_mask = (u32 *)&enc_opts.mask->data[0];
+
+	if (*gbp_mask & ~VXLAN_GBP_MASK) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
+		netdev_warn(priv->netdev, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
+		return -EINVAL;
+	}
+
+	misc5_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_5);
+	misc5_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_5);
+	MLX5_SET(fte_match_set_misc5, misc5_c, tunnel_header_0, *gbp_mask);
+	MLX5_SET(fte_match_set_misc5, misc5_v, tunnel_header_0, *gbp);
+
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_5;
 
 	return 0;
 }
@@ -122,6 +180,14 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	if (!enc_keyid.mask->keyid)
 		return 0;
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS)) {
+		int err;
+
+		err = mlx5e_tc_tun_parse_vxlan_gbp_option(priv, spec, f);
+		if (err)
+			return err;
+	}
+
 	/* match on VNI is required */
 
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
@@ -143,6 +209,12 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static bool mlx5e_tc_tun_encap_info_equal_vxlan(struct mlx5e_encap_key *a,
+						struct mlx5e_encap_key *b)
+{
+	return mlx5e_tc_tun_encap_info_equal_options(a, b, TUNNEL_VXLAN_OPT);
+}
+
 static int mlx5e_tc_tun_get_remote_ifindex(struct net_device *mirred_dev)
 {
 	const struct vxlan_dev *vxlan = netdev_priv(mirred_dev);
@@ -160,6 +232,6 @@ struct mlx5e_tc_tunnel vxlan_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_vxlan,
 	.parse_udp_ports      = mlx5e_tc_tun_parse_udp_ports_vxlan,
 	.parse_tunnel         = mlx5e_tc_tun_parse_vxlan,
-	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_generic,
+	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_vxlan,
 	.get_remote_ifindex   = mlx5e_tc_tun_get_remote_ifindex,
 };
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 71b06ebad402..af4dd536a52c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1357,6 +1357,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_ESW_INGRESS_ACL_MAX(mdev, cap) \
 	MLX5_CAP_ESW_FLOWTABLE_MAX(mdev, flow_table_properties_esw_acl_ingress.cap)
 
+#define MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(mdev, cap) \
+	MLX5_CAP_ESW_FLOWTABLE(mdev, ft_field_support_2_esw_fdb.cap)
+
+#define MLX5_CAP_ESW_FT_FIELD_SUPPORT_2_MAX(mdev, cap) \
+	MLX5_CAP_ESW_FLOWTABLE_MAX(mdev, ft_field_support_2_esw_fdb.cap)
+
 #define MLX5_CAP_ESW(mdev, cap) \
 	MLX5_GET(e_switch_cap, \
 		 mdev->caps.hca[MLX5_CAP_ESWITCH]->cur, cap)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1e530a8a2cf5..caef6aa20454 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -399,10 +399,13 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         metadata_reg_c_0[0x1];
 };
 
+/* Table 2170 - Flow Table Fields Supported 2 Format */
 struct mlx5_ifc_flow_table_fields_supported_2_bits {
 	u8         reserved_at_0[0xe];
 	u8         bth_opcode[0x1];
-	u8         reserved_at_f[0x11];
+	u8         reserved_at_f[0x1];
+	u8         tunnel_header_0_1[0x1];
+	u8         reserved_at_11[0xf];
 
 	u8         reserved_at_20[0x60];
 };
@@ -890,7 +893,13 @@ struct mlx5_ifc_flow_table_eswitch_cap_bits {
 
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_esw_acl_egress;
 
-	u8      reserved_at_800[0x1000];
+	u8      reserved_at_800[0xC00];
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_support_2_esw_fdb;
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_bitmask_support_2_esw_fdb;
+
+	u8      reserved_at_1500[0x300];
 
 	u8      sw_steering_fdb_action_drop_icm_address_rx[0x40];
 
-- 
2.31.1

