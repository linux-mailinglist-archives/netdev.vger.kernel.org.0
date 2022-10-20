Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24D7605C17
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiJTKUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiJTKTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:19:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBF01DC80C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:19:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gcn81ygH8XVj+fL9eP35RwJ2PuJd/LyNvuLBUcj42QQePeSGRt1i2nuvnQEW65undZSWZiXBwEJu+hgyAf4IUZdSIH4p0pQ612Fk3/gNLSJim/ib/VhkqMmeYFfKTjgpbL8P7YS6AoIMEsY2XlBDWh8MWqJc+JsZeC7pBOToV41+HlYfbUHMS0a0U37VXkAqh/xc+1i/H89SGES0jkiEN0NpajyA1GnlWMT2Gfv83J7F9OVxbK0/TkMUSOgbazpVcwQ5bJthkJUXvPpproBjl82Pe6EGdOH+tbJvQUYFjxgEQQemj8Sx7coK7JMzkJEwR7p+Yv8FuNXtK7mhEn5cDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RZnw4qyZr8FZzMe01K46WPkKlAL2FzJxrDi19QqhWg=;
 b=KYES5TOX7Q1ZHWlLncowk6L+jZIbuEP1n4r9RedFkYg4aozxJH24FtMFWZC4T1b4K3qYVUBAt7Nh6SAlObiRzpakqfSJNUfc+HUm2k+KhKlnKeh/xHJ9s8++mZR6sb+S/OEqkM9boJc4wdY8jHnDMhlHpiyDumX79qRf/ZcJZPEtMa1KYeB9Xu/gdKjK7+ePX9+gwBa3wqdl+7mlleizkJr94AVbVxctzC9D+MCkGvBNFof6O5o7VCPGu+vrQnF6kLXc16tQpW1Ty8xr/HvpQupf4SfXpadgCbja+cQjb2nHeAvUiyKsKTH+66l506B3PP9Pg70lhf8hN6/wjoUdxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RZnw4qyZr8FZzMe01K46WPkKlAL2FzJxrDi19QqhWg=;
 b=Kr0TZZmk9lR+AejIrBcVwri6GOwa9j56x+EMIsb2nWCauGA3NJ5DOl7mpvKXB+IHwT+Kubv90veO6Xx4DTMqoD65uwnAwtOB6T4kaEvgC8MDudncTq8tMzgzdJs/Dmrivp6Maz7emlWo4QOUDyOzU0/cvfrPD/VIBmGrZDz2PPvfS0+lgf0D0z1dMMX0B2UywOcS7Ptx2AAaqmq5jcipe1xnIqJAxTYjUjfdk85YKZXdFv+zxka8UvIPUGTV5Fiu9UV5w+QhbNKKtW5dwY2n+9X0VrMVOiMBi84LDoI4YwhXBks+VkoSgy83JXuHCKeV66OEUqcY8/DbQIfR60ElPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:19:15 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:19:14 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 05/23] nvme-tcp: Add DDP offload control path
Date:   Thu, 20 Oct 2022 13:18:20 +0300
Message-Id: <20221020101838.2712846-6-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0298.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::15) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: ca328890-905b-4f6a-ef99-08dab28489f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SN2Dy0Svp6Olz8ytgYG26Kr8+2aA23bzkCQHZx1o0YaQxR7figEWaHgAk2Bpoz8w02gYGkwD0cRL8ZGHORR/xy7KzIPtdDMr84LKeOs1xHtZtF5Wzo/5cEgbXfjKz9VRORcgsW65hZP7mm9m4BY1OW3lFjOfPxDJ/FbQQRKUlmWDvxK2O1Cpt/sBHXW6gfFnv3XNK2smbvmcd2ODpRUnwsGdoamC+4uBlxpuDvyHmyca3t30p+ezZlO1AtlOayhLG1YEj8RbKIE6HsuAh/535IA1CEOyWwezkXIjHsc0cbuDLyQu1rrWKH+8Kzi4/Hc7tzL3Ka5xkko20nyUyeIXrcW4a1dqYJy1D+4lEM01fVvkko6k0kgSzQu0dkaB3s14l8vK0KW5WxnJDYrjPqNYUt3I0tOXWUdwpvUkX9RJO9Kqx8ykZk70q5xg2de1hXbJfuTyOQdqRA+1mKm1KRVsLjkvlXzPK1vqQwlDKpSksM699R92/xytFjwmIXprGcZ4Te2yI0wyD5K16p1Mq1hl0jEI7WAoZsUMlZSluiC3LzR9PPJ5lwVZVcfWNMpOiBRN2M+hQiGNd+SbXZnEWBhBz5PmtJ6qBZot0qaQRLOyHAGEge29MkbEGJohY8MBpLBFNdO/47NC3L0I4h0VnkfrKdMQKQNuUH4izR7HrAeJti1uTepcECNTNjRIYDXF7Pj8XDqtQqUjPTKt5/CK/mE2IdE6AfC3wUDuF4OR/maFR2awziY4Mtq0dAEG1eArUjPN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(30864003)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A6w6uHrG57i1++tgru4JZLeSAEzckZyrgzMI7P2jHDq0exPidNm/z4HcSaQT?=
 =?us-ascii?Q?KxiflYNS/slsq5f96RzMrl3aQ5BipI9GY14Sz2hYzoA0qcc46aqHI9F1GYX4?=
 =?us-ascii?Q?H3wIoDocIw7tPt22eNYPQz0iYFOA3350xwnQea156UogPTDf035B0U74RfLm?=
 =?us-ascii?Q?1NlMnarx1H2izaEx0kX905I/2w0TYZjI3I0MsSrLxaFtWvzrzN0Xs1BWgQeT?=
 =?us-ascii?Q?4kLHYVUsASo5BnO6jHunTcueZDxoU6HtVYOCXbA8nTkA/gUsu2zcblg/c6nE?=
 =?us-ascii?Q?h7P4FRlcA2m3+sD3Zp+IlKsN1quai2XhiHMABbdjuoXS1REAWHDEXcUAZmYI?=
 =?us-ascii?Q?4sPjldRPvSFV5kI9tQMjY3ZYQgP+iss7sP06y/fQ5vhl3cnC0kyf6dvSrHbH?=
 =?us-ascii?Q?043YPgFLWKm4iBisQXcxjgsbQUNZOr3K5RGUHLn9wifscoThI07EZr1Yc4Ac?=
 =?us-ascii?Q?WQawrCHeKRWen01z4LXXY03OdnhvD1316eGtU9S9xXegpr3bVYf8w+bUX/Ts?=
 =?us-ascii?Q?k5F8gGHzekvMopBJDp6++8XtYKFEPoYOcLWgx12zvPmVTHkO9m6Q1wM0jqdy?=
 =?us-ascii?Q?exEdnCKqDv5rlF324ALQprQW+Kjr10wxpD9sK1iPkkn0m7sXczy+M4ZIdjzw?=
 =?us-ascii?Q?+IH/UuJzhc/7JJSngGd8ob19O2kctynalSv+ll78Jzu2oJO7WsjyKrIJyF5o?=
 =?us-ascii?Q?h7XCPXqesROaNCwTN0Sbtgp9Jxf+WFMXo1knzIhCy4azdpnk8v8niluc7+OY?=
 =?us-ascii?Q?QVpfGWmx3Dgwj4eNMQf+zAlIEHkG9HvQ96zylXSdjMfRp2410nXERMYiuu1d?=
 =?us-ascii?Q?CKO4zKUF7gEmrZfdcc2Jdpu8YyU2grbR56AclhXgRhyrG90SUrUdBjnSpZ8v?=
 =?us-ascii?Q?STU7LdM1SpaIbkijNsfjYH5Sftf9ZAwhNbWLskRcev/Pfx4gTAbESWEVSEX1?=
 =?us-ascii?Q?K9j3kZvRxwovr6AW/dwCbWohaS2pHrwsHHMwlwqTd6ekFB75bQF4oeMPlRHL?=
 =?us-ascii?Q?el+S2qjAF5NrkmLjbRROrCCxgEfS5UjCtg/x9PlGXpcy1sexUG6030mOQXe8?=
 =?us-ascii?Q?0HYbwd0g1u8K8riE7li+YW3FJmpg7QwecaenQt8W7HR5mwmVaOpH6gfMxJAG?=
 =?us-ascii?Q?r+loGu2PhU9nsuQGY3F505cwsTeAuICZOs6u/fHrkaOnATI60uXOhOtvaC+D?=
 =?us-ascii?Q?SVqC8xVts5s0FPz1xkcAj5VICg884BjxktKXl0KNkgD8Z7LXfELZpQ2oeGTI?=
 =?us-ascii?Q?RNioG+LNTU1aAbqiC6AjUDy8Qk4qR7f3uHTMCUCm0FP+SBNwIE1zzA1y7s3W?=
 =?us-ascii?Q?38bsQ2UojPsZIHQQ1HDf8v6E8psLr106q2IDzMyBKTUWfchfAtXeYI4fiziU?=
 =?us-ascii?Q?fYcvX2GAN4llxTj2j0LgGRkkOol0/NRqdi1XXg5OFe/qM7SobHBl/mV1gsBo?=
 =?us-ascii?Q?B9qO0g1inDCAqSBVw6bVDpHGecLfOppYfjcmuLnXAXWmmsB7AH0J7MSUem+H?=
 =?us-ascii?Q?HAJSxT7VgM9jghrI6jMTvYcdfGDGLikIXqRKSxdNKoBL1akhX33BOqnkP4Lz?=
 =?us-ascii?Q?ReLKPP5XORVUmVZbBeVOuE44ovRRhq9LgvHRoYvC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca328890-905b-4f6a-ef99-08dab28489f1
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:19:14.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKZj/VW1sj0989dYIEkIzurTJJbtUn/arc6CX2NE54ioF2tw95KgXucj8a3oaIwdWgcvyo8Za2yfcs6K3K+keQ==
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
 drivers/nvme/host/tcp.c | 261 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 252 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 10080cfd541b..be13db3aa4da 100644
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
@@ -261,6 +278,194 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+#ifdef CONFIG_ULP_DDP
+
+static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
+	struct nvme_tcp_ddp_limits *limits)
+{
+	int ret;
+
+	if (!netdev || !(netdev->features & NETIF_F_HW_ULP_DDP) ||
+	    !netdev->ulp_ddp_ops || !netdev->ulp_ddp_ops->ulp_ddp_limits)
+		return false;
+
+	limits->lmt.type = ULP_DDP_NVME;
+	ret = netdev->ulp_ddp_ops->ulp_ddp_limits(netdev, &limits->lmt);
+	if (ret == -EOPNOTSUPP)
+		return false;
+	else if (ret) {
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
+static int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue, struct net_device *netdev)
+{
+	struct nvme_tcp_ddp_limits limits = {{ULP_DDP_NVME}};
+
+	if (!nvme_tcp_ddp_query_limits(netdev, &limits)) {
+		queue->ctrl->offloading_netdev = NULL;
+		return -EOPNOTSUPP;
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
+
+	return 0;
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
+static int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue, struct net_device *netdev)
+{
+	return 0;
+}
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
@@ -703,6 +908,9 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_resync_response(queue, skb, *offset);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1650,6 +1858,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
@@ -1669,21 +1879,54 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
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
+		if (netdev->features & NETIF_F_HW_ULP_DDP) {
+			ret = nvme_tcp_offload_limits(&ctrl->queues[idx], netdev);
+			if (ret) {
+				dev_err(nctrl->device,
+					"failed to apply offload limits on queue %d ret=%d\n",
+					idx, ret);
+			}
+		}
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

