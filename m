Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04C62E8BE5
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbhACLSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:18:51 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:42775 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbhACLSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:18:34 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 8B72C54C;
        Sun,  3 Jan 2021 06:17:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=ibJPRastM2tZF
        l4PHv5z3y6HPBJia8I5WAdzsVC1pIM=; b=Khru31dHo9to3XXdrz234ZUcdoa6W
        gDgZp8c37DMqNCV3j0IEhNaKLzFrNsHfBMaTxwI2MUH3SkLNiD5Zwf0mtP+DgtCo
        dkxaenozszjXWMPfql3ISVRUxkyRDbMRR5t3S/P9e9Xx+EDFr3CpsZCWJgsWW6AS
        +kw5ZFbM1D9xgM4PVzVgrHcNxyvMnykbJjwOU3F45KSc7GM2Y5uhG6MnfOTHL84Y
        O9rMw5mqDm5PiP1zsaMDuqYhcvUPQs3d2B7TwALPOWQTdY5OlWYNS/gToWXWm8Jf
        QhzpUwl5G4gjKdv1UIW3KfRtBE5T7NWVaq+Nul0PJ7rq+nE6GSCnG58mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ibJPRastM2tZFl4PHv5z3y6HPBJia8I5WAdzsVC1pIM=; b=a96UhqkK
        68WO64AcmtI932sQXO5JrtkdyVlP6IHfpaG0O5AcjxkYT3QbtRsuiQp1ApcrFF0p
        ZOne0bEDFPLXUeo17La83H04oxqEWyFSHf5gPwplszM1x0TIFNEdzs/mICW8NT/J
        s4CCQxPAjKhgULt/4PsfMJleOV13PjY6Rn5XPMwVnSUJUrgMm+cwFTj0i7pPq9MJ
        a2GoRQqL9c0tVJRwomg1KqxYyogZhnrMkV+8ddfr1fHitJe5xt7Ik78Nfh1vJ0Av
        ZySHOKAhD6N2IcQ9Gkqka3mPr9q2msyrPWG5aYw0y76fJiH0685dyFy9iaMRAf4R
        x5oZGvlRaThldg==
X-ME-Sender: <xms:2qfxX_eCGmxc9eqe7vII1LPm-c5Rx6McC3gSQQjHAXNE0wTiMNOn5A>
    <xme:2qfxX1PJnQ4zDJIxBKWhmlYT4EPXWAlJQKin7yVW_zhJTzLVasHP77UR-Hia7F0uH
    l3eNAhMwlcEt99UoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgepudenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:26fxX4ii84Xi1_8ncJXIFGjXEXv3OxjZ1PEJY6aH9ljQP7dAxkyV0g>
    <xmx:26fxXw_QBffSZ5aoC7wtskmpRQSkKi_aRHPdF9xC_oBAGzWoJypDSg>
    <xmx:26fxX7vUfnKzreWqB0D5GGoQZhzx-BSW20yIKNa_F-t_gZouLAS62A>
    <xmx:26fxX0FqoedwLBn6tt95nJrjSl8FLx8cYoGQQIHP_DybKRlAdD2AxcPwbOA>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 68B0D1080063;
        Sun,  3 Jan 2021 06:17:46 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>
Subject: [PATCH net 3/4] net: stmmac: dwmac-sun8i: Balance internal PHY power
Date:   Sun,  3 Jan 2021 05:17:43 -0600
Message-Id: <20210103111744.34989-4-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103111744.34989-1-samuel@sholland.org>
References: <20210103111744.34989-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sun8i_dwmac_exit calls sun8i_dwmac_unpower_internal_phy, but
sun8i_dwmac_init did not call sun8i_dwmac_power_internal_phy. This
caused PHY power to remain off after a suspend/resume cycle. Fix this by
recording if PHY power should be restored, and if so, restoring it.

Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 31 ++++++++++++++-----
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index a05dee5d4584..e2c25c1c702a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -64,6 +64,7 @@ struct emac_variant {
  * @variant:	reference to the current board variant
  * @regmap:	regmap for using the syscon
  * @internal_phy_powered: Does the internal PHY is enabled
+ * @use_internal_phy: Is the internal PHY selected for use
  * @mux_handle:	Internal pointer used by mdio-mux lib
  */
 struct sunxi_priv_data {
@@ -74,6 +75,7 @@ struct sunxi_priv_data {
 	const struct emac_variant *variant;
 	struct regmap_field *regmap_field;
 	bool internal_phy_powered;
+	bool use_internal_phy;
 	void *mux_handle;
 };
 
@@ -539,8 +541,11 @@ static const struct stmmac_dma_ops sun8i_dwmac_dma_ops = {
 	.dma_interrupt = sun8i_dwmac_dma_interrupt,
 };
 
+static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv);
+
 static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 {
+	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct sunxi_priv_data *gmac = priv;
 	int ret;
 
@@ -554,13 +559,25 @@ static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 
 	ret = clk_prepare_enable(gmac->tx_clk);
 	if (ret) {
-		if (gmac->regulator)
-			regulator_disable(gmac->regulator);
 		dev_err(&pdev->dev, "Could not enable AHB clock\n");
-		return ret;
+		goto err_disable_regulator;
+	}
+
+	if (gmac->use_internal_phy) {
+		ret = sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
+		if (ret)
+			goto err_disable_clk;
 	}
 
 	return 0;
+
+err_disable_clk:
+	clk_disable_unprepare(gmac->tx_clk);
+err_disable_regulator:
+	if (gmac->regulator)
+		regulator_disable(gmac->regulator);
+
+	return ret;
 }
 
 static void sun8i_dwmac_core_init(struct mac_device_info *hw,
@@ -831,7 +848,6 @@ static int mdio_mux_syscon_switch_fn(int current_child, int desired_child,
 	struct sunxi_priv_data *gmac = priv->plat->bsp_priv;
 	u32 reg, val;
 	int ret = 0;
-	bool need_power_ephy = false;
 
 	if (current_child ^ desired_child) {
 		regmap_field_read(gmac->regmap_field, &reg);
@@ -839,13 +855,12 @@ static int mdio_mux_syscon_switch_fn(int current_child, int desired_child,
 		case DWMAC_SUN8I_MDIO_MUX_INTERNAL_ID:
 			dev_info(priv->device, "Switch mux to internal PHY");
 			val = (reg & ~H3_EPHY_MUX_MASK) | H3_EPHY_SELECT;
-
-			need_power_ephy = true;
+			gmac->use_internal_phy = true;
 			break;
 		case DWMAC_SUN8I_MDIO_MUX_EXTERNAL_ID:
 			dev_info(priv->device, "Switch mux to external PHY");
 			val = (reg & ~H3_EPHY_MUX_MASK) | H3_EPHY_SHUTDOWN;
-			need_power_ephy = false;
+			gmac->use_internal_phy = false;
 			break;
 		default:
 			dev_err(priv->device, "Invalid child ID %x\n",
@@ -853,7 +868,7 @@ static int mdio_mux_syscon_switch_fn(int current_child, int desired_child,
 			return -EINVAL;
 		}
 		regmap_field_write(gmac->regmap_field, val);
-		if (need_power_ephy) {
+		if (gmac->use_internal_phy) {
 			ret = sun8i_dwmac_power_internal_phy(priv);
 			if (ret)
 				return ret;
-- 
2.26.2

