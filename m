Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD033D141D
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbhGUPpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:45:23 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:1893
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233767AbhGUPpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:45:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKh85u4zwWvt3LYhXOpTv2oKbR535Euz2sKvF+MTGWpMzI7Ry/qDnrytAvpDBFK2Caj4RMpFvswKOCrkXtIN5MLxufxe04Ujgh6QHC1YxnJ+nD/XKOdzzAFsfzBDdbPPDwLOyugurHcD0+lauUZASOBG3zWZrJR6+fWbFiK+Ia0chXpnEp7yA/jgY0pgbevMZMPgNlVbehwBUMfCIZVLJl3uespZNlEvr1IuY+o5EuzBmrZ02MIW4gy6v2XCzbOxK66085vqhoWNyQqXXaqwYqUboF9sLGOhOy+vk9BwA21qXX+GLzLgfNkBXyDqEC402pCGQS80F0JQ6+i2lu89eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gEeKoYi4nqB+kTAdrjxJv+8gIPi54MqfqALyhtjMtY=;
 b=TCJXJgiVkvb6tTpWYm5ujiNxi/pEOF3TmT6aUFv/5l0F3+K5WZXlFGVj1zSsKyMnjiIsDh+Iwiyt6X2q7Y/hn0qYpPMEPfaNVncn3H1nUFYL/soJm6O5vyF+yG6h+uzhcj1giWotNrUDoDCrOWZJnCKznhMhIC3U5i0Y66/MeWq31EBmCA9lXTLCLtqSnVdthGVakF7AWu0tnF7lE4UkMvVFjGbMoBktUKri+oBGlccORS3Rjs0imMXVe71KisZVSbHDIWJGJnbv3fUEgJCEI1N3CVe28MoV4WmTnr0wUFfguV51VGTTdp0fza1whI6ksBuImClx9AmsEqrR1J37Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gEeKoYi4nqB+kTAdrjxJv+8gIPi54MqfqALyhtjMtY=;
 b=Vx/k5CzfRaawgNyJFrDbFisqbVF4E4zUWcMGkqAcmKowWUeWuQ4a4O3ovaskRQA+0aK7ACIRLETsORndrCM1Nkqv556/bWFBl4McN6d3YiNy1Pv/LcsdJOtcPocoFGnG/eA9BOehecObz5fSgl+Uy5NBNyQt07+rYn3fs1iQhH0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:25:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 16:25:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v6 net-next 3/7] net: bridge: disambiguate offload_fwd_mark
Date:   Wed, 21 Jul 2021 19:23:59 +0300
Message-Id: <20210721162403.1988814-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 16:25:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeddc0f0-3db7-4e4b-ab27-08d94c642346
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7343C7E8CF14FC16BFE63FE5E0E39@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LUX03Ml1WCqj2Bs2vKJQY5Lg+s4P0iWzAJPvqCo+wMbx2i7x08/mc2IrOPzyxjvJdaHhvtRqPuYS3jHwqSF8GIoAtJUqbjJYCSWYFYXpEUlfnMOq9tSAtNxzJ4rtytO5EWUJ81uzMfuMcRZvussY3//hjGSQQgvN/U+sYcdFJIqwWzhEB2eT681kOb3bmEdUHzOI+hdn4bid1SMl1PuuYiVthCqp39tyvNHuShL21fGWwZfeVzVDs5mlGJ6Lk84KS+hZjnZaJ53bthZnzk/YoNfNdCdo7ikxB2dtdmDvIYvCqoCE/YR7ykkGrtq+CumVqMW8o8Skx05XI06lp6O1PNH8uegRJm6+FRYLbVunyUIpXWGAfK9Y1MknBFFmSXQjGssBeuqRQVJtE2W6nHYj0po3FYX8JMh9RYW5eqmTnSZbmBDQ/60D9BVZSSh4hAFsion6dErVBXCajdtuewMuK0jXOrVM/diR4AgJf+oeq67AqrTgzjlAkv1CFd1GUS4D0A0EbKxsSfrBVVxgv85FX/BTpeliktLQ1FgfDebfaRfNlorRqggNJ5o4ZnbSjr99BeZZ4WzYm01jL8Y/dTh0ZiJd+3vj2Ad+oDHJROdhwzxQfTyUOreM844zTi90tNUTJirLV1tXXxCOLtHTgZ/3HSpRRTYnVOKLLQj+jiNsM3fJFLvJlh15oyvkZsHKAi7F08zwS7BzVODobHMDr3ubKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(186003)(110136005)(956004)(4326008)(44832011)(316002)(2616005)(54906003)(8676002)(8936002)(478600001)(83380400001)(36756003)(7416002)(2906002)(6486002)(6512007)(52116002)(1076003)(5660300002)(66946007)(66476007)(6666004)(38100700002)(6506007)(66556008)(38350700002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pgarb975i3IDAPYGmuL0OqMuD0VMOewIrApBaXDylWba6r/7nQTZgnSCsj58?=
 =?us-ascii?Q?X4N6O66egOHkCpCKxD8x7rRJvdto2IbY4Hc9MsOLHtkqFhL+NzTqrQLcNPne?=
 =?us-ascii?Q?tlfupBBn3hhALb5J3mcfz4owbIbRO90jDUHtAmgi5Nwm5F1xqe28ms/hQPcG?=
 =?us-ascii?Q?RjB03MEVR7zegikYFjnKPrieot1Aed3zr1FjSAG39ud5rJRAv9u//eZVFMzr?=
 =?us-ascii?Q?eKBB3/AYtYLsKPoEP1rzEDFmOyeB0x7A6MrgW2uIZobkr/qgQ28P3gqcvu0l?=
 =?us-ascii?Q?0QeMwSdPEUIrUGzSBZU3aBUQLA2ef1l5T5sZhAIjElkk6T8RaEZHVycaPnEl?=
 =?us-ascii?Q?IaIJws15DyddpoVHFBmd2Ssdy4TfAetJ0WrKTgDDQEF4cvFFp4LG+opG65Bk?=
 =?us-ascii?Q?RocyAnQx6e6BY3zJsMWqahciQ+lzOPd5fQracZX4uJ331z9JA2TJiBvUqmYO?=
 =?us-ascii?Q?STCOPrkczBBCEuGAcJlEq38pUWlPxRWeBe0tV8UdNAsKQyyfFXcHjHPXOI2m?=
 =?us-ascii?Q?NN/to5bZ9gUN3u7YcGfdMpHdIi0m7/MkzdExms7VGbgkI2jJI8j6X3APtc3G?=
 =?us-ascii?Q?BYQUfUpc02+aRbcVIK082n5A3aHsBZADaRamlONhCssW3my1qvY+1tmBTPJf?=
 =?us-ascii?Q?HAl864FxTPl93IaWd0OyYO+SWdnxcazB+o+I2kH3bOrjjs0dWXngsoN3Y7kJ?=
 =?us-ascii?Q?NSlu4n6uhkazYYbI9MtAeWpnopITE4cFaOyBV7DQR9Rk1MGBDdyQpxsB4jJI?=
 =?us-ascii?Q?bmHDz2tWDXR1g0DWch6HDTP/wwXZVwUs3DNNkdTiWbp/Srb6FdaGuhXs1yd6?=
 =?us-ascii?Q?PVztFepEgRbBY2axZ1M+G/PtWmGc8iNKjuy2nFCrvFhdLz+EYTdm4TmhRzok?=
 =?us-ascii?Q?+0Jk1XsG6y63kzw0TjoAXilLn2ZNYJ68YDt8OYzPXLQwI/8THKUcZxlSE2ze?=
 =?us-ascii?Q?IT97lnnT1Xxz9xBME1T+XOB2JCXF8cpct/SAXI4YJdZMhHsL0LL+PEYCaUBD?=
 =?us-ascii?Q?N/PAmJzQxvY3CojwaaCoD47cvasCNC+3RcUB6un6OKJM18ErVb+RIFG2E7Dc?=
 =?us-ascii?Q?G92zbYKBnRCW1gmYj3jxvZNra+EFygdwO69n5TbwFCJEQZWyOwDyoFM4mFYq?=
 =?us-ascii?Q?PN45mkUra/jadjUomozofjq3OhcTbSokUGiVhXBVVgLOdcTdYy8GOu5PfQ8w?=
 =?us-ascii?Q?86lE321+CghDFNCbapxs6D6/ijK+H+XKlXLImLnXqJ0ve1iInEfvC903pAEg?=
 =?us-ascii?Q?Fc6Nt2PiW7TNAWovcm2389rT6Ri9JQyap6fWfNe7Wtj5kqLUcWcgAYSSPO7H?=
 =?us-ascii?Q?TfphC+1MprZooMTRqrjgx76R?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeddc0f0-3db7-4e4b-ab27-08d94c642346
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:25:22.3179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUSFzrNafkPmH9NJgxGuV2pb8hwruaSgDNI5Crw/OHgiBEZbeQ6dM85HWPHnFB4HWGbLtFTbQNtADlOPZ2RhxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Before this change, four related - but distinct - concepts where named
offload_fwd_mark:

- skb->offload_fwd_mark: Set by the switchdev driver if the underlying
  hardware has already forwarded this frame to the other ports in the
  same hardware domain.

- nbp->offload_fwd_mark: An idetifier used to group ports that share
  the same hardware forwarding domain.

- br->offload_fwd_mark: Counter used to make sure that unique IDs are
  used in cases where a bridge contains ports from multiple hardware
  domains.

- skb->cb->offload_fwd_mark: The hardware domain on which the frame
  ingressed and was forwarded.

Introduce the term "hardware forwarding domain" ("hwdom") in the
bridge to denote a set of ports with the following property:

    If an skb with skb->offload_fwd_mark set, is received on a port
    belonging to hwdom N, that frame has already been forwarded to all
    other ports in hwdom N.

By decoupling the name from "offload_fwd_mark", we can extend the
term's definition in the future - e.g. to add constraints that
describe expected egress behavior - without overloading the meaning of
"offload_fwd_mark".

- nbp->offload_fwd_mark thus becomes nbp->hwdom.

- br->offload_fwd_mark becomes br->last_hwdom.

- skb->cb->offload_fwd_mark becomes skb->cb->src_hwdom. The slight
  change in naming here mandates a slight change in behavior of the
  nbp_switchdev_frame_mark() function. Previously, it only set this
  value in skb->cb for packets with skb->offload_fwd_mark true (ones
  which were forwarded in hardware). Whereas now we always track the
  incoming hwdom for all packets coming from a switchdev (even for the
  packets which weren't forwarded in hardware, such as STP BPDUs, IGMP
  reports etc). As all uses of skb->cb->offload_fwd_mark were already
  gated behind checks of skb->offload_fwd_mark, this will not introduce
  any functional change, but it paves the way for future changes where
  the ingressing hwdom must be known for frames coming from a switchdev
  regardless of whether they were forwarded in hardware or not
  (basically, if the skb comes from a switchdev, skb->cb->src_hwdom now
  always tracks which one).

  A typical example where this is relevant: the switchdev has a fixed
  configuration to trap STP BPDUs, but STP is not running on the bridge
  and the group_fwd_mask allows them to be forwarded. Say we have this
  setup:

        br0
       / | \
      /  |  \
  swp0 swp1 swp2

  A BPDU comes in on swp0 and is trapped to the CPU; the driver does not
  set skb->offload_fwd_mark. The bridge determines that the frame should
  be forwarded to swp{1,2}. It is imperative that forward offloading is
  _not_ allowed in this case, as the source hwdom is already "poisoned".

  Recording the source hwdom allows this case to be handled properly.

v2->v3: added code comments
v3->v6: none

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/bridge/br_if.c        |  2 +-
 net/bridge/br_private.h   | 21 ++++++++++++++++-----
 net/bridge/br_switchdev.c | 16 ++++++++--------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 6e4a32354a13..838a277e3cf7 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -643,7 +643,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err5;
 
-	err = nbp_switchdev_mark_set(p);
+	err = nbp_switchdev_hwdom_set(p);
 	if (err)
 		goto err6;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4681a4b6020f..4afba7da17ae 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -386,7 +386,10 @@ struct net_bridge_port {
 	struct netpoll			*np;
 #endif
 #ifdef CONFIG_NET_SWITCHDEV
-	int				offload_fwd_mark;
+	/* Identifier used to group ports that share the same switchdev
+	 * hardware domain.
+	 */
+	int				hwdom;
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
@@ -510,7 +513,10 @@ struct net_bridge {
 	u32				auto_cnt;
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	/* Counter used to make sure that hardware domains get unique
+	 * identifiers in case a bridge spans multiple switchdev instances.
+	 */
+	int				last_hwdom;
 #endif
 	struct hlist_head		fdb_list;
 
@@ -540,7 +546,12 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
-	int offload_fwd_mark;
+	/* The switchdev hardware domain from which this packet was received.
+	 * If skb->offload_fwd_mark was set, then this packet was already
+	 * forwarded by hardware to the other ports in the source hardware
+	 * domain, otherwise it wasn't.
+	 */
+	int src_hwdom;
 #endif
 };
 
@@ -1828,7 +1839,7 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_mark_set(struct net_bridge_port *p);
+int nbp_switchdev_hwdom_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1848,7 +1859,7 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
-static inline int nbp_switchdev_mark_set(struct net_bridge_port *p)
+static inline int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
 {
 	return 0;
 }
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index d3adee0f91f9..833fd30482c2 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,20 +8,20 @@
 
 #include "br_private.h"
 
-static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
+static int br_switchdev_hwdom_get(struct net_bridge *br, struct net_device *dev)
 {
 	struct net_bridge_port *p;
 
 	/* dev is yet to be added to the port list. */
 	list_for_each_entry(p, &br->port_list, list) {
 		if (netdev_port_same_parent_id(dev, p->dev))
-			return p->offload_fwd_mark;
+			return p->hwdom;
 	}
 
-	return ++br->offload_fwd_mark;
+	return ++br->last_hwdom;
 }
 
-int nbp_switchdev_mark_set(struct net_bridge_port *p)
+int nbp_switchdev_hwdom_set(struct net_bridge_port *p)
 {
 	struct netdev_phys_item_id ppid = { };
 	int err;
@@ -35,7 +35,7 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 		return err;
 	}
 
-	p->offload_fwd_mark = br_switchdev_mark_get(p->br, p->dev);
+	p->hwdom = br_switchdev_hwdom_get(p->br, p->dev);
 
 	return 0;
 }
@@ -43,15 +43,15 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
-	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
-		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
+	if (p->hwdom)
+		BR_INPUT_SKB_CB(skb)->src_hwdom = p->hwdom;
 }
 
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb)
 {
 	return !skb->offload_fwd_mark ||
-	       BR_INPUT_SKB_CB(skb)->offload_fwd_mark != p->offload_fwd_mark;
+	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
 }
 
 /* Flags that can be offloaded to hardware */
-- 
2.25.1

