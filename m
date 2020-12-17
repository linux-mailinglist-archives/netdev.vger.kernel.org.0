Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283352DCAC2
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgLQCAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:00:52 -0500
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:59936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727090AbgLQCAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:00:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdeunZH7sUPuPZ/s9kDs0UeLoIRMtwWpiL7nF4Bd2EkWJEP5O6mzXaG9d4NbMgh3A+VZuqvDWPoToY/ed0qjcZSKwB5yqr9qMLyyAAGdu8HD2AYfLxH4fuRFkTk+5qK9JU1WzMAIeChY6doC4HoDsst7NumSmia5Zmy4LUC0Tbu2hVlGhEoAsY8fDVH6BaXGdFBhfDRMxCik2froEG7Wh7LSirpuH/4WpXtDjlHV0a9seu9bImhIGFT+Cg961QkwuGYBSBKnebzrRrEjeSc9QNIRtKGUtquzqHU8dHkMan5+WjBPDavVu9naWDP39NWHmmCPBpvXDIDGWEcPLn72fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k09LJyuBB4q+ysQ7obOcjRr099IUwyTZUHsUvAuB2pY=;
 b=lU/7yEdpY88jO2w6/Aqiy3VkfsdZv08wuKWCObdRw32ElJNNVK6NZvEIDKpXi9TDLyz2i9dzG6Dd7TI/w0Fu29q2dYg+4+dBxVXuikYH8ZD0RNB44tU5rHkt9bwRDEPnCeN34j2vUP9oJFrGHLyYF+x9vzrrZxj7gCb98+0ZRvml5wGLYe4nfztnUbuxIdSFqYW6imfri8n6Ss2SknCUuXS1zyZq3yIGAKfsHuWUWlYwsakIN3t2F4qW8YJO2a3A6KATRYVh1RYVrsJgTHJQDGbWNBPSdmqvZuk4XP0vZ8DPofIO+dMi0X6tumfBx6gs6frFv2M8nl5bkaQ5x88vWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k09LJyuBB4q+ysQ7obOcjRr099IUwyTZUHsUvAuB2pY=;
 b=P5ThGBzazcBFk1ZTYSS230qeRa0HCbEeDSkseN/TB7BtipsKnDepqpnxhUOLq5G7sG6G8ELmHH2wR8hozkZ9DAaGf1rgMDzoURrfhtzc8cjMS3pO5RMfoFKm8gAOWjnbARHWynaZShZpacy/0dLNii/cTFXmyYs0a3HNA7I+A/A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 5/9] net: dsa: remove the transactional logic from MDB entries
Date:   Thu, 17 Dec 2020 03:58:18 +0200
Message-Id: <20201217015822.826304-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b512e81f-2995-4b7e-afb2-08d8a22f572b
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69439E7B38FA4F5BF56B7988E0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eHwqbkougoTboEoXWqjNEXUeosS8JB6aMsrmTQQiXqnXvaJzJiifElxfeOPrdcdQL26UD6cTaW/M9fPR09gBHXmxpCfUxa9EOZbTxdw4KIwGKkRUrTm2TaMorpOv5ez22XrnWf2iSwH4upKjKd7qdRFslFVTn1IBcRtYmaIBsqVDxFXFaCfZEVK1rqCOx5CkjteVykc7r62GhlVDmEi7h2I2n79le5yPB+Njj/iFMn6FZBCM2KZPHBIW0p2UkI3PtSjZv96cnhMkLeaPN1RhjnGoniAmd+hVj5M7oWhOkQIgDsfhLeUq2I8NQP+pL6fmtXfwR0xGxWxfaM5IQcLmd72KNtKza2lsjH4izYInn0o6bEM9NO9zQI6LLZxL/SDK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(30864003)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EpvKrgIxGL0lagKydbFw7wMLSVTeupHA09qs1ZBe6vAIJE1/AgJsERajBsRG?=
 =?us-ascii?Q?4uoHNRjg+mFl5kssR9QsieqKrbpOZ0q0+lQt8b0rljIQEWIk7LNCF1e1phFF?=
 =?us-ascii?Q?Ssx0deO9IhejrvSmiDj8ZhN2ui2P4jka1G3QrmUJJYXiS/69TyxS2/9isN6D?=
 =?us-ascii?Q?v8UKxO9yNwtmdyDUOqK+XqvDnXXFkPQlTQRyAtRFs1qoB6G2JCfB/EF++4wq?=
 =?us-ascii?Q?KdMgjsIurKw8QUlwf0ngXVMDh9MLLMFpufpKMC0ezBqYZDohMrArDluKx1uD?=
 =?us-ascii?Q?zppKt0dfNOtZltRWDWocf3ToZhz7uwE46P3lsLQQzDdVRjz9MfnAdTV9GNi6?=
 =?us-ascii?Q?jUZ6VarF9Lho1jKs2Yo+zKHQYCYmlL6Okkab0OO/S4Hnk6QPncTbfbrvTYCt?=
 =?us-ascii?Q?vD6WbfZk/NMNvsV9niATUz3H860XDiI23Enx0Ahjp2CqHmG8LEUSBjaNOYDn?=
 =?us-ascii?Q?FGzweGYLoT7bDPUWuZ2CIUZbx6LACaO7S+h+HKB81mSuOcXDoxhMSchE1AVa?=
 =?us-ascii?Q?BHFFe+/OcxvbYZ0S1LK09SAWyz0rObnbXOmR5lBl5tLHFpUXcKlfRn/A40QS?=
 =?us-ascii?Q?K2nFJf+msfr1319nlqA0Hw9Pz8EAISZMb6pqxe2JYsN5XN1sIukYPbh8TfkU?=
 =?us-ascii?Q?Fn2/aJaZLLsqbkbvKzFdfmF7ePf4DMxpthPRty3uLayYH70oRrUTgHcCBd0G?=
 =?us-ascii?Q?bg0GpxuLMBCtskoh6m8+aT/1qLZP1ZjlB13RIdeQBAEZRFyEO5HvmV9Gtta3?=
 =?us-ascii?Q?KsDQZuzub6HryIqtiaqDaYy0X8p0Qf8aAHyCgIzM2ZbFfHcY6bpCDXOKcl2U?=
 =?us-ascii?Q?O+SYvtnrN8WJp4AQ8i5R8YXlfrKhoBRP/g9P/j8N5K2kFahd/ndSBVGykMr8?=
 =?us-ascii?Q?gsullz78xueSZCUcepvAKa11WAQ1YKH9BaVi65Gx3yz6DLrXfsihwBL4Jm8M?=
 =?us-ascii?Q?utKQ6Lm6MeIgs7vz2u0rIfXAvEveq6DiVR7bd/OXrf3Xd+uqb9P8L4A5ST9e?=
 =?us-ascii?Q?JNK5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:08.1369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: b512e81f-2995-4b7e-afb2-08d8a22f572b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWh4W8vutlTnVVSP8ssQrC5LjB2ETA4QLslz+6Er48HDjvEFWGYudilwj6Q9ABVPrHh4tOKqdN+dFc/WZTTYhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For many drivers, the .port_mdb_prepare callback was not a good opportunity
to avoid any error condition, and they would suppress errors found during
the actual commit phase.

Where a logical separation between the prepare and the commit phase
existed, the function that used to implement the .port_mdb_prepare
callback still exists, but now it is called directly from .port_mdb_add,
which was modified to return an int code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 19 +++----------------
 drivers/net/dsa/b53/b53_priv.h         |  6 ++----
 drivers/net/dsa/bcm_sf2.c              |  1 -
 drivers/net/dsa/lan9303-core.c         | 12 ++++++++----
 drivers/net/dsa/microchip/ksz8795.c    |  1 -
 drivers/net/dsa/microchip/ksz9477.c    | 14 +++++++++-----
 drivers/net/dsa/microchip/ksz_common.c | 14 ++++----------
 drivers/net/dsa/microchip/ksz_common.h |  6 ++----
 drivers/net/dsa/mv88e6xxx/chip.c       | 24 +++++++-----------------
 drivers/net/dsa/ocelot/felix.c         | 14 +++-----------
 drivers/net/dsa/sja1105/sja1105_main.c | 14 +++-----------
 include/net/dsa.h                      |  4 +---
 net/dsa/dsa_priv.h                     |  1 -
 net/dsa/port.c                         | 10 ----------
 net/dsa/switch.c                       | 24 +-----------------------
 15 files changed, 43 insertions(+), 121 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ce18ba0b74eb..9865e734150e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1747,8 +1747,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
-int b53_mdb_prepare(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb)
+int b53_mdb_add(struct dsa_switch *ds, int port,
+		const struct switchdev_obj_port_mdb *mdb)
 {
 	struct b53_device *priv = ds->priv;
 
@@ -1758,19 +1758,7 @@ int b53_mdb_prepare(struct dsa_switch *ds, int port,
 	if (is5325(priv) || is5365(priv))
 		return -EOPNOTSUPP;
 
-	return 0;
-}
-EXPORT_SYMBOL(b53_mdb_prepare);
-
-void b53_mdb_add(struct dsa_switch *ds, int port,
-		 const struct switchdev_obj_port_mdb *mdb)
-{
-	struct b53_device *priv = ds->priv;
-	int ret;
-
-	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, true);
-	if (ret)
-		dev_err(ds->dev, "failed to add MDB entry\n");
+	return b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, true);
 }
 EXPORT_SYMBOL(b53_mdb_add);
 
@@ -2211,7 +2199,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_fdb_del		= b53_fdb_del,
 	.port_mirror_add	= b53_mirror_add,
 	.port_mirror_del	= b53_mirror_del,
-	.port_mdb_prepare	= b53_mdb_prepare,
 	.port_mdb_add		= b53_mdb_add,
 	.port_mdb_del		= b53_mdb_del,
 	.port_max_mtu		= b53_get_max_mtu,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 24893b592216..224423ab0682 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -360,10 +360,8 @@ int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid);
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data);
-int b53_mdb_prepare(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb);
-void b53_mdb_add(struct dsa_switch *ds, int port,
-		 const struct switchdev_obj_port_mdb *mdb);
+int b53_mdb_add(struct dsa_switch *ds, int port,
+		const struct switchdev_obj_port_mdb *mdb);
 int b53_mdb_del(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb);
 int b53_mirror_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 1e9a0adda2d6..4c493bb47d30 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1123,7 +1123,6 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.set_rxnfc		= bcm_sf2_set_rxnfc,
 	.port_mirror_add	= b53_mirror_add,
 	.port_mirror_del	= b53_mirror_del,
-	.port_mdb_prepare	= b53_mdb_prepare,
 	.port_mdb_add		= b53_mdb_add,
 	.port_mdb_del		= b53_mdb_del,
 };
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index aa1142d6a9f5..344374025426 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1232,14 +1232,19 @@ static int lan9303_port_mdb_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void lan9303_port_mdb_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int lan9303_port_mdb_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb)
 {
 	struct lan9303 *chip = ds->priv;
+	int err;
+
+	err = lan9303_port_mdb_prepare(ds, port, mdb);
+	if (err)
+		return err;
 
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, mdb->addr,
 		mdb->vid);
-	lan9303_alr_add_port(chip, mdb->addr, port, false);
+	return lan9303_alr_add_port(chip, mdb->addr, port, false);
 }
 
 static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
@@ -1274,7 +1279,6 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
 	.port_fdb_add           = lan9303_port_fdb_add,
 	.port_fdb_del           = lan9303_port_fdb_del,
 	.port_fdb_dump          = lan9303_port_fdb_dump,
-	.port_mdb_prepare       = lan9303_port_mdb_prepare,
 	.port_mdb_add           = lan9303_port_mdb_add,
 	.port_mdb_del           = lan9303_port_mdb_del,
 };
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 754a2377989f..49cd82109ee9 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1116,7 +1116,6 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.port_vlan_add		= ksz8795_port_vlan_add,
 	.port_vlan_del		= ksz8795_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
-	.port_mdb_prepare       = ksz_port_mdb_prepare,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
 	.port_mirror_add	= ksz8795_port_mirror_add,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4e181c09f286..8e7439e91f60 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -780,14 +780,15 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
 	u32 data;
 	int index;
 	u32 mac_hi, mac_lo;
+	int err = 0;
 
 	mac_hi = ((mdb->addr[0] << 8) | mdb->addr[1]);
 	mac_lo = ((mdb->addr[2] << 24) | (mdb->addr[3] << 16));
@@ -802,7 +803,8 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 		/* wait to be finished */
-		if (ksz9477_wait_alu_sta_ready(dev)) {
+		err = ksz9477_wait_alu_sta_ready(dev);
+		if (err) {
 			dev_dbg(dev->dev, "Failed to read ALU STATIC\n");
 			goto exit;
 		}
@@ -825,8 +827,10 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 	}
 
 	/* no available entry */
-	if (index == dev->num_statics)
+	if (index == dev->num_statics) {
+		err = -ENOSPC;
 		goto exit;
+	}
 
 	/* add entry */
 	static_table[0] = ALU_V_STATIC_VALID;
@@ -848,6 +852,7 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 
 exit:
 	mutex_unlock(&dev->alu_mutex);
+	return err;
 }
 
 static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
@@ -1401,7 +1406,6 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_fdb_dump		= ksz9477_port_fdb_dump,
 	.port_fdb_add		= ksz9477_port_fdb_add,
 	.port_fdb_del		= ksz9477_port_fdb_del,
-	.port_mdb_prepare       = ksz_port_mdb_prepare,
 	.port_mdb_add           = ksz9477_port_mdb_add,
 	.port_mdb_del           = ksz9477_port_mdb_del,
 	.port_mirror_add	= ksz9477_port_mirror_add,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index cf743133b0b9..874cdc38fad2 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -253,15 +253,7 @@ int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 }
 EXPORT_SYMBOL_GPL(ksz_port_fdb_dump);
 
-int ksz_port_mdb_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb)
-{
-	/* nothing to do */
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ksz_port_mdb_prepare);
-
-void ksz_port_mdb_add(struct dsa_switch *ds, int port,
+int ksz_port_mdb_add(struct dsa_switch *ds, int port,
 		      const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ksz_device *dev = ds->priv;
@@ -284,7 +276,7 @@ void ksz_port_mdb_add(struct dsa_switch *ds, int port,
 
 	/* no available entry */
 	if (index == dev->num_statics && !empty)
-		return;
+		return -ENOSPC;
 
 	/* add entry */
 	if (index == dev->num_statics) {
@@ -301,6 +293,8 @@ void ksz_port_mdb_add(struct dsa_switch *ds, int port,
 		alu.fid = mdb->vid;
 	}
 	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ksz_port_mdb_add);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 720f22275c84..a1f0929d45a0 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -165,10 +165,8 @@ int ksz_port_vlan_prepare(struct dsa_switch *ds, int port,
 			  const struct switchdev_obj_port_vlan *vlan);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
-int ksz_port_mdb_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb);
-void ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_mdb *mdb);
+int ksz_port_mdb_add(struct dsa_switch *ds, int port,
+		     const struct switchdev_obj_port_mdb *mdb);
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_mdb *mdb);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9206ba37d4de..dc9da2d46786 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5248,27 +5248,18 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 	return chip->info->tag_protocol;
 }
 
-static int mv88e6xxx_port_mdb_prepare(struct dsa_switch *ds, int port,
-				      const struct switchdev_obj_port_mdb *mdb)
-{
-	/* We don't need any dynamic resource from the kernel (yet),
-	 * so skip the prepare phase.
-	 */
-
-	return 0;
-}
-
-static void mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
-				   const struct switchdev_obj_port_mdb *mdb)
+static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_mdb *mdb)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
 
 	mv88e6xxx_reg_lock(chip);
-	if (mv88e6xxx_port_db_load_purge(chip, port, mdb->addr, mdb->vid,
-					 MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC))
-		dev_err(ds->dev, "p%d: failed to load multicast MAC address\n",
-			port);
+	err = mv88e6xxx_port_db_load_purge(chip, port, mdb->addr, mdb->vid,
+					   MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC);
 	mv88e6xxx_reg_unlock(chip);
+
+	return err;
 }
 
 static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
@@ -5413,7 +5404,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_fdb_add           = mv88e6xxx_port_fdb_add,
 	.port_fdb_del           = mv88e6xxx_port_fdb_del,
 	.port_fdb_dump          = mv88e6xxx_port_fdb_dump,
-	.port_mdb_prepare       = mv88e6xxx_port_mdb_prepare,
 	.port_mdb_add           = mv88e6xxx_port_mdb_add,
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
 	.port_mirror_add	= mv88e6xxx_port_mirror_add,
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index acf9507b1af3..d3e0693ae2df 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -65,19 +65,12 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 	return ocelot_fdb_del(ocelot, port, addr, vid);
 }
 
-/* This callback needs to be present */
-static int felix_mdb_prepare(struct dsa_switch *ds, int port,
-			     const struct switchdev_obj_port_mdb *mdb)
-{
-	return 0;
-}
-
-static void felix_mdb_add(struct dsa_switch *ds, int port,
-			  const struct switchdev_obj_port_mdb *mdb)
+static int felix_mdb_add(struct dsa_switch *ds, int port,
+			 const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_mdb_add(ocelot, port, mdb);
+	return ocelot_port_mdb_add(ocelot, port, mdb);
 }
 
 static int felix_mdb_del(struct dsa_switch *ds, int port,
@@ -797,7 +790,6 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_dump		= felix_fdb_dump,
 	.port_fdb_add		= felix_fdb_add,
 	.port_fdb_del		= felix_fdb_del,
-	.port_mdb_prepare	= felix_mdb_prepare,
 	.port_mdb_add		= felix_mdb_add,
 	.port_mdb_del		= felix_mdb_del,
 	.port_bridge_join	= felix_bridge_join,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index dc82c71d1dbf..3dfcb750e169 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1524,17 +1524,10 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-/* This callback needs to be present */
-static int sja1105_mdb_prepare(struct dsa_switch *ds, int port,
-			       const struct switchdev_obj_port_mdb *mdb)
-{
-	return 0;
-}
-
-static void sja1105_mdb_add(struct dsa_switch *ds, int port,
-			    const struct switchdev_obj_port_mdb *mdb)
+static int sja1105_mdb_add(struct dsa_switch *ds, int port,
+			   const struct switchdev_obj_port_mdb *mdb)
 {
-	sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
@@ -3297,7 +3290,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_vlan_filtering	= sja1105_vlan_filtering,
 	.port_vlan_add		= sja1105_vlan_add,
 	.port_vlan_del		= sja1105_vlan_del,
-	.port_mdb_prepare	= sja1105_mdb_prepare,
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_hwtstamp_get	= sja1105_hwtstamp_get,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 7727b56a4eee..2d715b0502e3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -580,10 +580,8 @@ struct dsa_switch_ops {
 	/*
 	 * Multicast database
 	 */
-	int (*port_mdb_prepare)(struct dsa_switch *ds, int port,
+	int	(*port_mdb_add)(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_mdb *mdb);
-	void (*port_mdb_add)(struct dsa_switch *ds, int port,
-			     const struct switchdev_obj_port_mdb *mdb);
 	int	(*port_mdb_del)(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_mdb *mdb);
 	/*
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 90a879322b21..f8362860cdaa 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -51,7 +51,6 @@ struct dsa_notifier_fdb_info {
 /* DSA_NOTIFIER_MDB_* */
 struct dsa_notifier_mdb_info {
 	const struct switchdev_obj_port_mdb *mdb;
-	struct switchdev_trans *trans;
 	int sw_index;
 	int port;
 };
diff --git a/net/dsa/port.c b/net/dsa/port.c
index b39a5eebbe27..c89e3c0c65ed 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -417,17 +417,7 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		.port = dp->index,
 		.mdb = mdb,
 	};
-	struct switchdev_trans trans;
-	int err;
 
-	info.trans = &trans;
-
-	trans.ph_prepare = true;
-	err = dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
-	if (err)
-		return err;
-
-	trans.ph_prepare = false;
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
 }
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 39848eac1da8..65124bc3ddfb 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -178,35 +178,13 @@ static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
 	return false;
 }
 
-static int dsa_switch_mdb_prepare(struct dsa_switch *ds,
-				  struct dsa_notifier_mdb_info *info)
-{
-	int port, err;
-
-	if (!ds->ops->port_mdb_prepare || !ds->ops->port_mdb_add)
-		return -EOPNOTSUPP;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_mdb_match(ds, port, info)) {
-			err = ds->ops->port_mdb_prepare(ds, port, info->mdb);
-			if (err)
-				return err;
-		}
-	}
-
-	return 0;
-}
-
 static int dsa_switch_mdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
 	int port;
 
-	if (switchdev_trans_ph_prepare(info->trans))
-		return dsa_switch_mdb_prepare(ds, info);
-
 	if (!ds->ops->port_mdb_add)
-		return 0;
+		return -EOPNOTSUPP;
 
 	for (port = 0; port < ds->num_ports; port++)
 		if (dsa_switch_mdb_match(ds, port, info))
-- 
2.25.1

