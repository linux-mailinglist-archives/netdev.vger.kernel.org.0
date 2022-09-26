Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ABC5EB0DA
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiIZTEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIZTDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:44 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DEC8A1D4;
        Mon, 26 Sep 2022 12:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlj7qjKPhGUV+C7XoXOCi/ua5GjIzv5gAJatRQUIvON+LjsaIjMWD+wQoI5keX7jnvc5Gv5TmMojenste0dnAv/TZhmAL/1WGBpDfXqATicHVsa2DocI0CbOnzRY3B4aqq6LI4XCMGa09DNmg0EdWInZ+QAsagk7pWJT8e0Qbhaer98O6TzT2ykhu4UGhqtv+0ZlGLTHIeGlTvfKswQc5f5yZvp7UdCsjPjspKbcLdlXgaDX2SwYiVwldNtNT3FWOFVGbuCVI9qjEeIl3J3c6R3edVb4TLBb/IG8CRMHbqB/394VtzA2glPBHSbvyG3Q+81xgbq3nplkutHGI6zwGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMNy2Do3HqQH5DPkIzy6nrVAzsYs9+I9nOYl8Mb1EXg=;
 b=K1XZPPvX34HmOveeMwVEBO7ZNRVYEJ93fC08bofMVGEnd6v4K/1ks0B+lxG4+ofM32x4x6OREtG45iR/v7ZTsBWz9jiciIt2EysKmZrHNwBvgc+LkOv1/cV1Y9qDwzOs0XStmkKqnzlXrFFUMw1GuqrDuY754HTcV+JMQFBjk+KVXnNsCiAESh/r6BVCmpi/xm7vhz/KM+1a7mc3i9fnTxI5yXadAi9LCCcr5LGXjCTuySafY00F+EJr3IfTeEYRpMlYxgVa1MZr36gc2LX+HHdX8KUkOmXag1mYBxTLFD8ho58PlzfWX6QyJgPCrAkgKNLrKzL/bwVDOH51QVCh0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMNy2Do3HqQH5DPkIzy6nrVAzsYs9+I9nOYl8Mb1EXg=;
 b=egjWBIAtI7lJ86M2rI3KHY2lTnm2YvmZDK2egtuyrSd/dmcxLG6vqr7lSPd+rONtHDcKl3B6C6esxIpn7yUzhaGUYNFDSnxusCNa28wNsrmzJygpzcsTp4Sc27ZDBkryIHrWtk+idKRMxe8SuYF6+V4c5z2Z2U6h7GHbqeMaLJ0D8bP+qXLyzt8V0Z4JOUF/bWGxV6hz07SEpCaNCqN0vpNP9kaLaFhu/wir20fNPgctJlcA6wTb9s+lvuxZ/RSu4/XUHCp943bsjTVtlw5wYpglDKVClBmrIoiSV5sFKT+jOfAV889jzJfImTNlM/iuD9lcddcD4Bx3cLqtmTcJhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:40 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 5/9] net: fman: memac: Use lynx pcs driver
Date:   Mon, 26 Sep 2022 15:03:17 -0400
Message-Id: <20220926190322.2889342-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d7b17ac-9dbd-4b69-06dd-08da9ff1d2f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CNMjqypDfCs2lCGAMlFGpwMaOpu99ymiB0ePicgZ8QqJ4LFLuxThm+iquFoWN4tjsM6rk9JeMUDZYtfyC/7TIK/u4fJT1461+4txxivBDUsCK2+70CurQOpwiyWJZSzmFcQTrW+WalFwXYHCSVAyhot2iRl2He7vfbdnAMqgcnMZCb3g0fkVKFMRcgrXSbeDea6enRj4w/flDGbh3Mlk2t7/64HqCg61LrfpMIWzm6oVkHTxkh5YYpOkL+NysXKN+1UtY7q6XTgysV3Hy/IlcAvhm7NMfy7UgXLJdpg1xzP0LHPnLIC6P3XPkwPpLvEHanLQNu7k7/hFlQSQZrs2XUrl4cF3tJOZFvaTtqLeZiG4m4VA65yTMRjJatGjwfNF04lVa4RSkTyXO9au+NSAe1VjA7+RxR8zDo6lU8ngXXBb9mtwgHci3vFk65kLw7wb+/uu3LY+amcOpu0Q04ihEGEzGJpUzv9I4kJrQy21ExNpjkRNlnoTCd+Bq4X5bQHvm6QBami4+dNZnBqNDRnpW5AfGgwMY6omvGnFaHSVG6KbKyXDskFndLEqV6MekhaDW+rQGlQnSZOEhAmMrrMA+nFdcZbJngW75/V0s9XjwKjUFmV1A6QT7rcDKhRDNygDDidApwbvdYW/qKRwqBO3CVscnZxaNGUbas4Y7mgbUR4bMqaHlk5icVYRaUd7+wVNSDd8IPwj0Ixsfal1XvaK2jvUEQrAmNGO9cRz2eaok7dnkhLbAHh/6JlWhwgNaXkeEuhI8FUlD0N1klRcASdMBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(107886003)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(30864003)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y35mDBTQWNC2uxzdBLuTzjnKWHLOJK1Rt6ZZW8wmP9GmnFNN8RUEjHmRGXZx?=
 =?us-ascii?Q?BKtjNeCCod8pGYo5M3jI6TKN3SgIr5/ptZLHFdQdUrDcIIGhPyEXu32ZyEIQ?=
 =?us-ascii?Q?HvCz/TYHQp8sZSs+JPV2Upt5mp98dVnKM35+c0qbrTRPgnL3Mh3jdpIg6aiI?=
 =?us-ascii?Q?Aq/EssjJ4mhkSfDlVgOfWXVKRTg7WtJpyDrvOr7AIUBVnOPmaI+Z9U0qu8DB?=
 =?us-ascii?Q?3fRu7Br6+3lVXVIfoEh3TT5yBygbNLPXiHwHNzteg3WGAG0gX769oFW6T4iC?=
 =?us-ascii?Q?ldiKWnLi5yKclpDRZMhrXhyzbfheTebYgW4G38oe6VtsWL1dJMGKwoLZJj3Q?=
 =?us-ascii?Q?IXv4AmxHMlQ9RdmbhGtzQpyEpK7EzftEd7zLDAyICYPY3HjzUvRT2lfRSnwd?=
 =?us-ascii?Q?myB7jYCF1cPu9n56ERKDXjHJ+A1MEsueDrdAwSzVRQMGb6RxA4KDKIk4jate?=
 =?us-ascii?Q?LW/JeB39Ymo3See5rlEBoRX5EGHX+2Ya5l2tm4Nh0aOhF00MQbK4CMJtj7SW?=
 =?us-ascii?Q?l+KJY3RK42NKNhzYnlKSdCyllXkGYqPfkW0pfJGq9/SNo8mErjr0ArxI0L+D?=
 =?us-ascii?Q?yTbvEOSeSZIAHsy2ydd9I5FmaKaX8sNMoWP518pHLTq2xHrG49v/5ZC3MmxU?=
 =?us-ascii?Q?EWb+6LI13YXdVSiXEF29Ihaurt0w2vVwZMUGL5dtS81107rh53X6Bi9ODU/D?=
 =?us-ascii?Q?QfrliKfnHKrULBEJYvF5TR4jgtNFwXz6PZGlhkWYXcyvetosEG5ivIn+pcFw?=
 =?us-ascii?Q?hR5z0rrnkzNI0IxLLqjrgsJdCL8/vkJOzkS9nk0QFdKIzaJIKVcsltzauZaC?=
 =?us-ascii?Q?AZhOSmgMQnBaJPykYLnVU0Mjytzj5d2brA4rFY0rmBQYiEp2QXg4FvLJKZcg?=
 =?us-ascii?Q?nZlrCGc97lP+xsaTRx8ohtjJsi+bfoEhAZUhlD+EbjtNY/y9ZTAqtullDvzB?=
 =?us-ascii?Q?1H/GritaT6MAvOccuiIrosoql3dmrx5b8jUkpAuvEcG98e+3hpZclKhVFIok?=
 =?us-ascii?Q?yQuIjMyAgxUdOKES4i6avC2d8+uNyf/cNLZT6TGuna9HO+TCyvKvy8DhV8ku?=
 =?us-ascii?Q?IRKUnR3q6jX/QULPVSEEj2nSlJ9otBOEv/nxN5Mv+s4gvdYrHlebABP8s7OK?=
 =?us-ascii?Q?aUj4EmrkBPgq5l0yEITzls8NwI6Z6Qaifg4722U9GsGHFoTEXJo4eqvouZUI?=
 =?us-ascii?Q?8ikxKG31PNe9UCqoOUU/DKOezlYnKpYLo51jh7oKatJAo8VIYxkMdKqXHTZ4?=
 =?us-ascii?Q?+hOUnUBB27ks661WFp+TJikBnaxSaTWScHRPmemxGlvB30irq528ceMsEGFH?=
 =?us-ascii?Q?LcHzpwAfKqs1vaQMxkzD/zvCp/ahpEwDLPmd//cIYL57EPkOCVhu8roRAamL?=
 =?us-ascii?Q?P+zqb2EwgoekH9OoWibclfhMjDUj52o+v3ZFmtOrfkfFvGYi0eynAwnaij1R?=
 =?us-ascii?Q?XX9G18ZALsNa0pPTPOS0UqWMD+5dpuIlQ57Kumg81p1EiOrutxt+izpeAUuM?=
 =?us-ascii?Q?J0ClYQLBKdKm+mHGjeXIj+nxC8hFUXSsy1dPDIfA9ARg8cKmJgmFbkOCuX5l?=
 =?us-ascii?Q?hAL9yBQfNRsMy7GXq1RMVis5e7+u/WhFsG6wU/gldpKtY9vJhmZNDhEw49N0?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7b17ac-9dbd-4b69-06dd-08da9ff1d2f6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:40.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPr2NeBnqxTTDequ9eGXvL3SWB4Ww/HVT6pis/B5za1rJIQbblEoD4S/XoZPa04kc23vuJmPyXydexTZabwtxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
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
index 56a29f505590..80ae34bea818 100644
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
 	struct fixed_phy_status *fixed_link = NULL;
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

