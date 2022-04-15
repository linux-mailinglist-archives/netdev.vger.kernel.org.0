Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BDC502D48
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355599AbiDOPtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355594AbiDOPtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:49:06 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EC95BE5D
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hG9oV9BvudClblpi2YPDFxLj4brrM0OTAUf1HMZhcyOak5l3H8Rt2S4YU2pNqX63Z9RKm4HWLWLnL6A4elIC/t7nr7DXvWgM8/yZmDDyLGYBbA0CLBxvTBuY/xnSHj8dw6PahOx64tX3VgRninfz4EWib4cnlnCl/xFqEnxpZZPjQEFWiESDj/Cz3avMaHJf4PYY/mH0PEF93mpjP8WOoYPj/LEoYrB3MGa6e2QuC1NHYw8s1wH2mKCUzjukEe7LkSjTLxXI2pRH0p8Ql7z4h5i0i2/my+/yhtx5NPSH0onyH9RLyuGvd/oMrP6Y8gEnm1gzLr9xb9HaHSJGNyKE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BY97yS9CWPs7D2XdtiGDJnITVBj7UuigHKT0dCPYChI=;
 b=AXHF4Z7J6td6xOPzMBcB8xGloqTY30o+sj8WkO21VugHUEItllFqaHfHgobOSAhbgitJMNJbIWC9IelUhyVGZbd/YEukX+RoVPwtwaI4R1NCAVxaARSOqXsXtvDsNerF2M9fyzYzKow58W4cEBS1ssjcas69SuBOvP5Ts4vugXZZ2tc7zhbBlBpQqUsTpXlKzafHvJVp+ZoDIr/E/XPEL0XVzpzIW4P5c5Cd9EWRMnqxSwi/ljzzblPjbCiPDadKdtPE7JsofGfMms39hcA7y381c+CSiq9GwaIPjS21j8DArrCbOMYaop41BRcb7DOqy00xl2biIgoo3OCUkrOkzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BY97yS9CWPs7D2XdtiGDJnITVBj7UuigHKT0dCPYChI=;
 b=JmJ0ar8nCqF2Q66+ZVO6FztPvWw0uyt7jb0/kPfM9IleDQQOPOILMxH/KUZ3rGWbTbHNfD20LgOGk5uz+28CV4nGtG2RH9oGeoI2GYCQz5wa01wBZecKl/ybBuR+tOuw0lU6cixigTEXBLPH5olg8U5FWzYKr44DfqVgknrWlW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7715.eurprd04.prod.outlook.com (2603:10a6:20b:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:46:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:46:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/6] net: dsa: move reset of VLAN filtering to dsa_port_switchdev_unsync_attrs
Date:   Fri, 15 Apr 2022 18:46:21 +0300
Message-Id: <20220415154626.345767-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415154626.345767-1-vladimir.oltean@nxp.com>
References: <20220415154626.345767-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6714d654-6cce-498b-9e59-08da1ef71f13
X-MS-TrafficTypeDiagnostic: AM9PR04MB7715:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB771552045C51C6770EA67220E0EE9@AM9PR04MB7715.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RtZNHpSzfj9+uQSgRufvqx+nEJYrZNwU5mY7l0wPUmPxeydHlIGfHp341fXlfG7vfyL1151DuVejuxk/9UyigPEp/0X6L3Niv2aSogBKRhwjE69hu/R31zx4bcjYUb428xq8XoEhzDKwYHhv0wVLFOKQNa8tEdVre8W/jYoAOVAFROJ567XOItScHNOM4AliEfXIitpb9h1oBGRAT6+CyUOanME9mhtsNvQdthSp0iDtkZQLnfYQut5o/KsU0zHXHXqitKPjd8Ul3NowQvHHgbcs7OE/BGdaD4jiNLolFTEK5yq1hlOvUcfI6BD0OWDW3PpP14FwraSXMjdnH0wm6h8GwXheDJGRLLiWOEKDLginLb0SzX30P1hZvi4KthLCIaNuTM7wmGizhY8XJrdNiQg5iHiRH7yeJ8uttpWybcq2EUjywjeC8ibVJkh956UZrhA5SfIsFeNxIJOK/SH7gHWyfGL7T/AquhJ9vOny/Nr3BaZsZqQcDJbkvjPWDSJXwkMo0Bv4taMGBfPN0cXj0xcc0jBj9rS6NJXkGQcxaEU8L0gjgcfhIZdzA1fmPccp185fjXI47cnIBsjbjUSLgdkrmB36ce2/X/SMFlsi92lhp/u5GUxKwMZ5igeWJyiN0Jtv1A4ErDtKR82EQWio1joPNlmYxWtrsLiMhfgZDSCja9P5htZ0YZCEJ8lkKJKcWBRBxy7yifd42ymLV26icA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(36756003)(38100700002)(54906003)(6916009)(8936002)(38350700002)(316002)(86362001)(26005)(6486002)(2616005)(1076003)(66946007)(66556008)(66476007)(8676002)(4326008)(6512007)(6666004)(83380400001)(2906002)(186003)(52116002)(6506007)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37aIX63cleac8cGgUjOIM1ZELjsDx5E0HrwbvUTVmCPGpLmS0HtE+9oQcVCd?=
 =?us-ascii?Q?J745Jhe5sTv04OfvlzPJptZ1w8KRYNvO0gJnP9j8bzSGnQQK49awnsCHegND?=
 =?us-ascii?Q?/PKU8mdVLevRnJyUey9JpnpiQYZPJJA9Ep/lMPHI+GFCHu5F9XJbypu0Czd1?=
 =?us-ascii?Q?9bWbYbtOzW2qWPuaBsYT1DWI8oUiZn2FhMQAcTWFH5fE7hxaSspRuCpW2tXE?=
 =?us-ascii?Q?D0Dl2wqF3PnSOak+jNUleN9KChyL8XVlI61HgFsaDmjUVw1hzvIjPiHNGYuP?=
 =?us-ascii?Q?LehKBgbCAxiPFlAD7jEQR2bm1ku/hASYCeA0wtdIahWfdurWhYR3AaLEqQXX?=
 =?us-ascii?Q?TcPlElg+1Nq+V3r+6XrNZqgdU9zOOF+veHUsxovTsqZg2yHF8zPl5dqY37uP?=
 =?us-ascii?Q?tDZhunb9i0fVu1VVV+rL05rM6AipyOVQb6ehW/Mc/vQUmIzozi/cxKEdUeus?=
 =?us-ascii?Q?f6Mqfhio4T7J0RowvNypH7rPlNexq5go1q/R9+HqdrgcBTx3+OcU12cqCup4?=
 =?us-ascii?Q?ec5a+CwglILlW//UIMlAo8u/uvqU5vkCKuvCXNl2FvMhEdCi0u46f8UhVEOi?=
 =?us-ascii?Q?K6rUwuIl9jM55owDsNkiGnwqvatXA8kfpkaddb9/iZTsN1a82VIq2VBglLFq?=
 =?us-ascii?Q?8O65luPO5h6LbEzKHligXqicULLcAZv5v9utI0OBo1YstWAY0ckG7P0CHnU6?=
 =?us-ascii?Q?hiEAQUShYjLK0OrYCD9x7hQovU+lAQY32sF+7GGmUm00MspRZgFYLf0wUHGM?=
 =?us-ascii?Q?ZdXs/wzbYofkSZ+9dE8DI4U44I9LlTdjlTx4NA5E6cX6FpbhUKfP0xk7/53w?=
 =?us-ascii?Q?k2l7MhItdlk17qu5JqaQ+PexSmEYR5oTdzd6lG/ZA49WXXlKum7jqSDSP/XV?=
 =?us-ascii?Q?HRdRTbGPJQsy66/1ZYHjRuqN3npgDgqrkox7pxA6iKs2IZRcFvVviNBH3OZ2?=
 =?us-ascii?Q?+d4nGn0ISk3YwgLBZRGJ7C+RXJDpUPiYWi4ED2lVKHfBCkPxZcc9LoVbAfNv?=
 =?us-ascii?Q?bX0JZvjUiWvO7rJ/++vM/m3+nK0PYFiaeBp+UUBV9Ig3qy1JHSD+FYOvv2Md?=
 =?us-ascii?Q?pCOgor0yVQLfKpgCMSGkX3NMNFbvPpDmqWpzxbpgrB130k3KgHSdcVZUlfkf?=
 =?us-ascii?Q?qDEKCT58a99ZVWF5WCi7EqlxHvNXcs/9VEnFxE9ZgVweZkOBuwrrtChO1y6O?=
 =?us-ascii?Q?iFhvLTeKbEqXbZQDvD9Zgzz1oN5VS1XGMfLbm8NfR2+ZTT0eRNDYX6H1T3jv?=
 =?us-ascii?Q?AixtWXZPTdY8p093upbFMZLRIrP1eVspCeHM52c6KUyV78VNKcUfKmA1OyOx?=
 =?us-ascii?Q?RVJDNRUTQw47FEolLu06Rmxe321xDHBIsG+AB8jyQfneuuF3tsuMnoqSg1Fn?=
 =?us-ascii?Q?DcvtsB7mhe44rJuVQ7hCVqid/6CnyMdqZlMJtQEeZn0qeM6LbQneaVIECAl1?=
 =?us-ascii?Q?Puv7NSlJU1nKOsgQVVzkEIER1o6c1We4buwv9zMw3p9/6aEzD+BPuZkm3Wb7?=
 =?us-ascii?Q?M5plg53jg9hCJU+k7hceaHcD7UB+/REBztG6vFoHu+stQ9PNoeLHxdujIycY?=
 =?us-ascii?Q?z/FkFjLQLQpqIURVQExgVHyK9Fw7dD2OSVgQpYOa6u+jRj14FNFfFFYlrbsF?=
 =?us-ascii?Q?zo1RbE/o0oxIUoaRsvJGPskULPWtgNJ3F83avX/BYreK6goELiFplZWN1J9l?=
 =?us-ascii?Q?/cfv+OyzXSsy1HGKNVf1XQ55DYxxbcKBUEtbs5AU2sp+ukvK7XiJTKoFxHwq?=
 =?us-ascii?Q?uXCYtLEOsNtB69k4WeYHc1EK9kH00uA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6714d654-6cce-498b-9e59-08da1ef71f13
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:46:35.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8SiJGq0HdQ6kxB6Qmd0P2yaZt279yEkzGx1GiM4DtvDXVh+lYT1kAQpyEeQsjy5ZXik3Af3E2Zskfqq+675MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7715
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dsa_port_switchdev_unsync_attrs() there is a comment that resetting
the VLAN filtering isn't done where it is expected. And since commit
108dc8741c20 ("net: dsa: Avoid cross-chip syncing of VLAN filtering"),
there is no reason to handle this in switch.c either.

Therefore, move the logic to port.c, and adapt it slightly to the data
structures and naming conventions from there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c   | 60 +++++++++++++++++++++++++++++++++++++++++++++---
 net/dsa/switch.c | 58 ----------------------------------------------
 2 files changed, 57 insertions(+), 61 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 32d472a82241..af9a815c2639 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -242,6 +242,59 @@ void dsa_port_disable(struct dsa_port *dp)
 	rtnl_unlock();
 }
 
+static void dsa_port_reset_vlan_filtering(struct dsa_port *dp,
+					  struct dsa_bridge bridge)
+{
+	struct netlink_ext_ack extack = {0};
+	bool change_vlan_filtering = false;
+	struct dsa_switch *ds = dp->ds;
+	bool vlan_filtering;
+	int err;
+
+	if (ds->needs_standalone_vlan_filtering &&
+	    !br_vlan_enabled(bridge.dev)) {
+		change_vlan_filtering = true;
+		vlan_filtering = true;
+	} else if (!ds->needs_standalone_vlan_filtering &&
+		   br_vlan_enabled(bridge.dev)) {
+		change_vlan_filtering = true;
+		vlan_filtering = false;
+	}
+
+	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
+	 * event for changing vlan_filtering setting upon slave ports leaving
+	 * it. That is a good thing, because that lets us handle it and also
+	 * handle the case where the switch's vlan_filtering setting is global
+	 * (not per port). When that happens, the correct moment to trigger the
+	 * vlan_filtering callback is only when the last port leaves the last
+	 * VLAN-aware bridge.
+	 */
+	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
+		dsa_switch_for_each_port(dp, ds) {
+			struct net_device *br = dsa_port_bridge_dev_get(dp);
+
+			if (br && br_vlan_enabled(br)) {
+				change_vlan_filtering = false;
+				break;
+			}
+		}
+	}
+
+	if (!change_vlan_filtering)
+		return;
+
+	err = dsa_port_vlan_filtering(dp, vlan_filtering, &extack);
+	if (extack._msg) {
+		dev_err(ds->dev, "port %d: %s\n", dp->index,
+			extack._msg);
+	}
+	if (err && err != -EOPNOTSUPP) {
+		dev_err(ds->dev,
+			"port %d failed to reset VLAN filtering to %d: %pe\n",
+		       dp->index, vlan_filtering, ERR_PTR(err));
+	}
+}
+
 static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
@@ -313,7 +366,8 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
 	return 0;
 }
 
-static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
+static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp,
+					    struct dsa_bridge bridge)
 {
 	/* Configure the port for standalone mode (no address learning,
 	 * flood everything).
@@ -333,7 +387,7 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING, true);
 
-	/* VLAN filtering is handled by dsa_switch_bridge_leave */
+	dsa_port_reset_vlan_filtering(dp, bridge);
 
 	/* Ageing time may be global to the switch chip, so don't change it
 	 * here because we have no good reason (or value) to change it to.
@@ -501,7 +555,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 			"port %d failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
 
-	dsa_port_switchdev_unsync_attrs(dp);
+	dsa_port_switchdev_unsync_attrs(dp, info.bridge);
 }
 
 int dsa_port_lag_change(struct dsa_port *dp,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d25cd1da3eb3..d8a80cf9742c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -115,62 +115,10 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	return 0;
 }
 
-static int dsa_switch_sync_vlan_filtering(struct dsa_switch *ds,
-					  struct dsa_notifier_bridge_info *info)
-{
-	struct netlink_ext_ack extack = {0};
-	bool change_vlan_filtering = false;
-	bool vlan_filtering;
-	struct dsa_port *dp;
-	int err;
-
-	if (ds->needs_standalone_vlan_filtering &&
-	    !br_vlan_enabled(info->bridge.dev)) {
-		change_vlan_filtering = true;
-		vlan_filtering = true;
-	} else if (!ds->needs_standalone_vlan_filtering &&
-		   br_vlan_enabled(info->bridge.dev)) {
-		change_vlan_filtering = true;
-		vlan_filtering = false;
-	}
-
-	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
-	 * event for changing vlan_filtering setting upon slave ports leaving
-	 * it. That is a good thing, because that lets us handle it and also
-	 * handle the case where the switch's vlan_filtering setting is global
-	 * (not per port). When that happens, the correct moment to trigger the
-	 * vlan_filtering callback is only when the last port leaves the last
-	 * VLAN-aware bridge.
-	 */
-	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
-		dsa_switch_for_each_port(dp, ds) {
-			struct net_device *br = dsa_port_bridge_dev_get(dp);
-
-			if (br && br_vlan_enabled(br)) {
-				change_vlan_filtering = false;
-				break;
-			}
-		}
-	}
-
-	if (change_vlan_filtering) {
-		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      vlan_filtering, &extack);
-		if (extack._msg)
-			dev_err(ds->dev, "port %d: %s\n", info->port,
-				extack._msg);
-		if (err && err != -EOPNOTSUPP)
-			return err;
-	}
-
-	return 0;
-}
-
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 				   struct dsa_notifier_bridge_info *info)
 {
 	struct dsa_switch_tree *dst = ds->dst;
-	int err;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_leave)
@@ -182,12 +130,6 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->bridge);
 
-	if (ds->dst->index == info->tree_index && ds->index == info->sw_index) {
-		err = dsa_switch_sync_vlan_filtering(ds, info);
-		if (err)
-			return err;
-	}
-
 	return 0;
 }
 
-- 
2.25.1

