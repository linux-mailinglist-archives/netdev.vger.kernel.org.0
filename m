Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A413D227F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhGVKZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:47 -0400
Received: from mail-bn8nam08on2057.outbound.protection.outlook.com ([40.107.100.57]:57440
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231796AbhGVKZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGsr+J5/Fj7tWRU+PzSPqGJQGh5menfwCeVxytxIebOeegeYZxexTwHmsTtxl2FIyvaKrO5Zksq+bp1mJPY84povI985ux627tBbc1yVe3v2dc5Tct2t+0dq89TEFGUUFvfH7Fjo5GDlEK8VGsAd99heT1GYz0FI7TWj0LjcJ5un0DcdWzq6EUet+M5eAWg5bmdsRmcp6I+uG1nMJVWuvWC2G9xCJM1YvZKRdEONg5/yjXsgfjM63SJZ5thmC9Ki7VmJLFiq8PsOcayxU3BV8nZiI48STlhE/+SFAn9TwrnxmvTdlKyQCxphuLthswI27WE+wdzuZMp0jkStajkMkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZDyYJpL1BwjLyHKPv4kjf6wRn+Kw2VKbmvpOLfLYvM=;
 b=cop0FimPgMZTMc9ulFrM7FYblXWPvfVsHscdxO6WkfRjbFj1MY0+1FMnnGcsdQJpxbLJWFH3Pgs9S7p122MZW9D1uveXzFcxtqly53xNHFN4xTXxUHRuvtc8uc/HHuqfVI3GNFe21E/9LZpmWPwtX3O7MEApHiDo8KkD1FH7ccD+uf2EPCRfguZx1x4ZHOkn9Tv//9941JweC4p7DjrZ5nNjr48bvO/X7XMzDoQJh+tvhO4QOEGmpqVmcy6y6sDopBv/cpIpccvhnMTIZesv2yQejnCy2tRmNlEz6vZcNHFj60DGoB8rYIwZKbvl50wQKQi2rOmtJkzjXGppK8+ZqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZDyYJpL1BwjLyHKPv4kjf6wRn+Kw2VKbmvpOLfLYvM=;
 b=UR43ydNMduFzOaLrmy/a0X3lF38j8Al6+e8vMTmvqFvHC0pIFHb54e6lCYNKlDWiiVR6TXojiHGW2MLn+iT/heM1vJEE8T2ELCTYaK0d2xUBbCr4KVPwI50Msj/At1PdQu39mWzMAms3+mrinWs7hbM/odW13bToxRvjTLxrg9PlxF0ZwKvF477sdaOmrv5ddYFL+cKdcHT6Apc72Cex7bfuIV6ZtUKg16iWx8cxkFKqSaMnB6di0wvhcG7Adj0ngrjJAK0gyvrOakSP+DvD8xdpsE1BqF7J3FoQHAoQbMTIxDO9+yToB6PJUVr2dOxCfKA3nFb4c20nPyEzhBhaVw==
Received: from BN9PR03CA0213.namprd03.prod.outlook.com (2603:10b6:408:f8::8)
 by CH0PR12MB5314.namprd12.prod.outlook.com (2603:10b6:610:d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 11:06:10 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::7d) by BN9PR03CA0213.outlook.office365.com
 (2603:10b6:408:f8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:10 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:09 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:08 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:04 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 24/36] net: Add MSG_DDP_CRC flag
Date:   Thu, 22 Jul 2021 14:03:13 +0300
Message-ID: <20210722110325.371-25-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ce402c1-a1a1-40ad-44d6-08d94d00b660
X-MS-TrafficTypeDiagnostic: CH0PR12MB5314:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5314EC646C1A7BB02DE124AABDE49@CH0PR12MB5314.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLwMYfk0rcrhnkWQ2EjsgAPotoVfXKiEW+rC4VDv93KS8SQXxjOY7rKh9e+Ousj8VcadPKMi2Rxs/rRC6IuNA0kBwAB2d0hsWFLzsyxBgzO1DgxqX+DgTvuDj6Hs725of77AA7cEnKEPXCCowT6YCMFAdzBHj2pnJCq715DgClIrnvN/EZ5iP4PXLwTphOD/fWpXlGsAnK5jjyR/dSStlsFE6vexDfpHouLdOPr2aIVrW+8svvEvZqqqGyzWPCqXovthrUr18dGbAp9YiSwKE2ju5afgPDhMiauH1ZDIQHNtHqApN0L4iG5mUuMyfnyZoru79gAOgo4ld7B1LKSIQNXcS885mKApnDdeyL4HeKFj8WwfN9s290xc7OJ6hB6JdaurTlgBEHTh67K16/2D3GivnHQ6Cfky0f22Im14mMpTYL+3J14Y9k15uBv96fjWJ8aWhNOnn0I4K+GOZzUTgMZ3nOYcSwKNqLxYN6tmDiSKwehdxhqIR+PvaDZQLyZhT2oJ/3L7HKvppqYl3eBqno1MVzIm0/hiFm86WXmHHUE7FiMdlk8bcoNJtQMrRxNBZhrglyuJ1jTt4FBirAvjMvBQR3ZRcHZfm1VQb68749jPc/IBzuPNJIakehl6MC4BLMM1kfeOB1kV4B1bnNnbgLTnvvw3FDSSgdy/JdLxjA9LSgOCSHJ5hj680ei9AW87lgbm7+Pi5aEnhYJMKNRGzhtVkTv1HmP1AvkYvw/3MrM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(36840700001)(46966006)(47076005)(4326008)(110136005)(478600001)(426003)(36860700001)(70206006)(70586007)(7696005)(82310400003)(2616005)(86362001)(5660300002)(2906002)(83380400001)(921005)(7416002)(316002)(82740400003)(6666004)(54906003)(36906005)(107886003)(186003)(36756003)(8676002)(1076003)(26005)(356005)(7636003)(8936002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:10.2098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce402c1-a1a1-40ad-44d6-08d94d00b660
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5314
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

if the msg sent with this flag, turn up skb->ddp_crc bit.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 include/linux/socket.h | 1 +
 include/net/sock.h     | 6 ++++++
 net/core/sock.c        | 7 +++++++
 net/ipv4/tcp.c         | 6 ++++++
 4 files changed, 20 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 0d8e3dcb7f88..640ec8535f43 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -310,6 +310,7 @@ struct ucred {
 					  * plain text and require encryption
 					  */
 
+#define MSG_DDP_CRC  0x200000		/* Skb pdu need crc offload */
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
diff --git a/include/net/sock.h b/include/net/sock.h
index 5fa2fd192d18..84141fdc3b80 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2656,6 +2656,12 @@ static inline struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
 		pr_warn_ratelimited("unencrypted skb with no associated socket - dropping\n");
 		kfree_skb(skb);
 		skb = NULL;
+#endif
+#ifdef CONFIG_ULP_DDP
+	} else if (unlikely(skb->ddp_crc)) {
+		pr_warn_ratelimited("crc-offload skb with no associated socket - dropping\n");
+		kfree_skb(skb);
+		skb = NULL;
 #endif
 	}
 #endif
diff --git a/net/core/sock.c b/net/core/sock.c
index ba1c0f75cd45..616ffc523b5d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2160,6 +2160,13 @@ static bool can_skb_orphan_partial(const struct sk_buff *skb)
 	 */
 	if (skb->decrypted)
 		return false;
+#endif
+#ifdef CONFIG_ULP_DDP
+	/* Drivers depend on in-order delivery for crc offload,
+	 * partial orphan breaks out-of-order-OK logic.
+	 */
+	if (skb->ddp_crc)
+		return false;
 #endif
 	return (skb->destructor == sock_wfree ||
 		(IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree));
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d5ab5f243640..36c445ed8a30 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -984,6 +984,9 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 
 #ifdef CONFIG_TLS_DEVICE
 		skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
+#endif
+#ifdef CONFIG_ULP_DDP
+		skb->ddp_crc = !!(flags & MSG_DDP_CRC);
 #endif
 		skb_entail(sk, skb);
 		copy = size_goal;
@@ -1311,6 +1314,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			if (!skb)
 				goto wait_for_space;
 
+#ifdef CONFIG_ULP_DDP
+			skb->ddp_crc = !!(flags & MSG_DDP_CRC);
+#endif
 			process_backlog++;
 			skb->ip_summed = CHECKSUM_PARTIAL;
 
-- 
2.24.1

