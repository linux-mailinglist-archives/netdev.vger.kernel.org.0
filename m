Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BBD57467F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbiGNIPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiGNIPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:15:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3953C8C2;
        Thu, 14 Jul 2022 01:15:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXmNrr4sdqRW1dZJONlaf1nSY8X3X2wloBoblqVYlHeX8Ai+76W+zlHe/ob4dGAXLEOPnMGah+uqzmc5/3HDAk49vVpILdo11MgDaFx1vVDEhfzk2Wu4slDMXu3+mSHXMpSDWyp1FctEtJNDs2lHcPccFIKExYBLJQsbD+33lv66Jp0zxPXTnmbFHxJUGaQ2czCPbPdZEYUMJ/cx4Pmyz22Yco10oRPesxv0R0UKc/fQ1gWGjM2H6a39qxc4ZWPptWLPwC5enHsbob8M45E1meBN6pKXA6k7EErLNA/P2R+c9AdXAQF6qu/RnikzGzwubSYv2RBtJ5sSc14Nhwkmgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=TAyrtMns7nMgTaY8tZguNfW9KE00GQVQU+q8g5Hsmqhczu1ziEjzQ9wNJ/D4ukm/rbvI+hlZ2u7VywZCRUec15rJvbFddC/I+/Skwv+1Ct78cNZCKLpyUf32T1+CBdaosikiME+n90YPrRlQUp8mtjOUx4n3xC6s3VyqHQwAJZr2hJLSDrs3/UtPOC7TO+LKetuzs3qCIczotavSM4sY0T7qPhUEDymQtiej6hfDupx3H8+YrwCC+xvMYfPLsOriWY1SRg5bkoOIECCDQSXm2a3kVHguv19KS/UQiyn5K/RIiGK5ww87cHEvDpK9kfbQrwXnkO2YYBiTp9IXMtxp9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=drIg5lzPfQSn/EP4Lazf1/udlC2M6ZgknqBaUu7LtjfmSHdIDEgW35p/XNrmx6+3+v9Kn1f3vcVK4hkbY5SPviC6Bf+T3NhQaoKvWbsKRo+zeHefDGpmgn6g4Aa1Pa3hF/fELZsU6a3tPvLieZtqzCIAJPlpIL2sV/rob/kaa+u4zamQMDliso4S/pGGsHI9wBwMebYepTkqPRj0lClY6pwzQKucgkyeNALDJzvtrAwffQl/Bogy66vCQtoinbdco0MO5XJOrW1btbShTrIk5HJup/Aov0Rotn63xrbps2nvooi8Vm4yFy2PCGSLyDmc+G/dRsbSXkXPWycwX2IZXA==
Received: from BN0PR02CA0024.namprd02.prod.outlook.com (2603:10b6:408:e4::29)
 by MWHPR12MB1663.namprd12.prod.outlook.com (2603:10b6:301:e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 08:15:01 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::1e) by BN0PR02CA0024.outlook.office365.com
 (2603:10b6:408:e4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Thu, 14 Jul 2022 08:15:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:15:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:14:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:14:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:54 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 10/11] vfio/mlx5: Manage error scenarios on tracker
Date:   Thu, 14 Jul 2022 11:12:50 +0300
Message-ID: <20220714081251.240584-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbe9be93-0939-45c5-679e-08da6570f283
X-MS-TrafficTypeDiagnostic: MWHPR12MB1663:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saspAHUWV89YG1z+Ug0NmEQ36ZqDwcxdENj2GJ42cVWW3sDJYc8bq8kebmgvo5DzzzAmF4cRGeCbKwxIk2Lv82eT2UqSldnXccJpTCh1RXNjoFTF9J1PQyklvAHTk2FLOZKw+HHUaCkEgH989pzHeqetF/D3y3/uJPx4u87XK1I01mYlgff2rb6IQwRK5cXQw+XX+LDX2SuniixcTB4rfXkSpy/8DqC6nz8CkFYJbhwNFsKzcpEMt3phRbg4pfktybt9MxTblVb5cAZ19NWITF691rogzq7mTOFTz9BOhhcGtsI+yFEQpAA40yACkl9rF3I6ywa/rMSIvgj+tEwx4eslpjxw9IqrH3anXpE4keZdX3vxlFbX3/We/ChVB3lUkOp6RucSMbyj8WienFfLELmpJRZNAlk1Hlyt+lSIeDTwColCERYZBgh9J1diyIf7nYgjD3T9qMJFwDaHX4blA3cGoG19Vjh1xVtLUnTy7cNSCEX+6jif7kknienBrzcp5YRwOKjOX/0HXSeCvKjSWQfjfU5sLgnoVQIK2EZ40bO76M6PP6Q7B0Ai59C1qRFGtuRfwfiuqG0pxX1R4r25j1DWaTKv5EvsaOucArc6ZUK32BVItsFFOAwbKxDmTtsffqt3/ifbQ4ail+lZ79TsBtdpvHgH5CkMUwM2iwIihhkyNU6wTyutI4imt1fDgJkmDZ8y4w2Vq7O7/FWDj8eb6hK9jWq5Za11g/4d6JKD7mcWQGsNbKNJ31w7T7A6uuRGqZ3jKHBxNdgkGrwKfHoyKe0Wb5H5+o3BZQdTBejfAm+msoWWffCBtSkrIgClAYSwfWPppfisMy2qjRjGvJbjkW0T0jzGXVoyMLZVlCkWMP0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(40470700004)(82740400003)(83380400001)(336012)(426003)(5660300002)(40480700001)(186003)(36860700001)(81166007)(54906003)(47076005)(70206006)(36756003)(356005)(110136005)(316002)(4326008)(7696005)(8676002)(8936002)(70586007)(6666004)(1076003)(26005)(86362001)(478600001)(41300700001)(2906002)(40460700003)(2616005)(82310400005)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:15:00.3755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe9be93-0939-45c5-679e-08da6570f283
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1663
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle async error events and health/recovery flow to safely stop the
tracker upon error scenarios.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 61 +++++++++++++++++++++++++++++++++++--
 drivers/vfio/pci/mlx5/cmd.h |  2 ++
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index fa9ddd926500..3e92b4d92be2 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -70,6 +70,13 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 	return 0;
 }
 
+static void set_tracker_error(struct mlx5vf_pci_core_device *mvdev)
+{
+	/* Mark the tracker under an error and wake it up if it's running */
+	mvdev->tracker.is_err = true;
+	complete(&mvdev->tracker_comp);
+}
+
 static int mlx5fv_vf_event(struct notifier_block *nb,
 			   unsigned long event, void *data)
 {
@@ -100,6 +107,8 @@ void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
 	if (!mvdev->migrate_cap)
 		return;
 
+	/* Must be done outside the lock to let it progress */
+	set_tracker_error(mvdev);
 	mutex_lock(&mvdev->state_mutex);
 	mlx5vf_disable_fds(mvdev);
 	_mlx5vf_free_page_tracker_resources(mvdev);
@@ -619,6 +628,47 @@ static void mlx5vf_destroy_cq(struct mlx5_core_dev *mdev,
 	mlx5_db_free(mdev, &cq->db);
 }
 
+static void mlx5vf_cq_event(struct mlx5_core_cq *mcq, enum mlx5_event type)
+{
+	if (type != MLX5_EVENT_TYPE_CQ_ERROR)
+		return;
+
+	set_tracker_error(container_of(mcq, struct mlx5vf_pci_core_device,
+				       tracker.cq.mcq));
+}
+
+static int mlx5vf_event_notifier(struct notifier_block *nb, unsigned long type,
+				 void *data)
+{
+	struct mlx5_vhca_page_tracker *tracker =
+		mlx5_nb_cof(nb, struct mlx5_vhca_page_tracker, nb);
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		tracker, struct mlx5vf_pci_core_device, tracker);
+	struct mlx5_eqe *eqe = data;
+	u8 event_type = (u8)type;
+	u8 queue_type;
+	int qp_num;
+
+	switch (event_type) {
+	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+		queue_type = eqe->data.qp_srq.type;
+		if (queue_type != MLX5_EVENT_QUEUE_TYPE_QP)
+			break;
+		qp_num = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
+		if (qp_num != tracker->host_qp->qpn &&
+		    qp_num != tracker->fw_qp->qpn)
+			break;
+		set_tracker_error(mvdev);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 static void mlx5vf_cq_complete(struct mlx5_core_cq *mcq,
 			       struct mlx5_eqe *eqe)
 {
@@ -680,6 +730,7 @@ static int mlx5vf_create_cq(struct mlx5_core_dev *mdev,
 	pas = (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
 	mlx5_fill_page_frag_array(&cq->buf.frag_buf, pas);
 	cq->mcq.comp = mlx5vf_cq_complete;
+	cq->mcq.event = mlx5vf_cq_event;
 	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
 	if (err)
 		goto err_vec;
@@ -1014,6 +1065,7 @@ _mlx5vf_free_page_tracker_resources(struct mlx5vf_pci_core_device *mvdev)
 
 	WARN_ON(mvdev->mdev_detach);
 
+	mlx5_eq_notifier_unregister(mdev, &tracker->nb);
 	mlx5vf_cmd_destroy_tracker(mdev, tracker->id);
 	mlx5vf_destroy_qp(mdev, tracker->fw_qp);
 	mlx5vf_free_qp_recv_resources(mdev, tracker->host_qp);
@@ -1127,6 +1179,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	if (err)
 		goto err_activate;
 
+	MLX5_NB_INIT(&tracker->nb, mlx5vf_event_notifier, NOTIFY_ANY);
+	mlx5_eq_notifier_register(mdev, &tracker->nb);
 	*page_size = host_qp->tracked_page_size;
 	mvdev->log_active = true;
 	mlx5vf_state_mutex_unlock(mvdev);
@@ -1273,7 +1327,8 @@ int mlx5vf_tracker_read_and_clear(struct vfio_device *vdev, unsigned long iova,
 		goto end;
 
 	tracker->status = MLX5_PAGE_TRACK_STATE_REPORTING;
-	while (tracker->status == MLX5_PAGE_TRACK_STATE_REPORTING) {
+	while (tracker->status == MLX5_PAGE_TRACK_STATE_REPORTING &&
+	       !tracker->is_err) {
 		poll_err = mlx5vf_cq_poll_one(cq, tracker->host_qp, dirty,
 					      &tracker->status);
 		if (poll_err == CQ_EMPTY) {
@@ -1294,8 +1349,10 @@ int mlx5vf_tracker_read_and_clear(struct vfio_device *vdev, unsigned long iova,
 	}
 
 	if (tracker->status == MLX5_PAGE_TRACK_STATE_ERROR)
-		err = -EIO;
+		tracker->is_err = true;
 
+	if (tracker->is_err)
+		err = -EIO;
 end:
 	mlx5vf_state_mutex_unlock(mvdev);
 	return err;
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index fa1f9ab4d3d0..8b0ae40c620c 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -82,10 +82,12 @@ struct mlx5_vhca_qp {
 struct mlx5_vhca_page_tracker {
 	u32 id;
 	u32 pdn;
+	u8 is_err:1;
 	struct mlx5_uars_page *uar;
 	struct mlx5_vhca_cq cq;
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
+	struct mlx5_nb nb;
 	int status;
 };
 
-- 
2.18.1

