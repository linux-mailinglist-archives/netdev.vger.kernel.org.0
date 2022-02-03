Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8704A8C2C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353655AbiBCTGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:06:39 -0500
Received: from mail-vi1eur05on2069.outbound.protection.outlook.com ([40.107.21.69]:13793
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244261AbiBCTGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 14:06:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUtTtck3M0/ZKTYpw39C0tRZK3H3CVcrDCWmnZg9cjUNofPNgYIWQHIB4zOmYpqx6cehW82zicMXITL1pTkK9d057tmJfgloaA3W7x3osxM5YYQ/7b3IIiDCx3Y3J49ndM5UGCkj6WaPkcZAqEYiG0Gm1Yk0TQhx5TWCnG/+k5RmSop9joSu76M0/lyV7f7T8X1lb4KPmF+tiKnCl0leGQWmiC4a2g1LBUbJxIKCKzBukhYLOgx4qsa1snfRTo9eNGjQxZpJ0w3i5uaG9eCGDB4E6yrZVlsJhKsWgnqd/AJr9GhQi9wJ1wiR1fdkjo1gfVP/tUbquEdkFyJZnZ8DAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwMz116FrNRLAAoMjPwfPg1k9vajaLJ9snnf0dJLeP0=;
 b=P7HL8ScW0LJjHPDptWAU2e9Y3kWC4a/iftsvCPVcSoPQstcQ4ND5AH6HgsXiCHIZA3TquDRFraNF9pcvI/kALPAtiPTqbmlKOHgT0KumTYIng0ufbRhKJiaQYzgOPgyHYxvYmPSTosFAnaroSpQZwyzQsawXdZtRIyiocDAvaUfKAgeE1yiqYkTquIuGIMkkbybJG+lRD5NvXqN0E/4MWQe/kLbzR5TZd0zlT8+KHV9hu33cfwnt+/pKkUs1qq5W4hiFtmhOcTedZH6sAmcnoa2lH52bReLidV+Nj0V0w5ij8dFBnMuv1f86wAk1nZpMe0NI+JYgKM67rhc6SDr/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwMz116FrNRLAAoMjPwfPg1k9vajaLJ9snnf0dJLeP0=;
 b=TMq8wI573hWOGjcBo4G4BMxrkX7zf0xIyFxutzdJl6AGLnv5KLUG+JMORMxPriJwK0TaMqgz7R1g5gvKOoryvsSGlsA0MPrinrYUh2/zpE8iKnn8k6axsn2UYTvI04HA/rwwkFDhZ9Ih/GelUYl4etDszB7GG3KNrUQr8PJgRTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by VI1PR04MB5408.eurprd04.prod.outlook.com (2603:10a6:803:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 19:06:35 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%5]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 19:06:35 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net-next 2/2] net: stmmac: move to threaded IRQ
Date:   Thu,  3 Feb 2022 19:40:31 +0100
Message-Id: <20220203184031.1074008-2-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0070.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::23) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f71647d-90b8-4522-ee68-08d9e7484c2c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5408:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB540898297A938E80AB8B1353D2289@VI1PR04MB5408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4upHNy/Udttca1h6JHkRTmOApVk3pCi79Q7QSjDOYY7Gf8lpwvROw4UxaF8SRmLmyW9E/IG8niJJzpNR0JpVQb5GFgDz34oPrWPTdIqGaj2XnWxZwDqgkfKrj1KtDx965ZlvUYdWemyRMCk/t2IzLz6ETO/pa8m+cFK7r+aougfBjTeC2kzUAqiX9wQfL/I20HEcJ2uR4vGDPux8wYuliyqezqCU7Kf3DH40Yv2oU8oLdHMhWUgTUvYGKWzMM/GMdSwNoJvZnqavY/wy5TgYgbmtgstJTL6QWtUjKPU4z7ffHXSx31Yd2Bi1U47VUxf3XHP0thh9VKrNOd0d7IAn2oKkgWz8hy5H/AG7ylBqkR7zu40ch6kHvflfJkKG5lx2DLa+K8ZJ4IyFIJCCBh28PRWEnvZSBPKrljcC15NKZNABBsnchsSAouwTC93wa1iJTRD8/U8qMG/rre7NVlQs5/QAMqbZfUZHQ8XZI54dAfxQ0NMfWXkwEWt8GLTgc2cEi41t/IvFiQhVsO6ShFJoC6ywQfnSe2qu6dEtIwvNO5ztXnNYgxaHlsww9ssM4m1RWLAmzN4h+3zygRlPB717o/E6rHa8kAXu/Pnna4gKRiFbenwgJ3/TVxo76PJCcuz4G/5xL85H7dNhQFne/KOCzYAVzoeGlAjWCW0WmRGOO3GHB3O13rmxlO8f/FKjcd+xMbfECV4ZrKJYYPhoxI91p0C0yeRRvJqMy4KN3Iu/5tU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(8936002)(44832011)(2906002)(316002)(7416002)(66946007)(66556008)(66476007)(921005)(8676002)(4326008)(5660300002)(6512007)(6506007)(38350700002)(1076003)(52116002)(186003)(26005)(83380400001)(2616005)(508600001)(6666004)(86362001)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q1eSdFxY3ohfMOP44B7/wxq2uguOI8rV1IuGCEjN6MBLyqfNT9uW0Ow08C6m?=
 =?us-ascii?Q?il7Ily0cXuNnlt/MuzG//wjFtrYEUeuVeWyfRM3KwINV7QVWZiPmxY63QCe6?=
 =?us-ascii?Q?AqqOP4Kt3IdhTpLGF6y13wdwbm5purOGIWAoxPKWZYoW8N15oqCSGmixVY0j?=
 =?us-ascii?Q?gES3H+bWSjffODVQxnxqapOduaaOBNfWIMOyTxoVfNU8k2m3JyKigBXjf5ny?=
 =?us-ascii?Q?HvqU/pvCU201Xytlm8suND/iG8YBhnUOf1M/Ti9NTDk8WdIPBBt39Bf6TS58?=
 =?us-ascii?Q?hmLdokaAJRKQgAa+UY8ZDsfevjOduIyH5IPUsgcqXpBwlMte/2Mowa62uQfl?=
 =?us-ascii?Q?g+QCDbkCgjB1pFZr5j9fROUnMX+h2eXXtzB4TYIOGbNAF7hOquaWBH3gR+sa?=
 =?us-ascii?Q?CXoxTSZ7hDVnL7MhARtV3hOick9XT2SXIamEK31PXIe4cYpYOLEmwZ0zPr2U?=
 =?us-ascii?Q?Gd2EM/a3DSkAc0AzvBKpiAN+btQ2Z9Q6uvrUJiiGIYqm/trdzhRSWYaTP08Y?=
 =?us-ascii?Q?99G9cf/AnJPerzT3UWv4lgQphlvvgJ5Fz/bwHC8pUanEWlfohhPseW2a3p46?=
 =?us-ascii?Q?pj8jh+fZpbaophex7P7PxKfTftLK5r/ow+qFDfmKgyltf4c9loYWhOOjTmJQ?=
 =?us-ascii?Q?Ng9bjmDVKQYpQkT3Idxk6dT7267/vV8sBTZGWgCd4uLofpQUs4mtQV/qX3fv?=
 =?us-ascii?Q?e5zdiexj2kMmjlSP4kkxSg3DZLgVspsOcFpBqgeYb0DNDKty3VPTwPqaHZTA?=
 =?us-ascii?Q?Cb1p7SBfR8+4crTs9ANNkOtoP2D5QRmpIDBSLfabYV38XxjvXgpWDZcQV7Qb?=
 =?us-ascii?Q?z60LZXNVYLwhCejKCy0Bw60mspbvtscO9JMaqtzJL0R8DaFhcRcIdCn0fuMJ?=
 =?us-ascii?Q?+FLQ8r3EIBhASE9XXTd1w82gMwDbmfOFM8EwHbvnkZbo5XccAPxZRg/Bwxtg?=
 =?us-ascii?Q?kauEq31ywfIVkNy9C2PWSAe65ag0Otm65hTT54FgaDS2yWhuharFKmWEe+1O?=
 =?us-ascii?Q?PkUGkSqrZdkPBQPaVW+D34NI24N1rjKU05fqFO/f95A8UXWmxHIzLPzOOiv2?=
 =?us-ascii?Q?wd6SFSk7suPxc5MJ2ouUklwap7CM83MdzbNMxrgu1LA7+ay2FodLn8h7pEvz?=
 =?us-ascii?Q?bTkomG/jG7ZE6FpK3UovpyIAK7qfThrVIWTRSN8cxsErSz6S+7XaMRrK0nWA?=
 =?us-ascii?Q?IBnB/siZgaxF6svKIoX9CFr1OCumcryfLXQXQeYHzIkVjtt9tSNJj4ZfuRMM?=
 =?us-ascii?Q?Ro0oqnaO1khGUB0sw+aFNxkaBCeEjVLHDjWt8F8VbhtjrqhZP91F9wJOznbz?=
 =?us-ascii?Q?dIyM0v98ZRv2yBKkahTvI2SFZVTLAgn40SAhFeicJbLBDfYNAfqzqhsTY8Lj?=
 =?us-ascii?Q?rlYIyB4aBqID98t0m5GHKHxC85GFOZtpzenhQJNRYuoVle6Vf31a1cYZ3R+H?=
 =?us-ascii?Q?JLZJYT9bCpfZE2h7j4hLkjCXg6fmHdmlAVGoJri2rq25Db+9a396kibNPrXU?=
 =?us-ascii?Q?xGIWne+3+2rWER8eeG7a+1zwjaG8s7x+M+7o2WlG8CMAYWHiyUYra7iudNTJ?=
 =?us-ascii?Q?Hwf5o8WxBUQ88Clqi6eIFn3tFbjP3fwFFFfwb8iS3mNX/rapjSW3jYAZW/dc?=
 =?us-ascii?Q?96uzNlujD/khH4KIUGcA8pE=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f71647d-90b8-4522-ee68-08d9e7484c2c
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 19:06:35.4448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCuTL/mOdXMLYVoYorj34djN97kMMYKg7WpvrXbxDv8hipNFstAlTmZAJ7RiOD5athAj0/lfXJdLZ8bhVHiuxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

When an IRQ is forced threaded (such as with PREEMPT_RT), execution of the
handler remains protected by local_bh_disable()/local_bh_enable() calls to
keep the semantics of the IRQ context and avoid deadlocks. However, this
also creates a contention point where a higher prio interrupt handler gets
blocked by a lower prio task already holding the lock. Even though priority
inheritance kicks in in such a case, the lower prio task can still execute
for an indefinite time.

Move the stmmac interrupts to be explicitly threaded, so that high priority
traffic can be processed without delay even if another piece of code was
already running with BH disabled.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bde76ea2deec..4bfc2cb89456 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3459,8 +3459,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 	/* For common interrupt */
 	int_name = priv->int_name_mac;
 	sprintf(int_name, "%s:%s", dev->name, "mac");
-	ret = request_irq(dev->irq, stmmac_mac_interrupt,
-			  0, int_name, dev);
+	ret = request_threaded_irq(dev->irq, NULL, stmmac_mac_interrupt,
+				   IRQF_ONESHOT, int_name, dev);
 	if (unlikely(ret < 0)) {
 		netdev_err(priv->dev,
 			   "%s: alloc mac MSI %d (error: %d)\n",
@@ -3475,9 +3475,9 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
 		int_name = priv->int_name_wol;
 		sprintf(int_name, "%s:%s", dev->name, "wol");
-		ret = request_irq(priv->wol_irq,
-				  stmmac_mac_interrupt,
-				  0, int_name, dev);
+		ret = request_threaded_irq(priv->wol_irq,
+					   NULL, stmmac_mac_interrupt,
+					   IRQF_ONESHOT, int_name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc wol MSI %d (error: %d)\n",
@@ -3493,9 +3493,9 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 	if (priv->lpi_irq > 0 && priv->lpi_irq != dev->irq) {
 		int_name = priv->int_name_lpi;
 		sprintf(int_name, "%s:%s", dev->name, "lpi");
-		ret = request_irq(priv->lpi_irq,
-				  stmmac_mac_interrupt,
-				  0, int_name, dev);
+		ret = request_threaded_irq(priv->lpi_irq,
+					   NULL, stmmac_mac_interrupt,
+					   IRQF_ONESHOT, int_name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc lpi MSI %d (error: %d)\n",
@@ -3604,8 +3604,8 @@ static int stmmac_request_irq_single(struct net_device *dev)
 	enum request_irq_err irq_err;
 	int ret;
 
-	ret = request_irq(dev->irq, stmmac_interrupt,
-			  IRQF_SHARED, dev->name, dev);
+	ret = request_threaded_irq(dev->irq, NULL, stmmac_interrupt,
+				   IRQF_SHARED | IRQF_ONESHOT, dev->name, dev);
 	if (unlikely(ret < 0)) {
 		netdev_err(priv->dev,
 			   "%s: ERROR: allocating the IRQ %d (error: %d)\n",
@@ -3618,8 +3618,8 @@ static int stmmac_request_irq_single(struct net_device *dev)
 	 * is used for WoL
 	 */
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
-		ret = request_irq(priv->wol_irq, stmmac_interrupt,
-				  IRQF_SHARED, dev->name, dev);
+		ret = request_threaded_irq(priv->wol_irq, NULL, stmmac_interrupt,
+					   IRQF_SHARED | IRQF_ONESHOT, dev->name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: ERROR: allocating the WoL IRQ %d (%d)\n",
@@ -3631,8 +3631,8 @@ static int stmmac_request_irq_single(struct net_device *dev)
 
 	/* Request the IRQ lines */
 	if (priv->lpi_irq > 0 && priv->lpi_irq != dev->irq) {
-		ret = request_irq(priv->lpi_irq, stmmac_interrupt,
-				  IRQF_SHARED, dev->name, dev);
+		ret = request_threaded_irq(priv->lpi_irq, NULL, stmmac_interrupt,
+					   IRQF_SHARED | IRQF_ONESHOT, dev->name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: ERROR: allocating the LPI IRQ %d (%d)\n",
-- 
2.25.1

