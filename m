Return-Path: <netdev+bounces-328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B07CE6F71CE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DD70280DEC
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BE7C8C0;
	Thu,  4 May 2023 18:17:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B83C2C7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:17:15 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2064.outbound.protection.outlook.com [40.107.95.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559CF5FCC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:17:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgRafPciQ5sLm1Ev+SQyfNEeZR638IuRueqcUHFZdPKn4zlFnMDSyOu/tH76g8OYjvP1so53ur9UalNg8RAWyX1YPR8DjojeJZcXRR/qlXPKZAnR4nNQnWkbVuwSASUBpISs+6yHvt02N9MjdGEzhBWtS9V5+NPhTcgNfCbXb7IOinUnWJbKqBpE0kmAsZU/8hAM5dA6IOS+47GT1e9kQVcHXJ6hvw7o6GZRlmAG2/88n4jIeWMEV9ui8mikb4aXW6aGl3PrtzF1UHJXjhXRvRXyIpRAb5Ih5ohnBSvokiRKt9tOicEjkod+sCeDyUPVL3TBD+T2zWiuwebO4ccjGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWN6FtgRQcS9zqkvZA1ojhNVNvVuWIatOjrmrM8V8fo=;
 b=ltyykuPBrEsv1e36Qs409qiBRqn4f3gJsel1Ir2Zal+c8uuLngChojDrF/nRFkRfwfIgQwYdNt9KG8lrPcYgXt6jihAKIyoxcehtsjhyQnrUYXj9hIW9KUX/a+EV2I1++q6tFEN+9FV6zWgxqLcA/IHMkWa+9Qy9K3VzqEY0v7Lhz1es2MtjCcYiUak+WtnI+F4yn/Md2f4aLiChcnuvQn0LbIhX3+cJ4ghyy+jPKOQktOlZfyNxDaQdri8wgD52M/y8cW/gSRv2tKaXKJitDBnFeHtiTzETvEEo7rtyCtrSRIC+aQJ9rVNLdajS0dc3ldGxQvOH/apz5oVnVFTRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWN6FtgRQcS9zqkvZA1ojhNVNvVuWIatOjrmrM8V8fo=;
 b=P7cc4RIM0gbVgkehTgokM/X5xcQLrLMcZjYrjRyFotuSHGdg1XzJGZJ+vpaCD2z2xOu9sX/AVcyEsVrnQGyZK0asTVIE6elCJbFZPo0z6U2VZBeGe/P8ZT+dNJSVuv8i4X9uO/y5z7KTgAzJtTuAfrF7aOgIMDgThSHhQd+B40hrjjPk7cDcJu7kk5BrWQAGew4QYyfpZTUz65gJ7zpr7NDigiz3MDUGlnJCEvntsLw0Mev0wrdVG/E6kOO57/9NurwVciy4O7zCPxhz+fcf1/CbCI05zPVSmZ0yehIihoTpHzGDF0IJH+CkqbpkaW8IAOZoiJ1/tVOZ76LhPZOlIw==
Received: from MN2PR16CA0062.namprd16.prod.outlook.com (2603:10b6:208:234::31)
 by CH3PR12MB7665.namprd12.prod.outlook.com (2603:10b6:610:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 18:17:12 +0000
Received: from BL02EPF000145B9.namprd05.prod.outlook.com
 (2603:10b6:208:234:cafe::9e) by MN2PR16CA0062.outlook.office365.com
 (2603:10b6:208:234::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 18:17:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000145B9.mail.protection.outlook.com (10.167.241.209) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.21 via Frontend Transport; Thu, 4 May 2023 18:17:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 11:17:02 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 11:17:02 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Thu, 4 May
 2023 11:16:59 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
	<simon.horman@corigine.com>, <ivecera@redhat.com>, <pctammela@mojatatu.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 2/3] Revert "net/sched: flower: Fix wrong handle assignment during filter change"
Date: Thu, 4 May 2023 20:16:15 +0200
Message-ID: <20230504181616.2834983-3-vladbu@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000145B9:EE_|CH3PR12MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: a2673fa3-86f4-4071-da9c-08db4ccbc82c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LpUGncHABn7Q9qKAPbK+tCl1ic3vazRfqXAYknLmLYBdekmlQcPOMACHTvkny+uWVBRilDhRQHH1OuvfxJUBBeKMi+GjOPJv1mz518alYCPhxCLO2AytbcWuD9x+HcKyu3itGkvpxkTC5VGZ9cE35eHsqfyLZsk5+SXGvWLFCU91VZv18D0yGQefwUt3gLSpnxfzYOuC6GpwEbYEth5flS+VzyBErf1ZSNu1EFWXJd+UVYeX8TCat4lzPjmSIxsGSmtV1iAN8etnZDkQsaXMSrW2Cy91pi7M94N+JvBM3NerFmSImkEH8fnVw1AKYFY5n8iPuIBTWV2H3YcunoHyJ25xtS9vWj7vJD5J6aIqGissiNIbR1+6ace2he5kYYUya9wYHbY/AMxECA9sXErXEdDtIozpDwix5PzWlsQA9hCd81EULvcFfq5bczNSLhi0vPvHWhPvCN/zQN11RmFbA4iYLaW7ilgHNdbzTcy/J4C3ncAf/QuhLQYJ1yXAP2gFPobDWGxdirO9LHIlsVOJ0XegCi4ZbcX1tQWY4kRRHpET5XxtPfHo4fdVFqS/RE3a47ZfBcK+lkrN2a1Hs528dtuhNipqPZKWVvE07DK2tVKKdqRtv5sR3pb4oZ0WcyZrHYuA9wsz9DQ9j9R7L4H1sC9IWL0g4P+dhwxfR2a7F4L7Iz2TgfBaFUSqwiREk1spAJ9yYQyGv9TcaVWnxaeKZA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(40470700004)(36840700001)(46966006)(4326008)(36756003)(70586007)(426003)(336012)(83380400001)(70206006)(1076003)(26005)(186003)(110136005)(4744005)(2906002)(54906003)(40460700003)(478600001)(2616005)(356005)(7636003)(82740400003)(107886003)(8676002)(8936002)(40480700001)(6666004)(86362001)(41300700001)(82310400005)(7696005)(5660300002)(7416002)(316002)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 18:17:12.1636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2673fa3-86f4-4071-da9c-08db4ccbc82c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF000145B9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7665
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This reverts commit 32eff6bacec2cb574677c15378169a9fa30043ef.

Superseded by the following commit in this series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/cls_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 4dc3a9007f30..ac4f344c52e0 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2231,8 +2231,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 			kfree(fnew);
 			goto errout_tb;
 		}
-		fnew->handle = handle;
 	}
+	fnew->handle = handle;
 
 	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
 			       !tc_skip_hw(fnew->flags));
-- 
2.39.2


