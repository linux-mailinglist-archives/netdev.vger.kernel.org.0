Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3635667FE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiGEK33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiGEK3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:29:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177C515723;
        Tue,  5 Jul 2022 03:28:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRO6n0IzN01hlVMLLWN6Cw1rG0cGkWpUZicb8qqIh/r/TB1KboqiwHifxRRRvpzy4+VhdB4AKh1Lv9yvowVgXQPixMs4mDlaB4GhfSBnNpM8qKWu2xiyhul7ixEBiWjNlHsPx9OF6QA6tRjYJ2Uaw9QCbWL3Xm0SdXnoQbbdYnSLVrGBmAFiDnMu6zRfl2JHY9YQvdTbrLeh4XrD0Pb9BGOr18kaF+/ZlxsYhBUrVjn6sTvSYADiZGZoTgp4FtnMaI8/YJ85fUeMOtXrOgg/xCbrGDCORNryRZ7rOsWBPIZUT9tmEBIRuMttRCI3WqE4XpIyjwOyhSqRxELOx2zduA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtQbQg1nek4861Tza7nvTT11lXhRIzWkTBZo3dmlKlM=;
 b=HuubwlsDklVE/E8ExWeCzl9WRdpgpVxZNIRrv07mTkIjQVUN6huoA9lV2lWMm6g5cPCvY61hrLcxBZClK5RhiV0EL+AP320PYYDUlBckE6jZIC+G4wKaeXgur47UuLPP+JA/N8h8Urw87GMXnISng6wMyS+WWJlrl5hCYT/LiDL+sXZWtv/2URIghG1C0XnCgJgAIvenJ/ZUIyKXIcFlNkrGImiMrdGABNUAWEEBUKLyl/NwW1NO7GDjTgQEn3Qs2L18hx8QFov9dXz9gJbMDnF/5q/Dgb5ZKN+4+bsYVrfKzuJ+on5z9dv+jZrbD3LIeWEGwQ7rjr8lsNKA8ZhwXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtQbQg1nek4861Tza7nvTT11lXhRIzWkTBZo3dmlKlM=;
 b=bUnGMscA9i4eUkAm0z9Zi6tg+lWtmPgstK/FGEUUEeSPptUoycFVJNREHPv8K6Dxh+JMjf+URerhkJpsG1WTUAm3I/2pEYeJoi8jnB1NZg3CL8DXfrdn/hYwTw1e/KVbYoEEIi6QqhzS7rX4R862HEcQrALjlUz0egmDC+ha3TEBCzqmFF+yYvyxrykGjUa8Omv2Hm3nVOUieeWobywlKmfDJinJoO+/TcjMhJmSFsKFuXTO0bJDTu376QrX2tnC7RP7uiCKvzPgf5CbfIh7dZPxQFwKnsKHAC9fuBowKzJjD/LNezxCLdD2CZDA+pcH87pgjbmmzcUumx35g6GHUQ==
Received: from DM6PR02CA0097.namprd02.prod.outlook.com (2603:10b6:5:1f4::38)
 by DM4PR12MB6661.namprd12.prod.outlook.com (2603:10b6:8:bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Tue, 5 Jul
 2022 10:28:53 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::27) by DM6PR02CA0097.outlook.office365.com
 (2603:10b6:5:1f4::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:51 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:48 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 09/11] vfio/mlx5: Report dirty pages from tracker
Date:   Tue, 5 Jul 2022 13:27:38 +0300
Message-ID: <20220705102740.29337-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d83b6185-416c-46a4-7376-08da5e7128c7
X-MS-TrafficTypeDiagnostic: DM4PR12MB6661:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpEiMsiYn/rFcp+CWlhFJlOe1jXoPsdPda6JD67sT3l11xXIE2Q7ofIQYWrHQLiYCZUxcq8h9gs2erAd42mHzW7Mh3Gt7jopNHZrSYYZQa3F3eUaGtvcu0aZ8dkc3AceOJNBYzfLB1OOIVlyjGS7bDBoz1y1l/3peiUnPydET60+hMIU/kN/kJlHtupOeiKsqU/VcTV/eEi3iXhik86sVarJnmv0TKwMn3Af65HoDqc3XymOarMv/jFjd1qBpl1WSWzwxQw/YAiKVfvYIyUFgKCkekUY6yHmZoji7HWOXHIhm+xAcMTWKFFCE0p03MCNB9W28Dw3uZCrr67wZTwueYDNVQ1BV5sPnJinMQ6Gluhm9atXum7TrFdc4u+kgmvNQvtxmoyCP7OaytCNh99sDdPH0ExWQnVJ2FtKYNlPP+XO/Uyr3b2CVqj6JPVoJSlitkfUguO0/iB4lb4qtKMpWYkW00rzdEV7W3p7wyBBfC/IY/Bu0rMZKmY1TpwONM0kYf0JDbufkTabg6CnZkMcZ/vSB0YPGxpzjuTbdykJwgjwFwHh5Vc10C28qBvj2yMJLZl894lumwHR5eNY7SD5uQ4LBNLWEq89ipUa0Jbt5Fz6LtK+1v2D5hSpOG41ODWEjNnY9Kuea+m7fnePJr8HlZOQxn6prAiHRPyMK163c10ZxclxKojJZjRje1DQ6moBOqGW0D//DFkyduGMRfufqMnoTCurbgSuFSrsGtqPayT5MoKyFgtbO3M/xKPESHcZdcJhCEaNVtjoa16pRnzctNEPQsAVry9y/9dO2bQzz3HHOeobJdm1Z1ZwVQY+iTF9mtl0m+RLThvEMjaUAZfkeRk5d4OOdohu12v9MNxT1/c0LwSdDTE2VSppP+Zkg4ju
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(36840700001)(40470700004)(46966006)(2906002)(7696005)(426003)(40480700001)(2616005)(41300700001)(6666004)(186003)(47076005)(336012)(1076003)(8936002)(26005)(40460700003)(5660300002)(316002)(86362001)(82740400003)(8676002)(83380400001)(82310400005)(356005)(36756003)(110136005)(70206006)(70586007)(4326008)(81166007)(6636002)(54906003)(478600001)(36860700001)(14143004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:53.3103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d83b6185-416c-46a4-7376-08da5e7128c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6661
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report dirty pages from tracker.

It includes:
Querying for dirty pages in a given IOVA range, this is done by
modifying the tracker into the reporting state and supplying the
required range.

Using the CQ event completion mechanism to be notified once data is
ready on the CQ/QP to be processed.

Once data is available turn on the corresponding bits in the bit map.

This functionality will be used as part of the 'log_read_and_clear'
driver callback in the next patches.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 191 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |   4 +
 2 files changed, 195 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index f1cad96af6ab..fa9ddd926500 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -5,6 +5,8 @@
 
 #include "cmd.h"
 
+enum { CQ_OK = 0, CQ_EMPTY = -1, CQ_POLL_ERR = -2 };
+
 static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
 				  u16 *vhca_id);
 static void
@@ -157,6 +159,7 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
 		VFIO_MIGRATION_STOP_COPY |
 		VFIO_MIGRATION_P2P;
 	mvdev->core_device.vdev.mig_ops = mig_ops;
+	init_completion(&mvdev->tracker_comp);
 
 end:
 	mlx5_vf_put_core_dev(mvdev->mdev);
@@ -552,6 +555,29 @@ static int mlx5vf_cmd_destroy_tracker(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
+static int mlx5vf_cmd_modify_tracker(struct mlx5_core_dev *mdev,
+				     u32 tracker_id, unsigned long iova,
+				     unsigned long length, u32 tracker_state)
+{
+	u32 in[MLX5_ST_SZ_DW(modify_page_track_obj_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
+	void *obj_context;
+	void *cmd_hdr;
+
+	cmd_hdr = MLX5_ADDR_OF(modify_page_track_obj_in, in, general_obj_in_cmd_hdr);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, MLX5_CMD_OP_MODIFY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, MLX5_OBJ_TYPE_PAGE_TRACK);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, tracker_id);
+
+	obj_context = MLX5_ADDR_OF(modify_page_track_obj_in, in, obj_context);
+	MLX5_SET64(page_track, obj_context, modify_field_select, 0x3);
+	MLX5_SET64(page_track, obj_context, range_start_address, iova);
+	MLX5_SET64(page_track, obj_context, length, length);
+	MLX5_SET(page_track, obj_context, state, tracker_state);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
 static int alloc_cq_frag_buf(struct mlx5_core_dev *mdev,
 			     struct mlx5_vhca_cq_buf *buf, int nent,
 			     int cqe_size)
@@ -593,6 +619,16 @@ static void mlx5vf_destroy_cq(struct mlx5_core_dev *mdev,
 	mlx5_db_free(mdev, &cq->db);
 }
 
+static void mlx5vf_cq_complete(struct mlx5_core_cq *mcq,
+			       struct mlx5_eqe *eqe)
+{
+	struct mlx5vf_pci_core_device *mvdev =
+		container_of(mcq, struct mlx5vf_pci_core_device,
+			     tracker.cq.mcq);
+
+	complete(&mvdev->tracker_comp);
+}
+
 static int mlx5vf_create_cq(struct mlx5_core_dev *mdev,
 			    struct mlx5_vhca_page_tracker *tracker,
 			    size_t ncqe)
@@ -643,10 +679,13 @@ static int mlx5vf_create_cq(struct mlx5_core_dev *mdev,
 	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
 	pas = (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
 	mlx5_fill_page_frag_array(&cq->buf.frag_buf, pas);
+	cq->mcq.comp = mlx5vf_cq_complete;
 	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
 	if (err)
 		goto err_vec;
 
+	mlx5_cq_arm(&cq->mcq, MLX5_CQ_DB_REQ_NOT, tracker->uar->map,
+		    cq->mcq.cons_index);
 	kvfree(in);
 	return 0;
 
@@ -1109,3 +1148,155 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	mlx5vf_state_mutex_unlock(mvdev);
 	return err;
 }
+
+static void
+set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
+		  struct iova_bitmap *dirty)
+{
+	u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
+	u32 nent = size / entry_size;
+	struct page *page;
+	u64 addr;
+	u64 *buf;
+	int i;
+
+	if (WARN_ON(index >= qp->recv_buf.npages ||
+		    (nent > qp->max_msg_size / entry_size)))
+		return;
+
+	page = qp->recv_buf.page_list[index];
+	buf = kmap_local_page(page);
+	for (i = 0; i < nent; i++) {
+		addr = MLX5_GET(page_track_report_entry, buf + i,
+				dirty_address_low);
+		addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
+				      dirty_address_high) << 32;
+		iova_bitmap_set(dirty, addr, qp->tracked_page_size);
+	}
+	kunmap_local(buf);
+}
+
+static void
+mlx5vf_rq_cqe(struct mlx5_vhca_qp *qp, struct mlx5_cqe64 *cqe,
+	      struct iova_bitmap *dirty, int *tracker_status)
+{
+	u32 size;
+	int ix;
+
+	qp->rq.cc++;
+	*tracker_status = be32_to_cpu(cqe->immediate) >> 28;
+	size = be32_to_cpu(cqe->byte_cnt);
+	ix = be16_to_cpu(cqe->wqe_counter) & (qp->rq.wqe_cnt - 1);
+
+	/* zero length CQE, no data */
+	WARN_ON(!size && *tracker_status == MLX5_PAGE_TRACK_STATE_REPORTING);
+	if (size)
+		set_report_output(size, ix, qp, dirty);
+
+	qp->recv_buf.next_rq_offset = ix * qp->max_msg_size;
+	mlx5vf_post_recv(qp);
+}
+
+static void *get_cqe(struct mlx5_vhca_cq *cq, int n)
+{
+	return mlx5_frag_buf_get_wqe(&cq->buf.fbc, n);
+}
+
+static struct mlx5_cqe64 *get_sw_cqe(struct mlx5_vhca_cq *cq, int n)
+{
+	void *cqe = get_cqe(cq, n & (cq->ncqe - 1));
+	struct mlx5_cqe64 *cqe64;
+
+	cqe64 = (cq->mcq.cqe_sz == 64) ? cqe : cqe + 64;
+
+	if (likely(get_cqe_opcode(cqe64) != MLX5_CQE_INVALID) &&
+	    !((cqe64->op_own & MLX5_CQE_OWNER_MASK) ^ !!(n & (cq->ncqe)))) {
+		return cqe64;
+	} else {
+		return NULL;
+	}
+}
+
+static int
+mlx5vf_cq_poll_one(struct mlx5_vhca_cq *cq, struct mlx5_vhca_qp *qp,
+		   struct iova_bitmap *dirty, int *tracker_status)
+{
+	struct mlx5_cqe64 *cqe;
+	u8 opcode;
+
+	cqe = get_sw_cqe(cq, cq->mcq.cons_index);
+	if (!cqe)
+		return CQ_EMPTY;
+
+	++cq->mcq.cons_index;
+	/*
+	 * Make sure we read CQ entry contents after we've checked the
+	 * ownership bit.
+	 */
+	rmb();
+	opcode = get_cqe_opcode(cqe);
+	switch (opcode) {
+	case MLX5_CQE_RESP_SEND_IMM:
+		mlx5vf_rq_cqe(qp, cqe, dirty, tracker_status);
+		return CQ_OK;
+	default:
+		return CQ_POLL_ERR;
+	}
+}
+
+int mlx5vf_tracker_read_and_clear(struct vfio_device *vdev, unsigned long iova,
+				  unsigned long length,
+				  struct iova_bitmap *dirty)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	struct mlx5_vhca_page_tracker *tracker = &mvdev->tracker;
+	struct mlx5_vhca_cq *cq = &tracker->cq;
+	struct mlx5_core_dev *mdev;
+	int poll_err, err;
+
+	mutex_lock(&mvdev->state_mutex);
+	if (!mvdev->log_active) {
+		err = -EINVAL;
+		goto end;
+	}
+
+	if (mvdev->mdev_detach) {
+		err = -ENOTCONN;
+		goto end;
+	}
+
+	mdev = mvdev->mdev;
+	err = mlx5vf_cmd_modify_tracker(mdev, tracker->id, iova, length,
+					MLX5_PAGE_TRACK_STATE_REPORTING);
+	if (err)
+		goto end;
+
+	tracker->status = MLX5_PAGE_TRACK_STATE_REPORTING;
+	while (tracker->status == MLX5_PAGE_TRACK_STATE_REPORTING) {
+		poll_err = mlx5vf_cq_poll_one(cq, tracker->host_qp, dirty,
+					      &tracker->status);
+		if (poll_err == CQ_EMPTY) {
+			mlx5_cq_arm(&cq->mcq, MLX5_CQ_DB_REQ_NOT, tracker->uar->map,
+				    cq->mcq.cons_index);
+			poll_err = mlx5vf_cq_poll_one(cq, tracker->host_qp,
+						      dirty, &tracker->status);
+			if (poll_err == CQ_EMPTY) {
+				wait_for_completion(&mvdev->tracker_comp);
+				continue;
+			}
+		}
+		if (poll_err == CQ_POLL_ERR) {
+			err = -EIO;
+			goto end;
+		}
+		mlx5_cq_set_ci(&cq->mcq);
+	}
+
+	if (tracker->status == MLX5_PAGE_TRACK_STATE_ERROR)
+		err = -EIO;
+
+end:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return err;
+}
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 658925ba5459..fa1f9ab4d3d0 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -86,6 +86,7 @@ struct mlx5_vhca_page_tracker {
 	struct mlx5_vhca_cq cq;
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
+	int status;
 };
 
 struct mlx5vf_pci_core_device {
@@ -96,6 +97,7 @@ struct mlx5vf_pci_core_device {
 	u8 deferred_reset:1;
 	u8 mdev_detach:1;
 	u8 log_active:1;
+	struct completion tracker_comp;
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
@@ -127,4 +129,6 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
 int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
 int mlx5vf_stop_page_tracker(struct vfio_device *vdev);
+int mlx5vf_tracker_read_and_clear(struct vfio_device *vdev, unsigned long iova,
+			unsigned long length, struct iova_bitmap *dirty);
 #endif /* MLX5_VFIO_CMD_H */
-- 
2.18.1

