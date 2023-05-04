Return-Path: <netdev+bounces-329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4C66F71CF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C77B3280DC1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66471BE7C;
	Thu,  4 May 2023 18:17:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0454A35
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:17:21 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3657559E0
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGd68KMRov0zpCJ12zDNs2OmP/DHFEObtueIg6BYZmQc54coHeM56m2tqD/TYA6d3VB8c8A5aSycOTbhj5gxOXMnX9RR9IBZX6edx72bw6vNhzO3raP19MQpl423WCbY1pKoFfwMJI/ETv6CDWOPZIJAih5ZbM8vPcuPr2BHVk532L0QrBLwzWX1UWm5TqeMd7pVkpH/iZHXHbl8m4bzk6iMPA9pO6oWEjU5rkllRr5rbB8vikmHDu9YjDWRI1JbPAzVUnJ1ZYxG3cAR55omb5NLZUYO6egAPXsvJ2kvwRDHP+6FkV5iu98bvn7hpwPgXBTVXk7+xZ0EzjYiNiW41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fE60Qc3gijW9sAgfud7MmZv2/TkiQXiegT+ok27JV8=;
 b=ao1wKPolSJHZhp6BeOVZdHieyfDfUcv3oUuru3RTqLJVu1dR1DPr2Wo5/Qrh3RIWDNCug4EGJ2mgfbWIFBOPhMXM3v+YwWD4vDOeAU0Xr9Sp+3jHH4aIwntProCiJMXtaIuYC3XnlmITw9sp+pxfG+ORGl90mPRbRCoqJn7EIPHwLoM7DMQbXUMXXvyJFJqfqCKqIZkkVcKb9FgWnm9mD5qdvCz5rzbh3RY+deCR+Uz1hOLdb1A6/MoGn1CsScezh/J7dZ7rVZFfWA3AKGhjhhdDq8PKfIRGuAuFpvRWkbL9JWI27oIg0cwZ9TDVfI3NrAlFB0iHAuxnDY48e2BQ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fE60Qc3gijW9sAgfud7MmZv2/TkiQXiegT+ok27JV8=;
 b=l09YwDhMWfGJg69q84/P9jNy/QJTTUVwzSOWhUzW11h+2Ha5uk7yHFtvYbbUhleIp/FLp/Oe3lcB5eSy8/Jxprgx5YEBpaOZRQ3MeukUZXP99216fTgjz3wZtr//yfrZ2uXnDvW2zLdaUtPHgFbDDDy71ZHwt6Tbqd1zWnzX34clIhtWCAf5X+H64QzV09v19XcC7ReJva69Etk9Vllu+dYy5AP9am2+youT/fppzZ0ES1m0YQsdhkZ5EpAvKPQTmzxSfVXqkfGhQodFhbmhEYBNZvctDWkG6c3yGLFNoHgZAtHAbacwQNEfmjGPmLo95gk3AAqE4onchYeZVTkdxw==
Received: from MW4PR03CA0275.namprd03.prod.outlook.com (2603:10b6:303:b5::10)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 18:17:18 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::85) by MW4PR03CA0275.outlook.office365.com
 (2603:10b6:303:b5::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 18:17:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.27 via Frontend Transport; Thu, 4 May 2023 18:17:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 11:17:06 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 11:17:05 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 4 May
 2023 11:17:02 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
	<simon.horman@corigine.com>, <ivecera@redhat.com>, <pctammela@mojatatu.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 3/3] net/sched: flower: fix error handler on replace
Date: Thu, 4 May 2023 20:16:16 +0200
Message-ID: <20230504181616.2834983-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504181616.2834983-1-vladbu@nvidia.com>
References: <20230504181616.2834983-1-vladbu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT010:EE_|BL1PR12MB5362:EE_
X-MS-Office365-Filtering-Correlation-Id: 902f1366-bd51-4418-1527-08db4ccbcb87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sXm3QnD+Aqun2XYINNvn6ZwciZ2OR9yZjuk4yK0TRkZCJ2YggUtco+w5le/8cX/IjF4Wx1CQmBfVoteBVb1eMuBwIT58MV939KvODM0isR47QptFGhS1rsdB1FGm2DcBjC2KmF3A1V/TPEHsXTOOO8GnXx5zSfcsSP0zOv+4DuIQ7Z+omMuFdbMo3ygOaw9k4UJ0IJOaUeuq8nVErqfd/UrDMzB3dqf2+ru44ueQtRkHG2ofEgZM7hWAelsD8CQ22reK1S1RiMVl8xoLolkRRGlQtBVIM7LJGHQnjK+3vhOjch3WESCaRx8AniFmULXgQWOyHwuNCmxS3T8h7TYKFaVzvYTkDR3bNh9gjccPnEKrUtJGlTkRw9ivCXS+SzYvS776hnHF+w7+Dib9ar1uROK3L8tPbNqd7M0yZupCpZobsMfwp7B3ck21zVKDOLq36najQ5FJWtGzb3RDJJCeTApv5wTGCPv9XisBTlb8KrhIwSh+azfMUjzinwDdBWqt4Nnh3TX6Q4oYpC0sM6MzA0UzSEZlt9MtexSCFy38Mu8C7UkrFZ6zBJ8Tx7fIQ1HMkHvcmSILePpQbVBASBj68FSmtKt6MrtaMiUzWvozjCoXnrKybae8K34A+OeM0di4XJMORF85Xigr6kxEdRcuIiJF8fP20ZakEnQdMUfmGAH62FrFR4GvpUgQ9yvHzqrHvqu1PpmHdHQzHGRmWC5IjQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199021)(40470700004)(36840700001)(46966006)(36756003)(86362001)(54906003)(316002)(110136005)(70586007)(7696005)(70206006)(478600001)(4326008)(6666004)(41300700001)(40480700001)(82310400005)(2906002)(8676002)(8936002)(5660300002)(7416002)(2616005)(82740400003)(186003)(356005)(7636003)(83380400001)(26005)(36860700001)(1076003)(47076005)(336012)(426003)(107886003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 18:17:17.8663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 902f1366-bd51-4418-1527-08db4ccbcb87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
new filter to idr is postponed until later in code since handle is already
provided by the user. However, the error handling code in fl_change()
always assumes that the new filter had been inserted into idr. If error
handler is reached when replacing existing filter it may remove it from idr
therefore making it unreachable for delete or dump afterwards. Fix the
issue by verifying that 'fold' argument wasn't provided by caller before
calling idr_remove().

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/cls_flower.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index ac4f344c52e0..9dbc43388e57 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 errout_mask:
 	fl_mask_put(head, fnew->mask);
 errout_idr:
-	idr_remove(&head->handle_idr, fnew->handle);
+	if (!fold)
+		idr_remove(&head->handle_idr, fnew->handle);
 	__fl_put(fnew);
 errout_tb:
 	kfree(tb);
-- 
2.39.2


