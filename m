Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3700A4B7747
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbiBORDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:03:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242093AbiBORCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:49 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10077.outbound.protection.outlook.com [40.107.1.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B0D119F7D
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erH5vRrvmAr1Mkvr9BE01FQlJ+lmY8NrDwf5+flQcJnXC9kOO49IhMW6bh1Ex5bJaeT9IS2zP1YuqJvtUnNYCPWes6VVuu0L1LRaaZfGeJEyhtI3YdaqYyQG9VYSIbdTbpYoX8+RXfoy5zuaCEwYSWeV0/QkXLc04o026db9jAwVEGkXfsXWVhHJxwhp9sQdQT+lKmSwqkXdO+/btmI5oIXjC0XguyOE+/LlkEx0QPr/+fF3rea3AhkVNhl09WhmThEnkQetWE7kmkNcX4ST/JrrPKDBqEV+lkiL88DXE+lOlmkU7x19lJYThRbgqU7A63wHo7K7dGlqtI525ps/jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPo8sxnHLu1/e/643gWg04NBEWT0VYM8ILWVP/dRzyQ=;
 b=kiqUmG1NV+UQgoB+0QDTKd3F7JCI/mLLvvMnaoz6msqH0pk3rGYGDdxx+RH6yo7emjrilmUvwUrCs0U7o7Cz6eI1UsG5n9BApgVAEzq78woVRqUNRoYl3tXZF5eYF8Y/hZgI7A+XwquPB2O4HTq0C38Qg5GeSggwwsjfzh3E9Kt3jzugF7TO+x04wm7W5VoTXJO7q//dYjKdgVYOntCyEhPsLAvVeHlsaMpYr+EqWzi0hTOJ2xEn1iUWrCPWYopw7a+1F9RF8HxWvy9pD6UqQZYHTWv9H679gcO9jJAJ0OhCnYj/5X6ax+vvEduwGKPOB1TwVBoPnOtkiucGPlBpmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPo8sxnHLu1/e/643gWg04NBEWT0VYM8ILWVP/dRzyQ=;
 b=EdLCpP7bUl/SgvPFIFvU8Ek0vtpwsJWEoLIiatwZlGtV/joyohP+P6ZkWwibg0aLXsDZVvF6bZwyQkxBYl1qgb7331d5M2eost3oltQT9NZCogZ2k0xcOUSdZNnwnjdevJsv1Ut9l7YO04iYlvguZ8jkxVVwAbw4Ow3p4oPLYAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 09/11] net: switchdev: introduce switchdev_handle_port_obj_{add,del} for foreign interfaces
Date:   Tue, 15 Feb 2022 19:02:16 +0200
Message-Id: <20220215170218.2032432-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 696d251f-ff02-4dbb-498e-08d9f0a4f516
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342BF4B40FBAB073CE3B456E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dSsjQULxXGYasYU67hVGUxVv7Av2cZMgiY136Qfo33i40bS+lFl8zOmg7tXCSPYlXHsQNaQyIbE/LJYWxZBpnV0admzDBN+WUyayYJk4S/0euf5e+IrYugtlouTldR+8AEJ9750YjahrMzMJD6h7XKmQhBurSnlqT1bH/D+7cQrT7lH1MVBFehZ19ANPddNl1zy8eN1jFx0D+Isuh+nS5UK2hk8bYehDZfQ/8JhxrX1m3AYb9GZ2IMF9DXnl/oSsv7YsfQ1w4GNJQeqSAxg4oyb1HawMlB1tFuszvnorahEVRGbeT3JOrMLi9FxPdz2I2gcBDMSpDQF+iOO/3qjXZZ9NMRZzgV3wZNJSToVnx2fLMO05PmzYT1oMTeuktdw0Dbr78c5R58WWL/BiQDBBuKOgRxenZSIGalen8GHn27GoNXBrxkWTmKQTLniiDdlQtTu93O6p+98iWVdAAq9p4RPcIK7ECDpfXXQzNObY7EgVfyvYfSRvKLUv8V3dGDRx5r2WfrSBI2m/t8S8nMcY+EyHkpla1+mX4s19jWd+mYwjW4ODiTVpgZpzMVmW9/H9DGN+xZ3r9gT2WnmI9tR9EIfYt25y/aw4m+qbPG9ZJ1Ajuz/oPrlAFXjv7yHyMb1OHScU8mODk9zXXxOAZGXiB9WF/9Cko2BSx8QkFn4kouf3Vdlv/6iT5Ze+A6G3DpYGWMeDJXd8nTdBJAfaR9+jA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(30864003)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z19r9+D/64P931ooO35fMc1AzzIVccj5IotSyOzY1Tgwy//4Tl90BBYVwPVs?=
 =?us-ascii?Q?FTRHj2R0Zd+LFSCyniRKMrLvB0pBFqGDETvjSP/o1AzdyJadJwvH5iKUVG9F?=
 =?us-ascii?Q?/Gqo4Mw351ncN5BRSeiLWydssMcJRV+A9vs2GwdDDOnqyTZkGH+Jq2pmeckQ?=
 =?us-ascii?Q?gLYno7AkB4dvrJE19+wI77CdR1rBYaSfWfZKjHF1pGmxXNBX/Mkv+SiYrWg0?=
 =?us-ascii?Q?bmoudaoVitCI4q58h2clrFd4J4efJ0z4nCn+uSHfroyieWBI2fGJVIqviYoT?=
 =?us-ascii?Q?5LOqBruOQFGkdi2LIQIsal1ZfShCo8FVLgQEubtKPl++Jvm3z5/F0RjHELPr?=
 =?us-ascii?Q?uPweg7/JzQFdmQKD975SgUzrdu/cdyT26u/MW0jAgylfB4WHNGvZBKBL4AkS?=
 =?us-ascii?Q?6vHdqs3Kl3z8OAoNjOs3kDWBu+hWuJI3q2BCnvcdgql3i+4gfQy3hTEtcxia?=
 =?us-ascii?Q?Iwy7p4xvbC6hfOCGMQ2yFbUIY1tv8xnMQJvZaQ0glEtRlvJ4rcdnupSc/4eg?=
 =?us-ascii?Q?7RQL6Frx+7GXGMmRTHBzezQEWLwljjJsp4UX8qKnuFukV6nXFG2J6e22Uyc4?=
 =?us-ascii?Q?uIS/NdhTrQf6mjT7M2p/PBpnkJhtKMbtaUuHb6FlvzAjvubO6rvKuqbIWp6z?=
 =?us-ascii?Q?VeCqTRiEO5OcvALJqGgqsqzdT88QL0QxlaQsCq3Ugn3m2WYpXWpHVxSQ/zA9?=
 =?us-ascii?Q?Epb17iTz0t/WdOOSxB75EfqyjFjP08xxCNaZexaKgQTtQaXS4vqbVuKnFYTO?=
 =?us-ascii?Q?nU6vyFT0xaw2kffCqvpLxt3rTsJKgShyBm+3yzLhHXJtrjle8M7YnYHoIKdo?=
 =?us-ascii?Q?PvcUK/2+xPxBUqOXRISETRBM97Ns/PTaT3OaGPOwAFd0f8HxITZWV0KWKVtF?=
 =?us-ascii?Q?7FmyX1SVNcYhToVyZrARqqWVgB8DKB5nwD4NELpA/7Uoq9uNYqZCrg3uqY6C?=
 =?us-ascii?Q?GoYThMPKabhN9Dtg7e9j7NfRK+OkGh81mbW24Ixu18Ak2D7dyII8fX/545iM?=
 =?us-ascii?Q?RHKBTr8n3gpZnt7i98C+G9Nj5bFoYN2to83n9ISlJow8q19woVNG/nZvXtm8?=
 =?us-ascii?Q?9oHRwjiERE9su25nKbM/V2VviEGLDM/rSU1ItGSiZFFNV4m1+IHmsHTU/lFB?=
 =?us-ascii?Q?MyUMMkf3oLUmC61TTASOwP5DnyPXmhEY4+oERpSWHpr+K3ZfAHzuGuX6uzz0?=
 =?us-ascii?Q?zeFXC5sNhR1umC7Hl52X85xZNoJP3ap3nd3yhPdz3Gvxb0TpvVLCNyHUh/Ik?=
 =?us-ascii?Q?TSpBbur/zLcCQyyRgwomoe5zXQv+CoM0tC81wa+gS8a5AWu88cHHnWC4FI/5?=
 =?us-ascii?Q?UIeEdPYrvsEaq3JjV1Hlt1XLPOQOJv0rJDUldqEVfdoqP+mp+uw8UueZfxRV?=
 =?us-ascii?Q?MyxdCzg/AJFXQdqXdT08uNZ7eQflLO5OObCa/sy/idZxN/ItyEJOHA40UL+Q?=
 =?us-ascii?Q?fImyOOanAjJIsrhjECkoPxOHOHJegDrVkXek9Ja1YP5QSezuSrcNCC5D1KBL?=
 =?us-ascii?Q?X/+rpIvnj7JOT1dKkH5pfQ5bOrQ4/LnQFomU/RFh7ulsnxMp/jwPEwjznyTg?=
 =?us-ascii?Q?jvl0kust3m1uMftUl5mZwrE600ch2nqXb1x7iXlelTuidptN2JOIsKDrTylG?=
 =?us-ascii?Q?UIpaFxM+FFQiRQ+q+jUR4Hw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696d251f-ff02-4dbb-498e-08d9f0a4f516
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:32.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /V3lsC9bl5Y3pICWQZnHKiAwuSqKR2TNsV6/V40aqbNdk8qxcVY18076kJcUOsV7qxDz4bW77O67IrqWbw2Gjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switchdev_handle_port_obj_add() helper is good for replicating a
port object on the lower interfaces of @dev, if that object was emitted
on a bridge, or on a bridge port that is a LAG.

However, drivers that use this helper limit themselves to a box from
which they can no longer intercept port objects notified on neighbor
ports ("foreign interfaces").

One such driver is DSA, where software bridging with foreign interfaces
such as standalone NICs or Wi-Fi APs is an important use case. There, a
VLAN installed on a neighbor bridge port roughly corresponds to a
forwarding VLAN installed on the DSA switch's CPU port.

To support this use case while also making use of the benefits of the
switchdev_handle_* replication helper for port objects, introduce a new
variant of these functions that crawls through the neighbor ports of
@dev, in search of potentially compatible switchdev ports that are
interested in the event.

The strategy is identical to switchdev_handle_fdb_event_to_device():
if @dev wasn't a switchdev interface, then go one step upper, and
recursively call this function on the bridge that this port belongs to.
At the next recursion step, __switchdev_handle_port_obj_add() will
iterate through the bridge's lower interfaces. Among those, some will be
switchdev interfaces, and one will be the original @dev that we came
from. To prevent infinite recursion, we must suppress reentry into the
original @dev, and just call the @add_cb for the switchdev_interfaces.

It looks like this:

                br0
               / | \
              /  |  \
             /   |   \
           swp0 swp1 eth0

1. __switchdev_handle_port_obj_add(eth0)
   -> check_cb(eth0) returns false
   -> eth0 has no lower interfaces
   -> eth0's bridge is br0
   -> switchdev_lower_dev_find(br0, check_cb, foreign_dev_check_cb))
      finds br0

2. __switchdev_handle_port_obj_add(br0)
   -> check_cb(br0) returns false
   -> netdev_for_each_lower_dev
      -> check_cb(swp0) returns true, so we don't skip this interface

3. __switchdev_handle_port_obj_add(swp0)
   -> check_cb(swp0) returns true, so we call add_cb(swp0)

(back to netdev_for_each_lower_dev from 2)
      -> check_cb(swp1) returns true, so we don't skip this interface

4. __switchdev_handle_port_obj_add(swp1)
   -> check_cb(swp1) returns true, so we call add_cb(swp1)

(back to netdev_for_each_lower_dev from 2)
      -> check_cb(eth0) returns false, so we skip this interface to
         avoid infinite recursion

Note: eth0 could have been a LAG, and we don't want to suppress the
recursion through its lowers if those exist, so when check_cb() returns
false, we still call switchdev_lower_dev_find() to estimate whether
there's anything worth a recursion beneath that LAG. Using check_cb()
and foreign_dev_check_cb(), switchdev_lower_dev_find() not only figures
out whether the lowers of the LAG are switchdev, but also whether they
actively offload the LAG or not (whether the LAG is "foreign" to the
switchdev interface or not).

The port_obj_info->orig_dev is preserved across recursive calls, so
switchdev drivers still know on which device was this notification
originally emitted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new

 include/net/switchdev.h   |  39 +++++++++++
 net/switchdev/switchdev.c | 140 +++++++++++++++++++++++++++++++++++---
 2 files changed, 171 insertions(+), 8 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 92cc763991e9..c32e1c8f79ec 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -324,11 +324,26 @@ int switchdev_handle_port_obj_add(struct net_device *dev,
 			int (*add_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack));
+int switchdev_handle_port_obj_add_foreign(struct net_device *dev,
+			struct switchdev_notifier_port_obj_info *port_obj_info,
+			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
+			int (*add_cb)(struct net_device *dev, const void *ctx,
+				      const struct switchdev_obj *obj,
+				      struct netlink_ext_ack *extack));
 int switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*del_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj));
+int switchdev_handle_port_obj_del_foreign(struct net_device *dev,
+			struct switchdev_notifier_port_obj_info *port_obj_info,
+			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
+			int (*del_cb)(struct net_device *dev, const void *ctx,
+				      const struct switchdev_obj *obj));
 
 int switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
@@ -447,6 +462,18 @@ switchdev_handle_port_obj_add(struct net_device *dev,
 	return 0;
 }
 
+static inline int switchdev_handle_port_obj_add_foreign(struct net_device *dev,
+			struct switchdev_notifier_port_obj_info *port_obj_info,
+			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
+			int (*add_cb)(struct net_device *dev, const void *ctx,
+				      const struct switchdev_obj *obj,
+				      struct netlink_ext_ack *extack))
+{
+	return 0;
+}
+
 static inline int
 switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
@@ -457,6 +484,18 @@ switchdev_handle_port_obj_del(struct net_device *dev,
 	return 0;
 }
 
+static inline int
+switchdev_handle_port_obj_del_foreign(struct net_device *dev,
+			struct switchdev_notifier_port_obj_info *port_obj_info,
+			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
+			int (*del_cb)(struct net_device *dev, const void *ctx,
+				      const struct switchdev_obj *obj))
+{
+	return 0;
+}
+
 static inline int
 switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index d53f364870a5..6a00c390547b 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -429,6 +429,27 @@ switchdev_lower_dev_find_rcu(struct net_device *dev,
 	return switchdev_priv.lower_dev;
 }
 
+static struct net_device *
+switchdev_lower_dev_find(struct net_device *dev,
+			 bool (*check_cb)(const struct net_device *dev),
+			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						      const struct net_device *foreign_dev))
+{
+	struct switchdev_nested_priv switchdev_priv = {
+		.check_cb = check_cb,
+		.foreign_dev_check_cb = foreign_dev_check_cb,
+		.dev = dev,
+		.lower_dev = NULL,
+	};
+	struct netdev_nested_priv priv = {
+		.data = &switchdev_priv,
+	};
+
+	netdev_walk_all_lower_dev(dev, switchdev_lower_dev_walk, &priv);
+
+	return switchdev_priv.lower_dev;
+}
+
 static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 		struct net_device *orig_dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
@@ -536,13 +557,15 @@ EXPORT_SYMBOL_GPL(switchdev_handle_fdb_event_to_device);
 static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
 			int (*add_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack))
 {
 	struct switchdev_notifier_info *info = &port_obj_info->info;
+	struct net_device *br, *lower_dev;
 	struct netlink_ext_ack *extack;
-	struct net_device *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
@@ -566,15 +589,42 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 		if (netif_is_bridge_master(lower_dev))
 			continue;
 
+		/* When searching for switchdev interfaces that are neighbors
+		 * of foreign ones, and @dev is a bridge, do not recurse on the
+		 * foreign interface again, it was already visited.
+		 */
+		if (foreign_dev_check_cb && !check_cb(lower_dev) &&
+		    !switchdev_lower_dev_find(lower_dev, check_cb, foreign_dev_check_cb))
+			continue;
+
 		err = __switchdev_handle_port_obj_add(lower_dev, port_obj_info,
-						      check_cb, add_cb);
+						      check_cb, foreign_dev_check_cb,
+						      add_cb);
 		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
 
-	return err;
+	/* Event is neither on a bridge nor a LAG. Check whether it is on an
+	 * interface that is in a bridge with us.
+	 */
+	if (!foreign_dev_check_cb)
+		return err;
+
+	br = netdev_master_upper_dev_get(dev);
+	if (!br || !netif_is_bridge_master(br))
+		return err;
+
+	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+		return err;
+
+	return __switchdev_handle_port_obj_add(br, port_obj_info, check_cb,
+					       foreign_dev_check_cb, add_cb);
 }
 
+/* Pass through a port object addition, if @dev passes @check_cb, or replicate
+ * it towards all lower interfaces of @dev that pass @check_cb, if @dev is a
+ * bridge or a LAG.
+ */
 int switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
@@ -585,21 +635,46 @@ int switchdev_handle_port_obj_add(struct net_device *dev,
 	int err;
 
 	err = __switchdev_handle_port_obj_add(dev, port_obj_info, check_cb,
-					      add_cb);
+					      NULL, add_cb);
 	if (err == -EOPNOTSUPP)
 		err = 0;
 	return err;
 }
 EXPORT_SYMBOL_GPL(switchdev_handle_port_obj_add);
 
+/* Same as switchdev_handle_port_obj_add(), except if object is notified on a
+ * @dev that passes @foreign_dev_check_cb, it is replicated towards all devices
+ * that pass @check_cb and are in the same bridge as @dev.
+ */
+int switchdev_handle_port_obj_add_foreign(struct net_device *dev,
+			struct switchdev_notifier_port_obj_info *port_obj_info,
+			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
+			int (*add_cb)(struct net_device *dev, const void *ctx,
+				      const struct switchdev_obj *obj,
+				      struct netlink_ext_ack *extack))
+{
+	int err;
+
+	err = __switchdev_handle_port_obj_add(dev, port_obj_info, check_cb,
+					      foreign_dev_check_cb, add_cb);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+	return err;
+}
+EXPORT_SYMBOL_GPL(switchdev_handle_port_obj_add_foreign);
+
 static int __switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
 			int (*del_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj))
 {
 	struct switchdev_notifier_info *info = &port_obj_info->info;
-	struct net_device *lower_dev;
+	struct net_device *br, *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
@@ -621,15 +696,42 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
 		if (netif_is_bridge_master(lower_dev))
 			continue;
 
+		/* When searching for switchdev interfaces that are neighbors
+		 * of foreign ones, and @dev is a bridge, do not recurse on the
+		 * foreign interface again, it was already visited.
+		 */
+		if (foreign_dev_check_cb && !check_cb(lower_dev) &&
+		    !switchdev_lower_dev_find(lower_dev, check_cb, foreign_dev_check_cb))
+			continue;
+
 		err = __switchdev_handle_port_obj_del(lower_dev, port_obj_info,
-						      check_cb, del_cb);
+						      check_cb, foreign_dev_check_cb,
+						      del_cb);
 		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
 
-	return err;
+	/* Event is neither on a bridge nor a LAG. Check whether it is on an
+	 * interface that is in a bridge with us.
+	 */
+	if (!foreign_dev_check_cb)
+		return err;
+
+	br = netdev_master_upper_dev_get(dev);
+	if (!br || !netif_is_bridge_master(br))
+		return err;
+
+	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
+		return err;
+
+	return __switchdev_handle_port_obj_del(br, port_obj_info, check_cb,
+					       foreign_dev_check_cb, del_cb);
 }
 
+/* Pass through a port object deletion, if @dev passes @check_cb, or replicate
+ * it towards all lower interfaces of @dev that pass @check_cb, if @dev is a
+ * bridge or a LAG.
+ */
 int switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
@@ -639,13 +741,35 @@ int switchdev_handle_port_obj_del(struct net_device *dev,
 	int err;
 
 	err = __switchdev_handle_port_obj_del(dev, port_obj_info, check_cb,
-					      del_cb);
+					      NULL, del_cb);
 	if (err == -EOPNOTSUPP)
 		err = 0;
 	return err;
 }
 EXPORT_SYMBOL_GPL(switchdev_handle_port_obj_del);
 
+/* Same as switchdev_handle_port_obj_del(), except if object is notified on a
+ * @dev that passes @foreign_dev_check_cb, it is replicated towards all devices
+ * that pass @check_cb and are in the same bridge as @dev.
+ */
+int switchdev_handle_port_obj_del_foreign(struct net_device *dev,
+			struct switchdev_notifier_port_obj_info *port_obj_info,
+			bool (*check_cb)(const struct net_device *dev),
+			bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						     const struct net_device *foreign_dev),
+			int (*del_cb)(struct net_device *dev, const void *ctx,
+				      const struct switchdev_obj *obj))
+{
+	int err;
+
+	err = __switchdev_handle_port_obj_del(dev, port_obj_info, check_cb,
+					      foreign_dev_check_cb, del_cb);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+	return err;
+}
+EXPORT_SYMBOL_GPL(switchdev_handle_port_obj_del_foreign);
+
 static int __switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
-- 
2.25.1

