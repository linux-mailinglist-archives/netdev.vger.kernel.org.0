Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC14D3F0295
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhHRLZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:25:59 -0400
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:20096
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235406AbhHRLZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:25:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mayWqPCChXD0CktBk4ox99hXFTG6s1CPS1TOxYJUO0ZXAo98OlZKpelaq/vvTbQCyg85ennyhTD39RK2IOXrSwV3EBVpMVJqTGTRwA1uoUmhwygsu1RW1BwL9HtyNRbnd3ExAYf30X1nBq87s6SptA4Xnid1j5V2RgIEblxJPruQgIHGlM3RoH7bOCkTu0dlpV2AajWqol1W3wJf5AFhunqhU9/7kRPmDCp/fdtkBocg6iplAV69HFf60FqQgKJj5WQfocoVHa++MLPuJsgj8lhogpuaUi1c0jrHLUFhFpf4GACxpQG5yqba1fflTSO7w2G3H16tz9W5AbcqP5X69A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbaLhxF7R/hnp11P5J83ucGIsa2iMdZi23BXznErONg=;
 b=DoKmqjKoclz/nFxe7pu3wxtiTdvgCVABiROG0GlePfMjuWJEbftmG4uI1sMjOxS1UypWF51DE8uhEw9ppwMPIc3+6yRFWcRB2JFWNGOAE2ALPtYGpcTjBIAZIntUO9fb+uBUa96HOpXeX4CTfcuArbw2qvqUyIXP/yi2wYRKk8IEzSD1DUvEoSJPGIl3SksizPVuIs0wnzGxfuy4e549nHH+08JjcYeay2PneZ+O15dEQPho+oXtbc3+wOjQGocgfO/OWU1u71KkAZ2wejOjLnRyW3QGTEQ4mY1iEFLSq87kgEcl5ZK3dB2S5D2XuItUPx0Oe7g3vVzi5tFujjf3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbaLhxF7R/hnp11P5J83ucGIsa2iMdZi23BXznErONg=;
 b=c2aSDgYfAj+DQjTizTv2Ljzl+bBUSHds379KAz7aUcUupBcadLVSjEmf+UgKBlNyQwQnaUJcDNiKtbf0HlMJsiFA+H5ES38tc1JTfkHipv2yt6Qy95b7LlA9wK2EuHWx9079ZCUsjB+srUSKHycJZqJ4matEO4WF9ia4BxQ3ORQAnUfKtiaIoT98FF2+WFVbc9SxaJEbjqnkWJIOmHVgoLFHGMwb+7m+6DGdyK+2vEuZXoVZ2Xp8Eos5954eJrnFJq8xT6l2RjGEF6Kf4j4kzwvHiuVS3U7s7mE34qCZvI7qdQ4EhBQTG1vWbk7LIg5xVurlhLEHLPCSWFB+Lj2j/A==
Received: from BN9PR03CA0144.namprd03.prod.outlook.com (2603:10b6:408:fe::29)
 by BN8PR12MB3044.namprd12.prod.outlook.com (2603:10b6:408:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 11:25:21 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::6c) by BN9PR03CA0144.outlook.office365.com
 (2603:10b6:408:fe::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:25:21 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:20 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:20 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:18 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 03/10] RDMA/counters: Support to allocate per-port optional counter statistics
Date:   Wed, 18 Aug 2021 14:24:21 +0300
Message-ID: <20210818112428.209111-4-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c7b643f-927d-45ff-f07b-08d9623add82
X-MS-TrafficTypeDiagnostic: BN8PR12MB3044:
X-Microsoft-Antispam-PRVS: <BN8PR12MB304449527A0233301D251DC9C7FF9@BN8PR12MB3044.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbJngF+G8GdRLP4bcCe0k/GYH41OkHvW8Ysh57r33HEBdexAqo5OMrlZTRvpCLVwzClqEFZLqa5Mcjlaq0fy+Ld/r1T4su1l2ITx2KaBno1C1MAbNbyOZ8MKQXcI9JnxyvSkueB9G5J1lIYPMt7fmJJ3CHaDZN6Prs1yVG5zvUXmpwOJAXI8OBgpq47D52w29448uU24Zn5sUwQWIEfi8GALgSvZew7QCOrc19io0Yi4EoMLBlvgX9VO2ht6SDyedWE80bIlvOUKyLwJEKiFvTf2ce4RaxXE/o25p7FJoaMGdgIKbmAfcTVJGg81B4meAI6uLBO6NaA3oRqPBMpVn9Z3xfJfvVPuXtplfSA8mVpHQ2oVZ7t3TzQSgUVeudqHU7ckojFcsm7fCNl1WNZFBkcZIwOptjpi8GUGCB3ZnF3M31rpFnT6mS1aLhWyPZtxUhQqxXGj7HX7LhUJdpDxoC1kd0p3YxEKnU06zzmr4DX8268nvUjQBM819jSheaBe0yNduSdrGYcxSLGr9mD2ZW7LzYvml5qYka4Ip5fyPGpKkuQ21fUFTNVe6kfx3ihnLVbkg0AL5x5dHc/3ZKBySj15KU41baeaR2XvCVINjPllkJ3RS46/7jdjptSLkcC1qgUX30VyTb4lgm3CnUbJn68kEzno7GTKUvhFbcupyQCq+3cXV503L8+tV65oo73knGQa5jbSKxrVb7qKCXeRFQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(426003)(54906003)(336012)(4326008)(478600001)(36860700001)(47076005)(7696005)(107886003)(6636002)(36756003)(26005)(316002)(186003)(110136005)(2906002)(7636003)(8936002)(83380400001)(82310400003)(82740400003)(356005)(86362001)(8676002)(5660300002)(6666004)(70586007)(1076003)(70206006)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:21.2027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c7b643f-927d-45ff-f07b-08d9623add82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Add an alloc_op_port_stats() API, as well as related structures, to support
per-port op_stats allocation during counter module initialization.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/counters.c | 18 ++++++++++++++++++
 drivers/infiniband/core/device.c   |  1 +
 include/rdma/ib_verbs.h            | 24 ++++++++++++++++++++++++
 include/rdma/rdma_counter.h        |  1 +
 4 files changed, 44 insertions(+)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index df9e6c5e4ddf..b8b6db98bfdf 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -611,6 +611,15 @@ void rdma_counter_init(struct ib_device *dev)
 		port_counter->hstats = dev->ops.alloc_hw_port_stats(dev, port);
 		if (!port_counter->hstats)
 			goto fail;
+
+		if (dev->ops.alloc_op_port_stats) {
+			port_counter->opstats =
+				dev->ops.alloc_op_port_stats(dev, port);
+			if (!port_counter->opstats)
+				goto fail;
+
+			mutex_init(&port_counter->opstats->lock);
+		}
 	}
 
 	return;
@@ -618,6 +627,11 @@ void rdma_counter_init(struct ib_device *dev)
 fail:
 	for (i = port; i >= rdma_start_port(dev); i--) {
 		port_counter = &dev->port_data[port].port_counter;
+		if (port_counter && port_counter->opstats) {
+			mutex_destroy(&port_counter->opstats->lock);
+			kfree(port_counter->opstats);
+			port_counter->opstats = NULL;
+		}
 		kfree(port_counter->hstats);
 		port_counter->hstats = NULL;
 		mutex_destroy(&port_counter->lock);
@@ -631,6 +645,10 @@ void rdma_counter_release(struct ib_device *dev)
 
 	rdma_for_each_port(dev, port) {
 		port_counter = &dev->port_data[port].port_counter;
+		if (port_counter && port_counter->opstats) {
+			mutex_destroy(&port_counter->opstats->lock);
+			kfree(port_counter->opstats);
+		}
 		kfree(port_counter->hstats);
 		mutex_destroy(&port_counter->lock);
 	}
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f4814bb7f082..23e1ae50b2e4 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2597,6 +2597,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, alloc_mr);
 	SET_DEVICE_OP(dev_ops, alloc_mr_integrity);
 	SET_DEVICE_OP(dev_ops, alloc_mw);
+	SET_DEVICE_OP(dev_ops, alloc_op_port_stats);
 	SET_DEVICE_OP(dev_ops, alloc_pd);
 	SET_DEVICE_OP(dev_ops, alloc_rdma_netdev);
 	SET_DEVICE_OP(dev_ops, alloc_ucontext);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index aa7806335cba..e8763d336df1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -598,6 +598,28 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 	return stats;
 }
 
+/**
+ * struct rdma_op_counter
+ * @name - The name of the counter
+ * @value - The value of the counter
+ */
+struct rdma_op_counter {
+	const char *name;
+	u64 value;
+};
+
+/**
+ * struct rdma_op_stats
+ * @lock - Mutex to protect parallel write access to opstats of counters
+ * @num_opcounters - How many optional counters there are
+ * @opcounters - Array of optional counters that are filled in by the drivers
+ */
+struct rdma_op_stats {
+	/* Hold this mutex when accessing optional counter */
+	struct mutex lock;
+	int num_opcounters;
+	struct rdma_op_counter opcounters[];
+};
 
 /* Define bits for the various functionality this port needs to be supported by
  * the core.
@@ -2568,6 +2590,8 @@ struct ib_device_ops {
 	 */
 	int (*get_hw_stats)(struct ib_device *device,
 			    struct rdma_hw_stats *stats, u32 port, int index);
+	struct rdma_op_stats *(*alloc_op_port_stats)(struct ib_device *device,
+						     u32 port_num);
 
 	/**
 	 * Allows rdma drivers to add their own restrack attributes.
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 0295b22cd1cd..3531c5061718 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -29,6 +29,7 @@ struct rdma_port_counter {
 	struct rdma_counter_mode mode;
 	struct rdma_hw_stats *hstats;
 	unsigned int num_counters;
+	struct rdma_op_stats *opstats;
 	struct mutex lock;
 };
 
-- 
2.26.2

