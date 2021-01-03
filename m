Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E39B2E8BE8
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbhACLTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:19:04 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:42219 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbhACLSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:18:54 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 7117B54A;
        Sun,  3 Jan 2021 06:17:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=bdo89WpaGjdZx
        noBm8NQIjV1879V2USdLAoeh6WdO74=; b=Lzr03FtEKargN9JhgJJD1SqIR/D/g
        pG5Fdat1tTBKmzfwRhZy+6lkNS9gRZcY3kQk1IV8H+QFIPI+g7XDgZTsUj+dd/2t
        tOnLH1KKoPitR3VQ7XU56N5FKYMr9b+Y0sgv6EfydeQ0Lkx2QOMD1yK5zQbnpkC1
        tr6CrGV9HmgsOd1WDDDjypzpgVRMyTaxXTSH/uatWZ1hnXzR6nrC1JdGqxclZue1
        AALKRtMSwXQ9k0C6NRQ6cUd7y9xKpiD4GSC3gDpsD8ZQjLF5IedaR+ZY5eFZ1MYO
        5Zo6iPHb6DitJJYloYtoU+j9biYUKoNo76dFjOAFNQKF25UR8dsy+ugww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=bdo89WpaGjdZxnoBm8NQIjV1879V2USdLAoeh6WdO74=; b=PAIMfNK/
        EmA5qAYnvTx8dIuNOSIPgVPMEp1FfAq67PFCtbQ/SR/2gLieiRX0NWC42azt881m
        bLPHIhWz6kBK+03fZMoH72Oa631P9sPbB+fniYvwJ1Ph38DXa96iRzc1P3+KnQuH
        tHhPGjqw6ufivayoe4RZdkKZLZA0XQZf/qOc850TObf4+BcmEYMn/mzETGl6PaXN
        m0ceYUHo2TlCRjLDE7w5ibjN5dwZxa4USy4WUf3Dy0UYMVQdw3IEApjHWsIYmqUp
        MyoSPOgud6LftUJe9yvqfZKm2Gkcu2ZYnmxIda3TZ/P8fsxiYD2e1cgxc+4izied
        HCM30HwrolzWcg==
X-ME-Sender: <xms:2afxXwPJek-wCTgfaQuowy5JQp-6UOzLy6GoDxtX8uYjhYaeg1Tr_Q>
    <xme:2afxX29kmlhNkHb4PyQJU-bW_K-E18aJl9eoyk77KrNnkNKM8czoje_uqAHnAZRDL
    7VJUjQdFGvoGiauQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:2afxX3TVrD8mlavlPKeRjiKCwjwPsdxMjL7P1EAGOXVtEnSi6Xr5Xw>
    <xmx:2afxX4uGMAg2dREZAwqWjaKIxO0rW4CIjFjsI_ebIKcdKz24JFNxPw>
    <xmx:2afxX4fv8ePB4g4rpyDLQ1_VGJBSfPPCM3wmerJ5-JPfX_vXF4UVOg>
    <xmx:2qfxX-0ivLHwCfX9SvcYNNPB07XoPtHx_kTo0N_xPfX5b62lG8-wENWpg2c>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 42963108005F;
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
Subject: [PATCH net 1/4] net: stmmac: dwmac-sun8i: Fix probe error handling
Date:   Sun,  3 Jan 2021 05:17:41 -0600
Message-Id: <20210103111744.34989-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103111744.34989-1-samuel@sholland.org>
References: <20210103111744.34989-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_pltfr_remove does three things in one function, making it
inapproprate for unwinding the steps in the probe function. Currently,
a failure before the call to stmmac_dvr_probe would leak OF node
references due to missing a call to stmmac_remove_config_dt. And an
error in stmmac_dvr_probe would cause the driver to attempt to remove a
netdevice that was never added. Fix these by reordering the init and
splitting out the error handling steps.

Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
Fixes: 40a1dcee2d18 ("net: ethernet: dwmac-sun8i: Use the correct function in exit path")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 58e0511badba..b20f261fce5b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1134,10 +1134,6 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
-	if (IS_ERR(plat_dat))
-		return PTR_ERR(plat_dat);
-
 	gmac = devm_kzalloc(dev, sizeof(*gmac), GFP_KERNEL);
 	if (!gmac)
 		return -ENOMEM;
@@ -1201,11 +1197,15 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	ret = of_get_phy_mode(dev->of_node, &interface);
 	if (ret)
 		return -EINVAL;
-	plat_dat->interface = interface;
+
+	plat_dat = stmmac_probe_config_dt(pdev, &stmmac_res.mac);
+	if (IS_ERR(plat_dat))
+		return PTR_ERR(plat_dat);
 
 	/* platform data specifying hardware features and callbacks.
 	 * hardware features were copied from Allwinner drivers.
 	 */
+	plat_dat->interface = interface;
 	plat_dat->rx_coe = STMMAC_RX_COE_TYPE2;
 	plat_dat->tx_coe = 1;
 	plat_dat->has_sun8i = true;
@@ -1216,7 +1216,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 
 	ret = sun8i_dwmac_init(pdev, plat_dat->bsp_priv);
 	if (ret)
-		return ret;
+		goto dwmac_deconfig;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
@@ -1230,7 +1230,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	if (gmac->variant->soc_has_internal_phy) {
 		ret = get_ephy_nodes(priv);
 		if (ret)
-			goto dwmac_exit;
+			goto dwmac_remove;
 		ret = sun8i_dwmac_register_mdio_mux(priv);
 		if (ret) {
 			dev_err(&pdev->dev, "Failed to register mux\n");
@@ -1239,15 +1239,20 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	} else {
 		ret = sun8i_dwmac_reset(priv);
 		if (ret)
-			goto dwmac_exit;
+			goto dwmac_remove;
 	}
 
 	return ret;
 dwmac_mux:
 	sun8i_dwmac_unset_syscon(gmac);
+dwmac_remove:
+	stmmac_dvr_remove(&pdev->dev);
 dwmac_exit:
-	stmmac_pltfr_remove(pdev);
-return ret;
+	sun8i_dwmac_exit(pdev, gmac);
+dwmac_deconfig:
+	stmmac_remove_config_dt(pdev, plat_dat);
+
+	return ret;
 }
 
 static const struct of_device_id sun8i_dwmac_match[] = {
-- 
2.26.2

