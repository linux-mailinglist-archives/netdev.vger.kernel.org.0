Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADB56BED7
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiGHRn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239043AbiGHRnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:43:50 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130135.outbound.protection.outlook.com [40.107.13.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C17E65D72;
        Fri,  8 Jul 2022 10:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMeVHnR3bPpwxr1cNnZYXOSj9gjMQxhMUZzlRR/XYxNHYr/6MicgJmNBZqWUM8d10gscyn2xV5M8cXPpfOHVAK1qNli0jTbWkiU/Db9FGvYgU0FHmzonH3z0L8FDfJnOQeIFkbfyMlH4/s6XAzb3W9T/zPoJfkGLuq6GVPfw8qOjOvVKhQOueDJSo9wg/EcgaV+HpyKQxzjxHqg36H0H4QnBmpkUXJcLFl701O8ImTHiWyjPqsb7aVoIvwGWVKDkCzB71aRW/XvGAs7TFS9AFCnZLKND0tkB5mGoCamwK5K4Ss7wrr09CaU5jp9N1kV46yfVXBqBaVmsAWrqtF9FIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lR9+F9NaP1dudXTodfF6DwgdAkai3R3ryt44JjHD0c=;
 b=TJ1vTlng9dgC0VcBf5OS0jnS2CNHOaw4O60eRfHKVxe+ynfZAAs8M+RJcGNfe0ZjYX8aS352m8R8/1fBnZJhMHSXRrp0IE449DLJTnyGemKwqZyi67Oc8GlA9IyJU1JGe58bCZ5bfHtA5oyxTDG6ajso6LBZSF6M9b4gb8nxoOwGz7PD7XM7s4xU/mIy3F94PzUaW2Atqw+JalDeIbMqy66KIws4Mr8W8+EeCPlgeM1xS59do9tbDYWQwwTgzW/BVXtYZPda3ruhTODFmlxH1WN02tGLovvQ5x5jJ2Q3rBPBMJ8BBSKNbDhituJZLldAEM+NhuV6G+zQBQoyLOA00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lR9+F9NaP1dudXTodfF6DwgdAkai3R3ryt44JjHD0c=;
 b=w/70EQSO8kJCi6S+XymZZXSM1a9bAYnK10zy1V4/o1Bf5ESdrgWmbN9yN0a2ruYWmSN6IvwYCRczq93952FWwx+JbMVEwhZR6zYngXY9eo3t0BZRuLupiMRxCArSxOJvJi0tVvKlHRjASI8MtK98KWe+bOYSfNg5/SQuONxTiwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1414.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 17:43:42 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 17:43:42 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V4 net-next 4/4] net: marvell: prestera: implement software MDB entries allocation
Date:   Fri,  8 Jul 2022 20:43:24 +0300
Message-Id: <20220708174324.18862-5-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
References: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0045.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33ed3380-89b3-42a8-e081-08da6109665e
X-MS-TrafficTypeDiagnostic: AS8P190MB1414:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sxaZ2eensdJ4qYAkUyHcPxcq3cpUoovwLLnrX8fIlzpORki8/HZQznAlRcSehn2RFudbZ9lGqOQQvWWjrPtCJzSTyYPyCuRThQ/w3/q7KSCZyZ+J2+erGSVEtZLdmua59VKdguRXJMo3jNJtP85B/6ycOBg5BrNVQ2T9ptLsFOZIgj7WaaWQhv45dUq/Tz22kqqTe3K0XcA0EjQ39Dh9S4f7Aozxob/8gohgmSTzbl/+6DizqX8Dh4s2v1PvXgCQFimmsQiCvLjiYCtM9ZtXLh30pS1yfqHw1wOW/pVWLA6LaFiuDCkiYcT2P153Wa+cwvvZO7PqAHUKDpxSdYQU7WKcA/ASZDd8fpCkqLbPg/thrJCt5pyVgYCFJ91TrftHi2A7BwPZfFzzTdsTUq2EXEWS5hiI760u9ufdxTdFBi28wBj9wSwqnxov4e1bY2JGRKD+cFKGP1UVMhXzOUevOd/SfFs4ynJ31mI4JHcdDNZp1UdDaK/qeA6kEkArceJkVfmaTmrIhozqdKgx73W0mzezmaHj9Sy99I8VORiwfLvTT7yc1pzT5emBKzbYaeH2o0ZtqOr10PSEAXepwxCclOaqvTpYURN6KEyUqbRvqVL3IPF3UkqDVWshSWmvn6R9hQnYe9O2aipAWYWn3HfyPGEtW0CBYwwJhwz9aVmvsNUUJiXi0Ai5f4/GrQbFwl0162WE1DLmLIkra8RelFcMg0Mp9bcRzBo1OAnwoJrczhN50wznnsUDl/cMry3BaYuwTN3ggj9rh89B23nNZbiTrRsKx0L8D8hEhFO3vhla1JEmlgsRtEdo7dIR5zmHDoK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39830400003)(376002)(136003)(4326008)(66556008)(2906002)(52116002)(478600001)(316002)(6666004)(86362001)(6916009)(36756003)(6486002)(41300700001)(6512007)(6506007)(66946007)(26005)(8676002)(66476007)(66574015)(1076003)(83380400001)(38350700002)(38100700002)(2616005)(44832011)(5660300002)(30864003)(8936002)(186003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kNGFqeCMc9FtWu4wFH+FOeES2iH+ASE61rKQarUTLjGmEPIrIukuCIcQoOtx?=
 =?us-ascii?Q?K4d3LV1byiKmWnG0fxG2a0BVFj8B6GB3zwn/GoET6l9ufIkSg2mhEeahp0Fy?=
 =?us-ascii?Q?UGt2XyGLFKitdCD7rWrXCPb7NGGKgDDbCJCa+iDfW3jiQWyPP66YuQL5/G0f?=
 =?us-ascii?Q?CSQ06kIrqDilOPuCBrujwUj9XoLsN0apJz39AYc4yJ6qMV1eJHUR4QTVKnim?=
 =?us-ascii?Q?8bfF/xSQWDEX50DmNRhQTm8/IrLhemoJGHw/kpdgIPXHJsuu1Te0B5egVtaF?=
 =?us-ascii?Q?Y2zfQCEN2ta/fXzb8g5Z2dTytC4tMSjXzRknBydBddqtP/WeSgLY5QRSDZw1?=
 =?us-ascii?Q?GA6nLZUSXNngP5V2Icqyws5L1vd1yIrb7DgVS5aDH7P3soy8rNCtsVrtdlHB?=
 =?us-ascii?Q?CZFwwxe6BBSL/zHKLkAeCCXTpZ7x1ST5FrXhXjlnaNzpen5jKeVLekZR5oB2?=
 =?us-ascii?Q?qnbJzCARnJ8S96EWmk8T26KDc3X9ElMrpaMCJmEFwkjCUdrFxFAEW7IT5UdL?=
 =?us-ascii?Q?4+1t8WEMAZ5Gku0mC22pXyI9ZKPKzDFAvhDp18thqiXHKkK+cmpuAu21GjmP?=
 =?us-ascii?Q?t/dBfELv+tTgISQoE58KnWCCJzizq0wA3xAwhXsbkY5EAOaawNuJbsCGRvma?=
 =?us-ascii?Q?D4GE4peImeC3rGHKFtVfKMpu8umOcVgEJbyZMmz71/7anOwvd3vo9x5XCkPt?=
 =?us-ascii?Q?Z6nbb44L9GLR6vV6mEXZOHVx7+TQkI0ks4I4ndT728OT6OYf/hwmfdlgEoVn?=
 =?us-ascii?Q?KKTpqbZhhsPn9d0wEf4LYA9LeqeoHhsDulgd1OZsDJfNr10NURx474G+j3tk?=
 =?us-ascii?Q?maqt/tqKAwM/dW/qDTDeNZgziov8GcTXt+xv2DyBJ3KtDxj2nfpU+XWHRD+6?=
 =?us-ascii?Q?XUFjkUA3sKtcoBnm93iYnTaF1OEZO+SZ3AvrBTnf1BoNKbYNOTsPkrw6SZWd?=
 =?us-ascii?Q?NDRjEcBOxYS3PAkRXk1QQXo+hbppik1A5vTgIgj8HlurWAT+WvFANTWTcLjz?=
 =?us-ascii?Q?YMXZQA5wNtAYK8vZxh6E2/IJs1MeYiQqzLtHWoApzd2Vp49m7921pdMAGjHV?=
 =?us-ascii?Q?ZB8fKJIo9EvDE+qgGEqYcq0kGV+9Ueajpb25UTHyKUovCuDDIqQxWBkoygRP?=
 =?us-ascii?Q?Sp6M4xhPu7Qi1v8e6iYBY3WF6IdDzGclaP1biMpbWOcuwZMeVltLwiwredzN?=
 =?us-ascii?Q?l8sb+lS/Hlx8lEtXNYCNoYGdFdYYld+bsyv6bXBMKxu4xzBr/Go507R6Nz7P?=
 =?us-ascii?Q?HTTzpbyoCK04WI+JdbjlKUpga/a7PLs51BSLE576lm35ikRqe+4YK+lcXXHS?=
 =?us-ascii?Q?Q2TYiuy3VO3YfXQHHEVBj1e+fbNw//w5yz5SM2l/lB+e2D0xa9LrAJkL7bIE?=
 =?us-ascii?Q?xREVGftU+XI2kQ24UBESBo4owUvMAApipZ9uIJIt2Do/OO1fbjExWc7Fbw0r?=
 =?us-ascii?Q?ykaavjH0Enpm/P+DiFnovn/oCQEnBFb1Vhr49wn1ABd7eAPUWUZOgDzWUJu9?=
 =?us-ascii?Q?ZMitjZJImdk8CyavIYz8UzsDk/X3k0sjnIR5c4fcvVdOR4dJ3sUwWsEdz+IK?=
 =?us-ascii?Q?5aYOPzmBIulnnl5mXOfjfX0ZWDJJ1WNM7baZmg1mwey31DWAlzMMl5FXdW6h?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ed3380-89b3-42a8-e081-08da6109665e
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 17:43:42.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VMKkeYPwDvjwOP70gSkTJHU4zoTrKrDZsvO5Y+gfP+fJcb0FwTxJRv1QamQzMY71PCpEqXFl2FIV33XpWM0YcQCK03Xhb60Gj3VRTELO31Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define bridge MDB entry (software entry):
  - entry that get's created upon receiving MDB management events
    (create/delete), that inherently defines a software entry,
    which can be enabled (offloaded to the HW) or disabled (removed
    from HW).
    This separation is done to achieve a better highlevel
    management of HW resources - software MDB entry could exist,
    while it's not necessarily should be configured on the HW.
    For example: by default, the Linux behavior would not replicate
    multicast traffic to multicast group members if there's no
    active multicast router and thus - no actual multicast traffic
    can be received/sent. So, until multicast router appears on the
    system no HW configuration should be applied, although SW MDB entries
    should be tracked.
    Another example would be altering state of 'multicast enabled' on
    the bridge: MC_DISABLED should invoke disabling / clearing multicast
    groups of specified bridge on the HW, yet upon receiving 'multicast
    enabled' event, driver should reconfigure any existing software MDB
    groups on the HW.
    Keeping track of software MDB entries in such way makes it possible
    to properly react on such events.
Define bridge MDB port entry (software entry):
  - entry that helps keeping track (on software - driver - level) of which
    bridge mebemer interface joined any give MDB group;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../ethernet/marvell/prestera/prestera_main.c |   8 +
 .../marvell/prestera/prestera_switchdev.c     | 648 +++++++++++++++++-
 3 files changed, 656 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index f22fab02f59c..bff9651f0a89 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -341,6 +341,8 @@ void prestera_router_fini(struct prestera_switch *sw);
 
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 
+struct prestera_switch *prestera_switch_get(struct net_device *dev);
+
 int prestera_port_cfg_mac_read(struct prestera_port *port,
 			       struct prestera_port_mac_config *cfg);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 04abff9b049d..ea5bd5069826 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -106,6 +106,14 @@ struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 	return port;
 }
 
+struct prestera_switch *prestera_switch_get(struct net_device *dev)
+{
+	struct prestera_port *port;
+
+	port = prestera_port_dev_lower_find(dev);
+	return port ? port->sw : NULL;
+}
+
 int prestera_port_cfg_mac_read(struct prestera_port *port,
 			       struct prestera_port_mac_config *cfg)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 7002c35526d2..fea0d551adf5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -39,7 +39,10 @@ struct prestera_bridge {
 	struct net_device *dev;
 	struct prestera_switchdev *swdev;
 	struct list_head port_list;
+	struct list_head br_mdb_entry_list;
+	bool mrouter_exist;
 	bool vlan_enabled;
+	bool multicast_enabled;
 	u16 bridge_id;
 };
 
@@ -48,8 +51,10 @@ struct prestera_bridge_port {
 	struct net_device *dev;
 	struct prestera_bridge *bridge;
 	struct list_head vlan_list;
+	struct list_head br_mdb_port_list;
 	refcount_t ref_count;
 	unsigned long flags;
+	bool mrouter;
 	u8 stp_state;
 };
 
@@ -67,6 +72,43 @@ struct prestera_port_vlan {
 	u16 vid;
 };
 
+struct prestera_br_mdb_port {
+	struct prestera_bridge_port *br_port;
+	struct list_head br_mdb_port_node;
+};
+
+/* Software representation of MDB table. */
+struct prestera_br_mdb_entry {
+	struct prestera_bridge *bridge;
+	struct prestera_mdb_entry *mdb;
+	struct list_head br_mdb_port_list;
+	struct list_head br_mdb_entry_node;
+	bool enabled;
+};
+
+static int
+prestera_mdb_port_addr_obj_add(const struct switchdev_obj_port_mdb *mdb);
+static int
+prestera_mdb_port_addr_obj_del(struct prestera_port *port,
+			       const struct switchdev_obj_port_mdb *mdb);
+
+static void
+prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port);
+static int
+prestera_mdb_port_add(struct prestera_mdb_entry *br_mdb,
+		      struct net_device *orig_dev,
+		      const unsigned char addr[ETH_ALEN], u16 vid);
+
+static void
+prestera_br_mdb_entry_put(struct prestera_br_mdb_entry *br_mdb_entry);
+static int prestera_br_mdb_mc_enable_sync(struct prestera_bridge *br_dev);
+static int prestera_br_mdb_sync(struct prestera_bridge *br_dev);
+static int prestera_br_mdb_port_add(struct prestera_br_mdb_entry *br_mdb,
+				    struct prestera_bridge_port *br_port);
+static void
+prestera_mdb_port_del(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev);
+
 static struct workqueue_struct *swdev_wq;
 
 static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
@@ -74,6 +116,49 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
 static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 				     u8 state);
 
+static struct prestera_bridge *
+prestera_bridge_find(const struct prestera_switch *sw,
+		     const struct net_device *br_dev)
+{
+	struct prestera_bridge *bridge;
+
+	list_for_each_entry(bridge, &sw->swdev->bridge_list, head)
+		if (bridge->dev == br_dev)
+			return bridge;
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+__prestera_bridge_port_find(const struct prestera_bridge *bridge,
+			    const struct net_device *brport_dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &bridge->port_list, head)
+		if (br_port->dev == brport_dev)
+			return br_port;
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+prestera_bridge_port_find(struct prestera_switch *sw,
+			  struct net_device *brport_dev)
+{
+	struct net_device *br_dev = netdev_master_upper_dev_get(brport_dev);
+	struct prestera_bridge *bridge;
+
+	if (!br_dev)
+		return NULL;
+
+	bridge = prestera_bridge_find(sw, br_dev);
+	if (!bridge)
+		return NULL;
+
+	return __prestera_bridge_port_find(bridge, brport_dev);
+}
+
 static void
 prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
 			     struct prestera_port *port)
@@ -277,6 +362,8 @@ prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
 	else
 		prestera_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	list_del(&port_vlan->br_vlan_head);
 	prestera_bridge_vlan_put(br_vlan);
 	prestera_bridge_port_put(br_port);
@@ -328,8 +415,10 @@ prestera_bridge_create(struct prestera_switchdev *swdev, struct net_device *dev)
 	bridge->vlan_enabled = vlan_enabled;
 	bridge->swdev = swdev;
 	bridge->dev = dev;
+	bridge->multicast_enabled = br_multicast_enabled(dev);
 
 	INIT_LIST_HEAD(&bridge->port_list);
+	INIT_LIST_HEAD(&bridge->br_mdb_entry_list);
 
 	list_add(&bridge->head, &swdev->bridge_list);
 
@@ -347,6 +436,7 @@ static void prestera_bridge_destroy(struct prestera_bridge *bridge)
 	else
 		prestera_hw_bridge_delete(swdev->sw, bridge->bridge_id);
 
+	WARN_ON(!list_empty(&bridge->br_mdb_entry_list));
 	WARN_ON(!list_empty(&bridge->port_list));
 	kfree(bridge);
 }
@@ -438,6 +528,7 @@ prestera_bridge_port_create(struct prestera_bridge *bridge,
 
 	INIT_LIST_HEAD(&br_port->vlan_list);
 	list_add(&br_port->head, &bridge->port_list);
+	INIT_LIST_HEAD(&br_port->br_mdb_port_list);
 
 	return br_port;
 }
@@ -447,6 +538,7 @@ prestera_bridge_port_destroy(struct prestera_bridge_port *br_port)
 {
 	list_del(&br_port->head);
 	WARN_ON(!list_empty(&br_port->vlan_list));
+	WARN_ON(!list_empty(&br_port->br_mdb_port_list));
 	kfree(br_port);
 }
 
@@ -619,6 +711,8 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
@@ -730,6 +824,269 @@ static int prestera_port_attr_stp_state_set(struct prestera_port *port,
 	return err;
 }
 
+static int
+prestera_br_port_lag_mdb_mc_enable_sync(struct prestera_bridge_port *br_port,
+					bool enabled)
+{
+	struct prestera_port *pr_port;
+	struct prestera_switch *sw;
+	u16 lag_id;
+	int err;
+
+	pr_port = prestera_port_dev_lower_find(br_port->dev);
+	if (!pr_port)
+		return 0;
+
+	sw = pr_port->sw;
+	err = prestera_lag_id(sw, br_port->dev, &lag_id);
+	if (err)
+		return err;
+
+	list_for_each_entry(pr_port, &sw->port_list, list) {
+		if (pr_port->lag->lag_id == lag_id) {
+			err = prestera_port_mc_flood_set(pr_port, enabled);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int prestera_br_mdb_mc_enable_sync(struct prestera_bridge *br_dev)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_port *port;
+	bool enabled;
+	int err;
+
+	/* if mrouter exists:
+	 *  - make sure every mrouter receives unreg mcast traffic;
+	 * if mrouter doesn't exists:
+	 *  - make sure every port receives unreg mcast traffic;
+	 */
+	list_for_each_entry(br_port, &br_dev->port_list, head) {
+		if (br_dev->multicast_enabled && br_dev->mrouter_exist)
+			enabled = br_port->mrouter;
+		else
+			enabled = br_port->flags & BR_MCAST_FLOOD;
+
+		if (netif_is_lag_master(br_port->dev)) {
+			err = prestera_br_port_lag_mdb_mc_enable_sync(br_port,
+								      enabled);
+			if (err)
+				return err;
+			continue;
+		}
+
+		port = prestera_port_dev_lower_find(br_port->dev);
+		if (!port)
+			continue;
+
+		err = prestera_port_mc_flood_set(port, enabled);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static bool
+prestera_br_mdb_port_is_member(struct prestera_br_mdb_entry *br_mdb,
+			       struct net_device *orig_dev)
+{
+	struct prestera_br_mdb_port *tmp_port;
+
+	list_for_each_entry(tmp_port, &br_mdb->br_mdb_port_list,
+			    br_mdb_port_node)
+		if (tmp_port->br_port->dev == orig_dev)
+			return true;
+
+	return false;
+}
+
+/* Sync bridge mdb (software table) with HW table (if MC is enabled). */
+static int prestera_br_mdb_sync(struct prestera_bridge *br_dev)
+{
+	struct prestera_br_mdb_port *br_mdb_port;
+	struct prestera_bridge_port *br_port;
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_mdb_entry *mdb;
+	struct prestera_port *pr_port;
+	int err = 0;
+
+	if (!br_dev->multicast_enabled)
+		return 0;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node) {
+		mdb = br_mdb->mdb;
+		/* Make sure every port that explicitly been added to the mdb
+		 * joins the specified group.
+		 */
+		list_for_each_entry(br_mdb_port, &br_mdb->br_mdb_port_list,
+				    br_mdb_port_node) {
+			br_port = br_mdb_port->br_port;
+			pr_port = prestera_port_dev_lower_find(br_port->dev);
+
+			/* Match only mdb and br_mdb ports that belong to the
+			 * same broadcast domain.
+			 */
+			if (br_dev->vlan_enabled &&
+			    !prestera_port_vlan_by_vid(pr_port,
+						       mdb->vid))
+				continue;
+
+			/* If port is not in MDB or there's no Mrouter
+			 * clear HW mdb.
+			 */
+			if (prestera_br_mdb_port_is_member(br_mdb,
+							   br_mdb_port->br_port->dev) &&
+							   br_dev->mrouter_exist)
+				err = prestera_mdb_port_add(mdb, br_port->dev,
+							    mdb->addr,
+							    mdb->vid);
+			else
+				prestera_mdb_port_del(mdb, br_port->dev);
+
+			if (err)
+				return err;
+		}
+
+		/* Make sure that every mrouter port joins every MC group int
+		 * broadcast domain. If it's not an mrouter - it should leave
+		 */
+		list_for_each_entry(br_port, &br_dev->port_list, head) {
+			pr_port = prestera_port_dev_lower_find(br_port->dev);
+
+			/* Make sure mrouter woudln't receive traffci from
+			 * another broadcast domain (e.g. from a vlan, which
+			 * mrouter port is not a member of).
+			 */
+			if (br_dev->vlan_enabled &&
+			    !prestera_port_vlan_by_vid(pr_port,
+						       mdb->vid))
+				continue;
+
+			if (br_port->mrouter) {
+				err = prestera_mdb_port_add(mdb, br_port->dev,
+							    mdb->addr,
+							    mdb->vid);
+				if (err)
+					return err;
+			} else if (!br_port->mrouter &&
+				   !prestera_br_mdb_port_is_member
+				   (br_mdb, br_port->dev)) {
+				prestera_mdb_port_del(mdb, br_port->dev);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int
+prestera_mdb_enable_set(struct prestera_br_mdb_entry *br_mdb, bool enable)
+{
+	int err;
+
+	if (enable != br_mdb->enabled) {
+		if (enable)
+			err = prestera_hw_mdb_create(br_mdb->mdb);
+		else
+			err = prestera_hw_mdb_destroy(br_mdb->mdb);
+
+		if (err)
+			return err;
+
+		br_mdb->enabled = enable;
+	}
+
+	return 0;
+}
+
+static int
+prestera_br_mdb_enable_set(struct prestera_bridge *br_dev, bool enable)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	int err;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node)
+		if ((err = prestera_mdb_enable_set(br_mdb, enable)))
+			return err;
+
+	return 0;
+}
+
+static int prestera_port_attr_br_mc_disabled_set(struct prestera_port *port,
+						 struct net_device *orig_dev,
+						 bool mc_disabled)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_bridge *br_dev;
+
+	br_dev = prestera_bridge_find(sw, orig_dev);
+	if (!br_dev)
+		return 0;
+
+	br_dev->multicast_enabled = !mc_disabled;
+
+	/* There's no point in enabling mdb back if router is missing. */
+	WARN_ON(prestera_br_mdb_enable_set(br_dev, br_dev->multicast_enabled &&
+					   br_dev->mrouter_exist));
+
+	WARN_ON(prestera_br_mdb_sync(br_dev));
+
+	WARN_ON(prestera_br_mdb_mc_enable_sync(br_dev));
+
+	return 0;
+}
+
+static bool
+prestera_bridge_mdb_mc_mrouter_exists(struct prestera_bridge *br_dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &br_dev->port_list, head)
+		if (br_port->mrouter)
+			return true;
+
+	return false;
+}
+
+static int
+prestera_port_attr_mrouter_set(struct prestera_port *port,
+			       struct net_device *orig_dev,
+			       bool is_port_mrouter)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+
+	br_port = prestera_bridge_port_find(port->sw, orig_dev);
+	if (!br_port)
+		return 0;
+
+	br_dev = br_port->bridge;
+	br_port->mrouter = is_port_mrouter;
+
+	br_dev->mrouter_exist = prestera_bridge_mdb_mc_mrouter_exists(br_dev);
+
+	/* Enable MDB processing if both mrouter exists and mc is enabled.
+	 * In case if MC enabled, but there is no mrouter, device would flood
+	 * all multicast traffic (even if MDB table is not empty) with the use
+	 * of bridge's flood capabilities (without the use of flood_domain).
+	 */
+	WARN_ON(prestera_br_mdb_enable_set(br_dev, br_dev->multicast_enabled &&
+					   br_dev->mrouter_exist));
+
+	WARN_ON(prestera_br_mdb_sync(br_dev));
+
+	WARN_ON(prestera_br_mdb_mc_enable_sync(br_dev));
+
+	return 0;
+}
+
 static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack)
@@ -759,6 +1116,14 @@ static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 		err = prestera_port_attr_br_vlan_set(port, attr->orig_dev,
 						     attr->u.vlan_filtering);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_MROUTER:
+		err = prestera_port_attr_mrouter_set(port, attr->orig_dev,
+						     attr->u.mrouter);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		err = prestera_port_attr_br_mc_disabled_set(port, attr->orig_dev,
+							    attr->u.mc_disabled);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
@@ -1063,14 +1428,25 @@ static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 {
 	struct prestera_port *port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
+	const struct switchdev_obj_port_mdb *mdb;
+	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 		return prestera_port_vlans_add(port, vlan, extack);
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		err = prestera_mdb_port_addr_obj_add(mdb);
+		break;
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		fallthrough;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+
+	return err;
 }
 
 static int prestera_port_vlans_del(struct prestera_port *port,
@@ -1099,13 +1475,22 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj)
 {
 	struct prestera_port *port = netdev_priv(dev);
+	const struct switchdev_obj_port_mdb *mdb;
+	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		return prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		err = prestera_mdb_port_addr_obj_del(port, mdb);
+		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+
+	return err;
 }
 
 static int prestera_switchdev_blk_event(struct notifier_block *unused,
@@ -1239,6 +1624,265 @@ static void prestera_switchdev_handler_fini(struct prestera_switchdev *swdev)
 	unregister_switchdev_notifier(&swdev->swdev_nb);
 }
 
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_create(struct prestera_switch *sw,
+			     struct prestera_bridge *br_dev,
+			     const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb_entry;
+	struct prestera_mdb_entry *mdb_entry;
+
+	br_mdb_entry = kzalloc(sizeof(*br_mdb_entry), GFP_KERNEL);
+	if (!br_mdb_entry)
+		return NULL;
+
+	mdb_entry = prestera_mdb_entry_create(sw, addr, vid);
+	if (!mdb_entry)
+		goto err_mdb_alloc;
+
+	br_mdb_entry->mdb = mdb_entry;
+	br_mdb_entry->bridge = br_dev;
+	br_mdb_entry->enabled = true;
+	INIT_LIST_HEAD(&br_mdb_entry->br_mdb_port_list);
+
+	list_add(&br_mdb_entry->br_mdb_entry_node, &br_dev->br_mdb_entry_list);
+
+	return br_mdb_entry;
+
+err_mdb_alloc:
+	kfree(br_mdb_entry);
+	return NULL;
+}
+
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_find(struct prestera_bridge *br_dev,
+			   const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node)
+		if (ether_addr_equal(&br_mdb->mdb->addr[0], addr) &&
+		    vid == br_mdb->mdb->vid)
+			return br_mdb;
+
+	return NULL;
+}
+
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_get(struct prestera_switch *sw,
+			  struct prestera_bridge *br_dev,
+			  const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+
+	br_mdb = prestera_br_mdb_entry_find(br_dev, addr, vid);
+	if (br_mdb)
+		return br_mdb;
+
+	return prestera_br_mdb_entry_create(sw, br_dev, addr, vid);
+}
+
+static void
+prestera_br_mdb_entry_put(struct prestera_br_mdb_entry *br_mdb)
+{
+	struct prestera_bridge_port *br_port;
+
+	if (list_empty(&br_mdb->br_mdb_port_list)) {
+		list_for_each_entry(br_port, &br_mdb->bridge->port_list, head)
+			prestera_mdb_port_del(br_mdb->mdb, br_port->dev);
+
+		prestera_mdb_entry_destroy(br_mdb->mdb);
+		list_del(&br_mdb->br_mdb_entry_node);
+		kfree(br_mdb);
+	}
+}
+
+static int prestera_br_mdb_port_add(struct prestera_br_mdb_entry *br_mdb,
+				    struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port;
+
+	list_for_each_entry(br_mdb_port, &br_mdb->br_mdb_port_list,
+			    br_mdb_port_node)
+		if (br_mdb_port->br_port == br_port)
+			return 0;
+
+	br_mdb_port = kzalloc(sizeof(*br_mdb_port), GFP_KERNEL);
+	if (!br_mdb_port)
+		return -ENOMEM;
+
+	br_mdb_port->br_port = br_port;
+	list_add(&br_mdb_port->br_mdb_port_node,
+		 &br_mdb->br_mdb_port_list);
+
+	return 0;
+}
+
+static void
+prestera_br_mdb_port_del(struct prestera_br_mdb_entry *br_mdb,
+			 struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port, *tmp;
+
+	list_for_each_entry_safe(br_mdb_port, tmp, &br_mdb->br_mdb_port_list,
+				 br_mdb_port_node) {
+		if (br_mdb_port->br_port == br_port) {
+			list_del(&br_mdb_port->br_mdb_port_node);
+			kfree(br_mdb_port);
+		}
+	}
+}
+
+static int
+prestera_mdb_port_add(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev,
+		      const unsigned char addr[ETH_ALEN], u16 vid)
+{
+	struct prestera_flood_domain *flood_domain = mdb->flood_domain;
+	int err;
+
+	if (!prestera_flood_domain_port_find(flood_domain,
+					     orig_dev, vid)) {
+		err = prestera_flood_domain_port_create(flood_domain, orig_dev,
+							vid);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void
+prestera_mdb_port_del(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev)
+{
+	struct prestera_flood_domain *fl_domain = mdb->flood_domain;
+	struct prestera_flood_domain_port *flood_domain_port;
+
+	flood_domain_port = prestera_flood_domain_port_find(fl_domain,
+							    orig_dev,
+							    mdb->vid);
+	if (flood_domain_port)
+		prestera_flood_domain_port_destroy(flood_domain_port);
+}
+
+static void
+prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port, *tmp_port;
+	struct prestera_br_mdb_entry *br_mdb, *br_mdb_tmp;
+	struct prestera_bridge *br_dev = br_port->bridge;
+
+	list_for_each_entry_safe(br_mdb, br_mdb_tmp, &br_dev->br_mdb_entry_list,
+				 br_mdb_entry_node) {
+		list_for_each_entry_safe(br_mdb_port, tmp_port,
+					 &br_mdb->br_mdb_port_list,
+					 br_mdb_port_node) {
+			prestera_mdb_port_del(br_mdb->mdb,
+					      br_mdb_port->br_port->dev);
+			prestera_br_mdb_port_del(br_mdb,  br_mdb_port->br_port);
+		}
+		prestera_br_mdb_entry_put(br_mdb);
+	}
+}
+
+static int
+prestera_mdb_port_addr_obj_add(const struct switchdev_obj_port_mdb *mdb)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+	struct prestera_switch *sw;
+	struct prestera_port *port;
+	int err;
+
+	sw = prestera_switch_get(mdb->obj.orig_dev);
+	port = prestera_port_dev_lower_find(mdb->obj.orig_dev);
+
+	br_port = prestera_bridge_port_find(sw, mdb->obj.orig_dev);
+	if (!br_port)
+		return 0;
+
+	br_dev = br_port->bridge;
+
+	if (mdb->vid && !prestera_port_vlan_by_vid(port, mdb->vid))
+		return 0;
+
+	if (mdb->vid)
+		br_mdb = prestera_br_mdb_entry_get(sw, br_dev, &mdb->addr[0],
+						   mdb->vid);
+	else
+		br_mdb = prestera_br_mdb_entry_get(sw, br_dev, &mdb->addr[0],
+						   br_dev->bridge_id);
+
+	if (!br_mdb)
+		return -ENOMEM;
+
+	/* Make sure newly allocated MDB entry gets disabled if either MC is
+	 * disabled, or the mrouter does not exist.
+	 */
+	WARN_ON(prestera_mdb_enable_set(br_mdb, br_dev->multicast_enabled &&
+					br_dev->mrouter_exist));
+
+	err = prestera_br_mdb_port_add(br_mdb, br_port);
+	if (err) {
+		prestera_br_mdb_entry_put(br_mdb);
+		return err;
+	}
+
+	err = prestera_br_mdb_sync(br_dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+prestera_mdb_port_addr_obj_del(struct prestera_port *port,
+			       const struct switchdev_obj_port_mdb *mdb)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+	int err;
+
+	/* Bridge port no longer exists - and so does this MDB entry */
+	br_port = prestera_bridge_port_find(port->sw, mdb->obj.orig_dev);
+	if (!br_port)
+		return 0;
+
+	/* Removing MDB with non-existing VLAN - not supported; */
+	if (mdb->vid && !prestera_port_vlan_by_vid(port, mdb->vid))
+		return 0;
+
+	br_dev = br_port->bridge;
+
+	if (br_port->bridge->vlan_enabled)
+		br_mdb = prestera_br_mdb_entry_find(br_dev, &mdb->addr[0],
+						    mdb->vid);
+	else
+		br_mdb = prestera_br_mdb_entry_find(br_dev, &mdb->addr[0],
+						    br_port->bridge->bridge_id);
+
+	if (!br_mdb)
+		return 0;
+
+	/* Since there might be a situation that this port was the last in the
+	 * MDB group, we have to both remove this port from software and HW MDB,
+	 * sync MDB table, and then destroy software MDB (if needed).
+	 */
+	prestera_br_mdb_port_del(br_mdb, br_port);
+
+	prestera_br_mdb_entry_put(br_mdb);
+
+	err = prestera_br_mdb_sync(br_dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int prestera_switchdev_init(struct prestera_switch *sw)
 {
 	struct prestera_switchdev *swdev;
-- 
2.17.1

