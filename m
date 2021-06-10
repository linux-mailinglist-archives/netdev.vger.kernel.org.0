Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C633A2F9F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhFJPp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:45:58 -0400
Received: from mail-eopbgr80109.outbound.protection.outlook.com ([40.107.8.109]:46158
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230280AbhFJPpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 11:45:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObmazVUDSL660NI2lWjhfd6a8Tn/ccWS73M2lMzV9WZgljMkDtyBS7Ygk7NSfDzCIjqZRBrk/L+ZVe0EbRBvA8+x4Ty1eVvoph6PgAl9yg5zka3SQSenCiOLe30+NULI+DdLXmS6Ha4LmLLtVKLN9kfyJ0OxMvJR3i6VSls1SJqkvKEjb6C3BjgjccvzBuJmizzFyvMBNScFj5Z/OhLkVe/oQIAf5UT0h8mpULOevzTh8W7j+XfZ1pRaVleg6HFGaMj9BPpOa6pcigc4SawXbaoLq5nF5p9xVSAbJ6Bzv6wjuxF8s0k5lUdMXZ/XUw26zCBMYPfiXfgZ4OaZUP1zLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjHq5+WEInyFKYhs1F3lh0jyNd9SdNqb262TLuIj3Eg=;
 b=kRC5LLw/FbK87z+WxlnRGQiydP5hS+Z+mVhwvMBVj1xGd34NjCynzp4/adXpmzINcwAREJUB8zh4Es3lWiijW88Rhf+7XiKPCagio+1EjniX7y5KNheH0OGWVXM+HDtYCmyopSFXlr7dowXoOogiVN8e0POZB66kIdvV+1gTkbcXVXI3W+Gt2GHlGLm7JSxTkZho49YiM63s9Mo6yuMDaeXGZ5aunL08Q6y8o06s8x04WqMCyUhh+I8D5XXE6rW8vJ2+ooH8ngLunE/mkt7eIq1nSYzAP7Rps1sPdacVpWhjsaKC/aYNNgpaPgGC4GluzFqoH89mkImh+jMRnhAMfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjHq5+WEInyFKYhs1F3lh0jyNd9SdNqb262TLuIj3Eg=;
 b=NmIG+1h0yA7i+1aSO6cauahy10C3UZKOytmiIv+CsxzUtGfc0JeZzExIdwFz1pQTVR1nlBIJrkY3+Q/0ZH0FXaZZVwJt/66JUX89RG4uRCsijJhPT61oiO0CpSuimKM4ThLlfiNR835AA1vNjMPxYE1DvuRyZMTfY5BliTcvAv0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Thu, 10 Jun 2021 15:43:50 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.023; Thu, 10 Jun 2021
 15:43:50 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH v2 2/3] net: marvell: prestera: do not propagate netdev events to prestera_switchdev.c
Date:   Thu, 10 Jun 2021 18:43:10 +0300
Message-Id: <20210610154311.23818-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210610154311.23818-1-vadym.kochan@plvision.eu>
References: <20210610154311.23818-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM3PR07CA0082.eurprd07.prod.outlook.com
 (2603:10a6:207:6::16) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM3PR07CA0082.eurprd07.prod.outlook.com (2603:10a6:207:6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 15:43:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eff90337-2268-4a89-47cb-08d92c268ac8
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB02680C22AD6AA8CB8C44778495359@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmAr66FavMPB4fZjH6XAZT9X95bzCR/RikeDizl3lskfjaPUaLWp3gdDrlFXB614jUe0oQn2QeWWWs8lJ7+dDeSXwCRh2WhdeFUVQyl7LgwOXrGoNph37VNWDiArpl9RdYs2N6C107kOe31QxW2VQhH2aAbi98wE8SmkuNux0m57qTNRggPKIpbfY1xEbJId7oXOHnlvLrGAZvabOflvo2hfSAOdTo9wksADkmVHvAyWS1vBs3iqy4TIWCXasq5oukdU8AeqTc7NDXfhbu9gLc1HUuZc0lwl75FTEOb6vev6h74QafFdg8uI4ClLZxqTjLkLjUBQPQzjxWAs5Kr4AiR23IyQ+Aye+7/0TkCmMcTdmS1j4YX/bhQcW0fGgNlHNDh2x78J2dGuWqW6Z3TiccsSXDzj2DQTLDvopBahjEIib8jOj80tBxn55ZkOGgusMwZ6vDwFtlI84BSd4c+kJCYeWASwAgBT9Th1S737VnWxYS1Vy9zUIFKG9Jb8eJe+0elO44yc+xDRN3PA/Qpq1ClAagXIH3spc8u8JFD298YFLiX9KNLw6E9QhoARdEnNKuwZyyNHovvVFc2Rirm58nl2BELBiB8v/vwZC7SLRRRVkfLbbZC9vAIaq7fxzzcaCiAWqdYTfzHOs75Sasr00Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(376002)(39830400003)(346002)(136003)(366004)(66476007)(66556008)(8936002)(66946007)(8676002)(6486002)(6512007)(478600001)(2906002)(83380400001)(1076003)(6666004)(186003)(956004)(5660300002)(2616005)(6506007)(38350700002)(38100700002)(52116002)(36756003)(44832011)(110136005)(316002)(26005)(16526019)(54906003)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?33v1UuR4bBVhylI+j56N47sJd1vB4JcQWH60W6FWK4LmAKd6VoXfiKb7auzk?=
 =?us-ascii?Q?4z+t7XhOD/UOsrHMEdqw+okXWG5acD3MHLNJzefdDMOBB2wxLoR0or+c3YgP?=
 =?us-ascii?Q?xLCNp1QkiQ+MGqFXqSlT2s/U4tYhJm0Lq30Uzrhjfaurf6Uc1oL9tyV/yZdO?=
 =?us-ascii?Q?3G4sHNsMh+/MPdgE2KRaLMTUMxe5H73ZrYF1ko8V6kCH1DnzHDwWx/AB84/k?=
 =?us-ascii?Q?FQ4h1QhkfPTip3WQbKKdNWF3EeJkNm4mHN0VXS0F5pqFPvLIRChYAt/BXad1?=
 =?us-ascii?Q?qHcR4PiezKPcusALlxx06Bzoo+BFIhrUUF5EUiO6xJrxifMTHxaYpWIP2vg5?=
 =?us-ascii?Q?jWWHFonyQ7mzChllJOQ/gEpWQ2DSO/NTLpkxk6d1vs4Wj9w1Mv+Y1Phh+mdm?=
 =?us-ascii?Q?TafV0zA5x1yOQdDocKGYMKma+1w503BQJksvs568Z+rvziNCvno2qN/O8GCO?=
 =?us-ascii?Q?aF77BllTdkKB7lx0N1720kzzx9NgfjRjB+eDpXTmlQpNVnr5qdCQqyCu/3+8?=
 =?us-ascii?Q?gceVsRRmVb4ODgvvUeao6hW8DES4iO6iZkThTZinBVnvfMBB0IPe/GhvxdNz?=
 =?us-ascii?Q?R23LQ/QpBgG46dnSTdhx9R7lbiwEu8yjRT1r2pyVGRb5e8ar83ou7W+9R9KR?=
 =?us-ascii?Q?JsuT3WKC4Ln06RsNIrg8CP+kFCgTPk93mHgxeVQ+ddLccHZED/PIwylUG4mh?=
 =?us-ascii?Q?/X9vJqVd4qEDEpeXHgXxxlLKacw38SJOQ+MZvh+tiaIgk71Phrdscdxn+UWV?=
 =?us-ascii?Q?pqwFHTrIQBa9G+ZGwImK5pTEB9IMOfc3Fzb+aGEgxlovotiqkU0zpdZO+st5?=
 =?us-ascii?Q?YyqYOFueU/c0t06HVRfq+pBJgFFQgYWwCobb22Lb5A4Wh0g01HjpXRK4oksJ?=
 =?us-ascii?Q?dWAksXSCC1ljMf5As40I8Y76Cd/690nf2g5z2QxMKVBTP4X4r0GNSPcRrKH8?=
 =?us-ascii?Q?fOydV6MNHGTAEVWN5DniJNqyR3FHsPiKxWmVEWbvhPsBBP/BLxRMyf6JAwT7?=
 =?us-ascii?Q?X5v0y0/Toyarde6reiPzqi+0cuzbtNonQqcdCk/aGT3hJtjOA+pRPIi4mbdO?=
 =?us-ascii?Q?tZgAWhVoQpXK9+EgPMUOSw54NIoyDhpBg2RITgPEBepqioSKNPrno3wI615R?=
 =?us-ascii?Q?0nXBdl1uNq/hdzjlxKEt1nFknKP2P38l6e3VwGSnrWbiIquAqFCJpBOBG/Qk?=
 =?us-ascii?Q?8Nbu+KkZaqNv+l/UBPDpo1eS+thron/GyTwhIyAs1qHJToPxRP8wJX60CeQd?=
 =?us-ascii?Q?Ij7t5wOaKSM7LNAHaW8q70xtfNVPzyfp8pwxF1ExiIz72i0feU/b1DHnKsEf?=
 =?us-ascii?Q?lOcnsAIpasgGlEF4LxRFpKUH?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: eff90337-2268-4a89-47cb-08d92c268ac8
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 15:43:49.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mfqJIQnqeMethlrMvt2W+fm64wrbj4rvXJijnti6qIYGIqItzeIHhBLWwmC2VEKwn5m79Ivj/Kt6UHerQ0lFcLO4l6O8/Ps0mtfuc8F941c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Replace prestera_bridge_port_event(...) by
prestera_bridge_port_join(...) and prestera_bridge_port_leave().

It simplifies the code by reading netdev event specific handling only
once in prestera_main.c

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
CC: Vladimir Oltean <olteanv@gmail.com>
---
 .../ethernet/marvell/prestera/prestera_main.c |  9 ++++-
 .../marvell/prestera/prestera_switchdev.c     | 40 ++++---------------
 .../marvell/prestera/prestera_switchdev.h     |  7 +++-
 3 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 767a06862662..bee477f44e06 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -509,6 +509,7 @@ static int prestera_netdev_port_event(struct net_device *dev,
 				      unsigned long event, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info = ptr;
+	struct prestera_port *port = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
 	struct net_device *upper;
 
@@ -532,8 +533,12 @@ static int prestera_netdev_port_event(struct net_device *dev,
 		break;
 
 	case NETDEV_CHANGEUPPER:
-		if (netif_is_bridge_master(upper))
-			return prestera_bridge_port_event(dev, event, ptr);
+		if (netif_is_bridge_master(upper)) {
+			if (info->linking)
+				return prestera_bridge_port_join(upper, port);
+			else
+				prestera_bridge_port_leave(upper, port);
+		}
 		break;
 	}
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 8e29cbb3d10e..0afbd485a3a2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -422,17 +422,17 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	return err;
 }
 
-static int prestera_port_bridge_join(struct prestera_port *port,
-				     struct net_device *upper)
+int prestera_bridge_port_join(struct net_device *br_dev,
+			      struct prestera_port *port)
 {
 	struct prestera_switchdev *swdev = port->sw->swdev;
 	struct prestera_bridge_port *br_port;
 	struct prestera_bridge *bridge;
 	int err;
 
-	bridge = prestera_bridge_by_dev(swdev, upper);
+	bridge = prestera_bridge_by_dev(swdev, br_dev);
 	if (!bridge) {
-		bridge = prestera_bridge_create(swdev, upper);
+		bridge = prestera_bridge_create(swdev, br_dev);
 		if (IS_ERR(bridge))
 			return PTR_ERR(bridge);
 	}
@@ -505,14 +505,14 @@ static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 	return prestera_hw_vlan_port_stp_set(port, vid, hw_state);
 }
 
-static void prestera_port_bridge_leave(struct prestera_port *port,
-				       struct net_device *upper)
+void prestera_bridge_port_leave(struct net_device *br_dev,
+				struct prestera_port *port)
 {
 	struct prestera_switchdev *swdev = port->sw->swdev;
 	struct prestera_bridge_port *br_port;
 	struct prestera_bridge *bridge;
 
-	bridge = prestera_bridge_by_dev(swdev, upper);
+	bridge = prestera_bridge_by_dev(swdev, br_dev);
 	if (!bridge)
 		return;
 
@@ -533,32 +533,6 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
 	prestera_bridge_port_put(br_port);
 }
 
-int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
-			       void *ptr)
-{
-	struct netdev_notifier_changeupper_info *info = ptr;
-	struct prestera_port *port;
-	struct net_device *upper;
-	int err;
-
-	port = netdev_priv(dev);
-	upper = info->upper_dev;
-
-	switch (event) {
-	case NETDEV_CHANGEUPPER:
-		if (info->linking) {
-			err = prestera_port_bridge_join(port, upper);
-			if (err)
-				return err;
-		} else {
-			prestera_port_bridge_leave(port, upper);
-		}
-		break;
-	}
-
-	return 0;
-}
-
 static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct net_device *dev,
 					   struct switchdev_brport_flags flags)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
index 606e21d2355b..a91bc35d235f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
@@ -7,7 +7,10 @@
 int prestera_switchdev_init(struct prestera_switch *sw);
 void prestera_switchdev_fini(struct prestera_switch *sw);
 
-int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
-			       void *ptr);
+int prestera_bridge_port_join(struct net_device *br_dev,
+			      struct prestera_port *port);
+
+void prestera_bridge_port_leave(struct net_device *br_dev,
+				struct prestera_port *port);
 
 #endif /* _PRESTERA_SWITCHDEV_H_ */
-- 
2.17.1

