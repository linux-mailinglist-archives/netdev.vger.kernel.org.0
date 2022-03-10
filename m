Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E64A4D4C98
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245416AbiCJPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344272AbiCJO7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:59:51 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9410518C7AA;
        Thu, 10 Mar 2022 06:53:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xin5XIt51uSxTznh8RxW+XXYZMqiav8KpVWWVr9bf808K7lFVt0J5h2uajZsNfZ2i+wXpV54Sk18FmVZ0LQF+QmHxzcmCtl1nDJrl004NpOnAVxedoa5/+RFKXqPT/PTxGWbtqsrL9N0cbgJghlo0DYzSf+B6xfVj87MjMGkmQCBdTIOk09HwnWsoVJHHH7zNpAx8AKfGBbU3CR6ijmTzdEAVP5XmuVVR9ylqAl+xBG3hUExDPJRiMKSwESDiBgV3xdgv0mEjR1kvCGQZXPMV7w8bnp6K1f8f+twZz091BkU5dWtbl3jnLEdU0Bgm1p2vq8/jTILafk2hmz9V8aQbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZvJ8NS+z0fnddGHLhik/zOI4Em+fe5A5hGRXXFQCvQ=;
 b=joqTxncoi9Sp16vs1Tffb7s8Mj+y/XzZrfXVsFSJYhAQIhMyEOdMmUECu4Si3LuKp4v2dIZ2zIb/Tti9WIxN0GYppfXoWso3VUuw3xwFRL87sHhAbfbAjWFcOOlZAJrKEIYN4YsKDD0kkT+Y7krFoK4IFzBxJ43CwFviCyYG1yllRsmHFFkl3dPNM9WNt9M/WZ6KkdIsZ8ZVHQzhUYxpUNssbk6l1Y1zpH+417SKwfqjHfChO0IPSRLUoz2O7x96NaWkoG5W9PTmIwovvfop1fSb1/GlMK0bsaL0PZuFRD6bwjh1mACG6s9vqdnwvg3SPdqiwMmZKtftj3yji56Zjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZvJ8NS+z0fnddGHLhik/zOI4Em+fe5A5hGRXXFQCvQ=;
 b=YaHqiR8oZcaDYDQvQkgHOwUPUdL3mjGOmtHVVYxzzlCpakQba7GJnW+sf44b10LYzh8AqNAVMo1gaGWHpdJHk8z02PoyMDrlcrXGIo+5dFQA8RBCQ86gw6LlBR2TfRNItaTWUQi5edXB723zwCHnGu1eVRLhcXwdIwLwqHQ38Z0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:29 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:29 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 6/8] dpaa2-mac: move setting up supported_interfaces into a function
Date:   Thu, 10 Mar 2022 16:51:58 +0200
Message-Id: <20220310145200.3645763-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92c1e1f5-2a04-4d8a-290c-08da02a5994e
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB7281EE1DFAE1D0592DC5F08DE00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JeIEkVrotiBQjntYsuuGoRMkMaGMWW4y2cjMo2IuzpV61zJBb/f8NHBAAogA4s2wesLBfCkC21kpQPaSSg7xTlKDuqCBTc8vP5GOduBbxfVpRcpHVhpgsRTukf8vxXI1UuOPBrCVlFO1oIh6/wKbKk/O6JUSck4VPUm72HUYd/svYWUPn1kMZrkt9oG/rbPGs9NE/u5hnKO7ggH7gO9jR4pXNOOJssBkEDd4b/3mwzZp/XrhGEJxblptOubp/YOQ9Tj373dJxFnUJhysTTL1GJRgtc8/HT6ZWI/esA8fcqcz+9WbszR7y5qi6kjBpnctT6vAuxRcHG9DR1PxxK1WyQW0h9xw+lLmErD9NEGE6ORHpGAb9PJDxbosVWnEz1gfIgikccZqdIZ5tGazQoXkBCsOfokVS6iQJ9p/e/8p2ArPHoWh0T0gYIxfq8odp1ST4v+B4Ckm/lQiMmvCtxu+2oGoIiug4aueiJXaDooxWF4ec2ub/B5w7Y2PGSanLJzWMaeUwXyVcm9Zpp3XJ7/q7JpV1CGODDa1q5QXeEdJNx9bXZh1riHciYnYe1UdGu41Q+MwbId1vxfA5f6q5tES2GY9+8YU90YAPujyfu47PhPXTfAGBtC9fgbAfZE36y3JlfX00UeYc8EMtVGEJ7vnaMNXsklKeccLcadJVZFsy4eglJU0QNriKWz56vNOTSJokbRMEZzuY8AP2LTEb2fRqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(83380400001)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5cmmRjpAxOcOzxcK7wF4bvvHbI5LiljHRG8QL5H5AFYmnqCLhnwQSiqcrZGT?=
 =?us-ascii?Q?5wJDUPLTZh8pqMOTuvsA30WHhbp2HVvduevqGxTJ01/THozLMb4IoDB5AwOp?=
 =?us-ascii?Q?Cm98xFn/ug4uO4LWWgWicZvbAlstI2Icv6o+pIAHNn2rKu3W+BJpB6zOJrm0?=
 =?us-ascii?Q?9X1+awAebB8fFrRDhhc+qgq+InjjjEuaeef7Qjc4r/UiXUh4GmkTxKTk4UdL?=
 =?us-ascii?Q?A3aMrqr0BRMfT1K/NS8rKsMw8bbTARj+sGHpGJZivVhDsqHG6mYGHCyWUCew?=
 =?us-ascii?Q?wY9fxe2bAek1xFvUyy4LCTU6LxpgKUWn2eDCNLM0T6V+FrbotdCvK9GoAhBn?=
 =?us-ascii?Q?gst4GOgM2d1m2AJxTgE3cHSnxKZ/o0u2Vr4krgEjXzK7/ykrHJ3bD0IGYqUa?=
 =?us-ascii?Q?Sw/S5VtmjbTmS5g6xFPMFv+sd6uqJl4LGOEjKuKiUcsbgs3IsR3n1sxn7hDp?=
 =?us-ascii?Q?+KPc+sdAbU44JIMqTYaoMsGVrGrshx9l+4JNE5vYXhISbFrtaveRd++7yKTI?=
 =?us-ascii?Q?ziJffDt7IoDM7gBVY6i7y0y24DD+OLnC1G9JGlSg4CHv+/WsgBrX5d2llVJ/?=
 =?us-ascii?Q?VmOXhoRYZ1FBi7px7sWJrlbo6QEGGXkJplveDng11bqkBaWaKrp9SSVfwBec?=
 =?us-ascii?Q?XCERzUBrdxRNqDxhux/QPYsq0eOyPlq00pme7VsLvgvzn+Z1g5gRBUGarRXm?=
 =?us-ascii?Q?fwtz9Z14pvJIp8SR8IHdjyAq8NFf+C5m+3nA9CD99L8BifG1PRuaKV2mGcSt?=
 =?us-ascii?Q?tIyFUc1HvxlMkGKdWRtgbF0peKmWHxJNG62YGwpzAhF/bnbcsImDlGNB53+J?=
 =?us-ascii?Q?rqulHeiEhohPlgWehw3ZWSYt5ZCJT8QsAilMzavBeNBiE/zF0pwLVBdm+mko?=
 =?us-ascii?Q?5ThdixgNMLJLxajOKOEiudSw15BZz64e0nBseIPbOyBw9rREjDEqcnkIh7lU?=
 =?us-ascii?Q?h0jR1XUxi0Oj18LFu3AQOt3yfSq6HlV8dU8pLy9BtynW3NT1SI/39AVWePgN?=
 =?us-ascii?Q?AMb7Mx5iUCH68ShkP46B62PYA/EEwpUaNLjnnwzcR2DXcjgtUbDJexh9+YZi?=
 =?us-ascii?Q?hIqaxvK10V1eo+Uyl9km8s5jCd8XC3oiSgs3sAHB0kYZQ4juTgASjjh+F7x6?=
 =?us-ascii?Q?FXvRY5f7ey74O4rFL/nm7reCy5n+D2PmloZm11SicTsCTjOyJB24zZ2xghh2?=
 =?us-ascii?Q?Qoiwv8FewDzX2esJbse5ldtRrHZvL+ZUiT3/JPIHt2MH+sM7En7o1Wwuj3Q8?=
 =?us-ascii?Q?ET0+vYO9g6FddAIvqsitO0de8NmMIWXe1M94xqaPR83d9CW1qKn4881P+aGw?=
 =?us-ascii?Q?nnQaqAe0wzMPnA8mMnx8MIgLGCiqkhpIWUdSwg95eIdD7g/prLwZ/1cEaeo+?=
 =?us-ascii?Q?OpD+cd89DaaEL4LuETHE7dgCuveteJjPlbc6RsGGt6mvcsSouzetht+O+gUX?=
 =?us-ascii?Q?NRwJSq96BjfUjlCftwybiHDyMpTDnwF+1il9Cr7lUQ7D+QFSP0goNbM91614?=
 =?us-ascii?Q?7BAlz1aEtU33cZe8LWhxZrmYB7ZHoFLntLm4Fs7EF+LBFkuZyaEtWe5kOxlf?=
 =?us-ascii?Q?OBeY/JuuMmwt1ZXCoI/wCZYCur3OkUcIk5NDQAfwOouatMleiPUu3AaK2PZK?=
 =?us-ascii?Q?mJP401r61fqMDhBfJnXhFpw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c1e1f5-2a04-4d8a-290c-08da02a5994e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:29.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TtAPpNWvO44OtsRC9zqU95FXeaP/W0IDe8F0Fl+N3RFiWP3b65pJo+b25G5VtuFIqSb7oEH2KbkTHnXnWblfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic to setup the supported interfaces will get annotated based on
what the configuration of the SerDes PLLs supports. Move the current
setup into a separate function just to try to keep it clean.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 43 +++++++++++--------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c4a49bf10156..e6e758eaafea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -257,6 +257,29 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 	}
 }
 
+static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
+{
+	/* We support the current interface mode, and if we have a PCS
+	 * similar interface modes that do not require the SerDes lane to be
+	 * reconfigured.
+	 */
+	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
+	if (mac->pcs) {
+		switch (mac->if_mode) {
+		case PHY_INTERFACE_MODE_1000BASEX:
+		case PHY_INTERFACE_MODE_SGMII:
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+				  mac->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  mac->phylink_config.supported_interfaces);
+			break;
+
+		default:
+			break;
+		}
+	}
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct net_device *net_dev = mac->net_dev;
@@ -305,25 +328,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		MAC_10FD | MAC_100FD | MAC_1000FD | MAC_2500FD | MAC_5000FD |
 		MAC_10000FD;
 
-	/* We support the current interface mode, and if we have a PCS
-	 * similar interface modes that do not require the PLLs to be
-	 * reconfigured.
-	 */
-	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
-	if (mac->pcs) {
-		switch (mac->if_mode) {
-		case PHY_INTERFACE_MODE_1000BASEX:
-		case PHY_INTERFACE_MODE_SGMII:
-			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
-				  mac->phylink_config.supported_interfaces);
-			__set_bit(PHY_INTERFACE_MODE_SGMII,
-				  mac->phylink_config.supported_interfaces);
-			break;
-
-		default:
-			break;
-		}
-	}
+	dpaa2_mac_set_supported_interfaces(mac);
 
 	phylink = phylink_create(&mac->phylink_config,
 				 dpmac_node, mac->if_mode,
-- 
2.33.1

