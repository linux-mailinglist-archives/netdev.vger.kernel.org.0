Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B346654FEE3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383250AbiFQUhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377564AbiFQUhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:37:05 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1B7606ED;
        Fri, 17 Jun 2022 13:34:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClZSvOIiFZt9aNwNX/CcQ6U2O50euFzJ4WI9Lk5PYqY69GW62a/DYoT1jOVcHVVZX36aGizc+pjl2Zln+dWetdJ312Du6vo/HlF3IFLxt5P9wDjgsAI2frPK9O88niPDb1uWjhVt5Wd8Tv33opZBxjBAPB+0/xPr2laYEMk8xeegVMMlLlVv2piWEZLFdWabdnk29QgUxjomeXN7Q2Tj+n5ObN6IpTnEhS1G395VpKhUpoxs/qO5PXQ5DBzLFDcwhtzQlwxgZzNA83u1Z+rUBhEwHLRmUUFzP/4to6RtwFfBpiRnavqQioSXkjcKK+TaLCtgyL5IV+qgbBv+UWQTlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOjdqXXJBkuSU4b0VnafBKBkGQmFEvoD7IBjvteqWJY=;
 b=hLVefkQbP6ecieN/BFo5JfSLkr++sj+YO6Y4kBaO+hydJbDsiLXG+4fX+BYd0rKOO4SWy+jL369Nrh8ZNGqLz6sXNOkfdd1pSoTUFP9QHXFakhJPUiEP/iToAF066LLhEYBR5wqSwB+GsBXfQ1qgko1pa4E1443zMi2HyOSeuTv5DNI8p9nZDT2uJB5TwE5M1YhFrHf7E6vaeR36buOEuJbo+kYnYr0O7+xRM0uehMhWza6ViNxvXyIq/L75vMCMY8BggHifuyNHsAHf9SmpvVdEV1BmsHB5cSP6ujiGM+eJV66YyITjQ2jhd66zdbRZGYdCYeKsUTsgqBFYSJ5oBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOjdqXXJBkuSU4b0VnafBKBkGQmFEvoD7IBjvteqWJY=;
 b=RfAmhnKegxw5YtGEJfbp3xYpoJe6XC6QFIEqcas15HnG7BahvZ5cmLRhrHVgaXl47XwZZr6oxscdRPz8guuqIi3RpMFwonEvioRqAmodscxwGTcFrAAKYfOE6nLN2GRPYRC4v7b5Oi9xf8NmgN2XLsmiKK9v44NYm2SaNrXDBOwHs6arlxVvd3bED8QbDVO0PvQQmXU4lwYIzswARJ71f9UX426iyudiEGJpPaq9zVAFmnUpyIUmTyRexmDGA6WoYXOE8p0g/ZDXGz9/fbCxlWReAyx3nVc10rW5tYq1TPG8IoEd7xM4hw5SjX+ztBesukkGt8cD7Lmwq6P9ORGJ4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:19 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:19 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 23/28] net: fman: memac: Use lynx pcs driver
Date:   Fri, 17 Jun 2022 16:33:07 -0400
Message-Id: <20220617203312.3799646-24-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbe218f2-ddb2-476c-7233-08da50a0c158
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB683812388964394D29A2EDD896AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0n9hVjZETi/PrEBhkWd7HiX1nvdCu0LYWB1faW5oUU4czp6DhcGpnhvVb2qp8XxBb10AFwlQfZfpKZCWAPi5LupG86QkXP9aHBlkRqpP/hfuFz2hSt9vHv+HQ9BwY3Pr4jA6hJ9bLDLCkVS111bIfxR3pxpsnRkyOokPrxCsoMsyMZGgzam2FSBQEjUyeLAaWINMEMfwIBV0iiI4cJ3BaSqMzzi5Cd2Zg2+5XeMUMTjYCCgxiM7SBYA8tb6nW/p2q8F5hOfmxZNa2v8gmXZaEUp7xZsFaNEe048k6hSquMtZO9ctm3P7fcESLMZTnNhJYewC29ZrZB+XVpNVz3Kwb6gLft7koIeMG8khFZgMv8u5uQZP4Iy4Yn470Lsumm/V8vXQmxQNwrPBWimsQss1AhV+7YBiULWAcMA49s4DhvOV8BoYJ+g5s+WVheMHm5rLYma9oO2eMIpxligz9popclLfYOfs4xWL7bRqA+p/gc6Q/PFonIV8527Lo5sqf6BjFC8BnM4YraddpvwNtcvjVWVYAI2H9oB5U+JVn9AhEv3ROAf6b6C21fK7GFPswnN4adXJ6xJB+LvR87AhGL9VCyR17aeykeRVbxxHa277rZJhsaRpZ6dosgTAnXLoyoTixBIB/Jxupn7PcicdpMoAfS4Htlt78Z5cGfE7fZq0Clg9WJT2wm7wW9tWecwoX140QkUFDD6ABgLSH343Bfz7Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(30864003)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CE8DfcTKBJei4o//H2CgPK7T7bwhnA6lNy21wYy15E0FQws4M0Uvu9fY3+Xq?=
 =?us-ascii?Q?SbaxpgEwJG7XTvmFPitOTjk3K7GVslSheXGe+NSlIXv6ZRyAPTyFyL45DbJ6?=
 =?us-ascii?Q?yQD1vaNS6ywIqq+X9jcIQeiTj48DQo0JBzcyw9hmTz+kmF5CZJ06hWg/YsnR?=
 =?us-ascii?Q?wecOTkKzR4J5tEA5vPW8Xlcr8XoPregEskJo2idflMNpaiZ0vMWVibn6Y0f7?=
 =?us-ascii?Q?IBJwhcfn75sJodbqfGFNwIDnMOyjlI6c9MS9SK/gypr6GoLwEKHbazfD6BSB?=
 =?us-ascii?Q?Ynk3XUMmHbXyI9upx3gkl1c+IrPX44Pyi205VrUL8sGSC1S5w50B6tvFeXuF?=
 =?us-ascii?Q?937m850ySMoEGc4wZk9WuGzvSIVBbcNiKzyocd9C6upFU0r/E9n89RTnf5i4?=
 =?us-ascii?Q?IwubuZMFbyZZ87RtguDH4cBRLdOm5UP9PqaEW9Fe7sW1645hSyYIWz6jVx6O?=
 =?us-ascii?Q?DJyLci8NUAG8fKPWqk8RtRgxf4dHtpowvWTdN9mlR6RF7eUV6GchvYh3NY0g?=
 =?us-ascii?Q?Q2xV+KlH0e0vLgOpSl5nhqy8PIwL9SqHijXAcTZnQRS1p694V/vDv1I04zDc?=
 =?us-ascii?Q?oDSvW1J/LASkYdj6qe2cu9+MiEPju/sYh+UiAwxxHUiuVLGNhMQ0kiPNN22d?=
 =?us-ascii?Q?CH8m3rUhNc6fmAO/QUz5xrAaGaUvitQE8A+e1faanTcq+VsryzFKRiCj8dnh?=
 =?us-ascii?Q?iP3K13nYcEVV1kkrddMNiPq/qKTAE7EcQVWbcr6KOBQs9Ebdi8sVJXTsvnQl?=
 =?us-ascii?Q?+8aAP3LwpUA6liZ/yuFCKrOf55/+NlQ4RdW5+KkuERi2uw859rsQ7N7n0zTx?=
 =?us-ascii?Q?Bax0IZ1gAj5zNRijGTs4Hvk6WnBsKakFto84wCrihAI2sA667rSAWcSFkMWb?=
 =?us-ascii?Q?vZCOVflzF2XrNycvdZv/lNlAgtmO5jgyxgLjSpzLQ7D4LgEuHi+x7Oo686Gh?=
 =?us-ascii?Q?zNaxXviMkGUe4BUbbNhTk1yFQ7rXqEQj23blzw8KblgqEZlUA/aRktNearzq?=
 =?us-ascii?Q?2rIcBvzaueI0K7sU+swMTet2eAbLh6UnaDMKASD3G4PpUh1HON/pZnkr4UIs?=
 =?us-ascii?Q?8ZmsXpx/9YsAeMWYlKRvkSw4Tp2jZapNR6Pn1iU533ZJSLMu2CBlvtoL/ZMp?=
 =?us-ascii?Q?/igVRRYIDz6Z0ZoVSCNZ/KznfRYWCXm4lmI6akL7spFCsAvkZMOG5A3vs72d?=
 =?us-ascii?Q?tW8bMByQ3bF+A3xo24aoiLaUKR2LAvOH4bYKsWcEhpPUaJtVHvpGGtBRcOl+?=
 =?us-ascii?Q?tewd3lBJ21/wub6zHBOZJOMszcGS/6mcQ0oJ0oseUP5b+mlVBQfOHI+JeSqJ?=
 =?us-ascii?Q?bpNVLsUBbAv1RYplt1L8c1vZbeMsbX4aAxq9BisUfGDQ1gD9VQHwEEpMDwtz?=
 =?us-ascii?Q?l9u028eRoRPrVHdc73hBJey8v9xLaQ7129VymvI4yKIF6nWjcywecUQGSaRY?=
 =?us-ascii?Q?sCLfRDLsSP66/Pxf4V7A5tWYLBWmz2WxH8VQFhwVYbFRqT5yl5Bt6VJ3k2hA?=
 =?us-ascii?Q?myoPR4aAbGYR0czH5oEzNbb3XQqEi1RCfwjZAyCbCFOzH7Dz16PSDQlgW0Jr?=
 =?us-ascii?Q?Pc2lSjY5WfzOVCmEOF7h7ZicU85iDCx0B1znuPboMUWabs3zLeR2wfXOgSZb?=
 =?us-ascii?Q?o+3ju47Ep+n9CyNVd0d0gu3SNgjbpKIfgp8tnLs57eHhTvIrIWA59LWF6jic?=
 =?us-ascii?Q?fWyZPhoT3Fh2Jdwa3tuyMb3mDzhRY5fvTQ5HfDFIsWK6wg8WgrKYEwAtI+5J?=
 =?us-ascii?Q?LqFQSGoqCKmzjVh5CBayOjNcLHCfXYc=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe218f2-ddb2-476c-7233-08da50a0c158
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:19.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jceuZWL6k6Yy/Gewa6z2fsIVnHbymeJ2cunSR46FcF+hakWhkTT9Mq7OnJwbpn4mHr9Awmf6wp3rVYoX9W5j8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although not stated in the datasheet, as far as I can tell PCS for MEMACs
is a "Lynx." By reusing the existing driver, we can remove the PCS
management code from the memac driver. This requires calling some PCS
functions manually which phylink would usually do for us, but we will let
it do that soon.

One problem is that we don't actually have a PCS for QSGMII. We pretend
that each MEMAC's MDIO bus has four QSGMII PCSs, but this is not the case.
Only the "base" MEMAC's MDIO bus has the four QSGMII PCSs. This is not an
issue yet, because we never get the PCS state. However, it will be once the
conversion to phylink is complete, since the links will appear to never
come up. To get around this, we allow specifying multiple PCSs in pcsphy.
This breaks backwards compatibility with old device trees, but only for
QSGMII. IMO this is the only reasonable way to figure out what the actual
QSGMII PCS is.

Additionally, we now also support a separate XFI PCS. This can allow the
SerDes driver to set different addresses for the SGMII and XFI PCSs so they
can be accessed at the same time.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/dpaa/Kconfig   |   2 +
 .../net/ethernet/freescale/fman/fman_memac.c  | 246 +++++++-----------
 2 files changed, 92 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig b/drivers/net/ethernet/freescale/dpaa/Kconfig
index 0e1439fd00bd..0ddcb1355daf 100644
--- a/drivers/net/ethernet/freescale/dpaa/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
@@ -4,6 +4,8 @@ menuconfig FSL_DPAA_ETH
 	depends on FSL_DPAA && FSL_FMAN
 	select PHYLIB
 	select FIXED_PHY
+	select PHYLINK
+	select PCS_LYNX
 	help
 	  Data Path Acceleration Architecture Ethernet driver,
 	  supporting the Freescale QorIQ chips.
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 5598a74ec559..3eea6710013a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -11,43 +11,12 @@
 
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/pcs-lynx.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/phy/phy.h>
 #include <linux/of_mdio.h>
 
-/* PCS registers */
-#define MDIO_SGMII_CR			0x00
-#define MDIO_SGMII_DEV_ABIL_SGMII	0x04
-#define MDIO_SGMII_LINK_TMR_L		0x12
-#define MDIO_SGMII_LINK_TMR_H		0x13
-#define MDIO_SGMII_IF_MODE		0x14
-
-/* SGMII Control defines */
-#define SGMII_CR_AN_EN			0x1000
-#define SGMII_CR_RESTART_AN		0x0200
-#define SGMII_CR_FD			0x0100
-#define SGMII_CR_SPEED_SEL1_1G		0x0040
-#define SGMII_CR_DEF_VAL		(SGMII_CR_AN_EN | SGMII_CR_FD | \
-					 SGMII_CR_SPEED_SEL1_1G)
-
-/* SGMII Device Ability for SGMII defines */
-#define MDIO_SGMII_DEV_ABIL_SGMII_MODE	0x4001
-#define MDIO_SGMII_DEV_ABIL_BASEX_MODE	0x01A0
-
-/* Link timer define */
-#define LINK_TMR_L			0xa120
-#define LINK_TMR_H			0x0007
-#define LINK_TMR_L_BASEX		0xaf08
-#define LINK_TMR_H_BASEX		0x002f
-
-/* SGMII IF Mode defines */
-#define IF_MODE_USE_SGMII_AN		0x0002
-#define IF_MODE_SGMII_EN		0x0001
-#define IF_MODE_SGMII_SPEED_100M	0x0004
-#define IF_MODE_SGMII_SPEED_1G		0x0008
-#define IF_MODE_SGMII_DUPLEX_HALF	0x0010
-
 /* Num of additional exact match MAC adr regs */
 #define MEMAC_NUM_OF_PADDRS 7
 
@@ -326,7 +295,9 @@ struct fman_mac {
 	struct fman_rev_info fm_rev_info;
 	bool basex_if;
 	struct phy *serdes;
-	struct phy_device *pcsphy;
+	struct phylink_pcs *sgmii_pcs;
+	struct phylink_pcs *qsgmii_pcs;
+	struct phylink_pcs *xfi_pcs;
 	bool allmulti_enabled;
 };
 
@@ -487,91 +458,22 @@ static u32 get_mac_addr_hash_code(u64 eth_addr)
 	return xor_val;
 }
 
-static void setup_sgmii_internal_phy(struct fman_mac *memac,
-				     struct fixed_phy_status *fixed_link)
+static void setup_sgmii_internal(struct fman_mac *memac,
+				 struct phylink_pcs *pcs,
+				 struct fixed_phy_status *fixed_link)
 {
-	u16 tmp_reg16;
-
-	if (WARN_ON(!memac->pcsphy))
-		return;
-
-	/* SGMII mode */
-	tmp_reg16 = IF_MODE_SGMII_EN;
-	if (!fixed_link)
-		/* AN enable */
-		tmp_reg16 |= IF_MODE_USE_SGMII_AN;
-	else {
-		switch (fixed_link->speed) {
-		case 10:
-			/* For 10M: IF_MODE[SPEED_10M] = 0 */
-		break;
-		case 100:
-			tmp_reg16 |= IF_MODE_SGMII_SPEED_100M;
-		break;
-		case 1000:
-		default:
-			tmp_reg16 |= IF_MODE_SGMII_SPEED_1G;
-		break;
-		}
-		if (!fixed_link->duplex)
-			tmp_reg16 |= IF_MODE_SGMII_DUPLEX_HALF;
-	}
-	phy_write(memac->pcsphy, MDIO_SGMII_IF_MODE, tmp_reg16);
-
-	/* Device ability according to SGMII specification */
-	tmp_reg16 = MDIO_SGMII_DEV_ABIL_SGMII_MODE;
-	phy_write(memac->pcsphy, MDIO_SGMII_DEV_ABIL_SGMII, tmp_reg16);
-
-	/* Adjust link timer for SGMII  -
-	 * According to Cisco SGMII specification the timer should be 1.6 ms.
-	 * The link_timer register is configured in units of the clock.
-	 * - When running as 1G SGMII, Serdes clock is 125 MHz, so
-	 * unit = 1 / (125*10^6 Hz) = 8 ns.
-	 * 1.6 ms in units of 8 ns = 1.6ms / 8ns = 2*10^5 = 0x30d40
-	 * - When running as 2.5G SGMII, Serdes clock is 312.5 MHz, so
-	 * unit = 1 / (312.5*10^6 Hz) = 3.2 ns.
-	 * 1.6 ms in units of 3.2 ns = 1.6ms / 3.2ns = 5*10^5 = 0x7a120.
-	 * Since link_timer value of 1G SGMII will be too short for 2.5 SGMII,
-	 * we always set up here a value of 2.5 SGMII.
-	 */
-	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_H, LINK_TMR_H);
-	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_L, LINK_TMR_L);
-
-	if (!fixed_link)
-		/* Restart AN */
-		tmp_reg16 = SGMII_CR_DEF_VAL | SGMII_CR_RESTART_AN;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
+	phy_interface_t iface = memac->basex_if ? PHY_INTERFACE_MODE_1000BASEX :
+				PHY_INTERFACE_MODE_SGMII;
+	unsigned int mode = fixed_link ? MLO_AN_FIXED : MLO_AN_INBAND;
+
+	linkmode_set_pause(advertising, true, true);
+	pcs->ops->pcs_config(pcs, mode, iface, advertising, true);
+	if (fixed_link)
+		pcs->ops->pcs_link_up(pcs, mode, iface, fixed_link->speed,
+				      fixed_link->duplex);
 	else
-		/* AN disabled */
-		tmp_reg16 = SGMII_CR_DEF_VAL & ~SGMII_CR_AN_EN;
-	phy_write(memac->pcsphy, 0x0, tmp_reg16);
-}
-
-static void setup_sgmii_internal_phy_base_x(struct fman_mac *memac)
-{
-	u16 tmp_reg16;
-
-	/* AN Device capability  */
-	tmp_reg16 = MDIO_SGMII_DEV_ABIL_BASEX_MODE;
-	phy_write(memac->pcsphy, MDIO_SGMII_DEV_ABIL_SGMII, tmp_reg16);
-
-	/* Adjust link timer for SGMII  -
-	 * For Serdes 1000BaseX auto-negotiation the timer should be 10 ms.
-	 * The link_timer register is configured in units of the clock.
-	 * - When running as 1G SGMII, Serdes clock is 125 MHz, so
-	 * unit = 1 / (125*10^6 Hz) = 8 ns.
-	 * 10 ms in units of 8 ns = 10ms / 8ns = 1250000 = 0x1312d0
-	 * - When running as 2.5G SGMII, Serdes clock is 312.5 MHz, so
-	 * unit = 1 / (312.5*10^6 Hz) = 3.2 ns.
-	 * 10 ms in units of 3.2 ns = 10ms / 3.2ns = 3125000 = 0x2faf08.
-	 * Since link_timer value of 1G SGMII will be too short for 2.5 SGMII,
-	 * we always set up here a value of 2.5 SGMII.
-	 */
-	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_H, LINK_TMR_H_BASEX);
-	phy_write(memac->pcsphy, MDIO_SGMII_LINK_TMR_L, LINK_TMR_L_BASEX);
-
-	/* Restart AN */
-	tmp_reg16 = SGMII_CR_DEF_VAL | SGMII_CR_RESTART_AN;
-	phy_write(memac->pcsphy, 0x0, tmp_reg16);
+		pcs->ops->pcs_an_restart(pcs);
 }
 
 static int check_init_parameters(struct fman_mac *memac)
@@ -984,7 +886,6 @@ static int memac_set_exception(struct fman_mac *memac,
 static int memac_init(struct fman_mac *memac)
 {
 	struct memac_cfg *memac_drv_param;
-	u8 i;
 	enet_addr_t eth_addr;
 	bool slow_10g_if = false;
 	struct fixed_phy_status *fixed_link;
@@ -1037,32 +938,10 @@ static int memac_init(struct fman_mac *memac)
 		iowrite32be(reg32, &memac->regs->command_config);
 	}
 
-	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII) {
-		/* Configure internal SGMII PHY */
-		if (memac->basex_if)
-			setup_sgmii_internal_phy_base_x(memac);
-		else
-			setup_sgmii_internal_phy(memac, fixed_link);
-	} else if (memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
-		/* Configure 4 internal SGMII PHYs */
-		for (i = 0; i < 4; i++) {
-			u8 qsmgii_phy_addr, phy_addr;
-			/* QSGMII PHY address occupies 3 upper bits of 5-bit
-			 * phy_address; the lower 2 bits are used to extend
-			 * register address space and access each one of 4
-			 * ports inside QSGMII.
-			 */
-			phy_addr = memac->pcsphy->mdio.addr;
-			qsmgii_phy_addr = (u8)((phy_addr << 2) | i);
-			memac->pcsphy->mdio.addr = qsmgii_phy_addr;
-			if (memac->basex_if)
-				setup_sgmii_internal_phy_base_x(memac);
-			else
-				setup_sgmii_internal_phy(memac, fixed_link);
-
-			memac->pcsphy->mdio.addr = phy_addr;
-		}
-	}
+	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII)
+		setup_sgmii_internal(memac, memac->sgmii_pcs, fixed_link);
+	else if (memac->phy_if == PHY_INTERFACE_MODE_QSGMII)
+		setup_sgmii_internal(memac, memac->qsgmii_pcs, fixed_link);
 
 	/* Max Frame Length */
 	err = fman_set_mac_max_frame(memac->fm, memac->mac_id,
@@ -1102,8 +981,12 @@ static int memac_free(struct fman_mac *memac)
 {
 	free_init_resources(memac);
 
-	if (memac->pcsphy)
-		put_device(&memac->pcsphy->mdio.dev);
+	if (memac->sgmii_pcs)
+		lynx_pcs_destroy(memac->sgmii_pcs);
+	if (memac->qsgmii_pcs)
+		lynx_pcs_destroy(memac->qsgmii_pcs);
+	if (memac->xfi_pcs)
+		lynx_pcs_destroy(memac->xfi_pcs);
 
 	kfree(memac->memac_drv_param);
 	kfree(memac);
@@ -1154,13 +1037,30 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
 	return memac;
 }
 
+static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
+					    int index)
+{
+	struct device_node *node;
+	struct mdio_device *mdiodev = NULL;
+
+	node = of_parse_phandle(mac_node, "pcsphy-handle", index);
+	if (node && of_device_is_available(node))
+		mdiodev = of_mdio_find_device(node);
+	of_node_put(node);
+
+	if (!mdiodev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	return lynx_pcs_create(mdiodev) ?: ERR_PTR(-ENOMEM);
+}
+
 int memac_initialization(struct mac_device *mac_dev,
 			 struct device_node *mac_node,
 			 struct fman_mac_params *params)
 {
 	int			 err;
-	struct device_node	*phy_node;
 	struct mac_priv_s	*priv;
+	struct phylink_pcs	*pcs;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
 
@@ -1191,23 +1091,57 @@ int memac_initialization(struct mac_device *mac_dev,
 	memac = mac_dev->fman_mac;
 	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
 	memac->memac_drv_param->reset_on_init = true;
-	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
-	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
-		phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
-		if (!phy_node) {
-			pr_err("PCS PHY node is not available\n");
-			err = -EINVAL;
+
+	err = of_property_match_string(mac_node, "pcs-names", "xfi");
+	if (err >= 0) {
+		memac->xfi_pcs = memac_pcs_create(mac_node, err);
+		if (IS_ERR(memac->xfi_pcs)) {
+			err = PTR_ERR(memac->xfi_pcs);
+			dev_err_probe(mac_dev->dev, err, "missing xfi pcs\n");
 			goto _return_fm_mac_free;
 		}
+	} else if (err != -EINVAL && err != -ENODATA) {
+		goto _return_fm_mac_free;
+	}
 
-		memac->pcsphy = of_phy_find_device(phy_node);
-		if (!memac->pcsphy) {
-			pr_err("of_phy_find_device (PCS PHY) failed\n");
-			err = -EINVAL;
+	err = of_property_match_string(mac_node, "pcs-names", "qsgmii");
+	if (err >= 0) {
+		memac->qsgmii_pcs = memac_pcs_create(mac_node, err);
+		if (IS_ERR(memac->qsgmii_pcs)) {
+			err = PTR_ERR(memac->qsgmii_pcs);
+			dev_err_probe(mac_dev->dev, err, "missing qsgmii pcs\n");
 			goto _return_fm_mac_free;
 		}
+	} else if (err != -EINVAL && err != -ENODATA) {
+		goto _return_fm_mac_free;
+	}
+
+	/* For compatibility, if pcs-names is missing, we assume this phy is
+	 * the first one in pcsphy-handle
+	 */
+	err = of_property_match_string(mac_node, "pcs-names", "sgmii");
+	if (err == -EINVAL)
+		pcs = memac_pcs_create(mac_node, 0);
+	else if (err < 0)
+		goto _return_fm_mac_free;
+	else
+		pcs = memac_pcs_create(mac_node, err);
+
+	if (!pcs) {
+		dev_err(mac_dev->dev, "missing pcs\n");
+		err = -ENOENT;
+		goto _return_fm_mac_free;
 	}
 
+	/* If err is set here, it means that pcs-names was missing above (and
+	 * therefore that xfi_pcs cannot be set). If we are defaulting to
+	 * XGMII, assume this is for XFI. Otherwise, assume it is for SGMII.
+	 */
+	if (err && mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
+		memac->xfi_pcs = pcs;
+	else
+		memac->sgmii_pcs = pcs;
+
 	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node, "serdes");
 	if (PTR_ERR(memac->serdes) == -ENODEV) {
 		memac->serdes = NULL;
-- 
2.35.1.1320.gc452695387.dirty

