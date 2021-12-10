Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD4F470B2F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243533AbhLJUAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:40 -0500
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:17409
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243387AbhLJUAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:00:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KP3K+7+GYxSTy8L6eumKQq0N96KJ0e/fTewEaHCem4Fahto3K3UWy2xd8kdl/oCliQ4kIqXqLCWiMWwXF7hT3K487Pe/MXnrgWQocyXyPWt3LNhHBIyMqJIA2YgAnTD57muEsCsJ3hKNqNbe4YWa9A5Jm8rRhR1eM3DkTJQVBYZoZV+Z3QK8wP4KJnrGw00RNdDFjUUzQb0ogc5pjgqDsuyiE9AtHNDt0NPefgEomlGDgjR49pRJPw4XsbRyD91qCgDQvSa2BJON13/pVEjubnRaDrJvw38EiimFPKtdHQqRdi6m+qEjGxUFG4aopwxZkwHlkmfJFjwbQocX+SEb7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ll0NpqBhyMYSxfad/ZPtqYdVsQQTgZY55WQtDBbPeGo=;
 b=TqZgmj+pQfoP23EiluSItnX1kq6Oix9ZnQatEK29Sreduu5inJkKUjMrIaJLh/+DBD0NY7GFbEbAK70f38/kjn7V65h4Xj4fNTC5lJNeu0sE84OWFKv9FLT87yRolLp6t4n6K8Dc5TyKbrfVJP8U1mycEx+lgciCMF/7swFBBwHi6lAsn3TByyz9/YuGhkT792vtHZ/koifKipuwLGOc8oQJ4lhUtmkyNR2ccq2PnVysu7Ma5xZZDIb0WUIvAT/1Y7qirhCdYhzkQ8cN6ZrwGidVWtzzKzJf+1Ep3tiYgOG1CNsc6VFr9WCxQI7ieFP2ReMjiyJHzNdFhJwwsKYD1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ll0NpqBhyMYSxfad/ZPtqYdVsQQTgZY55WQtDBbPeGo=;
 b=eAfGq7DSIQrKX2nT/Ixa/2/C82Wcpomv+XUgg+Bq3eGDbF4F/y27MIbw7DfJIMEde9nScUnU1/RYM5tFworqyAW85A9fRxlQJqfhA/XZSsYop6cj8M+7eeVwCRE/qgNMV2c/hodBUkh9BFCg4h9n+BWzfz0GEjQ1pb9mafdahCY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8887.eurprd04.prod.outlook.com (2603:10a6:10:2e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 19:56:51 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%6]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 19:56:50 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [RFC net-next 4/4] net: stmmac: remove unnecessary locking around PTP clock reads
Date:   Fri, 10 Dec 2021 20:35:56 +0100
Message-Id: <20211210193556.1349090-5-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
References: <20211210193556.1349090-1-yannick.vignon@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0153.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::20) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR02CA0153.eurprd02.prod.outlook.com (2603:10a6:20b:28d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 19:56:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f23ea2c7-fa2d-4deb-4da4-08d9bc1734e0
X-MS-TrafficTypeDiagnostic: DU2PR04MB8887:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB888759816AC62C61500FC91CD2719@DU2PR04MB8887.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HLzHEZkkCTCGC1AK/4KEAZ4poOA+Y/1rS1d8N5waMa/feGF1OCaFi3658iamulOsb2m8H/JbrUv6Q+cZs5s+ELLz78elMGSdhaWX1PWCY/B+0ucSOY90MSlwS5s4miDEVXmNXWgZdbdQp3nMQispbZiI6zIxF9Mf12T0pidTli94vFh234aVgyxEyYNAH6sHaq66ekafxEhV3MZswSq8d1hgtH7L9M4HQAoNdz4YSqYM8tUpMIIKobPYttJi5QgtjVwBKdQ/B0dPnsSd1y1PF6Q3azyjI5FAOBMSHeDFzg1j9XN3DEYJ4NfGCr5kjdOyPsCr9qISKNHofyPbhcHBq4+wUnHFQ5yyxNwlZXs0JqMJTn0o8gKLDVuEcfh0//mgZctZLr3pPfcKtGqlh1t+iNiDDw2rBE+19ToIZeA8T9MevDRc3kNG6XfABit/i0nzCtCBM7CF0eLIaTp0+MDrIR7q1J0W1++KYL//K+9UDRCBLY0i033mQBWvDqPoVNaKzmpfKlztJE/C/9PYGne7Sjier94nzEgAOqm5xR2ZHL0i5aEl4Si0SQ8OtV9urZOsgIAJtWJIwMCGIUIjcdrr92PfgrZps5/IbymuTxVuooS1DHiPlA8LTmJZ8BqeJjOZ7EJfyFzSHiBHaGz63gXikJLijoAY0Z5JPYmO4Anu+4l1KQIT29YmwHelWke/hKwBiM64vOeLUvi3xyIT9W7fHRfUYBpEEWyKrotRyZHI1qg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(44832011)(316002)(186003)(6512007)(110136005)(921005)(38100700002)(1076003)(6506007)(8676002)(5660300002)(8936002)(6666004)(66476007)(52116002)(83380400001)(66556008)(66946007)(86362001)(508600001)(6486002)(26005)(2906002)(2616005)(7416002)(38350700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oFDiUOZTcw7c0zjJ4FH1zdve4kMEy0KU4hyY5caLkl10vw6gK7ME5Rro22CT?=
 =?us-ascii?Q?4cW/HAqeuQIVasooaqNeOvsvudObtDU2/zhve59ck81Q/0OhFSLOhr5l+TcI?=
 =?us-ascii?Q?XUq9Vm3Hn6Q2X8lSwzRgvdLD+0owChW3hc1+etf3Q10F4USVm+5nhfuVe29i?=
 =?us-ascii?Q?FbFEBILweNRDfuXdnGI7TQinF+dOmowkGQ+M0UUGqRhPoSv9ovxpkI8/YgOp?=
 =?us-ascii?Q?x+xuDaNuea6LoMR9oGngayxcWlsoy/HyRFjB5uEnYSPN80fnY769FuAFQFIJ?=
 =?us-ascii?Q?pZidNgWLfkrZWQMTDxkjtk7WdocujDWZ61IvOGEaSj+UwanunUgD/VhdAQlz?=
 =?us-ascii?Q?tYejbfDcVe9UydCw0mHtSnOxuUaWdrQga+YgG6VOTXZ1WUiN/hPKcyzCjcJH?=
 =?us-ascii?Q?PWWv6CpYuYaU81OMjoFIPyzE7DHXCIBw6VSUErY1pHOXOHSP4YwOr0yEBRit?=
 =?us-ascii?Q?0Ccz+sam1+Wqw2ALPOLFNfcfrgmp1cF106cL4v3O7JtTVsWw3cbLgRHzA8CC?=
 =?us-ascii?Q?yPqs5fjYl1GcsdflxtvTaBnXj/1rMU80NdQyXooigVrikMCIy6Rt9b/naPhb?=
 =?us-ascii?Q?H5RdSF/Ai3STXaENYVO//msWpxHREM8hiltxDhoNvXMlvPrTw6cRTacCOZbQ?=
 =?us-ascii?Q?PKbMX1L3js2gOchs0bpFtuZceZepqpzqYX1dsgBAJPrm6ZRiP9HJOufJCPR2?=
 =?us-ascii?Q?k4mx5TTk3TffPw/rGM2vwcF3B9aKa8Q8XHHE8aPsUQE/GCFB1ezH4f08hI0B?=
 =?us-ascii?Q?PD0J24dxfkQGgExV+XO3oaIs9vFTJATMR1SbYeVk0k7BLVQXUKJBclgLg36c?=
 =?us-ascii?Q?DTynJrfX2eClC8NDvBm0mzx8UT3tcBjpV3JKe32Mbs992z/x20bmAx7D3AtS?=
 =?us-ascii?Q?qhQ3MVj/aBb6qwoltjWFiy1WQTq2N1f8IWSCbHzoAHuEvYURVDnQbvOkvWfc?=
 =?us-ascii?Q?5dm8j7/1jsUTqiiBKTTBrqKUJPkcRMruLXI4X8rBLReuffsEtOMBNgpNKHAD?=
 =?us-ascii?Q?O0I/EkOsyBhf85DQuXyBivO2WW7DONOnDdMq5B6oHVQm3elZmRq1l6l8QSvs?=
 =?us-ascii?Q?MtHFkNb2Lt3Xi53ftTtdmXN9+uxdcJZmd12oH3699n4Mx/UEjhj4v1sTrty7?=
 =?us-ascii?Q?iZLVBUio07y5X8wBPbsrHfREfrGSL3Rt8/ziePgFxcq0PBnytM0zVEXXPQcp?=
 =?us-ascii?Q?muyTqeYvOc5BxtJz1uGlUokvRFBrXQDMVzfaLcKFgbdgMgp497OW/UuB4b3m?=
 =?us-ascii?Q?bZI8OUGpVYbPUsgAsg8RUPvecye8yq2XVR1BhlNuOPuOnvCK2il8fC49D+Bk?=
 =?us-ascii?Q?0gph0ZaKOu/AGm2DOUpWHLEBaVNRGbxrMoPr5rMcDhOcCAMy4XV7xWPaDV3S?=
 =?us-ascii?Q?li5mCmDB1QZr8pIw8Zfz6UWiIBD2j9fSizEDE9Kt1shHCQt8Vf7FC+a6sjWE?=
 =?us-ascii?Q?UnMVknRgp031KPjk0oGAV2ypHDW8M2N13GHKYeMvdwSR0bq5FL6Kupiqaj0h?=
 =?us-ascii?Q?9hi8+96QMByWX17mMler4+Z88tZBLPlvKlMmkeODC2Ngk7kxj+7Ez4SN8B/l?=
 =?us-ascii?Q?/qng9javfyj3COFvhCC9HEVD74xL6tEEgC6boFuQ15cPuNhc+LJxElMpddNn?=
 =?us-ascii?Q?7hnuXCeVQi61fehTzvm2/J4=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f23ea2c7-fa2d-4deb-4da4-08d9bc1734e0
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 19:56:50.8195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKf9PCvgTxcIwphpP74myq0VNbBkAaiLqPHLHzk4Q2bmIMJQkPzNgCEf8T6pS2eRlw0gOE7w1QnyPnbPKs5uXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

Reading the PTP clock is a simple operation requiring only 2 register reads,
while the time can be set atomically through another set of registers. Under
a PREEMPT_RT kernel, protecting the reads by a spin_lock is
counter-productive:
 * if the task is preempted in-between the 2 reads, the return time value
could become inconsistent,
 * if the 2nd task preempting the 1st has a higher prio but needs to
read time as well, it will require 2 costly context switches, which
will pretty much always be more costly than disabling preemption with a real
spin_lock.

Remove the unneeded locking around the gettime call.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 580cc035536b..8f0dcac23b1e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -137,9 +137,7 @@ static int stmmac_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	unsigned long flags;
 	u64 ns = 0;
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_get_systime(priv, priv->ptpaddr, &ns);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	*ts = ns_to_timespec64(ns);
 
-- 
2.25.1

