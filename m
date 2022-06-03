Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E753C8CB
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbiFCKee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbiFCKeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:34:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30693BBD7;
        Fri,  3 Jun 2022 03:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4HlarIpLIFCHRInCpH7bkhV+qzo425reumCCclrP2zLziQJz20w8iFfzFB8Ah2Pv4/lArSrJf+yqpkq+dVB7wMmLFjK9Wl3yWnxc3yqFvtIH+dJErIYcS++LCNqi+eMy0F7/poQ0tLYCmXiQsoIrMNn4S37cK0ghsLAse7xdKZnZ03LaBZvjvCOcoyT6vACtCYPxyQaPZKMZzvBJQqC1GxnJwJHLUP/DSQwSOMaFYV3nmMY8L4vYD6nnPgcmKlhZHt545IFevaf2k1gyvsA2NRfjtcNa7hku0C0fNM8FIHPEyRZrKR+0N5qmBc1CBAYeVjGUIs7l43OQBu9ntDQsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgwYhsR65y/yzeFXK3fOiWTvc39y5w3Id4LgiHtIEPs=;
 b=W2KMJm7QRxZlHrZfNsDD9GVWhRgJpxjXskiLSaLfXXh9oVvz3f+Gu35ALCgwdEpAvRwwLK6CYbYfBsl1NSvl7or83s/5mE14jLhhktJ1F1L9MTSLoVnaumY4o7ObeyE6PW72zKDCb15FZekIbh+xokvgvJJ8R4JAl/lYbNVPRGRTCK0JsKtLr0iv6ugL6Fqz2kf2JHFxkOD6jpDBiZjupCS1R21fPJZZ6K1LWFuUg5v+ynucLqQAo/IdAItLw3kHHtY+b8RJL+8mhjasrtCE4xshULzxq66mTB+lkvTdq0T9ChWTiLgSp3Smkmnvlm035WFbjakIaxkE/WObeGZkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgwYhsR65y/yzeFXK3fOiWTvc39y5w3Id4LgiHtIEPs=;
 b=h1SvCYTQqnnMeBdOnexV2gbi2hbriMJQVTiouI5LOXSXarw8bSrmWKxwFm6Cigjth2Nzh5pAO2lHZqYeImGgheNlp+/VVbpVhgcTab9W5Kqk5LzIDBp3dvmyof+C5dm5agrgkihX8MAKsyjg4KFHInja/7b91X1A9YLjcJkJUGo=
Received: from BN6PR19CA0091.namprd19.prod.outlook.com (2603:10b6:404:133::29)
 by DM6PR02MB3980.namprd02.prod.outlook.com (2603:10b6:5:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Fri, 3 Jun
 2022 10:34:28 +0000
Received: from BN1NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::a8) by BN6PR19CA0091.outlook.office365.com
 (2603:10b6:404:133::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Fri, 3 Jun 2022 10:34:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT064.mail.protection.outlook.com (10.13.2.170) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Fri, 3 Jun 2022 10:34:27 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Jun 2022 03:34:26 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 3 Jun 2022 03:34:26 -0700
Envelope-to: gautam.dawar@amd.com,
 hanand@amd.com,
 linux-net-drivers@amd.com,
 xieyongji@bytedance.com,
 lingshan.zhu@intel.com,
 virtualization@lists.linux-foundation.org,
 elic@nvidia.com,
 parav@nvidia.com,
 dan.carpenter@oracle.com,
 si-wei.liu@oracle.com,
 jasowang@redhat.com,
 mst@redhat.com,
 sgarzare@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org,
 wanjiabing@vivo.com
Received: from [10.170.66.102] (port=45770 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nx4dO-000Fld-A9; Fri, 03 Jun 2022 03:34:26 -0700
Received: by xndengvm004102.xilinx.com (Postfix, from userid 4129)
        id 62DEE4121C; Fri,  3 Jun 2022 16:04:25 +0530 (IST)
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <linux-net-drivers@amd.com>, <hanand@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] vdpa: allow vdpa dev_del management operation to return failure
Date:   Fri, 3 Jun 2022 16:03:38 +0530
Message-ID: <20220603103356.26564-1-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4898223-c6ca-44e6-5705-08da454ca2d2
X-MS-TrafficTypeDiagnostic: DM6PR02MB3980:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB39802F573780FCD00ACAB129B1A19@DM6PR02MB3980.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7l+l4AG0SlgU17tA6UQEC2Fd6LmDcmI+SkGEIHYVi9/6QyLCi05LNC6SpfNmqz+DreUUCNvlKUqwEI6C7b80mDoIHdqrx/LXMtNLgu0bHv/YAFv7Bgz7LfQo+MTzo7ujU32yKfwmtz8StfIVD8BgKhOAr0UB6SPu7oDN3sIYWdSlGMWiSeUi3xx8RqKvCXJKD7gIqsmw2Le8tSWfSGlRjlj2vCZYMyrqrWVJFQDrjsRqCI9jxXCa0tOIVKghTS5zjjSX0HGOc4bpgX/IGt58dQuT1ZvU/OTzf8nhd6P8TGIEZBlFc9M6npneQ+Bg2nkO5MCMof/nEgl9F7gl9GxtzHtRCauGKj63HofR1ZfLOuxG3jxqMF6BvXYl/HhoefG4zudvgieW23yRSX1A63XVhssG120zim1HzPeV7lYN501v41yt5euaTK1emcbnvr77OIAM6bwkTzDo5p4Ja3tuWlGFTKo/nRTVGCEB3I6EmFLJUXEznW82MUOykLMhRzw0AR5FWk+lGTlS4Y/rQKbY19Sq58u3ib84iu20vf0Z6NhzhztiiMuXdI9kWPDj8oU/OtHyUtU4m9tET3+eYTREfQGmbnoAH5ZKAq5lBUBiMXbrijF0vS4CvFuWFi2Le+937NBM4mkElrMzT8OrovixABSWeF+HW+ZDnaaaotvVEXIkOLLaYCEiBnwSbai4EMRphCP9mS6jACrGy9lmNssMA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(508600001)(4326008)(8676002)(2616005)(6666004)(2906002)(42882007)(26005)(82310400005)(1076003)(5660300002)(8936002)(6916009)(6266002)(7416002)(83380400001)(356005)(47076005)(42186006)(36756003)(54906003)(186003)(336012)(44832011)(316002)(70586007)(70206006)(36860700001)(7636003)(40460700003)(83170400001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 10:34:27.6465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4898223-c6ca-44e6-5705-08da454ca2d2
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT064.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB3980
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the vdpa_nl_cmd_dev_del_set_doit() implementation allows
returning a value to depict the operation status but the return type
of dev_del() callback is void. So, any error while deleting the vdpa
device in the vdpa parent driver can't be returned to the management
layer.
This patch changes the return type of dev_del() callback to int to
allow returning an error code in case of failure.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c      |  3 ++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |  3 ++-
 drivers/vdpa/vdpa.c                  | 11 ++++++++---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 ++-
 drivers/vdpa/vdpa_user/vduse_dev.c   |  3 ++-
 include/linux/vdpa.h                 |  5 +++--
 7 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 4366320fb68d..6a967935478b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -800,13 +800,14 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	return ret;
 }
 
-static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
+static int ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 
 	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
 	_vdpa_unregister_device(dev);
 	ifcvf_mgmt_dev->adapter = NULL;
+	return 0;
 }
 
 static const struct vdpa_mgmtdev_ops ifcvf_vdpa_mgmt_dev_ops = {
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index e0de44000d92..b06204c2f3e8 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2775,7 +2775,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	return err;
 }
 
-static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
+static int mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *dev)
 {
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
@@ -2788,6 +2788,7 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 	destroy_workqueue(wq);
 	_vdpa_unregister_device(dev);
 	mgtdev->ndev = NULL;
+	return 0;
 }
 
 static const struct vdpa_mgmtdev_ops mdev_ops = {
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 2b75c00b1005..65dc8bf2f37f 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -363,10 +363,11 @@ static int vdpa_match_remove(struct device *dev, void *data)
 {
 	struct vdpa_device *vdev = container_of(dev, struct vdpa_device, dev);
 	struct vdpa_mgmt_dev *mdev = vdev->mdev;
+	int err = 0;
 
 	if (mdev == data)
-		mdev->ops->dev_del(mdev, vdev);
-	return 0;
+		err = mdev->ops->dev_del(mdev, vdev);
+	return err;
 }
 
 void vdpa_mgmtdev_unregister(struct vdpa_mgmt_dev *mdev)
@@ -673,7 +674,11 @@ static int vdpa_nl_cmd_dev_del_set_doit(struct sk_buff *skb, struct genl_info *i
 		goto mdev_err;
 	}
 	mdev = vdev->mdev;
-	mdev->ops->dev_del(mdev, vdev);
+	err = mdev->ops->dev_del(mdev, vdev);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(info->extack, "ops->dev_del failed");
+		goto dev_err;
+	}
 mdev_err:
 	put_device(dev);
 dev_err:
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 42d401d43911..443d4b94268f 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -280,12 +280,13 @@ static int vdpasim_blk_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	return ret;
 }
 
-static void vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
+static int vdpasim_blk_dev_del(struct vdpa_mgmt_dev *mdev,
 				struct vdpa_device *dev)
 {
 	struct vdpasim *simdev = container_of(dev, struct vdpasim, vdpa);
 
 	_vdpa_unregister_device(&simdev->vdpa);
+	return 0;
 }
 
 static const struct vdpa_mgmtdev_ops vdpasim_blk_mgmtdev_ops = {
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index d5324f6fd8c7..9e5a5ad34e65 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -167,12 +167,13 @@ static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	return ret;
 }
 
-static void vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
+static int vdpasim_net_dev_del(struct vdpa_mgmt_dev *mdev,
 				struct vdpa_device *dev)
 {
 	struct vdpasim *simdev = container_of(dev, struct vdpasim, vdpa);
 
 	_vdpa_unregister_device(&simdev->vdpa);
+	return 0;
 }
 
 static const struct vdpa_mgmtdev_ops vdpasim_net_mgmtdev_ops = {
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f85d1a08ed87..33ff45e70ff7 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1540,9 +1540,10 @@ static int vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	return 0;
 }
 
-static void vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
+static int vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
 {
 	_vdpa_unregister_device(dev);
+	return 0;
 }
 
 static const struct vdpa_mgmtdev_ops vdpa_dev_mgmtdev_ops = {
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 8943a209202e..e547c9dfdfce 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -443,12 +443,13 @@ void vdpa_set_status(struct vdpa_device *vdev, u8 status);
  *	     @mdev: parent device to use for device removal
  *	     @dev: vdpa device to remove
  *	     Driver need to remove the specified device by calling
- *	     _vdpa_unregister_device().
+ *	     _vdpa_unregister_device(). Driver must return 0
+ *	     on success or appropriate error code in failure case.
  */
 struct vdpa_mgmtdev_ops {
 	int (*dev_add)(struct vdpa_mgmt_dev *mdev, const char *name,
 		       const struct vdpa_dev_set_config *config);
-	void (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
+	int (*dev_del)(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev);
 };
 
 /**
-- 
2.30.1

