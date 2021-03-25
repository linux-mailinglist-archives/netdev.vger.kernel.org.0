Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587B134924E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhCYMnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhCYMm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:42:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AC0C06174A;
        Thu, 25 Mar 2021 05:42:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l76so1657242pga.6;
        Thu, 25 Mar 2021 05:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2X5hf76RVmZgnkS5Xn03sgP0gHvSiJwl9J2bXsWxbQ=;
        b=GiAMmznYYVJYW6pLsXQT82029OkTINrLmsIeyo56MBY0nVsAimf/fqwpKNkmCK+PT7
         bUeax4/5FC/rvoiDASQKherOHi34zDrnLkRu8D+/RPuM+Ibr10aE9ZJ6YzWDExcfBS6q
         Cah0JnCg1h41cbVWICBoHGWVPKtPuJArvgt6h/TZl/ld/5ljNRLChpVEVtAdQmqj/ouD
         DHeRG7G63nPdSQjB8U3LCnDnPbVym+b27hunSt4a4o0YkoYoLa0Yp7h7dBhVFXQAoKdf
         omsPG7ZmwyJOWr7hBrDXAvdWIdsDiJl7xWW6yYv5TO/YMH97cllw8OtmHFdwo7wdcFjI
         l9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2X5hf76RVmZgnkS5Xn03sgP0gHvSiJwl9J2bXsWxbQ=;
        b=glJqqWBnDnUhFdrKDd+gxuVK9S/pEa6n7LM/L81hXsrW3MQtPBpzS5y8gk+MYg9WqU
         Q4v9/6hMMbPcih3mK3VnCXoBPJjSIF8OmtyBqJLkdmtjhMflDuttAeFbTsLr4IPpPzVw
         zTabB2qmUzPw00Tr0oKN8h4hMz/oVzjeL1zlwEEWAMlw7U47oW+iQBQrrZpkX37Wo1bf
         lrg1q8Yo+252UYfsQ6SXrD+qKCrTvkIW+KDEj/5G4+ROpd+q1STFZbOvz232ZK9EDKHq
         nK77+LnhoykoLkoFu5wukTz/NJIWgATzOx9XeVqLlMwGBcaD6E1F49GE4i1gAzBYUDk+
         /A9Q==
X-Gm-Message-State: AOAM532/+F6heQuvjwi9yJQUBZP6cKt95D80gKhYl+PdLAwVM/GXkLen
        i+2A1mvQoboE9NON6OYAAiE=
X-Google-Smtp-Source: ABdhPJzl7yx6va8IfkiTv9dh6by6gQdg1/hFNrkxOXSCqm+m4B9AJjadDVA7V0kEGKBC17eFs3YaAA==
X-Received: by 2002:a17:902:e309:b029:e6:c17b:895a with SMTP id q9-20020a170902e309b02900e6c17b895amr9869758plc.74.1616676175363;
        Thu, 25 Mar 2021 05:42:55 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id t17sm6125917pgk.25.2021.03.25.05.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:42:55 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anand Moon <linux.amoon@gmail.com>,
        linux-amlogic@lists.infradead.org
Subject: [PATCHv1 3/6] arm64: dts: meson-gxbb: Add missing ethernet phy mimo compatible string
Date:   Thu, 25 Mar 2021 12:42:22 +0000
Message-Id: <20210325124225.2760-4-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325124225.2760-1-linux.amoon@gmail.com>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing ethernet phy mdio comatible string to help
initialize the phy on Amlogic SoC SBC.

Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts     | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts   | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts        | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi   | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi      | 1 +
 7 files changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
index e8394a8269ee..f3b0947b8586 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
@@ -69,6 +69,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* IC Plus IP101GR (0x02430c54) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 			reset-assert-us = <10000>;
 			reset-deassert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
index 7273eed5292c..a4c09f1af24a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
@@ -202,6 +202,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* Realtek RTL8211F (0x001cc916) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
index f887bfb445fd..abbc5571efde 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
@@ -209,6 +209,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* IC Plus IP101GR (0x02430c54) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
index bfaf7f41a2d6..4287d83d6f2a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
@@ -237,6 +237,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* Realtek RTL8211F (0x001cc916) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
index 3c93d1898b40..f7a1ffe453bc 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
@@ -75,6 +75,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@3 {
 			/* Micrel KSZ9031 (0x00221620) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <3>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
index 9b0b81f191f1..0cf4bde81c6f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
@@ -123,6 +123,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* Realtek RTL8211F (0x001cc916) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
index a350fee1264d..e652f112bc45 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
@@ -144,6 +144,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* Realtek RTL8211F (0x001cc916) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 
 			reset-assert-us = <10000>;
-- 
2.31.0

