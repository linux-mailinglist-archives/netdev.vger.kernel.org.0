Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18D4B5E4C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiBNXcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiBNXcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:25 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBA910AEEA
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPMoFZtm+9WKv2JhXixR+D9bKB5XA49oHx6QIkKl7VxI+OEHG+bI33gzQuBu2cRZ6Q3PyENqbBStfMfjk4hWiIScs7bh4xLEMg67NDG5Im0vMYTOBYLQb6eUaGbzk2otKaTmQvZooMg8v2k0xiPvjZhYPtMFD2ENkQA0vffsYu/v4arIgLEoSQVlAd6F68q0Y9cT10EefMkitAGSscQmGZUtIOo+hGdPtuTzD29ypaEa7NtxowurtIvNI042n9CLY8kyCouKiLQJUoJW8Pnq+CgtyPf3MNdMgZXR6SejfQ9W3IrhEkym42vpdgfvdxVqSgKCv2pJ5C+XTJ/d3TmYCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSgNJY7O8izPLojae23n3NERCUHvbFEiSe1WN4hrLuM=;
 b=LukqPf/T1fQ3v4DiYsiD6IrEOKQ/eQEJUwxMVPvWN9ATvjLC7sGzY/F8E7AY4LXaoUQei43I4fi45j32zmBJsFZiLzXAQMmTcsLUSCFLSmyNlmKyR3uApdvUxcBg66aNLXoIbn7hfLqMMsAapQw5lfYBD87+SMR6lrncDiA2hFjK8r+3ESG9HJVLoqiRzIFKshGjWJ6MTrTl0MePzmbhNXw35altwtTnEU+A6ODgDiyNG7ufz5PqO6qVWT1ekkW5CEBfLXcIPJE5JmBj0apLeOQUw+kFIb9NVD4Rwfl2QdJLrjrfEHh820LYdGaaIKKzr3lZ3UNxddcijQGhyHXhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSgNJY7O8izPLojae23n3NERCUHvbFEiSe1WN4hrLuM=;
 b=iKDJx811NrLB0ThS+DBKVlDBj6Uob2zYB/L824Pvg0l+oLQpyDtkMkqwoCra9WOteHh8HmVSf5h4LPbdZ9DGNaDAGyetGxy90DzWFejho+TUTXyvtwHwq80zcp6zY1mLG+dvccQ/oAT27i795Jnqvq5ZLuKNUfYu5klHA5YlfEo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:10 +0000
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
Subject: [PATCH v2 net-next 6/8] net: switchdev: introduce switchdev_handle_port_obj_{add,del} for foreign interfaces
Date:   Tue, 15 Feb 2022 01:31:09 +0200
Message-Id: <20220214233111.1586715-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22fecc5a-5fdf-4566-d738-08d9f01238ef
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB55043CD116A3C7BCE04FD6DCE0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnOlehXygvUoqFVxp7u//bub9xYvaJ+k3DeazODd5DSI67Glvcw01ANI//lIEMK/heAt6mXm4Y1CVRlGQBMnqQj3D6a+vCS1/bAONni04YA617BUG+y/Lne+4WlM7Ws0y55l0NRWkECT2Oq/qDaTWljxJDBiDuZLnWrGeFXpRsN7s6Ed3/GnJsOR4gNpkR5qd5QzNhYpYpmRuX9TtT591/WZUygevLB+1VXGOb6Md+iaG3u9dC9hNR/F4o7Eb/RPD5WNmKs1xcaTStcmNEYis+MnTIzJ1LCgG4TxGAjDt2+UATSjI6Hx7v3ihmpqyQbEHs5/eUzM5VSwlt3Z3ZW51clyqgQR0w0pC7AqZDGe3qZeDA+9t2rhebKr6ViPbOFrlD4gYcMfzexXgRihLc/8QTq+c1XO4Q6yjw4UaoslKhHYtk+C5e6mkxaw6gU8Fy7WeyP4zx7Qc2xwLT7PaiWvySINV+xSKlRAd5Fr2MHHKNM0XyrZAXuDPtR+gTfcW6cUyBgY7cDKSegDlRSKtelXucvD/SwrzWMvVmNjWNpgucYS5nvCNxm+2nGnWWU7WlITXUS3mixwiPzGZGKW6ZuD3WN78W7E9CjcCsdiOvZquoUvBGQCVvX8hcZDEyVxJ8cfNXbKiinU2XE9hVo0FsrBdik/Dd39bmhQXm8mMbXi98Hkk2CETg1ZIvnmyBjUhV/5aRZmZKOLiR+g+DKinQ6RIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(30864003)(508600001)(6506007)(52116002)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HqpLeac/1QiCj2mtJAQ0kKWhnC+QXNsSUk8jM6NeT9ALwjLUrAbxfqwST1y1?=
 =?us-ascii?Q?NBuLykd5cF1gxHtFK9ToQLTXK4ZDlsEBf/0/pnLclthaGeKnYzcwsgYl6oYr?=
 =?us-ascii?Q?uDs8TpKcHmyXyizCY6DYnF6jLrr9+DMUSLXfLydw7rOaOi/qu3AlFksKVJEK?=
 =?us-ascii?Q?nMZqZSsbIF5ZCwihxup4J8DUkfQr46OXMTuBnS+qIvv/ud80G2qm8un2DgK/?=
 =?us-ascii?Q?srIdOLGwERwn/dlxmbnd9/Pd6Ftf8KhAkuSLbMco+6TcXGZPrMhwLvvvTzfW?=
 =?us-ascii?Q?khn0DrngaWkesjz/p3O5Az4G+kRoKjAAQENm33QfUNr+X3DxPmS9sFjArV8Y?=
 =?us-ascii?Q?X8+G4JO1vT1SwXt6H21DQk1Qnuy+EmA0CEqtD0o7Mc0BWDX4WEAGHrGKmo00?=
 =?us-ascii?Q?5V87h8rKx0oIuTuh0UU8M+IsDI3O7V3R4dUJEAs1gfo9QNw9YVtbMvirila9?=
 =?us-ascii?Q?moi9RS82sg45YzRMZ5EKyM/hdXvD+kBI5E7dJjnV0XUL+jr3AJ72Gaztgu9b?=
 =?us-ascii?Q?gO1EsIpBFu/1eecXXO3MznT0wwRoAwO2Lq1oxcEHGctcSO+Q1noDNnSxmNME?=
 =?us-ascii?Q?jMTUR/K1EpuDVp901/hkCRLmSa3E9+5n0maFYb9AoACJOajQ2E3rx1sysTGj?=
 =?us-ascii?Q?lYUfldE6l3UkDBuEoAs+U8VnsZI4ixDxRGKBX8YSlEbSW5j5Y33GH0a05juc?=
 =?us-ascii?Q?lzDAmf+q9GnfsEnuxnOpOwzXcKj2tiye0GhyHYDIjdv6p3X0uhp0dISM+U2n?=
 =?us-ascii?Q?P2B0hU/g2brhza5z20V5GmgOreaDj0ylNIEQsJSl9v4vriqNFcftM5OheVnd?=
 =?us-ascii?Q?RZpqlV3op3jtPmlY3JXTqZbMhUeM1UzY6nlRRlOfH4C2ieOK+VsiwduXQfSC?=
 =?us-ascii?Q?UJmHWnsfrvO6mP6rN0ErY64IqGLzAYRYzn1yxfcLYj4/fosFLuQ5MoInpE47?=
 =?us-ascii?Q?lOyO6nKPHCPQp/UjoM5QDT7DRxQAv920RvOHZHN6oMLi80DlJmBELzU0gxMs?=
 =?us-ascii?Q?e5iyQVe+q69Ocdu+2Av74RIDu/tZEcAfOJ9zCDc7OrzoBWSGTQfq9WkL41fO?=
 =?us-ascii?Q?mUx6t98JO23yDL/zcuBdSPPcV/u9oNn1DRYiQL2+w8yg9GDmkNEj9DPGRTiU?=
 =?us-ascii?Q?eDdmYhe1zzj9LWWjbKsPjYTNbc1w6CuyKrEy4w9r1EqTm5GrGkZ9X7xMxc/Y?=
 =?us-ascii?Q?k9otr1akh/dn6eh8kqfTxua4LoKlHaYj50b2fxzuq6FfTZKeFqx+deDpTnpA?=
 =?us-ascii?Q?B7LjnJhRYW7Wc8cO2NVBv3E70Oq0WZ9gYycm6VOQgIezsHeT+KvUFZauRcam?=
 =?us-ascii?Q?k+TW4+b/TiyvCNUnjzA82lMH86Xe1wjLKOhL6mMpnCLsInoH7zJwCCdMWqpM?=
 =?us-ascii?Q?cHYV7l92sVk1kDMHYSwLeDXJmW4yblGSARghRmNzGwepsDAJGDlSZnbQqDr5?=
 =?us-ascii?Q?B5BSo4PBPdEhIcMLDeH1BGABl/sAeLKP9HhAiRkKfVaEF3GXlw8w2wfttDMN?=
 =?us-ascii?Q?NUG4Nci069n3Q7TxBS9kD81k7PVeVBVWNGwdO7jGstFNBEqYnYsGAYHO4zli?=
 =?us-ascii?Q?LsVPrPnR7+nQHFyWO2lh0P7tg69AKIGCVRsAaGn1t9ia27iyf2OzK8D622I4?=
 =?us-ascii?Q?HBTszucqgy74nXxPBOsrMwI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fecc5a-5fdf-4566-d738-08d9f01238ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:10.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4NgYuznQovcKMR8g9RnEs2y3zg+aM7lUirak9AQX/kj+IlWgOihL834+TBnMTdvZd5C+gODSDJr0E5+96pcmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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
v1->v2: patch is new

 include/net/switchdev.h   |  39 +++++++++++
 net/switchdev/switchdev.c | 140 +++++++++++++++++++++++++++++++++++---
 2 files changed, 171 insertions(+), 8 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 24ec1f82a521..2ceede8e2aad 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -323,11 +323,26 @@ int switchdev_handle_port_obj_add(struct net_device *dev,
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
@@ -446,6 +461,18 @@ switchdev_handle_port_obj_add(struct net_device *dev,
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
@@ -456,6 +483,18 @@ switchdev_handle_port_obj_del(struct net_device *dev,
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

