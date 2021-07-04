Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FE83BAF17
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 22:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhGDUzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 16:55:09 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:20256
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229993AbhGDUzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Jul 2021 16:55:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICktUMPpMMWd02v8GZveevsUrec1wWphPIZ5KZDq9RUiyPMIjRhjaxxFQkWKNa2pxUf6WPsOO+JYkfJL3y7VjZHCPzAnCzGQo7D4irNmQm9BWZ2hvNY9OdwrSxbAd74TxdcY/VaqMh804w87M5/ruaBdzFFQYdN7W28V1Egp/9bXUbiG5+7YohUDI8ponfGSNoQCnSaZpfE8s62SbSy1nHR4HzkdYX6D0uQqbSeC3wHpVgrLCjRIjBxazRmAmKy3nHjt1cYPtczuqNSG+0u/XWF7xiqWRDd1ZMPVsslM4MbxjuEz4QokseXpvrG7Fl5itB+SS7XK0CPnle3O9ks34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqcPIFQcyNyr/HkunJOg7peb6T4Uizzxa/iiUu/K0/o=;
 b=An9k/2sbMLQpglAYpDWI/n1YGg/c0zTGV8IWxwhUGcyfAcyRb9oMfrBH4ZN4zTyghzpvsCiY/Vxj+zjxNjpNM+lqeSnj9ai0gWMI3VU2fpJrzfOjvnXBvt9u/VkPnB3E7BVUHxN0Byy1u0l7tGNaKYrdfEMoaEp9B/z/lPFYmGPzk8c0wRChQUGFGLCoEUvKyeZMLGf6qdHtbqTytoyXRa8sychBRJVuiqsDK4hpTvvRPi0BP5RZr0eDe4cv7bsx/B+Vh9oQKAjVqWcJfGWvucaIjC83DShLKSEsHlQDjpzWde81CkUfB+xbPSuPwahanF25uBwZmho18zGw/HVVew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqcPIFQcyNyr/HkunJOg7peb6T4Uizzxa/iiUu/K0/o=;
 b=Et57EfZ6RgCkYg9HTowlvpDGi31Xtk6lm3CoCYwrZUQJXaH7YS8FEh/KVXWYi2p2JTHyss+NMhZJoZ/rm57gO3TyNSgYdOuxmHCAG6rE9d9WAVSGRMulRYBjHlxPoYV6cybCnaYzmgiJK8Sh4C4FFBbdYte9bUIS6lNp4jv2nsc=
Received: from SN6PR04CA0089.namprd04.prod.outlook.com (2603:10b6:805:f2::30)
 by BYAPR02MB5974.namprd02.prod.outlook.com (2603:10b6:a03:125::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.30; Sun, 4 Jul
 2021 20:52:28 +0000
Received: from SN1NAM02FT0040.eop-nam02.prod.protection.outlook.com
 (2603:10b6:805:f2:cafe::4c) by SN6PR04CA0089.outlook.office365.com
 (2603:10b6:805:f2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend
 Transport; Sun, 4 Jul 2021 20:52:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0040.mail.protection.outlook.com (10.97.5.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4287.22 via Frontend Transport; Sun, 4 Jul 2021 20:52:28 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 4 Jul 2021 13:52:28 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Sun, 4 Jul 2021 13:52:28 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Received: from [10.177.4.102] (port=43696 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1m096J-0006NY-Lq; Sun, 04 Jul 2021 13:52:28 -0700
From:   <gautam.dawar@xilinx.com>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <gdawar@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] vhost-vdpa: mark vhost device invalid to reflect vdpa device unregistration
Date:   Mon, 5 Jul 2021 02:22:04 +0530
Message-ID: <20210704205205.6132-1-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1132d640-530c-46fc-ce7b-08d93f2da2de
X-MS-TrafficTypeDiagnostic: BYAPR02MB5974:
X-Microsoft-Antispam-PRVS: <BYAPR02MB5974DC012FB7AEBD552EB078B11D9@BYAPR02MB5974.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IumzZknY8CfSm8rLoXTfTJrtknARJ8DlhKdlA/eKyIhKAUqaLYEbXHimVq+daXV38szfnl64vM1KXpoQqqv4uIcwHHz74REqquc7MqUnPLQniz147/go54aUlAKk4SyfsrgH6+awI8Gfu+uPTIwZsSYDE0O9uIbyLC4iFs5ifHYbHaTaUESfL+TsW7paLsLyme+XhmlFkUznwoCec2Cx744tHS70pb4uDjGo+8qKiR4XdsRwyC0yL3KJjoM7+7iXYl8DakHi+T2JvUIpN7PB4SKNc3m/QEEJbHvJJQ4QywiGgknMeEQa1aLd1ZLxKFI4pHAcOQX1A+pjMKmr8pKkOrMkORJx5BJW0M9/XbInSmPWOdE3NNAK6iCdTkJe0nOz1HZmCxpgXm8iwv7DNuLHvciW4u66d/LFnXrZqQXQ1SuLA9INhZ3p4ZnTSswJRRDk72eTbAMw0N21tbis3pcV7Ax7L6udkxh55yJ4GTnpMP1ijaxCNTnFIINTKa6qZs6D3bnZaBQ4DkZQHtPJVX7s9LBorgM+ukoD6+S/d78r93d2XaILS7uzqHyz3cnln9G+Tg3ezJGQPY2hVNDZjkYS4KQKTPtAc8GVW70GmUhr6bddOwq+stS0cj1lT1Zmkl8+P0iU9uwVtW+0Hv2xa++xA23lUH5g2/rmrI+nO17+ElJaSaNcMN3reBATZc5Zwwi/OufAkoLAZ/frf8Tzg7G1ffmhNI5H7YJU8aPsjqKT2TsHg8jBJwCG/ryYitRW/5ms
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39850400004)(346002)(36840700001)(46966006)(4326008)(82740400003)(36860700001)(70586007)(83380400001)(8676002)(426003)(5660300002)(54906003)(82310400003)(2616005)(186003)(6666004)(36756003)(70206006)(26005)(1076003)(356005)(9786002)(109986005)(7636003)(36906005)(478600001)(336012)(2876002)(316002)(7696005)(2906002)(8936002)(47076005)(102446001)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2021 20:52:28.7435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1132d640-530c-46fc-ce7b-08d93f2da2de
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0040.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5974
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Dawar <gdawar@xilinx.com>

As mentioned in Bug 213179, any malicious user-space application can render
a module registering a vDPA device to hang forever. This will typically
surface when vdpa_device_unregister() is called from the function
responsible for module unload, leading rmmod commands to not return.

This patch unblocks the caller module by continuing with the clean-up
but after marking the vhost device as unavailable. For future requests
from user-space application, the vhost device availability is checked
first and if it has gone unavailable, such requests are denied.

Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 45 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e4b7d26649d8..623bc7f0c0ca 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -47,6 +47,7 @@ struct vhost_vdpa {
 	int minor;
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
+	int dev_invalid;
 	struct vdpa_iova_range range;
 };
 
@@ -61,6 +62,11 @@ static void handle_vq_kick(struct vhost_work *work)
 	struct vhost_vdpa *v = container_of(vq->dev, struct vhost_vdpa, vdev);
 	const struct vdpa_config_ops *ops = v->vdpa->config;
 
+	if (v->dev_invalid) {
+		dev_info(&v->dev,
+			 "%s: vhost_vdpa device unavailable\n", __func__);
+		return;
+	}
 	ops->kick_vq(v->vdpa, vq - v->vqs);
 }
 
@@ -120,6 +126,11 @@ static void vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
+	if (v->dev_invalid) {
+		dev_info(&v->dev,
+			 "%s: vhost_vdpa device unavailable\n", __func__);
+		return;
+	}
 	vdpa_reset(vdpa);
 	v->in_batch = 0;
 }
@@ -367,6 +378,11 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	u32 idx;
 	long r;
 
+	if (v->dev_invalid) {
+		dev_info(&v->dev,
+			 "%s: vhost_vdpa device unavailable\n", __func__);
+		return -ENODEV;
+	}
 	r = get_user(idx, (u32 __user *)argp);
 	if (r < 0)
 		return r;
@@ -450,6 +466,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		return 0;
 	}
 
+	if (v->dev_invalid) {
+		dev_info(&v->dev,
+			 "%s: vhost_vdpa device unavailable\n", __func__);
+		return -ENODEV;
+	}
 	mutex_lock(&d->mutex);
 
 	switch (cmd) {
@@ -745,8 +766,13 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
 
-	mutex_lock(&dev->mutex);
+	if (v->dev_invalid) {
+		dev_info(&v->dev,
+			 "%s: vhost_vdpa device unavailable\n", __func__);
+		return -ENODEV;
+	}
 
+	mutex_lock(&dev->mutex);
 	r = vhost_dev_check_owner(dev);
 	if (r)
 		goto unlock;
@@ -949,6 +975,11 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	u16 index = vma->vm_pgoff;
 
+	if (v->dev_invalid) {
+		dev_info(&v->dev,
+			 "%s: vhost_vdpa device unavailable\n", __func__);
+		return VM_FAULT_NOPAGE;
+	}
 	notify = ops->get_vq_notification(vdpa, index);
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
@@ -1091,11 +1122,13 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
 		opened = atomic_cmpxchg(&v->opened, 0, 1);
 		if (!opened)
 			break;
-		wait_for_completion_timeout(&v->completion,
-					    msecs_to_jiffies(1000));
-		dev_warn_once(&v->dev,
-			      "%s waiting for /dev/%s to be closed\n",
-			      __func__, dev_name(&v->dev));
+		if (!wait_for_completion_timeout(&v->completion,
+					    msecs_to_jiffies(1000))) {
+			dev_warn(&v->dev,
+				 "%s /dev/%s in use, continue..\n",
+				 __func__, dev_name(&v->dev));
+			break;
+		}
 	} while (1);
 
 	put_device(&v->dev);
+	v->dev_invalid = true;
-- 
2.30.1

