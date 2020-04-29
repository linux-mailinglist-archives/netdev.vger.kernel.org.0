Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9FB1BE85B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgD2URq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgD2URZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:25 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8A3C03C1AE;
        Wed, 29 Apr 2020 13:17:24 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so4106420wrs.9;
        Wed, 29 Apr 2020 13:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ML06J9nAXnrGfb8Sw/sNjsFqqfba47oOWTFdhQokhaE=;
        b=I6xBJ2SgUjpuRy8PYgy88Vghn+35By2xz7BMjry77ASag5aKvIV0Qmf2JES6q8lIqX
         joPBLtr3A7Ztb/TQSlS0ammJAasQdIgPRAH9n6KVnbv8Dg+5MLX9ei/DI5o+4YgsLvjQ
         e0l//7Tok7gTPJYBjWFNKCwMX2VAfyYxxsbHmoCF2dWyNperl9l1u2w4O+Rqxi2v21P/
         vUDnGMSfqpvBfQ37f+oiepTpjsxV47f5ElwXR8L9zEMP2XwFpS4HgevSrzEs/DkOjxZ7
         1Q99zESKfDfl/IUuTPxbjD4lipMhJEsIj3HMKV83VbQbSl9DuCSGCXMrJ+SpJ2VeKacU
         ymSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ML06J9nAXnrGfb8Sw/sNjsFqqfba47oOWTFdhQokhaE=;
        b=N2vcDTRxcU/+qVgxuE0yicAghNg114Y+GuONofSNiJ7p/hISfhAeDwYBqqQiyc6zav
         9Fm38gTd0tBZhdfXgu6LuWkKO/8EWHl1KkS0F6tBVHWJgcfh1zZBMllfARcTvZXxvC1P
         /ZmpjW5ldfSXbu1uBtKEnI6BZhbvtGfew04OjNZIRy6O0DFwnP/oqnMLLj4fq8zO6Z/e
         MqXTy4ZFq086oye7ftb3JYs6kU3nya/N8YxRunBRL3YSxPIupbdWk+BFPY+ipLVA5/tr
         r3XYnZtJ/hgemTBr57a93JsaLTRtgInSg9rrvwL1waSoz9hfPXG9n4FKbDp1IE95MDoY
         Yn7Q==
X-Gm-Message-State: AGi0PuYCPR2KDLfeGlkYa+R5UtZ2P9V29Zpx67kRnvxrhhjEKhuH9L1R
        vhnzS/lB+AxRYnsKfwBJWNE=
X-Google-Smtp-Source: APiQypL/Ts+PnYJmzQA093RS5PL9mTk8d7JdiY46vyorm6USMdg0g2olx5OKhnYkn4+1TCd7ozkkOQ==
X-Received: by 2002:adf:84c1:: with SMTP id 59mr41790968wrg.350.1588191443643;
        Wed, 29 Apr 2020 13:17:23 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:23 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH DO NOT MERGE v2 10/11] ARM: dts: meson: Add the Ethernet "timing-adjustment" clock
Date:   Wed, 29 Apr 2020 22:16:43 +0200
Message-Id: <20200429201644.1144546-11-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the "timing-adjusment" clock now that we now that this is connected
to the PRG_ETHERNET registers. It is used internally to generate the
RGMII RX delay no the MAC side (if needed).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm/boot/dts/meson8b.dtsi  | 5 +++--
 arch/arm/boot/dts/meson8m2.dtsi | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/meson8b.dtsi b/arch/arm/boot/dts/meson8b.dtsi
index e34b039b9357..ba36168b9c1b 100644
--- a/arch/arm/boot/dts/meson8b.dtsi
+++ b/arch/arm/boot/dts/meson8b.dtsi
@@ -425,8 +425,9 @@ &ethmac {
 
 	clocks = <&clkc CLKID_ETH>,
 		 <&clkc CLKID_MPLL2>,
-		 <&clkc CLKID_MPLL2>;
-	clock-names = "stmmaceth", "clkin0", "clkin1";
+		 <&clkc CLKID_MPLL2>,
+		 <&clkc CLKID_FCLK_DIV2>;
+	clock-names = "stmmaceth", "clkin0", "clkin1", "timing-adjustment";
 	rx-fifo-depth = <4096>;
 	tx-fifo-depth = <2048>;
 
diff --git a/arch/arm/boot/dts/meson8m2.dtsi b/arch/arm/boot/dts/meson8m2.dtsi
index 5bde7f502007..96b37d5e9afd 100644
--- a/arch/arm/boot/dts/meson8m2.dtsi
+++ b/arch/arm/boot/dts/meson8m2.dtsi
@@ -30,8 +30,9 @@ &ethmac {
 		0xc1108140 0x8>;
 	clocks = <&clkc CLKID_ETH>,
 		 <&clkc CLKID_MPLL2>,
-		 <&clkc CLKID_MPLL2>;
-	clock-names = "stmmaceth", "clkin0", "clkin1";
+		 <&clkc CLKID_MPLL2>,
+		 <&clkc CLKID_FCLK_DIV2>;
+	clock-names = "stmmaceth", "clkin0", "clkin1", "timing-adjustment";
 	resets = <&reset RESET_ETHERNET>;
 	reset-names = "stmmaceth";
 };
-- 
2.26.2

