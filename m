Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB81585F0D
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237304AbiGaM5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237185AbiGaM4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:53 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E4F11C17;
        Sun, 31 Jul 2022 05:56:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLt859lzdmQow624ZJKfx2Ebsobf5Zhb1tz+yAaA5wJUXxyvn7ugNJv5TUpLdyxM8W9g6y1imTOdOqcbAJHKapCthX5vKc1acYMszh57k35I5w+sejDsjsjDnNthiQ8OCCf2JJcws/EaYHcqPMv88ALei7E0CVoC5/PgofuzOV2GaM/Ks0lmZXEagSEGblRqAYwvpMXINapOu0JsdCbhE7jXr1vUBC+fr5Ty1oLvN3MbRvOmDtraIFoiTk1ko/Ety5/5C42f9/nfFjuOpCZfGQoKI4Ka91MStIXBss+CEuJQy3R4LUp+71EiI5Y3a36IIEh9FPpV1kKtRT402Mum8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=B3BCOHw/oRLt4na0dZBdFFZAemjS7XkmLE+2QZw8Kcsf+Qtccz+QwRjAH/XxNLTlAf/XdFgwS/Pmjlj5HYH84PNO3BBKsa8PyDsfXXTZkQHoaShs8VRWIT9MKOm2MlCzbqlDuIAfrLIFu6OlaD4wDExwauHDa6Cf2gNJXz9A9gyH0aDTfOnoF2mZ4Lm3zCmt3UEAPsAWLyfdhsKNDcHYEaOBX4YE5K/doG6So/CRm8B2/QH+V1N3jBaiCwboL+uwNx/THgZ22Q+OV48Jzm61nA8gXdAWFkg92yizk0nsa3T3Gqk/Xy2PdZwVGJhwrUgvKuodMgPWZcxKALPrFdKjZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=tKfKdJzUS6qRqUqvW+t5MXw1i+/0Zn0FIrAiVegIRYdRJ5RK0lwSAr0KyTtNKEbQCK1+37VtnbX12wP1ztsxWbX7VO9wGwo8PPOZN+wEmQzMJ8pEMp+oLtgW3salP39ZVP4p8wY16z29jjWTk3H/ghw8VvmE4OX5DZruE982K025FYBLO+61xidPFjjut/Cmu6laIK2q+3zy/ScGFSUdekCd0FGl7cYfd8Xs/DpIayCGwmPZsZVcBWMlVIGHh6lNcwGvF0DemciDOHSgyS5dBzAqwbEfFO0mXbfMYeQq1Jhyx6/llgXad6wG8Q2Q6vgc8T9hqHhb+h240U4zt+TbBQ==
Received: from BN9PR03CA0457.namprd03.prod.outlook.com (2603:10b6:408:139::12)
 by BN7PR12MB2706.namprd12.prod.outlook.com (2603:10b6:408:2a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Sun, 31 Jul
 2022 12:56:34 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::e) by BN9PR03CA0457.outlook.office365.com
 (2603:10b6:408:139::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:33 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:32 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:56:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 10/11] vfio/mlx5: Manage error scenarios on tracker
Date:   Sun, 31 Jul 2022 15:55:02 +0300
Message-ID: <20220731125503.142683-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d47535b-7c98-487a-c404-08da72f418ff
X-MS-TrafficTypeDiagnostic: BN7PR12MB2706:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6U9pn5qbFBEcqQ06FYA0pDFe8HLW4/oyNWoH92TNAJOqPG7qmMgt52JbcQSDF8Kf6RG7GnPXNvaXjKewGaiHTw633aUe3q3gqTDFbU9h5ljnijT7Vlh0VfJ4i2nGPTfwfz5VtLG9ap3Gd/cTblzFd42KekAcoVGTGn5z/7pcKCr/PF2WyC6R8CWX2gmNX2hCwQcPaWJzLXXYpExODm+5POThvlqzEZvXLuRy3X4XtZBfe8SultmH7VKo8bCzOwqJJj6XnWrolX3fecASBnzdqW4xMmb+7kXKKBwq/3IEm8N3RGGfzVgChPTZ2sRsZbIcmst2ZwKk8sRbfdBZ22x6eCsg5IJhcnr7KdKl+ZJrs4ovFwuX/TYoHdjKZ2BOByAVzgWeLpafrb9hzv+ToAxYqgavJ4ghuaRF7pNDZ/RA4AW+ADBoIfkqdygm2MHggB0Mab5PGYx4LSqce21Py1WSv9mk+dJl+b/iD4EtbSvPfOu4tvZQzIQKjF+Pwwygsrkldlx5vex4lQ6HiWYgU7x1TkrFV1YU6uSL/f3zTWSczHu94kHCeYJtm9AhluDQoVVUZbaXp+Vg90uZ6vhzzIkAzWqbB+Ou30jEo8Ppd28HU1/PqsrtcOBdOJqEkFVr9t+xL5bKNGTgSruzhLoxnJm/zG4Ag668DHvJoAkStFQr45S+wRpPlZ2fen6g9zkq8yITgUPPqswxI8n2evsAF63sOTU3hCXRQxJ7FS8ewT2kyC7YgIcrqtkBTj1i2/hGtUo8GQaFeb6MaJ79o4775KLwiXL8lH3tI/OTus2mDddN8bJXP4HxwDeG/tc4avNDcQFWr1HYPqPnnjxNrILhPdwag==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(39860400002)(40470700004)(36840700001)(46966006)(6666004)(478600001)(81166007)(7696005)(36756003)(4326008)(70586007)(70206006)(8676002)(82310400005)(86362001)(5660300002)(2906002)(8936002)(40460700003)(6636002)(54906003)(2616005)(36860700001)(83380400001)(1076003)(316002)(40480700001)(356005)(336012)(426003)(47076005)(186003)(41300700001)(82740400003)(26005)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:34.1785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d47535b-7c98-487a-c404-08da72f418ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2706
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

