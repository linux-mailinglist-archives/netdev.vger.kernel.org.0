Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D68146A20D
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhLFRI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:26 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:26236
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244826AbhLFRCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:02:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6u5pOybKN25Grymt8kLAAWZun141u7pO5BrlNkPyLB07Hf7OnFJ4FNW9+1TzahfPh20ufET6Bms5p5hAWZs4SRI3WJMKoNDaK18/7DdmdjM7JiVFLpLGu6dUqRED1KYzq5yCJXXhHIaly55HTdwCaGjyoy+/rWM7AqbNp/StN9aoFJkJEBR8iWC2B28DY2iWH1T7KA+fAB4IB/mDoqXC47o1heFce3UDfFMehUtW0AI7ZeLRhJ6nDcym1jegoOMKJaN+yXXTqb67ROjTdJKs2+2oDl/suPHhYBtVxMA2XAbwUJvVdQyw6gfBGgXZbWdUm99+s2Ta3/wQrxGJxpR9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZy4ZP/Ouz22eYJca7dRFoM/oaNHmwTaFpAJK3kBSiA=;
 b=HbDGB7iinDW34Nu+30Z7pFZN/lWiU45Z6RfZDPLb1g8q+go2Y/oFwFWIstsVk7LvuS0iam+o+Q4ymXjuFtsyU8gGidOsaoKn/TS9c65OH0cd2qMTNbuNUPq3AjIF+kbQIgup7RWGZGSmHyD93Q8newUCxJ4cPwnKUlg8OujNMqrEo64oHUWbBIpbgJwZwEVhkzQWoW3icunwV42YXIjQ67fn69JJY41fD+CDNvSTAd1e3H9v0lBem5L8YglWD2CmybkiyKuVmeBgH37dqpePY2zprKQNTn4i8ubjwgeI8FrEy/7nQ9guiHBRwidLMrNvmNc0oY4KCaxUHq88ccxV7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZy4ZP/Ouz22eYJca7dRFoM/oaNHmwTaFpAJK3kBSiA=;
 b=OlceFpO0xsC/70fglcsBU2PRJmwnnOqYQyfg3BX/9JPQNG75yRO8ixKC5+r8oBXVsXMoVbyv5VBzkJaqefTK9CNIXDZbhLz5R8Y92VFp64a//z90ewXnzFk0EoF4u3W/8oix1Oz2GC8F9IveN+GXwRKmVdPpOM8lbdqu+ye/eFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 12/12] net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload
Date:   Mon,  6 Dec 2021 18:57:58 +0200
Message-Id: <20211206165758.1553882-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 359ba69f-6952-42a6-3c2b-08d9b8d9a477
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB49129C54C4525F53FCEA0E5EE06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFVXMWO4qAVL1DBWm4wgNVKHyAb7jWTLt9F7TViH9yBTgSMAYegLC+U54R/XAvls135F01TS6LInBmEid/sVu67Qc9uV13TZwfHQahsh01FCZ2kSf8e9WoepXMDhpAf8tDum0cbisILAInYiYQNrsFAiD60vc0Y/ObjSSa1izMUgMkB9fud5axYCGstiBed+g7rYrxzlvH5bMXKhrPebpu06HckRQaO1PNIKm4aDBv8rxO5isTloR4Zist9n9GaiHj2tuD07lAmpjbFqgwcEhI8h0+tvWt63QrU1JgI4B5gb67NG9uq/jfTh4OsYOGHFkmoMevYSYzLf/x+UYzsktac3uSWe1z4MHo+U8JdCFvhmFLn/C3w5VzLJT1Mszu/t7U6WNleV8jm+BDAYTSOYMLqNGRtcVdoDIaeiRe4pELbC62noHlQi9e2W+iR1PDNnMwgWI4CkaFuBB4TxXJ6d7ZBjmNy13m/aFJYSvg1+FFy8rnUqkRO/hmHxhS+rdmukNfdw89e6m4uD9v7OOtd9MmvrXQ/e6W3Es3i9JCH1W7FQtu6fKcO4rfB2PevlSF0xDUOn4XhDNfSeP6pvR0TpEjWfISrOpG8Dgn1nnUCknM1SgsPlsyQJj2KoFnalQNZKNFMDu8zNlraFdqnxIA3ruzoYPSwV7OQ50jR4qppCWP1itGeRDiVMW+ZVEPCwUG08WFKYJ1ltJ32b/S+tzAAMNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(66574015)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzR2V2d4S01CNS81eTc4dzg3VkJKQU5qbzNTbTBQeHRpaVpTQXhOVXA5bVVR?=
 =?utf-8?B?ZEx5MVhsUjZkZ2FBaisxdWViN2pRRGxPNml3aS81Q1dOTktaUDhXNVR0ZmQy?=
 =?utf-8?B?TFFhK0I3RFY0cXZDc1U5QVZWbW1DRncrRzc5MTI1TW5jcS9lNmU4eE5CSEhq?=
 =?utf-8?B?VmlRKy8zbS9YM2VOODVvSTVUQTBhSXgyU1FyQlFxOVNScmZPMFVkb25PcmVM?=
 =?utf-8?B?eDdRSmFFblZWT2gwRGJ2eVJwYUljNWc5cjQyakMzMy9CbGJlWEdUVW1xRXRH?=
 =?utf-8?B?ZG45eE9CU0xsVUVQWld3cGNHaEtZeDN4aHJNNUR3ZzhOMHBISDhJMmRFQlVM?=
 =?utf-8?B?UzU0YnFyeFRVbzJxNjVKZDRvbTFPd2NFZm9PaDgrcGxnVTBkWEY1c1QyRUZ6?=
 =?utf-8?B?eDdUQzRTMnY4REFGZ0ZPK0tHS09pU3ltWG0ya0V1alZuZmhiak1jb1JkZXM0?=
 =?utf-8?B?MzJtZmk2WUpjSzhaQlBRMzB4UExwOTdWdHV6SldsdE4reGp3cUNQMURsSHRr?=
 =?utf-8?B?VVVFWW1CeXdPZkJaY0Z4Qzh1L3BUMU9NeEFERjVsc0FtSkRGYVFTQ0hsOEZS?=
 =?utf-8?B?Y252UkVVS3Zmek5oSVV2RG56ejkxS2FqUGN2YldSRldpWVowV3FUeWo3ZTc5?=
 =?utf-8?B?TlpPM21vWm9TZi83d1Q2czR3OXIycS9FYnB0djJEUUFiREV6T2RIRE10TDVV?=
 =?utf-8?B?OEVVYStqejdLNGhZWDVoYmVPcm85VkFPYXdjUVh3TjJBT0hhdTBjMTlBVGZI?=
 =?utf-8?B?KzBtQytHZFRTQjVqSzlpNjNMQkUxeG1vUzhnSTQwVjlXZWZGaTRHRkpaSmN4?=
 =?utf-8?B?ZzEyTUVVNTZHMDV5c1pQeUswbnYrSm5uZ2UzWTRiZldHSXFtSkJNRlE3ZGN5?=
 =?utf-8?B?TGxYek9DYnF3Vm0zTy9rK2xRdnBKd3NZYXhoanEzTDlRZnpaaGJBTXh3Sk84?=
 =?utf-8?B?OEhNV2QvbFFHNGRsUGlZMldpQWc3QXdMblZEbHlwbEpIV1NMSDhJbXRDZU9S?=
 =?utf-8?B?bllXTUVCR00xZE5mU2o1bUxnaFpqZzhrNUF6a21Da0ZybzJ6QW5ReXk0UEhM?=
 =?utf-8?B?bHJ0Q0l1VVlxV1V3VS9nZU5QVXJGaDZZeFlWb0RFNXQ1d1pKV045TG40azN6?=
 =?utf-8?B?NGYwdTkzL3hUOHRWbmMveVhXcXptK2tpbnBUOGdvcEZuQzg5T0xUMU81aThx?=
 =?utf-8?B?dlFVMjNxYlRBOXFMYUJldXI3MUV3SjRzUFFFcHdVREtRd25IVXZpN0oyMU9l?=
 =?utf-8?B?QkdKYUJJNjI5SVYzUUR4QVpjcWN4L1pSY2dEN2lObWdXSzlMbjVtU2xabjVn?=
 =?utf-8?B?cjR5b05uV0VZeUZuSW5iL2ROQldnc3lmVEkyMUpJekZhY2I5a2hNaUVzSUY4?=
 =?utf-8?B?L2orT21sYzFzOXRjT0Fjdmwxay9DOGtmTmtoMElvTkVDaHlEZjFGN1hvcUl5?=
 =?utf-8?B?RFZjL096MzNlNTRXM205aURtRkV5OVByMC9Pa2VobEhxZmJnK0lrMjJONVh2?=
 =?utf-8?B?NWt4UVpaUEF2cXE1a0lJa1k2ZVhTTmVEeVZnVXVQeTY0UWZPbWQzTmVPaXBR?=
 =?utf-8?B?YTRTT0lKNDZJWFEzNWlXa2ZBNzlHMzIxdTJtUnpDNmIyNmFoWjZ0U1kzekd5?=
 =?utf-8?B?azZMMWhXTzQ5UUJ6OTV5dm9GTTRKbXpJNTJmYlhiMXpJdzdjb2w3UTA1ODlF?=
 =?utf-8?B?bTltQWlZUVJqRmlTYVdLUkhtbVhmelVDb2lub1BuSDFKaXpVK3M4RGNQZ3da?=
 =?utf-8?B?dFRlbWZSbTZtQzFwVlQvV2Q0UUJNQ0VYV2o5cnBVMTFsWVhUNFhvMmt5b0ZU?=
 =?utf-8?B?TzZXbXk4eGJ2bjcwUnllUjlVTi9pbEZHVThrS3N0bmV3SEMzQWpBeTlFSk9l?=
 =?utf-8?B?UHV3UGVLOTN5ZEYzbFNSSXZmZVRJeE9TY3NYbVc1NWFJSUFOYllSelAxY0hK?=
 =?utf-8?B?a0R0QzJnUVRWYnEzYVVIYkRBTWt4U2gvTW02bVRHc2R0YXhIUTNLR2F4QW1N?=
 =?utf-8?B?b3JFZ1pla1lXQUxKektXeXI3ZUhINjYwZVRwRkxIOUtzUUdtaVB2UnBqS3JO?=
 =?utf-8?B?cXY2YTJ6NmF4aWs3R0RYN3k5Qm1TUmlzaEduOUhWTmIzamxDV01RTVRhQm9x?=
 =?utf-8?B?Yk04cXBQVkhiZlQvZG9yZDBXTW9EZ2ZXa1NvTVRlRW85WlM1aFRlc3I4YzBG?=
 =?utf-8?Q?AY3qqwnIAeWfaeNxSATLWEM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 359ba69f-6952-42a6-3c2b-08d9b8d9a477
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:35.7889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4bPwRkrUw8JTqffEpaYwBKwkFONHIuNIG2z5EEeJV9tXExDey+qG8oKTifiPHTV6kgglVFMvTtvddn0QnqPDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't really need new switch API for these, and with new switches
which intend to add support for this feature, it will become cumbersome
to maintain.

The change consists in restructuring the two drivers that implement this
offload (sja1105 and mv88e6xxx) such that the offload is enabled and
disabled from the ->port_bridge_{join,leave} methods instead of the old
->port_bridge_tx_fwd_{,un}offload.

The only non-trivial change is that mv88e6xxx_map_virtual_bridge_to_pvt()
has been moved to avoid a forward declaration, and the
mv88e6xxx_reg_lock() calls from inside it have been removed, since
locking is now done from mv88e6xxx_port_bridge_{join,leave}.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v2->v3: added back Alvin's review tag.
v1->v2: avoid a deadlock in mv88e6xxx pointed out by Tobias due to the
        register lock being already held in the port_bridge_join/leave
        methods. Again had to drop Alvin's Reviewed-by tag.

 drivers/net/dsa/mv88e6xxx/chip.c       | 63 ++++++++++----------------
 drivers/net/dsa/sja1105/sja1105_main.c | 19 ++++++--
 include/net/dsa.h                      |  7 +--
 net/dsa/port.c                         | 39 ++--------------
 4 files changed, 45 insertions(+), 83 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c49abfb83cf2..7fadbf987b23 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2441,6 +2441,19 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
+/* Treat the software bridge as a virtual single-port switch behind the
+ * CPU and map in the PVT. First dst->last_switch elements are taken by
+ * physical switches, so start from beyond that range.
+ */
+static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
+					       unsigned int bridge_num)
+{
+	u8 dev = bridge_num + ds->dst->last_switch;
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	return mv88e6xxx_pvt_map(chip, dev, 0);
+}
+
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 				      struct dsa_bridge bridge,
 				      bool *tx_fwd_offload)
@@ -2458,6 +2471,14 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto unlock;
 
+	if (mv88e6xxx_has_pvt(chip)) {
+		err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
+		if (err)
+			goto unlock;
+
+		*tx_fwd_offload = true;
+	}
+
 unlock:
 	mv88e6xxx_reg_unlock(chip);
 
@@ -2472,6 +2493,10 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
+	if (bridge.tx_fwd_offload &&
+	    mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num))
+		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
+
 	if (mv88e6xxx_bridge_map(chip, bridge) ||
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
@@ -2517,42 +2542,6 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-/* Treat the software bridge as a virtual single-port switch behind the
- * CPU and map in the PVT. First dst->last_switch elements are taken by
- * physical switches, so start from beyond that range.
- */
-static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
-					       unsigned int bridge_num)
-{
-	u8 dev = bridge_num + ds->dst->last_switch;
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_pvt_map(chip, dev, 0);
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
-static int mv88e6xxx_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					   struct dsa_bridge bridge)
-{
-	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
-}
-
-static void mv88e6xxx_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					      struct dsa_bridge bridge)
-{
-	int err;
-
-	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
-	if (err) {
-		dev_err(ds->dev, "failed to remap cross-chip Port VLAN: %pe\n",
-			ERR_PTR(err));
-	}
-}
-
 static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->reset)
@@ -6272,8 +6261,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
-	.port_bridge_tx_fwd_offload = mv88e6xxx_bridge_tx_fwd_offload,
-	.port_bridge_tx_fwd_unoffload = mv88e6xxx_bridge_tx_fwd_unoffload,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 21622c60faab..cefde41ce8d6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2077,12 +2077,27 @@ static int sja1105_bridge_join(struct dsa_switch *ds, int port,
 			       struct dsa_bridge bridge,
 			       bool *tx_fwd_offload)
 {
-	return sja1105_bridge_member(ds, port, bridge, true);
+	int rc;
+
+	rc = sja1105_bridge_member(ds, port, bridge, true);
+	if (rc)
+		return rc;
+
+	rc = dsa_tag_8021q_bridge_tx_fwd_offload(ds, port, bridge);
+	if (rc) {
+		sja1105_bridge_member(ds, port, bridge, false);
+		return rc;
+	}
+
+	*tx_fwd_offload = true;
+
+	return 0;
 }
 
 static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 				 struct dsa_bridge bridge)
 {
+	dsa_tag_8021q_bridge_tx_fwd_unoffload(ds, port, bridge);
 	sja1105_bridge_member(ds, port, bridge, false);
 }
 
@@ -3231,8 +3246,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.tag_8021q_vlan_add	= sja1105_dsa_8021q_vlan_add,
 	.tag_8021q_vlan_del	= sja1105_dsa_8021q_vlan_del,
 	.port_prechangeupper	= sja1105_prechangeupper,
-	.port_bridge_tx_fwd_offload = dsa_tag_8021q_bridge_tx_fwd_offload,
-	.port_bridge_tx_fwd_unoffload = dsa_tag_8021q_bridge_tx_fwd_unoffload,
 };
 
 static const struct of_device_id sja1105_dt_ids[];
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 584b3f9462a0..bdf308a5c55e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -222,6 +222,7 @@ struct dsa_mall_tc_entry {
 struct dsa_bridge {
 	struct net_device *dev;
 	unsigned int num;
+	bool tx_fwd_offload;
 	refcount_t refcount;
 };
 
@@ -826,12 +827,6 @@ struct dsa_switch_ops {
 				    bool *tx_fwd_offload);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct dsa_bridge bridge);
-	/* Called right after .port_bridge_join() */
-	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
-					      struct dsa_bridge bridge);
-	/* Called right before .port_bridge_leave() */
-	void	(*port_bridge_tx_fwd_unoffload)(struct dsa_switch *ds, int port,
-						struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index fbf2d7fc5c91..20f183213cbc 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -270,37 +270,6 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 }
 
-static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
-					     struct dsa_bridge bridge)
-{
-	struct dsa_switch *ds = dp->ds;
-
-	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge.num)
-		return;
-
-	/* Notify the chips only once the offload has been deactivated, so
-	 * that they can update their configuration accordingly.
-	 */
-	ds->ops->port_bridge_tx_fwd_unoffload(ds, dp->index, bridge);
-}
-
-static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
-					   struct dsa_bridge bridge)
-{
-	struct dsa_switch *ds = dp->ds;
-	int err;
-
-	/* FDB isolation is required for TX forwarding offload */
-	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge.num)
-		return false;
-
-	/* Notify the driver */
-	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge);
-
-	return err ? false : true;
-}
-
 static int dsa_port_bridge_create(struct dsa_port *dp,
 				  struct net_device *br,
 				  struct netlink_ext_ack *extack)
@@ -362,7 +331,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
-	bool tx_fwd_offload;
 	int err;
 
 	/* Here the interface is already bridged. Reflect the current
@@ -379,12 +347,13 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, info.bridge);
+	/* Drivers which support bridge TX forwarding should set this */
+	dp->bridge->tx_fwd_offload = info.tx_fwd_offload;
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
-					    tx_fwd_offload, extack);
+					    dp->bridge->tx_fwd_offload, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
@@ -435,8 +404,6 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, info.bridge);
-
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
 		dev_err(dp->ds->dev,
-- 
2.25.1

