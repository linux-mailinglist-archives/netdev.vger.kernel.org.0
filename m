Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5DF601957
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJQUXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiJQUXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:34 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2072.outbound.protection.outlook.com [40.107.22.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82B075CD0;
        Mon, 17 Oct 2022 13:23:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8kQSCREehqH3FruOlayOEX3lPUZ+xY0WNapnG2iPk/Ym0Sdo5IBwQtKnsbHoRoTjcMCWop3NwW7kqFzCzMJLnTiX+aFK179SGYbIZSKbFxnhj3M1bbZC3qSbKF44eR0x1MvchLKFewh6iA+aMd0+qs+YtmCxH/MsMwazYOaael8XbyRkUqbCgEK2obQO/JEA3NvHQJ/AHCXhIcjOUxPon6eZ2a6ew7E0AesTzcDSe1aKCQYBabetMgT9GHK9e42SZAQ/jeVJ3RHtNdAMyI26rxH3s+F9CfuhGAXqOrHvgS2o6hi/oknhf64ndCM7nA0IyuSogVH3fjYAA7GRakv7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ToGFumyXaTeCIX2Hj+aHE0WG0pqor0zNtySve3aq7g=;
 b=Kz8LZTOPgJpQBXZGOHCCIcxt4WfKOGpj0ImXxS8PRXB6UJQRGHRsGukfnlU7H4y6HsyT4v/qPO0kOp8sXI3UzVyZa4GddbyHIZLW01d7GTB+Ms6bJEzhwtxY3jrWQu0m3BcZ447sO+FPUFPgxktYgIJv7EmGwsS/D7pODtTYcfVzyXfRmvahyzFIpc/+oVyzHVxm4rTZgNQz9NzKC8PVbWH6dHg7FfCIhGTJGVYnztfAHgZpKEapqsmewdgPcCTRjXsvi3TbcYaE924ZZe/r2e9SlJTGqhmHUD2QhR4MKBbxSYtc2Z8Obg313rVAc5nLISpRYnS0KTAs+lMitsbzGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ToGFumyXaTeCIX2Hj+aHE0WG0pqor0zNtySve3aq7g=;
 b=YPHRn18T9Ne4xKTaUwYSLshaQWtX9X5PqIyp5+PJScj4eF9Pmde2S+TohIjALCKFTTafS/ZyJMnPLgMSRMgL4DigmLYTBkRlNZGiMJYwMvNaqdls1CoQLxCYDC2DmMMp8/t1a4TcdT449Sl5RgmiNctEGv+aLx0VPCYK23dbUyVKKPw/WGrl0Z0RfaKNvTOmsOCQZQl3t2jTVQvkUFAwpwk1wkenARj7Fd7W9LVx+V7yVpYXicpKrGdTiFWpgAQ22cDDft3yUKlELx4O9m7OHPwjDq/MZxvyAbGo1H3e9v61EYq+2budq5mUogNzVg7cWbfHr4I6lyOXZhwvnYrwzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB4PR03MB8635.eurprd03.prod.outlook.com (2603:10a6:10:385::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.28; Mon, 17 Oct
 2022 20:23:24 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:24 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v7 06/10] net: fman: memac: Use lynx pcs driver
Date:   Mon, 17 Oct 2022 16:22:37 -0400
Message-Id: <20221017202241.1741671-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DB4PR03MB8635:EE_
X-MS-Office365-Filtering-Correlation-Id: 69d3a497-bba0-4ab8-e7a5-08dab07d7126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHpxuAdMaOPCR4zLKD2QNT7gEJQwZhZjJOL3tcuvEi9gOpG2cQ1oQmD0SvphuqyifURk8PpFAZ4Rrf0ID6zG0edAS/x1a7XKLT58uH16FMNw/GiBsNBuJ3/bxEKMoXtCpgdSa6osE1UvlAhm3hMnVyYmlHqXXU+g0/XzdmRj0RL1oOUHwQXvGyZQIRdnDdrIkXZyyUcopg+jIb5gF//Tt1Kh+xEmCVH39itKn/16AAg87ydOamWQbIGLBKsTD+AStejaBvNS8GR7Os8e00DaDqjfDHau/yct01/aNgrF8piqjEH97ej0nT8Dw3LzRGbJHlwk62sN7GT5sJee4Xc+mK1PQ7x0209ufXMzsaS6cL81eifV6QvudLIni4x7dhUimLjPiTvem7pWhVG9kDvWSo0q4Bd/lMr3qWAoF+qDrHDNMmgu/Zzc2Wq5mTJWbFv/f7LBY1YhWWiPBgtrPRt4IFEsLbhm8KaEAfn0XgTgPNroQ3NmMBnNM86ju0nRY6pYhAooA3M6tY/ZDg1k6cFzoIU8tCD4S51TFs0KLkcXHXHBskgs/mBMxfFN75HY/hYzYPRNcnEsfJV7UfZhdi146o70jZq0jtGrCJs8Uth0ztQFOr9hC+gf7tg7am0nfk5Fe+qNdrKKo7yST3XfGtunfxekPEYHhJ5K6XSA8RqLcl6tuQRRPVt6WLieSs0ZzZk+E7iHj4lumSg0wwb8pKdSVPVNy3hLXI754a6rAasiFg247NSQLGexb5AUnxhT09Y6JPOgGP0oSDgCtyToxbUK+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39840400004)(366004)(346002)(376002)(396003)(451199015)(36756003)(86362001)(30864003)(7416002)(38100700002)(44832011)(2906002)(5660300002)(38350700002)(2616005)(186003)(1076003)(83380400001)(52116002)(6506007)(316002)(478600001)(26005)(6512007)(110136005)(6486002)(54906003)(66946007)(66556008)(66476007)(41300700001)(4326008)(8936002)(6666004)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YN5h/jso7SK3qi+sQkJ1+uz9HpEZA8rOeNrDQL+HtRQOYsLig42fbZZEpzuw?=
 =?us-ascii?Q?RKTqnp1Dc2ah5tKJQEDAV4xtf9k6+OqSOrgc3CDNsAcH0q7Dw+moB18OsBl/?=
 =?us-ascii?Q?2o6wr1O0JXsPzEkZN4I3uZC7Nuv7to4CTYt5E3uMxiEaVOsuo7BSGgiqh+Km?=
 =?us-ascii?Q?bS3UqxQIO8OIkkQlbp4dBMe2vw8JOCEfwqsz3b3H4ttahMyFMOKENkUuqgsE?=
 =?us-ascii?Q?DjEMFyAxWOf9xMWXWff1u+cO2SuqbExBw3JnheJDqXwtUMpHVgRmjPG3l4wM?=
 =?us-ascii?Q?U86sXotT0sGf1sWCj9kajm9HU+KJn3briWs6QECtXqhNtben8OkBEYFJnkRO?=
 =?us-ascii?Q?Fn/gDAkeG0pHh51f4y53gMNihlZfLA4vFgr1kyVKAh4ct/cMnDdjV+CN+Wwz?=
 =?us-ascii?Q?J3rn9JTGp03nlDAnfY7Yeb6EjdFG/0xSnm5ciCIQavJukpBYaZxIjO84NSmK?=
 =?us-ascii?Q?s1Cd2z/DqkzFfpOt+U7PQqWMldaI74Mbt+fWNzJOz/gcKaRZpmwvSJbcZb6N?=
 =?us-ascii?Q?7qQM30zzbzl2UOTgMd7VO8E0cKQe4eAuQOTaBNaIGK51X7xyWvM3e6UV5+Fs?=
 =?us-ascii?Q?b8UMvvEBjvzuFGoAR3l3sijGIr7na+7uXfwn91p6fXx6otuTWCXneKNUc/uL?=
 =?us-ascii?Q?lqiaEdIchBkZR+uThqkN5bhIkvFqmPyeuTBqjAI3MrkKA5+yuDSus7/7KwS/?=
 =?us-ascii?Q?GPkXKxhAlzOAi5Tb6Zg6ZZrd2gByfzZ2t1Kyvuw0iMFaBAFpbXWdVcKS7w2k?=
 =?us-ascii?Q?AgzzjSAeVZtjLJL7sZmV/wrf08kckCrAVyBa5qzvYVoKx49XNlV6jcJhJsYe?=
 =?us-ascii?Q?LesaXnWjdVmW7T40Y7ZASTMqQfhMqk1VJOiVpbFsvXCLX5SQnnrbB4jElQQL?=
 =?us-ascii?Q?K0M0yyFFziKPdia34ROlIwx7vniA4fNKMHnfqV4FZPgl6pG/y2PscrjwNcpC?=
 =?us-ascii?Q?SIioy+tIOYSJi4e2AKLxpQN1S3IWGETMsyLu/dwcmQ5N0cK0Nj6kgnw6VR4F?=
 =?us-ascii?Q?U2NnqwdT4ZFXNcxF04pKdeF95zE7WbraKrQXtHmk6bIN6xqcnEZcaG/8DwYj?=
 =?us-ascii?Q?7xl/zMyhj0wLMQcTASesXL2vTf2Ltp4blpAJGVugzo7UNT0/YHkkejZJjRXJ?=
 =?us-ascii?Q?qaGPX3Fq6mGYpraic8SPgwt28LYz1ypyzfJHb9flXHRS8KoP/dcIYHAm3+Ta?=
 =?us-ascii?Q?s3CQF/y9CHfW2L1WyzOZ84tbAQisSS1yb2wkRBlpqxr0q/gW+6l8Xd0E2Riu?=
 =?us-ascii?Q?RScI4YzxpfuNfGjNk/H+8ZXr6Qwq9osWWk/5wjhYDn0LpNYbIsLYNRARX1WW?=
 =?us-ascii?Q?IkN7iF5/aCTQJPi/axPqUSns9RzYq6fBkzQFSWkhRRSoqMFx36TQev+V038o?=
 =?us-ascii?Q?LYvw0i/xJgUN9PPbZPUh/0/f6klaETwHLVRMSJC4uAbrrzaDt9GcyfpS/t57?=
 =?us-ascii?Q?OCInQqykdKv55MaUN1Yht8dZuqYhzpuTI2HVbUEb5XkEMC1U8LDm3N0Za87l?=
 =?us-ascii?Q?IA7qv/w5EaNs/qY5ZBPfY/QPJnVS9DhPpOruglWtd9iqbwfoRrxMg4nTUQ7p?=
 =?us-ascii?Q?VLBkRDjXui1XwNOlBP5w4i7eq4o8ZNpPCxVYvf5bG6GbxlDYdCAiS5j9D6Dp?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d3a497-bba0-4ab8-e7a5-08dab07d7126
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:24.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F47kHnxVHpPL3cpyRzIig3+dMwfIucAZaWziDW0HwWu8HkzTWjn348pIyjhGHBMdvM7pnxeQfF55Qv57dWi6ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR03MB8635
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

Changes in v7:
- Fix oops if memac_pcs_create returned -EPROBE_DEFER
- Fix using pcs-names instead of pcs-handle-names
- Fix not checking for -ENODATA when looking for sgmii pcs

Changes in v6:
- Fix 81-character line

Changes in v3:
- Put the PCS mdiodev only after we are done with it (since the PCS
  does not perform a get itself).

Changes in v2:
- Move PCS_LYNX dependency to fman Kconfig

 drivers/net/ethernet/freescale/fman/Kconfig   |   3 +
 .../net/ethernet/freescale/fman/fman_memac.c  | 258 +++++++-----------
 2 files changed, 105 insertions(+), 156 deletions(-)

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
index 56a29f505590..43584946cae2 100644
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
+	if (IS_ERR_OR_NULL(pcs))
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
 
@@ -1188,23 +1099,58 @@ int memac_initialization(struct mac_device *mac_dev,
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
+	err = of_property_match_string(mac_node, "pcs-handle-names", "xfi");
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
+	err = of_property_match_string(mac_node, "pcs-handle-names", "qsgmii");
+	if (err >= 0) {
+		memac->qsgmii_pcs = memac_pcs_create(mac_node, err);
+		if (IS_ERR(memac->qsgmii_pcs)) {
+			err = PTR_ERR(memac->qsgmii_pcs);
+			dev_err_probe(mac_dev->dev, err,
+				      "missing qsgmii pcs\n");
 			goto _return_fm_mac_free;
 		}
+	} else if (err != -EINVAL && err != -ENODATA) {
+		goto _return_fm_mac_free;
+	}
+
+	/* For compatibility, if pcs-handle-names is missing, we assume this
+	 * phy is the first one in pcsphy-handle
+	 */
+	err = of_property_match_string(mac_node, "pcs-handle-names", "sgmii");
+	if (err == -EINVAL || err == -ENODATA)
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
 
+	/* If err is set here, it means that pcs-handle-names was missing above
+	 * (and therefore that xfi_pcs cannot be set). If we are defaulting to
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

