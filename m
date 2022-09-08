Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590FA5B25F0
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiIHSgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiIHSfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:52 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA06EA43E;
        Thu,  8 Sep 2022 11:35:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQujTusmfEFmJ+ybup9IJiPYHrG9YMzJgXJNn9W+AypWq6SNHoJJbAmqyUwu7F73BiYhVs2pduJrX15pooT5tuLagQ0k2abcZUCGtBumdmptyAXDENhvfqA+t4mo4cAgPcASCvfJSEj9kpMHWYrY4dRgjCNecJ0Qky9iFJKALsZGcimTRaFBKLJ9dC81seGS6yAiwUhQlrMrA5HU4xNmfZROZLdJTM4ITT1H/MQ8PTY9w1BDgJ80LNjouHWbaH903Xf2rB12wndqHapGSBCsa4Fk4cuGhD0QWoMOAHl19NCS8F6cCQ6riTJq9YETDz7tzUmbfZID2rz9cDM5ncasLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=IN4k39Cy/DCvmMXt7LkRQIJ3PYh29Tiw9IuhVjDb5ZhyKAg/lbnAbd/LDCGmhJF8dMD9kv0quU66+8U8XBV9TJ7bzidHZWmmc8j0HboKtsncBuuyW5nFWqVYRQLq+jtNs6/bDVEzkZaVTRWG5Wy/X8J0wV41xzVztDATXEr6ePyHmRVBjTxoYo/P1tdJiFkaEJkzl4C1IxJPj+xxpE5XHEZblt+xz/nPm3mwi9d6NvbIrxx+4vvf3i7K+hd34LX276SrL9iZP8HlPO5/ipjQkY0q67G/mYMe5a8oDA9LJyhxbHeAe3BcTHn4bedLvbK3Sn6mennX2uIncsc88N99ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wb5B38pz2fgEyssjvA29VUF1xQ36PldquXyFPWiE7LQ=;
 b=Wb58/Knu7ivKmcUUr4B9k1qiKFamDA00IYNRbB5CF53hTWwhGJjJDDVcioHCCsVi8EZASrQNjrHlQxcQrfd1o0kXlbgc4O3W+aONJ9MS0HDmiHxp8+deW+omuV+QZkkEGjgxxVqAhA8jSoKkOrG3OUaHyVEoMMtyECN85qkjn4yMSUQNm9rKmsmzM5Zvqa0aCGAF6h4wVUfAHl6EZ+cAvnuiDOUAw5sUqJfwfDJYRVVydk8i2DkPS89Owi1j6jnMIlFz2sDnYnWjH5Q4xJ6rsXSCQp9XfdT9cBr1NGaQS2QwQdzOGt0d5z8DguzJPnNPe7mw0GMKFNvNmmaadQhxJQ==
Received: from SJ0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:33a::8)
 by PH7PR12MB5687.namprd12.prod.outlook.com (2603:10b6:510:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Thu, 8 Sep
 2022 18:35:49 +0000
Received: from CO1PEPF00001A5E.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::5a) by SJ0PR03CA0003.outlook.office365.com
 (2603:10b6:a03:33a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1PEPF00001A5E.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.11 via Frontend Transport; Thu, 8 Sep 2022 18:35:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:40 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V7 vfio 09/10] vfio/mlx5: Manage error scenarios on tracker
Date:   Thu, 8 Sep 2022 21:34:47 +0300
Message-ID: <20220908183448.195262-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5E:EE_|PH7PR12MB5687:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cf64e77-6f0a-461b-a5b6-08da91c8f265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BW2WB3Cd4Rq9sPdYQe91QfLyvuFGe9SIoajMJRWBf3MpsucjL+4YgO00S/TPCbwxg1pdzRXOv3x1kKSEIzEA+acgXxZJxvvGJHb20KVTyyITdejETKUyb1QZh3ygmedF1OFOl2oe+ETP7h6OfPlR1J9HMarBifokmMzBCJwcOFZOpUsJOyF9j1+LWrK/wWw8uWpGwc+KzlXDKnQInj1n6WBQgLOkkmzi3LbWWBp+56SheOts0u6ySX4ILM8IfP6gkWTJHcXLMUjW7R7hineB1IUGatKlmLJMMj6P82aMr7mKHKhb4ldTSEj9SxITDrCqjzZFUFn6HblUB4QfEmsMdBI8b7Ln4YQ7mUFoHGp25E/twnJXrwFSVNx2vKgksEhMi5975xvHQ+mHO3tKxLPV3FPELsZSXosGivQOo7A8Yw3z1o7HB/anNgsbw73b9BbC0SavCG7Dsgza+5igH2Z8NZx4Trl5T27H5ddbfNW4dHIQj7dQxxLMM0GIQJPMUbcfwuP7EUq/pKHgJRD0pzLMqo/MEqIXRQY4Qd0+dqLImwgW1yzq+WcVV0pKEOZp2DM5HVGoplI7QcTMIapm1UCD6jY5HBm7Ke1ScJnnGynLZcdvmG3UJKtisr83sVF/NV1b1BGTrDGbhnb5/EP1htXAkEjjz+vH2dU/A1ljhXkiBRzi9eeYDD1Y1r3RfjxFzOi5LDQu047vKcTyjqak7IqLIr4YfgBV92ABOtI8jWs2YhctAmX12ZEXPo6vTk0HzsbnbaS6w6CK24ifTLLxCYgG6PUPcQVmf3LhG15NOTxOGM0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(346002)(36840700001)(46966006)(40470700004)(6636002)(70206006)(8676002)(316002)(4326008)(40460700003)(110136005)(70586007)(54906003)(86362001)(356005)(36860700001)(81166007)(82740400003)(8936002)(41300700001)(2616005)(2906002)(7696005)(478600001)(5660300002)(40480700001)(83380400001)(1076003)(47076005)(36756003)(336012)(82310400005)(186003)(426003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:47.0393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf64e77-6f0a-461b-a5b6-08da91c8f265
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5687
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

