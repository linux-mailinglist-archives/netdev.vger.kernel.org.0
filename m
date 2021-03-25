Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D37834924D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhCYMnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhCYMnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:43:01 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3B0C06174A;
        Thu, 25 Mar 2021 05:43:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so891456pjb.0;
        Thu, 25 Mar 2021 05:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=np0SSxLTsfaMyZQWpoX2X5BItJhfehHr1tDviU+H3Lc=;
        b=m5N90QbNb9Iz0w2E4mpSUzWYoEK3lSG7cYGOMcMW6i40uvcmKKFnGcfRESuRlCRYqt
         029RJ75YMQQp3e0l7GUHDhDrATTHKROcAPMdSfwfJNSVxX7/pr0pYZ+OhsE7kZtMdRQK
         YHYuZ/aHcslFPHu1VY0KwKD6f0FSfMb4hcaJyuK/LjLWQbCvezJ/jl1noWCIkKuxzShh
         7vJJyqqmXCMk4ovy8w2zyNQJQkBICbKG/hingsjCSE+cxKriOSoTBZb73AIW3v2sUiO1
         cXkCWStHQr8paPS9dwEkoHGqcLwtRdHS7qdotkNqLhW1ybEIuMKlWii0oQSTYYxMk5oB
         +/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=np0SSxLTsfaMyZQWpoX2X5BItJhfehHr1tDviU+H3Lc=;
        b=Nu9EKoz5vhxfWRjy1hMClgXAoF/X9canerBVrQ1tigWTNTp4+oIUx5kGmSC+VIgw64
         8m45gxaeZb+lKrN2/h8AOnh5wRo5JrTbqhygNkCgjTZ3NE39Bv8Cz+rLmTfLcxNYxXo6
         DUguFc3EvBXYJjgp6zapyOHDPBbFNoLVLMijftGCE/zK6KjxjXdJgqZdqZ4SeLE5N+dD
         S0Jw1w0NZYVqe7ZbpWEazjuNcgjUPmaeBhXojYv5/BeRMhodJu+F77QxqV9kOUWW0HK6
         sPoUwfSi9ITwtMsCn7BuRTX+8JIE85FPguKHepVr0lwe0S0i+fg4eB7yzdloZsAPpk9E
         LEqQ==
X-Gm-Message-State: AOAM533d8LArznlHJx0fITtaWzsu7dJMCZHTdemM2ylSBSZiCBwAbwyC
        naS4kfpOPsNHuVxWn97jAjA=
X-Google-Smtp-Source: ABdhPJw8nlmrOvGUCqJ11kK8pHt/A0pB4F7zYvzwpYK3cTiwOCCq4fodhtdztP97FJQBavm7SBWbgQ==
X-Received: by 2002:a17:90a:990a:: with SMTP id b10mr8606922pjp.178.1616676180544;
        Thu, 25 Mar 2021 05:43:00 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id t17sm6125917pgk.25.2021.03.25.05.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:43:00 -0700 (PDT)
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
Subject: [PATCHv1 4/6] arm64: dts: meson-gxl: Add missing ethernet phy mdio compatible string
Date:   Thu, 25 Mar 2021 12:42:23 +0000
Message-Id: <20210325124225.2760-5-linux.amoon@gmail.com>
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
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts         | 1 +
 arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts   | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts  | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts         | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts     | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts     | 1 +
 8 files changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
index 359589d1dfa9..d7cfcde40fc6 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
@@ -374,6 +374,7 @@ mdio {
 
 		eth_phy0: ethernet-phy@0 {
 			/* Realtek RTL8211F (0x001cc916) */
+			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 			interrupt-parent = <&gpio_intc>;
 			interrupts = <98 IRQ_TYPE_LEVEL_LOW>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
index 2d7032f41e4b..5bafb45f6c46 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
@@ -272,6 +272,7 @@ &ethmac {
 
 &external_mdio {
 	external_phy: ethernet-phy@0 {
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 		reset-assert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
index b2ab05c22090..c0c2505081a5 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
@@ -77,6 +77,7 @@ &ethmac {
 &external_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
index 18a4b7a6c5df..7cb834dcc91b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
@@ -229,6 +229,7 @@ &ethmac {
 &external_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 
 		reset-assert-us = <10000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
index dfa7a37a1281..abaf58b7b765 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
@@ -108,6 +108,7 @@ &ethmac {
 &external_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
index 8edbfe040805..1342ca285d44 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
@@ -59,6 +59,7 @@ &ethmac {
 &external_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
index dde7cfe12cff..c96fc23fd8f1 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
@@ -110,6 +110,7 @@ &ethmac {
 &external_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 		max-speed = <1000>;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts
index d3fdba4da9a6..a99a760f253b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts
@@ -32,6 +32,7 @@ &ethmac {
 &external_mdio {
 	external_phy: ethernet-phy@0 {
 		/* Realtek RTL8211F (0x001cc916) */
+		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <0>;
 	};
 };
-- 
2.31.0

