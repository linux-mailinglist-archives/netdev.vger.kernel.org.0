Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CE06AB4E3
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 04:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCFDEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 22:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCFDE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 22:04:26 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D1ACDD2;
        Sun,  5 Mar 2023 19:04:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gw1Fwhdii/3qXVBb0EVEaVcNgmOlfgbjk3AFacUxy3uynOyywN63kN5ngp+dr7RnZwbXo8rK+/BEUMFIBoRV1p6q7HCNDPnt64p4PzyTZ74LoBOuTH29+Yrmk1mvkUU5662hKn/LrnFUv5esD8co8fO7idjzIsj0TGgVA/DGh2SGu3/xUjAw5107XxWB7Pk7hDWeS3TydKdnqhgYtl5nPb0YjrMaNcPtF/nYnD6d2pK2FtFgzBMVZRmCd6SD6UxmTRaqtrLzbg06oHofm87/AUmMFAi2lY/v5nwUTPbB/9cL+LCRKYR9Uy5KGvmP5ZrnzQOFlvdrZuNF0FvINgUysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N179DlG4Bn/W8g7JOeG9FuYbjDYjXPaJecv7CzHK2fc=;
 b=UTNn8xf7tF8QyMpoMJfwYjCgjmgFB/Bvc5QczGNxTQTFZaygy0hyziHYwcnNNJOUZrjBAoRMCtFO7fkmIc7KDhqz6S2fsitHA61DnWN9EXhbtpjebBEiNAkNbCHMdMSo/D4n9WsOUZ2GQxE+jOHrJlFTSLhrB8CLSCZ6JPNcmoteNbtI3vTDla5mwj9QgvvkPW9L+HEsc4PobAt2u4sZwulAjego3nyb0tBqXN/Aqntvow8UWem6Xy4NFG1XDSRtP1K/2S5z46s86OEnnnXG66S7k4DIJ6BOSAzxmThhRFcPMICL9+VqV00V1GWJzfeJxaRzBuBC62R+Y7j8q2O/Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N179DlG4Bn/W8g7JOeG9FuYbjDYjXPaJecv7CzHK2fc=;
 b=k7FsGJfd7x01mK+kD8FdHT+tSmc+tZ/xgsRg1JbrSO3uyNGGk5IxIVpqOQYJoOMY/Z6c2MyX9qg/HpiX1txyguHBWPo4VGx41ij/TJe1obVM+mrsbDkwZywZUqq53vXc9rtOqljQ0vDxStZY5H+i59AqO1wZDd9slzvd6fU7VMjEND77BX80eb8gDLa+wvzhHvwvltcZ8Yb9Gyz79QERAlkzrCjUJoX1byxlVBd7NVYvXHt0l91RYBJdIJtDU9PeNkgysIqyITeSrgFkCjyfW9dZt118NfApWgydN+YxCked+THjzP5No7yKMYJs2iuorAQzH0pV4e0PKK15VZxOjQ==
Received: from DS7PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:3b8::27)
 by SN7PR12MB7933.namprd12.prod.outlook.com (2603:10b6:806:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.26; Mon, 6 Mar
 2023 03:03:59 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::aa) by DS7PR03CA0022.outlook.office365.com
 (2603:10b6:5:3b8::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 03:03:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 03:03:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 5 Mar 2023
 19:03:50 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 5 Mar 2023
 19:03:46 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH RESEND net-next v4 3/4] net/mlx5e: Add helper for encap_info_equal for tunnels with options
Date:   Mon, 6 Mar 2023 05:03:01 +0200
Message-ID: <20230306030302.224414-4-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306030302.224414-1-gavinl@nvidia.com>
References: <20230306030302.224414-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT034:EE_|SN7PR12MB7933:EE_
X-MS-Office365-Filtering-Correlation-Id: ce4d2113-c303-4cce-10f3-08db1def6ee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iAflozl0a4g7vwlEChQmzkrFWGxGrz/ONYEaOhO4IPYOre2lx2pozo9sSn22dRR23ztx4Mqjn0fwaQkIt8NnbU+ZWr62/r/axL79ub4O/zkbLVaTXUE5zioK2zfn+aozF+t2/lSo6Z1cu49epbQOoH6Ljot2gNFb9ONIqShmGe/qLwvqVNYEuCLPlTpIe2Wk3peTQU346MsmAceLNpJ8DPBGLiPahckGsgD1lR6GqkH2EwPu+Af/2aUr2CA/ic4C9qdF8ybFVqIXJI1h6ovlZsxWgxcoJg/6VrsRWQNe3GjSqFbsAIkCvEwTG0cAtD9ihdGWie3TYfrzjZr4mY/T5CO0e8A964igypsrei6SLL2LR9pNUqZsp8gIP/f1LR9/iCg3eA99UztVUgmOM2XqHL2SD2M4bFNzfl4sm2LVq4MR4tNleNy32WinUznZA1uRBLB8akqoWjvy2fe7W3z2X0qj3rZuimXAefVg0SU2MQG0ImeCvXIQEf0KTbfDrpE46nBQ1rL6WRNpAnr9qwYXt3NUSDfCMG7bUEbE+6gMUZL3iGe2vKY9bwXbrEEW6s5fDytLxUu8h8D45D4qtNOFuMi8mmgh1ubACCdT2ptpZHZULgLcQBNqwLeQo0jUFLJYtGlfXx+Ignc6qG8Q9250oC8A2/J9ep+oAQ5wVeafw8X0MvbkQAh9RfPAnR5xwmjufu1XX74t/gH26hSpDIe0EA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199018)(36840700001)(46966006)(40470700004)(26005)(1076003)(107886003)(6666004)(36756003)(36860700001)(426003)(47076005)(40460700003)(82310400005)(82740400003)(356005)(86362001)(55016003)(40480700001)(83380400001)(7636003)(6286002)(16526019)(2616005)(336012)(186003)(70586007)(70206006)(41300700001)(8676002)(4326008)(2906002)(8936002)(5660300002)(478600001)(7696005)(54906003)(110136005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 03:03:59.6258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4d2113-c303-4cce-10f3-08db1def6ee3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7933
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For tunnels with options, eg, geneve and vxlan with gbp, they share the
same way to compare the headers and options. Extract the code as a common
function for them.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 ++
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 +++++++++++++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-------------
 3 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index b38f693bbb52..92065568bb19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -115,6 +115,9 @@ int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
 					   struct mlx5e_encap_key *b);
 
+bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
+					   struct mlx5e_encap_key *b,
+					   __be16 tun_flags);
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif //__MLX5_EN_TC_TUNNEL_H__
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 780224fd67a1..a108e73c9f66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -3,6 +3,7 @@
 
 #include <net/fib_notifier.h>
 #include <net/nexthop.h>
+#include <net/ip_tunnels.h>
 #include "tc_tun_encap.h"
 #include "en_tc.h"
 #include "tc_tun.h"
@@ -571,6 +572,37 @@ bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
 		a->tc_tunnel->tunnel_type == b->tc_tunnel->tunnel_type;
 }
 
+bool mlx5e_tc_tun_encap_info_equal_options(struct mlx5e_encap_key *a,
+					   struct mlx5e_encap_key *b,
+					   __be16 tun_flags)
+{
+	struct ip_tunnel_info *a_info;
+	struct ip_tunnel_info *b_info;
+	bool a_has_opts, b_has_opts;
+
+	if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
+		return false;
+
+	a_has_opts = !!(a->ip_tun_key->tun_flags & tun_flags);
+	b_has_opts = !!(b->ip_tun_key->tun_flags & tun_flags);
+
+	/* keys are equal when both don't have any options attached */
+	if (!a_has_opts && !b_has_opts)
+		return true;
+
+	if (a_has_opts != b_has_opts)
+		return false;
+
+	/* options stored in memory next to ip_tunnel_info struct */
+	a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
+	b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
+
+	return a_info->options_len == b_info->options_len &&
+	       !memcmp(ip_tunnel_info_opts(a_info),
+		       ip_tunnel_info_opts(b_info),
+		       a_info->options_len);
+}
+
 static int cmp_decap_info(struct mlx5e_decap_key *a,
 			  struct mlx5e_decap_key *b)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 054d80c4e65c..2bcd10b6d653 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -337,29 +337,7 @@ static int mlx5e_tc_tun_parse_geneve(struct mlx5e_priv *priv,
 static bool mlx5e_tc_tun_encap_info_equal_geneve(struct mlx5e_encap_key *a,
 						 struct mlx5e_encap_key *b)
 {
-	struct ip_tunnel_info *a_info;
-	struct ip_tunnel_info *b_info;
-	bool a_has_opts, b_has_opts;
-
-	if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
-		return false;
-
-	a_has_opts = !!(a->ip_tun_key->tun_flags & TUNNEL_GENEVE_OPT);
-	b_has_opts = !!(b->ip_tun_key->tun_flags & TUNNEL_GENEVE_OPT);
-
-	/* keys are equal when both don't have any options attached */
-	if (!a_has_opts && !b_has_opts)
-		return true;
-
-	if (a_has_opts != b_has_opts)
-		return false;
-
-	/* geneve options stored in memory next to ip_tunnel_info struct */
-	a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
-	b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
-
-	return a_info->options_len == b_info->options_len &&
-		memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;
+	return mlx5e_tc_tun_encap_info_equal_options(a, b, TUNNEL_GENEVE_OPT);
 }
 
 struct mlx5e_tc_tunnel geneve_tunnel = {
-- 
2.31.1

