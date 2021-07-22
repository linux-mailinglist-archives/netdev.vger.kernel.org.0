Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CB13D226B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhGVKYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:13 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:41953
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231513AbhGVKYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=intglNnk8+whoDQQoWXRQ//8uDfiEnRChDPtFgG5+Ar4y24Bp5NNtjX2NpkxxX5VINyEU3FXh/Gam38qlI2I9d5rkHshZylGvV8mqN/xwae3QWgiwp9QnGvwZHPrdivUUYQBwL48AsSzjCOK1iu7XVeATnj9fALenfo0SAvzhh7yQs/FY1GR29oGofudSyKKXlzeBxUzyGaexZ5gGmqN/varpY7MIDmxRFrBtNmMnREDv7Wg3JSiOWzPWDZKgXnwHw88gikuWO2joEr0VlLhJmX3JBSqWrccoJyrNZGMUcl4AwTTOlHMfOWNirNmjylnT5jAgoK+ByWe8ZYqHxssHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d9jublZvcwGcMthhVaxofy1VrIhWLzT/zvHLc6MzU0=;
 b=aNOqNos5v1zuTeq1l+o27LuQkgbOUEzqnACR51jxgYCggeGDArYc+B81RtXu+0BzyNgbt6Z+jJJmKtjn3ikqZVs5pqfYK2VMx70nxxXnowXms2xU7dh3OJev8zmX1C8t4YqNw+ghyKMCkDydtj503o6rYRIq1+A4v40TAWG6nbtkcHzH2SOop0K5bWUY+SnPpmXtI5tdcKHrgvO+XJH4VuzT1LJtBrBNu5GXEQxEGC7b1frDIr657qOJNcDpLy/QNsuTh9oDLlAiwGCC1dRIfi1ph22QEKuHbussE25+SBoo5q020xjp9unXImC91xOQ94ZoGIo6lX55hfXDTvm3EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d9jublZvcwGcMthhVaxofy1VrIhWLzT/zvHLc6MzU0=;
 b=Gb/JnUeCE/L1+22WMzvP5B7iE4uoUKpzwAJI/J1CRrZ6XcjtNlS/wajOvEhzrmMStqwZC1EuX1V0OnNHio+nvzGVg5OeCkiz+a2NlC4Ax5yKO+u4e0b/9zFfA+gNjBihiFQD60fgruUf/0th4Fo29ZPZc+QCcDEQ9oKolpNkO9AVlJ0Nkj16u133B1e5ME2lfT4oUKzQoi40QPYvFIjpSVApbdIXtL1nU9yanI3mEpsj30ZMQ0xIZWGTxf4qMclanHqw1Kz/g/lJAfBcTafbYlPEODKC3TrbGSx+mKdFxp9Ppn+LzI2IghFfKkrjpy0Wl+YshlkmlA7epLlahD1cpA==
Received: from DM5PR13CA0034.namprd13.prod.outlook.com (2603:10b6:3:7b::20) by
 BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.26; Thu, 22 Jul 2021 11:04:34 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::5c) by DM5PR13CA0034.outlook.office365.com
 (2603:10b6:3:7b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:33 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:33 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:29 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: [PATCH v5 net-next 04/36] net/tls: expose get_netdev_for_sock
Date:   Thu, 22 Jul 2021 14:02:53 +0300
Message-ID: <20210722110325.371-5-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed58ca19-fe22-449b-c50e-08d94d007cd5
X-MS-TrafficTypeDiagnostic: BY5PR12MB4194:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4194787428F1D61BD12C0850BDE49@BY5PR12MB4194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:192;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GnlUnBv+nZjtywZL3KVjeGe34GNEkd59T/6o7G+AZvwe9N5nXQTCDRPUWgcBQhYvLCIuUjqg55FOucQGHepAV6BH7ZfTVF6fmxl4NOyCzUb0HzY1u3NF/kLKI8P8Yuj5SKtu+oEXJ8zHZ8zHkp/230i2DatYZZ8BraTLAb3IUQypfukd/0gcuWZ01DUIZvDlBZNvEGdbeZYauBVSVX7x5TVq+yXX8RL0u7tm5JJAjRfUquWr4qwJ5SaavBWcCYFemDLRQOyqx4JBus0PHcYFXW8pvRaHvbc6LmPrB382gr5PuJh2BzRlbgn9Z7Lq/kjZ2xwXkz0aDadCZNlbTCKgeutKHAH2jDvgPuGq91P5Rw6W1tZMBoxtOXvM58a9gWLiVcrn5exvdDdHCtr2KOVfT36VfiBe+5dXY9ofTXKhispPcZ2fWoENgwE7TH9Llq0Dk+gMG5uA+gotWY6Yiv3o+IS6MQvF7ExTJVKevKZnbvW+sbZoYipfN3Tpv5H5AqY6aVjH+zWF11kPAwQ/A4DNpGJHc2ZoR+1rAkxBjADiYI4LfsRlI+v5D23daSorr25/ItTSd5jT5FUbIKghTzvxMPcmWJfqmDFxaTcolml/BVayHneOPpKIXAGTU1JTUJGDCLOC2bnRLDFxk5uJWzntoyXTfzuce8wwgNamo8I1jRzWUxqkradRXFVeT+N0Tx7pBUCMjkbR3p6QBGRDFmf/UWcitpFwfUjG4yp8xIdgs+w=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(46966006)(36840700001)(478600001)(8676002)(6666004)(36860700001)(83380400001)(356005)(47076005)(921005)(36906005)(316002)(70206006)(86362001)(110136005)(54906003)(5660300002)(7416002)(70586007)(336012)(4326008)(1076003)(2906002)(186003)(8936002)(2616005)(107886003)(26005)(7696005)(426003)(36756003)(82310400003)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:33.8389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed58ca19-fe22-449b-c50e-08d94d007cd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

get_netdev_for_sock is a utility that is used to obtain
the net_device structure from a connected socket.

Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 include/net/sock.h   | 17 +++++++++++++++++
 net/tls/tls_device.c | 20 ++------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8bdd80027ffb..5fa2fd192d18 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2769,4 +2769,21 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
 int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 
+/* Assume that the socket is already connected */
+static inline struct net_device *get_netdev_for_sock(struct sock *sk, bool hold)
+{
+	struct dst_entry *dst = sk_dst_get(sk);
+	struct net_device *netdev = NULL;
+
+	if (likely(dst)) {
+		netdev = dst->dev;
+		if (hold)
+			dev_hold(netdev);
+	}
+
+	dst_release(dst);
+
+	return netdev;
+}
+
 #endif	/* _SOCK_H */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b932469ee69c..06aa5f1e73d1 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -107,22 +107,6 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 }
 
-/* We assume that the socket is already connected */
-static struct net_device *get_netdev_for_sock(struct sock *sk)
-{
-	struct dst_entry *dst = sk_dst_get(sk);
-	struct net_device *netdev = NULL;
-
-	if (likely(dst)) {
-		netdev = netdev_sk_get_lowest_dev(dst->dev, sk);
-		dev_hold(netdev);
-	}
-
-	dst_release(dst);
-
-	return netdev;
-}
-
 static void destroy_record(struct tls_record_info *record)
 {
 	int i;
@@ -1118,7 +1102,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-	netdev = get_netdev_for_sock(sk);
+	netdev = get_netdev_for_sock(sk, true);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
 		rc = -EINVAL;
@@ -1194,7 +1178,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	if (ctx->crypto_recv.info.version != TLS_1_2_VERSION)
 		return -EOPNOTSUPP;
 
-	netdev = get_netdev_for_sock(sk);
+	netdev = get_netdev_for_sock(sk, true);
 	if (!netdev) {
 		pr_err_ratelimited("%s: netdev not found\n", __func__);
 		return -EINVAL;
-- 
2.24.1

