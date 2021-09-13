Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE3F4085DC
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 09:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbhIMHzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 03:55:33 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:49504
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237995AbhIMHza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 03:55:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNF3miEn5o11662eX0fZTVtOxCi0j4M4DCydrToyvfQ9Webr1dnM6d7PtF9cFvFQfecjs30Q4l4AMplbwQ0wa470nnLt1+YKF/6FgK6erjK1RkfGwgAafE2SuzojEz04NpHtBM08IooKC/HFuoJNQyeaRAmZ0JvYZnUol+Wx996pK0j6pGTNwEezALX5Jp7TzEk4a/MParkyBumdwraFYgMs8SdfDXaqMuEZJHNvL5u/GGg2DdpXzC3bxbPUrytQJDN0ILbV5EHytAVk1o3oVRVuNcmH9ZWQPNjAwSBPwMDAAA7TY7esBkEs36WEEOyVxv7Z7WG6/T6de9Znm1sZcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7ZohAGgbxvzXWcAaL5gbil9iXzq6TPAHBnj4EqvdLm4=;
 b=Mjrk3L7fz4CVyoaWvTSopv9qR9uYe+0VFrrRiuVL7Swai6YkHLzfo3HmCYrFCFI9da+FGKNFNfx4KHEHyQoN45znqGX51sKjM09Ut1MYrW+6locblwKGcSS/YjUyZDYneObj/Y+7Y+QeWdXgipyjG1o1Lfu8ZIR4X8c+AjYpV6Umvft4LWgjafat6lHP0Je7aWvBzm8/9OWw0/A0C7Y4ASU47vYhOQevkrQBrjBNQKYkzzdIuKaUDhlqpkBgic/T2mQI4OdffAmD3VY/ZZMXilSj4IxmKw/a2nkBPc84cZegmYIktHKO1ooKBntj+dKcz5ssUzXFVbc7vHXbkcXjYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux-ipv6.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZohAGgbxvzXWcAaL5gbil9iXzq6TPAHBnj4EqvdLm4=;
 b=uepA0XA6UzzCzhVCCgAYG5BIGOvw0GTbYR151/XTiYnP/EjoUwPKE55u+9ImDAQ2rdIz4a8tPqiPSh/LHweqGFGgZSI4eksSj51dU2ZazJevILGLMj6/mVe2bE7MZNOA81ZN9cRKqOJWk4EtfUZ4sl0q6DmZcdlQPOV7P7crsOC1tljZsxlhLmBtj4+xMHWRTIB9K89xS1UMPy1EETwVuA0LEOvnP6arHe1QUw0Us476JFM3eZe2jcud18tUdRUAb1RBx+2jdUO8fat/FwsNKqjT6nuJnSNyU1adW1WyWK8pZnBqDXx5rghciurCNoaCKEQuEvJ7CmpjCOqNHbTfgQ==
Received: from BN0PR04CA0201.namprd04.prod.outlook.com (2603:10b6:408:e9::26)
 by SN1PR12MB2351.namprd12.prod.outlook.com (2603:10b6:802:2b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 13 Sep
 2021 07:54:13 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9::4) by BN0PR04CA0201.outlook.office365.com
 (2603:10b6:408:e9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Mon, 13 Sep 2021 07:54:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux-ipv6.org; dkim=none (message not signed)
 header.d=none;linux-ipv6.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 07:54:12 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 13 Sep
 2021 07:54:11 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 13 Sep 2021 00:54:09 -0700
From:   Aya Levin <ayal@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
CC:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [PATCH net] udp_tunnel: Fix udp_tunnel_nic work-queue type
Date:   Mon, 13 Sep 2021 10:53:49 +0300
Message-ID: <1631519629-12338-1-git-send-email-ayal@nvidia.com>
X-Mailer: git-send-email 2.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 539550b9-8d26-4b96-265e-08d9768bad22
X-MS-TrafficTypeDiagnostic: SN1PR12MB2351:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2351500CDA0C6A9EF3A4D0CFBDD99@SN1PR12MB2351.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6Zu935wqcKAZHwpb9IC79g15fNoVt4yG0ujPR9KV1dliuQpEsiI/gnVydfl70HwXn+NSezGpHV1w7r/RffUjDBhItQhD0NWUdOeyP0PsgSny+iQAeg5x20nin5lJcjDgCpl5C/wgh480Dm1yWjY/6afxLo5mHKVftzKDjTQ4fq9f+R96xUogPLSsgrAeukhM1pgfRF7jcGEEoXt2EOY0MhC4uSTazQCNx6atA9h52HXlR2li8Ky2yFw/TgZ/N0usI58ZOcRO4B52DbsypOvsjSbeY5gXq3DaXa9ZQG5Xqb9XAiP/wDya84RnAOGiwm4X39BEHYXf5bLsUCUaAANqqZtQriAp1r+dMnNb74IejSNhy+BDqtYpS2TOM1ShiXKarjSn7xA167AMjY/dyN5P4EjhPurLD9WEZLi+J0Iu3V6JC0Q6vR3aMfw+eLOnw3VpAA/yMK9DzOAY5uZ+owRg2+LLmhLTa8sFftju6XzpxU6sQcpk1/M/BI3+wGRhA/2+bZnIssPd5VhdvA1qHAAwnDzuTZDwnrVUQWqh85pG5z2hxH8u3dZJSW+TiA2z++dN9awPbNmd5/z5CFvVpY+XGmIcUgDxuGPmkdwgzgfUiwyI8dBmMi29NWrpo7YWx0Wer55Tuvqv6UvmaHI5+j1Bt3qtETpLyzYOlnmj+szUjkX0CP8F6iniNcpUta6tXAVoHFyyaLXYG/ayD43QNnYxg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(82310400003)(426003)(2616005)(508600001)(5660300002)(110136005)(186003)(336012)(36860700001)(4326008)(107886003)(26005)(356005)(7636003)(316002)(8676002)(83380400001)(70586007)(36756003)(2906002)(54906003)(6666004)(70206006)(8936002)(47076005)(7696005)(86362001)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 07:54:12.5104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 539550b9-8d26-4b96-265e-08d9768bad22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2351
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turn udp_tunnel_nic work-queue to an ordered work-queue. This queue
holds the UDP-tunnel configuration commands of the different netdevs.
When the netdevs are functions of the same NIC the order of
execution may be crucial.

Problem example:
NIC with 2 PFs, both PFs declare offload quota of up to 3 UDP-ports.
 $ifconfig eth2 1.1.1.1/16 up

 $ip link add eth2_19503 type vxlan id 5049 remote 1.1.1.2 dev eth2 dstport 19053
 $ip link set dev eth2_19503 up

 $ip link add eth2_19504 type vxlan id 5049 remote 1.1.1.3 dev eth2 dstport 19054
 $ip link set dev eth2_19504 up

 $ip link add eth2_19505 type vxlan id 5049 remote 1.1.1.4 dev eth2 dstport 19055
 $ip link set dev eth2_19505 up

 $ip link add eth2_19506 type vxlan id 5049 remote 1.1.1.5 dev eth2 dstport 19056
 $ip link set dev eth2_19506 up

NIC RX port offload infrastructure offloads the first 3 UDP-ports (on
all devices which sets NETIF_F_RX_UDP_TUNNEL_PORT feature) and not
UDP-port 19056. So both PFs gets this offload configuration.

 $ip link set dev eth2_19504 down

This triggers udp-tunnel-core to remove the UDP-port 19504 from
offload-ports-list and offload UDP-port 19056 instead.

In this scenario it is important that the UDP-port of 19504 will be
removed from both PFs before trying to add UDP-port 19056. The NIC can
stop offloading a UDP-port only when all references are removed.
Otherwise the NIC may report exceeding of the offload quota.

Fixes: cc4e3835eff4 ("udp_tunnel: add central NIC RX port offload infrastructure")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

---
 net/ipv4/udp_tunnel_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Hi,
Please queue for -stable >= v5.9.
Thanks.

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index 0d122edc368d..b91003538d87 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -935,7 +935,7 @@ static int __init udp_tunnel_nic_init_module(void)
 {
 	int err;
 
-	udp_tunnel_nic_workqueue = alloc_workqueue("udp_tunnel_nic", 0, 0);
+	udp_tunnel_nic_workqueue = alloc_ordered_workqueue("udp_tunnel_nic", 0);
 	if (!udp_tunnel_nic_workqueue)
 		return -ENOMEM;
 
-- 
2.14.1

