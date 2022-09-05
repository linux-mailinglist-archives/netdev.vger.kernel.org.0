Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F00C5AD10F
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbiIELAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237884AbiIEK7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:59:41 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0FD1208C;
        Mon,  5 Sep 2022 03:59:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4QuWQc54A73kVdUZft6P3uNSchw6uVJb3g0jMCPDeZ+b/i97OXJf1II+h4HHTiXEvebKhk4Xq9YJzffOBh+726ofRaAIx85SDodbUiEf/7sc8KWa4HumwunM1nBB87Bch4qJhzDTMxktemSsHei9wJhBNvcM+wHyLGEO2leeV6W6SElPTjpC1nf5alhOOua11NlbHEtOiWm1v4mK/ilkuQMCvfYym5dHZDoLJglMJXrbM5xngMUh67xHrzOu6E1qmfjuCCEJxQ2EsXGwQXYWbC/UVQJgap5EX74+I5GDNXC3ED5Z5B1AR4LoU6gzQiDjN6+QbmR3zI/eu30CLmTyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=ab1+hbefG7hLXaZ0+FhalaVW4rQSgVrcxyM4Y96PvyTWYZDpReVCOMiv2OLMa98jgSC2/+WF7Qdt/TaWEovqdvk9/bwiHXeY7IFZ3HRcAAGmnLbzVehUMHYrilvgesGkuSoXfL2QBKpfIRL0ngTKmMMpj3afyQ/ovNfFyTTofZi9nojmjVlcsi7W56xJQh9nElbaHSv+eXSaIKDA4yuviLnsps1DanSzzk/Vdb4GrGJcEFhNvLR5a6dnq981fUOZKHy1XQZLHvVjUcbXSg61BktlPPlTdR+z2csSShU7BJCGoX+w7HM77IgFXGNqz5KmCVkOh5G5HNdlcjfZNypuNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSPkWxG54mB2dy3Cj1M8FdqBfihoIqPeKJMyEkC8U8I=;
 b=CeodMZY12YIqObaAHsNzhprOlXN+LBaiLo22vMhabpbtM6G/k+srD+nzGBaEoJ/1IsRFO/4j/HoLi5AcfiyRUbH6obP/P4Ie6favuS91HbSnOnaWyLDgR60fHcPBxbCGIqGGaq8f4q5/8ws28aupWTjQT9hFE65aEj37Qpb68cri5WFGcFM0H4nNVdQukpYwqWgHlSH71FFSZWVrAigXoOaBJI148/+z6opswYUQpwGSJLrOT+5gqnAKb0JbxUhUf4ajdydFK0hTHUBQTN305AOKvmSDf620WY3JKID4txXtDhStk9AMYgETTAFuPRqyBJpCOFZqji5O7FLGcefHdQ==
Received: from MW4PR04CA0222.namprd04.prod.outlook.com (2603:10b6:303:87::17)
 by DM4PR12MB6542.namprd12.prod.outlook.com (2603:10b6:8:89::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.12; Mon, 5 Sep 2022 10:59:39 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::7b) by MW4PR04CA0222.outlook.office365.com
 (2603:10b6:303:87::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18 via Frontend
 Transport; Mon, 5 Sep 2022 10:59:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Mon, 5 Sep 2022 10:59:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 5 Sep 2022 10:59:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 5 Sep 2022 03:59:38 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 5 Sep 2022 03:59:35 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V6 vfio 07/10] vfio/mlx5: Create and destroy page tracker object
Date:   Mon, 5 Sep 2022 13:58:49 +0300
Message-ID: <20220905105852.26398-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220905105852.26398-1-yishaih@nvidia.com>
References: <20220905105852.26398-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39019f20-f1e8-487a-b623-08da8f2dba88
X-MS-TrafficTypeDiagnostic: DM4PR12MB6542:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBhJYXDGg4J6Dc/hSal95nRrXDJt1aOWTXJMOVzFdlU0crLsD+p7XbQjN86pYpBhR6EhNRauHnORp7jKMQeycQF9UaeS7JUc6CSe3qDNBmPAPkNykCd4XjCYrchRxCL6eljgsdRG7tXYg3KdhbAo9YzcrAg1Lbayg01XFDMtw9P+GQP8Pr2dWBPlpatHP48dVZEoH1bahTEK0j8mIifH3JYupQ4xp9hLL+7kgYK7bqVZ32zRu9LTsphgZtun1HWXdCtnWBrVpCPaK1PlJeeQd2Yk4LINMm4GUkDeDVeoxdJZWk4xt87I428VM96BwNDQ/sLG5YpJKOaJCr4rM26tHH1aYAtws/9FXYzd6/5UuKg3e3/YWLPChIFJ8VxVbmDFvDF85lRnBppDcYvCo0EbPVilH0RAwuFveV1xaSS5Q8twAmCJFfurQaozEAg35lkKB9bFbmZWEZoM8zEdpyFLEj8mVDC0+KVHn6tXs9Jf3AAfwrYxseXxlzL0WNMljR1vdao5m8zMGDUJHjf7WpMjInZUVRMu+d1++Wxoof0X0VjYoYwXHdrKbFOHRM2qZgx0L3YgyMyJUE3EJKhzg+5Wy1onaB3lkR7CTBhO6rpz21hV0E+8TljoFBb1fjjR2rhmyiaTYDWD8Diah0Jx15egxrceLzOgTZHXUIl7fksy1CaugFyFMFSVN7sWby/W3MEHipW/4YYHl70TcBOod6pqFfHvNWsC34m8W71Y64sh/4df1O8v74DH1p5kmYPiryqGe9TathEVPgwgaEWfDT9i7puw9rhG8igwEFtfdsCKi58=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(40470700004)(46966006)(47076005)(8676002)(82310400005)(70586007)(81166007)(36756003)(40480700001)(356005)(2906002)(316002)(82740400003)(4326008)(70206006)(54906003)(110136005)(6636002)(7696005)(40460700003)(478600001)(41300700001)(26005)(6666004)(86362001)(83380400001)(8936002)(36860700001)(5660300002)(426003)(336012)(186003)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 10:59:39.1074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39019f20-f1e8-487a-b623-08da8f2dba88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6542
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

