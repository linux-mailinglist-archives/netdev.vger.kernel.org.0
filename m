Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A813B222FAA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgGQAFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:05:02 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:33630
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgGQAFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:05:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J74mHp9qiGRqPRjYXNJWUqS+05WKOzNH/1nv2yuXWfk2eFm7cPJcooazC/TH/CKCPxd6eWUCYIeN0k1aFNu5LSUsb+MU34kqzLZUujHG3sVdmMTaC7QZYBPbtKUJE90JmARzcdQAvlwJ5L9JvE9G5GS8AquQKtUXSGJuSi3waYHTZnbFIxFbmH17MvhfouaXL2+kHfh2sI5yA5CtH/7tT+lAgUK7DEwFJHeZYEt24pEsB1kjJC/a+mzQ7uFi4Y6IF6hFyKjsc03PB7ZcdPZF3SH1YFSavyuTE51bSoHixnkydLjW0qu2ZT/PnrcT2AiotRvflUl2yoKnWjjtYITkIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpasY9ypbevXwVO3RHMRCCSY/PQAo+1It/S62XzGYRU=;
 b=JX1DRBP1SW9S0cE0wYB/w90KR8lMpt/ld/1RrjgZKRDmuAXF8VCyqqU9BQ0yqQHqJD0u16BywE7uDVRfqpf1N4Y6rHhUztWbJhbxmaCP3omHzrU1FOJA0wRJ5pqnwaT588tlvH60wI8DVADAvr4ZjojY6isDKaqMVlOrCV3q5OncIxntjlkcgrcU00gI6HZyf6TwYB+Tihzs4FXxz9LnagP7nrGolHTqzFXvKf+TRwOySHhRwQc0MUwtXDZFaW45HT8fyw7E0215Xth3XwqPm38a8FHbXSsL2/cVNcturStWpz2A3mvx3ts9guxt4JPvagGGkztuRhuCwpM/NTlgVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpasY9ypbevXwVO3RHMRCCSY/PQAo+1It/S62XzGYRU=;
 b=PEr4Sk15kxUHAd3xFzq5UPr0rUhmRseYAWzHkqh7sEOtu89xqLqD8lk1XyUbyoOb5FrSZKyRhavb3Cu0tWtkwMXT2kT7pwTghbB/JSgisJ1BGLr8H6oHsWgeYnIBjHPmposQbpZu4GmnSEIvIT/0/6RA5TKDhPamyWQQuXgZKHI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 08/15] net/mlx5: Add IPsec related Flow steering entry's fields
Date:   Thu, 16 Jul 2020 17:04:03 -0700
Message-Id: <20200717000410.55600-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:47 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1cd660c7-bb0e-4ab8-c686-08d829e50566
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2448EB2FB3352C279B44A998BE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDq83jWIvYicJPxxtWjOuK+6SjS188VU+jxdni9KV8gbgIzEupXLT3ThIWJVwE4/WeXGAjzgy96Z2B2m6y28kkk0QibELXSK5/Yq7U1kFqtldrzzn5XT7ODZzntvunycioZegPIC+exnLOK8gLFsccoE0J3ffuRijFEsUj74B7MFHCOwgxAGrPa17wI3jdozlflHsePSxEB7ExypVW0W/Bl+kmcghyxugNEJmCzznkqdnXG+2E4tpU62OmVqLNU5Znti88HEbH2EDyeTd7z4a7R+2Vj6FIIG4EBnu0sUfEtYjjVqm6CRgFEI/vKh48TAAwc/GZjIonqwgSRhB7r11bc1YEWAyCOXXnVZv+2A0aFGWvPBFhAuW2sqzD+N0v8t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pi+bTr3BYocEgwejEvLY+GXvriFA9N72xwuzzUTIu2yawu2uUob8AErlOZJxpuaucyCBbOLOS3jGgPQi2/Gwyr15oFb1xf96X/wppcc9tP8cpFBvGIEYVmQgUEW0npOOdDsl4Vz7WtsuOEIpkOTDd+bK2uIos6ZSvhFJtIxoYnpsr5VKR0/CyT96n1FeWwN1AH6RA1pMhLAWSnTQpRlzfwUiaJy5S+l97qBFWqbanZMVNvm5JkdTJ9IOqsGhFvFq5nzsKFQsIv/He0C42KZ7yTx3PhkLUvtrYpVpK6D8Hgx30yDUOQsfhvxEhZD4AtnHZ9IR3db7N4nkOL+Wf6IwN5BWgwDX+N2tTmH8Y81neGWKk7+9x+jetezGPS6PB0kWrDVjuthOP6kU0GWw0j5KKxw2DBMM/DzyPB+z0JJyRpeYUTiIEoetf0lMLLSahHwPMFt0rPMyhtPtdpYRfz1asZb0Kj6q+d8YI0/S9Lajrnw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd660c7-bb0e-4ab8-c686-08d829e50566
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:49.3143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9CPNbEckeOx5vFdFLv/nWRkxWEQngkwhyQ1AqU+W5Km5myuI4Yz+Io4O/9U8Ws0yL7u++skr2nO1QADLkPU+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

