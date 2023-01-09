Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A38662721
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbjAINdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbjAINcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:17 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3363F1DDE2
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWtj9SqfV6werDJsPqBFcGTnC5nn3VnvwponWibBuMqLPwQdUByKDHz5iuXOexo8mZJ66WxNXw7BgV88ksI1MpfmJ2qA14v1EJCrHctz2sNqOGUd24Mdq06etiNHZikqxENOzuQR+0ssNYP9bB7FiF1JICcg0qJuwVuEDYRhrGZRiL9LdUim8p5aGjRFWU6UsT7QWdb1F8CWgrZpDeab+mmgqiT7D9+B4CJJ8D8GrS5iPikmy6oQcLd2Mdxrc1NtYe8JQ2Bq1jTgNIEyLs3QqhGHpPkuUsKme5wp8Y75nZaBTtNKXiydj67d5H8LQSlXBxVRNKDb+hcUJ08qsA+IyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMDSXqKkke0brmzCDWyLRI4uZCpji67Vq/Y46PmW5BM=;
 b=ZF41ypAFaRp6xCvz2RNQspYUIG96eMk0kFgCQSwNewBY7mz7Mgh2R9klkBbaqbgXfHE77HzapVy+L5cFJdPiGs7fxGXSpVbUwlMN5PHvHseXkk8FacjaB11n/IUe8cnq4wYjGCGy3ZjeG381+sTgvJq1Rjp0Wn0ioAaSDTPrGYf+dHXkF4+4wmBJO63VimIJrW+2uDLd1s9Pg3DqU6TMBpW2zM1m6to1r/bYY0VThprk+YOFovsl60YYmqiQIe5WkJQHfKtvVCH1w4Jg/xSw4IqhHdzDVGnPL0BB2++g4Ewc1ob0n0HHzw0kDyf3X3ZqaOSiGMbX2XNKewdFpVlHaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMDSXqKkke0brmzCDWyLRI4uZCpji67Vq/Y46PmW5BM=;
 b=IMboiWDKwj0xuxIBCtHlDgSqMMkhgFJ6pQKQn0MT8PocqJEKT0EAT4R18e0R/m9Q7YyA0H3ugL3C6pdQonN6O+4esOc2N/3t3lKhzATQcMB13buOO5omSPblHE70hE+s1+sE3Ln2Gp/xAoM59hZXiL4cXFkhI1o5ZC1LVmyLhPbcAHI8PviMOH4itaPf+fVNyWptr7/cNuL/X0Y7FxRD8GNDAxIAn6G9q2FWNhb2iqDpE1uSQEY9eLnN9BOYya7L+rRa80/RQd2YkMBd/CGyO7Xiv4hoH3V8dp8hVORyrmjRtp8YVH1U/nvdqWkbnCkum4b3CPUFGE4I0VsJ+KRNmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:11 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:11 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Subject: [PATCH v8 07/25] nvme-tcp: Add DDP offload control path
Date:   Mon,  9 Jan 2023 15:30:58 +0200
Message-Id: <20230109133116.20801-8-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::8) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 26b08fa4-60f7-445d-586b-08daf245e988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TuqoqLfXhQoGJIYT/eAbU9gVSRPVXrmXbeY3UONRFmqCHDaS/moGiAFvcBwBTd8I0+ipX4w3RxQ/yhxM4EixaIt969X0+f+7lTYZVvV1mUVpJ5VmXEhL7Z7dYfiw/9oCCEvr52wT2Eg1SV5SodwY4aHZsj2CjVKy6ku6Kw4+bY7KTlR55OIlCySh+wsaxTjqh6uE8H5NT/lRMAp3astqpAN1AgIjMObEvb3axQxwWa9WQHEaREcPjni1uq/4UeICNYf0R2WBvroR8NzNDnhdPYMLEU+q0a8TOee34nJxWjaI6r4e1N51ZbwM0qgS9UwxMrbePcaGQRZsXzthTlhpnHW+eWOFPKW6fPb/wwmRRlChmwJg17rF/mybNJgz+7x0+/8LUtDjb3LKobB2vhQXM2aV/h+rmEZ7IZb+p7+XTXcackKcxq0KLHgAkKqqMpcX5rRZNPYh4o8azbdOcwIgD6oQ/MQLkxMtE16RFiO4Bk7sALk45rfHQr3kq7O+OnlKjrxbQTIq6xbnxFMrBVXgz8zjVhTE0X8beFIxftQv6EsXovhzDd89LuDz0MapfP07FSI4M4wzkLdg2I2b4uAEmiNKMDYuT3ExXzrxujugdzf6jUjuSfirZfIdGIL2Jjp5Vsk+NC/GbyeTeKcIJLgDOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(1076003)(30864003)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(2616005)(41300700001)(54906003)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(6506007)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m29gAHbKnS9Rz4qNmlKDtlHGeRKngWNvTcmkcsa8yikE9gzCv7/L0SOgmG7W?=
 =?us-ascii?Q?IHINrembmOVF5z4EHE4tLN2HANCsalQlKpsPGJc1bdkyxwCn8HfrKBNc1ihV?=
 =?us-ascii?Q?mja5xPapl1lYVyh4d7mboD4rprTaSZVxXwTLczF95tKU5FUbS7Zb95DlIqO7?=
 =?us-ascii?Q?Wcvmhz/U6mgfWscSS6NeVePrLHwlAeWXAnUSlC6yHhHSaV0F/o7UfXRQQsSu?=
 =?us-ascii?Q?+a0shh4x6SSu0Q2w10HG9HR8mlGyxiHIYQIdJRTXi1r6TPjWqj8dv+E3xv7f?=
 =?us-ascii?Q?gMhq0XgnBgD3h9YFu0Y3Abc262P3Cucrm6ahLiZWU/Ox4JfUDYwQzH2+hRdq?=
 =?us-ascii?Q?4oIRkkX/+49rvDl/Rxkj7mYDeCoY2tKeo9+qLIhTQFQlfRlMR175OOEB9Nw9?=
 =?us-ascii?Q?e5V4JlDFJMK9Ihac+vhbTkE3f7YdnNVzXmvL/GE16EXqs7h6gNiF7j5aYizB?=
 =?us-ascii?Q?p6nbZNCLeFr4cl0vFAYncuSmeYVzpuk79m5vIsg95fvpiDO5Ysml7mx0+eNz?=
 =?us-ascii?Q?m9w0XE1HDoucdNAKUjW1TzU5ImBiDvfv/GNfnhhZFKRpa6WrzIrULHNht0nd?=
 =?us-ascii?Q?79pZqsRvR0LdRxsP+8Vb92O2T7/Cf3qQXczXwwzx77RDlP1NOPcCC0VYVR8f?=
 =?us-ascii?Q?PYuCB2kUjDsYJihPp8rpsmztIKdlA33ZqrO2BfZX8OSBRlwhtZbS1ge7twd1?=
 =?us-ascii?Q?dwkUvGC+WZVF1kAfXCrvWuLb7F2VM5NYpf+NwTs/0JqyvJ3wiJ7fKaqoBdDG?=
 =?us-ascii?Q?7ra0dReiFhoUZJypDlxF/5tXYb37ygrV+M87tYhW00ZbDsCfzUBqxcnCn5w3?=
 =?us-ascii?Q?7bUoRDrIuAH8PTmAjGhQgBkc6A9B+iCfex+3EW1NQe7T0oqh0nGSES7vd9od?=
 =?us-ascii?Q?WPOeKIRqF47254QDq3gNYGrkkjfGr25T8DVPZhsr3ZgxhMvXynKGOo4STbP2?=
 =?us-ascii?Q?DkdAt4TXPkXR+N7XjEvzN1AZYr/ToH7HaXXzsnUMCvHe4Kv8aRMtBZu86m6l?=
 =?us-ascii?Q?4QaJTpc4fKBAhlKWTgqoGqFhZAnwjlNHgJrC1ZPOEdKhEhDbXivS4PRXVmS7?=
 =?us-ascii?Q?vMZLaZFNn22Iz/vlYp3nSXd2AVOv4xyDgLtH4YAFHvGfJlU12t2VyCzOg6QG?=
 =?us-ascii?Q?ETJqPR5HBbGIR74l5KPUrl37MFZSMZI6vg1fcs6BwJjWfx+1Nn9WT0R6QVXG?=
 =?us-ascii?Q?LbeltAMq2LCOHaoOnEV7UPzUb3rebO9KUFl3LAyFDJPGcoH3XPDB5PjgIc8C?=
 =?us-ascii?Q?lr/gM4Mu8ofM34JwPkP5uvljUgvh/Zkzzb1N4HeD+uyicb1d9h2OHilYH1VT?=
 =?us-ascii?Q?+MiCfezDkTyss6T/ga9Ef57BtTb8t7saHBeX28S8MAX8MztSm5JcaD5cf/x9?=
 =?us-ascii?Q?tfkarVAjUxCQFUFrTYE9XMUntLL9hrOEp8iqvlaNdFd5ZXO2RYqZCxWN4Fby?=
 =?us-ascii?Q?TB76+mBgqpadpQfW1Jcic2Uii+zKuH7QBZCTEAqzgQFf7yqfIAvOxYb+ZfE4?=
 =?us-ascii?Q?o+IJDEyFf9MhzaJ82D3Y+z3J9qcFtfAOKUPSC1h7ZIz2GKvkg8fIrBQ5HmlK?=
 =?us-ascii?Q?XAZmio5xohZcj+r/xZ9HtlEWuSt59x/D44bIDacf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b08fa4-60f7-445d-586b-08daf245e988
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:11.3694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYLyrr6IJZKu93eXvnDREWiEKwBAd4KtrlPDVX/vF2xQUTRvc0iZXlF1J8lTAOP3edAUNRhyMX/QuqDT7Kpayg==
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

This commit introduces direct data placement offload to NVME
TCP. There is a context per queue, which is established after the
handshake using the ulp_ddp_sk_add/del NDOs.

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
NIC driver (ulp_ddp_resync), which will update the HW,
and resume offload when all is successful.

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
 drivers/nvme/host/tcp.c | 252 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 243 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8cedc1ef496c..3c35290d630f 100644
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
@@ -260,6 +278,190 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
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
+	    !netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_limits)
+		return false;
+
+	limits->type = ULP_DDP_NVME;
+	ret = netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_limits(netdev, limits);
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
+	config.nvmeotcp.dgst = queue->hdr_digest ? NVME_TCP_HDR_DIGEST_ENABLE : 0;
+	config.nvmeotcp.dgst |= queue->data_digest ? NVME_TCP_DATA_DIGEST_ENABLE : 0;
+	config.nvmeotcp.queue_size = queue->ctrl->ctrl.sqsize + 1;
+	config.nvmeotcp.queue_id = nvme_tcp_queue_id(queue);
+	config.nvmeotcp.io_cpu = queue->io_cpu;
+
+	/* Socket ops keep a netdev reference. It is put in
+	 * nvme_tcp_unoffload_socket().  This ref is dropped on
+	 * NETDEV_GOING_DOWN events to allow the device to go down
+	 */
+	dev_hold(netdev);
+	ret = netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_sk_add(netdev,
+							      queue->sock->sk,
+							      &config);
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
+	netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
+	dev_put(netdev); /* held by offload_socket */
+}
+
+static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue, struct net_device *netdev)
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
+	queue->ctrl->ctrl.max_hw_sectors = limits.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
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
+	/* Obtain and check requested sequence number: is this PDU header before the request? */
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
+		netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_resync(netdev,
+								queue->sock->sk,
+								pdu_seq);
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
+static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue, struct net_device *netdev)
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
@@ -702,6 +904,9 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_resync_response(queue, skb, *offset);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1657,6 +1862,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
@@ -1676,21 +1883,48 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
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
+		/* release the device as no offload context is established yet. */
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

