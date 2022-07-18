Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A5C57829A
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiGRMnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbiGRMnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:43:40 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2079.outbound.protection.outlook.com [40.107.95.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B0925E8B;
        Mon, 18 Jul 2022 05:43:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5/8LYFhiE4VqoPGntoKQiiVi5TJpJH+1olUDcfIHd2HvokbFRcxPLEMqCoKMbDaxLEBE8bHZt1VPSvlGphiGaAXLIoUupn92tbAK067TViYj3WEEhwvHWeOaJRYE9BqQXKhVXedc72eqOLw1Gv94P0yYQs2exbUyyKJv8gn690c/jdJ7cO5cu3o5aT+MjGLWhstoyylcGKsQ/DG64iKL7npwlsAaqix+X8qd0AqV6ZR+2UTHWn3CcGrjGD95HOCvLBmntFPdvx9IGQJtMb/Nf21dG1psdEu1YNwGua0h3X7R7wXAQrUh6QsDCh8j3szqhwKdEP4L9L8sjo0v8vlsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pDxbNSMJ1JHqjFo+SYG1t/Dyoh8FZFx/pgzdCCPx58=;
 b=CbzFl6HvA2RPozQlxJahjv7pOKzwlgPu70quGKqD4GBHHrYVxLSF8FSKfeuTBvzx9NSMFWXyTnsiY0vMtgmK4268dmEUv+DHU1IXg9dN997lpKbwKAlLAZPfl66PG+STw1EjTkW5bzmvr0Twp6Oy/njLhyqEpG/U1hvr+Z6LHbr4QVA7xNKLd/XvVKrWRd+rEIH03GKJsOwKpJwZnkB0lvubx8FvHpyfIS4dV2lUJWW+xXyo7O4YKPTfRyA+/8apcw9hUeepV6mTnoSxCOUKnaH+Y2+VvcuCoUk9QIhQg5/Z3UAf5t4kbHBik6itZr6rUxAjGnqdwFAx5UQAIoPshA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pDxbNSMJ1JHqjFo+SYG1t/Dyoh8FZFx/pgzdCCPx58=;
 b=oJ/kywylFATAJlEJl2MsS5YckcgcH/yGVsecPx45Vs6H4VB7igcl9GMuz477rFBxwkft3sRmHzgmwpPW2Tb0eUzfTx1w1+f+1JFCD4CC06KvDBI6SNE4YSfUrItK/T0qlthbADiyGlq0o90k5MAceQe2xqCEpCHuWzoI+XdWc1A+lDPJ/yEU04k/vLom35XRnaRXP+HEFPer90g0q67WrBfVStNryOMUPrXZFORR9oWnPq8jI9UKg3UfCBJRAGdqhTjnE+B2kiOHhi3BAqKRi6QS3lm8q7oahxtFu0gdjsC3Ns4kyRA1BHTsxfFRe9w87G7bA0hyWICyxSQ6ag8dOw==
Received: from BN9PR03CA0944.namprd03.prod.outlook.com (2603:10b6:408:108::19)
 by BN6PR1201MB0003.namprd12.prod.outlook.com (2603:10b6:404:b2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Mon, 18 Jul
 2022 12:43:34 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::62) by BN9PR03CA0944.outlook.office365.com
 (2603:10b6:408:108::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17 via Frontend
 Transport; Mon, 18 Jul 2022 12:43:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 12:43:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 18 Jul 2022 12:43:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 18 Jul 2022 05:43:32 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Mon, 18 Jul 2022 05:43:28 -0700
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
        <linux-kernel@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 1/2] sched/topology: Expose sched_numa_find_closest
Date:   Mon, 18 Jul 2022 15:43:14 +0300
Message-ID: <20220718124315.16648-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220718124315.16648-1-tariqt@nvidia.com>
References: <20220718124315.16648-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9814c1d4-e719-415a-ae46-08da68bb20c1
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0003:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpHc42HDX6FGQfd5yWHE0IWMfJEh5PzD12WB5NcwhJCRqrokiUffM4mB1H+/NeTCG/Cy/BmZG95qhO/lnzegWgq4+lev6kpusGbkKY6scZWl11xE3XL2TlAF6ZWP49FOmwoGlngc4iMtATnoLdAei6LrJbs0qLfauj39whuX1NbWOXZHigS9qTnnweOqTPF/YX/nEawHScPHLKwCpssY3iE/wVABo8hxHvHmvlkfdreYucvY35BAb7rPvHtYUOw7jTvAbJ3dRcgOhENTbtX/ZLSP0gcWgihVHV5BY9iP/5ZBUFwUqow5T3+v2YfGKu1dj0ll2s3w0m1UWqwOU5oXL5MODl1WAe4OqY2Khsl0+VZSVi4UZgGKnc19jKoPQhtCZcMbUOFG+zcwVPaZoth78Eu6lbZnBt1qyjtPKXO0C0RhNYx6+j61zNT8Sm1gyLR2YImoj6N0T0MmN04/ksVZ6sthAHUGp7NiP77qmla1XUqaCqZEZfrjAX2G0Zc7qHnosGozqKsHoYQt0TEYCMcmm4fpxvplaVh6bf15a4KIKP9Q+HULH5qZXyHoSvStuDbpmTHPk7OfVLDvI9pghztQVuc3KQHSNoTW/aoApXISssdiN/l534n2vAR9DftQbubn74pymguU0jyoOkYZcuG9gfMPlLhzacevNMkV83AMffuFLuZ77g0XyNebwmtYO20gsUshewB726pvH3r9NA6rcT8f6QFtD5H7yQm8DE+9Q5DD1Qg//fp07FyaepK9dRsTOWacEzrO95cJ1sfbt3b52TB5SI6drbiAmZ0IBdQypoD5y6lpQXkMwxkQG/+079LyQ9QLfPSNMiBixXfN2egZrnhXONhaJkxCIMOt5KSAMoQ=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(36840700001)(40470700004)(70586007)(7416002)(4326008)(8936002)(5660300002)(70206006)(82310400005)(40460700003)(40480700001)(54906003)(8676002)(26005)(86362001)(2906002)(36860700001)(1076003)(356005)(82740400003)(83380400001)(81166007)(478600001)(47076005)(186003)(107886003)(316002)(110136005)(426003)(336012)(41300700001)(2616005)(6666004)(7696005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 12:43:34.2208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9814c1d4-e719-415a-ae46-08da68bb20c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0003
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This logic can help device drivers prefer some remote cpus
over others, according to the NUMA distance metrics.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/sched/topology.h | 2 ++
 kernel/sched/topology.c        | 1 +
 2 files changed, 3 insertions(+)

v2:
Replaced EXPORT_SYMBOL with EXPORT_SYMBOL_GPL, per Peter's comment.

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index 56cffe42abbc..d467c30bdbb9 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -61,6 +61,8 @@ static inline int cpu_numa_flags(void)
 {
 	return SD_NUMA;
 }
+
+int sched_numa_find_closest(const struct cpumask *cpus, int cpu);
 #endif
 
 extern int arch_asym_cpu_priority(int cpu);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 05b6c2ad90b9..274fb2bd3849 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2066,6 +2066,7 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 
 	return found;
 }
+EXPORT_SYMBOL_GPL(sched_numa_find_closest);
 
 #endif /* CONFIG_NUMA */
 
-- 
2.21.0

