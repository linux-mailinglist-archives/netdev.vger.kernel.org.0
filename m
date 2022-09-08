Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823A15B25E9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbiIHSfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiIHSfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E015FE72EA;
        Thu,  8 Sep 2022 11:35:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVlST4/mYW7OeeJnnNj6YVxRSZg4gAPmAzrSjyD8GCfViZPqDwM/o552IbRmQyhHI3XVMkqm5HeBPFlLFSW3JUCwHkC+9QkRKc/DMi92os/djYs4yXPYKctADdON+i57eK0xOZvFrI02cql1/IX4t6rLsbUeQpF6FLh05Z+dqLulOPjMY423rXON/igmIMNRP2CmMcFVlSchWB8mBLLhF1W+Zwr/4D8EQ+o8kdjqf1OXIMS6fdePVvHEf/BNcIP/tPWy5bCplbyBfCun9/zh/Ydx9TotKSNEmoAr52PCPnBSOUsMqpkDE7ys6tiSxak4uATtZUK6e1ZBX4PAs5rGVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=G/+941gRNcPZBPcc+oUIa8m6zrueQlq4bpMlk9EPfEombyWq6wJe42vZoNtoQ/4WzDthSEAsx4s0UM7AWtDlq/ptyC5/4JpG+QFta0c7OWym+GwCneVxDOB4rwe+YqJgMrGBGWHm2T/pv7rwnk2Q5Rczp/u+NAEPIljfJ+CLkFSgUOhdasKgv41HJ+qkq9R97yklefWgpZQxhaZrl3MElY5AgyEr+fxmPBrR44rAkG2jVMGBgw7WdV6VNz4bx9GXn/y1trPsxh1JXF0wuwjF9gcaj50F9/TxEkdVx/PUHU5B4El8fDQcbjvupYSIopj8vDY16EynMp+hs3FTUwdOcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=uaG8xNVuvZStN49l1dwNg7JTc6AQ+doCwP7r8KQbi6gBtAhkH2qHejki0Xuiro/cx7eg2j0Tm0/31E150TmVKck677EJ5ufR+h1pHxf5yyy3W4gvQ1GHcQ2qmUVATdH3C1l7wXf2Jg7JbiW9gZ8zoRHoGafevCDSGjyncIzH7yM0gNJ12W86CLQhAtR20Xxy16f0NZ8UooercTgrFn+M9S4KTiltLRf704JlfeoHd0WMgqt6DabY2tyxfiGuiUTdSWNP6ebUQ0oDnCbzD+rVQ2TDRDigGUr9xtmx6b7vqCkD3QVrcZWv1XsJsue1feX1L2knczy9JKOKb9oj5kKCuQ==
Received: from MW4PR03CA0182.namprd03.prod.outlook.com (2603:10b6:303:b8::7)
 by SJ0PR12MB7005.namprd12.prod.outlook.com (2603:10b6:a03:486::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 8 Sep
 2022 18:35:40 +0000
Received: from CO1PEPF00001A62.namprd05.prod.outlook.com
 (2603:10b6:303:b8:cafe::83) by MW4PR03CA0182.outlook.office365.com
 (2603:10b6:303:b8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.13 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1PEPF00001A62.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.11 via Frontend Transport; Thu, 8 Sep 2022 18:35:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:33 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker object
Date:   Thu, 8 Sep 2022 21:34:45 +0300
Message-ID: <20220908183448.195262-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A62:EE_|SJ0PR12MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: e7f3d234-90f9-4d7e-a56a-08da91c8ed56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QorTTBmzp31cC27rR74czw2ffbnAipN9Ktsp36vWJ5o1LP9xhgQOWqIgE6j7gDHUlB81UcJqa/EUHJt90+auvu1M8XLYml0NRCFhXPnIvnafLfdCwPqUCDV/tO330ZVri0DYInV7hxBGmWPtcgPRL0TiwjboSVthe5E4BjcdJIsUjCVixdUZUMmmt9tB3S74Q4E0DaoaM9xux5BzXD+9vRQaL8jgC75f56VFkorYuZ50wn81dVFOl2CqB9nrYF8RYYzUjvwvSFZBd6XraT5RYnHLtbIYGeE8rZJsV3e/NigC3V6/azQrBC94Jlx+RrWkGV6V0Nhf96jsfXPhJeD7fe9d8WvcbBLUhxegqBJ5H34WnWd31U3hbn3L8JJwAxcyHTaZzhV6p32ZrsfhkPKvnzzlZ038H1fx8+XiCcGlq5vqqsgXo6XOGvdJe8diJiFcZO7OOnBObaxLaSpo/M2Ef7vNdBhKqMjRYqVBw+8lLm8tW2xg8lhAt1rEfKI0ZJ/vqfOYuYti1Ch9eAN6zsFlNu0ic7wEy0pkq7PdrT3D0Fn0hxnF+P5wPMxUMJstZUt4Q7T7qKvh5UIW91YjNsrSIzQ97860QLN/qvjVrt3zdysP+MUPrzd4PO2tJaPUGc2yV8zSupjpQBI2pi5HR+QFNGMpT5KRzZILUtV7SbaK4yVvuNJIxcdg8jCbBNHEjSDwtY2z1yVkBwO34/DBREqjSfiuKWRLy83HEA8IFVcFK0WIPdkYTzNWskMciscnKpyPiECToq/qrFgVA0kKgpWU+e/qofmfN6zj7sPk0Q59jpY=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966006)(40470700004)(36840700001)(356005)(86362001)(316002)(426003)(6636002)(54906003)(47076005)(1076003)(2616005)(186003)(336012)(2906002)(81166007)(40480700001)(82310400005)(82740400003)(8936002)(5660300002)(8676002)(70206006)(70586007)(26005)(7696005)(6666004)(40460700003)(36756003)(41300700001)(4326008)(110136005)(36860700001)(83380400001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:38.4430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f3d234-90f9-4d7e-a56a-08da91c8ed56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A62.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7005
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

