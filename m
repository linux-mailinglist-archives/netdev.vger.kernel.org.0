Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E3F3D2269
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhGVKYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:04 -0400
Received: from mail-bn1nam07on2046.outbound.protection.outlook.com ([40.107.212.46]:21252
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231629AbhGVKX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:23:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz/OzZnCv4mTj2zngNDawBtOVY/vjMdQBXkB/EnngQyQ8571PHlzDdZSUovsiLGe0wJCHhxQGorjYer4JqPcaCvuTQU3oyGJ6Czrdc/2023OkujoajRO/j/lFyAc+2QhSMK4yWyKevHqyku81izNgtvx32M2CObqH0izE7XD3JzguVOIrU91bCQ/UVhK7b/jAbptszjso2eWYpxkui3lAQzeaw/JTOrpaFLRc8cA21bF5HUyRfoRpqkLq6Uw7IDckWeBfpETdgYOS/SPAEVTl6ecXs8Md2ayNBLUeQ6IBa+pQJXMw4OAcSolARdV/eBR2C357aw6B++vmiw0cFcnqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aMa/LbdVVpeKmbblabEig4UwdwuOWkRhu0YaUZoYC8=;
 b=H4Tz94q09hMh5AHUIyZ1xuFyPfPt265Nv8azwFSbT+o4BJkQ/mdMOWS9hbdZU+sj1Y3dzjMngrnjNQR08o/k9cTuZiWdo7G1ys65vNHpbpYc/7QzCcq7VQeeM7DKI3NyIblJ/RHK4XK45Hko6Kb+eyWT2HbIMt+vM0DCS5Y7rhrsOcp/xuMiMxu/Hc/kPSDYMgev5URsNW4aMZ64cCvjDLb8a6N7Q/gUOZmJCQq52ZRsx/VPvRIy+4H9x5IgiRIWzzsdCPPzfX9C+1N8lB2N625fkzSbWakto2YBAemp0i1oKT0+qctY+w55ksZ3oT9rdqyYhKELakc1sHAtXZMmGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aMa/LbdVVpeKmbblabEig4UwdwuOWkRhu0YaUZoYC8=;
 b=ZOkajTKqJWB2b5c1RaYaF/2hyfUXDcjloRhfdCqZlDOWTZXHhtatP3pEl7BQug64OhtiApySTagyA2Mum+s6e19CvYmiFYqPWjYKvZkCysoWyQMqgsXcn7i2n90X7+FDu+woASdLwqFksXV2jnk1Nkym4FMW7ni1QpL4in5xsHNqARGF8+t3b4AhCapZ6lVh7nqkY+Dz215DMP3NAv1DD9c3JlwwPKbpfbJ2y4V0AA9TTflFYKO2ANQdsSLiGSZW0eUI0etNl4sT3+njm9E0Fe7V9hf+kkL1OgWwvcZEBLpvgjf6zjpu4B+NdNw8F7jytoaelGstiZYIqIbCiifvAA==
Received: from BN9PR03CA0320.namprd03.prod.outlook.com (2603:10b6:408:112::25)
 by MN2PR12MB3486.namprd12.prod.outlook.com (2603:10b6:208:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 11:04:30 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::46) by BN9PR03CA0320.outlook.office365.com
 (2603:10b6:408:112::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:29 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:28 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:24 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 03/36] net: skb copy(+hash) iterators for DDP offloads
Date:   Thu, 22 Jul 2021 14:02:52 +0300
Message-ID: <20210722110325.371-4-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 354ce2b0-fcd5-4de4-136e-08d94d007a65
X-MS-TrafficTypeDiagnostic: MN2PR12MB3486:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3486DC4C6B7088BCB9416F8DBDE49@MN2PR12MB3486.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ss+cR4gX0w8eeS1jnnzy6ds/5RWKjAXNUjwzH2uPJzUXqh/xvkwP4LRcTwlNq5UyWdhcHZ8yT3xtZ9AwfcIOyS0SL/ryXULLKZoO4An87ENwTa+jY2jjtXBx8M+4PvNzPr+IfgDPFamae4P2jFV4ZzywDI+XY6RuA3KVLGxIoOxCP/qaLgGfT2gOOzGnn7ke53DjaGFqLtvhJHeoBveFahLzzH+Yoion06UkjuklUrQHN+aN/82dfmlavgiTRkUVfZWBrBRjI5xwK0ExAORoDTD28dUXJx9jEpgFUO5y7/s0ix88qBGdJDEh9XjIgvpSwFv/59EpgNin7a7Ce/kZp/aQYqf+fidhEMRps+TNsNSXzFBQm9tq4QE2johSmvzqjPW+VIpefBCkqDh18TG44tJsF6LofHpckcl1PURz9ZSO24LuqnQdJt8dT1a675acGijF9IXWaK+1ytZt8xE+2+ig+TQBpMOCwAFXqhbvugxzg0H4VbD2XhxJNZWJMHueQ5uign3dB7IcvX/JxGiNziWGfc5IzoAn97uLeoqICavSRQAslCiZzvW4TH1DBp3SoFkt9RfqfyYdAaBOoE89sFb2+5AdsWVR7Wt6e5nsLkRM0Gpw/QQGDMfonv4giDsDHq7U+1lrWY6xRPcVckJql9miSVwvcTY1eCBHTS6umppxyPh3qPN7pelDyjoDjPSA+0ExTMd9WUn8/YySI1kvIaNnh6SeENYNS1Ub530wg8c=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(46966006)(36840700001)(2906002)(86362001)(83380400001)(36860700001)(186003)(82310400003)(107886003)(6666004)(921005)(47076005)(8676002)(5660300002)(8936002)(70586007)(70206006)(54906003)(316002)(36756003)(426003)(4326008)(110136005)(36906005)(7696005)(356005)(7416002)(336012)(26005)(7636003)(1076003)(2616005)(478600001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:29.6809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 354ce2b0-fcd5-4de4-136e-08d94d007a65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3486
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

This commit introduces new functions to support direct data placement
(DDP) NIC offloads that avoid copying data from SKBs.

Later patches will use this for nvme-tcp DDP offload.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/skbuff.h |  9 ++++++++
 net/core/datagram.c    | 48 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d323ecd37448..8c1bfd7081d1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3613,6 +3613,10 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
 			   struct iov_iter *to, int size);
+#ifdef CONFIG_TCP_DDP
+int skb_ddp_copy_datagram_iter(const struct sk_buff *from, int offset,
+			       struct iov_iter *to, int size);
+#endif
 static inline int skb_copy_datagram_msg(const struct sk_buff *from, int offset,
 					struct msghdr *msg, int size)
 {
@@ -3623,6 +3627,11 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb, int hlen,
 int skb_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
 			   struct iov_iter *to, int len,
 			   struct ahash_request *hash);
+#ifdef CONFIG_TCP_DDP
+int skb_ddp_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
+					struct iov_iter *to, int len,
+					struct ahash_request *hash);
+#endif
 int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 struct iov_iter *from, int len);
 int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *frm);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 15ab9ffb27fe..d346fd5da22c 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -495,6 +495,27 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 	return 0;
 }
 
+#ifdef CONFIG_TCP_DDP
+/**
+ *	skb_ddp_copy_and_hash_datagram_iter - Copies datagrams from skb frags to
+ *	an iterator and update a hash. If the iterator and skb frag point to the
+ *	same page and offset, then the copy is skipped.
+ *	@skb: buffer to copy
+ *	@offset: offset in the buffer to start copying from
+ *	@to: iovec iterator to copy to
+ *	@len: amount of data to copy from buffer to iovec
+ *      @hash: hash request to update
+ */
+int skb_ddp_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
+					struct iov_iter *to, int len,
+					struct ahash_request *hash)
+{
+	return __skb_datagram_iter(skb, offset, to, len, true,
+			ddp_hash_and_copy_to_iter, hash);
+}
+EXPORT_SYMBOL(skb_ddp_copy_and_hash_datagram_iter);
+#endif
+
 /**
  *	skb_copy_and_hash_datagram_iter - Copy datagram to an iovec iterator
  *          and update a hash.
@@ -513,6 +534,33 @@ int skb_copy_and_hash_datagram_iter(const struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_and_hash_datagram_iter);
 
+#ifdef CONFIG_TCP_DDP
+static size_t simple_ddp_copy_to_iter(const void *addr, size_t bytes,
+				      void *data __always_unused,
+				      struct iov_iter *i)
+{
+	return ddp_copy_to_iter(addr, bytes, i);
+}
+
+/**
+ *	skb_ddp_copy_datagram_iter - Copies datagrams from skb frags to an
+ *	iterator. If the iterator and skb frag point to the same page and
+ *	offset, then the copy is skipped.
+ *	@skb: buffer to copy
+ *	@offset: offset in the buffer to start copying from
+ *	@to: iovec iterator to copy to
+ *	@len: amount of data to copy from buffer to iovec
+ */
+int skb_ddp_copy_datagram_iter(const struct sk_buff *skb, int offset,
+			       struct iov_iter *to, int len)
+{
+	trace_skb_copy_datagram_iovec(skb, len);
+	return __skb_datagram_iter(skb, offset, to, len, false,
+			simple_ddp_copy_to_iter, NULL);
+}
+EXPORT_SYMBOL(skb_ddp_copy_datagram_iter);
+#endif
+
 static size_t simple_copy_to_iter(const void *addr, size_t bytes,
 		void *data __always_unused, struct iov_iter *i)
 {
-- 
2.24.1

