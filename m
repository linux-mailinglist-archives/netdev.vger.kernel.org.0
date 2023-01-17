Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AD466E268
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjAQPi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjAQPhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:37:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB9641B7F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:36:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTOcSg84zLNF/xUhDK//1aocjRWo04e9aB5ceggwD9yuiTfjM5knNDczeYNB0o8/ST0TaGOVKTZ2D/0irLDrZcqMk4LLF0bBbKryGIbpi4PG9TZYxufuT4SK54YY7jr0hnCvMiofCCmgpVEalITg/hdNWojt5rOmneTbjlzV+N6u6ZZ+h92d0/OUR4AxKLk6xJjNvzBEu/F6sCpdKAyMPSEkTDxH1qfGm5LboZX1CW00XB3tkkCye9Rb3Z/e+q+uZt4FBo3rU3kuRxRIhgApjmHzVTzN9sp2iWk/ABJetBN8/R8jfgTMihnG6dIVJ97txz/uCF/E38qWcil12xED6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66UcVXf71OzYj18EUjrzG7+fgnuqQnyGMMy2MJGubpA=;
 b=AXI5RtkfjC9YTZz/qrWLvyNgzt6LGWqbfq+rSikORGvo/L1FDSGBvE86NpAHo7JMe1Z28e43div7pBEwZJmgj1PkEZulGAwiqL/rwY2UnVz8gYdjweZyxN9LCBheR1B0FDXUyLiNKa2GvPb/F+IvstsYPOH2VjVzqlGx7B4D60F0jdcIwf7KxghV8sJmneXUvCBLmoXsST9F0M96alx3OgwX7L/dnlDwl/u2IUIYVJjcPDoidRHPokWYYpNFYoeu4736QdeX23qqj3KubXCrwYgE0ccyvIWyb2lX0IMhrF2wJFW7rO7isYplsARLOsWrqOzXd/etQ0Z3c1cNV/ngoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66UcVXf71OzYj18EUjrzG7+fgnuqQnyGMMy2MJGubpA=;
 b=LAk4dxaOu/esHgTIDkqNEDuSnpyr0ovSNR/KJG4jOBsJ4H2zLE7XFY7DZmi65pEdfiwYkWiHJUkCRebvpPyGnVyU4lPw9R2+vVG9wgUgeG98fljJ8JTQTObRE+6vlxCWQDrSjiVdo/xnR/WBjjmfNPrf26PVYyiopIJX8b7GlQg8AWORkitvZbf52Kd2sxbHZu0EyNY5CDurQH58mAO4yJOGDc7TIl+72fyGL0yE8q2g7tyMQQX5qaOTSpC3tJti+nU5iMs+RGiM9in8GRhnEZf9uIS1++ZX47LpC7Ytxe0hQaX2ZvNVRsuC7102kUE2l4V88dC8Bdx5sZYKOEe0tA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:36:54 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:36:53 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v9 08/25] nvme-tcp: Add DDP data-path
Date:   Tue, 17 Jan 2023 17:35:18 +0200
Message-Id: <20230117153535.1945554-9-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0193.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: 17a43f7d-6754-4e74-c6ca-08daf8a0a89d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0xUr00dLWnLCQxaYpytXmUXOb0W6G1jbmrrRcG7SAckhSHOzHEMoS3gw6M8oUACpKz6ExptkLsz4qu83kiZhcNwfFg4/ySG5qBYDExTXBVuuI614sl4UlYi7es7+jdPMh1fjv9VHy49FAnxcr+cAB2a1ybagtzmyzuMx4Y5DyhsdwZD2RbczFE3z68ZqOmPBHF+/OcEFmrtRXOhs0pZqw/dRbheK3ZurnPTsDv8BGkhI2zdJNKWZqKLS+RofESq7SHX9XrLtMuK0CWmyBVEwQ8g1oC0KdEhx8aUHrK09/9dPWF1mC74MfmrrtENLnHiAjH2N7IzV6Ih5T2SpgcDEk3bB19MoLAjj+UCX504AFIqrg8oSWqvv7Ysu0cYY2YXbTSaiVh6UZk6n1VsoKpTCT4zjXNhL7sOsBZTdLsapYzKAMnrFxo/m4cwQ13/SSzno5zB9N/V83Mh+riikxAVrX+SD6cmqzoiu/5vl1mgojr9ExgtVx+e9aFp5XHXBAlilTomg+lFKfxPam9DDVYiCAHG7T0GY9xlJpFSwOgdpl/s9lkHNXrn6n8cGND5g4MPkuZyeOTBSZqHROQVDpqb6GRncX3ainDP+HEzmcbTR+W3gBBksqgtPZ8lYNahNUaBgTO2mPewVAwhPgWgNx8uBvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(54906003)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zoRru79zOZCGiGBFa+EhFwkefMvdHGOFqXXTNqbwSthn1DXkOBbssRuccwDc?=
 =?us-ascii?Q?T0s32TajfDlMCoTAMi0fOFnu65aGFIchDw7CPi5HFig33QGkR/5Kq+qABD5p?=
 =?us-ascii?Q?SRscQpeTAdS0xpDreMwnE+a+74iZ9b3sIrYIrzmLprovq/OKvLmTbqvJruPj?=
 =?us-ascii?Q?cKnBBM7ndwFRUHe6bHrTXJsV0wBoluQrsmhVO9spI0B7qYcyeCYJwOLrTtXf?=
 =?us-ascii?Q?svi8rRpjXSUN5pitiT2g4WKLNYmw6gM/1MosSC87tYQUlJ5e2Oqa7vOJ5SCG?=
 =?us-ascii?Q?a8RKrVoeJbeshfyp7sUKUr+TCOFtUJs3qcFBOBfpQp/r+oyGLC81LoJ8wVEg?=
 =?us-ascii?Q?eDQCFXVhXoSvU87IHqJXhzVQIOZkKsd0eB6l+XNNfvU3XLrx3m8uuFocrucD?=
 =?us-ascii?Q?LXdxZCvYQKSicwdJmGT5j8eykuHcH9nNgpLoyBvtdnSAQiUR3/GtoyAv8zkl?=
 =?us-ascii?Q?SWSBHfGV2bYx5e504Xxgo1nGnPtnwHU83lRSEjqmS6raohGuc37Ih5xlsyps?=
 =?us-ascii?Q?yLluj4FShcV9dXHMYW+TDbjC6EyFpbxd6m8NB7X8ZE82r4pw4X1VpJsejoJz?=
 =?us-ascii?Q?aLXD4ZQGd9Hvv0/dmq3QKp14CL4TNpFvCCRdmu2ye+qkykRMpGSwCnsj3YSL?=
 =?us-ascii?Q?uU8TTjPzKJrOD03GTRmtrYwuSc+qvz7MGSTLvSV+rnnXe3kLTiPp1I28pWxO?=
 =?us-ascii?Q?XTrdJ/CzioQRReDnSLzDH/pRZ8byMkPYCpNZJABJbUxJ6WuWOyucIT5wxSJf?=
 =?us-ascii?Q?oPG7uTHhakj9yfDXU9oLZ2orQ9cC76khfJ3xXdWV4H1+U0pMl3P2+IRMSn3+?=
 =?us-ascii?Q?7ulJBiCyVAHd57i38jXQhsj8YM5PgiU4Os+a0qQ87LQttBUXzNJLd3dgzfbl?=
 =?us-ascii?Q?aQrCx4i21Lq71KT6u9K/szUa21FMSXAAh/7UqZt1Ae1lSWbhGZf+Ezz9bve0?=
 =?us-ascii?Q?uh8PRXzHi4ASf1PebtWwEsecUFcd+jO3x/jWq9GR5WegMN9dkvYnV/+k0naS?=
 =?us-ascii?Q?56pq2IGNssyl5DK2P8PNvXTpZfbxqKzbUIR9Gdt0JIyrern2haw0UEF1fyuQ?=
 =?us-ascii?Q?SVZ5RoQp5EdD4ew0jknM/6/+PoDfi7AehVvBDuReLhqZopUKgRjgTvgWvd13?=
 =?us-ascii?Q?BMj2ggwD3l3DElMar/EsQMbdgfmzvPEpIlK7M6WXoani+nlNovi4NywXkxen?=
 =?us-ascii?Q?Ezl4eQlx2jRDqWqVNnBIRaTNmlVSFNKhco4jqrK1u/CDXuoFjVGkLQ450xIv?=
 =?us-ascii?Q?0Ze7wj5ddRt//wR/G7kljt0zTL64R6rPO7M4M+kghxHrs56pFWsODxMudcE5?=
 =?us-ascii?Q?6MrU3+cUFEjv1RSMz4GK9fLE0Wgbm/p9ys6Cgt9oskl7YjytUCe6KH+fsCmT?=
 =?us-ascii?Q?QDYKBxpy5Ks9ZHGY1OUTN8h/pKDGVlZ5w4gmDzGX+EZfR5/XECRfZByGbHOT?=
 =?us-ascii?Q?IXEPZCqoJmUyrGvt4/sSmo6L/yjpn8/IOwQmo5FBLUodCPIUqYDidCYnWpzk?=
 =?us-ascii?Q?zq+EtuKI8Z2h0ipzTa7bmXRP31LIjihysWHPv/Rqm8oGRTv7MRd5k3XdSoGt?=
 =?us-ascii?Q?8h0QQDnThIg5NW6b0pyC/+8ZFpP8Rs8OCDrxIlcE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a43f7d-6754-4e74-c6ca-08daf8a0a89d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:53.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAVlK9PeDfJfKCfvxSfQvZQ+hd+tfW81meTCmYBtUB+BSpQvqh1Wvl04Wb1a58ILVQNaV27nh1HAy/tCSoIqaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8177
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
index c22829715cad..968b8b6459ef 100644
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
@@ -452,6 +523,12 @@ static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
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
@@ -739,6 +816,26 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
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
@@ -758,10 +855,9 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
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
 
@@ -959,10 +1055,13 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
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
@@ -1260,6 +1359,15 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
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
 
@@ -2591,6 +2699,9 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
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

