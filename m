Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6856899B2
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjBCN2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjBCN23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:28:29 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAB0646A9
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:28:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlH2/2ssNKmOVneId5JzIgHZvggBZfB4k6+xpX+EeCFNVpNKbJSFFicpnUBzPS+vv1PGlTmhPvOs1BAJGDt2BxjX6UM2YxZJrgj+1dynFRHStnraKL1WYtNSHGpWWxUP8G0GB0bewV6VAF+lTCVgRGL95Lqu6jaSZq/w77+ufRmIxRCJuJuJpJL6h64fGMBodnSaTLeq8Y5GFLvI0QhySQu6eHWj6Rd7ZwS9Sb4LJLuABdAKS1G8VtHgPWkagi+bvZ69kEAZMGQUNDnWwfvR4UOJBcZV86/dSlEqN/nuuUC+DK290jMFy4dfnJTp1wVD65uNZwdJhpNVXtHvRg3IJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3X1xxnLcvqublCNEtqddms2kV7RobqmXHXqnP41Cp6E=;
 b=Hl6Y5Q2tIdVrWb+boo77lkPttR/XgKflYComxD/cni86pmSX0OIJWIuPNbC5Aj92ZFqr9SY+w2zsakUPEB+gz70xZM3h6tLTvi0HCSKmsmtY9MS6aNqlpay9SRjcIsDSrsfOMxOtZ+GsKJfDDvCtmGQDvn5JhpG5qhjyUHu+A9oyz02WqVGUQ4stvpv+uoISuwbwJbNYwzUyGkmyrU4g24pCk0/4xBLzdA2OWd1JNLcK09W5po7UiNjwvH8tOQR1fDX5kfs6QKAup4zxj3tHzOYdzMV1aBv3nAdWmh0aIAezlXtRgWoJv0LtkLBU9Qe9YhHFcilKiqKX8vdj6agH5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3X1xxnLcvqublCNEtqddms2kV7RobqmXHXqnP41Cp6E=;
 b=Yw621Cj1OZA80+gKHgWaIObV/zpyQ78UvwO9zEs2dk0vhyJ/IXWho6VfJ9KwIUNOLi4Y3dD4SQ6S40PP+XlrWIyRFMTV9gXijjInYA5r7thP24+h0zuAJqZV6aEmvs6loM3cJcMMh4ezKEQtBg3snET/7L2juasgmm39ACQOvmh0vsMgKZ8D0KJkydeGyhfXXab7vlBQwruwxliI+yLVmzH4bmkXRyktcBWspNHco3ympjgKcsBXIwEmnIAqqERyazw2qfSASxq7wy0ORvu7OZofZ7c9/jF1p6KD8DIGNhBM3Pkvnj/MjB74A9LenXyREZR7Isz85bXpwOVZVputpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:28:03 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:28:03 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 07/25] nvme-tcp: Add DDP offload control path
Date:   Fri,  3 Feb 2023 15:26:47 +0200
Message-Id: <20230203132705.627232-8-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::15) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ecc40f-8073-437c-ee55-08db05ea7a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdObScBRd1F2xPL6L+m3IK9bflXgausyjqRXxcxobZ3pVFaltjsD7MJucvHeIfv2fBRwly0/c/9ouhSaRXgu3DfaaBZRhRf4oEGdxraFo1baoRHVwsJw6wCxFiZfTnMf2tHKjJbuxGbEx+sxIGNLRBRBp8kRzwvKJny+NLb60RRNj/Ic7Go8DHYCGIU3NaKapFgdHfyfG5LJ2eD+R9SKaUWWr1Mez5bjRvItr42qZy2ISH1lUjppE1j/K/OF+9sXc6h2L9vsUTYqMZMmWJF+pzatIo/Zt5iSice7TCVEs4wh8X24FU17U0dB5DWegHXcjZU8wS9274GF4xSl/NPJR8tC+7v+xYPY0tq8Y7AfnZP5047+aWiIeqmThfS3j7tXTrIuygLlSXd9SlgYyTiUDXl8XokGgTeOqEmUJ7xFkVpvmUmPfwi6F0AepdQczaIRqgBw6X5x5EVOu5NORe/V5b2kq8B4zIAvvqEVc9S59lhlfqUMPIvds/heitPBWdklWHmxvaegsjfTIRfcLcnuAVXr8TTZOaq9uqKlfBGxfmQ6oV+g0bH5Jg6uw47N9A9Gv6QUZWu0SM6XNOTvMDwUiGBcNuXaXvUHdIGnCq4Tk1jPBuSEnWcLPmBq9lLbrYPTLpUIplpuk3g6P7p0mbIg1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(30864003)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NAlhri7kMeaE7d31ye16sSdDujpEIZF42uQTPk/LJ7uBZj7hGQd6YJouCtPQ?=
 =?us-ascii?Q?sEIKLvWuqf8doNDMRcshcRp0YYpWbSakXDVuCkHSEpMd5jSXmlF1sR2+X/JG?=
 =?us-ascii?Q?vuWRcz3EOWl8b6TQ3kMPiv1n+O8VwQ+RpiReKpOzrPWoATB34+pJIMHoIceY?=
 =?us-ascii?Q?EHeL7JMxJC+ri+jWq7wyljyF26LGS+clXW+vcTwgGrWolCm/898mN+EVZEUV?=
 =?us-ascii?Q?Qe9PVFEi7bK/zwztjJRnxIAk1BcbhzxPmeyzDGQj8Mtq7nAtKrdQwVtX8bhw?=
 =?us-ascii?Q?KrL0/rfhI4DOgYJfroj6Z7Xjs8uWThcN+7i3MxsKZ8+XRrPPQAf/NDMNPeUE?=
 =?us-ascii?Q?19Ao1xdkjpNYgaatSoOtQrErxc0kt5i8s4UDiR3P9gSNuiJgKKnNGr74rq/0?=
 =?us-ascii?Q?I98ucEXaa+GpK+iXEyXrtLaCA30Mfp0JgdDVlzbHDAqNOnmFJ2HaDrcnXV2v?=
 =?us-ascii?Q?MUIdOGzxMeMqzCRZ/rWUGFlb+dG15Tqsj080Vzg2vNLN20K+WIIviVoGAxay?=
 =?us-ascii?Q?SqHx6yG1OG/cvR9gBzsAd3iXymSD3VkAHmHqWtlXQobyCf8LaiubGl5gh82/?=
 =?us-ascii?Q?wfSTdJb8WCAmGrwyR/qnoeJn3n+27lkWZc5LK4v5Sb1P+SrjWz9TSmZUtmR6?=
 =?us-ascii?Q?5URLPtbJbEWGMxATGki+aAlzOufeeCTr1v5Wvh/BJwWmdKYrZhaK+cyJP8jc?=
 =?us-ascii?Q?uP/egrZKs4wMFPypn/wClM9Xv2cTjofm6Mzej9ETYuu+a3Jkh+/aSUKGLYMl?=
 =?us-ascii?Q?DdBVkneVMw+SQdDO6qYBDNDxua9zsWywM4pZOXuOX2Lu0kNH2KEtoWMQkB1L?=
 =?us-ascii?Q?vWpfZwqkuHZxcCYBzaUKR1xckmSB4VjmDAMSgIBDcW4fueS989xxjcdahFJP?=
 =?us-ascii?Q?ECU1L+wMJ7sfoXZLyHQ3crmbpp1S4dnYeLLz0yfwgc3rsilz4BTPzXpk6sON?=
 =?us-ascii?Q?Dsyd8b/VqNCp6uRiIideeFJMV9MCRM4kOF8+wCqM7iOKzSN5dgRn6W72EWgf?=
 =?us-ascii?Q?OSbYFcqL/qRk6w/mfjANKSGQZC5dLrQ+Uh5uJMLuScwcpzRjp0XBbuHPDY6+?=
 =?us-ascii?Q?d/vDE6F71prbY/pPXEOQGN0VcOMdJI+nT//UuqMvFxoAOntkSTrF9bp4ZoJn?=
 =?us-ascii?Q?Hg9yU4L4Wv0c+4PAK1n85S/cqK+9hHj6mmD0BZtyvRa5WTY7vjSak2mKmh6Q?=
 =?us-ascii?Q?j6TVQVFWIqs51EQ/7mByrGUbwmn8hR77ZTLjE60nl0b37+bdbWB6rLlj7TIY?=
 =?us-ascii?Q?KUb04OAg+xW8GXuyp2oFidZDLzZc1AG1wPExJvRbc/3TAP9HgcTUglKeGaXk?=
 =?us-ascii?Q?ndQexkWgO897DtEIGjXqwhx1IbH4Nk5Mr/vNh2NJduqBEAUCigA9DdzdLoVi?=
 =?us-ascii?Q?2DUcBTuHfDwy69TXGS1bQleL6WttUB20KhJSOZU9aaf6wY2DT4zM+RG4CEtO?=
 =?us-ascii?Q?KdtPyrwAqiM1L70AyboC/LkbBpC0Thkwy86fFV8jjmNCKV1w6uU/7EuohvO/?=
 =?us-ascii?Q?Oxc29UgUMEOa72YEpdBFZbR7e6MLQ9Vv2iC7oJUkAVYJl4V3JpJtj3c8gPgc?=
 =?us-ascii?Q?PInhZKrZykpH5iNSC370ayBFknr2Oy/FH4uf7CGy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ecc40f-8073-437c-ee55-08db05ea7a13
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:28:03.4169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+nr+ysbAfebtkzRk+rSJduZKBcqiYtWdsOaGmOH+uBuzeZB+FV4U+qv1J8vJKiSqQ9UgWTiWnY/ilN24OSuUg==
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

This commit introduces direct data placement offload to NVME
TCP. There is a context per queue, which is established after the
handshake using the sk_add/del NDOs.

Additionally, a resynchronization routine is used to assist
hardware recovery from TCP OOO, and continue the offload.
Resynchronization operates as follows:

1. TCP OOO causes the NIC HW to stop the offload

2. NIC HW identifies a PDU header at some TCP sequence number,
and asks NVMe-TCP to confirm it.
This request is delivered from the NIC driver to NVMe-TCP by first
finding the socket for the packet that triggered the request, and
then finding the nvme_tcp_queue that is used by this routine.
Finally, the request is recorded in the nvme_tcp_queue.

3. When NVMe-TCP observes the requested TCP sequence, it will compare
it with the PDU header TCP sequence, and report the result to the
NIC driver (resync), which will update the HW, and resume offload
when all is successful.

Some HW implementation such as ConnectX-7 assume linear CCID (0...N-1
for queue of size N) where the linux nvme driver uses part of the 16
bit CCID for generation counter. To address that, we use the existing
quirk in the nvme layer when the HW driver advertises if the device is
not supports the full 16 bit CCID range.

Furthermore, we let the offloading driver advertise what is the max hw
sectors/segments via ulp_ddp_limits.

A follow-up patch introduces the data-path changes required for this
offload.

Socket operations need a netdev reference. This reference is
dropped on NETDEV_GOING_DOWN events to allow the device to go down in
a follow-up patch.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 263 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 254 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 70e273b565de..b350250bf8fb 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -16,6 +16,10 @@
 #include <net/busy_poll.h>
 #include <trace/events/sock.h>
 
+#ifdef CONFIG_ULP_DDP
+#include <net/ulp_ddp.h>
+#endif
+
 #include "nvme.h"
 #include "fabrics.h"
 
@@ -104,6 +108,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_ALLOCATED	= 0,
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
+	NVME_TCP_Q_OFF_DDP	= 3,
 };
 
 enum nvme_tcp_recv_state {
@@ -131,6 +136,16 @@ struct nvme_tcp_queue {
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
 
+	/*
+	 * resync_req is a speculative PDU header tcp seq number (with
+	 * an additional flag at 32 lower bits) that the HW send to
+	 * the SW, for the SW to verify.
+	 * - The 32 high bits store the seq number
+	 * - The 32 low bits are used as a flag to know if a request
+	 *   is pending (ULP_DDP_RESYNC_PENDING).
+	 */
+	atomic64_t		resync_req;
+
 	/* send state */
 	struct nvme_tcp_request *request;
 
@@ -170,6 +185,9 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	struct net_device	*offloading_netdev;
+	u32			offload_io_threshold;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -261,6 +279,198 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+#ifdef CONFIG_ULP_DDP
+
+static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
+{
+	return test_bit(ULP_DDP_C_NVME_TCP_BIT, netdev->ulp_ddp_caps.active);
+}
+
+static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
+				      struct ulp_ddp_limits *limits)
+{
+	int ret;
+
+	if (!netdev || !is_netdev_ulp_offload_active(netdev) ||
+	    !netdev->netdev_ops->ulp_ddp_ops->limits)
+		return false;
+
+	limits->type = ULP_DDP_NVME;
+	ret = netdev->netdev_ops->ulp_ddp_ops->limits(netdev, limits);
+	if (ret == -EOPNOTSUPP) {
+		return false;
+	} else if (ret) {
+		WARN_ONCE(ret, "ddp limits failed (ret=%d)", ret);
+		return false;
+	}
+
+	return true;
+}
+
+static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+static const struct ulp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
+	.resync_request		= nvme_tcp_resync_request,
+};
+
+static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct ulp_ddp_config config = {.type = ULP_DDP_NVME};
+	int ret;
+
+	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
+	config.nvmeotcp.cpda = 0;
+	config.nvmeotcp.dgst =
+		queue->hdr_digest ? NVME_TCP_HDR_DIGEST_ENABLE : 0;
+	config.nvmeotcp.dgst |=
+		queue->data_digest ? NVME_TCP_DATA_DIGEST_ENABLE : 0;
+	config.nvmeotcp.queue_size = queue->ctrl->ctrl.sqsize + 1;
+	config.nvmeotcp.queue_id = nvme_tcp_queue_id(queue);
+	config.nvmeotcp.io_cpu = queue->io_cpu;
+
+	/* Socket ops keep a netdev reference. It is put in
+	 * nvme_tcp_unoffload_socket().  This ref is dropped on
+	 * NETDEV_GOING_DOWN events to allow the device to go down
+	 */
+	dev_hold(netdev);
+	ret = netdev->netdev_ops->ulp_ddp_ops->sk_add(netdev,
+						      queue->sock->sk,
+						      &config);
+	if (ret) {
+		dev_put(netdev);
+		return ret;
+	}
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
+	set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	return 0;
+}
+
+static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+
+	if (!netdev) {
+		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
+		return;
+	}
+
+	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+
+	netdev->netdev_ops->ulp_ddp_ops->sk_del(netdev, queue->sock->sk);
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
+	dev_put(netdev); /* held by offload_socket */
+}
+
+static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
+				    struct net_device *netdev)
+{
+	struct ulp_ddp_limits limits = {.type = ULP_DDP_NVME };
+
+	if (!nvme_tcp_ddp_query_limits(netdev, &limits)) {
+		queue->ctrl->offloading_netdev = NULL;
+		return;
+	}
+
+	queue->ctrl->offloading_netdev = netdev;
+	dev_dbg_ratelimited(queue->ctrl->ctrl.device,
+			    "netdev %s offload limits: max_ddp_sgl_len %d\n",
+			    netdev->name, limits.max_ddp_sgl_len);
+	queue->ctrl->ctrl.max_segments = limits.max_ddp_sgl_len;
+	queue->ctrl->ctrl.max_hw_sectors =
+		limits.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
+	queue->ctrl->offload_io_threshold = limits.io_threshold;
+
+	/* offloading HW doesn't support full ccid range, apply the quirk */
+	queue->ctrl->ctrl.quirks |=
+		limits.nvmeotcp.full_ccid_range ? 0 : NVME_QUIRK_SKIP_CID_GEN;
+}
+
+/* In presence of packet drops or network packet reordering, the device may lose
+ * synchronization between the TCP stream and the L5P framing, and require a
+ * resync with the kernel's TCP stack.
+ *
+ * - NIC HW identifies a PDU header at some TCP sequence number,
+ *   and asks NVMe-TCP to confirm it.
+ * - When NVMe-TCP observes the requested TCP sequence, it will compare
+ *   it with the PDU header TCP sequence, and report the result to the
+ *   NIC driver
+ */
+static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+				     struct sk_buff *skb, unsigned int offset)
+{
+	u64 pdu_seq = TCP_SKB_CB(skb)->seq + offset - queue->pdu_offset;
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	u64 pdu_val = (pdu_seq << 32) | ULP_DDP_RESYNC_PENDING;
+	u64 resync_val;
+	u32 resync_seq;
+
+	resync_val = atomic64_read(&queue->resync_req);
+	/* Lower 32 bit flags. Check validity of the request */
+	if ((resync_val & ULP_DDP_RESYNC_PENDING) == 0)
+		return;
+
+	/*
+	 * Obtain and check requested sequence number: is this PDU header
+	 * before the request?
+	 */
+	resync_seq = resync_val >> 32;
+	if (before(pdu_seq, resync_seq))
+		return;
+
+	/*
+	 * The atomic operation guarantees that we don't miss any NIC driver
+	 * resync requests submitted after the above checks.
+	 */
+	if (atomic64_cmpxchg(&queue->resync_req, pdu_val,
+			     pdu_val & ~ULP_DDP_RESYNC_PENDING) !=
+			     atomic64_read(&queue->resync_req))
+		netdev->netdev_ops->ulp_ddp_ops->resync(netdev,
+							queue->sock->sk,
+							pdu_seq);
+}
+
+static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
+{
+	struct nvme_tcp_queue *queue = sk->sk_user_data;
+
+	/*
+	 * "seq" (TCP seq number) is what the HW assumes is the
+	 * beginning of a PDU.  The nvme-tcp layer needs to store the
+	 * number along with the "flags" (ULP_DDP_RESYNC_PENDING) to
+	 * indicate that a request is pending.
+	 */
+	atomic64_set(&queue->resync_req, (((uint64_t)seq << 32) | flags));
+
+	return true;
+}
+
+#else
+
+static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
+{
+	return false;
+}
+
+static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
+{
+	return 0;
+}
+
+static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{}
+
+static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
+				    struct net_device *netdev)
+{}
+
+static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+				     struct sk_buff *skb, unsigned int offset)
+{}
+
+#endif
+
 static void nvme_tcp_init_iter(struct nvme_tcp_request *req,
 		unsigned int dir)
 {
@@ -703,6 +913,9 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_resync_response(queue, skb, *offset);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1660,6 +1873,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
@@ -1679,21 +1894,51 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	struct net_device *netdev;
 	int ret;
 
-	if (idx)
+	if (idx) {
 		ret = nvmf_connect_io_queue(nctrl, idx);
-	else
+		if (ret)
+			goto err;
+
+		netdev = ctrl->queues[idx].ctrl->offloading_netdev;
+		if (netdev && is_netdev_ulp_offload_active(netdev)) {
+			ret = nvme_tcp_offload_socket(&ctrl->queues[idx]);
+			if (ret) {
+				dev_err(nctrl->device,
+					"failed to setup offload on queue %d ret=%d\n",
+					idx, ret);
+			}
+		}
+	} else {
 		ret = nvmf_connect_admin_queue(nctrl);
+		if (ret)
+			goto err;
 
-	if (!ret) {
-		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
-	} else {
-		if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
-			__nvme_tcp_stop_queue(&ctrl->queues[idx]);
-		dev_err(nctrl->device,
-			"failed to connect queue: %d ret=%d\n", idx, ret);
+		netdev = get_netdev_for_sock(ctrl->queues[idx].sock->sk);
+		if (!netdev) {
+			dev_info_ratelimited(ctrl->ctrl.device, "netdev not found\n");
+			ctrl->offloading_netdev = NULL;
+			goto done;
+		}
+		if (is_netdev_ulp_offload_active(netdev))
+			nvme_tcp_offload_limits(&ctrl->queues[idx], netdev);
+		/*
+		 * release the device as no offload context is
+		 * established yet.
+		 */
+		dev_put(netdev);
 	}
+
+done:
+	set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
+	return 0;
+err:
+	if (test_bit(NVME_TCP_Q_ALLOCATED, &ctrl->queues[idx].flags))
+		__nvme_tcp_stop_queue(&ctrl->queues[idx]);
+	dev_err(nctrl->device,
+		"failed to connect queue: %d ret=%d\n", idx, ret);
 	return ret;
 }
 
-- 
2.31.1

