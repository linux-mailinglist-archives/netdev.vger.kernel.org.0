Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C3A51F641
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiEIH6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbiEIHxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:53:02 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B49F13DD13
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:49:09 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id bg25so7860449wmb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VgEKyO0L0uA3SGFAWkGQhNMbC7clsq3EFnRg59TyA70=;
        b=bBiGh/AhGl38/MpaSnWoH0kWx8noJq58musIpZ/g2oeqIKpuW2Su1Y4ZgNGVc2+Dz6
         eXZiC83MRh77Kw3wvrYE2FR9xnbKOu9zRJEiqGkQIGyxLFuKlF9LDz5gXlubAdjw1rDy
         WwH53vZ1MkSY48ocvhfyQEHnOx3fjcof2u4WLTKJmBcsRR3KDpvkUKuhW7s9VWTNwXfv
         RveFcmrPMlo9oDIBI6fj7bhQ8q8DTI/LJBkvk9rJAWZ6ecAiiJWhEHZfOE9jTwbD8Mde
         Lah4Ki9hI1OHi/rRtcH5nwvxEwepu0M84Wkgdz7Ei73qHvAm68iq93wkbgAhbBr5uQ4V
         9BVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VgEKyO0L0uA3SGFAWkGQhNMbC7clsq3EFnRg59TyA70=;
        b=0vB+xTtaoij/9vCcl3p8orXA8gxdEo3p1aewWZENkJEXCTXS5LiN0ftfuCE3aaVh3p
         bHJSZuuNQUSulNLdDCIHa6jB5mR33ADgsS8PaWWQIPkAOYdTXEfBhshHauUKDsy+PoYC
         fOy34WeiXdgzoeYVk+MBBrMaKOf/JnMRQ4nzyhShUBair/xIBx36KelP89GRShaH5ohy
         C2uC+T9GbABecWiSi+1noqPWVakyzBAhrGIz1/tamXhCuDg4fkforh2UPkvV6WoykPvN
         m87yVZDQ5jXeMISmp+6E1FuzrUrxeHrD6b7HvdwdDGJ11/8aZ8pFgHaib0BKLJ0co+7O
         PJ3A==
X-Gm-Message-State: AOAM53397ZablwPPwS6cDiKHcCOBF9+ckPRbeMgtIPYbLhTAanPyHoV2
        +XTo43ES/RyfaWN+KhbIyNoFug==
X-Google-Smtp-Source: ABdhPJwiYLJm2AFKSikbo89a1SKZiOmfCAFxQ5X7TJwAoWGnUQJ66VAG9OF9Sr3O4w9WN8Znulrgyg==
X-Received: by 2002:a7b:c202:0:b0:394:1e7d:af44 with SMTP id x2-20020a7bc202000000b003941e7daf44mr14700879wmi.139.1652082547691;
        Mon, 09 May 2022 00:49:07 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id bw22-20020a0560001f9600b0020c5253d8d8sm11784768wrb.36.2022.05.09.00.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 00:49:07 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     alexandre.torgue@foss.st.com, andrew@lunn.ch, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/6] net: stmmac: dwmac-sun8i: remove regulator
Date:   Mon,  9 May 2022 07:48:53 +0000
Message-Id: <20220509074857.195302-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509074857.195302-1-clabbe@baylibre.com>
References: <20220509074857.195302-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now regulator is handled by phy core, there is no need to handle it in
stmmac driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 37 +------------------
 1 file changed, 2 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index f834472599f7..17888813c707 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -17,7 +17,6 @@
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/regulator/consumer.h>
 #include <linux/regmap.h>
 #include <linux/stmmac.h>
 
@@ -59,7 +58,6 @@ struct emac_variant {
 
 /* struct sunxi_priv_data - hold all sunxi private data
  * @ephy_clk:	reference to the optional EPHY clock for the internal PHY
- * @regulator:	reference to the optional regulator
  * @rst_ephy:	reference to the optional EPHY reset for the internal PHY
  * @variant:	reference to the current board variant
  * @regmap:	regmap for using the syscon
@@ -69,7 +67,6 @@ struct emac_variant {
  */
 struct sunxi_priv_data {
 	struct clk *ephy_clk;
-	struct regulator *regulator;
 	struct reset_control *rst_ephy;
 	const struct emac_variant *variant;
 	struct regmap_field *regmap_field;
@@ -568,29 +565,11 @@ static int sun8i_dwmac_init(struct platform_device *pdev, void *priv)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct sunxi_priv_data *gmac = priv;
-	int ret;
 
-	if (gmac->regulator) {
-		ret = regulator_enable(gmac->regulator);
-		if (ret) {
-			dev_err(&pdev->dev, "Fail to enable regulator\n");
-			return ret;
-		}
-	}
-
-	if (gmac->use_internal_phy) {
-		ret = sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
-		if (ret)
-			goto err_disable_regulator;
-	}
+	if (gmac->use_internal_phy)
+		return sun8i_dwmac_power_internal_phy(netdev_priv(ndev));
 
 	return 0;
-
-err_disable_regulator:
-	if (gmac->regulator)
-		regulator_disable(gmac->regulator);
-
-	return ret;
 }
 
 static void sun8i_dwmac_core_init(struct mac_device_info *hw,
@@ -1034,9 +1013,6 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 
 	if (gmac->variant->soc_has_internal_phy)
 		sun8i_dwmac_unpower_internal_phy(gmac);
-
-	if (gmac->regulator)
-		regulator_disable(gmac->regulator);
 }
 
 static void sun8i_dwmac_set_mac_loopback(void __iomem *ioaddr, bool enable)
@@ -1157,15 +1133,6 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/* Optional regulator for PHY */
-	gmac->regulator = devm_regulator_get_optional(dev, "phy");
-	if (IS_ERR(gmac->regulator)) {
-		if (PTR_ERR(gmac->regulator) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		dev_info(dev, "No regulator found\n");
-		gmac->regulator = NULL;
-	}
-
 	/* The "GMAC clock control" register might be located in the
 	 * CCU address range (on the R40), or the system control address
 	 * range (on most other sun8i and later SoCs).
-- 
2.35.1

