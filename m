Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090311D2956
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgENIA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726232AbgENIAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:25 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937E5C061A0F
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id m24so19557104wml.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=HEmrcvM1MOsX04VShtRQfw8wX95eDldjdaz2ns3Yi89VAbdiUxlVX87C6nzdephlup
         xHJMCz6e0Z5r01RY+lzPy4wHor8E2bIsMkvwpFAKFaBcg96Yv1a32HR47oaX+TXsTmxa
         tZ7BQztG8IQr3XPcRIMaWryF7+6ihgGVZH91ZuakknnofVFjDvamLmrgqsjevIBTIecd
         D//XX+ZSlcunyYyK8Qs563ju1w+pRSmKcL46Gx+DIpsLzRGBl4u61KIqVfRWAeiKOdzK
         G1WrNxSeiQ3W4YBBAZ1ChwL/wg09tzntcjmSjs7CEdvDYc5GX+643Ls0LEsYi8J2650b
         emRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=MbiOubIwSHlBqwOE5S1uy9licucjlHA4/E0dMNk+V8XKgqmV0rjElQaVDncsPTur9q
         pnnALri/nNRpl3iQJge3xzfzm6lEXRUFZJEyQPZQwleWjPycuot0aWh3aqKiIX8dfroc
         mRznOKBcdFaz0QE5jTh3CcskQsnyuQdL3Zp2N3XhR0OO7sxpXg0FIjXpbXX23EAZ9m4N
         xMGZBTK8Jq717PXCfj36bJqkKE2oERIt/EgOZSUbtxMmea4xfyWyu7XyscuXmPOyD5ex
         azn5lNHuv3vwxgFjnSG0/l0FgWPEFbU/8LkMzUJ6QCYXBf5lrDRUgZFMSzM5nHpuh494
         jsMQ==
X-Gm-Message-State: AOAM532lyQ3kXgw429UC+/dAbMAluehbnA+57cCBjSG166iqzM7I/xz6
        +SXr3P0y5CPezHKLCE6JEOYxWA==
X-Google-Smtp-Source: ABdhPJyVjd4+wt6kvtuaiL+tPilOBT+IL6rIp/TSm7VviUo+tkETpkHnlzpF7kAbFINWELiacsGnAA==
X-Received: by 2002:a1c:3206:: with SMTP id y6mr10610900wmy.12.1589443223305;
        Thu, 14 May 2020 01:00:23 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:22 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v3 12/15] ARM64: dts: mediatek: add the ethernet node to mt8516.dtsi
Date:   Thu, 14 May 2020 09:59:39 +0200
Message-Id: <20200514075942.10136-13-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514075942.10136-1-brgl@bgdev.pl>
References: <20200514075942.10136-1-brgl@bgdev.pl>
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

