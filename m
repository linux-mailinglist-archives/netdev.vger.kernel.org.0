Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364874C379F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiBXVZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiBXVZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:25:21 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CE5294FC1;
        Thu, 24 Feb 2022 13:24:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jngMXUD11HsH5AGliGrOs9eyT4XJ+vi30thELSVVW3pLheIjikHf16uvoVq9dSuyxlQ3l09avY5XpFGOFrVkY6VEYusmK3Yd+yA7lNrfgRiJVNGbmoFDLLqgtDFixIcNIWI5FAyTy+lyRlnoJf8bK7W/L7SZVyW1u/Sd5C7ZDzgMOKQ5ja1MiQ1eRtYFfKqJpS+fnyVe09o/ZSYWnxtAdwWo0kUzFNy2K//K+ZdqQlQf4OhnovfaTRwjEnsIajXu49hjwpH8Xu+lA9ihGMEpxdJbPt8yfc/34sHB9lbGgTH/Ha2Qe9DvQfr+lXHuBidNHkbbtk4QtPMJYkFKmT5Fqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buj/AiOUmN4Vxv0SoCdhA/v/c7DKN365NkZJYAjNDGE=;
 b=Pokhum5PdX12btM1Hopccady8GS5pxahHLv8L8faDNCQfQ+kFcQi8vZrdhvXdjGNjJNYGkao0I3Ty9hAWauqEriKUKoJNGYDToGWUALTpSAJ/YiiRUUxhfRpYteCfpQ9kguXutZY3tU2quLaqAZvmDvwNit8R/ayrruAoyG3Jgoe0sIu/LlF8t/GrPorqaCxyX4P6bTLOnB0+d8VRsiblf9YJ5yTJeKon10hdxPWAc4CfpP6obbmMpUL+bxc6IMvdPmnVBwQ01gE0cTNgYwYRzoky3WiwaaD57N9ERELwkQrMOJyNGyqrZR9dF/7lCIJCCPhQvnerXqXcqUz/CS4kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buj/AiOUmN4Vxv0SoCdhA/v/c7DKN365NkZJYAjNDGE=;
 b=IgfD3w8bX5pwrK+2N9Kt++CrO3aT8QNPn2m+ab77tqPtzQCCY9JdAdq7uJZfZDh4DVtIo9pTqKtC0A4YNkuzf2wyTbWDRzXViGrOEHiKDcTza8pAriiJkaEfLT0ppN3Jw+en4Stmzm7LbsxcGdfO7Lj1pZsT5QAR3747PMHAGKg=
Received: from DM6PR08CA0066.namprd08.prod.outlook.com (2603:10b6:5:1e0::40)
 by SN4PR0201MB3519.namprd02.prod.outlook.com (2603:10b6:803:49::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 21:24:38 +0000
Received: from DM3NAM02FT035.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::1d) by DM6PR08CA0066.outlook.office365.com
 (2603:10b6:5:1e0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 21:24:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT035.mail.protection.outlook.com (10.13.4.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:24:38 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:24:37 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:24:37 -0800
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
        id 1nNLbI-00095B-Nh; Thu, 24 Feb 2022 13:24:37 -0800
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
Subject: [RFC PATCH v2 04/19] vhost-vdpa: switch to use vhost-vdpa specific IOTLB
Date:   Fri, 25 Feb 2022 02:52:44 +0530
Message-ID: <20220224212314.1326-5-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8baf735-6864-41ec-a933-08d9f7dc1024
X-MS-TrafficTypeDiagnostic: SN4PR0201MB3519:EE_
X-Microsoft-Antispam-PRVS: <SN4PR0201MB3519B5D6993FE6EDD3883988B13D9@SN4PR0201MB3519.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEGfecEY5M57St+uMzVdqulLi+KUWU2k6dz3vhmHIdCL81zULw9A/Kc5S3fNhOvN17jJ2uLk0gY5dQUYYUISr+9qDhs8irlo9RuNPII7UrYA0sxUh2SO+mWabArtrvXXVhWM9Lyuppx+spWICGnOc3RP6sRaN0hBEhk0WynN3AfRc8rB1b1czQRWfdVYY5mONoRArQMm9rW7naBvdhWoOduBmNA1LB1jb6F/fAawRGI8Q9sLZ4yKQEohuwiY+dfQXPu+N/Kiy10+GvUyjp40pgz9BMj27OaayhD/rRNdbJa97LpCfkTJpQtS2JKQmWKpmf/c8b5IMORoGR1NreLYP15LCGofSMX/biFg6NDNd/fdcRgR8Gwh3rE/DTaoBZZLeI6Xkt9wBMGxS9CJgVKUI+1P2FvBcO4PQBVKPAdkoOyOCxPPbDPH5RE/KnCXiy+KvJNXrVLf7zdW5zu9TdWltcKhsWOQzYINWQNcNTN3nTO72TDJ9bActC4DjRuWB3JU7Zlg8JKwqgEY8kZuqcbAp21pFYwnG5M99KQhYW0soJx3HPETlvRrqLobSlEso97gbmg+JWJIK1ikjMZV+Y5Svz6+RftO1NiI3lOOk2OHp2KCGAIBAzqoKGJrROMVBpPKevJKApuLAkrFTqxLCLsHiSXYGllWD6s8wHaHupsAl8NkkN0l3BBjIV2QZ3x9dnhtTkv/C/mWtq3X139i/25zFeoDVLDtesOAV+TTJUskPis=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(2906002)(47076005)(9786002)(82310400004)(70206006)(8936002)(7636003)(356005)(8676002)(4326008)(40460700003)(70586007)(508600001)(316002)(109986005)(44832011)(54906003)(6666004)(83380400001)(5660300002)(426003)(26005)(2616005)(7696005)(186003)(1076003)(7416002)(336012)(36756003)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:24:38.4402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8baf735-6864-41ec-a933-08d9f7dc1024
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT035.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0201MB3519
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ease the implementation of per group ASID support for vDPA
device. This patch switches to use a vhost-vdpa specific IOTLB to
avoid the unnecessary refactoring of the vhost core.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 146911082514..655ff7029401 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -39,6 +39,7 @@ struct vhost_vdpa {
 	struct vhost_virtqueue *vqs;
 	struct completion completion;
 	struct vdpa_device *vdpa;
+	struct vhost_iotlb *iotlb;
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
@@ -555,12 +556,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
 
 static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
 {
-	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
+	struct vhost_iotlb *iotlb = v->iotlb;
 
 	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
-	kfree(dev->iotlb);
-	dev->iotlb = NULL;
+	kfree(v->iotlb);
+	v->iotlb = NULL;
 }
 
 static int perm_to_iommu_flags(u32 perm)
@@ -842,7 +842,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_iotlb *iotlb = dev->iotlb;
+	struct vhost_iotlb *iotlb = v->iotlb;
 	int r = 0;
 
 	mutex_lock(&dev->mutex);
@@ -982,15 +982,15 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	dev->iotlb = vhost_iotlb_alloc(0, 0);
-	if (!dev->iotlb) {
+	v->iotlb = vhost_iotlb_alloc(0, 0);
+	if (!v->iotlb) {
 		r = -ENOMEM;
 		goto err_init_iotlb;
 	}
 
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_init_iotlb;
+		goto err_alloc_domain;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -998,6 +998,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
+err_alloc_domain:
+	vhost_vdpa_iotlb_free(v);
 err_init_iotlb:
 	vhost_dev_cleanup(&v->vdev);
 	kfree(vqs);
-- 
2.25.0

