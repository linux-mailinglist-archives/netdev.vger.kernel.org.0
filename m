Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171F53D2268
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhGVKYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:02 -0400
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:41889
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231628AbhGVKXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:23:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlDV84A2+LXPEeYJiABOiQVlrtSY6D26/4s4o1QAI5hNxiD5fAf2qzwpmSmraMMp1S7xQScEsa7SWOI9xRnFNQ66P3aXPv4LhNjfDLH3WbD8djbH1+/uUvgdIG8CDlVjyT+OeHYiKjkg+g0y+PV6wet+/CynCZ1VZmD0/dHDPJT1DTMqQST69kT2QjdMYN6hZd5dtIUIv5sE4AlVooEzSF09L5dWPv9vstjdkSzy7x9tXlzXrWatmAOLSQDEZCXxPSpC+EEJnTAtywdDVxDMnzLDvLeHX+MW/PyiXaW7kB5V5j63CikzM9bKSYkJLCaF6afEiyv/s8V0FCFloKxElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xU5l6aDtsceNgoUrW3pxgrtmqwiI7usvRwB8T+szLtQ=;
 b=QehK6VS5tTLvEHVHYnaKzslYi6CHu2U2u4YgfZBMyHTfbeMOULRnSEbrMTkeqKzcgiy6t8a4jrc5ymX35SOb0Bhq4iAm9ZcN46p2a1FC1bpAQ9BFzaFizrbbaqOtHT5G1qxiiIRHvJfSHfUQzZyCg3dH4IHqFBQkXVHJVsjKe7fUHLMHjxaD6xxkgrQlSLawTkfzGZPXJAok2Mgzl6hJCg4RR9IDCztfdMSnnCAtuFD5f1dKbvjRfn4NxRWvOK+Xjhm7b/OwsGu4px2mV0O5aVt27nSih4X2885Uecl0tG8XCIi4ttf3ZDzWDSMA4SLHahPZ1Rg5ragq8M2xb4dzEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xU5l6aDtsceNgoUrW3pxgrtmqwiI7usvRwB8T+szLtQ=;
 b=DiI8Xdf+XH7R51hS+OBIMmNHuZN1uThJJOk+cNbCwK1d/s7G0bXLTdskB4h6Kw8gXzlX4Y/2bIUW/JZ4+9ur5h2CoFBSJUzzSfwBh1zktyOL2zPtiG/mdqhPGmmQxQncIMwpJsGLJ+bxx/E5hiCFurcsLX3i00xZLdSi3Kj5ERiWZGVVF6ZK3BDNCCuc48CDJql8PmjpYRbZGus2MiW04uG52QDMM15BiM98jwwhnxSaOt6d2RIB9TrBlbsbDWkH5hhjZLytZxDE0udtfrzj7tjg1fiO9Qk3uHVe5B1JI2Uqs5oGM7ZXoTVSjZtQrXAeIFb4KH1a5K9azjuhtHdPJQ==
Received: from BN0PR04CA0076.namprd04.prod.outlook.com (2603:10b6:408:ea::21)
 by CY4PR12MB1575.namprd12.prod.outlook.com (2603:10b6:910:f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 11:04:25 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::77) by BN0PR04CA0076.outlook.office365.com
 (2603:10b6:408:ea::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:24 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:24 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:19 +0000
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
Subject: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
Date:   Thu, 22 Jul 2021 14:02:51 +0300
Message-ID: <20210722110325.371-3-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc1bda8f-d512-4983-c86f-08d94d007797
X-MS-TrafficTypeDiagnostic: CY4PR12MB1575:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1575D2B0C43279EFB036FDD1BDE49@CY4PR12MB1575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AFklZ36uzu0+SigaEwzgPzh1c2C/vLV63T1wxRTGmA70w59x9tevJ7SP6Hi9rAisyzopfRKp9MmCQguKmKbdK2F5QE17X0i52V8p1iqxhk55p0Pz2ulL3eokSgR6peP0LgqDctw5z8tcbjjVDsfF6KUtBs6wg0oxWlQOKe1dMae8kQTU7BeDGzjyBXVLLP+EAavUQqmb7376prcyrtwvAjaGqCUnyP4uouYwU8vgms2lHpVlrFg4lN7qW+PPZ/S+aniK8Q4OwqL1Iv/KbWiTMV+NZD7fXeh9mOM0szjAYyOrYge6K9hakjraMeNshVwRVvXf2qRrmHM7pnmGiX7Mf51hsuBLPSE9YkLvCcbrT7Ol0fZ1gsNMCiuGYaocigWIKZHqeSGNZ3qwJmWQNTvVaTZ58P+pDWq7Wl1k4Iv3GLwFVY4t9zh21+n2a9jZECNfzAeHp2TnN3WMtOwl8mObxHcBi4vrjF34cHyyeFKUxBhlqNGlKT4JPa2cgejnQ0fReF6soap4hIA738jrIKhD0S/aPWI+8WvZ032PhHC5VJEK9pbSkecsAhlZKmOaGjZGsJddBg+BtzcOsAdSG63jBm3KQGcIm70Cc87Bc6m8Rj7WiZHxtPVEtAcf0BUFSokDVStPmWZ3wGMnTbdce/ZiH3PancdPgmAtXVIEmBP/A4MPyBb+1D5BhUgJQY6Jw9yYj9KpEK1hY+j1x/Iyi7riqDrMC5rA5gUvZPVtnoPfDG8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36840700001)(46966006)(5660300002)(186003)(4326008)(1076003)(36906005)(54906003)(356005)(7636003)(316002)(82310400003)(8936002)(36860700001)(26005)(426003)(8676002)(6666004)(2906002)(7696005)(336012)(110136005)(478600001)(83380400001)(2616005)(36756003)(107886003)(70586007)(921005)(47076005)(86362001)(70206006)(82740400003)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:24.9721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1bda8f-d512-4983-c86f-08d94d007797
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1575
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

When using direct data placement (DDP) the NIC writes some of the payload
directly to the destination buffer, and constructs SKBs such that they
point to this data. To skip copies when SKB data already resides in the
destination we use the newly introduced routines in this commit, which
check if (src == dst), and skip the copy when that's true.

As the current user for these routines is in the block layer (nvme-tcp),
then we only apply the change for bio_vec. Other routines use the normal
methods for copying.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/uio.h | 17 ++++++++++++++
 lib/iov_iter.c      | 55 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index d3ec87706d75..a61fdb369e0e 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -131,6 +131,9 @@ size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
 
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
+#ifdef CONFIG_ULP_DDP
+size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
+#endif
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
 bool _copy_from_iter_full(void *addr, size_t bytes, struct iov_iter *i);
 size_t _copy_from_iter_nocache(void *addr, size_t bytes, struct iov_iter *i);
@@ -145,6 +148,16 @@ size_t copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 		return _copy_to_iter(addr, bytes, i);
 }
 
+#ifdef CONFIG_ULP_DDP
+static __always_inline __must_check
+size_t ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
+{
+	if (unlikely(!check_copy_size(addr, bytes, true)))
+		return 0;
+	return _ddp_copy_to_iter(addr, bytes, i);
+}
+#endif
+
 static __always_inline __must_check
 size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
@@ -281,6 +294,10 @@ size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct io
 bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i);
+#ifdef CONFIG_ULP_DDP
+size_t ddp_hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
+		struct iov_iter *i);
+#endif
 
 struct iovec *iovec_from_user(const struct iovec __user *uvector,
 		unsigned long nr_segs, unsigned long fast_segs,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c701b7a187f2..2e9be46a9b56 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -508,6 +508,18 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
 }
 EXPORT_SYMBOL(iov_iter_init);
 
+#ifdef CONFIG_ULP_DDP
+static void ddp_memcpy_to_page(struct page *page, size_t offset, const char *from, size_t len)
+{
+	char *to = kmap_atomic(page);
+
+	if (to + offset != from)
+		memcpy(to + offset, from, len);
+
+	kunmap_atomic(to);
+}
+#endif
+
 static inline bool allocated(struct pipe_buffer *buf)
 {
 	return buf->ops == &default_pipe_buf_ops;
@@ -648,6 +660,28 @@ static size_t csum_and_copy_to_pipe_iter(const void *addr, size_t bytes,
 	return bytes;
 }
 
+#ifdef CONFIG_ULP_DDP
+size_t _ddp_copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
+{
+	const char *from = addr;
+	if (unlikely(iov_iter_is_pipe(i)))
+		return copy_pipe_to_iter(addr, bytes, i);
+	if (iter_is_iovec(i))
+		might_fault();
+	iterate_and_advance(i, bytes, v,
+		copyout(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
+		ddp_memcpy_to_page(v.bv_page, v.bv_offset,
+				   (from += v.bv_len) - v.bv_len, v.bv_len),
+		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
+		ddp_memcpy_to_page(v.bv_page, v.bv_offset,
+				   (from += v.bv_len) - v.bv_len, v.bv_len)
+		)
+
+	return bytes;
+}
+EXPORT_SYMBOL(_ddp_copy_to_iter);
+#endif
+
 size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 {
 	const char *from = addr;
@@ -1818,6 +1852,27 @@ size_t csum_and_copy_to_iter(const void *addr, size_t bytes, void *_csstate,
 }
 EXPORT_SYMBOL(csum_and_copy_to_iter);
 
+#ifdef CONFIG_ULP_DDP
+size_t ddp_hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
+		struct iov_iter *i)
+{
+#ifdef CONFIG_CRYPTO_HASH
+	struct ahash_request *hash = hashp;
+	struct scatterlist sg;
+	size_t copied;
+
+	copied = ddp_copy_to_iter(addr, bytes, i);
+	sg_init_one(&sg, addr, copied);
+	ahash_request_set_crypt(hash, &sg, NULL, copied);
+	crypto_ahash_update(hash);
+	return copied;
+#else
+	return 0;
+#endif
+}
+EXPORT_SYMBOL(ddp_hash_and_copy_to_iter);
+#endif
+
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i)
 {
-- 
2.24.1

