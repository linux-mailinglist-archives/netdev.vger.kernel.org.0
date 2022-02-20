Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457194BCDD0
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240907AbiBTJ7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:59:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243656AbiBTJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:59:36 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F48546BF;
        Sun, 20 Feb 2022 01:59:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6JVnH0A/UCfqXvhSyIEqjRXl6VP2iBvz+LdLq3uT0ptOsy3NrAtAOYoYtUsOQsyyoOQZZDiN9r0WZyE+Il/nI7mVbOF/qx0gq1IeGIp/4D70IOiV+1ytIsq7/jDgocGs/GKfDopM29nM4zc/2WWQnMduA2GbSWie5AJeoErxNpvZTABFFPQRV2xts08D+E8RvZDEAFPf/yKUJcgtjNyLYqmNpKpPz2613PupSXpq4kvqkN7hjO3xMKgkouv4MfY9vfnxwc2okNUnJsKNnJS47awYsPlWuAUkRcEiDhA2cX2WJheHYRdtW4mJI9u18yx4nVc6kWCDgkIb9TodiYR4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=157VQb82Al3hN7dordjcM3FVduuw604BBAN7zbqY0hs=;
 b=kK19WlyOHc5Wkz/B/5YbmdBoLuyR0PUx69/XLHzE5/pqY4k0/BMg1Bgys3EUBh+a3CphdARc0gxoht33soTFReG0akAtdnVN1eRJdZna5SIq5PIWGD5fOK5GErfgD0eI4f23LFqhlOh6+vy4FuSpER8LfXpK85sraaZrqx9LER4W4Agdm6pVfdhHcpPBiXkNh9GWfgs5equ62hB1CXMehRQ/Uvh5EUcEQ2H7c0e81TUF78z6lNc7VjIryVJLC+2Phbma7Cbxq73Ce9vSxlmjvqxJ3ypvQXmUWPgWR1wU4g4jWUg9baiHrIeUjIVbFJOPZnImvfIkCumbJnMEukTX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=157VQb82Al3hN7dordjcM3FVduuw604BBAN7zbqY0hs=;
 b=X2hbznbhQfQhJhw+YXZat4gJ0COvN38zO4acTgdJa9jTKCdM0fcAkNR6vLAUVgxXM8rvDg0czU6OwQppSxP/nmH5mZz0gUoQxSPG1FXjv+ZElhiiYDIOQzeEhUqYbdBd8aSjTkU1iBVHOrVS4M4fewGOiPzGcgj6ZA2ta+gYSI131WZPEFgxEqfxPCiKRqRKJwd5/9pszegHufzteQ8UE4px7YhwnCJGXNnQ/ham3KiZcPgFPK+cuUe7zYy9Wo/DhuwoMIpFhIsTSGNCNE+Xd9cZevPA85vUZ0Ef68+TCUT6qWZIKbCaQrS02SEmtdTYeyVbrro1P3chT9ftVxYjFg==
Received: from DS7PR05CA0023.namprd05.prod.outlook.com (2603:10b6:5:3b9::28)
 by MW3PR12MB4411.namprd12.prod.outlook.com (2603:10b6:303:5e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 09:59:09 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::b4) by DS7PR05CA0023.outlook.office365.com
 (2603:10b6:5:3b9::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.19 via Frontend
 Transport; Sun, 20 Feb 2022 09:59:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:59:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:59:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:59:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:59:01 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 10/15] vfio: Extend the device migration protocol with RUNNING_P2P
Date:   Sun, 20 Feb 2022 11:57:11 +0200
Message-ID: <20220220095716.153757-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0289603-4eeb-495f-441b-08d9f457a32a
X-MS-TrafficTypeDiagnostic: MW3PR12MB4411:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4411453632448FFB624C7411C3399@MW3PR12MB4411.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EYox8l5A0GyCLW+8NocNcg/mi8uvt7L3se/a83/83ykZ97oNaB/Pr+sPXYFXy9mzX53qxCPI46+7gH4HjBANBOao2jrNxhD7gWrvbas3ZlcH9sPKdzaFE3FI/ZIE4f51u5ii08Vsw8SBHTCtIwY+fFp+aCTZT78rhstOgCDOzQxASrgi9cV4Dq0mxD5zUrbGSlGNC5gdptM/daZbx2OYv8RUwgB7KJ487LuAIe2RFmMZV7Ma/Lpu8RI/h6fOUf7nF3rhcYrIUl2N8iTG3rvYc2cJXE8k1tUZ/IxrYmip+jg9I8uTnj7x05aR4P36+GJJqhd2V4iDPfWZNFpB6C0Efd7uIeRtRAZ1pVD2UBcsIK1p/t9RLwyClVcqBGEb0zOPILsfkV915it/3T1XFBFPWCUNEsWSs5mWg6ibSDovBF/MG8+56MtMlWps81LR3Dcn9FpbZ8T0SkJD2FXUiosjNjMGkh3Yp/bfVcDTXkhh6Z4xR5AdVL5kZnQl1WjGEAY7xPGJd21IKqwc7V0UHyWecMHlm2DceY52/w2e9Cr/K2tZjRAJvB+qIXudnPEzGYdXVnFlm3cyBHlN9RnrCOQc9oIyviiH8OprxQXHu44qqBTYyycpZg/iH8cd4bBleX6xb+B2je6Da4L6qwTP7v5xf61D464kE7AhcEOoVtqHsJru9DlX8MjFDfh8ii1gzhfEnDf6evpcbE7wRcdMzrk7/A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(6666004)(426003)(7696005)(4326008)(70206006)(70586007)(82310400004)(26005)(186003)(1076003)(336012)(508600001)(54906003)(36756003)(6636002)(7416002)(8676002)(8936002)(5660300002)(316002)(110136005)(83380400001)(30864003)(2906002)(81166007)(356005)(47076005)(36860700001)(2616005)(86362001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:59:08.5174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0289603-4eeb-495f-441b-08d9f457a32a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4411
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3bbadcdbc9c8..3176cb5d4464 100644
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
index 02b836ea8f46..46b06946f0a8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1010,10 +1010,16 @@ struct vfio_device_feature {
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
 
@@ -1064,10 +1070,13 @@ struct vfio_device_feature_mig_state {
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
@@ -1094,11 +1103,16 @@ struct vfio_device_feature_mig_state {
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
@@ -1128,6 +1142,18 @@ struct vfio_device_feature_mig_state {
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
@@ -1140,6 +1166,11 @@ struct vfio_device_feature_mig_state {
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
@@ -1147,6 +1178,7 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING = 2,
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
+	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 };
 
 /* -------- API for Type1 VFIO IOMMU -------- */
-- 
2.18.1

