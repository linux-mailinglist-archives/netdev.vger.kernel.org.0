Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75344C37BF
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiBXV2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbiBXV2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:28:11 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33B364BCD;
        Thu, 24 Feb 2022 13:27:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6HVdpO7amZsvwjH0Ui6YhA9Y0eM/0NW/6+AVFQGIo+7WSQ9JDuuX+nKBZ7FnD6hWuIVPImii2Frmkkfm+bjILUyjIIfuccuNpi9x2V0yrsuk9LqJzPl8Pra2/7K5BYXCdy+4k2x6dHhKGV0BrwoAK7UEhWS5NOZxv5R+JkMF/w6iB6ntn828F38plqLUupyUgb3sR/cEyKqTDf/jsM4GGEwO45ouGd4TO+2Tk/uD3Nw4mEGlskxgyq/6UPEGuWgt23eNL2piyN/T/FtgUYk8DjYhwCjYCDGBWUx3mVCx7ZeArztaiqpi/VGUwyhrR8+XTIQ/tit/0iFQCeUVCiNFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWSs2PlHjRSaymxGXJYemewGkO5sA2C9iaN9CMO6kCY=;
 b=d+MBXE0Y23E1mZxpzigYNKGYgRw/QoUy3jMCNrJ3o1LwK7jVQslCy+0ofauXl2XqwtyWIUpgrrU6nJFVQ0rpyyo0jIc2Z/4fppZLWqB7mzba/TUVSR3WMmacDc8l+X78Z94Lvq+Mhs40mdxSoJyk5HRf+aPJ5hUOphFBUgx/1xPvWm3HjOxh4RnSa8LyqUlS+jP0lxa0wqqmkZr6fmPP+XqSWeSILn/LzLc07oeW5snJNPqjbBigLyLqvTSZfxQInXqZ/3E73BsHoA9Mfa3JczYS4bFOSbm0L4+blOSwt/u5fsm+GG0/xi3DxVQ2Bi7CG2xCImXjJE3Cir7nOx25Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWSs2PlHjRSaymxGXJYemewGkO5sA2C9iaN9CMO6kCY=;
 b=A+DXOltVtClFTUzsfXF/8Utlea6A0hTfNPO1t4gDjSGyEyEkeKy6iLcVOPFIhlq53mLLr39RnqxAUpRFRiJ9FJJo1aP3M24wmbYkigeGfmuWkVzjM8QqRATUI8PrMe2wXO8KKx2o5mWxuhrdRVGqiLAwO4ugBd3DwLt9y4ZTCFQ=
Received: from DM6PR05CA0049.namprd05.prod.outlook.com (2603:10b6:5:335::18)
 by MN2PR02MB6830.namprd02.prod.outlook.com (2603:10b6:208:1d4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 21:27:30 +0000
Received: from DM3NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::82) by DM6PR05CA0049.outlook.office365.com
 (2603:10b6:5:335::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.9 via Frontend
 Transport; Thu, 24 Feb 2022 21:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT052.mail.protection.outlook.com (10.13.5.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:27:29 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:27:29 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:27:29 -0800
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
        id 1nNLe4-00095B-Od; Thu, 24 Feb 2022 13:27:29 -0800
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
Subject: [RFC PATCH v2 13/19] vhost-vdpa: uAPI to get virtqueue group id
Date:   Fri, 25 Feb 2022 02:52:53 +0530
Message-ID: <20220224212314.1326-14-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 215f0a5e-6af4-4274-8287-08d9f7dc7646
X-MS-TrafficTypeDiagnostic: MN2PR02MB6830:EE_
X-Microsoft-Antispam-PRVS: <MN2PR02MB683013FFAABDCEBF7EB71B65B13D9@MN2PR02MB6830.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46rdDkqNZjTLpa0bz/WtkYLlu7rgoaEjP0IUtBTq1+gf6YdffY63eI5Zw96Lqh7FvHUNNyXfggiUKvtZMWseAO8gXBeRDMf9SAEGfgQV4QuQubTueICfFOq27/WA9HZsaKA3/qlnxyrB5fp4h3dTJx4TixeKDon0nJzRgV7W0n/TSGtfzPEkHc8nmzryumWWbpJov1IoALSrSSTzJFFm7bIWkQtF1z7i7PGOrxGl+kWMEw32puEutgB80CPElJywfk6wfSaKhH+ra0eOENMhI8w6eJTUnlv91qckZpNylfh9qWZUseZFwwOgEycLL4LgvgtubVFAOi/NjprBMRLMJh7irYfX9amd8sbITlz2pdljW3elH9KoPxy+35uqzqQOPprBcYqxIlLxgwHSBhmdtNEsRA+B45P8DQfWJfLzYs/HwrmeyTFWw0N2gtw49rHDAwc0kKhvnZRHtjVOrK2DONn4KsKFJjilRdh7onb6I1P8cIggMAw9juVL0UbSSBHEpLreBcg0CdmKmEkKiWh5P+rXb7o0lLKZ889fvHkfFSCqixntxHOTl5Nlf3o6KxeIsCSr+pVJ7SQvSUTpbZbiyptLUnlWeJ5PHIZMEl42gzkE6ypGTf7ijtsxHzxRTS3MCfoxF2IOLtRqrm5xrw5tBx4FiVnS2ZchhHP4jKZBkenIo2yLpt6zxznGFnJQe3rwvTCL5bbvINfhsm3BOTz8EDqRc6dWIY3Xji5cQVjqxxA=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2906002)(4326008)(7696005)(508600001)(316002)(54906003)(47076005)(36860700001)(186003)(26005)(83380400001)(36756003)(336012)(426003)(7636003)(109986005)(2616005)(82310400004)(356005)(9786002)(5660300002)(6666004)(8936002)(8676002)(70206006)(40460700003)(1076003)(44832011)(7416002)(70586007)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:27:29.7896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 215f0a5e-6af4-4274-8287-08d9f7dc7646
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT052.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6830
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the support for virtqueue group in vDPA. This patches
introduces uAPI to get the virtqueue group ID for a specific virtqueue
in vhost-vdpa.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 8 ++++++++
 include/uapi/linux/vhost.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 733b305c5029..cfe57f0871a3 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -444,6 +444,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			return -EFAULT;
 		ops->set_vq_ready(vdpa, idx, s.num);
 		return 0;
+	case VHOST_VDPA_GET_VRING_GROUP:
+		s.index = idx;
+		s.num = ops->get_vq_group(vdpa, idx);
+		if (s.num >= vdpa->ngroups)
+			return -EIO;
+		else if (copy_to_user(argp, &s, sizeof(s)))
+			return -EFAULT;
+		return 0;
 	case VHOST_GET_VRING_BASE:
 		r = ops->get_vq_state(v->vdpa, idx, &vq_state);
 		if (r)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 8762911a3cb8..99de06476fdc 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -150,4 +150,12 @@
 
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
+
+/* Get the group for a virtqueue: read index, write group in num,
+ * The virtqueue index is stored in the index field of
+ * vhost_vring_state. The group for this specific virtqueue is
+ * returned via num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_GET_VRING_GROUP	_IOWR(VHOST_VIRTIO, 0x7B,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.25.0

