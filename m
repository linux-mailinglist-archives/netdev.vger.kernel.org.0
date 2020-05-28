Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D296A1E52D0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgE1BS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:18:56 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:32229
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726487AbgE1BSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6pkWaOx/nqqeo9MFtsB+SAAIdgKuAHrZYw5jQgjp4jd4teaCwxCOKkXp6QX2KjhNwx42TMRJOmMghEPegbwy2nzIhCryurwmUJ5reGZK8ILv2EFqUGHB0cJRmOEkA+Q5D2hKrNGT+UyzjMuMBvoTPn89OI4gzp56kJuX1T1rdD8Mma2qsJ4ManGpqebLSyPlwCzsrrM17ay4MVgU1JZAZhC22U7vXaCa21ZLe3ctMb0LyD+UjWeNPvq5Mb+FzibnQ76h6zT5FARUMDVmPkaAeajjCvz5+9Saejy79naASgIPOcSKS2fnviELaIhN+F9HRfvqJv2Hq3sqDpZoeeyeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwn1IuQwdnYVLhA7Y3kS1QyaryLMZdkX4rUQ1o6KwZE=;
 b=UcT0clfh8cTLkShFyUkbZ6DIz1cjn5aclh1ndhEHiEVoyPCp2gI5BfcUc/5v1VC3h4pHHkraDoByshtYfOkMZBNUjVEPTOGF9Bj3uwU2ASsP5t1ykEUSZXqqDwCCP/porOfiUke5fVlN0qrxfUEGGUEsSyBWcVWPsMP4F770qQKk4B3VQRU2EM7cI/KUvza6rnplcOZdjPZi4a9FI4aj2J0ipC0bwpba1LSKWpWpYATNx6DiCNB4CjupuigNxQlUmHnio3gVPih79IRMxxizw0T78jD2mGYgkEQj+JJZIBv564sagM9Q7r+6dyiye7z7Ok6IGXnCopVJjJu5GG/Nkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwn1IuQwdnYVLhA7Y3kS1QyaryLMZdkX4rUQ1o6KwZE=;
 b=RGx6qDxUS3QKHXC1uMc/5YC/BnMc+k7kpE4bqLPVQQqMRlZIgBwn94qC7upTwGqloJnCw+KlezfEW10slvTcjGS2IINpvR3HFDbMRiNirjzLdBW9vyIm/m3jwjCF3n0GzmbNT0otr9c95D4fjZ/uPnqyZ6HZqG4B93+fRRj8M9I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 12/15] net/mlx5e: Helper function to set ethertype
Date:   Wed, 27 May 2020 18:16:53 -0700
Message-Id: <20200528011656.559914-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:51 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f2245ef-e924-4d7d-99c8-08d802a4f1f5
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4368E23DADD8BEFA64557D29BE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxLZikixjtv0ewqOptdr2oHy4iu+73hFDrDQq6Dnow5/drrbUcGcNQK0fMFnk+2IG1fEdatUTH+liMUxq6OJXtyeAulSu3Y0UOivLSp/oTgODGXvf3mf9kWg+AqvbjiF9IoHxu93gpOxU5t9dXnRAhJLg25ihd4yyD0X3opirBqUsDs/FiOUr/viDGX6fX7IzLsym2Uq1KoPpHv1xfeoY25SxjV0Ld1qirGg84O72itPuXxew0CB3WAWq0SRDqpFCMxyZIgioIpuCXXjBwnVYBX5iLEJX2Brpe+20SP0oNd0jbR8UahbhV/kG0/eMpSPKFDjNW8T1z+2HS78W9NP4OLsfZpfmbZAaFVI2UJNcZqC/AhXxPVugA3TFvW9mF0G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jjYEZUS4EyXdyZkP+lXMDIKW00rKWxYa4Zqs6h0/rL/jGxP3S+7Opl8ip8I7S2BilgtIuzaB44mTOgrL8KI1OE8d6Ryl5IlLwzRU3CQId4Fr7UNwzOYHJLq/JnahO/mBi8RwWV0pBgcHqmAfzdeAEXZcsfUVCcI8gDWm27zsGsVtTsU6H0RpQmBAhQUCkIw0vFB2w5S9a3EWe9PibIBc4MG/Ic2h3FRhrj3Glv9kDB+4M/+cLEhWMHn0PrTeOcQlOHXgi55ZhCuaWcLtbxYWvFvRu1vE8OCcgwdC9UTlsM7INKyAh8oa7QXN+wwZU9cH0dlgVRREK/2Ts9StycbcxZf0Lfcfrk5pAsaFE5Df6BTWJytcmdWfYKpCCLoLVxDSdHZIQFiJVpZxpNPq+osHmoihACC6EGPXLwOR9R4N6UpL2Ry7ps8Soh1sWuPgV/AIA1fXyMirBMBgsq3mfiLCodybqrJE0QAiD9Jr5iS+vGg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2245ef-e924-4d7d-99c8-08d802a4f1f5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:53.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHwNRBte4kAv8eUiv5Zbm2x04exRyHS30g5m947q/Qfop05dP/OY47GNfP3pD6zPrJXYQkVGmwc737TsuvgpAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
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
index e99382f58807..6d7fded75264 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -512,6 +512,13 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_dissector_key_basic key_basic = {};
+		struct flow_dissector_key_basic mask_basic = {
+			.n_proto = htons(0xFFFF),
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

