Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B73D2267
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhGVKYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:00 -0400
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:34017
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231585AbhGVKXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:23:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHbeA19Wjzifw05B7ElJ6WYIiHhtVBa/6YaCTUQb1fMUn90gFirb64mnrO7GPsaaho7wp7z+SPLZE1wkZwZ7uX6+LIRpeFFrUYQSIWd6m3Q2kFfFx4oR75D6Mv1LsPcR7nxtN5tmsyB3mKYZdsQ9L6IUCFI0dh3xNW2INEmImw2/R+0I0U3LFgFVLV/U7n15Pw9+UoEwSCyTQaTK2SWu38PB6+5Q7vXFYIjVQlS2obfqFW+4KxOgr8j6hkfZewA61kc7x6ur7OliVaNaLzGmhOAFjeBLHQZxmS1Hjhw5WJsr570qyOejXN1MNWFGPvrQKFcxqp3rZgbwg2iuJWxQww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqTAAYwXQwigIi/k4FYFVIXpI4MtI+tQdOwA2kOIUx0=;
 b=BXwx902eofvQn4vkxVPGysoeO+19fcE1d3NIQ2gOqawGYxiyXlO7v+woijJeZQpA3RoUyrY9dgozEHN3oaogmss7tK3VMS10UsOcl0UXiGKjN9qzoiUd+55rgV6HN76KprRiiPLf9HqYrCk0xxuh+sdbAy4zdbjwyLrIUbNBsO15loj3RaaDv6W9VAuysYXBd5Ja5jLJmCrNtKR8LQHF1szhhf2D/UUjugK3x4gg5H0V1fHTttfwfLS6y/wIkrkPEqqrsVu43f7u44AjjUhjR99SKg6ZTAgK06tAoxS4HglsFy36eBa/khcdmJ3ubDkydLOn62AnvkayuwfYnpnzzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqTAAYwXQwigIi/k4FYFVIXpI4MtI+tQdOwA2kOIUx0=;
 b=IHmU1xGfnPRi6b+3hHysRs+8TJfozsGBPHQGbhCptWIbiXFAWd0s64rWMg8FnU/QC29uxiR9rjd2GvNZnErztbj3lpR6UGzJCrfUUFldz4MfhKpiYyqqhuYjshoJhDx+381RHU4roIsN247lyI96ACNvXdkDFh2OSYq1Co0DSWStulysRX8IbCesUeL70RGbtevTfB1/y2EFz1SFu2gG96DGcMrSEGMc9CFwTb40SL8wUE5X2jFgk99RcXGLbcUAuCrSFG5fkXBz8PCyLhtThFITPuGSzYee0XhuCpDEGXX63bejfbGFI9HcMW9tC7UY6ksYAbYc4nVNH+MwAZVWGQ==
Received: from DM6PR13CA0015.namprd13.prod.outlook.com (2603:10b6:5:bc::28) by
 CO6PR12MB5395.namprd12.prod.outlook.com (2603:10b6:303:13a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 11:04:20 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::2f) by DM6PR13CA0015.outlook.office365.com
 (2603:10b6:5:bc::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:20 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:18 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:13 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 01/36] net: Introduce direct data placement tcp offload
Date:   Thu, 22 Jul 2021 14:02:50 +0300
Message-ID: <20210722110325.371-2-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6243351e-d30c-4fa4-7e45-08d94d00749e
X-MS-TrafficTypeDiagnostic: CO6PR12MB5395:
X-Microsoft-Antispam-PRVS: <CO6PR12MB53956FF3DAC23D6AA3C43CD2BDE49@CO6PR12MB5395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mvlE8K6Hzw6T0wfrBhMJ/wkwSMfkoD7sjYKI6qCe4VbpKq15Y/zwOvA7D31ZDMtDBMSIgc96ptmivVgqgjo1+7VHtu6chCKKbcbc0X8ODwU32imXr3tvr7t6WIF0fhs+zQ4LsL0jDw7q6da/oG4QLD6nTJR3nl4OOIH9gR1udC8TWvwwTy+exYssxmmeU1L/AfG9QQM60Hs/O6ZFSJPLsbB1z8A3LIjGOp3Byx+LdA/I5On/HdC6wWBkrkzwqYdFTOtTUVuTelH1FD+z8rAx5IthfXXnf66jfkdqpjlMJGAaxdVtfTXquRhXSrFi/1sHGFykjLiU6t4q16vcxIHR8bgA0TFb2s7hGFLciK6X58zyypDuNzUpXFLjCF2Jp+KvRcKMqV2IHMTNc8AbmN572M6LGT+Dj8R9D6mZWSqLjh9RidZIpCczgg92XKfcvsG7FDGtK1q/CeiP6cOS5555QwYVV4Wt9zj71N1gcF+AA+Y31vEvbMzKrID4MfELCzmAJqh4m+g/4WBtvdfQINf8mcJ8dC+SLM06Tj6lJpcuC/Cszn5VKjM/SrgghNBm9CxqlUSrbSAKSdcym80DnyPMF3dZ5UcMbIlqXnnpKqSIYYx33CgaEq8TUl+zQ9yAJ2nMr82wINOpySEyoCRsEoaXUcg9GWdrzeLHNuvgXx26dQR6rPedyvvIApYeow7IfQfMKohp/+yiltmA0RxWFr3SbK4cwHjjKpImpIDvisIVhtw=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(7696005)(70586007)(6666004)(2616005)(8936002)(478600001)(82310400003)(7416002)(107886003)(7636003)(8676002)(316002)(47076005)(1076003)(186003)(356005)(70206006)(26005)(36906005)(2906002)(336012)(5660300002)(36860700001)(54906003)(426003)(82740400003)(30864003)(4326008)(921005)(83380400001)(110136005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:20.0459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6243351e-d30c-4fa4-7e45-08d94d00749e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5395
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

This commit introduces direct data placement offload for TCP.
This capability is accompanied by new net_device operations that
configure hardware contexts. There is a context per socket, and a context per DDP
opreation. Additionally, a resynchronization routine is used to assist
hardware handle TCP OOO, and continue the offload.
Furthermore, we let the offloading driver advertise what is the max hw
sectors/segments.

Using this interface, the NIC hardware will scatter TCP payload directly
to the BIO pages according to the command_id.
To maintain the correctness of the network stack, the driver is expected
to construct SKBs that point to the BIO pages.

The SKB passed to the network stack from the driver
represents data as it is on the wire, while it is pointing
directly to data in destination buffers.
As a result, data from page frags should not be copied out to
the linear part. To avoid needless copies, such as when using
skb_condense, we mark the skb->ddp_crc bit. This bit will be
used to indicate both ddp and crc offload (next patch in series).

A follow-up patch will use this interface for DDP in NVMe-TCP.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/netdev_features.h    |   3 +-
 include/linux/netdevice.h          |   5 ++
 include/linux/skbuff.h             |   4 +
 include/net/inet_connection_sock.h |   4 +
 include/net/ulp_ddp.h              | 136 +++++++++++++++++++++++++++++
 net/Kconfig                        |  10 +++
 net/core/skbuff.c                  |   8 +-
 net/ethtool/common.c               |   1 +
 net/ipv4/tcp_input.c               |   8 ++
 net/ipv4/tcp_ipv4.c                |   3 +
 net/ipv4/tcp_offload.c             |   3 +
 11 files changed, 183 insertions(+), 2 deletions(-)
 create mode 100644 include/net/ulp_ddp.h

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e416225..d9bd6ea26fc8 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -14,7 +14,7 @@ typedef u64 netdev_features_t;
 enum {
 	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
 	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
-	__UNUSED_NETIF_F_1,
+	NETIF_F_HW_ULP_DDP_BIT,         /* ULP direct data placement offload */
 	NETIF_F_HW_CSUM_BIT,		/* Can checksum all the packets. */
 	NETIF_F_IPV6_CSUM_BIT,		/* Can checksum TCP/UDP over IPV6 */
 	NETIF_F_HIGHDMA_BIT,		/* Can DMA to high memory. */
@@ -168,6 +168,7 @@ enum {
 #define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
+#define NETIF_F_HW_ULP_DDP	__NETIF_F(HW_ULP_DDP)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..cba92c2dd9c0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1005,6 +1005,7 @@ struct dev_ifalias {
 
 struct devlink;
 struct tlsdev_ops;
+struct ulp_ddp_dev_ops;
 
 struct netdev_name_node {
 	struct hlist_node hlist;
@@ -2024,6 +2025,10 @@ struct net_device {
 	const struct tlsdev_ops *tlsdev_ops;
 #endif
 
+#if IS_ENABLED(CONFIG_ULP_DDP)
+	const struct ulp_ddp_dev_ops *ulp_ddp_ops;
+#endif
+
 	const struct header_ops *header_ops;
 
 	unsigned char		operstate;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b2db9cd9a73f..d323ecd37448 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -689,6 +689,7 @@ typedef unsigned char *sk_buff_data_t;
  *		CHECKSUM_UNNECESSARY (max 3)
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
+ *	@ddp_crc: DDP or CRC offloaded
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -870,6 +871,9 @@ struct sk_buff {
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
+#ifdef CONFIG_ULP_DDP
+	__u8                    ddp_crc:1;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index b06c2d02ec84..66801ea72fb4 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -66,6 +66,8 @@ struct inet_connection_sock_af_ops {
  * @icsk_ulp_ops	   Pluggable ULP control hook
  * @icsk_ulp_data	   ULP private data
  * @icsk_clean_acked	   Clean acked data hook
+ * @icsk_ulp_ddp_ops	   Pluggable ULP direct data placement control hook
+ * @icsk_ulp_ddp_data	   ULP direct data placement private data
  * @icsk_listen_portaddr_node	hash to the portaddr listener hashtable
  * @icsk_ca_state:	   Congestion control state
  * @icsk_retransmits:	   Number of unrecovered [RTO] timeouts
@@ -96,6 +98,8 @@ struct inet_connection_sock {
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
 	void __rcu		  *icsk_ulp_data;
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
+	const struct ulp_ddp_ulp_ops  *icsk_ulp_ddp_ops;
+	void __rcu		  *icsk_ulp_ddp_data;
 	struct hlist_node         icsk_listen_portaddr_node;
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
 	__u8			  icsk_ca_state:5,
diff --git a/include/net/ulp_ddp.h b/include/net/ulp_ddp.h
new file mode 100644
index 000000000000..1a0b464ff40b
--- /dev/null
+++ b/include/net/ulp_ddp.h
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * ulp_ddp.h
+ *	Author:	Boris Pismenny <borisp@mellanox.com>
+ *	Copyright (C) 2021 Mellanox Technologies.
+ */
+#ifndef _ULP_DDP_H
+#define _ULP_DDP_H
+
+#include <linux/netdevice.h>
+#include <net/inet_connection_sock.h>
+#include <net/sock.h>
+
+/* limits returned by the offload driver, zero means don't care */
+struct ulp_ddp_limits {
+	int	 max_ddp_sgl_len;
+};
+
+enum ulp_ddp_type {
+	ULP_DDP_NVME = 1,
+};
+
+/**
+ * struct ulp_ddp_config - Generic ulp ddp configuration: tcp ddp IO queue
+ * config implementations must use this as the first member.
+ * Add new instances of ulp_ddp_config below (nvme-tcp, etc.).
+ */
+struct ulp_ddp_config {
+	enum ulp_ddp_type    type;
+	unsigned char        buf[];
+};
+
+/**
+ * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
+ *
+ * @pfv:        pdu version (e.g., NVME_TCP_PFV_1_0)
+ * @cpda:       controller pdu data alignmend (dwords, 0's based)
+ * @dgst:       digest types enabled.
+ *              The netdev will offload crc if ddp_crc is supported.
+ * @queue_size: number of nvme-tcp IO queue elements
+ * @queue_id:   queue identifier
+ * @cpu_io:     cpu core running the IO thread for this queue
+ */
+struct nvme_tcp_ddp_config {
+	struct ulp_ddp_config   cfg;
+
+	u16			pfv;
+	u8			cpda;
+	u8			dgst;
+	int			queue_size;
+	int			queue_id;
+	int			io_cpu;
+};
+
+/**
+ * struct ulp_ddp_io - ulp ddp configuration for an IO request.
+ *
+ * @command_id:  identifier on the wire associated with these buffers
+ * @nents:       number of entries in the sg_table
+ * @sg_table:    describing the buffers for this IO request
+ * @first_sgl:   first SGL in sg_table
+ */
+struct ulp_ddp_io {
+	u32			command_id;
+	int			nents;
+	struct sg_table		sg_table;
+	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
+};
+
+/* struct ulp_ddp_dev_ops - operations used by an upper layer protocol to configure ddp offload
+ *
+ * @ulp_ddp_limits:    limit the number of scatter gather entries per IO.
+ *                     the device driver can use this to limit the resources allocated per queue.
+ * @ulp_ddp_sk_add:    add offload for the queue represennted by the socket+config pair.
+ *                     this function is used to configure either copy, crc or both offloads.
+ * @ulp_ddp_sk_del:    remove offload from the socket, and release any device related resources.
+ * @ulp_ddp_setup:     request copy offload for buffers associated with a command_id in ulp_ddp_io.
+ * @ulp_ddp_teardown:  release offload resources association between buffers and command_id in
+ *                     ulp_ddp_io.
+ * @ulp_ddp_resync:    respond to the driver's resync_request. Called only if resync is successful.
+ */
+struct ulp_ddp_dev_ops {
+	int (*ulp_ddp_limits)(struct net_device *netdev,
+			      struct ulp_ddp_limits *limits);
+	int (*ulp_ddp_sk_add)(struct net_device *netdev,
+			      struct sock *sk,
+			      struct ulp_ddp_config *config);
+	void (*ulp_ddp_sk_del)(struct net_device *netdev,
+			       struct sock *sk);
+	int (*ulp_ddp_setup)(struct net_device *netdev,
+			     struct sock *sk,
+			     struct ulp_ddp_io *io);
+	int (*ulp_ddp_teardown)(struct net_device *netdev,
+				struct sock *sk,
+				struct ulp_ddp_io *io,
+				void *ddp_ctx);
+	void (*ulp_ddp_resync)(struct net_device *netdev,
+			       struct sock *sk, u32 seq);
+};
+
+#define ULP_DDP_RESYNC_REQ BIT(0)
+
+/**
+ * struct ulp_ddp_ulp_ops - Interface to register uppper layer Direct Data Placement (DDP) TCP offload
+ */
+struct ulp_ddp_ulp_ops {
+	/* NIC requests ulp to indicate if @seq is the start of a message */
+	bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
+	/* NIC driver informs the ulp that ddp teardown is done - used for async completions*/
+	void (*ddp_teardown_done)(void *ddp_ctx);
+};
+
+/**
+ * struct ulp_ddp_ctx - Generic ulp ddp context: device driver per queue contexts must
+ * use this as the first member.
+ */
+struct ulp_ddp_ctx {
+	enum ulp_ddp_type    type;
+	unsigned char        buf[];
+};
+
+static inline struct ulp_ddp_ctx *ulp_ddp_get_ctx(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return (__force struct ulp_ddp_ctx *)icsk->icsk_ulp_ddp_data;
+}
+
+static inline void ulp_ddp_set_ctx(struct sock *sk, void *ctx)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	rcu_assign_pointer(icsk->icsk_ulp_ddp_data, ctx);
+}
+
+#endif //_ULP_DDP_H
diff --git a/net/Kconfig b/net/Kconfig
index c7392c449b25..b6f0ccbea1e3 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -454,4 +454,14 @@ config ETHTOOL_NETLINK
 	  netlink. It provides better extensibility and some new features,
 	  e.g. notification messages.
 
+config ULP_DDP
+	bool "ULP direct data placement offload"
+	default n
+	help
+	  Direct Data Placement (DDP) offload enables ULP, such as
+	  NVMe-TCP/iSCSI, to request the NIC to place ULP payload data
+	  of a command response directly into kernel pages while
+	  calculate/verify the data digest on ULP PDU as they go through
+	  the NIC. Thus avoiding the costly per-byte overhead.
+
 endif   # if NET
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 12aabcda6db2..20add6c3f2e6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -71,6 +71,7 @@
 #include <net/mpls.h>
 #include <net/mptcp.h>
 #include <net/page_pool.h>
+#include <net/ulp_ddp.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -6295,9 +6296,14 @@ EXPORT_SYMBOL(pskb_extract);
  */
 void skb_condense(struct sk_buff *skb)
 {
+	bool is_ddp = false;
+
+#ifdef CONFIG_ULP_DDP
+	is_ddp = skb->ddp_crc;
+#endif
 	if (skb->data_len) {
 		if (skb->data_len > skb->end - skb->tail ||
-		    skb_cloned(skb))
+		    skb_cloned(skb) || is_ddp)
 			return;
 
 		/* Nice, we can free page frag(s) right now */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index f9dcbad84788..d545d1525800 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -73,6 +73,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_HSR_TAG_RM_BIT] =	 "hsr-tag-rm-offload",
 	[NETIF_F_HW_HSR_FWD_BIT] =	 "hsr-fwd-offload",
 	[NETIF_F_HW_HSR_DUP_BIT] =	 "hsr-dup-offload",
+	[NETIF_F_HW_ULP_DDP_BIT] =	 "ulp-ddp-offload",
 };
 
 const char
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e6ca5a1f3b59..4a7160bba09b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5149,6 +5149,9 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
 #ifdef CONFIG_TLS_DEVICE
 		nskb->decrypted = skb->decrypted;
+#endif
+#ifdef CONFIG_ULP_DDP
+		nskb->ddp_crc = skb->ddp_crc;
 #endif
 		TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(nskb)->end_seq = start;
 		if (list)
@@ -5182,6 +5185,11 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 #ifdef CONFIG_TLS_DEVICE
 				if (skb->decrypted != nskb->decrypted)
 					goto end;
+#endif
+#ifdef CONFIG_ULP_DDP
+
+				if (skb->ddp_crc != nskb->ddp_crc)
+					goto end;
 #endif
 			}
 		}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e66ad6bfe808..3d9849a39b82 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1830,6 +1830,9 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	      TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
 #ifdef CONFIG_TLS_DEVICE
 	    tail->decrypted != skb->decrypted ||
+#endif
+#ifdef CONFIG_ULP_DDP
+	    tail->ddp_crc != skb->ddp_crc ||
 #endif
 	    thtail->doff != th->doff ||
 	    memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)))
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index e09147ac9a99..96e8228d2b96 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -262,6 +262,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 #ifdef CONFIG_TLS_DEVICE
 	flush |= p->decrypted ^ skb->decrypted;
 #endif
+#ifdef CONFIG_ULP_DDP
+	flush |= p->ddp_crc ^ skb->ddp_crc;
+#endif
 
 	if (flush || skb_gro_receive(p, skb)) {
 		mss = 1;
-- 
2.24.1

