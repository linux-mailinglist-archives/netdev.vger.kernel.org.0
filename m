Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F4D2E8BE0
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbhACLSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:18:35 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:48299 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbhACLSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:18:34 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 70660548;
        Sun,  3 Jan 2021 06:17:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=J5Cq+Ae4IPa+R
        9jD99wSE69PUYZG8kpNxitzJfWW+B0=; b=PhbZctLps1kZBBbDdz5hYMa1IVRkt
        AVFIW2QokrvxIMeuWiZ6McJKN72VOndxLHsUaDTic+auyrhWAaSCgDRFk8+aQBWa
        7ZG18QFr12SVLjMYszVX5HQVYH1syexUIEhS/9gOn0BN7l4ltjzQSNTDUXOv/BPj
        S829E0WrK/YnoNTyyuUqnVMM64YiRntnZFD4wdWFg25bvTb7Zi43vLu3Phhh3CD5
        KHdIIdHo1dFHVvvwOPv5k7zLrEc0Zh6olpXFUSLwqtmTEVEAz+Uf6DJMiwyVGIRd
        CU/OHKKlqP5HqG7IUyYlsouGU/PGskAoSvXowRML385z0CCQUlVLA9odg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=J5Cq+Ae4IPa+R9jD99wSE69PUYZG8kpNxitzJfWW+B0=; b=ZmLtaDcI
        pkFbM+OiRbDP+yltkdEg13hAWg0eM9pdHEFXcNcDYLNY9Wt4uFxjZ1UzB0P5IFkC
        7NrhYE9IJ4FBfz/72k1kdlg3UIGzeKRe23ZpmtTG9idy6dGREHp80DaJJC8+LIGY
        +nUWkwlJ4xH96/rWBVAFt6uQgAkm0b9mOM507+bo+UCCwc5ww6mRVFeZy2aisnn8
        fdi/2xr4BwmhFFm+MrGXX3Yqfy3H0F/CMFhu6d+XAmlU1HBLcsOrYC9hC05WIl17
        oAFaQerIAuAYtM953DNvweyfEM08no5rOxHcatXXxLoZ5FCw2YznUAKG0OGx0urg
        TUSvFBnG8papmQ==
X-ME-Sender: <xms:2qfxX0ooAaW4Fn8uH1cIkTsVGvsI2Nw5r4Z0e-Y4YwomYKEkcKA5jg>
    <xme:2qfxX6q_3uOqcQY8P8u5vWZ56nqxqZD7iGY3RE7DrdHGy96LiQ9G6PGIzwG6D5BUI
    2lrvwIBblFX1BnBVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgepudenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:2qfxX5OvIjoGr4oka4wWbqukpsfSPxOXxi5b4tLK8gz59Lrbut8igQ>
    <xmx:2qfxX74_6oT1sOGspNh7_LhBnMGKkN1xtTuzMEpW6fFHs7Pbe3C74w>
    <xmx:2qfxXz6cbdDhvUMqAM2STIdUDvGvu8mw5Xtdyud-njppeOaHgElnBw>
    <xmx:2qfxX7yB2ngbHiJF1opWqyO1zMRM-ZMX1uqi_0L1xOJIyEnk1yyR6U9AiOE>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF6781080059;
        Sun,  3 Jan 2021 06:17:45 -0500 (EST)
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
Subject: [PATCH net 2/4] net: stmmac: dwmac-sun8i: Balance internal PHY resource references
Date:   Sun,  3 Jan 2021 05:17:42 -0600
Message-Id: <20210103111744.34989-3-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103111744.34989-1-samuel@sholland.org>
References: <20210103111744.34989-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While stmmac_pltfr_remove calls sun8i_dwmac_exit, the sun8i_dwmac_init
and sun8i_dwmac_exit functions are also called by the stmmac_platform
suspend/resume callbacks. They may be called many times during the
device's lifetime and should not release resources used by the driver.

Furthermore, there was no error handling in case registering the MDIO
mux failed during probe, and the EPHY clock was never released at all.

Fix all of these issues by moving the deinitialization code to a driver
removal callback. Also ensure the EPHY is powered down before removal.

Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 27 ++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index b20f261fce5b..a05dee5d4584 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1004,17 +1004,12 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 	struct sunxi_priv_data *gmac = priv;
 
 	if (gmac->variant->soc_has_internal_phy) {
-		/* sun8i_dwmac_exit could be called with mdiomux uninit */
-		if (gmac->mux_handle)
-			mdio_mux_uninit(gmac->mux_handle);
 		if (gmac->internal_phy_powered)
 			sun8i_dwmac_unpower_internal_phy(gmac);
 	}
 
 	sun8i_dwmac_unset_syscon(gmac);
 
-	reset_control_put(gmac->rst_ephy);
-
 	clk_disable_unprepare(gmac->tx_clk);
 
 	if (gmac->regulator)
@@ -1244,6 +1239,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 
 	return ret;
 dwmac_mux:
+	reset_control_put(gmac->rst_ephy);
+	clk_put(gmac->ephy_clk);
 	sun8i_dwmac_unset_syscon(gmac);
 dwmac_remove:
 	stmmac_dvr_remove(&pdev->dev);
@@ -1255,6 +1252,24 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int sun8i_dwmac_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct sunxi_priv_data *gmac = priv->plat->bsp_priv;
+
+	if (gmac->variant->soc_has_internal_phy) {
+		mdio_mux_uninit(gmac->mux_handle);
+		sun8i_dwmac_unpower_internal_phy(gmac);
+		reset_control_put(gmac->rst_ephy);
+		clk_put(gmac->ephy_clk);
+	}
+
+	stmmac_pltfr_remove(pdev);
+
+	return 0;
+}
+
 static const struct of_device_id sun8i_dwmac_match[] = {
 	{ .compatible = "allwinner,sun8i-h3-emac",
 		.data = &emac_variant_h3 },
@@ -1274,7 +1289,7 @@ MODULE_DEVICE_TABLE(of, sun8i_dwmac_match);
 
 static struct platform_driver sun8i_dwmac_driver = {
 	.probe  = sun8i_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
+	.remove = sun8i_dwmac_remove,
 	.driver = {
 		.name           = "dwmac-sun8i",
 		.pm		= &stmmac_pltfr_pm_ops,
-- 
2.26.2

