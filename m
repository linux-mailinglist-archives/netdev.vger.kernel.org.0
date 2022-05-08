Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDC951EDAD
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiEHNPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiEHNPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:15:47 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2066.outbound.protection.outlook.com [40.107.101.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002B9101CB;
        Sun,  8 May 2022 06:11:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGG3GgE0KSwkQ2TSriWwVOETqXNx7MVleXKFSAdf0ysyUYL86LOeskynWVHDrhEl1ZMVrOEFb7r7OM/4Bk3zzUuT3G9wNeFCoRCcaEjjfKLfApM6UuTWjHc/L2ByNh+C4NWADHcw/hBWhpSJb5VribJgCGdA9Aao40E8ILWinXGPXMgmBdvhihbEHt/GaPmW3R2SDQSYEr1NKoOPPRqlmUrmUuI0NwBNfGHfD5b0qnveDxRwCgDIkx5hzZ2c4RllBu9Q/p/7NF6igs0w+fzRHdz7Wrmf0A07tQvImQwWPNwIzFWbBjZTvVpj8OfWr5YJ0hfkoDrHr/HKKhvECx+jZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTmwMp+3S+/JbNelQ2DrTFXxzSNDZoLExaYTZ4F2uq0=;
 b=AUUUiIoVPMBB3rNTFgxIp+LmC+Plj711wEf0xEj9nq9aUGtGw73FLjTcxfAEis+bLbeRC0JABCSctBnEUZ1jb+o89NOmevR8rB3VddWCGVy9afr7AN76xpe1QenvAS3xoo2DO1npNiH7Nuk9bfL+45DYdofYwyWXITe6ZKH7b2K0vQeYlXcvPV3YEW9OwdbvfFNrKw3Ewt1ByZ0OY2gx85/pj9bJP5nUQtAoNz+dvjsTPd63U79LhUevWXYFDFfreS8cVun8nWaeOMDdYIEejmUffz2MHjVNlXIqP5P1LqpFbOZbtWrO2JuG26FohUjloklBsaYbsRj3Pky7hIw9uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTmwMp+3S+/JbNelQ2DrTFXxzSNDZoLExaYTZ4F2uq0=;
 b=LHYJg18tEVx3lx2xv85DV7+MNmcftttLu3LwnFZFQYdLUO26kgOMjVJbzg6u3n+Pi3C2R+8ZViHgAzZHLlgQFMF3lzrmYtGuwTNMPmXxL4nSvT8JAFyL29Yfxz+fgOR5Lg8KGbmbt8XhaohMz66SmSl8J+LKWcLMZCDRinJE73FEar9WyEExTxzM0CZv+d2K+QbeaeiNJpIP2bujq5l1hPzMrRPTluycuhWP5NBHDZdjXbvvh12RWb9LwJf77gLzCixSA2jaiNQr3DvPfPaA1kMWpg+rsyDBj6JHWgANOjXnQCqVfGUNvqh0hcMWn3U2tmbT9zClhazMmiKHKWhPOg==
Received: from MW4P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::7) by
 DM8PR12MB5414.namprd12.prod.outlook.com (2603:10b6:8:3e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Sun, 8 May 2022 13:11:51 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::87) by MW4P221CA0002.outlook.office365.com
 (2603:10b6:303:8b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 13:11:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 13:11:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 13:11:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 06:11:50 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 8 May
 2022 06:11:47 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 mlx5-next 4/4] vfio/mlx5: Run the SAVE state command in an async mode
Date:   Sun, 8 May 2022 16:10:53 +0300
Message-ID: <20220508131053.241347-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220508131053.241347-1-yishaih@nvidia.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ee6070-426b-4c54-ff34-08da30f450f2
X-MS-TrafficTypeDiagnostic: DM8PR12MB5414:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB541443A2B15E43A34AE10EFDC3C79@DM8PR12MB5414.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hmgap/qaf4sILhD2Zzm+4KcPOdqvsFFra6bYsumUt2/jnI0OsiUP2akCkLNBiy0GlOO7TXTRH0HdAj298fu/8YbSiiiPZxzs7oUAGV0N8JPd/Sw0Bi+RW/16lrzQD8CSoudmKGv4w0tg2qD+a3lmbAn0pro7l1qX1sUkJoMjzSKLyxrajxTbfSJw/0AM9vScwcO0owJoBBhrZDz1+6czUtZfsURqGj4h+F/g426oWOF3tv5JZAmGACqeFR+So9VmPgnrrjtm5muO0GgiLV1j8kDYsWXhypWdGy7zhLpDmXTXTYFhLMeXXJ/sWk0Wcs0gPsfJ2ywbAxCNGmbsi3ULgbW5F6+VAgNdT/jmG1My2QqPDQp/tq6oJsdaiqE7sIHOFaj0UKfvZpURQQD0hWyAvE627Q+ISKMKVbi+/WnJ6UitZ9aJE7vOQvHnjmmxDptipY7vcX3HXII9wp4iFYoGNwIjM0fTSKGkgUVkuD6Hau962RCXYwXhButHcUHSJY3TPr6pAVKThzp+WrRbBBN7vHIkJ+RGHFgMp48TXT56/VFd8cRcsMWQCZrOyDexlzeI5X5pvwVnlE8d8EjgorVR9dbS6HrSoejYsW67YKNj/79+wutR/rgseYlNIYMYJyy9yGl5fBA5AN6NVWbk7oJ8A901tXBbrI84zPiqXGlDvgM1lVV2jqm89CW0DDi5x6/9UEm0jFl3bzLfdwE7+4U/6Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(1076003)(2616005)(8676002)(70586007)(4326008)(83380400001)(186003)(47076005)(426003)(336012)(70206006)(508600001)(6666004)(86362001)(26005)(316002)(82310400005)(54906003)(7696005)(110136005)(6636002)(81166007)(8936002)(36860700001)(356005)(40460700003)(36756003)(2906002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 13:11:51.3039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ee6070-426b-4c54-ff34-08da30f450f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5414
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/mlx5/main.c | 56 +++++++++++++++++++++++++---
 3 files changed, 136 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 9a6e3d3e0d44..0538e44e7eac 100644
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
@@ -206,11 +207,56 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
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
@@ -240,13 +286,31 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
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
index 2a20b7435393..d053d314b745 100644
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
index 5bda6c0e194c..625ed5743f26 100644
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
@@ -558,6 +592,13 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
 	mlx5vf_cmd_set_migratable(mvdev);
+	if (mvdev->migrate_cap) {
+		mvdev->cb_wq = alloc_ordered_workqueue("mlx5vf_wq", 0);
+		if (!mvdev->cb_wq) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+	}
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
 		goto out_free;
@@ -566,8 +607,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
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
@@ -578,8 +622,10 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
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

