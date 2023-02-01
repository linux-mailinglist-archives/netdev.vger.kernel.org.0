Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A15A686B48
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjBAQM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjBAQMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:19 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04738783C8
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:12:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXVCJ1m/amfIYKhSOZjR1sD2WGHhPRZ3ZnkLTAJ/9iN3O+PZS5eZuxWpK/KCNKyFl+G8+On8u+YdlJpZD61NxDvPZfIIrt/48R3hThdnYUe9QR2/rEqaSyFumPKSt4D2UL0EByZclE/lmtgh6+do1fqYLnmarZB5Gpb8p/7O/Ybg8HsHaQZgUtVuAUZ2RH5kJ0PXI6PD9RHJwPsa+f3GY9L/FUaXzMVYQCeRVrb8rddWT9mT+gqkuIZIXyDDzBGrM9a6UfAzeT1dSZPw7HiVvOL+7XPTwNitkZ25tQFGMTMMwpOqZrNSPDGuivdGeqcbK3tYLF4myHR9LeY9goaTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jfFfoImAJIqhJ6Yj2CFjv8Yfc3z3/hD+s92ePxhMxg=;
 b=AungUNzy0WapoDNA8Tldb8BE7QkdybCIV4+Q7uLn2S8NqyoUnUe4+lHNzcD5Nj4WYIgJbqeDsUk3urH+a+3D+scx/ynxuV2He6ynE5ldbxxncFE/lISnF3UAHfeNQiwiBdf7R0q/XxVydS9fqCXPfe4lo3h+bp5B9ASdai3I31e/goQOvEFNvkWey2V4eeSKY3t11wTcZnm7H+vtAJAwZ6/5eje5rpiy2MCR01Bsr9wvCnO4/fTtMDFVGU8Ndp6wN3TPWrUrwSf2LSaABqDF2B5xrk7lI9Y0FOa1FnXPKrubrzNG5kDkK/HRw3H13g4HyPRRtgzNoW7XDkQpZ8DI5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jfFfoImAJIqhJ6Yj2CFjv8Yfc3z3/hD+s92ePxhMxg=;
 b=mOskJEIjDFYxXkX/JVZhS2dn2M7nyG6eRqX4wLj1DLUl9afUvQeTQsabbSGsTGv/fMuGAfh2MZhHchRTg6jIjn0FJjTEPGAeZqGyBpBItGQ9YMXNpKgnkeICEh0CxG2R2ccpTY+f4SrdqnV/HaPLDwxcyalgKp5XdMUkaj5ukJYGzd8Iv0laXflotHn6FngkJoaOfPSnnwL8IKACzERwQoQQaVaHS5zdwdaIkUqJMnLxh0srgvDl2uNi280OU5w+EA6zLSZlnU79se+jtPvTXusBRe90MiRiBn7KCLNVCto0bSRWQiITp76sLJ8ScbxQ5E0UUdnEwRxZ1Kv5FoMnUQ==
Received: from DM6PR07CA0110.namprd07.prod.outlook.com (2603:10b6:5:330::26)
 by PH7PR12MB6418.namprd12.prod.outlook.com (2603:10b6:510:1fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:12:09 +0000
Received: from DM6NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330::4) by DM6PR07CA0110.outlook.office365.com
 (2603:10b6:5:330::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 16:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT100.mail.protection.outlook.com (10.13.172.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36 via Frontend Transport; Wed, 1 Feb 2023 16:12:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:12:05 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:12:04 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:12:02 -0800
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
Subject: [PATCH  net-next 7/9] net/mlx5e: TC, store tc action cookies per attr
Date:   Wed, 1 Feb 2023 18:10:36 +0200
Message-ID: <20230201161039.20714-8-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT100:EE_|PH7PR12MB6418:EE_
X-MS-Office365-Filtering-Correlation-Id: 833c81cd-ebda-4ca0-1552-08db046f11be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Qcw3KR2Ar0ud4FHvc7+uiwfoMXHsXTHC/gEwVmc/z14xlCA0pqrN7QYCaJC5zkhjr59B5kfd9Ujs4u9T0J4c3/HdlyndnOTGQGFQArNPl10pZcjDCWAN0gC/vVVdwJafc0dNeI5xTqzi0Yv3DCi5M0tk7SIAWC3IwoJv/du9XN6iYqy886OcyWngLlrlv5h30ZTL/ZJlpLWJvZ46Y7MEdqUcLmGt9aMMrdvJt1RXMVGjyjMSoBGpbAxxM7fk7DHf88YM+E5QZ/R6IJz7WtwC1EDWeTcRZan2T1tD82SnjK5SW3op3tYkJxvAVxo6deR7Q/69BrcgiErX6Xfg2u05nVGTTlt41h4t9HFYscktFNV1jkeXzYUXEMlt1aEEp35A4iZ+ybVMyPkb9bvbgww8z3VM/ewzzPKWPNL66CQJoYMvMs4wU0l2siYRFZFeoGKB8XiCnAmQ1s2Qw0+8xj0O7puG7R4XzrrHomk9NSYbvAY79ikdM62L5a5xLrwF3++BMdw2wGh95XahkJYkvob0F/0/ivENjIXUmtvBxjzjoRqdhm3Doow5BLZN/t5VniXPF2N/kubJAosh+Fe98ZNJzeGw9vMGzRqvlzEjFwPwTMLaJSc3v6qCYo+Bs5nTBjb2yX6fZAfa/Hu1xdwnr5Bc4WR3+6HrTeirQmKmTB3C8FKidTe87NSxIm+vLpRtp5Ca8WzL/oldc1zZ6fS1e/JtA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199018)(46966006)(36840700001)(40470700004)(356005)(86362001)(82740400003)(36860700001)(70586007)(70206006)(316002)(7636003)(36756003)(8936002)(82310400005)(54906003)(8676002)(6916009)(4326008)(5660300002)(41300700001)(2906002)(40480700001)(426003)(336012)(40460700003)(47076005)(2616005)(478600001)(186003)(1076003)(107886003)(26005)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:12:08.7045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 833c81cd-ebda-4ca0-1552-08db046f11be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6418
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc parse action phase translates the tc actions to mlx5 flow
attributes data structure that is used during the flow offload phase.
Currently, the flow offload stage instantiates hw counters while
associating them to flow cookie. However, flows with branching
actions are required to associate a hardware counter with its action
cookies.

Store the parsed tc action cookies on the flow attribute.
Use the list of cookies in the next patch to associate a tc action cookie
with its allocated hw counter.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 39f75f7d5c8b..a5118da3ed6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3797,6 +3797,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
 	attr2->counter = NULL;
+	attr->tc_act_cookies_count = 0;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
@@ -4160,6 +4161,8 @@ struct mlx5_flow_attr *
 			goto out_free;
 
 		parse_state->actions |= attr->action;
+		if (!tc_act->stats_action)
+			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
 
 		/* Split attr for multi table act if not the last act. */
 		if (jump_state.jump_target ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ce516dc7f3fd..8aa25d8bac86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -70,6 +70,8 @@ struct mlx5_nic_flow_attr {
 struct mlx5_flow_attr {
 	u32 action;
 	struct mlx5_fc *counter;
+	unsigned long tc_act_cookies[TCA_ACT_MAX_PRIO];
+	int tc_act_cookies_count;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
 	struct mlx5e_mod_hdr_handle *slow_mh; /* attached mod header instance for slow path */
-- 
1.8.3.1

