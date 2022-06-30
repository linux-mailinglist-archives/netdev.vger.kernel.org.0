Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BAC5617EA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiF3K1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbiF3K1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:27:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4048CE3A;
        Thu, 30 Jun 2022 03:27:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1QWTzz0XFnEaxlJ98QpodkDXRQSkRS+MfAb3J21z0sA8Q2knm+wzJC1lGsFYwHsMA23f6kburf5QKKnoRmvMw/OTtN4jw2gWrX5ZlCvZLF19hwwr/fImqOZmhxOtdpko8s1zc7rqmirV7OR6dg0tgcSbZGcOFbuNRgep2yzcyh4u52jfyF98vJZGZlJcjUaZDtCAhDhVGBiCDmr/FCl+wmQwpc8xj2sDGB6Xbm68kWIdvqumWKYWaHiT5xuxdF9okmMp3SPVUTBYrJrMDqVggJ0Mwj3mRAXi/6ACNy5dkEmyhrkMLpx0XvvqQRA/9n7TIaCXd0fYZvnm/EABoVHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=me/q+QW7dOCETQGQAcCoE6Khm38PRtBcZOzIj47t+UuhDA/yWkCpxdbHGmdP6YDHX2LU3BJODHbwRqdz+qYqvlUK5QGFdDPfzeV8MrknACWcoIogs/aFCTomsy9YLbLoex6APGEvu9ijEiOeq6KSV9thxEhRz2t0WtBG/rQneCHTiLEwK+TBfgzFJ9d459hreqB5iaI+9lN9GTJwVGTHT4zFQP708euH8vQIwHPwlXIWDcjLkP9MUCebNLTdRMWo/AjHjsUzp9uM8VLAJbuQhtyHa4DqWtoNNldHGYONWP6XztmjfckhxQ4q0+oVz4zjMds1oYsusNDN7HJBqm2vtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=nH1Yz4+RtJWxciHCqcfk/18CRmJfMX5sdOPSl1+C/JZ6K6bopSd9yjNQoJS0OxlJVkivs5fjoYbMMOq3C9GpzYPbXVqgLNsEVhO9vh51OtDLSlEnYWBxnU6llJA6HSj4Fmdo9Vwci3k2imFfzrG8DCAUUTUtFyNd53KuEgkUw5AKWlK1KM2X4kk2sC5oo0qmZ9ovYGCzRkybjjHsNjH7iJsSnCVHQMuzQVjLRpBSCJvuSkrpQ9lKLVRy5onjR1nVOS2jYqh2sO5z9VKbGOkgw3pF6VDc7haFkx2I+Mwlp/c/mdAcQtfYUu3UAA5h+2LObP8RhotK3J5dRQr9Krgnrw==
Received: from DM5PR07CA0070.namprd07.prod.outlook.com (2603:10b6:4:ad::35) by
 DM6PR12MB3355.namprd12.prod.outlook.com (2603:10b6:5:115::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.17; Thu, 30 Jun 2022 10:27:04 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::65) by DM5PR07CA0070.outlook.office365.com
 (2603:10b6:4:ad::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.21 via Frontend
 Transport; Thu, 30 Jun 2022 10:27:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:27:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:27:03 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:27:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:58 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 10/13] vfio/mlx5: Create and destroy page tracker object
Date:   Thu, 30 Jun 2022 13:25:42 +0300
Message-ID: <20220630102545.18005-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c241bbcd-0cde-432a-5637-08da5a83138b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3355:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yMFk1zaxG7St06FcrBgRhHYq+ZAlX9OQ8g2dLppOKUqT7G71arJ/DtYhzXIeHMg+2lzhYZm8nOvf8a3zIihuN0sAr1dKtYjV/ih3GXQ/aRXlW9+hrUZooqWN62SN71G5pvQ9hvWp++vs8qwHqvIbYH4hnB21qHSg6lvgJFmnbIwuZTJjgy0bOutE+8jkMnWYqHvg59qUr7j9s0zR//R74JAk0X/ak3qJ+Felg2JtfqiDSTGEoM0ZKZ0Oyk1IQwk6m3M/DeIVHZ/niWjpXfIB/fpIF9Ny4ljAuaoTg3fNk0EJLzey0zysWieGeGuky8qNnZpxjHlYCUh4BQBl5qTk2u+9Cgo6h8wYD29Op7Syfutp93vmsjLIthoLgV650JrEWI5XlJwr9j4tn8Ny4c2RzwPk1A4W7dwICXR7zw8U4iWH5heRBd6NUrE4chkf8OuVHkQFgFpPzfkrkCUvsTPeAIJS34yO1BmJoN3Rufeuuvqbr1wGeyed1N/IHbzjOpQt2bAsJSY/p8T7eVSMR6N3vwvRIN8ufVgqB2OhpknnbgbeOSU5JCx/hmeZgkNQrOTNuzr+OI1Xh9xkjUK+qwtlbkz18DK4uqT8rT/6vjtCy2Ay7mDY+6FR8snN8j7/0Rb392iQobD95nT36CtdruUJ4Ac/8GCbwkB1AeUrK9YTijnyEB5ZG3ugtf7eZnBXwruODdOjqa9g4VEllGI0muxbtuL88QH+s3KnPwwupI8pr0YPioJ64rvvjubP4d8Mj6yUFtbkp2t/vTw3qcmFxtEPiPT4hWqNjXh1budgqL7sAp5QtOp8Jx2HEBHmtl6PoOGE/TfDvkp9F05FpTmwa4DKeBwlD0ZPi+z5xUEXriGyv2g=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(40470700004)(46966006)(36840700001)(86362001)(8676002)(82740400003)(478600001)(4326008)(36860700001)(6666004)(356005)(81166007)(82310400005)(8936002)(2906002)(110136005)(54906003)(26005)(70206006)(2616005)(6636002)(83380400001)(426003)(70586007)(40480700001)(5660300002)(41300700001)(36756003)(1076003)(316002)(186003)(336012)(47076005)(40460700003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:27:04.0054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c241bbcd-0cde-432a-5637-08da5a83138b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3355
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for creating and destroying page tracker object.

This object is used to control/report the device dirty pages.

As part of creating the tracker need to consider the device capabilities
for max ranges and adapt/combine ranges accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 147 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |   1 +
 2 files changed, 148 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 0a362796d567..f1cad96af6ab 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -410,6 +410,148 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	return err;
 }
 
+static void combine_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			   u32 req_nodes)
+{
+	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
+	unsigned long min_gap;
+	unsigned long curr_gap;
+
+	/* Special shortcut when a single range is required */
+	if (req_nodes == 1) {
+		unsigned long last;
+
+		curr = comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
+		while (curr) {
+			last = curr->last;
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+			if (prev != comb_start)
+				interval_tree_remove(prev, root);
+		}
+		comb_start->last = last;
+		return;
+	}
+
+	/* Combine ranges which have the smallest gap */
+	while (cur_nodes > req_nodes) {
+		prev = NULL;
+		min_gap = ULONG_MAX;
+		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
+		while (curr) {
+			if (prev) {
+				curr_gap = curr->start - prev->last;
+				if (curr_gap < min_gap) {
+					min_gap = curr_gap;
+					comb_start = prev;
+					comb_end = curr;
+				}
+			}
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+		}
+		comb_start->last = comb_end->last;
+		interval_tree_remove(comb_end, root);
+		cur_nodes--;
+	}
+}
+
+static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
+				 struct mlx5vf_pci_core_device *mvdev,
+				 struct rb_root_cached *ranges, u32 nnodes)
+{
+	int max_num_range =
+		MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_max_num_range);
+	struct mlx5_vhca_page_tracker *tracker = &mvdev->tracker;
+	int record_size = MLX5_ST_SZ_BYTES(page_track_range);
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
+	struct interval_tree_node *node = NULL;
+	u64 total_ranges_len = 0;
+	u32 num_ranges = nnodes;
+	u8 log_addr_space_size;
+	void *range_list_ptr;
+	void *obj_context;
+	void *cmd_hdr;
+	int inlen;
+	void *in;
+	int err;
+	int i;
+
+	if (num_ranges > max_num_range) {
+		combine_ranges(ranges, nnodes, max_num_range);
+		num_ranges = max_num_range;
+	}
+
+	inlen = MLX5_ST_SZ_BYTES(create_page_track_obj_in) +
+				 record_size * num_ranges;
+	in = kzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	cmd_hdr = MLX5_ADDR_OF(create_page_track_obj_in, in,
+			       general_obj_in_cmd_hdr);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type,
+		 MLX5_OBJ_TYPE_PAGE_TRACK);
+	obj_context = MLX5_ADDR_OF(create_page_track_obj_in, in, obj_context);
+	MLX5_SET(page_track, obj_context, vhca_id, mvdev->vhca_id);
+	MLX5_SET(page_track, obj_context, track_type, 1);
+	MLX5_SET(page_track, obj_context, log_page_size,
+		 ilog2(tracker->host_qp->tracked_page_size));
+	MLX5_SET(page_track, obj_context, log_msg_size,
+		 ilog2(tracker->host_qp->max_msg_size));
+	MLX5_SET(page_track, obj_context, reporting_qpn, tracker->fw_qp->qpn);
+	MLX5_SET(page_track, obj_context, num_ranges, num_ranges);
+
+	range_list_ptr = MLX5_ADDR_OF(page_track, obj_context, track_range);
+	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
+	for (i = 0; i < num_ranges; i++) {
+		void *addr_range_i_base = range_list_ptr + record_size * i;
+		unsigned long length = node->last - node->start;
+
+		MLX5_SET64(page_track_range, addr_range_i_base, start_address,
+			   node->start);
+		MLX5_SET64(page_track_range, addr_range_i_base, length, length);
+		total_ranges_len += length;
+		node = interval_tree_iter_next(node, 0, ULONG_MAX);
+	}
+
+	WARN_ON(node);
+	log_addr_space_size = ilog2(total_ranges_len);
+	if (log_addr_space_size <
+	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
+	    log_addr_space_size >
+	    (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	MLX5_SET(page_track, obj_context, log_addr_space_size,
+		 log_addr_space_size);
+	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	if (err)
+		goto out;
+
+	tracker->id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+out:
+	kfree(in);
+	return err;
+}
+
+static int mlx5vf_cmd_destroy_tracker(struct mlx5_core_dev *mdev,
+				      u32 tracker_id)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_PAGE_TRACK);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, tracker_id);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
 static int alloc_cq_frag_buf(struct mlx5_core_dev *mdev,
 			     struct mlx5_vhca_cq_buf *buf, int nent,
 			     int cqe_size)
@@ -833,6 +975,7 @@ _mlx5vf_free_page_tracker_resources(struct mlx5vf_pci_core_device *mvdev)
 
 	WARN_ON(mvdev->mdev_detach);
 
+	mlx5vf_cmd_destroy_tracker(mdev, tracker->id);
 	mlx5vf_destroy_qp(mdev, tracker->fw_qp);
 	mlx5vf_free_qp_recv_resources(mdev, tracker->host_qp);
 	mlx5vf_destroy_qp(mdev, tracker->host_qp);
@@ -941,6 +1084,10 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 
 	tracker->host_qp = host_qp;
 	tracker->fw_qp = fw_qp;
+	err = mlx5vf_create_tracker(mdev, mvdev, ranges, nnodes);
+	if (err)
+		goto err_activate;
+
 	*page_size = host_qp->tracked_page_size;
 	mvdev->log_active = true;
 	mlx5vf_state_mutex_unlock(mvdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index e71ec017bf04..658925ba5459 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -80,6 +80,7 @@ struct mlx5_vhca_qp {
 };
 
 struct mlx5_vhca_page_tracker {
+	u32 id;
 	u32 pdn;
 	struct mlx5_uars_page *uar;
 	struct mlx5_vhca_cq cq;
-- 
2.18.1

