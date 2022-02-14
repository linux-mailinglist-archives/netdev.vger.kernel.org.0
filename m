Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D4C4B5E47
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiBNXcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiBNXcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:15 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F94107A95
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1qw9LgQBF1AFWbhrZwcS6rcsyYpMtm2sUGhxV3w6rDQrNWU7Y0eA2crTTxQHVceELj/Lw5TqwIYb4mM7G/0Pd1N3F6ynRMCbeDAzesaSi88vUqqBgq4qvoIHNsBWUtmDyvKnPRnmGBLERryxyQNneeplPD4bW4y+ht3u4zkrZM8VeLtZVE47k7b0MOfVx6MSRzlBM7SWjSMB+pN2yqTDTGBO64HvahEvXEF69vzz9KEPZftJzHEOtnuVYL6DImn22KZL3IpL3Ii6IZkIgijXkdLl7Z/yDbKbaUXEG0hwr4kJjgJ06tVWbO7TB8JGqxE0iIwD87CViaZeQ3Jh+Qhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yayvcIRK8DR5g5i0lDfYKjm4dOnet8Dk+A4PbHr34WM=;
 b=RCEFDsbjPz2Vnj9+065ccTfNvLtq24iEhmCtCzW82UJFA4rlpBRloez5B/5jrObOvHEqXnc/gFURmY/8r+0sbvJ/wqAXaefEgHlYj1Rh0irj3ZhlJRoGT0Kw85En/sg0uivdsuyyCIzZwwAx0Wx7fi3An/kukUC1Btu20RZpoWZGstA6m0ImcEiautVGiREIyAIXaUH6ExqQGcJvSOf6M0c7AyGMbSh7WvY97i+Ar8qvimBNjllSjfjq1LpygOCuQxW32xZzhMZJUc2wSpS/yhrrjgm6d0QuKBBbvjQ3Lb1f0Oj/wA9CMyihuzeGiVtwGkyU4z5G1BBtGmLIgSEAcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yayvcIRK8DR5g5i0lDfYKjm4dOnet8Dk+A4PbHr34WM=;
 b=AzycIWonS2eodTaDZEVHmcbtd6LKu/XcMLibxNIfA4gFuvtSHOJyNNxw39hN5q4RpN8uF/eeBhnGVLaXBuy+dHxxEMmiLDBjQaujS5CGwuBBuoFjd3mFS9Gsi0P161SEuDHgACsEREiTe4flh6lZNaBVecrf8Ogs1pt/sE37cAk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:04 +0000
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
Subject: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only when something changed
Date:   Tue, 15 Feb 2022 01:31:04 +0200
Message-Id: <20220214233111.1586715-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: dd3764d6-aec1-43d1-dd53-08d9f01234f5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504E248927DFA50EF2B709FE0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiwMPR2wjr12UZdst2SJx3ke/DioMylYSHjoa/3ZHfCFaiSKb7p0ED+kCBn/0BsYkQCaaNow+Cn4t6lKVZkcbHICK+W8KM+VpKKSRQoy7gEScXKmPGWbrvxDLFnYNJF0zOChvolXYjV+sQUyaMNY/WunArgzty7d108f8mt5coyH5v5okM2Zqt0+RVLFHxAYiCYLXllD3zingIpSArXE9FfXmIEjPTp5YwXY1JPeRkmngUD0j3xLbzomuiIWB5bwiTsuGXc48c6X3fSquVaAAr5t0JTwosjmQzpR7thAqYH6gNxa/smAz6sKyqiBJTFGELhEs3yqAsdWT9KODCoqiao/10Unw0q2a+LSZEicPvQ8qyisAX4849VgBALsNNUHIE8BeIBcPeco8owIwSACejLIRUJW9Cz904q9RaibMJP82qp9W2Fokq17UHn9IuFqnm4B7EYWSOrG0OMYbGSs8SKfrQjNJd70JqGvdhi/yvNuYHTgRUsGgNk9CpByHcGq7oGmaYtg+r0okwjGgoFQv6Qz3ayYH1wzNBF6e8/GXXzbJm1SrJ/wW1eJUtoHHmUhPgbqwZXZBlrwkUaWXRYAYtjdqjJ1eJYxXLi0DgMPdkJrsCk99ctvSq9dxBe7gVPDbfhb/w0D/OeHVpUUQ/DVS942scRx65cwd6CxTr6DHGxN06ZXNXGhmh3aA7G4YAwrGZeR2k04XvtKq5+iJZP5JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6506007)(52116002)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UQzUhb5TMBa4wh3MPNY70YIJVdeHbhlMvMOiD574VBczmO6F9wB5EQgSUD58?=
 =?us-ascii?Q?/90LdmvNtY5IR8om3gFz6LK7beck5x45gNNp+6CY2P0QWuxXovuKjXh2Q8a9?=
 =?us-ascii?Q?iNVQmWW+ulNm0sx2PlpNvbBFa6hRxdTtyC3Juy5uCN/EcZPkvY3no6AZ540Q?=
 =?us-ascii?Q?eEmlyz4WUde2jNRj6Z08XBiweNn3iEqZn94+uViluf3wjKx2pPV6BsZbtTc4?=
 =?us-ascii?Q?UQNoQFISehloKWtTqh7C3qWQujVUgMcvZgBS0Asfh2SHOXG0VkxAZu2SiF/6?=
 =?us-ascii?Q?YpKz3DAygkKRPuEBWE1v0Iur463y9pjEGTK9rIy8cXzzsqVxVRYUZ5nJKyd/?=
 =?us-ascii?Q?jtT/pFq8I9HG9G7vxw5L0rGs1AS5UyvQTewyG6pY3cT27WsQgFCo7lpQm0qR?=
 =?us-ascii?Q?k3aDANoROA/aii0Kuhxv6iRpIJrg7RTaDUL2yNV/YdZCpRtASOXC6aIj4TaJ?=
 =?us-ascii?Q?LSelSlVcr3wSEZqy0d8V+zrw8rHggH6cUK8vvoC5Vl57AtLxfOVUotCGe6iK?=
 =?us-ascii?Q?4pL5SOsC1WnIxKA/s2gUOoPSjtZPFv6MyY0r+IA6zrX5tBqr7m7KLfqOn04q?=
 =?us-ascii?Q?UgBO0gywym2M43VIFxgG+ubddbctLFk7Ov9r+onpRbza5c3+kNADEqzfrUDb?=
 =?us-ascii?Q?zNS37yMMqTovxYX7jlcj5S1dPHtR1oOaANe2MUPJ4vGw3KriL3QYP10+QePl?=
 =?us-ascii?Q?+pcRFqRlLmL91xlxWVTJpz192gxjYJsd3G5kxWoEHl1s4stKpCs8e2D5ZUtq?=
 =?us-ascii?Q?dyj8HxdXLegJLCxt5kOs5N5xxO6G15eUKFB3XBf5RVucjSIBmj/CRq0hI59w?=
 =?us-ascii?Q?fTzcV3XLQoN9hXqutFatyQ0vVnHcb/f6uU5raqXBM07DppLKBaG/dOEDVVl4?=
 =?us-ascii?Q?RvZjlCssdMrzdTpEfJtpYPjoO0NdXWYiU0bk/VNTq/q7Px78G+dvz8zAR51V?=
 =?us-ascii?Q?8yvLFB7oLYJYfnrjidHw4ZumKa46A7Y4GdZeo7XHzGTxJx3ahuOcH6ZeyRUp?=
 =?us-ascii?Q?Cr5l6eMGEv9H39wNksRPbV7t+Sp9Xt0J/ffGJK2WPbPjOVMKCa6gwNHsso5o?=
 =?us-ascii?Q?B1SppuhBQic5R7S3f5DQ7BxIglOILa5Wfx4ArgJTaBVYLJk5epiMgY9UlmxS?=
 =?us-ascii?Q?MQ/Mzgiat4ImdG6kEoUImZSDyGgEvHN28bVr3hQ3KIVqhTXSXkeQMoW1r++L?=
 =?us-ascii?Q?OQ7BAIgbFn46z3fqz8u12vHiHcmanQ4eE5cga12NynYredha+3iVEeZdnibE?=
 =?us-ascii?Q?+XY5X9+0/GsJUMacDloap5Rgsxh2WgViwIhSbI5LZTN3Mn9PMa9EFSfEbrMz?=
 =?us-ascii?Q?U0X0tFAPaJhdbz6CrtPS1jA/7w4IC0Etq9vPIUxVIzjEMXdzSeffKYU2J3bx?=
 =?us-ascii?Q?cy8liNky+s8zqo6G2RfEnW3Gf/ezfvLC6eKKQ/26P4qczgSBu2ftM+aQEtSZ?=
 =?us-ascii?Q?ZJPtAZ9n31UEazR70IQRLlALUABdoLrgtzXzGxwHpgVhqXAU2tVm525L0OVR?=
 =?us-ascii?Q?8DK4fGcaVYyvX+bOqJltW3srY2nN38m4+wKN9N5ZcGUg0zO0qr+wWyYe75fb?=
 =?us-ascii?Q?A45Wy3pOOx1cDNrdy5lpcsKN8BHBpks+WFKVpWA3r7/JK64MLbCybMToW0/P?=
 =?us-ascii?Q?7I8dYVcvW1Ae6REoXEl2L78=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3764d6-aec1-43d1-dd53-08d9f01234f5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:03.9491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AT1dxfHiG/kS6G1gYFwD5r76MqKjnEAqe/1McochOPwQ8bgZT3OKVFzJOuUtGShU4i7zxTkjd0pmgl6eUGjQLg==
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

Currently, when a VLAN entry is added multiple times in a row to a
bridge port, nbp_vlan_add() calls br_switchdev_port_vlan_add() each
time, even if the VLAN already exists and nothing about it has changed:

bridge vlan add dev lan12 vid 100 master static

Similarly, when a VLAN is added multiple times in a row to a bridge,
br_vlan_add_existing() doesn't filter at all the calls to
br_switchdev_port_vlan_add():

bridge vlan add dev br0 vid 100 self

This behavior makes driver-level accounting of VLANs impossible, since
it is enough for a single deletion event to remove a VLAN, but the
addition event can be emitted an unlimited number of times.

The cause for this can be identified as follows: we rely on
__vlan_add_flags() to retroactively tell us whether it has changed
anything about the VLAN flags or VLAN group pvid. So we'd first have to
call __vlan_add_flags() before calling br_switchdev_port_vlan_add(), in
order to have access to the "bool *changed" information. But we don't
want to change the event ordering, because we'd have to revert the
struct net_bridge_vlan changes we've made if switchdev returns an error.

So to solve this, we need another function that tells us whether any
change is going to occur in the VLAN or VLAN group, _prior_ to calling
__vlan_add_flags(). In fact, we even make __vlan_add_flags() return void.

With this lookahead function in place, we can avoid notifying switchdev
if nothing changed for the VLAN and VLAN group.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: drop the br_vlan_restore_existing() approach, just figure out
        ahead of time what will change.

 net/bridge/br_vlan.c | 71 ++++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1402d5ca242d..c5355695c976 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -34,36 +34,29 @@ static struct net_bridge_vlan *br_vlan_lookup(struct rhashtable *tbl, u16 vid)
 	return rhashtable_lookup_fast(tbl, &vid, br_vlan_rht_params);
 }
 
-static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg,
+static void __vlan_add_pvid(struct net_bridge_vlan_group *vg,
 			    const struct net_bridge_vlan *v)
 {
 	if (vg->pvid == v->vid)
-		return false;
+		return;
 
 	smp_wmb();
 	br_vlan_set_pvid_state(vg, v->state);
 	vg->pvid = v->vid;
-
-	return true;
 }
 
-static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
+static void __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
 {
 	if (vg->pvid != vid)
-		return false;
+		return;
 
 	smp_wmb();
 	vg->pvid = 0;
-
-	return true;
 }
 
-/* return true if anything changed, false otherwise */
-static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
+static void __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
 {
 	struct net_bridge_vlan_group *vg;
-	u16 old_flags = v->flags;
-	bool ret;
 
 	if (br_vlan_is_master(v))
 		vg = br_vlan_group(v->br);
@@ -71,16 +64,36 @@ static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
 		vg = nbp_vlan_group(v->port);
 
 	if (flags & BRIDGE_VLAN_INFO_PVID)
-		ret = __vlan_add_pvid(vg, v);
+		__vlan_add_pvid(vg, v);
 	else
-		ret = __vlan_delete_pvid(vg, v->vid);
+		__vlan_delete_pvid(vg, v->vid);
 
 	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
 		v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;
 	else
 		v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
+}
+
+/* return true if anything will change as a result of __vlan_add_flags,
+ * false otherwise
+ */
+static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
+{
+	struct net_bridge_vlan_group *vg;
+	u16 old_flags = v->flags;
+	bool pvid_changed;
 
-	return ret || !!(old_flags ^ v->flags);
+	if (br_vlan_is_master(v))
+		vg = br_vlan_group(v->br);
+	else
+		vg = nbp_vlan_group(v->port);
+
+	if (flags & BRIDGE_VLAN_INFO_PVID)
+		pvid_changed = (vg->pvid == v->vid);
+	else
+		pvid_changed = (vg->pvid != v->vid);
+
+	return pvid_changed || !!(old_flags ^ v->flags);
 }
 
 static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
@@ -672,9 +685,13 @@ static int br_vlan_add_existing(struct net_bridge *br,
 {
 	int err;
 
-	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	*changed = __vlan_flags_would_change(vlan, flags);
+	if (*changed) {
+		err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags,
+						 extack);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
 
 	if (!br_vlan_is_brentry(vlan)) {
 		/* Trying to change flags of non-existent bridge vlan */
@@ -696,8 +713,7 @@ static int br_vlan_add_existing(struct net_bridge *br,
 		br_multicast_toggle_one_vlan(vlan, true);
 	}
 
-	if (__vlan_add_flags(vlan, flags))
-		*changed = true;
+	__vlan_add_flags(vlan, flags);
 
 	return 0;
 
@@ -1247,11 +1263,16 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 	*changed = false;
 	vlan = br_vlan_find(nbp_vlan_group(port), vid);
 	if (vlan) {
-		/* Pass the flags to the hardware bridge */
-		ret = br_switchdev_port_vlan_add(port->dev, vid, flags, extack);
-		if (ret && ret != -EOPNOTSUPP)
-			return ret;
-		*changed = __vlan_add_flags(vlan, flags);
+		*changed = __vlan_flags_would_change(vlan, flags);
+		if (*changed) {
+			/* Pass the flags to the hardware bridge */
+			ret = br_switchdev_port_vlan_add(port->dev, vid,
+							 flags, extack);
+			if (ret && ret != -EOPNOTSUPP)
+				return ret;
+		}
+
+		__vlan_add_flags(vlan, flags);
 
 		return 0;
 	}
-- 
2.25.1

