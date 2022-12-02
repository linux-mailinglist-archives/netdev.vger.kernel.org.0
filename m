Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93532640CF8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiLBSSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiLBSRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:17:49 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2065.outbound.protection.outlook.com [40.107.105.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4257CE033;
        Fri,  2 Dec 2022 10:17:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPZs4FxbeWFbjDR1qdEUo3mr7R4413KO4+V/TC6wDbfUd/gWZ3maeGwZNXOXQmVo4XkYAL455Q+ANl4jofp9yZv8UB3mB7OziYi5zQ0+20SzaFXmALtK66cqEFwj3LUhq8HAjuLt06xs/Aq+h3bX9WNl+/tGp6arryQcc0EIXw19zaENmBZKdqUV2aurmy+g0uS6+Sf0FuhHRwzH60FyngdTWpHEnRE422oKC0xXfFAyzHFqnuucCCBTMBemZVvp8xGdxKgGKkwmwXL77iDzb7JHrxZkthNn8byDn6MM9mExLCMlou8yv2ntdU8CJCgy/Unfs+DuiJgUS4gk97HTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7oe1/5YiY+Ivy2JKtDWcCbtfT6qLTsYByF7Nzyz0upo=;
 b=Me3lpWmSvwasonV9bjeJtqsCq6R3cCI3WfqXkgonlzAxSVZio/EcrRxcgxWRoy4cM0XlspYbkceeOU7JPDVV0yBf4hI/KoJsXplxyoZHFJeOB6MkVrMOFVaenEoz/d19ToLNJyg5ilICjHRFUDPuhpd9zaryvP2yCUciMaI1dyLX0W/2kuV4INV7kDq+BpR6FoMLd7AIY0cM90Y4KLnDFEL1FNQyAuHFA5Tc2qVGmglH1IrwuOehOUacEPphJH94VmGG/BnNu6Vci0RkBie4JugXebVatSwF8djXMMPHOI+ZKg59oya0Vf4yoYLeBX7OC6Kj81PyUjFTWIMl+o5b+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7oe1/5YiY+Ivy2JKtDWcCbtfT6qLTsYByF7Nzyz0upo=;
 b=ygR9tGwX+kSRBVkSenHjUNRbr0V0WxSVc/G6lCbwlQ3WL7O6j1nAOJeoo8er9UCSaRb7ht+/p1oHxwZ7b4pZLVsa4WIRLwpYZgHFVZZvkK3eOXNPqtYVeL04++ECw0Omd3MMjkByHyQ8hHPVRQbb1IJi1yamQuhDIQU2zbtEdSdid4SdokjzqKpZqGICwfih5ShE0ENXtPND73jEVxPmjP2QoUpk7hMoC/NrCrUbBTuASyruwLx+S/VrvcvSkWh7oZAKWcizhiDGvUb/ImYntH/gI5N+bohMMB4OdxrMYBNWOIXQLgefi0P4B33OlNO7Cv5fXkX/d2W6F/l4/70zmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DBBPR03MB7081.eurprd03.prod.outlook.com (2603:10a6:10:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 18:17:35 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 18:17:35 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 3/3] phy: aquantia: Determine rate adaptation support from registers
Date:   Fri,  2 Dec 2022 13:17:18 -0500
Message-Id: <20221202181719.1068869-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221202181719.1068869-1-sean.anderson@seco.com>
References: <20221202181719.1068869-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::17) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DBBPR03MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: f7f5f568-d0c1-4d21-ab31-08dad4917cb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32ClNpma67miASy056cdMJytovhxcAlHXV1Do5666B6hpNiKpDsl9mAWPkjBGg/HSKEoV6OV5Az0sID792Anmu7HcBVZKkBB8clNT0vSQgGLUNjJwrEnkAqBmdjOWqKUOeJivGjYXU89bxlNyVpPg0KlKrKlVOJ36vc0JRqJMUXUqAzJsrJCWXwE54w+qeqJt4ojWnYgsY44Fv24C2jMbIYDxlbNS4QPl+XJiHoJEiktJOCPAVofEOssBdSe1RCK161idNa1INeV6v2IrgmjQO24B40FqEc+NW+lVNObk3xlQQgfuuvv+JoH/pImV7AGRfU0b0i95NXv7CIx2mx4bK6iZWyETQ4pL24ghw2PqBCqfS8Y4pQdsnmrOpSLRET9UQW25F6YHFfvKW/WD7BLSuJe4qhVUoZhEzopHqXL/LvvEsTZKztsIsyWfOKI7ZqpnMWwZSepZdSMzCN4S9ojgXNzHRXHn8NEfp/diaAghOMcDtEQx7j7ODNDzB0NYmLylBrfmrNX5G+PgvcdRjzQGrEy58qIo+FWb4IvLuN9VaPruM1YrS1XRk+A4/GbnowmwE7LTf8AL+Dxo0kr8wezs+fmXStz244ZbxGLa58ubUatmHcp4UjT2Lk/SjIcB/b+Z3lNI3gRR4yz5/yOclYRBerMIDrpdfJ2PGc5YAQTyRLuFLkdyf1pSl25iXzI6XgJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39850400004)(396003)(366004)(376002)(451199015)(36756003)(38100700002)(38350700002)(86362001)(54906003)(316002)(110136005)(8676002)(107886003)(6666004)(478600001)(6486002)(26005)(6512007)(6506007)(52116002)(83380400001)(1076003)(186003)(41300700001)(2906002)(66556008)(66476007)(2616005)(7416002)(5660300002)(4326008)(66946007)(44832011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XFENNtkrNPstkY3IZdJ4IRb6W/vscNJHwDOMmQ2l4EWxJg4e6cjN6bvOWA2A?=
 =?us-ascii?Q?kiTLKv9grISyQkPSmyDzjRhuSrnm+SJBNvubhVpYR7V6FnsS4ntmaGLDGl2Y?=
 =?us-ascii?Q?iJbNMOKVaSl3Ye2Su6Q5vJH4U69T4IcVhERmsMC9Yd0wb/lm2bHbMJOLcp/0?=
 =?us-ascii?Q?Rvg1gnCVCW/E3+ku1qKcY2oBgNR4fVDB4G78i1Umwhubis+ie8ORuEPQd4Fm?=
 =?us-ascii?Q?evYBuHHs1Y0bBySu5Kl/vQSxonzksSl8a6oUXqUsw7wC5AxgvuUthXSIELC3?=
 =?us-ascii?Q?pa7OIJiHqwhNVyRYuMsogZ/nbk5cSDIJzu/aVFMIEdE51hipB4mFyppe7jAG?=
 =?us-ascii?Q?UkKgTGFvb/v5AEG/32BGgDMf/Mn6ogDSUuN8FgQkMjje+Nh4snvarYXKsarr?=
 =?us-ascii?Q?EOlehjJPVNEFncUpbtOiPa5611Z9Xv9M28SnID7jltdUjH8nNpMjKVUyuldt?=
 =?us-ascii?Q?i91DRNOjncWA6jHUf+Tom3/qj0F94HSvidPY6CjApfMOmSMqraXPlo3ziHKo?=
 =?us-ascii?Q?NQKIHrPtwgcJP3Boj/tJ1jmhybv2lIRKLXVC9kTXFIwgcagqm/Z9YV9irmyc?=
 =?us-ascii?Q?OfHIsE/xMfTR7b8qfoUi4qdRPj7e+wEE3vefwh1fmtpuIpf/xQFtvXeaK6VY?=
 =?us-ascii?Q?X3jpxQs4aCkPlLdqVZ1z26YLtN38rSF/ffwRh9nYpKiEEq4eHEP8O90TpASs?=
 =?us-ascii?Q?YFkK4iNgwHRaQVSO1wP4EmfMW59NN5VdrNb9KbTBwVPQdy8dNTk+1r55Mujt?=
 =?us-ascii?Q?9/PclJ+y8BcvG4ImnXaqXfLQwZwEawj/uM/92JmDtBppEVZ3+qm0UT7qGd9p?=
 =?us-ascii?Q?IzsGQdU98M23z/tpeNew3aei8+dSVvog+RVIpXsVHyf4aJviO0cUJox+wJ2e?=
 =?us-ascii?Q?Yfr+DNxLx8nOdXqNi3UU3ppehiDhcqsz6skS+lrbtKL+qmyHd51Za5Dk38D/?=
 =?us-ascii?Q?5pgrajgRsedA6A6X3BA+MfpVzITmGtBQdAX9Q+4ed9qcxtbiKD3xXVGJ8PnL?=
 =?us-ascii?Q?bUQJElGx7UN6QBT1Tq9fIXeOJ9TMi3oHUHggWEz7VvLxwUT5HQCYm4oHqEb4?=
 =?us-ascii?Q?M2qfB5tArBtdPuB9XBZxq7yblQNFyi+Pft8UMPbPbqBYRIO/ImtuPHO09XR4?=
 =?us-ascii?Q?PEHNwBeN9Mu465239SohpysEVBrYV/X6CXHIbKKkIrPkmQjrae3NYUfWKhTv?=
 =?us-ascii?Q?/taXMmXzyZ/ygFnToGNSssB4vtwnmQVGaNW/TXyTeccECJkqtPRzBXq13Z5K?=
 =?us-ascii?Q?OC8JavWQx3yG2yzARdj/NHzxqoBWo8Ix9P34l+c61cRRQ0xTH4Ik1l10tNPT?=
 =?us-ascii?Q?4YTDa4J77gzotIr+4CzjyTJexkRgxT48XQWjHVgm6dugg2ItYTyrKyJFoZxf?=
 =?us-ascii?Q?hYOxL3CkdGZXzk71EL3u27Ma1nCfOYcGqXw4Gs1tQNMCfIf7yFNVtTGFQ1Dd?=
 =?us-ascii?Q?2laHhwyIfeCUa64KvoDBWIWgHpbxxrOIriVIZDDJ4CEPeQItZ9NHmF3c/aLz?=
 =?us-ascii?Q?2vob0to1pzEJsMQPEqHehYUR6mG4A+bBb2KsZMVTdwbBBvD9qisGk5ro82hg?=
 =?us-ascii?Q?JyZ2eSn1tNHe7ZOQXs5OLNRRLg5QnaHOmE8aT8N2r+ZEfHr5XmBC2gp3Ul6Y?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f5f568-d0c1-4d21-ab31-08dad4917cb1
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 18:17:35.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkl0jAZk2S0ObZUB3k+F4giFUAPwRK0QGQ3TmsAozrAG5oQpClddU84+kZ5xpqMh62gAKk0r/82p1mE8FYembg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7081
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
up. To avoid this, validate each combination of interface speed and link
speed which might be configured. This way, we ensure that we only
consider rate adaptation in our advertisement when we can actually use
it.

The API for get_rate_matching requires that PHY_INTERFACE_MODE_NA be
handled properly. To do this, we adopt a structure similar to
phylink_validate. At the top-level, we either validate a particular
interface speed or all of them. Below that, we validate each combination
of serdes speed and link speed.

For some firmwares, not all speeds are supported. In this case, the
global config register for that speed will be initialized to zero
(indicating that rate adaptation is not supported). We can detect this
by reading the PMA/PMD speed register to determine which speeds are
supported. This register is read once in probe and cached for later.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This commit fixes 3c42563b3041 ("net: phy: aquantia: Add support for
rate matching"). In an effort to avoid backporting of this commit until
it has soaked in master for a while, the fixes tag has been left off.

Changes in v3:
- Fix incorrect bits for PMA/PMD speed

Changes in v2:
- Rework to just validate things instead of modifying registers

 drivers/net/phy/aquantia_main.c | 160 ++++++++++++++++++++++++++++++--
 1 file changed, 154 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 334a6904ca5a..e157e000d95b 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -111,6 +111,12 @@
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_NONE	0
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_USX		1
 #define VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE	2
+#define VEND1_GLOBAL_CFG_SERDES_MODE		GENMASK(2, 0)
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI	0
+#define VEND1_GLOBAL_CFG_SERDES_MODE_SGMII	3
+#define VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII	4
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G	6
+#define VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G	7
 
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
@@ -175,6 +181,7 @@ static const struct aqr107_hw_stat aqr107_hw_stats[] = {
 
 struct aqr107_priv {
 	u64 sgmii_stats[AQR107_SGMII_STAT_SZ];
+	int pmapmd_speeds;
 };
 
 static int aqr107_get_sset_count(struct phy_device *phydev)
@@ -677,13 +684,146 @@ static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
 	return 0;
 }
 
+/**
+ * struct aqr107_link_speed_cfg - Common configuration for link speeds
+ * @speed - The speed of this config
+ * @reg - The global system configuration register for this speed
+ * @speed_bit - The bit in the PMA/PMD speed ability register which determines
+ *              whether this link speed is supported
+ */
+struct aqr107_link_speed_cfg {
+	int speed;
+	u16 reg, speed_bit;
+};
+
+/**
+ * aqr107_rate_adapt_ok_one() - Validate rate adaptation for one configuration
+ * @phydev: The phy to act on
+ * @serdes_speed: The speed of the serdes (aka the phy interface)
+ * @link_cfg: The config for the link speed
+ *
+ * This function validates whether rate adaptation will work for a particular
+ * combination of @serdes_speed and @link_cfg.
+ *
+ * Return: %true if the @link_cfg.reg is configured for rate adaptation, %true
+ *         if @link_cfg.speed will not be advertised, %false otherwise.
+ */
+static bool aqr107_rate_adapt_ok_one(struct phy_device *phydev, int serdes_speed,
+				     const struct aqr107_link_speed_cfg *link_cfg)
+{
+	struct aqr107_priv *priv = phydev->priv;
+	int val;
+
+	phydev_dbg(phydev, "validating link_speed=%d serdes_speed=%d\n",
+		   link_cfg->speed, serdes_speed);
+
+	/* Vacuously OK, since we won't advertise it anyway */
+	if (!(priv->pmapmd_speeds & link_cfg->speed_bit))
+		return true;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_VEND1, link_cfg->reg);
+	if (val < 0) {
+		phydev_warn(phydev, "could not read register %x:%.04x (err = %d)\n",
+			    MDIO_MMD_VEND1, link_cfg->reg, val);
+		return false;
+	}
+
+	phydev_dbg(phydev, "%x:%.04x = %.04x\n", MDIO_MMD_VEND1, link_cfg->reg, val);
+	if (FIELD_GET(VEND1_GLOBAL_CFG_RATE_ADAPT, val) !=
+		VEND1_GLOBAL_CFG_RATE_ADAPT_PAUSE)
+		return false;
+
+	switch (FIELD_GET(VEND1_GLOBAL_CFG_SERDES_MODE, val)) {
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI20G:
+		return serdes_speed == SPEED_20000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI:
+		return serdes_speed == SPEED_10000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_XFI5G:
+		return serdes_speed == SPEED_5000;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_OCSGMII:
+		return serdes_speed == SPEED_2500;
+	case VEND1_GLOBAL_CFG_SERDES_MODE_SGMII:
+		return serdes_speed == SPEED_1000;
+	default:
+		return false;
+	}
+}
+
+/**
+ * aqr107_rate_adapt_ok() - Validate rate adaptation for an interface speed
+ * @phydev: The phy device
+ * @speed: The serdes (phy interface) speed
+ *
+ * This validates whether rate adaptation will work for a particular @speed.
+ * All link speeds less than or equal to @speed are validate to ensure they are
+ * configured properly.
+ *
+ * Return: %true if rate adaptation is supported for @speed, %false otherwise.
+ */
+static bool aqr107_rate_adapt_ok(struct phy_device *phydev, int speed)
+{
+	static const struct aqr107_link_speed_cfg speed_table[] = {
+		{
+			.speed = SPEED_10,
+			.reg = VEND1_GLOBAL_CFG_10M,
+			.speed_bit = MDIO_PMA_SPEED_10,
+		},
+		{
+			.speed = SPEED_100,
+			.reg = VEND1_GLOBAL_CFG_100M,
+			.speed_bit = MDIO_PMA_SPEED_100,
+		},
+		{
+			.speed = SPEED_1000,
+			.reg = VEND1_GLOBAL_CFG_1G,
+			.speed_bit = MDIO_PMA_SPEED_1000,
+		},
+		{
+			.speed = SPEED_2500,
+			.reg = VEND1_GLOBAL_CFG_2_5G,
+			.speed_bit = MDIO_PMA_SPEED_2_5G,
+		},
+		{
+			.speed = SPEED_5000,
+			.reg = VEND1_GLOBAL_CFG_5G,
+			.speed_bit = MDIO_PMA_SPEED_5G,
+		},
+		{
+			.speed = SPEED_10000,
+			.reg = VEND1_GLOBAL_CFG_10G,
+			.speed_bit = MDIO_PMA_SPEED_10G,
+		},
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(speed_table) &&
+		    speed_table[i].speed <= speed; i++)
+		if (!aqr107_rate_adapt_ok_one(phydev, speed, &speed_table[i]))
+			return false;
+
+	/* Must match at least one speed */
+	if (i == ARRAY_SIZE(speed_table) && speed != speed_table[i].speed)
+		return false;
+
+	return true;
+}
+
 static int aqr107_get_rate_matching(struct phy_device *phydev,
 				    phy_interface_t iface)
 {
-	if (iface == PHY_INTERFACE_MODE_10GBASER ||
-	    iface == PHY_INTERFACE_MODE_2500BASEX ||
-	    iface == PHY_INTERFACE_MODE_NA)
+	if (iface != PHY_INTERFACE_MODE_NA) {
+		if (aqr107_rate_adapt_ok(phydev,
+					 phy_interface_max_speed(iface)))
+			return RATE_MATCH_PAUSE;
+		else
+			return RATE_MATCH_NONE;
+	}
+
+	if (aqr107_rate_adapt_ok(phydev, SPEED_10000) ||
+	    aqr107_rate_adapt_ok(phydev, SPEED_2500) ||
+	    aqr107_rate_adapt_ok(phydev, SPEED_1000))
 		return RATE_MATCH_PAUSE;
+
 	return RATE_MATCH_NONE;
 }
 
@@ -713,10 +853,18 @@ static int aqr107_resume(struct phy_device *phydev)
 
 static int aqr107_probe(struct phy_device *phydev)
 {
-	phydev->priv = devm_kzalloc(&phydev->mdio.dev,
-				    sizeof(struct aqr107_priv), GFP_KERNEL);
-	if (!phydev->priv)
+	struct aqr107_priv *priv;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
+	phydev->priv = priv;
+
+	priv->pmapmd_speeds = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_SPEED);
+	if (priv->pmapmd_speeds < 0) {
+		phydev_err(phydev, "could not read PMA/PMD speeds\n");
+		return priv->pmapmd_speeds;
+	};
 
 	return aqr_hwmon_probe(phydev);
 }
-- 
2.35.1.1320.gc452695387.dirty

