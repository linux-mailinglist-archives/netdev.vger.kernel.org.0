Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69FF5667FB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbiGEK3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbiGEK3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:29:13 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4278814D3B;
        Tue,  5 Jul 2022 03:28:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9eI76gdMlAKkEn8lSPZF6VC9yzyMGqh41gsi2r0h+joIMuMCkaRcqWBi4C/KCe7srGQa1cQK4FA0giB68ozjwtnXdZ6ECJodLkd6gvBSnDeytoCXYEnDgPjGCwAt1Mce7VOr6NaPcpSw3I5n3kQkJzhk7kOyKiZ0MAY5zq6tjSUGJK0Ik3TzOJgopLpEJxutRuP+/aJUHI7HgodYBso5a4ho8dtXIUk4j+ml0264fY3r71Y+V4rLnN4j+X+0qJCYTJoqaP7y4i+sbiaJA5ACGLiflPzLXFwQ/oSbfipFFkw0eVm+nD05CxEFpF2NnBYqRKgFwyfUxYO3U8+OlpmJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DGCJTH1gN2qefNT81ZTzj2CLsE3lwqCbtSM2p36L4I=;
 b=LsToyrDct4m/bSSdM8u1MubDE+AdJo9ruJ2ugsQKlXzijp9qKdUAU4J/DWiATj/pmmO6A/xZ9aN8CSQG8bYDQhh8e995L6IBcXHy3rZXxopPzTULQ6mLrvsHf5NuBqOKUq04y2Z+5YeSXNNHsMIoEjuhA6UMhwmGGhaGl6s638iUVxSxAKNGIeE7LATMyVnc2OvDt/hapbetULoNtDJOeYNm1L4bZs/Y2b52CpNynVvKDc6xxsESnuz5CvuyLL/m4UxCPUyq0KWRCsRxSMMwU0k4RyA63LS5HRaZ/etIKjf0fnysxfaSNBrkGybCHdQXpmyaILSfPMH3Opt+rt7EVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DGCJTH1gN2qefNT81ZTzj2CLsE3lwqCbtSM2p36L4I=;
 b=eET7cGb9Egk24/wqJuY+akJ++u8sYjezXl6psqIw1T9upv0CNM6DZCsDmu5yQexB9Wug+O05lhnmfGZbSr4kGR44DJ4BQUHtNnGpZMzvidFYrYRQjeDat9UZg50487zdHUR3HuPr3rduCcN+g+dULgqCj5CsJQq0QOpXHbqNXCiGrma1nyfdXUWgPliyoQ0sGfuXB8J73t3BB8JzOIW+FwhB2rUp4dAy2JyLJunksW5GtgbUyFCHQ5knMs76ClsiJpTbnnOAuff7dO/CQ228FO5KmDan+KUsHm+Va4El8MmyFxvCro4cGVn6jvjXtUZZI8YML7F9jbcZAAxXQ2q61A==
Received: from DS7PR03CA0132.namprd03.prod.outlook.com (2603:10b6:5:3b4::17)
 by CH2PR12MB3831.namprd12.prod.outlook.com (2603:10b6:610:29::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 10:28:46 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::9d) by DS7PR03CA0132.outlook.office365.com
 (2603:10b6:5:3b4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:40 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 07/11] vfio/mlx5: Init QP based resources for dirty tracking
Date:   Tue, 5 Jul 2022 13:27:36 +0300
Message-ID: <20220705102740.29337-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee0c6405-6c29-44c7-ea75-08da5e7124b0
X-MS-TrafficTypeDiagnostic: CH2PR12MB3831:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89cruXeym3hNinGdHjmW53wkx0EiLEgfrWRZbr02ZuQ6AIn/RwKvTcNHxmuTgdZHdguQCXu6wXgWImDOR1kQUvIHL4CteloHKCE0XbFT6lPG8T7LwSBT52FiqkO3jTASgiBGbt84/lUwbpjGTieNtRAUxDUmy2k8cUdKhk07fJA9c75aaEhzviX1U5wH8R9oSs/cqtz6aKIJbGYqizLoz7KPpl2ph8psUWqeqenmE9tb8LzfLSDNbZn/T+xt5Frhh3W4KbUugwGNI7+UbLYmaufkaH91o2zB76CFv1KxZd01AINDF7OMTftQ3oIg7GIYTREVsP+wKcBxs6kgV8EkdJvpyTpDfOBERFUIG5TZGb2k6zF/pbrpb/PD9PNnq1IB7gWaywKEZiyob4tPZJT5cIamYpBOfX12gVX1h6rmh+qWXSEDvOdyKA6j4MCsH94RPbQrFYOsYYpxFLW/hvDllvFvkHoNK+DHqGU5SVwz3T35LEJmvAYpuvsf9MsztfuZUS+gfEyi37wd57xqexQNlYUDQ6t2G7b0clebptYsUsD78Im+lRxrpjKzOD5RaURodFR5f5tapDDP9EIvSimvNQZEfvYHg6Nj7YPluak4DqnK+cLADMViaFP3tgB+g5KoipAJ3E/9IL1IBG9v3ijN/uGHs7Qh0Fo2ypJpLhCbzH3Mmetrhj5Oy/P6KAvuxx+Sk65jGdyABkh+wMbTjni+sSBKWqOt3E6rgsTNNAQ7FX0WJhADSWH7rHa8ulTvwKoprGofu08TujXEhRyqJ0vmY+m/NeerRvawLJP7g2milB4iaLPgPz30cRQ0dWFN2ywyEewuwO5stiHjAgX0DZvfEBltR/nZJy9kM4m2zKo3hgAiV5hjaGmzN0X3bRDruan5
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(40470700004)(6666004)(478600001)(82310400005)(26005)(81166007)(356005)(47076005)(41300700001)(1076003)(82740400003)(7696005)(54906003)(4326008)(110136005)(316002)(8676002)(6636002)(336012)(2616005)(83380400001)(426003)(186003)(36860700001)(40460700003)(70586007)(2906002)(70206006)(30864003)(5660300002)(8936002)(36756003)(86362001)(40480700001)(14143004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:46.5142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0c6405-6c29-44c7-ea75-08da5e7124b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3831
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Init QP based resources for dirty tracking to be used upon start
logging.

It includes:
Creating the host and firmware RC QPs, move each of them to its expected
state based on the device specification, etc.

Creating the relevant resources which are needed by both QPs as of UAR,
PD, etc.

Creating the host receive side resources as of MKEY, CQ, receive WQEs,
etc.

The above resources are cleaned-up upon stop logging.

The tracker object that will be introduced by next patches will use
those resources.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 595 +++++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h |  53 ++++
 2 files changed, 636 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index dd5d7bfe0a49..0a362796d567 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -7,6 +7,8 @@
 
 static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 				  u16 *vhca_id);
+static void
+_mlx5vf_free_page_tracker_resources(struct mlx5vf_pci_core_device *mvdev);
 
 int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 {
@@ -72,19 +74,22 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
 	struct mlx5vf_pci_core_device *mvdev =
 		container_of(nb, struct mlx5vf_pci_core_device, nb);
 
-	mutex_lock(&mvdev->state_mutex);
 	switch (event) {
 	case MLX5_PF_NOTIFY_ENABLE_VF:
+		mutex_lock(&mvdev->state_mutex);
 		mvdev->mdev_detach = false;
+		mlx5vf_state_mutex_unlock(mvdev);
 		break;
 	case MLX5_PF_NOTIFY_DISABLE_VF:
-		mlx5vf_disable_fds(mvdev);
+		mlx5vf_cmd_close_migratable(mvdev);
+		mutex_lock(&mvdev->state_mutex);
 		mvdev->mdev_detach = true;
+		mlx5vf_state_mutex_unlock(mvdev);
 		break;
 	default:
 		break;
 	}
-	mlx5vf_state_mutex_unlock(mvdev);
+
 	return 0;
 }
 
@@ -95,6 +100,7 @@ void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
 
 	mutex_lock(&mvdev->state_mutex);
 	mlx5vf_disable_fds(mvdev);
+	_mlx5vf_free_page_tracker_resources(mvdev);
 	mlx5vf_state_mutex_unlock(mvdev);
 }
 
@@ -188,11 +194,13 @@ static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 	return ret;
 }
 
-static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-			      struct mlx5_vf_migration_file *migf, u32 *mkey)
+static int _create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
+			struct mlx5_vf_migration_file *migf,
+			struct mlx5_vhca_recv_buf *recv_buf,
+			u32 *mkey)
 {
-	size_t npages = DIV_ROUND_UP(migf->total_length, PAGE_SIZE);
-	struct sg_dma_page_iter dma_iter;
+	size_t npages = migf ? DIV_ROUND_UP(migf->total_length, PAGE_SIZE) :
+				recv_buf->npages;
 	int err = 0, inlen;
 	__be64 *mtt;
 	void *mkc;
@@ -209,8 +217,17 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 		 DIV_ROUND_UP(npages, 2));
 	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
 
-	for_each_sgtable_dma_page(&migf->table.sgt, &dma_iter, 0)
-		*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
+	if (migf) {
+		struct sg_dma_page_iter dma_iter;
+
+		for_each_sgtable_dma_page(&migf->table.sgt, &dma_iter, 0)
+			*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
+	} else {
+		int i;
+
+		for (i = 0; i < npages; i++)
+			*mtt++ = cpu_to_be64(recv_buf->dma_addrs[i]);
+	}
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
@@ -223,7 +240,8 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
-	MLX5_SET64(mkc, mkc, len, migf->total_length);
+	MLX5_SET64(mkc, mkc, len,
+		   migf ? migf->total_length : (npages * PAGE_SIZE));
 	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
 	kvfree(in);
 	return err;
@@ -297,7 +315,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		goto err_dma_map;
 
-	err = _create_state_mkey(mdev, pdn, migf, &mkey);
+	err = _create_mkey(mdev, pdn, migf, NULL, &mkey);
 	if (err)
 		goto err_create_mkey;
 
@@ -369,7 +387,7 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (err)
 		goto err_reg;
 
-	err = _create_state_mkey(mdev, pdn, migf, &mkey);
+	err = _create_mkey(mdev, pdn, migf, NULL, &mkey);
 	if (err)
 		goto err_mkey;
 
@@ -391,3 +409,556 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	mutex_unlock(&migf->lock);
 	return err;
 }
+
+static int alloc_cq_frag_buf(struct mlx5_core_dev *mdev,
+			     struct mlx5_vhca_cq_buf *buf, int nent,
+			     int cqe_size)
+{
+	struct mlx5_frag_buf *frag_buf = &buf->frag_buf;
+	u8 log_wq_stride = 6 + (cqe_size == 128 ? 1 : 0);
+	u8 log_wq_sz = ilog2(cqe_size);
+	int err;
+
+	err = mlx5_frag_buf_alloc_node(mdev, nent * cqe_size, frag_buf,
+				       mdev->priv.numa_node);
+	if (err)
+		return err;
+
+	mlx5_init_fbc(frag_buf->frags, log_wq_stride, log_wq_sz, &buf->fbc);
+	buf->cqe_size = cqe_size;
+	buf->nent = nent;
+	return 0;
+}
+
+static void init_cq_frag_buf(struct mlx5_vhca_cq_buf *buf)
+{
+	struct mlx5_cqe64 *cqe64;
+	void *cqe;
+	int i;
+
+	for (i = 0; i < buf->nent; i++) {
+		cqe = mlx5_frag_buf_get_wqe(&buf->fbc, i);
+		cqe64 = buf->cqe_size == 64 ? cqe : cqe + 64;
+		cqe64->op_own = MLX5_CQE_INVALID << 4;
+	}
+}
+
+static void mlx5vf_destroy_cq(struct mlx5_core_dev *mdev,
+			      struct mlx5_vhca_cq *cq)
+{
+	mlx5_core_destroy_cq(mdev, &cq->mcq);
+	mlx5_frag_buf_free(mdev, &cq->buf.frag_buf);
+	mlx5_db_free(mdev, &cq->db);
+}
+
+static int mlx5vf_create_cq(struct mlx5_core_dev *mdev,
+			    struct mlx5_vhca_page_tracker *tracker,
+			    size_t ncqe)
+{
+	int cqe_size = cache_line_size() == 128 ? 128 : 64;
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
+	struct mlx5_vhca_cq *cq;
+	int inlen, err, eqn;
+	void *cqc, *in;
+	__be64 *pas;
+	int vector;
+
+	cq = &tracker->cq;
+	ncqe = roundup_pow_of_two(ncqe);
+	err = mlx5_db_alloc_node(mdev, &cq->db, mdev->priv.numa_node);
+	if (err)
+		return err;
+
+	cq->ncqe = ncqe;
+	cq->mcq.set_ci_db = cq->db.db;
+	cq->mcq.arm_db = cq->db.db + 1;
+	cq->mcq.cqe_sz = cqe_size;
+	err = alloc_cq_frag_buf(mdev, &cq->buf, ncqe, cqe_size);
+	if (err)
+		goto err_db_free;
+
+	init_cq_frag_buf(&cq->buf);
+	inlen = MLX5_ST_SZ_BYTES(create_cq_in) +
+		MLX5_FLD_SZ_BYTES(create_cq_in, pas[0]) *
+		cq->buf.frag_buf.npages;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_buff;
+	}
+
+	vector = raw_smp_processor_id() % mlx5_comp_vectors_count(mdev);
+	err = mlx5_vector2eqn(mdev, vector, &eqn);
+	if (err)
+		goto err_vec;
+
+	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
+	MLX5_SET(cqc, cqc, log_cq_size, ilog2(ncqe));
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
+	MLX5_SET(cqc, cqc, uar_page, tracker->uar->index);
+	MLX5_SET(cqc, cqc, log_page_size, cq->buf.frag_buf.page_shift -
+		 MLX5_ADAPTER_PAGE_SHIFT);
+	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
+	pas = (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
+	mlx5_fill_page_frag_array(&cq->buf.frag_buf, pas);
+	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
+	if (err)
+		goto err_vec;
+
+	kvfree(in);
+	return 0;
+
+err_vec:
+	kvfree(in);
+err_buff:
+	mlx5_frag_buf_free(mdev, &cq->buf.frag_buf);
+err_db_free:
+	mlx5_db_free(mdev, &cq->db);
+	return err;
+}
+
+static struct mlx5_vhca_qp *
+mlx5vf_create_rc_qp(struct mlx5_core_dev *mdev,
+		    struct mlx5_vhca_page_tracker *tracker, u32 max_recv_wr)
+{
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
+	struct mlx5_vhca_qp *qp;
+	u8 log_rq_stride;
+	u8 log_rq_sz;
+	void *qpc;
+	int inlen;
+	void *in;
+	int err;
+
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	if (!qp)
+		return ERR_PTR(-ENOMEM);
+
+	qp->rq.wqe_cnt = roundup_pow_of_two(max_recv_wr);
+	log_rq_stride = ilog2(MLX5_SEND_WQE_DS);
+	log_rq_sz = ilog2(qp->rq.wqe_cnt);
+	err = mlx5_db_alloc_node(mdev, &qp->db, mdev->priv.numa_node);
+	if (err)
+		goto err_free;
+
+	if (max_recv_wr) {
+		err = mlx5_frag_buf_alloc_node(mdev,
+			wq_get_byte_sz(log_rq_sz, log_rq_stride),
+			&qp->buf, mdev->priv.numa_node);
+		if (err)
+			goto err_db_free;
+		mlx5_init_fbc(qp->buf.frags, log_rq_stride, log_rq_sz, &qp->rq.fbc);
+	}
+
+	qp->rq.db = &qp->db.db[MLX5_RCV_DBR];
+	inlen = MLX5_ST_SZ_BYTES(create_qp_in) +
+		MLX5_FLD_SZ_BYTES(create_qp_in, pas[0]) *
+		qp->buf.npages;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_in;
+	}
+
+	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_RC);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
+	MLX5_SET(qpc, qpc, pd, tracker->pdn);
+	MLX5_SET(qpc, qpc, uar_page, tracker->uar->index);
+	MLX5_SET(qpc, qpc, log_page_size,
+		 qp->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT);
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(mdev));
+	if (MLX5_CAP_GEN(mdev, cqe_version) == 1)
+		MLX5_SET(qpc, qpc, user_index, 0xFFFFFF);
+	MLX5_SET(qpc, qpc, no_sq, 1);
+	if (max_recv_wr) {
+		MLX5_SET(qpc, qpc, cqn_rcv, tracker->cq.mcq.cqn);
+		MLX5_SET(qpc, qpc, log_rq_stride, log_rq_stride - 4);
+		MLX5_SET(qpc, qpc, log_rq_size, log_rq_sz);
+		MLX5_SET(qpc, qpc, rq_type, MLX5_NON_ZERO_RQ);
+		MLX5_SET64(qpc, qpc, dbr_addr, qp->db.dma);
+		mlx5_fill_page_frag_array(&qp->buf,
+					  (__be64 *)MLX5_ADDR_OF(create_qp_in,
+								 in, pas));
+	} else {
+		MLX5_SET(qpc, qpc, rq_type, MLX5_ZERO_LEN_RQ);
+	}
+
+	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
+	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	kvfree(in);
+	if (err)
+		goto err_in;
+
+	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
+	return qp;
+
+err_in:
+	if (max_recv_wr)
+		mlx5_frag_buf_free(mdev, &qp->buf);
+err_db_free:
+	mlx5_db_free(mdev, &qp->db);
+err_free:
+	kfree(qp);
+	return ERR_PTR(err);
+}
+
+static void mlx5vf_post_recv(struct mlx5_vhca_qp *qp)
+{
+	struct mlx5_wqe_data_seg *data;
+	unsigned int ix;
+
+	WARN_ON(qp->rq.pc - qp->rq.cc >= qp->rq.wqe_cnt);
+	ix = qp->rq.pc & (qp->rq.wqe_cnt - 1);
+	data = mlx5_frag_buf_get_wqe(&qp->rq.fbc, ix);
+	data->byte_count = cpu_to_be32(qp->max_msg_size);
+	data->lkey = cpu_to_be32(qp->recv_buf.mkey);
+	data->addr = cpu_to_be64(qp->recv_buf.next_rq_offset);
+	qp->rq.pc++;
+	/* Make sure that descriptors are written before doorbell record. */
+	dma_wmb();
+	*qp->rq.db = cpu_to_be32(qp->rq.pc & 0xffff);
+}
+
+static int mlx5vf_activate_qp(struct mlx5_core_dev *mdev,
+			      struct mlx5_vhca_qp *qp, u32 remote_qpn,
+			      bool host_qp)
+{
+	u32 init_in[MLX5_ST_SZ_DW(rst2init_qp_in)] = {};
+	u32 rtr_in[MLX5_ST_SZ_DW(init2rtr_qp_in)] = {};
+	u32 rts_in[MLX5_ST_SZ_DW(rtr2rts_qp_in)] = {};
+	void *qpc;
+	int ret;
+
+	/* Init */
+	qpc = MLX5_ADDR_OF(rst2init_qp_in, init_in, qpc);
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, 1);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QPC_PM_STATE_MIGRATED);
+	MLX5_SET(qpc, qpc, rre, 1);
+	MLX5_SET(qpc, qpc, rwe, 1);
+	MLX5_SET(rst2init_qp_in, init_in, opcode, MLX5_CMD_OP_RST2INIT_QP);
+	MLX5_SET(rst2init_qp_in, init_in, qpn, qp->qpn);
+	ret = mlx5_cmd_exec_in(mdev, rst2init_qp, init_in);
+	if (ret)
+		return ret;
+
+	if (host_qp) {
+		struct mlx5_vhca_recv_buf *recv_buf = &qp->recv_buf;
+		int i;
+
+		for (i = 0; i < qp->rq.wqe_cnt; i++) {
+			mlx5vf_post_recv(qp);
+			recv_buf->next_rq_offset += qp->max_msg_size;
+		}
+	}
+
+	/* RTR */
+	qpc = MLX5_ADDR_OF(init2rtr_qp_in, rtr_in, qpc);
+	MLX5_SET(init2rtr_qp_in, rtr_in, qpn, qp->qpn);
+	MLX5_SET(qpc, qpc, mtu, IB_MTU_4096);
+	MLX5_SET(qpc, qpc, log_msg_max, MLX5_CAP_GEN(mdev, log_max_msg));
+	MLX5_SET(qpc, qpc, remote_qpn, remote_qpn);
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, 1);
+	MLX5_SET(qpc, qpc, primary_address_path.fl, 1);
+	MLX5_SET(qpc, qpc, min_rnr_nak, 1);
+	MLX5_SET(init2rtr_qp_in, rtr_in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
+	MLX5_SET(init2rtr_qp_in, rtr_in, qpn, qp->qpn);
+	ret = mlx5_cmd_exec_in(mdev, init2rtr_qp, rtr_in);
+	if (ret || host_qp)
+		return ret;
+
+	/* RTS */
+	qpc = MLX5_ADDR_OF(rtr2rts_qp_in, rts_in, qpc);
+	MLX5_SET(rtr2rts_qp_in, rts_in, qpn, qp->qpn);
+	MLX5_SET(qpc, qpc, retry_count, 7);
+	MLX5_SET(qpc, qpc, rnr_retry, 7); /* Infinite retry if RNR NACK */
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 0x8); /* ~1ms */
+	MLX5_SET(rtr2rts_qp_in, rts_in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
+	MLX5_SET(rtr2rts_qp_in, rts_in, qpn, qp->qpn);
+
+	return mlx5_cmd_exec_in(mdev, rtr2rts_qp, rts_in);
+}
+
+static void mlx5vf_destroy_qp(struct mlx5_core_dev *mdev,
+			      struct mlx5_vhca_qp *qp)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
+
+	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
+	MLX5_SET(destroy_qp_in, in, qpn, qp->qpn);
+	mlx5_cmd_exec_in(mdev, destroy_qp, in);
+
+	mlx5_frag_buf_free(mdev, &qp->buf);
+	mlx5_db_free(mdev, &qp->db);
+	kfree(qp);
+}
+
+static void free_recv_pages(struct mlx5_vhca_recv_buf *recv_buf)
+{
+	int i;
+
+	/* Undo alloc_pages_bulk_array() */
+	for (i = 0; i < recv_buf->npages; i++)
+		__free_page(recv_buf->page_list[i]);
+
+	kvfree(recv_buf->page_list);
+}
+
+static int alloc_recv_pages(struct mlx5_vhca_recv_buf *recv_buf,
+			    unsigned int npages)
+{
+	unsigned int filled = 0, done = 0;
+	int i;
+
+	recv_buf->page_list = kvcalloc(npages, sizeof(*recv_buf->page_list),
+				       GFP_KERNEL);
+	if (!recv_buf->page_list)
+		return -ENOMEM;
+
+	for (;;) {
+		filled = alloc_pages_bulk_array(GFP_KERNEL, npages - done,
+						recv_buf->page_list + done);
+		if (!filled)
+			goto err;
+
+		done += filled;
+		if (done == npages)
+			break;
+	}
+
+	recv_buf->npages = npages;
+	return 0;
+
+err:
+	for (i = 0; i < npages; i++) {
+		if (recv_buf->page_list[i])
+			__free_page(recv_buf->page_list[i]);
+	}
+
+	kvfree(recv_buf->page_list);
+	return -ENOMEM;
+}
+
+static int register_dma_recv_pages(struct mlx5_core_dev *mdev,
+				   struct mlx5_vhca_recv_buf *recv_buf)
+{
+	int i, j;
+
+	recv_buf->dma_addrs = kvcalloc(recv_buf->npages,
+				       sizeof(*recv_buf->dma_addrs),
+				       GFP_KERNEL);
+	if (!recv_buf->dma_addrs)
+		return -ENOMEM;
+
+	for (i = 0; i < recv_buf->npages; i++) {
+		recv_buf->dma_addrs[i] = dma_map_page(mdev->device,
+						      recv_buf->page_list[i],
+						      0, PAGE_SIZE,
+						      DMA_FROM_DEVICE);
+		if (dma_mapping_error(mdev->device, recv_buf->dma_addrs[i]))
+			goto error;
+	}
+	return 0;
+
+error:
+	for (j = 0; j < i; j++)
+		dma_unmap_single(mdev->device, recv_buf->dma_addrs[j],
+				 PAGE_SIZE, DMA_FROM_DEVICE);
+
+	kvfree(recv_buf->dma_addrs);
+	return -ENOMEM;
+}
+
+static void unregister_dma_recv_pages(struct mlx5_core_dev *mdev,
+				      struct mlx5_vhca_recv_buf *recv_buf)
+{
+	int i;
+
+	for (i = 0; i < recv_buf->npages; i++)
+		dma_unmap_single(mdev->device, recv_buf->dma_addrs[i],
+				 PAGE_SIZE, DMA_FROM_DEVICE);
+
+	kvfree(recv_buf->dma_addrs);
+}
+
+static void mlx5vf_free_qp_recv_resources(struct mlx5_core_dev *mdev,
+					  struct mlx5_vhca_qp *qp)
+{
+	struct mlx5_vhca_recv_buf *recv_buf = &qp->recv_buf;
+
+	mlx5_core_destroy_mkey(mdev, recv_buf->mkey);
+	unregister_dma_recv_pages(mdev, recv_buf);
+	free_recv_pages(&qp->recv_buf);
+}
+
+static int mlx5vf_alloc_qp_recv_resources(struct mlx5_core_dev *mdev,
+					  struct mlx5_vhca_qp *qp, u32 pdn,
+					  u64 rq_size)
+{
+	unsigned int npages = DIV_ROUND_UP_ULL(rq_size, PAGE_SIZE);
+	struct mlx5_vhca_recv_buf *recv_buf = &qp->recv_buf;
+	int err;
+
+	err = alloc_recv_pages(recv_buf, npages);
+	if (err < 0)
+		return err;
+
+	err = register_dma_recv_pages(mdev, recv_buf);
+	if (err)
+		goto end;
+
+	err = _create_mkey(mdev, pdn, NULL, recv_buf, &recv_buf->mkey);
+	if (err)
+		goto err_create_mkey;
+
+	return 0;
+
+err_create_mkey:
+	unregister_dma_recv_pages(mdev, recv_buf);
+end:
+	free_recv_pages(recv_buf);
+	return err;
+}
+
+static void
+_mlx5vf_free_page_tracker_resources(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct mlx5_vhca_page_tracker *tracker = &mvdev->tracker;
+	struct mlx5_core_dev *mdev = mvdev->mdev;
+
+	lockdep_assert_held(&mvdev->state_mutex);
+
+	if (!mvdev->log_active)
+		return;
+
+	WARN_ON(mvdev->mdev_detach);
+
+	mlx5vf_destroy_qp(mdev, tracker->fw_qp);
+	mlx5vf_free_qp_recv_resources(mdev, tracker->host_qp);
+	mlx5vf_destroy_qp(mdev, tracker->host_qp);
+	mlx5vf_destroy_cq(mdev, &tracker->cq);
+	mlx5_core_dealloc_pd(mdev, tracker->pdn);
+	mlx5_put_uars_page(mdev, tracker->uar);
+	mvdev->log_active = false;
+}
+
+int mlx5vf_stop_page_tracker(struct vfio_device *vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+
+	mutex_lock(&mvdev->state_mutex);
+	if (!mvdev->log_active)
+		goto end;
+
+	_mlx5vf_free_page_tracker_resources(mvdev);
+	mvdev->log_active = false;
+end:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return 0;
+}
+
+int mlx5vf_start_page_tracker(struct vfio_device *vdev,
+			      struct rb_root_cached *ranges, u32 nnodes,
+			      u64 *page_size)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	struct mlx5_vhca_page_tracker *tracker = &mvdev->tracker;
+	u8 log_tracked_page = ilog2(*page_size);
+	struct mlx5_vhca_qp *host_qp;
+	struct mlx5_vhca_qp *fw_qp;
+	struct mlx5_core_dev *mdev;
+	u32 max_msg_size = PAGE_SIZE;
+	u64 rq_size = SZ_2M;
+	u32 max_recv_wr;
+	int err;
+
+	mutex_lock(&mvdev->state_mutex);
+	if (mvdev->mdev_detach) {
+		err = -ENOTCONN;
+		goto end;
+	}
+
+	if (mvdev->log_active) {
+		err = -EINVAL;
+		goto end;
+	}
+
+	mdev = mvdev->mdev;
+	memset(tracker, 0, sizeof(*tracker));
+	tracker->uar = mlx5_get_uars_page(mdev);
+	if (IS_ERR(tracker->uar)) {
+		err = PTR_ERR(tracker->uar);
+		goto end;
+	}
+
+	err = mlx5_core_alloc_pd(mdev, &tracker->pdn);
+	if (err)
+		goto err_uar;
+
+	max_recv_wr = DIV_ROUND_UP_ULL(rq_size, max_msg_size);
+	err = mlx5vf_create_cq(mdev, tracker, max_recv_wr);
+	if (err)
+		goto err_dealloc_pd;
+
+	host_qp = mlx5vf_create_rc_qp(mdev, tracker, max_recv_wr);
+	if (IS_ERR(host_qp)) {
+		err = PTR_ERR(host_qp);
+		goto err_cq;
+	}
+
+	host_qp->max_msg_size = max_msg_size;
+	if (log_tracked_page < MLX5_CAP_ADV_VIRTUALIZATION(mdev,
+				pg_track_log_min_page_size)) {
+		log_tracked_page = MLX5_CAP_ADV_VIRTUALIZATION(mdev,
+				pg_track_log_min_page_size);
+	} else if (log_tracked_page > MLX5_CAP_ADV_VIRTUALIZATION(mdev,
+				pg_track_log_max_page_size)) {
+		log_tracked_page = MLX5_CAP_ADV_VIRTUALIZATION(mdev,
+				pg_track_log_max_page_size);
+	}
+
+	host_qp->tracked_page_size = (1ULL << log_tracked_page);
+	err = mlx5vf_alloc_qp_recv_resources(mdev, host_qp, tracker->pdn,
+					     rq_size);
+	if (err)
+		goto err_host_qp;
+
+	fw_qp = mlx5vf_create_rc_qp(mdev, tracker, 0);
+	if (IS_ERR(fw_qp)) {
+		err = PTR_ERR(fw_qp);
+		goto err_recv_resources;
+	}
+
+	err = mlx5vf_activate_qp(mdev, host_qp, fw_qp->qpn, true);
+	if (err)
+		goto err_activate;
+
+	err = mlx5vf_activate_qp(mdev, fw_qp, host_qp->qpn, false);
+	if (err)
+		goto err_activate;
+
+	tracker->host_qp = host_qp;
+	tracker->fw_qp = fw_qp;
+	*page_size = host_qp->tracked_page_size;
+	mvdev->log_active = true;
+	mlx5vf_state_mutex_unlock(mvdev);
+	return 0;
+
+err_activate:
+	mlx5vf_destroy_qp(mdev, fw_qp);
+err_recv_resources:
+	mlx5vf_free_qp_recv_resources(mdev, host_qp);
+err_host_qp:
+	mlx5vf_destroy_qp(mdev, host_qp);
+err_cq:
+	mlx5vf_destroy_cq(mdev, &tracker->cq);
+err_dealloc_pd:
+	mlx5_core_dealloc_pd(mdev, tracker->pdn);
+err_uar:
+	mlx5_put_uars_page(mdev, tracker->uar);
+end:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return err;
+}
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 8208f4701a90..e71ec017bf04 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -9,6 +9,8 @@
 #include <linux/kernel.h>
 #include <linux/vfio_pci_core.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/cq.h>
+#include <linux/mlx5/qp.h>
 
 struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
@@ -39,6 +41,52 @@ struct mlx5_vf_migration_file {
 	struct mlx5vf_async_data async_data;
 };
 
+struct mlx5_vhca_cq_buf {
+	struct mlx5_frag_buf_ctrl fbc;
+	struct mlx5_frag_buf frag_buf;
+	int cqe_size;
+	int nent;
+};
+
+struct mlx5_vhca_cq {
+	struct mlx5_vhca_cq_buf buf;
+	struct mlx5_db db;
+	struct mlx5_core_cq mcq;
+	size_t ncqe;
+};
+
+struct mlx5_vhca_recv_buf {
+	u32 npages;
+	struct page **page_list;
+	dma_addr_t *dma_addrs;
+	u32 next_rq_offset;
+	u32 mkey;
+};
+
+struct mlx5_vhca_qp {
+	struct mlx5_frag_buf buf;
+	struct mlx5_db db;
+	struct mlx5_vhca_recv_buf recv_buf;
+	u32 tracked_page_size;
+	u32 max_msg_size;
+	u32 qpn;
+	struct {
+		unsigned int pc;
+		unsigned int cc;
+		unsigned int wqe_cnt;
+		__be32 *db;
+		struct mlx5_frag_buf_ctrl fbc;
+	} rq;
+};
+
+struct mlx5_vhca_page_tracker {
+	u32 pdn;
+	struct mlx5_uars_page *uar;
+	struct mlx5_vhca_cq cq;
+	struct mlx5_vhca_qp *host_qp;
+	struct mlx5_vhca_qp *fw_qp;
+};
+
 struct mlx5vf_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	int vf_id;
@@ -46,6 +94,7 @@ struct mlx5vf_pci_core_device {
 	u8 migrate_cap:1;
 	u8 deferred_reset:1;
 	u8 mdev_detach:1;
+	u8 log_active:1;
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
@@ -53,6 +102,7 @@ struct mlx5vf_pci_core_device {
 	spinlock_t reset_lock;
 	struct mlx5_vf_migration_file *resuming_migf;
 	struct mlx5_vf_migration_file *saving_migf;
+	struct mlx5_vhca_page_tracker tracker;
 	struct workqueue_struct *cb_wq;
 	struct notifier_block nb;
 	struct mlx5_core_dev *mdev;
@@ -73,4 +123,7 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
+int mlx5vf_start_page_tracker(struct vfio_device *vdev,
+		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
+int mlx5vf_stop_page_tracker(struct vfio_device *vdev);
 #endif /* MLX5_VFIO_CMD_H */
-- 
2.18.1

