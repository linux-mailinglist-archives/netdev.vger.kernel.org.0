Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DE54A37B0
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355583AbiA3QQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:16:08 -0500
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:26313
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355660AbiA3QPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrbKJSGBw0CEWZEaV/vSaM5ht4y45+q9yRp5jnNZkdCIsNlrWujAQBnMOr+NcyRgOGToCnVlvjpglmXHxPUdzxK9+OuTYLhhsAIsZVIfAA/rJRONLRNZUNM13LXYuCLGNizSqUy+JgfssQbx8v8ggnuGhUAVFjAPshzMnVfk48Ggbv3uKwoHAXDZvrKcpnGhMqq0v35XolrkSOiKr4fPuTb7BbnBqC7bSkuMIHGhAf6PYFN/MWEV4FpyX2pWh5BYYA9XNasiw9yzkF5UlrCFY1dL3mDMc5b1hmNu+tLaGtuJNm3Q8VMgg/YWHEbzhpyM5Aqz2txolE/4PIM9p/qd6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unpx6+jsgTDmdJ0DjrKqzE90zLcLIRnRBxbjP7Kq+Iw=;
 b=Yup7DNxBRtO1iGtTHT3Yw1p+JRyRX5CAUaDvBwAMM3rhfmJH4G75NdaDnyNVVly1bk3M0PnCh0fnw3WtM5PEGCu27rZPbrtYFVG/xeyhi9TkP+MUHWP3Xih3PA/mD3pupXttBV57bwmeSSAsgcnLWVR02iQPiG2BASCMIsRpka5VwHqhV93e+42zChTLZo/eHuEUOShxYaPO+yvKA2mWtacmWxzyWhH2cCMNtn7WwFCy+f0kHaEznuWwdeGxrrg1yo6U+AJiefAnx0WqicS2umBDc9qG2ZiRZ+PjyFdF//Q7T0nTqjQ9nNz2UgRXxPl9wvFFw7SFqlA2g75TheANZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unpx6+jsgTDmdJ0DjrKqzE90zLcLIRnRBxbjP7Kq+Iw=;
 b=QgJY8ZrgErLRHvLrsLG+ps7DGlujm286AjTCRbyGqpX/yldLCjSZG2Su+6hgVuwPXaHh/I0Gyl+pFUyvD1QG1diI90JUOzB2QUdxHZb1pcfBxOEJc4XwQ+LjHEAQ/9jTTdqCi23p27vAn3suPtJy+GlmG8lu+fhQVZaQRWIMfekMqTsER24y0Gnv75ylRwBWllRt7wPi+4qC4+YVKPB8sDCuH30nBwPSapQL/VVvK6cZeUAM2DzuWm//BrUhoIHjDMAR5loewq32sg6ButzIZQqsfktEFadi/oFW7VR7vF129+wpL8jk2pDed9tqw3oGa4bUXr18ttgiG95BejnVTQ==
Received: from BN9PR03CA0469.namprd03.prod.outlook.com (2603:10b6:408:139::24)
 by BY5PR12MB3924.namprd12.prod.outlook.com (2603:10b6:a03:1af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sun, 30 Jan
 2022 16:15:39 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::a2) by BN9PR03CA0469.outlook.office365.com
 (2603:10b6:408:139::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:37 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:34 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 15/15] vfio: Extend the device migration protocol with PRE_COPY
Date:   Sun, 30 Jan 2022 18:08:26 +0200
Message-ID: <20220130160826.32449-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1534a40e-683b-4d14-4c3e-08d9e40bc176
X-MS-TrafficTypeDiagnostic: BY5PR12MB3924:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB39241FA4B766215DF6E6AA64C3249@BY5PR12MB3924.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12s43bHq5CUdnh6zVV1MBoiU7UXgZCBWSSMJiKthteZ5Rtq9nOJDvJ0tM6rjdtIIvPpUNM0f/0T6J+l4MtFIXVd4BLmbbv1s/jhDa4gjWOem4RsJLo1Qx3KqBOyzQwPG826wyCigmX6mcwYQqao+Q6Gj+u+ZqtQykZCR5qpplBujHl3ULhHVQNuRTe6NVQ8PV4rh2sawI7tTfqOF5/48ebF74sHvf1OFhH1RO2llG3XGKQGlT7jK4fsH94FAxfZTM+6s9q4Raz42sTU4z5RNSrJgJ4rNIPUrKtp1nVoiV7ILTKN48Vy1l8mkeRaQV6webD5MCmQKakbsFkheay9ZQUcPOZw54ukguQD4FaSiwdYmQOxOXkdc7Jit5SipSbMrsyG2VHCJSQGSwnzwZhPFtWRDlnd6fcivQZqMzrNzsN5zsvHt1W9dgrT1awe7F3a140bkoq3qKrUxi7uMbtiBIfNoJkZ5ZGV8NxJrvmRGypxttATnpHR5PmurneZvIAWEjJTtE+pJf5NXsHtgw2cN5cuEDoNZnB5Y/WKO6vk2NP2zuLE5LsQGu+mYUtEWpzTV9Uoht1zM8zE1gECcd/HHcsXr8oL94DbSpcZ+ckVNtT8bp/hYjrL3lrgOglUEfrY5tvQ3/vjvICvTBbd7a6yZIubC1zgjwdFUOQFjCjl1+Sq1payFBuLZnlvDD/PiU2LyR/Ty3yzpiuhMf6yUU1t6Zg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(1076003)(26005)(36860700001)(107886003)(186003)(336012)(2616005)(86362001)(82310400004)(40460700003)(83380400001)(5660300002)(30864003)(47076005)(36756003)(70586007)(70206006)(4326008)(356005)(81166007)(8936002)(8676002)(508600001)(2906002)(6666004)(7696005)(54906003)(110136005)(316002)(6636002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:38.8664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1534a40e-683b-4d14-4c3e-08d9e40bc176
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3924
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The optional PRE_COPY states open the saving data transfer FD before
reaching STOP_COPY and allows the device to dirty track internal state
changes with the general idea to reduce the volume of data transferred
in the STOP_COPY stage.

While in PRE_COPY the device remains RUNNING, but the saving FD is open.

Only if the device also supports RUNNING_P2P can it support PRE_COPY_P2P,
which halts P2P transfers while continuing the saving FD.

PRE_COPY, with P2P support, requires the driver to implement 7 new arcs
and exists as an optional FSM branch between RUNNING and STOP_COPY:
    RUNNING -> PRE_COPY -> PRE_COPY_P2P -> STOP_COPY

A new ioctl VFIO_DEVICE_MIG_PRECOPY is provided to allow userspace to
query the progress of the precopy operation in the driver with the idea it
will judge to move to STOP_COPY at least once the initial data set is
transferred, and possibly after the dirty size has shrunk appropriately.

We think there may also be merit in future extensions to the
VFIO_DEVICE_MIG_PRECOPY ioctl to also command the device to throttle the
rate it generates internal dirty state.

Compared to the v1 clarification, STOP_COPY -> PRE_COPY is made optional
and to be defined in future. While making the whole PRE_COPY feature
optional eliminates the concern from mlx5, this is still a complicated arc
to implement and seems prudent to leave it closed until a proper use case
is developed. We also split the pending_bytes report into the initial and
sustaining values, and define the protocol to get an event via poll() for
new dirty data during PRE_COPY.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/vfio.c       |  84 +++++++++++++++++++++++++++--
 include/linux/vfio.h      |   1 -
 include/uapi/linux/vfio.h | 110 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 187 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a722a1a8a48a..264daffedb09 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1573,7 +1573,7 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state cur_fsm,
 			    enum vfio_device_mig_state new_fsm)
 {
-	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
+	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_PRE_COPY_P2P + 1 };
 	/*
 	 * The coding in this table requires the driver to implement
 	 * FSM arcs:
@@ -1592,25 +1592,59 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 	 *         RUNNING -> STOP
 	 *         STOP -> RUNNING
 	 *
+	 * If precopy is supported then the driver must support these additional
+	 * FSM arcs:
+	 *         RUNNING -> PRE_COPY
+	 *         PRE_COPY -> RUNNING
+	 *         PRE_COPY -> STOP_COPY
+	 * However, if precopy and P2P are supported together then the driver
+	 * must support these additional arcs beyond the P2P arcs above:
+	 *         PRE_COPY -> RUNNING
+	 *         PRE_COPY -> PRE_COPY_P2P
+	 *         PRE_COPY_P2P -> PRE_COPY
+	 *         PRE_COPY_P2P -> RUNNING_P2P
+	 *         PRE_COPY_P2P -> STOP_COPY
+	 *         RUNNING -> PRE_COPY
+	 *         RUNNING_P2P -> PRE_COPY_P2P
+	 *
 	 * If all optional features are supported then the coding will step
 	 * through multiple states for these combination transitions:
+	 *         PRE_COPY -> PRE_COPY_P2P -> STOP_COPY
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP -> RESUMING
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> RUNNING
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> STOP
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> STOP -> RESUMING
 	 *         RESUMING -> STOP -> RUNNING_P2P
+	 *         RESUMING -> STOP -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING
+	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         RESUMING -> STOP -> STOP_COPY
+	 *         RUNNING -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         RUNNING -> RUNNING_P2P -> STOP
 	 *         RUNNING -> RUNNING_P2P -> STOP -> RESUMING
 	 *         RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
+	 *         RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         RUNNING_P2P -> STOP -> RESUMING
 	 *         RUNNING_P2P -> STOP -> STOP_COPY
+	 *         STOP -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         STOP -> RUNNING_P2P -> RUNNING
+	 *         STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         STOP_COPY -> STOP -> RESUMING
 	 *         STOP_COPY -> STOP -> RUNNING_P2P
 	 *         STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
+	 *
+	 *  The following transitions are blocked:
+	 *         STOP_COPY -> PRE_COPY
+	 *         STOP_COPY -> PRE_COPY_P2P
 	 */
 	static const u8 vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STATES] = {
 		[VFIO_DEVICE_STATE_STOP] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
@@ -1619,14 +1653,38 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RUNNING] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
+		[VFIO_DEVICE_STATE_PRE_COPY] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_PRE_COPY_P2P] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
 		[VFIO_DEVICE_STATE_STOP_COPY] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
@@ -1635,6 +1693,8 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RESUMING] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
@@ -1643,6 +1703,8 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RUNNING_P2P] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
@@ -1651,6 +1713,8 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_ERROR] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
@@ -1658,18 +1722,32 @@ u32 vfio_mig_get_next_state(struct vfio_device *device,
 		},
 	};
 	bool have_p2p = device->migration_flags & VFIO_MIGRATION_P2P;
+	bool have_pre_copy = device->migration_flags & VFIO_MIGRATION_PRE_COPY;
 
 	if (cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table) ||
 	    new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
 		return VFIO_DEVICE_STATE_ERROR;
 
 	if (!have_p2p && (new_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
-			  cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P))
+			  new_fsm == VFIO_DEVICE_STATE_PRE_COPY_P2P ||
+			  cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
+			  cur_fsm == VFIO_DEVICE_STATE_PRE_COPY_P2P))
+		return VFIO_DEVICE_STATE_ERROR;
+
+	/*
+	 * PRE_COPY states do not appear as an interior next state, so rejecting
+	 * them here is sufficient.
+	 */
+	if (!have_pre_copy && (new_fsm == VFIO_DEVICE_STATE_PRE_COPY ||
+			       new_fsm == VFIO_DEVICE_STATE_PRE_COPY_P2P ||
+			       cur_fsm == VFIO_DEVICE_STATE_PRE_COPY ||
+			       cur_fsm == VFIO_DEVICE_STATE_PRE_COPY_P2P))
 		return VFIO_DEVICE_STATE_ERROR;
 
 	cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
 	if (!have_p2p) {
-		while (cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P)
+		while (cur_fsm == VFIO_DEVICE_STATE_RUNNING_P2P ||
+		       cur_fsm == VFIO_DEVICE_STATE_PRE_COPY_P2P)
 			cur_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
 	}
 	return cur_fsm;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 69a574ba085e..f853a3539b8b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -45,7 +45,6 @@ struct vfio_device {
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
- * @flags: Global flags from enum vfio_device_ops_flags
  * @open_device: Called when the first file descriptor is opened for this device
  * @close_device: Opposite of open_device
  * @read: Perform read(2) on device file descriptor
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 70c77da5812d..7837fe2ca8de 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -785,12 +785,20 @@ struct vfio_device_feature {
  * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
  * is supported in addition to the STOP_COPY states.
  *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY means that
+ * PRE_COPY is supported in addition to the STOP_COPY states.
+ *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY
+ * means that RUNNING_P2P, PRE_COPY and PRE_COPY_P2P are supported
+ * in addition to the STOP_COPY states.
+ *
  * Other combinations of flags have behavior to be defined in the future.
  */
 struct vfio_device_feature_migration {
 	__aligned_u64 flags;
 #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
 #define VFIO_MIGRATION_P2P		(1 << 1)
+#define VFIO_MIGRATION_PRE_COPY		(1 << 2)
 };
 #define VFIO_DEVICE_FEATURE_MIGRATION 1
 
@@ -807,8 +815,13 @@ struct vfio_device_feature_migration {
  *  RESUMING - The device is stopped and is loading a new internal state
  *  ERROR - The device has failed and must be reset
  *
- * And 1 optional state to support VFIO_MIGRATION_P2P:
+ * And optional states to support VFIO_MIGRATION_P2P:
  *  RUNNING_P2P - RUNNING, except the device cannot do peer to peer DMA
+ * And VFIO_MIGRATION_PRE_COPY:
+ *  PRE_COPY - The device is running normally but tracking internal state
+ *             changes
+ * And VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY:
+ *  PRE_COPY_P2P - PRE_COPY, except the device cannot do peer to peer DMA
  *
  * The FSM takes actions on the arcs between FSM states. The driver implements
  * the following behavior for the FSM arcs:
@@ -840,20 +853,48 @@ struct vfio_device_feature_migration {
  *
  *   To abort a RESUMING session the device must be reset.
  *
+ * PRE_COPY -> RUNNING
  * RUNNING_P2P -> RUNNING
  *   While in RUNNING the device is fully operational, the device may generate
  *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
  *   and the device may advance its internal state.
  *
+ *   The PRE_COPY arc will terminate a data transfer session.
+ *
+ * PRE_COPY_P2P -> RUNNING_P2P
  * RUNNING -> RUNNING_P2P
  * STOP -> RUNNING_P2P
  *   While in RUNNING_P2P the device is partially running in the P2P quiescent
  *   state defined below.
  *
+ *   The PRE_COPY arc will terminate a data transfer session.
+ *
+ * RUNNING -> PRE_COPY
+ * RUNNING_P2P -> PRE_COPY_P2P
  * STOP -> STOP_COPY
- *   This arc begin the process of saving the device state and will return a
- *   new data_fd.
+ *   PRE_COPY, PRE_COPY_P2P and STOP_COPY form the "saving group" of states
+ *   which share a data transfer session. Moving between these states alters
+ *   what is streamed in session, but does not terminate or otherwise effect
+ *   the associated fd.
+ *
+ *   These arcs begin the process of saving the device state and will return a
+ *   new data_fd. The migration driver may perform actions such as enabling
+ *   dirty logging of device state when entering PRE_COPY or PER_COPY_P2P.
+ *
+ *   Each arc does not change the device operation, the device remains
+ *   RUNNING, P2P quiesced or in STOP. The STOP_COPY state is described below
+ *   in PRE_COPY_P2P -> STOP_COPY.
+ *
+ * PRE_COPY -> PRE_COPY_P2P
+ *   Entering PRE_COPY_P2P continues all the behaviors of PRE_COPY above.
+ *   However, while in the PRE_COPY_P2P state, the device is partially running
+ *   in the P2P quiescent state defined below, like RUNNING_P2P.
  *
+ * PRE_COPY_P2P -> PRE_COPY
+ *   This arc allows returning the device to a full RUNNING behavior while
+ *   continuing all the behaviors of PRE_COPY.
+ *
+ * PRE_COPY_P2P -> STOP_COPY
  *   While in the STOP_COPY state the device has the same behavior as STOP
  *   with the addition that the data transfers session continues to stream the
  *   migration state. End of stream on the FD indicates the entire device
@@ -871,6 +912,13 @@ struct vfio_device_feature_migration {
  *   internal device state for this arc if required to prepare the device to
  *   receive the migration data.
  *
+ * STOP_COPY -> PRE_COPY
+ * STOP_COPY -> PRE_COPY_P2P
+ *   These arcs are not permitted and return error if requested. Future
+ *   revisions of this API may define behaviors for these arcs, in this case
+ *   support will be discoverable by a new flag in
+ *   VFIO_DEVICE_FEATURE_MIGRATION.
+ *
  * any -> ERROR
  *   ERROR cannot be specified as a device state, however any transition request
  *   can be failed with an errno return and may then move the device_state into
@@ -883,7 +931,7 @@ struct vfio_device_feature_migration {
  * The optional peer to peer (P2P) quiescent state is intended to be a quiescent
  * state for the device for the purposes of managing multiple devices within a
  * user context where peer-to-peer DMA between devices may be active. The
- * RUNNING_P2P states must prevent the device from initiating
+ * RUNNING_P2P and PRE_COPY_P2P states must prevent the device from initiating
  * any new P2P DMA transactions. If the device can identify P2P transactions
  * then it can stop only P2P DMA, otherwise it must stop all DMA. The migration
  * driver must complete any such outstanding operations prior to completing the
@@ -894,6 +942,8 @@ struct vfio_device_feature_migration {
  * above FSM arcs. As there are multiple paths through the FSM arcs the path
  * should be selected based on the following rules:
  *   - Select the shortest path.
+ *   - The path cannot have saving group states as interior arcs, only
+ *     starting/end states.
  * Refer to vfio_mig_get_next_state() for the result of the algorithm.
  *
  * The automatic transit through the FSM arcs that make up the combination
@@ -907,6 +957,9 @@ struct vfio_device_feature_migration {
  * support them. The user can disocver if these states are supported by using
  * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
  * avoid knowing about these optional states if the kernel driver supports them.
+ *
+ * Arcs touching PRE_COPY and PRE_COPY_P2P are removed if support for PRE_COPY
+ * is not present.
  */
 enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_ERROR = 0,
@@ -915,6 +968,8 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
+	VFIO_DEVICE_STATE_PRE_COPY = 6,
+	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
 };
 
 /**
@@ -960,6 +1015,53 @@ struct vfio_device_mig_set_state {
 
 #define VFIO_DEVICE_MIG_SET_STATE _IO(VFIO_TYPE, VFIO_BASE + 21)
 
+/**
+ * VFIO_DEVICE_MIG_PRECOPY - _IO(VFIO_TYPE, VFIO_BASE + 22)
+ *
+ * This ioctl is used in the precopy phase of the migration data transfer. It
+ * returns an estimate of the current data sizes remaining to be transferred.
+ * It allows the user to judge when it is appropriate to leave PRE_COPY for
+ * STOP_COPY.
+ *
+ * initial_bytes reflects the estimated remaining size of any initial mandatory
+ * precopy data transfer. When initial_bytes returns as zero then the initial
+ * phase of the precopy data is completed. Generally initial_bytes should start
+ * out as approximately the entire device state.
+ *
+ * dirty_bytes reflects an estimate for how much more data needs to be
+ * transferred to complete the migration. Generally it should start as zero
+ * and increase as internal state is dirtied.
+ *
+ * Drivers should attempt to return estimates so that initial_bytes +
+ * dirty_bytes matches the amount of data an immediate transition to STOP_COPY
+ * will require to be streamed.
+ *
+ * Drivers have alot of flexability in when and what they transfer during the
+ * PRE_COPY phase, and how they report this from VFIO_DEVICE_MIG_PRECOPY.
+ *
+ * During pre-copy the migration data FD has a temporary "end of stream" that is
+ * reached when both initial_bytes and dirty_byte are zero. For instance, this
+ * may indicate that the device is idle and not currently dirtying any internal
+ * state. When read() is done on this temporary end of stream the kernel driver
+ * should return ENOMSG from read(). Userspace can wait for more data (which may
+ * never come) by using poll.
+ *
+ * Once in STOP_COPY the migration data FD has a permanent end of stream
+ * signaled in the usual way by read() always returning 0 and poll always
+ * returning readable. ENOMSG may not be returned in STOP_COPY. Support
+ * for this ioctl is optional.
+ *
+ * Return: 0 on success, -1 and errno set on failure.
+ */
+struct vfio_device_mig_precopy {
+	__u32 argsz;
+	__u32 flags;
+	__aligned_u64 initial_bytes;
+	__aligned_u64 dirty_bytes;
+};
+
+#define VFIO_DEVICE_MIG_PRECOPY _IO(VFIO_TYPE, VFIO_BASE + 22)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

