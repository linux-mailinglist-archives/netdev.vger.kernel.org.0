Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E43222E0D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgGPVeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:14 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:49391
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgGPVeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLmZHDpTajntAZKDKfQyeKz/KQ9JN+Ynpm51GhKUohQknXtMnFpSP6gSGqM6SwLx1Bv1B4dVYeBTtZoSpEk0nzuQeojiu0vo1apqaUdnizHrAwuinwO8IH4jwXHAdYMaI88KCsSFFYkOp+zBOCrsDqLPHY8rFPx4EkJglcnIABHGvI9T+RIiQKxQtL+i/mR88k+GI6aqRIg/gN2VCtgvQnUFqDZx5m0BDaRm8zSySShJMZfLIptRWzoW6R2NoYRIebJma6C/mIr2XAiH1nQoBenTbw8QOfBmJx8qOe2ck+hIa0Y2VcQ+sl1PGCENRE/SDvjS2hPufGlGlwof/OOPeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpasY9ypbevXwVO3RHMRCCSY/PQAo+1It/S62XzGYRU=;
 b=QZSSmG1TWzbmqRbFT7ywxWLPzpODxsfQvtyxx6P13qRp8YaTF6fyyttuz8Kva6lc6cRsV2BPzRswv9//rX0j049BGt2qUY4kdaW30KHjrqeVdaiu+/SOSLyClRwOx+0+5TwVQAi1ya9pjuHdWAdFnX2PyvCDYO1g9Ncm48DKz7uy+qK8UTlwW7+RULyM6ouD23Zi2ywIs+Xv4DqHd/rVA/txG6ZXErEMERSBFfhcI/JD4nlWiDAd94xAIBhWsYnHzu7r8uWC2i19j9PKChphzBL/xqYDgUwvt9up2eiqKgD1hMvC6ZZJerVAoSIF9FWKKLdwU8eqLSC1hQc7bqFylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpasY9ypbevXwVO3RHMRCCSY/PQAo+1It/S62XzGYRU=;
 b=RWe/XJ4opBTIqrN6TL67VFX3q6jk4eCtHNVEaNBX3MtWE7bL2SZKCUZnn1n8QZ/cnZudazuzshqxu9j82SXMWtsms2mO76VZMmf3EMnQKJmc/3Awm+GoaMhWW0bokJgxouLrsEF+6EQdANDM2lv+aYfPvAX6716rqDsqkgN7SUg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:33:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:33:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/15] net/mlx5: Add IPsec related Flow steering entry's fields
Date:   Thu, 16 Jul 2020 14:33:14 -0700
Message-Id: <20200716213321.29468-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:33:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3eb6e1ee-0e44-4972-9701-08d829cff367
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB29921227CF72E029234DB6C7BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlh9OTbxuaZzF1aHce5j4FIIdo+NuSELArgOlKbPXBRI+uUMfZFxVvfVK/T3aEEQLN5QRCwdHAzb8ZbJPxP1exnaCTXws/mBxt6j54h7Mzu3FQQAmTDZ9Oh+1eVGNJKVQl2Am37cuSaRB+Aht3dPvzwTpUlgptiNz84E/lavqTzvXNdCa8qYFwJqu9+zT14wQditky16BqE4+bHZaFB+rhZgnTZbL+t1YARc0zM/+8+bthWPQBwyvnPIBE/DR4FxFsFiesMY5zwDGhAFjNQAKfoQyU2whvEc9Bc8CeYpgUDyogghEurRz12N4cLp1nVWsJFMO/fwKXHTrcre3SevYBCkbj7soj0xJ87wBAN5oz/4fFFU2Kev/Nwoy0KveD5V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Tn0bqIzaHcI0jbVZD0P8CsT4CpjK0HC7DnC5xvnvt32dsq1G/JKMZ3w+sBbX69Fjg6SgwEYg2MZG1bU10vprAdiISk+PtoHGqymYLMiRglmafKWnK+sIWnUazZgLCJjejWwm4+Iiaqjn/vjA7l7U7uHOqYGNI6i1xPi7cj6E4mgZ+92t63uXqyY2SVgdS+QNpIOmza0Mlqsc3JaBw7jQj+2ggJvdZezYIByL26gtMgVksDEJ1wstdhAjr3B2W/dMmXjHZF4yG6nxD6/ckze9Wk3MrI6AYO3XIM9pfL0IBBoKKTw3b/KNSeBikwLqbf5w87CF6JzNIqNG52GcM3vCzWKVcUnyWoE8kCZeWoS43bIRE0z7z5xkT0tfD4gOd0LzS2mG/0UX5xA0Pru9dDRrxUa+GOFlBlslX3QRI9zDnB2977FUkQzKWfavWuCCZXrn0a6XuxiW9ZQJGIWAMPdr4oxsdAn2d8ybI8SUUHvXbHE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb6e1ee-0e44-4972-9701-08d829cff367
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:33:59.6193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5GOTvsfjrfs2sSNxVbvkZnw0jKnexMdx2k14K8k0XvsqKIw2bS/RqBbTs1u3jCyNBaeqtyn+43tcRqSMp9tHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Add FTE actions IPsec ENCRYPT/DECRYPT
Add ipsec_obj_id field in FTE
Add new action field MLX5_ACTION_IN_FIELD_IPSEC_SYNDROME

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/fs.h       |  5 ++++-
 include/linux/mlx5/mlx5_ifc.h | 12 ++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 6c5aa0a214251..92d991d93757b 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -207,7 +207,10 @@ struct mlx5_flow_act {
 	u32 action;
 	struct mlx5_modify_hdr  *modify_hdr;
 	struct mlx5_pkt_reformat *pkt_reformat;
-	uintptr_t esp_id;
+	union {
+		u32 ipsec_obj_id;
+		uintptr_t esp_id;
+	};
 	u32 flags;
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
 	struct ib_counters *counters;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 791766e15d5cf..9e64710bc54f4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -416,7 +416,11 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8	   table_miss_action_domain[0x1];
 	u8         termination_table[0x1];
 	u8         reformat_and_fwd_to_table[0x1];
-	u8         reserved_at_1a[0x6];
+	u8         reserved_at_1a[0x2];
+	u8         ipsec_encrypt[0x1];
+	u8         ipsec_decrypt[0x1];
+	u8         reserved_at_1e[0x2];
+
 	u8         termination_table_raw_traffic[0x1];
 	u8         reserved_at_21[0x1];
 	u8         log_max_ft_size[0x6];
@@ -2965,6 +2969,8 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH = 0x100,
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2  = 0x400,
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 = 0x800,
+	MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT = 0x1000,
+	MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT = 0x2000,
 };
 
 enum {
@@ -3006,7 +3012,8 @@ struct mlx5_ifc_flow_context_bits {
 
 	struct mlx5_ifc_vlan_bits push_vlan_2;
 
-	u8         reserved_at_120[0xe0];
+	u8         ipsec_obj_id[0x20];
+	u8         reserved_at_140[0xc0];
 
 	struct mlx5_ifc_fte_match_param_bits match_value;
 
@@ -5752,6 +5759,7 @@ enum {
 	MLX5_ACTION_IN_FIELD_METADATA_REG_C_7  = 0x58,
 	MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM   = 0x59,
 	MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM   = 0x5B,
+	MLX5_ACTION_IN_FIELD_IPSEC_SYNDROME    = 0x5D,
 };
 
 struct mlx5_ifc_alloc_modify_header_context_out_bits {
-- 
2.26.2

