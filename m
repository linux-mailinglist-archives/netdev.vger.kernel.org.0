Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2094ECB7C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349790AbiC3SNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349934AbiC3SNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:13:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA262B1B9;
        Wed, 30 Mar 2022 11:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auTgLIy6xJ7qU6Q8VcqdEXsXj/rc58VS4RHzLmc6MoY=;
 b=ip0IZPojn2dtoPlf3ehPCrWAH4vlOSnEMU1m9MIqUSxHhXzjTlKCXPi0x4tD954ZY4VPJz2xbeAWnGg0pntmDb/1wPobUoon1ilM+dCcdOcq+iy6dKUZRgHR6dlyLGbobQRagcgdnbgrAElrS3OUPbhoPvl+dtmxGen7QYdieOI=
Received: from DM6PR11CA0048.namprd11.prod.outlook.com (2603:10b6:5:14c::25)
 by BN8PR02MB5731.namprd02.prod.outlook.com (2603:10b6:408:b4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Wed, 30 Mar
 2022 18:11:20 +0000
Received: from DM3NAM02FT039.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::29) by DM6PR11CA0048.outlook.office365.com
 (2603:10b6:5:14c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:11:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT039.mail.protection.outlook.com (10.13.5.22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:11:20 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id EE6F041D82;
        Wed, 30 Mar 2022 18:11:19 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSaJSsO1NPydwDpfZ6y79ZvfQGGVCRhWVoB1COMqL2N0JBeJbrFJFOqnUfQyDOnux7huhXCUgu+snfqEjzWBUseNnb+hESnXzbn1KN9ZgRFr9ONK+4DVvV12/D89zkXg4tVFHm4zH5+wHQr/0PnTeTA7AQ0mM5TT7YuKuVKaisfY253oMIx5r/NHTXHpPf5GIcis+2qwAFOMLQg+EDsfn5xfes7jb3u43aFCiEtoGjPqhhbcoDXO55sms2BVWa8sE1p6vI6pUuPieT5+2gOOdR3bCbmnrK8Xm30me6iDfmkEv2uEzR2Upbh396nJlojfSPAgREM38IhaMvTBcTiY1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auTgLIy6xJ7qU6Q8VcqdEXsXj/rc58VS4RHzLmc6MoY=;
 b=c88XS67p6ZCrFIKUzxg4MsDqpb94qnJp5xsZXfV4HAHRgtc0JAd4deRLpSo0SlHOCitzBPsVHqNxi+gRIj5hSNQ7kjXHsW4j3DphdnGVITRKBWvKpd1sviCsGsxEwwp8r+Hx9vVvM1Fn88F99WrQIPeG2Z0E1M9ByiuU1F2eKN+o3KPndJ4QZx7J7ZNPEMD6yBezTWMrbWRkcDNxF4JGCjGSXQ6St0rIdQ5CCI3Hczc2cFYOAAuMMd3REscl7xKCZGbK3pZMoZ7cZfaDo+P2PGLTIqotALWj/ZzUKkMtgdeQv4ZbJuYT5dFBW+AkWwd1KzxZnLg8sI5wue0jwCcCqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from DS7PR03CA0296.namprd03.prod.outlook.com (2603:10b6:5:3ad::31)
 by SA0PR02MB7131.namprd02.prod.outlook.com (2603:10b6:806:da::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Wed, 30 Mar
 2022 18:11:18 +0000
Received: from DM3NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::db) by DS7PR03CA0296.outlook.office365.com
 (2603:10b6:5:3ad::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:11:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT011.mail.protection.outlook.com (10.13.5.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:11:18 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:11:17 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:11:17 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com,
 wuzongyong@linux.alibaba.com,
 christophe.jaillet@wanadoo.fr,
 elic@nvidia.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZcmq-000CCQ-HB; Wed, 30 Mar 2022 11:11:17 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Gautam Dawar <gdawar@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 07/19] vdpa: introduce config operations for associating ASID to a virtqueue group
Date:   Wed, 30 Mar 2022 23:33:47 +0530
Message-ID: <20220330180436.24644-8-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 78991ad0-12c7-4e76-b9b2-08da1278b147
X-MS-TrafficTypeDiagnostic: SA0PR02MB7131:EE_|DM3NAM02FT039:EE_|BN8PR02MB5731:EE_
X-Microsoft-Antispam-PRVS: <BN8PR02MB5731ACDEF413895F8A94AD4BB11F9@BN8PR02MB5731.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ziaREvisbsWZJxOhgmAwDW80WaXpOdR2e4DTtb4bo5mryPO+dJOc6R78f1+x+sRESbEk39U6UnhoHJUGhJeGws6KD/nXl8u5p22jlyIg18Q48QGUt7W9nokr7ODXH8gBR7DYwz58wMHTyNH7vC7DqYWxoSfPj4WE2FCNwXmlXyB7jM9JKOc+NHE6l0ef/21TMULUI15euYn1ZSx5bWb4uj1eI4WQ6p9c8FRClSoVqCaWGOrdsoYhvgbctaY8kSL5SqchBbO46B9GS4Rswn8sVjsjIXnmvzLS3mQCO8hTqpcLy6UxPjbAyR39LtZLw7QRSef+C2OziYkzEJcrusQ0u6G12TCOaHqFr95GhlaV8fz5gGRu6x1CYR//zhP8aYvVbU4PdI1POVXlp6u4kpANGSjMBFOlAursY47RnoIr82Boj+ljlUd6FmrGvBOfB/MVuzI0bK3X6IWkt30q2dLCSp1bWBx9GCc5fqOALV7yjlA4J9ExYlP30htwb5Pmo3YNJjBGvU8nb5EPopZwfCBMbHkZ/yVVrDmpKxaEKNXNQDD8onbrRo+K0qWNUoEVI/pUl6LUPVQE48yUGUCEjCn/LfxWv/Lx6nRVtIjbdoMnn3rxTIrKNbnzZCY81Nt8IQbXew5MuH5wk2IMjGF+K8mGQZbvyxfskaHYWx+geMqjxYqdOLr+gvb+uXbRJEAM6HZFwLaLJHsGiRN4+5bmKW5Obg==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(1076003)(8936002)(336012)(7416002)(186003)(70206006)(508600001)(36860700001)(4326008)(47076005)(70586007)(83380400001)(426003)(2616005)(36756003)(8676002)(26005)(82310400004)(5660300002)(6666004)(7696005)(2906002)(110136005)(7636003)(316002)(54906003)(356005)(9786002)(40460700003)(44832011)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7131
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT039.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: dbad219a-5622-47fa-4b79-08da1278b019
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I261KkhLjzjz9xFujQhMWrlzZ9LVqCCxHu1tSrfn/Kn5mHRc31+m8xn99HXj7wS/552IZxzqtKE5uzNHWsD+bvJmgLLBO1GGLbq1Z8o3oMuUmB/SQ1fnvB9GddHzUyImYjtNOA5qVbghzmKRfyH6HVh9gaOAwuDG2L/rsU4ddD7HxmDnmwllx/KMPaoDL3+6JPhiKHmBTdY4aikEYn1gTkQMx7ct+a1X14DuJZOB+RDw16LDGPJVneq7Ehe5uswrRHahWS8wre9lIikO8+Ua49xCk4nAHPvjMs11S0B0hQGGHEhc1IbEaFvV0mgAZzfIQ7BXauo9UDtoWUn7oGN/wtUuQ8TRb/kZCIPb+NCNm2jJ0OdDJ+YQNLgh6IfZtZexxnwd64bQazW21jA2cO6eznSQo1pyH6yr9upfXYswXI8/nstDTSIUgNb9n353ackOBjbZN9zvT5C+5BcS1yA2Kv4ifW+1ea8vhmwpyTfINic6qHsh6vp0T1JkoWRKYTN3OApzjcuJMup3ZqTifyTPg17+cZNGk04tSxDwNs7qOG24tfiywc34belfecgquCuk6Eun3DZwBdEGC9rYbooCj6UGVHOAPa6l9gfvhtP7wP/WUgpYxsk8qlnqWk9dMT7qBZhp3+vaebkFhF6+JpgY+vHuYDNgpuag7h88DZFDm42/m+HlHy1EwBiv0Id3Fo+a7GetmhCEd+4R3tMqgpmztJ7ure4dH3Pl2kR4DKScRMg0aIwQhGtFmje0PK9Z3FXt
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(2616005)(508600001)(1076003)(70206006)(81166007)(8676002)(316002)(336012)(426003)(26005)(186003)(6666004)(7696005)(36860700001)(4326008)(82310400004)(83380400001)(40460700003)(47076005)(110136005)(2906002)(54906003)(9786002)(7416002)(44832011)(8936002)(36756003)(5660300002)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:11:20.4896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78991ad0-12c7-4e76-b9b2-08da1278b147
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT039.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR02MB5731
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new bus operation to allow the vDPA bus driver
to associate an ASID to a virtqueue group.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 include/linux/vdpa.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 7ab0e29ae466..f4d8c916e0d8 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -240,6 +240,12 @@ struct vdpa_map_file {
  *				@vdev: vdpa device
  *				Returns the iova range supported by
  *				the device.
+ * @set_group_asid:		Set address space identifier for a
+ *				virtqueue group
+ *				@vdev: vdpa device
+ *				@group: virtqueue group
+ *				@asid: address space id for this group
+ *				Returns integer: success (0) or error (< 0)
  * @set_map:			Set device memory mapping (optional)
  *				Needed for device that using device
  *				specific DMA translation (on-chip IOMMU)
@@ -322,6 +328,8 @@ struct vdpa_config_ops {
 		       u64 iova, u64 size, u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
 			 u64 iova, u64 size);
+	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
+			      unsigned int asid);
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
-- 
2.30.1

