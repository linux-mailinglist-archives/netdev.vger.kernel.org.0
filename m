Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03460691F34
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 13:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjBJMhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 07:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbjBJMhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 07:37:39 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2105.outbound.protection.outlook.com [40.107.6.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EF371016;
        Fri, 10 Feb 2023 04:37:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eq80S7dU0wGsUCh/epCMdxffXsiAFpzuBDJDn6fAzTleXjDrfo3rS/Mn+AKaLovzX/sdsRyH4F8zFdN1lJ8RhwlGgJT657mOjK2B5TnDmdfWmb8Z1HLExUW6cR3CXp3qz/nmJgxXVzuyek7q15/F/eZuVkSSBPPNqRsSNybftzmQewP/kJgT4nazaLg8Td9tMVX0nl1ic//zmlNgCrsLxd09GM+kTbALrRkHFtQq5FitPvxDUSyq5UpPtJXpf0+X6bOkiKmjgHSr3SL3hl2z+ein7zdYDtIUgyEtKWmVGRtTR82AruHiLF1hG0Rdh9ND5VcSlw95B5W9bORoYTaQrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMEAP+Hbix5g5rbROmzp5aeNL1mFBHmfPQv6CQbzv6U=;
 b=acKhZJRBjIzW4XKmnvTUqFqS/7k5gnNDxnZyeYJqupVWZx1COwCiL3acWcfxHzfAG1TqI+WBLAEMszMnt+05uChE5ntPFtzMmWYrGs1aDACumCEZWtEuLuXKYY9auvaoAalqvuYoMlOPvoVsbzWnY7aM9h/C+HqPnJ9Ff5+ERBr8zUPdOb0TAg9Z75hx2i2w1nTduAjwSmRv4tfIwyYB4ZELDZnH7GSiTSIzGUZGpnCnyIlzRdpb/RSB4AMN60ilIGZf685zaKw8AHRVwUuIdf7BuSIzoEq2aD+5a9XWQj8xsKyXjPJgIdqb1SBZ7GmAPY7JggMAjmO8COHX5ASUAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 52.137.61.15) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=sma.de;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=sma.de; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sma.de; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMEAP+Hbix5g5rbROmzp5aeNL1mFBHmfPQv6CQbzv6U=;
 b=oUmWsI5rOo7mvMcUfaVcVrBQOQsXaqCkE7i+J0pIHMO4HRtAIsBuQHhYvx38ZWhLZFIozunwctAeRaUugPYzLwxy92twIvWN827KjkQ5MH9GWkCy+s/LtoWlnRMHC/eKF0vJfn6x2zt3SGoNs6DStA7ezwp+ZrP4S7JT9qh2NNM=
Received: from DB9PR06CA0015.eurprd06.prod.outlook.com (2603:10a6:10:1db::20)
 by DB9PR04MB8348.eurprd04.prod.outlook.com (2603:10a6:10:25c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 12:37:32 +0000
Received: from DB5EUR02FT057.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:10:1db:cafe::77) by DB9PR06CA0015.outlook.office365.com
 (2603:10a6:10:1db::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 12:37:32 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 52.137.61.15)
 smtp.mailfrom=sma.de; dkim=none (message not signed) header.d=none;dmarc=fail
 action=quarantine header.from=sma.de;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning sma.de
 discourages use of 52.137.61.15 as permitted sender)
Received: from mailrelay01.sma.de (52.137.61.15) by
 DB5EUR02FT057.mail.protection.outlook.com (10.13.59.54) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 12:37:32 +0000
Received: from pc6687.sma.de (10.9.11.72) by azwewpexc-1.sma.de (172.26.34.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.20; Fri, 10 Feb
 2023 13:37:31 +0100
From:   Felix Riemann <svc.sw.rte.linux@sma.de>
To:     <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Felix Riemann" <felix.riemann@sma.de>
Subject: [PATCH] net: Fix unwanted sign extension in netdev_stats_to_stats64()
Date:   Fri, 10 Feb 2023 13:36:44 +0100
Message-ID: <20230210123644.489-1-svc.sw.rte.linux@sma.de>
X-Mailer: git-send-email 2.35.3
Reply-To: Felix Riemann <felix.riemann@sma.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.9.11.72]
X-ClientProxiedBy: azwewpexc-2.sma.de (172.26.34.10) To azwewpexc-1.sma.de
 (172.26.34.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB5EUR02FT057:EE_|DB9PR04MB8348:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a34143c-ec34-4988-c507-08db0b639499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxqlPKyErf7TTxJK1/9V7iEgFheIpBtxPaue9+TDPtazIuXxQLv3AvvoD/UUJ47gur82aoQI7bIut1VRQY2UKXqHNm0qTMuLBdMmYQxe5EQU/mdLP1fhl5TkqAVVJXT1roemxp9PTCHtTrf70ifa7BE6q7EER1rdxzWdgu5WzBFXtB0qJJ3APXQXcdoNYeu2C9+KAGF66kNvX738U9XDa4BcB6PmVbK0JgM/WrJRnDjaFDvAblY13yTiPxgUTt3mz2h88BixzFTr0L2AV80bBr6mlImRE1XG68jBVk4PqmXqjZ0eq8d3rYcWsDRq59JXI1N7eM/ZtMEjqlcqFsbI64xNtORSING3wTyF0WcftbcBM8P3qu+0KES9RMDPJsIvttEvVmESGHEN92Y68KF6JOylEanfVtZDVA+imF9LcGPW1ummTGlVeEuAeLhCAeVbwSFW7+dxfepq7CaMQoon1qnAjq68cCcm2sAMg5OFdCKfiJBLwiSkHDrAikOFJSqXo5dn6sZcRNiniBcrW9j+0vkNS6ZfMf2i2WrjYeC38nXIGbCP+asUSFdhcrmdrEiEczHyCJRz6+/oVIY5ZPRq650F8QdvYMpyjMBxJXpr6cYmDcW4lfvA31aUEI/4EAnZNe9mNVXaaFjH4fRGkPVipkYt7kLSahLjBFCE5C8GP5tUEfM26i5y5u2SKVawlei8srwsxQC/LLzwvoTL0TCpd/dO4EE+P2GNTMKN+3LOv2Y=
X-Forefront-Antispam-Report: CIP:52.137.61.15;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay01.sma.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199018)(36840700001)(46966006)(2906002)(81166007)(41300700001)(5660300002)(8936002)(356005)(6666004)(2616005)(316002)(186003)(16526019)(82740400003)(26005)(1076003)(86362001)(426003)(6916009)(83380400001)(4326008)(7696005)(47076005)(82310400005)(54906003)(8676002)(36756003)(70206006)(336012)(36860700001)(70586007)(478600001)(103116003)(40480700001)(26123001)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: sma.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 12:37:32.5361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a34143c-ec34-4988-c507-08db0b639499
X-MS-Exchange-CrossTenant-Id: a059b96c-2829-4d11-8837-4cc1ff84735d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a059b96c-2829-4d11-8837-4cc1ff84735d;Ip=[52.137.61.15];Helo=[mailrelay01.sma.de]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR02FT057.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8348
X-Spam-Status: No, score=-0.5 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Riemann <felix.riemann@sma.de>

When converting net_device_stats to rtnl_link_stats64 sign extension
is triggered on ILP32 machines as 6c1c509778 changed the previous
"ulong -> u64" conversion to "long -> u64" by accessing the
net_device_stats fields through a (signed) atomic_long_t.

This causes for example the received bytes counter to jump to 16EiB after
having received 2^31 bytes. Casting the atomic value to "unsigned long"
beforehand converting it into u64 avoids this.

Fixes: 6c1c5097781f ("net: add atomic_long_t to net_device_stats fields")
Signed-off-by: Felix Riemann <felix.riemann@sma.de>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b76fb37b381e..ea0a7bac1e5c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10375,7 +10375,7 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 
 	BUILD_BUG_ON(n > sizeof(*stats64) / sizeof(u64));
 	for (i = 0; i < n; i++)
-		dst[i] = atomic_long_read(&src[i]);
+		dst[i] = (unsigned long)atomic_long_read(&src[i]);
 	/* zero out counters that only exist in rtnl_link_stats64 */
 	memset((char *)stats64 + n * sizeof(u64), 0,
 	       sizeof(*stats64) - n * sizeof(u64));
-- 
2.35.3

