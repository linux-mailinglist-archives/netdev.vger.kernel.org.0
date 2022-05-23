Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741345308BC
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 07:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355634AbiEWF2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 01:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351157AbiEWF2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 01:28:21 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9DB13DEE
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 22:28:19 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p10so1009261wrg.12
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 22:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kwRG8kJghq1J9woEQ8/8+NXh3AtgpEI2TuVWVjMfZMk=;
        b=0HpAzyrF8+FK9s9Lv6r8HnmS4n2VHb3e9NI+PYcrMI8MijK0B5XoHtXRkv0pI5tmky
         DTvP09m+Llj+BF8ipr7By+iseFMo7gGLtq7vYu96ZGeSz8zR0CmdFjxa2rF61Q3PyTwY
         5fEIB+1cjJNCHPS/dqw3StWXVMUIT3lUwunNjpKiEUWCJwQHOQjt+RFSK+miW6Z4zbXs
         MWvJvH5fNK1m37DX7lV/wbjEtMDmkUVmoLJADDbcCKXYidinq0Ke37o8BrAO6EZyFLdC
         sFfsslVnXtIGNMmhcoHGHRzHo5UgF4kTZ2ol6Bar+kuhYmFZ4qSF3OhS2bQXw91eRaVo
         C3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kwRG8kJghq1J9woEQ8/8+NXh3AtgpEI2TuVWVjMfZMk=;
        b=rAv23qHzFLNPbGXWYX5SxxhvybrpCVDRzZ7qrxjdyUrGuZznEveDOHp6zoUy80tA/T
         ea20w76JPlPfHXXTyquNJhFz5NSIJX3b2oqjv246eVCZZOKpSiJKsFJ/2rI5uAIIefGD
         krqR2pvZT3uGL3hfaF9tSeKZcv5nYbxeSNmQtwrnHet3hDUF7Lz85D+uY5aHbLyoRKkB
         ViY94XNyMsXzIDUdFP3C0MRMYhtBdokUeN/q4ZRMb41Uu5/bBKuSBr0vKRDt92KMlwhe
         RQDXgM3Bo5lvofzmy2yRFrFKVCK2z/a/3Uad0Dc6sGEB7HK4YN/ZgELffuaasMaTBHzt
         F/tA==
X-Gm-Message-State: AOAM533o0KozZOy9DTz1dSVi83/p/93c+VDmHysG8Cg4iXz4SNOYdOL7
        +FqYDKSD6KF/7cavJugdErQEQQ==
X-Google-Smtp-Source: ABdhPJy4dOiHRi8RxJS1vDYeuYztM8ZLIeJ4Hy3+HL2NtCowcnxhvWlaJf6kQexvMGXqL2AAqtP4hw==
X-Received: by 2002:a5d:4bd2:0:b0:20f:cb39:c035 with SMTP id l18-20020a5d4bd2000000b0020fcb39c035mr6890506wrt.709.1653283698116;
        Sun, 22 May 2022 22:28:18 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id h2-20020a1ccc02000000b0039466988f6csm7802414wmb.31.2022.05.22.22.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 22:28:17 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megi@xff.cz>,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 3/3] arm64: dts: allwinner: orange-pi-3: Enable ethernet
Date:   Mon, 23 May 2022 05:28:07 +0000
Message-Id: <20220523052807.4044800-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523052807.4044800-1-clabbe@baylibre.com>
References: <20220523052807.4044800-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index c45d7b7fb39a..2760a0bf76d5 100644
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
2.35.1

