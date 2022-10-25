Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C27760CE45
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiJYODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiJYODX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:03:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E789194201
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmVklMozbDiECxUkKjDhqeGAMhPcMDwu7in00HWi+/16lgHu8RDpSJaxE5rPs9Pg72Zpy8kIMeQYsnuVKxwanwOSYJkygO8JhoE2kUC0dY+wTyY5sJgOBPlm8lFQsFLAuPWtkLvHbdRtbkJKrONlP3YMdiHKc4SRKSELqvr/w/sX+xxXfUy/7v76yBGsD8k5HOhEZgOeg+1E4tlOYvZtu984a08BlPhMNgV61x8siZ6yv0xnyjJCfUPNYH+ZCXO1wkT2HQjGyfHKLSFtcXpoIC4vzwOu18gHdG0BC7LIULyeH6kz1yZ0YfFeNMi2xHq7C8sZVNtPEBecdUOj13AZ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxJLiG3ueDZqMmNy3ZA93Q7t7NpdCsOQX8aakhnM4OE=;
 b=gRi6FqgrSj6oq+47HzD4mZJ0+drBGCTzyrK/pHO/7cyN2v2CkZU5g09bGoKGw878RZvWMr8Tj6wJvahM7PeZMoFHHTeItoR8qCbyBFmEwmYjYOlTDtEvI/PCv3U/BVp4/soI++uWlKXNxSLuI9TaF4qU9vebb2LQ7Vd0bPERboi+kUif8PchzXIkSQKN0+CsbRi3wTqLq84ATENPsaTVUGMqaTkb8Ka9IEqRazBLkHcJ83sHfSpIH7kOOKMwHj0l95EcVHqeJ9G1woZU7t0i3SsxdsUmmbkcn5WYV4J+k/+V7SvuXNqsZr36aipMyXbDWunkQ5OrCZInyr5OgO/IJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxJLiG3ueDZqMmNy3ZA93Q7t7NpdCsOQX8aakhnM4OE=;
 b=sAJtwLhkKKepw5bjQIAccvNLO0WbAeA1akLAyXrk4jkN4AiQGotDBp1ZgoyBcwkCYg+OgV2IxBAWMNbCiXXmL5UKnFPt88ptb0GaSKH8XxW0WmxTrWp5HmOqYdn4/z4yJvEZJO79YvT2rlhDORP4NmdtjjMtAzc/+BYcSZH3LuYZPgMoPWUHy524mv6iNppZKnl3mnf2/TUr3PZUYhG6X4PHD85M2qDR6n1fFFFfdTmz49nsWV4/DlUw4BdRJWVZ7Smc4q5iJGSugkGHlia6llW8KBDiw12GVI5hwxyJq756oIdsY1x7ZxyNAKdSPLI6GdQLiZU/yMjDEMmuSOhcDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:42 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:42 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 06/23] nvme-tcp: Add DDP data-path
Date:   Tue, 25 Oct 2022 16:59:41 +0300
Message-Id: <20221025135958.6242-7-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::21) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: e8ffc943-9a87-4ce9-7fc6-08dab6914e07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qw56Xo6Kyy/7C0aoIob3qpJ4pqSJsVCDR+iDr+VY6yIUciT4M++R/VoPOPQFj/4KLlpiF7J1iU144OeHUd2pPxHx71H0wdktNVSgirWtdyyLYAPefhKzJ1XS43hM+oJEs0yxEE3TqV4rDzaDbpSDj1F1SzFiaeGzXaUxueeS9z8CiWhFaN6CdkI2fxI4Sd7nsKYZCEoV2QaBTV1pL+uWxVmyzi3apo4cYZX8+hbjZ9zepTXjvm/EOxRmkQcLiQ0G3vuoJzQx0c6zKGS4MIsnGh3UY/BUeqyctkImNqGDaMVqBDYS79vdrg05kjhSa0Qx0nbQNr2EhHF0r1tcFH/Hu17EwErEJv/7Si3CmALYHAs3561ZffEhdCuYTMldM30WKubZPKuu71nDDO7FJ4qACBjiuyqa/TDCMserNY2wB5jtZGMXHt48UQ7cIPuZ9StJf41Fv9fQiMFsedmoQGSAnhbMuQfTnplwVzcuTJWEpDd78cWo34rg4dW+upcSForyM0sLeLY289eylvXxHnQjM2ka0V1/F/xLW9He2RO29qqDa4DKarr+BGh7vZ1GCblwXkfCxNwmo6K95I33KydZXjcaXi+1opWIB4g7nxQzlGSYA6Ar18oY47GWW4vIPja995wJFpXcTUtyvaksdYqSwQNnk4MXNbrOFh0VmjnHLTG6w4yPg9pSGaXQ6BFau5nNJMdv/kj5+Iw6NNH0DSfCsijYJHu+u9ACHQZOg0/bF8VttM0Qa0vC6fntk0AYp+6C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(26005)(6506007)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nNBh9F70BejhOlqMaJYfZ4Qy/7rwNatH3WZ+woHpwCmbF27Q5Tfko1fqdcyF?=
 =?us-ascii?Q?LaIgImEhCc5GcUEeaCh4vxfZ3PQJ8pz+kcwncThByLoyivhdd4G3IAbPcBlf?=
 =?us-ascii?Q?pfAaQcc7WM1KhDVXvQ1L8ZaTGxJycAZhW7Mi4Iu3ObV4SVMT1gmyi19CThxh?=
 =?us-ascii?Q?MZxBkqsOgbLfcgROjDGOroW7OmPu0I7m9MAl5kzVKCZyD2mB1v4TuFOdpanA?=
 =?us-ascii?Q?A6DDK4cnc4Nr+Q7XGUX9P2Dj22ofq61/hgRyNMSiE0kL8cNhi7Ls4TTaFmFe?=
 =?us-ascii?Q?tM4NQNfmrFBAUGjVkmjFETurT+G2L7c/jUjqCTOuRFDcvpnc/XxmC2txAdga?=
 =?us-ascii?Q?RqQGfy235OCsLsGKalDF12MhIqtSFmHWMpp1DFJSQSOOD9PNMVUdJWripy3C?=
 =?us-ascii?Q?rztvXFdRDmj49xChcBTmSQDSq39Ptc4qzGxEXLuh764VFeTqQYEJYVnqNMZz?=
 =?us-ascii?Q?vI3o8R5XWFl5moOsvpDGfcvI9/XuwS1QCxmMx+OejXP1grly11eohvySg3rT?=
 =?us-ascii?Q?vtwiOFcJfQhfcEP9SRn20M62kBNbkbcYfPPArezgin4hX7TjID4W9iLz+dMk?=
 =?us-ascii?Q?uiLetSN6bgfX7Or4w+QKvGNFQDy4m0BMmts9cINPfXsfktZJct5UIZV5B9WS?=
 =?us-ascii?Q?p5qUxHUEjul65S34jrmyHJ19mw646J3SlWF8ysPg+GrtWDPVDIisn31Vx8Rk?=
 =?us-ascii?Q?U/Awc1HSq/n1c7XcjNBRXVRI1hQs/zkVl9znKRgmFAh1Dl+nF/srp2a4HJYW?=
 =?us-ascii?Q?ZFwD2mbJSLOJNJHL/vUddWJMXQdubtH8Xy6wVMdhVkNbcBsUexFF1N4ebewr?=
 =?us-ascii?Q?Xioim5Pv8SOV6AX34pn9NelM0V+IzX6xDzK40xyTyoPG9tej9VLgJLHc9Wfs?=
 =?us-ascii?Q?vEDg3jAwERcXu4YQ4U06WhhpFOtcvHE9GKZXXXH/BLqKffVyJDApe22E3W/G?=
 =?us-ascii?Q?YKWgxtmWETXIz/sfItOuhZnI+tauroSySEJlcj5R+xRnPY2LF1+MfQlf8wap?=
 =?us-ascii?Q?kiLOQQ5394Ygq4kVviFZWcMbcpGlnTva3xmzyiTH8KbR5ygd1I04a/oggE4C?=
 =?us-ascii?Q?GbomwrNNYnqmi0ONTcvye/dQadiMGZWsxE7hkh4h9vRdZRvUcS8qD0HHYixV?=
 =?us-ascii?Q?c7PAgQeis3f9H75b310iXdaS9E8RC+lyWeZ7goZ63Aew5K7sSVGTaL9mbtvL?=
 =?us-ascii?Q?dCKqvb0HxCbERjGuBars6sV8uc51ge9CBN4BVhGONgatHV61iviV4nVQ2NxR?=
 =?us-ascii?Q?wQU+FVVd2GgrjRUGXrTi4Fc2YneKQPqoI5WUga8vbBxYUETpsSMkk/wXOn41?=
 =?us-ascii?Q?VcLEGlnezZEcS7pB8ESSBChUpL2ZsUQMbxV8QGhUbotQCcjT/hY1IWrAyk6r?=
 =?us-ascii?Q?sLlyfPyKSDDYHWDMYYoyBj8hIai4dgts//RI0BYTYg+c76yWLEQZcqUBKM25?=
 =?us-ascii?Q?mrTbgapqC2nHT/1wmO9XYoJxYZ9YDnBMaeSKyumVede+lJHN4ELaQuoObq1B?=
 =?us-ascii?Q?d9A/LhNNj3k3wBSOWdnsgDlnCFiwA+nUO5SgcS4uZCNy/8erOlSABJyQg0dJ?=
 =?us-ascii?Q?K7eB9cKI6e1OxaS+qd+kpy/xFp4eShS8Wq5/fht3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8ffc943-9a87-4ce9-7fc6-08dab6914e07
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:42.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlrjvPZed8/Wunpo3uk1Wg3umpU+tZReq4ZZ2QSpnTDzwYiihCbwXzjFtTvc6lZWfOFMQjeWXMN22G3Fojst0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6521
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
index 0f065f18dac6..cb25cfbc9ac1 100644
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
@@ -301,11 +308,75 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
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
 
+static void nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue, u16 command_id,
+				  struct request *rq)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	netdev->ulp_ddp_ops->ulp_ddp_teardown(netdev, queue->sock->sk,
+					      &req->ddp, rq);
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
+	ret = netdev->ulp_ddp_ops->ulp_ddp_setup(netdev, queue->sock->sk,
+						 &req->ddp);
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
@@ -445,6 +516,12 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
 #else
 
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
+		nvme_tcp_teardown_ddp(req->queue, command_id, rq);
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
 
@@ -2575,6 +2679,9 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
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

