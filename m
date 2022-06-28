Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175BD55EAE3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiF1RVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiF1RVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:21:03 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2081.outbound.protection.outlook.com [40.107.22.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA1C37A9E;
        Tue, 28 Jun 2022 10:21:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzXxlSXOj4VlS+1HlshoyzALavQ6TQYyJYX8UxeHj6ri3lU6ZU2xIOzcqm36AQ7I2IzQV7fEqmF7pC01AyAnusDRXEuIN0P7WeRcUAD6YiFuOWSkDaARAKFJZJcWWGvP7pYbhaJgQDQK0IH5m/p3v2KbAnzvMABbg0vpwDZWIrrji7iyRghE2yeohS0i0108jQ1PGn7GlM1+1jINuk3FE6Ym3QOtAdZKewd/d6+UXKmqPR4gBL9CIYXweKnEC3Bblruzw7vWH6Gd82a6BZ4jzauC/BkxKZEcoKP6G+p99vUTZRk30l8QYPyjwX2OobJx31Fvr0NQYrIh/DKjr/cTbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yt85gRdonE63hMLAyPDC2Qp7VmJtTfIE0XYPAz6E8mE=;
 b=Iv4bBT2OC2Ob0zN/SDx8nusYIpV0uZ4Or8/XJDHys+3EZK67cUCzq+avNFiMERHvgo95OOvzv6wDYDC6ZAwaVAf6EjIfsOvBTWgYbEKB352ROom8ghtCSFbeBkgEhdzOGtlqlYlGY+IJtc0wEK2yPn/jCl6StMVNsF5f2QtXycW/Mw4P5uz69OQVjsTfXtJ0CEy+EQmKtiFt/nGDSRQu5rAgeblGIHuno8r0eT2vtpKFseiEV4bUEOEH3UFmcWMEjAX+WN8doTygWzQFbkm4pBc+VZICEFXScYHIoFTVdW1Zyfk7avsyPA+qosf1lhQm85nmq2bhPNb3MOBxy7P42w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt85gRdonE63hMLAyPDC2Qp7VmJtTfIE0XYPAz6E8mE=;
 b=eGr7rM3JyE9MH3meNsBFjWHeSs6ujnMgMlo91EvWFVkaYGoXMznz/kS4LoX+5MeWIM5hEpI320xfq1yqE2H68aG2U2KV8eYJlkC/P60qUGbla1NlDVUmxjEP4HjGWGeeMd4XUIM3qeSJdzx2yc28cK9nZ1Z1PRTWsA6sHVE2QTc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4337.eurprd04.prod.outlook.com (2603:10a6:208:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 17:20:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:20:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>, stable@kernel.org
Subject: [PATCH stable 5.15] net: mscc: ocelot: allow unregistered IP multicast flooding to CPU
Date:   Tue, 28 Jun 2022 20:20:15 +0300
Message-Id: <20220628172016.3373243-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
References: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2666695e-4bbb-47fe-7df9-08da592a8f74
X-MS-TrafficTypeDiagnostic: AM0PR04MB4337:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDhWcdxPxMFg/5Mh3ZuqG6f7focKfITZSO5aAuScZ40iRpgHAircabenTOAp0jWQT9yXt8CLSUkh0OV3cxEaFDvGAF+JO+BMSNj6z+X7q2NeJsQuLhUqioCNCSPs0WoVAPPCKwHmzX0+1/6HtHzvk4YLcgSsTNXuitHjdGAf6xR0D000geBxt1LWtVfPmWV9cY0MaVMhOJUvme1Dz5tPOhouLeuG6jVrkdjwS03TtHGCzIr5tg1NjTrq8ap09IjUrnhWhNJOHQ3FcApox1a8Tb+IEfA7bsbNmVDonKQdX+RBJZcS0Xf2ejbtskcoMrrvB8ohuJCNfZFIS+jHaQcLSUNquuAGMLTgsXD3r+gXzVPinQvOfXfnX1rZy/Qyehwoq/p6IEnkdQojlQoHWfsngoII1aKvZD5aCqht8RkjcgQo2jX0i4k4pRYuVoE398EMjoqxU+f8XVELZAJDoZf/QT0RTUSi70CUWQRcg49EMyQGAzEIUK225RF5LbneGGMlFFNmUYXfIEk+sf4GWGToSV9vkSR7kDIpuZUXnpGN34UWaXKt0e06Lmmgh2KpnpOnl8KJt2jlcdovwuEIChQNAIJRt2UIXcwxDUInV7ohJTedIeh6dxsmzIotGXEIyDPT6RdNQVHSJZl34KmmlF9dwf2VdDGHLsFVNxTYUSC7IIpa3r7Wic6xZvWT3ZR73zpBMW7rXIAh1CVcbbYTYenqzz5463VBMt+avUwGBdK+p1eSAXBSaJGBX8EHxLjV6pWdewtdfxSGHC3FSSwPuOJegkVr6C8woiEzSs1GAck/w1I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(2616005)(110136005)(38100700002)(36756003)(38350700002)(5660300002)(54906003)(2906002)(316002)(186003)(41300700001)(4326008)(8676002)(52116002)(6506007)(26005)(86362001)(6666004)(66946007)(6512007)(7416002)(478600001)(66556008)(44832011)(6486002)(83380400001)(8936002)(66476007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pe00BnjwdGUvrHQ+zyjVjS09qK1051f5AqQLUdv9/7yyIBLbyTmKog25Kvxc?=
 =?us-ascii?Q?jXsFBJ9MFMYmUM9xsI03wGtUHAiJB6V9Nam+oyyR4d5eDFfZo8Iog5uifndg?=
 =?us-ascii?Q?KQPehOoPQMiKcZSVA9RvrPDEVLKvrEaN/bAY1QcOUsRLKOb8vE6Do5O/dv06?=
 =?us-ascii?Q?FvA2gjXCL2FHpoQO0s3EQAICLMtJBk21RmF+ZrYhZUY/KrXpk27CLQhVYov7?=
 =?us-ascii?Q?kjjz44D+RZYqM7jNN2wPQl0Sln7M89MJGPyUXL8UwL1uCCRNrAkcTKsonHSa?=
 =?us-ascii?Q?XnfE+19Gv/WiPJd3cdAzZD+56EEhGMeVSTKIIbvdE3frQoVaMPumBQ4qHpKX?=
 =?us-ascii?Q?ZDtmKBlAWOpBj0xRjZv1d+0SjYM5ovQ0TRyO7fuwL3jlGVUqHnGoPZQ4e6HG?=
 =?us-ascii?Q?jwvjmsDxUQ/JT1oivI9Yo1CwCoPeh7/P6FW53Y24vR3u/QV3mkzXvV3voj4o?=
 =?us-ascii?Q?vtwbnKBKDatkwMMpm7ySo8DpcNAHdVDRzGX2rR7QrMYodkWz6e3j9lClCL4L?=
 =?us-ascii?Q?F9W00ClrzkuVfY38cOM4FBYYeTR0qfwDcRh2yA/ZVBLjNE4cICegzcI3/fiL?=
 =?us-ascii?Q?JsTegrwHsLM+sL4P3Tux4tMcFsbAjgAwTQCuz9mhxrsLTjZTRofYC98pxUah?=
 =?us-ascii?Q?CsfLaB15mVd0vp3vTNetusN/DP5XfRvkQABnh5xtutsGIxLaW1fh4YAqFtNw?=
 =?us-ascii?Q?9t8B0T2N5yJxGNO2r2sWi3mS0qTDfw0ye/9wK40pucRXUGqDaZy0o+EO9eHY?=
 =?us-ascii?Q?/csgN9NQlOSszt0EayOVds0BuxNkHJL37hkw1OAlWWWGCGe/dbs/yhV6koqi?=
 =?us-ascii?Q?YZIvc5srFOapTX4YC8yugN2FhmYIGS5g2Rqw3WuaGhBMfKrVnnpJ/qTtm98+?=
 =?us-ascii?Q?ZYQsILjKrXlttNW8dljyqr9bsZUOj3y3gI4ftHoF3+e+6hQqYXKbKwKgwzzu?=
 =?us-ascii?Q?V/wRteYzXO4cMiEDDnJbxEFh7fxmioLOnavvFVLrUnbF3QOPPPFX4Yl421jU?=
 =?us-ascii?Q?NdPW3ndstzZo2Lp9YgAJbwaIPDdZo4MaWC5HDXAYpXqw4FtXXeuhZH33STll?=
 =?us-ascii?Q?nDzzxNJO8GIK7fs7zZ4jQGLec9oJsDTk8+aHPTkoenuP4kjjm279eiZAJflI?=
 =?us-ascii?Q?AZ/J+JmYM823UMrfoeTI4rj69mZHst1uzmkvrTGVrknhAC7KXX4Jp6JXTPMp?=
 =?us-ascii?Q?A4gGyi7OAubOrLoJJT2lI3nvfXNa15eq4C0dIADi4LRS6C9hr00D9dH01DGc?=
 =?us-ascii?Q?LUH9m7aMoiOZRTNvKKnsUnPHEDF/S/n5LPDKCQwv4ugbZPGTkCB7aC9BQZCI?=
 =?us-ascii?Q?aCwxl0tIJFpPg5mdFdH/kaxyVicRuM7T0LxOxvchnb8a8v4CV4e5Xr+sMbHE?=
 =?us-ascii?Q?dLQ508xcH1MBMXOvuxjR/x4lkEfKioxmt97NMrkkvQG/MPmymZvz0hm3SQwm?=
 =?us-ascii?Q?KTGhpnq3H5Puf8W19lmKeciKXw11HY7JH7A5nxrRhMg6hnLZSI1SFWvFfQHI?=
 =?us-ascii?Q?UcS2bhN2hwmqMXJV0TxyQOM0Fo+D/Ka5Tia3YedH7vSviBUGFuRsdTwhnPOY?=
 =?us-ascii?Q?LQJwfi5NLceA6GquFOzrEzevNTjr/z1J+MoTgXo25i0KGr2ZJgZMbp7nvWdD?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2666695e-4bbb-47fe-7df9-08da592a8f74
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 17:20:55.8496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fhc0UYEdfPKUo2sNaehj3QcYb1mtFgS2IuYMA1l8Ficvh/QyLTmMin+KUlmQP3ZWgVy9SqRzRZ/XlrV7UuYz7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4337
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 4cf35a2b627a ("net: mscc: ocelot: fix broken IP multicast
flooding") from v5.12, unregistered IP multicast flooding is
configurable in the ocelot driver for bridged ports. However, by writing
0 to the PGID_MCIPV4 and PGID_MCIPV6 port masks at initialization time,
the CPU port module, for which ocelot_port_set_mcast_flood() is not
called, will have unknown IP multicast flooding disabled.

This makes it impossible for an application such as smcroute to work
properly, since all IP multicast traffic received on a standalone port
is treated as unregistered (and dropped).

Starting with commit 7569459a52c9 ("net: dsa: manage flooding on the CPU
ports"), the limitation above has been lifted, because when standalone
ports become IFF_PROMISC or IFF_ALLMULTI, ocelot_port_set_mcast_flood()
would be called on the CPU port module, so unregistered multicast is
flooded to the CPU on an as-needed basis.

But between v5.12 and v5.18, IP multicast flooding to the CPU has
remained broken, promiscuous or not.

Delete the inexplicable premature optimization of clearing PGID_MCIPV4
and PGID_MCIPV6 as part of the init sequence, and allow unregistered IP
multicast to be flooded freely to the CPU port module.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Cc: stable@kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a59300d9e000..96b1e394a397 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2206,11 +2206,15 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_MCIPV6);
 	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID, PGID_BC);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
 
 	/* Allow manual injection via DEVCPU_QS registers, and byte swap these
 	 * registers endianness.
-- 
2.25.1

