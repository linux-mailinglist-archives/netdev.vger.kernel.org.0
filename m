Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80A3EED47
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbhHQNXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:23:49 -0400
Received: from mail-bn8nam08on2072.outbound.protection.outlook.com ([40.107.100.72]:28772
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239844AbhHQNXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:23:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNMFgOfYW3E80VcOUS3/Pea44r1IY+xGtRWibmDh+9vh2F64r5kO98mNjeDhmYaRuRsHvY3Eu6lXkvsivXwv1fiYmeD0dAa59uk91L71g6U4uJkyNTbw9NUr7gDti8keec+E9brSEL8jT4HfItnlwd8mc3Qn7dRJxIzaLp8ses260GlKYt3p7ZGrEpmyU0MsqzDgxigUyyPa9Ti7fvg0TzPaWtU/SLXW3YvaJ2niMTYGaH0+GOka9ulodNXqN/oNupZBizwFTicuVL1spRMr1hlAfELl9JJ/koWLgyRBipFg+uP9SKgdC3XEjGkraHMMz6mxfVqMszJrP6o49OHOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52oneabHlPm6S92t8xhNuz27khF1eVFLyU9tmmwFjXE=;
 b=K+hSJ36bQPvlfdameLLcR+G3v7FrIJLGlo8Rz5AdaWNv4rEXuVQA+f9ej8jFNefm269L1wFKrwa80fhJB/NxoB7FoH4RPT46c5tfoDvvWYmq0wGCBowzGXGyAgYS1yO5EL2fFr1tuVe2gZUbREPiwDIx5I0Q0CupDslpDeQBHefmqASqQ16avq+mo+ioHUDXEnXMc2QUDPvDb5F4MPLWWB/buGiqcIGF9mCfQ8v664yio7vzt9DzJbPIpwj9vzLs5tEKjdZN1PswXO0mLtvwyt029gi0khkOpkhHiro9TkJXOAVy+fMFMJvOiCpr8rHNxr1fEbwuqGcBvtWnEAy2eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52oneabHlPm6S92t8xhNuz27khF1eVFLyU9tmmwFjXE=;
 b=NoKFB5lETdNAJHHyeY0GzD90u6Pdc6mGX09vqerH/MXHTiqm/qb3JXBv8I6tRgg+oOJs5/ZQL9w6sRuFzWPo9A5DxDryennQkHnDyBqnnItFLc2oT2/AXL66sit1p4ncZxaZf/R1eeInJyNKdNt0NYaLiQDcdNORALXO19O02cpnUNGXib+KKyrG7Z5Xyi9KI6RFEjf2Siv4fUP3hB8SpzcWs0L60YIG24VBoTT1+7n+TswRiRBqzp1fLlwrPY1JkLhm+RsDTYuQYiF0SAYGm/tEvbQ4ouagUo21CjivHtWVuTli5MlsyTiKIZGOjFMk9yU+ZM13tKjbanyCBTrpKQ==
Received: from DM5PR2201CA0009.namprd22.prod.outlook.com (2603:10b6:4:14::19)
 by DM6PR12MB3753.namprd12.prod.outlook.com (2603:10b6:5:1c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Tue, 17 Aug
 2021 13:23:07 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::45) by DM5PR2201CA0009.outlook.office365.com
 (2603:10b6:4:14::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend
 Transport; Tue, 17 Aug 2021 13:23:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 13:23:06 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 13:23:06 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Aug 2021 13:23:04 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <elic@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/2] net/core: Remove unused field from struct flow_indr_dev
Date:   Tue, 17 Aug 2021 16:22:16 +0300
Message-ID: <20210817132217.100710-2-elic@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817132217.100710-1-elic@nvidia.com>
References: <20210817132217.100710-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 365c7287-d594-4445-a482-08d961822692
X-MS-TrafficTypeDiagnostic: DM6PR12MB3753:
X-Microsoft-Antispam-PRVS: <DM6PR12MB37539237A9C47965C86BCA5DABFE9@DM6PR12MB3753.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bu/mrhhGf/eOvieyLDSy1pimBXdbqgcjB1f64Lo+qZAxAdvCmrN+uhUWImJCHliQk0FvQV78ZWTTLgPvz0gU4izp5ky7uvzOuNTKGVD94QPnFqw0ylRrtIoGGzzJXblNKqbBGZidO2QiwnO78vx+vwWQwqA5UQlGq19vXR70tELAg2ufaDJYQbus+JDu3qIwf/lT4qHPE9meYcJk5BOqmBy5LIoHxcDXfEuSa59T5avX5bC2+pZhjBbE06H9AXtVpUfeu4zpwzk8XTQRhZTe9lYkbLRiBZxxm8gqsmi1zuC1sLgsY2HQOH49NAtS9a0LNeYRxSk2nV+v8iNgINWQlzJESOgXSk4PkcxHZyoXhc6FlR6SN+WfyH1KQ9rgW3n2MJ+02+GTnMSfw4gn/gJpYABJWeg/eWs6XDql2yOC+Zu1nW9cJ16shhC/c7a8DyUQ7rybhYNZ5UkLA5nr6A5OUW9lf+T0Rix09z842gCuGuzEgyjbwMgOnIYMYeTS9vmrkDZXzpCZNi3j4RtbQ3uC+yJS7+VSm/LA6EC9Vj9zN4cZumB00Y2h23uuUPjYlRBCegs0rOPwAjVZk3kWsmDJMCih1oqFjVIsnQCfpc5yK6gQBrLQaFeo0rB8l6YpOw2x2vlN+Tiq0yo7/zoboNmiJ8/KGCAVzbblfZXL80KYCJvNRSuaBw6ecOp4bWcAK0BQcAOZ2Expn8XUyJH2vZl5WA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(36840700001)(46966006)(1076003)(107886003)(82740400003)(26005)(36756003)(186003)(36860700001)(86362001)(316002)(8936002)(8676002)(478600001)(2616005)(70586007)(54906003)(47076005)(5660300002)(83380400001)(7696005)(4744005)(2906002)(6666004)(356005)(70206006)(336012)(426003)(110136005)(82310400003)(4326008)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 13:23:06.9263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 365c7287-d594-4445-a482-08d961822692
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rcu field is not used. Remove it.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 net/core/flow_offload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..1da83997e86a 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -327,7 +327,6 @@ struct flow_indr_dev {
 	flow_indr_block_bind_cb_t	*cb;
 	void				*cb_priv;
 	refcount_t			refcnt;
-	struct rcu_head			rcu;
 };
 
 static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
-- 
2.32.0

