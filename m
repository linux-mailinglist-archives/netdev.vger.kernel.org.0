Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E2D521033
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbiEJJGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiEJJGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:06:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A4E24B588;
        Tue, 10 May 2022 02:02:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvKoL+BdkixcBPLDM5hpzl1jndLXY2kTE+HABVR/+uDKisT8DaA6v9cj/B7stvEByi8fvq5dFMj/SzlUhOH+P0DJNBH+JiVZE929s57oG9Vi7ip7FaK9tLrzNtkAJsh3nuBrKz+L19WzTkKGzsvbYOcO+EynwK5pRLei25+4D2QcEN313rXuxILiTx0puP766lA55Bmyb2fb/p+LM/YVPP94l9J2IqwmsmhR97HLJumfz+U0yYs7qczFDV2gG9GWlTkMxHheydVI70SWUfEAO5CFdWMOjSV6N5LY+lAa0VA9g6oAwOornAlAVMkvhJZuxN29e0agMrgCx0dxUYUaUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsB/g29+hUB/3wHT+yRuIHfpFFBxJ237nWeKOCN7SRw=;
 b=GrsmiuGOKHf8xyM9XE85mushgSlMugtaAWCknesySi2NgiXPekrIWbS3ugKX8NAegXh46u0TiKLfePpS+X+X/llwApajBHtRfSH3wAlnJxYT8gUmM0EwrmsuWzHrC1mk/qUWYlQibiOj2e1xZJSC4JxuxKCyPCTzI5Zz8T8oQmC9Gf2Wga/v/Epb7UJhWSnVdoGTJA0mJq0iXKpD8gOYhgjKjzhOgbM0B3qTolUkDffHENQn7fr+BU1ASf9EwXJtHLEPrZBeGQmXL7xmUV70f2/iKz+yatYOygvsrkvYL/CTfy+KCT5mV8fJx4elAhD7IRN1ZHDI9okzL509pFoV9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsB/g29+hUB/3wHT+yRuIHfpFFBxJ237nWeKOCN7SRw=;
 b=hJt4WQZ5k44gfvwEoSWVdQFWnbKaUJIGzTTN2a7zAwGj2KC9O8NXLV+pfkBJWCeHRgPHdNUsnfkHDWnCsxZReZDt0R6NzT/to51YXsXkMwh2lsKMJgnZnoQslWLFp6DjbXTo7oOJQBZzeDuY1AYWiaYwCmZW6akBevU52lfAxiAx61tYavnU2OjIqp2UcGeXgq2aq5/BbyXEeMGr9gDIuxddC6AWgJF+ciH1RQj+2WggEhGHsRd2znwIpeHczOz7a7M6zOteZZ43L0rSqK8+npRzrH6zm9eLCvp5I+as5DEEo4xgoqkVfK/881LXRwS1EEDntyrE7NZOXrUJq143Vw==
Received: from MW4PR04CA0116.namprd04.prod.outlook.com (2603:10b6:303:83::31)
 by BYAPR12MB2807.namprd12.prod.outlook.com (2603:10b6:a03:6d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 09:02:33 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::b4) by MW4PR04CA0116.outlook.office365.com
 (2603:10b6:303:83::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Tue, 10 May 2022 09:02:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 09:02:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 10 May 2022 09:02:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 10 May 2022 02:02:32 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 10 May 2022 02:02:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 mlx5-next 4/4] vfio/mlx5: Run the SAVE state command in an async mode
Date:   Tue, 10 May 2022 12:02:06 +0300
Message-ID: <20220510090206.90374-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220510090206.90374-1-yishaih@nvidia.com>
References: <20220510090206.90374-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ad776a9-0b32-432d-ac0b-08da3263d215
X-MS-TrafficTypeDiagnostic: BYAPR12MB2807:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB280754182181D15563770AE5C3C99@BYAPR12MB2807.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+7gPlOb81S47zwApWXGMlQPIGgstrgcpGCzK5uw0aLNkfRCd38rLsPnT+NbL3H/IYYiZtvwxqQcG6xf3pcqpspvRmNaGon/AU4+Z4slWQR+fCuKOkAKVIAnXWRPJVIrhYH2ho2JCYcO5C8qhE8Yc5BB0f/A5BQp3nRC1Ud92O2tf8uFFK40Tqm6DoBHjFRItInuACJ1my2j7XjWZQk6YWN8MaP/Bppt+9MYlDQ2eBNTUjiFDQMZqjpiDDEyXETQzvuiFHiy74chEAjRfM+QD8nwrxVlPnQVsO99ApSOlnQ/g4QenQ8zoXdx75x4qwwIPQAN5OU1wuveIa1vDXw0GhxiKC38GsjjXR7dowWqFmBRo6DIrp/Qt3wHZpdiB80vla5nY+vsLEWwik1PvNIi1nIJJERMlP07g4h22Y0bpiRRHF61UOB/QMtxm9pNA1EZewc7GOUeGPUxd3yXK2dashOn/54TIyYPMQeJZjiYgTvdNkBEUWFY54Ng+vjsX5SjQPNSfHquIdkFUTUdamx4GhAFZ/WYNikoBxFOGkHOLGSazEBYpQWAxJLWxRvvNHcB8uKHiDLHHtA20BOzzAj1IbaP0T9wTVB24Ab8ZuDNqQaKt6dbflHmKMINGswqBpgLo8LMpfWUuOIxvuYxUwPwaNhHBrL1QHTSwHRm3+21ZVA6bWs85/juHAgGQpNSDO9XlTa62F0sxfFbFpycji5qnw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(4326008)(70206006)(70586007)(1076003)(8676002)(40460700003)(2906002)(508600001)(86362001)(26005)(316002)(186003)(8936002)(36756003)(83380400001)(47076005)(336012)(2616005)(426003)(36860700001)(6666004)(7696005)(81166007)(356005)(82310400005)(6636002)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 09:02:33.2570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad776a9-0b32-432d-ac0b-08da3263d215
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2807
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the PF asynchronous command mode for the SAVE state command.

This enables returning earlier to user space upon issuing successfully
the command and improve latency by let things run in parallel.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 81 +++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/mlx5/cmd.h  | 19 ++++++++-
 drivers/vfio/pci/mlx5/main.c | 40 ++++++++++++++++--
 3 files changed, 131 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 2d6e323de268..9b9f33ca270a 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -78,6 +78,7 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
 		mvdev->mdev_detach = false;
 		break;
 	case MLX5_PF_NOTIFY_DISABLE_VF:
+		mlx5vf_disable_fds(mvdev);
 		mvdev->mdev_detach = true;
 		break;
 	default:
@@ -94,6 +95,7 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 
 	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
 						&mvdev->nb);
+	destroy_workqueue(mvdev->cb_wq);
 }
 
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
@@ -119,13 +121,19 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
 				   &mvdev->vhca_id))
 		goto end;
 
+	mvdev->cb_wq = alloc_ordered_workqueue("mlx5vf_wq", 0);
+	if (!mvdev->cb_wq)
+		goto end;
+
 	mutex_init(&mvdev->state_mutex);
 	spin_lock_init(&mvdev->reset_lock);
 	mvdev->nb.notifier_call = mlx5fv_vf_event;
 	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
 						    &mvdev->nb);
-	if (ret)
+	if (ret) {
+		destroy_workqueue(mvdev->cb_wq);
 		goto end;
+	}
 
 	mvdev->migrate_cap = 1;
 	mvdev->core_device.vdev.migration_flags =
@@ -209,11 +217,56 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	return err;
 }
 
+void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
+{
+	struct mlx5vf_async_data *async_data = container_of(_work,
+		struct mlx5vf_async_data, work);
+	struct mlx5_vf_migration_file *migf = container_of(async_data,
+		struct mlx5_vf_migration_file, async_data);
+	struct mlx5_core_dev *mdev = migf->mvdev->mdev;
+
+	mutex_lock(&migf->lock);
+	if (async_data->status) {
+		migf->is_err = true;
+		wake_up_interruptible(&migf->poll_wait);
+	}
+	mutex_unlock(&migf->lock);
+
+	mlx5_core_destroy_mkey(mdev, async_data->mkey);
+	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
+	mlx5_core_dealloc_pd(mdev, async_data->pdn);
+	kvfree(async_data->out);
+	fput(migf->filp);
+}
+
+static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
+{
+	struct mlx5vf_async_data *async_data = container_of(context,
+			struct mlx5vf_async_data, cb_work);
+	struct mlx5_vf_migration_file *migf = container_of(async_data,
+			struct mlx5_vf_migration_file, async_data);
+
+	if (!status) {
+		WRITE_ONCE(migf->total_length,
+			   MLX5_GET(save_vhca_state_out, async_data->out,
+				    actual_image_size));
+		wake_up_interruptible(&migf->poll_wait);
+	}
+
+	/*
+	 * The error and the cleanup flows can't run from an
+	 * interrupt context
+	 */
+	async_data->status = status;
+	queue_work(migf->mvdev->cb_wq, &async_data->work);
+}
+
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf)
 {
-	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
+	u32 out_size = MLX5_ST_SZ_BYTES(save_vhca_state_out);
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	struct mlx5vf_async_data *async_data;
 	struct mlx5_core_dev *mdev;
 	u32 pdn, mkey;
 	int err;
@@ -243,13 +296,31 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(save_vhca_state_in, in, size, migf->total_length);
 
-	err = mlx5_cmd_exec_inout(mdev, save_vhca_state, in, out);
+	async_data = &migf->async_data;
+	async_data->out = kvzalloc(out_size, GFP_KERNEL);
+	if (!async_data->out) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* no data exists till the callback comes back */
+	migf->total_length = 0;
+	get_file(migf->filp);
+	async_data->mkey = mkey;
+	async_data->pdn = pdn;
+	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
+			       async_data->out,
+			       out_size, mlx5vf_save_callback,
+			       &async_data->cb_work);
 	if (err)
 		goto err_exec;
 
-	migf->total_length = MLX5_GET(save_vhca_state_out, out,
-				      actual_image_size);
+	return 0;
+
 err_exec:
+	fput(migf->filp);
+	kvfree(async_data->out);
+err_out:
 	mlx5_core_destroy_mkey(mdev, mkey);
 err_create_mkey:
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 94928055c005..6c3112fdd8b1 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -10,10 +10,20 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/mlx5/driver.h>
 
+struct mlx5vf_async_data {
+	struct mlx5_async_work cb_work;
+	struct work_struct work;
+	int status;
+	u32 pdn;
+	u32 mkey;
+	void *out;
+};
+
 struct mlx5_vf_migration_file {
 	struct file *filp;
 	struct mutex lock;
-	bool disabled;
+	u8 disabled:1;
+	u8 is_err:1;
 
 	struct sg_append_table table;
 	size_t total_length;
@@ -23,6 +33,10 @@ struct mlx5_vf_migration_file {
 	struct scatterlist *last_offset_sg;
 	unsigned int sg_last_entry;
 	unsigned long last_offset;
+	struct mlx5vf_pci_core_device *mvdev;
+	wait_queue_head_t poll_wait;
+	struct mlx5_async_ctx async_ctx;
+	struct mlx5vf_async_data async_data;
 };
 
 struct mlx5vf_pci_core_device {
@@ -39,6 +53,7 @@ struct mlx5vf_pci_core_device {
 	spinlock_t reset_lock;
 	struct mlx5_vf_migration_file *resuming_migf;
 	struct mlx5_vf_migration_file *saving_migf;
+	struct workqueue_struct *cb_wq;
 	struct notifier_block nb;
 	struct mlx5_core_dev *mdev;
 };
@@ -54,4 +69,6 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
 #endif /* MLX5_VFIO_CMD_H */
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 2db6b816f003..df8b572977da 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -134,12 +134,22 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		return -ESPIPE;
 	pos = &filp->f_pos;
 
+	if (!(filp->f_flags & O_NONBLOCK)) {
+		if (wait_event_interruptible(migf->poll_wait,
+			     READ_ONCE(migf->total_length) || migf->is_err))
+			return -ERESTARTSYS;
+	}
+
 	mutex_lock(&migf->lock);
+	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(migf->total_length)) {
+		done = -EAGAIN;
+		goto out_unlock;
+	}
 	if (*pos > migf->total_length) {
 		done = -EINVAL;
 		goto out_unlock;
 	}
-	if (migf->disabled) {
+	if (migf->disabled || migf->is_err) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
@@ -179,9 +189,28 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 	return done;
 }
 
+static __poll_t mlx5vf_save_poll(struct file *filp,
+				 struct poll_table_struct *wait)
+{
+	struct mlx5_vf_migration_file *migf = filp->private_data;
+	__poll_t pollflags = 0;
+
+	poll_wait(filp, &migf->poll_wait, wait);
+
+	mutex_lock(&migf->lock);
+	if (migf->disabled || migf->is_err)
+		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+	else if (READ_ONCE(migf->total_length))
+		pollflags = EPOLLIN | EPOLLRDNORM;
+	mutex_unlock(&migf->lock);
+
+	return pollflags;
+}
+
 static const struct file_operations mlx5vf_save_fops = {
 	.owner = THIS_MODULE,
 	.read = mlx5vf_save_read,
+	.poll = mlx5vf_save_poll,
 	.release = mlx5vf_release_file,
 	.llseek = no_llseek,
 };
@@ -207,7 +236,9 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
-
+	init_waitqueue_head(&migf->poll_wait);
+	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
+	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
 						    &migf->total_length);
 	if (ret)
@@ -218,6 +249,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	if (ret)
 		goto out_free;
 
+	migf->mvdev = mvdev;
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf);
 	if (ret)
 		goto out_free;
@@ -323,7 +355,7 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	return migf;
 }
 
-static void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
+void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 {
 	if (mvdev->resuming_migf) {
 		mlx5vf_disable_fd(mvdev->resuming_migf);
@@ -331,6 +363,8 @@ static void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
 		mvdev->resuming_migf = NULL;
 	}
 	if (mvdev->saving_migf) {
+		mlx5_cmd_cleanup_async_ctx(&mvdev->saving_migf->async_ctx);
+		cancel_work_sync(&mvdev->saving_migf->async_data.work);
 		mlx5vf_disable_fd(mvdev->saving_migf);
 		fput(mvdev->saving_migf->filp);
 		mvdev->saving_migf = NULL;
-- 
2.18.1

