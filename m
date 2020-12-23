Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80D42E22C2
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgLWXbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgLWXbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 18:31:23 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66614C061282;
        Wed, 23 Dec 2020 15:30:42 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id q75so272794wme.2;
        Wed, 23 Dec 2020 15:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M0ndzokyweROc+1+J72pYZnLkVJUHj/9rLRl9lmhXAM=;
        b=aVjgPZg44fBmUtM/n1tXl5BjwycXTr85OlZeWOeTYBjSrDuPfOjDaMiBSlW22IkGL2
         RRJuNLufji3FLz6vpOSzmbFiVepP3ZndqPgPRDtwKrJ8nurJXhEOJ2KNQ10VNA0f89x7
         5t6xcdFK9sf0vI/FTYoYAI81SkwMX6adJT2MzW/wmDqf1E7uEGtM6MazTJOq5s4p8KHq
         FfKptQRd4vClm39VPV2i0XvsxFOKJjuYardGH+TXp77QGoVOpPAnHkFpD6vrWiVxFciM
         cde/TAuQKxfWpJzdlWuZYSbEMPr/OThJVuPS65g586zg5Tx7+5AU3agH2vDUpG/3RZAE
         uAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M0ndzokyweROc+1+J72pYZnLkVJUHj/9rLRl9lmhXAM=;
        b=f7ESeflQMAFacHuL52y4ORaP9L049FGmN8erRQF1iAwG9qWtPSarqUSKm4C0jLat0+
         O/PEeA4Q6ZGO4siz/gtQmXiRKS6vc70084SJ1MgzOojMsb9PWkv8tblNACc/HNVkdVtc
         +Zc4hN9dFrA58WcutGcDYhg6R3Anf49uUX7hR0lNPxRnCjlYPDn3YsAYjtocbiDYWVry
         e3EIrIeThj+A2Kj9cIt+L9a7tRlFJwOH5TRy88lLu2P9lubLqyyZhnj7q6kQDu0XW28O
         EJCBs1WjYixsOfOOp/ajhpj1bOxde3gUot51GAgmjMpmhEYZPJZT6KXvWR0L3Ptr+IxQ
         grNQ==
X-Gm-Message-State: AOAM533est0T9KKwwL3CvXEmiXghKzFP1E8kZft/rffzTnVYFFRnzZqW
        tbyWaVAco2NfTQJu8Uo/POEJoSZQA5A=
X-Google-Smtp-Source: ABdhPJw80ydPE2q0jtj/nk7tg5lGhT3vPnadHtbZP5NDS3hsaBkJ0NAJ7DCwCWGiXCIAlpNHXDOWSQ==
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr1760579wml.155.1608766240943;
        Wed, 23 Dec 2020 15:30:40 -0800 (PST)
Received: from localhost.localdomain (p200300f1371a0900428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371a:900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id l16sm37926657wrx.5.2020.12.23.15.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 15:30:40 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 3/5] net: stmmac: dwmac-meson8b: use picoseconds for the RGMII RX delay
Date:   Thu, 24 Dec 2020 00:29:03 +0100
Message-Id: <20201223232905.2958651-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
References: <20201223232905.2958651-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
delay register which allows picoseconds precision. Parse the new
"rx-internal-delay-ps" property or fall back to the value from the old
"amlogic,rx-delay-ns" property.

No upstream DTB uses the old "amlogic,rx-delay-ns" property (yet).
Only include minimalistic logic to fall back to the old property,
without any special validation (for example if the old and new
property are given at the same time).

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 5f500141567d..d2be3a7bd8fd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -82,7 +82,7 @@ struct meson8b_dwmac {
 	phy_interface_t			phy_mode;
 	struct clk			*rgmii_tx_clk;
 	u32				tx_delay_ns;
-	u32				rx_delay_ns;
+	u32				rx_delay_ps;
 	struct clk			*timing_adj_clk;
 };
 
@@ -276,7 +276,7 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 	tx_dly_config = FIELD_PREP(PRG_ETH0_TXDLY_MASK,
 				   dwmac->tx_delay_ns >> 1);
 
-	if (dwmac->rx_delay_ns == 2)
+	if (dwmac->rx_delay_ps == 2000)
 		rx_dly_config = PRG_ETH0_ADJ_ENABLE | PRG_ETH0_ADJ_SETUP;
 	else
 		rx_dly_config = 0;
@@ -406,14 +406,19 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 				 &dwmac->tx_delay_ns))
 		dwmac->tx_delay_ns = 2;
 
-	/* use 0ns as fallback since this is what most boards actually use */
-	if (of_property_read_u32(pdev->dev.of_node, "amlogic,rx-delay-ns",
-				 &dwmac->rx_delay_ns))
-		dwmac->rx_delay_ns = 0;
+	/* RX delay defaults to 0ps since this is what many boards use */
+	if (of_property_read_u32(pdev->dev.of_node, "rx-internal-delay-ps",
+				 &dwmac->rx_delay_ps)) {
+		if (!of_property_read_u32(pdev->dev.of_node,
+					  "amlogic,rx-delay-ns",
+					  &dwmac->rx_delay_ps))
+			/* convert ns to ps */
+			dwmac->rx_delay_ps *= 1000;
+	}
 
-	if (dwmac->rx_delay_ns != 0 && dwmac->rx_delay_ns != 2) {
+	if (dwmac->rx_delay_ps != 0 && dwmac->rx_delay_ps != 2000) {
 		dev_err(&pdev->dev,
-			"The only allowed RX delays values are: 0ns, 2ns");
+			"The only allowed RX delays values are: 0ps, 2000ps");
 		ret = -EINVAL;
 		goto err_remove_config_dt;
 	}
-- 
2.29.2

