Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF435A8B3F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiIACLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIACLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:11:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8127E5896
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeFKuFCLkK7TSVu0uflLDmZuKcmzZPA8Vz1O6N6Bf7RVtVL8Oh7LqHfxYGaFOQ9Il8qRjqMgSr+9oxW7eUiYHR8GkLhmXbNSumE8qK0RjRRSIY6m8/Nu1t1/PNTDmOJJbPEzLhQFMy4wmgR20nhuBwNUNZQeBYBwzYgptSnHraoCDMGP4CtYTXs9HTIOtVYxHmmBD/+qLCWz0Jue33JGjf98h+pbZJEAsOca8fppnAzdhXaUSdGkU00pHBSwLyBqkAcp/QcZLSymqkzwGDkJvM3xwcKj3JKPC3R3T36afv81fk4TZ+RbMMnP6+6WDVTza5LUVCixbZVVmMZk2Axm6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMOUzPfKv3VELT2r/SkGvAgqOKneZeF/B2L5oftkaPw=;
 b=NP3RuCXvmyNzQkb7nGejgAsWq9etjSZVeUz7Odipp3IMzpM1z8SCFh+HgtAlRSXsUFJyW+MMfE7ChjA7NBuUO4tmGjevm7YLaIP0KjLYkeTaCu1jl7cmCAB65ApzRuMKKVUiClv8F0QyyVGms9LWAMTs2D7eKLZQ3l6qmpqCKdt1vTNqQtuiH8yatywMIVzqKx+o+bqT3a2QbzxTrZIhgo9zOhwWjPmPLSbbFB1RhIR2/4VPj+6dVUscrQdgj4wEGhtPEGflCsVvXvF1/g6orfxwN6bmuSVNbFrAa1Hb59u1lX+8Xe/ow1tOZHQh8iPQYAtz0Sj6GtsDh6gq22KO4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMOUzPfKv3VELT2r/SkGvAgqOKneZeF/B2L5oftkaPw=;
 b=jQT82ujx8oWkNRJz+e33BeSddc54p0W3IUbSnsIafTSgCSSis5qzmW1+5tcL6u4RuNGFxoBdKCrE3OwCeXilXsHgg1sknlMwwEojwBJaWlfVLoM+yNJn+pz27LV1OkAmlolY+woQbTAN7wWLXdf46p/MUVpDDUigN4o5BBpcMGbnOd64QuF6zbqtqxzh7OA6mVLO6gUhu+7Q6k3UVDGpfxGNQOFUVB3/fG78090R78QEAcbTlJ6w9haksciIRzdTU+T3X73RVY4k5YDRNZ4O3ud3AOs44il1AJkL7XrzPrN3ulIwe61+KwXcGeoDcpBJcV4jnYbhB8F7W4OaWzXV9w==
Received: from MW4PR04CA0240.namprd04.prod.outlook.com (2603:10b6:303:87::35)
 by MN0PR12MB5833.namprd12.prod.outlook.com (2603:10b6:208:378::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 02:11:05 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::31) by MW4PR04CA0240.outlook.office365.com
 (2603:10b6:303:87::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16 via Frontend
 Transport; Thu, 1 Sep 2022 02:11:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT098.mail.protection.outlook.com (10.13.174.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 02:11:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 1 Sep
 2022 02:11:03 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 19:10:59 -0700
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
Subject: [PATCH v5 1/2] virtio-net: introduce and use helper function for guest gso support checks
Date:   Thu, 1 Sep 2022 05:10:37 +0300
Message-ID: <20220901021038.84751-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220901021038.84751-1-gavinl@nvidia.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c78f039f-737c-41bd-e0a3-08da8bbf3961
X-MS-TrafficTypeDiagnostic: MN0PR12MB5833:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J9HXw7ZeWAk0e3vc5Igcj3cwFRU7MC3h6cs0VJGFMim/6d23s543xW+AXh4U218oK8MBaOX6jRdtkc403lkTqLrTZzxtUdlhN++CcloEi3UVMJm7250v3LKPfLT04f+5yxKEKCDfeMyGY4aOyqXKORCqJfGC6Z+hoL8h/vDxwa/q5MT6rvviZt4dPtj+J6+3ofi0bddwITx0TOOUWfMFrep7UdCEpvMcRCR4Bn0Buzl4W8rLA/05hiDeJfiUn40LOuV7PtzvWwurWPxZrnFHe0CVUSxC89KZLHlRJLWC+Gc+lkG6JuuPi1h78HiUH1WBKOx9fa1gdnknTH9EAqUEPbAUvm5GaUFeLmxH06JxPHF7z3qBmT3fO1rWA3FaxlLArGrR3nvE3l01aXLPMDJIw/QOK79iYjZgWQI2jxOfAoA931FUe+8iAIvHrFVNNshvIuqAzFM4bQxJXhnP4VJLfoHDVRVKzdglZX4WbtTY5VYGcOvxqvwALuxbvMrBFv3CrgoYjpk/aJ5rPAzRA7nVaHY2FT/bfX1QN2OQOyliM5CHoaAz3JFmb4OWOZe7bmZGQHCBDgQk2IeFhqB8fkzL0vz15+bUugFI58Dp+5Aqo1SM86JXXbmJTKlOi+O2hEAhXi6KJIamScCq+IzR2H5kADPXdljnY+a1exT86q3n0gqLoFonNZ3FFtE1baic0Olb5OT2M22ncxQam2t0n85MNIRBm6PBmPgOsa7dm/L6COt9jUFSEkCok6Aji9l3kz93ofMYDM+sC6qVJDoH/n/+y1UdMLPRk0+AvYlNXzj/Qu8vI7HjCXaikJJpLMj8P0jS
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(40470700004)(46966006)(36840700001)(82310400005)(40480700001)(55016003)(7416002)(8676002)(4326008)(70206006)(70586007)(110136005)(316002)(54906003)(6666004)(7696005)(41300700001)(26005)(6286002)(478600001)(82740400003)(81166007)(356005)(921005)(426003)(47076005)(2616005)(86362001)(336012)(186003)(16526019)(1076003)(36860700001)(5660300002)(36756003)(2906002)(8936002)(40460700003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 02:11:04.2983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c78f039f-737c-41bd-e0a3-08da8bbf3961
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5833
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
v4->v5
- Addressed comments from Michael S. Tsirkin
- Remove unnecessary () in return clause
v1->v2
- Add new patch
---
 drivers/net/virtio_net.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9cce7dec7366..f831a0290998 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
 	return 0;
 }
 
+static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
+{
+	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
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

