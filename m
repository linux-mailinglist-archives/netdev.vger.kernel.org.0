Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BE45707F3
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiGKQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiGKQGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:06:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A9E6B263;
        Mon, 11 Jul 2022 09:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0wxfqYhhJLuUE2xZLwfZffb254i3cuuo5y811fXEKlxS7fzL4DDlZR4Izr9GBvBm4fsuRdeUFOoKvZI//fCoYo/b/fWvE5IBK93y7q4F7ka0A6Q7n0UjdmojCyJdcMzlDEgQguQLsZ2b92ZUmhw7faD5a+75rE264+z8x0wBEnZ8Rf3XIxt4x55lU8LSXb3IDBi7klnxpcTiGTM54oFR2FIT+F1j+tqE/vf8q7mSFSG7S+yOvG9plohD0TGyExj65aBe83nRG+GYIPiMJ7AuM1nnNWZv3DYYrFoNXCcmLB86UAlZMbq59cMFgUh/tUpkEWn5Sx/2nCEXEB58fCeAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hjc9RLGREP3Z5WJkyMST6CSowlBSuOnnDs9Ai7CFZkk=;
 b=e9Oa2h1GCdU80jdOMLiw03mp/BauQWvYYYJgQkFNlHcSZTzvmHvjN7FWM4DTJ9xbZ6Qk15PdoXot456kRYK+/zIEmhcRmu1mdy9tc60DEjXyWAbp9g+FBJy97VM9dklZgL9dPgckOprTl9IyEMyqLxUvAU43e1XMAWsbOnMJdycCRDCgQTRbYdEprsxHXqixvfAybGZovEH281c8BqsUmKqK5LFoER2EiLNFg22cbaUeBHc396uN3BGPW4Izp/7+rydF7awqObt+2Wnqvk3YNTWUPUY4IbnETomn42/x/b0DX7W37ts6scDc93kwuOTnmhxiJyZTGNr2etxdi+uKVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hjc9RLGREP3Z5WJkyMST6CSowlBSuOnnDs9Ai7CFZkk=;
 b=VQYIx380w46jSdBsSWAWVdwgivbSy23x2OU1vRDsajF/iVBIqYi/lgUr7cMJ5VRN+S2y6ikGm0PccPkRCNmy7mGc//6gj42Ec0porqNgCqtF4zBFReTEe4gUGqvwLoKe5+bGVGtMvGG48kho/z6VLG8aU0P3sfALJG5fNfIyrJHMhbcjNq8ky65yC2ssm3aaSoDtEEBhSy06EG3CvyKsOfMSRtz19d28ZS03F4rfrw3eZ+NsmUp0nA3C22KMDLnYGtrI3gG8fM2AJgDkDDutfhIgbN3rc6BnIUkYkt27BmqSh7Y2SKEqXHTXWb4hUR691wpN1236P55ozmNvpqo/bA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:52 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 6/9] net: pcs: lynx: Remove lynx_get_mdio_device and lynx_pcs_destroy
Date:   Mon, 11 Jul 2022 12:05:16 -0400
Message-Id: <20220711160519.741990-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c86d629-41ab-45ea-79d1-08da63573ad2
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SruOoDBENiQknJRFUYN1EeuamFHcHtJC8WEjCMyix5clekdUF7xXvj/jGvaBavWOFOPHeWewXjBxaoKNGTJmS0Woksdcc8XNRZlgzIa6eEz9sCreblJXheirZId+y9eQmz5T/nkSzwbpCwnHmOV1rh1NJsPQtbCXBBI05KYy+QTJWA3qbDOi72qXzQJMwgSGPMiOX+bYuLGLPii4nuBA14oaoohemSxTUqdZVxvSWRyx0nmPtMpoCiUHRBdKLaYaPm7v2Qu+Fj3ljLNimblvF1hscdyMuJ5dTwfIUCs0DsVGEIkYHLRI4odW/I+BXvV9Oa/tghzRC7SbORZsxwp+suN1xE8/gChUcpPzjCGPidGuFe+1qF6JpN7xsIg9Qs/3T2TO4U3NKTqKKFiIslt8dK5/jMmvcAp0vEHzuarIDyDHCeZydhbR8/RSBHxiVt9/HbGAmQo3rkjmo5XIvCkLJJ+bjKmmALObqtNNTdAyDsVDmajlGviLvEVaftARuStLGa9zT+NaSIu0PvlaJ1eA17Y6jiCAKP91xXaaH3q0ub+Z5+X+x2qXVHtVjxG1YrgDQ9hq6LGrvvC22CtMmgDrthUoGZFtAJIOz6jHAEHZSGuhuClNc8V8wghgwTdJ89SU/7V7AxMWyuuOjEPIoMkUZx/C98hNdj/9rz2JRwLwRehUmduelHTfb4WSDhajLQiCrGGwct7jU65Xk58wi7a+DE09C3PiSZ3pz/OK8yX2qx0o6vzlIIl6KxWfa2szywdu4p2ZA4NyPbhFpcVzyMQkg/9HoFAtzW0GZ5d/lhtdtrJT8yLuPTDHBFESpbU6LI3L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KrL3reZPq0vi/4FpMqYz7hX2ZJrewvEpaEtaT/b30D4Mw2GnS+ihalwTX8xb?=
 =?us-ascii?Q?FTWoEwx6xKLXUz+ylGtjv1z9ALXO0hDWnfXYUEQBx5d7RjZnKmrlOTWPLWc/?=
 =?us-ascii?Q?RjBSJctGfZelPWtpTcB3IIWuPweDNFnwUj6Sb2BlEnBZz8LvOufK88bU1IE1?=
 =?us-ascii?Q?KEUlZr75U86w6p7eyQGGgfQb1dPA08V2pHE++N+lKUg82xe5prlTfaAO1iGN?=
 =?us-ascii?Q?PlImYdaxsKBU2FW9eJwdsE+iAbo5eSSN/PWZGGvy2l8T5NTg23MfcgxSqDWp?=
 =?us-ascii?Q?Iwp4DTIdIjfpdutn1fO8X++zsfoaC+FQlrl1OoSHSVHfR1a8ECTHzIIQKoEg?=
 =?us-ascii?Q?kVCax3cYDyAW0xRbaQOZgNK00auaZwFU9aIymsrxtlVqzeBVQ6ukGxGPffCO?=
 =?us-ascii?Q?Mj1/O6bLBdmdoSIBHhdHE5t14QWxkML1x0FYb7usGhDUeUG9xmAvJ0iuGpHK?=
 =?us-ascii?Q?eY3uJXU3eLqI1/BE863pqWfjoIGv46v6ggFElYAOA7tCosqbsokcMYujkXr7?=
 =?us-ascii?Q?N5b/swlvnRBc6GkjgHlj06AW1W8SVXXp6L88PjMUQ/khsm+hjSgANVUZl3vX?=
 =?us-ascii?Q?HAebOX9Jo3Qrl5wsYyHFaZswMA9pJeL1zcQoV9GgBzEjSwiATrOgD/01a0pP?=
 =?us-ascii?Q?WuUWa9rRNGXfgzsMQjHH57p/yzyMIWdWEXBUVFAZqi/eWJCcu7tX038C2NqD?=
 =?us-ascii?Q?whDUjD8FYs3iWhOhiBbdy/Hg37GRcURv4K9gyjI4xBo5w57nykhU5XptBUyy?=
 =?us-ascii?Q?WB71jy5colnpYB2QhVoDCmhbyf+qXT7kirQtKrMICCVmvwJHORSzeGj/wAEq?=
 =?us-ascii?Q?AYhVWvmYEROda3jqAIciz1KjmNoo1Oq4T5cUkItpy9Xc1PAL8ggW8zsYeRE7?=
 =?us-ascii?Q?YmQu8mwUuqpV5R2d5GfpW19MOLefTBsMNJDU1C4jh0GbJSxYTdsQ3mRFvUL5?=
 =?us-ascii?Q?WOGNk5aXcZrSNMt/DCeYlKAfM7Ev+91sQ5NS6S0PmqqEbtyNESVHLSBjiOrz?=
 =?us-ascii?Q?ASUQUxTSslGy1q6k+cWSrvJYV0IeT/lKTsqnSoVHaofycrXKblZCWZ2/HsLE?=
 =?us-ascii?Q?YG8zEBnhgGP2nJsHnD1qyE00sAINRApOPZPQgDjmjnxIs42pI1VViuhFBFOa?=
 =?us-ascii?Q?IcZUl4Crp8gLYWhnGl8slrcighH02yg/ggXIEfEFsLl873MO7WdvrzP17rMr?=
 =?us-ascii?Q?mzORSI0v5YW8zh08FaJDwernA7wBvVrZt4HaAVajKv45vulkFrnSEo7EMYuQ?=
 =?us-ascii?Q?e6ALqVUUkNz69rmlHymriexPiU153YnN1A+iiUqE6soLg7ENtcObbBgjyecq?=
 =?us-ascii?Q?BON7m1rCIousuQo1d5L902MJzd9qNcPEBmqH79Wg1RlvSwwlvC6mdV2BHF7e?=
 =?us-ascii?Q?rhNmGa1PUu34TETjEXp8KiHrFG0qaqnB5erSwwI3CJBT36uUNHJXYzCU5Z7u?=
 =?us-ascii?Q?DQVrW/kj946agxYSHY9QsDnQ6kOJ/iBCAazNLzXqcHz8PJPh3wEhacF8WQye?=
 =?us-ascii?Q?Hh39vmpNdOPOyjTBw5EDdg+NTBQVAz9q7JxFV0bh/sxjQzLA62C/A/VJplwU?=
 =?us-ascii?Q?KMIrJuUysQeeTQboXsp+LaIrKeguukO9FJsaGzGbgu2+IKOgCbr5zOijw1Bn?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c86d629-41ab-45ea-79d1-08da63573ad2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:52.8554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x1ymC9tGS14nWwuJMOdUHlpD2spQFFIBvg6hyq53XeE4YhJbvI7N8amcT7EenxneAMn0Ct3dHks9edH+DVT0xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PCS subsystem now manages getting/putting the PCS device. We can
convert our manual cleanup with a call to pcs_put. This removes the last
users of lynx_get_mdio_device lynx_pcs_destroy, so they can be removed.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/dsa/ocelot/felix_vsc9959.c           |  1 -
 drivers/net/dsa/ocelot/seville_vsc9953.c         |  1 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 14 ++++----------
 drivers/net/pcs/pcs-lynx.c                       | 14 --------------
 include/linux/pcs-lynx.h                         |  4 ----
 5 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 0a756c25d5e8..16ff0052a8bf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1082,7 +1082,6 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *mdio_device;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 9006dec85ef0..669af83c9611 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1036,7 +1036,6 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		struct phylink_pcs *phylink_pcs;
-		struct mdio_device *mdio_device;
 		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index e82c0d23eeb5..d8b491ffa4db 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -2,6 +2,7 @@
 /* Copyright 2019 NXP */
 
 #include <linux/acpi.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include <linux/phy/phy.h>
 #include <linux/property.h>
@@ -268,6 +269,7 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 		return -EPROBE_DEFER;
 
 	mac->pcs = lynx_pcs_create(mdiodev);
+	mdio_device_free(mdiodev);
 	if (IS_ERR(mac->pcs)) {
 		netdev_err(mac->net_dev, "lynx_pcs_create() failed\n");
 		put_device(&mdiodev->dev);
@@ -279,16 +281,8 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
 static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 {
-	struct phylink_pcs *phylink_pcs = mac->pcs;
-
-	if (phylink_pcs) {
-		struct mdio_device *mdio = lynx_get_mdio_device(phylink_pcs);
-		struct device *dev = &mdio->dev;
-
-		lynx_pcs_destroy(phylink_pcs);
-		put_device(dev);
-		mac->pcs = NULL;
-	}
+	pcs_put(mac->pcs);
+	mac->pcs = NULL;
 }
 
 static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index adb9fd5ce72e..bfa72d9cbcf9 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -40,14 +40,6 @@ enum sgmii_speed {
 #define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
 #define lynx_to_phylink_pcs(lynx) (&(lynx)->pcs)
 
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs)
-{
-	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
-
-	return lynx->mdio;
-}
-EXPORT_SYMBOL(lynx_get_mdio_device);
-
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
 {
@@ -427,11 +419,5 @@ struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr)
 }
 EXPORT_SYMBOL(lynx_pcs_create_on_bus);
 
-void lynx_pcs_destroy(struct phylink_pcs *pcs)
-{
-	pcs_put(pcs);
-}
-EXPORT_SYMBOL(lynx_pcs_destroy);
-
 MODULE_DESCRIPTION("NXP Lynx 10G/28G PCS driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 1c14342bb8c4..61caa59a069c 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,11 +9,7 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
-
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr);
 
-void lynx_pcs_destroy(struct phylink_pcs *pcs);
-
 #endif /* __LINUX_PCS_LYNX_H */
-- 
2.35.1.1320.gc452695387.dirty

