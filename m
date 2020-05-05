Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47E1C57ED
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgEEODn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729369AbgEEODR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:17 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8DBC061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:16 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so2911962wrx.4
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=cVzH1dPGpMqAXPxKb2+d0LSY7/HTueVOi2Sdclc1d5WFXroNiTnCGax06ZRUzUzxBC
         BUh3y57hEA0QKHn0p8LMuwuIGxUcGlnDrT6dMvKvVo8CknIBmfP+WtMUK/RXkzf+hQAd
         CG7wMuCkKOANszSzqBn9jqXq1Ze5auYS7lGvNg5z+nbF8yG827NVgpPaFCp8YOAnKKI0
         h6VO7RNUL3pV+so74edRAnGDHHHcdwfPC6u++KxWTUZe+FCdgfTpNkF93LmwoywsYj/K
         gYxW4eQvxZ3fbG8FUAlWnbR/kU00rYU8f+Gn2FKmBkWJv/OV0h6bhhfiL4fJ8mrEn4a6
         vcng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cLB08H4ZIlTMzvj5hInDPm3tTNq7mk/XtYoMNSk6v2w=;
        b=WEuLxz64xomAnbwc6dXERoS7dcXLIK4FPRpB5iGhKYVoYVp1Nk0/ZPyJ186n9c94EW
         NVilrCQBo7F/pXOq0ovMXv0w+b9qbWbsmtX6nkkREcYcWFp/tPwkczGspF9I1Kvixwcs
         sUVwh59ewrCDIONo9P6k3ncruQ+X2AaqyUPpZhJPK5sxYCZhIu+NK2UuE9by3+lwDZxH
         oasf3cHvXUGqwDU1PLppkZDUGjkxhPvzwzEdevj3ubEOZodYeJnVAiPiaMEs1vHV13sL
         gqjLd3m0bLY5Ld9V6sBZ4sd1emCLt8+x/Az3jHc4ihAkRaDJ0urNre0gb45j0GJ2e72Y
         jy/g==
X-Gm-Message-State: AGi0Pub+mvweqAabDgn9mNrhgNZ7Wi3yiIa4tp0xQOKMN0hbjhQLJyxi
        ird/mbzgk/9pfcURQN9AaDQErw==
X-Google-Smtp-Source: APiQypLYiuxJLzQGcByYdRNRqjThYrVDv5Mb46r0e9HU0s7k3vsW2WSb3TSlR7LGVUwNfPWr1XlEkg==
X-Received: by 2002:a5d:4043:: with SMTP id w3mr3951385wrp.266.1588687395284;
        Tue, 05 May 2020 07:03:15 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:14 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 08/11] ARM64: dts: mediatek: add the ethernet node to mt8516.dtsi
Date:   Tue,  5 May 2020 16:02:28 +0200
Message-Id: <20200505140231.16600-9-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200505140231.16600-1-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
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

