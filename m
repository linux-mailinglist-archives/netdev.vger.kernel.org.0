Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FF946A204
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbhLFRIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:07 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236755AbhLFRBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+FsudFm5PYgjy1bd7HvgLISaYRC4L0uhlPhxdUb4fPQuZ9w5E7xSq5D0IU8cUqFAp4L+qk/3jfJzeV3Cuh6WncZghj1hnvNYIMib1TNrOqTrWwH2hGgrcU8Iurjy7vkIOHmVavlJiU6OdZMSlofu+bwQgx2UsBe0YsuV3Gmkup8YQhsAZ28domSStt/91XjxCTZXYsf5y8EOUvOKpa9W5nDU/kDcx8ki6FW/ph5cWUgvv3nPYF9ZzfFOtqXin6f+lW9TDjop9ZGyZGqWfzzXbaiahVqHPrvNQ+uV43RFix/49DBOQ2onWQJR6TzTCy7Gyfp5RwPGFtIITUBJJA+rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LidQH2Iud6A6ymu8esqZj9qhsROD401kiNR4ccI1+hs=;
 b=Rl5ggsD04ctrYgDXhHfdnSR3vVv4bpvQ7EdRTK7vbeVql5eXJLNOg7zVVN0I5oQqXIFpzcdkpSw74sLnkuCgUyzytX1V4B7uTb+uoTy1d5NI9vcur41rSR2E1m3uIYLYGU2losqYw4MlBrwiA8ngKrQj63l236KmGcn5jwxeILozJo6eltIBrSK1KVPvwrX1VEeZiLfUWIZx7DWmHlNVbPgJfq+0kaMhA/CkH/QEHSDN4uKCSPgnLykyE81LDaludsGwxhg879RDTg/9RUJuEHqi9KqTnT+o3hrYcHRaaxpnqp1aOdlFTAbGPddQkWkx8rZPXLT8NwaMWpNF9w1POQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LidQH2Iud6A6ymu8esqZj9qhsROD401kiNR4ccI1+hs=;
 b=VqxAz/MXHz9qkE67lsfApSsBgsOieOzySzqrqtCDdUdXy7yg1zF+RYedNZHvExVVVy90O2GhrFxdsaflVoMx965bVjeoIT1vUlU+pYVPeIR4xfyAhog/tnJK1Vxd/XhLQPy8Brza62Q+7RLT6y9UZJPHm/g5rNcTXJPAzhg7zKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:23 +0000
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
Subject: [PATCH v3 net-next 05/12] net: dsa: mv88e6xxx: compute port vlan membership based on dp->bridge_dev comparison
Date:   Mon,  6 Dec 2021 18:57:51 +0200
Message-Id: <20211206165758.1553882-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dbeabf4-0d62-4a73-d8d1-08d9b8d99d59
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB491220B699DB33BF3BA30FD9E06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGbUVUauj1Q0n//lvqxzNYR16nP57wcldCqvwZz0rDWW7L9Pk/Xf3P5d/9q9Ii6h95R90by4utlCl/fuOTLHb2axxvmbjKtRsDUcOclDYE4ZzsDBq7ZPouKs7eOdD6DzQ4GRGhtURhx46FBbuNieabumMlRtCjqGIeLlxhL5NZ3/YHT9lgmOOX43boRAbwGVtUCQfQx8QgGbkctzNVQfpkEkp7YhJbzbfhGF4pdmwYigwH6gPlnIRMBi19GbBSMMiz6kIbqTQ8KydDq5Rrk3qofzeeeUVI1MzbPKSF/2vEIdIhlo5hC4ZX/Rj7qA1g1sZqZaN9tTRECagc63F2YCDTWhU5EC6mMXJj23TXTOneua2gZ55214QDfnrnIxGkHDPM0QxXcgSzIGxylyuzlX8cXjUh8gOy9tS5+wBCsSIM/EZky3NUp3o8GMCMzIphxLmMBoOm2olX7vjDieKxT2N8OAnQsjBAwWpwfq+VI3sAu+08NyKenVe7aCV+Tb/Y8G1wqFTkjFibzdZJkd9UcVQbbpyG4oWKWjz0o5caGxwu26Za5hzDxWcOIFwid9cSAyEIUB5goxJxOYoBDbvHDkVFn4dAUVZOOUc6aP/Nwx3B2XKF5Js+pUH93pxZidDmr/aMTri7i6A4AlqB82Wq6uMld6cEmPEXY/UQxlXpivsmXaVWgvXsmj/8i9EvhETzQK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q2EVsK/PpuWWDoJQE0w9RRZ6NaaJsakJD3xHIWyX9ipy8F32Nx4IE7gsH0zn?=
 =?us-ascii?Q?SbwvWlj61xYO0E29QVsG8kL6tLDMR64yJP5eUxxX37TCQt63G8lnD/QHcuVs?=
 =?us-ascii?Q?WyJscML573XjgRafB0tVkIBCwFQQHLJGd76mtp0DwMeETjoxhzcOzLL66vGR?=
 =?us-ascii?Q?Hwdd7uSgy2aecqJgvrAGyv+IEG/MpA5qTfx8F7Bq7AoqMrQs63AM4vp7WZr0?=
 =?us-ascii?Q?0KJQooKI4OfliFZES+rbmKR6Mr2drID9Kbz8ceXOF5a1APeLWXNuc/r1x/pw?=
 =?us-ascii?Q?kUVipDDvaGaVvn3G5N3ENkDQwkYbWQx1xwvqgXBM3anZUcvvObVgz5Hs/Wee?=
 =?us-ascii?Q?3WqCUpaqGIY8TTjXefRnz0trVdG6QdmyFYgaRKIZlwvJw1e3V9ZTnJ6u2OQI?=
 =?us-ascii?Q?gRofERDHVl9B0Ni9n4b1kGIG+55CYZuw4SogOMUbXeR2yrw7X/0crLMZthmJ?=
 =?us-ascii?Q?aJT1QkUCjVWjpzz5Ku8A6B6dBhi9gF8qnIYQr8UHw7WBcdz1v2eDSkR8ae+N?=
 =?us-ascii?Q?3ewlzI2V4sSEP44psOC8rHzi5n6fRAaA6G9C0RrECoFmJHUtEUi+u7m2/4mT?=
 =?us-ascii?Q?7mJmM4CmbBEpKjjB1y1CY4gvTE1Q8yRs0PNVYKAaojW85I1PYIpP3X+m+Nhr?=
 =?us-ascii?Q?vXyh1IfqGNww49Czu49S+2xhD9XQQrH6V6BOmpIHKjGLxxeXr8ltSCA5vDOi?=
 =?us-ascii?Q?1hq6JYZz2ZZxw32neRoWH0gCnA0iNjW4soWmuD1IQCMihwQKGDqUEgEJXlZT?=
 =?us-ascii?Q?ZhWcLYhtHDF41iyj/b0FbOdQdO+DfL0Sz6lCDNRP7zD9/LZL7WerSFsExqjq?=
 =?us-ascii?Q?T2A9ysBt+Wl72GOqCLboU840Ve0bWxD1LISnxyuc48NtizBq2O3K1VPuXUdv?=
 =?us-ascii?Q?dBv0Dpr/88TM9hH3NOArIKSWEg0movMm6mzfu5B0Fw1RGnvsT7qlS4n1zkka?=
 =?us-ascii?Q?mErm7k1WbdxZSPRfJsLV5wFH5eEQYXoJpB+dLJnQoFPJHLJhYvKH0H9I3SH5?=
 =?us-ascii?Q?/f9LsMwxn/pg3wNHrVC8ZsgxTnkD0OYKb4ysQzYH2Q46zH9Ok8n9vEkHrICH?=
 =?us-ascii?Q?VpnrDB5k4Mt/LhAcDBairy2VOLewKhmDg0oYuKCKokmcyvfJp1NvYz8kirR6?=
 =?us-ascii?Q?0FucLjGdM0vCDmcNJcILwoEYm2L+1nj1ADfSKt1MwrvqWK5jsVJO9ilDG9CI?=
 =?us-ascii?Q?RnNoaV+gGKG3gbEBSmzVbPQGPE1HJ5xd9bqYaCP8nJGzGDKSp3A9CuTcfMtC?=
 =?us-ascii?Q?R4pCYaw4NfamdDGfPQCP4ZyT6oECHspQn8EON7M6Xn1KWKb8J8Vo5rsaTNwA?=
 =?us-ascii?Q?YU4rMqLyneTksvJHBwCfIKYSvDwq121l+RIg+aw2YBtQMM8G8bFxyFzoxQvl?=
 =?us-ascii?Q?8YdWVMmTCRTQ2n5RLu1p/Vz6L8PbcQN3DAvixG5zyQ5rkZKmxtSA7w2eNQOq?=
 =?us-ascii?Q?guCeC1G9YZniXJxMmfnOKXlraumq1dEVgWze6W1NHky0pUT91m4fhG91uSqc?=
 =?us-ascii?Q?bBnCAdONXoEo/KiiVtnpo7Qmz+g4Pjfd1Hpw2FJa5bmZfxqsJMy2X26ovE+4?=
 =?us-ascii?Q?iubtupxERG4w/WhkcPKbL4QVWJ6b4ZVO3yOi+a5EKqJBv+DyIPWSWmtfSG7Y?=
 =?us-ascii?Q?N4Ojb8+6NcKycR5QEXzF+Vg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dbeabf4-0d62-4a73-d8d1-08d9b8d99d59
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:23.8210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQK/bBUAdkNNxE1qfpx16Lx8HFvwNfBVQTzWQgxfdmOtZDZWnSk0t1VRjX2FZkgViMJwFaI2RnF3hPxe7XWwgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this change is to reduce mv88e6xxx_port_vlan() to a form
where dsa_port_bridge_same() can be used, since the dp->bridge_dev
pointer will be hidden in a future change.

To do that, we observe that the "br" pointer is deduced from a
dp->bridge_dev in both cases (of a physical switch port as well as a
virtual bridge). So instead of keeping the "br" pointer, we can just
keep the "dp" pointer from which "br" gets derived.

In the last iteration over switch ports, we must use another iterator
variable, "other_dp"since now we use the "dp" variable to keep an
indirect reference to the bridge. While at it, the old code used to
filter only the ports which were part of the same switch as "ds".
There exists a dedicated DSA port iterator for that:
dsa_switch_for_each_port (which skips the ports in the tree that belong
to non-local switches), so we can just use that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is split out of "net: dsa: hide dp->bridge_dev and
        dp->bridge_num behind helpers"

 drivers/net/dsa/mv88e6xxx/chip.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2c9569e88fac..341b62398d83 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1228,8 +1228,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	struct net_device *br;
-	struct dsa_port *dp;
+	struct dsa_port *dp, *other_dp;
 	bool found = false;
 	u16 pvlan;
 
@@ -1238,11 +1237,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 		list_for_each_entry(dp, &dst->ports, list) {
 			if (dp->ds->index == dev && dp->index == port) {
 				/* dp might be a DSA link or a user port, so it
-				 * might or might not have a bridge_dev
-				 * pointer. Use the "found" variable for both
-				 * cases.
+				 * might or might not have a bridge.
+				 * Use the "found" variable for both cases.
 				 */
-				br = dp->bridge_dev;
 				found = true;
 				break;
 			}
@@ -1256,7 +1253,6 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 			if (dp->bridge_num + dst->last_switch != dev)
 				continue;
 
-			br = dp->bridge_dev;
 			found = true;
 			break;
 		}
@@ -1275,12 +1271,11 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	/* Frames from user ports can egress any local DSA links and CPU ports,
 	 * as well as any local member of their bridge group.
 	 */
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dp->ds == ds &&
-		    (dp->type == DSA_PORT_TYPE_CPU ||
-		     dp->type == DSA_PORT_TYPE_DSA ||
-		     (br && dp->bridge_dev == br)))
-			pvlan |= BIT(dp->index);
+	dsa_switch_for_each_port(other_dp, ds)
+		if (other_dp->type == DSA_PORT_TYPE_CPU ||
+		    other_dp->type == DSA_PORT_TYPE_DSA ||
+		    (dp->bridge_dev && dp->bridge_dev == other_dp->bridge_dev))
+			pvlan |= BIT(other_dp->index);
 
 	return pvlan;
 }
-- 
2.25.1

