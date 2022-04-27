Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04465114C4
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 12:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiD0KSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiD0KSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:18:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6224654D7;
        Wed, 27 Apr 2022 03:14:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLLhGExSJ8HoeyR8bUweaCSRRiZ3T6RbPVAFAKIK5FjeBc7jkRSxdrl/Lz109MwUm9pUTJqnZJEFKfi6bX/fKBCGeMAx6+8/K4NlKQkshiH8GaNea0DSs8hQNHnQWQ6BotXMlzF+EkbWvJ1TUIFKW0ZebxOBkolsaTNKgv5xu3Netygat3OkLj7QYSXmU3POqnIGQUMUsvAdJEknXe/IMvR/82qyhlAWMzXYByeT1RQdS4RRqfrR1ga63ovfNZzbdKhThf9+wUhQ0hImeSJa8Ip+9v99A/hk6dg3LBFZTR+X+/iQxb0wBomHlIKWX3JloXptf7HnCfrsbMoxzuQyog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nz51Y8Mb/GtNzzufM609MljkjPUTgeagwUbrFLkPI0=;
 b=U6u6U7p5pAsDkTvhRLgG/hQEvDIoCFGuqiyE1V9xfGrZgh8GlkqXU3tCPP3a/04veRf4RHsyGHz5S/wWXYI+Xc4ygw5QtYylK7FZ8fP8mBlwhs/IISIWb6Tr5x+um0CiWISSz6+wMXjeNqTn3H/iQEV3no6uIt1roy1h539wyh0kZMwldV0PDjjls4x0+j044Ow1ijmHVX8RoHB03te759jU5XJQWzs6Bw9sCdtxZO8IlVspttqhupfCxnOLmAwiB2ChXzC4dl/wQXzIZh0AD3mDFaTolZ00MJXTmPaWRhy3xcMMfJ8ITFhhIyjIFF8ja9DAqyXRK+jgEDSHXWWGIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nz51Y8Mb/GtNzzufM609MljkjPUTgeagwUbrFLkPI0=;
 b=O2fDt5huerG0q55Yw/QfC1h2rOEM4liOyIDdYNhS/RXFV6z21FdfrjOq5ZER+UZ5LiQRX6edRJ2v6aoVczPXroIIIap++L7EjajRrTibDWc/Nm44v2FmqowfzW9ZYgO/xeeSNHte+JeHZOOVFCB8AI1uzdGhcMgEnLeyTz01qZAtvOsq/89SKBo71/0tMeJ781eJIDcFcFxI28dPTCX9RejGIghwslrdVaFUZz9Y/1gO6UEYTql7TngmZrKq9YdJw0moWZNEUwyF+1Ow+6i7x2pWxZkNF4JULBK6vfxaQf5JeRUdPu6HK1qwpr4t4QjVUvsvTPlZKBTVnoWIl6DyGQ==
Received: from DS7PR05CA0075.namprd05.prod.outlook.com (2603:10b6:8:57::16) by
 CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Wed, 27 Apr 2022 09:32:12 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::77) by DS7PR05CA0075.outlook.office365.com
 (2603:10b6:8:57::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Wed, 27 Apr 2022 09:32:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Wed, 27 Apr 2022 09:32:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 09:32:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 02:32:10 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 27 Apr
 2022 02:32:07 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH mlx5-next 5/5] vfio/mlx5: Run the SAVE state command in an async mode
Date:   Wed, 27 Apr 2022 12:31:20 +0300
Message-ID: <20220427093120.161402-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220427093120.161402-1-yishaih@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b78c76-6a3f-4b2a-89a7-08da2830cecd
X-MS-TrafficTypeDiagnostic: CH2PR12MB4277:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4277E0E258D6651D7FC1C88DC3FA9@CH2PR12MB4277.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9yIDVpY3hGtirVlz2yQVKBMwvaFz67UNGp7VqabJz1tf2Scfg2zh16bHREOtcaVkxhou+KsU7I/97JqCBhouTbxka80JF5JHhBo0u/Fo3WgQq4iFLDb39ldhPoZcejUriL7ymWtzBXGTkA7dsezQoUleDF1OUhNA/6j6bP8+6NV+LIMq9GPQo51pq22IsSd4UpcT6Axy7PezH+sX+c9rd9BvQ//ZeDOmlV6u0yDXxpR/w1sUQgrIw71wnGJ06xFDbxVJsMqq0sdcUtYvbjWM/xJW2mY+ucA4NdTsxJe9kornb4WvnQTIVDlxas/3rIvvE0yRnND1N0rOroKLvFZqbVF62gQZqPVEtANqcFnvDwvU9Wnb2A1ApSRnhCNCA29cx0H1qTypOR9Zz4u1k4JL4zp30R+Sv3fuRI2UmOXg0Z25kDcJbNUU8E6arqwSIa4jnNllrqGfSenvBohDKkMVdMoglnZXXQAdMWBVkkfsOGVlWBB7mWTrdxke9SXdC9k8IcTiv0Qv48nDy9tROzsa/Bp7+uu9db1FT6pAXcuZX/wKZUhKZWYgyU5Pgwb/4rMFQtzQDgIWB8g+BvNHqENtDZsgTdNnEcE+R8WRIf/JxlyX2gE8bYNr3BCt1nPN+bMJF8QnN2pJ4zini60U39RrV+OrnfKeo23TERGMhRjU2l8w4Y5ZDHYSRn9OwSPZ6LzO6mlmlvC0DRulbakoJxpjQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(426003)(5660300002)(7696005)(2906002)(336012)(2616005)(186003)(1076003)(8936002)(36756003)(83380400001)(26005)(82310400005)(36860700001)(110136005)(47076005)(4326008)(6666004)(508600001)(316002)(54906003)(6636002)(70206006)(40460700003)(8676002)(81166007)(356005)(86362001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 09:32:11.7902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b78c76-6a3f-4b2a-89a7-08da2830cecd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/mlx5/cmd.c  | 72 ++++++++++++++++++++++++++++++++++--
 drivers/vfio/pci/mlx5/cmd.h  | 17 +++++++++
 drivers/vfio/pci/mlx5/main.c | 54 ++++++++++++++++++++++++---
 3 files changed, 134 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index ba06b797d630..fad648d0c088 100644
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
@@ -209,11 +210,56 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
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
@@ -243,13 +289,31 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
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
index 3246c73395bc..f8f273faa5a8 100644
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
 	bool disabled;
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
@@ -38,6 +52,7 @@ struct mlx5vf_pci_core_device {
 	spinlock_t reset_lock;
 	struct mlx5_vf_migration_file *resuming_migf;
 	struct mlx5_vf_migration_file *saving_migf;
+	struct workqueue_struct *cb_wq;
 	struct notifier_block nb;
 	struct mlx5_core_dev *mdev;
 	u8 mdev_detach:1;
@@ -54,4 +69,6 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
 #endif /* MLX5_VFIO_CMD_H */
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index f9793a627c24..6df7ad2dfa6d 100644
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
@@ -560,6 +594,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 
 	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(mvdev)) {
 		mvdev->migrate_cap = 1;
+		mvdev->cb_wq = alloc_ordered_workqueue("mlx5vf_wq", 0);
+		if (!mvdev->cb_wq) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
 		mvdev->core_device.vdev.migration_flags =
 			VFIO_MIGRATION_STOP_COPY |
 			VFIO_MIGRATION_P2P;
@@ -573,8 +612,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 out_free:
-	if (mvdev->migrate_cap)
+	if (mvdev->migrate_cap) {
 		mlx5vf_cmd_remove_migratable(mvdev);
+		if (mvdev->cb_wq)
+			destroy_workqueue(mvdev->cb_wq);
+	}
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 	return ret;
@@ -585,8 +627,10 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
 	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
-	if (mvdev->migrate_cap)
+	if (mvdev->migrate_cap) {
 		mlx5vf_cmd_remove_migratable(mvdev);
+		destroy_workqueue(mvdev->cb_wq);
+	}
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 }
-- 
2.18.1

