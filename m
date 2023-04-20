Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7A66E9F84
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbjDTW4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjDTW4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:56:24 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFB24210;
        Thu, 20 Apr 2023 15:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACsisWJCnoDHxh5/JjCSc1sZt9BowMUY2rnX+j2PeNLM3AqK/oZDC9mE7/+daJzdKsN1d0EHI2R+DXFrGKnvi8npX2KkQklnX+UcvyukRT4DCJsyY0C7Tqt/CxXhFDo9BP+KKR+XxhGdSpPSp26Ir5N+nd1CVmBNFv6pIs+JNuWXObjRBJ/Fs3f0wIGXupbC+S21oyYyF7JO+hVdJPJTeV56VwsBVdrsPnct0vxeZ2459ztkVgXQfyYPvpRxCyqOdxUFPPUcL8U0owJqUrw6OA1AbXI27O12oOlt0Xt4Tsw+i0Mkf4nUGsSTw0yfT0TonfWvhEQzCOCFsQ4whUBKMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ht3ZUyEsnFLqae0qeYKxYb5wG/dLKpYEg1K7SawcTQM=;
 b=Z+gA+hvjGASJiT6OHMJevrUqtLYAVYCGHFJCPKHQgAX6c/w+oN+9Z2mmpjqKFAHV08uvnIdc1+6GLBzClDgedUCyz5naUntLH80u7CHrUlKce0lUZp7DWpurQ1SXbuDzbOxsd4L1oJ97E9Qs09+bzjsjjYCHI1etGWe7Zia5UInpP70clEKN3KlwVcSLkk3LJ6WgivU3zeyuxwKbRV5F7AZ/N+2tnneHrjLzqPcLAp7OtJI2ahDWzov3jAX4iGy0iJW9dlKb3bQWA2wRzOgWe4CPXX9AvvqAO1QOp1O09G964TNwakdgflE25TYVWFDelik5Pr+oUbqd3QNE/8FX1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ht3ZUyEsnFLqae0qeYKxYb5wG/dLKpYEg1K7SawcTQM=;
 b=TyWdVBmT0w1jMtSm4Z0x1JgwKgZOgU+xDfRTHPS75ckkktSqeXlrxDWDeYjC9e8VJhkyr8zDSiqFlsa5Fqx5pcMnT1C1LmGNYfzMKz4Kp7uuwI6TiwGwrmowG6u+vrc0KHCwHkYPqUWtTJrEOL1cSCg2tQ6sa0cuXWIhzTmhwbM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GV1PR04MB9213.eurprd04.prod.outlook.com (2603:10a6:150:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 22:56:17 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 22:56:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 net-next 7/9] net: dsa: tag_sja1105: replace skb_mac_header() with vlan_eth_hdr()
Date:   Fri, 21 Apr 2023 01:55:59 +0300
Message-Id: <20230420225601.2358327-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 123f41be-90d4-4d09-57c0-08db41f27324
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qVafDPoKD5si6kd1o7lqlo0UhJwGhjwVW7bF44XBX6JDR117UE2uhpUEAe0Qq+RqcwirkoUrx9+zeiGnE9FAbIDuXd98ineJLALL/xVScFv/tNIpM14xLmcyH2rt40/0vmwSvhCH5smY2VAPDyX0uX9fq/Al6a6p/r4RH4Tl+oY6ECJakRqGZGcNBSWmb3aymLf4k0YJsRc9j/MUk/GXKpQ3h13Lhv9JRWuwFttifbt+Uret7IEVYo5Cnt35oePyebCbowgCKSJ5HbFT+teS2P/NEg/DBeFlNnBCVmKlu4520WGlsEOmiAPLCy0cjbFUMMcLHGLoGCXjsfiwSoTrWeGi8+XAGkwUVxesQdhn0bxu4z3GQF98SB1xKCqsSPuBLyEgWzhTQUx75jbPQVcs/8zJ+aJv2Of/VqqsatP9fIkb7+n69+pasp763cinAkb2su+o71JIvcbgweuOyWqPOc+YN1yTcL/Kj/uz09h9vuMHTqhY57QUOMAOCg7N0LigO4dzgPxaDVA5nNsna5sLC5pz7x8rFmIzd8mUKCcPmdcl9wo3BueWs4HFa+qy999KLWPTKdLw8GSNXBZ2leS+310EOIAf2B96rUBR6nEVmSZlRw7M9HUdDbi3COQBlZb8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(2906002)(4744005)(38350700002)(38100700002)(86362001)(66899021)(478600001)(54906003)(316002)(41300700001)(66476007)(66946007)(66556008)(6916009)(4326008)(26005)(1076003)(6506007)(6512007)(6666004)(6486002)(52116002)(186003)(36756003)(8936002)(8676002)(83380400001)(5660300002)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kFTG3VWyKjJ/OEwdx58yfskuzYk4slUOhKwvj4LCgz4pHSgFCUKEt7EY5j9X?=
 =?us-ascii?Q?3IZbHDIMJ+ty/hPNRZdG2ih9OdrsIblL9K/LkFdCJ55RWmIzvSZu0sNbzRMT?=
 =?us-ascii?Q?y/bCT+Pnl2TbuQl00olS4LICmvGtW4FeKk4vowodG88QV3Xye5pjceYtdJZo?=
 =?us-ascii?Q?NPJxUgeoEWn0e4y0gyKDkFbET6sMCT7Fjotp261pJS00eqxQFtW56S7HMY9q?=
 =?us-ascii?Q?T8Fm5cd9cFiHfqWXOdVR3QdBdyUTV8P0c07xJ3Bgm6ySL6tv1uB7v87R4GQK?=
 =?us-ascii?Q?iKNz+7gxAjAWbNyfwlug545tIo5XC8FSylKdp/YjE0ru6n84pNII+eyTIn0R?=
 =?us-ascii?Q?aFMSmEDNihYHyjW0TN7FwjlU2NVXNU2QFB0ju1RjLV6ZDZRQWgFOkZ9MpjGv?=
 =?us-ascii?Q?3o/aPGExbjXQaCVuHFaFCKvoN+TPj/NL+kFFRIOgVcgmRFZdYQv7ttvsMLCE?=
 =?us-ascii?Q?GY/YkZ+HgMPi+TFFOdzYRqDAqrjlE09yGZPn4/tn5AVPIs8aaI0vxiry+GJ6?=
 =?us-ascii?Q?RaZoLofgIk8xjosTVxkgvPOms+NhU9jOc467JBFRkMiXZsyNRgc6cEjBoGRK?=
 =?us-ascii?Q?OWvlej+ofuVcwiKyFj0+QcZL9qw1MSmCoQ364hRh98pgrPCfNRrtdPOWFsrM?=
 =?us-ascii?Q?SZZX4sfFnT3SUQTDppzIuIT0c1GzsAVvVKDO6EMEIjfiC8v8Qa7IPg3qFuuC?=
 =?us-ascii?Q?PYI9enkoQ2XvDHxxqE5vGyBtY1hs5UzV6ugcZY227S0xTvklNekSwbvVh07f?=
 =?us-ascii?Q?945XNRcg4Nd+amHFV0+5joCfwQLnLHf9oX45VxhhbR1SfECbaEQpQ9D7PJD5?=
 =?us-ascii?Q?1rLePVPznM4lL7X7WEG9mj98iIbhvUE7haTkUa4kHNyoZuNae/0KFdGQ3VX9?=
 =?us-ascii?Q?pXxIewxTRNx9GLR4jseuBWW4r6rw86LF3BBfoUX+eKW4hPIMNZ2/MvmBRXBC?=
 =?us-ascii?Q?xQJ8xf+7Ppi0WIo4WNwIZ8+9W33W3isypZrwgbQQO7NBeBPu1xoUGbuIgBzB?=
 =?us-ascii?Q?Lffs+S0UhG7v37mHhUguJ4mBrO53GGI6nkZGfCsgCCH3aR3whPYc8xLwpJ5x?=
 =?us-ascii?Q?NOtq+8tLlOVr1ypFQHzlbapMAP0TNFmUKn/legloSzrv/9FLJUSlpj3gYTFH?=
 =?us-ascii?Q?BBc6HZakv9v2Y9BaN7jFom+SD2qXrANeKBUpxfP6ToXvdKT7OaQ6QHnMwHES?=
 =?us-ascii?Q?s7M313pBIalusHKgjCdvHIDBZnoJgQ4weLaO6oLslIesJBpdK12ZqBxj2KLM?=
 =?us-ascii?Q?0mVR1ElqrYFkH2fCu51eI+fC7kvPUSNFv/X7SWTuzSnWZu3Uclbo8hWZnL13?=
 =?us-ascii?Q?RpqwDGajzTXyNwUKyHKbVLDHOwk6X9/WGbzTnUjDomAMZ1+TMQISzyqUM9OT?=
 =?us-ascii?Q?TGowJyhU1+PdJ4GNRsZ3xACcwe4ojqR4B6xF9MIQ46aszMeVOqm3xEAzihWQ?=
 =?us-ascii?Q?aiWoWvtRi6cHgvDxfPMfs4q7CtrLtVflvWcy2L1KyhTbwgAliXnZyJ+AoJN5?=
 =?us-ascii?Q?G/+z7WUdpQfWJfEPk4fWK3IgKjTHMerqqH7ZxCEe8e2Ovie9EaUVvUodefhv?=
 =?us-ascii?Q?J3K/R/N/H2a3id07BVjuKJfILd6xM0rd7uP6SkuDTCPnk10LH4zVsRduKG+D?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 123f41be-90d4-4d09-57c0-08db41f27324
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 22:56:17.4071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy8e903hwW4gZYRRxkF+G7Ym2CEXgx9a4tINcMIxXxplUi+EJnlDLh7QR0zVICRLFn4IMRqjp3TuUNn+oZEsXQ==
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

This is a cosmetic patch which consolidates the code to use the helper
function offered by if_vlan.h.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_sja1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index a7ca97b7ac9e..a5f3b73da417 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -516,7 +516,7 @@ static bool sja1110_skb_has_inband_control_extension(const struct sk_buff *skb)
 static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 			     int *switch_id, int *vbid, u16 *vid)
 {
-	struct vlan_ethhdr *hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
 	u16 vlan_tci;
 
 	if (skb_vlan_tag_present(skb))
-- 
2.34.1

