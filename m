Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8BF4AC582
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353428AbiBGQZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387632AbiBGQQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:26 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C980C0401CE
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SltqT+Yrp8+430yoKW5hYwpDPOtB9whoxr3Aignzra1n++MUKk02bA4Sl+FQ20kmQENuENowObwuR/QZklCp/0onqfxeDxhkc+t7LUEcObBRafryrrKodopBdun0QePWLAj9CDiraYpB6azOvcHiQ08/eAUzGyszDNxTq5dPPrsqXXDLQsyGFkR47Phcm7YS8W5XrcPz2IBnQ/8bgCQIyi8nKdBlXPGV4Zt+ry7A9tzv7W9UJf2JtioqO3nbo6adMDaKSRNrO597UlhzSa3uDDwDJQzpCxzkNVfxAVBsUirv+Szlk65y93aAP8/fS5W4RWsJWyf3E9ZzuXAGOD7wbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSBotTeW+nS2dV7Y1hKhodSwZ/PANgseH9+qhrKjGl0=;
 b=oEUZUv+2OuG3fEkkIWvx5N1HQOx+p0I/lSeEXZ3/9s13476Lc8/ZcapQDUMeEb5EZY9sYhggKCDd3ddLXu6C2FmrogVfb9t72Svz3LYWyAvR/EIdtCMdPoWGi89VmDlqfPafhx7R08c/MvalqVZ5AJ5Q5JYGnm7HKxoYjJYUWZ0otV648CD9Pfcc7BPbRi+p6nYRxMHY8XcUphIkS/pmuY+JsBrnUr0dlK2FjrNrP/HH5u8DVYSlKIdF6QjM20fJv5d9att02jV9HLB55/Xi37UB+bycEYP0MBeU/4YobrF4KCHExroQ/LEGaIklkpg7Gf60KYIy8HiVe1HUA7akIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSBotTeW+nS2dV7Y1hKhodSwZ/PANgseH9+qhrKjGl0=;
 b=Bj0syRq2tIaMoqagogN229eZgvbuHvUcfNoaEDmF2ctiXKX0nVwLlIpf+oLjyG++v1wPqEiVsIdTAWpECsRxzzfA/pbGH+4p5GLL4vq0fb0tWM9YG8S/A8s+RH9rFP7doSjHLcaoPEawWu3TsbENc/JNajE4ufnYXDmGZDDURV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3910.eurprd04.prod.outlook.com (2603:10a6:209:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: [PATCH net 5/7] net: dsa: seville: register the mdiobus under devres
Date:   Mon,  7 Feb 2022 18:15:51 +0200
Message-Id: <20220207161553.579933-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207161553.579933-1-vladimir.oltean@nxp.com>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0066.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20992e1d-035a-405b-9e93-08d9ea552e75
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3910:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB391025B22F8066D9DD9DF89BE02C9@AM6PR0402MB3910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QSISqJ843sV+rG300HvWmPD/AbqZ2hyV7RKs32GD+buZkQH04W7sEawTIXngySxbQx3YWMTDBIpUE2LnhTz7tMf9nYhWrrYAetAsUkSGRUV1OdtLVycd6/F0VPfc+QkSfilJgLfNn39regEGNFR0IWjMBlgRULJ94tqtEDPQNa7/77eRW7hIJFEQHiaMJWIGGWpl7OFW6YUvrHjn8ISYjSgoo0Aq2c/Napjwz8tDpmhLtNAVM8ePqworpML4ewDYxTZbOYx56eEYnsiwmDUmIRMTng1H344VbYuz1Jcfu3V82/7Ve2gNnaLr9FsiQpntbgnI2iOEkwVEgPkWYecCrrwVn5H/O79r156WELbi3foFY5RmWVlIZ2LzScI9RwOfk0Um5mGBbn4w1zDkkDBCoBfP7iFALzLtFsyQH7fDWAGweO5Zk9oV9Ut8ptNGTRz0KzyJrcEUd6Cn2F7PT6tjr1Xka4sWz1fDyHzhJsGWwusOktPkk36bR3MbnXtyyHjWU4Gj5nUTwxek1+7Y7k0DSCB4btIZGOBKgMRH0lDBOanRu7jducpdhzpZVzeYHi44Bf/ueapo0l7vYZFz0yFRNeBcka45SuniVCGPqcAEEDeyxRR4R+T4wWUKX5/fxWc2tQEc/rh2rcPR+k8qPzsqp6vM1KNl6FKHDjcWOes5KwhwUpBa55YXZS18KNRa2kwCOP9kmoFkpFg+bS7FpRL+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(36756003)(186003)(6506007)(316002)(6666004)(54906003)(6512007)(6916009)(38100700002)(2906002)(38350700002)(2616005)(52116002)(1076003)(86362001)(66946007)(44832011)(83380400001)(5660300002)(508600001)(8936002)(7416002)(4326008)(8676002)(66476007)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2z22mPNrwI12gBOBcroIHPgM7VDT610wU9H+ag8y1ngSRC+S3MmZ1drZsHFV?=
 =?us-ascii?Q?9X4QizWPcz9U3cazI7vqu23DPtkuXv6IDIECU+F22s25sv+9VGD+q/fJi8mE?=
 =?us-ascii?Q?h4M3ds9zX1qd272CWwcTLksfHqSFu6XzchTATZ9XxD1Cx3ZgyfNB35hsKPLG?=
 =?us-ascii?Q?C3OSpSZGPqGkQYj4v1ZEs8qzclz2bfE7HtUPQNu1CYWnQDSi58csfcCamzLh?=
 =?us-ascii?Q?JtIJMmTs17FAq83pu6BNvb8GGP4k/ojlDrBsp4YguLoP6frssoNsrWLnlcpd?=
 =?us-ascii?Q?lI6I0GhOiXgQH3WQ4pxU6M4uMblhf86W3Rqd2yZeSK6nNvA96+2LxXlzxGTY?=
 =?us-ascii?Q?X5qbuvYyz1RczleNjNHpJN0b6F9V1QaQyEwBmtdP9UrmR6/Dxj5jEldxCEaH?=
 =?us-ascii?Q?WT7RBxUeONtCnFF/ELhuNP8k81bwkt7pTeHMUXvmmDilRi9MBd2ym1YOCZ6N?=
 =?us-ascii?Q?0YARliU0kpfFkdzGjMIrPJ1PwnzmgTty5k+VD4X7/oe2fmgbyadb9BARNxOf?=
 =?us-ascii?Q?xANaN4lH+rdQ2OwwtUKwNkPkp6lnjrYB8o7dwDzCGvDaI3/MY8Ee++C/g4Lc?=
 =?us-ascii?Q?1MxMBTfx6vmRsMmIjlyu4ts1UQte2D2ljyWh/GF3QS5aGHLoRlZkdvvVPGpw?=
 =?us-ascii?Q?i2OYeKqesLGWy0hdpNTHoOBkCAoa9WCnFhvptc6mtGb930NoRooN9xh+wUVk?=
 =?us-ascii?Q?3bVaL9H4mqg7BP+vbUkeL+zykH5XS2VAFXpBL0h3cfI6vItfkJgHAODg6u47?=
 =?us-ascii?Q?V2H4zDOkD8cWXjg/+ZVLXaUU/HUdqfpH/6BD14heOE4Ril2z0TKtOGFo+wYw?=
 =?us-ascii?Q?Q5casSbPgpvdP3F2Hvj40bQHXrBU0htI7liRl5qbCFo+JY2qRNGRbJDI7Nug?=
 =?us-ascii?Q?som6OKHToQqMf2EQSU/nJ1afwCivxR8V2wB1q45V+iH1XBcRLvBjRw4clyvn?=
 =?us-ascii?Q?eacCg9tssn+RZGUEgrAlVWzEgh7kKTCqCtvMhLDHw/F0bC/+cPt6tZkgnJhj?=
 =?us-ascii?Q?FFjnrXtGcPkRxa9WPOdocoXGUQLI1fbQLZNN/obl6BtHauwBjcBIOGcg75j5?=
 =?us-ascii?Q?ldkx93QQVIk1KvKLGG7RcoZLbWxtnWB5bVqsnWpxMjrl9wa/xOidDIvVPw36?=
 =?us-ascii?Q?SrPed5kdFT0Uop7a8lnzzNRP2uNQnOnNTuHi9qCYFhShRvEc3RnavvDUKMV0?=
 =?us-ascii?Q?4zx8fpyjPX7tVjDy2/Zy8mn5HWlLBz52sBgiHzercZxIu89+k21NBATMMEvB?=
 =?us-ascii?Q?vX/Wb2phLeo6+C7N78D8c8TJGcOVwO5e7yzL0pHGVGely2zpRl6ilYb/qi2F?=
 =?us-ascii?Q?t29JtZVH+XXf2xYfEMVydSFGGt77jKH8PjB35pVrpGNR4dUdvLCuzTIm9X7p?=
 =?us-ascii?Q?ByApukxpPKvaK4Xil0//o6+sdgmsPjlly3SFENjM4iII804CqxDWATMlYRXK?=
 =?us-ascii?Q?7au5QbmwocnzIRjB3xdHjRxryBmfOGBSASaaagmN/qocz5agKlyea/fFLOHm?=
 =?us-ascii?Q?5POyEcaNEXU+2rvGhrNEVhsoDfJokZueDIBKdojR0FH96vTnmbkxHqm/wu/1?=
 =?us-ascii?Q?owUWHOUqF9JxLtfMBQyeDCVesUuvJk1f9RV8Dm5jLev5Mu2/44VeZZNJ8Da2?=
 =?us-ascii?Q?46pxrZYZv3KVEwgNsYRKyNQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20992e1d-035a-405b-9e93-08d9ea552e75
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:22.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMsvWrMxo0m7YajsVj9gWGujzkS9t4g01hLu98JFNUaYoGmxWNoo426+E314mUDC2WAXWPbbHYRaHmkxaLXRvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3910
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The Seville VSC9959 switch is a platform device, so the initial set of
constraints that I thought would cause this (I2C or SPI buses which call
->remove on ->shutdown) do not apply. But there is one more which
applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the seville switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The seville driver has a code structure that could accommodate both the
mdiobus_unregister and mdiobus_free calls, but it has an external
dependency upon mscc_miim_setup() from mdio-mscc-miim.c, which calls
devm_mdiobus_alloc_size() on its behalf. So rather than restructuring
that, and exporting yet one more symbol mscc_miim_teardown(), let's work
with devres and replace of_mdiobus_register with the devres variant.
When we use all-devres, we can ensure that devres doesn't free a
still-registered bus (it either runs both callbacks, or none).

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 8c1c9da61602..f2f1608a476c 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1029,7 +1029,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	}
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = of_mdiobus_register(bus, NULL);
+	rc = devm_of_mdiobus_register(dev, bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
@@ -1083,7 +1083,8 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 		mdio_device_free(mdio_device);
 		lynx_pcs_destroy(phylink_pcs);
 	}
-	mdiobus_unregister(felix->imdio);
+
+	/* mdiobus_unregister and mdiobus_free handled by devres */
 }
 
 static const struct felix_info seville_info_vsc9953 = {
-- 
2.25.1

