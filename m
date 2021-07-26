Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E403D6519
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbhGZQUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:20:10 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:59207
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236125AbhGZQRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:17:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QyK96VYlKGQEiiBI+zMPtCIVM8tOpXJnWlWXQFf/R3WtyIa/X/DykJWrBqmCkXm7gEdZqhMV+Jh/pvEvDAEn0WDKhSoil26c692z64Qw5ydofEMoqyZAKJ0GQu14IkW64CAC3HxfzsvKI/co7oUPHkyV5aek1pED8sEX1801NE7JRO5rwqCpD3H/aWYNVWxWYnv9Cm0xxs0joqj//qXgO5Hd2IRftbNaLDknF6tEoVmr3ZEAr1pid3qYCFIKVnFg/k35dMNpwb8LQ6bncQx7H66piXPX405hAuFYq6rEEEJg/NqvAMMUc/KQavQaSrtUcuFJ/vYYJIAM/Q4l9SZKQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDjdqS3cL8erUstQBg+wweV0sZ76HJn25jkqRVQpIm8=;
 b=TlGOV0H4q3e/Cl9ARi7E+Mo8ZBcizm7C7ITlxSSe3K5vDpQ+HkwRWvII4aKofS83K5+TOcnGkV+PCfA60P2DQQnUL7aahfvP83ED4T8V5USYAdKNYxMTGrB2BnekDGDDRrqmZmgSKKmFZa0l872AIfx7d3XYAdouO7cQMwOjVmJ+Awu/F2JSQ9UsB8XjFDJ1P3PHIeXQvSTZAlqoIAAIxoUArDm8hgI2GwBBL6+qnqnK7HZ9X0DxOKkT/SuGIAPnTdcH+hhAQ6x31iH0ofHhihtt+E/aXSk2zt1CNwjKAXEySz9qFmjP8AeqaBKv/UBcKCWb+8xqkTDjjlPXUpewLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDjdqS3cL8erUstQBg+wweV0sZ76HJn25jkqRVQpIm8=;
 b=DAJYx+WzA4jl/b1b01n9pteiKpDIOg+tMajK8yS7WlgOhCt9M5LbdjnWY8lE+Uf52Fji4zfRW3PifvkcWhhbsXr/w7DHd9gxihc1VI0M2forZjPLGQdm8NsoM6/W9rKt9KQYn+76efRqrLu2wk+/HqN0G1/a1yS4f1oSALJbE1Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 9/9] Revert "net: dsa: Allow drivers to filter packets they can decode source port from"
Date:   Mon, 26 Jul 2021 19:55:36 +0300
Message-Id: <20210726165536.1338471-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c60dfc0a-6845-437b-db46-08d950564321
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328655B755CF48906CBA5FAE0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LR+ruoNfR1k+6I7xEx58cwwzgiy/REd/mL1l9BEnQZx73m/UUBjrLBpFtEsFEu8K0J/7a8X5XnfBQvuBbhBr/7ltdFtjxbyezidDd4wSXML9c5SyzVrAxvGnrorQSdYkgEWSgMAaqphpXiFTmf4rzdEfzsRr/NU6s4Vq8WCV4NixgxeXJhr7mvk4oZvSDhm2ugo+pRJAljrOyt3HyK4bZfYn5V/KfUz1+T+NzCkV4AN0hq7rb/7NVHvQBWrJmDqHNTEnF3rprucPzOV2OhVkFn898RZx1SFqG7FuA7sN1pIf3Lq79cH6HsrHP6E66EgZq6myZwZklLBmNxjSjCxlphg3JYr7YIQvlxsGyycLF6lgW4CBU6wNE9LhmD0xy1yQDkPhNvT0hWTQMRP5Gyj+BFYh655kMSl2Y3FZTisO9XjVIcpusNUDts8dcEMojtBOllAaAF26DWFCHfXxYoq5737naXZUbec4xyOn2RzbwPKdfGDHwc4o1DsljuMOPEsxDVWPG494kVR9om6AifGDkpuQ5GPUsVgCFwoBpkzp0qq7LZzVE7DUoyhWpMsljVsufPnjJEH2IUQp1HSjasS23xxHSwM0dTKuInsXGijwI2Xr+ZMYNmscfWshvNJgeSp5hBue8DmlgMhLmxcVQhYBxsQ/2Em0Kx9tSmgahHnheDIrRrprRh8KyG6BbQrBvwJr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hl66YYN/sOIqVzp5aeMM5WOMiX0OGycJiwCUKZTtpsPk7FkveMiXStQgWi//?=
 =?us-ascii?Q?L9MrCNTT3J+4+LyGJXMgztZgT5kZY3Q/mvKfxrNRt07uV3mVbJR/Xa1km9DB?=
 =?us-ascii?Q?yV93US+4830bayOGBXjk8A5mHgi/FN1DA/pPNniNwiwe9x9AEpdC2i2zjf5E?=
 =?us-ascii?Q?IGTpJoXUpj0F29st2gvtH3pzi8OKKZyX26XSw7NOhtmj4qoUx3cXLLxwyPz8?=
 =?us-ascii?Q?YFwWpX4aTs1nJFZhNZhEGLLXZG1wHsV8sHQvG5qHjBoEq9NaI266LDafhTqb?=
 =?us-ascii?Q?zSFqMmUARUWToUWqNYCd2d4GQjL9zV181XT3QBxZcF4FaYeNlPjMaaEyivYH?=
 =?us-ascii?Q?iZtuRSpIsOelnevnIx8w968EZGPXvd/mFQhW4dFLWyUZ70Uw3P2FwN0weLH+?=
 =?us-ascii?Q?5ScbIT5Euca+CNiCAKdyWnZGuX2J9Q+c8MPRqvMpfxlj/iw5evOt0FZ8z47/?=
 =?us-ascii?Q?DWqXLOBVCZzNNh0rGu/var8fzvw1vyxxNNlfeFtMqP4CSOGBuAV1ce2DIuHM?=
 =?us-ascii?Q?f5GG7wVrKzbBabZC0FuHANbBOq2YIGTudCv3iw8Pp/6UHWDKlDKXo/XgQH95?=
 =?us-ascii?Q?/Y4GOU0R8VGAd7nJci0mRNxfcaWrMQS5QHIUXZHAhms8T/bPGTVsfoTNwoqY?=
 =?us-ascii?Q?rgyCFaBCAc0p+VR7q4+okjv/ep41VmIpxrXxjc2665zncqx5dvtbsOz+8i+Q?=
 =?us-ascii?Q?GMxdTeuPjcioeaLiv27sg5z4nz1BGg1vsmqS916WU7EAJ+xVXfdybQBjPvcD?=
 =?us-ascii?Q?h3r22A1BT2l5pldoBun7JXa3nnhGIBxN2wV87hvz4V8AZ7paAEmw7KDXy0/g?=
 =?us-ascii?Q?nvTuyI5qjaKb0WJN7IPui2T5FsnA8P2XqlUAvEqHoTtRPmLWgclfSbPpBHGw?=
 =?us-ascii?Q?TNkNDHzabwI1Vbc6Sl4SURgOLjAs5H1bD7bFnPTSV72OxBKqvGLv1bKD+bdK?=
 =?us-ascii?Q?TZXlK7GLNABiWIzt7R7S8tRJGBGFKY1pahbhZGXYZP1qotgtE9cSLMa8Jvhq?=
 =?us-ascii?Q?TUkXHwLmDilXs0LKPUjob7+A5YSZROUgJPO4YGXrerMGUDS0fU0nGvHYVBjS?=
 =?us-ascii?Q?UWEwd9wlFIm23j+fvEJNleIxRlqfM9Qzc07iO27XJqS83JLJ7NPHZyLKgwjH?=
 =?us-ascii?Q?ErF2OZwvECq2O44Omn/GQbgQUR6jexddJeKTvOt61ctFsrj7FCH+3p+kHC2h?=
 =?us-ascii?Q?ppSLstRo2RG6OMty5O1aS1RWa0PIj1gDmXyVhuoH7RcuYWgZbbMeZng6bz38?=
 =?us-ascii?Q?llheaIN+0kvibZe11lxTUDgcF8Z1W22mIUwmafA1qDwy5obBXJW5IXu7TVph?=
 =?us-ascii?Q?Rj9zoKJXxLffyhJEi1orcowv?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60dfc0a-6845-437b-db46-08d950564321
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:07.4756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6sFGmiZ0nfuOGPZf2DGg+fkbtBRJp9cVrffy2I23IiOoT+DzZYBR0LLSJKoJ8u+bEhXL9DyEayetR1SeWmTwJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit cc1939e4b3aaf534fb2f3706820012036825731c.

Currently 2 classes of DSA drivers are able to send/receive packets
directly through the DSA master:
- drivers with DSA_TAG_PROTO_NONE
- sja1105

Now that sja1105 has gained the ability to perform traffic termination
even under the tricky case (VLAN-aware bridge), and that is much more
functional (we can perform VLAN-aware bridging with foreign interfaces),
there is no reason to keep this code in the receive path of the network
core. So delete it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 15 ---------------
 net/dsa/port.c     |  1 -
 net/ethernet/eth.c |  6 +-----
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f8eb2dc3fbef..55fcac854058 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -88,11 +88,6 @@ struct dsa_device_ops {
 			       struct packet_type *pt);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			     int *offset);
-	/* Used to determine which traffic should match the DSA filter in
-	 * eth_type_trans, and which, if any, should bypass it and be processed
-	 * as regular on the master net device.
-	 */
-	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 	unsigned int needed_headroom;
 	unsigned int needed_tailroom;
 	const char *name;
@@ -246,7 +241,6 @@ struct dsa_port {
 	struct dsa_switch_tree *dst;
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
-	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 
 	enum {
 		DSA_PORT_TYPE_UNUSED = 0,
@@ -985,15 +979,6 @@ static inline bool netdev_uses_dsa(const struct net_device *dev)
 	return false;
 }
 
-static inline bool dsa_can_decode(const struct sk_buff *skb,
-				  struct net_device *dev)
-{
-#if IS_ENABLED(CONFIG_NET_DSA)
-	return !dev->dsa_ptr->filter || dev->dsa_ptr->filter(skb, dev);
-#endif
-	return false;
-}
-
 /* All DSA tags that push the EtherType to the right (basically all except tail
  * tags, which don't break dissection) can be treated the same from the
  * perspective of the flow dissector.
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 7b9bf45a76b6..b927d94b6934 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -888,7 +888,6 @@ int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops)
 {
-	cpu_dp->filter = tag_ops->filter;
 	cpu_dp->rcv = tag_ops->rcv;
 	cpu_dp->tag_ops = tag_ops;
 }
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 9cce612e8976..171ba75b74c9 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -182,12 +182,8 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	 * at all, so we check here whether one of those tagging
 	 * variants has been configured on the receiving interface,
 	 * and if so, set skb->protocol without looking at the packet.
-	 * The DSA tagging protocol may be able to decode some but not all
-	 * traffic (for example only for management). In that case give it the
-	 * option to filter the packets from which it can decode source port
-	 * information.
 	 */
-	if (unlikely(netdev_uses_dsa(dev)) && dsa_can_decode(skb, dev))
+	if (unlikely(netdev_uses_dsa(dev)))
 		return htons(ETH_P_XDSA);
 
 	if (likely(eth_proto_is_802_3(eth->h_proto)))
-- 
2.25.1

