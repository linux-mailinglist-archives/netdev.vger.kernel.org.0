Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEC0468769
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351241AbhLDUPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:15:45 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351362AbhLDUPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3VQHNMv3XZU8chtFZ4diOqb0fRxD7LH1ulb86uy8U4QTWIzSAEr2syaSYsuPnu6HQmWBjp5YjAAmH0EYZyBGDxYbG8YIwHUAgmkhdVKuCOqkb4pOEm1WRlU1TLhtOd1heMOVoktjdrk7R2hgrepognHGxHPLEKMG1Mo7n4Nsc7+W+TrnLruKL54gLggB9RqZRLNfxJth9HbLAvuXqYJ1842vWMBKs+9btmtpRYNJ1BhEj6USblP1wi4zGr4bJJRMhef71oLhyL+00grBlXs53jF4eZd4ticpIVLB/kffss+f0Bp4vEEsqExt61upf8KatWW5PwLOrY+CMNk/SweHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySI4RYoTpvt3UjSV+tdwgZAS4cqT479HgcdUzEugzoI=;
 b=lkvQfk4Wwtbz3kma829U5mcEEdVpUx5eUpVaQkbS6V3ZCBXFFELPJXnwDY6GjMxwke4Xa7vB7jR912UuUxz7Izz0qpv7BiRM7ik/cwyiB6P7sHSaJZVc4iAmabaBR7O0Uz6aYXTUVWqDyN9c3W05vqdBapQWkpm6IblzHP+4JSx7KrsDT4r/lQs0gLBKx59bNaymbGfAG6YHyT8NFjECcxgzU2HFSjKABQsEadcbPFX0C5dMhpjpDmzMt0yDCZt0AJT2IjAKXad8JbaOxG4BwaPo9yC/ytiZBwF8zufSOJ1cOqAPqeOv7ASZxIy9miGHHM34/Tsd+wsSFR+01NwbMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySI4RYoTpvt3UjSV+tdwgZAS4cqT479HgcdUzEugzoI=;
 b=iK/u1wfcE/bJEZIUmyKhB5Z3pDtYcIjlZd2HCIg/HeZIMFRzlW4VTP0q2fB/GAcsDAX4nm2CngY7LZcQJ6IwuVXyJelW1yMCkV7dmeKs7a3ijapAG6Tc4/nO4PprXBGCEcAJd7HFJ2JG/hWAznGbVoj7PGLWi153wuGXybwt6CQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:12:06 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:12:06 +0000
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
Subject: [PATCH v2 net-next 7/7] net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload
Date:   Sat,  4 Dec 2021 22:11:46 +0200
Message-Id: <20211204201146.4088103-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
References: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:12:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16bed5bd-8c94-453a-d96b-08d9b7625836
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB36517C840A45AB617F0324D0E06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ism6veSc6NfJCJRjB86eWZ5QnJahcdcwmn8MahidEeUpkcyMby9XY4n5qkGISgauZNgg4coc6WLTpqUOnAb3T5ddCV7O5fUmDwo4yTz9xnMdU3gLRCBqtCkzkdXfjKjZy2pDn6Y1WOGDzFbb2vSRV6jGR9MNAO5Jhs4nQO8tmvbqGnmGDUwY5ueF/fZSrJmXncVe8rRb4p60syADWfKJsrxX8r6DOKc3GAPVJfjEUsL3t8pcAdqdZOO1ZjxGweQutIvzwUtcJ00kx/oNsod/BSRhDNGXLF1wEThJbDc3tbhYCi7dmTlBCAgXm68NoxdWA5TyxtPhj52KrWoyA257s2SPCDq/riPkuAty/WojaQtEKuQ7456FngIbQUAlTZR9SXEal/O3ejxqchZ6m6h7Yfh4LVV9d9zcFjIFNi7+uzfmfHxhXbFdI+XzT0Zt523GAQUcrF2H6wvsEBPQsrs6B7aL+sUcsCPZYJKwYN1l1fAd3yQu5932EGodEHHMaU972UKxv1NS+zhirlKuFWlIWU/8koHBIoD9XixkEM3qarscZwc/u1RFJTTL7+hdTE5sJLB8qZVhMwxsuQOZUlhhcLgje9jk2KMchTcS+6tjVP4wDsPfSGh8lfLA0iur4pXFOVd1NwQs2tfYZ0Uqll0WO8NlmHGUwzWQHlKyBP8npqU7HnY8cfiVyhdvl5GVOb44n3w07f72zJ1TzSKutwb6xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(38100700002)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RqC2U8+0BNW9gMhhi98d/3dV+n+oawOfRs8qA1V+JfpaGr1FAce58etjaY4J?=
 =?us-ascii?Q?HWNT/MidP4+AmAXTglYesihb1gF6vTM4u7ef/eYYkHmZ2VcqnxzZCEGTprV2?=
 =?us-ascii?Q?W1S2CTYwtALNxxy30IzzRwMSD25VvnBmSlrSfZl0CkyXnrznq0esIhJDG7PC?=
 =?us-ascii?Q?tKwfvTBwazY3XQKB5W7loqXrf+JVzGuNbLlRNnAJzasHv80qUlXVcV8CDT5I?=
 =?us-ascii?Q?QL6nA0kthQIN/DwJjA7F/OD+aCKvf6FpFWOPBAFcEII00Gk8Vfc5nLA+0V3D?=
 =?us-ascii?Q?HAUzTMVFgLXgQzSuQfCPdasygrw+/3HBm4gVSLdBWAKIzof5/yTLf8q2UlSv?=
 =?us-ascii?Q?qxCWCSMXJXKHDY62pxKoOZSP0DlE/ls5gYY98fAiGGSaR8ASYdvrHWIO3hOs?=
 =?us-ascii?Q?x4y1WI0/M74EnOGqawSO5XY96uyfEukDJsbHKz+JBRnZARmEIpfcCr6VwbXR?=
 =?us-ascii?Q?HZ6wmp+dcQbhaLgQEo2D0DG72t9VY7RFF45c6Yotf+2xbVJnhzkBIpF0CkK3?=
 =?us-ascii?Q?j7K4KwBZs2WsO7yhRhV2tp3E5eUmJId2HtR4ZN2huFImhYf+IdoTL2yCha/V?=
 =?us-ascii?Q?zcaaWxjVpAuZET2sdQu1kIcYAcG5GUIYw48Z1XCaOp/OvCZfBiZvUUOGPraj?=
 =?us-ascii?Q?8aizz3H5ldFjrXzNbkVniuX4ElGXuCwxnasC2ranpcPZFwvPGxZuk2yzXa0f?=
 =?us-ascii?Q?XjJsqfTnGazJURgMvTufsiLbJH+MlTFD+V99W9V9vjj/9Ike4oREPovOtpr4?=
 =?us-ascii?Q?e7agjVb7QSAJ3D3QJUZQRYO97q5f1dsuaZRrb3RjfjH0gGerPvmSVSN2DRVZ?=
 =?us-ascii?Q?K/zXZa6hUNbhXtu+8xpDn8bbbCIHD7ZLW99ULQYJpAU0EmDxDoRH4emiUUTv?=
 =?us-ascii?Q?J4UdkBY+2wTbLMtNRx6k42PF63dLqwA0rAcW9WuBT+3nawvQHv0F6LRWXpDT?=
 =?us-ascii?Q?nnRmqUXzE2VOQWpxJIn9xYaVyWJb/U6y9TpVOCYXjWHw9mfqFn9uZOOG+xjr?=
 =?us-ascii?Q?w0Yde1wwvQB22j5zIN7cNpmfLpDWH+fElABScLABY/p3pSqvw3g5W0/NSrtB?=
 =?us-ascii?Q?uvNMCTlbFXZZWImVDdDkseErBJVWTr4+U+lZFycWegfTYOFeZHprjxZ4GVEW?=
 =?us-ascii?Q?9/nMjKlwiomUeFwJEV/6ikBRtethi0npBwIuVzLSdax1P3pj4ldDOR2L6n5d?=
 =?us-ascii?Q?mO/IHtFqORJxufnuus0hTOKTgoLHv2eIl+NW3wTr7fYHn/s+Kp3dU+LVhfS7?=
 =?us-ascii?Q?ySeqEvNAZgG2VqVybjlodJvvL4uYs4nA6rSq3vLN+srCglbDIf956wJotsma?=
 =?us-ascii?Q?94ezdqygPreVE38tMpwRU8ZqoQYP/uTs4XIzqKts1/JbMhEchzL65HzVr3JP?=
 =?us-ascii?Q?ukm3RdG6kP5XWnhHiZduU5CXszOygVIePaiKSCRlkuez7fT8LEHIwRfgDAUL?=
 =?us-ascii?Q?2RpMe/aTmWHrvQ8Z1lKn6omuaZHLiJe1fCarT7ihmPp9yFstBgHUD6mtpT6t?=
 =?us-ascii?Q?U5kNHuNF0um3HLnEiKAJ3x6oGWS5yV8ZYEtv9p+VyGHVd2CCU/te8T/H10zJ?=
 =?us-ascii?Q?Cgxf688ENS/fkWbhVQfrjkoS7yzSJ6gTyLMbmYpxmWqpnBFrUu7M/adkRqAl?=
 =?us-ascii?Q?QBOHZWcB3kgZamNBDuyglWI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bed5bd-8c94-453a-d96b-08d9b7625836
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:12:06.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BemWf9NKYpHnhw0tI+tPjedoNTFw/1llsHasjnQ0Z6V7BYkj8pudfKbDZ47CpaXBgy3T7GDQIOEvt3581/hlTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
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
---
v1->v2: avoid a deadlock in mv88e6xxx pointed out by Tobias due to the
        register lock being already held in the port_bridge_join/leave
        methods. Again had to drop Alvin's Reviewed-by tag.

 drivers/net/dsa/mv88e6xxx/chip.c       | 63 ++++++++++----------------
 drivers/net/dsa/sja1105/sja1105_main.c | 19 ++++++--
 include/net/dsa.h                      |  7 +--
 net/dsa/port.c                         | 39 ++--------------
 4 files changed, 45 insertions(+), 83 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c30d1f825776..ec515045c16e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2451,6 +2451,19 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
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
@@ -2468,6 +2481,14 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
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
 
@@ -2482,6 +2503,10 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
+	if (bridge.tx_fwd_offload &&
+	    mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num))
+		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
+
 	if (mv88e6xxx_bridge_map(chip, bridge) ||
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
@@ -2527,42 +2552,6 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
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
@@ -6282,8 +6271,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
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
index b6c8a1a9ec18..fbe8c054d2b8 100644
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
@@ -361,7 +330,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
-	bool tx_fwd_offload;
 	int err;
 
 	/* Here the interface is already bridged. Reflect the current
@@ -378,12 +346,13 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
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
 
@@ -434,8 +403,6 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, info.bridge);
-
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
 		dev_err(dp->ds->dev,
-- 
2.25.1

