Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B41B66E266
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjAQPib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbjAQPhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:37:02 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD2E42DDF
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:36:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMkq1d/Bss8VLioWWos7Pt36CrT/VES6qISW9FGWZ0nPB1yRN/VJWOUlBrYvlMo3GC/xggDjZNKzPKpiWcNPHG/wQEFgS9PrqhdnwdsXrZJFD225gUic64WAHsiT7+Yj7Y7sAKz4wz9hFQ1x6bMI35Ttcs7ccYIk7u7ma/X3q//sFXOeBqQ7bgXT48kOJ6Nd+tox46HwNoOAwCRBJLreXTU4vuOEEPeF9mBWec9DVfh3ESt5RcOPEu8t6delHqDj9GcFYDBHxjSeUOL7tAZvgDiP4ucuowoTPv91+RzZOFXa8T7l/iiVvJTI4aGJAqAWb2k43mBBcpYTWio1rvparA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DfXIdQQRdRYR4vmGdcijzjvZ42jTVNx/f21uXnF1phI=;
 b=ftqoVUp0k8DvUzhTXMsmSloO816Skpx94dUBAvl73mMwj6/bknrCBOA+zPI3AQiy7Rc8su8PPv3miBFbVzDN34QGubIXeppUAcbnbqi4PPajTa//RIEdpWXxyZX/ITxhtOgAke+FGPCKaCCc2OBxfjSW6QCOeLA+EQt5PdacWUHT/DGA8cqK2uOFvwb53G4rMZo9UGgGy55G59T6dxQFTTgniUv9N2ugYGpf5QeDAEuOfz0iPex7gPVwx7Qlsyh67N11OTdDCyaOrW9XX83Dir0E8MAO/VHEBbbHHhGHUI2GH4dNHXxO0awSF3MGm34CY3agqiQFBN7j7+DZFype/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DfXIdQQRdRYR4vmGdcijzjvZ42jTVNx/f21uXnF1phI=;
 b=XH10gYmKp+1csCZyxQ+fvXAXcV/vPENM8JEsFMoTZTReksX7ITPKc/s3Pkcu6lLm8XP3tvqKyqD0xWAVXaq8Q39eHrSx5qzs+RciKPbQ8XDAKUDmrhZL7orpPRV7f2YyOInlXaiOIMe7ziyS0npMJhQkQt/xrsECG+RF9wr4qqqVTbRA2GnmDo78WblMF8pApQVN+C+3w1t5va+iYn4v00AWh9+wfpdos8qTE7m43Cluxnhljb8absLPCYYqX4PwZ6Tkem/OmjVrnudveJCIOPAiCi2flUPYeUGrPbZ9tSgtMIZtm8W201ibNlmyW1e5M0Al4TfhfiCLdZ9ZkBycsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:36:48 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:36:48 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v9 07/25] nvme-tcp: Add DDP offload control path
Date:   Tue, 17 Jan 2023 17:35:17 +0200
Message-Id: <20230117153535.1945554-8-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0189.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::12) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 942a232a-e10c-4f61-44fd-08daf8a0a530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ndY2FcSayYzZnV3RRZviNI/GJnCrXfxmdjQl6s2teVroAUb1H/hO/rXGzcNYQP2Ajv9gs+Ts6nKSPFeQ9udciNih1guPytyfVgOpvcok21t830fjruNRrVPh0Jb+wNRUbVAWdgabfwAaYqOJP4fkrG51qU7fzdnAAFasQybgooAn62j69NxQ1RU6XQxOZtKp9caYnPK1LQxcpgFLP9Gape5cDXxyxHVI7WQ1Ff9vupDac4xLSAwLFx5r+z7QGaLwHZbHxjV8tlgNe5AdY736bjSQNue2tCRKYwGBFcL4WaORy2xl0digqiD7GNLQkaRll6Ivv5RNkVeBrnJITVAy4zlxAvIhII4kMRBbz2CYkAZj6sN90q3VqGSrvL/4x5rzmvU9uA5udTssmXukwESv9fZWnu3gZX7woZ9qvl1UOhbO7vWP+clATKLMJJRop904oko8K8tn41MsxIk3IvII1FRNFezRi5cl4wrOtzaCK7tz7l4D2jK/Zgd4fqbD+xWuwbZjg/E/weJYTZ/4drrdltm4dVZ9SrhRXeJ6ZUlkJZHpYnUVneAYTV7HbqVqxizWuUsIUlT137RZ7ya9G+UFp8h4/c09bG5B0gnJho2K283Ghs2ZJlSRXeKgYoOpVA0ooGZCfLv3tgc2wO5YhF6Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(2906002)(66946007)(26005)(4326008)(36756003)(8676002)(66476007)(66556008)(41300700001)(186003)(6512007)(1076003)(6666004)(107886003)(6506007)(2616005)(83380400001)(86362001)(316002)(54906003)(38100700002)(6486002)(478600001)(8936002)(30864003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iRyl7FETGaRwQR/nyf2rc2bPEJSNcI9THcEkFd65d/wXOiRHXEWzIFE/g9yJ?=
 =?us-ascii?Q?+D7EA+hrNceHxVZGvGlMHLhevJVO2Oe1uk5HLsjVd8qJYjITNQ6g/MXai0ii?=
 =?us-ascii?Q?c9AwY2HqqteYkVcZ/HrIZj4sKaOrlyZDVY9E6skqs2F2ZKfdkzAbiqIwVDWW?=
 =?us-ascii?Q?Jah0x6aBjNrPrRguSh5Kq/WecBYMwEYitozxKoaUf/00unk14p6ZwUhU4tWh?=
 =?us-ascii?Q?nE0Wveide2D79oJpLlgKZbKQN8+RjooGxhf247kdVy6GwXABzVQn+yicfl1h?=
 =?us-ascii?Q?lo+55GE5VCn/NG6ArUq3kJTnnzhdGuzoNQnFRePNj2dXLMja35XILIsMjrV3?=
 =?us-ascii?Q?vfma+VIXngEPEu6WkzvRMH+vSpK0dtiWVXfPp+KLJFbmuKy0wv83mKOKfuN/?=
 =?us-ascii?Q?48DQjYPsTAjvZWjCg2bWJV/fzqeD8sQTZauIh0xLci7b2/VQkHB5Ynx3wSOW?=
 =?us-ascii?Q?Tc/PU+mWhe/E15osB/i5A6EyyxsQwQKzjbZygpPjQZ+e9EirZGMLdVO9H4l8?=
 =?us-ascii?Q?s4HPrJ/hK1peLiL+8+KULv8sey7UKZGy8SPWzi0Y0vXDAXBcEp183ydG7AO+?=
 =?us-ascii?Q?pjFrPdkD3Za0zaaKfWlenzlpVRAnZrMF/P68GBcbJgt5ptH/1X0onBICmzn3?=
 =?us-ascii?Q?yVEfcXPFuUdJ7sxoE41qQDThnP6tMuSDv6uM+pNG9LYG2iWSQBDE0OR191Fy?=
 =?us-ascii?Q?EqMXU1+v2EVl9wsNsat62jzYBybQdPp2UfYtDcJPD4AGmfZ0uPF1hQkx1nOo?=
 =?us-ascii?Q?A5vvIdwjezam8MknY/X1GTreJw8E871ElQzyTZaXznUysai3/uCo1/qKLUEQ?=
 =?us-ascii?Q?74KenNmIFSrvx0WuSyGTqk3iTjXh6GDNBJjZ+a6hJsS5C/ophLs+hjBYnjk9?=
 =?us-ascii?Q?FfPB/JSeUWJYozNUxe1tsuh65bGZaQRkbjpD4PXDVAKt+eByeLUhcSvwE2ci?=
 =?us-ascii?Q?ALq+kiStqREcjBZaa26hfh/t/03woTvEUjjtrW65849Ip26vybL06P1PjGl1?=
 =?us-ascii?Q?swJZlo0an2uHL95VV7Io0kcDkL8tujNroUxtmJbxsmE7+j/kDvuf2+780ZVI?=
 =?us-ascii?Q?XykFjmVnpqkyrunx9WuyqoVqi4jpaSH9KXZOJlwZdjO+irmhGAFOnjTS8hEY?=
 =?us-ascii?Q?byxwBX6zIs/EMEHq9njaIyQXLloyR+Cf+PmXedXt7RbHAF3A3fU24ixcol4r?=
 =?us-ascii?Q?gRFPZo5ckuWwTqjZwe/Ue22/zZM0ZjoY6ovFA/7MKUIgub/QVccX6GDrFfG9?=
 =?us-ascii?Q?GU8jdj9jfJMf42Tpadoycw9bz6aEhqCkBKUM2w4haT5RIPwS++WKATzQ4f/n?=
 =?us-ascii?Q?a14xtMTdURtiZUBrj8/96ljSEoqyulQA51zQy3BOpyCM5yiSWBI/M/nIiAev?=
 =?us-ascii?Q?1kulIYIeqYs55yCmpVE9WXEuOJl+6HUh6EyX3euCpyBTwwrZrW2JFEvyCoJq?=
 =?us-ascii?Q?K5h/HZ4Mf+DTCi1p7XWCiqIuHd99zyVaG9U2O/E6YQDoXhIT/jtkg659/Wla?=
 =?us-ascii?Q?RQrDXfsALUA9MKKFkqdjw4jpWRx5Vc6OOFx5UJSXEjWOpycr2HO1+q37G4OV?=
 =?us-ascii?Q?vbxmHM66j5mVGSw2eS1pvbad40l5IoRqmka7EzGo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942a232a-e10c-4f61-44fd-08daf8a0a530
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:47.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kS2QkNdj3+CahOA9vlKhOPPF4AdW23VHhfdsOm9dN2JEA+mdhJad0IYXqfJZfP2B0gcBNgux0pKebXvD/Xx0hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
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
index 8cedc1ef496c..c22829715cad 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -15,6 +15,10 @@
 #include <crypto/hash.h>
 #include <net/busy_poll.h>
 
+#ifdef CONFIG_ULP_DDP
+#include <net/ulp_ddp.h>
+#endif
+
 #include "nvme.h"
 #include "fabrics.h"
 
@@ -103,6 +107,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_ALLOCATED	= 0,
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
+	NVME_TCP_Q_OFF_DDP	= 3,
 };
 
 enum nvme_tcp_recv_state {
@@ -130,6 +135,16 @@ struct nvme_tcp_queue {
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
 
@@ -169,6 +184,9 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	struct net_device	*offloading_netdev;
+	u32			offload_io_threshold;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -260,6 +278,198 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
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
@@ -702,6 +912,9 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_resync_response(queue, skb, *offset);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1657,6 +1870,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
@@ -1676,21 +1891,51 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
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

