Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D085A9367
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbiIAJlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiIAJl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:41:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C78134D5E;
        Thu,  1 Sep 2022 02:41:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhpxZbctLWgi6MHL8Z2xw4moDuuhilO3aD3ZTsy3hMUD2o5LH8HsJ/NMUJ0bVPqJPuds9IP6DJiWzfpGcHj1Ce9USYtR/0fPwYQbEKpe9/SyioDLCRydYY6d3fC8b5VzU++UKiHyWVuzqhX3VlaZaM+wtJhCpqn72J893IEUrJ6+fXBq8Vjv4HeJFTMt02/KsW8ceqZJQdNp2tMgeCW6TLwXwPeDskm6t5q5ExB0CqpQlIgaeZgMRR3MtwTLxTP7Dl0eMEFqDTPgwOQr8vMaFUiFR72PXgUoO2Kwl5hanGTDuINnuQej7ZhB18oWWZ6cNa5ECYH7BTzBl45SDgA6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=EL/kxapx2+4teoJAQh3oV5cve++BKRd8MIfry8STtyetU9RlzOiew6/vXbmY2YGfM/yLvOFbTEIvgeBOZCjGLIUMgKJYOq3VkG+qMc9PaAo25J0Cxe8hKBh00JIY5MzcEJrEZM1CDuEGdEl0I6NF6Mv7Efp9YX6zajPPMnxfOyDHyK5ed1QuJkw8gEDZ2G10o4TZKavkf/PJmCA6M76DEKNelU7zZxi9GzhudXi/mCB+d6d/tIoyZEw7gU/Ts5OzeekN5gk0xpGbof//+uuyffV5JBmfPJtSdE17FaxZ4q42xEypsxR5k/JHxTtDKOS2Uq8h1UII6QAs9zYbOMyBjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=LBXEqiwvquuXG69RIogCuSZBnW0QmXkwLdHYh41SvKu/rizJTmdhv2/e4CZ8hUTLEtw1FK+or/ZCt/pHihUW5UsCn0ixrkFq0Zk1CPHy56hIzFNEDm/sktj7ZiYE0oDGRceXw9bRyq/PzVShOsRb2Mk/3QC4/6FL3VbzvohICl7VxMva4PjpUNrIXM4veSdBcBweXqcdhwEhd9EAbxdCRqE1o/MyB8mFOHgs1oT27Kr1HxMR8i/ktnfCOjtkZAPF7yqwrKqVeF/0CFEKnyPUh7nRX/P7tgnukB4rxPtrqMtgrAdZqSaDXWiep2yAKeq4DFwNmXuKWIU135K+jdjz7Q==
Received: from DM6PR07CA0040.namprd07.prod.outlook.com (2603:10b6:5:74::17) by
 MN2PR12MB4504.namprd12.prod.outlook.com (2603:10b6:208:24f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.11; Thu, 1 Sep 2022 09:41:25 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::18) by DM6PR07CA0040.outlook.office365.com
 (2603:10b6:5:74::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11 via Frontend
 Transport; Thu, 1 Sep 2022 09:41:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:41:25 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:40:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:40:59 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:56 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 09/10] vfio/mlx5: Manage error scenarios on tracker
Date:   Thu, 1 Sep 2022 12:38:52 +0300
Message-ID: <20220901093853.60194-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220901093853.60194-1-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2352e6d-618f-4300-e317-08da8bfe234e
X-MS-TrafficTypeDiagnostic: MN2PR12MB4504:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kaprqvaac8eU+7Kbvj0ZrRGfndAN4p+kWXAmN/WApLQ6HGL2P2cwNXoHFwxJWXfg5TglMmz8E0rR0nL2v4JHFJzTZeHQd8WQoOpMKLlzhLf+sknt3Aa0RtqHJiXbAKQVJPpKc1RYZvjrJC4ZqKtGXdu7PHGg+spC1GUkkJZ/Q42NeWj7zxjJxLvVV1jTd+hBVtEUyY7NxP+bjw6qflrJlSkOGPLdE7AxrflShQQYNlcxKZCX+YF2bh8oulVwG89YjLTzux/8ZMq8CmW9T9eOoXJW4DZGcQu5AWUXo8GUYsMeMqj4MANQOr2adJWRzLyzgcSkqI39Fom17YJZ6mrgsb1EKQaOkHWga9KO/8YMARTFwdIXK5xYR4p9BjGPmrY01cPIsRhD95eIXcBWPPq/iQD35H4DYX5B7cSf9yicmzIqEKFQMqNCxMblhy2e2IjfWfN9qddOtQ/+x0JIlDf4mOwxQsXPFfNr7G5ekjBHQZg6QY5m3oZXHlKO2Ts+gBpCyQZD46Omchdej7M6Vh3fG1zB3dRwEr6UKtmrowz10sy+lMYE0VjP6MDB5mLDPeV79PNdUDHcH/dG9ZcK/d1VcICTh2bzlY0B76Y612nLV/3lw+5otK45d+4oz3b1Gzyt5ER3+M1rpMGyo6fuCTvJeU2Fq00GLx/h8iuBxlr0gpA+7fVh06/9/+4GW8gzuPlX/Ci3T8WeqEhWieUPZHznHtdTjLKsK4UNcgGmmu5vU1YcuWmMtIEF99Fjw7CnSBhw+7PJfrWqAAZIrB78FUloFcTGtkue6373np6Y87ALJi4=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(40470700004)(36840700001)(46966006)(336012)(426003)(47076005)(1076003)(186003)(2616005)(6666004)(7696005)(81166007)(356005)(41300700001)(86362001)(26005)(40460700003)(36860700001)(83380400001)(82740400003)(36756003)(40480700001)(5660300002)(8936002)(4326008)(70586007)(70206006)(8676002)(2906002)(110136005)(478600001)(82310400005)(54906003)(316002)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:41:25.5423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2352e6d-618f-4300-e317-08da8bfe234e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4504
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

