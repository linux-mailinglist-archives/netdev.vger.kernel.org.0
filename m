Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600AC5707EF
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiGKQGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiGKQF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:05:57 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29AF6C116;
        Mon, 11 Jul 2022 09:05:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp9iHtVxIrmwK5SdX1sNpbzXzrehZCcUIxJxX9hwZG7daAVjXsu2RjGCsdFAt7YOeQXv18TSUtAnYkbBGZ2D31ni6UuuzUjCzmlSg8xwGnE87nhr/tvqCECz3iqA4f7Iqh9QYWnx3LQYByFRAp2Hw0SIp0M9OfrW63/VWrBs3mvOJAX+3IbsLP63HnPaNswIvr/6yfzMw4Gq7JYIKE83kUX1yjVcA1mY2g+x+GMBviS1eEZ+WctV/9V0yyT31Pys15EReCQOkstiwsf57GSr9CPVE6Ch8bXk8Mjd2SuDuE24hfP7BMKUF4Pt4zMlJ/zROGakXbcYBGC/KIv/HQMkTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3jcfX4LA/ZGnQOBcEiA1eFhvPLhnXo6KxDN6qgmZbw=;
 b=RUA4ZH1/c8SUCjpqrhMC8u+TYn/a7W3oT9xUpLhlKlmeDL+CXE7U7+XkimrRqz5xP57yrUOMYjwG+Cd8iCHOdUoAWafQLtclRweoOBKXkF2vPxtnLVk2l4m2YCyiSac1rfWWtYyBJ2V4edqeJLSYsGoF6ZICkQTvVHAPVibntqWYDFGMUgeEtdf9F/cSLtEV8qQmvWnwIL5Htf7ayv5A5eK+e12jG4PJrmowz/6AEf8rDZg5V199KhWEVdwHu1wkvAz3EZ34xvPd2imK5E2yJ0l17E9qad3/bgVKcRA8okS/IieCv96zlbd7oo4yoIKwEM9x/FjFa2pOAPVjFgmTsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3jcfX4LA/ZGnQOBcEiA1eFhvPLhnXo6KxDN6qgmZbw=;
 b=g12GwZh2WwIE5oq2uekF5sUYVc6BmQ21QwQGg+v2is/ytpYed/PK5QuKJQcB0m932CbwW8kXFXiAtKEfpXalJn253uKu3DsuB36h8hkmdz7QPHITAfC+b7ZHBjUTPbiscKywYqXVLXEvA0DPJj1jHJidEUsWLlUhDRFxR/ybH9/QM8F3JNf9ONGR3qE+z4yHHXBM5PbzaZyyrHOpC5zhLUdv+KUId4p7T+QLZvD51ooYmKDQ1gWBGCM5GWpYQcgr1maT47Ehqc7wqzX1LqR0sZ5gzsfoYh0BjkE3s9eoL7fCr8exdpaZV5/LodWRDW4csZD/kVvYSn+fihEJe7GUiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:50 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:50 +0000
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
Subject: [RFC PATCH net-next 5/9] net: pcs: lynx: Use pcs_get_by_provider to get PCS
Date:   Mon, 11 Jul 2022 12:05:15 -0400
Message-Id: <20220711160519.741990-6-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: d56cdda8-1162-4d08-7ad1-08da63573989
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzdxLeM8BRmqnxJIk3DK0/ho3e0edW2kGGOgsY37K0B8fle7VDBdh/SPyxDESx9iEuhoA481ZbNpn9525OBJIEEbD54HQAEQ+SnHWgjEGxDqO3vtbS6HxhNF37mDmrulxASc/w+4zbutGd8tEBl8lTXp7bilhCp76FTlyX+/cyjQ7mJH2iwPycwOSqxWR56W0F9zHob2P0kB+ovMOLSte5HGCcO8cu7HE/sfobQ8k/QjKkZKbXfAzSxg72JidPd4q0IT/dN9NIqGWWh/9HMbYdQ/t2bqhOFL0FY0tLTtQg93j+ulhgxQozX0jufAhxz5kQbSnjg/m759/84FbpejQ9qBXsryGMY3tkPXb/OsHksr147A2Ll3Kvnqa7SwAwS4gJLI8bJVf/lZn4S7KTFlli3nar1/nKKIyjDAoM483OGVpztJoNdTxuCtaamV9MWns30bXdkgZ0hZaklLuWjg4ln/xiT6T/rFiX2yhLTX7KKzWheN1YV/pm+eKfTWX8VeBNx5CFm/zC4iklhEUqfO1BrlBb7aeWMfN9JCqUGL4EjerFkYzMtF0mPlcHL6Qxd+3L2kcPud5W5TAzi+APULfzs7RNSNY+Q3spokhAK675EN7ijPPAT6+/lLUCYlJ0ygZvfwzXHpLbl1bTcge2KeMC/+egc6AB0pQaXzavT6/mxxkRT7vBFNy/AtH/7mxmjLVb7Sbz+IdcMtxJpdJOSlEQooA9aoUrvM2Bx7n0NrnQhON6aiq6VrqsEvpq4hV97S1WFjlu19ti+ocWW9KkBTlvKDi6hvJeA3C+pFoZD9N2oRbK+cGV+0A7IXqyrNRL0h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pg8Xd4fdQ0XMnCa5ivPZOUzQ+Q80pA62O2qxXjLZPIs8CXMM9sHGzFphO/8L?=
 =?us-ascii?Q?Ab0qfPBY/19EVZrIZXqKgPeQOCOcjq7sTDrsWmpB8paVeQA8JZ9nAFhqJUsQ?=
 =?us-ascii?Q?Okga0MRyS6cHdGNj2DouNrmKMIuQpkKDQHnaSyMCwJH4Vk/H2IZkcy5PCZCJ?=
 =?us-ascii?Q?Gr5P+ixYRp+X62Zmw41OdT/E2gSzmWvwZLPrMx2NJ07Wyo+nHl9NGE8K/do0?=
 =?us-ascii?Q?VKWmoT42fsyJdlIPam5uesxY6728+kx0lTex8vckS13g/ue0DOBtWzET6cGD?=
 =?us-ascii?Q?e18tMRKTPmNDtXb8e8xDc0+M2yk0AHHWUcLgAdUh5fw+b14W+0eI1qQJHnw2?=
 =?us-ascii?Q?X61fZaVjOGqWeN45ClRUaWdegvvCNxA6qVTUMEty6VUmQ2Hh5JLjfhtxUjZb?=
 =?us-ascii?Q?hHx9DHc491ZAH/Mh3oHeucjKJJyDajkKZ+73umUrvNF3tNXStbR9ZsEmrJMz?=
 =?us-ascii?Q?jBzxiL2NxAQsy27N0TKK0Gn2Nv1kYjYtFm4x9hqBNvqRWvVP5my4VON3DR48?=
 =?us-ascii?Q?0SA+0UnDZabq0N38nyfYZ/XBUB4ydUdGCgfulo302g3aD+T1JUea19PR7/2J?=
 =?us-ascii?Q?EqFCnCOB6NV5iesfj0LNyniGAEWNAjMPgbLBI2yaiyFXduDQfsaoJsUXfGa0?=
 =?us-ascii?Q?HJMBlCu8rY7ASRnenDD2JTu5mh28vyY19MtSOO7gH/oGIc1mdS6XIEgOmHJf?=
 =?us-ascii?Q?ux957odr+aDNmWk0dw1HORnnbFtJwn4cXhCVGKW2dRJ5dGaSDRqqzQJIDkR6?=
 =?us-ascii?Q?Sf1QHsx6aWOv2vIh0rnYDQ1wrx7jePrJakUCDY+1jZAjYK4FBKNhJigAnhXz?=
 =?us-ascii?Q?rqAe3apkOf+ckQus4qFgq7qjVslHB5jJ5d4esRPY4QJuGDX8RFJneGjIknDE?=
 =?us-ascii?Q?/4VB+7/H/Ulg7sJdZD7XQxB5pEWubk2jF4iIGRZtBE49EtEOLNOf5skpJWG4?=
 =?us-ascii?Q?G1ke0RiFlvxIWkt4eQnUUx9LXOE/GiDqMEJfa+K4WDUdmAHWeUd4d02bKDJI?=
 =?us-ascii?Q?3qafKd0GwAskqR4YH+JPSXPsVXCzz9VH8aQZeSXDZKE9+ojDNjMmZrBnYfWa?=
 =?us-ascii?Q?TP7RLDBHtAUWHGwJyryG7sF6MMF9oMNDaf/5PffiwBloZyD2PsQ+Fk2mp6lv?=
 =?us-ascii?Q?XOxQRWw8h0mOimNz2cFQ5MxYfw+lsArulm1EWt0Wz448OUDKl8tnH7UPhwbU?=
 =?us-ascii?Q?99ZBRpSIiNhpEe7bBiG10LrZNqxTBU/PvlaNhip6fKuvJ52OuzjWh8sI8qIb?=
 =?us-ascii?Q?vD8QilFwQRIiRibdncw9Ngn6y4mjsfU+36O8MUshjR6fVIc0TP9mCBVApJmz?=
 =?us-ascii?Q?v8B8xNVeDqIcNjzjE2HsHgJ7Qh4rZa1bQUMAVtfxmlnZWsS1ux/beCwWFBDX?=
 =?us-ascii?Q?B8EyPWXgFZoezYSXmvz4UQNJQCKyszu/wNcXdurxNu//ZKReOIXquG5Tawor?=
 =?us-ascii?Q?yJy+Z2cQ4pOhcnK1xMlSWyShnIjlxQ+EWgdhYt6WwEZtSCDdc2FMetxLW4EQ?=
 =?us-ascii?Q?NOWqfxynNqwKMdpriG/sN45eJOesOD12vIcgoE0w5bquouwebLLg9shh0saG?=
 =?us-ascii?Q?qPKhAzIrzZoiZ9ni/IRHT+L6i40xSzUPG4ffrGjYr2Acjsn+XsITyaSd3Q96?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56cdda8-1162-4d08-7ad1-08da63573989
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:50.7462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wjn3PmR/Ff+VsbXN5cXsyQiRvbUO0Do8xpCQZUrMkNYlJvkuOhkCW48vGwJfpWfCjnIw2VND4knB45dPcZ0a3w==
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

There is a common flow in several drivers where a lynx PCS is created
without a corresponding firmware node. Consolidate these into one helper
function. Because we control when the mdiodev is registered, we can add
a custom match function which will automatically bind our driver
(instead of using device_driver_attach).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/dsa/ocelot/felix_vsc9959.c        | 25 ++++---------------
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 25 ++++---------------
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++-------------
 drivers/net/pcs/pcs-lynx.c                    | 24 ++++++++++++++++++
 include/linux/pcs-lynx.h                      |  1 +
 5 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 57634e2296c0..0a756c25d5e8 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -11,6 +11,7 @@
 #include <net/tc_act/tc_gate.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/dsa/ocelot.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <linux/iopoll.h>
@@ -1089,16 +1090,9 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		mdio_device = mdio_device_create(felix->imdio, port);
-		if (IS_ERR(mdio_device))
+		phylink_pcs = lynx_pcs_create_on_bus(felix->imdio, port);
+		if (IS_ERR(phylink_pcs))
 			continue;
-
-		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (IS_ERR(phylink_pcs)) {
-			mdio_device_free(mdio_device);
-			continue;
-		}
-
 		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
@@ -1112,17 +1106,8 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
-
-		if (!phylink_pcs)
-			continue;
-
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(phylink_pcs);
-	}
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		pcs_put(felix->pcs[port]);
 	mdiobus_unregister(felix->imdio);
 	mdiobus_free(felix->imdio);
 }
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 8c52de5d0b02..9006dec85ef0 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -9,6 +9,7 @@
 #include <linux/mdio/mdio-mscc-miim.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
@@ -1044,16 +1045,9 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_INTERNAL)
 			continue;
 
-		mdio_device = mdio_device_create(felix->imdio, addr);
-		if (IS_ERR(mdio_device))
+		phylink_pcs = lynx_pcs_create_on_bus(felix->imdio, addr);
+		if (IS_ERR(phylink_pcs))
 			continue;
-
-		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (IS_ERR(phylink_pcs)) {
-			mdio_device_free(mdio_device);
-			continue;
-		}
-
 		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
@@ -1067,17 +1061,8 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
 
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct phylink_pcs *phylink_pcs = felix->pcs[port];
-		struct mdio_device *mdio_device;
-
-		if (!phylink_pcs)
-			continue;
-
-		mdio_device = lynx_get_mdio_device(phylink_pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(phylink_pcs);
-	}
+	for (port = 0; port < ocelot->num_phys_ports; port++)
+		pcs_put(felix->pcs[port]);
 
 	/* mdiobus_unregister and mdiobus_free handled by devres */
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 8c923a93da88..8da7c8644e44 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -8,6 +8,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
 #include "enetc_ierb.h"
 #include "enetc_pf.h"
@@ -827,7 +828,6 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
 	struct phylink_pcs *phylink_pcs;
-	struct mdio_device *mdio_device;
 	struct mii_bus *bus;
 	int err;
 
@@ -851,16 +851,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto free_mdio_bus;
 	}
 
-	mdio_device = mdio_device_create(bus, 0);
-	if (IS_ERR(mdio_device)) {
-		err = PTR_ERR(mdio_device);
-		dev_err(dev, "cannot create mdio device (%d)\n", err);
-		goto unregister_mdiobus;
-	}
-
-	phylink_pcs = lynx_pcs_create(mdio_device);
+	phylink_pcs = lynx_pcs_create_on_bus(bus, 0);
 	if (IS_ERR(phylink_pcs)) {
-		mdio_device_free(mdio_device);
 		err = PTR_ERR(phylink_pcs);
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
@@ -880,13 +872,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
-	struct mdio_device *mdio_device;
-
-	if (pf->pcs) {
-		mdio_device = lynx_get_mdio_device(pf->pcs);
-		mdio_device_free(mdio_device);
-		lynx_pcs_destroy(pf->pcs);
-	}
+	if (pf->pcs)
+		pcs_put(pf->pcs);
 	if (pf->imdio) {
 		mdiobus_unregister(pf->imdio);
 		mdiobus_free(pf->imdio);
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 8272072698e4..adb9fd5ce72e 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -403,6 +403,30 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
+struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr)
+{
+	struct mdio_device *mdio;
+	struct phylink_pcs *pcs;
+	int err;
+
+	mdio = mdio_device_create(bus, addr);
+	if (IS_ERR(mdio))
+		return ERR_CAST(mdio);
+
+	mdio->bus_match = mdio_device_bus_match;
+	strncpy(mdio->modalias, "lynx-pcs", sizeof(mdio->modalias));
+	err = mdio_device_register(mdio);
+	if (err) {
+		mdio_device_free(mdio);
+		return ERR_PTR(err);
+	}
+
+	pcs = pcs_get_by_provider(&mdio->dev);
+	mdio_device_free(mdio);
+	return pcs;
+}
+EXPORT_SYMBOL(lynx_pcs_create_on_bus);
+
 void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
 	pcs_put(pcs);
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 5712cc2ce775..1c14342bb8c4 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -12,6 +12,7 @@
 struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
 
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
+struct phylink_pcs *lynx_pcs_create_on_bus(struct mii_bus *bus, int addr);
 
 void lynx_pcs_destroy(struct phylink_pcs *pcs);
 
-- 
2.35.1.1320.gc452695387.dirty

