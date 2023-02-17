Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEA669A470
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBQDk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBQDkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:40:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1985B2FD;
        Thu, 16 Feb 2023 19:40:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl66N/9pq1X3UrY12n3g/guyjEUUha7+w27RO6fpwaEpsnZ0WkGSD+VoekgohQDX7UBUy5XZX/ngTSTtVDh37krfXsYDvh4BVQKZMOOx+U8IMa/intXWL17laY9KQ1VKjePY0CIKgTbv77xjREbjiGHal4nSgEQGq8sypUuHXOijvsVG6vcUR6boOpjlF6VeLlu3XC2HKhXt6SmlG6sp/wq4dDpYKsORSO9M4ptjtI5Ij7q+M/xS3Xk3inN34MAVZHyxmX6V6FPS/pyhB6Zo7kS4PkGHLOqRax8HwlCh8rTwRqe/Z6mzXdBvzzuHTnFEgA0BzlnYtWJR/7JVn80Eqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzVsdjsnF/Vm2FAg37jtKuyrnIPpmX5DxdStb0gHxSs=;
 b=LrHDXNuEPB9GfUObYlSwZZ4tkkxo9JK+zwi/93+6iK0zh7JWZ7WtPMSQpVf3cWzgmTYTtFzF5Eix3rEGPPk4M6kjFp3SX1vF+n+GpJ30kzcjadMZmTZKOy33rgRD73stbgYbdk0cnt4/y8SuZuDcjsPBwZSWYBYQbmawCwOEka9tSH1jQGWrXVXnIAUaxcKVAEH2O1bgAqQEEc5TCA1VD9N8Scg039YyuDIK0SphJeXw8Ui2X/0vRZbd7WHjcPXKNhVlTSNHUZpTlaIi5xXs86nErzVEFrqqveHyD64TrdYE0zOT16t//gSSeQzhw2aF59CWk1tEsf6SLflgecuTCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzVsdjsnF/Vm2FAg37jtKuyrnIPpmX5DxdStb0gHxSs=;
 b=nh2Zdtv9d9w+O2d6W3mIx2+HYzXHA0AY/BgDN9aton82PNpAngrMM9fz3RanQ/iJYJWz9zF6RaxjSuu0I7ogt9ha8SaCCQkWfFQzjW4xZrilKx2B/4N1Eri7HPsEr7vSyR8RlmLrUOlh40f68mWqYBKV5VGxr76AbAF3B4Q7z3UK/gdNNKP6JE/Qq5sKqpqUm0d+trvZp/GSNR4znHS3rhiP0HeGMD0HXMzarBbaptw+fu3SSXg5L1v/5snOR8op03/gMHetB/6NhBYuvfKQdqokSEKnKdQaEWqZn7rQEQP6ca6c/bKD5Twz2xHdMmXZECqFPXjOcvjVbe6TVCyuHA==
Received: from BN9PR03CA0325.namprd03.prod.outlook.com (2603:10b6:408:112::30)
 by CY8PR12MB7098.namprd12.prod.outlook.com (2603:10b6:930:62::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 03:40:10 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::7d) by BN9PR03CA0325.outlook.office365.com
 (2603:10b6:408:112::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Fri, 17 Feb 2023 03:40:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.15 via Frontend Transport; Fri, 17 Feb 2023 03:40:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:56 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:52 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v3 3/5] net/mlx5e: Add helper for encap_info_equal for tunnels with options
Date:   Fri, 17 Feb 2023 05:39:23 +0200
Message-ID: <20230217033925.160195-4-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217033925.160195-1-gavinl@nvidia.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT004:EE_|CY8PR12MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 9be4f839-690e-48b1-1470-08db1098ab41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEAaFke8IJFbufryPilSM+T5xEldchVT7UIYQJkL8JxYUTZv6vjfx30UmFZkMrpKK2szMjMm2C9AHTk/ET2AoE4E2FPmEG6UjpEHuupnO3sV3UD1aDQOooSdEnXbTMwZMhbOilYExcMeTEwtw4MP5/56b5Cj8u+pQ72cSE6OuSHIjK4SrwEqnGpc3Kdrzcr2c8IsoAyjTdjChCzRG8itRf8lcUwql4kU+1/OAmmE32NUSt2Pr7p2+wr/Jy+MRGLv3PyJ6loRBtc0K2jQwAnB0pOOCfc7pztWt4LOGGlA09ayibRymY+15tae3xQIB2+K9gn3mWgGMpVdTtn26Khn776iWSbInfCR7439VvDXcdtp4D6Ce4wjUO2oBeX1YlS+s7YnR6fjTf9sFPaWqOUEiLoDEhC/RNswvXCSI8g2pS1ok3axdSi4YSr/F3w70IF5bxkDlItIO2w5MmkZM3u0/csQJqb6PuF0XUyk/GRtw5LO7ebYTg/cVh80+10iXVcc/Wq1ICA+mhBrdlPU6fnUvr30doxyNMdu5P4BxV9tKVt2R1Va04uBap2gd1P+NHIJ7f6Teey7LQ6snTY0vJpwPCMpopMHn+z2iQ+905wbsNUzjonhchRbG4JK8LWxFojH3y5vZO8Yl6MROnIA0o7kEM6xCP9+E6kIY5Q6GPTz6dWDk3JQpihFQhNYHzQjR4OBlNOwHpee2rE3vnuno7De+w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(8676002)(83380400001)(8936002)(54906003)(110136005)(5660300002)(7636003)(107886003)(41300700001)(82740400003)(4326008)(70586007)(40480700001)(316002)(55016003)(86362001)(1076003)(6666004)(478600001)(36756003)(82310400005)(26005)(16526019)(6286002)(186003)(36860700001)(70206006)(2906002)(356005)(336012)(40460700003)(7696005)(426003)(47076005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 03:40:09.5268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be4f839-690e-48b1-1470-08db1098ab41
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7098
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 780224fd67a1..f1d132f16fcc 100644
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
+		!memcmp(ip_tunnel_info_opts(a_info),
+			ip_tunnel_info_opts(b_info),
+			a_info->options_len);
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

