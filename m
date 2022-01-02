Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D706482A95
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 09:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiABINJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 03:13:09 -0500
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:20704
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbiABINI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jan 2022 03:13:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGd8vbQ/88vXR3XtrpohdopUkzzYt/HSQTj4/3BXvK6xtesJvQECWSYHUMUa5Na0ZyTU/30e2TGQKmaKFbb+dH2UGvO9NWG1iA2cj9wTzHDobzQkSiixepRFntHaGQpvXy40988tcKXfvUu4H/6qZLCQLGHJe10W8rpEOYEEy8GKo9NL1zmyDkmczGQhJ7on2178H3oEVEYEJDdfGi2LNYYBpSbZ4FHWIv+AS9YSu+e/cBAH8VDKsMXLXzeKQtzhC0DRF/i6vkRNGnYfSVAr9VAXuq2lvUcdvpLpJLAwPrQe7+z/fC/M2ciTZeZeeHQ/t/gj+L3aEBrHuDOA8JNv0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDfPLxF6iB3+4Pjcfbe4cxwEY8pIy0fpqSZdwSVULs0=;
 b=S+3m91vCQ3YTseT+w0Cji7AGIaQyKkHYzLyhrHpqKhpRdfAMGnUa3JtREI/v67pi3jA27dIwztcfUBGljbWPSgobctj8gmwRna7HzwegK09VtfrFPT3rfkZ2L3NKcVlbTqJ3+OhoRizbZS25qUJDomtZyXhu1fX7OzpSv5rj95/me12zaNosuEomUquynOHXO0A+NHoSHKj2kn+lFazLBxY9q39BJtnhiYGMWZ1+/7r4jGVFzkFro1XP+v27tSR2DMJncfr5717/r1RWkzjCTyI927+y04MYzdgKk3KPDTcC7HkaAI8xUbpSAieTjgPSsUzQkUKrR9+6GjRwlAvSSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDfPLxF6iB3+4Pjcfbe4cxwEY8pIy0fpqSZdwSVULs0=;
 b=P+U1WG8CYrk8mZ5aGRQPkirTNORT6T6uxUg//L5NleoeJys5ZCaHzdAj8Ib5sOl7Sly/2dzpm3S7Z7ViowjiTy+8dFOB+ukvehnL07Xxpsg5PyNF2Cmjq+phfGqvKc/LwCw6mxwz4v/wWhDLkUngJB72nXggywW5bXwC1Cwx79a7+9++clrYKoSG+rLhJ8INBUC6GlTeBalLQw9EIP8np4ayaQmDAjidAIpeMb3F3YzsfJTEVNKPsbajdfT4oDYnh96d7pitlYT0O/9U/B3E67KZaz0KgaWfRzmyZa/TWQaE6I7H2AKjewOCkvZBtwdmXnqcw0u7dSeJxiqYVgr3ew==
Received: from CO2PR18CA0043.namprd18.prod.outlook.com (2603:10b6:104:2::11)
 by BY5PR12MB3825.namprd12.prod.outlook.com (2603:10b6:a03:1a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Sun, 2 Jan
 2022 08:13:06 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::c3) by CO2PR18CA0043.outlook.office365.com
 (2603:10b6:104:2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15 via Frontend
 Transport; Sun, 2 Jan 2022 08:13:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Sun, 2 Jan 2022 08:13:05 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 2 Jan
 2022 08:13:05 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 2 Jan
 2022 08:13:04 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 2 Jan 2022 08:13:02 +0000
From:   Gal Pressman <gal@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [RFC PATCH] net/tls: Fix skb memory leak when running kTLS traffic
Date:   Sun, 2 Jan 2022 10:12:53 +0200
Message-ID: <20220102081253.9123-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d90f895-694e-4d01-b37f-08d9cdc7b452
X-MS-TrafficTypeDiagnostic: BY5PR12MB3825:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3825509E71BF3A547E20FDE2C2489@BY5PR12MB3825.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bX7FZ1s7Zo7AJ+iQSKUIsTflp+pLV9gsYy2GggULCaeemAy4+DQCve6QFBcn+1pqrBRqWzilweUCBZu9HCcwmDPV2Y1YvruMv6xgnU2ZXHXGm8KAf5HJ3HmYjqzipoAYEEctvwgs5v0lgsXiztFPsfCYvjWmJdpIy1Wq6cd6UFbLaVxDVLKIFO3W3cU5mH8OQH5GO0BX1duEwSgjEtF8prBfB7Tg4GOjYrc5xXyh4WWxB+exShbw1T2GD63dg+wZlXA5kLmZtjsqH0w1zcr+Oh5Npr5OAY/8DJ8yvGgLurxrAVnYGtILbWXkbJHfKI3aBeF92YI4uNHLxQelOiWF/2Pvm0jZGPcFOD5gpGPDUvsSdaPiS/H+jE7cai2QLmPo50243Oo/zmCvyzo8qhIcTdC3VmL8sK24HXEOqnTmfkjQguchr5m80y4g6n2G5r41oEc7lTvm/utP6A/OQu3U7OpxM0f28j4Z+CpJ2rLlX+PU0Nbea2OyR1dw0NZuq72HCjO/r0k6cccgiCf/1aHWS9f/GazlnfbvDGPlVtUF2I6hIceW2JgDAAmcL0SrGByyX6MIYDHlxeUreaVGCmO8hDDb4CFS7ApXYnIp0FGRAty3UFVX2g4rhhOGGrVGGJfJZe5ks6d5mFhSpVa9AwTo4qyC+cogGIxWzStiLgSxm3ogIKnIbuNsRFMgID+cykyeWlYbJBF42YZZfcx8Md96XdySBPtc+IeWW09AAX2NtPuiccA4SELKgpYSsp9Bov0cvsfe5AWbEu3SzfibpRssd0ZTUk8P1WfQHOyB89w06eYZ+7kzi/iUqC7T8Ob+gceqsceNrksr0+4aZ9CsFSGcRQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(6666004)(7696005)(508600001)(426003)(36756003)(8936002)(316002)(83380400001)(47076005)(4326008)(1076003)(356005)(2906002)(5660300002)(186003)(336012)(54906003)(36860700001)(86362001)(82310400004)(2616005)(70206006)(8676002)(40460700001)(81166007)(26005)(70586007)(107886003)(110136005)(36900700001)(505234007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2022 08:13:05.6046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d90f895-694e-4d01-b37f-08d9cdc7b452
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited Fixes commit introduced a memory leak when running kTLS
traffic (with/without hardware offloads).
I'm running nginx on the server side and wrk on the client side and get
the following:

  unreferenced object 0xffff8881935e9b80 (size 224):
  comm "softirq", pid 0, jiffies 4294903611 (age 43.204s)
  hex dump (first 32 bytes):
    80 9b d0 36 81 88 ff ff 00 00 00 00 00 00 00 00  ...6............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000efe2a999>] build_skb+0x1f/0x170
    [<00000000ef521785>] mlx5e_skb_from_cqe_mpwrq_linear+0x2bc/0x610 [mlx5_core]
    [<00000000945d0ffe>] mlx5e_handle_rx_cqe_mpwrq+0x264/0x9e0 [mlx5_core]
    [<00000000cb675b06>] mlx5e_poll_rx_cq+0x3ad/0x17a0 [mlx5_core]
    [<0000000018aac6a9>] mlx5e_napi_poll+0x28c/0x1b60 [mlx5_core]
    [<000000001f3369d1>] __napi_poll+0x9f/0x560
    [<00000000cfa11f72>] net_rx_action+0x357/0xa60
    [<000000008653b8d7>] __do_softirq+0x282/0x94e
    [<00000000644923c6>] __irq_exit_rcu+0x11f/0x170
    [<00000000d4085f8f>] irq_exit_rcu+0xa/0x20
    [<00000000d412fef4>] common_interrupt+0x7d/0xa0
    [<00000000bfb0cebc>] asm_common_interrupt+0x1e/0x40
    [<00000000d80d0890>] default_idle+0x53/0x70
    [<00000000f2b9780e>] default_idle_call+0x8c/0xd0
    [<00000000c7659e15>] do_idle+0x394/0x450

I'm not familiar with these areas of the code, but I've added this
sk_defer_free_flush() to tls_sw_recvmsg() based on a hunch and it
resolved the issue.

Eric, do you think this is the correct fix? Maybe we're missing a call
to sk_defer_free_flush() in other places as well?

Thanks!

Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/tls/tls_sw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 3f271e29812f..95e774f1b91f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1990,6 +1990,7 @@ int tls_sw_recvmsg(struct sock *sk,
 
 end:
 	release_sock(sk);
+	sk_defer_free_flush(sk);
 	if (psock)
 		sk_psock_put(sk, psock);
 	return copied ? : err;
-- 
2.25.1

