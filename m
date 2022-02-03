Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E354A8883
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352189AbiBCQUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:20:55 -0500
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:16357
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244826AbiBCQUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 11:20:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXIneyjTXyYU/1+tQ/8vFhIfzOyYj0c0BXeEyjhdPBRhjSALY39EfEMoUUtCzG8sW+wU1FDUDYLViKmvbWKlOXWp3KuuxxSjX3AwhOzkt99xVX+JQBsbK9TZOINVmUYnjcwIUj+RNJRL6Bf2nCKYvmBFjiWPnBGjsLDl4X1gd4/1aMEhF8L+lf2kZOnc6vSBCwba5uIb34XStirImdkocM88LaCMBCjUeD6tban0VX1H5rY80D2JfBckZzCVePXsgG7ErfEVY/Ucf5h6P4A3KQ6lDSvPzBB6oi2DkNBuj4yJb2zNae6uCUadRyXi3Bjc/db2tR3XFiuF1Ul3rOs+Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAk2Tm7zXlRiSvIUg4pWT3wMAM3j3Z/A+Xw1ELl0xhk=;
 b=MV6tz0pch/zR/fwev82b6f1ecRKx26lcxYCq5xyAmMmBxX2qJgQng8sp4Yxhd0B4rGNGPu0N5zg5gPRUw8io2VYzFf5jl0UrKD4lh1j3p6zTsrEbq50OXuPI8j1EJ25RlgMkrSBkoy4MeiIbkvJQnjk8ysWFwDUy8X4d949591ts0kNhUbVR+MXoV13MRP8P10ZCxMXqxRwMD7u3YoCaPe0BPGEH3VQNHfNNoNL22bwlJGg+ucwdFKZfl05MWfcci6BJW0Ov+D1WN/gJmG9uu6nvQotb+DpvUEMJiBYwrXhYEpCJC+aJix7SDutz+BRxY26dDuQDwfpHZjXZ7Aa/tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAk2Tm7zXlRiSvIUg4pWT3wMAM3j3Z/A+Xw1ELl0xhk=;
 b=U3g4P143qZQKsUupT97K64CQZoXB+WqpBTD+ykvcmyVnWaHMlk1IGoFMweziPFCtU3CK/g4rxzR1KtUq6vjjCwkLvMX8mqPCwMej1NSqnHQeV4cd7m+Pn/HhAxlM7nHiD2IPWErQ4s/0Pu4ClT+bsESjqoMLh4l4tL4AXILrJ3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by VE1PR04MB6478.eurprd04.prod.outlook.com (2603:10a6:803:12a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 16:20:49 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%5]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 16:20:49 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sebastien.laveze@oss.nxp.com, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net] net: stmmac: ensure PTP time register reads are consistent
Date:   Thu,  3 Feb 2022 17:00:25 +0100
Message-Id: <20220203160025.750632-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0029.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::42) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d63f43d-5d08-48d2-94df-08d9e73123dc
X-MS-TrafficTypeDiagnostic: VE1PR04MB6478:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6478B83AD0054A2C2E7BBACED2289@VE1PR04MB6478.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5YU5UoTHy0CZKc7F7s+Ix+gRPcmxUaH++3duTlb6LLq6XmyKhIGeVd68NrOmz9BS9+yTUZjzkB8mhAqaqAVvFsLrK2Sbk/Ua7xmJrOX+F2QoVhT2aQPBGoLsgwFy+6+RTIpQLywUCxDJBqXNUl7E07tn/N3ZE6b90xz8BowgtzgchXWATRLuKlpoppoXnFsg79bJXN7dNuTOHFjMXyNtA6+ynON/u8yrhQUbSLm87DpkwJjG+1+At/eYdmG4XT1ohaneo1wcOV5yjjbEa7dMs/j52CDzn6doY/AFZXbYLLct3FGsN2egzo3GS5s+3j/IW5WoWDYJJEmpWIT9bvbbskSVk53z9ygqrDmOfBPOyWcDFO6glpangdsBDIiOb++xoiwjH68uG2825qUA3LqIQlmrwD9HQVCPNV7OBhsD7AtZW99fgLGdZoKaecNivz90ZnhPfz/kbvM5wkuujZgfeDzwMi+/W8ebq1jmw1KXjRvFa6F3c7ooqBHG2BmLPvdPv9VNP9zUxNx+2RcM/VYdm4ryBOdTAWta8xSPYjcLgjojVHWX9WUw4m6fRuxerf26f+KIiNxnR4hXzHnoWouzwh3BMdZ8Jgoq1FlgKAdEMKFk8MhMXadUc3dBrAL2kwjKkKroWoWYS215cL8OIjMYVRa2kQYxdaDPA3E/cKXVTdjkcWN0qFCyEQCDXNuZDvfSP7zKlFAJ9x7BFXQO/m4ZEAY6arwJif+CFKgA+Phl+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6666004)(52116002)(2616005)(186003)(508600001)(1076003)(6486002)(6512007)(6506007)(38350700002)(38100700002)(86362001)(921005)(110136005)(316002)(66946007)(26005)(5660300002)(44832011)(8936002)(8676002)(66476007)(7416002)(66556008)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iYmU3qdgP14WEYIS6c7ehn4U1NgmvWcaJiCsTfEkp4tX5nYnt0g+A3c6gAS8?=
 =?us-ascii?Q?KCN2hfOAagfY0+rtfxHUYecYw9qwIbLLWcF2J/3EWgIllDjBB8Zm1SUxTYfy?=
 =?us-ascii?Q?NiCulX7rH/vX7QhQnSwd1FRVfUMhguQrdftoE1y+N3ZI3KrD50Op5VsunTbM?=
 =?us-ascii?Q?DOvgOMDfpfUO2Cks+rFUL1ovHn6nnSQaBZR3ATlIsyR1lUp5/IS1zeSzgFSJ?=
 =?us-ascii?Q?sjB6/kbkNx2YcW4XahRgJgFBeDQFf3Eac8G72QZSPNxT3u5sptGLntHkMWV+?=
 =?us-ascii?Q?4fZwVgih0oDgxummMrHTQIn+2vMdc+OIA1x8dBEU7sKqBECCrfhebktWs3py?=
 =?us-ascii?Q?uSLJ6+BgbTz4S/UJL44CoCKXp07C3vCGrB28drOq8jlF8mGHSt1YM2aui+jL?=
 =?us-ascii?Q?GYe4Xsm0cbRZIsNyVWn+/rhgIbirW812+bztbaUM2gxrmU4qYqAZcdNc4Ytl?=
 =?us-ascii?Q?3Gu/xVObNkZ/v6pO+KREWexZfTyijWkg2cLP2y/g1iDbvMUhrNkRII708Ril?=
 =?us-ascii?Q?f/0BrhqQw3884PRhf74FcvOCtRZ6tSJHFMqxdqfxlDJy2ddGYgaWgu1xlYOH?=
 =?us-ascii?Q?hdUvam3yv/koqL3vmYkJdtMPj/7IU0Z3bLillsAwzUKe0ifmI/67qlaqMMEs?=
 =?us-ascii?Q?eElnm0nv2nEUzMiWnyApunHD08f3BQ1HrkLYTON5AbPb80StK3hgUqkZApWQ?=
 =?us-ascii?Q?XHsKrU5hzcbi4tVBS+mlQKSAFkFZEri+gh1PEn18aHFWN6lZ1BbtwNfXkee7?=
 =?us-ascii?Q?etYYpM4MRtw1VBwCLomc8aOa/5csGsA2NiOhehaTvuHrMghvoL/zJfPXM+oj?=
 =?us-ascii?Q?RyY/bQXEVmmGD6SW6NcYe5YbZ++EU/sMvFy5I1kqc/pQpSeEEGASfAfCeoNt?=
 =?us-ascii?Q?ThoCtKjJPEzFtFUWjvRiPk+uoq7eHHSdklJUsxRoZxovHKCQxYhPsEPwWfIX?=
 =?us-ascii?Q?Js4FFHZ9JFGFbK8Oh1+S1vvU5yS22zmNqedvp3g4VfoLT5VStgNAx+0wtSWZ?=
 =?us-ascii?Q?gTUbEqaiLJUKiS3SPGIFhsfXzRHVL+7EOfeRfmzTWQIn+1H++RUsgERL/63I?=
 =?us-ascii?Q?k2Eq+jdo905VQLrfhQsRZfMHI/8GtuSWxv1st0S98ROQRWUIFk07x7xYEnWt?=
 =?us-ascii?Q?CmkPBq92Z4HeMcx6NnHBitz0VA3fb4d9YGnJMcH55Dkg5tbpZYWu6HAcd7Pw?=
 =?us-ascii?Q?AuVWJl8JAyhcFjNVPcPrgdAmbHJJ1l/wBwE/Uf1NZTxvSvR+Nz4+qy2YZJf2?=
 =?us-ascii?Q?Ppk6uzFXGMj3dZpY7EVkmnI1x7iz6Ml3lgT4ikIHt9bA/9tETS5N3tzHB7xU?=
 =?us-ascii?Q?rPFCyJJP3Wtk9GKDL88ZN55qEw8gbBt9HOhaEnpGZhXoo7nSJoQhKS4b7yOz?=
 =?us-ascii?Q?ZHQXKfhuhf0XcdAeyqZKPCVVwx/j8wBupnKDhDEGCptJB1EfRYSwdJxW85N6?=
 =?us-ascii?Q?KorX7iCqfun5LRTq+0EcxE2+KHX2oKjpuJ7eeY3b9Cr++pl+9FCRGNYWHfVg?=
 =?us-ascii?Q?F6Dpnt2WB8WE6OPbHM6MKJeHyg5yHOfcpyesAW8E2t712YRHczXCYd54M40d?=
 =?us-ascii?Q?EqLZDxn7vEAvNlTVUKB0RjXBq+ghMZ1CLNc/anjpd01XN3jE9FsPGX094ipN?=
 =?us-ascii?Q?JbXB6imOGmXBbIjbuZq3/jI=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d63f43d-5d08-48d2-94df-08d9e73123dc
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 16:20:49.3051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWaNPziVmmCdxg6tmctEokIOilcsvRlOv64xipi/OZjO9nLe1ts0s7/hwMSefe4xqKcwOLFTrMknRauclUwFYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

Even if protected from preemption and interrupts, a small time window
remains when the 2 register reads could return inconsistent values,
each time the "seconds" register changes. This could lead to an about
1-second error in the reported time.

Add logic to ensure the "seconds" and "nanoseconds" values are consistent.

Fixes: 92ba6888510c ("stmmac: add the support for PTP hw clock driver")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 074e2cdfb0fa..a7ec9f4d46ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -145,15 +145,20 @@ static int adjust_systime(void __iomem *ioaddr, u32 sec, u32 nsec,
 
 static void get_systime(void __iomem *ioaddr, u64 *systime)
 {
-	u64 ns;
-
-	/* Get the TSSS value */
-	ns = readl(ioaddr + PTP_STNSR);
-	/* Get the TSS and convert sec time value to nanosecond */
-	ns += readl(ioaddr + PTP_STSR) * 1000000000ULL;
+	u64 ns, sec0, sec1;
+
+	/* Get the TSS value */
+	sec1 = readl_relaxed(ioaddr + PTP_STSR);
+	do {
+		sec0 = sec1;
+		/* Get the TSSS value */
+		ns = readl_relaxed(ioaddr + PTP_STNSR);
+		/* Get the TSS value */
+		sec1 = readl_relaxed(ioaddr + PTP_STSR);
+	} while (sec0 != sec1);
 
 	if (systime)
-		*systime = ns;
+		*systime = ns + (sec1 * 1000000000ULL);
 }
 
 static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
-- 
2.25.1

