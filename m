Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68B266271F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbjAINdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbjAINc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:29 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05021DF29
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXzYv3amj47igH5mSLy7CFP8Ji/f3cskbY8tGE1wKOYDzNA6zTk9uTvxPFr3aNQVUd6P19rOlhzYBh/w7zM/DuUJjLl9mpBQRBi6tMeANJrDZUVwbLx1gna4etbkeMAxHQn6luTqVNQs79+ifEYY5kB/A5EIwnhCX7NeO/XOq9vYBlddZgiagq2K46oX3t9LVIOrDvvV6/NkR1WSPsfevUhsfLsxevUMwWUF+mt3urKLgD8J+XpeRVmKuhVByOFxc9TzZKTAJjwMlYH0ctvOPJenjYUtjvhN0qcwBUcyjntSb/eVNcrO3ajQZV31tGBcJaj0WcKX7H0PnHjGeDrw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7r4JRb8h0M2ex9ZpGujHho5JCUi2y59yV2W6/CnTvKQ=;
 b=niiULNpLXTyTaFYhqE2MzmWHwBFOku2KHvUNr4GJRAHe2YALhEsriO5Ss6Daf5RI0BxCBIEat4xFqDL5KOK+iLNfFzSZDoLSJWQcf/bnD9R03yHHj2Yu0KfvZFnHjGXJUkcN2rCQZI+rNp87olGxAaoMtUjs5g2aH+Mh902Ypcp3gC7R/cZhnOYk2Lbg/J49uZufCCUWU6/vCMWd1EFpAHOgsLokKkm8rwAaby8nKfL6VsctsTaFoNI5nvIy6MqdBG1i+GcTmFJ5aYwx5xRWeXoHKkLwgOZe7FQHt3G49Ax7y/h7k+eDM/vGZIbBIUlWLpfOwizlAjyLsVntmxrxhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7r4JRb8h0M2ex9ZpGujHho5JCUi2y59yV2W6/CnTvKQ=;
 b=NOAQpoBn05AqraNtkscrW0LuUOmW/ik0QMX8lZJid+E1QOb043XWV4Hkqa7CQ/UU6AziEFEOy81rbX5hVAtP/ZijtbH+uQipaiuZjwrAmuC0rA368XTUSKTVW53uzeuHpA4Bcps0GWijwv0w36JOORahH7C6okuvPkx+sx32zev0KaoOIqABMBw7lQPGAjRITKO8Unv3MnCj3uUWqc54xMXp5AjCilRLaE4Vh9RUBx+F9pKGPquVEBzlB1ompWi2J8O2qOhbNz4VN+81vi2unCRhyPXEiTmXE5Vt4z9SvbXmxXVgnoyalmuSjGVkBivjJ3ptFM+WsX0nyBaohm2lPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:18 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:18 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v8 08/25] nvme-tcp: Add DDP data-path
Date:   Mon,  9 Jan 2023 15:30:59 +0200
Message-Id: <20230109133116.20801-9-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 5621bcc6-82f3-4465-2d04-08daf245edb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2q+cD+qSWcX0D6zvNpSDyIYTOg54aa/T4alapCi9dpItLmvPRlmsUd6fI43k+dSFdNQ4acNQCLJV2RfXdtLs8Uag9x5XqU2StKpsVwbXiBh8Bod42Um7Bd0EVAr2VBspmFa9k/vanio07Byr4LFKbBybU1dRkKHv7eHy+PnjjBTdfvFUQ4QrlXIt6rwKn0fBmyOmjzcizqU3ZVj2BPYlANZb4e5tsUBIOpan2PKtf/pwAkss9DB/aRcRi8ylSpEyKkS0mnQib18b+a3ljA/Hb/SKX99EYOfhfvJhiWeN1RBeoEXwLsO8VEwKCNIEIYMNAV5j6O6xqCjAbkWQIyIOh7pO25vDDuFTmbL6KCgVpRC0k0Dldr/okyXuKNCzSd1UTH5xr9l9Y98Ei6800XM+NsQfPCmS9ni230wz1FJO6IiR9phShHrYCPxmsPMOmoXsSMJXTgQaETyr7BOKK3+Cqf3Ha9inlsDZ/UW5pfh82iGfLB/BXE66qVzCVEek8Kq5OnoYtkCFgEyBLs3T234lFFy7oMSrAd0vh1DfQHr0gXXOgRF+DhABuIHKBi3ZKZA7KJsZHdwYp2wimRdpZdtNJqq1/enf+aTGELUCfyyUZSLypmbTNfDxIiXqS9ZLZzlvUcTM0jZbDtC6m0X4fLsjEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(1076003)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(2616005)(41300700001)(54906003)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(6506007)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VpHvYfHFhKurBflBG6VmPZlVN8e33AkG2uE62Z4IyP5jpzjsb807EtBGkH3o?=
 =?us-ascii?Q?a1xyyDCL/RBoFcy/D+G3oFMgWnq1TB1l2J3LZFdOfGQlw/dTXF4328UpLhQE?=
 =?us-ascii?Q?AGc7YCn5Kdb8oLDM0b7lIHM64EuV+I5v3N7GSlF7ONqs3AksokqVcIeFI89p?=
 =?us-ascii?Q?Yv4k+uHmjhFL+mIaSEQrUQoodIAsJz92+ZWG2xsLIlY7G9A6Ta9LHspkM/xO?=
 =?us-ascii?Q?AXb1IS5z/vq3USP35Py+CCXFQ/5U6kIx+WpxwK54xggGNpvwJUJK5iNrMsIP?=
 =?us-ascii?Q?PgfW2wQOITZhomZPisq9IV/EYULLk0aycw/CKW7HnrRtpYXvaT0HW3ds/n87?=
 =?us-ascii?Q?lkD4id/qCcrRJZLjU/9pJteIWGoLhRVFYWyfrtk3xmNm8csh8oSpK+gjTBMm?=
 =?us-ascii?Q?5zFeJZCLz/CgymoKn8WfTIzHoPzGHKeB+L26tX+sNvGAKxJYr1MXhyZDl3C9?=
 =?us-ascii?Q?MESkvfpWzgBUAgZdPVnI8g7m53Mcma/I+tYSC6YMYs2u5r4uLWDcjGnFthZ1?=
 =?us-ascii?Q?WTRP2AO/vc8hkOUcWJn86HcwFThQirT5anYCAsMZ/0/Akv1rTtifjD2hbIWm?=
 =?us-ascii?Q?WhQz7iJxwlwTq89NrJj7wMy28OrS7ggfiergMcfR/xdRN+JnUAlYMOO7Fhun?=
 =?us-ascii?Q?Mf6vD/DDLei5pNVcERBCvx/9xMy1r8H4MoFE56qb+WdAN8vE7qBWDTny7naW?=
 =?us-ascii?Q?NjdDxNs8IIV1U4bV6nzaKthnqIVdKphMsdBLFnWcXle29TiPtKC25SxT75Tx?=
 =?us-ascii?Q?G4ae84++UF6J2EMYpOoJ1e8133BUkQtlrxa/dsaJePfvfLGsvxVySMyGPyz1?=
 =?us-ascii?Q?j1h2dFBcP8HEAUeOnVwaEcJyWVPgW+91vRduYQ5xevzHEDUj67LFDJxh8b0x?=
 =?us-ascii?Q?KLioniBVEokanfeD4i/2nXFbBfomSnExoEI2tQyzQBroh3kSpgax5jBTgeVT?=
 =?us-ascii?Q?/dXD6m/CyOjyGl+E+0/Ckld+UrE40r0/ii4zCr2yJteXOZ6oC7lJMIx4Tfh9?=
 =?us-ascii?Q?qNze2zxYGbAJvP5J5sFgtPq+SYqVxAfhRVaVpH/3//7tq1YK+rQisQtL+ar1?=
 =?us-ascii?Q?FKKjKl6cOI8N8K0g7e/gZ6umdoAiWcNVa5W03vUHQnQ6jr06CKOg/WoVPH7z?=
 =?us-ascii?Q?UCLchIPwtQSc0bWvpUWAl35n8r01k9zaDm0mIBtqMDEUS1divFD58C339wUu?=
 =?us-ascii?Q?eJMwALrIr/V8KY1DlQ6q36jsS1ujyMBommmdbgCb5qXu2giSVBqnbuUcZUeh?=
 =?us-ascii?Q?qu8o+BttLnqvH7aJ1YKF9FuGUUxoBwovh3rBGgISq8rseIvKu4PZAPh8YqfM?=
 =?us-ascii?Q?a9ms42i3pq6W/yCtcTfvXjBHckbCgjrpDp7lzmY2jxS7jaRkS1IQUvE8Hg1u?=
 =?us-ascii?Q?pka1qHPIbQ5KLeH0MjSOvcn5lAaZdLG2rCdKxIlKMjtwqlT3pQyCkLm64VuE?=
 =?us-ascii?Q?BVxQt/TWxzeHnaHLkGkHFGpUgv8/rzRKcrCF0oLQPsCq0jpgjq9CuiznGoeQ?=
 =?us-ascii?Q?fexp31b9mFxSKZNR87F0qjG2Nh70wo3Ra9Auz0YGgZAUIw/vaYp1/HSeweT7?=
 =?us-ascii?Q?/Ibj6cDYWExfy6mZgTzbz6I+Epfhz/uPdzgev78G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5621bcc6-82f3-4465-2d04-08daf245edb7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:18.1997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2P3EOeJT5MR5M2Pq6xGnCSTw5Mu5OQzD3/MDrDzP+yR27KrdhxA3cDETV3YMX9cbmvru1YI/NQfLrZ8tO3r7IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
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

The data-path interface contains two routines: tcp_ddp_setup/teardown.
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
 drivers/nvme/host/tcp.c | 117 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 112 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 3c35290d630f..718d968d94d6 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -101,6 +101,13 @@ struct nvme_tcp_request {
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
@@ -306,11 +313,75 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
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
+	netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_teardown(netdev, queue->sock->sk,
+							  &req->ddp, rq);
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
+	ret = netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_setup(netdev, queue->sock->sk,
+							     &req->ddp);
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
@@ -445,6 +516,12 @@ static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
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
@@ -731,6 +808,26 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
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
@@ -750,10 +847,8 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 	if (req->status == cpu_to_le16(NVME_SC_SUCCESS))
 		req->status = cqe->status;
 
-	if (!nvme_try_complete_req(rq, req->status, cqe->result))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, req->status, cqe->result, cqe->command_id);
 	queue->nr_cqe++;
-
 	return 0;
 }
 
@@ -951,10 +1046,12 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
 static inline void nvme_tcp_end_request(struct request *rq, u16 status)
 {
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_queue *queue = req->queue;
+	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
 	union nvme_result res = {};
 
-	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, cpu_to_le16(status << 1), res, pdu->command_id);
 }
 
 static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
@@ -1252,6 +1349,13 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	else
 		flags |= MSG_EOR;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
+		ret = nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id,
+					 blk_mq_rq_from_pdu(req));
+		WARN_ONCE(ret, "ddp setup failed (queue 0x%x, cid 0x%x, ret=%d)",
+			  nvme_tcp_queue_id(queue), pdu->cmd.common.command_id, ret);
+	}
+
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
@@ -2580,6 +2684,9 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
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

