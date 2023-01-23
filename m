Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D631678536
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjAWSp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjAWSpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:45:55 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2083.outbound.protection.outlook.com [40.107.6.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E562139
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:45:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkqUCwTsdz3AJv4n2B4jUPskR6f105i7dktMOf5VbUTytf0Pv3COQhRD/1Gn2yzx/CrvF1fySbGgF/85DAT8kU2pYkSp8v+b7mtZQ2HlSZV7ZStMgugNMfvHh2HGdv04wQr9Ec3UofD4d9O9EnzpPKHCB50aahuEhMJTfOdNQfxCyOhJRoL7E0u/r4idKAzEeoXlI+bqzcU01V6j+NelBCztIMjppvazNAJ0gTGvLPI9mSmqCmsjf/qDQkKjej9jCfGVTYosrmMwfPIVIRN3KseOi0kYXxfBQSK6Vy03LlQ0Wq9Y4FWu45AozDycHzICDNxa04obZuOVqpTYVxshbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNGX5e3aV6cOrdcbKTmQ63yUHmkDHUetnwXF7BAr3sM=;
 b=YW4ITvdf+INJ4/2Dz7aQHnSa4DTx8+YR/bUpnm3NABDX+aSGOoNw3WrvMCehdXT6zyZONeDRs5yhGFxAFcoRWTVfbRCPD4vs9ej7zJGJNEqXIJ2mdYO95lP3rteFJtl/uwSs/+cus6pvlTLpwX5G59OOUJsSza6kmnu30MZ4+ey6Bm7xWZVoPcafRW3SSZ+pTy4yThe40Vu+umkW7FUcwEe/XEBQbgKHzqfzzUBo2eVZvlUX5iH45SlcRcD0MdXEE45RkZmQcgsJSFUKj/gEWltxL8nWxfxn7zCjFh5038MNII9YeS9fr23NiTh8RfgUBVE1t6kx1WnmebMDlnsR1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNGX5e3aV6cOrdcbKTmQ63yUHmkDHUetnwXF7BAr3sM=;
 b=EH9JZQbD2N/6Hk4aQ5Hx+NWKSUc5O7FHrXBclBzm/0gvPB4q/QgyNw2B9T4ePqBxSvQ2d6QyJNZ17zCqVfPTfyCXhyp5OYQq2tuXc4FLeq7Qd8gQuEIww743m5v1t0pEE8w9H3hwC07cnKGQ8PySbAfPNKBYodAFNzcN8B/DjKg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Mon, 23 Jan
 2023 18:45:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 18:45:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next] net: mscc: ocelot: fix incorrect verify_enabled reporting in ethtool get_mm()
Date:   Mon, 23 Jan 2023 20:45:38 +0200
Message-Id: <20230123184538.3420098-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: e0c7ca8d-636f-4918-710d-08dafd720d25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0YHdgwClFLhUc3wZqC8kNIk0oB/bnR850KnfUWTnCjgvwrbw3//sQ8UjhRdsTV4VDHSStHvnRgBuL9gwjCCnC+Y9AtYvCdijSwI2N65ESiZV7bdt/iOzToAwfLWNHj8CoKKE1qdywpaKd6SB9OI6Unvj/Nws1Tu/i9dUab2J4N+Wc8QyBzBk3iZ+LCRH/eWgtN4l1WaC8X6d4yaKGlbbwSDQPscC6e2banaPnnHLH7/0sgTMerWAqdcM5q+A1Z5T5VxPoa5wwy7NrIl6PRYzbZRPx59cxYC7aJKIFqIDAN8LNLKBdR8WpKfwngtDGbILRrrOnWxzIUn/vhJSXo7tBgXdJovK8yV7hn+YmEZRhrLHZnnXvBnPWcVNAIM/ELKAdCYPtb74PwRSKkX9Y9sz2ajqjQ3fhT4/EIKlcF0ZP2sfYCpKH0vrHMp2EDCZi7gkJ67VoHdTMW1XFrl7kns5uxIJRGWRWs+tzyOXS2dS12RfsAq+wK5apOH0HzKDZiQ4IfWQTAgOTzbQsb7G4y1PVMfUgdMRAakATTNLBMa/2u5ZDm7gtCEZmdsXPAnywFh5iocg0tKKP7lBaTnx2g3Vf44UcOZhDHYpHjBkCioK9w+NRCMEVK5n4vLch68UeLEqw4Uu4WyC2K/io1wqyphgZZx6nbJgn4dMwYG+W6ESzQ/D6L8UxRfdj/LU7LE26g03GW6IwvYdYHtVuLPOEua+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199015)(52116002)(478600001)(6486002)(54906003)(38100700002)(83380400001)(1076003)(6666004)(41300700001)(38350700002)(2616005)(6506007)(36756003)(316002)(15650500001)(8676002)(66476007)(44832011)(86362001)(4326008)(6916009)(66946007)(2906002)(186003)(26005)(5660300002)(8936002)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/iSHZbWVxpPGHPch9Ka16Hkj6L5BXiSA+bjJbLX1d/fLRrh6fqYzPIos8Iao?=
 =?us-ascii?Q?jDhmtXLJ0HVoPg4iLK9Pa1hmEpGPzo4T23Q55E4K/rsJleXZCblZhReYyvZM?=
 =?us-ascii?Q?Hn70XHJWQUaqhfoci/SEdoOZhInJHYdcBjJt6z7Dsv8e/jEGVfeaXllULZD3?=
 =?us-ascii?Q?9Zx8MKRJYsVZT+CFBfAl85QJmDej5Z9zD3w1blL5NgN4N4et2TuISY/DO5/I?=
 =?us-ascii?Q?rzFC+Q3VfAhBmZgmag4h8AI4RggnwZROj1Fm4tDhW8s7QXGSYHA8Yrq7uDf9?=
 =?us-ascii?Q?sqEu92R5006am/JEfBzrBQL664C2ITGUqC2+tVBm4eKF2Ark25Vs3rF/rB+Q?=
 =?us-ascii?Q?wNkvxQDb32isHa6ihYr5HW+NCi10kbe81pYT5366d3844owpjDSw4pCi9hpz?=
 =?us-ascii?Q?wORTVmyV1mXifeiQyFqrf3MChMsgLFevbQ4KWkPRcEogn0+h6dsW5Qwx3rbN?=
 =?us-ascii?Q?wXgPDnhcyOufpaBJF+GtGEvb9FNwwqxYId2MSKbyyQFdHei/KJkzH5G/a6oG?=
 =?us-ascii?Q?9xvXApnqDcBXxZdzDljQV4q61sH6MO9QOk/s2hCdGyk7M9jSf7oeHKgXjd0b?=
 =?us-ascii?Q?TqpYVQYSIokjX1TSWuPeJdCwOssc3WKJKdvETnJh5bRnVQfJHY54dWJh/INn?=
 =?us-ascii?Q?2YkwsT/VrOS+7/N9UuzTlESpj7HA+kEft1APQ7uKyR68mVpLTmON8IXMvE8K?=
 =?us-ascii?Q?Y0qbkWa9no/c2xPVz976m9MVVzYHnCBwVZQdA5TU5tMmw3fkE2lXPv9sXf14?=
 =?us-ascii?Q?2NcoTH/NK0kbuAy6mtyeAMAP1M8cAxVQ5faYX+JiwEcaayERTu6Z7t5YDshj?=
 =?us-ascii?Q?UCXI5QaZ3YFDYz7+whUyAP2NrKc5l0Qyth+Efr44vbaHjgKYR/F+fqoYNMrQ?=
 =?us-ascii?Q?1xxb/kzjlYrMEnqs04gYHBcaAat9Ug1f1b8ALSLBSm839EV77VTAT4bJQkZz?=
 =?us-ascii?Q?rsyi4UVJ8RT7l5zqkw4A4BFr5mLrR8RjAK4pwiR2WUEwDBd3IjSB0/AdqQ2n?=
 =?us-ascii?Q?Tpeq2D1zKUmsTjoJufpnbsImT+quF0+jjpGOZ/xv/APyPUGNCj1DK2IAs5WN?=
 =?us-ascii?Q?/ElYKPKxAf97hA4Ve8kr3+7CM893ARB2hzY3a5yQovtZn/aBl1gMKjPYwZYq?=
 =?us-ascii?Q?rHakyyXZ/efagLMcJTEMvG8OqPZe5wAwZSnlDPCqH0Oi1W0rPuQowm9eJbSL?=
 =?us-ascii?Q?rNk7ordLkVD9/Rz8fmhjypn0h58oCDpNWXgvV+tPR6Hnxd1rObTrVrWKUK2q?=
 =?us-ascii?Q?4YLoe4i7CBB7aK1iwpxRWlPaQ3TcUkx/qmAsB4rTlqGpQbrg0ZEMCYAiqcID?=
 =?us-ascii?Q?QNAAoHOIvgIx02Ltz6MbJ3kOCOEHcqtI7dk2IEZ+E5ucMECOzzctnBbyerfy?=
 =?us-ascii?Q?7T9RKqvyO27nREuH0HpdKYME5UNYJ6wpzXpq+GT1g778ObRM9FVAuC0fjrtZ?=
 =?us-ascii?Q?SC0KKwtxYMeZ2cx2bzvUrRKPakiIWibQayrw8WEjSpQqkR8A7zX7YHhNiKnX?=
 =?us-ascii?Q?Knqm2d7KtQtILBcrl1jHh7lif53rfcaqLfR90HLDjNfZNMoZMTpectnQuohR?=
 =?us-ascii?Q?jhbEQKtpHEiH8JvccPa9H8vTmB/UrrgBHa005G+g4ISnVEMTmZBM/fgMKAKv?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c7ca8d-636f-4918-710d-08dafd720d25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 18:45:51.7659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAlu5YUB2w629N+WltUbIblAG+Oa0PAzz+vE27MDvAj5RFxl2TyZhP4jtqxBOLzUCuX/jsMEANvXO/drwjJ7SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't read the verify_enabled variable from hardware in the MAC Merge
layer state GET operation, instead we always leave it set to "false".
The user may think something is wrong if they set verify_enabled to
true, then read it back and see it's still false, even though the
configuration took place.

Fixes: 6505b6805655 ("net: mscc: ocelot: add MAC Merge layer support for VSC9959")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_mm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index 08820f2341a1..0a8f21ae23f0 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -165,6 +165,7 @@ int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 	state->tx_enabled = !!(val & DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA);
 
 	val = ocelot_port_readl(ocelot_port, DEV_MM_VERIF_CONFIG);
+	state->verify_enabled = !(val & DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS);
 	state->verify_time = DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME_X(val);
 	state->max_verify_time = 128;
 
-- 
2.34.1

