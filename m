Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A647E1E49C8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390924AbgE0QWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:30 -0400
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:63749
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390913AbgE0QW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mA80csdfvvN8IDD9So5e+sq9cQANfEYjgVShIAEdHYRSnIjbURGasrxwsvIed21rqMAVY92Rrr7NSr/GWh8O8K3+O8wcZ/+H7HybsR+g+qLr2I6rfjqBgHdSCHsBl0K5aBszYe/mCP12ENRc3ia/rrNRFW424K/VgjczqAOPLaG8kdIfSBEbMboLsLbtU//D1zvV+I+CydpgkhBtpaxkrWl6g+amKo3KsBUXoR8VzJNZ90E8EEmwqKI+mN9M8CTU+N262hhXUtISFrTV0oqmhZ4Zt/DPHJ2f8rEiU44stSxHXK0W8wXubCf1l7o3IfAAoSEyDt8mDQAeW/Ii4zveRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXKQwhQfjDMd97XvJg3cbozDanPiISIeQKw3/wOYdOk=;
 b=ZUdmFaljnENM4u99CLXitJf0V/O7MEfRKFxUtK2/3g8BV4qgE3KCawGAj1qERV7V2dxUiAJ/axfuQRtjBpUER35DWaOnB3Xz/kJW09hP3S1VO7ouuXnKX3swoMuHGlgzq3H8H+GUYAS17rsahC/RlU04WVDAN/OpnQrh759vYVpwggJ5rxHL6Fg7TB65yz+zY8ATu+YYgA9Ej0QdaFs6Bx1trjJKo/qnLpDb5085UBWTH0Ml40QHErQ9ydihVy30SUrWWfMHcZB3zLmRtDa7h4svGKbXpgvxk5qIIcH8QnImRli0tvs+Dzxtt60mtNNBeA9VmqMByjZo7D7Q8cBqAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXKQwhQfjDMd97XvJg3cbozDanPiISIeQKw3/wOYdOk=;
 b=orkwZYgrG8UYyMMJL3EukYu8T3XjW5HSheUGwFNh+/iDokOe/JzZUEjl7HWJvVD2Hsw7dtS0lML/ClYFJodzS+7BWCMkrx4bDAxXBIPVIU7wm8Jqf6iTbbk7p/Zjnffe/j1zRRMozi9v4+u9iBx++NaQJfIM82yt6loyi24vsD4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 16:22:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 12/15] net/mlx5e: Helper function to set ethertype
Date:   Wed, 27 May 2020 09:21:36 -0700
Message-Id: <20200527162139.333643-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:22 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 191a31c6-fd0d-4552-1850-08d8025a23bb
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7039932F42F96274D25F456DBEB10@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l58mfNov5TRL73zMca6mJ652xTWbJ9eV62TZNOIqiDwYjMgY6krMtOw+/D3DRbUU4U4EOen7yooEUgYGyGSnTDvXPSKrPfKc3cMkgdL9XCE8x+KEDsMontlkNoyBghnCl17PvlPjDO/07otjdf6a52j1H636H/UBDEhaQqNEA3O64HVHQwFsQTZVc6JTd8Rq76KK72widuwHInQL91k4P63Fpkjmd8NAduhdTEiTSpRWPAdP3BrYekdioUf7wO/8qC8LyY9qv4l3BJNHwhR9lzlPUkfRfjfY1nNBR8MWBxd3bJoKPZcCMID4gyFWitm84TkULA16Xxt5S+Z8+Stb+7m02EjeLNza6b2CVkyQZd5dEjNHy39tSb4e0jUQryzF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(956004)(36756003)(6486002)(54906003)(478600001)(107886003)(6512007)(86362001)(83380400001)(316002)(5660300002)(26005)(16526019)(6506007)(66476007)(66946007)(66556008)(186003)(52116002)(1076003)(2616005)(4326008)(6666004)(2906002)(8676002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lziYHZyVXDAJ1F3OJw4CIfA+q0NXKd6ygw7qH0TKiXISNhDPt4IL+Ozp0aUnE6HV7/6qvKnLmOzrKWaojoYyfOyNAvgLHu4TjonKMFpcLOcRf0tEoy7soIwjG4BWyGpxoL/uBZ4HCVCdwGCRHZFQ7nh7MF99HAiV5ooOwMYZFgATIkxXSorehEH537ryqjIkEQ4ukYCdpx+4Qygvrxwp70fMzDdhOtsot9OSMZYH0cm5qqXCU/0lHQ27ZOhzKmR5cGgf0iuL2tB+Qlgco6M86PVnSOvlUFQ/0JBhB5ZvMfQ6mWM606HzRbkY8zCr7rjJaODCOZ5JPyE7fT2ALhrOMcmYhVlVXBslPaO1Z8ajU2vE8fiSiNtkw28GmRBupm+PHx1mJtfiQHW/6jcrZ/Ou2+Rpc9uEyMLFlSsgmJ5s/alC8qJ9E4BEwuFUTEBSYyVm9QsTTc0uhNcb/cclPzgP4YuIDgTnCdnWziOnKAKFm10=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 191a31c6-fd0d-4552-1850-08d8025a23bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:24.4820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GeA91S2uxhc61nalA0JsHmzsaw7wo7S96NmL3J8xle+RPeJ7BkrfXccr6qcRlbmnfVBVhCSr+XBeZ02pQTTsgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Set ethertype match in a helper function as a pre-step towards
optimizing it.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  5 +----
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 21 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 14 +++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  3 +++
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 995b2ef1fb3b..ba72410c55fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -134,10 +134,7 @@ mlx5_tc_ct_set_tuple_match(struct mlx5_flow_spec *spec,
 
 		flow_rule_match_basic(rule, &match);
 
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ethertype,
-			 ntohs(match.mask->n_proto));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-			 ntohs(match.key->n_proto));
+		mlx5e_tc_set_ethertype(headers_c, headers_v, &match);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_protocol,
 			 match.mask->ip_proto);
 		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index e99382f58807..105d3b2e1a87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -512,6 +512,13 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_dissector_key_basic key_basic = {};
+		struct flow_dissector_key_basic mask_basic = {
+			.n_proto = 0xFFFF,
+		};
+		struct flow_match_basic match_basic = {
+			.key = &key_basic, .mask = &mask_basic,
+		};
 		struct flow_match_control match;
 		u16 addr_type;
 
@@ -537,10 +544,9 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
 				 ntohl(match.key->dst));
 
-			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
-					 ethertype);
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-				 ETH_P_IP);
+			key_basic.n_proto = htons(ETH_P_IP);
+			mlx5e_tc_set_ethertype(headers_c, headers_v,
+					       &match_basic);
 		} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
 			struct flow_match_ipv6_addrs match;
 
@@ -563,10 +569,9 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 			       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
 								  ipv6));
 
-			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
-					 ethertype);
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-				 ETH_P_IPV6);
+			key_basic.n_proto = htons(ETH_P_IPV6);
+			mlx5e_tc_set_ethertype(headers_c, headers_v,
+					       &match_basic);
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 58f797da4d8d..680b9e090057 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2020,6 +2020,15 @@ u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow)
 	return flow->tunnel_id;
 }
 
+void mlx5e_tc_set_ethertype(void *headers_c, void *headers_v,
+			    struct flow_match_basic *match)
+{
+	MLX5_SET(fte_match_set_lyr_2_4, headers_c, ethertype,
+		 ntohs(match->mask->n_proto));
+	MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+		 ntohs(match->key->n_proto));
+}
+
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec,
@@ -2241,10 +2250,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		struct flow_match_basic match;
 
 		flow_rule_match_basic(rule, &match);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ethertype,
-			 ntohs(match.mask->n_proto));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-			 ntohs(match.key->n_proto));
+		mlx5e_tc_set_ethertype(headers_c, headers_v, &match);
 
 		if (match.mask->n_proto)
 			*match_level = MLX5_MATCH_L2;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 037aa73bf9ab..144b71f571ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -170,6 +170,9 @@ void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 struct mlx5e_tc_flow;
 u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow);
 
+void mlx5e_tc_set_ethertype(void *headers_c, void *headers_v,
+			    struct flow_match_basic *match);
+
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv);
-- 
2.26.2

