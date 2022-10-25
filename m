Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E0360CE46
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiJYODw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiJYODX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:03:23 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B22193EE9
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmzEycFDbTD/51hLqUd+qP1aYMcPfvNW1GY9P/MQqPUdo7tazxNylTAH8F00snou1zdm4gk7wk5FVaxtFsAI6KaH0rUhmGXbfIjQVubav425AxhcLTqnnrbh8DFTPbs4KFlCnmbFFLV9hNtEBufHFEwy5A2DYqFkVXfPos1tjmTAzawINxWQZajISQgWhzhIFHaP2xmpFkTwc+JNEeEJbmNBrsUkCp2nVFCKQAD/pstPXQVmi6XjBTp1ix5nwViKS+T9stwhfKWRviK0urAReL9LkxOGXRiwurDv39C6X6qWGqZZ+hk17Ag6smyxr+DTzEYM93C8bn2VmJFcHJ9kGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dbU/bxAhjKIOj9Xq3U3fwbIclTA7oF4rTfeoi1PPlmQ=;
 b=I3aQ0huShR/SIozxIZYlhCmOpA1Pkjhdv6aKp1V/gghM9GCs8BXGOx0McUcANHmOdZZ+JrurUOZYv9XUwmzjMuZcEpzWGfy2U0Tt7I+39SdsXuJ0kpqWQvrJEUJ4mIA/oz0MROKMyJWf9fujnTAL+hXs2mt6d3uO43BKJuD0JplQ3empshhS25RQ5MTuZFM3LVu/cm8Z2m1uFKZtYOOUx+H1sY7AlRElWLSXaIi8a0vj59VJwuNCSK8VRD7JSbMWJ6IpDBp5rkprtxkgqSLWkpyZ7l35xiLy/P7dCcdI5LatcrX3FmjNznuNgRGYYp654h/cPTLW3PABKaFRIjEAqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dbU/bxAhjKIOj9Xq3U3fwbIclTA7oF4rTfeoi1PPlmQ=;
 b=F6Epx7SQviVzUsmHehy671ygFONSoMbquHxwItGqvYjNy/9UbHtMRhd6urdMW/vFUOFJcVXKW6p2zBvSgxELoe2CBlsmZ4nEZs+W8Mfte428yCcd7e/sIekysGPyQ5jyhVO6tZvVQgH5lCWfjeZnVmJZWXrs3hgSlzGucR07LhlfJKXNYIXE8qTJ1jAoEW4I8CfQnUE87kgXwjdSHB6Gnfuw5LT2xskWpLRTFq+SwPq572g0Z8G902A0sVD1PuBZOxWfTP4B5kjAGm/CFIoUvDWDdOetaK54UOXYIYP51DD67IrfQWsanl1RpaLsBN4ygFGYfCD9+30r7ldsrte+Yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Tue, 25 Oct
 2022 14:00:35 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:00:35 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 05/23] nvme-tcp: Add DDP offload control path
Date:   Tue, 25 Oct 2022 16:59:40 +0300
Message-Id: <20221025135958.6242-6-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::13) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ee698f7-62e5-46dc-9430-08dab6914a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/nmzGDO4/ZiaMEWCIxHDJjuMgxii9FgNzQQdb9XQUHekSS0p5R1LVC4HJEK6KUyGluQe2AZoTp76BnhWsMAnv5VTyaHVIF0JfrPwVD8ToEwfao217qToVby2jKlNWVkrH6xTqK2EXlsj9TT/2Wlp1noIO2GpZYrrX42FrKqAye8HxdKqARH9PqVHGUJBVaCb/nzJK8y9+YRL2t1+m8qmrHNUYPG809sDVth/rfsgM/oI/uBs+mUIBer2fUAv56c6Yh90teb/E3UzJ6uy/yaPITEVnBA4zo4DN+5iFaCJBgxZRI6pFGeMMkdYLMz9fv4dY1v/5G30fuMj2toqY0M8Lp8BqjwGpu1P7qZDW3KmgKXaEc1tMDHI4DEwKX2i1jBiQJafdNjNm1Gav5lEoHkgkBVXg6gmveZsBldX21UyDH8g9pxUfDBGEBPbI7Z0W+wSoeksrvgjhZQ8DJFSV++AZWiDWd4u1EIdjV34laLUIXiUjVDvN8IyeFlP2WaG9RsxXH4jlUMvfzVLZ98ECsyhHAPw7TyqVE9iHFz0RZ65LcGsfKtIcbY+fgZpm89RXaN658J77VUKpjGNWpRG4NWV+vnopXrPc0dm0wctESEpjPts70HjHct1FgzCMoouq2pCcYdsX0q69a6o577idKnhFbonrGeEdMPHGpt0HBw3zOJ1zHVgn4AkH2k1N97+nyyfWkmFHvJU6rAETGPjX3QnqXOQLY66lyJnXoVgUpcELi6vYb5HbQzQ8SmMx+VYmKK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199015)(921005)(83380400001)(1076003)(186003)(2616005)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(478600001)(7416002)(30864003)(26005)(6506007)(6666004)(6486002)(4326008)(8676002)(66556008)(66476007)(316002)(6636002)(66946007)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k6KkqPvFGzuzR8X5Y1wpYzPxElMFenxdHN2YpJNB+rWeEIfc53bNVOCVmOW0?=
 =?us-ascii?Q?8+fg7KQLq0qqHrmK9nJ7gFWcHGvQavdO7JT2Xg8HovfAewVDMrGX3n3QASQq?=
 =?us-ascii?Q?HxFhJ5yXLDR4NHySev27q8F2wzxhy4iTPw3UfO6hq0ESoryXJL+X+UjHfefU?=
 =?us-ascii?Q?dJo98ndLDWypRXgH9AI0mCFpdA7Lq88v3fvwibE7Z9kRtZvfLJotW9grUgYM?=
 =?us-ascii?Q?pMhrjNmQdD7BSkVM3Rv0NTdnYmEYmx23x/S+WSn1LE6f0LaCow12+9gD9jAh?=
 =?us-ascii?Q?qfx/lyL8PsI/t1r1rcm3XgqQqvjgCX/KS9adTs0ojHyvHmuwaQZ3T4OFg5+B?=
 =?us-ascii?Q?0Gh+u6LEtM4jMAbhynaI5lskuzp2J6K26ybiZFU6BGS1rJpomHnQlm5S85c6?=
 =?us-ascii?Q?j4fVR3u3eVSdd/poc41hsdVTvgisk+ArK5H19eVIlBEAhZ5h+LrZrnxvYjah?=
 =?us-ascii?Q?85zNE6NEbdK1kDqvok7mWzYt4ht/SVT+UzhTKzAzy4WYxkWLvLHu2Ne2CWog?=
 =?us-ascii?Q?oT5vWSI2OrnWGdpnTqDMzXpNYS3YAXe4fXBtrDNnq8yo7rcyH0VKvBlLmgA+?=
 =?us-ascii?Q?qaedkKE7ss++2h4hWNU7SFe2/PYCbbWnArVbPUgMmfGgidtrduGV8Hb1uub4?=
 =?us-ascii?Q?0tYLUHJmSOjfkkR0jPCbk4z4ERA3jV8mfpSnD9wj1PJKFbtNT9L0ZmFT4hUE?=
 =?us-ascii?Q?UVWVdTFqfHWCYliCF/MO2j7Bu9Hvjj5RC6WbJ4srRF3zyTmVcQ/hcLyBxPo6?=
 =?us-ascii?Q?OTJnxqjRV8eJvQ9cSeH8cX8EKGGmT6+61sbUEDipWyesDc3SYJUIPsY4ZZ4s?=
 =?us-ascii?Q?MNQ9HJ5n8x1Z7yvQ4vhXzDlNU4+lCZOI/MJSOwPbN2/KnlIjwCMNus4C0NIt?=
 =?us-ascii?Q?Pc4uXe2NXCYaQsE2s6jMmadzXouMVx6wh5tc4DYgKC8c69SEp4bscH7/+xdb?=
 =?us-ascii?Q?QsHu1SKTdJmZgHzCa481TxEIlM0J0foJVJmqfPWTruYZf9V2AecX8swVa9JY?=
 =?us-ascii?Q?7QX09jNaR/8mcFAyi4yrNCtPehFZgkUC/be51cAANF+RYf5ekMiMdWw4XsP2?=
 =?us-ascii?Q?JQoaKKl3ZbzPBzwvgYPEa4/5eSIKweNwsdnHjw7PheJhVvdUetG2dkSIeLaf?=
 =?us-ascii?Q?zm6GXx0U2LnaSrUH2iEpqP2atm74U1+WkNZi/NAZDzJNYDjnLUcFp8oam7fB?=
 =?us-ascii?Q?76WJ9oiwRFRLSEd/HfM8/BfoavqEc2NPzW9Sae2nljqB9P5RdcNxtwybcNw9?=
 =?us-ascii?Q?Hw89fc9xK4LKjSHruHMFRR1D9iYkDpt+mASCC8L/oeQLP7QGvKW8uvDeWVh2?=
 =?us-ascii?Q?wHDMPNJ7axjcWAKJI2l8l8obVzMnZjOzXmnCcQ4uq+xN68hAqEXzYWNuwyPu?=
 =?us-ascii?Q?5edmRdj1mlU5+Z7JSduDW8PdrnE5K0tjkVUSksIcjQR0OGCdAwByJ/wh0Piz?=
 =?us-ascii?Q?9Hz7Riseu2oqskQtaJERwIlX3wRPtRF9gEpKldrRiOI6ThTBPsz4otg4dV9J?=
 =?us-ascii?Q?gHlXf2gXML+y0u3o19Ce1bp9NjISTw1bDEq45MZ5/05YFgaryUvoEjmK8VTq?=
 =?us-ascii?Q?n4DcBHjAmjv1HldO1/balq/JEQf/mUed5MshLrWn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee698f7-62e5-46dc-9430-08dab6914a13
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:00:35.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9ZdQRIgS7mz4fXsVS42J9uMfxXTol6Q7BOcQ1O2b1YFbhphnqlK7nrWEAEKnaQfKkz+HSy50u+5rlQfhXBgVQ==
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
 drivers/nvme/host/tcp.c | 251 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 242 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 42b2d86dcfc2..0f065f18dac6 100644
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
@@ -130,6 +135,15 @@ struct nvme_tcp_queue {
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
 
+	/*
+	 * HW can request a tcp seq num to continue
+	 * offload in case of resync.
+	 * - The 32 high bits store the seq number
+	 * - The 32 low bits are used as a flag to know if a request
+	 *   is pending (ULP_DDP_RESYNC_PENDING).
+	 */
+	atomic64_t		resync_req;
+
 	/* send state */
 	struct nvme_tcp_request *request;
 
@@ -170,6 +184,9 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	struct net_device	*offloading_netdev;
+	u32			offload_io_threshold;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -261,6 +278,190 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+#ifdef CONFIG_ULP_DDP
+
+static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
+				      struct nvme_tcp_ddp_limits *limits)
+{
+	int ret;
+
+	if (!netdev || !(netdev->features & NETIF_F_HW_ULP_DDP) ||
+	    !netdev->ulp_ddp_ops || !netdev->ulp_ddp_ops->ulp_ddp_limits)
+		return false;
+
+	limits->lmt.type = ULP_DDP_NVME;
+	ret = netdev->ulp_ddp_ops->ulp_ddp_limits(netdev, &limits->lmt);
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
+	struct nvme_tcp_ddp_config config = {};
+	struct nvme_tcp_ddp_limits limits = {{ULP_DDP_NVME}};
+	int ret;
+
+	/* device has ULP DPP, check NVMe-TCP offload support */
+
+	if (!nvme_tcp_ddp_query_limits(netdev, &limits))
+		return 0;
+
+	if (!(limits.lmt.offload_capabilities & ULP_DDP_C_NVME_TCP))
+		return 0;
+
+	config.cfg.type		= ULP_DDP_NVME;
+	config.pfv		= NVME_TCP_PFV_1_0;
+	config.cpda		= 0;
+	config.dgst		= queue->hdr_digest ?
+		NVME_TCP_HDR_DIGEST_ENABLE : 0;
+	config.dgst		|= queue->data_digest ?
+		NVME_TCP_DATA_DIGEST_ENABLE : 0;
+	config.queue_size	= queue->queue_size;
+	config.queue_id		= nvme_tcp_queue_id(queue);
+	config.io_cpu		= queue->io_cpu;
+
+	/* Socket ops keep a netdev reference. It is put in
+	 * nvme_tcp_unoffload_socket().  This ref is dropped on
+	 * NETDEV_GOING_DOWN events to allow the device to go down
+	 */
+	dev_hold(netdev);
+	ret = netdev->ulp_ddp_ops->ulp_ddp_sk_add(netdev,
+						  queue->sock->sk,
+						  &config.cfg);
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
+	netdev->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
+	dev_put(netdev); /* held by offload_socket */
+}
+
+static void nvme_tcp_offload_limits(struct nvme_tcp_queue *queue, struct net_device *netdev)
+{
+	struct nvme_tcp_ddp_limits limits = {{ULP_DDP_NVME}};
+
+	if (!nvme_tcp_ddp_query_limits(netdev, &limits)) {
+		queue->ctrl->offloading_netdev = NULL;
+		return;
+	}
+
+	queue->ctrl->offloading_netdev = netdev;
+	dev_dbg_ratelimited(queue->ctrl->ctrl.device,
+			    "netdev %s offload limits: max_ddp_sgl_len %d\n",
+			    netdev->name, limits.lmt.max_ddp_sgl_len);
+	queue->ctrl->ctrl.max_segments = limits.lmt.max_ddp_sgl_len;
+	queue->ctrl->ctrl.max_hw_sectors =
+		limits.lmt.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
+	queue->ctrl->offload_io_threshold = limits.lmt.io_threshold;
+
+	/* offloading HW doesn't support full ccid range, apply the quirk */
+	queue->ctrl->ctrl.quirks |= limits.full_ccid_range ? 0 : NVME_QUIRK_SKIP_CID_GEN;
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
+		netdev->ulp_ddp_ops->ulp_ddp_resync(netdev, queue->sock->sk, pdu_seq);
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
@@ -703,6 +904,9 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_resync_response(queue, skb, *offset);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1650,6 +1854,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
@@ -1669,21 +1875,48 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
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
+		if (netdev && (netdev->features & NETIF_F_HW_ULP_DDP)) {
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
+		if (netdev->features & NETIF_F_HW_ULP_DDP)
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

