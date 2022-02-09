Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30904AFF38
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiBIVbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:31:09 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiBIVbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:31:06 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140081.outbound.protection.outlook.com [40.107.14.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56704C001914
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:31:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxrvL0LqDV5ZfJ0i9JEDH6qg3YiMPWbdJtcnGdIioTr6mki/hJJ2wuRBs5uW8kKjrVWXhUliYPGwWEoXxoYJ+YbbOHxzPE74Gt7zsk6oMPNx7JacPGI5xO9YvebBEhaWz2OAOSDab8kLypjzHBpXKwndNEKv0zZluQEd3lzkXg9D+dNenPcpyqNEyX64zrM5NoelfwbZPh3uFayo6uDYDyggg2b5ZjzWsE/nOgeAJybj7dpnYneBJuGLuR+TiW/q7WSdhXcmrVq7aic2SYbeCCDMED85NNbkI4Egpl//islr8hJJGywrVWbxQ/GoCCQ3h92e82zk0h8rP3HUfLwpFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxVr9ljzhDEnIb2uNQwm1Pp8Ts5ruLVfo9Wr3ZJRPuU=;
 b=ER0PIutbpcOr1jgZtK2JEyDdWxWoopH4A+J58waKAizROf9XIefuwVHqvwFn8Wcv3e9kyPkvjYyhkHPc6XJmU+Z244a7/T9e9xBCLqMyiB4pMNl6drT8uWBgM/znXNNtItO2ol74+jCdcNcn/pISLuCvNramM4Dz9Rmp+zWYJDTdc2fPXIFAtn6hw9JbSrndihT02gjLEqb/vfyEFa4cOJXKZa8odLlA1oLjJgHsZWgmnXgyBJ7wmnUWkxp3P6MIiVkzgr5DJ82aZ8d+7B5L0vxKpeVA0FQite/S7DtacxomrTn5ZaId5UMjD+US5f9DMtdDcXsBP8hMJyE8b+WMtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxVr9ljzhDEnIb2uNQwm1Pp8Ts5ruLVfo9Wr3ZJRPuU=;
 b=Ydj9Cshw1qMp/xPf8z6vOG3Z4/YvqmsF6WeCErhY+22BLCHwa/XnjSfh5LorRH05mXKqwky9ixXbJFCiLMzj24p+9l2Z6FuyBDFir0LYBA45GSNQj/9bRsOel8nY6LHT6EdwwCXawrmdf/P+twaNNNSXn5Jv1kZnoRsYPc9CO+M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3481.eurprd04.prod.outlook.com (2603:10a6:7:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:31:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:31:05 +0000
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
Subject: [RFC PATCH net-next 1/5] net: bridge: vlan: br_vlan_add: notify switchdev only when changed
Date:   Wed,  9 Feb 2022 23:30:39 +0200
Message-Id: <20220209213044.2353153-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: df986e7c-b870-41a0-3b9c-08d9ec137a85
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3481:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB34813E7107315FFAA597A950E02E9@HE1PR0402MB3481.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dBcKbULu5oPKoPGxd3yMqTGi4vG9Ek8XPDrUvA22paZvUoMG6YTwe+Ui3+CiP/h7ixjFlOa28HlrUFwlgV3Y1R+Zlr4runbX3oSYKH/51s+b6eD0Cxt6TjGHD+K5fU3eObLDfQ6YQjKPjKf1QkOQGGsKq+e99V6KOJS05kVjnuGMSmlnLdDk/KYXru2KRP4hRC/4ySONefU2D07n9IAWANlhRgVfMklVum+N5ykZSYvYSD3x3PDYNtgrmdi0nYXFkgLRdRy5XCbi6PKMtFPFmv2rGR4MOKgPFtoJuK24XmQhDWqnxo/GR6G48EJS9xc19n6xWDP2+xDpoLXSOdf9VVxkU03PA8pS8D4ONvh/S7D19+CIbhpmyju9QFFWvxpEFnJzHdQDyy70ye6QUePv6amGiXwi9Cf4fJfOOo/MCnXHhKLljVtsXGhiAVrvCJgUs8hIDHFrIBZWJ6PLupVvOPVzdEmrwvlBcTxdCJKFkacjReTl6BQOKC+zpnP74JLDIdTCzTHO/YcKyoAypzLee0W3TJqgxjNqu6fafrLAMAMLzOtkMl2J2RMq6H+AmhBHuzNAiQ04/Ic8K3L4RWayug/6hcrO59rN5b6vwSSaZEOIFa+eVOQgXAG7iwUlb0WTAcZOaz+8Ze0w3TKjPtZwa5M6zDDh1bizj3mg6WxpsK17oxz8yzmzonGYdKlpt6niagXVfLOZWcZshoSHaGxpYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(316002)(6486002)(86362001)(508600001)(66476007)(6916009)(83380400001)(5660300002)(6512007)(44832011)(52116002)(8676002)(186003)(26005)(7416002)(1076003)(4326008)(6666004)(6506007)(54906003)(2906002)(38100700002)(38350700002)(36756003)(2616005)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sjT/0bU33JXA4aj8vgwr1dS054GdUzGwF97hokiepZTMOk3DSBhsj+bAdnQS?=
 =?us-ascii?Q?7fDbJD5KKbRET7E5+AEOJq3Cwq4HvIAXTZ5nK/JBLWmw1qqD9shF8lMhMs/p?=
 =?us-ascii?Q?mhOuFfpmghPGy8TzRV+01KbGu774Pe9zpx1k7e7W+FyKZilygOE26Gmm1Qmu?=
 =?us-ascii?Q?rz2t6oHEwTyjSDmpvRninzUL4x/Nrjf7vv3u0DlIdT/YCjv9uJcqdfNGE5G+?=
 =?us-ascii?Q?LOOcXSSyI0PAnBr08boFgiC62vGKQngJab1JDAaqDowJ/lXK0IxSA1cihfWh?=
 =?us-ascii?Q?1chClvoAB9ySWHwx/YMXq13Va3hPgpkxe5IsV0+JntXqoVuB2lx0W8cftYDp?=
 =?us-ascii?Q?SvSIMDzY8EKZCX/Re/LVIhCaAaLEMX76UO65fpAo9IxIFyb3HZHbTfjBf/5S?=
 =?us-ascii?Q?jaCVbmMFiambcVTTyVwGPR1gXSScMOmJyx2Hj++O7HrmjX78k/8+n1OFOcy2?=
 =?us-ascii?Q?2Z5er+8bhcIINSHHkXNr5Ur/qcLoErCVFVrVJQagMmiqPrKcPRO6B1bt19OK?=
 =?us-ascii?Q?RFt2nZ8+kh12GK129gLtNx4slm8mvDto1R2zLNatN0qYNcGqIIYXUFz2SuF7?=
 =?us-ascii?Q?XN92Fge+y+XQdW73evLOcY4aL2k/jVo+d28jj5PN6hcDouOWTKAAQuv/pZxf?=
 =?us-ascii?Q?Eg7bzanNdXiDNMLTtUV50HBZYLepJ8w6Ldapv/UKXdR4R1kmhwstEO1PObJy?=
 =?us-ascii?Q?I+4clAwbOeUN4HgqzvayvJYigoYvElCyMOW2CXJ4cnzl319/Llg6g35YNESW?=
 =?us-ascii?Q?e9lFbfwEPV/J9RqmyZPSqX8eWjsyd4H0whunrDvSDYspTlrokhuJo6A1kkxu?=
 =?us-ascii?Q?7uA6VhBGpoXUKuvak6PYQISp4Sf8o7/mYx1CvlvTlIhdBTvzb3lFP71Rc1yM?=
 =?us-ascii?Q?WFLrVuEelhCmPLxGh6fE0MFmOLb3bycKxdHoPdmcROovTS2SuCGypM+mm1Po?=
 =?us-ascii?Q?MM/bh7IG9LVtsRs95agEyOS1Fe011TUfkMbRI8GAu3AuaSGPdnzexBv/Xb65?=
 =?us-ascii?Q?+WCM+XLwFCozAMe/+H2Ih5iLu/x6OUpy7KNWx2DINkY6CdlBZQM+aXRfyuXW?=
 =?us-ascii?Q?AS32M65ooQqTvGOvlG+C1OZaeQ3nJdtqvIgftq4pfkZ7t3gDethJWfjdGsms?=
 =?us-ascii?Q?IsI+kTDeaTqnveA3ZiieJqNINOb++pcnlF+NHNod6scmGeD/IcXQ8zn2gCsF?=
 =?us-ascii?Q?xrWUZQA3EVNjJCnQzQEJH6TcU7ZDUoWi/dTlhesxa28QZ2RNLbz4M6YQ6qSN?=
 =?us-ascii?Q?8Jabs8im5xJIrjyqRVraEOn9pVcDNjYybIoISLla41iwtg8AGTKp4gnit0T7?=
 =?us-ascii?Q?B3MpjKZOvCXCczkysFVCE59/aACLNU7cSmWL/IMVBetiduiqlhPUkeo7Ak1Y?=
 =?us-ascii?Q?X80iHnNt+OIRZOqX09HIx1Wc1Zq5tU38g/C2Fd1EtJBbga8lDT/RTBbrZgrG?=
 =?us-ascii?Q?SjGLlzzQKHXZJLTAqygtTZvKKw9ujQLMG9W12npYyqt8cOFGO3wGIllZxYvX?=
 =?us-ascii?Q?h6zEb2NGoSEX26C08IhtKL4eJvETz6A87SnuF8BrIoGO5BPly7sH/dzEEdG4?=
 =?us-ascii?Q?VZ2GmzAQGakmDewoEVL3QeCFvNcGh5Ask7MxR6yerxKCcLZSn8Blp4RWV2jO?=
 =?us-ascii?Q?ORq7YSqZMAXtVxMgqPm4TK8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df986e7c-b870-41a0-3b9c-08d9ec137a85
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:31:05.5596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhezNZMiOBNsBOZRYv0xE1CC76HVTp+U87MzkutzK2bhhJuGpxssw15caPWBH3HFWjg7ETIs3EwdzdEqPTf0ew==
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

When a VLAN entry is added multiple times in a row to a bridge:

bridge vlan add dev br0 vid 100 self

the bridge notifies switchdev each time, even if nothing changed, which
makes driver-level accounting impossible.

Move br_switchdev_port_vlan_add() out of br_vlan_add_existing(), keep
track of exactly what br_vlan_add_existing() changed, only call
br_switchdev_port_vlan_add() afterwards and if anything changed at all,
and restore whatever br_vlan_add_existing() may have done on the error
path of br_switchdev_port_vlan_add().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_vlan.c | 68 ++++++++++++++++++++++++++++++++------------
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1402d5ca242d..c7cadc1b4f71 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -667,44 +667,56 @@ bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid)
 static int br_vlan_add_existing(struct net_bridge *br,
 				struct net_bridge_vlan_group *vg,
 				struct net_bridge_vlan *vlan,
-				u16 flags, bool *changed,
+				u16 flags, bool *brentry_created,
+				bool *flags_changed,
 				struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
-	if (err && err != -EOPNOTSUPP)
-		return err;
+	*brentry_created = false;
+	*flags_changed = false;
 
 	if (!br_vlan_is_brentry(vlan)) {
 		/* Trying to change flags of non-existent bridge vlan */
-		if (!(flags & BRIDGE_VLAN_INFO_BRENTRY)) {
-			err = -EINVAL;
-			goto err_flags;
-		}
+		if (!(flags & BRIDGE_VLAN_INFO_BRENTRY))
+			return -EINVAL;
+
 		/* It was only kept for port vlans, now make it real */
 		err = br_fdb_add_local(br, NULL, br->dev->dev_addr, vlan->vid);
 		if (err) {
 			br_err(br, "failed to insert local address into bridge forwarding table\n");
-			goto err_fdb_insert;
+			return err;
 		}
 
 		refcount_inc(&vlan->refcnt);
 		vlan->flags |= BRIDGE_VLAN_INFO_BRENTRY;
 		vg->num_vlans++;
-		*changed = true;
+		*brentry_created = true;
 		br_multicast_toggle_one_vlan(vlan, true);
 	}
 
 	if (__vlan_add_flags(vlan, flags))
-		*changed = true;
+		*flags_changed = true;
 
 	return 0;
+}
 
-err_fdb_insert:
-err_flags:
-	br_switchdev_port_vlan_del(br->dev, vlan->vid);
-	return err;
+static void br_vlan_restore_existing(struct net_bridge *br,
+				     struct net_bridge_vlan_group *vg,
+				     struct net_bridge_vlan *vlan,
+				     u16 flags, bool del_brentry,
+				     bool restore_flags)
+{
+	if (del_brentry) {
+		br_fdb_find_delete_local(br, NULL, br->dev->dev_addr, vlan->vid);
+
+		refcount_dec(&vlan->refcnt);
+		vlan->flags &= ~BRIDGE_VLAN_INFO_BRENTRY;
+		vg->num_vlans--;
+	}
+
+	if (restore_flags)
+		__vlan_add_flags(vlan, flags);
 }
 
 /* Must be protected by RTNL.
@@ -723,9 +735,29 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags, bool *changed,
 	*changed = false;
 	vg = br_vlan_group(br);
 	vlan = br_vlan_find(vg, vid);
-	if (vlan)
-		return br_vlan_add_existing(br, vg, vlan, flags, changed,
-					    extack);
+	if (vlan) {
+		bool brentry_created, flags_changed;
+		u16 old_flags = vlan->flags;
+
+		ret = br_vlan_add_existing(br, vg, vlan, flags,
+					   &brentry_created, &flags_changed,
+					   extack);
+		if (ret)
+			return ret;
+
+		*changed = brentry_created || flags_changed;
+		if (*changed) {
+			ret = br_switchdev_port_vlan_add(br->dev, vlan->vid,
+							 flags, extack);
+			if (ret && ret != -EOPNOTSUPP) {
+				br_vlan_restore_existing(br, vg, vlan, old_flags,
+							 brentry_created, flags_changed);
+				return ret;
+			}
+		}
+
+		return 0;
+	}
 
 	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
 	if (!vlan)
-- 
2.25.1

