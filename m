Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB724A37A4
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355710AbiA3QPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:45 -0500
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:51297
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355642AbiA3QPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvqHJzAmLJewQsVaxb2esrxS60PU8OpWMoj+xCAdubvEaB/VwjscvUDvcGhgzjaPxi9DzUUE8gA0X2ZPAzMQ3nXejG3jqRDLKEnvYXH4Eb/9eJSymsM9ZSyhJNr+fILn+3L+g71tRwiw78VWRxvDOFJ0fKdjvR8GesbrCzsecDay1EUTmT6nZHxNYwhEG0pxF7P0DlXy/NVVbTwHcRURkli4DzUP+bT17lcFgpHxARmC1sMxZl5Nenr8pKPwddPGkBR6TQqSKj55YKEZzpt3ukgedUv601EfNO/u4xV+cpuRm7gANAH5FXGg81SYaLJlcrJkzcgz4cWG+rDX4q6V+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R09n+vQ2szB3v1hXrGsre4kGZrhlMU0L7ImG085Wk6U=;
 b=f+r4DtVBfPcE72LfwXwHg0+png7FkuYL7Gy0/7+M3cC0NpXiJf6hD8sccGsLrG1GRZpYZse8U2uPOEsCv6aRBs7342ADWv6vCcj3HzaTFc+rCDIRALY/akzWE42h1ABa0Z3UIscDlbbWvB+p7PpyX09AQsH1lwbPt/syu5lWHjFMU9teYieXxtHk3eDQL5ASpLuA5v5NzAJtT+xuSVXyJpgYw5NwlA7oxM8hOwGBDzGzWXGvYZzm3b3rlWEb8QKrp70ZhJlUZhKzywqXq2irspk6xQVVxpVRDVcjqzP1MzM8FHefy3L+QiAb/qAIWtVsBSU94lTH8lr6Kza7/bOo6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R09n+vQ2szB3v1hXrGsre4kGZrhlMU0L7ImG085Wk6U=;
 b=MIh2cb1ygu9jSuo2McwQmOsYPNXbwNRttfVd9vGyY1BHSAn60SJtH7v+mC0lL/9nyM6D7grLrP1ig25M90V1unJWegn4in5lEZWo1BsZ8HqhD0uxoXH7PlifbbA/vs4pSZkb2Gle9bbpzPQ/Soe/aeg3/794umZUiIxeW9aSYYiTZES6RoAVvUzje2rZeGfBP20vm/tpe1jHwLWu2vI2X/9oMeGzfEKHflu+eQFTvZqJJNybikMkg98ahVAk956MHO3Bu9/f5EyZapSQIrzoZH4ZtsXLDXh0kwYzxHrOx/llvLC8AoNQ7tXSUlBRWKW7gVEG+hD7Kiz8j/y2kKHsOQ==
Received: from DM6PR12CA0020.namprd12.prod.outlook.com (2603:10b6:5:1c0::33)
 by DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sun, 30 Jan
 2022 16:15:22 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::5f) by DM6PR12CA0020.outlook.office365.com
 (2603:10b6:5:1c0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:17 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:13 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 09/15] vfio: Extend the device migration protocol with RUNNING_P2P
Date:   Sun, 30 Jan 2022 18:08:20 +0200
Message-ID: <20220130160826.32449-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8b8ede-aca2-40d2-86dd-08d9e40bb78b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4385:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4385A09BA2FAE7ADB65B6B5FC3249@DM6PR12MB4385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbFb18pCytnwX5YbUqzU4HiFVDyiAXMBV9TQeFz457tfdNm/VYNpMtsw8qC6dlcB2/24I++9jHmwiR+cuHEfX8pcjDvmsDeC52J3Na6ZDW9UMdOCiLSVlwBM5flf+7ZdsWAxiBDkaBaMAyitV3Dnjs1T5x1Wj3OmUH5+6pH1IgSmuiVl+zWL99TOCZJLXcvoMRTYUAlNmxV2+yySgUHKvnPPylo8EAtu/TCClWAQD0ystiVKhVJUIpqezZAihYZU5cwWRsGNF7S/2SF45hopzRzWyH6S3mXbaGAdE5sU8dpPQzA6e9cd3envrpu1J46QycRSnKL0uy+F/rWAj8eG6bNqF/6p7x4W8mabc/CbEpOVgsb9oKDCvbH5FzDTWr96GTmf2l0C2nyL/frbe4ePq8li8MUdpSKKDCDqjgkr/6fN08RH88x+KRBEs61CqbuyJULf9NmM5t2GAURZxE5VRBWcRWEmiYVPuzcQFClzdyIrrZ15GWk+xohQvhll14dVklOxoLDHye3nO/gIYA7tWCWK0v7JQ79exD03+7xNTnLMOi34kczmSZuyCjoRCaTvyBmzahMpBTkpVwnN6V5suNA0wfmBDdaROrsz4Mx0vKNu30YY1lUSuO81G3fKetl7FTjJCUZbJzA3SNrkgzCv3HcfZlLRRc6HzzPQ6kctut/tCRXPfSK7ZVq/az8teXiCOyEWm8DUImWXt5DR78ppJQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(70586007)(7696005)(426003)(336012)(508600001)(26005)(186003)(1076003)(30864003)(8936002)(8676002)(5660300002)(4326008)(316002)(82310400004)(36860700001)(47076005)(356005)(6666004)(110136005)(81166007)(54906003)(2616005)(86362001)(2906002)(40460700003)(83380400001)(6636002)(36756003)(107886003)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:22.3377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af8b8ede-aca2-40d2-86dd-08d9e40bb78b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The RUNNING_P2P state is designed to support multiple devices in the same
VM that are doing P2P transactions between themselves. When in RUNNING_P2P
the device must be able to accept incoming P2P transactions but should not
generate outgoing transactions.

As an optional extension to the mandatory states it is defined as
inbetween STOP and RUNNING:
   STOP -> RUNNING_P2P -> RUNNING -> RUNNING_P2P -> STOP

For drivers that are unable to support RUNNING_P2P the core code silently
merges RUNNING_P2P and RUNNING together. Drivers that support this will be
required to implement 4 FSM arcs beyond the basic FSM. 2 of the basic FSM
arcs become combination transitions.

Compared to the v1 clarification, NDMA is redefined into FSM states and is
described in terms of the desired P2P quiescent behavior, noting that
halting all DMA is an acceptable implementation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/vfio.c       | 70 ++++++++++++++++++++++++++++++---------
 include/linux/vfio.h      |  2 ++
 include/uapi/linux/vfio.h | 34 +++++++++++++++++--
 3 files changed, 88 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b12be212d048..a722a1a8a48a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1573,39 +1573,55 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state cur_fsm,
 			    enum vfio_device_mig_state new_fsm)
 {
-	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RESUMING + 1 };
+	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
 	/*
-	 * The coding in this table requires the driver to implement 6
+	 * The coding in this table requires the driver to implement
 	 * FSM arcs:
 	 *         RESUMING -> STOP
-	 *         RUNNING -> STOP
 	 *         STOP -> RESUMING
-	 *         STOP -> RUNNING
 	 *         STOP -> STOP_COPY
 	 *         STOP_COPY -> STOP
 	 *
-	 * The coding will step through multiple states for these combination
-	 * transitions:
-	 *         RESUMING -> STOP -> RUNNING
+	 * If P2P is supported then the driver must also implement these FSM
+	 * arcs:
+	 *         RUNNING -> RUNNING_P2P
+	 *         RUNNING_P2P -> RUNNING
+	 *         RUNNING_P2P -> STOP
+	 *         STOP -> RUNNING_P2P
+	 * Without P2P the driver must implement:
+	 *         RUNNING -> STOP
+	 *         STOP -> RUNNING
+	 *
+	 * If all optional features are supported then the coding will step
+	 * through multiple states for these combination transitions:
+	 *         RESUMING -> STOP -> RUNNING_P2P
+	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING
 	 *         RESUMING -> STOP -> STOP_COPY
-	 *         RUNNING -> STOP -> RESUMING
-	 *         RUNNING -> STOP -> STOP_COPY
+	 *         RUNNING -> RUNNING_P2P -> STOP
+	 *         RUNNING -> RUNNING_P2P -> STOP -> RESUMING
+	 *         RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
+	 *         RUNNING_P2P -> STOP -> RESUMING
+	 *         RUNNING_P2P -> STOP -> STOP_COPY
+	 *         STOP -> RUNNING_P2P -> RUNNING
 	 *         STOP_COPY -> STOP -> RESUMING
-	 *         STOP_COPY -> STOP -> RUNNING
+	 *         STOP_COPY -> STOP -> RUNNING_P2P
+	 *         STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
 	 */
 	static const u8 vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STATES] = {
 		[VFIO_DEVICE_STATE_STOP] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
-			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
 		[VFIO_DEVICE_STATE_RUNNING] = {
-			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
-			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
-			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
 		[VFIO_DEVICE_STATE_STOP_COPY] = {
@@ -1613,6 +1629,7 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
 		[VFIO_DEVICE_STATE_RESUMING] = {
@@ -1620,6 +1637,15 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_RUNNING_P2P] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
 		[VFIO_DEVICE_STATE_ERROR] = {
@@ -1627,14 +1653,26 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
 	};
+	bool have_p2p = device->migration_flags & VFIO_MIGRATION_P2P;
+
 	if (cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
 	    new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
 		return VFIO_DEVICE_STATE_ERROR;
 
-	return vfio_from_fsm_table[cur_fsm][new_fsm];
+	if (!have_p2p && (new_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
+			  cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P))
+		return VFIO_DEVICE_STATE_ERROR;
+
+	cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
+	if (!have_p2p) {
+		while (cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P)
+			cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
+	}
+	return cur_fsm;
 }
 EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
 
@@ -1719,7 +1757,7 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 					       size_t argsz)
 {
 	struct vfio_device_feature_migration mig = {
-		.flags = VFIO_MIGRATION_STOP_COPY,
+		.flags = device->migration_flags,
 	};
 	int ret;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 697790ec4065..69a574ba085e 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -33,6 +33,7 @@ struct vfio_device {
 	struct vfio_group *group;
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
+	unsigned int migration_flags;
 
 	/* Members below here are private, not for driver use */
 	refcount_t refcount;
@@ -44,6 +45,7 @@ struct vfio_device {
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
+ * @flags: Global flags from enum vfio_device_ops_flags
  * @open_device: Called when the first file descriptor is opened for this device
  * @close_device: Opposite of open_device
  * @read: Perform read(2) on device file descriptor
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d9162702973a..9efc35535b29 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1009,10 +1009,16 @@ struct vfio_device_feature {
  *
  * VFIO_MIGRATION_STOP_COPY means that RUNNING, STOP, STOP_COPY and
  * RESUMING are supported.
+ *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
+ * is supported in addition to the STOP_COPY states.
+ *
+ * Other combinations of flags have behavior to be defined in the future.
  */
 struct vfio_device_feature_migration {
 	__aligned_u64 flags;
 #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
+#define VFIO_MIGRATION_P2P		(1 << 1)
 };
 #define VFIO_DEVICE_FEATURE_MIGRATION 1
 
@@ -1029,10 +1035,13 @@ struct vfio_device_feature_migration {
  *  RESUMING - The device is stopped and is loading a new internal state
  *  ERROR - The device has failed and must be reset
  *
+ * And 1 optional state to support VFIO_MIGRATION_P2P:
+ *  RUNNING_P2P - RUNNING, except the device cannot do peer to peer DMA
+ *
  * The FSM takes actions on the arcs between FSM states. The driver implements
  * the following behavior for the FSM arcs:
  *
- * RUNNING -> STOP
+ * RUNNING_P2P -> STOP
  * STOP_COPY -> STOP
  *   While in STOP the device must stop the operation of the device. The
  *   device must not generate interrupts, DMA, or advance its internal
@@ -1059,11 +1068,16 @@ struct vfio_device_feature_migration {
  *
  *   To abort a RESUMING session the device must be reset.
  *
- * STOP -> RUNNING
+ * RUNNING_P2P -> RUNNING
  *   While in RUNNING the device is fully operational, the device may generate
  *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
  *   and the device may advance its internal state.
  *
+ * RUNNING -> RUNNING_P2P
+ * STOP -> RUNNING_P2P
+ *   While in RUNNING_P2P the device is partially running in the P2P quiescent
+ *   state defined below.
+ *
  * STOP -> STOP_COPY
  *   This arc begin the process of saving the device state and will return a
  *   new data_fd.
@@ -1094,6 +1108,16 @@ struct vfio_device_feature_migration {
  *   recover from ERROR VFIO_DEVICE_RESET must be used to return the
  *   device_state back to RUNNING.
  *
+ * The optional peer to peer (P2P) quiescent state is intended to be a quiescent
+ * state for the device for the purposes of managing multiple devices within a
+ * user context where peer-to-peer DMA between devices may be active. The
+ * RUNNING_P2P states must prevent the device from initiating
+ * any new P2P DMA transactions. If the device can identify P2P transactions
+ * then it can stop only P2P DMA, otherwise it must stop all DMA. The migration
+ * driver must complete any such outstanding operations prior to completing the
+ * FSM arc into a P2P state. For the purpose of specification the states
+ * behave as though the device was fully running if not supported.
+ *
  * The remaining possible transitions are interpreted as combinations of the
  * above FSM arcs. As there are multiple paths through the FSM arcs the path
  * should be selected based on the following rules:
@@ -1106,6 +1130,11 @@ struct vfio_device_feature_migration {
  * fails. When handling these types of errors users should anticipate future
  * revisions of this protocol using new states and those states becoming
  * visible in this case.
+ *
+ * The optional states cannot be used with SET_STATE if the device does not
+ * support them. The user can disocver if these states are supported by using
+ * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
+ * avoid knowing about these optional states if the kernel driver supports them.
  */
 enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_ERROR = 0,
@@ -1113,6 +1142,7 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING = 2,
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
+	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
 /**
-- 
2.18.1

