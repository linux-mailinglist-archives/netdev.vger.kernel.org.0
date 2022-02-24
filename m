Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E284C37A9
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiBXV0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiBXV0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:26:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5861294FF8;
        Thu, 24 Feb 2022 13:25:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRZu7HeThaKHCyfIspQf+wC7CbIPuZfUeiZNg8s21PoMsu1iUqoIPEnRlS1ox3JMxe98CCGJ1iUdX5aosij3B21Rdh9lmAoJw0tJJHzZ3KbyoNsUVASM4xcRHbJ36o/SdzO06VvYVgvRSvwOziMGB5TqfXhS4U9dlq7nTTPUXEzUiRwVvXbCSNGjGYDhZQWR6s/3ygwm7Evwc1fa7qPBzpG8uZkwV5EbS0DyOpy23xhYRFWpCSOaNubG4aDFMmRJFogRSvigkPsAGmzfAVfKDABdYce+Q+ZuQW0zvtkxO66pwJulkSEtM0omFHDjodmj6Chrrv5EblJ/VCV1lTxtBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWsiA+jInzk8t2UIiVOUl+QIHmmDAtf/1r53lkKWQtc=;
 b=CR6qDmdZKVAJdp1EzzmsliDciiu5qBbRBcyyfy8bpotm9EWyvQTGPbMU5f7AAJNJoBfoGeJn8KUz/WW3LWn6dHGlz4o9IEbYdSeCAXkGfEN1aaUcH7iTboMhEZa7McZ5tskfJpL15gaBJj6se+gvoBrLbtn3/JUtMCwRg+srkBKzGbh2P6TnDP+udCvbELZdiXOIFgscf2rDyektDcGRSRaedOCCF8rhXBar974qdl0CJIqTq+xw0iPEOpV6DRxZZG9BDBRCkcq8LmF14Pn1Sr7mkOJgJNlX7IAQiVt9PvDLRoTl/QBYWCBSvSoE32FA4zPhOt+BvtInxDy3xpFl/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWsiA+jInzk8t2UIiVOUl+QIHmmDAtf/1r53lkKWQtc=;
 b=DqFKTVxs44pw/ujXR6iyNQIlGLwmyZKL8SS226om/0riFVs72gkcuAh9yQOF/o+Mgf4MDQdIxO3fklRWgDppjVgcIhdi49+tkoeGPSsXcJdBFovJ1W9VbbgIwlXLJPDhzNdpmBKTEMlElvwk6Dez7KTAHmm1E1AWRlxILC6rz5I=
Received: from DM5PR15CA0071.namprd15.prod.outlook.com (2603:10b6:3:ae::33) by
 CY4PR02MB2885.namprd02.prod.outlook.com (2603:10b6:903:11d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 21:25:34 +0000
Received: from DM3NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::50) by DM5PR15CA0071.outlook.office365.com
 (2603:10b6:3:ae::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24 via Frontend
 Transport; Thu, 24 Feb 2022 21:25:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT013.mail.protection.outlook.com (10.13.5.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:25:34 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:25:34 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:25:33 -0800
Envelope-to: eperezma@redhat.com,
 jasowang@redhat.com,
 mst@redhat.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 elic@nvidia.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [10.170.66.102] (port=59620 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nNLcD-00095B-87; Thu, 24 Feb 2022 13:25:33 -0800
From:   Gautam Dawar <gautam.dawar@xilinx.com>
CC:     <gdawar@xilinx.com>, <martinh@xilinx.com>, <hanand@xilinx.com>,
        <tanujk@xilinx.com>, <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH v2 07/19] vdpa: introduce config operations for associating ASID to a virtqueue group
Date:   Fri, 25 Feb 2022 02:52:47 +0530
Message-ID: <20220224212314.1326-8-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d153978a-acd1-4fd9-9738-08d9f7dc31a2
X-MS-TrafficTypeDiagnostic: CY4PR02MB2885:EE_
X-Microsoft-Antispam-PRVS: <CY4PR02MB288521F8252816AE4E694A37B13D9@CY4PR02MB2885.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MUkA8gZMib1QmQ5bYW6rWFuGV422A38/wBgIHMmGC0lGM1Z5J0vyEThvLzUUvii7Vo06aW/NvHAMEEjEX90UvzJt/pEHV4JQp3j7wyV2TdLU1VcvpbNuUAjWSdqBOkpFu0FUkwwxToDV1wT0YLCnrx12wbJk8bIvz/0W3cEEBNtd5xLNMZPHbxxV7ILls5lVt3at+N+nBE5vN214D3etg4t9K753WDJEKT89L6tN2AHZrKPTAUgl+S5xML5Iia8joZmz0eMVS5hyB0gU+EB9qVJzqa/k85ZBGajWMVdJv1sqjPHFQ01ZgHoBIStkDnFu5ar3S8fUG1wLevMDHP27wEvV8ShNDRjSiLBJCImVOhfbCADAf7I4YCBWmNR12YuhHhY17kC2VjlfPHYS3TRupih+/H1jYcFh9m2Fd32MOvYg7ow67fouYYIPj2K01ZA6bnOoTDdFbtz6K6ecmhjXO8ziD+jWLgrs4o6RFWqVWGNbxrCzxNC4fRTquEsGO9IGzRo44wrwnSaFy127yhq95692UVW4ILnWQxb9qbyuryQuMGVFgq9/RSMPNmrKXeneBlGQ3AJ0JpfZcSXXqSKPrm906/WhjgxGwg3/cnS1wUaECOLzpLyWeJuR8OoA+guvQ7wM48AwmKRBfN7D8tsLu0o1/VcogPNOUKUA94FAfKsRyH0RhUpXsQ4fJeebTKLTcGjvUWn2Q5j7yXu822jARmeKPSdlG0xx7S5IztBmJ+Y=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(83380400001)(47076005)(54906003)(426003)(36756003)(44832011)(2906002)(316002)(7416002)(186003)(2616005)(9786002)(8936002)(7696005)(40460700003)(70586007)(82310400004)(7636003)(1076003)(70206006)(26005)(4326008)(109986005)(356005)(508600001)(5660300002)(8676002)(336012)(6666004)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:25:34.6459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d153978a-acd1-4fd9-9738-08d9f7dc31a2
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT013.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2885
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new bus operation to allow the vDPA bus driver
to associate an ASID to a virtqueue group.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 include/linux/vdpa.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index de22ca1a8ef3..7386860c3995 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -239,6 +239,12 @@ struct vdpa_map_file {
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
@@ -321,6 +327,10 @@ struct vdpa_config_ops {
 		       u64 iova, u64 size, u64 pa, u32 perm, void *opaque);
 	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
 			 u64 iova, u64 size);
+	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
+			      unsigned int asid);
+
+
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
-- 
2.25.0

