Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9BB4C37AF
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiBXV1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiBXV1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:27:00 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1029A29DD3F;
        Thu, 24 Feb 2022 13:26:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLj+7DV4ip7Zcy4wXahW05r2mA3Tdg0rfiUUQ1F4IcCQwADIKsCXmddptG/TkCM6AMaA+hXulX9xdDMAHH2ZxPSlgEV/hLG7F9HQMXIq7Va+XqVCfQAIMRqt9DFJg2gbwnyjURBV9JsQclVtUSmCWZhqLU2+RbL777S7JuQgKeeywDNZZRQllI6IyDjXJnwbE9Dg50cFWQE7rX2jehILegiKGULNn7Jn7unf5Et61/jtWqxCkhIVuzcCOuRLO55mI6BrSD9v1Nch1hlueAoj8YuE8UWP/pEdh2wdb/K+MvNjFgwmCqX44ock6QYlu5UsY4+bk/J13nDMRcNLqu6w2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aq9v9QnSl4zFVw86sJrG7QcpWAhGerJfTo+ZwuC/mWQ=;
 b=ID3P3uh8bwQAMblqOXO/jocw6FiwuiwKcWRLclBDBFXB4OkGoMcYH/jviPizTOFYHyGn96RkmFiU+UJFnjrhptbUx/3NP/xPWx8mQ6EtEwEfxiB0vQjOGJl+SRlTcEf6eqYERsVjS4oBxMksnmgo5dA7Roagm2UZvQZRr9eKR4Zm/VyrY5nbfZbmLRUB8n2SYCdJfbXHO6IIcgjbL7QCk8Duc6JzwxISV5NaikQMyxCrcxZ22efv2ahIg0qjNxDnrsBw7gIeQulSpBu58v6v7ViVLXahVO4/AQhVmk/wSFm/DiDqyS92WQIbcyyWj2FqVJ6f58VnT2sghlgyGqsaHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq9v9QnSl4zFVw86sJrG7QcpWAhGerJfTo+ZwuC/mWQ=;
 b=bFG0rzvdB0LJ9Q1TVkMPzgaUZGbjj2EMM5e0EziCUSGRarjgclYCylmkl0Ivl/78w/xL0DeB6tLxGpPgFAtlcHEr2PnbcyeVqCk9UuSCH50j4aAuJfwc3VH+uhGjUxXrf2IrdXkTS/FJ8AB54cYdCVCf623iu6AUyvvSueOldn4=
Received: from DS7PR05CA0047.namprd05.prod.outlook.com (2603:10b6:8:2f::26) by
 DM6PR02MB4058.namprd02.prod.outlook.com (2603:10b6:5:9f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.24; Thu, 24 Feb 2022 21:26:15 +0000
Received: from DM3NAM02FT050.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::f) by DS7PR05CA0047.outlook.office365.com
 (2603:10b6:8:2f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Thu, 24 Feb 2022 21:26:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT050.mail.protection.outlook.com (10.13.5.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:26:15 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:26:12 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:26:12 -0800
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
        id 1nNLcq-00095B-4Z; Thu, 24 Feb 2022 13:26:12 -0800
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
Subject: [RFC PATCH v2 09/19] vhost: support ASID in IOTLB API
Date:   Fri, 25 Feb 2022 02:52:49 +0530
Message-ID: <20220224212314.1326-10-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cb3dae9-b3b5-430f-a68f-08d9f7dc49c0
X-MS-TrafficTypeDiagnostic: DM6PR02MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB40583DDF0F6B804F0ADC408BB13D9@DM6PR02MB4058.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxyw77jop7pQHpB29kW9MhAWu4L+jjQ2Qt7CZyRm4ZJwVKy9UtVJ+IKh7a2x9B9nq22+ZGoVpeQtsY74qu8D1GES0obaJst1KVouPDtjsx0becPIh3TXTm92JJR+9YEXtIfFUzly/K5G95/vdcQ3CGM6UcfwE5mpvuLeDd9rVcEz2sK0MWU9mxOlWnKjcUFQqd0rj5wUpqlaLFyOaa+4cwpeSXkPaAFUKhomzn6STOe9pTF5Y0HtKVkJAIy0bURb/sOfiSGtDEun2Q/UI7tPlziM8Rc2hfvqePwRSh/fpKuidzGbQDpq3tRWAZSh/3qAb6FHTqg8d9iAg4HFg7d4FZH6XhDyCyk7RpQ2Y4QcGeYX41q+JMbY3Bvwa0MnDmU4ubEtOmCGeMMjpmvuhng5GqmHZkvk2hvFO3cevNBKchRIQyaozustTwEq7o5P6FJX8atRVtDlx1dmbyOvMoNBdDGJIPAkQkHg8KTJI3zWEjIYV835R1UCEenk2YtejTS4oDYZw7XKnodup7Hj8qhplbPVk7FvtNLUxDNizHoU6YIvjDKphE/6G9Q5F7zkj072zc0egLrmv0n7chnAXH3c8IQKspDjGmDzB+eKZx8Qw3DAq5NbNZCI9oBj2F9nLvJo3iyplEMxQMJGducVSNurRWuh83DqeqRXEG93gt3QuiejZspdE2BLzPncmKHFPqqQPzyc+ZGPFeLyAEM99E+ND+DbT2w9uGbAWoUYdmOL2W4=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36860700001)(44832011)(47076005)(40460700003)(426003)(5660300002)(336012)(2906002)(2616005)(7636003)(109986005)(26005)(186003)(1076003)(36756003)(7416002)(356005)(70586007)(316002)(8676002)(8936002)(9786002)(4326008)(83380400001)(508600001)(7696005)(82310400004)(54906003)(6666004)(70206006)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:26:15.0926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb3dae9-b3b5-430f-a68f-08d9f7dc49c0
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT050.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4058
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches allows userspace to send ASID based IOTLB message to
vhost. This idea is to use the reserved u32 field in the existing V2
IOTLB message. Vhost device should advertise this capability via
VHOST_BACKEND_F_IOTLB_ASID backend feature.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c             |  5 ++++-
 drivers/vhost/vhost.c            | 23 ++++++++++++++++++-----
 drivers/vhost/vhost.h            |  4 ++--
 include/uapi/linux/vhost_types.h |  6 +++++-
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6bf755f84d26..d0aacc0cc79a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -836,7 +836,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				 msg->perm);
 }
 
-static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
+static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 					struct vhost_iotlb_msg *msg)
 {
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
@@ -847,6 +847,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 
 	mutex_lock(&dev->mutex);
 
+	if (asid != 0)
+		return -EINVAL;
+
 	r = vhost_dev_check_owner(dev);
 	if (r)
 		goto unlock;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..1f514d98f0de 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -468,7 +468,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs,
 		    int iov_limit, int weight, int byte_weight,
 		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
+		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 				       struct vhost_iotlb_msg *msg))
 {
 	struct vhost_virtqueue *vq;
@@ -1090,11 +1090,14 @@ static bool umem_access_ok(u64 uaddr, u64 size, int access)
 	return true;
 }
 
-static int vhost_process_iotlb_msg(struct vhost_dev *dev,
+static int vhost_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 				   struct vhost_iotlb_msg *msg)
 {
 	int ret = 0;
 
+	if (asid != 0)
+		return -EINVAL;
+
 	mutex_lock(&dev->mutex);
 	vhost_dev_lock_vqs(dev);
 	switch (msg->type) {
@@ -1141,6 +1144,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 	struct vhost_iotlb_msg msg;
 	size_t offset;
 	int type, ret;
+	u32 asid = 0;
 
 	ret = copy_from_iter(&type, sizeof(type), from);
 	if (ret != sizeof(type)) {
@@ -1156,7 +1160,16 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		offset = offsetof(struct vhost_msg, iotlb) - sizeof(int);
 		break;
 	case VHOST_IOTLB_MSG_V2:
-		offset = sizeof(__u32);
+		if (vhost_backend_has_feature(dev->vqs[0],
+					      VHOST_BACKEND_F_IOTLB_ASID)) {
+			ret = copy_from_iter(&asid, sizeof(asid), from);
+			if (ret != sizeof(asid)) {
+				ret = -EINVAL;
+				goto done;
+			}
+			offset = sizeof(__u16);
+		} else
+			offset = sizeof(__u32);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1171,9 +1184,9 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 	}
 
 	if (dev->msg_handler)
-		ret = dev->msg_handler(dev, &msg);
+		ret = dev->msg_handler(dev, asid, &msg);
 	else
-		ret = vhost_process_iotlb_msg(dev, &msg);
+		ret = vhost_process_iotlb_msg(dev, asid, &msg);
 	if (ret) {
 		ret = -EFAULT;
 		goto done;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 638bb640d6b4..9f238d6c7b58 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -161,7 +161,7 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
-	int (*msg_handler)(struct vhost_dev *dev,
+	int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 			   struct vhost_iotlb_msg *msg);
 };
 
@@ -169,7 +169,7 @@ bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
 void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
 		    int nvqs, int iov_limit, int weight, int byte_weight,
 		    bool use_worker,
-		    int (*msg_handler)(struct vhost_dev *dev,
+		    int (*msg_handler)(struct vhost_dev *dev, u32 asid,
 				       struct vhost_iotlb_msg *msg));
 long vhost_dev_set_owner(struct vhost_dev *dev);
 bool vhost_dev_has_owner(struct vhost_dev *dev);
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 76ee7016c501..634cee485abb 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -87,7 +87,7 @@ struct vhost_msg {
 
 struct vhost_msg_v2 {
 	__u32 type;
-	__u32 reserved;
+	__u32 asid;
 	union {
 		struct vhost_iotlb_msg iotlb;
 		__u8 padding[64];
@@ -157,5 +157,9 @@ struct vhost_vdpa_iova_range {
 #define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
 /* IOTLB can accept batching hints */
 #define VHOST_BACKEND_F_IOTLB_BATCH  0x2
+/* IOTLB can accept address space identifier through V2 type of IOTLB
+ * message
+ */
+#define VHOST_BACKEND_F_IOTLB_ASID  0x3
 
 #endif
-- 
2.25.0

