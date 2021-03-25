Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC16349251
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhCYMnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhCYMnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:43:06 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C925AC06174A;
        Thu, 25 Mar 2021 05:43:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y5so1958967pfn.1;
        Thu, 25 Mar 2021 05:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ewEJiuUTUTiMPuh5BO0z//1JOB0w6fbG+bZ6ErXDulI=;
        b=qxsKAo5K6SnRq8s5y0PaFyRkSEBUVeFNRHgCPA+XBFsLd0SY2+zXz9SZMVcaOVnQ4r
         P/TPrYY6YGGlT4riIQV0a7TBaeWlave+J6OCYL1Y9qHjJ7ixoPhX+nCbS1WtXy8XknRw
         GuobUlCyeyUG+PTsBDZdEMMYKA3OzWb/iwuV6515cgH7N0HUFyG58Bm12pCGHRo2MOuY
         o7b4cQnMzypClW3PwcnPSflZER157BM7jR71UiW9PNgl1AWVtrIBkeD1kDDbhgbrjmEt
         iQybUnuIOXIFzp+WDHWxAPiOjkrs95ofJd5o6GxGFPJ8/LLIxfoPiMEBAENp786oABmu
         PxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ewEJiuUTUTiMPuh5BO0z//1JOB0w6fbG+bZ6ErXDulI=;
        b=gY+zBODsymntqYB6esZWWhZzBQcTs/4c4bVXSn220F4AHlQ94pyq3UIl1BiRXL9hk+
         eYgbdWZLat3oyYImAk46TesnREE4uEp412teiFzqGVCtv59bl7AZhIDnIm8jQXeS1VYv
         h0MH8wg6cvrvULN+Lo0NumHsBF/Fmi5WIugnU/Lir2I+QyJh8P3eu6sbGV1ceg/EyvBt
         3m0nuJqrLUWfIZDFTvkHSFVBCYngWh+riWVBV2qrLUYh7Xb+ndGTSQNV31cQMuyV9IqK
         R/MeNNnqRKHjnz7Rd7PrYHv/RiJ5IiNkG78ppvFXuyDYmw6GZjl0ysgCoU1sAQLpbHtg
         WAQQ==
X-Gm-Message-State: AOAM533BOSjnNbFSQV36zdHeusLT52cFUhDwgochXBMif0V8DDuRma3g
        5/zO3D/49XwB81KrN3u1X98=
X-Google-Smtp-Source: ABdhPJw5fm7m4uyEDWOOW4A8Qp1oFNL4AVVvqXdofBzw3DiUHKCyBr8ExRRshq7tvxOKVvkd2maKOQ==
X-Received: by 2002:aa7:8187:0:b029:213:d43b:4782 with SMTP id g7-20020aa781870000b0290213d43b4782mr7870651pfi.26.1616676185407;
        Thu, 25 Mar 2021 05:43:05 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id t17sm6125917pgk.25.2021.03.25.05.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:43:05 -0700 (PDT)
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
Subject: [PATCHv1 5/6] arm64: dts: meson-g12: Add missing ethernet phy mdio compatible string
Date:   Thu, 25 Mar 2021 12:42:24 +0000
Message-Id: <20210325124225.2760-6-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325124225.2760-1-linux.amoon@gmail.com>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing ethernet phy mdio comatible string to help
initialize the phy on Amlogic SoC sbc.

Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts    | 1 +
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi | 3 ++-
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi      | 1 +
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi    | 1 +
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi     | 1 +
 5 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
index 579f3d02d613..32c99035a18f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
@@ -335,6 +335,7 @@ &pwm_AO_cd {
 &ext_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 		eee-broken-1000t;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
index 58ce569b2ace..12f70b38ce67 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
@@ -410,7 +410,8 @@ &cpu103 {
 
 &ext_mdio {
 	external_phy: ethernet-phy@0 {
-		/* Realtek RTL8211F (0x001cc916) */	
+		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi
index feb088504740..cfb89f5e6eef 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi
@@ -260,6 +260,7 @@ cvbs_vdac_out: endpoint {
 &ext_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi b/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi
index 877e3b989203..4d4a5d467bc7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi
@@ -273,6 +273,7 @@ map {
 &ext_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
index d14716b3d0f1..5bdbf0d09bc0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi
@@ -253,6 +253,7 @@ &cpu3 {
 &ext_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
-- 
2.31.0

