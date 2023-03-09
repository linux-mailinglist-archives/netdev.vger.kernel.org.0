Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8010E6B20D6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjCIKCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjCIKCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:02:04 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D33CB56E6;
        Thu,  9 Mar 2023 02:01:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSY5vh9UsW28pWJYdYRAZkZLj4S9dZ+G7zOFyY8dQmsoV7zgSB0TQ1Ii8E2kT3+WjOXhlbr+eiNtOuo38eXaV/jLVFcKo1PTYpFa8PqMYPWNwutrBefaL/FCwQ9udCf5QIf8sfbCqyr5Di80SVPWRqRH/MMG8Bi0U9VQVb5oK3rG+xQgSi/Dgo9Nzgte1qdVBWvS04fSE9XPE12Pr+D64N4u+YWl9fkYx9+1zzXIxjq1+75kxXMlnmZUGnMoZ/8UraRZDQ9KVIvqboi4CxPH3b0ETgA0tr/Y8eWL2H7CJnkqqETYdkGxwSUdyZGOG2jkW6HCXJ8yF/e9sB25vHgrVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tA8TWh+NiIWX13/t+0QMCA7HCK2nNgMciBKxvWOEtyk=;
 b=GV7M39KiM7ha4VRQVUJ+V4cjbdmos2lbj432D1Yq7/I1/SCnAxlNhbArJ2LGXzfOlXisNtbDjKoeZBw94NRS56OCCeHQNz6oVTRW+OhNPEmN21L9W7ailtLKWL2+siEqlchEa9QBV94iKvWuFyXSKBwRx9iauyvcWL5h8BaLCTv2jy9dfNqCYMUF+pJV8PY7cfZ3D4Mjc8fr0e7xNUGcyKAm0vnyDzeQ9gccN1+6s67nfwIYaiCegRoVO18Y69k9EjILP0xMMO9QRpQfHOJYp3INPKbysvUK6AbG3IjIvarXgxbv7a3VFt+yczm4f7wQL3dQQPobRpuAbuMamokO/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tA8TWh+NiIWX13/t+0QMCA7HCK2nNgMciBKxvWOEtyk=;
 b=UgJDvQXilU8cTLR1avYO5hCBfHLP1cuRrUfeiuSLBpKLMOdd7iJ9OhFv9GRxEB+6Xoy3X1pMglRW9YRAVtwfuyeiwk9IqH1OarNpbu+1eeCT7XY9l+5daEPV1Wj3Yd21bsvk1F2mcN/MJYHW3Wp97Q0TwxFF04xBXmnpdp80Oqs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by DB9PR04MB8396.eurprd04.prod.outlook.com (2603:10a6:10:24a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Thu, 9 Mar
 2023 10:01:49 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::ae5d:59b0:7707:e5e8]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::ae5d:59b0:7707:e5e8%8]) with mapi id 15.20.6156.029; Thu, 9 Mar 2023
 10:01:49 +0000
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH net] net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit
Date:   Thu,  9 Mar 2023 12:01:11 +0200
Message-Id: <20230309100111.1246214-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::39) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|DB9PR04MB8396:EE_
X-MS-Office365-Filtering-Correlation-Id: 7faae0e3-7963-4dbe-86c5-08db20854cba
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SwY4a6E9BD3MHy4uQFP4xZi0rAaMHTRxT0ZEhAj6jsrjs3oCfB6TC636Ibbk929Yqx39BL0HmFxR+aSytSBcfDVkpr/HNGd7O8Scv5nKmqoCwUZio2S8nRJ87kwKN9w6Zn6xrYy4ybD9T7i9kmCRjbrkXgwBrZKMULrF12BKh5g+mmDyYDvty5VXBKup+1R8LAbH0JiTNYuUBNxlrhVJ/NP9OfqYkqGYiVEEG/kpGRwqIZYOnfIF0XvKXSBI3ji9oR8bwDqOQ6x7j0DQKAf+sE2DClQ4DK0zLIzzBoV8WBPkhVVmEeyA3oMslNrNV6hxiEw8slh0nQoBdjkSg4SVxat1/VJd1sJU2tDEnzINPdyXlBvj4KQMs0OrvwjqNjt7ZSUpTVJHFLDr3B3ioWyOQ53n7KWmxL/Ot0R7usOrYgR7Vekhg7ev18m9FVKJ6tMm3ZAEGHJnzCxrRdzg0PfzBnEoiwwxXOY1y6+N9ZzVJqNM6tpRiE+S22Ae4DXK/mRglMCICFOQIvbwBaR/x41/DH63qRwomzkA7vaARjjZLnNKTsdnzwFMKaa2Mwri4HEFxv4qSahF5jpxT3LYrREr5VPYSXKjyHY+k/hpdfa5SJtCUO2oQMRKANIn/lPd98ST8cTN4B10+gqgDEKH/cW+UwhQ9CFiGJUdPTyAkCUS7t5QaogfjLGtt39PKjqW7nwYjz0sE/fmExNgKLTk9E03w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199018)(2616005)(41300700001)(186003)(38350700002)(316002)(8676002)(66556008)(66476007)(66946007)(55236004)(26005)(6506007)(1076003)(6512007)(52116002)(6486002)(83380400001)(86362001)(38100700002)(4326008)(4744005)(7416002)(5660300002)(478600001)(2906002)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?whYuJvpPx0BTc5ic4QHcayE5yi1+27UiFWRnsQjhlYn3ClAU3Aml2Lqx6ymt?=
 =?us-ascii?Q?OU8WHe2Ha3LDaRwlj3HdG7ftZBo/huS2eLDaPw18z/BPSNo4O0dGEj3nUWBC?=
 =?us-ascii?Q?qdcnQ5Ft7cafJ3EEb317wWxZ8x/yudpywoDPr+np23LdX1hjPznZga+yEKTM?=
 =?us-ascii?Q?n1eEb7EzhXnRT+N77W9gCeG8yCemtTEjd//dzXfLUT/iQ5Iv1PzfZ8gG/TnC?=
 =?us-ascii?Q?fvJ7ofw2sn6kO6HFHKe8yrY3S8JyYIK/a0Isg2njet79QP3kZe7T1jSYa+2j?=
 =?us-ascii?Q?AjNYd5gh94N4Me1OdflYvvWsVY4FGPxfFjGqENiR7UGbX8QJCpzlRWISkr24?=
 =?us-ascii?Q?r6aDNmsRO8ejQk5YbdSs0iTZOyuQZdEyzmm2QpxDwNdcR81OpeKIV/TvIO2k?=
 =?us-ascii?Q?W1nUP268r1jDp0cdhK9hkGIeOIZDBhYVKrg0JyOS3Q5s5Ak+4335K2cvwjBM?=
 =?us-ascii?Q?v6gBME1MoEioZO62NpJyhTVaTWn2+kg842iBtFYQcTKvIEizGGUw+ILIHa8/?=
 =?us-ascii?Q?zQloZFGXg/r07lbeZ3QC8H4YKeOnQ6X36PARBoMk/JMlrXFxBn1YzeECBpT8?=
 =?us-ascii?Q?x3vrJbiCgyGs0MYtBCUTTpgj3qfc+FzBqEvVUbOrNHZECVhK6GdnPOpy0BE/?=
 =?us-ascii?Q?9CaZ9DZNpRPJE8Dfb9r9fYv3ODSZUxUf5bQM+mJBz/6s2hy7qC/M/hCgqo/a?=
 =?us-ascii?Q?FjFWdaJrE+GW1IXyHIRDlYnQ8Ith6PACIOGJ8e8rBQgO3VEmOuezULs8TcAm?=
 =?us-ascii?Q?jE+STZX6/Qv0V0fhdj/rPxcayaUdpwaOoTq+F4j8UVscdIXMXzj00EUUOYo5?=
 =?us-ascii?Q?9AFpyIW6/1//JtlT3HvjchYLOoeEA9zyXcD7DQlFVO1Ox9DCp6aEURdC3Wt4?=
 =?us-ascii?Q?2IxvjOgsG8Awl2ZQKqKIX3u810IoIuhzp9xKEOBYyLmhXTha/gaP89rp5esh?=
 =?us-ascii?Q?WjKIxNgj9Q/cwtraT2eRRsEGvymkkvMOtW/ierSb2gqyRX3SGgaLNBdQpi48?=
 =?us-ascii?Q?+hgXnRlaoLhvijP/JLE1zEl5qQm5R7qs/1i/jTwLOR5fVfs8nGu2eWvvg6zv?=
 =?us-ascii?Q?tDY045qguE8+A0sYRuzLCFoGYXTw8wd9p3NUftjyIibsvhieW8Fgnxhpv2Pe?=
 =?us-ascii?Q?iVy5oOvrMqB9GZn0756k/SHTdgMxn1FLssqFtrVI7jhKj4xuNaStL3i/BkhM?=
 =?us-ascii?Q?h3k52s/CmEd6r/NChYfEV4Y/dQ+tYKlSj23x7neVdbHZ5MEwCkNFBZ4wFArG?=
 =?us-ascii?Q?9vPfWeaPsPeVRKeF+IEdz4iZqpAUe9/VGexyq6xQsMep2N7o8Vy/KO8yqZgF?=
 =?us-ascii?Q?7o/mu3A51Mh+VMnk9whNGKtCb+KwL2G/tR05zCxlGodX1pJePWfXDAFaOY+W?=
 =?us-ascii?Q?7/wh15ABsMb5mrX+iDVN/GcnXz1C3rlQyr5hMXGOU8kMmWXKH2DxihMFz6Em?=
 =?us-ascii?Q?AbTDiv46EX2M/LlIlSUS/w5NV0Z5UnukHi5YjMtmBG9gF+brI8Pi8WKQGnri?=
 =?us-ascii?Q?htryxXXHFsewSKlu2sdovlm+EsSNeJONqLOWo1novAly+KeMEd8njzr7WkAE?=
 =?us-ascii?Q?C7mkx+jjjudtotEJCCDAq4+gGaKw+COZtc6NeTavwhxzZDT2PWnxQedzy5m5?=
 =?us-ascii?Q?1DvR8YI5SCKngK97z0UljM0=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7faae0e3-7963-4dbe-86c5-08db20854cba
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 10:01:49.5900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w45ncNYmJLFctoYVCBLD3+8zc4jRNZ5n4IiWbu29gL5zuTJBbVc4YurfVESSO5VGXaCmMkMc64Cf70ha5pB3d4vu/9naGqsWeNucxdDpxMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8396
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the TJA1103 user manual, the bit for the reversed role in MII
or RMII modes is bit 4.

Cc: <stable@vger.kernel.org> # 5.15+
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 047c581457e3..5813b07242ce 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -79,7 +79,7 @@
 #define SGMII_ABILITY			BIT(0)
 
 #define VEND1_MII_BASIC_CONFIG		0xAFC6
-#define MII_BASIC_CONFIG_REV		BIT(8)
+#define MII_BASIC_CONFIG_REV		BIT(4)
 #define MII_BASIC_CONFIG_SGMII		0x9
 #define MII_BASIC_CONFIG_RGMII		0x7
 #define MII_BASIC_CONFIG_RMII		0x5
-- 
2.34.1

