Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52A02D2A5A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgLHMJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:09:56 -0500
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:11267
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727550AbgLHMJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:09:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmXSg79QeXyxGQl6s1wvLx8nYmEB6ALgoG1JMlGIgKRGeFxOypHpJ0xvCDZoHN85SKtesxupAgxGy1CbC/IWSitCFhp7Wdr3reC7x9VY7GFgM9dRyw/V35hoXnV2BJpSsaDmT+i6s+Sai1Qxu9I0Hnrq5wuUf6o0SOyFDKG32Rev48FmKM1cLAoDxv8HnOLx5t5vDIy9YZj50huuFsnEvvDgMpakN3Nu/S5JhIzIEHUYrk8+IA/7IYnGoxfim2NZqK16ELZwi7fYWktQg6Loq9i45F1OGU8oYsQzLAAtWKFMAn1LDL5aUDAddOyQGjbEVo7RAYgNX0lf4LWTNHFepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DaZUhNkgZuXL1dKYDb/d58bbSIhY6QJ5vhZlaxJ1vk=;
 b=eM0n4MMc1bk45iGZhj7i2gFe/IdFtTmwFNvdNTO3eA2TmJx0qgawAKd2TICO6HAdmd/9ZYIkDMfRR0WHZxqZjw8/tX0xxH8F15ujlxtG2LTTjh1gTka81oOpOJrRJMieopMaws3sDnu0zcp8YFL4UJZ4K/dtq9agIE9WdKBLJThq0lD8ydhxa1OiwLWXcvYQwD23eYfyF/TK6smDKFcv8Dz7tkiqly97/6PlsspMy0S4vgzZwtF/ZWFbJ36E1rWwIU8Ec7OgtSsx5qtvmNQk3PozEFblHpXn3VSfYBkiFf7R0iXOLap3Bu6/t/GFDBKhxtuLA5/QZGnBaOW/fm6qVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DaZUhNkgZuXL1dKYDb/d58bbSIhY6QJ5vhZlaxJ1vk=;
 b=EkEahh2Ydd33DPrTK3bj4TL8RczXsHd5lX355ryOthrGFJDpu0GJuk0VZAK0AGMmapbm5g239BI+1y27uqcfkrubUd3IY65Gmaw4YTUFaACi/h53CYNkTaX3aVKkFw839WIYYberdb6+Nb05kEJ+TvGxCTFBA2c+yb1YiOOuyI8=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 03/16] net: mscc: ocelot: rename ocelot_netdevice_port_event to ocelot_netdevice_changeupper
Date:   Tue,  8 Dec 2020 14:07:49 +0200
Message-Id: <20201208120802.1268708-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5adbc3b-b82e-42db-916b-08d89b71f627
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB56938C69AB3354E0A17CC227E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3x1TAME4Pm0hRucA3Cu46yNP0lRcnaamGUWVAPVphhHVwIwRrB813unOQAtOfc71BCuJk5/877v4EsNajVf6B88Sg2jhXpu466V7ayCp8oLqCIQV+0lTOJuWNmfRR4Fodsqj0aMjrBYHTUJF5DY0WPY5erYkgzcepOkcZeKGjDuLiaY/gO9HnO2mZnSF/QqyIwn3fuZQ1+u7D7Cbhz7ytgLaDLQeCuTnZJCbTyDxZfOaG81eAy84Q7oIwQzpgrwsiv8A3U1bzWvxA+S7LCKR4PEg05S//VYIsx1qaIa5pHpoKLCFhrtIdGKkztgRZabr/jule6o47hEuh8P5Dgd7UDc1i0GqDTLINaftBa+kPDFprJO1asFJ1cvh8kc/Y9a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?47loPXEIMa553/HEZW8f0s24u0T31VbS13OVquN4RarJ0fx69Vbksc0pxY9E?=
 =?us-ascii?Q?CSEMf1u/9u5MBmmWP1YbgZfx9sl2l/C9s5Ubza9upS5TVmJS9nb7f/NhR2T1?=
 =?us-ascii?Q?ICflcd3nG8RCp8cAJblEitnxwmdIrSPTwRoyFZ6ORanGHDqXa1DDrmXFuj0Z?=
 =?us-ascii?Q?xV+p3FghlYVXbiY7vkM+xIPOJYyUwTgLl51+krK0ZLFnBqop8M3gVQi3xpWU?=
 =?us-ascii?Q?Aj6FrVROovNSE+MQrvnvGL8mnDOPR17VzKQu9XeA8WejCP1Rw6zzvJ86VNFT?=
 =?us-ascii?Q?uxM27mFzhClBjKebfGmnuzl7UHzDlp2hvnTjTYy74e6co4g8I/kdDcAMMLR3?=
 =?us-ascii?Q?brQeufA+0wVesiNCydHEx+t+63tDkHdC338NMlDtuAghJkkEABG2kuHamoFx?=
 =?us-ascii?Q?0Ztz3u/kl1zPpvxKM1vTCVomQhzxAAL0OykuwRjGmGdBdKwqp9QnqP82vuq9?=
 =?us-ascii?Q?Z3niXhjcE0Upp/72IURBUYmkAUezSJJtQIwCwHqO9FvScLlYz24QY7khLjYH?=
 =?us-ascii?Q?eAMsXGN3ZEd+dJdL2p6iSdXCJNLdaD4s/JG/jc3Nc3/NoN/7bAL+Y9Hncouc?=
 =?us-ascii?Q?IzQMZ5CXn9ufRqE4STgAcPtONkK2joEKejsGOdYwK+HwAYX5uw8Pq+/fCXOf?=
 =?us-ascii?Q?GZgdaaTReWGjCwEtYWZsTWMM5TPvvUtWBjKZNy/o6IXLiKbf0ThpusTe/cEC?=
 =?us-ascii?Q?4qHIALdwxjBy9AMO13bwSFbD+P73dPbDIgSG4ag3y1oajBUV/ZMt8GkeY3IB?=
 =?us-ascii?Q?yTz+ZVQv7Z7qBgBKHXmJQ49Z4IUydrSnqJZiThdwQD06NJTQNpAyEZsBUqU6?=
 =?us-ascii?Q?Tjt+gbon72eHkSbmolScg5eFBDkrUaanjJIbcnA8kGIAta8j5ZPRa6Nb1dTv?=
 =?us-ascii?Q?6vJhJwfqlFYyo6V/FXLZn49ebA0bjRCEQtvzMmn3AmbeZM3Z7rQgLxQDfzjr?=
 =?us-ascii?Q?I3Tt41hg330wavKawjuw7aNInW7aJEKLVnd2tDCqO8OY7coIJKR+AkrJnA+/?=
 =?us-ascii?Q?nLkB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5adbc3b-b82e-42db-916b-08d89b71f627
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:23.8881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOJMrWyUl5I0wKdwB//k7Jbh95ObbZr6D5ZVliB3+j0WmNUF34SnLBQTTJeHMns+/iFtNVCb8jpJhUY9e2JZGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_netdevice_port_event treats a single event, NETDEV_CHANGEUPPER.
So we can remove the check for the type of event, and rename the
function to be more suggestive, since there already is a function with a
very similar name of ocelot_netdevice_event.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 59 ++++++++++++--------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 6fb2a813e694..50765a3b1c44 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1003,9 +1003,8 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_netdevice_port_event(struct net_device *dev,
-				       unsigned long event,
-				       struct netdev_notifier_changeupper_info *info)
+static int ocelot_netdevice_changeupper(struct net_device *dev,
+					struct netdev_notifier_changeupper_info *info)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -1013,28 +1012,22 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 	int port = priv->chip_port;
 	int err = 0;
 
-	switch (event) {
-	case NETDEV_CHANGEUPPER:
-		if (netif_is_bridge_master(info->upper_dev)) {
-			if (info->linking) {
-				err = ocelot_port_bridge_join(ocelot, port,
-							      info->upper_dev);
-			} else {
-				err = ocelot_port_bridge_leave(ocelot, port,
-							       info->upper_dev);
-			}
-		}
-		if (netif_is_lag_master(info->upper_dev)) {
-			if (info->linking)
-				err = ocelot_port_lag_join(ocelot, port,
-							   info->upper_dev);
-			else
-				ocelot_port_lag_leave(ocelot, port,
+	if (netif_is_bridge_master(info->upper_dev)) {
+		if (info->linking) {
+			err = ocelot_port_bridge_join(ocelot, port,
 						      info->upper_dev);
+		} else {
+			err = ocelot_port_bridge_leave(ocelot, port,
+						       info->upper_dev);
 		}
-		break;
-	default:
-		break;
+	}
+	if (netif_is_lag_master(info->upper_dev)) {
+		if (info->linking)
+			err = ocelot_port_lag_join(ocelot, port,
+						   info->upper_dev);
+		else
+			ocelot_port_lag_leave(ocelot, port,
+					      info->upper_dev);
 	}
 
 	return err;
@@ -1063,17 +1056,19 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		}
 	}
 
-	if (netif_is_lag_master(dev)) {
-		struct net_device *slave;
-		struct list_head *iter;
+	if (event == NETDEV_CHANGEUPPER) {
+		if (netif_is_lag_master(dev)) {
+			struct net_device *slave;
+			struct list_head *iter;
 
-		netdev_for_each_lower_dev(dev, slave, iter) {
-			ret = ocelot_netdevice_port_event(slave, event, info);
-			if (ret)
-				goto notify;
+			netdev_for_each_lower_dev(dev, slave, iter) {
+				ret = ocelot_netdevice_changeupper(slave, event, info);
+				if (ret)
+					goto notify;
+			}
+		} else {
+			ret = ocelot_netdevice_changeupper(dev, event, info);
 		}
-	} else {
-		ret = ocelot_netdevice_port_event(dev, event, info);
 	}
 
 notify:
-- 
2.25.1

