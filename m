Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0723E7D53
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhHJQSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:39 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:16133
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234949AbhHJQQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:16:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9ef76Hf91p5VL94JtLcn2LKidZdHkqFqZZ1dNQhptF+GZOHCsJvLFopDU98E5X1te6qbr47uIEiyiQiJYGTFK2SvTuwQE236h233bpXZSB8COUGqZuD3GpWt7gUY1I64gySUMLBBk9EqwXUaMoAk2BrWCZbJjdyrWXVxGQti36FJG1ID23rtJJSOdwUW4+zKK7wklGCVdxg4iyNN9/U6tPLTvF+x+qda03kmYsC5Wtm8UQu3OYEIEXqB40xcKLjwqAlDtJ1JlkRfLfSnFSB4A9fsBOztSrGvmTQqlxVreqkVzcbP4VtwZMME91tBeNNAKj48W5c5xtq4Ih6ulS/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSg+LQ2WpNMKg39zpGqlDDhOcqp5TcKXUt2vMkBXq7c=;
 b=hud7h/E0Iv856Jz2nQWVTmD9LGWAxb1uqC4s1PVhmuFJe24xkOS2hdqmHNo00jjB/jey4Bzg1Di0ENKbAzr29Iz0/GMaKficpL1l6BhP90r7K/O9IgCWhNUP4YySRkTqeIx2PfGnX3xzxi8Sg9UxjhMry/l0YbTAwH51URAT/D67a7NoyaCJJBqSSO8QmjYAFcE83uwpIAgNixOsgmZoVcRGpBLXLrEst1M126k0JTPmG5ycBskv3R/ZJyFgX++S6QSz1EriPsbWfPQ+VrYeMjsdQPvsbuheNm/s2u73w2zddWbPr6zCfKPtLDI/KF1CvEGlwQGWD6NE3bN08gC2nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSg+LQ2WpNMKg39zpGqlDDhOcqp5TcKXUt2vMkBXq7c=;
 b=F9Zk1AeBEPUqgk9J6esb12Mcoz0B3uFYnVSXRsXewjElooqxMTuivKi39rH5Zo51YK12cWE6GYtZVAPQf2XhaGp4qMcukRB/nl7FoKYHtVwZxqerKnZxDickjiuV+fdCXO+RQERNrKZjwBvGRaMd3rp3xHOzKCcjl7/i/W4D1EE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH v2 net-next 8/8] net: dsa: tag_8021q: finish conversion to dsa_switch_for_each_port
Date:   Tue, 10 Aug 2021 19:14:48 +0300
Message-Id: <20210810161448.1879192-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6c530d1-8de6-4e31-98d0-08d95c1a09cd
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28000A90B6192AB45F69D4DAE0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2//ioBCnKO8+kpf4ih3gGrExEt5WBWwcG/txkR2faIBi3lnK9fJ08RA+HoXtgEhqLMvHjx5COnQkf8ZxqC5ogHvOlokb66nnj9yc7wPzxX6OwMpMOf6K8ZU9uGplv+23FXrLHnEL3ssNL5iuVGvhHrW0+opQv2PbZB+EwyXYnKjErfuK1WtUjY7xPJDqwaJYp5O/R4CbtSvqG+mSs0RfgswurxkneTFwVRWCh5uVhfGcKRDtNNNSunvem7/tMktRhty9YtyQpPh+aSJGBTv74XyoZP9GkDGZLnu8lYQpI9TnT2tZbwKKtwGDVBS68rgvTmJDZF/GELP08YkOdxS16nFAXyfzzjL6Me0Hh7PGixmz1BdSdgO9nr6pg6RKbaznMPHjujzIdDwjsjkW/GcClCsiKA4Q8b4mZ4ZQJ5kR293pTjT8Lc4hjiIhJk24c108krm8ZgNOP3/EAcptuENIOqXTcrdVCf5/z/qv2lEeWrBj+rVH0rauAQ1aHcbwzHKlvFgS8ezyOlISh4UeOaHUWSCnIO5BFnBku+JUVrziIDxlIKDpGraThiW/IOTQ3C8saIB62tuLx0hCJDffsSEoY/O40v8kiyIhQMtcUKFbkuVkfYkuesmISM0Wakt59IT6WKlL3o5tBw7kKnRY47SRck6+PBGUolFhiK8Dn+tXr83AcxcTwxRI6qlF0SJsUOyV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(83380400001)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(7416002)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HJo0FhDl2LkIqOrXTMDPoKw8eNBK6mAJf8DPJ3+2O1SoD4/Ws98vlvLJoiBB?=
 =?us-ascii?Q?K75mAfMRi7352trF8OmLkI3ec5hLguwBkhu3NIsq3UKPgXZITGS+JB6SjqQq?=
 =?us-ascii?Q?IjGztZpFonOCHGA9P8OOFMQxfzmMuJS6vQatPH/ltxz4STD/MNbnf3rojR0F?=
 =?us-ascii?Q?sqouTVGv9lTyIlI5RRAsqPmluo4x4myKM7uaozFwP5K+kW8CxvlYtrCheAMY?=
 =?us-ascii?Q?KZyajeqQUtpdtYm1K5rgMzWmB+5k/g3XvQv6fPQpbMOXCNYj1f50+yKtErbe?=
 =?us-ascii?Q?jG9s04fP29Qmb2GHBcJan7KUE3Xckj1WY46QrnfYeJuMR/z2HAGREq2V3Rq5?=
 =?us-ascii?Q?a07zFl64Z4g2J3V0lOwsZ/9tyGo9+Q83S1HSOp798FrBPj+bO+xJDP+0EiC8?=
 =?us-ascii?Q?SxEvoqUoD7Jgm+osVDxbk9VmeLLUdULVCtmxLzTp2nP6vb1KO28BN0y/LRSt?=
 =?us-ascii?Q?bS175YWhRrBCcURwd2dEIAddnH8zRvp6LH3ByGxzFaxIAhQ+qw+gKNwgL1+S?=
 =?us-ascii?Q?YVCAzynE0GgmXdp4yxzyOv68fh+Tz9ZG5gegaEITILt3lb9rWlKlfVOnLO6e?=
 =?us-ascii?Q?tLa3aJwALR/I5Vn7YFH83kVH9XBkB1NqTXOM0Dn91joRXCDS6dCCXxe1QviR?=
 =?us-ascii?Q?dndmKb1XuKljtyGVvZog+Idwoe67v2e0TNQJKjiWFJ6X/oWa4wVZUNVygWvc?=
 =?us-ascii?Q?B0HU6BuHcqph5QHxJuMQMY/me4yE8ewbNNLOU02CuyrzwHEfO94hOZxEEWNF?=
 =?us-ascii?Q?YTmBzJja9d/vlAlaMwa39LPZcdHPy3XMkFGx2irl9bJssD9JJ3k5U9LHQN/G?=
 =?us-ascii?Q?rY0zaf6MYE7+UMR9exOpKITpnPy2T1OmZ809YLZlQjnwOWMeTskufizXuQzJ?=
 =?us-ascii?Q?fH+I7UozHVv2NOkjn//BfMF7eWmHVXjy8RBRxLzk8SGUYo1gJWW0UtTYQiXf?=
 =?us-ascii?Q?Iz/Y44tmt5xWpa+jf6GeBzhItdnFh/m1LFwI4HBGMYSxI0xBEl0Fpvy4s2qb?=
 =?us-ascii?Q?2Z92R2Epfg3YsNatsHZbSstpgASHpqRIYatdauLQLGWSNVeO8RSYjZ1yzSPY?=
 =?us-ascii?Q?KRab3QpfXKClK/Ub6dXA2KP+kn33smy8TpmNsDXYQWg+GAIXZcXTx+ZegloM?=
 =?us-ascii?Q?QmDezHoGMG7tzMxhXZcGjMQGIgCBwYCmycNlftoUQHKsBImNFWAYKqL1f/Qs?=
 =?us-ascii?Q?okZGBasauCqjIz4g33AqPKWbBfyXC2n+LpMx4WGEbfm5bvBEY4Xe5cpLU2d0?=
 =?us-ascii?Q?a8IQM0tPfHVRKbBcLaeYfDMNY/f7XNR0VGYeuWQagOv8hrj9OUhZZCJE/o38?=
 =?us-ascii?Q?r5LS7V5LNt1P++19dfvw+Yjh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c530d1-8de6-4e31-98d0-08d95c1a09cd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:15.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzsm4T6fxTC1SdybmtmdnmXtYOurQPOg+ksPA0r5RCayvGcX/ibkZiUG8+CFaGxNTuB+b2ubW88/BN8xH7SLDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tag_8021q cross-chip notifiers have been converted to iterate using
dp, but the setup and teardown functions have not yet. This patch makes
that change.

Note that we jump directly to the "for_each_available_port" variant
because it didn't make too much sense to set up tag_8021q for unused
ports even before, but skipping them was too much of a hassle.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8e4fbbfc6d86..9e7c6b46d62a 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -428,13 +428,13 @@ void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_unoffload);
 
 /* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
-static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
+static int dsa_port_tag_8021q_setup(struct dsa_port *dp)
 {
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	struct dsa_8021q_context *ctx = dp->ds->tag_8021q_ctx;
+	struct dsa_switch *ds = dp->ds;
 	struct net_device *master;
+	int port = dp->index;
+	u16 rx_vid, tx_vid;
 	int err;
 
 	/* The CPU port is implicitly configured by
@@ -443,6 +443,8 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return 0;
 
+	rx_vid = dsa_8021q_rx_vid(ds, port);
+	tx_vid = dsa_8021q_tx_vid(ds, port);
 	master = dp->cpu_dp->master;
 
 	/* Add this user port's RX VID to the membership list of all others
@@ -473,13 +475,13 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	return err;
 }
 
-static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
+static void dsa_port_tag_8021q_teardown(struct dsa_port *dp)
 {
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	struct dsa_8021q_context *ctx = dp->ds->tag_8021q_ctx;
+	struct dsa_switch *ds = dp->ds;
 	struct net_device *master;
+	int port = dp->index;
+	u16 rx_vid, tx_vid;
 
 	/* The CPU port is implicitly configured by
 	 * configuring the front-panel ports
@@ -487,6 +489,8 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return;
 
+	rx_vid = dsa_8021q_rx_vid(ds, port);
+	tx_vid = dsa_8021q_tx_vid(ds, port);
 	master = dp->cpu_dp->master;
 
 	dsa_port_tag_8021q_vlan_del(dp, rx_vid);
@@ -498,16 +502,17 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 
 static int dsa_tag_8021q_setup(struct dsa_switch *ds)
 {
-	int err, port;
+	struct dsa_port *dp;
+	int err;
 
 	ASSERT_RTNL();
 
-	for (port = 0; port < ds->num_ports; port++) {
-		err = dsa_tag_8021q_port_setup(ds, port);
+	dsa_switch_for_each_available_port(dp, ds) {
+		err = dsa_port_tag_8021q_setup(dp);
 		if (err < 0) {
 			dev_err(ds->dev,
 				"Failed to setup VLAN tagging for port %d: %pe\n",
-				port, ERR_PTR(err));
+				dp->index, ERR_PTR(err));
 			return err;
 		}
 	}
@@ -517,12 +522,12 @@ static int dsa_tag_8021q_setup(struct dsa_switch *ds)
 
 static void dsa_tag_8021q_teardown(struct dsa_switch *ds)
 {
-	int port;
+	struct dsa_port *dp;
 
 	ASSERT_RTNL();
 
-	for (port = 0; port < ds->num_ports; port++)
-		dsa_tag_8021q_port_teardown(ds, port);
+	dsa_switch_for_each_available_port(dp, ds)
+		dsa_port_tag_8021q_teardown(dp);
 }
 
 int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
-- 
2.25.1

