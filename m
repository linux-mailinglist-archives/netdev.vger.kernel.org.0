Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02F585F07
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiGaM4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237126AbiGaM4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46992B4B7;
        Sun, 31 Jul 2022 05:56:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B954klIv//kmNBogap0IhsyCa3YuXK2JfFiRKMYJ94C1R1pXEEmaandiBbee8r01l9rRVVAIMxFPtgaV4ltdaUuecqQeVUTyUYxr2SnRlzseQ0wZY43inaHwPDqnur+0h8rUfpT9eHUnya31g4bEYO8GyCECXZfUJq+h2pgK42GfjuM7cMmVUe06fG4Hk7ZhYGogVfFCgfZ+tD1YETd/VqvQD4d79LdyTxmwLSWzhcdAv+1wKExbjH4UYSwtaNTXxN9itt1dpvPjAMOkA7qmcFWVeVFNuyiUBFIH0xXp0LC47tULDDPDb3UZL+rHvbxxRW3mEzEkrmzfXssChc+/Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=g77nei0/EhemDbNsES1qpG67Az0TyngPjNPHPPxNBr/ofJmOMpJXReWMiYCkfwu/ficmJX/i8f/jnHVBEeP0YglDolOUbtUpqCvwW6gchgZyeNAFw/K0dpZMJpZTsO0InAlqfwuhOdlmJmc0+VlssFmhov2eXarNyzwvZtXeWbm42k3RRuZdqyHBWYledxX+HQdRuWkTXMNkFaNugsO/tko1UOqQs1fMr5wnoyOcCGGJKR0cZvyOXSkRhTQeukYSxYIosb1KsJGY4jSVgEDwzZDrDj6GdHTJyUqDhNLALHARReVe3KeX33AaoEPq+z4Z8HZ/NOur1KAmHoOC51M4gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=FrxszrjsubHDxCgsMuw5Luyy5nWgKXHRP/I1AJvLwLrugDpxYG0apbhQqxzuUIH1tkkMH2c/gY6GxUnyKCIqJ990FkUq0U8jneKPkmKEYiONkhvZwT7F5+ErPQAIKd6NMxK1NAMk67uRqOLx4hE53b6pGiG/M0X4rcBo3sXvW4k5hIxrkxXQl+xffSrb3PmntAKeCZsZs7c6uOHU10xUsvuijwPn6NY0qmCNGwdFA/5Z2gtyKWFpN1M2dIAakKDKPmqBVm7jAhsVTvk/vKUGvUPrMhPJlkZhxIbjLIhODmMij0spkKz5NVlbWWyn/ZapE9aTjwAdCC3BCHGJQaAwsQ==
Received: from BN9PR03CA0141.namprd03.prod.outlook.com (2603:10b6:408:fe::26)
 by BN9PR12MB5180.namprd12.prod.outlook.com (2603:10b6:408:11d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Sun, 31 Jul
 2022 12:56:26 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::fe) by BN9PR03CA0141.outlook.office365.com
 (2603:10b6:408:fe::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:25 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:56:21 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 08/11] vfio/mlx5: Create and destroy page tracker object
Date:   Sun, 31 Jul 2022 15:55:00 +0300
Message-ID: <20220731125503.142683-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52bffce1-dac0-478d-71ce-08da72f4142a
X-MS-TrafficTypeDiagnostic: BN9PR12MB5180:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhxGfZUqFWU6ECYMnl+tKsshVNLSYWJhvajZp2FRcQm49SJZWi3lS+iuW4ZIrkSDpeSrhLBISg+L7P13Z8dv6oIj3EEUImtxWnz3t2D6Nh+wp8fVY+5pIntFFNEnyrqmIfI0AnbLyVJWEIQqKGEwr+kjEasp/cSwlq7WqDjy2ylYFnf8uDz3UeFmX0pR+58ptq7kJBot70v/6zKmz3l027uxToaZLHja8MQW0S1JhJXI5gDxqss+2t2M5fPr9B9hLh9Zl3CJ3VjzdpMxQkO7sqTLBfvpPSiJOgXFADg+Jl0UaejWjFOQ0IpakrVqRFuRapbn/edZk0tNq0QNP88BLkbgOqCVQ9YLeJpCzMt2Ev6iAme1ZyI3uGAPzMBMHZkY5+gDzv3zHA+9dAyk9lZO5CWc1Ll5FsGPaB2cfkq/pRtVUThfqO++FOuKjNX8aOeW0grifpSK3NzeEMB2KMhTy+t6X4qwF5KH05GJWuggrj/3lgTkqMFtcn8ZgITe+nSXVvGGkaoA8ZHAUuNRsjhO2kbgeyC4LW0+KXjRMFOfS0Yat71Oxeak2F18neUpwf4HMSQmIwxxTXfv7jAW7VjIjAJR7oHZ6hKR6oFWQUTCgP5hQHrNTVKL7HDJO8nBwEgF8Ie3QKLGgRoItO1bY4fD4ItRd7MyebHomKk1bta5DMj08vLgvaFFAbQuGALy0U/gA/DX9HlpokX3jQMBSqfeczS6vM8bwl0jRKfsHf/lklaSlikrmIUrMAQW5GTeGuR8AF8hlKtUhGu40Xwni1ObZBwr/CNQBtyO156uOAQ8opmEIjE6vU4ENQibD2YAR4AmmLjd7UR/W7HfXC8dKnoaNw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(40470700004)(36840700001)(6636002)(81166007)(54906003)(478600001)(86362001)(356005)(82740400003)(6666004)(41300700001)(336012)(47076005)(426003)(7696005)(26005)(36756003)(110136005)(316002)(2616005)(1076003)(186003)(82310400005)(70206006)(70586007)(8676002)(40480700001)(4326008)(2906002)(40460700003)(5660300002)(8936002)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:26.0384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bffce1-dac0-478d-71ce-08da72f4142a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5180
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

