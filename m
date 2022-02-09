Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207954AFF36
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiBIVbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:31:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiBIVbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:31:11 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140081.outbound.protection.outlook.com [40.107.14.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B444C002172
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:31:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8EHg9WrePd9/r7sfNxqLNeVTzOooyWUxZRiPT/6Jtv5ZiSeC3U2xVvTiqwyHxEhduBCMiyoeTzUPz25eDGtsv2ektvdHe+T12I/Zq2MXWEOZX5x9jIUiyyFUlX+EEb2ErC2KQ6YTL4CLybBVdS2ahhIViCzVX3/JsdoGU7aRfosq1iXbRkQd+qoiLwRz2ICGdY8Ik001bdnWqjuac1b/1t+D2Vt9mhz0DxYDbLX1WWWB8bJ3C4WkAe88m6njEmu4iHTUp8jBk0eiWiahvVnL0xW/niSyQf1NNIjhXaTbOjCJWQjTaJi/DsDCyz1aH81Bg3fkMHwwYtLjqHABtXDMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxGaN3zoQcTM1LO7MwcoyUP+8XQEQAkA+bg6Py+dpmA=;
 b=cHazB5fMvIiDV5/qBkJG7w6A30oFHXTKa7h4CQL3LITJUSaJZIj+TK3Qr3gMGoMYTgtZQMNFR8v0biBH6Q59NkzgEfYe0riISM3f6LapBp2/YkalW0aZFsbKMjGcLWm2uXsGOsl9B8b9H7i1/gKOVhzp27xK0P80o9KGscojM8YUZH62Bydi2VAjiH7nnhfIT7Xya4aPiJ+AUbwne7FHRW0BQpKQqPFJ6RP3QeX8vbwP16tChSK1YK8ctpE6tBwx0AOrcg2HbpNaWOFJLgt5iWrUbTZQ1irmw1tSaY0rmex1g0iZubAfQWR9MnQUp9TpbFQ4xc/T8rSo3JrNgZeh+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxGaN3zoQcTM1LO7MwcoyUP+8XQEQAkA+bg6Py+dpmA=;
 b=K7G8GY8G4ab+R8HZjTjQkCJ61Nx4BW5g38RVDprVKqNkIFyxLyEx8kAZ6H3Y+iLy9D0v0jcqxXB14eqb3EM2hZcuCm59K0rloHFZslrom7sA2l3o2dMiU24zJ9K/EwZQexT5r4n2K5tTXaimerztZGNSH+tO2HWTb/pXSpHps+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3481.eurprd04.prod.outlook.com (2603:10a6:7:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:31:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:31:06 +0000
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
Subject: [RFC PATCH net-next 3/5] net: bridge: vlan: notify a switchdev deletion when modifying flags of existing VLAN
Date:   Wed,  9 Feb 2022 23:30:41 +0200
Message-Id: <20220209213044.2353153-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0077.eurprd09.prod.outlook.com
 (2603:10a6:802:29::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4635cff2-343c-4104-7d74-08d9ec137b4d
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3481:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3481AE121F2AA34422614105E02E9@HE1PR0402MB3481.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rW4pcutzgqfRWmBpSNktavW4K6CD0I2S4xhhZNyBeMVOOuvz8UpSvPi7z5FMV0GP+rY6XzCKntTkAxyVPczJADbPe8H8JFsIJ94pIcrhUh5HoYHk0llin+NK/abbifV83s+l5u7aZ/Z9liBPN2VjmRj1EB/+CDcZG9115jx79K8HrkbNZoQd6wyW/hT7fulxXDjnRLw1xISlgSyd3WgXWcx0U/uoeYvDCSZ3ceEmrDjL9lNdKTzT5jZpYeWrWZrtlx5ubLcnePK4vgjGfUlLxa+28gx1Ia1TA1nVv+wusK7HqM0/1JsW5I3rSgUaRx2mQQctww9J83LYP/jWKdCN8XOcIVCvm9twqYT7kxvpKfuckatisWxox8QGRrt/Jbxlh4l8YVw6DomWOCqs0kVELNOz6qcwBvCFQBzP4ZONr8zAhAkAP/ts7fZy2ZNL/H8KmWiCVI4oHKSPaIUxy6LN8yYyd2CX4Rhl6ndnLUHgGtLj1WDKeRUfeJbkStgGpYODk+n3ugJaN+b08/1wwetmw1qlh8DxoRdwF//B1dDZhgOi+oLxJyp8J2/6QA4yHNKdy03//8IHJGC7doFJItva24BsrFCgfScTelTHWBkqD/PIlgrwTT1iLtL9+kjv42JgvO5KXrEz0LPv9eNS2ew/TWgrHRlCSbNSq69d4ybiorPVBqdkNjXeqlDgN3bHmwmxK3n9StdMeEgTaAkFuats9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(316002)(6486002)(86362001)(508600001)(66476007)(6916009)(83380400001)(5660300002)(6512007)(44832011)(52116002)(8676002)(186003)(26005)(7416002)(1076003)(4326008)(6666004)(6506007)(54906003)(2906002)(38100700002)(38350700002)(36756003)(2616005)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HTw0c+IaeC91uCGOLKZVThihOBkwuTuYX+PQVA0pJAbMmiaSWi9NUcY5QYxR?=
 =?us-ascii?Q?gXdaXRmZ1SMr3239YxARKkOeXvueQ7gQom20fITdvNuNs2DMZFXf2D+3+P+Q?=
 =?us-ascii?Q?tJ3Lj1Mn5bX6y7WEAL5jAcu4tMWdr9srcZV7G7o62P18qDHIGDc8W3rjyonF?=
 =?us-ascii?Q?t9DZh7M1vTkOt7HLY5LxaQ1FswtVK18u98HVEYnKfx7rhMktzoZ/FSlTocXy?=
 =?us-ascii?Q?MAegxBKpk6tHAO43H/5bWi/GxHDMMxPebNk4tJ92OZyzCVsST9YKBuWV1tcM?=
 =?us-ascii?Q?UNu1fzCOqH7A7WSjFsNAk5AzlEqzJt4ZLIDrJMR9KARHW0kCsGxryzMEq3UQ?=
 =?us-ascii?Q?leZr84m0eYydza9LgcSidGus+yLyN2BPKW18aALg6Oo1fjgKXWio69VywYW6?=
 =?us-ascii?Q?kdqRuXbb3mOy/d3SBabBql7XXy4sWhVSrBiR91qmLukr2svn3cppikQbOVp6?=
 =?us-ascii?Q?XfKMqBsbfhpYp0ewQGmEz7xkhJyjJfPFsoM53Ct/5L4pllGq0XLT7l3ML9tv?=
 =?us-ascii?Q?1MlzvShbEVCzH9oQaEqe3hN742Q5z7WSUaiFPKLDL9bs1Ta/ps/RobNQsDa9?=
 =?us-ascii?Q?J2CmZ56ouLHvlRiFTzCoyAg6phdHzWoXEEL5J4trEqQAoKlXHhcDbwq+ECl5?=
 =?us-ascii?Q?398dl+hsiKbpHM6iSuDIInmMIFsttIYhy0SwzK1LLY5yS7I1idxhghZRd8EM?=
 =?us-ascii?Q?PrdWOvGjNyXYf4q2ij+EROtq/WZQV1B9/viBsFV1XE+nLyNdGdseGlGjLduO?=
 =?us-ascii?Q?dtxmdr0SZpVY67+7amDCkpeiz/tkwVGOQO7YFPSZEXs7kdbfFDIm0I1lo6Au?=
 =?us-ascii?Q?dPsY4gGn+Hl7iG9GNlQIcLQx1L1qDavy/SR4lTVt9qWMZzjSpHbga0uORYGR?=
 =?us-ascii?Q?1Ni/tEhrc0IuiUuN7Ei4uS77BernCRf6DVTLK5vsYzt3BfvHXK/6wJmIwlwK?=
 =?us-ascii?Q?pCAuTzgnLWXwhC8Pmc24vaeHnWDtULZHZJdmOAHhRRK01+ZIzCtG2wqiIsli?=
 =?us-ascii?Q?AjqyH4Pa7Caxqn8V9NTvb/K1U9XMYSq3zZK97NEpZrr1BlM4U6dF/AUujDPw?=
 =?us-ascii?Q?FcuvWPlkPcIEvYo5WdJtMSAWoV/mxayPNthvrdtv3k2sMzzH381gtNJe5BOn?=
 =?us-ascii?Q?dnNI3Nv+rI6qjpz/rULSmr39hbGGvI5GP0PX0+xp7i0B9ArlUCpmbAiLvJus?=
 =?us-ascii?Q?2zuHX71wH9JAykROhmg7MGR4XUV7mVJEUQgbiwnkZbhCPbeD9c/EAHPUcwNY?=
 =?us-ascii?Q?B5fQhJeVOnQ04+ua38+blQUretFiCPND9OY1gl/wp+dFiby8sMr0ujNU5yhD?=
 =?us-ascii?Q?QatdI2ISHcZ8snnczLzDob/zzCHhlxEtQP3lT1KIyYUwhh3BJ2GCCDM95tT6?=
 =?us-ascii?Q?ZaHXah9lO9Cvh52q+HOVBsdSf9uzBPrk38oG+pz0rm4Ai4kx/BTQEOBVUPtE?=
 =?us-ascii?Q?cIUaXSD8Ae8rKtQ3mMy3OjNRG9Ak8f/6i5ADcgnsGQHkzhML7QhC+ktC9FPy?=
 =?us-ascii?Q?elfM/bPoLFz2HLELQoUnSuQoxHkzu5R5bAa4cFAICWIMh1WjHquGqtRzYln4?=
 =?us-ascii?Q?3nqbQBFgkTpeNI5MN0kDX6FsYu0rI6cQRzp0lLEPnUMejBce9Y/k8te3rR8T?=
 =?us-ascii?Q?JY8UMYeSfQrCvrb+MccPOY0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4635cff2-343c-4104-7d74-08d9ec137b4d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:31:06.8095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ws+Bg9cR8ezr5kFBsQ0CnUPuGy4RW7L5sqhL+8Oi/O+N6w2uXNE09b0b7/UoLTmCc65RCK0VGu0kpxhwUbUibQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3481
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several reasons why this is desirable.

A user is free to install a bridge VLAN several times in a row, with the
same VID just with the flags changed:

bridge vlan add dev swp0 vid 100 pvid untagged
bridge vlan add dev swp0 vid 100

After the second command runs, a subtle implication is that swp0 no
longer has a pvid, so untagged and priority-tagged traffic received on
that port should be dropped.

A quick survey of the in-tree code base shows that at least some
switchdev drivers do not appear to properly detect this condition, like
for example:

- sparx5_vlan_vid_del() sets port->pvid = 0 if the pvid VLAN was
  deleted, but doesn't set port->pvid = 0 in sparx5_vlan_vid_add() if
  the pvid VLAN was re-added as a non-pvid VLAN

- dpaa2_switch_port_del_vlan() detects the deletion of the pvid VLAN and
  sets the port pvid to 4095. However dpaa2_switch_port_add_vlan() does
  not detect when the pvid VLAN was reinstalled as non-pvid, and doesn't
  have logic to do the same thing as port_del_vlan().

- cpsw_port_vlan_del() calls cpsw_set_pvid(priv, 0, 0, 0), but
  cpsw_port_vlan_add() doesn't.

The list can probably go on. Some drivers handle the condition well, but
the point is that subtle code is easy to get wrong and hence best avoided.

The second argument has to do with driver-level bookkeeping of VLANs.
The goal there, broadly speaking, is to be able to count the number of
VLANs in use as the number of calls to br_switchdev_port_vlan_add()
minus the calls to br_switchdev_port_vlan_del(). This is especially
possible since now we no longer call br_switchdev_port_vlan_add() when
nothing has changed about the VLAN. But when a VLAN is readded with
different flags, the number of additions and deletions is unbalanced.

This is particularly problematic for DSA, who would like to treat VLANs
pointing towards the bridge device as VLANs added on the CPU port.
The CPU port is special because it is a shared resource for all net
devices, in other words VLAN X must be present on the CPU port as long
as:
(a) VLAN X is present in the bridge's VLAN group
(b) at least one switch net device is present as a bridge port

So DSA must reference-count VLANs added on the CPU port (once per switch
net device), and only delete VLAN X once there isn't any switch bridge
port offloading the bridge anymore. Using br_switchdev_port_vlan_{add,del}
is a good indication, except that it is easily thrown off when a VLAN is
reinstalled with different flags. Avoiding this condition at DSA's level
would mean keeping track, for each VLAN, which port it came from, and
what flags it had on that port, to distinguish between a change of flags
(which shouldn't bump the refcount) and a real VLAN addition on a
different net device (which should). Doing this would increase the
memory usage beyond reasonable, when we should be able to make do with a
single refcounting integer, not even the flags are needed.

The presented solution is similar to how FDB entry migration is handled
by commit 90dc8fd36078 ("net: bridge: notify switchdev of disappearance
of old FDB entry upon migration"): when a VLAN is readded with different
flags, first delete it, then readd it with the right ones.

This is a bit against the original spirit of switchdev notifiers which
were supposed to be transactional, but I think part of that was an
excuse to keep the complexity in the bridge driver low, and part was an
overly idealistic view of reality, thinking that complex device drivers
would be any better in terms of bug count. The transactional model for
VLAN offloading was removed in commit ffb68fc58e96 ("net: switchdev:
remove the transaction structure from port object notifiers"), and as
such, the only possible solution in the current API is first to delete,
then add. Treating errors in this model is best-effort, meaning that if
the deletion succeeds, addition fails, we attempt to reinstall old VLAN
with original flags, but that may fail too, but we give up and don't
even attempt to check the error code for the restoration. It isn't
formally perfect, but under the assumption that the original VLAN had
already been accepted once by the driver, and we're holding the
rtnl_mutex, so not much can happen between deletion and addition,
I think there's a good chance that the driver will accept to reinstall
the original VLAN. Plus, there are areas of the bridge driver where
errors from switchdev aren't even checked at all (FDBs), so VLANs
wouldn't be the worst part.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_vlan.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 3c149b54124e..5da7e2e23e68 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -747,11 +747,30 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags, bool *changed,
 
 		*changed = brentry_created || flags_changed;
 		if (*changed) {
+			/* First notify to switchdev a deletion of the VLAN
+			 * with the old flags, then an addition with the new
+			 * ones.
+			 */
+			if (flags_changed) {
+				ret = br_switchdev_port_vlan_del(br->dev,
+								 vlan->vid);
+				if (ret && ret != -EOPNOTSUPP) {
+					br_vlan_restore_existing(br, vg, vlan,
+								 old_flags,
+								 brentry_created,
+								 flags_changed);
+					return ret;
+				}
+			}
+
 			ret = br_switchdev_port_vlan_add(br->dev, vlan->vid,
 							 flags, extack);
 			if (ret && ret != -EOPNOTSUPP) {
 				br_vlan_restore_existing(br, vg, vlan, old_flags,
 							 brentry_created, flags_changed);
+				if (flags_changed)
+					br_switchdev_port_vlan_add(br->dev, vlan->vid,
+								   old_flags, NULL);
 				return ret;
 			}
 		}
@@ -1283,10 +1302,18 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 
 		*changed = __vlan_add_flags(vlan, flags);
 		if (*changed) {
-			/* Pass the flags to the hardware bridge */
+			/* Delete the old VLAN and pass the updated flags
+			 * to the hardware bridge.
+			 */
+			ret = br_switchdev_port_vlan_del(port->dev, vid);
+			if (ret && ret != -EOPNOTSUPP)
+				return ret;
+
 			ret = br_switchdev_port_vlan_add(port->dev, vid, flags,
 							 extack);
 			if (ret && ret != -EOPNOTSUPP) {
+				br_switchdev_port_vlan_add(port->dev, vid,
+							   old_flags, NULL);
 				__vlan_add_flags(vlan, old_flags);
 				return ret;
 			}
-- 
2.25.1

