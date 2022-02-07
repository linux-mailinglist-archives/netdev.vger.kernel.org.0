Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404794AC762
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377311AbiBGR1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346229AbiBGRXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:49 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E7C0401D6;
        Mon,  7 Feb 2022 09:23:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5f6rXMCWmE/PxLPB4lsvctMjNMPXjOmqWQE6PejythkBFCb1Sj/i1TrQ1tLrJqFVDR8OvhIO3xRWVJQmg+XzzHyENBNj0D/X7Cigdh7Q6azM2ws2J4jMghHj+m3qXIpIwxr6RBFs3XeL65G4ax2UdAFsLmclveKxfpEqgJ+YT43Hi3+SO8kc6u4AIQLwjFRWCKxJsIPO9VmMJsH5cAl/KnS0rkmQRV222j1osRvd6HDJaP/FaWNkwMzMaJdDZgJLlw13oJyYdXaZl/u0fFRRmNLeqtGD312+aErM2DyHlgmGJOs7RQPOz8KunkFs8wjADZq7QeOE1gE0TkS0k/HGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iasQLIX5PtpEW4tZYcVSJeb4BwNmLfATGoEzGk2drvc=;
 b=ChfiSV8/GPZupWKWDHQkgDZsURSs6G3ZCsQgv+dFyYpc12A7Q6ugWiabDDsunlTH4eeRm+e+QMkMqGpabbkkRI3tnnhW1hnO5XPu0uDLfuWS6GMzv6wJHEigcuF8WhMqsz/Hud4CtjmqNsxXNUj+Rekn9GpJBvl7VfrmOqXLpOIKKBumuyyjlUtchf9cWQA6G4pktbyPNlelMlypB5QnmAZM3liVwGdioE6d2taSbyKM/HMpwKLeHSVXGVFxPvfODhtwHI+NUur3h4/zINBgO6fzZkv/s5QHfxE/nKO+JV0E9K/LAg44Xws0WqwjqwYAK+Q9wApAWjE29gH5VV8xzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iasQLIX5PtpEW4tZYcVSJeb4BwNmLfATGoEzGk2drvc=;
 b=RiBydfMsU8OSGegWcQZ4Bwx0fAbbDTCstlCNT4RZfZbp0Cwrro5XOGOVu2wlAe7BDGyhL4ySPR+oocfg0ip7rs06xCSQ9uZllz0coklHcPiI0MaUmFdSWRXW4X+xGVaHzCar/tgzB9bFtAWiqrwZhb2hIcFg3tnp54xq7iMbd7NTAptQ2tXDJ8hzmC+XL5VnF1Z8UVzH9prWZ6CiT3aQzkbuSooGtkQW9z9haKmdFb4ZCs9pxcp1CRXfmjTtv1DEKURkv21298YiU0hHOlv0xpSL0o6Y1G2m+fdDDcvI4cENgOM2W75Xg6QxojkfswfE3FnRDji7+4kyQI7RcHSCRw==
Received: from MWHPR02CA0016.namprd02.prod.outlook.com (2603:10b6:300:4b::26)
 by DM6PR12MB5550.namprd12.prod.outlook.com (2603:10b6:5:1b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Mon, 7 Feb
 2022 17:23:46 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::c2) by MWHPR02CA0016.outlook.office365.com
 (2603:10b6:300:4b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:44 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:40 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 09/15] vfio: Extend the device migration protocol with RUNNING_P2P
Date:   Mon, 7 Feb 2022 19:22:10 +0200
Message-ID: <20220207172216.206415-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 314b92f3-b137-4689-28eb-08d9ea5e9846
X-MS-TrafficTypeDiagnostic: DM6PR12MB5550:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB5550600E101DD1E6F6DFB212C32C9@DM6PR12MB5550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K2s7Le1qR9fdF0hAiiMxc4sa3kSZrbsDTKUO3UHjfmlrlKaEa3P0VOZ3rcwX4cnAo/V9S/96MsiTp0Ss6NAY/VEEAb4dqcswtW6D6/xr0uW2JWycBadE98ue+dgiV5LX0kQ924OaPtQ50MF1Qpi3jEt6oZPwtaUEc8sphNIm3aoSWL0sDVQgEOgUyX0NoArpnyWggQHq5hgweaBP9qsdiRN0uuhWMtMuyzYy3NfSzs2YAGshCNWCNFQLGYjRBMCWUZYgwl2KDZKasw0mzK1wfKhx//nrEPpuRS/pj7fVxpJWG98s+2CkyJSn/esL1I5H5ZVnRoUD5G8Q/xpKy4bEayDhQIF1gBkowuodpm84evrZIgHg4qaAEeengU5XDqCzmXsDVFN/lgLbVjHOx43LNeZGPU4u6po1zd/KtSNDjB/PC1g3x8s0t3WDpYWOgzX+nolZc2ITkPEzCnG+KUTmVyrBhdWYL/x37ev83MP5vY/ou414LbK+GFDRrqcX79UqM0c4aFhtbvw0sbr2mJE9jSK06Wj7xt6LNuBhe0d/JKL7a9rvcn4261G33iKha25qgv+xl0uLIgKENWqj5jtHuCBNiW6RUcBZ8mGUat6782GebmGGSKI22nVjs+jPoz3GGKEmtilA5TD+WVy3f9ZE3iISRIAKtduw61371HjVM0rt+mFoUp+2uOcNUMtYXrmBN15pf8lAQpt1xMZbSm3YlCE8LJXO4nCOoptwCXU2DNrlcTSCgor79TY8V4wJzRImrecLX/nA7uqxIpRCWMP5QHqoXTWywwcuouCt4WsLjOw=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(6666004)(86362001)(2616005)(36860700001)(2906002)(356005)(8676002)(26005)(83380400001)(70206006)(7696005)(6636002)(4326008)(426003)(1076003)(40460700003)(30864003)(110136005)(54906003)(508600001)(8936002)(5660300002)(336012)(70586007)(186003)(82310400004)(63370400001)(36756003)(81166007)(63350400001)(47076005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:45.1102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 314b92f3-b137-4689-28eb-08d9ea5e9846
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5550
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
 drivers/vfio/vfio.c       | 79 ++++++++++++++++++++++++++++++---------
 include/linux/vfio.h      |  1 +
 include/uapi/linux/vfio.h | 34 ++++++++++++++++-
 3 files changed, 95 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e7ab9f2048cd..8c484593dfe0 100644
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
@@ -1631,17 +1657,36 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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
 
 	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
+	while ((state_flags_table[*next_fsm] & device->migration_flags) !=
+			state_flags_table[*next_fsm])
+		*next_fsm = vfio_from_fsm_table[*next_fsm][new_fsm];
+
 	return (*next_fsm != VFIO_DEVICE_STATE_ERROR) ? 0 : -EINVAL;
 }
 EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
@@ -1731,7 +1776,7 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 					       size_t argsz)
 {
 	struct vfio_device_feature_migration mig = {
-		.flags = VFIO_MIGRATION_STOP_COPY,
+		.flags = device->migration_flags,
 	};
 	int ret;
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 3f4a1a7c2277..a173718d2a1b 100644
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
index 89012bc01663..773895988cf1 100644
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
 
@@ -1063,10 +1069,13 @@ struct vfio_device_feature_mig_state {
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
@@ -1093,11 +1102,16 @@ struct vfio_device_feature_mig_state {
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
@@ -1127,6 +1141,16 @@ struct vfio_device_feature_mig_state {
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
+ * behave as though the device was fully running if not supported.
+ *
  * The remaining possible transitions are interpreted as combinations of the
  * above FSM arcs. As there are multiple paths through the FSM arcs the path
  * should be selected based on the following rules:
@@ -1139,6 +1163,11 @@ struct vfio_device_feature_mig_state {
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
@@ -1146,6 +1175,7 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING = 2,
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
+	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
 /* -------- API for Type1 VFIO IOMMU -------- */
-- 
2.18.1

