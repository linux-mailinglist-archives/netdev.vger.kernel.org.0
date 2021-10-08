Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F26426ABD
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbhJHM2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:33 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:27872
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241608AbhJHM2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfoSl2rTF6swrgB6YgnfUeuEF/6/1EnW7tB6Slz77vP4jrEoj7zly+njyAJF6aywbIdjIVTTT3jLq3eh3k8sXotyfKPLvN7lZpfwFRYnFQZ/HddwTjgn9HLNoQzVpRF5C2z6wM5lzmELTQit14ose5UbXpAS8bo1gZ8SJt6FZmPdTYMp5xQbpBoAG2dhyn/ZwQPwpzF1z37Qfrbgc41SGQMLDKZZK0dIv62lis07MDtW1B1oF3hz6wjBRcxQTgPldR8d4AU7JH47kkHyQDoX4U99GiGl1FnkNVvaeCMroA9vZ51FeYl19eJLbdpaRfXPRVp3XzUJW6MFJ1WVpl6vHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmJzmkKWylwu80KmSS+CbRyZubq8LY5B1209kUR/HFo=;
 b=f7U6/c8vu86mDu/xc5bKZZyn99jVmJNHc21xmgsw8hkE1ca+A4OAZB8bfY2n/cU64cZOXmWN4vU7OWCUAzDDW+21TWhM4kUsq+RGFP53f17saz+N1aqjkAwiYFXguS43u1LzmwXfRpnUSu6OgnXYJlduPuqU+LUt6qrVRUNloMK60uhVw90WAh1Mr5dopJwxGsUD/lWyWSNEMVGwpLZ7s8gpACNpWZIDdb1Vd5BvR9Y1FphzS+LvimYESAQ5axE/LKsdrErDfeog5hTS6PiMeXfVmqWoZHc8t/ReBnZK3MI0S0pxSBhTa15SLY1exkt/va1JdrVL+lB0tfbNPU2N6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmJzmkKWylwu80KmSS+CbRyZubq8LY5B1209kUR/HFo=;
 b=gmrdRi5LMWJ9W6z7wcUggdLq9FN4d90IK53+01TDwy567zez3A8jbv197s+pL06njadJ+sKJLHE5p7ay6hC1rrA/Jq+S1YEFUkTBypZfwPHsBwTYBdy1L2063U/+u4ISoYynkpUrJ9OWW2scCaoxOhDIQM0V4RdyYl0MMsNmnlRpDJ7SopXyMg8A8PVSHmugyyHStRTDT/Q1/U+39C/e9pgdfHQKI0z9xzGVhxKkROR/CBBvUMHm217lm0rCQyyXC90jPK1ZC2Awgoe2tGLb/jBygH1j7VivQlgfG/CzkByhc5UruD5UjolKMJzrFDWYA/iVvhAy6//eEu2nlQF5mg==
Received: from MWHPR1701CA0017.namprd17.prod.outlook.com
 (2603:10b6:301:14::27) by MWHPR1201MB2558.namprd12.prod.outlook.com
 (2603:10b6:300:e5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 8 Oct
 2021 12:26:19 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::78) by MWHPR1701CA0017.outlook.office365.com
 (2603:10b6:301:14::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:19 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:18 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:18 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:14 -0700
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
Subject: [PATCH rdma-next v4 06/13] RDMA/counter: Add optional counter support
Date:   Fri, 8 Oct 2021 15:24:32 +0300
Message-ID: <20211008122439.166063-7-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a94b8833-bca4-472f-0200-08d98a56d4f4
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2558:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2558D82DE80ACA0C176E85C7C7B29@MWHPR1201MB2558.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wA9ogn/dfgt2z67fLhsnIE1AHAhNAQ3bHC72OSZl1QC2/UE/vqpqLOhf26lZ+DOHS8Pc5qVIsHnNNCepX8FM3yhy7cvjbLkpbcSTdWyU9YpdbpcNriR+MaS+if2MkVr8akuDUUiFasqulZfL3Ivqpz2qkkPMns7ttWyGMNdO2EZSnlpWKS9Qbivza0Nb44k6URbkH9qAO8+8h0WATJywAeh5GjVdwSTmjOojtKAHfyIujcWEGy3iSMP6U6TgMI2sPyUTTNNyhjTOlBTh+FzmA+elfnoHccUjsQuHFxWM4N683jrXS458pB5dDfZw++OEzjHE4NhKNSF+2DgpkeK09X+rStdkmlY5iWgldYbBE6V1O37uZG/1Os41gq/xPEOtt1fIM4O4/Wvm6miriuhzXQL8JF0GYYNR4RyTNuzs5n5UUmqXQLNHc0Pl/dZcqwknjXWcntAS4uUFd8DdfEjhKV1umrhGl78EUAwa3QIqrsOljHd2YndJ7z3+ClD9fA5b+1K0Pp7EyaKr2onviEytDCcbIcVC1nevCWnoCQSgEV4DV1RRt/byqzCD0Xgy8dsfJZP7IzJ5f3zN4/5ubJiOf3BgOwOc4gGu3XERtJiaIN/lCuOlkdIiko6VW4PYzDa+sI8eW5PaV+xk9oWlFJSbZoqWVlEj8zPKw2crDEHvlXa+7kPyJVKYOKSUFN0xjQuMfDybt0sIwPICgB9Pwk6Qew==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(82310400003)(7696005)(86362001)(5660300002)(36860700001)(70586007)(70206006)(8676002)(4326008)(36906005)(316002)(1076003)(83380400001)(7416002)(7636003)(6636002)(2616005)(110136005)(54906003)(47076005)(36756003)(508600001)(186003)(2906002)(8936002)(356005)(107886003)(426003)(336012)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:19.3234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a94b8833-bca4-472f-0200-08d98a56d4f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2558
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

An optional counter is a vendor-specific counter that may be dynamically
enabled/disabled.
This enhancement allows us to expose counters which are for example
mutual exclusive and cannot be enabled at the same time, counters that
might degrades performance, optional debug counters, etc.

Optional counters are marked with IB_STAT_FLAG_OPTIONAL flag. They are
not exported in sysfs, and must be at the end of all stats, otherwise
the attr->show() in sysfs would get wrong indexes for hwcounters that
are behind optional counters.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/counters.c | 32 ++++++++++++++++++++++++++
 drivers/infiniband/core/device.c   |  1 +
 drivers/infiniband/core/sysfs.c    | 36 +++++++++++++++++++++---------
 include/rdma/ib_verbs.h            | 13 +++++++++++
 include/rdma/rdma_counter.h        |  2 ++
 5 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 331cd29f0d61..af59486fe418 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -106,6 +106,38 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
 	return ret;
 }
 
+int rdma_counter_modify(struct ib_device *dev, u32 port,
+			unsigned int index, bool enable)
+{
+	struct rdma_hw_stats *stats;
+	int ret = 0;
+
+	if (!dev->ops.modify_hw_stat)
+		return -EOPNOTSUPP;
+
+	stats = ib_get_hw_stats_port(dev, port);
+	if (!stats || index >= stats->num_counters ||
+	    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL))
+		return -EINVAL;
+
+	mutex_lock(&stats->lock);
+
+	if (enable != test_bit(index, stats->is_disabled))
+		goto out;
+
+	ret = dev->ops.modify_hw_stat(dev, port, index, enable);
+	if (ret)
+		goto out;
+
+	if (enable)
+		clear_bit(index, stats->is_disabled);
+	else
+		set_bit(index, stats->is_disabled);
+out:
+	mutex_unlock(&stats->lock);
+	return ret;
+}
+
 static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 					   struct ib_qp *qp,
 					   enum rdma_nl_counter_mode mode)
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f4814bb7f082..22a4adda7981 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2676,6 +2676,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, modify_cq);
 	SET_DEVICE_OP(dev_ops, modify_device);
 	SET_DEVICE_OP(dev_ops, modify_flow_action_esp);
+	SET_DEVICE_OP(dev_ops, modify_hw_stat);
 	SET_DEVICE_OP(dev_ops, modify_port);
 	SET_DEVICE_OP(dev_ops, modify_qp);
 	SET_DEVICE_OP(dev_ops, modify_srq);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 8d831d4fd2ad..1bf3aea4b71e 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -934,7 +934,8 @@ int ib_setup_device_attrs(struct ib_device *ibdev)
 {
 	struct hw_stats_device_attribute *attr;
 	struct hw_stats_device_data *data;
-	int i, ret;
+	bool opstat_skipped = false;
+	int i, ret, pos = 0;
 
 	data = alloc_hw_stats_device(ibdev);
 	if (IS_ERR(data)) {
@@ -955,16 +956,23 @@ int ib_setup_device_attrs(struct ib_device *ibdev)
 	data->stats->timestamp = jiffies;
 
 	for (i = 0; i < data->stats->num_counters; i++) {
-		attr = &data->attrs[i];
+		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL) {
+			opstat_skipped = true;
+			continue;
+		}
+
+		WARN_ON(opstat_skipped);
+		attr = &data->attrs[pos];
 		sysfs_attr_init(&attr->attr.attr);
 		attr->attr.attr.name = data->stats->descs[i].name;
 		attr->attr.attr.mode = 0444;
 		attr->attr.show = hw_stat_device_show;
 		attr->show = show_hw_stats;
-		data->group.attrs[i] = &attr->attr.attr;
+		data->group.attrs[pos] = &attr->attr.attr;
+		pos++;
 	}
 
-	attr = &data->attrs[i];
+	attr = &data->attrs[pos];
 	sysfs_attr_init(&attr->attr.attr);
 	attr->attr.attr.name = "lifespan";
 	attr->attr.attr.mode = 0644;
@@ -972,7 +980,7 @@ int ib_setup_device_attrs(struct ib_device *ibdev)
 	attr->show = show_stats_lifespan;
 	attr->attr.store = hw_stat_device_store;
 	attr->store = set_stats_lifespan;
-	data->group.attrs[i] = &attr->attr.attr;
+	data->group.attrs[pos] = &attr->attr.attr;
 	for (i = 0; i != ARRAY_SIZE(ibdev->groups); i++)
 		if (!ibdev->groups[i]) {
 			ibdev->groups[i] = &data->group;
@@ -1027,7 +1035,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 {
 	struct hw_stats_port_attribute *attr;
 	struct hw_stats_port_data *data;
-	int i, ret;
+	bool opstat_skipped = false;
+	int i, ret, pos = 0;
 
 	data = alloc_hw_stats_port(port, group);
 	if (IS_ERR(data))
@@ -1045,16 +1054,23 @@ static int setup_hw_port_stats(struct ib_port *port,
 	data->stats->timestamp = jiffies;
 
 	for (i = 0; i < data->stats->num_counters; i++) {
-		attr = &data->attrs[i];
+		if (data->stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL) {
+			opstat_skipped = true;
+			continue;
+		}
+
+		WARN_ON(opstat_skipped);
+		attr = &data->attrs[pos];
 		sysfs_attr_init(&attr->attr.attr);
 		attr->attr.attr.name = data->stats->descs[i].name;
 		attr->attr.attr.mode = 0444;
 		attr->attr.show = hw_stat_port_show;
 		attr->show = show_hw_stats;
-		group->attrs[i] = &attr->attr.attr;
+		group->attrs[pos] = &attr->attr.attr;
+		pos++;
 	}
 
-	attr = &data->attrs[i];
+	attr = &data->attrs[pos];
 	sysfs_attr_init(&attr->attr.attr);
 	attr->attr.attr.name = "lifespan";
 	attr->attr.attr.mode = 0644;
@@ -1062,7 +1078,7 @@ static int setup_hw_port_stats(struct ib_port *port,
 	attr->show = show_stats_lifespan;
 	attr->attr.store = hw_stat_port_store;
 	attr->store = set_stats_lifespan;
-	group->attrs[i] = &attr->attr.attr;
+	group->attrs[pos] = &attr->attr.attr;
 
 	port->hw_stats_data = data;
 	return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ae467365706b..2207f60b002f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -545,12 +545,18 @@ enum ib_port_speed {
 	IB_SPEED_NDR	= 128,
 };
 
+enum ib_stat_flag {
+	IB_STAT_FLAG_OPTIONAL = 1 << 0,
+};
+
 /**
  * struct rdma_stat_desc
  * @name - The name of the counter
+ * @flags - Flags of the counter; For example, IB_STAT_FLAG_OPTIONAL
  */
 struct rdma_stat_desc {
 	const char *name;
+	unsigned int flags;
 };
 
 /**
@@ -2562,6 +2568,13 @@ struct ib_device_ops {
 	int (*get_hw_stats)(struct ib_device *device,
 			    struct rdma_hw_stats *stats, u32 port, int index);
 
+	/**
+	 * modify_hw_stat - Modify the counter configuration
+	 * @enable: true/false when enable/disable a counter
+	 * Return codes - 0 on success or error code otherwise.
+	 */
+	int (*modify_hw_stat)(struct ib_device *device, u32 port,
+			      unsigned int counter_index, bool enable);
 	/**
 	 * Allows rdma drivers to add their own restrack attributes.
 	 */
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 0295b22cd1cd..45d5481a7846 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -63,4 +63,6 @@ int rdma_counter_get_mode(struct ib_device *dev, u32 port,
 			  enum rdma_nl_counter_mode *mode,
 			  enum rdma_nl_counter_mask *mask);
 
+int rdma_counter_modify(struct ib_device *dev, u32 port,
+			unsigned int index, bool enable);
 #endif /* _RDMA_COUNTER_H_ */
-- 
2.26.2

