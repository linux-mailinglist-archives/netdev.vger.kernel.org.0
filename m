Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205D043A681
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhJYW1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:51 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233709AbhJYW1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htVFV4xwHZ3fgOfwT7p8FI+wGqYyb0Vz22MwfXH8d0hq6lf+eBuyeIvV7jK8eNDdtVS54BbJYy9PA2Seeueu0drh+gS+DOi/o9ujGSCXf9u15I5aeYpWFsvFFcNtCnm+HuQEUwjZgA0efyG61BVObPRi70Y+zGnm1tjmhmIAU3dz/9nZsq1Foqg+ChnWOwFVK71DiVyys03c+2Dm6nt2QKXYBSSPjIaWQLWATBK3UhMe73UvyDiUaYMSeB+HuhZdoxrwWP0l0XSisZpqp5Tv0DA3nCS9ETEiEGOvfo5OyByDGzQLtoc57FkAkMgqTkSG71aEJugS856pCh+PQBB+BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5n2icqFmvpXYVgC6+rwEkwvAG7sjqetPIbkMxwwGY0=;
 b=oEwFUpArfAxyAWQ6jPcmnpjh6LFBRMucM8iabcNQ5KzTwuJw6no1+K+Wvw/X/EgkqEvYk+yeR8QWcnJlcQEI+4ArI9OAj6Iyh+ui4m1xRkr02IzFDK+s/AM9yDI7es2WOwLOh7XYVC7c2/G6HGgTfF+rzae/cHgrKFgKFMVIEYG0hf6ScTpc9+3u94rifk1tlnbIpyMVmbhI/9KHae8WCd2zRWU3eGR0BiU7tzPCr/U9yA/XrnCyx3+N9EgAYfHI6BAib2laY+UjTfE275oiezVpfye8UZ9CJWmlADThmbkmEn2R2+L0rKTUWl+v9WHsBg7hCEHKt6aOYZc8NzKKAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5n2icqFmvpXYVgC6+rwEkwvAG7sjqetPIbkMxwwGY0=;
 b=ecjVcqPIneUr7RFv4zXhxkFG2bWN1jToSvntFvHFGj4T1xcZMFfR1LpGqj153hqbS5YnzxPXKQ69gjiEC7iwUG5eve3YsaZfiGfCpqsLauieIy0sNB3kXG7a99v5nGNrUcWkB+dvhfGWFDlB8HqAZjj6iTq934S4p7y3dSWHDhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 15/15] net: dsa: propagate extack to .port_fdb_{add,del}
Date:   Tue, 26 Oct 2021 01:24:15 +0300
Message-Id: <20211025222415.983883-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1821db2-b977-4ed6-381f-08d9980640d5
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2304F51723B74461043FE36BE0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knLYtAH8hXHNlUdYQQvbq2SpIe6PrBNZeqZE4jC+PpH5e3CwwOxnP/+BO62JD1TtoEhguoUoFFenJqpjD42fRNebxmaFNjVngV37DKQ+5k/YoZoVnmp3cw7/grZgDm9AhLxkEmq9uoazQ/FoP0txeWgjv1aYoVqhB1aMdwobnnHPu28U17X363Fv0wIeYCIQfSCEEy+8stpvvwuMZIV9bIY1tGrEivHPBP1qH+Tb+BTcj9hk9RcajDWRIVlVCug6U7mqZTvAhO9fTTXeWdWfp2G7evM1OrnbdF3s0jtAHllQcCeyZQG9iCHQ1qgaoqso4hOoPi+Ia4M9MGUbJ/mPA/LKjlOV9QasV3OmjTypFPG909k4Shg+yzpxsDyONQjifaAY6bL8j2ifPhgirQjBRpWwqG8QKGh84G+f34p+JK1b+OKT1gD1+AOWLjBsvFOQUHKDfLbpfg0kdz24Y5oIOfX0O4g81uWXneWQ0ibE7g7UwDscqPm+TAE58vFe262UuXLXjVwMwvFUYAacG4ZVebh+lapDpr49N85R9UNDfzhcjNHgT7qSTxm/Sqkmmzja8diT1cuVzK7p/73iy8N4NwyhJJgeZVzceha8CVQSYeIXbNC+w/UbcnYzxVYglC1f+QfnqKNb4rFLKqbfpcW6tmh7JtEMhmmvvHFjo9AyZD63A9AOM9qBxEMCkKOVuXpuAUnd879cagAy6YrP/EUBZxJEer/83PhZUY6IrygIAGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(30864003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YdFlaWA6jlHAoN7Quq3DvdTgzUHKcsSeECtjB8inqM/JQbYCseR3pDaJjG6E?=
 =?us-ascii?Q?4N5HYUQhjZuNCMVCbw+8fayy/DvgSxCFisBjdq2Jv1DhNDiMpBAZj1cKGw5w?=
 =?us-ascii?Q?YMHQUuXUDmgsZO+BXilVW9pvkCgEJX5LBmVMfS9YSFXhfMGs7N/OSB5yHi3L?=
 =?us-ascii?Q?7xdkhPKXrfwuO5dUDpvWoPlRBakC6u0mA6a9lT37agNAVeWLyPw4N3f9xZm3?=
 =?us-ascii?Q?YGR3i6z7+T77dQK5ifLWoEcPMZjVMRHmX27ozoMohqOoW1dIAcv4mSblZM0s?=
 =?us-ascii?Q?YLYQBRnHj1ZAfac8AWqwMOPuL/hjUzii1Kxn8hM4Qax6MW5BYpucRI5jGx3w?=
 =?us-ascii?Q?Y+RfxQG7OTGzWcgi4Qze90Fz6iYTsV15U+U8v288Sg3o5OIanoZzzaAUXSV4?=
 =?us-ascii?Q?+hL+Xq+MdoTk7BNzLYhDZb41DBLWmKOOoq1nZLRJi8HxoRSRgHJfYmGZ+4Ih?=
 =?us-ascii?Q?bHwA6wT1QOe3by6O3oDWRIeAkMI4h4u2grUDBBg9hO6tr82SgYD7tT0bE1+T?=
 =?us-ascii?Q?kYSBbuYpqQ8q+qGcLqYXYSZ8a09gA/PetHVJwd5FsuDquG5TdrdzgTLege/P?=
 =?us-ascii?Q?+vRYMiraGr5OyBCOJTTFdJbzur8hs2eTfPip4lOG4toa72BqLUwQFQzkvlaR?=
 =?us-ascii?Q?IWiajGjXARim3woS4iHXkETQeYadwuVUYcN27D/BJHVXXUgvT6hcSDTHM1X3?=
 =?us-ascii?Q?hCU7xdOA71R3ify3T+vDCU9+Cpg3lNT/4OCI8m0c6Z4PBVcZW/dI2UZ5uQ3T?=
 =?us-ascii?Q?pDyHcWd83pu+m5YQHf8HbTiuF28UZcf3nAIDGUhPrBPWoNZwcI9zWYKlqa3a?=
 =?us-ascii?Q?e4L0ZMS4cAq6FsP+ws4KiPkrcAmum7PzYiKzb4i5MlLPv8sZ5tP+ReMom1mK?=
 =?us-ascii?Q?YKoReXOrEqbhgeTKTF4+a8mJu5XyvdmQwEUzwsYdwW32pJrwDSi2FcDqzIl/?=
 =?us-ascii?Q?7A0loGKWlazSMvVWqdwAX8Ze6T3Jao+9pfo4YRANJGUlshjFK+t+W7H12td9?=
 =?us-ascii?Q?6T2qyfrTC/xfnhGYD7hy8jHUtIa00SKCbVl48+CC+W24lF1WKatXxbESMkXD?=
 =?us-ascii?Q?9dRkpp3mcfq+a8Hx43dm9SfOC1LvhsF2V9hc9sSClvqwWmA970As91xO1KN5?=
 =?us-ascii?Q?A0FwXYjlU0x8urtx+zMDg1qAzTOhtBARgbWsK9cJPD40W7d2gMoISirKYOao?=
 =?us-ascii?Q?7Mrf7bSsRa1/FWYtDS3m7Eaue1rF4Uu6IHEDnxrSF7/zW6FZMDC1fNrmLB2F?=
 =?us-ascii?Q?sL0SfVGNmKWEiaKTKHGY73U4K1q0j8W0fXXpghOpDjacUdrJafSDDfxM+yVs?=
 =?us-ascii?Q?gyXdKbCRc0pbrytKoNnstidqFUgPpUxxu+tOCo5OHnVI5mvl0TzYjT/503i6?=
 =?us-ascii?Q?BYVLK3wfrK/nklF2GHPOnfl1BZMGSICy2qdEavpfhngIbuc0G5Gy9S6fiMwL?=
 =?us-ascii?Q?CYOGDRY5mO6hWRO1/8kT5vlKgvqOrazNJ+8iGsLwksDsupexmy1thMsGwXMr?=
 =?us-ascii?Q?j2u0s3LjwntoIwmcEd+ayS25SXPRPCcAHsYrImpE6l83Bw1CqMDJ3xpu+O1m?=
 =?us-ascii?Q?iQSVyEgDAPEYruj5T8dJ/5veb+R57UiPtovBO3ft3tJuDKeqqoQ96foW7ksT?=
 =?us-ascii?Q?eY0FNTzkf8BDxJox8T4KhwQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1821db2-b977-4ed6-381f-08d9980640d5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:47.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEWDvHdbVZxxd0CAPbxnC3/vK3nNTGJ3AxIBBeASbQlrVunhBFU7BJZIyjC1mnJ6F/HSMKiHIlnsTimrWthoGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers will need to veto FDB entries in certain circumstances.
Modify the driver-facing API to expose the netlink extack for extended
error message reporting to drivers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       |  6 ++++--
 drivers/net/dsa/b53/b53_priv.h         |  6 ++++--
 drivers/net/dsa/hirschmann/hellcreek.c |  6 ++++--
 drivers/net/dsa/lan9303-core.c         |  7 ++++---
 drivers/net/dsa/lantiq_gswip.c         |  6 ++++--
 drivers/net/dsa/microchip/ksz9477.c    |  6 ++++--
 drivers/net/dsa/mt7530.c               |  6 ++++--
 drivers/net/dsa/mv88e6xxx/chip.c       |  6 ++++--
 drivers/net/dsa/ocelot/felix.c         |  6 ++++--
 drivers/net/dsa/qca8k.c                |  6 ++++--
 drivers/net/dsa/sja1105/sja1105_main.c | 12 +++++++-----
 include/net/dsa.h                      |  6 ++++--
 net/dsa/dsa_priv.h                     |  9 +++++----
 net/dsa/port.c                         | 13 ++++++++-----
 net/dsa/slave.c                        | 12 ++++++++----
 net/dsa/switch.c                       | 22 ++++++++++++----------
 16 files changed, 84 insertions(+), 51 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index af4761968733..8657afd18791 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1704,7 +1704,8 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 }
 
 int b53_fdb_add(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid)
+		const unsigned char *addr, u16 vid,
+		struct netlink_ext_ack *extack)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
@@ -1724,7 +1725,8 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_fdb_add);
 
 int b53_fdb_del(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid)
+		const unsigned char *addr, u16 vid,
+		struct netlink_ext_ack *extack)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 579da74ada64..8c4741f7a837 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -362,9 +362,11 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid);
+		const unsigned char *addr, u16 vid,
+		struct netlink_ext_ack *extack);
 int b53_fdb_del(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid);
+		const unsigned char *addr, u16 vid,
+		struct netlink_ext_ack *extack);
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data);
 int b53_mdb_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4e0b53d94b52..3e1fcc7e23f1 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -823,7 +823,8 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 }
 
 static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     struct netlink_ext_ack *extack)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
@@ -868,7 +869,8 @@ static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_fdb_del(struct dsa_switch *ds, int port,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     struct netlink_ext_ack *extack)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 89f920289ae2..1255a28a12e4 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1180,7 +1180,8 @@ static void lan9303_port_fast_age(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				struct netlink_ext_ack *extack)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1192,8 +1193,8 @@ static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int lan9303_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
-
+				const unsigned char *addr, u16 vid,
+				struct netlink_ext_ack *extack)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 7056d98d8177..83d125259897 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1381,13 +1381,15 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 }
 
 static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
-			      const unsigned char *addr, u16 vid)
+			      const unsigned char *addr, u16 vid,
+			      struct netlink_ext_ack *extack)
 {
 	return gswip_port_fdb(ds, port, addr, vid, true);
 }
 
 static int gswip_port_fdb_del(struct dsa_switch *ds, int port,
-			      const unsigned char *addr, u16 vid)
+			      const unsigned char *addr, u16 vid,
+			      struct netlink_ext_ack *extack)
 {
 	return gswip_port_fdb(ds, port, addr, vid, false);
 }
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 854e25f43fa7..e4cd36c25d76 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -583,7 +583,8 @@ static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
@@ -640,7 +641,8 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9890672a206d..e6176078f5ad 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1341,7 +1341,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_fdb_add(struct dsa_switch *ds, int port,
-		    const unsigned char *addr, u16 vid)
+		    const unsigned char *addr, u16 vid,
+		    struct netlink_ext_ack *extack)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
@@ -1357,7 +1358,8 @@ mt7530_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_fdb_del(struct dsa_switch *ds, int port,
-		    const unsigned char *addr, u16 vid)
+		    const unsigned char *addr, u16 vid,
+		    struct netlink_ext_ack *extack)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 14c678a9e41b..fbd22d1c479e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2299,7 +2299,8 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
-				  const unsigned char *addr, u16 vid)
+				  const unsigned char *addr, u16 vid,
+				  struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2313,7 +2314,8 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
-				  const unsigned char *addr, u16 vid)
+				  const unsigned char *addr, u16 vid,
+				  struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 83808e7dbdda..0a3d0cbd25e2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -638,7 +638,8 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int felix_fdb_add(struct dsa_switch *ds, int port,
-			 const unsigned char *addr, u16 vid)
+			 const unsigned char *addr, u16 vid,
+			 struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -646,7 +647,8 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
-			 const unsigned char *addr, u16 vid)
+			 const unsigned char *addr, u16 vid,
+			 struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ea7f12778922..26cf4b583c74 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1850,7 +1850,8 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 
 static int
 qca8k_port_fdb_add(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
+		   const unsigned char *addr, u16 vid,
+		   struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
@@ -1860,7 +1861,8 @@ qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_fdb_del(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
+		   const unsigned char *addr, u16 vid,
+		   struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c343effe2e96..40a970874409 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1818,7 +1818,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid,
+			   struct netlink_ext_ack *extack)
 {
 	struct sja1105_private *priv = ds->priv;
 
@@ -1826,7 +1827,8 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid,
+			   struct netlink_ext_ack *extack)
 {
 	struct sja1105_private *priv = ds->priv;
 
@@ -1912,7 +1914,7 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
-		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid);
+		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, NULL);
 		if (rc) {
 			dev_err(ds->dev,
 				"Failed to delete FDB entry %pM vid %lld: %pe\n",
@@ -1925,13 +1927,13 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 static int sja1105_mdb_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_mdb *mdb)
 {
-	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, NULL);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_mdb *mdb)
 {
-	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, NULL);
 }
 
 /* Common function for unicast and broadcast flood configuration.
diff --git a/include/net/dsa.h b/include/net/dsa.h
index badd214f7470..ca333c11c7f4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -782,9 +782,11 @@ struct dsa_switch_ops {
 	 * Forwarding database
 	 */
 	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid);
+				const unsigned char *addr, u16 vid,
+				struct netlink_ext_ack *extack);
 	int	(*port_fdb_del)(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid);
+				const unsigned char *addr, u16 vid,
+				struct netlink_ext_ack *extack);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 5d3f8291ec7f..253a875f54cd 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -64,6 +64,7 @@ struct dsa_notifier_fdb_info {
 	int port;
 	const unsigned char *addr;
 	u16 vid;
+	struct netlink_ext_ack *extack;
 };
 
 /* DSA_NOTIFIER_MDB_* */
@@ -219,13 +220,13 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
+		     u16 vid, struct netlink_ext_ack *extack);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
+		     u16 vid, struct netlink_ext_ack *extack);
 int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid);
+			  u16 vid, struct netlink_ext_ack *extack);
 int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid);
+			  u16 vid, struct netlink_ext_ack *extack);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bf671306b560..444c7539c826 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -737,40 +737,42 @@ int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 }
 
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid)
+		     u16 vid, struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.extack = extack,
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_ADD, &info);
 }
 
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid)
+		     u16 vid, struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
-
+		.extack = extack,
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
 }
 
 int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid)
+			  u16 vid, struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.extack = extack,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -783,13 +785,14 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 }
 
 int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid)
+			  u16 vid, struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.extack = extack,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1329e56e22ca..3e49feb81261 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2417,17 +2417,21 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, fdb_info->addr, fdb_info->vid);
+			err = dsa_port_host_fdb_add(dp, fdb_info->addr,
+						    fdb_info->vid, extack);
 		else
-			err = dsa_port_fdb_add(dp, fdb_info->addr, fdb_info->vid);
+			err = dsa_port_fdb_add(dp, fdb_info->addr,
+					       fdb_info->vid, extack);
 		dsa_fdb_offload_notify(switchdev_work);
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, fdb_info->addr, fdb_info->vid);
+			err = dsa_port_host_fdb_del(dp, fdb_info->addr,
+						    fdb_info->vid, extack);
 		else
-			err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
+			err = dsa_port_fdb_del(dp, fdb_info->addr,
+					       fdb_info->vid, extack);
 		break;
 	}
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index bb155a16d454..9058882a282a 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -291,7 +291,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 }
 
 static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid)
+			       u16 vid, struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -300,7 +300,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid);
+		return ds->ops->port_fdb_add(ds, port, addr, vid, extack);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -316,7 +316,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		goto out;
 	}
 
-	err = ds->ops->port_fdb_add(ds, port, addr, vid);
+	err = ds->ops->port_fdb_add(ds, port, addr, vid, extack);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -334,7 +334,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 }
 
 static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid)
+			       u16 vid, struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -343,7 +343,7 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_del(ds, port, addr, vid);
+		return ds->ops->port_fdb_del(ds, port, addr, vid, extack);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -356,7 +356,7 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	if (!refcount_dec_and_test(&a->refcount))
 		goto out;
 
-	err = ds->ops->port_fdb_del(ds, port, addr, vid);
+	err = ds->ops->port_fdb_del(ds, port, addr, vid, extack);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
@@ -383,7 +383,8 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->sw_index,
 						info->port)) {
-			err = dsa_port_do_fdb_add(dp, info->addr, info->vid);
+			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
+						  info->extack);
 			if (err)
 				break;
 		}
@@ -404,7 +405,8 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->sw_index,
 						info->port)) {
-			err = dsa_port_do_fdb_del(dp, info->addr, info->vid);
+			err = dsa_port_do_fdb_del(dp, info->addr, info->vid,
+						  info->extack);
 			if (err)
 				break;
 		}
@@ -422,7 +424,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_add(dp, info->addr, info->vid);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->extack);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
@@ -434,7 +436,7 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
+	return dsa_port_do_fdb_del(dp, info->addr, info->vid, info->extack);
 }
 
 static int dsa_switch_hsr_join(struct dsa_switch *ds,
-- 
2.25.1

