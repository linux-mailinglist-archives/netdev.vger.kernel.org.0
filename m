Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B788D564B8F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 04:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiGDCPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 22:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiGDCPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 22:15:48 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80051.outbound.protection.outlook.com [40.107.8.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAEE5F94;
        Sun,  3 Jul 2022 19:15:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OS9sUOjno75rVMcQUjFizZxaJK6wTB32OMYWQVD3rHdlMYNP60Z9356iIyZQRGkvv2jNMwdsLRc2EXzb0AQZHaSqDDR7zco9Ylrx0NBbXdMZ9l09zjgQirWDHnJBariYZMyA42SEknyjY2qqdWiK5kJh93d/Sd54KD2xIhIF/q2RUG3oD023WB761kCh1zek4r8qqHLROozuUvTZbCmFawPEr7nz0tHbVFWrIJbO5yFKcAd3YwDCyxr/IqeZBth5gWbwK+9uhoCPXttIc1BCjxG/NTODsjGvPtVSID6Nqog8fTfprmFf/s6kAikDihBVR88ObLw/oAu31u9Ykl1Dzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGrF0DxaGlMBOS5nG5sqVUP/AGgWdaaCp5voiXUzVc4=;
 b=GictaHL1TiZeQKBLBGfNOb/lM3InFAZJ5c+DVeg956i0C+8q2JI79dlnS+H7T/mPVl28ryxGlzsCtXFkUohqtz5AuZcMTY6Y/2sBFZysBdVsXrVICUNCWaRvabxvsuzPfQ5DE/ApmlPR4HOSDpiZ7XaGRFzOIU7FIe+DsHU+oSeFChbUH2w16NCVrq/GyuXcQNFLmHKTb331snplGGUQZ76vZiZpqkP0/2dS70m+mfOKJb16Jy5+9/DlwmzA/36c/cUYhIUz5I3pa/1yB/UG8dCjlu2CHldOdVX69+QXIzagMq+nY0Z7/2ewwtOl6JMzxWIhqSFNXhg3siZ3LXBuIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGrF0DxaGlMBOS5nG5sqVUP/AGgWdaaCp5voiXUzVc4=;
 b=cFmAJNLXFrmfabRPL07Up7FBMp8UVGNcYuNgbObdzEcOAfw0u8KrHmQbd1xlbu3FXH6WFTb/zNQOAk/zhdUy7WMi4ln/PvrtQEC4PUq9322nUbggrNpZ47wqKvnrI9+PyFNebvdguiVv+lDUjeatndPoscBbK6mm6FsgQ+e81ew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6819.eurprd04.prod.outlook.com (2603:10a6:208:17f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 02:15:45 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654%8]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 02:15:45 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Date:   Mon,  4 Jul 2022 20:10:54 +1000
Message-Id: <20220704101056.24821-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704101056.24821-1-wei.fang@nxp.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0155.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::35) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 436059a8-7055-40b6-5193-08da5d631a18
X-MS-TrafficTypeDiagnostic: AM0PR04MB6819:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kjCWRdzbOWv8t30WLqr+HjIRCQyBOyz08NycHS2osb9/LrgK6Xd2/9bv6py5MsX1QTvWLWHEQFWYxO2aLcHO6gJ79UyCoKVDTkdOIq4Xy+qNWEBm8tQNAWhl/JcU7vE6P4UV7WKILRq2/5SEOBufHJ96HatvmXAq/EZwv031k7/JeL1q3e2wcpBrrhcTZMJDLIFJVmhV9vZhzi7I6LCk60+6vaj7fNqFLbFWgrX1M7v7wb0JXxnUrUO4xo9XgN/FhSdEUkBgvA2h+zcagSI7Fzbqyq+lpIfgzS7hzbtoSz485YeDwMtgUQYjaBiVlUXhqjUxdMo6l2KLF0DRNFsjOZyeKnFFB+xDvVRZ/TvjTAu822fm8mB/XzLGqVwaLFA3y97BFvPK54z0NjMb1IbdIG1dAI8M6EAQlmuyg5syLJD0oFV68n3ZgdVSamr42Zcz4kl7JCb6yJGZybUrUF/gpsiwDkKAwWT3wC0MHPy5WLWVz8z00rIQgSgS3AwwQSawE8nb8bRfbJVWn8CZ0o56lsoTq9W0D4PGqartOqEsQKl2XsOwdVXVzLEnv84IKGaphCrgV1tXFRz5hKFOCQlAoT1ypmDU/4piH4w8Kbz4QzP7NCSwLGzAFPhLx0qMJAmxOTYdzyhGMKxUjySVRFgwtsTo1QSY4WvYGazY8peniwg8zgKyECMzAlPp/Hg7Rd+iFU8a5v0J8cLSF92MYVK4ZNnwc16nMdu1HkqFL9zYBdDID0GELER2cupXng+VQpTwhArT/xnA0n/oc1U/lKdGJtRvzGvHOpp+205GtSMcWEKFVnNz2y1ohXiRoA2SBkXe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(6486002)(478600001)(6512007)(44832011)(2906002)(4744005)(66476007)(52116002)(26005)(66946007)(316002)(6506007)(5660300002)(66556008)(7416002)(36756003)(86362001)(8936002)(2616005)(8676002)(4326008)(1076003)(186003)(6666004)(38350700002)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cXfuXLF8QnrHG/eFw7D5/vbw09U1G1SMJDLtpmJrwsiErm68LydT6UrDpZop?=
 =?us-ascii?Q?h4wJcroVsAR3/m7Nw3uWts0UHMHjiaK+I58Kd/ZA9QEQJgT6LFeE66bnTgEw?=
 =?us-ascii?Q?NCRNo/SFjXmAsAKq5kP0q8nSnJ6/yqFLKp2lAA6a8M5/TE9nPIXx1sYgX4qD?=
 =?us-ascii?Q?MGcIK7raZnAuoZWamtH+7McZGPDtC8OQbpvrb78ol9d6xt2Hn8rNbmB9xYht?=
 =?us-ascii?Q?zlgh129EG9ebmlhlDvH5FbChZJdDfzqJ1GtfNQgRCBe/hY7g6MwZy8QlXRj4?=
 =?us-ascii?Q?FxbkVelb0lNnGZCsVD0kW8tf7VJm8Bi5G8kqSXwB8WVxaZ1z8F+/1YBMlInd?=
 =?us-ascii?Q?lD3P9459RjoZhYCKgKouVCxJVhxhcKHiww6xivMfMbVq8tbc7gKTFKKgcGHE?=
 =?us-ascii?Q?jhzerYHyfmbDwaF903z3tbP/e+xp9cHcbX25N+wuoPghw09Qkw67pcOff7Fh?=
 =?us-ascii?Q?ng7utTXG7bY9+tlC2gWMj9FStich2aTS2zjfR3ja72IdTyFDCU5Afpu/P8pA?=
 =?us-ascii?Q?H+N0N28flUwI0uLYQnJ+4A3/t4zvMP0xOLa1CKToCgbQVl3n7oNDssTukXvd?=
 =?us-ascii?Q?SRfVf36fFzNZ4MrKJvKAXtL5iDjwWb2MBMLzEXinq7kippXC0SNmk/fxvG92?=
 =?us-ascii?Q?vdQ8fCMFvGdHG8V7amjZae6rXOvnP3xC49sSth5nnh34oMfYQh811BZxxOSX?=
 =?us-ascii?Q?YsOj6A5wtR4OHKOm5erg9ECRgnf3xsuQdo+gbzXcMVxhrB5GektREZNEwi2c?=
 =?us-ascii?Q?G002T49E4f7P849HhRP1FC0PX9vkyjLcBF5sf6wS6nG7UZrkJtZxYhlagdF7?=
 =?us-ascii?Q?ZfckTRC1IlSVJ447qLsNmyQtnGvyAgubppw+0sdFyoXcpsXGD8Su4RIJqz+1?=
 =?us-ascii?Q?FWD55/0DAqPsRofwwdyiF8vNtocHPnfHBCKxlAIFNHZWBKUlY1oTHJe8UDwd?=
 =?us-ascii?Q?89Stv+fDNK1WH4Xv4dKIFk7VCaGMZwrE5uINJt++7Q16JD5Yk/sLSFMdLk+w?=
 =?us-ascii?Q?sSUZcmn/1X3C27wN3b4rS5SGJtfjKfivPfaNxDmYVl/TLj/fbEH+Jd/Kot7M?=
 =?us-ascii?Q?tCQTdvV9kzQ0fCzarzstDDY/FdY4zmCZa8BcXUmdjtGpRg6U8MOp2Bu5vrhu?=
 =?us-ascii?Q?qL0k5mJnGmbyTb9mVw2lSs/tI0fwlivRsUufuidgf0tuAQYWDn4W6QGWrido?=
 =?us-ascii?Q?gI6ss6DfWEWKzIuiF0ImWMM1f79t3CGfJH394zh4f+UREMEK+oTrKSYYqYh8?=
 =?us-ascii?Q?477sBeinplSdt+JmTTs14e9o5K1viRtrmIWJ7QjcTuzZZXgbFBGMs5/j+C5k?=
 =?us-ascii?Q?stPruGc4ahn1VJ+zZPjymfx9RgKkx1ltlR/GWDdiPJsNW/P76jnMk9pOE9au?=
 =?us-ascii?Q?hAC9b+TgQn9ffxyrmWL/lo9woSG06B7+cVuEApX1/11IVicm9kqEYLAxUnYu?=
 =?us-ascii?Q?p8yln2HugpjeLLTk55SnTPnhx1XJzDySz9nznaSbR6HUNimc5E00T7tXBA0q?=
 =?us-ascii?Q?pIjKr2wUgTQ6OAJ4u5lMmVvECSN/XrljmO3ZK6d6TT8ntr20Q+FAGG6HiIAy?=
 =?us-ascii?Q?vR2+sO2RNSsVDbcR78sMC4VGz2W76lYmAIWDyJ46?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436059a8-7055-40b6-5193-08da5d631a18
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 02:15:45.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHzSmHwqQeYBgos63fc1JucDPlyLA1ocH0HOio5nykyz+8Bbrk1otQmsF45sHwhTke4FuyxR/yZSBWDeEVHQFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6819
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible item for i.MX8ULP platform.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..6642c246951b 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -40,6 +40,10 @@ properties:
           - enum:
               - fsl,imx7d-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8ulp-fec
+          - const: fsl,imx6ul-fec
       - items:
           - const: fsl,imx8mq-fec
           - const: fsl,imx6sx-fec
-- 
2.25.1

