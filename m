Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B024ECB5B
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349755AbiC3SJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349739AbiC3SJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:09:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A2337033;
        Wed, 30 Mar 2022 11:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5N+DzVfLymIpkC0kdTUOxGNTtMH4HbnDMMHFXJ5OwM=;
 b=QIMkz2EcOF8O+dVGp7+kLzrL1VxGMYvcsBRafYm3Cu46/CcV5YGV0zxx4GozF7LiXsSklZ4ClWiyQzwyiv/JEO3FUyELBxoCXx80pBng4cERWD6UCQnc7BqtXgyM43cGQZiS5PPt+6L7ALfw/Gr1PCbitYhOIeFvBbDKWVLG6iA=
Received: from DS7PR07CA0011.namprd07.prod.outlook.com (2603:10b6:5:3af::22)
 by SJ0PR02MB8433.namprd02.prod.outlook.com (2603:10b6:a03:3f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 30 Mar
 2022 18:07:27 +0000
Received: from DM3NAM02FT019.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::c3) by DS7PR07CA0011.outlook.office365.com
 (2603:10b6:5:3af::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:07:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT019.mail.protection.outlook.com (10.13.4.191)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:07:26 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 2CB4241D82;
        Wed, 30 Mar 2022 18:07:26 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSpXAY9fOUNEJfYY3ZwRyi18enjcKK7ihqXY/GoOijwKP6Y6QOxU6xnuym1qaAqoYpAF+tdIf0GwqeCfTEUuQo7CbLOMEl4AnNhQ7/e/PaK6esRp0FCEVM10yM/Zm567vyqL26xu4qz/JphgsTJHC7YBJR1xAm4rHBb0fDUwAPVEMYJmTiDh5wD57Fay1trBIIbW15oIVkyQ/thW0ZoMRKyZ9ZxmYLAIyTRuOM/4ft+AU/IEaNL0wUlbVt5qkHL4I6keLcSEyuECU5BE/DglGtM/ckpqknj3uxHg38ihBxVigAj3CUIIVQ/xo3pzAq7sacxjV0f4AHSDBloJiRbi5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5N+DzVfLymIpkC0kdTUOxGNTtMH4HbnDMMHFXJ5OwM=;
 b=EIIVnG2i+2nBN1eq8eRbDhhCXT/rKmPA+I+y0GKgwxc5eHaJ5Iu3LAQReHb7h6jOCbvPQcrkqklcV6e6Qr6ToDvx/Df1QL7j9bGEPxbOlagQmwPZIl7mRq+Iw2AXmTeJavbvvlkHiHBMAHpR35vnxWEGpK+gzYjC2J7rY5Kqgh289J2BBMVLpzf8DShXeMr6nj1nHAkjSBLS4ISfaDcAgz7pTi/cEpKiw3tmFnAc+0gbXoKhq1bzS/fUDC4GPtiiidSZpEGJWOBjyzcge7aqHWmNIzFApO5ry4YNiYh1yLRVVSavKxPgIxzEe53B8SDTBhjOr4yFwqkJrYgQ4nNDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN0PR03CA0033.namprd03.prod.outlook.com (2603:10b6:408:e7::8)
 by SJ0PR02MB8420.namprd02.prod.outlook.com (2603:10b6:a03:3f5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 30 Mar
 2022 18:07:24 +0000
Received: from BN1NAM02FT008.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::bb) by BN0PR03CA0033.outlook.office365.com
 (2603:10b6:408:e7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:07:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT008.mail.protection.outlook.com (10.13.2.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:07:24 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:07:22 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:07:22 -0700
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
        id 1nZcj4-000CCQ-Cz; Wed, 30 Mar 2022 11:07:22 -0700
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
Subject: [PATCH v2 03/19] vhost-vdpa: passing iotlb to IOMMU mapping helpers
Date:   Wed, 30 Mar 2022 23:33:43 +0530
Message-ID: <20220330180436.24644-4-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 19f15fd6-7c90-4a40-adae-08da127825e1
X-MS-TrafficTypeDiagnostic: SJ0PR02MB8420:EE_|DM3NAM02FT019:EE_|SJ0PR02MB8433:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR02MB8433BA252ED9DA399F7D7584B11F9@SJ0PR02MB8433.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: eK/94eGXR9FXtBBEMxjeJdkyjOpD+feO0t+3KM6G8qE3QAVOQUAULGEknBKSb/3GkgMnfcAAJ7ZECyNA0G44+xkmHg9rG6wN8Q3Iex1sZ2iuZPH2MspQck3T3o2kQYDTb05TY71XlGWFRxbdWrIPvA3t2TwgsyEU+CoZ2s7T8LkTxZh0unIiUVthqVJYdeoJioL1BApgrwOrndoUdh5OOsM5F1ZB2xQt41div0xPgXNs+qPGsk64Q1DKz5cKsFm7nWWLpcEryneV+sXWC898bWJxvsMNVxTEEfu7q1sNJ6ylbCL4fK6Imf00YwEm7zONUKJjMmLSsh7nZ7uQRLRP/G4ij3a3ah4WGnboxcC1D+96Fry5tpVh4GTy9bv6HMr0k8DkSNbt1F762AJD6mSbYsnrDXpRZKTBm1B6px1NdjRCuy2hQDULQdTwyAcJhMRHhv8wY7PWyx10Q9/+h05vGYXw4UZS0VlCUYNaGNX7dUJJ2sgr+8GOzmBPRKSEL0m/f8P45C7joGJvjgwqJmrxzcQ6DeS7Mn/7SE2fgpnWx/ooLPLB/QR1PDhgbJRrzs+RRdTokkCjoVmWNe6mhO0NmmOwZTdE/3GSSX8hz4DcfJuOQ/vyha/5zLbQHYBNkOr4kTsTQ6Lwj7jXUbidQY1+89eB9RwBqPPy4MBAs1Ibp0hTYUpDqRSZVl9cUp4Mu8y2RahcvdJW04WJ57Lwpt3gtA==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(44832011)(7696005)(82310400004)(426003)(7416002)(36756003)(36860700001)(8936002)(110136005)(47076005)(6666004)(5660300002)(9786002)(26005)(186003)(336012)(2906002)(54906003)(356005)(40460700003)(1076003)(2616005)(508600001)(70586007)(4326008)(8676002)(7636003)(316002)(83380400001)(70206006)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8420
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT019.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: dab99898-a346-4dc1-c107-08da12782482
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfKsWGv9s9mdxlNlm93Ia0DgTvA9XfCT6yhWLD/h6/fgfHDOd6eDIOl0R1px4+/GpLGTZ6ku9CIM89a6w4knYiHxl/EER2S45ADBz+McVSDacc3Yx068WA202AByCBeLIg9pNXvxYRQf1uI3PE8a01UwBjw/WotTqHnqfvCWyn/FgaiBCS8goB8MU2kG/bBOL9nm5MbwctTJF14RKC030mqQO1aXtsb5X+M5Ij1qcT3E3Yux+9UEYam5jsfHqkZIbX/0sPVY0d+oaB2V/IBulQZGHICz9JWCSsPdCarCX0vGteoiC3xu2VBbynRlHoul++jIP69nIIV9jiCYz7QLn+MYQ9QWIv4soneVs8nB8f1XfuH7bh7HwyjWFZykJq/F5QWPVB/A3i/p2ui818ZTKkSCHWAihRc/OBCkEX2rFsllOB+xccOhEvt0HPgXeaSRLUQCmXHOCk99KijCQTOW9fO4Jc72uxw3vOBA14TfoWf8eBsw7Gfnx4wJRPfN3lSrmUkrFGJXDELVSmBYJzgtsr+ZP5HMNTeA/EMAwQ+ohngW/Uz7o7uC6nNe7xx/J4PnNUWrMqq6qFHrI8GjcvT4Kfkpl48CsF7DNE24mJOh+UmNWyrIKZnPtG0awHpEwcd/i5FQzzhbx1uhf0p/o0keJn3MSYzEHpBeU9RvagAWkixHfpVjbDZQx6s/Lyuy85nh0K+fed4JUgO+0qmOZw+nvTeUesC6I57KheG+0v+GnEoweIvI86Fu2VPFItqd1RvD
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(426003)(1076003)(2616005)(26005)(186003)(6666004)(7696005)(81166007)(7416002)(5660300002)(8936002)(44832011)(9786002)(40460700003)(36860700001)(508600001)(316002)(47076005)(82310400004)(36756003)(83380400001)(2906002)(70206006)(54906003)(110136005)(8676002)(4326008)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:07:26.6175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f15fd6-7c90-4a40-adae-08da127825e1
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT019.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8433
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prepare for the ASID support for vhost-vdpa, try to pass IOTLB
object to dma helpers. No functional changes, it's just a preparation
for support multiple IOTLBs.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 67 ++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 4c2f0bd06285..6d670e32e67b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -537,10 +537,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	return r;
 }
 
-static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v,
+				struct vhost_iotlb *iotlb,
+				u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct vhost_iotlb_map *map;
 	struct page *page;
 	unsigned long pfn, pinned;
@@ -559,10 +560,10 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	}
 }
 
-static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_va_unmap(struct vhost_vdpa *v,
+				struct vhost_iotlb *iotlb,
+				u64 start, u64 last)
 {
-	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct vhost_iotlb_map *map;
 	struct vdpa_map_file *map_file;
 
@@ -574,21 +575,24 @@ static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	}
 }
 
-static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
+				   struct vhost_iotlb *iotlb,
+				   u64 start, u64 last)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
 	if (vdpa->use_va)
-		return vhost_vdpa_va_unmap(v, start, last);
+		return vhost_vdpa_va_unmap(v, iotlb, start, last);
 
-	return vhost_vdpa_pa_unmap(v, start, last);
+	return vhost_vdpa_pa_unmap(v, iotlb, start, last);
 }
 
 static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
 {
 	struct vhost_dev *dev = &v->vdev;
+	struct vhost_iotlb *iotlb = dev->iotlb;
 
-	vhost_vdpa_iotlb_unmap(v, 0ULL, 0ULL - 1);
+	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
 	kfree(dev->iotlb);
 	dev->iotlb = NULL;
 }
@@ -615,15 +619,15 @@ static int perm_to_iommu_flags(u32 perm)
 	return flags | IOMMU_CACHE;
 }
 
-static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
-			  u64 size, u64 pa, u32 perm, void *opaque)
+static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
+			  u64 iova, u64 size, u64 pa, u32 perm, void *opaque)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
 
-	r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
+	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
 	if (r)
 		return r;
@@ -632,13 +636,13 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			r = ops->set_map(vdpa, dev->iotlb);
+			r = ops->set_map(vdpa, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 	}
 	if (r) {
-		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
+		vhost_iotlb_del_range(iotlb, iova, iova + size - 1);
 		return r;
 	}
 
@@ -648,25 +652,27 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 	return 0;
 }
 
-static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
+static void vhost_vdpa_unmap(struct vhost_vdpa *v,
+			     struct vhost_iotlb *iotlb,
+			     u64 iova, u64 size)
 {
-	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 
-	vhost_vdpa_iotlb_unmap(v, iova, iova + size - 1);
+	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
 
 	if (ops->dma_map) {
 		ops->dma_unmap(vdpa, iova, size);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			ops->set_map(vdpa, dev->iotlb);
+			ops->set_map(vdpa, iotlb);
 	} else {
 		iommu_unmap(v->domain, iova, size);
 	}
 }
 
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
+			     struct vhost_iotlb *iotlb,
 			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
 	struct vhost_dev *dev = &v->vdev;
@@ -696,7 +702,7 @@ static int vhost_vdpa_va_map(struct vhost_vdpa *v,
 		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
 		map_file->offset = offset;
 		map_file->file = get_file(vma->vm_file);
-		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
+		ret = vhost_vdpa_map(v, iotlb, map_iova, map_size, uaddr,
 				     perm, map_file);
 		if (ret) {
 			fput(map_file->file);
@@ -709,7 +715,7 @@ static int vhost_vdpa_va_map(struct vhost_vdpa *v,
 		map_iova += map_size;
 	}
 	if (ret)
-		vhost_vdpa_unmap(v, iova, map_iova - iova);
+		vhost_vdpa_unmap(v, iotlb, iova, map_iova - iova);
 
 	mmap_read_unlock(dev->mm);
 
@@ -717,6 +723,7 @@ static int vhost_vdpa_va_map(struct vhost_vdpa *v,
 }
 
 static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
+			     struct vhost_iotlb *iotlb,
 			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
 	struct vhost_dev *dev = &v->vdev;
@@ -780,7 +787,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			if (last_pfn && (this_pfn != last_pfn + 1)) {
 				/* Pin a contiguous chunk of memory */
 				csize = PFN_PHYS(last_pfn - map_pfn + 1);
-				ret = vhost_vdpa_map(v, iova, csize,
+				ret = vhost_vdpa_map(v, iotlb, iova, csize,
 						     PFN_PHYS(map_pfn),
 						     perm, NULL);
 				if (ret) {
@@ -810,7 +817,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	}
 
 	/* Pin the rest chunk */
-	ret = vhost_vdpa_map(v, iova, PFN_PHYS(last_pfn - map_pfn + 1),
+	ret = vhost_vdpa_map(v, iotlb, iova, PFN_PHYS(last_pfn - map_pfn + 1),
 			     PFN_PHYS(map_pfn), perm, NULL);
 out:
 	if (ret) {
@@ -830,7 +837,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-		vhost_vdpa_unmap(v, start, size);
+		vhost_vdpa_unmap(v, iotlb, start, size);
 	}
 unlock:
 	mmap_read_unlock(dev->mm);
@@ -841,11 +848,10 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 }
 
 static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
+					   struct vhost_iotlb *iotlb,
 					   struct vhost_iotlb_msg *msg)
 {
-	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 
 	if (msg->iova < v->range.first || !msg->size ||
 	    msg->iova > U64_MAX - msg->size + 1 ||
@@ -857,10 +863,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		return -EEXIST;
 
 	if (vdpa->use_va)
-		return vhost_vdpa_va_map(v, msg->iova, msg->size,
+		return vhost_vdpa_va_map(v, iotlb, msg->iova, msg->size,
 					 msg->uaddr, msg->perm);
 
-	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
+	return vhost_vdpa_pa_map(v, iotlb, msg->iova, msg->size, msg->uaddr,
 				 msg->perm);
 }
 
@@ -870,6 +876,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_iotlb *iotlb = dev->iotlb;
 	int r = 0;
 
 	mutex_lock(&dev->mutex);
@@ -880,17 +887,17 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
-		r = vhost_vdpa_process_iotlb_update(v, msg);
+		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
 		break;
 	case VHOST_IOTLB_INVALIDATE:
-		vhost_vdpa_unmap(v, msg->iova, msg->size);
+		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
 		break;
 	case VHOST_IOTLB_BATCH_BEGIN:
 		v->in_batch = true;
 		break;
 	case VHOST_IOTLB_BATCH_END:
 		if (v->in_batch && ops->set_map)
-			ops->set_map(vdpa, dev->iotlb);
+			ops->set_map(vdpa, iotlb);
 		v->in_batch = false;
 		break;
 	default:
-- 
2.30.1

