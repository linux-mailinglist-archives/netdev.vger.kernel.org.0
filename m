Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EDC5667F9
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiGEK3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiGEK3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:29:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED671570B;
        Tue,  5 Jul 2022 03:28:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6G+LO9jOkT0XxNh1vrtm3Q8Cr5DOBolfFAfNRCrzA0RwTb6jHevBEO2MzeKlkEj8jJ/KcmG2yWIGC9kzQ5iUqwYvO+ZnSImcPQyxy3L9WUB0DG74n+KCl2pEs4kl1RXWZBQNhFxGTsA5W36oxuraOoUucifvCJ2Xh4tkTeXVqavp3V68AOBTy1xfDsgIn6aifGrOKep3U90kLWHg9fXL+vpG6jpqprEvDTHqoztPP4zSa/UqOIWFWB8yT7gGFOQ32ncl4Fn+9kAm+u8LR45b3/6g2p01bZ4x4HINtD2AVDTETBR3x+lMJgTxWsael+iq2VFmuUnb6rnMXt0+W7EYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=MEaf9SGkc9rzoXAnBsaz7G7co8vDBUmHLflz4xGhrUCQMGd0MibqMxmwtgk88Hb1ZB1M3p60nBzwe20nWudO/68OpxEOEoqU5WlZ27qfFy3BrDlH2DRWQ90QC5Spgwi85UsiF94eSQtCrpdTXXP4gsXQ+Zoc6CT+cnUKufP00Yu5WgBVInTpORKyVY27iXlDap4Nq/L8UA3ZDg31LHVevNq+FY8y1x0QTLmRhm7sKy7N1B/pyR93tgMiUT5yMMFi1TpqplKUkTQgVvrehaq18W/bUAtt8SWpPmcpvYUt35EMCfbnL8zMY00nBO/k7Va7rPvT+YDM1WKN1rPMZjw+nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=W6gBqwB72HqwOGq4zzPK16MBsMQdAy2UDKY9E8Gv6AdORFJfoV5cJizfK73PVOgooYC9fZjMSBvLWAYrP8whygQ3Qe8Dp9eox5ad+yapmMIl51pkQvbboofiiWMOfjCn+bcKX0qQ7Iin5cHg9a1HYinTI1qs4gDk/XQhgf5yeY6ppzLDZ48LWB1Gs3GpOpzcCOyIkaF25v4TqbRY+2qfX7pgA5AZBRKvo6s38tpaVMc6xZmh8XmbNawSZMAArjdLZbRBh1YsxPUpn9DNr8W5orx3shJ+eUwhuR9rfcNOEXkTw2TZjkcTOhboOS/vFYPR4chKcOGgTpbusWtCEeyFMg==
Received: from MWHPR10CA0016.namprd10.prod.outlook.com (2603:10b6:301::26) by
 SJ1PR12MB6121.namprd12.prod.outlook.com (2603:10b6:a03:45c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.20; Tue, 5 Jul 2022 10:28:49 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:0:cafe::1b) by MWHPR10CA0016.outlook.office365.com
 (2603:10b6:301::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:48 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:44 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 08/11] vfio/mlx5: Create and destroy page tracker object
Date:   Tue, 5 Jul 2022 13:27:37 +0300
Message-ID: <20220705102740.29337-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1716bcff-9907-487f-82bd-08da5e71266f
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6121:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVTJMsAY19zuiV3pKXfhDmZH5qLFzGGXtwbo+xAptz/PrfDDnQDPdOvsPIOjTYNUFhuRslqNaorph+fpvee+cMm/LZIX84dkzEHEvyQi/KbHULKtF5/t2/YJVlMp1GPhXq3s0+MoJg6ujJvBDYKGwfnSQgOk1Eb/+vGd46P1CrNblGgrxafjWXiVaWBOocQC0GPL0v7aVU0M6/CsuucANnUW3LElYbm6+drky/9k7XKJCDX4N4rbN+m0RfnGWXgCACUlCoZ/GESGVhSPv5Z+ImTJ6noWzW75XCwJnLO3aLUkm9VpRnPmfEATPknLkOEqUIuEIUmjb9MXb45VawDAv114thQ1RALnwJTTYuLOxELCdTSDZLZYTp0OwqS4/hDQxHvHLTnk4pqzF3EgIpXK9AFln+JqHJHYTXvFcvi5PVSQAbJMpcK1xUf/a7gd+tlGZ3vNzztMGMK4WRchm4eerbPj40xxjKbafV37hqptRdMzB9L3OBYKP6sGNAGzUDmzBVkg2O4uCrczARwYf/Bz0PRmGBv/tvnlWMrJz7QwBOIQIJ4pwcwTSnNAKHq+i3G6IHr2ypgxVQ+FruRTVQwfdrsTLw1HnUnfIjWTw8+c8sT11RNEnT2chevxsv9F58V6yMzZJXkETJ/gT9F/rC6kWyG8idjDrQdApHmd0ilypFxfqbC1C9+0re3uJgJFyJyn0sKRm8Mq0eC0L14DHBJBw2VMafvuacXmEfbR9edzhuim5kjwMYmSsli8bjBDwc+wSJeXavWBV940OBaJ6sWt9uyGvrUUqb32b1pU6bD9t1kTcmyiDulOY09VbLHGwegP9Xb5TII8Vd7R3NY/tFohBrXIVZR5h3A1widBxiJFN5g=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(376002)(396003)(46966006)(40470700004)(36840700001)(478600001)(36860700001)(6666004)(86362001)(6636002)(7696005)(316002)(8936002)(110136005)(36756003)(54906003)(26005)(8676002)(70206006)(5660300002)(70586007)(2616005)(4326008)(2906002)(426003)(81166007)(40460700003)(83380400001)(336012)(1076003)(47076005)(186003)(82310400005)(40480700001)(41300700001)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:49.4410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1716bcff-9907-487f-82bd-08da5e71266f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6121
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

