Return-Path: <netdev+bounces-1019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3524E6FBD4E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65B351C20A5B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3527C1840;
	Tue,  9 May 2023 02:31:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E18B182A9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:31:21 +0000 (UTC)
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31F7A26F
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:31:13 -0700 (PDT)
X-QQ-mid: bizesmtp78t1683599363th4a0iuw
Received: from wxdbg.localdomain.com ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 May 2023 10:29:22 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: 239gR2IZrluXH4ewZ/jEdDFZ2mhiCj/FsuThKf9VcwReuyqtfr6+3DDXmo6ep
	LKA1LIgis+XNkvlLP1+1nkM3x847SzqqL4MDtnc/6oCAYzm+W5Faw8T8JalWvg0RO8Qd2uG
	kao13jGPOkXhM+TPUwQfOlVJlLQAGCqpyjOrT29ioM5RbyKGyQ+i0ZwoOa7O5zTAHsReWCl
	UA77Vsv5ayCcvCWR8vR3iBMMSmHuBRnyE941EVi7TKA0Z3XLsIf5VALwgTSR8TvZ/BjR/Ig
	vH8oQSwozFPA6+FJIeSjTNAw2j8LdoGK59CavV2rY+OhU9YUbYdoymgWRei7ZI5DHudE+CM
	ooaJ434hyp5t7CF4w2SYimZhIkFABGGGX+o8lk0izWZ3TTdhvaE6SvFhKLTLUQR/ZUlPnjc
	i/SFtwEOJUw2NM93zwXNYw==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5223412395742533194
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	jsd@semihalf.com,
	Jose.Abreu@synopsys.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v7 7/9] net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
Date: Tue,  9 May 2023 10:27:32 +0800
Message-Id: <20230509022734.148970-8-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230509022734.148970-1-jiawenwu@trustnetic.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add basic support for XPCS using 10GBASE-R interface. This mode will
be extended to use interrupt, so set pcs.poll false. And avoid soft
reset so that the device using this mode is in the default configuration.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 30 ++++++++++++++++++++++++++++++
 include/linux/pcs/pcs-xpcs.h |  1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 539cd43eae8d..c7c8b8d1311f 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -64,6 +64,16 @@ static const int xpcs_xlgmii_features[] = {
 	__ETHTOOL_LINK_MODE_MASK_NBITS,
 };
 
+static const int xpcs_10gbaser_features[] = {
+	ETHTOOL_LINK_MODE_Pause_BIT,
+	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+	ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+	__ETHTOOL_LINK_MODE_MASK_NBITS,
+};
+
 static const int xpcs_sgmii_features[] = {
 	ETHTOOL_LINK_MODE_Pause_BIT,
 	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
@@ -106,6 +116,10 @@ static const phy_interface_t xpcs_xlgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_XLGMII,
 };
 
+static const phy_interface_t xpcs_10gbaser_interfaces[] = {
+	PHY_INTERFACE_MODE_10GBASER,
+};
+
 static const phy_interface_t xpcs_sgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_SGMII,
 };
@@ -123,6 +137,7 @@ enum {
 	DW_XPCS_USXGMII,
 	DW_XPCS_10GKR,
 	DW_XPCS_XLGMII,
+	DW_XPCS_10GBASER,
 	DW_XPCS_SGMII,
 	DW_XPCS_1000BASEX,
 	DW_XPCS_2500BASEX,
@@ -246,6 +261,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 
 	switch (compat->an_mode) {
 	case DW_AN_C73:
+	case DW_10GBASER:
 		dev = MDIO_MMD_PCS;
 		break;
 	case DW_AN_C37_SGMII:
@@ -872,6 +888,8 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		return -ENODEV;
 
 	switch (compat->an_mode) {
+	case DW_10GBASER:
+		break;
 	case DW_AN_C73:
 		if (phylink_autoneg_inband(mode)) {
 			ret = xpcs_config_aneg_c73(xpcs, compat);
@@ -1033,6 +1051,9 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
 		return;
 
 	switch (compat->an_mode) {
+	case DW_10GBASER:
+		phylink_mii_c45_pcs_get_state(xpcs->mdiodev, state);
+		break;
 	case DW_AN_C73:
 		ret = xpcs_get_state_c73(xpcs, state, compat);
 		if (ret) {
@@ -1188,6 +1209,12 @@ static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
 		.num_interfaces = ARRAY_SIZE(xpcs_xlgmii_interfaces),
 		.an_mode = DW_AN_C73,
 	},
+	[DW_XPCS_10GBASER] = {
+		.supported = xpcs_10gbaser_features,
+		.interface = xpcs_10gbaser_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_10gbaser_interfaces),
+		.an_mode = DW_10GBASER,
+	},
 	[DW_XPCS_SGMII] = {
 		.supported = xpcs_sgmii_features,
 		.interface = xpcs_sgmii_interfaces,
@@ -1290,6 +1317,9 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 		}
 
 		xpcs->pcs.ops = &xpcs_phylink_ops;
+		if (compat->an_mode == DW_10GBASER)
+			return xpcs;
+
 		xpcs->pcs.poll = true;
 
 		ret = xpcs_soft_reset(xpcs, compat);
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index d2da1e0b4a92..61df0c717a0e 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -18,6 +18,7 @@
 #define DW_AN_C37_SGMII			2
 #define DW_2500BASEX			3
 #define DW_AN_C37_1000BASEX		4
+#define DW_10GBASER			5
 
 struct xpcs_id;
 
-- 
2.27.0


