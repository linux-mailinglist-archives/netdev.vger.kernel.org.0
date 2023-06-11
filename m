Return-Path: <netdev+bounces-9859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A0872AFD6
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D9F71C20A40
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 00:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9993A10E3;
	Sun, 11 Jun 2023 00:40:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A3B7F0
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:40:36 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC9A30F6;
	Sat, 10 Jun 2023 17:40:34 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1q898D-0005FI-0s;
	Sun, 11 Jun 2023 00:40:33 +0000
Date: Sun, 11 Jun 2023 01:39:48 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: [PATCH net-next 6/8] net: ethernet: mtk_eth_soc: convert caps in
 mtk_soc_data struct to u64
Message-ID: <ZIUX1AkjbSHdiMUc@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenzo Bianconi <lorenzo@kernel.org>

This is a preliminary patch to introduce support for MT7988 SoC.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_path.c | 22 +++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  | 62 ++++++++++----------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 317e447f49916..34ac492e047cb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -15,10 +15,10 @@
 struct mtk_eth_muxc {
 	const char	*name;
 	int		cap_bit;
-	int		(*set_path)(struct mtk_eth *eth, int path);
+	int		(*set_path)(struct mtk_eth *eth, u64 path);
 };
 
-static const char *mtk_eth_path_name(int path)
+static const char *mtk_eth_path_name(u64 path)
 {
 	switch (path) {
 	case MTK_ETH_PATH_GMAC1_RGMII:
@@ -40,7 +40,7 @@ static const char *mtk_eth_path_name(int path)
 	}
 }
 
-static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, int path)
+static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, u64 path)
 {
 	bool updated = true;
 	u32 val, mask, set;
@@ -71,7 +71,7 @@ static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, int path)
 	return 0;
 }
 
-static int set_mux_gmac2_gmac0_to_gephy(struct mtk_eth *eth, int path)
+static int set_mux_gmac2_gmac0_to_gephy(struct mtk_eth *eth, u64 path)
 {
 	unsigned int val = 0;
 	bool updated = true;
@@ -94,7 +94,7 @@ static int set_mux_gmac2_gmac0_to_gephy(struct mtk_eth *eth, int path)
 	return 0;
 }
 
-static int set_mux_u3_gmac2_to_qphy(struct mtk_eth *eth, int path)
+static int set_mux_u3_gmac2_to_qphy(struct mtk_eth *eth, u64 path)
 {
 	unsigned int val = 0, mask = 0, reg = 0;
 	bool updated = true;
@@ -125,7 +125,7 @@ static int set_mux_u3_gmac2_to_qphy(struct mtk_eth *eth, int path)
 	return 0;
 }
 
-static int set_mux_gmac1_gmac2_to_sgmii_rgmii(struct mtk_eth *eth, int path)
+static int set_mux_gmac1_gmac2_to_sgmii_rgmii(struct mtk_eth *eth, u64 path)
 {
 	unsigned int val = 0;
 	bool updated = true;
@@ -163,7 +163,7 @@ static int set_mux_gmac1_gmac2_to_sgmii_rgmii(struct mtk_eth *eth, int path)
 	return 0;
 }
 
-static int set_mux_gmac12_to_gephy_sgmii(struct mtk_eth *eth, int path)
+static int set_mux_gmac12_to_gephy_sgmii(struct mtk_eth *eth, u64 path)
 {
 	unsigned int val = 0;
 	bool updated = true;
@@ -218,7 +218,7 @@ static const struct mtk_eth_muxc mtk_eth_muxc[] = {
 	},
 };
 
-static int mtk_eth_mux_setup(struct mtk_eth *eth, int path)
+static int mtk_eth_mux_setup(struct mtk_eth *eth, u64 path)
 {
 	int i, err = 0;
 
@@ -249,7 +249,7 @@ static int mtk_eth_mux_setup(struct mtk_eth *eth, int path)
 
 int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
 {
-	int path;
+	u64 path;
 
 	path = (mac_id == 0) ?  MTK_ETH_PATH_GMAC1_SGMII :
 				MTK_ETH_PATH_GMAC2_SGMII;
@@ -260,7 +260,7 @@ int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id)
 
 int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
 {
-	int path = 0;
+	u64 path = 0;
 
 	if (mac_id == 1)
 		path = MTK_ETH_PATH_GMAC2_GEPHY;
@@ -274,7 +274,7 @@ int mtk_gmac_gephy_path_setup(struct mtk_eth *eth, int mac_id)
 
 int mtk_gmac_rgmii_path_setup(struct mtk_eth *eth, int mac_id)
 {
-	int path;
+	u64 path;
 
 	path = (mac_id == 0) ?  MTK_ETH_PATH_GMAC1_RGMII :
 				MTK_ETH_PATH_GMAC2_RGMII;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 08d1e73985f08..9bd7261449d13 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -875,44 +875,44 @@ enum mkt_eth_capabilities {
 };
 
 /* Supported hardware group on SoCs */
-#define MTK_RGMII		BIT(MTK_RGMII_BIT)
-#define MTK_TRGMII		BIT(MTK_TRGMII_BIT)
-#define MTK_SGMII		BIT(MTK_SGMII_BIT)
-#define MTK_ESW			BIT(MTK_ESW_BIT)
-#define MTK_GEPHY		BIT(MTK_GEPHY_BIT)
-#define MTK_MUX			BIT(MTK_MUX_BIT)
-#define MTK_INFRA		BIT(MTK_INFRA_BIT)
-#define MTK_SHARED_SGMII	BIT(MTK_SHARED_SGMII_BIT)
-#define MTK_HWLRO		BIT(MTK_HWLRO_BIT)
-#define MTK_SHARED_INT		BIT(MTK_SHARED_INT_BIT)
-#define MTK_TRGMII_MT7621_CLK	BIT(MTK_TRGMII_MT7621_CLK_BIT)
-#define MTK_QDMA		BIT(MTK_QDMA_BIT)
-#define MTK_NETSYS_V1		BIT(MTK_NETSYS_V1_BIT)
-#define MTK_NETSYS_V2		BIT(MTK_NETSYS_V2_BIT)
-#define MTK_NETSYS_V3		BIT(MTK_NETSYS_V3_BIT)
-#define MTK_SOC_MT7628		BIT(MTK_SOC_MT7628_BIT)
-#define MTK_RSTCTRL_PPE1	BIT(MTK_RSTCTRL_PPE1_BIT)
-#define MTK_U3_COPHY_V2		BIT(MTK_U3_COPHY_V2_BIT)
+#define MTK_RGMII		BIT_ULL(MTK_RGMII_BIT)
+#define MTK_TRGMII		BIT_ULL(MTK_TRGMII_BIT)
+#define MTK_SGMII		BIT_ULL(MTK_SGMII_BIT)
+#define MTK_ESW			BIT_ULL(MTK_ESW_BIT)
+#define MTK_GEPHY		BIT_ULL(MTK_GEPHY_BIT)
+#define MTK_MUX			BIT_ULL(MTK_MUX_BIT)
+#define MTK_INFRA		BIT_ULL(MTK_INFRA_BIT)
+#define MTK_SHARED_SGMII	BIT_ULL(MTK_SHARED_SGMII_BIT)
+#define MTK_HWLRO		BIT_ULL(MTK_HWLRO_BIT)
+#define MTK_SHARED_INT		BIT_ULL(MTK_SHARED_INT_BIT)
+#define MTK_TRGMII_MT7621_CLK	BIT_ULL(MTK_TRGMII_MT7621_CLK_BIT)
+#define MTK_QDMA		BIT_ULL(MTK_QDMA_BIT)
+#define MTK_NETSYS_V1		BIT_ULL(MTK_NETSYS_V1_BIT)
+#define MTK_NETSYS_V2		BIT_ULL(MTK_NETSYS_V2_BIT)
+#define MTK_NETSYS_V3		BIT_ULL(MTK_NETSYS_V3_BIT)
+#define MTK_SOC_MT7628		BIT_ULL(MTK_SOC_MT7628_BIT)
+#define MTK_RSTCTRL_PPE1	BIT_ULL(MTK_RSTCTRL_PPE1_BIT)
+#define MTK_U3_COPHY_V2		BIT_ULL(MTK_U3_COPHY_V2_BIT)
 
 #define MTK_ETH_MUX_GDM1_TO_GMAC1_ESW		\
-	BIT(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT)
+	BIT_ULL(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT)
 #define MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY	\
-	BIT(MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY_BIT)
+	BIT_ULL(MTK_ETH_MUX_GMAC2_GMAC0_TO_GEPHY_BIT)
 #define MTK_ETH_MUX_U3_GMAC2_TO_QPHY		\
-	BIT(MTK_ETH_MUX_U3_GMAC2_TO_QPHY_BIT)
+	BIT_ULL(MTK_ETH_MUX_U3_GMAC2_TO_QPHY_BIT)
 #define MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII	\
-	BIT(MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII_BIT)
+	BIT_ULL(MTK_ETH_MUX_GMAC1_GMAC2_TO_SGMII_RGMII_BIT)
 #define MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII	\
-	BIT(MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII_BIT)
+	BIT_ULL(MTK_ETH_MUX_GMAC12_TO_GEPHY_SGMII_BIT)
 
 /* Supported path present on SoCs */
-#define MTK_ETH_PATH_GMAC1_RGMII	BIT(MTK_ETH_PATH_GMAC1_RGMII_BIT)
-#define MTK_ETH_PATH_GMAC1_TRGMII	BIT(MTK_ETH_PATH_GMAC1_TRGMII_BIT)
-#define MTK_ETH_PATH_GMAC1_SGMII	BIT(MTK_ETH_PATH_GMAC1_SGMII_BIT)
-#define MTK_ETH_PATH_GMAC2_RGMII	BIT(MTK_ETH_PATH_GMAC2_RGMII_BIT)
-#define MTK_ETH_PATH_GMAC2_SGMII	BIT(MTK_ETH_PATH_GMAC2_SGMII_BIT)
-#define MTK_ETH_PATH_GMAC2_GEPHY	BIT(MTK_ETH_PATH_GMAC2_GEPHY_BIT)
-#define MTK_ETH_PATH_GDM1_ESW		BIT(MTK_ETH_PATH_GDM1_ESW_BIT)
+#define MTK_ETH_PATH_GMAC1_RGMII	BIT_ULL(MTK_ETH_PATH_GMAC1_RGMII_BIT)
+#define MTK_ETH_PATH_GMAC1_TRGMII	BIT_ULL(MTK_ETH_PATH_GMAC1_TRGMII_BIT)
+#define MTK_ETH_PATH_GMAC1_SGMII	BIT_ULL(MTK_ETH_PATH_GMAC1_SGMII_BIT)
+#define MTK_ETH_PATH_GMAC2_RGMII	BIT_ULL(MTK_ETH_PATH_GMAC2_RGMII_BIT)
+#define MTK_ETH_PATH_GMAC2_SGMII	BIT_ULL(MTK_ETH_PATH_GMAC2_SGMII_BIT)
+#define MTK_ETH_PATH_GMAC2_GEPHY	BIT_ULL(MTK_ETH_PATH_GMAC2_GEPHY_BIT)
+#define MTK_ETH_PATH_GDM1_ESW		BIT_ULL(MTK_ETH_PATH_GDM1_ESW_BIT)
 
 #define MTK_GMAC1_RGMII		(MTK_ETH_PATH_GMAC1_RGMII | MTK_RGMII)
 #define MTK_GMAC1_TRGMII	(MTK_ETH_PATH_GMAC1_TRGMII | MTK_TRGMII)
@@ -1062,7 +1062,7 @@ struct mtk_reg_map {
 struct mtk_soc_data {
 	const struct mtk_reg_map *reg_map;
 	u32             ana_rgc3;
-	u32		caps;
+	u64		caps;
 	u32		required_clks;
 	bool		required_pctl;
 	u8		offload_version;
-- 
2.41.0


