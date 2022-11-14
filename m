Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AEC628B09
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbiKNVIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiKNVIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:08:00 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2051.outbound.protection.outlook.com [40.107.22.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF41114;
        Mon, 14 Nov 2022 13:07:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4/VOTO17YLDRa2YPhGrq36/1Ri2L5txaiOB51bb4YRQ4NTWQcfI/RwPzl9DpZF4LSF8GbmpId6fyCGzEBiIeFEZ/COpiN4ky9qQGU81p/RFXSXCgx747bOixsq83qLzeHE+TWMPK5sqVRwwpw3bIBo9yA/hLTqz67e//0Tr2hCWHz/ntfmxj/lcGklLW8t5r2sSFtw/j0Ncj5972taTo8sZe+xGImpdaO6+pbaZzdDT5Td+/Dwib3696XfVVdGpa8sHhjLFl45nTh8SDpc9ADOA6yzmt6xSd4xSiqwmZcrqPljW/0ZFDYC5j7jK4VoxIXqZA7psfm0PWQZDE6cYNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjxcSIvL12nFFTzPtR1SUf+QUdxX+clFcMTQR2hZNJA=;
 b=KbvKgo4Gy4MXOprrIilytacjgJ9SfeAzUwI8Ag1AhIrHn8L8bME86hfaZ2fV1kniTCeAsnUFbBjJBcsJP+INVwJ2VoBhjbEqU+u64dyu38DPGtLR83LhRHTgUEw/lm0/mUA5adk2OnJiWvLwojAOaD+RLGyN0W0/j7Gs3Bpn9n5YhNPgdSkm1DzNzP1ZeSJ4Cd+PV+fP9cXQ2EKI6HqsHial0tVrNkTQcPMFZaWNpquD3MMCXHlNtqzZ9LwkUBbrafJ/rTdf4O3gEqkMWjqsV7UJdDjCDmBf4vjurJK9nutx+KmD6FcYdOes0T8Eg5sIcIfRk+s7atIr/HfhRjawZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjxcSIvL12nFFTzPtR1SUf+QUdxX+clFcMTQR2hZNJA=;
 b=z6CWTFQcdWLl+PQr4Of4S0sbZPiQbUzbfkmcJ8UK0HyZNjFTN+od1gY1Vo8X4w0xWZCQDVtxv3zwlFpYEF807j/LdyNS6ngaYvkLCX7L1AIWfm04BxbusC5+6j/OzgW/mb2zdo21iVuQHhivB88CatMIrK3S2bWTJ1BDI3Wa7o+UwZ8QvxdIhP/1yKcaLlDgda/vHj7wI3B2WxpQPO1Y6WA4gnokJ9i419rhpwrOxmJzAfmb+HfF3SGOAY2fELK+8PHrG89AKz3g3KJQXesYn7rEgvAKC+H3cymzr6MaOuu4IpIZfa8UTkOLDHUKIlXtT3Pj1Ez/8XPWEdfZiqWzHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9177.eurprd03.prod.outlook.com (2603:10a6:102:341::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.15; Mon, 14 Nov
 2022 21:07:54 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.018; Mon, 14 Nov 2022
 21:07:54 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] phy: aquantia: Configure SERDES mode by default
Date:   Mon, 14 Nov 2022 16:07:39 -0500
Message-Id: <20221114210740.3332937-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: bd78b9d9-4fdf-444e-ba71-08dac6844bc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HChHyHr9pwFIvihC4jAZJgx0dbiMA4ChIdbG9YkYfHGB0/uq1UxAPgMuStAdwz/+inivtqWOtM4UNXIigXsNpkbLCT5HCw+HqSK32m5CvOAfkLJojhEhTzaqgewDfA7TzRM3yHvnclhys37garLx5eUeAvL60kzPCkNWCtv6SbtwonwuAgpeODty4SdP66GovNQgxfT1sKnzrZ0ygHPqrciJFXSnfCs26UhhF+rllsECHbpupjc+61klxktojVh7GB4EYvVxkf0DLTNHGAUn8T7X1Obbo5SPgTm2e5FNc28pxFH8YS+MVrXXwvtcC5ER4mcNDiyLoPDfgYWnPEypqH+XKToG/KioBalkFMkPLt5Adu9EKK3khqIf+3iBryC4FNiJ0l8Y0/nVrphad7oduQIwkr1QOAeQZBmouDEd1IPG5Zq++3mX9CU7sIGiPAosvzG8FB/58ERrs7uwB3G1w8uruOUrm0/YHoVHsw7qCbiWUHW6AmXPIZdVOBxpmm4nyeHsVHrMdHj9aFskmbbJOf+Tz/0YDnjvRQKJ9WpwYtvY05Uh3ytX7U3nskettXlXxE8q4Ng/t9RFz1nwm/AhuD1cfR4T0CmAFifZDdt+zmjT4H1TSSm7xEj5jSg7vPTAP8kZQieyjmS61UMahBIWNG0QVCq7Pv5rna8070+pVDR9/IWRKlRCEZDjlZ60/4jIX/SGB2+9M3CpF6jZeBrp03sFt0lIRGE1RnHyhAhEI4CLPH6zc6KASxxBafvJiM3O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39850400004)(366004)(346002)(451199015)(41300700001)(8676002)(4326008)(316002)(6512007)(66946007)(66476007)(66556008)(36756003)(44832011)(5660300002)(7416002)(2616005)(52116002)(8936002)(186003)(1076003)(26005)(38350700002)(86362001)(38100700002)(2906002)(6666004)(107886003)(478600001)(6486002)(6506007)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EyD0NFc8HAtQXizyjCgRdoR7xq7Ic8kk7P+xKwTXntww1UxLHaxEHZK/t3HN?=
 =?us-ascii?Q?7M3eBwlm0j4daZmhkXhIamnsUX/FFqt9lNpmuK1QWtJoscgZtKpV2A68sAK3?=
 =?us-ascii?Q?Ib//TIxE9bahvjDjHigBgbqbl/dSXY6Tgh21wB4rVWIEc0EO6wiv/4hkjTeQ?=
 =?us-ascii?Q?GuynH8EksYOvNOqp5Ef5ffTwlj/w3lpHTGZN4X372xxNFCa1OPmXrMOmYta7?=
 =?us-ascii?Q?Hh4JHZ7AR6x8Ez94xKFW71dL5mt3XCIHrpmCkZd76+G1vpYiDv4hlXjKAFnP?=
 =?us-ascii?Q?gUEVShaYZB48QakfD8597PHwlD/h5s9nWYiDeAjJd3qpo2SNsAI4WrmGJCYH?=
 =?us-ascii?Q?TJa5YvKOJ68Ax4W1dMCLyi4HfyLgaOMlccav4Wgfz+j8f1xdhz+9ALt0YsB+?=
 =?us-ascii?Q?aN8eVTusvHDwLQg2N2WHIu26HUfX/ksNnlr/fUnnvIpxVrTDUz75/wU/5o6V?=
 =?us-ascii?Q?bS+eeLI7/NGfdRV7MO51S6Otzi5sRqndgLELnf94Pb4yrU5nB3+/dHxIipnM?=
 =?us-ascii?Q?i21iE0/H/PiE3e871v4A5cebRL3OZcv9RcjX6Ao09cQQkS2+cCYLbgx3E4Wg?=
 =?us-ascii?Q?s5PSJ4dOzrnCXODY2IEnLPYAdTZ7KQFLvRfVjrKZyXNNP2FwrTlaxDSsVU/5?=
 =?us-ascii?Q?d7RIFsBMhG+BpiX0UMA4cHVs+5gWLPrCINATBrpTKwSbLGQk7PefhWyZT+OS?=
 =?us-ascii?Q?6J74VKEEaQ7NUgx8fPD3IA1J7HPxzXHNhUp8U0OYgtPSMvpSPGfHCdePN/7e?=
 =?us-ascii?Q?nD+RfY7IpNtZL1INHI0jEp9k4aEenqUqY/XS90zYu/dbCTDr4I/9Ltcsjh8M?=
 =?us-ascii?Q?vc5Ea6Xl86uXtDL/0jHf9lhl++SIiSfv0swuy5IMs5nRX4klvZUfUSCaOtNc?=
 =?us-ascii?Q?4yKyAhhqQ2l1j5JapoxIC3s35hB+5EEPY5W+3sZw3bEx5+CPrX8PxvUW+v2Q?=
 =?us-ascii?Q?fuUnTX7trJYrZ/ZBb9Z0wInHcxcTikLReT5EcZk/CJcpc50mk2rZ7aN3Draq?=
 =?us-ascii?Q?wupk3x6dRR+euo5nNdsML86dC8exQ1aQ7D5qhin3XVL7X52VBT5L8m32fJtQ?=
 =?us-ascii?Q?oavHfur+NT5/00uq4ze0HYhXRJyIwKV/TecS/+b3/q3oNQcvXFNJFtIsNYnG?=
 =?us-ascii?Q?QhRFc0o7LY9T1yU7D2oK+0bWP93Fl37Up14l8FpfIuepZqEmHDN4aZp4TU+I?=
 =?us-ascii?Q?WuUrQiYcEux2nfhrC5zAcYEmJBriwNffEA/8ra0TxXRpv9hVOp2Xrbta1GNh?=
 =?us-ascii?Q?Vuibs0RmiDdR/a0bZstk2QLOlLFIx7iLeUbs5gXSPDry33ptM0vdkOPuejbj?=
 =?us-ascii?Q?rm0rg87tlyjSkPx2LE0KFLg0eNs5lvEnIMbDsNvy18pCn6P3rdtwITRzr7/I?=
 =?us-ascii?Q?QXtiW1gFge9rfIoegEcD2YkATjAD1AYfbTZH1rLqGVMEC4ojmg2ySm3FstYF?=
 =?us-ascii?Q?i7Q1Bn62tNGx1rVXOc31Rj/uo4hVJRmTZNmyS5mGkqCdpF1rCbVK+y01U+iT?=
 =?us-ascii?Q?WFwRpPaQ3o2HRheDfTByLvt+TrtgQjsrMyT36wZJWp/Qw5DaXbAkjjLx/R3U?=
 =?us-ascii?Q?W55CcjjhIQrH2DS2YogY2TOp/N0W7pw+PKzOTBEzWwLtUbzETRecMH29Ao8m?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd78b9d9-4fdf-444e-ba71-08dac6844bc5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 21:07:53.9953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HfJKD7NIoAV+U+wzvjsXoHiOr+hpoQbV/GAtWenEKIiqyBOppUWs2oEnlu9JJUuKGnSlFXvjLUZP8Eo0GXcTVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9177
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When autonegotiation completes, the phy interface will be set based on
the global config register for that speed. If the SERDES mode is set to
something which the MAC does not support, then the link will not come
up. The register reference says that the SERDES mode should default to
XFI, but for some phys lower speeds default to XFI/2 (5G XFI). To ensure
the link comes up correctly, configure the SERDES mode.

We use the same configuration for all interfaces. We don't advertise
any speeds faster than the interface mode, so they won't be selected.
We default to pause-based rate adaptation, but enable USXGMII rate
adaptation for USXGMII. I'm not sure if this is correct for
SGMII; it might need USXGMII adaptation instead.

This effectively disables switching interface mode depending on the
speed, in favor of using rate adaptation. If this is not desired, we
would need some kind of API to configure things.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/aquantia_main.c | 65 +++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 47a76df36b74..88a3defb632c 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -109,6 +109,10 @@
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+#define VEND1_GLOBAL_CFG_SERDES_MODE		GENMASK(2, 0)
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI	0
+#define VEND1_GLOBAL_CFG_SERDES_MODE_SGMII	3
+#define VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII	4
 
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
@@ -558,6 +562,63 @@ static void aqr107_chip_info(struct phy_device *phydev)
 		   fw_major, fw_minor, build_id, prov_id);
 }
 
+static int aqr107_global_config_init(struct phy_device *phydev)
+{
+	u16 mask = VEND1_GLOBAL_CFG_RATE_ADAPT | VEND1_GLOBAL_CFG_SERDES_MODE;
+	u16 val, serdes_mode, rate_adapt = VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE;
+	u16 config_regs[] = {
+		VEND1_GLOBAL_CFG_10M,
+		VEND1_GLOBAL_CFG_100M,
+		VEND1_GLOBAL_CFG_1G,
+		VEND1_GLOBAL_CFG_2_5G,
+		VEND1_GLOBAL_CFG_5G,
+		VEND1_GLOBAL_CFG_10G,
+	};
+	int i, ret;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEKX:
+		rate_adapt = VEND1_GLOBAL_CFG_RATE_ADAPT_USX;
+		serdes_mode = VEND1_GLOBAL_CFG_SERDES_MODE_SGMII;
+		break;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		serdes_mode = VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII;
+		break;
+
+	case PHY_INTERFACE_MODE_USXGMII:
+		rate_adapt = VEND1_GLOBAL_CFG_RATE_ADAPT_USX;
+		fallthrough;
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
+		serdes_mode = VEND1_GLOBAL_CFG_SERDES_MODE_XFI;
+		break;
+
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	val = FIELD_PREP(VEND1_GLOBAL_CFG_RATE_ADAPT, rate_adapt);
+	val |= FIELD_PREP(VEND1_GLOBAL_CFG_SERDES_MODE, serdes_mode);
+
+	for (i = 0; i < ARRAY_SIZE(config_regs); i++) {
+		ret = phy_modify_mmd(phydev, MDIO_MMD_VEND1, config_regs[i],
+				     mask, val);
+		if (ret) {
+			phydev_err(phydev, "could not initialize register %x\n",
+				   config_regs[i]);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int aqr107_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -581,6 +642,10 @@ static int aqr107_config_init(struct phy_device *phydev)
 	if (!ret)
 		aqr107_chip_info(phydev);
 
+	ret = aqr107_global_config_init(phydev);
+	if (ret)
+		return ret;
+
 	return aqr107_set_downshift(phydev, MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT);
 }
 
-- 
2.35.1.1320.gc452695387.dirty

