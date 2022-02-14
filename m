Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4C4B5E48
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiBNXc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiBNXcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:17 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580AE107A95
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bl3a3pROfu0M1d1N4AaBVPpUdkeeZGjBFQgmrsVFyWGtqui3L7qFcnc1MQK5EPE9EX1tMQBy1DWpO0s4lIag3RWNPs8uSg0qMjWP61BAuzCyQ1PKU7SPaZIZDKMumAvj87m10DaLvCndtdcdeZIOzta7PrpMEmqutsArBVAkcUPJcqqubkz6PwlBWhuBao+Pf1aQ0MVIG85OXeqHpuXiL2a+IGAdASRO5ViR5xs9h1/lIORAygangvwYOAdL/fQoNp8lGt4lPlUj3up5G2cXLSGW3bFFEhkpp3vl50x2oOLwewS4dc+/XLwFDzmZ3Psyv22Ud88u1nnvfn+pNnNq+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpcvmEUwNpamscYEpvqVJGH5WLF/yGAbv839RU+l8eE=;
 b=NF1x56MdWI9fdg3OEQ/PUy3ird04+ArwT13XrWLJH4YSZ4r404mpvALOBN0rVmN2nJlw5AlGN5Pg+kayHG2b9ZfXr5bLDu4JbXpJ0e03yxxMzCBBdXw3q0vMWlkGoR5JMTM6A0dl0PMXx1/UOfTcguQSnVnkeplEBohWpEN9Z/3m1nsNhWl6As5/VK1xEzWAWKgS4ti+MX6Sagxp9pCyi8DN5UhW/21S5mq4CWKvfR8zTIK8BD9JHv+0rtnF99C4SryqJxTqRF7PEhFQon/jeXJmMPgqsPYfaBqA7u3iVHgg4/SUUtnY6RobWNFs/QCMcM3BQ00jMsrfIWuMZIj0uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpcvmEUwNpamscYEpvqVJGH5WLF/yGAbv839RU+l8eE=;
 b=rjKsoahNu4wxadVcR1vXOeIZZgetlxHU6ESnzhpoB7hAYNQPhjaDbLlCCplW2lgPq5YAAq+q5LfjxG9hHRw0GT/kuxmxfi4HSKzLbCOGL2JqGolMEYNdEunkGFFus4kcbW+4VCAex5AtYNCGlaL48aC+XdR7KFuPfcYQlxnlpj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 3/8] net: bridge: make nbp_switchdev_unsync_objs() follow reverse order of sync()
Date:   Tue, 15 Feb 2022 01:31:06 +0200
Message-Id: <20220214233111.1586715-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8b0218b-d520-47ab-af16-08d9f0123694
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504136230EC34F548D2A660E0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8S+f0vTAw+9Ks35ilisq1+HalVB0GP3wSL6p2B0ENqC2hbDSZglWVHjZpZ59hCceKCzzIlTkaRS6Gvw77MSoXlrKgY+FW36MOULUne4SmOA1bLfFMSV6vD2yIOnN3H/oLYEBGfGwQC046tl86aI0ZvWDrwwniKuKm0f3oTOj4+8LVJtqRnzGc6JoHhQXiIQgT6h8ah99X1jNThmskdW5mnk4SgS+Z9roV9jSEpje9C2tc9rHXmMhHGRCgjXCATzvPkTuNDKOrokIr3RsfqipRzTYtVhfNxOI+YZkrPRxI1q+3+P5tmLK6cdiCZY2NikCkPmgc8efHzpuZMxJGOUdbLifBAbo5lgrzgl9sVngxJ2Fwikd28jvUz6PiIutSdpVMTs9hFMBGPoEhSdqiWfcieGflrofJ+zDlZEhoipz1mVOn31OtsZaJkYHhZXvuvaXNpTJ2I0rXYcdj/DupoGx7/n7PKuKatgVRfNIXsqdwkLVak7U5D24lVaLhumhfkvlVKl3hor7IYDHd40wcEqXlZD0YPM8vmmwf8Y3u/b3IpNWqICzE6hbBDHc7Gqlfz1jcpvzPcohRLKg21f9tdSm8CnHmR4BTOp0noiqHnCzU3NSYbDPDmZ6J9Nu/fvMn5bYoRDn887AA9NOOhWiwhLhmagnE4L2bQjRgNWIUVstvsOVZikz8UO7YqtUcZsAC5DPBAACSOPw1A7gk0h/bEeMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6506007)(52116002)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TedNw5SiaoQUHpLUaWr+XP3FeLLcbCJgwcKGyFUFNSEDNc+Vbq+eqhn0uXaO?=
 =?us-ascii?Q?f5hG53XcPS0f0WGXQ1bqg8UZ1cRWDfZfcBNaZOGqjP9kWt5m6ti1fR93hZqE?=
 =?us-ascii?Q?KRm7v7PGV7m+xINNBhscUglmQcwRxtRnkxgw+k2N9N389wUFyDcOFy2SUm8q?=
 =?us-ascii?Q?a5COMWU2hE/osa8b6nnKfsbmrN9nvWXpmxUGUXojP/wJOhcULvV6e5MilxDc?=
 =?us-ascii?Q?BgLeeEgQvU+I7v3FewwzyJvIXHv0tBgvW//NZks8GWIKxSKRBfZQGgTIuMvu?=
 =?us-ascii?Q?4MZ5hu0JYZ0kjhuKA7W2uZaxZ2SEj2U7Hdqw8+vBfsjew9Yd/v4RyTsPy1CW?=
 =?us-ascii?Q?sF2tSg3bQ8EdDKnCWN0XMAFnYRTOpnaqof43FaaB28j7AVRle+0SEBkt51Ay?=
 =?us-ascii?Q?V2cEAmtnl2FNwCZapamauwAu0QKMXxK6qFR4mhCJ9Y4GQgXGEGQ0QJo2CMr5?=
 =?us-ascii?Q?eKydC5/M6krUpm+RQgZeFQ6HrTffx75X1D+Jg4aZTPBwKbApyYr6MBNjn8NU?=
 =?us-ascii?Q?3+5W0pS2TFueiabkFkkPjKTSIF6UmklBGKLhFA+VNbxsMClp/tnCyeAV5/e6?=
 =?us-ascii?Q?9qZb6op+BKaNGGkLahw485okpOytZUGdq2OVxELMQo+t8+wmkEiRDZGPxSjc?=
 =?us-ascii?Q?hYHH4hOH7tSB3iKGxDm6fB79tYywa3pZZv6L+KL8RvMzmkaypEvIno+HY3iS?=
 =?us-ascii?Q?+fI4pUO8+xAVJ0+mNNA8oQp/U4isksAGcXSzxsSZXfMWHb+XSNtCQP2ABbLs?=
 =?us-ascii?Q?WUADuZqRBgWAHs0aFBSey0z2YsUMJFL3vDf5kf0ON2xv3e1IlOIZ7NZV/GDu?=
 =?us-ascii?Q?9Hd/8sqcDoJn+eCNrkKRUSxOnXuXUtCewru/om9fR537+jKNmQ4ssJvA6iZe?=
 =?us-ascii?Q?GZvPtHeeXUQfn/VzE92Pxi4CdSRkz5FYeCBRIBorZKUd+hEqWt8tPPVBeNWM?=
 =?us-ascii?Q?iWPw43L7FvVF21jtohdyZxkT3bgyNu82Y9l45qqxce27DGQSgjjwi4tDnSPM?=
 =?us-ascii?Q?gMRcP+QjXsNpHr/4CsQh8BMtqc3AVuqLHMlqdUUmhUtaONQ8ym6RTfssAsZ+?=
 =?us-ascii?Q?1VDhJ8GB+HjWPr+ogjfPAFLvZsrZMBDGmAxij8qwRZK7npgOPRPByIoWv0+o?=
 =?us-ascii?Q?kDwaO9XZAi5Vv/wLcK0y5wiL+PFR6IJVKXzXTQtFKKmLKuJtX/VH40IMGU2d?=
 =?us-ascii?Q?abNQiX5or7ilvVWhxU+OZKl7smcUT3rE6iKKuEVwqgANPEbytSA6+gUPs7pR?=
 =?us-ascii?Q?SkHnu+aP8vI5NYP+6WHknROBG3JErNwGNT0y5/ZYphv/heuL8RwuuwjBxGqW?=
 =?us-ascii?Q?/y5gUeOJ+div+8MbGqCHSGAEqwRxfa4eAdd6vzqBOs7dj6bjotA3JIFVg8+s?=
 =?us-ascii?Q?Sr4M4wE9Axq+T9+zWgu6q2gR+OCXAzDMT2anoMC80Vgn76ZwoDZn52Q8Sr0O?=
 =?us-ascii?Q?aWAbLWK/GA/qDM8c+7tOH0cdXc/ujHZQlPizmgXh8CCJ+6kRh4/7S4M6M38e?=
 =?us-ascii?Q?5I9Bph1zMoP5dZDZIKoT0pG2XRktD+7d7s2yekSMX3qFMn14xhSzYqC0Vp6s?=
 =?us-ascii?Q?3uvy7LCen9SYlYCtLy4tugDV0S2lPFAY8jJj/u3STYUrPvXYuIglrHvCG0/0?=
 =?us-ascii?Q?0QAgfOaXJcCfKq+plqV+EU0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b0218b-d520-47ab-af16-08d9f0123694
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:06.6833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TufGQsUgF088womcjSJ+LAGU0SBr2SLZM0q8IPxGWWmirDK95VSGtC1LVeUsgyLvIhR2PjcsvL5oRD0MQkpV0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There may be switchdev drivers that can add/remove a FDB or MDB entry
only as long as the VLAN it's in has been notified and offloaded first.
The nbp_switchdev_sync_objs() method satisfies this requirement on
addition, but nbp_switchdev_unsync_objs() first deletes VLANs, then
deletes MDBs and FDBs. Reverse the order of the function calls to cater
to this requirement.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/bridge/br_switchdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f36f60766478..a8e201e73a34 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -709,11 +709,11 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 	struct net_device *br_dev = p->br->dev;
 	struct net_device *dev = p->dev;
 
-	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
+	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
 
 	br_switchdev_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_switchdev_fdb_replay(br_dev, ctx, false, atomic_nb);
+	br_switchdev_vlan_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
-- 
2.25.1

