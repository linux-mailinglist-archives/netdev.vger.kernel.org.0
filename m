Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB4368B018
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBEN4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBEN4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:56:04 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9661E5CE
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:56:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLOm86jFmaIra9ToXYuBX3MN5l2GqpxgQkGRIvZpsY43NuUDyRBsHDCfqv7cDM7ktIgDw9G3LYNIzbRajK3Oe8yJIB6vvdRM90WJeYmuOWswtbef59GJqwIquJG6kWsYiD4madkPpoRXjfaX1dGklGchF96MZbmvIAvSlrGs7F5tHwPntJEXo5yyAiToSZ9tP0Rvcti2zx2Rxn7peCyYZ7T/0DqUKGybDoiuspbbtMSgHhL30O608qPli5uT6YrnOABj4G5pZPrxHU007b3JD5Oaww4e1PliZ24ycUhBc4NSTFKaYviTB3LzUppin9qifsyTBRY8FyDeBZp2ZuulBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMfHc5isviPAq4o9ckZeUYS1gFA00N0SeOsvV31q0tU=;
 b=etVwfZCQa8L1H2DEGtGyFM9H9szInMluO8He6/rFk81IsNXk9c8GNtilpZkH7/Qsf/qnbgWmV7ppOOzr9wyeEeBX3+b9xvMfP0awqsKpOp1iwbt+uMEzDUR0V67AVWBX2hA8HMEANd8w6BtrrzC54mXK7XxQa4DqG+SxA1r4MIxrCdIgEyFRFS6sl0enagQLYGdjD5FI1e6RC5O0ghpl5LwEN/Voby676POZBLy+aRHPfE/WQcvCehsYK3sImQLDk2tJC1KoCAbVqRm4mCHf2Yntr8M28dWT23vs+IZosNxZJXkZaR984lmoi9/TIt9gQdXWnCfIQpBeCX74COz6OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMfHc5isviPAq4o9ckZeUYS1gFA00N0SeOsvV31q0tU=;
 b=JSncdb4Y6UaSLSBg8X/TfHTaFqVVTGHPIezCI7ntn6heEy0R5HNdVg2QVwJz/EFy0VN+hkOsFEwYurda5T93jzZ8Xzg9GvtRudZw7O35ZsEDHycq9OXCkmosEnzCGRaykOPgFkt3N5ak5ca4+p4hppoTFSfhc/YQnyCddXt5p8lnVPZjeKdUUpGO+J+1JfweO0jYTjIOsonF4Epqoi6tFyzfPLFJ/nruKNkZeWLdKypUX/Wi+n4Op0eTyk2k5tdQUoRZwkD5G08acZ5gfTzo2lLiHVBu+ApjdecirfOC6gQPZseiXDyQO5IB0XrvYxEWKKfQ/k+omejYAuSxQJNuGw==
Received: from BN7PR06CA0055.namprd06.prod.outlook.com (2603:10b6:408:34::32)
 by DS0PR12MB7969.namprd12.prod.outlook.com (2603:10b6:8:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 13:56:00 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::fb) by BN7PR06CA0055.outlook.office365.com
 (2603:10b6:408:34::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 13:56:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 13:56:00 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:50 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:50 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:47 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v2 6/9] net/mlx5e: TC, add hw counter to branching actions
Date:   Sun, 5 Feb 2023 15:55:22 +0200
Message-ID: <20230205135525.27760-7-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT054:EE_|DS0PR12MB7969:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fcf7f6f-e890-4233-bab7-08db0780b6b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUzrI3ZxJlLOZvfqk/P0zhQPSPpfWrlATRjbi9fzCXSQGgnmjTXqGcWwinJ7R4dbORyp7uUEWtVe93Qq+d7Xsty5xi5Pf3xLMBq/zFdc/J+eCoPkWm3kTcPdr6VNI5b0rNUcHEWsGykyQsItT7Lfj0RqNqDywBA+KbgCju42lh4uHQ3fG57yYjxXj/LYJvaHbvSBANXvqvd+PUknnwT2DWF9uaxXG7NkLhXV1ddWPYAm1fVuLbXDYBdLb3Ir6ZNbfWD9YdZSONNW8bRu0eAqWadQdd+O3tjv3kC345zJ24GY07qhV4HViEt41BqfhC4VgTGQCoySvqs3nyKcmcpSt7MMxKsm1E12QLOBUgEQ3tJzzUFSu6qr+5JJ9kwuV7utPZaLSHoj+Ix0nrfpYmK8t2ezBGZFOsa36ASCpIwbkeExfdtSx7SPpsYVXWQJBjpZMnGH8aO3DGXlniuuRYdp+NmZifcGLsYPIrf2TLiF82hl/vxNivsKxq9H90JtY80lClLYkNIFl0EESkXqrI6KEKfRDZxiBOloSM9LbKpGPA4eE7f4S6K3ot8q0CJGWdpkNsKkK1w0SmEBryk3pbHqj+4NnKM0PKxZT8KtmRjePehwb4y/XAQhfuTz8z/7X67M+JmOO4thi3aeefeN5jzhwZnh0IfiyJtRKY3j5UNjhaqQNVyOZAWHmLXiOcBBhs5mZnWxcJ0yGFXnUbV6Wama9A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199018)(36840700001)(40470700004)(46966006)(426003)(336012)(186003)(26005)(47076005)(40480700001)(1076003)(36860700001)(7636003)(82740400003)(2616005)(86362001)(36756003)(356005)(41300700001)(70586007)(70206006)(6916009)(4326008)(8936002)(8676002)(2906002)(316002)(54906003)(478600001)(6666004)(107886003)(5660300002)(40460700003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:56:00.3688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fcf7f6f-e890-4233-bab7-08db0780b6b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7969
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a hw count action is appended to the last action of the action
list. However, a branching action may terminate the action list before
reaching the last action.

Append a count action to a branching action.
In the next patches, filters with branching actions will read this counter
when reporting stats per action.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4e6f5caf8ab6..39f75f7d5c8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3796,6 +3796,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	INIT_LIST_HEAD(&attr2->list);
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
+	attr2->counter = NULL;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
@@ -4095,6 +4096,10 @@ struct mlx5_flow_attr *
 		jump_state->jumping_attr = attr->branch_false;
 
 	jump_state->jump_count = jump_count;
+
+	/* branching action requires its own counter */
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+
 	return 0;
 
 err_branch_false:
-- 
1.8.3.1

