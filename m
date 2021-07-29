Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF233DAC81
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhG2ULd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhG2ULc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 16:11:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651CCC061765;
        Thu, 29 Jul 2021 13:11:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so11126496pji.5;
        Thu, 29 Jul 2021 13:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QuibBDljza9+RanigNcsGbAD/Bl63vVbtTN8yokwV00=;
        b=KJTLA5BADvsEc4snFUUYn0AqkGNtsRftFI8d/hubfBe0MsnO5KAfuQzKkMcWrgG5jz
         VNXcs1ccs+nVVGb6/YA6jlqOxnORL1+qZAYk4abhc0SbjFcuzP1cEHJaVqlHqxBmR7+W
         MB1dun1i1H1Wg01eKdMCvBj+AX4Cv2aqVoAPE982Y9Yo6SqZne8y//+xaQmOibKRfXFQ
         lmm6affl0PS5lRD6q7Xc8U0D0In1Q1ZJE3MnAFfWb/78h0ZbnfMD0WXMwZlmkEXsDREe
         1ILX5IpiE9TvrsL6gTeFhlGL6QRP0TbXkWtVgyGCMz9CSZqMPHBheaky7EFazV11vPsa
         KYHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QuibBDljza9+RanigNcsGbAD/Bl63vVbtTN8yokwV00=;
        b=PMHAnzuSSlU7lEuHp79deuDW16NTZPtoL5SZ+mN36XasJIaGBEmlqBRY0eBBQyFEoD
         2XxC5FvKxQrnVmMo6nCICW9NoGNmOKcdFpJWD3ly3UD6bK6zOwLHY5bGA7IzenM/vy31
         Nf5ydZU8B+79Ce4vNYfbR18rqVv7o2fWXIlZ8PNNR9lzo6TZcp6FuqdnAuzsaNMTrPwO
         7l6oOkKjO32bcUPkb26DCkj/ARYFIyH6y6EtqQw3pO+V33c4jBpMLivDQdHng8BUtSyO
         RBXgU39T0jmL5tKdFPFQb2MY8Svr8tbpNhuyverPM7WIiIhbtR/EdSXYzDGDeb64DoSE
         xuow==
X-Gm-Message-State: AOAM533RSZ0j5fALxBfzmyWPir6uD7RD8sG8VIatZIh0QHKlEOIMNNuv
        f2lpWtIU284agCgGXYzmJOBRcKTmZijbrg==
X-Google-Smtp-Source: ABdhPJxFrMpP2T7mTwT1/NZWyi0QSLLwXHv3nNxFg5K1uwnPr5fLpHAgkSkXf0tzZ/xV4F5/yMLS9g==
X-Received: by 2002:aa7:80d9:0:b029:2ed:49fa:6dc5 with SMTP id a25-20020aa780d90000b02902ed49fa6dc5mr6718675pfn.3.1627589487476;
        Thu, 29 Jul 2021 13:11:27 -0700 (PDT)
Received: from archl-on1.. ([103.51.72.31])
        by smtp.gmail.com with ESMTPSA id i25sm4581407pfo.20.2021.07.29.13.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 13:11:27 -0700 (PDT)
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
Subject: [PATCHv1 1/3] arm64: dts: amlogic: add missing ethernet reset ID
Date:   Fri, 30 Jul 2021 01:40:50 +0530
Message-Id: <20210729201100.3994-2-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729201100.3994-1-linux.amoon@gmail.com>
References: <20210729201100.3994-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reset external reset of the ethernet mac controller,
used new reset id for reset controller as it conflict
with the core reset id.

Fixes: f3362f0c1817 ("arm64: dts: amlogic: add missing ethernet reset ID")

Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi        | 2 ++
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 ++
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi         | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 3f5254eeb47b..da3bf9f7c1c6 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -280,6 +280,8 @@ ethmac: ethernet@ff3f0000 {
 				      "timing-adjustment";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
+			resets = <&reset RESET_ETHERNET>;
+			reset-names = "ethreset";
 			power-domains = <&pwrc PWRC_AXG_ETHERNET_MEM_ID>;
 			status = "disabled";
 		};
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 00c6f53290d4..c174ed50705f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -230,6 +230,8 @@ ethmac: ethernet@ff3f0000 {
 				      "timing-adjustment";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
+			resets = <&reset RESET_ETHERNET>;
+			reset-names = "ethreset";
 			status = "disabled";
 
 			mdio0: mdio {
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 6b457b2c30a4..717fa3134882 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -13,6 +13,7 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/power/meson-gxbb-power.h>
+#include <dt-bindings/reset/amlogic,meson-gxbb-reset.h>
 #include <dt-bindings/thermal/thermal.h>
 
 / {
@@ -582,6 +583,8 @@ ethmac: ethernet@c9410000 {
 			interrupt-names = "macirq";
 			rx-fifo-depth = <4096>;
 			tx-fifo-depth = <2048>;
+			resets = <&reset RESET_ETHERNET>;
+			reset-names = "ethreset";
 			power-domains = <&pwrc PWRC_GXBB_ETHERNET_MEM_ID>;
 			status = "disabled";
 		};
-- 
2.32.0

