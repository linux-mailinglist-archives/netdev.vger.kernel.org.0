Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB549FF86
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350369AbiA1RYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:24:13 -0500
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:49080
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350978AbiA1RXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 12:23:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMzJWmsPADc5iM3WA81ps1QYT5RYRdC2BL2B25pDuESE5BecS/xOdui12ZTgJmd0tEkbm7KXr2B8qY2sLqVBAbQoKUHp9z2CN05rWJR451/1FSWFbWcjU7esvaPfar2p5Qre2YMgkq1zMhtGM3ZLQFqk965O00ONnrcL/XfFAtaMSOLKl8iu+LNb6h50NbaJ/bRLcovOTzZT0ILqTd9GBCZCCpEuxDw2EAtbTMeA3kuajUNdh70xIczy+a2jCC06gGY2FDvjVcQRQdj+3vxyuEMC/juO/2DJ648z/44xY2/ndCsoMmzj0s3gdhTJzunBJvK9pqPn7fVgQYHm1Tiwrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMsSkCBB7WP0fpZquBxlXaOuXAy4OI1VdNfuaVcnvjs=;
 b=DdTI8rY23GoAfFvOZjqOEmMalK9TzVYFd76lNcnmLDTe1XDJECn8gqA9VF8gku6+gFElUkQJWF0I6X4ca9zXvwmsHBnn9d8G3Pndee5Hp9cXIVSaxuVReXo4tVofmVetiyNqzYBuWLkkw8F2KoiMDA6O+ZsQvLM0j1TlVRnmyWX/prk3X92QTjAxNUU0BgzVYVvfQ6pOGnTfI6jcyHXGZjqyfbUSn7H6CD3VB8wwEy60uBUND62h09niKor82XIq0g4vvIRPlYZLFM7Ikgeg7Ja1uR6ldgluN9VkLr7EFrklfmZu/FGgWAct2CYyDcjmu0Gx9ZdKFNg1Af7BbgabFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMsSkCBB7WP0fpZquBxlXaOuXAy4OI1VdNfuaVcnvjs=;
 b=hfkPCmy0AKJ+srdNLScztforl5empQ4ehZ9OE6APHoFpJSe3yxoRNtf2pOxzkzqU/FSvE18MaAXGmjwVkz+bFwoJ2LMxNLOg6j3LV+RfYEiA3pJe/9LAxwsfb54VIhMEcpWYwgnKojv5cfB6e3D2JKbOdqNZFWT7q6nbJLnPa38=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DB8PR04MB6457.eurprd04.prod.outlook.com (2603:10a6:10:104::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Fri, 28 Jan
 2022 17:23:27 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%6]) with mapi id 15.20.4930.017; Fri, 28 Jan 2022
 17:23:27 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net-next] net: stmmac: optimize locking around PTP clock reads
Date:   Fri, 28 Jan 2022 18:02:57 +0100
Message-Id: <20220128170257.42094-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0069.eurprd03.prod.outlook.com
 (2603:10a6:207:5::27) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e966e8d-fd48-4e57-aecf-08d9e282e56f
X-MS-TrafficTypeDiagnostic: DB8PR04MB6457:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB64575C8EE9DF9443EBF65879D2229@DB8PR04MB6457.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/dTEYDoAtRRdLxqgCZG+6MhV3wXYzzaOTVYibgAjo/6CILWIJnjS++ifTlAPuT+CiKWPQCk8TXxgm0uP9plAwc7Pe9ec+lrnD9V1HAMEumZd1behsk9am7HAQBSdK2jS2Wp+dPiXMTJ4jZixySCm5i3LxiLDKXJaRzazip+wiwxUTkK6TwePrfl5HUhoQitEpq4P410eKhaEFyVHgXSsOfH+J2wdQMOQyLhU8v5tC0OescmkzeHaKScFSopWTiLABB/QZ+tkY7cMv7XEmbgQ/WVO6p7Yf53abp/QZGyRyhLh8L+IGnPBXfEXNZ6k0wgVsF6dfdJFqqCPSY2jgK+/oRsr1sDM4AXwnfgnH5hahGldF+UM+XoNQaMFO7eoTGJFMeQgMntxhkMX+4coMnfpOKuA/ASz1GBNNtBCUQ22zwTGkR7nDTZUCaaYbTipmR/sar6Pt2WxvvKu6WeencVwb+jdE1fp+kI57fa1OxBXQ31p9D028g+d5YFOVvEQXCJh8IIhMcn2Cfn5zLyB1VcUVXNo7b3XiFfPBLCgVyoiMqGoI17jqouOD2Z59R8cimncQu9HXpLVH5lXC3bBLcG/obcZ5YQ0he9EOP5Niw+1KpxiAm80xx0rDNTZf+6NZireFVTa39BKtIT2dkTjugTxvqqwPJswTeEM737AQS/SA6w6Yse1M4TZEHwzULzfkoeSCmFRnJu5udU5LM4EBMlTtsKw0xVxjTcZp+GLZ8mMsw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(1076003)(83380400001)(921005)(38350700002)(38100700002)(2616005)(5660300002)(44832011)(8676002)(8936002)(110136005)(66946007)(4326008)(66556008)(66476007)(2906002)(86362001)(6506007)(52116002)(6512007)(508600001)(316002)(6486002)(6666004)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0VEL1CFcTJWgdBZJ5TyI/ENsAZYPOLmMzGWC7w7vN6VST48XngFGXk5lwsL9?=
 =?us-ascii?Q?8LCBkOpHh1qDJFiqIguk0sakGEyj3Bn1FMwxgfLXa6ShK5J2cwvoAJqTeqUJ?=
 =?us-ascii?Q?g50NFvle0XRb2Q+5GImFEVIY4vKkf+zmT0c+0F3XHkJe/yhCZBUFs9oxBL6d?=
 =?us-ascii?Q?kEYFiNAgen6riglsMAkqaSZWhD3skFJeXNzUHXYpmEvsXh660cwPtPdySxr+?=
 =?us-ascii?Q?o/7hb33BNE9GDn9QDqfYqfTw3de/Br/aEada0/cfkZqL6wUSngkZeTv/qw6K?=
 =?us-ascii?Q?PMQ8VO8uWVS21J1o3ANaUE7RWxOMZbNoDLJIbnuqmKYxxc1AH4eKabKSwInJ?=
 =?us-ascii?Q?z2/4BcUGrI0j8xuOSpvNHwf7nkV9Z0rVgxkWKwL1ucqTi+7RZqmtETdEA6/T?=
 =?us-ascii?Q?QO8KQzNMWX/AeuLze2g1+1lM+xGSYY9lPbohPd6FtUOJFOU3V4VsIqahmy7K?=
 =?us-ascii?Q?8QXsf3e7O3JpFoCWZAOZlHfEx9kJuoElQ45o1Dkp5D9oZUZRaNbyf+IyJk0t?=
 =?us-ascii?Q?Gyt8MpBEN8hQMECyCH/peXZW901dhOGe6PuAAul0Nzn0zzy40wy7k71HEiza?=
 =?us-ascii?Q?txxhCOOIoQQ5QBkK29PmSrACDLLvq5vzjGr893xwo+lv4f131dUhy2fz5qYJ?=
 =?us-ascii?Q?QIHnY+lA40Wg2pfqC2T13FjHHwm31JNnOqssDUeuUX308qNMyNmpHPZi40Am?=
 =?us-ascii?Q?VBxOxi3KlM8ZcWHsNDwyS8TjYDCTM3NAUR5WxI35WTKdMC8QS5WtFqmFRqF/?=
 =?us-ascii?Q?YVdURh2V/Ya5g/1Q3xKRrDX4Eidu7xPDyRf1vNTkWdlcepfM0ax9hodh0v4C?=
 =?us-ascii?Q?8pzqS2AoQLB0VVcnIQLV6e95Z4w3jbqLJrVjzEzLvFYiekBcwNjKifXoh6M2?=
 =?us-ascii?Q?76tuqcajC5PtZH8b+ItgvUXeOmTHWbSin8AxExW0Wf/49coFsQlz5mGpXRK8?=
 =?us-ascii?Q?PH2WFVSHDP5y1YCvSmI/FqJWMmf9NtW62JRFcMSvIp11vbOVWKMvp3peoLnU?=
 =?us-ascii?Q?tccMmu/gZjU6G8VJoe2yt24tiHYu7m0+vsKQEwe7SjqNGKEyynI+WTmKce7h?=
 =?us-ascii?Q?ON/eHycpGT3NaygY5rknpPcqCD6b+XatReepeUh4UXHC2YM1hq8NTd1c4TxX?=
 =?us-ascii?Q?/0f5/wzZwgwJnLDub97rZeV4TMSMmoWEBLI43wmZFVV5j4WLcQ5WWrtiuLt+?=
 =?us-ascii?Q?NNymbNvhBe4sx7z6UnRpjJM2Htni0TXvkjzNVxWX/dreC9xGiELP/fdk+kJZ?=
 =?us-ascii?Q?o4+53/Zd/Z1KgkixBvqrpCZ5JnERM4f8HWheMwPHWFMrML7Lb90ptVwM6+Nf?=
 =?us-ascii?Q?L20YdTY0vsS4e8VEMlkOoMQMn/tYtSikQc4i07c2pDrcOkxZQ8ZwJ5tGpdQ8?=
 =?us-ascii?Q?sxC44EQh/E135SjHsUb2XA+IxYsQELlIo0CAupGcznKcTBOCUGnE2zgUssD8?=
 =?us-ascii?Q?JjKhDWYLisnwg+v31NjzXQhyGLWFT5+DYWrmq13vHgWQiEpgXu0/33KOX3yW?=
 =?us-ascii?Q?vJWtNnpFdM7bgh6Q/v3v1TNpPnWDU6anAvBtRjnaDjL7XBhNuUesfxvJj8Ba?=
 =?us-ascii?Q?xJjrPPS9J3UXrbWSevgQ/u2F5Aas4nQousQIeSXCazyNA2nGmWEriVdSkDZP?=
 =?us-ascii?Q?vVgrj0HwaLWiYk9BspXBKQw=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e966e8d-fd48-4e57-aecf-08d9e282e56f
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 17:23:27.3813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUrYPCuz3LpM1qmCrLxX+/DhhAfqBfAsFU+pvJY0ZTBjKxhlmrqaIcLuOpGkuXhK55bB7UmBHdtxr+jBx2fvmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6457
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

Reading the PTP clock is a simple operation requiring only 2 register
reads. Under a PREEMPT_RT kernel, protecting those reads by a spin_lock is
counter-productive:
 * if the task is preempted in-between the 2 reads, the return time value
could become inconsistent,
 * if the 2nd task preempting the 1st has a higher prio but needs to
read time as well, it will require 2 context switches, which will pretty
much always be more costly than just disabling preemption for the duration
of the 2 reads.

Improve the above situation by:
* replacing the PTP spinlock by a rwlock, and using read_lock for PTP
clock reads so simultaneous reads do not block each other,
* protecting the register reads by local_irq_save/local_irq_restore, to
ensure the code is not preempted between the 2 reads, even with PREEMPT_RT.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 +-
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 10 +++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 22 +++++++++----------
 .../stmicro/stmmac/stmmac_selftests.c         |  8 +++----
 5 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 8e8778cfbbad..5943ff9f21c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -383,10 +383,10 @@ static int intel_crosststamp(ktime_t *device,
 
 	/* Repeat until the timestamps are from the FIFO last segment */
 	for (i = 0; i < num_snapshot; i++) {
-		spin_lock_irqsave(&priv->ptp_lock, flags);
+		read_lock_irqsave(&priv->ptp_lock, flags);
 		stmmac_get_ptptime(priv, ptpaddr, &ptp_time);
 		*device = ns_to_ktime(ptp_time);
-		spin_unlock_irqrestore(&priv->ptp_lock, flags);
+		read_unlock_irqrestore(&priv->ptp_lock, flags);
 		get_arttime(priv->mii, intel_priv->mdio_adhoc_addr, &art_time);
 		*system = convert_art_to_tsc(art_time);
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 5b195d5051d6..57970ae2178d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -263,7 +263,7 @@ struct stmmac_priv {
 	u32 adv_ts;
 	int use_riwt;
 	int irq_wake;
-	spinlock_t ptp_lock;
+	rwlock_t ptp_lock;
 	/* Protects auxiliary snapshot registers from concurrent access. */
 	struct mutex aux_ts_lock;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 074e2cdfb0fa..da22b29f8711 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -145,12 +145,15 @@ static int adjust_systime(void __iomem *ioaddr, u32 sec, u32 nsec,
 
 static void get_systime(void __iomem *ioaddr, u64 *systime)
 {
+	unsigned long flags;
 	u64 ns;
 
+	local_irq_save(flags);
 	/* Get the TSSS value */
 	ns = readl(ioaddr + PTP_STNSR);
 	/* Get the TSS and convert sec time value to nanosecond */
 	ns += readl(ioaddr + PTP_STSR) * 1000000000ULL;
+	local_irq_restore(flags);
 
 	if (systime)
 		*systime = ns;
@@ -158,10 +161,13 @@ static void get_systime(void __iomem *ioaddr, u64 *systime)
 
 static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
 {
+	unsigned long flags;
 	u64 ns;
 
+	local_irq_save(flags);
 	ns = readl(ptpaddr + PTP_ATNR);
 	ns += readl(ptpaddr + PTP_ATSR) * NSEC_PER_SEC;
+	local_irq_restore(flags);
 
 	*ptp_time = ns;
 }
@@ -191,9 +197,9 @@ static void timestamp_interrupt(struct stmmac_priv *priv)
 		       GMAC_TIMESTAMP_ATSNS_SHIFT;
 
 	for (i = 0; i < num_snapshot; i++) {
-		spin_lock_irqsave(&priv->ptp_lock, flags);
+		read_lock_irqsave(&priv->ptp_lock, flags);
 		get_ptptime(priv->ptpaddr, &ptp_time);
-		spin_unlock_irqrestore(&priv->ptp_lock, flags);
+		read_unlock_irqrestore(&priv->ptp_lock, flags);
 		event.type = PTP_CLOCK_EXTTS;
 		event.index = 0;
 		event.timestamp = ptp_time;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 1c9f02f9c317..e45fb191d8e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -39,9 +39,9 @@ static int stmmac_adjust_freq(struct ptp_clock_info *ptp, s32 ppb)
 	diff = div_u64(adj, 1000000000ULL);
 	addend = neg_adj ? (addend - diff) : (addend + diff);
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_config_addend(priv, priv->ptpaddr, addend);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	return 0;
 }
@@ -86,9 +86,9 @@ static int stmmac_adjust_time(struct ptp_clock_info *ptp, s64 delta)
 		mutex_unlock(&priv->plat->est->lock);
 	}
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_adjust_systime(priv, priv->ptpaddr, sec, nsec, neg_adj, xmac);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	/* Caculate new basetime and re-configured EST after PTP time adjust. */
 	if (est_rst) {
@@ -137,9 +137,9 @@ static int stmmac_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	unsigned long flags;
 	u64 ns = 0;
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	read_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_get_systime(priv, priv->ptpaddr, &ns);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	read_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -162,9 +162,9 @@ static int stmmac_set_time(struct ptp_clock_info *ptp,
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_init_systime(priv, priv->ptpaddr, ts->tv_sec, ts->tv_nsec);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	return 0;
 }
@@ -194,12 +194,12 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 		cfg->period.tv_sec = rq->perout.period.sec;
 		cfg->period.tv_nsec = rq->perout.period.nsec;
 
-		spin_lock_irqsave(&priv->ptp_lock, flags);
+		write_lock_irqsave(&priv->ptp_lock, flags);
 		ret = stmmac_flex_pps_config(priv, priv->ioaddr,
 					     rq->perout.index, cfg, on,
 					     priv->sub_second_inc,
 					     priv->systime_flags);
-		spin_unlock_irqrestore(&priv->ptp_lock, flags);
+		write_unlock_irqrestore(&priv->ptp_lock, flags);
 		break;
 	case PTP_CLK_REQ_EXTTS:
 		priv->plat->ext_snapshot_en = on;
@@ -314,7 +314,7 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
 	stmmac_ptp_clock_ops.n_ext_ts = priv->dma_cap.aux_snapshot_n;
 
-	spin_lock_init(&priv->ptp_lock);
+	rwlock_init(&priv->ptp_lock);
 	mutex_init(&priv->aux_ts_lock);
 	priv->ptp_clock_ops = stmmac_ptp_clock_ops;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index be3cb63675a5..9f1759593b94 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1777,9 +1777,9 @@ static int stmmac_test_tbs(struct stmmac_priv *priv)
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	read_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_get_systime(priv, priv->ptpaddr, &curr_time);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	read_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	if (!curr_time) {
 		ret = -EOPNOTSUPP;
@@ -1799,9 +1799,9 @@ static int stmmac_test_tbs(struct stmmac_priv *priv)
 		goto fail_disable;
 
 	/* Check if expected time has elapsed */
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	read_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_get_systime(priv, priv->ptpaddr, &curr_time);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	read_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	if ((curr_time - start_time) < STMMAC_TBS_LT_OFFSET)
 		ret = -EINVAL;
-- 
2.25.1

