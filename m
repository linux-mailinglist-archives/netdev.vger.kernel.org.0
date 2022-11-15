Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EACD62928A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiKOHgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiKOHgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:36:18 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CD715FF8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:36:15 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id t1so9069349wmi.4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CSDVCUIFMlfZ7nF9KUJuPkMn+99GuqCPirWDXaDIqPw=;
        b=lOwSFJwIzEoH9+BBlsV8ydJ8KFWxhnO/GNq6VadaMp8sZTEOlX4BPNGNaeJnzIi/Xt
         Hfh19SvvnzbwgS5c3uyGDzfyDi8OWtaOmeqs+zLuz2h7IW1isXGZ98sMl+Q0yMTeJK+w
         pMdu5rlXLrAAgP4iMPPPheHaN1JToL4kfYHgIhb+IQKUW5mVYoRgI9ZxU8h68z4QQDTT
         /8QHLCsHmJhvP5JTTxUbteVbS6fdRWB15waJ0AT7O9Od9p5GUjceBEFzM3UXdkR2uh8S
         qNXWaF+Lop2CJA8VmNfJviN4sIcaLNVoTm4BljVNj2E6yiORQRjnSm2kLQYGY92g9pzh
         vp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CSDVCUIFMlfZ7nF9KUJuPkMn+99GuqCPirWDXaDIqPw=;
        b=rMMaYXxleg+wYFok6FafsrUAGTOpYDPNy1wSQ6LRGmLfbLlwWpAP65R6Wh5YNMhPZ6
         ngUCV1s6GBu/2j6Zx+0hOrFBNzz2XN5SqQTqv3/Sd58APBRccMzm11t/JmsE+Yb7JXBw
         NNepVGPKu0a3kwPTvIktKC4NTbJqK/A+kveoA9rHIBwF3NKtMe9qBf7pkOmkluIpWH0F
         9HDhne5VR5NBplh2rOc6lJlYGtt9QmmripJRcRVag69tiNXYNLxFDEUdHk8MiVgRjRzS
         njOTIlg3+vgT4a4IilMcrWjNVewRHvRO9bU628tLoxWVkzRB6MSIzCXewJWBNaciAuaa
         nv6Q==
X-Gm-Message-State: ANoB5pmHP8lqhxFPalAtynPyD1JXejQ/JOeXOA1GNyB4AUZwt7U7rYTy
        2RUMZlsFw2RjEclYMUeh9cKoPQ==
X-Google-Smtp-Source: AA0mqf5/iPOpLCFEROZe7VK4xD8+ELw0YH0zY4IuN7pcxcBQWYaCiKyhhLH4kU9hJBpYwKCM40mpPw==
X-Received: by 2002:a1c:720f:0:b0:3cf:6f77:375 with SMTP id n15-20020a1c720f000000b003cf6f770375mr20265wmc.102.1668497775128;
        Mon, 14 Nov 2022 23:36:15 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j13-20020a5d452d000000b0022cbf4cda62sm13836811wra.27.2022.11.14.23.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 23:36:14 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megi@xff.cz>,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 3/3] arm64: dts: allwinner: orange-pi-3: Enable ethernet
Date:   Tue, 15 Nov 2022 07:36:03 +0000
Message-Id: <20221115073603.3425396-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115073603.3425396-1-clabbe@baylibre.com>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondřej Jirman <megi@xff.cz>

Orange Pi 3 has two regulators that power the Realtek RTL8211E
PHY. According to the datasheet, both regulators need to be enabled
at the same time, or that "phy-io" should be enabled slightly earlier
than "phy" regulator.

RTL8211E/RTL8211EG datasheet says:

  Note 4: 2.5V (or 1.8/1.5V) RGMII power should be risen simultaneously
  or slightly earlier than 3.3V power. Rising 2.5V (or 1.8/1.5V) power
  later than 3.3V power may lead to errors.

The timing is set in DT via startup-delay-us.

Signed-off-by: Ondrej Jirman <megi@xff.cz>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
index 6fc65e8db220..081b004f26ea 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-orangepi-3.dts
@@ -13,6 +13,7 @@ / {
 	compatible = "xunlong,orangepi-3", "allwinner,sun50i-h6";
 
 	aliases {
+		ethernet0 = &emac;
 		serial0 = &uart0;
 		serial1 = &uart1;
 	};
@@ -55,6 +56,15 @@ led-1 {
 		};
 	};
 
+	reg_gmac_2v5: gmac-2v5 {
+		compatible = "regulator-fixed";
+		regulator-name = "gmac-2v5";
+		regulator-min-microvolt = <2500000>;
+		regulator-max-microvolt = <2500000>;
+		enable-active-high;
+		gpio = <&pio 3 6 GPIO_ACTIVE_HIGH>; /* PD6 */
+	};
+
 	reg_vcc5v: vcc5v {
 		/* board wide 5V supply directly from the DC jack */
 		compatible = "regulator-fixed";
@@ -113,6 +123,33 @@ &ehci3 {
 	status = "okay";
 };
 
+&emac {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ext_rgmii_pins>;
+	phy-mode = "rgmii-id";
+	phy-handle = <&ext_rgmii_phy>;
+	status = "okay";
+};
+
+&mdio {
+	ext_rgmii_phy: ethernet-phy@1 {
+		compatible = "ethernet-phy-ieee802.3-c22";
+		reg = <1>;
+		/*
+		 * The board uses 2.5V RGMII signalling. Power sequence to enable
+		 * the phy is to enable GMAC-2V5 and GMAC-3V (aldo2) power rails
+		 * at the same time and to wait 100ms. The driver enables phy-io
+		 * first. Delay is achieved with enable-ramp-delay on reg_aldo2.
+		 */
+		phy-io-supply = <&reg_gmac_2v5>;
+		ephy-supply = <&reg_aldo2>;
+
+		reset-gpios = <&pio 3 14 GPIO_ACTIVE_LOW>; /* PD14 */
+		reset-assert-us = <15000>;
+		reset-deassert-us = <40000>;
+	};
+};
+
 &gpu {
 	mali-supply = <&reg_dcdcc>;
 	status = "okay";
@@ -211,6 +248,7 @@ reg_aldo2: aldo2 {
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-name = "vcc33-audio-tv-ephy-mac";
+				regulator-enable-ramp-delay = <100000>;
 			};
 
 			/* ALDO3 is shorted to CLDO1 */
-- 
2.37.4

