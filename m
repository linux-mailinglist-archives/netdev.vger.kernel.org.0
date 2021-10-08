Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F71426AB8
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241442AbhJHM21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:27 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:13537
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241534AbhJHM2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7dpu2iQlsoETyHOm5IvpvEirsGKzsMPDQOyjcozEkL8YvwPMDFsVdugvmGnp5mn834l6M1/IMy2MS/JrAfFLBokeMwxFKOy7lO1yeoTij+BCkmcO4XvTO6Lt/Jp/4/2xS6mHXNCRQ34XOHN8ovao8fCrphkHMFRqyNWhSzN9mq9q0KW+Xeo61gz3gZddqtstPsjeAlAj1K8gJaKSjBr+pEJJlfIiKyVNuWQ6ohUFG1IL+DoNGpfACZEp9F+T412K7wLEeqZePzW63RCtA3nZI/0/NXbZu340I8WxtKdOrQBAThAmrAeLbGw0+bPwDMZw9ybR/L+nYobvBgQ9uvDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BghE2GqHU7Hb7GZa4ODZP82j76YI+rGy+6vXlPLUJjc=;
 b=lzzX7+8GbUT9/fpc53NbZArgOzgEFKgG4uEmdqVvCTBB8IcpOCrssvIN+OVIU14OUcJLgGCtrjne61nUBBBs8JZqpwG9G9Zuz6tYekNxIWFOswZrU6NNudUqzuIydpIIILYJZNAiHIPU+OAAQyl8ZM2NlI4mw8RXOAFT7qARnb+uA4fTp9I5S6m4j7iNGjTSFC0zcIZUrgIaDvn9jbZrsz3ogfoF8umRjqg8SKkk6ya9Zfzo2YXN0aUJV1ExYS0F5XN3cAACebzLz78JvNiLwzUPIwPXQhrq90xp8oRIwnGi6KreH3OIbrQ3MVg+PKPoR8Tyrq0HCE4IrA876KgLBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BghE2GqHU7Hb7GZa4ODZP82j76YI+rGy+6vXlPLUJjc=;
 b=kRXZBprzHbTrlpaZ2TJjSxQLVexDwDcM2cq8mVIoErQKkXKlAUthWfKSH/NlzRWPFTo6d+KeHOk4Bn0iFvcYff4undUDXxYG12miXzx0tM0WXGx6lMUVgcZRITc3rJ0QwHbU3xgYdbnyQs5xyZa6LbdwEVgfeKqSBsl0rhJ0nRuI/Lutv0VGd29dWrDBdwV/NF7dL07AtKqNo9LDR1xwHw7ebqLHO89W/v9jwlwja9ef9YcaT60AxFGVwtdqPzSbIXOdqKdsOqyBod9Li40HIcruu1nMDHYJmEzRmgiKNX7GSz+7rUfadsMhH73deWBrsdp3DTWNR2Scg+7I1cG11w==
Received: from BN9PR03CA0801.namprd03.prod.outlook.com (2603:10b6:408:13f::26)
 by MN2PR12MB4344.namprd12.prod.outlook.com (2603:10b6:208:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 12:26:11 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::b2) by BN9PR03CA0801.outlook.office365.com
 (2603:10b6:408:13f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:10 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:09 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:04 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>,
        "Mark Zhang" <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 04/13] RDMA/core: Add a helper API rdma_free_hw_stats_struct
Date:   Fri, 8 Oct 2021 15:24:30 +0300
Message-ID: <20211008122439.166063-5-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba26bd6b-01ad-4080-556e-08d98a56cfc6
X-MS-TrafficTypeDiagnostic: MN2PR12MB4344:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4344C8E4E087A0B2508B6BEDC7B29@MN2PR12MB4344.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dx4rhDu2WzF705NGhP2eis0IDlfiLEAL8EpfWYfCKmVhrtau9ZL5dSh2v9RSvQJdz2lBMO6bpMY7zOZuwK5XhcnQ90vSP/7l3LKzjCFLzSUPur/j2zNIpEJN0ngyl/YMfqrZ4bc9zJbmKSpmQwD0mvTI9mXFyRTzacbfmarD1XcdOqQyH8xus62ZEGPI0/hH9Ap+8DA7baNxdk7fJ+tKQGzBGCwf70ANZ1/mBYJvoT8CUSIGgRUYBX8LMnZfkWWLY019umhxeKoMm6uIjcm0mokYQU4WE88tok+Q9n3vWWMj0AV84LJJzR4pSMoRzETVXtchthkfnDLzGUXC1BfYj+P2z17kdhZVo+aX5JVCZlv7Js7d2A9aWqtg3SnHTuZZ0RJYqGf3MrqssHwVF0wgeuDv9nMe7CZ6G2E1KrXBaiIO2xWDMp890Ve7RsWT9CghQ2/0zqfptBjqeTl8Sl7aq5pIikzNeQ5mHPj9euKpjH4FEQeczLbczHI/LdsB2VrBo+HUbnMcigxCcBTxyTEngJ9h9DSwUowCPwe7HP5UQY193M9P+gWGS6qGuuxS2Z1JP4Y0rBhlr9Hc53DLCP6OjG+r4MVQaRyrWIYnaxAHFZTVrErLl24G/svHQjtoJxO3GHXC/1YRJ1JFX7M5Cbb8mZccjK8C5y/uaAX5p05/gwzuqzK/DGwA3uj56xxnqIIjX9Vij81Pt0z34xyGwZnILw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(107886003)(82310400003)(8936002)(316002)(54906003)(110136005)(36860700001)(70206006)(6666004)(36756003)(26005)(1076003)(8676002)(186003)(5660300002)(2616005)(426003)(336012)(70586007)(47076005)(508600001)(7416002)(356005)(7636003)(7696005)(2906002)(4326008)(6636002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:10.5039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba26bd6b-01ad-4080-556e-08d98a56cfc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new API rdma_free_hw_stats_struct to pair with
rdma_alloc_hw_stats_struct (which is also de-inlined).

This will be useful when there are more alloc/free works
in following patches.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/counters.c |  8 +++----
 drivers/infiniband/core/sysfs.c    |  8 +++----
 drivers/infiniband/core/verbs.c    | 35 ++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h            | 27 ++++-------------------
 4 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index df9e6c5e4ddf..331cd29f0d61 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -165,7 +165,7 @@ static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 	return counter;
 
 err_mode:
-	kfree(counter->stats);
+	rdma_free_hw_stats_struct(counter->stats);
 err_stats:
 	rdma_restrack_put(&counter->res);
 	kfree(counter);
@@ -186,7 +186,7 @@ static void rdma_counter_free(struct rdma_counter *counter)
 	mutex_unlock(&port_counter->lock);
 
 	rdma_restrack_del(&counter->res);
-	kfree(counter->stats);
+	rdma_free_hw_stats_struct(counter->stats);
 	kfree(counter);
 }
 
@@ -618,7 +618,7 @@ void rdma_counter_init(struct ib_device *dev)
 fail:
 	for (i = port; i >= rdma_start_port(dev); i--) {
 		port_counter = &dev->port_data[port].port_counter;
-		kfree(port_counter->hstats);
+		rdma_free_hw_stats_struct(port_counter->hstats);
 		port_counter->hstats = NULL;
 		mutex_destroy(&port_counter->lock);
 	}
@@ -631,7 +631,7 @@ void rdma_counter_release(struct ib_device *dev)
 
 	rdma_for_each_port(dev, port) {
 		port_counter = &dev->port_data[port].port_counter;
-		kfree(port_counter->hstats);
+		rdma_free_hw_stats_struct(port_counter->hstats);
 		mutex_destroy(&port_counter->lock);
 	}
 }
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c3663cfdcd52..8d831d4fd2ad 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -755,7 +755,7 @@ static void ib_port_release(struct kobject *kobj)
 	for (i = 0; i != ARRAY_SIZE(port->groups); i++)
 		kfree(port->groups[i].attrs);
 	if (port->hw_stats_data)
-		kfree(port->hw_stats_data->stats);
+		rdma_free_hw_stats_struct(port->hw_stats_data->stats);
 	kfree(port->hw_stats_data);
 	kfree(port);
 }
@@ -919,14 +919,14 @@ alloc_hw_stats_device(struct ib_device *ibdev)
 err_free_data:
 	kfree(data);
 err_free_stats:
-	kfree(stats);
+	rdma_free_hw_stats_struct(stats);
 	return ERR_PTR(-ENOMEM);
 }
 
 void ib_device_release_hw_stats(struct hw_stats_device_data *data)
 {
 	kfree(data->group.attrs);
-	kfree(data->stats);
+	rdma_free_hw_stats_struct(data->stats);
 	kfree(data);
 }
 
@@ -1018,7 +1018,7 @@ alloc_hw_stats_port(struct ib_port *port, struct attribute_group *group)
 err_free_data:
 	kfree(data);
 err_free_stats:
-	kfree(stats);
+	rdma_free_hw_stats_struct(stats);
 	return ERR_PTR(-ENOMEM);
 }
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 89a2b21976d6..8e72290d6b38 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2976,3 +2976,38 @@ bool __rdma_block_iter_next(struct ib_block_iter *biter)
 	return true;
 }
 EXPORT_SYMBOL(__rdma_block_iter_next);
+
+/**
+ * rdma_alloc_hw_stats_struct - Helper function to allocate dynamic struct
+ *   for the drivers.
+ * @descs: array of static descriptors
+ * @num_counters: number of elements in array
+ * @lifespan: milliseconds between updates
+ */
+struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
+	const struct rdma_stat_desc *descs, int num_counters,
+	unsigned long lifespan)
+{
+	struct rdma_hw_stats *stats;
+
+	stats = kzalloc(struct_size(stats, value, num_counters), GFP_KERNEL);
+	if (!stats)
+		return NULL;
+
+	stats->descs = descs;
+	stats->num_counters = num_counters;
+	stats->lifespan = msecs_to_jiffies(lifespan);
+
+	return stats;
+}
+EXPORT_SYMBOL(rdma_alloc_hw_stats_struct);
+
+/**
+ * rdma_free_hw_stats_struct - Helper function to release rdma_hw_stats
+ * @stats: statistics to release
+ */
+void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats)
+{
+	kfree(stats);
+}
+EXPORT_SYMBOL(rdma_free_hw_stats_struct);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index aa1e1029b736..938c0c0a1c19 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -582,31 +582,12 @@ struct rdma_hw_stats {
 };
 
 #define RDMA_HW_STATS_DEFAULT_LIFESPAN 10
-/**
- * rdma_alloc_hw_stats_struct - Helper function to allocate dynamic struct
- *   for drivers.
- * @descs - Array of static descriptors
- * @num_counters - How many elements in array
- * @lifespan - How many milliseconds between updates
- */
-static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
-		const struct rdma_stat_desc *descs, int num_counters,
-		unsigned long lifespan)
-{
-	struct rdma_hw_stats *stats;
 
-	stats = kzalloc(sizeof(*stats) + num_counters * sizeof(u64),
-			GFP_KERNEL);
-	if (!stats)
-		return NULL;
-
-	stats->descs = descs;
-	stats->num_counters = num_counters;
-	stats->lifespan = msecs_to_jiffies(lifespan);
-
-	return stats;
-}
+struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
+	const struct rdma_stat_desc *descs, int num_counters,
+	unsigned long lifespan);
 
+void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 
 /* Define bits for the various functionality this port needs to be supported by
  * the core.
-- 
2.26.2

