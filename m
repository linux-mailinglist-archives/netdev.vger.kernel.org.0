Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787246899B4
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjBCN24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBCN2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:28:51 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EFA457C4
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:28:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQgr2vt8zfgRSYY21T3d8uNK7XfNLrlKhzTD4PmiuJ8kfeXFy22jKb1/1oGw9viZiRecMFOAAm9fE3rJzl6aosTy3YIXvsPMsHwUBsgeOwcmpqTuF2iGCtpd30tOmtbvdr5j3gZJtA48hgKBw5PdiCFL7e1CYkxDwT62sCFibGPM5eUIknIkrp0wDn/Uea9pJLaduG1TwGFnBsZw4R88qBIfSYqo++PivdyYMBT1XrOs6RwKwStRfXp8KHN/O5vubrEXZzk+1zZvW0jczaTekH71J/GnJFUloXtD7qxR+cM2itQcrIvRP7WMTW+QTLaefGsqX023Mqf4mRKFoiLK4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQD7FaT+PBqXhv4KW+daaBG/CJCSnqhsVJIb6lvnYfc=;
 b=Y+FSQMbWmF9ja8CCx8PTLfwvvzuZ81k6Lh0OodE6dVP7q03PDbNqgWJDcwGiyRkC95mc30A+R3xzr+z+9+tNE1FtuQUygfOWQ8dhNDNNfUfWEWbtk9KnncU99IALZj5Q5fk4XDLqzImckIl5KkOFu7ElM6os/TFEqaoYXg6dAb7x8aoGSVxnFEeiFlGQR+faO1X+9Pi5516X8u4EgG311mB+16F6aajUugqzvrnAhRZejJ7Bb+ol4wUeyBsBbm9H7Ca8Xm0KTeT41NIg/SBk1/oBP3GEroq2dX7iByZ/26tCa9J7hxBiEzKqVEptOVx/SwQ2lTfRvgSkbN9Ow6L38w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQD7FaT+PBqXhv4KW+daaBG/CJCSnqhsVJIb6lvnYfc=;
 b=OkAGtIX5QbJ08THCsgUzIMh4jfYs4D8nQA54B3nrT1GkKrokwQHhUt7zTkIFDW5tWC1jMuLACUpuO+aUKuiuQke7nedxx+rG5p5wdlR1sDNGDdlaTWgdQ+KY2u70hFYgs2s0ATWHBWHddoJdJgR8OZtjUuw+Hsqytt808AnbVhYlYlv5MGIp6wsXvry6VAzUhonZwpaaCabLQcTNpPmBRpx9/HaY22shHfbVuiJ+XO/MxmalStHkl4hkpypsgqXRWZwSlSjdbUN8xWCGz9e+OCffTk50E0e8gIrFQYzIZwsQwgBOEDBCTe9dKlav0m3WGg9vmWRh2HMpKWXXL4GI2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:28:14 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:28:14 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 08/25] nvme-tcp: Add DDP data-path
Date:   Fri,  3 Feb 2023 15:26:48 +0200
Message-Id: <20230203132705.627232-9-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: a92d354a-33e0-43fb-4b9f-08db05ea806e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4JMEmQ1fbvnw6J3N7XbJ7gmYEs1mbWcnVp0JyM8I6ekcffgchJa5IyZJ5ziFDehBBszKUihyzRNgNN85Qz6hq95gdu+BRjwmFf1Y0f97IB/qOyndB4S73tdWpY5EBtrpDu+cun1ihoIPyudF36mTelO1dqEfF3BrguCdIGBdzJWlN5vgoa8aaRsrAhX6HkKBJ5+Deq4eXhKID5K4zk6n6jobkAEb2Pj+avaKBnQk/HqKGgs74JX9rMeIrODEdJOBk32cTvPMgY6WviXRlfemhlf6UOJoLT8PBa/j1rkMM//ZQa2rAWhiUW1419boNYxnQ6v/M7EimDImjrt92wgcXJASkAor3wCP03PutraR3fYpNHhls+nY68UwvWp3nEqww5Jwy/QV7z2vBzp5nUwFq6bLxQwFf1jidqYFm35jzWgfQOw4jlkcUMi2drqKBJSt5SRuSFkUHhaKSfKDYQVeq70s97MySLeQXvtCNqwYdHaCRQxMZtvb6fbmVyNjLtsEG+elcdiyrFXVZpgIPPIL/wzEgxItLLFwE2gwBoRybE4YuANqJhXvGKlkRk6K5wdCOXxTlBnBpy0Jn0p/dC8Q39xMhEDVdLif1jPbVPSy/YTHvNkDadNeM9p4h0Q7Ma1j9K4S+5//fomjrDGybpdGkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uQSVF6jTWL0J/wqQ8svXX5/72P8NbOxiZABTuePQl5+YQHzk6MuwfAT+zp/K?=
 =?us-ascii?Q?HuSrofjjGOx5vU18a/qr/+Wkjjg9v7L9s5IvcymFa9D0iaMk9Iwk7VLzuCxq?=
 =?us-ascii?Q?0JaKx2fdZyma0IgBnDahWIBzP6bnlOKahffOXZmVxeBfnF10okTM+DG6lwA0?=
 =?us-ascii?Q?ubkXLhX0/Orse/2LKc96xcH+36hOZBAKPnAQ3BJzzBgo+CRH6oGA532fw19B?=
 =?us-ascii?Q?81zXnck8jFa6UfopKSWaiZhkSr43/jUKyz/R6u3paIFeX0amRJvELdKy1m7h?=
 =?us-ascii?Q?gOizOc+tnNsSU8sxwWA68LgRzr1HBmDiurdBR8IFAnrGmh8IEHhqhKx9I5ff?=
 =?us-ascii?Q?6iA6y05Iou6LqyKQvRZAtNtaDMFzTUCJsh3K+1C1NQfKx13vj8sh8JzjFHim?=
 =?us-ascii?Q?vrBL+jo5GTwOJr5zHAzfn7NkPq4RmtDMN6N/KvNDWHQqWjB/BLlc3ES3KkJ5?=
 =?us-ascii?Q?f0zfBiO7ofcVggYVuv33CwrW+RV+oRyKiThN8H3wWxW2NVEEPddHOaX1cuYf?=
 =?us-ascii?Q?/cHlVo2lRWqK3MAotgrpopiJ+ZANAZYJCjLGvU5c4A3GB9qVZZBP36rmJDp7?=
 =?us-ascii?Q?aPiex7U7zxJ0c7kFlULsKZ6vVTzZ1vCBmunYjdShwHipj5HDMMtK0o3e2o6n?=
 =?us-ascii?Q?Z3NmxQR7dnd866XzeQ96Ogzpg2Eu8J563IzJRc1pdbE4X1xZ/E+hKVymiGk1?=
 =?us-ascii?Q?tNCMZWZ5jYvXVDZ+RbJqlMAzQVwYBEgu2bVhRXhuAW09bd+FI63TuYGj+oVo?=
 =?us-ascii?Q?60L3EhIwllpjuga2eJiBHsE8hx33l0ZMaCByoqWf1Cisu1ODTRBcoGzdi1vc?=
 =?us-ascii?Q?2jO1r3ts+k6kBZUDxWnoJgkimsPWWPRbVTxsyrlcSBWHLtAnzjSUeRCE4hva?=
 =?us-ascii?Q?+tQjVRvPxzHNOFd6Sive6SDyXj/Ii1lLUsp9zVyWMjfurpe3Nttv4lpJ3Y86?=
 =?us-ascii?Q?JR9STbrizdeW3GW713PqNIQ7WbF4KALJjd2XyIGeS0ws9HVGh14MHfCAdh1M?=
 =?us-ascii?Q?h95h+Men7Gk3K/v/6cPrVMtxb0r5r37SrgHHw+DVTceGRwUgEDceYhKP9Un9?=
 =?us-ascii?Q?kM4AZgbtRgymDDTTsFEb8Dxn0KoU/d185i1ufTqxP/8D/3qvMGQeALPoz/jF?=
 =?us-ascii?Q?fAHeDzwVOi8gRe2z2mQHByL43LVwKJSas5AWhRxwivlNnoQntZQq80HcMxsf?=
 =?us-ascii?Q?vlvxk8pMcDidyYDGKHGgk8AysRsccELrnsFSnlBCgrp8vaGhJILoE19X+aDi?=
 =?us-ascii?Q?zUv1zRxAcTl6OvDOPuJiQD2OMVJ0P3jJ6KI1PM0i1CH715HrpFqKtvQ9DEij?=
 =?us-ascii?Q?Xw7tDTRDssntRtkC69YiTBivJjkZQMHP9aeFGTU60yc5SZA3m6XN56wiTrul?=
 =?us-ascii?Q?BLqJqpLGxBZ/uyGE+WBKJ7grmzUxUNhMREyfJlI5vBTzffbLh8s255ygMHmZ?=
 =?us-ascii?Q?bGsN+XmO+bJ3DGy0weQsCPSzvbdr9UBtKQw9jS5S6iJuUfook2aAVXXI9Dx2?=
 =?us-ascii?Q?IEpITnhhqsnZmjdThVq61cUmr4CDTYVIxTi3gSXxvKduwVP4URhkd0X2gxmV?=
 =?us-ascii?Q?v5rsPoJRRNGjvNduXKi8Xv7y4awcCS+dkKfPULGn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a92d354a-33e0-43fb-4b9f-08db05ea806e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:28:14.0598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNyFazB2C44grJwK98sKyvM7AL6+MUXybB/JGeV707YNt7CS2FtOZ7VWJaam+gQloTleb6ccAGA2IWfGEy5R9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

Introduce the NVMe-TCP DDP data-path offload.
Using this interface, the NIC hardware will scatter TCP payload directly
to the BIO pages according to the command_id in the PDU.
To maintain the correctness of the network stack, the driver is expected
to construct SKBs that point to the BIO pages.

The data-path interface contains two routines: setup/teardown.
The setup provides the mapping from command_id to the request buffers,
while the teardown removes this mapping.

For efficiency, we introduce an asynchronous nvme completion, which is
split between NVMe-TCP and the NIC driver as follows:
NVMe-TCP performs the specific completion, while NIC driver performs the
generic mq_blk completion.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 121 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 116 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index b350250bf8fb..533177971777 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -102,6 +102,13 @@ struct nvme_tcp_request {
 	size_t			offset;
 	size_t			data_sent;
 	enum nvme_tcp_send_state state;
+
+#ifdef CONFIG_ULP_DDP
+	bool			offloaded;
+	struct ulp_ddp_io	ddp;
+	__le16			ddp_status;
+	union nvme_result	result;
+#endif
 };
 
 enum nvme_tcp_queue_flags {
@@ -307,11 +314,75 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 	return true;
 }
 
+static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
+{
+	int ret;
+
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	ret = sg_alloc_table_chained(&req->ddp.sg_table,
+				     blk_rq_nr_phys_segments(rq),
+				     req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
+	if (ret)
+		return -ENOMEM;
+	req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
+	return 0;
+}
+
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
 static const struct ulp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
 	.resync_request		= nvme_tcp_resync_request,
+	.ddp_teardown_done	= nvme_tcp_ddp_teardown_done,
 };
 
+static void nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
+				  struct request *rq)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	netdev->netdev_ops->ulp_ddp_ops->teardown(netdev, queue->sock->sk,
+						  &req->ddp, rq);
+	sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+}
+
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
+{
+	struct request *rq = ddp_ctx;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	if (!nvme_try_complete_req(rq, req->ddp_status, req->result))
+		nvme_complete_rq(rq);
+}
+
+static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue, u16 command_id,
+			      struct request *rq)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	int ret;
+
+	if (!(rq_data_dir(rq) == READ) ||
+	    queue->ctrl->offload_io_threshold > blk_rq_payload_bytes(rq))
+		return 0;
+
+	req->ddp.command_id = command_id;
+	ret = nvme_tcp_req_map_sg(req, rq);
+	if (ret)
+		return -ENOMEM;
+
+	ret = netdev->netdev_ops->ulp_ddp_ops->setup(netdev, queue->sock->sk,
+						     &req->ddp);
+	if (ret) {
+		sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+		return ret;
+	}
+
+	/* if successful, sg table is freed in nvme_tcp_teardown_ddp() */
+	req->offloaded = true;
+	return 0;
+}
+
 static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	struct net_device *netdev = queue->ctrl->offloading_netdev;
@@ -453,6 +524,12 @@ static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
 	return false;
 }
 
+static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue, u16 command_id,
+			      struct request *rq)
+{
+	return 0;
+}
+
 static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	return 0;
@@ -740,6 +817,26 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
 	queue_work(nvme_reset_wq, &to_tcp_ctrl(ctrl)->err_work);
 }
 
+static void nvme_tcp_complete_request(struct request *rq,
+				      __le16 status,
+				      union nvme_result result,
+				      __u16 command_id)
+{
+#ifdef CONFIG_ULP_DDP
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	if (req->offloaded) {
+		req->ddp_status = status;
+		req->result = result;
+		nvme_tcp_teardown_ddp(req->queue, rq);
+		return;
+	}
+#endif
+
+	if (!nvme_try_complete_req(rq, status, result))
+		nvme_complete_rq(rq);
+}
+
 static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		struct nvme_completion *cqe)
 {
@@ -759,10 +856,9 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 	if (req->status == cpu_to_le16(NVME_SC_SUCCESS))
 		req->status = cqe->status;
 
-	if (!nvme_try_complete_req(rq, req->status, cqe->result))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, req->status, cqe->result,
+				  cqe->command_id);
 	queue->nr_cqe++;
-
 	return 0;
 }
 
@@ -960,10 +1056,13 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
 static inline void nvme_tcp_end_request(struct request *rq, u16 status)
 {
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_queue *queue = req->queue;
+	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
 	union nvme_result res = {};
 
-	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, cpu_to_le16(status << 1), res,
+				  pdu->command_id);
 }
 
 static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
@@ -1263,6 +1362,15 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	else
 		flags |= MSG_EOR;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
+		ret = nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id,
+					 blk_mq_rq_from_pdu(req));
+		WARN_ONCE(ret, "ddp setup failed (queue 0x%x, cid 0x%x, ret=%d)",
+			  nvme_tcp_queue_id(queue),
+			  pdu->cmd.common.command_id,
+			  ret);
+	}
+
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
@@ -2594,6 +2702,9 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_ULP_DDP
+	req->offloaded = false;
+#endif
 	req->state = NVME_TCP_SEND_CMD_PDU;
 	req->status = cpu_to_le16(NVME_SC_SUCCESS);
 	req->offset = 0;
-- 
2.31.1

