Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAC645D11
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLGO6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLGO61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:58:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054D5286C9;
        Wed,  7 Dec 2022 06:57:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO2AFiHcp7FsPca032sRGVisIb6Dng0k6krhrNmhpncOcgQe8F4SconpcF1PnJmE+zh9GdDsuNAAJXG+Os5sZxbjLzQvJwGCa0IhK1pKzfz3I5teQH52L03q3x1Oj/lKeX6MlENpMrhHi2ol5WPFZqntv4J2ClIRCsiHvmsvnQHfR3iCpRpiQDt/RcHtYB91cJS6zUBTb0GHg63birSEeyfu0EwXpyZ7KXQL1kBec43t/6HI/4AcAh3aMwGBwIl3hYWRqG7R/tlelLVPDnXt3zLs5XDY9NCPP28FCU57t7Ekt+jgrnuRtmC8yG8c26ciMU0k+oeopearabYttOT3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBP928L7PbICB3GBzOJVIoT4VDNI03KsNRLoodNlAhg=;
 b=eMkiv/GkhvM7Xqz1ML1eUzgI0l+7NQwKODrR4OsP9ae3GsI7CBEk8JYD0JvjlWp5W2HNJ7arI5yoyv6fXfBARPGgUObAA8CWZSS4lQ9YXNcjDh+/le7nE82wHnswOCL/1sGyZt2cyyimZt9X2QEQANizT7jgEB4HoWvg7C2wGRqc8yg2EdJJ3cPSk8yQxWnACq+PhKPbqEigSdP/AVnXRBNYqNCyOaVCKdf50IS82H9Yo20fs2XwS1u/rXmfl+YwpQ6NijecyoJTxI1ikBe6Z2/GgjOEIHsZir13QHF4yiC6ktPMfdSj1ak3lz75Ego5yunntz5hzqwgCqVny+VdGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBP928L7PbICB3GBzOJVIoT4VDNI03KsNRLoodNlAhg=;
 b=3mMVMRJQ0ewbC5n23YNfKdDUHdyBoiT/RrqtIenS5qQ818EifBZbHlbiQMbUYD1NcvafflkNyAW5905mLOFTWjwCx6mAGU+FVoOH33jpsjPx/cA5jiUZ1+FmzreatDs/L3DCoyilqBhiNAcCCWWdRQvtnAXUkPes1vtyZru+ZEw=
Received: from DM6PR03CA0039.namprd03.prod.outlook.com (2603:10b6:5:100::16)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:57:29 +0000
Received: from DS1PEPF0000E652.namprd02.prod.outlook.com
 (2603:10b6:5:100:cafe::f4) by DM6PR03CA0039.outlook.office365.com
 (2603:10b6:5:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:57:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E652.mail.protection.outlook.com (10.167.18.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:57:29 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:57:27 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:57:23 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <eperezma@redhat.com>
CC:     <tanuj.kamde@amd.com>, <Koushik.Dutta@amd.com>,
        <harpreet.anand@amd.com>, Gautam Dawar <gautam.dawar@amd.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 09/11] sfc: implement iova rbtree to store dma mappings
Date:   Wed, 7 Dec 2022 20:24:25 +0530
Message-ID: <20221207145428.31544-10-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E652:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: a5b0856c-55dd-4e24-9768-08dad8635cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ipiim5mvAGn0SCUyc4iU+nRkxk1AlfI1q9zCp5zRjPvZhg/Fas43pgtEZQNWcZD1fOtLCPAl48T7vOnCAA6BVNMa3PGXsjPVI2BJo0TZXGw8NnAZGcbZQ+brHNKoqQq7GEGvtpkT9kf/Uw4N+RM5bbMsf3qEE+ihMe7eAlkdIUJ/QOiaBLNT5zLnRDwnWoPPfe9f7Hyp2eqcSfn9dfqCB3fZux89s3t8fsNk4ARZADkvA2ropBjs3z/T6uRZI/5apAd9Oj9s77d9s2YcpNcEAAoiOtwH6SWQLsrok0xDi6PPDGeSE5/VW/uXS1c16OqAmSCjgH9ArOTEnjwXv1EzRycoXm4DskCZRfRaMDbpur7fUkbvjNgWnfjct6EAroe0entYMWVDJX/nOiHqRzPfMXRsIUaOhJuX4/b2jGmySmpMF4i5ySOjYT1YHZJiSq5tLGYlQcJAwRZCG1tE1jWT72VjXuJjVPaCTEdyEF6ZolCmi6dz1aCrLlGu6uG7F4vagrHpzWkaLXWFdX71kmU5S/cjgz0stUj2HR8nmH+NYxV3xueW54YAYW5lfy//WXnYAzI2PCPV9Z14/mHYPdBEJgU7s/SKWahripmEt1FoOYSr8zLsefUpbt13MKbEJjnC3NRxxIgJxNPMjTiCkAbIHN3xrSO5ZFf729Ll2xdG5YMwS/rI2+T+y39ZUgzjh/aC5sdwjIfsJ0wl3yQJXSGa3Hj2qfA4yW5rpYx6a5cuKpGgIfmzxSUnOYwaA1CgMin9
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(36840700001)(46966006)(40470700004)(86362001)(36756003)(2616005)(70206006)(4326008)(41300700001)(2906002)(8676002)(40460700003)(7416002)(5660300002)(8936002)(30864003)(356005)(44832011)(81166007)(316002)(40480700001)(82740400003)(110136005)(83380400001)(36860700001)(54906003)(426003)(336012)(478600001)(1076003)(26005)(82310400005)(70586007)(47076005)(186003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:57:29.6756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b0856c-55dd-4e24-9768-08dad8635cda
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E652.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfc uses a MCDI DMA buffer that is allocated on the host
for communicating with the Firmware. The MCDI buffer IOVA
could overlap with the IOVA used by the guest for the
virtqueue buffers. To detect such overlap, the DMA mappings
from the guest will be stored in a IOVA rbtree and every
such mapping will be compared against the MCDI buffer IOVA
range. If an overlap is detected, the MCDI buffer will be
relocated to a different IOVA.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/Makefile         |   3 +-
 drivers/net/ethernet/sfc/ef100_iova.c     | 205 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_iova.h     |  40 +++++
 drivers/net/ethernet/sfc/ef100_nic.c      |   1 -
 drivers/net/ethernet/sfc/ef100_vdpa.c     |  38 ++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  15 ++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |   5 +
 drivers/net/ethernet/sfc/mcdi.h           |   3 +
 8 files changed, 308 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_iova.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_iova.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index a10eac91ab23..85852ff50b7c 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -11,7 +11,8 @@ sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
                            mae.o tc.o tc_bindings.o tc_counters.o
 
-sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o
+sfc-$(CONFIG_SFC_VDPA)	+= mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o \
+			   ef100_iova.o
 obj-$(CONFIG_SFC)	+= sfc.o
 
 obj-$(CONFIG_SFC_FALCON) += falcon/
diff --git a/drivers/net/ethernet/sfc/ef100_iova.c b/drivers/net/ethernet/sfc/ef100_iova.c
new file mode 100644
index 000000000000..863314c5b9b5
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_iova.c
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for Xilinx network controllers and boards
+ * Copyright(C) 2020-2022 Xilinx, Inc.
+ * Copyright(C) 2022 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "ef100_iova.h"
+
+static void update_free_list_node(struct ef100_vdpa_iova_node *target_node,
+				  struct ef100_vdpa_iova_node *next_node,
+				  struct ef100_vdpa_nic *vdpa_nic)
+{
+	unsigned long target_node_end;
+	unsigned long free_area;
+	bool in_list;
+
+	target_node_end = target_node->iova + target_node->size;
+	free_area = next_node->iova - target_node_end;
+	in_list = !(list_empty(&target_node->free_node));
+
+	if (!in_list && free_area >= MCDI_BUF_LEN) {
+		list_add(&target_node->free_node,
+			 &vdpa_nic->free_list);
+	} else if (in_list && free_area < MCDI_BUF_LEN) {
+		list_del_init(&target_node->free_node);
+	}
+}
+
+static void update_free_list(struct ef100_vdpa_iova_node *iova_node,
+			     struct ef100_vdpa_nic *vdpa_nic,
+			     bool add_node)
+{
+	struct ef100_vdpa_iova_node *prev_in = NULL;
+	struct ef100_vdpa_iova_node *next_in = NULL;
+	struct rb_node *prev_node;
+	struct rb_node *next_node;
+
+	prev_node = rb_prev(&iova_node->node);
+	next_node = rb_next(&iova_node->node);
+
+	if (prev_node)
+		prev_in = rb_entry(prev_node,
+				   struct ef100_vdpa_iova_node, node);
+	if (next_node)
+		next_in = rb_entry(next_node,
+				   struct ef100_vdpa_iova_node, node);
+
+	if (add_node) {
+		if (prev_in)
+			update_free_list_node(prev_in, iova_node, vdpa_nic);
+
+		if (next_in)
+			update_free_list_node(iova_node, next_in, vdpa_nic);
+	} else {
+		if (next_in && prev_in)
+			update_free_list_node(prev_in, next_in, vdpa_nic);
+		if (!list_empty(&iova_node->free_node))
+			list_del_init(&iova_node->free_node);
+	}
+}
+
+int efx_ef100_insert_iova_node(struct ef100_vdpa_nic *vdpa_nic,
+			       u64 iova, u64 size)
+{
+	struct ef100_vdpa_iova_node *iova_node;
+	struct ef100_vdpa_iova_node *new_node;
+	struct rb_node *parent;
+	struct rb_node **link;
+	struct rb_root *root;
+	int rc = 0;
+
+	mutex_lock(&vdpa_nic->iova_lock);
+
+	root = &vdpa_nic->iova_root;
+	link = &root->rb_node;
+	parent = *link;
+	/* Go to the bottom of the tree */
+	while (*link) {
+		parent = *link;
+		iova_node = rb_entry(parent, struct ef100_vdpa_iova_node, node);
+
+		/* handle duplicate node */
+		if (iova_node->iova == iova) {
+			rc = -EEXIST;
+			goto out_unlock;
+		}
+
+		if (iova_node->iova > iova)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+
+	new_node = kzalloc(sizeof(*new_node), GFP_KERNEL);
+	if (!new_node) {
+		rc = -ENOMEM;
+		goto out_unlock;
+	}
+
+	new_node->iova = iova;
+	new_node->size = size;
+	INIT_LIST_HEAD(&new_node->free_node);
+
+	/* Put the new node here */
+	rb_link_node(&new_node->node, parent, link);
+	rb_insert_color(&new_node->node, root);
+
+	update_free_list(new_node, vdpa_nic, true);
+
+out_unlock:
+	mutex_unlock(&vdpa_nic->iova_lock);
+	return rc;
+}
+
+static struct ef100_vdpa_iova_node*
+ef100_rbt_search_node(struct ef100_vdpa_nic *vdpa_nic,
+		      unsigned long iova)
+{
+	struct ef100_vdpa_iova_node *iova_node;
+	struct rb_node *rb_node;
+	struct rb_root *root;
+
+	root = &vdpa_nic->iova_root;
+	if (!root)
+		return NULL;
+
+	rb_node = root->rb_node;
+
+	while (rb_node) {
+		iova_node = rb_entry(rb_node, struct ef100_vdpa_iova_node,
+				     node);
+		if (iova_node->iova > iova)
+			rb_node = rb_node->rb_left;
+		else if (iova_node->iova < iova)
+			rb_node = rb_node->rb_right;
+		else
+			return iova_node;
+	}
+
+	return NULL;
+}
+
+void efx_ef100_remove_iova_node(struct ef100_vdpa_nic *vdpa_nic,
+				unsigned long iova)
+{
+	struct ef100_vdpa_iova_node *iova_node;
+
+	mutex_lock(&vdpa_nic->iova_lock);
+	iova_node = ef100_rbt_search_node(vdpa_nic, iova);
+	if (!iova_node)
+		goto out_unlock;
+
+	update_free_list(iova_node, vdpa_nic, false);
+
+	rb_erase(&iova_node->node, &vdpa_nic->iova_root);
+	kfree(iova_node);
+
+out_unlock:
+	mutex_unlock(&vdpa_nic->iova_lock);
+}
+
+void efx_ef100_delete_iova(struct ef100_vdpa_nic *vdpa_nic)
+{
+	struct ef100_vdpa_iova_node *iova_node;
+	struct rb_root *iova_root;
+	struct rb_node *node;
+
+	mutex_lock(&vdpa_nic->iova_lock);
+
+	iova_root = &vdpa_nic->iova_root;
+	while (!RB_EMPTY_ROOT(iova_root)) {
+		node = rb_first(iova_root);
+		iova_node = rb_entry(node, struct ef100_vdpa_iova_node, node);
+		if (!list_empty(&iova_node->free_node))
+			list_del_init(&iova_node->free_node);
+		if (vdpa_nic->domain)
+			iommu_unmap(vdpa_nic->domain, iova_node->iova,
+				    iova_node->size);
+		rb_erase(node, iova_root);
+		kfree(iova_node);
+	}
+
+	mutex_unlock(&vdpa_nic->iova_lock);
+}
+
+int efx_ef100_find_new_iova(struct ef100_vdpa_nic *vdpa_nic,
+			    unsigned int buf_len,
+			    u64 *new_iova)
+{
+	struct ef100_vdpa_iova_node *iova_node;
+
+	/* pick the first node from freelist */
+	iova_node = list_first_entry_or_null(&vdpa_nic->free_list,
+					     struct ef100_vdpa_iova_node,
+					     free_node);
+	if (!iova_node)
+		return -ENOENT;
+
+	*new_iova = iova_node->iova + iova_node->size;
+	return 0;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_iova.h b/drivers/net/ethernet/sfc/ef100_iova.h
new file mode 100644
index 000000000000..68e39c4152c7
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_iova.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Driver for Xilinx network controllers and boards
+ * Copyright(C) 2020-2022 Xilinx, Inc.
+ * Copyright(C) 2022 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+#ifndef EFX_EF100_IOVA_H
+#define EFX_EF100_IOVA_H
+
+#include "ef100_nic.h"
+#include "ef100_vdpa.h"
+
+#if defined(CONFIG_SFC_VDPA)
+/**
+ * struct ef100_vdpa_iova_node - guest buffer iova entry
+ *
+ * @node: red black tree node
+ * @iova: mapping's IO virtual address
+ * @size: length of mapped region in bytes
+ * @free_node: free list node
+ */
+struct ef100_vdpa_iova_node {
+	struct rb_node node;
+	unsigned long iova;
+	size_t size;
+	struct list_head free_node;
+};
+
+int efx_ef100_insert_iova_node(struct ef100_vdpa_nic *vdpa_nic,
+			       u64 iova, u64 size);
+void efx_ef100_remove_iova_node(struct ef100_vdpa_nic *vdpa_nic,
+				unsigned long iova);
+void efx_ef100_delete_iova(struct ef100_vdpa_nic *vdpa_nic);
+int efx_ef100_find_new_iova(struct ef100_vdpa_nic *vdpa_nic,
+			    unsigned int buf_len, u64 *new_iova);
+#endif  /* CONFIG_SFC_VDPA */
+#endif	/* EFX_EF100_IOVA_H */
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 41811c519275..72820d2fe19d 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -33,7 +33,6 @@
 
 #define EF100_MAX_VIS 4096
 #define EF100_NUM_MCDI_BUFFERS	1
-#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
 
 #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
 
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 80bca281a748..b9368eb1acd5 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -14,6 +14,7 @@
 #include <uapi/linux/vdpa.h>
 #include "ef100_vdpa.h"
 #include "mcdi_vdpa.h"
+#include "ef100_iova.h"
 #include "mcdi_filters.h"
 #include "mcdi_functions.h"
 #include "ef100_netdev.h"
@@ -280,6 +281,34 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
 	return 0;
 }
 
+static int vdpa_update_domain(struct ef100_vdpa_nic *vdpa_nic)
+{
+	struct vdpa_device *vdpa = &vdpa_nic->vdpa_dev;
+	struct iommu_domain_geometry *geo;
+	struct device *dma_dev;
+
+	dma_dev = vdpa_get_dma_dev(vdpa);
+	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
+		return -EOPNOTSUPP;
+
+	vdpa_nic->domain = iommu_get_domain_for_dev(dma_dev);
+	if (!vdpa_nic->domain)
+		return -ENODEV;
+
+	geo = &vdpa_nic->domain->geometry;
+	/* save the geo aperture range for validation in dma_map */
+	vdpa_nic->geo_aper_start = geo->aperture_start;
+
+	/* Handle the boundary case */
+	if (geo->aperture_end == ~0ULL)
+		geo->aperture_end -= 1;
+	vdpa_nic->geo_aper_end = geo->aperture_end;
+
+	/* insert a sentinel node */
+	return efx_ef100_insert_iova_node(vdpa_nic,
+					  vdpa_nic->geo_aper_end + 1, 0);
+}
+
 static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 						const char *dev_name,
 						enum ef100_vdpa_class dev_type,
@@ -316,6 +345,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	}
 
 	mutex_init(&vdpa_nic->lock);
+	mutex_init(&vdpa_nic->iova_lock);
 	dev = &vdpa_nic->vdpa_dev.dev;
 	efx->vdpa_nic = vdpa_nic;
 	vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
@@ -325,9 +355,11 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	vdpa_nic->pf_index = nic_data->pf_index;
 	vdpa_nic->vf_index = nic_data->vf_index;
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
+	vdpa_nic->iova_root = RB_ROOT;
 	vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
 	ether_addr_copy(vdpa_nic->mac_address, mac);
 	vdpa_nic->mac_configured = true;
+	INIT_LIST_HEAD(&vdpa_nic->free_list);
 
 	for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
 		vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
@@ -353,6 +385,12 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 		goto err_put_device;
 	}
 
+	rc = vdpa_update_domain(vdpa_nic);
+	if (rc) {
+		pci_err(efx->pci_dev, "update_domain failed, err: %d\n", rc);
+		goto err_put_device;
+	}
+
 	rc = get_net_config(vdpa_nic);
 	if (rc)
 		goto err_put_device;
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
index 1b0bbba88154..c3c77029973d 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.h
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
@@ -12,7 +12,9 @@
 #define __EF100_VDPA_H__
 
 #include <linux/vdpa.h>
+#include <linux/iommu.h>
 #include <uapi/linux/virtio_net.h>
+#include <linux/rbtree.h>
 #include "net_driver.h"
 #include "ef100_nic.h"
 
@@ -155,6 +157,12 @@ struct ef100_vdpa_filter {
  * @mac_configured: true after MAC address is configured
  * @filters: details of all filters created on this vdpa device
  * @cfg_cb: callback for config change
+ * @domain: IOMMU domain
+ * @iova_root: iova rbtree root
+ * @iova_lock: lock to synchronize updates to rbtree and freelist
+ * @free_list: list to store free iova areas of size >= MCDI buffer length
+ * @geo_aper_start: start of valid IOVA range
+ * @geo_aper_end: end of valid IOVA range
  */
 struct ef100_vdpa_nic {
 	struct vdpa_device vdpa_dev;
@@ -174,6 +182,13 @@ struct ef100_vdpa_nic {
 	bool mac_configured;
 	struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
 	struct vdpa_callback cfg_cb;
+	struct iommu_domain *domain;
+	struct rb_root iova_root;
+	/* mutex to synchronize rbtree operations */
+	struct mutex iova_lock;
+	struct list_head free_list;
+	u64 geo_aper_start;
+	u64 geo_aper_end;
 };
 
 int ef100_vdpa_init(struct efx_probe_data *probe_data);
diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
index 718b67f6da90..8c198d949fdb 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
@@ -10,6 +10,7 @@
 
 #include <linux/vdpa.h>
 #include "ef100_vdpa.h"
+#include "ef100_iova.h"
 #include "io.h"
 #include "mcdi_vdpa.h"
 
@@ -260,6 +261,7 @@ static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
 	if (!vdpa_nic->status)
 		return;
 
+	efx_ef100_delete_iova(vdpa_nic);
 	vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
 	vdpa_nic->status = 0;
 	vdpa_nic->features = 0;
@@ -743,9 +745,12 @@ static void ef100_vdpa_free(struct vdpa_device *vdev)
 	int i;
 
 	if (vdpa_nic) {
+		/* clean-up the mappings and iova tree */
+		efx_ef100_delete_iova(vdpa_nic);
 		for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
 			reset_vring(vdpa_nic, i);
 		ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
+		mutex_destroy(&vdpa_nic->iova_lock);
 		mutex_destroy(&vdpa_nic->lock);
 		vdpa_nic->efx->vdpa_nic = NULL;
 	}
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index db4ca4975ada..7d977a58a0df 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -7,6 +7,7 @@
 #ifndef EFX_MCDI_H
 #define EFX_MCDI_H
 
+#include "mcdi_pcol.h"
 /**
  * enum efx_mcdi_state - MCDI request handling state
  * @MCDI_STATE_QUIESCENT: No pending MCDI requests. If the caller holds the
@@ -40,6 +41,8 @@ enum efx_mcdi_mode {
 	MCDI_MODE_FAIL,
 };
 
+#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
+
 /**
  * struct efx_mcdi_iface - MCDI protocol context
  * @efx: The associated NIC.
-- 
2.30.1

