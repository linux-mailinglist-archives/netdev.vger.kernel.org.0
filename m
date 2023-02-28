Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC106A5AFB
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjB1OnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB1OnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:43:16 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2089.outbound.protection.outlook.com [40.107.6.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6163911649;
        Tue, 28 Feb 2023 06:43:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obvBcmrUa9oWoeMqCG7vsJkD5FLaL1YB0fZyuY672+4fCjjfqFWyQAb/thKQ8uzzpZCdfkhms7v9SF3vYjXZawD7xBbifj5VEN+WvMHeKawpdvJKZsQSz1Y7LeZNCcYr+hREwq210ACCIq4w3tK44OoJpubdo4ztijX7S+RFkygKL4m3I+alYeeMSLzRheE1lzI0U7+ij7ZA8xzzJgEgGMZ0iT3eddvUiJGlDeXdjD73+NBjfKwEbbWLpvEbNrLZjPWRTxyQ6EbYtgQ6F57Sik8/gqAbCpFxPbZppBtfV9zJNfZ22ekqy3BXs/a9NsWZjG44XBevoItNGUH+fqUaMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLfPRn4JhZMfiq0FffdoVq7zpCN3dGNvbXvntUsg34s=;
 b=PS8xRIVmg/yF78gX9XW+5dOM3EN/nMC0uVpMynMmt9uGGb1kfPHCwQdGR8ONcRa/Ciz3WfbqwnFF5jr61rAn0tTRbax+UuGOUGhlzuS01sAn0MeVq9Ag0AmVZiRbPAe66ZK8oQGpK29iv0CnZwjI9zUmhgLYhMzzyYGL+LrQoPcoltrWXHYc4dRCw/sXj+KIK2OT8TdBUN7bIlfAX9tIxF2adioyXHxVb2UqUa0H43XNufwrk8pVtp2m5IABrtPH6Bpyz+2qH7gkkeqxA8TYzGMgR38e858Rih2Y+Z/VJvG1f5Y2mn1NFpgd3KlV5Cfs5NBB5knCu4OOCgU9Hz5q5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLfPRn4JhZMfiq0FffdoVq7zpCN3dGNvbXvntUsg34s=;
 b=GY+B2UolpuGCLSYjuvkBSX1Uk/avySzhxRzD/bJbmFaS5erYHQoX9tUSXHrPMd8f6l0sDzXbrytP6cmArPQ7dSfbCVaZw2kKVB+O29uKhpuM54FEO9vrjWRIEhbDDWL4d+BwBhQP7STzfrK7ipUp0aOaW4Mpj9BdvsKy0vD4uzSjTrFkf6eEFirBgQYPt6CxWxNs2o1CYP+6n93zwSxfFxV5LpoRVLZAjfG7L9bRTfLuF15sbfG43vnUcaBpjTWdmcR8lCqK0+IuRRAmt65gBxMbnKwwUVflMA5TqQgWC6Vovu5sWF3e6dZoJBk1meMUQ82N5AnxwfX0LDXK5AFEaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DB9PR08MB9852.eurprd08.prod.outlook.com (2603:10a6:10:45f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 14:43:11 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Tue, 28 Feb 2023
 14:43:11 +0000
From:   Ken Sloat <ken.s@variscite.com>
Cc:     Ken Sloat <ken.s@variscite.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] net: phy: adin: Add flags to disable enhanced link detection
Date:   Tue, 28 Feb 2023 09:40:56 -0500
Message-Id: <20230228144056.2246114-1-ken.s@variscite.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0184.namprd03.prod.outlook.com
 (2603:10b6:408:f9::9) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DB9PR08MB9852:EE_
X-MS-Office365-Filtering-Correlation-Id: 35137c46-bf15-45a4-5c07-08db199a1d7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GziSvQcika858eIcnS4wEUos5/m8BJYWAIfmWpPlFIj9aPlRJM/qhxDoj3LSyLOL/q4K+FgS6xAMuM699c0M/pwmep09OE+qcuHl/x1a72FLVg2DINtv6x/3pYcCt2laoeojkvati05264OgJFO8qWmftc6PwM/+26CzC7qZ8e5Ry9tVkGGtg5BwpA+OIy0OfsFNayJKbgzHo7edYj04Zt2SY/6/ujR6P5Vz4ILU59j9RZkLGkQ8kLJ1dZlLnw3CTpf4kuXrn90/xjTAgyPsAOZMTmob0hKoL/kBqhDabbejmXjGe+T0rdSx/oKATSm/aOvn61ddP4ztH+Kc1LC7ZNnrTBFgKUlzt/5cDIEEyoJD2ek/p7+so2lfhSicaey+nGrNSPkg4j4Lo0fFfnX+d/gPTw9aeynY/e8wZEW8BEQVSzudKOkC1+Tk2pPCWuOGVNPjrc3tqOKPILVyDKq+j/dL6dzMZYYuJtUEiDaykjfZMEUOOf93JcAJS6+/575x5zcRLNq5vB1pLsSfnZdHndA2s1CHIao0fla9g9C3WU2VQF8eYyHOploUmO2VOk8ZAAsU1iy7kOCFeKsd6UQn66MrGHG3wAe4SG5GGnJII91TNiKdtR5M5XPuC3y4BPYJQZIHyhwWNhiR9iX6KMSuOjbJCbxrqbnet2mFW4huBmb2fEwJwPKwm0QmS0J5hKPkBYQyuxGhkx4OF1hXxhPusaIjoAiiGhlkWDcKfYf9nqg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39840400004)(136003)(396003)(109986016)(451199018)(54906003)(83380400001)(2906002)(2616005)(316002)(186003)(52116002)(6486002)(26005)(36756003)(86362001)(1076003)(6666004)(5660300002)(8936002)(478600001)(41300700001)(38100700002)(38350700002)(6512007)(6506007)(4326008)(66476007)(66946007)(8676002)(66556008)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?elgl1ktrABKgbTGgz/59JW6rnftmyEI8460Uigm6XEEjDVV4jamAdSXOlAs6?=
 =?us-ascii?Q?u6hZv+PXUmkFl1oCHNi0+L7mxV1Smvci9deZelsoVgMbubv4/uyxZKTCc7z2?=
 =?us-ascii?Q?Vg+HRHQUH0gy+m4474toExtxQPIk7NXkzirQq2lXcMyX6ypDCJx66r5cfkbs?=
 =?us-ascii?Q?E2CSRFLxiR91KXvDwWp7U4qNuY7UpQrEsdRqJay2L/vsC9LQ/KJjz2vJMOGr?=
 =?us-ascii?Q?jQtjylb925VogwCcVYaRY3YUMjhtcx7SE5H3c8FIRCKPnVi7AsmgNrtbbhZD?=
 =?us-ascii?Q?sM7jt0kiff8G1j8XnZ8a491i8MVaP2+o3K+93juuN8SihZ10upP/7ej8dKiA?=
 =?us-ascii?Q?hV5wpPW2kXCY9kzwU0YptoVwqNhx+xG4KWjYqxZQqX+JcXBqtMZXSoGxsYyt?=
 =?us-ascii?Q?i7XNl1X9XGHCYR0rVI0OB8UwPLuXjNmySRLY8U9sO68GcrnFuSfohHtMj02i?=
 =?us-ascii?Q?cdAxgsuPHxiDGPO506DCGILyly6p+6VBdFktHlBe/zs4csNWyXSK+gF2PouC?=
 =?us-ascii?Q?OG96QUpXLVrZa7uqIDE7WDzKsot7cDnKYfoEhReRk8vbpgyVANQOhT+xdNNK?=
 =?us-ascii?Q?CXcJESWCXhUA+4osIB2TFng/y7fCS4VFvT1Dl/DL8wv+tpuu5pnyw2+50PhM?=
 =?us-ascii?Q?RB+AHyepgGIVGLyEvy0SDF2i3eTO/bN0TjD1/QLhmi0BopasYqXz+fa6TWZe?=
 =?us-ascii?Q?p6xzXaFY1IqGeDPCnuO3+6hLdpiRMgLUP+8DHBjCm07AchOiHgTOeDfXIVUC?=
 =?us-ascii?Q?WGapcYZsMYeTbSrku6gp/BKC30qlbIBu7/comCh0kQ4AH3wcXdPcAiheZqdE?=
 =?us-ascii?Q?4A8PWrsZ51iIxoiQoUAOY1NW4f99QKbjI0iSTXINbP2p9/kueT/Hsk3sck6j?=
 =?us-ascii?Q?6/VqrwrUdSMiHQqIp5DndyojaptfhY5UjvvwvObZRo9xqL16jI9BBzNFUm/a?=
 =?us-ascii?Q?/NVOu9siJ8HfmYdAzmihIan4HEwrkRX28DlT0GsZWbiASj4HBdAJ8NQYZjEJ?=
 =?us-ascii?Q?QyMTDmMilO97VXt3yRWRj7fW/d/rgvYZ5/d23oM0pEemcHTO7vcDOAHHb/DG?=
 =?us-ascii?Q?Rjk3sYzbfOz9ceMzRKxPkRAjfXvBBbFMchCX0NXOpuKmlKArLMtosfKrbF6h?=
 =?us-ascii?Q?XLB80IwxCwlw/6gVbXbTpt3dH7RZYxIO/sc7P9VRColJsgkxveQ+m+ySAqw9?=
 =?us-ascii?Q?lYC0Z9gGMW/W6eo24J8+zVJ2vNqLaLnujtWi/s+JFnAZqmg3/sJk/oAYlKAh?=
 =?us-ascii?Q?/s+t3zVJ8EwpKshQvDRBFTO497vRxytQK9ztR6+uFSA6Sl7QFGKCFVJG1Yc7?=
 =?us-ascii?Q?mbxd23DS0SpW/If+V7//fjLf3iB4JUCgqDanwUzTl4GVsCigtlp67g/bRAL4?=
 =?us-ascii?Q?bcYTAG5SvioTg43jKI38Y867NS/g8M3Yhmnz9TvKoklJv5ZdeiCxjpnh8qbz?=
 =?us-ascii?Q?HfngzzmJHVPMQJp8nXgFnwoJyJUlabMImZn/3jxQC25yoVWavLizajgk4zDk?=
 =?us-ascii?Q?JQKyX7TtBhsJZCf4hRms/SKei8myBRh4LbmIeeYeggXXcVrC16AZWVvREFia?=
 =?us-ascii?Q?qfjCxhlyu9ZmNsJC+G3YzsiUjVqVqNiDH9ZYzpjQ?=
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35137c46-bf15-45a4-5c07-08db199a1d7a
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 14:43:11.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vVEyu31pQBNeTv9LtAA9aUStPiBS2ODp0O5DusRWBfTPeYenTP+oLoXnUzTf8vOG6r0G6wuVJCeFMtrvUhfq1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9852
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enhanced link detection is an ADI PHY feature that allows for earlier
detection of link down if certain signal conditions are met. This
feature is for the most part enabled by default on the PHY. This is
not suitable for all applications and breaks the IEEE standard as
explained in the ADI datasheet.

To fix this, add override flags to disable enhanced link detection
for 1000BASE-T and 100BASE-TX respectively by clearing any related
feature enable bits.

This new feature was tested on an ADIN1300 but according to the
datasheet applies equally for 100BASE-TX on the ADIN1200.

Signed-off-by: Ken Sloat <ken.s@variscite.com>
---
 drivers/net/phy/adin.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index da65215d19bb..8809f3e036a4 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -69,6 +69,15 @@
 #define ADIN1300_EEE_CAP_REG			0x8000
 #define ADIN1300_EEE_ADV_REG			0x8001
 #define ADIN1300_EEE_LPABLE_REG			0x8002
+#define ADIN1300_FLD_EN_REG				0x8E27
+#define   ADIN1300_FLD_PCS_ERR_100_EN			BIT(7)
+#define   ADIN1300_FLD_PCS_ERR_1000_EN			BIT(6)
+#define   ADIN1300_FLD_SLCR_OUT_STUCK_100_EN	BIT(5)
+#define   ADIN1300_FLD_SLCR_OUT_STUCK_1000_EN	BIT(4)
+#define   ADIN1300_FLD_SLCR_IN_ZDET_100_EN		BIT(3)
+#define   ADIN1300_FLD_SLCR_IN_ZDET_1000_EN		BIT(2)
+#define   ADIN1300_FLD_SLCR_IN_INVLD_100_EN		BIT(1)
+#define   ADIN1300_FLD_SLCR_IN_INVLD_1000_EN	BIT(0)
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
@@ -508,6 +517,31 @@ static int adin_config_clk_out(struct phy_device *phydev)
 			      ADIN1300_GE_CLK_CFG_MASK, sel);
 }
 
+static int adin_config_fld_en(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_FLD_EN_REG);
+	if (reg < 0)
+		return reg;
+
+	if (device_property_read_bool(dev, "adi,disable-fld-1000base-t"))
+		reg &= ~(ADIN1300_FLD_PCS_ERR_1000_EN |
+				 ADIN1300_FLD_SLCR_OUT_STUCK_1000_EN |
+				 ADIN1300_FLD_SLCR_IN_ZDET_1000_EN |
+				 ADIN1300_FLD_SLCR_IN_INVLD_1000_EN);
+
+	if (device_property_read_bool(dev, "adi,disable-fld-100base-tx"))
+		reg &= ~(ADIN1300_FLD_PCS_ERR_100_EN |
+				 ADIN1300_FLD_SLCR_OUT_STUCK_100_EN |
+				 ADIN1300_FLD_SLCR_IN_ZDET_100_EN |
+				 ADIN1300_FLD_SLCR_IN_INVLD_100_EN);
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_FLD_EN_REG, reg);
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
@@ -534,6 +568,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_fld_en(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.34.1

