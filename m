Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26C05A7E40
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiHaNG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiHaNG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:06:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44320C0BFE
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:06:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuKHtt69gJoMwE8kOZjiSriKRB4B09/uBtlZJnx863MHs9IPT19K5r2EKx51qj87b6OEH55/yy0MAyAHqX0xQ2xxlWbhZbbELUNbnX7rqhmdPnH4AT5YCG0Utnm0d7gm+5HogcK1ZVPGFMfoimgF2P0nI4g1zk3tkOseebLM2DpEVRksCw1QhTPC1gMMXlbh01k6mOu42nIxeF7yrdqPDmk/swwtc7x1bmfpIc4T9nejYQXbsd/mTQjE8Hi5Sk4EJkwCGOpwMp/IvK8Xcm9dyPspcgWa0VQCn5LmLRuGzEzOtJRVHjy7vkW0LtcEoTMZsuDAf1a0EeksJCh/8/9Avg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVyYOB8Nwv/PUgeW/i+ExqJkY5cY6cayeLY3HJ6nInw=;
 b=mLyWWWx85x9ViaHa0VhxG/FQOIVceAz5Om7m74LZworJ1NoEaoyJ1M+rQi2+H4iIhVSQiQvAIxfhcdjo9wbdLmrRoikaZvME2zNVC0ZxEvA43lrPq5yaTqnYYCyWANj8HCDtjPhw+q7zCwfuD0QvRu1o08NG8V5WCE6tWx7D3HIZ+VZxuDvid2ZEeL6ZpyjX6/QeLlUMYfZk13NCuRQRgHiGu+Fz01sNHOX43+dRxqBIFkTfiXOncdF2ESaLAi2b54Zaah7+uJCEOMovFnaU/JzUIhCNSv9XX5ucQzOxPVEM66m8YUMPnLRs0ZyJCb0rsAZLo0HFkVfK0aAGAryBXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVyYOB8Nwv/PUgeW/i+ExqJkY5cY6cayeLY3HJ6nInw=;
 b=XCV0VfKwF0gKGZexrAxfAuGFn0Wu3LbNbfe/CEQMhmq/u/MIfVRMRsxikfpzmdS+epcCzWnr9nBUzjAEkBZha4moPWl4qwKv4cipHLh0NEe/hvizf8PgFWXYYORR1wf+ZfK6zZgIAlXl6MzPD9cMLp9Rb0Za6k9n/MX09qd3NyMwA0TGVJhAPrlIpeD/J/iRkTT7l0Vf0LZ8EWFbO3CH9mJV+TOqtpDcUn60Gf8BtWAYm1ENOOJPEqrrNQqallED3uRrQ52hY8qQ9j28W3MH1yEKLGipSy+s+2HLQjeuipLhBEfxlh6tTn1UDbKX33XkKD/Fe/w9gMwM3wvGyrdMhA==
Received: from MW4PR04CA0140.namprd04.prod.outlook.com (2603:10b6:303:84::25)
 by CH3PR12MB7617.namprd12.prod.outlook.com (2603:10b6:610:140::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 13:06:21 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::a0) by MW4PR04CA0140.outlook.office365.com
 (2603:10b6:303:84::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Wed, 31 Aug 2022 13:06:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Wed, 31 Aug 2022 13:06:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 31 Aug
 2022 13:06:04 +0000
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 06:05:59 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH RESEND v4 1/2] virtio-net: introduce and use helper function for guest gso support checks
Date:   Wed, 31 Aug 2022 16:05:40 +0300
Message-ID: <20220831130541.81217-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831130541.81217-1-gavinl@nvidia.com>
References: <20220831130541.81217-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11043b49-c09c-4dc1-f33f-08da8b519950
X-MS-TrafficTypeDiagnostic: CH3PR12MB7617:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ustzqu4xYgcMn7MvXQfRFeAT/g8lmggHzCfd+UQdqUn62GrUlxh4zUnmDU3/2vB/0fFb20zVGVDhVltggB9dM2hr3PLCKfAK1KP67cj52+NEhPvPsMrgcOnICPKmoz3+DQNuYpxvAf3QXFQSx+VI+yPcYipFKyQrdsv0+ceeuWvFHyAnXGXSTgSTBRJA1F/tmX8SVjArLh1ayER4dU6VTGVslowxeEYQsLz69IBbafScvmMn6arq1eNZBJzZAYlpd5TdMR9hhADqpLm3fNamaW8Du2YWqXnzLMs92a4cg76ySCv7zm3D9nZBBHom+ED11jAWgbrCJINjX11hReZB7m5W+4YhstKuvaw97jtlvqCzty4/rVTHJDxkfHC9z7i0aLILy8bc1AnT1YFFOihsyun4PA+EWVQnDwxyuQcgmNbE1GUH+Qs3dfQozmOjkmOcO0QkvSElyXWTNJk5dGO5V8Cy3qkKz1mQXtHRqcyYRaWiR+IOw22H430EbBtUnH7gj1iei8SPpKtSemNFjGzx9wra6Y/GMP94gDddBc30IPxu8zeDuHyTFnACaeI6SZqPW7w2xtkqhifsoXihVxxD71BtO1JeX4DGlDiRZWON5nNaPPkZNkFXFBYe2XR7T49Xn9F8rBOl6DByWGsVom22YHjYZuSDW02S10TsC3bnK4RSekARChM9pvnD4LI1UG7Dadsw8+3hSbUxyzPSgXpenRwb5XSoFeQdpwMmnkuo0d5/W5pA8koz26LGx974c32FNMe32EVHMtIS56EprLzRj04PDrXrsAQ5mRS8x9IZ41lZkepurSRfHUNLnEfXS3Xg
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(40470700004)(46966006)(36840700001)(82740400003)(86362001)(316002)(70586007)(4326008)(70206006)(8676002)(36860700001)(36756003)(356005)(81166007)(921005)(83380400001)(16526019)(6666004)(26005)(41300700001)(478600001)(7696005)(186003)(6286002)(40480700001)(7416002)(82310400005)(110136005)(55016003)(40460700003)(54906003)(336012)(1076003)(2616005)(426003)(47076005)(5660300002)(2906002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 13:06:20.6083
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11043b49-c09c-4dc1-f33f-08da8b519950
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7617
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probe routine is already several hundred lines.
Use helper function for guest gso support check.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
changelog:
v1->v2
- Add new patch
---
 drivers/net/virtio_net.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9cce7dec7366..e1904877d461 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
 	return 0;
 }
 
+static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
+{
+	return (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int i, err = -ENOMEM;
@@ -3777,10 +3785,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	spin_lock_init(&vi->refill_lock);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
+	if (virtnet_check_guest_gso(vi))
 		vi->big_packets = true;
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
-- 
2.31.1

