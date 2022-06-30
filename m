Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7AD5617FA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiF3K1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiF3K1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:27:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF45BC1D;
        Thu, 30 Jun 2022 03:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvVlVbzuSvaScx3agBizP3ZoLgP9sdR3Ug+BSRp6A/bVeiOAlzHVl0FCNcnNRgUMdGbcmr5Zi/fU/32MpjFoHEnS0Kd6grT45z3F0t8J7DvAm/33NPPocGP6VJ56i+rkmU0kPYrsHi7EEM24MoMOfK9XLMK6iXf+85FKNtL1YDvhkhYaQN/nYugPzfl6xkAfzhkYZTIIgbzE2fyJVGlbbpwgwng0pFDAT12HxL88uiRVjZ9JlH0nZQT73/kd6OpV+afFwEQxykyx78oq0rItt7edTVp2vhJQ01rt/PhCTO78O9+/vUO1FUn5Av1AiMSqkxlN+q0cI/lWy0KLpY61uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=WRz5Okvbj6H7wPEe4yfIFh2KTwV5wMKHV3EYNYi4JH/dytK7/6ODy1LJc6/+GlI9v76m21QtUGOUTUU6m8axDPnfoPaxW+fA1dqqPsZhJY5cbZkQKb0z8ghH55sLnV87POWnmO6T+ZxwM2nj3HPQpXyO0Zoid87Pn62IRxv9wqnODgrVwm2mEMr62mFHsOXGA7i8kEHkzOnqlCDxiqY07XRAPAtyfo6/+Y6ETA3sZe/Nu5pSY5rSQErlc93BUUJpTI9Wf77CqOB0K1/rGf55YCQqFFlbNeIx0THnkhLJkhlGBVy16quc2o7vlnPbR05cN75Ve7cvfzgprCxqt3NUOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=eEFKb9Ie/7qpC8lDi6tGFBcYBoh3OK7hNnpql9n+XqMsKwokfKWvCuYzXi1/xkiZFOM/vxjU1l4ZeUmHv7kEqvYTgYlESrdZVl/WUIrAVoxF9WtqflAsZqLwYGmqVd4X0UXfderCsQ2/bx3jMXnCOSlWjvnV/9gKJ4qtKjid4zTvHP/sspnSijIVe2fomj7IclwpSDuaD3gnlPWVAVUPqPTyHgmD8i4kl0H3RGKQz+kEZhHp1zaFd8tneR11sVcExnc5kpk9NO5nhzETiFJHWxFZhVXccNBGIdygGAUmC1G0pYtpDo+gBbTEqB/2C2wyrAU7taUp11OVRDcvBhOPFg==
Received: from BN9PR03CA0501.namprd03.prod.outlook.com (2603:10b6:408:130::26)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 10:27:11 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::95) by BN9PR03CA0501.outlook.office365.com
 (2603:10b6:408:130::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 10:27:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:27:11 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:27:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:27:08 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:27:05 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 12/13] vfio/mlx5: Manage error scenarios on tracker
Date:   Thu, 30 Jun 2022 13:25:44 +0300
Message-ID: <20220630102545.18005-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e00ea3fb-dca3-48ce-6c28-08da5a8317dc
X-MS-TrafficTypeDiagnostic: IA1PR12MB6164:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BatnxOVzpk2R/kbzh98adWma/M2uzGeqEICh+OQ7ifu7dUwOmMKJMHWEX+cY2KaWii/3MNy2++yrkzlhaNGiW4OVONM8XCYFrIxyYa1NPeqdg5aZ0hhJfXeNX12fiUqPdK96lOfwayE28NE8pFsdEEV67siABuE23DeH+5zEmEr/JkF6QiCI41qQHTwDMkT+jnXMetH4WkiW3LFbSAKojKDmWL8bU2Ii6tyQZMqS4ZH3CTHEeI+O27PkCSglEmZxU5oBXh1eOLVDLXkwhqp+s2bnj3KMD3DCDiYmdBEy34BiftenFnrrFyXLcyt/VQRUlO51H5BCQjAHmp8tquZ+8h6HgC2CGyyS+xX6oWzThcOXHwnTiBY/RPjdfHgJp8AdgXRQoY1u+hard260jhhzEyBNE9IKt+O/Abt0cDkuZ4DGn1c/4BdowouA5SqOdeF465OrezzPlXx2zj7jXZvFeuOQNoZIz+ZcJU6Vaba/ru6IVGTzx5dE+3tvUEqhJQFQauqPvDlcR4//sseV4jpkvR/YpWW20f7OKX9wCL1NHb2Y5HfBAICAO837/TpCiJsXWE04ss8xCaSGZ+VD7uVgqgVZFmli8KFiT5npHpRF5mgSlWLbFNZdXlp+8R1Ffrhn45e74L0HUPsuQYFayMqKqK+uKzsfmqAxv5pCdRZZhHt+WrWy4jxzDNOwVzRIcHvd2UfQW8YlwlVn4763mpflzlxwqqgDo6zXdaDywB0Ssy44odqLxGPGMpkrmKpcOMenoaAv1X0a+3FaIpNN5ghTil3b7apOtEEsU52d3tuXQHRxGrMcshLrGlb1d1jK9tLO1JJ7X6YyBMgHQRpA7t+JpKXVOg0y0MaOfrF5h3jlDWY=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(39860400002)(376002)(40470700004)(36840700001)(46966006)(2906002)(86362001)(70586007)(4326008)(8676002)(6666004)(478600001)(5660300002)(70206006)(81166007)(40460700003)(7696005)(8936002)(82740400003)(6636002)(316002)(54906003)(356005)(336012)(26005)(41300700001)(186003)(1076003)(83380400001)(36860700001)(2616005)(36756003)(426003)(40480700001)(82310400005)(47076005)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:27:11.2165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e00ea3fb-dca3-48ce-6c28-08da5a8317dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

