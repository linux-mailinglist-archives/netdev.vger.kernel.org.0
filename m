Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6322967D137
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjAZQWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjAZQWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:22:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2872E800
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:22:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI7OejohlqDzS6a5l0AheojPClzKyG/x+SVkQDbpTHyyUY1Yx1nbpWvqTkqQU+YfsjAiej2xpfcFCZy0uTZTlLFEkxI2l5v3HYHHNmIVMuBAiEQJZlWcfBtIDww15y1zJv/r9nC2+RZp5ETas+X+2x1l5chqmEOVitThn16PK3kc1ll2/4HVS98N3OtBVWZnYgxakoNVEEVU/+Ebis7Dr9gAGnZU7qIU4VSrnWbT1c018cFRgS3WEUrYpmYPP7GqzCFkIvyoWOjao172cXksUkFST0bNQbiGXaXzxFW39sGInGi4eYV6Y5yKpiVzJbP14oE2JsP/F2w6QwFV7IEG+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u41RUKjgbSyCMhIf0q/5XH7Ofu19EUA94uAfyv5ASJg=;
 b=OGlF+/TFZbQrJGQLg43RrmNA6KvJk+dhuqHrx77L2tQuJa+0suaOHFChUk/wOd4pRj48Gp3hPpnq6Qlxtc+MJhDlqmf5NxjDzYmP5C9D0YJyW4xNThpTvJdfcySAqZiBaRrplc5i8/3rErOLTRB05YU0D6aouzdLjJ+YvvnE22N3bcJgjiRrGUSFAsKO2k03gcYbPrRmHLHAZIremcUPaCeBdKYLrgdLMnKz6bjU1q1m6TmWzTXJHMldsLYTFWJMGkeO7ynmzcH1m/Rc2/Kud4Cc0uSHAUwbS7BC/u1spzbVtJRoiOL88GQ/isCTyjapNmPiEjUJyMNXehK0KBENEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u41RUKjgbSyCMhIf0q/5XH7Ofu19EUA94uAfyv5ASJg=;
 b=NE7SzGaB8V592rsAhztUH3N8IZ3wsOJyRJeMnLo5PoJgL2dVMRqWcO6uaEGpK/GAxO07dbSEI34Uz7FUKOctaivc2kqhnG/hUG3i4Ld+wkXxTOPOR+YhCipi8FPJN2JGo7cpe1q3cz24SnhQue5X3jvgyNB7W5wuPvjixI1qLG3bAzwJVtHWY/1HxIzFLQNKi1PiyvowaJgl0f/7FS4em+3PxnzRTCk6aZl29vZxpCXGE50j5+6Bd4LZG0C/Izg9KusnZ/h80RVcKcnBmpBsXIrXMU/7TYFpBhIazzgVnRfm/o1IktWt5JBTTVfXI9hS5WjFSLB3SVLNzozFbFU5mA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:22:25 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:25 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 06/25] net/tls,core: export get_netdev_for_sock
Date:   Thu, 26 Jan 2023 18:21:17 +0200
Message-Id: <20230126162136.13003-7-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0206.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::26) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 1955ed1d-a2e5-4dd8-ac54-08daffb982a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qx2VsajsFVEmnwDb8mPFIaD3JpYnyT0EIGSoNTD/8w7dsn2F027O0AObpkJEU2Mqspw72qmNLtKfcX0qnWoMihiaWYWVWSyNIjAw+DJtLTVLVHUmVUCLtnyheFVWO1fZiPXuK1tzVSmxBmkA8qAzsspL4CtmOHbSENrhjcnkTakKSfbvEuufRNtQu5fhIrGqcTNZGlPqHYVViUHw6cPjoWio63b8W2QMTdy3naWu2Qn+5JJ24bGe3sQoG+XgH7cjpjkY0vTltg89158mihOTGrFCZfYTu1KjqLImcdbZ0fqUSMU0Kb5OgiLdiJAg4Td/EdkShDU9DWCLF2/PhJnNqBvJbHznpqZxros7ZlP91Hd5NKoQg90t4soue/et+2Ubt+eNRV8roNFtSN7/96TTo1p8EfEq2anJlAyn3InDrkzR2M1U5bHK+3UXzaixAZo0GYMrtClMGXwlU14gZFB47BkA4mJ3XNL0qPt04D6Tq2g8FG9ghkzrG7PMHIWzxX8COLblnRLe6EOenWabZVHxEQJaFPtlcu0eHxV33yBBvdeIlzpfoTjRr1HlRIIC2i3MqCRTns6CwHssoZ1WHnvOxmqTxCwA1GXS2NUi0+irehL//j/i0tJw4dqghaN3yhIdU3mgUeREaQCAiwo2ETYHOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PHL52y5I1AWAD4RY3MpyJZilGcRkVV839cKigVm72oiCGQnojkT2P3qqO/J7?=
 =?us-ascii?Q?GJfHNCNTaK9hbm7ucEFLRR+NbmhY3QYgseoUsUkUG9TG6OPAIl+w36Sc8KaM?=
 =?us-ascii?Q?HaKMpcWC+TWXmU++k69NWfeeznt84QDc4XHG2lLxcbGEeHDE9HV4Uuh26CW4?=
 =?us-ascii?Q?AB/Ub0t9ZvQAbLaTjf1YkvFYSo5kEZvxeBKTbYeEHYHF+GwfTmMM7XukRWsn?=
 =?us-ascii?Q?bKK7cywyNzAj/nZ7Fdp1iPWfU0pGOu7esQnyF+Cj7oMt2w5Xi+jegAk5OHHe?=
 =?us-ascii?Q?ZOYoi0cgTLpIlV6nVxTatmeJAkcKRuTlFvFG4nhc3PVjLfCqOAdRMkNsaDD/?=
 =?us-ascii?Q?2U85emshhUxSz5W4yLfOyPIP3quYkLSPcGYBK98mSTNObtjdY9CHNS+lLiib?=
 =?us-ascii?Q?UYKDiiT7UEA0sig1asXJbwKu6Gx42z7f4X09JKwGNAEyuRWUVnvS2Y9E0mou?=
 =?us-ascii?Q?uW6Czhvzkm8rSW3PSvxlpNo0nUhZRht/U8OlFewO2CvUByqcbZcHiZ/W1WTw?=
 =?us-ascii?Q?y31vzGpz1Fukw6VWZcEoiJNwkiWl1DuN8yX8AN4RJo016SLUOxkaIqD/2rCG?=
 =?us-ascii?Q?oW+FeMCs5riCCzK3kRMcOGlqRHQcpTu9sCe4pM7vmSYGeN8MbNGlrXfbaX8D?=
 =?us-ascii?Q?FFJ23JEmjWIm7drl/cKNu6QjijQU/K4lhxyWMw1e8ZCTAtbv6YoBrryxZBfq?=
 =?us-ascii?Q?7sBfleQzVqZ27W2IzxLIoi94lf1W/x5ZTQ1TNKjvFORECBplQU6A+ESFY3qw?=
 =?us-ascii?Q?jtpNM8k8oSKl72KSqF+AnL1BFgcg+ZAbR7WrZsPC+mF2tlK7zbMOs6mKfiDx?=
 =?us-ascii?Q?kbhR5uB3t0L4WPxs9zKWvqIH5nO7qW+YrAu3tqMa3IA0dT1ls2JIKZ5gj4LU?=
 =?us-ascii?Q?3nLp19UzqItUQKpqOVhZJMqcvBGyP4XxNjgFV8NxdXuuf6NTWY7vI+rw8Nrr?=
 =?us-ascii?Q?dKQI+dU56+N1yLRn+EWtjasMVdOhz+Jz58dCc6LRi+Zz3sqHMPs5iW816Ub6?=
 =?us-ascii?Q?JLBiHRuCqkLPTD1ABEqvWK+swued+Qcyd/8zZo7EdpXDE8O7EzFCxO8qU/aQ?=
 =?us-ascii?Q?JRHfoRQ3OTy20Z4C6FfxF+TBeTnjX8m5dO6Wzr/TgqNYUbuR3Hy93VcR6tKq?=
 =?us-ascii?Q?x/3CscxoF1iM4r98AUu4T1I/WMOFNCaxjt9iQRM7fjQ+a3VdgBTqrqG24DGb?=
 =?us-ascii?Q?tJw5jWEW0P3P6GYEQqcAJHzhdd1VMvx+mT//h9g975d6zU++3TUkrU92dcYQ?=
 =?us-ascii?Q?fx6uoOHh/ret8Cne19GezFBiWqJAA/9qQFpWJ3IEikxo4Flpxyw2K6q4ydvB?=
 =?us-ascii?Q?kpsuynLrh76vfo/YiB/AiDq4VV/mk30uuhfZVdvgAfyMs26R6MmVjH2nRoag?=
 =?us-ascii?Q?xK+wKo85Wk4dVFhe8vy2YwVBniOusndToUuJcpI3Py1yQ9eyxNEEqByjzq45?=
 =?us-ascii?Q?SycLw54L2lm/xz43dbzOr54+rPXaZt6uRXzSiC+jqe0r7WctE/b9Ci2zLo0Q?=
 =?us-ascii?Q?eqXh0XEzP4jE9oQX9rkik+1hxOTURSm4OF3qy0JV0mH9xoTn/NGuajNGRm/S?=
 =?us-ascii?Q?1g3MR3/f6NTN4mRW21brzQhC8rpo1PpIiEgUuBzg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1955ed1d-a2e5-4dd8-ac54-08daffb982a0
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:25.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTjnqi/gaqacL/KCP7i6tThNh8xl+vG1g58NyXvGNprIQ+ulPeR5RcBlVaaVhlxbRdZb4mpvGej5T6l13Tnwow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* remove netdev_sk_get_lowest_dev() from net/core
* move get_netdev_for_sock() from net/tls to net/core

get_netdev_for_sock() is a utility that is used to obtain
the net_device structure from a connected socket.

Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/netdevice.h |  3 +--
 net/core/dev.c            | 26 +++++++++++++-------------
 net/tls/tls_device.c      | 16 ----------------
 3 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 289cfdade177..19aaf0531fc5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3082,8 +3082,7 @@ int init_dummy_netdev(struct net_device *dev);
 struct net_device *netdev_get_xmit_slave(struct net_device *dev,
 					 struct sk_buff *skb,
 					 bool all_slaves);
-struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
-					    struct sock *sk);
+struct net_device *get_netdev_for_sock(struct sock *sk);
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
diff --git a/net/core/dev.c b/net/core/dev.c
index 9c60190fe352..29db89beff48 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8151,27 +8151,27 @@ static struct net_device *netdev_sk_get_lower_dev(struct net_device *dev,
 }
 
 /**
- * netdev_sk_get_lowest_dev - Get the lowest device in chain given device and socket
- * @dev: device
+ * get_netdev_for_sock - Get the lowest device in socket
  * @sk: the socket
  *
- * %NULL is returned if no lower device is found.
+ * Assumes that the socket is already connected.
+ * Returns the lower device or %NULL if no lower device is found.
  */
-
-struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
-					    struct sock *sk)
+struct net_device *get_netdev_for_sock(struct sock *sk)
 {
-	struct net_device *lower;
+	struct dst_entry *dst = sk_dst_get(sk);
+	struct net_device *dev, *lower;
 
-	lower = netdev_sk_get_lower_dev(dev, sk);
-	while (lower) {
+	if (unlikely(!dst))
+		return NULL;
+	dev = dst->dev;
+	while ((lower = netdev_sk_get_lower_dev(dev, sk)))
 		dev = lower;
-		lower = netdev_sk_get_lower_dev(dev, sk);
-	}
-
+	dev_hold(dev);
+	dst_release(dst);
 	return dev;
 }
-EXPORT_SYMBOL(netdev_sk_get_lowest_dev);
+EXPORT_SYMBOL_GPL(get_netdev_for_sock);
 
 static void netdev_adjacent_add_links(struct net_device *dev)
 {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc25..3c298dfb77cb 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -120,22 +120,6 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 		tls_device_free_ctx(ctx);
 }
 
-/* We assume that the socket is already connected */
-static struct net_device *get_netdev_for_sock(struct sock *sk)
-{
-	struct dst_entry *dst = sk_dst_get(sk);
-	struct net_device *netdev = NULL;
-
-	if (likely(dst)) {
-		netdev = netdev_sk_get_lowest_dev(dst->dev, sk);
-		dev_hold(netdev);
-	}
-
-	dst_release(dst);
-
-	return netdev;
-}
-
 static void destroy_record(struct tls_record_info *record)
 {
 	int i;
-- 
2.31.1

