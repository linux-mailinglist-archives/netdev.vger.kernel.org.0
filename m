Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F1F1DE62E
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbgEVMHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729651AbgEVMHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:35 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3866BC08C5C4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:34 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f5so1336336wmh.2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=Sn/1CrJlRf1gaXAt7BzExoLU8RuOHChRbTQLpaUrzwFYqGsov68ZYpiUu778e1h74U
         EG8H1AkAkI/Dvmx5QKB9iXaqQh4CeJTf3KZiOAOTno9BIiFgfkjQQ3V4IRkEH4GAPrLA
         maiOekJ94V3I7H6hUXcjbEOxaDc55leACFe7VuKpdTyg7O80elge/QfPQjJeWku+bhMk
         /BOFybbSX0X7y3Qvi81k2fAIAzdXkIexmNVingkHUbHWITInUkDyAjfPXgMuJPMXVerx
         QZT3djIizjK6MVClkQM2eCBMIBdSWPweS9uJyC7sYma38spotFpi6WHBHlfhEvvRmcPV
         FXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=S0oCn8sgLKxY8vb246DR8Sfiw2SElnNmQiru0wGRhwADuGOHolCIAWDoVHxfRoWUht
         rl1cooc61bJfHrTlM0NoHn1QKeqTaN1xIPyOrdcjvCdcQGywk/2QI49R4qDD2w/9Ilg+
         yScQ3cfHuRwEoOUbIvJVpIw/ZROxrS7X+4wE9W/Dekhz9rDmRXl/fBTsnxrrfk92WX07
         i9ni8zSqV6O2fOboxPN7cI5v5QnJlMLM3MkNiU4//i1kuWBEN77JDSYgYGtDdsCR3SKl
         c5nXvrIgA7iKiBz7vxOpwzhFDDBoKoC02AOWPo8p4PwLB7Yvzpi3RwxWwrgDtF4Jx0uw
         gjag==
X-Gm-Message-State: AOAM533VqTlpQm6870o+JCiV+tGG+e4NPEAq7oLzybdcDc1EIs8WPCLl
        yxMj0etq/9JeMP0bje/olgbTPg==
X-Google-Smtp-Source: ABdhPJy2DwWygp0CZukF1c5MDhWbG3suEHoLEk61djOMVZnj0q+0DRdXHTp94SuAfm6DtS52JEtM4Q==
X-Received: by 2002:a1c:4857:: with SMTP id v84mr13962835wma.106.1590149252025;
        Fri, 22 May 2020 05:07:32 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:31 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v5 08/11] ARM64: dts: mediatek: add the ethernet node to mt8516.dtsi
Date:   Fri, 22 May 2020 14:06:57 +0200
Message-Id: <20200522120700.838-9-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522120700.838-1-brgl@bgdev.pl>
References: <20200522120700.838-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Add the Ethernet MAC node to mt8516.dtsi. This defines parameters common
to all the boards based on this SoC.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 8cedaf74ae86..89af661e7f63 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -406,6 +406,18 @@ mmc2: mmc@11170000 {
 			status = "disabled";
 		};
 
+		ethernet: ethernet@11180000 {
+			compatible = "mediatek,mt8516-eth";
+			reg = <0 0x11180000 0 0x1000>;
+			mediatek,pericfg = <&pericfg>;
+			interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&topckgen CLK_TOP_RG_ETH>,
+				 <&topckgen CLK_TOP_66M_ETH>,
+				 <&topckgen CLK_TOP_133M_ETH>;
+			clock-names = "core", "reg", "trans";
+			status = "disabled";
+		};
+
 		rng: rng@1020c000 {
 			compatible = "mediatek,mt8516-rng",
 				     "mediatek,mt7623-rng";
-- 
2.25.0

