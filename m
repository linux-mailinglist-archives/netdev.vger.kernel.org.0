Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C090849DDC3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbiA0JUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:20:39 -0500
Received: from mail-mw2nam08on2086.outbound.protection.outlook.com ([40.107.101.86]:6689
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234708AbiA0JUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:20:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKaFiHAASy+iQ+Lea+X1gQ4PjbVaPQrUcCGiJlm0YoYYpffOh4LoZVOpV3KJJ2JJvEiWXEBYCYaagcMCDIjzDcXhIAa8I/K0hU25EcoYgzSmeJgLJDM5ndpHt6rSv35r32uXwxvVFCGvfItzXUFHgcEHX3MoMIFNeJajD1hKKNEH1BSir9Q/FEty+Od728uWSOteqR2j7uxzsfAgLFumCtTQ3CGB9f3ZkopM1rQaaY38zMp1GwjYHbQKoxSHrku+g9X8Rs8E3c03Xn1CHT9kWuGxCzyxANG/iVke30OsXQFOEiKQRk295obdh/6uWJK4R9b2M/fzJAxoN/+WUTpu0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0ky5EgiZ/a1gh0fXQ9+oEcRSv3cPGhfjl4f/5BKENI=;
 b=KvL7twlZKHN1q17U+cIvC0SqUoFySVZW1GatJogRVTpDcudXoz50KS+7RMi78rlODWcB6zyLec1WhYxvbeAKZ5daqG2udn4RaydjSAF0Tiv0IKUa9mmQtXZXau6Q7aR4anUKmiI9fsaCNajKqePrVFYUS5zppnoU4MMBeW2ZQhTVX8l7Z+mliyxXl13U+raZHEsMC3lOVvRPhykAsC62R5KR+n9sTG8lQpfNu0l8Lu0tJlaIL4H+d3eMr6AEu2ykUPYkzBs7Vqflh5A8W6jFTHSlKPS7YrPWuyO/FOnl1E9LKiv7oQpx1Z63Ap2gLiE6Nk2UU0m87mhgZnG/NOhqOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0ky5EgiZ/a1gh0fXQ9+oEcRSv3cPGhfjl4f/5BKENI=;
 b=APzWBXzncRff4Bvzx/l4QJsxVCu/QK4pPrMCfD595WMANWghK1mJB2UuIsOYqu7Og8153VzdbtUTqgbyqhSNI8+gVHhhgJfa9XKAZAIA+Be+0Mygwu9R+kncexyeiql5JcZ0kxX71xphajyG3BVpuwBm/4B4NuvGfsqDrskfNZY=
Received: from CO1PR15CA0099.namprd15.prod.outlook.com (2603:10b6:101:21::19)
 by DM5PR1201MB0252.namprd12.prod.outlook.com (2603:10b6:4:5b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 09:20:32 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::c3) by CO1PR15CA0099.outlook.office365.com
 (2603:10b6:101:21::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17 via Frontend
 Transport; Thu, 27 Jan 2022 09:20:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Thu, 27 Jan 2022 09:20:31 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 27 Jan
 2022 03:20:24 -0600
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net] net: amd-xgbe: Fix skb data length underflow
Date:   Thu, 27 Jan 2022 14:50:03 +0530
Message-ID: <20220127092003.2812745-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5257972f-8c6d-420d-ca06-08d9e1764480
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0252:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0252FDF14C9933D3B9635E3B9A219@DM5PR1201MB0252.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6EL0AffHQbi1jMZlkRXMU7NwFcE4865LvCpu5WwT0J5f0E01mjy0wcIHwRLACz70vKlpY9eo2GhTFRxWyvfNY31e97883S0vfStMzwHSRB0WR+HhndYWjtskvyFH5sfLuF5HtFD2HDp0hMk0UCgPr3Jje01ajhvK7nkijkhAV29sOrbzlwft0wvWDFg783CN3AuMev1LybPRbfcZxLkM/NHkBNFsM7hIShAT5U2Zp1P0JArmOiec+ki9eAnoWTmTZ5WoEZYvG02X0N7wLNIlSQrNfCkca7l/zvBK/uZsFnyd2nATLBSbrscO/9/5gjzSMtfh5HE8f1gh/P8JssJeuk3RodLNxcB8N4WOS6A6qhEPKIQbIQBGO/cOfJiVZ0f3EvsloumwBsLgmN/eKj0F3eadJNPNkRH2sCdZzPopqcS+a7U6mJP4Ps1V87nTJ6mfFaXNHvAkqxGWT4Vjiyq0tRYJg3CuPN5RvOA9taC3kHFFvl/ivAjVJBrCjkK4xSrYIoG/cSWZL544cGOLeGTI6toLK0DQaEuQ4SGKCozVFN9GRPhEQmb8HrZX2364tD89/6Wr2mslIcsc4tSMcgxwVSDWA85kulOCm9COOOaDiIHtpmBBa4gRN5awuqlgMvXEKyQNwg4pVaMlttnTUdebkK9h88bCfQJmi27JC4pBJDmcYQfp/LUnb1xqz24Qn+pFtN39zMS9JQ0WZFCCtd8Gg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8936002)(508600001)(8676002)(36860700001)(4326008)(186003)(16526019)(26005)(82310400004)(1076003)(316002)(70586007)(2616005)(356005)(70206006)(81166007)(36756003)(2906002)(336012)(6666004)(110136005)(54906003)(83380400001)(86362001)(5660300002)(7696005)(40460700003)(47076005)(426003)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:20:31.9442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5257972f-8c6d-420d-ca06-08d9e1764480
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There will be BUG_ON() triggered in include/linux/skbuff.h leading to
intermittent kernel panic, when the skb length underflow is detected.

Fix this by dropping the packet if such length underflows are seen
because of inconsistencies in the hardware descriptors.

Fixes: 622c36f143fc ("amd-xgbe: Fix jumbo MTU processing on newer hardware")
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 492ac383f16d..ec3b287e3a71 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2550,6 +2550,14 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 			buf2_len = xgbe_rx_buf2_len(rdata, packet, len);
 			len += buf2_len;
 
+			if (buf2_len > rdata->rx.buf.dma_len) {
+				/* Hardware inconsistency within the descriptors
+				 * that has resulted in a length underflow.
+				 */
+				error = 1;
+				goto skip_data;
+			}
+
 			if (!skb) {
 				skb = xgbe_create_skb(pdata, napi, rdata,
 						      buf1_len);
@@ -2579,8 +2587,10 @@ static int xgbe_rx_poll(struct xgbe_channel *channel, int budget)
 		if (!last || context_next)
 			goto read_again;
 
-		if (!skb)
+		if (!skb || error) {
+			dev_kfree_skb(skb);
 			goto next_packet;
+		}
 
 		/* Be sure we don't exceed the configured MTU */
 		max_len = netdev->mtu + ETH_HLEN;
-- 
2.25.1

