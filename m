Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897F92A1533
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgJaK3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:29:43 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:28640
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726753AbgJaK3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIbMlOt83zHd/qcWAihWmUzqG+lKmf1WB4XnrYpud+ysqcdEmvh0ZoE/8cQtD4XXxO/Kg/UXRaPEfHaZXwjVUKJ1bv8QoaHFCYa/Bm4zp1N3Anpdo67ZgY/e6p5O0X7hHRZ6BXJsyczRiovOShJbmGUVe84HyzBCSAJ8Z4pqIEGmgdjxAA9Rrvwjps6yE59cyUbe8CnTXvGoAh0rAuyg7a1QNT768kwtIZZtGvfi1xBKuj+mgYfryxG0ZqXUOFeZ1pwBipDmWIIF3Cjq22DwllJrRdLuVuWdnR+e4zhKuYcn5M21hW5FOu4CzWN/Jz24hp0q2GePU+LRmUcXLGXDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfZn2CdJleb1VrEeWX7DxsdfPbGgOUM7dYtYsf1PVIc=;
 b=OERMC4Q5ZeFTeYsRl7l6YplgUGiKIrkNROCBp21p8nFv0H9BfoipWr4BhM0vVn8Zi4RLDJ8Y/TAPV8JT+n5hilOaFQgJXicu7TBIjZ8zFCzy9nMA1SxFFUvJoUg9Px7954EdYEvwq8VkJ8h70CcpotfjfZYk2vX2HfpL+svVNvykXaq2FxrVZGbqDFt3x4xPLLU7Yf7e7+vI0eMmdLlK0KFuTZZuDXyPthjnAal7iN7lHjeiF1a5D8VsGD0JHzDQhOVHsF0nMM2Oh5wDPDoGmGX9Q+wU0JTpX3JjiiliMv/yCkDyopwvAYfHNCz+yG3SGiF3/QAGFP1uunDn7KH2FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfZn2CdJleb1VrEeWX7DxsdfPbGgOUM7dYtYsf1PVIc=;
 b=CeXVvJfjsy6bhoAPKNpdeyhZuy/MV4t/1WuKdWwh70B5KoLaA15fzHvMYvVT1+bk93i8avLKEOXeaSSlnvVEOHSrmpdnAUy910HxI6Na2DWB7v31UlK+/tV8cUaA5nNxPypnsSCtMLw9UJFOWDXPj06FT7zAJ7EInUdqxJQ8QPs=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: mscc: ocelot: don't reset the pvid to 0 when deleting it
Date:   Sat, 31 Oct 2020 12:29:11 +0200
Message-Id: <20201031102916.667619-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201031102916.667619-1-vladimir.oltean@nxp.com>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR08CA0170.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d69e79cb-1aaf-4275-20f3-08d87d87d8c3
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637F7F277D6FFBC2812B587E0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+u6Y5oScT0FEQde4YIEhC0p9BY0cWrbHS3cLLv6LwRKqUjxRK4wTDuMtYMk8Du3GVA9jcIOCW8O1MmXVrlS3VlfQYBNWG5JTT9l2HkuBA+10snBGnu0Cky5v/eK2BIe6S5nHiL75lIHm77xXIx/aQdpNZmZyFXbiI3TgPAaiyqcyMHerIXjWcXCV3tkdLsIRrQVBnqo+RDakFtFgkx64gJojTdFHy8ilN/HBlZNxlokcXenqass74uqIIfHkKVqGWTgL8fAOwtg6pZIc8BihGSJpCUnPStKifzx7ICe4+GszuAKmX67KGDf2q/ZYmfoWAQ5MLMJPoEiAOWzkogPpaNDZ0CPzF+dD+csgPkCv5LD+FwrR02IzghSDPaeMzaiuOAD8xEfFAtfZu851hjDxXY4ymdYBBBh+VjQEhnDfKuBXxvN3XLN2aIXQGNULGex8Vh5Ix95jhnSPFBS0T7D8dmU+TZJsO3m9EVw4MwrTmM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(966005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PuoZd8IkoaCwRCX42Cg7iAUGyED+w4P6tsc5XeTh5/UuUS1zKsA4C5ZrfNd2h8Y4VZviOMZ/zsacuB1m9LrxhXoMrzoF9ERcLE/vCX5+Gf2tjhysY2ocg0veJx15uaZ0HVjWcbe6VB1gCeGOCAWgli4SGHbBPpbCJaL5Ks1XOLoBTIzuROVfiu2K6i8bwlubnccVHmGtTKcHEPzV8wgj7nGzzzDTT0sL9UeoH1p3I+v1pUj9saWUlyCvMH1/67FYeFhV9CR7RtBj2aA/xW/vdppLa8b0X39DyPTIKRFWZy8HZv5gjBizfV7WVk4p2Ff2UtVtI6BgRkFQrfu4lI6x1/53DosOS4BZwmGWnIDdA5qfuu+AQJdSVKt3OtBH/2wR615JFp2KHDw8WMbxRwDrj2IV7mEkHFoTEOQBPCyIe6M0VDzEhMMI6qB4gbs52jiBE1borZ3tgpINkQ0NR3JOvSDWIKWi3Wof750kDE4A3ylZPRxU5V5VKXDqvx+AOhjs38chqLlz8ICKWYPpO5b6h4QY4siYNqakBmAaO6ZDvByiF/6gDWiucZZropa2HV3cJibuF1ruHreW14Rl5piauG1cBooqkUSmKzXazzvih2Bvfp44uVDyufDZLJw+Ud51UpgO0Zp1OgwMpBGRt6ijQw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69e79cb-1aaf-4275-20f3-08d87d87d8c3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:28.6167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1l3CMLlyBE6yS3ewfeloPBoXK8UoeL1xJxHHkVqLYnQg1B8zigqYGc8bmntD2Fg40JaXhyY63CXINlCg5XCHIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have no idea why this code is here, but I have 2 hypotheses:

1.
A desperate attempt to keep untagged traffic working when the bridge
deletes the pvid on a port.

There was a fairly okay discussion here:
https://lore.kernel.org/netdev/CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com/#t
which established that in vlan_filtering=1 mode, the absence of a pvid
should denote that the ingress port should drop untagged and priority
tagged traffic. While in vlan_filtering=0 mode, nothing should change.

So in vlan_filtering=1 mode, we should simply let things happen, and not
attempt to save the day. And in vlan_filtering=0 mode, the pvid is 0
anyway, no need to do anything.

2.
The driver encodes the native VLAN (ocelot_port->vid) value of 0 as
special, meaning "not valid". There are checks based on that. But there
are no such checks for the ocelot_port->pvid value of 0. In fact, that's
a perfectly valid value, which is used in standalone mode. Maybe there
was some confusion and the author thought that 0 means "invalid" here as
well.

In conclusion, delete the code*.

*in fact we'll add it back later, in a slightly different form, but for
an entirely different reason than the one for which this exists now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index bc5b15d7bce7..ae25a79bf907 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -293,10 +293,6 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 	if (ret)
 		return ret;
 
-	/* Ingress */
-	if (ocelot_port->pvid == vid)
-		ocelot_port_set_pvid(ocelot, port, 0);
-
 	/* Egress */
 	if (ocelot_port->vid == vid)
 		ocelot_port_set_native_vlan(ocelot, port, 0);
-- 
2.25.1

