Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6384B7761
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242116AbiBORC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242109AbiBORCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:47 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10075.outbound.protection.outlook.com [40.107.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2839211ACEB
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECG4i66zonVKFey9I5jnFoIv3G/VcL3jjfyPT4QFvuFSbZXebUWLaI7cVu9oz8aIliwNyac/peHVskQe4z7qSOkKoeOn8lM5lHOky306dv/Gp4fGIixx2JDfDM7jobTNqaQzplxa30/nqfESepx9Gv0xxz8HLLSIiu33HvB3lXrmdG/vL3BmUZp2qyGjZ1/0CHztquOKMcHc6YbKSEcNOWV0fqcI662MMuz0LRQ52HZu9w3bJTgRjmVelQrJtjCFbf396A7Bvao9vaPaW3OsBk/p/7aU8093zzwTX5r3VpdnGqR9V6Br+LZt6brZeC4glQw70VGgKfa1zXDl1vVZsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8suTKATUxzp4p0qo0GlyArOXaIbBY8P/XskrFnxh0w=;
 b=PR3eg/u1aUkXigYz2ciY97hPUHU1/XKH9TfTRV0R/N5odHnDdZfO9Pif2Imhv6XeQkQ9WysRneJjh8MduATQA7F7iNsueHbxv5aA1pCKefoSUNcSx93ByAgz265VuCzVP25OwRSgc0dAczZTidgmGNpIq8isWCqmR6xiuNKCdRbVK2hVnuEMQTW1qaHXvjr9jyD7wZs64OZBzt97Y2q3H21MsCflm5bsurLsmRF/5UsT9CUAaeRFh9Bp30MjuuAIZ7DExsp0sbWdvck96xajcOxYT8fcaz2sCiFZQC97yOO6wL47iALOS7kiKwQhsZ/uTAbpt18EtzDgdxPhrj49ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8suTKATUxzp4p0qo0GlyArOXaIbBY8P/XskrFnxh0w=;
 b=LmxyfvvYve9cXYW8LvbxDlEEtCcDJabNYa34IkPh2e0XokLdaS/1fPUSIZPKuzp7jWZlPao4D/w86cVb6Nk9dLv5zRJHV/RZa9VblOK9c0IRWrS8FUBpbEFOBDuaPkGTtXCaz5/JuRBW92Oegs9VWPbzBbIBrWl2jj6DI4rZEAM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:30 +0000
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
Subject: [PATCH v3 net-next 05/11] net: bridge: switchdev: differentiate new VLANs from changed ones
Date:   Tue, 15 Feb 2022 19:02:12 +0200
Message-Id: <20220215170218.2032432-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: dbe46fd9-1047-43db-1399-08d9f0a4f394
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342AF8F405E2FAD0B651E76E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cFazPk/Dlb780iPa27HjwTqr7JYKBcGPPTptZh07bEp1p6mXU5jXDffEAEqH7bcgAiQVfHHiDm4LLyiRTM90Sm4UTD8liJwvtnnS6XOawa0mDfRno6Jw2wMdqMFq1nCXKeSh06csVC6fRbwBsp2FBlvmwZzeCENmN7cW5lXXWldnqHeY/0Wv9BuxatO7SoL6dNPSuffNm40WPCJdDvvM2ZYIlq9lYaRv36Ijzg78+5LQQaxLoENnq9wsryIydwjyDd3hsfedh8pU+Lpkob5qjc8kBqDId8ZROZ+U5VXtbdU9idukILqOKBfy4lQVsTbNGvy4efJmSIAeflMpBMC/1vPiwTMLy3hNIxXWnRBcKwV7g1wOY3Io5/4Y8hlE0wrWqJWNyd/Gfug6nsQ3k5c4yygT41IQ2iUGZ8f96vrWvO6JynK4pvo//2T6Q8fmIlt8h8z6sUJwMYCKi1CmNLApDXgDMAk0TCigDxhhyiCP02Iq+zQ7/xbrfpsxfcDYMYZ9hAHPW6WXwFg0Ggl8Nl1qoqZ4k1cKlfkVmi+1t5antom312I251EMk+9zn86KX4y5sGa2r9hZrP9bCwvzFsb1N3vmjpEHwh0Lj0ymanuKgjAACB6UMMRzrLf28fGl4Bokn2KG8PQdkzP2LlC5cep6ll2/x4JpwzLvB4n8lnGtqFN0n1h+LuQDARvgf+RV7C1RmVZDkMPjbrY8n45ljn02Mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x3bW47ZU7+BExTqa2pE+qd5YHnLblT28XCac9nDryAF27XW417062D88iA5s?=
 =?us-ascii?Q?eX0B2cTGa0aNe2UWfgaTVYmaKf/ITeeUf/Ig/iXqrwL1sEyRcSd2B2vC0bFN?=
 =?us-ascii?Q?R0NKLLzHyOFPn33Fe/Jmh1KvEHkZPCMpxVi+R2w3sUL/Rw9A2hFWPGy5MROP?=
 =?us-ascii?Q?1J8wKqmnNYDsSmae5C/n8gEU2fBhrHBQnGN9xK4bTItI/n5lg2Qo2cTrT/A7?=
 =?us-ascii?Q?1AoPyniXpIoePCYMUn3/XYKuBCHLugHCErC6Ejjz/sI5cRUbB56sSt1pkYSF?=
 =?us-ascii?Q?j8pHBHXT3Ufd2nAUebPit+wQhqInvy2eahn8DQWfNEBv7DbKJSB53qhSizCX?=
 =?us-ascii?Q?OJdKJbbQT29pYsUGoa+g2VHbBMUQP2dpnnOVQl/UO+8p+u+rH5KqCBNu90He?=
 =?us-ascii?Q?8ii0QCAITCefOeFt1feyV3eM0BxCTnyQi9jsFmI620t3ijdr4R+3q+OPvVvf?=
 =?us-ascii?Q?Dov9o+hQk7RarhhKAT2skh/qPiwzcDPnVRnwolHU/rDYwuVP+5SlBVL0oHWu?=
 =?us-ascii?Q?x+pT50nxz4POQ89nTC96RC6Bgjdry6gtJal+yQWBQ/LtUcar0O27op3R1sm7?=
 =?us-ascii?Q?oqTfn0atlj3ZcdorGjx33ynjiDUpxmp/7DKlZhIJuAq1yrHJqYtJnWTnJxGk?=
 =?us-ascii?Q?o0OFfXhu7j4V81BGxIVPel/NcPsPBPi10AZcbsRVlNHeLn7wv6HmDKrm9jiP?=
 =?us-ascii?Q?zzKoin3f02/cmfwJeRqDxvR3bS3kTGwJepNGgHe2ZS5m7rDjlkGM4Cu0eE/U?=
 =?us-ascii?Q?jNnZml3Z2L0l+CJwwp4MXS7NFIcNyhWjBFxGW5ZilsBpgXH0jWwYqZhtbHDC?=
 =?us-ascii?Q?jNKKYvAln7kIJh/O5JYkNq9nHhVmOlvKyHuPxTMSzeYFHZhaFOyO0lJfoHAw?=
 =?us-ascii?Q?/7X5csN7/rdIUv8ZPdSKfDcgPvP82EI+3OYgRfMW2oW268kg+BTCdMjrQkT8?=
 =?us-ascii?Q?5d37pXvrXHueC2uXkwPnKpZsgxzkO+mx+L9eFH7I4bvzXL0toe2KOZYrRRzS?=
 =?us-ascii?Q?zaFS6E0RWQVU4X7xcjgwgp5yPGfl5fYxnYDvlSWI+N+UDxVqj8R8VlLMAs0n?=
 =?us-ascii?Q?+tOPKx8EjcJ8P9nc4txPyqOmGP0dwp3z4zvsi4GwcMFjIFyX1qNwhQIo1xZP?=
 =?us-ascii?Q?ucONJHPoE2Eb0u5jCqPB/UWB+KLF0akk6gKvnCLqLbh7iVnrN9VazU8efvnj?=
 =?us-ascii?Q?oP8ssUhWej+S9xw8B6p5cOJqGMaWj4oFb6lstncsA9aVmqPZ2L5ItG87yojV?=
 =?us-ascii?Q?ZAhhrYsmV6QES0P3jH0DdTERmZRkrWWQyQEQg1xHRACMV5hF9eD+PRDJXrJQ?=
 =?us-ascii?Q?Uu+ijpeskZfY/ULZaNL8IGGBG7rlmicOLoLKwYptJ8ikoq/MHYZrEKOH46f2?=
 =?us-ascii?Q?gcjPMcfV2QZnDgvdWNC4M5EUIFgMKRVDQBbIcgLM82Q+zpL3G06cBa+8P/Q3?=
 =?us-ascii?Q?QSeLSqbXDR9ab2S0bF804j4PFjKXZ81FAuHCBh1D7haS/VQgZIKiXFRgZWce?=
 =?us-ascii?Q?60+UGZuXht1UDH9dWs4Af1d2vSU0ShRKZ41yfRNUAuZoKyYblyOb9nJGJRlQ?=
 =?us-ascii?Q?QAnU3Zzc4dIf5++oH7thMPL6rkjPyHQ1zliWitNmr/RuGpt91jsbc7p5OPmM?=
 =?us-ascii?Q?pGOYFID3SQ+EkRfyfhCCPmU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe46fd9-1047-43db-1399-08d9f0a4f394
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:30.2912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhC5y9t19VgGxlSEebSor5SkeNO+ZbbpfyvVAW0iFh5bbI1wvtC4JjgLXtaWXHsOzHWLR0VqC5LyxDM45IGu5Q==
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

br_switchdev_port_vlan_add() currently emits a SWITCHDEV_PORT_OBJ_ADD
event with a SWITCHDEV_OBJ_ID_PORT_VLAN for 2 distinct cases:

- a struct net_bridge_vlan got created
- an existing struct net_bridge_vlan was modified

This makes it impossible for switchdev drivers to properly balance
PORT_OBJ_ADD with PORT_OBJ_DEL events, so if we want to allow that to
happen, we must provide a way for drivers to distinguish between a
VLAN with changed flags and a new one.

Annotate struct switchdev_obj_port_vlan with a "bool changed" that
distinguishes the 2 cases above.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- drop "old_flags" from struct switchdev_obj_port_vlan, nobody needs it
  now, in v2 only DSA needed it to filter out BRENTRY transitions, that
  is now solved cleaner.
v1->v2:
- patch is new, logically replaces the need for "net: bridge: vlan:
  notify a switchdev deletion when modifying flags of existing VLAN"

 include/net/switchdev.h   |  7 +++++++
 net/bridge/br_private.h   |  6 +++---
 net/bridge/br_switchdev.c |  3 ++-
 net/bridge/br_vlan.c      | 10 +++++-----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index d353793dfeb5..92cc763991e9 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -81,6 +81,13 @@ struct switchdev_obj_port_vlan {
 	struct switchdev_obj obj;
 	u16 flags;
 	u16 vid;
+	/* If set, the notifier signifies a change of one of the following
+	 * flags for a VLAN that already exists:
+	 * - BRIDGE_VLAN_INFO_PVID
+	 * - BRIDGE_VLAN_INFO_UNTAGGED
+	 * Entries with BRIDGE_VLAN_INFO_BRENTRY unset are not notified at all.
+	 */
+	bool changed;
 };
 
 #define SWITCHDEV_OBJ_PORT_VLAN(OBJ) \
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2661dda1a92b..48bc61ebc211 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1985,7 +1985,7 @@ void br_switchdev_mdb_notify(struct net_device *dev,
 			     struct net_bridge_port_group *pg,
 			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
-			       struct netlink_ext_ack *extack);
+			       bool changed, struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
 void br_switchdev_init(struct net_bridge *br);
 
@@ -2052,8 +2052,8 @@ static inline int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
-static inline int br_switchdev_port_vlan_add(struct net_device *dev,
-					     u16 vid, u16 flags,
+static inline int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid,
+					     u16 flags, bool changed,
 					     struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index f8fbaaa7c501..fb5115387d82 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -160,13 +160,14 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 }
 
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
-			       struct netlink_ext_ack *extack)
+			       bool changed, struct netlink_ext_ack *extack)
 {
 	struct switchdev_obj_port_vlan v = {
 		.obj.orig_dev = dev,
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.flags = flags,
 		.vid = vid,
+		.changed = changed,
 	};
 
 	return switchdev_port_obj_add(dev, &v.obj, extack);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 990fe0db476d..30486f20e29f 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -109,7 +109,7 @@ static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
 	/* Try switchdev op first. In case it is not supported, fallback to
 	 * 8021q add.
 	 */
-	err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
+	err = br_switchdev_port_vlan_add(dev, v->vid, flags, false, extack);
 	if (err == -EOPNOTSUPP)
 		return vlan_vid_add(dev, br->vlan_proto, v->vid);
 	v->priv_flags |= BR_VLFLAG_ADDED_BY_SWITCHDEV;
@@ -303,7 +303,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 	} else {
 		if (br_vlan_should_use(v)) {
 			err = br_switchdev_port_vlan_add(dev, v->vid, flags,
-							 extack);
+							 false, extack);
 			if (err && err != -EOPNOTSUPP)
 				goto out;
 		}
@@ -707,7 +707,7 @@ static int br_vlan_add_existing(struct net_bridge *br,
 	 */
 	if (becomes_brentry || would_change) {
 		err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
-						 extack);
+						 would_change, extack);
 		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
@@ -1282,8 +1282,8 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 
 		if (would_change) {
 			/* Pass the flags to the hardware bridge */
-			ret = br_switchdev_port_vlan_add(port->dev, vid,
-							 flags, extack);
+			ret = br_switchdev_port_vlan_add(port->dev, vid, flags,
+							 true, extack);
 			if (ret && ret != -EOPNOTSUPP)
 				return ret;
 		}
-- 
2.25.1

