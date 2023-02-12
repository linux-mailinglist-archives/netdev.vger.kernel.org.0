Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A7569378B
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjBLN0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBLN0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:26:06 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C0E1167A
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:26:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGYe1GTmm8lujPTGzLy97lB6VatwsNG9n3LHWoyKadkHcQWZUR6mSyThQjiq1/1TKo4TRlN65S+WoB1jHSZMyQOEE6pP2KtVFq90l14pTve8t+d0Bkf6LigeebW3afJ//jS5SpcJ/V4NeK/hWXXllqZ5Q6xi1If1X78imAf8xnlUuZWXBSdzUr+JzI1Ztkd6yRdcL/3rvWcuKRGsNmTolcmxl33sj1cqS4TOadHQXxS97ZywM4vqgIbWyMjSIyjbtNxiT4LjIgZaD5qhj+BnBOyYee9bHs8j7N7G10RNmlIBbuj6eWqLKPFf2asCf/HOnpiAupVRjELgo54aFxvkEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CojsF1WM49btV+fNacnfmGqaPjQ5mF87InsRxyzeRy4=;
 b=ZXYzIgv5vO5bxzUnSNDXSNXRKxRNYH/GL0MOJ5vScGph1xoiAJj//OLOipFyfuc5ztISlwhFu8mL95iQacbKxMdaB/cxXZPECCCB1v7xIFZkLQCmwYWlfMxJNBCwQCJqww6z861kwMtj5MHKNwWyQc5CVuAD64kdVrNptOuTs34uHJVHLAjUC2btHJkwSO/asA6GIfJo6ArfI6ZoAO0pE6UJhSrHpIrF9EIoXQRPVrth7hfLp5LJzjrTaEP2nFt8JH+n39+PWM81JPLNKxIUHz925kMVo9nVCtBmLeKldos3lKlm9/DOIanYQiDmIJ+5yAlsexFs8VKqrguSHPDO7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CojsF1WM49btV+fNacnfmGqaPjQ5mF87InsRxyzeRy4=;
 b=RjT7bq4FC66qW426K+Tnjds/2Wc7K/7ASFZk47sWmgjs82NzzGJ9Ri0POTTLL5TIRRAB/u227OaeRlfkgZL89YqffHW+cqb+oG07CShF5mRddR0uO7iNuig0Zq7fP70fKO7V9PE0lxrnOpHJgvzOjrAU6cJ1+0w61vRD+6RR6crFKcMQuo40eATNGF8gsUJz2F0jiez3Zrcy+Pr234MnLJfQwAYZglT60TsstvDynkvSJ23ykc6+E60DBVaSqTtjc23cek8hsoBwv0nHCUqLxKmlkPrW/eftqiDzzcMWD1pexLPodNXyPomkrbJ7xoPoU52a4885Pqe1HYaAWMgI2Q==
Received: from DS7PR05CA0013.namprd05.prod.outlook.com (2603:10b6:5:3b9::18)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 13:26:03 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::9d) by DS7PR05CA0013.outlook.office365.com
 (2603:10b6:5:3b9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.9 via Frontend
 Transport; Sun, 12 Feb 2023 13:26:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23 via Frontend Transport; Sun, 12 Feb 2023 13:26:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:59 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:59 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:55 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH  net-next v4 6/9] net/mlx5e: TC, add hw counter to branching actions
Date:   Sun, 12 Feb 2023 15:25:17 +0200
Message-ID: <20230212132520.12571-7-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT018:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: bf7a7d94-da9d-4d03-851c-08db0cfcb01c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rW3Yjb1QPE+tj6tYs2hVdk+pfN4vRPa1XQ4rg7nOQbmKbTTVAJiQXld2IQaUmeEY+zioQggHiU5jNDneKkg38YexhxYZa1jo1dq39AN8wPrE/YSBh8HcokukF5Df/Tql5ZgQgwo7V0GDrBo9rtdk+qbs1TTyiSsrZvxZSfeZydiYAkLiUydkeqVgipWpFRhmdIEvR/aZCvOXAKrS/coCE3jCBvv2s96Jx7qZgXHTQ8OIMhJRzO84DozouRsk3RDbM915sZ2Wdy0Fj07EsQQJFHeJem1ahyb36GC4npb4h+/LOy59f4x2lxi7oNcgf0HaRz0yYB0g1MuP5mJSEXLzbInCPA8hH6J2u3DYHuK1uB/VL5CkoRMmPfWvPf7HohFYiRjsunRIcXiZc3DTT+fqLObN2vW582Cf22QwKqedDz/BRNLuVwTxHjPvawRqu1YzruH7prfLgZYMZikROtPnnKMG4N8vmpPtPtcTZYOAqMHqH1URmO3HHyP0uF6B80oTTVDy6dI+ttqHUZSO3aQMT49TCQAVbfApoIrGgodkopo+bjTLcFQae3MM1gFjQ1zQdis2/K4oyLlO4+IU7DlAC3cUG3ZA8fypTwk6XE/4Jnv2HK2zTADhu0HURf7KeKjmbausckww5sXE4ckVs002EfcEJO/Jfb4vD2UA56PnfzM=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39850400004)(451199018)(36840700001)(46966006)(5660300002)(41300700001)(8936002)(426003)(47076005)(7636003)(36860700001)(82740400003)(82310400005)(86362001)(36756003)(40480700001)(356005)(2906002)(316002)(54906003)(1076003)(26005)(186003)(4326008)(6916009)(107886003)(6666004)(336012)(478600001)(2616005)(8676002)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:26:02.7758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf7a7d94-da9d-4d03-851c-08db0cfcb01c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
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
index e2ec80ebde58..a3b46feeff8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3785,6 +3785,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	INIT_LIST_HEAD(&attr2->list);
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
+	attr2->counter = NULL;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
@@ -4084,6 +4085,10 @@ struct mlx5_flow_attr *
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

