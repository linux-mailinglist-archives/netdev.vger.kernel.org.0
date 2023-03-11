Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1966B5935
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 08:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCKHKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 02:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCKHJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 02:09:58 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2126.outbound.protection.outlook.com [40.107.6.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F391A121151
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 23:09:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xly07D241JAgj0bhhjNp+YxS7oXWy6A1d/OjfjyjQOrw0ghpVVqo3ad42A9dL8SSTyokfwMrEKzjUuimCJJKSIgb6oMS0xorU5r+cAmHwK+gi6WLV7576Xn/AOEzxEWgjMWBk7JCr/h2Am6f0QwYD8udDU9zfs3XV78cpxgug5DZMQ9CpvRZL3++2tpvTCKSa5QoIpVHmHyb07sRXyRCcQNV6xSaLayBm9wr/BtUEdhP/8Fp6Q+MeDtOm+SVaaN09dnaP35BC1rSgPDS0UCYJRmrVHJp13VX6K/NxtsfuNLEICZwqNs5MHX8x6rZWhu9ZjI1O9lFsfwDbrxYfqIz7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpKFD/+pnUDqo/OkQLbPd946HTVU8IUwIrpmiP8wz9E=;
 b=KY4ueIzkYlXjEDkN0fHLLbVxwB3Xu+XbUc6QBUgxDfyhp8btTJF12lPCLHqOVtiPGqkInD9UKz66qMMhDWOzSfWm5tg1/F9VeVChXQFFOwjElD6aKOFWl6EHFjX7WcVTWkRH8oz1qr4EihxEY2L3Z/0GpB54hXxCrecLVkhVrKGH2wEVZzwrJ6auq+JcgLaOqHmgbh1WlV0HQgVxML53PWPImVcTWdaI0BbiyFL7yIAnu20U2BC666xzd9U7czyPNc48kkZBwq8ZNMNVfnqKln7ZpdcO9Z6CDhfhk/fH5gHqzxbQIWJfx8458e6gweykR0ra3axqOHQmcUgbjv/kBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpKFD/+pnUDqo/OkQLbPd946HTVU8IUwIrpmiP8wz9E=;
 b=Bc8A7ExfsldPddMnA1D/l+HaTJMMixfCfumqeNzsfaxflsb5u53422RZvOnsVhFImBD3b7xsyDJPYrhagImUIGFP4F4Q1E3KVluDtMarvJrj3WyfLMqHHJRGF7Rn0RAWrcr/9oixE70fXxuTOCkJwhq9hcavBXDkLXkL1dVXdpo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by PAXPR05MB9410.eurprd05.prod.outlook.com (2603:10a6:102:2c1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Sat, 11 Mar
 2023 07:09:52 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%9]) with mapi id 15.20.6178.022; Sat, 11 Mar 2023
 07:09:52 +0000
Date:   Sat, 11 Mar 2023 08:09:48 +0100
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR0P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::8) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|PAXPR05MB9410:EE_
X-MS-Office365-Filtering-Correlation-Id: 2070f48d-852e-4e97-3009-08db21ff9c21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4EZHMDpfTLSQCByPQnsZHIsVYatgKfjZbK/6IP+pkpyfO1pOSpqrDNRwHnJG6wmAx0EJl3/FpyZ8fW7+sT2r9guPy5RSPJ0N/2lKcamJb+3RYixO94rxfeCcbMd0lvpwcHiryWOSA7cWBwsxh5DvQ6/cQ2sBa1Bqs09pbX/MmYed6GCeONUabebpmQh7u+nX7ZYjWfGqSomzELuIY1lpv5n6Na31M/Rj9CqqerQPFuy2kMjVzKlAqPiD/N2x00pOZ7wdPQdfWBTwyaG+O0w96xoM3im65J7SRyod2BiYycipeCokOBkef15VXzHmJHtqdclMIlzyevAtKzdDAKVjmNsm0F1ivbt8HkBeAs8dkd8sovw3cjWQ2IP+igfg6zM16Esm9APvpBB7zp3gWshIsY9afJl5Ue9EIHW5GpmJo67P5n7n7dmwMYA6AeOzJdkF6igBa051TBlumdYcbCZSRg1UoT/Zn1vNAykF8McenLbYiRoWlAw3NDu9WxZ4yFGWEt6nNlEwRaLV/Suitbh5UztUF8qvBypgaDPOGnHEtOY7oGgW4wkWhz1RLiyn4IqgvwisusJUoPV3U0EL6nIBnlP2a5xnfSRXphjfSnhPTS2iJOUokkAAZ/BpYydqeK0qRaxYa7+HA4JRqDL3Lb/ixg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39840400004)(136003)(376002)(346002)(451199018)(86362001)(38100700002)(2906002)(41300700001)(8936002)(5660300002)(6512007)(6506007)(1076003)(9686003)(186003)(26005)(6666004)(316002)(66946007)(66556008)(66476007)(8676002)(6916009)(6486002)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T165TA5aW64FZQkjBbaSK3F2mquQtIoMZvmDjnvS+UvQB0PEWxAU9D4ldDMz?=
 =?us-ascii?Q?XDC63PSSfx4eXWaQ9wXaZLlPVOSBlia4J+HwXAQav+Id9wF5izVIR2HoRAhD?=
 =?us-ascii?Q?OuKp7lsP2zxPPQwS8w0iC45k0b8cEeIbF3P4qk3XIFhyhWbay1gp0Q5EF7X/?=
 =?us-ascii?Q?B+wttdD1WWV7KPn45znplOmJSoXeOqW313BKG2FFaqLrGLDFbM48Oblk7XNg?=
 =?us-ascii?Q?uZt1Cys2C91HnqFcOG5O82WEO8ViyGBLu+Eillytb1o+uD40WIh6gjRGz+lY?=
 =?us-ascii?Q?vQ9yYvckIXB0ZGAymdphw33YEhMM1xzRyg4Cm56nLiojJLO/r0qfp0S4slkY?=
 =?us-ascii?Q?x3f7kdzD/F3WYiLn6vP7belevt2lXkvT6rYCS7ubWqqvqr/JGXmGURgQAdre?=
 =?us-ascii?Q?yFfcfrx45wayCqOd3jqtIyG9gDxY6J80NZIbLkTfmtSLjduTtPHibfNu0P4E?=
 =?us-ascii?Q?HCvj0rnwW1+AY4oCI9EkwAuTlemM5E6hIz5dvwuJ2nW4MuBFYMbBVC971GeA?=
 =?us-ascii?Q?yppprTa6dV/n9OpQlZWWa8c2Eag7C4jRlX3UMIXVbfyU90Ubqo4C8ql0/2zw?=
 =?us-ascii?Q?X3rQOP8K8/Xyb/+lK5+5//ZuytfUK/GWVnLSQ1oZ1n6w3fA80LrnhceQGKbP?=
 =?us-ascii?Q?/uOTUg8dmf+/Fn/1C/M4jewXmbZdMqfZ0uFAorizxd8ZMuf3fVcYbsEPwEua?=
 =?us-ascii?Q?XNrVHD8TPSJSlWKqDyH34f9IJAkQdvaSNlOqBGpC04IcWUdp8qKigh4wAW99?=
 =?us-ascii?Q?9CnjS0RB257++k9gpnoFiA0xbTII+HZ8wtSzEs7ZXwfgaSIOYtMzKGv/Agar?=
 =?us-ascii?Q?FCJ/uGICUR/RZphTFyBkCeX/oV4sSqI+9fqJesggbZj7pc/kTlUWwEHNF3RO?=
 =?us-ascii?Q?lOPT+VKgoKqpZu5fe6Ciy8Y9QAMF9lAwBksbFMbakB8n5PF5R93pZDuzsKRm?=
 =?us-ascii?Q?RNMyJwLrNCiXlWhX32fPWTe3w1rU1gGg/S9IVyuoSoJ5yS4Oggi2gFTDLvor?=
 =?us-ascii?Q?ekeopyOBTdn3YZT5oVdKEN8j0/Rbe1ddUG2AdwrfpTpBaNouGem075+jik2e?=
 =?us-ascii?Q?4JzZ3seT5bG61Pdip4f/58LhgQPGNok8aQzZKeJ88UsuqzftOGm4sGVWk1Ad?=
 =?us-ascii?Q?od9xkgPYEibEfyaUhQvgZHGilfgEws61GT2mo4I1Fjysn1lqClEilS4fFoBu?=
 =?us-ascii?Q?sNz0aCJYO5Tku9GrBBV3WPGoipLtTerUy+bs6B7aiGwusaajIRyjS8jziPob?=
 =?us-ascii?Q?MeFbDME0qYCjG2gZ6UDtreAexUw9o9lTD8AtvO9SdzltoDNHH/N1BB7FzZny?=
 =?us-ascii?Q?tzTlQT+QIIXyPlNty7lQjDdijqNNGJ7ssANynDOlpNulCGmL+ZVjutc5zyDh?=
 =?us-ascii?Q?hfkeLAHC6QubzfUxOHDdOawZ52RJlmi/OyriK5i5gDeJk/hqAlZBi2dKGjzO?=
 =?us-ascii?Q?b5Mu+U3zPUe3sfYnhNahVs9d8RaZ7QqSJHjbmcA8f7N9ihTXTKGvJAMDmlCT?=
 =?us-ascii?Q?/DmV2q7nrdgzL3Xsp2GAiNr6FXx3bJp+6jKt7bAy+UuOvSaeHwQh8H6Nr+zD?=
 =?us-ascii?Q?ifUz829hcj/OHUH9oMRkpSY2knB9OADmB2kwX7UFofn3FI4r3FccYUXd8OA6?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2070f48d-852e-4e97-3009-08db21ff9c21
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 07:09:52.3949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7UnvVJQqovsFOEMxOIJRwwl8CfjvsB5MPZ0h8Wz8X8NN+vLwntlaLlSM6ENzSkq1dwr3ANUmoKUukxZDzT4v4gI0I7WceiJAg7wjs9Bid60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB9410
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The classifier attribute MVPP22_CLS_HEK_TAGGED
has no effect in the definition and is filtered out by default.

Even if it is applied to the classifier, it would discard double
or tripple tagged vlans.

Also add missing IP Fragmentation Flag.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 41d935d1aaf6..efdf8d30f438 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -44,17 +44,17 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* TCP over IPv4 flows, Not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_TCP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* TCP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
+		       MVPP22_CLS_HEK_IP4_2T,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
+		       MVPP22_CLS_HEK_IP4_2T,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
+		       MVPP22_CLS_HEK_IP4_2T,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
@@ -114,17 +117,17 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* UDP over IPv4 flows, Not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_5T,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
 		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER |
-		       MVPP2_PRS_RI_L4_UDP,
+		       MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
 
 	/* UDP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
+		       MVPP22_CLS_HEK_IP4_2T,
+		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
+		       MVPP22_CLS_HEK_IP4_2T,
+		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
-		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
+		       MVPP22_CLS_HEK_IP4_2T,
+		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_TRUE |
+			   MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	/* TCP over IPv6 flows, not fragmented, no vlan tag */
@@ -178,12 +184,12 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* TCP over IPv6 flows, not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -202,13 +208,13 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* TCP over IPv6 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
@@ -228,12 +234,12 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* UDP over IPv6 flows, not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_5T,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -252,13 +258,13 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* UDP over IPv6 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
@@ -279,15 +285,15 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* IPv4 flows, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_L3_IP4,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_L3_IP4_OPT,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP4_2T,
 		       MVPP2_PRS_RI_L3_IP4_OTHER,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 
@@ -303,11 +309,11 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* IPv6 flows, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
+		       MVPP22_CLS_HEK_IP6_2T,
 		       MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 
-- 
2.33.1

