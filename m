Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DEB43522F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJTSBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:01:30 -0400
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:33959
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230311AbhJTSB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:01:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjElK84jd/UwrSeBggY+LvySl/iDzKiiMruAgdwBvcPal8DlwXy8m0oMf8Y0rhVbiGYQ60u+kWFH7gJ485ge3Ha+sBc193L4t5B/gT3vXOUROt9SjU3x8jKXnP9oNlmwaFPkabrpewMMqN+j2REEZTw9qTKjB/JA9TQ6Ba/FrFLu/pzmTzzA4s6Sp2ciG8mDfwgMvLL+/jN42i2npaRYp6oDWfo5Hurrp/YFrBE621Iu9f57bT+dSnN+mlFJBGyY5spK9BJwaRqJat2uuE0G96MXfFE56c3/LhTREWw9675o5ID8jPqvkw7IrVaqtRD1ybnj3vosWNagHs4eGMgyig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUdJ2x9gGvWf48WL7+p+ZRMABZogoO3c2AM85VhimNk=;
 b=a2gkBgE0VZFpC7hKQ/JT9YNS1gm1jhiNmlx2m6par4PyRuKEHYSAZtmzPCWo9RVAcHA2KqnKI8uwtS26pvxK3/jPCPgQ7NM1zIXmPG+L8woA6H1ES0OkS0TdwF8OO/CuBQAijKPFagDul8phyA0gEmgQ1IoDMDg4LZwJObyRXM9ekFM5lKsAAJ+0eYTqqDi8CoeW1DdD0ywkznV6xJe8dTLJiKiSmKSPk+5RZAh58Mu1atnC3WoKIY7LvHeir499JtJGIpwWuZCuZK71GYmHagpL6WP7esTBwgqAnn7kcXDYgRhdArIa0u99eo/hBbImmuqtUQZmX1h85Dtnq9xGvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUdJ2x9gGvWf48WL7+p+ZRMABZogoO3c2AM85VhimNk=;
 b=apiieYv7p/fGlta8zXHedzARSZ23h2oezGVEH2USV5b6uULCM+CJ0dY1qyOIiDQJTP5Jq5U+pg+DFuQCAq+P4xVGggRcP0wJ3B8HgqXex7iDTiP4wayFwZF+mCSRzZ/t4/1wZwQJNhfXMeddOnWIj849jceEDwe5u0rPZsZ8Uwo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:59:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:59:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 1/5] net: mscc: ocelot: add a type definition for REW_TAG_CFG_TAG_CFG
Date:   Wed, 20 Oct 2021 20:58:48 +0300
Message-Id: <20211020175852.1127042-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
References: <20211020175852.1127042-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0019.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0019.eurprd08.prod.outlook.com (2603:10a6:208:d2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 20 Oct 2021 17:59:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb4e639-119f-4414-2208-08d993f352ce
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28613D7703C50E7067977DBEE0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8VF2crtAk7C9tcYtNnRBh2sLs8TtST6HCzpnJdmClsX6Dfk8uVDZlQORGM/3uYte4PBEDpIcseX+h926tXDoHjgrgrd2rKD+oLCeSJMlQE3QW/4ly4LresvIBnRO4YMkpjsaz+Wd7wGfDfSoemEcBly7tBahBVMoeYW4sIWVXe5EC7qYwBp5U5ArpqaeIZ+W1NabMkXYjUghT5QwQusejpURQpjZ168AdZYsg3SbZ6ny8Ejl3ecs9VUGyNnMvu0qzcVZ4rGbacDggWd5TMGZoly2D+DvzVnLqi6gPymF1xosv9OFMzixdRZ1eVyMSdP7R2XgLpvISV14D/AM646ThozmxyMQElJOXJofvDUC8nXXCtTJT74m5ZzZ7otHQh8Xe29g52+abAk9sMjwrB4pdI0U6uar5bbEuSs7NRIGW8VpGzMyRp2L+QjvGagWP/6bgOImLTrKia7KTAbRnSHO0wBbhgZ/XTeWH0UV43SpcurdwFmi2ddJ1Cc2TZ2Es/RrNDO+0uOgBbfw65xQ8Qx7aG95gMFQ1n/kw0QDludr9kDCqCI9aalwEirHHRBwGMVlINKgjHaUwCo8RxDiPEi27mwkp86k7T2znd3oPgX/BUiwV6xVoIxFwjs8H8lPv+SOC2MWfP9WJnWOkNbap38fnxHhXj4nKS0YMISjaLtcIwaDTpm8LPgWnPbQgkKUqLXzlkEJ0CBuAJVtnuMiS6Lzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6636002)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(83380400001)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uuZjkBgU2n9emT6Efkp/mNguMT8u4mGhx/1zzbrW54aD0GiBl3Eciyalxmh8?=
 =?us-ascii?Q?TlwNZBG+4jECxHT5Z1XcR/ARBl9F6h7BUK2x8LRx2UnhatGghjbOXbL/24/M?=
 =?us-ascii?Q?Hgquqfake3onttSUrCkUOaL5XKL2AprTcPzgj0bFZ9f/ghKS+ooVSFgHhpB3?=
 =?us-ascii?Q?sLQzV6MY03AYBtwSN9Y9D8WSNzEFLsGkYmWLvKFsZsJxA16282Qf3e8OwIZq?=
 =?us-ascii?Q?l+rXzgdHzFFzkCX2C5hrNjKrRFCIHxiXngzLSRHI2CQQLRV+ZmBKz4HZmtma?=
 =?us-ascii?Q?+xXPhgaoe+iXTa6HAtteU2AqufxQ2hYAmPN7bCyQd5zj3frRtIKRyWRdn13x?=
 =?us-ascii?Q?JK9u028ayR7bIYfI0UsLdTRnCOwPxXdp0M94FDQCIwPpNy2aw3IVth56vycz?=
 =?us-ascii?Q?T6eiXiVHwMST49bEBzV5DeMwRfPeLa5DgWej/BMQk//GPbRRVRvpbfGbNEHU?=
 =?us-ascii?Q?31AYKapDxq1jXMyGUnfWhGPbrvQ1Nao2XE8YU+KU7XRaJcdpmZxfnjLJV38V?=
 =?us-ascii?Q?94CGZakcY8UeWnpv64tKgpAgrD3WLa0ayzLNsuBHvjYKje3P3FdDMaOF4ohV?=
 =?us-ascii?Q?nqkaU07J6W6tQRQw6mGEbJt3ZHmy4knY0hmB3auy2Rwma/2sJ/nV1jGFWsY2?=
 =?us-ascii?Q?54IqF9fqgNVVUoH/BONgaihUjrymty0MAJyCI/2ePVcoFBfrZwIejuP9d0vW?=
 =?us-ascii?Q?xicnTjoy3GRiFYD93Uk8RCPzt10gHyz9TX7wDBVp/MtdjX3FMEzXfVSZ7cvT?=
 =?us-ascii?Q?UnSiL+ekrvpL1oifXaB1aolfWWdsiAYW29o/+3wfCk35gQnn1VwjvOpdIvb4?=
 =?us-ascii?Q?B316YLOe9gwQ5uwFoRV/F2DV5rSp0Yq5IKayQl8FQsNp5zKKPZLqEi0KyZ7K?=
 =?us-ascii?Q?1b6rPHpyb58EZ4exT080XZk+54gOSQ6zQJjRp1Gqd1rxKdwo+EhJRWxakXGs?=
 =?us-ascii?Q?p4kgS7dHkNbZQJvJ5ZXqGqPTcOtSX26h8YPG4s7nCrPtu3EtJaCuOyWr4l1V?=
 =?us-ascii?Q?/IJK7pJ0Zge2hI5s0L/rc09MzTN7pCVsjU3WRjhjyGZxCwox6RZqSMzKkPEM?=
 =?us-ascii?Q?5ing0ERpX8cLqdL7vBtaVYvHWurygGjj6IddkVeBY3p4n/PuoBfEg64XXHBH?=
 =?us-ascii?Q?PqJmqk2nI4xEUXqESq4PTlG3CFGsuyNIuR9BeX4hhTam1u1AtMfeASET4PRF?=
 =?us-ascii?Q?Dwo/oj3LnDFDinTIP9vXMKXOvg19XxMyVxBhHJ3PpRKp7ez8k3n26smNgbB9?=
 =?us-ascii?Q?Ya0pGbShqxsLHUj+6OyWGrKbzp9bK1JpbbzdygJXEQxEI1MPfq+kZ917CbLM?=
 =?us-ascii?Q?J4qXDdIKG3MRjOncI9IGicOu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb4e639-119f-4414-2208-08d993f352ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:59:12.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVk3M9eUKgZzNfpRUtGIsMb7Md1cbVpQYtMlyV3qKFjIg8CU8G2uibslF2qLhp3kKl0PVdnMtNDbAySv9ht8ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch which clarifies what are the port tagging
options for Ocelot switches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 13 +++++--------
 include/soc/mscc/ocelot.h          | 11 +++++++++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 520a75b57866..b09929970273 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -166,7 +166,7 @@ static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 					struct ocelot_vlan native_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u32 val = 0;
+	enum ocelot_port_tag_config tag_cfg;
 
 	ocelot_port->native_vlan = native_vlan;
 
@@ -176,16 +176,13 @@ static void ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 
 	if (ocelot_port->vlan_aware) {
 		if (native_vlan.valid)
-			/* Tag all frames except when VID == DEFAULT_VLAN */
-			val = REW_TAG_CFG_TAG_CFG(1);
+			tag_cfg = OCELOT_PORT_TAG_NATIVE;
 		else
-			/* Tag all frames */
-			val = REW_TAG_CFG_TAG_CFG(3);
+			tag_cfg = OCELOT_PORT_TAG_TRUNK;
 	} else {
-		/* Port tagging disabled. */
-		val = REW_TAG_CFG_TAG_CFG(0);
+		tag_cfg = OCELOT_PORT_TAG_DISABLED;
 	}
-	ocelot_rmw_gix(ocelot, val,
+	ocelot_rmw_gix(ocelot, REW_TAG_CFG_TAG_CFG(tag_cfg),
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d7055b41982d..0568b25c8659 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -568,6 +568,17 @@ struct ocelot_vlan {
 	u16 vid;
 };
 
+enum ocelot_port_tag_config {
+	/* all VLANs are egress-untagged */
+	OCELOT_PORT_TAG_DISABLED = 0,
+	/* all VLANs except the native VLAN and VID 0 are egress-tagged */
+	OCELOT_PORT_TAG_NATIVE = 1,
+	/* all VLANs except VID 0 are egress-tagged */
+	OCELOT_PORT_TAG_TRUNK_NO_VID0 = 2,
+	/* all VLANs are egress-tagged */
+	OCELOT_PORT_TAG_TRUNK = 3,
+};
+
 enum ocelot_sb {
 	OCELOT_SB_BUF,
 	OCELOT_SB_REF,
-- 
2.25.1

