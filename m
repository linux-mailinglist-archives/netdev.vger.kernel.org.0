Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9B757A42B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbiGSQYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238843AbiGSQYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:24:10 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C97550BA;
        Tue, 19 Jul 2022 09:24:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lG+saKlcgrq6fYRdmytuf8cyS++JC9g1NaBeIv7dA+LEFQAi2F3MlzJgTSlFH5jUcjCR6a34J+f0kVF8E0spM7YtSbVEyUDhg0yICy10FHamr3alztn3OwvgeaNVWLjNWqij7UzBzEunwq31DVFYN1kmQXMEunK2GLRF6hkcifeNh5ld/l0gWIGn5AorZWG8aWUUVvkq8nOEEItms6IHhhbtLR4hBM2avXFCY1Va3y4Qb5N6jeXi6YxmbS+TfXWl5fscI1ik2u5oa+H4OOW4bGsQXK3ZE0xKXNCPeAlXyNTIVTVj2xYcZK7T6eMPOab9bEe+FTf9iSbjYWOgp/a/Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cLQU7+nU5eOwT7QayClX4EbG5c4mI67Su2od66AifM=;
 b=MTJru607GO85kcxmPIL6tTLqUx1HAFLkeTCnQERwS0uSUcO5snHFcwjttbKAoukpWCa1VGAQw/StyEDcN3XBUnIn+pRJf+lp9WS+FapnR8ZxqMHzb3HeCKX/xfThck27sbg3F/L/4MxMNvpgaaj3o9Zt98dbHXhwY/Jp0fh2PbDfnD6XGkWeaE24aj3Zh0FCxbIb9d9rHENxt5UD28OVaQ3ciuiVokXRGpBVCD7K0FYczvgx8RsYKecc/y2xIaymkdKAwrl6eDDykkh68Ynjv6FmiEsv8Gn30zfQ8pXwmYMKA8mYc0/k21Q2M/escndzmquu0dbmRJk10GYa80BV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linaro.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cLQU7+nU5eOwT7QayClX4EbG5c4mI67Su2od66AifM=;
 b=NBX98jgzgdNdqHST4QHIQn4ZHjGqdNFLbHOhRtRaL1EhOGgm2uRlPamjD5kbU+92o+RKmCit7H3R2IYuuIWcJI/3/xvb8eEzQMjCpK+dMPnevXIuCD6aRbXip8SEyD9h8IZTb08O8UkQTg+k3S4k2NB4iINVZmjQxaGP15kiRq8wG+I177WnkPEnWqY0WUD5+CTdPXFFn5zb06hJz3pVgygLcbXnZBbdrv+0/YWRjF6tTNE/3FztfP4SVZgeDEz+b0otvvEyIornZy0rT5TguwbUmfGTg2snReBc67NIj0jW1sfbRhsMD/ypOPMm7gA2jRsI51CyUkx1ZRif4dMhvQ==
Received: from BN9PR03CA0977.namprd03.prod.outlook.com (2603:10b6:408:109::22)
 by DM6PR12MB4636.namprd12.prod.outlook.com (2603:10b6:5:161::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 16:24:02 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::6e) by BN9PR03CA0977.outlook.office365.com
 (2603:10b6:408:109::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Tue, 19 Jul 2022 16:24:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 16:24:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 16:24:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 09:24:01 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 09:23:57 -0700
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
Subject: [PATCH net-next V3 3/3] enic: Use NUMA distances logic when setting affinity hints
Date:   Tue, 19 Jul 2022 19:23:39 +0300
Message-ID: <20220719162339.23865-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220719162339.23865-1-tariqt@nvidia.com>
References: <20220719162339.23865-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ced6d237-9f4c-4da4-562a-08da69a317e3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4636:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IbbyILciQ1e08Q49Hvuqy23lrRTDJA8aPG/97KIkdFkywCfs5cP+24SyNl1hdAQytSKr8uoDIElxDg5uX3z0lG4g6dBrHRxYfLss5h1F1qEN/121PlNHdoOa0dEsbY8mluEoz8pkJPy2JYjlhI917UHbZl+mygcRsiincuEcSIQ7Wzd1HTwEiXef4b5W8Rnpu7fQ+qLpqXWFP/vMqvgjtSHiITQQaH8wxIcWmdIjmEwNUHT+KCjMLaiyaStJjnEyOWH9qBMfPjh/aaWLMnLm97nbUY/bHArm0N/j7AGxmoxg/1mywOxYQtArwVTK6rAl1IBvGGLihVRGQ4FIx3vOB+mYUeTvvyjbZg2NH0fzaW+PY0hHmByuEy8WYiJ2P++/yt/caDY/9HmRp6YUFDjg8MOUKuequ1/ZsazqOdE+IXnNSSxv7zunwgoeLgG3/rXs+luMF6oJy7j65tftzDMiLVtpGtEkeb1HxIc3OxT4Pe/j3IiSR66QqtmnAvOhgf+f/xInnSkZ1cmfAj6pSeH4/IbHnyzXHkAF7e6TpL57w7tfimf1TRzRc7XOvgbb0F5/tFPX92bqPezP2chU+V7RYODeVysXD0PSASflEZbA2NXHu/0iFoFUPXts3sQM51z0KwTjNvwXJt2yKlUn+7PnvyDOJMNfIbxioKFsEHeleUk9zhGr1Hm0X1npdAeCR84mMcSrfN19OLaCbxHObNvwRxNsGdTNyfAez2tu7HE4npmwUXrNQWkw4p/a+utnxGn7UtgR9I+ZRjbRzMjVwcPlxjzaG0J9P2vsPEMGVaadg6XAHoNuzcSHQTyZxZC7a/XW8pLHxkkxB6iBdS8ktlEvB1wVKe2vE9bVFCRwyzlH80=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(46966006)(36840700001)(40470700004)(54906003)(478600001)(110136005)(41300700001)(6666004)(7696005)(26005)(2906002)(40480700001)(8936002)(316002)(8676002)(82310400005)(5660300002)(2616005)(4326008)(7416002)(70586007)(83380400001)(36860700001)(356005)(36756003)(82740400003)(40460700003)(70206006)(47076005)(336012)(426003)(1076003)(81166007)(86362001)(186003)(518174003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 16:24:02.5832
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ced6d237-9f4c-4da4-562a-08da69a317e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4636
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

