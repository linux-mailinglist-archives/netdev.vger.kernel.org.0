Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863DD55F14F
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiF1WTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiF1WS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:18:57 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00078.outbound.protection.outlook.com [40.107.0.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E760393DF;
        Tue, 28 Jun 2022 15:15:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/chMcilN7yUqSLlro7n9h0fkonh/Sy3qFBROox/rOOKBn0VkPD8waMhb7tje5pmCgal13exwrQvlJMShRYZ0OVbAQzKlV9aulkbFFKGzfL8998a/aUvlGpFyyYNHSSrAv6HfQamDg0t9VZzdbGQEtNu9PuWvtIQC/zxmriwDZzBs5h/DsELhkHfN6k6jVOcbwbwsmVZu/aatAaiMI7S2gnkNhvgkms8ohtvPz6TfjxeZn+BufxpOTahGEb9tZoW7+wlaSFnO+WjG2Tpuu8068GqOH6BFAeXayIPL/BSWNgQXXAa+ljMwOknHJ7WM72o3CRUfqQLMz+voymkjRkiQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIVXiwaPqN2qpxsdgsEHfCgueG0jFYH93TSiEtZ/GMQ=;
 b=DkHs/gkxypl6JgpYgsqTCeZ7udaKJs2bkUkZBW/aREj2T2y14VCetQaYotQxzsXh6U6mhBaUVvbKaDqRYcnafG8o1kp+1lSQrM2BU8q/m+ozrWekoLSIHW4/+BG7B3XCAGiFkq62JAL1RsGG9hFTqed5s6eI2XVzqICp4nA+wEzWV8a+4KXFa7wn2Pd/L7G+I/3VtnKraUqJAEBcmIsGg0P+8O8MrMoQXFLTSj6jBfJhhKDpIHLvjpwoR5oV+uIMQvIhavUXNuLHa6g6jzoie/jZHMs1XaE7Ibvsn+hNbOM5rghjNTPvMAQtoUwS4DBeF7Ev9NfgaR4ylIlnAnn76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIVXiwaPqN2qpxsdgsEHfCgueG0jFYH93TSiEtZ/GMQ=;
 b=dMwgTGam1w/0qwVcPWTO1cfCgKErLbvHojn7FdoZGWUHPCowbxdiZerVF/B4QpCfSiRib4f1DsLYzKvmqi2J2NkFyBrkkX5xuOqo8HYPV0PCDfyUcyFBHOv7II1dQQnVtRpYPqUcOyef0GYPraBWFIFM0DqNZvurROtyZ9J16y7+Cxdx2v/EUo+kVQfMw1uQ6hpx7j8jQYNoyH72lstfXaOfvPBswPKuR1WtPeqUJHmR72f1dzzcMafALgIYXH4lBEGzyWVw3KNhwRZtvEXWOXEUEm7WFu48uq+zm9Lny3XttajVRGW1vTblCz/VUy7XeZ0cgvSEG98ZKmnxCm4uSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:35 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:35 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 30/35] net: fman: memac: Use lynx pcs driver
Date:   Tue, 28 Jun 2022 18:13:59 -0400
Message-Id: <20220628221404.1444200-31-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66db4b53-96b6-4b79-a68f-08da5953a798
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AUgVzqJqlDU1RZgBin5qJSbtoumLZONr7WuzMqkU+iK+CoYbGG5howKOmLfsWhWIKc9ZAnkBCCw0/tuyeS/CdxMA25brYwsI9KRR1Yt1ZySHET7xY8p2Z5lRRhSqSLxU9Opk0gH5WHbbua3Fy6QDM3VQL+Ajs+og6U8B4yPe/i5SVqhTIF/tIgcTyfw+H8FspGSkx6kMoCNFGsd7IsteGZOvmNgl8I0EDkwCGeux7SKkdyMGd4OQNawFW9lBZc+qQpVnVUVbetZQ80hXUshx8wiGj8vnEvliGljgLWfj2fjwsn8pU4gmIRjCFu1nDWk0svlplLKNc5fEwWeWLXoWhjo5z4ealRyWW9Rv4b12O1Uw4sdEId14HcRidGUfrBWFKxoJQfosp3mTYPnXUvOZH9mIdLabjKpgxZT+7rVH70CCAQ8eD7QhczmDR14/edvWhuCRxc4Qc/DNTiDw+51pwj94DmZbRoSc/E0xZ+wayoBqmFXQ6h4ke77581LNc/1pcQEuJ1xQfySjge6BYcMaLVcWFcWZAiXRkma9ckLjdeDy4XU/BQYMXEVBqLn17O75U2TI3XR5F/Gn34aQKZSzz6gm94v1dtNjsy2SgMOzoIxiIvPl+6nfMce3411t4Ao+jx9K7EbvQsuh4UNroBt2KMoeptWUDp7xRhMiNe4yMkpMr2aG43UJWRpC0KDpVZpnyw6BUlrrymBKQXmkcAD9glT0vwPfk50oR9ME6t9Oh1E62J9S021RuceA5ee7yDqDrlUddFcQg9GBNxXjzQI1eFbV3FBbXj/3PdnWritvJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(30864003)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GJoA7hgnJn9hWaRbFWXKr1C5rLSWO1cwBSIOadqOOr3qxWAuOIQ1jLt8MwqX?=
 =?us-ascii?Q?1UTM0r58RsP/rTVR2jDL/SwI4MV+KEYo1eCY2Iodc6oAlRs4yWAgZeiqmGhJ?=
 =?us-ascii?Q?Jctump2SN62BousI9fU52kf2TuVPI8EPrS7OWptXpdUUrHtAwiqJ1wFnEP4C?=
 =?us-ascii?Q?kWr8sRg9Z/InLjUFxUcZgjyjvIpySewuXnY4Wi+MqyRgl6ooVkd+CJhucab1?=
 =?us-ascii?Q?Ooq0GTQVI6CYgAkrlvDcQh/isBQHSrQuj+WJxggzBClZDCZejoU1yD5X5tFy?=
 =?us-ascii?Q?P2Y2EYoRKt5TCaMTJVx+qKVALUMdi0MMvHgRuc80+qOzw8LuG17L8jxBdR09?=
 =?us-ascii?Q?U+dW01Swbq7DAKTjKdvjukpV0N01bL6LGNBO6iNrlBDaQw/oK8bTlj6Z23gS?=
 =?us-ascii?Q?mEfeFxb7bawiV7n9JkX9whJqX8HONDOLRTvJFV3kD5OMTNDyxCXD4e/UgX/Y?=
 =?us-ascii?Q?LgzMeACGnajZ+TOBVKiJ3rUku1TwSXvulemJziwGeyHVw/UmaaY3K5pRMb5J?=
 =?us-ascii?Q?wl/6nAxACegC0aCJWGQBIH5xYcYZ9RFQtIZyLB6CyGNx6E7n+ZG0b84xU3If?=
 =?us-ascii?Q?aVFHaFR98eD9QGgLmmHe0kXSmeYS4BUXa7k0rM8A3qx/jZe/RJ/O6yloZKQH?=
 =?us-ascii?Q?D5//XmHkG3XQGtnHgyN9RXM2g0n4VCTAbXeLy9vJodSL1hjU9s2txr6qRtFS?=
 =?us-ascii?Q?Zw+p/iMItFTA+Qzv96EOj4buyWaF0e7pwiDDMpBK4SyjCIz9E3ArA+v+tZWR?=
 =?us-ascii?Q?NlsS5M6IwumQ/ocSswjP9BxVwKsVzHj2lptQ5B4i/8LPiHsD9eiH7Iki6wH4?=
 =?us-ascii?Q?QWF1FGPTCyid7kpBsZdQFoVlm5if56EeOzppwcT8MYR/ys7epqvMaR4bePfr?=
 =?us-ascii?Q?ptakBmuGUiGRG/IqcE7cJh/UBAzpDTeqcKNCeEKmKDiAVdPLbeqlKUH8LXJb?=
 =?us-ascii?Q?yeyDfOiqs0BSiX6Gm8nGNg78ZeWXQ1kOQ6wCr1W4dE0P5oL5XRutbw6Og4Jy?=
 =?us-ascii?Q?nUPXI9tL1NclRLpfjwP2pM4TyumbcCxf1grE7yi16bqZOjqboptU2DZ5j3Zk?=
 =?us-ascii?Q?D31yepuSzNNYSMuFMDrsz+HEQCCfyp/YaLi8yT4BA2knfE1p3VGdQeRGD22v?=
 =?us-ascii?Q?uq9GtNOh1R8WImvbDEqYhly6hZePgI4eZdjkezomCRpaQDfoAh0BXHhk4tOC?=
 =?us-ascii?Q?pzHytNWYd5oiSprwb2O5VIlaJSB0gAGtpizudE+rZMGhC4Z/40ABjdSV7O1P?=
 =?us-ascii?Q?2q1GhDJqrhhCXNJG+ceARhdhdKdvFlB7ik2znjS0e3hXAteYNTMYNUeweZPw?=
 =?us-ascii?Q?IYft6dN3WYcf0A7WsYlW61wLP9r0AKEmcMtkH+X40F8+bLiDYND1UQ7xX0Sf?=
 =?us-ascii?Q?m4rODBs+0pC2/fePFPKyXLsgfCRumwczVRVf6MKBqOs7QIQil7w9e18Ty5r7?=
 =?us-ascii?Q?BOQsJnR2Z2/YFMdFlkNtr6c65yc+jr0CJcXESIzshCgzaJaGvjgSRqDzOi5R?=
 =?us-ascii?Q?FGrFmOvHbT1AdTDrItTFSrmEZRsmnzvFxqlN2SspJbM56c/DNEmnPrI87If4?=
 =?us-ascii?Q?T8u6UYFH7XJ8olr3Bikd0TVy/a/PE4Qi+yZD/qPLWOqvuMHCqCViZO1Zgo/h?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66db4b53-96b6-4b79-a68f-08da5953a798
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:05.6553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKV8x4pa08f7Dj4tWWeZ2tnvnr/0DSObfqgutwDoHPBkiPXRUE7yNOF6kSq6/dFMTZKFbLG8QM7Tb5YIpXFBdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes in v2:
- Move PCS_LYNX dependency to fman Kconfig

 drivers/net/ethernet/freescale/fman/Kconfig   |   2 +
 .../net/ethernet/freescale/fman/fman_memac.c  | 246 +++++++-----------
 2 files changed, 92 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
index 48bf8088795d..f5ef42bd2011 100644
--- a/drivers/net/ethernet/freescale/fman/Kconfig
+++ b/drivers/net/ethernet/freescale/fman/Kconfig
@@ -4,6 +4,8 @@ config FSL_FMAN
 	depends on FSL_SOC || ARCH_LAYERSCAPE || COMPILE_TEST
 	select GENERIC_ALLOCATOR
 	select PHYLIB
+	select PHYLINK
+	select PCS_LYNX
 	select CRC32
 	default n
 	help
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index a62fe860b1d0..2b274d50fafb 100644
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
@@ -1101,8 +980,12 @@ static int memac_free(struct fman_mac *memac)
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
@@ -1153,12 +1036,29 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
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
+	struct phylink_pcs	*pcs;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
 
@@ -1188,23 +1088,57 @@ int memac_initialization(struct mac_device *mac_dev,
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

