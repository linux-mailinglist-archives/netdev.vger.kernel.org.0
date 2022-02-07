Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10BE4AC74E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358372AbiBGR1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiBGRYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:24:16 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63B3C0401D6;
        Mon,  7 Feb 2022 09:24:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ri2SqwS0QyXGUNyBvUbESwki6qK4kR8CD6W2soV72UyI7zs52ho54dAgfgFZnqaqXUaI177r97IZhswYi0tpPKjkzizUgDZSkbru0hRFXSH6oGNXLc5PybR4TvlL7i16QLT9E2wdcDyrz55wHhPUiFTrW9vspqpniGqy64UbMe3DdVLq9baoKYhfv6jloddd173KLKDmcTCGVqZ9l3jaDbyzxvA4KbsfIFGeW0Fm1yOVM2RnpvWChoW1y0979tAmWkP2HSJLl3dEdHckNiGEkygLoYZkJtKBeyuSrH8+OsEbTs6jr34NVhP2AnUT3sOOMGza9lpGc1BiATqdxVcS0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GILwQh9UN0e/szg6YBtlkdheha+GiHOw3hifeuWppxo=;
 b=MpWuETOaWu5dMbFJLbMCN1U6hJZ6ZS+v3IViNqtN0j72/KtV0cKan21hxr5yTkkktoTwNi4BMYBnXWxov4iDD0XUnwmRoghSEAx6g5hUqSl20RN5ZY2JyBfUit7gtNmDdxIrboYyr82hyunjMJxjABA+KWqp2/nCEKQXVHcgvB7wx7AVpRDAfPiPCj/mT6qR0lGboYf6GZYudaZ0c6HdlbY8QmbHuvbk/bQ1xm9SMlwmfrpLGpG2imeReL6pWQeZsK3F37q37d28yEekOBxDrcy2hO9voODzMiXcQ5sqPCwRRbU3RQ27sZxHmi38+9nMr5YqPRZ2vcoEVnTVEq7fSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GILwQh9UN0e/szg6YBtlkdheha+GiHOw3hifeuWppxo=;
 b=qznB4b+e6w2UK+LLMzL8LAeHnkOWiF53+7122nuXwtpMPOgl+2paMt3PGNd63+bv+TJ1kBINlVbHodjE6t2A5utty6tkVtm39C0sZvwMmzdwehfk862s+hGtL8mzriqobnUZnMnYk2qwgZ+kSd/PdaBNVC/hj5ZvCWcMYxKFtSBpaiRWRYe+LAc4nEB3B3dLo0Ha1CprEvsvD6WWBRQ0GLp72o7YYxSCQjuEXBhslcOuAqKuoXpXb9clpquvuWHh6TFphymmFvmcOk7nypSSnFw2yNBpYqOwRjTZm+sHler2f5Cv1njzhnJDcrZ+JMC2ntHxsPjyODMUdRRr7C8CoA==
Received: from DM6PR18CA0018.namprd18.prod.outlook.com (2603:10b6:5:15b::31)
 by PH0PR12MB5404.namprd12.prod.outlook.com (2603:10b6:510:d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 17:24:12 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::39) by DM6PR18CA0018.outlook.office365.com
 (2603:10b6:5:15b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18 via Frontend
 Transport; Mon, 7 Feb 2022 17:24:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:24:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:24:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:24:10 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:24:06 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration protocol with PRE_COPY
Date:   Mon, 7 Feb 2022 19:22:16 +0200
Message-ID: <20220207172216.206415-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae5f6f05-6355-4e80-074b-08d9ea5ea85a
X-MS-TrafficTypeDiagnostic: PH0PR12MB5404:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5404B64A5C6C5C77BAACD766C32C9@PH0PR12MB5404.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ti9hxLEAjThqMkEFkHEpzSyL4bXgLwWktPmX1xrOJrSdSCeb6xKJh2DREPw/FEUiF4enMYzNreDX7kmtmo2PiouBCB8klDNvu9eOqIcJ0kvk5WbSP8faQY32TG8PgSd3XNCsBLM5Wz2kxehvqxHskU3JsBF5GQLreBlHer9A10ODvmgHcUCqdFF+7+eXYdakne1APXbf8Pt+SfOEgDkRA3miKMjHbf0yhOhuEKXSdXsA1wBjRLYwdb0aBEZvJrNOoxS2HE6bQEJeEtgcVJHFQ7kr9Xvm2A2LQccpztEPqQ90fby9YokQR+++tCkm5pvLADI+NPO8BEc7nZoVlzMTOWSQJbOlVHV2oLgr8hDFcr9P+c92HSVaJd8aby0vphC1GmhxG8h44DRjNWTHxMN1SKLxOtNC8/mqe2iSEq8yy+twjlB1pSp+ZIUfBlppujL7p5GaI7a8YM5/rzfVUTJGRv1VNXoABipvKwqBxkUSEVGH9MQIPWkE59O+hVFBKEg6BtjEeHn/jpZJ87GrSIK4qxHiiL60oXizhklAmOzWmtJoNNp3QwSES6I6S76F8zv+PYTMSoQ6dFjSBpIJ+TKLfIxcO19/at+Y9qR1o/6MxxqljSHSC0M7ZUvWCo491BoUjXtd5r92xaVRavBP5AJ1EGZ2/yTqzpokzGdFlaTuOHRGDJ/WEB1qdUhm5oNgupjH3kJgeiQz40/QRCZmNs01Fg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(186003)(1076003)(26005)(36860700001)(336012)(426003)(356005)(86362001)(82310400004)(83380400001)(81166007)(47076005)(40460700003)(4326008)(36756003)(8676002)(110136005)(6636002)(316002)(54906003)(70586007)(8936002)(30864003)(5660300002)(6666004)(7696005)(508600001)(70206006)(2906002)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:24:12.0215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5f6f05-6355-4e80-074b-08d9ea5ea85a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5404
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
 drivers/vfio/vfio.c       |  71 +++++++++++++++++++++++-
 include/uapi/linux/vfio.h | 110 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 176 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 8c484593dfe0..b4c585114ef3 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1577,7 +1577,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state new_fsm,
 			    enum vfio_device_mig_state *next_fsm)
 {
-	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
+	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_PRE_COPY_P2P + 1 };
 	/*
 	 * The coding in this table requires the driver to implement
 	 * FSM arcs:
@@ -1596,25 +1596,59 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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
@@ -1623,14 +1657,38 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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
@@ -1639,6 +1697,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RESUMING] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
@@ -1647,6 +1707,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RUNNING_P2P] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
@@ -1655,6 +1717,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_ERROR] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
@@ -1665,6 +1729,11 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 	static const unsigned int state_flags_table[VFIO_DEVICE_NUM_STATES] = {
 		[VFIO_DEVICE_STATE_STOP] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RUNNING] = VFIO_MIGRATION_STOP_COPY,
+		[VFIO_DEVICE_STATE_PRE_COPY] =
+			VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY,
+		[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_MIGRATION_STOP_COPY |
+						   VFIO_MIGRATION_P2P |
+						   VFIO_MIGRATION_PRE_COPY,
 		[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RESUMING] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RUNNING_P2P] =
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 227f55d57e06..6424c5b3415b 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -817,12 +817,20 @@ struct vfio_device_feature {
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
 
@@ -873,8 +881,13 @@ struct vfio_device_feature_mig_state {
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
@@ -906,20 +919,48 @@ struct vfio_device_feature_mig_state {
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
  *
+ *   Each arc does not change the device operation, the device remains
+ *   RUNNING, P2P quiesced or in STOP. The STOP_COPY state is described below
+ *   in PRE_COPY_P2P -> STOP_COPY.
+ *
+ * PRE_COPY -> PRE_COPY_P2P
+ *   Entering PRE_COPY_P2P continues all the behaviors of PRE_COPY above.
+ *   However, while in the PRE_COPY_P2P state, the device is partially running
+ *   in the P2P quiescent state defined below, like RUNNING_P2P.
+ *
+ * PRE_COPY_P2P -> PRE_COPY
+ *   This arc allows returning the device to a full RUNNING behavior while
+ *   continuing all the behaviors of PRE_COPY.
+ *
+ * PRE_COPY_P2P -> STOP_COPY
  *   While in the STOP_COPY state the device has the same behavior as STOP
  *   with the addition that the data transfers session continues to stream the
  *   migration state. End of stream on the FD indicates the entire device
@@ -937,6 +978,13 @@ struct vfio_device_feature_mig_state {
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
@@ -948,7 +996,7 @@ struct vfio_device_feature_mig_state {
  * The optional peer to peer (P2P) quiescent state is intended to be a quiescent
  * state for the device for the purposes of managing multiple devices within a
  * user context where peer-to-peer DMA between devices may be active. The
- * RUNNING_P2P states must prevent the device from initiating
+ * RUNNING_P2P and PRE_COPY_P2P states must prevent the device from initiating
  * any new P2P DMA transactions. If the device can identify P2P transactions
  * then it can stop only P2P DMA, otherwise it must stop all DMA. The migration
  * driver must complete any such outstanding operations prior to completing the
@@ -959,6 +1007,8 @@ struct vfio_device_feature_mig_state {
  * above FSM arcs. As there are multiple paths through the FSM arcs the path
  * should be selected based on the following rules:
  *   - Select the shortest path.
+ *   - The path cannot have saving group states as interior arcs, only
+ *     starting/end states.
  * Refer to vfio_mig_get_next_state() for the result of the algorithm.
  *
  * The automatic transit through the FSM arcs that make up the combination
@@ -972,6 +1022,9 @@ struct vfio_device_feature_mig_state {
  * support them. The user can disocver if these states are supported by using
  * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
  * avoid knowing about these optional states if the kernel driver supports them.
+ *
+ * Arcs touching PRE_COPY and PRE_COPY_P2P are removed if support for PRE_COPY
+ * is not present.
  */
 enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_ERROR = 0,
@@ -980,8 +1033,57 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
+	VFIO_DEVICE_STATE_PRE_COPY = 6,
+	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
+};
+
+/**
+ * VFIO_DEVICE_MIG_PRECOPY - _IO(VFIO_TYPE, VFIO_BASE + 21)
+ *
+ * This ioctl is used on the migration data FD in the precopy phase of the
+ * migration data transfer. It returns an estimate of the current data sizes
+ * remaining to be transferred. It allows the user to judge when it is
+ * appropriate to leave PRE_COPY for STOP_COPY.
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
+ * Drivers have alot of flexibility in when and what they transfer during the
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
 };
 
+#define VFIO_DEVICE_MIG_PRECOPY _IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

