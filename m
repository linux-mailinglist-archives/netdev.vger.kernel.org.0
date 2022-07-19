Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F83357A427
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbiGSQYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiGSQX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:23:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D740550C7;
        Tue, 19 Jul 2022 09:23:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKejqM/u0A+bwAXCTqZ/k7/w3mxSHU0Jn/HbB+iswlCZJL6TE26qBUMxNOvpJEQOv6EyL2UJ0h6FZ6ocRxLtVaezg0xNKrSA0x/Nvf4k8uhvl8lAFbuGkIziNr4OmcDF+tXRGYvsVpAnuKNVM0l7Ql3kWh4NnA2hmgodB3X/APJKBn1W4J6I4D5bB3rCbbBcaLDYOuY6cRXwudxuikmWa5Si0dBHQPmTUnFrIrDqMaoU6OUcfSyBUcoAnuqSVXhqTJP8VCAaVm8w/zlopWwhpoIFb0kYRNwkCVY59zr3UQDEcmWAlJOoz1JuKh8jZNUkhGZtjursmcrWuyb8x6e5/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=896a1msK77/4vJIdyHpHWCnjcda8dseK05Hu8ZFf7+w=;
 b=WndM2qARq3UwcuIYWnrC5YxKXK9VmtVLhqXIz4DOSAozYpWfGdP8zlrqPKU/bW6bv41pjoMYgb3wXaxMkzGQU7hIoOrinlH1nEQqDyLMsLQZ+O7kpaKYr9R2+4P2hZVB9jgGmbAD29YjPa89XASeRACTPBepxYWxizWGrmaMpNDgViiyyzDTlhs0pAEUDr22MYWiTWLKBT8z1gBxzCNGZOxzF7G9z9g1Rqt4o+9e0z8bPBkOrwzq88e5NQ5ChkeADEnmvZvoxawa2/FF6tgm9mTsiDB/R0Vttt2dQer7oEAwHsZKO8hiC/SceZdQPibz5mzDEEOdtZkjqo5Puhg/Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=896a1msK77/4vJIdyHpHWCnjcda8dseK05Hu8ZFf7+w=;
 b=Rc9sMiOmfvOa3RRF0EEcANTLvrAmfeYDYc2hXMb7QkhZNJH8I5cHKeE/ammRWCjAUVBKQLZDMEzmQTeRueGx52758VEJk2dYAQuJr9qXB2Tjlbpkjol1Z6EJlqnlqtX5w9nGpax82huHZDETyfySn3ehiJ+giatYKMhMAvPIWuGYSX8NDs4BWubwpt/PolHZNDq6XFFWcf8dP3qhTS1MyCNEtgw9cRZBOmXr0tUlof7u980GrxOEVsdPsVRRNsxQVL//R6wcU1Ep7g+FNguaKw6+momnwZ8oFG3vtb32WIDgEhZmqfiQSVvXndrADRZb98e7JRgZGNsTZ65nP1A8Lw==
Received: from BN0PR04CA0116.namprd04.prod.outlook.com (2603:10b6:408:ec::31)
 by DM6PR12MB4204.namprd12.prod.outlook.com (2603:10b6:5:212::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Tue, 19 Jul
 2022 16:23:55 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::39) by BN0PR04CA0116.outlook.office365.com
 (2603:10b6:408:ec::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22 via Frontend
 Transport; Tue, 19 Jul 2022 16:23:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 16:23:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 16:23:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 09:23:53 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 09:23:50 -0700
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
Subject: [PATCH net-next V3 1/3] sched/topology: Add NUMA-based CPUs spread API
Date:   Tue, 19 Jul 2022 19:23:37 +0300
Message-ID: <20220719162339.23865-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220719162339.23865-1-tariqt@nvidia.com>
References: <20220719162339.23865-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26446a0b-e450-47f3-a964-08da69a31337
X-MS-TrafficTypeDiagnostic: DM6PR12MB4204:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zftFrKuLh5phMq/1A5vcNkFX9DnXTTvvmX2VPAPUo1M0fIxU/W1A3oAoUUDTHDNbkTPQDSuLj0kRCVfNex7GRgtDIUjXqLL4fUwQ8KvGHNxdH0wl6/9NmU53AZIM5Hgn1JpGWD9OnKfqqbCLwRRjkkGu+dXbdzYfNhQYyJzBJ3K2MYQBMzAqI+3aLhCB8QdmODrixUXhyERa5ve8dz7hn8ZEPpU5HSzkg3WvZXtKcQ9Z6sG9u1crb7+F3SGX3sKY+hbUWZlVdHJSiXbvWqiOYggfLp4Tdv4tOyBCi6ZY8JJ4WoQMFijHiBaFsHrJhjS1s8yjqjDxObJdD2FaaNjItkzVvJY+LUqlmOFyDpn60G7dv6c46o0mmrxNaxYdPodeBULRC+UEUqyJZs4P/LSDKPuKmTJ13ftnfFXyUNMO3jGMyGvv1hxCOKMuO3WA9UlLQCq7iqjR4RdPkfRrzpe/zVaqNnX2BrLNLhAqrESNwB+XH1dd9dT/9kOrXP+IIZJvsZ3s+A6A/PpmvTfx5kfBuIdqKojyUzWhZiL8NMjaqXItmiQdn7C3ZRuxx6Hq9rZvmrBbjwNxXFTZq6puC++CR1RWT567HtFMuDnl1o8xLGu849EYtQyYkQFKEvWrL+7CoOO7eW6noLKF6vQW6vvL5aYIPC1Q31KEVO1zBKtjWg15vw2kEuIpTugTrwIHsfrPOx6+mHRtB9SCYq0vXywi2a43wUCEszV1DGMCHnsk988CFrtxJzq/z/p9o5weoTdybRXX160HRCIim1uuNd9/BkhxbgDCU9sUuqYiS7M1c9pEO310cxvAvmaqu1QpHSJgh0xavySimfpU8kwxpqcvMw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(40470700004)(36840700001)(46966006)(8936002)(70206006)(8676002)(70586007)(4326008)(7696005)(81166007)(36756003)(110136005)(316002)(82740400003)(54906003)(40460700003)(356005)(83380400001)(2616005)(41300700001)(6666004)(86362001)(107886003)(1076003)(2906002)(186003)(40480700001)(478600001)(36860700001)(47076005)(426003)(336012)(5660300002)(7416002)(82310400005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 16:23:54.7628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26446a0b-e450-47f3-a964-08da69a31337
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4204
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement and expose API that sets the spread of CPUs based on distance,
given a NUMA node.  Fallback to legacy logic that uses
cpumask_local_spread.

This logic can be used by device drivers to prefer some remote cpus over
others.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/sched/topology.h |  4 +++
 kernel/sched/topology.c        | 49 ++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index 56cffe42abbc..4fa2e0c61849 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -210,6 +210,7 @@ extern void set_sched_topology(struct sched_domain_topology_level *tl);
 # define SD_INIT_NAME(type)
 #endif
 
+void sched_cpus_set_spread(int node, u16 *cpus, int ncpus);
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -231,6 +232,9 @@ static inline bool cpus_share_cache(int this_cpu, int that_cpu)
 	return true;
 }
 
+static inline void sched_cpus_set_spread(int node, u16 *cpus, int ncpus)
+{
+}
 #endif	/* !CONFIG_SMP */
 
 #if defined(CONFIG_ENERGY_MODEL) && defined(CONFIG_CPU_FREQ_GOV_SCHEDUTIL)
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 05b6c2ad90b9..157aef862c04 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2067,8 +2067,57 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 	return found;
 }
 
+static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
+{
+	cpumask_var_t cpumask;
+	int first, i;
+
+	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return false;
+
+	cpumask_copy(cpumask, cpu_online_mask);
+
+	first = cpumask_first(cpumask_of_node(node));
+
+	for (i = 0; i < ncpus; i++) {
+		int cpu;
+
+		cpu = sched_numa_find_closest(cpumask, first);
+		if (cpu >= nr_cpu_ids) {
+			free_cpumask_var(cpumask);
+			return false;
+		}
+		cpus[i] = cpu;
+		__cpumask_clear_cpu(cpu, cpumask);
+	}
+
+	free_cpumask_var(cpumask);
+	return true;
+}
+#else
+static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
+{
+	return false;
+}
 #endif /* CONFIG_NUMA */
 
+static void sched_cpus_by_local_spread(int node, u16 *cpus, int ncpus)
+{
+	int i;
+
+	for (i = 0; i < ncpus; i++)
+		cpus[i] = cpumask_local_spread(i, node);
+}
+
+void sched_cpus_set_spread(int node, u16 *cpus, int ncpus)
+{
+	bool success = sched_cpus_spread_by_distance(node, cpus, ncpus);
+
+	if (!success)
+		sched_cpus_by_local_spread(node, cpus, ncpus);
+}
+EXPORT_SYMBOL_GPL(sched_cpus_set_spread);
+
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
 	struct sched_domain_topology_level *tl;
-- 
2.21.0

