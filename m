Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBEB58A178
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbiHDTrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbiHDTrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:47:39 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE1C6E2D7;
        Thu,  4 Aug 2022 12:47:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfewAYCAGP1XtoPGIHjc09mA33z45CKF4E3WmAlQRATHGLFXP0fS2tFHaJxAQuNDfdjd0frqQTWOgzzpIDsqvPaIG901HLqKudEetuQjBbK4hrT5mljZFk26qF2P3VoTLAEPxSOVZB+VJ0p1ZKORfdV0SqgbiwxB7nhVS8kmPxITlDcjQyOqyWsuRZO9rmBBoUKgAz9mNtizB0HsduPz1LqCOZ8J2z8mKPjRmDPsEuw69XoOXZtZWOOTFOPKx5ikzF0k7o1sSvwalyt2LUImIK/GppGVPu27/vFBm7uipqEXa1D+cPBz5fRKCMQZkeIollpAFXUPR37TyGc/NghJzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yg1Ggq3xdvIUN+I6gcZ2KQhsujZuotG1HTSN9jLdI/g=;
 b=L8x79WtV9/TnsfzU+jceFevXWTGYdIM6fPkBZyw26fLNrv2MLG7K9rpA74rB1zYL0a0S4MP8MuKtVS2ZKmRKAGBaTN6sxcZ3++7Dpkhwee7TankaCFsR8vw7QjSHc0oB7ZDpdi9oWi80sNhZ4LqBbWwa5xSqFuC1bOnPA+PAdBRMzXPMjo+U3PhVkGXEv77Uc3WDCHP6jAnRCXRrUfDZsrzqK0pq1ajBz33xn+mfqUMS+QagQ1r6TeIlNOsyPieFgCLVxNJOymrht69jkPfQiOMgBqUQ0KyhUL58NgyNIlBelOvaWh2/L90ormzI3NUi3feen+Vta9AZpYvsL3qeEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yg1Ggq3xdvIUN+I6gcZ2KQhsujZuotG1HTSN9jLdI/g=;
 b=mQFS1Ve/e2RBNTrpL+sBflSr+HNzjhXqy4lq80EdRI2+geBCe+L6bjr2PjJd1B+VhYNI1dYVEaR6b3y/xKxcCYUSpzi6xYWUv5R45CcMUfAC0hafIYK/SCoGQa5UATZXwcU44mgrp0lHQNABU/lzrIqrDu2XMcMsBwXY+u0MMILPzpCYMMaZjH7whIIGauK+v7PzfpON9cMhD1jRw4UOhJjqS3bJJ27F0UBlFIWjuQJcx3QeWcqBF8fVUNhxFlC3xEPXNNPV6BLhun3/fmPXuhHky1qeeVJjIyC+jEBn/v5OykZxVbDcIvYFoSL7z06LrThX491ffX8fTpNyWBP4kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 4/8] net: fman: memac: Use lynx pcs driver
Date:   Thu,  4 Aug 2022 15:47:01 -0400
Message-Id: <20220804194705.459670-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
References: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0acc0832-e023-4bf7-2e2a-08da76522b17
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KXwR8WLoS1mJ6eKHS+DchGWilhcA+MeAiIm3M06jRzdPdTjoeHOUpsYqyj9DegTf/nxpo9M2KlxngiOg0csFRdeVpp4Iv3cmr3pffCRY/GP9fNflM/kk7qJPSFBvnpeALrWD2PQ5YpopkbwJKKGk0aK3HhoeAzLuXISiX2k7fmWBkm2vxsPRQaYYPo4g9co/bFPwajGobFrUbyyaS5h2i9gMdr53IlEezsCx0bFRCVPJiZZ9qNx+GliiksYWnr9U0yl8tqMQ2DO0eZHMDP/rRxe4EZVb3bUT5H33PftRTbOb5CHs2ulePmsrprMXW7cb7kY0Xo4C1QtFNiecAXPp2bPY8FHP2EN+/Vyv/5xLos6/TGlOCwGA62LUS0THNgcnNgK2jxTfDl+199GB/hYlikgGxtLru+T4WEi1IiEBYHV80fhDIaW++nelLg5/LtsBa2gIvrf1biD0aZitJOEGIYNS/tFLEzh5jy7iMVWtNFN5GYw/h6pQ3HBRXX4Acd2QfEC2NhLFPa2vu60DWJpit3L29ySLKWq/ifetMCI7eR7j5jb9HvTmzxDMnsrcs1tng6Iu9rV+CgotqCHgVSBZGZ8hIdkuOhWGniOz/t8RuXbalQ5lP9AMO5wyQsKmfgbc1vCDhhppk1sSfpVtuVIWffMNNI6EdtRNWlFm8ZoHYLMTkAO+BWNBI94fB9i811GVXvrnhTP179oEzeQrCX+Bo50lMrKAnHL/tU87FCgy08oKgavFUusp0O2opemsBaB632wXLnmVJ4rzNqI0ZmszzFRzqHkOiJGI64pc7a2fDJH4G6/JisDLvMvr1vgXb4B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(107886003)(30864003)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(83380400001)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qDcFuIfM++RY+mYuDuTJjZmi//SC+p/8d8Mei+Yk3Ee3jM2uxcg1I36TdLGM?=
 =?us-ascii?Q?/Rz78+Xn2JLJmAvoWhb4oJ6mzLCNxW4VZit0pWdFc8A23b4QWSjg72yTSfkS?=
 =?us-ascii?Q?dKuk33kiM0GyNx58xzL3qrrIMAjyI+VQxbWM3pBbt9aHCezRHKsI9wopSWVK?=
 =?us-ascii?Q?BtmMVU9e7ryB2wteO2GWOddr7mIlLEDnjuEUWhozjI2uLFQlG4gQv4XN4hF/?=
 =?us-ascii?Q?fncacJ38RwzYaZX2s3dAMGnZj0BCgITwyEPgEHLUBZo69UVeVKAltZJR5nBM?=
 =?us-ascii?Q?hccDh47Gn9AhNU9/aqh9M7NTd4DeYvWmOTwJFAFZ9/cfM/eW8oCtvPmDX2NI?=
 =?us-ascii?Q?Q59BbtaLuMGptyqugMldX8pCEJ6YKNjZb2q5itxy6CiKsvXEzucnVHVqjFxV?=
 =?us-ascii?Q?QgGymvKZxT5HrEzxpfFDCnOVkrbLDWrPe1tQ4FKBH37IJY8rz6mNKYI86BMy?=
 =?us-ascii?Q?hM+OstGlUKBwPFfIDMohQFZj7tyi+tIcRM24gVgC9jNhgk0BtJ31+uin1TR0?=
 =?us-ascii?Q?ARUES93Ed7/T+BzzpN3WDCZL80wVOvDCazMrJA3DOQO6IVwGDt6wAkK4Gatx?=
 =?us-ascii?Q?JXgWZAJD9LvvFQAHsLky/GIsnWc9Ie+fIzRPBGWDFf/LHnWNZ5YC9ONGQ6Fk?=
 =?us-ascii?Q?pOrdD+gGOxCZ2Qze2l4pt27LoSBvbTuZF+J9ZzClXGNgyYNXX5T/OJfPG+sL?=
 =?us-ascii?Q?Y2fpKYD3QtwurHd9pbTLGKZnZy7OQBdoxraTYjAFXs1EkViW6eKGwoQE9fcE?=
 =?us-ascii?Q?L1V6Otd+g/ZPY8X9FMxg+9kRVS9jxX/PqGZwKOvwGHNzY2k678+3//n9QZh4?=
 =?us-ascii?Q?TDAyJICHbFEESppYbALVEpjhdXl2yNl01HDEXPzFjoUwSzS681KN74t8XAFS?=
 =?us-ascii?Q?7HvPGwErl3UiZ3KJbY+ziMOfvPmALDJvkX5ImwLNNUFghJFKUYfe4zMh5n4I?=
 =?us-ascii?Q?D9FVbd3NtTCbLUA5Y9FGuW18ojNaqdMJB9awB6lBihopVFfoyPxMTb8IGj94?=
 =?us-ascii?Q?K8H9jJxIUPb31pXVRODNaQO1Ac/bv+wcIuthXokZHKA9Myz2yWYQHUDl1MJG?=
 =?us-ascii?Q?MhjzsQGqi3RlxvyjnWvjwlFhDQSkow+VnLkNMD4kipUS9aew3SlI+g1DOvD1?=
 =?us-ascii?Q?tBCvf7v8kKnshWbMc9nUBdxL3BWpj2qQYEyXDEZFYSiIoeejDOrfg6QesoCB?=
 =?us-ascii?Q?svYQuY+6tL1r5r5g2u9XoGsWSwULREXdPcSHIiJNgmnK6OjPhA+Kqw1YMjem?=
 =?us-ascii?Q?ztNCFuikESKtr3jyFTs6muxA1dh0+Lt9MkPTBWMS5nM6cOGZOss76s4ujIGA?=
 =?us-ascii?Q?f9xpYUZkUFMO9WRFs8jKa3t5Ie2SZxA7gHjPvzX85TgvY0TLc7bOFXn6tOHv?=
 =?us-ascii?Q?ZIXA6TDenfHErcRrxpqGFcMW02++62BO5kRvcM6Fc4NdhUFS23iutaXP909F?=
 =?us-ascii?Q?1SEUI5hLI0q+pIMlSKUbP3ctEX2XbxESIy3Sx8hxAi4tYA3kf8jWx4HJWlUc?=
 =?us-ascii?Q?h695V0dFXLGE0px3R491z+vyzMBesjaP0/71NiXvIne1LZBNGYo+l1QzVtJs?=
 =?us-ascii?Q?BgDYClPw4vAuTpAxJjQFHWtvbrKkrb+cM5kSLXvmGMK2WWdDHywtTAhButrH?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acc0832-e023-4bf7-2e2a-08da76522b17
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:31.0712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0H2TNVwy4oPl8+ulzh8uvId9MozmI75axrvmOSh1IrkLzth141iQ0FzL4sGZcJM4XMaP7Q12XTNZeP/1GIOm6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although not stated in the datasheet, as far as I can tell PCS for mEMACs
is a "Lynx." By reusing the existing driver, we can remove the PCS
management code from the memac driver. This requires calling some PCS
functions manually which phylink would usually do for us, but we will let
it do that soon.

One problem is that we don't actually have a PCS for QSGMII. We pretend
that each mEMAC's MDIO bus has four QSGMII PCSs, but this is not the case.
Only the "base" mEMAC's MDIO bus has the four QSGMII PCSs. This is not an
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

(no changes since v3)

Changes in v3:
- Put the PCS mdiodev only after we are done with it (since the PCS
  does not perform a get itself).

Changes in v2:
- Move PCS_LYNX dependency to fman Kconfig

 drivers/net/ethernet/freescale/fman/Kconfig   |   3 +
 .../net/ethernet/freescale/fman/fman_memac.c  | 257 +++++++-----------
 2 files changed, 104 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
index 48bf8088795d..8f5637db41dd 100644
--- a/drivers/net/ethernet/freescale/fman/Kconfig
+++ b/drivers/net/ethernet/freescale/fman/Kconfig
@@ -4,6 +4,9 @@ config FSL_FMAN
 	depends on FSL_SOC || ARCH_LAYERSCAPE || COMPILE_TEST
 	select GENERIC_ALLOCATOR
 	select PHYLIB
+	select PHYLINK
+	select PCS
+	select PCS_LYNX
 	select CRC32
 	default n
 	help
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 2886f86e45ba..23794e8d43be 100644
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
@@ -983,7 +885,6 @@ static int memac_set_exception(struct fman_mac *memac,
 static int memac_init(struct fman_mac *memac)
 {
 	struct memac_cfg *memac_drv_param;
-	u8 i;
 	enet_addr_t eth_addr;
 	bool slow_10g_if = false;
 	struct fixed_phy_status *fixed_link;
@@ -1036,32 +937,10 @@ static int memac_init(struct fman_mac *memac)
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
@@ -1097,12 +976,25 @@ static int memac_init(struct fman_mac *memac)
 	return 0;
 }
 
+static void pcs_put(struct phylink_pcs *pcs)
+{
+	struct mdio_device *mdiodev;
+
+	if (!pcs)
+		return;
+
+	mdiodev = lynx_get_mdio_device(pcs);
+	lynx_pcs_destroy(pcs);
+	mdio_device_free(mdiodev);
+}
+
 static int memac_free(struct fman_mac *memac)
 {
 	free_init_resources(memac);
 
-	if (memac->pcsphy)
-		put_device(&memac->pcsphy->mdio.dev);
+	pcs_put(memac->sgmii_pcs);
+	pcs_put(memac->qsgmii_pcs);
+	pcs_put(memac->xfi_pcs);
 
 	kfree(memac->memac_drv_param);
 	kfree(memac);
@@ -1153,12 +1045,31 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
 	return memac;
 }
 
+static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
+					    int index)
+{
+	struct device_node *node;
+	struct mdio_device *mdiodev = NULL;
+	struct phylink_pcs *pcs;
+
+	node = of_parse_phandle(mac_node, "pcsphy-handle", index);
+	if (node && of_device_is_available(node))
+		mdiodev = of_mdio_find_device(node);
+	of_node_put(node);
+
+	if (!mdiodev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	pcs = lynx_pcs_create(mdiodev);
+	return pcs;
+}
+
 int memac_initialization(struct mac_device *mac_dev,
 			 struct device_node *mac_node,
 			 struct fman_mac_params *params)
 {
 	int			 err;
-	struct device_node	*phy_node;
+	struct phylink_pcs	*pcs;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
 
@@ -1188,23 +1099,57 @@ int memac_initialization(struct mac_device *mac_dev,
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
 	err = PTR_ERR(memac->serdes);
 	if (err == -ENODEV || err == -ENOSYS) {
-- 
2.35.1.1320.gc452695387.dirty

