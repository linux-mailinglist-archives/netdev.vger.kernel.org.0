Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7009E1DB187
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgETLZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbgETLZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:25:50 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3530C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:49 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t8so2814851wmi.0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=DCTR0x8TJBa8+opcAvlYBjrh/vCYQMQoQ3RQ14CYFtSRQpZI/qhI4oIh4w0OI3jZxY
         lUOXz7W+Pz6EP2XZ9uKzLEWgEH6gMU4ZNlDHEeOk5LmpYDOTtu19/ow+Uwlh5LBJZlgA
         vze8VuncLa9NqJBxeRh9BoF6r/IyN/fJQ7/eytgThQv2cbdvbG0e6Rr9ZZMfGKx2P+zQ
         yUmZmjfLffCCnwhOJ2L9/fDLMJtsbDO0OehqMKyXxypBkg7w5SuC58HzlZzSp3c1g15c
         qkyU+xehJAV9meR5oFN4BX2lxYb1JrUCkes4m9UtJFVNZwHqMFRNHnCgzNKwrqTzj0lL
         B6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZF4M1Ryr6CWnpRgUMWuRsLTKn/UHmWXZ3+MZTEjA0A=;
        b=p04tvCERHfoJrxjNmPAWzYyHMwb56hJE3ofjtrxRJ/xyvqrE8MX81GskKTOm72uQIh
         F7rD5HXl3YfEuGx4pTgHw2KxtUOUZD1B8wQ92qk5BfqcNv96Vlfp2qzaCtQzHd4remzh
         f7/sTqqTZWIuXvy8vOjrRzz4DVXDXRvo/9Ti4IeE9mKxRb3GSHPyvNIgaOqywXLMCT2z
         dPXcseZuUcgAJqSckaZ3ozH2xeDoZtkp6qs2gmaWbJTT9i5gMk8I3wRLuAptR+MqzZf9
         O3zlsgvgYHgsSGVuXyhs5z7JZTvV5SxE0tiUPazmf4qKtTcQZZGwClEdA0yILqRK4eu5
         yQTw==
X-Gm-Message-State: AOAM533oqU5XAfBLdl/G7+QlXbiNUnnJwQVsatqbI4ACIGD6b3rcEXaV
        +UrDln2KvoQLz3LhQ8zz9eu0eA==
X-Google-Smtp-Source: ABdhPJyxQ3juEFptHcCtPg6At1kWItPyvN042bhzhG99WFO1SSzV77tG4mYBDeWML0N22iIOVzKg5g==
X-Received: by 2002:a1c:6706:: with SMTP id b6mr4265142wmc.54.1589973948657;
        Wed, 20 May 2020 04:25:48 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id v22sm2729265wml.21.2020.05.20.04.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:25:48 -0700 (PDT)
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
Subject: [PATCH v4 11/11] ARM64: dts: mediatek: enable ethernet on pumpkin boards
Date:   Wed, 20 May 2020 13:25:23 +0200
Message-Id: <20200520112523.30995-12-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520112523.30995-1-brgl@bgdev.pl>
References: <20200520112523.30995-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Add remaining properties to the ethernet node and enable it.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../boot/dts/mediatek/pumpkin-common.dtsi      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 4b1d5f69aba6..dfceffe6950a 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -167,6 +167,24 @@ &uart0 {
 	status = "okay";
 };
 
+&ethernet {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ethernet_pins_default>;
+	phy-handle = <&eth_phy>;
+	phy-mode = "rmii";
+	mac-address = [00 00 00 00 00 00];
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		eth_phy: ethernet-phy@0 {
+			reg = <0>;
+		};
+	};
+};
+
 &usb0 {
 	status = "okay";
 	dr_mode = "peripheral";
-- 
2.25.0

