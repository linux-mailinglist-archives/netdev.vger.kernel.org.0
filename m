Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64047D8D7
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbhLVVfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:35:16 -0500
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:58757
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234838AbhLVVfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 16:35:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9MlnL6o+osealNA3icOAsuQHnplRkuCfP9j6jeC4fzCuDGinU2tVmc9GL9WaN5DNKXDX5zsEB+gZtkVCE9+65Ugd9kaguHKe01jbE0v3bI9WZy7LbWEl+CYvMCfCy+702bgiwtNY4W5UL1Q3wpKq46CbFquf2gc0lFieU0kB/8WLkaV3BXzy8C24YVxObJAoF6OEa2hB1j+zUxp7CwW+RLo81ZIwY9udIH4xyIasOqx+Opx/nJFSeJ5OuuMVidgqxThge/nV8R9wOy+kFyIOnFmnh1QZXCDbhJdr7EQ03fnLVzTAGipGgR0fubwcwtkKHekYKQo/9rKrfsnfGYugQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I26+jQ0sNZlzKP69es2jb1Fb1qkwqvFa0C1hVB3gqFo=;
 b=RQ/3IHLytbroGmEGnj/dDjZCl0/8ZFF9Oo6/GDc3HM9hyxsQrYljBLz9AJdvvdt/MALx8ikg37xnFEgwgxZ5FneE58/bOcRwnxGomlhwJG0m/mf0YQXUX8qsL6TRseAo2El3oNPvLWqA1Zp1peOjJse2xjmprOwkoKvuKat98i76T8AZXCTcsXzhloQCVeLefaa6OPyTpnA4wddANutVYm4t4RafLVzWb34wNmxRphadmyjb2lCHN3h7yW8M0XIbNMv/Nqr9Vv7HeMK/eGiX7wP3szozpBrxRzIUyh1aMrQuCKRhBcZrnC0L8VipKgAN5U6eM3zxsh1o7UD7ZvqHwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I26+jQ0sNZlzKP69es2jb1Fb1qkwqvFa0C1hVB3gqFo=;
 b=B+VyiLPfwPg4DMvZOMEvPAvnuc1q4Lij4PdFB6AoUGwIrsTUYvEPI7+HIq4/1FkjGfYJeNFg5oOgG68Y3XI/KyAh3+0Xc+CzHLSrPlBkloF9Zz4fy0A0hnB9ErlFz7EgD5dtgiUJuuUfv+Sue4EJWvnl+oC/y1YDjUaAu37ZSU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8732.eurprd04.prod.outlook.com (2603:10a6:20b:43f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Wed, 22 Dec
 2021 21:35:11 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%7]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 21:35:11 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 1/2] phy: nxp-c45-tja11xx: add extts and perout support
Date:   Wed, 22 Dec 2021 23:34:52 +0200
Message-Id: <20211222213453.969005-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
References: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0100.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::41) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 407fc991-8d86-4c3d-cc4d-08d9c592eec0
X-MS-TrafficTypeDiagnostic: AM9PR04MB8732:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB8732076FF32FBFF21BEF774F9F7D9@AM9PR04MB8732.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G7uZ0rmAr6nW470fQtlTGrfcWiwcg0J/rFG/Gp/0GUTqR9cqjru671qi+EYoM6aJhMesRjDTeWq+QrXlUvSj7Pk7LN1BdTNbm5oVyDDsWeRJHfrlx47b+KV/eG12+1DyE8qQtxLUazphzxhLmC+pob0gtMB1jMN872N74XFrp0eDmOkHaNTFiz7Cq9XN2W6gRaPNBCptuEb8TT5YWSe8Ci1xQBywLIg4iyBaG9JCCbB1O7Col7pV2QqYnl1ewBY7OABACinP5PExqvEUeH3BrE+MFocDfjjeiXM31UW7aRXqt5CAZxlzrchKfJA5pLiCE+UckuBI+xWDpn+UpKb4ZgnE0m4ZmJRIVfarbZB4ZEs7AmqF0zddiml2hi9PF8EuQQblLAUVH5EiNr3EMADx/KGmjsHKJcC0TWEa5G5VxdxRUloBHTLN4kKpgrxK/S3jikypO+MAq0no82zykGGAMrJwdg9VuNulF5NrePbqTCD0N+I1MeqKrepS8obZLY03zOCuhKLSEX3nk+uLWO8fJpr9dYc6lAs2Iei8Ys99BuLrvZoZdAdyhFQxXL5BnfQrtBwY4Px89R+PDH57ETfOPlJlFEcxzxy5R6QqeKaiKOqfQZtToaeEE5VoRzNUiQVcHXunpmHsATXXQ/DxheHcNtIOzlr/ta21wHjGKWYzq5HaklpqJmhf8p1rAZDkN0lbpKJ0Qyjb9pqFATgjKucGQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(26005)(8936002)(6666004)(66574015)(8676002)(186003)(6506007)(66556008)(66476007)(83380400001)(316002)(1076003)(52116002)(508600001)(86362001)(2906002)(6512007)(4326008)(2616005)(6486002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lad4jYCpkkN6SB7ZF96Kfz/OGMsznJ/omjC1++j7htNhqsd9R39XPgvFzMM9?=
 =?us-ascii?Q?IqtKpnHv8i7+MkAwOGtebgnpeYoymdPjrhVmorPwNUZJOoy/FAPOORDWcHrN?=
 =?us-ascii?Q?Xb280TOd8elOlAIUj6eiWa5eW9P/lnvaXMYclJR+6WIzHWXu62qVsLZKbuZ7?=
 =?us-ascii?Q?BGBOG9R8phAvlqvMg7PvJ+lkfaGZZ+RkGazsQfpCbaLFrOBjPpvR3zdw+gRt?=
 =?us-ascii?Q?ZS3YPLr+vncPtoHwEd6Bzw5rP8ZuQbovZ5E6YMhcxCnYP48yRtAro9g9q2nm?=
 =?us-ascii?Q?CkFJMz9GsscPW3Nyew7i5IDbxiq4vD9nPEYk8F23x6ghxhXRSUrmHUnAAu2K?=
 =?us-ascii?Q?nahWUI0ySEIxmZNoWVOXu2t6LUofaRqFLom4jdnE1AB2AMMOYCtGp+lamxm4?=
 =?us-ascii?Q?QdXc2fFlkpetU/j00m/UJUMPOm8/WxZm3Gvos3c0BLDHC0XaAu69WTWv9YGI?=
 =?us-ascii?Q?Vvy2nkVE+dAzQy0t314d/Fsg22MGrdy8w7X2v8PbI7pRgOHvdt16rLKE6ghd?=
 =?us-ascii?Q?oXWPIC1cT0ZQdCb67L6c+K97Uznsw+iB0/vhKttf4ZkK2HlFEupOfffrTkDT?=
 =?us-ascii?Q?b1CurEhBl2NhfLZ+fiSOTykUUAht2K/OXhpy9q08dxXS5aApW/AzGgY+ElMy?=
 =?us-ascii?Q?3fJFxeVYUZrz374CrSWAY/HB4wLLDZ9yK32QKgyKkT5q5/iargxVmLsgyZWe?=
 =?us-ascii?Q?wbS2CI1LfZyhw7DIR+1f+zVvEX/Dx31uwdJYeHVysy3mgyfTgWexe29WHlzY?=
 =?us-ascii?Q?xU4HS1bNggLzd+rJJ8p6CfLhLwViadeFnCJwal6oKNF/Y79WOx7bx2pEWQIU?=
 =?us-ascii?Q?gpQVCXGBycegpIY79wUfF2Tqd8bRFbf2z3JZJQ4gka06sYuinMauYt6kX81h?=
 =?us-ascii?Q?vgOuVROnAql6dMhKzmIE6EO329d/0phsjV6xmiGq6uzRyrezywP0bjOY6XnW?=
 =?us-ascii?Q?l/hgUeEbwYNI/enwCCyRrh63Rh6mFrRQnzRvaNDMrLeuMDREorXuz1pFAPyo?=
 =?us-ascii?Q?gOytiubigLjTD+y0UtePDKQlJOawnkk0eVqqzDMuN1XKxPy7bygquzKFmEi5?=
 =?us-ascii?Q?HY32QlecrolrsLJyuCZU1gLw3DeqpoYqJFqx2bLXi+2d06HTyflL/QFmLO0y?=
 =?us-ascii?Q?i97cXqrrpy0wrqNFO0Z/JrT0haaUnaM0zGF2vVFWGeuAWE31+zwNi19m0PIL?=
 =?us-ascii?Q?E/qAUH9d8YDtfQh4yAZxRSgbl7JcQrmovx7iPg/WLr9POgJ9Gxgxn/gcp11G?=
 =?us-ascii?Q?Sq3+/1ey9tz8jRBIf00Suynv+6csprTRM5XduZk3GxrqMW+tXIk1Q/QNoHl4?=
 =?us-ascii?Q?y2mQUj6jpsGdX2J2Ecvu2K8In+oZla/t3h/VYeWKDhrP8msDXStrdaS8I/RV?=
 =?us-ascii?Q?V4Q3HHxx1Ds7axQD/F0m+uLNNy4aQwfTzDs45wPvyUoYSiF31M1ZddGnH58Q?=
 =?us-ascii?Q?BSu0s8Rs85ABA7nMoZnvlByIEvG67ElLwvuw8SRbof4KEUGgBLzlKQ4aOijN?=
 =?us-ascii?Q?OMEMKu4CAWYqDEJjabHtw6qK264SHKp6MIqiO1LxFK+Ba4/IWbyL4DtryPJy?=
 =?us-ascii?Q?fbunI55YmER9dq5Mo4yZIh3X2ovy5I4RaL616dT/DSMfQI/hrJ8lVoG0YeRg?=
 =?us-ascii?Q?9qGD7hTxPXHClj1F1TRrksk6HrgxpGQEAoVz1ahI88L3epyLeXRDsV3OxHNM?=
 =?us-ascii?Q?ia07I4KwNbdzXoXvUbMEvcibtlA=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407fc991-8d86-4c3d-cc4d-08d9c592eec0
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 21:35:11.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWiY0Naq1FzZkLv/ACIX35bujxkYXv8cseZ/3aCGt7mchtt3Eg2/1oQ5I04E/rS7CEx4qXJHAUrlTho+poeSJ8Jg+fjKhPBgcsaIvmN9Yo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for external timestamp and periodic signal output.
TJA1103 have one periodic signal and one external time stamp signal that
can be multiplexed on all 11 gpio pins.

The periodic signal can be only enabled or disabled. Have no start time
and if is enabled will be generated with a period of one second in sync
with the LTC seconds counter. The phase change is possible only with a
half of a second.

The external timestamp signal has no interrupt and no valid bit and
that's why the timestamps are handled by polling in .do_aux_work.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 220 ++++++++++++++++++++++++++++++
 1 file changed, 220 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 91a327f67a420..06fdbae509a79 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -97,6 +97,11 @@
 #define VEND1_TX_IPG_LENGTH		0xAFD1
 #define COUNTER_EN			BIT(15)
 
+#define VEND1_PTP_CONFIG		0x1102
+#define EXT_TRG_EDGE			BIT(1)
+#define PPS_OUT_POL			BIT(2)
+#define PPS_OUT_EN			BIT(3)
+
 #define VEND1_LTC_LOAD_CTRL		0x1105
 #define READ_LTC			BIT(2)
 #define LOAD_LTC			BIT(0)
@@ -132,6 +137,13 @@
 #define VEND1_EGR_RING_DATA_3		0x1151
 #define VEND1_EGR_RING_CTRL		0x1154
 
+#define VEND1_EXT_TRG_TS_DATA_0		0x1121
+#define VEND1_EXT_TRG_TS_DATA_1		0x1122
+#define VEND1_EXT_TRG_TS_DATA_2		0x1123
+#define VEND1_EXT_TRG_TS_DATA_3		0x1124
+#define VEND1_EXT_TRG_TS_DATA_4		0x1125
+#define VEND1_EXT_TRG_TS_CTRL		0x1126
+
 #define RING_DATA_0_DOMAIN_NUMBER	GENMASK(7, 0)
 #define RING_DATA_0_MSG_TYPE		GENMASK(11, 8)
 #define RING_DATA_0_SEC_4_2		GENMASK(14, 2)
@@ -162,6 +174,17 @@
 #define VEND1_RX_PIPE_DLY_NS		0x114B
 #define VEND1_RX_PIPEDLY_SUBNS		0x114C
 
+#define VEND1_GPIO_FUNC_CONFIG_BASE	0x2C40
+#define GPIO_FUNC_EN			BIT(15)
+#define GPIO_FUNC_PTP			BIT(6)
+#define GPIO_SIGNAL_PTP_TRIGGER		0x01
+#define GPIO_SIGNAL_PPS_OUT		0x12
+#define GPIO_DISABLE			0
+#define GPIO_PPS_OUT_CFG		(GPIO_FUNC_EN | GPIO_FUNC_PTP | \
+	GPIO_SIGNAL_PPS_OUT)
+#define GPIO_EXTTS_OUT_CFG		(GPIO_FUNC_EN | GPIO_FUNC_PTP | \
+	GPIO_SIGNAL_PTP_TRIGGER)
+
 #define RGMII_PERIOD_PS			8000U
 #define PS_PER_DEGREE			div_u64(RGMII_PERIOD_PS, 360)
 #define MIN_ID_PS			1644U
@@ -199,6 +222,9 @@ struct nxp_c45_phy {
 	int hwts_rx;
 	u32 tx_delay;
 	u32 rx_delay;
+	struct timespec64 extts_ts;
+	int extts_index;
+	bool extts;
 };
 
 struct nxp_c45_phy_stats {
@@ -339,6 +365,21 @@ static bool nxp_c45_match_ts(struct ptp_header *header,
 	       header->domain_number  == hwts->domain_number;
 }
 
+static void nxp_c45_get_extts(struct nxp_c45_phy *priv,
+			      struct timespec64 *extts)
+{
+	extts->tv_nsec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				      VEND1_EXT_TRG_TS_DATA_0);
+	extts->tv_nsec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				       VEND1_EXT_TRG_TS_DATA_1) << 16;
+	extts->tv_sec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				     VEND1_EXT_TRG_TS_DATA_2);
+	extts->tv_sec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				      VEND1_EXT_TRG_TS_DATA_3) << 16;
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EXT_TRG_TS_CTRL,
+		      RING_DONE);
+}
+
 static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 			       struct nxp_c45_hwts *hwts)
 {
@@ -409,6 +450,7 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
 	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
 	struct skb_shared_hwtstamps *shhwtstamps_rx;
+	struct ptp_clock_event event;
 	struct nxp_c45_hwts hwts;
 	bool reschedule = false;
 	struct timespec64 ts;
@@ -439,9 +481,181 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 		netif_rx_ni(skb);
 	}
 
+	if (priv->extts) {
+		nxp_c45_get_extts(priv, &ts);
+		if (timespec64_compare(&ts, &priv->extts_ts) != 0) {
+			priv->extts_ts = ts;
+			event.index = priv->extts_index;
+			event.type = PTP_CLOCK_EXTTS;
+			event.timestamp = ns_to_ktime(timespec64_to_ns(&ts));
+			ptp_clock_event(priv->ptp_clock, &event);
+		}
+		reschedule = true;
+	}
+
 	return reschedule ? 1 : -1;
 }
 
+static void nxp_c45_gpio_config(struct nxp_c45_phy *priv,
+				int pin, u16 pin_cfg)
+{
+	struct phy_device *phydev = priv->phydev;
+
+	phy_write_mmd(phydev, MDIO_MMD_VEND1,
+		      VEND1_GPIO_FUNC_CONFIG_BASE + pin, pin_cfg);
+}
+
+static int nxp_c45_perout_enable(struct nxp_c45_phy *priv,
+				 struct ptp_perout_request *perout, int on)
+{
+	struct phy_device *phydev = priv->phydev;
+	int pin;
+
+	if (perout->flags & ~PTP_PEROUT_PHASE)
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(priv->ptp_clock, PTP_PF_PEROUT, perout->index);
+	if (pin < 0)
+		return pin;
+
+	if (!on) {
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_CONFIG,
+				   PPS_OUT_EN);
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_CONFIG,
+				   PPS_OUT_POL);
+
+		nxp_c45_gpio_config(priv, pin, GPIO_DISABLE);
+
+		return 0;
+	}
+
+	/* The PPS signal is fixed to 1 second and is always generated when the
+	 * seconds counter is incremented. The start time is not configurable.
+	 * If the clock is adjusted, the PPS signal is automatically readjusted.
+	 */
+	if (perout->period.sec != 1 || perout->period.nsec != 0) {
+		phydev_warn(phydev, "The period can be set only to 1 second.");
+		return -EINVAL;
+	}
+
+	if (!(perout->flags & PTP_PEROUT_PHASE)) {
+		if (perout->start.sec != 0 || perout->start.nsec != 0) {
+			phydev_warn(phydev, "The start time is not configurable. Should be set to 0 seconds and 0 nanoseconds.");
+			return -EINVAL;
+		}
+	} else {
+		if (perout->phase.nsec != 0 &&
+		    perout->phase.nsec != (NSEC_PER_SEC >> 1)) {
+			phydev_warn(phydev, "The phase can be set only to 0 or 500000000 nanoseconds.");
+			return -EINVAL;
+		}
+
+		if (perout->phase.nsec == 0)
+			phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					   VEND1_PTP_CONFIG, PPS_OUT_POL);
+		else
+			phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+					 VEND1_PTP_CONFIG, PPS_OUT_POL);
+	}
+
+	nxp_c45_gpio_config(priv, pin, GPIO_PPS_OUT_CFG);
+
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_CONFIG, PPS_OUT_EN);
+
+	return 0;
+}
+
+static int nxp_c45_extts_enable(struct nxp_c45_phy *priv,
+				struct ptp_extts_request *extts, int on)
+{
+	int pin;
+
+	if (extts->flags & ~(PTP_ENABLE_FEATURE |
+			      PTP_RISING_EDGE |
+			      PTP_FALLING_EDGE |
+			      PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* Sampling on both edges is not supported */
+	if ((extts->flags & PTP_RISING_EDGE) &&
+	    (extts->flags & PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(priv->ptp_clock, PTP_PF_EXTTS, extts->index);
+	if (pin < 0)
+		return pin;
+
+	if (!on) {
+		nxp_c45_gpio_config(priv, pin, GPIO_DISABLE);
+		priv->extts = false;
+
+		return 0;
+	}
+
+	if (extts->flags & PTP_RISING_EDGE)
+		phy_clear_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				   VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+
+	if (extts->flags & PTP_FALLING_EDGE)
+		phy_set_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				 VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+
+	nxp_c45_gpio_config(priv, pin, GPIO_EXTTS_OUT_CFG);
+	priv->extts = true;
+	priv->extts_index = extts->index;
+	ptp_schedule_worker(priv->ptp_clock, 0);
+
+	return 0;
+}
+
+static int nxp_c45_ptp_enable(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *req, int on)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	switch (req->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return nxp_c45_extts_enable(priv, &req->extts, on);
+	case PTP_CLK_REQ_PEROUT:
+		return nxp_c45_perout_enable(priv, &req->perout, on);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct ptp_pin_desc nxp_c45_ptp_pins[] = {
+	{ "nxp_c45_gpio0", 0, PTP_PF_NONE},
+	{ "nxp_c45_gpio1", 1, PTP_PF_NONE},
+	{ "nxp_c45_gpio2", 2, PTP_PF_NONE},
+	{ "nxp_c45_gpio3", 3, PTP_PF_NONE},
+	{ "nxp_c45_gpio4", 4, PTP_PF_NONE},
+	{ "nxp_c45_gpio5", 5, PTP_PF_NONE},
+	{ "nxp_c45_gpio6", 6, PTP_PF_NONE},
+	{ "nxp_c45_gpio7", 7, PTP_PF_NONE},
+	{ "nxp_c45_gpio8", 8, PTP_PF_NONE},
+	{ "nxp_c45_gpio9", 9, PTP_PF_NONE},
+	{ "nxp_c45_gpio10", 10, PTP_PF_NONE},
+	{ "nxp_c45_gpio11", 11, PTP_PF_NONE},
+};
+
+static int nxp_c45_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+				  enum ptp_pin_function func, unsigned int chan)
+{
+	if (pin >= ARRAY_SIZE(nxp_c45_ptp_pins))
+		return -EINVAL;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+	case PTP_PF_EXTTS:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int nxp_c45_init_ptp_clock(struct nxp_c45_phy *priv)
 {
 	priv->caps = (struct ptp_clock_info) {
@@ -452,7 +666,13 @@ static int nxp_c45_init_ptp_clock(struct nxp_c45_phy *priv)
 		.adjtime	= nxp_c45_ptp_adjtime,
 		.gettimex64	= nxp_c45_ptp_gettimex64,
 		.settime64	= nxp_c45_ptp_settime64,
+		.enable		= nxp_c45_ptp_enable,
+		.verify		= nxp_c45_ptp_verify_pin,
 		.do_aux_work	= nxp_c45_do_aux_work,
+		.pin_config	= nxp_c45_ptp_pins,
+		.n_pins		= ARRAY_SIZE(nxp_c45_ptp_pins),
+		.n_ext_ts	= 1,
+		.n_per_out	= 1,
 	};
 
 	priv->ptp_clock = ptp_clock_register(&priv->caps,
-- 
2.34.1

