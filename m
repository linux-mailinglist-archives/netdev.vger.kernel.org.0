Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F869378E
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBLN0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjBLN0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:26:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31CA14220
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:26:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SujyHiwilsWL2VwhUNXqKXH7hgEBSa/yHlUGHPAame2MjWSJ7j6bBNs+cQuAfFI1ZmEBuzUm8y8CQnn72sNpFpX4wKNVZ8T+ofs4aNcrBMm86HZPlwknRzfw9H0l2mbNjfNGec8mpHZuYZcqn/mrmAbktSuhwve6UTRGb+Sr6uWv+4Qc9JwuGw06TGiG6wTgMTrp9WVr6X5t5V1+lnN6qwhKuCvNyUPiySh9hnN6zOC+Xu5NtC9lDFuBeeNh6SWG4GC6Mr/RAd/xxNEsakP8JPUZFZ9QaDNySllCqvU1kqqusitOw1jhGY61bRM+PN+FNfs2J6HAT4NPY3f7fiXDJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57PLWSpudxHF2rkh/8dLnU6NGoPex/ACVkAQOMuRWY4=;
 b=U+Xfm0OQwbrrJb3Bmkzaju1RHOJ6/Ao+wJy6/vk13FT83Q/jNZaPW/B1oMAsKCC3VVY2tzclvr2GXUHWgWAaSoUXXPTI1NDkPNXN15DGFNuey+tMU2YKdoQ1cnYn4l8nf+AxLG1nbsB6zLToS8vZSmS5DEHyzzxKrJH4gMBjN7N6Y7Ywq9Cn+OnwZi+FZ0XtmnpDut7eqpnRaNBVBMBCYNfB7XRJen64aWxo3fu+1nJl5XhqIlZaRVjtzAPSkno1oWCsA6fDI7IxJSNsw9mVPxONOW98dQAM9hfid4th1jRYHQHxIxZpoX1LmV78/o6+TOPkjcwtGIYYfuM+LbHQLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57PLWSpudxHF2rkh/8dLnU6NGoPex/ACVkAQOMuRWY4=;
 b=fIpN6qgPM0+b1Nb+xdZSV0Fuh2iyai+GDj38+azCQQ66ovC5QvQn1FNSmqOR84bj1TNCTwRipbLnkkcOA5DtFsItOw0wSr2kx8Oo09lTD+8rNtBoizUYKGJog3h9U/nd7rSQsEjpcPXaFXsfgafQ5oxatZfJFLxP2FXmt95G0jxGRM51S5EcCAfV70s6kP7lmy+DvU2R/4TS8tpOygJ66CeUYnh5TBHVeGOUf9ZJ+7OqrZWJEgHPRKSU+ZNMyVCLTkYFrR83QuNMvdbmW4PcjLEcY/So8ZmDCDGsVCzGaRey/9omxOnxWsIYZ9Ic5AKUBhHCnuQX2IvJfLFhMTB82Q==
Received: from DM6PR01CA0014.prod.exchangelabs.com (2603:10b6:5:296::19) by
 CH0PR12MB5217.namprd12.prod.outlook.com (2603:10b6:610:d0::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Sun, 12 Feb 2023 13:26:11 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::96) by DM6PR01CA0014.outlook.office365.com
 (2603:10b6:5:296::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23 via Frontend Transport; Sun, 12 Feb 2023 13:26:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:26:02 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:26:01 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:59 -0800
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
Subject: [PATCH  net-next v4 7/9] net/mlx5e: TC, store tc action cookies per attr
Date:   Sun, 12 Feb 2023 15:25:18 +0200
Message-ID: <20230212132520.12571-8-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|CH0PR12MB5217:EE_
X-MS-Office365-Filtering-Correlation-Id: a0433685-a878-4176-3c95-08db0cfcb57b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+0Sc662Co4iRYcHtT7pxy99uKFUP7ZIaf3oxltVv29WVN6d5K98sOWFqbgq1Xp20Hgg4UnLtElhc9lhw8052jfvnaORmtZuHX8gTh/20ryJ4ERfrBFIuO/ufaMZ/GK1w4rYhS0GCIwycvB9OFaA1YF8l/I6FiBaalLsII9ABCanjwF3wFKMgzxLb74+BFWONA/0JbeGB86NTeW1g1twQ7a6hkesDvg9YWVzcqzYDSQMAr3JZxzJPAj6TTKnNUrtafeKDKpJIvdtCEm/tadvaNsT/Lm03b4khfe4PaX302p1p7ri20eaJDqVMu0CyApTYkk+k00dp90xW2x5Mur/guGFs+iUx6mG5u/EI6hzaW8HB1RZD+tBynmXTmbO75vLyfq2Dov8x16P1QS8Nv3WjEOQV8HHA0Qeu5WfYYG3CuhC8WSAeGhn4zxtlXUb/CtWOdzkVDfk0wTHY4NufOo0UYO0a71BYYEZVCqxGs+Fy6AsjcuUuie2gCK/UxduO7NEbVq5XzOW9U8mI7cxVTU693HnTHpI4J5NBzyytiY9+bGuqOcYLe22WRWYxwnLZMy1V7ZRh3cMK/Mzxxhh71Or9fzeyPn+u4o5sw4SeMsGlO0ueeKe7M0eJcpzRc6bAqTWdAT/HFkA/YRj9cQy6rfF4V8OU5jV+2z6jMdvLTwrpU+2Ir3HGaWOd/UzczmH8KlKT49u9AnYcA/BToLGGVI/XA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(5660300002)(41300700001)(8936002)(426003)(47076005)(7636003)(36860700001)(82740400003)(82310400005)(86362001)(36756003)(40480700001)(356005)(40460700003)(2906002)(316002)(54906003)(1076003)(26005)(186003)(4326008)(6916009)(107886003)(6666004)(336012)(478600001)(2616005)(8676002)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:26:11.7539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0433685-a878-4176-3c95-08db0cfcb57b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5217
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Change log:
    V1 -> V2:
    - Reduce tc_act_cookies_count size from int to u16
    - Rearange mlx5_flow_attr attributes for better cache alignment
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a3b46feeff8a..08123fb207ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3786,6 +3786,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
 	attr2->counter = NULL;
+	attr->tc_act_cookies_count = 0;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
@@ -4149,6 +4150,8 @@ struct mlx5_flow_attr *
 			goto out_free;
 
 		parse_state->actions |= attr->action;
+		if (!tc_act->stats_action)
+			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
 
 		/* Split attr for multi table act if not the last act. */
 		if (jump_state.jump_target ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ce516dc7f3fd..75b34e632916 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -69,6 +69,7 @@ struct mlx5_nic_flow_attr {
 
 struct mlx5_flow_attr {
 	u32 action;
+	unsigned long tc_act_cookies[TCA_ACT_MAX_PRIO];
 	struct mlx5_fc *counter;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
@@ -79,6 +80,7 @@ struct mlx5_flow_attr {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	u32 chain;
 	u16 prio;
+	u16 tc_act_cookies_count;
 	u32 dest_chain;
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_table *dest_ft;
-- 
1.8.3.1

