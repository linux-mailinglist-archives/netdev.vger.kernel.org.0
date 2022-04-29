Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962595153EA
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 20:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378784AbiD2Ssq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 14:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiD2Sso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 14:48:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2068.outbound.protection.outlook.com [40.107.21.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186A67EA17
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 11:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZyJdO0K/REaO7j4eSxazRgwBJNMPY+cFqhHDqT9HOZ1mtl9SgcCV35bMYY4NhNX6lh5fwVvIsOgYtvStcUfrTSPFXh5A71psED0AG7WlSihuwU5OtNi7/8mcLFQSmX0h4c7YyX6fSSHxdmavnS4x3cl2yW9hM1tmvm7PmGHVQozYOZ+Ow1KjUhhvFvDxMnTQ/ig+619U2rHRNs2i6JLOC25zyvNQKwVxbggmoKvcaHtJuOjeJwDlaJO1/82BGvy2QLUJ0gBRZUs/gMbyMu7qag/UXR2CxtrL5/BGxVL9GSFWg4bHctCpT1DOprN2M/2/Gsn9q4svEuNpd/ulfbVrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXNM8eOha+GrIx+9y2trvL1xy3XGZ/wTDmYkI8Yn2ak=;
 b=F+mZPBdqv3112ZXMy+rFNCQcDJXeLsRuI66RpaGzyk+uBI49I9NsE5eZUqThXMmEeElsli9NCSsgiK0PuCaKab5PzaslZImpO3wPQwMH1YYdihgA5qlQJ6LW7aewVrwD+leFmj4j4KxrAaWLxslC1nOXPx6lknyXmjoSYitS3hZA2q/u8SOXBfVMZE9fWQfTP78tqCxnsYY9i7Y86wathahZ7leqnQqgbcteNEujdEXVyfLmrykLE5VbkeiwqOCtTLZ+BXJnrz9Vy1SBBSXwkHQ8M+LITmxiVrIJp+6tYWvp1JH9US3B1BOQGcbdYeMCB+kbcJIS3QzzOfDlwNWaFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXNM8eOha+GrIx+9y2trvL1xy3XGZ/wTDmYkI8Yn2ak=;
 b=TkxRrv+Wb25CnOL/zpHvtf7dbFFillgSYUJMP7+Z6l/8G3Cv3VhnEqWaD2GOKIZIipmmIxtiQVRejPP8UMTjUj+xMlE5XkgB/tNW2oWSXKMyd4h3krt9l0lT04Pqvf9v0FloiLhlO0wqBQJNnXsnk/W7oYk4Ov2QRp34ZmzI1muGG85dOyTXZfGIn2f04nnDyjJlEWXiRd5aboKlkBG1jUIH/N1CltiggO6M1E8E5TFr4rT/Lur58QiGIdfdr/JK6YrKzMzSqZGBDBVP17FJgNh/zOThO+IO4Iyzbc0LMuiHOjC1mcJd1ZSK+5tsz1cZ1d5aGgsuLIA5q9+0mnxruA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from AM8PR08MB5746.eurprd08.prod.outlook.com (2603:10a6:20b:1d8::20)
 by AS8PR08MB6632.eurprd08.prod.outlook.com (2603:10a6:20b:31c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 18:45:23 +0000
Received: from AM8PR08MB5746.eurprd08.prod.outlook.com
 ([fe80::9dfd:cf1c:a154:9a09]) by AM8PR08MB5746.eurprd08.prod.outlook.com
 ([fe80::9dfd:cf1c:a154:9a09%9]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 18:45:23 +0000
From:   Nate Drude <nate.d@variscite.com>
To:     netdev@vger.kernel.org
Cc:     michael.hennerich@analog.com, eran.m@variscite.com,
        Nate Drude <nate.d@variscite.com>
Subject: [PATCH 2/2] net: phy: adin: add adi,clk_rcvr_125_en property
Date:   Fri, 29 Apr 2022 13:44:32 -0500
Message-Id: <20220429184432.962738-2-nate.d@variscite.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429184432.962738-1-nate.d@variscite.com>
References: <20220429184432.962738-1-nate.d@variscite.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0049.namprd04.prod.outlook.com
 (2603:10b6:610:77::24) To AM8PR08MB5746.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d8::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83da2b47-48a9-4aee-d4a2-08da2a106b12
X-MS-TrafficTypeDiagnostic: AS8PR08MB6632:EE_
X-Microsoft-Antispam-PRVS: <AS8PR08MB6632903850542D5EF7D5278B85FC9@AS8PR08MB6632.eurprd08.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81jXNoZBXWBI+zlm3ZJqC67PQ3fuPGW2yi7W4ITZWqKQ/vuUHf0rTMXnhI4iIIgthTbHmnDjKnyicZXc0AZfbAYSsgQ6TFSjUvoOZ3i695nvW+bN3oql+tpDRe3DKXed3z3KZgBXhCtj2BrhqcTNeZtB9KSmGcYTX6qAlMSzCXUPEjJBTJtpI6WzNp4VhXF6eB3DyFHX+w6EDL8FO8woYvKCBXTZ1Etsz3KSgh1eJvEpVXmwpqGTq1TrT6AS4dkCm3/sjHFNLQ1Z3VWgUK4PUf09/M+n/rgeFKoc4ZkPimyfz2+DhoVZ5aDUSPHNTi7Cn5RKoKxbNvO3tcjnWruZMI4MCTOfhMrCR79CE+k++jPFdlrKD1YKDMLj5lnGeuDXujoHbl4wJ8RHhSVryE9i4PuEmhJsRSnbUFXhSahjZzXqEFuWQi2fAf9oyaN70Ib/YobhQbY3QN3LOGUQLdpyWFb6GhlPhRwH3SH1r7cj3d+bjoGhS3wCveVQdHb/tUuFQY/RdvzFGZJiAgUsnTALeQxgbvMFRJc22LvzKJkNq2k+DXeDxbWqCCRc2r8xNqAh+Sw57MBc4qBVGNl09HLCGTDav1stMNl9XZvyXGZwlO75HthsgBagjeDDVBVHh1eITahm8ZCJXFPX/iFD6A7M6uUzXNmeMygFPZO0X3dDNSCWy5FARJCSa4aT0f3eI+J6sjRDDzzsZrXVBdpJNGgovw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5746.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(376002)(136003)(39840400004)(346002)(396003)(86362001)(6486002)(508600001)(2616005)(107886003)(1076003)(26005)(6506007)(6512007)(38100700002)(38350700002)(6666004)(66946007)(66556008)(66476007)(316002)(2906002)(186003)(5660300002)(36756003)(8936002)(83380400001)(4326008)(6916009)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6WMWxTq87pCVrAHSAXweIWmwIj/hpXDHc3ZwnZFz0V5u/3oQF8lBm4jWrGNQ?=
 =?us-ascii?Q?jYLs4zGaxgt4f7cLO/uPs9ZcW+CH3QB1V+ucUcH977DA1AAyAILzp1aBwkM7?=
 =?us-ascii?Q?7/e52/krMx8ObL9wf5LDSJjKPBtVsUNw/JS1Sm7iG7MMjIhZDyglPVgWwVlB?=
 =?us-ascii?Q?ufS2XGSkYihkhMmBqU5X866tMbIJThCIRV2vbzMr0uQfZjhCxp5v/R+0yDu6?=
 =?us-ascii?Q?LTO2sstErqQOS+cmG3W6IM9zrL0r7QLxsXiu2j6dShYwng9QSzoZoxUAq5BB?=
 =?us-ascii?Q?8KV094UZJzhIgZr76zToiHmpTq/3icon/Yfq8sNX0cIupLapRqJj72pumTRx?=
 =?us-ascii?Q?X8ebIDfM4Pn3rFcj8jnbf761maoFG5y9+iK1Zhxijc06pz2OIUp3F/v44euq?=
 =?us-ascii?Q?4AghEpeUAugdxj0Za6qbk0n4hqrl9jIu7+neSJw4rsxZt2KNeaJjoTFqbu9p?=
 =?us-ascii?Q?RoIn+945jfZ5Rj/2ykbnzuwqE2tsZr83jO8uobdzObhzs8BS7MS4eZPcWkvL?=
 =?us-ascii?Q?F3t+MN7exUn6xP2/8Gr1/iWlTUV7jE6U0QNB3sos0rFZq2LvuGnOe7GfN30x?=
 =?us-ascii?Q?gvYfjdgI7BMo7CsyeMAy+2MJLJl3JQ9X2BGNnujDC0eCx1GSHLtuGaqDH8Pc?=
 =?us-ascii?Q?yTEGQ8Aauq8Sv26nm5OVApmdjuM7pY+JkFBYOuxKLdOchmotD5vU8w5jFkys?=
 =?us-ascii?Q?HMiVdfu1lt09Rtq03HlRv9GX8VKcHGniKMQXbKtjhXWHmpl2iv2mnGw+ctsd?=
 =?us-ascii?Q?L3vWtsmhMTmHoGP/9cfkOATGns9fyGcVz7bjtfW+JZSq/BYJyDe09D5ajM//?=
 =?us-ascii?Q?zc+K0JWSwwxaSsXxLn+e7pvNpQZH0HrSB1BkvXfHxf8DIkKhDMPZYf4dlUVd?=
 =?us-ascii?Q?0MnaJ6GIUdnW4QujBttEsYM1lJm0DDHVBXu6urGU9dgs35sex7xsgIsQjuov?=
 =?us-ascii?Q?saO88Z5fmPtY9jT6bPWpNAq9l7Mdb0swy3IQ45RCzDud80X2Pht9vVDe0BaR?=
 =?us-ascii?Q?TCT6t/Z9SeRuKVPbHoOU3+50Hu8wi8vHdf7kqZyJpRpfz4bz7B/W6RVHLL40?=
 =?us-ascii?Q?zHADqqjyx79jJeyX+ukbNsJnv+I1TjE0Y2YRr9efQG1/PqvaXbh9kuMwW+gO?=
 =?us-ascii?Q?/hK1lCmzCh4Tv2jJ/9PX4e+6xr0OzycISyDQao2DacYmsfDnInQEy1lplmy5?=
 =?us-ascii?Q?FxrQH/pTXAVOT00y7tI21A4GFQV0TiFsjK2Tcma3YXWXzAOWhesQnndsLDn+?=
 =?us-ascii?Q?Wdfyzd7gqoFPhv7l1pEyexqTY0yspnVkCZ/g9Rtsdufuc8SzNJAXGoKwET5g?=
 =?us-ascii?Q?nM/Pw2iPggF+te7sckB+2QNYcvx/Kpr2wwCsEPnF1eLJgzpSfWm/ScW8DUSp?=
 =?us-ascii?Q?Lc5p47UrVREUr+T8eBUMWExVDJAom6s2zLcP1EPRszpaRZ3D0s/WH2qaTNxc?=
 =?us-ascii?Q?m1Ft012ahay4HPbzfe4OdjNkP04VoCVqRke9B+x648F7JZyUVk/Gs75dJscN?=
 =?us-ascii?Q?C7fMG4cI8fwdB6Po/Zc6q/jEGAqnC2A+m3mW5zWvViX/Eo84mLTAtFe6E0Kf?=
 =?us-ascii?Q?wAY2X9H2G05TqVvYHL3hy41ToDPoF5srdUbKXQ61A0IwuEbrO24K5yLleUGk?=
 =?us-ascii?Q?NjO1JNt+Gm+xd7t7KRaySBQa1d7XdDUqflZSSx/i+mGyN3Oh2yM1w3CKwddb?=
 =?us-ascii?Q?5SpDLy1EYSUcLKvEgrW2C1xU3/WZDQeL2LUR56lLrxC6iyM9UKl8nKNpbKOL?=
 =?us-ascii?Q?yfyVD+QrRw=3D=3D?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83da2b47-48a9-4aee-d4a2-08da2a106b12
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5746.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 18:45:23.1367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDU06pwyls9v+/pWeHP5DMJ8KQ3V9qhloYUsDHWNOppXwAaHJBTJfl/duvzpYA0QBREGjRhXb0sbkApARN+nCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6632
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree property to set GE_CLK_RCVR_125_EN (bit 5 of GE_CLK_CFG),
causing the 125 MHz PHY recovered clock (or PLL clock) to be driven at
the GP_CLK pin.

Signed-off-by: Nate Drude <nate.d@variscite.com>
---
 drivers/net/phy/adin.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5ce6da62cc8e..600472341cef 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,6 +14,7 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/property.h>
+#include <linux/of.h>
 
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
@@ -99,6 +100,9 @@
 #define ADIN1300_GE_SOFT_RESET_REG		0xff0c
 #define   ADIN1300_GE_SOFT_RESET		BIT(0)
 
+#define ADIN1300_GE_CLK_CFG			0xff1f
+#define   ADIN1300_GE_CLK_RCVR_125_EN		BIT(5)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -407,6 +411,27 @@ static int adin_set_edpd(struct phy_device *phydev, u16 tx_interval)
 			  val);
 }
 
+static int adin_set_clock_config(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+	int reg = 0;
+
+	if (of_property_read_bool(of_node, "adi,clk_rcvr_125_en")) {
+		reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_CLK_CFG);
+
+		reg |= ADIN1300_GE_CLK_RCVR_125_EN;
+
+		phydev_dbg(phydev, "%s: ADIN1300_GE_CLK_CFG = %x\n",
+		           __func__, reg);
+
+		reg = phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_GE_CLK_CFG, reg);
+	}
+
+	return reg;
+}
+
 static int adin_get_tunable(struct phy_device *phydev,
 			    struct ethtool_tunable *tuna, void *data)
 {
@@ -455,6 +480,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_set_clock_config(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.25.1

