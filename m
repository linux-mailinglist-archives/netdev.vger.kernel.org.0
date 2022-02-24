Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6025D4C37B5
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiBXV23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiBXV2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:28:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561D6182BC3;
        Thu, 24 Feb 2022 13:27:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lW1VXrTVz5Q2pMKevvJnWTIdJlJW1i8Fu/feN9Iy48+npgaFJoZA8IgDPlGKRhQDp9bOogAGpTUVf3h2e2fx54dtMQzzCIbzRHcy/+QPJ127u9dCgTmy+/IkBl6VFQ3jwiUvixmZw/lvPrhhIwKcN+E95jZPwPvBSRwJ1P2LOQe36g9HR0N6v8DD9Sk0c6J288nTZ1KL0MjmvkNhOUwgA63ZJkn1EaBllHuOcVXRaXk0n1BnGqw3AOUnqUNmLfXO/vBwWiiUaUMFEYd26v1BOTD5QFYZpoaMF54APv+jXdiNXKfILsAtbXVhGC5YGdtjCBuJnS+KEsVnKKLtGdBXYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pw8FQn1Tmtp9i5XvFpIl2yHLN1b26+LA4Z57YTRCt9E=;
 b=GN32XL7hi/HfNsDUvO/GyOzB4nMy8AmAUSGTadlSRl9yNbxBSYIk6pLn5TiQ55P7DWEDMPfJFHi5Hmy7pkfs4BpMQm4y12ZXALKfM3F2dBs7SJKWZ4nnzu5o+1HgUgETUTJpLZ6gsx4Lj9AODaGEV86Y2lRnvQXxfo2nYQmYJ7wjJax9OcBOO4L8EHhCucvij4NBtqxrzA7bwplyIITAdl/SrgJ6C6+YAhWkVMkxdyeqcYt3+FDUsyCcVz6APgVEwP8xEFjMlvfuqx0BwyH8CxOmka9GUbC4uOFd+Vkmyw5y7mTM5WJigfYREKpa0HFlA00qO4IjTSr4CO/PZNB9iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pw8FQn1Tmtp9i5XvFpIl2yHLN1b26+LA4Z57YTRCt9E=;
 b=Abu3d8kBqEDIJQXXkzfu69+w1teUPUmcg+uv3D3dXJ51xUrTzirkeKSCTUZRy85LeJ4ISrg1ERaG+nmXP/KIwb6pQPhX2h581sPzHVGLqbl1tTTCPOPjSAKFwZ1TEaIEQmIdL/KpcJyqXEFjCxPsPrDW5ZcFsYbkLc1yKs0roA0=
Received: from DM5PR07CA0077.namprd07.prod.outlook.com (2603:10b6:4:ad::42) by
 MN2PR02MB6208.namprd02.prod.outlook.com (2603:10b6:208:1bd::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 21:27:49 +0000
Received: from DM3NAM02FT021.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::d0) by DM5PR07CA0077.outlook.office365.com
 (2603:10b6:4:ad::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 21:27:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT021.mail.protection.outlook.com (10.13.4.249) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 21:27:48 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 24 Feb 2022 13:27:48 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 24 Feb 2022 13:27:48 -0800
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
        id 1nNLeN-00095B-Kn; Thu, 24 Feb 2022 13:27:48 -0800
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
Subject: [RFC PATCH v2 14/19] vhost-vdpa: introduce uAPI to set group ASID
Date:   Fri, 25 Feb 2022 02:52:54 +0530
Message-ID: <20220224212314.1326-15-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220224212314.1326-1-gdawar@xilinx.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60add338-7f7e-44cc-13a8-08d9f7dc819b
X-MS-TrafficTypeDiagnostic: MN2PR02MB6208:EE_
X-Microsoft-Antispam-PRVS: <MN2PR02MB6208ED8E9F2666492AB0C0CBB13D9@MN2PR02MB6208.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6/cs664NclWU+5fMkMi9ZAJHFAolAfEMwX9oPAp7w2bUHhyuyur/Qz+MH9VsVbOqKMQE1/U8ch6mbCrXddZx6DuZVG7Fb2B0elo/Q5HBZYsjpNQQCTzO2YO4QoMo3GNQA8OqUq06rNpxFkKwdeCCUyjUlRRdxfjNeRAiyJX5pI4pVVxVOBBG59RQh16lBOoNkwJ76KTbT9HGsre55uvCL+FkI1ckN8HHhBGBRowMhCUZuQqZuhDK7DP6ZshdfoJp8d6L6G8OJp9ElvkcL2o/UqcsNKAnbQmGgA59U8GWanJ8jikEcYG6s5lF6cSBrB6a0yK308Klfa9vWm6ifwVVi8F/ruWDde3LIlGtrTzD5Yvyt5Jnja3OBDSd0jfRXicZVqJXqrgDKqpLEU5/mON7fTnixmRMaBR0LcTEda+Yuj4CbeWmrtm3SzEQ9sLcs5dNsf+bd1zysR5+LdL6O70MpNcE+mxuAYEd4KyOE1PpqUt1AZKpFqXSoh7FUFRXORsQ66iufOPK0ycIvPDAjkiE/R80lrvy1V30U5fUqHss1J8knFkPySkj7f6v4MH4WIkCTYAUcGd/SoGhIKSwwGgJ2tx1bqqcKHojF/X/uVNQ/e9Q+sAg5Cu9qWbM/1TaVnCqcj6rW4QGn+BreH/MfmoYtphUToiEuuMU4QZ/0CneGq8hcjpmPotHE5golSp6uTXYvxER/419IgQfb97jmUB+YeWxsecuqs59EZ7DA+K34Y=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8936002)(82310400004)(7636003)(47076005)(426003)(36860700001)(2906002)(7696005)(1076003)(508600001)(4326008)(8676002)(316002)(336012)(26005)(54906003)(44832011)(356005)(109986005)(5660300002)(6666004)(70206006)(70586007)(9786002)(186003)(40460700003)(7416002)(83380400001)(36756003)(2616005)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 21:27:48.7988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60add338-7f7e-44cc-13a8-08d9f7dc819b
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT021.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6208
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the vDPA support for associating ASID to a specific virtqueue
group. This patch adds a uAPI to support setting them from userspace.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 8 ++++++++
 include/uapi/linux/vhost.h | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index cfe57f0871a3..47e6cf9d0881 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -452,6 +452,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		else if (copy_to_user(argp, &s, sizeof(s)))
 			return -EFAULT;
 		return 0;
+	case VHOST_VDPA_SET_GROUP_ASID:
+		if (copy_from_user(&s, argp, sizeof(s)))
+			return -EFAULT;
+		if (s.num >= vdpa->nas)
+			return -EINVAL;
+		if (!ops->set_group_asid)
+			return -EOPNOTSUPP;
+		return ops->set_group_asid(vdpa, idx, s.num);
 	case VHOST_GET_VRING_BASE:
 		r = ops->get_vq_state(v->vdpa, idx, &vq_state);
 		if (r)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 99de06476fdc..5e083490f1aa 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -158,4 +158,11 @@
  */
 #define VHOST_VDPA_GET_VRING_GROUP	_IOWR(VHOST_VIRTIO, 0x7B,	\
 					      struct vhost_vring_state)
+/* Set the ASID for a virtqueue group. The group index is stored in
+ * the index field of vhost_vring_state, the ASID associated with this
+ * group is stored at num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
+					     struct vhost_vring_state)
+
 #endif
-- 
2.25.0

