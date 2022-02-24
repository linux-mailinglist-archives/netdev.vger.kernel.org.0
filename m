Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB80D4C2E22
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbiBXOW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiBXOWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:22:19 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2066.outbound.protection.outlook.com [40.107.95.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79A13B563;
        Thu, 24 Feb 2022 06:21:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mujknrdTm/37KY9Zwi9ZxbtjNiWlmAUdmCnNdj08R7QcIn8M4htQW8Sg9B2fhsakoihnE+OW99QTk4Eyc5jgF1VViy3KuJ66NLNxPteVva73438tPMZfLEujrONp1nWDvB76B79fDJydBVkRL6gBS8sROEgebFp+S2IAkfwBi+rMjKSnGIMsGG3jxbClZKrj8N1m6J802Wx1UAKrpxMKvv5T71zx9UeSsuarRwiGVuYxr+xsNC0TM8+Mbq0+DQgBdteHPjulemSxnBQiK8SLAxYiGCV2BhAF9k4lusi15sS5ixzCUnb06uBRXtdqoa23RwrVHdrkb55eYdzrZYoaKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pg4lySj2nLNpbwVNF+SkgD4I4673nkRu8g6N+8mp3Is=;
 b=eFc2NnFYyqGIpxSGzH6gxvfpY2S6rXNT0GGK3mhT7JIKxE37WX9j2SZ9ZW6p4ou8UyZ0HnIyfXHDJYOzxY+tztZikQxaPqJNxnZMryKX6ozHWgPLFksScNDBH9b394+xIJ3RHd7dG9XAKENqbB/sJR8+GVthwCRttig3JDK81mm2uPmACN4wwt30mRlIUY4fI6Hju4mvcbbz3RlXGrefSJed08Sb0o17xJjn9nYcLqaqzwFyoAsUJDMBgloAZ+IvlPnFpXwd3qH/CnsurooayMcl+rH2mY4WWkihIh1dVSJwpDK5tMj9I4l8/pOvkL7jP4l1NIKKCFb210HJe7OUHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pg4lySj2nLNpbwVNF+SkgD4I4673nkRu8g6N+8mp3Is=;
 b=BD+4NVyNjEJWnCRF3ABgbnyAlq1RXoZu+3wRzwz/Knwtxy/bjLR83ZP/bTJKYnlSWSFm66Cbk9wIfHC2OBUEaw3ckgYmHmd5gjSTji6JG/1sku6ZyjlhuznbyU2D78R+i+kyvyj+1LuFuXxKL8GTa/Q7CwKrix2DkIXz9LOvZrCKCxK5ydbJliBGsmy+UeZ9JnOoA0xfLBBM3gSqEsKyXctHsUceW8n99m9gxQxAty/usMGC5ajKuIOnn2Pu8Yv1YKooWur7eqyPdFZuubOzyGzgF2udyW7jXe/nDLNBYjIZT2AvvEx52eQSAXSgw1GQ4QRGnZ9y1N9g5iNGgF6ZaQ==
Received: from MW4PR03CA0150.namprd03.prod.outlook.com (2603:10b6:303:8c::35)
 by SN6PR12MB2702.namprd12.prod.outlook.com (2603:10b6:805:6c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 14:21:38 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::b4) by MW4PR03CA0150.outlook.office365.com
 (2603:10b6:303:8c::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:34 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:31 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 10/15] vfio: Extend the device migration protocol with RUNNING_P2P
Date:   Thu, 24 Feb 2022 16:20:19 +0200
Message-ID: <20220224142024.147653-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 174b9466-6d59-4f07-3864-08d9f7a0f861
X-MS-TrafficTypeDiagnostic: SN6PR12MB2702:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB27025625829AA2698D4098B5C33D9@SN6PR12MB2702.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7AXDeu+zEJ5+goRPk2nd08LBz1KeUGFJHlgd4Rd87JdQWJCipaNw9rDyGrWSdUiPl7oF1vpkXkbHWFwWeykMMvODHABz4ylTkovp5w0gfCjBSyyweYi2qBJQ6tkkoodmJ5yD7uYmD/tZSqproC17yIlqXqtLx5KHDGRBvcFbrXEc5u21u6JqRGtxD0EWNIuAkJ3FK51w98iBbCmPHQUtoGuERBLG3weUX2O12fXCPIrpmhiV5wzvpn+HY6UA0JW466FBkw2iTv+IcTK0EC7acwKFnT97WO2EyWDHsfKFNCDQYUrZNOhRwbivQtifPQE36kOalCiaszUnmMn8+QXdmf6/Apdr9rFkhSxRL95TW17NIvhkG3e65P2c16kPAFb1CxlMCOILjPV7dAZJi4TBZQ2EYwOBYWyr6zmVpSOLIBuGWP/kFuDOGQf6uMzmvyuLKHj2/DYQP6D8tGS6ONHjF/tTWYT+c0x0l0DcFpionzx/oC33aFe84O+LG5rzTm4TLVvVHIFpzrL0jVtz17mPM/YRr0EkRM1o+4921IoVfjY4xbqu1qHh+YcbpnRIb5rpd7dCn2jOp59qb4by1GEGSdDk149PMdEPGbTFkxy6LP1HsbPyAZieOlyCskikT1NDiIPklqts7YgWhFd3I69BfShAoSElWQiHnCnnMkJlW7n8JIyDHQhf+KAA6GJDZ1Bu61913qU7dIfY+h+Muq9zGQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6666004)(7696005)(26005)(336012)(86362001)(82310400004)(186003)(1076003)(426003)(2616005)(36860700001)(47076005)(7416002)(8936002)(36756003)(40460700003)(81166007)(356005)(2906002)(110136005)(83380400001)(54906003)(70586007)(70206006)(508600001)(8676002)(6636002)(316002)(30864003)(5660300002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:38.2491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 174b9466-6d59-4f07-3864-08d9f7a0f861
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2702
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The RUNNING_P2P state is designed to support multiple devices in the same
VM that are doing P2P transactions between themselves. When in RUNNING_P2P
the device must be able to accept incoming P2P transactions but should not
generate outgoing P2P transactions.

As an optional extension to the mandatory states it is defined as
inbetween STOP and RUNNING:
   STOP -> RUNNING_P2P -> RUNNING -> RUNNING_P2P -> STOP

For drivers that are unable to support RUNNING_P2P the core code
silently merges RUNNING_P2P and RUNNING together. Unless driver support
is present, the new state cannot be used in SET_STATE.
Drivers that support this will be required to implement 4 FSM arcs
beyond the basic FSM. 2 of the basic FSM arcs become combination
transitions.

Compared to the v1 clarification, NDMA is redefined into FSM states and is
described in terms of the desired P2P quiescent behavior, noting that
halting all DMA is an acceptable implementation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/vfio.c       | 84 +++++++++++++++++++++++++++++++--------
 include/linux/vfio.h      |  1 +
 include/uapi/linux/vfio.h | 36 ++++++++++++++++-
 3 files changed, 102 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b37ab27b511f..bdb5205bb358 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1577,39 +1577,55 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state new_fsm,
 			    enum vfio_device_mig_state *next_fsm)
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
@@ -1617,6 +1633,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
 		[VFIO_DEVICE_STATE_RESUMING] = {
@@ -1624,6 +1641,15 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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
@@ -1631,17 +1657,41 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
 	};
 
-	if (WARN_ON(cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table)))
+	static const unsigned int state_flags_table[VFIO_DEVICE_NUM_STATES] = {
+		[VFIO_DEVICE_STATE_STOP] = VFIO_MIGRATION_STOP_COPY,
+		[VFIO_DEVICE_STATE_RUNNING] = VFIO_MIGRATION_STOP_COPY,
+		[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_MIGRATION_STOP_COPY,
+		[VFIO_DEVICE_STATE_RESUMING] = VFIO_MIGRATION_STOP_COPY,
+		[VFIO_DEVICE_STATE_RUNNING_P2P] =
+			VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P,
+		[VFIO_DEVICE_STATE_ERROR] = ~0U,
+	};
+
+	if (WARN_ON(cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
+		    (state_flags_table[cur_fsm] & device->migration_flags) !=
+			state_flags_table[cur_fsm]))
 		return -EINVAL;
 
-	if (new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
+	if (new_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
+	   (state_flags_table[new_fsm] & device->migration_flags) !=
+			state_flags_table[new_fsm])
 		return -EINVAL;
 
+	/*
+	 * Arcs touching optional and unsupported states are skipped over. The
+	 * driver will instead see an arc from the original state to the next
+	 * logical state, as per the above comment.
+	 */
 	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
+	while ((state_flags_table[*next_fsm] & device->migration_flags) !=
+			state_flags_table[*next_fsm])
+		*next_fsm = vfio_from_fsm_table[*next_fsm][new_fsm];
+
 	return (*next_fsm != VFIO_DEVICE_STATE_ERROR) ? 0 : -EINVAL;
 }
 EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
@@ -1731,7 +1781,7 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 					       size_t argsz)
 {
 	struct vfio_device_feature_migration mig = {
-		.flags = VFIO_MIGRATION_STOP_COPY,
+		.flags = device->migration_flags,
 	};
 	int ret;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index acc99aeea29b..f1b5d231b7ed 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -33,6 +33,7 @@ struct vfio_device {
 	struct vfio_group *group;
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
+	unsigned int migration_flags;
 
 	/* Members below here are private, not for driver use */
 	refcount_t refcount;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 22ed358c04c5..26a66f68371d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1011,10 +1011,16 @@ struct vfio_device_feature {
  *
  * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
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
 
@@ -1065,10 +1071,13 @@ struct vfio_device_feature_mig_state {
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
  *   While in STOP the device must stop the operation of the device. The device
  *   must not generate interrupts, DMA, or any other change to external state.
@@ -1095,11 +1104,16 @@ struct vfio_device_feature_mig_state {
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
@@ -1129,6 +1143,18 @@ struct vfio_device_feature_mig_state {
  *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
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
+ * behave as though the device was fully running if not supported. Like while in
+ * STOP or STOP_COPY the user must not touch the device, otherwise the state
+ * can be exited.
+ *
  * The remaining possible transitions are interpreted as combinations of the
  * above FSM arcs. As there are multiple paths through the FSM arcs the path
  * should be selected based on the following rules:
@@ -1141,6 +1167,11 @@ struct vfio_device_feature_mig_state {
  * fails. When handling these types of errors users should anticipate future
  * revisions of this protocol using new states and those states becoming
  * visible in this case.
+ *
+ * The optional states cannot be used with SET_STATE if the device does not
+ * support them. The user can discover if these states are supported by using
+ * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
+ * avoid knowing about these optional states if the kernel driver supports them.
  */
 enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_ERROR = 0,
@@ -1148,6 +1179,7 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING = 2,
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
+	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
 /* -------- API for Type1 VFIO IOMMU -------- */
-- 
2.18.1

