Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F006E9F7B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjDTW4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjDTW4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:22 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C365B9E;
        Thu, 20 Apr 2023 15:56:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOukXD9Rq4D0smXqitOpZ3WIOLEbT3imCAR2EPC9/f+qK1SbliICWOcVe7d3YuPtp4AzRMSzEsHhiQdIZgXNhXyNM9HKevvTpvQCVNeCVw/SWnoO/gHtiqHWg2NyZBsztLncLjGTtCegHoPvZcAE3ScEjlCxoDFu7q0Yf5nd6/p0qa9eJHr6S5c/m2JY7ovngquRcq3DViZucAS+ee3M2vF3CUaPaqWqn1H7Hj8iz/kZWVWw0LM++HXBdUTQ7zZJ5a265sxfu/lYCmlbxgWK8KZTEfK5R6Slll5P1GwPXl3hfWE5ywe1BWMUfMJtT0sKylrOJzSzaQuhkl2wnlSkFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VRDp1sATinR1AEbcXAXCgTevcVxBGIbhFvYTt7Teq4=;
 b=VgGMFN1YDV7YbwrQylZ8p/bfsjpaxvuBwOzU9meJ8edr4anDGLduQr0dh7lnB6qKmuBYfSqsbPlV4Absd7rGJeRX0TyLFr5c6634D0EBIsU+/7SZXKuoqBwqxuZrKqS3+WAv5Hdgu5BYcqKQwaAeroBS98/IPuW3pANmIvvYbvQj+Ig0UaowSbXL+xwPBFu7JnyELKscnAUfT7fxOZWlM+lmo0Lh9HtkljbqVQuvcyimBmpRpnqYit4akCMiS+8V9H9CxtpXqEB38HWeupiPH5+vS+0AtBxM66n1NFn594k3pm8F3WNbMsxy0jQvMmiLh0jUwCzWMCP6oU4sX3hCUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VRDp1sATinR1AEbcXAXCgTevcVxBGIbhFvYTt7Teq4=;
 b=JaQJ0hiaZQG4xz8ZAc9vOBOMKiPgwZfnGbiOhUhAJD7yVir4w+o4+/fHUuwL6ISfUYZDuropqeKuGHx7L/njlWx2Idb+QJcj2H/4lxGriianjAaYW8CxDu2Q1HP6b/cZ/dN0mtoq/w1dNCgN5UEkg3gxn7zXLdTJFAswJnWGIVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:16 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 5/9] net: dsa: tag_ksz: do not rely on skb_mac_header() in TX paths
Date:   Fri, 21 Apr 2023 01:55:57 +0300
Message-Id: <20230420225601.2358327-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
References: <20230420225601.2358327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0088.eurprd03.prod.outlook.com
 (2603:10a6:208:69::29) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GV1PR04MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: 96dde338-b4f8-4fd5-3d78-08db41f27244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZTOdUCalSqlbB4iWQBxKDdywmjFWiq92RscyvyWoV9zh4oRS8323x+EvYRSWxTpKIiuTdiAl5RpnCMR6/1IOwY+Fa+ClNvivjovd/F/DvszmdSKGPOCwwgshFqQtFCYYt2N93VwQQY+3QRlhjyBk+qTwVVZnt2ieE3W19ACZz86XPZxiBJ4bL76ScmwUjs0vTcDnAwMT1EgjeYxAvu5V3FbLD3FOiXS/1bReRgmFZEDlDFvD3lerWX2zUHkXBd8ZhJIcK9MJr9k7z4gl6gQC+qMiFvebfq9R7QJCsl9YFz5MtxeSSAcNjKIYZO7Y+yWd0+kzdujXkElhoWayBF+X2G05HJVMhREM6HVEhy61iPvStP2M99nwKhpfDnbnP6cp0e91tmS0IL9gD43HwuYzW5vunErfAWeO6cz5S6SJaaVVdl7V0Ussge/kyXjaXnpMcOa4vOYD9TYioVpgM/9scM/NOxMYHaJ7NnXYz2ILvOfC8zQ+n/h4KjJg6TWZGi2kJkNcJKg2sVfgpfjGBEiam3IuBPAhDqBcIkbhwMWlajdAD0x3jLD5hKu+u2K2i6JktmQ+MjiVOaRFRTcenU8Ik+dRGt8iVuQSVwlMwXsM7AduX7ODjfJGen3WR6w4Q3F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(38350700002)(38100700002)(86362001)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H1rJMhvxAZm9EEfs0UPy2PhbsHzT0iAr3+lwWO2F109m3mnvP+fi4hTzATwU?=
 =?us-ascii?Q?daa6eZmTGgFZhJsZF2dHJTMah2mWDUeOKm+HxIhL91hvfYd7LpiG0ruXkjgP?=
 =?us-ascii?Q?0SdY0SlGfJ0j2DpRmtDeoHU6DPrk8iet6j2zlFhqij4UMKl4VMf+hbZHtgq3?=
 =?us-ascii?Q?eSwEUTuI3uTv2dt2cV3qth9I6Lsv9g7s8P4aDqgys561rChJQEMEBXL0ydhJ?=
 =?us-ascii?Q?jiAWWhC69GE/JMkAllN0OSa+mymwMLCxA4PU4xIsiYcFjWwPwaFO4qcACPOH?=
 =?us-ascii?Q?RfBmuYIfYKNuvm1zqlYoo4NRl3181WKHTX3gmxW0gMRQpy4EMK6NWYg8xSWX?=
 =?us-ascii?Q?DSxvOG9Qn6nhWvF/pmYugKpdXR+UKxmcrsO7WHteyEXbeuwDDwF2EUIB9dy+?=
 =?us-ascii?Q?m/7VfbY5c6YWNbgAhR5kAeV/of8YwIktxbIMfKvJawRfVQjmxHLgDXD64E0f?=
 =?us-ascii?Q?Zar3BCwo2a/D9xqSZcuGtLrOld2IPit/6sIMFu1r7y3zWb3HqWqHMrwj4ZF0?=
 =?us-ascii?Q?gfOW57GU/NadYhG0Th95tUFeCx0YHh90E4I5ARLFVAdM7xGDvc9NqwKUDTrJ?=
 =?us-ascii?Q?mT7N/lZJwKk9iVoj6s4BJ/Jl1mMPwlgorgH+3gJOnl9WGPI2TDSWdfG97Y84?=
 =?us-ascii?Q?xp96ZbolvS1aXEYJlyy/ETKPexFdGPYU+jD6esG4vuSe8XIq2I7lHormNq3z?=
 =?us-ascii?Q?+yYxYkw/2rRV1IfriHfcNUhh6xT0sqY2hAv9V3ZqIUrEK6rWkLhFh1n2SmGL?=
 =?us-ascii?Q?kxskXMziItOhSHvmNZzrx8qqcfBi5LTwM/1Ud0Pkz9QXubB/d5iYGZbqkBID?=
 =?us-ascii?Q?s88yr7YwpB6oCgjhf5i0O2zlkZ967ipRLF6QhzU8NSyWLGdQCeZHMFpGJTIW?=
 =?us-ascii?Q?LsAIXFh4G5Fh5zlDKwix754yICd/f6uxUBZ76IIT4IwK2OtLtGnlCfSl/kmp?=
 =?us-ascii?Q?dM2g5zbdp+qTP8ZJ67Lezzhu/RnTtMUPunmalc/5oxwcq/2zyoFMd7feaNOd?=
 =?us-ascii?Q?SuwJh/nkF5b48w2S25pedUoJyGLwjn8sGNeXKnRn1+Qzij3xleWL3NgxBqv4?=
 =?us-ascii?Q?rgfFAwDFF9y05OEqZrflncfG/7/V8n5RLkn/gNXWyXCuP2knhmVhms7k8n4Z?=
 =?us-ascii?Q?a5qagc70N9FPvaJwxLo7m3BqpJL9ibvlAtrFZ4gPy7L+OpZxK2M6W1Ya0cTL?=
 =?us-ascii?Q?/q1NuDGDcQrLNZ2FLFzob74H1WWmNg2BRRhNkIROB87QNr9siBFFdsPn6cQI?=
 =?us-ascii?Q?VAHeEkmvqCIrnll2z/aAQGlKmvWZHM1q2ZhPg6YsBvqIximeWaLAbeXrCbrX?=
 =?us-ascii?Q?15uNbutxeqfG1N/D4TGVGgA7Z6KVfs9ub/onezIa7hldlhZ4HQBBkr394b/0?=
 =?us-ascii?Q?3FZE+l/kvnJTtBACUOEyVLqATA7IV1xEYkPkEQ95a7vBJuZek8nRPxpEn+Pv?=
 =?us-ascii?Q?Go4Z9fC5ftD/xzjROqvUlNniUtc8F46/38gkNzmJIg3jByRjJSqRT/PopH5H?=
 =?us-ascii?Q?tqiiPDCp2bR5585IWHc2hrztiEhGTVtAvn73auoIGK2GejEXPTkIyhFGoq5o?=
 =?us-ascii?Q?sBlypSCDUGKC9+1PYwVmwirFYT4/rCXzRXi18t7lLh8XTwPdpdLmNP6vlpcz?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96dde338-b4f8-4fd5-3d78-08db41f27244
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:15.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlHW8kGpgNiU7dVGE7xP7hZeRM3Ae32xHOqXvljW/+MTrOwVyrSJx/teHxJxPJtUz/XpUlbaKfsXRU7LqnzBMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_mac_header() will no longer be available in the TX path when
reverting commit 6d1ccff62780 ("net: reset mac header in
dev_start_xmit()"). As preparation for that, let's use skb_eth_hdr() to
get to the Ethernet header's MAC DA instead, helper which assumes this
header is located at skb->data (assumption which holds true here).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_ksz.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0eb1c7784c3d..ea100bd25939 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -120,18 +120,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ethhdr *hdr;
 	u8 *tag;
-	u8 *addr;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
 	/* Tag encoding */
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	*tag = 1 << dp->index;
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
 
 	return skb;
@@ -273,8 +273,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ethhdr *hdr;
 	__be16 *tag;
-	u8 *addr;
 	u16 val;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -284,13 +284,13 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	ksz_xmit_timestamp(dp, skb);
 
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	val = BIT(dp->index);
 
 	val |= FIELD_PREP(KSZ9477_TAIL_TAG_PRIO, prio);
 
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		val |= KSZ9477_TAIL_TAG_OVERRIDE;
 
 	*tag = cpu_to_be16(val);
@@ -337,7 +337,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u8 *addr;
+	struct ethhdr *hdr;
 	u8 *tag;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -347,13 +347,13 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	ksz_xmit_timestamp(dp, skb);
 
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	*tag = BIT(dp->index);
 
 	*tag |= FIELD_PREP(KSZ9893_TAIL_TAG_PRIO, prio);
 
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
 	return ksz_defer_xmit(dp, skb);
-- 
2.34.1

