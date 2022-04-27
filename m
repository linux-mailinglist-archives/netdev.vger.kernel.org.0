Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C775123F2
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiD0Udp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiD0Udn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:33:43 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20058.outbound.protection.outlook.com [40.107.2.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BBFA777E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 13:30:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9DIctbhCtHYsLVTxXtQSiQT4suHe7OWnVbqd6pLu8nwWTajwHQ3uLhbYbeYqVZQm6E3rWMeDCVSkFpJCRFfvatIpR40PvqpuE60yOYIr7WguMM2WaKzCDaR7zaGuLvGaniNJbBmYRCSRcAJ2dQ+JBeDWxsn0/0V4La5S3acNR1WLCY1Gnc52ilJ61lw+evdcmyoBHvtllDsKdx3LTc4W7nEhBEyktFj+nTWuiZJoKH5UxksAXYyGPzoGWyllqf/RVHSr2cju7GXMwadT+sZAKTJyGqqlPpFm2TcQexZEDxK6cpmQhj/Z7KqFdpZ/D1i8WZus3dUfdYHU3jAoUH9/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPHkKra6iYJW4S1TVZHx0vvw1Ql8rTnT/AjQYoEys1I=;
 b=GJ/cbkzR4l/Iid+Q9n7YupJDFINCnxONi76PEA+pNFC3LfjexnPh7UtEtuQ1lebxz5OCGeUJx7vCO+GNCRUAphOymdDQvSbItt2Sq9HWYdz2L2HwcmCIveEEBrJJNwMZkBbCfnkS1dIz1rMSloP9icHzR3c9MheoJr04UWCBZn1rA/B/LyGTON/JJjnwVj+lQvRvKgZ8N8zWXh1E3f4X1fbuNw3fboLXRobM068pxL1akCp/b32SUFSv138HVpRIddz1KbBhX7fHR5o9dSN6p7iXpvqzCoq/CqTjE2593W+DcMOIOoeZAKlyixAbxQhfKJAou+k9/utG1E7Pzoztjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPHkKra6iYJW4S1TVZHx0vvw1Ql8rTnT/AjQYoEys1I=;
 b=QiX9TZArEinWKlVkCaHaJVL/ZYW7ukGDO8yVYYGithqV/+ZOY/Mzu2hnAkWqhFIRjZB7eETlHV0aHw938xVkF3WadNalMtjXpV8TXmpBcqOrpq8/8gf/7OC4Ifk8FVcEevSUaQupqtOVtHn64LbKEvWntwz/Azx8LqFMNBeZIaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB8PR04MB6537.eurprd04.prod.outlook.com (2603:10a6:10:10c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 20:30:27 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 20:30:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net] net: enetc: allow tc-etf offload even with NETIF_F_CSUM_MASK
Date:   Wed, 27 Apr 2022 23:30:17 +0300
Message-Id: <20220427203017.1291634-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8P250CA0011.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::16) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99a5d401-d4d4-46b5-d6e2-08da288cc381
X-MS-TrafficTypeDiagnostic: DB8PR04MB6537:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB653779CBE1BC54B530D09831E0FA9@DB8PR04MB6537.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 91qTWAevT13oY6ATeJh8TEzUuMfOeXafSIxwQC7WIyb6E9mHLX07kMQXmiBnJEHHXdHqqyUy/U3/kaqO4RVXyzHkFroc1WdGSBmMCZVo9ggt19LWm6QOmRT7Mv4Hkyqo1V5PGuWAiOxEJMhl4eZ2Yu/0DU/gkkWCaY0MzNw4hrx9/VRlPxw6dxiCPo7vKdH1PZPNS8v9sxlhrfFDpwuxzDY29BT/ne+/P2A0T1P4Vpn8YDyouOngBnvIa6LYHubx9ZEAJ0aZ/zgPaBKWoOBwQxndRbq+D7SuEVrL5q5MWhUHjA5TFchIHSlCRQfuqzTdFu4M4xvM8FTuIuZTgnTfnzTkSR/LYP1s8CxNWqZLQ22Da0XoAh5o3xHRI9h39z9Re3G6JbDbei/J+/H5Q1L7UOLvVh4m8Xw4Oz1mnA2Xt9T9jLEQuKpr/6Nmp2RSe1fDZtlVrvtqKUEQHKUrD54MIrRnWe+04+ZaxZmNIXUsLv3iXgIkJvd1umZaQATeJXY579RVHJJG4zdBdml5zFCnBJdI7AJ8qrYy53eqagGIbQxqs0/29ZJFM8HLwNCESNX1I65IspuMABcDdwd3foZtxC2CeHZZ9Kh4+dFoTgR0HiGSZ8r44MeaRfRyUv+3Nbs202NybKMVvR/uGJV1ZYeinR3kYUCeV6bCpc9iz0mHEdcgy3f+jzqEzkmeMQm+Iz6u2dsid5TM8DIJs6qnJiPYjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(86362001)(66476007)(66946007)(66556008)(26005)(6512007)(4326008)(8676002)(44832011)(5660300002)(6486002)(8936002)(508600001)(52116002)(6666004)(2906002)(186003)(1076003)(36756003)(6916009)(54906003)(83380400001)(38350700002)(38100700002)(316002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?is0LbGHmfC2TuGjzeRdMSliU4NWshl2H1boHgSy2lvd4ToT4qrSYYlazEbaU?=
 =?us-ascii?Q?+ALUMfhetaC7iFob/A1PE57Zt0EUENGmToQ9/cUQIBSi0t6ocGxCDN9218wt?=
 =?us-ascii?Q?J3RV69ngYLCcFN2AB4XU2MFZxYdrS6AEeJFBPj90PF9m4VLCkETN5QO8VTC7?=
 =?us-ascii?Q?O0PvEYMwJIhHHXyJQtnZ139mWaHb5sWFzdJKbLk8mEjmmH6+kDgANfj0n2h9?=
 =?us-ascii?Q?JH2rEsGGDjJGfYXVdw0gG+3ENDQs3vtlY38pwzkW7EHnz0K+5LSSgpYKAX44?=
 =?us-ascii?Q?1lulvhT3WsDUC8o7qmem0xPBbH5er5VBfRFO+vmeKq53cDulHrfOoqLeZ8Ib?=
 =?us-ascii?Q?myqE9Z2FR9axivxIWxo0MXaDwLEZ2ZXcTdS8dbqsseRTQm8s4TeDicNzEX1s?=
 =?us-ascii?Q?0Q8XoBTWFBpsd4TCKlS8RYOr9W9ug9F+d5NwHj96Ow1yakF7zrx0GzDgc6YA?=
 =?us-ascii?Q?+zoJWIJltlHCqATWgWCK8NjqFXxm5lqWRJGG11hGF8ErcIdiWXfI8bkasTSw?=
 =?us-ascii?Q?bqxnJRZ6RX+KzBHyFM1PE0b/+DtzBkpZSz4yXgV2KCOzSRTf35fuBmvVJR6n?=
 =?us-ascii?Q?QLmpdhn5rRd7SO/z4hQmtRw7FP1MBZ0P/1kBQYNF8ZAKDNABkbAtyZ/HBQtq?=
 =?us-ascii?Q?alq+PlUZeZ1cB/q+j25Xwwv0GM5MYDZF2FzEfEbRIjrnmOsSOybCocHGa9Vw?=
 =?us-ascii?Q?TEpT2yV8fbjNEKu+eRPrHXbfGUYL6JN2QTENy6l6Wr8Fw+lym/Qluvnyf+EC?=
 =?us-ascii?Q?XmNoE2uyic3MDNMTQW/w9Ku55g8o/AFDcsEPc6oyPG+FGOUERlp7NckMZ7re?=
 =?us-ascii?Q?xUOHBfRh9YtsWJ71Qugl1D/Yq27O/+kYmIGeSDA6VPzf0BKTXU+sWxqSgwFs?=
 =?us-ascii?Q?13Cx0UpGpaszqVdAo7CiotCqqKo/mTtYB6DFRfC0wnRGKjSn/gwla88z9aqW?=
 =?us-ascii?Q?WErWWFbFNH3gf8ZCfPIae2Qgqhg1yP0J1OSKcyh9axfFs4dFLypkRWL4y3mn?=
 =?us-ascii?Q?1oMoLsgYit1AcBtSoTyEvvrDKWEiqTLhArOknUt9hHIzeSx77Zc0rU08VJXW?=
 =?us-ascii?Q?ptt3t+9i2Ct4wmPqmKVNN+X/GbC2Zbud/13bEpSZ0uqbwAt+4v/6ATbexgK4?=
 =?us-ascii?Q?r1xwyI0rwOYOOH15sy7BrN0GXyB95rsKqU5gA2JUA1zg9iXL+2WhIigZJKsj?=
 =?us-ascii?Q?bSsrTvRmtGu5nQeV/bwSJ7ms0Odfd7ruRRFT04g54e41+uk05hWGB3NRozT9?=
 =?us-ascii?Q?lNIDQ0kg5AmGG+UDgezPsfYGgfyd8j0oox2asz883hzoB5XmceBWyuEGf0eP?=
 =?us-ascii?Q?kooiX9RyzyFWrojORkNR1229yECzFG/tH73TTNhXvWM5R/z/3jJGlrn+bx0k?=
 =?us-ascii?Q?cXtpI5Z/CJSVGpeY9ZnHjLwYFwEb9JsgoePAIuZyGvSPJUCjwzY5uj/+AmEl?=
 =?us-ascii?Q?1R3mcwciT/0wI4eHG/n+vCOI6NmMJp+PsgTSzE2n2di9nHzB5ORfWG3l7U1i?=
 =?us-ascii?Q?R3JUm/KqB1qeqkaJxKuf5saUGmd+7OQbC7cHH6f3TXKi1sZk8AGMVHbst4F6?=
 =?us-ascii?Q?zsQEPY3ivznSG2zuKWhxNtfWwLHdqW4P1Gz3gqyPgHf7TLR2sNkq7YQQXfOn?=
 =?us-ascii?Q?UzpGQ3T4wyaiw/jvBRiZkG4EkV6q4VDmlEQ2lQFqw4cWpcZ9EK606aqEQCx4?=
 =?us-ascii?Q?jrLKJoyXEtpgVxkJwyTf5K7cA0XqbUvKQKdEON40AMckoj4N7zi/av9GG4cv?=
 =?us-ascii?Q?08NAQAV+kAVWMvjVD7zdmytqQbUuMsE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a5d401-d4d4-46b5-d6e2-08da288cc381
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 20:30:26.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgkbMkGHO3kjA2Hi0liI9/RmpAWGBeOC4jJbNiwS2JJ36tvMG/RQxpRYy0OeCK4sj7eOpJSzxqncL+ar3QKfDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6537
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Time-Specified Departure feature is indeed mutually exclusive with
TX IP checksumming in ENETC, but TX checksumming in itself is broken and
was removed from this driver in commit 82728b91f124 ("enetc: Remove Tx
checksumming offload code").

The blamed commit declared NETIF_F_HW_CSUM in dev->features to comply
with software TSO's expectations, and still did the checksumming in
software by calling skb_checksum_help(). So there isn't any restriction
for the Time-Specified Departure feature.

However, enetc_setup_tc_txtime() doesn't understand that, and blindly
looks for NETIF_F_CSUM_MASK.

Instead of checking for things which can literally never happen in the
current code base, just remove the check and let the driver offload
tc-etf qdiscs.

Fixes: acede3c5dad5 ("net: enetc: declare NETIF_F_HW_CSUM and do it in software")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 79afb1d7289b..9182631856d5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -297,10 +297,6 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 	if (tc < 0 || tc >= priv->num_tx_rings)
 		return -EINVAL;
 
-	/* Do not support TXSTART and TX CSUM offload simutaniously */
-	if (ndev->features & NETIF_F_CSUM_MASK)
-		return -EBUSY;
-
 	/* TSD and Qbv are mutually exclusive in hardware */
 	if (enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
 		return -EBUSY;
-- 
2.25.1

