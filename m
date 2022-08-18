Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A7C5982B2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244477AbiHRL4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbiHRL4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:56:01 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150085.outbound.protection.outlook.com [40.107.15.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DCAAE9DF;
        Thu, 18 Aug 2022 04:56:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTq8HYgXQ9SsWhlcduOvm61r3Efb7zinT/5eILPl+1nB9+hiixOzX/L6Y8NuDyzfCbRv54RwtZFIpsH3+UOmu2SQsdCjWWBVEea4tVrPs0iPe9oy4f7sKKJK1P9ww4MiKujpBb0FaLYAz9YwpQzOTD0KRoQKZFgkjPRL0laGtoxqDraaqDzQlCXneStmjbtn92Ila3STHv5VAxctMngAs8GYCxKRUglXnJ08xS/PUcud1OwJyFLFu9tdAEERpcIrY3lROi67ZKZWyxs9Mc4FVWYiR9cpbGiQWpxqhCDrMa5jA/xByOUla7K2BDv13KUqB4YER9cg+00tC2n7rcN6ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yedZw3gdHlfOpVVJ/exAtCjZGJrolEiKNQmUg7m3mzQ=;
 b=mPpNr8bdthi/DS3vQWb394/4UwmUG8QivdHwPsDbT8yUf/izsiVMkppW5hhwfNoXTydRw9Ce7XP8Mt+wjsvBRjgch8445RIMBRyIhoxbv/J7bsKgAgcGDOxtmdqRITIvaUM9k1O2VHN9uvBFvhBxo067iQQ32C1YpOznnPzKj9T7tQWv2S46TvgP0gjNzEZAFT6VOIK0eW52BmLcGGkhG17J+awMKRfDRH/mqtaqFVb11VTJmt8hyvs2wb1BLej5qyV1yuzLaka65p9DCIGYeD5ZcM8lU8s5VjPLpd55O1xnCSN8dg6plxGAaV8WWJz860YakaxqJ/K0JnBUUUoP+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yedZw3gdHlfOpVVJ/exAtCjZGJrolEiKNQmUg7m3mzQ=;
 b=j96Y+rC3IuYxWijSL31tSG5UCaJOFkuPM6xv5G22GEQDXdujletTXfewQsvaIiUB/9R0JC08Vaba9Dp67oXLanS5yQxPA+WL0zOzDX9/7E85mh9mPecn5+VLWPcu5nt3O4uauq6INY9w5JV9uEP6Zun/dG1kcOnKAcPk5nTVQMo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v4 net-next 09/10] net: dsa: rename dsa_port_link_{,un}register_of
Date:   Thu, 18 Aug 2022 14:54:59 +0300
Message-Id: <20220818115500.2592578-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
References: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10cb51e4-df16-4128-1f53-08da81109cb5
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +VV7zPrilx9vq+RpB3pj4CEcf0msYuZAd3X3trg5AOITNNlI9bHfexOKN30eFGQWQnvWDuqKlmpVqR9U68fsXDC61JI5R5WLItizM+WtnRuNdcuPN6EJfsez3YPkBdj3SeCbQuSAsjRN0p0Mt4g2nL4xUBk9SwElQbG8HcYySk12v8FGlplrb1pyXyWkxy92uI44+LZd+QYVQCOeDLGf/70TaqC82i8EYxYa1vsMl6n/PbfKS3ktZcbucelDjcUUIk4uKHhsVC4uU02qtK4MriWL8Z5Mww7kJwu8SlLxodiCcK2tn+NfGf5iYQeyOoLZvtOmhp25qkohNR0Y+eE0LWX9c4Cxsm2SBxP9szGIqoBlNJHFTZdfGVHLEEbs2jvDJvJFRw95JVttFRzFqz5mlXx8KgMih2N3kob+lAdafoRaKgbIjaa5iYOlikOLOBJBvCz9ys+uJp7UlbckhLih5ZpPo/FADX6u6y+QsiCjDZI6/A/E+Cnm3ZMMzH7yOYai3V+tla3WJPVfw6gd8LgBpK5MKGERKEQwYWpAMUeM6B7uJjPNEEoqkRM7Aix7tg1VukHj5uxb9L/Do7n0NDY9KemD3fGJbRJL8Zyk/jjQeP4nivtJC5gewRWeWXJtq+PFUUbrQE2C6as88Wr2G0jkDC1yLqTj4hgHIiHQo7YP7+fuVqLVep3hb+RXhyOefy5roVexQ7srNW6n2++Ne+WJB8EoWhYPn1uIfc7MMvZPY5vXzywQgCVnSqVx2SYOGrnA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6512007)(186003)(6486002)(52116002)(83380400001)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sgTWfQBUyWIZklW8exE983mnV0NDGzpsAf/gssPobCJ+DuG+4d4OMwTm2/fq?=
 =?us-ascii?Q?6d+eLrDgqCIcYOdpgBtgp+lYYAxKvIaeSajW8b8bo05zAEysVBs9862s9DKY?=
 =?us-ascii?Q?+2i2sBBJms2v5JcdKYc5ufLN4N7tyFisplJwHaZryEKILMg+oMskVTZg3KII?=
 =?us-ascii?Q?m4Nqu+731EWT828bX533iNnsbH8ZF3OjlS9nt2MwsuHxYFSzVJ2J8L22Cjle?=
 =?us-ascii?Q?ivXFE5VI8t1FSEtaUs0LO7gMGthqvc4Ni7yfIDS67uUDMn6rf2ZZvvVEZFu7?=
 =?us-ascii?Q?2qJJ5nzhIYJokmitsbrIReP2byF+gZpbqCO0egIsStY5GAljA7aNfLpyPCpr?=
 =?us-ascii?Q?NDle9h0FMTYL4RQkXy0iGZmLxYFM9hfrT0koGIx3RQOGXVnNFyWaYy9+iDHm?=
 =?us-ascii?Q?uVgGex+8lK5tLJF5oG4hPpyuOWd4vTir/m9TKhj+PeyXy5wJ2tGspFA4SfzD?=
 =?us-ascii?Q?acZZOdY2g9VLexlsngOvYUc9WHoBTMDY7Lkk2l1tlZbLNbyK7IIO9CV+u49X?=
 =?us-ascii?Q?7xgztoTvkUY+b+8ca+xWG/zLtEQvztd9iASBUuXWk3MCoQ98wMUdvC0YoVdB?=
 =?us-ascii?Q?qXEsANsGx7MTf74h9lpk5bW2vQ9WQNPE7877BRZakN9GqOwHkmVvKaqw1Mdo?=
 =?us-ascii?Q?Gc0b+AznhDPG8SpsiclbL3ZRuJywr4FkDunnS/StU4MnJHz+FUkDcGhZaSTk?=
 =?us-ascii?Q?uPueN3Nxj79Ltf3XB96rktpO+G2alnnpBALb6uwooqDUvgz0CB19/TxKUvDS?=
 =?us-ascii?Q?i8qVQhTHnSdWpWCyld9Y8WKWVEilFThZIY/8zT/oDcwG7y/SuSxFKimi0Q4h?=
 =?us-ascii?Q?swQaE58E9+s0iBM8RHLuQwOcZFC1wj7K9C1ZxJZJETTG9sla505T+IMG0Trg?=
 =?us-ascii?Q?vFCwtVqCbCNDtNKsuXH7buCE+9LQjXRHQeEux7nKFDQHSqKZ5rG2lSVBKmi4?=
 =?us-ascii?Q?9GA5FHGBTHgtghTfhHFeA+X6v94Vah+UFaK+g5Lctw0e6AE1pPGpt8qnfO6x?=
 =?us-ascii?Q?AOyL5/1gMbZ2RpPHUC2nYs/MIWzrdr/SV5HPTGZylRm76WQ8u0Q3EK1zqg0P?=
 =?us-ascii?Q?uhQocLp/3K0SyT5Ak3VUJtvHyk43WxKJS2hf0e0FqBhKKzfkrwQby/45XQqm?=
 =?us-ascii?Q?TK7lBlKFV+qSku8jp+Ld5NyLD+6CzUAcj0E8Ni6v9NKGLkGGOmMfiHFuda1Y?=
 =?us-ascii?Q?SJzc+4kPPvBGyGdYob0SdI0oZ3ArkBnLCb9QzExTZnTweKtCp7dT9emVRlbA?=
 =?us-ascii?Q?2tglcZP/pej2cVT/xURVXulS+jphz545fPW1XWpbpGa3BKlv4hnmMoSpLfzb?=
 =?us-ascii?Q?kqALVeNr0CcMPca6DjKiMvoRiM3ONnqhoyUxvM0y4v5hbNgIsXVhBdtD7/K6?=
 =?us-ascii?Q?MzF3d+rWd1jVviCs7mrWNzbrYQKctzRFZXhWaj34wjd+vNZ9mtGlsEldtUnR?=
 =?us-ascii?Q?Q5l6yU1BFEJA2oPRsaetEIwnn05KP8mY56id+Tna/XGAzBrKC+lYMuyixo82?=
 =?us-ascii?Q?75+a/Gcr2v+2GjmFvKgnWfxMJAfzZ0xgO8EBCfZOwz4c2o1eXzTJ7r09AVEh?=
 =?us-ascii?Q?gE881sE0rtGcdAoKLd/2wMd+VK4PDCJt6FR6HG4KkBUwF9Uci7G6iLdX7SuI?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10cb51e4-df16-4128-1f53-08da81109cb5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:57.6640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MwwPyiEOYruyv7O9f7vKnRdL1cjWKagc4pVYAsWsAublXI8NxOrpdccHzz+4Ko2fAc5VoZZ7Atvo2tDw8Orqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a subset of functions that applies only to shared (DSA and CPU)
ports, yet this is difficult to comprehend by looking at their code alone.
These are dsa_port_link_register_of(), dsa_port_link_unregister_of(),
and the functions that only these 2 call.

Rename this class of functions to dsa_shared_port_* to make this fact
more evident, even if this goes against the apparent convention that
function names in port.c must start with dsa_port_.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new
v2->v4: none

 net/dsa/dsa2.c     | 10 +++++-----
 net/dsa/dsa_priv.h |  4 ++--
 net/dsa/port.c     | 18 +++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 12479707bf96..055a6d1d4372 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -470,7 +470,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		if (dp->dn) {
-			err = dsa_port_link_register_of(dp);
+			err = dsa_shared_port_link_register_of(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -488,7 +488,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_DSA:
 		if (dp->dn) {
-			err = dsa_port_link_register_of(dp);
+			err = dsa_shared_port_link_register_of(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -517,7 +517,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (err && dsa_port_enabled)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
-		dsa_port_link_unregister_of(dp);
+		dsa_shared_port_link_unregister_of(dp);
 	if (err) {
 		if (ds->ops->port_teardown)
 			ds->ops->port_teardown(ds, dp->index);
@@ -590,12 +590,12 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
 		if (dp->dn)
-			dsa_port_link_unregister_of(dp);
+			dsa_shared_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
 		if (dp->dn)
-			dsa_port_link_unregister_of(dp);
+			dsa_shared_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
 		if (dp->slave) {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..8924366467e0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -285,8 +285,8 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_phylink_create(struct dsa_port *dp);
-int dsa_port_link_register_of(struct dsa_port *dp);
-void dsa_port_link_unregister_of(struct dsa_port *dp);
+int dsa_shared_port_link_register_of(struct dsa_port *dp);
+void dsa_shared_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2dd76eb1621c..4b6139bff217 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1552,7 +1552,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
+static int dsa_shared_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
@@ -1590,7 +1590,7 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 	return err;
 }
 
-static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
+static int dsa_shared_port_fixed_link_register_of(struct dsa_port *dp)
 {
 	struct device_node *dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
@@ -1624,7 +1624,7 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_phylink_register(struct dsa_port *dp)
+static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *port_dn = dp->dn;
@@ -1650,7 +1650,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
-int dsa_port_link_register_of(struct dsa_port *dp)
+int dsa_shared_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *phy_np;
@@ -1663,7 +1663,7 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
 			of_node_put(phy_np);
-			return dsa_port_phylink_register(dp);
+			return dsa_shared_port_phylink_register(dp);
 		}
 		of_node_put(phy_np);
 		return 0;
@@ -1673,12 +1673,12 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
 
 	if (of_phy_is_fixed_link(dp->dn))
-		return dsa_port_fixed_link_register_of(dp);
+		return dsa_shared_port_fixed_link_register_of(dp);
 	else
-		return dsa_port_setup_phy_of(dp, true);
+		return dsa_shared_port_setup_phy_of(dp, true);
 }
 
-void dsa_port_link_unregister_of(struct dsa_port *dp)
+void dsa_shared_port_link_unregister_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 
@@ -1694,7 +1694,7 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 	if (of_phy_is_fixed_link(dp->dn))
 		of_phy_deregister_fixed_link(dp->dn);
 	else
-		dsa_port_setup_phy_of(dp, false);
+		dsa_shared_port_setup_phy_of(dp, false);
 }
 
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
-- 
2.34.1

