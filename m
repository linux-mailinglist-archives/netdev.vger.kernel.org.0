Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762CE3DAC85
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhG2ULr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbhG2ULq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 16:11:46 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8E4C061765;
        Thu, 29 Jul 2021 13:11:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso17441196pjb.1;
        Thu, 29 Jul 2021 13:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W1DcINwqfJqO0dtPIz+bu4Dg7uAJTjlEluLn5n1AaFQ=;
        b=igb01awKOgcbEbBWdptZNnPS3aA2621O4Rz8/Uw3mYCgfIlIp/mFJXb+zFB57GL7vM
         WRqgSTr74HoTswSPtoQqs+Nz6JC6g3uUiw0q0sBYGP9lMztqCB05vl5FNYxyRavi8YM6
         IqidDVLUbNk2dIzYSj8wni04030cr+3fRwUanN1ikHAMCJnsyZf4AA3Qw7SF/rn+ovfj
         ZHmcm6omslE0MFq+2Kh4GFgj111d9vEnZ4JT9hLvrYVfLYIrSS9lkX6WE5c0TXZmqVsu
         mPRiKekh3FGxZvSZ3aOYbWVdIt2jH9tK/vPkr5/HpcAdBDeqJJ9/LtGajwxyaJjDhPRy
         KN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1DcINwqfJqO0dtPIz+bu4Dg7uAJTjlEluLn5n1AaFQ=;
        b=iWty0nZPMUfseJP5+hUluUtkvHCGloA9i+l5XBdU+lDVwSQywjatOwz6n7MqTTl9ic
         5wWh6iyu1e+CumfES6i4/kuE4hw8yAAE6RmqU968RI8d4fjz1v8aDatXSNrKfEjhPxzZ
         ClXpCufKGMZLdV4juhwuWJwgL4S49TC0jNTPvQxEXz+tLiAp2XBq03SbgzOjyP5klErr
         erT5SBp3i4mnktDdsHNMj4ThqD0mV1R69XRp4H/21rTd5JNqYgcbZxkJOzhLFc4sSiXY
         HSdrgO+tAT1BCymmzPZz34jQojyVBs8Apd8PzSvvmuY9ro/KarEANVexPuW4L1Vy0DHC
         Czsw==
X-Gm-Message-State: AOAM532y50uj/n9JLWMscoqUQx3+qQHSX+B8Z2jbQpsrcC0bJhfPepBq
        HlaZF6f9nwCDe+QGGEIMC3C9oKqKW3z+yw==
X-Google-Smtp-Source: ABdhPJwGKpnTbv+C5Cd9r3idwiLy7WXCCr7A9uP9HatThZRm4SpBVI1ma+PGoaVlCJygldBP6r8vLA==
X-Received: by 2002:a63:1359:: with SMTP id 25mr5265930pgt.79.1627589501459;
        Thu, 29 Jul 2021 13:11:41 -0700 (PDT)
Received: from archl-on1.. ([103.51.72.31])
        by smtp.gmail.com with ESMTPSA id i25sm4581407pfo.20.2021.07.29.13.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 13:11:41 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org
Cc:     Anand Moon <linux.amoon@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Subject: [PATCHv1 2/3] ARM: dts: meson: Use new reset id for reset controller
Date:   Fri, 30 Jul 2021 01:40:51 +0530
Message-Id: <20210729201100.3994-3-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729201100.3994-1-linux.amoon@gmail.com>
References: <20210729201100.3994-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used new reset id for reset controller as it conflict
with the core reset id.

Fixes: b96446541d83 ("ARM: dts: meson8b: extend ethernet controller description")

Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 arch/arm/boot/dts/meson8b.dtsi  | 2 +-
 arch/arm/boot/dts/meson8m2.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b.dtsi b/arch/arm/boot/dts/meson8b.dtsi
index c02b03cbcdf4..cb3a579d09ef 100644
--- a/arch/arm/boot/dts/meson8b.dtsi
+++ b/arch/arm/boot/dts/meson8b.dtsi
@@ -511,7 +511,7 @@ &ethmac {
 	tx-fifo-depth = <2048>;
 
 	resets = <&reset RESET_ETHERNET>;
-	reset-names = "stmmaceth";
+	reset-names = "ethreset";
 
 	power-domains = <&pwrc PWRC_MESON8_ETHERNET_MEM_ID>;
 };
diff --git a/arch/arm/boot/dts/meson8m2.dtsi b/arch/arm/boot/dts/meson8m2.dtsi
index 6725dd9fd825..cfaf60c4ba5f 100644
--- a/arch/arm/boot/dts/meson8m2.dtsi
+++ b/arch/arm/boot/dts/meson8m2.dtsi
@@ -34,7 +34,7 @@ &ethmac {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "stmmaceth", "clkin0", "clkin1", "timing-adjustment";
 	resets = <&reset RESET_ETHERNET>;
-	reset-names = "stmmaceth";
+	reset-names = "ethreset";
 };
 
 &pinctrl_aobus {
-- 
2.32.0

