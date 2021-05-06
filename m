Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CD8375920
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 19:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbhEFRVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 13:21:53 -0400
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:20320
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236203AbhEFRVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 13:21:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbMz/jQxlMszd6reARiIV4C4COD7R1/wHfFPXAT6GMGPvroGWZzOlwqx5amaYPbd6jaetsvMMxBWy2kYnOpvkjlPkPxmEm6in8iAHl7tbpYNbqIDZR6I9RK600iGFFnn/pxCC+pQZxZsD5CyN8Aqvy3lJlKMGnMt9P6BqV4WRmdyMQQUq7j+ggY0qW3IbOvlvp07CYHntc5sDZw9zI4TFUcz6lSfukpfs4+Pd2ArrZSWBEsSMT2dvpGxQIQTsk3klOYAIUpK/51iC56BU0tfOm4CRarogLGneMpOUKsjsJ8+kyonWB/h+HNz7htxqqpXJIBHWmbzmys2xWCTc0JvWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kexEp/w8W58wMrD3tB2Y5op678Z7vfG6jGXWaN+pm9E=;
 b=gwmuzhf2Jo9E1/dja2WF8yUTZmgwnavfrb+G9rs6Wlyen/vMmyAl6vdenFPA0P2vIOn5aI4qzTYyiMc30mxLSV2q3YFbninG00udAgwZMyr6DbvyF3M+pusxuYKmceTt0r1CW+QwA0nTZdG59rhh2LYFY4yMS0as3uX4r7Jb6RGkhvyt8pMG7LYm4sl1msyIr9Qc4Gj2foZKohoSyZjaTMP0Y5ojOiQ8TrPXF2O4gzV42lSRR2yq6XiaSMwQjMeSQARiWFL46eSqYD/FU/sFHN+Oz3eQ23Fwu2amgYI92rEnAPuAlrCcU5ArrekaKRoHzLJvdXmcvfzzVvoJgdpR7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kexEp/w8W58wMrD3tB2Y5op678Z7vfG6jGXWaN+pm9E=;
 b=VWj6Q+kG4ljUJ9sl7/1wh86AGDYS8FN/Dv68OjXwalYegQfQmLAGtl6UcArhH1Uu0g+1Rsdh7+YfJmAaSN8McchiU52gIKrhDvTjYj6r9IkVD3KOKJEY303KHtsSth3X4T9NYruYZWW2bKoIbOwuvBGCu9lFiGg11b9aTpQ8hpA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8581.eurprd04.prod.outlook.com (2603:10a6:10:2d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 17:20:51 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 17:20:51 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [RFC PATCH net-next v1 1/2] net: add name field to napi struct
Date:   Thu,  6 May 2021 19:20:20 +0200
Message-Id: <20210506172021.7327-2-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
References: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM3PR07CA0129.eurprd07.prod.outlook.com
 (2603:10a6:207:8::15) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM3PR07CA0129.eurprd07.prod.outlook.com (2603:10a6:207:8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.9 via Frontend Transport; Thu, 6 May 2021 17:20:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ccc853e-eb8a-414b-3799-08d910b34c33
X-MS-TrafficTypeDiagnostic: DU2PR04MB8581:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB85810662B1462E03D6D38CB5D2589@DU2PR04MB8581.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /wB+v7b6PbZgR3ALJHdNxwq1zoJ/efzahr1FtgQ6E2NE7WsfLQLcnmU3ifClaWece3Z+Jb0YiknVX2mE8oOGJlOlaIJ/4yn8RfQzKNtnrYzpgYEBK7/GTd0QcCxGGWeC5CkmYuNiUUV5BubDCY2DfhCq5a86Sm0ZuqtnwMOHOEBXzIdo9YXxi4RRkyba9Obkgck2O47q1ppg28aNMdcI+QckPb9PheRcH0t2wbMSv9tyd8boi9eInlZkVFmQ1LFygHUxKZOgUWUsIbM0VypYV4C7omLibBhAhCnNRYbdht4NzNop6hQnkT29DZZy2RkUF+lTWHqcLAAmj9v4P4eHB7h695cYNAcGgDrGRawQGSou1aNd+hkCTr0yTJIdSmsQxVQ31eKe+llaW13DPsfzFnBDfxQJYI9lOqx9sX+AhAmNbEydOLDhiIe0Gz/XPdipwZJIMgZJBgg4KUhOx6fF5W3fBKcY+zZNrNtXPgL56414Y1fG+78uv0xB2VWhgdgkCBszXUdugf4VtDRqtjfFN92pKqWuqGKwaVaCpHnoX37MvmzTLyxj55/bPJagKO3k8Pnl02FaLnzwATpPpxydMuGaLZvgnqkhLJGAMArVQlo+/+Z/Ir/ABZaOZgwsTDiPgMs8huinZ9GFT1QDaruCyKTsW4FLFMMZVl2hTHa1Qw4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(86362001)(83380400001)(8676002)(16526019)(6486002)(7416002)(1076003)(6506007)(478600001)(26005)(6666004)(921005)(44832011)(186003)(6512007)(6636002)(2906002)(4326008)(38350700002)(66476007)(5660300002)(316002)(956004)(2616005)(52116002)(8936002)(66946007)(66556008)(38100700002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BwnXRCAQcFZZyQH/CG0LIl0ZTtq2my9FyhVW86LKUdzMkaeWzMQBfTZsWtAr?=
 =?us-ascii?Q?0822mFH30KDb98U8QG1qEDe+NBgJCHsGXhKWBXMOCDAc1qw74wa/CITcip+d?=
 =?us-ascii?Q?vfV3GumLEoYY9gz+TOaHpXK07L52cEywmDuj4N0PfgaXMV5s4PN0pD+atvol?=
 =?us-ascii?Q?nYnHsWhlntp6KE9t0793x+NcOYAPlTjAVp9SIGKueBWm717x4THVWLqVpzpc?=
 =?us-ascii?Q?Eytmxjbprhreh7uVW2+fkEB9pIjlE7Cjj3Y2h0vwH7XR6Z4FL5FNeWkVKq17?=
 =?us-ascii?Q?egHTx7KtipkVR/KsuhLp9q7NlaFWcFRM5QgSv2XWL5eLRB8rd103Kql6OKqw?=
 =?us-ascii?Q?WQhO9yPUB1jtiKfCKHQj4lEt2s+i8wwXhrHgVoU9NK8H7zS7VDCvZwBIByVg?=
 =?us-ascii?Q?lK6pVYnUtvTwRiwSXqV9VN1BU8pDbRsvOZLlmrV0QrZPpUNSw8kSXSowa6G4?=
 =?us-ascii?Q?GXAK/KPj4sSXBIVcPLy8WViohHoTjMjry6ubuQ8xKig8J9AMLwexTbkab//a?=
 =?us-ascii?Q?g/ztOeaVcABF5y6FU/wlILkxkEcbrS5peoLw6L/aAR6OCi2SH+wVAdFT2KdI?=
 =?us-ascii?Q?7Gj9y5LUZdJGa0xWvwgggZNYF0w5aSTxWfINBnqjCtg7WUvdDYzel3T0SPs2?=
 =?us-ascii?Q?Dm2N5U4KiYK0GqBkLLUjoSbqqceCn6kFnUz8A7A3FMGODNR3NJjXzTzWPUck?=
 =?us-ascii?Q?T4hMvST+Xltkyk2iD90hJ73nE2/IT0V0OufUPjW9DkT/lYV7FbEPirLRvnVj?=
 =?us-ascii?Q?bH4cPG97dW4rFpMkNo1VRpSoxHM9lP1Pul/v8HlS5b9o/Bsfwp5Uegxb+UmD?=
 =?us-ascii?Q?y3a0Wzoxl/20v89suSjmKJJXryxdrKNZhgnJ8NOndw5994VtNw58QPFNR6Dd?=
 =?us-ascii?Q?hCr/dC/3UnQKfhpKApnYx+Nh2SLvBUScfMKDeeJ+ujBjrmP82Vqs/XXWk5uj?=
 =?us-ascii?Q?iwA9T5MbRF4+AYhKsyuF0Yafs7oDqPNoGU3/xJiXrAJw1G3gm0z6GvzN4Mej?=
 =?us-ascii?Q?a4i9hCebjDw5RiBNEqtravVzsSuVztxuDP3wvTFeVmpjWa5kO0vtw/gS8xKJ?=
 =?us-ascii?Q?dPXcaGwn550htGJCrdd8RyZxe0u2VIPijpODtWfHpcDiWzJY1ciFEumKnj6w?=
 =?us-ascii?Q?Wn4oCMKPGqvC9Qm+Y7FwZ9zaiC8YTHfiA79Gs2wOflrMxSOSPYFRW0iMpB19?=
 =?us-ascii?Q?JO3dnhofVlLnfPJFeU2K+vM5ODfIR5/YHMq+qYF/Be/ewX7sAig2HPlRQ+sf?=
 =?us-ascii?Q?dQP3D8wM0ntDj5ZcmupL1TIr98zs9WMunpPuwIOfDkehMOM+hBl1ts5WZfBZ?=
 =?us-ascii?Q?0EkCiJdA+HVcNP0MCdLlmZN3?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ccc853e-eb8a-414b-3799-08d910b34c33
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 17:20:51.4884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trHrPUHrX7fxI5VBCXQiOq8VTGSQoaV29r29CNqvEFddeqTXJ5ymAu57+ovu91CIYma5N5pQ00cBvyj5SfCXQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8581
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

An interesting possibility offered by the new thread NAPI code is to
fine-tune the affinities and priorities of different NAPI instances. In a
real-time networking context, this makes it possible to ensure packets
received in a high-priority queue are always processed, and with low
latency.

However, the way the NAPI threads are named does not really expose which
one is responsible for a given queue. Assigning a more explicit name to
NAPI instances can make that determination much easier.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 include/linux/netdevice.h | 42 +++++++++++++++++++++++++++++++++++++--
 net/core/dev.c            | 20 +++++++++++++++----
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..01fa9d342383 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -318,6 +318,8 @@ struct gro_list {
  */
 #define GRO_HASH_BUCKETS	8
 
+
+#define NAPINAMSIZ		8
 /*
  * Structure for NAPI scheduling similar to tasklet but with weighting
  */
@@ -348,6 +350,7 @@ struct napi_struct {
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
 	struct task_struct	*thread;
+	char			name[NAPINAMSIZ];
 };
 
 enum {
@@ -2445,6 +2448,21 @@ static inline void *netdev_priv(const struct net_device *dev)
  */
 #define NAPI_POLL_WEIGHT 64
 
+/**
+ *	netif_napi_add_named - initialize a NAPI context
+ *	@dev:  network device
+ *	@napi: NAPI context
+ *	@poll: polling function
+ *	@weight: default weight
+ *	@name: napi instance name
+ *
+ * netif_napi_add_named() must be used to initialize a NAPI context prior to calling
+ * *any* of the other NAPI-related functions.
+ */
+void netif_napi_add_named(struct net_device *dev, struct napi_struct *napi,
+		    int (*poll)(struct napi_struct *, int), int weight,
+		    const char *name);
+
 /**
  *	netif_napi_add - initialize a NAPI context
  *	@dev:  network device
@@ -2458,6 +2476,27 @@ static inline void *netdev_priv(const struct net_device *dev)
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight);
 
+/**
+ *	netif_tx_napi_add_named - initialize a NAPI context
+ *	@dev:  network device
+ *	@napi: NAPI context
+ *	@poll: polling function
+ *	@weight: default weight
+ *	@name: napi instance name
+ *
+ * This variant of netif_napi_add_named() should be used from drivers using NAPI
+ * to exclusively poll a TX queue.
+ * This will avoid we add it into napi_hash[], thus polluting this hash table.
+ */
+static inline void netif_tx_napi_add_named(struct net_device *dev,
+				     struct napi_struct *napi,
+				     int (*poll)(struct napi_struct *, int),
+				     int weight, const char *name)
+{
+	set_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state);
+	netif_napi_add_named(dev, napi, poll, weight, name);
+}
+
 /**
  *	netif_tx_napi_add - initialize a NAPI context
  *	@dev:  network device
@@ -2474,8 +2513,7 @@ static inline void netif_tx_napi_add(struct net_device *dev,
 				     int (*poll)(struct napi_struct *, int),
 				     int weight)
 {
-	set_bit(NAPI_STATE_NO_BUSY_POLL, &napi->state);
-	netif_napi_add(dev, napi, poll, weight);
+	netif_tx_napi_add_named(dev, napi, poll, weight, NULL);
 }
 
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index 222b1d322c96..bc70f545cc5a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1563,8 +1563,8 @@ static int napi_kthread_create(struct napi_struct *n)
 	 * TASK_INTERRUPTIBLE mode to avoid the blocked task
 	 * warning and work with loadavg.
 	 */
-	n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
-				n->dev->name, n->napi_id);
+	n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%s",
+				n->dev->name, n->name);
 	if (IS_ERR(n->thread)) {
 		err = PTR_ERR(n->thread);
 		pr_err("kthread_run failed with err %d\n", err);
@@ -6844,8 +6844,9 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
-void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
-		    int (*poll)(struct napi_struct *, int), int weight)
+void netif_napi_add_named(struct net_device *dev, struct napi_struct *napi,
+			  int (*poll)(struct napi_struct *, int), int weight,
+			  const char *name)
 {
 	if (WARN_ON(test_and_set_bit(NAPI_STATE_LISTED, &napi->state)))
 		return;
@@ -6871,6 +6872,10 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
 	napi_hash_add(napi);
+	if (name)
+		strncpy(napi->name, name, NAPINAMSIZ);
+	else
+		snprintf(napi->name, NAPINAMSIZ, "%d", napi->napi_id);
 	/* Create kthread for this napi if dev->threaded is set.
 	 * Clear dev->threaded if kthread creation failed so that
 	 * threaded mode will not be enabled in napi_enable().
@@ -6878,6 +6883,13 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	if (dev->threaded && napi_kthread_create(napi))
 		dev->threaded = 0;
 }
+EXPORT_SYMBOL(netif_napi_add_named);
+
+void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
+		    int (*poll)(struct napi_struct *, int), int weight)
+{
+	netif_napi_add_named(dev, napi, poll, weight, NULL);
+}
 EXPORT_SYMBOL(netif_napi_add);
 
 void napi_disable(struct napi_struct *n)
-- 
2.17.1

