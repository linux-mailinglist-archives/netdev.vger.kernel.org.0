Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19478584673
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiG1TNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbiG1TMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:12:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9256691D9;
        Thu, 28 Jul 2022 12:12:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQMx+vnzV740+n741jCMuyAmjmgNeMyYicnMG70cVu1N4dY4T1StWhGvKpCpPHsWkT1zKsZu+xqxJvGzwkt8dzdbQNqoxHi/Gr34VehoLfGA/NyXNVsCusBgKB6oyO1GYt/sFr7frb0UFqLDarKIBUEoVlcFgBW4uwegflRw9Zu0crdwaFmxEWRtvRT2VU9FdJyJY2fedwjcTniqZCP1Tu+Xdt+xwLCHfpOaqlN0SDdMUq6AATiGI8nBnlrpz5YQh9reecovSVJxPyl6UtY5mtgYgTmBqX/8aJxHG5cLb7ySkuvzgkQHleoi+Q9qR1FxDCTT3StzrkSkCy4oflKLAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cLQU7+nU5eOwT7QayClX4EbG5c4mI67Su2od66AifM=;
 b=Q/ZSItYddwfNergPPb9Jv0V3UdpD/Y7eq1HZvEzUaa+cJ6CxjhRoIQrPnW9pDV1ZxnEDlR9eYAYGLOjImqqKyN1ynaZji6INaYvMv32fZd39NmZ2DNPjP6qptZoQeSq74miyBeuxsxHIQHdpPAdAq1OoolulfhQwP6sRl03Byf8nEa72kSrnY8sxVjcVGA9CfUcvFBYWZbAp1MoUMpEj3Q8f0Beei0JLhXf7BDPaE99b3wZvYp2CC3O/IuP98hC6jBeCkAEkN7jR1SRd13LnTrsXuJe/3IZPH09KfnXF/OQVP3R6FzlSBNNot6wwJIQ7ntRN/OueeaVPnCHuhlbHfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linaro.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cLQU7+nU5eOwT7QayClX4EbG5c4mI67Su2od66AifM=;
 b=fqNXsp2zLNaeyBC71MuRnxaBQnvBtKx5PCeYYKJiEkUum9/JXpekt5GeuLpwTByo0bB/IaXS5V24SwSb2mlHXNXJofWgp2QgeSAZI3zUF9nbsBq+G8/WIuEnnZMhxDMqOu5mo26CaY9pEzXLZU1BYKcERxn4Z8Yd3M32ZaP0dbK32+SjhppL15J8GVWFx3nGTzSeiYBT3vj2YcCLTIk7XAJChZQ8QlVZb+D53vYh4/+9PFCjJHASw+rSwbQkQKMW96dD+3hMDpb47vznEv4aBORbvQHOGTQIaYKqwQPAGimOw+C2OzgHl/QGAT4Fc6q6EMvXWcYogZg+TkpeO60Waw==
Received: from MW4PR04CA0188.namprd04.prod.outlook.com (2603:10b6:303:86::13)
 by BYAPR12MB2936.namprd12.prod.outlook.com (2603:10b6:a03:12f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 19:12:28 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::a1) by MW4PR04CA0188.outlook.office365.com
 (2603:10b6:303:86::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Thu, 28 Jul 2022 19:12:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 19:12:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 19:12:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 12:12:26 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Thu, 28 Jul
 2022 12:12:22 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-kernel@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Christian Benvenuti <benve@cisco.com>,
        "Govindarajulu Varadarajan" <_govind@gmx.com>
Subject: [PATCH net-next V4 3/3] enic: Use NUMA distances logic when setting affinity hints
Date:   Thu, 28 Jul 2022 22:12:03 +0300
Message-ID: <20220728191203.4055-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220728191203.4055-1-tariqt@nvidia.com>
References: <20220728191203.4055-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02a8e346-f723-4146-b995-08da70cd1cac
X-MS-TrafficTypeDiagnostic: BYAPR12MB2936:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mpCrbIfFHpXW1Qu/BDNW1/pHQV5xeJy/5uJFbDqNVNXON8FPmFIvRULxAEE+zhXt2JJPIAztXaEmY5Aixf/hO2GU3TK59bOurMBQjkgKTjlXy9Ks/yyCR9/Q+tF0b4qyqqczi4yZWFo2thhjoSe+yD17cCArbhkWL0UwfMdky2gjaKba8wobPfFERMe6UiLC7VwzopUFlPJMxbFj8WVJSjYwil5vgc0NKdiO5m/ApdJlSsGf5+zxyF9P6naU+siuqp8TjRXG7HJiPf1xjd/ydTOMoyiqWrVn8STkP3LysLKhtjIN9/FrClUsY9yrLos2BURL8ZkyjAiKwXBm4g7HZvx1zO8kxSlzFKwd50nbMeS8F5vVO8bt5zwGycgR68wnBusEmWxtNiMJcBozAJBccKWN/oaySpWOCrFP05I1dYAzo8jE1Vq8TD+g1OuNCQR+PRYHgo5CVt9VieZ0iCewn6yjC1XIUi4IEBapApWpiHO1TRv+Ksrcttc6zN2G1C9gc4IRH5J+PleuS0YIVJKjihRkUrXftW3ZGxw7DyZUOk3/FdPzhwVF8MnIjxvZLNsCuKhohA6c7WAEf1BfOh2F9VwB/AFf62ZjvglruyfGyt45L9z7rGxAPgoRGlYQOp/AZpneI8Cr1KMUVMvcGiHB8IG/0z2pMRcQLoJC54pK/d75pWGq/P7OG7rmxqHGyAmQG6QyF3x2yKC1oioZbOyvst83jds/Pw3d+t3s19+PssqD1w8Mu57w4iqyvJHm7V70qeNGCMgZAB+eOovNefisbOEaVjgrlQL8ZePNy+W8vo6OOIuhJ6G45tQgqEyJbDCFf1frGgh0gsA4XHiKPHEYW0IRKcdiRtJL+EMrW3Oxgkk=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(36840700001)(46966006)(40470700004)(478600001)(36860700001)(40460700003)(70206006)(5660300002)(54906003)(82740400003)(8676002)(8936002)(7416002)(4326008)(316002)(36756003)(186003)(110136005)(2616005)(86362001)(70586007)(426003)(82310400005)(7696005)(40480700001)(6666004)(1076003)(2906002)(356005)(41300700001)(47076005)(26005)(81166007)(83380400001)(336012)(518174003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 19:12:27.6784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a8e346-f723-4146-b995-08da70cd1cac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2936
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new CPU spread API to sort cpus preference of remote NUMA nodes
according to their distance.

Cc: Christian Benvenuti <benve@cisco.com>
Cc: Govindarajulu Varadarajan <_govind@gmx.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 372fb7b3a282..9de3c3ffa1e3 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -44,6 +44,7 @@
 #include <linux/cpu_rmap.h>
 #endif
 #include <linux/crash_dump.h>
+#include <linux/sched/topology.h>
 #include <net/busy_poll.h>
 #include <net/vxlan.h>
 
@@ -114,8 +115,14 @@ static struct enic_intr_mod_range mod_range[ENIC_MAX_LINK_SPEEDS] = {
 static void enic_init_affinity_hint(struct enic *enic)
 {
 	int numa_node = dev_to_node(&enic->pdev->dev);
+	u16 *cpus;
 	int i;
 
+	cpus = kcalloc(enic->intr_count, sizeof(*cpus), GFP_KERNEL);
+	if (!cpus)
+		return;
+
+	sched_cpus_set_spread(numa_node, cpus, enic->intr_count);
 	for (i = 0; i < enic->intr_count; i++) {
 		if (enic_is_err_intr(enic, i) || enic_is_notify_intr(enic, i) ||
 		    (cpumask_available(enic->msix[i].affinity_mask) &&
@@ -123,9 +130,10 @@ static void enic_init_affinity_hint(struct enic *enic)
 			continue;
 		if (zalloc_cpumask_var(&enic->msix[i].affinity_mask,
 				       GFP_KERNEL))
-			cpumask_set_cpu(cpumask_local_spread(i, numa_node),
+			cpumask_set_cpu(cpus[i],
 					enic->msix[i].affinity_mask);
 	}
+	kfree(cpus);
 }
 
 static void enic_free_affinity_hint(struct enic *enic)
-- 
2.21.0

