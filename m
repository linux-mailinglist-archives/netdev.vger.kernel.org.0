Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8B268C1E6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBFPmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjBFPmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:42:03 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4FE298FF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:41:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACsUAnFSZKxxZ3OlpR+4VnzLIeBvPEqWVIzo5IiE33aBs4ppPYdi3FFM9v88IOY7nRd+vYPdo+IDc4rUk/UuuMF0hUgLZ17pje6k3YPpqOvO+IpDgPqwsCSSo5KpHDW0r0otE0OOW4QBZ9Jg4rD65MbxAXhTnRvT6NYcBMl4MBrZhX4swyr3YncboYdIuMIKpXNFtfE76PGpLjFslP5x5miOFhwFGZ6nG1/Y5AW4j6LzeBG+3Xrv9r8CcgYDKyrKz3P9ZL2Xz2BBlK16cg4WAOvvxGFon7apHWNH+CBB/euq1qwVnHrHlzUw7s5ND2wnqVly/w9d1aDfdyrpNtfISw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sX5NIMFNrWLDwjDfWzkoS9f3OgRsYhQaXy1QV5lKWc=;
 b=TIqrbIwa+Yx6JiVUZXN5s+wBNoYXmymXA2m2H8BDfXa33cZz4UD8f8vha4bBfaJUpxFRmNhPdRWIAiwQc7kvuiABWg9N+Ko16ZQW2IeYFoMHKjsCzU2j8EYNOk6tICmmW2IqdXaM67f4diqBQ6muPGyxbux2Wg3aiP8pask5TTztRRBbNhBoN31h2fxcBmXuEDkU4SH2JIbPVhQN5b8OMNJCDPZMUzcXF8CyXUxRk8lDVtffJbTAOEX6zoTLau0o9W17boPo5ehTEc1JP53LCVKloIgwijJixsjVVFdYquAyZNvkP8CX36bHY4XmitlDJXO/hTNyEaMW8ub/8Kbz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sX5NIMFNrWLDwjDfWzkoS9f3OgRsYhQaXy1QV5lKWc=;
 b=t08hjnYmp+Z+YWI15rKnspF7mA0MiyCqWuCS3Xw7YPVI6ZZBDVHpbDuB3YC3s0uBanCCsZzHS6MKRkFKeTpH4sDXCt4Ihx8rEJsq2Lq0O+fvWs2MxsoSXffZxNB4WXIIGOwum1XaarTVDmMp2wl8jL/LHj2ZLDwWO3iojv2hptM09qU54QnnaYjHmqTWi8nYMN1tujfChCJ999XUBqQZWEbEaylJttzkQHKOYo46PYpmh5K2UDA5WAYZxxIZ3hsA2g7fzcv00GyFisCQ3pm+LA5iIMcsBAnhP5U7HObGi9p5XpQ7I/X7qVUKGry9BUm9zwXBYO+oSLToTo+6+u+cXA==
Received: from BN9PR03CA0138.namprd03.prod.outlook.com (2603:10b6:408:fe::23)
 by SJ2PR12MB7963.namprd12.prod.outlook.com (2603:10b6:a03:4c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 15:39:58 +0000
Received: from BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::a3) by BN9PR03CA0138.outlook.office365.com
 (2603:10b6:408:fe::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 15:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT069.mail.protection.outlook.com (10.13.176.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.35 via Frontend Transport; Mon, 6 Feb 2023 15:39:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:50 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:47 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
Date:   Mon, 6 Feb 2023 16:39:19 +0100
Message-ID: <74cf16b2284868246417bcd4a8d967d24e355a7f.1675692666.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675692666.git.petrm@nvidia.com>
References: <cover.1675692666.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT069:EE_|SJ2PR12MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d5fff8d-9f91-4579-603d-08db08586721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5wCL7pnmx41cGrvXIls89iQdrgFqrLpdWjIDaTyoxkY7j/q1sWeh4Bjzzap4bFIqTMJOJnJHznCxUHzCASg4muZ5ydhCc3d4oAXkIzTqu4n2skOpddCgcTakhd76uAYsUUMg7fzIfVNzFXAXMRnbbaVYXitrjZd+G1rHIDdsfW0K3FPRXEFMAh/c713LeLXg+tPbMFxp1xwZFs/TXAULLI/Voksr5S0Hp0GOxlsRZ8AjsBBc6Xd/H0ElSV3ZzqEtmhBeM9gZsbXJRbewrkcnoFHivxk7dFZkXZhsipGPyRibyIz16wyGGwXuhCpQBACBhIe+2IwI4U9mOHLpypG2GN7OaWrBqNJL/0VdLr5gPXAytTWlDq7roVk7TFjZjx49iWH4nYRMq56ljwVuIQvl91jb2vQqxFCgIfH4OcbUJs6RhbLukOgusmJsZlVesJV9xQQ9k/68yrPHMBTiefO/55QXfm/UxbVvHOiWN7O8XrzvY1myOi4XhEB9yf9RgN1Ii5vNK709OzfM89Avqu2gjuk7Gg58Q+XVgCknOqfaOYv3iF3GrKLJL09Dsq1t/SDpOIMULgPtzCawTEba9yr+tfUF/sW3smRPHvFUuybPlX2d9VHyDnBJxwMsrxOmbzTsMNwchan5iMhP8qr5Kc15ZJxNsvV+M7ud4t4VqdXeqgCszkUloSrdCi/gTq2Cq7OFRXxcm+lkmjkoDnN88Bi+w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(6666004)(186003)(107886003)(40460700003)(36756003)(16526019)(26005)(478600001)(356005)(47076005)(82310400005)(7636003)(82740400003)(54906003)(316002)(110136005)(36860700001)(8936002)(41300700001)(40480700001)(2906002)(5660300002)(70206006)(70586007)(336012)(83380400001)(8676002)(426003)(86362001)(4326008)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:39:58.1410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5fff8d-9f91-4579-603d-08db08586721
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Pair mutex_init() with a mutex_destroy() in the error path. Found during
code review. No functional changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 3b9ba8fa247a..7cbfd34d02de 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -52,8 +52,10 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 		max_regions = max_tcam_regions;
 
 	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
-	if (!tcam->used_regions)
-		return -ENOMEM;
+	if (!tcam->used_regions) {
+		err = -ENOMEM;
+		goto err_alloc_used_regions;
+	}
 	tcam->max_regions = max_regions;
 
 	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
@@ -76,6 +78,8 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	bitmap_free(tcam->used_groups);
 err_alloc_used_groups:
 	bitmap_free(tcam->used_regions);
+err_alloc_used_regions:
+	mutex_destroy(&tcam->lock);
 	return err;
 }
 
-- 
2.39.0

