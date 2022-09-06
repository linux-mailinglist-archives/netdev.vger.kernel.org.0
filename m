Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EDA5AE349
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiIFIo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239531AbiIFIn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:43:28 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D05420BEC;
        Tue,  6 Sep 2022 01:39:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOrTXn1DXW5kiV4lO/Ko1JQpPqEqsUbYpyWXsZCm0/xyibO3r9jv/W2XhuXDx6OhWYtU3oQVnPo22OfpSRvDehKAOkXdUqz3zguoZNbQqt1rMxNPcqx30/hIPCMaL7oWWQofRb0vF8W45NOngIC4o0BbYpYRQlPMFYBAggmJSbw6KYTaJzRCKdi/hmX/ldsjrjWqT6GNp37mvYblrJM5ytqwlvkiKJ0E/f5PeAhtuHM9jJ7Ri1LcQq5aeoJNjVH+k0P+8G6Bpul7Y4A7Fp8HJ14rm8KlxL8mghZQrKtAfj749Udi3ywDMD/vxgwGpYQdYcOVb99n884mfYcAo51kEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMtya3KrkLL2eB8bv+U2z9BR5zzHlhSV/WQdgmJ4fcw=;
 b=OVTcB3xPVikSN966d7Y8j49wuW85LWzUbThh6bxyNvlyigFB6xZkjd//Zr6JUjEtFUxDnL7i8NCR9hcb/QvaZJrgf+WzVLXmqKQzoVKVfhG2puABP7Y0ydDFypCJ4eZDp7Cih3+2o0R4PgBa4z8JfvukTH21eIzxlrIxITgr5A5nkLOKJiF1BgCWwePeSuQVt+5WrnhdTQcUgWgu10v3+ete1yTSqTcwDrZwdhDdLSY9XfVlu8X0HgsB612yc7vZovW13IAzjYD7BOYckyKUaY8A9NlMofxfV0GP4UwhjpBOr1/tzY1y8npqyIb8TV5QgBhRiyogChNtNZgjqeyf6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMtya3KrkLL2eB8bv+U2z9BR5zzHlhSV/WQdgmJ4fcw=;
 b=NTpraggJy6m+Q7GfcIzHYCS+Vj65f0OjeBO9DY0rn2PGg+mdfEdM3hHWgfcDujdkHmP6UrA96VVMVkQ2tOaKqnX7NZAn1/ypLa4iDw4Ft/j8BNG+aeZ7Tw90M1XVbv2T6x2O/crWFaJvsbrIxRFymNmWyQg3kGdoErsdn2+vSOA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PAXPR04MB9373.eurprd04.prod.outlook.com (2603:10a6:102:2b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 08:39:47 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 08:39:47 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: fec: add pm runtime force suspend and resume support
Date:   Tue,  6 Sep 2022 16:39:23 +0800
Message-Id: <20220906083923.3074354-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::14) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60a8e558-5a6f-4f2b-92f5-08da8fe35ac3
X-MS-TrafficTypeDiagnostic: PAXPR04MB9373:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yn5yXBPQnjTdWokU/7Tg6Y+F6DM8l/igmYEXx5FJDrIP5PDHhDBrPTKgUjpJDwjJbmTVMmxlSebt8Q8LsWQA3xoRcPM3v4i809f6rNMvqopFiyg6yTrvicKSBj0/BttqTtsC9LiX4Un11Lu7JZK0UJNd0bERjShOYQJ2RkxylA779b3kAzj/q2pTU1R31TlnRuTNyZbCrS9TWo9iU9qElidoos7u2QQVxEdbVA0MrHFiYZEnrUAPTBTq4ki8lL4ksz7AJ+xf506P+o9p4kNPlvXzJXF0ygIFoFEnpTFxQWH6iexIv8J64Mpbp8bCsAXunL3iCpQBeI+l7ZLeAGZqdCtdYm7beScejSwmJe9BquWVUFwT2SeHZWrNl0yiwSRcONgiW+xgqwANcyKoGLLxdIEpQiv0XcdWyHVbDdCVt7XyWbd9wNszrHtVSgrMFoBpcpRuPTElTIZuyUM7f2o/q8ULMubtiGOb2htNOoDhNgqMhdR9fJqOPC0f3P9+oG804YCrP5qcsWkW7ttfLm3xwNvfGMZVngoFAKsNEB6AAbF8iR7l0189l6Qrt6DdSG8Lzgd1N80VKunSSyFb2e3wqM3MN0V7vpAakv0M6AfWV3xK4zrKmd8ocADQDUeopEFY0Tko8cQW8mYG6eCODR/wHBvaaZLxFgB5talJ0y/OR/t8umGV0npmK/ygzOlMs/3F5hv9vIPdWO4BT4tLbkr9SfrVtWpyrcphunFB0h0GKxXnFJToGJ3H0Vv2+AHMI+vHnbVkwvVno7P4kruBFxjugA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(66946007)(478600001)(316002)(66476007)(6486002)(2906002)(36756003)(66556008)(86362001)(38100700002)(38350700002)(1076003)(186003)(2616005)(6506007)(6512007)(6666004)(9686003)(26005)(5660300002)(8676002)(41300700001)(4326008)(83380400001)(8936002)(52116002)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m79iDEjW6qIsU5UldOiDJRERSkvVQnCAeHY7/whbDqP33hTROSarxTLII9PU?=
 =?us-ascii?Q?fcxb+W8PyMf/k0BC4GOqt3A7fskYaUM+H2X+F07GEkvxp0IMeL8AHKwrpiBM?=
 =?us-ascii?Q?hkWQz6oxDt8q5aJorUUlpxem9nXNvLd+v5DJYtRXHW4KpBZiTD/6oQXZQNnY?=
 =?us-ascii?Q?nyoQRtG7jRmbJxx7I+DXRIbJQiewdGI0/owdGabHLjxlvjidQKzNcXhcvxkH?=
 =?us-ascii?Q?wLz8auuu3iWR5GbCufizAanj1N2vOy3x5vEH2Eal/kW5mgK08cT56OlyVEDk?=
 =?us-ascii?Q?gtmbkXDZtq6XdjVOiBqId4JZWnFnIG70axDbqy9XZ0+J8ensN4iKVg06Kkcw?=
 =?us-ascii?Q?Wu6AGg3qwAhUIGeq8rwXJvt6G1IiYTeQb/5wOQr7yUrcslbU61wrEdANU9v7?=
 =?us-ascii?Q?jls6pEcV8hsfevTwR/l2Hy2QPnao0si9ThJQNu6XxTIUdz8wlpvVsCn0O1Vk?=
 =?us-ascii?Q?iogWPNZ3dFXjGfhOBOh5xNNyBUgWjV1TmzMBd/vfZlso9TYymWKyd2wsb19V?=
 =?us-ascii?Q?qGHEIuYdUn550kKgyJgAEZIx1ouhdaKLHAWTSt41X60qd8zn9FOW2iNWNxRz?=
 =?us-ascii?Q?YDkOMW3AtFesE8Q1VQ2ZdVxktS2bPznF8Aw96EcRnIJnpYLMTQhKIgEy3YYy?=
 =?us-ascii?Q?+qHijnpv3y1lDYfhU52d2JOyWILQAFmIjIuvWcZbVvmFnItVKq5QjEHbCwGt?=
 =?us-ascii?Q?JRJPwXkKfnBphBVon4p4jd//lN7a7HEw/bJYiuOmlbJHEn/Jxqe7ulH7tC5y?=
 =?us-ascii?Q?SAVaTVLvhwzC7NMbuDO8DvZr6fOZdLEVU1V6iNP61mMVUA2L7cyrmHIDdisu?=
 =?us-ascii?Q?4P+ZYKlN1F/jjqaYRzrjCfVb10avo6n8Qg75vLUAXn+e4HTddhXBpFMVyPY3?=
 =?us-ascii?Q?bNkUwG3NJvFb27N0cgy7W1mTeDxXwBmjDEhHJ9PNvba8+kX02pQ7CIBTJZsp?=
 =?us-ascii?Q?rVP6/fyAf7vMAM/a/2XMNWUzj08tiAvCWd9bgWMB+wohUWF5e1kNMtrJb8PM?=
 =?us-ascii?Q?3GGrkt8HYnHGXbHDQ7hSb/meEM2gaaRovMJqWIUML1J+CKPkshqUW08iuDLb?=
 =?us-ascii?Q?y7aIWZS/fNdn750JgyWYg3RA462BDnkGIvlF3KvqDUxU8yJ/wKbhCIsRkyzD?=
 =?us-ascii?Q?vNI0R01Q9XXCjxAjdCD9s+TRjwVF5bvfSEFTdEd2/mPVmBXBCzMY4LZ8x5oJ?=
 =?us-ascii?Q?N7Rdlw/0HJGaV9WC8eDxp8i3YM/Mj71lT02QQjOayc3g42m52Y+BSguI3k0U?=
 =?us-ascii?Q?8myxaLHR16luLfxZ6i+wV09l03oLdPc53BTtPDEcYd+A5QcBuMReFRqduxxm?=
 =?us-ascii?Q?E4aHcRZ2/5RkEE1LIA1ee5mKp0fmYbjDDkjp7un6hMYkFaCNMKtWZHNlPgTo?=
 =?us-ascii?Q?J4a6B6Hbpv7xZBgyUiEU+aleNUcQnrkliIYE83pIlHXnqh4dT8T1n6bJc8o9?=
 =?us-ascii?Q?XfbdGIyvOB5DWNzTw6CQjuw2iVJd0+lFKpf9OD+gXq7f1zWzNX0RWv7HCVob?=
 =?us-ascii?Q?PbjGjIb2xm3ZhAaFHiRTgGMHX7r69oVBD9/1AskxqaCzPtudiN213Omd/Hx4?=
 =?us-ascii?Q?Fb3E0CEON2Zo7m2hXPa7O/Vii5W2hEFfQqB5cSfd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a8e558-5a6f-4f2b-92f5-08da8fe35ac3
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 08:39:47.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCOSuwToEYDpNKkIybFheerUI7ce2lecTe0J8VfRGfFzutSWlDd/6V+apsf2XVgmE3YfAeERojN+9j/6X8eJWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9373
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Force mii bus into runtime pm suspend state during device suspends,
since phydev state is already PHY_HALTED, and there is no need to
access mii bus during device suspend state. Then force mii bus into
runtime pm resume state when device resumes.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0cebe4b63adb..521f60c7f2e0 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -579,6 +579,7 @@ struct fec_enet_private {
 	struct device_node *phy_node;
 	bool	rgmii_txc_dly;
 	bool	rgmii_rxc_dly;
+	bool	rpm_active;
 	int	link;
 	int	full_duplex;
 	int	speed;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 7211597d323d..13210b216ee4 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4092,6 +4092,7 @@ static int __maybe_unused fec_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	int ret;
 
 	rtnl_lock();
 	if (netif_running(ndev)) {
@@ -4116,6 +4117,15 @@ static int __maybe_unused fec_suspend(struct device *dev)
 		}
 		/* It's safe to disable clocks since interrupts are masked */
 		fec_enet_clk_enable(ndev, false);
+
+		fep->rpm_active = !pm_runtime_status_suspended(dev);
+		if (fep->rpm_active) {
+			ret = pm_runtime_force_suspend(dev);
+			if (ret < 0) {
+				rtnl_unlock();
+				return ret;
+			}
+		}
 	}
 	rtnl_unlock();
 
@@ -4146,6 +4156,9 @@ static int __maybe_unused fec_resume(struct device *dev)
 
 	rtnl_lock();
 	if (netif_running(ndev)) {
+		if (fep->rpm_active)
+			pm_runtime_force_resume(dev);
+
 		ret = fec_enet_clk_enable(ndev, true);
 		if (ret) {
 			rtnl_unlock();
-- 
2.25.1

