Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9C651F647
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbiEIH7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiEIHxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:53:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0240113C095
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:49:14 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id w4so18149300wrg.12
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q/wAy1TbeV5Udmm91pas07M2plXYLkR5RXGzDlfWEKs=;
        b=Mz1U3xqaHzLf32jHaFUq5wH5UT6+YXlAZPhIPFuRedkXRkRdOeYm6T5Sf4ZeCe5W/a
         XTqwpmUYrJcOkXvnkKoB7Ce/bTPuGRI8wkuPhY1W78BYk5dB/rmCRRoUUg015Qu92LLh
         VBHZ06pkjyW4KEjczSJQBSwtoXnVx3i8cX+bhdWV/f0Hat/8+DjZbIH1QJ02cqvrjh6E
         /DGL6om7h5LGaqo7+b4GZSo24Rt0Px0MC12dRvbog2yJPVjc8imq5h20UFv2z4zT5pdE
         fWhPA3VnJMfdV/dVtUvXJOW7rvYFb0GavCDb/7KrcDegzW8gOLRliFSBhFBBEoxvD/HM
         hvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/wAy1TbeV5Udmm91pas07M2plXYLkR5RXGzDlfWEKs=;
        b=lO67TIeG6zfMDTLVL3CGQnbofE7J6eCmLVb/YFEaX04JZHKsooT1745s6coM3eXMZl
         STBTBvd0lpsgPhpQ7TIi+MW+9+HdP2wnnGufY2SKGlc0tElwjBBQ8m4qhVeE4BTojEun
         NYcqZ8pCxzAOonUOlAO28L+J88/eqeUjbpPC5iFQXD5k95hNhS2V6VTMqgIzD7hj2Gjl
         WtK2QIqxDfH0OjDpUY9hicN1g7PXwEZu52UdMwcuXU930iV2m3tGHj06TVh8XArE7Bt9
         qeN4Nstg39QN/rdau/7LxCM72gSJTgJ4xhFXc5ohRtSG68MRI4Zh6hVd/aRWAQQP/KGU
         6P6w==
X-Gm-Message-State: AOAM53024Sdc9Xt41SXYVgufLxoAN+O+xWT5XcMNUXuLe7z2R84HiScD
        gi5iFTXO45Ekr81u2SZF4qItig==
X-Google-Smtp-Source: ABdhPJzL/bzJC/0GZFFuu0/iBuWDwc79RvZ2RpR+JFTjPC3wz1nhPclk6lVJ8xe3Uqv4ZuISsOMxUg==
X-Received: by 2002:adf:eb87:0:b0:20c:a5b5:6731 with SMTP id t7-20020adfeb87000000b0020ca5b56731mr12936661wrn.199.1652082552477;
        Mon, 09 May 2022 00:49:12 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id bw22-20020a0560001f9600b0020c5253d8d8sm11784768wrb.36.2022.05.09.00.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 00:49:12 -0700 (PDT)
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
        linux-sunxi@lists.linux.dev,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megi@xff.cz>,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 6/6] arm64: dts: allwinner: orange-pi-3: Enable ethernet
Date:   Mon,  9 May 2022 07:48:57 +0000
Message-Id: <20220509074857.195302-7-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509074857.195302-1-clabbe@baylibre.com>
References: <20220509074857.195302-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c45d7b7fb39a..fd1d4f5bbc83 100644
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
+		phy-supply = <&reg_aldo2>;
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
2.35.1

