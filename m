Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E70E470B2D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243419AbhLJUAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:00:32 -0500
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:17409
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234616AbhLJUAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 15:00:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkWnedRJh0zcLCL1IPm0deTFlhf21dJQyppXv0rV6lWtXAjKr1F302/F7C97Rc+0ixKqNyhzen7//mRrbFK5NRUIsRRTN+hgtXwNutWDH8ocl8//PhOMYyXRV5OuXHlByHaH6RzoW04uLjD5GQznuZFZ4VfWw9go7z+tflG+dwDiMz35AeV4HSdgiK1cvyMnphziKZjS6eTi7jH6/tuv0L8rvKXFP0CDn6KDMtI2hbKe3Kez2LqxiPK4kHw7UOhmXf6pwjIHcgCmejPi6anWNuADRjAtu7fXICEvdyU4los9KuUGR39sTL+svMjMDrDE9y11t6qY4xmVOPUtznuBQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2EWqiBiCKXySpNbmTT9rqOx4cy2Yp09CWqKbEhp8bg=;
 b=JpyIizXBUElOeQKCdgHLxvCwlUttyMXMdKOcYu6HqAEtbSWtM8mdRsd0q/q992Qd7SkzNJ5jNGeZahocsQ1Mm0ylXuHx0cDsdMetgyeQBX2gT694Od5MKJ0gAv8ZrUflla3jcgBtlqRIhgYQ238Tw/Jid8tREbC/qLlNWr35et2BVJaqo+Y0/0XgSPhFCeGeK79BBEuQE99hBmgyKWNJW0pusRPTBS/k2YOh+hs2gQJmxV+fPouHz+E0MnkQPKPGI2zVpY/PgRtCBIGZkjPEex5GqwKrBkiW4u+HldIjEhQilIW1q/17j/Uk9EMmsl9P7ZEYD6IPsfvGNv9bdlbSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2EWqiBiCKXySpNbmTT9rqOx4cy2Yp09CWqKbEhp8bg=;
 b=k7yut7TDHg1dBqbztPoz8tjizDbqhkI5C0Y//un9GDqQo0N7IDeIVnSUlfXufiGU1neq57Oq/+Ylk+FuqmY4y6nUlp4a9LDA9GEjSlH/1LThIBaNno/ycM4jqa1ljdiCYvcqcbFB7epwPyuSwi/oPbvzEh6EIamw2V9LQ3z1ffs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8887.eurprd04.prod.outlook.com (2603:10a6:10:2e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 19:56:48 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%6]) with mapi id 15.20.4755.022; Fri, 10 Dec 2021
 19:56:48 +0000
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
Subject: [RFC net-next 2/4] net: stmmac: move to threaded IRQ
Date:   Fri, 10 Dec 2021 20:35:54 +0100
Message-Id: <20211210193556.1349090-3-yannick.vignon@oss.nxp.com>
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
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR02CA0153.eurprd02.prod.outlook.com (2603:10a6:20b:28d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Fri, 10 Dec 2021 19:56:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e68ee64-898a-45d1-59bd-08d9bc173364
X-MS-TrafficTypeDiagnostic: DU2PR04MB8887:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB888705E6E24D2D5AE899E38ED2719@DU2PR04MB8887.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiSp1nRc28/61Nv+EljxBvdBUwyzdtbV0fQrR+qavymw4bhHQwVEw1M5xBk5OeTICLikhdRyb/ql/hXOcVFrZx0fxacn06ympiI+4YISQzUKcGVSnnSeZGnauAoBLrU+Eh5bK6W4VGWc1ZZFmh/e2kcSBrmfP9tjAlZ0pNTLf4SXyNFUTbwqg3zKRSF2GpzVd9rOn3wzHNmSs5KCWJJkcX80QX0Hzbg1Z0hw2qeUpoQjO5JwkMT98mZQjIf5vw2osqBB8XGzd/N4D73wV3+nqrswJMwsAOYUjWkdF7KZKNCznw3C1FnAgkhF+0tO8bwExv2zBNUXTDFnokbbAADLhFC2lPgykW/mKu1n8Ran8nMljU1zqZfrhok7SbY3h/xjdQtHpJR95hVMNQZ4GO+P/NUjK13djp2aDUfrK9E0agZuM+OentWNNs2EjtKaB+m4w+sCH8fj1dFMjT2C/xVQG5/GVTkSlxaidITiSsVf3Nx7WR8KP7mNGTVlbfFuHw61PmuW5w+xTc8ngdgrV5Uz3OoOyW814TVn37sHOiFVACuseqRb6bCI5BIj6PzQZyU1jatjk5QQVR6Vb21XvsoxufoE9VMBGXukdteH9JOvW8GL1GO019b6l66dGJDD+AnEqESqc7dclIfJHuHcaoEmnzhHCT90aGGrdfSCVJPpre1W4SMX2qmwGB5E4pYH/xdR9ACD3Lws+/+ezDGskcGUqfvpuWZs4XSiZLCDcsrtVis=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(44832011)(316002)(186003)(6512007)(110136005)(921005)(38100700002)(1076003)(6506007)(8676002)(5660300002)(8936002)(6666004)(66476007)(52116002)(83380400001)(66556008)(66946007)(86362001)(508600001)(6486002)(26005)(2906002)(2616005)(7416002)(38350700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3h/mh8IF8zU5Nbh4GL7sUYwP3diq/URouMowhJF2atjxciLBLQfyn3Shw7Ju?=
 =?us-ascii?Q?oazfNuWjUWd7/T12hjuIlUszKyelC4VnE9tHKXGubZjivQyqV7h2CZoQ/ZrI?=
 =?us-ascii?Q?l/QZJc1V4GKt69Ntg9QfUA9IYEt/HsW6RTKQdjyOwI7INQO9N+9K+mT59zqT?=
 =?us-ascii?Q?nFyUmjpmFT2cmFMYXoaiTmJNpqFp9W6OcHdlobBS8I95ajJOzl+wzkxtVing?=
 =?us-ascii?Q?HopjNE/qj8KiiIIzz3F6W8U4u5UT8X3IWI7aI2K8tLK4ByDWIE9CdENxRNmL?=
 =?us-ascii?Q?WBUgyC/LYewpfpUz+SvdOOl1rsZxwzpmVkd/HyPYYI3FXQM2ZbaC/6WTGY6M?=
 =?us-ascii?Q?DKBIZ5NMtZmmCsq8xbY6+R7Hz+uSng2hAJwpwS61eAJaJynRsQIEand2vj24?=
 =?us-ascii?Q?7YFWdJrIReD4VmhvmxbYtaVpQZ8XH5+Gu94f3N8TNlVecZTS8PR4B96kHjrF?=
 =?us-ascii?Q?9LogDnXiPfnZ9HSMtLHGZmoxNAa7mffVDmeZR7NKdMke2wYCMLlFQBA0wMhJ?=
 =?us-ascii?Q?76N11dwl5mS6aY/ESQMi0f9NlLC4gnuGy39VSKknGbESFN8d2NO6RA2j6aJk?=
 =?us-ascii?Q?z2QoVPSSjK/FTIcrConUqbHeVNUvcJfeuQvX6hl3U7LcSgeqVhmwBh/X07OY?=
 =?us-ascii?Q?rzFuQnggHmYAEtRNhQx45lrLAmlExo5ERweSCpeujOVWbWSJsuKa/xgZP6u7?=
 =?us-ascii?Q?ATjh8jMbOm6NeNjl4ELYytbfhdSEMhCLcuTur5/Sk1BRVuY44v32/PoIEDLh?=
 =?us-ascii?Q?iYVFxo+jpCV24BErO15N8onhE1e8RVdsVuBviTurVgetvaafpVBj0/Kgpwxz?=
 =?us-ascii?Q?Ls7anm7ptzUcf46hs0ZjRynOYcBgM3zA184l0vL/ck7xOXodG7ViTFDyY1FG?=
 =?us-ascii?Q?ajkufJ56PpvntguuuquhQMH8a1VwjW52c9f8GN1vouA8Fr33q1oIMt/XDFGS?=
 =?us-ascii?Q?KSGpKpm13J5Pl5wXjyBDTmWM/m7BPbWOfG3++YskO7rebOYTb9LqrrHZ0efl?=
 =?us-ascii?Q?WbybqctoTB9OIR5kR5eVtt39okG81AB2rwu2+iffdBXj8cku8YnCXAEJ7Pej?=
 =?us-ascii?Q?PstQnvT95i3aCQGJMqoFeYC7q52Adk7u8kRDBO19oxOKMYKUKHpUGgDWPKHw?=
 =?us-ascii?Q?GLwhs4SRIs/H2+nPGcQS8Y9mWcsTSsG9dCPjNtwSyvreNRpOGW/kPFkm4bKS?=
 =?us-ascii?Q?uElU/8AUZV3y9BNvTXt+5fT9xF3JVazfZSWEnUZUjgSQmUSRaoZYCOSiOEZc?=
 =?us-ascii?Q?MxQ/I/jeUNPSA6xovj3A4/1KY/20OEXFngGhSwynVLArlmbB7PqMf7vOyRb4?=
 =?us-ascii?Q?T6+bjKVFfsb+9/aBx8kSpKO5GwfZHZJg5PY4CGXx76mp8ZkBjNTHRyd1UZxL?=
 =?us-ascii?Q?4gx3pLdpyNufJ42zbxn4NJSsGxlRQ7huQjCp+CgHJ/O7BokdFgN2lbz/2t3s?=
 =?us-ascii?Q?vF5f7/0C8kdYnd/8F6XEKJA6ij8TV7azPi6Y1cM//srm/IMJp5zEMVYQpEF/?=
 =?us-ascii?Q?/QaAkjbFPn/AkTQQ42Rdv2XpuX8sQGxetein4oj+J2P0fLAoVVAk5FgNbyeH?=
 =?us-ascii?Q?/hjE5B+SgWH68qv/tsC1eNZ8PKPNHrQlgFBCJabgW029VKsErT5xX6Np4yf4?=
 =?us-ascii?Q?PyltYNiUAIyn+47vqWLztD4=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e68ee64-898a-45d1-59bd-08d9bc173364
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 19:56:48.3334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2D1HYD4fz6TFkSZeOalWhIi8ouxQGgNE//kVnxMXpJkJxTRzbm2EjoAVnzta1jp47LLvmtsCMNIiGJCmPGAng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

WIP (seems to generate warnings/error on startup)

When an IRQ is forced threaded, execution of the handler remains protected
by local_bh_disable()/local_bh_enable() calls to keep the semantics of the
IRQ context and avoid deadlocks. However, this also creates a contention
point where a higher prio interrupt handler gets blocked by a lower prio
task already holding the lock. Even though priority inheritance kicks in in
such a case, the lower prio task can still execute for an indefinite time.

Move the stmmac interrupts to be explicitely threaded, so that high
priority traffic can be processed without delay even if another piece of
code was already running with BH disabled.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 748195697e5a..8bf24902be3c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3460,8 +3460,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 	/* For common interrupt */
 	int_name = priv->int_name_mac;
 	sprintf(int_name, "%s:%s", dev->name, "mac");
-	ret = request_irq(dev->irq, stmmac_mac_interrupt,
-			  0, int_name, dev);
+	ret = request_threaded_irq(dev->irq, NULL, stmmac_interrupt,
+			  IRQF_ONESHOT, int_name, dev);
 	if (unlikely(ret < 0)) {
 		netdev_err(priv->dev,
 			   "%s: alloc mac MSI %d (error: %d)\n",
@@ -3476,9 +3476,9 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
 		int_name = priv->int_name_wol;
 		sprintf(int_name, "%s:%s", dev->name, "wol");
-		ret = request_irq(priv->wol_irq,
-				  stmmac_mac_interrupt,
-				  0, int_name, dev);
+		ret = request_threaded_irq(priv->wol_irq,
+				  NULL, stmmac_mac_interrupt,
+				  IRQF_ONESHOT, int_name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc wol MSI %d (error: %d)\n",
@@ -3494,9 +3494,9 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 	if (priv->lpi_irq > 0 && priv->lpi_irq != dev->irq) {
 		int_name = priv->int_name_lpi;
 		sprintf(int_name, "%s:%s", dev->name, "lpi");
-		ret = request_irq(priv->lpi_irq,
-				  stmmac_mac_interrupt,
-				  0, int_name, dev);
+		ret = request_threaded_irq(priv->lpi_irq,
+				  NULL, stmmac_mac_interrupt,
+				  IRQF_ONESHOT, int_name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: alloc lpi MSI %d (error: %d)\n",
@@ -3605,8 +3605,8 @@ static int stmmac_request_irq_single(struct net_device *dev)
 	enum request_irq_err irq_err;
 	int ret;
 
-	ret = request_irq(dev->irq, stmmac_interrupt,
-			  IRQF_SHARED, dev->name, dev);
+	ret = request_threaded_irq(dev->irq, NULL, stmmac_interrupt,
+			  IRQF_SHARED | IRQF_ONESHOT, dev->name, dev);
 	if (unlikely(ret < 0)) {
 		netdev_err(priv->dev,
 			   "%s: ERROR: allocating the IRQ %d (error: %d)\n",
@@ -3619,8 +3619,8 @@ static int stmmac_request_irq_single(struct net_device *dev)
 	 * is used for WoL
 	 */
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
-		ret = request_irq(priv->wol_irq, stmmac_interrupt,
-				  IRQF_SHARED, dev->name, dev);
+		ret = request_threaded_irq(priv->wol_irq, NULL, stmmac_interrupt,
+				  IRQF_SHARED | IRQF_ONESHOT, dev->name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: ERROR: allocating the WoL IRQ %d (%d)\n",
@@ -3632,8 +3632,8 @@ static int stmmac_request_irq_single(struct net_device *dev)
 
 	/* Request the IRQ lines */
 	if (priv->lpi_irq > 0 && priv->lpi_irq != dev->irq) {
-		ret = request_irq(priv->lpi_irq, stmmac_interrupt,
-				  IRQF_SHARED, dev->name, dev);
+		ret = request_threaded_irq(priv->lpi_irq, NULL, stmmac_interrupt,
+				  IRQF_SHARED | IRQF_ONESHOT, dev->name, dev);
 		if (unlikely(ret < 0)) {
 			netdev_err(priv->dev,
 				   "%s: ERROR: allocating the LPI IRQ %d (%d)\n",
-- 
2.25.1

