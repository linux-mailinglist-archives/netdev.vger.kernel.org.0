Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C4520A675
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405474AbgFYUOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:14:12 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:6196
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405218AbgFYUOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:14:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnUJIWrs/mvkeTuaMaBG2AwbuduLd7J71PnEXSjn4ldtZY9ToVoSAofv5nyn5tRPnUVTdR+Js36lvjQu2Zrg4eQjFRO0GukjY9qRGx6Boq9LRKdxJ00T9C7URfzLEMf1yzjbd+zHXewQXwPQZIplSs3NUjzIDopfn54fCpUXIEt6PhZLCzVPSyQUikzYetN5HiVJisxqgsVV9cQsOTJT7+SpCpPxmePc2dp6eP80HUVjq40/gjfSvEcjs0eEhAxxmH2Dv/KW3Hly4pchD0amq5uTzMPyyxP5itKpMSX7NjUMJG+IvOuMrjozSfvSf4lwb8zFLB2/GNlMt9p1HeERnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1ulmEsLk87aPuwLqOA4+/0tBo0bloH/+X64+wQ9dqk=;
 b=dBSOhbt3srq0mtmUNxKXcTw5VNVlNozsV65Vh0lTQ7j9gw068gJBszyZ7V6mrNC5LPKJDTZKgneRpzw7HXkBgfB3zlz6GoxPP7/jkbRdohYCxpWEP0N+tHZ0bPaUTF1SunBGNH7eJgzMFgHQr0+I79RvWT+Q2PBzHUn+W9hsG29hlwOUFjmkTzwLQMpYSsaQlUWhGcz4PdKe96GgIPyOtqUzyuECQ0QAmsqQCbrAaBIHT9SqVh+l9EE2T3OSN4vFHa5oEPoREGGN86uQgwg2BsEY6KTO1feWp6LO9iYBDli+AiBqVi4QRzQjBA9R4n7yfu05P87mzj+Sb24mxp80Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1ulmEsLk87aPuwLqOA4+/0tBo0bloH/+X64+wQ9dqk=;
 b=tTuJIrzy9wLlTXdlfbB0ncans+GcZvNCnnGGyuAqivzjVSRapV1TmXl2/mEe1GeYxX2xBGUFcfEppwZa5DF22/LN2/hbHhJsCXkUSPH4Q+TDvA0k1dQqgPPM/e9tizlo0IXNRjAQlcvTdl2g9Inx8P1coJQZyuRZDjo5r/QLPq4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:14:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:14:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Maor Dickman <maord@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 6/8] net/mlx5e: Move TC-specific function definitions into MLX5_CLS_ACT
Date:   Thu, 25 Jun 2020 13:13:27 -0700
Message-Id: <20200625201329.45679-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:13:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2eafda3c-30f8-49b0-9810-08d819444cc2
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2448B7A6862EDC2AA2C856FFBE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlboZRtBr1FdKa9OttmDYOsCXmx4KF5OPdkRCYJ+pGa44Sbkbacl+z92/KMfhIxQtN5rSbeD4uO/ICjehzeKquTdF/bG8EVQFiX/eVz85Zkfvh0CcbhoGoXS/6pJACMOWIIY2rOJE2RsAlDCMdKZwNBnIplX81+pha7r7MGaTMSY5WgC9ExwGdQ5aVwwIPw438IBygbjccRh/fjaA52Uc/Cu2hb0oMhU8Fka1XDqQSdZuTX66oVCLreuAFx3wE7B/Bu7TDc2/V9FVMDhcYiVkSBZsvekzz2RIrPl6NYrfxmmXSvtDrO3v4CRvv7QPt1qdPL5S/gqYbW/5l6RI0f+EyLteW4uB27l1bCQwf2N8cBhqJOJwKP8bwSVPVeznamz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(54906003)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zWWR+pPwxaNdf/cxaVQp9UA92FJznxnLPK53tfMI0z/PAXD8xYLr+xQZMFuj+34Wi8LfPjZe7A+cdul4gzOeEpxQ8SyiSCC0JuoxCCU9GZ5uagD//wQZX7RmwGm+FR1n7gGDyNROapELLYbUQ3nXTI8nQOBTPTpMeG3BBCadPJaaM3qi3JIxuo+HwrzOO+VnkQfsrz44wRYvfr+TjM4ksXMbq6Aa+1FNa3M1Wo1wQ+Kt6IW/soS/Iy9NxOEHtKJx6orLO2MXHvpvcWwtjGo5tvJwA+VUJuhFZm8a0O69VkWSaxnoTpE5Jrcz29IEQixstefezGhwUsDQdgX4tQ80Hi6FK1oEILu1JnvPRmKvMR/wJ/fDv9IrlO4rcAemTeKdrK9uQgcSNoJ34ggT6hiJGS49oDZK3baCw5m7xRv986c1l5R02JhFhF6JrlVRf8iTw14TflNqMm19Pl5vGSOLoKqgzmAjUSuXiUQY0HQhIM0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eafda3c-30f8-49b0-9810-08d819444cc2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:14:01.3344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EoEHE2eRhsEU3vm58M2sqQP0huKi22gJQl/EyO9HAD2A9mbsXLU2s/tzthh2XZjm0bN5NDcb899C10KdV3xqTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

