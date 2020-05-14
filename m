Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60861D295F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgENIAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726232AbgENIA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:29 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26AC061A0F
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:28 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g14so13667561wme.1
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=Vs7BWdW4qtjuWLul+b3IMZZZnvBlsodINipnQPxtpW/F7ENBD558mOLpTqiiVB3x8t
         hLT1BV2jrTOFkQu3nW4Su+sDY0Y9SjF1qdgjI2avlRSXBWGtoyup1WdDhscdp4FSyz/+
         MqrADU0tNfAhxW4oXxQnnKc65GJ9UdZBzNyHKLJkPr4Z8OGo9w8MMWDUQ4A8XNu8x6Wb
         O0CHpyM30xiSeFh3K4OT3R9Z7oD7u3674d9224CetXPrYmxKG4VOSQVY2jh1vT6SdQCw
         37CfB6SJsMXQU1dZB4OfcABQw8ds7oxxV9nnA6Vhw7l0QsIy+W7PrITFiF70cVow9PKS
         hQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiLRpfO6b7G+PZFXWrA65hqZV6E46x1U4Qg5U0775pc=;
        b=rebDMXSS8r5oV+Kl0fBjZVCvQTBt60Xp7Z1P3vfIt+BKEijMLBus+Mtsg4+jp+NUGG
         tK9dEvqKZErR0ddNMxXHF8b12mf2Q2HW8oZVqRPBbI2D6822F9UqUSn0T62rUKtxrahS
         BYDC78CHGy8g3TYnM9C+0qVQJLOhUESVsRSseBw+jxdRaddXj258WUAMPHOaZWsfRbqW
         Tptkvs3Sql9WfKitHinmlIeI13QNx3N2DWNdz/vjy0LskCHX+tY1zHbYxY8dh77ucIYt
         uRvEd1USfz86e6QOzPS0KOaon5b0lHUmyaQex6vQi9NuSqy3lvVw5kycUj7XuNUtRlQN
         wNbg==
X-Gm-Message-State: AGi0PuZcEgm/sFmbuPFIvh6s7TpG18RvUHcH1EDVU8E1rixpE5KK7nX3
        J2S3x65CXlCp5e8pXbRs7dc9aA==
X-Google-Smtp-Source: APiQypJbzO8pCBFuVuOAqVYsKQ0PvXVzzMvcQ4KkdS8eawJ/v7ILL6jWzMqCUpbB7Qo0NSK+v2z2MA==
X-Received: by 2002:a7b:c41a:: with SMTP id k26mr41792532wmi.85.1589443227078;
        Thu, 14 May 2020 01:00:27 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:26 -0700 (PDT)
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
Subject: [PATCH v3 14/15] ARM64: dts: mediatek: add ethernet pins for pumpkin boards
Date:   Thu, 14 May 2020 09:59:41 +0200
Message-Id: <20200514075942.10136-15-brgl@bgdev.pl>
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

Setup the pin control for the Ethernet MAC.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 97d9b000c37e..4b1d5f69aba6 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -219,4 +219,19 @@ gpio_mux_int_n_pin {
 			bias-pull-up;
 		};
 	};
+
+	ethernet_pins_default: ethernet {
+		pins_ethernet {
+			pinmux = <MT8516_PIN_0_EINT0__FUNC_EXT_TXD0>,
+				 <MT8516_PIN_1_EINT1__FUNC_EXT_TXD1>,
+				 <MT8516_PIN_5_EINT5__FUNC_EXT_RXER>,
+				 <MT8516_PIN_6_EINT6__FUNC_EXT_RXC>,
+				 <MT8516_PIN_7_EINT7__FUNC_EXT_RXDV>,
+				 <MT8516_PIN_8_EINT8__FUNC_EXT_RXD0>,
+				 <MT8516_PIN_9_EINT9__FUNC_EXT_RXD1>,
+				 <MT8516_PIN_12_EINT12__FUNC_EXT_TXEN>,
+				 <MT8516_PIN_38_MRG_DI__FUNC_EXT_MDIO>,
+				 <MT8516_PIN_39_MRG_DO__FUNC_EXT_MDC>;
+		};
+	};
 };
-- 
2.25.0

