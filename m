Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65E31CDE43
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgEKPJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730378AbgEKPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:37 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BA6C05BD0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:37 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l18so11400891wrn.6
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=JIdJlCRVq/GMgbBOvi6/7vVciRUSXXPqqjgduOgvL6hA0KWWzhAvAc4R1L0GT4gHDf
         8IwpdH2Yu9XMwIwKiNXbtmKgEvK4I/GzELYFo8rR2E8gwlPB3G4Ci5J99YwzgjqqQ3mm
         tKGH8HwJEXN73O+tXJbA+hKlAPPmJxkYMDVJOuNh/sm37mW+SRwSnwEvlor8o9Rx9QEH
         hnJ+YkdjEzwA/2jbkn4zicFLDMTmRXu3oOOCdGkHMZqEr7X95rALqp2a1WUtMH+ozBxQ
         FHjKG0IMFQJ9PtkrWaR8RHbB4qXgsRrsjCCu27j+GJ5AhVxFQHMrjbOzvmhOeEw2l7cW
         +F2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=cNSFnG5/u8L+spD/FoO2tmLc8uiI1kzpfqIR0bm0wvoqzkEXCQrp4Qoz30W9/JidLH
         bDgnRMh//WbPNEQefPd9AsPu1370Grv5VXRXIUikQ0P/DhrefAzYbK6fYJhTxBlK2vkH
         Eau3kX/WtF4RmVGFwku74awlYRQgZJxzIT/eKLVyjw7+MXLqyNH68+Vm1LvDxpbzDliT
         yA+Cs2oHLHjKWbZBAxO6yBrCl4XBlKTyVC1OD44BGC/369MFRVT2JVd99+4VrYNIwrIU
         ordbY268VI2BCBhrc85D1rUxYs2Mp5cgmwxCbs2G/y9aCyJFQQT352igS7HyiUY43nmP
         zBPg==
X-Gm-Message-State: AGi0PubHD0OxqvrQBYYAfglF0IyflGhvPAmYoiqdCP2MCS9UAD8a5iRK
        84se1H8S7XKIgd6suey/uOdmxQ==
X-Google-Smtp-Source: APiQypKchqURWEOE156yp9c2Gtsg+rjBGU1OyYDs5zNKt1tBVinXwxb57TLkJavCyiOfPrG3uEzb7g==
X-Received: by 2002:adf:9264:: with SMTP id 91mr19344771wrj.362.1589209715886;
        Mon, 11 May 2020 08:08:35 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:35 -0700 (PDT)
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
Subject: [PATCH v2 11/14] ARM64: dts: mediatek: add the ethernet node to mt8516.dtsi
Date:   Mon, 11 May 2020 17:07:56 +0200
Message-Id: <20200511150759.18766-12-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200511150759.18766-1-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
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

