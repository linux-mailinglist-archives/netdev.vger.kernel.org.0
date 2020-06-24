Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867B9206B62
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbgFXEro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:47:44 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388036AbgFXErm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:47:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fq6DtLoStOI+GJO1aRrcpyMEiisAoiNJTGkpEoec4RAwik2bc4GlFGFRbJEvOT3SSHsC0fjFLPTs7zo2WRHhZ9TW1BY3qwKjZiGV8A9dQs/ICPf5eP+PB6hTms+VTt5IJrnNsbnoE0w9zrp+UQEbijjNocZGkLlfJqaYrJtJraoMC7xuSn/DebiBgcEqQHDzgB3NigccBx57tLS6KjSjewO+tta2SXDky5ciHcS1Eaw9xuF660pdKJIItgxqa39KDSrhWmNtwJpDXq4ZDs5QJpbetP6I+MbMENDn4wFIF03rvX1vDZPn2CJzQPNBwWemPGkBQmvpfCxn9HbRjd6sSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1ulmEsLk87aPuwLqOA4+/0tBo0bloH/+X64+wQ9dqk=;
 b=AjaK2uZQPX/Z5VUPKLnCG1EwNLY8mH2mHWncO53JIEWpd0ZD7LKZVQ6W+v+F7C2xsIxl7QtY5/sgOBym89IlcC8Z7z0ZCM0C781n3+So1xRlgiTOevc3hQtLVK2c7ywCh33Tnvz81BCbY39PloiNiQGS7dL83WqzKJ9DkvjwjULqxT+r7+Gh5ML7RJOHEQ7pSxoDUC3tCpb4GPlBfHRa8NthxJfL/cYdMHbPb3R8wamFcXZiBB5V1sGDJ4Wreqwvh3D38whilBVbaFSHYgWM22Ia697DHt3SW4I6q6uF7lFu9DedAIH3Tk1brBrzFTeC139i2rd9/OlO/JJHqR34Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1ulmEsLk87aPuwLqOA4+/0tBo0bloH/+X64+wQ9dqk=;
 b=rf5+sYbmXL3P19BZJPoyQ/oGdvYVNCLhqZNDx4rJswiP1x1jnFjObUvRiQXrbMUYakiVotcn6omTRvOhl2q9RtG8vQ5TtW9LwqsUf8uishRb++czaQmVOX5UUCzs7haSnYcOPpT9dJZR2CRIkhl27pnfRX00pgOMZijz8RTCI5A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Maor Dickman <maord@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 6/9] net/mlx5e: Move TC-specific function definitions into MLX5_CLS_ACT
Date:   Tue, 23 Jun 2020 21:46:12 -0700
Message-Id: <20200624044615.64553-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:28 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 34de92d5-54cb-4453-d188-08d817f9b3cf
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51357EE4D0C41929FAE2F09BBE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jcdWiGTqDjxSyYQRzcNl8f0zOP0qBgncOhg1A2/zem7xM/1XuHJx0RZHKyBdHEQXnsfOB4dq5DiDxsiLKKHpgjKtIne4VTMsVESXcG/3gXesjqWuGMaeuYEwvATXTMKFXaxFvd4jjR2qkGxg7R2tHODsJobhQ56JnMd4XM/bz110ef7nmyJy0LfEraz6dSUvHqCj5guJYn2/InWoKz9goigqhAS/QL61SYGCdEuRprdl4W1z7i0Hog9yeUcVT/b6QE6UuwmYKSxZVznePKCW/1XQO1c1mybfaOSSATVrQGyr37lJk0xN8uUIu9ZoQfb3ecREjVM+dxXj6yggfu8+lD/kkQ9dJIhlq8tybAXhsZmoSwkU6Q0va/r3x7odWrY4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(54906003)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7/pzN24sj8VeNx9aQt2k6gWECuvdFr6/myagliKLh8GOLlVDl4w6ii4bAH4Uig4lmCrOt4uteyfI7H3Xt0AYzF+aX/jVcba42P77llkPsdHMjXA6fM3FXC/Hk3PpqdNi9/dNMPEa6RCucEtV0TcpmlvDfjtMKFwgL6+4dl5fjLqzEZu8G+cfvP8cP4uKHWVTEGli/bG53APxR9qT5/JE2pk7eb6kDLIo3k4oPBhlGwZBxRj+AuNGSswEYFdr9272tSFRNKbk3iIh9dU/WMKALgiqAuqVl3jJo1Xh4GFkSeaqulKu0V//Eaz00oU4eThELHQaYfMI8mZmaeTcHQSnbgO1K/z3hyPXWNKGe4KCg/G1Ilq1TDvF4tQ3bl74S1bguI6SMy4LB/OeKxXNYc5kdUq+PMT9I7mLTcE+ZmCrcH7YLrpxaDQWjVfV5Huf26F7aCwoq0ho8SRSF0dkny8UWgfkyIZ6zQZOYB2FBHyh0gztvntYwt+y+I0E8mcHUzYA
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34de92d5-54cb-4453-d188-08d817f9b3cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:30.6830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSgge4QXAI6PBIhFvqmmdg6z5W1MAkpO6zXLDnSHG2/zzIEQlOF0RqXjSnDJ6NKcKueuGgbCeZNIYbKSt4PePg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

en_tc.h header file declares several TC-specific functions in
CONFIG_MLX5_ESWITCH block even though those functions are only compiled
when CONFIG_MLX5_CLS_ACT is set, which is a recent change. Move them to
proper block.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Maor Dickman <maord@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 5c330b0cae213..1561eaa89ffd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -40,6 +40,14 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
+
+struct mlx5e_tc_update_priv {
+	struct net_device *tun_dev;
+};
+
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
 struct tunnel_match_key {
 	struct flow_dissector_key_control enc_control;
 	struct flow_dissector_key_keyid enc_key_id;
@@ -114,8 +122,6 @@ void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *flow_l
 struct mlx5e_neigh_hash_entry;
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
 
-int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
-
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
 enum mlx5e_tc_attr_to_reg {
@@ -142,10 +148,6 @@ extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
-struct mlx5e_tc_update_priv {
-	struct net_device *tun_dev;
-};
-
 struct mlx5e_tc_mod_hdr_acts {
 	int num_actions;
 	int max_actions;
@@ -174,8 +176,6 @@ void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 			    struct flow_match_basic *match, bool outer,
 			    void *headers_c, void *headers_v);
 
-#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv);
 void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
 
-- 
2.26.2

