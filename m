Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3166A605C18
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJTKUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiJTKTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:19:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032969FDD
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcQhmt/KSf521h7lJLHmo468sNf1FDN0kwisSucnoZ4lKdWJY+NchGBQKHQIpa7ca2kB4keSOKtLtpbZOwyDxzh5onZyCJbMDkuvlrL8qKkuLuY26+uA6PjmnDyvlDokh3Y3FjPgwkSPiS0rNrl2mjRCNqXXzWac3KUegFUNb5oNh8XUGvC48c5dlEQa1nR0CyKNxNCwCuvuUL6rEXd0y15pw7tJiCNRYWlsPTG9JlpgOPhB+yXBeRFD0sBkDjLHrFykwWyLQiW6FGZpobUk7MgTgWktSpyb7F3uCyNiNFQsUoooZaFTyms2g+Zq9oULe9BkbWPpaYNeGx95iPUiWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUfaSy0fBlW/UrFsfv+Fmf1/fciVCG6gB5QjeRf4Iec=;
 b=XBhttMbVz2sp1JGawRN8b6gU1YY6oogsOx+lZQKTHMxyvAMuYRG7IOdq/I7rURvWOi5elfhssoVIFfsPR2gbfBdg6yg1zvm7C9DTPSCMko8kyRJzwE6XxfiOPCKYj7cBc5PajE2sQmkR77O8ZhmdzJBN7BjOlCbUHdUYCpmTnFeJdtSp8j5/JzbapTg9wBxQjOlC6iV+pd7bHXIGSQ2P5IRDyZwon3bOzzcoNZGuWdwEQXPWP1khZn+ZkvCNEPgyAb+M2zferECpDrhnPwoAhexNTsZTFR2wZFpPTKlRzc1xV9tjsT6/P2eN20hRP2qeEleX5sjGObpSJFdirNQRSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUfaSy0fBlW/UrFsfv+Fmf1/fciVCG6gB5QjeRf4Iec=;
 b=gnOvNqWFVzr4tsUocZBgsGc11OPGWqJbw5V5xdGpmcYHE/GLoGLYJiGnJzHrvPwHiu1c4dJ7NVrBKb2mTQpx9cqCFe77TQVzYe0OHojsi/oulnUeOU+lwNJRQrEgMusflUbDF4aNDqqA1R0xLUMWDHk0yc0ystz79wBZoKXc5YZj/PugF2IpCF9VfhzwRtRE6CZuDFLFfaB4uaH2dvePWdIMM4ezozsA/x3OV669eTS9pgQcX0ZuGgWI1xVte6A5b4Pi59oFJqnET+7EAMkpelbbggxRR2Psgi1m7K4TGR9Rz+yRyWWJ4X5zlpcyJ5i6oOZ17r+eIzIgPBOzgJdejg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:19:20 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:19:20 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 06/23] nvme-tcp: Add DDP data-path
Date:   Thu, 20 Oct 2022 13:18:21 +0300
Message-Id: <20221020101838.2712846-7-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0615.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7d6f05-abf3-401e-3a5d-08dab2848d75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q41pJVNKMsfAZFqxJnT9EeFwf+6rQlfuH8qBjqsvR0pcuew0g1oEI3tpWvIp+sQdZCuJdZbftX5B6xsEa9nsY+/mOo3qfo+yLm7jbx+k5odajBrbMfbLb4NunviJiEhj7m90/X1LXjjbSm7/0nVfbVGZV4iaDchZZiJPpAW2Cs38v1cy+SnBFXltraPTauv+R4qhzAEzpfD/gHOuWdUtLL5WzoO7asVtU570wYtuM/6FN5jNAsFXkjVlifch7/QPqL2iClSSnWSRHvx/MJPmZNPbVVDCYQZ05cU/xk3lNjnfnCvk/zNtZblHxeh6WRX2JYNUfeOMC7Tzq4yBm2nx7BWzeUNqQm2lg6piK0Uv51UU9DDkqKGRp+5ZobVpP6QtR1Sd7ZLdYdCCAH8+UzEsY50yU7e+lYYdl9S/3kTP0y2I9yDMHk+WQYF6ep0SblIlMbX86cft0J/o5k7jM12b4Jq2+zjLWnc1gWeqbFRW92X9JCwCJ7ckeywoBQKdFKtxVjhen84PuU4eCTHzk/2tBKvby+ZWoScF9oypWBEBUqHSG1zGwmcBeAC0waxxBI1YBdS+bOxHTucPgFqjBPZPL/YMUayCgDr/cQ7MJw8MTCnFRReDlDMTG7ilHWIxS4T0NRy5ojmomrvVVce17Kp40kjoaMirSw9CUQqOnP0QqrCzuQ4y8P+g8WWADryExxRIjcFfg+7GxxoMVdCOq7aqwHQ1h1lyQns5tyaGnDg+5sUrXTW1jvDF1ljzoI2DfKoI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qvJwFi85wch4nFWkWOyRvhQUK2hMD8kDW5MJhqQfkFPQguywmGXj6VnoZBvT?=
 =?us-ascii?Q?UQBdaa6O0+ST1WfdYSBQtCDsY+jtteuXGS7K/zz0aW3tJwsnMOAiW7Kq5tgi?=
 =?us-ascii?Q?U2sijSA5GKO6NnMa/ELmD3nCALnUuCVLVGH8+OWlIlxsdx4THMXt09evAC2f?=
 =?us-ascii?Q?NAfpKirSyJw12abgYRuS0WVj/7MATAe1EoEKPNHDK+sM8LicAJkSjRYeZTOK?=
 =?us-ascii?Q?FX33cn5XQH2mCe0gzADeGWBGSfjNSQy11y7lAyJ5uns/pOZB5Xnkp/+Iklz2?=
 =?us-ascii?Q?FFWqG35vqr4+t7F3ea8/qmMg8C+8F8DzugMomz5mp8ykSt0NOB4LXrsQQW7I?=
 =?us-ascii?Q?f4QQGToIPzIRVV6C73q7ddRiYl20wMSv1ToAVxKSEcWiwlWaGsq5w9dr0ibv?=
 =?us-ascii?Q?BtNuj9V/Fe0h44jWtC8T0PpWQyvEoUwnfGWOIeWIfhmPk1Y44FGywUArVgPB?=
 =?us-ascii?Q?+VELU/OH0ik8WwwemXsI7c2aNiS3dynVHsDqqcPfkSXh7LsUqK4CUFrV84SK?=
 =?us-ascii?Q?01RQowSn+utuGF+1hZWjXGDCbRkTUlZLKVP6IfjDHDNQ640Jo6/baWg2VFqk?=
 =?us-ascii?Q?EbiW62aPLNteXK32Yt9DrOkNgo9uTFMTWNCYEA7ItPTGaX1QstZQwayxefRz?=
 =?us-ascii?Q?+OVlQpkSclxj9cpfmEGSbMCwog+SQcmybjdXRcwivbSVxFuh08E9zEW3EiDq?=
 =?us-ascii?Q?6gvca+RaACHMKLxm2FuRpNNpqGL6tQDMkVoS66QL47azfs2a2GyoVpnbP5TB?=
 =?us-ascii?Q?m3Yd3fAxXdJc7gtr8sLSt651q1qdB7qpyRBvGvtP+cL9wTqy/8LzAQtXdeaS?=
 =?us-ascii?Q?deaeLPHJXG1roCXAsssl52GZbMzNOrdiCSP+v58JR2ZaXZj88fS51nowZz/d?=
 =?us-ascii?Q?KsSo39WK8UttF/74oPTw/dO9PhXFhsd/hLIIVGNTvlv0McJhhmFqiE+Xr908?=
 =?us-ascii?Q?R4YxDfJD3BVBrfLyy+LjlCkYZPLf3VXXmTvjrPcstwQ1Q/FFMz8BlSISCjn+?=
 =?us-ascii?Q?FjD184ld4U36HeFZrl9W+khc3LD6BxAlIQtnr0KDRb+HtvXxvMI4IDPJ6/w2?=
 =?us-ascii?Q?a7IopSmnuluP8rF/ka7AMjP5gZkS4Jey82pngsvelioH5kg7ovk053Gs9aR+?=
 =?us-ascii?Q?zuTbjRVf+2c89dozJXjR++ZwS5MEi44FMaNSnnxM3pNmqgdBmfyqN1Tkd2jy?=
 =?us-ascii?Q?u62qUFKjtaFS7FmI3s2ZCnP+nxoRYLO7Sb4qBG3Mz9PgDOe82gVxdYZwPWtg?=
 =?us-ascii?Q?kf2bz1/0wF3DiAUq0LVnEK64OP+UNuzSIRoZMQM3viJY/n6bdVl7+x5RCPfu?=
 =?us-ascii?Q?cIiBlxhfGxspHEMCm4k+rrmwivvjKXbCP5MV6C0JVuCopitFFZgEAHVFLkD+?=
 =?us-ascii?Q?+r9fbinzKbhMsYxt8OR6K8niZC7uHLrvd27XVFM8LFjR6guly78AG/1mFhOi?=
 =?us-ascii?Q?t5CDTXyHjBKEN2dVrZ3qzbOGCMHg2qioKQFxmxoCvX3yun2rQISA4l7njDjj?=
 =?us-ascii?Q?RU90dhFbAfOnsFBnqIDMepKo9oMrfMXkWoJ+XiMD2CdkhoHXfLpuFIDffND9?=
 =?us-ascii?Q?RxPsZvBrFZPrxAVkG8xMkzfjHnveb9RqjwK84EMY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7d6f05-abf3-401e-3a5d-08dab2848d75
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:19:20.5668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8QEkX2kJOGVPMEYIbDBbeGsUhIykS28K/C+GAd4op9BCcEJ4LEIwD4lR2Mg8rJws/EB2RJcNZeoCEp+JJRGdiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/nvme/host/tcp.c | 119 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 113 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index be13db3aa4da..0fe4ff9e098b 100644
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
@@ -281,7 +288,7 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 #ifdef CONFIG_ULP_DDP
 
 static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
-	struct nvme_tcp_ddp_limits *limits)
+				      struct nvme_tcp_ddp_limits *limits)
 {
 	int ret;
 
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
+				 struct request *rq)
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
@@ -447,6 +518,12 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
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
@@ -735,6 +812,26 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
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
@@ -754,10 +851,8 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 	if (req->status == cpu_to_le16(NVME_SC_SUCCESS))
 		req->status = cqe->status;
 
-	if (!nvme_try_complete_req(rq, req->status, cqe->result))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, req->status, cqe->result, cqe->command_id);
 	queue->nr_cqe++;
-
 	return 0;
 }
 
@@ -955,10 +1050,12 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
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
@@ -1256,6 +1353,13 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
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
 
@@ -2585,6 +2689,9 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
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

