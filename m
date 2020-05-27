Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB9F1E3501
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgE0Bub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:31 -0400
Received: from mail-eopbgr40067.outbound.protection.outlook.com ([40.107.4.67]:57088
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727965AbgE0Bua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyjLvhXzta6a1dl968uwVzyAYWMkmXCB4ZwTkJgCRcfwnRzVbLPhpSf1hZKlCzSyV5ob7j4lHN0kuWaxKsedEKcX3a0nSVHTnaQz8RheVElrTmWxvj4/yyiS36dBq198XL4QhuGGJHxkjaMYXLOlVzZZ/AbhUka+F42iX2P1/DwfEE62m29EEEludT4JhXg+knC0omDqSOpA1MSU6ZsIvrh6bShKy/La1wfTYi6miB4KWAIKoV50+S5CqoRHxEZKgbzzDvZ82xthh+RGa4nUqK4iq/9Vu7DlT89SahBm25mA0pMFXIhgWz7pZfx1tEhA8DJSP0tv8DzajIvrDTXlNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXKQwhQfjDMd97XvJg3cbozDanPiISIeQKw3/wOYdOk=;
 b=etSid5/HMOXuyPM9sBUXsXwmbtE3viI1BvvXc87WamMpJQR8KUEm2KgZJWx4OWIvHrTPf1yxvyjjDdNguGbKKwexxsLVoeBkQaXlV6xEwGId2ob8aebI839G5m1XJIs8RSpTUdjII1U+//7TI31JAjh+AtUNteDK83kSOJ/suqG7F+8dYbXgwP5eGTkbOx5EsR2Aw1NRt8oWQhF23Wf6lIlWWwDivIe9N627CjXaJUWKXu+qvLGFfy/pzJyWSXjWz2noLC1jP+CkpDKbqsgtIEDlWrF1FyB2nL3xLjSprD684jrdvBjlpyui6c9wDI6FnEeSXNfTSvziwgqjl72Nzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXKQwhQfjDMd97XvJg3cbozDanPiISIeQKw3/wOYdOk=;
 b=MDQJt3g+QT5vWT9cmtR4qgl/qHO0eA6PNFP53U5G1GIVDlQXgl8qJD43f900cY73kzwPXjaFDlz3WMY0PT+yiHaTuAsxUwXaxRFfP1YeG0G73uCiM/jFeqwnw+ZySPWbUZggEXYVS6XDWzhf/h4i4rPJyQYznj944eTAsY3R7n8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4704.eurprd05.prod.outlook.com (2603:10a6:802:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 01:50:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/16] net/mlx5e: Helper function to set ethertype
Date:   Tue, 26 May 2020 18:49:21 -0700
Message-Id: <20200527014924.278327-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:21 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00e74f06-1546-49cd-3b4f-08d801e051c9
X-MS-TrafficTypeDiagnostic: VI1PR05MB4704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB47049BC7202A2350111A1675BEB10@VI1PR05MB4704.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uL+HQpNbRMWoCcDk6v7I5+LqSvz4/4NbXSUWAxqF9kC8vSyWPEbnfYgZTeBnCg06iuzoi0Y5jVqWL8r3+XLxYReceDJfC6mdOWfYPwpSTutlihMTYers80N4oU/hrow7ClRxm6lze6unFBP3bW8x8R0GHmHif4f0vteoWVV3GohMP/Eyxs2gu5bWT2AsLm5yMxD4S4yiYmB04+mhAPjVcy2TjUEF9UMuZ81PMDNdXx4B2wSOBZF+5lgxPhoEqiyFiWKHitdKoryphbWWvvS5FEFMBoLWptALGNyKuBsUtvaZmXM+L5zvT7y+7Fnnrq3okriZQ32llv1yVGsXG9/+2AaHiIcpax3avywW2wDYJ5zLjOT0eLNwp9aW5sZ/bF4k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39850400004)(376002)(346002)(8936002)(86362001)(5660300002)(83380400001)(6486002)(8676002)(6512007)(6506007)(26005)(66476007)(66946007)(956004)(1076003)(2906002)(66556008)(2616005)(186003)(316002)(107886003)(54906003)(4326008)(16526019)(52116002)(478600001)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8Iqbs6ZapWz69qxzEDfp60XSRlnj23j8Wz4JUpdk27mtBAZUf1CogC4pvKRL/cBkPydC2fJkbzUGDes02ae7y+T57IpkOG+MvK7+2l6qbZ76NLWNWjBi+22svwhKuLm9vbeZbPbIpcMBGtQVp2v5Z4Q44SKN8bl/2nbICyVUGUrItorsSu3MTLrfRHGotXG0WXT5G1tXaLq+VW0oypm+vhJiCyjta0adhKy6lbRFEeIHETw+aNha3/pX+lhD1D8eIedeHIdq3nI/WS4dedYAj+iAexp7j9NowoeYVXDLTBNMr3uluz+nXN/FwczYx7PVCOwBnc/H/qUDU9xg7d0hilioWa4O6byYDS79sTwkCOEXXJiVYZ/oKA3GkPvZaaqYIC/UaKGIiR/K6OeKVpAvWz+xYUDck3eUCebufP17e14pVK7zay648R0LYh9RyPEXqCm3isZGXhyhI4aIfney7wu7u8JrbxpPGKElW65Cz1c=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e74f06-1546-49cd-3b4f-08d801e051c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:23.1368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5WHcmuOT7bugWZ/fBt+HYgQ2XF18Wn2bJ8f3JVH57EysjxXzXdxXE8RTAcfSBfqXfzia/sqaFnuEX9WFsoxgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4704
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

