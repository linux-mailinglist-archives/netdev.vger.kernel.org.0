Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF55236DD
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245615AbiEKPOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244902AbiEKPOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:14:50 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B9762111
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzpeVGIDWFPk0G/KdT2FpJx1uAH6zL8iw3lrKGoAfAiTLLIs+VOAmRnFUkUYQMjMqPjW2bNYTWsjyst6a//AsTOl03OtNk226FAC/6j4jmULnZY2tAESYoQlhHGcXLgjZO/zShPM8qEdoqldWCPyFtAd0KVCgiVjlUcuGzcFQDDS5RLt0TDdLPb1Tsrt4hbmz0nw5/HOT/hL9Xqm61FtiDuVP1dRwLl1BELRLfcQDRPFNvVvgQRE5xH7UOvvziaS/+74Ow/wtDsZT8ag8oZPE/R0TzRYv9l/nBn8492WJebNuFu4q8TudyzchzakzFXG2w4qFzlpsP5y/wwEAQe9/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLfOO4BLAcv6vpu55HeYPE3zHvcERLQWOzqfouIZpQY=;
 b=RcUMAwh6KHbyWQ2h9XERI/pAasDwJb9d+RHH/+4hSw2aNSqONRhb2LHDtH47mhyUg0MuKz3ndJ30U5LhfyajG1mbFRhOoQIH6Eg0urct8STSI6qeiVAY66DYisOVzRrDZdiKhRzAEFpo6unOlUe2cbFs380nK1mHuPgFXoLOqTL21LHF3x2rGNR94wNJG9QvLaUBMKheWYh1xfYbGq41pweQA64xsJMOfYwMmFfXXBrLDqCXwaz29subY3apyiRJUAD1wGWaScu6COxxSJPfOmH1L65JJNciocDsn8nLcJGtrkB0sOI7Uj0+9BYOSUMI68bHTbbB99eE5Sx6iEFewQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLfOO4BLAcv6vpu55HeYPE3zHvcERLQWOzqfouIZpQY=;
 b=pQ5TWPuDvYlFoISvzv91uwK7W7LFy/Q0Xmig3rJixe7RIUNXAKm9WPAp6Aqo8I4DTYegI58IrZbEbT2VS/+dRJEMunoXBDECnTJrMeGVuHDWsLTutUz+CRziVzpBv5qzSh/xZz3vh6S9Sx5PE0yrC6t1kSaKz7XI1O7Xj7QCLEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2300.eurprd04.prod.outlook.com (2603:10a6:3:29::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 15:14:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 15:14:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/5] net: dsa: tag_brcm: do not account for tag length twice when padding
Date:   Wed, 11 May 2022 18:14:28 +0300
Message-Id: <20220511151431.780120-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511151431.780120-1-vladimir.oltean@nxp.com>
References: <20220511151431.780120-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80f0a254-db84-4e0f-3f40-08da3360fb3c
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2300:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB230047417AC2C665A20B47DAE0C89@HE1PR0401MB2300.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uSE6EIkksKJPlFPEARpdGuJoqumhVg5ytGYdAusDWskoU8kE4OFeFcBTneEzdsXM2XwGQFfUgseFfL+uspkxN4sBGYz13fcPnAdsvKjM5793/D+KtquFKJLjgdwiqK/Peabv0Ml9zQBpIcyuycVoCNV5YzQ8R/flafQXukyNxZ0JXp62qJj39yAe3fimMYYfl/7URwW3NrglvOLHK5xhhjr28OcSQc6iZBw2OLxROFwVsQ0o3WWAabsqT4P1omW1pCa31A1x83/JtKWBb9hHJknJAVticUq0jy0K+4UChqD5GyrrjdmwFTU94BJtdetElb5y6ijK1QbY5zQqvaQHtpvD3VjhBKwlJR/w7sslnlxTRnJHPY+uGyianxOxDq61fQGN4xbAuBd6u3CDpxGvopq1DqJTMXfL/eS5HlEeEagEl5O1tkBrvnPtuY6Z6WRSBykh39zNdO5HY77cw+bTJ7647KViVt3WCaHbvap01K0DHbrlGCXQLXesl6iM9z2zvpOq8TjDm2TY+1kLcVhMeblbaYYzC7YhGc8hDZMAReTkDhWjetl7ssk3+laOpcFojFaoUuUJMXgoXT73DQVFegX2TbTPa3iPqG7eXJn4G+yg/WTY9Cs0/aXtwMVQMxiBh4Qi0i3JKrtfov+mB+4uEkKCGF08LIBdcB0l2T7EkOVWLABg2/STBME4Ceyu7MUbtjy7yMbYXmleUzxsoA4oHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6916009)(26005)(6512007)(316002)(38350700002)(2906002)(54906003)(83380400001)(508600001)(8936002)(8676002)(5660300002)(7416002)(38100700002)(186003)(6486002)(86362001)(2616005)(66556008)(36756003)(1076003)(6506007)(66946007)(6666004)(66476007)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eJGDY44tWiS8SRnZQ/K8bzc2P1hSSnndOJqmda5nA1y8hFd5ssWPzCzX1hJ4?=
 =?us-ascii?Q?EJ/LYPyP/DvyGnvw+QSn0MPzNMyZjGHoiMeI0K/b3PCP/aUFReACxtJNRTj8?=
 =?us-ascii?Q?6+St5+7hzWYlyaq6/gYWYnv+9H9BD/JmApn3Fl7qtz7lLFBYYTpVxrysjOpg?=
 =?us-ascii?Q?Fupzgsk2vRl0QBIb/4cATxWL+rp447+R1pvdO9cEGSlbqnyEgR26vW5hKZhw?=
 =?us-ascii?Q?o4aEYgvhxxohcGy5ZZtv37plWTRX8wd55JU98zDVnzI1fQLa7xMU/CrAIDrU?=
 =?us-ascii?Q?0lA2Lqlk+YJcD6snUbzWrGtduFGcupvD2pXXf7zDQKT7M5+PRGK53sg7842F?=
 =?us-ascii?Q?CfdSpKOQRbxeT6JajYZ6BcQDUe6rZcLh8VNCWgLs2BC3qg/tcy2x7QUOVM8Y?=
 =?us-ascii?Q?oAGAhd+FFqewwq+3K1cagI5hCxNcAOmX7xw0/UIKb2TVbmVV7CofqZ32lUES?=
 =?us-ascii?Q?XOVkdPtbMTwfaQeW4N4AdIsAUvqoa/m1JJINciwPMc0HW9g5xlry/e4dT3Th?=
 =?us-ascii?Q?tIytgDBarPLj6mwERRmnRuPIZLn5yquEQxxWd+xuKjtd4mtQLUPZbyHQUifs?=
 =?us-ascii?Q?uDDZxmYz/kYLm50fye+VSAfNve1bLP82Fe7/dqjmTjO5ogE4nz65/MN3bCq9?=
 =?us-ascii?Q?i6Jmb2nyIYRO/9DhKsnQ+OLhRX6jtOYu0wHeECox1Q9HCdaKn45UmARMhvXR?=
 =?us-ascii?Q?MQPks/CN9Av0GJD08qgOKRsandnIjkEB/BC2xuQJxdCXzkzVZ+ykiM/cwG9z?=
 =?us-ascii?Q?KQiDoyugx/yMOoqrattfq7e8dsWuI2M5xA95vYtC1aiyyA5H8uTJp2IXrOlC?=
 =?us-ascii?Q?LVf+pjT4uLE80X4mn/wNHMMsLMC2qw7W2mAjP4XI8IRgqRwNckOXP1XEh0uf?=
 =?us-ascii?Q?9alUs1Uyt5HqzqPyJxgYVOtllfc6x/OlUuYpebeJO6IsVyOIMuvWkBBundvC?=
 =?us-ascii?Q?M/ViSo+sKl9exqlAoujoxM8VsYG3PHFNBY9O33scw3KZrGj5qubuLHjejzDc?=
 =?us-ascii?Q?6bAwhKjZFW4KCriPdReoZCKjGsel9sq8gl7dpveB+n/so9CkkzuvVu/sV/yk?=
 =?us-ascii?Q?aiZoMfMDpqFeOFLWKC3mH/gKtYqw8HjygNFiptlcIIwR7qhnbowJnH6Fjfkq?=
 =?us-ascii?Q?81gHkysyH36aG6nDsrA5hbWfT1iMUJdbok16wUw0IuXTCBOMTTORdQlr5RpS?=
 =?us-ascii?Q?UAgNYVTzG7YnFya0AT9XrrFjgT+R1/dibEjbW9ptVbQFOJj5q6CExUwUZyf1?=
 =?us-ascii?Q?3uSbrX2bYrS6mbWUDxqFl2o1D8sFegNGQ80Q9xgM0Af0xaaj9zvbs+U0/oDB?=
 =?us-ascii?Q?A4UDjnZQ/JlWaenMtZ+Hn2Z1xwo5sBi/lcYWOYRDR5opin2Kl3usFX2JAhb9?=
 =?us-ascii?Q?+5/NERX6H2mORJ94Er1Ys7MajoOFKFhyFTeA45iw0xPd4au0Q8uwVu8AtKuG?=
 =?us-ascii?Q?ozclW2L3726vunnnP/i4Rp+vQ8A2VoDgbt39RehR/jtSp/00NM+Ln71idb9t?=
 =?us-ascii?Q?V1L/AkdQM19dhcqEfeL3YhRgEjKe9MSZevDVuRpJsTz3KBCQzWBZUj8I9vwe?=
 =?us-ascii?Q?sB51+GAy8ZgNehmXQKkWHNM94Z+I9QBRFioQxAHv4xcPVg437TF/4L3wMh57?=
 =?us-ascii?Q?jv3miEZ890mvNy01kKiXBfKn+cUlkOgJLbSkxRsIjJBdsCILPfQk13Gkn6U2?=
 =?us-ascii?Q?oH8YT7QAU1LGQNYxPwMEolj2fuVXsAobBLsQ/ot2UltamF04Viy4XMkRBBVj?=
 =?us-ascii?Q?Yn3iCxCrBGqM4EOmcB70W8hLeqI6UaM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f0a254-db84-4e0f-3f40-08da3360fb3c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 15:14:45.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eBuOghH2QYb2kKryTOrbs1fFecw0fJt24QbXhOq+iH3ri469WyMyyCQwd2x2Satmua0+uXKmjcP8o+NKONOCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2300
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

brcm_tag_xmit_ll() explains in the comment that the skb length
(sans FCS) must be at least 60 octets before adding the tag, and 64
octets after adding the tag.

But it pads the skb to 64 octets, then pushes a Broadcom tag which
increases the length to 68. With FCS, this length would be 72.

According to the comment, this is not what the minimum length is,
so just pad small packets up to 60 octets to bring them in sync.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_brcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 96dbb8ee2fee..6cc4c4859a41 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -93,7 +93,7 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	 *
 	 * Let dsa_slave_xmit() free the SKB
 	 */
-	if (__skb_put_padto(skb, ETH_ZLEN + BRCM_TAG_LEN, false))
+	if (__skb_put_padto(skb, ETH_ZLEN, false))
 		return NULL;
 
 	skb_push(skb, BRCM_TAG_LEN);
@@ -223,7 +223,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 	 *
 	 * Let dsa_slave_xmit() free the SKB
 	 */
-	if (__skb_put_padto(skb, ETH_ZLEN + BRCM_LEG_TAG_LEN, false))
+	if (__skb_put_padto(skb, ETH_ZLEN, false))
 		return NULL;
 
 	skb_push(skb, BRCM_LEG_TAG_LEN);
-- 
2.25.1

