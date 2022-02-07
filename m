Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDD4AC584
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358785AbiBGQZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387628AbiBGQQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:24 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21384C0401CC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPw7/tFt23hekIOVXl/Y/OtGemitRx6Yt9iLh8scxiOOG5fPs6ZF5zWF/U0tutJARZn2R/LpdXkmi/EsYfOT0E4mGbzHPEmXxfcv1WlnKn8+fSOCGRCbn+c5OiFSwdm7O+gCQ8kZI0FCnAoMRdsWKZl0nXjxYHGwqxKuzNF41r1+4tmkkAD8mP5JQ1qc0bR8By7YNJiwfPUaAfgs0NJWZh8aqrrXqsK1uSDSU6nteVSB2gDLu3Jdq7A1AFzOVGdpsQqr7qX2p03W575aGRQBeoEzw1rMuAwFdgUClFLDexrZRqqCLpMZV7MsOXcothkDfXPy3N5qI/P74OPgqJdECQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqW8Gv8PqavDjinMhTorYjEbByafxsUdYw5LBF5Rx5Q=;
 b=m8YLU5Qx/6WD/gL7Wjtp/yV674gYt/SjcKh7g6YYZ0dMzCW4jhL+4wCBmi+mskI7x4wklpFY1W5mvH6yBVA4rOYrFhrSDj/I1ZWgJrlWIZ4hlgDw2iWkV+QUfqC62/Sy+/pszDKDZqMCFygJ1c8+AtzVO+Xhvz3832UFDxJdIiC3/F7YzR2i7KEYwHvfW86pW0kat69CTXQyDFJPEn56USzgWntZaVcFoL1+bcaHqzTCHJMH5SCAeAl596aFd7eQXFTnehB16u1RLtEPueI9rwUy7rdGxUYBE12XzsRUcThq0WnLj5+XXrbIiPNhiJW31kuoWAbIEQO147D0KsLphQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqW8Gv8PqavDjinMhTorYjEbByafxsUdYw5LBF5Rx5Q=;
 b=iDgVouUG/xo+yx0UoyTEz2H3iszRKBjLcRZpjrgXDV8u5PjKAM/oZcVoQa2KOX5/EPWWDAIetDmHIeq2N2e+CofJ2f0vozkS/50SjyFXnIO+TgOlip8DqrZ3sWIAx57KLHImNz8HP5pESERcGNvany+jIEwL8WpHDpna+FemI3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3910.eurprd04.prod.outlook.com (2603:10a6:209:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:21 +0000
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
Subject: [PATCH net 4/7] net: dsa: felix: don't use devres for mdiobus
Date:   Mon,  7 Feb 2022 18:15:50 +0200
Message-Id: <20220207161553.579933-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 07ff88ef-916d-48c2-aa8e-08d9ea552dbb
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3910:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3910E52EF3316730CCEF2124E02C9@AM6PR0402MB3910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6rWKYgC71v8vHEe+dJ/vno4AsSQFJG/xR/9U4zsbhapkhD429BSU05lxVpY3sw4Qtj0sxtdvADdftpPlvArcWUVZJbY4IUJ6S8ardjaK+Iw8vl7XvyKUiMhie8vU0LWUVBWty7IS+I/bRbn5U39NS6DC4V6pWcEOHgxQJJE4ZgrZtrmSEbB/OXpZ/kZgFodDpNo28CQla9Ql7cvdrkk1M/vDpiaTs71sAVSXZWu2nDKwI2U9RynmNOqOd349OSX5SO97ao9cFlfLkdS3qSddnu8v/PB4bRta3Qu6mOMRYpPzF+0VxvYLtoQSJGhJ816LndH57MBLDo466A9ytDTCHrNoZ0Cyh5o0CBO9jENpzW5eFHBlCkbJxMWG7PGHYFoRFW83J0Izt4/y3D0dcAsiduKj3lj8fSNl5VYzQXmMAAvS9a6cs8Cxfd7dMOxe3Be2U3Y9uc4gBUmEDse26mgIWT6aldqtmvOKnz545NCcYTEYug1OUdfHe6ABMMPTskrAulJsc/q2bCF3oaMFjowLULJ13N/F92UR5WUE9xfCb9Xy7nqY36rHCa3ZhxNZjVV6ZZXpEya/Igqh/MLx7iHmIUS3ntb5WUfKTcGAmIPLowcC6BGY9jaubkH1gPzLudMXNoLg+Uhuze4Sw05LqkwOIabPv44dn/xR1L1NLki9N3uLAjtAuq3Blo/iLTquZSUOgSm0qLmacbLSyL9roUAcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(36756003)(186003)(6506007)(316002)(6666004)(54906003)(6512007)(6916009)(38100700002)(2906002)(38350700002)(2616005)(52116002)(1076003)(86362001)(66946007)(44832011)(83380400001)(5660300002)(508600001)(8936002)(7416002)(4326008)(8676002)(66476007)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uK+B8wWKq3JBhU9AOjsQ3oCN48/WJq6wi1K1zF7lSCIJ8/PJmcLXmW/PGi6p?=
 =?us-ascii?Q?Cw7gZsw+Oo2z0WrgiaDRJGIaqIlkEwSJcp+8F/kyDTe15eUc0ItaLeVECWff?=
 =?us-ascii?Q?kTIktB9WGuCyleANnaPgUFjlcYc+akN39Wzpiu3usLJdSHCvgIpiQsIHhezM?=
 =?us-ascii?Q?otfAciyRSa1x7IHF1uWP5FRCnPjA1EzbAQw9KTNgUJULmUxhxHoJML2bd6hN?=
 =?us-ascii?Q?6Z20vyhUr3vRt/3tAn78AXd92c/dYyTyvqO5l+92H6qD4M3hT6TT8tjD66H+?=
 =?us-ascii?Q?6jBsgwDXQ1+nUXwvqR8y8Mo7umMf8cYMAkU81iU0nKviTPjHCyqF2YYuOPne?=
 =?us-ascii?Q?lVGqDAHLwjq5KU7KuUuMuV4JUIiZDVWqQ0DD7ncfUp07GB1QPRD3pSpR0+f5?=
 =?us-ascii?Q?7uVViU8IDJwxmeEgc5m/6Bc0OgI0X7xEaZw/GemTc9f4ufz/wqyF7mq2m4EN?=
 =?us-ascii?Q?Z55OX96jSMY2UrdQ4sApQlSFrHAtTcFbR986dAKLNFb3UzlAemKA9VeQzY2F?=
 =?us-ascii?Q?Z80hjPByjYVTphwcGjWBGKYHCuidsFYlwqPOtSjXJZyNw4WPDccQfC/NRNIa?=
 =?us-ascii?Q?ibxS0hVWU9mAq45OqHNbTfqg+uXzrAHCkT3xVEuNvVwwidhYl1T/b2KGtzXN?=
 =?us-ascii?Q?B+s96YzuwdBqVmtCSorO+9K7F+bEOX2sUrRutBFZO6EkjuXSlRX2XZ/tPAK5?=
 =?us-ascii?Q?0yrWsrrMt/rV+rpwTqIyTKrbYeSnD5QoWXfn10pZzLT++jelZpvRiXK+iZv/?=
 =?us-ascii?Q?cjWfLr2+/mDUXNIkn+aaBRxNTaKygZ7RFzGRqjukPinZxRN/aoVRgzUeejXM?=
 =?us-ascii?Q?D/dnZvDukggVlX2eFD7rOV5xE+AOfQSxpu9bwP00QSdkWyTZSUgTd2r9BsCK?=
 =?us-ascii?Q?6dXM2OxXITdl9DX6OYhl1GaPzpQbW7h9thKk8cDjgZj58jQuTVJ6bn/7y0du?=
 =?us-ascii?Q?+uU9kOqTl1PPtt4yGIoNo7V+aPaEaERZff+sUeSIFJ9BXw4Bj01JUt2wOnFU?=
 =?us-ascii?Q?OOqoxtc8ukM1880UCt3sL7jqeMqRxnzTKeqdVDDkI6D+qtQVCk2zYyIk1qEt?=
 =?us-ascii?Q?vOn9jwPp9Gav45HTgwCwco5IWVZ60JixcZBj40WD2tXdj6Jpd2lDu56b1g/k?=
 =?us-ascii?Q?xDz9Yu9FVW8PUrsnL4ietoOJCzMWJ3F2wuqKVph53/P8AUhfBXGQ37fZ4Tg+?=
 =?us-ascii?Q?juU6UMtf/1maL05z1mt6731ktaYBsJU8x3NP5WuAQ/zNpbOLYZ5LXP1pqbE4?=
 =?us-ascii?Q?Fr8rzt8e7t43r+FIl5f3AR5k+jqVU/v41nXTvaDJJVxMbNxLQjRmqS/aIlX4?=
 =?us-ascii?Q?sqev5eOK/Q3cgRgm/AXHnh82MPYV5d7vKFb9vbE9OebUuyZjdxRHach7Kir8?=
 =?us-ascii?Q?qmZPSs66Ta42f8k4RSd+XLEDHamYU2MXTa9KAbx9i46AjQ3uFSo/+MEkrpKW?=
 =?us-ascii?Q?HsIouOIfWYWofPKM2IGgokyB5AK9UoHGYa5ZdvB982hhtBaVL5aUaPlNujxT?=
 =?us-ascii?Q?lsxchdMoPorSIkKCeUEGtNykg0OB9XazyD+9aCE1pFfTh3k6hhSP28gpGQMZ?=
 =?us-ascii?Q?BDz+18Vwc9GzxrjG82QntWcIXGdL1Qn/8EHbdyY+iRmnTH4MQhyaTDRZTV8y?=
 =?us-ascii?Q?05STU2xeeSrzMpcvIeEVj5M=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ff88ef-916d-48c2-aa8e-08d9ea552dbb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:21.2372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ed21NlSwhlu4GeTIexEucPj5gq6ixP7X6bB5gr/v2krlpqwpX81kIKNk4KY4VIXEw97NfRIfhnCsDlTAiWoBA==
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

The Felix VSC9959 switch is a PCI device, so the initial set of
constraints that I thought would cause this (I2C or SPI buses which call
->remove on ->shutdown) do not apply. But there is one more which
applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the felix switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The felix driver has the code structure in place for orderly mdiobus
removal, so just replace devm_mdiobus_alloc_size() with the non-devres
variant, and add manual free where necessary, to ensure that we don't
let devres free a still-registered bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index bf8d38239e7e..33f0ceae381d 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1061,7 +1061,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		return PTR_ERR(hw);
 	}
 
-	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
+	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
 	if (!bus)
 		return -ENOMEM;
 
@@ -1081,6 +1081,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	rc = mdiobus_register(bus);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
+		mdiobus_free(bus);
 		return rc;
 	}
 
@@ -1132,6 +1133,7 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
+	mdiobus_free(felix->imdio);
 }
 
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
-- 
2.25.1

