Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694853D227D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhGVKZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:37 -0400
Received: from mail-dm3nam07on2063.outbound.protection.outlook.com ([40.107.95.63]:35765
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231814AbhGVKZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAMFwu1yFTTIpEL+mYZ1vU1PWUaq/m0TLPVlF+e7jCtCQS7a7gnhayE0/SKaWQJD1Nc7ZLjVvCpmKNx+yTQcPdJWC86/lOSLcBtb7M/tQVtFHfrCXudUbk2Pp/gm8SLBuPwvZt7+eQlpcwyd33NM2nxqlVCMRFBcRlUZYkRkuSyywtxWygaMvTEY7jvtl0Kiq1iV5mibWaviSq1SITmZxqB9B2mML+i/bhyICbiJN5lOeXeqrZzJgsWI0D1Bx9blADJyljCZHvIuCBQ86CVBQJvWlS9kXPwi3UrLe9CM9o13XqXUGDNNVauO4KA9Mvr10e6/ssRWw1eZ6Sx9AS1Tcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQZoz24VPjVt90atOql9PJgkSywiPU2ZImRaihLLhoU=;
 b=j0sUNwUNkSWHJ7fe6w+V+n2Wzn8eVSO9PLjK5eipSreM5qOkY0ucMeay1tHcfxVVlXN7G4ibZznzVtH6drZgcl27If9KKNSEU5EWYy3bzoHDlFTaU+SNMErYQWrbA9LS7wHnh0lImC3PNtRLDZhJlPj03iJM1wg/1bZOAZfHtcQ4kqo0ccqbj0diElBd9s2Rhez6oNfphwWaW1wTm2AoOlHBfuNv45nSRFIVRAdTBwVXC5a9mevukErEPTCKCrpjvikoQi/Y5NeoIjvkLrlz2mcnXFbFSucyA37MXH6SAvbsbwfKKe+YBl0QjkUebZ8xsXpT/f++LVnCtS/QNrMRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQZoz24VPjVt90atOql9PJgkSywiPU2ZImRaihLLhoU=;
 b=KpHqcfy33XUp8pnLJfVkpFlk+ASn6TqaoYHAvgeyN4PDM9WYPdAUXxmhHGwan6Lo1/zp1Prd+FFfTZlmmGnVrAovhgDLIKdBc0HP/KWNZBo57T8frK80C+/Cgaq/RxkBHDIphmBETF1GqM7PEH/ichgzikVpJkFXyf8lHSKHGHiOtdwAN9WX1uI/wXTkdOG5ad2vHqYrntV/B3vBsPZOGLVTp45A/gHBAj7H/j8m/nVEfgLB8tGnjxgs7eDJrfThjYcn5komqp/w2tByp6CMaulFV3wwXCXnroXCf0p13nYVB/62xPhoxWQd4VuXZnczY4uiIs72OVNbWE/UXuIy1A==
Received: from MWHPR07CA0012.namprd07.prod.outlook.com (2603:10b6:300:116::22)
 by BN8PR12MB3124.namprd12.prod.outlook.com (2603:10b6:408:41::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Thu, 22 Jul
 2021 11:06:00 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::dd) by MWHPR07CA0012.outlook.office365.com
 (2603:10b6:300:116::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:00 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:59 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:55 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 22/36] net: Add ulp_ddp_pdu_info struct
Date:   Thu, 22 Jul 2021 14:03:11 +0300
Message-ID: <20210722110325.371-23-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 784d4371-7476-401f-08c6-08d94d00b068
X-MS-TrafficTypeDiagnostic: BN8PR12MB3124:
X-Microsoft-Antispam-PRVS: <BN8PR12MB31247FAC5D6A8EFB7433F689BDE49@BN8PR12MB3124.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ewm/QXjiuEFXAYG/JDLW5HcPuxkhZzkFpRMjsuHICpEoQdVHnXOWusn0uyShHhG1naPGfB0804sFeI/V6srLgteUJTnBAIBOYFLFuXJjDM51Li4h1zUCL+6gw5/Hb2iNstDVXEkvOcolB9ogGwKzukslCnKuD9QGrmuboWOdcRSRjSZEKSLUPRzO09fsx+Y+94RFCEn+Jcf1A4nL5VO5a/amY5DPzCJfvzr4EfavunE1yOZkaS7dN4CQX6eISvnD8gQEMw7D3o77L9oMTKvuvMHt10sFMXnZrzyjLgRPvK0BsNT99Ohcn2d88qESYGCX4HrhUjmmwKB5069lIZp/uETxasjfs6XeQSbm7nyo1V85EA+CX4gaFMzJIWNiGj2gOL5WUnur5TxgmKkGgW76Gh2JTvhO1bSzZuZpSVF7CU08wEo68t02QC7UXHJ08Ku7ZbL2gKhvfS5ytp7cz5YJMv2gYy1eKSLVLrHqFYWSKbYeTWBXLVwY3HqYXPaNsKd6NvyFbXnJ+KUsSeYshx8gMLdXMjvtpYdWOJeD3Nl7pi7Y3ebc0Xp8qkHoLIm2rvFq/ugZKzY1IGeRFCA1UbOHOcsEEMq5PHw/klu2l47SbdpwD2/gjIjSWPgSMa4B+f2k2NikSNgP3mWvXWSpDmqvBI7jEiT5hGqr9G+pJEySvBef/bpKs4ZSUyfGHj4AxlyT5+oddtGs9aI0D97vVLmq37r6IlMc0uwypRIiRJdVm+I=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(356005)(107886003)(5660300002)(921005)(82310400003)(186003)(83380400001)(70206006)(36756003)(7416002)(7636003)(70586007)(4326008)(36906005)(8676002)(316002)(2906002)(54906003)(82740400003)(336012)(8936002)(7696005)(110136005)(2616005)(426003)(6666004)(36860700001)(86362001)(1076003)(26005)(478600001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:00.3173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 784d4371-7476-401f-08c6-08d94d00b068
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

This struct is mapping between pdu's pages to TCP sequence number.

The use case for this mapping is in tx offload,
when the NIC needs to send a retransmitted packet.
The NIC, in this case, might need the complete pdu,
which is sent before (i.e for computing the CRC for this pdu).

Using this mapping, the SW can send the NIC enough context
to offload the packet.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 include/net/ulp_ddp.h |  55 +++++++++++++-
 net/core/Makefile     |   1 +
 net/core/ulp_ddp.c    | 166 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+), 3 deletions(-)
 create mode 100644 net/core/ulp_ddp.c

diff --git a/include/net/ulp_ddp.h b/include/net/ulp_ddp.h
index 1a0b464ff40b..8f48fc121c3a 100644
--- a/include/net/ulp_ddp.h
+++ b/include/net/ulp_ddp.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-3.0
  *
  * ulp_ddp.h
  *	Author:	Boris Pismenny <borisp@mellanox.com>
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <net/inet_connection_sock.h>
 #include <net/sock.h>
+#include <net/tcp.h>
 
 /* limits returned by the offload driver, zero means don't care */
 struct ulp_ddp_limits {
@@ -67,6 +68,26 @@ struct ulp_ddp_io {
 	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
 };
 
+/**
+ * struct ulp_ddp_pdu_info - pdu info for tcp ddp crc Tx offload.
+ *
+ * @end_seq:	tcp seq of the last byte in the pdu.
+ * @start_seq:	tcp seq of the first byte in the pdu.
+ * @data_len:	pdu data size (in bytes).
+ * @hdr_len:	the size (in bytes) of the pdu header.
+ * @hdr:	pdu header.
+ * @req:	the ulp request for the original pdu.
+ */
+struct ulp_ddp_pdu_info {
+	struct list_head list;
+	u32		end_seq;
+	u32		start_seq;
+	u32		data_len;
+	u32		hdr_len;
+	void		*hdr;
+	struct request	*req;
+};
+
 /* struct ulp_ddp_dev_ops - operations used by an upper layer protocol to configure ddp offload
  *
  * @ulp_ddp_limits:    limit the number of scatter gather entries per IO.
@@ -113,10 +134,25 @@ struct ulp_ddp_ulp_ops {
 /**
  * struct ulp_ddp_ctx - Generic ulp ddp context: device driver per queue contexts must
  * use this as the first member.
+ *
+ * @netdev:		the coresponding netdev for this tcp ddp.
+ * @ddgst_len:		data digest len in bytes.
+ * @expected_seq:	indicates for next tcp seq.
+ * @open_info:		the current pdu_info.
+ * @pdu_hint:		hint for ulp_ddp_get_pdu_info.
+ * @info_list:		list of the mapped pdu_infos.
+ * @info_lock:		lock for info_list.
  */
 struct ulp_ddp_ctx {
-	enum ulp_ddp_type    type;
-	unsigned char        buf[];
+	enum ulp_ddp_type	type;
+	struct net_device	*netdev;
+	int			ddgst_len;
+	u32			expected_seq;
+	struct ulp_ddp_pdu_info *open_info;
+	struct ulp_ddp_pdu_info *pdu_hint;
+	struct list_head        info_list;
+	spinlock_t              info_lock;
+	unsigned char           buf[];
 };
 
 static inline struct ulp_ddp_ctx *ulp_ddp_get_ctx(const struct sock *sk)
@@ -133,4 +169,17 @@ static inline void ulp_ddp_set_ctx(struct sock *sk, void *ctx)
 	rcu_assign_pointer(icsk->icsk_ulp_ddp_data, ctx);
 }
 
+static inline void ulp_ddp_destroy_info(struct ulp_ddp_pdu_info *info)
+{
+	kfree(info);
+}
+
+void ulp_ddp_ack_handle(struct sock *sk, u32 acked_seq);
+int ulp_ddp_init_tx_offload(struct sock *sk);
+void ulp_ddp_release_tx_offload(struct sock *sk);
+int ulp_ddp_map_pdu_info(struct sock *sk, u32 start_seq, void *hdr,
+			 u32 hdr_len, u32 data_len, struct request *req);
+void ulp_ddp_close_pdu_info(struct sock *sk);
+bool ulp_ddp_need_map(struct sock *sk);
+struct ulp_ddp_pdu_info *ulp_ddp_get_pdu_info(struct sock *sk, u32 seq);
 #endif //_ULP_DDP_H
diff --git a/net/core/Makefile b/net/core/Makefile
index f7f16650fe9e..b7c1618944df 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -14,6 +14,7 @@ obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			fib_notifier.o xdp.o flow_offload.o
 
 obj-y += net-sysfs.o
+obj-$(CONFIG_ULP_DDP) += ulp_ddp.o
 obj-$(CONFIG_PAGE_POOL) += page_pool.o
 obj-$(CONFIG_PROC_FS) += net-procfs.o
 obj-$(CONFIG_NET_PKTGEN) += pktgen.o
diff --git a/net/core/ulp_ddp.c b/net/core/ulp_ddp.c
new file mode 100644
index 000000000000..06ed4ad59e88
--- /dev/null
+++ b/net/core/ulp_ddp.c
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: GPL-3.0
+ *
+ * ulp_ddp.c
+ *      Author: Yoray Zack <yorayz@mellanox.com>
+ *      Copyright (C) 2020 Mellanox Technologies.
+ */
+#include <net/ulp_ddp.h>
+
+void ulp_ddp_ack_handle(struct sock *sk, u32 acked_seq)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+	struct ulp_ddp_pdu_info  *info, *temp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->info_lock, flags);
+	info = ctx->pdu_hint;
+	if (info && !before(acked_seq, info->end_seq))
+		ctx->pdu_hint = NULL;
+
+	list_for_each_entry_safe(info, temp, &ctx->info_list, list) {
+		if (before(acked_seq, info->end_seq - 1))
+			break;
+
+		list_del(&info->list);
+		ulp_ddp_destroy_info(info);
+	}
+
+	spin_unlock_irqrestore(&ctx->info_lock, flags);
+}
+
+static void ulp_ddp_delete_all_info(struct sock *sk)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+	struct ulp_ddp_pdu_info *info, *temp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->info_lock, flags);
+	list_for_each_entry_safe(info, temp, &ctx->info_list, list) {
+		list_del(&info->list);
+		ulp_ddp_destroy_info(info);
+	}
+
+	spin_unlock_irqrestore(&ctx->info_lock, flags);
+	ctx->pdu_hint = NULL;
+}
+
+int ulp_ddp_init_tx_offload(struct sock *sk)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+	struct ulp_ddp_pdu_info *start_marker_info;
+	unsigned long flags;
+
+	start_marker_info = kzalloc(sizeof(*start_marker_info), GFP_KERNEL);
+	if (!start_marker_info)
+		return -ENOMEM;
+
+	start_marker_info->end_seq = tcp_sk(sk)->write_seq;
+	start_marker_info->start_seq = tcp_sk(sk)->write_seq;
+	spin_lock_init(&ctx->info_lock);
+	INIT_LIST_HEAD(&ctx->info_list);
+	spin_lock_irqsave(&ctx->info_lock, flags);
+	list_add_tail(&start_marker_info->list, &ctx->info_list);
+	spin_unlock_irqrestore(&ctx->info_lock, flags);
+	ctx->pdu_hint = NULL;
+	ctx->open_info = NULL;
+	clean_acked_data_enable(inet_csk(sk),
+				&ulp_ddp_ack_handle);
+	return 0;
+} EXPORT_SYMBOL(ulp_ddp_init_tx_offload);
+
+void ulp_ddp_release_tx_offload(struct sock *sk)
+{
+	clean_acked_data_disable(inet_csk(sk));
+	ulp_ddp_delete_all_info(sk);
+} EXPORT_SYMBOL(ulp_ddp_release_tx_offload);
+
+int ulp_ddp_map_pdu_info(struct sock *sk, u32 start_seq, void *hdr,
+			 u32 hdr_len, u32 data_len, struct request *req)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+	struct ulp_ddp_pdu_info *pdu_info;
+	u32 ddgst_len;
+
+	pdu_info = kmalloc(sizeof(*pdu_info), GFP_KERNEL);
+	if (!pdu_info)
+		return -ENOMEM;
+
+	ddgst_len = data_len ? ctx->ddgst_len : 0;
+
+	pdu_info->end_seq = start_seq + hdr_len + data_len + ddgst_len;
+	pdu_info->start_seq = start_seq;
+	pdu_info->data_len = data_len;
+	pdu_info->hdr_len = hdr_len;
+	pdu_info->hdr = hdr;
+	pdu_info->req = req;
+	pdu_info->ddgst = 0;
+
+	ctx->open_info = pdu_info;
+	return 0;
+} EXPORT_SYMBOL(ulp_ddp_map_pdu_info);
+
+void ulp_ddp_close_pdu_info(struct sock *sk)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+	struct ulp_ddp_pdu_info *pdu_info = ctx->open_info;
+	unsigned long flags;
+
+	if (!pdu_info)
+		return;
+
+	pdu_info->end_seq = tcp_sk(sk)->write_seq;
+
+	spin_lock_irqsave(&ctx->info_lock, flags);
+	list_add_tail_rcu(&pdu_info->list, &ctx->info_list);
+	spin_unlock_irqrestore(&ctx->info_lock, flags);
+
+	ctx->open_info = NULL;
+} EXPORT_SYMBOL(ulp_ddp_close_pdu_info);
+
+bool ulp_ddp_need_map(struct sock *sk)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+
+	return !ctx->open_info;
+} EXPORT_SYMBOL(ulp_ddp_need_map);
+
+struct ulp_ddp_pdu_info *ulp_ddp_get_pdu_info(struct sock *sk, u32 seq)
+{
+	struct ulp_ddp_ctx *ctx = ulp_ddp_get_ctx(sk);
+	struct ulp_ddp_pdu_info *info;
+	u32 open_start = 0;
+
+	if (!ctx)
+		return NULL;
+
+	if (ctx->open_info) {
+		open_start = ctx->open_info->start_seq;
+		if (before(open_start, seq) || seq == open_start)
+			return ctx->open_info;
+	}
+
+	info = ctx->pdu_hint;
+	if (!info || before(seq, info->start_seq))
+		info = list_first_entry_or_null(&ctx->info_list,
+						struct ulp_ddp_pdu_info, list);
+
+	if (!info)
+		return NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_from_rcu(info, &ctx->info_list, list) {
+		if (!info)
+			goto out;
+
+		if (between(seq, info->start_seq, info->end_seq - 1)) {
+			ctx->pdu_hint = info;
+			goto out;
+		}
+	}
+
+	info = NULL;
+out:
+	rcu_read_unlock();
+	return info;
+} EXPORT_SYMBOL(ulp_ddp_get_pdu_info);
+
-- 
2.24.1

