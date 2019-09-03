Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36420A7436
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfICUF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:29 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:21316
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726946AbfICUFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oadc0r0/bBiCvHoWjkGl4rgMMJTAi0QMuxKa8B1BZC3ULnFVCYb8htuH+aBzhUcrdMTd3Imn0Z8tolxKM+FgsAfeS9Tg/jdD845vH0kQuHNnObXK/LWKSHxtU45rwx7XykwmMwqfNHinY0XHcxw2WFiFr/cUMWjXCxLOGBgpKJ3BKsc8tYEKsSxGJ1gpVIaCoA+StERrLD+LpAKfS4dZYofytM/93mOXGrv3TWyzx7gpdOFBO3KcYDEuMwkzDFemOJ0PNb1xYybNX9nK9T6/CCDPVbpXDlzkuKSbC71YlvHGqySpNcuE9mM2rCGc8L3Q81SJ4JdVy356jto32miwhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnLCLo8Nxod06zHw8PoV/j/S6ErVJTFxkNoioFPoEBk=;
 b=nkzJWVk+YdOeeM2x8puBBLgmkuisfv+KPpqbB1VJWwYpkXCnayUlv9l4GrLpHEIHBd7H5ktf9qjV3NtMNwOQTgUFjTZe8Adoz9XEVcOKUEyqP7kKoUGEZcYyaT9JDPcnZGq1Fkz9cAQp2HiDw+F10itSxHCGOyjcjsgwTht2o2vod6z8UAylYg3xas0+aeUy7b8vaqUvzG5Omol+12YW4ZsUbCc57YR7RUjJoPNG6q7WQTaHNBJVpzh8+MhV6Uj7PBdSLYCUmTK6Us/9TKF/+Uiep0x/VpC6yyKkG8cKzKb6ouEmStaBZtxaMSsJ2v8yMKg2khh53Zu7xBHrrjRHYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnLCLo8Nxod06zHw8PoV/j/S6ErVJTFxkNoioFPoEBk=;
 b=lZwVFEQN/KPWzgBpbQZ02qYOi7jLr1zGhjG6kbuE6cMf8cbjfKGR5mZUCREvc934ZtSVmy8lZJvk4HaNPaNpeppJJBVQGI0BH+Zq8tnhjqazNpmsrv8w8IIjxVi96qSfKgeHs8BvDlsMEhIrLM/Bgiyk6C+zrOxZjvEXBXKML1k=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:04:46 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:04:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 09/18] net/mlx5: DR, Expose steering matcher
 functionality
Thread-Topic: [net-next V2 09/18] net/mlx5: DR, Expose steering matcher
 functionality
Thread-Index: AQHVYpLV4Q/+iex1F02mNYgzImaJhQ==
Date:   Tue, 3 Sep 2019 20:04:46 +0000
Message-ID: <20190903200409.14406-10-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 467fe27a-5759-4683-092a-08d730a9f7a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2706A116575842A4155F3D91BEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:250;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(14444005)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(30864003)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(53946003)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cW6ADJyOfJGUjJDF1xBQtRO6J0r/EHAmfAT31pjCF6GhI1EKkG06AI7FXvZrEhhlwHkbhqhQPUP52aTDi9osSFXiHEga5eJDZpZZTnyKGF8EabAyTkapEJg8zSPngsDJryQHNKCOeOrOivSIk2XkuF2AJS8FhOCoQdBlFaWsKBQ3QB+2V8HsNoo03brLlKALjlnQUmFn0o4F52AzLYbvJ8SA8w1TYbwpy6G3ZtHSnaQBbd/nJm9N5iqN/2XvOibhbsvKQIqzPi6lSsl6ArSKEvLzfo56PD9VvmCcLpST0N+hqeTFS9+SzoYtXzsT1+C0AaWlEuT0CUS7YNaDRoW80w0myUIhf9g5YV1QE7phWd6lKgNklHhk8EMuruveGO0UiyYu2TQzVErvhKm9Qn5r2LQNns9ptkKerbJ3wjwpW38=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 467fe27a-5759-4683-092a-08d730a9f7a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:04:46.2039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SWE8UprMpXgMbihK2fg4q6C2ynuXN04pe6TbargC3k1gnSaHJewa+WPlgMrME3KRVslMNguMN1W1D9ywWyyz3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Matcher defines which packets fields are matched when a packet arrives.
Matcher is a part of a table and can contain one or more rules. Where
rule defines specific values of the matcher's mask definition.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 770 ++++++++++++++++++
 1 file changed, 770 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_mat=
cher.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
new file mode 100644
index 000000000000..01008cd66f75
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -0,0 +1,770 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "dr_types.h"
+
+static bool dr_mask_is_smac_set(struct mlx5dr_match_spec *spec)
+{
+	return (spec->smac_47_16 || spec->smac_15_0);
+}
+
+static bool dr_mask_is_dmac_set(struct mlx5dr_match_spec *spec)
+{
+	return (spec->dmac_47_16 || spec->dmac_15_0);
+}
+
+static bool dr_mask_is_src_addr_set(struct mlx5dr_match_spec *spec)
+{
+	return (spec->src_ip_127_96 || spec->src_ip_95_64 ||
+		spec->src_ip_63_32 || spec->src_ip_31_0);
+}
+
+static bool dr_mask_is_dst_addr_set(struct mlx5dr_match_spec *spec)
+{
+	return (spec->dst_ip_127_96 || spec->dst_ip_95_64 ||
+		spec->dst_ip_63_32 || spec->dst_ip_31_0);
+}
+
+static bool dr_mask_is_l3_base_set(struct mlx5dr_match_spec *spec)
+{
+	return (spec->ip_protocol || spec->frag || spec->tcp_flags ||
+		spec->ip_ecn || spec->ip_dscp);
+}
+
+static bool dr_mask_is_tcp_udp_base_set(struct mlx5dr_match_spec *spec)
+{
+	return (spec->tcp_sport || spec->tcp_dport ||
+		spec->udp_sport || spec->udp_dport);
+}
+
+static bool dr_mask_is_ipv4_set(struct mlx5dr_match_spec *spec)
+{
+	return (spec->dst_ip_31_0 || spec->src_ip_31_0);
+}
+
+static bool dr_mask_is_ipv4_5_tuple_set(struct mlx5dr_match_spec *spec)
+{
+	return (dr_mask_is_l3_base_set(spec) ||
+		dr_mask_is_tcp_udp_base_set(spec) ||
+		dr_mask_is_ipv4_set(spec));
+}
+
+static bool dr_mask_is_eth_l2_tnl_set(struct mlx5dr_match_misc *misc)
+{
+	return misc->vxlan_vni;
+}
+
+static bool dr_mask_is_ttl_set(struct mlx5dr_match_spec *spec)
+{
+	return spec->ttl_hoplimit;
+}
+
+#define DR_MASK_IS_L2_DST(_spec, _misc, _inner_outer) (_spec.first_vid || =
\
+	(_spec).first_cfi || (_spec).first_prio || (_spec).cvlan_tag || \
+	(_spec).svlan_tag || (_spec).dmac_47_16 || (_spec).dmac_15_0 || \
+	(_spec).ethertype || (_spec).ip_version || \
+	(_misc)._inner_outer##_second_vid || \
+	(_misc)._inner_outer##_second_cfi || \
+	(_misc)._inner_outer##_second_prio || \
+	(_misc)._inner_outer##_second_cvlan_tag || \
+	(_misc)._inner_outer##_second_svlan_tag)
+
+#define DR_MASK_IS_ETH_L4_SET(_spec, _misc, _inner_outer) ( \
+	dr_mask_is_l3_base_set(&(_spec)) || \
+	dr_mask_is_tcp_udp_base_set(&(_spec)) || \
+	dr_mask_is_ttl_set(&(_spec)) || \
+	(_misc)._inner_outer##_ipv6_flow_label)
+
+#define DR_MASK_IS_ETH_L4_MISC_SET(_misc3, _inner_outer) ( \
+	(_misc3)._inner_outer##_tcp_seq_num || \
+	(_misc3)._inner_outer##_tcp_ack_num)
+
+#define DR_MASK_IS_FIRST_MPLS_SET(_misc2, _inner_outer) ( \
+	(_misc2)._inner_outer##_first_mpls_label || \
+	(_misc2)._inner_outer##_first_mpls_exp || \
+	(_misc2)._inner_outer##_first_mpls_s_bos || \
+	(_misc2)._inner_outer##_first_mpls_ttl)
+
+static bool dr_mask_is_gre_set(struct mlx5dr_match_misc *misc)
+{
+	return (misc->gre_key_h || misc->gre_key_l ||
+		misc->gre_protocol || misc->gre_c_present ||
+		misc->gre_k_present || misc->gre_s_present);
+}
+
+#define DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET(_misc2, gre_udp) ( \
+	(_misc2).outer_first_mpls_over_##gre_udp##_label || \
+	(_misc2).outer_first_mpls_over_##gre_udp##_exp || \
+	(_misc2).outer_first_mpls_over_##gre_udp##_s_bos || \
+	(_misc2).outer_first_mpls_over_##gre_udp##_ttl)
+
+#define DR_MASK_IS_FLEX_PARSER_0_SET(_misc2) ( \
+	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), gre) || \
+	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), udp))
+
+static bool dr_mask_is_flex_parser_tnl_set(struct mlx5dr_match_misc3 *misc=
3)
+{
+	return (misc3->outer_vxlan_gpe_vni ||
+		misc3->outer_vxlan_gpe_next_protocol ||
+		misc3->outer_vxlan_gpe_flags);
+}
+
+static bool dr_mask_is_flex_parser_icmpv6_set(struct mlx5dr_match_misc3 *m=
isc3)
+{
+	return (misc3->icmpv6_type || misc3->icmpv6_code ||
+		misc3->icmpv6_header_data);
+}
+
+static bool dr_mask_is_wqe_metadata_set(struct mlx5dr_match_misc2 *misc2)
+{
+	return misc2->metadata_reg_a;
+}
+
+static bool dr_mask_is_reg_c_0_3_set(struct mlx5dr_match_misc2 *misc2)
+{
+	return (misc2->metadata_reg_c_0 || misc2->metadata_reg_c_1 ||
+		misc2->metadata_reg_c_2 || misc2->metadata_reg_c_3);
+}
+
+static bool dr_mask_is_reg_c_4_7_set(struct mlx5dr_match_misc2 *misc2)
+{
+	return (misc2->metadata_reg_c_4 || misc2->metadata_reg_c_5 ||
+		misc2->metadata_reg_c_6 || misc2->metadata_reg_c_7);
+}
+
+static bool dr_mask_is_gvmi_or_qpn_set(struct mlx5dr_match_misc *misc)
+{
+	return (misc->source_sqn || misc->source_port);
+}
+
+static bool
+dr_matcher_supp_flex_parser_vxlan_gpe(struct mlx5dr_domain *dmn)
+{
+	return dmn->info.caps.flex_protocols &
+	       MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED;
+}
+
+int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
+				   struct mlx5dr_matcher_rx_tx *nic_matcher,
+				   bool ipv6)
+{
+	if (ipv6) {
+		nic_matcher->ste_builder =3D nic_matcher->ste_builder6;
+		nic_matcher->num_of_builders =3D nic_matcher->num_of_builders6;
+	} else {
+		nic_matcher->ste_builder =3D nic_matcher->ste_builder4;
+		nic_matcher->num_of_builders =3D nic_matcher->num_of_builders4;
+	}
+
+	if (!nic_matcher->num_of_builders) {
+		mlx5dr_dbg(matcher->tbl->dmn,
+			   "Rule not supported on this matcher due to IP related fields\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
+				       struct mlx5dr_matcher_rx_tx *nic_matcher,
+				       bool ipv6)
+{
+	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_match_param mask =3D {};
+	struct mlx5dr_match_misc3 *misc3;
+	struct mlx5dr_ste_build *sb;
+	u8 *num_of_builders;
+	bool inner, rx;
+	int idx =3D 0;
+	int ret, i;
+
+	if (ipv6) {
+		sb =3D nic_matcher->ste_builder6;
+		num_of_builders =3D &nic_matcher->num_of_builders6;
+	} else {
+		sb =3D nic_matcher->ste_builder4;
+		num_of_builders =3D &nic_matcher->num_of_builders4;
+	}
+
+	rx =3D nic_dmn->ste_type =3D=3D MLX5DR_STE_TYPE_RX;
+
+	/* Create a temporary mask to track and clear used mask fields */
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_OUTER)
+		mask.outer =3D matcher->mask.outer;
+
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC)
+		mask.misc =3D matcher->mask.misc;
+
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_INNER)
+		mask.inner =3D matcher->mask.inner;
+
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC2)
+		mask.misc2 =3D matcher->mask.misc2;
+
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC3)
+		mask.misc3 =3D matcher->mask.misc3;
+
+	ret =3D mlx5dr_ste_build_pre_check(dmn, matcher->match_criteria,
+					 &matcher->mask, NULL);
+	if (ret)
+		return ret;
+
+	/* Outer */
+	if (matcher->match_criteria & (DR_MATCHER_CRITERIA_OUTER |
+				       DR_MATCHER_CRITERIA_MISC |
+				       DR_MATCHER_CRITERIA_MISC2 |
+				       DR_MATCHER_CRITERIA_MISC3)) {
+		inner =3D false;
+
+		if (dr_mask_is_wqe_metadata_set(&mask.misc2))
+			mlx5dr_ste_build_general_purpose(&sb[idx++], &mask, inner, rx);
+
+		if (dr_mask_is_reg_c_0_3_set(&mask.misc2))
+			mlx5dr_ste_build_register_0(&sb[idx++], &mask, inner, rx);
+
+		if (dr_mask_is_reg_c_4_7_set(&mask.misc2))
+			mlx5dr_ste_build_register_1(&sb[idx++], &mask, inner, rx);
+
+		if (dr_mask_is_gvmi_or_qpn_set(&mask.misc) &&
+		    (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB ||
+		     dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_RX)) {
+			ret =3D mlx5dr_ste_build_src_gvmi_qpn(&sb[idx++], &mask,
+							    &dmn->info.caps,
+							    inner, rx);
+			if (ret)
+				return ret;
+		}
+
+		if (dr_mask_is_smac_set(&mask.outer) &&
+		    dr_mask_is_dmac_set(&mask.outer)) {
+			ret =3D mlx5dr_ste_build_eth_l2_src_des(&sb[idx++], &mask,
+							      inner, rx);
+			if (ret)
+				return ret;
+		}
+
+		if (dr_mask_is_smac_set(&mask.outer))
+			mlx5dr_ste_build_eth_l2_src(&sb[idx++], &mask, inner, rx);
+
+		if (DR_MASK_IS_L2_DST(mask.outer, mask.misc, outer))
+			mlx5dr_ste_build_eth_l2_dst(&sb[idx++], &mask, inner, rx);
+
+		if (ipv6) {
+			if (dr_mask_is_dst_addr_set(&mask.outer))
+				mlx5dr_ste_build_eth_l3_ipv6_dst(&sb[idx++], &mask,
+								 inner, rx);
+
+			if (dr_mask_is_src_addr_set(&mask.outer))
+				mlx5dr_ste_build_eth_l3_ipv6_src(&sb[idx++], &mask,
+								 inner, rx);
+
+			if (DR_MASK_IS_ETH_L4_SET(mask.outer, mask.misc, outer))
+				mlx5dr_ste_build_ipv6_l3_l4(&sb[idx++], &mask,
+							    inner, rx);
+		} else {
+			if (dr_mask_is_ipv4_5_tuple_set(&mask.outer))
+				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
+								     inner, rx);
+
+			if (dr_mask_is_ttl_set(&mask.outer))
+				mlx5dr_ste_build_eth_l3_ipv4_misc(&sb[idx++], &mask,
+								  inner, rx);
+		}
+
+		if (dr_mask_is_flex_parser_tnl_set(&mask.misc3) &&
+		    dr_matcher_supp_flex_parser_vxlan_gpe(dmn))
+			mlx5dr_ste_build_flex_parser_tnl(&sb[idx++], &mask,
+							 inner, rx);
+
+		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
+			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
+
+		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, outer))
+			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
+
+		if (DR_MASK_IS_FLEX_PARSER_0_SET(mask.misc2))
+			mlx5dr_ste_build_flex_parser_0(&sb[idx++], &mask,
+						       inner, rx);
+
+		misc3 =3D &mask.misc3;
+		if ((DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc3) &&
+		     mlx5dr_matcher_supp_flex_parser_icmp_v4(&dmn->info.caps)) ||
+		    (dr_mask_is_flex_parser_icmpv6_set(&mask.misc3) &&
+		     mlx5dr_matcher_supp_flex_parser_icmp_v6(&dmn->info.caps))) {
+			ret =3D mlx5dr_ste_build_flex_parser_1(&sb[idx++],
+							     &mask, &dmn->info.caps,
+							     inner, rx);
+			if (ret)
+				return ret;
+		}
+		if (dr_mask_is_gre_set(&mask.misc))
+			mlx5dr_ste_build_gre(&sb[idx++], &mask, inner, rx);
+	}
+
+	/* Inner */
+	if (matcher->match_criteria & (DR_MATCHER_CRITERIA_INNER |
+				       DR_MATCHER_CRITERIA_MISC |
+				       DR_MATCHER_CRITERIA_MISC2 |
+				       DR_MATCHER_CRITERIA_MISC3)) {
+		inner =3D true;
+
+		if (dr_mask_is_eth_l2_tnl_set(&mask.misc))
+			mlx5dr_ste_build_eth_l2_tnl(&sb[idx++], &mask, inner, rx);
+
+		if (dr_mask_is_smac_set(&mask.inner) &&
+		    dr_mask_is_dmac_set(&mask.inner)) {
+			ret =3D mlx5dr_ste_build_eth_l2_src_des(&sb[idx++],
+							      &mask, inner, rx);
+			if (ret)
+				return ret;
+		}
+
+		if (dr_mask_is_smac_set(&mask.inner))
+			mlx5dr_ste_build_eth_l2_src(&sb[idx++], &mask, inner, rx);
+
+		if (DR_MASK_IS_L2_DST(mask.inner, mask.misc, inner))
+			mlx5dr_ste_build_eth_l2_dst(&sb[idx++], &mask, inner, rx);
+
+		if (ipv6) {
+			if (dr_mask_is_dst_addr_set(&mask.inner))
+				mlx5dr_ste_build_eth_l3_ipv6_dst(&sb[idx++], &mask,
+								 inner, rx);
+
+			if (dr_mask_is_src_addr_set(&mask.inner))
+				mlx5dr_ste_build_eth_l3_ipv6_src(&sb[idx++], &mask,
+								 inner, rx);
+
+			if (DR_MASK_IS_ETH_L4_SET(mask.inner, mask.misc, inner))
+				mlx5dr_ste_build_ipv6_l3_l4(&sb[idx++], &mask,
+							    inner, rx);
+		} else {
+			if (dr_mask_is_ipv4_5_tuple_set(&mask.inner))
+				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
+								     inner, rx);
+
+			if (dr_mask_is_ttl_set(&mask.inner))
+				mlx5dr_ste_build_eth_l3_ipv4_misc(&sb[idx++], &mask,
+								  inner, rx);
+		}
+
+		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, inner))
+			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
+
+		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, inner))
+			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
+
+		if (DR_MASK_IS_FLEX_PARSER_0_SET(mask.misc2))
+			mlx5dr_ste_build_flex_parser_0(&sb[idx++], &mask, inner, rx);
+	}
+	/* Empty matcher, takes all */
+	if (matcher->match_criteria =3D=3D DR_MATCHER_CRITERIA_EMPTY)
+		mlx5dr_ste_build_empty_always_hit(&sb[idx++], rx);
+
+	if (idx =3D=3D 0) {
+		mlx5dr_dbg(dmn, "Cannot generate any valid rules from mask\n");
+		return -EINVAL;
+	}
+
+	/* Check that all mask fields were consumed */
+	for (i =3D 0; i < sizeof(struct mlx5dr_match_param); i++) {
+		if (((u8 *)&mask)[i] !=3D 0) {
+			mlx5dr_info(dmn, "Mask contains unsupported parameters\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	*num_of_builders =3D idx;
+
+	return 0;
+}
+
+static int dr_matcher_connect(struct mlx5dr_domain *dmn,
+			      struct mlx5dr_matcher_rx_tx *curr_nic_matcher,
+			      struct mlx5dr_matcher_rx_tx *next_nic_matcher,
+			      struct mlx5dr_matcher_rx_tx *prev_nic_matcher)
+{
+	struct mlx5dr_table_rx_tx *nic_tbl =3D curr_nic_matcher->nic_tbl;
+	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_tbl->nic_dmn;
+	struct mlx5dr_htbl_connect_info info;
+	struct mlx5dr_ste_htbl *prev_htbl;
+	int ret;
+
+	/* Connect end anchor hash table to next_htbl or to the default address *=
/
+	if (next_nic_matcher) {
+		info.type =3D CONNECT_HIT;
+		info.hit_next_htbl =3D next_nic_matcher->s_htbl;
+	} else {
+		info.type =3D CONNECT_MISS;
+		info.miss_icm_addr =3D nic_tbl->default_icm_addr;
+	}
+	ret =3D mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn,
+						curr_nic_matcher->e_anchor,
+						&info, info.type =3D=3D CONNECT_HIT);
+	if (ret)
+		return ret;
+
+	/* Connect start hash table to end anchor */
+	info.type =3D CONNECT_MISS;
+	info.miss_icm_addr =3D curr_nic_matcher->e_anchor->chunk->icm_addr;
+	ret =3D mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn,
+						curr_nic_matcher->s_htbl,
+						&info, false);
+	if (ret)
+		return ret;
+
+	/* Connect previous hash table to matcher start hash table */
+	if (prev_nic_matcher)
+		prev_htbl =3D prev_nic_matcher->e_anchor;
+	else
+		prev_htbl =3D nic_tbl->s_anchor;
+
+	info.type =3D CONNECT_HIT;
+	info.hit_next_htbl =3D curr_nic_matcher->s_htbl;
+	ret =3D mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn, prev_htbl,
+						&info, true);
+	if (ret)
+		return ret;
+
+	/* Update the pointing ste and next hash table */
+	curr_nic_matcher->s_htbl->pointing_ste =3D prev_htbl->ste_arr;
+	prev_htbl->ste_arr[0].next_htbl =3D curr_nic_matcher->s_htbl;
+
+	if (next_nic_matcher) {
+		next_nic_matcher->s_htbl->pointing_ste =3D curr_nic_matcher->e_anchor->s=
te_arr;
+		curr_nic_matcher->e_anchor->ste_arr[0].next_htbl =3D next_nic_matcher->s=
_htbl;
+	}
+
+	return 0;
+}
+
+static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
+{
+	struct mlx5dr_matcher *next_matcher, *prev_matcher, *tmp_matcher;
+	struct mlx5dr_table *tbl =3D matcher->tbl;
+	struct mlx5dr_domain *dmn =3D tbl->dmn;
+	bool first =3D true;
+	int ret;
+
+	next_matcher =3D NULL;
+	if (!list_empty(&tbl->matcher_list))
+		list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
+			if (tmp_matcher->prio >=3D matcher->prio) {
+				next_matcher =3D tmp_matcher;
+				break;
+			}
+			first =3D false;
+		}
+
+	prev_matcher =3D NULL;
+	if (next_matcher && !first)
+		prev_matcher =3D list_entry(next_matcher->matcher_list.prev,
+					  struct mlx5dr_matcher,
+					  matcher_list);
+	else if (!first)
+		prev_matcher =3D list_entry(tbl->matcher_list.prev,
+					  struct mlx5dr_matcher,
+					  matcher_list);
+
+	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB ||
+	    dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
+		ret =3D dr_matcher_connect(dmn, &matcher->rx,
+					 next_matcher ? &next_matcher->rx : NULL,
+					 prev_matcher ?	&prev_matcher->rx : NULL);
+		if (ret)
+			return ret;
+	}
+
+	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB ||
+	    dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_TX) {
+		ret =3D dr_matcher_connect(dmn, &matcher->tx,
+					 next_matcher ? &next_matcher->tx : NULL,
+					 prev_matcher ?	&prev_matcher->tx : NULL);
+		if (ret)
+			return ret;
+	}
+
+	if (prev_matcher)
+		list_add(&matcher->matcher_list, &prev_matcher->matcher_list);
+	else if (next_matcher)
+		list_add_tail(&matcher->matcher_list,
+			      &next_matcher->matcher_list);
+	else
+		list_add(&matcher->matcher_list, &tbl->matcher_list);
+
+	return 0;
+}
+
+static void dr_matcher_uninit_nic(struct mlx5dr_matcher_rx_tx *nic_matcher=
)
+{
+	mlx5dr_htbl_put(nic_matcher->s_htbl);
+	mlx5dr_htbl_put(nic_matcher->e_anchor);
+}
+
+static void dr_matcher_uninit_fdb(struct mlx5dr_matcher *matcher)
+{
+	dr_matcher_uninit_nic(&matcher->rx);
+	dr_matcher_uninit_nic(&matcher->tx);
+}
+
+static void dr_matcher_uninit(struct mlx5dr_matcher *matcher)
+{
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+
+	switch (dmn->type) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		dr_matcher_uninit_nic(&matcher->rx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		dr_matcher_uninit_nic(&matcher->tx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		dr_matcher_uninit_fdb(matcher);
+		break;
+	default:
+		WARN_ON(true);
+		break;
+	}
+}
+
+static int dr_matcher_init_nic(struct mlx5dr_matcher *matcher,
+			       struct mlx5dr_matcher_rx_tx *nic_matcher)
+{
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	int ret, ret_v4, ret_v6;
+
+	ret_v4 =3D dr_matcher_set_ste_builders(matcher, nic_matcher, false);
+	ret_v6 =3D dr_matcher_set_ste_builders(matcher, nic_matcher, true);
+
+	if (ret_v4 && ret_v6) {
+		mlx5dr_dbg(dmn, "Cannot generate IPv4 or IPv6 rules with given mask\n");
+		return -EINVAL;
+	}
+
+	if (!ret_v4)
+		nic_matcher->ste_builder =3D nic_matcher->ste_builder4;
+	else
+		nic_matcher->ste_builder =3D nic_matcher->ste_builder6;
+
+	nic_matcher->e_anchor =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
+						      DR_CHUNK_SIZE_1,
+						      MLX5DR_STE_LU_TYPE_DONT_CARE,
+						      0);
+	if (!nic_matcher->e_anchor)
+		return -ENOMEM;
+
+	nic_matcher->s_htbl =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
+						    DR_CHUNK_SIZE_1,
+						    nic_matcher->ste_builder[0].lu_type,
+						    nic_matcher->ste_builder[0].byte_mask);
+	if (!nic_matcher->s_htbl) {
+		ret =3D -ENOMEM;
+		goto free_e_htbl;
+	}
+
+	/* make sure the tables exist while empty */
+	mlx5dr_htbl_get(nic_matcher->s_htbl);
+	mlx5dr_htbl_get(nic_matcher->e_anchor);
+
+	return 0;
+
+free_e_htbl:
+	mlx5dr_ste_htbl_free(nic_matcher->e_anchor);
+	return ret;
+}
+
+static int dr_matcher_init_fdb(struct mlx5dr_matcher *matcher)
+{
+	int ret;
+
+	ret =3D dr_matcher_init_nic(matcher, &matcher->rx);
+	if (ret)
+		return ret;
+
+	ret =3D dr_matcher_init_nic(matcher, &matcher->tx);
+	if (ret)
+		goto uninit_nic_rx;
+
+	return 0;
+
+uninit_nic_rx:
+	dr_matcher_uninit_nic(&matcher->rx);
+	return ret;
+}
+
+static int dr_matcher_init(struct mlx5dr_matcher *matcher,
+			   struct mlx5dr_match_parameters *mask)
+{
+	struct mlx5dr_table *tbl =3D matcher->tbl;
+	struct mlx5dr_domain *dmn =3D tbl->dmn;
+	int ret;
+
+	if (matcher->match_criteria >=3D DR_MATCHER_CRITERIA_MAX) {
+		mlx5dr_info(dmn, "Invalid match criteria attribute\n");
+		return -EINVAL;
+	}
+
+	if (mask) {
+		if (mask->match_sz > sizeof(struct mlx5dr_match_param)) {
+			mlx5dr_info(dmn, "Invalid match size attribute\n");
+			return -EINVAL;
+		}
+		mlx5dr_ste_copy_param(matcher->match_criteria,
+				      &matcher->mask, mask);
+	}
+
+	switch (dmn->type) {
+	case MLX5DR_DOMAIN_TYPE_NIC_RX:
+		matcher->rx.nic_tbl =3D &tbl->rx;
+		ret =3D dr_matcher_init_nic(matcher, &matcher->rx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_NIC_TX:
+		matcher->tx.nic_tbl =3D &tbl->tx;
+		ret =3D dr_matcher_init_nic(matcher, &matcher->tx);
+		break;
+	case MLX5DR_DOMAIN_TYPE_FDB:
+		matcher->rx.nic_tbl =3D &tbl->rx;
+		matcher->tx.nic_tbl =3D &tbl->tx;
+		ret =3D dr_matcher_init_fdb(matcher);
+		break;
+	default:
+		WARN_ON(true);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+struct mlx5dr_matcher *
+mlx5dr_matcher_create(struct mlx5dr_table *tbl,
+		      u16 priority,
+		      u8 match_criteria_enable,
+		      struct mlx5dr_match_parameters *mask)
+{
+	struct mlx5dr_matcher *matcher;
+	int ret;
+
+	refcount_inc(&tbl->refcount);
+
+	matcher =3D kzalloc(sizeof(*matcher), GFP_KERNEL);
+	if (!matcher)
+		goto dec_ref;
+
+	matcher->tbl =3D tbl;
+	matcher->prio =3D priority;
+	matcher->match_criteria =3D match_criteria_enable;
+	refcount_set(&matcher->refcount, 1);
+	INIT_LIST_HEAD(&matcher->matcher_list);
+
+	mutex_lock(&tbl->dmn->mutex);
+
+	ret =3D dr_matcher_init(matcher, mask);
+	if (ret)
+		goto free_matcher;
+
+	ret =3D dr_matcher_add_to_tbl(matcher);
+	if (ret)
+		goto matcher_uninit;
+
+	mutex_unlock(&tbl->dmn->mutex);
+
+	return matcher;
+
+matcher_uninit:
+	dr_matcher_uninit(matcher);
+free_matcher:
+	mutex_unlock(&tbl->dmn->mutex);
+	kfree(matcher);
+dec_ref:
+	refcount_dec(&tbl->refcount);
+	return NULL;
+}
+
+static int dr_matcher_disconnect(struct mlx5dr_domain *dmn,
+				 struct mlx5dr_table_rx_tx *nic_tbl,
+				 struct mlx5dr_matcher_rx_tx *next_nic_matcher,
+				 struct mlx5dr_matcher_rx_tx *prev_nic_matcher)
+{
+	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_tbl->nic_dmn;
+	struct mlx5dr_htbl_connect_info info;
+	struct mlx5dr_ste_htbl *prev_anchor;
+
+	if (prev_nic_matcher)
+		prev_anchor =3D prev_nic_matcher->e_anchor;
+	else
+		prev_anchor =3D nic_tbl->s_anchor;
+
+	/* Connect previous anchor hash table to next matcher or to the default a=
ddress */
+	if (next_nic_matcher) {
+		info.type =3D CONNECT_HIT;
+		info.hit_next_htbl =3D next_nic_matcher->s_htbl;
+		next_nic_matcher->s_htbl->pointing_ste =3D prev_anchor->ste_arr;
+		prev_anchor->ste_arr[0].next_htbl =3D next_nic_matcher->s_htbl;
+	} else {
+		info.type =3D CONNECT_MISS;
+		info.miss_icm_addr =3D nic_tbl->default_icm_addr;
+		prev_anchor->ste_arr[0].next_htbl =3D NULL;
+	}
+
+	return mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn, prev_anchor,
+						 &info, true);
+}
+
+static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
+{
+	struct mlx5dr_matcher *prev_matcher, *next_matcher;
+	struct mlx5dr_table *tbl =3D matcher->tbl;
+	struct mlx5dr_domain *dmn =3D tbl->dmn;
+	int ret =3D 0;
+
+	if (list_is_last(&matcher->matcher_list, &tbl->matcher_list))
+		next_matcher =3D NULL;
+	else
+		next_matcher =3D list_next_entry(matcher, matcher_list);
+
+	if (matcher->matcher_list.prev =3D=3D &tbl->matcher_list)
+		prev_matcher =3D NULL;
+	else
+		prev_matcher =3D list_prev_entry(matcher, matcher_list);
+
+	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB ||
+	    dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
+		ret =3D dr_matcher_disconnect(dmn, &tbl->rx,
+					    next_matcher ? &next_matcher->rx : NULL,
+					    prev_matcher ? &prev_matcher->rx : NULL);
+		if (ret)
+			return ret;
+	}
+
+	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB ||
+	    dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_TX) {
+		ret =3D dr_matcher_disconnect(dmn, &tbl->tx,
+					    next_matcher ? &next_matcher->tx : NULL,
+					    prev_matcher ? &prev_matcher->tx : NULL);
+		if (ret)
+			return ret;
+	}
+
+	list_del(&matcher->matcher_list);
+
+	return 0;
+}
+
+int mlx5dr_matcher_destroy(struct mlx5dr_matcher *matcher)
+{
+	struct mlx5dr_table *tbl =3D matcher->tbl;
+
+	if (refcount_read(&matcher->refcount) > 1)
+		return -EBUSY;
+
+	mutex_lock(&tbl->dmn->mutex);
+
+	dr_matcher_remove_from_tbl(matcher);
+	dr_matcher_uninit(matcher);
+	refcount_dec(&matcher->tbl->refcount);
+
+	mutex_unlock(&tbl->dmn->mutex);
+	kfree(matcher);
+
+	return 0;
+}
--=20
2.21.0

